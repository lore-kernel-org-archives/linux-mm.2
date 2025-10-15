Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF35DCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 00:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD8A8E00E8; Tue, 14 Oct 2025 20:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE848E0005; Tue, 14 Oct 2025 20:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4328E00E8; Tue, 14 Oct 2025 20:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4358E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:45:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90179883B8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:45:48 +0000 (UTC)
X-FDA: 83998505976.15.92331C0
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8575D18000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:45:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YkI320q/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760489146;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjS2vWmWFupijvTyxg2fppwPWWk6ldlFSBLrc+f8lsk=;
	b=BaJJdvhHIuaOxW6vKUZh7wKr5Mwb8w56jiqyE3iFHkO6k7zz96P3S7DZl3UqwYYXDu6Q2l
	Z+AS0Ae1N+mpaOGII7vnFhSo+JNmx+Szhjps7Pf/Bi1/uJ+AkrcLAk1xh2az+uXUSne2xX
	ywgrkpwWOKJoF1VISqOkUQhq00UI8oQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760489146; a=rsa-sha256;
	cv=none;
	b=DjWh0g5tZVB2nZ0lDB5j6ak6yE5tvxrLwc3Q1krctV0lnt6SiuS0obD7Uadt5l0xER0wiN
	jsJZAgbKHi181UY+VvQLjaLEEc9Leb8nAcUbYVrRMHahaYwcdXBR5/l/9BP4M1nViPRG3A
	KOj7+IvwUk35DICRd4+W1+jKy3CqPvo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YkI320q/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e6ba26c50so37641425e9.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760489145; x=1761093945; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JjS2vWmWFupijvTyxg2fppwPWWk6ldlFSBLrc+f8lsk=;
        b=YkI320q/Jyn0wuFj4TaTj7cmBU1++aEqFrSuea2w6rSex6wAFrZ/U4ceZs/NZh1bEj
         CHXuMMWs6jpTm3+tqzLpTinDsuZ3woCJJXAZH5YJQRJKKt9iuKOA5RjVZ9w5NnyGcbsH
         E/TiPoyENIdQzM46hcOKwVewvnnmYiw6EZ/KSX5ZaIQdvKpYJIslLz+LIWQrv+lIOZci
         cCewEWABzX8UFFwikoRq8vVOpsettuwtayr0UeqPIPAH9WGBNFYdqbXf51RphdKrQlxq
         UmmdwMPqfIgubVVyiz1/jw+MS4TDG7ZhxSqaMOIWAtjOCN/QeokiEuZaA+07i3iVRMtU
         uIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760489145; x=1761093945;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JjS2vWmWFupijvTyxg2fppwPWWk6ldlFSBLrc+f8lsk=;
        b=nyGGR+eClTOXy3MFZzJGinOVX/mzkIjPkWEt8b9SdzurcKyGaeYk3K2+rLcXUT+xqd
         b+TeGiyYVM296+i59j7QR8me8rC7wFtcouqj254RzuKuYnUh0LOhBs96VWtyuByZhjcr
         VGLlVf0PnVXg6yaFHJCnMwhiiw6ZwUUhx6REYa9btx1oMCymTpwL+kwd0qqD+rJVi7nk
         Jh0QyRfn0z4SNzqw9H4ojFmHbAuIqTvWP6Gwah8Ah1FqCT4vMI63UrgANdJigLz/r+7E
         wmW89uZLQ1KdEyP85I5giVzMa+YJwtsBEQHizCPVZ29L6crYVX0Jdd8rlRAwgl8Fpu6p
         Axzg==
X-Forwarded-Encrypted: i=1; AJvYcCXgtIyyjmqTMsyzjc6fMHFmLyh+TVO8JTtMFyOocGAgB9Gp3ExwN9nyl3ioVlQsBoK84Fbvw09ybw==@kvack.org
X-Gm-Message-State: AOJu0YzJ+zDBroOT7cfa8V4+3jYs5a+Bor/r+kz8VXwX7jns2F7rppLn
	6TcDMmxt2G1SqmtcQaIcPoPCQf2+UoX2GRvYiOF58/yI3crN/v+Kl0AU
X-Gm-Gg: ASbGncurRew2MwNC6Fv+ys9cun3sySFWfam/gtV20pS2O1M4jNHCBt8eshb9dzMdhXi
	OuQdLtkmfSh/ZQoYWrHim6mekdQ2X6gk8W5F4kzH+DdEQJhYT1P/T71cicK1ohPiJQfAU6fOIIu
	4vpJBGEMCimUzPz14gb9pTl7Bkwih8yinj5NDDCZqxKmev41fgNWJwQfy0uEj5miSgqHV2U1bq2
	M2rWmaPABpp+9SyEXRVP1i9vSCJpRBVffbNyWgZgmR2x2rYQp1d7iuuB1/4V4YSYQMRawR9AYMs
	kxVVHlTp9Ls8PBrSvMjKB/nCULFU5MmnOWp9K9uybNaIMH8uxztBxAm7U7OW+VbRlHoeV3E7Gvt
	yjAz8ykJtQUPWNDmzAsxzJFAbP5EFkAgZKm6ZhmooAurVRfY0qY0=
X-Google-Smtp-Source: AGHT+IEUsuN0HzcjvOiasKjxoAVXbiNobka2YXSRTY/9Up4v1JrTdSmA4WVnfLZUCScJw93cZ5lkow==
X-Received: by 2002:a05:600d:42f2:b0:46e:4341:7302 with SMTP id 5b1f17b1804b1-46fb15396d6mr133011165e9.34.1760489144718;
        Tue, 14 Oct 2025 17:45:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fc155143fsm220567755e9.11.2025.10.14.17.45.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 17:45:44 -0700 (PDT)
Date: Wed, 15 Oct 2025 00:45:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Muchun Song <muchun.song@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 20/20] mm: stop maintaining the per-page mapcount of
 large folios (CONFIG_NO_PAGE_MAPCOUNT)
Message-ID: <20251015004543.md5x4cjtkyjzpf4b@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250303163014.1128035-1-david@redhat.com>
 <20250303163014.1128035-21-david@redhat.com>
 <20251014122335.dpyk5advbkioojnm@master>
 <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
 <aO5fCT62gZZw9-wQ@casper.infradead.org>
 <f9d19f72-58f7-4694-ae18-1d944238a3e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9d19f72-58f7-4694-ae18-1d944238a3e7@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 8575D18000A
X-Rspamd-Server: rspam02
X-Stat-Signature: rnfjcgim439m4c6x3y5w1wfjofycjtoh
X-HE-Tag: 1760489146-74246
X-HE-Meta: U2FsdGVkX19oAahGX0o1bcOs11HT2mfrrUtm/lXq33OkViTB2NIdErjdvwZlCJ315FBrRHr+CRZ9NH0xepy/L8Z/ub/mPuP2gKx2Dh8Kc48HBLqIsJbAGM+O8ZvQH1b4Eten2L74KEd+RjoTqzmO626hj2ZJFA0HpStjtP23r9buZXaoTRvDiF1+cmGN6T7lalklqyR1XUhpZuBUmS3arvRa0dDbB3rOo9VObciX7VfqX14LSp7dWDJM9y3ait3amabv0u49y9KBSxpEaiPaRANv8utb1gGDAe8FfJ1AlwpKT/UHSAkK+ElzFFiKHlZw7yykc1uXkYBrxsSYiYKBf220/04f8qJLVSfl0Pl9IkuowLigtyvf0t8n1seTfch32C8nIKO0NC2mcxrKC4kN5oHugJ0US9CcV1UdqVopaGYoMckLMWnkGKsFwtMj4U2McncUw7BUSmKIVUZkESD0+mLRwJbQHtr8zjYb4GxNiHd6/LvzsPI0vhQyo9iplnXtIJedq87+hqaiOv+r0yR4pzy3aeaLFrOrqYwDj0cfYQFTY4o7TOJ5bA4YDzmohQ4Zt2Ew1K2RyyeWNbasFJGCJEWtrjHeX+YruD93V828zWYSNRPtmg/EHDZuar46sv06qQ12Zdb8qgWQIo8eQtFLuP7WDdg1SigvyNE+OMPRE1HhHNiX+HD0lrvNIdEk7MOaGAYD9w/tobbij1wmxH5OWiJ88NYDnikQFbVnCXF1NTS+YKXwiC7fZx8CwMWE//mMtgVzViVXS2DudfiJ93Awmte9l40Xfu/G0R1GfROyYtg9HP1nR+jcUP0m/z0bNC6SmTOBeo7OAVMbGQ/FLHN4tOVUZyOmhkvDKajUfRIoWe/nzWZ83C/gxKsYTI5iOxrB0UxMzqdDAvEQzQj4/0mjjoADcDFOkt1oQvomCu4dy/bGe5CkgD4vrOqRXdqiD5xcMRkAjWa5fF46u1GOuls
 PL9f9fac
 mF+IfQY9Z35LUXfF1YYJw9fT7NnoJFd0jNeEzMTBmCJUSo4hatfRosYZFi6QPhazP1F7IE47qBkXvZEJgsM0WxgS4ARuu/v/Mti10imULg8RUn31T2PTQoamxGF0/Jl4Mg/rK1OgcVqbGTE/OAuJ226t1y5UT3oPTXQDY2CCDTClIhbAIncP0P0UkwRdgD5HkeYae0WVRmbGnnrvp1M+iL8g9aWrCOG9p6gPiWLRVZVNl0nm89ssnv8L5upJ3zy9ZChwVD5SKRzKqkqKcV8wTkoCpb/ypuFVGannLhzIisIeyDX2NK9iVQYwpGAnFfirf/C/43D0MrlgTgi6sBVvvInJepMwK8oZpLV2yvBQXUcfPvCBE4hI23zqiNktW552USBTx1z9+KCcpdOLYaozxCcbhteNX7h0spniri8znenR+KxJrhswTAafPWhDiorOjvAivDtrBn42brl0OmzAsgV472tbIU2JIVGSsxHInVeW8fWYS3m0/0bbHMmPAtCdi4TI+a7Onc+9yWcx4697uiXOmxNptwB3GwqUYHw4gob+r3HWpmRF07c5DBCLn2BlhouTAnRrOazc3hbXeqL81IDreFpxvAzBHDymZYghXWIVuK0NLu382gzwgmeefQVgtBP/XwmREXHlSYdmk+Sn8mfJoEdxyb8Q6ElOhbkI2vxu8txYVmWC4V4BrOuTGZ8Gu2b+plqMXwySYGxTSCxVyy4A1nDQ2/isbENc7x9nNBAawL8CeYY26DemDBRkw0d25ZlOA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 04:38:38PM +0200, David Hildenbrand wrote:
>On 14.10.25 16:32, Matthew Wilcox wrote:
>> On Tue, Oct 14, 2025 at 02:59:30PM +0200, David Hildenbrand wrote:
>> > > As commit 349994cf61e6 mentioned, we don't support partially mapped PUD-sized
>> > > folio yet.
>> > 
>> > We do support partially mapped PUD-sized folios I think, but not anonymous
>> > PUD-sized folios.
>> 
>> I don't think so?  The only mechanism I know of to allocate PUD-sized
>> chunks of memory is hugetlb, and that doesn't permit partial mappings.
>
>Greetings from the latest DAX rework :)

After a re-think, do you think it's better to align the behavior between
CONFIG_NO_PAGE_MAPCOUNT and CONFIG_PAGE_MAPCOUNT?

It looks we treat a PUD-sized folio partially_mapped if CONFIG_NO_PAGE_MAPCOUNT,
but !partially_mapped if CONFIG_PAGE_MAPCOUNT, if my understanding is correct.

>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

