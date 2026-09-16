Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59B5C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 07:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F71E6B0092; Wed, 16 Sep 2026 03:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7296B0093; Wed, 16 Sep 2026 03:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495DE6B009B; Wed, 16 Sep 2026 03:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4496B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:07:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06111805E5
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:07:01 +0000 (UTC)
X-FDA: 85218743442.10.C96909C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0A3DC0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:06:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bU8VbXfk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789542419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9x/SI9lzMazRKT1jOXiFAsVL8v8pO+gIgyfwCxXS3Q4=;
	b=ofazgMc1QWwSZqto6adRZp48q/yXVZBNjyPzTNVRTXGhVo6PPEz6zbwOWWpxG9/4k7Xsal
	UoQUyW2O2Ixb/y1X9BSPzyC6liEpSlQazBvQzF2KkIL++jY/h/ZiNLnO7UGo23aI5Nkapd
	P5Gx0Ajh0EWGSjwKsUZs8yyMxSXOIfw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789542419;
	b=E6mwALujnUaF+i69JVNgyELhwvq465T7inzIhjAhjKDX2vBNMBpmVINLHNFHS9WBudIrce
	BdEJc68foF3yy650vSFS5oZmpzEIM0E7MwLgVZf7qs5XxdjDubTaUKI474u4wc6OQjPqwz
	pLp+aqg2gh3/XK/uJLEq1YswBwlIyWU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bU8VbXfk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E0A0152B;
	Wed, 16 Sep 2026 00:06:54 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 995AF3F86F;
	Wed, 16 Sep 2026 00:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789542417; bh=7j41/pbsi2hh7BzOK/zlBjo5ceENRET+9FnTWgUaeYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bU8VbXfkKaKwuh6T7BWjvzIFRNk1/Mkj14bNCbgP3EMRPQntwVb6eQyRKr/RtoJHR
	 nZXlP4iJoqERz7vC2vDX7Bun0jQtSF23uJZpSIC4RlnrRLdm33e9UUX8fC63WvUnhI
	 2Wt5RYyChyWHtUQWRzRHrQCFtqWRQD1Q+BwMeRUM=
Date: Wed, 16 Sep 2026 08:06:52 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
Message-ID: <aqpADFi-qa4990ZD@e129823.arm.com>
References: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
 <db48325a-6eea-4924-916e-5da06bd31e47@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db48325a-6eea-4924-916e-5da06bd31e47@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0A3DC0003
X-Stat-Signature: 4xoxqsrwe8ompzzsoo1ayairdbxwemqu
X-HE-Tag: 1789542418-28702
X-HE-Meta: U2FsdGVkX1+CJfVjYj7Bsh2cm4dHO6NZedlZgRJ1250nXhEsPz3l/p946wNrKk93hFLs0WJV6OfWaeWFa5SxUpva9Mm1wNV7latHXOVsvdlXc8CF4Gi1jBK7B1ETup4JEBmUJcelX+uV9JeDwoNXZc5K9dKx5shwLDnih5pSzX7hO9XTfOyLZn07Ih7wqCPfn3Io6OjGeCWZdbHCLHkBbjU/Ccmvd9NRgUCkoE4BWc1iie4CGT+eJ+Bm7tHyppInZwPqX3w38WSRW+YTFrHOqbjW8zZhHHIyD29g3OvyfYHIomvOpSM6a+09Y6T+hJRXCK4PwQg0T51kt/dIJ6y2tqVuP9ry+iOEhtTsjPx6dYlIl9/3LEhI2pUzahZ0AxwweHap4C3Whu6oXyo1up4G2SSc2/GI/YAQ3tA4nP+wY2k4dobIxp/mBw9mnWjgZzeecnyyyf86Sys5X3lcqKcLMITvZ0cajgXeaOzcgaAn45J1MfhOOYddxHDuDS2RBIqjYqo673P+VJT4fhmYfPbrVcKxZgBYH+/yC0exRTKdz0tuRKZn/Ulp5UgzYloFvDySEH9dZrk9VFdFHWVnMX3kJ41gqjyfCQBm1GMFOfxZfICAGtgtBJPRdhq+GKq66dYR0ZXJK1UDCWpPcIKJ73puguVlODAtq8t9waSv/v8RDYmf3NSxy8dFCG/2S4WlVmEZbUz6sPsPN4Sh6W7dUhitomvrkap3+8JjnPL4DYv8ayd+cpRCXE9geqQDWN/iTwj71nAT+8lEddvx/kk3cOXEXqwUpXjgjbR9PNjFGaXZ1qdDnC9ATGvwYordyNiXpJweRjWutwDqchzizTpqSiaf16Vuk9OkqAECNoGeSNmvKzHskVNguaJujZZ+tMq5ZgOc0ja3qFJrvuxBoClcNd1sDYTti2LnGEBiz5LconR7LxUvdA9GXms1SUNI8buh0dMDWGVDUjEKVO+ezdVIcXN
 N8H8Ju1D
 r72z/S7I51RYM5lnP7eLOa4twsl9RZc7tH12C7jEbtxLq2WLujEdgjTTvSVABUgVjaR+IQwEovEeL6c+Nat/UzRB0eWNwqEZvRQtnvvldt19qASsy7e72KbbbD0NsUaETTvbCLLI1oPbMN8G4/gAebOouPMXZJRXIoJNu6rDncMZ7zWEKmB4+gJixccluzuoOPUXNEK/8W1OHNHt6gyaYvDH4B4CKws/GbaJOxr+J/Y3xCso=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 08:41:00AM +0200, David Hildenbrand (Arm) wrote:
> On 9/15/26 11:21, Yeoreum Yun wrote:
> > There are intermittent failures in collapse_max_ptes_swap() and
> > collapse_max_ptes_shared() when using the khugepaged_context:
> > 
> >   # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >   # Allocate huge page... OK
> >   # Share huge page over fork()... OK
> >   # Trigger CoW on page 1023 of 2048... OK
> >   # Maybe collapse with max_ptes_shared exceeded.... OK
> >   # Trigger CoW on page 1024 of 2048... Fail
> >   Bail out! Unexpected huge page
> >   # Planned tests != run tests (26 != 23)
> >   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> >   # Run test: collapse_max_ptes_swap (khugepaged:anon)
> >   # Swapout 257 of 2048 pages... OK
> >   # Maybe collapse with max_ptes_swap exceeded.... OK
> >   # Swapout 256 of 2048 pages... OK
> >   Bail out! Unexpected huge page
> >   # Planned tests != run tests (26 != 17)
> >   # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> > This happens because khugepaged may collapse the pages before wait_for_scan()
> > is called, causing a sanity check that expects uncollapsed pages to fail.
> > 
> > For example, in collapse_max_ptes_swap(), after faulting the pages back in
> > and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> > before c->collapse() is called.
> > 
> > To prevent this, change the khugepaged setting from ALWAYS to MADVICE for
> > the affected tests, and mark the VMA with MADV_NOHUGEPAGE after it has been
> > collapsed by wait_for_scan(). This prevents khugepaged from collapsing it
> > again before c->collapse() is called.
> 
> ALWAYS also respects MADV_NOHUGEPAGE, so why is the ALWAYS -> MADVICE (MADVISE)
> change required?

You're right. this is redundant and it's enough only set the
VM_NOHUGEPAGE for anon. I'll remove them.

Thanks!

-- 
Sincerely,
Yeoreum Yun

