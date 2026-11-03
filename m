Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E3D606A33C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 05:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151EB6B00EF; Tue,  3 Nov 2026 00:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102E26B05B1; Tue,  3 Nov 2026 00:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018866B05B2; Tue,  3 Nov 2026 00:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D27086B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:42:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CB77A77D6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:42:02 +0000 (UTC)
X-FDA: 85392711684.17.91FC02E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62641180004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:42:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793684520;
	b=YmZ7v5CoMPRp7n41PjXwSaaAyIGNe9XXmQrn3Tu4vLTU91ss/FTLNjeOvscusTRNkjDw2R
	22vlWUHMujlKxluvaTmevfwv/2fOPSTWBkh7d1/xL3rCe8F+76qmrnRDQw29H3rNaZ52fh
	mG650tKpsLz6rkZaCmOzBxhwjQYYIGU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793684520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bQ8ajFT5xhILdB0dsRYEtZZRvSWnG4oIvX2mQOlC0CI=;
	b=v1svrSFdvjEjfu9zZB88gQkSBx0dkjKMk94ftyKB/i8lgz2xQ9IPlU4gMVx7WJVCvdNcND
	3l/gsVvrN8vX8hx3AdJu9e5qWrfXvw1UWcm6wgfUXwksFCClRJXNtSoDaqGYcy07Wn4Pj9
	yshjpgzF5wjm0EoxsatM1lvpWQ1tWzg=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3967B68AFE; Tue,  3 Nov 2026 06:41:55 +0100 (CET)
Date: Tue, 3 Nov 2026 06:41:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a
 shutdown
Message-ID: <20261103054155.GB1559@lst.de>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org> <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: iep7mrppaokebztyj1gmrdb1rieukoe5
X-Rspamd-Queue-Id: 62641180004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793684520-753695
X-HE-Meta: U2FsdGVkX1+fU3EdebC395Q7yZAgHWBbBTTlgKHabSl4bjt82heMKh1t+871D7XVCiewjAIyKpr21Ks6XpZxxxfg+jgdPDJz0nN1Mi7sTwnkRTkgn/t9CB469vs0fFo0s3PEp9IQ2D+pQQBxsB/dnAvKviEdqSxKT8aJDXds0nTJ1NsX+vJVtftMozP4fLhqdeU1vL/6P52cHa1GB4dAOj4XB8kcoXQmVjdn0nu0un3OA6+g0Z3vtWhTi8ymAuv9csZE/u/oOGa1s5ytyk9lG8S1l61r1P1WQ/57yvgA7SxHHYtBWggcJ+1HePIjg73eUzSjVSp972SaIPGNL8RBu0cZYEJRZUqnj6E0jWLzYQP7yzFD02Tt/aI42+adl1WeyFUr5l6p0q0eebM/5ubUgspkspyqnMlfC48kCC2oRWLM0JYzA/3ZmEHwCGT8sepgSKihrx6VYRLWZPzfkc2tYttgiIeE/HzZ13CLtIW8F7UyItFJEgriz+fZZBBu+ajjWw3/GC0r6ElDGrMrwbhSw+NC6Aw/YmmZRBm/aV3YNFnPNNaCBP7GOuG1BjDPRA+X8+HhONABC0U1vQBdl8RcW6UJsNspbb65AsMnOLydBajOh7bVQYUpkkWs8wxJaBWOU7w1DswbATjNRCUS7ZmMbvBnG+3PuXYaNtHmeySPmsokSL7xzk4287NqgHw+w6Lx7Najvt23q6mxyxtWFQ4zR9TGbYTZadr4E/3FMyR/RbtSMEYiWNN+1XnIEswSI/7TF4xleIF/Y2Mc+yo4Viq/p0TuJu301X2HkRGrgn5y2uzJ5kO8S1RqUHh2GTLpTE/zIkrLfqFr6IChscBEn1zKwE+2N7nIrpz5XiM2gWl9H2Y5bgiTKSpYQKVPaMR+2KyqX7LavoAcwX/NUOJEMEH758+RQ3aDBhkAft5b9OGyjL3gdcOh6YwWp56YswhWS2XRv1pL1U8bwsGDdGxDTYr
 amhckAPB
 uUE0PN5ugul1swaH6sQk6fsTCveQ8LB4YebC8Rw8K6m6PXdrfPiEqBrANYLFHLclXTW60rYumXJE9F2CVK70yn2huxiTETSst3vXjH0Ns31a071ik+YYdkjzeRWiy2gMxSVuy90Qvuy1sOII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Btw, if my previous reply wasn't clear:  please add the test for this
to xfstests where they actually get run regularly and not the kernel
selftests which for file systems are basically unused.

Bonus points for having generic tests instead of purely file system
specific ones.


