Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B09606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t6kwXPKf
Received: by kanga.kvack.org (Postfix)
	id 2DB576B00EF; Wed, 11 Nov 2026 09:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C1F6B05B1; Wed, 11 Nov 2026 09:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B306B05B2; Wed, 11 Nov 2026 09:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7A0D6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:23:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 776F51402DD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:23:45 +0000 (UTC)
X-FDA: 85423056810.05.75F20A0
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id B06A6A0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:23:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t6kwXPKf;
	spf=pass (imf15.hostedemail.com: domain of zirajs7@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=zirajs7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794407023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Sp4dKr742azZCnJ8RuBlUtN4JNyRRBPpgnCwCd6hxvQ=;
	b=0iAgFqWYWZjtfmanAulcoe4YXG+f5mi78D3wWYlW6TyH/zY70i+Nhpy+lEerclRN+1ZXCN
	RGPgFmCjtvV8fpELtbjZAVKIAWh+2mVObCdhiDvvq1Dlule9jcRPbFmWJLYEtlL6GCzQvm
	TwW1HK9jdFlfmu/3N+P4rqpQgFRGcB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794407023;
	b=EInrR2MWojdnhVmO+ODl1/g98WAJao49As6eO94IhKQf5DOz1uV8goADtzTzvMMhkXo54Z
	wwbjRW4YD14RKKzPfI54PhgD3waY3RSG5q01vIhSa66ih46BNGXHCLIdlXQnrwl+dOUmtp
	pH561V9w2z8w6cw9PSkIM5BCw74JpfU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t6kwXPKf;
	spf=pass (imf15.hostedemail.com: domain of zirajs7@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=zirajs7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so1952323a91.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794407022; x=1795011822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sp4dKr742azZCnJ8RuBlUtN4JNyRRBPpgnCwCd6hxvQ=;
        b=t6kwXPKfpKWVSUOcJHR3Mc0i3V4z6J4z4ksHVznoe4aYZylUtgw0j+53D0487gotTm
         2D1TQlBTmOFIjSBjLIyrh7qmNAxFFY8VS2G8v8NilCb1sLXx0/PKhpQIIhQMsi1UoBEm
         Y/ZXZdhH8kFVPFXW27mikBs3+sdZIZrRCMRpFEua1p0GmquKal13AvwQONl/cmryM3YB
         Ek0WqoUGXmcO6L2v3jwlFrVc2madympkl+rpeBtETWaJzGV0EpBil7VnAYZ0Uwb8F4h8
         vNF9eyaC0uUWbgYW2ExMZ6eyNMrRsJIX8xep22wPjCjQwSUssoWhclnMEcdF9reRsNDy
         zxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794407022; x=1795011822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sp4dKr742azZCnJ8RuBlUtN4JNyRRBPpgnCwCd6hxvQ=;
        b=A1nbRlqoHlE8A8Km0I53cz+1wepItJYrbwd6LLXDYmAC3PJPw34SD9BbeNUMxaEmR8
         6eEs+iT38OR/SXqK6oguFgtR2sURcPXvQdHWwT3wOKSgwW08W4f5nELwRZ3Kuil7dolX
         ONIUvwE0pd91Fnno8TcDDnz8SxdNliD4s/D5OlrKjyI5imB8vG4g5In1QmXa59do0qal
         0VhOmn7f97UA+gCoXLyZYRacGBPee1E031l9y9nC7O955Ohj1Jp5B9hKC6dYyB1CVWrU
         fEDdGS5SgWy4ixsjP/SxzkaGWsTpjxVMAG+fUctTE677+YpC2eUlIF1u72lRlSaok9zb
         qtJQ==
X-Forwarded-Encrypted: i=1; AL+hErEestFTIwyMa36UQpLgjejQcbupnv3pDbxcetcW+3fR401QeCRJkAlD94pZO68QtzPlshGzl/kgIQ==@kvack.org
X-Gm-Message-State: APuU4Z/KYJDphlQgUg8P5131TfYqEf5ESWR42AsIleNAD4arn/bkoCpG
	6ieWgqd3lLyopD/wK/lTWRBdSBVxVvuhhzSRbZAz8kwQTF0zwiQ9NZgC
X-Gm-Gg: AYBFou3DRxEssK3+JRnJeGs9lniykRplEs1Cel0yvFrjhLllZZ2W3n8vUw/cs2RZ+kh
	zhDTxpg75n1mu9hJgCHVXxg6hegsJL7eBZRoB+FAvHBeCybd5Rc8TMtaS1jskxkpNdCQUWdcJRJ
	sEQ/Iqq66x0/hpiLbDAF3mtlc43+QQrBXtCCPxXFmw5RLRDuyjqpqTdjug3Une/ZpI2UP5ug8gM
	bgBa/Pf+4IEkiqFRS1NgGUAqyr0BFjM9UC59NxU9SyDzgDD8Xd6JhKoo3EgXD4npHXw9HeLcAma
	CiNU2mbLxz58LMCTjPY0hdR2Cc6r4bXz+hjIrMRu9FKnCiNnfWCPKwDp3kLytXDH+Inm+qyfPz2
	kJrlRagnJ3ptbQmVlLXVu5sC/wvyPJvFqdAEcfUl2x97ZOUtosxB6EoyPJYREIdf5HwqDWLC80O
	QE3VozoQh1w6F5hP9ocm0HAgEe5kOb1+IdEd+jWisrMvfK67l+ZVZ6ye1OIUjbc+XWFpg0ikXse
	D+ZnRqeCdzxxJYZPpfyhRMBfJzl5Ca+0+dozE3ACq9nHQfG3gHekojdGy4BCvnTLk2wbfxl0D32
	UwT5Ioy+we4OQKrZTGL2OBA=
X-Received: by 2002:a17:90b:1c02:b0:3a8:13d6:f740 with SMTP id 98e67ed59e1d1-3b182eabbd9mr2705481a91.22.1794407022263;
        Wed, 11 Nov 2026 06:23:42 -0800 (PST)
Received: from omen-arch ([147.46.174.207])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db5cc73sm4768976a91.10.2026.11.11.06.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:23:41 -0800 (PST)
From: Junseo Lim <zirajs7@gmail.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: hao.li@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm/slub: barn sheaf counts can exceed their limit
Date: Wed, 11 Nov 2026 23:23:37 +0900
Message-ID: <20261111142337.748120-1-zirajs7@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 46pskn989ceik1n7gf3wg888ss6p3n9u
X-Rspamd-Queue-Id: B06A6A0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794407023-478701
X-HE-Meta: U2FsdGVkX1+aztMneHnLstHVuBkEa9IO8BQQ9+Jna8TysOExwm41SgT38hQ1loyVsdNV18dJc5L1vPJ2g0Pl6cF1DpeLxeDMfffk/9z02beYhqTjAgQNSOctofOZN63Gascn18ffsM1LvHR0r6P0zgWsWrjKYqfGhvyayZJ9dk+UijENmjlC+gIm/tJ/MsBx2qEX+YvCAkRdhZHWq5mCciHmucln0T5Q3Fhj5SEO3yQ6jqFxu9tpgvj28l1nwNdjKlk3FG6SMWXw4+eMwFWuEh78P1IjivSpjN+3JHKaPFAhLXRZwJK3KSsW6g1mLuaN4EnnjWhlGEwEgVvHyIiwhAOo4Xqmq6oEr25AguU/KlUMGj8vgsJdBHhVs+s0bIfZDdpoyGv6ocFe2sQ6nnM/I7kusSNZ4/a1kXpTaGKUoV6HA7cJvhwo/m3nuutCM8mpzAxE+fTZmgg17H38NbWd7BSjQ+g1lncDfAjVaXDaWrWRou7/ZDAp4jtWxxJjGBaiKndfP37OtlxhULHp8Gv/MYcfqt6O3qtacGRg5IxhpgIO+xRTorX1TDb3cX5Jw4/W0Lnzq0NmTtdBlsB4gxv2WARAJYUMstGkPwP7JLTaqNKY/ZU7EuPWaP7pggAU4QwNPMQhjFj2Q8x5hXX7HcAwNoLtHoaIaFdF/yKa5M+YTgGPQybNYUyrDo6fxIZlY9y3vqdx4YscajezhWTRS5CGOH5nzU0tWoi/XwPKmseJGjMTrbqJtbOScjMxiSuO5NJUHqRTOz5T4VWP9H/eWhdqvnorNr1ffZ0VyNexxyIC+Tn2TMXOgIr+5EWihBLZ83KxBa6U0r5EjRldM8n9heEJ5zu3nkNNPYmhiKXXl6q4E97LA6djVIFL8A/6prfcngV0Suneg87W1OqLQk9ieZZP/SzcPBJLHYJ5fzX0wVGMtbvlk+wfQslUbjGBwpjwBNvv25bOJzqcnjjFT3eVzaQ
 nAcEj757
 NEmz8ieAcF8yqf1wtE0LZNiYwKQ3AF1RsjepWWuLaRHx8iE5QorjhRpawSY1XpvN0MoZAjth3jhTAXir4QZgosrBvteTFYMqoTKgJXAeoNibCbJhnXH4REBkwhu39RCp3v4C6zxPa+m+N6l1NCWYrDWnQU2o2YhUohC/U7e+Z9ZKqZchY/aFJupCJaeXBdtJ1A767KmGZVwdXqDd0izX0dh96pQwtFBBXLIc7rzImZxNcetoMBWUcGvOTXWwKIVBLKyx8swhfwNcf5iqHu9qcRlk8W7UkzegAgnJn6R3Zrn+jVlLJmZ11dEp+fI7t+v7i6igL4B61/pdxf/1ts0xHIwgP6LPo5yIMWEF4I4RgLrz4r3mz+oe9tmixAI6gpDv1eeil
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

Following the suggestion to discuss this publicly, I would like to
report a repeatable overshoot of the SLUB barn limits. Although
MAX_FULL_SHEAVES and MAX_EMPTY_SHEAVES are both 10, a userspace workload
can repeatedly trigger the refill recovery path. In one run, I observed
states like nr_full=91.

I would appreciate feedback on the appropriate way to enforce these
limits.

Description
-----------

While the sheaf layer provides a simple array structure for
amortization, the edge cases that involve refills and allocating
structures are inherently complex when combined with multiple threads.
One problematic case occurs in the allocation path. Consider a state
where every object is drained and TH1 on CPU1 is running:

  CPU1
  =======================================================================
  TH1                    TH2                    TH3
  ---------------------  ---------------------  --------------------- ...
  pcs->main->size=0      not entered            not entered
  pcs->spare->size=0
  nr_full=0 nr_empty=10

    <observed states>      <observed states>      <observed states>

If an allocation request hits this state, __pcs_replace_empty_main is
called to retrieve a full sheaf and swap it with main. However, no full
sheaf is available in the barn, so TH1 removes pcs->spare, sets it to
NULL, and refills the removed sheaf through the slow path. Here, the
per-CPU sheaf lock is released during refill and reacquired afterward.
If preemption occurs during this period, a subsequent thread (TH2) sees
pcs->spare=NULL and tries to get a remaining sheaf from the barn's empty
list and refill it. Likewise, this part is not protected by the lock.
Chaining this results in a state where new threads keep draining the
sheaf and ultimately consume all the empty sheaves in the barn and start
to allocate new sheaves.

  CPU1
  =======================================================================
  TH1 (preempted)        TH2 (preempted)        TH3
  ---------------------  ---------------------  --------------------- ...
  pcs->main->size=0      pcs->main->size=0      pcs->main->size=0
  pcs->spare->size=0     pcs->spare=NULL        pcs->spare=NULL
  nr_full=0 nr_empty=10  nr_full=0 nr_empty=10  nr_full=0 nr_empty=9

    <observed states>      <observed states>      <observed states>

The construction of the sheaf layer allows such racy scenarios, as
mentioned in the comments. Nevertheless, this overshoot is much larger
than what we would expect, and the fact that this state can be recreated
with moderate effort implies that a fix would be appropriate.

Impact
------

This itself does not pose a direct threat or system failure. But, in a
security sense, this behavior can be leveraged for heap grooming that
targets the underlying slab_sheaf.

Design considerations and Question
----------------------------------

One way to limit barn overshoot is to constrain the racy allocations.
Simply using the current nr_full and nr_empty values does not help in
detecting excessive allocation. What I came up with is adding an
nr_alloc counter that keeps track of allocations during the unlocked
path. From what I've tested, this restricted the targeted workload that
induces the excessive allocation. Before this patch, nr_full reached 60
to 90. After the patch, it remained at 22 under the adversarial
workload.

I haven't checked every possible interleaving yet, but I would like to
know whether you think this is the right direction. The possible
regressions are that it requires an additional field just to track the
adversarial input and that, in a highly contended scenario, every
allocation after hitting the nr_alloc limit will go to the slow path
until the preempted task returns and continues the allocation.

Is tracking in-flight sheaf allocations per barn, and falling back when
too many are in progress, the right way to limit this refill race?

Note: This is only an implementation on the allocation side and is still
a prototype.

---
 mm/slub.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..472fcae4ac91 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -456,6 +456,7 @@ struct node_barn {
 	struct slab_sheaf *sheaf_partial;
 	unsigned int nr_full;
 	unsigned int nr_empty;
+	unsigned int nr_alloc;
 };
 
 struct slab_sheaf {
@@ -3333,6 +3334,7 @@ static void barn_init(struct node_barn *barn)
 	barn->sheaf_partial = NULL;
 	barn->nr_full = 0;
 	barn->nr_empty = 0;
+	barn->nr_alloc = 0;
 }
 
 static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
@@ -4754,7 +4756,9 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
+	unsigned long flags;
 	bool allow_spin;
+	bool alloc_new = false;
 
 	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4796,6 +4800,19 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		}
 	}
 
+	if (allow_spin && !empty) {
+		/* The limit is advisory; concurrent reservations may exceed it. */
+		if (data_race(barn->nr_alloc) > MAX_EMPTY_SHEAVES) {
+			local_unlock(&s->cpu_sheaves->lock);
+			return NULL;
+		}
+
+		spin_lock_irqsave(&barn->lock, flags);
+		barn->nr_alloc++;
+		spin_unlock_irqrestore(&barn->lock, flags);
+		alloc_new = true;
+	}
+
 	local_unlock(&s->cpu_sheaves->lock);
 	pcs = NULL;
 
@@ -4805,7 +4822,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!empty) {
 		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
 		if (!empty)
-			return NULL;
+			goto out;
 	}
 
 	if (refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
@@ -4816,7 +4833,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		sheaf_flush_unused(s, empty);
 		free_empty_sheaf(s, empty);
 
-		return NULL;
+		goto out;
 	}
 
 	full = empty;
@@ -4839,24 +4856,31 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		else
 			barn_put_empty_sheaf(barn, pcs->main);
 		pcs->main = full;
-		return pcs;
+		goto out;
 	}
 
 	if (!pcs->spare) {
 		pcs->spare = full;
-		return pcs;
+		goto out;
 	}
 
 	if (pcs->spare->size == 0) {
 		barn_put_empty_sheaf(barn, pcs->spare);
 		pcs->spare = full;
-		return pcs;
+		goto out;
 	}
 
 barn_put:
 	barn_put_full_sheaf(barn, full);
 	stat(s, BARN_PUT);
 
+out:
+	if (alloc_new) {
+		spin_lock_irqsave(&barn->lock, flags);
+		barn->nr_alloc--;
+		spin_unlock_irqrestore(&barn->lock, flags);
+	}
+
 	return pcs;
 }
 
-- 
2.56.0


