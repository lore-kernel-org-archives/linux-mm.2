Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A192A606B462
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YJSsYMqE
Received: by kanga.kvack.org (Postfix)
	id 91A486B05BD; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2846B05BF; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76AC16B05BE; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8656B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1840A0225
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:34 +0000 (UTC)
X-FDA: 85421907228.13.721BC58
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0C47A1A000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YJSsYMqE;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379653;
	b=P2wMdInh8ZXG8YTA3u1UxUDYAnvoPREwmjB1EELmRkwUMzaJtUlYw3p0H5auBIpzKOCos0
	oxaH3Xwm3QO4Tcg47Nq7V4k2SGxIYWZWG00HqrlOBy319uumQKnZAL4HHlVVTbRwTUdHT8
	hxowlqHyhQXfVMbX2iq4Z2bwLrS1Fbo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YJSsYMqE;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxBgELUdpwYR0KSdpANT2wdlj1GRYG+jNYkJLmCk2gg=;
	b=jj0LWeJIC9utBuwx17a2MxYu2b+h6qBZkPMX1Ajbjf9tFzv8kPKlUPKDzrvKDodYULgYEx
	QNLUVlNcDMASivmWuoyAnp04OwOkOg1okIEgx3mCI8vb2t/jAEbAUwSsBTM9If/LdYHPF5
	fNa0kWEpxQ1spFuyn/kwhBrTedlAlOo=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so1790020a91.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379652; x=1794984452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FxBgELUdpwYR0KSdpANT2wdlj1GRYG+jNYkJLmCk2gg=;
        b=YJSsYMqEqsTcyfJnBGF7lKms+UYDQpHWBPIlnBgECAFzBNhNqYnizXR5EqbvyGpaFE
         mMH28lmPNn1xVmJikX/nF/cMgJw7ZG/Oa1PxahSp0Q3Z5mvVwjuuUjuOt67rp0wH3k/e
         a/urWcNyrVW9CGU/LC9A42wBW4AktSNLTibBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379652; x=1794984452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FxBgELUdpwYR0KSdpANT2wdlj1GRYG+jNYkJLmCk2gg=;
        b=Z9RYPVwsfxapAbUHeG0IbtDTKHsmPCqoar8C9rFD2KZnkhSIxVAtRy9+z7ub6ZQXqu
         bRLV7I5b/vPDA5ROj82t1qOMGj9Dz4Zrd6PXLRFjZeWR4YBFpULL7ehr84C2qUhFu5Gm
         a4cPUEP3RGMhz4qBrp7g40rP8Vo2C0jXDdAtlJBIB+tzqmIn0fECyt9yqdffvB9dJMqU
         j5dedqX/575tOiBIdudb2x3VKQqvQ4rMjAJnVjvfcieNNlqB9uUmqcbDKsPt0lj1ypga
         qWET6mRUPePCfdIrK1b/XaGO981vGHYr7nYsNLDULWCreRinhMD/F+rxa3nIAYmc+RUY
         kVNw==
X-Forwarded-Encrypted: i=1; AL+hErFtZGYzobf5dNhD0bGco3dwwKE6fm4nAWbQp/FRlmdalnmRIy3uhM3tCGQfrAYfRhPsEYb8cxAYug==@kvack.org
X-Gm-Message-State: APuU4Z+fOjOPLmPx8Hh6abzP5sHOJvXPv4Ea3IlhmB7f/pUnBnBGbsI0
	NJ0AGpPru3dWuShf4A/hZEEZ5EsI/HYv39ULv518GFUBmRg6vupJuC32Yno83McNNA==
X-Gm-Gg: AYBFou1MgIGGR/6TcMQ1/2YKdldjnSEkRoqbMn9ZDeaRywAHIpf17C0nh5iktgN052e
	vPlCXgqSVUHQAXYnGGlEADBsxtvNg2pmFfVfvYnCr6FoG6tYz9nXGYITM2+6OwClvk4HeD5Mh/4
	I6B/MhldtvOXIbgC3YQQ+vV9i+pvXv/FCfo01WzuCDN/c/FTiXW8PSfKu/gCcWyia7/7MHfqjfU
	kF1X0Uv6imRZyh1O5jGBETWgtQ3kyq9DL8ISMWmEvlypyoH0RMAY0Uv5O9S6MNLu+YqzQRUUB7P
	Wq9lMdPI7KJgNId34y/qXRx4TiGjxLib8MdFktJLjx5eGLr2OckZkJAHpIfJJU/Y6HBE7NAH1nd
	eT3EMyqncDXAnecRylSPJp+8UR8xXvWcuqL/q0jkd0AY9ozhj+zEIh93egoNsoMUWObsA5qzjZK
	FBFWlF/sxDAdvNhxecl0+0IbrMzogXoM6FhbOzMN+RsAwXzHuVFyWXj4OtrY+UEFaBFnnMfR/ue
	c62K627U7ZxPfbKDOunR9TN4GTzJrdvM1JCbM+xqSFIbCm6qcL3cGuWTZbRS75vMwVFDvdbWHtY
	c8z6aRxiWoqTWtNxr+MwLUYQU5U5kHfSx3vIc2M0d1ZKlPBV9+xLp670X953Hmqk23xUCYvBJub
	3d0QU1qXCbSAOxRRarczLYb0faKWMlIF5MM0RFF0Y
X-Received: by 2002:a17:90b:1d4e:b0:3a0:9c9d:eb18 with SMTP id 98e67ed59e1d1-3b182f1903cmr1771365a91.54.1794379651615;
        Tue, 10 Nov 2026 22:47:31 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:31 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 06/11] zram: allocate zsmalloc object under slot lock
Date: Wed, 11 Nov 2026 15:46:29 +0900
Message-ID: <20261111064707.2568433-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0C47A1A000B
X-Stat-Signature: q9ugtmwpn7r3w439jpkbgmfdj5syxzss
X-Rspam-User: 
X-HE-Tag: 1794379652-823947
X-HE-Meta: U2FsdGVkX1+/YPNi+TXeU0+tPeW2wKwuqNKvPlwFkbCg7xQiVoX9naJtoVUZHLPP8/9rcK+no2qMZ31KRvzyhrEfqoWUnHMYlhlwGpo08EKnHFOxpi/2Am4wSWXolgebI4bTSBgo5gWBhzcoColRADp2HxYG+93ZmG25ADBj4ax6LQwfG2rsKGAIlF2rXlUpAD9eszdGMmYoCs2bMJXLo2VJXEaCxjokSG2McVPzpJ47U1qhSgCOmekmVBLA1tmo9la/SLaZe2nmo1PK8vHRq+v5X2Q3kLHJI8opamTBSnKj5BKLkQhq9uZtrMpcbunW7rEvukD6+R1dvMRVrSjKIL45dclgaHkO+0ioI+TuNLUWsj4Vaas4pcjuS0qAQiXL5G5Id8h9DrkgHO+zW5AghuKeEkLUreJsqNEw7OjCHLWRnDqWfbzHQsOdlow5v/kgi4FlxM0WfbraTjAgbBbB4TIPJ0rrXrYUixR0gjWcQG7nt+gZJ2ywQYqej4DvOXQXtanFPEUTKkokz5IdCByI8uenJ0fufYuSYWEMjBHhVxfPP1/pX4z80MkNTe0/sw0YgFi/a0S/gMULeM1SwJDP336xTtAvOquSTKAlnC4gqUP9IFE6rI+KMJxRcmWGhVNuPqvMRJrvdUFqYfrJxjmL26HbnkqttNdHKrYvvwWWAyPMkhrA77TxvKLaNAQwuyBEhIhY6fObfv0AXPoQiu7LdgUcN+4FUOgT0caJfjzL81PpQVvVU2Umhwr2U33ZFurCzRrdtRdRwQvVqstDKB5Zz8tedxAvfYHSjTPIqDEvdPYP3Wv6TvS7acBcpOFVZ2FF+f9qNHpf+Toz7SQnD/xwYpTnelnuS3lArA/HTiILnr0wUloR10ZRMb3YCxm0xFKs14sNMetGrdJThZ1d8dQagcRdfjDGRzAvoIPre+93pZVIWP/9P8TD27/jP5xTuR9IMbpA2t8D9Q/bH9Fo0p9
 uLifggAG
 mbUUvqKPDx280j2LVs0MRDA6qskyNcX/x43jISxmLylrSik+f1243+YJ6oiHqsdfraeUKLR3TcputcyIggZ+gYYbU7Un4VXUbyePnvg/9Oo5bF+LSCnXsQ+cvmCHD2r67ZiYmErV1D7h+Y0S8YMg5mebyJCSsue6Ge6XmYAPlefIjTMq08kCTpWS6d0scnWx6NU0zGep1PmvsCzKLG4TfgsVDqcMZ1LewRc4KUKLZ7IFN5UX2sE7qlXSaMLNaPFLKz67pC/I4e1J2VB4ysgocyoWXI8Sy/CpP6xOQYxc8ASPvGS+MVXxTyNj63R8nNddXLf7BKQqE0E3BqGlJMdfDC0sS7sPEAi2UE7hv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_write_page() and write_incompressible_page() allocate and
write zsmalloc object first and take slot lock only to free the
old slot data and set the new handle.  A subsequent patch makes
zsmalloc store object location directly in zram table entry, so
we need to free the slot before we allocate a new object for it.

Free the slot and allocate the object under slot lock.
recompress_slot() already allocates objects under it, and
GFP_NOIO reclaim cannot re-enter zram write path.

mem_limit is checked before slot_free() (previous patch), so hitting
the limit keeps the old slot data.  zs_malloc() can still fail after
slot_free(), e.g. when we write from reclaim (PF_MEMALLOC), which is
swap-out, so the old slot data (if any) is stale anyway, or when the
writer is an OOM victim that has no reserves left.  The slot is left
empty then, matching standard block write-failure semantics.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 74e02cf4f53d..dbcbc267344e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2261,11 +2261,15 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	struct zs_handle *handle;
 	void *src;
 
+	slot_lock(zram, index);
+	slot_free(zram, index);
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		slot_unlock(zram, index);
 		return PTR_ERR(handle);
+	}
 
 	update_used_max(zram);
 
@@ -2273,8 +2277,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
 	kunmap_local(src);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
@@ -2326,11 +2328,14 @@ static int zram_write_page(struct zram *zram, struct page *page,
 		return write_incompressible_page(zram, page, index);
 	}
 
+	slot_lock(zram, index);
+	slot_free(zram, index);
 	handle = zs_malloc(zram->mem_pool, comp_len,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
 	if (IS_ERR(handle)) {
 		zcomp_cstrm_put(zstrm);
+		slot_unlock(zram, index);
 		return PTR_ERR(handle);
 	}
 
@@ -2339,8 +2344,6 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_cstrm_put(zstrm);
 
-	slot_lock(zram, index);
-	slot_free(zram, index);
 	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
-- 
2.56.0.542.g3ef89b7020-goog


