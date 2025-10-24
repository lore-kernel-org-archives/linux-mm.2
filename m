Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25331CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1898E0054; Fri, 24 Oct 2025 04:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A95F8E0042; Fri, 24 Oct 2025 04:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E61F8E0054; Fri, 24 Oct 2025 04:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2A08E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:05:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C936160DC9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:56 +0000 (UTC)
X-FDA: 84032274312.10.7D4B2D6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 82DAC40007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pNGaYHZT;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf27.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGL2Ky/C5f4WiPo4ACDgwQE673KFrCXkKYNJpYlApDo=;
	b=SV2seMZ48o0pLSt+Ro/h1fNp+kQrhvxebHCDlC1Xf0HORcYMIq+CldeF+ETeLJ7sbK7Rzo
	+pzOd4DXFtel5RVQRhLKhm6c/N+W2PH5QVcjXexE2W3LMrrNVV8fewSu2IRvq/wfUUdzeb
	cHiS2+89H3bi67vYyCl2pSetN3SIFxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293154; a=rsa-sha256;
	cv=none;
	b=YFQ9K5ZpEtn8YIC7StXng1z/YduN5sCYdH4FaVloMzwiI182R+eV/VXNgVQUPLWj5UL8gq
	dkBy7SOjRuVOqevfv/DELB161GK0xw7HeBlIVHFmAUWW4b+WZE+y0oI7PCk0Hmcav6Pslr
	hd9TI0jGtRaxWkGk7t3nTmyZIp8+SfM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pNGaYHZT;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf27.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lGL2Ky/C5f4WiPo4ACDgwQE673KFrCXkKYNJpYlApDo=; b=pNGaYHZT2+pEkbOmqAAuHzvUCY
	tL+VPQrUf1wIiycXsLWAqp8LOwyNz/F/8Gyzm1vIoTBdLo3LCJqN2owwz5U/LKkNDJI7h3wkLL2pQ
	p7noeGxTFVC1xVvd3Fn2u+oSLeixgvFYYF6Iy38VjyFBUg/mEeTHgr/LW8dixMdJCsSHsa8b5eagY
	xknkONy2wiR1pQsf+fsTx/rCvWBzlNZEe0m4wfUB1t+0jQcRm1XV4/gkpMEdlWXKuA6Ii637MPEHv
	tVtn25mSzhPIhd/D5tHvzKcqOW6NXroJMKo/LL+BlrD6Adqnz9xwD7m3PBTdTzySidh5rfGx7yC5/
	H22fIynA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCo1-00000008cGu-2B7Q;
	Fri, 24 Oct 2025 08:05:50 +0000
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
	linux-mm@kvack.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 07/10] mm: remove __filemap_fdatawrite
Date: Fri, 24 Oct 2025 10:04:18 +0200
Message-ID: <20251024080431.324236-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 82DAC40007
X-Rspamd-Server: rspam02
X-Stat-Signature: hwwtz5p3i1j3yn39husnb17a175694hk
X-HE-Tag: 1761293154-54230
X-HE-Meta: U2FsdGVkX193Q76tPy07t3BNCqXlwXOVrk0WgZREA5bK+U7jiXq9IkBccBqFbNTLbnbEn1McYiD06Ph+xiB0nYFBLDUY8D8lougI7B3s1PzXwZ0oXLtPShBSNJ+a4b2nw56AVN+ptcPUdjw99f+ZBmBxAMcIgHa+6VJFIZW+xg+R2Vip2jj9b5466e7QT0XwlCGIEJH0hOY7/g8d9Fi1l29wIoMaic9HIYg67iMfmIAopJ7u0Nc556aF6OBBzp3ae8qRENW2i0y4kSoPPiwTMVx2H7+X1igjo8ZznYxVUuD8exXJ7sK3p7/2A6lXhzxyOChvTUpMomokpospp0RHf77EfT3Fz459yRUvqDf4PXoeavK0nx7ACWCqY9XnDGW5FMiXozMdR+a68UcsiKLvlKruzEXCvEA247b7WAhNEyLggrPwWxII4ko90eFx1tnJAGINeptl5UJnSVnaGe2IlGpvKl1jClwR7TNtxgv3arQdutbrHFZ2pKA+QKJkSOzVFU8b7zuGxwBjblAa3qzyaFCek5wPD8NQnLSiJDFRJI2Bc29+xe8Zzk2JqsARraCTreOxfUlwY7aPdYnydPwJAbZIT8fOEVPqmGdRS/Ocbk6jtwUbFtCS2jM01U2h8Dpsrm676WPquwinARwJ7e/L1yBnir5d3mqYg5xZYDmP7yns3aYqTWoRpi4np31OuskcxD9zJvFiEiZzM9YERmf37yxci8QQH/uDjmItSAzFuJzYr0XHeqLRQNVrp8X9glMEZxgxWU1pLb6gyM/XwX+pd6DJNfIjEZsFeyOYWlZnjW7HTG3Y20FN2N9C8EHcJnj/lYmQj0NLHin+gkWCK38fXc+WwmSuVLl9Q2QpidAUAgtUFAHuW5ImZ4C/fUUJn0/2gdUMDy7JodOBwYi9BPauR3D9qNvSePac29w4FAsXM8gt+kXlw9Spp/vYnG7Y0IqPVurM1bg13l0n2ILJj9+
 PINh5Avr
 Cfntw11uMRwQzDBZ9n8H9VO3ejuE4TJyy8Tj//YlIHB7W1T8WsjxWvvq4Qr3SJJMFLLwh1aDLMjmdUvlEJ1Kqqo9vsjm2jD1hs6Un8+oSRjq5syugTev6QyIfepNe6ndFSulvxcWWvorG8GBuR7R9wV4P0VwN9a6Hjkt/la1X9B1wIsYHDHSrtNWo6/sLo4eLfxVwSvkR8nTsICtZBihgc9QhMclVLo6e0JnREJ1CVqvo7v/sbD9oVo451Woq9GkOmFFIJMSnSx0HScZnj9R+2YZJ9cq9s5SLSmmUO8dFtGmeF2/Ndd59NjrUO1pyg9t5A2rnAN80OCPtpA5rynR51n/fq19jTcPZX3kl/W4nCBlQDVzwu3mQs22r/z/LFgdoQWn0Ito23euQQx9dxw+cV6vxz1vwGmGiofcZ7LgmB/nQn0RG165IdD0VQ+74mhQXp6N153PPqNy79gYznmHAZyTHmKVZSVCJpbf8yZjVsvc5xK6dd2cDsK6BBuzQI/OIjo44B+NEMJg2CG0oP3XcGkEm11VNqaHIIzY+pDlxkV7E3or7XieS50/prJykYSp7ERHQTKAYDW952hJuDcQuF15HnqyvxmN6d02PI63mSYMKJIdq+M3uCQSFdTVR3uOssadH14aty6HUCevQ7rSCrEHo5LUYjYhs2QFGgtjcqMPibgh39yO5R/mAPuOeURKDiCpF
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 mm/filemap.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index e344b79a012d..3d4c4a96c586 100644
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
+	return filemap_fdatawrite_range(mapping, 0, LLONG_MAX);
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


