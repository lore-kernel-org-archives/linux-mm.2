Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC248D1D494
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0967C6B0005; Thu,  8 Jan 2026 16:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067816B0089; Thu,  8 Jan 2026 16:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78146B0092; Thu,  8 Jan 2026 16:27:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC8966B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:27:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FC9F1A02A8
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:27:12 +0000 (UTC)
X-FDA: 84310082304.10.38A890B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A084180006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:27:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WngXL5Mt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rgZymFtK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WngXL5Mt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rgZymFtK;
	spf=pass (imf24.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767907630;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZU8r+RCFJ1jEtmsX6mpEJu1O7Ro0wL5v4syn8JyhiE=;
	b=G14gPGkQpVgfRJoXIiSPzqfsAHvGbI/4fNhBMszVoXzusnYS6zK8TTtPV0yVwsfD3bHNb7
	Ei3Kj6zjrQoRH3qpvg3tYlYlbTR5uXcSx4mM6HbP14M6bbxNGnTrH0Zufykky7/cnMdDOz
	ORgZlQ7NRGkdw48cCK1n4TQVMIJ192c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WngXL5Mt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rgZymFtK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WngXL5Mt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rgZymFtK;
	spf=pass (imf24.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767907630; a=rsa-sha256;
	cv=none;
	b=hWxqusOoBbpiMcNSf09ThQno66CCB7qV9hptuoRT9a4xgHAEF2UZiCRblA/amWe/8w86q6
	gyRG0wXsmC3jrZD3nNQO5NlGSKtrUM+1MiTX4CnFSgEWqPNGmsiDYaKDVEZ1Be7wKvEhG0
	y1NNqwy6CZQMM1CaG5rSEqZkVSfXrnY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 26E2234AEA;
	Thu,  8 Jan 2026 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767907628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZU8r+RCFJ1jEtmsX6mpEJu1O7Ro0wL5v4syn8JyhiE=;
	b=WngXL5Mt8z12rVyB9cE0g3PVLg4QznOcZdW+phzk9IW2toERw4wMu36HdervhlpWRN7DTd
	6uZQnRvT8qX8tqCQdh6/pVGZCheyeBc6+y4C9/RWLAj0VqW0Zuj29XrpOvvpP1CwbWeFbm
	fBlxU6Tr9/5L2jSfY0HJVq910bpy3to=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767907628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZU8r+RCFJ1jEtmsX6mpEJu1O7Ro0wL5v4syn8JyhiE=;
	b=rgZymFtKxfaMgDxcetCSh7aq5GywiY4HbCwncfXh198AjaY/BPftNkDMYnDsixHAsCz8wx
	fwQZ3sGV6XX4DoCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767907628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZU8r+RCFJ1jEtmsX6mpEJu1O7Ro0wL5v4syn8JyhiE=;
	b=WngXL5Mt8z12rVyB9cE0g3PVLg4QznOcZdW+phzk9IW2toERw4wMu36HdervhlpWRN7DTd
	6uZQnRvT8qX8tqCQdh6/pVGZCheyeBc6+y4C9/RWLAj0VqW0Zuj29XrpOvvpP1CwbWeFbm
	fBlxU6Tr9/5L2jSfY0HJVq910bpy3to=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767907628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZU8r+RCFJ1jEtmsX6mpEJu1O7Ro0wL5v4syn8JyhiE=;
	b=rgZymFtKxfaMgDxcetCSh7aq5GywiY4HbCwncfXh198AjaY/BPftNkDMYnDsixHAsCz8wx
	fwQZ3sGV6XX4DoCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5EF93EA63;
	Thu,  8 Jan 2026 21:27:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d94qMCshYGlqWwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 08 Jan 2026 21:27:07 +0000
Date: Thu, 8 Jan 2026 22:26:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Anders Larsen <al@alarsen.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org,
	v9fs@lists.linux.dev, ceph-devel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH 03/24] btrfs: add setlease file operation
Message-ID: <20260108212658.GM21071@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-3-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-3-ea4dec9b67fa@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1A084180006
X-Stat-Signature: o5d88s5zayg89h49bofatugi1hse9osi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767907629-137642
X-HE-Meta: U2FsdGVkX1/gRm7jiLi8lWQ80IlZdhVfQ73M6CvhryMdpB+K161cdeqta8HdQuG7D9Pca6JdQrKntOL5U2mcnO/sz9b++6hk6Po27U9TAPaki31+vm1b7hGHChJu/JHx3fFf6quspFStrI4pcShUKtYzBy0cO2GdzOMfoAaZ6mH6TyCuvte1WikbfxW7b79wjYBW6fX+3ktYRGlZ15zHNxco5R5zMB4BjTj2cueCzcTLG18oKDZ69ybuTpwSUHEBk8TzmZSW5JgqcAjc0qADj7iDcfBtcAJLcU0TlftQkePBtlTmzOZMCoRm+pYXMjFi5pSQlVR0K3tvmhj0i4l5j+AyMWlGuxdqYh+kSY+wijB7Avlm1FvDQMLT8DR464dEX7fD1jHMA3YnEkghayXMzy8T2muasrjJQmf5Fu7H3PQHE0tMPH/p0X37+uKVonhoopo6L2Wl2l+7OkKtVbssoAj2DHe00PDIzLcVy988pPZUtx9FfFVokTq7roK0jkKBwo7QbwiLkokVrQsEYNdsAmVGkfHWU4eCJYoVLBHwbbXElU/fafTmqqXBydd1STHmG4xWjSkzZfKJ+CvF/zk/A90tLxv+bk8KY8wxs1b4SLpLIUPPjqNwCKYgujjPL9PF310q9WJx3jR/V1SrOhAWW3yovdU/v1UDqnDL0635ab8Fe8dR5W8L1B6a8F1AtODE6let9jxfEZM/1gm50xWUeyMIF0U/69gMI+UGIb+A2PXKdjLMS2yKQh02E88kzpp31fU4Hz+dV5Cpa1/rMLGVGv1+DANJoZ23SVgAeabsTWzDoM29xZgQjof7QzTbtdtiwsEdD9zl3Ok9BFlD3lrFQZHVndYmXjlxIU2up8KyvpCexhQVSQXb2A/KAbReoLAIHim4arXsypXVt0FhbUOS84XBb5l9Rb2IGN6/MNyh8QXdpkyuO0Ce2DR/Z6K0ZjFu25TsIpQjwCGb/DbvDA4
 U6nZyD8+
 Jw30Z30y8e6wkijUDAnp4LUWBAlGvVeb4nG1ulRtV9pbpD7/aOW8b4Yl/YnHAH2MLFeI769vxES5EkTEXIOBv4cCOhoAD8X3tHLqHFiBhGfMs3cLAhrdirnwi5Z2Imq1Il25VZd5FjHYUsnquS9P+pe1hWX9BJKN20B66vPWYnzulkkFycjrEBft4zHvEi8RFiRawrNF4HhIotR/NHLn775E4vnPyvly9TCaT0+355ptCCFZD2DLa3UgUoAPRy7R5EmTy3ad42QcIVjkgyrq/vaBvZBl/Dn3jMh/eVden+3Kj9YGEGqWvW3Z6ugs6t2qRUnbXtXZcTgQNcCh788IbPSUd+wnadI2JHtJizKsG8O6mEn6Zt5BHGJHjFPt93VDfglG6IcuZ7aPgj2bv7yUUDzVnKrpUAaBrv+e8WetZV71Xcy891r/ReiBpMwLaeMWonixta0HavPRPGcpyK3zBKotYC7+fVU9QgYs6tHXXl8Tq9vtkPwg98K5hPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:12:58PM -0500, Jeff Layton wrote:
> Add the setlease file_operation to btrfs_file_operations and
> btrfs_dir_file_operations, pointing to generic_setlease.  A future
> patch will change the default behavior to reject lease attempts with
> -EINVAL when there is no setlease file operation defined. Add
> generic_setlease to retain the ability to set leases on this
> filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: David Sterba <dsterba@suse.com>

