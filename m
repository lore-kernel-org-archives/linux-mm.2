Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49737606A334
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NNoVry5E
Received: by kanga.kvack.org (Postfix)
	id 11C8E6B05B2; Wed, 28 Oct 2026 15:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD716B05B3; Wed, 28 Oct 2026 15:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67906B05B5; Wed, 28 Oct 2026 15:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD4B6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:40:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9E511A02A5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:40:19 +0000 (UTC)
X-FDA: 85373051358.11.5EF6544
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf24.hostedemail.com (Postfix) with ESMTP id 362C4180009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:40:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NNoVry5E;
	spf=pass (imf24.hostedemail.com: domain of 3oE_iagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3oE_iagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793216418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xBdNJHzSelAN6h3xYRSVm8HO5fDJ981Dsf9qFwSDvFI=;
	b=g3mPpYE/T1PCsaoiiyg8QH+F6dHm8KoO0Fwm5V0E9xs1EuHXS/aNwdaqkw7sm9Sn/x3OLi
	wlpw/ixCSvmFwnWU1wZTCdQqT41SZNKq3OcY58utx2I4iHd3Nkm5rxmTeqYj75eRN9hZEs
	mR87jC1fe2K+imX7qk5Cb5qj6+b1NIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793216418;
	b=RDvuBPoKvQ+1XZhigD87gvhQbKSe7moPqoG4VI6BhLTeI4w9xuDYXloWjWKFT4SpSGYomV
	RkCtGJTW1NJ15kPPYQft69SmwERTXLPadGz6kSiHdr4l2cbbUhxRyWirHZzUGmf/bGBalk
	MR4c4VocqmPMjESg9zoOig0Uz2P3khI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NNoVry5E;
	spf=pass (imf24.hostedemail.com: domain of 3oE_iagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3oE_iagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-89f9fdbabe1so1804028b3a.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793216417; x=1793821217; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xBdNJHzSelAN6h3xYRSVm8HO5fDJ981Dsf9qFwSDvFI=;
        b=NNoVry5EkaYkaAkvpe+S2cSnRnl9ZGoKDmHWYJ+c5BXBrp9TBsIUnBW2Rc/mbYB3rB
         siibMdk5eW5pH96NCMocMjaztZKRdjjFCuqDfqqq5hSAUxW51cUv/ThGokk2sZ0ksjrV
         qph6rw9zgNUblzDgj6huIj89tIPJ6Zt1/h/OF9d3+/yI7q4Tc7NDjYeW5U8Gsytzmu2U
         rUA1cEbNMxsdfMbCAMgVMKPal8cqHfVyuEhZ0upMfbSd2k+t/RZXBLLON6FL4fri1MJ3
         /uxQdTOWP477BoL5LV795WzFVOH5wCBY4nukteN5Y/HCYT0qHwftXYWfC26zZYwLrhmH
         sHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793216417; x=1793821217;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xBdNJHzSelAN6h3xYRSVm8HO5fDJ981Dsf9qFwSDvFI=;
        b=KTBBrKB3Zvxd5zmOLDJB+y1ucDCi1mSNb6/9Cu/61rd8Zvb+cn9PS1+pnoJ4yfbiBf
         2ecUy/t5ypNkG6hO7uLS+up8uDnduwP/uCW8N81Q6myOhq3VpF+kAaa9edOymghE/L/S
         djLpDft1IcVcpEjFL3hlnUkA5kC7pSJnBbwEs7YUVEh5BGOtpJXQjnWSUbx4989wAd2Q
         PHhPC06U5jcc3/AcYn6CX8euI2YclMk42TlBPuzceZOz3By4agqE0H/3oG5+feaUGkza
         kVukrDL+gHBS+u9ArktEuuBoqQ9r70pVI/NkhGJ/1GtuMjt6X08MjnHn+Y+RWKXYgmJk
         hpjg==
X-Forwarded-Encrypted: i=1; AKwUvBwUqdQTu0V/yqovLgTSZa1HjXJG73ZKE4p/ioCtVVhR+dt48d5DRiMWbpNFrkcrdRTFrBzS3I9DAw==@kvack.org
X-Gm-Message-State: AFq9FYIAhLEdEWt9pZnGHFwfhnHRGh4OFQOC9tvTGDo3a3uDUAi2BxKG
	cQ/6R4/7MEj6cX++Go1Gq+X6s5qt9UIFA7gcUzccUqPhuEP3M8Nx1dFtGAWvVoZGs3ZSb75+StY
	c8QfEKA==
X-Received: from pfem10-n1.prod.google.com ([2002:a05:6a00:c08a:10b0:886:368d:9900])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a11:b0:8a0:7ba9:939c
 with SMTP id d2e1a72fcca58-8a6e6fef2f1mr2699695b3a.11.1793216416474; Wed, 28
 Oct 2026 12:40:16 -0700 (PDT)
Date: Wed, 28 Oct 2026 19:39:18 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028194014.3671161-1-kuniyu@google.com>
Subject: [PATCH v3 0/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 362C4180009
X-Stat-Signature: 9ds84nzj3rxtzrw6r6q1me1qsaeb36xs
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793216418-845466
X-HE-Meta: U2FsdGVkX1/QBPbTJokwoktZJ3dEzTFFtZk/XsVsQ212thpxHIKb7BxRzVZCtb+VFyaeMYzYEPTXCGTqNsE85zujdw8i3bFRhlnKSE8ZfGuAFyM3kuvUvpm8+nqP/3y0AhceRGA8GRYj11U5ozoUpqIRA9sC83gp3tJ77JE+EHQKR5dwlOI6/Wjt8OfHsr8tvbRJRi/Xw8uvMH6fzAcrFqFL4AqJWljWALKcFg2ebpq+J7DnBbfKPNdCigmJ/rhvSmw43q4PpXSyyM3k6wDzz3uebI81hIPj6m2BZ0ZsIA99p5sIXWXEoZj7DwFwWaEdTvR6gQGDtp3wuD76yXv47tfktvchjOkNi0LUcor03WVkfV85ao/ZtmzfLbwU75ZS53a1KxA3W2zPjwEHWDSKAlLBUC4qDyw7QB4qlKw/lZM68a23Ykhn97W1YWy+WVjulIJtvO6CM7HR6EwFM8EZB9DAoJWOjmpebS5uatPbRbqNH4d7B2yo2zi+KxLOuDwplFEtSTBB8bZRJm0+Oz303/sGiQxMVF3sK4fKqWBZ3xgmtblS88LyuBqOgwerQgqUMSd/Gdtwix1cz/6ARAAzdVGgpbN//+29MCgcT2eHYY5GL0Tsx9FMVy5xmDmR9VPf57BUTY884KrY78sNSJBAsRBXSNWOzDGrD19ezA094oCzRdNaVxXpvuI5FHLYXcHHT8TpFGvqZgtgYqC2I8ExHgtaEdFbPfZY72zo410wauNoNTS1kunSrkjjTNjAFyx7dCZVxfYyzSLdW2tGQIMMwEVm91Kb2yWZIgvCRRdK2kpr6zD6ZdbJIpzMSH0VUEDDwenHfPexkIKBsx3ksj2RXjdEKda80y0f9I5kUenHU7cwbFozfV4VExoUUkkwOK3YchyNKrS3TiYCYL6NPJebI2Koocjqk7AeLwklDm6ooMvoWZcUzB+0LTflBjjzd2X3Aq+6pcCdiqRYwN57V3A
 jtqRC2nB
 Sa0w0R84vc01zMGSPSYhqE6eXWsw9TdIE3DBX+pqwj95Je1l4Dwm1kTID+glEaoravZjztG4171j8qyOIg2mbPIdgC3FOjkNiS7wNWHveO2c6DDTmmUR3Kr2V4wnDjzpWa4ryl5j2I+54KBkMaC9i+4lzIzh3anW+ShZMDOIvfdUOus0oWPnfENVCXIWkiMS8HdMSmkcD0P7Yrcu9VIlUN+ZnwF3fD2hjCVTF9JvT2B52tRMUwxk8TtnTHk2lZ1AvT83dRfJ0u+hA39mFcd3W5NYuDxLBVfzf/mxGKLscBmqOi+X1lmnnQ5IB5pPZP3dF2/66col3ptmjbHsaurPRQLeYOGV8VmIMutC9R+Ap2gCqY3jDstCyKtEomleYXQcxfi73mnAJlZHDE9DbdQSOH0hsFqMOgPIEMYgcSs3ULHsgH+5Ncd1/upcTAk/FHW+7I/yzzrkCKGvlRyzx9A9B/8BonKsFVGJQG9tTMXgPj/2l3D1vjnvpZyhtwrQ6sk5KOeSFnSVdr6wf8smT9sJchn3/cWoru5+duS8R6P8p0cmG8cHm8JeJeVf40UlOkfnkqPHu8KiA1tHNTHe4ZfPfe7uigUguK5lbLRRfFr+jIDgF7IhPppsB2rw9yKiTOy7zTVrpjAGS2k2AWDFWE8ivOg70aypPdFahYJ900Zg46JuBrv6LTghHK/dABQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Recently, syzbot has reported several weird use-after-free splats.

What they have in common is that "Freed by" points to rcu_free_sheaf(),
whereas the object shown in "Call Trace:" and "Allocated by" is never
supposed to be freed via kfree_rcu().

This means the object was a victim of a double-free somewhere else and
was silently poisoned by rcu_free_sheaf() after being reallocated.

This happens because kfree_rcu_sheaf() queues an object into the RCU
sheaf without invoking any KASAN hooks.

This series enables KASAN to detect double-free involving
kfree_rcu_sheaf() immediately and adds KUnit tests for it.


Changes:
  v3:
    * Collect Alexander and Andrey tags
    * Patch 2
      * Move migrate_disable() before p = kmem_cache_alloc()
      * add KASAN_TEST_NEEDS_CONFIG_OFF() for PREEMPT_RT

  v2: https://lore.kernel.org/linux-mm/20261027222557.1072105-1-kuniyu@google.com/
    * Patch 1
      * Collect Vlastimil and Alexander tags
      * Add Fixes tag
      * Add kdoc for @after_rcu_delay of kasan_slab_pre_free()
      * Rename s/kasan_record_aux_stack_rcu/kasan_mark_rcu_free_pending/g
      * Add comment for __kasan_record_aux_stack()
    * Patch 2
      * Move kasan_byte_accessible() check and
        kvfree_rcu_barrier_on_cache() after switch

  v1: https://lore.kernel.org/linux-mm/20261009214639.2878857-1-kuniyu@google.com/


Kuniyuki Iwashima (2):
  mm/kasan: Detect double-free involving kfree_rcu_sheaf().
  mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().

 include/linux/kasan.h   |  15 +++--
 mm/kasan/common.c       |  13 ++--
 mm/kasan/generic.c      |  17 ++++-
 mm/kasan/kasan.h        |  34 +++++++++-
 mm/kasan/kasan_test_c.c | 139 ++++++++++++++++++++++++++++++++++++++++
 mm/slub.c               |  13 +++-
 6 files changed, 217 insertions(+), 14 deletions(-)

-- 
2.56.0.313.g2479322e68-goog


