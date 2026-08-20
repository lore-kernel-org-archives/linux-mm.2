Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C72D2C5DF8C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 21:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D42C6B009D; Thu, 20 Aug 2026 17:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ACD16B009F; Thu, 20 Aug 2026 17:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E86B6B00A0; Thu, 20 Aug 2026 17:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3926B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:27:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 914A21A02E2
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:27:03 +0000 (UTC)
X-FDA: 85122933126.24.D283445
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2DC3A0008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:27:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QPDSeuHD;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787261222;
	b=G038H+EJK0fAAegAfr4XNWy0TM0Rm1DrAXR/bjSCYUWNxq7MpxsBJ6fhoc8vjafnjoC5ae
	rBwfAVnYHX3LM/s++Bm9xWxdGp/Rp/ZQC86wmgt87B7f72Q7H0iXRSX/4HaoDN0lCUQC5u
	MpAA6iDMzCtMI054oFXZl+cYEzAiokg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QPDSeuHD;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787261222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aivq/JVDPV6r7/a16PkDK/xY2W+gTID787MQ1A2/bQ=;
	b=KgXWKzB1KNSV+FEG1p1bGztt8dtBbb7ItqMky3CWfz0s+4otoSTnnzHaVFVBUZnuJiceBv
	OgAzakKqFA4MIq7Qu4WgyhwoVzL2TP2Vv+d/XnCKx46ELOmLPPVoy+9hYhHgnSwhauk0hv
	FBduWcLwx5n+vuZ06DvOZ13297+3E8g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A757B202C;
	Thu, 20 Aug 2026 14:26:56 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D49923F763;
	Thu, 20 Aug 2026 14:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787261220; bh=GtZxJZ2uVfeF4rlVw6qybAWaJ/Pn2JPxWEnBFkpsqmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QPDSeuHDSrpGU507oYLegehgj1gVzJa8qOPnvmiKgIYmXPt19bsNUNsaC8wFNCiSP
	 8ZvE88/GUEvv2MoMtV/TDPEfU77YEZm9CSQK7bb/PW21YKcHmSjBlZ4G2w3sNuhR2u
	 warTFMqvZUikr8QuZG1iiiMQ8sz/zHEhMhBJUpog=
Date: Thu, 20 Aug 2026 22:26:55 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps for
 check_huge_xxx() helper
Message-ID: <aodxH5Qc6_zVay-M@e129823.arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
 <DKU1AFIKNMNE.2A0JUVSTKHHLC@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DKU1AFIKNMNE.2A0JUVSTKHHLC@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C2DC3A0008
X-Stat-Signature: s66543cs9aj1in9akxeuu7emsiwnsmtx
X-HE-Tag: 1787261221-213617
X-HE-Meta: U2FsdGVkX19ybr1RCp7L5o+iUKfK6FnwXKikKI+XG3KlbVzMy42d+QVG5UUngUPZvrG8IhBIAcxMdSP8x5zZ5BJpSb/94mH/1myMGJF2Fv1QwTrrKyCojkiXvUX9bdYKpejYwmV7KCmTFSFGVfR5CGZhNz7nuPI5t6n1KXRs6NLSqcowF/2bKlL3EVSGewq/dgCXctRCMQBQShXD1vpSc0DP8h9jb4/Bm3fEeKQ1KjIf0NLq0iELg3kYlc5/bTgfgSgWQOkuqpYHsjjSgX5dzs29Ln8Hl9/FlNTWpiPFd/d2Aph9GFxcNtUQVc0TPb/NWZKlbiyNWtaJ4z6VLM6+u5mtNJucy9kuxNsbSF2CVo/1nk9Lixs4wkecI7YpVlH3v8iI6ihJ96OuuE59uauj4Vxe2B0rRlvnjLLczTaPaFmS+8LGNTTdBBm6qSRqoUHekSnoGob0SvNEg03yWsi7OIgdEirquqdANboPKchHACnozYPBBrnHu0cDA1avWKN6rO24UdnX//v++hEp3v2jfv5LYzt6btBY12OIYu3NQdjhAmzDPi2Lbxqpu9Q4KSqJCGCzNQcitXcFjKYkbF/Z/jb5yUanvBya7qg5NcsKCrWqqNya/HVKUDhsvLnxgvWIKTOVWDe+GnQJIuRnUJaCLqwubLrTNuktJGbQ0a3fP+uAnV6MKcheLdeSs4xMNH/rnssqOVIU4T+iF0/j0nohAfgpaodTxhxv0EzcsMP426KWB6O7zVcO9CmvUGLEFWld+c2iPrc1vnmkPwji7U+HUlJicg197sBx1cgfGQm/SR5kNETYq/3lOIXiGDeQAYFBm67dgLemMyBWDc+fPSNrjAFXkJqBvf9+4k6g1py4asvoul1ftByNU+ItNUqHgmmMhNXjIf29vkezJE28qX00mGryk3cSS1va7LL/LF6flJ07l5v6TZwrppUF5b9aybn1JrWK9oDcp6hxyYR511i
 lNSgl3gh
 nTopGsTt30lFs7Dkm9HzZwJtT8b9M1hCMMMQ1KYlu5tQkw3evuLyFsAeJnFPCVB904u3ZtGrEmhfu1KRar2Juj0158jzCRtDHu+3V3/zlGLjde2b3szYFEi0PpR2I66ubD5mg2/mcqFMZ8j5a46+JgDT/AVg+kcH4/8WjgBQiUoWzxZseeX38TagA3Ul3PQxWbefoBz3LzEF4z8I+BL/jvA4jIYHXc7uB+u+Z9HLA3UNesLVLsG7AL7pRadMqjLr4Ol3YwVr0JvbsZtBTjcPKjq7cizPDxJRj9fhsYgz3d9ueo2yzU/HUfNwBt2Jun4NB5yODDGYux1Sp7OfJReoMXKta8a2yhMTy52isA5FdEOcRCKOu6vBQz/zUCzcE5uShlSVbJ+anLVHeV+u8KqbYWZbY+8nwablhHZKt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > made by memalign().
> >
> > The underlying VMA may start at a different address from the aligned
> > address returned by memalign(). Furthermore, a subsequent
> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > already set.
> >
> > This causes split_huge_page_test to fail because the check_huge_xxx()
> > helpers incorrectly require the address returned by memalign() to
> > match the VMA start address reported in /proc/self/smaps.
> >
> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > /proc/self/smaps to detect huge pages and change the meaning of
> > check_huge_xxx()'s nr_hpages argument:
> 
> Have you checked Baolin's patches[1] in mm-new? They resue
> gather_after_split_folio_orders() to reimplement check_huge_xxx(), also
> based on pagemap and kpageflags. Does it fix the issue?
> 
> [1] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linux.alibaba.com/
>

Unfortunately, No. since __check_pmd_huge() in check_huge_xxx() still use
/proc/self/smaps [1] for pmd THP, it still has problem though ths patch
series applied.

[1] https://lore.kernel.org/all/56b16691f605426b33b5cf47319233de6127a6b3.1785985999.git.baolin.wang@linux.alibaba.com/


> >
> >   - nr_hpages > 0: check all of pages in the range are huge page.
> >   - nr_hpages < 0: check all of pages in the range are not huge page.
> >   - nr_hpages == 0: invalid.
> >
> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/khugepaged.c           |  26 ++---
> >  tools/testing/selftests/mm/split_huge_page_test.c |   6 +-
> >  tools/testing/selftests/mm/vm_util.c              | 135 ++++++++++++++++++----
> >  tools/testing/selftests/mm/vm_util.h              |   1 +
> >  4 files changed, 131 insertions(+), 37 deletions(-)
> >
> 
> 
> -- 
> Best Regards,
> Yan, Zi
> 

-- 
Sincerely,
Yeoreum Yun

