Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 092B8CCA472
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19F18E001C; Thu,  2 Oct 2025 04:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55BD8E0022; Thu,  2 Oct 2025 04:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C328E001C; Thu,  2 Oct 2025 04:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADE28E001C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CAD21403B2
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:55 +0000 (UTC)
X-FDA: 83952460830.15.F017558
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81D25A000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=GYcjzlTIOlZP3QZuzXKJbkX9X1t9OWfOQ/saEp/btr4=;
	b=SFet7mJIpozLgnnlUULWalOpf1g55p9etuc6qHzO4kfEa4uwggVCOs2NDx7d2yJP/TrGs7
	DMKx8fyZuyFR59iNEFKDs1OcTqhV//F8yp3qWPwEe3HLIqPazEPFJ5It6cpVMhtuNNyWyb
	+9nVKgmQocGkr+9D56d/C6oG1UtU/UA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392833; a=rsa-sha256;
	cv=none;
	b=NSbKXgXAGZK1U5MaEgDpWMSWfRt5bOgen/QQyclPf3p6/h9QVOIqCGGWukDItAw8Gp2tIH
	6GfRySWVK9k/W70Cc1zB59dreMjhD7pBxVtPr3rMbCH6vQgfF11tooaj9eD/umMm2toyuT
	00mp/iAEjsrC/hZ3LFdNjAxHxE7K05g=
X-AuditID: a67dfc5b-c45ff70000001609-11-68de34103173
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
	dave.hansen@linux.intel.com,
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v17 22/47] dept: apply timeout consideration to hashed-waitqueue wait
Date: Thu,  2 Oct 2025 17:12:22 +0900
Message-Id: <20251002081247.51255-23-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSWUxTYRCF/e9OpXqtRK+CURsJxsgaNJNoXF7MNcQEgr6IRqrc2MZSSCub
	RgMqihgr4oJARFCBWiA0BUUEYmV5AATKIjQKhbLjAgFrERew1fj2zZlzzrwMg0tukesZheqs
	oFbJlFJKRIi+uBf4ssFWecCDu4HQm2IiIM2YTUJq9RIB9oUPNNzvzMShtDIFg6+GRQqyplII
	WBqYwKDP8RlB0egiBqOmawh+tnXgUGAbwGHS4BzrdJcoeJibiaDz0y8MBovGCWeWgntlNRgs
	FOlpyG3rJmFYl0ODvceGQXZePwVpv+0IrKVLJJhNrSSUT1gwsA1ZSLBkjCG4Mz3uvPhthoYu
	Uz4GutksEgxXnAX92o8ENJZXYVBhvIfDj+ImBC0/WjCYe7hIQm6KFkFaowOH503zNBhmiymw
	l+ipfQH8fKqW4EvzShFvL7yM83WOfIK/3ebLV+cM0Hy+MY5/UjuF8Ub9dYo3zmXSfMHPSZzv
	762l+On2dpof7cnC+LzmMP7D4gge6nlUtDtKUCriBbX/nkiRfP7GoVgtnThmuE0mIxuZjtwY
	jg3mCu9k0//57VAVcjHF+nAWywLuYg92E1dxc/yvH2dbvbjezu0uXs0e4dLqnxHpiGEI1psb
	/BbqksXsTq7uvRX9q9zIlRhMf2vcnHq3rZVwsYTdwaXOXMHSkcjpeeTGfZzuI/4F1nFvdBYi
	A4nz0TI9kihU8dEyhTLYT56kUiT6nYqJNiLnmxRd+BXxEs2Zw+sRyyCpu9jsPSCXkLJ4TVJ0
	PeIYXOohjtT1yyXiKFnSOUEdc0IdpxQ09ciTIaRrxUGOhCgJe1p2VjgjCLGC+v8WY9zWJ6Ot
	Cb4j4WUzkTrJ7K59E4XVvx2y8ZCVxUs1rYdR90h8b8Pm16pVHR27n37fGWe07oqTPsBeZT86
	uP/ygZBK6+GunBXmuqA1x5LNzV0in+HQV74RYcpwrSH65N6Z+4Gs1GvLpoYQ/+UFHi9yw3rU
	5xXvLk7qhQ0VuuN7NKFb7VeXbX4sJTRyWeA2XK2R/QEt93EsIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG/Z/zPxdHi9OSOllQTCwIzYSMl7LLtw7diC4EEeTIU1tOV5uZ
	BpW31SqruZiWs1pGw6bVmnYxW8iidTGpaTfKuRZqRi6pNsVbthV9efm9z/Pw8H54WVLWSMWz
	qpxcUZujUMtpCZasX1qSzC3qUi7seYzhbVELhnDIgKH6Zj0NBud5Cl7dqEPgDxsQDI1aSNA3
	TWAYN3kYCA1/ZGDC5UFQ4TWRUN9YRMAvx28avj36icAc6Kah8msRhgFbGYKqXgsDXx+vgqC/
	mYIJ3xcC3g32I7B1/yagu+UYgvGKLLhU00DDaNtLEirNrxBcDvhI6HNEzEZPFwJXbTENPcbb
	JHR0T4bX4QEanplP0hD0VhPw3UGDtdhFwQWLCUHJlZs0VFxwYmj6dJ8B77cxAjorTATUOdeB
	39aLodVYQ0Tui6RuTQdLZQkRGX0EmK83EzBsszPw4konBlthIljaOij4XFvFwFggFSasGvDU
	fWHAd8aM4UbwJbXSjIQh/Wks2BvuEIK+fZwW6i/WI2F0xISE0NUSUtAbI+uj/gFSKG04IFxt
	7aeFkfAbWnANWrHwvIYXytuShaYqHyOUPvzAbFiyTZKeKapVeaI2ZXmGRDl0ct3e00x+j6Oc
	KkQB6gSKZXluEf/i010UZZqbx79/P0xGOY6bwzec6v2bIbnWWfxbb1KUp3JbeIP7Gj6BWBZz
	ibw/vCEqS7nFvOtDF/pXOZuvc7T8rYmN6B2BVhxlGZfG6wdKCSOSWFGMHcWpcvKyFSp12gJd
	lrIgR5W/YKcm24kiv2Q7NFZ+D4U6VrkRxyL5JKk30aeUUYo8XUG2G/EsKY+TZtR2KmXSTEXB
	QVGr2aHdrxZ1bjSTxfLp0tVbxQwZt1uRK2aJ4l5R+98l2Nj4QpReusY6edfS8I6spw8SypKM
	6rl9M+5Mur9xGQQ2JVSnNAXPlrmOJ6wPZPoT3bI9aUdU22OC16uneqalJgeOHko5p7GP5cZf
	2i+nvUeGRpL2TRm0zmw/vGtLXLNz94/Q+AO7/N6y/BkrtxaPPJmtUayI6TdU6ds3b9ak58vS
	5iwxrj0vxzqlInU+qdUp/gDN8B3kRwMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: mtktceq731rq8tjs8phduwrzwmjkz4mb
X-Rspam-User: 
X-Rspamd-Queue-Id: 81D25A000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392833-463220
X-HE-Meta: U2FsdGVkX1+weQ10QOogcPyvVjuATCLLK/z7zckeESi4TrQvAw7M8PVBBEDmw7/TkY/KPHwSxVUUsstbrHzicvuIWdzYOEvAkI51gClr+UOvLqYm6v7hkHBMMxAuZiQwKOOILpgCsUnKGbMxnVWL9ahtHbqjDyHvjiZXm+6gHUYyToEh3eQaYhrBuDAPXp0hLS4FRMsWkSmTHDSQAnLJZsrvIeJXfNKLm6VWLbJBzUfl22VMoeaKd5ELVXZNBFBHBbd8kQIvh1ZRml37BPGusqOJcPYaNrY8xGVZtAxzsP9fUI+OGDiup2lWCiuQ4pewzZn9tPK3WmqlCMdQUcQudLkoPCgK4FeVMgiJ5nYRtGMPJa/6UIhut0+FED36x3NJIPJpXrJ4Ik4ISlnsBvn8D1AvcQq3UxEXmBpT3Df7Sn3vNZPYOZdD5RhjdV265jOpJlYM1PUhcEEzZ+fLYPMz6IIUL14ks1uLpdsevN8SCaIWiEVvt2VT8KjKs/Rzz00WZlX1jecDqmzgGqpVdS0eISk/MwksN32a5rPjaHxrTBcTXc3JlLe7xpr248mmo3+b0Go6T5/aFrGihHlGfLF1wfntTPeonvBwLacrz+nDHe/9LWxb4GyZ6e5cBeOVeSQRjcKSX1U6Jjg+DJi7+/k+zDzuZ2pGLOP84GKa/bc+OdsZG2YTUT/3jS+odgCY5dJ4NfewXxPqV5TMV8YVWkKIKz1wlayPhc888aqoPItqxRzEcjnUzC9iO3gezKOcNpfP1OmljZ/qZQHVz8vtHGFaLZjFO+rI9vK4pyONHJ7El/i0sGFbgvWheLcgF//nNb7RGKZjesLSIMExi7GPBlbyU7Qc9wX3PWYmEnMcG6iVsAWiuZKI0jHnSyjPERseZXOfqzoFeoLAF/UDVXZe1PRhf3e6RZIH1QxN60U8zK+IF51AECLlcSa6ZfKh/Bpr/I6uOMkfOcGILwqUeGqe3TL
 f7/JGA3z
 sV/G7TW5yZLWCfCjgFqIsm8PpWX53cx8H5vl+pBEI4BIuiR56xyYLv7JT4FpFCsmN7SSYJd10qzXiDyM=
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


