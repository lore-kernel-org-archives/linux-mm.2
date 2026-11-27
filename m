Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F1A606A6AC
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XBCn6ndr
Received: by kanga.kvack.org (Postfix)
	id 96D396B05BE; Fri, 27 Nov 2026 03:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DD76B05BF; Fri, 27 Nov 2026 03:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80DD86B05C0; Fri, 27 Nov 2026 03:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55D4D6B05BE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:49:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D13D5A79BC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:49:02 +0000 (UTC)
X-FDA: 85480274124.19.9533164
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB0C8180005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:49:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XBCn6ndr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795769341;
	b=zh/IzoyPsmVbWZw9+/ttEdxj5VvnVGtQa5rg/+RLCz9YkS0pVxrI7fx3MjqdpOOgMw18Wd
	ZyA2mYoxAtPIyFewo2UChzjc8Dr++Nxpao/abtvGxVvehYad2x7s2vom+/wecPE46ijdlP
	8lqyQhUemG+FmQ5LU4VA9etXp3Taw10=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795769341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSulb1ZKSxB82Q0DHVFpLluzjXlQ4n39cXbO7GHm4Hg=;
	b=eE9MenfUGOQDnry3mceQ24J1LpEEEPvn1+epBp4kHjoCsaLC0qM/LNf5TGtv5MFMVDt4RE
	lnadLLNyvhA4Q7gq4KEp6nt9Zy1lPWiu8Ssm1Q7+zidOVIf8c+fatEva4fcO59jDk/REoG
	RJZULO+ABFDAItR6pL5q/F6PRAwDTUc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XBCn6ndr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2f046b0adc0so44898115ad.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769340; x=1796374140; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aSulb1ZKSxB82Q0DHVFpLluzjXlQ4n39cXbO7GHm4Hg=;
        b=XBCn6ndrMJ5uCjqPrN0ONw8qOxooLkjYAtMEl//hW1PvyZkwJfepIsx7j8+35IMpXd
         1TMRklVFgP0FeP7EENfaepMK/3Mvu1Ml6O2lAq++mmB6WxuHiL/PNWY5F6m6YuJ6pY2Z
         Y4ymZ6ZsQJmsTPABI+nXyf77/0ffkNxJctKv7Slkti1BLKpLOk6syNfkZ1E6iF6aYSEr
         Hb65k4nEy3GZs7RChHRYUXE0lo4wcO53qbGLeZEFs46ENx5LBzDvh0toUKy//44CGd6O
         yHwRVTSmcnx2uKdFKfO103nskYjlfENLV7Pbmgu+bJud++2ZD5PXozPfWLBEXT+c5z83
         nc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769340; x=1796374140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aSulb1ZKSxB82Q0DHVFpLluzjXlQ4n39cXbO7GHm4Hg=;
        b=IQnUGHDvybR0W4qdVqA7U9R6r+wJukbyj9eFdWjy1wLMiJMrsT6g0/k9o5FF4CPcb+
         M1oL1zZnLfVCyy56x3PQiiGrwIgpDqUj/NW2ZLf2HrksZsbx0krHdo778JyApxDtVyP2
         kjdINxjJm4YUFH8QRWBu41xQIUqosw8p0Jznga8CRG2sPjnk914QI3Jp7BHfB8Frp4Lv
         xxe0MRdBOLkGCiCy+W4HlW5ef3cIR9lnrOhVublMC71VVAiBOxUT6IqBR6Rplu82JM0m
         u5N616EcZapVbYsgIuSWz70TVu/+l2F+AAn5VBcKJpBoVkQ8A6Cy0fM/957CTB1xDdSw
         DsPQ==
X-Forwarded-Encrypted: i=1; AL+hErG7KESH5t15kWr9KDuwSRWl4G4VEEkcoTBQn9meKxMHsaailqoF7wsl/iwBC7G1zFy+EjM9j6LHBg==@kvack.org
X-Gm-Message-State: APuU4Z9QVKAFLL72HRmsAfexwB1KhPcZdWatyOZqTivHl91x7UbtUypx
	Oj5ipX4mgLiF9t8GD6Gro1E0Z+QaeQBEnS50iSGuiOcu/xEcok+RrwzU
X-Gm-Gg: AZFdTZc3iPjHNZFO7roRIm6/66NUDVv6fIbcPqRlwoEW0riiQ0ry0l3YGt7QuJdz9HR
	4uvWzXSNjGgl49FmCvjH02HF7TrzzVwT3Nmdgr64KPIEo4o3MJsVkXLnK+EpiV8QWvsaiizxH8T
	X36h3m2n604nW95ZK0oiGogT4JZiEBdJJA5+ip3k3I1PM9KX37afguVygaGPdQWnV0SyJinieTS
	cSUm5K2odZxzGAJCG8faZGw+vGfwNsaxDi8tB9zazAYLtv4hj+m/HYwyr6K267/UrDPDmGzcJyE
	Eom6fJZ2k8LAYEyUSYh4i4wtTA6QiULC9ywhHmEr4e0CSFyq4m+tLQQaXEGRWlsYitTdZu6c6hy
	QCHFcNwgfXRK2p5FxJJZoJzTU5wkta7JEKhlAA0DNQtoEb6ngY14Dl/uXKG8HYBefup3gzNWcPd
	FRVJEEMv6TeaIruHvgm7slaIcA0Nkp2n7H8rG6ojznzL/JS8Ua1VPTNFvu5rD377ycZQfYB49mn
	zzheSnmIOVxUKgL66VaSgudjEZpeP+IsO9RjR2afqh+oGz3Jux7tcUCGSDo3l4WmHEHy03pcS27
	YgxmPnEVQ/H2tqcbtVtyCx9YzvDVIVgWeBrcyU77K/aVgGt7QJ5kqjEkvz/2vbqJEA==
X-Received: by 2002:a17:903:22c8:b0:2ef:e563:d2a2 with SMTP id d9443c01a7336-2f11414c317mr10473615ad.57.1795769339572;
        Fri, 27 Nov 2026 00:48:59 -0800 (PST)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d0818c1sm12289058a12.30.2026.11.27.00.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:48:59 -0800 (PST)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v6 1/2] f2fs: complete dropbehind write bios in task context
Date: Fri, 27 Nov 2026 16:48:44 +0800
Message-ID: <323235fbdeb5131f83569541c602ddc88f412b18.1795746008.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795746008.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <cover.1788795700.git.qiwenjie@xiaomi.com> <cover.1795746008.git.qiwenjie@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB0C8180005
X-Stat-Signature: cj8fmg67g3f3wmnofry1x1pjfwbojmky
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795769340-187872
X-HE-Meta: U2FsdGVkX19LZ+I8F5yNLU3FeMktnY1V+zHFUUlF1nPbQE8K09ytKzpl36ZQ40QkT2MAuGo0Fco1Dk591bleSg4w+BrSVDtbe9gbPIr/jXcE34Z2tPHA3tfQgwPb9UNUCcM9g/W3Oop6GuhsdDHkldEiOq1ORwvdHNl0opqHwsNm2B5sKUhnc8/ParXmfeIl/ueCUYHzma1Z1OGQrJIKliTJ1U31SwuR2wek53VLcYUgJSrRMuVw7M6LKyoROPgj5k/YFlFpOLONriV6PH3E1lfHUH/KRzAmOe/ZcPmphyxHCJVNxPcW0Kiq+UOKXpiEKfJ90RtvJEmNrhDpD1/i52oej5aQVpMIGWK9oDGl9E16K0mVe1PjQzj8HzWREbBbx/sntAsQYUb37eqBS3n0cTxxXVLLMEJG8vx4rHYe2R9p2ctz8V9ECo59CaevlqJZTpfPdPUto3oJXyMK4AM35mDCTkTf7wZ7aQiCkE/8YTAwdSwszufEjlGreC4J9cdw/2K9qoFta3YrksuHwXlKuFRYJ/gTh+c0KODBYb2bLJ+dVX8wOviu/PmmzYuHeSDYbhdY1GURa7IzKQsejylcGCO1BmIMllXKhiX/e6PJhLm2mRlDtdEvwzSYefLIBrrHql7HhTV3rzvsspNoncbWlOYL383P/4hmRKInfdscCDyj9RssqRgDcefBRBbPHFgIEi6hocTPy3G6MSlfrS1+ACjSHK8JKwvEW+Bs9pzNd5R4lTDk9GI+JVjBbo4GeZ80ypf7ADqZpz8Kmqzu7TBUKZyQo0Sx6GtLjIp41JSXZsGpMNMIzVpBVoVPar8fNWECarf/j7LjphB5XsGwmXLNXikPNW6rNoyFU9AZlDc4HEMgRpCA8mXoFCE3U8UOySmLN5ga+nsxMxyk4xqRsDdFQBLVbbpyaifnJzLXUBPG3myc+bJmpMqAgFr9zOjtNJq3niuW+KF9l7RFHxS+dqo
 aPGGScdH
 BCp1wrZ4T7CtY7AMqTXNZ/LmbgReo02DeugIQnwKElV0GOTku3nFoJ6ophdhnvQcsoq09J7uIOG1UL1KCadLtL7aJTjiE6EXTs2S6w79oGaoUMYA6gjXylxMtp0PFMGYb9GSczgz6FxpwbR9GCr+aUY4O7vg/X5MqxyMOHxX3wuPYvGmil2bEZPl/e0UTyx/0w+tDqeorQgz7WBgAMlLggQJ+der3yaKt0Oan6DBhfnEWw75nHICYjuq8lt94SWAFe53t+yGtX9vCSpwx2d8mgWQ+mQLXDq7Jmypqip8LV9u0rOKgs6LZFq7hDUv+Cz1D29sxdvMLFQBkYRb+CG6AAMiilXYoY2HMLbCnjlduXPHndJapTL42MrHRd4C4sG3QjlXuNxsMpGg8MNJ3uEbRiJtP1Ta+fNVaXmcs4w5T3NfCsO4F2hG4PMd2aNgNiuEpI6SeU7lZ1XGPVTTJWcn/enEfv1aTTxuAGQaVW8UCmK0ViBJcnDg+emBaBUy4Wi5ND/tmB8FTndqWBziFQTCvauwGh3gtcQWzvCgqzRZcHGOBX9Z0T4uJC/By878V0Ch08fzu7xf4CBj0Xx3MYQwIlRb+dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mark dropbehind write bios BIO_COMPLETE_IN_TASK so the block layer can
defer their completion to task context before folio invalidation.

Allow normal and dropbehind folios to share IPU and OPU bios. Set the
flag after a dropbehind folio is successfully added, checking the original
page-cache folio rather than an encrypted or compressed replacement.

Exclude metadata-cache I/O, which may not have a file-data folio. Leave
the existing large-ATC completion path unchanged.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
Changes since v5:

- Rebase onto dev, preserving the updated bio_len/bio_offset merge paths.
- Skip metadata-cache I/O before testing the original folio's hint.

 fs/f2fs/data.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index cdc9e6e8633c..37d74afc8b26 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -624,6 +624,9 @@ static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
 	bio = bio_alloc_bioset(bdev, npages,
 				fio->op | fio->op_flags | f2fs_io_flags(fio),
 				GFP_NOIO, &f2fs_bioset);
+	if (!is_read_io(fio->op) && !fio->is_cache &&
+	    folio_test_dropbehind(fio->folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 	bio->bi_iter.bi_sector = sector;
 	F2FS_BIO(bio)->entry = NULL;
 	bio->bi_private = NULL;
@@ -1077,6 +1080,8 @@ static int add_ipu_page(struct f2fs_io_info *fio, struct bio **bio,
 					fio_folio->mapping->host,
 					fio_lblk, fio) &&
 			    bio_add_folio(*bio, folio, bio_len, bio_offset)) {
+				if (folio_test_dropbehind(fio->folio))
+					bio_set_flag(*bio, BIO_COMPLETE_IN_TASK);
 				ret = 0;
 				break;
 			}
@@ -1359,6 +1364,8 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 		__submit_merged_bio(io);
 		goto alloc_new;
 	}
+	if (folio_test_dropbehind(fio->folio))
+		bio_set_flag(io->bio, BIO_COMPLETE_IN_TASK);
 
 	F2FS_BIO(io->bio)->entry_cnt++;
 
-- 
2.43.0


