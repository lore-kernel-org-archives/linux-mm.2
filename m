Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A99CD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 08:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856246B0006; Mon, 15 Dec 2025 03:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8069B6B0007; Mon, 15 Dec 2025 03:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C926B0008; Mon, 15 Dec 2025 03:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FAE06B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:43:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEAD513C471
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:43:57 +0000 (UTC)
X-FDA: 84221067714.16.83C585A
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id B3C97180008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:43:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FUAqz2sc;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765788235;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYenxtkhvUimYIpfVfB8PwA50IBcJ8jsB0avQ/w1o/Y=;
	b=sp7/2Up4rszM8EduEoI9TPZOI9vzSkGA/lKpsP5khTVpFiuZrU7Um4Vz4koZyRJjYvkt+M
	fD/rboAWSz40SEX7uwlbvZFr5U8TReMZWB8HXaKKSwBpz8HEkHHaniqzhQaj2jKAThRLTI
	4ynMmnkJmBW3Zqb/IX35uEW8iYM3qjo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FUAqz2sc;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765788235; a=rsa-sha256;
	cv=none;
	b=x0fCVjk6d8tfrskbmEzI8+vgiDW+zuSYdJVauZRoahm5DVhDmjWzjnrtshXMhJbfw0DeGM
	ukGpW+i4vZUjo2+w4qgEbWvcCnVncQkQDH9ubUBnDwv+dh1w6oPqDwMj/S/ud8HM+Q8mmy
	40IAKmRXpKteIX7sU1WYnhLdyYla4D8=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-647a3bca834so4866960a12.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765788234; x=1766393034; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NYenxtkhvUimYIpfVfB8PwA50IBcJ8jsB0avQ/w1o/Y=;
        b=FUAqz2scNrqFTEegvyQR/kRUZmKT07IbGJ8m8PZkO8+HraLhFkxLaKMmHG2veCXpTS
         vs505/ymGmzaGvEpMGDcB50rks1PmQChQ+b+7uHVS8CWul7IAYL2R3xhQ0UtC73sDKW0
         Y49Jhv9pe//ezOHXF8q6NeuGiYfcNArzCR3WsFYmni6J6CQQMaCE5bhMAMuGEFFGXU/S
         mX5QdYoxNwQsaQAU8SsmePaSbkNy5RbizkGk8aMHXNRWoGfFPxC/ReSQWdIK+/jkP2qf
         UxOgcU0HfM1lmobYMvMzAonoszm1bm4TgcAi3jBquO+nMhx8rF63Q6ovRqF5HZKZm9lk
         RAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765788234; x=1766393034;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYenxtkhvUimYIpfVfB8PwA50IBcJ8jsB0avQ/w1o/Y=;
        b=s3o5WPs7xvJmR045Eu3FIwxTp9j8wiGCD9JIwMinIGD4NKGLQ2IZhTbeIX5Mo0Cq4w
         b9o0rulNvEduO7tErvKCQ+RwWeu3WZj8K6E/ja7XjPEn+A4Wpm+c+TzMs0g5M3EOa4hf
         iCdMsLUUFc1vYZcWXdTjUgvaggo4EY4Jpji6w6bHFwyVjDYSGx7YnFEZi7TlmnS8hbny
         v43JRLss7vSVnhL9n6eHcBI1xGQ3co8XEBbp3ymSA6bsf075iHZL+sF+5rpCJIyuZf2m
         K6BF1ZjSFiBexOlFBWd3CRYn0516nc8J8GaO1xlQP1Y1T1Mj/KlFoNKW2te5QRXQ8SlI
         ln6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUC5kn/rZpIB9gFT0ey6GS+XfH2r8HzqrRQqhdj8qesECcjnDfnOJ+Q3g/cr5IJaFCUYw4b9VckbQ==@kvack.org
X-Gm-Message-State: AOJu0YzpLaRxBzOGR7+3+pLVctxYxR6LGRrbrNpi140xa5hogBObzdCG
	/uCi4QDJtvFRcpn7Bpxy6WG/DxM8jDQgJxHj5OcZvAycpPQ+CoIoODzt
X-Gm-Gg: AY/fxX42fTGJm9md5J7cA9FWPGVV7l78im1gjVioihBCl7E7mmH2k8YcD7Z1nrI1t1w
	7FETxub0oVIVUGWBC6xSI6NUBFzfYQLMQFHLz0UDUzn23vG6UacDGHBL1Svxdl4zBL5tJDElIf7
	gzJ6Zm/mdB+OVSA0AVBz7ybtJmrwx7L0BIGbvKEXLuvHh3Ge3j4fx1eEyT7tNte5JrwopOwhEHV
	hD1oZe8Ntz+HKQx8M+inRacXob+UgA0PVpxkd7G0wPTHSL7Qd0X+IXhy9vyn1gRHbd1J29pv5fR
	jpZeU6lkuprbpH4Uy8BzuSpFHxxSb10OxyCZaAw94FeD7+EU+bBEYDfD+yxeQuOjnYzWS/qexCh
	hZCa/3po+3B7woWujZ8AuZ6oJzYM6qKFP4Ah1ASMz1auGdio8I8wgYU9DHXKPC260l7IId66i8F
	D9NUCCTut+Iw==
X-Google-Smtp-Source: AGHT+IFdjfDKk3DEn67pEaLWn7zpmFg6W5CVuJICS7ljWj7zGdT9JY4jY+0P1WqvKH6W6XqgMtoJNg==
X-Received: by 2002:a17:906:9fc7:b0:b77:1b03:66a1 with SMTP id a640c23a62f3a-b7d23a971acmr941683266b.41.1765788233922;
        Mon, 15 Dec 2025 00:43:53 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cf9f38778sm1345724766b.0.2025.12.15.00.43.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Dec 2025 00:43:53 -0800 (PST)
Date: Mon, 15 Dec 2025 08:43:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
Message-ID: <20251215084353.nmznnnmcpcqo4ldy@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215004836.694-1-richard.weiyang@gmail.com>
 <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3C97180008
X-Stat-Signature: 9n4kekhih3gxmeubuehisad5n4anre4h
X-HE-Tag: 1765788235-635270
X-HE-Meta: U2FsdGVkX1+t/pDBxNa5Fou18abDw5CpiluvmAYislivYXGKqFj+OErxJ2qZjr6e+kMeJcdZwp/VLNPmb6KnSZkViKPedlQL2erwyIlCia7NXrDdvPgsMUksdEL+qtli+fyLksV1rD53emThp1DEhoZEeMljBhVhI6q6J3rORxAXKpw/Y5P39JroTaZe5BpF4x4Ow1h0tS75qr0GO9LCBmtOJzBIvlBB47/qBtefGc7TBfzlAHdzXu/rreTCjgB9wHQDGorMbmyELk7XvtL5zqOpzgwCTWicfURHF1kBehmMhygxul9CVoW8yBGgPzFVkvzLfv6TiwWhCV14fO/U5vgwVaboxB7+501/UbKqwTAa/jvKz0ljSwesc3iVAQP/BT6lvR5DiINALq+zPjxSXtQKX25xkxxHBgZKw32QGIHRwe70gsHVNIwEce/G68X5jOL5msRVbMUYsnQP++2KxHGkZivAhZ99HeZ+c7gS4M4BEe1W0K1T8cORb5Qoi7YadNSXs1rByfi8WL20OaEnZY+s21zYSMUklcCBKva7G9aKMpYZJKskD2/qNauyd9vMt32EnQKQqT2+ZaztT8k5Mw1F3bNDHOBo3OZiG2W/vokxyP6Zn98vcfVqXokENr2bXIUCI7fKXgPZFnMyutGsNEg2U/78lQp5nkunH5wn4Mr+dZdBPlok2xFtiGqJ/xYffGeLq9DS++K2az9Bq/fvsnKYaQiRxLkKFjzOVdUN/5wSohYeHzxybQTk9gLFyG/QpuOeqi38HnK5VHDonuiWCWtE8EDyXivO4AVkp3B5SClaD/PsJSmISQlo/vGUb4YGG+m0yFlTZQ0FC4Yk4ILZPfVjjM/3Ti2ZymNyOBVYdhUTbTJ7RQgBp/CGQgGmkCfo4eCoqlL4MWBL7MliAC0Nmw4mAcR1pYqJjOxiHGtaTDrWsQm54ghNKky1/IMnqZ32r/L/UcxULVie+7595Cq
 Z713uybI
 cYjEfoNFCNS5YUgyRN77riK79Aj5PSJ2UeX0lwjpZQOHdmphgQuY1MN3TD4uWZzp8M/0hyFpDCp2/CGN/MggRn0YxuZh/ZxJZb9Ki4oC0tXoPD+N3zgvqNu5amcRjerz1OrRjgPvKrW4J61RIJw21Y86N54+K8MhtUasI2OBFFGfP8l0JmVYaoWngFKixtOJEvrTh/16M+DQG/hKzGul3s8TscnUeIhslRYJXerYp3H5mmLzqOzKv0cACC/uOrRhPY4l6MBBl+Oail+ujxl3UlTVZOrGLrX/xKJowwt0HvACYfqZtmuT6uw7n/rK8MdBY2HXutdgbvrAA8JBQJWxd4ZGw617NDcR7n3WTk3uwcyFfETNbtIG5fW9DdX5zU0u7E/5rbNkQ0nqGuFH3F/gO2xypEvu84o84aDetYGUxnj8uVrR+dW5VHha/14BFLkUQHqvogxDeTBYq+awnr5Cj/c+wqbBHlZNKYdHYHqcrud+vbbAb8wSn+ati05IQ0hnKHWa5aX1RQjnjuW7PKgpRkHFdj748Vl2yEGAu/srTSxA8oXla4iJDvoWd5KxvbUZamMVq5oq6TGa/y2taIvKW6rs6wKCeUVOGS3z9ktqq1NMT3sqjnSjwrRzrSUMjtpswQ7mExQ8Sn60oghCGqRxd59dfIxwCUXjPSslPhJtGJfl3cEOw/E33m8Dnbe7lxJF6x6JNOlWI0w0pxFB08SNVOjnnQYTqX7w/heLR1O42amKWJnb92oiQNvFqEWvVDLUc7aWaRZ4KTwUo9esxRX9cYg0EA1BcbV43C6wbmts6Fwg+c2yPrfIpnWgI7vvmsUXNLakH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 10:31:15AM +0800, Barry Song wrote:
>On Mon, Dec 15, 2025 at 8:49 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> After splitting a large folio, it is necessary to remap the resulting
>> anonymous folios.
>>
>> The current implementation determines the end of the remapping process
>> by counting the number of pages that have been processed.
>>
>> Since the final folio in the sequence, end_folio, is already known and
>> tracked, this commit refactors the remapping loop to leverage end_folio
>> as the termination marker.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>>
>> ---
>> v2: move folio assignment in loop
>> ---
>>  mm/huge_memory.c | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 40cf59301c21..fe812d9c7807 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>         return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>>  }
>>
>> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>>  {
>
>Do we actually see an improvement in readability or performance?
>The existing code feels a bit more readable to me; nr is clearly
>the number of pages :-)
>

Hi, Barry,

Thanks for your review.

Currently end_folio has been used in __folio_split() and
__folio_freeze_and_split_unmapped() as a termination marker. So continue to
use end_folio here as a termination marker looks consistent and improves
readability to me.

But yeah, this is my personal preference. If it is not the case, I am fine to
keep as it is now. :-)

>Thanks
>Barry

-- 
Wei Yang
Help you, Help me

