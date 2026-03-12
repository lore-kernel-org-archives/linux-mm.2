Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF98E106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285F16B00DD; Thu, 12 Mar 2026 17:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243A56B00DF; Thu, 12 Mar 2026 17:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125236B00E0; Thu, 12 Mar 2026 17:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 011056B00DD
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:57:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C88191A037F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:57:25 +0000 (UTC)
X-FDA: 84538772850.16.0278242
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf29.hostedemail.com (Postfix) with ESMTP id B776E120004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:57:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=nvIfh2aV;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=xlwDjQbH;
	spf=pass (imf29.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352643;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcDuCufZRxJixrcfGFygV+aETR7o0fZBVzJe26rF96E=;
	b=iPKg+4m40vZGHoOfw1DMeiSKLReOBCKBuveQzov/FpwYTspFwq0lGMpi+k1JmKORk7A43q
	NTA7GgHVEnktfBiXuErjrNv/wwIKa8vvoqXie2msFHNZbYP+gORUICPm1/SzL9Wl4dflZL
	6gSk4tyEcISs9qnZkHiGgJyiERcyBDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352643; a=rsa-sha256;
	cv=none;
	b=g0Tl/jGF1H0rxG3jkMlzkhw4IkMeulnNrEa/w4hIR4xVIagal0z/IDCcCrzzNzT6tJrcTy
	4TfXMzjuWlgtcV3K/FtuzNSM+vR4rqeUzxkdWlV/JJS3WnNSDSnGLd7dQ0pCcEx2EIE0cS
	De1uF3sJSl+2t8pwb82TCeW6ZGK8iJo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=nvIfh2aV;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=xlwDjQbH;
	spf=pass (imf29.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 8380A1301B63;
	Thu, 12 Mar 2026 17:57:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 12 Mar 2026 17:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352641;
	 x=1773359841; bh=TcDuCufZRxJixrcfGFygV+aETR7o0fZBVzJe26rF96E=; b=
	nvIfh2aV2uCnP5fbNBD0+p+cy5dGDLvwuz7s3Y2ug0pE9ASziUJZDIeLE56guz56
	/o5mTdgRuBry13nfhP1Q6ljFE8dK90mkT3TGfExLnEDQmbbJ4Dd5dIswurNNrHRG
	qGYhyGNzBYe1eg7Wv4tqzkAxFgmyldVz0qJd1mhHWbQli6lUFt9JSJiI5gyfnnfm
	57b4oV9ELFNsGFG3SMNAeCDK4TTz5aO3+SYbXmhxZKK0+IiiAUY8/N6+jkCPR+pd
	4dpuFNZj/O88RcKYROJtoFUZ9hP5f5ew2YzSgcaYhUFxonj7LcTlhEjqBbo59CfP
	1Bx00rDdV5Kc8MhWJ7JNLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352641; x=1773359841; bh=T
	cDuCufZRxJixrcfGFygV+aETR7o0fZBVzJe26rF96E=; b=xlwDjQbH9C1hyWYTk
	qKwHe5IPsQr+iN4dxQjz1i3OO4hnW9JvPTqO9DlXAuYx/EU4usiTZf+yBPoL8+fp
	v/v6ZaEjHOByIDbkNYrbdJWbNWeuewez+R4OXr/Xw9Qyo+x/FkLR79SrLLtJK3d3
	3mf0I+ElHTZ5v25Gr2YAJD3rYwupgT1B6fSTpAvQYmWkEZXCpYWUVl/GMo584Do+
	OCWpoJvv3lLzJ5rwqiPmcnhbTPLew/JpKRHjScaMdrDKoT/wZLzFfO4XO/ABZ5D/
	u0cy237zNWkEclRAhZkLsXOULDttuM2SX9t6Y/c5mpNLkRskDDrpctYmuSOGGgpj
	IdArg==
X-ME-Sender: <xms:wDazafdO_sWmGhWD6154c9XN-js9DNlJSejXhjsPLSLhzF2tW7ppPA>
    <xme:wDazae6WP7w6MULrdQaFCcRVtULw3Y7MWcWXAitpbINf0gpHinB9l76NFAp9R3ud6
    RB4dpzj87qnkxj_U4OdBaVw3In1ut-s--0rHPkEKyshYsCY>
X-ME-Received: <xmr:wDazaff2jYtQMUMv9jiPp3U3_pL_Qyu4MAGP1jAbw-8ts5m8XsCM-D0VpPenhsz9BGYuWjErsQG9g397hHc0xvCSqiukdGirvqWJ27D7kx7s>
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
X-ME-Proxy: <xmx:wDazaVAuQHn5C2dPy2Z6RtnXGYui5i3IkWQro_KarsGBRGti7OYaQA>
    <xmx:wDazabEf4uiVOaOx62aACayZTusJrh-zsFGKwToEWfSjuae36C7qtg>
    <xmx:wDazadjc9GxUmAxpfWyoSqBYdHbU04U8SCrZ2NeJ1FBeztiTngr6VQ>
    <xmx:wDazadvuGOVPBQxad0umw1vk5OPWk8rux78NWpwYaI80YZgoEPwTig>
    <xmx:wTazadWAt_VLN_gSlwcbgrDREjkhIl2uauPOa9jebByPwtSF2xeXUZZx>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:57:07 -0400 (EDT)
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
Subject: [PATCH 48/53] VFS: remove d_add()
Date: Fri, 13 Mar 2026 08:12:35 +1100
Message-ID: <20260312214330.3885211-49-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a3whshrd4b1sot5ba33tkmdgzmztqzr5
X-Rspamd-Queue-Id: B776E120004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773352643-620783
X-HE-Meta: U2FsdGVkX1/erEdU+DPyl1fJLSJoU2ZyS9U9ku5v7N2TP/mX4mK8yfQiBge/XEfGDrcJryvs8bhkjaarh2IDgP47AUD+xjvbASeh8sUktlijFRGUkMxTQyUE0d4HsO64hxpo/fb52dupxuYMcjM+UHPuVHgFUv+JuRUnYv7Gxe7z7it6/Zv50VBnO4vA40qacANtRSWG4ZPJNmNNt20trMKCTs2GH/Swr2CeB/1b+C59J7fNyDx+pJ8CLOFfVCnrFjIi/10pdkFfcNcc4cpIfnQh2qq9JO54NhXfEp57tZe9H8ydzoosm/YO/NeOacJnut2YPEurmVwbJAuENLXC/aX0f8v5VScJGO9dY+NdxTdSfQdWC3IzCiqsCYZGo0hm4nyO8+V68WG3ZAG3/94z1K7hki5RPiBL3Ut4KKMcipAQVRinZDeAx7tyBZbrz6lP1xtMfvegvPyKd9FpxHw6C8XmIGNOPV223/rqowdBeomd4x9XwoYFxHzc2pjK2gei20Y2swM4qIYyMF8VBIRQhxMpyqdPEnQiwOkAagDU5ErbYNvHC3/A8hAOH0X+prBF4GjrLerxM+6xZAhAkChrOQI0hYNl7V/BSKPRXvT2BcklReC7EvDunxA4fnJryj5mfdd2hrZyLG2SipxWMosqlZq48GU5m0+OVa3Dd4TfWJR9uwmVw+u/jceJIPgUH3K7KZxgzKMTEz7l+ycrnuyCAIektSbA8ZtQNrjNzCFWCAC+GU+yoiUmDsuOU5rUOEDiVVY8jUjA9q1zuD8BIGQKRxCoLcou2jmBuarf33Z8hg/fpSVH+i7tkZ3UO10AUF2b9L2+MKJvL5ZGNWk1Kbww1yafd64WdJMOfXLm5BBatKf1AduYbxMD1jOvJcPi71cGW5ErEp3dG5qY1oRfhRog1DptZR7b9NYOf91bVlJtrOp406K035oGwYPm+XU/I3L3TRiXLA0ewOsBmj/0m0o
 WWGXWLy+
 sHfgYuK+9OIBsZ7esH8DHaUiRJaJAGG9gBhShMyY8znZSs6gQMhbkWw3czn11/qVeWB+jJFlekBwRLlwqbJb4V05PIlefWqq/IURSeNK5GXsrqCIyYOSBfBSHBcPbpr+85Ocoq5Y/yPNDku/kS1G3jN6t49fMWAKIW92CgO8qYEeDJTW0qD0t8Aj9b4lGWECmXS4f0GfHgIv3Mf63T6MORNwee//3+C+Pgk6OrfQZWwpjerLsKRkJkdUXcGfYd2xGJFvMYpu6DbmtIvOfSxhiVXEuF9bfjnjQWqjfjUPEbKcMna9P/0iDu657nCB5cqPztVMadQ4ebryd0/BkT+192wL3QB3mPZ+fScMUvlNU6ySKK8kr/4VOuvG+MDfrkA3D26og7W0m60OQTm/P9vCN9IzOaodJdd76hSXQtsqFp/7D6uOEdv1M0pvHPCQuEARX7gSbk3Nf48xzzmuvvIs0dqOjo3uFO5tsfW6aq2AuBtZRnlkTy1kseeYJHO2fCGYnHeLaxmCRTCW4JjYel9LwrDgkbOU54vNJr0TYHHAJv78FmN2mwMxVnKSA7C/BIy0tCW6x7UbKOK+hJF17HhdnUA9S4Al6IGZgQz73jBmZQAGI8Qx8uzhcG/UsONc1v6GLLr3BT8tukHiISbXA/ZQjAS3WQmxFC9IIksFby6LR+fyfoTixOjnPkwVzQR04Bii0bAqXl8B+7bPfz000j4vl62KZJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

d_add() has been supplanted by d_splice_alias(), d_make_persistent() and
others.  It is no longer used and can be discarded

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/dcache.c            | 19 -------------------
 include/linux/dcache.h |  2 --
 2 files changed, 21 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 23f04fa05778..4ebbbcc5aec4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2979,25 +2979,6 @@ static inline void __d_add(struct dentry *dentry, struct inode *inode,
 		spin_unlock(&inode->i_lock);
 }
 
-/**
- * d_add - add dentry to hash queues
- * @entry: dentry to add
- * @inode: The inode to attach to this dentry
- *
- * This adds the entry to the hash queues and initializes @inode.
- * The entry was actually filled in earlier during d_alloc().
- */
-
-void d_add(struct dentry *entry, struct inode *inode)
-{
-	if (inode) {
-		security_d_instantiate(entry, inode);
-		spin_lock(&inode->i_lock);
-	}
-	__d_add(entry, inode, NULL);
-}
-EXPORT_SYMBOL(d_add);
-
 struct dentry *d_make_persistent(struct dentry *dentry, struct inode *inode)
 {
 	WARN_ON(!hlist_unhashed(&dentry->d_u.d_alias));
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 18242f9598dc..31b4a831ecdb 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -282,8 +282,6 @@ extern int path_has_submounts(const struct path *);
  */
 extern void d_rehash(struct dentry *);
  
-extern void d_add(struct dentry *, struct inode *);
-
 /* used for rename() and baskets */
 extern void d_move(struct dentry *, struct dentry *);
 extern void d_exchange(struct dentry *, struct dentry *);
-- 
2.50.0.107.gf914562f5916.dirty


