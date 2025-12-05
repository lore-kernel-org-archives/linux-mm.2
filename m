Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D7CD2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D906A6B00E3; Fri,  5 Dec 2025 02:20:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BA96B00E4; Fri,  5 Dec 2025 02:20:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53DB66B00E7; Fri,  5 Dec 2025 02:20:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1212E6B00E7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C787C8A4DF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:59 +0000 (UTC)
X-FDA: 84184568118.14.2AAF378
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf05.hostedemail.com (Postfix) with ESMTP id ECBA3100002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=UGkObL7oD/K2bAkUVhXxAs7YoFHUnPDSWQxkr9+NXKk=;
	b=e9eFKpNr/SKDsxZXv1iMOWJyC9Kg8t3roMXLoyZQRDdRGI3p9Emy/HcUfIC0Ue/PcB0bfR
	brckXImqaMOz31E25G0J2FI9tvLf1FCtJdEoauu9awjZ37AygDT1F1RJGBGZgqe+xNoVnf
	n+HE4UT7Jy8DttzQePhlmdFexTbUaQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919198; a=rsa-sha256;
	cv=none;
	b=yB0oKNMHHEGaCfWUmBuPNBNIMCSHI2fRMRbMjXBtUTEa2QjvQVvtgF32SlXscca1NM1eCS
	A6Nf+S8X1LngwCnkHfihLUmjIg1Doh0MoPiQEmH4Ccc3bNKIAGTneHFCEFl1iSdTZ39TR8
	++zyh+Rha11/CEejF31ywyQ/X6ln+2g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-00-6932876e9f6b
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
Subject: [PATCH v18 17/42] dept: apply timeout consideration to swait
Date: Fri,  5 Dec 2025 16:18:30 +0900
Message-Id: <20251205071855.72743-18-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTZxjHfc+1NHQ5qbejyyKpURcTtSVenkW6MBOTk7hlmmVfZuJo5CAn
	lNYURDDRFbMONFhJkXYDhNNpGqAVsF64iSJK4w3oKJMK9YKW6kYRhxVH7WC1xm+//G95PjwS
	XB4gl0sEXT5v0Gm0CkpKSCeT7ev0JamC8vK/n0DgcZAEb5MTwX8WDw2R2VEa5rs8CFwXizF4
	3TJHwcSNaQTDM2EEjuAcBsHuknjYmgN1v1+Im9ZXFLzrG8Bh6M0UBeLRLhL+mIhhELBaMHC6
	v4HHjhAB1vNLofJcJwb3zgQIqO7zkTAv6sHjfE5D0+QACRMhCwWtxic0uB/0IogMjWHgKgvh
	8FttgAJP21MMfB01FJS1XCLhkWs+fnT3XRIGnV4C7npuETD2xE+Cv3wcwQNbmAbHmyka6v+x
	kRD68xcMGrr64iviEmj5uYqGkhedFPRV95MQMP9NwM3mVgzcrvsUVAyKFEQftpFw31JHwfTp
	ORJMZbM0VMZKKaguNiM4HVHBy/IImZ7OvTWZCc5V60Lcu6gFcabyON0IT+Fce9VDmhPdB7gz
	V/7CuJEJNeduPEZx7mkLzb3s76e59rEvuOCQDePsxkqcq729a2fKD9K0TF4rFPCGDV9mSLOb
	g8Vo/2uq0NZ7ljSiO+RxlCRhmY2so8xGf+TR6LWETjFrWL9/Fn/Pi5gU9sKJUFyXSnDGt4It
	mTUnjIXMdnag0Y69Z4JZxTZbTyXKMmYzaw7biQ+jK1hnS3cinxTXK4ejCZYzm9i6428ToyxT
	ncQa+03oQ2EZe73eT5QjmYgWNCK5oCvI1Qjajeuzi3RC4fq9+lw3iv+c43Bsdxua9n7XgxgJ
	UiTLug+qBDmpKcgryu1BrARXLJKFtUpBLsvUFB3iDfofDQe0fF4P+lRCKJbKUmcOZsqZfZp8
	Pofn9/OGjy4mSVpuRKbVKxvG4KjatBPfcmyzuj7n5PaVaV93Ek31X3k7KpJlvuYq1fCC1TWf
	ize3tMZ6Da6th18plfygmlin6rDH2nu8Wb0VyqsnxpfQ3wrB1JRdWenjupTJZ+pfMwpzbn02
	sgy7nbVqVFn60+LoDuORNP2cOGL/viaydZtsz3xFqehTEHnZGtVa3JCn+R82OI86bwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUhTcRTG+9+3zdHqsgQv9aFYpBBoGiUnktIgvAVJRVTUB73VJYdzymaW
	QdS0ofYia7SNtkqdOmJavpdmI1Oymvky30lNo2WZM61csqnZWvTl8DvP85zD+XCEuKSBXCuU
	KTJ4pYKTSykRIUrYmROuyN0qi/SVhUGe5jKMjLlIGFA3E+CZyyPgbmUFBUvmJwLIq7lDwuvB
	bAK6H5UjGPPkIZhfMOOgaVwmYEnXJoA577AA9GoEy/Y2BAanDoeh7uc4VNSpMfhZ9ZuCqdYf
	CPQfXBQYJ9UEzFhvIDBNmAUw+TIepseaSFge/YzB4C83AqvrNwau5lwES4YUKLTU+scNsxQs
	dHThYNR3Iyj+MIrDj8lxBHVt7xHYH2RT8Elbj0OvaxX0eWYoeKO/TsG08y4G36ooKMq2k+B8
	O4XgnlmHYOKdHYOckkoKDPdqCGgcfyoA59QiBiMGHQblNQdgzDpBQLvWgvnP9aeqQ8BszMH8
	5QsG+odNGHitNkFsGWLnNQUEa6t9jLGaniWKrbhfgdgFnw6xc2U5OKvR+ttW9wzOXq09z5a1
	uynW5+mnWPuvIoJ1WBi2NN+Hsbc6wtlG06jgYNwJUcwZXi7L5JVbdiWJkitdapT+k7pgfFlK
	XkEO8hoKEjL0NmbY9zzAFB3GDA158b8cTG9gam9O+HWREKd71zO53oKAsYbey3TZirG/TNCb
	mErD7cCwmI5mCtzFxL+l65nyquZAPsiv6wd9AZbQ25nCa/OkFomK0AobCpYpMlM5mXx7hCol
	OUshuxBxOi21Bvn/yXpp8VYDmuuNb0G0EElXipvPR8kkJJepykptQYwQlwaL3fJImUR8hsu6
	yCvTEpXn5LyqBa0TEtIQ8f5jfJKEPstl8Ck8n84r/7uYMGjtFXTI+7nAuVJUnWif6frKhTvC
	NsqjYxQeh0m3Of52qGVDf8xibtuhLaUhxtmj1fV79p7y9A0822fc2kmvTniRaioaWZ1V8oqP
	jp3KfNNRXtp3RNt52LI40H39OxO1wzHN5Q+H1uc7ZocLdx9P2P1xU8MDg+lEj2R6wTXZejK8
	ZzzuopRQJXNRm3GlivsDMmueF0sDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECBA3100002
X-Stat-Signature: wuemo3u9u7xrhjs6wpaox48q9kmc5myu
X-Rspam-User: 
X-HE-Tag: 1764919197-585722
X-HE-Meta: U2FsdGVkX1/R8cqvq30SIt1KmG4DoouklmiMEvtlJJA0+zvXJsfHSeNtRH/BKqegYM3LFY/8SYZI0u7mE1+ta+cfYMopDtsIpGNfxkVplA3s1D1iIKIvTz8rfGRlfJTdvFucAVbtyQ+kS68nsH2bbsYVCgNnrZrXHBNmrVjOQQFtUBJ+MuxNZtPaiSN6WvxT67LyjGnx2bSn46syVwLcJEgnIs6iKigkEZmGMBdvEF/lS1418Z2UB+aMn0PsanBq3lzb/zs3CARjDQgQ73hcrVGKsCMm0ulYgLHwLHKbHNunzjZCBygtvrF1hAwi/IyBrio23jxUzF3YMj2PQf3mjzGWjd8p3+SZuP/Wr0egNzxEM3Wi8lJAz6x+aJDOCw6zkKt+r1zwzFwNaWfIlBRR8DZF3BWJCdR5wXe0aT3Iq9KfhDstYJD85PqWVEXlJ9EcSWdoBYoew3/5zF5DYjS38hiWVsEbvSbA0vsZ8Nd7OGYKsUV6QqDB9so6i5uUajhCrS+lySK75JOzpwpGSpTMH+T+3qPmTt0a3Gbw7l1NrwiEqbS8Es+JwGMM11Sk5WAEgU0ktgrtuAN0J6PhzKQ6COeJb6fUNutfDOeY63b8tAdlyzHosveUYC4xCWg4gT0RLwgOBDhHMujFtRY9lfcPtira1reTCtLTRzX/W5YzVEl0kIKJCqkl5/yq6KYV6lG0OuspVxq8Fe/Kx5wydjosWuLMUkSAaijReN25vR7BdKY9eDeu7w9jHuLAmvtKC+tvilHRmy6XCkN2P+YgPKpW05silv1UwrdXXSLYqnPQgNLPclkbUqJ5fQqjLDySjQ/lx0ivrri5k0N+WRA31R4fkAmrtwMiTC12lHkWQjUdLa5yIVVmib5F3tQv+E37B/PLnijdrH4Z2cD1fJ1kN5J3g1B91bbWUBiw6NOl3hnSYeESdakko7ZIdXJz7NaqjBbiUKNFKshf19/uakQw3z0
 B7lLQ37e
 Y6IRggeDc5Y95AGgX+4EFKh67FV3/5l2YTEDc0IKixu8DtGg55uWqZ8BrkSsVq4L4AzJb99dT+BVhK0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to swait, assuming an input 'ret' in ___swait_event()
macro is used as a timeout value.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/swait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 277ac74f61c3..233acdf55e9b 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -162,7 +162,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 	struct swait_queue __wait;					\
 	long __ret = ret;						\
 									\
-	sdt_might_sleep_start(NULL);					\
+	sdt_might_sleep_start_timeout(NULL, __ret);			\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	for (;;) {							\
 		long __int = prepare_to_swait_event(&wq, &__wait, state);\
-- 
2.17.1


