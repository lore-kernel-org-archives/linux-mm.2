Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D824DC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 19:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453A26B00AE; Wed, 21 Jan 2026 14:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3CF6B00B0; Wed, 21 Jan 2026 14:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ACB16B00B1; Wed, 21 Jan 2026 14:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17FFF6B00AE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:00:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8C3ED3CBA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:00:11 +0000 (UTC)
X-FDA: 84356886222.01.EC1F055
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id B721FC0009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:00:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gfVKmOXi;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769022009; a=rsa-sha256;
	cv=pass;
	b=zvwRdzM2Yf5MgLuF3z0AdoS8MFtrRgfCqpdJ1za2lTlwhfZoQ3pz5qMnnUpbLuuLSlne/M
	DfB0vVx6uGUM1U5+zV9bSc4uGgti2QLwHXV1zGtMPd9um/5X6qOPxS5caB+0BuMwI40rT7
	3Q1IfHqDgZZGOLWP76xi8jgW2J8RGaY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gfVKmOXi;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769022009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
	b=aN3RtW1didrzncQe8+K+jAse1kch9R6nfFZDb2P+suF9/7BTaWojKQSXzX/6Sb/96hHCQD
	DxN8vFzjoRRrxSffA8FsBb1wCqFTanf4YzjMCleLwiVfc+CURUTkQh2VADFhqGyIPWO7TO
	72wLshI+pb23z+wOXfgAsz4pjzn+11E=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b87693c981fso20614466b.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:00:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769022008; cv=none;
        d=google.com; s=arc-20240605;
        b=ARkZsDw8hHwcQ9TtzSnMXZfoDmktFW711Lxdm4GsZh7dH0VZy3FAgp6N5wElaqHYIX
         FK+a0E4n3IuMRWv2E3dJkt5kjxfCxVLvO0CvsNpYfxUyv94etrgwumtEcXiNVe08U6Ty
         GcmU2nA8D6kOHnqiEKSXqToqg60z/XNU06XeVAKH/f6xNo7o7s7TByGhk2PMmCrwbwUF
         0QX6F7ZXtOOxlbYBR7OJNoN5K2dI8rHTw5U1OXlnS4r14/5oMpHFeqx9Cqs11rEhWJ5p
         kT/yiySr04xkJyG/RN9SjaI/ZOtAzHqxkeLNnsrJ94wRLscH3K3vQVqgfGsx72mtFvfn
         ndxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        fh=1n4K+ltSCbVxdPpFuCO+G8ku8HXmyapTM+Te8omxTBI=;
        b=We97G/pg2ORbDvojq0bVspVTPAqOE/K3lL9//Ro9xPkk4NWkRPYC7469a+i+qDIaSm
         mYv0TzqIUC100FrfbhyFSocajKBL6iiv3wwv+tQLfCo+gwS2P7HhzHzL+xCDjiUGAWnO
         zbEhYZfV/LlskbZHwtcKcNgSEtUB9zkryuJ4mjb9A1PvaXFYrizj1O6iPbW1WJV4oHY/
         3Pvcijzi7pQvlCQV3Hj2AmZ6CVfZzInDr4O/kv5G5Io6Ftl0IpJwBCCvfjJrIp6zy/MM
         /5MZjiTZLYLd5fNHRpiEqEiMzrpaLSkT04c5IYBsMb6PqCAiYiC9dBcKLGqjzms6R4ev
         oarA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769022008; x=1769626808; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        b=gfVKmOXiUmhEBEsTAjzacMmEhd2euee3CJ1XliBODmaMTuKLtjxtuYiJ+Pn5a/2DRU
         S22KLJe0toIU6S4Uf8T8l8j8JaIGV8aEdYqdlitaTfJwzvnccZKY4ENfZamHPXFRgphr
         M6qPzquV4zzS8jhQDjp1gYCd7krycpt2tXR6EkpooeSsr8INRI3qZ1BPRIqIeEvwqFXn
         LqmdVFblUlVJuKrQXOLW5rTOvWyJv4RxMvjRxfC9WpQ+eOb9Lea1Q4Sx6uKksNeUZ6Co
         QR4gyrmrkZ6Zb9Iwew/LnaACDDSpDizYCi3MbD4/Z7p54SQJUggBYhdcfp3wkmDDDiKF
         ZUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769022008; x=1769626808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        b=ajBB0Tr5/bCfXdGSaUd1omRAu3VSo4F1pr831Fb3eFxEj1iIfFSzwzSbaQujPap4Io
         +x1oTrrjhUFZ8nA1CnV196U346RNwuQcBphaYhbLbVU8V7I6N7dTV+ULWcZKhDl7LJqK
         nDb6ol0R816q4KkuAFAgvaiyJ+6mnod9hx22GIU5OVQge6Gb4vQ2pAc8VGlDITwx+sS3
         +14cY6b2j/jOAtfn6SEN097roUEtJ6EOWHqbrJaz0pP0/2DnYIppXr465awOcU/Vk7RO
         D2/QTpGxY3XVB3T7ETiEYYjr1LpiHch7LnxrLeWL3TJgOibaGqvRDWeeKH72M0gIhh8L
         YGPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXonyLiDH4+ZPYpg5weTbfzptGdNn1g/dM2rnrmj8yHCXCzxdFf2HFabboYf/qo2K6ZyGoTycq9+w==@kvack.org
X-Gm-Message-State: AOJu0YykgG4vDnBr3qU1RQfXS0J+j+w00341VzOqCNsDzNQU9BLdADDA
	jMerSepSP8N5FhCohYu2nxpfF47Fm/PBdlwwbbsHpQia6WyFUVRnIKA8iT7X3e+BOtrtbcZx7yz
	AmBbjyqSn+jb8xno+L7P+ZCdHWioyT8I=
X-Gm-Gg: AZuq6aI9qCxKfufKw0Sh2hI19sbyN/hpCLh5zp2glnbNxD6ScakQiGGhKwiZjl4EcDF
	lbOd+hpBQNocvEhNz71SK4II2etZ7WP7IaSyrvEKzb6W3AWhFRO4c58gLbJnNTQfV2C32r5E3qS
	7zafeOX0JieWN+iF3VaJnnPgRNNHGogROfRzzZaL4QpuSaOU3Xy/gAFSf+/6QGYONlfoHyTmeQM
	Gf1D/nCoxX5I8x+kpcFMWNqytcXIOj7xDVkH+WJGhnqjSInLTWcNvjqdlAAcYOiWEM04ZW7Ryw7
	2ZbSjhlXZsb6W2upSa0+sTTAVBU=
X-Received: by 2002:a17:906:6a13:b0:b87:206a:a23b with SMTP id
 a640c23a62f3a-b8792f79852mr1477117366b.34.1769022007470; Wed, 21 Jan 2026
 11:00:07 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org> <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner> <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner> <176890211061.16766.16354247063052030403@noble.neil.brown.name>
 <20260120-hacken-revision-88209121ac2c@brauner> <a35ac736d9ebc6c92a6e7d61aeb5198234102442.camel@kernel.org>
 <176896790525.16766.11792073987699294594@noble.neil.brown.name> <ccb32c576cc4ebf943d5ec35e3d7ba4ae8892acd.camel@kernel.org>
In-Reply-To: <ccb32c576cc4ebf943d5ec35e3d7ba4ae8892acd.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 21 Jan 2026 19:59:56 +0100
X-Gm-Features: AZwV_Qh050IhjThhArfxNo-53HjJR0uLCcITEQOtntS-75Lw875opD6ONQssxps
Message-ID: <CAOQ4uxg+dC1o+6V7Nvxf8UW3H=0OvsGjEe76LNY6q8ZcpGDDJw@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B721FC0009
X-Stat-Signature: j4xc7ikdphfnzghuy47xuxgb4epenhy5
X-HE-Tag: 1769022009-308715
X-HE-Meta: U2FsdGVkX1/bC8HTB512VjncU15EQ9B0HUaDOaKm7PG95lSgE+04mcJfsdvi3S1bApXn8ladfaql4EJqfnNrVqUVHFEG+0xZonFxEdn7MrJH7kuZ+a7Nmudpuh3FCz+2m9Xf2/dVhmtGs08Ihq0EeFrJRFMSfP8CZyjQ67f62btmuzWVoOGffZngqaofet7ujnvUCH2g/gFVkcL/h7fq1z1JIlOqxK0PboibT6gAY4+0DjaV6m3aIZVxez9g12PLLetH0g9Vk7tSrfRTk055EXppdXh/665bRfBEHZa+V82ssEUCB8N5o7JIRa7hB2ArhhUDQmMUtz1xw6Pwogz7R694cWebMEPWag8D+fLTN2ZtoN8JObeM4a/izMgN37klap6WTbVERmiSzwAJv+CeARzgS5bDqXny8x8nJt1S1qUgMBw3eMH9olc0bmPW8miBIFRRGuFwafaP9pq4JFWzLEm11BmHIN1ULykWF15lwkG7qGKRb43ro/byqC4ngoqhnJqoURUJdvOe20ArQDzgidRaa1Y4SaAhgaQaiVWgYsAGpPJ/FxCU5c9Adv9o/sb9zurPXg+k9ojj/a6PKw5zndfkFe3OoSGnJm5tXl0I7cPq2YHSA9lSRXDFuLUgb1rhlOImSwTkYizUUd/qMT17CP6fHwyUVv9mciTcvTS2XfZ4LAiPuEhTJrMf4e9jSRlfOaktSLX4Q2jYS6XEgXFUSkHm4hUm7pKeWzFUQXXsfP8F0WdvTVOi7vJc0lq+LBC+YQJPLQkHkJ5p3Fddg23rRC5EFSZiQErVUqsO/oY9nkH3Ug9qZaurB6yVxQdQ/zz8BoQqIhdXdtAMI6lol59S3NmV5l2LvTwOJDBJi2wDvTjVV2i3R9vRn91cb5LiHWklAdTfoIYe42lY2bTyezEic8gjWVsvhzAegVrOyBbN0w7ZAOfaOsvShrp4c00EtjNElmxAaUMm7/4Io8IeTTv
 wgdU6VyS
 GgfrtJM/fji7YoyTN7D5iFjsrncoZbGWW47ei3FQAG7GsYiBAsyLMMlG8YjiLwYQwUKgDFWPBr8zDxaFd5DOASv0hFndsMFoFbQg6gNy+1cQ5r9nLWiu3RvVCkX8RCbZk0vYmBhXzacMJIzwaJik2ug9TiJ0PCvCgOn2+gC+4TULNsrm298mL6zH7m2Q0l+ysJo6WCpmPBj/L996LBy6P7w9C6Ej3PdjkXybXVBlIY8hMEIeoqVPv8WkHfUJzm8mVOqzAgIjPr3ZkWb/s9dk+SnPtdPtw1LpMVR1Kk/8UWaNnB0XQl1yVcY0ys92CcvkIhEfZc8Yt31SaN+2D2PsTsGijyMA95E8Mns4mXrdo3tl9JrZ/j6v90jl5Vbq9FIYkY4wPyLCEWy0autlcl+nV/HNOYkGHG104mNJbCNqQbaqmfZhsy0xswoP1Mhv/gdhAiDH3ASZn5UK8YMxp+vahZPWfFi8K4OrjtLJ0jHEBb7ae4lAw8IAdOlsJJjJMr3b42wXvmnI8fAYmAHwI2o+kBRTnkan+NEXsnOQDS+s3WKspYCiJqGhuuRrlzSPka3Amym0R0ILZVtLAuNu887bJLCV797rGaPHxr4Ze
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 12:56=E2=80=AFPM Jeff Layton <jlayton@kernel.org> w=
rote:
>
...
> > But if you really really want to set this new flag on almost every
> > export_operations, can I ask that you please set it on EVERY export
> > operations, then allow maintainers to remove it as they see fit.
> > I think that approach would be much easier to review.
> >
>
> We could probably do that, but I think the main ones that excludes it
> are kernfs, pidfs and nsfs. ovl and fuse also have export ops in
> certain modes that exclude NFS access, so the flag was left off of
> those as well.
>

For the record, my comments regarding fuse_export_fid_operations
and ovl_export_fid_operations variants were purely semantic -
it did not make sense to mark them as _STABLE_HANDLE, but
it does not matter if you set a flag on those ops, because they do
not implement ->fh_to_dentry(), on purpose, they are not
exportfs_can_decode_fh() by design.

Thanks,
Amir.

