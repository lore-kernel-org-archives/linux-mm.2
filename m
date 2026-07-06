Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5792BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC8E6B00FE; Mon,  6 Jul 2026 02:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED52C6B0100; Mon,  6 Jul 2026 02:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9BFE6B0101; Mon,  6 Jul 2026 02:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 925F86B00FE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:22:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2174B1A02E0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:08 +0000 (UTC)
X-FDA: 84957356736.26.59D5A27
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf31.hostedemail.com (Postfix) with ESMTP id ECA4120002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6r9qdvkhuuvFRjJ6MDxNAMrtlFh07/ZF+kMNkug6Sho=;
	b=W3aRhoqhIjFSvq/8Lvp0pD7M9KKjwxG+s51YBAhQevg9fZF445oaw0SfQ69kXu1tKSqGi+
	27wxJf93xVVXbipsJ7O50A2B7KEDl0YV5JBoI1MELpg/vNJn00sND5yb3fbkbGXmeYEZe0
	gsVCe8P83RJieo5tKgYTVVXozkun2qY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318926;
	b=lGSNwKYEUcayl0i5KQ3qS6nqqJEKAxShlQUdWygkL0Z8W/3RS9pR7VJHCx3WyYmK75jNFN
	6UCJaSe4DAN0xPtQeGIlF9yLOVEGw2ZzkeTMLeKb+o/cpKhcZMx1tCGia1xWiZXyd5VivF
	hLZdhziBT45VsGAJ91EBMJ1F2V7RWbI=
X-AuditID: a67dfc5b-c2dff70000001609-20-6a4b4983b9ef
From: Byungchul Park <byungchul@sk.com>
To: linux-kernel@vger.kernel.org
Cc: max.byungchul.park@gmail.com,
	kernel_team@skhynix.com,
	torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	will@kernel.org,
	tglx@linutronix.de,
	rostedt@goodmis.org,
	joel@joelfernandes.org,
	sashal@kernel.org,
	daniel.vetter@ffwll.ch,
	duyuyang@gmail.com,
	johannes.berg@intel.com,
	tj@kernel.org,
	tytso@mit.edu,
	willy@infradead.org,
	david@fromorbit.com,
	amir73il@gmail.com,
	gregkh@linuxfoundation.org,
	kernel-team@lge.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	mhocko@kernel.org,
	minchan@kernel.org,
	hannes@cmpxchg.org,
	vdavydov.dev@gmail.com,
	sj@kernel.org,
	jglisse@redhat.com,
	dennis@kernel.org,
	cl@linux.com,
	penberg@kernel.org,
	rientjes@google.com,
	vbabka@suse.cz,
	ngupta@vflare.org,
	linux-block@vger.kernel.org,
	josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	jlayton@kernel.org,
	dan.j.williams@intel.com,
	hch@infradead.org,
	djwong@kernel.org,
	dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com,
	melissa.srw@gmail.com,
	hamohammed.sa@gmail.com,
	harry.yoo@oracle.com,
	chris.p.wilson@intel.com,
	gwan-gyeong.mun@intel.com,
	boqun.feng@gmail.com,
	longman@redhat.com,
	yunseong.kim@ericsson.com,
	ysk@kzalloc.com,
	yeoreum.yun@arm.com,
	netdev@vger.kernel.org,
	matthew.brost@intel.com,
	her0gyugyu@gmail.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	sumit.semwal@linaro.org,
	gustavo@padovan.org,
	christian.koenig@amd.com,
	andi.shyti@kernel.org,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mcgrof@kernel.org,
	petr.pavlu@suse.com,
	da.gomez@kernel.org,
	samitolvanen@google.com,
	paulmck@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	chuck.lever@oracle.com,
	neil@brown.name,
	okorniev@redhat.com,
	Dai.Ngo@oracle.com,
	tom@talpey.com,
	trondmy@kernel.org,
	anna@kernel.org,
	kees@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mark.rutland@arm.com,
	ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com,
	wangkefeng.wang@huawei.com,
	broonie@kernel.org,
	kevin.brodsky@arm.com,
	dwmw@amazon.co.uk,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	ziy@nvidia.com,
	yuzhao@google.com,
	baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com,
	joel.granados@kernel.org,
	richard.weiyang@gmail.com,
	geert+renesas@glider.be,
	tim.c.chen@linux.intel.com,
	linux@treblig.org,
	alexander.shishkin@linux.intel.com,
	lillian@star-ark.net,
	chenhuacai@kernel.org,
	francesco@valla.it,
	guoweikang.kernel@gmail.com,
	link@vivo.com,
	jpoimboe@kernel.org,
	masahiroy@kernel.org,
	brauner@kernel.org,
	thomas.weissschuh@linutronix.de,
	oleg@redhat.com,
	mjguzik@gmail.com,
	andrii@kernel.org,
	wangfushuai@baidu.com,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-modules@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	2407018371@qq.com,
	dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com,
	neilb@ownmail.net,
	bagasdotme@gmail.com,
	wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com,
	geert@linux-m68k.org,
	ojeda@kernel.org,
	alex.gaynor@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: [PATCH v19 37/40] SUNRPC: relocate struct rcu_head to the first field of struct rpc_xprt
Date: Mon,  6 Jul 2026 15:19:25 +0900
Message-Id: <20260706061928.66713-38-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH9547jV2OlYQz9wHTTEfchGG8PMkW4hKXHTFmRj+o24fZyNEW
	CphykxkjV62kYOlCO1qsCOSsox1l7bZo0WzAQFFUCiglys24GgalBqlGA3SnkGV+efPL8/wv
	b968DK6wU+sZTU6+oMtRaZWUjJCF1jRtqdizN/OTyedyiCzoCWhwuyjQe+pJuDVSRsBAmxPB
	RESPwOw34RAY+AOHF+3LFMx0zyOwTJcSEBYNCKZ7voTQRAcJ0bFnGIy8nEUgPl3GYMmcBZeb
	vJLe/JwCS90AgvnpSQS/9o4juOEoo2A4EqYg5G/AYK6dgsayGyT4+2cQXLKZEJQ3uym4Numj
	wT+ziMFjswkDp2cfTIhBQmqnwGYpx+C12EqDWLIRbHeHSHjisNKwOJUK0cZc6HU+o6EtdJ+E
	vvGHJMwETRR4RnsQLAxPYeAyBHHQ+yIE6JcWEAz5GigYd0VJKLG9khzWn6QHqK0mIWD8G8HP
	c00UfD8XRDBqmZX6ImEaSjubiV0Z/KvKGoJv9f6O8ZWDSxTvsrsQX2mUju7ZMM5XeIv4200c
	33LhDcbX3t3CX7OO0Xyjp4Cv+CtE8l7HZr75+jTGX5mPkPtTvpZ9liFoNYWCLiXtqEztcPSg
	k7NrT3Wcs1MlqP7dKsQwHLuNWxg9XoXiVnDQdJWOMcV+yAUCr/EYx7MbOG91kKxCMgZnhxI5
	g1hNxBbrWBUXnLqAxZhgN3L2kQgZYzm7g+v/xYhWQxM5Z/ufK0Fx0rxt8dKKXsFu5x6FbxKr
	+rVcX/1TInYfXCp22xWxMS5Zy3+z4bFejh2P40Z7DNhq5ntcpyNAGBFrfctu/d9ufcveiPBW
	pNDkFGarNNptyeriHM2p5GO52R4k/VrxzOI3V9H8wMEuxDJIuUYOu9IzFaSqMK84uwtxDK6M
	l29K2pupkGeoir8TdLnf6gq0Ql4Xep8hlAnyrS+LMhTsCVW+kCUIJwXdf1uMiVtfgswfqBu0
	CZi8d1NR+jBZmtr9VfxBeiwxX1x6cT5lMPrpxfqzpw8P8c5z7h8/fvDR5Q74wfSP7M1ggu9o
	bV2otOaxta9A90V6Z11SF+tOE7PC6rZDvcfS/RsmW4rIO/2+A2f3t7yzZ9+R1u1p3UbLzjPH
	lz+nk2suav33ru/WH7BGDUoiT61K3Yzr8lT/AoxJ5laxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0wTWRSA986dTofGkrGQOEFd3GZ9xKi7m4g5icZHjHFWsmY3/jDxj050
	lPKStIBgVgVqsSBuSpOW0EpFlIpQBYuoiF0JBlypRBBZiIKIW4uEIkZbTUsLTjUb/XPz3XO+
	8/hxaKyYlSTQqsxsQZ3JpyspGSnbuV67WvtrcurPd6ZWgV53AoZHPRL4t7CdhIBfT8LZRgcF
	EetNKeidlRL4Z7CIhN6rDQhGA3oEH2esGHStcyREjF1S8AefScFUiGDO1YXA3GfEMNR7F4Pj
	eiEB75tmKZi89w6BacxDQcVEIQnT9jIEFq9VChOd22FqtE0CcyPjBAx+8CGwe2YJ8LSfQhAx
	p8G5mmax3PyWgpmeRxgqTL0Izo+NYHg38QLB9a7nCFx1RRS8MrRg6PfEwpPANAUPTKcpmOo7
	S8CbJgqqi1wS6Hs4iaDKakTgfeoiQHuhkQJzlZOE1he3pdA3GSZg2GwkoMH5G4zavSS4DTWE
	uK5oXVsA1gotIT6vCTBdaSMgaK+Xbq5F3EfdXyRX33yD4HSPIxTnsDkQNxMyIs5fq8WcziB+
	7/mmMXey+QhX6/ZRXCgwQHGuD9Uk113DchdLQgRX3rOaa7WMSH/fske24YCQrsoV1D9t3CdL
	qavrRFm++XltxTaqAFXGlqIYmmXWso+Nt6RRppjl7NBQEEc5nlnCNp/xSkqRjMZMfyJbZj9D
	RhNxDM96x0qIKJPMUtY2GJBEWc6sYx9eM6AvTRPZhqb2z41ixPjVcNVnX8Eksc+m75Nf/Pns
	g0qPyLQ4YDnbaFNEw1gs1bZYsQHJLd9Ylq+W5RurGuF6FK/KzM3gVelJazRpKfmZqrw1+w9n
	OJF4lfZj4fJbyN+/vQMxNFLOk8PmHakKCZ+ryc/oQCyNlfHyZSuSUxXyA3z+UUF9eK86J13Q
	dKCFNKlcIN+xW9inYA7x2UKaIGQJ6v+zBB2TUIDc/SH3wN/2FcGw+whOlI//t3/D4q0q/6ns
	E/rZsLaok36y9sdd53aef2+L7eiu7fTLy5OX3L/rjJMlWkqK12/JebrIl1vwZ0vCywGjMdU/
	Hjn0aLCUPh7nefvHd3k/bJu7nJT1KlS2tFu1yTFsv33cqjp9MFzM56yq6Io/+X2wZ/ElJalJ
	4X9ZidUa/hOqfMNukQMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECA4120002
X-Stat-Signature: 4ji7jajf3t35jktur88gwn7qs5xr3dib
X-Rspam-User: 
X-HE-Tag: 1783318925-681974
X-HE-Meta: U2FsdGVkX19K2nyAiadfE7Hjuc9BVqAFzsjFY/eIQRLe1Nbr80vQkDp0SsT4Pqv4D+vcUtZZO9ih0pa6N7wYJ5MP7kFixUIWrkQIfZ+Rf379jTC7LukYz7quNA+gcP/t8vnY2WUHysSYurNzOjorY885F2w2RaReBnxRrLWFKR8cDSvA2J+cGCqKuh/m1RT7a3SkJnsugp2dw55bbS9v778HFd272y0KEjmFzRR3fu4au7rglJubZkJJUiUpty9vLKLjzY/lCuFUk4c7Wol6fkPMbRsMRqZ+zuiAYjQMItyB8W5stZ5yTxzxNn70qljKaayrSj0KNeB/LjoTQDp2IyzSqZk8pG5bYSX/Og9EhmQzPv8o5ca1XoTZ2sNtAQFygObULe09FzhOLnIar59/JtnEA5mCKSuWJ0WcnrJU+5ipI7xYhsV1hPkjeKvn9Ted2FURWcalMUVznbGsmL/UhT6zQPovj9nZiMB4jIOBn0aJrjkxQvAvR4GRjKRJ7crpib5hcB5iwcMR0Cbu39VVirQcYYeZMACQ2TecFR86Xx0x4r53NBoi9p1BYGvXcp4+cu3zavPEoW9mqpvAJY6Dfh9uGT+lSr2qIigs+cfVhIV1L2XeBxFzGCfp/ej+l9oaeY2bySWC7NMamooxFP44pEKkMPl/HXs3S2K1XOvtFNRqeQjYg7hq+eVheVTlS8+3YFDtvoS8UY4j3PnyM58KoJxSW0s4+9wFtqkbHRZdoZuBCtDG75iWyElXTdiWdSoAivBQh4gqfLcwpw7MDhof7r1G+XLH8BODBdxRtFt40xTvcPNaSHxpD/zH+sulh2cyv/sqnFrEAjEhPASub4cXvQ/p3L6ISBRkuHcMkMBlhW55NgJD8orR2rEKoRsowkR2F8/T2M8YXevvdvJiAogs8oAltOpuKMs7LTG0VTdUQXYyLV9IicLEWIrufwFw04nrE/aSp3DxA6dCQFwFnQS
 TPEum7JK
 le5vqayZbqj1BK0FSfkLHkbLNY6Q/hwghgu9gXk/K1dE7i4SYi/SpJrcsY4W5nOmykOmG6FUv0zXh7MQG7Qae3PBQ7jDv9SuV1zfWZsSntwXwx5pTbuykjhRzazXJHxR+TK/qx3oXsi6u6R5J+YA6BWqe+17R+y2ROITcvLl5p3dQrUxwA1bAW7iQkP9k27Cm9K/E2aMfjb8laLc7Y2XOygI9GvYAcl+g7hNV3DpUEJ1gxaEHXW0MeDFmlThOl/k9fJzcRNB3gsmflllSqQqmu+tSn/zA8ApEgD/hbkRqqh3WdzMyGGT/akdeV8aVCl/oFnn18M9+8oeGe4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While compiling Linux kernel with DEPT on, the following error was
observed:

   ./include/linux/rcupdate.h:1084:17: note: in expansion of macro
   ‘BUILD_BUG_ON’
   1084 | BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096);	\
        | ^~~~~~~~~~~~
   ./include/linux/rcupdate.h:1047:29: note: in expansion of macro
   'kvfree_rcu_arg_2'
   1047 | #define kfree_rcu(ptr, rhf) kvfree_rcu_arg_2(ptr, rhf)
        |                             ^~~~~~~~~~~~~~~~
   net/sunrpc/xprt.c:1856:9: note: in expansion of macro 'kfree_rcu'
   1856 | kfree_rcu(xprt, rcu);
        | ^~~~~~~~~
    CC net/kcm/kcmproc.o
   make[4]: *** [scripts/Makefile.build:203: net/sunrpc/xprt.o] Error 1

Since kfree_rcu() assumes 'offset of struct rcu_head in a rcu-managed
struct < 4096', the offest of struct rcu_head in struct rpc_xprt should
not exceed 4096 but does, due to the debug information added by DEPT.

Relocate struct rcu_head to the first field of struct rpc_xprt from an
arbitrary location to avoid the issue and meet the assumption.

Reported-by: Yunseong Kim <ysk@kzalloc.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/sunrpc/xprt.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index f46d1fb8f71a..666e42a17a31 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -211,6 +211,14 @@ enum xprt_transports {
 
 struct rpc_sysfs_xprt;
 struct rpc_xprt {
+	/*
+	 * Place struct rcu_head within the first 4096 bytes of struct
+	 * rpc_xprt if sizeof(struct rpc_xprt) > 4096, so that
+	 * kfree_rcu() can simply work assuming that.  See the comment
+	 * in kfree_rcu().
+	 */
+	struct rcu_head		rcu;
+
 	struct kref		kref;		/* Reference count */
 	const struct rpc_xprt_ops *ops;		/* transport methods */
 	unsigned int		id;		/* transport id */
@@ -317,7 +325,6 @@ struct rpc_xprt {
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	struct dentry		*debugfs;		/* debugfs directory */
 #endif
-	struct rcu_head		rcu;
 	const struct xprt_class	*xprt_class;
 	struct rpc_sysfs_xprt	*xprt_sysfs;
 	bool			main; /*mark if this is the 1st transport */
-- 
2.17.1


