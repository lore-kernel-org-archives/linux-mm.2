Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE62ACA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6BD8E0018; Mon,  1 Sep 2025 04:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A72C8E0012; Mon,  1 Sep 2025 04:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD218E0018; Mon,  1 Sep 2025 04:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 070988E0012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:43:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EE49160723
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:43:54 +0000 (UTC)
X-FDA: 83840043588.23.2E4A7AA
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 78C7D1C000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:43:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OUstaE5u;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756716232; a=rsa-sha256;
	cv=none;
	b=8pECk6Czfi6p6uHpyZwq25yuz5DrgmFBCLNqcz6je1FqcN8yXAepStFwrzxE88D1waGjPC
	E6v7egF+/7sZnRJuUKIUpLmFfWFhRqraNXKTUYU3C/qgb4+j7+ZBhYSAoIEEoXkkRa3VVh
	l0EwqW/NBmGD3zXHjWxUKYLZW0EQ/HQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OUstaE5u;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756716232;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyqYxxTqFKLIwYU2In9gt4rvnXEtC8gE8PpkkaZ0VEo=;
	b=GqNss1ATf4LpNrtgddqbQ/mKqsG6RqJcgL5BPXjCe6nJ3doCDAgdpxmN2UkQrtK6FvuTNe
	uWUi2sFqI/aATlbTvWgsUi5Ca8tDh3zDbjSlQs4YydaCJf2LXUBmm4FaNBEbYg2WSizGOZ
	MnMeBnpg63cBedWcgTA1Ee5RjIBGS2M=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b043a33b060so43355066b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756716231; x=1757321031; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyqYxxTqFKLIwYU2In9gt4rvnXEtC8gE8PpkkaZ0VEo=;
        b=OUstaE5ufFPMHby9Dppv7LQyyaWEZld17+bDUdnkEk32huBm4EURxq4Dt0qMpfp05R
         Y7zan0x0+62MrMws+4Xgmt/3cMMpWgQ+OXYTpk6E6r1VQuTBSZz+Ac6Q7Z25pzximI52
         fPLNhze3TQ3zT10r1cf9VlZ2ZlozqAEyv+5Bx8z7k3UuMlHpQ9UuUcpLpoQY0R52upho
         Wz1UByU/ieLN3MfQWkmLSQxaPTxyBdlPQfTfOBvInI6ZSvOW+5c7ak13vTSuXS0ScRFj
         I4/ELNT+mo49DzDDHCIYIAxk+yJJVS9+h84T0DJ9WJbXrgpLo0YxShCybyBgH4qrUZ7d
         rypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756716231; x=1757321031;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fyqYxxTqFKLIwYU2In9gt4rvnXEtC8gE8PpkkaZ0VEo=;
        b=RDnN4ljPLsy9fLyzYHbF1/IQlnhp07p5VXlimEqplXXXivynYv/pxYxPp3bohr7Cq9
         EYbOQLDVCgx/8iM6hwB0loADhfFBgv02IE0y27+3iQYo4qKzi9SZNaD03tC2OD+C8g3+
         05mOyXf/5KeY8xAMhDpU66FngFllJnoQLcjwcyUdRpkWtTsHx9jiOfQRgORQhIznp/D7
         rDg2kr9bvrlS2qYyyQyRdkx18fUk1V7TYSMJTzT33TiC9a8GjqaEkOjt3ittC4XMVi+h
         qPik8ZBxRya6NE73I3YltRKHVDS4s8DyRVs6Uc/ijf0I8WkopvHZ7n0oRzXo0kBIhccn
         EsRg==
X-Forwarded-Encrypted: i=1; AJvYcCXUdhqJinPVDMsl30S6A997PP5QOsCPuB/iz1ndGZa99VgCxUjVIUMUWf+wsdzj45WOajfENmItig==@kvack.org
X-Gm-Message-State: AOJu0Yw2w/RTwZ3mnRUFHfYSfqAKR3MM5kDiUz7r4WfD9M9PBntEA4pH
	d40Bp4iA2cNSaxB/QoJwXkjlP+qo+at50rhiA3NCLIkGXtjzJe7+FsKhwsuXkw==
X-Gm-Gg: ASbGnctAN2nF3jORNuF93+q5RTadfNq+25c/i8XCqlj2w9jNvEDxsMEFYHhSZ3NSr1I
	k3eCQE7vc18aKLnrBVg7FxVGft4+KzCzEHZrTHmosjliLQo4iWb5tZmNAUaZ0tgbCaEeWGXICfg
	rLTQ0OUdFua4YLY7f0hmBuF/9GHI/EhrDdIP/paSA9rwXOv1RIy5LiSIr2wWZtfOBLao1nrbqW3
	BoKSMfLxeZtztfeaVMPSHLtChbPljIdyOQ6x6yGqRsPUUARDlCH9iT7SfWHkR5IEmQDyDQYaQNk
	Fa4nkiT2LiEpjLawVFoDFWIIA9DcSE2gQftitHf0wOwF9MrBQ3A0rskOg2IcRIHqVJPoM5Sj8WA
	Uu+mb0ySUCkJLzpfGu9Dp4PC6mE8SFdpG7bZ9
X-Google-Smtp-Source: AGHT+IG0dZrINPTvKzcQ808Q1XKK68eFAZ8vAoHXzUBGuo9ws+d6KBK6iPjT9erGsPmK2Vj9TjrUmA==
X-Received: by 2002:a17:907:3da1:b0:afe:e745:c3b with SMTP id a640c23a62f3a-b01d8a33b6bmr593546366b.12.1756716230617;
        Mon, 01 Sep 2025 01:43:50 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0425ce98f1sm234739466b.67.2025.09.01.01.43.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Sep 2025 01:43:50 -0700 (PDT)
Date: Mon, 1 Sep 2025 08:43:49 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
Message-ID: <20250901084349.imkxldwebqzgq3wd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 78C7D1C000B
X-Stat-Signature: pfs73git9edytiix6czfzqh3ya93pcu5
X-Rspam-User: 
X-HE-Tag: 1756716232-473
X-HE-Meta: U2FsdGVkX18iUINZ7usoIA3LhTM2nRuOo5U7xRXeq2gUR8PfuzT/5dNgaFINDtyTxyjhYUzIelS5SnW95+FWsUrSQ/t2L9Mq5Z6TvjSy4HZ4GgXkPR5KScmOLiJu4sj6vhgFhgFPjF4RTmjjOdvFhseCjEKDLRK/92WH60keJ+WQmh1ZQtHcHcbcLeMmsqZYUTJ0IunAbtjeMCIVJJbr+2350u2TIs0jT/mMhNpfoXD+tWKGUfJFf1uDajVyOa2no5kr2Ehe3hsgiCEAXtBV3Py4bbObqjZG+4XMDy9Q6ilfRw/qOGcKRJ9dif89MF6Z4SabOOmacfz95qkJZgiV+XkrtoT1cWqInrHnWDvVRL5jTtJnWJ2B+fPDBCGgzpijCuESNuqlau4UHcVFXdilSqY+wRJWou1AKtnGGIW4VbL6e1vRy8GcGvLh7o3E9z/nM1JmrCwjsD1RUOWjnlkAVuQxj+w3qh+9HVF9/nB6oyznIoJIWjegTmj7w2LGHj/GioJGObtlYWAdazylQFni/6+/e17pAuhNreWCRaCSdpPyX62/FLIvIPQlljWf0gOws014YU801Y2X9YsbdETo+e1rREdnEL2EOMiWgyOAUqIdwQlQpP1YGE+rfUEXSnZ8eJ1KhHiZ/FDcUX5uXt/QKZxYsY379mQLj67p1mvH9x9HK6G+XiLrs7gO3fkYp1Cgd3rhY2oY0psolBFoejix+v2OOZJcNTeETVEJ7NqD6Gm+5c5U9ikiuEPlBnYbVvlhbR+lmLqhvxDfg+8GYeb3VsgnFw44y8FXUcis2Ey2UB95BClGzOK+V66NeYWwTKLPSfA7vD7HAfLIYeMlfJSr8rZD3tJMu0anemC4wh5/qhmW4e34fvpRBj/5J7ZmMHUhDlnn/caFHNA6uVYPUsoWGesC7w6wwt3zDd+/Y3T32xW5b3+aAOvJX29T8vkr2Miy++CmA4et4NCNtIVysHr
 1s3oB1vK
 cqFVWCQcI/hDztf8LbTadVf5765YLqZdqshSUbaJ9P+AnseprWyBiofcRM3oLYvU73xZnDgQvx8vp2y7A/U4YucoaMts3AjgaiadAUBkH21oO7oNlGvV/caflK/cSbrazCl2hYDezbnefDx9JWLNdtGoM9r9WWsvGhsR6vR/2541zrU+8RAa9eYWDyDlPKtyr5l/k0D/K/Cj0ntWYlTzUQcJQtswDaFSsLkVaNzxSvHyKq/rEoKLPgxE1ekdaajNJGCqzXpPyDTyQzGrvht6fRgm2xGRRGPG/GThRSjLZcBf7yn9XArZzqm0fk2u2DGE4faiiBlo5mCqN6tcLfinREVEwpuLJ6gzPPGA0Qy+BCPM0wRN2nZm6epnnyZSh/z23chpuXRSYkHc8q83rL9G6HnKP3CU/n1liiyi9icJi39HSenYtkcAv72YeDOYrmfMltRLoOPN8BZNoeUwSKyWNN4QetNxsZkEfGnpaj3S8dhegqhOUY6BQq2IOJrMRls5YRLpbWJO6larhtYWu4Oil0SYQu04AzAcaVLJmY3Bs0pwLYEzyh8MEzv9hSzhuwUH6FIxT51ykCe8VZ14CDiZ+C6t3xceld1EDgDxZ9rYsllrmpNv0HLHUKJ1hoaIzaeV9K864xR6kn6ThbSSbq3YvbvRvFYbXMqHGo4CrX/Dy1exTMFErucFxhD1FcRJ8bF5FIBcyOTMtNTKEw9qimWWLgi0+XTAZV1VId2fI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 09:22:44AM +0200, David Hildenbrand wrote:
>On 31.08.25 04:27, Wei Yang wrote:
>
>Subject: "selftests/mm: verify page content after remapping PMD through PTEs"
>
>> After mremap(), add a check on content to see whether mremap corrupt
>> data.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> 
>> ---
>> v2: add check on content instead of just test backed folio
>
>I'm confused, don't we have that exact check later in the function?
>
>Your v1 might have been better, unless I am missing something.
>

Maybe I should insist a little.

>> ---
>>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 10ae65ea032f..229b6dcabece 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -423,10 +423,14 @@ static void split_pte_mapped_thp(void)
>>   	/* smap does not show THPs after mremap, use kpageflags instead */
>>   	thp_size = 0;
>> -	for (i = 0; i < pagesize * 4; i++)
>> +	for (i = 0; i < pagesize * 4; i++) {
>> +		if (pte_mapped[i] != (char)i)
>> +			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>> +
>>   		if (i % pagesize == 0 &&
>>   		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>   			thp_size++;
>> +	}
>>   	if (thp_size != 4)
>>   		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
>
>I'm a bit confused with this test in general.
>
>We do a
>
>pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
>
>which I read as a "NOP".
>
>Questions
>
>(a) Will this actually do anything? Also, maybe it does now, but can't the
>kernel just optimize that out in the future?
>
>(b) Is it even guaranteed that we can access > pagesize afterwards? I mean,
>we specify MREMAP_MAYMOVE.
>

To be honest, I am not fully understand the operations here.

>
>I would suggest to just use mprotect/madvise to pte-map a PMD-THP.
>
>This is, of course, independent of this patch.
>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

