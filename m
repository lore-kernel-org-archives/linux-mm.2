Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43BBD2ED11
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB7C6B03B6; Tue, 20 Jan 2026 05:34:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5D46B03B8; Tue, 20 Jan 2026 05:34:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ECE86B03B9; Tue, 20 Jan 2026 05:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F06D66B03B6
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:34:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99728140480
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:34:33 +0000 (UTC)
X-FDA: 84351983226.10.9929585
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 175A4180011
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:34:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkYiavwj;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768905272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Yl/Ge/38zmabHKosQXQVrEg+BmTHvglVpqWXSfbn0Q=;
	b=i28P2pyGRDrox8vS2oaO5OMt8s8EYXy5Unco3RGtzaK4kbcC5VPa+FSZaWXDYO4E/W+NIH
	1TDH8ICV+8DDBKx2qg986D+Yq+1lwU6IbGDAed3mcpot31MYFgbH14oQxuNE5ocC1wLnQq
	0U1ji8+F8Nr9WbVG6OfPkWdU6oCV7xI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkYiavwj;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768905272; a=rsa-sha256;
	cv=none;
	b=JsV8/pTcpUhIgRQFdi5uvlsrddcojEGqK8XrJojxGXPfHQ1DFvYw26aawhqO+rz+7K3BnD
	Qe9Uvj7IYMX68kijR984sZZDDgxAJu+0H6spRW2c+zptBaVb0xVm2BQUDML/wdPV9wXETw
	FtZukcs00ifs91iXSItyPeD8S2ANyC0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D4076011F;
	Tue, 20 Jan 2026 10:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04B6C16AAE;
	Tue, 20 Jan 2026 10:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768905271;
	bh=ofM75JqEotc0v7XRCKkNO2AMeaUn3xH4tlqNjm8W0YQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dkYiavwjArBw+8JM3Doyt4vFEjXCjTBOooZATw7ybtJyDWfHOsWo6vfR+lTcrWca0
	 84g12kcedULlbCjwN3OhgKihsyS+8LP34glFKHjjboChPwnx87Mgd4ye5oYrptvwcU
	 IR130p8sJwGfsM12J432DDMgzJBXrhBvvtKpy/9JDcG+rvOkHRKRbslb+hAqYozEy4
	 8HXCy/UDUBGKe0SB1WSHTXCGpraNDHfp54t2En1JQCop3QwMKo4TzMN4znHIRfj92N
	 0amrFzP0cYXKJTlNdj7dkkgVOhyK03N9xYYfKakG8ehUjpIPXdBq3+jcGxXnzZWvCP
	 JUo4/sRFClXEw==
Date: Tue, 20 Jan 2026 11:34:13 +0100
From: Christian Brauner <brauner@kernel.org>
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <20260120-bindung-eselsfell-fadec0d95909@brauner>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <aW8w2SRyFnmA2uqk@infradead.org>
 <176890126683.16766.5241619788613840985@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <176890126683.16766.5241619788613840985@noble.neil.brown.name>
X-Rspamd-Queue-Id: 175A4180011
X-Stat-Signature: qnugrefk5tkoy43dywr36ooxgoifq3z7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768905271-65117
X-HE-Meta: U2FsdGVkX1+0f5AlSTW93pgxHNDNxMAiF8HdZJ3WGhhZkiokJG3PA7rXMict72pnWk6mQsFGOrP0/J3ESb4JQoDUc1gWDw4oAfo/B0o04ucD322VWrGgtiIO8XDmCTfBfzFwUDbqRXU0SKbMZWPa/GAYXxDKyYNcBnc0LKmxOOUzwnYnKBKyghexfpKDKcFXUqpVvGcJuEas7zBobzuJYTBb3kDUAFNqlwRw8x15Hx3UUFfQ2YtaUnxXdcFpgpBpkrcGU9wa6SFvOUMPTcNyk45f+MjI44Yr7r4HIO4qnye828fv92+lsXV3+PCP1o8RB22gD0uq2DncKxJUGo0oRr8Rgu2DN/O5UJANmIgEaSXGzUEGpvvO/8HDpKiZSG0RtWybIiPFMq+ldhc2IBbHesbKEAS5AsfXne4ReZcajn49xq2+97BE2NZUpDYq+E+FkPFtp2kV6ocgBF6cT3jMD7KbD4ngp3piGwnpVrCBanrDh9I8NK3lrAFNlh2UI/rLq1RMQwht+Gk6eP3FLLaYGvk1tXfni0kDpFOCFIrZKEnAq9yMLGqmdP4DiKCi+RFTbY6nDR1UMGYD0XskIGt1MmRoEJfLEp8qZGWL+jLL8VcukPZnW2pgFFyc/fEqx66mZIM86gFB0QQDO2vyjsi7b2gDOA03ntSx1S+kEEgsvYcj0tC6N4+3nQSIGtHhr109i8N8cOIr4SHbAhswlzx1ZNK2aMsPKdFsE1szf0q4MkmglqQ/OcQQzeA8dOHTIFqNrOYLRIxEVy6fcBBqzhVfZy6DKfFw7dx/r/g20r+Dn62OlWjzQ82aFd1TIl5BpggU1EaYzEhiVemfiOdwc4ksViU3dPj+F8mFWpys8a85jnUPgIJCaVzT7noBLlMLigol4MyEQOYUDNLZMTydZoBaJ9tFBNRoXu9JOzXiD4ZFutDMWQNQeeaYZRv5NhglZ5D+WZctJarx492OzdUiw5w
 DoQdKuek
 JirlPuJNUxoGEeacPR/Isq48edb+d5M6tdBJk9KRXlfp2wwYQDgfJ8InkB2MPc1fBMPhSSKGpF++j9HBewMj6CO3gX6mx8jX7lcLIyIosUUCW9Jc2fjGERQhIC5eQ1x8rugj5h2KA+/Y41oVUGg1Y4kmWK8wCm1KbDrglD3eMTS5AtFg0ELjbSfzHMV2Dibov1sfgOnaIe/fDfwvKltvoEcTHrJv4RJ0CEddYq6lPs3+wkZ7pI2LaitCn/ueIYM3Ivr+9Ax+GBVjjeJ9UC/5YOpXSJnzKXfq1BwBQgSn9YP3cm+ILAR0r6oc8ty2rxzA17gCxoJfadvZNmN2FppZaJvbFXrHc35S6aXrH3fNt+fw3JtwTiaXBDTYVxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> It took me a while to sift through the code/patches/comments and come to
> this understanding and I apologise if I wasn't as clear earlier.  But
> my intuition was always that file handle stability was never the real
> issue, and maintainer choice was.  Hence my rejection of the

I very much agree with that assessment. Yet we so far have failed to
even agree that this is an acceptable position. Hence my irritation.

And apologies on my part if I'm curt. I'm simply annoyed by the very
lengthy and to me somewhat pointless debate here at times.

