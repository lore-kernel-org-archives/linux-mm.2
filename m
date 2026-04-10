Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB6B2F36BA4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 03:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BEB6B0005; Thu,  9 Apr 2026 23:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62F56B0089; Thu,  9 Apr 2026 23:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F946B008A; Thu,  9 Apr 2026 23:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98AE56B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:22:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29BE11602E7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:22:46 +0000 (UTC)
X-FDA: 84641199132.11.9740C12
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF537A0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:22:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G+yp2+wa;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775791364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHdIs+WY6R5DaoZ/DJBQW/O2KE9/mI5VCbJg5HKZ1ms=;
	b=D27eqJcUWzGLNVLbDfmG2JlestV3iYHugwdtCjSTdYbiIK2L7QSO1YbusG7Wz8QBMEBqE4
	tlfcnJkahvrMaP7E54qoICNVG1nbdGeIj9sC5ie88/6bllmEDEFsxJhTyA2OfrN2j7Der+
	/wVbKEPjT1F1/AauRlEQXl+/dbsgdc4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G+yp2+wa;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775791364; a=rsa-sha256;
	cv=none;
	b=EsLKk6UrdntAOKsg6i7BLd7mP7W9k83qEWmTS2OFGHjbdInZSo9a+vOnemF7VZRoiYpRJF
	OxSL9itKwph6bgqZYlqvt/+AvPyC5gptx6wRW+u4rtPdSQ936yOjYrlqTi2mb1bwd/70W8
	Vji4mfDbqWiRiA64Qeyr11L+3VW5Wes=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB3061C25;
	Thu,  9 Apr 2026 20:22:36 -0700 (PDT)
Received: from [10.163.181.107] (unknown [10.163.181.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEDB83F641;
	Thu,  9 Apr 2026 20:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775791362; bh=R3qfDw7crVOy8R1j2TZwYuQoVv5jXQP+cKnUXI5OagA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G+yp2+waAu91yxXfiqb8dbQfzSXCQ1iHAvULnso7HPiYfR827OieVKrhS5V8+wMqa
	 q1uW/KbgMfpSlCI44/PT4LXYYbfuLIob2IuOvEmmbUJ3kc2wPSsuZiSlD7bfEPfKmU
	 dGKDbHoGuZZS/wmvK934atJ8TP8nhwh7yAPgkalg=
Message-ID: <ac73cc87-8663-4d45-8c0f-4a01ffc0fc29@arm.com>
Date: Fri, 10 Apr 2026 08:52:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 14/16] arm64/mm: Enable fixmap with 5 level page table
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-15-anshuman.khandual@arm.com>
 <4382c90a-bc92-470e-9aa7-4666753479ca@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <4382c90a-bc92-470e-9aa7-4666753479ca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5o3cgwgce4j773b1grr444oeit1k36h1
X-Rspamd-Queue-Id: CF537A0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775791363-994626
X-HE-Meta: U2FsdGVkX18S6HPwjDBk3Wm3f8R513gMvrkT6rlT5mJ6fT0id5QwvD72+nZNTYXhPhcLDPx4Ng5sUlTlbp4hGvwxwGb/6T6SjZdTnI/CjpBdOqlCCmqjHx7vYSTiiPj33Adu/IC5NzRlg/W2A8IOI5SpujwlzUy5X31WpuHn6DVwhvOM+tdVJX40BlnwpF1mkBgOksuwqWnmPCDVMKwctSywdfQ4PkUC8IO28zlKFKlxFD1P1z58VQ5/rsqjJS6WyDpJAatHy1dBHN4slyNdxzCmJ9FF5h2v3kL7SH7s/chEXjf1kzT/A+xz5faEo+F5rxswZuVoHvMXxP2M3FZyN/MEGw+qyQoai2d2Cc6UJOc9Gbmebz0Xtw7jF97e7FshM3CKycNb0E9TLymOU5lr8ahXEZS60ZqDHBzmluVLpwSjBbviOL0o09WQWWG2W9xnNlJLjhIQq/5Z4x1w4mOJNN7QDH3V7bViH4UZhvIZSo9wG6MAQOVDqq1YSSD7wrOay8AV3s37PUHl0KpLpJ01+rhAFGl/ZYU+smN8PvM5PywpgL6pI+k6V+CCs7AuUj9KPHCAtcgsq/XwYv2fQk8lGClIj1hiUXMe53Hz72YufwoEYJReZXunyATCWVaZzd3wjRfJ/qBMoZpAHzXWwvI7L9thHQxwrBustTtpcSFw/1VWJE/LRjTi1NMNw+ypFlXpByaTCdeBSk78MPLLQdqrdcjjjM2SvyVAw3Bt70LBP6Jgg8LOZfL2UJj5wrxQ7Xpu4HIpq4JoOywjH8T/Id6W0iqY0dDqIZuoaAhi5yvdwHqvUaQgLHroaRgSsoTt6Lo2bJ3ci3HTpOq6CzuZuigGUapgp+hUcvpkvPFle+lFhqRaIZz49N7zd0ufdvIoRJn2+fjLSVAHYMYM3ORIebSQTP2eOAZiR21ZMwLJ59iWR+lkEld/G2FMEoeJ+RCtH6pLl8kq5rtQNkKbS+yu96y
 6nfwMkQH
 8w63ZkwWmwiJbsBo1E0AGwsyLMIpzk6MM5ZIYKb4H9hURJOqcltK+LPgJak711i/tI6kRtbbTtZn450p90BxqMym1GZyPs8v80PloUGyvYoShFEW8RKzUj+Brez1bC9nTh6AJvzn4ODLMIQyzyW/Eapq2RlqRZBMUKp+zwe6cEmU1W1SKzwOuqDGUYdZ+QNAxlYoQ77DdHM/3sOpR9uE/tEWtphCREGBya0HNfi8ij+j9itDsvVYp+iZoWfv+EXk9Ic2dxz3wILgdd9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 5:59 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
>> Enable fixmap with 5 level page table when required. This creates table
>> entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
>> (PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.
> 
> Can you add the "why" ?

Following reworded commit message should work ?

------------------------------------------------------------------
arm64/mm: Enable fixmap with 5 level page table

FEAT_D128 halves PTRS_PER_PXX thus shrinking the VA range coverage 
for each page table level. Hence in order to preserve all existing
VA range configurations, some geometry now need to become 5-level.

Since fixmap is used to build and manipulate page tables early on
during boot the mapping must also gain that additional level which
was not required earlier.

Enable fixmap with 5 level page table when required. This creates table
entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
(PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.
-------------------------------------------------------------------

