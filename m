Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65969C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0FA6B008A; Wed, 23 Sep 2026 11:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7917D6B008C; Wed, 23 Sep 2026 11:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7436B0092; Wed, 23 Sep 2026 11:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 497A66B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:21:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3DB3160293
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:21:01 +0000 (UTC)
X-FDA: 85245389922.20.19BD736
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2363F120002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:21:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qI0VIK/I";
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790176860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtpKOVixm0piBcu/yUJhOOa1ghVwixQYr8SRbofY6Pk=;
	b=yyWePEsIBrDu7ePOXP28cefQ6G98X+PcEAYK8OI431u92kmVVc5XYZa3C4/6sN8WIM6Fat
	irmvWyRr7g45urLxxaInR4dx5b0PFY+8PdCtL3R/SkIc4A9KXNuis0EIPBk3T/TiAupsRA
	FLPWeVAGQjtYC0vox4J5diLZeq0FBPE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qI0VIK/I";
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790176860;
	b=z64tt1aSAM+xnME0gr1zFadVjI54psDsyqb8kP6VlJDdiUExXcS76tQNbK+kKs+P+jdAVY
	kIE5P9t6WvpW0mwYdSCznsmcyDTLF9GqfM3iomzQkp/I0lBfymuKjC+1GbP4mPEQc06LIa
	nfVon3PqY6hv0U3Zz9ylP+98GS0Sf60=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B748E1570;
	Wed, 23 Sep 2026 08:20:55 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B71E3F86F;
	Wed, 23 Sep 2026 08:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790176859; bh=5GOsuFCuw+jc5vl/l8WflGRzLKXAVjSEqD5oq0W5DB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qI0VIK/IBH9KvZQZ57W4XaFXOuGdOkJGcw93TheuxDGB3zEdqaz6s4ZqUnVfRUTQZ
	 GYh5UVJWYpbYhLZiS92pn3FORl+CTSiBsc7yArDRyew7s0NpuQJp31lzuy+WFH5dcv
	 b0fI9J7arbbZo/PCnEKHYSkDSxMHPpeVNX+cJTuY=
Date: Wed, 23 Sep 2026 16:20:53 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
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
Subject: Re: [PATCH v2 2/2] kselftest: mm: fix intermittent failure
 khugepaged test
Message-ID: <arPuVU58hOg5fq4O@e129823.arm.com>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
 <20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com>
 <6cc12fe6-4f2f-47b6-b821-8a507eb80b46@linux.alibaba.com>
 <arOv_EFOPg0HwBk5@e129823.arm.com>
 <cf3aede5-62d4-4f93-b415-7498f84a20c2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3aede5-62d4-4f93-b415-7498f84a20c2@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2363F120002
X-Rspam-User: 
X-Stat-Signature: 5cssushuxhasqdg3i9iqrcbectj9dkcm
X-HE-Tag: 1790176860-209601
X-HE-Meta: U2FsdGVkX1/6Se57rHRlbq3BZpUwAEpw8uUbUqJLjJw8ToEmBrLWOLUzyhqKr+fSZzmgMfFb8LQUYrUbiSUc8nXcK0cpOj/2B+RtkpYErQz+T8cYVPfSXoU7n2S/cUqSP5UPSVKw9SvNv2qq2ZuxGBCylsNKpAooYCunu/CWQ5/7+6JmAvMG8gmLVFT2ZjOnPZyE3uHbuaGZjrU83exUYX50uXBlwuxie2GMXrMhbbsn/brU9cWrkJtqQFEKcRPbTAzdfaeb23YO1OWIAxZtgZuA+7hXK2g7XCxUq9L+7wtp8dH7KOzMEFguj78JmggwJIb3ca6MGpdZ6y64JGt1Sgp4nxv0EZsPUx5UKCYWTCgRgddQAAnLHqdSpcH9fu49vMAbtZuHa5SqgZQQn4Wh+/7CBGJ170cf9dlz+WWiyuTX6sx2Ge7xo0CMMOrJjEE2tPFz8jOJ6jdipen0M/Ke+p8Td7o7rnbaJv5icOnx9/jcKWvbKy3qk0hCh44NgvDMd98Fmxlq7KZPT75KQDEppndg/x2tRy5ac8Nf5RSpjwSdaWUUDB4zMhmI2Tt4vyz6+tpn46mydNsBcKHLOyOtAeVPNYgZVfkd+CSki+d75ewqXlvRPhV/+Hruofn8OyzwIoDz8HNbA6N3kG/h1QjBu6KCN27pNtP4zAapRBPfsCE4nWXqP3r8vnTkM/SGo6LqMVjpQ1AiF8z20k+9cI5zDx2iW/iuAFekTwru5z2g9aeAwqh3KTzXwsX8fS6P8EeY8dUSjje4Pf3Na9fH+6EySsoNswlqx+ZplRRa4CnuNzVVfaL/aGckPM8uJ4bPFAMTQjNXCe/+sYvqjTUQxhRxTCDIoXuDa9nAvmWBIdBvfqU1LsOzRf7kN525O7yp3x7ErGugAps0DoxAv0gGnmreoDtQaoFbUUVDfveGOgau3IwSAP3/Km3fNzMq+efIhm86OeLyafV9zrkgwQ92lag
 5hCkfdM5
 1q+58WirAUboLjOkuMRVA1pv7Dp/y4i4wAfNfJ1MBN0eaRkO48b51Z8oyRqOmOH0BBesXcdYLYnXiAiqLsO8teWm3GObEICg3K62wi6Ny9wYKbGkuujXpr1U7FQsG1hdtnVEXLE4BKyTOHbJiOLOdWWLlFOjxnyLVOn4w1d7kjcTBcARehWiRUmdUSfQyjc7rpl+RH7lxE8hIGZ0R/SOICWqQpzPqiDTvL7qEvxbPJU2ZgwQDzHHMD11RVlSewTJGpFVUU6gPRI6ORlmVosaZpJRcgA3yOW62qfhl3/2x1L8n0rxjPDsKEKoIdDXCrn9rJeRH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/23/26 12:54, Yeoreum Yun wrote:
> >>
> >>
> >> On 9/21/26 6:35 PM, Yeoreum Yun wrote:
> >>> There are intermittent failures in collapse_max_ptes_swap() and
> >>> collapse_max_ptes_shared() when using the khugepaged_context:
> >>>
> >>>    // while running ./khugepaged -s 2
> >>>
> >>>    # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >>>    # Allocate huge page... OK
> >>>    # Share huge page over fork()... OK
> >>>    # Trigger CoW on page 1023 of 2048... OK
> >>>    # Maybe collapse with max_ptes_shared exceeded.... OK
> >>>    # Trigger CoW on page 1024 of 2048... Fail
> >>>    Bail out! Unexpected huge page
> >>>    # Planned tests != run tests (26 != 23)
> >>>    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> >>>
> >>>    # Run test: collapse_max_ptes_swap (khugepaged:anon)
> >>>    # Swapout 257 of 2048 pages... OK
> >>>    # Maybe collapse with max_ptes_swap exceeded.... OK
> >>>    # Swapout 256 of 2048 pages... OK
> >>>    Bail out! Unexpected huge page
> >>>    # Planned tests != run tests (26 != 17)
> >>>    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> >>>
> >>> This happens because khugepaged may collapse the pages before wait_for_scan()
> >>> is called, causing a sanity check that expects uncollapsed pages to fail.
> >>>
> >>> For example, in collapse_max_ptes_swap(), after faulting the pages back in
> >>> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> >>> before c->collapse() is called.
> >>>
> >>> To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
> >>> collapsed by wait_for_scan() for anon. This prevents khugepaged from
> >>> collapsing it again before c->collapse() is called.
> >>>
> >>> This failure was observed on NVIDIA Spark with 16KB page.
> >>>
> >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >>> ---
> >>>   tools/testing/selftests/mm/khugepaged.c | 3 +++
> >>>   1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> >>> index c32244b565658..1aad4bb427ece 100644
> >>> --- a/tools/testing/selftests/mm/khugepaged.c
> >>> +++ b/tools/testing/selftests/mm/khugepaged.c
> >>> @@ -578,6 +578,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
> >>>   		usleep(TICK);
> >>>   	}
> >>> +	if (!strncmp(ops->name, "anon", 4))
> >>
> >> We usually use the 'if (ops == &__anon_ops)' check in this file to identify
> >> anonymous test cases.
> >>
> >> With that, LGTM.
> >> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > 
> > I think this is merged at mm/mm-unstable already So, I'll send
> > another patch to change it with is_anon().
> 
> Unless it is in mm-stable we can reasonably squash stuff or resend. This
> shouldn't be an independent patch.

I see. Thanks!

-- 
Sincerely,
Yeoreum Yun

