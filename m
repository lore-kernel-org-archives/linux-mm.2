Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303DBC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119E46B00F8; Mon,  6 Jul 2026 02:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA9A6B00F9; Mon,  6 Jul 2026 02:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5736B00FA; Mon,  6 Jul 2026 02:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDB4A6B00F8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:22:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A46A8D0EF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:01 +0000 (UTC)
X-FDA: 84957356442.16.4DF3EE8
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1CB2620006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:21:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=tvW+ldDk6GdwfPY70zXMRkBEKqIF5sW1VPttrf/0Qqo=;
	b=KfPRCdPZwgBxx92e5SSxPD122QDfLIoW2JPqFr4UcK28U7r2oJ1NBtasQ37xVwD5hIeSeh
	0l26pHqoO7JFnkgEVm1KIlNi8KuE73YnuFLdMo3zdFfvnkTpnk58SOucBHPMJZRHR0DzRo
	2r9/DUBo/UR0AHR9ibhpJDQ8IQypDW8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318919;
	b=eIeaMK5rpo2X2g0sbNX9hPV6t47YcOwFe0WKCX2hReMCAX3MgWY5L5MCfx4F3cIIfNLSJu
	Hy/hpTfFBBiFZUktzz9Sx5L4T/LLFDvBn110+ogarT15OkOf3/r353kWDZp2p4gwkeHPLY
	LgDUrLTFmwSCBgs5r9atvnLF2GrBmQs=
X-AuditID: a67dfc5b-c2dff70000001609-c6-6a4b4983a0e6
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
Subject: [PATCH v19 34/40] rcu/update: fix same dept key collision between various types of RCU
Date: Mon,  6 Jul 2026 15:19:22 +0900
Message-Id: <20260706061928.66713-35-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxiG957zng86a046N49uiaaZbGHi1CF5ljhDlix7nVviss0fGxGr
	HKVQKCmI1EVHQbeKOBmGLqPiEFxltFE5NQpEDKuTj2ADrAwrn602VdYJwlqcDOiom/+u3Pf9
	XL8enlYNMCt5bU6+ZMjR6NSsAiseLqlNLNm6LXO9uyIBzEe/guGxAAMDpjYMkbAZw7z1Kgdm
	+QcGOm8XYzjaHMUQfjLEQaUJgeOyiYLQjWkElf4AC9+PmzBM2soQVAWtHIzffB+iI/cpuD3z
	JwJbYIGCQNs3COYtWfBjrZOFkOURC/+4e2g46x+hobW+mAVPYCn0RyZZ6Ko8zsLDvtMUTFxi
	oe9WCEG1tQJBSd1FFizVMoZmXwsHw5YKCrrLaymwNC6HW3XDGKxuDwN366s4mPNvgGiNHtrt
	9zkYOVmJoWt0gIGrRT4Owv1+ChxlQRrMLREM8r3FonXwDTDPhxG0N92lwNNymoVRR5SB3+y9
	GLrbOzEMuU9y4Pd5GTg1EUQQmrHRKemkwXmFIo4zDkTCP5XQ5IjzAJmN/M6S1pkaTM4dm6XI
	d+5E0lw1wpEj1wc5UiPvJ876BFJ3bZwig6F3iNxwjCXydAW3fe3nis3pkk5bIBne3LJLkXG2
	p5XK7d9SeL20gS5CPetLURwvCkni1wtO9hmPjbqYGLPCa6LX+4SO8TJhteg8EVzMFTwteFaJ
	ZbYTuBTx/AtCmni+c29sg4U14pT34lOPUkgWh/7u4/5zrhLtl9qeeuIW8wtz1VSMVcImcWiy
	A8ecomCPEx/fafr/YIX4S70XlyNlDXquAam0OQXZGq0uaV2GMUdbuG6PPltGi99mOzT3RROa
	7v3EhQQeqZcoIeWDTBWjKcgzZruQyNPqZcr417dlqpTpGuNByaBPM+zXSXku9DKP1cuVG2cO
	pKuEfZp8KUuSciXDs5bi41YWIWtqxPy8R8pn/lIW3wzUvutOedG1Pesz5FvTIZ/KjSinDs9d
	WZFY+Fb2q8LOLuPSR4ONx1+JJ99u/fA9nX61eXZf+Mxa/du9u5M7ft4U/7HBl4xfikbG084v
	3Ljw5SGO+3X3Y7fpYPnlpB0f2Rs1f+g2pqZOGcf2Gu7JwQdt3Z9O5k+ocV6GZkMCbcjT/At7
	OUwdaQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUxTZxTGfd9779tLY81NIXqDiZoG8SuKZkhOVIgmRu40GhMTRRMDjV6l
	fKmtQzFblGJjZTjbmpZIQQGlakFBQBS1SiDrHIpQi9IMsGI6HAFFkSqfdu3M/jn5nec858n5
	47CU/C4TyaqyjorqLGWGgkhp6ba1ecu1P25JW2k6Hwt63Uno8foYeJXbRIN/VE9DcXUVgWnr
	XQnoay8y8KRLS0PHrUoEXr8ewddJKwW6xgAN0yanBEbHuyVgzkUQcDgRWFwmCjwdjymoqs/F
	8LnmG4HBlhEE5j4fgcKBXBqGbQUIivqtEhj4PRHeex8wEOh9h6HryxACm+8bBl/TGQTTlnS4
	XF4XXLd8JDDZ1k5BobkDQVlfLwUjA28Q1DtfI3Bc1xL423CHArdvFnT6hwn8af6VwHtXMYYP
	NQRKtQ4GXM8GEZRYTQj6/3JgyLtSTcBSUktD45v7EnANTmHosZgwVNZuBa+tn4anhnIcPDfo
	uj0HrIV5OFj+wWC++QDDuM0uWV+BhK+632jBXteABd2LaSJUXapCwuSECQmjFXmUoDME25ah
	YUo4XXdMqHg6RIQJ/0siOL6U0kJrOS9cPTuBBWPbcqGxqFeyfcMe6br9YoYqW1THJKRIU8va
	HfhwZ8LxR/l26hRqX5mPwliei+W9r5uZEBNuEe/xjFMhjuAW8HXn+oO6lKU493y+wHaOzkcs
	G84l89eeHAh5aG4h/8lTTUIs4+L47jGX5HvmfL6ypum/nLCgfmuqBIdYzq3mu4f/oA1IWopm
	2FGEKis7U6nKWL1Ck56ak6U6vmLfocxaFHwn2y9Txnto1J3YjDgWKWbKYP3mNDmjzNbkZDYj
	nqUUEbLoxVvS5LL9ypwTovpQsvqnDFHTjOaytGKObPMuMUXOHVQeFdNF8bCo/n+K2bDIUyj+
	PO6r2bs1ENs52/HQuNH+6fYPC3t+1p1s60hagjbJR4pnLotfUxTQ7Yjyawui8knU7lfUEaNp
	G7NkjafhUon7Rmt4Qtlzg3GMOC9E1scdIclvW/DOMynassRonX6PIjzJ1XUjGxrmHUttdS7Q
	lEu1MSSmKd697+bY6WimM05Ba1KVq5ZSao3yX1zt3TVKAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1CB2620006
X-Stat-Signature: muqrp31nzas4c3b49e6snmn3piztntyq
X-Rspam-User: 
X-HE-Tag: 1783318918-464468
X-HE-Meta: U2FsdGVkX19UC3+7aBxP6kQa5FLGzTd86yzfU8FnuOfdmc5AGpMHMGSbQAmY5i0bdkJ3uLE+u/hIGxf+SYIa+wNGI3KcZOpQEYjFvOBsgSsHCEJHbSV0TR/CIKxn1a9A5cv8r5/olYUA1w3njenvpQZGyt+tDFhUyMDrB0iRUlNDbxMJqAPErhxCyBZt1GpcwvgEgTEbOZXF2MiogkWB3rF5kwQD1n4QXNrxy65eal7tYAuTGqEl8bxkRSYOWpbCxoYdZ3OQxP7lYYZ8NBBmIpVM7kqmmsPrg+g8o8/HxOLdcqlF5BPDRzTh8gDEAA7omgXcGeYwCmgPTjmi3knr4P15cGYQ5q+BhKnDgCs/NZNzUeQJaLvRKB4qHB7k/VhVUFejqqiPbVnkBPLLA3B24YeDvRnLktOTlKyqwDG2Tptt7HJXSFnOlkn549XZwx8BBZMVVrwfbSccyVk75eZOPTOB5A6u9yZh9A0T2dVLGnNiMCaFS/NiZTVVdlPoCHKNogN9s0E6PDnUQmh3sMvbmwtqxO7UMAarTuU+9zgBbV/voMajJavFtSdLK0u6w8yyK+Z1Wo1fiNBGAG+NRfdhLfk+OwKdJ601yuDKmlXqCzQlo3YYDDC/2nOabEiFeOXShc0Owd9XCJOqv5ZwH1m88ABwSoRdtLpJF2tDqT1VTCdKcqsLUYTHN1+0u+Yt3NFd+kEFh49qTTtvJ9VMJ0alSk8ns8Z93jdiG+YxD0ghHQteED8V35l4BgJTZ7gG1DyVdyLqoCKcunrSpiCGirFPEmMxvSbg0Ud0lPCtobX7mg9w+vc+h0xySRq1Y83b074hysJap709GljtAiRearx9vZlfl9Wodv6ECKFgtlWXlPGPdLYmblPmxD+0svk8YjD125VMFeNLl6+N59Vk+Z6Dp8uyvzAb/GRGHhhKEfW7NSYoC2S1/2YvyjKBK13z7/D2mq7XSxA9WHH6bdAsE0E
 /OTyTjoa
 iB5/q5GeI+ejNoxLtmD1hhvCHIORTraL+AAqOSQCHG0YoASsWqLHse3QrR/HYBLGg8W3A2pyfUAp2RT5TTOC4nRrYxHUbFISIPqg8pk4WahyXZWq1Ul3PHPhUTr/DD82xSLH46pM3cg8GwdNBtyo9ffiLn+4TMXZl/UOF/CrkPzBUmnNr9uGPw5ybjVBDv7R27M24meeRxeZwFbARoArvVZX7pFTwX+eGVkB1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yunseong Kim <ysk@kzalloc.com>

The current implementation shares the same dept key for multiple
synchronization points, which can lead to false positive reports in
dependency tracking and potential confusion in debugging.  For example,
both normal RCU and tasks trace RCU synchronization points use the same
dept key.  Specifically:

   1. synchronize_rcu() uses a dept key embedded in __wait_rcu_gp():

      synchronize_rcu()
         synchronize_rcu_normal()
            _wait_rcu_gp()
               __wait_rcu_gp() <- the key as static variable

   2. synchronize_rcu_tasks_trace() uses the dept key, too:

      synchronize_rcu_tasks_trace()
         synchronize_rcu_tasks_generic()
            _wait_rcu_gp()
               __wait_rcu_gp() <- the key as static variable

Since the both rely on the same dept key, dept may report false positive
circular dependency.  To resolve this, separate dept keys and maps
should be assigned to each struct rcu_synchronize.

   ===================================================
   DEPT: Circular dependency has been detected.
   6.15.0-rc6-00042-ged94bafc6405 #2 Not tainted
   ---------------------------------------------------
   summary
   ---------------------------------------------------
   *** DEADLOCK ***

   context A
      [S] lock(cpu_hotplug_lock:0)
      [W] __wait_rcu_gp(<sched>:0)
      [E] unlock(cpu_hotplug_lock:0)

   context B
      [S] (unknown)(<sched>:0)
      [W] lock(cpu_hotplug_lock:0)
      [E] try_to_wake_up(<sched>:0)

   [S]: start of the event context
   [W]: the wait blocked
   [E]: the event not reachable
   ---------------------------------------------------
   context A's detail
   ---------------------------------------------------
   context A
      [S] lock(cpu_hotplug_lock:0)
      [W] __wait_rcu_gp(<sched>:0)
      [E] unlock(cpu_hotplug_lock:0)

   [S] lock(cpu_hotplug_lock:0):
   [<ffff8000802ce964>] cpus_read_lock+0x14/0x20
   stacktrace:
         percpu_down_read.constprop.0+0x88/0x2ec
         cpus_read_lock+0x14/0x20
         cgroup_procs_write_start+0x164/0x634
         __cgroup_procs_write+0xdc/0x4d0
         cgroup_procs_write+0x34/0x74
         cgroup_file_write+0x25c/0x670
         kernfs_fop_write_iter+0x2ec/0x498
         vfs_write+0x574/0xc30
         ksys_write+0x124/0x244
         __arm64_sys_write+0x70/0xa4
         invoke_syscall+0x88/0x2e0
         el0_svc_common.constprop.0+0xe8/0x2e0
         do_el0_svc+0x44/0x60
         el0_svc+0x50/0x188
         el0t_64_sync_handler+0x10c/0x140
         el0t_64_sync+0x198/0x19c

   [W] __wait_rcu_gp(<sched>:0):
   [<ffff8000804ce88c>] __wait_rcu_gp+0x324/0x498
   stacktrace:
         schedule+0xcc/0x348
         schedule_timeout+0x1a4/0x268
         __wait_for_common+0x1c4/0x3f0
         __wait_for_completion_state+0x20/0x38
         __wait_rcu_gp+0x35c/0x498
         synchronize_rcu_normal+0x200/0x218
         synchronize_rcu+0x234/0x2a0
         rcu_sync_enter+0x11c/0x300
         percpu_down_write+0xb4/0x3e0
         cgroup_procs_write_start+0x174/0x634
         __cgroup_procs_write+0xdc/0x4d0
         cgroup_procs_write+0x34/0x74
         cgroup_file_write+0x25c/0x670
         kernfs_fop_write_iter+0x2ec/0x498
         vfs_write+0x574/0xc30
         ksys_write+0x124/0x244

   [E] unlock(cpu_hotplug_lock:0):
   (N/A)
   ---------------------------------------------------
   context B's detail
   ---------------------------------------------------
   context B
      [S] (unknown)(<sched>:0)
      [W] lock(cpu_hotplug_lock:0)
      [E] try_to_wake_up(<sched>:0)

   [S] (unknown)(<sched>:0):
   (N/A)

   [W] lock(cpu_hotplug_lock:0):
   [<ffff8000802ce964>] cpus_read_lock+0x14/0x20
   stacktrace:
         percpu_down_read.constprop.0+0x6c/0x2ec
         cpus_read_lock+0x14/0x20
         check_all_holdout_tasks_trace+0x90/0xa30
         rcu_tasks_wait_gp+0x47c/0x938
         rcu_tasks_one_gp+0x75c/0xef8
         rcu_tasks_kthread+0x180/0x1dc
         kthread+0x3ac/0x74c
         ret_from_fork+0x10/0x20

   [E] try_to_wake_up(<sched>:0):
   [<ffff8000804233b8>] complete+0xb8/0x1e8
   stacktrace:
         try_to_wake_up+0x374/0x1164
         complete+0xb8/0x1e8
         wakeme_after_rcu+0x14/0x20
         rcu_tasks_invoke_cbs+0x218/0xaa8
         rcu_tasks_one_gp+0x834/0xef8
         rcu_tasks_kthread+0x180/0x1dc
         kthread+0x3ac/0x74c
         ret_from_fork+0x10/0x20
   (wait to wake up)
   stacktrace:
         __schedule+0xf64/0x3614
         schedule+0xcc/0x348
         schedule_timeout+0x1a4/0x268
         __wait_for_common+0x1c4/0x3f0
         __wait_for_completion_state+0x20/0x38
         __wait_rcu_gp+0x35c/0x498
         synchronize_rcu_tasks_generic+0x14c/0x220
         synchronize_rcu_tasks_trace+0x24/0x8c
         rcu_init_tasks_generic+0x168/0x194
         do_one_initcall+0x174/0xa00
         kernel_init_freeable+0x744/0x7dc
         kernel_init+0x78/0x220
         ret_from_fork+0x10/0x20

Separating the dept key and map for each of struct rcu_synchronize,
ensuring proper tracking for each execution context.

Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
[ Rewrote the changelog. ]
Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/rcupdate_wait.h | 13 ++++++++-----
 kernel/rcu/rcu.h              |  1 +
 kernel/rcu/update.c           |  5 +++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcupdate_wait.h b/include/linux/rcupdate_wait.h
index 4c92d4291cce..ee598e70b4bc 100644
--- a/include/linux/rcupdate_wait.h
+++ b/include/linux/rcupdate_wait.h
@@ -19,17 +19,20 @@ struct rcu_synchronize {
 
 	/* This is for debugging. */
 	struct rcu_gp_oldstate oldstate;
+	struct dept_map dmap;
+	struct dept_key dkey;
 };
 void wakeme_after_rcu(struct rcu_head *head);
 
 void __wait_rcu_gp(bool checktiny, unsigned int state, int n, call_rcu_func_t *crcu_array,
-		   struct rcu_synchronize *rs_array);
+		   struct rcu_synchronize *rs_array, struct dept_key *dkey);
 
 #define _wait_rcu_gp(checktiny, state, ...) \
-do {												\
-	call_rcu_func_t __crcu_array[] = { __VA_ARGS__ };					\
-	struct rcu_synchronize __rs_array[ARRAY_SIZE(__crcu_array)];				\
-	__wait_rcu_gp(checktiny, state, ARRAY_SIZE(__crcu_array), __crcu_array, __rs_array);	\
+do {													\
+	call_rcu_func_t __crcu_array[] = { __VA_ARGS__ };						\
+	static struct dept_key __key;									\
+	struct rcu_synchronize __rs_array[ARRAY_SIZE(__crcu_array)];					\
+	__wait_rcu_gp(checktiny, state, ARRAY_SIZE(__crcu_array), __crcu_array, __rs_array, &__key);	\
 } while (0)
 
 #define wait_rcu_gp(...) _wait_rcu_gp(false, TASK_UNINTERRUPTIBLE, __VA_ARGS__)
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 9b10b57b79ad..d30dfc345532 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -12,6 +12,7 @@
 
 #include <linux/slab.h>
 #include <trace/events/rcu.h>
+#include <linux/dept_sdt.h>
 
 /*
  * Grace-period counter management.
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index d98a5c38e19c..c2858650ccf5 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -409,7 +409,7 @@ void wakeme_after_rcu(struct rcu_head *head)
 EXPORT_SYMBOL_GPL(wakeme_after_rcu);
 
 void __wait_rcu_gp(bool checktiny, unsigned int state, int n, call_rcu_func_t *crcu_array,
-		   struct rcu_synchronize *rs_array)
+		   struct rcu_synchronize *rs_array, struct dept_key *dkey)
 {
 	int i;
 	int j;
@@ -426,7 +426,8 @@ void __wait_rcu_gp(bool checktiny, unsigned int state, int n, call_rcu_func_t *c
 				break;
 		if (j == i) {
 			init_rcu_head_on_stack(&rs_array[i].head);
-			init_completion(&rs_array[i].completion);
+			sdt_map_init_key(&rs_array[i].dmap, dkey);
+			init_completion_dmap(&rs_array[i].completion, &rs_array[i].dmap);
 			(crcu_array[i])(&rs_array[i].head, wakeme_after_rcu);
 		}
 	}
-- 
2.17.1


