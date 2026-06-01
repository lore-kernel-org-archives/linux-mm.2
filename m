Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42152CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B706B044B; Mon,  1 Jun 2026 12:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC6D6B044D; Mon,  1 Jun 2026 12:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB0B6B044E; Mon,  1 Jun 2026 12:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0A46B044B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:08:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E306BC2466
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:08:01 +0000 (UTC)
X-FDA: 84831825162.01.0042E85
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id 08A3F40010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:07:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KFCrv1SH;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330080;
	b=LCs7d/dnPkfI3M1JEwP/oQ39n5ZRKtVAE837LHR5cmUfMzZqGl4bOHkbP/8bOyDFZFNkQ1
	n0LGTgx8jmELB8pb1STPLnf303xVTQyGjUQvsTyTjL5COV0D93vIuMF7TbqiivPujOwXHS
	jwq7aUrN973gzwJ+ohO+sr41wt2wA/I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KFCrv1SH;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hE1QzaSPeeuEtKpkpB1CtsBNbDEAW/Bexb+NhfT6llo=;
	b=K6qWk06oSmXxtVq0/m39DVhRUmcsw7hAa7RnugU9Mv+rJkaj+x7g5KcOvTWNREmiDXK37l
	RlptCAnOlAZ/VB9vzdjqFbEFKdD2BYoSkTKFToB1FBu0KxHZSljGAZEz54qp7orWGxVhnA
	OMde6LUcly2YdYmHFR6sODzU+1VReRA=
Message-ID: <76ff7922-bf54-472c-a628-ee191aeaf149@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780330077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hE1QzaSPeeuEtKpkpB1CtsBNbDEAW/Bexb+NhfT6llo=;
	b=KFCrv1SHIW6rKf6zXja1OJy3cyn2UvdGKCE3ASX3JWUedBw+K0MFreVvLWyzIJ7q05O895
	rvnhDuiR+5P9eKG7V9B0yQvbhmbdS8hrfybIXAU8pDudK2wZzqls5tbU4qer7NuOTc/QAp
	Jg8Y8lhEBuDUt90t+eGNkP5jGSXBzPs=
Date: Tue, 2 Jun 2026 00:07:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
 <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
 <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
 <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
 <0bb49c47-8c41-478c-847e-b9154c75e59c@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <0bb49c47-8c41-478c-847e-b9154c75e59c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08A3F40010
X-Rspam-User: 
X-Stat-Signature: zktxwuc1x3kg5rq7ke8w7uw8mqozdqyb
X-HE-Tag: 1780330079-839237
X-HE-Meta: U2FsdGVkX18pp0NuBpZ9jImwwiF8MxilMW5zyG03GF1gM+Rmv7K/22wMT5IkKdDC/OCFsWsQ57AHQcJ0xhr78CEsFhfL+boi+LN1rKNx2o6lRq901ggU8C5eDu4JSRYjpXH4H/6HL3F0QeQ9O4AebTGfLZ7sSWv77/EQm8bwtXuGTIi5ArnujhhBTHpkF2Z3MwIEP6wozNHMZzUbbBf8KcfIBSHEZvh1maJnjJlCcZzrxn2WgOwlqWAutj7C3AMNEUlbG1E0JZic+8XvRsxqfaaF1QKUOvrg7I0xdxKiypOrWqB6+IV02sn4dvsYy2jIsEL5z7zDwAtPhl0o+05cW3SCgm3WD8rm0WlVKs0O62g/JrhxdjXlTm7c+q35M6MX2QGvQYdG2r7oAqts481O66Q3tIGPrOE0Nr0QbCR3iWTJFQpFjIV3f1OvrK9EvUxlht5yEOvpPz0MPPPyETCuehoqGSOPn/Oycc6FNS+6MLYmVb7seQq1LjpOW1oI0nejlc+rdcWB5jyWo9qreTZ/2746+pP6L9+NHjD7jVYU6X6mFBZ3lU6vbRcne5o0/rhDBLpeHsTYG4GXeO68q49FiVdC1odzGfnoZD15gDBRjAXzhCT21CXncgyXWvcIjVp/wkQ30xfZxOJxdLKezmRgct1ot5Nb4V0wtfu0pS0PcjqozFHAOWoDYfC8IO+UryebDliHTdvBzt9cLDSUb0vlnC+A8BTlWup4d3YDMDDLXffdB0MqAYfH0sjYGDrYwe28ldoWWkvkPBgBdO2NTcQ5fVf9JkN0GNrxwoRqwe46nn6sWb26bsxBEKTuHigkw+o+pIX+vUM3KD1St9V6iGuwDr6Xaqytq/bmKj9Nal8oQ4ypgiw5KSFFy1dt836ecEpH6Kd0dQpcZym086dXAu/DB3s7Pkf4lWY+f0jUWkPmHclb1/HSoF6A/l2xfGcb4FCEwsDZPtzJ+Xsv00ylKdP
 O6+Zp3Ga
 tVBLlO7joZMXYIdX1bjitSXAHrwxGSZfOiqMDI5ilOIJXj96cMFXj0+ojJ3scwazC1MuE6cMp+/i7QhvtD2sZCbvLCxNlCp7rX4xyUbaGnAwbVAIXC7cqShA+0v8OEPpPQg1lICYx0b3RqfquafBqm6bbC2xz6I0Q82vsibj2VKmtMq7pPMtTcawdeBvVu9vgP0BagaHwbMhP/B/21RbIzFd/ESdsySpGm9kuzeAEje6Mv04FSTHOyLnkL7+C5lR/36ivgfjoZzoTyV3/RDxmEjwEsyqAJTOvY/rtIrpSVOM+hksmBgkksPBT5vMdVyE4ws1DSkdJpDSulE30OZduWBrtZqxmtiEaqA4SgUlWG5p1D2r1uuOWhcfBUBrz+d7nC1nW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 23:05, David Hildenbrand (Arm) wrote:
> On 6/1/26 17:00, Nico Pache wrote:
>> On Mon, Jun 1, 2026 at 5:14 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>> On 6/1/26 12:47, Lance Yang wrote:
>>>>
>>>>
>>>>
>>>> Ah, cool! __folio_mark_uptodate() already does the job :P
>>>>
>>>> So yeah, no extra smp_wmb() needed here!
>>>
>>> Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my code as a
>>> draft.
>>
>> Okay, I read the above and did some investigating.
>>
>> I will try to implement and verify the changes you suggested :)
>>
>> Or an even crazier idea... what if we ensure MIPS checks for PMD_none
>> before walking a PTE table?
> 
> But how would they update the cache then correctly?
> 
> I'm too non-MIPS to know the answer :)

Right, that's my concern as well ...

If MIPS sees pmd_none(), it has no PTE table to walk, so it also has
no way to do the cache update it wanted to do, I guess :)

But, the PTE table is not really gone there. khugepaged only cleared
the PMD temporarily while still using the old PTE table through _pmd.

So I'd go with David's suggestion:

"
Best to make sure the page table is already installed when updating
the entries.
"

Cheers, Lance

