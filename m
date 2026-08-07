Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CB0C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17F66B007B; Fri,  7 Aug 2026 05:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8816B0088; Fri,  7 Aug 2026 05:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7E46B0093; Fri,  7 Aug 2026 05:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61F8F6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:21:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B05DA80243
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:21:13 +0000 (UTC)
X-FDA: 85073929626.22.E510F9A
Received: from mail-lr2-f10.google.com (mail-lr2-f10.google.com [74.125.230.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0FC21120002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:21:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E85bwhyH;
	spf=pass (imf29.hostedemail.com: domain of henry.elderman.edu@gmail.com designates 74.125.230.74 as permitted sender) smtp.mailfrom=henry.elderman.edu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786094472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Yg3vSIEOaMhQKfAW9Oze+MN/GQeddccWXpooaXprTM=;
	b=TaHUQ3uZhJFvl/S0VkmYp8YgzuFHTY/2dJ5rx1FqOJG6Ay6+hHbjhDzZDYvWA3n+p0Y93z
	gttChaaelm1XKi7hz44Ne7ahqMvkqC5NmNiOnlBJGkvwdXxteDQ0VZB74QtRl2xgRzIDyI
	iyJ8V0Blq76Su9iKSUzmts33s0MGglk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786094472;
	b=sXqT4DXCvlj46Wy/yRsI6BMuse0RT0qU/3Xu0ONpbVhO+P6Zo9RCA3VqgOIbmaufWlIG1d
	SXgyXVQI6uoRU2IqNar5TirtqySjsKAK9rcAijvL3joF60xXhK/ROwmWa9SfitX5zlE2zk
	t2SQ7tIqT2KTCkjI0zvemR0CILNlUZ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E85bwhyH;
	spf=pass (imf29.hostedemail.com: domain of henry.elderman.edu@gmail.com designates 74.125.230.74 as permitted sender) smtp.mailfrom=henry.elderman.edu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lr2-f10.google.com with SMTP id 38308e7fff4ca-39c7cc2339bso16565911fa.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 02:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786094470; x=1786699270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Yg3vSIEOaMhQKfAW9Oze+MN/GQeddccWXpooaXprTM=;
        b=E85bwhyHcMuaYYXYPoh/PBRQVLxsl5IrQQ8xLLWiBbxP07aglDWDg9ki3qM2a5vkXO
         6G4gj8p0Paf/v2xaSXtojHgCLKG8ZCF+F/iRBIuE15+jRAKyWsaUgl6TTpKDdzSUAGM2
         30MBE1+z2jk4xXDe7MaskGjbU8zQO/xISy/qd6sC14MVWK+17aCqOugohcTlqMFvq1ZS
         vG96l6g3KV5+daIRavnsg9kU62GNAwilDp8MLe2G7bLSIBfo+kVKnn2jM45vqI0eereA
         sHdW6QFcBwBt1aGlvdGhuiRfM/yNbAZVRgqxahh0upffYypmklBmJnyx23S5880cP+7Y
         vAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786094470; x=1786699270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Yg3vSIEOaMhQKfAW9Oze+MN/GQeddccWXpooaXprTM=;
        b=RyPCDkvv0jipSQzcwpidru2NkPG0nspeohGYRKoH/3FEXYYh2ORl5Zqel9dY3VfOIm
         zDYQABy+oJJyYLG9aK+KXs1sWK4Vj4y+FxiBfZqbhtWEdvLxUux/EqmDDB+O2uBVe7wC
         5nYntB3N0rylat7sHjFTugO/ae3d5fkpHPeKbMgVQMw2dWir0x46nPoINen6bRk+wuCw
         Y1h0YDH+shdCFLxhT3tl+iAWNU0SZ0Dc0h7qtabVuRKE1s5OUxaeOr4BlYyBCdCmxMs2
         hNvQJnOHfYYJKCwQfj7yA4K4x9v2N/U+LgaYDbBURHw9hhx/VxXIQ0HuuWGbdG3N1s6m
         cx5g==
X-Gm-Message-State: AOJu0YxyR0SKR5V9pmxCzAbVQgm/T2x49EYK7mus89A66SlkVndsNXAX
	moZkq8j75WvSVEuCOTyggP/KE/qdmS4hPMFVFXhAgQlhQz8mwslC+Bqy
X-Gm-Gg: AR+sD11vxv9VbaJ8NNpeAnrIvk/GrXvrG8Bi9lcS56vl2yufxrShXP2l62Ld0Ed2ei/
	Bbw+5IY0qx47wM61inFA1sviY3o/p18wBlZgb6nffmh6yAUSMKpTVPvW5ds9vK6+maQDYZDW7mG
	t+ffpBsRFJ7TVeCIryOpYq3h00DctYfBwWDXleaJZVDM1ctw9e7HD53luyWieHyr7hp6spFkqeI
	xBo8BnxB6DJ6KvDcmclL3dgBLuFwW1X/AL1XvH2iF2DNefJOwhbZVrp8hcoQSEkVYrYs84XKBuj
	XRQ+Xu3KqnV61yxxPxAqMD/uf7anFhQ86qoQjU6C4g88xN0QZzeRfbPozZeDbFytG3s3359NHXb
	VQqIkOolsIoF3pKumb08Faxu8Y5zHBHqYjJAnlSSxez99fCaOsMk+Ex5xFISNqiwnS1/1xV4pxZ
	txmv6EwyOHcQfxgZegaXaSy3wHMT+mji+/+jj/j4F4pvESOuC6v2qd6C1rcyyNx4HT
X-Received: by 2002:a2e:a802:0:b0:39f:c7f9:e4b4 with SMTP id 38308e7fff4ca-39fc7f9fd31mr16183341fa.26.1786094469958;
        Fri, 07 Aug 2026 02:21:09 -0700 (PDT)
Received: from kali ([95.191.20.153])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39fdda80e0dsm2431001fa.7.2026.08.07.02.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:21:09 -0700 (PDT)
From: Henry Elderman <henry.elderman.edu@gmail.com>
X-Google-Original-From: Henry Elderman <henry.elderman.edu+linux@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Henry Elderman <henry.elderman.edu+linux@gmail.com>
Subject: [PATCH] mm/execmem: fix fallback_end description in kernel-doc
Date: Fri,  7 Aug 2026 11:19:58 +0200
Message-ID: <20260807091958.4735-1-henry.elderman.edu+linux@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0FC21120002
X-Stat-Signature: wn9re4g5ae4h3bkryngqs4oduzdbbf9z
X-Rspam-User: 
X-HE-Tag: 1786094471-614809
X-HE-Meta: U2FsdGVkX1+fweHcrrTWWW/QacmIxDE9I0ECpTznkCHqifu7DtQ1d37b3XP1AWglpV47wGMxB52JEyZ1fRKf1LAxR1dCLEQyYUQzLJfOSiJ2NEB/s5qQ+RUU6bJ8HQEqMtwzssutnpHH/IdzgRL6MKlkO3TTA3uFGLJ/qA8Xtc+vlWLSJE9K2MEBqyTiN1b8wWAzSWGTeYuqL8Y6YpZQOLKSBbFH4Kg/3MVJbZYP6wcBXy9+bHbXAgfby/0p8ixdN4zL+JdPdHhMOFm2zmQSVJ2nBmBhMFdVpsGyLnL/TvrxqsLYW/rfaHFTRwb60LuZxQvTwcw47YKUhxd7kPwb0dHK6pGy5Q0Xbkkg2AdqC3ie8O5Cw0hrIgOF1dc1llpYE9Ke4HuThAFYGW7ljrwRN5l5KAwYPiqU0qELA5jQZB3fBkDejFFBPQ8/l3eyuBVTUWe/KvdXB7h4tqoIjRMYlk+sT8E5Ulwj0y0bw+ivmQBB1yGaK1G5BQ2zPIhuBX5iu4m9Vh8MOOV3C1/um7J6fDP1/Px6tGd+Vsch/iq5T0Xfi83DWmQfH+ElDGVJg5LYBYeCkA5BJjBYmX6rNpdWLu6+dvQrrF8PeJHzaO0j/SoPnQ9qgnwnmtQ4BlBZTNzPnBwuJv/1p2SEglDy7dvco4Vm94J1qHdwFGLfUI1vmLrVOON90LWy5Tnyb91NIr9lhJPPbsS1+eVIANk9SuClw4AkvjTdw2PyKP8xV1zTkh+fC+Qz3tMLM1Mr/PsDu5KTwMikvubTGwp8igutfDNkQfbTdPIrvBMc2pykzLZsyeSO3UcZjqTcjP/zHkwpFEc/cCthBF3XRmeSTR5bJPdqijOiEM7tI9Kkj6EUyCxoZNFGxMciDP4Y9e8R54BH5pqsRlljeK/l4O0GOa7ajPJGfM5Tg33LURVAk0hbIBsHu5uADeRSdcEMrGFFYFZgJw6v4eTNmder9hHGkrTXKba
 1u5XPSHM
 9gDDDlpbhsfDae2rVsqJMxCCZboFbW2gnoLtspZzQ5oCP/fvbb46W/CEaLC7By3r2rpZhGDwqPmo1toEF/eRe+QX6134UQ4IbID/4NxeGK40Bq5nSTpaW6r6z2A16KgeXip8YJqvCQ8GziqSsxAkRk8/INcnDnEbLUnCuou8gQtEJOPaTqiq3EUQtVVgtZd8R5APetjbDLBkGbZxJoREpqO2tNWOHlt/guLPjF6D+2dOML48m0grnuTYbCaT5eyDD+mGNhsvVCQ1wtShyiKBNWM545lmENaNTatJnHF8OcfXx4gAyl+3vdpCgFW+ErCcyZL7m4hd+zitB2ogXQPnEMkFb3nx6oWI3i6PwuT85lrem4ZaJHMjgTrduof/nxtg8jEBJU8mHnl3xYNeC9CjdRSNkUVd4bT0zroFf2fjvooGFr6duDskLmKx089ld1MaDRKExU0/ezavbKMZPNcB3Qby2vKLY/Q0rwagM2dpAWuNFSKlQUWmjGnRK6uE+i/Am8xo5PgeQgUAY707S5mc9LEIqc9q8/ipPsUPsJs2lsYFcluguZ8++zsp5+65Jj4JiMjgVBrgZ11lpVx1wKTb1jLNHiEqowjH68ivGOluTRBVO3YdkLt2dBF8ZLj4rWTo6hA5tF+MoN/lHTgoSpgSIZ3xlCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel-doc for struct execmem_range incorrectly describes @fallback_end
as "start". Correct it to "end".

Signed-off-by: Henry Elderman <henry.elderman.edu+linux@gmail.com>
---
 include/linux/execmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/execmem.h b/include/linux/execmem.h
index 7de229134..1bd34925d 100644
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -89,7 +89,7 @@ static inline int execmem_restore_rox(void *ptr, size_t size) { return 0; }
  * @end:	address space end (inclusive)
  * @fallback_start: start of the secondary address space range for fallback
  *                  allocations on architectures that require it
- * @fallback_end:   start of the secondary address space (inclusive)
+ * @fallback_end:   end of the secondary address space (inclusive)
  * @pgprot:	permissions for memory in this address space
  * @alignment:	alignment required for text allocations
  * @flags:	options for memory allocations for this range
-- 
2.51.0


