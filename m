Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9C6CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 03:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA6E8E0005; Thu, 16 Oct 2025 23:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A4E8E0002; Thu, 16 Oct 2025 23:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7388E0005; Thu, 16 Oct 2025 23:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA7D8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:46:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B86821A01FD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:24 +0000 (UTC)
X-FDA: 84006218688.09.0FC9A66
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7AF81100005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RdLrCNOh;
	spf=none (imf14.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760672783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K4A1fNA7jBkelNwgEEMa2038bA7E1kb77kUqqLoY588=;
	b=lZeAhJ1tHQmnWTbtfVTy1fjx94k1tmHjzT/hn5ReTBfkgthbTmyfSuGCWTzFEbdXgefEjp
	HiZ5wPUed4EYWuHISVoVdtW67SCmQdwS4nX578f68dNM8Dhv24Euq9qa+68oos9L+SMJrm
	6FjUriM3WRrr9ZWZUScsTW7BY3GZv20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760672783; a=rsa-sha256;
	cv=none;
	b=clvS0hVwKt8M895Xmtq0CJY7aVFGwtaiX0y9jaInRIhJDs3d6Sn9cruV4Y2fWZTs1YT2d+
	jVIwZ0miDia9fGIek7KpsNU+IiMqSh9fnZsotFd0VHWWvils0v8aRcAUP91CnvOUw2FewD
	93F+xBR++hAm2BCFxIN7Z6EOvVjww8A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RdLrCNOh;
	spf=none (imf14.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=K4A1fNA7jBkelNwgEEMa2038bA7E1kb77kUqqLoY588=; b=RdLrCNOhaq3CpPOvWZR3PLSpVT
	7fSHTcc7swz+B9JYH2j+PoouNvhYL5pPKiZIYmPZnQgIUk8c4sz93/0RSXVUArj//8077yQt96hs8
	IYOfv6BfVzizo1nrwmF8KiYAtkc4tiY5urOHqWMHc47asXMJtDbIUhNZnrP1FXLHSJUmrT0s6X35r
	2NWS7i9DeW288vw2ADQE8IuG2DrEBi8kepvke37dmpCLEdVN6ytRNWKL7YRpeYt4AxtTQmxZyFiOx
	CiZyTxgwz09xfYYlgDb/djgNlNKVN5Cdu4gUQ4OdkKl1R0UYvhWVCCjbwvp592mfyvmq7+1q4dWCS
	VJAOXCjw==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bQ3-00000006Ty9-0SSV;
	Fri, 17 Oct 2025 03:46:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	willy@infradead.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: allow file systems to increase the minimum writeback chunk size v2
Date: Fri, 17 Oct 2025 05:45:46 +0200
Message-ID: <20251017034611.651385-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: ygjrodfsmtcz66uy8i51m1gt5c8gzunu
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AF81100005
X-HE-Tag: 1760672782-579119
X-HE-Meta: U2FsdGVkX197JcRM9QQ/4rrvBCCBW7qMl2T/AUODWuwmfms03DTQbZqDgbCTSAbiaxGP8RrqT/Dh/yHS7R+bN/6z8DKO5Sv3HNNXh+KzKD5aMSmJyBSsNhvGkx5sgHGjs6VK61GgU91ePKwL6eRdObhfQfXRtbbQm4GGkutCRMlcjH0pbsPWsbGztrb5eaCsgn1p/HOpesC4O4Ky+/IBEwX8+s8Pk4ElO7b8xkMddXSmdMtzgmMfTgwM6DPZ7mJxu1fY73fzWgaeHI2rjSUFXW2vlYsL5gf8YYg32KHHSWKD15ZqlqZgBE946uLWXWYXpUgVejvsL8CL+psrEPMFVbwBeie98hWsWo6vJ/UJS//+4GScb+otiWmZYSWnd/nwFFtzj3sGikRsygAO7guVaTqHaexixmiPV/UOk4ehE2JgLUMmXPXCgI/cokrAH1S5AycMSd6eo1xNhEIq0NF2V+ZmatCauL705005DjlqMFchopLnI/3zycEYGhFSyMhmzeMvZ/T6i2PFaoycTn7PX1E87yqu/84KeylkvVZeLyaoRGRHTHlaDFf38AZMFj9jQ7fz7ZcggZwXwHujp+ST4EMRSBZdkhE/VfNFVOBhi4mxmA80Gc/HlkmpEI+QD0d5feF6ELuk3z75jkKteolTd8k0nnRqzXO3TfPZi5RvI7Nt157hOXvxZNfg0TkMlfIX6C/zA9sgujgwTph2lJ5JiBVzWg++KbwxnohTMMGxkuoO61/oFNTAwvOJ61GbkiPoknmIERNM7KNUEvtHHqOCAcD2iiKAmgNrsLjE5S12gtA3469f4Ga+9AYTnXxy2JEukXYtg58VR7JAY1wn5zhz4o67hWn6KOARTryNHNtBDUuHfChflttxxr5a5cih1f6aJPzp2gp7s+EUflCkJuPE2PyiR2pKBq0CsMefw+BBwNdYAcs24cg2QLEjDC9ZbhrKd/AJfQcotYrJ3PXq41s
 ttWhg6Jy
 u/7VDfaj7XQHps4PDaeSL2PPlPAL6s+v41StTIFfuNSLf/cTillAeDRs8UaXYWXArP1slK5wCNBMVHjSciOE16StTxNdqEniahQ30JSt19JjGu/7T5wX+CaLwK215y1tmzSaMnp68Hkbth4e654x2igCLJAVPgp3J8iqRZc9MFPWNUtqSCsDvczlfdhf7xhUKiXrU+JDw2DipI94e0qx90WDatWx4VW/JdrGzkEqL8VVXNkpq9O12ohX5gjerOsgL5S82Xyh3nhNIWxVrra3o5/MB8tKdklLIgiP/L/fXJtLG6GGEiZnvWHM0LKtcqE8m+iRqR2hW2CV4gh4ArsfTc8OpHIgy7Dwn062xZolShq9Sy67+LejC8DBXBkwRpyIGR+6CKDvkRJJjJKHiOfNx3corECHlfZxgOlikQN3RY3mcVIxwlL4/2JuiLfTL9bDM54zBXuahYajHvDdqRhiOIHKUVrjlRaJmnt68KiqvMBwgvM6VlgWJXeeleECbk+vsPOpTntfz8bUZgfSSkd73AcY+ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

The relatively low minimal writeback size of 4MiB leads means that
written back inodes on rotational media are switched a lot.  Besides
introducing additional seeks, this also can lead to extreme file
fragmentation on zoned devices when a lot of files are cached relative
to the available writeback bandwidth.
							         
Add a superblock field that allows the file system to override the
default size, and set it to the zone size for zoned XFS.

Changes since v1:
 - covert the field to a long to match other related writeback code
 - cap the zone XFS writeback size to the maximum extent size
 - write an extensive comment about the tradeoffs of setting the value
 - fix a commit message typo

Diffstat:
 fs/fs-writeback.c         |   26 +++++++++-----------------
 fs/super.c                |    1 +
 fs/xfs/xfs_zone_alloc.c   |   28 ++++++++++++++++++++++++++--
 include/linux/fs.h        |    1 +
 include/linux/writeback.h |    5 +++++
 5 files changed, 42 insertions(+), 19 deletions(-)

