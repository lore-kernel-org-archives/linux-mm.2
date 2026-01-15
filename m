Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6911D3CCAF
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 06:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29EC46B0088; Thu, 15 Jan 2026 01:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BD46B0089; Thu, 15 Jan 2026 01:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E946B008A; Thu, 15 Jan 2026 01:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 014FC6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:43:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 936DF570A7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:43:37 +0000 (UTC)
X-FDA: 84333257274.19.0D1D1A3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 59A76A0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:43:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VGObqK5v;
	spf=none (imf25.hostedemail.com: domain of BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768459415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/I/lmC8LP3DXdryYas7yQPVnLzGMCsU6bnNnqo9iZUY=;
	b=rGsLnqg33AV5/rhDgU8fUWpBEqQOk+Xkl1ILqDQo3KObnCOdfp4Ot3Uq/PO/5d9I9AuB47
	+mSuNGDK+Ev2ZJyaCOvLceeruMvq/pIQ7g2z9oBmdOISkxCUMzOU/fiOPOmjESxVZrHNdt
	hCtTunMa96ew/WID0OHCKJXq7BExjOc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VGObqK5v;
	spf=none (imf25.hostedemail.com: domain of BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768459415; a=rsa-sha256;
	cv=none;
	b=ox7e7E630FeBh7NyU19Ci4ip1ptG3PvcqnAENTwwDzhC0paPK+mcoqiQYReXIGtZlmRZ9i
	NSDn51YNUzc0B4IxYKWu19nb0fXFHwpDyZYYhDgh6fQ2rzLjNUuZStCO3TKL0lw35wj055
	EPJBLA6XL/2BCi2czlYE7p8ZuWyPUGk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/I/lmC8LP3DXdryYas7yQPVnLzGMCsU6bnNnqo9iZUY=; b=VGObqK5voCZEvaOS2sd8k58SOl
	1MKXHul0UIxtbNustQjF3TiNBO5A5DEV+7luUQDjVEmdj1o6ZXj7/RHbsW5uQ8FHghSmNa8RGSf/Z
	lqXP7DBojYS/m9d+kpswr79pVrMANdI/lJ+/vLktuyA9+4LwMwmW4ZudctP5Nn8fgcUOpIxP4H3bZ
	wZU+Uv2sOpV/KHIJNeQwI3FUfk0W1FapF8T8lBqL+KFM3MrFgZ4F2CMZTLhz100xPKnoPJhHW7ms9
	sJwJmQ51fc9hgVLMQHKjPH4dx2dyuUWDE38tPmbeAdELv7G3/fIrEXIlcOTJgefaGpHmCuyNcNjpw
	8JLGu1tA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgH4C-0000000Brtc-23Ey;
	Thu, 15 Jan 2026 06:42:48 +0000
Date: Wed, 14 Jan 2026 22:42:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
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
Message-ID: <aWiMaMwI6nYGX9Bq@infradead.org>
References: <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org>
 <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org>
 <20260114-klarstellen-blamieren-0b7d40182800@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114-klarstellen-blamieren-0b7d40182800@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 59A76A0008
X-Stat-Signature: bcb36g13hzykeet39ofkdtcpbpma9heq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768459415-451488
X-HE-Meta: U2FsdGVkX1+bVyksVQHz8/firHJcMJ4NyzV4M7nnNcWNp37C2TgBWoajFFG3Q9mgoaKvS2n16cq0TFZAjcjX2wBXl6uc6nAD+P97lzTr4B/VtUBTGnEQMcqppC+OfSTv4FJwN+1+zvA/+fiQr/ZwNpk2gH7r3oFZkvfVDIh+Q7wy1jNIayA0I+idnbiy/iZVA8CxKGqU1EblG+0FbErmGqOp5o0k/0SIcm9nWdfNMKMGJBMq7xYx6WdVhpNJvEDy5iV5B8bFkWfrdYWLPj0buNYLu3FYFqYdYKvGC35AdGSxxzp+ZQqaRjXp4xD6kyjF3gRsL4GPVv2vHrWAHjHgeiKnmBuxPMN7qFrQv3EjqC7NsEPSMgy1HxSKuEH0M82XBH3gOmA58pYsMfc1I7a36aHZRNRqDsCPTNMLGt6AZpyYsHtNMD+eCPRVnwo070Nj2Wqr3FN2rhz8y0jV9hKlCTAkhVuCmCOKxMlSirAzI+rD/soI/Lttaz7+jLMgmWZAokar5TzUUMuuU7XEAFO4f9tnNHX6GPwxpK3vL82MXxR+5Ne0vDWIuxORYtbXBVC81obE2gWwHzZPbRtOpeW796S5nBrvgeyB/zCeprF1u1bvl3jeXjG2HShIVlt7bvluBNiSBSnXFQFC/CzZzBEcYUjBOo6msyf/cOBR60ZEziUvTFYh/p1xrX8rC8x0iFyMsImu8FvFSEOdHI4CP0gmVwrTD/IJQjQ9ZkbhV3coURA0hiTASXBszzcwKS5DRPg903EzCa/27clkv6ysZ6V+DY5OOEVCYllr5ljF+Iwq1ZZfNK0VPCBnRkKchRsHcffj+dE2LFYudaLIG1MOxjKAfkAXRo/tz2ZdHEpypo3Sn028TNKfcB4R3ugZ/OKoNYrf16/kmrt9JtcV2kX/f8SmaW9i03/aQJsaidSY4RQP2sa+fk/2FRLbxRpi4CM6Pe4drS9OEQ2bloENrLQPZzR
 uL6rGkXW
 Gyg/MG4PP6Kg46jgQmPATQP662rev972H132Ut8VL81UEJrK1d/DTGBpr8at7n1/PTVLpKkkWKh9UwHy08mJMJCU4Lnb5Dv90LEv+dFPKxAa46tvVLEPG/QPXoK+xm6zY/Ru1IcoxjjxudOq1YAmMmm/WrKWJ7Z8sL9ZOSzJYD33qi4tTzIsOuRYUU2ZARBVOawsQxeKy07uO1JIA0xAFCjVofk3t3X1DzK5XJKDdb/dczU5/iummCuDVQpKBe4v+iRoKDt9uAeWrJIcwRRAxFvIdh+Y5vwFR/bSOwQcQR3LeVIXR9tj65OChVHcEKvsCK3QAbdY69T1PuFO2r9qMrejNBcufMURraiDHX/MZIhJYbxjMGD5L/uopCHjWUpHrdSAptCXOrAUGMDUKWWdmsXGErRBm0YziIlKisdJImcApRjhDOV24EGAiGi4bCW077eoaSc0ZAHffsJBFB8JyvLVz7DcV5sOOPxlfbk+NMCMPlKvjXZ9HIHl8VGeYx3XtriSPVEHsFCcYxjJUZ8IIT8Brfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 04:20:13PM +0100, Christian Brauner wrote:
> > You're still think of it the wrong way.  If we do have file systems
> > that break the original exportfs semantics we need to fix that, and
> > something like a "stable handles" flag will work well for that.  But
> > a totally arbitrary "is exportable" flag is total nonsense.
> 
> File handles can legitimately be conceptualized independently of
> exporting a filesystem. If we wanted to tear those concepts apart
> implementation wise we could.
> 
> It is complete nonsense to expect the kernel to support exporting any
> arbitrary internal filesystem or to not support file handles at all.

You are going even further down the path of entirely missing the point
(or the two points by now).

If a file systems meets all technical requirements of being nfsd
exportable and the users asks for it, it is not our job to make an
arbitrary policy decision to say no.

If it does not meet the technical requirements it obviously should
not be exportable.  And it seems like the spread of file handles
beyond nfs exporting created some ambiguity here, which we need to
fix.


