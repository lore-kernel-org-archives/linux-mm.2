Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918F9FB5EA8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 03:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B676B0005; Mon, 16 Mar 2026 23:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CD56B0088; Mon, 16 Mar 2026 23:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722496B0089; Mon, 16 Mar 2026 23:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9E56B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:24:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED6AD1B7E79
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:24:06 +0000 (UTC)
X-FDA: 84554111292.28.DA19B87
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2AEC04000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:24:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hNylPvBO;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773717845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fALKEtwVUlhiV3LDTLfOGewg1HDF3QwssUtCeBDAQNY=;
	b=tEsOl2anY3tsOAAao8acKlIQ0nrvYXzP9/Vf00cAN+gqM8L3M2mLA2EynyS1Mo9PtExMwN
	XBh85/OwavGzKxMzwgrWRdrP15ColshHocWZTaqyc4mfohLuCxiJy/sPcl3HWEI7dFo2Uk
	2WnJMGDY/vc90kcc7yqP3luxMJwfeGk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hNylPvBO;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773717845; a=rsa-sha256;
	cv=none;
	b=nhNYeSJaZNRsAMke1Cw3/W2nrHw9Ayd9UCkROjAOg6uEmQZAs9B8ErDRTYWApf8tKmERXd
	KnXKhQufG1XPaho6V6Sv+gPuWAHaOuIaOVd2gYkEueGkJCSFauuWch+cmFUcSY28pE4aih
	NSxcFH/lfgAsiSCjBqgprL5puH43AAI=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82995242934so146285b3a.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773717844; x=1774322644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fALKEtwVUlhiV3LDTLfOGewg1HDF3QwssUtCeBDAQNY=;
        b=hNylPvBO9I5jf1nlpKOxFTvbyQO1nxK5AC5iKG7hL0yHjE/eq1bO4/v1lE9JL5hAT7
         1RseXZl2vo+AWR635u74ddTgSTu513iuFwrslZOjCEimVaVVMqK0AuSG/Zbsm9mApQnJ
         eNmwb2slyCJpJAMdPdJDkShDNhvqxSU8CgFqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773717844; x=1774322644;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fALKEtwVUlhiV3LDTLfOGewg1HDF3QwssUtCeBDAQNY=;
        b=jdWbfkG9XZKVbTbrbhX4Ebj7iHdWq+HHoq6IxH8wWFGmeKZcU8kZrh21frUPE7D1bg
         4SOruRDw5Tyaqu6LorgqdUwXTLAayRUI0G5zW1j6TjANIC+Ux/wU8HLn8oHeGAdttobm
         yIpIdsvO4r0emtBjZC7TnWZ+AxGFI9I54Rmdfi1yqfld5pafjF6DXZu5hYNiIJskJg/T
         RxavOjEkXfEEU/UUfbgw+vXOkZAnQGUti3p0hdjHcVQyFzlgL58bGF9T2PJ1g7ouFGCL
         5CmvOONV/UzaU7+fstZbgbBxVa9pHB+jZwgGNSXvGhsy7l6QL8QlROwUsHRH75aF3hqq
         8u5A==
X-Forwarded-Encrypted: i=1; AJvYcCU8N5P2yMoGgtRi9I29JUc80fbE8xKv0x+PERBejVKWT3u25CZ7H6jsNfNbSFvGcYVDy+bBUc/qsw==@kvack.org
X-Gm-Message-State: AOJu0Yz48eh+IXWPq52bWnjFzIZ7WuPJIq686ulkAd/jr67SvsMuSGND
	gpQwF9szKmHJlx7CqIWHyUvAtcpL2Z8F57c2EhOmD5OFaz4MthWcfWulJF42acel1A==
X-Gm-Gg: ATEYQzwLopz5fnP2lMnf9zeRFkOZxGne7M9YpT4QzSKPg87E+n/0WwMz9Go8hNOrK1K
	XxJ90U6LBoDgxxCvVZLtRx8B9uGu2qm/nhEnOmZ9ZgY9wpjdXE2bcxm8yJsc/L/cNPnP/n4zAvR
	m0JPaO1QpvM/HjDUPZKeTC9Hi6SMBVSjcwklUp5ogdX0dyUPES/XIQCVnXhuB6nSIUZTgQwMhgF
	n3bgWbR4RZ0THNOP+QrQChIqCrKd6MkW9Y8xPZSsavcVRBHcRfa8hcXnZZaBVGMQCt8pL5IalMl
	QBFGA8C/RKAz/doSVGPw3RP0OAM23T0HZKksik3h7lq/GmDUYkT4HitTV3MIEI1ZpYIyDaaqiwn
	kqxw+xq2v6OfI6Ah5wo9Ey8gugHJ06/zvp7Uc2DtP/FLfMMT4zHpZMkaehm3Ahlo58Iw6/SUqHE
	F8fXVOXryzWLmUhV/vVlfcplRKWtrtuQxB+D4ScIywbQpRx0glBlJ30qRtRj9RvqrMj5r2XdY8U
	baVm5/bHfeZLQ==
X-Received: by 2002:a05:6300:85:b0:398:9a45:9cb5 with SMTP id adf61e73a8af0-39b7e061c47mr1611249637.32.1773717843902;
        Mon, 16 Mar 2026 20:24:03 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:4523:d548:3639:235b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebb7f2basm9840364a12.29.2026.03.16.20.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 20:24:03 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] zram: change scan_slots to return void
Date: Tue, 17 Mar 2026 12:23:19 +0900
Message-ID: <20260317032349.753645-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e4bon8i9gfs3gbrsoufzqja1hnrugp1q
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AEC04000E
X-HE-Tag: 1773717845-849621
X-HE-Meta: U2FsdGVkX19V2pe7A3wUX8C7GNKKA+9g7m+kF07rv71pafMqxbqvX3uUfrm7Yue4a/Y/R5MNv9bCZiCqaOCZOS53X7TJwjw25GCJW8a2ZG8soAI25PJL8sDO+NubGaWrerXHR/x3U5/Q/HivAjsxjXJxQuIlKaexiWNmbJJPjkbIcCy7MYXZA9+VK0al4I6c5kb4b2rwDH4R5N5hxq8gSNVXJRvRjOPyf/rcOCtJ4KoKrW5K0a5kjrlKLpXYH8Ls67TBRxf4QtvRnueLbnwkOF+gGR7ElAZxbB2ednMTOyRrndJT+88z4iPIraMQaeDlDQuzRac22ySB9cBBvIEwhR2JV+7EQlk8lxvuQzW5ZjLYIgwt28jnvMWq7wUr/TIkvqfMyJFIWNKuS1aaf8MsrHY583K/Bb8jDVKZ8nRK+Bnw6MVRPa/HtxHKxF2FzqVTsLiklUeXhaow5kPcRxKF4lVu+lfgdXc+NMhfcSWDSb7IVAGWYUPv7SiQfbYYCIP+LjVYDhSk4OMUEOY/fT2D4Ac4DxTS8J6X3xhKk/ZKJj2rC+AIOpKCZXLIIkazWctMibLUp99h5wJBQLloz33+ElAvsOGo6RRPNY6yPKkYiKbivK9P5hwvdYtZ+/Ul3fEUVCpDTtZI6w0E04IFDvPjnukiP6argGTGxEidYCZZSiNE3+WjXFSRJd/W0BZySlL7Ru+w+53XVChlSxvp3UMUdeaHJf0B+PZn0yR/dtG8aLIAZPHR9lsl/teiwCNTyMljfQOvStFiSQ9akycLk5N8kQcoWcxQtOj8VK0Iudr/z/j7MuEwskVcldWzcNcECv0mVm3uHs2+weCSzzQOoGwzYlr9HBtAkAO4PRMWP3dJsp6zdGK8o4QtgUNv+la/gk5EhAPQguT0Xc0j96+Hvb+5hFlAZEXh8TIEV+4O2z22f2k+IMZ5eA2SN8hyvLUxYNdE1D1647TyhBRVPc+AOBt
 X9DK50pS
 dWFl+nyp6hmNu9niE8D4vfEVMGNYk9CVhPTpv7jwvrM9o2nBWNoS6gK4mT9nr7dco09cCV3RhkExXxQufmAyprVPB0v8gy0bNDYFwg/hZBbwzotM3KsTaF9sar+FcmYfyzo+OYJetNMJvRlZEOvHHGekN4mkvMp0DQ+b7p8ejAAX00XUZd1Cuf9RnJsY6JYo8ypqu+Y7yJfgTipqd5TLAwQC2Z7z5mu372+EQtxXuArrNM6zW4dPIuyu49CcnqNrGRFGvDORBxlJLzexVDIfRETYIZ78aB9I5T9SBfAeq1YSQRhXUM6noXAQGBUMgU+Ms6iHeeHinffTiBlSWaySmh5U5I6wc3NylHaz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

scan_slots_for_writeback() and scan_slots_for_recompress()
work in a "best effort" fashion, if they cannot allocate
memory for a new pp-slot candidate they just return and
post-processing selects slots that were successfully
scanned thus far.  scan_slots functions never return
errors and their callers never check the return status,
so convert them to return void.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7e45b8c8c33d..1b0e1c02ece7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1212,9 +1212,9 @@ static int parse_mode(char *val, u32 *mode)
 	return 0;
 }
 
-static int scan_slots_for_writeback(struct zram *zram, u32 mode,
-				    unsigned long lo, unsigned long hi,
-				    struct zram_pp_ctl *ctl)
+static void scan_slots_for_writeback(struct zram *zram, u32 mode,
+				     unsigned long lo, unsigned long hi,
+				     struct zram_pp_ctl *ctl)
 {
 	u32 index = lo;
 
@@ -1246,8 +1246,6 @@ static int scan_slots_for_writeback(struct zram *zram, u32 mode,
 			break;
 		index++;
 	}
-
-	return 0;
 }
 
 static ssize_t writeback_store(struct device *dev,
@@ -2379,8 +2377,8 @@ static bool highest_priority_algorithm(struct zram *zram, u32 prio)
 	return true;
 }
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
-				     struct zram_pp_ctl *ctl)
+static void scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
+				      struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long index;
@@ -2415,8 +2413,6 @@ static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
 		if (!ok)
 			break;
 	}
-
-	return 0;
 }
 
 /*
-- 
2.53.0.851.ga537e3e6e9-goog


