Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AD5C44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C656B0005; Wed, 21 Jan 2026 04:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA7B6B0088; Wed, 21 Jan 2026 04:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC32B6B0089; Wed, 21 Jan 2026 04:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C71BA6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:17:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76BDAD2BD9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:17:53 +0000 (UTC)
X-FDA: 84355418826.18.B8E436A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0265040009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:17:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dL4371OF;
	spf=none (imf17.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768987071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMRVjotEayLOv8XTxaxuE0M55enKBYtQeaeNcrACLfc=;
	b=o+1BZPijmTw6ScmiT5YKX/1DuZYgq/9Jg415hZlMT+r1l+aBuYnTPCv4QJWevCO9K9bKg4
	RzojZFUumvNCeXZiIlWdfcHYYnxKRpwqFHrrof0QXB1FOdvcSuEV42vfegjmuRddG5KPjY
	xmXz9lRPovGopT8NFNfQpFsegX0blq0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768987071; a=rsa-sha256;
	cv=none;
	b=Cpe4JW9OSUJ0XoQZS5gf2Bgnnm6l8RcnnKP6O+0FS7ojVCCU6Jr7OXFS1l5FtkM35OvHYx
	rrbHEwkfYQRtuSi4e7zy1fidAt6kAe7lIJzvtDIglBbLeOedow9PxXfsJnCTCH+IiXboGa
	xxVCpqCmTKLYjZbYMDUP71FBJ3tob3s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dL4371OF;
	spf=none (imf17.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QMRVjotEayLOv8XTxaxuE0M55enKBYtQeaeNcrACLfc=; b=dL4371OFHyaeDBmxzj7GOgrMx3
	3K3xbidZALqODJsAS8whqERF7Cf9V7Fo7hOwrsqaJ52l4+3LZ3NOo6ToaJTvHKZRqcoXdeIkI5i2Y
	/IGCwCDyqZvkKB3vxuq/jXLgMBASekbT7z2m5uG7UV6Z1vT7LxO5FNkuYsqXQ65ggC8pblORDhMxn
	g88h/3uSdhW32hsFMLKV41gZ2EzUh0QwXmfBFzhtXFBCIM8iZiBvymXdqRapwUqUsREyNCfkJfKnN
	emlY1xCH7+a+KdQVe/KemipvA79Ca3KD2ZAnJ6dAOXDUOz1nqP1FfvsKk+szaZfJ4qnOmyQQriS0o
	bmhS62CA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viUKw-00000005AiH-18Yv;
	Wed, 21 Jan 2026 09:17:14 +0000
Date: Wed, 21 Jan 2026 01:17:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
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
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Chinner <david@fromorbit.com>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
	steve@digidescorp.com
Subject: Re: [PATCH v2 02/31] exportfs: add new EXPORT_OP_STABLE_HANDLES flag
Message-ID: <aXCZmmBRSJR3ftHn@infradead.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
 <20260119-exportfs-nfsd-v2-2-d93368f903bd@kernel.org>
 <aW8ztQ-RbhxwzMk7@infradead.org>
 <56fr33ju43h6zzp6jrzrkyfag6r3jz6wpnk45oe5byy6fqyvti@d43hgikfuk7t>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56fr33ju43h6zzp6jrzrkyfag6r3jz6wpnk45oe5byy6fqyvti@d43hgikfuk7t>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0265040009
X-Stat-Signature: rmkqkjh4q4ej74wok6jp8pmmq4irmkbq
X-HE-Tag: 1768987070-991514
X-HE-Meta: U2FsdGVkX1/gDrzZKkSv3VsDtLazPcyGiN05mpiW5d1qpsDB3ZWMEVabxDQ93DTr+OKkVejDQ1xfKGZTOj028dPOyQMRtpE4xWT8EG70cSGKtGn8vux9gsO4B1JnBCr6VJCA6u8gt1ZFhAwQQIM0uInAwszzgLW1vNgyqpuof3fZ7hUhb1SF4pCINlpdlF5f/BZEmN1XEKkxBePxf8ArhyxYqCZZxbxlQEQkSBp7OafQqtBrf1IGstskWfV/g/rLGkPD5XQbW+2O8axeH3zowFQHS6muNsv6Wn3EsjjPVYgb/BgcJDwcS1S1aBjVfv3czbgHhYj1el6R5mRvpNoEj2luwpEI/BbOLSD0QmcKpHdcbJXM0miGIPtsqXBPPM+DZji16kdZqiQ1ZzujlHCELNNkSOBvy083PhBJYq3OBrtSWtyce6lfpQCA4f+vg74jKU12XoRGYylSR5C9PzC4O+NbeDPc20WtfdLR1tMpE/XeDEn3GS1LTBLErttcGhLB8EWz8la28R2sNDO39pTtjphBHWXjzLRCn25PwgiAIgrteAds+e+jJrVJTCn7NBt2yqyYf5D0pHA6xUHZOD5+xAbVFVQDJtYZ6TbjkxrrXBLtOpmaVZfzlsfN0hnoCmequV9CyK0rH2QpDcQqQW+Uwi1nT/IiAqi2NSB/nkvLDo6ZUo1XPy3NGlBh72WJGtDVL1iZN8to3jjrzWrlFSdEr1QxFhXXAfpoOv6O/5ik1UHtpKSjFQXWLS1nO4K08E2Ci8KhdoZSs74vvY34kwjPStcQ8syHCvCJjIhRYF7YgSKGWyGxuINZwf2hvXOeeKwu20RL3VLgBO8cpz25f9WylNFQSI8hnCQqj/FHs4iuqUYYElacdohQ7LxOs9NgmMcjOGfh2pOqL7KTI0GmSxGvXpXFWNliihfakQw6OYU6zHvby2lytUnDhkUA4PfxQ4yUHFzeH1tiZg8tgImYW91
 ImPk6Ldz
 CUkZf98fiXmA4NtApt2LfYetwNuObw5o0KHSQjRs6bmJmwnQ+htB3JHbx/dUinUY/qh8XL/+1oUGeIuc9sTg8r8s5xcqA3qp0a4QpIjXu1Gb6eJ67cJgKuTaG+Gukcuu6IBhDrWTJo2xIX9oczZxlc3iXPiODMcqC3jVW5Ma64Vw5JwmI8D297sALT7ULxk7ViLboujiEoFhcSJNfc2OHAS5JM+EnTfqnCQbXA8n2YCDxTRv5q21tK9bZtoc7BRn4ke7jXL3iINl68x0VmhLHimWNb9RrhZMPGooQ7WZR4Qxj8NZec/dt2zpsYpFaKIwECycO7v81iiDgJCvTJu6TEIkOPVi8x0dr17CNmjtIJDvPStmzrnlOE2sPK70hpiziEErG9MMoY1kvpXHQkgp4PjFQ25mQH8IzlK8a6SCTNgMECe2GqIqv+rtEwP8ggFfTfNJPmX/f9xf6yif5mpifFYzfRvTcbHvvkcISY7uF01/1fzFFUeWK3r1yejrn3+ugV4z0MBxQ/lRKpwNQAi8t/teioNUdfxNwesI+dHaQw5ZjWPFl9Cinkb2/4gJG+B9a+jk3FSbTlR5507pjwPMXdEHTDdiYjuVizgkbfYOri96S6q/34rwr4HsyZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 09:40:07AM +0100, Jan Kara wrote:
> (with explanations before I couldn't quite see the difference between shmem
> and kernfs). I'd note that fat or shmem (which are both exportable)
> satisfy this only with reasonably high probability as they use
> get_random_u32() for initializing their i_generation but I guess it's as
> good as it gets for them.

For tmpfs random generations are as good as it gets, in fact that's what
XFS starts with when allocating new inode clusters (which could have
previous been used for for inodes as well).

fat on the other hand looks broken, as it also set a new generation when
reading inodes from disk.  So I don't think fat should be nfs exportable,
even if the export ops predate other uses.


