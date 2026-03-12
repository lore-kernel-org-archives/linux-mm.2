Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A685106ACF0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B2C6B00B6; Thu, 12 Mar 2026 17:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915E66B00B8; Thu, 12 Mar 2026 17:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDFA6B00B9; Thu, 12 Mar 2026 17:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8C96B00B6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:44:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8D4B8B8B1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:44:47 +0000 (UTC)
X-FDA: 84538741014.08.F0D1AF4
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf08.hostedemail.com (Postfix) with ESMTP id C4704160006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:44:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=PajocoyR;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=eiKEFyzI;
	spf=pass (imf08.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773351885;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+mmsaKBniwLTeTPIsSiVJuLQl0gYbnHV92H9IS7A4Y=;
	b=Gce0gu5aHfd0+tVMc9kokQ+/vf8K5oEodZTqPYaJ8DuNY9pq02I5Ti6ezokmxBpQ6o8AUK
	hhFHq7hiiI3FzVxcyk+8nkabLkOj01LpZfxoJXjye3VC1F4qqwFNLVrNSu8KUJlXjc7XDD
	hqTR0fO+56FPvmvdrW8ULPb3Evk0uo0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=PajocoyR;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=eiKEFyzI;
	spf=pass (imf08.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773351885; a=rsa-sha256;
	cv=none;
	b=sIc/LmMgQYLN1FvpSZis3F3kdkfH1xb4av2fgaM8JOa+9DA/DwHA0GAHWi2dtnUby4YDBY
	GA7792+3JsSIj8zn8pfbr1DD6OPVoVHjlThPoiqj6MU0WBSS4MXDqXdXBPoqrqY7hnRoEf
	lD/b0WPUcCUSssFRey0Wowha6Ak4d9I=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id D4BF41301B37;
	Thu, 12 Mar 2026 17:44:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 17:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773351883;
	 x=1773359083; bh=6+mmsaKBniwLTeTPIsSiVJuLQl0gYbnHV92H9IS7A4Y=; b=
	PajocoyRnbmUsSEVN0KUCT/oAq8w7rz7XZBiWlFG6mILTzRMZadAVs9BMnUsdgpe
	VV5nKSfhYha9QGrwq154yebdSuYBX8+hBAeeSZRBxVC9NmmJJAT0nPf+13VMfxtf
	2Ol/vyXx2RuSHp24+K4OoOZ4c6gWli7I6Ek/EqXSWX0L6Ycuth8+TDu4Nn+2y2ED
	2AgfW76Z++0l2RrgWXbVFYHI/axuhx47RqBeYoyoaSOtVQOGxiDobmV+Ov+Ax42q
	yEGDJPGa1eEfseCt4wuoqX31vuuvtEvwijFAgA6thCViI54F0d6a1J/EaB+UANTS
	Y+5EmuH3P3aCXuDVWH4+1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773351883; x=1773359083; bh=6
	+mmsaKBniwLTeTPIsSiVJuLQl0gYbnHV92H9IS7A4Y=; b=eiKEFyzIZSyNAQzCX
	d+RQaHTOhHrbknO16+Wz/TPgBVYa1dqTafhGeNTm6HFQaU9Zpg99xU4J09EviScA
	y2QdwTApDbLsMmmwQnLewGL1vk+AFMuyJLCY975YHn3noQe7ewaX+iAEM/JkzoW9
	Vi35ja7wL0tPHqJdxf9CnkiDk+wHurPo2EJsT4Ysz215r2GMlN48ywG9FhKqLmQ0
	6F+5dRWUU121OP6gzdER+0xB/ZU5xIOKe46pmTIbIix1EbrObTt/tmGR45QAFNC3
	3XUiPSR+383Wu3hyeASY8KiIFdQW9vRKIF9xyFsTBAM0WvDuxihL4Na8gIg6TD/U
	Eci2g==
X-ME-Sender: <xms:yjOzaR1f0sP1-tDqkc-RFB88DhONAfQ7RJDh6Q1310ENBPPeSKWd0A>
    <xme:yjOzabxHYc3FDIwm2KGs43S1htZToWT0kuFPQz12AKa88iHeyCl0cavEsWXgWD5Ad
    sKlWmPEkWfCDLGogyU2cKxeLanpsWjjlvF4V8I-iOTRuARmQQ>
X-ME-Received: <xmr:yjOzac-AgPhr0IIPuVmODSMQuKGVoa_-yuRUCTd13VC835lFa_Cq6Qy1nz3l5rOzSvWUKb9o0m49HtwCKxFbn0wNwA9zv1VWGNlKac5VU1zy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejkeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:yjOzacSxvT53D4EC0GJno5_4e0brtZ18j26Kd01CWJ9svUCLgwKo-w>
    <xmx:yjOzaZnlYqFcjgWQzuZDZGAbmjw_maAnTksL_XOLOhsD2eCla2YaoA>
    <xmx:yjOzaca_oXXkKSpckA3Bb1Be3OCJ7jvlQjdGUYIA3Ya7PtK_wy3JBA>
    <xmx:yjOzacnjuk0_ReF6NaVCHibQtn1n7zg_HC6LuvFQee6fXbDucZvpEw>
    <xmx:yzOzabBhUzPmnBVjwIBIDtJPe-xU3cGBpUcDJ2bjBCdgB3hcXfd8hpa4>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:44:29 -0400 (EDT)
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
Subject: [PATCH 01/53] VFS: fix various typos in documentation for start_creating start_removing etc
Date: Fri, 13 Mar 2026 08:11:48 +1100
Message-ID: <20260312214330.3885211-2-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4704160006
X-Stat-Signature: w6z3oi1syex9g1ufs7kbckm5iupp3ydi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773351885-25429
X-HE-Meta: U2FsdGVkX1/OZqXr2OQNJX4wxK5ghLXrGyA77X0lUgkTeXlb7MD1VLEmbSpd6Qwnd40l95gen0K7gKKdZhOHeEwA5qH8fU/Q/lQ0n8J4HnuP3vyeHzSd8fUXFGd1AFMQA5sl08mzf3K/V7qCrt8ZAT2N0KC45ootH1pp79stnQAHn9Waj+LTA2NQftE+OvvhMelXAhp3HWunlLlSMcuYmFNretqOMdwBlXqTO1eWgUGvyLtPEBYgKef2dTDGfk/Opa10BZX1ziAYD1Mqfm0uHb55FygdjgodrKQBVOtmgavcCe5D9rCGJ2UU9oZNaqVpT38YBcIuGYYDrfjpXNyqNtHNhwvghZJ6TtJGJJjLorFmqoq1p2HVoL7wLuF/QV6SYlbBpdEU+dvrdMxAbMgBr9aqF+53sQyHKlpr9TbE0v9Tg9heB2QXcH9fEdRc1sLwFr1vP9M4AXWZnS/DipNJm4ewKKUl7nuTV9cuZ6MvUQ3O3YzSNJ77ZXSgnFt4Pb+s8ewGQIrkzxoiiAqEcnxRR9UulTMPYDUUWtLeBAlL8oAxyFh+6eRJVbY7epbRzKsGvHddpPBIQrwHzSgyXu/dnsDZAZKuFYD6eZ4ir4Zj9Q+JkV8rmC/WyLgdeMLVup/Q0mKysMAeXSzXoaG8Gx91wv4MgS4P/Hj8iyhsnEuoX85QBNwz6ohdLsMRyq8xLHzXzSQAQhuvix7cthFT+4dl3thwhJj+6qjDNEg5rvLiXgDuA/J/osz7EFOOZzL9iJjrJU1Gb5xNq5fWdXhxbI2GSb5iAkHc+a5yDBmtqHu6lTPHcQP6XJD+cUP3JLK4kjBg6kfXJbB3KyeWVhWIbMzrvkM21uPFTjHmGnbRXFU6GrASPy2ijKYI+Dibiua0OBDMxs9ApqbCjRuZUHjMZ1Ms8b99XMIsIO6tT/DeyMAitX3rSWVbZOGxUGkHgpn5dCOfDeRRc5419leNk2oSQgc
 rc8UqgWl
 /IWTFg2JEeCI2kR2/NuCHN/fYTojJanyMwO58U8BLIjaB8QKuOMHjbLa1bPBrsXZJqgUC2ufNNhRJNBjb09AX/BeQgHiz3UyRWQkwxNOB9A4zwqjFWenO8ZxCIdM6MnKJ+AIRaKwiUc0ziehWhlNCbpoaAN4dGY5d5qJM7m2lgz/nn3ffkOckvi3VzJKgWzysRZ7WXnTIWzC0cRM4lHh+gWG95v0VT7my0diI53RZS3BbbVOsRw9xJ+qqG3bVekGpuXoCKKFe4B1PzP6dUVBaPLgdQcaLvjZhBLQEwrMtMIF63wk0ibtJ3IPxruz74X/iiYjurim/Gp09hW1IZ1iDdO4soLQ/k2Yh6TSO742MidbhZgFv9EdALtSm/rwG3DqE6kYBnFCyNWZ47HT5YtGyAXwEJuTZzl7m6hqXaBkWSflRxFcmIvQeRnh2kDBoJERR0cMGIZ7KUTQ8PlLZhzY13/iY1zSFxgL6i40AaLf5gTTLE4rka91WjPB6NHkQmpjadXxG7NQ8sKyVgaVzHoar3fTP8lILMefsE71Z0/vyMYwE2YK4l/dLLuB0oO8KFbu44gYDW1GJQmjJWyx6CFQQF1gWOLihjrwukwqaxTiwG25su7s3pfLxGKsxWnEzXK+zLh/dfu5DqhdTYkQJklGLSYQufRXtuBozBDl03AUowLBQEP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

Various typos fixes.
start_creating_dentry() now documented as *creating*, not *removing* the
entry.

Signed-off-by: NeilBrown <neil@brown.name>
---
 Documentation/filesystems/porting.rst |  8 +++----
 fs/namei.c                            | 30 +++++++++++++--------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index d02aa57e4477..560b473e02d0 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1203,7 +1203,7 @@ will fail-safe.
 
 ---
 
-** mandatory**
+**mandatory**
 
 lookup_one(), lookup_one_unlocked(), lookup_one_positive_unlocked() now
 take a qstr instead of a name and len.  These, not the "one_len"
@@ -1212,7 +1212,7 @@ that filesysmtem, through a mount point - which will have a mnt_idmap.
 
 ---
 
-** mandatory**
+**mandatory**
 
 Functions try_lookup_one_len(), lookup_one_len(),
 lookup_one_len_unlocked() and lookup_positive_unlocked() have been
@@ -1229,7 +1229,7 @@ already been performed such as after vfs_path_parent_lookup()
 
 ---
 
-** mandatory**
+**mandatory**
 
 d_hash_and_lookup() is no longer exported or available outside the VFS.
 Use try_lookup_noperm() instead.  This adds name validation and takes
@@ -1370,7 +1370,7 @@ lookup_one_qstr_excl() is no longer exported - use start_creating() or
 similar.
 ---
 
-** mandatory**
+**mandatory**
 
 lock_rename(), lock_rename_child(), unlock_rename() are no
 longer available.  Use start_renaming() or similar.
diff --git a/fs/namei.c b/fs/namei.c
index 77189335bbcc..6ffb8367b1cf 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2936,8 +2936,8 @@ struct dentry *start_dirop(struct dentry *parent, struct qstr *name,
  * end_dirop - signal completion of a dirop
  * @de: the dentry which was returned by start_dirop or similar.
  *
- * If the de is an error, nothing happens. Otherwise any lock taken to
- * protect the dentry is dropped and the dentry itself is release (dput()).
+ * If the @de is an error, nothing happens. Otherwise any lock taken to
+ * protect the dentry is dropped and the dentry itself is released (dput()).
  */
 void end_dirop(struct dentry *de)
 {
@@ -3254,7 +3254,7 @@ EXPORT_SYMBOL(lookup_one_unlocked);
  * the i_rwsem itself if necessary.  If a fatal signal is pending or
  * delivered, it will return %-EINTR if the lock is needed.
  *
- * Returns: A dentry, possibly negative, or
+ * Returns: A positive dentry, or
  *	   - same errors as lookup_one_unlocked() or
  *	   - ERR_PTR(-EINTR) if a fatal signal is pending.
  */
@@ -3376,7 +3376,7 @@ struct dentry *lookup_noperm_positive_unlocked(struct qstr *name,
 EXPORT_SYMBOL(lookup_noperm_positive_unlocked);
 
 /**
- * start_creating - prepare to create a given name with permission checking
+ * start_creating - prepare to access or create a given name with permission checking
  * @idmap:  idmap of the mount
  * @parent: directory in which to prepare to create the name
  * @name:   the name to be created
@@ -3408,8 +3408,8 @@ EXPORT_SYMBOL(start_creating);
  * @parent: directory in which to find the name
  * @name:   the name to be removed
  *
- * Locks are taken and a lookup in performed prior to removing
- * an object from a directory.  Permission checking (MAY_EXEC) is performed
+ * Locks are taken and a lookup is performed prior to removing an object
+ * from a directory.  Permission checking (MAY_EXEC) is performed
  * against @idmap.
  *
  * If the name doesn't exist, an error is returned.
@@ -3435,7 +3435,7 @@ EXPORT_SYMBOL(start_removing);
  * @parent: directory in which to prepare to create the name
  * @name:   the name to be created
  *
- * Locks are taken and a lookup in performed prior to creating
+ * Locks are taken and a lookup is performed prior to creating
  * an object in a directory.  Permission checking (MAY_EXEC) is performed
  * against @idmap.
  *
@@ -3464,7 +3464,7 @@ EXPORT_SYMBOL(start_creating_killable);
  * @parent: directory in which to find the name
  * @name:   the name to be removed
  *
- * Locks are taken and a lookup in performed prior to removing
+ * Locks are taken and a lookup is performed prior to removing
  * an object from a directory.  Permission checking (MAY_EXEC) is performed
  * against @idmap.
  *
@@ -3494,7 +3494,7 @@ EXPORT_SYMBOL(start_removing_killable);
  * @parent: directory in which to prepare to create the name
  * @name:   the name to be created
  *
- * Locks are taken and a lookup in performed prior to creating
+ * Locks are taken and a lookup is performed prior to creating
  * an object in a directory.
  *
  * If the name already exists, a positive dentry is returned.
@@ -3517,7 +3517,7 @@ EXPORT_SYMBOL(start_creating_noperm);
  * @parent: directory in which to find the name
  * @name:   the name to be removed
  *
- * Locks are taken and a lookup in performed prior to removing
+ * Locks are taken and a lookup is performed prior to removing
  * an object from a directory.
  *
  * If the name doesn't exist, an error is returned.
@@ -3538,11 +3538,11 @@ struct dentry *start_removing_noperm(struct dentry *parent,
 EXPORT_SYMBOL(start_removing_noperm);
 
 /**
- * start_creating_dentry - prepare to create a given dentry
- * @parent: directory from which dentry should be removed
- * @child:  the dentry to be removed
+ * start_creating_dentry - prepare to access or create a given dentry
+ * @parent: directory of dentry
+ * @child:  the dentry to be prepared
  *
- * A lock is taken to protect the dentry again other dirops and
+ * A lock is taken to protect the dentry against other dirops and
  * the validity of the dentry is checked: correct parent and still hashed.
  *
  * If the dentry is valid and negative a reference is taken and
@@ -3575,7 +3575,7 @@ EXPORT_SYMBOL(start_creating_dentry);
  * @parent: directory from which dentry should be removed
  * @child:  the dentry to be removed
  *
- * A lock is taken to protect the dentry again other dirops and
+ * A lock is taken to protect the dentry against other dirops and
  * the validity of the dentry is checked: correct parent and still hashed.
  *
  * If the dentry is valid and positive, a reference is taken and
-- 
2.50.0.107.gf914562f5916.dirty


