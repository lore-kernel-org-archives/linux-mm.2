Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C07CC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 05:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F204F6B0095; Mon,  7 Sep 2026 01:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF80E6B009B; Mon,  7 Sep 2026 01:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36316B009D; Mon,  7 Sep 2026 01:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF8246B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:38:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CA331C1803
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:38:43 +0000 (UTC)
X-FDA: 85185861726.28.C0F32AC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5ACB21C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:38:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xe1VRFld;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788759521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gueox05OZHkoqftRBagK9JDBQI7MbQBCBYDAGveUozc=;
	b=TGMILG6Gq4ff6MAUGGE1WqWB0Fkn69+yTt7E0JFVYxkXoR3yTf5SMAlxahBNa/gM7lMBRQ
	FsLn+lCcda+QqVX6l1cqtKI/K0IP6gKeINyGpBIwyWVOjjj2WV0JESPuEkWynDJlry2Zd7
	0IwZPJP+mx8jGra1nYb1Twyc1vPB1sg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788759521;
	b=NaGYhELoXLr1hkN5mwSmahTIjUerKZBlW72XqOlw+kVePX3opN82W5hACaR9XNKuNdX38f
	Zzq7fQF1rIpsTpZb0mkhT27/X87FhLTg3tG5YfGIvBMl+924RxioMrhoz3a32jXPabhFn1
	9KQwDlpdlICFXWkbzmQkgGwENob+gh4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xe1VRFld;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79AE81477;
	Sun,  6 Sep 2026 22:38:36 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A0B73F7B4;
	Sun,  6 Sep 2026 22:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788759520; bh=MkB23r4IshMaLslpYaUeiocUPY8Zusw8p75PzrXbS64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xe1VRFldIAz//b+Qnx8IF7QSBg1x6cwQvY0Uf0DmMQJs5x0znk3lcV/ibVWVlT+ZS
	 lKBdaP3DKAY+W+Wji3qSZQLUsdxuEb6gWeOd0RBML5tOuNhr8VhKw/xBfPkepnTt9N
	 fHJd92x/O/d4hd/3te19hExLk6a19mtAr/4/pleo=
Message-ID: <12efdc7f-ff82-412b-b79d-bff211d34218@arm.com>
Date: Mon, 7 Sep 2026 11:08:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260901054358.4049095-1-dev.jain@arm.com>
 <20260901054358.4049095-6-dev.jain@arm.com>
 <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5ACB21C0002
X-Stat-Signature: bu3bc9zngsjn699u6g61nrn4mup9o7qd
X-Rspam-User: 
X-HE-Tag: 1788759521-355301
X-HE-Meta: U2FsdGVkX1+28l3HijBo7cpIhVRUYrROQTUkA5bIwrwo+TAZEhYK7Y3IRsYTCFXPj4zIOTaisxXbi680OecsAkf4dEFiRR46CWVpJDK/YELlPohtuYnEPO/pSN+dJdx9NcMO8OW8Cpvv2k0TKBdHLfi2At+cirU8tZ1lBaymdr7e28rUmqhnWBlRk84z565uj6sUIHT490f42Vt9GJnkCYoUmvZBKRxcVwQG0pj+WUY1gL7NKyHKCn3K+dcy8vM9dLeVdw0bRnFmKG+P0t39Yi9sMmq16PmWUkdaR/Tyi0B0KTmOqE8glJU9yy3g2labFtfFo8PVxeRlVmCzIsGPBtZpWKTE/Pdj+8mEXN+lcWH89s8Hy6AGor2YnJQVCYJqi9lXDTT6CYicMFK22ohc39wOSJ/Ko2i16r7XyPA0E08ZM0ABO2eeiOYwER+TY3/jrWkreTtYW4GjfrliCi9Yh4N7Xo5KDnqQz/yxPBcEmkgXrbOZeuBVfSZoatZ7FAhNv8awlfCfvboExqskDOxmtJmDuGKZJBOMq6mFasITHO13rPpkiuSTwoH1rJE6HQVg+/TB+hMUAGo0P50hKBdAg1OMSP+z8k/9HCIDCLqo6eeZcEHzccN6W8szsLsnJcbR+xzYe5lar/vuGgUDHSOZzrcDcTWrZYCNCoURemAKvIT+QJY/xlWAlbdNODwC0ZlFWE6IE/9JbFr/efmesIUuOC+DfPSk8MqtQV54/Z3BNcnTbHXUKuYmL/35P05by5K0cn8ookArJ1ppl3NR5UjXBSTy+xs+vneWiDhtB/5wf9DmkgrBAp6/sGuRxqYEVeSM1+TSapCYBA+lU/5bW/ckIcwNk49kW8cVo3cbAGtXddQBeQ326N0o3Yvte8NOgLOSgh55wSTyNrO7IMvtc1g8ZZjmaaBWMH6hEibdY1NpGCpVApwTHmCuYCubR+JZ9oaJl450C+K2sM89qCzRfBk
 S4d8FejE
 rR2Xwbf0LAx+WPn0Uo8o1I+4xeG411aCvYwFKI3TCfbO5Jr10hed4jkNxWnPy1UWDJRLIyd0KZfQapB0kIeMChREmT4vAZKiFInn1CwY+nW2B15DFK4QgVUVrTVLKIlCamh+KitUm4WL7ss0WdCfgRfZuLc7ASeNjuZezZPA0QdqIq/JrIjiEgmnh33Ga0z1MIwxRCT/aAG1tyJCE+bTt9j7uCjLmxThAfPW9fw732ZqZ7K67xTLXWhuYsHA6khXgfe3DhDgxg3YCPDvV9WzTdcEA/jjPsRikClG4Qsx/VlJjpXi19l7U9ncMPbebzoiVG90IVkbdaxv/8Kod/e3Y6U6RZCXa0ANpCF8cJp7CP0FgQlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/26 4:12 pm, Barry Song wrote:
> On Tue, Sep 1, 2026 at 1:44 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> In preparation for adding a helper to set softleaf ptes in one go,
>> generalize the swap entry helpers shifting the swap offset by delta,
>> for softleaves.
>>
>> Note that the soft-dirty bit, exclusive bit and uffd bit preservation
>> will still work for non-swap softleaves, since a softleaf entry is
>> constructed out of a type and offset, and those bits are ahead of
>> the soft-dirty, exclusive and uffd bits.
>>
>> For example, for a migration entry, pte_swp_exclusive() will return
>> false, as the exclusivity is encoded in the type itself
>> (SOFTLEAF_MIGRATION_READ_EXCLUSIVE).
> 
> I don't quite understand why you mention this. Is anyone calling
> `pte_swp_exclusive()` on a migration entry? Shouldn't it only be called
> when `softleaf_is_swap()` is true?

You are right. I just wanted to emphasize the second paragraph - that the
pte_move_swp_offset will also work for softleaf entries. But I think
the third para confuses more, I'll drop it.

> 
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks.


> 
>> ---
>>  mm/internal.h | 29 +++++++++++++++--------------
>>  mm/memory.c   |  4 ++--
>>  2 files changed, 17 insertions(+), 16 deletions(-)
>>
> [...]
>>
>>  /**
>> @@ -523,7 +524,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
>>   */
>>  static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>>  {
> 
> We might find a user for this in the future, in which case we might
> want to rename `swap_pte_batch()` to `swap_softleaf_batch()`?

That is what is being done here:
https://lore.kernel.org/all/20260813-migrate-rmap-batch-v2-1-3c5424c555c7@amd.com/

I don't have a strong opinion, I can also generalize this right now.


> 
>> -       pte_t expected_pte = pte_next_swp_offset(pte);
>> +       pte_t expected_pte = pte_next_softleaf_offset(pte);
> 
> Best Regards
> Barry


