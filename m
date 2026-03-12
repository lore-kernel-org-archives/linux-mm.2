Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B916106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68836B009D; Thu, 12 Mar 2026 20:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D288C6B009E; Thu, 12 Mar 2026 20:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6896B009F; Thu, 12 Mar 2026 20:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B0C7F6B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:45:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 784191B81FE
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:45:33 +0000 (UTC)
X-FDA: 84539196546.29.2410170
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70B9BA0007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:45:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=Xigasop1;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FvytbuZD;
	spf=pass (imf25.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362731;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R05x33rqt4D3Op1mihSzRwcI3EKvb6TFzzswayv/Ksw=;
	b=MCO85k/f8nQlCG/6bd04a1+dnZzyT8JBYtHaQA3/dQzW3GFTe22JjcJVQrvA58VQrftSLz
	SYlmokpPEmDDPjGyQr3L6YZYVD44JWRV9treiydauOm+NVsKGqxrcwxMS8x3EdaHAIUOc8
	rqWmD9n23mYk9hnqTP5VdsTclZfB0cQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=Xigasop1;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FvytbuZD;
	spf=pass (imf25.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362731; a=rsa-sha256;
	cv=none;
	b=Hhwm1MclzDIkSo1LpRrLjH5a4zM6BYZTsJfpxhZYVOzxL1vMTLcG85nSei1CdafWakqgnh
	T23VqVj7ffRl8C/3OmSt/aUoaTMLyafYpoX5vzkOJggSHM6gTh1KHXVNsqPriyvq5QC1Eb
	DMWTVloFTCCAvcvWldIZxDSLG44JZq4=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 723A11301B47;
	Thu, 12 Mar 2026 20:45:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 20:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362729;
	 x=1773369929; bh=R05x33rqt4D3Op1mihSzRwcI3EKvb6TFzzswayv/Ksw=; b=
	Xigasop1MFc1BQXQk0iq0PfuDE5mE+cILrPFMrDYi2HMs5dOR7m3kR60PFE0o//D
	aw2w/JFsCcl4UMgrADlcOW7LnhmzPFw08CFCSey71EXkDmErCHEi+jV1cGpk00Ts
	tEFSho7APavmIZUF0dMzV9Gkq78RsEPr1fAJ1JQVkbh4z/t24eBjVMJ2iQ2FDZ9Y
	7ketqCAapUiVN1O9T16DVsGZ/8cXOCWKejAqG2k6NgW2cxG45qPNMJl9IPFen5V/
	orYVj3SFsDH2EOV0JHX6QCoGsJzMb8M4NMZohb+vDl7P5TEDtUi5kJP2hvJVYvqh
	F12YY7eWyASDT/+ROxjrlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362729; x=1773369929; bh=R
	05x33rqt4D3Op1mihSzRwcI3EKvb6TFzzswayv/Ksw=; b=FvytbuZDDevI4Y9VG
	JVZqSJMtkrWNxz48lVJmr/EpHNXAk7GWlVs1oWlFVkAQTUVnGKy2Dbd3N857jru0
	c2IoXqdFdnReDa6d8K2oodMGlOj8GCefMCv+cRaC7IjCCbbuTZklNYoL8xRuYr0F
	g2vk1l3mBLBWqC3Ym8bfh90KxjjC66/YiXzk0siKTVi0/DIYZnRN2EJqa02yyRpS
	vEs5fDDK5GYYr0uCIn0BmwwcOxDjkV0BR9kEP0Sn1Tx7ezF6Af3gnhuCMP4Z3sz8
	vaPSeIjskEaJHNN6PGjenL/R1IF5oAuSRIvL/OBiCSQpf8gBGcD8V3ZV2/2ls1h/
	Ycpqg==
X-ME-Sender: <xms:KF6zaaoXWyZZvhY17htT7zTbbZ-fm8CiLEK9cz49vqGCyRAGAG2lTQ>
    <xme:KF6zacWJYv-sR5VYxTujowgTH2C6epaXN-cWDG2hNB5WXffMCREy4Gd0UroqlHUIx
    8IWlVwgW2p9hrl5l1KAYxi1GmZGEUf2actXDGLN7gPn6aIT>
X-ME-Received: <xmr:KF6zaaS0qRJy-k5JF-BgDVTm2ja4gMdS4iod8uhA844UKEHrZelDgpUDvzhU8J1K2bLmTfoC0ItOki9ZteHCgRVNq2MI7NsQsAkoGsr4g3V5>
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
X-ME-Proxy: <xmx:KF6zaXUhNuWqMfOt-q70hBBhYgBzxQMIedAXB23XfOhHI8JFpA0CSw>
    <xmx:KF6zafZ5LywNiNZDFY_G05X1qY4SJi5n3Ozd5CPSA_E1FksrMGHqCA>
    <xmx:KF6zaV95xMcxOp7quDaX0mMEYp0Wor0o8Ltj81Bg-KhFqYDM43mTrQ>
    <xmx:KF6zae5fT0BJZzWHa3X9lFqgt9O5rUax6R5oBVr3uScE3ddRI8zGnw>
    <xmx:KV6zaUli0x3NBlCHJrCPno_ViJshrj1ZG14uzpnRZbcLeJpZod6RSQsK>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:45:15 -0400 (EDT)
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
Subject: [PATCH 29/53] exfat: simplify exfat_lookup()
Date: Fri, 13 Mar 2026 08:12:16 +1100
Message-ID: <20260312214330.3885211-30-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 70B9BA0007
X-Stat-Signature: yqf854phci6jx89zxygbmwfgbeab4ztd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773362731-292925
X-HE-Meta: U2FsdGVkX1/xjFZjyfBnBVmBN9X3LQtQVJn5K/XrrmY6hHPcyPwRb4UjNxLC/2sVcpFfEA0993a02zBK16+bXH4gUyhwVvx73GvY8L5ujdhdJuJLev4vGM9LkyQx3+Vwx2eNuSRpuJLJXdl+Thaq71JHqHxlocCYbzDAc6llV5dmOxMcKLpi1ZExXH+OQ6p98wIhb5G0tCymwf3kQSG01A0517S25jX+zpvrr2Jcz3cYHFTpZDIqw8L4WEmZZWFDEY6QHcs/dwgDhieI4e+AHrKCXA50WsKXpBQ0ac6GIjjrJATclK1fK1SDT8ckhwI6eRs9mJ1LrD6qSQIRC5KA8JU5quZWcJFo7Xzp+SKtnG7jA8EqE+upJwFGuOPeogxNnt1Z1vFKnTW0mb2klErnlpOaE05PsaAumQShNW4sFW9HExhLkEXf3GR/NxLdbg1uO0V9H3mGTM/+cPwFbpX5JdSK6AkA1CsY8KhIouZ8RNgrnlLyLPeI1tXajJjp4FHDkBhg5eHUPdj5HcGQ1tVv3MUDwDPnbMyv4bcPBn5R17n6EpBFJRZvch2yccTi+0kZWKemWJq1IjXGd9TxG5Q3M60vqsIDpGfHJCLHlveyJW+HyPgfyOj7eCFd95Wby53TzY90tMo3bD1PTWRW9jGvbSSZQ4Qrw6uPaMAc4BBZrRyB5QLphJBYX/3j++B0bDiGNYfJ446PnFWFRPBh5pOkdWTVbZPM3bK3I2r/Idl+fnNeu0BuwgJD5ufgE4fGsw5UQc2gzmWqgkXjWwv5EtG+WWPEWX7XI2h1leoaxrHV0B0a4jMuHMoxSBpmtkzf2W1ug64Sgsy2xUkmKLRelWdXjIFIwemOY20WYT7hC09qmwhvehYheMGpELp5tH4u3NSF2k2D9CB1787EGHoofR8HxLKobnmhBFrCg0vUK5VbqeXhrF+ukMt5ywEtQXpkptj5/+WttL2AcjJy1PC+Tto
 mo29aB3k
 ifWF3IPVHak6gJ5mEmLqjz76RhdR3ktJOEyhozIoV6MEeYG2Em0o9ozADv+xspWnW48hIFkT5NRJbrx7BMZ6zo/B7LphJrMaOLv4DT+cuBrXjidDk7Eu0YwMElNXYSC9SHjqowShnQjhEOoo0tWSaCJntOqDxAD1eQUSehIUYCN7e0upefEtnP5n7gYw6FzBQambWe7DAdiNEWXJBGloAOq8RlebSNJzVZhzqQ8xmjP+BSgPQNcy0oZRthO+63fd3KKKVrS+hr5sNF8mwW76XUQ2etDwoRDEo2M2IMRKEFx8IzXGvUzSUi3UUr1ilJ4hD9L2Y0vl+hImeAlEO0Xr6kZo5IY4ubC+d85ZcRQ348XCp9mfbUTyStxh53hiNIZSSQhnJ1vq8xzCbHmC9WTCmXFke/msRQFeu/f51yrEP4bLpYdTCA/XmBOqx2X/ihDtVv2xmZuAzwZolRbWzEkDlX0hTBgatzwm6fRJhRUX0AygkbWQ0Qp1s8U17ZGEggpr+SVWETqtAUvxg0ACDonDyDBO+StnX1plTAS5UUdLsmY0JzVHecQfFISA6Qzw6Zl00aEqXk+qHETugtx0bvxOymU1L3PgVEao5/JCZW9LFbrWKjFZhyekG+ZKS0K4UOmwNZ9DARxfmCN7mCIJl1aABShmxsvR89VbwRI5unvqJqPaXRfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

1/ exfat_d_anon_disconn() serves no purpose.
  It is only called (on alias) when
         alias->d_parent == dentry->d_parent
  and in that case IS_ROOT(dentry) will return false, so the whole
  function will return false.
  So we can remove it.

2/ When an alias for the inode is found in the same parent
  it is always sufficient to d_move() the alias to the new
  name.  This will keep just one dentry around when there are multiple
  effective names, and it will always show the most recently used name,
  which appears to be the intention.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/exfat/namei.c | 36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 670116ae9ec8..e04cda7425da 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -711,11 +711,6 @@ static int exfat_find(struct inode *dir, const struct qstr *qname,
 	return 0;
 }
 
-static int exfat_d_anon_disconn(struct dentry *dentry)
-{
-	return IS_ROOT(dentry) && (dentry->d_flags & DCACHE_DISCONNECTED);
-}
-
 static struct dentry *exfat_lookup(struct inode *dir, struct dentry *dentry,
 		unsigned int flags)
 {
@@ -750,32 +745,15 @@ static struct dentry *exfat_lookup(struct inode *dir, struct dentry *dentry,
 	 * Checking "alias->d_parent == dentry->d_parent" to make sure
 	 * FS is not corrupted (especially double linked dir).
 	 */
-	if (alias && alias->d_parent == dentry->d_parent &&
-			!exfat_d_anon_disconn(alias)) {
-
+	if (alias && alias->d_parent == dentry->d_parent) {
 		/*
-		 * Unhashed alias is able to exist because of revalidate()
-		 * called by lookup_fast. You can easily make this status
-		 * by calling create and lookup concurrently
-		 * In such case, we reuse an alias instead of new dentry
+		 * As EXFAT does not support hard-links this must
+		 * be an alternate name for the same file,
+		 * possibly longname vs 8.3 alias.
+		 * Rather than allocating a new dentry, use the old
+		 * one but keep the most recently used name.
 		 */
-		if (d_unhashed(alias)) {
-			WARN_ON(alias->d_name.hash_len !=
-				dentry->d_name.hash_len);
-			exfat_info(sb, "rehashed a dentry(%p) in read lookup",
-				   alias);
-			d_drop(dentry);
-			d_rehash(alias);
-		} else if (!S_ISDIR(i_mode)) {
-			/*
-			 * This inode has non anonymous-DCACHE_DISCONNECTED
-			 * dentry. This means, the user did ->lookup() by an
-			 * another name (longname vs 8.3 alias of it) in past.
-			 *
-			 * Switch to new one for reason of locality if possible.
-			 */
-			d_move(alias, dentry);
-		}
+		d_move(alias, dentry);
 		iput(inode);
 		mutex_unlock(&EXFAT_SB(sb)->s_lock);
 		return alias;
-- 
2.50.0.107.gf914562f5916.dirty


