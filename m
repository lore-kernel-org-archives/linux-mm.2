Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52174C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53ED76B0098; Thu, 27 Aug 2026 12:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C83E6B00A2; Thu, 27 Aug 2026 12:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9946B00A6; Thu, 27 Aug 2026 12:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 076D86B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:41:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93E3F1C0030
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:41:27 +0000 (UTC)
X-FDA: 85147615014.15.E97D4FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA50D180009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:41:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6xaLIzY;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848885;
	b=a+80M9VKqUOpFK/WcG95Pn9Aj4spGuiiXsCenpDtwa0rw2iR5nn1v56s1ROJEuiuxCMaKH
	uGarcvd4u/3PMYqUQXWLEilWejzrbUeOH0hN7AXh9MQ4P6uROqWjxAIb3vtJrRIowgr7Qo
	EXssBa/fnllUpZIEqDZfOb2v5zkZq1o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6xaLIzY;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCC2CkHOGwlKpi+16PhEFCGSE3IEc/igKIbUU+uMh80=;
	b=XM9Owe/lCQ7ILyYBqi0BRqGJrFAg9RW6C6jfiX+sUlL+IdKNJ6Q37AbyGyVoQshYtsPhWP
	vy1JVlnRaCPbkca8wD6/pLq4Mfk7kYdwkKDo18CDV6NEop3N2GlXWhAD+ieXUqEnfooybE
	qNyndfzJiHdggCZOZomtwi5dzlx7hL0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20E67600D2;
	Thu, 27 Aug 2026 16:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A42D1F000E9;
	Thu, 27 Aug 2026 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787848884;
	bh=bCC2CkHOGwlKpi+16PhEFCGSE3IEc/igKIbUU+uMh80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b6xaLIzYah4sJVfBReqcEi5FQT78DXP9WZ9cbcGxuv06r/N6WfCkWKg/xp1UBhRPP
	 Hyk0oWIix07jekjKLzCKIEqj/ottYR2QZR0DgQwyCNTM098m2ur1cma/eJM8+jCjmZ
	 fBaL8WR3ptaZK/QPO5BETCTgamTASyLgnU8jhziDK4faVCLPUjSEQAjsuhMIizvrk9
	 bDXmGFi0V+2lKxGqX8tM5BvqNbSj2r13pkPpZtQRn+spAXvMeA5ao70UJfpt6civlM
	 Qj7ZzlWe7VA7pdpK5Pc07Zb8ijR8Bi7vrzKDFX9/jt9uQzIgEVQoccxBAJnfIpIlUK
	 hdkd4kxMJm2Yw==
Message-ID: <5ee65970-abb9-47ea-b548-5430b382cf7c@kernel.org>
Date: Thu, 27 Aug 2026 18:41:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/18] mm/huge_memory: allow splitting mappingless swap
 cache folios
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-11-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-11-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA50D180009
X-Stat-Signature: tqj8oofxmswobog755z34oiypbpxogx5
X-Rspam-User: 
X-HE-Tag: 1787848885-588875
X-HE-Meta: U2FsdGVkX18z8D2lNcr7w8zgITIMOpKetCd0+OcuEfCZrNlZJMW/F5mJMOBEw+zkdDX4P8vY+DyrhQI7MGN+N5ttd3rtXw54Ya87PX8Q5YHmEyxf2nnk/qJGPMbRdyV480+XMrZupPu/rfVJSW26iGfarVTNaY64Ojn2LxlTKBsABIkKcqhYh11snv7oyOcuo+CKrDk7GChlMyKzS1Vs0cDyOEdJ4SMq13ojZfY9mJ3w/JF2lamsY1/bm07mWKEuxxxR8pVyyUsAmyLXsqwNn22LvKfX7qE8ZxaGhWnmbafBhuRhwV7mTqXdzT8MI1i7+KDZ6ljkz3zmK0VURpI8mn5rfDpDKd0swaWaiMxqx791jfXXpRo3NSEd93TOHvJdBh63CE7DlaAKCjGgpc+p4k4V4X6NM/s9Gsl9am9cfnE4CXIMoClAdr5cwDWipKnz2Ij09+1DbgJy8+2u9LThcUCsLeAeBqFBPa/kQ+50iPaL8QKimYteM+M6vyP/kMs1DvuAnkwz8KR9x6fDffDhJBMisN07/eerSKca6HNW9ACbxUG5Sy6d8FyFbaDgkBoTpinBOJxK0YY3g1ux+n0xW5CvANxKAt3ITKafAWpQf5sAQVT3WapTkpfcZtMOLObZZMZ60WcO5pFOpQLEGlqcHYMPP0Ng53VUQFWi4/76dJOo8E8NCxc1IygkYnEcklmRjx4vxFBRhwQN78H6TMEeZ2a14VuxVnOiTkLfnED18eeXKbzpU5ZeouPgdUAak6RoLfrD5K0aXmmoxIhEuYOxXeCbp2QHzKXcgsJOZpjEr+H1dR5JmXgz9YdmoLVJtiZ4pdMfpFTSgM6pvcLGTArbZLWdX8MrPiR3PLR14KDMDxwcpupZb9RfKy1HIQJw4Dl3R2lY8X2DUnyhEwfzTrIB9CgtiXlC42PGLEpsgZJgkh0X1fFgpZOX7iKu24DWha3WkeIiytZHWbC2aLq6kxz
 JH3cziAe
 5QfTnlljaOfuMnoTu/PXbvMy4NkqiE6xnwXqWUw5SNOchwMPGDM7uHD+aY4PLnebWWgnq9sZmWFz7G31Uw/dboRNaVgMHCYwFNbgnTITSSxul6QoZujUXFS93v4C/4Bpt4HaNp81aVA/ok1Bi93r4ucpr2Tppb4Ih74HnppWEow3N6C8rZpPYjpObPhoqLk293M1cqddcz/fLo6vFk2LPHD3JUHY9xSF808FF+v2ca8nRnFcFJ3cdoACSMEojXFPea//i2v5k1hjS0Yu5oCk+e13nhgk31bJBlmJ8VzSoOyPv9zvGYknF95QP8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +	if (anon_vma) {
>  		if (!ret && !folio_is_device_private(folio))
>  			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>  		remap_page(folio, 1 << old_order, ttu_flags);
> @@ -4259,6 +4261,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct page *lock_at,
>  		struct list_head *list, enum split_type split_type)
>  {
> +	bool is_swapcache = folio_test_swapcache(folio);
>  	struct folio *end_folio = folio_next(folio);
>  	bool is_anon = folio_test_anon(folio);
>  	int old_order = folio_order(folio);
> @@ -4285,8 +4288,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	}
>  
>  	if (is_anon)
> -		ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
> -							  true, list, split_type);
> +		ret = __folio_split_unmap_and_freeze(folio, new_order, split_at, true,
> +						     true, list, split_type);
> +	else if (is_swapcache)
> +		ret = __folio_split_unmap_and_freeze(folio, new_order, split_at, true,
> +						     false, list, split_type);

These two boolean parameters are really a pain. There must be a better way.

Also, I don't like that __folio_split_unmap_and_freeze() sounds generic again.

There must be a better way for that as well. We had a clean split and now we
mangle it again.


... but I am just before my PTO and out of puff, so others can brainstorm on how
to do this cleaner :)

-- 
Cheers,

David

