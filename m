Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E852D3CC9F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 08:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740416B0088; Thu, 15 Jan 2026 03:19:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDD36B0089; Thu, 15 Jan 2026 03:19:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9B46B008A; Thu, 15 Jan 2026 03:19:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7BD6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:19:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F05D1C0123
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:19:04 +0000 (UTC)
X-FDA: 84333497808.11.03D61AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A5C81A0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:19:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VjAZtcoy;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768465143; a=rsa-sha256;
	cv=none;
	b=QgUbpkESHdlfP3/1LTwrhHz2V1rSlH07HOUTyP9KFvt/ENiyEwlMDDUyVpVghTiYze09aZ
	nHEla14MYDJd08JfAl3ywrfsNLzMPWMSRjmvj6xvGW1/PW4uaECpB34eF2vgPhg1keidNJ
	p+d5N56Vg9CG4TQ3TpVmIeUEVCZ5IKw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VjAZtcoy;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768465143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATQ15qLQkFTNybHKUwOcg7v7b4dVAW6yFiPKJqq/Tnc=;
	b=oJD3fsTH8bKDXXNQkHMj5UcM38MU85Mm/t1C0Edie9q96I7GX6rWKLWfYxZyO59L4qDIGx
	JWQ/IdmIwB8A9VrwxaeRFb7mH6rFxz5cwLIF4UypsJhOY3hJbFM/CnFYOXguwDY7Y8YT6u
	xFZIN9svBEKL42fZAAuWKzbVBkcIhDo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75FBB601AF;
	Thu, 15 Jan 2026 08:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541B5C116D0;
	Thu, 15 Jan 2026 08:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768465142;
	bh=g8fgxkdEmT3gKXWufE7oV9na7UkVXcbj4Z3BE9lnGFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VjAZtcoyRkWMO1uB5ytW9qEsvR5V7Cs30p4xBsOxbZrUvEisSAE2EAo076KOotF78
	 qEIKjz9ZTs3Sah+mDEl6HKj/6ZFsJhhpdu706ffgp7GsppnNy/6v1rRUieEi0S94hY
	 gC8UiOPABxtZ5SIRdk6TnqsJ46pJFV01GedBAmQ72u+truEug3h3KyekccB7qCl4DP
	 95uk0iMVEM0+GLeuGt9ROv/NmuQGtvdz+rOC5qiuMik08aNMJAx9GrhYTNr3cCos8t
	 Qo4BNTMVBC3PWI/mIp/yopDVejft/5N8xaatqcyNxvAtf/4oY+yxbkUxuUcKT52lNf
	 EkFY9LJmLUerg==
Date: Thu, 15 Jan 2026 09:18:41 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Jeff Layton <jlayton@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev, 
	linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <20260115-rundgang-leihgabe-12018e93c00c@brauner>
References: <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org>
 <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org>
 <c40862cd65a059ad45fa88f5473722ea5c5f70a5.camel@kernel.org>
 <CAOQ4uxhDwR7dteLaqURX+9CooGM1hA7PL6KnVmSwX11ZdKxZTA@mail.gmail.com>
 <aWewryHrESHgXGoL@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aWewryHrESHgXGoL@infradead.org>
X-Stat-Signature: rf7jsnwmt54788w4zfjh8bc1d8uu31yy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8A5C81A0006
X-Rspam-User: 
X-HE-Tag: 1768465143-780356
X-HE-Meta: U2FsdGVkX1//SMCN3zD4mqY/7Wz3vRECf+2g1RK9S7M6wi/N4rnf2bgrwpZd/Wfdy2nUQ5w/h5e+pUny0B8xLgPK5h5xCnmXLRRwslDdmObsYgPPWu243ojb7ccz6CbFC0dmlyR+N0TyQWl0i0zmo7ooNqGgpVpiU6xDL/JNYkvkPjbJ4NfyJaFAQA+F2p/C6JBfilCzMLNG0MXD7SB+Pf+zmV6FwWA/No3RM8QLWqUtMPgL5sf259yX1hXMIFxeBM0eNlsWj0kQpnlbt0+H9s644pBQdwPmRksQTOGkbtOkHRsmTM/5AbC7CNcO4CdJyfYdJ0afvTSGlytoUxZcUPUgVkTGxbdJyRjVAqzN96saB3uLY1ZblUNQZFPAeZsbrdTppzfTuvZIcwxaeefhJ4jmp6R6yxupaE52MwSF2SNvenl1N7YlUtCvhxdGu0QhjYgBHR9lQbf99ByfsDhgWL7MdiznWSGlSkQkf7aaEjkRCPcUAyDbr0FIJyDAEDYsMWc+h9EvG94PCUFNGUkniFhPerj7pJ6+lbwNBm0cOdjCd0Axynv9oXSfNtwYeEH5ORgYSecRt4B1Aetox/6SiomPov4jcgpI4mMNI1SuvI85+BjYomqwYVZaydQxWKJs08isEYdbo71Rks99HZfH+FQzDfAgEFXFzw9dys+L8NS84FzOMl/Rs2myISSa8tbh7iWV4KGg+FFpbNJUfeMlmiPr8+N/DHsDd++rZh6oL8ecC/RZsPjMK5/QU6zVyM0FXgAw1sjSZ4JcYEOYkgbPKxdpOgynDJeRIfzYP4rCQkl4kS4oFhW2fmGA/MEBUyhnHQxGc3IAvjoES4TLnExxeLPdiHJAiWUlRYE6hkh3oy4sSExn6A/oTnY7z0XluwHx/hAjLDx+mwm/PHT+9kpkAocjvgtb4qrOeOiRRqPCJxxUG/4dqhAgCY3LwWEmj0ekTZQthvxdMmVnCK2v5Qa
 aM4I1qhX
 4IYKZr0E1dh9UEG25UjHgiwL2gkuG6fwKA2mTKS0Zy7+IPeIUS5i9ry+3DBSbhfmRYHq40bVEmHiI3VM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:05:19AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 14, 2026 at 03:14:13PM +0100, Amir Goldstein wrote:
> > Very well then.
> > How about EXPORT_OP_PERSISTENT_HANDLES?
> 
> Sure.

That sounds good to me too.

