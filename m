Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACF3606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=LcIdXRoP
Received: by kanga.kvack.org (Postfix)
	id 16DCF6B05CA; Fri, 20 Nov 2026 02:48:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DCB6B05CC; Fri, 20 Nov 2026 02:48:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032DE6B05CD; Fri, 20 Nov 2026 02:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D234B6B05CA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:48:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D3DB140CFD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:48:39 +0000 (UTC)
X-FDA: 85454720358.24.28FBD94
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F4BEC0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:48:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LcIdXRoP;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795160917;
	b=lb3onJx7Id7iM3KcrJFbpcUgpjbPrL1oSh31igiNlrIboniBS3i+DakDfcB/pW2YS4OYIF
	nio8Y3wqQ9xp4x0XhIoUlKSmCimbx5rErYI1W3k6EmtkyzGulf6CKO9ZBNFAVn3z4twk+T
	4KL2KNzm5Yo7Z1J2jkgdUkpht7WGpGA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795160917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87RNaaNfdLcFk4ZTuxhuFbTHIbFpjHDXzWzIK6yaLPw=;
	b=iaRmpFbjPb2/GcZYehBnZeTwYu8/R3uHekTmhdSihxzXahvmsTOtKfuUFAfhhpGKOwF99v
	CQ18n1wLgKR1WyylyrzBDAt/eT4LbieRjzM750q9piEnTlOfFI6tprNHymU1k44srHfPOq
	3ynguEXWNnkc1IdcFJ/RxCDcy3RzOoA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LcIdXRoP;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b405d8f1cfso326255a91.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795160916; x=1795765716; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=87RNaaNfdLcFk4ZTuxhuFbTHIbFpjHDXzWzIK6yaLPw=;
        b=LcIdXRoPg9myAMZRcrnK8A90Xe3Ozv/6o6hM7H5LwH6VE8yw/pPlsmamZpl2igabnO
         Q390Zlhw/v9ZLoPLqcEOEDzNNinQlt1E4fSqMIMuKTFc4jH+xzlC64himHwo4T1QGdX4
         RDlx/kd3q5+/XxK9044Zdb3DlPEO7BoNAwxXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795160916; x=1795765716;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87RNaaNfdLcFk4ZTuxhuFbTHIbFpjHDXzWzIK6yaLPw=;
        b=h7jzW9ToYC97YfPZa7RjSXn33wdsBI7D5+VvISUbYSklD5pmJRVJBfdHvE4vEnj0KZ
         dHHjv3LcWOgj3l4Am5JHgLxB28C2uF/OUd3KnVpYpj5hYMw5VU5dvwEEs8HgkdwRTbmt
         RIRKuxG3yayfgw5cDyndQXtOsbXsvL/418dDcr+k5H/F8z+CF+p31HyAa0byoY9Rqtrb
         OpwCFX1HDcuJeWW8JhW1Qb0DnE21odC0GEMqqOTC4UMz52/i3fNz7Ow7ueMt7ULxwCIs
         y/C9fS3A8A5ENu6cNSgKVwnnzkwuMmuPw4wvenZ6MNTtRKklEdgM3SqYXxiVX7NDakHd
         8seA==
X-Forwarded-Encrypted: i=1; AL+hErFRpWtecpbjjlgdsr6R70y+tAOHoz5a7+X1QwD6MgC86siPW+Z+5+MZoIf4kihom7IQVu8BdzQjdw==@kvack.org
X-Gm-Message-State: APuU4Z/1+QbF4JbzocukvMHheoNLTHhn8sCODulaVjvpgRwfi1WD94+e
	HjwP3oeNOITsXe2bwwy6Z44l2rKwJGCCsC5dEwu1SR/w5SC4BycTwFp8DKjr0395JQ==
X-Gm-Gg: AZFdTZcN2aUHYq1LppoCl9lk8+nWUZS9rFsY9+5LhvAZuCOCNfx3eM4c2w5ri/86x/Y
	Mvr/ZF0vTr1iVRYZCJlkPHDYL7LPw1MIxMfMrCoveXQoXulRIsmxdNn/ZjN9WZOy+RLpeB4b11+
	b2PGYtAqyereP7ftChMoBhz/YCau72HYyjteUSytRumApT4kHbDilyC9u2IEpV8j7Yx3Fds5Wi7
	nP+kh8MEez4ROTQy8Y1wVfYaRKaE4TgWzS2E/xpfkJGAj5Y74B0WrNgo2vqE98hEx5v6IspA/RA
	g1IHHBMnfwgkBO09eiQHKAulolC0kFju53MbboV+Gl4etLB8+YHhRMldNEPdVmF4/Mdljtm46JP
	/0niulbYNXEarz9yLE8wjeqQ/ik3su/LuaPEq+NJU0iSVWbYSN9SJLNzD2Hao/Fx/SjfRXJ1RX5
	hbEdsYZ2eeyr6Xv53vcQsLDCH0Aifcn1d5Ks9PvySy8ojvT6jskRPMdjml/2nQ5JLhuZeevkJeK
	CsRHEofk5mM17sDtQ364mhaX4jHcAMIHxBd2qRS+TH/W9ZySFQpz4ikl9wSLFp9j1Sgy3RqxNqq
	WPHx4fdLzXt0O6dvb95cAjOmkBazr3dNu+DKN+vti/7+qLeRF0wLrfd8WegQltv0sIOYbw==
X-Received: by 2002:a17:90b:4a4f:b0:3ac:8af9:4a6a with SMTP id 98e67ed59e1d1-3b41c93c3b7mr2039531a91.42.1795160916074;
        Thu, 19 Nov 2026 23:48:36 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:d5a5:46fe:fd42:7b73])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b420000deesm1063037a91.0.2026.11.19.23.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 23:48:35 -0800 (PST)
Date: Fri, 20 Nov 2026 16:48:30 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hongfeng Chen <chenhongfeng0212@gmail.com>, 
	Nhat Pham <nphamcs@gmail.com>
Cc: Hongfeng Chen <chenhongfeng0212@163.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Wenchao Hao <haowenchao22@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	Hongfeng Chen <hongfengchen@xiaomi.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu
 batches
Message-ID: <av_4KLI35RzCQ7zC@google.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
 <20261023123736.1542117-1-chenhongfeng0212@163.com>
 <CAKEwX=M4jTnxmq6cj115Gw4u5jdY7Ex65jPtVTEopW70jGzfuQ@mail.gmail.com>
 <20261109105957.2577351-1-chenhongfeng0212@gmail.com>
 <av6JvaCh358eSMCw@google.com>
 <av-ltJooUJ0lqvqa@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av-ltJooUJ0lqvqa@google.com>
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7F4BEC0003
X-Stat-Signature: 351uaej3mta9a61npb77woxtzkt4h3mh
X-HE-Tag: 1795160917-239776
X-HE-Meta: U2FsdGVkX1+tUrzkcYoCj6zI/GODo92XnV1In/RgfSp6kIKO2JMMA6YghdyOVOSXydj1elofJfLAZG9byOF2S4vmONhyb6GCGhse68G8m7dhBSMUZq+gVJkQHxuC6E4hsW3bQWgi1KCNfYHGN/VvFuJKipS5HvoZQQ+8qFu4/J7zhe+8oWgRcdhQwNobNRYj0B7SQN80FjmBkm6VCoPtcSo8t09gKOsY6H0IhScdSuBWQXTfeoytibtBdZz7WgXEzsvRwST48CpiLjlOMwwF4cMNQyapCNzXzYFiYCr92alQhJ3LRk1ISGa7KITm4rXKIUtHmJAJHYFTkCA2mJ8vCN1IiZ7VO6dfIKu0tfi3/blpUxoXP3Yfw3QBzqVZOGNCF2Akd+Z6IbD8wJ/SYtBz0v/UWXc+Lu9nz+GkOyKgNiRwxs2NqgQODB2eOXqe/nhx+PDbriVC96iQSmdBwDnYV1+9fXf6a0OgP9Aozzwd3t0LEgDtJwCMu94ZFpzLAUJExBGhhUxsmp1WsWh/yXyrOTn7DMSClfbhGBMIUueNoA6br2AYKPXogwimZ3WZU1P4oE+ItVXQk0DPAwM4RlY8hJPT2f51zmyXvkT9O9k0CHjMZla57StK9qkVjfLnY/j15QcNItq+bkMQoYZ/QdWAREu3tGrSJB3idaaoqL9XSF1IXqZRYco5D51B8K6TpSIZn0iuqXiVLQ6k/1RhXMW25JM0OnjqCd4oncUSqpBo1FlLU0IBRANZHODMqYkBK+JQwjv7E0xTYEAdom/EosQMGdVMmzTrdOUXkRNqcUH+Bf8/y0cmz47ilquWKgwOZ29l0JZOMlbOvBiTySfh5CE/PYcbVnEfZ6c2HLiFOXWcY5dikfg1PXUyxFfYMK43Lqq4yOaOhRGcKfHo6Uw8bTtsO5ZlyJznki1K6oeDnvknAsd37xVcR6Z87FreMuq4vV359s5CRwBntRKBf4ZY7IR
 KFYLCiU8
 tIbrnUE48pph/QCV9JGnCnDn8pudtihThtLVYfDm1N549Ab3sM248uVpj6iS4/iZ5NWDkGAXF4DpLxgY79yGHx2LqUFuiwJqWRKG7Fh8lxDMMLkP05g/dT81mv9B/TeavRZFBnXiR6tFYNA/+CC4nzs2Od3BmLQe32F3jR873IwhB0Md8EsMEcrLN8TQhShLdaxLLeTujECU4Fto75qbUnhxO31hiX5FnnK3eCuBnK/QtHoaJDXMzCzDH9ZP756eMpOdDGQs1v5bQarNdfBJKIV/5t9fFFZf9hhDbp88ItssnQ3nmE1XdLxBuLfwgvadMFTGHPrkoayOsH5V92SNhDs93Z4WiXS0AE1xAOTss9AOw1Q6RRAK9TX0wD9Pqr+Do3sobwPVmqm0I2o+Z/Ww4C6UPe2D+g2tFQQlorGvRKjtCJrs36+qY3idFd632+F1PM5irE4cVoi5afrgtMGWjTIfugNChteIkwxd6Mx7OOw5NmewZOF9T3y/kv1tEeOUpdDb5PeQeRFMRMPqjyHLDFKdgA206c4DTuQWSBkuYJ5qSCskNALFWVhIX0M/KOOYUYEw1u7iDqC7bqD/lmOwMLOFxWAyGxyw9IJa0P/Rk3OSMN/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/20 10:44), Sergey Senozhatsky wrote:
> On (26/11/19 14:35), Sergey Senozhatsky wrote:
> > On (26/11/09 18:59), Hongfeng Chen wrote:
> > > On Fri, Oct 23, 2026 at 11:19 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > > > Is there any more juice we can squeeze from zsmalloc in that case?
> > > >
> > > > It would be nice if you can perf zsmalloc freeing. And yeah, maybe we
> > > > can't optimize any further, but let's eliminate that first before we
> > > > rely on offloading.
> > > 
> > > Here is the perf breakdown of the free path:
> > > 
> > > zram:
> > > 
> > >   __swap_cluster_free_entries        90.28%
> > >     zram_slot_free_notify            86.01%
> > >       slot_free                      74.15%
> > >         zs_free                      56.01%
> > >           __free_frozen_pages        19.85%
> > >           kmem_cache_free            10.15%
> > >           _raw_spin_lock              5.53%
> > >           fix_fullness_group          3.31%
> > >           dec_zone_page_state         2.43%
> > >           obj_free                    2.17%
> > >           trylock_zspage              2.12%
> > 
> > We removed one of kmem_cache_free() from zs_free() [1].
> > 
> > [1] https://lore.kernel.org/linux-kernel/20261110054836.1515030-1-senozhatsky@chromium.org
> 
> I suppose we can batch some operations in zs_free(), something like
> this:

A slightly reworked patch below - handle incompressible and pow-of-two
zspages separately (w/o batching), because those are 1-page zspages,
nothing to batch.

---
 mm/zsmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f571b3c9e9ca..9dcd1549c2fb 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -37,6 +37,7 @@
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
+#include <linux/folio_batch.h>
 #include <linux/workqueue.h>
 #include "zpdesc.h"
 
@@ -866,6 +867,44 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
+/*
+ * Free the pages of a multi-page zspage in one go, see folios_put().
+ * Not inlined, so that the folio_batch is only set up (and, with
+ * CONFIG_INIT_STACK_ALL_ZERO, zero-filled) when there is something
+ * to batch.
+ */
+static noinline void free_page_chain(struct zpdesc *zpdesc)
+{
+	struct zone *zone = zpdesc_zone(zpdesc);
+	struct folio_batch fbatch;
+	int nr = 0;
+
+	static_assert(ZS_MAX_PAGES_PER_ZSPAGE <= FOLIO_BATCH_SIZE);
+
+	folio_batch_init(&fbatch);
+	do {
+		struct zpdesc *next = get_next_zpdesc(zpdesc);
+
+		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
+		reset_zpdesc(zpdesc);
+		zpdesc_unlock(zpdesc);
+
+		/* NR_ZSPAGES is per zone: one update per same-zone run */
+		if (unlikely(zpdesc_zone(zpdesc) != zone)) {
+			mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+			zone = zpdesc_zone(zpdesc);
+			nr = 0;
+		}
+		nr++;
+
+		folio_batch_add(&fbatch, zpdesc_folio(zpdesc));
+		zpdesc = next;
+	} while (zpdesc);
+
+	mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+	folios_put(&fbatch);
+}
+
 /*
  * Three free helpers, kept apart here:
  *
@@ -884,21 +923,22 @@ static int trylock_zspage(struct zspage *zspage)
  */
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
-	struct zpdesc *zpdesc, *next;
+	struct zpdesc *zpdesc;
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
-	next = zpdesc = get_first_zpdesc(zspage);
-	do {
+	zpdesc = get_first_zpdesc(zspage);
+	if (get_next_zpdesc(zpdesc)) {
+		free_page_chain(zpdesc);
+	} else {
+		/* Single-page zspage, e.g. a huge object: nothing to batch */
 		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
-		next = get_next_zpdesc(zpdesc);
 		reset_zpdesc(zpdesc);
 		zpdesc_unlock(zpdesc);
 		zpdesc_dec_zone_page_state(zpdesc);
 		zpdesc_put(zpdesc);
-		zpdesc = next;
-	} while (zpdesc != NULL);
+	}
 
 	cache_free_zspage(zspage);
 }
-- 
2.56.1.750.gf70dc682cf-goog


