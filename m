Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A90C2D277C9
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 01:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2656B0089; Fri,  9 Jan 2026 20:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6856B008A; Fri,  9 Jan 2026 20:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3186B008C; Fri,  9 Jan 2026 20:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF16E6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:48:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEF0F1A1079
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:48:04 +0000 (UTC)
X-FDA: 84314368488.24.AC7DF81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1262C1A0008
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:48:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fu7FxrUR;
	spf=pass (imf19.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768009683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGJ7du8VQFjwWoJPHie5gQy0pHDdQ8AKRzAoeeB3cHU=;
	b=DTN7/Ao/zt1wwzpMp77CBImq0C/juwnhtfIl1fTEhCPO1mCPaPothMc9iUGwf5WOt42k4y
	hFx6H+TdKs1wu8Or9UfzsBWDF7r2T4uUJc/lqs6MwgJec4GADeX9nIId7n5GIPlN6mq0GE
	XvOJnL+bth+H9fcYYIoOYsZLh7MmHYs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fu7FxrUR;
	spf=pass (imf19.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768009683; a=rsa-sha256;
	cv=none;
	b=A33DnD9IEtD5raLLhoO9ZrsOyRtHtMAzjK+TVYDzKUI295JC42CMH6Jh3wIOGAhat6ZeYR
	M8aloALYqEPpxiiIKWIxAz028485aXtzgp9ctl4OKgi97hWvAnSQnINOTMIM/QmgDjIG+s
	njbBIh5w9I7ueTicQfivsRdnexQz9Vc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AC574021D;
	Sat, 10 Jan 2026 01:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAB1C16AAE;
	Sat, 10 Jan 2026 01:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768009682;
	bh=cdF01HTymcjwXfQS8AcBirvW01pDXmvEycM3L47DM38=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=Fu7FxrURqv63o/6rCcdW5OUCW4q5tJDwdMX16lkstwj96Y3ue96Q6p+PXYcAkBSTE
	 UuBIQcMoCb8UBhZ3VgYGY9Hs+mposZy8O/TAd1t9B2FHXb83g+J13cZy/S+COvLI7A
	 AVzdxtl+7sZ+ARe92YM2Pq5SJrqPzbyS3fbZcI0XyVKr6eLq08Q3Rx/Lu5Az1QejVf
	 c5L1AD5mIN6/tM9/vPJ6O4DOb+2koTVlkEeccrf23n1J/Asfg2W7yZt4cZtExuiJ/F
	 dREajCpoYlb46NKuspiGJYA2YFWhQ/LnSHS5B/M4V94u/4Hn/t/pnkaQiawh8m0Fnu
	 nh/QGL+jmgSBA==
Message-ID: <772e9b7d-6d83-4495-864d-f506211a9d62@kernel.org>
Date: Sat, 10 Jan 2026 09:47:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
 ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev,
 linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Subject: Re: [PATCH 08/24] f2fs: add setlease file operation
To: Jeff Layton <jlayton@kernel.org>, Luis de Bethencourt
 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 Nicolas Pitre <nico@fluxnic.net>, Christoph Hellwig <hch@infradead.org>,
 Jan Kara <jack@suse.cz>, Anders Larsen <al@alarsen.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.com>,
 Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>,
 Dave Kleikamp <shaggy@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall
 <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>,
 Alexander Aring <alex.aring@gmail.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Xiubo Li
 <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-8-ea4dec9b67fa@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-8-ea4dec9b67fa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1262C1A0008
X-Stat-Signature: jmcbaok8dhp556hzikibm89kkzap3yhc
X-HE-Tag: 1768009682-568651
X-HE-Meta: U2FsdGVkX19VhljievAPUPDLaDwzIFuqzs5RDn0R1hOwHiFpXRhzZNadnM6zH+jOTTrZoAYZWmm1wMwkZCJqROacrtwz5GugZrhi7zV4TNh310UgNmLqLmkrgy/sok1xtGpp3VjRk29715rSayD6TzvFgj68SijtX7SSSNlfknRU/fpYV0ny6wV5uEZfUE2X9iokEBOdDap6oF29CwumJRjTQSr43UWrDS7wdNXN9U9NNxIo17/jmSRk8eVfIo4WK0udlskfCctAdnWuFu+KOGJlOf2o9M1Qq86JtTPsAg6jqWq90pq7/C2ECKDL8QqKyApgR/m5iluw6P4q4/aL9yMHtUzzZa76wb9T6kmVKhNBmqV7U3pyUADKIzLDteErvFxf5rznnYt5ZUJTfiRGR23vxxneJ6uG385xYsvZG/PcvtFvER/KLBN/C8naU4qNtiqOKbvl7oFmy/KkRSGtKCPIJwYubclwY3rSkHKLfqkgCwHbdfnnc3nWwCTTiEOdFVHcbZSXmkIhZ+2T49R8FjX/ec/ZoPF5LkG38mzC30bH2a3kCMO8fEy4ajv2y3cmCX0BHnH91TxRo4N6D3n2n8kDVYUUYEXeRkQj7hsenfUz1E2rsel7gEWxlC2s1Uny6UYWNf1rB+DYnKOv3zUGPewnqHne3sGDgZKAKTW9C2p+7myVkOjdPWNcb+tvf487lgMF7dQlKOPcgNykizfiL35UDeI/REXwYFxYOtufpnm0llnezFTH/Z8c78TKnPfhLRO53FR9Ack6qzIZROLVpOF6tH9aJyekhcjf+VVnkG3VIkGPT6Fg5xvkVXLzAxoyyXXDWpjOIDB0MQxUeiktgi+Y8Oe9lBUDtBP7MQ190FC9qn1IPxy/yzTG/IFiTillYw3l70z3QvOLQ2Ra/PRHkYDiDcmDRx19LKLT/49Pj3jE/JgsEpxOxQNVN28VWK3aQgJMsy2cUAaI9+KZZXK
 FLQqPRdJ
 cTVXsUz1JT1YVpqETMC1phfOmuSPwQmIcfw13i/pDNDkBwt02DY3JXEfDUcsAUCB4Ni6uH0+Bpwwth+R7Dv18q365lnL8EkRhFfYiuIQnzMJ9CW5lDG5sQNBLxUrsHYUSe9YJipOVBQk07XSsL4sjwyH01g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/2026 1:13 AM, Jeff Layton wrote:
> Add the setlease file_operation to f2fs_file_operations and
> f2fs_dir_operations, pointing to generic_setlease.  A future patch will
> change the default behavior to reject lease attempts with -EINVAL when
> there is no setlease file operation defined. Add generic_setlease to
> retain the ability to set leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

