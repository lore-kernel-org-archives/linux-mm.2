Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5218CCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3198E0161; Fri, 31 Oct 2025 13:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2539C8E0121; Fri, 31 Oct 2025 13:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191238E0161; Fri, 31 Oct 2025 13:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 091C88E0121
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:48:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6D46C0436
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:58 +0000 (UTC)
X-FDA: 84059145156.10.07EA8C0
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id E16EF4000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GPGLexmk;
	spf=pass (imf04.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761932937; a=rsa-sha256;
	cv=none;
	b=RfMRFZDoEl29RM3IFtIz3EitFeJ7y691wmBEpm8OPX4pY9wtE7AaT2cqAq5XwUQOecmFz3
	Wu2N3TOKhz/9tZZacSqRaVafyAwodFrRt79YZYrjZVAtIC03t5M3frcPfc8Vwoa5KFELd+
	aSdd7zcsB5XS1aA89B6x83YR+hRZe6o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GPGLexmk;
	spf=pass (imf04.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761932937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUPskgZ2IwxfUAiutZm0xbNgmm0EpWQfATFCqCIntuE=;
	b=d0Gcg5BpvG66eagq8s26sLA0vj7R2+9SdxKSFOtI2a2jdEWv+N4HVij1UgdstJcbNKhwYq
	gIBaG56wtL9VxIvUQ4P9JV/leFB+m7yIockt6U3zyJFpTGmMswuY29xoCrg6XeXaVYXfmv
	cQslEj/s+EaQ20hw9jzMapozmYsvO0Q=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-295018cbc50so27169205ad.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761932936; x=1762537736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PUPskgZ2IwxfUAiutZm0xbNgmm0EpWQfATFCqCIntuE=;
        b=GPGLexmk9VsIJoueyytUlgSz3FjfEafp0lazzuboByr0rmncIXUo49ZThnghu5+tKp
         R3xpH4/BPz/rETAfPz9RwGdJXUMXrIFv9IBrs81ECrKabdB35T84m07e86N/LQYXdN27
         19fXAanHywdlnnRrlkwE/J/U3lfAWWcJ9ocdTcZL+lb5jOECULlibLfRGaa6usPwdMsV
         WFqGLSDfD4aE2W27xjYijyA5zUEZ+Dv1CJ2/yzRJetNAqvvXzC8/sg6QFh9M756xoXDy
         zSO219d0oOO06eb/5iyDHPKpaSSvdmhtM39KoFXgExv3ghTR6wPt1HLA+5PNJAQXN5T1
         9HtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761932936; x=1762537736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUPskgZ2IwxfUAiutZm0xbNgmm0EpWQfATFCqCIntuE=;
        b=azvQCrOzvRyM8s89jvZiFG8fvVUywBzc85i32ewdtCg2oRYUi4mqesmJGNgKM7g58/
         3MyZQq9E1tXBU1CmpD4pb1JYJsDR289ciF+9atpSbeV83/QSPaHrH7AG8byl973tYMAw
         6iwsvshDuz604o2PhUxam6HlVYtzjP/1+lnrxTl65/pNZE/6dyZU1fZ6MUuGLCGlIlt0
         PrxBA7gbR4TOPsvMAGk1qTmsKThzrfI3NjaqRzqwCN5CpVEFwjdw2ExSZiEfj1vq8KiQ
         Wz0XtewQhwHBrwzSnZzQ/E5BPN1Xre2ABhOuzANYyXUwN0GdAWrTDLC6JLpiH6ETjHjK
         NbMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJ+aUH2TBlkjDCAY9vwI6T3sKctM0Mzx9km5o5gqSpy8iXCgyuhJ0Xv05u/hP/BdI2TT3TscSBmw==@kvack.org
X-Gm-Message-State: AOJu0YzWIMXB0/WSb1Dwuogy9bnGrAWoUHTc7j3ObCIk9WIrMt28B3Ky
	Ar4VAW8zMiqVYTvy0kqu0fY53nXDjXZE2Ut1x+1Zr/sbQU6EU0em1bs32VFXbU46i0s=
X-Gm-Gg: ASbGncuVRgiqZ/V578U16Offudryk2b1Th6uekP/NvkLXM4Dtmxr8mE/hArqutCS2xn
	CmSRlo3FT2nuR87HTFOA2RUvMpltevL9u5waKE7YJjwnf/rUsK19tAJxAqEG3lwAcLakqdJNA8f
	a2pnvqVSn9XYMkgMiZ4Rr4+E6sA8MbhZc9NG0hCyQOxU13Wu1y8Op/YhZhiTx74XnSKvNhO1I1k
	CdO3QKd/rx6f/DC5QjPrPcict22BU+0xC05AdGdyplPPSg5sToaEODsufD/w+ZmEMcMlw0sWYjz
	EGVW4A6jWHA4vYVX0rSKv56D4eNEX2JRWPmWrYxOFdOt+BTcXu8Vi38aBvgRZo2Y8QaKjp4A2vw
	hTkE1N5XmneQpsdNLIr9BShp4lrWEHlwLtfsaoBs9vHNSv+RXYzcOdh9TBp5ynWS0m58juFRbpZ
	I4BQ0Lz/OtQN+BPYfWQbpHQr0z
X-Google-Smtp-Source: AGHT+IFhSYtCMU4JzYA6EJXN00Jwg3bj+x1htmVLhTklDNpuQrO6NhH17BJNDWBo1Bau8BMQrknvKg==
X-Received: by 2002:a17:903:11c3:b0:290:c5e5:4d90 with SMTP id d9443c01a7336-2951a524561mr52125235ad.42.1761932935457;
        Fri, 31 Oct 2025 10:48:55 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29526871693sm30113185ad.20.2025.10.31.10.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 10:48:55 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v2 3/3] ksm: replace function unmerge_ksm_pages with break_ksm
Date: Fri, 31 Oct 2025 14:46:25 -0300
Message-ID: <20251031174625.127417-4-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251031174625.127417-1-pedrodemargomes@gmail.com>
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dnuf6jogpyndbxig8qozpcxpqm7dic9i
X-Rspamd-Queue-Id: E16EF4000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761932936-753725
X-HE-Meta: U2FsdGVkX19jtZsgptoTTaWmTSLEYQllGbH1VmXsRyy7OjhC0URj+GRLjhTZot1hMBBagLqzAvqlPDN0aEqkGSWqpgAuj3PBhfflHyuB+aXF8a37s2cQwgR9wBmAWA901ZTyt6jinVh5xqPyVG0aYtV8CkSxXnd3W8uWDiz9AeBkyrMMpgFfRrlukeNOFCOHl6HB7F5u+L8qNtQtahdMZdhVhU/Ox/W6tZGIGVhxaagUZ7kJzyeiHg42EzGhN+4zEDQoe6ZT7gYVQIN1NGpi6CbnWtdviK80Ryvo7ytRwd2QSsk8NvdVXC9/zWrxQZyPxF8uwp464/opdHC6aXis69TDEUy0aod6fdsiW9ACDYm5vnkICEuQDICvZRPsFydzCJRg2IjYRqbcPhg8BCoc7Lgfo3TPw9GkXEusOEdQjJly4CheQZosTnd61NpTJINsspYXyhRVwEi64ehTnT/DGmapsDegDhGJY+sj/6OKltytznTOkFHOJYcn2X20O48b6895uEOkMynRhIJzkEOOa9HvaxOeFbUKUVO34K42kImx240rgrjRugExGVICnyVocE94ujuUIiC4NUCAdps59g6SXM9P9+0pVJcOxBWAtCmlCZQNaIEEPWki4bGe5vpADpGpxn8qd0+plKTEPoF4yZ3PMuja1NzXRP16Rn/e8H8qDkN4eMOZresOamTL2xyIpTlhURt9Qg9olSjyki6uhdGPqo0PEqBmS6PIlC8hSgYTWUcxVMzmyWlSFpNhlO0lDtmGDE1RZ1APZcwaDOzKW9WaZzNrRDH7S9eBu1jPkt2btRpZ9CPaxWfEDWQvQ0g9gU8yEiCwwiJqVMGET+Wa+k0VSuD8WQee/AYFvZeQDkhGzncfQGOqo/fi7hdBmUd93UXmczDX6le3Bq/O2DzVjaJqy29tvuDp9Cl3lp+UiTAfUbJhg5rwrMuAidZ/rh8i9lle3dsyabAWhIQEafH
 yfeTs5kr
 JiSh1c4wAMWvNLcPps0gzcmfFLEGQcYy/+x7YEp3FtfnUoechvvHc5SzNMz8P90aeTDoj8m9JFtuGKyJUSStYCZBTp73pOh92HrL9Lb+njOjN37rqPYiv/batMDg8aHx4IPXfg+N9bRKAHo++wcKJsIC+qAosxKwuKuT37H4OEwk7WxYBDnmFN2IByonjryIQ8LXiegK+/GlYrrE27X+1OV9O1TCPBE3qi4yWSSNEeOiuB2HcQ/+2uEr8mAoaqF8kQHhlGA86zIhc4FgCfE+8xBUnNA9Shs+c6aknlPF1TKp2kp1Eh5VX7pZBJdjq23H/Xeom9gqio1e9dcupbEFD8HW6B73+xlSAUKF4pMP22IZXBpUO29NdjqJk0275DDcSjErSEf3raTJZ13yyMgMF9KPmS3Mgi3xArpBP1aVKAGw7CHblEP60Id3S+S++HZlcwf4Pg/R5ECJhX2ApM1mVRuFyrCPUTvOGtmqx/VhI5OXfVPw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
an address range. So replace it with break_ksm().

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 64d66699133d..7cd19a6ce45f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -669,6 +669,18 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
 };
 
 /*
+ * Though it's very tempting to unmerge rmap_items from stable tree rather
+ * than check every pte of a given vma, the locking doesn't quite work for
+ * that - an rmap_item is assigned to the stable tree after inserting ksm
+ * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
+ * rmap_items from parent to child at fork time (so as not to waste time
+ * if exit comes before the next scan reaches it).
+ *
+ * Similarly, although we'd like to remove rmap_items (so updating counts
+ * and freeing memory) when unmerging an area, it's easier to leave that
+ * to the next pass of ksmd - consider, for example, how ksmd might be
+ * in cmp_and_merge_page on one of the rmap_items we would be removing.
+ *
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
  *
@@ -1075,25 +1087,6 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
 	}
 }
 
-/*
- * Though it's very tempting to unmerge rmap_items from stable tree rather
- * than check every pte of a given vma, the locking doesn't quite work for
- * that - an rmap_item is assigned to the stable tree after inserting ksm
- * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
- * rmap_items from parent to child at fork time (so as not to waste time
- * if exit comes before the next scan reaches it).
- *
- * Similarly, although we'd like to remove rmap_items (so updating counts
- * and freeing memory) when unmerging an area, it's easier to leave that
- * to the next pass of ksmd - consider, for example, how ksmd might be
- * in cmp_and_merge_page on one of the rmap_items we would be removing.
- */
-static int unmerge_ksm_pages(struct vm_area_struct *vma,
-			     unsigned long start, unsigned long end, bool lock_vma)
-{
-	return break_ksm(vma, start, end, lock_vma);
-}
-
 static inline
 struct ksm_stable_node *folio_stable_node(const struct folio *folio)
 {
@@ -1231,8 +1224,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			err = unmerge_ksm_pages(vma,
-						vma->vm_start, vma->vm_end, false);
+			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
 				goto error;
 		}
@@ -2859,7 +2851,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 		return 0;
 
 	if (vma->anon_vma) {
-		err = unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
 	}
@@ -3011,7 +3003,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 			return 0;		/* just ignore the advice */
 
 		if (vma->anon_vma) {
-			err = unmerge_ksm_pages(vma, start, end, true);
+			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
 		}
@@ -3393,7 +3385,7 @@ static int ksm_memory_callback(struct notifier_block *self,
 		 * Prevent ksm_do_scan(), unmerge_and_remove_all_rmap_items()
 		 * and remove_all_stable_nodes() while memory is going offline:
 		 * it is unsafe for them to touch the stable tree at this time.
-		 * But unmerge_ksm_pages(), rmap lookups and other entry points
+		 * But break_ksm(), rmap lookups and other entry points
 		 * which do not need the ksm_thread_mutex are all safe.
 		 */
 		mutex_lock(&ksm_thread_mutex);
-- 
2.43.0


