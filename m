Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B215FF36C31
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 07:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F5D6B00F5; Mon, 20 Apr 2026 03:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8D96B00F6; Mon, 20 Apr 2026 03:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE276B00F7; Mon, 20 Apr 2026 03:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89A1E6B00F5
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:13:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1DDC160946
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:13:31 +0000 (UTC)
X-FDA: 84678068622.12.0BFB85D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B9608000B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:13:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5Km2TZe;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776669210; a=rsa-sha256;
	cv=none;
	b=b3T77SVPGrjN3qPICoANmKqKTu66D3EDxV4+CPZt8cSUroJWugNzLu3A3uVHi6cX6jqKVq
	LG/oZ9KnNJUfZ9VRksmJDzHQM0mFB7+Q49svqn5YUHGKm2j1kN5F+BpM/v1/YFlTzy2qRG
	L7MEKLcOkuQ8Vojqf/qqYK1ElmNohM0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5Km2TZe;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776669210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OOkxXT314zgkCbMJVgR33WQVdo5yDJLfeSxoAafAnE=;
	b=z2jfjR2gyN/IRLXmVwDfmqx/6Wp6yZtEHKUF7PRYSbk0HUMC3CrVJqmQwQ7mPT/uxdMbUV
	InKbq2S8py99B9cRAUQKRyLAwVfhtj0C78GlRSKMcUEh3Yq/mYbXyR97tiNncCHn/2vMG6
	BYIcRmN3vPOh6SRBN/iXCstf1B55BXY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F020641A25;
	Mon, 20 Apr 2026 07:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC7FC19425;
	Mon, 20 Apr 2026 07:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776669208;
	bh=9eukM2C8gRicLu7CaCXCE0c9KR81w7+tGO0F3PmCFCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5Km2TZeIdwP4xKxqDr3zA22JtgWHKuj5SC7f1P8o2qQ/+RpiiJTKY0wBk/oVmbdS
	 UV89bWG569ImZtIfED9Lyi/NcDP1Zd9YBc98hc/TOpngY6F2VbOReUTjjQ7xyCbi1H
	 Wc6s9x+1rpVRUVPfyG4cSZWb6f/RQQ2gFQn37ORUDhj55ckIP0lhN7y5LFL0z/gVOy
	 /QVCpveNacFpeWvBaOy/lIVtv7HOMm7WDd2+yESQAOHw+xPoIJGKbJmTRAVDozLFQj
	 wXBtjEQOT5LuqxXG3IYtez2S/K3Xd6wVpmEP7uuBL3e3c9RsiSCnISfaMu95brIyB/
	 xwusZV7SuUMZQ==
Date: Mon, 20 Apr 2026 10:13:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH 1/5] liveupdate: Remove limit on the number of sessions
Message-ID: <aeXSEe9Bo-vsSkMH@kernel.org>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414200237.444170-2-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 0B9608000B
X-Stat-Signature: jtqh14hjbjdq6haek1j67nn6x18oo1gf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776669209-915657
X-HE-Meta: U2FsdGVkX18n1oRvLioJDLD7rbbbrhyI2y76/Sy4O8i5HUbyotDMyQ9dzLzjj244IMN2uzNp8E5aATlz8Aii6w6lMq94e6FQ/EVkN9veN+ESseplF7j4ae4USMsiiipiJsVKmqwFckLbPvzwTgKloyh4GqHIPK5BW9vna/fzPtlKr98nnkklh6tn0/E2DHv6eVN03RndIk/z2Ali1pd3sA+n5TlRjanlXk8uPfk4ZSjNf0wAws1deHj8swoNmbrSAV983Y+YeViMWUvwQpiNPIrI2Tg85O+K7TDWR/u3Hpc/QKwg98KbD+nxXspibAMRkfnWjVSTVxhjsEuK3c/rLUaoX9QBg+IPTZWAPWJeKNY8Arx0V3uRX0TSqYE4ewWAKpFXrEEsil8Uh/ZQxfHoRXerSTEuC8Jyg2oZCApJlrEslLUdgZb3pJ/w0ttn4h6ewnfNDnQFMsFccaILMopOWux9OhDkZVexVPZ8oOnI2zg1XHQ1JnXwLykyISgizdPIKKLAd+g1zzcm8f7tQEn9BmenxiDMMJESmv6bWtRZeBOWibzZGIKrfqvEsgjbV4KJ4CczvJNj3Cyj2MyGiG63w5/1b5KKUf6ZXsjjJqlvVBm55QR8jEOZy+6zPc5wzD04nvTxpgDMmpxx7Y7fT/ADlQHX9qLB/2btPvSmDoOuQEOW1mDJR0UBcarszVPzQ56z+RBYwNlyf3a4glNpWGguDruL4Inu1OuyF4uuKaDiWm7Nfb5cuVzgHlWVz57P5IGdwG5W3OiC3+jmdchPm9IluR9DLXXZDxjCo3/KiMdv96Dxq8gg7T9VbGEnWMuulRbn0DoQWxeXw0QEiybN3+9H0gNg0FGQKsRW2vqeVvKZlaj+3gYIU40hxi/7SmEdUeW4SRGNwXzHTi0BoQJfG/gacIZONMYGGzslrP+84vWl5fKMI7JQ/7iQIRZFc4hNQRgZTfebdwFYmPS0Zb/hC8C
 S8PIM9LU
 693DMfNkTBosTqwM6yARuMGVX4sTNhgTMCXFteUUgUFiiJEjfMQycq3gUZLt+yq1QsPfSlRwa/mjYL2PKLB70LFI+Vlm8+LJZ9sqvNPv2LzIMqrS9EZjKKx9IAszqAUJd0tdO7IQm8H8v/HLvQa5+Qu84urv+ZMWBJSepz0e1o27eO4bKay2DDVFjpxENM+JCeAxQ4yXwP2yriHuue6/eNePY0sEoTOsWk9TZ95dppxaKKYd1JYtvKoMKiBolma6Ks2WK2OcbATFtH7T1FvTzpmVouQjoof8ItX37rA53D1q3g5mBwKTXJUVwWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 08:02:33PM +0000, Pasha Tatashin wrote:
> Currently, the number of LUO sessions is limited by a fixed number of
> pre-allocated pages for serialization (16 pages, allowing for ~819
> sessions).
> 
> This limitation is problematic if LUO is used to support things such as
> systemd file descriptor store, and would be used not just as VM memory
> but to save other states on the machine.
> 
> Remove this limit by transitioning to a linked-block approach for
> session metadata serialization. Instead of a single contiguous block,
> session metadata is now stored in a chain of 16-page blocks. Each block
> starts with a header containing the physical address of the next block
> and the number of session entries in the current block.
> 
> - Bump session ABI version to v3.
> - Update struct luo_session_header_ser to include a 'next' pointer.
> - Implement dynamic block allocation in luo_session_insert().
> - Update setup, serialization, and deserialization logic to traverse
>   the block chain.
> - Remove LUO_SESSION_MAX limit.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h      |  19 +--
>  kernel/liveupdate/luo_internal.h |  12 +-
>  kernel/liveupdate/luo_session.c  | 237 +++++++++++++++++++++++--------
>  3 files changed, 197 insertions(+), 71 deletions(-)

...

> +/**
> + * struct luo_session_block - Internal representation of a session serialization block.
> + * @list: List head for linking blocks in memory.
> + * @ser:  Pointer to the serialized header in preserved memory.
> + */
> +struct luo_session_block {
> +	struct list_head list;
> +	struct luo_session_header_ser *ser;
> +};
> +
>  /**
>   * struct luo_session_header - Header struct for managing LUO sessions.
>   * @count:      The number of sessions currently tracked in the @list.
> + * @nblocks:    The number of allocated serialization blocks.
>   * @list:       The head of the linked list of `struct luo_session` instances.
>   * @rwsem:      A read-write semaphore providing synchronized access to the
>   *              session list and other fields in this structure.
> - * @header_ser: The header data of serialization array.
> - * @ser:        The serialized session data (an array of
> - *              `struct luo_session_ser`).
> + * @blocks:     The list of serialization blocks (struct luo_session_block).
>   * @active:     Set to true when first initialized. If previous kernel did not
>   *              send session data, active stays false for incoming.
>   */
>  struct luo_session_header {
>  	long count;
> +	long nblocks;
>  	struct list_head list;
>  	struct rw_semaphore rwsem;
> -	struct luo_session_header_ser *header_ser;
> -	struct luo_session_ser *ser;
> +	struct list_head blocks;

Don't we need some sort of locking for blocks?

>  	bool active;
>  };
  
> @@ -147,15 +222,6 @@ static int luo_session_insert(struct luo_session_header *sh,
>  
>  	guard(rwsem_write)(&sh->rwsem);
>  
> -	/*
> -	 * For outgoing we should make sure there is room in serialization array
> -	 * for new session.
> -	 */
> -	if (sh == &luo_session_global.outgoing) {
> -		if (sh->count == LUO_SESSION_MAX)
> -			return -ENOMEM;
> -	}
> -
>  	/*
>  	 * For small number of sessions this loop won't hurt performance
>  	 * but if we ever start using a lot of sessions, this might

For ~8.1 million sessions this comment does not seem valid anymore ;-)

-- 
Sincerely yours,
Mike.

