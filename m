Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8D4606A88D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0276B05C5; Wed, 11 Nov 2026 10:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28E86B05C6; Wed, 11 Nov 2026 10:05:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB726B05C7; Wed, 11 Nov 2026 10:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8985D6B05C5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:05:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A1211C375A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:54 +0000 (UTC)
X-FDA: 85423163028.08.CB1094F
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4385C4000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409552;
	b=OTczkIVri7icB2FVeomXfabTJjw+v9S5s2ubmQl2LkWY376v5O0geAPLFWaTTl1I21MSIB
	99sMAHaGtBD/BS3TNhmxlUvEDJz420E1y1d8jWiem6HiV9iXrvVPQR3bvdNPLZ5Pl2+JkD
	a6w21zrrXtjllkAuZOrodj8P7r7ArQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eTh/pZjfcHNyaYvHc1i0brd4au2XXqBxglcFJNmjPBo=;
	b=YAmtEoiYJGqMhRCo9YdchSxA4+fzC6kx2MoXZkPeLMFeumSSWGtS3D4DssmKuKKdngfnY5
	gZHB9lHc1s4DvnKJDGC+LYWIMQgachUFxXek8guwMbpO4Ohqx+GTUHwnUVCRWadT+Vt3wA
	pPd1x3QH/AG7oo1Ic9CBNQyO1JPXKfA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 484DC68D15; Wed, 11 Nov 2026 16:05:49 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 11/41] failfs: use fc_init_pseudo()
Message-ID: <20261111150548.GG10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 4385C4000D
X-Rspamd-Server: rspam12
X-Stat-Signature: d6twuyo4hrs1uqdgu5fccws5p9oskxgq
X-Rspam-User:
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794409552-174027
X-HE-Meta: U2FsdGVkX1+zc8+YocIZCsmsNo+a50WVHdWaWybIZOJzaqy3IdI2Ghauz0pHVK2NtrcIpVZNNzWOFAE93bzK9e5s65JKfTq+HZxKe33ZV2tqmsQWFmWpf+ltpNpagtaYAKMUsmrXp6BQv8ZhIKRaNF6SAesQhhWBeYIzxad+9pnrgh7XKrsrRRyeTZuLea2V3PhVMk0iDSFsKwQxt2/iVZQQW1N7IJuA/VXGGd7xDbiUZ7JuDG7TsBmbBDMRKO3AvIGCd7NBkknKlvbnJBp/Taz+Oaebjti69FCUjLJWS1bJbEH6oes3SdRp29NXUT9eLo/CNrawWBEzO0xPUPLtLw5rOk5tfPHde5XwIi9ApzlLqoiUIIKkNMEBu2wVIZAY93vGD4iRVydh3AIBK6QeOdX0cTOWfn91gg76j+sT8dJXei/rsi1RHxAYg5U2FDY1I0ObF5rr2ZaGgscTa+7lpZQtCtGRAtSuYB8J8bLdqiXxWkO3ypEYGfm/WpBwqqffWhW+SSV5vCaeJmKL0rItyi5MJoLPsJiuVS5yqGQIw9barve43o+i3Wi7ijxxcOSGQv1G9PPK3HanaZA908n2iRHGGfyi2hR3E4FEJhMXicHeJ+342teuuGOXEcQoeh51WYvtCWxFccAXuZ/1daJMc/azHNk8OHKZ5GlMMVMResX0Rlt2QxhwgxxxJCLgyMwt0SIDNcwrSp0K5aoZB/JL4vYR/aFC+6ujYacEE0jNAs+IJmGot+C77pXYBq8dnubkO+oFiubQRmwWF8gX0LRAIZepkysy8R2xyi5p8uP2sJ5sdF4tXWxEVjzYYY4BOe7z50RKh3/mgNWdrf1HUra49DaMcpiI+BfmqRmDG+O970EvAonaT2N3UmY6h6Kawuh7Tz2gBEMVDpA0VSLejocFQPLpZ+R+xRE2adZR0anL88XMM1xrACSBE3ggcJNzgSOuIxrLuS611Rx1t+DQfG4
 xw8lCHGu
 Xk0EBGhWMdJTy78jrnnxgfN0EZd8a00reyft9/fhNjXH5RynA+J8MnjLUjI0FBEyWMudWLdUpRCj7Say9ztnu7DJod/ParWT7/QddLEq7dvzxpbqQE1VWd5aLm4qlZncUZta9xpXOD09piY+WNlCqTGkPW30PnJ3wsiih2l8jmg5O2AVVENke2Qpk6nTRgr6MkRgVerX+P1l3f8oVlw8ZKkR2ORNavWSrunlRZL+Vqya7wX+QjwhhVxHASfuLNRwb7/Trl4JZZb3wEg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:27AM +0100, Christian Brauner wrote:
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


