Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 679DCD59F6D
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 06:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8A56B0005; Sat, 13 Dec 2025 01:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BFC66B0007; Sat, 13 Dec 2025 01:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5FE6B0008; Sat, 13 Dec 2025 01:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2376B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 01:48:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE4711357AA
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 06:48:45 +0000 (UTC)
X-FDA: 84213519810.09.37F82AC
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id DED30C0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 06:48:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=CNk48hdC;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765608524; a=rsa-sha256;
	cv=none;
	b=LA1xrUscJjmk+2RBQa2Bq3cQY6ba/yw/G2EBK5j1szCZQmufowvqCaKyeUp3DPnuOZSTlD
	DXd3L3uqhcpTNT4VO4kTeFeYCKDHyJhkazPjSek+KZJwBLEmY8MIGw1HXXEKtn1Fw8CBQa
	lJEjUPhlOJ/dSxcTZSwa+mv5ozCKYzY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=CNk48hdC;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765608524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSPLFg4W3QR5ByFn0Z+25izVWJy4kGkKLbWih19PHZA=;
	b=bxHvDq3Bnc79Zms1fY7oN00rphPX9mRtBGp2mNEcchPfm9Lybh4B8WO5XgmXADxqhQd7+X
	5u6neTpMyfe989QrybD54sJod2vtKtrMcPWQ0rJr4iVbfwRkCDbjXKDJI2Kx11+F6Q/wyd
	YWB7w5Bo3RT0jZ2HUnAk+WOuDXXegxw=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo2211578b3a.2
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 22:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765608523; x=1766213323; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OSPLFg4W3QR5ByFn0Z+25izVWJy4kGkKLbWih19PHZA=;
        b=CNk48hdCcLnFPIgQ4PnvEn60T+RKgpRs4TiCtaxNVzcBCS0gXbnmCd2/RfhCf/3pMH
         Gtf43IKiX1JqOEAgk9trs0+BjmMKE4GKOqCQfoMdU41eHuzWAVGkZCV5ejbHZbzGl7Kd
         j4z3JjTnegzkMNfZLOEjxFPRE5v8UJMtbOT2VObGNIXZEE9EGDn3TFS0NCOU1q/5lFTo
         d0/eAu7TgUpaYGGwoSoE+ik8U4b+Z+937YAjthkbNgEeQi80qtj0oJXFW0JWBZjrvufv
         2GlWddkRi4ChkqkfDKKuOnbws6wmqWaESWXKk+LJeFZPyAdli2e+/V59RKDYCY1ysBHE
         lWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765608523; x=1766213323;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OSPLFg4W3QR5ByFn0Z+25izVWJy4kGkKLbWih19PHZA=;
        b=NxLtw/ZpMCKqTMXrK0OVlYCFCMQjQIkoW3iq52h2+zrXWsDsJiZfJF8f7OTKf/KxSv
         u4nhM2yhLHBxlbkZ3wawDy2E945UWsjsO9zDa7I8FcQHA7Dyelh158IU0+nCotlJMGBJ
         SuEjfDiyx3WwoMObfPG4fkQaYSSVelC9SRANzraR/qQkHtc/rQCfbubYiF846wMvoiJn
         HzxT9fas7eE3hw/PnSDDRXiPogdOgtaR3jQIUhAwPqjJ4wyuX0F/DO/aCmG1u1aAeEJg
         F2P9zF0WLFkDWrfs544W9Ot/hCU17JT5DOyhAcPsL1rf7wDolpD20v0kd1pD/iZXXzsN
         phtA==
X-Forwarded-Encrypted: i=1; AJvYcCVeuE0lXBOInSt0bLlLwOlRYaus8ccpryb8vw9iG/DdkLkbgODDHQCEraXXAL2RRW/WnZo43Emv4Q==@kvack.org
X-Gm-Message-State: AOJu0Yx3+QGjjkz3+zIn2wkMUA0iFn2PBQu7o79dAQBHaclhSbzoZr78
	GxwsfTV/FfWDEz75fA3qinkXbnxtSFlkMiDGHNQ0hVu0FsR6DINGVv2AaDoLW/+9oKc=
X-Gm-Gg: AY/fxX6Bm5QPBcO/VcYZoKH40svgBFmFLO0+9WKE4L97E2nWn21WnoW7rmEjdXrJOaV
	2rMkAMRU+WFoINGBNORdJDyYAD/Q24fNH8a8w2OtypFwc7tvrmucUAk+3HLaKB/yf4PSU4iDcbk
	pB02WsS8OXVzKzIf7S9hQ+ll7p5bWJ+K0EAoeARy7X5tKlh5iz/3VpVOmAS+ALCTJUJ9w0IZ4go
	5mZQiT6a8xh07BLGIPX4bzpyJPRRRwgn3ixb3Xi7gQGbNW96/Afkowntn5ahOcSKPcRhMPqiKHf
	1wUVGe7LMzD5GvTylx/9FWLSX7yqOSXoxQn+CB2KbCsnN2ZzHWmMPkU4YO3KxdUMElshtsA/Thi
	RFdJitamKAIaGorfBKD8SW6sbpD26fDzFXeRIemaZOKA/G7VooCvx88R/EKxpUdtHN6AC5ivaTV
	3sIixUj1b0qw59IcVgij7LR8u2Sz+poUwDs9iBq1vQ5qGJ9UP/2+S45gxOCwYtRA==
X-Google-Smtp-Source: AGHT+IHwMXPg7Qn0Ef9xWbq83SFpsB1sFhZLa5C8vjkRdWjkXJZFN6bz1qhctibBoHiLjB/xaNqEfg==
X-Received: by 2002:a05:6a00:1c99:b0:7e8:4471:ae56 with SMTP id d2e1a72fcca58-7f6694a964bmr3530338b3a.34.1765608522549;
        Fri, 12 Dec 2025 22:48:42 -0800 (PST)
Received: from [10.200.3.203] (p99250-ipoefx.ipoe.ocn.ne.jp. [153.246.134.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c4ab52aasm6927000b3a.38.2025.12.12.22.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 22:48:41 -0800 (PST)
Message-ID: <bf00eec5-e9fe-41df-b758-7601815b24a0@linaro.org>
Date: Sat, 13 Dec 2025 08:48:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org,
 Trilok Soni <tsoni@quicinc.com>, Kaushal Kumar <kaushalk@qti.qualcomm.com>,
 Shiraz Hashim <shashim@qti.qualcomm.com>,
 Peter Griffin <peter.griffin@linaro.org>, stephen.s.brennan@oracle.com,
 Will McVicker <willmcvicker@google.com>,
 "stefan.schmidt@linaro.org" <stefan.schmidt@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DED30C0005
X-Rspamd-Server: rspam03
X-Stat-Signature: r89hrugw6ffr1rhum3f5jic98sot7qbz
X-Rspam-User: 
X-HE-Tag: 1765608523-884405
X-HE-Meta: U2FsdGVkX1/kK6FmHrFImDM1jG+MFb/QD7Z00tp7yTFG+1GuCVKU93ylisls4NEaWb3Mb3TyKv+9c9+lM56rindoRzSy+ulk+aoTQMyRH4o+Bjh/MLb8SnmrxgjZnJ+I/LtXeHvwt5Qxf0TNMe8z7rN5MM4va4yjwhmc3egbVdPsJlsFMBcOHwTyhKcJuKnIFFRoFL779OGaCDhUHHJZZqERUPBq7pzLNbKwBfpyAWlUk/jfmzlU5hVKq1zKwqn1tY7FO314a9nHZB5f/UpLfxWQoEDBLTOq/sCaEeKZlfzwyPdJ9BcjuGjhQJkSJx74IfbUz+92gmfuK+VclDWE00Oh5NmPTcEwUM+aA/Kz8nUctYmvMoMpuRu6djDeHR+F9jvq29uW8ETm2reNogsXNXIe9GUbHX9/XNEyR8JjBH/0Fk/kbliM5tZ5lqA6SUggi02PIHsFpGeswWDYw2KDfI1kBEz43vjEAPSiJQ3g2gjBXJ6HWmea78ylpHFESu3EQLdsN/jFGmrL0IjTtDLu2IxssZ93/a4N50s0ca62EqQT8W1ZXNNuQAzDsmYjzM/CMOcj9mTGYMuRT5Dhv/g9Y51E74GwRoUPDoOJ4kuhYWcMF5leTGH6CTcpZu6iMdOJZjnmpGz4oyLJiGrE9ad8owoQ2EMyY71uDIWPOBQ1vkVNp8e4KXqvPDEAMXHhmHhryE2EkTH54gpaEFl1kM0HX4soZal1AgMbcrYRkWZy8wSv03KvyPC4l0gP6FbCQAvGa8Ppc0AucVDo99IAYHJPogKt/LzU+iHgMZEgd7FhqZYDT+z7oF9LCUzP5Cjq/DKUwJOuqEcfQ+XpcrWHo6S706s9/tQXHprv4UO5bMC2AW4e+WYEt9sEsec5KkajpaCz4Ov5/GKoG/c1qOMJI0bdKn0fQleaBWs6vFixo6snEhlCx/vGv4Z3uUuDXoLKluPP4h/prIDNwqZcLV02+J/
 G6RjOYQO
 1ii02TGwLli6KXClprviUjG20wes2lQmNmRFLZxgootZn+H2gNX7bAqUTehbM78+SOSiAHxk1/1iupxpCKeaLyMYf2GjbTfTqYtbm53aYkQ8CcFCloCqRGrLI28Hm55uVWrZ+VaSYl0c7cxDoKFVn/aYt4tw/lpQaus1pa2vFoKFinS/1mJzFdGrxOQyDMOp/VaYT6D8Vrvc/YqqFc57q6IrJR8hmRKiskqE4GFNekudjqz0FWb7pJUlpqHBlTDA79YiEUdzyiSr0pZqONaFSbIIw7KgKsMobNSiiJk0ufbn3B1lQMN32ffBEjKCq9EzECj4NmUXW1kwhcSIEJx11UFsSUfluQZEiUcKt9MzB5R0U1l5QIK4rPDz7VlkFnneMeQRZyUQEJsXEg0qT3TxeV2+bSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 17:44, Eugen Hristev wrote:
> meminspect is a mechanism which allows the kernel to mark specific memory
> areas for memory dumping or specific inspection, statistics, usage.
> Once regions are marked, meminspect keeps an internal list with the regions
> in a dedicated table.

[...]


> I will present this version at Plumbers conference in Tokyo on December 13th:
> https://lpc.events/event/19/contributions/2080/
> I am eager to discuss it there face to face.

Summary of the discussions at LPC talk on Dec 13th:

One main idea on the static variables annotation was to do some linker
magic, to create a list of variables in the tree, that would be parsed
by some script, the addresses and sizes would be then stored into the
dedicated section at the script level, without having any C code change.
Pros: no C code change, Cons: it would be hidden/masked from the code,
easy to miss out, which might lead to people's variables being annotated
without them knowing

Another idea was to have variables directly stored in a dedicated
section which would be added to the table.
e.g. static int __attribute(section (...)) nr_irqs;
Pros: no more meminspect section Cons: have to keep all interesting
variables in a separate section, which might not be okay for everyone.

On dynamic memory, the memblock flag marking did not receive any obvious
NAKs.

On dynamic memory that is bigger in size than one page, as the table
entries are registered by virtual address, this would be non-contiguous
in physical memory. How is this solved?
-> At the moment it's left for the consumer drivers to handle this
situation. If the region is a VA and the size > PAGE_SIZE, then the
driver needs to handle the way it handles it. Maybe the driver that
parses the entry needs to convert it into multiple contiguous entries,
or just have virtual address is enough. The inspection table does not
enforce or limit the entries to contiguous entries only.

On the traverse/notifier system, the implementation did not receive any
obvious NAKs

General comments:

Trilok Soni from Qualcomm mentioned they will be using this into their
software deliveries in production.

Someone suggested to have some mechanism to block specific data from
being added to the inspection table as being sensitive non-inspectable
data.
[Eugen]: Still have to figure out how that could be done. Stuff is not
being added to the table by default.

Another comment was about what use case there is in mind, is this for
servers, or for confidential computing, because each different use case
might have different requirements, like ignoring some regions is an
option in one case, but bloating the table in another case might not be
fine.
[Eugen]: The meminspect scenario should cover all cases and not be too
specific. If it is generic enough and customizable enough to care for
everyone's needs then I consider it being a success. It should not
specialize in neither of these two different cases, but rather be
tailored by each use case to provide the mandatory requirements for that
case.

Another comment mentioned that this usecase does not apply to many
people due to firmware or specific hardware needed.
[Eugen]: one interesting proposed usecase is to have a pstore
driver/implementation that would traverse the inspection table at panic
handler time, then gather data from there to store in the pstore
(ramoops, mtdoops or whatever backend) and have it available to the
userspace after reboot. This would be a nice use case that does not
require firmware nor specific hardware, just pstore backend support.

Ending note was whether this implementation is going in a good direction
and what would be the way to having it moving upstream.

Thanks everyone who attended and came up with ideas and comments.
There are a few comments which I may have missed, so please feel free to
reply to this email to start a discussion thread on the topic you are
interested in.

Eugen

