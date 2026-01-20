Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C560D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 07:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8446B0376; Tue, 20 Jan 2026 02:44:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BAE6B0378; Tue, 20 Jan 2026 02:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B438A6B0379; Tue, 20 Jan 2026 02:44:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBF26B0376
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:44:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39B1D140447
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:44:49 +0000 (UTC)
X-FDA: 84351555498.14.6A19504
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9339F14000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:44:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ilacl4zO;
	spf=none (imf09.hostedemail.com: domain of BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768895087; a=rsa-sha256;
	cv=none;
	b=Ehb6/2KyYTr64gEbVoWWR8yrI1bGjThyPifZm2gmu3rnX4xaTu0E3ddg0Iap6xavUMI4UQ
	PIjgxxxnN2BjGMJMmBbgb3tO8TrW6F8Qim5f8sIFuOvMaN0+TF9PfSLw2m9OuFK0HSbMPz
	wKgAn3bD1h7yL+orXfyk4rI8QMomd5k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ilacl4zO;
	spf=none (imf09.hostedemail.com: domain of BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768895087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kid6MiU7s5f8T4gEwmOyT2zu04YSeGDYh8750Mga8iQ=;
	b=XRdQ318ZRIwtsep2j/tbp+HxdvT5yQD2usD3ND46y+1CJrVdea7kKJFf61nEfdbsumfzJA
	IQX1QGHMdJwWQmv8mosi8w2FQRWAat/tnl7RSJBZ/J1gHH3c31iIahfSxlwqUS3sNay28A
	5lVWBuHp54d2M2W4jH7LwT2oa4VM/QU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kid6MiU7s5f8T4gEwmOyT2zu04YSeGDYh8750Mga8iQ=; b=ilacl4zOxBgb/lmdsCZTsr3EBk
	zFj2GyVX/vUj1UlJHTeGnpcPnHJ9j1woWxvFz3xRKDyTqK+wAajiLLU925mQ8gXwhKmyxMR4v1epI
	AOBbpi2btLiLaBkLAx55KwETuAMOToZG4XHJYEOLtQSWNewFbBS0oIkgoS8wa3txVmTRVKzYeS0A3
	V9gH/Lab14QzzebmbPcXNWPVgrikm/JOCo+2HYwEDmDIwtOHHDne6sJtxRZS613O1tl53Srsju7g8
	UT5LyUVPxepeDRdKwUet4llrhStqaMvjEAL5ucvkWWrFbYBz71lqsJk2Pg/Tigf0o/FCqWWyZna9G
	sV+Bbw9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vi6PX-00000003MrT-17WL;
	Tue, 20 Jan 2026 07:44:23 +0000
Date: Mon, 19 Jan 2026 23:44:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
	Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Chinner <david@fromorbit.com>,
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
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 01/31] Documentation: document EXPORT_OP_NOLOCKS
Message-ID: <aW8yV6v8ZDiynOUm@infradead.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
 <20260119-exportfs-nfsd-v2-1-d93368f903bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119-exportfs-nfsd-v2-1-d93368f903bd@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9339F14000B
X-Stat-Signature: exmmkja64pbc9d3orx86izt7dtxtasbt
X-Rspam-User: 
X-HE-Tag: 1768895087-285777
X-HE-Meta: U2FsdGVkX19/iSDajDujjvbMiKYr0lD81tqxAWKb3toSamO1tiuN3EaXYeT8d4YhzIdQ8Qlk6SdK2XtV67q8GGo88CCPbVQfghDdXL4uVo2Y/z1eBgU7ft3+jtn4jVA4RLFIqfytwLrYkG4r4qO4Bi52ujXbOpbcbm89BkLjbs2ZiaRn0Dn44AN9VLU84qkEbt1myNMw7Jjco56uV8Ifi1LwFxEIqVvgWMonkyH7L6UemPIVAkginF3xG80UyvgPKs9Jfle8Abo1CJI4exhl6ckJ1l01jZcyg4Ra7bjSFoYn3PwI7ecwullx1yEsPNvp1m1ZqoK7MBXmVpQKotKVFgbzGAXjHyqLttDCSuJ95bC8qs9WAKlvQcOxVX/CyKoF3e2Ps+OVfJytZEtBLI47++LGeEE3pRJoCUU0w6eNLamJeUO8EPpCCT10Vw/1V5d2a+rzwV/z9rXLVKXuyLSMItpaOWybVluwqwdU4aGpXvbiswBBmkwsRM0bbJgCYTkCd79jWwBFXKiGfOErNIb9GQDRmzUIfH2vhHuLbNrjl0ocdfRQneCrX59NC0ldJQi7O4uWJfT+RNmAGAQOB8TYYH/bbSQNi+6qUBZQHph2qxs0KKB1P12aU8dyjob1XFIYilyJDvnIa0eD8o+TAgSXH/NZE51jkRQsM13/B/k90O7WuVTxIyKLHZfvotY0136hoiEpbOb+1ouzk+SzZJeaoajBH3/nRaJbWk8FMHTe377uW6Tk7RCoWFfdAnXRQoI1UNCyxp6dPDE85MDGfLKYYjkBekOSd/EqHth4mUia/yoTA29dHXy1UIn2PWpFIWFstYBhC7Q/X1b+UguIIRyZ1udCdj3XaEfqGCkkTfhyObM+j4FWyXrtfyTgENeFLqOz/jusp+qdKcTJWoX7JbJnBjEiTcWnhxv1CDeJG+4ifjJdDBWU9Q9DwtMj4f01/xGCHmG0LLRbiG/KDiL97/E
 i2E8pj6P
 8FNH+Z54cqJBbbh4CDflb3+EAGXv4Z/gBsU0xbJAu9A54wjxFE1QQGP7IbnRxBrmptTp23JMXSgZWz8GqGhyewat5gfa6jiEXcFChJXXCkMtzIQlcNeky7OjwyuMEHsKfT1OsndTe1t+ijinM8pgVbbIxZ4c0n0BMdWoKNZ11WBi5YtD9izK3Dxl9vV6t0Anvl2HpTBiOpd6ToD4gt3/6NGpbH0f+6m/w4wzHYfGwzNFtiYp1pmuSrwSaFrPUfO0WWuY9Oo/bB1A0lhB+Xrp+r0DcFaljl6O8aaUUbHXPGewH/aBkWNwkHTazuKfo1nJGCPSbKg1lcdRXFmiZq1OJOJe9ZZOXVe3Xa2tsWiDF0Mu/Hd8H35m1NJ2XKl+Ad7nExxf9pfuT1UlOt7uAVcoF8FCdFwEjTRPUNTnhMZMDs6SUkc420+8cXD871E/wpNUnBxqjyz1Du5eXh0Udg0xMduRTeNZFYqRs8skoRlJBtEBTmjG0LdrafJsXHmFQEG1BDGlU2PKY1yGbkAp02Ub7it8JsNWmtu+n1Ymjq5gODpmmE9GlCrq7YLgVgFnRak14iW1z7HYFE4r25HKO3KcsYPGCV4cwYlm+AdPw30xmLs6h+eqc/PAlaAPBbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 11:26:18AM -0500, Jeff Layton wrote:
> +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Some
> +    filesystems cannot properly support file locking as implemented by
> +    nfsd. A case in point is reexport of NFS itself, which can't be done
> +    safely without coordinating the grace period handling. Other clustered
> +    and networked filesystems can be problematic here as well.

I'm not sure this is very useful.  It really needs to document what
locking semantics nfs expects, because otherwise no reader will know
if they set this or not.


