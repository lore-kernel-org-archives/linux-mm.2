Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FC1106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07816B0089; Thu, 12 Mar 2026 20:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1556B00A5; Thu, 12 Mar 2026 20:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDF46B00A6; Thu, 12 Mar 2026 20:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0CA6B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:46:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D7C01A04F7
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:59 +0000 (UTC)
X-FDA: 84539200158.19.6EA8DD5
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf09.hostedemail.com (Postfix) with ESMTP id 451B9140012
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=RNXQe8RC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=wfskezN6;
	spf=pass (imf09.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362817;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3IStrNmQd52sbuvLJgTXGgXoqLBL9Wr3QWVkKkzQVI=;
	b=L03Pu8bztNgt21T3gjFQgI4b9N8/dTHXMLpn05HqPzCJsN895OXacnDBfAglRABASdn9bd
	soTWY7sNyO7Z5iyCNDpWBmB82aCYdz5ISfl1Zqq7HCIDHZt6zW8YTN/hnf64DQo3B29WIN
	q78sOVGoLpZPo4kKGpKFL8NLc/eaXLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362817; a=rsa-sha256;
	cv=none;
	b=r6OBYyj2hspEbwm7jgN9T77QcW0shatHYP4y/rGEEvVjmsY3I/yKQ2bhdES6HcCdheZmkQ
	hrSLRvBQZXx0fpBvtU5ETlaaNCr8oPIJ+vmonSRraC5cEbpBB6RtYjSF2DWUg9l4pxpn6m
	s11/yL1bg3Fn6H9cuUoFzzabs8UteLo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=RNXQe8RC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=wfskezN6;
	spf=pass (imf09.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 605B01300BDB;
	Thu, 12 Mar 2026 20:46:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 20:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362815;
	 x=1773370015; bh=K3IStrNmQd52sbuvLJgTXGgXoqLBL9Wr3QWVkKkzQVI=; b=
	RNXQe8RCRsLKMGTZv3GRKZahOC0IxxlJic/ko0MFy4a1ctyXK6vvz4ReaSk7Wtb/
	mAzGCuXrdmdZBQIRLvL9TgyL2qlc45O0kQ3l8qXW16jE7P6d9LqJCqRvPWC/uzxz
	Fg4Z9KDdzbQTjvMOHVIfVhzYLGcWWMkbkuEXMLMZZKzxUaOV6SPZtD3+P7r4CdlO
	YReiac+iMDhQdyLzaO6kSMLbrOxlDborVcCeQAMrmsrVMTfxIzMeSF5US+w16WfM
	ACO2ucwH/a+sdYpvVApyX2BOUWYS4NgQgEXOKZ4Urg3/g1TPjzQe8VBcsJ455SzX
	9KAVhZnChtKP/WL+6dyBwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362815; x=1773370015; bh=K
	3IStrNmQd52sbuvLJgTXGgXoqLBL9Wr3QWVkKkzQVI=; b=wfskezN6avTEhR19Y
	nyFK8EjU0/MMk1mTZsKRrgviM3fKXxJNJu1JVFZMcMVBW/OhFGdzQV2zxrvMHOyI
	+wsRPzWoNSHHCaB3Uz6Z2Z50+4HPTAToivoCuItoC7GdStbUhlwIos6CNfKYetOs
	dtWj4+DVfGt5fqQnqBjG1Dqg+KH1ydv5G4O84e2/iXhc9Ryvf0hXvivBdRiWWVUz
	ln4nRLs8aYjEr1bv8aqsemzU1pcoJrsa+DX022p8AWsPy7cwqUau5yZRIa7kTqSX
	KkLiJjVMjxGllDLHldeMf1HfZBS49/IiohaDFc6csqGAyWyuyBEkdFBLfaeltNSp
	jBt2A==
X-ME-Sender: <xms:fl6zafe3S7X84lJOJFdshQFEOSrbddVEHmr1mw6S46GpGR2i6woJ8A>
    <xme:fl6zaczFa49e0KK0S015j6JpoR_5P68FmUDqY6WEQHX1cWMiUDEH-T7HQAfY5J6od
    qM5cWDNETWONPUtRpmNWTVHJCOl1xZ2rv7QmzJHE25REqnBVQ>
X-ME-Received: <xmr:fl6zaVfYsIubTYkOgpCpYFaYitUZ5oYFrWfnd5ZTirmi7nP4J0c0z79jLMuEwIr_H465ON1BCgxcqIa4aTJ0nwCIZ9blq-QRFlXrRlcGC-hU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:fl6zae4dK9r668Qiw8CvZFQjfZ31XTfKNmbrp9eUDoDMrazoXyD0fw>
    <xmx:fl6zaVaKGWkKJVt8deNozJ9QBXJAphfRuD5nuPx9CFBo8ryZkkpqgg>
    <xmx:fl6zaTzrXRucFOWhgAsf8iS1wX5cATadJaq7iOpt6RIngHxauV71uQ>
    <xmx:fl6zaSQ4lRJXRVAygVyvKtYoYqFXXoBXTgOtSlESq2KNF1VJOQLY9g>
    <xmx:f16zaVIP2rSOzehLw3_PK25GCy-IcS721ulaHNjDv3drFOKshm3Pavwn>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:46:41 -0400 (EDT)
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
Subject: [PATCH 24/53] afs: use d_duplicate()
Date: Fri, 13 Mar 2026 08:12:11 +1100
Message-ID: <20260312214330.3885211-25-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 451B9140012
X-Stat-Signature: huh34m4eun93chp9spbddcnuq6aoygit
X-HE-Tag: 1773362817-727438
X-HE-Meta: U2FsdGVkX1/8PrcazrHcoDlQ3w6K+UyOjicPmfEqMSa0gTswJ3dC8dRUVJ9PLxL3hkMPj8fg2YdyDpt2C92IjKFzPQ1M+0+VllzLhlrEjddfZ7gkDejDP6XdLFTxQdB58UQG8dliF2ferxDY631TQhIYqDS06sEjabPNju0S7a8oUxuAHcvakveMO8fpJG2oglj5BGFS9W5+RI9QaIIv2YVQmadon8YBIrzORHVjVNIMdP+bdO2YeCKgb37lb51vGVU36I5oqQ2gdUOjTWggZkqw5GJdyd+AdaddGHfLBKh7E8fV0PtGaPfg+pSNg8ZahzB0/13GEud36bsNbK8DTyolKPsB4WnMJnSqWEFLKsXgxzmywl4Xw55HIcCNFtO4MX68YvX+0h4JqKHbCRqJKXwN2KfqvMLEc/Dzaoui/JRTmPANzK5H1kuuEvjsypC5g3mCserxexmXDmOpYtIa1C025NhACqaNcHi/9qa2QokKMIDLsXk9uxnAodiPOwWb3/hnI1NBmUEVXB5r3eHmRV+tVF8rg6bTgLjWbdrafeG1v6lzAoruR9QfX2JM7gx2C03mRSiuZJKmRJUIdze2KDQV7l3nVMMhysE1u5VeCoqFYZeQpUnG2yeirDfQGZs1rVnG8S6WQtyScg1/UqymsShiFWksSvjXGXnUAakiXv4Km4pio8kjtHGsWbZa4olAKeWymFX+rCEnkD958IeRbpK0ykZoL2s9Q2sGMjnp/UFQiizWGrE2E41dY9oacQMXAdDiQ7z+A9h6p7N1eA2HkUQZRPHsQ6+u6CPKusBpGWDEt76Xkr59nV9u8XaE7G054zQf76C1+fwGhMocbh9jBK2K0+Q/vHLzRwN7/AVPQ/fUiYkSMy82NBArhmUV0enKd7JHNvCprl3x16OtJM549cJuz0twBjk2RLH5FDQgPsqbaiOi3MELDHDlagi3SZCrYqKCxE1b+9pH/tlAlGF
 S1lBmC58
 /VrZm6In9TB7b1m5xkUFutSKahzjp8iiO+QGn77Q/ygPOd9+9biwPCmk2GR/LGQxtD3a/kjJu8nhsHj7EYh2bIaAcdkm33zsvXjHK9iO82Dic2l6qkIOUlobZAwUvzDvcPMNefirTui6kxLVA2uggIwj2x3NtLt1pUBpjoDJlk/skrYSEdtJLktBWFvkwyDDPzmlD6BCsX+t5e0+/hnOy0CsmjlZ5/dHoym9uVgX10ak8kd3R/FZ5wvn+CBjQgnZqkY814z2LYqCCBgLU82g/fFVwTuhsnvrr9u8UBugI9vuHjQmQ3tijn2lsNlvcPo7zux2zN2ya7oyn0VSRv69uw0igH3LRcL6FGYJJHvZED+y49i8gzXLuUM9l20Z7qkz/AvbzKHy5c35A7enN6SkRvIVjj3oQuVUAnl6aRpiUxCxVRMQzltqItouKj9uF+ZU7/YkJP1R7hdqEi78+SFZDTetXf7obX4+xfu93THwu6f4lmJy7Z+ZPyx5F8miqHnccMzrN0Hz5Xmd8SJNS3XLRBZ60t1S86UDYavA0rIucODgWQP+om90qL614IUIQvhKCWeODA4iCoXHn2Q0SKM687UYjMTJQL/iziPQE0XFKvRNlmxeW5sknHi7BEjQr/doW1HSa+lYi39FHzwK1axjz2iIhI16+TsP9Rq61qf7TRVGz8VQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

To prepare for d_alloc_parallel() being permitted without a directory
lock, use d_duplicate() when duplicating a dentry in order to create a
whiteout.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/afs/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index c195ee851191..b5c593f50079 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -2047,6 +2047,8 @@ static void afs_rename_put(struct afs_operation *op)
 	if (op->rename.unblock)
 		store_release_wake_up(&op->rename.unblock->d_fsdata, NULL);
 	store_release_wake_up(&op->dentry->d_fsdata, NULL);
+	if (op->rename.tmp)
+		d_lookup_done(op->rename.tmp);
 	dput(op->rename.tmp);
 }
 
@@ -2175,8 +2177,7 @@ static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			if (d_count(new_dentry) > 2) {
 				spin_unlock(&new_dentry->d_lock);
 				/* copy the target dentry's name */
-				op->rename.tmp = d_alloc(new_dentry->d_parent,
-							 &new_dentry->d_name);
+				op->rename.tmp = d_duplicate(new_dentry);
 				if (!op->rename.tmp) {
 					afs_op_nomem(op);
 					goto error;
-- 
2.50.0.107.gf914562f5916.dirty


