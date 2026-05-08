Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E56CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8AC6B0281; Fri,  8 May 2026 16:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532DE6B0283; Fri,  8 May 2026 16:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3466B0284; Fri,  8 May 2026 16:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE5D6B0281
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:20:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E77491C01E5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:44 +0000 (UTC)
X-FDA: 84745370808.22.098014C
Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
	by imf05.hostedemail.com (Postfix) with ESMTP id 337F2100002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vYBABUQy;
	spf=pass (imf05.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MErEmjiki8eLR7tKMnzhamgQ5TwvhrTV3RrgO75bht8=;
	b=CSbrMipDfwNj0aG0qU8/Tl1Ier+N4eCcnI01qG+pTsr1SStE83SpxapHK3XxCn1Y7eCxiS
	Ho/ZzAl0vZtop3PKAWmPDc+VzixOMNlhwfycRqK/5UDcMc1RFGZFHzA+7UzsOTYJub70En
	DjA5VuOOwf2GwaVLky++CAw6xJZlOl0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vYBABUQy;
	spf=pass (imf05.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271642; a=rsa-sha256;
	cv=none;
	b=zf7mmygoJUQm7vL8+EaBXmX/6DHU4e/kmQgXXOeo6KN55J7vBULB66e1azQRBlam7TKZQs
	faXXkV/VZ49Cyu1Wd1SJ2jAa6lBZQPbqp99kH9+faFm+B98L1e8KS+izUCYhLmREnxD3c+
	KhGQ9uvbosDi4LjxLq0yWRAYa6AYhOg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778271639; bh=MErEmjiki8eLR7tKMnzhamgQ5TwvhrTV3RrgO75bht8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYBABUQyN4SGyrmC9fWXOgwkHP4srN6NdhgFTcsfRhoh1Lo5e1ZJ+31fVmaTlG6xr
	 VFQvbxfkUbbBK9SLc0JdvHAoYmm9c9IHeu58S/SrR0l3NqYjgfNpkbGw4AyAWq5+ML
	 Tnc9tuj2FfT8GHl/FBMzMV49dKyTshV5g8bZVF0E=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 52124024; Sat, 09 May 2026 04:20:33 +0800
X-QQ-mid: xmsmtpt1778271635tke1hdcuy
Message-ID: <tencent_2B796C8FACDD905B3470C93D072BC2CF2B0A@qq.com>
X-QQ-XMAILINFO: Nwte6vbuj0Eq+xflc0glVhK11CErug6dGLe8F71ZYm74Myk/sg596Jj4bJ5QwL
	 Xk0KOfEkVY4f+Ab3EaMi/ET48FUl9wmDKfhx1wov3J+5pII5WnkIU4kEKsRstbH696zW7e3IbARA
	 ZRPNpqUGT10j36xKt6J88EKj6j9vpTNdbMtxaMmJ8Q6hncry+fz33iaQ7TrerYa7JdO0VuaeNcoL
	 PQTuaqdaM46epuKA7OiRiJ8Ui8RpMXE/rXr50RYIYIG/uCanWRTkA94HtBCyVLhfQTBDL9ME5gtf
	 4kP5dQ41FGEUkvE+UABBagk9nV6K4XVzRVh/TMLyQnNH2IYLU0Zu76aCR1froDCoig6KzhKZhHjA
	 wEblB9hS9fxvzSJ+VdvJZ65hk+/J3QmD1SLhKfReWd5k1/p7R1Zf3uVsvGI4UX8Hjzt/fKDLFUrh
	 KmFAZVf7TIun2O1eGTkI28lgilqvN+wB0JINKhPlKCcdm83bPWZ/r4UuUKeMeiJAAExKnOwte03N
	 XYPLlKPeaqEYVbXS5RH6rX0gromLrzUVyOVCTMUXR3So+7z1nja6jZ7sRgnwz7oe2CW5ehSTYuN4
	 RRKYp2qg5xQB2/b9C51wE+0t4Ez148iStBWw2jTyDrs58/MyRBzt134Rb6CaSzNucayK4bJn2sKc
	 KctXN6TbwcYY4k9UJ2TJDK5+cfb1a6V4GHl2J3mJU0lBxDH0Ww+fhNsg8xwE86JjGzicRuY+a04C
	 gMGV0c/sYLGmMQ9/62ZhCIGyeEHejbeWvCz0/D7QY2EW4ypiYbzjYnuL+Zq+StXMIPrSOILz/wXs
	 yMI1AHJgS50gnen0/z873KWQ6CX6+OOk08LrsMS5OcWiCN5MbK6dCVVZd2nX6kPQDLbFFynyXq9H
	 00BrsIlEQYaj9qr8XoZu2b5wK6HqkN8d03m+4jmkrvm5yPjSF79+W/3duSTTOTvVi858PpRnzEX2
	 aTJUAIEx2k4pr/gLQMQz3K4zKL7kn+U8IlIwYAmjoHWf8uMwFDmw+IrDLf4lYGSUsebwb3Topt0h
	 HWy3ImDYhOVIwUKLEMVz2MlYuq+bhl/DGt9evqeDSlljxebdh6
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 2/5] mm: zswap: add a zswap entry batch helper
Date: Fri,  8 May 2026 20:20:30 +0000
X-OQ-MSGID: <20260508202033.1834876-2-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 337F2100002
X-Stat-Signature: jk73rysbrobipnykak1hyobcwrycjxws
X-HE-Tag: 1778271641-21981
X-HE-Meta: U2FsdGVkX1+0SBt7EcN05rQrw2DPFpkhMc3iqTiYkVxBbEPhAxvNqn4aj/3P9o7mZ7inFYYy1GCpj5e8w2N3yU1bCmAbOF3HHIkzzBhTTSk1j6HDTp205saawuTTH7FRO1EzPGS8/bemmtOt8n05oPeIgCtNeCjYBJtXZsmcE7o4YbHn8Kr2VJu3QmR344/rksQfdXDXqLSUCavUz5TM0JQ5t3MMafegPPmSK+QQ+ONevQg7mUdYqh/cSM2GmwBEFyW0gnRzZRs2CsWhw5tB+Eb9vAU9wzgfH6uI+X4LsrUBGjvipHbcKMKo93RyRSFBz7Uj2Jyn7OVB1SaOUMIMmtGVZEiGa3Ga7OKUvGSIQRuHKug/6O070ft400Ia9Y0yhiHiJQOPCVkewafODlBwYQhtn25d/uz7jh2/s2hHQCOOoF/DwBcbkAFRLCfaeKt0acmaTAD93lCPiK3VNvRnFSaA0pM/Cg4zCQ3FvOZUwnetKpQgmK9dhLhROtX76GKIo9hroz4G9ufT9uMxEGEhuHsg2w3lkV9sL3uSyKSp77vE6vpDTA3P117RluELkRIPHCSBjfXC54QyhoREedwOrXY4DBe2tvVTpb0bqCnYVWXQu+cbhjsWLKWADzvgIYWCqSBQ7XEpzZxSVO9o4tqf+YMHe0UIVPKrKmMCEdNKTnMEcq6+sa8s+oUoGYvf17e/Vl+CKDvqfkjE17Zl+PcBvSQ7T93QYblTXYNgiHtuPwW72sapaa8zv0401FkxQZgMK+8lIZ4SHrRE97lpTHYZKFCvB48D5E0YiEelw174kil6wzokxqAulcnyW1sM9vR1dHFrnwTs5rYu1bi6Yg029fJEkasu5oxqpmkcaf9s61R+7A9JEiwvEGsb/fFe7x+T8XTbG4jkomdid9GlDVFh0nF6W9T7ZWpdL9DaVj2PfOOuChvk5Chf72UCcqssYRE/xInycpZcofGGNqV3OFn
 KfkpTrvB
 NReQyOHL6JNAej9lbrf7Gzwvy3BouG3YwEcIorjPo1qUve19VDwSA1WOX/LrPA3CIEFov0/MdYQhFYdLQfAxK+F45rx+sP8q0v+bYBS1lgccZUcLZLb6NeptK8L6cQn8VsNwWZ8c07Ob/dpJkC6F0m35aLgHIRVuh2gQiisXi3PhFht4JYRz1vglFBCaC65gtyl6dYMfQlHX9cIAzoClFtitoeo5431DkUFXYe1McECAXx8J544FBg4Nh0roz19dHes4L/+gbTkedDPVvU68b0t7fc3q39MQPHOK53CVFVeLg4YpvcYeANnSND8IZ9i0mjiIk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large folio swapin has to know whether a contiguous swap range is backed
consistently by zswap. A range that is partly in zswap and partly on
disk cannot be read by the existing whole-folio swap_read_folio()
backend selection.

Add zswap_entry_batch(), mirroring the existing zeromap batch query: it
returns how many entries starting at a swap entry share the same zswap
presence, and optionally reports the first entry's state. The
CONFIG_ZSWAP=n stub reports that the whole range is not in zswap.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 include/linux/zswap.h |  9 +++++++++
 mm/zswap.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..b9d71f027200 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -27,6 +27,7 @@ struct zswap_lruvec_state {
 unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
+int zswap_entry_batch(swp_entry_t swp, int max_nr, bool *is_zswap);
 void zswap_invalidate(swp_entry_t swp);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
@@ -49,6 +50,14 @@ static inline int zswap_load(struct folio *folio)
 	return -ENOENT;
 }
 
+static inline int zswap_entry_batch(swp_entry_t swp, int max_nr,
+				    bool *is_zswap)
+{
+	if (is_zswap)
+		*is_zswap = false;
+	return max_nr;
+}
+
 static inline void zswap_invalidate(swp_entry_t swp) {}
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
diff --git a/mm/zswap.c b/mm/zswap.c
index afe38dfc5a29..27c14b8edd15 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -234,6 +234,42 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
+/*
+ * Return the number of contiguous swap entries that share the same zswap
+ * presence as @swp. If @is_zswap is not NULL, return @swp's zswap status.
+ *
+ * Context: callers must keep the swap type alive. The result is a snapshot
+ * of zswap xarray presence; callers must tolerate races by rechecking under
+ * the lock that matters for their operation or by falling back safely.
+ */
+int zswap_entry_batch(swp_entry_t swp, int max_nr, bool *is_zswap)
+{
+	pgoff_t offset = swp_offset(swp);
+	bool first;
+	int i;
+
+	if (zswap_never_enabled()) {
+		if (is_zswap)
+			*is_zswap = false;
+		return max_nr;
+	}
+
+	first = !!xa_load(swap_zswap_tree(swp), offset);
+	if (is_zswap)
+		*is_zswap = first;
+
+	for (i = 1; i < max_nr; i++) {
+		swp_entry_t entry = swp_entry(swp_type(swp), offset + i);
+		bool present;
+
+		present = !!xa_load(swap_zswap_tree(entry), offset + i);
+		if (present != first)
+			return i;
+	}
+
+	return max_nr;
+}
+
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
-- 
2.34.1


