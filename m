Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C1FCF2588
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0946B0005; Wed, 19 Nov 2025 02:14:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90B46B009D; Wed, 19 Nov 2025 02:14:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80146B009E; Wed, 19 Nov 2025 02:14:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92DC66B0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:14:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60A49B83EF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:14:44 +0000 (UTC)
X-FDA: 84126494088.02.3D7AC7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D43371A0004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:14:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYCBeCyD;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763536482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQrgpy8JjaEHyZqJA8eDLgJamo/HVbJwYqaGe1sVdzM=;
	b=z8t1v5X1HdL8Ss56xWw2zasYYAf4E9/ncx2+OL7JkX2OLzydXy7igHm84JOKAFS7u++Gko
	RwGaLZWhve48IDj6jFXOvuurhaO1t+OwquIXX3Ok0sl4x2a+6/1mQwt+/4czIpjW81TZPG
	rnAGi9eeHjArOd8F/K4mQV1VpasJ47c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYCBeCyD;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763536482; a=rsa-sha256;
	cv=none;
	b=RuSvvQu3hBtOIVmdk/p5XdMdRVWLe4Rbv+tsMRCs315jdl1J63q/dTNR7fF32RfSOCI5jo
	aaks8l/Lvwqk2+IiEFph//y8s0OurmrDdzlqyArvEHUuhB6H8Lvbzb+CNv90RVZPI/noc/
	vrD5/mGbKAoZ6kONOcN5yTdEq+BX3p8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AD3360123;
	Wed, 19 Nov 2025 07:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE36AC16AAE;
	Wed, 19 Nov 2025 07:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763536481;
	bh=KnK2LwaTVxpBAnGwrP0tBXDqK6jOFJ6w3qTM2i6eO4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iYCBeCyDe0Hmh4FfKgfEdzfAO4ZrQf8bQrN0P2JurnGdjoWncjpN00tOiseNAHhyD
	 pr2K27K7CR068BZewS9sL54E9liZKy8YPv0UZDU1S233GRIVK5kmL3wE2xnqvhYFx7
	 qEOnarB+NxZFiQU5OWNtyj8q2WMAr6MTS1UDc3l2JfBFKyn1N8fgnKyFh4WDZBhbEA
	 00KFkpNarLFddOUnoDL4rgiEcaRLIL09Y1Sefcpdrl416oYCEc26BTywiDxOBwFVDP
	 ie684kTjlQMNESnMb239J95/Sj6TLRC3DNn4exOGC4YZ1MhWuqHxh2Dy6kpxiJCjHc
	 xu2xYl817psIg==
Date: Wed, 19 Nov 2025 09:14:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: free chunks using free_page() instead of kfree()
Message-ID: <aR1uWvLu5Hlneppp@kernel.org>
References: <20251118182218.63044-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118182218.63044-1-pratyush@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D43371A0004
X-Stat-Signature: jw9whexyn5s73rk3pg5f4cb1crsiibim
X-Rspam-User: 
X-HE-Tag: 1763536482-574643
X-HE-Meta: U2FsdGVkX1+5TJ9kIOSQlzNO4TqfKgWV+4JWbRfWZP5KLztqV5p1vQFBDE4yXdAklh4HIqSXTT752EcGsPa7lzn+4rb7j+bgpdabg5Q4qCL/D0B2StqzB3vz/8nvJAFk3AZHbM4slKBMRRb2FWc9LLA+kYK6xEQ8FX+vteJ/G10YpWUOKUZ8J2LOhSirL6ADbD+k8N+oXaM6R89p55lrhDjiwQN18pdl2Cukq/MFMoMAEJZzeFVSomJbhrFmj77Ggeg+NDWBDfI5G0B6WnMXLRajxOvRdKCbxCuRHrQHocRwahsy12vbJw4vb3Q3Kf14XY1WcWtaFT70Q9PZzDiSlhPhW4dp2bRU5HEVcoXJod3ii9U4YyiKN7xiL02RN8H8PFH5u6JDfWNqQWWhw41f8ZhABl1Ya2mxAL/ccJICH7E6Is0zdVAyH6kMrLhlpnw9CD+dornwHjgqyKaVdakF0baVb5vQFAy3cmLy0qkOyavKdROYmAavUMyU+kWapimLTcEEoJ51KwZfPUm71ygerg7ttKFP+nfEU04tI1kSSdZMerl4DkSzeHSWX4JvaoqYwYz2GwF6Soxg7FZL4Uzk6V4f5tKKfG65nS5qZBYT/z20HvKoxxWfGVWM/RtKo6U/mLIA8e4xjIqYjsRqYGyTOgx+ZRmMGYmLJzOypBjbR40/445nLjTeYb3/I7km0DuZORTgRFWIctURQpATwmRrvHApCNIBKYJpgbqqOrVn+Oi1W1Ui3nJNfwblxvjPjh8SMSMbUybHY6mqkzxqSrd1N33Ku+BTda+Oos4Xu4KruKnhx7pv8z1dgkBwgPcnoAn5qsO7zNdPIxMAAo27/ko4QSWh29LNc2/lWfhCUWd+ozy9sBlzPLtwgyXGjmFRBXXav4I5pZ1i1bk7oDmMivINnNNxQcWEJTRW9HGJ7c/ElqbUYYqHXnvlBpxZTSXZcmEX4jmEnzs2DWeJYq4XABl
 MpAwKwuy
 PaH96EUa+ZKuUtEcs6JPi9wtyzrlvYVqn40Vj7O0h4CVC06oQIeW19TDNvIrf0JoGkp31J4pehTrC8EwtzcL83OceNdjszx4L8cTPHI0Gi2DYb8r2dkdwWQglJu69v3HeQAHhstamzeEPfL3SirXQ/6T/JKaH2YjaggWREfjJACRySC5vQgxl5MLAPR1/ppRu9H3Qtu5ba9GmYB1jCtoyR/VWB3IF8YwWif9tmsjT/92g5WQjHV1eAQXH7BW4UhDe1+mosAsxPmrS2uzG3SUy/b2JBM6XbVRKiLVl5t4FqvSA9Uy6adc01YU7fk5Io0QE8gmp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:22:16PM +0100, Pratyush Yadav wrote:
> Before commit fa759cd75bce5 ("kho: allocate metadata directly from the
> buddy allocator"), the chunks were allocated from the slab allocator
> using kzalloc(). Those were rightly freed using kfree().
> 
> When the commit switched to using the buddy allocator directly, it
> missed updating kho_mem_ser_free() to use free_page() instead of
> kfree().
> 
> Fixes: fa759cd75bce5 ("kho: allocate metadata directly from the buddy allocator")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Notes:
>     Commit 73976b0f7cefe ("kho: remove abort functionality and support state
>     refresh") made this bug easier to trigger by providing a deterministic
>     method to trigger freeing of the chunks.
> 
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 515339fa526e0..6497fe68c2d24 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -360,7 +360,7 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
>  		struct khoser_mem_chunk *tmp = chunk;
>  
>  		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
> -		kfree(tmp);
> +		free_page((unsigned long)tmp);
>  	}
>  }
>  
> 
> base-commit: f0bfdc2b69f5c600b88ee484c01b213712c63d94
> prerequisite-patch-id: f54df1de9bdcb4fe396940cdcc578f5adcc9397c
> prerequisite-patch-id: 800ec910c37120fd77aff1fad8ec10daaeaeddb1
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

