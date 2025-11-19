Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272CFCF34B2
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4416B0027; Wed, 19 Nov 2025 09:38:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254C36B00C4; Wed, 19 Nov 2025 09:38:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CAB6B00C5; Wed, 19 Nov 2025 09:38:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFB886B0027
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:38:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BED82140390
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:38:12 +0000 (UTC)
X-FDA: 84127611624.14.D496FCE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3175F2000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:38:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nBP5qgac;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763563091; a=rsa-sha256;
	cv=none;
	b=dPCVub9b54AWY1lNshHk3NisEAh+1H9+m1OwZ6VfGaSTfuSKOzDDYUAKdtp1XF8PqU7CHI
	YGZRDvgVnuLiEBCIqKCmc8WLHUlsRnkBb8QxIS1ot585rGQ4IhS2nmzC0mWKV264IqJnRH
	DBLJOQstcXC3Z6YckLWK7BgOwrYSzN0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nBP5qgac;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763563091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrEBjc2npjUKEbY4i9jofzcj/5yPuOiFOP9lZOX0tsI=;
	b=VicFYZ0YJao/GpEGQNpOXLIxtbqo1+tIMVJx00TP7WEKZu5oaMAffsHr3OCtcLbKLnKw4D
	iSzmu9glJubieZ2ui9vui2AX/FUsF1YmV1jG0t8ZHESDF3HokTvUqDmPwscoO6bnOS0X1J
	xsj5kl9/IyDFqupw0sIUxjaXxK23BjM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jrEBjc2npjUKEbY4i9jofzcj/5yPuOiFOP9lZOX0tsI=; b=nBP5qgacID7pPb1N+57YvHaH6U
	G7JzO5pEUGdhuUMMNn3k9NaEbTv68dj0hY9UW4pHZq6L+RoVGX93qIlWtLYoQytGKMPvLJ/D1KqKX
	GV6hrdcPub9oX2YzpcjTtacFWku+OtVVTd6+pFYjSu6527+53NKY32Lj/L974tmHv3ScDp3gXp1L+
	iFJ2wJM/Lmo71iZAxzafzKq22ZOt8sC31Kd10ep+n2MvqtEeikI1sljZ8uMGCqsNpyKZSf9jdYI8B
	dZo+n/E+UO2Xtx516smblcWCers9IJLf4xYNhwJApoxEs2EHlQuoj0F7yrGXeee4kL13PJKFJYviX
	pvBttZDA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLjJ8-0000000HDmA-0XUa;
	Wed, 19 Nov 2025 14:37:18 +0000
Date: Wed, 19 Nov 2025 14:37:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, david@fromorbit.com, amir73il@gmail.com,
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
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
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
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 44/47] dept: introduce APIs to set page usage and use
 subclasses_evt for the usage
Message-ID: <aR3WHf9QZ_dizNun@casper.infradead.org>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-45-byungchul@sk.com>
 <20251119105312.GA11582@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119105312.GA11582@system.software.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3175F2000B
X-Stat-Signature: 5tmtinnweb84amtm96q6dezeqgfw1tit
X-HE-Tag: 1763563090-606245
X-HE-Meta: U2FsdGVkX1/d9aJ48QxBOD9fjxfBKqrqIF2pR1hzN+wL7fvvmUnaxb99MBb/6Fmtj9MQmlk32EEhwhIiQFL2je6ORQY/DOTAE/cQzFQ3qBs9O/rWyT/PCzIr+lYVwOlWxRnoBCh58Hgf3kkEEEho1BsbqmViVTw5oNfcWev/UhNapA1i8AUgBEURmQdZq0AA9kDB3/3WqE0JyOdXP8AQE4xPQCAmGjF9rD6d8dzYQaJM7gOVKviqD0WasJYeHUF1e0bRwVR7VMQ90bHWc+y+WSugZk0H0tbgDodpVmKDo5bicDe9+IEUgYE6VJGPHDlV2rUvXNAnh10jRv5iv3epz10w/UD1AfKqAswLaSt7gP3GRkNBoRJv5195o8g+MAhBDx3MMHakGJCPKyl9Y9GR0C5IdBeP0gr/vsuSHKQhNtH06rtLZUnkgsCNwW+xkoFMrtBqnq/nzFwK7TRmbee0DGqfBN8X9nFdYgO3Ci7HJyEW7fJfDUWWQmV+qgL1ufYD37+utS+bivhkpisBiJ965GbhI/uZ6RASxBX+KEdRTUuJWXsmvgvoaKFqd832DvhKrfMMlhFFvR7UuWbl6UUckUqWfs3QneHqSCE28GDFHkA82k4rLdDemCHsQSjRdQtCRFR8oPjw2zOpeUOYicmHV93i2Y75rdFeeerWcfV/OCDEDALlRy3YXK4i078y6rWZY+pQ/Ft41TjCOSoIOYNT7W7zmDy0oXnaFl0+zanW4p/ADFJq5aQ/Nrkdn8Y+a225GFZa4Hp3Y4Qaj3c+LchX2uVub+pMMbb3xWjgjA6ivXRPXacVwHFI8TqJf3CddGyuWfcfqTDzBtNl65DBDgKqyXLtUK1IEVqU9GgJQuVFNp+Se04nTHEGfKhcbU9n3NSRKSg1cwkTzYTC5Gb2FO9ypqe+bMIHRLFE+DLfjhCvqGnMHRpc4g7AmtIMJ4kspWg7h0325FMJgce1eOp+WzC
 hqo3J5oC
 eFT9USA3Uz0Q7is1FTsw4wt64WoOemcYdpYEuEOPBR9OP6M+QVpKJwyQZHDoQnS/4hKzAJpYvfrfztFdefcuAFFdSt5NJR0LK4SMoQFGrrdFQkS/R2wKebmcjMuNr67OHpz2QzVaWqmagwMaAs7ZC8X2qeXm8/wkK5x+rS151QvpotaW5pY1N67AYZFk+G8xvCjNAiKJSQwTV2weWc/OqRZHV+wIAnH20JcYrhIc6R2e5nGf9waKYhpmU7PKo3UKZM+Zy5UNoc2rZpVFtnts2cXIoXGdFIvuhrDJtSFalvMPRGwaM9tJjuzM4wDmJh1jmOhcS6WlH3iIl6qtIDRuZyMBwLpKevcHcjIq/oFDeKCyqTyXGw79OIjU88+ngchez94W7f+f1MDZSQ8onq2f+zB6kBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 07:53:12PM +0900, Byungchul Park wrote:
> On Thu, Oct 02, 2025 at 05:12:44PM +0900, Byungchul Park wrote:
> > False positive reports have been observed since dept works with the
> > assumption that all the pages have the same dept class, but the class
> > should be split since the problematic call paths are different depending
> > on what the page is used for.
> > 
> > At least, ones in block device's address_space and ones in regular
> > file's address_space have exclusively different usages.
> > 
> > Thus, define usage candidates like:
> > 
> >    DEPT_PAGE_REGFILE_CACHE /* page in regular file's address_space */
> >    DEPT_PAGE_BDEV_CACHE    /* page in block device's address_space */
> >    DEPT_PAGE_DEFAULT       /* the others */
> 
> 1. I'd like to annotate a page to DEPT_PAGE_REGFILE_CACHE when the page
>    starts to be associated with a page cache for fs data.
> 
> 2. And I'd like to annotate a page to DEPT_PAGE_BDEV_CACHE when the page
>    starts to be associated with meta data of fs e.g. super block.
> 
> 3. Lastly, I'd like to reset the annotated value if any, that has been
>    set in the page, when the page ends the assoication with either page
>    cache or meta block of fs e.g. freeing the page.
> 
> Can anyone suggest good places in code for the annotation 1, 2, 3?  It'd
> be totally appreciated. :-)

I don't think it makes sense to track lock state in the page (nor
folio).  Partly bcause there's just so many of them, but also because
the locking rules don't really apply to individual folios so much as
they do to the mappings (or anon_vmas) that contain folios.

If you're looking to find deadlock scenarios, I think it makes more
sense to track all folio locks in a given mapping as the same lock
type rather than track each folio's lock status.

For example, let's suppose we did something like this in the
page fault path:

Look up and lock a folio (we need folios locked to insert them into
the page tables to avoid a race with truncate)
Try to allocate a page table
Go into reclaim, attempt to reclaim a folio from this mapping

We ought to detect that as a potential deadlock, regardless of which
folio in the mapping we attempt to reclaim.  So can we track folio
locking at the mapping/anon_vma level instead?

---

My current understanding of folio locking rules:

If you hold a lock on folio A, you can take a lock on folio B if:

1. A->mapping == B->mapping and A->index < B->index
   (for example writeback; we take locks on all folios to be written
    back in order)
2. !S_ISBLK(A->mapping->host) and S_ISBLK(B->mapping->host)
3. S_ISREG(A->mapping->host) and S_ISREG(B->mapping->host) with
   inode_lock() held on both and A->index < B->index
   (the remap_range code)


