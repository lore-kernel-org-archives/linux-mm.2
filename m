Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47314CD5BA0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 09:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689D68E0011; Thu, 13 Nov 2025 04:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661348E0007; Thu, 13 Nov 2025 04:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E128E0011; Thu, 13 Nov 2025 04:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 459CF8E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:09:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D62751A08E7
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:09:56 +0000 (UTC)
X-FDA: 84105011592.10.3EC24A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1573540011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:09:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uj6/Pi6b";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763024995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3PNNHGLr6DEEVOXTwKRwy0//P8tBdERe8w2q36scgc=;
	b=CJI8bCOC8VqypBF0tcMvt4cqMAiAE4n9+AWMXfyqrx8ueD1GXAFNANWq+s7qZbdPuE3yGW
	3Jp1iGQ7w9SWLYPeFv8ZOS8br/sj97F7F7sAvE09f5fLnN9Py7sSMpm0ehn2SLRQBj63I2
	lIwRr2LI8AdxRbX4r0bCkOUvN1MeO8w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uj6/Pi6b";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763024995; a=rsa-sha256;
	cv=none;
	b=nPLuu+q97YoPoV9KC3DoMUsTjVdq35Ed+s4sjWoeqWGO+JiGBcHi4v42oD1/4YDpzDLy7a
	y37ngVVJSaf4hifNkg9TOPbOsvuzEPcdMCxJbQ8ov01oQakXLH4SdaB0oLltxXsI1modrt
	C7PhU7QZyO8Wm0dkUUPNZvtqAWMVeWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04CFD43455;
	Thu, 13 Nov 2025 09:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5EDC113D0;
	Thu, 13 Nov 2025 09:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763024993;
	bh=rHmd0rMUHyefZtIXeMVesUbxq18R88JCSA0oFW1Fm0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uj6/Pi6bfNWw9ZykppZ3qDAZRUlr46B7/demige9vo17lWrcE75ESNOuLgJFYiQjk
	 8u5/IVA5HgmEyMUG83YUQqs8bmhFarX/1SdJofCeyX0Q9i9oA2in1+hNhxxTYal3iJ
	 4DUfJTloVfkqDlg/TPjiWY6my6JLWQ7kUqouZXhXcRJgL4W+YTsqP+Ul0us4XWLP2y
	 2u+zaaLg1iULPBIsBLLCfohBG5bBrdeYMUgA1KgAeWLNktelgyw/NkMK+16ELR/OnI
	 WX+m/WjJd86on3z4csb4zbIydeIC7sQI2P4EmrV17qM5k+XyzsU+vbwhDw1hi00DdL
	 jdKgUbGWYif6w==
Message-ID: <5bdd8b10-171e-4171-a1f2-43c029dfd8e4@kernel.org>
Date: Thu, 13 Nov 2025 10:09:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fix gpu/drm/nouveau: fix return type in
 nouveau_dmem_migrate_to_ram()
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
References: <20251113051322.1753532-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113051322.1753532-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1573540011
X-Stat-Signature: 1sfmye7tpspy31mkyb38g6jzrjbyxp7i
X-Rspam-User: 
X-HE-Tag: 1763024994-542023
X-HE-Meta: U2FsdGVkX18SfbnMKXtieYlWC7bS0b6pFdYygQiNChj8uBKdW2rKsrxnwsfvCxI3D12FVP9M2rsy2MsfsUblLYVYmqTAXLqIzdbgKZ7bhiC8LDtExegD4UvITS8FsQ1DO7qub/mtbkZ2DL9Lb4JGSqXeowrUfnqL1uYleASwSZN7BZKPGajP93D8Q+v8iTPL2JK1MeXu2b0q4b6+VGxZov6JepoMwfsjahcUFpSEyDGQUAW7nwvCQAhR3TNdl8s/bocGuHg6iTuilXMS/GnzyKvzp9tEbxSJqlFeUT0YJnL81zCCEAUs9kQTbXft2rYfP17zBEDpdxBlCDq9zBwNC+vg5heX61G/pu0Spdu9Sr9U1ZFkT9RtOtFplunHG5PKlH3o1BRoNASFEPEwkG4xWPc6aBftRAW21jGSuDs7Sl9MLH0N974U52xwo1B4qKCgIjYoNkiLnvJCDnF/PGM4K3Z+FmP4q+gemc/05yqxAfW4nsPxWF1nt03c14S68SghYiQina4Oq6apLrxZ3SnY8Fy/DwjEKZ6MoCuN5Xq2IpWTARj2JwDoO97lUbwAdJEsbHcwNCvGq+A6oWtnyjgybQVxeETI4aCxWfvOtpm0V3uem63idecyVZ0xsuekYydl/2PfZ5Jqh2bX7FeIKynqwqnHmReiPCIl1jSnQsCZc3reWEC0V81YAF1TWg9flkRb5z9T2617mTVps+ggFJS5mnN+GwwQjToirmrboxuDwH6L1k4Z1SCVT9Xvpp7N03XmmXX9LWZ6Ye8LgPGE+jMLjsLh49o236C1yvef2wstNF0O84LHhS+m6vUgIFgSkq4qFrmbVX6mNWrPed1HQuzLMykRvX3Dwsic7dne4OfIab/JnsI9kMt7o11Ce3UJJK5O+d5idd0u6PxOOcv1BAVz4gf/6BvulsTeeyQbVi1BFv7FYoepT8vIVauSfGh3oztPFo2T3bFS9hOSrpT68O7
 ZrpA1L2c
 zq4ZXzYvueJp8l5sVvYDcGYyHbssBR0IDASPCKswKF1elIUK6ya2f+gqZxeV4v+JRxUJrv0CjpDeMGaEq3dad2t8CNSMpMha5HL2AWMkgON+bnfPfkZ5O5jPwUad8iSH3+NLy3cfOXQ4aVxjzHHd/xOQcqgvZlfDf8ZVOORkoOTeUpQ9BF3vb+bLDm7flvHnzc0IrRwo3P19rqZLTaEHgyJjl7U1pWiD1zUsjkxHLpS+ihPjH6fjS1ZKhaY4CYQMRtG8RbaVL7NHNJP+iQ5bZYDQRsIfuDA7NwLETgTGHWSLJKhhdyqbrR2ii1BUvJia4jcGZhBZjB7NR3Bs1YR69kWVz+OlbHSHMEG8Z8d8r4uKfmqVIwWWYTO+AM6TQoDVDynA9Kgwd33mhwbQHFHOsChAAbWdaTjiSzLcTrGex1G5Eu81cv4qcl1wU3NDZbRICGykt70eAxjym24ARuNtfeUt7C+mXBtXNq7Y2qoTrSX+0om7TTSCWK0L3OoM6FMWbylS1Z+Nb9374D+QM58AqZuTRaO9pi/rPAZCSbkfWyyXk3Y1MZIy/HTGilW7VZSplQ2jGOy9forAywMOty/Y9ELCrA/ckIzWo+9A/7Nt/0jehqgupY3rCgOSqGU9CStkRW0CH/iPpm4IhmagZlsW/wLuMWmGje5J5idd87c/qZTqu6XlZVqHque8KgLzIGTBD5XM9XKYy5KBm+1GOXYBHwvxud7X5RjGgUXwK8UqU9hDyFyaesffRmF2zxTCoWp9pMIZcG/TkeFJ3TcizDE5vkrsZN2GqW20PhwsC6ZQBck0p9WI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 06:13, Balbir Singh wrote:
> ret of type vm_fault_t is reused to capture the return value of
> nouveau_dmem_copy_folio(), which returns an int. Use a new copy_ret
> to fix the issue. The issue is not new, prior to this the function
> called was called nouveau_dmem_copy_one() and ret was used to capture
> it's value.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/

It's a sparse warning, is there any runtime effect?

> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 

Fixes: ? Or is does this just fix a sparse warning and nothing "real" we 
could run into and cause problems?


-- 
Cheers

David

