Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D84CCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123CC6B0095; Tue, 12 May 2026 01:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100BD6B0096; Tue, 12 May 2026 01:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0112E6B0098; Tue, 12 May 2026 01:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8D9C6B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:37:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 830B58C907
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:16 +0000 (UTC)
X-FDA: 84757659672.16.532AA69
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id E34781C0015
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BKwVZyZB;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf20.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Hw3XcDONqEpFVCAFM8gW1FdoetT8Zbq83oYUzuqJBc=;
	b=qbRTlVp3FbrMEIV++ImxG8ZuaIUknY7xjFyRJs3l+pk2dygoqzEiPHD1oiCgx4CvRPcyVg
	cJYGcu91xMDtyg5V9F4w9qPk/SBaO5jLM6R8imFen7XYcqvyGhhISQ1u92NGuBzrhBVI8Q
	UPUs6nO+Rl6wtBk9Yv7eGfU29Bvign4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564235; a=rsa-sha256;
	cv=none;
	b=StpgAv8DsS6QNPYM5Um7AzaIpBFOhYYDS3FUa6TAgmqKki8PjMYsCxMmboXjeCEXnDbcDt
	ObaCQepSIT1S//+w7muE0UVlD6hPOTFQTRxLcetimUT7dRymYSZ2u4L+ut50VWKxwqrXpX
	fANZjADKZnybQ4Ckn4zB24pJTHibKRo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BKwVZyZB;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf20.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1Hw3XcDONqEpFVCAFM8gW1FdoetT8Zbq83oYUzuqJBc=; b=BKwVZyZBxahKZ8ZxCxPC6Y4z5Q
	pBiOEEqDkyx5ololy28vqASvBt4xi35sl0+NmWmVYePnVyQ72qbz3HwzDQq1AstWN25FRYsfZL4yD
	FMnezLkwXChwq9Lg8k2aBxxz9HNfyNtpVLv573yOfNZ/eB9CP1TIUvRVru5ciaKPe/f5DKPzFioOz
	mzDZhG9FVUkbzWZmxaJ/X4fLnz21zuNa5oGBY8gNbRmsAdW1dnnzK8h5NAlfUrt/sUDd5CmL8jRAu
	TerYktd4rvWR4hE8yA7w0bS2Amo/cU73MVg4bamNvnyv7oYMkUbHbvGSTZLjuwoBI1GwKcFyb0J6K
	aW1iSWxQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfnj-0000000FfJy-2bJw;
	Tue, 12 May 2026 05:37:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 04/12] swap: restrict to regular files or block devices
Date: Tue, 12 May 2026 07:35:20 +0200
Message-ID: <20260512053625.2950900-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E34781C0015
X-Stat-Signature: gwtmzuuxf9333eiowr4fmqrabt6gxxfa
X-Rspam-User: 
X-HE-Tag: 1778564234-916406
X-HE-Meta: U2FsdGVkX19HFVQrNp0ADdV6aIZozDEEuYrEAA+TYnkVIQjderMlIgChCDyBamhjVXfnPRt9LDBRKQvUsM4YxtEqa6cSdx9jpkzB9HH+EotFY02De4S7DFF6FM0IAW3av2Je/UFIOS9R9dUvCL9Lv3W1Da0QVvpfQudosPnYgmHV/jSsucIFpH6FsNEqwOTPMn0jZsWiiby2W3nuSGFQ0POZOfKZUC57VtOCDXiaP2q40A25yKDUi6XYSby5xQvqLPUKRFxyJ+9sSuw6n25hv5lks91TCiSUMJN1AfwROBaFlCQNkKEEFHNEA5m31krAkbd2Yh2DhLLHeDKP1lQ/pmFOYr3nvYjMZi2HtzWnPNW1IqI4dcVG2oOm0Lh+Rl2GhgvmNlpjjFbYDXtXvlA/icaFRfElTlHSZeHcKAuh08wsdEjgLmLNGbFQ6N5NvK4iCA3UFB3y8sBOphZVhfk3FtL0IAbFHQTd12sVrPaRHlyhesphi/30Ylj1+pR7T6gAuMSQ7T9Lzt4BARUkC9E65iklVCJeaRil6CJXpKX+rB7iR/QJ0z5rgGskvKd87peEPvXVQjSrfbtPq/CmJH2QHq3+6YAztSpmDwWoiZBuxrZkHKu3e8OKZ1FeauweCJvuTvcLERAHa9tS6b53OiH9RO56M0yLD90qS/skVEBPpwHYKhk89JjLVUyMXHz6WSvyg3s33+aI6C1mpLCEjupEDiBwTpg+3Iq9fgsfNmRv/e69Is4V/k8PAuSj3/4jC8Ge+l65Tc1EC6/HjmM9GgNGEfpuftQhFbq1DJwmxpxgJnhYhgrbQ6G6hD9hIZDog+2zSwJ0BKauFf7lj1zUf0wzjHfIQ9U1DcnVcwPdU4TQuRQqepJgxAcJYMDJcp7Mmtex1ysM/+DjcYZ/OjtkfInfL90X7l0nxjbuO0egrQp+SBv8s1CjThcerNcCLlCT2kAEInSAyBid1VdgayN9eZn
 2Nw3Bu34
 kz7rf7ESK8Ql8Si6z1/f0v5VB40FQYt5AKQFaQOPlzoSg6dlCMP7qp8n7qVTaTox3GbFKWRB1EK+dYGuR9bdqjCcruBkjIiouJ6mHXC3wIeHcAkEfBdz6LBpvDEZaZfWpwsq3GMHWnpwPCmwd+tCSh8CIZeNO3ZbSbaSconIq3yQUnA7CdzXvJmz9iXD3/38hqV4oTMuo94+mRdOKKQXEHLuyKMo5+n90KVlN51GT+XmOHWOa1Sc04eegVl4s9jr5rHFriJzvhKYR6GF1vuH/TdfDZALlnaH4/ruGETxDn5/J3mNrvwBOITm+uX8SEA+QfP24jJr7HG4hPYx9SlxSrOOlhccaxyX82PdAC9MdxSIVGyrm5YXwA22etOYgBbhIFEQ1wVT85BXwjm0eVjYDSlCi0w4YpFcUUpLBqRZaJJFMq8aFX3CkKOCpPITC8K69hFjq25HQ9XwdhbvGpZhLEQveeZmcv1zh1VqhUS0a3SGULQBGFPybkthtB8ZTxgsjopU3W4u1cXaqFG/ol6oP5Z9Hlj4NlId3tc0ms6E6ZSyKTUlLXsCYbkr0vma9kKdtBDDfKM9sGCuXod7ycGfISA79qyXCiwnZxtRBSPLYa3RnaDXC8lVQWee3Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various swap code assumes it runs either on a block device or on a
regular file.  Make this restriction explicit using checks right
after opening the file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a183c9c95695..651c1b59ff9f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3515,6 +3515,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		error = -ENOENT;
 		goto bad_swap_unlock_inode;
 	}
+	if (!S_ISBLK(inode->i_mode) && !S_ISREG(inode->i_mode)) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
 	if (IS_SWAPFILE(inode)) {
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
-- 
2.53.0


