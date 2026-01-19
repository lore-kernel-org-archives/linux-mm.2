Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95292D29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F6A6B02A2; Mon, 19 Jan 2026 11:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0105F6B02A5; Mon, 19 Jan 2026 11:30:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27CF6B02A2; Mon, 19 Jan 2026 11:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1BA16B02A2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93428C0A7E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:15 +0000 (UTC)
X-FDA: 84349250790.18.8EA4F50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B9B7B2001C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a81wX7CH;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHIKlgaWBu+aT3gm/Wqmp51Q8f9pgnyETXcCHEv7n28=;
	b=f3edqZa5N7JACktX/S3lD9OzmZ8OmCAVfe7iBkc4mIsOf4pZB3qqHW9g+t9oL4GUweNZux
	J8syuuj7bRWbMITNT/gLBTfU7jig/wl6E8TUlyGzfZK7iPZ0E5Y8jRTtBH+2bSAdfNvyYC
	r1lb5br62L/3YrkTbq3JzHT5m2Xwojc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a81wX7CH;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840213; a=rsa-sha256;
	cv=none;
	b=ODYfkXyol+RHMq0MpHsUaoXCZPi9W3DzPaPv2vncRnbst3DwSt2fudMuZTRvPB48onlA//
	HoLq1hx4kAW3RWw+jKiIh10QWRzcT7mUF3IyzLBVk0ZSM+dGaWioshCjzOVh2Bv7qfJgVK
	xgOCKS5fe3tkFwD5U+TgMX3l50v/YXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAA641759;
	Mon, 19 Jan 2026 16:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A639EC116C6;
	Mon, 19 Jan 2026 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840212;
	bh=n6o2QP6G+vRALjzLSnRDRDjCb5K6Xo6hC7kQYuLTnag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=a81wX7CHFaMcWABGqmtr3bCnnlSH2+QJW6sj7Z5s+YHeHljRLrpmkrFPCRjArvVgi
	 /XaWZDcbtZpLtK/pb0aJ9GWE2dfijyEGdXqoSe4kJcGmsC3eNBKhUb35dBWA4dCtEc
	 77ftcJ2FU6Tb+BFuvMrPAHF5ksnWZxqJCeiOxur4Fk+wsxTxtj6qRIBFJvKmFmm5Ow
	 UEr/+uPLfVxiPt8W0cv/zj+rZQ7Uig3djb9n8GUKAJXwvu3yF1ovzkjetfwCRoq9cN
	 RyeS0NSJuTN3iyYs8sWrdDC32QcczPIYJiZcC7xFlpSM9IZl63faxJ+zmMU+ot8Oee
	 cu+IW2ZApdGdg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:41 -0500
Subject: [PATCH v2 24/31] jffs2: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-24-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=742; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=n6o2QP6G+vRALjzLSnRDRDjCb5K6Xo6hC7kQYuLTnag=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltfI0USivroSaPnKybgkczOShKdRT9HZraZF
 OxjWyUMDF2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXwAKCRAADmhBGVaC
 Fdz3EACbzDFYvTKaT6J+G9ta/KSD1FSJsg97pPf4Pr3Ovq777BAZcpKmF2NX/mQBaUKyOfBzk6O
 YM2Mx7K1IT8iRZuJywzH/PH8fL6L8dR790PYOZDjz0wl8jnfobiJ50BB7eJo9iVgrOjb3Xz4Gqf
 NvgQamJe9o8ouJuUZpBhkwICfWgKMap5x92NL/4cf2tQn4YgWtqeHIHbIQ0NaSoWZ11w994n84B
 iCVAfMocfV7h0qZ59VS7Fc/HdaFQLwFSmKvlz2GS0kHbsMKeVZFrzdL0zC0ebJolRow9hnZF+1s
 vJQWpBh4SVhgwNLgc/AZXq3vReL4GvAM8Ha8+MgA8p+nuqL7zN18lFi3vNwJS4yjMwYq0qFafWk
 65zGwA+xIKY1uOIbRdtgwrxH74ptBWZQVD26VlmtB1qrelYciadJWV3+tsAOhKXxWh8yRP9BNEc
 C1b1Xh+XJz+3AM7myF+l/Nohzwy8tkkJCU8Ku2yAFJcUpHeBwAjEub93HM99JQ7xWgM8YLSNPx4
 QcXXD2LE5fN5WBuLbdlC0LRYHgeFmq6zUeFGmZZVkbD/CLbtdblGJ7E8YRrOZBXDE46lPOywZ9O
 5MT8vhgYocG2wgiTbTHDrtM+8LubBwz81EAvtnTITbIWXmDSYYmocdD/0l3AaXEplO1s2iJkWR0
 F/Tqn/AjaU/GRUQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9B7B2001C
X-Stat-Signature: fpnw1mcjunj17xe6f1twihppnkbsj5ee
X-HE-Tag: 1768840213-470825
X-HE-Meta: U2FsdGVkX1+/yNhQkjsdNuAVvzTkzfhapRgzF8zlc7Rr1T8uTKHVPiDTyCZPJn6rU62557u9rpsx19dEIlxNpDcN/Sf1aSueQdMaYTc3uqQh/3ROfS12fMMG1jNpLmw5cArG9LpJG73bKPL3KTTI2DF+ut8AFyWZr89DQCNqA3/oJWx1BWrFXJXBSRqfz6y2FsDEb61CqZQaKZs44MO2o3Di+InQ8APeKoGkGOjLnCbqbn66E1Y4bt8z6ASxHjLa7zgjlD25ZiT19UXCfW4CBvwIoAOS9eqyfsgHhrXgdo3Y6I9xpr3u/7BWgrQl16ScYzRARgbTbSTxaOzzMgLa/7ggBOOUkXXdgLwfhLWAXmGoDO/4iMP2KW21IzG9hTn0VefcabaQmV1Dln+zKo7928zHsO48BK8cNkp8Ey86WHenntDP2iMRS8yOyDvjewzZMm2MC+LH5KGnJuYHwBEfrH16Ys0qXxN9qGPFSCraE0+4NP3wWRqvdwdLJBbcpu/yu8LMy3e/+nESTGU2P6EB4REJaWEU0CmN2DeUc5HyD49st9p+oqhFx3S1o2/9Tp9jK7BPFryXifKCRPTSogS+VqHCbnh4D9gMlp9UYj026EJfcmQd2Ud8cZVAOLlONu2mdVjiPcbcsBZnFOTOsznNp5aty/Nn7pBJlAcZ8dcww3hmILp58GyA7FFWXiDQB9uo+LK+ejtLZdzTS3Jw/08pfNCSJdN+aO4a5J9meFmqXmRKueIBqELdm/vazXrgqn1XsS/c4AcJnF/iZc3iXLIOM/31YhRpUikTUYkWWR9rKCj5A7dBgqoBZn+/qOe7hgsoAV8B10NuPpoPOjRKv3B3/Snv7y11kJTPH5lDLPqdhC7tv5mjlzLjc+FfGzMK5FcnQV7J6/vRMk3w+HX7K9DG3XTgSmX7y7qQdG6v821ecCPi2Vel1BB+yEM7faFolgleF4RFa4oWr2lYoCcGCXJ
 fTylWsLg
 DKRgCmu+SK9P0tqF9APDKO7x2dPaCgs9BA+i8RZqq+VbhldaT3ERJ3T6uAAR25r9O41D1fLi65Ohqe+8NBrxPiQJZpufAt/N9lCEbvzSK+6lUF/GezaUjOGwr8d9ojFoNmJBRuk/FlWh4IsTF4qrpIIFjEQUJJX3V3fIpwUnjdXKvj/de7xzvecPiSePD21+B3jCO445CmQ2wrEoGhqS8Q92pP28HJe+QQqVSXMsjVsF7SKXLFNKchDZ+rmCsKsUB7vfJvD9XCM0XrcWud/sJwR8/uKB9LaYCiqorm5IYNK6dZvjG47+cyPGDnuW8Glxgj3+JXuz5Ga6axFwVqpjw8kyBD6kHx7Bb6MDELyu47o2RUG+OYYsBfa3YhFA0SX6yoPcgzCYQNrOWVOBR/GuFt/p/xtrZEhSQUPluS3K1PZPz4VCCBKbO4Zxca+80T41MzLkqr8MEMNfCNhNOdJgR74t23SmKU0mcSsfM4bWSpFj7eBQlNhxBTuT0sTSAcS7MlcnHqcPEdRG97NQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to jffs2 export operations to
indicate that this filesystem can be exported via NFS.

Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jffs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 4545f885c41efa1d925afc1d643576d859c42921..80ff5a0130603f94c9bce452c976753c85314c3a 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -155,6 +155,7 @@ static const struct export_operations jffs2_export_ops = {
 	.get_parent = jffs2_get_parent,
 	.fh_to_dentry = jffs2_fh_to_dentry,
 	.fh_to_parent = jffs2_fh_to_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 /*

-- 
2.52.0


