Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB65D29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A846B029A; Mon, 19 Jan 2026 11:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3886B029C; Mon, 19 Jan 2026 11:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6286B029D; Mon, 19 Jan 2026 11:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0D4C6B029A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8E1F1601C8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:45 +0000 (UTC)
X-FDA: 84349249530.12.92203E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D21E740009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWpRmCRl;
	spf=pass (imf11.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmGy0v4cBQeUCOJSxeLRPx7PKr1iQvHg+Pi6E7hov5o=;
	b=aRRrGjHWjNyk1f/huT47ZWJCsNJwGdp0LGaTe6CafVX8P8J1PfjWaGpL1LIn2IaLRH5x7C
	9SRMyynkb8K5Z8maGxLHSJMAj5+dXssfFWR3HDqa8w9hW4mav+Du94nBmcIfJuNSsuYiks
	rFs0iCAohGh/EIVFPZzMNOWATIUZfwo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWpRmCRl;
	spf=pass (imf11.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840184; a=rsa-sha256;
	cv=none;
	b=t8AN9uAkDjKsDtWXZm0zJJAn1YElEFNY2oxBIGhgK+uE5kfCFvfEFjlDfpM54R7fTxBz9J
	ntIZCZWJEG885zhU7TfBUoBXYqdcJX6KpfrwIJoOBq/wgW8nPy6X1fZa5lKvcff28H3IZH
	oDtXV8vbMCFBlRo9Tx1VCkjeQQfCUGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC10D442E2;
	Mon, 19 Jan 2026 16:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED218C2BCB1;
	Mon, 19 Jan 2026 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840182;
	bh=0pjRYIsnDRpw9eCc428hMJ+RmLNOXECTiV0TzjyGuWE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EWpRmCRlLqA7JIm8OHKhCrXcT2ln5vA63b0sZyoVI3zCuqdcFLzc4lORDKTmNYPgE
	 68L/MldcRNmq7VjXDoYJoCDFOIAMCsTPNrQQrWwbaRzw8R/DojiRLpEhdab0Mokr2b
	 HCN7YzXCa6Kb2QMc/Fv0AhxCHNWSJd0MtERaTQkcJWqox9B6q7Q4nS2xcysS4axClP
	 Q5SrX8dLhllK86laqesoQ2aGFtn7PE0Wq8rZ7mWf7BWEXrhaUv8U1gHj5gz34zE4Ur
	 LdYxuZHS7V0X5KEMOfWN4bc+BgVBojyIM5X2h33jNR0RIocK7OyyiZWPrJO9p0v1Kt
	 /1xXtEu+1aQmw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:37 -0500
Subject: [PATCH v2 20/31] ntfs3: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-20-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=702; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=0pjRYIsnDRpw9eCc428hMJ+RmLNOXECTiV0TzjyGuWE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpblteUCie9VgtOBk7k8KPcwYUjg+5e3aTiLSyz
 pedHEvEigeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXgAKCRAADmhBGVaC
 FXDrEADXMOqneHOXazrfXcU6SEaFdPp2jgcDyKlpcouTHeHL7JMG75dMhNd8/tZpaqBBFh8PXPr
 m/R0lXt0HXYZD/WowEUdI9wfb8zMEoSXka6WUnrgA2qLKI2K5EoYLcUDlB2f11F39Cg42pXIv+Q
 GwIpJ81OsYk8AMTKSlmCBneF4heHmiUP3ceLQEd77l8rNMaM97BuExMkt6/FAXyx7QPMM90orOY
 5ru14ROv12v5JtsocjudqdzZhUkNVJq4qQ8BSksvhOzGrEHyktSKKC/4qF54Q/AGTlU2IsSca5G
 YlLwjI6/aLM2HkJ07JS8Tp8XQHW6KktCwDkz5gI8cfWiOqfSZhhBxicjQd20i9XzXSfixWitcGl
 2OuYprkJVsaf3xiPIOluLq1RZBodScZOje3zQS1b2pv6jm4BlgqEyd77HzLudAmpYNo4wwLvEql
 KPtVvl8CASGIRsPK3aDKAi1HNbzKPgSUIA29eRhvzlLbWTBlO7pxqeYgHhJZiwsMJCRnsWm/144
 39yZpmFmTHkZnPTT80fwG3j9E36XUg65OPrPlv/9wGEjgBA8PH/4Uowj0JPGJSQr67iERPo7rr6
 i2wOrIsCiT+ItGJOWG1dfznfv2LMHa0wNrDOimgp9zKPWyOD+8E4Tup3ekZmosQr7//lt8Ry8kl
 38O1cP6Qlg6j2ug==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: D21E740009
X-Stat-Signature: 7zcuunjor6dehxa3b3m77bnm7y9btkzn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768840183-193670
X-HE-Meta: U2FsdGVkX1+uhJBRVgKZEef36XpxirUUHFVwSUVakHaSj8BpVShvIv2VHDDl5JnemnLvfGUrCJohy54Dv85UzuqCxPlMypf55TRFdlfvHX93qEdAhSTx+m7lCgJ83mmXJpaCMaLopkblrjOgOQkZe+OGr8bshyGRqMh05241QZCr0Zv4sq3Ifbz3zbziEm80Wk8c5Pz127yqNKJZ6kG9sqI9+8XaKRqZBjpxvdibiQmauvCfRl1ChLcVpifk3TI0VykVfOMcjdlg9K/tb1/G5epZpCioSuSZnEt9cfE5BYK2zuj1MpJ/ga9z10noHNob5N9We6nvvJAHhznKltip6kg7cmNbwCMffycRg8oGNxWP2eZg73tRBUEd6Fic6IXM9KONPHhvCwFJHIzs/FMOdjgGjC515+dlJqFcxR84Zb80Q5lmldmNAITBro8mHJToS58bPm4BR5jcd+S7foasvBtMZ0RWt2ycm+T6sLyl6qv5XpWm2RUaIzzlDZdIchNPeAYMuADrwhMvhCEWyVNytexdI5bhbgfP2NIYoXKtd6tp9fHdCT2bkhc3nybwRiTRDP/2vObQCFLi3Qy4WqNMIWEQCZGkYLOplJqdWBrkCfSNM8KjxwI+iSe0mMCAf8PiR4FEXjB/3cXUhFkcCLPRFbCy7vPpXGh2XuZFibkUqWHlvqQmbw0ZNNUVw8ilYllZD0BBYsW7w43vzHwZ7o7+ZcOjH7MQcMJ7AoJ9d9vssw5HNhT6rooXnHezZyfSrMJhnAwKWMe/a7wSeN5QEtFcp+nYfZNufSoAkuzi3xAyfLBrkxBicdWymkOB6/U1ReHlJSRlyen2m/vpF9kUvkfPS7ax0gfefsDzRiaFetwD7w2AjqXg8f39OR+XBCCcwlfFpavD3S2kAuap6ujj0o/LJ8iSSJvybZ1knvxXk9zSIMskLtzqbAR6XG34eFTvrqhJx8+Qac79g0/UOtj27cW
 KKp8rfSS
 0QzURA1Gh/jS/fT7dM9CYY6ZlolX4e0IkZHkrVqZ2AzYShz6PtdK9J8o23vbEi5yCdnqldVyM/rwS/k7IPnxJaRqgz0fWFFqy4VrTngOgbyh9aBhwYR13RIJhzJQElNNh/8N5RfrpigXdqI5wCL1QAWU/4VyWnwePkR3PDnukz/WRAKOhgsQO+GWjkW+xRp1SgdQQ2OFIng+sw09eqdYvo9jEZZZ8V0FZejPGgQFWZhbgXRBfz7w/OVY/EzeMlGDbpMajb/J0C2UukPrV0h6IdnUJ5rmvnYv597iuz9UqLYKa11d24rsnNkKD9LZCVS/VfTUlSkriGh0D+laM0aLXeYqqwHwTLky/rBOikccE91RPA1kyS9e/o/rLMJztH5/E6Y80UgFEEFnlMa4JvXgkk6pGXN/gkx22c5GCrrQtlPED8mP5etWNoH0FHUyq3t9vKOGu8fardZG2g6a5EnnKGiteiO3hDqfiAYVZWCvZMyJWyY1yw6ZqVZwMxNKRCPRXGAIi7i1e70zEfcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ntfs3 export operations to
indicate that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ntfs3/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 8b0cf0ed4f72cc643b2b42fc491b259cf19fe3b8..df58aeb46206982cc782fad6005a13160806926d 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -889,6 +889,7 @@ static const struct export_operations ntfs_export_ops = {
 	.fh_to_parent = ntfs_fh_to_parent,
 	.get_parent = ntfs3_get_parent,
 	.commit_metadata = ntfs_nfs_commit_metadata,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 /*

-- 
2.52.0


