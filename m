Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAEB9106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B29D6B00B9; Thu, 12 Mar 2026 17:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181656B00C2; Thu, 12 Mar 2026 17:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F006B00D7; Thu, 12 Mar 2026 17:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA1406B00D5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:56:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BA121B7F2D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:56:17 +0000 (UTC)
X-FDA: 84538769994.04.DE171F7
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D31B14000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:56:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=U98BFMAp;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Uq1hO5Ih;
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352575;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNooXh8tukAy53X73o1gk7dQ7zysETg4G5i0zUIVsso=;
	b=GO7ntVZItdeEuaLWDE7BocBdC7HLcxujii9dvIJFqisM3BjtgbJMOOTEzSCx6NXr4DsHdk
	01k5u0yrWvCkfJrDmGej6Ab84M5KGllrBJiwL4Wa9oszFcaF7zkERBG9/gEeyHFn/gr+8c
	67q98KgCnbWeBfMbw7USV2O87OmleKI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=U98BFMAp;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Uq1hO5Ih;
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352575; a=rsa-sha256;
	cv=none;
	b=lYrZZmomv3r9zUT6IY/y0XukH/nC+nmOSoGf2nVjWL55zJxi+GSxr2TGSfrIMXXyiYO40T
	cI98217Kpwpe1UyPMY2vPseg+G7pieCXIznOGlcbKqrysw5Y2YnD0cCg4esgnhrFChUBEu
	KLHEBIT8IqxK+IDvG4d2NDytHVVYutw=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 8DFA81301BBC;
	Thu, 12 Mar 2026 17:56:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 12 Mar 2026 17:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352573;
	 x=1773359773; bh=hNooXh8tukAy53X73o1gk7dQ7zysETg4G5i0zUIVsso=; b=
	U98BFMApU8sYPYQ7CogFDzIo34fTbwL3/llQtmzYPZfV0pgMqsNO+ST5FrQoK5D4
	MoEqSp37f3Ei/nvhh9gnzQ0Vj/dJ+HGBU1MPmSCSms/pLVOoHo3pYMHID/m1+mT6
	9aGOMWmkzPKRnfmBMXDMCQwGUY3khdFrwEnVLosiNx0qu0sFoGPySVfbV3/3hJpW
	VyBVlf2kOBR/TXmXdeKGHAcYZkzvQi1I4xDgBdvOz8abEkZU06o2QQM70xCkKIH0
	Nw0rDMrPWZhx2wVPJUKPNXNp6cRn7jvsDB+AcIp52fzIkt6gcOhQ2zcmMdBhejxQ
	zm50aAYFzBWFIWO7hUiU6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352573; x=1773359773; bh=h
	NooXh8tukAy53X73o1gk7dQ7zysETg4G5i0zUIVsso=; b=Uq1hO5IhWegU28BI8
	tdXhi/CPmkZ7mOz+LkShu1oU2Xm2IdFVdV4/D9Cyu9c1dhFr6h1RwH8jyC39NHe9
	qWOS6s9Ci7FAcAYKjUGYJMM1qhTr7ZgUE8IQMq5yMA6kvK9cth7XAx8hSg8Hy/6O
	k8Gcv3JWxxdyfq6ZTwBlR8gmACl9067HX6Fr7XX0c1f2F9RYRFIRgdSedLKqQK4m
	bp2TDf5cQZsusRq5sp6pLqDfjaTZYakjOcWktAW4cJWMVPfXhQszFLr1NOsdh8dz
	p3Cb8COwX/iQRC5GlV6uaTyYfCvVeH10Fyw+vNSnfAsjFuzFbMTASPxaaKt8yEh3
	en+RQ==
X-ME-Sender: <xms:fTazaQCvKcgOfPynB2vf2syc47sQUi2N9jdtJmrJM51J6B5sgGFB_g>
    <xme:fTazaWM9mJfHxSvtWo8a2w1VRBJQjDxKJoImPoKNo68DwB56LTEqeGxvqYDzGPbuw
    vsyDoYLMaQJABne1iik5He1UY_vg3gahZXR4SM2cqZlRmCCoQ>
X-ME-Received: <xmr:fTazaeoij7oInvObC8rUmBYgYIJGpebYDqRsuuvwdJ1yQ9pNnase93-zXmbllRm9ZNS8J6ffsfpojXwGL3AAs6RWhUXb64ImzsbftBjg7AvM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
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
X-ME-Proxy: <xmx:fTazaUP5gN-D4lirA6LzmVOxfRZGzc8xsfDoXI4j2DA06LwGD9K3Vw>
    <xmx:fTazaaxw2JFlHPp2G5UFctx4YbNX13W2oSSzCLuF5kZ31EyaL7jmkQ>
    <xmx:fTazad0IJSKp27f5u7czcE8bAcKqoY3ohFQ7Mceoya3vC3gwqf_nzw>
    <xmx:fTazaZSsfwh--nJBWI6X4a6YKlJKFc9VFs4ZjV-kDQLuqpQDRWNbIg>
    <xmx:fTazaeOsjXzpD9DbHcSr0M06EtmY5_eqE1q4W6iQ7ZsyUg4g1i2_xqDY>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:56:00 -0400 (EDT)
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
Subject: [PATCH 44/53] hostfs: don't d_drop() before d_splice_alias() in hostfs_mkdir()
Date: Fri, 13 Mar 2026 08:12:31 +1100
Message-ID: <20260312214330.3885211-45-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D31B14000E
X-Rspamd-Server: rspam07
X-Stat-Signature: sqgendwmjh8b733mm797c1oau4bjfcsx
X-Rspam-User: 
X-HE-Tag: 1773352575-307259
X-HE-Meta: U2FsdGVkX1+U5xqLHX+nWjNn9ZAORwWmo/D+U3hB+lCiLIxfuWl2WKDOPr7Y2DSMuUSAvXSFZO7RVS3VxVItTLwQ8nhYXuOpQ3ZGCVtt8NFyKOLuwzhKg5N0d1bi07VuiJOjQX0rlS8Q+YM5wY8RDMlEKLvu71QT5U4Cq22hksd0qV8L76FzCwpSDGMmjgQmv+NIM1DESIZFHJ+HdnTJlhhhnZeQwTX+vCdg2y0v8dBf3iZKytKNgBQo7gfoC2xv5ir/1f1lyaI6i+PN0G4DXm689dNFcCuQ4rJS0mRn2+UiR1/aQw9eAK2v8QdrU5FGkwdEoCbTaA9XV7FRPqJLvOZbszc0H8qR7ck31tzf5vL37M9yIRyjdAPJ8EfVcH1k6zyfjmvhIyb4VzbJRnH7kAxVxcSF9vDL5RH+UqTdJvoMvcrS3ss1DCNf8rZUqs7I6+eAfs2nsptg7/fmK+fpKo2uSvvlfa/ynV+XG90LLHRm/CNcUTalWCUIiDwFkoyyOKU57XPFs5KnBNAz2j4WFK8wbcE/65/Ji5w3ZEt148+D90s/B4OGgYPSB1RZhp7t6wW7zDnmsk7nJh2KCysN7qxEV24M+cMdGE0/vmILX4II4HUSYscJzLOJl3J7OvHgEHZZAjenSHubQojdVFVC29FKCmDxJ6BpHduRydbYQPunNKJMfHH0G6ebnJXLiWUHAO/3Zc7zq2TMuWaHIBagJyuIXn+xlu99lSofNb7MpnJHPVfVB5Qwmzl97XVL7Ic9op0WTYxICKMMD2meRF5L2+ZewzOyimuI6RhUeztn8I+qNrerIG0+ZeInX4t2Ar1HHhbS7Nz3vRE2tYZ9ZibzvE+scBqVS9cvaUYIIOylsGOclsEfAGoPwShFpbuI0+zSGUdAtWjLFW2d+Ebz06YRrk+DQ2rmgimyJz08X0aE0sUQbEqiXel+h/M1C33GubmAJW+J7INf7OfZWQ4ZTZP
 KVYfkzmE
 2hX1iT2hzWnpwfwR3LT7fthtXmRvYYWcJ1aqnnY5bSj2omWyRDCaWqNRy5/x98Th6NF+UsuLtrKtlJmKCc2+YISas+quTrQskSAp+FV7w5l1Q23iDJdS9S36gKHBft24wUB6MNLTuKwWt5CDskk4KvVcNouLwG0z+ZSfht5qK+gLQmSkKxJZR8VHPn7XpgxhPYAdRbTio6npsX1Vhi/TYrP/EWnHrwfx8I20podufiEOqqRdvSIp6h/aALi+smW7q57/S+aBzvS+E8CL10UR6CnPZyn3KKUJoqnFwe5qFOqBR3DvuiV8sbNwZPBzXh7Y7zCfkUXsVAxjTDo9Y3JCPzoEiujVe9/kaPCbbomfsOKI5oqyfGwkcqhPzzZVtl9OHjsjwOYT3iOW7QLl0cI2ptq9JE9hdaMsG1Gp5BCfyBmtA6DPhQXwFayRFNGIf+Q2yYiFvTPNd84an3tZ9W6imrQG9mN3agV+cY2xpWgnHjCaXNZwgZt4PO02uEYBWYnXU8rI58yN/bpuXLhhav9aDQSLlvuzO0B9YpiXmfSbLX0PK7B0yOwP0aCjsUl+Aa2Dk0Z99El9RHZVwP+8SvHXzkDUhgemFQyyhmgc08tQ7UQwUIHDsefchXnjFl37TjjOCqhpi2KEAkOUuVKwTs0lEP6dn0kmLo1NqUN05sYTbBqJSL/E8SSjdiYQ7cwgjPxXkIZZEkHQXBz3aq40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

hostfs_mkdir() uses d_drop() and d_splice_alias() to ensure it has the
right dentry after a mkdir.
d_drop() is no longer needed here and will cause problem for future
changes to directory locking.  So remove the d_drop().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/hostfs/hostfs_kern.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index abe86d72d9ef..f737f99710d5 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -700,7 +700,6 @@ static struct dentry *hostfs_mkdir(struct mnt_idmap *idmap, struct inode *ino,
 		dentry = ERR_PTR(err);
 	} else {
 		inode = hostfs_iget(dentry->d_sb, file);
-		d_drop(dentry);
 		dentry = d_splice_alias(inode, dentry);
 	}
 	__putname(file);
-- 
2.50.0.107.gf914562f5916.dirty


