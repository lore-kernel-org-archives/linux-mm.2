Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED5D8CC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4EC6B0092; Wed, 14 Oct 2026 16:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55DB6B0095; Wed, 14 Oct 2026 16:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B956B0096; Wed, 14 Oct 2026 16:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 953BA6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:30:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C60A160715
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:30:52 +0000 (UTC)
X-FDA: 85322375544.09.7FD047A
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 484DE40002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:30:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="mrp6gY/4";
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792009850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJ6C0cQbZi7DUkbDV+JTTS7gIU7UG7fhtx07+1Sej4c=;
	b=DJ4UBInTBJT66sRpgn6eybkUTP3r8rnlDesqvQ0I6Mzr0Waf0EFMVZwx1YnByhICRhCYcQ
	+iOqIuy9niCOuLMi6/FClWK+Xg7ZGS+lv5HHrWZyOiYN89zcv4BssKivWHrOlMk+0Ayfw9
	ZwXvCRyaargBvuxxAwE6Li0nLBk75UM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="mrp6gY/4";
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792009850;
	b=MyP9GbA3p6fyiZX3l9sKZ/CwytulpKCbm52Ovg2xFxDS5ItCYta08AS+hQAPQWNALpLPtC
	BJlLDKBFyI2CanE3fpYwH2wkLnPd2pQbHs3g6Ob4aSphTrCXIfolWZbnJgyd19Tk0HB0F+
	K4RfXUXG+ZAqr6gdHj1PPiAe0/b/L2s=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53391022dc0so51465901cf.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792009849; x=1792614649; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jJ6C0cQbZi7DUkbDV+JTTS7gIU7UG7fhtx07+1Sej4c=;
        b=mrp6gY/4HM8WSTAb4HhS6hm/l6CNHeTvE5HcxU90eQbuaRoPKpfHMIrp0aC6Gb8bOS
         q/LCj3JUVxGeQ3mdD7uYTWlFPWKxi1GR8tc55O4sY0xkxCyDBcPw0o73CGcCXrEM6eCg
         Vqa0n1fRGEw1yv8o6BZNd1BvtZpEZuZEHg3qdSDPOi3q7jp+CZ35gOIj9QyFg6yYDMUO
         v++3yvadU6BQshT92hsJh3JvWxRdTS8cmstZY8szQAMH9ekgnrV27m+ydqgfPcAQsPhP
         UMmpIsjMMMRjWYe3QqduTfaAXRCoJNVyF+3Vr8u2bxXjKSXLjJvoe9dHMC5zK0Vbw1XL
         IQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009849; x=1792614649;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jJ6C0cQbZi7DUkbDV+JTTS7gIU7UG7fhtx07+1Sej4c=;
        b=exeLEV3UyY5i80P/1/zFjG793rpgBP4g72VtJBwYvxkQfRdm7DhOXWa71OV/+vfLA7
         kAg1CcB91RNr6zKtbf/iNJpIJCfYnBzqqYkJZUep9F3UsHxPn9EioDpRex3EuzKb54ZD
         N0lP8MZMXs43S2YfNZ8ZdgREZweO001su9ZSpOo6a+oWfQoJqjOLSrJoy2fsIPP/tOEV
         i5/dJThPCvaNtF8MJjo0g7b+T4bcXSox2f+5pS+iCJgCOqkW/c6J2ZDuzytn+POrFJaU
         AbxzbCrMQSXdGCA8fS0xfqbCCxRlgmjZxp/zq3vbF+COR5T/KtBbO/FV3Na3iSx8Qvfr
         ktbA==
X-Forwarded-Encrypted: i=1; AKwUvBwE8+NBu46trCwhBacV5SokMu68Y1SB6GZhbtzOMfnGYQDx1u5nn36b6hL1aFb+oXfxZZoh/4M4tw==@kvack.org
X-Gm-Message-State: AFq9FYKtba0aUES8RBAgw3tDdBXsJGTGerXKR9VGudB06/3o3wzwplGQ
	MkiM650r52ypH5LlpAHg+pHW1C/wRwmT8SNiXLQKTQRqds5eLIDJ9puMdHJi0/QXd7U=
X-Gm-Gg: AYBFou3OyXcdm3Uznoc3sMgrIe6rFsIlLDU08AfKQUg7dWksn/tJ1ZtaXIyV9bQxsVC
	TvfNVgI9ZJGBLVcWHt5i/t8MmBDzxUcOoEAn14EbAfRjo2DjAoVKxP1ibMxaXW2PMM0rbiO3b/x
	bO5T+8j+4qhssjtKr0i68sAAD3N5gq4f7KtiR+23YJmIqMM9/qbDJ2k9xF4pcC3m9PSjXAsjyyR
	caHFeLyLw++BpoluL4M+Yemd9Lxdwr/FzgFyHjkksFHrTksxL1BckzedbTrikwgD6mIShnRd/X1
	POVWdore0KrAFAQwqepGiJy7IvkioITHBGQCnaYyR4tcCLLHXcRadf7AFZqktUpKKM3lbsYyXcz
	UeqFRAaSwuYmuQSmaynMXdm+8ObbIojcCdL7xwl7IGnupe1zbn7eRCWEneZIcYLsnt3lKe6LLQ9
	VwnB0MhsXjC3/2zt+KR2/ruOYChtpIuHTq5NTauZlwGhO7o82tDB6xXcyAYR2UOC+cRUhE
X-Received: by 2002:ac8:610b:0:b0:535:1b18:20f with SMTP id d75a77b69052e-5359fb287e9mr250799621cf.29.1792009849141;
        Wed, 14 Oct 2026 13:30:49 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97bce2c5sm61949726d6.36.2026.10.14.13.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:30:48 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:30:47 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Message-ID: <20261014203047.GE371161@cmpxchg.org>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 484DE40002
X-Rspam-User: 
X-Stat-Signature: uzb8koa6ozd5birz7qbqtqmp1z93pbzh
X-HE-Tag: 1792009850-958459
X-HE-Meta: U2FsdGVkX1/Yu4kZfsQzJBCTDpGWdqlAPOwHIahMXW07h2p23Om5kPMxkmmUZgX9viuwF8MgvmTZr5ORYReFzQoGEgIQm72WzJvxLZHm+bwF6a74UXxPcafBaIdiofjP/jyhgyO92eH8trm52nzjn3vokc7fKlJVMU2KTKgWFLLHLQ+cyvdBiB0K1ncr0XLPzdb0hAAqNx19j0sER0+lFTfb/PliJtKNWXSRg3IZ/RT/F5W+d5VIUmUlMmOxEAnX9MgixxBxIAOBt8+El7k0HxFZU9yna8C+s/a/T9iwAdD/tRrre/M/9LcdyoIu4hrVYQZtvYxp09z3UTdgiZN0kXhvTUFjWrfhdirBC9JKG69J4NbPh2mU6nGSsH9ddrSOnruzsL9f4OJF/XhcwhA1z/VI7siD5/hafb1PyGV6oiromb1lY5k2e+h72KVct/Bpksq0Z4QD1MjXqLzU9xpTyX0VQEcbpVrNl70rGm1liCnVZM4ydWt97Cnejm9maanVXsffC/TJWdTTsJPziVdEDaBlX2HEIOpPHHUcMIdHjkOwG9U3d3VXfv56rPG7lDR8UY0UYUeahXcjGXKPj085TYqtwvyHR1qR7Z18er24tKwCze3pgufQuZKlbJQ3ppATj56tdk64cdHHFxvsyRHHsilXS4aebBAK3xwFbWULA2NYedtGzAg6dY29S/sfex3x6x2PPCVC/9zw+aOj0m6pAyRUxIdopIrYc9rPCcGNsjm/5ktjLnnRsTCKEkQ70FBzah9i7JAVa+skkSjhWkTkRIxkbq6odPnH5DfQ86LoJrWvJe8ShZg8+1lQBoXgGTUJZSfTW58P5IyeG5StPj+s5Q98yK8X/fy7meXvHUxISEi2eCQ+Rhd6kINhqqsSgwKKspCfc1NoWekKS48pqUOcMxzCgMvl6NP1iG5D+o0QIUBjk9BsakG4eB0PRSgHbi+cH5osCuWyAUy2M9dCb5S
 g90rQmQm
 RPOuPEX+jRxApL6KrMJTheOd7klrKT0didZJbmwXSWsQPpivLs3+LFxW0pJC9BVNydJ2WlBbBwAuwj9++ZMICKrEsdsv6ff+IdJuRtBbj1KuvNic46aJP1YV/rjSFs+5yNOiULgt0rwlanoY7qrd1QOvaAc1GFx3zhv5eznBxPb12AsvllTBY/WKvY+QoraBkv2MMI6/pnv1Yt5untzovFditpeP0WGx2+QtcxBsiCOk0Y73nYMzmqXvvSV6s+lWSyUL1ZXsP5GxUHDlYkbcueC+36AvZ3T9rX2VDM6VklCHq+4PfVOTJaFIJikHatKHUu5osy4cydC9awscEuhCfwXV4oXKfBkVAuxqco8kYmy0mAODPUOYxxMt69CJJ1lwpdGRbuREUdkxhFir70V7C3Q4HHkEzCFCOCktMp2cmmokxbtJq5C4UQ6/FgIyNW57ghYAYOOpMOAbFbRVs1kHLhkS/UjCnFvyvDjsJ7KxBQ5wdBusW++BOVKIpWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:08:21PM -0400, Tal Zussman wrote:
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

