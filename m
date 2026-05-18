Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7719CD4F57
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1376B0005; Mon, 18 May 2026 16:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79276B0088; Mon, 18 May 2026 16:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67066B008C; Mon, 18 May 2026 16:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A425D6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:17:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B4EF161857
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:17:01 +0000 (UTC)
X-FDA: 84781649442.19.D092E95
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 33A8C4000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:16:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lImhG8GM;
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779135419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2s9kvfBmd7egsjirKL69ARrFpEHgFlrENxtE9a5xeTA=;
	b=Zy0jKzujC2plb2uHfzzhz/+5s/xva5g34AOL3C3SI6WDh4JrUesHufQONBHSs7I+IwWfJQ
	dJpdZQbnrYbfa89osxpCPHe9wZ/bsm6da7C1m2Xn46tlslEjTgGwoAaKMnqlKN0zki1In0
	eKbpnQuuRob+qWxNsDNn/0FrpVk6XJQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lImhG8GM;
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779135419; a=rsa-sha256;
	cv=pass;
	b=FoIOwpgHm21IU92fbjio69W5BgAA2GXS0N7+Ul/SRoALvqaX2Gld5HV2VUHTfykye27nn/
	l7uhh9Y9QbTiaO9W8xHnkNMCW1nYpzlcif9DE5uWADE4ML2cMp/JO6VlGg+gUgMCsS7qDa
	kg1bS58HMI1RhroeDowV5SKmEwrZFSE=
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-6314d2e31d6so901454137.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 13:16:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779135418; cv=none;
        d=google.com; s=arc-20240605;
        b=bdML9QZvf3MdsHxhf3s7jTgbVZCvMKalWgwsJwaL73gIRc+DjNflNLNM+jPzCqvslx
         O6aN8xQyIOksN9P+R15DgXa6ITWwh+CxGFV/NiJqOzRv+4RjLLWd9rPwG/1N3/AlCQqr
         UTzPVx+1rBn199mMkzaxk+iTlDTuN9sVfUt2WZkeVhcerjti5RSu93m1yv9UNEGfTmU3
         dz0l/P3EajH9IpI/xunP8V7p3lDMAcKQTOVFJcRQq/5hILO2dpYUE5KVrTpkyCTbOjAK
         eR15Jny65DHxbZr3xHSP0Z1wtzAOgAwn3OBUwEJP8207Cx5wg95+0JHTPd2gXDLrz0j+
         Ch5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=2s9kvfBmd7egsjirKL69ARrFpEHgFlrENxtE9a5xeTA=;
        fh=+9Gat6uqzP0sW0ha4FHbec4EjtxzlM3+krvlr/TKbB4=;
        b=aCYMqeFVGKCKOH8naCrdAVqkkzLRHVetFIju4FICN/Zt3ulSIWViYzgqItcJDAFfAW
         c+l2HlrM0V9OpSjsqeeHEF26EheBAMfFDS9yA/BsbDnPfxVChxa2Q2wP1nYOBUBM2dRc
         kQ0p+zmwTwUYvyWERloi7R0DUGh2WxyHAvx4fQLYl5p7w6AM74RqIaDEb+QMPFOdgGNd
         xikjN87lE7PL4v125Xyxsk2d36wTTk9vFalelcVhF3nMMKAzIIOccdJcDHukiypt8tA3
         X5zACR3eQYhaMLtjhdU6D78zCWhOf1P1Z/2Cuul1LUwciNqS3Q+BvWbNolFuy7KxgRP9
         DTbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779135418; x=1779740218; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2s9kvfBmd7egsjirKL69ARrFpEHgFlrENxtE9a5xeTA=;
        b=lImhG8GM5p48Y9j8GegmWkZBCfEp0KkW3Tdx3y2IgzOlctpLziTxLeWl3U50pbtD7y
         mBEfOq9LO18Z616EyQN+Ao+E+k38i3Hwb07VJtWgaYLma1to0v+YZFInxaTkLCsjkQIo
         LADvEsMMJ4gaf85gOOXgFrQWIknCKpA+JcLqgUn2TgpYXQdJIFVvuuPK9pVpAmdFGfSo
         BfXqVgcyxBqqaL6QdAvUX+ikC6xo7PBV8tS87m2uN/+w/y/4g15jJILarh/g4UMxnJ02
         O+jaLZgZ2UH0NAdqxM4zden7bYoDSik7aq80b+wvtlheJME8qxfwhEOR7lgQVHgDVmw8
         Si+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779135418; x=1779740218;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2s9kvfBmd7egsjirKL69ARrFpEHgFlrENxtE9a5xeTA=;
        b=VfuAXdLUVvNUkYlmemhWzEgpycfOcEyFjEmTJGYhXkGnqashvFiVlTG2/zN+bqZE4R
         E9Z5UD1uNYN5w8bvIwmj/iJ7iXhjLnou9/8R/4mfVpW/uiiV9qsW8P/NeY86HgaQhnjL
         DsWBLKm1IRmlRnyxA/pxPxn/DcT4yv1U6I4TdjJnuUYrcqUSkb/0SEtiIHW/kkq9/Xc2
         79U7YbUTPlLgM27pVA7QhkUBn+mw1TR1rVYw4xnxrYnl/xVQC30do4OaBDKjGBV+VuRJ
         VI8oOoLHV1iI3tgXRkkKJJWeBPgLuj3d8YOpRq4Jd1xWrOZ9Ubtj64nTDXX0OoYlPCiu
         v1hA==
X-Forwarded-Encrypted: i=1; AFNElJ895k4a7gdhA76PaGUVcyFHi4ihlpC9QFYoTGncyqlCykIIUSYRLLOhnEvr277JEhQBHsSK9Qh3Fg==@kvack.org
X-Gm-Message-State: AOJu0YwICB1/YOxgirvW+wwaLnY1EV6xvsepUK+VfCY9ArvUNHwNQd/S
	u+ZxFUgGjwfxv0OYs5GWS/zzn9Y6LHvDB0JBbs/A0m+NApPZJ8yB5u7LaSsNXOyztudwnNewA8A
	fXGtZ8P9v++tY/kucEazeaeaiwfkv4wxOj7uaWsPN
X-Gm-Gg: Acq92OFWusjCCAvBeRRW0bQSaUHxbZLRuwPOjESM19hp5Jb60sk0osAkkYnm8yPIQG+
	KChxPoy8zqP1UBeDB2nTA4AL6alJuwY++Sxo9FZ94jZL/9y9SYBsSBlRSQ4bb7yBzq9BaJnQew8
	6DQGxKtot6V+y1miZEsdiUUwwIsdiwqFnFk6TWugfNhdg5cqJ/qlKBZjGpNwN6zNBUX83APt33Z
	rlsUBGL/JqL7xfVr/KQluwMjNJqyJi5nBGHvHAJ7aylCKDT6WoqO3qnZHJ8XW4eoo/6NVNhdP0t
	tePSIixStfmrLdG2t5azHMol98cqTmcnJ9IPNt4GbPM80nXsT+Q9T3RdpvuyFd33zXTf2rF5XSF
	otkAv
X-Received: by 2002:a05:6102:50aa:b0:660:d26b:5077 with SMTP id
 ada2fe7eead31-660d26b744bmr1614764137.6.1779135417515; Mon, 18 May 2026
 13:16:57 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 18 May 2026 13:16:56 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 18 May 2026 13:16:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <agMohIaXKLlBKM6A@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com> <agMohIaXKLlBKM6A@localhost.localdomain>
MIME-Version: 1.0
Date: Mon, 18 May 2026 13:16:56 -0700
X-Gm-Features: AVHnY4IyXwWPpksbrvmzM9WO7o3-DjZWhhGs_09px38mqhjH5BhTI2oOA9sHqB8
Message-ID: <CAEvNRgFb-Bw_-R3LZLkFRFH-5RRZ35s5URm_t=4mPeGKBke8DQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Open HugeTLB allocation routine for more generic use
To: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, jiaqiyan@google.com, 
	joshua.hahnjy@gmail.com, jthoughton@google.com, mhocko@kernel.org, 
	michael.roth@amd.com, pasha.tatashin@soleen.com, pbonzini@redhat.com, 
	peterx@redhat.com, pratyush@kernel.org, rick.p.edgecombe@intel.com, 
	rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com, 
	shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yikh8gh38m1665f9jqsnkzwwczb1xcph
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33A8C4000A
X-Rspam-User: 
X-HE-Tag: 1779135419-465103
X-HE-Meta: U2FsdGVkX187ZrRuoKlzprQrlj/HB6OcBEsu+7X0TzudxKC9ShnkCtIZkbaK7+Hc9X4bUAuYsAKRKVoxdsXBFoZnDIDj/E6xw01BigG8QZRS6IxNoIwQodaAmYFjmL0XBpa6678qt62eA8UF/GLI8a8mKmO4PxcM5E01IYcpNUY1sg4x99j2sNmXBCW8E/K3WLU25Ba2wmmdU/y41wXpw+AMcYOvBA7gJKsNMJstAe8lmtoeL9X9qWGyi1teFg067uV/pap1mlcsMZobGKeUS2jAoos9pVgfJvLd76OatI/H5n4ftCs62P9RwuqWtPq9ReXSlHHV87KtwC6MlpRVppPFn09ZTTCjziJJwyOCbXsA3Zgd0cYciNEldh7C4Gn4anx5Q2NrcLLZ6cJc4MGlqNzDxz6/iCXwJOztbb21CO+ZwI5rfWwxsUL2Tj0ZOD/VI0tQBcyHxKVAL07aMfSD2szgRuSOwnO+y3evejUqYA+nBy/JmR+oUvzejMvkNPeoDNO1cc3/tlH2kyr6UQV16FvgjYuDmToUKU/2eVH56+TjM3ggR/bchdcONhooUn7HWGFYw3kw1kV6O9DnsSDM5jLP1WXSPjmGZupPrL8+BlHVt3tvcDamWZffbtGADTuF3zpYciEe/lpP0Ol5/y/WRSD4+elJidrvixkTxwrdrEY1GLq84rS0upCDGGp8x4nIxyG4s1hUljgl6dhMwrXnOjN+Fdd0CxYJmD60mXcSmcb/FS0U0mlVEF3jA9rfBTraQccxNYxORyZhTiaXr9hSX844Z8/DYzEpCIDSeg5CEaTt7WnGB0lgCRINasBCdfRA4FZxdu7OYe8qB/4yr88i2umorwUH9u5bFNxAgBfm+NjP2R1SpCTgZ/JhdEcIEig4a46o2Bky9dA0TUoGW1mCIG6dw+z/q13I71WmvNbhUBN4uEr7ZKwoyLWcrvBPpNqTVmt2ixvZnTo8SlcLFhz
 qRWcLJ1L
 JPvzFnD5j1ID//pU3wGmEn7Gx1H50CU7UOcQfYx7l3vrOmUr3mO8omNjEqzqOmDjaquMfac6KlKxnaqKTY5HQ2yDlcdSk72KQY2jslBpEg/KrECPMALA4U9efoqUaMLSl15hxnY/G8Eqaswh2H9JFix0a+vAbxQBIJV3bA/MQveVyuuRTgCDjqy4ncs0xqNTnIiHSm/fFE+3gbiO3zCCY23aI+8phKQ+MS4528Z1ZMS1plP0Ttp91Dugx3RgMe4jawKCQWU+TnERl2sfQOTo4GjIIuzRKcXtoH2COArUVpDcYLL53uayJhwLHwKNDFvkKYK3SIhX3dtdwiEJrznZk1yjLzwJLGwhTXITpsJd7L8Qvma0/7VB6GRGxoAIBFSfm5kKEpA0mF8eia8Hm9UexGUvQY26HVuA9AeDlQI2esEg0VyLeMAasZvWm7zHraHwDz6Dj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oscar Salvador <osalvador@suse.de> writes:

> On Wed, May 06, 2026 at 08:54:36AM -0700, Ackerley Tng via B4 Relay wrote:
>> Hi,
>>
>> The motivation for this patch series is guest_memfd, which would like
>> to use HugeTLB as a generic source of huge pages but not adopt
>> HugeTLB's reservation at mmap() time.
>>
>> By refactoring alloc_hugetlb_folio() and some dependent functions,
>> there is now an option to allocate HugeTLB folios without providing a
>> VMA. Specifically, HugeTLB allocation used to be dependent on the VMA
>> to
>>
>> 1. Look up reservations in the resv_map
>> 2. Get mpol, stored at vma->vm_policy
>>
>> This refactoring provides hugetlb_alloc_folio(), which focuses on just
>> the allocation itself, and associated memory and HugeTLB charging
>> (cgroups). alloc_hugetlb_folio() still handles reservations in the
>> resv_map and subpools.
>>
>> Regarding naming, I'm definitely open to alternative names :) I chose
>> hugetlb_alloc_folio() because I'm seeing this function as a general
>> allocation function that is provided by the HugeTLB subsystem (hence
>> the hugetlb_ prefix). I'm intending for alloc_hugetlb_folio() to be
>> later refactored as a static function for use just by HugeTLB, and
>> HugeTLBfs should probably use hugetlb_alloc_folio() directly.
>>
>> To see how hugetlb_alloc_folio() is used by guest_memfd, the most
>> recent patch series that uses this more generic HugeTLB allocation
>> routine is at [1], and a newer revision of that patch series is at
>> [2].
>
> Would that be
>
> https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/#me2152fa2cc79d651ecea7a2bce8b57725fb57465
>
> ?

Thanks for checking :)

The link you have is the latest patch series I posted (let's call that
[*]), but [2], or
https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25
is even newer than [*].

[2] has some more bugfixes, and is also on a newer version of
guest_memfd conversions patch series than [*].

>
>
> --
> Oscar Salvador
> SUSE Labs

