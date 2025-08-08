Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81123C87FCF
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 02:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A987F8E0002; Thu,  7 Aug 2025 22:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31858E0001; Thu,  7 Aug 2025 22:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9203B8E0002; Thu,  7 Aug 2025 22:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EBE48E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 22:58:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24EC6C12BD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 02:58:10 +0000 (UTC)
X-FDA: 83752081140.16.E4337F1
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0BA8340002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 02:58:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uo87fBIe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754621888; a=rsa-sha256;
	cv=none;
	b=Ux5e8O3BRLwtCnjVfVScZxbJSo0TEbEmj2E2B6smIk/pD5GY64cH2h0DD5RcMgSfeKGBAx
	8lh6gpp1KVGK4OiQ0olmyRe5QBQBRCYROnzTQ4oUDws/K1AdJO6U+5Xe6x6o+PfjKvfwks
	s6NGVYEbumEMkFdQYaBkK9z4rjPjCiI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uo87fBIe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754621888;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InFnfUjyzfpsp+W5R8piC/DqY1LG1vw1ztQP90OY3GA=;
	b=toxtfo3sd21Q06P31QSxrTWZBjOy5Ev7G8DJuQuO1c6M5Bgaa3MnzfOWYlTu35ss0OD+zn
	b7lQvrZDwit5Q5uabjvKExglM/3yLdG9RBFmXlns523DPZIVhc0On4W02tkM1sRXereZMX
	9TLEnNPQga4YGxszYOjEuIyl7mNzAkw=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-af9611d8ff7so327801466b.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 19:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754621886; x=1755226686; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=InFnfUjyzfpsp+W5R8piC/DqY1LG1vw1ztQP90OY3GA=;
        b=Uo87fBIe4Na7SUUGRYOQ16mZmktUmbh6Oma7m3mJedMFYbzuXrhPBBkmwc89V+t2qA
         /pbxnkcKdAbM43ZehpLgzqabPX1NHWRnELYSXrZS0/8t8l03kS6eWVCokx+eDBfTnvP4
         u5y33K6pCcO72RTdFdldebGalAwNpfSvhz060ALiW4zYM+oiH3G2n/luGdEi1PNfJwHQ
         DnosR3FFkfSGmud8i+prV1PjtLR0jw05jbVCzqsFZO0y/ny3jkXVV5/M4zSokqN298xw
         oOyaIy49IcX/KHXp6cTVHUOiUxoKVvQ90Bgtot9HxXsZS4kAFG8I8dHGispL9qLfRklK
         VkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754621886; x=1755226686;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InFnfUjyzfpsp+W5R8piC/DqY1LG1vw1ztQP90OY3GA=;
        b=WvEHRGQ7z4/GlTnivanGia70WFkq4H2qmgOJX5By+ouTEjMeeT3NvoTgIFe+uNUQRg
         6JXHmK31sy6OzdrppE0qb4lUm+uz4J1LICLHHk+qQgXx1XNs4mNQSF8ersaM08MIuioW
         poxMeOhS5uvtLUGrzTXNNL+WiVFgtYXOpY/OUU43tAD8StWyY+W++tHIXtkrHXs600hQ
         9BULd0IQ0mkyHFIqhs2jwwEFW9B+15/6k6YgZpNS4UbDA759MeT5sqDXqMEgqvJrhhBf
         OEO/Tv0oCc/PVO0/bxdx1pHAYNyUz0W4O+9k6JUuUaiW1S6azAF8tSKy0Lftcqey1rCS
         vuxA==
X-Forwarded-Encrypted: i=1; AJvYcCVrmwy39V/b2B2uO1FjMjzzffi+scAR9dq6vn6fmuQWFsCSlL/fHufUYX927rbf2Olm1yoa80NeVg==@kvack.org
X-Gm-Message-State: AOJu0Yx5DBefXxINTCR/FfS9/3aiYOAIY3DzTjWqyK2LfYHwh6RWHskc
	iBBTNRHNSvmiCd7q5T0zB1zLDX7U9JEeNam57jMloI2wpuzDwcOUHNi6
X-Gm-Gg: ASbGncvk/ZFkmz6AUg08eA60+8qg7REr10HWLta3kVzTSMvIHuJlhkb+zhOCYsBtFc/
	l3V0zsGnM7M5eGJQeVQHMtc+Y98GqaASo9gTuH9v8ICBdVDjw3fWPvb8PGG6yTbhwclpyuR5LZD
	/GIdbwCExf/pUZGtBXUOOrhDr4VxciB4qSvgCXg84Fkib5TXjkrY4InByIzUMaJjsIcGXkwj6EX
	35Rd1dMqs//D2mw4twxdbkIpEii36Bl8uMUSv0TYNy19GrXfEwnhBcammx0xtnjnf2Su2PKyRwD
	tzMB60WmDF8aeH1kM1Toeml9tlMOlohINrz9msmHDOmjugFQwrEDUmoyZeB9qGIavU1aTP4L+Dg
	I6Se0iAwReZZwgxCl9aqPcw==
X-Google-Smtp-Source: AGHT+IEvl6ZdfxAsRS1F4iXaUsO8JqUXfeEwT1NP8Lupi7iF8ZO/CuT92uX1OKdhIEIS8t0JwYzAlg==
X-Received: by 2002:a17:907:d0b:b0:af9:3f99:1422 with SMTP id a640c23a62f3a-af9a3c59269mr590769066b.5.1754621886013;
        Thu, 07 Aug 2025 19:58:06 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af9215cdc53sm1365718666b.78.2025.08.07.19.58.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Aug 2025 19:58:05 -0700 (PDT)
Date: Fri, 8 Aug 2025 02:58:04 +0000
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
Message-ID: <20250808025804.b7cv47gcq2yscka7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
 <20250804091141.ifwryfmgjepwrog4@master>
 <20fb853c-7d79-4d26-9c8a-f6ce9367d424@linux.ibm.com>
 <20250805170353.6vlbyg6qn5hv4yzz@master>
 <e9079694-1e30-46b6-97e7-b79be01c65a6@linux.ibm.com>
 <20250806145432.nygrslkiyvzulujn@master>
 <111d2351-3fb7-4011-af07-78b40874d956@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <111d2351-3fb7-4011-af07-78b40874d956@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BA8340002
X-Stat-Signature: s7hw18xm117mfsp5dnokyyyrit6ppkmm
X-HE-Tag: 1754621887-933738
X-HE-Meta: U2FsdGVkX19ptKd2EKQV17zgAlkUf19toHjU0MvsXWK1dpE7txoZi+VWE8R2ayPswl8K51SDvzbgpuoIi7QX0YsLUJs7htWUUU1huAa8/nvIhmvf2ppywtmFsr4+tTeDaO0KsVHXzuCtWwoGwLv/LzGAPcv3jMv5e5UZ0lqcsct8A1OrJOxbuIX5/1FhlnOa0VCl+YU7fjv+hqVsk8YfzY5B+s8ZNEAXh0K925SWm3cBUF2N7IhL7cirYTsa1nw2atyekpkWY6TLiYFxCOvzYv0LVVGP4AOLO+0LmnDP/5b20NhMK/D8leF9EhyMNqzZVbdDzl4TK7Ml2hl2gkexlTk65qmJ1f8BmItsVnn5qyvA0kfDjUB4NE2JS+x5OmDyS7OlLk/haGGj4GSMtbLRg5rBKiLSCLx6oloA+k9ffrfcFm+bS0c/yj+4OomP8AW0wi1fMs/CdFEkrNLhx2Me1E3rh+35ZLWTXaQuiP3+C8sAdlBE29/70QHzIKOJIRRqbpzaO9cJ4USvLygXIbC8nCyziWGNrqbD6HtLWUqBBTLa7as7jZ5dau2d8lBztgvF17MznLQnDZJDkQ/jQRHjKfFPVXK94Te55FVaRVZj74wpUyXJb7xaWXDHchxVWDE3skkU1V9/IUKt7JgUoRVlOqRYXFVrYvYnQ54/lK/Uq+kpaVlKbL8BiNGWlndw4et4TudBY28eFEwplCJnuu3B1OEejkWfRd06R2N4x90wIkZTg5IzppC/saxxoqmOdSOeERbPOa4ypaZmNCJ9naDeiQIrzeFrDFY38eK1KwlQiUoksKWEmbsjibO3Ljhp90PPEIDQYG6PMrxQk4oU8M3MSgypKaxAoTx9HmOoMZZf+AzkMh3l/OgelR71LgIGBHHyHXUudAqOqlLJXsvv7soXJfN6hSEDcFIAeaBeP1tTEAglnhOCxRBkqNuPbEvdPNf8X5pBhkLZwo/M5oT1J9z
 2I3l55V4
 IkEiWGKZZi2gn9JwjplZaLBoCQzqalQ2Za5QBeoNZpb6fQoR20pVrGOHecoWbFT0RXWC2ebK9MeXHiSFUWktMe9ztWQ0Zg8vLXOIYyVYjqux570q4ahK0Vla0/V/xf83OsFSSJ6sYFeBwlH7R3rbKMI59s0ejDHqAGs2RRX5fRIBQNyJVCPTFnY7EHz2FQiFVlmsTaNUazr80Z01DU+Iu0uG/iTmdyJrPYtlNz9kpUxxW/vsIkBwBM0nILAJZiWvV1rC8YUMUANul1EBE7LRfuFf2kLp0QJsFc1OWVphwg9eLZjxOxTNIkc3aamK8JHYqmzYSqDUT1Pr3ACh9PC6Lq+avq1J/o4k/uOyfFwsT/xDd4uNOFHuuKfsIHX6+JqD3RPkZ2ExlyeTTTYX1jrY4N5DTylPhN31UxmHOP/im5pC1XpS4+IR1TZ0vOjCZvI5qt88U1kYmNIscKLCfweBhfuVJcz1LFc4eZHlmXH5oD11DasAiQBYO0RsumIMKpGwanEkBSrPGFYuQnrsoApQcUtWWSAoHfhmpg05P28AhML8qRvLGxYBvIeu1VUp3eMGi9nOcd812EHLBoi9GYrzwg+0rh/WroiFt4Uf/ATH9031BU8LzG1uKEYly5574HJ3+9tUVAPDPD1PvhZ6xVR/1V1FNktWFqxv2N+VuJir4NDmrtYBF5/fmQAPYH4cMmJB8IkzrrJK+SaN161JcmURqaUWzBdiyOu8lvj4tzPQ8WqKsJpnIxsgOgRZVLTDQqf4FEg8jp3jaMnvzeBcSnXhOlHRxYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 02:56:28PM +0530, Donet Tom wrote:
>
>On 8/6/25 8:24 PM, Wei Yang wrote:
>> On Wed, Aug 06, 2025 at 06:30:37PM +0530, Donet Tom wrote:
>> [...]
>> > > Child process inherit the ksm_merging_pages from parent, which is reasonable
>> > > to me. But I am confused why ksm_unmerge() would just reset ksm_merging_pages
>> > > for parent and leave ksm_merging_pages in child process unchanged.
>> > > 
>> > > ksm_unmerge() writes to /sys/kernel/mm/ksm/run, which is a system wide sysfs
>> > > interface. I expect it applies to both parent and child.
>> > I am not very familiar with the KSM code, but from what I understand:
>> > 
>> > The ksm_merging_pages counter is maintained per mm_struct. When
>> > we write to /sys/kernel/mm/ksm/run, unmerging is triggered, and the
>> > counters are updated for all mm_structs present in the ksm_mm_slot list.
>> > 
>> > A mm_struct gets added to this list  when MADV_MERGEABLE is called.
>> > In the case of the child process, since MADV_MERGEABLE has not been
>> > invoked yet, its mm_struct is not part of the list. As a result,
>> > its ksm_merging_pages counter is not reset.
>> > 
>> Would this flag be inherited during fork? VM_MERGEABLE is saved in related vma
>> I don't see it would be dropped during fork. Maybe missed.
>> 
>> > > > value remained unchanged. That’s why get_my_merging_page() in the child was
>> > > > returning a non-zero value.
>> > > > 
>> > > I guess you mean the get_my_merging_page() in __mmap_and_merge_range() return
>> > > a non-zero value. But there is ksm_unmerge() before it. Why this ksm_unmerge()
>> > > couldn't reset the value, but a ksm_unmerge() in parent could.
>> > > 
>> > > > Initially, I fixed the issue by calling ksm_unmerge() before the fork(), and
>> > > > that
>> > > > resolved the problem. Later, I decided it would be cleaner to move the
>> > > > ksm_unmerge() call to the test cleanup phase.
>> > > > 
>> > > Also all the tests before test_prctl_fork(), except test_prctl(), calls
>> > > 
>> > >     ksft_test_result(!range_maps_duplicates());
>> > > 
>> > > If the previous tests succeed, it means there is no duplicate pages. This
>> > > means ksm_merging_pages should be 0 before test_prctl_fork() if other tests
>> > > pass. And the child process would inherit a 0 ksm_merging_pages. (A quick test
>> > > proves it.)
>> > 
>> > If I understand correctly, all the tests are calling MADV_UNMERGEABLE,
>> > which internally calls break_ksm() in the kernel. This function replaces the
>> > KSM page with an exclusive anonymous page. However, the
>> > ksm_merging_pages counters are not updated at this point.
>> > 
>> > The function range_maps_duplicates(map, size) checks whether the pages
>> > have been unmerged. Since break_ksm() does perform the unmerge, this
>> > function returns false, and the test passes.
>> > 
>> > The ksm_merging_pages update happens later via the ksm_scan_thread().
>> > That’s why we observe that ksm_merging_pages values are not reset
>> > immediately after the test finishes.
>> > 
>> Not familiar with ksm internal. But the ksm_merging_pages counter still has
>> non-zero value when all merged pages are unmerged makes me feel odd.
>> 
>> > If we add a sleep(1) after the MADV_UNMERGEABLE call, we can see that
>> > the ksm_merging_pages values are reset after the sleep.
>> > 
>> > Once the test completes successfully, we can call ksm_unmerge(), which
>> > will immediately reset the ksm_merging_pages value. This way, in the fork
>> > test, the child process will also see the correct value.
>> > > So which part of the story I missed?
>> > > 
>> > So, during the cleanup phase after a successful test, we can call
>> > ksm_unmerge() to reset the counter. Do you see any issue with
>> > this approach?
>> > 
>> It looks there is no issue with an extra ksm_unmerge().
>> 
>> But one more question. Why an extra ksm_unmerge() could help.
>> 
>> Here is what we have during test:
>> 
>> 
>>    test_prot_none()
>>        !range_maps_duplicates()
>>        ksm_unmerge()                  1) <--- newly add
>>    test_prctl_fork()
>>        >--- in child
>>        __mmap_and_merge_range()
>>            ksm_unmerge()              2) <--- already have
>> 
>> As you mentioned above ksm_unmerge() would immediately reset
>> ksm_merging_pages, why ksm_unmerge() at 2) still leave ksm_merging_pages
>> non-zero? And the one at 1) could help.
>
>
>From the debugging, what I understood is:
>
>When we perform fork(), MADV_MERGEABLE, or PR_SET_MEMORY_MERGE, the
>mm_struct of the process gets added to the ksm_mm_slot list. As a
>result, both the parent and child processes’ mm_struct structures
>will be present in ksm_mm_slot.
>
>When KSM merges the pages, it creates a ksm_rmap_item for each page,
>and the ksm_merging_pages counter is incremented accordingly.
>
>Since the parent process did the merge, its mm_struct is present in
>ksm_mm_slot, and ksm_rmap_item entries are created for all the merged
>pages.
>
>When a process is forked, the child’s mm_struct is also added to
>ksm_mm_slot, and it inherits the ksm_merging_pages count. However,
>no ksm_rmap_item entries are created for the child process because it
>did not do any merge.
>
>When ksm_unmerge() is called, it iterates over all processes in
>ksm_mm_slot. In our case, both the parent and child are present. It
>first processes the parent, which has ksm_rmap_item entries, so it
>unmerges the pages and resets the ksm_merging_pages counter.
>
>For the child, since it did not perform any actual merging, it does not
>have any ksm_rmap_item entries. Therefore, there are no pages to unmerge,
>and the counter remains unchanged.
>

Thanks for the detailed analysis.

So the key is child has no ksm_rmap_item which will not clear ksm_merging_page
on ksm_unmerge().

>So, only processes that performed KSM merging will have their counters
>updated during ksm_unmerge(). The child process, having not initiated any
>merging, retains the inherited counter value without any update.
>
>So from a testing point of view, I think it is better to reset the
>counters as part of the cleanup code to ensure that the next tests do
>not get incorrect values.
>

Hmm... I agree from the test point of view based on current situation.

While maybe this is also a check point for later version.

>The question I have is: is it correct to keep the inherited
>|ksm_merging_page|
>value in the child or Should we reset it to 0 during |ksm_fork()|?
>

Very good question. There looks to be something wrong, but I am not sure this
is the correct way.

>> 
>> Or there is still some timing issue like sleep(1) you did?
>> 

-- 
Wei Yang
Help you, Help me

