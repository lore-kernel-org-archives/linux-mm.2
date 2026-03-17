Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B7AFEDA1C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06AD6B008A; Tue, 17 Mar 2026 15:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE9C6B008C; Tue, 17 Mar 2026 15:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BAF6B0092; Tue, 17 Mar 2026 15:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8218A6B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:56:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3458C1A0348
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:56:03 +0000 (UTC)
X-FDA: 84556611006.09.0C8F8BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A517B80003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:56:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TCUiiwbk;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773777361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTctyymJddg0yE+yrOjJEzTKqh1nBl/anjaKdS84pzg=;
	b=ILHa0tM1P/kBh/SZDkLCWRdQNQH5kICA9f263cKWurD3iLlXD6K76Cn4r6ZRbjH1gmVkec
	IWaKXTv57WpPM9Pp6L0cnxMcqr3SehaZtKRnecbvsZh8MKpp0rls6xmLJ/d2DGDXnYrPFk
	B51NFJxmXfthEEmKWL1RJTEfXp6TchM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773777361; a=rsa-sha256;
	cv=none;
	b=sL0U9YcaQkLiCjsWhaA1bBYQzsUFnAy1CZ8u8R8ACQo0vg6UKEuWxuP+J8gLMAfJYCXpcx
	b33sGdMuchFtwCigHsMsCxiuV00WzAUP/IUMhVXMOEc/Rfo99glBoKhzCxTD9xE1bmVsz1
	8T7Y9yOOq65e7AsLlr6QMe/a5N1JD+U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TCUiiwbk;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28B276132F;
	Tue, 17 Mar 2026 19:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412A2C4CEF7;
	Tue, 17 Mar 2026 19:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773777360;
	bh=84/Yrocy2s3h1aRMvrwLTg5dXCrLpngBo18sDPAgS7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TCUiiwbkHanOSlqU7zMUiNIFM+qG9DYxQxyaVLWgaR2XCJP040T/dl3zW+622zh+h
	 +AoucEiyCyEUPm/0FP37MKV8yHqxpECNiYXUDNHGge8/yKKEiitkgXOddDBCeg4O+n
	 s7Bw6aEkfRAjmxuHBCU958q6gT6n+XCWWhPFpj6pOuzm/mzTJF/H9G5WOL4h9VdjOJ
	 l9JFX1eBaphDLcD62YirDFVvSJs6oiUWTMvfaR94hQfj0L0VD+KVt+olVASrRy+aKi
	 wcUIwy6PNbwmgEW9Yf6KkFqyT6a/jsWZ3w2sYQqdhbPdLavMuQP3aVjNYiE1rQ+cDH
	 EtJ2LeRtDUpuQ==
Date: Tue, 17 Mar 2026 19:55:58 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 11/14] mm/sparse: drop set_section_nid() from
 sparse_add_section()
Message-ID: <6462237b-6a4b-4174-ae0a-bc6bd4e5838a@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-12-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-12-david@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A517B80003
X-Stat-Signature: tr4skitw5q89tbnpbcekb6ej65rykq3a
X-Rspam-User: 
X-HE-Tag: 1773777361-945937
X-HE-Meta: U2FsdGVkX1/HBld7wE+zAhhdmXGfnUowulaJgdFE2P0X+ogxyRbD+6zlJJ1UqvHxyttuax5Fx6cjMJunXl1WCV/vZUmC18Bn4AaFwRgDpZmXrSusqvvw0XMRtb3aWb2LV5kF8WQwG8aD3IjjGw7P+3jHs75e1sAKTZJEFz/MrVHvWX4kCtUoEpEmCXO4a8DV13l/rzHlMRiwCS/xQV2W121i2D0wsdrdlSoOUi3sICSXrLgFSIcQZ2BRdv3IYYAuMkMOm8V0S/kLQfN/BpmxiqAd5+0vkIh6ZYNJh970xg6pgKNQrbEkE0VCHUssZG5eW/K4ROgfxgvtPpdcF2lLwnCBvKrpCHGIwvuZVWxTf6Mlg3uH155eb/TxqBSwMIlwHVjpH9m40oEIwuF77e5mEZEz9zt0jMBDh113SR44qhSIrpytGOp+iBujX9EMG9QwJpvxhxBjonUkVoBs4X9MY6M+fexDAEph9xK6rQ32mByjkqfCr+2GGHxQjuHwY4PH0qiOkZI+vUcIkSMXTjItlJw1nJNECkMVpKP/xDJyWXGS9Th1geZjqEiGsvsqU+ENbhRt5/e9y2vR5hx5QeaauRAE2C1k2MGbgEgn6+bCRkQs55R2p7iheUUNAo4Lnt8JJyyWrmip1962zcmZLDGi+/VaU8/9iJhUdyMKezMLrl+t/soTCDgU8pFBc5X7cWbaLdB3k7v5EymS+Xa86sVleWhpE2uwL7llcWYiVps8QsaCu2qTtjhaXATB0f3G0F/89pq+thzZvDtjBMcmca0Y/dcZj3/a7tB4T0W7O9q5I4A9/qxQHNvhgCKMbEb4/OH4iBFZCW9VB6IowHJpZn/vupKsqEEF6XAhEXceaq/LlPw9zkgrWXqs9YD01b7eOk9G7FDd4OJ6Jlc+w4I0xa9SgecXwfPEJr4Ftt8dDd9vN5v0oCI5Wjmr6kvaNAzi2wlX1mndMinwKg0a6SJ5otW
 ShCk5VeL
 kTSwnxRpHgc9I7bXxPZuad9Q8X7rS/KK/855hApoEvR0Cz55Xicc1Z6XfdmijmDG8ThbVXFJu6rbe9sHgFzDB/s/C+OdTz6kfN2ZPTqLNkDVsBDXdHLlNkWB6VI/kKUBJb8BBlo3FoRnUhzWClTXRExj+QZbmsrfDD9quC2Inu5s8ZB/t2Qyq7mbF1V21i16KqnZiTuwdUmQVzh7RYufH8kEKHu4aGSp0yjaFn1d/yjhL1ONYcrAM6L7Ris6TmBEhiatOeUMrTYmcUG9VKGuQyjcH9dvzXr15f/Mg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:49PM +0100, David Hildenbrand (Arm) wrote:
> CONFIG_MEMORY_HOTPLUG is CONFIG_SPARSEMEM_VMEMMAP-only. And
> CONFIG_SPARSEMEM_VMEMMAP implies that NODE_NOT_IN_PAGE_FLAGS cannot be set:
> see include/linux/page-flags-layout.h
>
> 	...
> 	#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
> 	#error "Vmemmap: No space for nodes field in page flags"
> 	...
>
> So let's remove the set_section_nid() call to prepare for moving
> CONFIG_MEMORY_HOTPLUG to mm/sparse-vmemmap.c
>

Maybe worth mentioning:

#ifdef NODE_NOT_IN_PAGE_FLAGS
...
static void set_section_nid(unsigned long section_nr, int nid)
{
	... actually does something ...
}
#else /* !NODE_NOT_IN_PAGE_FLAGS */
static inline void set_section_nid(unsigned long section_nr, int nid)
{
}
#endif

Or more succintly 'set_section_nid() is a nop' or something :P

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

You may have dropped the call, but you've not dropped the ball, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/sparse.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 7b0bfea73a9b..b5a2de43ac40 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -769,7 +769,6 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>  	page_init_poison(memmap, sizeof(struct page) * nr_pages);
>
>  	ms = __nr_to_section(section_nr);
> -	set_section_nid(section_nr, nid);
>  	__section_mark_present(ms, section_nr);
>
>  	/* Align memmap to section boundary in the subsection case */
> --
> 2.43.0
>

