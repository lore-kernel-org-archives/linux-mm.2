Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC047CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384FC8E002B; Thu,  2 Oct 2025 04:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8648E002F; Thu,  2 Oct 2025 04:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F0E8E002B; Thu,  2 Oct 2025 04:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D40EB8E002D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F9FD160366
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:19 +0000 (UTC)
X-FDA: 83952461838.16.EEA48D7
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9A68A000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=23L+uLerZ0ilRTZXNUlzqhRD/tvrOgjOfxmrw49VyG0=;
	b=Q+/7fQtVvXSxoThbaBl30iOhT5QXbcRXwxgh/EbWmWOYU40bFXvKhx5NJgZ+p+yfLsWr2/
	NWPt0ymcItN5Ssf1lFZWeRQzO5wQuv6ewN2lXLA9Lxd04L0ryGjWIxzEOpHMhvoVEXlL0e
	APf5j3JyAAXp0hbS3uojGTTYV7VpZrw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392858; a=rsa-sha256;
	cv=none;
	b=KEOTIpKlfX3NibpEOuw2/qfB1ugDN10AOGe9/8AqUwtYonVYE8WFb5JPPROy+GjFg34SQX
	ACtUj0U0W2SY0w2MOC9f4bHM1RlgFMBZePUNGDlQxtzO15UMRdK89x1Kg0BrpBSOSP2ldK
	++JYNyz99+8aKaH3TPmWGlhk1i2+0As=
X-AuditID: a67dfc5b-c2dff70000001609-bf-68de341359ca
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
Subject: [PATCH v17 35/47] i2c: rename wait_for_completion callback to wait_for_completion_cb
Date: Thu,  2 Oct 2025 17:12:35 +0900
Message-Id: <20251002081247.51255-36-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSf1CLcRwHcN/n+T7P1hiPyfX4ccftxEkhwucOHf/w4B93ft3VoZ2es51a
	binFYX5Efk9aXS3ZJjNZP2xCTXcJpSaWkaEtS0bXdU4qFyUb55/vve77/vz45yMkJW+pqUKF
	ch+vUsqSpLQIi3rHGaJCY7zyhU+rxkLb0ToMRRUWGrKtBRR0DGQjyKoexdA/9F4A3yt/09Dz
	qA+B1tdFQ373UQyFfp0Aup+shd4OOwWjns8EmLp+E9BVdwrBVaONhl8tL0jI1zoRGHweEr5U
	BoI7DV4EteZjNHzSVJHg6hoPTdqzNPS2FhGgP1ZLwRVdDoK8K1YM1R9qBNDaM0xAh8mPwaEx
	EoHVNOTdDgNd/nEi8HwhQFtmJ+DZtXYMJnU46FpcFHSaCwUw7IuGUX0KeC5qMTR52yjo8efQ
	cE/9QQD9r3wEWM75SbB+DASGkyUYCorbaXhQ24Qhe6QfQcP9TgJcNUU0nKusosBrGaXAWeeg
	4OUtJ4aKz24CHA1P8apE7kfWBcyV2u4SXNbLEZqzFFsQ13/9OMn9HHhNc7WDesw1G1nuUksU
	V13oEXB6axp34nEvxdnMEdy1B90EZ+gboLh3PSs3zo0TrUjkkxTpvGpBbIJI3mktF+wtYzMM
	JjepRr7QMyhEyDIxbF5xqeC/b2oaUdA0M4d1u4fIoEOZmaztvJ8KmmQc09m21sigJzHbWWPj
	m7+9mAlnPxoriKDFzFLW21xA/ps5g71VWffXIYF/l8+Bg5YwS9isrycC9aJAjS6EfT40RPxr
	mMI+NLuxBon1aEwpkiiU6ckyRVLMfHmmUpExf1dKshUFDs50aDj+PupzbqpHjBBJx4md4R65
	hJKlp2Ym1yNWSEpDxQnmdrlEnCjLPMCrUnaq0pL41Ho0TYilYeJFg/sTJcxu2T5+D8/v5VX/
	U0IYMlWNcpehbbAmsiR3/4ix/TlSTjEUFRTWnHZV25sbP3UO2u25Fza0KZrWpGSE6ezRmSe3
	bimed/HGOs3inXHl2WNKm9+pIOGFZvbkg2SaZ+E3/eUjcZZVByJO2SSb49cvmUl2l+TMis1b
	tCBy7eG7Zyc2mNXLp884qP25ekJ81KPH1/fsiJXiVLksOoJUpcr+AL/KANRsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSa0hTcRQA8P733t07V4vrHHgxoRjZi+wBGgezJ1G3oEgixCBy5aUNNx+b
	rUwLTUf2nqMpuR66cJjvtrTMVqK4HlN0WTbKaatlVppUWphT24q+HH7nweF8OHxc1MgL48tT
	MjhVilQhIQWEYNfavMiQqH7ZKlf7XOjNbSFgfKyAgKt11SQUWK7woLu2CsHAeAGCX5NGHLRN
	MwRM6e0UjE28oWDGZkdQ5NTjUH0nF4Mf9dMkfGn7jsDg8ZJQ/CmXgFHzeQQlg0YKPrVvg5GB
	Zh7MuD9i8OrnMAKzdxoDb8tpBFNFyXDDZCVhsrMLh2JDN4IyjxuHoXp/8469H4Gt4hQJH3QN
	OPR458KL8VESnhrOkTDivIrB13oSSk/ZeHDNqEeQd7OOhKJrFgKa3t6nwPnFh0FfkR6DKstO
	GDAPEuDQmTD/ff6p26FgLM7D/GEIA0NNMwYT5koKOm72EWDOiQBjZw8P3lWUUODzrIaZ0lSw
	V32kwH3JQEDtSBdvowGxv7QXCbbS2oix2udTJFt9vRqxk7/1iB0rz8NZrc6ftg2P4my+9Shb
	7hgm2d/jL0nW9rOUYJ+ZGLawM5JtKnFTbP7D19TumH2C2CROIddwqpXrEwWyd5ZaKq2GOVZm
	duE5yCM+i4L4DB3F3NI9RgGT9GLG5ZrAAxbTCxjrhUFewDjtCGd6ncsDDqH3M6bHr6iACTqC
	eW+qwwIW0muY/mdX8H875zNV9S1/HeSv93gcRMAiOprRjuZjOiQoRbMqkVieolFK5YroFepk
	WWaK/NiKQ6lKC/J/k/mEr/AeGuvZ1opoPpLMEToj3DIRT6pRZypbEcPHJWJhYkWfTCRMkmYe
	51SpB1RHFJy6Fc3jE5JQ4Y54LlFEH5ZmcMkcl8ap/ncxflBYDtpZ+UBhrwl7szDjQqEuoW3V
	7KwnCYetrnXB3opZn38sQXHlJxuncgyPjp9Nt/E7CtKn4+bE6kuUxGnN8uy4lqyt2d2HOnzf
	Y4bD1WKlJnRffNumzdtj1jr2Nmhysy4HBy2at6U3+q4eZYcEx5dtWPrNW5t817cnITz24LkO
	VdKZ5nYJoZZJVy/DVWrpH7oHRxxJAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 6y7cnrc3wut934rzzfhuhqq4747bjige
X-Rspam-User: 
X-Rspamd-Queue-Id: B9A68A000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392857-886122
X-HE-Meta: U2FsdGVkX19xTnPwt6C9cQ8OVweoKKymNy+FIFm02i/0MBrPPNEIu3kY4JKivspk0/3lX5Ywm3ttfYT4iisSK2pdIo5myDvGbiwvPQzRz2Z698S2QjEizYahSBPJcjJvT8ucPQuBHjQUa+Nvw+iIEvzcM/WFWNZoVRMs6zrQtizr44YYJnXgOEav78WK1/2pXpGVJgJx7kx+obwIjlh0+2sFxq6KK7LRaqZLhKsdpz1pliEGuEXfXEculXIqys7aHE8VSIvH4IPnvLahQ+kdDZVSMdq7saPLUGu8URCu9fHf76u8/XE0zKPkvGrgvIWkKtwZURI1/DFnaTJf6iRd36ecS537Uj4GuV+J2s5GaWLSIEnxH+GXpA5ye88bNIL+C/S9e96QkHjqckuxrCaOLHOGujnqUkq76iz620kkpMLMZ6BKiymy4uOVWSPJxULIE4RXZ0I9kdjJz6g4biDXsOedr4fGTT/taVFZoX+IOw+vlbJOf55vMf7DsxhkgDNTx9uPwvZFxURyjQipO5u/2vgD0Mrw/4YE9GtSfoiwjF2CZT4rTcrM18UABlygCo+TrXtoR2WXkThNrW75QEURtNWWseAY236KgBoUEpA9Y6dSWnAtokTzv/SlKuAyAljfEg8Vmf0zqEJliSsc+B6IQReQ+uGWjZ7CZ1aK6vPuzQuX9hyIA7u9CvI30r6lYhdInF4w5/klh+29wWtYQw2Q9cLwGDhQw0wF+5aoe0lGbYukol+6M3IRawTzHwQ3jwu0XNxvMgGb4OEpINtfKU2Sb3YldVtWmtVUjZw/7Xgu/Ymubv+G7ILIA3ERHREWbvSCVSOHvp5uEKDlnD5OSWXTjHLfEs2L77dhUmeNQiSeblz+2hVpXTkGArGhWndwdNvSXWJP5/NZ1I2vnd3x1RUYBhdX9Qyd/RosnnfuCDD4dlfdoNsoOX6mO06NFaPiLbb8U77VE2l8TTkCTZxQ7K9
 lSTPkASA
 YrUwaZd0ZEq0p0wTadcLKIHcsdj2FE3KTXm1bBrr3PlryJ7YdcCcG4tvCYHh+p0Zh8eiXUDwifoCyn+Iw8NCLN4aMCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Functionally no change.  This patch is a preparation for DEPT(DEPendency
Tracker) to track dependencies related to a scheduler API,
wait_for_completion().

Unfortunately, struct i2c_algo_pca_data has a callback member named
wait_for_completion, that is the same as the scheduler API, which makes
it hard to change the scheduler API to a macro form because of the
ambiguity.

Add a postfix _cb to the callback member to remove the ambiguity.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 drivers/i2c/algos/i2c-algo-pca.c      | 2 +-
 drivers/i2c/busses/i2c-pca-isa.c      | 2 +-
 drivers/i2c/busses/i2c-pca-platform.c | 2 +-
 include/linux/i2c-algo-pca.h          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
index 74b66aec33d4..ee86df4cff4b 100644
--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -30,7 +30,7 @@ static int i2c_debug;
 #define pca_clock(adap) adap->i2c_clock
 #define pca_set_con(adap, val) pca_outw(adap, I2C_PCA_CON, val)
 #define pca_get_con(adap) pca_inw(adap, I2C_PCA_CON)
-#define pca_wait(adap) adap->wait_for_completion(adap->data)
+#define pca_wait(adap) adap->wait_for_completion_cb(adap->data)
 
 static void pca_reset(struct i2c_algo_pca_data *adap)
 {
diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index 85e8cf58e8bf..0cbf2f509527 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -95,7 +95,7 @@ static struct i2c_algo_pca_data pca_isa_data = {
 	/* .data intentionally left NULL, not needed with ISA */
 	.write_byte		= pca_isa_writebyte,
 	.read_byte		= pca_isa_readbyte,
-	.wait_for_completion	= pca_isa_waitforcompletion,
+	.wait_for_completion_cb	= pca_isa_waitforcompletion,
 	.reset_chip		= pca_isa_resetchip,
 };
 
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 87da8241b927..c0f35ebbe37d 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -180,7 +180,7 @@ static int i2c_pca_pf_probe(struct platform_device *pdev)
 	}
 
 	i2c->algo_data.data = i2c;
-	i2c->algo_data.wait_for_completion = i2c_pca_pf_waitforcompletion;
+	i2c->algo_data.wait_for_completion_cb = i2c_pca_pf_waitforcompletion;
 	if (i2c->gpio)
 		i2c->algo_data.reset_chip = i2c_pca_pf_resetchip;
 	else
diff --git a/include/linux/i2c-algo-pca.h b/include/linux/i2c-algo-pca.h
index 7c522fdd9ea7..e305bf32e40a 100644
--- a/include/linux/i2c-algo-pca.h
+++ b/include/linux/i2c-algo-pca.h
@@ -71,7 +71,7 @@ struct i2c_algo_pca_data {
 	void 				*data;	/* private low level data */
 	void (*write_byte)		(void *data, int reg, int val);
 	int  (*read_byte)		(void *data, int reg);
-	int  (*wait_for_completion)	(void *data);
+	int  (*wait_for_completion_cb)	(void *data);
 	void (*reset_chip)		(void *data);
 	/* For PCA9564, use one of the predefined frequencies:
 	 * 330000, 288000, 217000, 146000, 88000, 59000, 44000, 36000
-- 
2.17.1


