Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC73FED9F0
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D9D6B0098; Tue, 17 Mar 2026 13:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574D56B00A0; Tue, 17 Mar 2026 13:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1D26B00A2; Tue, 17 Mar 2026 13:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8AD6B0098
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:19:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02D4D1602A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:19:25 +0000 (UTC)
X-FDA: 84556216332.10.1805CB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 660D5140012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:19:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h5WyPkLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773767964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/rqSEWfynNCjmSXmGnKrPp3JCVcRSW3WHs5ZTd+dwQ=;
	b=IvYvSmtC8dxPe/UEcW5b9D8Q1E2drYVPGjHfdzzIhMOLrUcDtka1oiYwRDVmiWyXLrmS87
	jT0V+rTFmnb0e1k1/L9gvod6h8DkWCGnxoUQJRW0Ihb/L4iVFr7q3DAKH53hmY3t1DArdT
	6QNM1ssFK8CJwMrx9ctrKy441R+ar/Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773767964; a=rsa-sha256;
	cv=none;
	b=SxfXb3YMzhG0MWvEzJboeRGCbk7BD9T1zkZIhEiQi20kyXw0V/HzAgbN8O5CWxRBgrnPg8
	6Te0wZep0J6Y3nkc0wO5p/C5EzHjzdIxTNGgYLHb/VUd8CW0OSP9BPQ2wcNngcZoSzzDQX
	uZvycEHLohNK1wBKsTJaWqjkBAnWhzA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h5WyPkLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BDC91600AD;
	Tue, 17 Mar 2026 17:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CC0C19424;
	Tue, 17 Mar 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773767963;
	bh=PZU9tIsV6USqDXcrCGfFETY9fHYZa8i3ji2a+gAm3wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h5WyPkLMO1HCGbefwv10wnKMCkgsNH8nVFdIV3GCV409M/70k3QhHQOyTAjY6o538
	 67kZCxkIwAmtNA+CcqrRGl6dUW2wLIcDduAgeBK1hrlg7gJ496np2ia49V+YHcgJmk
	 rObd6MzsHdZW6neDxMVATVncFHYtGwp2YjQDe2q6dzKWQJB1VsH4bvkGLzFHdbRLI2
	 pyDdoFL03r5daL6+xqSvUBYITG/zg7s4BXoM877USEa63iaCVvrt8zu9ryyjRiz6d/
	 SczeerRphx/Qc8u66mDg/wRx7ufs2NHombOEu0YvSluvS5DgPLstfZfTlBO86VULOO
	 K3Givrrw/s34w==
Date: Tue, 17 Mar 2026 17:19:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 01/14] mm/memory_hotplug: remove for_each_valid_pfn()
 usage
Message-ID: <caacd86d-4c92-4a8f-b0ef-a152d2cc09cd@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-2-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-2-david@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 660D5140012
X-Stat-Signature: k81zyaogx9gthqtj3mmokikpikom9d16
X-Rspam-User: 
X-HE-Tag: 1773767964-742752
X-HE-Meta: U2FsdGVkX1+6cGs1r45ttVGm3jxbdB6+veZX5jEk8VdkDiRnCn3oEkzNCK8ig7Dq0/HrPgcRB2jKSxaMOmd8q/P1gMT/cweuWwKjEc3jktnJCCiv7zU1Dhg/KBwqHiBPttWPvXWxBy1RX/kHQ6hJXkKFbKLVZO7zRSz9Bo+djVKYE1YsQbc1N7PWl+QF5ivqr0VygMbqVM5sQ6YYIBs8t9KTsixfHuDtEhkjM46IMCdLGPQX+pas3JcnA1gl/nGI8gTofOB1r4M9p4oCr07aYKFOLhqi+7nqK79pS88du+ai8OU2hanOhXrCeA4TAAqbOh0UiEU+xdIPQiQJLdCed4P50C4DO1lL/wsi/2RVHbRyPmNP81mQLokE0bG9o+b3pv9EDLm+L9AGjmpMsfybMDr69SJWXT+y7stcXrSbizDM9ddXCVQ0bbgUo+QL9vO1djCORsrr+/ME1wyK8Os0pzoQp0+xuSdceIi4OdJud9RkwBGSUUHpEVhNFpX7g9wFalVZqBDPBbl0m3VLTYZSebGeDZyIPULuB9xWqO+XQ17wf/qGLoHFJFB7Zl9AdOSWH6U/pP3E7cEFsn4ShXsJtXT4Zs+24UGSljvof6Q8hCKQLMcWt+lmZLJlvZNP6xA2JSd/YBOK1IXXc6PT3VAe6DlMbHz1zJPZOqFEdM8n6DoldXvnBdZNAp9cbxPTDfpoUP+8ZXNvhVkaEri3qUAl8oYPmfIjnFGZgxpq1AZzN0xmfaQNP6P6VYVnn0y7erbRFklCA3dBErGkNn8AzZBHcK1FR01aP7ZDL7FDs/t/L2EIbRckNTk1jLKMslP5yc0xrJwijK0tG4pV9gy1ld/lKEgm7nVAWp0AjGcTNgY4PNdainOPBmbliQiQCXif8KZVShaZ8AT1Ziqni4An5oo3GqtzeazSw0FZoFsrLC5hy7UHqnKlZEWRq8LKQhrYE3XJuKaABUUQC3ZWvok5LiQ
 /PN3LG+j
 lHj3pMsmmDQ6NsjC9nn8QW9k7j96HVKZGoNpPF9Ms7rG0SevlBZtrX67P52C1MqD7+v0cMxnN8wjFCNc4lIC7X0+adMkMIX8jjimccraq/J/hDXl9DCLzFnTxyzmmW9GuxpwKLFQ885DdhrTmxrel/X9w0gWuMQsOjKMfen5HYXP+WS/me8MS0r8pyy3t0evlNGJQ8kltRtxjnBUtg06frvQL4p9cqO5RYExeiWlag4inbxsL4P/RArQVS3j/MvlVxb5y+1Hk8F8CuSwcW3tCE8LTx16efvENkEAg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:39PM +0100, David Hildenbrand (Arm) wrote:
> When offlining memory, we know that the memory range has no holes.
> Checking for valid pfns is not required.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Holey Cow! LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memory_hotplug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 86d3faf50453..3495d94587e7 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1746,7 +1746,7 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
>  {
>  	unsigned long pfn;
>
> -	for_each_valid_pfn(pfn, start, end) {
> +	for (pfn = start; pfn < end; pfn++) {
>  		struct page *page;
>  		struct folio *folio;
>
> @@ -1791,7 +1791,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>  	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
>  				      DEFAULT_RATELIMIT_BURST);
>
> -	for_each_valid_pfn(pfn, start_pfn, end_pfn) {
> +	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>  		struct page *page;
>
>  		page = pfn_to_page(pfn);
> --
> 2.43.0
>

