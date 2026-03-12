Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC586106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E006B00D2; Thu, 12 Mar 2026 17:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F20E6B00D3; Thu, 12 Mar 2026 17:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4716B00D4; Thu, 12 Mar 2026 17:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9BB6B00D2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:49:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE462140485
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:49:40 +0000 (UTC)
X-FDA: 84538753320.26.E622D73
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1DDFDC000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:49:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=Xccu7BqG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="m/gQSpd7";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352179;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puUX/onZj/vaXC+2Vk95PLkQLCVwPSvUkX77dKofgTQ=;
	b=LoHwuwwKcNKsPQoIyBQlWgUK00IQtf6DqKgsPlCfYkCmE/fHAFtoEOU/AQplxEI9QbuQO4
	zkmtX/h/HOM+JGzx5STndNGynjQxpfBkdhrw3/cRq+Hu6BY9SrnbTi+pLURXjMZQFSosQt
	hJG6hO2cQC539STkXn+jvAQsRMbX5S8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352179; a=rsa-sha256;
	cv=none;
	b=2Q91nVwsc5z0vgC5LspbbxgMOe+7rSxPzq0fUK4oVmXj+XWjpuxi5GmXbZKDXJVVRKFFNx
	YRL/7nRaZMrg9VQie5pgTtCkVMRk9KNIhw8j1zvk1L0Eu1N3wP2FwPpUh1kJxt47jrdXUK
	1ZImmjRE5K4rTmUmi6jOg8sgsoDeg7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=Xccu7BqG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="m/gQSpd7";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 304841301B9C;
	Thu, 12 Mar 2026 17:49:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 17:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352177;
	 x=1773359377; bh=puUX/onZj/vaXC+2Vk95PLkQLCVwPSvUkX77dKofgTQ=; b=
	Xccu7BqGG8E2NDVZg/N4GFdwY2oD8s3CZ2ec6I8noK+y1khNNKwdQa3qSaE8p3ck
	0l50JSAYQMZ5XRGqZ6Bm/NAd13BsbRhSkEdg7tqZU6lqcf02dFEy2EcSjKuts/ie
	93Y1uP4EFwJeTb8r7VZMByZxlZdqGEPpizVdBZMUA2mImhfkLWcTIYnNYeFDeLsv
	5FU2zkjTsrw3bSzl+CIzFJGHS1tbUaCwV+5sD1boXsVdn68Nb5W86QGVNW3kz1dO
	ZBA29VXiDgjJht9QJK+RFCH9oZopsofcKUpnEEHU0+MgBQGEzMOp4Bq2C4HkdvRc
	lnP0iuRl+qvkLgnss8CbMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352177; x=1773359377; bh=p
	uUX/onZj/vaXC+2Vk95PLkQLCVwPSvUkX77dKofgTQ=; b=m/gQSpd72bOeZbbIs
	bt9p9HVZaVD6pf8ZLbR/liTkCv6KLk37Bwr8ICPhs7HK1JpcdmbvRz230O5ZCVWm
	bL1vRCv8aa/Xm/OpaO3WA7ztqdqawHLsbn96Qsi2daFjSCddFwzLvvwz4NQtqelr
	jJiohG5ZcJotwPQPUQg4NyRCl/Tlv1u4/GXgV4jKWFBH0UUA+Mqw1kR51FO2ihPR
	sv9Bl9N1dEqbD5ZMaW3p4mZ8SyUtMM0xpWUs4C7GXuaqyzfvyS/u1YLmjyB5CADx
	iwjOJR50j2ZM6njft50LG+J5rhWP3t9qo6Wg405WgsbPq6uZnUmaMgGVQl7jGsRk
	+xLJA==
X-ME-Sender: <xms:7zSzaRVK2ld2mjFEAplQJYa3xj2B5fXBRT5y0o0EdVsnun8GWGj7QA>
    <xme:7zSzabR2Lv5FmbF1j0P4TzJuP00xer94lt3X-Grr0Tb7TbVDJgf4Jx5IwpC9MwnwJ
    P4t_lKZRwAwLN1n9mgh-b1sfmG9SoeU2JQMiLlb4i48l8ScJA>
X-ME-Received: <xmr:7zSzaUUi1znV28haYsZWa146WyJbSjqBMqzMN7HUYQ0_ezVgi0z1HHys1ytelS5qeuiqw3N9ZonF1PHm-rXrsrwIwgZ4NLTmc8x48k7FJUbX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:7zSzaYayN_tA3ZkrIRtpJ_g6qClkPs2v_4yuR5WOe7mTaUdMhUxu9Q>
    <xmx:7zSzaa_u1VUCAlV12vbpEUyTKc2zx_hwL4IwQMPrbjyh4r_ouPPtxQ>
    <xmx:7zSzaf4y5PLi3r_Ggqqc4UxN7B9yxtAOERfWRtN6w0IgVtlfwvZ05Q>
    <xmx:7zSzaQnBblIZERJYN1PXUQ5V96-8KEp8KPLi_5CcVcuQa04y7G941w>
    <xmx:8TSzaZmH5TF4DiiBHGfn2CzS1n4UuyybOJqjIgTLw_TmHyJHXgibp5sQ>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:49:22 -0400 (EDT)
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
Subject: [PATCH 18/53] shmem: use d_duplicate()
Date: Fri, 13 Mar 2026 08:12:05 +1100
Message-ID: <20260312214330.3885211-19-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1DDFDC000A
X-Stat-Signature: whg3x13jrxmgu7fr7o57b8wri1yxxr8f
X-Rspam-User: 
X-HE-Tag: 1773352178-888441
X-HE-Meta: U2FsdGVkX1/TQMcbOwEe5m69hxUh3VAUugQbXjChu5P5Z+lsI2xcvNnDmwdy0jDFYiI5JxON9HIZHKXCYOtsJqCYfJKTaptQCc2BXnlr/05b0snGYjOUSBFjyuCbd2Qb/C2fweYjdVmuYVyB1gdwKjMXC8+2Y07Fsr5XUIwBBpHjxK+GgyLQXmwBGBdnaW4/DQbocmBmGwCW3mJPAt8jVW6NPoJlY0KTZ2FgwFUksyg9JZfF08W9seMH7+3vzz4zhh7w0gOhj0kn1H1l+GkXeh4CuQPBgpN9taLgqKFo6wGuu3/oTN9A9p5Jts+CDDfoXZRPI3M9Rhp/ybp8grejrnE0uwpPgLVSdDLC9pJJlEP+1mcBAiqbrSIBWKhYTDdHVgz3Z2OfhtBBLws1rucfmYIpcV+qRTaHIshdZbPA/BVftHUcNpSFXMTWudyyYK/S4dMC7paPqTGiEmJdQDOvf7yeFAA1PX7Xiw1YCCtKmzkWKFxtwUyO07q6g7/FvXDIc1J2uzqzltY3nxdb9jlHNtxCPayevuUsiPkjfp8l8z7lNmejWebG8sa4BGJNRZqErD13q1e6nkAm7QDhUl0h+Y2YU7MIgfeuOa1KAJX1c/8SPZU3kDF4tVOLWYyKlxu6Hr7cWw6d4MxsQTm1PC47RNTEGC2ZoNQGlNmzJ3TaAzIPDHWbOV3+juDb1ok9JXPY7xtYSYGqBlUQ5jO2QqYwTpMjEM6m86XnVmj+Ze3RjaqofOIi5+C/Hm+TNc4iGfKP8AnTQKtSOfUj9/+DPqcC3O86WPCvf04maACWmKj+iIto8KESss1xWl9i//OIburLicI7pE7J1nTsw4RRP7K3lVm856h79/ucYtgF9Io2pmO1QGtHVlM/mt3SUyy8oGohDJW/5fQEF6Pcu8W/hM5Ilxon7q7eO27Svg8uii2JPMGWGsQelrSnPtPhYuvmvxUMaqSvIFo9fSkUSx11opy
 smdggkUv
 Dny1eQbQ2Asce6fuonQe3w/vBbpJxMFCUVpDabYrRqMNpEspOyelXqTLmqDIDG38ay3N5GRCCjcwH765vIgVeG5bUrCOZsClZHI5zYoY8+SF0DDwPjZmiQBsBc90OEKRpp4wYC2vfjpI8tvFYkrz65AzH00oLNPWtP9qdEW/iG77jlSeRfK5Y05bzw87bMaonVshHLbTnOT7MI/kVsnsyApHcJFIjeM4L6rngTSGbfeRpLOKb/IAYPVmxL2mQp245RBmEc9jF+64pjAwxXYHkKYT/XkyHFZuJ2tpbwlNrUszbeRZDs2fBy//4meqNOWf7tGW84hq/Xmhi+qDs0O+22OPLqg==
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
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b40f3cd48961..6b39a59355d7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4030,11 +4030,12 @@ static int shmem_whiteout(struct mnt_idmap *idmap,
 	struct dentry *whiteout;
 	int error;
 
-	whiteout = d_alloc(old_dentry->d_parent, &old_dentry->d_name);
+	whiteout = d_duplicate(old_dentry);
 	if (!whiteout)
 		return -ENOMEM;
 	error = shmem_mknod(idmap, old_dir, whiteout,
 			    S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
+	d_lookup_done(whiteout);
 	dput(whiteout);
 	return error;
 }
-- 
2.50.0.107.gf914562f5916.dirty


