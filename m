Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BF8C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12A96B0088; Wed, 16 Sep 2026 09:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3A16B009E; Wed, 16 Sep 2026 09:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2216B00A0; Wed, 16 Sep 2026 09:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A76DA6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:08:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CC3F120708
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:08:56 +0000 (UTC)
X-FDA: 85219655472.07.91ECE34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D51021C000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:08:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gr6/24qa";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789564134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4HuTK4jePJtH8LBf+QEidf509ABsOfiRp9Jj0ByiJA=;
	b=AHGyKJmRU22lvqryQ03VwU9A2BN07tbnM9b0v1LjYQ7YsP+5+CkyAi42FyOMhHo0XnLTUw
	mDUKRBH9Pg2c36sGdw2iFN6RLNiBKZfmYo6GZJJCvgVc5BeKWAqs9rHjMMDMvsksVjYFiB
	bfNbQeTf0KFeai+dSmiGPQlgAMNpeTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789564134;
	b=ZwJlYmnHTwgZjconehGvGajrs/+gAMLkM6ipxEqJkKqh/D12US+sEYf4RhsXHIi0uoAeyp
	LfDpSwSJZR/caOvD0FoLrstlisBXvJWy1Lgjpxiic9pwYQqY4abG7iwyR0ss+U/wgIejGA
	cWyQSXjwOJy0t1i9+A2fCpVMWD/uuMQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gr6/24qa";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A05E6053C;
	Wed, 16 Sep 2026 13:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58041F000FF;
	Wed, 16 Sep 2026 13:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789564133;
	bh=B4HuTK4jePJtH8LBf+QEidf509ABsOfiRp9Jj0ByiJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Gr6/24qanQtWXcVV0Zm473sUWdftheBN8Dl6S2dota+JDIBegvD/U6oepXZtL0zbG
	 5gR5/rAGlAwe5BfF4pSvarTVpMTl1dTPor4Q0tRwz45laIq1a8ZunG55FpWdvrHwYG
	 1ef5CdHmOW7oE6g9Hs0EPHK+K0i/mb0ecUgC3D9re1Kw9X1s/yIc+5KWjhTIvGcgXx
	 BuPm307qwWX0eGUnbe7prJ5l4McvA9c9raYOAOEqbixvqOfV8eLMBudNkmLsTVMXNg
	 mTWgc2YB5Bh13UiNbjRlEh/KPlMbqI03KM9t8Wt+aXexc0waO4BjOJyrEcX+GXGDAM
	 F2euRBinNH1wQ==
Message-ID: <ad36cd54-7319-4bb4-bf8f-9fcc7b009158@kernel.org>
Date: Wed, 16 Sep 2026 15:08:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Michal Hocko <mhocko@suse.com>, Kyle Meyer <kyle.meyer@hpe.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, linmiaohe@huawei.com,
 shuah@kernel.org, tony.luck@intel.com, jane.chu@oracle.com,
 jiaqiyan@google.com, Liam.Howlett@oracle.com, bp@alien8.de,
 hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
 rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
 surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <aqiIEkrc6aDBOqRg@hpe.com> <aqkCbgHmMGxI_GLG@tiehlicka>
 <aqmGd0GGUCkbZpkZ@hpe.com> <aqpYxAktjexhaMGc@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqpYxAktjexhaMGc@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pz39hhfwxdosng1dyjnepjexo346xfcs
X-Rspamd-Queue-Id: D51021C000A
X-HE-Tag: 1789564134-442245
X-HE-Meta: U2FsdGVkX1/UjHQe1wIIOGO9fkebSZy5LwAZR9VVnicIzoi17aOLMm0FJyRdJgOhWjmc8flz6Wsnyl/mi8iUWSaD7oaANuLyKHJiA7GGzD640M453cpdbS2Hu6r6wJmQUIX/D57Hxj6liqpfjjxMfv0SRS8UGumhMTlV6mfkrkotcPlsy2yC5p7thWtGHbXpbQxsYRyI4QW2Cz0BVUgyDDGurCl2sH7Tc5c6qqRVHfXB7+cXZw+sUFOJT+5spS2E/CqsM/YT1XRx/hic+EY81+RGeRacYgjUNx7tZJVWRB2JxY+xOy0mozBVjUWqhfT0cYVSs5Eybka+603j2M3yUbUn899Uk6pm+IeUf8HF93M2lvtPhQQ7IRjh0R78vDFxD4q6sqoCpIhlit+vk3GfAiwLHXy79EFTipl/v/et2Nx/ai3qM/cm471cdL5UGLT03awI4LAoUn9o7Z0RbjN+YpVc/Uqw5RxThTngcWtnAKutFDRVX52Y2Nyo0eSDJvTddcMNlZkRM9SJRfJ4qfop81kSF/XI6paIrj+nMHPGJXCFoZ6iLcEUmi7679g7uSidhipnobxDMIrm3z6JoSWhhtsd8fqE+QZbtdUAF1yIERyEd19W6ydI/CiKlCnizRgQW1mtLal3WcAhXu7II19lKMKLOy1PnzFIYfPU1xeXaDTDUMbCyfbFRYz1KOkAJV8DzSjjlZ98SWJVE5HNvILt6v9ayMTgsuxfDv/+H0Dn9uGIO6b2VZyUuwI2jjGdhe3KdkhXh8Zzn42mHfLb/JMYmHgjc8ac8/HFgvF7mkD84afdixCvt2kE8KJFQyT4VPU11TDOn+NNm1br0aNOBvoGnmB9a/rik7VtLlqkm1S2wnADJJJgAp67Wq8rLCOYo7Nz/2G7Kq4uDFqsGP/p4e3jtBHOoRIqVNFwaT2QEad9DCoS2oJiCinMxi82NYonV/bbfZdsEMCd0Ho8JwJEgKo
 Vd+YC8IA
 12y9GCAk7Y3gvUjNKRSG/xGCR7xfZF/fCf8h+MTTQrTVZ3/npClqJxQZBqf7YfOajDnYKLPdSj1V4xE7qvGPFCAd+jcqWh25Ke5T3CP3sprTjnx8ZoZeM8jXgCfEbGGikubc+1lPtYEy6cyR+bFlTG9IXQ76hIN2FjPIjIJ+HpcY10KjvODOZU2dUG6rZMQ70k4HdNFc7J6xaolO/PW5wGgJ7+SkZtW3DdyGmCHJGYt0g/z045ENnGsJVJXLXSxwRyXOXaD2jJEa74B2t3qJv10osm6s1NTaF6qo5ns5/+v8aAp6ZoDZTx0abuukv7i+q/MOvO/OxB8rUqGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> OK, so apparently there are some BIOSes which abuse this feature to
> mimic a real HW poisoning. This doesn't change the overall picture
> though

Is this really abusing? We know that a page is shaky and will likely go bad in
the future, For now it is still accessible. Trying to migrate off that page stop
using it right away sounds pretty logical to me.

Now, the weird thing is that for hugetlb we wants a different behavior (keep
using the page and ignore the request to evacuate).

> 
>> If you think this should be handled differently, I'm open to suggestions.
> 
> Yes, do not treat hugetlb pages any special. In case there is a HW
> related problem which decides to offline portion of the hugetlb page
> then bad for you. It wouldn't be too much different if this was handled
> through a real HW poisoning.

I agree with that.

-- 
Cheers,

David

