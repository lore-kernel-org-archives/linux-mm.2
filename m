Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C93C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85586B00B5; Mon,  6 Jul 2026 02:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E086B00B6; Mon,  6 Jul 2026 02:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFCBE6B00B7; Mon,  6 Jul 2026 02:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B71A6B00B5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10BB81A02E4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:21 +0000 (UTC)
X-FDA: 84957352242.05.4ABAF15
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3C25320005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=2RZYJT4nXPz/0zunBSrL2ai9dkx+LO0+UPUASDTqCL0=;
	b=bb0ntZ+Nt2+4NBazRNMuvnSFWlsfLHPwcGjtxENtGpFSUyEuiFj7UdhaNZhF18TioVJH5s
	IwQaTS9EpdQcNTSLpO/+A6jd7J1fNeTm5W4JtJOg3nmCQ4covprmEos48i4yI29p7iuT3s
	vSScTeGTVHPV8AJevW0d+FsR2YOhShc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318819;
	b=v2lojVtVtiXepHv/Se5xgYf/tpBW03uq0G6Nfe2PYCPzmyQ6gaJ/NzAk0Pp3oeaplwB/aT
	up4uWxa/ICgv0fhjLL+qrA02C+1805Rw1FiILTsg2y9xSZBYejPhx6Xij0nepL8JmB+2PM
	i8vV6fwSo/bTxj950ylA/xm5OMrhT9k=
X-AuditID: a67dfc5b-c45ff70000001609-c8-6a4b48fe1d04
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
Subject: [PATCH v19 13/40] dept: apply sdt_might_sleep_{start,end}() to hashed-waitqueue wait
Date: Mon,  6 Jul 2026 15:19:01 +0900
Message-Id: <20260706061928.66713-14-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTBxSGd+5XLx0l16rxijFqE8Vo1Pq1nCVz84eZV8n8iP80RBt7ldYC
	WpQJzq0MzaqgNtVKAFEooSJU0QuIikRArSKYlKBSRAQUSkmZTQjgGO26wua/97zve87z57Ck
	soOOZXXJR0VjssagYuSU/M9o+wrYEq9XZxnRfPo3DBXUytAs5dHovlUB2DNmBvw8WUBiyOqS
	oS0TMFzvArzcZiXR435EorM6k0BbXz+DuUOZFAYcOYBDTzdjuHuQwI7xYUBH/z8E9jf8AZhr
	cwOODPUCVrveAw5Yakhs74/BV2MBBptt2QwW/V5Po/dtPYFZJZUMXi6UKGzzBwmskH7CFoud
	iFAi9p05WJDri3Bv1hE44SiXocO0GMNFKdh9wUah32tlsNbUK0Op8yng6Ks+AqWPb2jMu/qO
	QXNoFNB17wOB7Q+uMJhzu4bG984wjaaCzzRWDnoIbHE9p7A5/waFpR1tBPb1emisetlK4vj5
	eeixDADe/GRn8OInL2zUCs6rThAm/7aCMFqaRQqnLZHx8XCAFEpbhhnhhZ0X7ud3y4Qi6ZhQ
	VbZMKHk4RAjFI2O08Na/QZDKzzCCNGKVCcWTPnLH8t3y77SiQZcmGld9v0+eWN16Bg73sMdL
	3JWkCXqYsxDF8tw63vy8Fr7osuI6YkozXBzv8UyQU3oWt5CvOuelz4KcJbn2BXyO4xw1Fczk
	EvhgXWi6RHGL+cCp19OHFNw3fGNn5/+ABXzF7YbpTlTEvxUsnAYoufV8V+AZNXWU565F8dfH
	r9P/LczlG8s8lAUURfBVOSh1yWlJGp1h3crE9GTd8ZX7U5IkiLyb42Rwzz0Yce9qAo4FVbQC
	N27VK2lNWmp6UhPwLKmapViyNF6vVGg16RmiMWWv8ZhBTG2CeSylmqNYM/6zVskd1BwVD4ni
	YdH4JSXYqFgTZPwwe9GJPR+OEF87TwyWl+4Mbrvb12CXgU/9Otp3p/5U/jZojF+l+qt24XZq
	MmYDnaAPyCcunSyczb3I1vpDPdSv7YseGjYdaToQ1zYjTv1LQuVSdQyl6/12Z+OzgSd+PCRd
	0NeUrVXsqtGFu+b+2DqQx6qbM3yGhvldsdnej90qKjVRs3oZaUzV/AsL6zhiagMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+/3u3d11tLgspVv9UQ16YyVknB5EUbGLVhQUQVB6qUvOV7KV
	ZRE552qahi43qWmp5SV0qfkoH4zWSqtl6LLSHraCZYnWIh/lY9qU+ufwOef7PY8/Dk0o6iXz
	aHXiCUGTyMcrKRkp271RHzrBRcauedfIgtFwHj54vBJ4o3OQMDRoJKGg0kaB33pfCsbqqxJ4
	2plGQntFOQLPkBHB7zErAYaGSRL8phYpDI68l4JZh2DS3oLA4jYR0NX+gABbrQ7DQNUEBX2P
	fiEwf/ZSkN+rI8EnZiG41mOVQm+zCr57miQw2f0VQ+dwPwLRO4HB67iIwG+JgxslNYF2y08K
	xl60EZBvbkdQ/LmbgF+9nxDUtnxEYL+dRsGXnDoCOryz4NWQj4Jn5ksUfHcXYPhRRUFRml0C
	7tY+BIVWE4Ked3YM+puVFFgKq0lo+NQoBXffOIYPFhOG8upd4BF7SHieU4ID5wZcd+eANV+P
	A+EbBvOdJgwjYpl0Synifhsuk1xZzT3MGV76Kc523Ya4sVET4gZL9QRnyAmkj/p9BJdec4or
	fd5PcaNDrynOPlxEcq4SlruVMYq53BehXMO1bumerQdlm44K8epkQbN6c7QsprY1AyV56NM3
	2yuJVOShMlEQzTJr2dvFTXiKKWYp29U1QkxxMLOQrcnukWQiGU0wHQvYLDGbnBJmM4fY8Sb/
	tIlkFrO+9NdoiuXMOvbh27f/hi5gy6sc056gQL1ivHB6gYIJZ9/7npA5SFaEZpShYHVicgKv
	jg9fpY2LSUlUn1515HhCNQr8k3huPLceDXaonIihkXKmHLZExCokfLI2JcGJWJpQBsuXLIuM
	VciP8ilnBM3xKM3JeEHrRPNpUjlHHnFAiFYwx/gTQpwgJAma/yqmg+aloqD0nZtWEMuMGS7X
	nwOZbXnOZ7HBh93DPFUPzcv3RYmOg2c667rx2iPRIQW5hgHCxWxXhabyxrn+sytDnshLLozJ
	V4oFpM8mqvbrlWFLZjTvvJp3/sJHT132or1FO9jS+QPb1u+YuOJytcpupFx/vFDVhsO05bpt
	dZMbOh3O3UpSG8OHrSA0Wv4vV41UCUsDAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C25320005
X-Stat-Signature: iewaktwia1f53gaoyqahcwngz1qgbtiu
X-HE-Tag: 1783318818-370898
X-HE-Meta: U2FsdGVkX183ifElKTCpOk74fYThNVjnehDIyI+Rx+WYWnea1bE2ybCuZrUex5xi9aig07VPj99JKd1dVVeKVhgYJMcDkzGdCnFmWe8nSNk0GrGw9bQA295Ld/3fMkByi+qw6iZPlQKyiu6i27GaDdzsWrpg68RIFNRbkUio4ce90YIcswO38WU6ixsbA/AAaS/fQXLbHS2MMHB/6iwpHIbMBv1AREpOM/lucbsTqmv916n98wShIcRm7/JP6onA0P1/tqY/E7OpnwkdH7Iqhn5SN4Kx6Rr6KJV9z3AEPZlhIeO659XwR++9yc2s7UXkdylWZmw+4G+FSBlUxN+yZqlMIdnR5vOhURfrVDQMBqfvjZAMaMp04bnQpcNFMjvqTS2y/UVh+OZrdk5xpQjMgovBjaSWIHXit+mgCM2cSuwW7oETFYcOra04FTqZXtIhtwHrKMsEGqraUt8RLEAzX1J1mmBOpM900Di6sxTGaZnflZeVgXr3FB+cVznhqQwUHBGNr5Ajb7DLeHaeAWg/HgwrDQSIrvebqvqV2/hjOSOXOzRJQ8Ye2F9c3akoZ9aEuPh5jhobOoa5SiuBfWVmJdR9TNUT08O/3h3yl6VWdXlo3DVuRqYmapGrVXcPDNevGh5i+p1dhSxSf5mvXOmUkSzay9KGA2irl2/EEGrwOOMurExnTxGKrN2+XddHYP7LcX58nzLHMhQC1gZyQRhJwpVULVC8qmUsnPi++Ki52Q9DWjCDCjPJZOvJ+OsA/X8L+Bgbb8yb51SqyEHnHBKdtW9mPtlx0aeHeUDIwo2bPu9MpVyCVTU5AHoftsueOoBdKEYPRJh8DaGXYUj857JHruyzcG/H6XFJyjXHvCYN6O+vxtUnW/C6fq79ZR7G5+WdX+nCgG7bXyYbthYudeUTA560jRXKXXe3fNOX20vKxsXix6ojy5qvN7BWXbp9VNJVvDAfkdtWPRwMcdwaCZY
 7Y75TYel
 esCThohJsNerNmhe/j6UxBEvAphBsUlK7NcKk3ZjkJtZ58tIN/dnkfaQP9OxgU/EjoJxjBiNbwsI7u/IXlJ40fDKulubyXuscIBPLGPbcLvr2lxXtxuP5s+XKGJ91ZK0XUxbCBjK1cJG46KcoN4/2tsGTdLly6014DDtJi9V4hJyiMYfBMpVXwf1Xgi9bznTQPlrBi7TUmCL5nuzTj0V9s+CBdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by hashed-waitqueue waits.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/wait_bit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 9e29d79fc790..179a616ad245 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -6,6 +6,7 @@
  * Linux wait-bit related types and methods:
  */
 #include <linux/wait.h>
+#include <linux/dept_sdt.h>
 
 struct wait_bit_key {
 	unsigned long		*flags;
@@ -257,6 +258,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 	struct wait_bit_queue_entry __wbq_entry;			\
 	long __ret = ret; /* explicit shadow */				\
 									\
+	sdt_might_sleep_start(NULL);					\
 	init_wait_var_entry(&__wbq_entry, var,				\
 			    exclusive ? WQ_FLAG_EXCLUSIVE : 0);		\
 	for (;;) {							\
@@ -274,6 +276,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 		cmd;							\
 	}								\
 	finish_wait(__wq_head, &__wbq_entry.wq_entry);			\
+	sdt_might_sleep_end();						\
 __out:	__ret;								\
 })
 
-- 
2.17.1


