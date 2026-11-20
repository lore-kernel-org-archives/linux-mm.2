Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F5B606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LobbUhHv
Received: by kanga.kvack.org (Postfix)
	id 461816B05E7; Fri, 20 Nov 2026 03:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A026B05E9; Fri, 20 Nov 2026 03:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3501F6B05EA; Fri, 20 Nov 2026 03:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1031B6B05E7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:37:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94D53A8C46
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:37:21 +0000 (UTC)
X-FDA: 85454843082.21.DB605C1
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB29E20002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:37:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LobbUhHv;
	spf=pass (imf03.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795163839;
	b=rPMN0o0j+GhXDSzSCooiCIH5gWntPwkT6dHhhbpARMgXy49tBVLZcCK1Mq5331lSDHtazf
	sa4LeJqPLoUOo589OGsEi/mSKypfJ2Qj80kNsDy8EXmF43M6QiendCf0pEWX/0dq6LzEhQ
	yZSEQ3KCH2+sqxzUxg5SBr/Q3+/Vqf4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795163839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/fHu7Nley/JjRttReoBdOyGfNrnA+dp2NZ1oWj3jhM=;
	b=n/TlpYaNRuOy0UvNNdPd0hWIpopXl0VLrsmV0fghZLG4NpJS6gZpgCrpgYm7yMriPsJtaA
	i0Eu5/viQXp2LSTbxIvrLo6UlayHcuu8zHMDJb4v3ZT9gOJ1kjp2pYj/FwVc8/5JBEcb7o
	RbT4kn0E4mA/tLQFHO6soAFMWmSifGQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LobbUhHv;
	spf=pass (imf03.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2f037bc348dso5519685ad.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795163838; x=1795768638; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g/fHu7Nley/JjRttReoBdOyGfNrnA+dp2NZ1oWj3jhM=;
        b=LobbUhHvSSLTB5g8704BbjlGDmyJFyPFp1zS5AW1S8g7A/YsiLiAiZfzrkAhkamJeF
         T62iofzXP4lWSzoyga2rKmQeXx87Lu0hMbT7pY4hqbVtlOe1nBA70zoILlHuaVhD06XD
         hTCJ9FX+M+DkFAehO/BrqIrKJLOGeV0wvouWYP6x05FL5t33ZBeTyfz7lOd05NrwdEkK
         FSFoX6E/Fr1T2qxUwwCo+ZGZm0nHTknLRD5gH6tG6WzbVLsxC/BTFIy3Aew1JeXGDpdE
         czU3/fCwaGyaGnryxXjNFdjFl0OqxgEdHabhzXhpEa0Wgv1pOqfBDQjl4lzbYQ37uEVK
         1Ksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795163838; x=1795768638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g/fHu7Nley/JjRttReoBdOyGfNrnA+dp2NZ1oWj3jhM=;
        b=Q/KNP08z5INbhOEOFoRlghuCmnFmMjxbxzhVMsX+P9C+wOm5jBiu07pr0kpHqHdCXV
         YLuBefd/H+plPvPjnhzAPZyJLRO26S/y4fUnrYy8L5sDc6KqAQk7pfEYruILLhY6Pk5m
         g4PB1fN6sAB/gXl5oaOCcQR1zyafZfw4Q2xsYlpSxbO2hhyP6VE3LBw6XqEbFnQtNXGM
         qVyvC3C+YE5lNPh2h5tnJrSkwQDeq6wgHSj9iBY9SPbB9OtRBmLa8tsRYNBjvzi4KtTv
         lgzGpriaBZt9+nYdf2SWqfCWnH0x1IQRv5FVBfTvWYqsS4QqaCGDCIRhYnC+OjV5FsO+
         XnqA==
X-Forwarded-Encrypted: i=1; AL+hErFLUbaousfjKJZLCNEYmBpOjzk43SY8ppKyF90Ol2x+OVeT5AMftSS4FmLbL4ukKh8hzFynMTACrA==@kvack.org
X-Gm-Message-State: APuU4Z/tZeZQo7FRDrqEx1vV78nvDWFkpLJcM7N4mhDVeeR0kbWASZ/+
	1Bcs3GbJhY7gCqpWMxKbzW/ASAxdHMooBZAPXmfEYtMbbNYqncm8w1aj
X-Gm-Gg: AZFdTZfd3LonD8DEbC8ZM5Q2Vaeq5kNNYBLp+8eVjH6Yiy3D9kYbzQQBjpGC17rPOm/
	uaCfp0hDcWf3FetUaGifFNJxu4PmmzeVPpkEFCjX5WDFQy5n11jXMqEOU0K8lz54vU0RqqaFwBY
	HNDMCJQl2+Mdgs9PFmJDPdRCoo2qR5zdNg/mhJOg2CjrrroO/X2/TzYw+I+XDpFBV9BXUo1S/8r
	XcOMGESV/IMFpsKuNVg5oNJp51rGlzCeaUEc0TwRh2MhodMUMArm/AbJrCsAPvKV69d7qqzJe00
	5va78JGwjEpMgvp89LMBnCY5Kz8/BmfxPI1S9kzFJfqDMvK7TyNdIE0DLEjKbPn3y92Ba8qLjJE
	dOvTeelJq0HwFX3D9CHW2QMxRAltkh+6SlGIYNlyqtw+zQ6DnfoPjTtSb+UKQZlOlKrD7n0UuEa
	KeFRFWak8SWQ6PK8HBHfNTR08iacAtN/XnzMKwxvdcNgqT2oWLDyk4VTlmbN2hj+GbQuRc0NHrG
	FjaWP8uwXtH3JNTo2Zm63iJ9VMxUxrp6mtfKo2d9md2ReX0DkhVQZq+8CIUOVg5JQub6BV4qocs
	d7KjAeNS328B1JwT/JGBaz8+iRbWcgJRqRel2Ah2x4kQBg==
X-Received: by 2002:a17:90b:3891:b0:3b4:127a:2bc2 with SMTP id 98e67ed59e1d1-3b41c8d9bfamr2140676a91.14.1795163838461;
        Fri, 20 Nov 2026 00:37:18 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b52dsm3590057a91.5.2026.11.20.00.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 00:37:18 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: vbabka@kernel.org,
	harry@kernel.org
Cc: urezki@gmail.com,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm/slab: don't queue the page cache work under krcp->lock
Date: Fri, 20 Nov 2026 16:37:07 +0800
Message-ID: <20261120083707.296481-2-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120083707.296481-1-zhanxusheng1024@gmail.com>
References: <20261120083707.296481-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: e3j6zxgfzis96g6os5kiogspn95shnpz
X-Rspamd-Queue-Id: CB29E20002
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795163839-824295
X-HE-Meta: U2FsdGVkX1/LDWiz7bksfk+YA5q7HyXPUslAnKP4nM1eRJb9nidgW6GUI8RHk5DeZ47kJOQYFKnAQQrjBMd3eTnEWdh5SU/xC8/Ko4ZhN0bS5L9u6pzkV03NkIXJjPJE2CWpm8xdb/gSOmhIInf/lnpSoHt3n2OrqDNHhqCqNaLu3bUS1dlTmhPe+Q2nkNS0KuBdFgEKObLxHCf8aBattnFH/Z7iyAI/b6wGLAjpLzit9I1Lvh4sq4zHZdCs7kQlj9t/JwfhUqL5vTP0ESRaitC0URjQt0v63weGirKHsZabkrUTFixPXoKRlGxez5kvJvLvK4i5N6FNWqEl8M1W58CFO5D6FSoVXgLE1XFzQfVrdVRbJGjodvJ+xHoW30XYxpFkRtPNc/s93wiVCzhiKsEDS91beyU8oTr7eTX3YkMD4W0LT/bLyLRyQb2ULQIMEQiYAXCpLhxkaGmWKAvm2RYa8CEJ6C/MLpGxDuD257ro6ZfNfi2OUpdWVqWD/yk7bHsXpFnrxtYlsq5vKd/LTMNboCXh024kBvs9cO+rvduMxweDfBz1/nl2oGORjNt9TS6UM7/p2yt469+iSKoXIRmFvGyVuKCVk6McXH8y2i8nxl/eXCF3GGB7U6UQs6VRmcVa25ZomUXJpPWVnWwYr2HZtSkdjLog0urIe2XkA3bu5ti8rzv08Zx6LxzCPMMaPY5Rfy3q4DmhW9/qlxoaQ6vZ6Bgs5R+wlkqSODofVqvTwIOEljiR26jI4wzgZCy4NH0EQ3mlPVB/ZeUW+bd4NrUljcBZ2eyeOUpLRGXrOCMg3SYEYTdOCtW1HEOLJqn9b7uT4FEnHFwSdBMke5cnrQy0+B159/UHUiHWk8jAK9a5mR6Js/KlwQ+SnBrvF/ukGPhF2KWavCGwWcPCV2FsNF+G2pe9irJUpGIFvB2UJA0RHGnZu2F33HX0mJipHRp8SpDB5BrTVRC3dz1OPwt
 6F0whtQ1
 VySXLa+cjHDk4g+Q9F+0BdvRw16js8MwpuJ0XSe8cHO3JV284yn+e7BNtdNKHDysLlbE4EP1/Upud1UN+bMChvz4/9zBCKFRvgVDmVIoX3mIuU5aQ8yQO3KgMdvAXHa1WOREhpeWRGxnLzBUrPlCIfsX7qja/vhaMD1YfsyRmc8goTiljsvXXZ5dPnq7Yj4FoNjJiRN2LbzGIilCBrJpTudiHym0xTcJani/e262OA4exuUkKZ3YjOHohr2RfNKABuEtUsizo4bK9ZG9MiYhIdhFKsa9QCzlonab05/WZFfcj15jPR5bKZmiJcJ+N31mk5ENoo5YCkIHqliZ3tD46r76S5WtHu5CGcCyPKPzon4scnB+lHe7koJ96bjAL0pDC2VKuW0tdO/bf9wo1+T0m63tbCob/zTNmkPU3XCSD9WOw9onGN6kq2IM1CJv2dEDoEx1LsQVchmhAHhjYV70ZMMM3XIvh7hdo2Xd/XixQWz2lg0yeLXP56mfyBFFMatfhIxABABqpL8W40etKkSr844SU5lGjv73CSqJ+/B+RoAQ4mEQ4BGXv6Vfni7djeH9Y9BV4WADq/W+nmeqMdTYGb8Ao/bwUraxpFFJTEJkqinYx/orGh7wLen68YYH1CPfixBp07Iob/bWRYzh3uyw99arlvz6p42QtjejcQL+CgFWKyKvrStcjwgqaWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

Commit 56292e8609e3 ("rcu/tree: Defer kvfree_rcu() allocation to a
clean context") deferred page allocations to a workqueue. To avoid
deadlocks with the scheduler, it used hrtimer to queue the work instead
of queueing it directly.

Commit d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory
pressure") later added a backoff mechanism under memory pressure, but
did not consider that queue_delayed_work() with delay = 0 immediately
queues the work and introduced the deadlock commit 56292e8609e3 tried to
avoid.

run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
callers that may hold more, such as set_cpus_allowed_force() under
pi_lock, so it kicks the refill work from an hrtimer. Under memory
pressure it instead queues the work with a delay of
rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
queues it at once, taking pool->lock under krcp->lock.

With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
pi_lock after a drop_caches makes lockdep report:

  Chain exists of:
    &pool->lock --> &p->pi_lock --> krc.lock

A zero delay also defeats the backoff, which is there to defer the
refill under memory pressure.  Clamp the delay to [1:100000] ms, so that
queue_delayed_work() always arms a timer, and update the documented
range.

Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v2: clamp the delay to [1:100000] ms instead of using the hrtimer for a
zero delay (Uladzislau).  The changelog is Harry's version from
slab/for-next-fixes, with the last paragraph rewritten.  The
Reviewed-by tags of Vlastimil and Hao on v1 are not carried over, as
the code changed.

Tested in a VM on v7.4-rc1 with lockdep: with
rcutree.rcu_delay_page_cache_fill_msec=0, patch 1 alone reports the
circular dependency above; with this patch the boot log says "Adjusting
rcutree.rcu_delay_page_cache_fill_msec to 1 ms." and lockdep stays
quiet.

v1: https://lore.kernel.org/all/20261028134647.3176080-1-zhanxusheng1024@gmail.com/

 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 mm/slab_common.c                                | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..0d1d76a6af70 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5763,7 +5763,7 @@ Kernel parameters
 	rcutree.rcu_delay_page_cache_fill_msec= [KNL]
 			Set the page-cache refill delay (in milliseconds)
 			in response to low-memory conditions.  The range
-			of permitted values is in the range 0:100000.
+			of permitted values is in the range 1:100000.
 
 	rcutree.rcu_divisor= [KNL]
 			Set the shift-right count to use to compute
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 41dea01a8c1f..6fb453118641 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2262,12 +2262,12 @@ void __init kvfree_rcu_init(void)
 			WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
 	WARN_ON(!rcu_reclaim_wq);
 
-	/* Clamp it to [0:100] seconds interval. */
-	if (rcu_delay_page_cache_fill_msec < 0 ||
+	/* Clamp it to [1:100000] milliseconds interval. */
+	if (rcu_delay_page_cache_fill_msec < 1 ||
 		rcu_delay_page_cache_fill_msec > 100 * MSEC_PER_SEC) {
 
 		rcu_delay_page_cache_fill_msec =
-			clamp(rcu_delay_page_cache_fill_msec, 0,
+			clamp(rcu_delay_page_cache_fill_msec, 1,
 				(int) (100 * MSEC_PER_SEC));
 
 		pr_info("Adjusting rcutree.rcu_delay_page_cache_fill_msec to %d ms.\n",
-- 
2.43.0


