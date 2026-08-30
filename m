Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4826EC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1FB06B00A2; Sun, 30 Aug 2026 00:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9D16B00A3; Sun, 30 Aug 2026 00:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0586B00A4; Sun, 30 Aug 2026 00:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589056B00A2
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCC981A0237
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:36 +0000 (UTC)
X-FDA: 85156631952.29.E16534C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4021920005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jmnyzAGh;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsfpWnTEEugF5BhxxP0f5NSzcOBwxx6do+o7r7CRpoM=;
	b=1ZdgTCXzHjbFdhRmAgmsTEUQBPStbmTCgucLhDukJnf6+Q44mf7vh0Rg9S4l8GOERUjnD4
	GH7VnTVc1SpbV0HHaAgImePLaD82R6tnGWRGX8JCm4SuxHc9yL9OZvQuuwhqOgVpMx+E7J
	0G4X1rMs+AgDcHcSd4cz9uBH7SCkhD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063575;
	b=nWK6pvwPAZv/lC1gc1Ik5OY9gQJPnE13dx73g4M6mMVtUWwvNzTksZHRDQGkQ83ux6KrGa
	+Xr6K99KghEo6NoQOgLRV6Kk7L48S6E+R06IW6vZhK78DoYjuFFUZ90ZGTNDF9fZFQ/CqH
	i2YlklwwERIGHgt3OMK+ydWD897Ke/k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jmnyzAGh;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=tsfpWnTEEugF5BhxxP0f5NSzcOBwxx6do+o7r7CRpoM=; b=jmnyzAGhnXUs0+C5LS24e7OvOs
	zECGaQnz/K7uDPY+0u1wIf57vrFCgxSAVDmXvvj2TMBVH3TwhpYMMCjU/iKIiKTFWX3wS6ki66JzL
	u+cDYy9gVlfHAwnU21whEjN+K2q/N4jfjfUTBerTfCmMcehN/SHRRgR81UCMVMH1utVmJ4lkryx73
	gukk3XpXRgPtZ+cK2nFL5ks8imp9XnV9WbnbHY6KaDnzoVrezcKyrtL4QpAosis5BrPyRe81xoTst
	U6BQxwL8QcjppnnEieucNP8b4nPqOQuTwxvZKv4tOIF7s0w4u3IBCUeo+jof7AAqQejsMCVDHmuHG
	SfbA0xNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hS-0u4B;
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
Subject: [PATCH 4/9] nfs: Remove redundant FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:51 +0100
Message-ID: <20260830041901.2668-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4021920005
X-Stat-Signature: 7s7xktmohnz58frx31wbtausqqud7bog
X-HE-Tag: 1788063575-277884
X-HE-Meta: U2FsdGVkX1/0N1SQ8bZVGwkPez2qhsGoV6ZyCKWe1GNmcfB7Cnm6RJa2Y3M6XzDyAcN7p2n9jnRzGSwU+3Idp5OixhbiY2iuNUOcUaoZxYdmQWzHwXbYumw/Gh1jmhRD4a4w8q2mtRJBmhP42obFu9ksJPYXVP0jUP+rTDlpZs08Q+0T3tf5wr68fLFMe82Gs3vOspemYUKQ3DXHewxWIzkYM0s0068cpBXqG35Rm2klu03CbxjSCbIoS/3V1ST8B3UY7q6MtXXFaLpademDDLmZYVth21tVjAi/z1K4kexJJOJkE1PQwnlyycE4ttpOwW+7Bf75QY+qS59YJNECyChOQo8u2h32I8uN31Z35w/JXb8ZW5p5KbHeF6XQk+GRbUJBQ26suGXwsu/CBDLDW3/ZqibTwYERHNje+f7mu2mPbx6+Crn1mU/cOT+K7EV7PA/TudqeWFznLFUW7BKJ7r6CTO6rYn6jMzU0flikcRB0+GSqKERPrQrOCbCIXQkQKZ1dvxSllxeuYuxsiqHwlTIuZNYr9TXBWNfd0J7klRT3lqduxez6kgAgxD2HWXutDMS7/rzbczgZXKPDxyBrZxnSYx6n5dQo5pbd38olFrXHv6W05kAq6ERYWAcifWXmNADXacWhWheNeoSWEPdrf1GNgxYi8TWi7iF0D+bvLSmbpjzsV5Gv+dokdWwd3T2lwyL3XGWflr5tNwHVd1HwkSRjvi9MsqmaB9TlISOMKMQ62Eg0qzSTuCaqQ5Fmw1zTCaSSfmTccDU3QVmRC9JA+BrJEVfqDRmKQ5rEdzGmmkYBzokqLledv0V9wZWfPP9TqYnfN+x3V8XTkT5sp0Gbp4cq6LUu3DsPj87tHTdlXOTvt/p1zqXf+k2AZDRqLYe/f3WsHUhjSDVLhSXNf/AA1s3heOGgvgfbh10wVEca/VVxH95gcr9if4hIGxmLFlEk0stGonBfBk6k6XOnqYL
 OPLNOr5O
 7Mp1NsQwEJEf124Y3XE2i2FJtw19W+wWuAagVQRvyQy0C+OO/jW7kHEgBlDfLqgfvstaPCFxTf+gA42xf4UGc2Sya2Eh7XagyR7emEtHXZvZnQveuaZXd39nX+NNsFtC7EUMpH7coI3IcysxDzdcCX+jjQNLu3xJQ8pAsNL2vzZLYBvZI8LII298uBC6Rve6xvzFH+ni0O0Lg5Ee0RZaKNZkJx7lDpmt9O6CDglvUb7cEX8NixJRJ5TxLH+CzjMtWbx21A04JoZSQRSl8cjYC3GjARGMy6JYH8niMGs35CXcCSJmNR/G5QTgtLtrtpPKNZbIc9LYgaaYgmIDnON8goS1u60s9dwRQsVBTr1+Tk2IIQ0Mc5hPInnn0yA==
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
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 49394123bd09..e34125a8a2e2 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -447,7 +447,7 @@ static struct folio *nfs_readdir_folio_get_next(struct address_space *mapping,
 	struct folio *folio;
 
 	folio = __filemap_get_folio(mapping, index,
-			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio))
 		return NULL;
-- 
2.47.3


