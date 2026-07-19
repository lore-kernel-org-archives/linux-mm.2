Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D54C44521
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 01:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754946B0088; Sat, 18 Jul 2026 21:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705C96B008A; Sat, 18 Jul 2026 21:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61ACC6B008C; Sat, 18 Jul 2026 21:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9F16B0088
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 21:46:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 894FA80514
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 01:45:59 +0000 (UTC)
X-FDA: 85003835238.18.12B92CD
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64FC4A0007
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 01:45:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="wM85+XG/";
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784425557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npjWI4sepkXG3SfpWUN7QMm7qm2VcJzaC7SQ+AT6TP4=;
	b=eexfPH+fIisdt2xauiPhZj5xFqPORd1bXaNzkn0RFBJsL9M3361UNa+e1a++nmlCLZQHMc
	jjGhWlmYRwHxhe0jJXaygS5gaT/Vep+VmTMrdLfqaa+D2Jpw6I75y/KhhNm6aIupcNNoSU
	rb7ng0JHDIthhCB3RzJMZHWbDuas/K8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784425557;
	b=pSDkgEz4p0bCkpxfsATy/u1YJrvqUQPQ3D9fK0U7MU5vGZHMhYEeTJ+YoPc0JYH+ZWGjjA
	WlqHFx5eKbuGxb/P0kocjc5a55t1qu/DJzfvUmK/6mV8JRvLcb28LYXud+63DCWI7NSY10
	8Ofr0wsh58CKAk/RbII+B/NKrGPWflw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="wM85+XG/";
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784425553; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=npjWI4sepkXG3SfpWUN7QMm7qm2VcJzaC7SQ+AT6TP4=;
	b=wM85+XG/E+8+gGmYq8/a6vw1wA4R8ajT4X9LbjyQiOm5F0ha3tuDFXaGWKcJotmnaaCEL+dHrvSZSWqYKV8YyxVLL5cSvLXqomVfDDo4EJhkeCBeb45S8i2KVQt4elj4d4Mpi1r/0TlmIX4caMYePfpbwGjqxsZH1gawz6JFoqc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X7KvgGE_1784425550;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7KvgGE_1784425550 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 19 Jul 2026 09:45:52 +0800
Message-ID: <eb395442-0aad-428a-a5ac-9072d2d89060@linux.alibaba.com>
Date: Sun, 19 Jul 2026 09:45:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm: mglru: promote mapped executable folios after
 first usage
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 mhocko@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1784268206.git.baolin.wang@linux.alibaba.com>
 <7db4d1975cf04e3e48157f98bdf398565ee189a4.1784268206.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7CkuWfPfrMe9jPypW4zibHG-nFCmH26xR7u0Z6zhOvQpA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7CkuWfPfrMe9jPypW4zibHG-nFCmH26xR7u0Z6zhOvQpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64FC4A0007
X-Stat-Signature: xqaw88i9gfg1y4oistsihuxje1b5tw6m
X-HE-Tag: 1784425556-260179
X-HE-Meta: U2FsdGVkX1/0DP521BO0RazWV6QjNB9VuNRo21jTs3O8LtpuhBjZRaEvKuLAgCi628O8W8UIMCgY/q4AhX74alOT7x09ntxVWN1tm26K1yqkqpHVC7Rn6A+HEA513ZLhAoTTXgDQ+4ccoFuS+EiW3+EkO4KgtSq57Q3Dxhu7Dxhzs+NRp3/yfguv/8vdGh/W335/97ygO10aS5J5IA1W18gX+cb4gSIV7nXdG/tJnIt0z7WGiyOIXufEKHaCktpKCU95m69L0QvJJpbpjN7FHCDjQpgjjDkJE+uXrQsfRf8XCSdnzNQgB6Kx9GbolahpV9F7fTL1o0aoIWTeH3/YlOIv6sVG/SR+Lf+LiGULz0Bp+U0Phz+oNaey7vKhfT1MLfAl3ST41Hod78sQFDwcpDoGqGhJwtaoJvk6cc3pfz05+V7SnzUGlPPxHzI9MLmgphSOK3ZwChheCQhkHOQ3tWeLvigZ9kYk0J2bdwt9nq5EoTfvagez2wzfthbMU8tbKBE1UVDpSgLVQBBnglufrdZKDPav1WDVmbVv4PzYOlOqTmdFr3rAUAFT6dgdfwc2JmGu3UAkNCc73kHPOAf4HuyUjmQWuJyiFoWxGiQYm4HMkI4wk+SmfZdrfkxgUQpcwxjW4JlrUwRFqMxa83MY/y2/uYOQ/3zz01jpMNta6l64O92TcBhVmuxBaN/iPPBjDjYQyM7cpkrcpLtumam/0Jz8HG+mildG+pN4Fo9Ocvp72E8AH5DqbUgbZjV+UTMGTPbE5JsrKSLULx5qANpY88OKPWoBtqe9n3GYw9QPycWFTFwY4svHYg83bO4+qxUWTj0FXxMjWmHqHILveJPRmgGDtxEIhs9pAkZO+IDb+MMnPJadW92sTX95UTtBWgM2mwb9rrbjBDqZHQKLHoGSSJTvnDjAdo2hIX+ploDGkitWYGCBVmjw+z/nTgV7TwxQMfFKywT5jKUdJqnwXwG
 Ee8Q1Bxr
 HhYsNTRoATdXpeJqux05HmtD7F6f8nNFySUjwZiWCidil0d10bVWvJ0dZoW52CaV6M7RAmHuU+yviuAOxrDsQBkU8DEYYD2e4J6vw+dyBgZqNCb3Lvug2XC6JogtqUe25DasSglQUiZaT08LhKogQi3Z1OmhXk9ek4SkzTwg4ffJLOAEOEPz+DFeyqeDkO0m9mtD2WUBAkMNJGOotQ+zDC/oePbvzxjuc4GswDTAljvHe3j197IhoHr7AiZLKEPUUutlm4lB+zVpbPSDdLOZfrsnvGUA+pJV4dKlOuE2dWFjRNcHYpbLXRYKNDRUaAM3OqbQu0gOY53MvPiX4zyV7dE3794m1scUfJAX9zbYokgneRjT1G4tAVjw5RpO89SqbVvEmgNXyI8QGxI8wp++20wX/ORxH9964GNAp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/19/26 3:23 AM, Kairui Song wrote:
> On Fri, Jul 17, 2026 at 6:06 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Classical LRU protects mapped executable file folios through commit
>> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
>> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
>> after first usage"), giving executable code a better chance to stay in
>> memory, avoiding IO thrashing and improving workload performance.
>>
>> However, MGLRU's protection of mapped executable file folios is less
>> reliable. Although shrink_folio_list() checks references, the access flag
>> of mapped executable file folios may have already been checked and
>> cleared by lru_gen_look_around() or walk_mm(). Additionally,
>> folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
>> flag for mapped executable file folios, which causes shrink_folio_list()
>> to ignore the first usage of these mapped executable file folios and
>> reclaim them easily.
>>
>> Follow the classical LRU's logic, promoting mapped executable file folios
>> after their first usage in folio_update_gen() and lru_gen_set_refs(),
>> giving executable code a better chance to stay in memory.
>>
>> On my 32-core Arm machine, with the memcg limit set to 2G, running
>> 'make -j32' to build kernel showed some improvement in sys time.
>>
>> base                    patched
>> 9248.543s               7861.579s
>>
>> While we are at it, introduce a new helper to check mapped executable
>> file folios.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/vmscan.c | 47 +++++++++++++++++++++++++++++++----------------
>>   1 file changed, 31 insertions(+), 16 deletions(-)
> 
> Hi Baolin, thanks for the update, looks good to me with two nit picks:
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index de62899c108d..1040bf9f96e8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -268,6 +268,12 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
>>   }
>>   #endif
>>
>> +static inline bool is_exec_file_folio(const struct folio *folio,
>> +               const vma_flags_t *vma_flags)
>> +{
>> +       return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
>> +}
>> +
>>   static void set_task_reclaim_state(struct task_struct *task,
>>                                     struct reclaim_state *rs)
>>   {
>> @@ -835,11 +841,15 @@ enum folio_references {
>>    * with PG_active set. In contrast, the aging (page table walk) path uses
>>    * folio_update_gen().
>>    */
>> -static bool lru_gen_set_refs(struct folio *folio)
>> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>>   {
>>          /* see the comment on LRU_REFS_FLAGS */
>>          if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>>                  set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
>> +               /* Activate file-backed executable folios after first usage. */
>> +               if (is_exec_file_folio(folio, vma_flags))
>> +                       return true;
>> +
> 
> This somehow missed the PG_workingset below?

I was following the original logic of this function, which calls 
folio_mark_accessed() before promoting. But after re-reading the comment 
on LRU_REFS_FLAGS:

"
* For folios accessed multiple times through page tables, folio_update_gen()
  * from a page table walk or lru_gen_set_refs() from a rmap walk sets
  * PG_referenced after the accessed bit is cleared for the first time.
  * Thereafter, those two paths set PG_workingset and promote folios to the
  * youngest generation. Like folio_inc_gen(), folio_update_gen() also 
clears
  * PG_referenced. Note that for this case, LRU_REFS_MASK is not used.
"

I agree that I should set PG_workingset and clear LRU_REFS_FLAGS before 
promoting the executable file folios. And sashiko[1] also pointed this 
out. So I'll change it.

[1] 
https://sashiko.dev/#/patchset/cover.1784197559.git.baolin.wang%40linux.alibaba.com

Additionally, I think Barry's earlier patch[2] also has an issue: when 
lru_gen_set_refs() returns true to promote the folio, we should also 
clear LRU_REFS_FLAGS, rather than calling folio_mark_accessed(). So in 
my opinion, when we call folio_mark_accessed(), we should return false 
and should not promote the folio, so the logic shoule be:

static bool lru_gen_set_refs(struct folio *folio)
{
	/* see the comment on LRU_REFS_FLAGS */
	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
		return false;
	}

	/* Promote on second access */
	if (folio_lru_refs(folio) > 1) {
		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
		return true;
	}

	folio_mark_accessed(folio);
	return false;
}

What do you think? I'd like to send a fix first to correct the logic here.

[2] 
https://lore.kernel.org/linux-mm/20260526130938.66253-1-baohua@kernel.org/

>>                  return false;
>>          }
>>
>> @@ -851,7 +861,7 @@ static bool lru_gen_set_refs(struct folio *folio)
>>          return true;
>>   }
>>   #else
>> -static bool lru_gen_set_refs(struct folio *folio)
>> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>>   {
>>          return false;
>>   }
>> @@ -886,7 +896,7 @@ static enum folio_references folio_check_references(struct folio *folio,
>>                  if (!referenced_ptes)
>>                          return FOLIOREF_RECLAIM;
>>
>> -               return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
>> +               return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
>>          }
>>
>>          referenced_folio = folio_test_clear_referenced(folio);
>> @@ -914,7 +924,7 @@ static enum folio_references folio_check_references(struct folio *folio,
>>                  /*
>>                   * Activate file-backed executable folios after first usage.
>>                   */
>> -               if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
>> +               if (is_exec_file_folio(folio, &vma_flags))
>>                          return FOLIOREF_ACTIVATE;
>>
>>                  return FOLIOREF_KEEP;
>> @@ -2119,7 +2129,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>>                           * IO, plus JVM can create lots of anon VM_EXEC folios,
>>                           * so we ignore them here.
>>                           */
>> -                       if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
>> +                       if (is_exec_file_folio(folio, &vma_flags)) {
>>                                  nr_rotated += folio_nr_pages(folio);
>>                                  list_add(&folio->lru, &l_active);
>>                                  continue;
>> @@ -3188,7 +3198,7 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
>>    ******************************************************************************/
>>
>>   /* promote pages accessed through page tables */
>> -static int folio_update_gen(struct folio *folio, int gen)
>> +static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
>>   {
>>          unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
>>
>> @@ -3196,10 +3206,15 @@ static int folio_update_gen(struct folio *folio, int gen)
>>
>>          /* see the comment on LRU_REFS_FLAGS */
>>          if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>> +               /* Activate file-backed executable folios after first usage. */
>> +               if (is_exec_file_folio(folio, vma_flags))
>> +                       goto promote;
>> +
> 
> Will it be cleaner if we just:
> 
> /*
> * See the comment on LRU_REFS_FLAGS, and we protect the executable
> * parts to avoid typical IO thrashing from reclaiming.
> */
> if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
>      !is_exec_file_folio(folio, vma_flags)) {
>      set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
>      return -1;
> }

Yes. Much cleaner. Will do. Thanks for reviewing.

