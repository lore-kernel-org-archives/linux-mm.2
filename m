Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9E1CD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 03:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38706B008A; Wed,  3 Jun 2026 23:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8BD6B008C; Wed,  3 Jun 2026 23:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0596B0092; Wed,  3 Jun 2026 23:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 837316B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:11:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E2771A04EC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:11:00 +0000 (UTC)
X-FDA: 84840753480.01.8D83806
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf05.hostedemail.com (Postfix) with ESMTP id 086EB100003
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:10:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780542658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3GQ0+2aJZj9B7sWkIO2tuyK/dPU/1gz1VXQ9fI4xIH4=;
	b=eP7rmytuk0bpHKNce0V7Cq+fqOQ4OVNsWJT4jkwz6xd9sqpTZix7/DO4F623EJC2SYSiWC
	nb4lNpVAtPNy2ucuMhwI9y1MVIbG0jEThaTziETp2PlDdH7L4LAd3mFsF0SZ1cXOVaP6sj
	wB57xpzyGsUZ32hXCBF2VxUXdPdhkng=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780542658;
	b=s/9uimqu8j18e2xMAlgvsHC/xlX7sM0d6Qi+jGvvOP5cjDeT19Xyg13wlN8DoGLCY2fkYE
	sSf7T7kUzU7+DZuKFd8nXU7Uk1OFkkrkHFI0vCsV4u8NDNMeDcyWDVYJxEWKa+uz/aHVQn
	ND7YPECFYQZRr9/u9TJuJ9FhNzgflqs=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gW8hh3Vhyz52SFw;
	Thu, 04 Jun 2026 11:10:44 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6543AYsC051407;
	Thu, 4 Jun 2026 11:10:34 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 4 Jun 2026 11:10:35 +0800 (CST)
X-Zmail-TransId: 2afb6a20ecab4ed-9e08f
X-Mailer: Zmail v1.0
Message-ID: <20260604111035154Lk-9ZgwKY4Nlk4zz30U1t@zte.com.cn>
In-Reply-To: <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
References: 20260527110147.17815-1-tao.wangtao@honor.com,70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org
Date: Thu, 4 Jun 2026 11:10:35 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <tao.wangtao@honor.com>
Cc: <tao.wangtao@honor.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <akpm@linux-foundation.org>, <willy@infradead.org>, <sj@kernel.org>,
        <kees@kernel.org>, <luizcap@redhat.com>,
        <zhangjiao2@cmss.chinamobile.com>, <kas@kernel.org>, <ljs@kernel.org>,
        <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
        <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
        <jack@suse.cz>, <riel@surriel.com>, <harry@kernel.org>,
        <jannh@google.com>, <jgg@ziepe.ca>, <jhubbard@nvidia.com>,
        <peterx@redhat.com>, <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
        <npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
        <baohua@kernel.org>, <lance.yang@linux.dev>,
        <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
        <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
        <rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <pfalcato@suse.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <damon@lists.linux.dev>,
        <shakeel.butt@linux.dev>, <ryncsn@gmail.com>, <dvander@google.com>,
        <wangzicheng@honor.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwLzE1XSBtbTogaW50cm9kdWNlIEFOT05fVk1BX0xBWlkgZm9yIGRlZmVycmVkIGFub25fdm1hIGNyZWF0aW9u?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6543AYsC051407
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 04 Jun 2026 11:10:44 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A20ECB4.000/4gW8hh3Vhyz52SFw
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gn5jifteapq9a3fdxoqjcosqifoc1r8o
X-Rspamd-Queue-Id: 086EB100003
X-HE-Tag: 1780542656-203464
X-HE-Meta: U2FsdGVkX19Z4a1IwsGNe7djXwNhfMR08CcOuwbiZJvpHwQTfTsvtHF+ECOg9+0ofDCUS6/sp5+kKubhwFxsOSzb7h7OgwK4sWr0bJf3PlIX/hyiBrAArCuL+suDYSPpXxoeyqDM3wW9zvSdrHuAl5CvUKaIEwbIwaHHiRjgMPFwTbh4JSYWQHukTWqbHeKXcLUn2nl7a2W9QhRj4JWx2WhyXtSRD/2/NCAZel4tWqlSRgXLH/mGozWbzTuDDz60bqorunD4IKzHyDLmoIKtPiaKsg++C+mnWhHXJnB/FASO4yMVrrxWVDNKYH7EHkZHQa2jnTnNWjyOYCfOMt/WiIknTRzVMPbp7uK3fUj8DyBkONjyBPfOmqQJz0uMQ1J8lFjAgnOL4+qbYLcDbyGBXJgSZ52MqH5dfNQuy6UpWwaFEMLynxw7VX8zebvIBsp75Jq9ZjKzJf/CAsdPaEpmhr/a2L2YnRJUaz2/aTvwg4LhF02lzZEkDbOBj4eRCqB2ekxW8KDMdo51+MqN5WY9UBO8eTLH9F3Pac5rAOYPfvdDwD6qP4+M38SbMrwznZ9heJJ+uTS3W7w08wFwiLRCYLoW/4WTJS9HeLp7PLvHVYdlFmArlFGIoA0zrC8e+EpiTLa1pMWkTy9sr1aue3XlNZmfKpmCHvFv/pV/No09WTwdkZqrXm0tjA2yFcANrjmRVzCFcoQIGXmMIhnTBsSu/woXRsWShOBze3Rhx7S4Zt2ZvV4ymJaMy+w2WJ2JYdJzicVnahIn6pVeT04hkjBU6ArLgbHgFVi+7DmxUPTQ9BNz7nZh6tuvybglkpYPjzDeLGZHZqZGjHrZaVbbeaeGo+6BB6UB0Unw+HIlFA6NOoU+iKJBDsDlENxw45a35efjQkr5j4ct+LpocvYTrkZ9OhgkQJ680H93965zCYIL8Le3F5WmHG/j9PXAXl6379+WgfvdayzSQ/oIL5jP+5n
 T4IBTe9l
 62812p3o1v/RFJiY8p5CKJmXlAzifi6W6suBCeq7d1niD7i8jy1q4huG1IiAwlkONfuGJza7BHcVKm/tyTFKZWfc5ev8acAIJp6NAsPaTS7ielNd7LP119Q6vCCVOk/NzOwvKF396o2Z0UNIq1pNkls0HeOFdZdVvoQQ6QArl6qUr+SEU+bwe+UNcJNXAZIDWOTyzJEkTY46U4T4XeOf2LizQaiI5Z/7a1tiEeM/eGIGFonoZwwBrPTQ3nnky+L+OQZFFGQSI89B443SmmfCaBseAhxKET9DKRNA3Xt4DkhLT2m774DUagNdGvUM+4lLufHALNWV1f6h1xg7XfwIAYESKSJrv4sSjrY9O8oGnyKUx5cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > 
> >  arch/arm64/Kconfig         |   1 +
> >  arch/x86/Kconfig           |   1 +
> >  fs/proc/page.c             |   6 +-
> >  include/linux/mm.h         |  38 ++
> >  include/linux/mm_types.h   |   9 +-
> >  include/linux/page-flags.h |  34 +-
> >  include/linux/pagemap.h    |   2 +-
> >  include/linux/rmap.h       | 165 ++++++++-
> >  mm/Kconfig                 |  22 ++
> >  mm/damon/ops-common.c      |   4 +-
> >  mm/debug.c                 |   2 +-
> >  mm/debug_vm_pgtable.c      |   2 +-
> >  mm/gup.c                   |   6 +-
> >  mm/huge_memory.c           |  16 +-
> >  mm/internal.h              | 171 +++++++++
> >  mm/khugepaged.c            |  13 +-
> >  mm/ksm.c                   |  43 ++-
> >  mm/memory-failure.c        |  11 +-
> >  mm/memory.c                |  19 +-
> >  mm/migrate.c               | 126 ++++---
> >  mm/mmap.c                  |  15 +-
> >  mm/mremap.c                |   4 +-
> >  mm/page_idle.c             |   2 +-
> >  mm/rmap.c                  | 690 ++++++++++++++++++++++++++++++++++---
> >  mm/vma.c                   |  76 ++--
> >  mm/vma.h                   |   4 +-
> >  mm/vma_exec.c              |   2 +-
> >  mm/vma_init.c              |   1 +
> >  28 files changed, 1279 insertions(+), 206 deletions(-)
> 
> Hi!
> 
> When I saw the diffsat I was concerned. Going through the patches made me ...
> more concerned :)
> 
> This is a lot of complexity. On top of something that is already so complicated
> that I fail to grasp most details without regularly taking a look at the nice
> figures Lorenzo created recently.
> 
> For example, I read above "since child VMAs do not need to allocate anon_vma"
> and wondered how that could be part of something that is just done lazily. Then
> I had to learn in the patches that there is some additional "Child VMAs
> are created as ANON_VMA_TREE_PARENT and do not allocate anon_vma" -- excuse me,
> what? :)
> 
> Reading about VMA refcounts made me shiver. Reading "Holding only
> folio_lock(folio) cannot guarantee that the split
> operation completes atomically." confused me. Learning that we have to invent
> interesting ways to make page migration mutually exclusive to free_pgtables()
> concerned me. Figuring out that there are arch-specific config options and
> runtime toggles is a clear warning sign.
> 
> Seeing test_folio_unmapped() was funny, though (why?! :)).
> 
> I think this patch set has a noble goal of reducing anon_vma overhead when anon
> pages are not shared during fork. However, using anon_vma for them actually
> makes the overall implementation (e.g., rmap walks, locking) more consistent and
> simpler.
> 
> Even if we could be convinced that most of this here is correct, how should we
> reasonably maintain this increasing level of complexity here?

Indeed, it's very complex, but having the changes of 15 patches scattered across
various subsystems is really frustrating for reviewers. It took me a whole day to
read through the entire patch set, which made an already complicated matter even
more complex (maintaining such complex code in the future will be a pain).

However, overall, I think the original intention behind Tao's patch is innovative
and valuable, and Tao could definitely make this patch set simpler and more
readable, because the core changes actually start from PATCH 10.

I believe that if Tao had done the following, things might have gone better and easier
for reviewing. In fact, I understand the motivation behind the patch is quite simple
at its core (just wanting to avoid allocating the anon_vma structure when a VMA hasn't
been truly forked, and instead put the VMA information directly into folio->mapping):

1) You could actually simplify your patch significantly — without adding a lot of wrappers
and helper functions that introduce extra review overhead — and keep only the most essential elements.

2) Provide complete test code (in tools/testing/selftest) that covers the affected functionality,
such as VMA, huge pages, KSM, etc.

3) Use the RFC tag to start a discussion.


I would be very glad to see if Tao could post a simpler v2 version that does not alter the rmap
core data structures too much and does not introduce excessive complexity, no matter whether
it can be merged finaly.

