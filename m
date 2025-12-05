Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF7BD2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CF06B00E5; Fri,  5 Dec 2025 02:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2696B0030; Fri,  5 Dec 2025 02:20:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04DA6B00EB; Fri,  5 Dec 2025 02:20:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA6E16B00E5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B9811604CE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:01 +0000 (UTC)
X-FDA: 84184568202.26.A5BC818
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFEF840008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919200; a=rsa-sha256;
	cv=none;
	b=XFtwugJhMh7TVgUdPWCiaDDFIQtJQcQNGel4QRrxulzgbP/besCMTbPMO3aYNKeWge1PEv
	NMkJkKB3icOHfJLOClWMbTyInal9CL30szacB4m1PfrAl4FUWtz0BAnfFdKSjWJggrSS1m
	sgWkvKzZdnlcsbTaJplvnyxEoxR2lHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=GYcjzlTIOlZP3QZuzXKJbkX9X1t9OWfOQ/saEp/btr4=;
	b=ubrPF/B7kH0dHu/MoRl9RvNZZaskpuIJn326yUuGhikPZo9Oaf+P91U8AbpFMpQK8VCYGs
	3oAlZd390jB2u9fjF3u+q3wBAIkLRUwyrYZdYkJf3ycpOBvks3AVLK+8mbZERvy3/1q4b1
	JAWNyUkY6/iEv/0G9jnD3DfNYPi0loA=
X-AuditID: a67dfc5b-c45ff70000001609-3d-6932876f6900
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
Subject: [PATCH v18 19/42] dept: apply timeout consideration to hashed-waitqueue wait
Date: Fri,  5 Dec 2025 16:18:32 +0900
Message-Id: <20251205071855.72743-20-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUwTdxjH97vf3fUldrl0JNz0D7cas8UERw3bHg0xxmTJxY1sybJkcSxa
	7UUutlSLgpgYKZWXKWBxa5tRwaPIhWlBpGPZpmBBF0XoaAG1TCqiWKNtARkvA3RYa/zvk+f7
	8jx/PHKsHqZWyoXcA7w5V2fQ0EpSGV/hTjOVbRDSR5wZUF5yFEZGxym4bfGRcPqCh4Ybd4pJ
	GJ0tRzC/5MIws3BXBnYLAkfwFIZQ4AoGz68WAqJXpxE4n1hImJQqEMRHL1GwHH5MgDT+PwEv
	HHvhjNtLQ9QxRcOSvx+D0x5AUD8WxjD95D6CjqZiGh7Z2jEMjr8NPfYTNMSDpwkQizsoCPZF
	EdS6TiGwNlygIRh9TsD5tizotbmJxFIaHBdTweW0EmBvvkRAX8MICVLRWnD5BxNXiCYIn7ST
	0BLvp2BmaIwAT0UEQ33pWRIud/SQUNHaTsE9zzIFAV8vBT01v5DQ/2czBV5/H4ZAdSUFzRNu
	Gn6ciCCIzkkYBnwiAZauBhIit0qJLXrunPc3gisZeEFznjoP4mYarZgrsSXoamwSc429MZpb
	nL1Fcx1zIsmd/WGR4Kr9adwfNWEZd6zzHxknth3kjl2LU5y3ad1XaduVmXreIOTz5o8271Tm
	zJ/I2lclO/SotZoqQmPUcaSQs0wG21gp4Tds7S6VvWKa+YANhRaS8xTmPdZbGUn4lXLMDK5m
	yxaqksI7zDdsuOV2MkAya9nI8sNkqYr5hJ16+rfsdelq9nyrL+lXJOb2O4tJVjMfs2eOzydL
	WcalYB84/yJeB95lu5pCpA2pRPTWOaQWcvONOsGQsT6nMFc4tH63ydiGEg8nHXn+3e9oOvB1
	N2LkSLNC5SvQCmpKl59XaOxGrBxrUlQxQ7qgVul1hYd5s2mH+aCBz+tGq+SkJlW1Ya5Ar2b2
	6A7we3l+H29+oxJyxcoi9H7mmq3azLquYVPt/qFPyWuKz/1NN2FL+vWJSZ9Vqsrh87/Vbixv
	OYJ2iGLl3LO6zpSjY75NoaltwZ/wfx+2L+ml70tatYdrHL7tWZ6+1Ow9ZZc7Jwfs/9YPuXtj
	ZSdrpxVCQcywa/hLyXalMVyU/fMaetvsF+JnlodZxvZsY52GzMvRaddhc57uJQZqz6ZsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzVSe0hTcRTud59zuLotyZsh6iCKIjPLOPSiIOgSJBVEEEGOvORyztjy1YPU
	tVwrTUeb1LJM54ppaZqW1cqU7GGWNlPRTM25Mi3LtDEfrbXon8N3zvfg++MIcPFdMkggUxzh
	lQqpXEIJCWH0OvXyxKxIWYRd6wdazUl43+sgoT2jjoCJcS0Bl8vLKJgx3aVBW3mRhOcdmQS0
	3CpF0DuhReCaMuGgqfUQMKNvpGHc3U2DIQOBx9aIwNiqx6Gz5TEOZXcyMPhZ8ZuC4YYxBIZ+
	BwX5QxkEjFrOIbjkNNEw9HQrfO19QIKn5xMGHb9GEFgcvzFw1GUhmDHGw9WiKq/d+J2CqeY3
	OOQbWhBc6+/BYWyoD8Gdxg8IbDcyKRjMrcbB7pgNbROjFLwwnKXga+tlDL5VUFCYaSOh9dUw
	ggKTHoGzy4aBuricAmNBJQG1ffdpaB2exuC9UY9BaeV26LU4CWjKLcK8db2q24Fgyldj3vEZ
	A8PNBxi4LVZ6UwniXJocgrNW1WCc5u0MxZVdKUPc1KQeceMlapzT5HrXhpFRnDtVlcKVNI1Q
	3OTEO4qz/SokuJdFLGc+M4lxec3LudpLPfSOzXuF62N5uSyZV67YGCOMc53dfjiHTh2syCPT
	UT+pQ34CllnNqutP038xxSxmOzvd+F8cwISyVdlOr0YowBl7CJvlzvER85jdbM+tdp+BYBax
	Ts+AL0jErGG/f3lN/wsNYUsr6nx6P+/d0DHpw2Imir2qc5G5SFiIZllRgEyRnCCVyaPCVfFx
	aQpZaviBxIRK5H0ny4npvHto3L61HjECJPEX1aWslIlJabIqLaEesQJcEiAakUfIxKJYadpR
	Xpm4X5kk51X1aKGAkASKtu3hY8TMQekRPp7nD/PK/ywm8AtKR7rjaz/o+sLz3UHdGz4+UgYL
	2y5ee/4ERUQ/655rX7Bsen4aCi5+bTXr1jTfW+Qgm5amUtl75pz66b/50M6+z+dnl2b/cK2q
	jhxy7DBzC6NDrwyYG8sD9lkfJh079mVLrIfxxCwJjAiqafKI+PgL5kBF6ECxBYkbiq4/juwK
	C8vbJSFUcdKVS3GlSvoHOHKecEoDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFEF840008
X-Stat-Signature: bz16znd6ue1sjumkzmw13d997edcunnd
X-Rspam-User: 
X-HE-Tag: 1764919198-773453
X-HE-Meta: U2FsdGVkX18BIadJ5XYWDh03Kct1xgTPNs7RFQstIHEAIh8gHLFzqH8m/2UnDN3vTHSvPQh3EDQGABN5sKR5U7YEEzKd+lei5JTyyrZJLjfF4ws0eRqUhucEw4bgUeWMWS0ue6MsyquvjyQ74+eoip8PlcDbvrr2oieWaCmy0KGFUs03v1TT6sypaQtXE/z/SGlIeHQUMzTjRsNXpgwJfDqWeoQb4SpXQJb592tNCy8MKW0xABKy4oJgZUksz7W+8O0AVII0lm3LkFUpNvU6iPwio3acXoe26k+CFv1FimsvgAF7BHtxQuyDUtO/TVkOy7ViFmmZOtO2VoT/c6hniSTO9QykCfE7qqlDl679bz4O34XTH9H2+M+Vo5ErQGO9FMOEoyiR95D0jdazLTDi8graH/GoWN6fNndERXetT2dTO0y+2g2drE5xHRDsneSpCltqyTnADqyC+XX+juIEFUNBx/JOBERyrXHFSet6/p259H+8mEbPqiONg6UtU3kZ1j7z2JXB7deG9hkJq/V62WQ3sexyrSLdvy0ZnjAkv4S5N406dni9nklwogDfNETjVqAoWbcr3Kael6taxnnooPjBFht0qo/ncGQa5I4CzAHq15f77K3kP7i2ZZvMVGYN+NoqdXKw0Q9ubs81e9TQa/jKBWn5H/cRx4pOxamXshsOjR3XkirSM4tq3BOuQE+AGgWI4yawL00sYxRQ6Y4gPFO56Nz5egoNP+SL7BfEP4MFYvvhSdPMU6JNsvasgLTFqpT819SsO+ubfkr7snh0t6L5YGNvk6lj4uudiTXg6D55f+dgbrUYK7WGQCcZbqCMn96s8VOLpZ0xjudzi8BkdWtbdYPObYAfxLilCZL9AeMSw0oBGKyxZhpbXixCFJ99WfYCUCs2O3bZlE/w/GAZCuWxb0a17Dztj6hp2cuZXyg8A7dT3UEPRdqPd/kGAG9KVjOP29tpDdLDGCJtLhO
 OCTlCRG1
 Fp8g/9YfmZ8XYAcYB6CwjYK4nOy21r7dsQMa6Pz43l4hjgBVNAhoG95D+sYKEWTilq4nUPr6K8XJQUtU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to hashed-waitqueue wait, assuming an input 'ret' in
___wait_var_event() macro is used as a timeout value.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/wait_bit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 179a616ad245..9885ac4e1ded 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -258,7 +258,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 	struct wait_bit_queue_entry __wbq_entry;			\
 	long __ret = ret; /* explicit shadow */				\
 									\
-	sdt_might_sleep_start(NULL);					\
+	sdt_might_sleep_start_timeout(NULL, __ret);			\
 	init_wait_var_entry(&__wbq_entry, var,				\
 			    exclusive ? WQ_FLAG_EXCLUSIVE : 0);		\
 	for (;;) {							\
-- 
2.17.1


