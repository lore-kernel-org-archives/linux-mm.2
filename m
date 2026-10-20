Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39A9606A324
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JH5lIuMK
Received: by kanga.kvack.org (Postfix)
	id C09816B014C; Tue, 20 Oct 2026 05:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE11E6B014E; Tue, 20 Oct 2026 05:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F196B0150; Tue, 20 Oct 2026 05:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4666B014C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:28:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 004B01A091B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:28:01 +0000 (UTC)
X-FDA: 85342478004.15.BBFA66E
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id D394980006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:27:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JH5lIuMK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792488480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qm5hxrzsx0yRdSYYG6OEY4PTPJuPDuREv28P0/x7drY=;
	b=IZvbBfoKyuOHbP6erXu2fxLDd3kuFZjtkRquuo07nvpBk5jlc7qvlb7heppjE4g465FwBE
	3ilqLKxQRMVC4xIkzQhcjzIj67Hkn8DdcL0yUOUMJId/XiwjFpc9v6rq203QYNrZ6x4vQ+
	MVoXU3ppDYIJ+EA0ougloOk4wxQuScE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JH5lIuMK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792488480;
	b=ume46m2IFPXwhD4+fz8AN10DuPVkDo4smUVYgdZPH8MbfKI6RiLWfR2zvvCUsC9G3WSF8j
	ehWbCshmF8mkp3Hs2JLzmYwwYR+pKy5CCYvgNmn+ZeuxMdOdqpKNzobSDhPoeMkMzNVav9
	zihVKtzqCdPGNPctJxf+ukVPUoMPxiw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=msM+cZjAKkwGVsfaQzIbcjbAhIHFxqTzbEiHo39glFo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792488478; v=1; x=1793093278;
 b=JH5lIuMK8SSfFBgtPncMAzzNJQhAmW8ijEW1eP/P+r6H0R2ICX53BgNHF4WT+89bsb0fEL4A
 eUT4F4AjH2UNdQPbWp5ZVTghVEcFbpRyi57cmo7fL1Gb+2/t4sycemaCV3Fc8PU8JXYVaAWyEGu
 IDPsHhWlco6JEZsl44EYKkYc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f945068c0369cb3a;
	Tue, 20 Oct 2026 09:27:58 +0000
X-Mizu-Trace-ID: f945068c0369cb3a
X-Migadu-Flow: FLOW_OUT
Message-ID: <8aa3e14d-6573-4359-919d-a8e9d372032f@linux.dev>
Date: Tue, 20 Oct 2026 17:27:49 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in
 lru_gen_folio_seq()
To: Barry Song <baohua@kernel.org>, Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
 <CAMgjq7BonFtsvHMRYXXToqWBHTzNa52EU9B4ZqD-k-DJ2inQDg@mail.gmail.com>
 <CAGsJ_4yAYMiRoJRLLt9B_+qdMhOFmizDy-PSbQ3jkMxV0zJqPA@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4yAYMiRoJRLLt9B_+qdMhOFmizDy-PSbQ3jkMxV0zJqPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D394980006
X-Stat-Signature: qkwg6bgp8wr9q3fnjrtqtgx1zisbt4p1
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792488479-819297
X-HE-Meta: U2FsdGVkX1+PR4cNsm3vtxteYjZK3f+RnsHJaW8Jz8Xp6Bj5W24l4nBF0gbhN+jWP1ZEJ1HbFIJxI4Clx4+Yve0FSI2mD5AdPIwWpK60lrHwKG0cXMLvxCVRTutG02mb2NilDgMMEInRH447DvpKqb0IDw2SFGbwmO8uHF+BUaDtJ7uq1SObT6w+zzu9l/3zZ+oujklXQ8grtMKm1BAVmKErmM/0bBlAdj3huDjBztramwKnovsEbcPu6imVx9dw6TNLDINTAkE9DGpRy4abtSurAlQxM8vI11GdHBl2ss0FEH18m/A1u0hARLnGcp3CYzGYJP+57tndnrp21QE5qs1JDWhAHL8jnyxRczjUjgODnoIjjo6Gpi9X+d2HgGLK71oCtqGLlUB+ipV/It5yc0HhMsLhSkvhVaXyHf1E/qMV18j26zT3ZWhc7qdPmQRCYBHVzAu/oAb4eBQUM+qN0K33j4B6bE87yG/MN4Nuypai3YpXOpnSsIKO+ZSjOnK6E+b1HD/f75P4balxXKrFUFsar/3Mp8i3b+DvrQdUuT1LVA9Ql/fdIIw/jSnf1Brk8phceFTAwfQiSk0YmF3hDb3hayWc4LgmVQP0l1/SbBernH/IceL3L7LSQdc1FUcrPIHJ1PtiEeb1EssfS7DXDWnx2GwwH0j276HdItSNxiBlL/gVYl1/LBcj2H+Qdv1jTP+zq5nVVgWy6kBjWqAG5f2Jb8rb5tz+Rk39lDw9RpKOqDCmLQF8UYxm/2JDtXNjvmoxxZtOYNmgC7DwNQoDAHuZ9sfCi7zmnKmUdfrZvpNRKirDTpY7xzF/GjYjZaa+SDMPQkJrPPb1yc4rdZiM6nekSjbjix3X4unGbWnWq8dte+BEjvecQDhKEb2i0/Nrhw47upw+FQu5kDLP0/DbnBGnINTdKBOEV94avV/0MluNsSpS3gbIh2FdtDsiBLkGHz9uKRPD3AHTF6mqYNg
 PmwPnSv9
 Dlnz8w8+r5an8rQp2PUDibTdBu9QxzCkpgdqRvchUBVVl3Mii+XkEsVIscNTkVEXLvgZJjFu62o0HLMSarj5Kmcewnu9wbAZ1MK7Ko9GNIxcCgt6dcZk94usMHaJniwZczXhPJSMc75dZcMycmTkgV8C4QNE7jBrGiVMkuf6OdAsXBXCXv1G15EW0EWlHFxa2sHJcEE30mdy6Li0iyjVp0xnFV3dUgBYgxR0YgamUG3BTnQzCN5Q5CgLfXOhRCJ3Pp1PY6J18z3OFQ10oVNvW6KNXX0zDUpDjDl+TxuHxfVgiAZylPJiqXlsHy8xvLLvqbVAyBDPPI0QymuoTpQGh7s0/5rxxMWMHzYlGwl6PIh//Lf/PPp9z6oWSuvy84w/VUIWEbEoLG5yz9dM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/2026 4:29 PM, Barry Song wrote:
> On Tue, Oct 20, 2026 at 4:20 PM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Tue, Oct 20, 2026 at 10:36 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>
>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>
>>> lru_gen_folio_seq() computes how many generations below max_seq a
>>> folio should be added to, but stores it in a variable named "gen".
>>> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
>>> seq % MAX_NR_GENS, so reusing the name for a relative offset is
>>> confusing.
>>>
>>> The comment table above the code also no longer matches it. It only
>>> covers the PG_active and the final branch, leaving out the reclaiming
>>> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
>>> although lru_gen_folio_seq() never looks at it.
>>>
>>> Rename the local variable to "age", redraw the table so that each
>>> branch maps to the age and seq it produces, and note that the result
>>> is clamped to min_seq[type].
>>>
>>> No functional change.
>>>
>>> Assisted-by: LLM
>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>> ---
>>>   include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++-------------
>>>   1 file changed, 32 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>>> index ab69b9930893..a933d8c14558 100644
>>> --- a/include/linux/mm_inline.h
>>> +++ b/include/linux/mm_inline.h
>>> @@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>>>                                                const struct folio *folio,
>>>                                                bool reclaiming)
>>>   {
>>> -       int gen;
>>> +       int age;
>>>          int type = folio_is_file_lru(folio);
>>>          const struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>>
>>>          /*
>>> -        * +-----------------------------------+-----------------------------------+
>>> -        * | Accessed through page tables and  | Accessed through file descriptors |
>>> -        * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
>>> -        * +-----------------------------------+-----------------------------------+
>>> -        * | PG_active (set while isolated)    |                                   |
>>> -        * +-----------------+-----------------+-----------------+-----------------+
>>> -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
>>> -        * +-----------------------------------+-----------------------------------+
>>> -        * |<---------- MIN_NR_GENS ---------->|                                   |
>>> -        * |<---------------------------- MAX_NR_GENS ---------------------------->|
>>> +        *            +-----------------+-----------------+-----------------+-----------------+
>>> +        * age        |        1        |        2        |        3        |        4        |
>>> +        *            +-----------------+-----------------+-----------------+-----------------+
>>> +        * seq        |     max_seq     |    max_seq-1    |    max_seq-2    |    max_seq-3    |
>>
>> I think this comment update is not beneficial, we might have more than
>> 4 gens in the furture, so hardcoding a number is not a good idea.
>>
>>> +        *            +-----------------------------------+-----------------------------------+
>>> +        *            |<---------- MIN_NR_GENS ---------->|                                   |
>>> +        *            |<---------------------------- MAX_NR_GENS ---------------------------->|
>>> +        *            +-----------------------------------+-----------------------------------+
>>> +        *            | Accessed through page tables and  | Accessed through file descriptors |
>>> +        *            | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
>>> +        *            +-----------------+-----------------+-----------------+-----------------+
>>> +        * PG_active  |  PG_workingset  | !PG_workingset  |                 |                 |
>>> +        *            +-----------------+-----------------+-----------------+-----------------+
>>> +        * reclaiming |                 |                 |                 |     always      |
>>> +        *            +-----------------+-----------------+-----------------+-----------------+
>>> +        * can't      |                 |  anon && not in |                 |                 |
>>> +        * evict yet  |                 |  swapcache, or  |                 |                 |
>>> +        *            |                 |  PG_reclaim &&  |                 |                 |
>>> +        *            |                 | dirty/writeback |                 |                 |
>>
>> I think it's better not to describe too many details in the comment as
>> it actually easier to just look at the code.
>>

Fair points.

What confused me about the current table is that it is not clear
which dimension it is drawn along. The columns are generations, but
the rows mix access paths (page tables vs. file descriptors) with
the flags that protect each of them, and some of those, like
LRU_REFS_FLAGS, are not inputs to lru_gen_folio_seq() at all. So
when reading it next to the code, it is hard to tell which branch
puts a folio where.

How about keeping the existing table for the design overview, and
just adding a short note above it on what "age" means, without
hardcoding the number of generations, e.g.:

         /*
          * The folio is added to seq = max_seq + 1 - age, so age 1 is
          * the youngest generation. Ages up to MIN_NR_GENS are active,
          * and the result is clamped to min_seq[type].
          */

>>> +        *            +-----------------+-----------------+-----------------+-----------------+
>>> +        * else       |                 |                 |  PG_workingset  | !PG_workingset  |
>>> +        *            |                 |                 |       or        |       &&        |
>>> +        *            |                 |                 |  PG_referenced  | !PG_referenced  |
>>> +        *            +-----------------+-----------------+-----------------+-----------------+
>>> +        *
>>> +        * The resulting seq is clamped to min_seq[type].
>>>           */
>>>          if (folio_test_active(folio))
>>> -               gen = MIN_NR_GENS - folio_test_workingset(folio);
>>> +               age = MIN_NR_GENS - folio_test_workingset(folio);
>>
>> That's a very nice rename, the `gen` variable is so confusing to me
>> for a long time, I thought about renaming it to `gap`, `age` looks
>> much better. Thanks!
> 
> Agreed with the rename part. Maybe this doesn't conflict much
> with MGLRU-FG either. It could be cherry-picked before
> MGLRU-FG or included as part of the MGLRU-FG series.
> I'd vote for the latter.

Sounds good to me. Kairui, would you like to pick up the rename, and
the comment change above if you agree, as part of MGLRU-FG?

-- 
Best regards
Ridong


