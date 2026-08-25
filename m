Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02DA9C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9166B00B3; Tue, 25 Aug 2026 09:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059556B00B4; Tue, 25 Aug 2026 09:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64326B00B5; Tue, 25 Aug 2026 09:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC1706B00B3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:19:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42444803FB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:19:13 +0000 (UTC)
X-FDA: 85139847786.11.E892C5F
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA9E64000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:19:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf01.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kH5MVggWeSq1SefTcg/6K/tb1NMrR4tq2AreO77Uhwg=;
	b=cTb2NjU0Znfx+7a7ljOCGu+NijCy9jVRJEQj85wyXNqEpJZEKXG3L5pMbyvfL4hpKyCxxt
	5n8n+Ladcrp/L1Nsn6ico5lhjElGT+2qLvlJJaBnZd4n90zT4mDw4PQ538a73XByjsFLSM
	6MKjY/UwhoxU8u4slReCRXN7cRmzu4Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf01.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663951;
	b=oDsakbLGZoccQOIB16Pqf+VlJCHNrdU/Ft6mTJOgjkF0xTIY48pXbndLV1aWR2fe5h1mXo
	efJ6j2oJmK40etyZ3Z/U2bFJ90xgSKVFYiza5C4pUhMVgREOQ1fchK9kc3e6fRJcJa6drF
	yV8kA65bhJ7U5v/KNN697mAbyXvsKVU=
X-AuditID: a67dfc5b-c2dff70000001609-0c-6a8d964b3a74
Date: Tue, 25 Aug 2026 22:19:06 +0900
From: Byungchul Park <byungchul@sk.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	boqun.feng@gmail.com, longman@redhat.com, yunseong.kim@ericsson.com,
	ysk@kzalloc.com, yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
	gustavo@padovan.org, christian.koenig@amd.com,
	andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
	samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org,
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, urezki@gmail.com,
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
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
Message-ID: <20260825131906.GC23086@system.software.com>
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
 <20260821042143.GA40890@system.software.com>
 <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
 <20260825121322.GA23086@system.software.com>
 <e0c589d0-d17b-48c2-8e1b-d41b69ecaadc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0c589d0-d17b-48c2-8e1b-d41b69ecaadc@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0yTZxTe+37XdnZ7rSy+4rK4LssWkjkwZDvJnLjEZF8yF5fs1y6JNvJN
	yrhZLooLDnRoh5fWZkAoOiuOezOwXASxMhC5aIh4qelGC6K1rDB0soKzlmLLYuafk+c85znP
	c34ckVGf5GNFXUaOrM/Qpml4JaucWXbqnU/KjqTGdwTjwT3u5WAuYGDheJONh4XKswIY7BUc
	jPzaiGB8zoAg8HhUgH+awzyU+4tYsPgqBfBf+hhmxrs4qPGGMUyX/c3Dk+GrDJSXjiA4NeFh
	oLV/DMFkWxDBDe9LMFR6iIeZa8cxWPc5OOi8fU6Aa9MhDI32T+GKqQpHvHkoO7MSKsv340j5
	E8OdOosAoYkEWLRmgsdYysLQ2C0OAjcnMNgO+xiw3420FT+7eTjvGGLBsBBA0N9xB8OYbZGD
	pkkXhiv9g5E1Sz0Lo8NGAVymewim52sYqJl7IEBRz2kWfM4DGMy+WQHauosRuI9OsXDglzMY
	bv7ehSDo6eAgWHsJweyJMAfND2t5uG8KcBs/kh4VH2WlhpZ2LBVfX+ClQPV+Rio22ZB08a8H
	jPRDyy7JMW9lpctVVOq0eATJas+VWuripNPn/Vj6Y/pDyd7wIy/ZZ83CZ69/qVyfLKfp8mT9
	uxu2KVM8xmouy8Htbr9tFArRMbYEKURKEqm52cU/w50OG1OCRJElb1LfvaQozZO3qMv1mIni
	GBJPJwf34RKkFBnS+Br9aXxAiA5WkPdpq/sQH91VEaBXL78c1ahJE6ZmZ+uSRkWW06EK71Iu
	Q+KoK+zHUT1DVtPasBilFWQDtV3wLmW9Qt6gv7UPLGVR4lPQqYPV+L87V9GeOhdrQsTynK3l
	OVvL/7ZWxDQgtS4jL12rS0tcm5Kfodu9dntmuh1F3ramIPRVB5od+bwXERFplqlGjh1JVXPa
	vOz89F5ERUYTo/quoCRVrUrW5u+R9Zlb9blpcnYvWi2ympWqdfO7ktVkhzZH/laWs2T9sykW
	FbGFKHUzfZHLEU50b+G/tllL/91c+MIHX7y3M1QVHBAvLlY2bnQix9bQ+m/2rupLqTh5OFbd
	tqdohWHQkBhucWdtSlD0JJj7zuVOuv13lzvr1zgK7m+bSvJefzKs6Vd2dQvDTsVZ/UBD/Tpv
	3/fbR2MOTrz96GHWTNLiBSO6IexYs/fVLRo2O0WbEMfos7VPAWCHzluyAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTGfd/39vbS2O3aod6IWUxl0ZD4lWg8m4sf2RbvNDOaLEFnnHbj
	RgqlaqsgW4xSaAZ1alttCa0ogq1M6mDlw3WujGAEUYitH6NRsJhciwQQo1QjUFhLYuY/J+c8
	5/nlOX8chihiknmMWntQ0GlVGiUto2Rb1hQu2Ww/kbW82s5AsfEo9IRFCfxb0EJBdLSYgrO1
	HhpizqtSKPaWSeBmt4GCwO81CMLRYgRvxp0EjL4pCmLWNimMvn0kBVsBgil/GwJ70EogFPiH
	gKehAMOrukkaBq+/RGB7ItJQOlBAwYj7VwSOiFMKAzc2wnD4mgSmevsxdL8eQuAWJzGILb8g
	iNmz4XxlfRy3v6BhvOsOgVJbAMGFJ70EXg70IWhoe4ygv3EMgb/aQMNTcyOBe+IHcD86QkOH
	7TgNw8GzGJ7X0VBh8Esg2DmIoNxpRRB56MdQWFVLg73cS4Gv7y8pBAcnMPTYrRhqvN9A2B2h
	4La5Esdvjrv+mAvO0kIcL88w2K5cw+vdiH9jPEnxl+ubMG+8G6N5zzkP4sfHrIgfdRUS3miO
	j9eHRghfVJ/Hu24P0fxY9AHN+19XUPytSo6/WDKGeUvXEt7n6JVu3fCd7PMMQaPOFXTL1u6R
	Zfaeckn2+yWHm/pOSY8hC2VCSQzHruR8fg8xIYah2E+4yNN1CZlmF3Gh0FuS6JPZ5Vz/TQM2
	IRlD2JqPuTPhdmli8RG7mmvoOU4nWDkL3J1bHyY8CrYWc9YHDdMeOTuL6ygTp7MIm8aFJgdw
	wk/YFO7SJJOQk9i1nKdZnM6azS7kWprasRnJHe/Rjvdox/90BSKXUbJam5ujUmtWLdVnZ+Zr
	1YeX/rgvx4viT+k+MmH5E43e29iKWAYpZ8oDlhNZCokqV5+f04o4hiiT5T8fMWUp5Bmq/J8E
	3b7dukMaQd+KUhhKOVe+KV3Yo2D3qg4K2YKwX9C922Imad4xZG4v2TX/i5IFXak7872z1Zlf
	Pg6EijTN5KTPtmOoSL/z+23LtKldaYcaXdVKU2k0b05VimgNlnV7A2dM4WrX1XLVloX2Hzqp
	zzIu8es76hbvdVZ9Onzh24ruPEPqb191bp+RHli3Rvza0pceOdCcc9r899SMzQvuh3J3Tww+
	G+/A55WUPlO1Io3o9Kr/AKCz9huQAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 93f6xf997wbbdnjhtk6a1ncee7h6q8ff
X-Rspamd-Queue-Id: BA9E64000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787663950-572973
X-HE-Meta: U2FsdGVkX1+OagzBBcdhfwQmLqxaw+hqM4m8k6OGTgjvDAXQPEX7PZ2ftWFznucpBxVO0mKp9XibY7XNatsPEXdWmGmv3+kAQOODgIrrD/a2mloOOUBus+T/rZKQM81tsinKwpjjw2shHK+8Rvpvq51yzCh8vjPBJUkENW2MjbHtLZWq1itiDgbEYDEl5ueTizVWVrSIui+43IJ3dhBB8CSPXON4XeFGjj+XWM3q3iY7dEr/88EG3/ilgDVqv310jivwxbhbwK/nt3SSk86FtrUHub3wSM7xY/c+y85yRGJ6lDy4SjX1VmHf9dVt7H0Wp9nP/2t4Xbgo0rpDooVZb4jcWrjwfkey5D9Z3VH2FMFOGCrc7juNejXNBQpquTWxbDbA0UC7WoBXMRIpSoBXfgiuCzvcZdY2fPcbqzOtmqqwXjWNtmxPQTmOVQlDmxgAxvpC+kfvN81+0bXFKVf/18h5d19d1FeO+LDjZuOpQYTDozx/HmWiH0F6MpOUDRemDdyCDgSgjpJF13ue2k1bS+TMrEvvsQehpFsF0Qhjye2VnqNZ8eM292cGztMdLh4cN71ZugCYqUCskPzFy0Wlf3/kpC/BjDlawIX6J8O0YrhUYm8lynVCsW/96ssMwtqAYAJrEymJ75tc694csxLtTlRMrGcbzn1qmVA0sJSikE7unCiLCbDA3TtaWYjMxO6sQxFmsIRgUMe1hqXSp+rkCDSeU4vepvrXxB/f22Lk3MH4dwruymQGb9Vnew0n9UhYXvOtQP7ufKfmt+CPvczzoK5deRYtkm2fFiszTrO/HlR5TM70p7y6ZLfQ6+00vSgGTEIBpQ8fueuVfn1AP8o3EC93hqIFOLDl+6ylseaadj+2BY6aADRDKxCFCEfqhRYzfa1OXKKOvVMMOzF2tJ/3q9N6Yoly5geqxpMtWNL2iqwDDPt1ZtcTTE6URwaO6YlUHfwxqrzZmC7JwWh8G0P
 kgRfy4Nh
 YzpLIK5UFv+o9oWrNTAGIYow5aaTUNsFPiz4ETEVXBpXTUT+NdUyqCCmWoO/6yCOgeYJzmq+OWJ5cueA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 03:10:28PM +0200, David Hildenbrand (Arm) wrote:
> >> As the saying goes, it's hard to teach old dogs new tricks, but in the end
> >> taking care of two dogs is likely harder than only a single dog? :)
> >
> > Or it's better to train a unmatured hunting dog than to teach a pet dog,
> > how to hunt, for better hunting, even though the pet dog might
> > eventually become able to.
> 
> I'm not sure whether "pet dog" is the right analogy to lockdep in that scenario,
> though ;)

Ah.  Okay.  I will be careful in using terms.

I wanted to tell DEPT has its strength, lockdep has its own, and they
are different.

	Byungchul

> 
> --
> Cheers,
> 
> David

