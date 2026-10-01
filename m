Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E5BCA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED126B0088; Thu,  1 Oct 2026 04:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E306B008A; Thu,  1 Oct 2026 04:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DC56B008C; Thu,  1 Oct 2026 04:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC0DB6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:57:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69680120364
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:57:04 +0000 (UTC)
X-FDA: 85273452768.25.ED2AFFE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0893180002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:57:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DAaVkpx1;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790845022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGFfOloDVGt81WW7cFapo78BY0WCchVz36PTh0Khmm4=;
	b=nhTbO5L0zycuKhIbjyuoNSnXfK+9CgBWoPoDrrZ9tPredxnSHqFkvvxOLiBLOFkadnEpV3
	PctBQnZBWbJeV7MiRtvNw6Kgtuvu9+5UGs49le1SnaosZCMfOxGEo2iloZBOSxaX5oKhi9
	W6i0Fo0OekE6+qYMvhwE3Q9QP/ek+18=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DAaVkpx1;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790845022;
	b=R+p7/JjH8WNbnpAEn65AzD/UZbV4YKpNcgzGkg2+vrKuGoMsOG7jWLvvyir/4O1Rb0vNqd
	w9kgcBlJN9bKlDW0QMldNARknUtbVUOrnH35bAIY4QqoYYsOJyA1Edy06JYuOlgXFzlCpq
	Fhqo5jyJl3g3ZNnpYJP0zXdQ0yUzB0E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DFA9497;
	Thu,  1 Oct 2026 01:56:58 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D92233F85F;
	Thu,  1 Oct 2026 01:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790845021; bh=3zNTBTzTbpwHYWDK0XIAY+iSCQscCOuwOgZRECRF++g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DAaVkpx1/jOgpspHxz2Bcpp3BaIEEQQGiZpOP7Ft5D9MvVRn7yixwAw5nEn4Q1kRu
	 T5pUxEmM/GohIBxlkl+Tel3R5OJDpL1uoYfmIvOV38VA+o6xhEiVFK3Ms/MNt1mR2B
	 VoAAdBhD0HbDOtfA3qWgdzxbkmYebz5DXCV53miU=
Date: Thu, 1 Oct 2026 14:26:58 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Add KUNIT test for ptval_bytes_to_hex_str()
Message-ID: <uweoxvlup5ogme5m356uw4mzlfn32a3iqyme5mpsoun6qylh56@dmjvfbey6oqo>
References: <20260929120530.3394073-1-anshuman.khandual@arm.com>
 <2f7a38e0-1e85-4983-9bc5-adea49f44cbc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f7a38e0-1e85-4983-9bc5-adea49f44cbc@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0893180002
X-Stat-Signature: uw9iq53ref59ti18rn1maojh4jdpasky
X-Rspam-User: 
X-HE-Tag: 1790845022-588284
X-HE-Meta: U2FsdGVkX18uF1ThtGNKRTDofHPZV6jZ7FqEroy52Ug4UT6/RRlzkTO/WYI8rMDKwv/s2K5Tv8/ER113MVXRGcXDjrd/wLZR3L1JtGsosTClyTtSngP/vuvBbQBflvpWkjw3qfRFhmz5fdezfqEO1UDkEzpBPs0ItouB/53xc5Pj86lV4FjmSobRMun5mWfnTba9hA5ywgGaMxJpjrWv7T7NhLMMspRgIZelAYvzSGBKJ7/c3JTQuEu+AquJJWQrRtQGJLe25jAUHptUGZMkg4JQxFjK79Mdd4kc5gFrJiDpletGvEYCqLfeFC0jwG6mlagN0tPNNyMmejfZMB+mnABwGLilLElk+b5RJhvty5ZQS3vhBjem5oTlw4MUD7zYOAOdqoGNGvW7fe8nakyhcUbyLDJ0VYOzpnpSXTc9A0Y+YhFDGbd5ui8vWSN0Vwa0upFH1EeX/7cwtzIABOVQkH7z9D6UDBPeUv1L/eaeVfMHDZMmx2tw8Fs++aHsf+m7yuqGdSpwqpSOMj4Cwi/qVlaMeKhuz80YYdOSXQeUDV/4eUBPUAGvKP38Z0JRHmk9/mOJQQJuThZRckFYA2Rh7YdQ39+7FOmZCMfZkUTaSkkBd+4pL4BSyFex0IRnMFtQcwTv7Opp2clGqzn3uQfNftYfVsW4xucsa9gbU+q+aViqfAaqIU6Qpj0fwVYUNkVjSgSDbo5Vtsxfe1iJfLbBTG9hLNVlmo1EOrWMo1jX83YI9mXTK9Nw+TkA25tTsBVTLEfRMdeP1C+Na0tdJ7uc+AUQWgHVYTbiCi9plfQoJUHbE3NDm/TD9jhzMaR1mstAz9fV9tpST0r1aOPiJVqOmuJTalZILyZAT+SZVnIL1p/rDHsgeIfkc3t+3VPbPDmlMlKiiSMm4F66WdgBTJPRN1YyMZ7z/69auX4rAn8MWB0JBj/MJOiWREyZWz495uBdpjecpp+D49XaOJjOulu
 qZ4lNLOX
 kjYIekkS8qTBA1hYELqZdVXHzK2CmmFXbEaHdbUU2KOMOPCJ54rzx1a/9wtf+83gq/nabFIgy9Wh/ylf8Pj7L/aUVjdX+ZZvrdsmnKWMcRo7lvsuIMwOWY37x6qPgRdOfra4NnPKL4g1f99GkB5Z55ip362CAVhtQZ3eCasKOFDsXb/o4oRsN3d2zSskJjwD5Yj0pHbISmrMkv319+QaBvGt7NyYnB5rffc8skcy4v2IQy5G4vySRfiWvE2SR6n0qf+fF97t7ilefgOgqX6ktBfAj3EK1KJMhXIf5dQ4lckFcK8CqM+f2lExP/a8KSDXLYESiDfwwltcRfKJ0hkG2ah/Yo+0MLOqIw6jjtm2hYqPdkcR6RQPa+PNPaTYxKDtX8//0S2ogH5ftBfNn0F73takh5EC9KhH11LzgdseXN3pI8b7Ld2XEV/AQWThfVsr2MT1Tbc4orZttVRxt/sR0s+jTUOpOPvr3bvioLW+4OXOpnqarXByP+MVH0HiO2IMH8CtrBaMNDVZkRus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 09:45:01AM +0200, David Hildenbrand (Arm) wrote:
> On 9/29/26 14:05, Anshuman Khandual wrote:
> > Add KUnit tests for ptval_bytes_to_hex_str() to verify conversion of 32-bit
> > 64-bit, and 128-bit (when supported) page table entry values into printable
> > hexadecimal strings.
> > 
> > Add a new PTVAL_HEX_STR_KUNIT_TEST option to enable the tests.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> > This patch applies on v7.3-rc5 after the following series
> > 
> > https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/
> > 
> >  mm/Kconfig                        |  11 +++
> >  mm/Makefile                       |   1 +
> >  mm/tests/ptval_hex_string_kunit.c | 111 ++++++++++++++++++++++++++++++
> >  3 files changed, 123 insertions(+)
> >  create mode 100644 mm/tests/ptval_hex_string_kunit.c
> > 
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 604c58199acbf..f68bf26b98c83 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1511,6 +1511,17 @@ config LAZY_MMU_MODE_KUNIT_TEST
> >  
> >  	  If unsure, say N.
> >  
> > +config PTVAL_HEX_STR_KUNIT_TEST
> > +	bool "KUnit tests for pgtable entry string conversion" if !KUNIT_ALL_TESTS
> > +	depends on KUNIT
> > +	default KUNIT_ALL_TESTS
> > +	help
> > +	  Enable this option to check that ptval_bytes_to_hex_str() is able
> > +	  convert given pgtable entry value in bytes into hex strings which
> > +	  could be printed.
> > +
> > +	  If unsure, say N.
> 
> That's a bit fine grained :)
> 
> Could we somehow pack this under another existing / more generic test? We don't
> want one new test for every new function :)

Probably right. We don't need one test for each new function.

> 
> An alternative would be to use mm/debug_vm_pgtable.c to just run 3 tests at
> runtime as well.

Yes - that could work as well given its printing pgtable entries but
those tests would not be KUNIT based any more I guess. Although just
like the existing VM_WARN_ON() check, new tests should be sufficient.

> 
> > +
> >  source "mm/damon/Kconfig"
> >  
> >  endmenu
> > diff --git a/mm/Makefile b/mm/Makefile
> > index e7245cb88c665..d08b8bd01917b 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -147,4 +147,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
> >  obj-$(CONFIG_EXECMEM) += execmem.o
> >  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
> >  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> > +obj-$(CONFIG_PTVAL_HEX_STR_KUNIT_TEST) += tests/ptval_hex_string_kunit.o
> >  obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
> > diff --git a/mm/tests/ptval_hex_string_kunit.c b/mm/tests/ptval_hex_string_kunit.c
> > new file mode 100644
> > index 0000000000000..45c203cfb49ae
> > --- /dev/null
> > +++ b/mm/tests/ptval_hex_string_kunit.c
> > @@ -0,0 +1,111 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <kunit/test.h>
> > +#include <linux/pgtable.h>
> > +
> > +struct ptval_str {
> > +	u64 val;
> > +	const char *str;
> > +};
> > +
> > +static struct ptval_str ptval_u32_tests[] = {
> > +	{ .val = 0x1234abcd,	.str = "1234abcd"},
> 
> Isn't a single test like this enough. Why would we need the other ones?
> 
> So I think this could all get condensed quite a bit (including the test
> functions, a single one should be sufficient if we really only end up with 3 tests).

If we continue with KUNIT framework, probably all three tests are still
required to distingish them but in mm/debug_vm_pgatble.c based approach
a single test can combine all these tests via VM_WARN_ON().

> 
> -- 
> Cheers,
> 
> David

