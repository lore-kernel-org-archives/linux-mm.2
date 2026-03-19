Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6EC8108E1E2
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1390F6B0472; Thu, 19 Mar 2026 07:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E94E6B0474; Thu, 19 Mar 2026 07:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2026B0475; Thu, 19 Mar 2026 07:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA4D46B0472
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:03:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C3C21A04C4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:03:56 +0000 (UTC)
X-FDA: 84562527672.03.0554C2F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4102AA0003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:03:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773918233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YifErqMt+itpLBDIu2BIswknjpV1SuqoYtwD8GJqUn4=;
	b=cLXe6kG9kR9lFmSDBG9CBMHYEXsAo5fCXFIPvzutWq1V95SBkqk2IDR4nZVEn58iDk2xRx
	xWWp1WXEtVpnVs2cAeCV3gT0SP1LOQuX/NTHJKtsG223VdzKdLD5sIKuZjQjnjPlnwgCwp
	vZn3Iw7h1GpXbIredMhBQFVuQHJwGUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773918233; a=rsa-sha256;
	cv=none;
	b=CNUXId/rYrJir+CxtxhSqSXWLIIVaex78Tmo3vcyOg5N2w6MrqfpBbpeQNiweUVb/56pFh
	Q+0FyJgwQtOat+4jb5qk632MaSK1/FY2sgcwtGYhs6JX6poIn4kC2tdxDkQgUdX9Aw8qG4
	GfgHRM0Io77yO+66SLxLRgvyB97XR5w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc2py5dyzzJ46Dn;
	Thu, 19 Mar 2026 19:02:50 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A71A40086;
	Thu, 19 Mar 2026 19:03:50 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 11:03:48 +0000
Date: Thu, 19 Mar 2026 11:03:46 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, "WANG
 Xuerui" <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens
	<hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
	<agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, "Thomas Gleixner" <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
	<ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan
	<ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams
	<clrkwllms@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
	<linux-arm-kernel@lists.infradead.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH 0/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE and
 cleanup CONFIG_MIGRATION
Message-ID: <20260319110346.000034a5@huawei.com>
In-Reply-To: <20260319-config_migration-v1-0-42270124966f@kernel.org>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4102AA0003
X-Stat-Signature: npannwagbsr9wkasrwh9y1k4qrx1umbk
X-HE-Tag: 1773918233-983355
X-HE-Meta: U2FsdGVkX18KtdKo4ZKGDgd2KPSpi7JQjVpAloIXGEdy26eOzwsXK6anzXr+a9ttoENfDYMaj+imadrvLe03xg3pbXwmsVHLSoxYmGomXBWBGkmxifm5qaWfnsyJmezRw8hnkHeIlvY7oJP7VNMGXdyFzvHiqK6OuObKQbUPosN7HcVRv0d6ujq5DYXBsS3nAbBIgdpO+f/Peretd5PjOI3A5dWvQLCPRbe9SDqRgRAYQeXvlAtuzci4iE4IyoDHAZS3+gfR48WeHatAwPescBOmPEvxlRn9yeCT5Sgy8F5aMEd6LgHFJtZRLm8Y4oiTc2b2LNXrWa6d3hApcbm539tyEPZAd0q3fkWKeJomPVjkZm2H16edkx1ZKjOy0PqicWE9bcNJ707t/ICB9pmuPg3F/1+hFI4i7gwdV6YX3iPY0jq1pPA2xGPTLX+en3/5d/27IluyjEy+sV7FOo8MWYq7slCOoW3uSnrwN/Qij3FcGgA7FjwQ+nPpXCnsvki3uoE143eqIxrx2+X4BmdJlG+wYnSU79NljFMWvHk04TnHoxKOceI9xaME3gZ+2IMxFPEHsC4Sw1JeKPbXP7KGR+09O+jduuDEHJCcTk9yw54zzOfKlVhqpaBuHvWxe+NJnsI/XYUaOjW4UzRN5q1b+yKHvSr7DJ9FD4NWeVs230EM8WYDT1pedVn6CNK8phv9gQSrSRgAWe6PmeW1bs0JxhMnIrofcU2yq6/vbTmu729Ymw+Id1QIc3z7AKVj9wO3qadwjSZ6Mbunjv/06P3sfPkNDzovTTQZz0Zo1ukPfvMI8lOkNBaDK/tU8Rm44z9J03fIzDaO7WbhykxQPF9NrqvOqkoIdN3Gc1rpTRQIpkkwOG2Zm+AwsMizV7q563UNFcRXzXCsV/JeC734qBR+7w/b3BUzMDjFJA3ucyBnmsxqJ6i3hyUhUNUVE2UvR/ShPQalLvEN+kCBd1nT5nh
 zY06gviv
 P6VxjR2nrqtW6LjUsg7ezUrEs6LjidB6qvS/lO1ie8pko0cRAdEHT1vmgsKh1bkwxUd3nCMCRwQrhVyrtM11JKzmzDyCNbU0ViR8D+iR/sZ7hgYruDM/ROJ3B4Njags4J1T8Lu11aAEXtdz6ra6noy+A4TYcPjHayfXgz+TXG1ryMS5Qzc8q2RwxCiTDOikKscW5utLhjS/NEBlsErTf2B+6yXZSnBoBv1PCbQ6KfCy3EfRVaZacdrOH3bYSe2j7+IvqLe85Av6NB+97Ejs9stmDaeFGxm4ZAOhdS2/V5mAUHt+RtgYnf5citDecPoPPWlD20ds+EFuULcEw64IfDONj5y4mhKAGC4YFELLfqF8iUth7iN+p0xYkvMQbo3V4DGmLZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 09:19:39 +0100
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> While working on memory hotplug code cleanups, I realized that
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE is not really required anymore.
> 
> Changing that revealed some rather nasty looking CONFIG_MIGRATION
> handling.
> 
> Let's clean that up by introducing a dedicated CONFIG_NUMA_MIGRATION
> option and reducing the dependencies that CONFIG_MIGRATION has.
> 
> Heavily cross compiled. I assume these changes are fine, but messing
> with kconfig sometimes feels like playing with fire :)
Seems fine to me, but I agree it always feels a bit like playing with fire.
So more eyes good!

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (2):
>       mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
>       mm: introduce CONFIG_NUMA_MIGRATION and simplify CONFIG_MIGRATION
> 
>  arch/arm64/Kconfig           |  1 -
>  arch/loongarch/Kconfig       |  1 -
>  arch/powerpc/Kconfig         |  1 -
>  arch/riscv/Kconfig           |  1 -
>  arch/s390/Kconfig            |  1 -
>  arch/x86/Kconfig             |  1 -
>  include/linux/memory-tiers.h |  2 +-
>  init/Kconfig                 |  2 +-
>  mm/Kconfig                   | 33 +++++++++++++++------------------
>  mm/memory-tiers.c            | 12 ++++++------
>  mm/mempolicy.c               |  2 +-
>  mm/migrate.c                 |  5 ++---
>  12 files changed, 26 insertions(+), 36 deletions(-)
> ---
> base-commit: fbf55982f31ae6aa11f890c36bccc130ce70a312
> change-id: 20260317-config_migration-463e20400499
> 
> Best regards,


