Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41AB6D46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A918D6B00CF; Thu, 15 Jan 2026 12:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66046B00D1; Thu, 15 Jan 2026 12:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9519B6B00D2; Thu, 15 Jan 2026 12:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 811D46B00CF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:51:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C9D91AE50E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:51:17 +0000 (UTC)
X-FDA: 84334939794.05.A012866
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 508131C0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:51:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g7YSb1/T";
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNSjgsgRtyIw/iC+tCBD49WoY/riJf+CPAjf9Te8tA0=;
	b=Ts4VkJbzbOhXJQs4g+N/ey8q0Sa5i1AVgGFuQCbWqeM5iBl0Gs60yvxT2re53j9VrorZTR
	0LT+uLoX+bpq2p8p7o/3Q1zzb6iwv/oqGlepBcG9Gkk5+FpyFPGv89fTNUCKG0JZ5mLvli
	750zMYEDIUSETEy6Lgad28xJlMfhBtE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g7YSb1/T";
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499475; a=rsa-sha256;
	cv=none;
	b=bKkYGjA7VkDPgfgPScdx94tDZEHPQxpmSE7xUrG6osF3jMdDxu7GRnvSz15rH9NPUHAJYH
	XfQ34ilv0weS8s09qESzW45nSN+w1jRO+QZbqZJ+nrXFZsIDKp9VvqCW8SyU+boMuyzwwW
	K2sy/7d4b9nkLClb7mKISZoSqQYhtu0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DD7B43830;
	Thu, 15 Jan 2026 17:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28E0C2BC87;
	Thu, 15 Jan 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499474;
	bh=3Lesog+saJIE7fVwXxIqzocDbbL7seXSBVcQWCAEylo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g7YSb1/TODzXkcIP6p9/wwYu2DGdEGs5A1xNbEaa6YXpXHCkZo75dKOhpzbEnke70
	 tFl/wi+2L9R7juokN9RrAO2hzFkzOo1UolYG7PTrgtqycoumg6wuMYanMSAiGEcL5+
	 rrebzmnse1W5h+gJbvvkGvabjn0w4tpVTl+YkKEq2+zyxzqIIVNGyGxTNWXPGgnVDI
	 yas38IdE9VvF4iPsPwJa+4aGhd++bDzX+ryoJ+6LAed16KiFtr8ZpWA0uQW4o4J8uj
	 O85No7vo/UQXZUte7vVLWFrrfWkgy2ib31R9cgJpIQxJgqj9Q4vVS5rQZcE6nkgtGB
	 bWbKRQtHDsekw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:48:00 -0500
Subject: [PATCH 29/29] nfsd: only allow filesystems that set
 EXPORT_OP_STABLE_HANDLES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=933; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=3Lesog+saJIE7fVwXxIqzocDbbL7seXSBVcQWCAEylo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShL1IWuANGZmRgu17fA6ieKmPdFRTw+kdOfE
 T/UW6Eb7tSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSwAKCRAADmhBGVaC
 FVMKD/48eycQzLl5j5B6HkE8L1FfwXraMaTibRGf1ZUUO1tdf5xaliTxEmmTz245juQt2kJL6vV
 t3v0tmVInLOvhNl5Gml0VNKIfoY4DHYYDMqab3/BhWW52OAXYuFC1OHvNjVSOItR8sbZ+iJfdmP
 cpCABU6fsvW2RanNoGDQLVF2gHpTCVktYbUOx2fTqCClkLlPc7eyiG53QS9imf2Af1jR9/MObU2
 UJC8aPGoFg29JP+VBrJ7+K+uG/qCZ+4Lk8yD3Hb0EdyY0XHb70hMV4VEfQq77MoCSoVGAWAYq+b
 sydLKAPVS0MlM6fWB5A+y37+o3lo+1bVTlGmwslQVeTQiyGkKAYNQNCMygOJQ75i8hJBaJ3Ui0r
 wPpANaw1oBzTALc2orq3uIyZ2m6Kc8WXMOVdDcT86U6pBRMdATdTLzeEaNV+i+eRTrA8gCkrAXq
 JtaYC4ihJzgaSo8BPtxAJdlyFFkmEA8kw/Eg1fhJwl9r88x60VPSbw53L7sBrhYiykB4xsS0Yn0
 hW4FHIe8yJXugnlD+0XpRgz9ejnjAuydomhlSsmB109/2pn9NyuzvVEW6QO6oIhAsH8y+nYAm2O
 zDhKSTd453A4Zb1cz+XkXonK4dyl1yN7vyzDar6cQ/2BJVoC+1C7e3OSHy/2knx1Qt3EFlycS5s
 GPaWvnhRUrWOAkg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 508131C0007
X-Stat-Signature: mnejxqi1gdhwg993azrjhoygmewxb4j1
X-HE-Tag: 1768499475-502861
X-HE-Meta: U2FsdGVkX18QD1jiACYt2geqFeEk13ot4Ghtfzb6LAO5Qapdk4voc3JR8RDkVo9jfdI2liydiQ6qArnXdHZo8niLKMgqmhdHiN1q6s5CxLkH4O63JWn8p2nOrXfyls/1wRxqFUtWHkSUgU4htvu8+a6He2+9KnlwegphJl0hhcHyal8ZxtHqY9jL4mlViNPN9kTZRdKSO9rUy1AMj59GLTEvJvAuScITM/KncDYs+ayYvHnCykLM5ZC/vjeqGDw6TcFf0wvP3OgZTzNmg8ygQzSnoN2+RhJIGW4rOqE5W0PbXlNTFamLK9w3tKOF6WTh1jcjetGo3RMR9emFepLpmh7GijkbO7Q3LESq+yHOP6wO2quxDQx+UrfapDORmM+F30pdgg2XRJyKXwtMmg78+gWXvXqs6TrkonQZR5cBIAuX7mah9frTvE+zw1gPVNOZMYThotVn9So4LpIwspX6SuzF+Ea7g16i8ZBeqYhRKyQSmM9t57cCNrRnhD4eIcnTSuT+z9si/LRHIvgXQTmmXZ5ToTAhyCfkae8sxauSVrPTPgyWR5eRsP4dKQX7taSEKjPaFccHOGUg9jvQcqss1OQ3m99anapVXVJZvEqFixLVfVLMnmI4xIXT8eue5faCZNkDs2A0BlnqP1Y4g9Cfz8FX/e2uc9HheO+ZpFDcU/BbdQQjCoB9yUgEt/9ik9q/A4rc8Te6Q7h/XXiEqgJJC/FV/a/aj0axV94hToi3e4QwB5XV9SkaNyt+5rqb/Q8EDJ+55E+GMGhVC2ZBFLh1SIlkUGMnqzbam7y8s1xRockxCgzrPAaebZ1VqqJ1XA6/U3B3VcRt/CNrjEt9qssZ8q1rUaM9wfMBnygKnFtBppN7Xg8t2MoWyNadHeaQp/Ke66jQnAJ7HLIXZN8YPQ3npeIzCTkDem1aVICJ0sqGCltelf+vf1cMzj2U1GHqeA3urfgldcGUGsrgtPasprd
 R/2gLCXu
 M3ckGQrSPPzLU84yrEWc7LY4OBYSTzn1vBzD54+CQjQ8Hn+w/v3JVN4v2SCyiurmcDw33VhGeMb66glQIDTRf97viTeWlcvglnS5ou0M/yoZHIIyxkqjO8Vly59mwgsrYvEGws+c3D+En514RGU8bJawHAFHkBXvGqB7ZKDKqugxg2OQVN65LNa8+/p4I7dghtDaQe0TCoBO1C4XjVxe8R4n21/8BBZrK6ExDQk7CkMKxsm9hCQtuJWpkRCN8uOT0ZDq+jXAAL3NSEHD+Ga2DvwCGAlF1CfwmLLXKMmKWEUNWuDuoYt4MToAbwZq9oIolnlXJNhU8hGUkl8nygFfYrlnzJqjYFr26H+p6WTNllnfEmSC7JN+4FdrsUnuD+Ac5WTum
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some filesystems have grown export operations in order to provide
filehandles for local usage. Some of these filesystems are unsuitable
for use with nfsd, since their filehandles are not persistent across
reboots.

In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
and return nfserr_stale if it isn't.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfsd/nfsfh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195da2e8678b3fcb3d444d 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
 	dentry = fhp->fh_dentry;
 	exp = fhp->fh_export;
 
+	error = nfserr_stale;
+	if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HANDLES))
+		goto out;
+
 	trace_nfsd_fh_verify(rqstp, fhp, type, access);
 
 	/*

-- 
2.52.0


