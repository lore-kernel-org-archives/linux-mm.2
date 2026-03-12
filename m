Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C03106ACF0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BEB6B00CD; Thu, 12 Mar 2026 17:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF666B00CF; Thu, 12 Mar 2026 17:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1446B00D0; Thu, 12 Mar 2026 17:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 070626B00CD
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:48:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE631B955C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:48:48 +0000 (UTC)
X-FDA: 84538751136.19.00D98E2
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id D230D80009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:48:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=YiFgW3M9;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nvhsCJHi;
	spf=pass (imf30.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352126;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hxhCnV9U6zmeL8OYJrlmY7rj/yQGmrUt+8UFBTzKtg=;
	b=VVHXo59zXQuxzqaC5WHGK7zcJDgZZuFROfpzkVANI0MIPcaSWv2VWLZc96SrpsaD7fbaOi
	lZenQrajqRy6YbuyfXYZUu4hAgoNdbXha6fzxou2dcgAMIsUZr0aIFBO8yLFKDLIGUS+4J
	TNcoNhMc7EWUQkkCG+qQ/9a/22di4N8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=YiFgW3M9;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nvhsCJHi;
	spf=pass (imf30.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352126; a=rsa-sha256;
	cv=none;
	b=KAu0xgUzCmFLxRxaP3joTNbHfc0g8dK3AGHGdqIkeJuTS44BtxZd4eOluxFnkVmTDbW7FC
	D8YXLn7E/G6j38k34kloq9GynV4YDRik+eVXF7414rvyqS4Wvmrpl9KQLeyThSMUVeIHYS
	J5HOk2WARkPjS0/U44Amslp8/RoN5Vs=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 0865D1301B8B;
	Thu, 12 Mar 2026 17:48:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 17:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352124;
	 x=1773359324; bh=8hxhCnV9U6zmeL8OYJrlmY7rj/yQGmrUt+8UFBTzKtg=; b=
	YiFgW3M9c4+BqqZQJA+22GBvrn30b/igbH0adx0uC69vr1gxmtdnWHTXSLtGZ1v7
	vE8AO38ThUJuxgrxw9XxjwQUNmiEN3pJjN9OptD9mzSioPXADb7E1O+EsYDpyNTc
	YdDide8ZPwAVPNcdbMUJdPj3GrpsmnSxGlz6tNKTziSuxrFzDgABnzqIvg48Uo5A
	d+Pl4wmzy+RLHOf0e2eeJC2r9wTFiefv+UodRNLArqD91vyLKqd55rcnDT1x1RVd
	s0tzcQj3gWkhnCx3w8SwRX6n2lcgXO77X8jg7SxXoy33jHmIl7FwkDml0cUSuTSS
	EUcVXtbPpLAzS1r4NI//NA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352124; x=1773359324; bh=8
	hxhCnV9U6zmeL8OYJrlmY7rj/yQGmrUt+8UFBTzKtg=; b=nvhsCJHiqZ+mas8ml
	KbZ0MpLKNgbhychg1yEE0z+mDKaZ2xC/Z7ex8NS3Ayigl2vn3dn2DpixzvgNyWGH
	EtAcbXjLqI2hmLhCVkKnPvjB54+2sXL4B6XMRBWvZKYbXubc412AfpNsT3mA+43U
	9Zc3xeIA762Ej5UQeJiKcrkcCl3qndb3Gi9jhKAZgYkOw0NKm0d14b/+/q3UHC85
	Woir5+CeVR+o8DsbEdUD74X/kDfbBBoEnKHDbeSqDsPRMT71BYUZsJw6dIverl2S
	rUDX4MtqSOexyOlIIikP62Ve4xks0MbrKiHi7RLjhMX9Ddqib31JGdw7vkM0IgnX
	h9mRA==
X-ME-Sender: <xms:vDSzaeDRyHvMRzUJWeuFDLL_WpOWPxBidorFlsg7ALzZmVszVsxKAg>
    <xme:vDSzaSOq4tHLpHuRcmav09_mZPCLNoF4Uc5mLwMrpCBzar6Dl-HMFwvWm3c9dheOo
    3W3YgS2dEkZDq94WZiSquFEfjyu2xJ94E0Vmks4wW82zuB6CQ>
X-ME-Received: <xmr:vDSzaYjCGvA38LnK2J6PAiSb_W8ESyLdOp5PVn-ZmxcaXJ4ZIZQMWiin3OzYsWa75kclwTovgBRdTVeFxHXoX4VNK6LoSLyhTyiUDp0CQJ7D>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:vDSzaQ0hwy_nS5OU9CELIkn0gcmn64b1OAlxyFVAiK_80ro9S9zTKw>
    <xmx:vDSzaSpI9fB4vLdI48ydxjjYlM77m1eKi9dRSOVd-S4yOArH-Z-npg>
    <xmx:vDSzaV3OBVEQpPW5BZTS6MXEYj0n0naIhj6vGBp0FNbSdStZjiYsPg>
    <xmx:vDSzaXxC6TVqo_2nLdQP6jL34HDW5eWNS2ZFDt2SctkLTmtwjxOpkA>
    <xmx:vDSzaVpN6CMMUybH5s849JM1MXURYcAp3Q_A3QG4DxV0RatYQMVsmUEu>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:48:31 -0400 (EDT)
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
Subject: [PATCH 15/53] nfs: use d_duplicate()
Date: Fri, 13 Mar 2026 08:12:02 +1100
Message-ID: <20260312214330.3885211-16-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D230D80009
X-Stat-Signature: kkjf3qmgn7dpierixzhsfuu9w8frgh7s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773352126-755753
X-HE-Meta: U2FsdGVkX1+LoTD8UdG2fl1cngQfNw25FwyA0HLUFjVF4LL4lIgycZcTLhAQMya/g8Lgga48RG6iB/DdQ802C/6wG8OYJfcnP4cY4DNtiMVcGrJ5HJoW5G8MsRrbcxS9667ad0sjFlmbMe5quCFOJMIHDJHa9aSZav1Bw5enzZfHW4fsf5TKTQIV3tsjYyGNtAawby8FccPbZjnaehQjvP4GqIYn7wH7/VoB4D5zTZ/9TPT22CdE5J5yfTxLgMqRpW8rc9sJZk48ISvpBcvj7M5QGY62pOhY1B1F7Ha/BrhQ22g92yorJdQsDV16tu9OVo5kMZYMCU/dfkVGPpRm6XSvBhqC90l3FSYUGLNl9THuD2OhynuitW49vqPDEyKz8yUii3nfyhcxsskxFf/XM8+yREh00pr8WsLRJnhcOsqPKvJKbfzj/rXGEz51NZbdg05vNwK2qAh/SenyQgr79wwottRQIbTufV7bApbteDnBcp6DTaBrXZgz1SV7yHZNvOpoJa+g3ncK/njzC1GNWSGhl56+lbsBvQPToszKHdNAbkb+d7AFkpfJTsqKVZfX0boDGMDTRZu4GTPEhNcuaS4uWo91UcW0ob7NWEdHyqI3DfhMlRs48Y+Knj9jxD3WDI629sN/Q4BqBj3XrcFUso5NgfCFWOX1qKRMvN3wII6UB+OR2x4jywdkZTPRqiNB0VWZU633LOHVikjLmUyXGYHmr/sUPdrwB8p0KOVx7ANIXtS0O7SY9wiNQ3BM+pMg4Cj0Gaem2AO27f6F2JjVPPCrbnGVq3mFbuenmFLb/bpFhF8ZTZyDLjpgW7dLqFM5LYR+6N/jT0mqrWXeQr79uGdE5QWBkwzSW/gMG/ihJrGMZzmtgIXafD/iLI35/I8nW1qPKPwYXn68o3I7IwmVHyuPmoUMAD3xTN0zLIoWSzz6MbIksoL+YhmEpuYvwAs//S6s/Vni35ItVy4F6xK
 gQaSJ0r4
 /EEeAxpgqtlMNDdbiKZ0os51qj3CXZuKlHZxrzeD6Pf5pL0ul1JdK+tiKc+3hcCqWEIYa1hdi+t7TIngm0LTUJc/6r0SbacRXYia1bGP1SYemdbFHbJXSsH7ReXiNVZKy9xl81mA5WBxUbVafdRg3J7s6BTrT8upv1QOvp1y9mj5I032Nzq8XJoiEBmu49nkYJ115ycatzjCSeHXqQYsigcQgq2Ek9gopIDEmmq71UdTh/PLI6Qm/2oIDDXxzViAUwUAcbFmyFd+VgmpSDVEbiXIgDuC5wvDSwAXfChIK0myFFFx+ZPb/4raunRKVm3s1Zq4LUMf4GceKZ2wA8PZ4P+PnbygrrbrUdoJMzS5EQlEb1EImGB/nTzuGiLwVs+QbBadQfHxWlcVVSQkiaC46y/1H26FUdnPghl6hZbLB3sGqeTAF1Rsu/dxM0w+F3vYZU43KTHIAVwx1ysRIaG/JCEcwEQJ7o4RAtOZP8QdoQd9bn3M/j92zFck3ffpz2OaA0NKLdmgojZPjvMJtcAhLfPsyGlHqC4WF/S4T98peRcj4Gp5F6m3x0jqj+mmxoUHy8JE1brMyxC9ldzNUQcaEee5wm3IqWyqVtQKfK802FyFKbee89rFMbD1k0vQWNcmtHb5hr4r3RATxa+U5iDTbX8cqorcxIxtxigM35P0V/Qsyb6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

As preparation for d_alloc_parallel() being allowed without the
directory locked, use d_duplicate() to duplicate a dentry for silly
rename.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/nfs/dir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4b73ec59bbcc..655a1e8467f7 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2781,11 +2781,9 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			spin_unlock(&new_dentry->d_lock);
 
 			/* copy the target dentry's name */
-			dentry = d_alloc(new_dentry->d_parent,
-					 &new_dentry->d_name);
+			dentry = d_duplicate(new_dentry);
 			if (!dentry)
 				goto out;
-
 			/* silly-rename the existing target ... */
 			err = nfs_sillyrename(new_dir, new_dentry);
 			if (err)
@@ -2850,8 +2848,10 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		nfs_dentry_handle_enoent(old_dentry);
 
 	/* new dentry created? */
-	if (dentry)
+	if (dentry) {
+		d_lookup_done(dentry);
 		dput(dentry);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(nfs_rename);
-- 
2.50.0.107.gf914562f5916.dirty


