Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 375FECD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A456B0093; Fri, 22 May 2026 04:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A2B6B0095; Fri, 22 May 2026 04:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567B86B0096; Fri, 22 May 2026 04:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481556B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:13:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D62492748
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:13:15 +0000 (UTC)
X-FDA: 84794340750.21.901BBF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 730D120003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:13:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGn+PukV;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779437593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccAeL1ERB+r+345gl5qU77eKpAq9Gi9fPD1ei35H+Ds=;
	b=ZQLHPTQhej+VfDd1HFZgq5G/BZBpNUwKTK66puoM6TIU6tyswEeQ9KSom9LfJWBTxwhBvC
	i8E767ufdFgSX0bJqwE7T4Pd2GhEUumiMupUfu5OP8CKb11MaGXnjR8e66e+/jGxLjtP7B
	T0z2wlfn5AooWB8mSUQ+whijtXfJsTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779437593; a=rsa-sha256;
	cv=none;
	b=uq01v4I0UubukOsty/mxT8rUGWtgXXw7ehF5pNwkrvOfHptFEEGv7ITU/p+VRWYDUkVYmr
	SJypt5bi1++VZLF1UtgTM5edb27u1DHCU6qTNHoCirWxXwHWKUsqPKhCN6Tb2RdUuOqw9n
	4iJN6+xVKJL7j8qMm0arIf1G90nUtZw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eGn+PukV;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CD9D43BBB;
	Fri, 22 May 2026 08:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20621F00A3D;
	Fri, 22 May 2026 08:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779437592;
	bh=ccAeL1ERB+r+345gl5qU77eKpAq9Gi9fPD1ei35H+Ds=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=eGn+PukV59bZ4yYZYIu/6OODX6Oe878o6WY0cJENFbE2XlZkjr/2wFcE04d+3TEiz
	 Y7hHSoWKIXg6X4g4d114pWk6QsLMZYAtspGjq1mLjpQmlWXhTXmJCXkx5SzRt+UoeE
	 oLS3hqZtLjdjfJ+MQZoeSCS3N7txkvPPiulcf5cVxXKsCHqCWvYP4U5ubgvXy9/qvs
	 zUxt2E758jAjGQ2j4J7XSijH3Sk286cGzVG3u3hqMJakLtEBHyXVdP9Yw16kXWFUuy
	 s+6Uoc9bkxzRMGxVIuC2kJe2ubo/4zjiFjWRtq0KcJPiHp/dCziQCmYVqraWgsw4bA
	 9oTutTYukNlnQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/69] mm/hugetlb: Initialize gigantic bootmem
 hugepage struct pages earlier
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Ackerley Tng <ackerleytng@google.com>, 
 Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com, 
 joao.m.martins@oracle.com, linux-mm@kvack.org, 
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260513130542.35604-5-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-5-songmuchun@bytedance.com>
Date: Fri, 22 May 2026 11:13:03 +0300
Message-Id: <177943758344.3662727.2192220418077361290.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 730D120003
X-Stat-Signature: q8fd3wiroqmf8ckx7bygtddeimdf6bpu
X-Rspamd-Server: rspam06
X-HE-Tag: 1779437593-53428
X-HE-Meta: U2FsdGVkX18LnQvHo+0nro7qhV3nkpz3RX96Z/BUIbew2h49fe7FIkySCMSsQIjVvuN0oPxiQlNN7W2psfJbBZDcy3uxg8hVRVbTtut+yNvGalR1KLJY6bdb4NXBAzdmirb0HUb2njE15D7j+Mu0M3SEa4MbIPLtbUO9rmnGGcGEnG3qgfoLT2LpRax39lvbCtF2IsAJobANQ1FK2AFZ6W9qV/F6gkSxL+eB4JMD9mJJ8GpXuEidNVIMk53qzLFtU3v6OicTF2rBX5DMeq8gTa46PqzsD70+jy66wO++jCcl6hNzOybFWy0EP76Z+BXoPAjm8Tlxjsff6REdDf2EmA+wsW7a8DdTubS9xaGeamIbZ6tCoMp/DbKXe9MexxGyYEggJxXmynuQ0UPE44izY2nr+xAmcSxO5zuGLsDuecMe0nNymub3xL020aMh+phGpBBAKm4vB8pPQ3d4VnHEN8Fyncp0xf6yNbZ7E0pVZlZeipNmnPSCfDH3BjW1lp2Xt+qubXQIpxkqQWBMKqpVVlUJRnUb1Jzvr1MPgVoApvrQsW6vWiv4pZt2w1zoY1C865Mt2eH6cXJJSaiMfUw/M1Y5C1W8XTghNPj6akfPilsYXohDAMWxSm/IDBNftnbFsWyOPukLq5IJzA9hvD+fdD48rxzPo48A1Mb+slN4fyarLXsBrTcrCh3TMH3LadTm6bJxfYq4l/OTZ1jZf7j0VZnIkxTF3IobDejfRPdOgbeYk9KYyCoIzIb7tBRFSA1XJl0uT6meKYhVN0yyUrEg0UCl04yrkr0dAgzaRBD5qmZC5iZCvVSxaC0cSuqxQU1tceWbLnfWlt6exJtjEUALdY3ntJHtKQB3jg0qgM1bfpm1RFsXXm4tF8FP5M7jT7Z50k8V7MZEzF9jQDBHyoCl04TW0xN6FgQ1mvaRBf/VV3SwV5SuE040bU4FpbhbNbHlRjaHtwVidsG0nsCYdMd
 naVpKCLz
 Cqobkc3KNKM8Ea7sCt/zTgSBg8c2qzVFMWvmCBKCBSErlgdN8RnaqEizDtfviixcHqA5Y4cHQgyfG5D+teyMGSYJ3Iid/LTSU4YS1IpDqtUcmIByrDA4F6DWiz45cUXliPVk5bWCINTv6GIfXdx7zFPswbdCnCw1VNeyRR/Og2kjU19TwbpnZ77mqUjR4IwvI0V4T57FSWRBs2wmbSvs5YgcZKrAD2TWxUucC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 21:04:32 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Gigantic bootmem HugeTLB pages are currently initialized from hugetlb_init(),
> but page_alloc_init_late() runs earlier and walks pageblocks to determine
> zone contiguity.
> 
> If a bootmem HugeTLB region is marked noinit, set_zone_contiguous() can
> observe still-uninitialized struct pages through __pageblock_pfn_to_page().
> This may not trigger an immediate failure, but it can make
> set_zone_contiguous() compute the wrong zone contiguity state. If extra
> poisoned-page checks are added in this path, such as PF_POISONED_CHECK()
> in page_zone_id(), it can also trigger an early boot panic.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


