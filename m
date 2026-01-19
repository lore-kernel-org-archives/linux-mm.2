Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0870BD29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E20A6B0285; Mon, 19 Jan 2026 11:28:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2AD6B0286; Mon, 19 Jan 2026 11:28:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB996B0287; Mon, 19 Jan 2026 11:28:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 473436B0285
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F86514018B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:27 +0000 (UTC)
X-FDA: 84349246254.14.D9CF02E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 83F5F120006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJKjaF8o;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBphuM+k5rUsfY8pXRdrXBBG+auSp5TPclN3VGfMpMw=;
	b=i0FlejsFT2tyQqtIs3bqo8j43llqlu6OVvMNWHWwccjGuhLEi/Qo4Tch5fA/LttOeG16GX
	2JmLnZTrshZ+RR7iPlgLKRr/GdIfLreuZvWJmmrSQfLrEjUaJRH1yz8MCOkmHMEk3K6Dhh
	negzhLtDTxngeERLRYHwXUILGbnSdss=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJKjaF8o;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840105; a=rsa-sha256;
	cv=none;
	b=jk+9iIAIkFY/SGzFVQFQhzbbF9f9DVRxgyPrQijdgfC9I70Nthn4y3r/u5wQEofOlSBFQf
	IyBddMOByOzyznKOIBo3UA28GilGBV5umSUdM3b6/b8K0t56GPREVI2z83pW6TmyIcxPHT
	1EMMrIaV6XC8HYWWUDZotBoVwuntIRI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA31C6015F;
	Mon, 19 Jan 2026 16:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC61C116C6;
	Mon, 19 Jan 2026 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840104;
	bh=x2khPUUCfCV6ZHITK1kpgcwN39t2U+Jx7hzhd06hCuU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NJKjaF8o2BvQf0lZo3JR5j8yKQWUqbZaVMaucg0C2gAY7K613riepptLGYNGkjS5B
	 LW1AiCj8azKp5kKcfysLFFkKHO036/KjYmTimnvt40NtB2a6GLrAx3+Jntr1TP5P5F
	 MDzaqdPTdSpMulnzOIN9JyqH5T/xodDX1QSS+ItEd/mnwf+DMO5ERX0odk5EVZWTiF
	 m7G3rt08Hg7HgPZDSuqwG7w1v91ex1fNu9EHbC7dhc5Wn8hE19ATEpvra+Pl3Nsykk
	 Zb0la5tlztNcL7LlQQx+i3zLc50jGfipuklNdgVLg+ANoGPjsTH3MOa8nnQroHJOak
	 EmL7aV9aoTdcg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:26 -0500
Subject: [PATCH v2 09/31] ceph: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-9-d93368f903bd@kernel.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
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
 Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, 
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net, 
 linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
 Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=724; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=x2khPUUCfCV6ZHITK1kpgcwN39t2U+Jx7hzhd06hCuU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltbP/9gZQV2DEc3YZ56hrcGZmfoDaIAhNhl8
 71GFh2V4kiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWwAKCRAADmhBGVaC
 Fcz7EAC3hszuWhkIWgvqtaP7NMpfIAj4jYdz8JhqYJHCVh1jzoSx8uhtsLlz4U8StET9O2eo5QK
 6MUGG5HqfNER6iLS5bgRkjG2wDjX8E9iopPSx43wvER0Vkjgq1U8jBg2RzFYANb+9PjMsYmpiWb
 YutyhYiK4by/a8827D+ieAR0CuGxGHBirD+Dl+CLFunH8qtmyJ8d77FX1nTSt+klSc3oBcDXKjR
 TRgPy3m8aIZM4/I6lUMfZt5JHOlbTRz8odScA9LNItp+gtQGMpbSLvNJEUdeoT11kESD9/Y208A
 rF71Oan1XbCh6q5s55NXTzBtazswwEfEXh/8hPTfcO8dJy6l8Aud8vEZKw+QKAmuYX5i8tdF2tM
 kd3GQlDlMeJYcWI4zneadkxvBu3gYPsWGm4fh4HrC6rvP4zqbILG+yYKE1QsXaeqex1BGmTOlCy
 RtGWqZkQAjB2hrrQJWzZL5fGhELvmxcrTBzfucyMLCSu343EsfyuubtnISeEcFvdu5JJfiaFKbZ
 jWcfxHqkXjfiD/GaZ5U8UJBPdPcbFa9yEpm17SCHbm/7rEbaooK/jSO6FmTB4edy9zYyi2ERZyd
 5ifYN2ou0miM92U7fBoOt5pE1/cBzxuvwcIB3IVbfwrzbVr1BVGnX40AA0P2jOAylEtUN5FRTY3
 na81VuEcE6bQ0cQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: jn7b9mr115tk444eakwyi76a534sznnc
X-Rspam-User: 
X-Rspamd-Queue-Id: 83F5F120006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768840105-156664
X-HE-Meta: U2FsdGVkX1/74fu/62nyxe6zX06HHAqG3T2vT3WZA7naZl8x8nb33cFV9XFLa92Tfn7RDd1DmyFuWgIea91oWQ2oqyOT2kLEEwFOkJcKB13YDC5BkVCan4A3JHdmafNHh4SpKzNONAQf9rAUKA1Ys2R7b/2qsP8sHPlOwJBeDK6lGC02bxIEjXyyxDz02Z09l5nTUZVDYKnRV0kRgqLE75UTaWi6HqBHzi84zHh7Ot6IYBQSUIklWTsidHXClglRz6C33mr1/Q7JUX1wGhffn6bWycZ4DKkSBE7hdT/wVvvxCG/8/s3zWab7SrtvAs4vz/aLYCw33+ngE6uFCYapg3R6aFjRPa+CoRfXajUgjRbwej9ddehNv4nA+foeO4vKIMUOekJS/0cP5esDM8v4ng+WLPkYR4jHmlXkfgUiyxCBfCja1UtlnLMvjo/x5HVfTqvRImBk2b5I0dUKag1dHiBhf+EOsOUQtG48tjWTMPfjfk+VpeyyuchZB9VDe9G/g6tDsubBGc/3lrMxeRcvG75aXaaRjSMZuGGeT565WZB4qxPwM5Yroj5idzVM1T/s7Ht7nCL6gi1uRVHjKNXfxEjK3WOvY3NsEhZfI8u/myr6ka6aZ90kilwhzk/yy6dDUVEXIT701A4CNOC/9946BoNXSAga03EC/x+FRtm6iFH/d2DrD8GHdTk5CeOgT75nmW0zsJ70ChXGQTXVSx+evhZcJDI3clznBCS9Q3K+BtQ63l+1PdV0028Qpcldgdpex1j3IHlJYHfJXTskhbr/4jjP9HN6AXv1BlQOfzDjwrtRsm/jeizNyn9+Zy62Fd53TLklpCb9Lg0Ye4LsgHdLdBMmK0LIxzO2+vTwRULX7CvHV6mODR60jEWyKuyN1M9tUJkb+tCRCuntyfzhe2CJP4Y0BD8gEu+ZjeUqDfmfVsIDVCQbiYVYPQmnXHIhzxt6ZyQ1mNFfkVkyT0Q+Glp
 nj6CZ5/3
 bAyvtp5Tk3A2CDFEybcFgQA9AOfIsjslNsddpThn4oThP4bAJi15CLhBrjC7+hta8Hy4k6YR0++P5FuA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ceph export operations to indicate
that this filesystem can be exported via NFS.

Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index b2f2af1046791d8423c91b79556bde384a2fe627..10104d20f736a8092ed847ecb27030be286c0ede 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -615,4 +615,5 @@ const struct export_operations ceph_export_ops = {
 	.fh_to_parent = ceph_fh_to_parent,
 	.get_parent = ceph_get_parent,
 	.get_name = ceph_get_name,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


