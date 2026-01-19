Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1346D29C45
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F826B0272; Mon, 19 Jan 2026 11:28:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603F06B0288; Mon, 19 Jan 2026 11:28:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519C06B0289; Mon, 19 Jan 2026 11:28:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40B996B0272
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E2241A018B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:56 +0000 (UTC)
X-FDA: 84349247472.07.4AA50EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 214D2180010
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gLSidMGq;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KH9GAMr/eWsf2mOE7iYyuOGJooyfONtnMuRkvbB1nI=;
	b=SwJsxNhkcHR5CtHRT2anrXyUGQg7omQELJ1sJH3zo6EzUKIKZX70UIT//bBtt7q8TGjGXG
	4CDt3k6A0xdXYzE0qhaeDP0RIuM6b3jdrzADrfZ1GmgFZLHBtJDh68eGNHfUI1ADGkGOFe
	CiIvECxnAdBiK41AHbx/qz9LLR9fcuk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gLSidMGq;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840134; a=rsa-sha256;
	cv=none;
	b=IDlghYd0CXALITNQTb9KWNhReHM42MzcRkNGkTzX7/Y9nvt99FsfEqBQ8nhJ+NFNBnkGry
	JijwL2TizHuAL5SNp+ZxeneLyanEfzeFpDPA7gB8Kslb0ffnC+IJOSyKaDKqlTGM7NAuPv
	YNDqU63chYRZzID5G1otjKcGm45duuA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 215E543453;
	Mon, 19 Jan 2026 16:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27114C116C6;
	Mon, 19 Jan 2026 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840133;
	bh=DOe7Zr+SC0SYYE7gHRN3EzdcslwerK27BkcLvt/YLFc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gLSidMGqIduwhhiZBRl97kiG2r0WSem//2Bu5eDamZwGlTsr9LrpoWaTD9OIQfiWG
	 PIcjpOsrKsKKoBTdH0RVx2h9oNObYSeGccUXe0tJOExLbMz6brRFhHfwX/xW4p00iT
	 0Aapwu+EBjx7X/ebQKY2u7Oc8Xm18MDBtNma1ZzvpgTWbbE40PXPlZWrfrPbUzljXx
	 ti2hbcDLHS2Mtd0BBszkVSvql1u5IKlKWMkfPiUeXlny3aVa3EZJYwuW6qOP2hLnJa
	 Sg5Vh/88liPis+95Wn+gdIj3gOvrNfxxM7In62NU0dbDOMh6+HROaUGGYnEd+tPfR/
	 KjdC6A4vI7Quw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:30 -0500
Subject: [PATCH v2 13/31] udf: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-13-d93368f903bd@kernel.org>
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
 linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=773; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=DOe7Zr+SC0SYYE7gHRN3EzdcslwerK27BkcLvt/YLFc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltcB67I3Cfm08JpbcXHGEkrLfaJbcvd3qnwq
 BhDRd4AN+OJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXAAKCRAADmhBGVaC
 FbS8D/432THFEGWROgX8dP/qCEuSNPHNLeycBv+YXQdISlJtiHD4iuhGoQ+OgERyuJmu3TcYkEQ
 P0eYFomKXV8jqpqGO2/2SDRE8CSame7BrqEo+F6vqJ6h4aVkE6ufeuJybyvumep1nUmlsIk2DsU
 u0fENt3ExKeLea7brus3iT8xHM0CItU8XQS5RVMuiU/SxqPPEs6Gb5NrQ0Nb/yKLHlN0JpOjBD1
 u5kv+v0F3ZlB9nG8fp17BTBsCD/QSUkuv/VXguesgG1a1OdU1QlUIJf1bvZTI1eDySl/V1zJ/ys
 pB7kAyYPYpDzTxPmSOSrYVzGbRdfgIfCzChXnUTHchfvlYDkLqmoNjSVx4VcTmBHGy0wZq+p3Ij
 gw4LUOedWkbXdEWCD1VLGQ2lmsKA6KzmNxKG2DguLX57oTKI9hKSx1QkPTgioRhhpjAffxxzZzK
 YG/0f5pV4d15jKegKxjp7WbBOW2h9cYTfkca9b3NtC/IUE/cP6DzojeN7GJRXhtM/23HU+stsUF
 PYmwauk2mN1n1kuL/EXO+pG81cd36tlZ+q+6noHC81NKX6rfqcujUI2rrAH+gabLD5BcxHCkrQM
 nn8xl4i9spqRbsniTmZPDusVh+1BEp/XL0fHi6MMd2JHyHZaS6gOgg4V3V4ygHuuECMOaIqJVcC
 YlFVQwsgmBIRBJg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 214D2180010
X-Stat-Signature: 3jppr946dyw7xoc99fqk751k1iewmuun
X-HE-Tag: 1768840133-41959
X-HE-Meta: U2FsdGVkX1/4HgDNKD+N5f0WhdC3fr3egvujYh0sFepLSxtJMr99rKDaWq4pMa0ARwVjlY4O2HO8D4VQyehK/LqxhFj1EsOz0ueEJqIu6avioFcYtSOgkEGEjsH0w8XA6vaKi4Efeh5PyhDc7RgVcULX//BOLPNLPyDBlijtvWdn8z7r7c5Ctnjdw4xrWmW4Kbzt0Ew5mvz6cPha2Bf7fcCpSwMcZXPYfIhDgTMNhCPPb/S6tvQesMWd2Um+oxJ4OPscuHGNuzPTQOpspDWmlY6N4/OovcyFkBSXkbaUgw3cZwaT1rUaRus6i/ogPMLdpx5PdVmScZ0UzPu9UgkxiNT4NbJnPYhxjrwYZEkmNju3tEHjPzGBPRkPlHX1NdZMw5B8dJ5BMav963CXxZz7ViTNCcomyoi3gNmP9Vo6zi9+yilhPppc/QMUlXzcCWMDa7bv1U0A2h9jIS4fRQvJT9XmR+QYGz1ew6Q/iYGfpaoH2WsBDNnRbr5yJWnwcJskJbxP3LRzitnl19wC4mx5i2tlnOND7IQG08gCUbt5sSHSvjwF4KVOjZSLrJgDQb1GPHwwUXPMsET1m0wCUU/eAv4GT6T5Hyi+DlszxuAbrcdhYe4uwr6I1wATQs7z1odddEX+v449Lxh1nL9rKHSQI6Xz8ISXhVDPy0wfKrJ98UzEuegcEi+rWcXcfdqX0WEk9k6VgKMDfiSTNgOc+ci3WSBuZOFmLDMSvpShhoDEhsk2vwrEHqGQ5wOXBctKeqrvnFhwJvR97nwZy76y5rWhKZXmc8DOt+UqiW8y/8ErFdzr9xlRVZxxY3fKBaFV0GYnJNvbGcVP9JIZceB/hHB2rf4L5AXacyJng78Nfiswgx68UmjikTDLALSz2T2ml38NAGXAzNKHc8jeDGhTnI6T9d4fQ0DGpKjhlHlq/IunLHQCmaBSqWhFbcUARX7vT+uUCzl/8VuDmABaiKpDs3q
 diCSf8Er
 3RE6e4B7PmRxu4nxfPvMHFxq7Nlz2i+T770zJ24nmaOZud1sfjL5BkvZ3PCUWoTIJyqOOilkG4BTYuObn+xOEPFJjDI4I+qqYz4Jlq1uR1Rn14v/4f82Wd/2wk5dcpa2w/jBbdgyFvDLLn33HqyAZGGcmoHKN08bRoSG3mAnYbYFcGdJuS5vxcMQiFYc9teAJtkvvXpGU3x9VjPm19CpyUj6/8qqqc7RMyd2W1kE8mt77fU5JH0/i02WU4zQpVaj8hYoinNreQ/LBc95FMtsLmBcK+PXswoLjf+RVwqkWa1O2ceQ053Hr3QPSAdaHn9BMwrILe2u5yhGjHKw697+SlLxDWJFrScPRGwtldIapSV51r16soP3YQagDMro5jtVdjLkcRYj7dG/SwYZzjQ8680frJ/6dadIf/ffAOMrcx5eFhFrFVA5MU/+OMsNwedNm2RNUNW6D1n7//OdQX7nV/54ekqrYFluf3+SjfeUq6NLjQD3Dsm+gQ4+Q5WWGf+NgkUP5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to udf export operations to indicate
that this filesystem can be exported via NFS.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/udf/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 5f2e9a892bffa9579143cedf71d80efa7ad6e9fb..7b8db8331c77bb43d9a3c4528aee535eac2bbd37 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1012,6 +1012,7 @@ const struct export_operations udf_export_ops = {
 	.fh_to_dentry   = udf_fh_to_dentry,
 	.fh_to_parent   = udf_fh_to_parent,
 	.get_parent     = udf_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 const struct inode_operations udf_dir_inode_operations = {

-- 
2.52.0


