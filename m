Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6046606A336
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=RGQnT76F
Received: by kanga.kvack.org (Postfix)
	id 3AB896B05B8; Sat, 24 Oct 2026 22:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383BE6B05B9; Sat, 24 Oct 2026 22:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272776B05BA; Sat, 24 Oct 2026 22:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F399C6B05B8
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:18:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A97BA7D3C
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:57 +0000 (UTC)
X-FDA: 85359540714.13.82DEDCE
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id BEB4240002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RGQnT76F;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+dUZI0Q28ikrVhP8r1OLTtsR33EU3YB9h6P4MYpUiA=;
	b=7lz/H9xg18E7i104peftYKh/FFspIiT2GM7A9Z1wzTSQscXbWfcSiDAqb8ZcHZO+CtKFYd
	u04rRv4f4dY/YZ8RjkRL2USlw10DtC/SWDYvi78Le9JTBT16pUR2WUKLQVtFHFcuWYN5vf
	wk7YHdKwSNLbmolarJsB/t1jpiEKvZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894735;
	b=rR72OtNeVquFmhAj9uyICyJPiWN8tFGzZb31Lk0NIK7F6DsFdPpgU+9ecOIwiFOCZKnxUZ
	46rEdKrkZed4MWWpPKU7xfzLCAeNUIL5HVPhWLftIrXglIPwd59Wsml3P+fu4DH08F9dIR
	dUoDngI9ySYendDUZCCpLNY0U0vevAg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RGQnT76F;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-14394530ec6so2650681c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894734; x=1793499534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W+dUZI0Q28ikrVhP8r1OLTtsR33EU3YB9h6P4MYpUiA=;
        b=RGQnT76FGoVA+KV6sIILY8tkriVSWg/iWFAgqA8fbgLrnJO6GuNx/WWMhZbXXE2px9
         m6AfKtwwXnfn2/VhjrFDb8HCT5pWc0poHPtBV/im1tm5pzCuETYkUloNdJV8hHQm9A7Q
         uaJkuSMlrJIY3tcifZgKtcZBduyxsdHDp3u5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894734; x=1793499534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W+dUZI0Q28ikrVhP8r1OLTtsR33EU3YB9h6P4MYpUiA=;
        b=BHCjQsQILB/+ZIV/LWYcgIV2EvDX++9MtmnpCUYAd4gIokmnxvr7bls//Z6QkskCI0
         iw3/iPzkXlEkZWFClRqRVEuQWhr0YDXx7EH3k0WORlKztcH5SPfd/x2l+IQGSNuKfYcs
         5UukIKZAAQ3E9WPYSjdAOYxAGZu/+gYQ7nCJNjo5+TLVCyDdSx8bONk67CqeVEqhHule
         ulwoM2sahQZEwYI8WtlrNH7kg4vLA7xpcR+MIvQD+d97K6vtpEF7BS4qCxT2F+vA5tFn
         ZtiqeJpp5W6xJlxTx8pAUBH/QeyLuR581YWUC/+uryGxmvFb9uAM1m+LF4Xhd27cgqhK
         bmEg==
X-Forwarded-Encrypted: i=1; AKwUvBwxc+qDMBkCXOg9hyFbS+sf0EqZiVaNrimRRK3oh1NTBSkQpsXP4zGJvN/rTHFMsq2zMKl5Wt8jjw==@kvack.org
X-Gm-Message-State: AFq9FYLVY7jpZoZ3FxNLhAnGPk2Heg/ORfWHWUiC5VxvSPPI1GXL/2qN
	Vb3jTyX0iLarakoSdEEq7eiHS2rKQf4mBxioDXAjQHBbmnZLSxVC+estmNdIPbjGCA==
X-Gm-Gg: AYBFou3O5PVhvGE84C0uWN5EuChQnbBcb5OaKEuIaqQzWznb8519Dkm5IIdrayF+XzJ
	uff+9RxPk5elIzuOuLrFOcOR3+F1pmQJuriKK9/N6bYIc7j7zmXL1bQBezvDCAH3HrnwqWKtofW
	oKRDnkPbE/ofMLxkK+yL4yPA+BoN7WDCStxuGAbTPXi21m1eb01NmMwAsZw599wTUcIcnIKRiCd
	0+uVJVim7ZV7istlLuYHtHpYjY7NiqfnnsUg3XRedMGHymh8BSBPJOgxCDSvsR2Mt0xCQHwo72O
	0d9s5g+VnCtzhm85jgXj3eVEuR8w+tzR8kd0CEHDUoh+QrF+u2QUEynoooHH+HElL/ivAqhbt9X
	GYsWI7zewGjPAWImUJb1uPePL849XQUJht67H7e5sjOvfqe+Qz2ZgZfKty8sbjZe5Cn28+vlqRX
	cw/1TZkVSXdGKSoCLP17DG561F/AJAa4Xf5WS6BCrbyxR2Fl0MGu0RjY21Rhob2z/MEeNgcwhEC
	iTKm/luoLBiEHGk8OHPfxfxWcJJKSHEOSA6GBhp8p9D4emxe9F+vF8BX1XVlp0QWY+iUQg2xAlK
	7IiZDOn/LS4F2Y/TgzVxGb+vtegIjDS6Gr8anGZAIW8F
X-Received: by 2002:a05:7023:a85:b0:153:3c50:ab85 with SMTP id a92af1059eb24-19934a952c6mr5391501c88.12.1792894734487;
        Sat, 24 Oct 2026 19:18:54 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:18:54 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v7 04/15] zram: move mark_slot_accessed() under existing slot lock sections
Date: Sun, 25 Oct 2026 11:18:20 +0900
Message-ID: <20261025021839.1542805-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEB4240002
X-Stat-Signature: hi8gqg6zwmiw41e4pi7uycaiz83tgdgj
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792894735-338251
X-HE-Meta: U2FsdGVkX18ETPvZ1Lw/CuZzK5VVFrJUjSb6zZOgnBcliAfBATBRNWQGQpu/gGocudOK9altcWeCykYy7vNiKL12BQ+tgRLGKPqKTfNe7Z/X+yIZCcCffVMs0RaRq0PZc+58Rf9+pu+5mc8LB04/4YiqQbKaT2asPHvoQUYiQ5KxUsLK/WLv/JG2YzhBeRhp3ljmY0Qw4paiqqfz4vhQ2Dt9W/NXephCZ97ZLkzP342xYYBextilXNE1knlhhV5vNDGw4KoZvkf2g09MBoHdbNcIHyCwCyjKq1OH4KwVDbZ94q0xkmGy5JQx+0E8LhNoAgRAQSWiYai1lwNG8+4NFlSOTlZUhUsmyF7XJj1eihsaNETwNOkefORtiRQ/csNbud3QrFcmoS+14MBkmp/v4QndGH3xMJHfjedMcVLbvInh/p1xdyCyx7Enmr8A5N0f1kqGh3kaJxU5AI/ImYfLDyZEaknci87bs8hCaWgGMYqiUcSK1fMFgkZGekM2gxRKi7trlkhb97luL4c76mKgqQrUBUgybEiwISj0S83Ste14KPQpAfmZtOAKAwJXJ5Svl+NxrbMBEeXOkDqC/R49rrp98jTQCE48MLjn0+RYwl1dQf1RA5zOK44FEVMotXFbbL3kYPG5tANZYCR34Kb7uh1XrF1RE44fabqO3HVXRd9Y777npNuCjxhQQO/wpcjFYNjb/5A0sw05YE7UGY4h/hb8CVLjZO66GFgmd8KF/jgmzQzuddTMEwZSGu6OGF85D0u+lt6Z9dhV2hf8rfuJFiFPMbQF0IytkYB60gZEr9iwwfWKaiN1opNNgZbhxAw1BwjSEynxhIo33CaAd3dzM5qOG8/lneu0qqa3p02LWePzkTKfdBpMjUcfHP0XrdOA0hnen0nmV0EuqvWBU0qEC4SHvlcAS1dxeP/cZmWIz1l1FX8q+Nkm53md8EWv0R3/tJKL50WufnAfXDJaEUH
 cxnFSLmx
 FVoHCrs9EOpAoqgZkNDjMMegilI5++M9xqQIa+Wq7ZDpzCFr+Jbj+ggmfEPAuonlBSYY7vOHJL2Zs43OjvDFX2y0ymTwJoJOLdeQZu7m7X+Gb46J7XRFZXNyQw5y3g068fJQOuTuyJa3Se+IcTHrYj+wIIxmsGYQElVPtErvcnIVIirj92fgsPaYmZItK7J1LbLqiclszVqBBXRKWaN7YHAmWMEC2V2ZyTkXLR62qpbCafP2ria+dcmwlbIbeK/KeHHMUzQQqAA8DPc3qmrHqxtNDw3bEa5Vmfiitl0Y3kL8CS+RIb8dVpjGUBRI1T4urSbNV5Cq0e3BA1kIRkINvSZeWCZjNunRHpBZL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_bio_read() and zram_bio_write() take slot lock just to
mark_slot_accessed(), right after zram_read_page() and
zram_write_page() have already taken and released it.  Move
mark_slot_accessed() into those existing slot lock read/write
sections.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0e1aa0da11aa..2affac25db5d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2188,6 +2188,7 @@ static int zram_read_page(struct zram *zram, struct page *page,
 	int ret;
 
 	slot_lock(zram, index);
+	mark_slot_accessed(zram, index);
 	if (!test_slot_flag(zram, index, ZRAM_WB)) {
 		/* Slot should be locked through out the function call */
 		ret = read_from_zspool(zram, page, index);
@@ -2244,6 +2245,7 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_SAME);
 	set_slot_handle(zram, index, fill);
+	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
 	atomic64_inc(&zram->stats.same_pages);
@@ -2283,6 +2285,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	set_slot_handle(zram, index, handle);
 	set_slot_size(zram, index, PAGE_SIZE);
+	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
 	atomic64_add(PAGE_SIZE, &zram->stats.compr_data_size);
@@ -2348,6 +2351,7 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	slot_free(zram, index);
 	set_slot_handle(zram, index, handle);
 	set_slot_size(zram, index, comp_len);
+	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
 	/* Update stats */
@@ -2756,10 +2760,6 @@ static void zram_bio_read(struct zram *zram, struct bio *bio)
 		}
 		flush_dcache_page(bv.bv_page);
 
-		slot_lock(zram, index);
-		mark_slot_accessed(zram, index);
-		slot_unlock(zram, index);
-
 		bio_advance_iter_single(bio, &iter, bv.bv_len);
 	} while (iter.bi_size);
 
@@ -2786,10 +2786,6 @@ static void zram_bio_write(struct zram *zram, struct bio *bio)
 			break;
 		}
 
-		slot_lock(zram, index);
-		mark_slot_accessed(zram, index);
-		slot_unlock(zram, index);
-
 		bio_advance_iter_single(bio, &iter, bv.bv_len);
 	} while (iter.bi_size);
 
-- 
2.56.0.257.gf7497c7d27-goog


