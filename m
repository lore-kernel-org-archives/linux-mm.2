Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A86CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6596B008C; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737536B00A6; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562806B00A4; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 344CE6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B254DC03E7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:44:39 +0000 (UTC)
X-FDA: 85266163878.18.FDF356F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2072100006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:44:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fy7FxN0I;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4L/jE5ebP4VaIcoaqlRL5Ew3xtGuWL/copMvRUYC5A=;
	b=g/R5kCh4ws6In5fG81VHoyo8BVCqXaxpwDsA0HHP33CPOVonkDnHIsrg+NH2dQGdwaPPpG
	x9HUbyF49ywF7JH1mOAcGSlLRJP9BiHmE5ItGoF+9S0owRVYpwUEteGCxrUZj5E1Atr5nE
	AdJSVn0Ilrp+rjKTgQDgHbkEVKDuIgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671478;
	b=d+xM5Yt6SNWTVvW8z8CNOBRZ2aaiVl0y3K0j91FvNir0Pr4FPLK2e2UuzwwyHEnm0vOTSI
	xYzUdF/uGu6fh+OvN22zCYzYL34C64tQH1m73uijuiIRS42bhC6mPgNqX/vh2ihtxZ9caa
	ilwcgzH3YHBk3CMbadsbMVe1mH6TLqI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fy7FxN0I;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EF9843C18;
	Tue, 29 Sep 2026 08:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44961F00899;
	Tue, 29 Sep 2026 08:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671477;
	bh=x4L/jE5ebP4VaIcoaqlRL5Ew3xtGuWL/copMvRUYC5A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fy7FxN0IlIRFzxaE9D0CVee2wD8aBYfBGhMpfSJ5mU35Z0HXsavQxNKOJ/ifFcHDB
	 7DPywdjuwW6jxeQxSR5zna3L6bplj4pTi5cOgmbWRH1DFbAy7Bta8TKii+fCWnJ/YT
	 wd/VFXsLIIS0Lge88piuCgH9Vfj2px2o/oOOng34Htvac3JdTduprEAiqF9RthPeKe
	 vnir0muq/qdyVBQ331EM0FEjj//JPAXixYRUTRPwd5drrOmrjXjgu1onPQ5bxjzvfP
	 Q1lef2ekkipbtmQMDmSfMaZeuYVEQreTpQN4qaL/CjE9qJ/eCeJW0XbWijFyz94b8p
	 32SMVGda3PK1Q==
Message-ID: <7b7f0ce6-6f67-4f98-9408-59e9d0716135@kernel.org>
Date: Tue, 29 Sep 2026 10:44:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/12] powerpc/mm: switch device DAX to shared tail
 vmemmap pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-10-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-10-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2072100006
X-Stat-Signature: qytiemm4m4mskwby7pze7dzp6ibrcf9j
X-Rspam-User: 
X-HE-Tag: 1790671477-429327
X-HE-Meta: U2FsdGVkX1+B12diHt1qZ5mNWy5uo28WtOjx0u2xO9ZMlqj1AbCvwXgo1S7GuDPDh1qVrvCIhi6hyL7MvmEquQEEMWZ5al4n7529l/DQwf4uSDqGTiP/g8GRjb2+s16fX76xUR7pVDltE0rMumeGtMBI9KwCnR9ksPWKjot+440WRHHcl36rIFA78U8Z7eugzB2MbiLXJGj3xZSALT7Z4w4Sse9xIopKYcAUghLXgKPlRUNCLpi+TZNT8fu/bdcSNFXx84yfmgGJeXbiuDf2WyFjGWTrfoEQdRbMbjpXEMoHbjdLnjHeXI2o5hp7Vm1z9MvZl+UMYttPX2UPidhph8cq149kjs6C6OvbJRi/wzaCYinFfgZdOhhUMFJhzgPD1XTZNW6Oga8r36wtf0MBmYOoul+J4G+HoU29cQHPzeOIEDvsc2Ib0dVa9NOE/3bebfIrNZ9vnwJHXxtWxJybJTq3GU92V6M4s5dfWJwxjKnAIqSJWdlWF1Lpb+p9aw+p4X+xtveFGuEFFPWpEuQ38JcbjRVh5ss9T3VIqPuzPW++8JTe1Y5Ron2XrKExaGK8PSgGIVz8poATt0xq2WNAjgjh9D3Qqn/gk3oMfQGOpbMMZbLGU/5KG1pwOcqColiR47fhbgoC2IwICjmDPvxhWKLGDkCXt7lNErPJf9HSPg6T1jq+Phvcq6gKX90dFomka3S3xHA51D/H3jTKbx5XWyKd38UZgHC8y/uXiDXZ9eF3l87oxVLk5dgSmYJ4FbdEWyFKkcsXRjIXAuWWCYbhuQjI2mUJMRmGu7c94S2irYYEZliW46sCc7FqrPPMg/TLPydzqTPws0PlTXHJ+c7akrwQstbxh9sjZWlMyluQzM+fgM8XDNBFBUGXz13z/Nwi7Nlm6wBuAwRnCe/nLpYzSib21Ms888duOpGig1yAt3pnAinezPCSG2ryeYpKxnOzF9qMGaKVAe9O5hcX3qC
 Z+Uc4vlI
 mnajflyf1YKNocbzHNom99QmH/JH7tmk8g6agAj0IhEfSxg1qtEBaylm9GVSjkpvMqdmzG92Bj5TN93bSm8oam0DJYvXBws8cGbDYZpXaXuYqTYFSolHhomCC2YJg1Lu2Ayk7LZPQzHWLggCE3DTcIi7Ph7jDnstD0675QPK6n5bH3E0z1WAng+SWqhuZomWmal9ghKUORlD8FY9cPwraUCe/QBTKoYx9L9+mhPZclNG3zMDKfkGbme51gDZcKPK8RM1aGPYrMq3R7TOs0f1J8kloydcp9gmghzHsZN9KZ5/3XxFuP7pTzJ2Rsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> The powerpc radix compound vmemmap population path still finds a reusable
> tail page by walking the vmemmap page tables.
> 
> Switch it to the common vmemmap_shared_tail_page() helper instead, so it
> can use the shared vmemmap page directly to simplify the code.
> 
> This removes the powerpc-specific tail-page lookup and its fallback path
> and aligns the device DAX vmemmap optimization path with HugeTLB.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

I did not grasp all the complexity of the old approach, but what i read here all
makes sense to me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

