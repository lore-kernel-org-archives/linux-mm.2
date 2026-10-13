Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59101CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AA76B009E; Mon, 12 Oct 2026 23:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C256B009F; Mon, 12 Oct 2026 23:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29C46B00A0; Mon, 12 Oct 2026 23:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 976096B009E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DFE1C0973
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:30 +0000 (UTC)
X-FDA: 85316230860.01.8383A78
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id B479DC0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Vd11mlnS;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863548;
	b=XX4s11wEb/sng28/cVvNkEtrVl2pJQRlACy7Sq8JTWu2ORWxICmSaccVMxomI8aFLmQaSq
	h5MhFWVNU+uHdJxkpqq6JCD0a1P0fGI4Xlykvd6oSs/xCJJnk9bRxQa3zzbFIkkb7X/jMb
	Nl2pnaKyfLvMP1tM/SvfI5j3aPYzNws=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Vd11mlnS;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFX4FeTrLTacTalFto0lbFyZ1pMwSeqR4eMyIxwMMBg=;
	b=PvKDZKj3dgx/TSycUf9kZikYjqWS3ZLoB7sCW0P5VoVQHy7Q5yR54XT1VBK22u0neb/RG5
	FVRmR5LTGh2R87DzBQrWIPqbi7hgGxQKfhOKynYTDPjSJ6Wxhgr3G9eqZltjih5OqHoE6M
	bMm6El4ySRGqD5JYBtY7VP8N/lRqvNc=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-86aecf49833so1174929b3a.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863548; x=1792468348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RFX4FeTrLTacTalFto0lbFyZ1pMwSeqR4eMyIxwMMBg=;
        b=Vd11mlnSJCVQkUzrRkZLrHT0zPdgvnzOkg8gu6S8eH2VYTyl8Q5H4hCYaXg556SeWB
         Up5oa36cMBR38FiQ8XdKA9Sa1bXbwVZ45+NiewKWyQQalzaUfDmbOxWw0NItIz1uoDLI
         NBY+G+swBJujvxJrrEhGZ5ESQsGnXqApgpf60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863548; x=1792468348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RFX4FeTrLTacTalFto0lbFyZ1pMwSeqR4eMyIxwMMBg=;
        b=YjjMODc8FOMb1SpA6DZDvu4FiLFbRMXd8px6lwBvEuvySHc4ZFVlQVoWjVKMe699Io
         +47fNxIrUhNQHvl+bItCEL0y5ymsEhWjgXnMHYk+VVYaba8lM6sXAjV8omuCn4eDJhVz
         m5Rp9gxJoLoGQZhxR3OhgfZhKbE3+kLjagRbuTKwpQoq/3TDcuIgCDCv3HX5uepbQfzJ
         Opx3QDuGwD/A07LYElktiDW2PZ1qAUoMVnwB8R/LYF5WzaAvBO7i0mL+lw17d92Y8meX
         0DFNR7m3DbHLW28zbJkV241NZWsjaHsQ+3bHDfBtS4CBULAUEDU680akZ7cXRXlojdUc
         80GA==
X-Forwarded-Encrypted: i=1; AKwUvBzb9BVKE4TGG2m5MHi7A8+Kxdi2QKNYcIj7ixCiiPb1Xw1m9Ik8VlLSixSdJ7gJHmBKsrVGRnDnjQ==@kvack.org
X-Gm-Message-State: AFq9FYIehkSgzNT2fGyD3C6XXzvTEM1mWEzdWPCWhOE26N2QB+o32CTk
	pzRiOOW8cgadsOoXXQlKK20t+PUlVgRkY3ML75hHe4r1aTwYjeLOVHcIUtNvrbB+wg==
X-Gm-Gg: AYBFou16zBFaxxk9VIDwcg11NYT/igc68ss5rrHEUKFaPgFM5qhLHrgljxjwrSa+KJC
	/gqeDGp43aqVr+5JiJnJZdchgfFjLldOWK5I+vnbodab23Jc5RL3naErfVAqUpIRI0oF5inzTOy
	PWCU6D+XRXxS/dzlMOBAa4DGhGrekiGLtknrlWUZlT/z98RGMOvjMj1XqFVLyPzV++27slteL7F
	nMqdNiDxVVTU4/qCPZ98+92xg4+aGzUlwFg+bW8qvkhEiKbPNDuqoVOTYjT0FxiZNz+h6s7phOP
	geyPcISZTwoBp2FEbY0I/9KJO/ve12Ri40lYpd1bm6wqRrwekkCI3x2QXp4FuuyNIkMcwZkVHPr
	dzTXY/0KAncU/rUM6MDdfKI63x3mp7jJfbwJ8Kdad4y2hIj2Rp6gpEpuwmhzO24g9ebGVMosf5+
	Dqd0dL6t41VwMFgRnemeXU/ZyyxsKrDseLMVrEoXFsdhEZv1gBa7z+tQF6Hf3Ha654aaHWlAla7
	SFC49tGMu07KO2Ha77gIuQ0v09/g/l4VbuN+nb9T6G19CrzAZlJZAvl+dXNjg==
X-Received: by 2002:a05:6a00:3d49:b0:891:e380:3d03 with SMTP id d2e1a72fcca58-896a29105e5mr7734654b3a.28.1791863547666;
        Mon, 12 Oct 2026 20:52:27 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:27 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 07/11] zram: zstd: do not use kvzalloc() for zstd allocations
Date: Tue, 13 Oct 2026 12:50:54 +0900
Message-ID: <20261013035201.2809924-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rw1sz11j1q9sdcxqhy4ufyacq59friqg
X-Rspamd-Queue-Id: B479DC0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791863548-202511
X-HE-Meta: U2FsdGVkX19P8kWnQ0WtxAFaBGuZ7fWQTOsOY5NG9cqDt+GD7a4GxMFctXufWwmTd7yQA56XUUpSQ5H80dXPbg5SqnCBTEGEZNayeJekypBXSBTF7zUrpwKYI6DAmZx9bQa067ePAVBMrpNDnR6yFB0T7pKJo1JlgJbmot7bLrT3jw57PnKEHi27R4VrrIdn9e6cUwWfK7yU6AO2WANttb87ACoyuQ0M6Ewg3LW2x1NkSD77f5gPmIOuHRpLcNBMjMUCvvTyEu1V/C4hwh/1Sd0aLxhQMqskLRKE3HcDXegQ5p9ASh4beEzj9FVpeXQhVgRdiNZ++URt9gk9Xkg5q6KWQrWhzR7ZlCAZGSvzPywXpGNRKbF7yS39uXDqnb4HpGr0H7nyaFXJ5LtokSdBdWJ932Izs/by0NeAeCrNTIBzmqxRmu182D5hsxurr85yrFyQrdOcgrsa5aqfK0bXnIbCu85S0DS25DzD/IVluCCl/EILMMFoYxHqMDupkVhMpE4wkxHQGk047cGjkgTRDU8gHZGZFxRaaEzdieLCsiqV1vxfauKD4Cjo66D4yTJEEWb+kj6VBvED5yzOdSHso+gFMwFrDxKoDU2sHsjwvb/gcsGF4+xs0jRIpIcIDyFAdpbJZz/rnOLzVWW1io+WTEkvATmKAKOldlMJx0zpjFD78Ql3hmtSnpyo6np1u1Eurj+6DoO1feg1hi2FFwWXly3y6OrRsHeDDR3LJr0JoeTOonzY9nnlaKCQpEUAFoHvjgWPCcRN7gnrjDZwJqVTGC+BBtV+qpwdPU3P8I7/Mf9qYOVdZVa94towyckgFOs47YnLWvqDyo5DA9bd2LVJUtyIe5hSCFxChA7gnXbK5QJ9QohMykMvz2F2E/57BJH5dxzjsvt+XiwK3JucVAFJJOiL6AP29diUb8quY9DoxQZ/LZV1SmLV8+2RpUqs+IdIL3wu3GrII/wONJ9miI3
 2SrAAmMB
 5qbwhZKZsQ5tyoVEMFIZDuhT8x5Th+wuPQzsJGFQ0IVqIcawmweXN3muDYycxnyLjhmB5BlYjTLfb4E0UttcZJES83c/cA+SSzFv4NVvehOHCyd8Ax2BjyXBwaTxc2Ep523p193zUVmRXHSPiv5Ht+v5Pdpwh+mf/90zR/swB2T91g/DHF765m1cv96FQJT4Uw9zV7agjuvZb1fU6iDFZ8BzD3THUKsfv5BDKkVhl1eoY51zTNspl+KJoC4tWRMRt8YgnnG8rg0xbjPf0CMyECqXioMSRwABHzCiG06Dv2AUfrBXF2mrvMozqbKVceRmeHVtWkpIc2ijrVrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a dictionary is configured, zstd allocates all of its memory (C/D
dictionaries, compression and decompression contexts and compression
workspaces) via zstd_custom_alloc().  zstd_custom_alloc() uses
kvzalloc(), which falls back to vmalloc() only when kmalloc() fails,
and kmalloc() rounds such sizes up to a power-of-two number of pages.

For example, on x86_64 with a 110K dictionary, switching from
kvzalloc() to __vmalloc() reduces allocations from:
- CDict (level 3):            512 KB -> 400 KB
- CDict (levels 12+):        2048 KB -> 1552 KB
- DCtx (per-CPU):             128 KB -> 96 KB
- CCtx workspace (level 3):   128 KB -> 84 KB (per-CPU)
- CCtx workspace (level 14+): 1024 KB -> 764 KB (per-CPU)

Use __vmalloc() for allocations larger than PAGE_SIZE (and kzalloc()
for smaller ones), which is also how zram allocates zstd workspaces
when no dictionary is configured.  zstd_custom_free() already uses
kvfree(), which handles both.

Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index b367049f131d..7a8b5ff186f2 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -26,10 +26,17 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
+ *
+ * zstd allocations (C/D dictionaries and contexts) are large and
+ * long-lived.  Don't use kvzalloc() for them: when enough physically
+ * contiguous memory is available it serves them from kmalloc(), which
+ * rounds them up to a power-of-two number of pages.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (size <= PAGE_SIZE)
+		return kzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	return __vmalloc(size, GFP_NOIO | __GFP_NOWARN | __GFP_ZERO);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
-- 
2.56.0.385.gd3acb90ef8-goog


