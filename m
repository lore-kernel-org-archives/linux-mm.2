Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9FA5606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 07:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OhxvzF3C
Received: by kanga.kvack.org (Postfix)
	id A67516B00EF; Sat, 31 Oct 2026 03:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A170D6B05B1; Sat, 31 Oct 2026 03:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905C96B05B2; Sat, 31 Oct 2026 03:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDC86B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:05:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 175CD16089C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:05:27 +0000 (UTC)
X-FDA: 85382035494.24.9B457BD
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A704180004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:05:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OhxvzF3C;
	spf=pass (imf16.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793430325;
	b=TEBb13WkFSx56qYr2MJbSwXZTU3TxIbYlC5y0hSxB+aJgxfulg4ERB9EpdOnrWFCcP64vI
	QblQrTv3KvQeeF5+w/W2le3p0m+5P/HP/kJtLd1PMQq2lh2m8ECGtbU4jnXSeOXnDzX03o
	wTD8NFqiT00+2cQFzJIbd6hwm6gK/ms=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OhxvzF3C;
	spf=pass (imf16.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793430325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Iufanw/5KFAPDTTrdzVdPmEyBabAy2noz2vvQUjeASc=;
	b=Eo+TwOMdcEEkbgnqcTxUiDXWfv9EAjStPsdqKYWh8O1fqYZxNBI/xYf6KPjgfOxPIeBxS6
	55Ma0+bdKBve3VlhEFhmgQqibXAMpUbzvGUZJs3WZXsOYY6Wtd+DeVltLGtD6UmyMbZ4Q1
	hHTSfsdAUCh7ueIfwtlEW7lFRz+jCyA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso9675595e9.2
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430324; x=1794035124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Iufanw/5KFAPDTTrdzVdPmEyBabAy2noz2vvQUjeASc=;
        b=OhxvzF3C6YlmAfTnwdXrHkeB+fjxS8g1GprqIUvhTCryZgTcECpAog2B5YFslk5JNA
         M/dKptN3GOcjoCUQpJc8MUT6PRtwUo2EIsX7nUE8y33iKqpR3VpmYZHdyhZB5ejtMlPT
         h6WEoV8aifO7hAOL6yiMRwAqZI430vxWvSF10KwdQjWKbd2OOKmus/oAxyNWMe+ztX8O
         vyRo/yNAD3pr1MtbITTLd3N1JnOvcqSKazAsb4qGUNH2Li5QOo3jcuj4A6EL0JtUZG0P
         idATRFCYGouunpqVeWmSdWq9W49nvgJcy2sC5OSG2224sDZ/7nnDQwoVj33SQwfpUoTz
         /nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430324; x=1794035124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iufanw/5KFAPDTTrdzVdPmEyBabAy2noz2vvQUjeASc=;
        b=veS6v7b2/zMJ+K3/aBz2Gun3/nW4WvnZHKNPFV+nmHfeuDwHjzeWH2KqhguB+ittc3
         ehLrjVzyjd8nQq4o7CREZ4GggrVgqylaVd6mV72J4gKF2GekYL45CKNIQ7mWAF9FfFaH
         gNEGk2M3GZkkcO04t30LmaS6VjJZHkwxYUj7m83P/zgoMzphqiRzU3v7I2J9q+6kijJh
         t5A/xFEKcl21ywM/t7W4lXJL40aihWKZslqBRD/45KrEydRxkyAeJfbvOQ6jaLz7tgT1
         sHtsMwqReJucq1ZoBeCgD4V+sbc5PGaCzD5VNNDxca+FTqnmqYqisPEWdxhsQ2q3yEb+
         oXvw==
X-Forwarded-Encrypted: i=1; AKwUvByfGhqFgwu97BuIrrb5Adyyq9MxFdHsiZhpesmUf8pt2BnEboiy7KvHkLIIEkbrThrmvxLp0I6+hg==@kvack.org
X-Gm-Message-State: AFq9FYINPDI5jQmq4k7xUiAJjdKNkhXi7EfM4cjJLrfD0oE1De0sBHSm
	aD9JGYRvf+KyefrIAEw+rTU1OmhCnQqE+3Jv2BJtCl63iSsGeRDvBTUv
X-Gm-Gg: AYBFou22bb3xKf4j3IJ8wHq7V1xf78Z5N9CJk3/IIeDhLT5iI3oD6AlL7K1iIwBMw7s
	AoQk7TsDDQNbY2VdVKullLJeosbdkOEdYfun/m1WI50n8XuxN2r1jn2R/gfBc3X6PamGgXKHZiv
	O4/beo5WT7WemJF2Axw4fwg4EYUkZ2c4xp223OmeyzMXXfRH/zDqulngvTm64pEr3QD5If989Ck
	RVP5O2IO8r/1m7f5xLwbooraufjarTtKuNA7zYJ4tZrPtqBxbgpiVkS9VGvwW85t3OCYr0vY6/l
	fG6V6sS/XXYDHDopPfuTlPZSm3s7uyX/k21kTMNwjMwzmtUOKIDQb6h36Vzb+RKSSeoHFWZbuIy
	yGziCX4RgbNdFyndKCiKUgwEs4evc2fQqYh8qwogWUJ585c9kHnxSEFrQgzVGINBo53p7YYG2hd
	QcfdfMArKpCJhlqaxzS/DSuDnDC4CVMQVxpaJBcYWfPlec7HqO//wNmMT9yJGNwica0s7f83j8u
	uMLq+5QEyxJuSt3VpglMdBbApdHQzLgBMs6eyG7pgLdq/wbchGDsJ56k3q+clYfof4T4wXz5z9v
	XM+XhxBNtFggJ0/ClgXOk4jOY8MCjQyZ6xz8flkz8uNe
X-Received: by 2002:a05:600c:8b0a:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4ac1709a200mr101686865e9.16.1793430323735;
        Sat, 31 Oct 2026 00:05:23 -0700 (PDT)
Received: from localhost.localdomain ([2a06:c701:4773:6f00:c8d4:ec29:293e:f39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09cc3e9asm46827155e9.3.2026.10.31.00.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:05:23 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] mm/page-writeback: avoid unnecessary strictlimit background wakeups
Date: Sat, 31 Oct 2026 09:05:15 +0200
Message-ID: <20261031070515.3042848-2-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A704180004
X-Stat-Signature: cqqqxhkdcts3pmx9rci17kq3refb1oi9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793430325-843137
X-HE-Meta: U2FsdGVkX19yXrL4rDPwRrUX1AwkxtO4cLKVojDUMCJekeWdOayx9+/8LE9RpLCnD36eDEfn0swCcO1+BmvP2YwfGfx/KOxTxNkVUPQ4qu78EtfJXuPICF3dpesl9B6gi4ezRSukR6cIkfgP3Pst6zxy3pAmObKz1JRXW+RbS18UHOmmAZQtjMCiX4ZnwgO1FFwTIIReaqiKM3l+AjVPXOMzptlUnb9Yqgq8sucLp315Vw/N321qHoiSlvO0qYbggMxiIklwNRsnH5jWF5v1tCRDe7WQ6my4R8pcb9rAMDW0HoS7CaMxi4Hvq2gQkLRLQoyxp4xn6sDsspPiDrE6RAmu3d3uW4VtJiQa95PSKZwPl5wB0Z8oXSIBxABHlg/CsaAnjw3lXRhNbJnyNDHaaLokmK3F3tGVAyv3LtUJuy88mKB7lIcoVV1G6KG8BCrlxK1atJ2J0nTIIoz36h+IIq74R8SRd9l1Uh36hJYs6+VnH4cmqHCPAINBraP07OUK1hVBd8wVC4ZQj3ZBwchXuK6HEKTGAEASDGy2fitqkMp3NBK3TMaexBarL6ytnVt7PiPwRb12Eag4aRtj9LaAiZmaEx82zE/08H+BhBi1iDzz3A1zyVuXOGYyT9XFOXIbmRB7+5TN82VJyb4HfZ8MiER7q8zTfTTZic69fQiesRrSBZafyO3bOKj5E49RIp1Vy+tsozV1hpLMO9HfqcxbkPotdT7YfA49CQK192YXitgVzDfd9KRoz+3clh9M6DhT9U/27arIQwX9kbjKUBFZDfhMHqg9d9ZiqAUwMjnQqYQW8fnSDvaadAVXB/PlGexu2/1YiJlNKvFynE0Kp1ObzJPUOddJdKYGtfHrJd604HBfNrLaDYNgolK3oi9Im1Zf5wVSwdDxjnCa1FvK65PLB59T9+zEO9InoCVhx/WiRFD1EPQKrAfQsimzgeCGRbq2Qw3DJuqaINjLzFayLmQ
 GHMtGm5e
 gefe5vBrrNc7KQNyFdEKZUn2MeDWjknBBthOt02JTaSI68zJQxo5azOL+IzQ3Ril6fL1Phtdeg2EfAy7Zm1Rkr3ynP56aohOpqenQhwFWtWC4sf9vjXoDwdmo9Dd9pI381C/PNNoO8lSmCdnmbU/xLMpiwPU9vSEaOLWQXhybmQrUczTfFZMz5dhb2z7305vPJaRQL3peVa65YyCD8HhW+KJxBXviS00dmOm4BN6ee/DDkhMOw9zE8T+WC41jYby5iwFel37spioIei/9tQNcOLFcuVCZHk/8OCA8U+Xwo7l+jP2sHYFkr/FdmOcxGMIcyjfW/Pr52i5hBiQZfOpG0hF++fECH54xxnckykVM5GGxEmZazCjmLxB2D5JccRGDbrICPRsSc8IzItnKCuaNMOAsgGshN1M1wOHr6O5qtZIRy5U7kepTwXd2v2sBbeYWNkxP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

balance_dirty_pages() includes pages under writeback in
gdtc->wb_dirty when checking the per-wb background threshold for
strictlimit BDIs. However, wb_over_bg_thresh() only considers
reclaimable dirty pages when deciding whether to start more
background writeback.

This can repeatedly wake the background worker even when there are
too few dirty pages to write. In a 15-second FUSE writeback test,
background wakeup requests dropped from 2657 to 682 (74% drop),
while writeback_start events remained nearly unchanged at 99 and 98.

Check wb_over_bg_thresh() before starting background writeback through
the strictlimit condition. Leave the global background threshold
check and the wakeup required for dirty throttling unchanged.

Fixes: 0437906841d0 ("mm: start background writeback based on per-wb threshold for strictlimit BDIs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 mm/page-writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 499a35473e4f..cb0c58715b93 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1826,7 +1826,8 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 
 		if (!writeback_in_progress(wb) &&
 		    (nr_dirty > gdtc->bg_thresh ||
-		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
+		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh &&
+		      wb_over_bg_thresh(wb))))
 			wb_start_background_writeback(wb);
 
 		/*

base-commit: 36aad21d50d1af3f6954bb0c988257a908202477
-- 
2.43.0


