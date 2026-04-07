Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AFEEDB7E7
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604606B0088; Tue,  7 Apr 2026 06:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5156B0089; Tue,  7 Apr 2026 06:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAA96B008A; Tue,  7 Apr 2026 06:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9F56B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:06:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9C3A8C3B7
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:06:05 +0000 (UTC)
X-FDA: 84631329090.29.6F8C462
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 43C472000B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:06:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDe3atUF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775556364; a=rsa-sha256;
	cv=none;
	b=HQ8tvrLhtUq2Vu3W+yPfglwsqqYAUXFTCGB/Bf/SUNLC5rlcrZh7v9+V+LqNqcuRgGMGU8
	dsAk+IOEMIjdhy9nOg21uG/kvsaQ6ktPdWc8y8aEsv+vpsXzKI7sPzvuHGOIs6VdGxS559
	udaEcs1a4i/oHM58rvqeKJzIyWs3ZJM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDe3atUF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775556364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5rNUzspCCwbmUahVp36chMThRuJkZ4XpZItUDula68=;
	b=dGW5xoUwMRlzbPt+pCXLN7uSWL/N+KDLKdSa5VBiWtBl1FIstYzl6fFZNj1rWeNzu4FAmY
	Qjp7a7KMAySBW3n2mZ/UD4YNY7pWmQZgB6nPngy/kO65J1Wp7vS/ivPQrIylFnbFIZHDd4
	FSwn81loOeHIRCeY9Db1pON/A/oq8Gc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFF7660123;
	Tue,  7 Apr 2026 10:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C9AC116C6;
	Tue,  7 Apr 2026 10:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775556363;
	bh=xcNXJlqieSYqhdO9b7zc1ja/wDpDdbkAoWgTKktXzBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KDe3atUFrLcha8dZqpU20XliIYXYYBRVu4cdpDmyL3Y4twRJ7HmKqINPOZimaf9lq
	 P+MFlkMryiizs/wkxZXHmNoRUXXZNSD3GEBM/W/TiAR7Lalggq9/hhOctfAdMe7Coi
	 hEKxD/OfEBpOhJdeOYOX/pM48DAJ6+TIYvKJAdT2Tgyww/sTwF01ktJSmMkJLamRns
	 7E7TwHKpXq9XSPbb6aba+k7c9QVkdqTo2TxWiv8NlO6/sM4CA3WNaq8+L7gJk+2zmn
	 9YIQIlcFk0PSc/C+WrMyntX8vAVEgXSR855RWxo//guiaJz2NsKdb2fWvbyxvrhUsq
	 ySUTkLZNQa3eg==
Date: Tue, 7 Apr 2026 11:05:57 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, 
	shuah@kernel.org
Subject: Re: [PATCH v2 1/2] mm: fix mmap errno value when MAP_DROPPABLE is
 not supported
Message-ID: <adTWtnIMxao-_Fhd@lucifer>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
 <20260402235933.10588-2-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402235933.10588-2-anthony.yznaga@oracle.com>
X-Stat-Signature: g3pgy13zarkmuyk4hk4us8n4jzkhadjg
X-Rspamd-Queue-Id: 43C472000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775556364-17524
X-HE-Meta: U2FsdGVkX18VeER4Ebr+387pe5orn+69UVR8QrH+1uQ8+426WmTBo/me51oVb5bMaLxToonrTNkA1C0GL6wDYm42xXIazW4Ds2E+IrD3IELqdS+9hbSrR2ykQWt1yE0/psVuTKX2/iIfDUFJPjwEtQFKcoUwrjXwCFW/WYhhCKvrbXCtLWVcfOH9uZXl3H9ZYJwstk6mK2Ggw8nr/uSoR8d47VR0cMKavCvBMMRnvrl26VhHvvcugYd1wiV1BC7CWFqfRo4HW6WvNeIrZTPatlFY4qqz0H8y843j/n5BnI+6cH72OSsqv+fLulxv1JfX61qT2/72gdf4sSUsifRwfGOjHlrDNCO5M07+cwFG0DGXN08WTUsrc3vxDsv9HujVpWtVdCnFME7VK/kPETBXjEKv2bv1ly9SBomOTkq2nR6UqiEw/pmIGR+wKgNQ/ZN+BCZtaSP6Q0Ogt2bbYZcgebb3L6i/TFgMQo/D2CSt3YJxKMDoj6v6MAHe6koUOs4vn+/+SSOYAjphwAnO/AfWXSRNznhf4Kn6f4IeOka1eVNru5nSaqGoePHCtROTJZoLd3qp+vQbozhhCZmW8R6S2YOKT/kg+DD7cd8Sn8gwkSksX/8KRrI9waZUt4xbs91bqXgGuA61nqrDskyQmM7Lk1gF/B5AaNnCM9ar9JjiFEj6LhDr8PpSVJgY9MzKY4xF7Js5Ko2aEi9QJPaNQot0oMEt+VxteBHRZUNdlQOwBRGL+5N2pjq8Di94WB1FguSva8l3n/Y3iKniYL9p3SFNFVozuLlpbgPe1kVH9Dn9gDAXgiJEp8FiLrE09ODTDD9A4w+P2LoQw1VFcrStzsWJyyybFta22qsrqXZ2V0FapPDk4/nYBpTBEbk1qcG2YAXQQScjXrOFykBY891V8G6i5JYG+jo357djDx/4EmkVt2ncf7iwVovxhb8+eUsUlfE5A8ivQTlv9hl/LRtGMIi
 t7/arn30
 Z71Iw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 04:59:32PM -0700, Anthony Yznaga wrote:
> On configs where MAP_DROPPABLE is not supported (currently any 32-bit
> config except for PPC32), mmap fails with errno set to ENOTSUPP.
> However, ENOTSUPP is not a standard error value that userspace knows
> about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
> checkpatch.pl has a warning to this effect.

Hmm, weird it was missed on initial patchset, but checkpatch.pl is
unfortunately overly noisy about silly things quite often so things can be
missed fairly easily.

>
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>

Nice catch, LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5754d1c36462..2311ae7c2ff4 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  			break;
>  		case MAP_DROPPABLE:
>  			if (VM_DROPPABLE == VM_NONE)
> -				return -ENOTSUPP;
> +				return -EOPNOTSUPP;
>  			/*
>  			 * A locked or stack area makes no sense to be droppable.
>  			 *
> --
> 2.47.3
>

Cheers, Lorenzo

