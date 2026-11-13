Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE72606B1EF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=l/trp1bF
Received: by kanga.kvack.org (Postfix)
	id 647636B0608; Fri, 13 Nov 2026 03:31:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8316B0609; Fri, 13 Nov 2026 03:31:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E256B060A; Fri, 13 Nov 2026 03:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 386036B0608
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:31:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5BC1801D8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:31:02 +0000 (UTC)
X-FDA: 85429425564.29.3F54B97
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id D488B180007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:31:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="l/trp1bF";
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794558661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f61a/DEp6A2hm2rkE7XwudvGQ0m98AaZhEeJm5iO0+E=;
	b=aJCw3vByUr5tyy30ZdoshcwCkIv297HVvtEtETl9V/EMoGdfgRIlD8SvTQnx3zkoKPO31w
	lshKcjlXYvQ1hpalvCmRURnzUSqAGHdNZqvFiD6/FgkJhdR+3Se15eEIXXAukWlZvq5Hip
	RnvBZeYRXsVA/Z42Pf1zJSTSi6dBoNg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794558661;
	b=JCDbGyg+P8cagK9k0mqeSvxOM+I39wFbn62kr5PiGXfxyKFDLdF2hDdDx7BN/gXhop6rkw
	1iBHoqeiItPswBQYqIlKpn/3uisjf3K0QB7mwq6QIhY08Oq+UmMx3pZgbH/wF/4TFpiB6+
	kIBmte9kPPUKXatKF0+olf0je9Ljjhs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="l/trp1bF";
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso4164735ad.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794558659; x=1795163459; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f61a/DEp6A2hm2rkE7XwudvGQ0m98AaZhEeJm5iO0+E=;
        b=l/trp1bFdsXQW9Ro58j++ozUC0eUEmfO8PlsJ71U8t37CkB+p12SA7yVI8h997tzde
         uAPl1MPAQJCch6tffiUl+znwEZPhIF9rJsVWmDxh8K6kRWS2MDz6IAXIqy1qr+U7CWwh
         h75fYsz80MeKm8YF+HD89vdR+IXEz90KjAv5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794558659; x=1795163459;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f61a/DEp6A2hm2rkE7XwudvGQ0m98AaZhEeJm5iO0+E=;
        b=wr8ZHpYTHqaXnZddx5TdZOcei7UuWxd9w2sUcyj30CoNsJzpaDLqLA7aQwk9nS56R0
         lF5jI3R9gW4Q0kVwKsb3y5DUhI5xWMBAHhCz7HmlokOS/8OkNVQaosUVlO3fmk5CKJRd
         Mm+g0xBTlp1vuaHKQPa6Hqy9jLpVle2+WtVxD2hVgK1dsSzxxKSEy181SFJZTf1ObhSI
         O+zLNGcRNC72otVe/J0eSp9rLEalEt14oqDDA5UoegKy6sCEEkOnSigyY+QAXdOEb5+d
         EY0or2fu7CjhbAFn7CcEmWDeDHE83R2mqZ6sxubfeAQ8Wy3F1o8w7dPfsu0ou3xXdP0R
         m3AQ==
X-Forwarded-Encrypted: i=1; AL+hErF1jK7RT0N3Do4/ZB1ACanfE2wp+tQHvH+oNJnbocLTJmlC3t0SocunT4hV/m9FCbIIYTT9vNQGaQ==@kvack.org
X-Gm-Message-State: APuU4Z+bxPRF6LgvNbVnRGbBTeV/qv2w3XwVEtVAbfT8axC5oxsdmprh
	0A3EBfvgKHczhAoEEP/vdRZ2q/T+Spddz/8d+tD/R9XlsebRQu0ZPyKxxIlLzwtY7ow=
X-Gm-Gg: AYBFou1y5kcWbjj+K5gMDXsOcLZzWdwmsAUZDpQeRe0JvasJQVQy1IxwWWR/mwzmDkl
	xAQ12ga1PO0N4vGJ1hPVudV9QRpXHLL/GFIpGwyUOZ+NJFT+2QCPTgeEhODA0+y2wfYJSoFJWCm
	qdVeXo9vXxZsSnvNttrMPsM5phOO18dbjKIwCV5321ZPKtLaJw+1EzA/qURGRtTRkwrtC04q+z+
	1bHW/YZsl0La4XK4F6mL3b5AsZmLj0NsDllGWgNG1I+ape5u2Mew4OBjgNsICWWZk1JvrQlEF3y
	gH2n0RggX3TWCMVTg72+f5eUtuxrV8UC2ebODDjEGKExRpwugKzBFRCtrVfaUbHCTNP1UQJ7Xrc
	d4qthbw2SRZn2wETIph+hvT6O+9RQjqiq+SYfgvcExChb4bSqTiQ0nnlKcrs/a21fTYsmiecsOb
	8Zdbq0XUm3nhx2ODPixmIS089STBN/HfzWCwuPVH1elFaOMnxPiTvYuErX0BId0TTArpuXzR5fE
	06azhde/1wvAcC7j3Co9OtOczbxrmC7ESE2eq58WEcCJHKcTmaxUaTYmdBeFex7+/Moq5Q62Ch6
	vz8SeiizuXx74WmZW1IJfyf+l/2yoQXWTcn1c24ny3J15dy/IP3gFTCnEEiTJSZ3zPtYs6mLJ0r
	hLHvyd1IcL/x11gX5Qy0SYFE1RdaJuyVfr4uf60iq+XUsewny9RQHuWEEfDeD4OJNyO/xHanpMS
	+zwavTKDl/szmVKg/4rkx9BiDS/t731WHtJwqH0UFy6qOKWJYssbNhazNknVA=
X-Received: by 2002:a17:903:228e:b0:2e8:18ca:5f46 with SMTP id d9443c01a7336-2ee0da7bf97mr17781095ad.14.1794558659559;
        Fri, 13 Nov 2026 00:30:59 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f868217sm6442615ad.52.2026.11.13.00.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:30:58 -0800 (PST)
Date: Fri, 13 Nov 2026 00:30:53 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Breno Leitao <leitao@debian.org>, Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/9] kho: Reclaim the metadata page left reserved after kexec
In-Reply-To: <179443616043.2329176.17166425351392983946.b4-review@b4>
References: <cover.1794383544.git.chris@chrisdown.name> <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name> <179443616043.2329176.17166425351392983946.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113003053.1c951f5a678d35e3@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fhpczby96n4gwgt66k4f41pmh8qrohjp
X-Rspamd-Queue-Id: D488B180007
X-Rspam-User: 
X-HE-Tag: 1794558660-945041
X-HE-Meta: U2FsdGVkX1+pYZw6jUQT+A5x+88DbrhPSFNW4+VYA4llLndeV9R4+jt0iguJQCjJG0HISXKDwuesWX4f+7dgQ+EdM73v6xvfaUwuXxxU8pM6/ewDygnacvcHr6fJPzDiv2KmWt9bVKaDmc/A8OUW9Q73kjm7fmdDFbFgNLMJV7sZ02RlurGU0nWKFvLzeXsDUps9eh9g5tiFE9BfaljwyMgPFnmHxF0eZn2c6l13FE0nEHvbA0c5sWtCPg8r21R8q/7VCJ2Npvl/vMkl3K0pzhrdBxZd7NGhxY9kT2RFvVtk93HU3ATBQivvuUaYw1I02U4eg7ai707Wn0eJeAzoncozNvU8zwPs9MySng9HmUPhq4t7huXgXMb6plLgbgpmVH3rs5AoMBGvqIiYT6/wZclrgq0Dc5hBTSpCXrQ45WmuKEv74krBIiW8JdrO0gZoB9o8HJmT+kr0LWIWUkErKo1owxcGkLkD6JABKXgulLJFRT2pupxRJghaVENxA+SXjTsY/3K7wO9tEzXjmPUIGxnPbR3s0jYPHD6iMdVmWp6reV2su8X0Yz/ob3nbuTTT5j7spTLg5kGKyY5/q6Tf00CsGbBGL0wmDuvPvfHg9GL8b6El2Ol5ZiejKAMXScgV+CzVBxWcVBTzq5ooIX8eAG3pkMV5bMQczEJ2LFTRcK/J8OExK1x5c7Rr/K6YtrrI3QN/yBgXgy0AGUKkN0UWgTWuKhy5R+kONq8NvU1CMu/a2M799KLZ2vDD3SXKXbDOCuTH4Z8WewEkcx45vl6gLA2feU8uuOquvcrTN14AkKrEYyErVcAmxbbSG4y3j1G2oDePDSBzPB73HgQZn6vXELd+JHmgHOt+zZ0VORuI52Li3B5BjCeNO+Bn4VbrZZbapTHppTWmTr2eAajuaapcap2D+I2okWlKOn5UhYv/vyLxqq+yzMKVIYBznDm/51fj7dLvyvPG3PuhKd2IfJd
 ifa+gDSX
 Fow6O7+ig0tggx5XIf1t1wdGTWPkNTF338foQFhQcrp7DmpVo4QMfcbSjXhr6FoDaxtLkXiTF4nDJzVS0IMg0THDmp2Q7FUjSIkK3GJ49rNPtUjgFgAwKbBR2Xam8ruVjqXk6XTfvNXInHlyjh2dG83eLVkdtU8ZP5Dq0o5BUviC1I4NkuaI0wbH0bV/ksJ3yPpVj553Jf5j9se7CjfEb96uWt+Xfvj+uoC7XqiI6ssA6HlT32bheO8vDj6WTK7Yt3LaVDIpBd8lA8yXeGHFOLBAiJOLUoez6VTrQoKz/tKAs8391ry0DMmwJJ1MGYETvZWMrRwwtoh32x8Q8QSyRmxnBST/FNhXB1QIl+t/jWzWL7p7VOZWqIKgSwAnYiL/5EQtpZ8NbbahI70btfNZZzjK50PwgBTb7GP1KKO+3R4O/Loo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pasha,

Pasha Tatashin writes:
>> Fixes: 76aa46b9e404 ("kho: kexec-metadata: track previous kernel chain")
>
>Do we really need to apply this to stable? It behaves correctly, and
>your patch performs a minor optimization by releasing a single page back
>to the system.

No, I don't think it's worth a backport, since it's only one page per boot.
I'll drop the Fixes tag in v2.

Thanks for the review!

Chris

