Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F2AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6787D6B009F; Tue,  7 Jul 2026 09:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650596B00A0; Tue,  7 Jul 2026 09:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58DF86B00A1; Tue,  7 Jul 2026 09:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDED6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:36:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6433167593
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:36:24 +0000 (UTC)
X-FDA: 84962079888.18.DA3EEB5
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id C41031C000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:36:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kzUQhfS+;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CeqnHolqvupennIplS/D4Qb+nQEYOXtCZ3+bQBmewjM=;
	b=cJyYH9wX2UWUlCMXBUnv4j2uOi+bJnh/ZTU6wws1RDWrkIHrVbTOkmcWn9mKtv31v2n0Dl
	yqaYl68x9cIfxaRHbkuTu/IBwnPoVh7kiKWDeSC4FuYUHKrb64EPSfvyRMa5jNTpA7lX3h
	nFr8/vWy48x8lwBR/Q9LYnVd1mlChTY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kzUQhfS+;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431383;
	b=zguH53hE5lRNPw0elqas52A1ZSFNr3N1FCKph7ynujcMvMbQNivwqZ5Ydac3aQEE0ZGrKh
	uzNCmsICocI4hfXJ5kQzwzkNtfV5i3cc+sjzoIPIw4EEkk0mTBiQs/RxoAv1AyRo2fQVJo
	low+b9QAYZSrrHH1JvQtp/p0SIVJJZA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CeqnHolqvupennIplS/D4Qb+nQEYOXtCZ3+bQBmewjM=;
	b=kzUQhfS+Yha6KTVB71IH4oQNliXnuHIxjb7QbikBcuJQ1e90X15E/8xiPk9OHFFsYPVpMTRh8
	vwqru0MUTzMLyOyMlOfSid/mVaEO6idW5xcCgADL+S6r5bkZFGn58cmJejv9vvIXulBD/i0FSqL
	/uagqyWiR+QnE6LFO11sPY4=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gvhpZ2DPDzLlTZ;
	Tue,  7 Jul 2026 21:27:02 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id CE7D0402AB;
	Tue,  7 Jul 2026 21:36:15 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 7 Jul 2026 21:36:15 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <linusw@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux@armlinux.org.uk>, <mhocko@suse.com>,
	<rppt@kernel.org>, <sunnanyong@huawei.com>, <surenb@google.com>,
	<vbabka@kernel.org>, <xieyuanbin1@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault() under CONFIG_DEBUG_USER
Date: Tue, 7 Jul 2026 21:35:27 +0800
Message-ID: <20260707133527.81833-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <akzgsZi6aKCFWg_U@lucifer>
References: <akzgsZi6aKCFWg_U@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C41031C000D
X-Stat-Signature: wa5scafmrnz7em93pb5kfw4ij16b9ikb
X-Rspam-User: 
X-HE-Tag: 1783431381-983430
X-HE-Meta: U2FsdGVkX1/s/k+LY/0BorYLGXmu9Ael/gQy4QSUHFYGekqVdjLl2vEWNwLyWZRaeq4KLCRZZn71EckVqiCFPTo2myG69DB0h73qXdbmzT/V8gKEVl7AgqKv2xkz+pQEzRevETcKgpIB7nr8ahb+TchS3lCzEillh8b6pbnaqqrZXLaGfpIcwau8pAF+ILbKNYPVZ8FzsRRCqn8MNSDDyhK3llNAuNqvCFmNMKc8bOhiPYqYcQSL/5yCi37KEV7vMLI1d2hif7aT1b1YShP5qt90uBVCVWnLdKBxYo3NCkHhJ9TVaXk8IzsM5Ls7uw8VJtvLFAC0GqhmUQhittVxOlGR1/7XHCme+c0HxSGjuQlPvOw1c9N7kHEvFP225BajF2hZB4KI50/3wG+E4HK8BQscnJibpMk3ORiBfGKt1p/nvjOQcoIz3DCkqYFexosO4/1p54jKnGMuwgMH+WSKtMsUmMcEs3lMej9fFD4qZBfpfeu3V9iipzCvAk8eZdSfc2ThzLvzy+ihuO6TfQHx+ivmI5EI+Ux1lgJVY56YUsCfdMEv9X9BGbgDsXwpJw/YqtYlRndpwZhx9nwCjzD2bMae1h0nSIYaTwwoXSHwZEQWt2OMBnzBkwSaZ2n3cw1n4soEjTOJchDDZ7B+NlCzqGCnXoYGcG1hlZAPOP7zhkKQWeiUTQlHiMXyPyWtHpTPVJSOTLHF3Ge80s46TF8FKZ/BrQ/wfjkceX17YOP2thwVg8zOO5sQVGuImpG2bfI63CxqMbVjxYYsovhMSwnnF/pm4Q2JRwEiD+yvzi7+ax7klycQJ9aIufHuqKubFjPDzrKJT8pYnqEt6asomDVVyp2b2weQOin+RIFqXjskMcfGRgDQO0CfDiTxIHuAbFcw1VA8ldtozHQ5l7i3BpWDDpMLDLlF+w/DiO6C0JbOkul7sBYyHtMRtkv0VFtYv6tVvXtuNU6UAgfpJbS3heQ
 7vOkekhj
 Q0WUz2b8sLv4rFrsATwEkyR1FRv/dECc6Dji8Md1AqQOexIadL9y9YTdqy/HTFF+jidQKCogk558lQllB7bw3U+/x8ORKy33UmRhHnpAk3FzEMT7btDdW32GeoIItSXjM3fPrsXNROIquE6/5ob2mieopRcovU/GHDMVUlm6GRGHOtPCX8VnWmCVMIsn80apT/yCR4HE18m2MBPyJylewzl86wU5sgMB6Giks+wdVkXQZixXfSSwamV5OjlvFe07FN2TzhKHDxmldSzzT+1EnFYTHMa3MClWKRUOrWQGAf3omFvTB0K8IK6HQyd0TZ3lGN6uh/0AsSfUPRFYHh0czo8AQ8dLBIDrEs2rGN9lcyiE/Elk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 13:46:19 +0100, Lorenzo Stoakes wrote:
> On Mon, Jul 06, 2026 at 09:32:47PM +0800, Xie Yuanbin wrote:
>> I have read this article:
>> Link: https://docs.kernel.org/mm/process_addrs.html
>> `mmap_read_lock(&init_mm)` should be able to ensure that the kernel
>> address's page tables can be traversed. But I'm not quite sure if
>
> I added a section specifically about this -
>
> https://docs.kernel.org/mm/process_addrs.html#traversing-non-vma-page-tables
>
> But note:
>
> "Since, aside from vmalloc and memory hot plug, kernel page tables are not torn
> down all that often - this usually suffices, however any caller of this
> functionality must ensure that any additionally required locks are acquired in
> advance."
>
> With the latter part being particularly important - you really need to be sure
> you aren't going to be raced on page table teardown by anything.
>
> However:
>
> 	* You're safe from vmalloc trying to install a huge page table (only way
>	  it removes intermediate page tables) since !HAVE_ARCH_HUGE_VMAP.
>
>	* And since arm32 !ARCH_ENABLE_MEMORY_HOTPLUG you're safe from that too
>          :)
>
> (Really I think you should be using walk_page_range_debug() here ultimately but
> that's a future refactor).
>
> BUT see below:
>
>> `mmap_read_lock(&current->mm)` provides protection for user-space non-VMA
>> addresses?
>
> OK so this _does_ need addressing, and I covered it in the document:
>
>	We also permit a truly unusual case is the traversal of non-VMA ranges
>	in userland ranges, as provided for by walk_page_range_debug().
>
>	We must take great care in this case, as the munmap() implementation
>	detaches VMAs under an mmap write lock before tearing down page tables
>	under a downgraded mmap read lock.
>
>	This means such an operation could race with this, and thus an mmap
>	write lock is required.
>
> I.e. you need a write lock.

Thank you very much for your reply. Now I fully understand: to traverse
the page tables of non-VMA addr in user address space, the mmap write
lock is required.

But I still want like to ask a question:
> However:
>
> 	* You're safe from vmalloc trying to install a huge page table (only way
> 	  it removes intermediate page tables) since !HAVE_ARCH_HUGE_VMAP.
>
>	* And since arm32 !ARCH_ENABLE_MEMORY_HOTPLUG you're safe from that too
>          :)

If (just hypothetically), the ARM32 architecture supports huge pages
and memory hotplug, what kind of lock do I need to safely traverse the
page tables of non-VMA addr in kernel space?

Thanks again.

