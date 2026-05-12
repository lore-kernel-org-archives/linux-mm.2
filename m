Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701B2CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21C16B008A; Tue, 12 May 2026 10:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2606B0092; Tue, 12 May 2026 10:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE87F6B0093; Tue, 12 May 2026 10:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF65A6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:06:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 780AA140370
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:45 +0000 (UTC)
X-FDA: 84758943570.19.93B30D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CB9C740019
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VMwv/PYL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyW2RPjoRrauDloWfMPz4dabHfcu84ozYf86Ot2KhNU=;
	b=hz3bznwpUl2u7u83/E2fn1F02/sm6Fyy42kki+hNV9gkayABXAPOlW8IFZnZALttlTT83K
	UOUnEdUtoQObULKyHJJzUDejLQkdSSbjVxdME8XZP72IrlLTxO0Q4Mk3c1Q6zLQtyNVz1G
	LhFPOqyVaKujOGUnSKmMbRf4a0jp4ac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594803; a=rsa-sha256;
	cv=none;
	b=TewmMzrD2pNGf2b1zbXT1iV82VFplgAkekHD0spBhLNKNJzrTpNDzyPHsOKNKdFxdfILWc
	xHC/7Nx4jM+qk5w9Rh72pqwoBKyyRacKKwEkiMvqRgx2u7OiPjxLtdu5v0e7DVgnhL8i+x
	mdfZozIKzAf2VTB7bz+mlwqc5rmc9So=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VMwv/PYL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0285662C1B;
	Tue, 12 May 2026 14:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64388C2BCF5;
	Tue, 12 May 2026 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778594802;
	bh=l8rlIftvUwZSA3nVW/yOkWdGvGYk/uXyMrRJvJWFUmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VMwv/PYLaQ69DlNxjWQ2j43T1AFY79ij4iokB7EeOKbyrAWlwfRbBkMabIl17U6uL
	 XSXRDqVBrTa9CHG5VeHjNo5Y9U4cC7eSw5/z8TYlfjSwpakekcUlQnKEKUsL3/XBuL
	 XsK2Lr5UzPMQ5ZQNxwhPq51f/NxNcp6XcDP6iz6JS1qTCZD25Jx257dT1OWmnRcJBL
	 JcZTbWbhR1erUZ1cmbILgtIYEXbHjARiWXdprmsXJflT8pn4XdZJzmmYGFkviv+WAK
	 HB/ATVzZl/YdXZ3LRXUiIMs2Vm7GVsl81DI5nAohxGZd2n5kxJa6h4RUjLcEM+Yhif
	 y89q5NsyUreYA==
Date: Tue, 12 May 2026 15:06:37 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix mmap() return value check in
 run_migration_benchmark
Message-ID: <agMz2PftVnfzIQpC@lucifer>
References: <20260512101305.139509-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512101305.139509-1-lihongfu@kylinos.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB9C740019
X-Stat-Signature: nf57ow9fyyhumwkxwjqn7xhg5d4e14eu
X-Rspam-User: 
X-HE-Tag: 1778594803-346559
X-HE-Meta: U2FsdGVkX19n23JBj01Jzp507siln76QGoqxWKdVC4hYN6xM5q3pUeq3bs4/00Ivl+B989jbnbh8xadUWnvTwM2tQml2Zz0sBpgMVzC5KVdT3yb8fG1S+8Y/sVnKLil4uIvq8V3kyyECqRO8hIaDHeS1V5d/Mn7xh9g3hg/bYeIYxfS9z92uE5f/8ldkguPwLFg49Q/iHE1/w0nxs9Y0pOkixSO+IIoIwcipKEv4G6mEXoF6Lid81o/UkyzYAz3qhAdFES2Jy7AkyPoGvNuJMzXTfXP0X+pYFc1VAr6jXxIGCQLXKoE9YXrBUmi3IjnpPhqdgHtWzO9ugeptX35sefm+TXX+Ok1E5RXcastnl8CptHrCZMUiasNXe6TFw91WIxui9RtJasOKPg4yVX0gA27jCc9hCM3tTGSH5up0wCt9iwuHEMll3UrjZJrXdiX2tJOx/3RE30rWCalRxzYtMEpYP3dwlQ1Llsy4GzqqeN8MRFfSAB6LrYpw/pXb3Uf3S+HcgKZWWyB03nrByR607ERKOK6j0Eoko5sSOuRdz3oH2cWw/jI1/G+w8SUvQDuxL3y/MiX4ovYeFs1S/llBqFtRqtxJ0MW/Qp7riLKfjhxelIVNuKY9sF8IoiRHgjP1QRKFNMns0glh5kbWi/HI2VGY44O2U0wpcGTEh1C4xgWO6vre0iZwRYIjKbcPxwggd5P0Aj0qN4oyrRBQNzJ49Dp9ImFnqN6osLpaFH4A6ZBCv5lUXMISPH07V3AK3H+ZAPMJDvS+qQ70G8g5qYlcSC2LxXUSiXWI+w8hjbxVH0UgSI8NlH8PO1tN0MnkKeL9iNis2OENB1XfGd8glxr9MoWu1h8czWKr04ejk1Oez27b22GraLkUoYXGMcZ6W0oVuuuOb9wyuTlteIY5CT81NoDya1hWzFIwADtHSgj3Ype8s0Ld7m5Hbl6wLvNXokFhk+E54DSzg81jj3r+yXK
 dKrkF2BA
 PlfwWZFD229vuq2NJCOKVnlYsSr24Am9ZeTHiRgCNRiVTty0+ELq7oG8px7fo6cIfVQ0bXKwUM2+bWPKIDWgQzj0+whGCqUI2sv+St0YpZf8SosUHpHYf2SbuJ/v26LNrFxDHFae4XUpYkcvYdSo1nKl16K+fWot1uNFqSWtNPLsNZgcts45BnOYjD7BbZ3RwQlBAlKRcBXeezhvgeQv7Za183UdTLKV93oucI5uymORbkWxa/NeiBjpphW805vg8RgW4cvegQ/6v2Bc6yjy+3QOQuImaBJCWdKZprphqtG2hKdZQVvsF1Z9SBi9WbM2hdnij
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 06:13:05PM +0800, Hongfu Li wrote:
> mmap() returns MAP_FAILED on error, not NULL.  The current check uses
> !buffer->ptr, which evaluates to false when mmap() fails (since
> MAP_FAILED is (void *)-1, not 0), so the error path is never taken.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/hmm-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 788689497e92..d72adba5c74e 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2688,7 +2688,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
>  			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>
> -	if (!buffer->ptr)
> +	if (buffer->ptr == MAP_FAILED)
>  		return -1;
>
>  	/* Apply THP hint if requested */
> --
> 2.25.1
>

