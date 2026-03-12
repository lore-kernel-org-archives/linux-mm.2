Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B83106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202D36B008C; Thu, 12 Mar 2026 20:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4986B0092; Thu, 12 Mar 2026 20:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9BE6B0095; Thu, 12 Mar 2026 20:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F22F96B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:44:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6B401C7AD
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:44:07 +0000 (UTC)
X-FDA: 84539192934.15.43DA472
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7553120004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:44:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=eCvS91w+;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="VOKUtq/0";
	spf=pass (imf29.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362645;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j63R+vGSqFIeC0SCj0jcb9BcsciO20wok4YExEEnIuU=;
	b=REOEUCCSG3Tz9RzgrPOkjtgtybNYX37ouwCiflQ7e4ffBebxnCl/Wr02vdKBf6MWkMyB/T
	iFi+Fd/zVZQW1DCKevkiHoI8xvTq3MKMZWhkC/g9cQZf5s6pjvZx63fnjQrxzwkzVID/Uz
	k5ZBNFwcPkoZeI5dUFjl7bw4T/ZOJmA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=eCvS91w+;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="VOKUtq/0";
	spf=pass (imf29.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362645; a=rsa-sha256;
	cv=none;
	b=Z+LZTVxHj0nKIMidPf2Z/IzRVgPvOOGdYDZwh5auX546OvQZTezHAoWauRDSDiqadjXjeM
	mYt0TeLj8WxCl5NJqKrUjxdqzTG5Zd7R6zFDi+nAMcxBqD9so7UkrEyalypXtIbxaTEp7i
	diVcH68udrknwRCv20el9wUAAkqqqjA=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 9997B1301B2F;
	Thu, 12 Mar 2026 20:44:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 20:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362643;
	 x=1773369843; bh=j63R+vGSqFIeC0SCj0jcb9BcsciO20wok4YExEEnIuU=; b=
	eCvS91w+DhWkcI9jjJdNUADcxRGhElzytgMJasgIzKJtuooXaIh3KKja0pUFfX6O
	fgYAReRrX9HpVO7F12hftQ0cSIl24yo01gvuoWwgQ+0LBkoLFsR05RvwjsbQ/xGe
	TARIB8LZx92xUD+U+XYJVZBaPlMp/mwNUr6o9DINS6+42ydzcFDjycZgH68WWE6o
	C3GjVtvxBt81M8NGL0of9lLYsOHaaCljR0612e0zlQfV27RuAQZNtF61tH98aa3Y
	SztxAesntkfAUiZ3e07BF5twMFIeG7LcYeif3ZUiOH9o5O91dPmpaZ9mcvHyC7F5
	pzd5Q75S3kEWTz9D7gVIYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362643; x=1773369843; bh=j
	63R+vGSqFIeC0SCj0jcb9BcsciO20wok4YExEEnIuU=; b=VOKUtq/0Ox3dCym8N
	La/hchRjt+rNU/iyTLG4kwEHuMKD4y3a/JkwzJH9LuB11f5JIetBBVHMt9ViJypU
	UjyLlnUHckM8bh9QjAY4Jyd/C7N5jwudw1JHDUa9iXFd7am+GANyEnLlgi/obehc
	ULSfiEhaSLtneM7w7UNW2TpbgbwcaZ5Y83VVFAz+dm25dDXamEX/5/azTn0wR4rH
	T5eikG9cF+xC+X5DUfa2srcny2SiEQpjWf7Wv50KDnPD1IC+BRLh5gtaUkd0Xqxn
	q7lCrpBBSd1OGWFQIKyOZeBKLnQT8rrdPD3KtmKkTnMRm+b0/M3MehJ+STL1Wogh
	t4YJw==
X-ME-Sender: <xms:012zaShtjFWHYv9HOGnqTxWKzw1vnA7StjckJwiN2A5XojBB-F9JCA>
    <xme:012zact3Dt6TPh_zjEgrQwDsyr4DDxrfYJ6cn9riTs_e14ePaC1C59ywk8575wtIx
    oCoyXSmpvc2QJ7FHiKkN9vyQBEYv-8vxOZoFw9Pf5SKSJTBfw>
X-ME-Received: <xmr:012zaRBDZsBNJH0PilDgngT1D_tzQ8ozHN_bDcdw-FMo3b04ruKTCh0syXRWeolXCoApwXWT2_5U1Kk96nnuomeQn0TR05_drdDWBLwveY1h>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:012zafUKwyL0OuJClu15Puc2ys4KgwTiMGJwcET4JsKEaucWrW0l3Q>
    <xmx:012zafJP8iVeo9UK7ccWbWNQm9a4nXPYhx2VbUK7ny3vfppuOu7x9A>
    <xmx:012zaYXOH9KU6qbd-du9diTet8tT6m4DrmZSp1YTRJNc9aQpNYykwQ>
    <xmx:012zaYRD_17YWDi-EKB18x17U_SFvVAUAN1Enot0fJD4HVRO11zFbw>
    <xmx:012zaYIlDd2v2et1x5yz_VJ7tc4OmMkzO-PwjDx9T6vNixAjsjCKsyLB>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:43:49 -0400 (EDT)
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
Subject: [PATCH 34/53] tracefs: stop using d_add().
Date: Fri, 13 Mar 2026 08:12:21 +1100
Message-ID: <20260312214330.3885211-35-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C7553120004
X-Rspamd-Server: rspam07
X-Stat-Signature: ci3mwncjfg3sy6pndthmajiihjt7dcj9
X-Rspam-User: 
X-HE-Tag: 1773362645-83971
X-HE-Meta: U2FsdGVkX1/MXIR3vKj8PD00OUMy1LFEh94PSwLBTps29mVxWvAFKmPRsYTU7RbLlND7aI+e/AnKSkIWdWKxVKve4F6nMyJpXJIXjiNxof2N7AVLTPYdgCzUcfrlLcPNgbcNuC60+VB4OppXGPfjzrjVNpvyqkjudVBQNv9WlkirxzpqZ9ZaMDOJekmWcZED1RRgiJXs7tcv5r9piEAjr4rlVZTjE/y6g59bKqRlVvalJC7RIKmzbG9ADT5lrLxXquPkarOc49rDrfS41IX9c+qo8K0lhj8ThL9hbrV0bh1UsSmCZroLA5DI30wZRIXK1/+23gi1imqX3b/3OKz4rzWddwSAZ7aftWiCsB0biDqFCOF/HVH732SoxSIt4fl+Edqw1uxWl2W5xLoPUbZQdSQTQWgljPD2pNLNnJ//ACnc9qZ7uFl5KkMnIUMaAyzPNBLAYEJgxa/Ln+jRbwdf8x+2+ioo4NYYtDBv9QJPj/p2DbyhkAkLV0HBR8NbRJ1Di2OohQCp/f3/pR1Sg4CyajREAzvxoGe/G8bxINUZq2/qObwbnh8gjyki9M0xDKaKOIcI18oe0smjBzAfXyY7ESKUQImEmapDSwndEnShQqXOcOzxQO+ePW2YAMKxzRY8COELaXV80KTtZ01sHnBL99w7igUOBe0if7V3bdao9ZQSnR7f+q7CpGu4t6khvlY4/XAfCJA5Ov73IpqGTqKuffLZ7QKJFFItV7/pIq2IjEw4Lu2ANP/aA79QRRSaLM9reEqPp7J+BVOywWjDvJCpMGlmXf86aeJY7K/5gXyIhbzTy/5y55pn1flpt1c40QXi0B2CldZHwLsYCxBTfJIMMc8noGtBkYssmP5w/jVtLRN7Rtw75v4COBV3m2QAj3GGIm7jssGr065NbbttfbcJ0dDe2hhG1aryIRydtITLdYBs1tXt2PUqCDyZUxlehUs5tvNOi7lPHsnymk3OVEY
 I9HagZLX
 pvdMlYVVau78sXmL0vbj0lV+OBWgRI79x5wWgodQl0TaSRtN6f5nwimkU+QCjqxw5qSvwoGMys+1bF8TDoyfDTVinRqctQLQ3YA9T7b/ikjJ7M12YST7SVvG/cy/40YjXZ6lo5bRRq2aONj9/I+9cl7HNRLhqaE3dEcw7VTP678jtp2zNAMxH8nmr24ecfKJE7esa3nJeKDoJpMVgLJQ0pxVr6luG8ibAppHPNGupDpJoit0g7vOd70xdbta/c/fl+AoiMh0dUHHjeYsEDGWb7ts168eyMPENUDZTx0ja2PnmMOxFsULSdBtVEJbxb1Z/vLbVZL6OR99CwC2/W7YemrqoYeXv5GHIGoL7VkLwuZH4e7w/uYv+kvoWjOm51UU+Irk+5rhmff5pj3i0IJ6H9Tb5A60RY3xcQI0LkeQHQXubQiCIwh+2GwkRC/xKu3wobEHhPKADSdzb0daVIJr1B/MMiUWb2nSqk8F5G811JX6kl4/tn4G8Ur32PC3c4mdrVTovzN4SyA1Dw+Ia/GD7E8O/GcQlQXHMIWcY81BKUXohOPwzCNenVt+rfUpL3rW4wKmFN0d+giolLtL6VsmGKqijnTY2s3xE50+PBIl5vTJF745iAIgl3kLd3i0Vd2+SlMoI60qP53pd78Rd5Xy4aJPSVZIumIkX9KfkNYdMeWqaIg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

"Best practice" is to use d_splice_alias() at the end of a ->lookup
function.  d_add() often works and is not incorrect in tracefs, but as
it is planned to remove d_add(), change to use d_splice_alias().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/tracefs/event_inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 8e5ac464b328..c30567b5331e 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -393,8 +393,7 @@ static struct dentry *lookup_file(struct eventfs_inode *parent_ei,
 	// Files have their parent's ei as their fsdata
 	dentry->d_fsdata = get_ei(parent_ei);
 
-	d_add(dentry, inode);
-	return NULL;
+	return d_splice_alias(inode, dentry);
 };
 
 /**
@@ -424,8 +423,7 @@ static struct dentry *lookup_dir_entry(struct dentry *dentry,
 
 	dentry->d_fsdata = get_ei(ei);
 
-	d_add(dentry, inode);
-	return NULL;
+	return d_splice_alias(inode, dentry);
 }
 
 static inline struct eventfs_inode *init_ei(struct eventfs_inode *ei, const char *name)
-- 
2.50.0.107.gf914562f5916.dirty


