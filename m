Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9245BCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40BC8E0003; Thu,  6 Nov 2025 21:15:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C191E8E0002; Thu,  6 Nov 2025 21:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E1A8E0003; Thu,  6 Nov 2025 21:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A145D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:15:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48036884DF
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:15:41 +0000 (UTC)
X-FDA: 84082194882.08.F0AB438
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3EC24180004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:15:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BUJd/Tg3";
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762481739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVK751XGNfAVIopDso73Iu+BIYsWXXgOr03CtpdbB/4=;
	b=3bNzKw/g5Z3Z/2vPKBggR09+Jm/87pLcdmfgznSHMm2/9o8ySKbjf3nhgBmN5mW6DszGBo
	0Ar6LJkdHWz7X4n/eDrCM5qkhBRWU7FTrGOPqy0Nzmm8KRJAYyqvKjFBx2Kn7EjBIiCEZr
	oQP0Zo9vTecbg++gWCroqrVLYjDBirk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BUJd/Tg3";
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762481739; a=rsa-sha256;
	cv=none;
	b=ZJiuFQCbZTHWA5GQpw8bYtDoFfRCyjMFUBDu5ECNov8rbq4PbEcS16dJwYZfLhLEJVtncw
	JuiftWrqGC2IyeDcisBPEd5ppfQnJdhfe6xXGB+Y3ajh3HZEIwrTo5afYo68X79QEPv8z6
	2C9g/+HX5d+iA2m1SQNI0NpUXIoYbpE=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso509710a12.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 18:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762481737; x=1763086537; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVK751XGNfAVIopDso73Iu+BIYsWXXgOr03CtpdbB/4=;
        b=BUJd/Tg3xjpohMR5l194Se0uTRPxJ0u/JWoDwzxV2DrYi2SPG0YRGd9DB4P8rORTfW
         tR0gqTSAcebyF4yYtA6VnRx9UnjmUPahy7Wnh/aqBc+ndwQVQwvI8DwKNRVM8c8SOgvm
         g4Vy+Znw8x7ls9KzaY5JD2qJVem2IjA0vC0DWiA8/O9xT1zSblCDooQkBgbuDpzaBwSU
         n7a6abAQtLiRHxneKxNNd7MxwouQmCMmjQRz6aqNpuMydeTelLNxd0DnLfNe4HlqpCOI
         DClX8ODH8Fwf1ce/cwbS+DYi/px3ofFsadNzjSODMmZdWbpqycTQ9zW/2r7gMY/2Mu34
         P6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762481737; x=1763086537;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVK751XGNfAVIopDso73Iu+BIYsWXXgOr03CtpdbB/4=;
        b=NcEa5cwwvP/mBN2zGBRfCW3+PzrFFKsUR/yTy6rSCpA6gKMrj43mjGZGEr4r0dr/Du
         73NuVgGSWnZFxbtDVJ/VCXS8mI7g3LS3I7Qk50fUbLsMno5lbEy1xNxUA7bQTLw/mVZx
         anou0ezoVdAYrF7jlbjhrD01IaV3Tqd0ERjlAoPZdo2eR3Kku0+OMHP2zO6HuW5QMzna
         i83Zj+B8Xnjp1bNDpQNUhyaTJqL7xPCUgsdHjFQ0RUajizXarf8PnIlBMu88jVxRWIZt
         B+j/P/ZqRHA33jLm9zBuoEV4QM/5m+gdmUWTyIWmZS4UZJNMDurwTGUzg8JBW3QYUknV
         aXzg==
X-Forwarded-Encrypted: i=1; AJvYcCWHKrvC+lnM3WqlSj4H5M9ZLf2T/yrUDeF5Wb+uhoJvd5UoRD+v+PCZs08XfZ3GAGBsuEMUmcCKZQ==@kvack.org
X-Gm-Message-State: AOJu0YxF7FVHRWgWPknKpQYBh4UuHYDQMEn9BdyXyXauF87F9a6a/OiI
	AOicFueJze3VvO5lz7Sgt4n/a1o9ZFFRO3psLgVUOPPKCCr+NVvA1BNy
X-Gm-Gg: ASbGnctclcOj2MsImiEPCQBe7EyAIQebJGtPdIBh60ah815Do2SDHf3GEax678lLSf+
	jQBJZ26gHmRrJFeqXug5MkdJlPlRvElDua69fequn29mL4nPoLmtoioael1I5zOd7fEsIT38LNW
	oeIM1KEhmy6p6lUSbRzdEaE8gY9b0t2usBgSdGy22i6wwdDDjrBF0SNOp1OjKyqMqpbCtzaPIN8
	N2CgU0lauyGLiPOwWps3g4LbkZqC2mxb7ECz3aB+sjGjkpdZuyGKbA2oe2o5t4nTfrHINEX+AhK
	Ck9u5eWP/JQFzX7Hp10XB46kXCygPEcn5xs0j9zNlhjCmjKXUdtFv0NLKufvr9qThecWnpZ4RO3
	E2a7dmCDTKNSqdGwumOHX9vILFPtviDQh4sTBMl3yRDCfSHsmalALw2KqUQ2kkDq9dx04m3kjtB
	UDYg5NwBV+EjF5v5sJt+g4
X-Google-Smtp-Source: AGHT+IHGLbP8PaO+mVCuoaK+DUwD1SXlvUFyS8du3A0VYiyjcS9fnkZcI4Km7JDuworbp4twuJtXOQ==
X-Received: by 2002:a17:907:9608:b0:b45:b078:c52d with SMTP id a640c23a62f3a-b72c0a6ee74mr132792066b.35.1762481737455;
        Thu, 06 Nov 2025 18:15:37 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97d3c0sm105496166b.36.2025.11.06.18.15.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 18:15:36 -0800 (PST)
Date: Fri, 7 Nov 2025 02:15:36 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: introduce
 __split_folio_and_update_stats() to consolidate split task
Message-ID: <20251107021536.x572tum37szc2llk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251101002927.2610-2-richard.weiyang@gmail.com>
 <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
 <3b098e0f-7632-40b7-9201-41a1b5b0ae42@kernel.org>
 <7870dde4-801e-4bcc-bb92-7b75a6a4a4a9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7870dde4-801e-4bcc-bb92-7b75a6a4a4a9@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3EC24180004
X-Stat-Signature: kyoeju8ph3coskttjygm5c8zhregpxxe
X-Rspam-User: 
X-HE-Tag: 1762481738-648778
X-HE-Meta: U2FsdGVkX19uc/UNGrlZ7KxnYxvomqgolHuOsfgo15Uxl0HGcUxvZ91LNKiCoz24nPh8VXXIXtov4cEbdDpD1XSRJFjncdO0mz05yiL8BlyEYBv2HxiNCIpDFdeNjQihfPA4wykE+0+gz5Q5vH3gVZwIiPSzAP2i5Eh1Tl742hfl8HRNU4JS59Q4U0rLetG2Zr2LlyeBkWMA4VfTKRYKUdDiZaSyZeiaGgoltQKajYj74FG0WpN63NvjNJOj62kfd6jgOdyXO23JZhwnzIXyJKusNvhG+iLvgr+Sp4DcRn3yxuKW+KH0dY/P/M/HnOtXwhUDkGq7Nk3VDqEG/h7XmRmICMjSQU8OmCCpj1IbljnW5KWf093SaOySKysvDCZaZ0iZdma2a2EikGBYDWbCEhqCIo1d0e9hnwUERovNYR07jrP8qTQd35SDKlF4WLGRg0lu9y4bE3kASqnWca5nxS1xeprSnWoHdj1j2nN07PcqUh1xnAgpFcJHXh9pHRh7mEt26AyTggw2a2sRxlxlp82j8YSTuHRtHbbRVDbZw+TOBu9n1O5aobfVRzsE/aaWszbiG4AJZshMh9QEfAP+hv21dcTRrWeVneuf20K8B1XOtaEWFSTpJkJoOXgGEcBG/PMBqvDS1v3xPv11wcA7TjORaqJfg+AgQFJQ6eLkyn1ns349K4zVsB7p3jzFo9u2GICSs3jUqQO5s6QCO55lbpKZIEPazy2QMu1qka7QaaphjPWB0SaPGtinqntt7fkO5kt+BfX/3vJ78Yy4B3mN+qMYhJCdp5fMarRyUmS1WI+TFfG7Pd8xyu3x3aebMX3O+IpjVXd+walTcfu6v0mn5gg7DGUJq3/6UDTvy9DfBiQIhnT3tfqiEACDr1dt9GQUocNvdq2+oxcm0UvsnyjntI/Rf6MhTp2xWwASYd+7dpnFXwHUmAEVPz8T6xMHpjLWFR8XKB5DAKLI/gZaw4F
 JdDG4K0t
 fwz23rVl8gvCJms1P3jr+lQ0x0+6WyheE9RWAdSVno39RtOtuOKHHxG5GDqY2qMKJWwBJOqdhnzOjrhzbza8EEb0KoNTgDKzgoBdl49R5bbirzmpxRoHruPpoZQJBFZCvZ5DQfpWL9aF/+v8jSmf471OIym+YQ69mLmqjcmWsV+IJjOVp8a9NKWiAZAhEXpmbILPiKObB1ZCSGPDpw123oN1wJQ39MbxKyXg7TfzLMHuUIc6VcXPJzVhia8fXy8JcFuosOWzIIkOAIDvd8gzgFhNP9/eyoQZgvC+mGb/p/iwW3MimsgLwpIc+g5mfXwMDopKuUDHGwM2rIrsU5gMfz593fBXVwUYhBEiRBbnq2xTqWk5MEfjD7pUXNv8wgNgHPzVga7pOsAb8NlajIno3QZoXFDjHvmfH3c8Shd6OEPOj/NYoTd1CMjyY3wmGf3LtjJLfGlFbB+r5Ucq0/I8DqrXejP2vue/HmYfKhgnK4oNXUOGJdpjSoTu0n+pBArNMRJcEV/+pE02yqm2GHxcy8ztcsmjlMKbZMGmO4KpCcQ4mquhmeymbT0jKZ9ZlfU540MOVypcFB+BUOSwgYt0CRNkV/DZsFmDosZAC4k11OSxWX+PXhBW2AMAGVujhub/kPQUI4ATrCKzWQrbR+0iUJlmbTxn2rgw16luxEMQJdkoH3bMs/TZCVvAE+4faL3rgCN6isAkqN+xL9wlYoZalfV1d//9LlpoHL3865nQIm5XodmApgXefe+LnbYKuB1qRL7KCza9Z67DqW4s1274ThLHKJp1echYZ1JdIQEgAaPuyeNRKqYZ6cBFHEq4zQ+o2mMBO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 05:22:10PM +0100, David Hildenbrand (Red Hat) wrote:
>On 03.11.25 17:21, David Hildenbrand (Red Hat) wrote:
>> On 03.11.25 17:20, David Hildenbrand (Red Hat) wrote:
>> > On 01.11.25 01:29, Wei Yang wrote:
>> > > The folio splitting process involves several related tasks that are
>> > > executed together:
>> > > 
>> > >        Adjusting memcg (memory control group) accounting.
>> > >        Updating page owner tracking.
>> > >        Splitting the folio to the target size (new_order).
>> > >        Updating necessary folio statistics.
>> > > 
>> > > This commit introduces the new helper function,
>> > > __split_folio_and_update_stats(), to gather all these tasks. This
>> > > consolidation improves modularity and is a necessary preparation step
>> > > for further cleanup and simplification of the surrounding folio
>> > > splitting logic.
>> > > 
>> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> > > Cc: Zi Yan <ziy@nvidia.com>
>> > > ---
>> > >     mm/huge_memory.c | 28 +++++++++++++++++-----------
>> > >     1 file changed, 17 insertions(+), 11 deletions(-)
>> > > 
>> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> > > index c37fe6ad0c96..abde0f1aa8ff 100644
>> > > --- a/mm/huge_memory.c
>> > > +++ b/mm/huge_memory.c
>> > > @@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>> > >     		ClearPageCompound(&folio->page);
>> > >     }
>> > > +static void __split_folio_and_update_stats(struct folio *folio, int old_order,
>> > > +		int new_order, bool is_anon)
>> > 
>> > Is there any good reason we want to pass things like "is_anon" instead
>> > of just querying it in that helper?
>> > 
>> > 
>> > > +{
>> > > +	int nr_new_folios = 1UL << (old_order - new_order);
>> > 
>> > Could be const.
>> > 
>> > 
>> 
>> Looking at it again, and that we are not reusing this function on patch
>> #2, I am not sure factoring this out is really helpful at this point?
>
>Ignore that, I was briefly confused by patch #2 :)
>

Hi, David

Would you mind be more specific on which part confuse you?

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

