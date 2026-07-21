Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C50BCC4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F576B008C; Tue, 21 Jul 2026 08:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9372D6B0096; Tue, 21 Jul 2026 08:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84EA76B0098; Tue, 21 Jul 2026 08:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5326C6B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:36:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC1318012F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:36:15 +0000 (UTC)
X-FDA: 85012731510.17.CB3E56D
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id CBDC840002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:36:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TIdfx2gF;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784637373;
	b=Pq2rscwesn90x5zoq39EiwCiG848u60rK4QjQagfV3sGbGe5eLYu5t0IqRAiIaFxio0ib+
	v2wkv2uJBw/ZWc36lWPdoL8jwUSkwDMYvnkjrCFkCFpVGZT0FmrlVhpJGYeclKH637HFFb
	tY9j5nFOFQqdYwd5CHGjpaMX8694T4o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TIdfx2gF;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784637373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXKZ+mCy8htaHCjZ0GyevgxuuwSsosaOIhPAQIQtoX4=;
	b=0k403kwlByULv2vVtRhfxQb3Fz6rP/bYueYRzZjHeNsPC+yvwHD6t7eXT3yl4FwFH6nBkM
	LXMriqB9oD2Yu39xHci+0JaHKTSPjbEQmtaLfmYEucHvQAdfWFlh9T8qKtwt27hWK/hVU6
	lpoHIfraDzeDuYoc98LGMRxZR5LJqK8=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7ec49608332so2469791a34.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784637373; x=1785242173; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fXKZ+mCy8htaHCjZ0GyevgxuuwSsosaOIhPAQIQtoX4=;
        b=TIdfx2gFIPE71G3YPogFLyIzahciGBqcJReqcnvM8AObu9DBtpICPyFxtHznD5Yusx
         ky5xPteYakFLoaHeAusaW3CGMqczo4nAryh5fvZivmpD0aR1WYhDf2rPBsyJdEzxi2xB
         ytwMGzkmLhIgKtZqVDbg1VpKhYwelhapcSU4N6oTQq1Dc8B5AtV0X85CLtJ+x0JJByTa
         Wkekw5+J6Q7CyCQxX0rjdpT4KTvCn3O2ZLIcAumuAL1n4pI7oe0oALdGKTiKtknYlcrt
         ookHs1/nXYZnlXxxhn4H3IdoKJpfAxo43QO0Sa4xbLX8qFD9c5MxDXEDwvoLWjGq/kYZ
         7f9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784637373; x=1785242173;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fXKZ+mCy8htaHCjZ0GyevgxuuwSsosaOIhPAQIQtoX4=;
        b=PmMfjndKxKHDEAR22Qu6TtBExrSaAS9dr10D+XvOFBrNGz3Kw9ggFeDgOyZuEcP9op
         g83ceXn/cE5E2BJ5Gzc8GcUnOaUH6otDA+Zi7Ufp6aDF139zUK3duksxM/Bp8Vn9+jT7
         LykJD3nWhaOecEMJrXJnBI2PUeLRLNujYgDwBQP1/64fEphbx0RxaE83RB34NF6+4GGW
         mCgunsmN8/gkPPu4blMXcmk/HjFeCpuXs/dBkIkDZQDrMQx1uUJUjMTSI71+i+pAvALJ
         b6dha6jOWI5G725E6ltSFb3U7ma3+IdsWMS5Ika3FYF4U1n6lMPpk409EARK4dYfg2mq
         L1+Q==
X-Forwarded-Encrypted: i=1; AHgh+Rocih1cGJh9w1a4v9JCrNKedZxBLTiFTbrN4k4C0pJzvPc0KCDsvZ0FNt7uRoFsYiq9NKwEtv68lQ==@kvack.org
X-Gm-Message-State: AOJu0YzmJHLBReFjQ/rgs4ZWiwSfq/32YZQAw5uR5VgCpH/+cLD+OIl1
	rSoom+jPy0LK7rzayHGnYOH2e0eeMj23/SS7rRkRkTdrFgZzLkD+RCr6
X-Gm-Gg: AfdE7cnv9Lwu/+ziwRjwuaAuSL97s9XUMjbgwHICi84SlfjoVghF28fjyXTuxZr/N0k
	R9mfMR3F3xrdGs5fQnDZCLOnxMzOncelgCDm69mbr+2ieug3QWVoK2Gjl76Jln6eWXUbE9mNQZd
	hEPNPdt84q7y2NjK8MGbolZd09nHP5MFqCJDLR0vcPgBn0QNEPjUbN44PK7YXX3z6c9k2YoOh6C
	ttuAURYw7V3j+6k3eCs9PXeeqcfJGk2rEQdj5j/HjrsvS09F5SBvwXZ5CqBhtwGdnZcNdcoeuCi
	7ZP6HgCZEY9lAVRH/8Pn2yxqg9nYlwvTB1LqYAW3cgcl91iFLL+8Ve1I85r5m8heoObiuj7UBYy
	JyXaf0nh1A8bEpLh4goMk2TDbJ2wBQU7F06Ij/WIh/AmnuleyQpstb/B//wnyRXSHdmm5qKS0ny
	A8RF/jEQ==
X-Received: by 2002:a05:6830:82e3:b0:7e9:b946:e1bb with SMTP id 46e09a7af769-7eda153266amr9848253a34.23.1784637372781;
        Tue, 21 Jul 2026 05:36:12 -0700 (PDT)
Received: from [198.18.0.1] ([144.24.58.22])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edaf94a494sm10332132a34.13.2026.07.21.05.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 05:36:12 -0700 (PDT)
Message-ID: <0565e7d4-fb0f-4b84-a20c-0c73ac964b51@gmail.com>
Date: Tue, 21 Jul 2026 08:36:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints for
 hunting memory corruption
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
 <hpa@zytor.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Matthew Wilcox <willy@infradead.org>, Alan Stern
 <stern@rowland.harvard.edu>, Randy Dunlap <rdunlap@infradead.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
 <91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
 <20260717181004.GBalpv_MOaAflgFxgh@fat_crate.local>
 <20260720232442.3e6b0e70c6939541b8362e05@kernel.org>
Content-Language: en-US
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <20260720232442.3e6b0e70c6939541b8362e05@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k7uf1j8n7q4ii9313c14kqndm8etexqq
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CBDC840002
X-Rspam-User: 
X-HE-Tag: 1784637373-425855
X-HE-Meta: U2FsdGVkX1+30ix9ItKpxCLuo49YXZUr+thWuAvbALoVnn8NF9vsa7t/rhbQZTvPVZPf+dzE/gi0Jwf4z9mPiQyPNoqf5Cx6gTniJuwtAj0wk3KAOxfReCIi6c3T2+GxxF9a/Uc0o6Tvru+rbh1TMMqz8UU83Oy5LRM2NuxzchoZZvo4WGdYfIfGwXmpr3i/gZSiwVk3ame/VYst/v6KhMeKNmvNasSPvayHgwghSB1SNtQZ5ZZt/lADdoZTtfcs+hqee+xHBn5PKO5IodQEJcW6Sq+JVnXUZzdtTVILP5/ZI8ZiXlQCX90ChZmYSN6BQADaoqNriuQr3roQaZ/SLORxMXIY70RTrFBEl4zOh0lNFDrPozn1+SckM5EPGjR8FbAsXK0b96Rn8i69FqcUNCWny+M8zWcO1Qi9rQ3A/RI6efjcLx5gU3pUSRpX/d8Ev4IuJnMmzcjN1cp1uQKR8wClMmW6a4xhvp22DgofYGdKFNIjTvvtmsZWUYUfKTld2sL4RKJhugpndSUeK7sS5I5lMAZ/PnFmpNfEiaVTb3QAk+waeIJ9/eaDDo82QUnaD8LmwyIOEsgoXs8LtwViz1XUKSg3GtIwLLHdUdyglaqqXY3y+ES1kt7aTnCaDDDuX8DLKbtnJyrqxKCfQtSIQqIpfJLSJrdlYDaNL5xlTtOHVlQ7836lkof0VyZtFymeW5ygjbblnyyx5oixSDEpLR+MvMgOBvxZhsy78ncxm5v7YLYJBltfjlrTMUYZhZjn4Qoo7DFh3iOU9OnYcIpTX8iYPDm/nSrcl5fwRx5giV8ENyFS2yNsh6PWamDsZOD8GfEWk1wgMWyysY9AYL4cuucXKAw24ZrnBGq3s9IBqStu7c/esVy01AhtqXeSJ2Sm2kyCk9jqkSZaeWRoSupw1l8CUM0r4ixBx2ReMAxkCFjwxc9IcSAPid8FKTWPHlb2hOQJ0XNL4x0Q4Ortgfp
 yFrEVGyz
 t7prexpu1fsWKZqnPio7Vxby1Zswaw33OWj3Mh4dH8ngnk1hW8+ki04+54uOePGETiFGC5Emd0rbNZ9sBeB4CLMmrwVhKiA3zi/bXph6fF1oijMFaN5FxygeM5D03B+nAxXVCs0vL/d2flK9YaxFaHdP81/bjgLyXSVV/qP23EHzsyiWqr9yleX83XhKEdncYdEPui9yvkloflReVXMCD45+h6yglUiA2drMq75GH/2i+zh6sso1iwBqfxoufTfWaJerobNgsAAgHh6Z2StpOKYXPiYZMUITOXbi6BZoPDKgBy25umEfIdjdXzLv8LsljmVRYhHDci1pvOppPmnRNWhpncMO5ftnTOK44RWKnUfJ/GiWreMN9X4rAyWxELFqTOA8Wz14O8MqV57gZxEXY1NcfpqkCfkOy7ziETiDpOE3rz4wMQO5cq5Gnr1WvjEdH0YG2cqjUTFS3kRRJz/3B5io39w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/2026 10:24 AM, Masami Hiramatsu (Google) wrote:
> On Fri, 17 Jul 2026 11:10:04 -0700
> Borislav Petkov <bp@alien8.de> wrote:

>> Looks to me like folks need to sit down and agree on strategy first.
> 
> Yeah, I need to talk with Jinchao.
> 
> Like kprobe, wprobe itself integrates watchpoint functionality into
> the tracing subsystem. Jinchao, I would like to ask you to redesign
> the kwatch tool based on fprobe and wprobe events in user space?
> I think that could reduce redundant efforts on the similar feature.
> 
> Using fprobe entry and exit event trigger, we can make a Function-
> scoped watch window. Also, since fprobe and wprobe are having BTF
> typecast support, you can access to the members of data structures
> more naturally.
> 
> If you are interested, I would be open to having you handle the
> development of the necessary features for wprobe.
> 
> Thank you,
> 
Thank you, Boris and Masami.

Boris is right that we should agree on the overall strategy before
moving either series forward, especially since they share the low-level
HWBP work. Masami is also right that fprobe and wprobe provide a more
appropriate foundation than introducing KWatch as another standalone
debugging tool.

After reconsidering the design, I will stop the standalone KWatch
series. Instead, I would like to work with Masami on extending wprobe
to support the function-scoped dynamic-watchpoint use cases that
motivated KWatch.

Masami, thank you for being open to having me develop the necessary
wprobe features. I am interested in taking that direction.
---
Thanks,
Jinchao

