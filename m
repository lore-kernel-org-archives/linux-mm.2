Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92B2CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE358E0023; Mon,  1 Sep 2025 08:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F4E8E000F; Mon,  1 Sep 2025 08:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC02C8E0023; Mon,  1 Sep 2025 08:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D78468E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:51:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 739B811A353
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:51:31 +0000 (UTC)
X-FDA: 83840667582.27.602F373
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E8DF40009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:51:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EKZ7TBcz;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756731089;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqF+hZbPh+nXreNj4wa7WGyYViBQF8JL9gx4eQUgXJE=;
	b=32bYNxesgtI/3rop3N7bsyLLU+HjCjtw/0Hxrak2exJYzZaiZZwMBsXNgXFy/sr3TlrHUC
	s4AfI5GBlj9GK2IkCXneY4MvytOwWxKX2pO0Gv+BIS5Yi9bbGXvKFTIDGYKG2v4mM+rHYg
	sfsxHG5dRX6QtaPJ6TFCmtwm3TdEBzs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EKZ7TBcz;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756731089; a=rsa-sha256;
	cv=none;
	b=FvFKQCn0lyyMHMb665SKKCRIdg67aBf7NAC5r3vjP6dkka00U+13CB77BfLSvKdDex47p9
	RGSYFFmPtqzkGOcoXTuDiYrapTOlUuiv4rXZYfnTrKwB/SX1KQqo6sitKe1gPY9TQRZOpG
	UErfm2Htko+8bcvcjj0YZlhDzFRGFuw=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afeec747e60so648291266b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756731088; x=1757335888; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqF+hZbPh+nXreNj4wa7WGyYViBQF8JL9gx4eQUgXJE=;
        b=EKZ7TBczP/WpZ3y6geSoh93Q3h1PAmhd4Y/0AXBPns+QjFUteznV/4Ah8XTPCfqbgg
         P0rvpPINzfDRPxo6tXEjxjWhG1Pqep7yghXUoZv1xVzVPrg0NZxg+j/kiPo3rAkpu/ka
         sIncH/j2551ijxxOpRDxvrnCGlKRSTVDST4M4onxLxJ1S9GmUURqCr5AY22Q2J7UDokK
         +Di7jpg813Nb2dhFKyjN8tuWY3w5mTR5c/MTNRTirEYT5iwOIuGdDyjobjPZ+Y06yabn
         suNY4c2QPos9fZV+P+BSJxHjNXfgd7jt9npJcVsO/zEIovoVMlJJjv1JrdJq7Bu2RiOC
         J3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756731088; x=1757335888;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rqF+hZbPh+nXreNj4wa7WGyYViBQF8JL9gx4eQUgXJE=;
        b=YLKETD7KsBW1GKXq1ocSwVepCPAnaj7rT0BsBWDTfNFYMtRA/qvbQMTIa7+UuacbaU
         SkLrmO1BEchqaOEKBHWf1XJXvh+q47QRGnXnRn7BXwolAj1EdyarsWP5PrQ19GJspZlj
         yZVHQbSZVi6mZEaItd9Z177566eWURo7Xaxn+5vBFoOP72ctI9l2TR4wouWO3g+i9oK3
         zpLxUarT8Nu1Os39BtWQwnfiBX3ziB1+6NR1EHIckcup9YrUoowIUNZsOtL5Lrd0S/2v
         543puQ4rzo3unaccZts+QQYDIhKSWR/nv1cl1Zc3WGc6P/88mZ+/QfBAoKsuDo3S9gke
         Pq1w==
X-Forwarded-Encrypted: i=1; AJvYcCWKYzB35IHPoHXumhQ3/m4FiKf6k6JJYyMSwe56zivbqGOZkiCW6TysVGdEK7REt5nhA2SIMvj6nw==@kvack.org
X-Gm-Message-State: AOJu0YxYvp6HwG/is8Aqq4FKO/BKRoPsZKfOZowxq+4sw8KH1ceG3So4
	7nvD9EINV2WAsgKO6J5OjZpSWPfRuwv02GHTKECpUtSDNkCdm6n8b4B5
X-Gm-Gg: ASbGncvGEYXn1Z81lOwztZyEnShiyHZxBOAsx02G2uXWJGhGLQjaCbZa/sUF9NESicZ
	8Xw9pB62bYGrjOo96SaKSn6q+JJIVGLiQ36btUnmbPluYlXkWMnM8GThOM9gmVZ1mfq1TfeEQ9M
	t0qW0rSYMYxrEXnJ8oAW7FLZ3VKjf++lZBfAplXOOxBntT55ATIKN41CLhMt0D26bKVAE6XVnLp
	TxK5NJOAdWKEFdGuYoWNWXk2drXTx9qKSUD2BBdThCJ1R40yEDLxF8nybrIXLuMtjojdCrCczYY
	PJOHpJpDaizKRQXrvuoWfbrdQ4U6uIUyrYYFx0M2xrQLQWwhJ7iEDoXIxXD3tTLFhlXQpm2p2d5
	fJBqHUGPHzszg+/jKZ461DSlnpUghWAsASRk7
X-Google-Smtp-Source: AGHT+IHvmHfcLHgFlGk/m8KuGlVWmwSTjF/X+LrwDzuawwRSwyxbRGkBHfPGjI/Zz8OpUZfMC+cDWQ==
X-Received: by 2002:a17:906:299b:b0:b04:25e6:2dbe with SMTP id a640c23a62f3a-b0425e63044mr395870066b.63.1756731087624;
        Mon, 01 Sep 2025 05:51:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04148f95b5sm419796266b.92.2025.09.01.05.51.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Sep 2025 05:51:27 -0700 (PDT)
Date: Mon, 1 Sep 2025 12:51:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: directly add pagesize instead of increase
 until page size
Message-ID: <20250901125126.furb4fkgim7adzhq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250830023102.14981-1-richard.weiyang@gmail.com>
 <E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com>
 <c89a9096-716a-4bbb-a911-99096ff8f0a0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c89a9096-716a-4bbb-a911-99096ff8f0a0@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: c68xehj36eeiz78smcj4yzhgyqgww8j5
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E8DF40009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756731089-520452
X-HE-Meta: U2FsdGVkX19zOLPkm0InzR/KuL0Hy5gBt/ODCgaOHEeLgP7vn1bAdLS7HmURUOlH8YuujmJjzP/bnRAOhIEoPjocl3RoUKaNisnwmK5PB8Wk/BIFXsGefot0ItWYvZ2/WIxWkIbdFZSFN0O1XQ7xhzfjlx7J1dlkbumfZWwVdRzMcwUX7nVhPTLcTKiCI3xEy8q+tli+roWiuFqvlPtY2n9JnG0EeKMxmcP7MRs+P3g5GZAmXSVN5iDXUdyFG4hAIOJSDfz6aiOC2fQP3gc3KFRqcaTJD+JOcw+f/NEI8ArxrtLVTtWfetILUx64Zf/cTem7GuJfJT/2htJnjhTyb6jIZB4/fDDznecRB1opAKjM1/GkIJX9vYOQpyrtwR7qOhR2hzwbVAQwe+nD7U7sCLLjloMSdD7qHXnylWj9eCFy5oemBSBctI0z8DuL/JP16/5iNofe3pYAlcz2WyUkXOAU1rEW6EpqCbtvlxMJ4OUeX8BUWNOwy6syqoez0xhRHlkuZDYMj58i5iaPUZ7kFpokYOjEsIlH5lebdKv55+A2WKunSKT6vQVJVRA0rseilIyJ+uDYdfDOZ4zooTCWAtMcRvh0FEkRWOezyXE7FWiFjngRSKUdVXG4cnCK1JVpQMeNgtjDwblQHRaEcUIDoSJXvPYYHUt82pJwPczRwlq0CGgqEBbDJqYv/gQDmgM4wqv8t6FFNpIoomi66N5CksPMzhZpXyMHU2IemkWIRwNbHLiUpSA46gSfv1fjFS+gsejFwyCIknkkmaTJMcmy4z9qKtrgQRfruJL7F4myh1hNiCQakMoqD4hwQYz7W1msWvJ4WremHNKsyrXUgtKMyt/y+d1NbfeTCC6Q3Wmfx4vUIVPhRlOVuc4v0IXuUhWY41orTEdweppCmYN1LY9r66LzdUdorYPwICWtrVm4HoyxZrSqUihHuhzwkB+uEOOb6PU8u56hXUnli04ucgA
 3+RbOlCc
 gXsjc1IDCisjyP6MH2gHfqOOFzRmeSKnt810Yc7FtrjdWU27c+OQJcLulgkLKTtaKRnujGaRmE/ZLvc9HZZjmR0S6iHNZ40MyD0ohPuFeDIjrJZUba2e4RkBH9UGT6FZu3gGUmWRiaYx1PPfCd6QKCqikCaLQGL62NS2i1UTVj4ZfPIOvH0IqPlfRgs6S6h0JNWo9SdjCyf7kDliOhRYQVfnwZHy9iKT7neZXBzr8RJ2Lum/hlbUCV3O0PmMWDrBMjf83WYnJDj7OnLQA9N+HoRMJFe9J7a5WIkfV6MI8/G1DcWfeChxxXEnnlLZgCdAsE5b+H3YKwUZvbZicM5Zzspivy9xLGpehV/sc8qXQtVeiuW6DrHgJd45vfDaPaEOtkUgiTgXjMM9GhIYfx04iku/MfOVPbGSTOPGPgzlbMWTK+Oj7Zm5Tz91uCxe9cQ2MIa/T3oamcjbWd84ZkhLvctLYD0DNjMb04pTmP/apyapZr+bMCHGjvA839xM+cUbpmof5AYm+n5iP1hS/0ZaXYlyOL+vEaHa9/GCyktsE/Se6C2C1VbHZ+oeOofdujQQUtnRoeLiodhbvXSxjJ/g0QJMZ0qJ6aJoZd95wDODHmYaEIvT57EfgmKO/cKqys9xnSVyR2xFMUPqS3w6hayVwvhR8fjFuQH1AU/xnDpDjpGZDV7m6zJ5iCe6Rn0+GAQykVDXn5nQS1dRZSssZvwMoOtxnZXRzMXcak1te/C3loBoGFbCYFdDsuY++qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 11:32:11AM +0200, David Hildenbrand wrote:
>On 31.08.25 03:32, Zi Yan wrote:
>> On 29 Aug 2025, at 22:31, Wei Yang wrote:
>> 
>> > The check of is_backed_by_folio() is done on each page.
>> > 
>> > Directly move pointer to next page instead of increase one and check if
>> > it is page size aligned.
>> > 
>> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > ---
>> >   tools/testing/selftests/mm/split_huge_page_test.c | 5 ++---
>> >   1 file changed, 2 insertions(+), 3 deletions(-)
>> > 
>> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> > index 10ae65ea032f..7f7016ba4054 100644
>> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> > @@ -423,9 +423,8 @@ static void split_pte_mapped_thp(void)
>> > 
>> >   	/* smap does not show THPs after mremap, use kpageflags instead */
>> >   	thp_size = 0;
>> > -	for (i = 0; i < pagesize * 4; i++)
>> > -		if (i % pagesize == 0 &&
>> > -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>> > +	for (i = 0; i < pagesize * 4; i += pagesize)
>> > +		if (is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>> >   			thp_size++;
>> > 
>> >   	if (thp_size != 4)
>> 
>> It might be better to add
>> 
>> if (pte_mapped[i] != (char)i)
>> 	ksft_exit_fail_msg("%ld byte corrupted\n", i);
>> 
>> instead to make sure mremap() does not change pte_mapped[] values.
>
>We do have a corruption check later in that function, so I think we can just
>keep it simple here.
>
>So this as is LGTM
>
>Acked-by: David Hildenbrand <david@redhat.com>
>
>As noted, we should just move from mremap() to mprotect() or sth like that
>which has clearer semantics.
>

If my understanding is correct, we should

   mmap 4 PMD_SIZE region with RW
   madvise and fault in to allocate pmd-mapped thp
   mprotect first page of each PMD to read-only to split to pte-mapped thp
   check whether the page is backed by pmd-order folio

Is this the correct way? 

-- 
Wei Yang
Help you, Help me

