Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65511CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984EB6B009D; Wed, 20 May 2026 17:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935F06B009E; Wed, 20 May 2026 17:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824156B009F; Wed, 20 May 2026 17:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED9D6B009D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:05:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1530CC1BB0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:05:08 +0000 (UTC)
X-FDA: 84789028296.04.F954EB8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4BF3F140013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:05:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bR9HCAGS;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779311105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NoQFWNK7oWAD/wrjDNQs2N+Z55W1ZBNqkdyVcG17n+A=;
	b=bROOZRCafCIazOPmHmEtia0W74HRDdYJy9eTOJe/4DaiGrf/T6oHjVCEicM3WiCb7+10qI
	2bWSJ53npHhR5PaLWMVVAAoUpd0Dd1mUVpDHpxEQOxd01NfGE9MDGVVolLItmVCCJCls06
	0Jc2VmcpaV0cveIffwRxGyWs26Z/4yk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bR9HCAGS;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779311106; a=rsa-sha256;
	cv=none;
	b=vDKKuVaPXecrFSRo4ExLJs/rWeGPKggSme5j9p+JVLNpudMJD/ncFwwbo30zj+hh+/7k4e
	A94qIWVr73jmsIXvjrolWyPybKhr8NtePk+Sss+yWOtmywF6WlLn9mPL5iXR5uWaKRnYQu
	wGX83CSBbUUx1w/Cy2+lgpKAGrv2A80=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=NoQFWNK7oWAD/wrjDNQs2N+Z55W1ZBNqkdyVcG17n+A=; b=bR9HCAGSj3BuTqMtUE+DLlE2/V
	hbqFNHpAblQKp5tyrESGJToQyAt4gGSYt43sRu6JEbVNZTj0qvFZxTyoBxJ1wp0kQ5ZcRxN1nm3Rb
	gh32K03vbE/E7J0yrggnNOynCTcgltl9vPaiaVZXlPQBWE/JQgInR1dXcExZ8Iz6LVbgTlq8x52mX
	WL8vfh2Lyfw2a/Tpq2i/SXxctbJ1CzS4YgLicbHSvLU347BFYhk2464cXsmbdNSDNV+5du23ojl3E
	wPSEPslSUR5LG+Oc0B2L/jDVGsi3Or0fTJoXFl2vl9TX0JbwU5Szrew428V10FYaIsgWdHpxL5RaA
	8tHIsB1A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPo5z-00000007aEX-3LBW;
	Wed, 20 May 2026 21:04:51 +0000
Date: Wed, 20 May 2026 22:04:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, david@kernel.org, vbabka@kernel.org,
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de,
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com,
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ag4h87CBd-gph9zX@casper.infradead.org>
References: <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
 <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
X-Rspamd-Queue-Id: 4BF3F140013
X-Stat-Signature: zp5kf8njuyimi5huki4y9whtoiku8wy9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779311105-688338
X-HE-Meta: U2FsdGVkX19EUeR1itHPmHvZJyxIawLPt0NUjweM6BXIZEwqPwg87VlcbvBQesD0PH1aXgMKmW060ruTHktdfFNDshpNrp4gHD7DQYZBmaU90q0fvxqG1fi2/ZocAeZKBxHKWZ5pHHcDRgVgSFrBmX+8YHg8j/2Zif7bg71WhAweLHjinChBpqpy5ATSz3IB0vJ7cRh1Uf0owwJ2Yy26uyAa7abJBHV5lg8M9RRDl4AoVB/0ZgAhaH+p0USEBfZ8VZJ82bsezRCqVHUQrdiHlgh3yjOffmdrdGyOOipfWGZADDlywXKnG1SQXR6+d8cWhnceI/y44owaCjqU7LBrbEn4zf7GY/rX34WdwkcxV8fICcGzWVPf82QkNnPsA6P1V706MgvNAQug1FonN+3zFiSq3OOt5Q+4t44w/kkhC4FpsgMMoRyAYWeGBQ4LKBOmn/aA3YMZcX1qifgOoncd3mZenDIXV57FKP46/or54iVXKTMGJXRd+PTcVdLzrVzyMQd74M0i2aeNJh3jdzfoaQUq2iXjVIWhlQsCfkfFw3oTD1Rdt0LFNw3CIyjxZrW0/jShdVCkeqibEJnD8k1gx5RYFCBtHGHvFGtnpmw+pyhoWYAQ5CcrEBb9jdVMosFtEWq1hjQRk69O4VVDBLHRXdPXWP2P/Dh3aJWXxo0AJzC7TrYEtuFZsgvUgGQ3Uy85uCqir8kOgGUc8ZsNq88rY4JV9zucOKbRojk6/521Mnht5ffgHRiVegdD8d8emWWoWuBUHZUC8a8lsWosZ/Z648uMy9ivvaqnhihlhdXEhrFxi1aHSTjpv1doKI4JICWatE3ULn51Dkoc0JJinN/zrTVCmUr1PWwbrsPsbKXo5TOubb7cgF+lqZr5FqN+pntug1rNDrVJNiXQVWs5d12hzCOg6MFH8Wh+t0hGv6QxFejom3wnNtCOU6AA4i3O1ToVJwEmguyntgv5fUsct4K
 DUmpSu83
 yg/fGcQEVqrr0rT1jbN+dL1nGcmBXTVKZvL2cp5qLIDpF0jCmN1e0YNnCqTnuymx6pTeUw86YnAn5EANkEsBP5PhWdokGUZEnvoNJVSY3n49oqpSU168mnhiatBu6iwYaZ0BUUwEt95vGmnFMJtcaENSK9Lfdo33tRvdFix2eeJSro5D4Bf+AfeUEIc4Tmxm1nUOYt61xzdmistRegSM6eH8mHdmetIPVL2E3Es5fFD9CZxbSZIPqu3chNzi9r09XszCRiOe/KMeC485flHOc98XkkL3gXapn/IPbj8Nfbr8y/WvrKwa0BPdp99sti3VcgcIDi8PuAIZRARK/n+N/VB+yjHhQZpQ07KN7guFr3vqCnRnxxqUOvrIPsiR1oqcnr2cHMLEV0N0+2/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 06:01:56AM +0800, Barry Song wrote:
> > implied is that the per-vma locking may stall mmap_lock writes for
> > longer than if the mmap_lock was taken in read mode?  Barry, is that
> > correct?
> 
> Not the case — the actual situation is (if we modify the
> current kernel to perform I/O without releasing VMA read locks):
> 
> thread 1 PF: lock vma1 read ----  IO ----- ;
> thread 2 PF: lock vma2 read ----- IO ----- ;
> thread 3 PF:  lock vma3 read ---- IO ----- ;
> thread 4 fork:  mmap_lock_write ---- lock vma1, vma2, vma3 write ;
> thread 5 :  take mmap_lock for any read/write reason
> 
> Now you can see that thread 4 has to wait for the I/O of
> VMA1, VMA2, and VMA3 to complete, and thread 5 then has to
> wait for thread 4 to release mmap_lock. Both thread 4 and
> thread 5 can become extremely slow, because I/O may be stuck
> anywhere in the bio/request queue or filesystem GC.
> 
> So now we have two choices:
> 
> 1. Change fork() to avoid taking the vma write lock for vma1/2/3 where possible;
> 2. Keep the current kernel behavior and drop the VMA lock before I/O:

Option 3: Say that this is a very silly thing to optimise for.  I have a
hard time believing that any application will care about the latency of
fork(), or the latency of page faults while it's in the middle of fork().
Multithreaded applications just don't fork that often!

