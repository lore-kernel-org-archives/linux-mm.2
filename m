Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46117C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F956B00AC; Wed,  9 Sep 2026 10:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5B06B00AD; Wed,  9 Sep 2026 10:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE186B00AE; Wed,  9 Sep 2026 10:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF116B00AC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:07:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EC45C0206
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:07:06 +0000 (UTC)
X-FDA: 85194400452.10.5C69040
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 959FC140017
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:07:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZX+G/b3L";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COu9YXS5z+3bJ5HpL8E7btRECMkkRv1d0ERtft6U7Fs=;
	b=XKvqfmzna/TULfWqx5b5hgU/yVSPQ3/JezTi3OPU4uxYIRab6PVIWPnsTGgdtDTjGVJr5m
	QM2u/dRCQY7zn1grUpEd2o2KdvOxcI7QQvXWFbqm1o+tON/C9PRAxgUwo3wPYNwKnH1e8+
	fRjTwh1Yz/7bFRYI2lEIZ4WRQJmwxTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962824;
	b=LcMO7a5xaRCEb0J06u6GlWf1jrBkril/gT03OAoP+7CGijCGc6+ize/q1lrzk0aDr9+c8I
	0by4yQ3UgpZuM3m15mifszDUgtvYZqPSX8cZ5wGaw2XMJkDt+DtGDWlw0+H1RF4qP0WBVo
	P057AsIAwp3L2uPvy5YFuD1mKX8426M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZX+G/b3L";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21F4060218;
	Wed,  9 Sep 2026 14:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DD51F00A3A;
	Wed,  9 Sep 2026 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962823;
	bh=COu9YXS5z+3bJ5HpL8E7btRECMkkRv1d0ERtft6U7Fs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZX+G/b3LxH3nXQffSaa9JMsaQS0gjIJ02uJISyRP0cZLQNBGxyIRDGZrns8jkWzN/
	 gabIeV/0jMZF2bPMFRPMJrRfEmzW3m2/cePne404tI2mA+deOk+AzkvUlcVbinkIDV
	 1xjmuzmsa5tFay60gdwZS49E/lnIjV+BbwxU4W83tWTJQucaxEQgd1bWnd9Vp7N9RN
	 lAmhZsEwFcJHpDxDkvrpoGhkjAFfqCeBWPWugzkHC0RDAcnkdRCsxdKUgfWmZ0AshM
	 Gf+mBjy0u34/cgjbY6MOSdT34Ybf25cjj160Ok0Dw2UJGILtTpyQP0PG0jvvseoi6e
	 Pe439DbOCIADA==
Message-ID: <4e0bec21-4f09-439a-ae65-66a95c1b4c45@kernel.org>
Date: Wed, 9 Sep 2026 16:06:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] mm/swap: remove page_swap_entry()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-8-ee6d01dfa5e1@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-folio_swap_entry-v2-8-ee6d01dfa5e1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 959FC140017
X-Stat-Signature: 1m38rcgihd8smoopf3ff4awajsheu8cf
X-Rspam-User: 
X-HE-Tag: 1788962824-976184
X-HE-Meta: U2FsdGVkX1/8j8+4QFeqoxfGzlFsSLLfEpAoYcYpJ98BoYW9XmjkDQXxhprn3Y6m9BMwwVYVj/CFgU2zRHlj9KC1zlNhUubd5eNF3M4KfeiYcvxs75d1zXAklpKnvsRXAzcIPHCzdj852K/ST1jw1heVLGKMvsmH4oggu+KRSUCW/miticmqFHZNM7AJaRamXOjQ7MJWf3q+WoohFy6uSiXxy374IKGLlv9FK5z1UFRb1W8TGClskiL5OLstx3QDUoI9uUwRsOjnCgabfD7Y9VYhNTqQ6DWDUX1I28LtpFK+0DYSaJ9MOu0eh6tEcYbxoQfrMUDq6VyOtJP7gIVrwqnIPLfWjs5N7ZGKl3MIX902jhapRJBGijwcK7N3mYvA4NV2bcqL+344Opj0QbxgJgaEohqfHPx+MmTze1n0s6RCiySSziQK6HQxD5ydu96aTZqfyIhdWqm40ckfe7lDMQd9SX6XmuA/qQdmFIdh/lLKx9UiOA3cf9WP2IetdIr3P88s0mdFl7VnlkjKJPuWCJzpWGcHoVauHfggumuqgUnt00xvlAGklGXjtrmtAq3O7tnTQ0vQwubdjt1ZSaqfHsVh9qIZZH9nzatrndISM4EtQTivIygA1IKGTnc7Tp7zf3MjZMWZAicWDh0QBzlDyifLgxvqPeMewIlKNGIjxk4BAfIeBoqoSvtdHoAEUvDtmiwK82bjWlkj8GFwm8j2OghzPpS1xBiKBAtiQMI4EdSMSf28Fj/AK3hRhaVkct4BSPl488dVZH7L1pgBzVcNHNPzqVllmHtC9WNKhmABAe21cg0oLcnYDI++dNuPP6tL/KU73NAVHN2P0hBMh3WjTtX0UhAkUklFyjnHguQZCuGUGHIpaYv4j1QI9TCDpwoR6D7Xda9x/TY4ZqG454b9Jp2989EBEDiY/2bYtw+lWbPGr/lD11+VgXxhosL3e3Vww5qf49GqI3Jl4YTfOwv
 qjyIR6qe
 jJdHS4D92/894O2nub15qc2TGtK4szJnzmRkX81jiL8xsTOBNIDaaXt5FZGQbJu49prLMoHBficu+/2WETBkbXeyqSWXm6K3FCe/yVoDiyN2rd6jxKP2mGdsNoT6XgmQwJGUZseQqMW/E3NylRB6ObzXGQlOhjVib6emOWlDf/J5Bc1pO9ZrGiO3vLoUSfVxLRmlxw9NEgNvWTns2+aUxWGiYw9rVb08iRrkifCc1x57ikf3AOf3JPcvEMWnG2HcFO5g75YurfDmSoW8ICz8ugGd9aWC7vfziS/tXhjhUl0W3r35BR0zFwSXvh1ocGGBVpO8jhBW9rpmrhgc6GHNAimCrscekY3NoFsEB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:16, Tal Zussman wrote:
> All callers have been converted to folio_swap_entry() and
> folio_page_swap_entry(), so remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

