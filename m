Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04894C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17E76B008A; Wed,  5 Aug 2026 06:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF9B6B0093; Wed,  5 Aug 2026 06:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05F76B0099; Wed,  5 Aug 2026 06:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A60F56B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:05:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3722B1C0B47
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:05:49 +0000 (UTC)
X-FDA: 85066784418.30.C2B19F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A809180011
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:05:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZT7pZHOU;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785924347;
	b=dkthNk5oc8ZujqCUMn0SIpX1HY9biVIDebXKbDprjYqammgcftwldzzEvuPXlrbYnkEeGb
	TQLFxfKQJodiNHoodMTRfAN+fVTwZYwDq41ZwC3Sf0TTmSWBIpCOBtiA5AmIjWSyA3HSdG
	mgfBQZupqtuSWqZn3VkV4Z3MU0f7Zbw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZT7pZHOU;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785924347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkHngmbduQCjxofsIO0vDrPy3snBXaWTEyZFFZpOrbU=;
	b=sUcQqGw7xS3JqS6bMLTYaBcjmUTn7tt7EtthnZ1Cteb2HPj2Q2nlcILRgiafVsVmIyyAMx
	95h8UDN4OT5UqPiAZ08f8D7If/UV1hqJAQmfOuwcqGOoSu8Rmqjfat78nOG/TLLNVN9Sn8
	zYYYEl5lO3Gnx8OgOSIi8bzj69rDYt8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B0E8600AE;
	Wed,  5 Aug 2026 10:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7A81F000E9;
	Wed,  5 Aug 2026 10:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785924346;
	bh=jkHngmbduQCjxofsIO0vDrPy3snBXaWTEyZFFZpOrbU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZT7pZHOUH3y9ed8FGJcrN4FaX+l78lvN+80hWqotj6EcjAhnevUXKS3yd4ZeO60zA
	 hlPKMZ6nPqxjHI7UUw93UV4BRHuQRQXFlyjPay7pRP+Xthq8cKaxmmINWaBMnFfLVS
	 G/8P1S5EJQbfUSt49djHtEpJowgKgUAOlNVbAsJqmJuUHSvFBJUxXGBeRIr3ng44D3
	 QsUQr0qKS5dAm6ux61s2H9zv92EspaROERtmENdSQ8feU/ZY7hW1Edbt2I6tLJ/S6l
	 HxYcZS6JAvZbYkeNjYcVZdvSlPJujI0wsyNZVQuokzde5SAhM+pH0BFeJuUy8T9wO0
	 iA1ShjgbdhrdA==
Message-ID: <0b6bddb6-5fa4-46e2-b16a-7195119b92cd@kernel.org>
Date: Wed, 5 Aug 2026 12:05:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/page_ext: remove pgdat_page_ext_init()
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>
References: <20260804151145.3419768-1-ekffu200098@gmail.com>
 <20260804151145.3419768-3-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260804151145.3419768-3-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7A809180011
X-Stat-Signature: hp3yaewqe6u69rzu8bapqkmi33g7deih
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785924347-395770
X-HE-Meta: U2FsdGVkX183OKTpNMSmRK3xi9Lr+3WofmMY+enADOf+kquC69hwGPN9ATGuQ2hRIOI32QZP1zDPCLJMxd6BPOFinZz7r/lQTwqlivA+tp3S0ikBxIpaGtNc7noV5ra/ea/3zIXMqGl0+i7fDGWKXi2GCZaNyio75jEiKAkfqIO2CQBvxJ1PFlXO4cn3w36zUlAk7LRZ65Of7o6/B6nwZkrzaOCIxNjfoXg2o9cqDvciq7N5L3d4Ngo8zp/HjyRrR9+Ta8N23lhm5xhI+TuCoNQf2xRBprkRcXr6leN6Gnz4tCa3tB25yHZEGhtO7YswR67RGb9MTFDIMMRUoOEEtoJvsvG27A2+/TUwqPf/oZc3zeSg7X1hCESSUVezdXLH6htNcGorvo2c55K3Lq+df3lP5X+4f2Z5gj+3xXxiObzY9rTQSc7AFlcA55cVzFy1bfHa28Tiypxe4kIfnKYjeuXru1pLK5Swj30z60N/LLBkIdB/e7zxAM3OkrXcfR5vcFhJbmEvLJrqvGQSpO6jZ6H1GD8KtXf4r5If3u4xg1YHVtA72+jI+Etc1v5RW/MWld+54ptY6Td4CW9nRFxAtd5oJ5P0Pv4SBee2beFBjRXzR3j3ZxLGV/hkYHqdXAjhJhjCMks2frfCzlZu+iwQLfMQUwOnCn0Dg16OQAjosundNJaKglOAXC92AE5qV+NAGAYbB9rEqvi6lSIQnwJfRZbGAlz7PVqt+7b+BDr9GVrm36KH8/lCx8FjwpB+vgi5LXMzaQKrOn0taeX5Br1gWYto4FbvdlP9CYNPsbZXFSyp5d9w1TvFy5TNbxJrnXhyxnpcGiXP5L6+Dieqfdtm3f8oLdlOal8UyLjbd/r2BLSCuO3F4sXMwOaz8xx91HB8eWdmOZb4VuMjfuTTAxyAiNR3ABBlLo6QsTN/SKBppVA4LJXAJVKkS5Z+TeNfmOvjg2YLXIZSV5x6vxftV1L
 dhTFKW0V
 Vg9F3qaFXXVlgoWdpYy6cjEUfKEg5ok2m19xD3p+coFEa15JZSOyuQF1S8spoMd5nCwE8nE2oV3OwcLmrvheA4bhzu0nF0giVge0EqZabf2crexIlZEeu1A5Nif1E9yQBwkJxpcdnXGYPlWVDRNw/xtnGT0Crm9XEjpESz5BX0jadpHUkGlM6/GLN8KDuW11YT95VwECWzl+vx3vSS87essBpJoh4d3jqR8p2dNmRWpoxNSCtkziPmu5oLuoPEM3qvjiY4uaTZ+pKDxgvAlLJh/easT/7TbWthd0Jpl+7e6f00UCGPvNDhG0x1rUxd0ZnMhjdZu97SVukBijMfJNpYfA3mAdW8dKG+2oX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 17:11, Sang-Heon Jeon wrote:
> pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on
> FLATMEM. FLATMEM depends on !NUMA, so the pgdat is always the
> zero-initialized contig_page_data and the store has no effect.
> 
> So remove the call site, the unused function and its declaration.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

