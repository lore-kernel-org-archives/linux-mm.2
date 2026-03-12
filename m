Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 170AB106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9266B0088; Thu, 12 Mar 2026 17:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D996B008C; Thu, 12 Mar 2026 17:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F166B00C2; Thu, 12 Mar 2026 17:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4716B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:49:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11CFBC1C82
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:49:06 +0000 (UTC)
X-FDA: 84538751892.28.166AD44
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0D758A0004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:49:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gaAhEBPA;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PYzTveHy;
	spf=pass (imf25.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352144;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YL+J72s4jM/IFD83vUlKIIKhuJuEonEWtkSdhku4yoI=;
	b=jvhp25MRyNfl2+7CeJO/hbcqrlX1i2sgW5DnRIOqoL2JuumbKIORzp0by7bphA+6yFpW41
	szUR9tABHPQAV2zE6nHmBvCGqfVvbm7EsZBbOrblTyIHti+L7tIhh/vpYJVm5cLO6MhhQ7
	Q+TUHdIHfIoYdGxXWIU4lviv+ND/+Y8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352144; a=rsa-sha256;
	cv=none;
	b=O/gQMJ9zHgdIM8K4cntF93AUMJvc1Bh2GGqpJcAw6L9SL5XLEHbQjPFvGIbVQ36KPzaEHJ
	pLFbDSbM3QJyOC9rlP7HdBSYlx7nKKQt57RVmkzLVNgKqWZKdo8wDIHEQ5GO7nGWr9TiMM
	iTMT8Ngn4ZE4xJ0q2VpbtVpcincgVlQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gaAhEBPA;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PYzTveHy;
	spf=pass (imf25.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id DEB981301B8E;
	Thu, 12 Mar 2026 17:49:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 17:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352141;
	 x=1773359341; bh=YL+J72s4jM/IFD83vUlKIIKhuJuEonEWtkSdhku4yoI=; b=
	gaAhEBPAdZ3kN0WV16+ugt1A/74DzdGxG8GEh+e+EQn0LxokiH00tux1d8sBHRcY
	Vg+7f+AOVRuHjhznqBd0sk41zkY9Vx4MFt96H29HY4RyG9/tLfLooU+qOjqy3Ip7
	IH8RP4puRqDzsWiVR9OJNaF5F8IkaIv8EKzwUABlX5z0SXc9f3oqyE6HyxoBMDDS
	pc/vRkKXd+xwK5xh2M7mb3cTBfa30Q4hfYmSYHp47InunZ8s/qXNmlFjFULmHD7w
	3+DbNHr3E7SKmihSlBhgNVVkp2v/H1cc12RtWmoaSN4ONlLZ4DcnjXpDPs4R6LkU
	ns6xJKqBdYIvZ4hcjjUj7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352141; x=1773359341; bh=Y
	L+J72s4jM/IFD83vUlKIIKhuJuEonEWtkSdhku4yoI=; b=PYzTveHy9RbMJRFOG
	+aOYTisnLh1GssROIXjKgytZ4YxU9i+aq6o6xyI+wA2qQQ3phZD+7w9a+2oxR9sd
	MeqUQsL4Pikanpl6RF2Vlolwt8nVrrSGXImQw1AiavtrMeOHQp80gmJWpbwF2FLc
	nH2rodwDYZ8UVeQnQ/vcXJ7K/d1UnY3kPRC6+afOMbKrlwwk46kzWD211KuXsuNA
	OuNxbhRGhgyAjKWcJHaW4LaMvWUKu+JboX31okwJgjFqztHXyiMO5KvAJdk0mEfr
	nvn4Mqxg7kmCNIR8KgMyimzGJdQGOGVz0Rta8y6idYVjE7mud+m4qGXXI8tSbQc7
	PLcCw==
X-ME-Sender: <xms:zTSzaVmwZixCGdoX2erYF0lP235WWzGm_ytqUU29xWcEeK7L0VW-wQ>
    <xme:zTSzaUjG04C-wM5lql7c8WfFKDjRHXkGA04C2snp0wQn_m27cVZPK_uDtD9jQYXU-
    iK7vr13E-btv_v6m9oHI9tCXM4q9Zw7H-3yQldyhMRQJcTA>
X-ME-Received: <xmr:zTSzaWsqAk9yDmJdbanEpvmBeyBlj7d_0-LcKSmgHHotctU1rSIGew6MWReJM1dGsftssvq89mEj9JIvBq67daOHoQnwV4TX_7ghL9A09Cwh>
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
X-ME-Proxy: <xmx:zTSzaTARJTYpvXl42P8fW7lTXo4Lj2wXGnHid5oDSRvhe_yZolChkw>
    <xmx:zTSzaZWOsXczAf9XJmzQY_cdxcxLTv20bO6dyIAvbZru0n0FgBFW6Q>
    <xmx:zTSzaRIbQrG4Do27wKl9Wfg5Nj0cHKP-bxR-i9E9XHdvomQxuGhoBw>
    <xmx:zTSzaSULGNWJZjGpBUM3QAt6gABNWwr6kRRnFzPn2VEFH0VbT_nXjQ>
    <xmx:zTSzaczB9cOVBaPVl5IKIF-TP6DKqW7SwY2Aj9X3Uh4e-1ZgrGKRQC_t>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:48:48 -0400 (EDT)
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
Subject: [PATCH 16/53] ovl: drop dir lock for lookups in impure readdir
Date: Fri, 13 Mar 2026 08:12:03 +1100
Message-ID: <20260312214330.3885211-17-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0D758A0004
X-Stat-Signature: xunfdzkwbiwp7qr1khy4c6ji9mfqo48i
X-Rspam-User: 
X-HE-Tag: 1773352143-981135
X-HE-Meta: U2FsdGVkX1+wlbO16kzoUJAaG/LXPjLwhrM6SFiFoA6PIVia5xqvKam8omeHU3BNSTy+/VG/8O95BWgR4On5uyO0P5dVjXv9flyERehgDHcdYA+NKZ6WNQp2SIM9/jn8o8kR4I6Tvgn7r5PizW2ABcAnbY9kffXXTjd4MgPg+YTiW7R/CiH+dRbBdpIXD9LVWR2yZ4/8w9hIkDPhQflqNDdy/w2GOy5mZTngs1/JA+F9+fz0AmxIcXb/d9drkFdzbigAYuzJQkAuE7+sPZ2NwvCUPcoVjemzcFtdgga+9B8f8VynGE0UwGvYid5hDhuPjmt19D+cst+g52YIJZZNGwVoLy52duaI3bzhfrsxS+SynBaWj8osVM4wHVVCJikbh6OGHClbQeJNATx+Ee9qSxt5OlJN6Kt3syoSe56QebWurPdNa5mQu+lj7JxN/WPIWEfCyZkrYVBm+M6PDG1d7e3lq+HN7nk8DBWRGTeAbt2o8QymKwtDjpKChtR4J1cgIjYYhQGdvPE8SujpFkTizDy7XFCc5d/F5i6wKk61OCtpUF6udjJ21TT2LzjhVBymbvvZylPZ569mKRTk0ZvW97mEr+Fmf5cnFUcJaWWfVU/pTSsflKMOdbsNZ7/EYwehs85gNnt0GZBOaajhYZRlskbcbAclBFoYWXk5yoqX1BjqvM5dMzxUbKE+o/HgyDsHebpY7uY+/PULHojAazzdJP06pjV9lWKrqY92jyUjjd++Xnl92CQGGFCWYsvOmIVutpGgo9PQ14aODDvK801IMTSESj/nKpxUCDe1SfqvmMQ+6tbHZ/9PZUhiN60JehiUHah6fmo8Ia4suALDLVNgHyokqp5zEH7IVsXqi3Fsuial6ziHOpUaRJuWqOyuhVOC0LJETSGonjdi3sX903S4G3YPo2FarSOvi6Ld22mFTsCXCNlrjsnvXQa1cb3xje/6CUqS1qal7q8TQfegA1a
 cCsOKOh3
 s0B2vDKoFrEycB/JW0W0erhs9QWo8LRMfijhxwmCt9N+PAVF25gkelBnSHNbr3ynq60cPA/mgpv1nhkShN0yDwz5E9AX5T0xZpG+Ou7g+/cWOIOiSSG50C8ge6XxzcXVVGxagJPPqYeb9ibVF5sFkscFO3pyIi4AHcxcUblrpKpH3gCR2/89ho0TfWvvdbV2/oK2Su73COyN/+eGLlxOLD7t574/OHfBUA4zz7WgqyyEIYeSkaUCAcd6Gt9ZQf2wqBBWSQrTTR5N5838U+Wpp1n1pkNsAijjft6CcZX4iDNwR38/EyRU1GHheAdn/epntifJVyk8sQKNfpEU4mkZhIgsd+4yw7yJQNQ3SC+G1mL4Q1Uhgbz7R3wSz6fC5uxgR86nrvpOXD948rqA7iXQDPjYNIJ6sNHdTnFm/M6GOmw7pwXmm116qK3YjSSrKywWbvfAS4mx6yK51AUH7cM4zuTqYbeqdVTnJjZBHJKPrvvbC8LKoYYh7VDLqL5NZN+XvxJfp395L0ESmrPanYyHOKv7+9prPC14STJ8DOPtzFP4wxGN4aVBvBB6DsSW/ObAXAkfiCGtVukbv9Y0D7tugH4cI8Ivhlh09LBRhWpFI/8a53tSnKFeJTdQZpewNfscp/UkL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

When performing an "impure" readdir, ovl needs to perform a lookup on some
of the names that it found.
With proposed locking changes it will not be possible to perform this
lookup (in particular, not safe to wait for d_alloc_parallel()) while
holding a lock on the directory.

ovl doesn't really need the lock at this point.  It has already iterated
the directory and has cached a list of the contents.  It now needs to
gather extra information about some contents.  It can do this without
the lock.

After gathering that info it needs to retake the lock for API
correctness.  After doing this it must check IS_DEADDIR() again to
ensure readdir always returns -ENOENT on a removed directory.

Note that while ->iterate_shared is called with a shared lock, ovl uses
WRAP_DIR_ITER() so an exclusive lock is held and so we drop and retake
that exclusive lock.

As the directory is no longer locked in ovl_cache_update() we need
dget_parent() to get a reference to the parent.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/overlayfs/readdir.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 1dcc75b3a90f..d5123b37921c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -568,13 +568,12 @@ static int ovl_cache_update(const struct path *path, struct ovl_cache_entry *p,
 			goto get;
 		}
 		if (p->len == 2) {
-			/* we shall not be moved */
-			this = dget(dir->d_parent);
+			this = dget_parent(dir);
 			goto get;
 		}
 	}
 	/* This checks also for xwhiteouts */
-	this = lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->len), dir);
+	this = lookup_one_unlocked(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->len), dir);
 	if (IS_ERR_OR_NULL(this) || !this->d_inode) {
 		/* Mark a stale entry */
 		p->is_whiteout = true;
@@ -666,11 +665,12 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 	if (err)
 		return err;
 
+	inode_unlock(path->dentry->d_inode);
 	list_for_each_entry_safe(p, n, list, l_node) {
 		if (!name_is_dot_dotdot(p->name, p->len)) {
 			err = ovl_cache_update(path, p, true);
 			if (err)
-				return err;
+				break;
 		}
 		if (p->ino == p->real_ino) {
 			list_del(&p->l_node);
@@ -680,14 +680,19 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 			struct rb_node *parent = NULL;
 
 			if (WARN_ON(ovl_cache_entry_find_link(p->name, p->len,
-							      &newp, &parent)))
-				return -EIO;
+							      &newp, &parent))) {
+				err = -EIO;
+				break;
+			}
 
 			rb_link_node(&p->node, parent, newp);
 			rb_insert_color(&p->node, root);
 		}
 	}
-	return 0;
+	inode_lock(path->dentry->d_inode);
+	if (IS_DEADDIR(path->dentry->d_inode))
+		err = -ENOENT;
+	return err;
 }
 
 static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
-- 
2.50.0.107.gf914562f5916.dirty


