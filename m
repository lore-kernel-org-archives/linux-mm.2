Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BAF6106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09FAA6B00CB; Thu, 12 Mar 2026 17:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054346B00CD; Thu, 12 Mar 2026 17:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B0D6B00CE; Thu, 12 Mar 2026 17:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D61436B00CB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:48:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA85414047B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:48:31 +0000 (UTC)
X-FDA: 84538750422.11.8487AA8
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id D85E5C0009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:48:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=Ulio8jdR;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=V1ILUza9;
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352109;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmjblPgjMtNsKFHT5qnV9lxupCTmEj8C0v6XyHf7K7k=;
	b=zgdUrVM+GVst1YIHk5YnpugYpnMJdYWIAgRsolahrS3NlDHcA0ti0TEx7puOfTVqfUxYst
	52AcOlHALFb4QH27/RBeVmx/MSKmu6hzF7/Fpk6Z8Jan/2scynYPXe3JXWBKlB+en91f7N
	7plZdcfGAh6hkdNPvRR+81OHWihp99Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352109; a=rsa-sha256;
	cv=none;
	b=2Pd6VZkm1w8vlxv43N0x9VklSyMEblKBY1+dAZUSbx7IB0O4sphAtPOVWhbOur2SCUBZ2v
	wPOJO9gh2kpHARSwjBSBGKMPInqwPj8Rj3Ww7n0CwNQH+1kN1IQt30B/M34Pu0h5ahYax1
	ZRQUzqJgWkKuwYRaw0VjBuUmTve8JIg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=Ulio8jdR;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=V1ILUza9;
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id E04541301B7D;
	Thu, 12 Mar 2026 17:48:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 12 Mar 2026 17:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352107;
	 x=1773359307; bh=KmjblPgjMtNsKFHT5qnV9lxupCTmEj8C0v6XyHf7K7k=; b=
	Ulio8jdRV17YOr50t+t7boNaHOeF2wTQGOHtn+dNIoN5vKNfDyK0CD44CgXabKUK
	TV6nXN2knVpB++dAh4V5AAO9193CaTSvg7SQYb2sKyBBRHlJR2LidDplCTZEANqT
	vmfQ21wRbawPzNwJbwUvM+LB20U4hwnVaghMWWb2/YIpQqO+6cYfq3X0KzeCr1oi
	FJSDAmeGC9yvUXg0iUtYAJxZee59kb6/VwJuNxNGDE8ysKU1uxaXQjerR3m/1UF6
	69fvZaLM9UVgD6sUjJm72z0yVSaXyyECAxCx2ODjn5Z8fqrU1RbyBsGwdzuxZIna
	WS+V65cIpf2Vv5kJeBkFWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352107; x=1773359307; bh=K
	mjblPgjMtNsKFHT5qnV9lxupCTmEj8C0v6XyHf7K7k=; b=V1ILUza9NLQSxawiL
	eF0WlKAetuUAGiKullHxP7XEcjOGX0pSDLHT+d3ZxLUsukHA9enGP//FKvRTQqU/
	IQAZbK9m1MrlRmvhragai8VPzskTiPUPw5NyPV93/lE9PPi0U7yTePGgPZuNDe8E
	2KtvNIzplE7kIb4ZMNiFpnwQr67l2ZluVdaeE0+q7D672SbupcGOiQ4VPzXZuHU1
	39+IR54k8h/yleEScI5O9sAqsimUETjsmYBMojccLsdfnvm6TOqgD0tMeq8OULl7
	WdGrqgiD5VcVeh2H65t+c0B7nLPTaIdBrH6JiUsORtvwHWzELLSJEDuM/Y+JdCLT
	Rq27g==
X-ME-Sender: <xms:qzSzaWje6cDYVZTL6oRga944PHze4WztxNBkg-UWzbipV-sJXmrErw>
    <xme:qzSzaavc4w9W9aG6YIyVleJhpfHtCfo2YaBfvj31McqpbgK24kIWlsdRER60iBLDT
    WDFgT3pNbtScSHtleoPoy3PM7RzP0I_ombeH2mkYew7rWln>
X-ME-Received: <xmr:qzSzaZKkPCr5kGbM69aIAfYhsnh2jweVgWwOC-VwnzZ8IDsS7pApMX3BhrbhSlbECWFcszM3_um6AAvnkECHXQOg7rRHFCn97G-ztlgW88Lx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:qzSzacsdvoW2RMAUGHvilYc3L1sBOgLXw_1Y-TSRnvvTYhGpZ3n9ug>
    <xmx:qzSzaZQuE-abwLWUtQGwg-Qi3bAAab2Sek4mKMqqlZKVZAqQSCH2kA>
    <xmx:qzSzaaVUpgfhBKqEz-fvy3vGigsuIsmeH9eHDIyvlkt1FwYUswK3Lw>
    <xmx:qzSzabygAjfC1YXbKloop-JFYJQjQzYu2bcVRaIZmFPzF_lLy_bAOw>
    <xmx:qzSzaY83DT5TSxCCpVbf_7WrM7PG0uoHAsKdRRw9tEKJa_AkpPR85Sf0>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:48:14 -0400 (EDT)
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
Subject: [PATCH 14/53] nfs: use d_alloc_noblock() in silly-rename
Date: Fri, 13 Mar 2026 08:12:01 +1100
Message-ID: <20260312214330.3885211-15-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jndrxn3pfm19xfkfyuwbwxob3sgqz957
X-Rspam-User: 
X-Rspamd-Queue-Id: D85E5C0009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773352109-721741
X-HE-Meta: U2FsdGVkX19UruDnEMRyl+3Nsv0jf/FkiOkz/tpD38vEXUgJ4XRzbKGOTLrnsdRmUav9NkHpFdFFk4yswRKM8U2WMeRYUlaUFuxaRpo6EH03aT/RRq7SyngWuTqKnMmlUAidjKcLlGMRkAB7i+cYQtljX6SdPoA5ACFkd015Gi6B6MkcpeCHUPCXpO6HSFwxLWFXRKRulCrxddvxHhGSHM/M3XxUjGVCiKLuEsCdB2DSAUYqqGbk+mECOI5oYKprmdHtvwhgSW5omWUlitHqMSq1xxImbDfV7vN/+lfbw20XQrX0aiNJoBfBRLDZDsAQkEgH7/5qYsbRdlOQNvMPrwjwP6GTwTOJeymOb+34hdtGCQgXyCc+x1jdrvSIolS91riG4grotPZACGVAsYrBiko2x+CElYT/SfDjrfJWNJvMflzGR5TIrsgByQhHYj0R4KXXKJvYl0Qk0PAv3TSTH+s5/xzCe91nI9o3yZoQdRm8QgQLCgLnefTbpYozkdwcyBFLKBGjPg13iKktv20DTQHkfz6yAOTn9xU7A9wiDNxzdxz0go0t2QxZpSfdt2orO2o5YbSJ9fK4jOU+Yhda0xUlDlPlUhytcPPuzjd+YF4Mu8V2yfWVIrqz79wvq3te6qKX8bHyZToDjCg1fZiCMODn5jj16/cbj0lgFOKh/43XVvvy4vO/SCNFEuYraJdpk0PeBjcTeRUJstrn6SW+o1djp6q/qT6kXtn65LpoO5ucQmqGHA1yx9fb57I6AZC1tuaWuZGs8BUHdu/pGMO5knlrQ6qSrSInK7SOYcwWwsjMnPb3lXvQmS7qtGcdkytcrZ4uVUx5rnTGk69ZUuKPywT3hEDtt/Rp386SirbfimDshNuVonxCEP5fTJ+vssxZofxfjc7LPGcgijan77137NsiO5S+dPmhZA6Dnv+e/pfhGZG4YFggI09DGbA7U66FiVghZynKvSojGyhPlNS
 HYXC/y1X
 2L+jMkkyspvfSQxz4jQn46a+pn7PF7DWYeTjYR77uSXa8gfuN4oi3TDLgWIyKHbgFDKhHwaEiGmDf2nUzbrmxexcZDufsf/lRzTsJm7VA1XrR7lD04FFIXBIyfquDNDyiaoVvfFuw8j9dXylrWmrwdKzs7rpUvC7rSO1rmT7fBmsLCrzX6bELXqkUuK7P4txbolI/xxhW76+jT6meZY6aR1BP1mnojdJbnI/Z1bjkjfvRth7yxMxuiMPuac3atT6aNT8fJKmUcdMRzVGnEhyLROf9trKT1Nf1IftUZX84a4Joubj+hcalgfp0szDsv0XHvsvNHQrQgPgOF60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

Rather than performing a normal lookup (which will be awkward with
future locking changes) use d_alloc_noblock() to find a dentry for an
unused name, and then open-code the rest of lookup_slow() to see if it
is free on the server.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/nfs/unlink.c | 56 +++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 43ea897943c0..f112c13d97a1 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -445,7 +445,8 @@ nfs_sillyrename(struct inode *dir, struct dentry *dentry)
 	static unsigned int sillycounter;
 	unsigned char silly[SILLYNAME_LEN + 1];
 	unsigned long long fileid;
-	struct dentry *sdentry;
+	struct dentry *sdentry, *old;
+	struct qstr qsilly;
 	struct inode *inode = d_inode(dentry);
 	struct rpc_task *task;
 	int            error = -EBUSY;
@@ -462,26 +463,41 @@ nfs_sillyrename(struct inode *dir, struct dentry *dentry)
 
 	fileid = NFS_FILEID(d_inode(dentry));
 
-	sdentry = NULL;
-	do {
+newname:
+	sillycounter++;
+	scnprintf(silly, sizeof(silly),
+		  SILLYNAME_PREFIX "%0*llx%0*x",
+		  SILLYNAME_FILEID_LEN, fileid,
+		  SILLYNAME_COUNTER_LEN, sillycounter);
+
+	dfprintk(VFS, "NFS: trying to rename %pd to %s\n",
+		 dentry, silly);
+	qsilly = QSTR(silly);
+	sdentry = try_lookup_noperm(&qsilly, dentry->d_parent);
+	if (!sdentry)
+		sdentry = d_alloc_noblock(dentry->d_parent, &qsilly);
+	if (sdentry == ERR_PTR(-EWOULDBLOCK))
+		/* Name currently being looked up */
+		goto newname;
+	/*
+	 * N.B. Better to return EBUSY here ... it could be
+	 * dangerous to delete the file while it's in use.
+	 */
+	if (IS_ERR(sdentry))
+		goto out;
+	if (d_is_positive(sdentry)) {
 		dput(sdentry);
-		sillycounter++;
-		scnprintf(silly, sizeof(silly),
-			  SILLYNAME_PREFIX "%0*llx%0*x",
-			  SILLYNAME_FILEID_LEN, fileid,
-			  SILLYNAME_COUNTER_LEN, sillycounter);
-
-		dfprintk(VFS, "NFS: trying to rename %pd to %s\n",
-				dentry, silly);
-
-		sdentry = lookup_noperm(&QSTR(silly), dentry->d_parent);
-		/*
-		 * N.B. Better to return EBUSY here ... it could be
-		 * dangerous to delete the file while it's in use.
-		 */
-		if (IS_ERR(sdentry))
-			goto out;
-	} while (d_inode(sdentry) != NULL); /* need negative lookup */
+		goto newname;
+	}
+	/* This name isn't known locally - check on server */
+	old = dir->i_op->lookup(dir, sdentry, 0);
+	d_lookup_done(sdentry);
+	if (old || d_is_positive(sdentry)) {
+		if (!IS_ERR(old))
+			dput(old);
+		dput(sdentry);
+		goto newname;
+	}
 
 	ihold(inode);
 
-- 
2.50.0.107.gf914562f5916.dirty


