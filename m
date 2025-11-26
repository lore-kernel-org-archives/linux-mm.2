Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F07BD10399
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 09:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E366B0022; Wed, 26 Nov 2025 04:55:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE596B0023; Wed, 26 Nov 2025 04:55:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD086B0024; Wed, 26 Nov 2025 04:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 683B16B0022
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:55:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B85B59060
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:55:04 +0000 (UTC)
X-FDA: 84152299728.23.F98FCC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5EA20160012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:55:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oqpgj7Ow;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764150902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tqipy7U50dFV2LnXqD3B0Eds8DZUB9zZ9Dc8ivunaK0=;
	b=H5Hw6hxQbkLFEMaK6zrHrm55rs4aH9ytX0Map5TfONzN5K5mVUhEH86HOFLveEbS06u+Mj
	wqmuZ0kpIJKHHqxQVwHjXe9jzSVJ7jZtWzx+9k/IZUvxFu9WO+K+QZMhNOT748xXdzyu3u
	yjpUYsHkUvxIfXocoCiAWvQGxvrnJNc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oqpgj7Ow;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764150902; a=rsa-sha256;
	cv=none;
	b=CH07GbDNvKzds0ys4Ogk1TGcDNmTLu8fgMzXHqDnOREMBGISodlQpATsuDGJ+L9rbMJB07
	ietF45ezOwKJWKNrV4gT72wjiI55wUXwmvL9DNNB+GElNStO5cU+dOPJOAlA+tpSROIUZt
	28qKQsEs3A41saBj6Z4KIRLe3gk1LdY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD2DA6019B;
	Wed, 26 Nov 2025 09:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35452C113D0;
	Wed, 26 Nov 2025 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764150901;
	bh=czA4ih43T4jn7HUj1yePBK4UCqlTH0yuZ/2smSik6Rs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Oqpgj7OwpnbjF3Gon/H88dlNFNGUz/S0mI9/Bj2EfEfLqOL73oGbbwy2jQk6SNdy+
	 BEZD8piEQuUs3QohS8fcr4YnDJs5kRkPiUY9DvfL/uag/KZ7wl0+hSdw9qK5RAjHzc
	 MpnwcInM2atrOTxy2B4OMGmeDq3PKsm3284dR7wP76kIOI4+ALA3MreyVE3YBOolB2
	 bv0qxJvaTdL/t88wb7ONDGiAN+5HuGLNST6sIq69+bnmZZ1trt+0M4CQoLudCWxjH9
	 8kF9QOwNAoOEHncgd7OhLcmEdP+VPTjAoPgxCWzV/rbea5qiQNaIDIOyFuARIiIEQs
	 bPUsS7jvgnC/w==
Message-ID: <46d5090c-a6c5-41de-91c4-dacac58e1f9b@kernel.org>
Date: Wed, 26 Nov 2025 10:54:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251126035008.1919461-1-ziy@nvidia.com>
 <20251126035008.1919461-2-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251126035008.1919461-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mebfk4h1tgtpep8zc1g3uiwjtqwxpf3o
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EA20160012
X-Rspamd-Server: rspam09
X-HE-Tag: 1764150902-64022
X-HE-Meta: U2FsdGVkX1+GMWIn3kKgi+DWxwGCKkieK83sNdZCG+Fjfuq+nOpI3Y76/FRUGTGdVMpLyCoW/+HIRppySTusfGj9MF6gk09CY0Y94z5NkMhxu9ynuWtsA10l0hqISO/CrA2Q64Z92/D17nn9maPzKr+j5YFJHtuFI8w1mkHByjdeqfI71pUlC4u7mBflJwwGpfyi3O2Xcqtq2DxAIh2ii5Ex3MlQnGRpXdmAfy77A5rvuuDCjlK7K9nygrKHs0qUIYzNKgc1vvlosZZLxetpNPiKWf7U1zVKw9gRPYhycYNiR8tiqzRSrZyDmxJLkxNJOjj/Z7e/vxyryciUYRXBRs8RWMCSPuy4JixPaBcwRbtAaDY7BEqJYwMDKJm9aM2xZReIS4z9g63w4A+DYSPWuTfao8zjGuUCzpe1Xe7O51ZvI2MvzTZhiXY+q8aQejqMWVfLo0j0nkmbXvK9WTIf6SCyVKBs9tbj79EK3aTAGjXTrWbVchUy6zZpLVp/nrLrXrY8seDBKhACM2j7pth0iVwVcPlns4Y3CkATzzKz3KZQex//tHI2Kz7sCKIDXqzx3GqEpQ22j2607RdAFRRq0ZTbvaJpl4nswGrVsO08cSbYOXwOGCF7LlHCMc0VrCkQ1c7n8C2zs/STW5Diu5bC+v9kBpkugY8NqVee6CnHhFs3tcNj9bNcaBZAb7vb/SxGACFoBJTaXLe2X3mK5WNf5VjOHyNhN+88L8WIVpKZl/bm4PgVAmaC5f+/y+bEv616sJLh+3cWEf4MeWBwczn5hrFSTJJ43oj5kV/s4SLj3QHG93UWLWlx6rZPxEC/ksA+ucFlKU6tnqCuRat/d5xXaG7+jzl31ibQ2/A70k28pkA+XIxaj7DswKhu5iSKE1lBBMxzn5VVJNPHTB/NAKaYft3v0JS0Q4gdgdmI/B9h0GKjDWA6lMuV75HuDSuItXIXOdNp7R6+yqbht1CxC3t
 IuKd/NH1
 E2K0SeNMb6oewWU6Un2bozWgt/hTBXqmDDdQS72OIYdbkXY5FRUWHIRQi5mYpJBUmDxZhoI/igV4Cs2zfFvR84/BhoTmwCfR3WfO5PjhOFuA5B1L8Sxx8ZdYfJb0duS4qA80sJnhKskR4xtScKKg4Rf+ZPEIAHqyPh0jDRFalzNbbJ2x4kgZDmAdfy/nGh7GgvXtVfGq99BgTJPsX9B/CAvUUsOovbJfy06iVEijqBLXhwv4s7gHpsW9aOe6F7GRwN6raMdZXOqjeLGpFAWKjyJf6DsVub/bdVA7nm35cWm3hKA8EoIxyWo1cbB9GrCubSjM4SA7CMJ9ApUbg0FpZwOJbpfyObU/kb/jUqNL0RxXEBNESIapUPQZsDV19LJxMZvAOQSSkFeyBu0aJ2MEWbVQrBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -	/*
> -	 * Folios that just got truncated cannot get split. Signal to the
> -	 * caller that there was a race.
> -	 *
> -	 * TODO: this will also currently refuse shmem folios that are in the
> -	 * swapcache.
> -	 */
> -	if (!is_anon && !folio->mapping)
> -		return -EBUSY;
> -
>   	if (new_order >= old_order)
>   		return -EINVAL;
>   
> -	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
> -		return -EINVAL;
> -
> -	is_hzp = is_huge_zero_folio(folio);
> -	if (is_hzp) {
> -		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
> -		return -EBUSY;

As we are changing that case to a VM_WARN_ONCE(), is there some path 
where we might trigger that?

I'm wondering about the split_huge_pages_all() function in particular. I 
guess the "!folio_test_lru(folio)" would protect us?

Apart from that LGTM

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

