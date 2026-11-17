Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852F4606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OZZDYnOe
Received: by kanga.kvack.org (Postfix)
	id 7C2996B05BE; Tue, 17 Nov 2026 11:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B766B05DE; Tue, 17 Nov 2026 11:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8436B05E1; Tue, 17 Nov 2026 11:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC0B6B05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:23:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB58BA04F3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:23:35 +0000 (UTC)
X-FDA: 85445131590.27.014EDB1
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	by imf20.hostedemail.com (Postfix) with ESMTP id 77C931C0009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:23:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OZZDYnOe;
	spf=pass (imf20.hostedemail.com: domain of bradley.morgan@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932612;
	b=RwkvFrMFyEt8+q1WIIVhOxcImvI9SBuExswWTD+MjqEQbzShbQiTu1vXuvbLQJdCn0Qb/R
	88+P0A7W6g+dP78qNRG+dPrNxNYCJ9Ps2/yk5ihxRPMPhQd8gE0644ZLC0HKvpkXFsR4e9
	5O/jJ4h/vX8QEz/xKcprPCxRxhqBKYU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OZZDYnOe;
	spf=pass (imf20.hostedemail.com: domain of bradley.morgan@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=1gOxdNpoOktUbt78ygUuRKgFaA+6LpWMs6/n7RbPnMM=;
	b=sRNhskbUsYWN9DjSF9Hyq4NOMKHcYVfrkOefwyXzFHk7TRnp8G0R78L8S/fgfoQYYtr7g3
	ji9Tmf+FTZOHCa2z+CW8qV9eX8F6JuHI9z8ySjB2OydMrtWusWUPEOLfIxNrRW8SZeS6Oj
	RAZryOy4ATfffCPhyDnoLoH6T5e78ww=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N7mjm7vMXqCyNrByfjcWEsdHNqPY7UhdoQ3qsyo58eg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794932609; v=1; x=1795537409;
 b=OZZDYnOeX6IiRkPYGsxSsG5eR51bVUCR2PXGXktzAf0yhI6KbWafNWfXQ8i35FXHKKNnb4mj
 K1YYbcCbnSUjUcjs2wLKaqreWjLMPuW88Uen/1J7wHU7E7U7+/rNoazHHoDZewi61x3N+q2cRcG
 wiK3PME4EizeQIr9JC9cZUTE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c28228232a92365e;
	Tue, 17 Nov 2026 16:23:29 +0000
X-Mizu-Trace-ID: c28228232a92365e
X-Migadu-Flow: FLOW_OUT
Date: Tue, 17 Nov 2026 16:23:26 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: m.harisawan@icloud.com
CC: akpm@linux-foundation.org, bsegall@google.com, david@kernel.org,
 dietmar.eggemann@arm.com, juri.lelli@redhat.com, kees@kernel.org,
 kprateek.nayak@amd.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org,
 surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 vincent.guittot@linaro.org, vschneid@redhat.com
Subject: Re: [PATCH] fork: mark memcpy() in dup_mm() with data_race()
In-Reply-To: <179489519663.1444496.15875846661591982934@icloud.com>
Message-ID: <CAEA6A30-B69D-460C-B5A7-057F2BC6A52E@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 77C931C0009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8qbp9nqjkchtxoppph3iezjipc1igopx
X-Rspam-User: 
X-HE-Tag: 1794932612-952833
X-HE-Meta: U2FsdGVkX18th9WoiJc6RMvNvRBR13QOZDYQWTJOe2wBIHjlpf3f7YQDIrDYbneFT9GbNecZIpbr0ZJnZgsW1MZ22Fz2Pp/9MBHh+hYzn/aUmddlSmTi3vZuJmnRoGMCytluieUSO1O/eA5ofeZlBsEf71+wwIJLQ2qqI6Ch9fOowX01ni+K36hobJFmlbkfVnuwEa1vv1BQSyuZf+sCJxbEnOoQWu7xpIjMnjcQQToR3GFocTfmAxq3tcJu+x/qiHPkvXjpwkXql/g1H4HMXrMP5ve6siyL+vKx2oPFCs1caeY4xKTSGqARe7RLo+LrGvtUyVJEJcbEd1sLOcP/POpM9oV5lxydiGq+Uo6VBXLCLL1yr4DPi7P53ny/mdsL5focTZ9F74w+ceejXbkWmDNob1Sbn8+EqE2QXgbp7bOgQLBiEKOiwvHNiwTytM+yAdXW2U4M0XpiZ8XZcLg/BF0AHUNN+XceTzupEbYG5zZtt6Uq0LjlfSd3ELx+HIRKk6QmmVa86vL2CWaXXbBbcir2/VR9KT/gQAookp2vaNihYBoGqrQrd0Ez/+6cSC5sf2F3RhZauGcMnSFzEVupD37p5Ea9zNWQ4NnGN8G+Bwm+mrNtt49mAFJMpQkNP42Ex52RnjQD0mgALm1EVclBap9rMAjv5L3lopGj6u/vJFlUFx9AzVENLZNZ7xWGd4uhTwG1COcbTtpjCvKKf0y6Erwqb99GOZl1UruRVnFzzIqlFOvD51cRiVmtZ4n90N/8cNLnsf/VSiddtRQ8+lKmwiBy3I2v5w3B9SALgCDeaCT9C0AL1X7mtoOZ/Z5BdLPDdyKeOGXeL1tol7JqTUmV2mr55YMmv33du+8UlI+fNDHCK1qVMovfZBY2wPCqFdOsPofhM2XeBDenamQ13pT81crQRheRjwBvg40jncETWMpZPo2Y9ZK0IEP55cH8Dt9/Qs+yH8gPpPQBsaIcbd9
 NsZBwtbx
 EYygslNId93xtox13KaJBFZt1jdX80fDJXwZj3BzQWEdxPLJrMaS8OGZRg5Ll2KKqcBPGgD8js+mGOyCSxlNY+X+h8sGWQcVbo2Sq152bWcw1Mho3QQb4UAZepgB0IkKofgM1rHkdIvHG30+zznofM/aWpuCRxV4DpbBEShDu0O8Mtmxzx4kNh79xmyYw1lCiMTwKhFx9IB3Shb4tXVKj1q4pOjUCqZgdNd525ZIak9+FvXFwt0w+PvpiNYJqf/mjOKjGtqkFGeD9VZ/n9zJiDsBkw+qJbC1GRwh8mhM7lzUvERFtfXrwlLzniseYdLz2LG4TloIoSpiVjqGI6burYHn1Yv/C2TevBj6MS+o2aiqygabkoObYgxQy8M1ggbmtt9q/9TJUvXHKqkwpWddQ/Seg5oAzqfJN3P5ApPU/RshfwinUfQVEoQTirVyn09nc2+J8rqNKsSGe8MpnLvp9mcUnFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 17 November 2026 05:59:56 GMT, Muhammad Haris Awan
<m.harisawan@icloud.com> wrote:
>KCSAN reported a data race between dup_mm() copying oldmm via
>memcpy(mm, oldmm, sizeof(*mm)) and lru_gen_del_mm() modifying
>oldmm->lru_gen.list when an adjacent mm_struct on the shared
>mm_list->fifo is removed under mm_list->lock.
>
>oldmm->lru_gen and oldmm->mmlist are protected by mm_list->lock /
>mmlist_lock (or updated locklessly via lru_gen_use_mm()), not
>oldmm->mmap_lock. Because struct mm_struct uses __randomize_layout and
>mm_init() immediately reinitializes these fields on the new mm, wrap
>the memcpy() in data_race(), matching dup_vma() in mm/vma_init.c.
>
>Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
>Reported-by: syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com
>Closes: https://syzkaller.appspot.com/bug?extid=c6e1b1b32ff2fc3b7d60
>Signed-off-by: Muhammad Haris Awan <m.harisawan@icloud.com>
>---
> kernel/fork.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
>diff --git a/kernel/fork.c b/kernel/fork.c
>index 5efceb8d5..14ac9a070 100644
>--- a/kernel/fork.c
>+++ b/kernel/fork.c
>@@ -1539,7 +1539,12 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
> 		goto fail_uprobe;
> 	}
> 
>-	memcpy(mm, oldmm, sizeof(*mm));
>+	/*
>+	 * oldmm->lru_gen and oldmm->mmlist may be modified concurrently under
>+	 * mm_list->lock / mmlist_lock or locklessly via lru_gen_use_mm(),
>+	 * and mm_init() will immediately reinitialize them.
>+	 */
>+	data_race(memcpy(mm, oldmm, sizeof(*mm)));

NAK. Your basically just ignoring the race, in fork, like Lorenzo said.

Let's fix this somewhere else?

> 
> 	if (!mm_init(mm, tsk)) {
> 		mmap_write_unlock(oldmm);
>

--- Thanks!

