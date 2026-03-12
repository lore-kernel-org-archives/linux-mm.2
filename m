Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA2F106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112606B00D0; Thu, 12 Mar 2026 17:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0576B00D1; Thu, 12 Mar 2026 17:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9CA6B00D2; Thu, 12 Mar 2026 17:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9EB86B00D0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:54:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 960AE1A042D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:54:32 +0000 (UTC)
X-FDA: 84538765584.13.C40ECC4
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id A05F020007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:54:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=knwvQbEG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=4Zu9WuMX;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352470;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rEBHIocsGomFaeNZ8FKVkPPiCLC3KUr0T88wGXsY+w=;
	b=Y+VG4H/gzxjpNc3xZXweAM9V9Sg4joqGcZJL2o5wIZ/RVDkTz5eeRVFiCKicbJxJ5QCDy+
	MDvB8hV1027sipD2bC/Ki0MuapO9R0uiUxk0DD83NeuZ2mKNFNnfKyVnksV6emH+g5CIaB
	jjsBP6tSH8RrbguvPbfGVuzzQcyqQTY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=knwvQbEG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=4Zu9WuMX;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352470; a=rsa-sha256;
	cv=none;
	b=WEXrgVhja6ElR0/oF6+AHaOj/TduhNRuEd4XiQNECH1fO2Ydgd24rp58vXwd79/eQDKF3b
	tTUerHWy7AQylpPXrj8Ii8onCFYUzI+6PtDc5ggcg7LVCO9mrMu+RhLRA6IjD0poEyf54k
	Fsjy0bbAna+ROMzS7d2H0AJAshG+4gU=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 764DE1301B4D;
	Thu, 12 Mar 2026 17:54:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 12 Mar 2026 17:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352468;
	 x=1773359668; bh=6rEBHIocsGomFaeNZ8FKVkPPiCLC3KUr0T88wGXsY+w=; b=
	knwvQbEGvEIqlMfPnGjtJpPojdNrNczYPtebe2Z4kPKMkUCzRctdcCXACQElzs21
	5O2a+QMmSwXVS7mmXVu2UbB62pEo78a9LLmTYGivD7du0jEWHQCQNY9CqyyjZM0D
	WxQVP+B/lLDgba8OONiDmEMwfdC99MyLWeo5sUXoJpj2s0/eqU6juECWNWTZd58e
	f2JUhGZZOdAKXc5zKwvqkmFAR+ulhtk7F4N+/VKAGM16LSYty6niYrfDL3MhwWZQ
	5F7UPhU37iVLnKURGdbIUXSCxaF0GsKm5E/ELskY9F7iGXtUNUkh7m1SAYob5ueD
	tG+cNMx+lV41n5I+6+vVUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352468; x=1773359668; bh=6
	rEBHIocsGomFaeNZ8FKVkPPiCLC3KUr0T88wGXsY+w=; b=4Zu9WuMXKiMeGX/7/
	ze2DMZPQ/soZLDQ/oXU+K/4hHMjcEbwuRZzOQNn/0FYKubqN7uvd+xUhQsXGDVfc
	XFQx9NIeuhB4i9Fdw+0hLLcGCxsoXgvauzXIgttzQmRQRIMSqUVbZ83wnbvBzzTO
	LXU0seG7VBKWtNnozR19mdRgFEyA4pYMjPGA/j7LYSGbfIowMBFBZEYKa8ZivFjZ
	wCZFyMVCKIXP7JjAvEk3jKEPxxVTswqg27R3aHZpcyHuzR6zYaa9mxb3FygDZl2f
	k88L/InMovZo682809zK4ENFUDAn25o7ypfmHbL8vM48dnX2pKAMzl5X2ab+Svl4
	ddZIw==
X-ME-Sender: <xms:Ezazaey-fvZqInYUpzLKVh0s2v9tOotlJQb5SulL9nI4oaXgr3tSpA>
    <xme:Ezazad8MrhOleAAQOTQy2qLblBKX5WC_We4qchjQvILJ3pnRA2FxvthXMjdfjfV4w
    UoRKHkRpzuWB2q2BhG3sPKxU_JyisucUacsdZab9tuQGNM1Hw>
X-ME-Received: <xmr:EzazabbikfbFhxQsQwNIZruHOMSwYGu5ivVqXVqxLTeYxlwz9iv_yIyz17g7ZV2LlcxBcrz3VW2uBeAL_bnCWa-q56oBQi4V-rXhNxIFXune>
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
X-ME-Proxy: <xmx:EzazaR_rDZ2cpPqieMKXHtJOQkHjLTGjyZbnPvedne1hBz6T8TNV8A>
    <xmx:EzazaVgT96boA0j1ougvrF0FQaqGb49jA9P1i0x6pBMQiTubNk5OHQ>
    <xmx:EzazaRnU5sTc9LuYwn6ue2LaL3bI3JtiIHjA8-szWM4tYJeor1kUZQ>
    <xmx:EzazaSAd69RfkLZRj40WM2JpiwTdOS31qJZu-6BnOXl0dr1anYis8Q>
    <xmx:FDazaQPDp6s81azLqtKk1OQBYAISt4wd_paeIdQbgvXGX3nCkXzwKQNo>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:54:14 -0400 (EDT)
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
Subject: [PATCH 38/53] cephfs: Don't d_drop() before d_splice_alias()
Date: Fri, 13 Mar 2026 08:12:25 +1100
Message-ID: <20260312214330.3885211-39-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A05F020007
X-Stat-Signature: x1qasbiajx9wrbs5aqc8io88hsd3dmwz
X-Rspam-User: 
X-HE-Tag: 1773352470-233509
X-HE-Meta: U2FsdGVkX196+GLDcmi73Ur0tiPrA+IrXYwyaNvptPTro9Zg+OvjnoyeBLN1x/MIoBouM4RW78y6sS5ovgoTQEP7E3rOvl/5YpyxMRvDXxPdCybkCWMrd9kZCylQE8ypd0r804B6O8VBsocJhd6gEd7hkYZ8nqqCXr2RaWFhKvdYikduBSMBj7f22N1hQuM4LiJf6/KZWgo/g2kTk+6yNHAkjUcVyqr/soJzxu+st+iyJg72n3f3UhcFXPTHtXtlp6koPKDzQtiDlUs5cfsyYcoriVpsVP5WYgS5MKSRrXVVYPUZUOTYH5+r5OW8Hiho1YPXybqozU+axALjIoXePuRp58KQyyo6g9irGib7EWbtpiI7Q5cTJk4J1d6ZaO8PPZv/WYBBwJpONqESiFABNXONpzHBPf6WacELJukZm9t69OQEi/47fGtoeGZ3vm4TAo5UJCzY8wIuWkHm4FyRgZnctm8vuTocAj4VlO5RZKwEFJIOwVTwgksXuocpfp/IE0odAl7RrZ2n9O34wePBKWTSu7HzkTVYb7oyCGsajDZnM5IaYn6pfy1Caf7nWHFVlTN5u9oREs5gEv6etf3DOyLBVeTgR4asarD79zH/vQW6LaWdn0ZymTOT0gjxdlouDkyekrahJXy7RL+Mlq+nckwK0L0l9F0g+npfjr/qX/2Juq34172LUXWtibzfePAfvwYAJKVSzmVuUPXi99PVAFO3KVtdEZzTNHtV0FD/oOoS4XUzXl/B89HZuUaWePC2G7y1eFoLNeEYe+e8zvOn27PIBa3tQH7nxt8yyRlGXG/i5xoANc4lCZiz5Jpj4HKxtHIVB59SnQfP0LiRPRi3CUvOKVu4NbbBKVhhQp8U4JXsGscGL8gIFmXVeOaokOXWrCziO7A5JLfQaEBaL3nUDxtap+UlyRO54FomfDhaCfTljVR4vW1fU5bH9MvqZEPdJ6S32kTxK/XxQf+siAg
 HVteEExu
 m1XrDPz87EUzYLzsLXyV7e4dwjPMUn8eGPCBh18jF+SwqvJ0htF8yLvoP9Iy6KAa5Bvje+lrTW6tRqSciDse9FWu8pL1hHdxB5rGA0vPQgacgJ6RfjWlZFBiybALXXuL8TFWJh4grWkfwFZ9V32YbDps/ocgbmdbgHvnzgKsP5S0z74BzaJBzTaoaxMV42zdkOi97eSGSjjKlrIqyVNDeH1eziLAB9pgsAxOCDldKA5IfOB8gvtfgEPU4su/Tg/7WEdleWfX1iSNtYPPCylNjjCTyKiru/Tl/H5Q5fwJiyCBRAGObHRMs2i/ZnI2RQ3qFsyEVDHd+TTq9zK9aaxi4WLqcadwDtU+eELthhXfdpFHhB95dj2dIOmRq4XSpDKHhOzuP9fMEGe1JCXIKPFwLGVeZIuNKOGbwts4WR6+mD1jZ7kqy5KwpG7rDM371m4OwaknijDvPYDk6egPAOD36XK8uC1rTLLy1s5H0q/Psd/qFXjVTbdr8Apy5IA1HPsIPyNUN/1atj2cw0BL67/RwgFsZEapQQ/gTl7SilK177F9PghbLPBN8Rm0wgolX1VsX6sHXTNUzdpVzdaBbRLitG9axmN4Vkw1cXVzdI6YXF/GFy7sErJipDc5WF8sGaxjVRw4WPmyuKv0xFDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

In two places ceph drops a dentry and then calls d_splice_alias().
The d_drop() is no longer needed before d_splice_alias() and will
cause problems for proposed changes to locking.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ceph/file.c  | 2 --
 fs/ceph/inode.c | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 66bbf6d517a9..c40d129bbd03 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -751,8 +751,6 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 			unlock_new_inode(inode);
 		}
 		if (d_in_lookup(dentry) || d_really_is_negative(dentry)) {
-			if (!d_unhashed(dentry))
-				d_drop(dentry);
 			dn = d_splice_alias(inode, dentry);
 			WARN_ON_ONCE(dn && dn != dentry);
 		}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8557b207d337..32bac5cac8c4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1517,9 +1517,6 @@ static int splice_dentry(struct dentry **pdn, struct inode *in)
 		}
 	}
 
-	/* dn must be unhashed */
-	if (!d_unhashed(dn))
-		d_drop(dn);
 	realdn = d_splice_alias(in, dn);
 	if (IS_ERR(realdn)) {
 		pr_err_client(cl, "error %ld %p inode %p ino %llx.%llx\n",
-- 
2.50.0.107.gf914562f5916.dirty


