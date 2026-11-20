Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3E7606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=EDkEZQLv
Received: by kanga.kvack.org (Postfix)
	id 307596B069C; Thu, 19 Nov 2026 20:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DEDE6B0705; Thu, 19 Nov 2026 20:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF526B06F2; Thu, 19 Nov 2026 20:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7F9A6B0734
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:44:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46AC5A0D12
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:44:42 +0000 (UTC)
X-FDA: 85453803204.05.B28DC44
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 62F9140004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:44:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EDkEZQLv;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795139080;
	b=DQjk3BDqvQLYrf4isbGfQ2HIS2diBry83XzGcRHL4+bI1OWd7yRdoZtGvEyv8/qY9XIgvG
	mwPM5Umjd3b9DolEh0UT/+VNF8HdlYHJhcfzT0lFgdPe281GzpV/GdSW/cJKSE7cbHp396
	wGltdBvc7nYDZaoDA1XHICbxU9uicNE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795139080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaTemiemWt/IbS6IRMeW1LosBwcuSLA0MnPohXWgKzg=;
	b=UkJGtDSGgH6N6hBs0b35x4wiBvF4eUv2Vb8+UusUnlAeoF4VM+u0uRKAGJthhyYw/9R5sB
	WScZEkCcE7OBaF7vHXXSmDnHMp1/AvlruoTEM0Q2uRRXtRKvq6sq9gfAYWhVORqwiBCmGR
	Q902kEiaKqHIbMCDWt4My2/yuLvdxg8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EDkEZQLv;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f02ee04378so2911755ad.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795139079; x=1795743879; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jaTemiemWt/IbS6IRMeW1LosBwcuSLA0MnPohXWgKzg=;
        b=EDkEZQLvShu+5YP4qUQQk8SlOgP+xIC31vMTNFVWr9tY5jphHMglVpOnwvkQqRC55+
         slZvbMym7hR8CSZRouwWoX8krCNESbUABndAcH63y4+Ac/+USkZTiJ/I/ihSdDA1KVUx
         HI99SJihxo7z6ajnwQoju3GPi5/PF5S3IhjCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795139079; x=1795743879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jaTemiemWt/IbS6IRMeW1LosBwcuSLA0MnPohXWgKzg=;
        b=Ta6Ek80Imexgl9KNuUhakyMI5bz47n0mLN7AoZQpUxKo+KipsPlMD2Zxzs+nJkksSv
         IFWprfZjaAHAcksMSWH3VFyCOKM2ZVja4tXq0KenqCRVGap9EQq65VG5RxWey57Kd00l
         qJcVvateyMy0kd/Ru7nLxqbENtXFHvZeU00iN2hdKpoFNN6zQPixHGyMoSWLYC2bOLkC
         v6SEuYlfHOLoNsFdOLQ+TGhDLve1R/8OBXFwYLxPoR31tF+Tl/PqUcLJuhbR51WCY9No
         qtyhUvrMrhbnUJ1wLxvMQUgAg2NOQFDUO+jsZIimn2lEsgScAdN4EIsepT6VFRFH3Iu9
         n3Ow==
X-Forwarded-Encrypted: i=1; AL+hErH11jfseCW/EizCTxgJUwGLqgILqk4wKclBNDOqyGyBv9msb2aGQjqaa4rbdJ8AHj4sh7F4S1njZQ==@kvack.org
X-Gm-Message-State: APuU4Z95AmS6e9PT3hZoTMAX3+EDnUeSqJCTk6xMdWrQaOKkGh+eEoUj
	OK6G5AmYK4MMfpvvS/DDpkZfMnR/+YLBSKa/LJplpoAwm+eV/FS0orgUup5f8VLGXQ==
X-Gm-Gg: AZFdTZfQdDy0sQdAkzOIMEZyTogFHXEMMTLkBOklY6sQ7jxK6Uidc/7LCOq/ZZUtKE0
	5bNn+kmnT88tDL4pxBiNSuAH1Hsa4B/OgMfr/mT+EqUOskRmym6DzmhYzyb+mCcsVS/KzQIbhcs
	r8suVKpdkrseHnaOYnQk80rcBzeoVepsdDlYpjKi1dJKIag9Rz8CceFtiVOc0pZcF6Lr2s2oWDw
	otrdLjgYF6D/7aF2q91nWp82bMrNRN1JMZo8dcmFFD80Ni3MK38N5/0D9oeEB2leh3K5GjHmwRi
	gn2jGpE45TjcfyfsimgVvtYwvMcpbBbssMPrOGSp2m/2JqQH/P/Va5VFTt4n90aqdz0iScTTy0A
	vb5vYL6jBsCYgv5NhVC46LUpxnzfe4mzytSXUAjcxVwYIK0kINEgRpcp9hj30hmAZrjLfL9b+/Q
	hSaNpMgWQiomsJfBybHjJdWqUrq9C1Jv1EcIVCrwN48Q+0lariWxW0Pw0IcyPkHRjGU21xGAuUV
	Zof6kmzY9BgcaqPymgB/dyyymVZfTN2oUAZ0oiWg/My1E70dbjkkJ2n3EmkblTktdaguPF4oGCH
	exHiyDAWugWAgI2iCJCopzlgwuIKd1trlx5zZUUekiTds2HhnXuMiWJkxTFAKBP/crVLjr3uflS
	Dobpr7OyFcai7u9g=
X-Received: by 2002:a17:903:2f87:b0:2ef:df75:337b with SMTP id d9443c01a7336-2f03f246f17mr17438555ad.48.1795139079121;
        Thu, 19 Nov 2026 17:44:39 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:d5a5:46fe:fd42:7b73])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84294sm6793145ad.9.2026.11.19.17.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 17:44:38 -0800 (PST)
Date: Fri, 20 Nov 2026 10:44:31 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hongfeng Chen <chenhongfeng0212@gmail.com>, 
	Nhat Pham <nphamcs@gmail.com>, Hongfeng Chen <chenhongfeng0212@163.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Wenchao Hao <haowenchao22@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	Hongfeng Chen <hongfengchen@xiaomi.com>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu
 batches
Message-ID: <av-ltJooUJ0lqvqa@google.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
 <20261023123736.1542117-1-chenhongfeng0212@163.com>
 <CAKEwX=M4jTnxmq6cj115Gw4u5jdY7Ex65jPtVTEopW70jGzfuQ@mail.gmail.com>
 <20261109105957.2577351-1-chenhongfeng0212@gmail.com>
 <av6JvaCh358eSMCw@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av6JvaCh358eSMCw@google.com>
X-Rspam-User:
X-Stat-Signature: gzdj83y37mrj1ux751zdyw7dys79xmcu
X-Rspamd-Queue-Id: 62F9140004
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795139080-911481
X-HE-Meta: U2FsdGVkX18I0bf9EykWJKzZYs7gQnd9jZ3puCCs8h1/sH69WgJB1ArHTs2hkNJ7pzAA7b6d9ERNB7dPHl2jCVWSeaON2JSvN4kVX0rqaW9a6L5aL6+DJSbX+w+2XH4TOBjxJAOLPZ4Cx5BqTmbPBk0EICLKRNM3KcB1fr0rnyZ2vTPiCYC67SD4XZ1gtZ0cxNPIEcU6UwWXXt6Ko94DOn+3ckHc3Nsy47QQshXAwOcCoDbPkuFB0GRqgPmBHTquXsb8PcqFnTW7NSYsx/P7jWnNSXpNGSJ0t0T7dHPKkwtWTk/hmcZ0RSfQVqS3edsj2pcolXX8wP4qTxgpo8Wr61dGg4KQbaNIiqSa3FyXCeGRokOjbvcfGQAJTU1RQlP6hdNypSjiOGRiGifQXNlxFv7SpKA1vb8ewgfCZ+xGShEB0nz2rK0LZOW2rxNs/mz6mz7kPv1U96aYbK316XTcfxcO0ZXO0vVJk04a6SVPxlGKXcNJnwWyJSRvuS0aJd9dcZnitkcVu1WBWKKtfwN2GSspSUWWPqDAqXxPtatDpc+BxRPQB0i3LBo23kY3hKqvO3mw3l+ffBeXzaIY6yz5ghvszDyvj59ztuW3msoI3eldJZ5t4tJMm0kldsaPEhbFUSb5Mf+vuRqD1Vu4A2atwlmk4hY7yTinoJZ/gz/JauWPRTGhqfizJspO2U2R1X6XfhjLaVqPfTbXdcEWmRxeEDlXwDwuljWVR/bXQb+GVDGCWsgZXvRHVQWmjuSCVhshh/3V3emAVaUbSdbWL9I01CIlI5++7Vp+YJr3SxTgzd8Uj5z+LY2xs6LIZxbxDWwEhhgG8DUjc9RjCLYQlAWIEKVq/2a70hBlfN/ZqvXtnqDGeB3sgVeoxLiqQMNSwjyGEU9wV9OH5H4W7ElZW45s3xU/uROCet5vr7whQz87pmKQCJVeX31yyYgWagUW9Z+EjTtJQKMM8gg4KW2CPFe
 xpsH2aqu
 xfXu6QVCCg+cmvn7cW9LHKVDCYWskvC2KAkl3F2k/niUKqfUHUJj6J9MXsHQHDSS8W888V+XiUwnWP9eMmKOQMUle3pekQg3BD5K7Y+kHvZbPXpcwv8/5aTzIiL/S/o48T1tQj2AfkGJzgQWplfI+gUTLqMiKpGvi+oIswCmhK/XviAk8NLssKrajY1AS/EHAIzgdRawxniVi6/c6fFV6aEStWyovc47V7tszoI5q6CGc+ehKXKbl2dvnYMpo0GGjDisZp9gGJ+26rLFTV7FtcyMeO8/uAHu38xELOqVgdQKMWBVlLp763y93TasUUzvUDoqsNkVUHpOo7wtMoHNuV6Tr8p1PZaCZ3LP2lzOAcl+pJfi7KHCmsIC0p1WuFl10XN6cH5kiTkXdZtyu50GO9mLCDnM+VDGK7gdgKk1FXrQd5XrdaPEWcuLJrEdVNTyH2U0OOh03nNoX2P6ugSzfTxnahzVsxJQi48OfaCsZGR2ANclsjuEgO7WHj1aLeyAWuvStSlQGZtcFyib+E15NGeE7rNQrnJ8qKnsIMEozdUscc+UXld3vI4dhseUXNO58otDqIRm+BJfFz6dj0a4bY+EGJCssQ1JhDHW56T80G4St1Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/19 14:35), Sergey Senozhatsky wrote:
> On (26/11/09 18:59), Hongfeng Chen wrote:
> > On Fri, Oct 23, 2026 at 11:19 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > > Is there any more juice we can squeeze from zsmalloc in that case?
> > >
> > > It would be nice if you can perf zsmalloc freeing. And yeah, maybe we
> > > can't optimize any further, but let's eliminate that first before we
> > > rely on offloading.
> > 
> > Here is the perf breakdown of the free path:
> > 
> > zram:
> > 
> >   __swap_cluster_free_entries        90.28%
> >     zram_slot_free_notify            86.01%
> >       slot_free                      74.15%
> >         zs_free                      56.01%
> >           __free_frozen_pages        19.85%
> >           kmem_cache_free            10.15%
> >           _raw_spin_lock              5.53%
> >           fix_fullness_group          3.31%
> >           dec_zone_page_state         2.43%
> >           obj_free                    2.17%
> >           trylock_zspage              2.12%
> 
> We removed one of kmem_cache_free() from zs_free() [1].
> 
> [1] https://lore.kernel.org/linux-kernel/20261110054836.1515030-1-senozhatsky@chromium.org

I suppose we can batch some operations in zs_free(), something like
this:

---

 mm/zsmalloc.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 4a6ec43f418b..e0083962e4d3 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -43,6 +43,7 @@
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
+#include <linux/folio_batch.h>
 #include <linux/workqueue.h>
 #include "zpdesc.h"
 
@@ -891,21 +892,39 @@ static int trylock_zspage(struct zspage *zspage)
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
+	struct folio_batch fbatch;
+	struct zone *zone = NULL;
+	int nr = 0;
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
+	BUILD_BUG_ON(ZS_MAX_PAGES_PER_ZSPAGE > FOLIO_BATCH_SIZE);
 
+	folio_batch_init(&fbatch);
 	next = zpdesc = get_first_zpdesc(zspage);
 	do {
 		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
 		next = get_next_zpdesc(zpdesc);
 		reset_zpdesc(zpdesc);
 		zpdesc_unlock(zpdesc);
-		zpdesc_dec_zone_page_state(zpdesc);
-		zpdesc_put(zpdesc);
+
+		/* NR_ZSPAGES is per zone: one update per run of same-zone pages */
+		if (zpdesc_zone(zpdesc) != zone) {
+			if (nr)
+				mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+			zone = zpdesc_zone(zpdesc);
+			nr = 0;
+		}
+		nr++;
+
+		/* Free all pages of the zspage in one go, see folios_put() */
+		folio_batch_add(&fbatch, zpdesc_folio(zpdesc));
 		zpdesc = next;
 	} while (zpdesc != NULL);
 
+	mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+	folios_put(&fbatch);
+
 	cache_free_zspage(zspage);
 }
 
-- 
2.56.1.750.gf70dc682cf-goog


