Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C9BD2E017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547B96B00F4; Fri,  5 Dec 2025 02:20:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F0A6B00F3; Fri,  5 Dec 2025 02:20:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E655F6B00F3; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1E16B00F4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67B4E51E2A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:04 +0000 (UTC)
X-FDA: 84184568328.30.A72B7CC
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A5F4180008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Vu1ujTQiPlAM/knJ0P2/edDU1UsUdkwH4UafbJoB6yo=;
	b=HjmRTwQTNFBk74TwaQqxPTPJuGlED6tHC8FZ3FZ+GjnLlA/EwAXG6i/UpkfyNtD0FWpogM
	MaAR8HOes3xiTBu/ZyL1oR5RyJSCklZcuoi18kQAALwWUethvVsaKdvrI8lrai7Nj9PSoW
	sTYR3l+pZRVJ8f4vMOOTeTqy4FN7GR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919202; a=rsa-sha256;
	cv=none;
	b=E776EZtDeF+Wyoi1eN+oMjLU7b2Oxqvt5vRyDddH55FFND/8FkSnEYB6EHeLU2qEj/Hzui
	l0HRLoOx05wPo4H+WgG3Oyc2Ws2lJ49kZIe0lGTYfHpNVLM0VUI0dcGL7TmRXUpm0R5DHF
	dZppuMrhPb29EyyE4lCThhWyyQqYXvU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-8a-693287722131
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
Subject: [PATCH v18 30/42] dept: make dept stop from working on debug_locks_off()
Date: Fri,  5 Dec 2025 16:18:43 +0900
Message-Id: <20251205071855.72743-31-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0xTZxjG953znQvFLiedxk/U6GrQBDcHBsz7x+JIpvHIXzo10ZmMNXIm
	J5Zqyn3LsE4uBRW1SUGgIteGQI3aDgWEDdlEGaDFOujGpcVwkQgSkUIKOAYY/3nzy/O8z5s8
	ycvTKjcTxMu6BEmv02jVrAIrJlaVfa7P2imHXndsAWPGWfBNGzFYbtlYeFd0jwOjvYABj8+I
	IKN+EcM7UysH0/5eDsznELidv9Ng+/UcBW9v/8fCpPUigrGH+2Cxf5SCnplxBEPNWQjmO5/S
	kG92Iigd7KdhasyLoKnqFxZcQx/Dc98kC23mCyxMdFko6Op4haDe28BBX56JAo91BEP+GAt5
	d9ZCUf55amm8pMB88z4Ffms1Bx3lfRishmAo6nQx8KKqkIPWmlEO+i+bMbQNdDPwasTEgudR
	JgP3DN6lQg0+DE3/bofSzAoMBcV9LDQ2tWFwNVhYGLAtMmAommXgWY0Tw61RNwXtrY8x9HZe
	5qCyp4sCR2cHDc6rlxhwXxlGcPN1GRsZI85m5GKx2nGXEm3FNiTOz5mQmO5IFivbx1mxaaYE
	ixXZc5RYX9jPiSX2RDH9zwlGdFSFiOWNY5RYOuVjRHt1Nivap0zcgZBvFV/GSFo5SdJ/sft7
	RezcQi99ZlCZYjJlMwZ0PTAH8TwRwsm1woQPaLRtyEEBPCtsI263n17m1cJm4rg0wuQgBU8L
	rk0ky5+7YnwiHCS2xjq8nMVCMKl9wi3LSmEX+eeBi1lmImwiNbebV9YDlnRzz9wKq4QIciNn
	duUmEcoDyLC/hX0fWEceVLnxFaQsQR9VI5WsS4rTyNrwHbGpOjllx4nTcXa09G/WnxeO16Ep
	56EWJPBIvUrZnBwmqxhNUnxqXAsiPK1erRzXhsoqZYwm9UdJfzpan6iV4lvQeh6r1yp3ziTH
	qISTmgTplCSdkfQfXIoPCDKgw2ERiwsFu/enh/vpbzZ6hN8i6waihraG7j/UnndqT0V3ZNqa
	MndNRNigvThu9P6jY3Vv1qSu+zRLPWkIjD7y0/ATXffw3r/a1m9VKXJrn772HB8wBf0QGW3x
	Pvvs6LaStLQNg28Of3cHyu0nn0dF1XrJ3ZGNylj+qz0J/q9l+INY/lbj+FhNWAitj9f8D5qj
	NXtrAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+93XrqvFZQreLDJGDwrUjB4njSyivARF9U8PAl12y+V8tJVl
	EPloOdeDeWOTWqZpjtBVplmajUzLUntsWWmPZdZaiZY9Ns3ptCn0z+Fzvg84fxwal94iQ2hF
	ygFelSJXyigxId4YnRO2P3eRYmHRieWg1RyD911OEl5nNRDgcWsJuHDdQoHPdFsE2qpzJDzu
	yCbAdq0CQZdHi2Bw2ISDpm6MAJ/QLAL30DsRGLIQjFmbERjtAg6dtns4WG5mYfCncpSC3qbf
	CAzdTgoKerII6DefQnDeZRJBz8NY+N5VT8KY4ysGHQN9CMzOUQycDbkIfMYkKCqp9teNPykY
	fvochwKDDcGlbgcOv3s+IrjZ/AGB9Uo2BV/0NTi0O6fCS08/BS2GkxR8t1/A4EclBcXZVhLs
	T3oRFJoEBK63VgxySq9TYCysIqDu4x0R2HtHMHhvFDCoqNoAXWYXAW36Esx/rj91IxhMBTmY
	f3zDwHC1HoMhc7loVRniBjVnCK68+hbGaV74KM5y0YK4Ya+AOHdZDs5p9P61qa8f545XH+LK
	2voozut5RXHWgWKCay1huct5XozLfxrG1Z13iDat3iFesZtXKtJ5VcTKeHGid+QdntYtOSwI
	eWQmKpysQzTNMotZrWWGDgXQFDOP7ewcwsc5iJnFVp92kTokpnGmPZTNHTozYQQym1nL3Vpi
	vEswc9iaZ6JxWcIsZd/cbyfHmWVC2YrKhol4gF83dHgnWMosYYt0g6QeiYvRpHIUpEhJT5Yr
	lEvC1UmJGSmKw+EJqclVyP9N5qMj+bXI3R7biBgayaZIGg5FKqSkPF2dkdyIWBqXBUn6lAsV
	UsluecYRXpUapzqo5NWNaDpNyIIl67fy8VJmr/wAn8Tzabzqv4vRASGZ6FOuRx+1LDg1L06Y
	Vhj76+ze0GjnhuiZMZFcRIJ0135HZtRz2zpX/WhZ3d/YmCO+uX/rY6Jaz32+lscHTgoocr/V
	F+swtDi1Bp3etpKcvjbOs2PngwH79tbA/HzDAluE8Ge7M7zUl/jAkdEy40NIz/zh1Vvmp+n3
	qOKa2H3q2WseyQh1ojxyAa5Sy/8BP5Wpp0kDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 8A5F4180008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: r31y4ytgceieq5fhzhhpijth5ut3so7m
X-HE-Tag: 1764919202-932850
X-HE-Meta: U2FsdGVkX194izgUVu4hrVRKIIZRyjUJrtc4DSk0VqTBGuTSIn3lZp1kJisW45leF5jiX2fdAC+NlxkZKmtrB/u5SK1AkLMfsCiXyDmJTLx6l5JhBGRZ990hxrz5XMLZHWf/Nivuz3yuRNFMWCkXo0DYXOnV8KgsfrLsgeivFEZ2rUasIddnZvp3H5cw+xgnhSK8qWnJgXJXK2GhawCfIKJrL+EfiiWyXV5g1Jpu+n4XABPH5Hbz8dUswZVq+LiudmcydIAaQXENh7eNtijD/kOUkDJ6BVm0FVeRnY7eJb9afE/JK+vnRA/g75q/UDbkz4KtcLjWCEIWnLfWQ9vwUpfLPQYhkltOE8mLVqiwUBAx7oPdReAmeXKdld4GPeMGI+8X4aXO5RArJGnEhspm6GZKwNhYm4TiYH25yQ2Sk4NygC5KYTulFn/YcE+65Tm22I+zhv9DZeHhIiR4U2YolFxJ/RYCXyjfs+mIQnso5TjjrDPMrfAqyUxT+AjORqJcM7t+ieRdB3U/9KJk53gwRMrw7APUisCX3PPl+Ov1pjOkxhgo9uQw2PglVh1k/AHoBCKMeOHCk6wYqNamBvRcCkd19Y/0zSwuPAEXr53Q7DUm4Jn3wbwvWCEpsUElI6pNV4hl9bOvnjxc6SPh6Ecd/gVp3gtkWehV3uxL/mIH5axcHm3mPgSnCRZbsG0lM23yuaytGNCLGGYpofc1zhid+f9I1qw8jXYhNiX+VQAaombSqSOCTe8TSPUyfd45QpTUG84xbr3FJe7GpAIyTlUqcMcRA5fgvv9gelIvfhXJdWCId9izIetN/rwrekbxC82fEjNOibI3aAUYMJVERtmgeo59VleunaU6p0/8BevtaVMQR6R7okqY1+K7E95pIV081lEZoMaA+8DKa679kzx8/HP/8otbIUnPgrHhdG+PvcmKdTbph8YxQsR7qMxHvb+nWycqR641KgxpWSoLaHU
 hgsY/R9V
 ZpQ/lR+Szvk9Bs9iNj1XmXS0Fcg70o9OjHMZdDu+RPi1DMsG/tvkh1pu+ACkHlyPMmRouis4gVuzLdww/ZOmelv9+O5yPDl0drkhIYafuoppRb902bEEmP+mJIlBV4uuyzkT1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For many reasons, debug_locks_off() is called to stop lock debuging
feature e.g. on panic().  dept should also stop it in the conditions.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h     | 2 ++
 kernel/dependency/dept.c | 6 ++++++
 lib/debug_locks.c        | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index bbcb48f6140a..8b41f7a65abb 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -142,6 +142,7 @@ struct dept_ext_wgen {
 	unsigned int wgen;
 };
 
+extern void dept_stop_emerg(void);
 extern void dept_on(void);
 extern void dept_off(void);
 extern void dept_init(void);
@@ -194,6 +195,7 @@ struct dept_ext_wgen { };
 
 #define DEPT_MAP_INITIALIZER(n, k) { }
 
+#define dept_stop_emerg()				do { } while (0)
 #define dept_on()					do { } while (0)
 #define dept_off()					do { } while (0)
 #define dept_init()					do { } while (0)
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index a0eb4b108de0..1de61306418b 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -187,6 +187,12 @@ static void dept_unlock(void)
 	arch_spin_unlock(&dept_spin);
 }
 
+void dept_stop_emerg(void)
+{
+	WRITE_ONCE(dept_stop, 1);
+}
+EXPORT_SYMBOL_GPL(dept_stop_emerg);
+
 enum bfs_ret {
 	BFS_CONTINUE,
 	BFS_DONE,
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index a75ee30b77cb..14a965914a8f 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -38,6 +38,8 @@ EXPORT_SYMBOL_GPL(debug_locks_silent);
  */
 int debug_locks_off(void)
 {
+	dept_stop_emerg();
+
 	if (debug_locks && __debug_locks_off()) {
 		if (!debug_locks_silent) {
 			console_verbose();
-- 
2.17.1


