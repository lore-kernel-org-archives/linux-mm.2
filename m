Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31610C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 14:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FB66B0098; Wed,  6 Aug 2025 10:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A208D6B0099; Wed,  6 Aug 2025 10:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936026B009A; Wed,  6 Aug 2025 10:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80E726B0098
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:54:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D2761A06A8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:54:37 +0000 (UTC)
X-FDA: 83746628994.28.E3EB473
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18BB18000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:54:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TeniVRwZ;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754492075; a=rsa-sha256;
	cv=none;
	b=tW4WWL3JDeo9g9qAhUOMQBIi1cQhqxP4A/bSIM1SGEXpKraB7wsfU6FpYRUgVChFalRKH7
	U4zP4C+R0GVCK7We3VRw9/+U/V1KjwQ9DwxRiFG221KLQvIwiRpsCbAvGMFDz20lKRlqVz
	RZiQJ9SNeziGZjmqfLYZmoLcvSCqJpU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TeniVRwZ;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754492075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/rb74Rn4CUT7usZvguA3GJ62ZV1pluEnH5A6t2WngA=;
	b=rIbJXK7GEcB84vvSJEEBOQLLGQ1KGe3XQoKNkMXrZHTf2Bw6gJxV7RUTHDrXLX1Q9LdTYG
	DALAO8J/s4caWfUZ2sZTC5Xpylxpqbhmss1SyACewKFpCMRDHn0C7WYhQ3DW1d0claQTdT
	il5t8MneINZTtf4lVCEom7ewgXzaSq8=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-af98841b4abso285316766b.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754492073; x=1755096873; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l/rb74Rn4CUT7usZvguA3GJ62ZV1pluEnH5A6t2WngA=;
        b=TeniVRwZQ803Thg8dl+xzN/3XslgUeRu7jPd+44YB7WRqlXnd894RBOqfNqG4RdIHR
         tIrBG2mRQwc+WNmjLcj/KL0H2ZGa8macnSRZ33mFyOm+6xqXKhrInNteqzL3J8qwEo6c
         rKKjJ7pYOQ46TeFoiSsaFhKQknZCNWhVShFo3m+hQXFGBjkSrAjXmmeh7XRnp4wII1SW
         wR6orD8iXi/414DHAzY3ORX2yXZcgPqxEUzSYT6/6fyGWTuhMC4rWSJ5MAaeUGwsmtgj
         yFF0rPZ69rkyrP3wP45cxj9QK4Xx65XWOuyYhloYe72WEaLOvE15eHVDxmAApeZGbQah
         /LRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754492073; x=1755096873;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/rb74Rn4CUT7usZvguA3GJ62ZV1pluEnH5A6t2WngA=;
        b=k0I0gfPg54YDOrMtAceCPZpQvxyzrYbuTuw1nj+aLer1tsH0KOMYTenzbwNcKoc3tc
         0VJfHxRneMBXO0WjjqBvA2EQNOTjcVmJCpEXW4hgq1CG1RvVLqo+Vx633oyWr01qiYmL
         OPqg8a6sJ9Tx+6yafl5UkVLk/s34FB0IT1GcvNL9jG+3S7zES20vMcvvScptJGss+f6d
         1GSEj3U/PoqwLU2TbctY6WEZRtm+peZTz3Gaot47WRKvjv4fOlnofgibSyaMwweYyg2M
         zIyaGhm1BVpb/LBSgtOopgtfR0PLuLyJY966iaEvAs8e0SQTY9CGibbRarbUXxcY372I
         sh3g==
X-Forwarded-Encrypted: i=1; AJvYcCUytGyslBezWWTnZmzC4jtu4Xw1Ch/rVqiKdDk6rOTmtTuipCNV60OkZX1zjrMVwZABc54a1eMPyA==@kvack.org
X-Gm-Message-State: AOJu0YyVYCWKqEzGeVNrjfC4s4ajotHJUln4QbAvZuDUaMpKY2KglV/N
	BdUnJiRuRnrf0GskLyeApnz1uR2hXuBjjmsPFIzGm7GXs9JpBF78fJTy
X-Gm-Gg: ASbGncuh9k4Yeupj2L1WGK/mP7twh1cWCM3cnogA3duSHeJgpXTreHsIbPn4j8lrZiq
	b7IvIMUy1rbxpO2Lamn74qFwGcgsVoCh4S3a898VPIfK+Ev9QAiawj0dwKfvbis4w6ZVPogTmC5
	ZPZpR23utFfEZE+PTQWkK0yqn2ojRdxKTt1MSHkl0id72B8/i+VnIORpxkAdGnvh1ynw5MJOzS2
	MoYdAMqxsNF6MKN8O7uXt69ajcKcexzeCVum34FhjOUBJfTuenqoePHRmTYlM/kedW4u70PhQsz
	FVCumDMmPsOh2ihKNiCiCD5Xq8W/rCdU50oUzOogEdbS3kpeEHsh2VQdhQZz+nsiAmlMoHEMAWK
	jU44vLl0KlVlcqD7S4DvvfA==
X-Google-Smtp-Source: AGHT+IFS6g0g1OqUDi72LqUCVo/ND5e7JBrkMGvo/NtwvaBttPCiw1Ma69w75ETAugGec2ZHXmvHzA==
X-Received: by 2002:a17:907:3f8c:b0:ad5:2e5b:d16b with SMTP id a640c23a62f3a-af990350c69mr348859766b.27.1754492073165;
        Wed, 06 Aug 2025 07:54:33 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0766f9sm1139997566b.24.2025.08.06.07.54.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Aug 2025 07:54:32 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:54:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	ritesh.list@gmail.com
Subject: Re: [PATCH v3 3/7] selftest/mm: Fix ksm_funtional_test failures
Message-ID: <20250806145432.nygrslkiyvzulujn@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
 <20250804091141.ifwryfmgjepwrog4@master>
 <20fb853c-7d79-4d26-9c8a-f6ce9367d424@linux.ibm.com>
 <20250805170353.6vlbyg6qn5hv4yzz@master>
 <e9079694-1e30-46b6-97e7-b79be01c65a6@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9079694-1e30-46b6-97e7-b79be01c65a6@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18BB18000C
X-Stat-Signature: bmm7jy89o9hrxnmzd916oz56cy539b4a
X-HE-Tag: 1754492074-25929
X-HE-Meta: U2FsdGVkX19ItfD738rYRWAqOyhn+yRfiuiczAituCWhmZA9VDRNb4+v/Pbg0CvmpVLLyD18o+vk7aDZT+/YXgffPqtnOJaw3yKSi86iCGHZIkfuPJVHPT/kQDmrKEMW+NGL+7GHSQLI0//Wa/QL7JwiN8fZcKTcYBk+xNV/qWifIdBCr170ZLyU0bprnUz+tmHZ9IdGySfM3VD/jx9CENqAgl8+kKvI5aMociQF8oxaaMwr7emPFjLjONvzotn8jqHAC4yVXvIofIxLj3CmCEUDhJ8Eaz4Y8nxWMeUed65DXbpFTizwJStPGSYxLdS2VAfnMPLOL82cF8fYPYMu83rcLZZhQhtjeqctEm6s3ah5TM44/4L0TyoTlVA8dHJcNrwn5xurQ0tMGZsKpDxOpyDRZiMNZa8tcM4MbTt6lUEZrIqV4pz1YB7Gan9qJBcOHgN576CbQW635bwG9bgLY732L8dcpfpfcRLPBuVjzze0HzKzP59TAiViRa6WXm1bf7iPSuppAcQVkbZX0PihaZNr9Bk0Z7cYQqqEn95G50Tnrfc/LIRjETBY+8NOiM+UBorBTMIERol2YoLpg5oCKoeTiGKNsbpFK5tE4qwmbJBlEGQfr5xsonLZGe7wHZ416rdWTObGdwK2rhBXWiOFYCZzb+u06dxGns5O/Xu/QBv4fZtsZegjhDaTTeUp59913oWADPYqDEXI4S0M2cqGlvxG8MixjrOwWxKUZX5qwMn46eQUYNol8XCE7x5OBygIkXL3EyQuHFVbUqvdZ0BcxQEsB9olKVLItk3J2ousboChATNm6infXZYQQ4RIuzEm1vfgWtxEL+4tWpw4Xkok74FNl2uR/B0AXIwNW8YujN6M/Nv4ZUoc8OuEWk01f/3BtDsRnO96qOGkdAU7v3VC6JeK6APLIXrUU+vsSh5Z4OAHXcbXBnw2i6xCrY82lP8kbo9Thc+fAllNcYXnqlL
 FsEoePdP
 9rNfK3uU0gOfqi+YNgiPKVLtiUaizhuVaZeKpejY456vzLrHibMTpIfitXCt1G+l0fnw9UHaQBzu5PsIxDamAvWTHDu+1bgisG6nnGZe7QuudjY0TIzCY5ZQVt0BR+EgC+20prCpmh+nHHcYnmsY+AfROyFSM6JSSj+5oAIVZOSlxc9Pztxwh++VS7BykvCeUmJjdxcvCLnIAIcRI0PRnQFc2u6cEAA/EgEcXR6JmwWtVMWH+8SBtqsIRuGue4j7OmulcYXDFAeZ1D4ivw1aHGTs95HfGDoIdO4xhpen5C18onIwPTOn+T47lLuDvOBAHwLJonpSoqByHy2C8cwjI1v6yHNzAbpxZucjA//DSkY5WNBO4zs3ZAjfsDbWARpt9AiOqPtf4AGAQMu7o/O1Ol8RODdRf5sp7X0yLqC0nrShnmiQOJxQdIMKWg9sCmNcbjmJdbYBVKmEqh3gq5/x20LL9U/RANZsT+miAfjxcu+SLesqWo8EZIvVfZmaMsaOMCP28n222jFmbO3Wu1ClVUQHWGaDKRx4Cf/YJGuXedij9g7t7I50+Hur0HF9xB7GhnEDCM8N/DxuMvPLHQWRKKP0WBeLV22xsmKmPNPVaVEAp/H3UOAjO+scJ9UjpxeyjwR35h8kJgnFgA/+A6HbM/sjzVIpVeQ/VxrqPebQEEDwJuYEsdoSKTSZcaehwFjzULheo49E+XFEEBseKFEvb7gTtNJuxA+Y7aCrks30G/5m4/GeCT4qJWoK1CUZDotaMbp0NPKE4gbJbCBdw4ndFkVBKRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 06:30:37PM +0530, Donet Tom wrote:
[...]
>> Child process inherit the ksm_merging_pages from parent, which is reasonable
>> to me. But I am confused why ksm_unmerge() would just reset ksm_merging_pages
>> for parent and leave ksm_merging_pages in child process unchanged.
>> 
>> ksm_unmerge() writes to /sys/kernel/mm/ksm/run, which is a system wide sysfs
>> interface. I expect it applies to both parent and child.
>
>I am not very familiar with the KSM code, but from what I understand:
>
>The ksm_merging_pages counter is maintained per mm_struct. When
>we write to /sys/kernel/mm/ksm/run, unmerging is triggered, and the
>counters are updated for all mm_structs present in the ksm_mm_slot list.
>
>A mm_struct gets added to this list  when MADV_MERGEABLE is called.
>In the case of the child process, since MADV_MERGEABLE has not been
>invoked yet, its mm_struct is not part of the list. As a result,
>its ksm_merging_pages counter is not reset.
>

Would this flag be inherited during fork? VM_MERGEABLE is saved in related vma
I don't see it would be dropped during fork. Maybe missed.

>
>> > value remained unchanged. That’s why get_my_merging_page() in the child was
>> > returning a non-zero value.
>> > 
>> I guess you mean the get_my_merging_page() in __mmap_and_merge_range() return
>> a non-zero value. But there is ksm_unmerge() before it. Why this ksm_unmerge()
>> couldn't reset the value, but a ksm_unmerge() in parent could.
>> 
>> > Initially, I fixed the issue by calling ksm_unmerge() before the fork(), and
>> > that
>> > resolved the problem. Later, I decided it would be cleaner to move the
>> > ksm_unmerge() call to the test cleanup phase.
>> > 
>> Also all the tests before test_prctl_fork(), except test_prctl(), calls
>> 
>>    ksft_test_result(!range_maps_duplicates());
>> 
>> If the previous tests succeed, it means there is no duplicate pages. This
>> means ksm_merging_pages should be 0 before test_prctl_fork() if other tests
>> pass. And the child process would inherit a 0 ksm_merging_pages. (A quick test
>> proves it.)
>
>
>If I understand correctly, all the tests are calling MADV_UNMERGEABLE,
>which internally calls break_ksm() in the kernel. This function replaces the
>KSM page with an exclusive anonymous page. However, the
>ksm_merging_pages counters are not updated at this point.
>
>The function range_maps_duplicates(map, size) checks whether the pages
>have been unmerged. Since break_ksm() does perform the unmerge, this
>function returns false, and the test passes.
>
>The ksm_merging_pages update happens later via the ksm_scan_thread().
>That’s why we observe that ksm_merging_pages values are not reset
>immediately after the test finishes.
>

Not familiar with ksm internal. But the ksm_merging_pages counter still has
non-zero value when all merged pages are unmerged makes me feel odd.

>If we add a sleep(1) after the MADV_UNMERGEABLE call, we can see that
>the ksm_merging_pages values are reset after the sleep.
>
>Once the test completes successfully, we can call ksm_unmerge(), which
>will immediately reset the ksm_merging_pages value. This way, in the fork
>test, the child process will also see the correct value.
>> 
>> So which part of the story I missed?
>> 
>
>So, during the cleanup phase after a successful test, we can call
>ksm_unmerge() to reset the counter. Do you see any issue with
>this approach?
>

It looks there is no issue with an extra ksm_unmerge().

But one more question. Why an extra ksm_unmerge() could help.

Here is what we have during test:


  test_prot_none()
      !range_maps_duplicates()
      ksm_unmerge()                  1) <--- newly add
  test_prctl_fork()
      >--- in child
      __mmap_and_merge_range()
          ksm_unmerge()              2) <--- already have

As you mentioned above ksm_unmerge() would immediately reset
ksm_merging_pages, why ksm_unmerge() at 2) still leave ksm_merging_pages
non-zero? And the one at 1) could help.

Or there is still some timing issue like sleep(1) you did?

-- 
Wei Yang
Help you, Help me

