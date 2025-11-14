Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D35CDE01B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4998E0008; Fri, 14 Nov 2025 03:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D238E0002; Fri, 14 Nov 2025 03:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA038E0008; Fri, 14 Nov 2025 03:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F09798E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FF051602D6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:00:29 +0000 (UTC)
X-FDA: 84108465378.19.15C1D3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA965100017
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:00:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9lkW645;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763107227; a=rsa-sha256;
	cv=none;
	b=d8pMON9JzRpm58WK44BmQbYHdmODKtQ6c4rNLAbK6zPH733b/HLVT9dh1MyQzqiBKfp+YN
	TGhziCXHBrfWIeesqVS79hxjGrmSahyJCHSzB/HGF0/DmuYgEqJfUtMudRDMRnJxQaJGdq
	3NPO4Vr0Z5EfVT73zZ0GW5HESHfnCVY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9lkW645;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763107227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQeXNKu8YufhEAXXgyd+codGl7nIyRtkHXostiSG8vE=;
	b=mxF0OP0yTQJ6eprcycOdQmGWwoYsl56xhyQeY0m4HiJXNYmnAo7wDiekOquCnZbt8Wv5YM
	rxjXG2jm/kB9PEJcklfwLsq6lXP0WsuYlz49ccF5YAH7TaCnO6UUAPUfJFZAqqYgBFjWxB
	//ppW59BO8wXJGFqqCJh7N1l21Vpn8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE3036015E;
	Fri, 14 Nov 2025 08:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247E2C4CEF5;
	Fri, 14 Nov 2025 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763107226;
	bh=2rEmDzBPvVbBzaVsfHSeKCxSJRV3hxIlDk5T0Pey/9o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i9lkW645XNOm791Lb7QNFSwRub+ky9+FU9QGDU3xmd1KuKg1qd5rwXZipQDGxbgIe
	 SpPvGKgA/aA/rA9BHDyV9MlaT8ar3sEQ/zRN4nEJCvbb2Kw/QMC3k54BGpusFTuJXo
	 hAD5vSpW1sI8t4RSlsP8PlpLcYHXP5HZ13RkSvrJ09f5szELAVJKcS/V4Jd3o+zXHV
	 v18OJZYML5Nepf4fr2Vjxol6XBvxvzwkLflO6D23DBQM40VHVgl3TwtMswfdE7FgVi
	 kYrV03WEneGteHBsuPADJzUm3i1LUlJWgcYmYadwwvESBSd5Y0JSbBnq5SgLMyYBtY
	 VOPp7P+Ps19AA==
Message-ID: <7f0c742a-3799-42cd-86cf-93ebbc9a3897@kernel.org>
Date: Fri, 14 Nov 2025 09:00:17 +0100
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
 <48265d08-df2b-48df-959b-d2ed1407ceca@kernel.org>
 <e902daa9-d756-4523-9488-9ab7256c02f4@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <e902daa9-d756-4523-9488-9ab7256c02f4@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA965100017
X-Stat-Signature: ena1asxfezkfg53tws9bjbpe5bmnb5si
X-HE-Tag: 1763107227-973902
X-HE-Meta: U2FsdGVkX1+Z/tLelCcUkAH7IkLKSTzNdAOm0BhowR5KgzaOMMXgmDowrZYObrB8NARVe+lqTvavvaq/SLJZPvs0KGbybDRP7EMq6VwKhPv4gjPKNrhnzTxScSLM+4pWDCthnDO3cI9TmaPSKOoMpZNilnsdN4A5s9NU3140KcxwiCduDPc4GrTrAa0bdkx9zEYOVyvrjxCyUHpOQUlRBnIqyo4QgrdRdTAAVWf1KTqPAiISp7U+XMk7e394xdnnkXLVv4ghiv8tYgghnrogQyBzDvS8bql2t7aMPFbIZXthSlQfgiUHkSMhi2cKw8MgEwGDpBYsiGuY0HBoZG/E+Ynp+l0A691l8+rGlNx6h42CYrqg9Uv3S7yVuRXlWRTQVfoBA/0iIc+2icpZW+OAJzCQsXXQ4SoVE1VqZO2MGC/EAzHwSEq4jwvDvsA3lCvaymszlbo1sAwIx8d2Fwxt6A9nFCvRy5bx7yotiQTbICrm+1yHJ5oFXPx3v+MTdo7WM4a8NaeLsiYkcvYrgdMLSfcjWdP4sU8obGZqaF73p21WEf4lMgchV5+PN0eKGSMwUsUV/b6qp32ZFcsuUyiknsAWF/fM97shhJqU2WzDJVi/FMMjVVCziZZL1FQdMVU/qsk88klPs5cbDl85DFBEOmTyZuTJl6+KbgTkP+lD7YDBgTrmWEiyXqLwV4p3rrnBq8GxxYNjWw9qQVJ2HeQ+3uX8oVYT1V11xN5dSFd5lH3IDbsQaJ1UqD/lfsQZf+GYz5uaEYBIV7+ytWt50JcA+cY0bYf7HjgqywHfhCVQ/VdiqsBPBhO2kyg8PetM111i95blnWg0l0AElZm/PVoWaimV5r/WEkamzJ8Jad8widfiYOQeCpvNEwD/hoLv0vYQaQF9FnwrpJf9HLTK+pWtactoQ1Wr4HAKd/WzaeyeRj/gb4fQT4xfCadu8dYL9dWxWpY+0P0x6eMbAsFeVyM
 yJhWzkMB
 UJ9aOhP76mjPSDI8n36MxhfbPRIqcRMfS36SFQ0l9Fd4qWLTE/pVQJCCOLobi0nXK3gXJmHYZdBZEHFn1ckJLh9TtBowCnMpzALjNT80E62LTgGZ4zHdEfCwCbJ51lyN2E0ZY3/Fr36Zl810Y7O2lvBhknAXx2dbzM7s58lO7RjIG0pfvrXiWKES91nVpOwBNowbEGhrKa5CcGAkUBLtj7dK4R3S1heP7AgER84Nc2uxQuvo+llRiPgMjukIXDA6ua3s7yR3qO+vsZnHNEKDg6dISWUWMLelWm4++8P9UPC+HxLeA+++V9ss0ZhkcmcvLGeW2L+tl4tyR5UoDFAATzWfd8Jdn2WIbqBGGJ2SuE85qXjGdkzHKN6ut6yQpQc8SRzpToYcFhUBu92opMEH6ong3bSQ0Abl6qaxWLcZ2m1N9/uM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 21:51, Balbir Singh wrote:
> On 11/13/25 22:50, David Hildenbrand (Red Hat) wrote:
>> On 13.11.25 11:31, Balbir Singh wrote:
>>> On 11/13/25 20:09, David Hildenbrand (Red Hat) wrote:
>>>> On 13.11.25 06:13, Balbir Singh wrote:
>>>>> ret of type vm_fault_t is reused to capture the return value of
>>>>> nouveau_dmem_copy_folio(), which returns an int. Use a new copy_ret
>>>>> to fix the issue. The issue is not new, prior to this the function
>>>>> called was called nouveau_dmem_copy_one() and ret was used to capture
>>>>> it's value.
>>>>>
>>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/
>>>>
>>>> It's a sparse warning, is there any runtime effect?
>>>>
>>>
>>> No impact really, it's just a sparse warning
>>
>> Okay, then please
>>
>> 1) Make that clear in the patch description
>>
>> 2) Make that clear in the patch subject.
>>
>> In particular, the current subject is weird. Should probably be
>>
>> "nouveau/dmem: fix sparse warning in nouveau_dmem_migrate_to_ram()"
>>
> 
> I did have "sparse warning" in the subject and checkpatch complained that
> tools should not be mentioned in the subject, but I'll give it a shot with that.

The important part is to be careful with the term "fix" when all we're 
fixing is some output of a static code analysis tool that does otherwise 
not result in any actual issues (build time, runtime).

-- 
Cheers

David

