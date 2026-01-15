Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47656D4660B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8646B0096; Thu, 15 Jan 2026 12:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99DC6B0099; Thu, 15 Jan 2026 12:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B85A6B009B; Thu, 15 Jan 2026 12:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5C06B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3723D58CF0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:18 +0000 (UTC)
X-FDA: 84334932276.10.E68EDBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 61BFBC0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/aT5jS7";
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoRx4iqvApY4n68S8X82ro128OMPf7po0KQOiKAg9pA=;
	b=iFMMi8Mxp2v3AdJqA7ksbdnLur70Q81+rvDxkaM5iJWJNo5OHoMYKawhIpDNICKXX3Of/0
	oUOz40w2EtTXJ2EQDLj0c2zf/C3aaPp8eIc6ZotTA7NUexKADatjY9Mfit5vA4jLtmAQDO
	kGeXtNbkDd2ZLFL02YasonH2bZ9qP/I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/aT5jS7";
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499296; a=rsa-sha256;
	cv=none;
	b=acHTWpxg49r1JVigENby2b1Gj2TETNbtOfoBvwIyp4YyxN0SwWkwg2sdRa7JtFcQfgBwlh
	t6LLx2KuU3E0QXz4isWcFF4G+k8cazTovIT5A/EH8EM2pV1qkX02Vys6AjoSaRDSGiTt/b
	w2p6kLF/S10qY0qU+PmpI5QNc0v6foY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88A2B433FC;
	Thu, 15 Jan 2026 17:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B80C2BC87;
	Thu, 15 Jan 2026 17:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499295;
	bh=eGzcrbK82AAYHA8mp9BK4OkYs2dNeYeCsyAFHAtDQCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N/aT5jS7N6QoemTXHYE0cX8UVkbOu2/wbixgEVBgnGYF7LhX8OhNz4XrWyrjWRC7M
	 zD29UA1bZK9fVBcd+hA6xYgcgJEJ2sOcHLu62k3G02+2GGzKX/VLC9noXIbXKuuT5K
	 Nr+33LfHhpTNa+foKCiyUmvvq00e+Du8qeu6aHkC+zm9MykELBvSIJbtqfNnq/OaOK
	 SF+mPjA+LVjF+9H+bIal6zl1BUwjpoAojxDJr4szcfYTYT5pi3BOBaWc53Pi/XWVcL
	 UUg6FGToVwTQewnPmGxKUIYtkaiiQBopAjTCdSXAr5q8BAP1a33Gv7jD+4BPFrdlhn
	 7fI1YzYPg+SYQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:33 -0500
Subject: [PATCH 02/29] tmpfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-2-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=687; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=eGzcrbK82AAYHA8mp9BK4OkYs2dNeYeCsyAFHAtDQCg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShEbLwccGXUC5j0WTeZML8RysoPsUjSds8pC
 JZi3m3aO2KJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRAAKCRAADmhBGVaC
 FVG3EACMORg6FWU2k+gTVXQsRhFWMoWdpO7xBjnubHZheO/O5JyWKYWNPX4sbXBvJB6B7Jk1/b1
 MaY4i/BdFxaDMt69GQfQWSs/ZjgMLW4LaHiT35v+0ApKcyuUcyUpGbePY8Q45RmV6DfOh9whS9I
 t8sVCOKSYWlli98pTJRslgDUbjULTXyaFW3R08JP3i5prQEUPNI85rq3Ia39b/3nRxCeLKaHexo
 Wh8mjzMVA3ncr3QS3JDW8EiM4mJqdcnsG7C0p0NsRXX9Bj1POl4qDX4/A7s0z02kDavF/u2IJaJ
 vzU3qxp6MoJLJtZOYAMJEzw6d2NIMsfFQi8pwo/iMRDwkqxsFpwRvT7h8npYMpXyQRou5PI4d0k
 WHlJK66KpzRjMnk6kiLnVvwtZuUQrYq4oVkkaWTcUB+fY19qVtW1hVVw7scwCIR3paw5NG2hfJd
 yGUZ66kVaTV4kRZIMqbz4YnHGfIFhEP3jeaF0kbPpJ5OOuVTBVgLJoD+69v4diy5ByzJk/ujYyj
 EnGCShycUwb0IGd7r5f1TDdSScJ49Fh85Zg86XLyxoT3TDIvfZG2VWm5VKRN81ifgwd84hYqGHs
 dMhx7JclW4kuJSjtBkrqYaWP3J4TCUaDo3fstC9n+P/mEEHHzveE3Gf/t3MD3vm9L8CDEYfw0rc
 Din5n2xsqXt5kxw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61BFBC0011
X-Stat-Signature: wa1kaj5au7ngmsmpeix185ong44jw4uc
X-HE-Tag: 1768499296-935943
X-HE-Meta: U2FsdGVkX1+WAEcpVmQsbq3XlxQD1sp79bT2ugReItZhBGR1TGFKFxsAB6RTLKojW6+MedXRnGWUWvJIIBzNuBcK4KpzBYjhR4Hk5IyQOyZeGHGPPBCM3Bv/pATI+7wQ7fmW/TdN8GMmVEapX+eGQopaTKC5MazN+zCZiw363l2MC2xbuN+nbzIcNJY/9nVXK5dAGGI5HLtAFWAa8JDnTgA4EZbfuGDlf/0Fzt+fU7egSejFoF8AZ2NLToEDEteR9u1LfXiMOnY+fechwqZM6tsIMakHvnaxWkcqOlBlMYbZkslA4CiWbDKXqORrvmNvGs0R1kWdqYJxyIVe+2feSu6mJqjs5f3g/ixyKLTIRgBgIN3cmyYI2QfmwkzBiH+D9vdyqaJ6Du3HCSHliVfmHMnCBPWG1YsC35Una0TKxqizR8/QkAyvF/24ljUxGZvcgjiytfUs7MzjiPDHtoApVCKgef3ekpjMhHMTrL25I3mFssDPz5+qv22miEBlSiDiRHpyWN4C6wJrw7rh0tfNPNqD5bpXZy2kzz+1acngpoYiJzdYGVercQAe2t78VOLIatu6Pqp74MZF+5bSaG7/KQqLz803mCVUmCWMbUZ4rOO7urQ8iC+Ln1/nq+hXIHDNSyNXYGkuhA40922ph0sgw0yxqh60wKytdKAdkrHqQdaWcsIhyYnZtfHzy83w+SqHEdQ1gGX2ovsOHrXa3tF2QwYPbveGR95SqiYie2ofKvQMTreZ9XEi/XSgTOz2BWByMq8M1joXDDm2d8u+kAlZ/d/J2jCCBaU6m/8k2Y32kjgD7vRdd78VkTZ0auolkBN6VgME+OqUwb4hd0TDvrwBFWhLli9mTOew+Mw0xnTIMVq742/bOL992PVgaaopS7E6jHTtI6oF5ZkD4Mngj0JmWcvRJiBc2SSbwaS8vrNqg7LdkPLeL1BvMx4FFiCdJQ5jX+fn5yXZTqVr8WqwXVh
 o+rpXFfT
 H3QUnlyPpnzU6y+i/TFXhXmDjiTjff15RhDyVNctinDn4RvvVr0Gs1wBfp2UV9u8ThZSvjhM8tXLgMZiuNyWn2CDn6/VbPO0W3hlTdPexN3BKy8pxFbdl4SUMoq0tSbnB613tYJe+qbVnTvznnGkBDniTnBbeyXaviQ+p+JZzHkIRSa0nTFYGQWtdDq/3iKKcdJWawzdoJvK9CdiE3oKQq2qxpOHNWgKbtTCMJtyDh6DeJb9c9JZf73R/KqW2XprokDbC85vS8gHIRE9UbY9wlM3pzXDQj8A4prlzjZJe08FWGORgmx8mm81hgqin56CZzZe3QfHRYHNOOTfTqNuNfWW6t8byniTGuGlzVy0uSwqKdds=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to tmpfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d2bd47db9d7506e4d6a565e092185..c64c4410b4fd9961599a5ea768b469d8184e713e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4477,6 +4477,7 @@ static const struct export_operations shmem_export_ops = {
 	.get_parent     = shmem_get_parent,
 	.encode_fh      = shmem_encode_fh,
 	.fh_to_dentry	= shmem_fh_to_dentry,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 enum shmem_param {

-- 
2.52.0


