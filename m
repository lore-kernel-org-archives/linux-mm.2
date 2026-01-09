Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631FAD232E3
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AAC6B0088; Fri,  9 Jan 2026 01:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E2B6B0089; Fri,  9 Jan 2026 01:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10A86B008A; Fri,  9 Jan 2026 01:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1E76B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:01:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 222738B7EA
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:01:30 +0000 (UTC)
X-FDA: 84311378340.15.4AF7F4C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id D4E914000E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:01:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nNw+ohOk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+d4639d90bc861be87f98+8174+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d4639d90bc861be87f98+8174+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767938488; a=rsa-sha256;
	cv=none;
	b=NdAmZFmMtRksyv3LZIA9ttgGSzQ2cE/bviYuod3V84Q1LfbOr3nHtvV+dEULPRLfidq/Gr
	8oYT2+9aVxYZAxbHPIL+Yl7h3QrwblbG/61cV4Kzj1Um6LP+aJ7oMiJl6n6BNz04MvdJcu
	KBaeVqLgx6txnCIZuIfee8BbuNQIzqE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nNw+ohOk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+d4639d90bc861be87f98+8174+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d4639d90bc861be87f98+8174+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767938488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVlnT2WiXW5nYG95M0tj3/pwuA98uZmz0fLtRU3VLPA=;
	b=wyBkrQwYgjppjmNfKjDRyEsWzPZdI5G+bywFp1Tm1+IJjctAPWceoxxaYyTb/VxPiBEZ/j
	awzCU4HEbAmNz+JEzBLszvcxpDkftCQj8w2FWi7dWaUyskZvR2sw28BpnMNrmChes+az00
	5NOPqzrs0zqbmB+YMVjLkzfIv9IA24Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TVlnT2WiXW5nYG95M0tj3/pwuA98uZmz0fLtRU3VLPA=; b=nNw+ohOkHNWpQswvh+NdF9LHsu
	PJ6XIUFJtAy/341ZJ9J92w/DrPqKhkxz3zTjI/OkCD5uCId/D9WwQgvpVYCFTlMBlisRY+uVtvIRe
	REPMinKM/zRtj+mAGb6mG8h33I8v4EUxHd7wpMoL0MVUe5QELfPQU02i+BkEkkPD+IWuWUtmR9vj7
	5PESqXWBa9hJrSIyYBcnAULtN9bqZwa9ct6avHgzAt8PQ8DJwQPVi9fHlBg9V+TF/Bau3F5xfjNlp
	4gxLTxemKZWrMAqjEIaxZ8E5uEYuSvRgEMvz0VvHRFcwTeD7kP/g3KTcD027gjhOnTRYhsN0CtrV+
	PA5MAVYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ve5Y8-00000001VCt-1XPG;
	Fri, 09 Jan 2026 06:00:40 +0000
Date: Thu, 8 Jan 2026 22:00:40 -0800
From: Christoph Hellwig <hch@infradead.org>
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
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <aWCZiFOmnY3D4oUl@infradead.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D4E914000E
X-Stat-Signature: 7z7ecu7nyfpx7tac8a9nc1df5cwqmfmn
X-Rspam-User: 
X-HE-Tag: 1767938487-859343
X-HE-Meta: U2FsdGVkX1+TaUio21ijApEQkjlsMGiK3aYs4mj/JkOmxqy/eCbJ8qSSvPp9WrAO5vv6m3AUL3/A+ln1WEN+uLgYKxo/BqomSuDCiCsb+dzgH08V8jkVqPxwEyz8Ie2Am3zQJ8oBBlpJZomkXi9B9u8YRr4hoyQMRd5Ye4tv2HDgfSHg/mYSZXPOdrBJjLdnQ2Skbx8/3yCQQqNQOvVAsS1v8vGwi/x71bgkClbc4uN98BhyzLMJ2ClTJfEewK78nYiviilRLJCj2VUaxKM0qrK5uxJBYBS7lpii7+Ly/EniOG8Oa6q2CfAC20b1RalRGIEKm60bo/lR1S3ohh0E/v6LbAsMeb1rxMbCjbvmgx2apNwyu428HF9Q6Gy6mrvjfw4bR1QJVRewJG4K2h37iKcM5ZBCc6pCx9mLsOitGg51Ugz7fueRO4T+bf5hjHBcFl975iFjKn7Odi56p6zAr+LZURoAU/AGakkABPenPSkDp1AwaV42UP4bynhy8TkWLak/SNJxtX4aGsYHejiGQS2xA3yVeFg7nqL/6n3ji5SMQxtdjomXs3OF1MpSESUXcpXi/mFYGvvJQUNHs7P2tBZbK0HPfg2rCvAHpqH09rsd3H9e8KdRFAxQqqRaHmQVd9EsonNHIdU5Rb3DClznNbCX+0f9TUmPZFUOnAj9QJRysI2Dd9BCmIbBTkjyz4eAlUzAulUdPwXSPu6AWXhSoaLvkJvCa66tLC9CLQtejg3yIDwxsnGaMH+3Jqlo1u1k9AcvhGNPJyZ7y16JBXlySnDq3Af/lsg2XzTKA7r7Gc51EyqmVZ6ntCnuq+uvgBJKnCtxGuBaCcGOn0ikAzUU1Pb9CYveVsXPSH0LFFYaSVn7LsqK4rVOll1094pZNLZkMGA8Liy5HhIq/d0xsNGN+/iYad9lyWWZ5DopQr/6u9yktsraq2XgNv26cxO21Z/EpjxqMOivSBtDl3Gh51r
 FtKpbGBw
 HXr3RIWh3MguJwwDfViC4DaMknisscDWoFN/KHox4XdyP8smfz2qWdv21ORp2YfeM2KasuQ0ZANdkcFwdwoQkUnbrLSm9zFzr/Lx1EO5JK3dNFxbA5zQuJhh0q8dCiyzfjrwhsgczZw1y4Iur1V+c+F5h6Yh9Okg2aPnBlKObg7e8WcblqvvR8awRlrWtRV5pV7/u8ogHZWirjVBjD08q1f16wNI2+/Li2VOKhwN+oaq7Y46Em9fDxqS0Dye1A3eJM9TkdGbWhUooJjDFOw25MYr6kEkDA3eGUR5j+7oUDvcaTyPOY4kYa2MCTFgCfeEUEYHkMLj9lm8MBycFYr9d4M3icmScZKb58T3986uO2dxwQgdHwr0hc0yQkOL636gDUf2vsCMsM9FVf7jdXEaPpC4tgnbcj2un98x4wvdtRDP24eaN7h2tgz2p9ZjQ2wrcAEfnAWtFRQ1OwHHhIj4lSYpLaN3PRg3/A7in61DyfvXODROyMSGAfpUV81gdnB8uA6l9rJztDbaQ58ahrYZTkjh7YvmOVTfFta3FzjYCQQ2nci5UOku+U0ISoQ96KGn0OIkbN9G2NOKNWs5wHIlL4scjtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:12:55PM -0500, Jeff Layton wrote:
> I mainly focused on filesystems that are NFS exportable, since NFS and
> SMB are the main users of file leases, and they tend to end up exporting
> the same filesystem types. Let me know if I've missed any.
> 
> [1]: https://lore.kernel.org/linux-fsdevel/20260107-setlease-6-19-v1-0-85f034abcc57@kernel.org/

That seems reasonable, and I like the approach here (without having the
time to review every change right now):

Acked-by: Christoph Hellwig <hch@lst.de>

If it turns out we have people use leases on other file systems we'll
have to wire up a few more instance as needed, but I think your initial
set makes sense.


