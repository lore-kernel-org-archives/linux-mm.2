Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F6FBC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7A56B008A; Wed,  9 Sep 2026 05:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AEAD6B008C; Wed,  9 Sep 2026 05:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DC96B0092; Wed,  9 Sep 2026 05:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26BAB6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:42:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 312BC1C0669
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:42:20 +0000 (UTC)
X-FDA: 85193733240.03.3EA12AA
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16C3C180004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:42:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sqe5GzcY;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZhIjaKSKu0jnDwRfSlp/FTaG5xLy46pxEQXC6FqYeA=;
	b=tVVD60qKxiKIK2cU1inz10u22p7ywVdrir814rHQUclBV+MILHBnPszOfSviiJT0i5yNB0
	2oTxVkCxUvuOLC238X6owCTQijaneU0aQ9HSeg1FzJRZ78MMtsKxMyh6Pb1mutCg98Q9u5
	OjyrOYTp+fQUQNjIqstf1fUtJ4hFuUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946937;
	b=OWu7K35R48mWezaXuuyFUYa7mYKR5J2WwrGYvpkwPu6PkUQQaV/JkncKGStfflrKFzkR+r
	5AgmInQwb8Cyyt4OM469AAi/V4wpnAUglqGcSvozrIyGCWZCawPWTERGufYftev3OZu6Oy
	cCiOZoNJDJy0CiQHaKt4YRmgggsXDD4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sqe5GzcY;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66c70f69d3fso5315969d50.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788946936; x=1789551736; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ZhIjaKSKu0jnDwRfSlp/FTaG5xLy46pxEQXC6FqYeA=;
        b=sqe5GzcYY3mc2w26V2AHh+bWds33WRrih3J+WzS1Oo+QrV0d+WTwH1ptYhpbZrr76r
         9Wc+xR247QEyJiotIOJzGrYlrrz9p2is0V3QgpoL7lDXkD2s+LE1hzmsNIOP09WWa1Rc
         5N6CC10+4Yvj5wK1VyUr5PBHWg4vUplA4WZzx9hu0mAKzIC9sGXDdQyVW8mPh8+3sciZ
         xYWJf4UkDnN/loxvMF44O7Y4GOLYTL85wDkHEy3OU86Keyisu6TIElBVrIV5qON2Sh/Y
         7g1XFp7Msx0xZNw+AMpNuVeSoFOB7QIicWd1Qe1pinV91UZbl/IkHH8Uyy0BEONSTdCn
         FCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788946936; x=1789551736;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZhIjaKSKu0jnDwRfSlp/FTaG5xLy46pxEQXC6FqYeA=;
        b=JknlukPo+oFezEjhsER9MN7CZY3QVJO1ggC7bSIMAI0DhfQ28cgj3E/RLDkGeti1/n
         I4TQT26BWs+v0H6hhYgs67L7z8Tnn1Oe5+ofY2g4nhC+CDljK5gXEY+lGzZWvcDz+SpH
         u4R/rf0jQNV4eRIo6IE63adD73JTqCXEyqQujajOU4kvQ+xzBIUH7mkUtDBLr48fNACw
         G7T3HgG4hpcOEa+HyamKmTxcHkrF097tp9GBrABBt3vN/KV7oTTABVF21rqsnAYpuoBl
         jnBTAkp0lc/pyQq/+hvYRO0wiFguXrsxCZMeivCTpnmkxiGui/RAQMUQf5VByIOuxC8E
         uvzA==
X-Forwarded-Encrypted: i=1; AKwUvBygQ5nBlJpKOAE2prbQ+fWf8vjkhD92WUpSQH0I8j34I+V8vlyZ+UGaTEsZtZIJknjU72FrjDBqJA==@kvack.org
X-Gm-Message-State: AFuF++lvkyb+9WEr0kb14Rs+Ri6/tNPNuZNCygotXQrQfB1vr/42SmL8
	cRlkReZmNJsNdkatcdZIxab+gLxSVpLLVjNRpEh89jXbT/1eKNDOtmD+0jBv7YoiVA==
X-Gm-Gg: AYBFou2LXev4aDBqo46FaRaYgSdvNe+IaDjpZct21VLXnwDomTwRFDCpLCcYQRU7HNN
	L1VPzPrutsWlaDRa0tU7uJCgKihcB0hJo3CKwdBi7rDyvYd3eJik8TpFEgZFK1y5xQ+NNFFfkpF
	IOZA7bZ92QMJZ8avfVIzzXUpsAakmNY3co9YriHfr76KAtLcGD/OkMCr+FxcUAfsz4Be7ONr61I
	nD7o1NDkhXAknNYpO/RSmUIUC4AlY1OrXv8KumYB2BxJ+ZknoNDwDd/rWUX65uuxjne40Wk7dxr
	krZWliMm4vi7OiMkS6IIhSKGk4SIgVaXDmdRyM5zyy5tR6uDyVE9+XjJfWTkdr1TaGj645VLoI5
	GIKqcPbkmFPY0o9VrD14cjqcOsAZosWdr6HWulkIe5u+SepemyNkkE5RjzJvXIzDG3VLlz1d9Qv
	3rLCoeDHqzzI6BvKxT25mtq33uJvgNxs27WvOqbd7hw4f5nj5eZ77OLltkMjtJjVxfdXvcWlOU1
	A0H+1HvmxMJ8ekNSemg4D+fmWdtH0iykXh4osPYAFj/MyTZPLZ3D/OvyH09
X-Received: by 2002:a53:a043:0:b0:66f:c1be:3187 with SMTP id 956f58d0204a3-66fc1be358emr5989382d50.94.1788946935368;
        Wed, 09 Sep 2026 02:42:15 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb47a8b8fsm12141411d50.2.2026.09.09.02.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:42:14 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:42:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 01/26] mm/fbatch: remove !CONFIG_SMP special case of
 folio_activate()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <b482561f-6620-d41d-eea0-a7f2a05cc444@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: wsocgthgh611agfuotejfzsu1483irih
X-Rspam-User: 
X-Rspamd-Queue-Id: 16C3C180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1788946936-496694
X-HE-Meta: U2FsdGVkX1+o6uo1UcXX/OF574KonPNoySjCVLHhgDzzG8FSgzb+eOdNbaqS+7oAn7f0ePuRHGBg1iL0M24Xl0ukQ5T6NGUpNML24+iL05WZPNoV82U+UrWFfdYskjziCuBov02VGkv5HMLWcf+bXfc1rY4Kn7Bfs1Yddnna60dIWYDYd3eXMATs/5IGFBg2VJnpkaq0Pe2exDKe41afpP6bGWgCjdf+SovvmHq/HfjSAM9brdpXF0LcHldirm5ZkDg/QVia9UPaajcucTDN+hr6ZkE61NoyROcElTovF2fSy8J3uO+CItib9thTE4CbauqwO8sEOrk9kGm6dqLFGPeqmp4Qbl1T4qBjQvijl0i0gfqGV8ePoRRMalxExUIk8yOUsIUmfPtwdlE9nVelGZ4xhl52yBA6ZhNmWcMTkwgE7wKp3++GSp2hg+KhD076GqPXKiuj3+kD4q5ng8K5i6jX1tLzD2eHK2KhEUg2ipQVHoa7HcIc3tls3rZVV1Y+In1v3dNv8mT6xkeRPh6d7HpskzAj3Q/aAlUpMgkz/bCa7SsO7fdP/3YqhWsNLbQxhKu+gFlwbSz2JRME1z00nLrJtx5+lPUxT/SAt2RAKLmWzDygHRZg/tGA2sy9Fn3/lG3TXmsbyj/IeA2pAv85Pupl6A9WPX2QwSdeSYcSYOBYA3JE2pOCcyP0whegK2L8AsHqlx8ga1D13dCtSCfco6sytplgaRuXQGi7oFLxt57Zalx8ZaabgoFNxS8V1e+I0haXd5IfZ1FXcURi6W/oAiBZzaCNzpseY4a6KoEyFAzZq0tNn6Iz0f0x+a/G2TcypXw4OgybXNX2roLY8qedfg41m57ayFVfFac4LqZYPE3zr22I35i1TGWcISMrcIkamOFOGHqSvJ4UeHdyKuDAs18aBd1K+FPE2oRFBE6OZedwj5rIqHl1sJgmSJnLaorSxxzag5+Vu6zOuU7Talm
 ThvjWV3B
 rv6GXS7Qmh0cKscpq8Nu7nVTMNpVwUyBcUZy6iT89+5UiZqc9XyOMCCLWCR5yV2PumRU1E94YDElw7JoVowK6HLoPJhDLhyC/4gYFg9q5YYS81mIKH2ixQgb1ufu25n2LihQ1velQ7ocZZlvFL1p9A4aFw84EaRdPVmqb9kIqwnX3R/1XxQt1mvuMKMb1I00Dh1GGzibr4u85iDPTs7jcgnNvcYNvZJUrQ7L+tTUT/5bqdPXdI/30b4zjQIw4PHHdmEmr3cDT58lzzWOUneUkp1wMyRXdOZvsycsFGsX40IUGpTHO7NfIPXcLYvJoukgQyazJYQBep+9bJpGMonWcbTqmMy9GWVvKyBkN7BUYRvo/eKwqnJ6hvs9aE1w1pEd1OyH+Ic7KXb7069ndjBEQjnoZZHJJKPU7kxmfGYDqH0+MXo/TIoL1ZRD6bZYaqjTgZHMGO7gbBTpeQbSN6gi0S85iW9n83+07hpA4le0oWuA/yYTPJSzGlTJqF2c0mH0wwSalJErqxAeOSt33QyCE+sKA6x78pgoY6Avr3ya2Dt1Huyr1DNXsKMJ6GhyRoPECPFtDH3ICB8azcpq96/udVAgOOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

3.0 commit eb709b0d062e ("mm: batch activate_page() to reduce lock
contention") brought in an ifdef CONFIG_SMP around activate batching:
https://lore.kernel.org/linux-mm/20100805140755.501af8a7.akpm@linux-foundation.org/
shows a sensitivity to bloat that day, not any incompatibility with UP.

No other batching here has a UP alternative, and it's a bit confusing:
simplify mm/folio.c a little by removing it now.

Certainly we can reduce UP bloat (and/or 32-bit bloat) by, say, lowering
FOLIO_BATCH_SIZE from 31: traditionally 16, 14, 15, then raised to 31 by
6.9 commit 9cecde80aae0 ("mm: increase folio batch size"); or by giving
just the static per-cpu folio batches a type of their own with a smaller
array size on UP (1? or a little batching worthwhile even on UP?). But
not right now, it's orthogonal to this series.

And I suspect that the old ifdef led to lru_activate being placed last,
whereas it's usually the second most popular fbatch: move it there, to
match cpu_needs_drain() comment "Check these in order of likelihood that
they're not zero".

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-By: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/folio.c | 40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 50a6dbe55998..c093ca900a3e 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -48,12 +48,10 @@ struct cpu_fbatches {
 	 */
 	local_lock_t lock;
 	struct folio_batch lru_add;
+	struct folio_batch lru_activate;
 	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
 	struct folio_batch lru_lazyfree;
-#ifdef CONFIG_SMP
-	struct folio_batch lru_activate;
-#endif
 	/* Protecting the following batches which require disabling interrupts */
 	local_lock_t lock_irq;
 	struct folio_batch lru_move_tail;
@@ -283,15 +281,6 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 	count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
 }
 
-#ifdef CONFIG_SMP
-static void folio_activate_drain(int cpu)
-{
-	struct folio_batch *fbatch = &per_cpu(cpu_fbatches.lru_activate, cpu);
-
-	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_activate);
-}
-
 void folio_activate(struct folio *folio)
 {
 	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
@@ -301,25 +290,6 @@ void folio_activate(struct folio *folio)
 	folio_batch_add_and_move(folio, lru_activate);
 }
 
-#else
-static inline void folio_activate_drain(int cpu)
-{
-}
-
-void folio_activate(struct folio *folio)
-{
-	struct lruvec *lruvec;
-
-	if (!folio_test_clear_lru(folio))
-		return;
-
-	lruvec = folio_lruvec_lock_irq(folio);
-	lru_activate(lruvec, folio);
-	lruvec_unlock_irq(lruvec);
-	folio_set_lru(folio);
-}
-#endif
-
 static void __lru_cache_activate_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
@@ -628,6 +598,10 @@ void lru_add_drain_cpu(int cpu)
 		trace_mm_lru_add_drain_tp(cpu, nr_folios);
 	}
 
+	fbatch = &fbatches->lru_activate;
+	if (folio_batch_count(fbatch))
+		folio_batch_move_lru(fbatch, lru_activate);
+
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
 	if (data_race(folio_batch_count(fbatch))) {
@@ -650,8 +624,6 @@ void lru_add_drain_cpu(int cpu)
 	fbatch = &fbatches->lru_lazyfree;
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_lazyfree);
-
-	folio_activate_drain(cpu);
 }
 
 /**
@@ -759,11 +731,11 @@ static bool cpu_needs_drain(unsigned int cpu)
 
 	/* Check these in order of likelihood that they're not zero */
 	return data_race(folio_batch_count(&fbatches->lru_add) ||
+			 folio_batch_count(&fbatches->lru_activate) ||
 			 folio_batch_count(&fbatches->lru_move_tail) ||
 			 folio_batch_count(&fbatches->lru_deactivate_file) ||
 			 folio_batch_count(&fbatches->lru_deactivate) ||
 			 folio_batch_count(&fbatches->lru_lazyfree) ||
-			 folio_batch_count(&fbatches->lru_activate) ||
 			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
-- 
2.51.0


