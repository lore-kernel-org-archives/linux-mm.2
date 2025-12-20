Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7CAE668AC
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 00:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8648E6B0088; Fri, 19 Dec 2025 19:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832B06B0089; Fri, 19 Dec 2025 19:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F076B008A; Fri, 19 Dec 2025 19:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6071D6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:47:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B68D1403F2
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:47:29 +0000 (UTC)
X-FDA: 84238011018.28.44AF5B5
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id EFAC114000C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:47:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Elh1OWRn;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766191647;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqGGiBGIBzqIDXbf6caOhs98baOh9Bc0Em5bUFyjY94=;
	b=vFbKcG7GX6ZjF+AFWRV6XLBrcwuZvoSQahbxeWaxEhX/XFIdmaQAh2ll4BelBdRK+o6L2b
	P/sKTJcP7S949uGd+oF5Qs5kWbts63pLnmYTc84NrquZ5ewzAXnj5Qkpl70UTSxXCi8pMq
	wU3semrDwpHJUbH9JDEf9OwViqVwoY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766191647; a=rsa-sha256;
	cv=none;
	b=ebwuIMEwyR2bhGdVzvD2Q0eJjuEh+2NoQUYvidelEz5krKyq22PJjsVbybJe7IUYDiSeHA
	6T3h3cn0g3+2WJsLgbvH4iXBBDQTiJAsSaEDgnaXmhC+8VlgeHXik7h3Y4usbhekIs9A5V
	hgBTaOL69RE7oAsOKSvIl+RL/JiF79k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Elh1OWRn;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64baaa754c6so1231630a12.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766191645; x=1766796445; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nqGGiBGIBzqIDXbf6caOhs98baOh9Bc0Em5bUFyjY94=;
        b=Elh1OWRnl/iSGiCGIBkAzo8q5pYpBzvB96QZobgHCPzcyAGqE6Yjd2P/YhfZzwQRy0
         FobCeA8ntCyYeutN2jWdj1t7x7P73f9y7mXpBX6juOQEPWQWCRs1bBnPXOBQlarVBOps
         KPIe5GSeRNhagVK42UakHIvBcqVs/+x5vKEpp06DNiG45TaEyAxB+X6PIowNe7Ob4Rw0
         Cim/lBS5lq0KA2OeHTM8oZRljnnSegc0b0ASJiDjk5/PWpa0bXxQ1NdO5N4ZWz2Kf061
         jwY8PRz/t87EFrX6kvb3vsYG9CPi9plk7OEHLtTsMFxKVaMgqUIroCFBNydm+MuqSpWc
         ECsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766191645; x=1766796445;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqGGiBGIBzqIDXbf6caOhs98baOh9Bc0Em5bUFyjY94=;
        b=XzfmsZ17zamZu/FJ5RgJy1VnBRMkTLawiM2VW+AZ5KTaYgzlBITNYRMk3Uown9JpKZ
         hJQssI1Yk6axEN8LlU+/rqjYfkHK9M7jrNn1OhInZZi/yF9jFG3lXU3/LKLSodie9tTU
         irH+U4APtiuSQZSSn8J+fg/y2QtTZOWzP10LfdUJiZO7LvxRtrNQkhaz13JcBfAtt4aZ
         IjZeKrPYIp1odpn/3kPfNghLFYu59nTiko9s9i4gPMODFK4B4bVFaw+Yk1LHc21BToLV
         bFl6GLBYHo4Xm1J7m5BJcHPqaASbADlvkfsPkzmCb7VlF1vGx2APirXbexeSZn2Hf++e
         Z1Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWCv8CG5/ic3KZSL/VAspYbzRE5b4PlaHqNrJ8WsSon6sYGo/b0khGdr3A41EmJ8VY7gJf/u1iyng==@kvack.org
X-Gm-Message-State: AOJu0YwO75agniAW3C0fW5YVC3PGU4QR4UAclVrM7iyNf5sS93gObEnH
	mHj67XzP4V7w8heeaVKzV4vbQaSSeevglesrNVnBUwXBHcgA32uZDKV1
X-Gm-Gg: AY/fxX4SOlryzh3SNFHhcc4uJCQb/oMaGqLTG+uAZIxALnwY9cWL6EXLPA1/eYXs5VO
	4Lfm1R+OpMApk5CnlkBWPkbj0uAVRUXIKl+NAxy+qA2EuolGh4NjXHGbAiE8qXrESG8hvf/NCGy
	z9KtEILBGwhQtneI8iJi9h2JpeWiCY/NNZB4ojYlC57LhLIDBgJzBV1W4wPeATg1OTxZ7F1ydeC
	Jp2T2O/+Tt/uw5UT/qW2WNUEMcOrzH5ri96sM5+FcGr/Sa6ZIl/j11RE5WDZuOHp/Q/CQhLoEWy
	YLkgo/hkKcFrH0zZI1xk1Av2BV1fslIeN7GG9NnrNCSqzzKabWNU8zacGemVg024aQftzgN6eLn
	vHrgozABDCqzy6Dh9xzf/9OeJ+pirxJrCf8N+q7QfU8QTzk5NV9OJPcdR33l7aYQ+4SaU85nqeL
	GRbz8CadgjOQ==
X-Google-Smtp-Source: AGHT+IE3zz/T2eYzh/DpdpgtZ2AxbF3wFfdR861oOsjU+UVc6klb7w7mN+3jT1/xcpdOd5OdzJXUhg==
X-Received: by 2002:a17:907:72c6:b0:b7a:2ba7:197e with SMTP id a640c23a62f3a-b8036fba99dmr438564366b.29.1766191645250;
        Fri, 19 Dec 2025 16:47:25 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9159ac90sm3470027a12.29.2025.12.19.16.47.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Dec 2025 16:47:24 -0800 (PST)
Date: Sat, 20 Dec 2025 00:47:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>, Bijan Tabatabai <bijan311@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, shivankg@amd.com,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in
 folio_expected_ref_count()
Message-ID: <20251220004724.b4akrh6ljreoyg5j@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216200727.2360228-1-bijan311@gmail.com>
 <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
 <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
 <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
 <20251219002134.uqgtnr43zz7vvvtd@master>
 <CAMgjq7DU0U3RVw4cuFeNSSmTWnOmvRF9bQn5oaeZUOvXTVTdYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DU0U3RVw4cuFeNSSmTWnOmvRF9bQn5oaeZUOvXTVTdYQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: rq1yepcez1tu1j1cttxnkmm1rd1da5j8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EFAC114000C
X-Rspam-User: 
X-HE-Tag: 1766191646-248074
X-HE-Meta: U2FsdGVkX18gnUeCHjR2RVFxCToyS8Az2x4fFPnz8mAO+GtahIDZmbuvUevJkh9iC9HvgFa4Ih2Fkjq068i1d8waYtHWamvMUPnqd4NOfYaZN01nMaxLe87SKfTuDTKRNdLD7u+pO9+xkGApWFaamkRVRMnYuHqK7rmqRR/iqPjDuIq1qEs6Qf7vw3ZXhqdDR83LXx2IGYKWsQCNBPtN+2NEma4EiVF8+kar69sFu09V5/6AHEJN34yUPRLFW6axgkfEfaROX9Z/BYFFuQb9evPmr4VNtbwvM/O8VLRZ8Lg5sK+wQg91w7qRN22d9LMoKh9OlXmfLpeXnrS70eMuBOww/1o48zvVSuS0fqHZ2sxyHkZzGGPsAigN0dMFdEmuPj4j7dTGUqunbU3dH4UoQTyhW0B+ZFEPDOSNDCnp+sS6lnNpwz+EeKKzo2H5/US8RGJsOexd33boF0r34bTgjJegda4UiJ1stzwgfE8wla0S5BFJCvrEHHGT3w33X5sbsp/urhWgqPmBL6BF90+iDbBAwwxbYKYVh7FJVK1f5E41c4IOHod5YTjchQqFpXwTmGIqJecnpTselOtTnyV7Id1OtA573vLkNb1bIDVWJj9aq27OM6LOPxMltz9TRj6D66xGXg/Upm8zsGY5ZYduiKSUOZ4aQVybEylhxt265/PVhwdU4aH+pkpxV7yiwoIXu7k5cPjUu2VQqkXPUBF9/tRH2PpmanswRcwjFPaCDtzOP6Q6tP+sG/StvpsK7BG+hQZ3/TbnHv3G5iJYKFfe2qMRT1L0pbtDlhvrcXoneEX9CR8qPjgN11irZYHuK/YfkrjFTR4CleO7E9ip/Wxglt4IrMg3Kq2qJEcib4SVUqtRFbTbbNLJ9WbQg6OAdQOEH8RT3tn8i4mPp0nc+yPNzmmNq8eg/yyLP+ZFG3zb8q1sSBBAmDb5vDDnKaTp8z0CLafyTVYd9GI29jg9v3m
 vaW6QVrn
 44VDwtjy1AMgv6BaZyldfFTOGmgYvv6RxfMoQ6ZTYUkhXQpZoFGmlSYdVWS4+hOccxH34WEjSE0/PgBAAcfEIcjontCmeJIDSXTnOgxGAmEhFW3UXD4zuheSdJiP95BdKsKKs8J4ys5PFwIDYwki1ZK04cEHNKEOXwY1Kowel/SabU4sTh+wGjX3LIqMKwrr4FCTdgCzjtsMGDKHaHHQey3TSHBd6iM0PQqqlCWIBJsyfkzYpxrcqi/9dCojnvIX2dnIRiec6VCC1t5Z7tPCbdDPuNCbb153I0yrQR78ji48Ag0HW+Id+A410mHAR2qhq0KmarCQp39JfS9LqUtm0nUTQYt+IR98YWMcOYEWH2BTQfHQXgGTJaTQIVvs56m1S1p5KUdaZr80Hx1q61fRFIBGs9dS+lj2y88qYJtiq/P51iWZh8ETetcaVtNofcmDK+cYvoyky/xcV3v3U/uiNK1qlf8cMGis8UhDL2gpt/FjUluXZ3PJ8apyczg9oEgNBGmU1lWjl+mxrl50Di9JKFRtO02C1f5X0b0rB/CfAa7ZXIJhPSO+AzJwR21oR6LbvRyQfuSaojJO5F5oX9T/DRnKrDxr7dvlIZptKp+/sqtVj/CxhXE+J+TTSR1Q6wKqWbU+kSO7RThk9Dn/L+/ExYecgc8orMT+V2Cgmcr3CaHaH0DSJDkVCo9KBAZWZb/DMrAEuEkxfXqJfqX9CxHBGxIMoNxhbD9kw/7A6R5GS/8fDcR6uGiYmruP8bqsK+p/2sJdxm0TeAVz2A3LZX93Q9ZwKdVVaLkAPtKn90QEjcgQrdgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:35:05AM +0800, Kairui Song wrote:
>On Fri, Dec 19, 2025 at 8:21 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Wed, Dec 17, 2025 at 02:04:16AM +0100, David Hildenbrand (Red Hat) wrote:
>> >> > >
>> >> > > I am not very familiar with the memory hot-(un)plug or swapping code, so
>> >> > > I am not 100% certain if this patch actually solves the root of the
>> >> > > problem. I believe the issue is from shmem folios, in which case I believe
>> >> > > this patch is correct. However, I couldn't think of an easy way to confirm
>> >> > > that the affected folios were from shmem. I guess it could be possible that
>> >> > > the root cause could be from some bug where some anonymous pages do not
>> >> > > return true to folio_test_anon(). I don't think that's the case, but
>> >> > > figured the MM maintainers would have a better idea of what's going on.
>> >>
>> >> I am not sure about if shmem in swapcache causes the issue, since
>> >> the above setup does not involve shmem. +Baolin and Hugh for some insight.
>> >
>> >We might just push out another unrelated shmem page to swap as we create
>> >memory pressure in the system I think.
>> >
>>
>> One trivial question: currently we only put anon/shmem folio in swapcache,
>> right?
>
>For swapout, yes, the entry point to move a folio to swap space is
>folio_alloc_swap, only anon and shmem can do that (vmscan.c ->
>folio_test_anon && folio_test_swapbacked, and shmem.c).
>

Thanks for this information.

>Swapin is a bit different because of readahead, readahead folios are
>not marked as anon / shmem (folio->mapping) until used, they do belong
>to anon / shmem though, but we don't add them to the mapping until
>that mapping does a swap cache lookup and use the cached folio.
>

I saw this. So there is some folio which is in swapcache but no sure is
anon/shmem yet.

>Also maybe worth mentioning, swap cache lookup convention requires the
>caller to lock the folio and double check folio still matches the swap
>entry before use (folio_matches_swap_entry), folios there are unstable
>and could no longer be a valid swap cache folio unless locked.

Thanks for this notice, will pay attention to this.

-- 
Wei Yang
Help you, Help me

