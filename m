Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73D7106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E3D6B008C; Thu, 12 Mar 2026 17:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2596F6B00D3; Thu, 12 Mar 2026 17:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1356D6B00D6; Thu, 12 Mar 2026 17:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03DF86B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:55:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B726113ACB2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:55:43 +0000 (UTC)
X-FDA: 84538768566.26.510DFFD
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA24720008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:55:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=QWDEme8q;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=uCftpOHJ;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352541;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EkI+1dYSsaNPhaQL4RFoi/L2xXEeUvFR4/hMXQ6Tv8=;
	b=ZVFw5rhh567kwDGf13f4TFg0a9w/KBtWYWyp2H+dIFyPvwHRRu8OJr24tWLqy7G8rMNuxH
	w5V8I6wTKWB4yxlixVZmo3Pib3m7RraQdNTMTsqDQ5S1aB4GdKRjv9i74Nj8+eSPU0zX51
	wHDsqOI7LCPKIY0GG606nzJatjPIaIs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=QWDEme8q;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=uCftpOHJ;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352541; a=rsa-sha256;
	cv=none;
	b=cavn/nxkbLdgh51Y7LagsUTLW5ba3m90n3WNV/6h/OinHnMuq800ABx6PgYHNBXdDQPGOv
	PKefYMDj9cqltZty1H5Apgb7nSipQDuJunnZUO9TXACWVvUFpCaXjfVpTAekp9bPeHY/LQ
	H3KpsIwjgLiaQlnwWiQG3Bs2tU5BQHE=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id CDE231301BB9;
	Thu, 12 Mar 2026 17:55:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 17:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352539;
	 x=1773359739; bh=7EkI+1dYSsaNPhaQL4RFoi/L2xXEeUvFR4/hMXQ6Tv8=; b=
	QWDEme8qECmbVrBBbWwkEiohStbLaNDmXHMhulBhyoA2EG4o9Klb1AYQqUq0RNC5
	nnDBs7m1PE9pcBUM4WeYuhcvjHqs2D1sE3ayPHMrX+/DMifhX2vb081xbm0s9sZH
	mib0fDRiW0EL75WUrBvfmIo4P6lq0ic+WO0ZWZ8D8u+hNI7/c8FRPA77w+chdZzE
	UNDIwkYV33dYEKHCTqgO3B6LmvhzAMLUTNWy7hxZ7MgeWCKtOCauLjv6EqU11gPw
	tc5/24EPJ5Rau0RWMcN9eJrYwG62vPk+uinTSI6AUMf/cUl/7nrsHyBW2HJN+hJ/
	KjRxJq02GMx1+LsJkMOlHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352539; x=1773359739; bh=7
	EkI+1dYSsaNPhaQL4RFoi/L2xXEeUvFR4/hMXQ6Tv8=; b=uCftpOHJU6GQPgjyP
	BqLIbZVvlgXlUB00MfOPgAaUi6FoFzPi9wFTBubNPoKakH+qqHCAOZOlPS/LAOUy
	2/3De6yOkuPvYWRD68s+R8O8NOgbqOF81JlMqBfjjNF1p0HfN7PxORtuutOGgl9h
	uZ1t6widneeTd+8IGNXM/3F5qx8YOdgd4tNglwZJ+Rzk/id4c6PbCQxG8mGaTQ5U
	tKJ0yapFVfywZIR6KJRe0o9D6eR1gitNNNnyItQ78W5P9/nxAFKWWaudljMP03sa
	j2NvKpJYMrCX1uXLOSrf6IaPTyPZe2mcHof6Yt4e2dWNk77qwKbPdbVaRlkN4WxB
	0dF8g==
X-ME-Sender: <xms:WzazaZi4hKudtguizjeyiXfodZw7Us9Z5TlrZIfUJ3BK76SDx9ljhw>
    <xme:WzazaRvjGdhLe-FsYCIbBqkhtkSj8mSAyqrsSIdUzQPO4gl2UF_sP4tPTLASWEile
    1rpmDjjs_Lcc8KvGYCmEn7GXlMvc4ES8AD67HcaujvX8UF_>
X-ME-Received: <xmr:WzazaUICRgJIkDTfpPnwiHMg1l1HCv9bk1S7kn4_pqjnYMXSyuJoKCwK7Ig8EM5d20TRJxl2MPYdV3TvOmA5o7e_y0p52XvN7x3Qj4ix1xAS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
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
X-ME-Proxy: <xmx:WzazabshJ-q_9wgV6KgTAqXTmtx-b1AsTy2w3f7q6pCvLcT4_skiHA>
    <xmx:WzazacR7k8GqjyOEzAUJqIcIRh_zTSch0uWR1cjLR0IRJXvMjo7PsQ>
    <xmx:WzazaRVS4Io-MY8lFU9j0xRoGXrLk7Z0raOKVZ0SsKRmQKPTmSLB-A>
    <xmx:WzazaWwppvOs-RxpcSIPxRmcmuSyBX1k0cC_WAmlITduW1bS83gNiA>
    <xmx:Wzazaf_E-7jZSi11Dz83gTvIASs6ravc4L_sRo9bzrYz1jx1268FZeht>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:55:26 -0400 (EDT)
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
Subject: [PATCH 42/53] fuse: don't d_drop() before d_splice_alias()
Date: Fri, 13 Mar 2026 08:12:29 +1100
Message-ID: <20260312214330.3885211-43-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BA24720008
X-Stat-Signature: 3p198bc1bgmqbi7p6zmgunrwogx8x7qw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773352541-515309
X-HE-Meta: U2FsdGVkX1/EM4rMyBAqO/qcJjSMi/nD8CcejUvseMFs/jmfZcj/zYjkiOOVGJIs1zLQWeGjbEw6l/9cIlNAz0G/FZyoxWPQg6+A0tYNwfg3iSpImR4QFlT9wRL6BHVp2pGqACWsTfEpsFI+07bu8pJpZS4xvIbB98iSwO3cAMHTgd3PQyfhs29ERuWyAlv3Cbj2wwxpjCvXuDG+WjoTXiJiRk4dvMJG2k09GOhkWSMdxX5G4Op2rvdmPLL2hd7FDbE3giiSpoRlTqW6yAZdCCp2ovr140ZJ7YJ5mQoZZrIBgwp1cvB7OxZW/8JCUG+K8iVRMADojSwz1KYZ6+r1P5YqVFfnMzQRteXq6v0l8x5rQveXb0Bvk+gyyP/JbbdQiQC1+KMWnRSPzRwv4+F0O56ryHR0SyUV7py1MzJszUCSk7IOY3xKF3l29BnO71qfNFOAoxN6Krvmn9pMJorbYIrxu9RREHRZIYAKK9hnwoqxM54bRHIrqecvDyp7kR6imdi7DX3nJ13LZgabxU68Yomx1IgtRiCuqtwyQyjtAIjQRj4r0Dbkx1VNDTNfXw1vNZiZ3Fk9ThHCEb2VrXOVqgbJIHkzQwJ4kei8cwD335sBsQkaoq2n0Y0E/HFI0BHGDlX/Qr0sPqhQppaY0AcbgI9izFZEf6cueXxKLuSEqLZbwEaRkB5VrSPtT0L3JGhIKaVYkPRZb4ax9ZB4W3qFiOO3ObjGtu1QvKnVca5XA4nu96JuYydVrKF8QhkyaqhZERxP121apsTvHE6AUapHbPIQagTZr13PvPv4zkw4G2PD2W+2GdRVo1nd+rFwy8XHtQ6mNAajl7H36A6W2ac+WVmJ5z/ImkWBgvS+QRVDA8dDBUwE3Kfdjj0T+mAJoWayalCm3hkcFirMOeIrYnsv4EjT/egO7rfsE8tdhgUwdsTsyo6HSHpuFUiNLz8+DKjwFpOD4me/+VCwlAMlfTL
 ptJh9Rzs
 IcVbaqGUg/rQgGO5lZFAZSi80nkFbk0qn8ew2EjTEbDL61gR2f/MxHzJkutTHLi/5da9ISYWh2jDGCuLrS4qfSycfsm7o8gkdsYDHNvBH9PcuVd0Qei5OHc1gO9De/ZdEA0HKmO6vgYFM6ETP5VFJOQiXlc0cx/hcyq/hEvsnHchj17EAZTz30TVUwVh7pWKxpjbQsG6uSaBz6Mry10UzJXfTOPXq9ou4plMgFVbozT/Cerl67XpdIRIsruHR3RLPTOya6477sr0p4uYrGn5wV/Pk/FxO5cLUYnZfPCLcmSEn0PJCyq2sYUW7H3pSLlSjZX1w1Ye7AAMUKknZ97hsxzFEbS/5pLiA9RmRbDmNQ2nVGXNVrSMLNM7Kzr8bbnNGb7BHF06PDz7d/FM9+aj9aLVxurl5O3cT5ASkpM+zDckunrscukZ/mgV2eiKeP/ix4RKN3Aijh6nQ0KGiOVfmsunBfjgaggisDWD1qQLmPZNgXSStpMkgt4CPzDZ8aZ0VaGKA4nBVGuDI7zXLNjfFbEY0OP4H7GqrJ5Kj+JGB2b+W9uM43CiziFoEuiiqUWgu++S053fey637MTStbcItxv9Gi/k8DL+8/9S9n1UinUeEf/Dc8sc0RkzBySqOK4UqP/9zJBvOUJcBABAdVKtN9UIaf0OebrBVt/5cdskutdZ1sZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

create_new_entry() is used to finalise the creation of various
objects (mknod, mkdir, symlink etc).

It currently uses d_drop() which will be a problem for a proposed
new locking scheme.

d_splice_alias() now works on hashed dentries so the d_drop() isn't
needed.  Drop it.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/fuse/dir.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 7ac6b232ef12..a659877b520a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1020,7 +1020,6 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
 	}
 	kfree(forget);
 
-	d_drop(entry);
 	d = d_splice_alias(inode, entry);
 	if (IS_ERR(d))
 		return d;
-- 
2.50.0.107.gf914562f5916.dirty


