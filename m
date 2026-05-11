Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71641CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993CE6B00B6; Mon, 11 May 2026 14:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944BB6B00BA; Mon, 11 May 2026 14:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A456B00BB; Mon, 11 May 2026 14:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 740C46B00B6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:07:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 233FB16023B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:07:54 +0000 (UTC)
X-FDA: 84755922468.30.6B6261E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 605FA4000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:07:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jC0EGkgg;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778522872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oW/aUNOHn/2E3jlIFrAr7dkB+FF5lE8cvn+69c1Sxk8=;
	b=Kz32IkBU9iXpqsqjOva31WJ2DNr8vayAI85A9l7cOVwE0Q72kvhYHDFb9vQbHflEwy9RTG
	AcR2GMVU/rx3vZ19st0FhHJcC1HRd8wgm3ti95ERJPDKW+I7/nCAHxZYl1VMZYZsqSYh1p
	pOA9svr9XL440lDgBDrFBYMcvpGKitM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jC0EGkgg;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778522872; a=rsa-sha256;
	cv=none;
	b=1EuI4mSX9OkzYfN50r/YcSnSwhEM8KcxVIHUMxTS81juiq+On/aA8vg41HgdC505sfBiV5
	Je0W2/V1a9IR5H6QsYiSUwNNvP6NItK0ag1yQ3opsrzMf2fIm/NIJSj7hJwxgab+Ud9ryj
	+63wcxmSBMebCZULX5LG4TyUkT6YzQE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51DAD41735;
	Mon, 11 May 2026 18:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B2AC2BCB0;
	Mon, 11 May 2026 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778522871;
	bh=Y7181jF1bSs6LMnCapoKzcgBWoMTajIXSJ5pxwHBPRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jC0EGkggvlYx6PmXezKzPi9NKvVbs12aG8LROPmIO3q/Fz6/TS98sKot9fcv+IxdY
	 j9UsWqUlyI6ErX/7MXgDtd4tfNdNc4oxY4Qou1KxzZK3Y7uOYXDZrdjJPBb3uYdKEo
	 BCfU0Yrp8W11XhQxdXGip242l0eDAvgoUXsppLlfL3Q8Y3Yb1IhwblWraD6cmeXljy
	 QQ0BGP4zJLfFMulMldAhEuYaUQ1U8/2vT6fLtSP7nLWhqJoGgpYFHmM/jHQ7mYebQY
	 0LiBG+C3JTqqVoXMgU21ox7vbCgrnknCCEd7AEJsZ3taObmn976xEp/G7p7TT0x+U3
	 5b68M4i2Fbp6Q==
Message-ID: <9df7caf5-fccf-40bf-b8c6-ef633ae44bff@kernel.org>
Date: Mon, 11 May 2026 20:07:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/22] mm: rejig pageblock mask definitions
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-13-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-13-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 605FA4000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 4brq7dkd7zam1zye577gaqcpcwy8oqqi
X-HE-Tag: 1778522872-763214
X-HE-Meta: U2FsdGVkX19zfUpRkciIFzh5hSq8UHrfbRWx3Xej/A9CaE+GFKAIXV2cIHHFlLjz+iED1GZxb8Ck38N1rYFBMpKeGSk59pdD1fz0gybtqtt3ieB3+uGFVjBPSQoOOw9xCN1ZQjwo3hRDzvh5h3YaB8NVxOyc3aZ7s22ApSgY6GCZacU8nNCVOCrD2Dql5Z+WpOBWFoVKYcV9pvL8x22hsOoe+16Hg4RnCxsgaBerK0jeJXvXtq6k6VutBly8xP3LXn0rfnVpvgjF0i6ClptrbJ1CM/FF2wkCprDmMqGkiO5pHfG/rd0EmryjFMI+xKXG+f57UmICNqqJzLOz7cauw5QTQltlzafMAcaEjqfvtv/GlUo/PjNo1SdQ5oTNEm2jTWAMphD4s3KnoUPZft9ET7vBrAuXRhhWADXPHnDFo6TRG/ge8+c2LDHQbjcf99jCpl41koGHxHwRoKLmT9JVzhcC66fmc/582g2Ph62EMTntP4rqIfn3j+EW8UlzzeBHui8gNSSi77RKeAFO1omt/7lwuDoZblPU/mHOeH5S4B0U2gmZRCuwv8D5rQ1q8tFrkvzhun6a8mrgG2Nu7FsKs0XZhOeUU530u3q8NAvQeM/wfdnrZc5fzKuljOxieJe5pYuaWPkSkLWqQopjnVfzxmlTTLNpSypAb9MGx80oPQ1XEtiCXGVqjZfJHySGKdCOSXN1Katv9jEgmlbc+S4Grm0R3HFzQV8CWM2lhhvTZGIea4mgKFq2ITpS0LWm5pR9ZofOQzpvJ+DbdVqoUX+F775xQes5q9FrjGOzLWXI4uoKBaHdayPghGcwnXZXz5NRGb+5VCWbsqIHW4+0UFkm8kCqA6+1zSOPagX/Hf5hyDGACWwGYbsmQqrQCuKTl9CbQkQhQxLqCulJjUsMoQ/Ub8qrm+HLJSFfzg+RMrpFzzjyXnLhdd30LfrbaYIRculIL57gO83Qe9W0kdPjk84
 83/S6UcP
 WKs0Vg9RC1kBtHSWSc9zxy6DKhLZa9aTHgZfL50JujFIO2sW0QafQLvCGXf9+6mrTSMNeb7auv3NdAzLiUpF+L8MXwT5u6CNHeC4emainO2Uvp1HW1hy933wFDf2hnYGL42+9OWnW9Jw8MK+K9Okf695w6j88oswLZ1Mt7QX973z6ehH+lPn8rMofkn3IDDEajwx18pRSDxwW8RF9uAP7zNP5aVH6BVcxG1pHo3D1rIl4Wg4VvcQF6P1UgGdVVTXV9zBlaklDAbzVEi54/kfVg+Lq4iht0H1FP/RVLKx26x5w87WAH3b7WpxAGDxW5q1QplDxdaX1Hy7nKAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> A later patch will complicate the definition of these masks, this is a
> preparatory patch to make that patch easier to review.
> 
> - More masks will be needed, so add a PAGEBLOCK_ prefix to the names
>   to avoid polluting the "global namespace" too much.
> 
> - This makes MIGRATETYPE_AND_ISO_MASK start to look pretty long. Well,
>   that global mask only exists for quite a specific purpose so just drop
>   it and take advantage of the newly-defined PAGEBLOCK_ISO_MASK.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

LGTM. Could be also part of the immediate cleanup series?

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



