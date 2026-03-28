Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D36B10F3DEC
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72146B0096; Sat, 28 Mar 2026 13:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC9B6B0098; Sat, 28 Mar 2026 13:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912336B0099; Sat, 28 Mar 2026 13:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9C06B0096
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:01:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CA4DE0327
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:01:10 +0000 (UTC)
X-FDA: 84596087100.15.B67C480
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3CDB4140004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:01:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NcFzEM+L;
	spf=pass (imf09.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774717268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRK24Y27B4JY/rNOIbNDjWmyhoHVodZP2NDr8eGkwx0=;
	b=z5mSo/vb0tB9S6IuLy5tXwkLj2617NtNtBoqa/Dv0UFEzWMxZf3oFxi4kZsFWdaRr3xOXr
	AxhKU71lcuu658dtpFZgcj9F4jrJ/f1vogXG3SnhmSWFdUde8aQOC8/TIIICI07i/wtyRY
	Smdyko71fSxJyXFkHSFw8rd6Mf0fQ40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774717268; a=rsa-sha256;
	cv=none;
	b=V9bIW1uYWGMbm/pDldFJI1ykOPpqzXIZ2JpK6vbBzgLWIabMKImTzlFaa6Y40eEHrU27es
	3LzFoCmkbHmo0jrx+stwXvlYgPVNdgdtH0kIAmXsQQeSBKOBboSlJc6h31oonis9vbQpQ+
	8SWItHJEdtcTwAGV0eAO6dzk7rTnt5Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NcFzEM+L;
	spf=pass (imf09.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48702d51cd0so36203265e9.2
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774717267; x=1775322067; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRK24Y27B4JY/rNOIbNDjWmyhoHVodZP2NDr8eGkwx0=;
        b=NcFzEM+Lxn42IDXbGKhyHpeo5tvL9DZLQYJxy5eTUWEKEenvrnOBYfJXHOhXPgxOXo
         BWY5lWM1N02LanSJcoQ6MrSVAIjrr0NJ9Q0qCMXtTWX32Run/rQcKhA9lKYq+ry+Nbg/
         kgmIpdtNsZGfXQEPXUdwLVMI27Sq9+/f128uP9JCvoHELqs3g0aiBH+8LGU5P9+qhlbx
         zx9zzo1NhzW5VqL5nbSPt76lSjckumlYhju/T/xV5BkOnGs5HZ4E+rIsIMFhiDF73gnK
         GbdHsdfBHVhy5FSFAmvB2JiRdMylkaS/W9B/cvMafkslbFr2j+Cn427gYaNxk4kD1ak9
         W2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774717267; x=1775322067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PRK24Y27B4JY/rNOIbNDjWmyhoHVodZP2NDr8eGkwx0=;
        b=eAjPD4guaFyO1KQ0mrTSyJCzHqZUhi/yf40W+xa/7gZ7g0w54e6HTx7cMH2PEbEIKQ
         i3ygpe91U4i5CQjFBUjCGX+BiXUOJJrxtEJ6Hb8t4kZOM7N+L1W0zd/EnZDKwkoOEfvD
         B3X0YaWsdualjD/mgjR+xtjAuai4A+mkX1DVU9EQL/9wmlyq1h8j6yt8o4+F1Mw7upBj
         TuxSJQK+dA7jr0/HP76fV6RC9W0jOrP3CoUiMoCDKVAG1LftRDPhipGe9MOroGXUKIPp
         2I/NoVSftngbPPsM+FuMLn9d1gGsEjHgb10vq+Kx1O3lEBJX8fbh8DsZTHhR7frFjuSH
         1uLA==
X-Forwarded-Encrypted: i=1; AJvYcCXimUj9P8Tlz6843Yaof5Ln6wCfTHupklHWWbm99GqpDnS/YSCO1ZCVCPIIpioqJYZw7ZBTmsT2Nw==@kvack.org
X-Gm-Message-State: AOJu0Yz2gGCe/pO+PBqspLFZZqtZ/deP2FbPqvnD3qMCi3T/HSNPvV0Z
	z5tdb4fZg6OuM/qfMbcyvd3R/GWQd6tqfUciVq59BlZkUEZ3IZChgKd6
X-Gm-Gg: ATEYQzx8x4Fcnt5+eoYVget8gNNIxD0D+PvdLPeiJnEr94eCgulJAUNWUE/khfuEZKO
	BbKO85yPqC+tFpXtrE6jZ/L49NZxnFbi72dZ1p6K0XCmJ1zTFESmutH/2shcoiqQgk07GxQkOc8
	m5RGjdDj6dnmteTGKlRjI2IafLobvFBwrAYaoHQXKjmZkvYPuVf5nICa1f/6XTVe0H5863PRHO6
	4MVWdQbrJOmgDGa6VHAbvVvqd9BxqjNeSSuJUxrS+ZIeZjQafsUmis7sZYDfmEcgzsyznuj95Sm
	sW92dWI7gzRYJyAKf6kdcX3pvy0s89w70asXM2KJDUwYfPmd6Rd2o1IYtE6UXuhrb6nJTm7PCDm
	wC5dell308XHs1VjBlF1epodYNvxlqbXJu5yj/H9G3ER+7UXyPVTXwOTM/KSQILxoN+Yn6XkmnX
	bZOio8DTYLh1qONKyxfjSQbPcIbYoJw45rDvn/roLB0nX8XmfUf1H8m2r9fkEJl6dT8SUMzd3Of
	kjwfWG0bKoGHSyT6sNHd34=
X-Received: by 2002:a05:600c:a10a:b0:485:3f72:324d with SMTP id 5b1f17b1804b1-48727e9ea73mr103096045e9.14.1774717266642;
        Sat, 28 Mar 2026 10:01:06 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4872718dfdfsm38161075e9.30.2026.03.28.10.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 10:01:06 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH 2/2] mm/userfaultfd: fix wrong likely() hint on mmap_changing check in move_pages()
Date: Sat, 28 Mar 2026 17:01:01 +0000
Message-ID: <20260328170101.184163-2-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328170101.184163-1-devnexen@gmail.com>
References: <20260328170101.184163-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 6xsfj55561rw3kzz4hmkt835pma3ddcp
X-Rspamd-Queue-Id: 3CDB4140004
X-Rspam-User: 
X-HE-Tag: 1774717267-829882
X-HE-Meta: U2FsdGVkX1944g1U3j3zlcVaScA5lfHKb/l4Kbxs6bpJ5LUulYLwmRc8tSwFpyg2IdvRhEbDy9jVXd0L6YQfOXHr0iNAAdcEY35Dytl0qZFcudoCwT4sy92dEEtahPFh6LgXTk/wwMfxNbRJBHjd4ZfsLPgxfQn0aJbaB42DOHm6Y/S+EwxsHHOqj9MFACFoqbysLwp86b5VJt4ZARDnyDZUaWqPbUE8pFkdmnsxXPLSB07iUnIgZVsj8fjSbXQYq2dRVjOMeCrsenxS/DMdm1N3l2EdnlfZHieOmaKaHN4Z97Nr67i/BeHmb6chLLKzbUloeWc9g8TDJZOBUufFLGAi3CSGa+gHQ7pAkQhzqE3Q1bExGB7/tWlW2jjh0OaVolSSq/lyMqh+BhpBOrtg1iZB5/ZqoDMjoxuiW7mG1rp5UsOlkDmLDDVt4OXflBUXP2kNkKNySpopC7yfKwloXvagpSy/1JqhM5khn6Si9EWVSao22NeM5uIOizYTY+2EJwz9lNpt1r7gqpTNaRlTPQrOo3q/R2+oM/dizpjKxYk8wEVZaANFs1CEFy3HrDRqxcjWDSWyxcad0s0OHWbUwojCwHZs7lJ1g9xX2tHI213700O8LyOE5ixkTolGDDce09cqvmgbZRYMS7drJ4lWD5eiOrtP20RdDqPX56Esnrzf2CS/QBluOEy842EMbmBMQOeZGu3Yjca4dUsSOXoz/iUMscLupS4mkSFI3F6OfhGczRLf8jS6aZPN/HfgUqtpF8BM3sAMVR/Fdk47MrZDWCdx/1RPKuNoeCs3PJi192GF7uWHqdjm/Xx2L07V5mce3Ni39KxFX5r7iaGjMQeVZ91vqy9+3UxREJDfHuE6hdmjjtdo6oxef91BxMLNHfLBVt9J+cTRDjwNVOdNUFADmHLGLfdVceHf0Jg2BOAWgHhMSstQPcdjeLV969TBBsyL1I7BxO76c/w61mxAR2G
 prR5OjdW
 X/ojoGuNoj3WGUCgr7UxXXcEKmEuWyUOSuxKEdUS5baKJ/QETlEVj17oGEOUXu9EhgHE2jhJD/wdstXe1of6Jx0Ktsow6SeJTDt+cfP9ww5oUerT762Sd6DQcFe+kAUn/S9Ty2gcbXI8+k3IqTbt8POreZD9w84nNenZh/gF9cnrFHwzWkQfJO05dMa+HAJXBLyV1tDr8IvhdxA4TmHvmC9fh3dw6A5cDWosY7sqqFmEMrKWpg2Fq+LPazc/zXuZffnxv2nc6SenuK7CSipI03EzMR4NSIdL7INTV6W7py7HawWxXyP30S20r28FUSd4iDxQLTSFPRYU8Wdo+bvapVZ7xNWliY5wyE8ENMsbgvpVtH6hpJP/YuTCSwLoRR3Y+cltz/Il6cuKkri3MGjH3SygHh4rQKzA/pG6KV+bAjWcpU0CuqkYmJJ9GoK1owGkykrZS8bONeRuSDiO1R1AHgpeknzZ+vLyOV0n7b3EbHVNXvMtLMtN7nqkWAMMgCLUqoVzc/yfxt937dV7HUPM17XvHFLmW2L2tsucE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_changing check in move_pages() uses likely() but the condition
being true (concurrent mapping changes during UFFDIO_MOVE) is the
exceptional case, not the common one. All other mmap_changing checks in
the same file correctly use no branch hint or use unlikely().

Replace likely() with unlikely() to match the expected branch behavior.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 2a6e034b15aa..dc1b3dd1aece 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1872,7 +1872,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	/* Re-check after taking map_changing_lock */
 	err = -EAGAIN;
 	down_read(&ctx->map_changing_lock);
-	if (likely(atomic_read(&ctx->mmap_changing)))
+	if (unlikely(atomic_read(&ctx->mmap_changing)))
 		goto out_unlock;
 	/*
 	 * Make sure the vma is not shared, that the src and dst remap
-- 
2.53.0


