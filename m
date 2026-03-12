Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF59106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42356B0005; Thu, 12 Mar 2026 20:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A246B0088; Thu, 12 Mar 2026 20:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A268A6B0089; Thu, 12 Mar 2026 20:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8636B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:43:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39C96C1DCD
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:43:16 +0000 (UTC)
X-FDA: 84539190792.13.0439AB5
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14685A000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:43:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="evZBO/FT";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=tlm7pJXg;
	spf=pass (imf25.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362594;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtJ/saZCLiCxFDNQljniHYoFSU4uzdwtWsgXO8zNDIk=;
	b=DTrRO7lxnmo1HhmjTBYH88J3N7CvJ8XxOL336QF643onK3JfJO4k4XyR/C+ssFAv1TxBhI
	SoJhEOxbjIt5LY0XXtVoBNpmBsFci4SNWlzF9MEUkj8JRqa33vtyrT52PMTrPmJYOoz4uF
	8WrXRHZBnIWzJzaYfHhV2ZW3o5mQqTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362594; a=rsa-sha256;
	cv=none;
	b=5XkH5M9DZ1gC7+facuXiT3uOPX2QDrKssA4OpGGJryS/tPcjh31gw6GCzYeWH0C/lnCSF8
	RYu4uA9PrLKB3vnKNo34VGeKTXuvmU6kjqeB1tMP+3m2dI9H3RYEDySU/zGucsRdvCQazX
	lI6VXkxTD6LKfxsbc79ElK9wJ8jLtAY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="evZBO/FT";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=tlm7pJXg;
	spf=pass (imf25.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 1863C1301B1D;
	Thu, 12 Mar 2026 20:43:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 20:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362590;
	 x=1773369790; bh=mtJ/saZCLiCxFDNQljniHYoFSU4uzdwtWsgXO8zNDIk=; b=
	evZBO/FT5uLkrmbp/p/bKHGn86ivpuWIB8uwzomHLGU6kH6lhmmlCRwiDJoWV39q
	TXhehd3v184kz2tKDZFnYt3nMYpGYs0FHIDP5P1WpT7DuL/s4rQw/xsDTsgE9QLg
	/164043xlTxtGbkRkgPLxopa5nRZXLGdKExiyrVeEWQB7Z6SjppifuMa+H+nAnt/
	Y9UIllgVcpdMC3ryQir69hasMs4sAzed4op96lB/0i6WUn6Uhf0fVcGFEXiSJozk
	InAA9BqTgm3htPeeddGMpXgGFTZior38m4S57df0DQ4nN26Wz6Bnup7omFSZuA/V
	bXDsxk1oRwy+oBWG8yzDjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362590; x=1773369790; bh=m
	tJ/saZCLiCxFDNQljniHYoFSU4uzdwtWsgXO8zNDIk=; b=tlm7pJXgvMRnwrzqw
	361ob53tdiymOgQgABOTedImHhfzfyXrgBfCei5K7ic4kOntEU7/s+f5sGh5Urct
	yi6RhxZa9AKNdjteFK4EVVHFzPhf0rBHY7+D36NQKzOYqyDZTXwjWo75g7RIoUOt
	+1Y24Dtef108V7gC/hPAOKuoKHxLQb6ez/GO9OthDEETcJ7ke8mp144qJcMLu188
	7QoX5KdxhtTAeNLGhB9EFu+7bHr1B8GbxO8xT5UwDkDbvUE6Kv/LXlywzoVIfx8H
	5/sPhbm9H87cFjM4xoYFeNlJ51RwpxBUAAY7/b3qCojyfoXALXgP5SiZxeMBLz3U
	TvcfA==
X-ME-Sender: <xms:nV2zaf-NnCpb3HI-jpnIeaMEX78RNQjZehsLTDQASvyJLmVZkQdgfg>
    <xme:nV2zafZJ7mvrmpO-gcToxfMKwcMc5Q_rFX10NZl8_LR-rje39CCVNCfpHij589i8x
    F8Ot_R8pRFhAt1hFRsQ_wy6CVw51XS3cVTIlX1zcPm_ZZvJPw>
X-ME-Received: <xmr:nV2zaYGPAoTTcGmEks6mZrihRO7DEzSJQTLVP_2o9xNxWYeVqZvQjDfXGA3yqw1n6XZ5fGvyGTUhxFiRqIqqc-pGG5s2HTIOOgdySI1Z0kbM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:nV2zaY7faWbXQHLIpd0SYafA-iMAWHAFfnW2ShinVhLAUGrEfx07iA>
    <xmx:nV2zaZvgDZlHyejqPasp60C6LyxeD80AFwab7f1aj4miUyVx-K4aCA>
    <xmx:nV2zaaBryqgkdrCkCXjeDM2uqFf7SAUNres7R_12QlIkQ3RduF7YvQ>
    <xmx:nV2zaZvraRlGVqoe9uMDqj0rk0wlwP-X2N2IrOVEi5yN04lSuh4s-Q>
    <xmx:nl2zadJN25sW9Jik8_kJDmuvga-QlrXGx2xisz4qYzgk4C1wnxRkBwfU>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:42:56 -0400 (EDT)
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
Subject: [PATCH 37/53] cephfs: Use d_alloc_noblock() in ceph_readdir_prepopulate()
Date: Fri, 13 Mar 2026 08:12:24 +1100
Message-ID: <20260312214330.3885211-38-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9mnpwaymtpmu7pg4y79pm8mcpzqjc7dt
X-Rspamd-Queue-Id: 14685A000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773362593-569968
X-HE-Meta: U2FsdGVkX1/lJcCbYFGyjeat7h12fEnMif5bEHmfDxqfS3o8diTrJvWhqP9L2cYfrIug3tHwJry3XPWrXN+agwnY2PtNSztnffuLKu8Q2VZebX+BlXmiRKGoCCw4EP/CLFN1kEZuvcjSEPADFSyoNjkKxadJU7dF/DyRph3RpYuoOBHkDbrkD0qHTrVqzjih7elHV8Cr/UMJPoRnq+IZtB2ApZqG/rvNvpVPTjRjTZ7W2GTzAAnZjV4Ino/Lmcn0WECaT0uNpXZ5JktMbLQ/4p+zGvBLMOSlqu1gtSLARWtoEn0Rz55LbRz1avuK4J3o23LnDLghkWDOvQgE3llWwENnhrHPTwafzLoVvmo1P/A6hr9IG1ZTbTCTcubYmMaNGXkHH24rKJuOydcZQrMFUvNNLjCZhZ6nbaGYdc7F3At50cA+bS0xiyIiEwhbaV9wF3zczaVVUIGtVBCfJycZcJA4dZuuc6Qgnh1htZCppXFfKoQyq+g6kcItb51+6ppAQhq99HvR56IJ1o56y/nLdHADanLXnfY2jH/CfxNckC3QrIv+br5WvTkSTkwORtbibclndNUeihDJnRqTlGScX0+WsIwQUtwpH2ErTpMWLkbDUbEYgeHix6d3CetIPZ7xlGf5mpZSmIifQsQKCDWXzKiSl2bUoBoYRgYV+cFryNw+mX4TGtN+wu0PbexP4OPtIKxsIBC6NQ/Ar0Xj2iw3G8gEXAWvDkcd3Sdy5Uu1RfvGXoGnooD/AboFXmQf7MgFWXWSWvWN8ggvrDLUUTGhG1HlpqQFvDCyRz2spqmz5ZN6P7tpT4sjHGHY3EAee9YrMDsKcwZcAhefnHL0ebT9W4wqKEaAsACXcAfUednv5C5ztWIL4rV0nBNYjuTEpVuorCPOmtFEN+nrrBd6d+HsJ/v9c66eP/MtFo/TVYbV65+JDaLp39lLVV8Vx0VKD0h+WUX8io3NfQ7Ky/fBprs
 p+iRJ5dd
 eYnBmy9pusRUL2E/+pVjYO2mFHjojGSyEm8OE4X0sgWEQ7qpIswbqr6TmzG7A2MhjzRGYtMPAQ6YV9Mip5wG/gxk87tYMTjmxNlkA/j5kfBmaeakBR5d/wo4nA3itITN0RbrvNbklm+lkn9vM5bMXFAF/kN6p+AZPcuT4H0A00fSkKWdZIW1d7GQmovrzZSF0jZKj2AXX7sBZWEupBnXZlZNP91WPZtqn49TRW+V8KEbb/NBKvUuG65RPd2/6L8m6VWDltYzjVcSiWMGsm2dV0c0hcUANoVrOoY7i47cg2+UGxt6dF4aI2nCexmIf+Qjqz/TERQc4Sf7Yy1YrvPr2W8GDC8QjFiaTzAZBDfj7dx3LoC+DWivf7R7+iWHospV3U+XLm/Sq/DNdGd8HNZZa72QV8efr8djKfid6mZtynJbeapZ3qx77paPFkH4VIo5MVYgE6OnteBNhZ9vwsAsHfzwQv2r339z3h2NUufhg08EuCT+7HC8RC2JvSn4fUHizFcbJ9y8omFlsgLsQ3GjMRGr8BV0j/lsixKEDhyV3gfUZ8X+K5yNzFf1qGLk1LvVxQjElRfNPT/KI+nJNJbTNkyuNMcQe9kZsne+IzDMekfwzdkrbKJ3m+D1GXQKvRKQ1nBQ6AYfQ3FGXquEQa82Y/oUm4/CvA6a96o5PfCcQfx6fRl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

cephfs uses the results of readdir to prime the dcache.  Using d_alloc()
is no longer safe, even with an exclusive lock on the parent, as
d_alloc_parallel() will be allowed to run unlocked.  The safe interface
is d_alloc_noblock().  In the rare case that this blocks because there
is a concurrent lookup for the same name there is little cost in not
completing the allocating in the directory code.

It it still possible to create an inode at this point so we do that even
when there is no dentry.

So change to use d_alloc_noblock() and handle -EWOULDBLOCK.  Also use
QSTR_LEN() to initialise dname, and try_lookup_noperm instead of
full_name_hash() and d_lookup().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ceph/inode.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 0982fbda2a82..8557b207d337 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2011,9 +2011,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
 		struct ceph_vino tvino;
 
-		dname.name = rde->name;
-		dname.len = rde->name_len;
-		dname.hash = full_name_hash(parent, dname.name, dname.len);
+		dname = QSTR_LEN(rde->name, rde->name_len);
 
 		tvino.ino = le64_to_cpu(rde->inode.in->ino);
 		tvino.snap = le64_to_cpu(rde->inode.in->snapid);
@@ -2029,20 +2027,24 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		}
 
 retry_lookup:
-		dn = d_lookup(parent, &dname);
+		dn = try_lookup_noperm(&dname, parent);
 		doutc(cl, "d_lookup on parent=%p name=%.*s got %p\n",
 		      parent, dname.len, dname.name, dn);
-
-		if (!dn) {
-			dn = d_alloc(parent, &dname);
-			doutc(cl, "d_alloc %p '%.*s' = %p\n", parent,
+		if (IS_ERR(dn)) {
+			err = PTR_ERR(dn);
+			goto out;
+		} else if (!dn) {
+			dn = d_alloc_noblock(parent, &dname);
+			doutc(cl, "d_alloc_noblock %p '%.*s' = %p\n", parent,
 			      dname.len, dname.name, dn);
-			if (!dn) {
-				doutc(cl, "d_alloc badness\n");
-				err = -ENOMEM;
+			if (dn == ERR_PTR(-EWOULDBLOCK)) {
+				/* Just handle the inode info */
+				dn = NULL;
+			} else if (IS_ERR(dn)) {
+				doutc(cl, "d_alloc_noblock badness\n");
+				err = PTR_ERR(dn);
 				goto out;
-			}
-			if (rde->is_nokey) {
+			} else if (rde->is_nokey) {
 				spin_lock(&dn->d_lock);
 				dn->d_flags |= DCACHE_NOKEY_NAME;
 				spin_unlock(&dn->d_lock);
@@ -2069,7 +2071,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		}
 
 		/* inode */
-		if (d_really_is_positive(dn)) {
+		if (dn && d_really_is_positive(dn)) {
 			in = d_inode(dn);
 		} else {
 			in = ceph_get_inode(parent->d_sb, tvino, NULL);
@@ -2087,21 +2089,22 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		if (ret < 0) {
 			pr_err_client(cl, "badness on %p %llx.%llx\n", in,
 				      ceph_vinop(in));
-			if (d_really_is_negative(dn)) {
+			if (!dn || d_really_is_negative(dn)) {
 				if (inode_state_read_once(in) & I_NEW) {
 					ihold(in);
 					discard_new_inode(in);
 				}
 				iput(in);
 			}
-			d_drop(dn);
+			if (dn)
+				d_drop(dn);
 			err = ret;
 			goto next_item;
 		}
 		if (inode_state_read_once(in) & I_NEW)
 			unlock_new_inode(in);
 
-		if (d_really_is_negative(dn)) {
+		if (d_in_lookup(dn) || d_really_is_negative(dn)) {
 			if (ceph_security_xattr_deadlock(in)) {
 				doutc(cl, " skip splicing dn %p to inode %p"
 				      " (security xattr deadlock)\n", dn, in);
-- 
2.50.0.107.gf914562f5916.dirty


