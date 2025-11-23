Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12564CFD314
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 01:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116796B00B6; Sat, 22 Nov 2025 20:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEA16B00B7; Sat, 22 Nov 2025 20:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BEF6B00B8; Sat, 22 Nov 2025 20:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E44F36B00B6
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:56:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9134B4F633
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:56:07 +0000 (UTC)
X-FDA: 84140206374.30.DDD5649
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 945D6100002
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:56:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C5pk6B71;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763862965;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFfnRMxsFef8UuqVOMtfR2RwUPLNhAhZ9jQUdR5Ficw=;
	b=sbYlPafixFFoqpxTyj5BQPiX5UvLa0NeArt+Gko6h4OrbDxnW1BBxUkO+2OLGyQ94mcMTz
	mbpRH9vk66A9NiiDAW4UaZ6r1vJdfA9JOl5bfLJI6NU+w/XGSEyLJ8nKG8RMf9VB+HgXsN
	iUxHXBMAhCMZotb+sxNENGPOIp984nk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763862965; a=rsa-sha256;
	cv=none;
	b=qwkQy+8K2j2hA5Fur23Tl2uC9k0RyoylUqmT8tgvRv39gEuRSrIhv3qXKEQrK8Vus7yS6M
	AjQm3EGA4HvWam/WAAWNYN0pmOX7QSwXGWARUvv0TlrfSa7kikGpUnJV2Va46urKE7HiVX
	wuahZxj915wzTQFlBdXv6Wr5bdw2H/c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C5pk6B71;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b72bf7e703fso532330366b.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763862964; x=1764467764; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFfnRMxsFef8UuqVOMtfR2RwUPLNhAhZ9jQUdR5Ficw=;
        b=C5pk6B71WyECtGFXQ9M562lsI3aA78naCY/BjHyyEFHYBf/iUS0o1VjvBgiGTA2haa
         Lwmb358BbxSO3s2fI/mxR99tOng0pV9jwjZOsPqI3o1LIB6dizMMPN1c/oSWRoMSBLX+
         3UIaoeCJX51hKoCczVxo1+yEJY1U5hn7Sxv19wNtRZIVYw/qYFlV2yT9/C7fm8x7tWhp
         dq8sCDKB/xqaO0NdaSyqeVcg5uVWoxe0C566a4ufAny+JqQojxEeCIvZOb9qlw/9H9FV
         +bWwlePSwmWSKEzPp1TlZAtLkxAgQ+adrVNsie04SOOOKiquYs2Kvu3G1Nd4UQwBH1hm
         X4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763862964; x=1764467764;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hFfnRMxsFef8UuqVOMtfR2RwUPLNhAhZ9jQUdR5Ficw=;
        b=q1GOMyTTxRQFE/QlazsluA6SUOJwGYMeg4hAun7LzBZGJbYkX4avuS0Umg0Jlx9V8a
         VO5anaUCI0p0ZoWchdnFFYyd8Ap24Kua9VpyoDupDcfbCh6TAWgpMx0R4IbhRHN1y/9C
         aXnrVT2QHOXpd0EmbwdNzgXv6O+Dtcfc62n6+uSeh5Hpg2qe/HhICWA4TjGGkF4IhrP8
         sDkSQQ9tS5fsikUWi6/MBTVY6KSB/I4SGEOOisn+h9OV+EY7Omt8pbjg38Pad3TJQegw
         MRLXGkcXDr5nopBhgK5sCMFK3MmpoHai7MMOa/A604xh4KayKA10kuwEyWAwinppbQvT
         kRog==
X-Forwarded-Encrypted: i=1; AJvYcCUdxPMx3OHBqBgBIadMQYi2qGmVYt1I1B/RQIc7iUVv9RbtHbBfRhprjehVlaO3obptB7RB5bpc7A==@kvack.org
X-Gm-Message-State: AOJu0YywG59VJZJnlXd8OlZx81IhhRUH2wkKKJHqtsL1AonVqlV9Ux3x
	GIMGwZvNx9CQR1xjmDITNLJtCqsJTXIZ6erVrEm3n9DeTnEC/sL53DTR
X-Gm-Gg: ASbGncuNJ9PxbfG480gK9H6i1jMWQlYM2+IEwqeUWSqv+Jn0T8xZqVVC+HlsCMrghcr
	t/SchMNck9yRwtavoVPdSKzwMbnPbio/7KZpfXZIdfQVwLWS49Qg+zskv3DWeDQLyV6ugFtXSjt
	fb5dDbIpO//NuBXHjF3bKYus/VxcgmEaHnBFG1CZe3dQQxf6/eJmQVcuxrjTvL4Zo6dhHF3FNMA
	ufQYAudutt+y/zb2IY2U5LcRONjjktsp1p+23jawidk1MUd1eiJs4cmSRCpC3vLuk4qE4N9ILdT
	ZnDYXmW6FoJRP2HmPUmTkJ9iD0pGt8q10DYaUWTxtQ5Opwig6IvgG+KB3DTBsKm7bgIq+pEGZrz
	jjizO0zI4pfAmItErSQuVYSDBccU2kEpQVtSH38fiyjKUB2yNV0q4foWlUPTBja99jpW/GmxIIk
	hFlpM4qPY60Fce7A==
X-Google-Smtp-Source: AGHT+IFIwca2o53gjcqixsgLvQiiS7Tt32GJtgXalAxMUoDDVTzlUHKIoEE5lRjCpBf07TXRPziyRQ==
X-Received: by 2002:a17:907:2d8d:b0:b72:f621:aac with SMTP id a640c23a62f3a-b7671a77455mr763934666b.39.1763862964001;
        Sat, 22 Nov 2025 17:56:04 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654d56a70sm883475966b.22.2025.11.22.17.56.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 Nov 2025 17:56:03 -0800 (PST)
Date: Sun, 23 Nov 2025 01:56:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm/huge_memory: fix folio split stats counting
Message-ID: <20251123015603.fmzmkwxjqkgd4oop@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-5-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122025529.1562592-5-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: hzptimmt1woirrif9e8kkmahoy915g6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 945D6100002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763862965-865067
X-HE-Meta: U2FsdGVkX1/z4ebFlNo8NRGowwahM/Hx+h6sjcW1tBWd8Y4JYRbt3x6Ii00EdZcV5dFAbT3BdngClGlJ68/2HTxS9xYjXnFu3OmsVFptwaSZ4aaivW6keLzBenpaoqIDlstHn6c8uvSOfv0r/RKHFvhnpff8WjxKuaH5V9ImK7C1qADeyVbdH1xiHqEStRRTloJBGUXDo9fCQlJ1KG1aquKULijtZ3FJyOxJh3XA/mHOWFKWCcYGaEz3kS/dMLLXW82EHci2Gqm6j1NBCG4AY5PfMEtWBMX6we7EwQYIcaE4e0FFGzi9xjGrIUYvh4HkA6JVf4iuTjvknamV0ncMP47ayHWinNteAge5iBsQ9HnQVc3+nKOaOX+Trdts9+cBfAjih61ANdBLtaOOtLN30X0NjDNGBGmbjAuzV2T6F3b0ebnxDvTs3ttTGFEICS3G1Jw+3OskgSLbHhRTUxqODhsl/7te4KLdZdgV6rHySYaEokbAS4sokIMWJy51UcHCXjAv9Rjg/diX3pJ4Ov9ZH+5thHvrRmU5ET8ptqQpIcN9Nb/VrBOhxk/4tDo6iLh+heJ/0JQgWeEENp9/j1C7vPjync+qmxDdZ9oEZZiL9LLqbuEmGbJFHj2qLblZuECi/rhTGXW3gkjGo0Zxm4k7GRjTUMrYJYyTFYJtbGT13dkBQE9Mw7tnX1AZ1wGKzUOiuXri0OPAcpsscqQraBqqpGGINyNG73bFV/iiZocIMRe3ZgXgsZFfOcKvxIDmdNb5HfcO/sP1SrmF4svGD/jBpNikj/QZMsjJsMOGV6f8BcoL34mFpSDsJ6W8Cr5pGWL2nZ3BIZ1SFYtv1Sycvepzkp2nNiRuPcJdMq9TnV1BaQRdNqZiUub3xKrW68Elun93uFaMNabmC3NjEV8pzbLTDotW3yWhyYeDoZdvKU2mHceJ99uf6OslRuwc329yGUvHJoeFC8yomBQ+P+RAveZ
 GidppeTz
 xnlnIC3FQCgOSJ7Vcd95yiP/TlXCX6BMe4zByn5WiQpQAl7+9AAbyOemcroFflLXnjEYHel4yV3Tvure3SBzaVQRDRZmvKFAvrwtXye1Z7wCmHQyeCEbLEvbzEEePqCuRlU1NijO/F1d//WgGje609XKiDZtS/jwG1bGakD3jv6cs+08VZI96lIIF5e2/57VDO09IL0Pakxt10/VZJu5ovD2HpNkX4ZCgDlf3YFyE97cUMMWJlkGjLGSJsRlUzTuEKVpVxd1uhlMGD6a6OsabmFAWVzGklo/GzRfwssDltNp8AxiglpbAUN+MFWOQXJDrN5iI+Icfi3mXLcdInQg5Lva+6euUuXN0cuyQsYKXuMqfmVDu2OqJWtb1lKRDUr5SzeeWkSz8e4WxaaxF7wMVJoSoNpWOww94E8wZjN4+3J+jyuWFCxBtunBEiGjv89SIMGOaIbyuvvcU570cJ8hB96BQU/9PFUpfr/y9YhvANmZ09t3RdHymda8eC5V4KtRMOaSVIDMfoi6KUYSNDoDWNCo3ezqnN2E5ckK2e4TCM3DMBvriAkIcs5MzHFpFlvePh+WAnJMmGpECvGZ/TjUQEdEMjKjCjZA2z7MwJlrZW/dwdprAqPEbTexZPe9WQMTwFHBeOV+QkkPWTdz97iqjdRola9N4bV9YTiROFXjuGhElMmqM2P+8qwiCx4ndE8OJaDp3+b3cem5LMFWndVbYzL5Ch9gcOjlDqlsKH79UX+RFhQ81g0gNaKL6cOKjjikKTrbsHrEyCbnK1wogCqPihfSj0nXkSzdugl29frZxJv6sefk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 09:55:29PM -0500, Zi Yan wrote:
>The "return <error code>" statements for error checks at the beginning of
>__folio_split() skip necessary count_vm_event() and count_mthp_stat() at
>the end of the function. Fix these by replacing them with
>"ret = <error code>; goto out;".
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>

Sounds reasonable, Thanks.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

