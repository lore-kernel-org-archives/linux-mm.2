Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0B8C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDAD76B025D; Thu, 13 Aug 2026 10:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1F36B027B; Thu, 13 Aug 2026 10:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7766B04F5; Thu, 13 Aug 2026 10:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A258C6B025D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:01:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 147011C0473
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:01:37 +0000 (UTC)
X-FDA: 85096409034.20.9626904
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B388AA000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:01:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5pyqJYf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkIqkMTKmkFkOVJjNZ4y+l5KuM1u+wDEcZU7VVL0jWk=;
	b=aJ8ap7JshkrgXjBhX7JTK/Rz9JtRN/+rwJHO4EXX6xrUuYgMtb2h01FB1Ura/m3HTJfmnL
	67J58JYKTxeOuTMKHa8L/jMAvWczCd041I7CZQqUuw7dTqMFkWlE3SmdhOZcsyzrFQcui9
	OvblcgMdahCwda0r+zTOZUnxMkiyb5w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5pyqJYf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629694;
	b=oh1QVTCR5y1ztRoBEsaYJ6yxynOKL42YmCSzkfqYy4cVvjXufCm4ZYR9gzKKvMqi8+SvoW
	WejPHTVa9j28LY13qcWmVsreeH87ReFWIFdNtmMXl95xc7ge1aJJ9JQbpjEdkdr1LOrMcW
	d5LjDnC/aWqIhAsfXXCc9MFg4nayPHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2BE244E79;
	Thu, 13 Aug 2026 14:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AC41F00A3A;
	Thu, 13 Aug 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786629693;
	bh=QkIqkMTKmkFkOVJjNZ4y+l5KuM1u+wDEcZU7VVL0jWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b5pyqJYfyrjA8JeWy0+LAbakSmadU1JZ6YkaMIVF9pvzBsCU50kUUiGHT+MMTJL2X
	 CR6JVa8MmXk0Ts8uITDGupmcikB0MwBvhyU1PzKcJYuyFKXEdQF4HTRl3nfwiLBQu8
	 hP/HVoKeoj2WL9KNqEdc/GqgvS19ni7gqqCaSRHOwJkORnVrSjTKNssOPPMCzJ0N4d
	 fcw/pyvVFPh5AUddcwuooDnnTRHFYLnKqdguwlWXC2R/nAY1v/mZ5OWrzRC1omVnOo
	 PXCrVjUk6KWO3gN+wtlhL1vEXh2fCc8i0v2JbZNRONlWJLmAEEBDYoGWdM4R6iIEXe
	 KmGdQpO+YrsFw==
Date: Thu, 13 Aug 2026 15:01:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/page_alloc: replace custom bad page ratelimiting
 logic
Message-ID: <an3OI_aflDc0ZxO7@lucifer>
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811172156.356053-3-pfalcato@suse.de>
X-Rspam-User: 
X-Stat-Signature: b3i3uxqjc5w3mcy4uwfp4nwfkg3qsahb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B388AA000F
X-HE-Tag: 1786629694-844478
X-HE-Meta: U2FsdGVkX18rIBspTfFj33vAQjz5g4pLMa53IreFonFZLWaSMALnQI/IeoKFEno3Vj2Md2s4au3KOncT/Ggiy8NCzMWmNPFRiH+Hco0YGiknfLEKS6V2ieXg196CYAquzuofcx3YOwwJXdu8ICluSywT7wkvPwQzSp+abkokX6lMGn9OSDpRkKedKu/8oGvD3d69wrFgpTxHUIqZ3+r06Qocj0nVlEF36e6+9vpmj8zewKVJPXwnTrBnKL3IMQqNQ9+FEXBW32Ee9j0l869d/Pmqpj3FCf56md1RX5kQ2pf2XbtaZbxm+qdd4NOCIaGumzHVZQQwhfk4vLygphQGEITB6baKmFPEowthnIrrV+GAyepDqsUhnz7vn35xmrmegJLLy/PUXeKM8b6afXQXZceLSP5c6QmzePib17L8/ERtrmFKJW2qw2eVcYgcUbAnolHs6MwnjspwJ1PA6f98PM4RrIH57ThEihQBs0r07xsWyUM4wBvihGwnCLOfeiVosnME1wdh6E0NXOcgjdoq4+vgGt8WVmhh2D4QBnflEqKN2yajlh2sqKJ3cyyPjvItSnhTcApP1Ygwp/oC+zK/zBa9fRKo+jGlWT31vQrvGr1Dki4FwyzG2ybKnevLh8EQdyu3gzb+Mn40gBWoUgkyGs2YmGxGbfaM8BRPc/ZZ77M6Xjh1fFLyAQ1tUp61QOPmiW6tvsgKr6/HDgnpiKjNzYeNYQfjn9e1ORLF3GsDwzvtghq1Ud6FTAOHjnottkR7jBD5hQKQ4KgHGJsqWmVaGU6oFdugVDUUoV/C3+AF1x6TUTbHj3sz0QK8JLh1iJi+zQBTQNKTjdea08oKpIO8AHvFBYDsctn5YM1CjoK1EH4mHdFKDs8HlVLqdxZQBkmJGKpgtNxG4p0nSdOdTBgfvE3Fl9z/ca+awgmKWG5pHvkr77kbLYv9CoDdi5Oq6psrZgOVHO0sfqsf4up4ZgP
 b807hlno
 O9WNJIXG97UHJZ31l7etnhhaW37qVbDJqTMqMdlZYSaCpe7iPqg7aoQvcwdYfFiU9dBfylzokff2Orxq1RWh/VXli2Q8upJ357tXl/pAMqLHC+K447Js8w6soF0vm2ur9BzwpGUngJ/D6N0FeHzWDlDFfS4sdjdKJUzhxoJLUUZdmHSyhJGjrDrM4Cs8tM7FHynd246kbkCIm/N/3n0sgriQilyU3Z7rzgh8HtYSR/WzZ290p1SNxc7hzJg1WJfIbfjHHBmJJxsbJHZ2L+UkKj/V2lpFKTs7wm02G+IEZkQJDSCJU9pjUVCCL7gvgPissBF5j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:21:56PM +0100, Pedro Falcato wrote:
> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kernel.
>
> Do so. The only functional difference should be that the new logs will
> read something like:
>
> KERN_WARNING "bad_page: %d callbacks suppressed\n", ...
>
> But that should be fine enough.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/page_alloc.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..9ccfd87bc273 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -613,31 +613,13 @@ static inline bool __maybe_unused bad_range(struct zone *zone, struct page *page
>  }
>  #endif
>
> +/* Allow a burst of 60 reports per minute */
> +static DEFINE_RATELIMIT_STATE(bad_page_ratelimit, 60 * HZ, 60);
> +
>  static void bad_page(struct page *page, const char *reason)
>  {
> -	static unsigned long resume;
> -	static unsigned long nr_shown;
> -	static unsigned long nr_unshown;
> -
> -	/*
> -	 * Allow a burst of 60 reports, then keep quiet for that minute;
> -	 * or allow a steady drip of one report per second.
> -	 */
> -	if (nr_shown == 60) {
> -		if (time_before(jiffies, resume)) {
> -			nr_unshown++;
> -			goto out;
> -		}
> -		if (nr_unshown) {
> -			pr_alert(
> -			      "BUG: Bad page state: %lu messages suppressed\n",
> -				nr_unshown);
> -			nr_unshown = 0;
> -		}
> -		nr_shown = 0;
> -	}
> -	if (nr_shown++ == 0)
> -		resume = jiffies + 60 * HZ;
> +	if (!__ratelimit(&bad_page_ratelimit))
> +		goto out;
>
>  	pr_alert("BUG: Bad page state in process %s  pfn:%05lx\n",
>  		current->comm, page_to_pfn(page));
> --
> 2.55.0
>

--
Cheers, Lorenzo

