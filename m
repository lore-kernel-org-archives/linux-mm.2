Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396CCC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167006B0092; Mon, 14 Sep 2026 08:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1408E6B0093; Mon, 14 Sep 2026 08:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CC96B0095; Mon, 14 Sep 2026 08:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB9266B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:46:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B45C9C0423
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:46:40 +0000 (UTC)
X-FDA: 85212341760.30.F7A1EEE
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8734F20004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:46:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cp1cYtBR;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vcNAxFZ2rsqLL4d8JSVp6zRB8S5BUFYgWznnQ8mTZo=;
	b=2fPmhK5YdTEG4Z49QPyWlYHHO4hn28F5LMxO3gGVLu07kpUEP/nd1E8VUS0Wpd3QvQOGaj
	zXe1W5Ds/8hMuiGS/OpnzvFq/O6pqxFvMFCOM1dk9bEjnyYEcrhuw1f06dMOY2XOjKfaWD
	gnaBIu20gdByPAJGH/1UVWeYnsddsWE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cp1cYtBR;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389999;
	b=a+h413WMjb/D87AgzBW2ZvZnKClhwzq0O5p8/27BkiDJ++d4W+AM0VBe/NLtKjp1W1sxnA
	Z4e/5J6W/HhXl9IjlOIm2U56Q7gUQgcCjYf0JZLR3aTU3Nz4oj/NYiVu7uzPD/7Yx9XFKL
	okTROlFYkY5K95m4DuOQL6zTToc/N+w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PAV/4XheBnUf+eFjtLAnGVj+GexcIqJdwTJ4MJKQQW8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389997; v=1; x=1789994797;
 b=Cp1cYtBRhvu0DUFuNaxAVGVtl5adZb8VFLQYajLZ0sNiUFS3rR9WWFQkbAW5SNYe1CYR9aXg
 2H84eHbeo2qndtSTPhqABifFyrJtj2oozrU8gXlGYtxPpTB2HbPeW8+X+00aIizBcBh8dmZd2Z0
 7XWdAKL167qeFmP6iFPElc1w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 01c12c3a66a72b2b;
	Mon, 14 Sep 2026 12:46:26 +0000
X-Mizu-Trace-ID: 01c12c3a66a72b2b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v7 00/29] mm: PMD-level swap entries for anonymous THPs
Date: Mon, 14 Sep 2026 05:46:22 -0700
Message-ID: <20260914124623.331589-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8734F20004
X-Stat-Signature: jsdngmm8jwkkitsc366t7nzof5w7a81a
X-Rspam-User: 
X-HE-Tag: 1789389998-290846
X-HE-Meta: U2FsdGVkX18BoDGMWmDBIO/hjBwsvuiGvZ+j9vf49HISvwAFpAmIt+8962xTc8ZuWQgDSyq7AjYlC2xp7fQ4N8zsPunQdunk8pY2043SG/7NnDgQCGW0syC6l/qsYmLU19qoyBaGsghxqIYi4vfqCuW7Ivrw4C//ewuCwoWfYibz1HeIVWM2wfZgMfM99qoNYs2yJGLOZARSodC7vHwHf4EIIbbdWdRZMCo5n2uDDNb5s6ep1JlSyMYiRim1GFsQo02qxEbSPPoRDS+SDjc5CPcIZS47M+9dbaenvo6nrP57+8GXxAg3OvvuIk54Li5owgk5kWBPuKuKCz79CDb9PWfwACITRb10Je59hNpkXlAoVjSed7USPG4G2wwkaE8356B0sOQti6BBQhOo9dhjdpPQjUAzZgYuf020eTBiB5obPzzmgWd4X3u+5yvfZ64G6wcJzKByzItKPszAsBzzrL5C0Bm/aGh2lT17xK/0JhUQ3gKVZ5gb98uQj2LdbH/aJjdzvQwP8u8x9DbicNWR+UQ/krOwTrlTRhGakrsbgvPbN4t33oLibxyUZOjxmjy0qwv10sXMv70YjZobAGzd/ZmBdx7cNadUqHybvPYYR12N4imd8P0dTOMYYQr+QEkE/Yh2WCYEJRZmOrxEEZtHV4rq0nIFAZz/aAw8g1bpvaSVi1LfH2OKF3RINnwz0kTYxg/E9afQei5BQEQgi0kNeuuKcgCYQFIRYsySjlUTpiEZo1EPAJEGz5Q8hXLbay/AreEDJR74XGLjrX44K5TfjswARUuqGw93hD0kJ4T3uB1prymcJ/ZiysemWU7+nPlVIJzchWoJaqPI/Pyq+1KiYBrzmzoycl4bUiHt83Lwk+Smmn0xXDuL2tf8HpUB24WK39lj4m/ej9EeATTX55ZzsIefkG2cKbmbfR30oEdk4PPmasFNty5UPL7KzTJPnka8p9VENr9qxWi3mgghpBz
 RY1B3x7t
 +FPnIiGiGvxnFTLAqW94NhXhRUFIbg8jUYM+nkD8MYi1EatAHRpac7s/cRy75PGAWaaZINZN9KlPv87PRD8PDiQ7CbmiwQfipM/f8LM/4vQWkA83q7IgGzrA64hFYwLCglTi5OZ2JTAjZsU/GZBtmN2DjxHFFPSkKwVNykIB/VSgtShXbyIbFWd7lMJwO3D5Quo8uMcMaNvSvaLrlLtK9E/vcrckjT1W9ZP/6arjSDeeHx16bMCJLnSndgq70QULApjJb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 04:41:52 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
> split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
> before unmap.  This series introduces a PMD-level swap entry so the
> huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
> can restore the PMD mapping directly on swap-in, without waiting for
> khugepaged to collapse the range later.
> 

I somehow messed up sending the v7 series and only 10 patches got sent.
I have resent it in [1]. Apologies for this, please direct all reviews to [1].

[1] https://lore.kernel.org/all/20260914122950.3283997-1-usama.arif@linux.dev/

