Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC88FC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C106B00DF; Mon,  6 Jul 2026 02:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424636B00E0; Mon,  6 Jul 2026 02:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4F76B00E2; Mon,  6 Jul 2026 02:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5CA96B00DF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57E611202EE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:48 +0000 (UTC)
X-FDA: 84957353376.19.7781658
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 765FA20002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=NoGwPeDFjlzz1rEekEmJHx4Uu+BeL/5f42v/t0kAGX0=;
	b=43wduMJk/iLtO5QojqW/hdIgHRyiYe2NCO1XObA8vsnvwCf2yESbuMNcQhTL1+wdr97qjT
	qsZZykuEeNzHJTBlsVJrqAn15xWIwxzZhEjl9SnjaATXE0gcIrJV7Py8I+Z3i+uvbfZ2Vl
	48D8Rh13pUwgBmUj80lstq+mH7DcmBw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318846;
	b=7XTWxl9JgGreqkssTr3UQ5qv7PH/WqvPj+0rx/HJ6NT2u4FIb5oDPCHgHwUsOCOk6CpbAu
	BKHqkS3FYSdaVTtwcHXPmqL3O8o2yZ3+OyI6e91DgPnRhxMRzPsD/pMLCahD1ARba9Jtwi
	QOzoLAaVxxrYEVzhAWHNUKY74TQpEN4=
X-AuditID: a67dfc5b-c45ff70000001609-58-6a4b4904a87b
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
Subject: [PATCH v19 26/40] cpu/hotplug: use a weaker annotation in AP thread
Date: Mon,  6 Jul 2026 15:19:14 +0900
Message-Id: <20260706061928.66713-27-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTH99z7PPfeNja5qUQv+IGlRrtoxpToPMpczL7sbm5hyb5s08Q1
	cidF3lIQQTet1TKC4pBEJ1SxQCxgq2Kr4UVqALVY0ayKQrVIK6slBgnujkoQgbWYffvl/8v5
	n/PhcLQ6QJI4fW6hZMjVZWsYJVaOL6r7mHy1NWvNsxYEQ8EwgYFDXRiik2UYzlx2MDBraWWh
	zFlN4M6gCUMwWoZgasZCg7l9HsNslYeFyekACycPIZh3exD82zLHwNhNGcF48DoBW3iOgnDX
	7wjO1bti4tRrBuSXIQRXPcMI3E0mBl5UXqPhUXSCAe/JowxYTW4CkaduCk6ddWJoD3WwYHd+
	C0FbBENfZX0sv7IULH8epmDadoGFew1DGGzGFWC5309gpKmGhXlrHnjsoyx4hwcIjEWqGAj2
	lhJoNYZi5z56ToHjWISG6tohBjrdXgxls5MIPG0jFPR3nGFg2DFPwGiZIvDQ7sNwedRPQZ/n
	DgZvTTOGvzouEjg/+IAC1/17NPhOVJAtGeKU+TgWzQ9nGdFR60DizNsqJN58NUGLR1x7xfN9
	rxjxbfQxI96tF8T2mmesaHXuEY/cGieiq2mV2ND5khLr5CgRn45t/m71T8rPMqRsfZFk+OTz
	n5WZ/roenB9RFE8PvyFGZOLKEccJ/DrhXIAuR4oFnJs8TcWZ4bWC3z+9kCfwHwquiggpR0qO
	5vuThWO2ChwXi/lvhAeD9WycMb9CmGl8QuKs4j8VAt1e5n1psmBv6VooUsTyS+/OLixQ8+uF
	wEQvjpcKfKNCKJdbyfuBRKG7yY8rkcqKPriA1PrcohydPntdSmZJrr44ZWdejhPFXs7227tt
	bUj2fd+DeA5pFqlgy9dZaqIrKijJ6UECR2sSVCs/2pqlVmXoSvZJhrwdhj3ZUkEPWsZhzVJV
	6pu9GWp+l65Q2i1J+ZLhf0txiiQjWuJKO5jX8sXI0QZtepHtWtLASuu4r/SPHYe/DMps948/
	pN1OXS2TfJxVWXrC0sya0gtr5eeJSxLzfVI4YcT1epuxuO+Adn9tuLP37nKvdnv/nGTVjR5o
	C11NVSeHtDdS6A5z+qaNaRsCimo5oebXG4lmjb658ck/ob977b80nNbggkzd2lW0oUD3H7la
	QUZuAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe2xLcRTH/e6rd80qV7fYDX+QikckGxKWkxAhzK55E48swsou695axojH
	Oo0alWrSjlXZxopttq7z2EZjKuYxo7WxMduQrszGmHayRzct8c/J55zvOd9z/jg0Lq4iJ9Cy
	1L28PFWaLKGEhHD1/OxwfPmKxNmXRyJBrToK7ztcJLzJqiXA61ETcKG8lAKf8Y4A1NbzJDxp
	VhLgKCtB0OFVI/g9ZMRBVT1KgE9XJwDPQKsA9FkIRm11CAxOHQ4tjvs4lN7MwuCXZYSC7od9
	CPQfXRTkdmUR0Gs+jSDPbRRA16No+NZxl4TRts8YNPf3IDC7RjBw1Z5A4DMkwaXCSv+44QcF
	Qw0vccjVOxAUfGzDoa/rA4Kbde0IbNeUFHRqb+HQ6BoLTd5eCp7qT1HwzXkBg+8WCvKVNhKc
	z7sRmIw6BO53NgyyL5dTYDBZCaj+UCMAZ/cwBu8NOgxKrKugw+wmoF5biPnP9XdVhIExNxvz
	hy8Y6G/cxWDAXCxYVIS436ozBFdceRvjVK98FFd6sRRxQ4M6xHmKsnFOpfWnD3t6ce545X6u
	qL6H4ga9rynO1p9PcM8KWe7KyUGMO9sQzlXntQnWLo4VLojnk2UZvHzWwjhhQkuBnUh3Bx0Y
	aO8njyElnYOCaJaZy454zmEBppjpbEvLAB7gUGYyW6lxkzlISONM4yT2tFlDBIQQZiXrbC4U
	BJhgprJDV9+SARYxkWzrg6fUP9NJbIml9q9RkL9eNmz6u0DMzGNbex8TWiTMR2OKUagsNSNF
	KkueF6FISshMlR2I2JmWYkX+fzIfHj5bhTyN0XbE0EgSLIJFMYliUpqhyEyxI5bGJaGiaTNW
	JIpF8dLMg7w8bbt8XzKvsKOJNCEJE8Vs5uPEzG7pXj6J59N5+X8Vo4MmHEPrtG8O1+xyLd1f
	JrrR/uC2RKZdtefcrKNtFx3k4qown7LV2zzX4Xi9NdbdNPFF6MZtG+yak+XGmE2m4KXMdxOm
	MS0rsN/rXBMS3xXVN8UaNVN451VFZ6xFE5YTsv7HvtVfHdG2Qz/TP824Pn7LkTM78jrHqeXB
	kTVLvE1N0zZGWebUSwhFgnTOTFyukP4BUcBZc0sDAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 765FA20002
X-Stat-Signature: wmfxo5zaq74ee1bf9dtquctf8nwn9qyg
X-HE-Tag: 1783318846-320791
X-HE-Meta: U2FsdGVkX1+1eIWn/TnX+/A4UDOTUyrLgMp3N3SG590Hf5HMmwc7MIFSrf2m1lD5r6JcfCBXoXpxQdkdCm+mPPAPiWCKSRZeZRLehhBhHhZCGdrV18/hSAdXBXB35w3EzBM3JxzokWsWbQfPIr28MIuJcRmoW13q8PiJideNkzWZuWsT8LeajmY2BJxRliNPdwbWyx2ZIiPFpRoWpF8s6FonuG7yWcMRxWpfHR2xYCRgn1G3oeSVetY14xrkwacBPMgwuYC7hC5vW8eDQcepGE759qe0la5VAZVtl1dEk3ZCO+Xt/6NXLRlOdYqVDluDcUiDQj8WbMo1u2YkLcLyGtfwI3+Z2GBzsiVj07wofQNXivN+jgN/PjslSmMSJpcuXK2RBJ5CzDdm4kF3ofO3AHXrK51B/d7oa3VWmhCSQBInRZEpnMBCyPLxMX1fJm9b1OSuHguKSgRTSt4Pf1keuwMfAWH5PcIXNT4BWQF/GtADGPlLlXsCtx4Jiyib8WRE4OOThxFobq9VU1eP3N60A+5ovJ5dY3eZhb2cMFtixKjdf68bRImzExotkQzwXMId/n595OptcgRjBFLZm4TyBeeDCs6OjsRj0WkMGDsMogb2gi5esk8mPHc7g4bMcd6bYuMa+WcagyEACvVo5wMvn8CK2VN+hj+MAjapQdGd/C9GLVvvJafDDvfju+anESXEp8EGZxT73fwY41QqserK0lYzVNGwaai7siSfuY5PNTDZ/XMOQtU/S9NeSyDEupITaAK+p+HLQg3xuk1h1HcvBytyXOUDffneOe9l6Fk40Lh3ifg0D9WgtiBJA/5ZCrkIDXXTDpdBAbYi7I3u4vviTtbZ+H6ERqL//OCfOF+cFRNkkQqHbu20N7+DlOPXmr/N3FKaO9dvNDMwNR/l1jIchu05mPTJr/2uPcUuqoHr/FCXLZhozGCxojOSyaP7b5slz+tKd5LwWF4d2O3Rz1C
 200Oh/Jo
 d3Zl3yCzAGboSCDM4ai4YOAD/LJQDCW1Av2yywWEnUlzTMwkOWPiwWc09QrhqmxDGela+ie80l1c/gKY9t2KVaZbK/s7g0eOOD+b68KJVR6NvfRjm6WagU2Hpek0Gv7/B698TtalQzpHLjeGZ1e42DArFsgtwceqdGxVkmstdHG5DDvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cb92173d1f0 ("locking/lockdep, cpu/hotplug: Annotate AP thread") was
introduced to make lockdep_assert_cpus_held() work in AP thread.

However, the annotation is too strong for that purpose.  We don't have
to use more than try lock annotation for that.

rwsem_acquire() implies:

   1. might be a waiter on contention of the lock.
   2. enter to the critical section of the lock.

All we need in here is to act 2, not 1.  So trylock version of
annotation is sufficient for that purpose.  Now that dept partially
relies on lockdep annotaions, dept interpets rwsem_acquire() as a
potential wait and might report a deadlock by the wait.

Replace it with trylock version of annotation.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index bc4f7a9ba64e..ba9d89613590 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -542,7 +542,7 @@ int lockdep_is_cpus_write_held(void)
 
 static void lockdep_acquire_cpus_lock(void)
 {
-	rwsem_acquire(&cpu_hotplug_lock.dep_map, 0, 0, _THIS_IP_);
+	rwsem_acquire(&cpu_hotplug_lock.dep_map, 0, 1, _THIS_IP_);
 }
 
 static void lockdep_release_cpus_lock(void)
-- 
2.17.1


