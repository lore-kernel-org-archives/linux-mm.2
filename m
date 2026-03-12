Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD13106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529736B00BE; Thu, 12 Mar 2026 17:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4556B00BF; Thu, 12 Mar 2026 17:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C27A6B00C0; Thu, 12 Mar 2026 17:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CDF26B00BE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:45:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C565A160442
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:45:22 +0000 (UTC)
X-FDA: 84538742484.05.55B04E9
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id C406520015
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:45:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=oU7Dkvpe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=XEukUI3V;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773351920;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkNDZy1y0XcEqiMJfVuxaHOJivaG8+FsdaJGeUAPkhs=;
	b=600oGI9qdDet4pCNlXKmLbPSx+hvXtHig0Quw0xIJCNw+aST+KawAFlgItmW80054xG/dn
	0IgatXgVS0wfCfYRj+cglR+h9xuEhlUmnCQrcd6VC3ERRmKdDmNfvkDIhA8e+R/HgCMnRz
	D5d4qGkBs+YtbXnPGvFdBvX9ZeBMC8U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=oU7Dkvpe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=XEukUI3V;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773351920; a=rsa-sha256;
	cv=none;
	b=RbR/wsknLlHIs/EUUwQTgwT0/czZJJd0TVTA5zoryBxHN2ROC7v9gvgkTPlEUf8CclYUDr
	0Kp4N/ela3dioLrIiWgw6nvI1av8MXt0+ML8HItI2SAVI3ZhNw0O5I+d6eOOaiK7mFNfH4
	QcXDy7Tvq5G6HwJlPNWd0obT9RHdz9k=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id D6DE91301B40;
	Thu, 12 Mar 2026 17:45:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 12 Mar 2026 17:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773351918;
	 x=1773359118; bh=OkNDZy1y0XcEqiMJfVuxaHOJivaG8+FsdaJGeUAPkhs=; b=
	oU7DkvpewrvzdiSKJXf+1LXKtPl8JAwiXQg+MNyMTHYoeeMPqHRXvj81aMRL3qvH
	cmWTZEUVpM6ISNXRk3Ve+FcQa1Bj5AKlfu4fO5BxyfFnQ1IF3/9qFpsCArrlZ7vw
	j1auSZiVRvDlCsp0UYsBQfDmeq2cDbh6NiTooBFahDPpj/0Un4Siq+qoSfetu8ny
	7TYD3MS4Y4dQwvSzsMUIwmQr65VMCm5cLhgoMgm3SVq529RWmPLamSe6ZSXsifnQ
	aMQsZM73lq0zESINoCPITL5aMSKvnmq7IFVg8LurAlmYguXXWJbvWfEdQ8Hy9Lwh
	xDW834w2rlAsdRqC71VV7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773351918; x=1773359118; bh=O
	kNDZy1y0XcEqiMJfVuxaHOJivaG8+FsdaJGeUAPkhs=; b=XEukUI3V/2YjPEFR4
	0aIpLrtcxJ4a7LKdlkpP9HmN51hUAiNu7t0fJ/qeroOxIAfybZuMoq+PaRivD0UV
	8eGVxpuDMSmiwmaTAwIJ2SgsSpRaoL4qfI/EnxoLUaxPPE/ogE7afoNNL+tZXXBE
	RFCfq2q6rZAKEd/p1tTtEpxGgXPiXEHBmiEN8/20oNkKhtQL67JvQpE+sWET5/07
	BoQHPCYycVijulfNnU/Ino4fg4qXgO5ogkeL3vzYF5M7AiBc5eloHioXlKSTABVM
	3alYD20GqpHfmYb0aD1smB6oFqY/hwX3+t8JW2/QIrjyXo0B2aeOaIoiaE9SD1ac
	zaL8Q==
X-ME-Sender: <xms:7jOzaa7xaAIypDs34rqVeO9pqFpOa7pLT9RcwbtEl02TKjDj-ud_yA>
    <xme:7jOzaXn115bSzsroMKp-SgWenEzsJxt4GbZ1vxixCWPuViNhej7r3VaLIkvSZm9w8
    lE49TO_hGiMPLF3EpC-BFoXYdiF1SQy7EUI9buDFOBGx00Z>
X-ME-Received: <xmr:7jOzaUhIXHDX_EsiW9mPIsPhqRDlEkQJhmyzcwCTcJGEgt9kpImMRe5kfrI4swRhn54_bJAsV08ZupQnmnnhOd8McWNgdJNUtnbF7ZLP4tmE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejkeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:7jOzaUlWFI5rngjTvHkk-TnbFtcXOVsp6AXoRnw6VS_qGB8syBiJsw>
    <xmx:7jOzaTpwskH1_cEq2WJkK2MqwTEgQC1Po-f5C7lcgR47RRHzLlpyzw>
    <xmx:7jOzaVNseJiz8bp8OkJPcBi0T-9Qsk4AzeqkwYkqCTP_P2Jac-VbxA>
    <xmx:7jOzadIJJVrOWSW25nWdeGFrc24RZ6a_QSUfHuF7rYidH8SDDyCETg>
    <xmx:7jOzaXFeYiV3L0vg38v82tdVGJDf4YsvsysJVh_1adt8NnBqX2WOIwWM>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:45:05 -0400 (EDT)
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
Subject: [PATCH 03/53] VFS: allow d_alloc_name() to be used with ->d_hash
Date: Fri, 13 Mar 2026 08:11:50 +1100
Message-ID: <20260312214330.3885211-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C406520015
X-Stat-Signature: 8e5fqnpurub4qumktuoayttu7ptggude
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773351920-92700
X-HE-Meta: U2FsdGVkX19C5kwxYvK+wCU/77efUJ/Xp/PeWUuXjwd4NI9rZykkqdZigjt4qkQHzRaa0E973hqTiTjUfOoKA8+TA1JuyA2U+tldcrt87CoaCPIhUfoPOwSzhDhTo4FjWKbDxWx7aKKZh+9r9nWpwMoCORPB1DzX5LnXq8QZOpEY9Eb8tjYK9/jJItPyLbxiMdh4wEofzVpRQS0m7ufqTMcp7z/0Ix4yxhUQDv61eX/JcVi0mhfjQRu3zsXJynKZvDKUp+O66i9OmfiV/WD4G6ECH+Qs8er/tj+nIMRLYj3MEciTm0zo/eApmk1KaL1EmCwOh2H9pPGeyZAStvyoXTT/GB3nnZgpgdLeSYrPrichxcVYat5Sym+4FKXqAgJHpN2LgFiIbIGWIczFMtOhnIKkQnfbLviGIX+ie1Pr+mPHnOEH4Nfg57M3T/U3KMftk/AYqjmik+Ora+AE8lChEB8OcE1fSA29SyFjJbB64ho9jUIbAdH+MDtZ5oYhm77haVSXdrPCrXJmKfD20VydizPeYY25WE5vA/zIeIHifpgfjXXF5zVcks15nZhZ48vDQY5/HhNy2OTpaZ2YnfrnIXZ3Qc2Qab2/gWaYo97/aR/52TEjtJMXuK7Hci2vVteoUXWlcnhCYXRBSqE6SbYRIQYQ3gfC/eW2O2SV0avVk7iToxAeN7CnM8skvHzXWF0oTZTPn4JG6EFkNuNuH0DGbFItS7hyRcXoPyM4RfoZOddFAqP0N0rYL8dCzaLSgloVWWsrL2HFeoYVPnhPpF21Eldsjlgu6BpBUA1cHwrtV2Mfs81/LB6aFX0ISN5bk4CrVGSCybY0XGw96R6u80Gez3+0wymtCSJUXw4s6m5cmXRAKrHNbIuI6eOgrXij614Alqa5Rlm+uk7ji032hOtcIqtOsDBtluS72bZibxrnjhZumlabOIfIExL0zRRsIQmGPb3SyYsnweFGUIwoqj2
 K+4O91K9
 MO/PKeWuXarUr0IUjkdaCcSr3SVSVd/cG6IJVd9XbLtLrm4CV1gKF380z1X7zEbmgpl0QQNbuCSq4yg/ZsDffooLf2LbXayu8/5Oij47ICMMJdMXtTe+JI+fZHxg6TthnVWph9UxrWo3Ii/UwEf0PsbMfHDfEzJ6O3KeA9+mP+RpXLUzIdNDA3Rw0S7obi8wXh7f4Jeq+LYY8emmmWpcfr3GbAkrvFKa5tdWl42/Y1dopL+PiUOZtc7toP4bORV8TDoQ57J9TE0+5btSz6IAuqvMwRRUaIFV5/tiVdt/MRkCdDSXz5kzr/xlWPIo5uzX5tk0VZBznIyKAU7IqF7UjOyN3je7O4BamkQp9P03AtwGQ8fjQJPyIw4bnoicevoItyDJcKIrcHKgZN2IODSbytRBkqekOxtHekO9roy0WTtflCylej4RyaYLWgxvqMLcBujEN/TkIzOfXSUDwMmw1Pgl7j3HIUYV8s+sw9dMSfIYp+GgJ7cbpTUqaXuc+zdt5wd7BFdtrOvZrMM0RNX58cMDnGiX53ApMlTAO07s5bBcV5n7vengC3M/qpbUiO7GAbecyX8HtCKmyJGpvCjCmx2siHV3P7eMjnAW+e8TY1P6IqzFEkX139nXciKq9LSeiyf/WxsjBxDZckZWnmeo8Tvvx4fvF8O7fjlSqOwZqNuq6208=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

efivarfs() is similar to other filesystems which use d_alloc_name(), but
it cannot use d_alloc_name() as it has a ->d_hash function.

The only problem with using ->d_hash if available is that it can return
an error, but d_alloc_name() cannot.  If we document that d_alloc_name()
cannot be used when ->d_hash returns an error, then any filesystem which
has a safe ->d_hash can safely use d_alloc_name().

So enhance d_alloc_name() to check for a ->d_hash function
and document that this is not permitted if the ->d_hash function can
fail( which efivarfs_d_hash() cannot).

Also document locking requirements for use.

This is a step towards eventually deprecating d_alloc().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/dcache.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 2a100c616576..6dfc2c7110ba 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1878,12 +1878,29 @@ struct dentry *d_alloc_pseudo(struct super_block *sb, const struct qstr *name)
 	return dentry;
 }
 
+/**
+ * d_alloc_name: allocate a dentry for use in a dcache-based filesystem.
+ * @parent: dentry of the parent for the dentry
+ * @name: name of the dentry
+ *
+ * d_alloc_name() allocates a dentry without any protection against races.
+ * It should only be used in directories that do not support create/rename/link
+ * inode operations.  The result is typically passed to d_make_persistent().
+ *
+ * This must NOT be used by filesystems which provide a d_hash() function
+ * which can return an error.
+ */
 struct dentry *d_alloc_name(struct dentry *parent, const char *name)
 {
 	struct qstr q;
 
 	q.name = name;
 	q.hash_len = hashlen_string(parent, name);
+	if (parent->d_flags & DCACHE_OP_HASH) {
+		int err = parent->d_op->d_hash(parent, &q);
+		if (WARN_ON_ONCE(err))
+			return NULL;
+	}
 	return d_alloc(parent, &q);
 }
 EXPORT_SYMBOL(d_alloc_name);
-- 
2.50.0.107.gf914562f5916.dirty


