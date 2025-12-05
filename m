Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326C0D2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF566B0108; Fri,  5 Dec 2025 02:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAB86B010C; Fri,  5 Dec 2025 02:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C736B0108; Fri,  5 Dec 2025 02:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE54F6B0109
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C35DDB9ACC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:08 +0000 (UTC)
X-FDA: 84184568496.08.4B40C49
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id C9A78100008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qoBYT6wbI3DuD96QNrUKxtuEJglEVZJKtwoP0TlqlQ=;
	b=w5OErLi5CV8tXLx4ja0Lk02Ge/vgZ1hVB1yDBHwM9J8gPc8oASfv8V+yyElGRoAujvBCDl
	/dO2JtOOy+GU9BQDY/2ervmAS8hKAojB/P+jipc7u91ReZkSCMNwT1mla/BwqvcTRMLgfi
	KAfr7n2QeRWQ0uNFjzmR6Xrwthl7xxg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919207; a=rsa-sha256;
	cv=none;
	b=7z5f/7qEMBaSj9TJpr0fEr9lpLhbfaU44dBZAAvXBTopZX5xBbyWVNr6z7Dnr73wv8cVzj
	eMxNDp+aEYpyQRfF8b9zNh1ACwoGRC4DVl7Bs6BsIwhgDQr8XGcVPY6lYFpO44iPg4Negl
	KbDijlXSCd8WDcoXrF30aktAJL//F0A=
X-AuditID: a67dfc5b-c45ff70000001609-dd-69328776b787
From: Byungchul Park <byungchul@sk.com>
To: linux-kernel@vger.kernel.org
Cc: kernel_team@skhynix.com,
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
	max.byungchul.park@gmail.com,
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
Subject: [PATCH v18 41/42] SUNRPC: relocate struct rcu_head to the first field of struct rpc_xprt
Date: Fri,  5 Dec 2025 16:18:54 +0900
Message-Id: <20251205071855.72743-42-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTdxSH87/vrXa5rSTcQSJbM2M0G1PCtvNhW7bsxZu9OOO+Tc12t95J
	QylYkMqWJUVwCmGswZSFlkGF2UHpRtcOURRFDChpmVScFKTlZaWEtYwMKQ0ouhZi5rcnv/N7
	zvlyGFxRT6Uxam2RqNMKGiUlJaTzm8+8oD+Zpd7lDGAwPhEi4U5pDwGxpVMErFk6abgxcpyA
	+H0LDksrd2kwlSLwD13BwfF7KQb3nA8pME2FKDCHLTTM9e2BkeUoAlvoIQZrtbnQ2OSm4P7g
	TRxmjB04DIeegtuxBQrmffUYWI93k+DzRhCEx7oxKGtup6D2RxcBFya7aPBFHmDQ5voQJmxh
	AjzGJgx+mEsUfksF0y8XMfA2jxNgM2yD6RYzDY+s+dDfNktD4HsTAb/O3yRhIHiHhEi4hoKJ
	69+S0GmYpME12ofAURXGoa5hnIJTa0sI+s9PYzDcVU9BlbODhKDjEQkGS5yEoR4PCe2zfgw8
	/TcIGDC3EjA16SfBPejFYbk6HfzGGfSGio+fqCZ4u/scxjsaHIi/Fl3A+XK3nj/riVL8auxP
	iv+pYhXjL5gDNG91HeXdLTv55ktzGH9mMUbyY5HXeJe9guJdizX0vuc/kb6qEjXqYlH34uuf
	SXO8rW8WdMuPldccMqAFWSWSMBybzU1f+QM95r+dY1iSKXY75/ev4ElOYZ/h3N+FyUokZXB2
	OIM7uVK9PtjCCtzcvSiVZILdxi0Gp4gky9iXudHTS9jG0gyuzdmz3pckctPI6jor2Je4xso4
	udGXcwN1oYTLJA5s59obFMkYT6hlHRY8eZdjgxLu0q1z+MbOp7mrLX7CiFjzE7r5f938hG5F
	uB0p1NriPEGtyc7MKdGqj2V+kZ/nQomftX3z4MB5tDj0cS9iGaTcLOvR71YrSKG4sCSvF3EM
	rkyRRTW71AqZSij5StTlf6o7qhELe1E6QyhTZVnLepWCPSwUibmiWCDqHk8xRpJmQKp9FUY2
	MOvuaw6+n1tl7NrkkRf/tXX43UzrkfKmt9575x/5+N66xlbFs+lyH+/W2gfT8ss+t8Vb7qr0
	t4/Ud2c5A7Tl360nDp5OPXx571mfcOBt+3VJ7ZfZWT8ve82X93R+7dg/WvZB0abIoQrjrbqu
	mdhHzy3YUjKEkmCBVxHa8YqSKMwRdu/EdYXCfxdbNeSvAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxjHPffce3tpvHrtSLhTo67GuJjoZBnLE3VGv+h1UdRkyYzZJo29
	SkMB0zKERaNQKxXUYJcWvbWIKI2WbmDxDU21gQ3n1AyGGy8TgaQyC8VOaMHyIt5iFv1y8jvP
	8/uf83x4GKyaoOYyuqwc0ZCl0atpJalMXW1anlv0qW5lo5MCi/kQPOkOUPB3gZ+EaMRCwtka
	Dw2TjhsKsHjPUPBbWyEJzT9XI+iOWhCMjjswmOunSJi0NikgEvtHAbYCBFO+JgT2FiuG9ua7
	GDxXCwgYrn1Nw0DjEAJbb4CGsmABCWHXcQRSn0MBwV83wmD3bQqmuv4loG0khMAVeE1AwF+E
	YNKeAecq6+S4/T8axh/9gaHM1ozgfG8XhqFgD4KrTU8R+C4V0vCs9BqG1sAseBwN03DfVkLD
	YMtZAl7U0lBR6KOg5eEAAqfDiqCv00eA6UINDXanl4T6nlsKaBmYIOCJ3UpAtXcLdLv6SHhQ
	WknI48rWlSRwlJkI+XhOgO2n2wTEXG7FuiokjJpPkoK77johmP+cpAVPuQcJ42NWJESqTFgw
	l8rXxlAYC0fq9gtVD0K0MBb9ixZ8IxWk8HslL1w8NkYIpx4tF+qlLsW29TuVa7SiXpcrGj5Z
	m6ZMf3h5/T7fnLwj1m8PozBbjBIYnvuM76/tJOJMc0v59vYYjnMit4ivO9FHFSMlg7nWhXxR
	7OR04wNOwweHQ3ScSW4JP/S0l4wzy33Od/wYId4+upCvrvVP+wly3dY2Ns0qLoU/VzxKvfXn
	8PfPBOQsI3+wlK8pV8XLWI6arjlwKWKl9yzpnSW9Z1Ug7EaJuqzcTI1On7LCmJGen6XLW7E7
	O9OL5J10HZw4dRNFWjc2II5B6pmsf3+yTkVpco35mQ2IZ7A6kQ3pV+pUrFaT/4NoyN5l+F4v
	GhvQPIZUJ7Fffi2mqbi9mhwxQxT3iYb/uwSTMPcw6nyV8UV2dJOpavTjjus7FvRfvPO415oz
	Q5JubnC+7J+f73U74cqqxJLsj/Zou0La4VUWIe/Od4de+ljX7JgntXzmL5ulo+7kA5sstxbv
	Zi8ot4bX4CTvV3vd1L00NlV6Vfbssn173uDd537tYOuinmPf6MV789pHSj48vTiYXjnUqCaN
	6ZrkZdhg1LwBtNOU7o8DAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: C9A78100008
X-Rspamd-Server: rspam11
X-Stat-Signature: 977zuf6eyriks4ty849eibem1nwmzou7
X-HE-Tag: 1764919206-943947
X-HE-Meta: U2FsdGVkX18VR/6/Jp1jtShkcuiu6hhLF1MPz8y7+42C2fK6uB8Nygs6yZmmEQThCZgnI2Q93o4bhwk0FnbtIzlPDUgScXHgOl/2gYY2qfW5b81Wv99TXXQqwNJrrEmsffU4Q7CbuCO1+/v7yuGiVDKnStIgEh26TvppBQelHBpWYKqYVoyXuIowiK45CeohzvRU2DdYmquMXcrvwReMcuW2xLo6H5p7TNZ1VbVqgQVBbYUYMlVUjYjxsm3GU85NfMArW+rm11biBF3UKHotMkk1xrvT6dh+pLGV4IiboRbQJHcyuQImVr0lmI15aC7gHorghbKnb3MxrUEps4wcYurJ75Plv3HXmw5lsf71nUxdFAl1wPStXU+C1acd/Ri/ejhqRWf6MQ4DERL4NxFCIX53VTY9nJpAL8B6gafwyTLUpnBT5VpoNj8JHh/on+aNS+5CabGuIUwYnxlphZ8YfhcNdGHsXYSO1q0aPflB2yWEVlxziBLF8gFHR914GBWKhCWAp2HpnqxjYakGZEKBrLQAHLUCG4TvpkEBRjYuXN3GrgnDlj9VJvg8yKMJkSQeliYCq217q4LuNLeAbCaPV52f+OnE1wfON126BuEwRQyTWHnX8cgpPKR+/RnM8kRHUAQJmXiQZICuxH8rJAJteh1dMQJCDSxvLieQqW93wLq1IECwHOecfg0Ud6bIW5bxHDn+fkHULpfuXNkX6GlUMn88opKW4P9ozM10BcQGq1MEku86O1EV1KbZn6fzvSWeaD5+S+sRaXrEg8HU2IniNoRKdO6cYw03YQD3qbBzHzSjqRPcEZetPOEYhkxXq3qxm51Z8Yd1jcuBC9Ib49zbPMDhLDAiMKsTBt2O9sTR+1WMYViHFkJOfhdp2DIYdBGyfGt4vJSyaSCbeVX8Bcu40py8IXhFMmKwF2mrVFkwN5HMCdSWF8NyhepVhtL4pUH27jPIxRTrfH1ynJqn43p
 bQM2WVO0
 FXAUZDrs07aMliQMyZ46JCj/kxaadmD6RcjwzXd3P47d29vGMIHfxCS0Q0WkNo5Bmh/8pywLGJx7hAgpEReiZhPZgOByPstg2lSIj5sRUPzKF6gscOAJtc4WwLOyeQVA0rQS5NFRAWJL0LDaLygkLTxXofKPweKvaEXkFLkbX1u66RCxBV09yIZ0GRHhirCbA/xfguaI0qB48qRSxiLG7t7tSuzlWlygUvyHe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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


