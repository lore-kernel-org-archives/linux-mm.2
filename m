Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D2B9106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE756B0088; Thu, 12 Mar 2026 17:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F086B0093; Thu, 12 Mar 2026 17:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A9B6B0098; Thu, 12 Mar 2026 17:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84D2B6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:46:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F803C1B7F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:46:31 +0000 (UTC)
X-FDA: 84538745382.26.B711631
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id 46AE31C000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:46:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=KP3KmofC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EM63CurB;
	spf=pass (imf21.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773351989;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFIiei8hP9eouC0SsGkVtqGMAl3skHPWk1wOm65U/S4=;
	b=8axg7L62NZ04OMb4I2FosrpwbDVbhIoD2aV+nsVPImKLOUNGtAiaqqDFTLLic1Ba4GYjD1
	8JA/FGvPsIA/BpWHS3LH7GiNva1AWqdrgXy7MetvWmDGbf4L1biGTGe+PIJkyfga1Ug2bV
	P7HLSyJeXirzSA+SZ8h6zMqGsBOYYTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773351989; a=rsa-sha256;
	cv=none;
	b=YawKf3zdtjEAGfEHAmUVKZ6LtbFP/F+qmh/k1WpviSMdKzGVgGXSFOcZrTrmgEGeo2KcvH
	48T4L74akfpwdSsmIuFrRmdyc4e1m20Donf+mouXaDvIFY6Ebrei4z0JJgADj9YFBUfU4D
	THXANs+HEVusiIr50aHsk9gAs+QmSJU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=KP3KmofC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EM63CurB;
	spf=pass (imf21.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 4D4CA1301B58;
	Thu, 12 Mar 2026 17:46:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 12 Mar 2026 17:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773351987;
	 x=1773359187; bh=jFIiei8hP9eouC0SsGkVtqGMAl3skHPWk1wOm65U/S4=; b=
	KP3KmofCjcr3B+X9NgLhehjjQWjvB0L1RxnigH1q3NmPi9z5tKUX53SA4RbRuAAh
	8ICxhDkH3O0bnUE+qC+zFU8WNq8K0pq925UJpNLbld9S8U9nc0muHzfnMLHm9VUR
	vztXmdk/aM5P95nkL0XMwX9ybhH719+DWeHEGTao+UOWI7lxMrU6Mw1XbVWYtSXS
	EDCm2Nsb04P8CB/j4K9w6lr+hyB/igARie1rsG2NalgOGQVpFhXFEW88tyUsHj6B
	/6DRqiy9CeTAow8kFmGZBL8FFkmlKGzWV6GVq2kBJPXMv7mSVxlqdT440tnO+DNI
	y5unhWaVC+hb9Kko94krOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773351987; x=1773359187; bh=j
	FIiei8hP9eouC0SsGkVtqGMAl3skHPWk1wOm65U/S4=; b=EM63CurB/EIqg0bzC
	mjMxQq3eNXKOpGBZJPriZWRxxClegJnzt4SKrP1g2qQfyNl16vjSk4AaldBZ+JWf
	qeiyyYsjRnwFCD/IF9FkKSPVhZbSLDgwR51afyFyygx9Wnwy//hLSL+OOOo8N7D2
	zazNXklWj+3/4NZ/FP1rvYYUuPhkUP4Rst0agYj0sBdRYqduLOTb32mLrRUMZR/R
	rpZCOA9TydSifeXzyLzYJ5C5KJHz0h86TKjboP4Si9kcHib8C4yUTdyyS9x2Owwf
	lgjefxnpqi+o3ZpSMnNzmU6I02Wt/oP+Yqfvi0tAcxkoKNffFnQJG7HbO7b88hmI
	boTLw==
X-ME-Sender: <xms:MjSzaevw8FzdHcHRE7zs9lfUu4VHMdYSNU0qPpDeBo4J8Wg268UG6A>
    <xme:MjSzadLD_-P9zKexyXhJ-Q3Nl692sNr74GbkOIc9b2EU8MxVDR24qGR6Dfm-fSQ2N
    Q5oLFi-KxkQw0XMdBBZkgAu7IaMaifJHKa2Urh_YtqAkq8fiw>
X-ME-Received: <xmr:MjSzaQvs5Tpy9Au5tg-3KdoB34YYwqFeOEik7bnCEzSzar1MYZnoBVw-ub925mSl96IdONFtYsLP08YsrhASHDr76y4gGQ6OblP-nb-FNGmi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejkeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:MjSzadR_U26NVPT9FzhjkBn1A126uo-pTzNxCMSouTbDD1QFrjhQbg>
    <xmx:MjSzaeVsCDvDaEpbQCoyuxKxps6m7C2LkXO1M2_soVelf8ta9W4B0A>
    <xmx:MjSzafxzkBSlfzQYmfwJOKGLlqYYqjG8ROL6JO9Lssq8JGPE1a6P-Q>
    <xmx:MjSzaS-hUpmZGR_aF8UFJFjWT50lNkwFm7ro3SYjM65-wvSX58wDEg>
    <xmx:MzSzaflzf9s7-0gmsoW4bzEdf9NDaYqcOJdplu_WnSMmlMkDzvDQhkj3>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:46:13 -0400 (EDT)
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
Subject: [PATCH 07/53] VFS: Add LOOKUP_SHARED flag.
Date: Fri, 13 Mar 2026 08:11:54 +1100
Message-ID: <20260312214330.3885211-8-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ai9uwqze7r9jjhx7njymw1jgybb1ab5j
X-Rspamd-Queue-Id: 46AE31C000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773351989-553482
X-HE-Meta: U2FsdGVkX1/NXYAdF0WPrKuOegOw164VHIBsAhgh1JCu53G45o2eWrRe5Bs2Dm0Hbj77HnAQkiRVJB0MG2TugcLRnkybylvGUkZP3ySg+jYf4vzM+Z5Oz6LWuJsXMgMS/BeZG40LfDoEUUHHQhSvLBXCFj3TuZdW+d70v3gJhqBYUfSe2rAX6chJgyIiH2oPBImb03oau3/rAo8w6b3dE/fotCMwaNe1li5+n+4cTnBnS72Rx8smgFBjk63+1N7lcbtG0fdwlxGUhNy2cewqN3h4OYUuqZY4UGVVeoQxUNIqjxU4ngcmUfqpuMOMVuRRJmr4qm2mBhgeRyeMBQM+6AQUdAQYiWre0J7HYuNiIE9pr1nR56rIuzHB/3Xw4sTnlY/WigAQMv9oRc43rCO+Upu7vZRmTQx8v8hUjlWUPPSpBP0bwZXuzvQBB6jJhjuFZy6SMA5MK9Li8vi7aJuBynHL2Xzd2rodW7aGHWqo1Y9R1hly1HtBMlQfa+sXwO9btoHuo4KMDZLBc3oHaon8YbazaM1zm1C04VemDw4u7HbsRIU7L4fUEs66Z+8rkTWhIcaGFpoQ7Ih4B5rQ1nrDH+4XdcAmYXY+gdImcHxqEcgKq3xDS86ZyNWKoD21vcG9SYkQ6ZSANuyOJ8Ys+IuSUSDBwyALA545wRY60yN5ABUipZlY1npGsm5JA4qnorTE2oeOE4qzG4Y36UBuAHyvewW4bkcx0ywKZBe6sYEGJXgiygFoQng6S2QzQwW+IKLNmtslrMxCn2C3Yw/UJkEQglzBZoO/VmI6SY+iY0KcCMsGWff3UGVNkyAi63T6e2MHPfhh4wG5WbPHdwPQ9wRNHBnS0QzMO0bHPTlH0dVFRIneq3BykZEemxmISEQH4ecryM1fpWisPNE0PTGGRX7fO1r+3V39vQIdH2Ngk97rfz8+36SevxNuyqmk6cXPd4KtC870UF2uxEeQhY7SE35
 /m3K2sAb
 L3Zg6er1sbR8j7VWCNDjPU8JTZjQpvIjEkK+pbhj8t3sqp5el9SDZ7J0uPHBQftjbh2IhP6Vnetpmv92ITCo79gPNqOJ/6Mbp/9VGF2IUiOjShfmx9abo6DVfLPfvr3kMVlEncrO3O81JwTv7XRf9EUxpbOJqGgAb83KGezvag/z84Fe5y2K1JPO3p1KeW0hpsk+o6QcEXwz/CLJO/FWcWXoSjfHXj5h7MVU3rb35HdMMbWRrL/AhbyQ5eMQarLHqdWxg8XMmO88pQSaZxJ58X+DImnMo9I6TYiiRWZJFQR3k9oj502pFBSjouSDTmaXDUHIlK8e4zJwfoWi5aR3+4tQLqnb16qiZ5SESVKuYXnoJROJ6qh9wLy2ghFLPn3sfRdLJNsVUV2ztDsSDSJ7PrLbEXE0nUolbhZ8VzmhGdQQ3PLNM/FDlOfuo5mvJ62tKNzvgfywmsqEZQ45ut+loarqR7cThDcLy9JHfXudPhf/9ajJtWBiF7uDzFCzd1/sivrxm2rOZiS05CV3iqH48MlN4Q7T3YQnQLKyfXOcvmtv5kqp8gfxw7i8gFNRPLlMBrC/dPO3Ov2qv0rZYP12FPkZbR5siesKdostctjjWyy5QVgZ/fs4cjDVYZpDxNrhqU+YhpfzqKEr4dUjQvctv5aMLwAaklCrLlGFcm/sqMcjsqSgnAF7SUbefeQU4nie0aTtaBfQi5dcDOm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

Some ->lookup handlers will need to drop and retake the parent lock, so
they can safely use d_alloc_parallel().

->lookup can be called with the parent lock either exclusive or shared.

A new flag, LOOKUP_SHARED, tells ->lookup how the parent is locked.

This is rather ugly, but will be gone by the end of the series when
->lookup is *always* called with a shared lock on the parent.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/namei.c            | 7 ++++---
 include/linux/namei.h | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d31c3db7eb5e..eed388ee8a30 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1928,7 +1928,7 @@ static noinline struct dentry *lookup_slow(const struct qstr *name,
 	struct inode *inode = dir->d_inode;
 	struct dentry *res;
 	inode_lock_shared(inode);
-	res = __lookup_slow(name, dir, flags);
+	res = __lookup_slow(name, dir, flags | LOOKUP_SHARED);
 	inode_unlock_shared(inode);
 	return res;
 }
@@ -1942,7 +1942,7 @@ static struct dentry *lookup_slow_killable(const struct qstr *name,
 
 	if (inode_lock_shared_killable(inode))
 		return ERR_PTR(-EINTR);
-	res = __lookup_slow(name, dir, flags);
+	res = __lookup_slow(name, dir, flags | LOOKUP_SHARED);
 	inode_unlock_shared(inode);
 	return res;
 }
@@ -4407,6 +4407,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	struct dentry *dentry;
 	int error, create_error = 0;
 	umode_t mode = op->mode;
+	unsigned int shared_flag = (op->open_flag & O_CREAT) ? 0 : LOOKUP_SHARED;
 
 	if (unlikely(IS_DEADDIR(dir_inode)))
 		return ERR_PTR(-ENOENT);
@@ -4474,7 +4475,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 
 	if (d_in_lookup(dentry)) {
 		struct dentry *res = dir_inode->i_op->lookup(dir_inode, dentry,
-							     nd->flags);
+							     nd->flags | shared_flag);
 		d_lookup_done(dentry);
 		if (unlikely(res)) {
 			if (IS_ERR(res)) {
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 2ad6dd9987b9..b3346a513d8f 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -37,8 +37,9 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
 #define LOOKUP_CREATE		BIT(17)	/* ... in object creation */
 #define LOOKUP_EXCL		BIT(18)	/* ... in target must not exist */
 #define LOOKUP_RENAME_TARGET	BIT(19)	/* ... in destination of rename() */
+#define LOOKUP_SHARED		BIT(20) /* Parent lock is held shared */
 
-/* 4 spare bits for intent */
+/* 3 spare bits for intent */
 
 /* Scoping flags for lookup. */
 #define LOOKUP_NO_SYMLINKS	BIT(24) /* No symlink crossing. */
-- 
2.50.0.107.gf914562f5916.dirty


