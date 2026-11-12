Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F309606A89E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mSYKUxqU
Received: by kanga.kvack.org (Postfix)
	id 7A0436B05B2; Thu, 12 Nov 2026 04:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778D56B05B3; Thu, 12 Nov 2026 04:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B53E6B05B4; Thu, 12 Nov 2026 04:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8526B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:15:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF4B940502
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:15:14 +0000 (UTC)
X-FDA: 85425908148.06.48A7411
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf20.hostedemail.com (Postfix) with ESMTP id D73011C0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:15:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mSYKUxqU;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBGlhgfSSYlipgOYHctRRtvyjsaynUhxyDWcaL7Szfg=;
	b=yzBh5hEVFZ4euQCQNQJnHcmQXS/qyhOfCW9Em8fFyyySKPxd6CgQtHeiDYkl46hHJtNISl
	vk7Rg0cXYqh5HpmqZKP/kQb4ihfdx/l52F3QQsyHf55BzDOzVvuzn7l7OZ5koxexDgbo+d
	4Qpw2lQJ0MS8sEgWMAHYdjO/oCm6GAM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mSYKUxqU;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474913;
	b=Q5i1LMBFS2lAILO3f0r/cPE1RPErswHk7AGQI9XCDFgEs+QScg9QxLg3R4Gmt/Pbdy05VR
	6FScQbR+xYLrrCWVi090ufoNTB5WhloLXDgK2CN0DzumZL4R5pX1zBYIvU3NGM0XY33ie1
	A1S+8viKtaQMf4gWFTYGpBBk0JxVgVg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794474909; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JBGlhgfSSYlipgOYHctRRtvyjsaynUhxyDWcaL7Szfg=;
	b=mSYKUxqUuQZ45Q46FMsC94kqSiO46kCE8sqpm2bZm11GOOZM1J5WhRg1/a6umxQg/4fl781osaZBNRVzXloN8CNXoBV2IwON+k1sxgrEZUkYBUNkqZPvMku7iDITvMk/QvbOczpG/D8zntE4xTZUNZVEZIsGv4YkuODuBjPjgcg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XEbbjop_1794474907;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbbjop_1794474907 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 17:15:08 +0800
Message-ID: <2cd723d4-742e-46b1-8a8a-47a4db1ff8d2@linux.alibaba.com>
Date: Thu, 12 Nov 2026 17:15:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/rmap: fix PTE table overruns during batched
 reference checks
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lokesh Gidra <lokeshgidra@google.com>, Barry Song <baohua@kernel.org>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
 <20261111-pte_table_clamped_end-v1-3-2dbe339c487a@kernel.org>
 <c31cc8a0-c098-4784-a843-f13f51914094@linux.alibaba.com>
 <33b2549e-f033-42e5-82c4-a72cb0f92324@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <33b2549e-f033-42e5-82c4-a72cb0f92324@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8yqacgo1msridynfc8e887sdze9ridsh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D73011C0006
X-HE-Tag: 1794474911-995228
X-HE-Meta: U2FsdGVkX1+v0Nv+eY//7cvfAKtfqr1GCJi409RyRRbrvSFkN3ADqBf1Ortyr38qi4ttJ+scEb1+RMBr/5SLrQqGr6zhm+zLnhqyraflS007dWEuKRlV1N5Yi+kDhnl2I+Utwga1a2T4zKx3lSVXq5knOGz5RpX1RfGOfSBpjcj8MDy/THYNtU7caQYj4UstLS4FVzDkZKsU4YU3pDrfeKdUUywFh43pF1jOQjZEJffkT1IqJAHiQkFZ/Fkaxx1asX4dyhPzcPShsk+krutXFYe4FiaWOh0RbPNSmCXVR4Y+8jSqRhjqU5/tGZn4s3ggkQRSLWY70pUaocn8RWbeuKbtxEwydWcR59brkOU5lim4MkHKr9Q8CwgpQ4AThWCZ579kp60cQqqT0c35b9rhPcAamtxEKhzAd2shYkhaGOoa7f8D5Hu/+npilqQ9c+Jbas7auDDIqI3TnWr1tL8az4cWAD6QYjAdUpKZGQnPWbso2Hv0FS5g9oGDVt8A85sRsmfk2S0OxyysIWNJhwVdrvxQJvp4sk6SiwKVUf+8xMlkMGEH/BpueeuYEZjTW9MXL5PgzPbwSW8FJk+epkpxAqEibAqENFXcd6s74YQibcPEh/7FKGkk9Szxe9lfCeKV7GkmFRjsoZqY60UwNaaMc1HoID0xkbI1YDp/q9b1h+T9jY7OxtbWCzkaRYw/Srjo9owi8hACM6ic3CP+nADvFfagwZA48CU0lenXsHRGT6ZuXkR0x3UPk7W9bmH0nTFWMFbynAv4mcDp2KVIz2jm0c+uTfRpXoFS8981lPLyVP7uJZLg0H5631C/aEocb03x0DegpQZAa37mpo5/IUcd0nFM1jFeqNe17+n54g2M1aeM2RJFMAj2GwVXsk0TGJmgIvXlKSqh7cBGFiovNAuiPY7tgn49jNTz8CpvZGnfaBFhaA45BIjwMNGwuvjUeGBQbIZy/pRLToOD1gDtDhf
 +zFRZ6Fm
 0E4L0ILJpxE0Z8XW4NCB//E24H9QpvR+hjUfpicEBj9rpSqdHZfOlVc0C5xUQmHPtKsvlBQ0qeGlWjatdqLgRNXkO1CMmvSJ/mI9oPMuXfcS0VBdLPAVQgsSL3ZTDMctQtbzBHRwXKsNW9GPt9t0BDYJ1kfKqJB7yIj25OM+iq264MrP8/plnH6y1vrIe1iePVbP2owJ/8uHm6IhYhVCSNhpjVLbQGkSqVzkjMelD3/ZzmIHdkxVdD0eziyEhH5qT+6i+WtKnbb+AhDrliHYGFzSFNAgrILYrYRQwum/I6Wtj8jpUQ7YCgmoODBbyh3gJPDjRk3RfIquEGns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 4:29 PM, David Hildenbrand (Arm) wrote:
> On 11/12/26 08:25, Baolin Wang wrote:
>>
>>
>> On 11/12/26 6:00 AM, David Hildenbrand (Arm) wrote:
>>> With a folded PMD, pmd_addr_end() simply returns the supplied end.
>>> folio_referenced_one() can therefore walk past the PTE table when
>>> checking references to a large folio.
>>>
>>> Folded PMDs are uncommon, but can occur even on arm64, for example
>>> with 64K pages and a 42-bit virtual address space.
>>>
>>> Use pte_table_clamped_end() to clamp the range to the PTE table and
>>> VMA boundaries.
>>>
>>> Fixes: 52e054f71840 ("mm: rmap: support batched checks of the references for
>>> large folios")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Chris Mason <mason@kernel.org>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>
>> LGTM.
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>
>> BTW, the 'end' calculation for the batch operation in lru_gen_look_around()
>> could also use the pte_table_clamped_end() helper. But this can be a follow-up.
>>
>> end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
> 
> Cool, can you send a cleanup patch? I'd pick it up once these patches are upstream.
> 
> I'll move these into core.git today, so you can send against that for-next later
> today.

Sure.

