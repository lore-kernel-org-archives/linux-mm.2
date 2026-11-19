Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C89606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngrIqHBj
Received: by kanga.kvack.org (Postfix)
	id 4A0B56B05F2; Thu, 19 Nov 2026 04:33:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4783F6B05F3; Thu, 19 Nov 2026 04:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4DA6B05F4; Thu, 19 Nov 2026 04:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1266D6B05F2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:33:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EED7409D3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:33:38 +0000 (UTC)
X-FDA: 85451356116.19.ADBAEB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1163D20007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:33:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngrIqHBj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795080817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zs8KmS6M0tc9kdI4/Q5qCxRWf3GKyv2JX51WYmX/Mp4=;
	b=elLwMPApOtDMRPaTRS5jNusRGvjetyK6fY1s9jJh5NDVRE+Dk18QFvqMDm1sPTYy2nswLr
	+nJZPisc8skWGmYqHGLd4RR+G1eKWQjqlDQihfK+9LwAhTB33B92P9E+OAl6hGuC1Y+amR
	aW889KSyUHnj+1Qqt6CAgJSFb2d8MDc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngrIqHBj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795080817;
	b=5cr3iR4yWuge+ttqjwiONKCI/M3rZhozBlQnu15VTaVDLniZKTuYQmnrowvdnkZtI+kI2/
	rya6uoeIJ+6LnUstny6HnAAoOp7UxTVkYesdZC+LsJi3uMpZtbW01ax3Hb1pZrwbp62ne8
	8kyyNISq3YxR9z5d1I+XWJRB15HKDtk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84D81612A7;
	Thu, 19 Nov 2026 09:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51011F000C9;
	Thu, 19 Nov 2026 09:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795080816;
	bh=zs8KmS6M0tc9kdI4/Q5qCxRWf3GKyv2JX51WYmX/Mp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ngrIqHBjgVYdx/F+VW2lBwdufHaaLpZ49uNS+5QElhcbhKI7WUfcXO5XcpWxdaZer
	 5I12Pj2zNHxyR7JKGqjEageIt60T85FtPYb3L9n8ToxBAgovwz/E5D96mwlOhhniuu
	 OG/U8Ui1vqEh3B5gxHtEQCACMhuUCYlBkRdaipBu3WNcz7svfU/221+kSCtmSYiDDL
	 gryUxrqGnwNwCjVPBAuiCKfrgkVk7mEsXDY4Qa1F086QTGLabM4C+Y8OL6/Vn2nuTA
	 75gwcgYKo4KXq6XplCTi9qW9uo63hudHLggJNcjcaJKqIirxi4XXXGk0X74An23PVO
	 KK5RxRkZQqGUg==
Date: Thu, 19 Nov 2026 09:33:28 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH] Docs/mm: fix stale split page table lock references
Message-ID: <av7CVzXLButoMsSi@gremlin>
References: <32FBD023F945BCCE+20261119074854.252609-1-zhaozhengzhuo@uniontech.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32FBD023F945BCCE+20261119074854.252609-1-zhaozhengzhuo@uniontech.com>
X-Rspamd-Queue-Id: 1163D20007
X-Stat-Signature: p48byf3r58xnn397z5n4t4z11xdbrz4k
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795080816-236082
X-HE-Meta: U2FsdGVkX19zzMsu5ILiBa1nFK71i4FIUcMNfv95x1FVEbvEmaaN3Bc2vvVZABUsS9Aw0dfybrGYbrsUZoPU3jWivEdMucOcSBTakWYaGQa+gggYNg+cYSxp6ceBSqD4G+rfI5RYTTV6c8Tmnwg1KvamvdaEkxPh0Rzhy1pbXGqcRfcWfeGJ8X4xS/WNdHv2LNX94SZddasDPPq7ixvoD+15e4t6lTxg8KBZk4ILRFMDFbv+qJg13VQx0esvYfdJH/nJb4ezMy7Uq1sv9YOeQ3h7r3sof4xRJD8o6CJ77eO6e+QLKcRprhwrYxeEL8yUKz8DzxWnzNwdiZUbHv4SXY420xmRtKu/e8pRBfu0Ak1mVzJLAh0L3jobeA0K0nOM7QIBfiJX5nuA8o8DutY9jQfxITM7TpT2AOKdKRGqeLr0nW6MgEItmjUicJhaiXvC6svSgixQlpYoakvAUUyAwcTs/YTT7e7FlHGgAzmd8B507x039OS6tTToFZkQyff6EDa3hFQSX52o7OoDasQVDhGrEbsJxQ7SPrr5UFSsuxjQOAUZeiHveUDucSLVL4RK20poE13ThC/GRH+6G5lf8MyxovbmYoqWXuQq2Y8znxOdqCNTtsM/oYnGFK08rs38GRqDWiFrjy/STCq1ebRTMvQ2eFQh9V9k04YCX+E/Hl2/AlXV+msIP1UahHOiGqSbnfgMzACGNDds+SQ2Bx59ARMJPNaiHFqtL0KaFWl0Ja4L/vfi0HgE1RqMZp7/DhODkETxGwnnxA5k3J0F7a1hTDkVuliIwV4yxh6BFXdqWxaukFPpJgSd2kRk02fnVN7wdvn2iOhhj9oP9hXfzimZQ3VO6ZA9FdUSzQuUfAkquijnEka1YyMjK2aMxIJVbomlCMoC0VACrU8h60xq9ShEEBEoOK4LF0pdpuG1wQFn7W0u+5E8Kar8736MHP1CIYuwn2BaIAKIW0nKG6PlFYt
 5csA78vb
 rVbBXowxEpAEEceweay16rqHRBupFJcQgkeJRMCHRbYe8a7B4i8phjSnRyAEFyCUXcEqaQbLpZE9EHFErQiNEBR2/JNdMUbIoxmRSfMcJvL5VpllxSpLo0VVf84IJTBYbeZtmIQxpHSfaBz5qNBOCvQgqyrddsXVmI5f07qcry8EjgfNW0H8lc80lvtPMUyg4QdMZZDHLXvic7nfnH2C4IX2/TH1sFqBJ/5trYisZ1p/VTUPgjl6DmoSONzEBp6scQfnQgOiJynsA9vYEN5gfLub6Kpy/0YAqOLW/KctyrGwFccuhqgWk5JUD2GkbJv69xNY3SIzO8z5OlJdbVe1JleR09/9LND9PfNAtGG1FrBLqChPItvkEnVLyHeVc6VxV3SA5v9yrN0GHkz4bpEIT+GwBXcjjoUIU0FVn4nk38QX+FS+hMil3IMj5XDGskVMBB5GW6VwdV0cthF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 03:48:53PM +0800, zhaozhengzhuo wrote:
> The USE_SPLIT_PTE_PTLOCKS and USE_SPLIT_PMD_PTLOCKS macros were turned
> into Kconfig options, and CONFIG_SPLIT_PTLOCK_CPUS was replaced, but two
> Documentation/mm files still refer to the old names.
>
> Update both references.
>
> Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

Seems reasonable, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  Documentation/mm/process_addrs.rst         | 2 +-
>  Documentation/mm/split_page_table_lock.rst | 8 +++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index 04b649818cc1..0b6355e6d1d5 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -659,7 +659,7 @@ acquired in :c:func:`!__p4d_alloc`, :c:func:`!__pud_alloc` and
>     references the :c:member:`!mm->page_table_lock`.
>
>  Allocating a PTE will either use the :c:member:`!mm->page_table_lock` or, if
> -:c:macro:`!USE_SPLIT_PMD_PTLOCKS` is defined, a lock embedded in the PMD
> +:c:macro:`!CONFIG_SPLIT_PMD_PTLOCKS` is enabled, a lock embedded in the PMD
>  physical page metadata in the form of a :c:struct:`!struct ptdesc`, acquired by
>  :c:func:`!pmd_ptdesc` called from :c:func:`!pmd_lock` and ultimately
>  :c:func:`!__pte_alloc`.
> diff --git a/Documentation/mm/split_page_table_lock.rst b/Documentation/mm/split_page_table_lock.rst
> index cc3cd46abd1b..ce7908bebce9 100644
> --- a/Documentation/mm/split_page_table_lock.rst
> +++ b/Documentation/mm/split_page_table_lock.rst
> @@ -37,9 +37,11 @@ There are helpers to lock/unlock a table and other accessor functions:
>   - pmd_lockptr()
>  	returns pointer to PMD table lock;
>
> -Split page table lock for PTE tables is enabled compile-time if
> -CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
> -If split lock is disabled, all tables are guarded by mm->page_table_lock.
> +Split page table lock for PTE tables is enabled at compile time when
> +CONFIG_SPLIT_PTE_PTLOCKS is enabled.  This option requires CONFIG_MMU and
> +CONFIG_SMP, with CONFIG_NR_CPUS set to at least 4 (see mm/Kconfig for
> +architecture-specific restrictions).  If split lock is disabled, all
> +tables are guarded by mm->page_table_lock.
>
>  Split page table lock for PMD tables is enabled, if it's enabled for PTE
>  tables and the architecture supports it (see below).
> --
> 2.50.1
>

--
Cheers, Lorenzo

