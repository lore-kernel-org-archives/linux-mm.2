Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8279CD277C9
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 01:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEFB36B0088; Fri,  9 Jan 2026 20:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD12F6B0089; Fri,  9 Jan 2026 20:47:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF726B008A; Fri,  9 Jan 2026 20:47:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7E236B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:47:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4AA8A13C605
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:47:36 +0000 (UTC)
X-FDA: 84314367312.21.404B01D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 74750140007
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:47:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aS1PPg/D";
	spf=pass (imf23.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768009654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZWEW1mD3/NQHrMS1jEqwJg9xM6fxd6FqkwiyYjKSIw=;
	b=NoqKcbETPwMpqPsLXDDc4nUw5viaHYsGlipKRsKHeQPXyjHTvsPGbGbMAGILxK1Q/KD0Kj
	fT0XTs2jI4vWzUgvanUmV6agWgqvVI5sQ0ez+YYeymJ3+MYw0bTpk34gadC4qwdRW6p+mO
	YBkTAXb1/pCV/rmWe/3ncxXGqhtXv50=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768009654; a=rsa-sha256;
	cv=none;
	b=FftmuUNdWoVnRumxAyBkHYDa59/qcT+CWA1aYU29WqKvmAPE3ZFkf5tdXmPKg1qNQvb4a6
	QVD6/V3PlllDzA8wDEeVpaEIx37FBjE6SwYEFDGqEQ6RyDbuHPoM63C3/lw/myZJLOGwet
	DgDhpmgzWVgAun9y65v1Zyr9fVTjR08=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aS1PPg/D";
	spf=pass (imf23.hostedemail.com: domain of chao@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35A03409EE;
	Sat, 10 Jan 2026 01:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9FBC4CEF1;
	Sat, 10 Jan 2026 01:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768009653;
	bh=OKPFCC1ojmEDlLwUQA1PrvgWaqI/QFfkYIRaHHjgLI8=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=aS1PPg/Dg2j3WlAEK5nHwD5i8kCTebxLR+i8vwa1Umz+Wef0tfIentBS0klMYZA/0
	 jcNMCTW2byAj+2+1CuaM8xxEVkIBoJHlppRtjIGo5fLkKKWAuHZa5JPyHvx4sw6t+e
	 +SwwuwOcEtWTrjgtkf/FhomVQK8mNq+RpWJtAVY8ZEyUrj+ucRRxGYTYp7Xp/qex4E
	 afNMjdvfkLqjaXQpbL974EbmrZMtjQ5HekIFhOGbzOSFgVlWcBwV3eO4AhalhUZOEB
	 rsyBo6s8Gp7OWORYRudl7fUPvCO3D2sc+9CFLGsHY1Zv/TiLZVK9d43+cGel2wVRPX
	 PWiI+/c4aq5zQ==
Message-ID: <35b959e6-a91a-409b-ac3e-f78aaf60148a@kernel.org>
Date: Sat, 10 Jan 2026 09:47:29 +0800
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
Subject: Re: [PATCH 04/24] erofs: add setlease file operation
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
 <20260108-setlease-6-20-v1-4-ea4dec9b67fa@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-4-ea4dec9b67fa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74750140007
X-Rspam-User: 
X-Stat-Signature: wnhx4cc1xebzgfghrdobjd3gf851s4nq
X-HE-Tag: 1768009654-659718
X-HE-Meta: U2FsdGVkX18ojbxdt5i4Dz0oqGWQa3qAZEqjEmjOH5myVbDbOWREDEu9RTpMPWrU/wG1vupoapEm68MevdoI8u0Go7JCYEb0pyEmoeGAqwPgtFiNAWkqo3NgwHwEDZwvFNmTgmQsnsbYQ+D8Vc1KAqs6Np27HBRT/pD25rCECYcR3K342qHrLkhZb0yAefuUm2fv8uIZp8pbOrnMUE/+q+SaZNgqqO7jDqX86YfDfS6Q1u4lOy8Wzko0K5EZ6TQqqPWJkx8poHNHsbln3sKeejZKrHXjkWBSaVJSR/F6THrYb9Sx4N8JBUK63KqlGs9q+zjBSATUbrAV93arLaHJZ3ctTaFYDHc1RD4evlfVDrylFn1r0eJTUKbjiksVxItugiVX6M2FcEOcuDPerK1fVSK3XuNFj+tjtUl10nAVXfa5Qd5OKtkCQ9cOgp8a/7iauPRHz76EIEFYiBF7ncxkTm0PGtKp3Zo+wQc27ocRsDVi2g/eDuGCWk34vzZGOm99TpIui9dW/exXdEE1EqUQMb6hHUNom6nJDxsuGceMw123bWW+lAJ3qsDa/gCu+LmG9l/gTLjCi6K9gmM/a8oZMCSfyGnWZErj3FKogrXjJQoipgbVfGnXJe5cjBuOoBupp4rVaUSB09wbehH0GcYbCwr1HvnDItrE0Zs5VVB9t9KhAW+nRMLxIBi2sgM8sV+tnJXfKNfQpkXd8ox9JEgBcZtWyWFIt4IkbWfDgEC6sunJFRdwIdshAYJGUiGkceuzNxioiuAz2MVRv90EDeqPC/E7wwM/VsYAIR2C8nuoe5yyOwRFWGpNLoPxy1ncxT53nfJIxNAk4tgKEUFhvRlXlNfAG9t6honV5SUpMEo/jS/r20TrYXsqkJ0RAozNgUXRAUd4hgmd+TMsKPix+prAAk0e5ea0v8qjItxdGU5r75VP9tAPnnCZO5fb+IzV3xehaTz72gtX2n9RTLM3QgL
 pwbsRY+m
 hMhEtterRs2h3kuuohR+0IXHLcSFWh041HQIFm9GShQGlgp4V70ozXjEC2EL19KN+pCjIMrPgKGHIrAl9e0aZvw0JxfBTuAqVxdy77mt6Tu2vm4RBjDQ2FxACV18zyWzDAn8VmB5a33PJajK1/jLPNtSsGqZl6l81qAxMLBoatdQNvz0ttIYsfdJaExSjQDPYM9zTssMkHgcXFNHnnmCm4SLz/0+lHmI5IvHgIoNYb2XmQf9ot2QIV65gKAf5BezyK7hr1u+6MYhpaD7E18iWKrGysyXAa3hlh6DfAeFNJrhQFFWyPECC6up+AWiSdDla30QkSnrV/zpjAlK1G31DaCpS0VSCl2Yt8myHo/2Mcl/O6i6e6V7LnObNq6gVpK7J0aG5RvBwawPlo0jBEAFu+VtZNcTXdsQzuh7ACMNOBF5k43fr40+ASU8xeAmbSampK7Ky3cM2v7YV+OFJBhgZ8bd7+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/2026 1:12 AM, Jeff Layton wrote:
> Add the setlease file_operation to erofs_file_fops and erofs_dir_fops,
> pointing to generic_setlease.  A future patch will change the default
> behavior to reject lease attempts with -EINVAL when there is no
> setlease file operation defined. Add generic_setlease to retain the
> ability to set leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

