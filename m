Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF804C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8576B0092; Tue, 21 Jul 2026 08:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50DF6B0093; Tue, 21 Jul 2026 08:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42FD6B0095; Tue, 21 Jul 2026 08:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 837496B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:00:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03D164011B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:00:20 +0000 (UTC)
X-FDA: 85012641042.25.C19E22E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23101100010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:00:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BgLyqCcb;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784635219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJOW6Bs284w6UGW0mn4mtnqzhNAFZ710mf86ogBRyqI=;
	b=PgPllXzekjxKwq/nKsL7SS/tn+S1XBm5CmJe6M6QYybHHY+BTgFVLuJjLPreHOaWthvNrS
	tYMLYvmJLt2diH/3quqZMsSnmTKkPyG7agIKvq0QhfYjqm2x7IFWcXSHsik0ymDAD6gJHY
	F7KQyjf8rSSc7xILsmzj/3iZvNP5qH4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784635219;
	b=eOm6h/ICwx/2qBpt/fjCtbF0+qhJv6ll6+pEqtWSa1+4HcqENR3cW7LvY6pNmVfDxEAXnY
	lFTKuWzp+vhV+wqnF5pTsWySbdETaTsHckB+eoGxFsvF0nLwyQKulxzAfwyv45EWnE36KU
	vb49ZH5Bp4b+flxF2/2g4li2Ck3lXpw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BgLyqCcb;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 754476001A;
	Tue, 21 Jul 2026 12:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10B21F000E9;
	Tue, 21 Jul 2026 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784635218;
	bh=QJOW6Bs284w6UGW0mn4mtnqzhNAFZ710mf86ogBRyqI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BgLyqCcbuuYeKn0ttf9bofptfFrFHk1FhEElRZ1xZS5tdFtu8Rt48lIx4Fjf2asl/
	 HpSH89iPLF71tvFkK83aKz3MF0CfamtFDOcNJpcesARBIYBoV3bxN3OxYkXleXLztR
	 C0zWdQ2vahzoI+zFb555WCbITdRlu0iKM2HfJfnuR7/ByI3FjGjF/4cZPGJKs/F4Pl
	 BPONvVvOWvwEcEpFAJ0BIPpvL6anB7FfUEnlBQsXxa8Dw5ZB/f8rmqojEliNJCNtbP
	 30T6nKgYq7cClPhP/A+sE4cZvKNwbKezhYfRPZgWq8GdzLwpQ49Owqh36dabLo96Rg
	 /qUsQcZUuKupw==
Message-ID: <a1bfb44e-8df3-4926-8d19-ea31c985e6af@kernel.org>
Date: Tue, 21 Jul 2026 14:00:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: Physical Memory: remove deferred_split_queue
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org
References: <20260721111919.22923-1-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260721111919.22923-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23101100010
X-Stat-Signature: urw6cynfomie5ski9jkbw9fjffewxjpy
X-HE-Tag: 1784635218-751973
X-HE-Meta: U2FsdGVkX18JvuSU2pvmFWtH0otMwrg5Vi4zfija+apVenrv/HmBr1mLByJXbivCsIAuzYu1YWpWiJVB2F790Azl5e0TXuOaB1ILfwYkL+aipKLt3G+KpXgxfPOUg3miKb817SQZiJiSwNNYmN7xUoShd3OqO2CmTEDs5s61tvS6q6upGC9MvZLcKYBknQ+cNPFVOHhoXSpyeH7tlgiea3GWe7gSQgTO2rFwZnPoJ8njU6hzCJYkPVe/Sj1Ko/EeJq8Tbo8Vf4be0zJ1VHy/S4vRVCvR2PFaPJhP/qpNBz0ABiGDKSHRzPpq/yj+0et9tCsbfIVT8d+5QYvLfff5w3f5uGNZyqFmBT1cMDOo0clySL7eBhc+cZyOWdCKTCgeKVc6VKo0JF8S2tqkPrwMfS8XB21l+qeR5lEt+i2eNTm/o+iKdsO5WZSbvWnWTadGW0v8HI+biRJ+VaHdtFI6XOy9v0Nu0QHndJ/S4s8A9un6AwemW7uZzwSTrUiRUt3k43bWBC/gyyOnOIcZSe6QS3aFHmisg8q77aDKJLr2ZYIpaLPUzS4ADcdNYULHb9yyhYLiISA/lpxUgh8saU5tIbEqunWcUA1C7pf5QfW8+is3StLiXZIE72Bmv1E6mjIp9MqjwfklFUDfS1iBCS+0f4J37h1NXohaATMvmOmBCwHNUnJyzPfTdNztZIoWfXyWkl8rUBniP61AOr/nBPDak1ouJskGJEbRfW+5XuSiOUSAXrCFjUn6f3CVsSh5hvwhryGGTqbfclxwUlDiN6u2kYIj5mdB2+V6yV7BR+xb+N1vbZ2qJuv/NC2wkI206aai6TFNoYz4Cc1lixUaSulEUUmhRrGlcUezQ7Ic1HQ+NpeRfNEnqVB+p+IBwTapL44zkfCReG6jWK56A4Kl8RERNsHj3hE5qhfor+qg0HzoJ52MTsqkNeEvV6B4m8W42gx20Cdl8+/aOxJo58m1lzo
 7rBZ6TYM
 86SKGlAefZHKJCyJmYKfUmKqWC4VoxeAUi5Vcgt/S72McLLU2haZ1acGPNDXG9R06NulrwsGesBfDKnX9T5O5Uet/NFhC+prQcfqsqNkMytBtdhLg4srFqsC01hPvZsTcOAEj5nWhZX90EdN9Hw01NNDI6MERGRGtjEPlOrC1WkjGOSVke3HkjloTXEdV51FOepGr1R1u6pRlrBx0xlbx49ZQjo6gLu7uzwQEEZqM+ZvmkML5Q19ENmkQNDj8HmMsw/KKRcyU0ISbLO/H50BkiqEJWEt/OjSYfvwiEXtIssKK9ZzTjVaB2FsODmqVkT4Be8JOv22te3KUOgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 13:19, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> deferred_split_queue was removed from struct pglist_data {} in commit
> fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru").  Remove
> its description in doc as well.
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  Documentation/mm/physical_memory.rst | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..a09407d72973 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -262,9 +262,6 @@ General
>    PFN that needs to be initialized. Defined only when
>    ``CONFIG_DEFERRED_STRUCT_PAGE_INIT`` is enabled
>  
> -``deferred_split_queue``
> -  Per-node queue of huge pages that their split was deferred. Defined only when ``CONFIG_TRANSPARENT_HUGEPAGE`` is enabled.
> -
>  ``__lruvec``
>    Per-node lruvec holding LRU lists and related parameters. Used only when
>    memory cgroups are disabled. It should not be accessed directly, use

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

