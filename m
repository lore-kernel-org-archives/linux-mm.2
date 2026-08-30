Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D095FC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46F66B00A0; Sun, 30 Aug 2026 00:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9DF6B00A1; Sun, 30 Aug 2026 00:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849C36B00A2; Sun, 30 Aug 2026 00:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 573646B00A0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB2CC1A023A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:32 +0000 (UTC)
X-FDA: 85156631784.03.61886D1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0FEA6140005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZYfiTFLB;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063571;
	b=iKsaDKrQPXsFs771iEUcRsQvFOx9whRG06Eto/h6jyHwbedvtpH1ufWCJ5a0j0zHjM+F08
	FvtHUQbOQOy6555d9+acQQEP8aSAD8oPSJlb5HOoVPsAio4YaIQzTJkSNPJk5pm8kDmrRq
	SSTq8pOs0uFYvEJO4kQ43f6/PdCmmb4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZYfiTFLB;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrBK9zAVRuWrfCGTpwW8HiqL2BzA7MjQTeYnO4XWRqM=;
	b=DPhHrIqxT5XuR2mlNvImB8k+7iM/gK65b7ynxEuWoaCTO32n7GTZ5I7b6SxT3ORDbtEzcR
	Yp3jbBkumFAPHeb9Y8QH4l7YSJTlP17h/AzwUTOmOz4qq8aSPdzG10lw9i+cUbtEb+kNls
	IsMTkwT7+rBqZC9QwOHOYecMQoSctig=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=yrBK9zAVRuWrfCGTpwW8HiqL2BzA7MjQTeYnO4XWRqM=; b=ZYfiTFLBbqpdaWTdAiqc0+5xJO
	44XPrYZU6F4MGY/PtsCU8/I8FsN60fK+PLVNyFLOolQBLhPVG4oAy5ghiGXh3XA6i/J8LrLNlo1gS
	nRD1GPEqKKMUK1wKAK3kF8msLk4fxe0AnMcFu6iWeHAQ/J+5S2aFm/tnFPN7QjjcMKL2r40t93fJO
	iZEBXKfJRTsrPd1dKa/7324uldDA6fT9fizmRe62wSkq1l2cgf5cGHSNieSrJSrGjzuHeudQfxZwe
	36jH284GDJM01IX/0tCWU5I0AQj8pu6NkuPaA+ZB5fcN6kKlOk0Z0pCzUTrAL+zeI8fN6sy5EkstX
	GOyKOdMA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hQ-0aEV;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/9] erofs: Remove redundant FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:50 +0100
Message-ID: <20260830041901.2668-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FEA6140005
X-Stat-Signature: j6or9aju58nh3x5k6m1if6zh4g8nep39
X-Rspam-User: 
X-HE-Tag: 1788063570-114623
X-HE-Meta: U2FsdGVkX1+gpjpG+jPDSfXVmvckIRy/j13ZT2gl7DGKGQZOs6crfHrcY+e67h5yJE3cHaL7nqw/5BBTdSc9Y/vclhvq7s4NY1HFHFQfTGWlqo/C+JqRVJ/d3QWfoCdEXhb/l/OGNjTn0RD01cuEiG9p1Ff5meGa3ZGkxKH8mvPVVzumudGZdGqc7l+3V1sBaQl+5lNoV6LhtP6sdqQYv+H+3sPFRVAOr5auI1Lwu2nfJY1pQPqfO4DD8ey/NNyG7LDKduKtKbghbsRclgiRQ0TIg6Aq3Pzlq4m/bjWgKFvcGgQUcjBsrRFMVFXAloE1oIxna6YEBL2s6FElLEOwGsxCF8R6MGBw1xg+xHh9lBYnHTsFftKcqbKlD/lJGSWv2T6WHDNvSB9smPEdipbNt7aWF5ZYXSkz5LHHgATnFZ5tQWYaJxV3Z/ZUfgojnnTv6bmwHbS8/PEttXOMbfa5XHpTCM2UPVapzSJxfp9hjDCqxj2wzPIoJ5o5Yo0NV1yOOCaLo04VILdg4XVP8+48DQEaW68pLaHg9XlsE/k1NufV2YI2+hmYwlbsP2SAMwga4/Kf0yGepPi6GQM0Pnbj0aue/wINA3XXfGCp2fGRzO++BdLCJxE5RNWi+n4stcIuzPB089GZU1ASllpudK95gNwaDjYemxAnr/Cdn2bIfFjdpb+tptyACKIv31g1tcbivqj++b0TgxRqK4jWbJ7KI2YVmD9httasS6XRcXipoe5wR3VrvjVG3SVhM+xn2qVL860jKbS2CbWHh4zKq/Ncw221hLy+MRX955IVBvOEO1iKDj3I5tSCcJB2SMBFiVHXUSNhLt/SfNjC8lxzJEqmtXKUN0wkh7pl4IJ7/fgxf6lRd/C2aJJTDzSUu6MrFT2ovC2zlN/1HgG+zrMfC6YlL2wUtM7sVKA+WCMr22RXt+H79QR+8Ql5e+durDq60m2L0GpKIiLPmN7YNBzHcbL
 C4NqMNHf
 ySDTQj+E8cvuRJmakDMQNXpsHB8tFXhuQVwbYVAf/+QhnByMDgFxnrHkTuzQhyco2E64KO3Vky4xY6+qE7DZhAbunIxuHd5QA+CTqrjUE5CQuPaHj05VVRkhCts7S60Sh/1YxPnv9PhFlJM/fNjyctYbWG4McXs5DCsArGBXdcRaIPq/lV7CDy6A5GeoF9tGVkxnvnJE5d3mWKONnV1FSdFlPFsyhqNS4ZoA63HcCwKxKKnu1yaSr3OV5AqOX5a132N6e5j0Ms/0obVa2CxT6nGc+2hBZzrIo3Kwo4XISmxN1buiilzFRc4YUVUIswhNelfbHW31IHMm/uuiuV7DVzq2kqQuy4azkeKRb0MaGI/UxdIcXFX0Lgt3b4TazKYqlnwBR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The flags already include FGP_NOWAIT which prohibits all reclaim, not
just reclaiming from the filesystem.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/erofs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 65974e57aebf..84b3cdc8e88f 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -327,7 +327,7 @@ static inline struct folio *erofs_grab_folio_nowait(struct address_space *as,
 						    pgoff_t index)
 {
 	return __filemap_get_folio(as, index,
-			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 			readahead_gfp_mask(as) & ~__GFP_RECLAIM);
 }
 
-- 
2.47.3


