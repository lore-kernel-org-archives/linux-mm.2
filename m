Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E54CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09AF8E0011; Thu,  6 Nov 2025 22:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2618E0002; Thu,  6 Nov 2025 22:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1DE58E0011; Thu,  6 Nov 2025 22:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B04048E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:28:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D6FAB7FA0
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:28:31 +0000 (UTC)
X-FDA: 84082378422.18.D320AEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DDD861A0005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:28:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AArFEai1;
	spf=pass (imf19.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762486109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KshOcUgMIl1CfWOWXtBUmY449Qz/92AN78XeKVINCC4=;
	b=S7ZhhUg67VK6qx4esIMgXOor4hSQilDIiEY4hskqrpSW8uCMxY/CgyGZTNRwgEGWE8eLwG
	oMTKicOUIg1ptDj9Zg7uRJvjMYo/WjJmQKScGnFZeP/Q3zPzAEElW3vlV5ng8F/aPV0dvP
	0zM26X2ekLsPpyYBN2Zy3cYCstOSCOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762486109; a=rsa-sha256;
	cv=none;
	b=b210kmSkmmrxpsCd+aVLdumBJrZRHj9vcnq4V9vLE3lvhkxMTRuf2q9f9OMyHJ9XQA9b8R
	msrrDjym1BeCiiSn2s24oLuzNljExx00GLKwmWqL8U1N/1dPbNfizLSj62hd140hHmV1QJ
	XTpVHyh5p4t2xJ8iz0Dqv48VQgLSxok=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AArFEai1;
	spf=pass (imf19.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C384601A7;
	Fri,  7 Nov 2025 03:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574C7C4CEF8;
	Fri,  7 Nov 2025 03:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762486108;
	bh=aybGlQtaizqxHm41GGb/A/kHPgiZ2DKdD6qW18vbYSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AArFEai1JWZvh3gNP8XXmOc05q7SzaAXjuoWU0mV5vEgOlhQmmKJVxOSjfyYixzQ3
	 vi82Fll+cAMAtHKg5Lc2nmYm35CFw6RaVGYIddIgCeVmuAmi8kPUd/YxBcEAwliYah
	 zPEU5HCIRHS7YFmStaNogEcPvh2NS1I1GhGKzUL9cZgVfMCusGEzPbZSSzj9CkDd89
	 TXbfVN7y49QKub/B1CKJMsDTvnUrR+Nng2KhsMM2MYdnmrpR1r/lQ0E2av3VPQ7hUg
	 RRxPX1oCj2I1VH6+kZC4VNVNo6mOF5i0q+LZ/0Enom+4fOBRcusaIwS0Z6M74aMIgl
	 JhJIpAzozGX8w==
Date: Thu, 6 Nov 2025 19:26:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/9] mempool: update kerneldoc comments
Message-ID: <20251107032648.GA16450@sol>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-2-hch@lst.de>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDD861A0005
X-Stat-Signature: mo5w1bc3sk8tr7mym7rf1j18cfzgdd9w
X-Rspam-User: 
X-HE-Tag: 1762486109-350634
X-HE-Meta: U2FsdGVkX1/e6rrPv+icflcLVtaTDuywIJTH2aZqqHjKkWeN8p7EokW7/ygsGJVgPYTwvBTI/tdErDatRLRE1GmFzC4aSnceXH/CpYxdCt/30aIAW1lueXxA7tnWAmFvUP63Afr69rWpcb0FkmUkkmFGYrI4oUaiT6BCJPiPA2rfiFTHm4ctUJ9tPekCs7jyLMpUj4Sf/8LdA/ZNdw0mxj7V9Sptz2sNan9DS9rwMv3ZIqqOU66YvUtc2D4/RTQKy3wdpKtxNLdVa7DTDqGzvIi1tGHCppky4kePtbQfXvYTMLlTomRPoA6dRg6JJahhqgjOc3/+EEdYbSVlPxM3hfCRbNYjkyJyAbRQuHWOWdbiZUqOLviDWOX+Q/8RxJHCAgTMS9zfHTJjw9yD56gvN705d9GW7ijdz85+4GPX+Qpm/FGug/ShTr5fA3VLBblkSWfYJhG67RdWd2k1jh7/wAenMjMJMUzpsWnx0d4TcqslI+9NHWepRHJu6eV4SdvKDJvtCaRXBoAPiKqZw4PdeboqzVSad15Ngmq1vSgYueZSzwjuGDAZaIXb6IsBiKKdLgRhcm0sxa0/1f7I4w0T78zmUwroW7oa9QVaV6EF2nK+YqtM+4vcZ5lJyfVN1OFvXU0vhgkpMeXaym9rTaONgSo6Q19HfqdQoE0ylVOzzjWfdrMvpqhQKakv/x6QqC47wMQtj2cStiYhexJyckRWc4d2gbwdtuiEOJVQXwpbfZs2ClNU/ugEJXKG7P4iMu4VXMlYwST90pH9eR9gAp1U2szPbRHiGE0SoKDlF25vpzUvWBRa+V5SYG65TBdUDm6LfdwpWCelwvJ5fVSlBkqkO6GoLaNOEYES/5aswVjo3s2UHqkTTZ6PRMwPEFNb7j/duDrCtPD2Z/tlyXza7gdUpKgB/EOLhbEADFDVMRgiGOYFc603vJgY6OyN5hfaFosveb5rPYwilqo5UOJA3+6
 FIeChWJZ
 g3PMP6I6s+DzIYkhQLcwmjSyTeodSdooqRxCCR4KDToGfq7p1qpUfOwl3dxDQCVXZ2EjfQRy/h8qAfqtI/zItNU8fBKxmBbP+DfnGSxbvctXT+GmyNYExa0aQcC6VraA4Mhan749HmmPmvR/RnmmmDeZdlqSpkZioW1T1EeZDbIv6t5UVRLgakTaTanDGFWymZFyK0tbgD3gxWc7C9oD1VBidhSlxaIEyK/ilpYuMf0vAV0EYloGCQ6p6/aOmkYL9JyaV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:31AM +0100, Christoph Hellwig wrote:
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 1c38e873e546..d7c55a98c2be 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -372,18 +372,15 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
>  EXPORT_SYMBOL(mempool_resize);
>  
>  /**
> - * mempool_alloc - allocate an element from a specific memory pool
> - * @pool:      pointer to the memory pool which was allocated via
> - *             mempool_create().
> - * @gfp_mask:  the usual allocation bitmask.
> + * mempool_alloc - allocate an element from a memory pool
> + * @pool:	pointer to the memory pool
> + * @gfp_mask:	GFP_* flags.
>   *
> - * this function only sleeps if the alloc_fn() function sleeps or
> - * returns NULL. Note that due to preallocation, this function
> - * *never* fails when called from process contexts. (it might
> - * fail if called from an IRQ context.)
> - * Note: using __GFP_ZERO is not supported.
> + * Note: This function only sleeps if the alloc_fn callback sleeps or returns
> + * %NULL.  Using __GFP_ZERO is not supported.

Maybe put the note about __GFP_ZERO being unsupported directly in the
description of @gfp_mask.

>   *
> - * Return: pointer to the allocated element or %NULL on error.
> + * Return: pointer to the allocated element or %NULL on error. This function
> + * never returns %NULL when @gfp_mask allows sleeping.

Is "allows sleeping" exactly the same as "__GFP_DIRECT_RECLAIM is set"?
The latter is what the code actually checks for.

>  /**
> - * mempool_free - return an element to the pool.
> - * @element:   pool element pointer.
> - * @pool:      pointer to the memory pool which was allocated via
> - *             mempool_create().
> + * mempool_free - return an element to a mempool
> + * @element:	pointer to element
> + * @pool:	pointer to the memory pool
> + *
> + * Returns @elem to @pool if its needs replenishing, else free it using
> + * the free_fn callback in @pool.
>   *
> - * this function only sleeps if the free_fn() function sleeps.
> + * This function only sleeps if the free_fn callback sleeps.
>   */
>  void mempool_free(void *element, mempool_t *pool)

"if its needs" => "if it needs" and "@elem" => "@element"

- Eric

