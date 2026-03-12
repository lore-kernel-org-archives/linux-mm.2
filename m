Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B6C106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456386B00A9; Thu, 12 Mar 2026 20:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416F66B00AB; Thu, 12 Mar 2026 20:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EEC66B00AC; Thu, 12 Mar 2026 20:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18FE46B00A9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:48:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B46D3C1E87
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:48:08 +0000 (UTC)
X-FDA: 84539203056.10.B8801B9
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id A6B5A8000F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:48:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=mdKzMrUC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=yDEdPqox;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362886;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcLY9NjcITx2BXCNwc1K2QRLwUNNN9sEl0XxFiatrQo=;
	b=b9Jr+1etuAbc05LMp4SNuEeJ1PY172HS5jcCtGYLnMm0giVkfTjImPcOyLESlfacKlbG6H
	6rIk/dNFqXKy9Q2HDbWLwWT/UBBojQdNoo1K0s/49WmlcL71j3mRtgAllumJ1cgs2JUiQl
	jmOCv0YlNl8kYjTr4gc3uy9T5LbraPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362886; a=rsa-sha256;
	cv=none;
	b=8KqBSi/aN4SVaNIs+PmDiJGvQcv3ERjug9pBUXr6D/t2IRemcovBFkROrF8rFAei5W7y70
	H3g/gNHE33ihwFg5LP+VUWlK0BrnYR9+fvR3XSQbDIgXas5Vdx4c7kC2FFqZncUu1YP71u
	W3l8FJYcpwCFEe1J9Mif4UiYxmUk4Qs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=mdKzMrUC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=yDEdPqox;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id ABF701301B7A;
	Thu, 12 Mar 2026 20:48:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 12 Mar 2026 20:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362884;
	 x=1773370084; bh=vcLY9NjcITx2BXCNwc1K2QRLwUNNN9sEl0XxFiatrQo=; b=
	mdKzMrUCmCgev5rjqMYLbCk9/NmPt8l5SN1cuh/XYEGVQSm40ukfPkz/tmPxK/Fw
	C8CU42AUDwoB+BWyvZtfv3qDJQwJMZqdkw0S72eJstmGGGMBhaX3ZHeVREPYyC2V
	fvUXlbJyg6aO5H4oucGa1RsaVgY2d21FE00GybtMYM8I1ew/f4keraC6xDUPB7c+
	5Pn0hGoCJlIddOhvP8sj6pXnoHeVeH2/moOy4KjHgIUwC35SmgVP2TRJhtJl4ARo
	qOU1z9u/0AZz+m+raqJO2irqtfbC4sPHEnz+cJH8kzFrV31gL9Yt6CTvQ0AfNIcZ
	ThO11BMQNTi0fw4x0ZoXng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362884; x=1773370084; bh=v
	cLY9NjcITx2BXCNwc1K2QRLwUNNN9sEl0XxFiatrQo=; b=yDEdPqoxm0mvV/5PV
	Tn/eyzEfPnGUZEUvP0huJ0EgtFB+R+oNg15Lem1KP+cIB5aYs2Z0gfeS39ngIbKd
	sOWHNPGK+ZBSJt6wqiz2s389Zx158JBtkDde4mi+o9LWu2L220htc5Z57Rzo3VCu
	Z90aAHSpgBiPjX8Yb5AmV6q6FQWHuRjLfpHlr9jZjWb14gW0ydd4OI2iRf2hiTOH
	MlOKV6hphPTxCpVXdLyVJMEyK2ZBPk/i/vECEPqsu4qQtVl5VtfC5ZMnfsQ25QJV
	yMMfqpO4OcTvkWzFGghdY4we94eIkCp4DUNmAIn0DHytKFG5IxjjFvYe1zdHOPjm
	yg30A==
X-ME-Sender: <xms:xF6zaULW-NwfZ6qu3iJ9TlEpAEC4uvO82gKtANaBAXYbdtWdN5XVkQ>
    <xme:xF6zaX1A6f3iSCrTwSwJZCB6Tw6LuoRySNxlr4ygzru7LHkCgercK7wD_YNFghaPH
    blQzzGMx3reVFOfFHrMVsy8tYCFIb3P9olIpEKtDle8iuAB>
X-ME-Received: <xmr:xF6zafzQznsFTdMpan5mFbq7xcgpUC_0AeCWzRdATCvsU8ZvZPDZNod_8tQfK5u15bLRkg3QSLtcNDY4l8SUvRBc_s98YD0PPSRUwc6_MXez>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:xF6zae1CmnJpT51rTdmfgm3qsIuMeUX2qKE-vHu6G96-t9rU5tfCfg>
    <xmx:xF6zaQ6Kg0DhF3JyA7Grw7T5XFPqYZr7dC9NGUkrW1os-H7djLtabg>
    <xmx:xF6zaZfjJJxvAh-lv1fnj6C-QCEXixW2zPJzDqHfmxNxsWpWg-scjA>
    <xmx:xF6zacbpasj86nZdirEODaqhQnsR5vPmsB0fhCgedqBfuHkUzp7tIQ>
    <xmx:xF6zaUUkZ-bPNnauXw_6I8hrTSreHohEU96-xm7UFeGDs5FbnFLK1l-1>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:47:50 -0400 (EDT)
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
Subject: [PATCH 20/53] afs: don't unhash/rehash dentries during unlink/rename
Date: Fri, 13 Mar 2026 08:12:07 +1100
Message-ID: <20260312214330.3885211-21-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6B5A8000F
X-Stat-Signature: 4oxajb3iz9uwpusg81u5q44ryqp3g9oc
X-Rspam-User: 
X-HE-Tag: 1773362886-28755
X-HE-Meta: U2FsdGVkX1/CaScowVgvEJu7yvKSwXu3TT+3eIvCR7o5ALnHN7z2D4/UeAL+C4e/JVv1XJXkSp3VY8Z1BPT+Ar2s3XHlY2xi1p2j8OljvHI998bCwShVGrPTDk4kl/Qs/1Hdha+rJs5BBgDHl1+KX6fRrw8hx0qlitj5RcQk/EJbCS7O65yxeAIfJTOSrBMrQLJODihx282rS0eeR9/hzr3yXiPeQ9QtGda3xcqRCQUz0ZL4YYAduv5PWoj5HsVQTKCb4pbgUZ4MhBj2nXppt9ZquzpQ2+3NDQ3NQvSgpEszvubRFN1fjvxxXhuSMztLf1RsH56WmS0j5HwT8ykaBDn6XRjBxI4Nx9A5qCDAtDrEadFLxut+laNCidgiRy1GXpHrtcqyc7RDnMFY4MQwfbeyqNfQdzUZC4k6NXgN0OnbPxUAIyEgb1sWHIx62EkvjtdtyvGKXc7m95Wclh+jCQm7gq/oLDuXWGXVg5G3aYfvH2IGyOHDYjSeghkMfSPq6g/MV733RF0TpVlIuYschlJ7t7gG4M249e6g+yCZXJdsZBnCZu7Q8MwAgB7A04X9uZ+AVGJ2CCx7/m/1yDGYm89kAMfTs1Kw/qG1XHw8aCb4BF8OfG84d+Un+uQP1BVjdGy8SXoom2J8WfsJGunHwI1v70PsI6YTvCCRyuIfWU38cM5+R2ScVEVUT5b2bKMZUbP47UgRqM4/83mjIwCn6N6EXXWsVBGuP5vVZjz30CHSvLSgpVNwCcW/0VwS+ErTjjOmFGyyRCu4DFgYVRj3xSNZ429KnmnxVmtvZFnhYOKq43IYzYxf+hg8K2Avqf6QkmWjQWNR0mSCTyWMbkSBL+1SvX3TF55aS3wAsSY8vXQsGbeZxram9ANz+zHkFHditgY6XpWWLsvD10Ojbp8JWzFthJ51fw8grqRD/DxOV0wkhVDKZVQR6COxw3oAHaUf1cRwe7JRXPaNPgWpzin
 QCFazaMi
 90hCGTwQeLn5YR6R5igt3E2gDa2LAeJCbHviggcBqUZTLXfrw5AjaZHIelAH1Ej+A8nfGDkNdycKzdTedu23sQuVkqVGGqlcCQbmj/vdEYFVkKv5JCOw7NIKxsRuJAAb/eub9XI2c3MMV4+4tAQUFmAIksSiCp9VO0wtBMS/N8WEosst/4Vs2Qk4w5r2kFG8Ln5KmuCCAPwJfCJHEqVY5B8kcse84uZ1n67y9I+FRRLHvzRoLTwC9B8x6yiwNYAvRO6sQgwTkUoMQDkyBFox3ioQoDViTKta4HlhwqVN3pt0NEgTMr3UJFIPT7MoeWBX1axDaxb1NeztoNhBompAogrtAZIDdz6BGJnsVNMcNRCTU2W+UbJJHU6joiXb/aWQIbEByrIIAMQsqMOql/Ev8TnDGWUz3IXXryH+inUZVJchV4mSkENAjFsh2mnQcIOb6UCOqE08AiRpEX2b9U3+lZ870IpE7OQP8jsdx7QogfKgQSCOcTLCvBmuYUlQlY5CjNn8lG8TfyFHRODa3YRH3xxGw+mXGukRkFRfdeoBIzJHx08Y5NjFPpqZM5EILfjtT2wMzxBBcy0a+6Xfot78GZQqnvbBI7SolrYsLc2SWnSUibSAfeQJ/tj/A97SPJoWhJK0d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

afs needs to block lookup of dentries during unlink and rename.
There are two reasons:
1/ If the target is to be removed, not silly-renamed, the subsequent
   opens cannot be allowed as the file won't exist on the server.
2/ If the rename source is being moved between directories a lookup,
   particularly d_revalidate, might change ->d_time asynchronously
   with rename changing ->d_time with possible incorrect results.

afs current unhashes the dentry to force a lookup which will wait on the
directory lock, and rehashes afterwards.  This is incompatible with
proposed changed to directory locking which will require a dentry to
remain hashed throughout rename/unlink/etc operations.

This patch copies a mechanism developed for NFS.  ->d_fsdata which is
currently unused is now set to a non-NULL value when lookups must be
blocked.  d_revalidate checks for this value, and waits for it to become
NULL.

->d_lock is used to ensure d_revalidate never updates ->d_time while
->d_fsdata is set.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/afs/afs.h      |  7 ++++++
 fs/afs/dir.c      | 64 +++++++++++++++++++++++++++++------------------
 fs/afs/internal.h |  5 +---
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/fs/afs/afs.h b/fs/afs/afs.h
index ec3db00bd081..019e77b08458 100644
--- a/fs/afs/afs.h
+++ b/fs/afs/afs.h
@@ -26,6 +26,13 @@ typedef u64			afs_volid_t;
 typedef u64			afs_vnodeid_t;
 typedef u64			afs_dataversion_t;
 
+/* This is stored in ->d_fsdata to stop d_revalidate looking at,
+ * and possibly changing, ->d_time on a dentry which is being moved
+ * between directories, and to block lookup for dentry that is
+ * being removed without silly-rename.
+ */
+#define AFS_FSDATA_BLOCKED ((void*)1)
+
 typedef enum {
 	AFSVL_RWVOL,			/* read/write volume */
 	AFSVL_ROVOL,			/* read-only volume */
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index a0417292314c..9c57614feccf 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1034,6 +1034,10 @@ static int afs_d_revalidate_rcu(struct afs_vnode *dvnode, struct dentry *dentry)
 	if (!afs_check_validity(dvnode))
 		return -ECHILD;
 
+	/* A rename/unlink is pending */
+	if (dentry->d_fsdata)
+		return -ECHILD;
+
 	/* We only need to invalidate a dentry if the server's copy changed
 	 * behind our back.  If we made the change, it's no problem.  Note that
 	 * on a 32-bit system, we only have 32 bits in the dentry to store the
@@ -1069,6 +1073,10 @@ static int afs_d_revalidate(struct inode *parent_dir, const struct qstr *name,
 	if (flags & LOOKUP_RCU)
 		return afs_d_revalidate_rcu(dir, dentry);
 
+	/* Wait for rename/unlink to complete */
+wait_for_rename:
+	wait_var_event(&dentry->d_fsdata, dentry->d_fsdata == NULL);
+
 	if (d_really_is_positive(dentry)) {
 		vnode = AFS_FS_I(d_inode(dentry));
 		_enter("{v={%llx:%llu} n=%pd fl=%lx},",
@@ -1161,7 +1169,13 @@ static int afs_d_revalidate(struct inode *parent_dir, const struct qstr *name,
 	}
 
 out_valid:
+	spin_lock(&dentry->d_lock);
+	if (dentry->d_fsdata) {
+		spin_unlock(&dentry->d_lock);
+		goto wait_for_rename;
+	}
 	dentry->d_time = (unsigned long)dir_version;
+	spin_unlock(&dentry->d_lock);
 out_valid_noupdate:
 	key_put(key);
 	_leave(" = 1 [valid]");
@@ -1536,8 +1550,7 @@ static void afs_unlink_edit_dir(struct afs_operation *op)
 static void afs_unlink_put(struct afs_operation *op)
 {
 	_enter("op=%08x", op->debug_id);
-	if (op->unlink.need_rehash && afs_op_error(op) < 0 && afs_op_error(op) != -ENOENT)
-		d_rehash(op->dentry);
+	store_release_wake_up(&op->dentry->d_fsdata, NULL);
 }
 
 static const struct afs_operation_ops afs_unlink_operation = {
@@ -1591,11 +1604,7 @@ static int afs_unlink(struct inode *dir, struct dentry *dentry)
 		afs_op_set_error(op, afs_sillyrename(dvnode, vnode, dentry, op->key));
 		goto error;
 	}
-	if (!d_unhashed(dentry)) {
-		/* Prevent a race with RCU lookup. */
-		__d_drop(dentry);
-		op->unlink.need_rehash = true;
-	}
+	dentry->d_fsdata = AFS_FSDATA_BLOCKED;
 	spin_unlock(&dentry->d_lock);
 
 	op->file[1].vnode = vnode;
@@ -1885,9 +1894,10 @@ static void afs_rename_edit_dir(struct afs_operation *op)
 
 	_enter("op=%08x", op->debug_id);
 
-	if (op->rename.rehash) {
-		d_rehash(op->rename.rehash);
-		op->rename.rehash = NULL;
+	if (op->rename.unblock) {
+		/* Rename has finished, so unlocks lookups to target */
+		store_release_wake_up(&op->rename.unblock->d_fsdata, NULL);
+		op->rename.unblock = NULL;
 	}
 
 	fscache_begin_write_operation(&orig_cres, afs_vnode_cache(orig_dvnode));
@@ -1970,6 +1980,9 @@ static void afs_rename_exchange_edit_dir(struct afs_operation *op)
 
 		d_exchange(old_dentry, new_dentry);
 		up_write(&orig_dvnode->validate_lock);
+	/* dentry has been moved, so d_validate can safely proceed */
+	store_release_wake_up(&old_dentry->d_fsdata, NULL);
+
 	} else {
 		down_write(&orig_dvnode->validate_lock);
 		if (test_bit(AFS_VNODE_DIR_VALID, &orig_dvnode->flags) &&
@@ -2009,11 +2022,10 @@ static void afs_rename_exchange_edit_dir(struct afs_operation *op)
 static void afs_rename_put(struct afs_operation *op)
 {
 	_enter("op=%08x", op->debug_id);
-	if (op->rename.rehash)
-		d_rehash(op->rename.rehash);
+	if (op->rename.unblock)
+		store_release_wake_up(&op->rename.unblock->d_fsdata, NULL);
+	store_release_wake_up(&op->dentry->d_fsdata, NULL);
 	dput(op->rename.tmp);
-	if (afs_op_error(op))
-		d_rehash(op->dentry);
 }
 
 static const struct afs_operation_ops afs_rename_operation = {
@@ -2121,7 +2133,6 @@ static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		op->ops		= &afs_rename_noreplace_operation;
 	} else if (flags & RENAME_EXCHANGE) {
 		op->ops		= &afs_rename_exchange_operation;
-		d_drop(new_dentry);
 	} else {
 		/* If we might displace the target, we might need to do silly
 		 * rename.
@@ -2135,14 +2146,12 @@ static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		 */
 		if (d_is_positive(new_dentry) && !d_is_dir(new_dentry)) {
 			/* To prevent any new references to the target during
-			 * the rename, we unhash the dentry in advance.
+			 * the rename, we set d_fsdata which afs_d_revalidate will wait for.
+			 * d_lock ensures d_count() and ->d_fsdata are consistent.
 			 */
-			if (!d_unhashed(new_dentry)) {
-				d_drop(new_dentry);
-				op->rename.rehash = new_dentry;
-			}
-
+			spin_lock(&new_dentry->d_lock);
 			if (d_count(new_dentry) > 2) {
+				spin_unlock(&new_dentry->d_lock);
 				/* copy the target dentry's name */
 				op->rename.tmp = d_alloc(new_dentry->d_parent,
 							 &new_dentry->d_name);
@@ -2160,8 +2169,12 @@ static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 				}
 
 				op->dentry_2 = op->rename.tmp;
-				op->rename.rehash = NULL;
 				op->rename.new_negative = true;
+			} else {
+				/* Block any lookups to target until the rename completes */
+				new_dentry->d_fsdata = AFS_FSDATA_BLOCKED;
+				op->rename.unblock = new_dentry;
+				spin_unlock(&new_dentry->d_lock);
 			}
 		}
 	}
@@ -2172,10 +2185,11 @@ static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	 * d_revalidate may see old_dentry between the op having taken place
 	 * and the version being updated.
 	 *
-	 * So drop the old_dentry for now to make other threads go through
-	 * lookup instead - which we hold a lock against.
+	 * So block revalidate on the old_dentry until the rename completes.
 	 */
-	d_drop(old_dentry);
+	spin_lock(&old_dentry->d_lock);
+	old_dentry->d_fsdata = AFS_FSDATA_BLOCKED;
+	spin_unlock(&old_dentry->d_lock);
 
 	ret = afs_do_sync_operation(op);
 	if (ret == -ENOTSUPP)
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 106a7fe06b56..f2898ce9c0e6 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -891,10 +891,7 @@ struct afs_operation {
 			const char *symlink;
 		} create;
 		struct {
-			bool	need_rehash;
-		} unlink;
-		struct {
-			struct dentry	*rehash;
+			struct dentry	*unblock;
 			struct dentry	*tmp;
 			unsigned int	rename_flags;
 			bool		new_negative;
-- 
2.50.0.107.gf914562f5916.dirty


