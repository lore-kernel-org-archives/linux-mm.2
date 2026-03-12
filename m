Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026F2106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E5C6B0098; Thu, 12 Mar 2026 20:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61ECF6B0099; Thu, 12 Mar 2026 20:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDA86B009B; Thu, 12 Mar 2026 20:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCDA6B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:44:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 122E61A053C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:44:59 +0000 (UTC)
X-FDA: 84539195118.25.1D47714
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0AD22180007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:44:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=CqROUpl0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=z24mIuT+;
	spf=pass (imf06.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362697;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epUsWlAclv1DX2KFvnl7YFoPpzqQm77MgVOFM+B8UxU=;
	b=ESDFV4RiWGYAOqm6VBbqaPP9sO0JkBtYLts0AjIwP83CLwdpYY4KCH0ybmzt3ngthzVQnR
	H7e+KfCOA35EZqbfLRdixxhFGNiLDzmMdHWbpvuisTl/qi3PIP3nGkXIGwiEN3gVvrBfBb
	ByJplob0Ns+j6yEaJOvz8eCP97/JOqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362697; a=rsa-sha256;
	cv=none;
	b=rc4dK6cip1fmc6FvR1/g/Fv+tyPMrqnXMauV/tE37Zjuf9w+OJJfI8EPF8Jn/TiCN5ZQOF
	lttiRTYmPGuZy/wm5Vl90ATYNWXdoa5m6/ibQVfu7eym2FDU5Pc2IoC9IzhWQ3Ol6uuVrQ
	OX7kcHk2e7il+VRyxpGlRy6nu0gvnxs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=CqROUpl0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=z24mIuT+;
	spf=pass (imf06.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 273051301B3C;
	Thu, 12 Mar 2026 20:44:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 12 Mar 2026 20:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362695;
	 x=1773369895; bh=epUsWlAclv1DX2KFvnl7YFoPpzqQm77MgVOFM+B8UxU=; b=
	CqROUpl0SFgdLYM+5S4HfZslkqN7s5xdFeJrWFhMGpiUdyODd7Z+7ZvN1Cp31hpK
	ZT7KdwX8nus+Re9RyFZ7Lmx2HS/y4aAbuKPyjNSlyG4QT9GlQP35c7Qc/wveUpJc
	R6fyTEJL1SYXniLv5tJqSk0lVP4TG9izP0Z5673lCC1cVr3QRjNHb2xuAnovPDIN
	SWebynoCqykrPAnihTtAf4L4HNSaXCdZDUwo3lrKJrbCjD9/oexYvaM0MJCepNAl
	UAzWnRabXqQJKdQ+UqQhD+TSINUJmdz5L/8VPRv5cvG/4/0ylXxVgi/4RB5tBewr
	q+8rr17BgBMChmtR+WIx8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362695; x=1773369895; bh=e
	pUsWlAclv1DX2KFvnl7YFoPpzqQm77MgVOFM+B8UxU=; b=z24mIuT+M2aYx8BDn
	/SvHK2UeiuT9Zv020rqyHMZx6iwO9BhUEN4xj0P9wfCsYHthOQ7I3eXW+qtsed2n
	/hGxBGJFKKkTmgXNYq9tJp1zytp6kg+1P5x0LuPwfGAY/urC++X+Rh/67vfy5hZl
	DF1pkcDi9UQPUY2J1H/YNQzRgxd7MjUUl8aQvK/mKz5IoPlHl9bi+l9YIlwoaZgH
	Zk1LmrrSqNDSvYiABRJ2cxUaljb/oxyhp6EmBjDzWaeW+e+D8vTq2jf3ic7Ke1iv
	RjnCU9b8SvZ4hBQDdVmd8EVd30w+Luquz27gPL6jEjG5gzX9KlTD0SzRez021FFn
	iosiw==
X-ME-Sender: <xms:Bl6zaStXJ9WAw-16S3bYaCz_RnS8tYIFCyfwjxNZHNrhQ9Ae5W9-Xg>
    <xme:Bl6zabJ5U1axuX6nlB6VWQLXTnvvS2mY7Jgk-rmULAb0W5ZhgWxydmDeaAFefR9aW
    TEl-nDM2wCNr6XpJ9HBJO6rHcSSiZmkWgKeXXxmS55kQhKFIA>
X-ME-Received: <xmr:Bl6zaY3KSkPbpdXhtNRFclXHaXrF71EMYZcvCFtn3vRjXfFhyhDzrAo3wC1O5tXXPk3IWimgPTOXKMOae_kBFPhBSEbSvIB5v8w_BH0Myp5z>
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
X-ME-Proxy: <xmx:Bl6zaarLR5ShQVdaOoWUVtIhXP2j0-a8MHXe_bBheeqOXSt1kFPCYw>
    <xmx:Bl6zaYeQfHS5JnVFj1qQxZXh5cdBT39G07cL5E5Dm-e7x3pBmT-Rgg>
    <xmx:Bl6zaRxbiV781OoMd07m9PkrWVRBBoGMyd0NWxXe_GpCM4BzatSIGA>
    <xmx:Bl6zaWdLL1WOPvL9MrrQBGVzVZJ-LjPPQ0X0uOHzWW3JziVEDBVF8Q>
    <xmx:B16zab6RlMl90xxVmmES_1mzBODI5Ga6UsScuDL74A1RJ5HwqAPRxTmx>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:44:41 -0400 (EDT)
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
Subject: [PATCH 31/53] configfs: stop using d_add().
Date: Fri, 13 Mar 2026 08:12:18 +1100
Message-ID: <20260312214330.3885211-32-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dq95g5upnwcmpynwpb9jr6pq9cgfapjo
X-Rspamd-Queue-Id: 0AD22180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773362696-723646
X-HE-Meta: U2FsdGVkX1+flK07P1n4mcEOngkXcbKs8gU1qPCeU3o8eL+k0YeZyW63IsBGouy7K98/Rm7U6l1+B10HEwSBOgxDIe/FIIeA8WR5dwKjC75Cq2YF5lP0KBSxVp+txYxkTcEsEysfdaCpVmQ99I4/sLBE99l3D5g6DQxGoivFwHOirFiUlWKI4OIVWvrxlMvVCbFHyNU49ufesLIgVlnP6mo3++0y1w/3fzhvXNgzCPhdTu+T8JC9OR23fofrPjLyeQYdgPNVcAycl0oOp5+SFfiOhn7+W3Q/4U3/CVKXYbdbIuok5ryqWaMVlodt/ObhMaomONoRFCKxcK8ML8B9jkxk89cUg4ysSTcY7h6N/vD9t8xtxp/FJA/kH1mUXVqEV7LtQbuz4MQLkMfupcS2N3SVZfzJS6/5cOo2MB0iQbMQ7FYzQkV7NNBNDDL+QFp3zxetf34L/VxPMPhbQT2i6ANYI4t9dITZeBQr6FMADZmI1QTAWeWi9c8hOl3FEDwmt/Q4I+V/9m3RFK/HZdqT7/YiEbP9XAjmrgkWi8kTYmhcHCEDne7ndmgao81pWWUQmlaEU2EW3qejC1PlcC1aTOO/6Zp8K2uJU3bYTf9HJgoz3Uts1XvFiyeF0PHWVH+aN9rmAR3blAA0Fr9bs6tTwqHZo+qbZqLfF90kkdgb2vlMU7oNdopEhwUDx0pk9MW2/xlByiGhkVIKec6ErIOL+sQ6GmMSpM0o6qoBZv4PkwADxEQe7DYlP/HB/8MjwSHYHoVSuHBHuIUE6XXZzc2YmP3WACnzymx3OWFO4hoG42pWoQDD1aryI85eIwOsY6tmjoCXYQaFwAMPFUn0lRIbBg7ofCABk/wzh9vWKP3lfk+xIADvyUTCq2/AIyXzJyzjEFXgAzroOrMVVJ8GhgnPwl5Lj8ZmiINwVRSjtR9pGJxqgx3VHyKFlXxlgas/eUZD2juSnCTDZ23ZsnJVcrx
 2STQoAVY
 7RUp5piWVdiMtkHojcFSEhL/7rLCpPOsa1xm6aWX3O8sk1IVdFmlYkSwui1MznwY31qZoMT1kQUSCtjPdbTm6AjFnE+Y0DAlQlNlgn+ZhVwKrq1rquoiu1dn8wQzM1D/i9rP7Oh0zkuVvd0cREHst6nRlB0S0RfpA+m6HGMYSSLmYl/xbclcu82zHNDPVbGEhb6v4jlgWO/pHkN8dvBnfQoggZHQHw0SO5U4l1rB94ES6tH+W6fXBaLWis4s4l4oWyBxeZ0sVDfXemDK1jsqNm0eCAb/w7okzuNXo0WBZwjxeLBOpmoFftJC7IT5IxiREU4nGoMmqMsJsBGLRuh77zf1mdLREZ1mgLF7PKVJShNpmquAb+6YFAWM5OgJj/2niuxbS0SyV6xmseqI/UX8TFk10hT70eHe6zfGI7EtzsioFYywsxE3+yBOT4V6P81SXaNEfgkqx4VgpYA4WRHS/p2Qo++BBd4ZKVanN4NE5Nyuj8/bluJroC2Ik5IrKsl8GTUCjPhlKiORUMxIp0KlrJob5qm43KsRJqkEy0BFqzyScYwzTs0ftwLl/bQlgBNnVRdwB2WrskA1/TmKuxeUA/4AzLZupaH17SwGxO6MtPwA+zKhRsQTw505iwC7/6xcO8FTYwNfdmJZweuvyW17kQtIw59x4AhP43Ip8M60BWIzlB9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

"Best practice" is to use d_splice_alias() at the end of a ->lookup
function.  d_add() often works and is not incorrect in configfs, but as
it is planned to remove d_add(), change to use d_splice_alias().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/configfs/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index c82eca0b5d73..6ec589b6b8a4 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -501,8 +501,7 @@ static struct dentry * configfs_lookup(struct inode *dir,
 	}
 	spin_unlock(&configfs_dirent_lock);
 done:
-	d_add(dentry, inode);
-	return NULL;
+	return d_splice_alias(inode, dentry);
 }
 
 /*
-- 
2.50.0.107.gf914562f5916.dirty


