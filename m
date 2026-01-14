Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED93D31A09
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 06:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3D56B0089; Wed, 14 Jan 2026 01:29:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4FC6B008C; Wed, 14 Jan 2026 01:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CC96B0092; Wed, 14 Jan 2026 01:29:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C97E36B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:29:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93E6DC1A79
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:29:39 +0000 (UTC)
X-FDA: 84329593278.11.F11DAC3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id E40B4100002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:29:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MkKROcR+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768372177; a=rsa-sha256;
	cv=none;
	b=31BfMOkfQ0eYNMJCpadigTP1rULhXxn4drgQpo/+x/C63shTW7BNH60irdGGFaUz41N30+
	PPtKIwjAL/mufQCMjf2XmdhJljZY2ktIZCt3i4AGx/IwebsaO2gSGVj3GEvthpXwZEJp47
	qx2CeFCqCWZLvZVk7BZsaeqQ2QiGTrE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MkKROcR+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768372177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1lJVfHRx2M73EEQBeyjJ4ZU0g5MJMBt85jgXIscgqk=;
	b=WKEphjYYJpgf0xPDpQVLA/x8fQKOyxHtnooQUdhjWSj9ToWgLL2LJReW1Bqb/9aqRTTa+f
	C3GpodfHp4aTOi3oOS+om57jcVZkjKIeqqWKGLJw835oo0+UrBylFgh0oQxfQ6ve8xqYXY
	XkWrsb3zJrHisuoqaAtiudJeJ37Wxvc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t1lJVfHRx2M73EEQBeyjJ4ZU0g5MJMBt85jgXIscgqk=; b=MkKROcR+fTRxETHChOoegafJYd
	rVnSIecuPjzpPHAi79Z/9E8hnQE/6D+duG7uKE8Etw/Bm6dWntrsVhsVurmjDh6xZsV+8pHxkeSoJ
	ndNxzNYJknNqsW3hr24nqZHB3ULW5yRVpmnifag0V9pVxlQPJMOiWJmWmZkBz5qjZPdJ3c+mjXSGp
	4Jy+no+6j4YYszNuWSWw4+r+n062YwVhPa2zS+YyqyK8Q1gdzXfH19dNw1oI7HYA5BvmSfu1ZVJSl
	ACN0osF2p0zrPz6GjW8Z8JvD9QXvhwnkzyztUTe+XucT4knsGMqADhm06qixbeOjah8JvRXTt4+np
	/3dA1Z+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfuN1-000000087m5-2rva;
	Wed, 14 Jan 2026 06:28:43 +0000
Date: Tue, 13 Jan 2026 22:28:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
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
	Phillip Lougher <phillip@squashfs.org.uk>,
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
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
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <aWc3mwBNs8LNFN4W@infradead.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E40B4100002
X-Stat-Signature: qhbnzgaidf73p5kuxyqodhcxqyefownf
X-Rspam-User: 
X-HE-Tag: 1768372176-814373
X-HE-Meta: U2FsdGVkX1/d8JPnOVmSijonxqoacb6/TA0X9pRpYXdkv5Oi+xiBg84ZAwiKaGpiZ5As4DBMXjWgcNurkXxgLi+mRhxpc8RHKTvs9L/4Il5JUbCirJ9wKmsi8w+3aZ1EP6zLDI1WyBBE+2WfML4RpjYg7DU1FRMruKeFCv+M+44JBRFc+h0Lc3MZpbSMEVv55O8Hzn11fXqXdDPQ+z+fvSkLLGs6z3NYox/fLEDJv2pN9mir8X6RU9o+EhId5rixVvYgQTrYZAKGMO2k3xzbI+/GtOefQKEERzrnZrZmJM+cGuwZHeWA4ee3thPHZjcl9aeXQu7ysvAlt8DSetDK84x8Ywfkwjmhb5zBMJi/Jv+kcVn1JASEV0McipCvkyw07fp+QmEGjhAwb7Amu+QOJXtd1JGWYXji1+gcxF2dhneMZ/kkpEv8ct1Uo+2xkGXvCD3hux7kbC4gs2FVQMemxfebvdieeB6M8bdVSFW8+PRtK9zO9hvJ1b6MQDtkGKLyJ0kcofBhHAsGcW5VVy1+Vs7tZgHqF8CzE6txWrKDIkjWDlOejehPXNTjEu31VvqPdFe5GDRuUPVqq7uAVEQDM6LiSDJz+tDzRsuP0Kq4o7NWrFLpPGYfKopXAdhqxabSJ0et69zYkPg89QoVSk0NKFjpC/az5fBM5Nd5hLMhGEX6GeZn7qQ+HN+Wz0+ZXm/4QbMBIRNDZ+wwCzi+tyoXijAOLvzLhyDAAKY8/J9AbtVKT8CfYBv8zCldp9Bh79kKNmg2UOdFV9+IljZcsKhyeR8yYMu3uAfi/qtiJljwB4RCXHangxGrmX3mIG6sGD07wvgbGLAsC8rL3Ow1TgSlTA+UzAIXc9mUoUNGKK0oSuTgup6sFgDrD3NJH11pwv08AJVmqYbXLwuXBNPaBTGuVa8Sbw8OltaMEGioSwERyY+BOJwR84IDU48zLcmxkgR2cvODCUhlURiu2h8igpc
 uWBAlVv6
 yFEGbva0mDvUb5RueK52EKghrjuXt+89mt5yBG6OEE/UAFZ2/JxfasyWSAaqAgq5Z9c+BMQnl7keNxmxVl0sGTNT9KCcAJNGatQKV4nyo1OKrWOmIFIUgLUIJdfmRwea9UwO6f1pw1f3ywFfX78kZoELbBemQkwrOhbu4LyKGytpcYiu0ZphTu5Wgr5y9qyK/ynNUDVMeCVc8bcgEdTI6vtYpg+217fdsgmoSP6vt9T1Zq8abkJE9PK6sE3RW+oeCCNN/fyNEqD+HlUAVCmz458WtopRB2T0CbFa4kg9y33I4qvbT4uaqcWdR60rPTXlbZwpBYD74oP3KY9oU4f9PtP2ATVBFJdel2mBwzkJf37xPjE1wMw3UUhPDjIFFkd4Nm5m+uMsbf/wq+FeG+fLNcNBzhMe4+NUoINMhViGW9bmaV0+alqoGjMyl61y8aIi3WnmhoL1spZl/JEST2saceDM6bXOgpiqXDZiA7Dc521CsLSDeWndP/ZWzmAMePdYEK9MqPTh2k893x3iHnXO4/9AJE47Cz8umhkt82Q+H0yee9Vbh7F/zjaP08bza03GFIu5wGreImVe9lLq286bhVzdHrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 12:06:42PM -0500, Jeff Layton wrote:
> Fair point, but it's not that hard to conceive of a situation where
> someone inadvertantly exports cgroupfs or some similar filesystem:

Sure.  But how is this worse than accidentally exporting private data
or any other misconfiguration?


