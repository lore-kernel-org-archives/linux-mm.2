Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A59A106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF69C6B00D8; Thu, 12 Mar 2026 17:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4A66B00D9; Thu, 12 Mar 2026 17:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6486B00DA; Thu, 12 Mar 2026 17:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9D19A6B00D8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:56:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71E1E1C381
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:56:34 +0000 (UTC)
X-FDA: 84538770708.03.A9A7190
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 716C5180009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:56:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=BjVQ7Tij;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=YpiNzHFW;
	spf=pass (imf06.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352592;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1Hs5eklgfQn0H62/n/RsRquBHKKGkv3SWjXFgqWxeg=;
	b=FElJutRECJm+JsexI1/hvNldbaycw+qzHDoW9m2ekJIHvYEHmE/im5bB3qHr5Z7F9/NnS7
	h1nNkUidNEGhcSqHvdzUQL6R7E5gRvdbLZ09uw6/a98EIfUm/ntD58UpGh/pKistpCqoNw
	SWVE/Pb2xZddbQmebTBZ9nPZsotAafM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352592; a=rsa-sha256;
	cv=none;
	b=rbnsFeqh8NnLDvGBue5m161Gz/lRgM53yeU459oULFG5pxlzgSuUEJya3/H1C2m5AnJsjp
	ZkT0s4siXPhHFdrDbRcjNnopdNeJqOrc0wjOrV2rAVI/c9k1bRHC1Q/bQR5FJkT2quENjQ
	WOOzftvfMEMU8Z5gxazqvUhGNec+wc4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=BjVQ7Tij;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=YpiNzHFW;
	spf=pass (imf06.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 84D321301BBF;
	Thu, 12 Mar 2026 17:56:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 12 Mar 2026 17:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352590;
	 x=1773359790; bh=V1Hs5eklgfQn0H62/n/RsRquBHKKGkv3SWjXFgqWxeg=; b=
	BjVQ7Tij/z0cXHesrQNauBD40mf05TL+Wj6m1LoIvu1L/NzpAqGZ5cLMMYGVnhHH
	5qpQy4Dpm9bq8Pb3bQ7SLoPEAN90xLCEzbpDBw32FsuGAR+9EIQaGhiqQ98SwOaT
	QOjIC4JQ26O0nUw/gfHxixp9O2LeLOAfcv7ko1la8I/jwje3ZAcm/+yUWtQegekd
	SEaAK9AahEsg1k6Lo05tjFqkn7nUv2p2kEM2DQJCJhauy4winthpmj9pCKsDjw+g
	LbL1Ut73HTaiBOaqfNeCA2hdtVcLqDwM9vhFb2A/Gp+vNDKEnvCIcGUBnuRQC5w4
	c1vlq/YTLJZHkxtZdNo3ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352590; x=1773359790; bh=V
	1Hs5eklgfQn0H62/n/RsRquBHKKGkv3SWjXFgqWxeg=; b=YpiNzHFW7/D9ZPSMi
	cZJKUNBZwgvwypUiNaP/NJM1ssRQhwagO51x7MSYiJEweucl/LQJMa2SKCpn9TMY
	zKHk3Y1z+6lpK6TbV+SLBojRbVgzqxTumBjH8yjZlwb/Pw05pMeeuDj3VQASKNMH
	JI1m/tgCDLltyQqPzDgUlE9fDYaQup9pOGAFgK5F8pGZ2h+PJQKg0JYnhCf6Anpd
	cMP+lNg8R98vHR1s3CC4zCU3o+z2qTy8ZvFno6N0EEpF2DC7MXEjoQhGkqR0/QDv
	RkF1A/8dkZ52tjjo3Ye102S9dNRb2q+2o8wsWe6EZ9KjKj0zQND+rl+xPCwoT4um
	OVbAw==
X-ME-Sender: <xms:jTazac6FLGNVN6mYXBnDf9SGBJ-5AaLarvcOU8zCdKM-rgD0nm37qA>
    <xme:jTazaXkaZi6_Q0Jm-lBvOu9zaiUvR22nAfEL3fp-sBQlrI8G_kmh7gL0ayaRInKRk
    XZIxzM9PotaAMQ3cBeWj4acBkT0vf9SDWm_3_E5WG_nMyTpIg>
X-ME-Received: <xmr:jTazaSbbRo76-Cc2ogkQrvL-OPYQ5JCvn2bqCYzr6nvGNZAfbGpbGDH8PFUEvXXPdJaMLQJOCbVZDerV-oar65urrK5fVyegZAnq-kIPqB6X>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohephedupdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:jTazaVOQT9zD4viTQ4xyy0f0WkaSFD_ev8WbCWz_uPQ12WavoQ_H4Q>
    <xmx:jTazafiMQd2syhHGHNy8Myu4LisMaLIGGQkEyIGzYQ1rYsquHpExpA>
    <xmx:jTazaRMuOIUcjmRzCMyCCRij3jggwxOGlKVoNhuEHX6MGQkKuIhy1w>
    <xmx:jTazafqGIcE8OMyW4BiXoDHDYQOqT2BRlWtBkIn0WX7qznzvPQMgOA>
    <xmx:jjazaRA3wD6VQKs5bEA6Zod3_QakbUuuwwdoM7KaYYhvXHRdFmZWbWeV>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:56:17 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,	Carlos Maiolino <cem@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,	Amir Goldstein <amir73il@gmail.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>,	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>,	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,	Tyler Hicks <code@tyhicks.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,	Jeremy Kerr <jk@ozlabs.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	ecryptfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-um@lists.infradead.org,
	linux-efi@vger.kernel.org
Subject: [PATCH 45/53] efivarfs: use d_alloc_name()
Date: Fri, 13 Mar 2026 08:12:32 +1100
Message-ID: <20260312214330.3885211-46-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3qdkqjfxqkczndzz9tkigcxcspkzzgee
X-Rspam-User: 
X-Rspamd-Queue-Id: 716C5180009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773352592-640117
X-HE-Meta: U2FsdGVkX19JLiLhTUKv497D7BQ+drzyGG/AufsknPe/QESTDS20KXPDvebTiRu+b2kKQO1jsr+iOmw/vGaLoAeM6+MAEXphqzSvHgOb4GRqGeFWXJPb49QLT7hJqnRylA2TgN0ZmPnbEDGa1jFP0Mbkq1YxnaCALhyYcUK3qGjHLIpu9kGZc5Msda4TbPQfyW0QpvG+gCxwjeb/JhVb3NTe7OQdAxrTvlpj3CQEXd9fR3M2JYhBFT8kERZlZb7LRZCkJP8Gx3z254RDqXE9r+qvqujr+i8+zxLomt6rKRl7fq9mhO5wiJg9J4XBZXrPWZFQxvdAJRN8OqKUj2+u0skwgN0jvviIe6wl4ylTE81KFHqjwF2G97bXjcMBQoahG0x3+ImMGoFsjYy6QGGn+g021wf63l2mqSyIdgEr30ReleJzwQ5AmVmUHkezYtfBV6IknIBDccS1xeKgGmtjq1BkLrivaFYbpns9X87Ny3NQouLt1ohXzCS+KnlJy4BThLs2s0wweRx6BoE0M0SL4NanJdnLysfaXVfIqV0NbLP8pBpbL6lhL2fCEBbjpvvg0Opu8be4LTZXXl6ERj3rWbtMKCISrwoiiUwYgvZX4sqRNYYBPDTEtEW2vRV68IyMSIGn0w1ZeDZCpapuS/1ydaXbTSmwA1hEUgfTwdjI8RqzyNlQtNqej1p5uN/CYyhKxyPtVBvOHqPfLtggdYNbsig6qJTy9fgcCCS3NRaKzxZjbwUTQtfeln+MMjlmq7tAxD2z/PPENg6hkCmjQdVFBukrnWwgmfYWPaHvQOzlI1pYyZoTHDptxrAte2Kg6sVZ9VIE1BH/2Yc7i905LrU0OGPwvFveWjJmjEYp1Yj9v29o6PEYXKB+ZcG6TXdH0iAAxY9pPJkFQ7wNqiWXtA9E3DstkqKmxZzZ1AeuH5InSwnobr7FTHnCKkn7f1wcqb82n1u79Zsld4WZLGHun/5
 i2IbD2ot
 wROKXuJ5nUm2qZJloo6zV27zLkSb5/kiiSC6DlSXs02aykoNXdtDJGTebh68Pert++zQ1MQ5gluLGwW1XkrjdJ1kOrcq7U4vFQ7D8mZT0LI65ESaXQWbpSUfCOkzppKqMZRfVc6IirAx9QYXduBmv6Ih1A6xCk52df6eMB8BV1Y//HBGFuXJj4mmOsA4BNnVPtnA8rwJei44Ed0whpipLUCJ/Bi4nWQsRHTt6Yv7rvjznxR8r3EbMdR+Pwh4paTzk0fw0PQlBqbFSz54iNkTUyEOr4al5n8xvn+ng4pNsDzH35Peg2lfXHZhifH2ukW4tDGJfJ4/QdHfHjBUUz7YovehJ5xT/xmYMqAucpLwheW8AJ0vAJNz3KHn3bZw7nLlZIku71rYLiTGqffUhd2YSMMvZVEyvV5leyqGGPVq/GWQK2xvQzAwYF+MOCevaQBkcjfI6mGEPGbgTodX78gLGr2xxW5hPKF53LOe8jvAanC2l5de0FXup+0ZuOrkqAXsSd6CjqMnfdmyy9NeRyFuA11lu/L7AKRgwmT8NeSv2+zlXcS3a4YvEtPJ8r0C1ftqzrRdAW64SuQpMJmA4kVr9D5FvIrRF8gLHD678Ypp+hk/fZ/9swSdV/EI9i6gbwc++J6xKlhJ4Wp/HRUiAuM97CEBF+3/TkrlEKih3nXkfmpFJZcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

efivarfs() is one of the few remaining users of d_alloc().
Other similar filesystems use d_alloc_name() in the same circumstances.
Now that d_alloc_name() supports ->d_hash (providing that it never
fails), change efivarfs to use that.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/efivarfs/super.c | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 1c5224cf183e..232d9757804c 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -189,26 +189,6 @@ static const struct dentry_operations efivarfs_d_ops = {
 	.d_hash = efivarfs_d_hash,
 };
 
-static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
-{
-	struct dentry *d;
-	struct qstr q;
-	int err;
-
-	q.name = name;
-	q.len = strlen(name);
-
-	err = efivarfs_d_hash(parent, &q);
-	if (err)
-		return ERR_PTR(err);
-
-	d = d_alloc(parent, &q);
-	if (d)
-		return d;
-
-	return ERR_PTR(-ENOMEM);
-}
-
 bool efivarfs_variable_is_present(efi_char16_t *variable_name,
 				  efi_guid_t *vendor, void *data)
 {
@@ -263,9 +243,9 @@ static int efivarfs_create_dentry(struct super_block *sb, efi_char16_t *name16,
 	memcpy(entry->var.VariableName, name16, name_size);
 	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
 
-	dentry = efivarfs_alloc_dentry(root, name);
-	if (IS_ERR(dentry)) {
-		err = PTR_ERR(dentry);
+	dentry = d_alloc_name(root, name);
+	if (!dentry) {
+		err = -ENOMEM;
 		goto fail_inode;
 	}
 
-- 
2.50.0.107.gf914562f5916.dirty


