Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF8B106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5DD6B00C7; Thu, 12 Mar 2026 17:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0E06B00C9; Thu, 12 Mar 2026 17:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290356B00CA; Thu, 12 Mar 2026 17:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1724C6B00C7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:47:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC082160431
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:39 +0000 (UTC)
X-FDA: 84538748238.11.DB97484
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1914040007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=iPWOSxqZ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="unIU//e+";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf04.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352058;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQfPF8qsPDD4y8gX0swga1hVwNgQjqyWwNEjHrIDNRM=;
	b=n22l6cg/4sRJeDYuFKelakDFcR5XcSmZ+7MJLR8xGKVVZewg0YXHGmLUfaQHB2vVAKwFCd
	MQT092hDRqo3WYOPwVoYAT+5eQBppJTFXcgCU2vbSUh4bHw16NXImGO2sug5urCGB0WfQe
	aT5LOufKk4wL20NydRv8lsNRK5wEX5I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=iPWOSxqZ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="unIU//e+";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf04.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352058; a=rsa-sha256;
	cv=none;
	b=k/6tOVGZowlT4mAuJyvhIHtUCDrDdnliUCO96B8GTCqRjphO83nVu35xQC3oO7/IacLmMK
	IDaezOpyjN5IPxrVNn89GSG0hf5IgwDSNzQX95YGQAaP1bxPlVe0oUnfVYpxNPczBRHkFz
	Zz1CkxhZ6usNvtlMuScpP/emCkHl1EE=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id E848C1301B68;
	Thu, 12 Mar 2026 17:47:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 12 Mar 2026 17:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352055;
	 x=1773359255; bh=IQfPF8qsPDD4y8gX0swga1hVwNgQjqyWwNEjHrIDNRM=; b=
	iPWOSxqZlSqyPdU6zTigaodUHhIuXMhwcY2p486hgesZ4N7bhchW/j7ATJHN9FBW
	oKMrqPBlqBMt3lkYCgSSFCKYXJmW9ODmThws66AtdxwYimzVfOz9cBugmFraUhdV
	YoO+Tg3MdlfJnhcIN9JfefQc+OGsJZ24NInAWQKWdb3ofc6nEyQw44fO+K1AQ1pL
	PckIAJ6PEuGLH3OUpr4l+1OppEhqfHtePP18EAfy8H3V1DfBdKsDc1LWDBmYxKsc
	1007QHUZL97zu3IXO53mSATagMEzl3Qlsr521UnNLtczRjXcqKEV2fA3ORrfY0a3
	MpOs5Xw5kf4wMfV1RUUcDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352055; x=1773359255; bh=I
	QfPF8qsPDD4y8gX0swga1hVwNgQjqyWwNEjHrIDNRM=; b=unIU//e+8gYENP4K1
	FVVmPPrZh+cW9to8xynIOLL2gjLoSBNBWQceiEYqrtNCGzla1+3dWZUcITjMgi/X
	uuL46Ngko2u2uNp1O1vKehEFbTUjc4NkhiutBEF1BzxX5CZ/RVgo9uua3IfTb1U4
	NGa3YLqzHArKaIKtpRK98PwLIBxeoOcWX+A+OTTeQa5687EfcLW0m0JQ4OCHV0qj
	k505GHZtj/bSahn2aOVVCe3jQhaIxFFRjMcooWaTHAaqasI9A/H+N3+vQ1i3PxZy
	LueNtc+7viQ3EYAT0DTVcQn6YEP2Q1GLKATntEhtaDEKcbXPcerB8IzWARCsLvWM
	IvM2Q==
X-ME-Sender: <xms:dzSzadR1MAsZAitEgQpRqkE1Ohgad2kzGcH263o1t7TXTRgxjdqYeQ>
    <xme:dzSzaaddjVsxxqrJg6cd61V4ey9u8NiPzMREsyhWiuAlorEYRpPofNSDIMwtQieXj
    imi6hPyKXjSImt3TlbHBCxZzDmVo8J_ehFyBdBFkz1_tFAlXQ>
X-ME-Received: <xmr:dzSzad73mhvPgvYL751N9h1IuqZDC9qCfyFWvhd2UO8UNcD9DN87JGATxBceAdvuqD6UcBlC44Ws0fF9LuFEhaLI_3yzuN6FXCQu9kMzkMg6>
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
X-ME-Proxy: <xmx:dzSzaSfdzbvlo8FTUtQUSZHaX9m1SDibKD-faF9-7T1qyLf0BGRfRw>
    <xmx:dzSzacBQhEFOtMEi4Yv-yULYFv_4Nk0yU79ngB4PUfLkpukgxYwauw>
    <xmx:dzSzaWFpFURMotSUNpKLQepIDtDYxPIhrb9wtRHKaYgRNylCCa9-YA>
    <xmx:dzSzachcP-QQRCqfvyqvZXN2FVihxCh2TfPpAiVTFvwqP43nNdJpFg>
    <xmx:dzSzaUsQ6Hj2-q3E5VjcI00qQ9mNWzPtWkKoAtnPKz8E6T1iivMLl0S0>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:47:22 -0400 (EDT)
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
Subject: [PATCH 11/53] nfs: don't d_drop() before d_splice_alias()
Date: Fri, 13 Mar 2026 08:11:58 +1100
Message-ID: <20260312214330.3885211-12-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1914040007
X-Stat-Signature: jgnnrfxdhgcpsb6z9m6ag8rwy9p94z9n
X-Rspam-User: 
X-HE-Tag: 1773352057-611098
X-HE-Meta: U2FsdGVkX18uWlEUB6ABv4bNCnHTHWKFa+WMaym8v5IBzBApJK4waFlJ1SiuyjLgn+4t5uJ25fzM3gfNjDB1k3f0UjKuEUEhyNiGj44tV81qwf5wsLzZCRSNh2pqHRlpez0NRCZPoGCwmSl1vpuJ5Pzo1PEMxkOTP4/2h7ph7FuW5QV4kAuFk/9IRHtGYxfgC2fEO36z/gB/yqP27PNaks1z+NtZ7/vMWQGteWwxyN5VuGarbx5CCRaJwscCu3byUxNX7SciRbVCOUTFI3OO01+KjebF15XIq/qxXz/Q0fhCN/ccT5xeunPXExn9Fe/07+s08FfOsMuSGxp9u6Ub/6ta40iwoEazcweHCBa/XO8r8wjCrvIiud95js0yVUA1/VgQdevGLDeO6JGw28Iw1oX1jGohG2VhjNq4uaoXP6ridGXUHoZslSOAuXtNtJoQ8xoyFW49rKTgHxZRDfFh9PBhzunT5HCyZUKfijL+fZL0ntVSb7zHSZtFSJHq+OnCaW8tfA+iG/YbE2tdU8l9C2Xz92r2ZXISfqlrOoXB5aRLY7m+xv8samOJEuRepzJhapAgNqnuIhR4fdQgFjWC3ATsl6Y47j2ZEOAPOsdwTRCVhH70Pd1VoX/KvlDBrvCU33CbjPgxEMwvTUVLBXi9LyDIsZpZqorKr5J8offdWisUOWS0BCMddO3k1bW35QwDvosXEvCrJuSEo00J1T8EDdRMe9OI4Ou6lNTWjc4cvxwaQWnku+9uTazrIbHbXu+TR+fTU64Hu2ZWIK7nYwa+9uQRfOe1iltaqEBbnDQ+hi/+2hLOwsK66GBqNBuppnA3XNbBBMSSeqdOAHdnND51yxvBkNgLRu9t2eC9YebINLvkbf5cCF9U01YbeMqA9rWC0Lf6tBahuji7oCq7JCNCnQr0MZPnFLk0aRLSIYoll34fnpyHOvVN+wvriM6P+Ov2XebLLjKQTW788vxcj4g
 1ufAlZzN
 BO81GQ5Srx+Pc4R9qiGPjgRqqzKFEvRncMUTxG56rcFkzM1KnW78UHFYakmfNFhx+Lmt5Up3+XVVrivc2dbIIaauILSvsjVBnz23MulwenebRKq0+q253iSwJxhNk4+4PazPXyl5hj5FeU7KZv8/zfrtjtTQhfCP0THjPbFZAxb7mA6iw+ec7uvWLcReaF+pEdXTgCj4YdgjJOHEV2ocouWCS8McFWALD6cT+g7qnggZB6bdT90UG5gyJZ9yYdDGmnmKs7arJj9m+hrAD5DUHLcslNg3ou5XMRoDr8fgVFVBdHuFoF+bmsUm3gA0eE0mmqYZoScJLVrSX2FY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

nfs_add_or_obtain() is used, often via nfs_instantiate(), to attach a
newly created inode to the appropriate dentry - or to provide an
alternate dentry.
It has to drop the dentry first, which is problematic for proposed
locking changes.

As d_splice_alias() now works with hashed dentries, the d_drop() is no
longer needed.

However we still d_drop() on error as the status of the name is
uncertain.

nfs_open_and_get_state() is only used for files so we should be able to
use d_instantiate().  However as that depends on the server for
correctness, it is safer to stay with the current code pattern and use
d_splice_alias() there too.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/nfs/dir.c      | 3 +--
 fs/nfs/nfs4proc.c | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index a188b09c9a54..f92ea11aea44 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2330,8 +2330,6 @@ nfs_add_or_obtain(struct dentry *dentry, struct nfs_fh *fhandle,
 	struct dentry *d;
 	int error;
 
-	d_drop(dentry);
-
 	if (fhandle->size == 0) {
 		error = NFS_PROTO(dir)->lookup(dir, dentry, &dentry->d_name,
 					       fhandle, fattr);
@@ -2352,6 +2350,7 @@ nfs_add_or_obtain(struct dentry *dentry, struct nfs_fh *fhandle,
 	dput(parent);
 	return d;
 out_error:
+	d_drop(dentry);
 	d = ERR_PTR(error);
 	goto out;
 }
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 91bcf67bd743..a4ee0c0b4567 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3099,7 +3099,6 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	nfs_set_verifier(dentry, dir_verifier);
 	if (d_really_is_negative(dentry)) {
 		struct dentry *alias;
-		d_drop(dentry);
 		alias = d_splice_alias(igrab(state->inode), dentry);
 		/* d_splice_alias() can't fail here - it's a non-directory */
 		if (alias) {
-- 
2.50.0.107.gf914562f5916.dirty


