Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD165606A339
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UjA2xqeY
Received: by kanga.kvack.org (Postfix)
	id C61026B05B7; Wed,  4 Nov 2026 04:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11656B05B8; Wed,  4 Nov 2026 04:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27566B05B9; Wed,  4 Nov 2026 04:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97AC76B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:15:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 121F91C3D2A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:16 +0000 (UTC)
X-FDA: 85396877832.13.9F08CF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6951F100009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjA2xqeY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wozQOH0rL+df2ESKnkoR9U756io00+MftNixJAyhy9s=;
	b=3j0gQ1P55ErRKdhQElg690lO03szQp16ZIaYZMGRglkPoGNPrOMmcN70ZtfWEIrhgprVeO
	H4Oau3545ThgcRmq8LfbltICC6iTccHPqg4PGWP1xGd2udFMA7DvNs+6r0vK9mChhr1jYv
	8HLtoChihxn2RfnvgK1hmXZWs57G43U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783714;
	b=0ulBOQrz1ovSZL9Luk+0HEBcADaEPc8Gmy82rC8lMaTl8Vu+kj9TdZu3v+rvPjakOAnR1W
	tiH52yEnhq95Obbe2fEG9yif5VFpQXh+jATOCyG1MUk5HaEPwaXP5nO81u0z+qR7AFnKbV
	6ar/YgVgZo82JCTJrhUtYHMkZ6Avdm0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjA2xqeY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F3EF43490;
	Wed,  4 Nov 2026 09:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53D41F00919;
	Wed,  4 Nov 2026 09:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783713;
	bh=wozQOH0rL+df2ESKnkoR9U756io00+MftNixJAyhy9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UjA2xqeYEK80i7Ppq03lQvL9aj7w7aCpnwjVlKlY4qACwWrO1xNZH7fqcg0/XQYXd
	 0XIL1G57zMHPcLqouikUAlFkvwGNnm8TEe+24IPTE2jQRZRI+rAZV8LmaK1RNpS6CY
	 VgMsB/z+HEkEgNNiR4S3FJ+IcrvX5Lhj9lHuDF3O1rEdd9gcSgRk2fkShoJcQeaK1R
	 G8h5IWb1O1KAkMem6coEO1PTX2M3tQxZGkQyvjwPTBLfv46F0G9+q8RqQrcNpjeHNM
	 I2ikync2oN5s0Hu/SoQvjlVGu0ChAoqqCFzQdaQFzUwb8DVF/4rYw9Mm9jkHtbz6Ug
	 g1OvXpMbmC3ow==
Date: Wed, 4 Nov 2026 09:15:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Rheinsberg <david@readahead.eu>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, stable@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 1/2] mm/memfd: handle GUP pins more reliably when
 write-sealing
Message-ID: <aur3R_3_oz4Isjr4@gremlin>
References: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
 <20261103-fixes_core_2-v1-1-f332954f1df4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-fixes_core_2-v1-1-f332954f1df4@kernel.org>
X-Stat-Signature: 8dnaoji5mqxgtu4gx67ctafeubyz38bm
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6951F100009
X-HE-Tag: 1793783714-989806
X-HE-Meta: U2FsdGVkX18Sso5Ay8aRDVzH/YaJOrHfO3EjxakTrJSJBfwj+NTEiBRExLKn+8AC3CAcVIBUlLH+CmJSgobhU2mNNQNqQUDDTFPSNndi7wtZEMehej1NHJCHn4p0v/w0m3HJXm6ax1V+vgvAMZDC3mYWPY3cjx2zlFFX7Bp2WdmQl3qnY4FKwJsdK0bb4UwQoAHE26h/xhCXCsjcBGMvXSJBZAq2FNzoEhV+tix4/y0/ku9xb4FNgyi3ds9moiVcW9+JLxjOHMCTWH+3uSsJbaBG9X6Jbfmos5zh+SPpumcK8OIt2qbViBtw3Er6BlYhlPIp1pgd4LoDs4LpXl3hTnPETikO8XH1sR6bs8+O8bmyXk1Le5nanX6Mt03HfgDs8AqVUzC4rspFtP9QHKh/cr5QIe8oGILvMqtSNCzl8+jPHp6JdWgbCRyidmRgRIneuPAq9wjWETSwUg4/WxavjDdA+T2zT8pN04bwME/KxTIhGbToMbYLR5r4cI2TAUTFZsaxQZLWWl3DaVrJdTuDfcJWAbNxFS5qVpZsDShZTZF57YU204MC02ocVK7oCXLLbKv1WdyWmANFb3R5sdhfLIX6yjAe47zuQN/udIgAg0UM6jjUTG39PdJoOtoVz6ocIirZPtT6vEviQ/WbYzaHt3zv8oraJTjT/OiBhxJIgZ9Al9fKqXEX4UvC9Vdui5X0/SqJ/X2/7wMOmhdwPXgUNcvT2aej9jXeuBFa5GY9t10zmwyYOKzkDgZdraOa5a/Y901CPJQiqEeQxLFM967R+1TlKdv3WjI4HXO123JvSGpa+FN2EVcBBjrhHYhjZQoH5Kja7UlDXwmPJFq000hW/u6h2lfRjE4XW+BQ0eC/G/JuJ6HjL8qLrTwoKScASHAzzRLhL/bPXYjmGJ6htkwL9AyMG/1+3Se825cyBxSszc7wPSJpMQmmmdWnV91A5mHCbqotOIaM1hm6nUtqxRW
 eEOW/hO1
 1yeQsDW4+0FOuEj7WKcsaFF5XYVZlQC20lEGDnJFqVVDwiDIM9RlhLLK2tD9R2SArV+AyKHJdJ73gWuHt4neKx1O/KHcD68wW5KTF6kdBesMW+mIQlrZ0cNJ/x0AeZNOI5FTxNnx0UpuB/gZutwwY4Ym3iNX5MWT5u9awghudmFII3ot6q0jm3iSrUIwPF/TDLopy4/oHIjg+2uXR3GWUCYmRHcuRVzw+mbuHDpR4lGCYKnOydw6bk55I+tezF4ow2av0QqNipVoZ+/WaglseW6nKBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 07:31:44PM +0100, David Hildenbrand (Arm) wrote:
> memfd_wait_for_pins() detects GUP references by comparing a folio's
> actual refcount with its expected refcount. As spelled out by
> folio_expected_ref_count(), obtaining the expected refcount when there
> can be concurrent folio (un)mapping is racy.
>
> So it is possible that a changing folio mapcount can race with our
> check for GUP references, and F_SEAL_WRITE might succeed even if there
> are some, allowing file contents to be modified after sealing.
>
> For folios with a reliable pincount, detect FOLL_PIN references using
> folio_maybe_dma_pinned() before falling back to the refcount comparison.
> For small folios without that, the 1024 pinning BIAS makes it very hard
> (although not impossible) to misguide the refcount comparison.
>
> This improves FOLL_PIN detection for folios with a pincount. Handling
> FOLL_GET and small folios requires a more fundamental change.
>
> Fortunately, most interfaces that allow for GUP'ing such pages use
> FOLL_PIN, in particular interfaces using FOLL_LONGTERM. However, we
> still have some FOLL_GET leftovers ...
>
> Fixes: 05f65b5c7090 ("shm: wait for pins to be released when sealing")
> Cc: stable@vger.kernel.org
> Cc: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

All very delicate stuff, I wonder if we could somehow make the logic here
generalised in a follow-up?

Anyway seems reasonable to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memfd.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 0f6fff004f5e4..9eda4c3eeaca5 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -32,6 +32,13 @@
>
>  static bool memfd_folio_has_extra_refs(struct folio *folio)
>  {
> +	/*
> +	 * Use the precise pincount where available to avoid racy refcount
> +	 * comparisons.
> +	 */
> +	if (folio_has_pincount(folio) && folio_maybe_dma_pinned(folio))
> +		return true;
> +
>  	return folio_ref_count(folio) != folio_expected_ref_count(folio);
>  }
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

