Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF6D106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085116B00D3; Thu, 12 Mar 2026 17:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045B76B00D6; Thu, 12 Mar 2026 17:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65816B00D3; Thu, 12 Mar 2026 17:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D48056B00D3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:55:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A53EEB7EC5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:55:09 +0000 (UTC)
X-FDA: 84538767138.15.B056553
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf03.hostedemail.com (Postfix) with ESMTP id 99F9B2000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:55:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=LvUkteWZ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FJNskYCq;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352507;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdLbzmw/KSDnf0Z+kMRVM204bGIQfGT5DsH4LYpn9rk=;
	b=ELOAfLvm9uLG7kM2RdUf/qkG0M7oBhHR4nnlrMYh7cuOisqEE9XAGgseNGkicqzj2rD+hx
	mO0+fgNUJGcMS+53C39Mnpnz3NgsTaIObFj2TaWkWqG6kF9SM0TOhRXSJKX1Hhcgzn+pUV
	IJXiFvntXLA6pKCWojXHqE42zjIWXtw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352507; a=rsa-sha256;
	cv=none;
	b=tvIqwIPUJfbmQ6WMYS8SMy591GdkrJE66brKUecvcPb2gQKEPzjyYmREOWNpA8ayz/AyWM
	QWBC3NCjDs6QX4gmyMEwxV0mxcBEz/lWojJWt6Q8E9TNCMZRhGrmePENjl4wmXrGYWuFsZ
	tY7ZlujTiEWt9c0dI3lkLJujEVW01pM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=LvUkteWZ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FJNskYCq;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id A5B1B1301B6A;
	Thu, 12 Mar 2026 17:55:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 17:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352505;
	 x=1773359705; bh=QdLbzmw/KSDnf0Z+kMRVM204bGIQfGT5DsH4LYpn9rk=; b=
	LvUkteWZCDaoWYqvI6Uisnfitx8+ggZ7C+jDVARmw4MfgDHjnDypqJJX1nPL95Es
	Nag0d95y4bOlXv5m+pKizu4jWh5ahcynJTeDGkIUolBj+IgzzhsyXjFo2bfH0Qyv
	tKaQT582rw+TPUHzjlFD/YzofmzYyhPIuVAyhZa+ANuqDH7cXjyaGIOgEiIAmPMj
	/yBD02o3rX20ddAj2X9Lja60A73KqNH7Vbumy6bJPWqkV/J7oJhkcQE+7e0oY9oj
	8yrxJYAMSoJ2oQnH4ii8XAtCwFXq0JdtQ+OZyBx9LBztC94estrJlQ7Fb2RpHNci
	j9HTBYX57sNFqJtdD257YA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352505; x=1773359705; bh=Q
	dLbzmw/KSDnf0Z+kMRVM204bGIQfGT5DsH4LYpn9rk=; b=FJNskYCqOEZkh+b+X
	kjQKFHwDK4nlkiMOH79i49kx6oyszytp/7cRmbQdR4TG6i+WX1zSfAfDFSj2Y1NX
	urfJRQbAe2/ZivP8ZlFzYw5Xx4Tjt0gBM+SYtqpX6Kgsv306S8wBnJ3NPxRIo8Gr
	U5NJ5syIF6Ijl8lBWd3BsfXtGZ4Xp0xg+1uBM5qufDdgQAu95mr5nsWl6MMtoXlQ
	/0yyYgynJbthg1j1IiLBfYq1sU6SKAay8XiDekf9/sJ9Swz/so6Zcq4L7c2DgnYV
	ED/qOoO5zm9sFslZ6prlPbvaBfLftMXMK7/uaBYc2tOu/H1h5F+TOPuSFUXn/JDI
	t0ykw==
X-ME-Sender: <xms:ODazaQF7k1KATwaGFlcBZZKpfc2WG5qJMk5fnlfxm1Vi7B8CBF9F0A>
    <xme:ODazadD_2IL7856JUXB5PVFIBNMwA3rDwgll_qpc4ZhOz7e-JQ0NuRoov0eB42WUc
    EF3bvsNaNg3qYNH_6PwXS9evSOT0CwL1GdwzFrQraqer4PE>
X-ME-Received: <xmr:ODazaVPZS9YqF9ZefzQt107DROar1zD2G1yJvDbPvT3o3mATZ6mSjon75F5jB5LVrojnzHvcAo4afzSenxq3zbhqdyMRDGucrx4hX3BDj38C>
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
X-ME-Proxy: <xmx:ODazafj5iHEVaQbQL9xUSPUswOF968qjB-7fYOVT8Wqivk1HLaeLDA>
    <xmx:OTazab1bv4yDY87VbPr_S6wN9LMoF8mSMxvCKipOcZJol4AgbiLq4A>
    <xmx:OTazaRplVN--MsA_JdAYXWXr-dyaNK_CIRfy2b-VOFGs-cHK8Mzl1A>
    <xmx:OTazaY3AxBB1DDvGyksBA06N9SqB_ZPRuIzdc1Nf4sBn6Jnxpg8YxA>
    <xmx:OTazaQQzPhe-KJWsJjAclLfJeMdfP4VJ_ZU2q5xz2RTb5aOEmQxLEFQB>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:54:50 -0400 (EDT)
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
Subject: [PATCH 40/53] gfs2: stop using d_add().
Date: Fri, 13 Mar 2026 08:12:27 +1100
Message-ID: <20260312214330.3885211-41-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99F9B2000B
X-Stat-Signature: 6kegku36zk751gis6d38smedy48oqzj7
X-Rspam-User: 
X-HE-Tag: 1773352507-426254
X-HE-Meta: U2FsdGVkX18+j0EmPnjvhu9Ao60J4MdVtDJz9p2zxn7qKPJi4j4ge8wWndL4FWK2hgVQvSEatjKiTaFfZJ02WDD3dHOnLVJcbjO4s4Xk/dvI8l37pxbW2EJPAqKMuVmIfCTfaHUJO5E1yhaTz5FdHkggvxbQ5vuQTRfs22DYgE7CAWxkSzFKBp+BlBdKGs6RsIU30OfcAQCciSt6KovzYBbNPJDn2zbq7k3sccJtDZFqWifB8XglLJZrI4A3Ve/cmd2eo3NyFsJWsIf+7i0Pec2G4NQkGwhDTrFkSoo62CPgAjltA51XkCPDPtwZlEWNHE7iWl/4kuFJLIpoe4cCC6QoQwY4sqQkCKGWR0ZDjin3T4UH5qHK/v5w+qDvYQh0w7nbilzY109AKLtR+7gn/zjbndU77sgLtaIflgXESTCpkOa3IlgoFS8O0/tw9rh88GP1TFwI6XdBqj23x7QQTuwBJXmX4wUnEp/074sx7Ov/h79Gwo2DlWO1kOnVB2MyJ3RtuvaWnR/89+MqctxTpBnF78L5+RWF5BZIORlClXxLH6dw5VtOmET2nAOlYhdbsG+RpXDmG+jnkdxg3ywdPJMoxMj21e/bvPjaBqphX14hJwA34WAedwQQBgyY78+5C2jqcPZ+KW653DsofVlM75z6Cm1gD4X0qcGNjd9jBVR4IyT0sG0OAuYmHuNZitEOCa+n2Fzdo1KNgmHQDrk5Lav4WHsKc94n+ft+idRVN7NjyoSME4AHI6L5RbMsNC2jw6Sktq/YvYFfSvTJMeUWbPp5boi5xBklX/Om4ha26GtEOvbh3XuXyHdKG0NDz3U52/kZj15BlPyg/8qDZiPDf/C+NoJfb5V8xFNCSa6pXoB06pgipuz3COBitOqIrpXknRmbqpq8FhJPg3fsEwnR7yyyczuQaO0Teoq2lvf5okW4TkE2SlnOG4zTpqZ8/9jPXFgKhsNXsOE7ghSXJcw
 w3XjLI7V
 gwpx+191LACI8mSCmW/7Wbm/f+HGc0BNYl/3EI/hoYwgaC2vlDcB+2JKVG/wGdB2y1Da/aaubB+0V4QCGsKJsvKKG+Gw/bV9tXq28tTYI45ZTJwoV42yn5g/LOI5ZQPQXaHXCEO2A3sC+DM+LyDCwBxsK7qvrQkqb7CbcnxXD5Mw6kM3aTvVRDtJN0GgUbbWs4QHMH3urzQhhTiTkpDs6GJD3ruTszHq72NMpdFlvLMKJLbQMVUUfnXE/uXdq1whA8wWhcB0jsVdfuUAfgWXAirMauRdfWacnoxFpgFkW59e6VWHHWqU2U/a9TqPJYa2FMbp4Sj4giiBauvHjrE1WwNins33xDc+5pPvzijbfijStiNUCr9rPQXquh8ny2/zoCZaUm3P1tkIzQYhOSKQQL5kX+qgIUYOnCtQ5jeCFpH+WXseMUpI2lXCHVnLTh6WxB4VO6xnajseY18o6K91Zht3tqGW7/mzxlPIVeYt9VnttPShyOs6Hx/qV5tcjHYmpO7VvkIxtoxFNtoQ7pTipCqsBDeBJEwKKVvg7arBmi61QSQat+8WBLk+GfqQ1R4b8I9BwlbzY5QLdcB5JCki8b4arNyM9EfzCxqGsQ5snJRC2mgzGPYoXV5FYq8WPKrnJTnNvExjbz80CZod9NtNF08dtE/DUckywi0iUC9sygDHRfWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

"Best practice" is to use d_splice_alias() at the end of a ->lookup
function.  d_add() often works and is not incorrect in gfs2, as the
inode is always NULL, but as it is planned to remove d_add(), change to
use d_splice_alias().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/gfs2/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8344040ecaf7..9997fbc1084c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -988,10 +988,9 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 	int error;
 
 	inode = gfs2_lookupi(dir, &dentry->d_name, 0);
-	if (inode == NULL) {
-		d_add(dentry, NULL);
-		return NULL;
-	}
+	if (inode == NULL)
+		return d_splice_alias(NULL, dentry);
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-- 
2.50.0.107.gf914562f5916.dirty


