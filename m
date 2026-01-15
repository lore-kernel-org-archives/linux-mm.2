Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9215DD46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 055FB6B00A9; Thu, 15 Jan 2026 12:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E516B00AB; Thu, 15 Jan 2026 12:49:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C2E6B00AC; Thu, 15 Jan 2026 12:49:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4B166B00A9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84223140425
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:11 +0000 (UTC)
X-FDA: 84334934502.08.29B83D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A60E22000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwHkGr2x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499349; a=rsa-sha256;
	cv=none;
	b=hNtmJodxlfMjAe5yQ8ZzOfg/Q9auO9nslQtQJbgTWO+qYqCaZ8CyBGHyHxBatO2/8HEFIp
	ubo0aG/mP2cKWqbhZUOBMrr5EfvT8MRLPMpGeJKsNmgFvx4ZLkityEadrlN9dkDvOy98sH
	a/RtVq6DR9L8xlFc4zmg4JkwQ1/XDOI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwHkGr2x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obBvXeIihwcnYNwIfK7fO8NOfGknt4GVIgzKgx3OkiQ=;
	b=Xl+NGX2wt/PMrtDHvsFAtkjYkYSu6KngdOzz/SHDWIbw+U75y0Ap1eI3Wf+bhgxnxKAzk5
	XBechpQn3nvA/LYuQqq2GJcgjr3LpBKTEM2H6tGbHTRm3Zn3NKQUy+evnMwTVRCL82zGoE
	AMHNZUQj5lLPutQ4041jzgRzQYyN1Bw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B04BA43DE8;
	Thu, 15 Jan 2026 17:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358B6C16AAE;
	Thu, 15 Jan 2026 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499348;
	bh=FgvaakP+KkZTiWPmd/GcmMQL5i/gToOI+UK+TD05398=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bwHkGr2xg6B8U5TV1PJOWofK8WpoXC25yUxxbtMAPlBPDhQrTQSG6vrqBrUs8uDBA
	 hTqGyj9yg2TH2uINyrZXCjzuH2kH/kz/XePVIL74Zs7t7dv4JpGdmbHA36OZU+DJpk
	 PWmLshHFOMRMefsxGC29Pff7c0kcVj0MxDdQhdnqdzMXc5Vap/L7iD8JqaqQDzOlpW
	 oevuq4IZNRQ60YjDnRkugrc+ROG3Hn+nEfLCVs9dFaMKHspLizBAMr2yjPWiQc5QxA
	 c/JcgLHuNUH3+8x2nXofqJfjnjWbvPUhDLylRyyE/uSqPEh1qjEcalALGwqW+YgG+k
	 G7FnxaFhkK23w==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:41 -0500
Subject: [PATCH 10/29] befs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-10-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=706; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=FgvaakP+KkZTiWPmd/GcmMQL5i/gToOI+UK+TD05398=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShGbxyozH9HfLZqQETsvfW/RuWGQpM8tpPCd
 YnS/wCZAa2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRgAKCRAADmhBGVaC
 FV26EADSUInyFlfgi8mCxLJgVoNQbbVSxQ1aPK+W8ZC+ZjdRh0buWdJB1AqTinRIY/+hFrdznoR
 2ij1tYPigO5YJNUa1QuOcvdR1eMs/OF9F5mjiEO4NQVqjmtxFejq2q7Oz1dTaYOWKusvPa7duFk
 szeNwIHZigrHOXNHDA8mBsjuutshb2R7+3T8CzxrXHuU6KZFxQTBnItrStyDP3nCf57wQhs3lla
 1CKlKga4tIeLYArvkJaEfFiyGtqtctzSSWRbprAE4TqMfC1eUzsoSghWWpkNCAfpnAjcCgOcu7R
 Qd8+8pXhG4zvQtv7WVaWiYSTJtxkztKJB7aV25SRrs2bQpO/cIBvruIHhOZtV+C5KFC3q7S4Ng9
 cosmYNrH5tNiIe1f18DK3kHU22ippITqJ9OoOafSiehsarK+Z5w9Z60+Wfzjz3Q6ffD02Z8S5DS
 RUX1xUlKXgUW9ZpR86DLZoT/TJlqx52AWBrklpEV5+LQ+TC3lPHjq23gVI9GjTsai3UlHGnxhcf
 eg3VD1jJijVL1y3CsI0JMk0j67gHyCkWdQ67/MjF+DYzMfmLCOC7xquhxS28B9bfyDc48SyRAG8
 1wZJtPzPzh+aXjwMzsqJICCOR/ExR6mP1AJk+vFbe2nB1tS5Gyo721I/mFPhRhvfckkPX3ujRj3
 8k2oLoDOYoOrrmA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A60E22000D
X-Stat-Signature: q5ifrdy7i5rn3x7d7t1zr5rjgewkeqps
X-Rspam-User: 
X-HE-Tag: 1768499349-177448
X-HE-Meta: U2FsdGVkX18mmFQle5wE08qJ+e47BwT457WJQO/wkeEewrqDFphFXYVZee3OJct/z44sC6YYWF2tMDEBaEB+1UAxZjHGvDVbhZw5YOPrHaSTYRqBzz7taSmvjMX+JFylpXP/1JTo87vFLrhmR+3toJlK3ldq3vbJw3kL9a0stmiHLaL0QjdY3sSD1/guuqBwcABse+zFyH26VXjktQjCdvDtKVQcOSAnWM4fWI+EKWT9ChSgYHzDG7r+NSAk/U0Z4o9gG35097BtN/hRnSS0aCi59t6IHkhkrHXwOBJtmHvE4bQQcqqtpzQV0gyVu4DeKvCRakZsrWv/8uQOR9YSm5RWKya1pyaN22A4XxNdUmogTz3wLeIGYb5QTmGxQ6XE884owEYTbEVm12gH5w3jZWAO/GirSVlBjaEtVhMFQZq9w1m9NXRE8Oa0DdqywFmOhze3rSzd3sY+H01DxFsdWJa2moYGtKyrBwVxXrN4GbgC9za29S9/iQGoo894dxvQkxw1g/aq9Hfg3uCHbRshkjpzzi2J4K5BQGT1QfFQMUMHo1SpVS/ziHYEBYzEkiThu3/rRCXPx8kJqO0cOfVBA0XZQGg+yJ+cTqTxi1znISqdAla/zFksNbMqoL/JtCZ0fxweGECP2haPjjRPDRJ4ESUQjbz1l8lyKg0w3IXp1NJZiRBNZLpC3FcXDK8mVLI9/ugx+Oxe6bKHscG6NL+tuee4u1WkP+JXxwM2ISkZ/HS1g0b8YpygBAspD6fz3hQlKEnlVsk8kb9dWrvhNuq1FzO6+Kcy8qbmME6N7ZjIrSDv2kU3gdKeje8vaNSVpGNyIaaU8aj5vLfIq0uCWBegJ9HII5aFmKOsCTKgxLTZCt0kb2VjHaE/VWBOY+3eCM6FOS8nYfU3+kDXBDxcdk5SatD3FaZgI0ttEaCK8e03uXj+6rhkE7Qy7kOxPqiwkTLZ2YHWuiGKK449ifRV7jg
 8vX7WCm1
 dvATSsLdYmPXV7BGftKnYa0zitnlJXjNbpkJlgmB/uX5FTV4MyA1bZC1Rji3WwWVLe9r/Hm1p+NY/3SZo/z0LSxPJ2HGuNv+zJuz8T5QccGPIbnVn8oy7gID98JGp/TxB4EukdxJgG175ILJNWJC7IGc+8eHzO32wXxRX1ea4bhQ7DByMwQemFuCe9AFuMc5twocLl8WW3oaj9g8799LJkgMsfJtmiOCByWR5cNnqV/EkVrdo/GcvhkWBK+fhsDr7wOQjqPH5pTOtcyrQKvLvGRH33mv3Q6exv+k9RqkwhsVKBQYYgU9FcNm/vPt6j3STEsQjVWsYXggGBLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to befs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/befs/linuxvfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 9fcfdd6b8189aaf5cc3b68aa8dff4798af5bdcbc..1f358d58af8b4de9bc840b9926970340395bc9e4 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -99,6 +99,7 @@ static const struct export_operations befs_export_operations = {
 	.fh_to_dentry	= befs_fh_to_dentry,
 	.fh_to_parent	= befs_fh_to_parent,
 	.get_parent	= befs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 /*

-- 
2.52.0


