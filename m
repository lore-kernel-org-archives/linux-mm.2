Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E6FCD5BCE
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4758E0003; Thu, 13 Nov 2025 06:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9C328E0002; Thu, 13 Nov 2025 06:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD97B8E0003; Thu, 13 Nov 2025 06:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4098E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:50:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 673931409BA
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:50:31 +0000 (UTC)
X-FDA: 84105416262.15.60AF0C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C11BF40016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:50:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EjS7/pAB";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763034629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPhLlAySFT0dge8iZuuPiLOdTgnJoCiY9c581hpkIpo=;
	b=ABDsJ5c9hQSbX9JBwgKSiUulFItijWd9xg4DA6Jd+m12zMKKpHAMjBZLt5cZWsRim+okgZ
	mpMcfKjnp/LDYhsHSgKp9j2D+uBKJ82/HLETR5zfiXdw2dNMOmlbcwGVAco+LD+xBa19pY
	qAsPiPUCifY2i5Ci3O0x0jq4r8yRXZU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EjS7/pAB";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763034629; a=rsa-sha256;
	cv=none;
	b=ogNe8MtcqnfsccJmMgehb+9xqjA0vPgxsNn8FDd0sDsB9eijhhtOjiN/AIgDHYRFJtSjo9
	MnPvN0I0dnYNbmxE5NZGdUneIqOrhYksQDpgEUW39rMm2p2mdfnrlN0P+sF+TfIs3hFcJV
	YWRpmkK1uZ8onBj+RUlEXWSUNRRemhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3347C601B9;
	Thu, 13 Nov 2025 11:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1B1C4CEF8;
	Thu, 13 Nov 2025 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763034628;
	bh=Pa2RgIARzCnIXz9o1YbhSbulkMlyeUbZVlsIzcP3LEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EjS7/pABfgTH0LGoCqvoiauYcHaLTvT1cJh6jJCD5N5YbrXfRXgYWCRnQ44RDURMj
	 YwxvBMXsr1iaMMEZoWT8XtrvjMzk3FHXfyxC41Yz30zcSY66dtMQF3+FiV/N9LxcDI
	 sPaeqHe4mnqNeJlGpZQ0ZuyrbCeEbYYvZoVZLsEY069KRRpRoEflDWe5FMpKdxkr0q
	 mSlXjQqewIs/TyG3TQSw0rKW9s6nyHDEpuwv4PMGQflPlIcE1qz5kCMHT2+4DmJcVb
	 SN38L/lv2iYz0UnKrcRI1aUJuwES/Y1hFY9xU6HKf5sQuNbCet8Z107wGm6XF8Os2y
	 +HqJ9qqvVXqIg==
Message-ID: <48265d08-df2b-48df-959b-d2ed1407ceca@kernel.org>
Date: Thu, 13 Nov 2025 12:50:20 +0100
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
 <5bdd8b10-171e-4171-a1f2-43c029dfd8e4@kernel.org>
 <7d5ff6bf-9e44-41da-a9b9-c5424c569e98@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <7d5ff6bf-9e44-41da-a9b9-c5424c569e98@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C11BF40016
X-Stat-Signature: wmj4c97datydpggg3rfnt51ufz39owrd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763034629-240177
X-HE-Meta: U2FsdGVkX1+eHvGTRlhqW3v3bNRdUwchvwRlgKkT+7TvyOjZ+prVmRZihEnFWMFjZnNWSiMG1cZPNgnYcHN14mWentSmqSZV97UdIGntBU//HbGO0tNpd78cfni0EoWVFsatREHswycd4W0sAECM+DKcBg/fytSOlVE2mOqt3AigOSUOVeSYpnP72z1N7o9ws/94rb+zq1bFTm03P33sIny4luWQ68p9LA1mBGGC/LMzuEDMhumFb82cSbrJ5fRmqv9a9ndinUn0G+T56APgBUKT0HwF8Yk+XWtugw1y1GFH2Rw8U+29p6z2yvAiLSOLqDX6a5T5Ape1ytZYC360BvY2dL9s7uteP3x4lk2BzJPrrZ+LuLwUHp29nC70yFug7IutTgMQjplViIoy3j3zOGth2SYuk5UR3BoZ7cY6IlBz0lvBlP+r+c9NvEynJrYkWhI2CcFfTR61zyhgdCyCppRaQFfMswtmzT7hUWlrrt0471rw+hKq4rJFbitso+3Ypf3Wmi1TOccp2yZoyelP8RbOdJkSqw6TRW9FN00BeDcAez9KDM9bosEqfQA0mxjCEYK9txH6/wealZyl6o6V2Pz8kVKvVGeV2+EOJcRS6uqkvmzllPKocaAaTgLFSkzcZ6AgAqpN7Bn7XE+SS/BuBtbesObxnBVJ3JfMBlKm5Qg40DckTT9HZrZw9NIBqQ0ohgGGfXZ2gXn/q5aFpjU6gYCQCfNIHpniuHH/WgabakkV3wgrebsphIZnh3xgJQTOpUj1RHoVKkdX1paigr9Iu4Id4gtQq3Wovs+z65x7462rUxEadmY5Cbr/lfiil27uMEqqVRC4skQWvRVTLWLV86VjeZ3CbxSYTcYeUezPAoQKEtne/Ac6tOTw93l3vzV+r7vPZ8eiVCAAjMi75Ucv0rcWyC5SNmGk7d+s0xQddM8oHx9WdN7KAwm7zzLYCmwqZV771ivirxKUQ0W/bv/
 nFywcpZE
 pH6gJkx+JQZWDUW0iWuzaNn3lkHK9hgpN9gvVMh6KBVPpjYEHbGq80/BmB93EwghTvc9rYDAKSUJ6jWCS1lXZQ2n+Wu7ZNk36JcR3Fm2d8VyGwH1joPnbtO2bqe4kLtst4skC0ELG30zabaXhHflPmxNopWpOIZ6xVINnw4u6LHh8zvFlQKBNaxTmyELXV4s66rNXH/Z8kuEWWNgRaFI8e2DUsE54psfUaYCkOhRUIb8HZS8JO74hrUclK2u3q7/YTGMIydFYkit8O5Z45ftID+/J6PWFICrVHgtqG8oN8VEq64s+9Z33B2nF/bdXVT8WHzhoc5eryWH4iYcnNbUNRvz4f7553kc4OjI2qADqAda5eM+Eq4ll3/YeXoYNMWYGSFvYpShWLexXjNyrSrmHjbEcrCPb3G4Cl5KUoPGkEAB4qIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 11:31, Balbir Singh wrote:
> On 11/13/25 20:09, David Hildenbrand (Red Hat) wrote:
>> On 13.11.25 06:13, Balbir Singh wrote:
>>> ret of type vm_fault_t is reused to capture the return value of
>>> nouveau_dmem_copy_folio(), which returns an int. Use a new copy_ret
>>> to fix the issue. The issue is not new, prior to this the function
>>> called was called nouveau_dmem_copy_one() and ret was used to capture
>>> it's value.
>>>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/
>>
>> It's a sparse warning, is there any runtime effect?
>>
> 
> No impact really, it's just a sparse warning

Okay, then please

1) Make that clear in the patch description

2) Make that clear in the patch subject.

In particular, the current subject is weird. Should probably be

"nouveau/dmem: fix sparse warning in nouveau_dmem_migrate_to_ram()"

Change itself LGTM, although I would probably call it "int err" or 
something like that instead.

-- 
Cheers

David

