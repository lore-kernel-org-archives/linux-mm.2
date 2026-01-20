Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E11D2ED11
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 08:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212926B0384; Tue, 20 Jan 2026 03:40:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA046B0386; Tue, 20 Jan 2026 03:40:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2476B0387; Tue, 20 Jan 2026 03:40:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE7346B0384
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 03:40:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35EB4D244F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:40:12 +0000 (UTC)
X-FDA: 84351695064.15.16055F8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id C515980005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:40:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lXbl/VQV";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LDOUWFgZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lXbl/VQV";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LDOUWFgZ;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768898410; a=rsa-sha256;
	cv=none;
	b=yHYQ0dgNooKd1OTsQCitz8g67lQFbfWXajhlVw9Wiqqu5vXbpNq48Y/zTeGBoqghU0SHrW
	z9MEawd3MDEjndI6rDXSevCi+va4gqkOv1aVdLactAXB8Gqv+IZJLx+JT3RWP4832w4LyI
	UYMq4Si0EWrW80SwUMIFZk8ZZpaTriM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lXbl/VQV";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LDOUWFgZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lXbl/VQV";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LDOUWFgZ;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768898410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=241NHzkrAsafry/49JFnJwfuSaj964PJNO6i4H5lhSI=;
	b=mda+5Tbi9Fbj8444JmD2ICjfFXSreO/etuUaC1BDsDvkYtWfIT+xegdzR7LBCifjrAx0yt
	ZpH+dpWb5kUcHgqbh8OVSVf146Vkggb036Nk1Ww3xA/LHt5UJEJNeQdiuMXh3RZ5m71+Ar
	a948vAKosupcz7SZo3w0/WwksUrw4SU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AD0C55BCC3;
	Tue, 20 Jan 2026 08:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768898407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=241NHzkrAsafry/49JFnJwfuSaj964PJNO6i4H5lhSI=;
	b=lXbl/VQVuVPBPaq9av5smG5OFa/NhiwefeYAnKTxiTxM2QX9a0Jsbdpis0tVJFy+unWMtD
	bNh/ywftBTm5m2O2e7f0QmCLthEIxPwfSwEbrsfum9UBevwRj24bv8DnE2XCtOBZOykvGt
	AUYIB66up1nxz+RBb/9UrZZim7/aN7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768898407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=241NHzkrAsafry/49JFnJwfuSaj964PJNO6i4H5lhSI=;
	b=LDOUWFgZ9L1jfR2KXNRaliX4q7afY0RWN0QEnpzcnPdpU998Wx8+N3DLW81My4a1pFp2EE
	dwI54JIvYwP/B5AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768898407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=241NHzkrAsafry/49JFnJwfuSaj964PJNO6i4H5lhSI=;
	b=lXbl/VQVuVPBPaq9av5smG5OFa/NhiwefeYAnKTxiTxM2QX9a0Jsbdpis0tVJFy+unWMtD
	bNh/ywftBTm5m2O2e7f0QmCLthEIxPwfSwEbrsfum9UBevwRj24bv8DnE2XCtOBZOykvGt
	AUYIB66up1nxz+RBb/9UrZZim7/aN7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768898407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=241NHzkrAsafry/49JFnJwfuSaj964PJNO6i4H5lhSI=;
	b=LDOUWFgZ9L1jfR2KXNRaliX4q7afY0RWN0QEnpzcnPdpU998Wx8+N3DLW81My4a1pFp2EE
	dwI54JIvYwP/B5AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D31D3EA65;
	Tue, 20 Jan 2026 08:40:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3csLJmc/b2l8AwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 20 Jan 2026 08:40:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 47975A09DA; Tue, 20 Jan 2026 09:40:07 +0100 (CET)
Date: Tue, 20 Jan 2026 09:40:07 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Amir Goldstein <amir73il@gmail.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Laight <david.laight.linux@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 02/31] exportfs: add new EXPORT_OP_STABLE_HANDLES flag
Message-ID: <56fr33ju43h6zzp6jrzrkyfag6r3jz6wpnk45oe5byy6fqyvti@d43hgikfuk7t>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
 <20260119-exportfs-nfsd-v2-2-d93368f903bd@kernel.org>
 <aW8ztQ-RbhxwzMk7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW8ztQ-RbhxwzMk7@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C515980005
X-Stat-Signature: r7km1ixgabupoj5ynxczfmxfk1a1bhk3
X-Rspam-User: 
X-HE-Tag: 1768898409-395998
X-HE-Meta: U2FsdGVkX1+I4CzrTPu3zk2aVCcCVSJ43knn+dTM46QnRoQajzFw/sIerdOvuOmfTx5Sk0cGqTe/SNrBon36Zs+AtGV5117XiXCfahG1rW+LnRwC2+7l3RuMq+U9DrRciNYcU08i3NyUAcLomfpA9UZzIO0POYI1EKFXzcUawnjAdMT7SaJq2qiezKMb97UoZMsS4/PVACSd3m4VSdFNeLOylzdjN8ffYYTRdzp0ggw8JvJPdYihimE6xIz5kGy03+PH4xfSg+mxUAWZtOyqfCD5emY+JFth4Yt6bhw4fy9wpbchn5m/KTeZpBtviLkd4H/FxYveDaY0AbhRDJMqw4kjzc8Jt+piZ9tVUPnqyzobTyu/+GSEOJLMxDWv/0+5cIgBGO2MnKFKxLtDTLP+8n0zp7vcHMclAL+FkjKGi3K5nfgDCu0AGXIrZnvn0KxUFfEvaNr6OPXaMHkg+eUd5I3d/ApB7X2cxm1aVv5AfaR+ew7rmlX5Tsk0hLkHVuhEBOLv/cTojiz8hx2QbFB+51jexSgFxte5Wu8Wnpcn3acsCGq+gFZvY2JeydetLYYhxXSiFWKkCPvz4GDlo/JeKtTjRxUFdFKpkt4iEoSsVNoDdrdpzgzMC0ARZ3OYmr+XCI19be3A4Q1zu/Ff4qJBvRTsz5RmL+n44RzaUb8e2xh2uwmh1MhBkkINYmbEcs4SBoDhRrcP+eyLyWuAy64NkO4TyXw/BacMGbNy4TiWHDxhoEHaC9vnFkm2HGOtUv23MIxqsmAI8r3y8Z5MxPnYDQgbQNu+iqd9DU2hZNJ73mNZ713KTxXcUp//gGUWL9loJNhKWDh6ReBI9DGwVKqA/25rBHEJxFQ308oTN2q0mZLiNuZhZDsh6BWJZ/vS34VIGg7cuDq2rxVDLDTjQ9v8M9/wGGKVPnRvbxZcG2FAMP+X1LjHByXP2hDWgv3Bg5QowKmJDiL7mjtRVavuG+X
 CmNPzb2Q
 dj514CZ//lJfovduGwmR3Xp1hldvicgTYdZT5/6rKAAqKGeWkJjuEKVjtsFcr9EcVkOaZW8SWWgfGi3wz1LmqodalUtD5yoJ9Ju38HxP6pDbbHL+ulj2qwcU7rJgrPlHf7xFZHPBnQosPO4xZV+RG79EnUkeSXMtmc7jmWUBnMseYCviM1UEAW5TUJR4CNOJOAduSeUneY946XVhxj8UmJ6a67VMcC5oPBRPlkLZI1yAY9Hl59vgvXpLP5OyJru5hAeNYF62/LMaypmbYiWD7tdZKRqr5EHR60585QlZyJ48jM8WvZ8WVxOQcpoTspapnJ1MhIeCjfKLFhH3/RYHNGNcPN7dqDeWEgCn3GX0o/uzuradsEm1Ja+4kq3O47P4CyGnQCvpHjPeag7kaoLJdQihOHTqeJXHWuGZlvLLZ6rpx8zE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 19-01-26 23:50:13, Christoph Hellwig wrote:
> On Mon, Jan 19, 2026 at 11:26:19AM -0500, Jeff Layton wrote:
> > +  EXPORT_OP_STABLE_HANDLES - This filesystem provides filehandles that are
> > +    stable across the lifetime of a file. This is a hard requirement for export
> > +    via nfsd. Any filesystem that is eligible to be exported via nfsd must
> > +    indicate this guarantee by setting this flag. Most disk-based filesystems
> > +    can do this naturally. Pseudofilesystems that are for local reporting and
> > +    control (e.g. kernfs, pidfs, nsfs) usually can't support this.
> 
> Suggested rewording, taking some of the ideas from Dave Chinners earlier
> comments into account:
> 
>   EXPORT_OP_STABLE_HANDLES - This filesystem provides filehandles that are
>     stable across the lifetime of a file.  A file in this context is an
>     instantiated inode reachable by one or more file names, or still open after
>     the last name has been unlinked.  Reuses of the same on-disk inode structure
>     are considered new files and must provide different file handles from the
>     previous incarnation.  Most file systems designed to store user data
>     naturally provide this capability.  Pseudofilesystems that are for local
>     reporting and control (e.g. kernfs, pidfs, nsfs) usually can't support this.
> 
>     This flags is a hard requirement for export via nfsd. Any filesystem that
>     is eligible to be exported via nfsd must indicate this guarantee by
>     setting this flag.

I like this. It certainly makes the requirement of stability clearer to me
(with explanations before I couldn't quite see the difference between shmem
and kernfs). I'd note that fat or shmem (which are both exportable)
satisfy this only with reasonably high probability as they use
get_random_u32() for initializing their i_generation but I guess it's as
good as it gets for them.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

