Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB97D4A5E4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C86B6B0005; Thu, 15 Jan 2026 21:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1751C6B0088; Thu, 15 Jan 2026 21:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056BA6B0089; Thu, 15 Jan 2026 21:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8E5A6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:24:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 898CCC1911
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:24:12 +0000 (UTC)
X-FDA: 84336232344.26.E8FE2F5
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 999CAA0007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:24:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=CKqH0dMh;
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768530251; a=rsa-sha256;
	cv=none;
	b=U9rkfhEJ2wk26IN8NOsdQ9HY+NIyLCxoBTupfmNQIN8/7jXCUiDIivq3bfr8ahd2S9q21H
	WzZFzcjcrskyc5JpsrU8VtMmQQiDJD9yZKfn5YxL9G9d0Yb3cVzn+ucJ5sj8HCWrs+MMir
	5LSJAyW6YyE+J81qM06GxCOw17e8+yw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=CKqH0dMh;
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768530251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7+ZkXTf+cEt8COK7ZiBm7FpEGCZkXwmsqQ2YKKQgYQ=;
	b=Nhx1ycpdAiMsE0iZ2zYn+4Vaeo1wGOPIP60Pb8vJsrAjINpEwvFdOJ99qMRXBIRxIg2mrs
	8BjmiLIgrVL8QXumUWNPqnY3LYq/5NXQfq5aiL8RstKUE83Tp8E0I3MOhbEmFpOytf/a6n
	1lGy6lxQb3Re/rfyj3T3jY56OVa4i3I=
Received: from macsyma.thunk.org ([37.140.223.154])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60G2M4QF012987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 21:22:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1768530137; bh=e7+ZkXTf+cEt8COK7ZiBm7FpEGCZkXwmsqQ2YKKQgYQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=CKqH0dMhvlhBzX4Ihkt/n9SLGrWfxX4mn8QeWQB6i/JMAynZ/PpZnz2J7QzS+Bs5J
	 LHYjeS4eVH/+ftuv6ryVG1XbTNkEBDxBvsdirBrG5SJDvA92Anx4u3N3DTR/EiIhC5
	 D7kuOYWuR+wEG+aT+6digJ4U2JgVCouMwzPvCca8UfAIhFjTH/mNpBMF8a1mqTO4TR
	 J3Ca6tRIWBeIDKXxVFNRB7jtbFt4susYUTGwXkPso02XWNw91PlkdVzLKiVnspunHr
	 roxMctbg4I/pbwnOXw13om2WtDRQ1218LHXRi7gxhCYQcXc4EIsE/wDw9NxL3LC14F
	 SKf5FnkqXpe0Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A12EE54D8E5B; Thu, 15 Jan 2026 17:22:03 -0900 (AKST)
Date: Thu, 15 Jan 2026 17:22:03 -0900
From: "Theodore Tso" <tytso@mit.edu>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
        ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
        linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/29] ext4: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <20260116022203.GE19200@macsyma.local>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-3-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-3-8e80160e3c0c@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 999CAA0007
X-Stat-Signature: ase64ooufr3ewnzwyn7dynjoq6bkthku
X-Rspam-User: 
X-HE-Tag: 1768530250-645311
X-HE-Meta: U2FsdGVkX18xkKEr8Q2QuJ99X/WYkU+sVdo6TlC4xJk6tegpxgh5DlbkipY1R/bOAlI72symVORGXiM9G9PjPeyLRNbs+HNTalq2iS7e3cdxEiznAbRxcMN1mniOykx8AEjAC6a0XtaMfF/7gEnwI3XSpyCK1fWIxXk76SlryVYmTRJMkFZrc0/ck6cqlZnvkJ4ZF7Ab+TO74lcAC5X7eEc1I0uWi4cePn220W7y+kKL/gps3fL4fX7ZNTgt7Hv7LuKzbhT/wUZp9cd+oKcw5XP6aN4QuPrkRlBA1Keatc+W6HBhnOCaEP0ZwYeWDm2awCbJ853QK1YN8XukV7kachy0C/jbeVfGCKJpdRgPvFDZkMPaQgitB7RReJ+Y7dvSd+mOrpGToLxyZxn7fKaS3xdjqKRcLKxljxuUIcpBLmFmDKYU+9NuzW6o7veZwjZqUCHgl2jcH8rXAQ1iu9cHnf8ZxhuJ1aVqiDD9eP0iBGLjsHN7fJIMIuU3xXCNECB3zK2eUykoyadsdzP2JJyxD36Dqn+Ahc1RTQcYIcEIMHg8mU6VSAfkz4jRYKHFgs672guvcxZEs1bIZiyr+wwmj2yrPh3fgBs1ouyQ4aM9T107RUbKTZ4qRbIIUb3Pgv/CVdmhelJBAXvqg6uzs2g7w+aMmpWTJXUfl0n3UYdbmzXkZdcTSoUsyeVI60J4lyxz1qgOgpaVvxyyTzIVH9XETnWjV1/q4uOtbUton0zNc/uzM+dHJSwvbTMMB4Px+dn6Oz3URrI1rJ6llMn+UOkzF3+tG7C+3pFiVY3YUS59H7NTmXtVwDxw2jaZ8DFMHGgiRd+9dkJrvLm5ur8FKeizEUOQN1QHpkmYm1K9+tfmihwIQDC4PmHbMObDQG1OMv1ifG4jCkN1VLFanH5FSfLFvkDcai3hvAO7p0jWol2PoatJmE+rLKdOTiennz9rCsQislcT9rk5mc6HPTknSqF
 p3pBNTfB
 IV1s0V2NH3CW2wBmXhOAE1en01nvwq9tUR+tpwlVhYzeoo6K0VgcZymftKI0VGR5iwV+6oVCI7258PUr38QfZWIpcHr8d7VlEHbjosY+0xInm1IMw/HE5y6WemC8eFp9qwIs0ilWn1DynVqWt8IBIAnQ49sSuZuVmY9vL2BT0cQtr8woCs2QSfx3pB5esi3mzdUuB4z1QYCqSqari1JhoUigCtIMR18KsZfMm0B0N/HSNIHz3XOcyFVEDOwEgTrHHIsnVrlLGZP01R2lky8mn/g+lU59St48F51+pM431ZolCLMUrtVKwheCSzc+KXcid/ysNE1P8L1UxW/2B5NmdRVedvTJZa8h54fA3QpnmGaCF/8e03uXZjEsu4MzXwf1H5DNUsGKcwSWimpwBQ/h/baMZQZge2eFen6H1y5e+ZYDnm7zGm1n5+87cxh5uiRm5pauoIGAjbiv5/X+S4hZEZVOGDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 12:47:34PM -0500, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to ext4 export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Theodore Ts'o <tytso@mit.edu>

