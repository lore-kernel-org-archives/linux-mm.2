Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B881073CA4
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38346B0088; Wed,  8 Apr 2026 08:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8FC6B0089; Wed,  8 Apr 2026 08:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8146B008A; Wed,  8 Apr 2026 08:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8B46B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:11:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30EED5C215
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:11:41 +0000 (UTC)
X-FDA: 84635274402.28.74D0F2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D5A61C000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:11:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TAkH2mAK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775650299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BRZY+pcnQ08ylQgO8G9gh28UYxAOGWlZSbhClXBliw=;
	b=udq2NK9KkFH0SU5DxkCvodFnEOX+MjMwFfdmVtlR7o8RxaZcgAr+oUFEAMpzI5BF3x5Eh5
	5K0MtG/cv8fzo/M5Vnn0T9V+D3zzHORlWfkqJHlmOIhgXH+nFiR2yf7rIUFOm6yv2VxtnJ
	5AokPfoijbr1DBcIp9q7tBFKv/jdMlE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775650299; a=rsa-sha256;
	cv=none;
	b=1RWzoPhSmR5r1owYN0GsLThjb5xfDw73b+4TUDP2ZKHqIN6es+boOSUKEyEtmxJMgFQ75C
	Gf2AoeZEdl+gjBfhZ+PexcBHbMLkKJNkcWAJE73zHi4H+29/E94wLc8oPRj89LvwKTV3M2
	zGSrh5zSCu7oUSgff3emDUh3HHE2Ssw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TAkH2mAK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 578674454B;
	Wed,  8 Apr 2026 12:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1987C2BCB0;
	Wed,  8 Apr 2026 12:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775650298;
	bh=Ol+xkN6yaT23Br6Zs3lLHk19S4Qvt/lfnkQJSV9CpQc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TAkH2mAKU9+L0aYV86ZGKaI1Udhi48E07kE9syr+C0cYRaY7VSH8uj0mBczjN+P+O
	 9BT6kqIYyxW2CeaNpFeuEqq8ZyT55dtf+rM/6WHiAjLM8Sz5QqSkxDCWmWXi4arYlN
	 kqFm7R/hLIhvb0iy+4osKVJMvIRUj5ZeAiBEL5+LRCb5uEhQBGGmLHyxoWp3R2TDDz
	 sBWxJGW131iejvn/cnrUdaZU/USSZLjRJrEMiRQiiYEqp3oC8ipfv7JblWXjHp8sv2
	 B3BmlcbD7XIzfP1Y9qB+ZLnQJA258wJfBSU/vDn48ESNv8vXRSG8YTHIrZA9ddhu3e
	 wpChoH8SkHo8w==
Message-ID: <628a1d9b-cc16-4cf6-8c19-b6ed49af8492@kernel.org>
Date: Wed, 8 Apr 2026 14:11:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 05/16] arm64/mm: Convert READ_ONCE() as pmdp_get() while
 accessing PMD
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-6-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224051153.3150613-6-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6D5A61C000A
X-Stat-Signature: y8z74557jfq9ci4bzs67oejn4c8ig597
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775650299-309349
X-HE-Meta: U2FsdGVkX1/oe7rNZwJVKCTf/MXczbBxcu+WUZTC49NviPMHX10Uj4BDw7l7C9ddbAatBoBgD8Y+H2cYeYNs3JfSWyz1dMqAhNxgmNBynNtvT+XkRsGcykIwluymPSgJ9YKABfocMqeRHjaex0c2JoosnB0C58w7fSVN+1KTT9TZ51B0mkU6F7eL5eJPd7wAaXqFLkQmaq3Ns8sM4Np9PFM4zamdXqWkpWQkHjSUkQWHdVAweyfjWMWhQIZNK9+KeUBK+SNHDJRruAZBny4+fW+8wDbX367GU8uzwcsXBgiXafWN478H0RqqeRVr/bS1xFLRw6nOLwsgDjy2RVtFLdZ9Gzm8R7Nhy/ALBoBLefY4RdMEwJJPRsjUpQvI1yt9FY7BU07Z3qbtyez2dhHTPT924SjKFqvaOxw1Zo0ToT/23WU9dU53HuARH4V3EvxuUvC3pov/ZQ4EmG+nR8MxxuAhCIC45GKFcvAP/iYHWITC8d6RuMgXIeM8IzXLuVAwdGhbFcz0J2B6tip3RRyXpsHwKHIdTYYR3v4sSzzmIxkV2LT+Y2GWRyh99PXEidf/SgBkeP3SQyxJh/Bd9Mf03KCSTLjXSMzj6rdR9sI5OaeVDAgCWzdo4ooVlJXDAP/HrowOonCF+1tZCOQuqTpV/veyYQm3v3cuLtxv3eUEYr3eDxIx6hPSXuJ++IIAjefrFLqqV0JNKxrvTsQusHHPKZXs0DhOqAO6ADABGB7IBTNR/Ycg/5Stde+0rk/X1Zl8g2DlHeprI/N1w1ikMEbuTfE+DKiHYz4KgUtldSlQ+O4lTlAdpJwSW3YXjXsLrXr6feUk8RCAliw2+wroVBUpJfxl3+yPc+8F43qrmUcB6e7/0IjxfgbOJHceIrCOXrmIpUlDMVIYYZHTOWmEr662SDiK7fPBr3E3NmpekvY5GrHJMK0Qd0XVYkeZb9UUqvwaYYIx4enX4SlfYFMQTrQ
 VBTzf0CQ
 OtcauXSYRSckakD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:
> Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
> support both D64 and D128 translation regime going forward.

You should mention the move from pmdp_test_and_clear_young(), and why it
is performed.

Nothing else jumped at me :)

-- 
Cheers,

David

