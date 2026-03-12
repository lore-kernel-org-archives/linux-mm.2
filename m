Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BF7106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D713F6B009B; Thu, 12 Mar 2026 20:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D320A6B009D; Thu, 12 Mar 2026 20:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33D16B009E; Thu, 12 Mar 2026 20:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B0CE96B009B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:45:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DD078BD98
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:45:16 +0000 (UTC)
X-FDA: 84539195832.16.C737D85
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id 328398000F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:45:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gZ+8j40U;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=zzfvAvPP;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362714;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEn/ifGqMa6Ax93LDCMof9WVE/J3cBfFQIVVntI4FSU=;
	b=Z9X6XOCarCglmAuruwDJY1P8VFffxwLUOzh4BKlto9+C+Ljck6VC1L9nnKuwcpt201ORZ0
	WAzaTkJulZ3Lp20o0oW8cqg+AOpuSSDbMDMcWvT5b5TlFUFIthKOGkhHCwqR7Z75JbWlPq
	eMSjQr6QZFPjYVdHE4MUR4ARgCykZm0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gZ+8j40U;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=zzfvAvPP;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362714; a=rsa-sha256;
	cv=none;
	b=ioApAtlwkI5zqUO/zUYaHHIASzcFOFprqhOzSo9m12MaX7B3lUAn83o6KHP1MuH6AYkeIs
	K5UUyNkzMB8QvRDy2y9+ASV8O9KQ3ryFZ112Otrw0H10fGca/eHALAoQJcMJDQUIcwp5tz
	/DMi7uZCwSXkuEkvZyr3jPcVOXHOXic=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 4ED741301B42;
	Thu, 12 Mar 2026 20:45:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 12 Mar 2026 20:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362712;
	 x=1773369912; bh=WEn/ifGqMa6Ax93LDCMof9WVE/J3cBfFQIVVntI4FSU=; b=
	gZ+8j40UJfd35YHLEn8GltXBxrkHPPJuG8UzNQ3aeCppl0Bx/G/7pz2k7GhTJmjj
	mMkAf0dDw+XbG44/22ZHnC0JRrXwzH8q+b82+ON+NK+C1ecJu5I0G6cz+Vt/yust
	YtInsQcWto7IBJEOT8YxmPsZCQpX3QkE4fAQTc0qcS4tV0zoArACYwrCYiAcYuR2
	IU3IwRQR4aA2y5hgvfqRNgHlsCxk0iBegjLC050ZkP1ZyWpg+OZEQdX1QuP/ytZl
	/kpi2YCwgiIZQX+OdMfzYWmhsrdWZfMNXzIpSMtOnpwWF/EVPknBbGGcynUfDN8U
	DaCcDEvlgv1AfZcLYJmQlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362712; x=1773369912; bh=W
	En/ifGqMa6Ax93LDCMof9WVE/J3cBfFQIVVntI4FSU=; b=zzfvAvPPEd2RUPFHZ
	l0AGY0rUFybvZ//8GerfoYDoJ/RiOp618aTFUWOlyRcqPbjs+TwRL0gLxxsIgn9B
	9D19+ZiWTLY6YmJghBQ0EtLyi32bLsLapT86+x3V0Oyr4WcdSP8ViASeFCxFlipW
	+h2cuSFfiKsYtmGkwNjMFh5Wks22+oCYAhUFbfGjj9uat3x3i2ZjM/1YiaEpE+e8
	nv5myRHW2Ieskf5HzoPTOIZ08+j8wF95yGOTtnv4tZUYVtQggkg0IQjwJNs9fLnp
	cK+VOUlhixrvzRekBrrG3Sdeah9seF20NJJD+piNW3SbCTgj0k1feZCLF4BxGTMl
	+rclw==
X-ME-Sender: <xms:F16zad072LGVm4nNLtXOrAE0R4MHeFys17F8aeOgTGGFFsxEqmoKvw>
    <xme:F16zadwY6MqKqvxEVnzjXXhu7yGKdN8mP1ZYLTT82CbpvlqHQLwBO6PUewUXY56Z4
    w_T6uLZaMp1MNL1uJYJMMEsjNPZEnmlMzDtz_GAFuTpukfY5IY>
X-ME-Received: <xmr:F16zaU0dcVnke18uj6A9ullyKRr_uxRR96urzCzwQghQnjqU3W37o55JhZUAG9djAg834APpoywNrQ9x-erMjL6ihxt3rxm9oYrK8MIg3Qtx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:F16zae7EsCLuKwBwXpUVK-Wp3nq9hST10o2DtFm4ZdVUHUDoH0CyuA>
    <xmx:F16zafc0zBIwpnROPq_jVe_3OyVNu6Wd_Kvb5bA0x0ZLMd_ZIBFK6g>
    <xmx:F16zaabPROXdG8W7YqgtteFTEoudtOzuCKNyVM0SFp6wLn5_edfCfA>
    <xmx:F16zaZFkMG282SjUNBy4FH7U4gLvxD_T1KDRXugWgu8krhv9pGNr4A>
    <xmx:GF6zaeGFHDmk1taakt1v2R44Go7b4oaB3SIGvOOEo_CQeTBJb9IsLDae>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:44:58 -0400 (EDT)
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
Subject: [PATCH 30/53] configfs: remove d_add() calls before configfs_attach_group()
Date: Fri, 13 Mar 2026 08:12:17 +1100
Message-ID: <20260312214330.3885211-31-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 328398000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 9yzsjospj1fai5zxjhuxkynmeogrzfhq
X-Rspam-User: 
X-HE-Tag: 1773362714-808010
X-HE-Meta: U2FsdGVkX18cOXlEzpNTYMdGS8BWkni+jVPEqBp1EQPIejmCbTGIDGOL6jFeocINasg7bFWWl1wRJkxuPzX3zDateQ9uw8y7MUW4aNerrtR9GojYeCYMQUstpcunjipD8dOyEh3DOYY069B+cGXWHKJDT/yD3+TtHGMjYqEy8nCNYKHjZ0sVGgVcmXx9xdvfusd7VuxW8Roi2iZem91DsLthDEGyY+FtaMpunDqWw1J0hrn8lhZInQOSlpgb04z9BzF3uoFPwLg/ZezpfthbAGPPJEnqp/cHbyccSflujq6R3AlPLFlGt8T6fJUG0/wZ8adW1OiqfBWGjv4rF2r31+IiSE3Xz6ic0wDZ1/Yo9GXl6/OAjBWCVWU+l5ujIB7b9n06RzwYX8+dqBa5IRAv993InRNexI4BcOUlQGigPb/xe+asa/Jk3Lc74bkN47Swr17Uldiwd0llZ1cw1vl4RsWJ7asJJVUkCqFPL04Drj0slCQumXM48GMbdS8KXJNGANVGxFt3jr5s+kD0nMe9NPf9aECXzEIuaZYzgOywG5qX9/xloiJTMGmz8DWWYNhH1E+plbNeNLhKt4Jm3VM73h6Q5tChu7QwJYxtq0OapNlLpH8wjzLatm6eUUzDwVvkj5YfC5Hbwg1ICpxpKgEbs9jglyFFqg0ZZQuI8C8C7e4veZvN71Oz8RQGpYy0L5AuomX2eVFwLesSgLzakx02vBYxCVlQ+bLYmeEpFoCTT+6uZNgOEINagHPXFaLKB8bDGXfmq7MXhbCvD+jM3/jViSsm+8/gUBowcIPsOgBYBl24I815o980k8BEiKA34dk7afP5xLm64mtt5b4jX3Rky87KyRTi1K5ZDw/D0gyipLxrctear4jr9ktDktfNL611ye240ldPAITHvd6y1cF0Cu6JgecEran5cViYOZU8XRoltfKMReOJozaP1LKTCqcTozzI9Pw+zpglNHiepE+
 DBWStbq2
 Kzwgq5Gqsfd9i4xkbRr7PNOCt7K/eR/0288y44dbQhA7AfoXpn1/mB9Cc6XZe4LO5HhI4Qu+Zr4ZO3ULkfrXB73cBfd4nHzV9SVCB7DfnQtWS2/qiVqZdWkL/Ol1F3wjhTL/vsiM0T7Ze7BEBLcx3mrPS2eeVP5SJV+WTAo6zPA+IDgfHk0+nUJBOBWHz1Hk+reudKmkfa96eOzM8ojL+HFslo1wZg+g4TWP+QjUKpVih46GQrKgUoFHtKiHppQYM57B0btXoGgR2/peWAjgSqTl5J8Du8bcAaQYTsjDcDUfrA3jHHYKWO4AyhAinyWk8aPDcXLotK6Mr6ASeeLFD1bcR+c36z0rMHrPdq7zqVs8sAJFNoEND2DIaed8aUys4+RnJskksz3Sx6z59BkrdWkcUQnszXbLrvk/UqSJUCi20v5K5KMfU7ttN9nTLKpU9giD3mPSpUpqwqKAOmX0eEXFi3mZDxYaheal8xtjJIUqjul9oZejRptD9bjOC+EPrJm/UDcKJVluYthj3rv/xZ1dQQss4p2HWCwU3e9a2pqS/e2s7EF4GI35bMF93DK8gcDUhSOxMzaGV/B45KBQm+3wht0v5hreIp3kpmoIMAhu/cHtUj9RO54OEyBHek9NVZDN9UGqv7mHaxa99+wARC7cvC9l23iwRCjU5tEfaT3hBWlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

These d_add() calls cannot be necessary.  The inode given is NULL so all
they do is attach the dentry to the hash table.

If configfs_attach_group() fails, then d_drop() is called so the dentry
will be detached.
If configfs_attach_group() succeeds, then
 configfs_attach_group -> configfs_attach_item ->configfs_create_dir
must have succeeded, so d_instantiate() will have been called and the
dentry hashed there.

So the only effect is that the dentry will be hashed-negative for a
short period which will allow a lookup to find nothing without waiting
for the directory i_rwsem.  I can find no indication that this might be
important.

Adding a dentry as negative, and then later making it positive is an
unusual pattern and appears to be unnecessary, so it is best avoided.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/configfs/dir.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 362b6ff9b908..c82eca0b5d73 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -706,8 +706,6 @@ static int create_default_group(struct config_group *parent_group,
 	ret = -ENOMEM;
 	child = d_alloc_name(parent, group->cg_item.ci_name);
 	if (child) {
-		d_add(child, NULL);
-
 		ret = configfs_attach_group(&parent_group->cg_item,
 					    &group->cg_item, child, frag);
 		if (!ret) {
@@ -1904,8 +1902,6 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 	err = -ENOMEM;
 	dentry = d_alloc_name(root, group->cg_item.ci_name);
 	if (dentry) {
-		d_add(dentry, NULL);
-
 		err = configfs_dirent_exists(dentry);
 		if (!err)
 			err = configfs_attach_group(sd->s_element,
-- 
2.50.0.107.gf914562f5916.dirty


