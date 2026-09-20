Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928EDC982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4A26B0088; Sun, 20 Sep 2026 11:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265366B008A; Sun, 20 Sep 2026 11:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1548D6B008C; Sun, 20 Sep 2026 11:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E23656B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 11:50:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1B3B1403DA
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:50:09 +0000 (UTC)
X-FDA: 85234576938.01.7CA9AF5
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 262DD180003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:50:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMDNu3VK;
	spf=pass (imf06.hostedemail.com: domain of devnexen@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789919408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DY5Gw4WLBwhdsQnGaRXBVUTHKUhqsOU+itnrh/w7afk=;
	b=AK/uUSAjDlrGbMTDpapb8R89ZQQ6GVXGbBJsuw5h6FXq9SRCg1oOu9mrOY88fiZ1b0GRfp
	QGbc8tOSwEoWu0ya+dbN5RZgRtGPowBwkCwqV0VP6A/6+hEzkRnfSrsZLFzSaFOOjr5bk4
	y3sam61vcEQLfc/GRTUa4O9bHORv464=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMDNu3VK;
	spf=pass (imf06.hostedemail.com: domain of devnexen@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789919408;
	b=Zy4hPds8HeIk9OQfUxPBYOrGzROPLzAgNh6SeZ/VwBtWkglMWPFyubVlagU94EXDi3eCwR
	qLjLWL2j5429YMxpAsUtE1CvuN3dkAgYe63cVGUevl+VegbHrKbiAUHZErYoWfxd7uKSpG
	eFfCOReagLTVDGh1YiiP/qrt+VW/ai8=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25ef7a3ce9so265075766b.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789919406; x=1790524206; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DY5Gw4WLBwhdsQnGaRXBVUTHKUhqsOU+itnrh/w7afk=;
        b=YMDNu3VKntlbakRL1jGNOJ6u1YxceDYy4hWN+/xdyQVunNHNdi17DMmMGr+KKb3t+X
         HA6KH+vJQE8Kg4Lpf+6Og28Bh1mkInq1Oat1XcIuSBM2LK7HQaKS3acIFO4l0VYiEDVQ
         F1YZ9gUW7Dz6VlUvYaJn/gm6s52PjZhWgqV3fR0a/SkGeJbayqWzKLBCIYYXMGMzwXTx
         K99LjLzJnoCJufTzDY+srfp1hawcCAVozyiNKaYFgVM6OHoMWyHeh01kvW5J5I5hldXi
         WvPKRfZbkS56HX8ZEhLMdwre+SlYctBKCjunWk3BkpIZnYBlGzzpAndB1s7d7rQyipQm
         YVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789919406; x=1790524206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DY5Gw4WLBwhdsQnGaRXBVUTHKUhqsOU+itnrh/w7afk=;
        b=O42M0WgCbFTUavLNMpdIlbPlOZyVEbrvxTKKSiIh/W48DCc70Je9DSuQtwFb4PDoQd
         5O+qmfbZUaWMOr5GtTyAKD1BsSbI3l+CqKt6HsDyL3lhC++kowQOTm/yIb5jF//MmVeH
         AOeOlNTPmQyTl6zPHWc14eroyN/tMKUwFe7fEYdBNOuePxDQuMMlkm5BEaGuW+m7A7y7
         84JNEwvhFftwHFA2W3WJHXjQHjuqSvBULK4kyNJYBZYfuECDU8nNH5e5iKZd9sGZVtDq
         +cZlWJnHuK/2Ra+TSfgcB2Q1c+O1gPnPFP5eSvUvDUh2LiFX7kWK2ypTudEveumqHAuB
         kKPA==
X-Gm-Message-State: AFuF++m2UTJWaDOrDTFqzF1ZteLigoN4+U9zMYC3WY8n2UsCtF7jAgxz
	BmGFVh4Oij/9FF6ZM43To+IgQhzKSEWiEXZRToI5mYDOFo9yKM1g6RrOWgmXWg==
X-Gm-Gg: AYBFou3RMJ8TaMDs7HVNVVeGTcgRUoTSkvc4GDcKk4Sr3SS2sJ2LavISXzf6AUc6zs9
	7ERS4MRymwYn4jZr7CIYt2XG/oXYWrjuJn2Wv25SLwLycz+L8yXgf0qag+YmAZ+kDQHCZIJ4r/S
	+aFVTmEmUszAKpViy3Y8r0pLVzuK+mJKW9HHcOYVB23rmg4C4SNUT7DsJGyX088H3SPBno+1Xp/
	N/sTGgiQKtAMRRndwVpEmPa0DGCl29hzE6bZXbJpu0GDUynsy12bw7cJoLEa7Pp3uuQ1PQxUOhv
	0ARfwmmj4M7j7AloZKLlvY9Cn6mPy5xdIDTpXTMGuL5lWmwXT/dePVopx8Y51HF4hPS5hsUhs9m
	4AgITTK7/L7XpXU9Fku0uaQUFdXYWLT9bezWUnDRiz4+EDG1NXp4hDv10WK5D1bvvPhrm0wH/Cr
	wIXB/faxXPPEundKRRRFe1Ii7a+M3FeACjBEvkqUYX+c73W7rsgN7HUzxAMebMhz9+16HjFJRpp
	igoujcHNR3t3DkzbJXtnyWMvnc43KrYkgb4Y1eQXrcaiReY4zeVV1k9S58=
X-Received: by 2002:a17:907:9301:b0:c26:2b63:a746 with SMTP id a640c23a62f3a-c2a15cea371mr659191966b.49.1789919406284;
        Sun, 20 Sep 2026 08:50:06 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a3590afccsm195356666b.62.2026.09.20.08.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 08:50:04 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	kasong@tencent.com,
	bhe@redhat.com,
	chrisl@kernel.org,
	baohua@kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	David Carlier <devnexen@gmail.com>,
	syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
Subject: [PATCH] mm/shmem: don't release a swapin-error marker as a swap entry
Date: Sun, 20 Sep 2026 16:50:02 +0100
Message-ID: <20260920155002.1030454-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 262DD180003
X-Stat-Signature: kfjgnp8ym3zaasm4by1fknu1qi5qacgy
X-Rspam-User: 
X-HE-Tag: 1789919408-134685
X-HE-Meta: U2FsdGVkX1/uCXtMU/ibEpXZUtLQHvfnnWxI0oSkVswr7aYkNvN+t4HB0dPo8hplY/IsXT+vHybYjctxH0igph0cw9t6Uh0fFMRl9mqqWoPgZwduc8P7bsvJ0ZkUOw4sQBlQsVgIaqApTcBZztARjrXaKee3hg3iglk/40k6NusuVL8O5CgUhSArBPT8M/qq2wnheHK7o7FsxK/Fo2WN53Nvrlep4dE1CcgpC++dOab/Es8/IWShMyUhGY30bFazshhhqilhi6r/L63hO8OHPlS/SZq1cMFDH+1NCZP9aNm2nyVDqtQkdfwfLus+uTHHLFJzW0IsCpbw81PhEJb7tHpFmKgpI9QdLolM4zeT4ti2ifh690Xg0mjTU5k+ZlkjyHLjsovYSxAikZ9jr1khmP4D23XmUrSJgjeCKLvpLRra/3saAN2oFCpYunT6AqfWdh/+hFVgghPHy1iRdv4mv8i3cJPxsNSH++8YN+gSADp1VTWT2OqaivIjUsdkD9I8e2HNGVf3wiwtz7WaB99TALAQpDhvbqTjjDi9djCMXigaBYLXM2ROM3L9WeRveCMPQStEBSwi/Xk1E6huRYPDnsVi8an5ZLIEL8M6+ywzrFqfy6kTOat6W6COCLEsYMM41VxjR9X/LzE/ggpx4RANp8yRgXnlWR9RUzYv9h2Kek2qeOhnIQcnNo1ssf5l22ZMmk/dCutfBpTeSNZ6gPGfsfNZVv1pyC4URUhVc1eZ3Q0kl9EESoYat2hX6bCYeOLAybYmrsoX7vIQR/BrbDe64LY1D2H1iLaezyWATjsjWBtEfZFsPnINTHs2JUgEMu3+WQTIOn0GrZCxM9iOHSdStQRcQjmF0zBD4Up4kWfBsdENE+nEdVqjmJ2CLHjnM+dH48eKkwZ0loTAIcGZcSJFRCic+WRwfJQurMDEc2RLDQn9JiOJ48JBoqSwt1Mca0vodknTkwK55bzOhuWFiDf
 q+7rL6tR
 lgeoa8PWJffU+HFrIALni80Gz30TxBe1K6isOt/V5v0VPfrvciIj1vE0cjiUsFincAJuXOrQD7u8BCnZ/X+/eCfkKYTZDSozYGNZxQCVXu4UcdfRYPypRpWcrcoIY+R9ecppEiJRquB16xi064xwhVNG8BEoNl8pYMO9bQvCOmGEI5SJFYoklEqwY+BbLCj0vOGct9ZLHGVWtSG6Ui5Kn43WyCLLmTK0tcSbfVebJmcwvvrESFzXtSeDk+YaHwf0qLm6/JSXPUnf+T3vOyyjsB1V5OyNxyS84LclHQcFuYD8lvCSz7RNRuHyoSLta8ixkya3HtpO5KHe4f9C83QdHAVdHxMcmltYRiQWgO3yEg8hI+iMJwVQg7tTK33h1bHaCMkMGAA/wkbaUf0AMSLE63H9VSPZT/KCJdsHxUAE5BAjtl8vl/IlNr0BQIKxpIjBGzKnYlG500YY+0orXxCNoODEXvJuVEk0+nuylUzVEuoDugvfrr3B/Muw46Z/uk9zyIokAILZAyFel4wpKcIh6KD80RgmZ2DT2uq6v6wDeQydkl+u4xNiidffT3yxSCXdNPCZXHlSsrBprF0GGoGoK3jn4BXC5u18TDdh6Ifmg8UBZx8nHKaDFRlPH03TQ9tLwD/Xy6eQmVZJRDMyleI007qjT8Nj7hEr1Nqz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A failed shmem swapin frees the swap slot and leaves a PTE_MARKER_POISONED
entry in the page cache. On truncate or eviction shmem_free_swap() passes
that marker to swap_put_entries_direct(), which warns because it is not a
swap entry. There is nothing left to release either way.

Skip the release for non-swap entries, as every other caller already does.

Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b572c60f2af8..94f2c59c8cfc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1184,6 +1184,7 @@ static long shmem_free_swap(struct address_space *mapping,
 			    pgoff_t index, pgoff_t end, void *radswap)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	const softleaf_t swp = radix_to_swp_entry(radswap);
 	unsigned int nr_pages = 0;
 	pgoff_t base;
 	void *entry;
@@ -1200,8 +1201,9 @@ static long shmem_free_swap(struct address_space *mapping,
 	}
 	xas_unlock_irq(&xas);
 
-	if (nr_pages)
-		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (nr_pages && softleaf_is_swap(swp))
+		swap_put_entries_direct(swp, nr_pages);
 
 	return nr_pages;
 }
-- 
2.55.0


