Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C89106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052F26B00D1; Thu, 12 Mar 2026 17:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C076B00D3; Thu, 12 Mar 2026 17:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03E16B00D4; Thu, 12 Mar 2026 17:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC4936B00D1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:54:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 816A71C066
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:54:50 +0000 (UTC)
X-FDA: 84538766340.03.4A4B2F1
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A0378000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:54:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="R9VPv/zi";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=lvCNqQrx;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpyBzrNDFKyBNYiy64/Yla5qtyKgmTDryIXyDQiUsjs=;
	b=3Ha//Ixf9dVc+6CMeFzIGPhpdSFAkIPGN9oUBWOjnErqFlX7HQ4+ncnyImeMrvrEsgOEft
	Rj7PpRdKsTJGrvgfRmzZmBUS/5FVEnefCeCPbahNo/lLs58HzZijlJ+j6pOFwzBsCIFUKJ
	rkh6IEmwnyKxd3F8fcOLTMOSmKEo9zQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="R9VPv/zi";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=lvCNqQrx;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352488; a=rsa-sha256;
	cv=none;
	b=JkBqB8Vqqd8wP7DeUbHlmgkwLkmML20lb2tQRxMGoG7GYKLROaJlWEsFmXTkau1iZY/ayK
	dNUftNza+MUZBSC7bzW6OW8puC1z65mjAPP1aiTxkO7ocjjgt9cA0bm9mKA2eX5/EnbP0x
	PrPn8SaZkPwQs6s/nyo6uPYOvWGDS0g=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 897D11301BB1;
	Thu, 12 Mar 2026 17:54:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 12 Mar 2026 17:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352486;
	 x=1773359686; bh=fpyBzrNDFKyBNYiy64/Yla5qtyKgmTDryIXyDQiUsjs=; b=
	R9VPv/ziHvarZw/AQGr9s/6SlcupzBGjtLFg1jEyRvdzFV/RJz3QlbiVW9PogxcB
	uq19ftZqv/w/QB+pWd/PtWQzykeuu9rN81RyybCP7p3uOes5ycCdcxkqVLcaFgPt
	GbQUYu/U5zZS8o5E7pQfGKiz957WUj9u86OrYOiA2bVJEDZlUx7NES0TytyApQGj
	x/jLnyCWW18lBbJSw9b8gm5gl/mwwM9pz1Dw/lA9mL8IRMxgFcmDqjLK7IMbs3Gc
	bPfTT5o+RFQFgP29SGUNKI8B7dY5Gskl7wM8hscfVf6RYD+N5EHvFqkJI112v06w
	cZ0Y3KvOZIJXTgIefJVRXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352486; x=1773359686; bh=f
	pyBzrNDFKyBNYiy64/Yla5qtyKgmTDryIXyDQiUsjs=; b=lvCNqQrxDQEkh9EE9
	DHdnoLQKJXZuHP0lw6gbA/RNYrUbKF152er2Ht3nW70QAjga1J49zCLwHjK2p/Y7
	BJswoCBt0LZR+bUq+QMqYPbhP8R3Xp09DwafNs5xNgE3kD5ZV0k+BJq98zKU9Zqj
	sFQJ2d+d7F/KRlK06Vfv/0SRfilvI/OTiBSxO0HngUIpIhxrNM9wM/PFIIuR7uOL
	15ONu6WzjQxb92eSo1if9CPu6HIkyIhlPYQFlroJS4Yn9zoLdn+2uv3griNSBuSn
	VQ+9fPyb/vhGnCvTBIdeahqB7kgmyUz0Xfp3NYe+xhSZqP+PK8CIlW8j2sDwrak8
	c88vA==
X-ME-Sender: <xms:JTazaaLTXPY0lW_r5GxWLpYSTzZ5XIG-MUtCmLGSJalAt0Jxt-kyJw>
    <xme:JTazaV1ioHfFOkoiSkUr_kki-xWQBmOgK0GpLQQ7JwYno7HKD4ZqE1m0UTqHQY5i2
    BikshymDZavbsnTX2xSE1OYswjqxBYqIrl1x3oSfq7smMuCiQ>
X-ME-Received: <xmr:JTazaVx9t1HsoGNgk8X-449EYfPcde2N9cnjcQzToEYKYavNbdKMFm75TaYUFpRbM_tgRnvf4IFotsd1JHwWkuMEGOEvbTp0lKedo3rUiPKc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejleduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:JTazac3nCbojWLHfcxWBM7ihJmqwG17cby5TrKLcC_09xB10S5Rc8Q>
    <xmx:JTazaW79rTcZoSvXrQoLretwFpAtB_DfWpj5iEv7u5-3O75zoLz2zw>
    <xmx:JTazaXdDYJlOMSReScUwwg6IU3z-cDWKKve-4kemj4-Cof71M6Nm-g>
    <xmx:JTazaSb8VZWu5_vRWHgPSmkV8kGIrlJa9-c-i9_vxto0G-p2SRPELA>
    <xmx:JjazaaU3cuTt1axgUaJnB0tCd7dxg9-0mSMffoYD0j9ht90DvG8qbNQg>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:54:32 -0400 (EDT)
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
Subject: [PATCH 39/53] ecryptfs: stop using d_add().
Date: Fri, 13 Mar 2026 08:12:26 +1100
Message-ID: <20260312214330.3885211-40-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5wiftx75w6dbxbxghf5e5hwewf6f8g39
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A0378000C
X-HE-Tag: 1773352488-929872
X-HE-Meta: U2FsdGVkX187H4tCEKOlkGj8PA0XKM4Z6Er8DP0XNcgH6QbramyiaKtePJo6Kwuz0BmHQKGSgzMmKvP+x6nLOhdPzhM94vKLkwUxO5kZC7Y/XsNEBQwvk8vgAC8T24XUJeQRaX10qbn6Js7XnFuvcgUENG3Xpq+rVL4u46RAD5zPvymh4wOThR965dbX5/jwooUtSag/Vl0zBw1GXTGOaHfJ28rBG895cI+WOcI0pBWcJfkKp9s0gYEQLPFiCot/QcV8H+1gVzdkM6drex2Cyd2X0yn5OpuwIkG9ZnYwVj29/IkaiYf7R2Bx1AvOx1+AC8+Z13zV8LsTith1iA9Nv8GHUjBDmvkN1SxFT9xAHVNw/V5XTtDy1LYBHsY+2IkAUvBu9GCw6xTFoM9fiaw+mVOYWi1clayEwpDpoHsRYNzCJ5suj9ZMWdFUvKSUZUczTLqE8+qeVGpA5soLgyLC7ejEGUmPf0bu7fGt8QHH9JAEQWTVmXfyIjBPH5n2ZYp52KAKRF0YuBV4g4maHHjh62725En2I+FDs+orr9biVkUvIgRK3oxD7goZjrQwUJDS+UQs5T7kQWDlu+aPhMOdD8cskSlH1lYemIU/GlojN/sct/JRdFTy2XaM3tJtOiFoQ7AMSJl9UOFfrK/LxypOc4PwPq8N+f1zXoQipfvyN3rdPWigDD5ef7AxAnah6d27Lv4asL3AKhldi1iSNgJ8+OlAJFq1m58c4bkho04yxTh5u1IiLYNQAP3hphAzvYcQla1kb/CLe7l4xGgRRxLie8IuvJe07P1/cwLFg8lKm93CpY5gA4663ztvqC8hFle4EgqJ6TpnNr//pbbIJBPpwcoY3uAk6msq+RMskztThcxm0HXAzofpruqUt3i+1xU7j1YgRsJKUlWNWNYKF+Jm4fg5Eo9dYVWel5McrZgtrqBPMUe1IhsGTzQGRD9GlaO4DpmSWJsOTUi1n2TLuzk
 6TmNwgFe
 fblLm/Urxk2OpPQWsaniIkEcKMRHPx05ewvh4KcdUHkivcYo2JlTSKl/HlWwqi3TTwxpcle6l4/j1aGnOwFe7nWwHN04IHa5NRk/fYf7S8r87LNB5ICyGiUgjgmWNWJVp2phV7Bo/kclzglNN2dnem5PBOSVLVPK1FcSbKfdNMLBuTvoDzh2CXYDeKwS3OAq0Am2CSgYtcxoPv/H3HJGNc9zF47YifVE7AN1Cxuz1eh3o5M03VIHhDlgfrNKwofw8pBtVV0CaQ2KhnqaEN/1hO1x/xbQ2ezDg0tZwavHe3DbjHNeZrqhXzJu+7oexIs7c8qX6D3YCdUnqjoJ78ae/gk5NoDIq0cwa8WVJdxp140a2zvRd2BJpW0PkkGtsIx58d7pp/hFhnH8x8ehyB0LnCpLyscxj9Cg/kF9S8lTug8vvrnVTAc/FEIc1QaJ1FpIj6bBrJM0OOfqKKuzMhlfDlsuppG/mJUM3xP/fJkjq3s5OmHXxg0LoNrmY5AStj8afMul7I7I4uCWwn/j8JhCRo/BJhoOPYxAyBw6Voc5fpCsueCCXbq26KR96CZFWWY3Er//vgpwesMvar3RWPHHoG0fWTf34O9EO/359BVDUT8fbU+px02VEKrTe1DCkiSg4i5u9l/kt/EofPxikFyN73QFYZOIxfEeTqRLhCHB7ZHpqgS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

"Best practice" is to use d_splice_alias() at the end of a ->lookup
function.  d_add() often works and is not incorrect in ecryptfs, but as
it is planned to remove d_add(), change to use d_splice_alias().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ecryptfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 8ab014db3e03..beb9e2c8b8b3 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -352,8 +352,7 @@ static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
 
 	if (!lower_inode) {
 		/* We want to add because we couldn't find in lower */
-		d_add(dentry, NULL);
-		return NULL;
+		return d_splice_alias(NULL, dentry);
 	}
 	inode = __ecryptfs_get_inode(lower_inode, dentry->d_sb);
 	if (IS_ERR(inode)) {
-- 
2.50.0.107.gf914562f5916.dirty


