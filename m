Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEFB60A6F4B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=q7LA20K9
Received: by kanga.kvack.org (Postfix)
	id 77CBC6B0636; Fri, 13 Nov 2026 03:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E026B0638; Fri, 13 Nov 2026 03:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644476B0639; Fri, 13 Nov 2026 03:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43EF16B0636
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:52:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5180DA02B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:15 +0000 (UTC)
X-FDA: 85429479030.04.C1B20C5
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6EC2BC000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=q7LA20K9;
	spf=pass (imf22.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559933;
	b=k4csj6Yy8pL4ufFPfP4crVRGsZmEgpWAnZyshhHV7lC66zFo94uakpeTID59VblxI6Rabj
	bDKB52BXX1hFeA+MuK8whlcZiyAUHC3u1wk1MXScrjpKCX6y3Qh1FrB1XpVoimltn2h/ik
	yqhDdrGq7T7HcAFje5RX533OXBih2v4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=q7LA20K9;
	spf=pass (imf22.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3YUrGXSXKZY/bSJltCtfezd+TfrIG0RukF4uztH5NA=;
	b=KKET0WOxPQXXye8v5P8VOt2wVXE6uBunF5fSu+vtDO/tj6r3zd3odTI6dTYD+TVpC3z3T8
	CPHQzzoYayBr8fv5r/Q1uK8pgdgJ2JDNBKVjRAvpOMJqgM/hHDHorpVdKpLg72bdYdBKYM
	plVzwbVCL7ELAD/+a+WTjQv2hGRuazo=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3adac5b29ebso836935a91.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559932; x=1795164732; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J3YUrGXSXKZY/bSJltCtfezd+TfrIG0RukF4uztH5NA=;
        b=q7LA20K9JlZ7DvapTo67GjMtmE9WwF35iJkO3BFTgZG9e1yqHnATYSrroFj8GCc/vW
         QYvqIdakCvvN3sL+RvAnp3rD/i9M3TgEV5HNW4LszzDUyXoRYlCda7UAM94r7Gif4ZKt
         lxcp4iLD3sDs5Qmm7AiSOdw3BxBIeLcvkbLO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559932; x=1795164732;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J3YUrGXSXKZY/bSJltCtfezd+TfrIG0RukF4uztH5NA=;
        b=o3LhDSsKwJJu7qXBjVmNuJ3Tar+C7Zt2G025q6xLUSzSgU0gPwOCJHra02kvoszjft
         r9OZrYAkTory9NXgGpX5My7eD6D2wmKRlDo6M3Yi3YaCovKkWccSNXD3R4CTlmndypjt
         P523fpS6DqBEFxjQ1yQQBBRzrFp+VoXO/E2fbzcKKFHDxYis9PDmAvOU/hYo1NGyh9jC
         viM7ld1rQp5YbpunFJ4Qb70+1eAPFQZDwjRDL5t79ty/FO3ESQWdlTwtMwMWAAnb6Fkk
         reHUTo3N6+idcWT7EbEYqXKLAhSeGbnw56OcPcuToyafSCxDtNLSArcwdxSHTjDAqn6z
         WJOg==
X-Forwarded-Encrypted: i=1; AL+hErG56vM2I0HdNMsTUUKNH0eED9y0AojrdOv3EoN8R3eCxofTD3GaVBLZCwzHNl60vA1Z5DW94JKuYQ==@kvack.org
X-Gm-Message-State: APuU4Z/8bIqO/IdjwF61egsfiSxwf+iMwXMF4bkKVE4SIYSesj4zdQcL
	ys19DYgBwul538nQKPpxO8jL5RQ3z3VNKWh/0UmCt8L7AJiUP9D30oMZI8cSUNRy0b8=
X-Gm-Gg: AYBFou11VDYGcykoj+opRYRvQT2QqbobFMpVbFVcy/q457r7D0fzHGeskeC+RIB0upz
	c5xu7JqOgGm2PSkNws8c42vNpOHLq4Cpse0qXPF6++4CbpBPZul8ABoRd3ZpCpUkmM1cq9g8H/d
	mzee3Ee+AKKsysHrlpr6JqszDClBTXmR6DoMk6MlZVyObJBuGEKaq1SsiSS88IUNtKhZlVRycf9
	je8/yxdp7hreHEB6dUAeV93p+qH3AKiVAV2HBdXGKHeu7U6S9qlYCx/XvbWczcda6i5ZKpm6vPc
	QpeRFBoCjpha49kt+MpIt1gT1jr6hrl4JOU3J0G+qhj1+MQyOJJzzZWXC+CmpjRV9r9pjnRaafF
	+nPBeXUFi4+EiH0o+ftCyiqmX7GBzjF5wGElFIWvYv63pitCMJQ9LIGscvvu7QfVwAX8EMqKIpT
	xNYMNs1TYCCQRcdhBMtyrpCyoj+isen0fZ2paAmwsrgSaYVum2IUTAsyZ5MedKIaiPL6l1Byfc+
	htET3JcY1sQBNdoOC/F5KCx9tVTHLD6c2jAk+mtJU0VnDsGEjivToHANgW/L71HXjqZCV//l/AP
	0OXiDLGYhDC25JQtSjKno0Sbsk5zlKSUgqfzcmoSfd29GfBq6z5x3lpxkcA7O8fDlAREvooq6r4
	Gt12a7wUS5gehic/WTqMALa7FT7kPY0uSlVB/tfvLOqsKeKSIxcXaqtWOTB+a/RGI+dQg+bounR
	UANd1nOzWdUH7IgKp/0KsmOknGJ8ipbL/IOUD1l1GD25cDORSm/Zla8BLU1K3Mx4I7sCW487NnH
	XsrQz4G
X-Received: by 2002:a17:90b:48ce:b0:3ae:5572:c4e2 with SMTP id 98e67ed59e1d1-3b1b0a4e8aemr1576928a91.57.1794559932319;
        Fri, 13 Nov 2026 00:52:12 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d35525sm8662027a91.16.2026.11.13.00.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:52:11 -0800 (PST)
Date: Fri, 13 Nov 2026 00:52:05 -0800
From: Chris Down <chris@chrisdown.name>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 4/6] slub_kunit: Add a test for the slab_buckets boot parameter
In-Reply-To: <202610302117.74D1EB1@keescook>
References: <cover.1793253633.git.chris@chrisdown.name> <47c0b11109203640122a9b5b030d3f41bfbac609.1793253633.git.chris@chrisdown.name> <202610302117.74D1EB1@keescook>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113005205.440863a59b460786@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EC2BC000B
X-Stat-Signature: bhhqpo7brfxk1hcktfwiq7q7wkif4p8t
X-Rspam-User: 
X-HE-Tag: 1794559933-976723
X-HE-Meta: U2FsdGVkX1/y2l4of8uREzEIP1R7IzoZSdM6AoXjj++qY06Ggoii29iWA2vVaJ89MEyBcbkNUd0pExgI87nyanabjsTzzw5MvEy4FJgLMRnGql3P+ytsgQiwguMjwoMM8WFjdMaqyN7hjpKnAeSBk6ZRCBOtV4Jp96KDxVTUF46PGzrOCRpJntnZnk9zLK9/YzwQRl2d4nN5FlMqTAMHjVWCGVpeeAt77Ouqq4iOcb1iMKerJyrj/pQ5hnvXcfQxCCBs50BTt/oGo9gwLpGX3c/Ihqh6J+QBjZgH3Q9UxRH1wl7WOMRgcCuwKAY9+/hPIEQS5om+CzUEKyitIVwsyFWu0KSFVQDA4lqp7RA4+T2jv2RbXgcGQljecuhJ2qfuTZto+foa+dSfDpcdq1WdBJv2adSybv3lNbdOqA7SqiiQytgRhET22dNgctYPYrwnFZIhImuC4odm5hTFB1NtN2RtuFh8f7Fc6iPWB78GX9mmIzAQQWM7nXkmfZN4453JMbogb1IefM7ePgWzFsk+w0eS7nIXwC2mTmCOaDQq5XKdfIWReip9+IvKyUeEa1x3enK2Thz7L2PE9/KmJ7yEnvXPltvh18Gqm2ZxJbFfgQmxYT5ggWYB/Jy4jAFwO0+ko1fNJnL57/BQBbBHURFk/ytsvTUzzPofKJYyyfUmEdMPtCbIEx2ATcQBfMsyLwAc8VyMXEQuRYMMJwiNFFIumib1DhJLKF6W5NJUsLhHcUNc4t2UXfhGUDkXTwOHNPjJJNqfgOmw7jSOU3vmoGKVj5bN9oYE9JszRCHGgQv9Wtt7omZm+1ksXRwFPAyAVe1xrpOyopdN5bTVVk7lRAhro04lq8QspOMrJChBh3YEATEXLvpFHbRei9hiWwXIaZiMSMemNs1P9FCel3/kDT/yrScWSoHGEfpNTznZPLzf+P0ycQ15MwJWXcLXKkzWJg0Xbu4AUtDlMOwI/Mg01W8
 E1zHq69w
 C6bGMBTfON0Y+daRKQtBisUea2IyY5NWnruUYc+Ap+NMTGwxMx+OZBbH5w7/kawFCUx0Tk7IZnuZQQlqomDfbi4AKHY1h1l8TREATU7dwswpNvPkcW2QggEs4f1HKi1amX2bxbajvCALQINRpf8c2MD1jFjN/lzAJ7y5YDrpbSVncvhBWRz0APrbp0ZdcS0Rb0bLPR5P81jLWz7CzmgUv8Fb7QVNfFlE0ubq4p3bQnTT61E2rS0WT7zDmR1/a0XDEvOLy7ZgfYJILMHQC77KQzpE4fdBLiCekKW5HWpBssKhTFHFgwc35icIURNkyBdmNkD49G3DBvKxeE9JtzrTxcSCQe6pATmguqF4deaCXnWJRzUI8B5Twc1Vvo230LkKEkvs4Q1JQBxjxKrWiiygHSInQ/eZ9SBAD6c1NXW0HuYs7AFNNoUCgw4qUGWOpQQYrStwMRSMvlqG8cIyicvJL6qjnfpuDLpONAuRSPgo+sxL6hRb1ta2hl8tsww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kees,

Kees Cook writes:
>Please don't ifdef to drop a test. If you have to do any ifdef, use it
>for test skipping instead.

Sure. In v3 the test is always built, and it calls kunit_skip() when
CONFIG_SLAB_BUCKETS isn't set. The kmalloc_partition test in 6/6 gets the
same treatment.

>This feels messy. Any reason not to just export it entirely and avoid
>all the ifdefness?

No good reason. In v3 it's a normal global, declared in mm/slab.h
without any #if. It's still only exported with EXPORT_SYMBOL_IF_KUNIT,
since nothing other than the test needs it. kmalloc_partition_enabled
gets the same change.

Thanks!

Chris

