Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B10106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC56A6B0093; Thu, 12 Mar 2026 17:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86446B0098; Thu, 12 Mar 2026 17:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EB56B0099; Thu, 12 Mar 2026 17:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85BE36B0093
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:46:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56C98140455
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:46:48 +0000 (UTC)
X-FDA: 84538746096.03.57C8864
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3FCC914000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:46:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=SerCWqLI;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="bz1e/Oln";
	spf=pass (imf09.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352006;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WJg8BesAO2r3vZCyn8Qj6EvQOGiM+109I5YGqS1b9I=;
	b=22nEhIWU6JEE5Mygh3b5QvSE9gwsAbVWDskIT9UXvZGfHHPgtiA5JA2Jrq3yix3zKlLKQR
	3c8lvJzrkVg+7iUgkWBGFCRPm650txHpEr4mOaEUOkF41WAv+7ozuovyTzumTY1VEogQO1
	Vap4vRAxyH4FgUgDdRGx0D1gM5iLHWU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=SerCWqLI;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="bz1e/Oln";
	spf=pass (imf09.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352006; a=rsa-sha256;
	cv=none;
	b=uo09qT1ZkMw33tTNqyUWzShohTPGHszJMwzs7w4kysGx8cuqDfV0VPw63FSBrLvvVS7gUP
	2daGzdx6tHAavNIoJCYFpXoGH5oemTJYlkKGw+I8I+yWxxYVRKLYOvHTdbobL3ecv6O+9O
	WjQ3taAkjBxdsitJ1V2zNKeZZWVZazE=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 293E41300F6C;
	Thu, 12 Mar 2026 17:46:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 12 Mar 2026 17:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352004;
	 x=1773359204; bh=4WJg8BesAO2r3vZCyn8Qj6EvQOGiM+109I5YGqS1b9I=; b=
	SerCWqLIgdWRLB6BFLBdqn2eI+vI5/t4G8+IU7QLeE8wYOrdHBw5HU694Zz4gf3W
	M6tCB5+ksA0SG/bjn4x5w9+oyXipICRWoxM0ehBTavuD1xt02fz2Jdhcbs1AqGB1
	xcXbISL1jLJEABmTYnW/lMs2oqr2ta/3BNNWvrocKOn9gK+6mf47WNMrpBl592kJ
	FzscqO6u6qq4PnC9NiqFVwTPOrfVhOWBGK14bw6NESRrWKqV7Dl4Dco4/LE+hFbo
	HixqPSoOkkx2VI5A/uT1KJd7g0Oc5t/uavVuNubv5KUOz1eH1PyEG3UIsGNvyorv
	2b/dfxvPTHpC0RdBiGo00g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352004; x=1773359204; bh=4
	WJg8BesAO2r3vZCyn8Qj6EvQOGiM+109I5YGqS1b9I=; b=bz1e/OlnsMyj6akRb
	IxeYS9L2jvkQo8W89blCf+xp6yfqMO3SMeerllq7Ios+b+V5zIhfXemg6fgMmsA7
	7ncn1BKA1nPjv9DXPEyTjhjjPbyzrQyvwa8Z4FIdur7w0pFW/P7SpKZQC1bNqVjG
	SQJ0LVU3ABw9muOjKVl8UHKkptWCo66BsQtjh8/a3tjtMpHJh3m3w6A/vrLCKGHr
	Jdm/2cEgZFqV81SboGMySRQNjqSXtpMWuMHpMv+gnZ+/tGg6J8nD3annX4j4KTaR
	/8dnRk1YiNlPOc2j5fyVdgnPf2yKQJ48BLw6M2c1qifsRF7kXNb3OXfFmGkRd5M/
	CdYig==
X-ME-Sender: <xms:QzSzae-_RUJ_LKPLY7mTewAt03A9YptxJHuSuQh6s8V5C963Umhc5g>
    <xme:QzSzaSYtFquQUsIXw34mTZMPK68O3unTDICtNAsOTtaTjgJBV9ne7dzdLLwm4iHMD
    nAag40mLhUJDzkqTeSs1EbAWXE_Iv3YEgye_MqkYzeH_0JLyg>
X-ME-Received: <xmr:QzSzafFqW05biJiriNkrPeJzdA72U4phWYPTkM_iqNiw4h1VTOa1Y7AJabIMIMN9QcRiToQNYKh0zkj3B26JHpQC8Pn8EAq1lCNUKFiRSzAG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:QzSzaT7upc63WACrikUPcBWBCgsP_sRT-FWHYJea2_6zxpV1hC2ESA>
    <xmx:QzSzaYtBEhpWJVTEZrCewe5RuYo_PChA-ijEHPGqS2typBwFVUlitQ>
    <xmx:QzSzadBR_wPJIKcv4DNN4povDMSTO_zB-Bfw0w7J21L3Uqn7KDQY4w>
    <xmx:QzSzaQsO_0k-M4QIiH9Pfs2OdTOZ-CXVfoXnRl2Bt2Pbkhmo6mzdxQ>
    <xmx:RDSzaQgf2GkDuAkTHdg5V2lbXPP1GGvaWrpMh7oNhgYYYnYWDVESZTtS>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:46:30 -0400 (EDT)
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
Subject: [PATCH 08/53] VFS/xfs: drop parent lock across d_alloc_parallel() in d_add_ci()
Date: Fri, 13 Mar 2026 08:11:55 +1100
Message-ID: <20260312214330.3885211-9-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3FCC914000F
X-Rspamd-Server: rspam07
X-Stat-Signature: ynpyhak1w4rjx6ds8keh3m4htjdtmidu
X-Rspam-User: 
X-HE-Tag: 1773352006-547093
X-HE-Meta: U2FsdGVkX1+Lm6wkUvpX0hoWRdp/a1tIhZRfDzxtaxDxcQUuAJDYTELsNyd8r7RpPQ2A8GmcqnmMxMNt4GfqykIME8XgH3lKz4jT8eP1lQAUdTxmMn2V7Br66TEDtfayV4PyBrAtq2jwNNuF2BYIuwiwZAscHVideUjCSl0ZGWQPMA7jP2R+B2qjU2Ft+BMaTR6s/tR717rbqqQwMhlyDVdeP5d6l5/WJ6au9QVltWTnSw26FzPE7HVJwqye9s69B0+iOFdWEwreUbmPw4k1Uw0CkOVXak8WPfTyDxDOQt7JHyyEUpZNNPV6NPUnG94h0SdoKHtFEyAgtYwPIdzes700ciy9zHTMyN+oBqHiA/QwXk8lZGyxZNyl4rrEKFmDJopHOQvkZ3nJnEePN7azO9SDu7LKUJVZ8HCDQ7WgZe9WHw8jt2mXZx7U94z/uEZVK3LFCaZQKcDFCRWyiJ9qY4EKlJeGV2gpgwxLGE2l+Cx5WMizUnofW/cZFJlWYBQ/evGwaS3A1d+upHf//Zj+Da+znnGlTxufiYBG+rtnr4Rc+nO5J8pnxL+razdwp2Ee+X3IZpbjKfYJzXI/BmUxfuEllqwMzgq1qGOi98J2LwnQr+wVD/9TAtEK81h8Tk8nLTPP9cm/rgksanFNY8mep1+HO7SKHAoFZZfqJTD5BQ0YdIaIwxqwPP/AtH2TUAE1u6rHhYY2eLAl33ETpAIRJtZcXuyeCfkszVJjwC8fzF5XVV5LCty6T7c5zZqWC3WuyaosKWlLzYEOiXf98OeG9sRRR+vHv9RWZG40zHnenOHF7K/SqHAA5XAtCDcnOr7lDe/vsqQPS/oI0oim4ZTPDLegU7OR7aWvzcjQVgmnOZiOHIZKU4XPMymFqkkijKGfSvm8YeY2yKi7B4ss7vQLaicgjW5Eop61UGYdMeABAtBJwuoX8ivA2hDVOFPqSNJfPDDG22n4IfQ6UNgjkfr
 PX3OXxT9
 YWn3UMvc9odowg/R7aIK8oBkf/7SQ65rxJJ5bI+hGE6ylfGPfoQiBOuiSpPJYefEVbpavUaGyy6JyslgiA8q3uuNtERbJt1P6J2qtZbCM7JWmfKVWF7d4mzZU4cIuJYvHPpEtZyV5if0oXVQ0XShlepHp9CDchYgmm7nOsV5htGv6em/kOx7KGb1ei58zvssYZ1uUu1+qbVdNbEauuXdt5XPK8Tko1BeL77sa11xyNsl7Q490kMfaBRo7zeqdh8HgRrMitKoCW+tReTFh9+nczBD1xo7zYCiIdOjQ6pjdD06lT7WXnLvkt+1t/hqO7TeGUyn5OmVx8yMae0HA4RRX0FkHUlkuYSM4/OfjS3NhZs+c5/kqowLKbO8QNP20YBut2HQAtfipKLCmtHU6uUFWQtQMzkxJEbxntHoGniQKW0qM1WXow0tZj/k+vlgjC8TmdBe/EfRAbyS4NngfIUkb8xa6QtAO9G+dju2mPA7xjpMQ0TpQllLuopeG8o3oQ9DCGeqCOf5zM3n2YIS/2SyGn/NIE7klmzb207Zol7xPKXXopPCR1JVUKJ1zxYJNDe91PF1L05tmq2qRDcIKTSi1a03tOB1yu6Mbak3BYtCuyBrHaLMft0qvTSyl4AUp3QJRHL5HsnDhPeYU3A6JqOtQu3hWo6UEf15orohzCeK3WlY0HtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

A proposed change will invert the lock ordering between
d_alloc_parallel() and inode_lock() on the parent.
When that happens it will not be safe to call d_alloc_parallel() while
holding the parent lock - even shared.

We don't need to keep the parent lock held when d_add_ci() is run - the
VFS doesn't need it as dentry is exclusively held due to
DCACHE_PAR_LOOKUP and the filesystem has finished its work.

So drop and reclaim the lock (shared or exclusive as determined by
LOOKUP_SHARED) to avoid future deadlock.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/dcache.c            | 18 +++++++++++++++++-
 fs/xfs/xfs_iops.c      |  3 ++-
 include/linux/dcache.h |  3 ++-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index c12319097d6e..a1219b446b74 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2225,6 +2225,7 @@ EXPORT_SYMBOL(d_obtain_root);
  * @dentry: the negative dentry that was passed to the parent's lookup func
  * @inode:  the inode case-insensitive lookup has found
  * @name:   the case-exact name to be associated with the returned dentry
+ * @bool:   %true if lookup was performed with LOOKUP_SHARED
  *
  * This is to avoid filling the dcache with case-insensitive names to the
  * same inode, only the actual correct case is stored in the dcache for
@@ -2237,7 +2238,7 @@ EXPORT_SYMBOL(d_obtain_root);
  * the exact case, and return the spliced entry.
  */
 struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
-			struct qstr *name)
+			struct qstr *name, bool shared)
 {
 	struct dentry *found, *res;
 
@@ -2250,6 +2251,17 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 		iput(inode);
 		return found;
 	}
+	/*
+	 * We are holding parent lock and so don't want to wait for a
+	 * d_in_lookup() dentry.  We can safely drop the parent lock and
+	 * reclaim it as we have exclusive access to dentry as it is
+	 * d_in_lookup() (so ->d_parent is stable) and we are near the
+	 * end ->lookup() and will shortly drop the lock anyway.
+	 */
+	if (shared)
+		inode_unlock_shared(d_inode(dentry->d_parent));
+	else
+		inode_unlock(d_inode(dentry->d_parent));
 	if (d_in_lookup(dentry)) {
 		found = d_alloc_parallel(dentry->d_parent, name);
 		if (IS_ERR(found) || !d_in_lookup(found)) {
@@ -2263,6 +2275,10 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 			return ERR_PTR(-ENOMEM);
 		}
 	}
+	if (shared)
+		inode_lock_shared(d_inode(dentry->d_parent));
+	else
+		inode_lock_nested(d_inode(dentry->d_parent), I_MUTEX_PARENT);
 	res = d_splice_alias(inode, found);
 	if (res) {
 		d_lookup_done(found);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 208543e57eda..ec19d3ec7cf0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -35,6 +35,7 @@
 #include <linux/security.h>
 #include <linux/iversion.h>
 #include <linux/fiemap.h>
+#include <linux/namei.h> // for LOOKUP_SHARED
 
 /*
  * Directories have different lock order w.r.t. mmap_lock compared to regular
@@ -369,7 +370,7 @@ xfs_vn_ci_lookup(
 	/* else case-insensitive match... */
 	dname.name = ci_name.name;
 	dname.len = ci_name.len;
-	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
+	dentry = d_add_ci(dentry, VFS_I(ip), &dname, !!(flags & LOOKUP_SHARED));
 	kfree(ci_name.name);
 	return dentry;
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 2a3ebd368ed9..a97eb151d9db 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -251,7 +251,8 @@ struct dentry *d_duplicate(struct dentry *dentry);
 /* weird procfs mess; *NOT* exported */
 extern struct dentry * d_splice_alias_ops(struct inode *, struct dentry *,
 					  const struct dentry_operations *);
-extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
+extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *,
+				bool);
 extern bool d_same_name(const struct dentry *dentry, const struct dentry *parent,
 			const struct qstr *name);
 extern struct dentry *d_find_any_alias(struct inode *inode);
-- 
2.50.0.107.gf914562f5916.dirty


