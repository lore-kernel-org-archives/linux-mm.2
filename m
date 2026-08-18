Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2421C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10356B018D; Tue, 18 Aug 2026 14:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7966B024E; Tue, 18 Aug 2026 14:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDAC6B02A6; Tue, 18 Aug 2026 14:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 616DD6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:17:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C046AC02B3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:17:57 +0000 (UTC)
X-FDA: 85115198994.01.7BE1D27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EBEE6C0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:17:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzI9KS0w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787077076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCcAjwLaUU4YCPij0SvKq6AQcqWrx6MaURfK8O63wl4=;
	b=EDEeRAdVDKPyWRBZYaCVmmgVikpKsKOso6RsYbskHUtvBkr4JY+xYeOkAKcjtDjOUXR6ku
	WeaRzOte6MgyXBorTn4mudXs1odPVki0vkQno4MJa+TvYOn1THJdWGYNTrF99AaNT5I4Xq
	cj6HuY+HRkA7t9vyuRtxcdy06Dx8fNQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzI9KS0w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787077076;
	b=7MUy7s2X7rymkUGltgz5IpW7Vd9O2CnV39002Q/ZSTFbEz32F3NFG/QI3/En69LcWltTrK
	WOnt5gQO3dud40G+bhI1NYOmtI2yJJJi4QnSLWvw4xxH83phPoaVxlRqfS681eoqebCEXR
	TOhBwUx7hjDDa0r2hpkQhM3wakm/J7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D9FF4374D;
	Tue, 18 Aug 2026 18:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F951F000E9;
	Tue, 18 Aug 2026 18:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077075;
	bh=qCcAjwLaUU4YCPij0SvKq6AQcqWrx6MaURfK8O63wl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hzI9KS0w+wiNHoPenVr281vsK7C4Gkx7F3n53xEyPpXGPES3gC8fBmHXM65FFzgXs
	 vtmORQi9FgEjefhmAw2oH1lREEW3jvnGkkhMuKjuZtIFvc3p4ebGA5475urctQfVZg
	 yu18aDr0YE05URl4D8vJLnRzxiAYTBMtJ0tJh63cuowmjdpgprLvdEbZ7dcXxA69aR
	 WEQ1KivzUU+8mSMP6xSqPrA75cjez/v8QZdot64vdTfNI4Jk3reH5KfVMKZ7PG1a85
	 /XzMV5vm5aJntaPjvPFcHOe3+cAw+KlwQ80EqvdKy7xSfmaBxsOyJUP/DWv0ILz+Hd
	 Y2kfgkCrY37YA==
Message-ID: <c34c95a6-1a80-45f2-adff-f60dedc2eba0@kernel.org>
Date: Tue, 18 Aug 2026 20:17:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm, swap: distinguish a malformed swap entry from
 a dying device
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260818-swap-v3-0-d3fa52598a59@debian.org>
 <20260818-swap-v3-1-d3fa52598a59@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818-swap-v3-1-d3fa52598a59@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EBEE6C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: ekn3s4koqzu1nka9czaaoyk14zaoewz1
X-HE-Tag: 1787077075-250003
X-HE-Meta: U2FsdGVkX1/5jzHS2FWEn2vt3Y/yu6VCI79yuJSfMUSWJ9Tw+KxPvEUrlxRpbje6dTOMmyxK2Sn8kzg2vWpYAxCZTYjrJ9fwRJVFrdCKMR/RdYZqGlvdB5OT3SxYcTmB1t6RgdGxfMQyxT/5VBy/Ng3Oaup8GR5dLBK7cjuhGTdgF+pAaSpP4HPYAYJehPUnLEY3rQypaIVfd1kYHux/jNWPN3djMhVobJOaYhc3Cv8zBsUzpu/lrD8RU/hKsZV/VVmtADjWbYuXo1Lt90BmPV7BzPFaerum/u/J7VapymhmiFwjhhbp9izFIxVa64YDYs2cKm+WlX15v3+9cxrdgUMaTAAAtaBKrrYUGKiwhblTwslomNqnviuJCtd+1fxzYLRbGjPOkqh82ajxd1ZIAqi1oBCYzIkimVFHEuqJivI+0pKvQrbt6b+/Qnh2Ze/We78W+ZEAGau031cDPwi6Pm4DoifQ2Hja8TyQiUCz6FMS5nKUYkeOtdvejZGtzSqieR7UgLiHD4mhO+nlWrmw+m7qM56RlB5z8ahRy15+7oflbK7vDqNIDCnykLA4uFFbPete2kj5f3MDRYCb7LTbpy6yqpA6sM/MaIKc17k6tRzVgsl1SCV5o/iU179HR2QyocDiaenwi0nvF6x1PJPYX5+gXAiseL57hF68r0XV35JuQRXfWWbB4mgkZISVyj/JZNvCVmr1yAs983AV1HGQARvHtJdr7wjAlKByTjR6si+lT46VS0W9JQrQ538LxQxAHfvAJY7ksFQcgTaFqj3thsD2NTirxiG/IaukrRf26hM+8uo6rUYegRKqdHBvB6B5856eAglEfuS1jp+Ahz3/mupJhEV645Zaq7CUgI46sScpW2aXIJbbL7dpYW9IV2ZaPzpNeuHfdbvuCUnfLrVhkRGddpw4ahHopfa0H+jhnKXPNduaplfDsdq4rxGWrfKxijrlqd5dW3ARzdtNfx+
 da9gRse6
 2VBj3idTcP84o2xXeSF8rOH6dSnLYfOotdUfcG58nU6l4XaXinZfJ7Mm+Ng6cQnW+0xzJ73nsdJ64EhKNtj+pByGQR+mpLIlUr8UqhSUjyrfDSCr65J2mbrZ3wCOtrwJXh5i5fNPGMBYGSj/5NfHqFw6GSlY39B0pidcQyw5z1XHYlNGokDxj5ja/PGo9+LcIOmovPn50Gd6O/V0qACWcOhY9Fvb5sSxQzH5eJAS+GqDuuovbaoJN0Q8yINkQlrcoZwnLy6QKYWBTYRVTEXm9sVA8z0XG37ZJxxt4Xy4S2Q7iiw0By/U4/YwKJdRa5v9etf8eGl8jtIdHIq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 12:06, Breno Leitao wrote:
> get_swap_device() returns NULL for two different things: an entry whose
> type names no swap device or whose offset is past the end of one, and a
> device that swapoff is taking away. The first never becomes valid, the
> second does, and callers cannot tell them apart.
> 
> Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
> swapoff. copy_nonpresent_pte() already reports -EIO for an entry whose
> type names no device.
> 
> Callers bail out on failure either way, so switch them to
> IS_ERR_OR_NULL(), and let the two paths that drop the reference skip an
> error pointer. No functional change.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

