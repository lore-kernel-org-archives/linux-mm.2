Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9346D46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3046B00BB; Thu, 15 Jan 2026 12:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4D76B00BC; Thu, 15 Jan 2026 12:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C13E6B00BD; Thu, 15 Jan 2026 12:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 293966B00BB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E814013AF6B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:23 +0000 (UTC)
X-FDA: 84334937526.11.20C8404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3D8D018000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncKx34pW;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdhUirb/YWthwGbnbDuSKExYBUqRy9BVrPxpIPyz+0g=;
	b=F7a8OW4+7G6pQ8eLxgcGe6KlV0T5ijo7UV3kdPdNoxtVot4+cDOruC5lglVWui8UtSsC3V
	JTbLDM6Nn8hXuvdZQzKyb1HYiyNd5lmxoFwaWYBVXFz93hQCP2+gPUxKVF9W79ORMO3YTs
	Rr+cKbjlLWKAghZouMSK/ZZVGVGCH4Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncKx34pW;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499422; a=rsa-sha256;
	cv=none;
	b=lmHLZv7ZefSWuJT5HOZktx+H08NqQnPIht9aBVDPq1Ys4F54aKzRJSlaYxIgvZ1Xhb4uih
	GOFe7zgyFVuCz+BTL+y9zy+j7aldApavLf8W/uy6FDTlpBi1SOxgzGDZ9xPkKPZrc/5w+q
	KYY+uTPsKLVUAuzFSazepbjI7msoEH0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AAAB4601B2;
	Thu, 15 Jan 2026 17:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3663C16AAE;
	Thu, 15 Jan 2026 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499421;
	bh=ksDOdJgrlY0p5ZvKqSnF6dLYZLuuHG/nH15DeY9s8Cc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ncKx34pWjFemMaBjR1MOoBOtd9hxTIgtD63Rs0W24eZ/eNaJJ97v1ntfo8Wmd+pLy
	 /y4C7B8Z4NfngHzIpkDISFbyonBVP1CdWXx1hKT5QeZHxFk6pHjKf81Y/1Jg2zfv0q
	 wO+w12OcSLMzqqroVFATdQeLyqs8/TSanPkWZBM9ioDzXyUwUDE9X9rVXOVltyW6RA
	 UC4YXYl6PEbjUnzxsnrKDchJhbzcvRHJTjap1XyJ5Jm8Cry8N0z7QzDMs7Ua3RWqRD
	 J8GZmq7ZexKTShjhJCWfqY2IRGCHR3YV7ELYiXaP7uVgdUXP0GzSg/wU+5LBpFyziy
	 5WCUJbU3jNfDQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:52 -0500
Subject: [PATCH 21/29] nfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-21-8e80160e3c0c@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
 Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
 linux-f2fs-devel@lists.sourceforge.net, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=710; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ksDOdJgrlY0p5ZvKqSnF6dLYZLuuHG/nH15DeY9s8Cc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShJPGllJakzZ/gKe1G8QnikNUgRJxvkj2s8k
 zvafiTCEwCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSQAKCRAADmhBGVaC
 FQttD/wP1GwYIZubDBune0HMfmmzXPJsdHzJsaS/iWv7lBy3/gNUuxVn43OvoM3e25i4dal6/7i
 aHB2odWRq/FZezm6b+CRVCMD1Lt/1SS0RyOPLyZRKklL5aJd4OblZXpIT7J0j770FcCOZpGAsV8
 XmNAex2rqagFsWqq13syrXXt6kOlnRepawYzRzKHOWPC43GCaGfLFwQL0FHekPhVcE/EeZXQxh+
 cM9n/3AjZFKYtJ6Rfdpg7sakP7XGCptExb/zSvw/GE7PTMk6goO+0Y4vWmAVK/FjhNAdZqOpFbb
 mJt55VuY6fntM4hG49ouBvnOiStM9NYN3EEJRus3aPk6R9AjRDLX2asOquRSYASPIzjDlNRyPso
 5H5wUH+PEaXsXwoyTQrVznGsgAo6019vDYZPCQk6oesrECSYf4aUhKAyQCrZ+nkxE+vCvyCr5Nn
 BoKRTI5I5u61+IoV7QoI6Wn4bBnndE6IBAx82gIHuXmcjVuRucM9BU/vDZKYmKC3OIRsKW0cWGb
 Z02GPTSTJusUKo/mi/9Jkhkc2zdQLK992Mv19/6xLdIiTah8cUc8QDHDJT40b7oCbIot/Z9/EsU
 FMt+OE1wrAe77jxGWSBnTMALz66TvBaethmNo+WkNkoz5oZzp/KCu+y7FIZhnmfx1OoUX6J7ksZ
 UGocVC3NmrtajNA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3D8D018000E
X-Stat-Signature: iq6pwkyzct9ogourhq1grq9ozmwn1jhz
X-HE-Tag: 1768499422-153452
X-HE-Meta: U2FsdGVkX1/GGI2GXn0Ta7Wl0KzmCrotIEyzwiWkXbcFaHpya6d1PbWWZfUxwniq/1hBqrZ+SizHDf251Ls8cV3GoAm4TjU+MYr4fVWG+jagDOii5baKEcXP1CriUA8uPv1IpoEIuN4EU0hMXwtacOI9WFmxn6tyc7WRu4MspWPwy89gNfMl2wwdnLKOkj3G2zhfZG3pytWAcNXYCzydNdy0ETEF1rgCzTZuwrGciEjorckY9L1fRTpJ0UrkFJazP42Rq3S5q7UYO3PauQciQVLSSuP/L0uF5hIKPCo91gjkeAXEv2KLg98GAJCce+NNUm+bM1t8LjxolOsIxd1eHjnQa7j2RBLKkpE15EQjM1BDl0ZPnmHcCGiTmr4s7J7MFXOPXjxQTndbx/SK8+N1HuIXyAljSNTct8rk3NuECyuCkKZUmjOq/wYr5ohOyYPYz/NCstgDOSlZ4ZHKBQ/4WZdxl2J2u4Re3+Scc4ef8tO6DTO4BbaVvi2wJ18c/s1Dr7LISj3WKB7RRTq+RkK5DmHBnH7MNlOwp2hwXD06HhrbjUimDUxVE9Hn1Gf/1Gb3U4y9IwD3Aq/jV6GlK1c+yobS51IcD5K//TgJhcgcVRxy14w6Tppl+UZi3pRwqmkhufoYljAoxQpMxxQgYWyT0VT61krD/fybHFYnwlqLiDA0eNZSwqzs6Ylhj1Ijw+l1o7fGMLlJkbeuetgFVO07whxUPaYLUki6CZ9VOo4TZjQdqGQgeaFA36iqvTqN8Zwg6w3PC/3rDjkRqkEJclUUaxdD/Ve9/PhnGTnwCKeJ6dWWjwD12M5kx8l0uGYjT9IdBmwBZw77T1Kf+l+PuUn6npNAzSIWqCYW98ZmeV0I7jZRUxT4Cff6wfpz4POH5Wkp2JgAS5LfJXHQGjM+YPaYB2Mr95sBwdAll3TB5g/eAQShrVINjvV1G/Ej4EE5FxH3f66s+VbZqbhsMeMb5YF
 9KPzYwB9
 G9xCv7nOyTkaCxYtRKvn+HDfVkhcxAPxNrcEo1nKFQQdhKAaJNPBSqxeWky3gchdVkN2C4R7Y+GE4QBrzCfQkgV0wpTd2S9vEfdzXLThXs8khpFYQAGbTER5pQ5o6PZGxClMtolrgbxyx4cnziyYQfC7UuiOSjyBNj0wQr99p5NhZjkAh7UvPvvtsAJTCcNIqYSCWz9YR+Rh9Pu6O+Stubnw+WEHgoXH6+6Q9MYIYN9l67fUFxmWqqJhymUSTMoqn89tsBV8uXQCQLi2J34A8G5hXFahC6Ut9sZm0Z/b3m3esKHer5il8/D044KEkWO/Y7nQa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to nfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfs/export.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index a10dd5f9d0786eb111113bf524a1af8b7da0fb6e..7592ef347a2eae5d6305b64effd22537d5ef5e74 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -162,5 +162,6 @@ const struct export_operations nfs_export_ops = {
 		 EXPORT_OP_REMOTE_FS		|
 		 EXPORT_OP_NOATOMIC_ATTR	|
 		 EXPORT_OP_FLUSH_ON_CLOSE	|
-		 EXPORT_OP_NOLOCKS,
+		 EXPORT_OP_NOLOCKS		|
+		 EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


