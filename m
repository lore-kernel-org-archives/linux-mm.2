Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76918C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273BF6B0095; Thu, 16 Jul 2026 10:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE566B008C; Thu, 16 Jul 2026 10:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0765C6B0093; Thu, 16 Jul 2026 10:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D04436B008C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1311D1C0025
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:11:29 +0000 (UTC)
X-FDA: 84994373898.28.86B77F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5F9F1180004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:11:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApHxBAhg;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784200287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlEsIsMy+xiqP+sE0QJNQFS6r7wucHYdEueItdqzztY=;
	b=xwp15nqK07ibyil2mVRW7kANpw+wTM36Rs+nqR9Ia5weoiTXtjUWesYzgQdqxt82OjeIIw
	iHXxr79FEt3skdiptpY6UAsrXca9WySkXM6UhyGpdoMNkwnLUhP8iCczf0e1SxamZP2DV2
	YaVmjXOnYnqLmbHUG3Kg0jtoye212kM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApHxBAhg;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784200287;
	b=OcBtmcc0lO9x9YTM6F2uxywtgCfcXAra/iTXVXH8s8btFcaYFbo7Oo1W3AZ0KDtBb+GbD4
	fajSxBO5pI7uCY2mbnyjTkNkqr9yM7ylHpNbwNOoQBAIGALFoOeYdrDti2pdVaGfj1i654
	5U23C42f715j8LQwFTj8e3cFR/eBBPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F14C9600AB;
	Thu, 16 Jul 2026 11:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341361F000E9;
	Thu, 16 Jul 2026 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784200286;
	bh=ZlEsIsMy+xiqP+sE0QJNQFS6r7wucHYdEueItdqzztY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ApHxBAhgxK4rZgVAUKVSLikt7oCZykDg0dWIqcOcJzhXm1INviLh3+uA0MVJVjaUM
	 QfuDd6LggOdh1jHMvQqki1nhHzSIhWMGYdiXz0trCU5m4gsMPOlMnKldweAE4XJcIf
	 7KrnW6I2pk1naFH5bhozl0QgZwD9tPOyFrXval70wa9tA3qMNRFL4Q7HbhJ4CH9YD9
	 zqYDuMu70q0j4bIkDyYoIgd3W5ImW8GeEYdz+1naH4hvkHYYMso1B2ROTjF3bneBoQ
	 2u0p+Jb5pHvACMNIRfzEHw8ZDphquf8918mWsqMHpE9hJKkryG2kKq9PEsk5jwq3BK
	 UePj6+DalNZOA==
Message-ID: <e1c542fb-fb77-4d51-89dd-60b4991c3e0c@kernel.org>
Date: Thu, 16 Jul 2026 13:11:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/huge_memory: drop dead split helper variants
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260716100345.473473-1-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260716100345.473473-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5F9F1180004
X-Stat-Signature: ijmxmg8orap1k3gmbszsb1an9n85ip5g
X-HE-Tag: 1784200287-384483
X-HE-Meta: U2FsdGVkX18T4o6A1eGazWS76SPLoLAYaQqyzNBPnlsNmEvRKz6akDfKLDdRn8u5sYw3GI7EeIfeWcyYxeQzfUWnK79PtanVXRW9SmL3i3MLMhlpwPL6MGoLf2lAwDmCOgJAhuvb3Js+LQM9l3jXSKDNgTt8WHwsSb6d2aXTu/ZHZKudk8gudQN4Uotcq1pf6TWFaHUhBbePIVZmCz56BT0yyRx/UI789Q+pIrfgRQ2flpuFreZxRSKFwdXdtC7udBGr4hBmkvtdvANb/WgTqU71R22tuhENFYawubsUNjFCMKk3acMPAIBMTghfSo2V6lNOpoAFvFTWo1eiv9/YgOn46mpXZBceY+/aKU5yiiRPFZFVke6IQj+Gk61Y+3z4eAF+5Yst1xOXIq8ZLtkYBYgS7LUwaaykawRyT+sA4L54bfe7Qkti479ZY32PAzUFd1PH7P21/HFm+sRbPJFG/CEQFtJSce7L8RgOaREHdeVXp1jADudGDbdLFDzCKh9LQRFxdo5p1QVJyfEWcZLHt9Sb+95641X7noD4M+XbXDQEuGU43kj/Cf7CKaXKlKPeWMlp961LRnK7M2aGF+jlRoGaASD5Ao4z++AJiu2b6Ba5WcypIZFLMUj4BIeci0IT8fxN36zuxMkzwE7G9is984eKsAnRww+9OLdgM4oV05yC3QHZ/3eCfwRGAznieqcKXOa6YIG4Q5ZGFzjtEbGld/twWHURsAW/CO4w/PFOe+2ML4zAhhoi5XTChpyEWKwUCso9tdP82UT5YN0XjZAQWfqImIZcrYGMzAZmsUf0UhmDH6doebECiNDoWyxnYmsZazCAoPnVq/pB3D/iMMrQzm/g5NQJ4qP7/JnW8VLe1bF/ax8t/+k72yH8/oFU3cHdzlEv0tkjKUpVqvJWGbfx9Rj9WUEo7l45Aucro2l/Tl314jFeK/9Epmd+R7EiBWyZO4d7uWIzuBypFkXtGWq
 tVvnLsc1
 f2ZYVJ+DtMgNAXlyIxRsh5y96vL2reaNxq59kFUqzIk+5JUtvI3pO31MLvUhxtI+gq6OdvxPfZ5gStZTvMq2hlRzAm0TB/ulVq36QkIYw39EXED84gE8N9Fv//a//6Zrmsm/F1Wz/ysrL71rAxVNblFK/8VHsD/9xQvBsvXapLIXa+n3gP2DEzRTFcoVPD07fgj1dhywv0tsLGXaoUVWLQOXyZF7tM+EwJOWf5cTm2nJxITDxcCC71MmueA2fc+YCTIe3va2FVycjpisdvyodepl3igf8SfMhCuRhJnFf20zqcR9c2P9Wr5zJB9AMIMIzLPETqpdU9UH8QIg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 12:03, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Two trivial cleanups in the folio split API, found while auditing the
> split helpers for the inode UAF fix [1]:
> 
>  - can_split_folio() is dead: only the !THP stub remains, no definition
>    under CONFIG_TRANSPARENT_HUGEPAGE and no callers. Leftover from an
>    earlier cleanup.
> 
>  - split_folio_to_list_to_order() has no direct callers; its only user
>    is split_folio_to_order(), which always passes a NULL list. Fold it.
> 
> These were 4/5 and 5/5 of the withdrawn series [2], rebased without the
> memory_failure() dependency. 3/5 (removing split_huge_page_to_order())
> is dropped: with the UAF fixed by [1] instead, memory_failure() keeps
> using it. The syzbot ci failures against [2] were all caused by its
> patch 1, which is gone.
> 
> No functional change.

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

