Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BCCC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816DA6B0093; Wed, 16 Sep 2026 02:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7F36B0095; Wed, 16 Sep 2026 02:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690296B0096; Wed, 16 Sep 2026 02:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4862F6B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:41:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01D7FC0196
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:41:08 +0000 (UTC)
X-FDA: 85218678258.06.29BB4D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 210A140006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:41:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YRcOO/aY";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789540867;
	b=5SrhPqIzmrxXDkoKEnpEl0Cp+xoR9+28ODyMKAeOhBYZP4vt/xZ3h/CRlZHQ2tCfL0mJyT
	GKomvQ4wdXhuieGAO5K4Z520JqLYbwnRZPYXwqGuPfWN7ETpS35dOzFmb/P1bgKqJBnS1p
	XfFjp2lWjdKZ11KZ8+iwsWun9da+cXI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YRcOO/aY";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789540867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4r+Pqiu+h2areqlWCR+raj1oLk7aj/ORIoUigQPd4M=;
	b=CxzhqrkSHAzYzsYQgyYm2aZa4DOXX8OpstN2dY61BlA8mCpbhDm9vSLuMqGJU0M1xH7n9O
	ybiqIPQ7VTGEFCbsqBzDTPrGELSWChh1q24KDx0yVtIlSTKIl+n7+Ro/ZvCcSUKtsWuNQp
	vuWuk0ZiknJlCxkMqvmHXSpSC8Mxvag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BD9741A8F;
	Wed, 16 Sep 2026 06:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780051F000FF;
	Wed, 16 Sep 2026 06:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789540866;
	bh=N4r+Pqiu+h2areqlWCR+raj1oLk7aj/ORIoUigQPd4M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YRcOO/aYEgAieFRd9TV4em1CiMPNL4yZ2IxWt5FVOqBdT1E1LDqTvqSiNqefv5alX
	 QJ7IfkAR3/rt5P+BVHbG06ZmBdqimeMXUP1aFFGJSIkkgBeVWgHt9UlzN6YLThTClw
	 EMhmq2G6roomk/lKD1LtDv5TMZtuJmLtJIWd5oxHF1x6/CgKNzwQ53hniKCw3wUE4k
	 dTxwpeoE2Kne023rPO7AcasjqcOb4syUVFvmF+QbVLtZFh04XbXJ1noxsUNUZrt98i
	 Yn6w45hHVHb4sJDClSpTxnzvLWCSgzvMCQ8P8Qh+RM2/zsmZ5zrma/Pnmo1vJ3L4zr
	 72RjjehxGchPg==
Message-ID: <db48325a-6eea-4924-916e-5da06bd31e47@kernel.org>
Date: Wed, 16 Sep 2026 08:41:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
To: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
References: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 210A140006
X-Stat-Signature: c6ysck74ya64sajs9ystzwhyz1h98a5f
X-HE-Tag: 1789540866-952513
X-HE-Meta: U2FsdGVkX1/erO2pfUPQC87Q41uWV4XFP7qCjjxXySj+hVdD6oWpZ75d6uz2YLVWEwvOh+fR7bAXPrnjVwrJcAI3ShZIHMJF4CxdPl6RHLuhgW8VtA2zQ5j0ZGmQ/75FJBrDuZhg55JIUO+34XpAObBU0VIWYyTQpFi7falLq8YuDlsabh4A+1IX/A6wBJAfsjkQATzZJP8P+4zVbsTM4iAbc6pOGlpZ4uDy6vvaMYi54V5MbGUIIJ9Sc04p1dM8qC2/FPdYBD9iYJgeT7DpDZD3HZSfC9Ykl4T1dWuavW2nmvMdcYbl/FDDvcVW/7evloEu96iwF7GP21jw9TLp19lwyWZ8J0U4pf/Befidbxv9R8C5ZAH2se/1mxb4hNF9mRQxsxbVFoAa6a6NesFzykMrfZ0S2pvbihYv8PD3OWA/wrgr2q07EnRR8oMwO7Zq567oZmXW50ImnYyrfjeiKPkNtUtmaV5N1k6Yw35qwTCDzztWYLHF2G/qhtHFbA0N90tvASlboI7MMYGrE8qYqAIi7ILAE5bJZUG7G8CsYLJkx34VQt1vR67vbaIH6Eva0yoAbPFP3UmiG95pgbqW6ABZxqnR6526i7hPWeOTykKH41OHMtD5KBUoPkEbRSkzh2S8M43/AFqLT5f1OLpbK6tlzIF6KAvPVfkU02RVs1bDTVy3NOpS1rLJ+MA4NsIYNhL7G7Z5J6X7XQUZDlTcBX7Qp3D88ExMl5zXbsPx7vACYwTULxWzpGiPHr2Fh3m2qkucruhyJbH0/mK9BMkESi5v2DbafbAwB8nmu6b66sLkzxD53/1KEt7QagxTI8PvgbLeokgSoEw5UA3tm+fpuEFrww+9b9da98a5gtqktfa8gBqxY+K6xo+8IhoCAIvW6jFvhhJjOuDcereBA7su1rA1VcABKxu9cwv7c0ly93nxgtfqOm72Vu6a4wLLHQLPhDxKDhaNn3wMmPI9U2g
 8j9qyzdW
 i3gJoTHITq+chaOIH6sjvUtsrNDeIKgk2wNcVsDnfTrdCnXE5yOY9wbnvBWWw1SQxsb9nGgDCiFY+P1F0i+kWzvyZya0rWoAfTbHj+/25vcfmWlcEsrt+nmuE6DBMZ4cLTBpx/lpYDXFoUuKVcHJz2/8C6mufMcBwYiD3svUTOa+wrPqnac3ae8FVNArEv7nk3KI2AwEe2mM3BTN0t98MEoRtlQ0wvm45CR+y/dgYDMiTcd8qfKi1B05uybIweB4fAt5ve7IR3gL/B+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 11:21, Yeoreum Yun wrote:
> There are intermittent failures in collapse_max_ptes_swap() and
> collapse_max_ptes_shared() when using the khugepaged_context:
> 
>   # Run test: collapse_max_ptes_shared (khugepaged:anon)
>   # Allocate huge page... OK
>   # Share huge page over fork()... OK
>   # Trigger CoW on page 1023 of 2048... OK
>   # Maybe collapse with max_ptes_shared exceeded.... OK
>   # Trigger CoW on page 1024 of 2048... Fail
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 23)
>   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
>   # Run test: collapse_max_ptes_swap (khugepaged:anon)
>   # Swapout 257 of 2048 pages... OK
>   # Maybe collapse with max_ptes_swap exceeded.... OK
>   # Swapout 256 of 2048 pages... OK
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 17)
>   # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> This happens because khugepaged may collapse the pages before wait_for_scan()
> is called, causing a sanity check that expects uncollapsed pages to fail.
> 
> For example, in collapse_max_ptes_swap(), after faulting the pages back in
> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> before c->collapse() is called.
> 
> To prevent this, change the khugepaged setting from ALWAYS to MADVICE for
> the affected tests, and mark the VMA with MADV_NOHUGEPAGE after it has been
> collapsed by wait_for_scan(). This prevents khugepaged from collapsing it
> again before c->collapse() is called.

ALWAYS also respects MADV_NOHUGEPAGE, so why is the ALWAYS -> MADVICE (MADVISE)
change required?

-- 
Cheers,

David

