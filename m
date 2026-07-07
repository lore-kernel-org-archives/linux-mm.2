Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90349C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD226B009D; Mon,  6 Jul 2026 22:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE316B009E; Mon,  6 Jul 2026 22:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651F26B009F; Mon,  6 Jul 2026 22:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC316B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:35:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FB408CDE9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:35:56 +0000 (UTC)
X-FDA: 84960415512.12.10ECB14
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf19.hostedemail.com (Postfix) with ESMTP id ECB781A0006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:35:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783391754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evlt+H2flNU4v1UcR6D99LjG9UvybD3lTDno3Lap+u0=;
	b=sVvx0ZV1UIfhosJYQszhBaiVGyYQB6TOzp4BQN52LeJ96Itow0kglhwBZDitSd4ku5okYu
	lUlybKnO/TiEmnJtUWUApSTq4fFrC5k+oqqFFaRd9oxjilOuY63/hXTtMS1f+vXn/utICd
	o5eH7q9P9sCCOTFv41lcg3SiFZEZNIk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783391754;
	b=sat3+jpLJHQ3ttYHFw0Nm50AC4sxUFJ6ag0uhmaF30Jx+GHQf2a1S5HYHHqjvO7C8NRTkh
	/3DECxpX+eU3Eh9NPGHpS4tygPPm1EOHYCuogNMoBAxkKTMNFht1UIzJ+TLipqMBi895Sf
	cw5tGAfI3MmbSqRZZMOpOYErvZN2+v0=
X-AuditID: a67dfc5b-c2dff70000001609-b0-6a4c66049ff9
Date: Tue, 7 Jul 2026 11:35:42 +0900
From: Byungchul Park <byungchul@sk.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	david@fromorbit.com, amir73il@gmail.com, gregkh@linuxfoundation.org,
	kernel-team@lge.com, linux-mm@kvack.org, akpm@linux-foundation.org,
	mhocko@kernel.org, minchan@kernel.org, hannes@cmpxchg.org,
	vdavydov.dev@gmail.com, sj@kernel.org, jglisse@redhat.com,
	dennis@kernel.org, cl@linux.com, penberg@kernel.org,
	rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
	linux-block@vger.kernel.org, josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
	dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
	dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
	melissa.srw@gmail.com, hamohammed.sa@gmail.com,
	harry.yoo@oracle.com, chris.p.wilson@intel.com,
	gwan-gyeong.mun@intel.com, boqun.feng@gmail.com, longman@redhat.com,
	yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
	netdev@vger.kernel.org, matthew.brost@intel.com,
	her0gyugyu@gmail.com, corbet@lwn.net, catalin.marinas@arm.com,
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net,
	bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
	alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
	lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
	tmgross@umich.edu, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 22/40] dept: track PG_locked with dept
Message-ID: <20260707023542.GA33746@system.software.com>
References: <20260706061928.66713-1-byungchul@sk.com>
 <20260706061928.66713-23-byungchul@sk.com>
 <akvueAxPl8aoLvMR@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akvueAxPl8aoLvMR@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTZxTH87zv815o2u218/IMNp0dY4ZsbCgfjstG/LDIu8wtGvdpJtMK
	VYoFTSsoy4ySbV3XsI6hE2mJtl4AS0VpRRkDBwhIxzWTdEW5yEWxWaGx0g7l4lqNmd9++Z9/
	fud8ODwtt7GxvDpnv0qbo9QoWAmWTElPv4t3bcp63/hoHRi+PwyhGQOGsosOFhYsVznoq65C
	MBIyIHjS2I7AcbmAghJfAYZAeSECX1sa/B32I5ho+gHBwvE9MNfdS4NtdIiGoO8Ogv5QgIXO
	otMUHK9ZAZaSbynoOjOIYazSzEF71SQH1VO9DIzc0DNgqA9hcI57GLDpz2IoPTnIQkOjG0N7
	3RgFw44nDPxV1Yfh4qSXgs72Dgxu83kMt7t/5qC3/gIDo3e8DLi6u2gIm+Lg6PQ9BAMlfg7K
	Q4HIMutyOH+qAkHxvSAH/QO/IzhXOcXA9ZCfgj+HHnLweKiOAU/xKRYeV7Qh+HXewIKlwITA
	0BqmYW62jAVTTxrMXhpnYKbKzsJ00QwDlrZhbsMG0XHSgcTvXAfEc51+VmwMW7H4m3mIE63O
	XNFVmSieafBRotP+Iys6g8WcaJu7T4uDngZWnO7p4cSOE3OR/uh6caK/hNr8xpeSDzNUGnWe
	Svte6g5J5oMLd+l9luSDLnsjdwQ9TDCiGJ4IKaSjuZZ5zqWuGhxlLMSTnlYrFWVWeJt4vY9o
	I+L5pcIa4r+81ogkPC0cW0lspitctPOKkEqu3Q4/ZZkApMh6jIuW5EIhIv7CRfxssIS4Syee
	Mi0kEu+ij4pKaSGOVCzy0TgmcsPIv//QUV4mvEmartygoh4ijMWQ+rvPPER4lTRXenEREswv
	aM0vaM3/a62ItiO5OicvW6nWpCRl5ueoDyal7812osjjlh+a31aHgn1bW5DAI4VUdsn4aZac
	Uebp8rNbEOFpxVJZwppIJMtQ5n+t0u7drs3VqHQtKI7HihWyteEDGXJht3K/ao9KtU+lfT6l
	+JjYI0iv0f2BN730Sdnm1o03d0gHFpgvmlanjZq8y+UJjt71k6HZQ6s/Tq0tjX19/OzOha9k
	Gxfjr62UBoY/G9Z3Je/6/NaWZSn8qqb7r21/OSu9tuaXj46eSAp4ch+8lS5skcLhhKvTA27N
	rXfWpZbd3BY/m6ef+Sbo+WnnB5rmPt49X51tX6XAukxlciKt1Sn/A9zEkT+0AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH8zzP7b2XZtVrZfMGEhLry0wzcTI0J3PzJVnCzXyJcR+2+EWb
	cZXypmkdA5NFKDRWJKY0toRWtKLUBXkrrUxwZVi2MmUOKttgA1ZZKti0jg15CSDF1mXRLye/
	8z///8n5cFgij0qSWHX+KVGTr8pV0FJKemBH6Wbq2L7sdwMTUjDoz8BIICiB30q6KJiZNlBw
	qbmBhiXbNwwYWqsl8OOgjoL+ppsIAjMGBHOLNgL69mUKlkw+BqbnhxkwlyBY9vgQWPwmAkP9
	3xFocJdgeNYSpSHcPYXAPBakoSpUQsGkowKBddzGQOiHDHgauCOB5dEJDIOzEQSOYBRDsOss
	giVLDlypdcXiln9oWHzQR6DK3I/g6tgoganQIwRu358IPF/raHhsvEVgILgCfpmZpOGe+TwN
	T/2XMPzdQoNd55GA/6cwghqbCcH4Hx4MpdeaabDUtFLQ/qiDAX/4OYYRiwnDzdb9EHCMU9Br
	rMWxc2Mu5xqwVZXiWHmCwdx4B8O8o57ZXYeEOf0FSqh3tWFB/3CJFhouNyBhccGEhOm6UiLo
	jbG2OzJJhDLXl0Jdb4QWFmZ+pQXPrJ0S7tfywvVzC1iofLBZaLeOMgf3HJZ+kCnmqgtEzZad
	R6VZ/zY+JidtWwtd9R6mGD3bWI4SWJ5L56tdTirOFLee//l7O44zzb3NDw3Nk3LEsoncJj7i
	TitHUpZwF1P4qxfamLhnNbeT7xyefckyDnij/SITN8m5CsRHKqLUf4NV/L3q4EsmnJIfioZw
	fCnhkvkbUTYuJ8RuCMyFSZzf5NbxXW092Ihk1tfS1tfS1ldpOyL1KFGdX5CnUuduS9XmZBXl
	qwtTPz+R14piX+n46nnlbTQ9kOFFHIsUb8hayvdmyyWqAm1RnhfxLFEkyjZuikmyTFXRaVFz
	4ojmi1xR60XJLKVYI/v4U/GonDuuOiXmiOJJUfP/FLMJScVox8rOTzqN207vYrZ3HAzNjvUd
	ej/tQ+9b78gHC4uFhYq6bP9HqUfW9w4cakJlzhTnsfdu/I5GjG7Pck96dI//4Srf9hppzxZb
	d8YtX3Ll3W/DE86IUuFOYJo6XOfGy9YOW9OaJRuUuhFvn1Lc9VfSZ/evJDam56lG16YYdIev
	TWUqKG2WaquSaLSqF3VSn4uRAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ECB781A0006
X-Stat-Signature: mw9bqdfqxa6p7bc84zjfqfk8a5jhgqy9
X-HE-Tag: 1783391752-407632
X-HE-Meta: U2FsdGVkX18vxnq2WY18wsAZ55BvlTiG5+GbWarqMhD74DsKyBhJPuJXb2LB+ViExAHQe5ZcILOclZ0MUfcLqVKJDFtILvd64lctCmFvoCW/LcLap5ZZKpp6PS43FXO0okPWSBvfGCWZ+QYyC1nSZxu0dhS5NYSc9MNWfa/80wdl9uG51JdJdl5rNYTm7C/5bWra6R6jk2vm/qAdWOEruFdCPkAEhpCKRHYwo1HNg6pFR326No+SPj0qamgwqBBYPt9qXl63nMdlNESvjDzYA9AywqT1yrBXM6FpvROjOpmi+ZXWHGYSA0DGpBj7UlRMYDwmM7aBNly6gg/JDKh1ZzCD5vUfBr8TNtmTY4a/krs0UvMxNgNfLKdFYAFCVIX1XgB4dUfiTIWS1XVh25sJddKuHGofTmf+9IAMCPGjivCCk7luA6nMhHUIkVGeopc3Zr9ISLuD6fPtVHbMEwCt1wLT6odEAiUaA2y0x1fIaBLukaxaouRDW6XTeCZ2M16vW9ol5ySu9wUwnp1ixtK1z3391DSsU4eU0PyzxzW5xBs83xxb2ZVABUWQ7d+tgKqsWW+LOxsGV9vrXKw1FsMd+323eztf3TEhtuwf1Ji39cgneF91mW7vgPWKoWy73i57GhYIm3t7QHQyOSn4q5fqSrjhKJg98aXNi+DsUXzujGHG7cN2HbvIoXYj4FZFtmK39mw7TaavJ9ogFgcNuwGWbyp0ZCwwbPFWZKiB7/hn1WRMzAFKqMc6rPnd30ZydvemcsC2cGK/9gEpdnwmyzekPXDZNsGL9qBG5OsIDUdht1MsDfjaUIfITNboHDn/ecv3N7Z6nhwOvoJHryRrVwvXq+41Ok1/JpFkDl+fcdcoM91lfwXvBDl0Iv2b4E37GTYp41ET8T+K2bTWa4osH6mds4ArTKkAr3emL+zT+Mxh5Fl2TwQ5azCIe1oXCE1/nL/uD8JCcPzWJ3M7FXXK4xF
 Q9e3GSQy
 GYQR9fdunZ4I/IQRu42s3rofgPAvzhST4RuHPZChlIzMUM+3e47EkjLZsM+WKEsTbMAK1gTziMJYMKwTmmcqCDfTEGlQ5bpmm5ocdGjRR92gsNScH792YhYC2VYAdo987Ed6/Kdihr7ghLVMjidKHKMNoyVX4fR9xrLNVCb9jCp655LM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 07:05:44PM +0100, Matthew Wilcox wrote:
> On Mon, Jul 06, 2026 at 03:19:10PM +0900, Byungchul Park wrote:
> > Makes dept able to track PG_locked waits and events, which will be
> > useful in practice.  See the following link that shows dept worked with
> > PG_locked and detected real issues in practice:
> >
> >    https://lore.kernel.org/lkml/1674268856-31807-1-git-send-email-byungchul.park@lge.com/
> 
> > @@ -219,6 +220,7 @@ struct page {
> >       struct page *kmsan_shadow;
> >       struct page *kmsan_origin;
> >  #endif
> > +     struct dept_ext_wgen pg_locked_wgen;
> >  } _struct_page_alignment;
> 
> I may not understand this quite correctly, but I think that tracking
> PG_locked dependencies in the struct page has both false positive and
> false negative problems.
> 
> Imagine we have a file mapping M1 containing folio F1 at index 0 and F2
> at index 1.  It is correct locking order to lock F1 before locking F2
> (for example when doing writeback).  Later, M1 has its folios reclaimed
> and returned to the free pool.  Then each is added to mapping M2, this
> time with folio F2 at index 8 and F1 at index 9.  Now the correct order
> to lock these folios in the order F2 followed by F1.

First of all, I appreciate your feedback.  Thanks!

That case doesn't generate any dependency unless any other waits are
involved in.  That should be handled in xxx_nested manner e.g.
folio_lock_nested() that I need to introduce.  The work is in progress.

> I don't see a part of this patch where we clear pg_locked_wgen when the
> page is returned to the page allocator.  Maybe I missed that.

You are right.  pg_locked_wgen doesn't get cleared.  However, DEPT works
this way:

   folio_lock()
      wait_for_pg_locked_cleared()
      set_pg_locked() // (1) update pg_locked_wgen to the current wgen

   ... // there might be other waits

   folio_unlock()
      clear_pg_locked() // (2) check if there have been any waits since (1)

In other words, it's guranteed that pg_locked_wgen has been updated e.i.
(1) when DEPT refers to pg_locked_wgen e.i. (2).  So I don't think it's
a problem.

> I think we should be tracking PG_locked dependencies in the owner
> of the folio.  For files, that would be in the struct address_space.
> For anon memory, I think that's in the anon_vma, but if somebody told
> me it was in some other structure, I wouldn't argue with them.

I think it's a good point but it's a classification issue.  folios owned
by struct address_space should be classified to e.g. address_space_class
and ones owned by struct anon_vma should be classified to e.g.
anon_vma_class.  I will work on it to apply the insight you just gave
but better do it as follow-up patches since the initial patchset is
already too big to get reviewed.

> This requires slightly more complexity than lockdep currently has.
> We don't want to use a lockdep class for each folio, obviously.  So we
> need something to say "I already have folio F1 locked, is it OK to lock

From DEPT's perspective, folio_lock(F1) and folio_lock(F2) are waits and
folio_unlock(F1) and folio_unlock(F2) are events.  Since DEPT tracks
dependencies with specified classes between waits and events, DEPT's
interest in the following example is to detect a situation like:

   < context X >

   folio_lock(address_space_class'ed F1)
   ...
   folio_lock(anon_vma_class'ed F2)
   ...
   folio_unlock(anon_vma_class'ed F2)
   ...
   folio_unlock(address_space_class'ed F1)

   < context Y >

   folio_lock(anon_vma_class'ed any folio)
   ...
   folio_lock(address_space_class'ed any folio)
   ...
   folio_unlock(address_space_class'ed any folio)
   ...
   folio_unlock(anon_vma_class'ed any folio)

However, the following pattern should be manually annotated by
developers like using folio_lock_nested() or something.  DEPT cannot
work with it automatically:

   folio_lock(address_space_class'ed F1)
   ...
   folio_lock(address_space_class'ed F2)
   ...
   folio_unlock(address_space_class'ed F2)
   ...
   folio_unlock(address_space_class'ed F1)

or

   folio_lock(anon_vma_class'ed F1)
   ...
   folio_lock(anon_vma_class'ed F2)
   ...
   folio_unlock(anon_vma_class'ed F2)
   ...
   folio_unlock(anon_vma_class'ed F1)

These should be explicitly annotated by developers if it's intended:

   folio_lock(address_space_class'ed F1)
   ...
   folio_lock_nested(address_space_class'ed F2)
   ...
   folio_unlock(address_space_class'ed F2)
   ...
   folio_unlock(address_space_class'ed F1)

or

   folio_lock(anon_vma_class'ed F1)
   ...
   folio_lock_nested(anon_vma_class'ed F2)
   ...
   folio_unlock(anon_vma_class'ed F2)
   ...
   folio_unlock(anon_vma_class'ed F1)

> folio F2?".  Essentially figuring out how we can track all folios in a
> given mapping the same way, and making sure that we don't deadlock on
> folios in the same mapping.

At the moment, as I told you, DEPT cannot work with dependencies between
the same class'ed folios.  However, it'd be much better if DEPT can work
with even those cases.  Could you provide a scenario where a deadlock
happens between the same class'ed ones?  Any idea how to detect for the
cases?

> If F1 and F2 are in different mappings, it's not a deadlock if F1 is in a
> filesystem mapping and F2 is in its backing dev.  It's also not a deadlock
> if F1 and F2 are both filesystem folios and the inodes are both locked.
> See vfs_lock_two_folios() in fs/remap_range.c.

Yeah.. DEPT is a tracker to track dependencies between waits and events
even across different contexts, but not a magic unfortunately.  That
lock ordering issue - with the same class'ed ones - should be resolved
in the manual manner as vfs_lock_two_folios() does.

> I have much less knowledge about anonymous memory locking order.
> Maybe it doesn't happen.  Or about locking one anon and one file folio.
> For slab memory, we don't sleep on PG_locked (it's used as a spinlock bit).
> For other kinds of memory ... I don't know.  Page migration is fun.

Anyway, the sophisticated classification you mentioned is necessary for
DEPT to be better especially for folio locking mechanism.

Thanks again!

	Byungchul

