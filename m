Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BED8606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kBcoc/p0
Received: by kanga.kvack.org (Postfix)
	id 6CA6C6B0905; Tue, 27 Oct 2026 18:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1AA6B0907; Tue, 27 Oct 2026 18:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE7E6B0908; Tue, 27 Oct 2026 18:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0146B0905
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:17:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FA24140B57
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:17:00 +0000 (UTC)
X-FDA: 85369817400.13.AA4CB44
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id C66DB4000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:16:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="kBcoc/p0";
	spf=pass (imf01.hostedemail.com: domain of 32SLhagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=32SLhagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793139418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxC8R3rSYOb3XkMdjyNe0hm8F2fSEUHIMbYVSgpiFMA=;
	b=53jEv4vAZuROPQ9ANxCqdUUdFuoktB61PTzqjtN7pgDRvxy90cIkERH7ZXK+CB+rzWGZFK
	xacZUUL1CZTkr80La4OWmipeeObIqTu0E2LWvOgee6w8yHv/CGxIejRI3EEi/j6XthcCW1
	ORMQgmqQcrAa9B6M9tXepbmJDD320g4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="kBcoc/p0";
	spf=pass (imf01.hostedemail.com: domain of 32SLhagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=32SLhagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793139418;
	b=Gb9V5UmIIuGcD4l3kC9hg6ZXL0c4SWH8LmDAvm54ydJuklK2AavYjtXbxyJhF1nk1XMNIM
	pu5oHinjbNgw6FgxrVGVp9EnDoCTIOkttBSMIQ1CdfkVavNkErrv+I1mTpbB/ra7mXvYUC
	AnrbOziBbHRPSw3kekPoPnN/MPim8Uk=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a086ed8980so219078b3a.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793139417; x=1793744217; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OxC8R3rSYOb3XkMdjyNe0hm8F2fSEUHIMbYVSgpiFMA=;
        b=kBcoc/p02Nh5SB1U7JsCQ4dNM2li5NaP6tdzo6BRbr2+VxT0zKEA27vRLxrD6hN7m3
         ROc8BgdtQXKWKgwL2whS375ywcimTX78hRAQjT36BQrb1z3NPVdIAOLiG8z7WiaG7mhJ
         Y/MeLjsTEiz5snXEaBEVd9YTkOZBYOszxT50HQqVc/DKDnfeMGbCinTW0WirBu7DAetn
         jzRpb/oJd8TFRseM6L2rGOPiAQna9pj5pkwADCecIcZaDn/BeYs8hhYanIaN7+yKkaDV
         wD5TxmWJNGwuQfXe+tRNBiUkZm0qGKChvdjIfBmSnsyK1MPgVeoGd5K8sTrWWPotyhKq
         Uixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793139417; x=1793744217;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OxC8R3rSYOb3XkMdjyNe0hm8F2fSEUHIMbYVSgpiFMA=;
        b=O9Kr3tXTVCzZy7NifRsyQe7FnBgX7D5XglO6Zx6vZR8YdZDgIvmRC8SFtqig+ITN70
         dwF4ea2N0+vHkbx0xe0D/vJ+tlJRUvLA5Z6rWBM74z3xNdN8oNuh2i6h8wiQYaAUBDMQ
         vK4mtTFx/mFJeyzzZ24Bm6N0mhYAiup5v9x2u1TWqFh8IuUJ5kzX5a3WLThRhB7qRYJZ
         JVCKqOaZwo6I078ynOIcqIkS5I7fIOv+4tjZgP4GsCTXO4IM9gFoJGDIpnEL+MW6tZUc
         u5Uywe+hqIwjwaDx9/RoDe36euGs5S5/LkAngPjqcXxeRGRdS04P5oG1TUktnsDSU75y
         DQIg==
X-Forwarded-Encrypted: i=1; AKwUvBz6wzBSqj/QlxB4SdiG8OmexjqsILUCcmz9tXUp1bTIXYN8Q9LPdo/DdnBtuaNAOSDGxiu+CfgSSw==@kvack.org
X-Gm-Message-State: AFq9FYJmCPvHROm+JOJAfmzGZtFqofZIu6ITfpr/TGQwDvtOViUdVGAl
	V3m0e8ap28/RyXVcWQG9zZbi2he8wPoXIn6CKtuCjEA0vrQLqoGf5PIbziKoKVfxlCnxJt0TlLe
	YsowsQQ==
X-Received: from pfbfb23.prod.google.com ([2002:a05:6a00:2d97:b0:89e:6029:204b])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:908c:b0:8a0:550f:bb43
 with SMTP id d2e1a72fcca58-8a5a61af994mr2231062b3a.34.1793139417300; Tue, 27
 Oct 2026 15:16:57 -0700 (PDT)
Date: Tue, 27 Oct 2026 22:16:56 +0000
In-Reply-To: <CAG_fn=XQXEdKSNG5L-dPMoNA-q_CmQsZ1G8c+jXaGBBWP5Jpmw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261009214639.2878857-1-kuniyu@google.com> <20261009214639.2878857-3-kuniyu@google.com>
 <CAG_fn=XQXEdKSNG5L-dPMoNA-q_CmQsZ1G8c+jXaGBBWP5Jpmw@mail.gmail.com>
Message-ID: <auEiOD0B675XgnSM@google.com>
Subject: Re: [PATCH 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C66DB4000D
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: o59fios8rqaazadpc3msyiwo7qsotcas
X-HE-Tag: 1793139418-252767
X-HE-Meta: U2FsdGVkX1/BzQDZX7PqBznORf96A6rnJZLct6Qkg+vmup05w5fA1bshvX7Q6wwcjKy6Zk6dICX+QdGYlqxNPrSzFuw40ia6fgBiDkpkdvUF3LYB6z5h0okkAgoOuI9/oUOkReR/JREOk7Z8mHwQ426ZYZtlHy8a2byJEEz5ZGEDRVGhqApi7Tio3rH2IFQxkhMssjEIGikMhW803brTAqqek20RDc8YWJktBrML00mZApcbO3sBVmlZodSwvPl5R6jF3Y4jbd6aQ36IlqwlWTBTvo1vxn6m8+XsM7b4S85S7bBITqh/qbbolQmusWY/hLT182UfReY4ItCeiufIKEnStozaXab+XOFAVCC/LSltfRa4QvIu2ODlGsuChO52aTriFqJ0ia9e52H6kavfMy5QQ2bN30zNu3iVgScCpcugQHT7A9OD7owdKKMJLo9IV2aUKvZMdQ1M52T9i9AksQla3emmhjYWehmHPDKCN4TbF/6pXC2ZA5HiS/0Dz9vV8/gfvMYEtovANqhy8uYKxxRBMIblhTzf8a0GKspyDmLqntx0TBzeeS60Hj0v3NN1D20FGMq82QqmFaCMDyFAwn8x6c43KXlyAyBr8vTJ5t3Xg0hl0Zv/stIq4rWUmQNVVC/XJtonxd5uSOV8HbS5efQ73PrWIXb+NAGeBIE1tahvrsfwsSEA9ShFn8cspqLCg+8xEvsHKUEqInzLyKCCtomidCAFbwsf4fkE26z+CJ3dk4gxya59RFW1ypsvrxFxP9KwJXv9U4RPgs9vqD4eex8bYQemxb0XxccuyWlOSzwj2n4tSbeE8TDbH32PzRIe+bxUFeZg2J4dIL1WdLt0eBF/xUVpkkqj0qGTd49q8amGi9hfTXOEr8Yj44LNv7HD7eDXDBg3rSQwT5J5xhHt62GEpgHtjXQC3lRulxd9bNlOogbdXE8sfogB3xtL3seHjgX0iKBX+eFYWo+d1Lk
 UqlqH2Co
 NHMLw6OQ/VYIPN9Pe8sqzJbgOS0YyyLvyAIbLaLdrhjgue8wPqNHvjzwDl2CVWq7HGb9h27N1Uz7F5F7z7pll3EzTTdWpMiDTxKY2ThLVuP/mKwXUBmObl7PhDEzelnxUDOBY4sWvEQZpvgbEOKp5kyeyyJ8D1OREsYQ/HCOPgnEbx2GFEnvGtM6n9qQUZLEoNO8nfMyFADO1tBsWDhhuPj5d9e67p3P0JEd3m3vI+drpWmS41e29TntsuIXykYk0hvqnGRaPJS3WIuQRspWDB7aTJi+COPiZF3dFFd+paAaeHyhmOLWgxHPHEFSZAEUQZAkgyst5+byw7wqg/c7TvE7iT2hWyB7fToLx5qJeZDYgePiGf8AlqpHHQsx15lixHb1gDa0hw+fvuRF/bkpwcpFtEgtLRam/UbTqAE02YdaBv2djrgZ+fUnCZuEwWhoj7M6lFUn2D1HPQOwU6cJInSz2zhbHNw36mkcTplGIXgVUfvHrXnsGAyvIQK7CIg/zBz3mkEdT4oc4OPqhI4Lfqf1jPXJ747KicSYQB4Ai2Iz6d1BtTB+gbJbKEcOa9+61PxFnwOCtBENAow9faK6Lw0JNZau//xCz8MV1sDcK7q7vTOr437hnHJy1bZ76U06+0PZwoSDNEoF9aFxXLYKk8itqwqjUr2XVqCwrAy33/bPsEDv1Yc3WpkLv263SGBe2dkDyfEWJhBsbCeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 13:48:05 +0100, Alexander Potapenko wrote:
> >                                           ^
> >   ...
> >       ok 2 kmem_cache_double_free_rcu_2
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Tested-by: Alexander Potapenko <glider@google.com>
> 
> > +       case 3:
> > +               migrate_disable();
> > +               kfree_rcu(p, rcu);
> > +
> > +               for (i = 0; i < cache->sheaf_capacity - 1; i++) {
> > +                       objs[i] = kmem_cache_alloc(cache, GFP_KERNEL);
> > +                       kfree_rcu(objs[i], rcu);
> > +               }
> > +
> > +               KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
> > +               migrate_enable();
> > +
> > +               /*
> > +                * Move the 1st full sheaf to quarantine, keeping the
> > +                * 2nd in pcs->rcu_free.
> > +                */
> > +               rcu_barrier();
> > +               break;
> > +       }
> 
> Unlike the existing double-free tests, this one can misfire on a
> healthy kernel: __kfree_rcu_sheaf() may decline (local_trylock()
> contention,
> alloc_empty_sheaf() failing under memory pressure), and
> kvfree_call_rcu() then falls back to call_rcu(kvfree_rcu_cb), which
> never sets rcu_free and
> ends in a plain kfree().
> 
> Could you drain pending frees unconditionally
> (kvfree_rcu_barrier_on_cache() + rcu_barrier()) right before
> kasan_quarantine_remove_cache()?
> In the good case it's a no-op and the victim check keeps its meaning;
> in the fallback case the stray kfree() hits p while it is still
> poisoned in
> quarantine and is reported as a double-free instead of corrupting the victim.
> 

Calling kvfree_rcu_barrier_on_cache() unconditionally before
kasan_quarantine_remove_cache() would also flush the 2nd sheaf in
pcs->rcu_free while p is still in quarantine, making the victim
check a no-op if the 2nd kfree_rcu() wasn't rejected (e.g. without
patch 1).

Instead, I'll move the kasan_byte_accessible(p) check out of
case 2 like below in v2.  This keeps the 2nd sheaf for the victim
check in the normal case, while draining pending frees if p
hasn't reached quarantine yet due to the fallback path.

This keeps the false-positive UAF w/o patch 1 and double-free
w/ patch 1.

---8<---
diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 60d25eb7cb01..83c418c0ef87 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1112,10 +1112,6 @@ static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
 		/* The actual free order is inverse. */
 		kfree_rcu(p, rcu);
 		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
-
-		/* Move p to quarantine if kmem_cache_free() was rejected. */
-		if (kasan_byte_accessible(p))
-			kvfree_rcu_barrier_on_cache(cache);
 		break;
 	case 3:
 		migrate_disable();
@@ -1137,6 +1133,13 @@ static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
 		break;
 	}
 
+	/*
+	 * Move p to quarantine if not poisoned yet (case 2,
+	 * or fallback in case 3).
+	 */
+	if (kasan_byte_accessible(p))
+		kvfree_rcu_barrier_on_cache(cache);
+
 	/*
 	 * Evict p from quarantine and reallocate it as a live victim object
 	 * before the RCU sheaf is flushed.
---8<---

