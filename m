Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A19CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742BA6B00A0; Mon, 28 Sep 2026 13:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC506B00A1; Mon, 28 Sep 2026 13:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D216B00A2; Mon, 28 Sep 2026 13:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32E2D6B00A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEE491A029C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:52 +0000 (UTC)
X-FDA: 85263888864.10.429F01D
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0BE9CC0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TmHN++5O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 33aa6aggKCHIiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=33aa6aggKCHIiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQQXCFUTzEuKqqGshgMGPB+3UWOKCHMCwqurMu3nBP4=;
	b=r8lwlSErDeQ0AXkK84x2q8pYqDl/FEfIc8gzU/gmyFMt0sl/8R+w8M1pi2AnNZCZUWKz2o
	nb3ZdchJT3QV8y9U8OqTLrQiZsWGclOi5v/LID9XLvyZpr0PC8wkNblrkYEujK0JnWNASh
	glwKAW9xonRI7XAtN5H0K9feNQWLSZo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TmHN++5O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 33aa6aggKCHIiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=33aa6aggKCHIiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617311;
	b=zF+577Ki+s4YPDTZZtTM3n20wxFmNwY9exAS4NyOhky9DG8Zn3Mq4N3ios+TsGWV15OKwB
	fYj9062z5AM/UUj6WI0HJ0+qEMIzmA9LSm2vJruFtmSXCJ01WzwNK+AiLJd7kYyEzcLfeP
	UeHsocLunhOSjCTvJvdBNNad4qveF90=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a9caf60126so3581969a12.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617310; x=1791222110; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tQQXCFUTzEuKqqGshgMGPB+3UWOKCHMCwqurMu3nBP4=;
        b=TmHN++5O8K6g9fz8MToCZvUdfAZSrs0yOAgiwOLzyoaxvs9kyp/ihl3mOfWcLbRlM4
         pTH/xT4DKwa4u3php6i7+2Z+aFIFR3UQ3085mGdySlsiBMrzH1omGnZkbiBTEjkHA0Fo
         tavAN4FD8ibJ0XFOOqN9PotNHJydlgJirAC6VgNTBxNb4Xd0O5Haw8w4xhD8kgOof2yR
         ogHUthZvR9FTyqKG7Rq71siMfRRzGhaPKSUz46U6u+kRgb1IQYJCkMNbgoSj90yziYu2
         r+l2h+Fc+HzsYlCwzIVBiavlI5S34Aptp5in+YdFMd1rwDWZlF6sZyzUf55Pc6tRFnUm
         eH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617310; x=1791222110;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tQQXCFUTzEuKqqGshgMGPB+3UWOKCHMCwqurMu3nBP4=;
        b=L+T4vMdi3jDiK+73JCCyCxMCllH3CoGYPlJMnKNLLpmQiX3/XUhPmXkcWOdHvEZvjI
         6/lbNtXHAeE23jmUl0wq09UoU9yRamfX7MHW7uxTO9XKvxbK4Sz4Shcr3Pv2J1RoEt/Y
         LWglSlMu5gO2x6ky4P5Vf7jsO6blpzgp4Oa77BV5Ma/YBr41Rrhwe14NoAU/5p1QbwEq
         D+0F+nXndg9pyfANbZ7/Uym7McOl3l32pwJyLPGh/h/JaBWewCFrxLX2McFV+eH7kH9N
         9S+9IafI7hHVZ9LvClhgH3MZD39BtEKIgRAHQ+S9RpEb+eHYD42D0dJ82wLEczxrIwSc
         Bvpw==
X-Forwarded-Encrypted: i=1; AKwUvBykczL4WJqnsxJyj2R3HpratHT4wX4GE7yHheWThDCbWKfsEMREy/q9bKH6MLju9diAaYm9ecpRew==@kvack.org
X-Gm-Message-State: AFq9FYKSFhsmRk9EyIRXJvGvlhjIqKN2w3/GHFvniPCtZyKZESju2DI/
	DL0AeYUGevs5ZdrUDZvZygOlk4y3d2/QSR1iaM3C7+ZTzqXdbSjHOCtY0sG/JWQNaeAjlNPzNci
	vaGzYS4xRS7OfXA==
X-Received: from edfz6.prod.google.com ([2002:a05:6402:a406:b0:6aa:1383:f342])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:538b:b0:6aa:fc60:60d0 with SMTP id 4fb4d7f45d1cf-6aafc606c77mr6303087a12.33.1790617309305;
 Mon, 28 Sep 2026 10:41:49 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:09 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-3-smostafa@google.com>
Subject: [RFC PATCH 02/15] fork: Don't assume fully populated stack during reuse
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	David Stevens <stevensd@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0BE9CC0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8cde8sjyfk31e863uwgy3g9npanqp8sk
X-HE-Tag: 1790617310-583921
X-HE-Meta: U2FsdGVkX1+V1G/tr06wzAGlfQY3ZXmD4M22NCBWAivm79vyxcw4UTYfEEmtoR1vcWXvPb+YKaJSmUW/iOnvi4Lw6hEso7Bm4aYrhNPACb+SZyHSHlL+UsUBTehTGON/waK6gudNTiZCcCM3+/o3DO5ApAk0XQd3keobnJRr0f0HGnsZLoEIW6XshTiKOhqAuye1fChic3yrJ7NrvPoHlcnGRjSvKg32WGgnD8hsWtcUPYrpFoeGiH3lLON/tYu29svqHR4dfF1R7g7fdCMLOm+ry9aJjIlGzx9EbQfHbgydIgXRpK6yPwPTtm0ro2YgAIBiMwVeB42iKrvunBead0RP828jxk86eXHbJKzHWwobTbs4lEYRBs5L4n5BLRhD14Js+adjQ/vVghM81P8HglD20ToX0MmbGSUqKmohherjUg2wbxaq+QqaG9yJoVYS6l1J7wIfhW4nsu/2xiiXXg5n22AtxSo+vltLL79JY98lIusBPmIbV0mCVA81Y7jBVI8t9ZsGOkXrdw3NieS0uC36iRJkXAoodioqE+zCGoL9r8mC0F2/EJm8JSb43qDVJM5eHo0L+4wrPjv7D4669cjMkSArinFv44n/VqcIumvnUaakX+5hlbHHZP0AI1uADLn0wa6J+paODJTFKSHmlhfWE9e7vumC/4catXcaQNtNcDi1plzxexcqNyCY74TV5c8qCivHW9SMz8itv3mdav3HYELXsPSpH1YnpPS8DxEMFrpP5hewfjWwAdlRob++7iPuvZPrGYATqcmiLyMmhHz+tz9aHtDqWQDypnq4wlpfB2IWfhG7Dlo3+HzW5s+11Bgj6yezQ2YZdVvmp2fNCUVxaoXrA3NGZ73CRJ48WEDgoOEyeL393/Nxa2U0YzErEdrMQN0FqIPwUsVFVVS3/U54qjQRGqrPYz433T5QWeAdHm9Yo39cOOZMmsGZV7H8Ouw30IE3q8B1PVNHc/5
 m94mH3vZ
 cUxQYsliL5V3UOLZ7+coAPh29p20Uov7ZJnRgeiwhUR1mzVxTgB3R6IhsPdnJs+bAk2y3JJf/NeDkJoBXkoTlgZzDBIh9vS8l0u6rCQbNTzFbqai6zPoloqNP55THSb4swhcFRSs9O75cDmY6x+Ip2D9zltK/r8bz/1ly46C7Oak1sETOSxYLCNZY7dLBgiJDpdxqzfSFXAkVieeJzuYs9SnrDJq7bkSJfv350GJMPMF/rn8Rn6SNp+RiJu+Xed8uw/2fs9Vkf0NljAqmWsLqKEU2NiAAA8baQISKgV1fkIjzJ/Ern2uBESCRTSmsmZ/u739FGiWbNCUAYi9UXkR90SINhn7iSd9Oq+KpSvl1VUG4PmHFMUO4cW2r1jrN7MnkowXQP5sh5oCjNHnxAQNKPVjwnHu8nZd6BU33I9FpEMwX2nSvKCq5sKYBjtGJvzb7G0drxIfzv7ElwnSQ1BaH83R1QFii5O5d8b5QVtAJi8Fvf5PfURS37+ndjjPyoamnNJHBEXhcR9OBIb8VsTz/grjQeIciD08t8KlCFIsh1VyGW+bpWBwsIISej3p+ip3Mnu7DmHJ5kT4q3wqFy09SQEHsmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Stevens <stevensd@google.com>

In preparation for partially populated kernel stacks, don't assume
that vm_area->nr_pages matches THREAD_SIZE when clearing a stack
for reuse.
Note that the VA range is still THREAD_SIZE in that case but it
might not be fully allocated.

Signed-off-by: David Stevens <stevensd@google.com>
[Resolve conflict and updated commit msg]
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 kernel/fork.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 2065693e762c..ec4431bf309a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -335,11 +335,16 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 
 	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
 	if (vm_area) {
+		unsigned long offset = 0;
+
 		if (memcg_charge_kernel_stack(vm_area)) {
 			vfree(vm_area->addr);
 			return -ENOMEM;
 		}
 
+		if (!IS_ENABLED(CONFIG_STACK_GROWSUP))
+			offset = THREAD_SIZE - vm_area->nr_pages * PAGE_SIZE;
+
 		/* Reset stack metadata. */
 		if (!kasan_hw_tags_enabled())
 			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
@@ -347,7 +352,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		stack = kasan_reset_tag(vm_area->addr);
 
 		/* Clear stale pointers from reused stack. */
-		clear_pages(vm_area->addr, vm_area->nr_pages);
+		clear_pages(vm_area->addr + offset, vm_area->nr_pages);
 
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


