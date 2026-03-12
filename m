Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9508C106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0020C6B00DF; Thu, 12 Mar 2026 17:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEC96B00E1; Thu, 12 Mar 2026 17:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC66F6B00E2; Thu, 12 Mar 2026 17:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C93666B00DF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:57:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BEF61C381
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:57:42 +0000 (UTC)
X-FDA: 84538773564.21.5E5967F
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf08.hostedemail.com (Postfix) with ESMTP id 919CF160008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:57:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="H/xdszBd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UIuUs5vU;
	spf=pass (imf08.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352660;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHdWWLZAUXsN0K/gS8foO1rQ+cBpiHFflrFfn6k5mho=;
	b=iBS3Lulj08L5epn+X9pcMKzx8aksTVh4e60CeF90SqgwdJn74fGdLehRjcKGGtL/q64Joo
	3AD0rv5cde0KX0dH6biaHGboh1iaVA7uGn6lU2jx/zdqhhszT6rZgwmeo66AyfE1jdIZiB
	OWhmaWh3pPHFVAlysvM0Hrm5KewS52A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="H/xdszBd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UIuUs5vU;
	spf=pass (imf08.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352660; a=rsa-sha256;
	cv=none;
	b=Dlhv0tR0irG9kU8SgFN6Wtey+S1V59Y7LP6FlZUQFoE+JuzDy4a1j5rOM/0fpw0M+SdGYn
	xNwnEWJZRNauwtQ9f1N4WgRkjRcN1RWSoOR+Ai70N2bj1TyAcqtoDi5rUYbK0OGUmPAPAY
	yGx8yJtg7IYFHXv7GKcbupNezYKaLrM=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id A5ED31301B5F;
	Thu, 12 Mar 2026 17:57:38 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 12 Mar 2026 17:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352658;
	 x=1773359858; bh=WHdWWLZAUXsN0K/gS8foO1rQ+cBpiHFflrFfn6k5mho=; b=
	H/xdszBdpajXQlqvP2h9f8bRrmPuJ0E3HbSIi1+FvDbmXu5Tffa39rTheWtfGwZR
	07K9XTAAEu7QaoJDNNdeV8FPwp7VsZ05tBCbGNERpgIPXvnUh4Dh11eHvup8m6vs
	E5AWfQHX37M7Oed9OovK3Y5b84TTp6vRaxqOKav5UXzJr4jRcIi0QkXwPhN4kZYV
	LZoFa/W1oz8zPHi+tqAL3COCNVGwcsFSYb9+rQJTG37CHQI159wRjqpP0tBXNsNq
	WKVSfQ7Vrk7fhCT55o9UbvASICeM8pa8jCAA7V/OugQhNLLKoEUUVDh26eeB6pU0
	w+PQtmIUZsNeWl/pHFJh2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352658; x=1773359858; bh=W
	HdWWLZAUXsN0K/gS8foO1rQ+cBpiHFflrFfn6k5mho=; b=UIuUs5vUUmD7NwmW0
	yb8NDgNHItXo1Ks/l/WxZ+fc3iPeAPnbXAz/dyah4o+3nxPXgyyTjMIsM+QVnZP+
	YrT1OE6Q7kMuq0FQpMmfD5M3YNYv+ja9g16SXRCe54Y8qn2v2Rv3Fx3JjasZy4Wg
	UEOHHaKmxENT6dRF9frTgZLL7RQ62rZhSzqZV+3ehBY2yK051jf/wLAtOKbzZxck
	oOCPIJW9D0oqj7rnHP94IfAhWhex0ZcyYxBDYhqGoYVxAV21pRS44vfgPWtBBbbw
	4XQOqgI+qyun3wABEJ24wxhbpqXk5pq7ME0lbxnSNrBtvCLwBnmyKv5pz1oNHiw7
	QHz7Q==
X-ME-Sender: <xms:0jazaSy8bXpWpPsaPX1E6VAPF25eFtNUoJuhfM6E6DvIgBXZeDvK6Q>
    <xme:0jazaV2G0RNn_BRqnE2PE-VjHdIf6JJIiteQEz6hIGZfeZfr65GcDPKsQiMmLA3Hy
    eBNoXKsoiKkvNl0paA5xRLSNO8N3TZuVLesMTJo84VjvJS_-g>
X-ME-Received: <xmr:0jazab7g4darHFJA-SCIA5F6MXzidX8T9V3YZD16QZt-SsfFkLX5Ub_x5kNHV7EtiTMQYwU_2nhZAmFQd5V_j1v79PJAWdXX3WHLUpxf8sBX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:0jazaYfsce6kv1VLx4j5HYSDkDJDWLXIzfT4KuG2qT7lIXautdNOdQ>
    <xmx:0jazafZXf2ZbWmY1gwph635TbUyC-MTdZ1P4qT982CsVse9m1MpE-w>
    <xmx:0jazaaFOVBMAmCt30GIJBXbAW3DqDj5BUiJ1cbQx9CzarA2KS1okjA>
    <xmx:0jazaY0YaOBPy7S5FOPpP5VNijeMTySTyB5LHakGXV8VuIzZWSbT_w>
    <xmx:0jazafMd78AdCgo3Yq2WUdF6y1n7vTQFPDeto_tswQS3a4MdLzMaJVae>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:57:25 -0400 (EDT)
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
Subject: [PATCH 49/53] VFS: remove d_rehash()
Date: Fri, 13 Mar 2026 08:12:36 +1100
Message-ID: <20260312214330.3885211-50-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jummcw1ogy316zrp8wocpi3aze4fkukm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 919CF160008
X-HE-Tag: 1773352660-519233
X-HE-Meta: U2FsdGVkX18oNqAKn8RkfzHdWpxEdU7UbG+SipyIaf9Ov10sTlN3YIICWpX0JvoRhhRgDn0zq+PDbeVJ+YzBYc98np53K954ckSppd8UX1KYzLMstAULGG3by1yqKtd3It7tjoxfTFKGYb6G6rvwuMp2/RnX6Hh4hLvtBHFrr+BOzu6j+QSt6VvIpRcqRd3UIggwjnF/pyt/BsjzA0gF/FHyzrZ8mO89uib5uLNmUrVhaWIUHeQsTGk5HFo91XHTSqF5QXmsjOtibW3ZtMufRJE2pPD5DVvAHfN8tO5rWad2G0A+q113+PA/3R2yTjg/lGR57JnORFUEUkNSYKrxf5kDc2HBUWKgnVRHzxGtpqRjLleoZB3LXQ4xLp9ciVy4nOLwO3zVScYT/ysIypQ3rUo5Bv0+qkoDM/BcTEHIeydnvjFQoR9EVMov4kh/MuFLbQ7Mw5Sxufqe2B1EJJBdKnvbcDNh8DBit6bPaPD8IhPlqvBP5cL0ATwju19N6z7oMFqOn4twBCGsaJc/NAIRIAGBD7e55leCB0WbGPFg9pldQSRsGsr4xoGgy78vvbhuoYCGgnW13R50BjCWx2pB2ir616cl1Ee4XYm5N3GqRHGnDx1f78WT6oU/1zhJkfoa9h0wmsJcRgAk4897QP+udn7mHpRzGfP2v8wTNHIZtPW5ipmACZSuvhTB5ufq7iOVsXuB8MccNQqTdJP+bXIeDByV39Z6IoF08d3+cWmyHdQ2B01BX6l2NAkl5UU4iGpDM3YyzggvlkyIaAyPB1rtnJ8sq/RhMy6e5OqQbI6c0yuqjHOIba3/PCOh+DFo6rkMpQ3G6el/7G3pCE1JwQTXzOwo6/y6cAAFnkhaOBaAGhiCnxDtKuGnI1KqH+hMqgr7y/KVvpirtweVHriAM6wdm8bZ7rrTzauUpfGmqNXX6qo7pei5kMjv4XtWHd8bL2UKekG80+yzS+lkw3Gb7fY
 00vSjeRJ
 E4mXMyc9Cj6Z2D4GS2Mqf9zCPbpFyAZPn6DjzEkO+uZzGorltZG7VgPv56vGN3qG6jQxd3LEMFul3piF4dS3XSjzTelvQ/2FPxfREmCjWIJiJUu/qsNFHvrCEk12E8U7ycTP88XjqYC+PTl3IyAvyKn+pgRJ9cuhQ+7ksbKW1Tg14N1e4TLlLxgvAHhjubPNSifEYEUSBXkP6XCerOTK0TEqumvm/8wnjaixROOFkjVKheL1hzb1NEbOf+5mtWQK3be1Tay78KoTEDKvFaiB/ijAWr15XfDitbOBqkeNWztHUJapqDhFhE/TR76/jdvBJiSb/PjOlfpok/UoLIxdA+6f4LYVGfLgNUCUg8S2IGH3/Z9XQpS5hJme0rTEWzSiCwn+LpFDQlysjVsKhaA1h3plVOdO1oaD1m5HzS8/R2G0czbq/roKB9NJF7BoO2uyc7oNfPvOSvrXo0lus1roFWVZy+IC2eFsturssmZiBeW53Bdsn59GSSoCTxn9AL3ieBDKBIQiS1PCSTnGJSthcYarnFs5Um9x0NpgUDJM7LQdYbJfYj4euJEUCzC5jUQQTfWDk0rAbiVU0IMFTSmMYoWz3iz/m9Wwi8Asme7Vu5djqkQqsKUEVg5fTGKgdN2yF4Y0YOnV0RA+Vxq7CPEy1NXex/uVrPbwO6SZzO7f/hCVRRYp5h5dAFtRs6eKWdcHMfCE1aUC01oWfgW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

d_rehash() is no longer used.  Is existence implies that it might be
safe to unhash and rehash ad dentry, and with proposed locking changes
that will no longer be the case.
So remove it.

Signed-off-by: NeilBrown <neil@brown.name>
---
 Documentation/filesystems/porting.rst |  7 +++++++
 fs/dcache.c                           | 15 ---------------
 include/linux/dcache.h                |  5 -----
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 4712403fd98e..154a38cd7801 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1389,3 +1389,10 @@ from an internal table when needed.
 d_alloc() is no longer exported as its use can be racy.  Use d_alloc_name()
 when object creation is controlled separately from standard filesystem interface,
 and d_alloc_parallel() or d_alloc_noblock() when standard interfaces can be used.
+
+---
+**mandatory**
+
+d_rehash() is gone. It should never be needed.  Only unhash a dentry if
+you really don't want it.
+
diff --git a/fs/dcache.c b/fs/dcache.c
index 4ebbbcc5aec4..abb96ad8e015 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2627,21 +2627,6 @@ static void __d_rehash(struct dentry *entry)
 	hlist_bl_unlock(b);
 }
 
-/**
- * d_rehash - add an entry back to the hash
- * @entry: dentry to add to the hash
- *
- * Adds a dentry to the hash according to its name.
- */
- 
-void d_rehash(struct dentry * entry)
-{
-	spin_lock(&entry->d_lock);
-	__d_rehash(entry);
-	spin_unlock(&entry->d_lock);
-}
-EXPORT_SYMBOL(d_rehash);
-
 #define PAR_LOOKUP_WQ_BITS	8
 #define PAR_LOOKUP_WQS (1 << PAR_LOOKUP_WQ_BITS)
 static wait_queue_head_t par_wait_table[PAR_LOOKUP_WQS] __cacheline_aligned;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 31b4a831ecdb..eb1a59b6fca7 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -277,11 +277,6 @@ extern struct dentry *d_find_alias_rcu(struct inode *);
 /* test whether we have any submounts in a subdir tree */
 extern int path_has_submounts(const struct path *);
 
-/*
- * This adds the entry to the hash queues.
- */
-extern void d_rehash(struct dentry *);
- 
 /* used for rename() and baskets */
 extern void d_move(struct dentry *, struct dentry *);
 extern void d_exchange(struct dentry *, struct dentry *);
-- 
2.50.0.107.gf914562f5916.dirty


