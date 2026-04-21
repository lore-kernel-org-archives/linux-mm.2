Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9349DF5A8D1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 00:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804D16B0088; Mon, 20 Apr 2026 20:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCCA6B0089; Mon, 20 Apr 2026 20:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E42B6B008A; Mon, 20 Apr 2026 20:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CBEC6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 20:59:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 681C55C53B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:59:08 +0000 (UTC)
X-FDA: 84680753976.29.127807B
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf11.hostedemail.com (Postfix) with ESMTP id D978B40010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:59:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RguoVPRK;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776733146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yi+xUZCUd5yeE272YJMQ5iJ3vo6smTP4Z4GqGgtzU4=;
	b=W1tzYEYMJXMeQ+BX1dTGDQNmFdxv/FhdtB6HLMyTcn1qgDcfUdR2Uvw1djH+OyRhJBIZvK
	rxKm5VlwtZp8IGUF/64v5/JD3UZODpSmyqyTNWA+Z7xhQa2IlfB4muWMQ2SosnImganoEU
	9R74/1y0oferAQeKlBMBz1cEw6a174c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RguoVPRK;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776733146; a=rsa-sha256;
	cv=none;
	b=YbGuNtrgkFMXhymTcDkgasYzIQbWJx3e2+rKxptuREa+ut2OpBTZ2mIjIYD26LWkDr0Q2H
	pMq41XJYZS6ML7KcLRDrvbNaRU+UJOX3zl7k21qW3WcJMp+FxH0+X+TV+gB5U58qUaTcJF
	ariqjk3pwxrTFhhBBdOiJIM3Bjz3azk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776733142; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=7yi+xUZCUd5yeE272YJMQ5iJ3vo6smTP4Z4GqGgtzU4=;
	b=RguoVPRKAQbcH2h0/QWfnQtOzTdRCnmcfM0RzqxiQtcq56cyUN+Ff1svS1CkwBqiozM1adJS1Slu1QBphIA9w2IZkoB49D5GaDsY3gArAdXXc0j2ehL7orVFkAmyXyQUrO7XGToT0nWUHwGrdwpIH/biGAOGJ3vC+aErbpPMEHg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0X1RC5RC_1776733139;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1RC5RC_1776733139 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 08:59:00 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,
  Vlastimil Babka <vbabka@kernel.org>,  Brendan Jackman
 <jackmanb@google.com>,  Michal Hocko <mhocko@suse.com>,  Suren
 Baghdasaryan <surenb@google.com>,  Jason Wang <jasowang@redhat.com>,
  Andrea Arcangeli <aarcange@redhat.com>,  linux-mm@kvack.org,
  virtualization@lists.linux.dev,  Johannes Weiner <hannes@cmpxchg.org>,
  Zi Yan <ziy@nvidia.com>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R.
 Howlett" <Liam.Howlett@oracle.com>,  Mike Rapoport <rppt@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair Popple
 <apopple@nvidia.com>
Subject: Re: [PATCH RFC v2 02/18] mm: add pghint_t type and
 vma_alloc_folio_hints API
In-Reply-To: <290d615a001cf121dc0c604eb79451bcc7917baa.1776689093.git.mst@redhat.com>
	(Michael S. Tsirkin's message of "Mon, 20 Apr 2026 08:50:23 -0400")
References: <cover.1776689093.git.mst@redhat.com>
	<290d615a001cf121dc0c604eb79451bcc7917baa.1776689093.git.mst@redhat.com>
Date: Tue, 21 Apr 2026 08:58:59 +0800
Message-ID: <87pl3ti0x8.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: 1ieu5girn75raxwc11onyobyn1shm1yi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D978B40010
X-HE-Tag: 1776733144-269157
X-HE-Meta: U2FsdGVkX19dqButUEtAtihf+mHXuaeS31Ulp1WUdf34lQQE1q0iRs4aaIs0iut1PQl6wdRq4sCVnpIp5fL0WAhlUOMl/NrL0wHaDpdhjJnd4jnJHHHtDKc2DRPYMMdMueBy3ryNW2F4SIrgxeXbSylE+CZfOVZL38MARK3Z6VOnqN2234NdBOBZp8Mf1yViWfCXXyaYB+yPEZrS2k8obz5tq5qFpVagcWow1A5YG3QYtM6mveXH1a4eEvuCm5DxOE6EX0zMsbNuIkMw5qEGZp+whqQ0FC2DMKJyRo8pKkYwP/TH8cCJu7pOOLDzTLEXNanm6ZCeIpod8PRnqjKxCjzE4grvuCb9rYKAgUfLX0GdY3JyM/3uY7t83KGGzI9DqF2RhP6c1Y9mBuVYSpm43jnXGdA4ZVlS25ayo2Go+X4qh7GnUqQQFQjbnhwYN14XQY5nQLi2+BVndnRURX8Ov6HX0nkj9V8ko+rSf1+ucMtSxaR/ZWKzA3KyacsG+c30rdsAQJfhOTKzjDfxWJroxpBEYzSdNojtJMx0oAD3NIBmhuebsumM5k5hsONe5/7HyvFDiFwxZPoZAif7XumPsLSGweWJ6TZ7Ww4zGPkHmWd3m8+w7ceuAYTXhu+tbvrBpN2OYrFC18jtxuh5xLi6gg4A66fxeK11D1BSxrloKl0oB+dk1RBgEfN8g+L1kmcIJYGp3yDLIXFZrWs7r0qMEkywHlbheMCv9ksCcWkkgbnb8P5Qzp7MTcV0ZJMTKmIfDvsoABJuTSkGww+Oxcn9DxG7Syll0611Qwo2Qc8M+mduySfsqntoSPbWD1P9bv4yXFzryjgEccnBwW9o3rV/0rHVTpWqK+wDhHQBYmo6XBWNja3JnkEW07suIhMjIJr6fzI5MnnPnnGYjWcx1NZ307aPhi8bejzxWpIJZ3v7meS1QSt1J9OK8ue4ZdNKQ1OY1N1cN/wl3VWE9thU0re
 wgKQ4ORm
 TjyvRNOPTTArNQ68tSqQLFR4ISWZbeSox91+o5FPAio4JHe6R8nS2KU4FAVJmqlOqqbtYsERYfoWc2ZcbPPAgVDbYcQ7CFNt3y9LC6GZyGgKVBKFlaxS8XU1dBBvl3lTm3uRgNyf0VCjnxHOwSQfDE2gC5Qey/4xgwG5pP5N2KOGEy2vUwD9LR1M2mIY9Sh/K6PBLl5IRrPlA9qZ3gzxpSv3d8NHGpxIKa5UVxaLpfJykflhzpWLZCOyVX1N5K2f5V3PSfow91w1ILI2JVgaC1TmqmUqSoQq96r2vLS3uBvyFBz1mtZlR1DPZeD5hGYpHOFPtq5gIhtbS/5pxYrvs0uaJEIpHRrPnp7cwjlLsqgvZM1Rb8lC7lDqTImRPYvtO/1qBAsGSUzxXKJ53Hz88QEpQOrZaMLXp2OFe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Michael S. Tsirkin" <mst@redhat.com> writes:

> Add pghint_t, a bitwise type for communicating page allocation hints
> between the allocator and callers.  Define PGHINT_ZEROED to indicate
> that the allocated page contents are known to be zero.
>
> Add _hints variants of the allocation functions that accept a
> pghint_t *hints output parameter:
>
>   vma_alloc_folio_hints()  -> folio_alloc_mpol_hints (internal)
>                            -> __alloc_frozen_pages_hints()
>
> The existing APIs are unchanged and continue to work without hints.
> For now, hints is always initialized to 0.  A subsequent patch will
> set PGHINT_ZEROED when the page was pre-zeroed by the host.

Why do we need this feature?  Is there any performance impact?  If so,
please provide some performance data.

[snip]

---
Best Regards,
Huang, Ying

