Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EF4C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75F2E6B00FC; Mon,  6 Jul 2026 02:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BFF6B00FE; Mon,  6 Jul 2026 02:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D45B6B00FF; Mon,  6 Jul 2026 02:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA226B00FC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:22:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E62C1A02E0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:05 +0000 (UTC)
X-FDA: 84957356610.03.161350E
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf31.hostedemail.com (Postfix) with ESMTP id C02D920002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=qCA3O2hXfpDdJdbT61rx/u28O3JXMbt4V8TIVYlIsXw=;
	b=Rx4lIhZVSEueIP3HPdMhaMd1ab9aGEZ0dox6ziCcJ/E7Lfkh9WZf/+/jNVpNO1znBdVsow
	kFch6x7LjbSvQAHGOKaBa08jVhoRjKmFmrvmPJcQdzGz9NeGokZo5VM6sjw290aqZHFX06
	PtYBOqU0xwqM/r8ld1XIrbQEnyYFw+M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318924;
	b=Q57G89kV5aqGQfFfqSw7bkfsjYsBo41g0wdPmt59clLoB3K76+bxDmURYzxE9yc4JvWX6x
	ckpHiVCXHLhKjNl9t1U0HYeIpRgUZzZyHnLQByh9oqAtcDNkg34PO+BFmbU4Dm5Von5Nto
	MaeMCtOtE09BPr1hap1P4Mukt2jCsl8=
X-AuditID: a67dfc5b-c2dff70000001609-02-6a4b4983a234
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
Subject: [PATCH v19 36/40] dept: track PG_writeback with dept
Date: Mon,  6 Jul 2026 15:19:24 +0900
Message-Id: <20260706061928.66713-37-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTH99z7PPdeKjXXasJFluG6uC3MMVxwnixz4+Nl7oPJTKZui9Zx
	I0XeLMpgyRSVOkSgTScQKAKKdAiV1VbGrFSRLJUOO4rd9A6BwqxluDXurToGyFqMX05+53/y
	/306HK0KkNWcNn+/pMvX5KoZBVaE40+/Wp65OSfthIGDCv0hGAsECdw63I9hwdzLQoW9gYCv
	uwtBIFKB4NGcmYYFk5uFRZcbQd2IiQbZd5WGv22PGaidCjJQP3MYQ2PIzEI4cJnA4vg0BZbg
	YwqC/V8gaDnjYGDOO0xDfa0PwempcRouuicQuDqOMHDP2EODP7gcwiNNFLQecREIjboouDTp
	ZGGszkRBwBLCUHchAcz1R6no+JWC2vOXKbjRNobB7PUT+KWjkYX5qfXg7ppmYdxQi6E7PEzA
	M3GLQG/ZJAvWqhANFc4IBvvdaNbQPMZAn8uDwe9sYqDK1kNgwrpI4GaXD8PX0zIFQ+5BDJ7G
	cxjueA0sDDvPE2i/PULB1KRMwOG9QWdkiY/0NVjsdHxDifqbC4xobbYice4/ExL/aT9Ki3pj
	dG0f+p0RXQ9bsfj9GUG81DjOiq32A2L5d2EiOjpSxLa+GUq0dx5ntqTuULyVJeVqiyXda2/v
	UmR7jx+jC2efK/ktcgyVodnEShTHCXy6MNDeg59yZLSNjTHDvyTI8iwd41X8GsFRHSKVSMHR
	vD9ZqLJULxVW8puEr1xGEmPMrxUqw71LrOTfEFomf0BPpMlCl61/SRQXzbvnT1ExVvEbhDsP
	ruOYVODb4oTgzJfkSSFRuNYhYyNStqJnOpFKm1+cp9Hmpqdml+ZrS1I/Kcizo+jbWT6f//Bb
	9Jfv/QHEc0gdr4SMd3NURFNcVJo3gASOVq9Svvjy5hyVMktT+pmkK9ipO5ArFQ2gJA6rE5Sv
	P/w0S8Xv0eyX9kpSoaR7eqW4uNVlyOLau8lnvZhJDa4bOlRFfzx35V9DdSRpy7P7CjYYPej5
	5mtr9qzw4WVy37k36+7dbsqr+cjWkO75+aSz5YOD/n0lcvJ9/2BCSuSFHX/47xYaTp3Uy+/9
	tCic3boxzWYqz6hJu5589f47hvJXhjLrt19ZnhhMGv3zx6bd22y74j2JPXBCjYuyNetTaF2R
	5n/ObYLocgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+/3u3b3X1eqypF0LKhZZBPaAHodeGP3RLXv9E1EEOfKS87Fs
	K8sgcq6Z2oM52qSWZZYr1HRtpi4bmaI9V5pZZpmTlmVqlrlkU7Ot6J/D53y/53w5fxyGkFaL
	pjNK1SFBrVIkySkxKd66Shel2xiTsPjcZxlk6U/A+06vCF5ra0nwDWWRcKm8lIIxSxUNWfYL
	Inj0JoOEprISBJ2+LATDIxYC9M5xEsaMjTQM+d/RYNIiGHc1IjA3Gwloa7pPQGmFFsNP228K
	eusHEZi6vBTk9WhJGLCeQXCx20JDT8MG6O+sEcF4x2cMb371IbB6f2Pw1p5CMGZOhCuFjuC6
	+TsFI+4XBOSZmhBc7eogYLDHg6Ci8QMC180MCj4Z7hDQ4p0Mr3wDFDw2naagv/kShm82Cgoy
	XCJoftaLIN9iRNDd7sKgu1ZOgTnfToLTc5eG5t5RDO/NRgwl9i3Qae0m4amhEAfPDU7dloEl
	T4eD5QsG060aDH5rMR1dhPhh/TmSL3ZUYl7/coziSy+XIn4kYET8UJGO4PWGYFvfN0DwJx1H
	+KKnfRQf8LVSvOtXAck/KeT469kBzOe6o3jnxQ56+7rd4tVxQpIyVVAvWhsrjndnZxIp/plH
	e32ZKB35I3JQGMOxSzlf+zU6xBQ7j2tr8xMhDmdnc46z3aIcJGYItmUWd8Z6lgwZU9k13A2X
	QRRikp3L5fRX/WUJu5y74nmO/oXO4kpstX+DwoJ62Wg+DrGUXca9G3hIGpC4AE0oRuFKVWqy
	Qpm0bKEmMT5NpTy6cN+BZDsK/pP1+GhuNRpq2VCHWAbJJ0kgelOCVKRI1aQl1yGOIeThksj5
	MQlSSZwi7ZigPrBXfThJ0NShGQwpl0k27RRipex+xSEhURBSBPV/FzNh09MRjrj6zL1+5Y8d
	JdOWb7N50iar7ztaTQerH6dksrYpw7YCO7+Cylhd4ZNFBNyt0Z6Jztzsr5Vz6HqTNEp1eIq/
	xWlfpS107Gr8tujezqrUBTWayB+bB+Uzu9Lxp/lvA7ntcXNUchkzcVJt5ANZ4g22wRUOLxKs
	5/eUn/jYcLwyRk5q4hVLFhBqjeIPAg6jj0sDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C02D920002
X-Stat-Signature: 35d3bm1mfxho8mygmrts8fjddg7k7s6f
X-Rspam-User: 
X-HE-Tag: 1783318923-419904
X-HE-Meta: U2FsdGVkX18xXOnAiAmJIWxG0lvQewozXmdBRdpshJoLjuK9yom1FF0x5egINKGmYRJLHHvgAxulHDadRBkUbKBdthn6jvmrnQHXNKR13YKvfIf6h9qARCuwlFutxSXVpHS1WTfJOCueWne+efgQQUIUE1Jq7ugpmGC339wk10+wqNAHb0SfcBtxCNdG22CP2SXQ6sUYJhdVUUBsoMGWj+NCU6wLecCfdCp4SO+wlp0+qj4Yv0RDhi0XstXmaWnKFEU60X8k8FaMiJUTolsXWsHqwb31NvGx9k+rpzfnkN0s9vwH+2RW3MW2Vq+8edKwru9QnWeR30qyqZ5KY3pnCAKGVnBpN5H/egbqFE06x8d+Drmd8vpbjxsD/vXrp7isFbL++lH8lVn/CDnBSRFQfSrkEaWKlTYtGWO/0K0rMcygN6ub3phOxl0fdD9nZslpkU6EqtC0Wx4z+gINsUbBJg8JUXGSjEFMYdxBAuc9ZwGpUdelCzhaVi4pYS8blRcpGZO7CGg1yvARlUNEZsmiVExAMNWSv44zVEpoaHO9xh/nHBEfp71ex8wTlBZoPVxV2wHWZEcDgGrRD4hMtaF+y5IpUz6FRlEfIbY9lceyUWbSajKUl3pdfJVLdJipRn0iPZ2UOscEiN0QQJ4JXIGFUqhUow5cYEI73TKZ4n8iZzNQzMd1eArQJGfhE0JtNSNYV5M0HXF2LgtSlDRi1/tqvD+z+oBjPvxAe49CYkM1sMa9ji6E3BlIr2ZNffgbf9qlYsYz2zwukvuj0VvLJyOww/v1w1xMWc+m4V18HcG4lJ5LvlcXmQlw2sY/RPzhsLA9dHjvCPQmO3iL7H1k/I9p/l0OVKEk0vijL6JdyK4bfYR8mngrPIavBLASQ5hRa8eU7PFh6KoXRtP8YW8xHessuWgEIdImZyAlsEqqqacLBp40lKRSQuCDvpN6rsHJ+Efb3fAacTj1zWxczukA4DD
 QARhgdjI
 4ei6QOeUV43NCIjOd8mY0yKSgYt7Rw4E4mlpkHljFfvjOddDHev4h3GsCUUoaONSqXhjwkjdVfXnjTZ6rJq25k6ZNeJT+A5ucWQNLj0n2FC5/GCZlpmUtBYoNwNbZB64w7SKiEdSgdb9A+PK/iUewt6fEzb522unUUIbHhYoySv8BnXX5wEOk/XaTdpC5NGJHAthsCD8p40uTITzEbzog9DdSgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Makes dept able to track PG_writeback waits and events, which will be
useful in practice.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/mm_types.h   | 1 +
 include/linux/page-flags.h | 7 +++++++
 mm/filemap.c               | 6 +++++-
 mm/mm_init.c               | 1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index e25d09f3dfa9..81dc9999090a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -222,6 +222,7 @@ struct page {
 #endif
 	struct dept_page_usage usage;
 	struct dept_ext_wgen pg_locked_wgen;
+	struct dept_ext_wgen pg_writeback_wgen;
 } _struct_page_alignment;
 
 /*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0b0655354b08..ec736811a2c6 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -203,6 +203,7 @@ enum pageflags {
 #include <linux/dept.h>
 
 extern struct dept_map pg_locked_map;
+extern struct dept_map pg_writeback_map;
 
 static inline void dept_set_page_usage(struct page *p,
 		unsigned int new_type)
@@ -292,6 +293,8 @@ static inline void dept_page_set_bit(struct page *p, int bit_nr)
 
 	if (bit_nr == PG_locked)
 		dept_request_event(&pg_locked_map, &p->pg_locked_wgen);
+	else if (bit_nr == PG_writeback)
+		dept_request_event(&pg_writeback_map, &p->pg_writeback_wgen);
 }
 
 static inline void dept_page_clear_bit(struct page *p, int bit_nr)
@@ -300,6 +303,8 @@ static inline void dept_page_clear_bit(struct page *p, int bit_nr)
 
 	if (bit_nr == PG_locked)
 		dept_event(&pg_locked_map, evt_f, _RET_IP_, __func__, &p->pg_locked_wgen);
+	else if (bit_nr == PG_writeback)
+		dept_event(&pg_writeback_map, evt_f, _RET_IP_, __func__, &p->pg_writeback_wgen);
 }
 
 static inline void dept_page_wait_on_bit(struct page *p, int bit_nr)
@@ -311,6 +316,8 @@ static inline void dept_page_wait_on_bit(struct page *p, int bit_nr)
 
 	if (bit_nr == PG_locked)
 		dept_wait(&pg_locked_map, evt_f, _RET_IP_, __func__, 0, -1L);
+	else if (bit_nr == PG_writeback)
+		dept_wait(&pg_writeback_map, evt_f, _RET_IP_, __func__, 0, -1L);
 }
 
 static inline void dept_folio_set_bit(struct folio *f, int bit_nr)
diff --git a/mm/filemap.c b/mm/filemap.c
index c0bff1e08a28..e3aa2754da3f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1197,7 +1197,7 @@ static void folio_wake_bit(struct folio *folio, int bit_nr)
 	 * dept_page_clear_bit() being called multiple times is harmless.
 	 * The worst case is to miss some dependencies but it's okay.
 	 */
-	if (bit_nr == PG_locked)
+	if (bit_nr == PG_locked || bit_nr == PG_writeback)
 		dept_page_clear_bit(&folio->page, bit_nr);
 
 	spin_lock_irqsave(&q->lock, flags);
@@ -1254,6 +1254,9 @@ static inline bool folio_trylock_flag(struct folio *folio, int bit_nr,
 struct dept_map __maybe_unused pg_locked_map = DEPT_MAP_INITIALIZER(pg_locked_map, NULL);
 EXPORT_SYMBOL(pg_locked_map);
 
+struct dept_map __maybe_unused pg_writeback_map = DEPT_MAP_INITIALIZER(pg_writeback_map, NULL);
+EXPORT_SYMBOL(pg_writeback_map);
+
 static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 		int state, enum behavior behavior)
 {
@@ -1697,6 +1700,7 @@ void folio_end_writeback_no_dropbehind(struct folio *folio)
 		folio_rotate_reclaimable(folio);
 	}
 
+	dept_page_clear_bit(&folio->page, PG_writeback);
 	if (__folio_end_writeback(folio))
 		folio_wake_bit(folio, PG_writeback);
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 66b68c02d8d4..2695d7b3b089 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -589,6 +589,7 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
 	dept_ext_wgen_init(&page->pg_locked_wgen);
+	dept_ext_wgen_init(&page->pg_writeback_wgen);
 
 	INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
-- 
2.17.1


