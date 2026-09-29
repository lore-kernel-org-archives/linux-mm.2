Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E184BCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D014A6B008C; Tue, 29 Sep 2026 06:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88E16B0095; Tue, 29 Sep 2026 06:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52A56B0096; Tue, 29 Sep 2026 06:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 810556B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:08:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22734160498
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:08:36 +0000 (UTC)
X-FDA: 85266375432.15.1632B74
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44D86A0005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:08:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qAIyhHaP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790676514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFcejaZdsIYj9VhQK6+kEz42HX5926Klyw/4uu0/sNw=;
	b=i149FIRmJkelufyAoAEVBzwEoHffvKj7LqdRLecNT8xcZLJoBEMJ2+vUGIUjPqmh0kjnjq
	J1X6cMraYzdGn6ZxQ7oPj4uaka9YvdfsFRm8zRkZKdnbdEavpCPKiWdtJHGP7mkG5oKZQt
	ZlutUDRxDyP8MzJ9u8p7nDBaC5mNDcs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qAIyhHaP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790676514;
	b=o3jbsFlYItYmxVO4Ywq8kjLRaC0K6YQSc2ibRx/9Uo8fy8WVEFJXDDcuVMCEQFaJj8kpRy
	xy+1+Td18ioT7OAa1PG/o5kQWRozU5jr6HNmtHodEezQTLKTPbEmI6YKfBkPY2pXtaBKlK
	LYYczL1+/0CUehTq0gPCEPB9vWm11GA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD8501516;
	Tue, 29 Sep 2026 03:08:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 758093FA1F;
	Tue, 29 Sep 2026 03:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790676513; bh=1CYkzAv1UTOgfjhP/3+i1axtbxG6zEvJxlpMfUNZI7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qAIyhHaPe22UOjd0zvagXkjWWMEzDE+8CWsaIgPMqqvkJLe9g/mFhHaS6vmtvCgB/
	 a4X+hXCZQKGxZlUxyYJqbOgDaFC5UaE9hpi5gd2HWgesheChZ/neID7JzTFSuRI5iN
	 uAEBhOuuwow5j8+ay83HPaHCNneDHjFcbTHl9ins=
Date: Tue, 29 Sep 2026 11:08:29 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
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
Subject: Re: [PATCH v3 2/2] kselftest: mm: fix intermittent failure
 khugepaged test
Message-ID: <aruOHat9wlu1H8la@e129823.arm.com>
References: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
 <20260923-fix_khugepagd_fail-v3-2-b387e92fe1a9@arm.com>
 <447e0be9-836d-4324-9a36-77f8a0cbecf9@kernel.org>
 <84d3a9f5-4bfb-4f5e-86ad-ac8fb896d885@linux.alibaba.com>
 <dcf6fb14-7048-481b-83c6-9e8da6d874f5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dcf6fb14-7048-481b-83c6-9e8da6d874f5@kernel.org>
X-Stat-Signature: kye817hbmdi8s1d9m5uwmqfz9swgo3o4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44D86A0005
X-HE-Tag: 1790676514-951625
X-HE-Meta: U2FsdGVkX19GQRvgN7Uvj0lpp04AtbbOh/fjm0z+jKqogFE+u3lJGNYLzKGht6TN7JO115l72LdGzBNWY+kkSuvp5PhlyCgFFK2+X9uoOAUtlRsrB1tOab9rV2q35XUkAHHWIJuY5H5NuGJpjW+eizJXdUU6CZVbisG+X8TJuadDDiIelWzJp/ys+6HKbIf6WUOm16q4sIIzhC4MNREkQNUhxnWF8+l0kVPyowtDIP2mgwT71D80hL/Rw4OlSn9RBX3qCuhkxD5jMdmb84jOmlYVSTe5CLLp5LCgbg9fPfHs18VG2kH4OpFqqfiLC1nke+7kE3F+OnZgGkKZoawxOGAj+hpNb7DWH5ojNtw767Hi0bnOh5ekogkJJII5EnGWdCScLaxW4z822/TJ8CZgHstyivboF35VYlsw7dQ9if/8yk+xiEV4mwtFDDj80/wTXy8+w4IQ4sM3t0l7YPU1MCNtAa39cA9B9nJBpb7mDUbIivwF/c7pPNCNtX/6aSyM6bZb8lqRNBsgydyxMWBdX5z8j0fC4Rpf7jeKEaVEDfgPT72UMGpwrxmLCBLvmxG90ogipKKas0ycZYzkgF7mIuByUjH50Jxp/Ittma6JV3uT3CzXjSjVBpg/qejXl5+vut1tIB8N4dk61FLRbUdwNO59NePq+ROgWa4+y33uiUJ/VoM3LNuGZmSvADXodk5fDIwgUGrfm0SZwmoEAddATuHf/VXM48potEbf22aPTDGI+0SDKVl04p5AV7XrQKbz+udoFtGGjmEwFl8czfI4/picvJV+SlsI1v6pRbeHdCMZqO2ae+/DSPBAoptkrKlaAktjh7n/zZUkrP5JPf3edl0E7OkYJdzCuQegholG7urE3JEC8tLI6mg6olWOUMAjZ2ktNvwlX+PUBOQsKlk0aCDxgi7cvvUBcBYEm6AUrH1chkTSwC/wMKIBgcCutkV4jYjGpwc44kmbKPnxw82
 Rs33SE2o
 bnik2Ry3JauAkx3r5AcfmEwGl+VvjUgmS0rGyHbrwg0mTaPcy/YzFiWb3wBUyv/cQBoV04MdjcAVWyXJCpQQeqyEgG5R4C/oApOiFUJSRBPVzOEJwps2EDV+iLPu1VZ00nXJcYzlQ8M2Mmo5c32fZXttfqD1h5o2H1zD/qPSwsgYKHTe8H1CEVFoA72C1sqpF9bQXVEcU8COm7xQXBT7dO0b4lIn/QQHkBYuiKjGFc3eHIybcrzCzkm2FxldPD+rqSqzz5lQufgxs9R1oE3hdWUxfXvGaKrIvBnRH4ahLw/s3OlfFE/P+GUczQEWxsb+MlgwrenNJnvbdldVGaoItG3EVhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:46:50AM +0200, David Hildenbrand (Arm) wrote:
> On 9/29/26 10:43, Baolin Wang wrote:
> > 
> > 
> > On 9/29/26 4:38 PM, David Hildenbrand (Arm) wrote:
> >> On 9/23/26 17:29, Yeoreum Yun wrote:
> >>> There are intermittent failures in collapse_max_ptes_swap() and
> >>> collapse_max_ptes_shared() when using the khugepaged_context:
> >>>
> >>>    // while running ./khugepaged -s 2
> >>>
> >>>    # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >>>    # Allocate huge page... OK
> >>>    # Share huge page over fork()... OK
> >>>    # Trigger CoW on page 1023 of 2048... OK
> >>>    # Maybe collapse with max_ptes_shared exceeded.... OK
> >>>    # Trigger CoW on page 1024 of 2048... Fail
> >>>    Bail out! Unexpected huge page
> >>>    # Planned tests != run tests (26 != 23)
> >>>    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> >>>
> >>>    # Run test: collapse_max_ptes_swap (khugepaged:anon)
> >>>    # Swapout 257 of 2048 pages... OK
> >>>    # Maybe collapse with max_ptes_swap exceeded.... OK
> >>>    # Swapout 256 of 2048 pages... OK
> >>>    Bail out! Unexpected huge page
> >>>    # Planned tests != run tests (26 != 17)
> >>>    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
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
> >>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >>> ---
> >>>   tools/testing/selftests/mm/khugepaged.c | 3 +++
> >>>   1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/
> >>> selftests/mm/khugepaged.c
> >>> index 2aa7c9197158..b0cb02bf1a73 100644
> >>> --- a/tools/testing/selftests/mm/khugepaged.c
> >>> +++ b/tools/testing/selftests/mm/khugepaged.c
> >>> @@ -618,6 +618,9 @@ static bool wait_for_scan(const char *msg, char *p,
> >>> size_t len,
> >>>           usleep(TICK);
> >>>       }
> >>>   +    if (is_anon(ops))
> >>> +        madvise(p, len, MADV_NOHUGEPAGE);
> >>> +
> >>
> >> Any reason we just do that unconditionally?
> > 
> > Although it's a bit messy, as I mentioned before [1], unconditionally setting
> > MADV_NOHUGEPAGE will break shmem testing. Maybe add some comments.
> 
> Ah, thanks for clarifying. The problem really is that we cannot undo a
> MADV_HUGEPAGE (give me hugepages) cleanly. We can only go to the other extreme
> (no huge pages).
> 
> Yes, let's please add a comment describing why we limit it to anon.

Okay.

-- 
Sincerely,
Yeoreum Yun

