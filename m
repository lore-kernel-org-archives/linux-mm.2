Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E80D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5036B00A5; Thu, 15 Jan 2026 12:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180436B00A7; Thu, 15 Jan 2026 12:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078476B00A8; Thu, 15 Jan 2026 12:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E752F6B00A5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3E9C160456
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:57 +0000 (UTC)
X-FDA: 84334933914.21.2DE1DDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0CCE5C000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SM3X45Dk;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499336; a=rsa-sha256;
	cv=none;
	b=mkwreG4kMO4fdKGY9kkyoqJzczUnC91yOc/HS8wCaOco5r50gYrpVNc6N0s2wAfInPW91+
	c2BqIK72NjlQJFtFKu1yEGWQrcu+UtTvuZ7j9S676jO3OpxiNCIpgxwi00cJtslbJnqqyJ
	ZZ8oxO7QNkvRtlJCZZytDlj5ogT3Mhg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SM3X45Dk;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcT2MNb5bbs1cagatsZFrbh+4HPN3saK3kpB9dL8T24=;
	b=K0ZyVC8sgx4FXYhitLcVX5sgjTfL/RNgHo8q0yNOzp89Iq5e6aZCaovoWbvBMFh45YPPSP
	33CzrVcIRqLzkXm+ZiAajKaBm3VUf4pnFwa0nBMrxizuPC3pn9FHyyXX6iVsdqBd7G4P8x
	iSM+tSgLH/xhps0qjHKeZaQfM/SEbLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C0AE601B6;
	Thu, 15 Jan 2026 17:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EDFC19425;
	Thu, 15 Jan 2026 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499335;
	bh=bjqNmWwoD40Qnk+TzNgJZFwf0QIhVfVk3tp13EbdB2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SM3X45Dk5uYSSa9zWw3XI4I7Ss6sYTSQtClsuuSbca4pRTbsigBy2OSxOWAVI21wR
	 eZ2Fh1LDbYgzQ6voMboihPby2Z1r5nZNmYeAGGwLvaOCqd/5AIKAgWF2Zt58oQCDEn
	 9WuN15JYC7TmHhHEDPO7hUm/HiRvG5zY24QwluGrGzdolaEdJpSPzPJYgp8+EtX1HN
	 j65MdUC0VNymAvQX7V5Bdy9+xqyXvdn1rd0p0de54gL6MLS06X5TAQiqXSFIUW/7R1
	 QyILvgn7ZlION29gYsD4ezO/kSWgzPcuIsJfdl7/fUSbH8RL0iPM5c9vQe2rKPXh0W
	 GMbfwrtSWhKkw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:39 -0500
Subject: [PATCH 08/29] ceph: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-8-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=667; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=bjqNmWwoD40Qnk+TzNgJZFwf0QIhVfVk3tp13EbdB2U=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShGa8nQcABAK5jEXI2cbk8SHUMrCeg06EdMp
 RCwhBgmYRCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRgAKCRAADmhBGVaC
 Ff4wEAC2JupfnsVYXONrdaMqx7Rc1TCYHMpOlEnGJ3bdTPbia88mLGCcKDAI5WggJ7XRzIcKHWg
 650uAma7Bno5Mhk90U6+216K/tjZqXt0pzb4+W1kBELjWr4uFeCBB/pUPuH0S3G0p8T0qGT0/TH
 7gtmc5LBWW13mbYVsuobNKq9/GgvX4cR5cH3j8tbU9EXcoH6fVcRiETTdSysAC2+ne7/IdzZ9rb
 4BwiU9ebeLiXmFO37Y6yMQjX5EOr2k3wTZs/r3XMJhh/Ln/HXNa5w8VaRxsO2XO5Vq2r+As561d
 h1986yPq1624DSdy06ZKpUJiMF+roEU0pm0B9gzRlS6VLTaUM/RJIoq9W9foUp7hx2TEdQnF+en
 6vrSImaQZeCd+yBOkQSIUzt9mHiFSIUvxJ3YCmipafSLvhMzVX2jcd6RjE53mi+W1N6cvjmxxRr
 RcyTfuZWdbBsY91RySpnu9RZCgAz73j9EIJgvltd2CBdJaq6iFblaeKSti2sskXks2Oc8+uH86Q
 BN6MElZwK605F/Q+8CeGnP770IaFbHsiDWQ0lT+TI/5RXwU/E4MJQ+i41xWwu2GcQcCTk8CxAIu
 GCWx27MAOo5ADN/9Bj09FzZbltqCtp3P4+ZKEVUNQSvNSllzlVlduvpsl/bH3/ubLxbBdVYsPBp
 kEcghw8IpuKyeOg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: uck5rqc5jsqqscxmtfbsgcnub56hdzuc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CCE5C000D
X-Rspam-User: 
X-HE-Tag: 1768499335-604810
X-HE-Meta: U2FsdGVkX1+u+H1ncrIJjWSfOlPLxV4roa9hYnxPgChyrImZytUiIGiOxoCmmzyZa7ZY3ZuZX3gqRUCWUi1HpCM0wZiGutNH0mcwC9t0Odhn3ZsXKXtAzxrN1hyQ3YnVWs2jWqmX4IuxA6GcGV9ZwjQPOjAMoNXGuxQlp/UsnMbQmftqWC91f1lwcFgDfU0eCT1upVKj+FwiktMRDXR1yLffeBUqmvR2OqvrOtUAq7DsBc84uYDbCPa62ztEFjg7p49WV2C+DhlIhfjR4HjD9klvmTXlxdZE4qWnsq+DOwrY6F403PdGBeFGCCl7aA4+8bd0lQSpploRRMXi9/Pds1MAwUPmMpYjkrA8MzCETcIcxJlyuyRcuxJihGOO74L4TR3Ikn3mm6We6N/VGaXPbcucwH0aPc6owGRfSiC3TfW/fZhGrM2Gd30WDOi6NycLG66fax1oEAwXFX01OiMVlhkn61wnIZy0NgMEf7KRMu9VoehN/qxivhUjTiHALCu481t1L3Jwjry1evgQWClvV54jXIlLPWOBUYBmb+XQzJHJ5Rgf1pRje0eRLCT5P5cDhUN+jtbE0DXXPPUOh55+ofSrthvUgOcY14SELFMyElXByi5G/T1nNCmEjod1w33KeAowbUgkJgJqKVsgHv5jDsqwaECwK8wx46d0X2cQ6fWXY6ndE3xGS7B7vZqXAW1X5uogplxqBG0swg67BFEOX5r9fvn5dksbQs9UnTMvGSKwKFWBVAkgRHGkoadrAFifTLyiCVOPnjAD8zvADcUivD3UBqo4nnN5yYK98VjLWb4jdYvs5xTerGnOPZt0Nt2eL3pZSyg360z6DzBiztErtjzH8IiaAf6fI1lx2c+2X6fMc2Iqk/LXjtd/8nqzru3tKF9FVUXSLZURZeYos6wjyQVeKglW28jwjcQac6Av8QKARACV/WVyIudtURU9q1zLDrmZ106y5y7w8qAI1go
 O9lcrL48
 jG6DY8lU/dTLMZb78knoDKSz/X4Q2Av/i4q2W5PRQkfR9Pv3DyYU3Ypdsonbu+NzsRZ7GyUTpKD0509o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ceph export operations to indicate
that this filesystem can be exported via NFS.

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


