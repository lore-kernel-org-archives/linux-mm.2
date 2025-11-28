Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DD2D116F5
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EAAD6B002A; Fri, 28 Nov 2025 02:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2706B002B; Fri, 28 Nov 2025 02:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF956B002C; Fri, 28 Nov 2025 02:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62EB56B002A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:41:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31015160481
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:41:03 +0000 (UTC)
X-FDA: 84159219606.11.D589DDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 763E71A0006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:41:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U1hC56Z8;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764315661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kxct075zh0c2XTNfsfY2rUfaOVjaxfmgGgfDA1RMF5o=;
	b=eVBI9RJ6yf2ufC664cDh1kxQsOf/Xc7BCnoRi7mkcA96QUUYUZvhMpiCxpJeSJ6WbVT2gC
	ThYP+qw+NwX39+FxfjRK4nSAI1yhVDUbotw9ii+jHIkeAWvtYg6gFNEJGzfAG6eH55AL7d
	2WibPamHLLRa+QxTToDdGe8TFfiMD08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764315661; a=rsa-sha256;
	cv=none;
	b=UpPVDF100UKYspNznuBHoJq1ZUv5WPh5viVH7T5GexHTN+WIXIUrl76W2ttySRRcXp4SLa
	JZfhq8AsGQ8Di8c3DxioW0DRZKXE2yKYTIay34gPzazfy7GA6kTCPdsqKABMptw5TRvRON
	trGZxtleQwiZRDHj5OyadAEiRWVYKCs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U1hC56Z8;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7430440BFD;
	Fri, 28 Nov 2025 07:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D189C4CEF1;
	Fri, 28 Nov 2025 07:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764315660;
	bh=Cvm8VHYmiklHkHLbjGWk9H4wF4lDIswUe+zfGMLAC5w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U1hC56Z8WBw8QH9tGIQdeGelW13iXtcQtuL4XpwBwmjePCPQhrTCZIVKhN2ciLq3r
	 f8GZLBRJBtNo9UGCkcA8iqQXFe6o+v18dbZ8bqh0r0TPSpAq8qLjsLbBnDr2KsXr31
	 YL3TpqC9WksHalFF8G4sFNkk8LDWGWifJtIpBKqi1fmicyoUSxAC71X+F90J9EGvEE
	 rQoLXnL03j4L93SDlDU414+zNo5p1iNk3ifG32eTPkjKI2FMdsCvaUkxpIsI/tREV6
	 BIQ1ZnxT8LVOdT9VUVAdbMLjuXGmeaeLNq9vzUZDexsGe4zSSZqKWjzq+iSBLXxkD9
	 r2Kg1RkU7ZkFA==
Message-ID: <301376ee-3439-4d3e-a2c9-8604e7bf49fb@kernel.org>
Date: Fri, 28 Nov 2025 08:40:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Remove device private pages from physical address
 space
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org
References: <20251128044146.80050-1-jniethe@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251128044146.80050-1-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 763E71A0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: x5tf1nbfez5c778gcjaj65xg93u1ix4i
X-HE-Tag: 1764315661-972103
X-HE-Meta: U2FsdGVkX1+RR63fL5vgsCHaeH+npa3FpDpShc/6axmwIbcmPb2HGCtXi/KXoScfpVSuVZKvYFPlvWe7ldW5a/snJiGe/iNiFBFs8gO99AOcJr4PQ6qrdNTnHgm1CExjuaCf9dcSTvOj9BsBDmF+BgfhIwbusw7/K9Zw3b48L9LxhBRgcAD8/wLuiUQeR2rms9yeXqbNY+Q1ntC/CxhtcMU3epRwx0l4CgqL+4qry2PG/DjBq0Mc16EQkVZU8FcbOr4lp9QP7jOdZomBTRuWL/yUydNe0jXHNBdDhGoWz1chGeVAa4XzX4I9mBflV0y4a5vWtB/Hrwvs+B5JC/FCGDWcAus2MPqRyO2xRd3wLAy3QB4x4DgGqtGnZiqC+gPcQTw4Uxj/kpt0GgLAkFXMvmZ6iPrOR/eYP6irwC8ExETNeLKtSTpWq/W+COeKrzvpT4MmwoEFMOrXjOykuV7b4pjNjlvjWkLZiHPCkokZArtJReTazZp42vgq/HeTXHrOf4438qvaV1ER/IKurInABD9NWAw5Y2BbgCk0ziUNGZB0UJdXbKfe5dHJvRfdOw3JAazyudaOMfUZszqCVyqKlpX8gF9znUU8o8tCxfpFgdFIGURHT5xGYj+OuEbqJktVxAMUUdMi86JV0vOczjd8nnF/bU33P0CMd7tT6beickFRUXvT7FP0GArGG/Ie7K4KY9NcDz8a7UN7/jI/2aO3PhZqRCpIGxkAWnZ8p2/ojmb0GfDzQ5IHKCMQ0INPmGym8qnS+9tO+XpBPhJ3bs3o9ksYcG45bQwFKUhggIfD+ZK1jU9vo9rIw2Z/DHfIwc7gJIh/hLQFZUkwrXmbBjnb3DNrfjLe0Kx8aFI0la5NKT68rcSUrVpVSHuzZl6iWpFSwB9Txn/hV9+U9S31AqAJXXy1j9pnzUf0L1Yp9oNPZPz1ZEvt1IXP91MFICtrwp7hI0jNVHn9wsMM46ehJDn
 zzEYCscf
 bW57lSxFptxnYhfUWOjrD5R8C8EXKshBmvqlZxrHnxKBT0/hZz2ox/6BDM8+y7jf+CcAUWKslIy5KWqKlScI1DvafV5cDP+GIrk1ndrWzNuLxRGdzoiLuI7zulr5SD35h3Z2PXJQVFDWadbVqswFqh4fX+kXejl6jVA7PePeR9msTk+vaT1LLBv/sm6kV7oAOPY7lf9vOFHM7I8XISfCFuwzfuOnnXdX6aGlVaATVergYHPiwsbk6c0T/dtpZS0aSg2x8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 05:41, Jordan Niethe wrote:
> Today, when creating these device private struct pages, the first step
> is to use request_free_mem_region() to get a range of physical address
> space large enough to represent the devices memory. This allocated
> physical address range is then remapped as device private memory using
> memremap_pages.

Just a note that as we are finishing the old release and are about to 
start the merge window (+ there is Thanksgiving), expect few replies to 
non-urgent stuff in the next weeks.

Having that said, the proposal is interesting. I recall that Alistair 
and Jason recently discussed removing the need of dealing with PFNs
completely for device-private.

Is that the result of these discussions?

-- 
Cheers

David

