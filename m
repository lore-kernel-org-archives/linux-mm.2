Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF11FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8255E6B0088; Mon, 27 Apr 2026 09:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D63C6B008A; Mon, 27 Apr 2026 09:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC6D6B008C; Mon, 27 Apr 2026 09:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE716B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:12:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0FB51C008D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:12:31 +0000 (UTC)
X-FDA: 84704374902.14.5467CFB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id BEB66C000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:12:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HqkYlS8R;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777295550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79uM2Zdks7gEgsRotpWu+/1rf8zg45ohibw7xbEt1AU=;
	b=zxrpoM6ZF1JW6R/8kKQHq9NIi6JsjyJ5KzrG1wPMOuyEuEjjVAxj18cwz6xUeqWwIFnHMK
	IaIkJeEcInS/LlSBmBWWGerIdzhZnkSDYG4YXr9REbWlHieFsZMouxKoQPRLqwNNX4ipy0
	+3MeAtlF5MpKAGo8fxSmUSVJL41RM4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777295550; a=rsa-sha256;
	cv=none;
	b=XmnjHU161E8TZwYFNATsKPARg1BYpxmPBPsn/7qPnhecSe++DsIe0oEPfxwZELiX26DwyU
	9MT2cxcac/EDrRwWWvwjm7riaivdojASICeeLWpaAtfQ95dZlHBdqLJe281dp0ysVWWeZT
	IZsm42VzmGgv/Pc7F66qx1mtCZLp7Kk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HqkYlS8R;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=79uM2Zdks7gEgsRotpWu+/1rf8zg45ohibw7xbEt1AU=; b=HqkYlS8RO8wHIK9MBGbTtiUrlD
	EOWiP9QV/zxAAwwytmnW21ZAZja+yrHTT6V9KAokVDmJEMYHLyY5wvzDthtWo4vCaJ0EhNr23Ce1P
	KaRFfhqSBegTIxQYgsx1U9zjnpTL9W1Z0fN5k870hAXSqIZgY5ifzGveiQyKUwcLtOBtbkuPjXBm0
	MmmxKMr1OG05FSgTvY1+qek7+N2IhQiMnKODOtwbS2K2HJ1kC1w3aVNaUyGFjp5C8SopqCeHF+3TT
	nYPNv8PpvWRYiEPmaxsylHfFYLVwOl3YtKqCDEu/jx2pvV5DqOsP3Zig2nWy3c3P19RGfR1KYho46
	2nV0i8nQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHLl4-0000000270I-3FhZ;
	Mon, 27 Apr 2026 13:12:18 +0000
Date: Mon, 27 Apr 2026 14:12:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: remove page_mapped()
Message-ID: <ae9gsjJolKTLeoZR@casper.infradead.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BEB66C000D
X-Stat-Signature: 3aszy8xqqemkbnbz8jn9e5mkykuotnj3
X-Rspam-User: 
X-HE-Tag: 1777295549-122080
X-HE-Meta: U2FsdGVkX19oVuVum0rEly1c5Q2uDPnHDlYjedSb8AlzMcJ3gwFHgSMCXDlvQyOP1JlW/kVJrKgC1FxKbCCCq/Y6tWswdSCRge6MggnB/Qf+TVXY8y+qdd24mQIz/9IrVRex3w79w+PcZST+LXwUeE6ujUufBY4isxoktE3X1enKggA3b7Hl5xAREiC5a9XaqXQCGiUpZzvyiGtFyD/EdiirGjs4wr2JdnkVETuWX7aX3brijULXprsLp0ixf7CMQiwchYZM1LU7jFbaHIvS1PH234UcJt5qqRhK2XzTgmHmkkx6GrdrthoZOAI5JyVmLNrPzpZRFkuVjpEI5AnumfAPP7h2R6EMRaSlvTuoqHepmLOqPt8MTblI8ACy7Dyx0ixefBVzIM1lbpnJe9prLXfzOswbI8mWmR5fzi4JPPjWvEAREuV+9AJUJWz6pqyoL/TesG8CgdM39Yhyuewm1NVEFD+G5k8uuejhjUhuTzItUknYgkS2rTsBzX1p+jwFhNWuaxnzWehVMEsU53lWvFL6JF26MUUShJiDVWgZNX0l7v4F0NTxCSnGmRYPO5w6LyRCpttMLj/YOgArhZCNt3IABx8vjrorJa+H4F6mX3DKmOfwHjY/S2xZRJhZ/VWc2gRVmpk4kBfF5svnXbhvpXWEY3gM5QqSF8WDOOuqtnYD8vtTXVOnOZ70pxW1D+NG2PkMY1F5z1w4MqtOKEBd1V0VPzadk+Ibvek4ty4rJMc1jakwQK1GmGcieQjZEN0Pa7kROx/l1QlEsJEaFYNU1qiFey8EPjdi8tmpeDCJRG//HSiVgtesnKbtne3jM4SpCgpDUp5/yu6p3qUPTdWSqQ0wNVgF3s+RmixiY6JCCmRtaTz0xNc0f914K1AGtIGwAlXeCBthYSGufSu5kNUdKG1bFQKu6SLn08pzDqRUunLpy4Avrpc9Db3nM5nt+tbHI30FYSgnaFcQ0P7d1Jb
 VEx9PXLA
 /9ydbwE+95Z9zgF7raylvAzpFHv3tbJea97Bnzc0YtdoQn912pVfEwZYjd76tXFN3S0CimwGP5JeOOz1k3FJ31ltuDp66NcEgCIYoCm+a2mInVJC8rvvZQnNN/7hWCzRrI//lKCl/OWdJwW2Adob/AgMUusaRjdiiIqiAiVf81uJbVFpPSyyB433Cw/N4MF9LIkgf9Zcnjnkd+DAUVsNXEYScg/o7P847GlaW5+R7oGw7xYUxggiIPnS/5AYuQMa7vge8JZw/xw4fB/Q7Pqf3oDkclO3/M5zYvEdL/Ud+r9lmX4p8XasG3DzyOLy07DeCEyfys5acHG5O6GMnhiz7gfORUvOobHr+gKu0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 01:43:16PM +0200, David Hildenbrand (Arm) wrote:
> Let's replace the last user of page_mapped() by folio_mapped() so we
> can get rid of page_mapped().

Yay!

> Replace the remaining occurrences of page_mapped() in rmap documentation
> by folio_mapped().

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> +++ b/mm/memory.c
> @@ -5464,7 +5464,7 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>  	if (unlikely(PageHWPoison(vmf->page))) {
>  		vm_fault_t poisonret = VM_FAULT_HWPOISON;
>  		if (ret & VM_FAULT_LOCKED) {
> -			if (page_mapped(vmf->page))
> +			if (folio_mapped(folio))
>  				unmap_mapping_folio(folio);

The idiot who authored 01d1e0e6b7d9 really should have done this at the
time ... Oh, wait, I see what I was trying to do.

I believe my thinking was that we only needed to unmap the folio if
this specific page that had hardware poison was mapped.  But no, we need
to unmap the entire folio if any page in it is mapped.

Does the affect recoverability from hwpoison?  I don't think so.  When
we detect hwpoison, the first thing we try to do is split the folio.
Of course that can fail, but if we do, we kill the process.

So yes, my R-b above stands.

