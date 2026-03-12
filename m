Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3CF106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A74D6B008C; Thu, 12 Mar 2026 17:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4858A6B00C2; Thu, 12 Mar 2026 17:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366666B00CF; Thu, 12 Mar 2026 17:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AB216B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:49:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0FADC1B7F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:49:22 +0000 (UTC)
X-FDA: 84538752564.21.444B81C
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0148C80004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:49:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=TgyoTat1;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=obUK4rxu;
	spf=pass (imf30.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352161;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+7QufvNN3q8n3hkdBe3X5vN3xc/nhZLNzYG67Syggw=;
	b=LETpbFsn8LIkg1JKQ4qNf0HBx0Z2odNyTuBqOzWCtilaEl+isaMLGWLBXBQZk2RHXes6sw
	aKkY6SQX2ZG/bO2sSrNfHsGhs+SS3y3tZ8L4EDwCHg3MUN7mJhynoi6v0EPuLbIazsFbdW
	AyU0K4YM2ah9RZpIiQRwQZiHNNht2i0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352161; a=rsa-sha256;
	cv=none;
	b=mHCpHTWetgQOy3Pm7O07HmXLB/wEC2GdtgcWtb9HWW3ehXvvjL2DZYASkZR7KKV2ac63kE
	u0msAL5IxdYIrtgX/rTXAJ17oVlc1S66yfBtrdgJ8WUdIJ4qQvV+l2emPU0TwBSAPpNCDf
	jHCYX16fb4QLlIUK/Jy+kSMBz6h754k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=TgyoTat1;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=obUK4rxu;
	spf=pass (imf30.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 204861301B98;
	Thu, 12 Mar 2026 17:49:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 12 Mar 2026 17:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352158;
	 x=1773359358; bh=z+7QufvNN3q8n3hkdBe3X5vN3xc/nhZLNzYG67Syggw=; b=
	TgyoTat174eBaw3Mh4geA333otferDz8BBQPH1PgKmD7FJaHSr6GLkuhr2HlpJDw
	cVzZ84rQMihNKez8G7vGAleKuhXA4W5y9KIyFD4XN8Wb5z4C/GkUjuKskb+kJrR1
	lC/yoVH9xfJudFAZY9VkxvQRWgVEaIklFmqwqosxDL5m24ZZf8ALkvi5+8kTNaRg
	JaI5ac5o4PkCD/awH8jjlvbtcksBwP/UrAs/wyTtRe9wh5vZIiq43rwWfSf23iAN
	ZvxN48yBCgh6KULlPPnNa2Bf7IuYhYgs2ho1t/OJA0HAv6x9x5aQGqJdst5665hw
	AUEGVu0PRgJJYV2cz8wi4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352158; x=1773359358; bh=z
	+7QufvNN3q8n3hkdBe3X5vN3xc/nhZLNzYG67Syggw=; b=obUK4rxuvN2EEYhNI
	NtE674q93iVvjy5WR4fSqUmy8AHVYgkz/UxLyEHzkbsGA1QeFwYFB1iwCX/S2SXG
	/IPa6UfL54oQSq7sTP8Jf1YUCeNn82kWlW2yVSo7McnrgmZEJtbc4KeiMeYoKXAK
	BAY1RBx4D/DMmwFaIDCZXvTM+ujGQnIUM50S3v5o/1a4uwQV6C+pc0s9z8zOjwKh
	Wd4hbA4HdhrJjvqf1rT4/pg+E3TEO/wK8a/Md5olMOwIGDS9ErEvKobrJGJQZ9BD
	2OjvflQ2QmT9rRSnyWJm3cSWLappWt7B0uGl9SqswPjgzsIGfheQXhEqfjP+ehhn
	ijVCQ==
X-ME-Sender: <xms:3jSzacmiHA-T5A5AEGCAPRisYfRepw7X9MhO968O7F0fHUoyPbCqcA>
    <xme:3jSzaTbFNkRfJHGcu0SKNCrv8iRuKLvhnNF3nBYgiuCnV1F_HFX8PqbyTJlPBR7EI
    4nY2MMg5jusbnpid8vE-XkSsP2UrTIeAEbJx63CCA63L69C>
X-ME-Received: <xmr:3jSzaSOZgIZGoIIXYg2PoswHVWMT6XVQxqzKNR_HkotMxbkbupsyYrBXG_wfSZcnLvqER2WU-paPU6OI3-WxvGt0sPfdw2Tvz0bIZ6eNC-Bs>
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
X-ME-Proxy: <xmx:3jSzaYgtzeEu3P-KvNjuCtUPl42_DEzVT8HvuUimvBjWAblXlqrttA>
    <xmx:3jSzaWPrrMtwf1k_IiFBhtUZYvH9CuY0ZgnbQX6ifw6H5zUoX4qeyw>
    <xmx:3jSzaQoCrIiXp_IcrtspyfbsmXuloL81TRtB9bP7hiNmOCQtMAkDlg>
    <xmx:3jSzaULSuxRvndu5dd7u3ObmqYkIhunnkgWc-gpUCX-Sm0mvcKAJGg>
    <xmx:3jSzaWCk7Y5VsPadqok3seJ2hWjvt7O7dzBc5fbocDIx6aKo4dQz-DrH>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:49:05 -0400 (EDT)
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
Subject: [PATCH 17/53] coda: don't d_drop() early.
Date: Fri, 13 Mar 2026 08:12:04 +1100
Message-ID: <20260312214330.3885211-18-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y63gkqk9s6apcr3eyrrzi7thkujr8igr
X-Rspam-User: 
X-Rspamd-Queue-Id: 0148C80004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773352160-888931
X-HE-Meta: U2FsdGVkX1/YcW6we4Pxqrb8zcfj3AndaOKpWG41SuRbC2lqGDiyo7WpB3++zrA1HlhOYl0CLOjRqtI31Cj42CnilVsgH2de2yTYPzeafoINjIIi4Ey4586bXBUQJvSmBq9azigYZYTm/QHOWl9k/nUIO3E6DKD+UYIUNogwLjkUe25CGTURyJMyUG/NF/ScnogmQ8ow2+mzIGNocSpMUX39CQP+OA30BdZeDNqqij95wul3tUxzFWILa93lq97nIGLEyosK6GhcpMubaCyUNpZHekl9WJXcMAX6/kwIByoYl1NUGuMVhrWLyNYZv9j+0cxUdurLFgx+ylXtOQgCqgJYWUfzdoLVD9/K0xK/uuZnwvJ/plNzm+hZNQvhYBxTVGsdZhytBGOJ3R5Agk5ii9EMxzYXv0hGLAJWuVKV2urP88jZ8Wkc+Sip+4QqzNVRkRR5K5KhTtUSf+kQovJ/eX44m3tIPk/xnG4kkuSBT9qK6o7yqN9XWScqBapJxcXz0XupJQGo/Cj2kbWF0zqZdyWvEcfBgzuCCvP3nZ3Svy7HC7eSYOl+YKOFU+VQ/QyO8jsMCQQgfsUHbkGJAe688c5a+40LsYO6+4mNJy/BtEWcI1P9nla+u7GTh6rf8WOcLlAWh0mWOHdsYsZkcML+lP3QOzKEuv+nelilKLaiMg8BlFc06RlhTktrY3WT9Q7Fz3dH6e9hZ4qrRvqDaYpTAkYy54K/F/52AZNovq6zJlyjuVom1dbVJj9EF5i39lpY8sGnq87p72IjGCxZYsmCI4HndAiOmknpzLYomRA7URTxuc75JrHff2jBLP/SAFi+s0S9Shd6QllMYqsLolC3l/NqOU7Py3PGtGDjdE2R3xUwH/6e7zMMDD0BQkcL7ZZnDZ9ZX6AfdnkWtCTVZl7SofriL/kKd9OBYj1d3MuHeHzgr73GG5EER2l+IWsWby7OOz1lZy23pxn08yP9KBk
 qRRb2Gkm
 kuHZkQsBK0ipPQAfl5RPTZpVnm4zEcuKktQDTiFdM4A50A5S7IR0Ce3I1sXcZMBoIspzDODt/5SWLaqdH4YZMhOZxjFoZcjpT3vgtDyeY788yvIVE7MsP7xNqjaZHrqWL++nzGZOXDwaCVX7XFeFm6lm1uM2+ke/suTRHkJO/r4nj+gloIFCrTNtmOGQRB6+E+nUhg9Exkwd6e+wscN/290Q6FKuX9HLty+fX69kYV9IcYfNVZgL+8IlsuKMHhnd5YZ57T1vvQ9kansbp2CAqja80H/8zrje86wLlDQ+Kiyk6NIEnED5Wh8GidLf7hBhzyFQmaxeo9aRpM/+A/hi4eQtEaH0jeQPeSyFKWn4u+hqISlFN1WUEdSnI3pdp+9vWsY0c0RgrY1XWvWA6pwREns14DS0CEwY6Dn9eEzk4FYYFKrEphf9PdzcYHXEPET3ROMEl+gBbI3yQKG/HzC1HsLvZVpdFlD1889HjSCtAvlW3QDPs252oILYk3eGl6+h/2OLaouJQItdOv7JtEXM5wvx2Hhtwaa9vyjuc7M/ZN35D/lOweuNVNqn8gUElYxDTL6Gcz2/GDO7O8Hm0M15CKn/CMbqf9RNU0DVZtZCEOf5eJlrwB5m2VWbUUpBp/NG7biBaSfKT51VGBP5mLogxHPzyNYgkdr9jfyfzzQU5yev53FU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

Proposed locking changes will mean that calling d_drop() could
effectively unlock the name allowing a parallel lookup to proceed.
For this reason it could only be called *after* the attempt to create a
symlink (in this case) has completed (whether successfully or not).

So move the d_drop() to after the venus_symlink() call.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/coda/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index c64b8cd81568..70eb6042fdaa 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -244,13 +244,13 @@ static int coda_symlink(struct mnt_idmap *idmap,
 	if (symlen > CODA_MAXPATHLEN)
 		return -ENAMETOOLONG;
 
+	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
+			      symname, symlen);
 	/*
-	 * This entry is now negative. Since we do not create
+	 * This entry is still negative. Since we did not create
 	 * an inode for the entry we have to drop it.
 	 */
 	d_drop(de);
-	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
-			      symname, symlen);
 
 	/* mtime is no good anymore */
 	if (!error)
-- 
2.50.0.107.gf914562f5916.dirty


