Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325CE106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9676E6B0088; Thu, 12 Mar 2026 20:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9121D6B0089; Thu, 12 Mar 2026 20:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E2F6B008A; Thu, 12 Mar 2026 20:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2F06B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:43:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09ECA1A04C3
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:43:33 +0000 (UTC)
X-FDA: 84539191506.21.DFF15FE
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00596C0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:43:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=WX7c3DKP;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TKoMfHHk;
	spf=pass (imf28.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362611;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aHffWYVzxlbvh037JlVhR8ERE/IxGWBZRv5qHj7bJk=;
	b=bxDrDdDCCw57WrAneOSvwD4qEtHX+FPSsAyRWqs2fwtHPc1YlcyWITDS+r++fb7xBEDVRH
	V7oDyDNVRprtac7vjAuHDmrQLdhOqiNxpKb0d8v0Ew8j+Hn7IA7PYGlYEu9IKoARUgdOb1
	bj1Ow/DbcSBa8tlUYtm9Oejg1ldBoC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362611; a=rsa-sha256;
	cv=none;
	b=ynSXQ0SjjZW7xX5Fnl6iAN2uQFaNkWTxDHju1bUO4TtwB3UZOKp0B1+pnTDiqNVsIS1mjx
	lxTc64UZipy93LB9+6z6RpthyammEz9xQ4elgbBQynA4jkIUuztxe3109R6hALAkm5D+8w
	5mvYfacFYKVAgQByhSf7tygIlElOvUs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=WX7c3DKP;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TKoMfHHk;
	spf=pass (imf28.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id DDA261301B24;
	Thu, 12 Mar 2026 20:43:28 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 20:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362608;
	 x=1773369808; bh=8aHffWYVzxlbvh037JlVhR8ERE/IxGWBZRv5qHj7bJk=; b=
	WX7c3DKPx+tVVhFVjUW8//0VWvS4las6XMedU6aTYpr242woaOIcqjdZZVJ4yVnC
	P88WJrijdCqh71ZQjfLl+xhjGoQMg/F8wZ7GNOHUOS+3PK7l64Z9RcJfHzu3EJx+
	9kiGTP3jc4KeZly7RqBISMFoHeUWIhyiLSOgatDGNqU+ils1tsCxI9p7zB3O39nq
	cROINYPyREvgD1SKVCYqH32NWAcedBFxE+Wuyiva088VcFlPPudW1EKncv3fsuaA
	BShtlQMTfihkHb/wYJyVBjIX251wX3ueq3TmnmoWiRxo/NGW66kYiWp2sylnh++s
	bFkFlicATpGbeU9QOA95Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362608; x=1773369808; bh=8
	aHffWYVzxlbvh037JlVhR8ERE/IxGWBZRv5qHj7bJk=; b=TKoMfHHkIQcef4oL9
	WCvsrpW+mTxjtA3eu9J9hQdlSACakLolIy62RydRB3PnAitR2M2UBSxOg6u41jAQ
	orR8E5pfwsu4X5hri4xNT6JK2donC1MWsL/u0WbE7rRdrQQpndWHCmOLcrn85w5q
	SI+HqYSuDNwoKNY/0GBR6Pi4KU3xLzz6Q+JVFC40HVtSP3UyiF03OUmeTa8dDPt6
	DcuHCt92Cd2YJ7SYU+vMYMh3KnIdv8pfwE/90UpO7I3xohC3Jy56VaPbigBQF9ob
	6qBILVQxLXuHVd9mMl4KuNfCKXc+3cO+4irgJurxJUSavrvBRuwB40RYu4N6E0i6
	RGNjg==
X-ME-Sender: <xms:sF2zafwU5O7EET5F6K-aQw7jkWz_ixnHMn4V0xMGQaiLTVepCp0tRw>
    <xme:sF2zae02wD0x5bh-9IIDWH0SxbeC0VpY18ApLPS8IXDYBqpRjLeeJzPqp01_9lfY7
    8Jv0uyAVrBjp1-Aj-tSe7O8R_xxkSMDF1paMjxYStXEtm2zyrM>
X-ME-Received: <xmr:sF2zaQ5u5MiWf_c7DuHg5fbpvIKQer-qUWUomzqvDd3cFUmdR7Z_2wQrinuTZ7IkyU0CpPNKTH5Q0vb0CvuRdpmuwc7ZgXvaIhhtyMu5Yb9C>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:sF2zaZf3Per3LZEdp2WRei0ix5aAERTBM0In42j2nkjtAIqVFKBUPA>
    <xmx:sF2zacZtEAEXc0iiBzy42igNRtM_Pt7PbdtzWmXxrPKB5Q8Y4_JQgw>
    <xmx:sF2zaTF4c7hbyoPU2SzpbJB5q6gWv9QUr2hNyV-ZxscAn7v4SDrPRA>
    <xmx:sF2zad0qxF5Ms1PY3l5bG_FSgiwxJyCVizNYRzREyDx2EYRsA7FshQ>
    <xmx:sF2zacNj0BpnAMzEYFy9m-DUQPdAneviKyB1uWslBDL8eNGoPKzEt0nM>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:43:15 -0400 (EDT)
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
Subject: [PATCH 36/53] cephfs: remove d_alloc from CEPH_MDS_OP_LOOKUPNAME handling in ceph_fill_trace()
Date: Fri, 13 Mar 2026 08:12:23 +1100
Message-ID: <20260312214330.3885211-37-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00596C0005
X-Stat-Signature: ou15wfexap4teha4uj9k4987mdtna469
X-HE-Tag: 1773362610-581865
X-HE-Meta: U2FsdGVkX1/CoyoaprBj/B/mrFirqGsIy/3ESMeUin7OgnbhLdzMTUlEGLa6fSG47D1tySoMohdIBM88axXkucPaHBoP2DLuelwvnJ7vX3unP2R2TzmJWTjBRdIvueUs7c33JSlPOZI2GFih3Vj+gUGybVlf8tQ+DGx89nczeTDkv7Rz82mJKHZjTTxCD0s1ynDipt6kUFYilzOELcDGlScMj7NgVelqHF5vzpSasLpRwNZ+yYpToNKG9Zz+gLUroDsxhULqDX2Mt+vkxiOFD8546NZy5Mx1w84H2VAZQZSbo9LmaMeMrest4KGW6PvmU4Ov/w9JQpU2vWixeA4RpYQ//AsZAhSXYLvZB0NLFudP3C+9TJ9jPQEbBbWFh3pEA2gJk7YJwqS2juQPmbdLCY+szU+NJmKHBpgrqgfLXqC9ghC7ixZYHE2kTm7OFmVu3MZcT6lBhF7GCyFyuHqssGZTDpkT5wmSUdSbL1z3dKBZBXSmeBu0dWjPGlqsJa7Guept78IeYbOn8H/jdZ89yidNknkZjQFXSfQaWrDYEwOmbk0imntYh9omfRMBbFPpuOm9EpsRL+xVoFcmNmzQ1dm/D0O2gZownYl56kD1mcleh6sRRFnuPHd/i0m3GIFMlwVN/xx3UKa3B2kkQWIByWaV/g0oDmxkM2do6JFpIh1NLnk0uYBjyVqzuRYFV4lk4JSLyd6IDLV1dWs3dCEECEMf35Kl4+KyCu0Hv09u8/CxYR6cfTGcMyrRAhADqlTMTRKnFaL/aPxYBGYOuPeKuV9SpEEeOR9lbvQGhvfKIlcKZrSiZ/+johGWHoGcqMM764XnMyM8K+cy+grL3sT4FANxUQxExXO9F2ezAPaRnF1c9hALq2gx9xTjabVSqphmjmRcWwMJQ/fsRUXZWyWVlmOIusOouzpPqzY1HWPkVEdNu6g/T5+dhZvGeqFOmDGKYSUf2kFWdzwY9yRSqfq
 aQCXg6cZ
 5M+VWLpgflEIUY0gTb/rR0bundxzZjCDk3tKeoqM6DIlRPNPUY6lVjo8Z+Q+/G1Sp55wZRiKoKno0YQpdvOZV8btADR4oqM2z5cDBzrF8pbIJpNHDD4ygSTJ2IHZ9fcFCqXg13WCb/VHPZQbOoquIourwv5Rq4STDGrD/q42sg5qS0xe5/GsxuTCu6kkuBd/JZT1PSAQn9FNcdftdtERGq1wJaaukagzQ3E+JOniIoA6m9pHFSCFyTojVUQD6mmdQOAtHapAYAl3p/yA6AHSK5qu67IMEkKrnxy6teTZQOy9VVOaUMjbQWD2bOAYsXKIjyO2tzWFtkDNdPVotu3184zonX+yTkLEtxklrgxYM8tMoCn6tSPgCi7A6o7t8PeGv+HGbRvsrsCT/I30ShqHe2b4xlIOeJ3ab1iZmtHkx03D5IKkBdBshEKqyqJg+AEPPKoylBQjxfC5SWRiVKtt/e9rq/BdrZD3dG4f3qo4BbKfTLfEUmx//KabjA0BlsJhBWFTss5DeKO79YOwXeMyzt0z+5/bKw5fRyV5W0MRo1ykNASUJW7WekYTLXLXrcuuE2V37IGX0KvT3m3kS0oCh0LffnuR5STykFeYtrnr0LBoVguIq7X7KqIsA0yvV6+ITaNVzCx1P+fA99UC7FiwChENtORuCeKwSpsneXEooVlt74kc6fUvn4+pCcszj0svRmiwhbh24shdPIFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

When performing a get_name export_operation, ceph sends a LOOKUPNAME op
to the server.  When it gets a reply it tries to look up the name
locally and if the name exists in the dcache with the wrong inode, it
discards the result and tries again.

If it doesn't find the name in the dcache it will allocate a new dentry
and never make any use of it.  The dentry is never instantiated and is
assigned to ->r_dentry which is then freed by post-op cleanup.

As this is a waste, and as there is a plan to remove d_alloc(), this
code is discarded.

Also try_lookup_noperm() is used in place of full_name_hash() and
d_lookup(), and QSTR_LEN() is used to initialise dname.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ceph/inode.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 59f9f6948bb2..0982fbda2a82 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -15,6 +15,7 @@
 #include <linux/sort.h>
 #include <linux/iversion.h>
 #include <linux/fscrypt.h>
+#include <linux/namei.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -1623,33 +1624,17 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				ceph_fname_free_buffer(parent_dir, &oname);
 				goto done;
 			}
-			dname.name = oname.name;
-			dname.len = oname.len;
-			dname.hash = full_name_hash(parent, dname.name, dname.len);
+			dname = QSTR_LEN(oname.name, oname.len);
 			tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
 			tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
 retry_lookup:
-			dn = d_lookup(parent, &dname);
+			dn = try_lookup_noperm(&dname, parent);
 			doutc(cl, "d_lookup on parent=%p name=%.*s got %p\n",
 			      parent, dname.len, dname.name, dn);
-
-			if (!dn) {
-				dn = d_alloc(parent, &dname);
-				doutc(cl, "d_alloc %p '%.*s' = %p\n", parent,
-				      dname.len, dname.name, dn);
-				if (!dn) {
-					dput(parent);
-					ceph_fname_free_buffer(parent_dir, &oname);
-					err = -ENOMEM;
-					goto done;
-				}
-				if (is_nokey) {
-					spin_lock(&dn->d_lock);
-					dn->d_flags |= DCACHE_NOKEY_NAME;
-					spin_unlock(&dn->d_lock);
-				}
-				err = 0;
-			} else if (d_really_is_positive(dn) &&
+			if (IS_ERR(dn))
+				/* should be impossible */
+				dn = NULL;
+			if (dn && d_really_is_positive(dn) &&
 				   (ceph_ino(d_inode(dn)) != tvino.ino ||
 				    ceph_snap(d_inode(dn)) != tvino.snap)) {
 				doutc(cl, " dn %p points to wrong inode %p\n",
-- 
2.50.0.107.gf914562f5916.dirty


