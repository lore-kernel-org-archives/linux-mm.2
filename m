Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55A7CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115738E0012; Tue,  7 Oct 2025 19:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED478E0005; Tue,  7 Oct 2025 19:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003478E0012; Tue,  7 Oct 2025 19:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E49178E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:42:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE8825872E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:42:11 +0000 (UTC)
X-FDA: 83972944062.03.0FEE257
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id EBD9E10000A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:42:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BlAiRmbo;
	spf=pass (imf05.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759880530; a=rsa-sha256;
	cv=none;
	b=qR3cRjefaTm3EM7Hf+4WC0K+GWe1uGxcddzx2fy/CUFjasFPm5gETqPAzD1D3fbs3kPzM3
	0NBHHkJvmgV6/3+EGfds24k2P850qlgHhOy7oCZ5Zo/5ZA57bkI200nwpVK7mAYzXpkFmd
	0fRLsKkN/jLf1ZXDpT6MimW0e1jVNa4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BlAiRmbo;
	spf=pass (imf05.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759880530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69vstxN5iaeMoAXTOwPIMnQcC6rAdKt4sbd5u04ANzU=;
	b=HkN89nmIG84PS4zYmtsPoXvQ34wW7Dof0eEPvtWhvBJ+e2Uh14nBSQ+4DIE1VG+6/KlDQd
	aQrwjn916wEDYGx3MXpYHdYWOD0hydNHuuP4sC8OHB18LrU6K/t10g/I7geukDJrK6Tb0A
	i0FF/rFylhrxAWQF+kGkYEyIaFJpfSU=
Date: Tue, 7 Oct 2025 23:42:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759880528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=69vstxN5iaeMoAXTOwPIMnQcC6rAdKt4sbd5u04ANzU=;
	b=BlAiRmboDCZPs7XL7X0mEv7qifobtDsgXHjmE+NVxUfqnUHgwNKlg1RYUpAdu8Mmv2mLET
	7gyRyD6jDILB8Ig4aahNRrnYtIfkoUlZZKqjml5b2JsK/crvXZsZgbDvWfPIn1fVX1/8BJ
	DHc/JefufH9NeS0RxKebXuEDXbhdqFA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kernel-team@meta.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
Message-ID: <4mziyxqm3nide6fh7xlbwqkuex4yf2tn6yzkwhzmy4mamazbxk@53an3oyd7amv>
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-5-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003203851.43128-5-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: k8xuoomq7m7qbtms8jdj8izxe694afb8
X-Rspamd-Queue-Id: EBD9E10000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1759880529-677470
X-HE-Meta: U2FsdGVkX18KuLCkcgQ0L5NS4roVo2gYOWUtrpN9i8APKL4tpp7ml0WOT9LCqf9iqxfI4XisZFTeddilwx/i22M8J7KxAczy9xBnPlYi7CrmBpaj4LY+E3cc20xWmAggTt0FCMjtWHs8FFhpv6JU6F7z2R0GOoZQ9nQQGqIYIp9WQfI413jGkzONmKrqSyYLkBk0cfUF4J/97DBZihWmOWif2Vgtf2TAJsDj5WkpDKKLIV5edClxRkeZS3+D/0GyMHCRBGScz0lVpWouEFVb1FgDn5YYfhyJzQIqo3hBV/dz6mRkboCPzHZPa9ywIDIyUvJi1itvbG0yS/tqgk1/gmLiiXF/vCkFMUr+EWqphAh9MYtwyUd1tBpNMXG2hsNHIemIGvqPHOt7HtQdFf0L61BCDXYY8o7KRQStXgCpEHM+XAZPAGP5WyUfPgVUAiI5KB9PI8LcRmdTEgpcHquyfDof6lUmYw7MZKZqnT+RHzm0vUnOuWeXZzvOA0jNrwDssSlLjxOidky40+j6js2Yaw4IGdoPko6IG9mi0rZf6M6KBrbM8yVia1AQUnmNVDk/ColglIRXAN6+6WRqlZmsk1AAImu9a9z3neYRjzAfOpkIH94lnN48QOalRlpIRvaqgC+nHWuLMRu48KEanUepaeyBkZRKiHXXXFallsPLO7wpkdT1dSMbv+okyqU8x1T1b8lpUMkCtOt35Fbnkn2Rg8CldgB8L3E2qlYZ00Oh7RW9GOk+YUBtMIrJpQAUzZnayiXozc7Kp7EGBZo1DWbj+px9OtJgeMwesQN9xhnoGcY7U+GeWDeqzrnNtRhKS+hnM4sT+5R3Ndy/OemiCP/Nxdfy/5RCj/GxX6npk3xV0R8mHhM6eS8FosudPFIW2/hDrVFvH1qlKPbI6aKoHJkUp6xyfFm/egA8Qlq2J5lYEPlavS6hOox7BL67C7INp7H4NkMfiXiyq6fkXuaZ4Qq
 9u9Rcjn/
 v/q8SFXx/aRYq8OiHkRvPW/F8qv4qJbD2tjKZaTimTsD9Igu/NloiESMJ6X5MHMx7RUHrBhip/dLweyIbw1bkLOFB7FxiD4LLROZIhHY/NvEGFNLath2i1EhvctMEoXTm2BQty/UL+boB7QT+DQt+xHYRBqxpAcb0M0ZSgoj4AD9D9sLL8TqErgIDZwpZ6LVODakZD50xlzEWbdrSiUwLrt5TnIWIRgfu85akTcZiL8BihTc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 01:38:51PM -0700, SeongJae Park wrote:
> The change from commit 796c2c23e14e ("zswap: replace RB tree with
> xarray") is not reflected on the document.  Update the document.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  Documentation/admin-guide/mm/zswap.rst | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
> index 283d77217c6f..2464425c783d 100644
> --- a/Documentation/admin-guide/mm/zswap.rst
> +++ b/Documentation/admin-guide/mm/zswap.rst
> @@ -59,11 +59,11 @@ returned by the allocation routine and that handle must be mapped before being
>  accessed.  The compressed memory pool grows on demand and shrinks as compressed
>  pages are freed.  The pool is not preallocated.
>  
> -When a swap page is passed from swapout to zswap, zswap maintains a mapping
> -of the swap entry, a combination of the swap type and swap offset, to the
> -zsmalloc handle that references that compressed swap page.  This mapping is
> -achieved with a red-black tree per swap type.  The swap offset is the search
> -key for the tree nodes.
> +When a swap page is passed from swapout to zswap, zswap maintains a mapping of
> +the swap entry, a combination of the swap type and swap offset, to the zsmalloc
> +handle that references that compressed swap page.  This mapping is achieved
> +with an xarray per swap type.  The swap offset is the search key for the xarray
> +nodes.
>  
>  During a page fault on a PTE that is a swap entry, the swapin code calls the
>  zswap load function to decompress the page into the page allocated by the page
> -- 
> 2.39.5

