Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA96CE7A9B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A0B8E0016; Fri, 14 Nov 2025 04:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA6D8E0002; Fri, 14 Nov 2025 04:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9788E0016; Fri, 14 Nov 2025 04:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B655A8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:25:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FD5213A90D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:25:43 +0000 (UTC)
X-FDA: 84108680166.28.4AD9001
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD8894000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:25:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s03bsySQ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763112341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2vFR8fbbgRJspH1F3SP9Y8Q2Yr/ojxN3mbIJHAXXi8=;
	b=cx24gy9SE+SPB9YXtDeRoo764gJX3//Gp5SC0pEPdXU4dKUYKDbzNFmMtiZNWU4lVctZwx
	GJCv5tHjwaHLsWZ+torxW/SmYD+0Rm7NhgWCeBjRyrH6oOpl+XQyIizdr4FGhdhhr3dFYw
	G/rD+5ZadBkSC2i0aJuXpdiG01iSZ1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763112341; a=rsa-sha256;
	cv=none;
	b=7tdh4n6TWDq3gR8IdIN9zUJqDF/CMNbc5DcUuk2BR7Hn0ZDJaXkMl8p6K3YZJnlk6BTUo/
	IHWn98NekCM3aDzC/VgmzxmMl15I4bUGwcw3hU8zkNBiidJyNcjJyqUP8BgDTZ9HQmgSWu
	Ysg/vo09q8Mqxy7QTKtQL1qFUn35kd0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s03bsySQ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0B9D6016B;
	Fri, 14 Nov 2025 09:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354BAC4CEF5;
	Fri, 14 Nov 2025 09:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763112340;
	bh=AJN2QsVxRz/TV+WD3eMF4eAyBt2EDjnXsaRk0ZwmCAI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s03bsySQgTiAmWung3dp0SMdOfELmoPFAkNBYvfYICW4E2AdsUDPeW1N5wv5pYg8s
	 RFHRi+o66lqRWa1za0aVCmOFXMtLuWNwWvZl90XERNjWwweJUEI6sKsbK7znCC+fHa
	 Ei+DCdH6Tt80m+NuRmw47o5gYopA4HzQSQbNxglKFTgUQ0exQ3YnLkFzCAYp0JbKfX
	 NYLfK66+fI4T1o7wppXj6Dxy03xN8oPzvKBj6YsyI4qY+VK8/96v9jQmXoEm3aWJSS
	 nZqNCPFVSyot/quAG1s5qwXXKdWx028AIDBRfrOHHiHh63B30ihI71WDQmVJyc9aKu
	 0DELz9P/UFDxw==
Message-ID: <240b0a40-c0da-4995-b7a8-cc98797dd0a2@kernel.org>
Date: Fri, 14 Nov 2025 10:25:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix override of entry in
 remove_migration_pmd
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251114012153.2634497-1-balbirs@nvidia.com>
 <20251114012153.2634497-2-balbirs@nvidia.com>
 <406bad47-1637-4891-b418-31f510382384@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <406bad47-1637-4891-b418-31f510382384@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BD8894000C
X-Stat-Signature: m9t94mdqhs5qh4qmgturgda4tyhymgcf
X-Rspam-User: 
X-HE-Tag: 1763112341-985148
X-HE-Meta: U2FsdGVkX1/XhT+dSdt1hOF4NLe4xY7Uc5vQ3vNM3HI02aidC+z7z5rk2w2iCGXZ1l1SHDPpO8WDRyudrbKC+gIFhwayQKr5+uRiVF7F6gQdlFNjJQksNleyKYC5jWxT+IXDXrAhVuB4Uw9/Swrko2wBpeOW1juCL60AZZ8Vugoqu7kKW3lj7KpbO7WBF8EgzRqhEw39jfAW740bRC5pcWP405Ffm0iI4kar9IZ0JqarZnPq5Qox1RSUQ1vsffp6mKh3Y4ruXmivEE2oQR6gEpE7vrkPfp3GmyGKp7cY7fUQrmhN4INquyDz3HgFVr0N98ZDbkDU5MzNQROU6oX8EFadcTMqCMwtn9V/cwH95dp5NCsZEe7Tfcodyk1hauliatN8YffP04aC9+RFzwiEhrnkbh61KQCDz/NTr4Ba3Gp9QVyNd4ewDFNm7qkIvMyRScqXvOdhEIXb+syTTM4/0s/QeNeDaZEqePhQy81YqAurqy0oH/KUUApaujgovBOn1o4Vo697re5l4fnLCY3MM/h/I2uSxRezPYGJDTWm2dsZcMHd7I59s+DcDAm6uWRB3YcOHUzaiaptmPdrwTWhfUib0QQR6J2ZyGYQwdwKPN/2MsfmKtX9MCf3UexUwyhaHjluOHf8CtcIyS+z7GdiZnw2OXJS5TI2fZiOaK2v7YIw/Emb/O55FCY7h26XfPao15lR7ujPaGePq2015VzmJFm/vsKC7HsQq/xzU3t6Sy0pD41p664mHtHHiP/MYkC6QxRtWwEm9bE6MJjKQxsFD5eyEgNEt8ezxFz/nRdFc3mWHUumJ4rNzD0NX2xt/iW+UGJhDdHuPMZ9OOLKduWuB5JnabpzUrG9+8puRjH7L29TTkCoH0UJrxdxdlaC1swmAdP6PZkZpAPvx3nPefeZv5t9xsXFTbT9dybUFEUVpr/mdcdsD39qCNtlKqM66PPO9gPf1lKisu/Oi3RVhsL
 vEfsLsGn
 HGXidxrC4MH+Izpw2n7eyC70YVG8HiT68zi7VJVdGnK85YfWM4YJEpYKsoIHn73FDLLUhxMIShHckC5Wb3irr82Eejl1URNOiYdQLg6uPJ3YlPdIXPD91pot/6gQeO80xRk0xdCMfLrbDphvyDDUNnz+JA+IrAqcg57wP5NCYw6QCy1MgyFl3qCTo4Naeje5YumzTfp+XCV9Pz0DZAgTFkFGQQBz8MKGSpfyXeqacaNsf8iQQJ3Aaag5yeNOmLq7bmxoBQB+p6XLZZe19EX8IQkrMqremATd0J9cGXA3yCx7o3T3AR8TTxk7p+/vKHLN4Xp5B5PDk9Tog++vAbfLzh6ZKAmMRJ9kKHAFTgq53ZiV8a0bmGaBzOQvA7n3zNI0fwjyYvJ8eAnYjYoW7vEo5CUKDC2psUMH11hew9+05YJ6DsmxJHx3CZuz0HfXptayQcyM9KcnS/5ne7aHH6NCtRYQWDnyFWXGiCm39Sa6QfzPNyaf6tEAkjrkf7sFzlN/7Qvnlm+rfiZ9HtMO/ShrzZ3JrG/WrzvH9LBW39BvdKHXdv3mvfwK/rtUSgHcAEfYDNZo3uqRBM+F9bKUDJhIOdH54zmKfcDqQ7WOLtYyYA33hpY+YbgshI3EJUwRfxHbhmywYWqeC7zg4ESGk2XbU7HqCs1lv4iC7MYsr5Mmf8fKRPCPcQHPzTXOo6CXLGV1NV78clY17XPsjgxOSCPkttgukN3Q/WiSMLCKOux3GEZ0fOpmt8Sa7rHAsydP0bfHaDE/nAtLxxbxMUi7A0B9poI716E0pBqjy6ZMz5GbkwwclJWw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 02:24, Balbir Singh wrote:
> On 11/14/25 12:21, Balbir Singh wrote:
>> Recent changes exposed a BUG in remove_migration_pmd() where the
>> migration entry was being overridden when the folio is device private.
>>
>> Use scope local entry for creating the device private pmde. Make the
>> pmde writable if the migration entry is writable by moving the check
>> is_migration_write() prior to creating the device private entry.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> ---
>>   mm/huge_memory.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
> 
> Hi, Andrew
> 
> This patch fixes a bug in mm/rmap: extend rmap and migration support device-private entries
> in the thp device-private series.

When you resend, best to add under the "--" something like

"This fixup should be squashed into the patch "$NAMEOFCOMMIT" in 
mm/mm-unstable"

It is also helpful to call the patch then

"fixup: $NAMEOFCOMMIT"

So it's immediately clear that this is something to be squashed.

-- 
Cheers

David

