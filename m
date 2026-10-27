Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7637C606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FgJGan7p
Received: by kanga.kvack.org (Postfix)
	id 7EBEB6B0908; Tue, 27 Oct 2026 18:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C586B0909; Tue, 27 Oct 2026 18:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C236B090A; Tue, 27 Oct 2026 18:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 382E76B0908
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:26:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B79AEA841D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:26:03 +0000 (UTC)
X-FDA: 85369840206.09.37E9363
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11EE2120002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:26:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FgJGan7p;
	spf=pass (imf29.hostedemail.com: domain of 3-CThagYKCCULVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3-CThagYKCCULVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793139962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=35SH48eKyqkOU0MTO2yi/u5JEpuE09ODfaHRw5WcxKE=;
	b=p7BSbmKKTOiLtro3pF4/5J+W1KGFicmhtxinZqBvU+Mxw/WZLcsVlut5D9jy+5z6dhInnU
	RpkcgxYa33RVaxm8bcvi/fGZEjWUytZH5gM44tgM+iDh6Jv9ZgwEoVjXA2vNQzqV27ftx1
	wwnus3YoyDeyJIqLes2XwFEmycWb0ww=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FgJGan7p;
	spf=pass (imf29.hostedemail.com: domain of 3-CThagYKCCULVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3-CThagYKCCULVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793139962;
	b=hMDOwgAcCWFBxQgLaHvK6Fym4F04FmYzuU+g8et0K5vslV6/IsJlyESifRPifYtVcVYQ8r
	lug48mAAAi4xnaVYfRXDqgpsR2Aop/vG4YRzVoDn74qSkivM3xIhNfkwsrfVhcVtaI0vbp
	7rf+fNHCvjq+U1FbZmRMk8cKBG+w1m0=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e818ca61bfso2248725ad.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793139961; x=1793744761; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=35SH48eKyqkOU0MTO2yi/u5JEpuE09ODfaHRw5WcxKE=;
        b=FgJGan7pabHmiIJnv49w0N3XHnsXtj/7sMgXJU+jtwu1+Cgaeu6/GALTmhiET+/uW4
         cOD4B2i6dhUuENyVC+kjN//sS/Zu4Xu8/updxv/5zS0ZuAlq+lcwBjc0wAgVahhcpv+/
         JtVr1EnmG9jtvpnSCbCB3r7OyuVcCvWIvyc7OfyzGVz3XlfcEUJzugMqkmi1VXVTw7Jr
         ALR+JT6HHeRkj6K1e0pN0XpcVHx24fnyfp+Q4NE3bEwGq63WvuOdKbI/T/jfyqc78Y/T
         Git74HsFpg/qOophWkbC2X6BwM5YFja1EramO47/AkhUyvRGZ1BZwGE/qOl21daG1PDK
         PzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793139961; x=1793744761;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35SH48eKyqkOU0MTO2yi/u5JEpuE09ODfaHRw5WcxKE=;
        b=TB7IORyBEYLujcDDfGDhiIqlJpGt4C6QBxZ/HzpJjldRLSqmzvQD6aMZSopXCNXWgv
         pm+0qoP1mtUCeQNI+N07/rzu/x2C2WqUpcZPMuP/v06CnhhAwy0z/rH/kPAqDE574Gzk
         IJBx0qMRYK0aZwR+OK8j2o3t0vfvwqTOKOBhajLvpEVK8HB72tr/1RWRb2xoQix0uzVr
         QkvFPxHGxbK1WPnfiy0S5XmxzPZBEanIIrDi973x+GdHIxNwZF4e5q1Uf6hwPU6mh4JH
         NyPsISoVDZRXUPpnfYb9K1DsgliZq1/aQex4SXbWFNEgfD1ob4s37YIFqPZKa9npx9gM
         Qk3w==
X-Forwarded-Encrypted: i=1; AKwUvBxXYRS7p/Vpt1oDmAhlyqUMtJt4WZvuGzX4NhQTGKzA46/I+9cXu3O87h0izgrSQLaLshTdb9WfVw==@kvack.org
X-Gm-Message-State: AFq9FYJRjyoCEWEGP75WmSmjy/gBBjhEAwA8KJHu2YjXCir+ahPntWDp
	h8T4Wz1f4/ie24qXe/PaNKmFKXYjMkXzI5MysDFhAiGtUFvxpGyN7L2Af4ElXuGfjyCycnGQ23W
	HEJKmug==
X-Received: from plad19.prod.google.com ([2002:a17:902:e153:b0:2e8:486b:aed])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e889:b0:2e8:3566:b53f
 with SMTP id d9443c01a7336-2eb003bf1f6mr7269935ad.33.1793139960651; Tue, 27
 Oct 2026 15:26:00 -0700 (PDT)
Date: Tue, 27 Oct 2026 22:25:44 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027222557.1072105-1-kuniyu@google.com>
Subject: [PATCH v2 0/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11EE2120002
X-Stat-Signature: yym7trdaf9u63xhjtx7debar5e47n3du
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793139961-63954
X-HE-Meta: U2FsdGVkX18K1nusTjj7/aewFNhODEj7VHX6F3kw5lVwzq0mog1eJoUvbau6IZwObn8ymtxdf24KxY4Qg4fRa8wEEl9HuW+R2KFtL2WntirS1gvFtsf5CLgC+6ugGJoqsSoZCEjKZwEQJ+wIGvD2SOIrLBsuq6Ko+sNz3zUVOSasSFjK9GXZcBmJmea87EdFPcQBqNlHKER8ZP/CNnjT+WRUuin3Vt4yWVIeREwZCLeetN+XVRadNNwBUGCxsnlqN+H1Rsp/QMDcXEpbe/VBe0zgIEDZsSpVEvWbTks48d5Zm/+EAhT+Kp62x5HyC+deRVNssshmMq1vWzjdk5cpRPCWWep4stgPoN5I/XSXYJ4C4VXpaKVyU/IK2EmKA6iA0V6mqs/+X6Na+aiDtCbTci2OCy2f8NSl851Scqsnk/wWzt7OH2BMuSyOlk9WJdwJZVckTsuLFj9exYfvufdjb6+X9Ac0MNuR+SNWjRKos3Ib1Abh4TPsxf1FSPkr6LzIqEoZYwxMidD3Nv+EeISZCEeSdVLgIlZimz6M2ElGmG8i+ZLMnfE7VXMjATdHHv2ZgqIwWv6hAu6FCZL3dMc76MuVHsHcifhMVCFJTv8PMt/wIvDUKA3ZEAIYnqGFEXAS2y1HfIShxOVm6y0xmojJUOAz3Bey0Ye27jQ8VxsN8nDVuAvGjtD1HmqUTq0yt1rrGSN4Xt4eL5/W1rcEtl4Ss0sFoZQ33lWell89TSLhFACN4o9qO7Yuj4vkx0ZzUHm18grONbbVYCrbQlb8ry7Hmg+Mm/iiG8DqCRMy6/IAIAy6i1Nv9srlcscdxuRp40NPwHY3cE4err1/s1TZfRYkH21NMBvdXR7ORgWQFSMe/yj4Cf+pfzC/wgeA79kRnv6yUun0UK5nUNBT7yF41pAIOx/iWUHkqG3dq4t7Tn3MOBAZkG1E33JpoKcvVdNw8mmsuXGWfEpSkm3BShtqIWP
 7LOpCE82
 C0Z0adKXC20q4oNAvaZIM/E89Rd2bZW4+kN3HrMf6wmPgcMbkvjDQO2WJSrxuiZI1AVNqerqZfqNtljUL7I4LztPXLS6e7mHtZFHQThnoS7ziIw2TWY3J3qBHZIoR1IlwQom4aWSePz4T000jk1xwM69oHo1ZXL8HRkqgsYYFw0GbRymVcqSBugeGEkT1h45wndOF/iv1ujs2WwKF/BHHtV6lY89lf6UAuC8Wc1uSd7GiYzG0KSqoKKXY1Tq4DSQ6lPqkEbnAlSKZQZ6U3+698AguLxVwSpyvfCPUyVkSC/XyUmc1T/cH5Xo3ONyUBy1BUCU9RY1g05MCJwOeonQY+XNo3qDOmQKif4EDni8C8cGgc/NbTlB27D0To4qdxajxRc6+zOxQQ2OV8dLK13r3Fbq47EvwAiJP5LvHmPWa1shn1QUt8pKqsKG98LPrDIX1xIt8uH4qMCFYiBCtFzY0uBiCJ+WDZ8n//6iU9DPqEuFG2R///WBsoLOoU7jrPOaIqsRkmHhxJAcaLoIjhmPkyT4dg6Un8tN4Ci8is8I6M+kF8up0JW9fSwDFZgvQfqnzfKVJHA8WVEzzDe6V0x4/JOi+Lyu4qLCEOWaygX9WLYAEvCl2jMiYIDV4J3aTkLkROg9YNeVLU/wHbKe6jbi2MRbwI/jKrPdZjE89nPa0VXTyN9kPeE4yvLBgnw==
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
  v2:
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
 mm/kasan/kasan_test_c.c | 134 ++++++++++++++++++++++++++++++++++++++++
 mm/slub.c               |  13 +++-
 6 files changed, 212 insertions(+), 14 deletions(-)

-- 
2.56.0.307.g5fe7bd680c-goog


