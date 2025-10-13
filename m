Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61AE7CCD187
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB0F8E000C; Sun, 12 Oct 2025 22:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA30C8E0002; Sun, 12 Oct 2025 22:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFFC8E000C; Sun, 12 Oct 2025 22:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC7F8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:59:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F35457AA3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:13 +0000 (UTC)
X-FDA: 83991584586.21.BB5D528
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9AE8310000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=eczotvSA;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf05.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6XqMAl0hhgv+pueu+gPbmnZHJ+gIOipzSWvNzlnECE=;
	b=N4DPRO/yXes7UPSFD6ywAeZmYn55SYiHSrnaiK4WGJKiQiXb1f1Rh95NaYJMCLBisjG6o7
	Yu6tX0AbyzFBe+IHUC6tZe9XTKXZnFtmjAfP7flUQSDfxH5x4tqHawCxw6rNLQ3lAu2VQP
	dEa4Bt8xIhGGGOFAHxePNEojU9W6ouw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324351; a=rsa-sha256;
	cv=none;
	b=BqdEvmyEv7ZlkfMBbtO6SbWG1i9G51NpsdaQEKTxvxRsjtzNN1GvMGfEZ/MKr2aOEA2Jwn
	UGPrxAATnql2zn4ywfKV3n0FIpHe9DcNPfIiGs/BzxwQShzb9uqo387mQWla7NAxY3GYSi
	ui3tZ4Z7wT0CpNCv53vW78KQtLOmzmY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=eczotvSA;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf05.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F6XqMAl0hhgv+pueu+gPbmnZHJ+gIOipzSWvNzlnECE=; b=eczotvSAlwu9quTnO/DHd+Ag+q
	DnbNC2oa4pQsv0UhWV82c22oGnj8ZQvOU9Ny7pVSGhaTdQUNQ9gaJf4DH6EA2NkxYsxSsgVC4RGhk
	4mI0tevqB4kMZWCEwwJUrTZZNR0VGEonrbk0um8sxEwW2nWsoNZLMmmwNeMn5xlxhrBpb6YlUcWCF
	HLQ/8hvGThOcLJzWWHEOdUUPsC/3HANOdQgKpzHkh+5ZBcreCg34O06/bKvGmO9JR9brsqAc4zk1p
	c61ey5nUKVM9rQ2DBsvZ/rmOvw9MmP+BAwSEyrsv+x/t0AfsERkTSNA4RR7R+i8m0j1XBx8NK3pcp
	8GNbRUeA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88mA-0000000C8J0-1o3a;
	Mon, 13 Oct 2025 02:59:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/10] mm: remove __filemap_fdatawrite
Date: Mon, 13 Oct 2025 11:58:02 +0900
Message-ID: <20251013025808.4111128-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AE8310000D
X-Rspamd-Server: rspam02
X-Stat-Signature: oequst1mgzkw9jsbbbpradiie1g3egwk
X-HE-Tag: 1760324351-950927
X-HE-Meta: U2FsdGVkX19WTxO/fFiWLkNaR3tAWvUZg3kYOSKPflx1LYRW95n91hKzaVxFlOraaLmqberLtX3JLtK03xo/65/zT1vWmgJLBnMwSxsvEiveM//t45LAdFyFVERXVCaPl+I5egkWY/2v36eXR5d7gzy6pI55SVg+JotjtPJl6vIaYGu+x3FtMI0p9Wy1TMAHkbqttXgEQxJDsU4r+f3Qecc5L3wOSwLdIL3wZdkZ2XDilcF92b5eq6BowSIVFg9CcRcpgi3pGAEFG1UehBoyEpwNmZd1grpvP63sSaYxYOom1eLLaPybHkX/DNJLWJWIPsGxmIV2GEtkrr4Pj0zuMzyJV48HxLkDQLETgsefUpnxDHBECjn436X29mMd+kFlBJwmTx1yNkBN65sfmj+nIqfNp6SgWIsk7ZAHIX9Ci3j1Od1/XNhMiIv5US9+rDJp8b7kfFLvu5Vk8TcEvFIdSYcT/5MdYb6D98/te1oOjrojxjYg35f6PyPOSVFUP8r/ANJLCcVx/RuTJFl9uO/mw+QgnkjCKO3mz5YrKHtSR0TK7CuaZnbPUJz1cOggq0k+9KmasIelE9o+hK2Qot501i51KwvM8jgpCZI2IEqtWeBGvimliWkpYgIEsGrsVB72vb/pK8fksmlhvXypjM9rR7vAmNLqj//CHyboic9e9ae1ru1cxMSUc/4qW0HJdXZMQdquO3jtSvAkcVasPteyjeHOHz4IEy8gUOzY5gsdTqxCEBsOalaio7kZhvH6T/TwWXRy0IeUtD6MWhrPJP36Sg1GuhjEJViHE46xJeUIvifDX+htOyiOd+WaXKxP8DHiHA6ooyJEeVRdE8Z329XuR7YVdnanO4GAlT81sMsh7l0VkUx1wli6spp/217jOwYVTcaYwSANmf3xIlFcd8b64Q+AHatEx+v6EN7S5SNB/a3pnwif+sMViS/NQoQIbmEAsrLkedwtSKMt2+mRX4k
 H8xx48Vj
 6wV5RQUQF60WdtSQr7EDuMTaFA52B7b6XmqjtQo5EgaK6SNcPGnA/YUJMW6HkvH8VJNkhXFpoqsDEvWPn2wPYZMAlH6qc3MtIVppaERlHI3Wh5xjyjm6HbuLZmhRH8SIPvTYEx0sCsHalkZfRMbP1o+AxcTOhrKXtpr/0B5zyxF49KPSVzsr28JLxDXdr2h0Ox1OhA10V4lbdceRO2ld6qXv2JbP4ly0aDS3e9cwBVY1LIqtU082da7djK/omWWaCEwkA2TO3tVtgdk5tUdr/str6tv7kKuN4zpyhwTtJidGzBj9WOOfqgUNSq/TlFFk0XfGvAf4bQ4mZKaF7A2BsakS/NouYsM+RHXSMJ6+RvAmmvKXWNdO3ETxFfXslm3NivSVZXk4Xe1CIXZ2/vJBDiLDzLKO5TlC+0FF1E4QGuomAzDmdAZwW8PtWGcwD4pDPF0c30R10YLEoQ7dP63WCq4qiLeGAUlaew5AEW04ekUaQr8WcjBwjvbslyYj4ozdrCiQh6b6vlb+Kd5xvbXbn1Ba42TV4TN42VJJB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And rewrite filemap_fdatawrite to use filemap_fdatawrite_range instead
to have a simpler call chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/filemap.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b95e71774131..bbd5d5eaa661 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -422,25 +422,19 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 	return filemap_fdatawrite_wbc(mapping, &wbc);
 }
 
-static inline int __filemap_fdatawrite(struct address_space *mapping,
-	int sync_mode)
+int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
+		loff_t end)
 {
-	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode);
+	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
 }
+EXPORT_SYMBOL(filemap_fdatawrite_range);
 
 int filemap_fdatawrite(struct address_space *mapping)
 {
-	return __filemap_fdatawrite(mapping, WB_SYNC_ALL);
+	return filemap_fdatawrite_range(mapping, 0, LONG_MAX);
 }
 EXPORT_SYMBOL(filemap_fdatawrite);
 
-int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
-				loff_t end)
-{
-	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
-}
-EXPORT_SYMBOL(filemap_fdatawrite_range);
-
 /**
  * filemap_fdatawrite_range_kick - start writeback on a range
  * @mapping:	target address_space
@@ -470,7 +464,7 @@ EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
  */
 int filemap_flush(struct address_space *mapping)
 {
-	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
+	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
 }
 EXPORT_SYMBOL(filemap_flush);
 
-- 
2.47.3


