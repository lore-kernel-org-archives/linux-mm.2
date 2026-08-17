Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECB7C5DF7A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5CAD6B0106; Mon, 17 Aug 2026 08:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D566B0107; Mon, 17 Aug 2026 08:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A9F6B010A; Mon, 17 Aug 2026 08:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69C116B0106
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:22:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4441160730
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:22:16 +0000 (UTC)
X-FDA: 85110673872.03.2435EB5
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id A3E3520007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:22:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SJIrd9Vl;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786969334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcRuYbDemapntKxkxm0nYno5F87CmpF/VTX8mqgRBG4=;
	b=10RWZ/8Xfu0qN22juf2Tvtbb6eQ5SVyzhIXFvbv8gVSE/voGliJeWMmyCfiUugUDPa0B78
	u8ejd6YbNaKRaGDSJvqUNKQGJ0m/6E4+swZIyHrcJeRsoE3ZMrn0TPgUGwtan6if6VIgUO
	ouWu2bWeqx8a41sk0EOAr7EFHbgGV54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786969334;
	b=3awt20vARCkCRsE7g5/SKl3HpfrpbuiFCK276QebmQhhy71d4A5lS/37f6GEjheTEagli+
	4aT66GTIyfZx93nJIa7Q1aQfGEaqOE6U+GFlxAZXSY5cG5hW0vU4M9X8vzYVGWbY4a1sYE
	+G1/sEfo5Tdr9+yi9puz6LgH7U7emDE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SJIrd9Vl;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IcRuYbDemapntKxkxm0nYno5F87CmpF/VTX8mqgRBG4=; b=SJIrd9VloOXaqMpJtvhltKrkl2
	iTbsrl1WsIGdJHF90ymVAuIjTCPKK2ZOjJc5PI8EtfGnSQ6HS3FJpx+uc0SxH2ms3jJXssrH/kK6Y
	eyd0FW39IH9MrtDv7N503H+ojnNfT8sPGwxoEe63BZsaVWrm7aV3ldi3Np+9XaBqyGobQp6eHdLGx
	+mJ2jH7woPjueWyCm0oEHu/UubQEkOrZjER2qkT7P0oDTUGFKXb0Rh4V+hv4Xq+IPC4IymxTzA8FL
	3roTeSHSo5CWIlBP8nkJrtd37M27j2FL9fOs5FSJWbE7MrGLtbrRYACjpi05JW/Vof/SBLqLreZWW
	WQGye5YQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wvwLS-008DhQ-34;
	Mon, 17 Aug 2026 12:21:39 +0000
Date: Mon, 17 Aug 2026 05:21:32 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] mm, swap: don't spin or flood the console on a
 bad swap entry
Message-ID: <aoL2hgmgQYk8vU8i@gmail.com>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813133455.3fe770eadcbe640e6f6c46cb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813133455.3fe770eadcbe640e6f6c46cb@linux-foundation.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: f7ry89snbbtmga5acm5qrncg1k3b9fc1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3E3520007
X-HE-Tag: 1786969334-883005
X-HE-Meta: U2FsdGVkX1/pLmupBuFAMyYSSL6i1ivv2ojbfPo2qZBlWTHkRSQGVVLUWJ/LDv28jSMy6SJM8I+S+tTkV0JILInFVqgCvhm2txEdylP6NIcW0HjT+N25DY2AsPxJjNB0LPotHYQR7UHHQ/K0PsyNC4q1EqLHD+38HFEkWRtLau9MHrrimfyQI/2HkZmtbmqiTUx+thrP30+zs6rfxxzWkRK60u/7ooSnLdGwpT5khZ//TpRYs6s1CjyymGaLcOtDFC0kgRr9hRHg2NcCV78SQSz+Xk3n9J3cMMjmvwhFAyvX3+G+ga2M2Z1UPI+tDnbf+u4ifiWfyVQ/GaF3nKPSaELy8+hSTk/djswp+ER6pqmLRzEC54q5W0iLHaeu4zjV54eGODsIwPVTJ3K5E9/zmKHHKGDX0AOhR1kVG36ELgleqbIoKKyl6cy9X69d6niQJ6cvS2YpJeopCsYCxRjhO2fYiwJXOWrIRTR1gP/8H+VuAg6xcTVoEN6kqwjWib/A89pvife9sEEl/ia1fV8fvCBkiX0TQNpcsfibs9FRKBy6Ak1eGzpt9OP0AsDRlXMwWDo1S2NTAPX7o0esPXFefycYe2GwoNcKtXZxyU1neujBV19mYz6LCPEllx8uvBL7drpghpZRJF0/2YWEc52Y6E9e33QbhMt8O03iWANrh1th7v0rzox1vv241z3iOnMYHke4u7l0dqDo0DV7881nd+s+w2G3+Q2CqfsrsDeLN33okq5piR1RmSpx5953DQpTUz5vZO4oMCoYu5KlmJCjlH5FcHBL5q4zIyD/BAIrO/oPS1j/u47NG5YT8DNB+QWDGEfLu9gN/AkLFqlAZnYkBEksNlP3Xqv0LXSbWpt79fJ4VA+j/nYGF25VTXCOl6tj9KoZ9f0i+vI+PCq0jNKpJ19wFIGvdWR9kDgx+F0xjLiLbMmanHWZ7mOUlnjCXnXCH26hJIdIc/tsrksJQEF
 A9x+2o1G
 xF9icFplTuV7KaaHtA5u0ctMO3V3l4Jphr4ppz8W5JEkn9VA55/9of02HPsVHLcHOO14edpcHZ+A2/jhkzb+rIuy4CYNoP1Z4yN+CuXenCBynj2vX2t/sFVfei2CoAAZbde8Zif9tMHowkFFuyaoRxuxMaZIxRubbFqCzb5N8qHslcg1av4bkCeKCPlrHu52ZbpHMuZfeUzgKVxskmQdO7KoTIJvBNGv+vCqZD/Q/A4bftvYp3TF8zhBibEBnedejdz3X+tyJ1OrK0xlsimODHQJQcRsZeHgLIvqMTQFYwF9djkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,

On Thu, Aug 13, 2026 at 01:34:55PM -0700, Andrew Morton wrote:
> On Thu, 13 Aug 2026 03:02:19 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > I've seen some machines at Meta fleet that show the following type of
> > problem:
> > 
> > 1) It gets some weird warning:
> > 
> >   BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
> >   addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01
> > 
> > The corruption is most likely the collapse/PT_RECLAIM race fixed by
> > commit 366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM
> > under per-vma lock"). But this series is not about this one.
> > 
> > 2) Then it floods all the monitoring of the fleet, sending the same
> >    message in the loop, crashing the our fleet kernel monitoring
> >    subsystem (which is the part that I am interested in protecting)
> > 
> >   get_swap_device: Bad swap offset entry 3ffffffc043c5
> > 
> > For instance, in a host today it logged 6M in a few hours, and it is still
> > going forever. Two things go wrong.
> > 
> > 1) get_swap_device() prints unconditionally, unlike print_bad_pte() next
> >    door which suppresses itself with is_bad_page_map_ratelimited().
> > 
> > 1) do_swap_page() returns 0 when get_swap_device() fails, so the
> >    fault is retried, reads the same entry and faults again.
> >    Nothing in the round trip changes the PTE.
> > 
> > Trying to fix it in a naive way:
> 
> Cool.
> 
> These behaviors sound pretty obnoxious.  And the patches are quite
> simple so hopefully the swap maintainers will make quick work of them.
> 
> I'm assuming that users of earlier kernels will want these things fixed
> so please let's work on identifying suitable Fixes: targets and
> deciding which of them should get a cc:stable.
> 
> 
> 
> In a spirit of experimentation I asked Gemini to identify suitable Fixes:
> targets and it said
> 
> [1/3]: Fixes: 122e201211e4 ("mm, swap: get_swap_device() to get reference count of swap_info_struct")
> 
> [2/3]: Fixes: 122e201211e4 ("mm, swap: get_swap_device() to get reference count of swap_info_struct")
> 	(and it complained that this patch doesn't fix anything)
> 
> [3/3] Fixes: 122e201211e4 ("mm, swap: get_swap_device() to get reference count of swap_info_struct")
> 
> And I cannot find such a commit anywhere, so wtf.

I think only 1/3 should be getting a Fixes: in v3. The message I am
drowning in is the Bad_offset one:

  get_swap_device: Bad swap offset entry 3ffffffc043c5

63d8620ecf93b5 ("mm/swapfile: use percpu_ref to serialize against
concurrent swapoff") added the put_out: label with just the
percpu_ref_put(), so that arm was silent. The pr_err() landed in v5.19:

So, if I need to update it, I will include:

Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
Cc: <stable@vger.kernel.org>

> [2/3] is "no functional change" so ideally it simply wouldn't be
> present in the series - we should aim for minimal changes when fixing
> bugs, then leave the cleanups for later.

I need 2/3 to expose the difference in the first place.
get_swap_device() returns NULL both for a malformed entry and for
a device swapoff is taking away, so no caller can tell whether the
failure is worth retrying. 

2/3 adds that distinction and converts the callers, but none of them act
on it yet, so it is no functional change on its own. 

Then 3/3 is the actual fix, now that do_swap_page() can differentiate
a retry from give up.

Do you want me to squash them?


