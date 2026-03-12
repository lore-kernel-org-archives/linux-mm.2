Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3AC106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4851F6B00A0; Thu, 12 Mar 2026 20:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466EB6B00A1; Thu, 12 Mar 2026 20:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349236B00A2; Thu, 12 Mar 2026 20:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22DAA6B00A0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:46:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2A75B9CCC
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:07 +0000 (UTC)
X-FDA: 84539197974.02.714F78F
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id DAB0F18000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gKwSPNrD;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="lBx8/it3";
	spf=pass (imf16.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362765;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvJJgAoi6+6/iAinwR5eAmiVL7AkcVBlOABk7/2rYco=;
	b=iw97M0kYCYABlQx3TN6tXEGjx27FhXYeAOXzZux0pXyLP1xVT43074eOgSYUlRbP41+viK
	nc6EmoTDlDC4/yRnLtYhVM4fqgvbnIkC+Tl5YLiniyQEFf4TZDwEHN740faBinljlVstYE
	7Lkm7nPc29tldE2kPR8FRhsfw5JRZnM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gKwSPNrD;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="lBx8/it3";
	spf=pass (imf16.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362766; a=rsa-sha256;
	cv=none;
	b=QlUtESS/zdsHaID7O+gyICkHxQbwosmiO1kN5ujmzV+DqQpJvnSZuGMCsNl95SsiquvuQq
	K3ABH/9xJ6lQfMEKTbgYPKJ//kXayriNr9S9H6wquOumOfJH0Upe1211ehSE8H/4jsylrd
	HvI09ZV96y1afknW7VYlZrjIC+PR0ew=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id C57AE1301B4C;
	Thu, 12 Mar 2026 20:46:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 20:46:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362763;
	 x=1773369963; bh=PvJJgAoi6+6/iAinwR5eAmiVL7AkcVBlOABk7/2rYco=; b=
	gKwSPNrDp/Lh0K2AdmDPuP81x/xKJYynieIS613cuyIap5TJBGt5zoBJQkcnLx+P
	wIIpre2IzG82z5AyDZagtjjr4EtLFHuY+3ew5fDab1/yIPB/uUEieMSrkA3SAGQh
	0hw7ulI7fDK+6bhU0r4qO4EEemUcLLydcBXxhaWveI05xHIYigrT2kv6HGB22iDl
	Pm7Z70iYJsrxhQm/lNa8SebZsdmRrivu1M2XBRDOdTP/LlqHocEGRvESnBiNX92B
	JLUzL7W8K2qPLuHSJfmCX21NPVd1NhNhOrW+1abIUaEPZHtwCQuWsFmoxcxpcZoQ
	s9OP3WR1HmclPU7UtiAU5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362763; x=1773369963; bh=P
	vJJgAoi6+6/iAinwR5eAmiVL7AkcVBlOABk7/2rYco=; b=lBx8/it30WvLfM1Ut
	4V40yFC8YMQTxuozALmQF1Kz8GrZRjYHh0SEma52k1oUapkTo/R08AT0F53b9/VY
	xdwzYS7PxHPQqsugkTC7WGac+zdsWTTGVKW6btlA+rILgtb5JxhC04Vy/65L2Xdv
	gVJcdhH41QdzdnSyemJSUkWvzFljqohC48EoOSDQD2TO/gvb0ZljX3XBCb38KUN/
	K+Vr6CN7cP5atIEEGvmRRks84tlmL3uGXzUXmKCpw01j5H5hJwsVnCDxu6xxFoYd
	SqpnoXrKs1sjPLo+NcbXGxHzrmCTuu76BPw50bfweWvA1mDAr7hV9ogvlDfmv7zI
	1xFmw==
X-ME-Sender: <xms:S16zaUATOTAdUJHvPn1j8hALIFcGRTY7CqUc16mh-7kpVKdUNqbudA>
    <xme:S16zaaNsN6WULJMEZEYNHEfjGUNLg3TOo3eaDKIpm1RTVN3yGVRWZAvSMGgaIa2it
    zCE8_z9EZtPihlV_knN9gyoauJDoLEX_bOdCZHU5Lxo9MKjdNc>
X-ME-Received: <xmr:S16zaSrByZrWq7H4eUim4f3MNHov96sAFzfyid3OWyvok-ilizmXdhDBXHbVUd_PivqzLTCOghaD0LUru-wo-Mt2CSaRzfWYgxwjiDiN0QJ2>
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
X-ME-Proxy: <xmx:S16zaYPao2XJJDUhQdklcQ-SsDGTxjCkGZDxZQnFX_-wWOM18mzM3g>
    <xmx:S16zaezYESx1jpjLQkq2IsSCH2hcX8BGl2KDNnw-JHk3TIaPIkf8aw>
    <xmx:S16zaR3sP_vaX_rkdTjpttWUBD6HoQ2X8iZG1g7atODF1WCyli2TtA>
    <xmx:S16zadTuHaCPpH1HtOdIocFwfnH-uWVUynbgpiYtByM0WOqO3X63lg>
    <xmx:S16zaSPV1vYMjAglL0pfAPcfhz6A-1ky5mxg6OKIh6zA3xacPhk5bBc3>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:45:50 -0400 (EDT)
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
Subject: [PATCH 27/53] smb/client: use d_splice_alias() in atomic_open
Date: Fri, 13 Mar 2026 08:12:14 +1100
Message-ID: <20260312214330.3885211-28-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DAB0F18000B
X-Rspamd-Server: rspam08
X-Stat-Signature: isoe3peo11fyfqxkzrm7fqg84et5swb6
X-HE-Tag: 1773362765-959973
X-HE-Meta: U2FsdGVkX1+NHECzrbi9rtHfqqLVLWATBWtVm++t4jnzGBdupsfRk6JGzDzLEDjGfBioZ7W03ebrjqQvAGF/wCmu/a0hH3z0Ccc8BT7bKgHC75yJM3wBtlKzvj85X6mwvV7v8d+XVksLSfqM6j5zNJtdk5KB8FDEM+tOYx/STUpBnoXfwjl8u/DyTaMsEPaHEnCa9WkHNloJbTOaAUxtfP5ogRZ8RJ3zyG/+lBmcd64wDW4DqGXQ1pQDs4FgkTjD87kljAoFXmdlOF8Q+U8Pa+KfrJD4sfiScxv7FMp67QQw6msEauG606tsiTzlet7SlDWOAejO+6i5e2UbVIEe+tNCcPxshxMPYu+VXvwKXDo+ZenzFEE4pawbjAPHcQLY34CBSy9Ir/Jp24ryokX37bvoHubFfYEySFBsW1CZ3D3z/5WlhLcv8LpqHWiqcTdbSR7T5lE+7yuiSO0Q4orC9jGDj7sg2iQR/Fr82qMJ55PI855uPLjQdtWulDXyk7NnVBgKHnRJtM0HuoGs07R2lb175yyof5f6thlbA6Q/YnwyN1JMsOrNVVD+MS6nBwLIu7uTgZKP2ohsN5UN4OPQ4YjViLV0w38Sv2BPwO/1PCGxtcrzD4JmPTeTZbeCynOn9sh+upvpgUbMYHtL7tmKoduCu64rQjCXoujEhGKWZUltDeAqr3nnc9/6ev+mqeBGpdMCRXyAa9RJz++Hqg/oTtt3/TTV/zgpwSULkmj3wiEfNQeqCLIw4RButiTScSbWlCfcc8niPailKUdCiH8IPHSJacDoqLaDoAYRI9hFpmEgBRYMOT+SImuuJSSL++pvZ8W9mOAaRu37A16fXfwUlfG+Wr1g9zwy5ksyQrsk2iIEUJ9wsQVbiV577OWPyjv8ThfiHPThuq0Uly1zGcPNBbgnubJMijEWGTVoKGLdSrsfRdJw1jh3GWA9H6qAtXdLSirvyPBhsGQn+ZAJ76f
 RgMBxHFR
 9oGVB0N6H2E1CojXVOzzus2nCNyBS+tVwsSVB1PJwB5mnm8TfROsp1+PNXWtYWuj6XrLLo1J3MdeIL6VAIkZUfhBVeN5WzVBwaIZeHSlu2B706/gjH/Jki5yAuxm1QH7pRh20tpCNQEbOa1XWDXjoOtzNECYL5jSNDpAumygg7JSa8FWwgvfSop1PdbODEaXOh60DT83xHDdfD0ek58M72LoU/399qceqKeAT/abPLXh/XKaUEt/EHEkKmldrRx7g2fAM6ihp8QMmQEgHNYUw+a18+IjrJa0dy9h+9Rfm7qbFuvZYCGxZB8FbvMigQE8lkaHG2TxLHv9zSgXB7P3CdHUOF9k4Q4y24U5tiToqJaX3sHRb33828viFDhtDtGGvJ5m4m+SHr8gpFE6dIq7mnKWj1OvJ22Gut7Y+AKRn7FH4UktCUm7IXSxCzCbcXTwgfgUFv8D+unQS9NNrt7AGe412C31uAYusds7mLt3r7rbctxWLGSAei1ZszzztbUX52frZDEHH3W1DeuCVI8q82UQp83qH2QwynXIGuXcZU2cCMiMrUAonjNDcHwwRqaU7X5RmWyHmWISldny0fBaKXCWZPeA0mX2zHrG1Xmz5q6cQ2oeB1hYtlq1RXmvfCSBlUzckr3ZIETK37ug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

atomic_open can be called with a hashed-negative dentry or an in-lookup
dentry.  Rather than d_drop() and d_add() we can use d_splice_alias()
which keeps the dentry hashed - important for proposed locking changes.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index cecbc0cce5c5..361a20987927 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -439,8 +439,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			goto out_err;
 		}
 
-	d_drop(direntry);
-	d_add(direntry, newinode);
+	d_splice_alias(newinode, direntry);
 
 out:
 	free_dentry_path(page);
-- 
2.50.0.107.gf914562f5916.dirty


