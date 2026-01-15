Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD75BD46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B966B00B9; Thu, 15 Jan 2026 12:50:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520396B00BA; Thu, 15 Jan 2026 12:50:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E786B00BB; Thu, 15 Jan 2026 12:50:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31EBB6B00B9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E57521403F2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:17 +0000 (UTC)
X-FDA: 84334937274.05.4BC3D20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC2014000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4LOVrQz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499415; a=rsa-sha256;
	cv=none;
	b=WK9yCkqlrycnySrJnFGSJwqCmoE00suxDFlPeJTE+CCzBTErhqeUG3MdTBuGcRYnHojBUs
	7N0TbLHunVFo6oKClm9j3QLug98ij+ce06as+81JKiUys2sK07EfWWa1oaJvRwt4O8PIlo
	DqDjt3BJQZjKzXlMlT0wyh+lwg16F+A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4LOVrQz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofTok/hZ9dw1JbMr5NBZWt/it5I8zRKreVKO3w5NLO0=;
	b=D/mFHiU+jO2qBeiI0GQCdDKHSBK7iDOd5vKXqab4N+hPdq8s+AZRbUcXmLCtz/lvR4hH6M
	ralfZjghQJuOsqvazIss+qKyE405a+/m5WZDFsnPM//LXjIztQVrf9cGJQFHboTf+Gotkn
	YgL8BvvmHna1Is/GeVkmSIjroAuy6IY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D503B4449A;
	Thu, 15 Jan 2026 17:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E799C19425;
	Thu, 15 Jan 2026 17:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499414;
	bh=U14CgwQNmpmYm/olsFPDmAvGebUpMmdXLYBcSiJQo68=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=U4LOVrQzZFDe86/JOIxFd/oTbsgvDFVbCPtnJNbJV62tNETnGVQcZbKoD5VbL/PwJ
	 f+gza7nr1wN/rVp0cfVFyiNPnmP2h7xyzhf0lL6Pgjbxf9ja5yS9DCJsGAyi5yN2sy
	 4ue0mFvkb23UAcEXqDIfhhT1l6jADXeh4D2GGCzn5vcFi47mkyVciNWNEAcNyEn+N1
	 1k+iUbFC4J/zNUdYYVPM6f7EiRxfog9ZRuVbC8ETpYpelIdZmtAzDehlXfJNHIhEL/
	 cTjgLsM7yaccBslJ6+uQ5W4Vwp47GREyY/Ad4dVxEPb6+NiRXZswo082ea/IHe7W0+
	 ZfuwxblAnAqhw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:51 -0500
Subject: [PATCH 20/29] nilfs2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-20-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=686; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=U14CgwQNmpmYm/olsFPDmAvGebUpMmdXLYBcSiJQo68=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShJFbXOMj4js450jk2J72PWoFR/JR82AXdQy
 iwgyzXU5QSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSQAKCRAADmhBGVaC
 FSZYD/9uphGdzaGvn2dg4Bd0XX2b8qmIqlYBiw03MYG0trIn0ktMmsuP2fx7I6z6kbKu96A8Sia
 mP/7efimfs1aKaZJr6B3/fmOtBpqwhnDS3kgWOTBu8fDTe5QrkDi+ctDvRVYiIfrAN3+C8bAhrA
 iNy5KeyzvhYkJqb2hf+fJ/zhXqNbv260P6SQ05cNKI9yOiqNnb8npWxgwD/vxA72R0KLkPQngA3
 0iUAXySskZKvUAw6bAmGwc6TeACjpDeXWilP5zP1ejD115mBHRoyPjyH7E0UBwhi/ZwqrQh0Yli
 Q1rmIL1WaF4AqtEA7W1a1ZRqFZwrIxu9SiDRp5xS097OtKgyBRM3YcLEz46iyWojw62Vts/p1yd
 5Zwt0L4bpA7o2oY4CduvIzH4qaBRWnl72mLRhifKBY07v4jEXZo16rcfN1R/TrHWYnvEGK8bVOH
 eveMdSkU99tj3mokzFwkv0xuTwrFRi/Ybi4/OZ3qZhPiaw8jgKHBTSgOzBny17yPp9hLsv3yQoa
 MdwJ48ubetO5oTRrxG5TJQpY6oLaYJ5DfnsyAbylsupYYb7doZ8JEhdLu7WxLMTcUEY06PSoVR8
 Y4467ix83xMvF/LKJBQiPwr5dYhMyx6uNDY3V4tsPAsxBsBErVvgWXjOygYx4my2qfERvrWSmjA
 a18liGFzln9M3yA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BC2014000C
X-Stat-Signature: 1nrfph3wdwsy69af4fw7aymjrhg9oo6z
X-Rspam-User: 
X-HE-Tag: 1768499415-963306
X-HE-Meta: U2FsdGVkX1/2w9ttCJkECcpp3rbvxJ4C66gjQtnURCVCA4HQU/mKAGQ5rIRQYiAcMZZ0sT5fjrluNE3eZQMVmEZwt3E+5MxlESBMpTipgCspvOjudHjEK2zxBHrXlB1LqQt2z+rziJ1qNxeHsqPshPyCD1of7Uw3R1pB2lM06i07xHd1qpZdOLSCOnmTlCtI1TjvTC2HO6o+A9DCXkHWjGqAZwZkp5LWx55Qh+1Iw4A4SHDOCa5USBUKLwSxGWySGaMhfNy9heDvUeunLAE8ARvbBNagP8dhc9Irwl1qD8pbZAGBm59/XFU16Muvf5YqMmGkJB1FEYggW9wtdKAkegqv4acjvAIuRDdNMV6oWpbbT+Uz44Uy0nR+lGmyfr8FwN8Gt6ywEfOJSeGY4XjMxOxs6k9FUTyE1VGU9m48n7cWSV6pgoApIYVMpou83OHYCFH5ZULR3ZsTT/s+9gpeoV1PP0jzn51ldz7frOKRmFCn1AcK7/Dmp7pNCmQwPMmRwqH+ikQ7sUChkb0ZRQhC3vngr5VGCF7rg705CebUFab2OaXSwUJVZZ4EZQgs5r/ZmuP5XhX0vuS8JtCHuE4Dv+yxZgs86gWjeF0RM5Keh9wiVQq+yF6oOZroy0XRO7KacOnu/zPANf4s+vFvnUEjsqVV+Hj/4lvk2azClbvHycBF9zbYIYxBPaXquKhlDH0tzd5KRrjmP5Ucq+3An/FKfIKtN5V1ypNF28N7IMY1IG1w4HNmFJ8/i7DsNdh+tOPLj/pk7hd1ggVyMmAXczNIkbdDifMYzfNXc1JnLgB8GkBmmCiUtkilybtC8tbyziZ4WQdQxHHeYkkNgLoaF7tUJ5phZlYCAp8zsFVQTD4xKFM3y0kRVHIDnxFwYjl3IHGZj40ArynJ0xe7i2d7c3VX9KU6qde6x88WDQlLpsV+9mIHcOuIpZvlri7FA59LFXl1xCjsu3HBBqsdlWZwJED
 7DeK2PI8
 0foqAr0XA6NtsZM0/QI1glYG5CzRnpdJY2vYmoxfhLdqFmT6On2isImMQJdTf3MsQVLNbXu90jUtvN0ge+xbWsHgFAOdUnC87gVWvdmS6RTQY0C+iSMTDHYTpN2JsGcgNPVx8LxIKKnfdvS1jIYzjqzyVpicb/F3dWgX5quqvaBthAKVtvmUgylEt0q7fH53s3TzeOK5MlLnV3FrXgswOyd1VBYjI6I45yCHUczhl4eKxW3ruEQG8D3YKGJvsFbJLpiMU8iDQWLJ6dqnufO7f0VYRhSG4XF34YDIXcgcRXGdEQrWUv/Q7A8Wgulxde4FSsEr0kFJF7HaIS7mN/IdFKlnmMh6oLgEeEi0Vr1d7ZDWRHImC/yjLkM7SG0N6Yag1RNZb6TLrFwbw2pQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to nilfs2 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nilfs2/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 40f4b1a28705b6e0eb8f0978cf3ac18b43aa1331..975123586d1b1703e25ba6dd3117f397b3d785c1 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -591,4 +591,5 @@ const struct export_operations nilfs_export_ops = {
 	.fh_to_dentry = nilfs_fh_to_dentry,
 	.fh_to_parent = nilfs_fh_to_parent,
 	.get_parent = nilfs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


