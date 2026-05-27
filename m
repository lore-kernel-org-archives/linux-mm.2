Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BC9BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 04:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DD56B0005; Wed, 27 May 2026 00:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E8D6B008A; Wed, 27 May 2026 00:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D846B008C; Wed, 27 May 2026 00:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A46D6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 00:49:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F1F040311
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:49:32 +0000 (UTC)
X-FDA: 84811971384.09.F55E173
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 99B5110000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:49:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rBZdOWez;
	spf=pass (imf14.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779857370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DtWoDaWr1fAVpczHdMCywjJZwwAcuUUA2TuUPYOhsgk=;
	b=ZTkeLY9Av33vBnTt9tITpI4Pki8onT8hI8Up4ElhemVozmUaOpQZ5xRWgmrt5+/d3Nxbjj
	RPblQbywOks+H6pEIwAkmXePctjD9gzfppTjcwu82bRy7qh189Jo2RAnzcQrzqN3uL4ZJM
	ShWIu50m+ZnQY1DCXNAwjA0PcAZ/cds=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rBZdOWez;
	spf=pass (imf14.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779857370; a=rsa-sha256;
	cv=none;
	b=ixW1vO+/PvlSvctJXPH2rGi+uIvfjQfXCWcq0zyV2tcRUew5O+R3JBUnuzA9RivcHpDzf8
	n9eo/YvAmBo39ytILwdYtneuywYwmTleNTqt6Puy+xnNuf0uRRPvnhxIDG2vQJODIfg+mP
	6Be3neZ3BhlaY2gn6I3aATQEX2fKdzw=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ba4efedbeaso85341515ad.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 21:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779857369; x=1780462169; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DtWoDaWr1fAVpczHdMCywjJZwwAcuUUA2TuUPYOhsgk=;
        b=rBZdOWez5mFEqleNHT+czVm08jhSSf+OTiSarKdYB4jp2rtBBdNLPzbWeZCp0m13eh
         6xDozkOIjwBQruZCoMCp7LXpxIgoyiSqI2DEUW3ihP5JhAf0zSFjXm+D2UQHDsmtfLAi
         cZZG+f/xs4DXLQ5vtxIkEm1LSnOFPeR9CfmvSBRHbDCMeUTmGWTmMlcI2kot1h32Vlsr
         51hBubyvXTNjTzi3PZVuHX0PJZIsXtPBUeaX2tNSeRDRza628GIli4+7jskasT4KnUfR
         2IbEBuLzyoLaY0LInXy4O6IDOyaXbVg0cknc2DbiJpO8KRTSLqUElMa5l2x4mTlFa2cH
         mTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779857369; x=1780462169;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtWoDaWr1fAVpczHdMCywjJZwwAcuUUA2TuUPYOhsgk=;
        b=eBcXIFsoIec3KFs6ctzMQtsY0GR8biv5Gnom41Llmhctr7tuOuS4EoFsn1XOkwgb4z
         GXC1xSptuEfwZ/lXzzgGhbZnCoqahRQo7f0vRi6WOgNoyTDjxAHdNtvKZsD1Y7DFIP49
         0odkM/s/fQPm/5O1FHZHDb4gpg6zU/txbb2XeU5nw5oWgMUSC0AZZ6PWV5xPkPHC8T0L
         VjcR8ahtDzura5zqBiMSFnShGY3G+U32hy+yyX2VWJPnwLRxAHw/IwObyrYzjtodomKv
         yzJV3i3/t3TRldqiwkPIlx8KXhm75GTP85yhaDhOQF9DwvSFA8IPIPLvqT1RcoeuU6fN
         YALA==
X-Forwarded-Encrypted: i=1; AFNElJ/LZm5pE4GsRE7NW6OQAR3TTrg5yikokpgQkiwQnNoY2a+MD5hAZuK7uIwXEPCGUvqY7iM4IMYc7A==@kvack.org
X-Gm-Message-State: AOJu0Yx1/UXL9HgiVyv7vYUngI5I47hYIw3D8h1JlyUU6N2gAsKk7uWH
	JKDW86MB4K5Wh0eQ+urGFmdfUEebPS9qn88Au7QyVVouEsswtF/tNn1c
X-Gm-Gg: Acq92OEaXjoEVMSz0QOjrlCGtdQtNE6JBZjJbE9mKeEUz6e3BCVPr8KKaybxQA52d8c
	nqSwJpTnHRfYgQpbiVFoj8wa04CAYaLUQkoPlnbmc8lPMgw8cMp21lzy+3AMVCask5AaAxQATb2
	2mAPLqTox7LkIwIppXVB7XQUZm1TiDMj5T+pmP/NYCWTuGGA80iJff7QfaeREDLVQkBm1OTbFs/
	yLL4uMbSMw3MCyEtHZKlz1efqFTephgt26ig0YIoH/pUV8h34r6wh68l+n57CuXVDd2XRhTmjQ5
	taW9IUpTZNBEwzKjqXMdZu2kHBD1zNip/25h0oGeTAzyuhljO/wFbTR/jbweosWuejXZibbX/7s
	sbm/zHIc9y2K+2srq+GtpZX7NVNWq7jGtyrG/9E70p8aBFPGEK/Pdz+uQa5EN0RoppfQuB6edbB
	rm0Soqpo384xxDzyE/1ny5z47tHu1MFBWGSg==
X-Received: by 2002:a17:903:1a2b:b0:2bd:ef12:14d6 with SMTP id d9443c01a7336-2beb06cfc33mr237395755ad.34.1779857369510;
        Tue, 26 May 2026 21:49:29 -0700 (PDT)
Received: from [127.0.0.1] ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58dba7bsm135704105ad.66.2026.05.26.21.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 21:49:28 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
Subject: [PATCH v2 0/2] zram: fix UAF in zram_bvec_write_partial() and drop
 dead bio plumbing
Date: Wed, 27 May 2026 12:49:23 +0800
Message-Id: <20260527-zram-v2-0-2fb84b054b5c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANN3FmoC/zXMQQ7CIBCF4as0sxYDE0ujK+9hugAc2kmkGDBEb
 bi7WOPyf3n5VsiUmDKcuhUSFc4clxa468DNZplI8LU1oEQte9TinUwQVqoD9nYg7TS06z2R5+f
 GXMbWM+dHTK9NLeq7/oHhBxQllHCkjLNovfHH8xQM3/YuBhhrrR8t8VD0mAAAAA==
X-Change-ID: 20260526-zram-b01425b7e6c6
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cunlong Li <shenxiaogll@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779857366; l=1050;
 i=shenxiaogll@gmail.com; s=20260517; h=from:subject:message-id;
 bh=MWXxtYUJHKCFAwaYN7w+xkzs9tEH+b5cbl78IjB6IzQ=;
 b=awVJ3Reynx/9qKcpkry8pPVO6WO/SxEC+sbgYlB/AXjE7b9wokupd/75eZl2DJa0r9X5EKc89
 efYJzuJECK2DHFqkFpgYD8dIqvHv2XslkX3RsXOW5OSU8b65Aik3V+A
X-Developer-Key: i=shenxiaogll@gmail.com; a=ed25519;
 pk=SKFifnqPdsvsjuhUiq+Y9vtCdhyZ/LrRcfYn8eRq6AE=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99B5110000B
X-Stat-Signature: f6p9q9yapn6scq3whddr9xng9nm4zz48
X-HE-Tag: 1779857370-362839
X-HE-Meta: U2FsdGVkX1/8tiOuFJFF1VNPii7oHylwVeKlTkUFjd/LOo0ViNqPjH3WHOpzuG5Z1jF27qcTsWHJbqwHaQfFzxObaxGZ+ia6Yqs5YtnO0WEWE6E1d8xR65GmjUyNrS4GDSmoPSXSeXAt50kPsUpTxr5gY+q/iHXZ7Tr3u8fQwqBruU9VEXqTnzSg2+H28GcO5YxPSfAzfEGMQo4VB4im7jClO64uyJExEmWyUtlT6OUfo52CDwZGQMtAcbr4v7vpJ4Nb3ErakzXpDrocsIFuoebgUDsC6hW+C9ftO7RLBNuywGUVpHb2wQDsVX5dWGMZuPB1L8+xV/JPKXDn/GaoPbCi0Pwo54+PhuVNZ6PY3PrRQepEt1hqyse8dYAAsxJKvzdwJJ4FjhPyOpBVBZTIDxRSW5mmpvCrbCh444LTb5GoQqhfExgkajJgx/dfJAfp4KJWSxxClrKPhmz8DCVb7XN67sI22UMPCTwwE0I6BhQnPiPzC190CUj4ZEQJipsHWQG2O5/FVDQ+YWuKXwPFnaSXLsVXA90jYlqrvAaRVi9pJY08I7kFCGORqdBzBvnb7EOM3/zH3nSb8be9cFJ5na5xj23WeD2U9rhcc7HIu8CGSByf1gUUgi+bwoDWLck4xPQPV7O2tXdueXXIDkzTgu1Y0SZxtWcy25q9zUYFHiaN4n0qbgbDOwBz8V0L0ZXMvAuGBE2tHkPLgTh4I59B+WezL3eOljHyLulEdzNWxtzSWurpplD/9w+OkHPZeC1VqMZ/0N898x6PDKcrypmkIheai0VVNC3G0M3rIGEwGY839vEsaLO1bUSqOV7d/FEJXkykM8VM2rG1y2krJKDbLw46jDlP0UM+SAz5/cn39Vq0Ctku4UHInuQEdjYMeOabMZgmqKTQEvf2R5scn4G9E4dFZpQqVEIFQ322IrML1ipCXHxJjstXlrOvH9iRyBmTCJqLx4Hn0zCM6f4hJUP
 TcjTQS5i
 muFCF/MblmeziaC6eNPGFBi0CmhCyGPR7g/aJRhTq3NKKArS6GbcTLWdDQ/w8PbS3fy+nju0s465c9vsVNpkN7tXLCWN8U4YOjsh88EMFFnZf4I2RLF9Fn4v0y2FEqoxWyzj0a4TNJXRpnBa3viWnaBZHkiCMgiY9cyrpFyZAHZXD4TfvG3tHzBP/jkKHJjgmxS2IYlFN9MEPyWzIc3ULgeID15uhOZSvtgY3sIqNnwlKvf0BICSClp3Tp4cblmbVApejrzmvqQd5Q7BHBQV6obWRUyRQnAd63QHwK6L0ILA2bWFagxdLhczA543+9uiOiofztgIvtNw3gw5vPt8w7yTfqJzG8Nx66XaURLK9m69FGCDM6ZmRjsKIRw1nQyleGZutzwLZBIGYtk1/Lu5d6I6wzUVxmRxZz3+hS7SWmkbWqUxjIr29pDOymYIHufmXmwn8ub+HhnHw8n3AnRBha+TT7dyL8xTbDNiLaxh7UEScVH2nOl/a3qvHpWUonfZulzRLGg9yoj8HM4XxzGhUSxkUdeG7GA2X6TKV8dteoFUIUlcNbgOntoTSNMs5YFxp/QWxF1ELes7YhWY9o3sqQLpesl3PyhWRqAUSKY8H5Iq5FESjy2xk+yIr7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 fixes a use-after-free in zram_bvec_write_partial() that
happens on PAGE_SIZE > 4K configurations when a partial write hits a
ZRAM_WB slot.

Patch 2 is a follow-up cleanup that drops the now-unused bio parameter
from zram_bvec_write_partial() and zram_bvec_write(), no functional
change.

Patch 1 is tagged for stable; patch 2 is not.

Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
---
Changes in v2:
- Add patch 2: drop the now-unused bio parameter from
  zram_bvec_write_partial() and zram_bvec_write(), per Sergey's
  suggestion on v1.
- Link to v1: https://lore.kernel.org/r/20260527-zram-v1-1-ce1acb2bfaf9@gmail.com

---
Cunlong Li (2):
      zram: fix use-after-free in zram_bvec_write_partial()
      zram: drop unused bio parameter from write helpers

 drivers/block/zram/zram_drv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)
---
base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
change-id: 20260526-zram-b01425b7e6c6

Best regards,
-- 
Cunlong Li <shenxiaogll@gmail.com>


