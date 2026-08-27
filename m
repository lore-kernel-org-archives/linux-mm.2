Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962F6C61DCD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993726B0092; Thu, 27 Aug 2026 11:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9430C6B009D; Thu, 27 Aug 2026 11:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858C96B009E; Thu, 27 Aug 2026 11:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFF36B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:05:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB8691A0424
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:05:21 +0000 (UTC)
X-FDA: 85147372842.10.2CDA6EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2F3AE40006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:05:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHe4CmaV;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAv5ec+HrqSWxCZoJniPdwA/qfsGl/k5VHJgM9oKE54=;
	b=hhb+9X2M1FNm08HFxQ3C2WaMtNYO9sZcmiBKAatgd/h6pkXoq52hfonhV3VoMVip3TXPfs
	oLRJX0cDq17yiLRuw7BRyoobE5F7BOePWXaUnksgI+0T6tYZVy4PisaEaC57OIH3+Jx4zi
	ZUMKagfS/df53kEfy+hFCKfahILuTn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787843120;
	b=HhNJiAiPmHUP13Y/TVezYYW118I8pYGqooB6HO2dRTabKq14tV+an8kQVvycnG71bQjk6g
	3A0mHBjEPCGg7bxdWyPCcP5iBUd5PAm7Wng+6QpJawUAdww72I3Ly8WEn34UCoP8E91lhl
	fHlpejYPnDG0xXH0BJG6/mNVV/v+SkI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHe4CmaV;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00A3F600D2;
	Thu, 27 Aug 2026 15:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F111F000E9;
	Thu, 27 Aug 2026 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787843118;
	bh=JAv5ec+HrqSWxCZoJniPdwA/qfsGl/k5VHJgM9oKE54=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nHe4CmaV/Xijn/whr/wnQl+9tmZuynl9FfE8Htdg2lDY2Y3o/cdcFStfX28WbvJ4Z
	 57C3TBTOGbAOi62eBEA6at7A80fuK6bvZOhRwlo2njW6dATkRYBG8nGKsBIKBP/YRr
	 RJDBVuqyvX4EGIzRG6SHs6hymH2yCAicgnxk3jrB14jj7C47XYBpo/T+KWcXwabssT
	 dIhg6zan3PjIjzo0nHUwDttPke/Uz4LDSVCnBx3MK/yDwzqwhdu28NKfQw9w9mRCvX
	 7z97r5q4FiJED+F2d2TOztuqndzUoYlmnJaWZw/Ec7uYXMyNNK7BXTu4Q/0iYIJ2zc
	 pFc4EFDJlwDyw==
Message-ID: <4312740f-2aa2-41f1-8442-d4a80682753d@kernel.org>
Date: Thu, 27 Aug 2026 17:05:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/migrate_device: Do not write past the end of
 the src_pfns array
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Francois Dugast <francois.dugast@intel.com>, stable@vger.kernel.org
References: <20260805231041.3791771-1-matthew.brost@intel.com>
 <20260805231041.3791771-3-matthew.brost@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805231041.3791771-3-matthew.brost@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F3AE40006
X-Stat-Signature: 1566ene69ichkbirkrggx99r89ierk78
X-HE-Tag: 1787843120-726136
X-HE-Meta: U2FsdGVkX18i2JjYAOjpvuuAi5G5mNcmppgmnbLMaNkLFBAsPTr42OlodNhmHV+uxNUpoGAIPYzONx0/L/B7D8992n0yG9Il6KctrlRJeUs5bThNX8XbsTzSx2BcCCEeTYvxYpKGMMPavMWwaBn3ZcycniwYMrB7NLdN+P5gOVqFV4K4WCtCc4nvJDxwl5RPeVOYTIrh/EEGskVdUsucprfqJA9RMCbW1nFbksXhyh6uZZ/dmuhouR/z27xo6NL+z8URw+oK0ZbILROEx6wf9PB17k+BkC8TflwuMuhSUcaqauUaX2L7sjhTRD+wGeCJhmWjhCft+Hg2Pz4vnXrflxvclYwih9ycmxhQdETSqC8cYTgVTSKR9Fw8gt5F5taFzzvvv/q1CKdqNz9+ONK3470jRmDKeBKAecxASbQhPmZzOyUZb59DkKXlesvU2KFf7X4lg32H25+60WUKeau0sSxCB7OLTryzbrhK3VnrAAYzdsJmeFQVicWpArtyJLEtDR/Qbpc6Eectfqcq2oaELmD3LiR/T2amHRxYdeheWQSL8jx6EkKBGx93UpVmOwVj18qmZxnopHX0fDsmH9ZmXFDwvIP691Lw1d6eLK8mUBny2SPlqyBj7FOOsql1ndHTR9f5LSP9pWnOqAHakX+fa6CNUe+WZIRiRqxXcaqUyJG+YY4ujhpYeRV5y0Rj+1sCNmjg4dCuP14It+DAcDoAPFlB/lRorjVWIXRoHJqgpJov2WDuuQOjvHHrfHVOgU26v2LbPnGG9H7xBM/a2BOV1DAdVPSFLQ7+P+mIUlV7esc74l/Ac7H2NzFusSaqUJ5pEhjeQ3NFEG+ePzF3RSdhGEJCEBY0yyAjqReR91g+KuS4Gr9nM4Qh5aH6Cs5A+b/C96hS+lhWvZU7DOVIudbe5zUe3Sqj4ihwXw2r0W9/1haELUCASLpB2ieJ0ro5/Iz1NOMrKmn9HdOyImA72Hq
 RYTe7qVv
 mMWLa8bhTRckHcbvatLxoGgnG4y20qyG6lL+aUr6YJF4SFzPlBUWjiTLq7iH14qe9a11Kp/0NmbrmswnbWDf+48zgQfmo+Nwl9rVVWgDqs8T0XYjTgsjSvbT1XeU1fRev48JZEwhSDi9u8E/wbgUYR4BX6m9CWSdUaJoCmS/gdIMOfEGtiw10s10TiWPH4HM9Da3EQjDQS6gNUkSYe8hNWQ1NUJZJgJYSoTmOK7JlqWUDgzDVNSVzGvSSjLhj+8Z6xzMtKor005X+3hOEghxMKPDGjLwUwpmHy38aKd9ghHMpdBwfpZNKET7R1bg7bapcyTzwjahzrxT5Vo2axx20JhBLlWfYe04jrOJPT7tKFqaTUZQYkDzRamCAgKzthZOCsN42o6ANe2u77ReGy04OHd3HVXGIeXrvTtp+QEikSGFO+DsrbzLH1al1AzbGYipD8T5BtI3kVGZjYyzpWHP8gIRNKeneOPKYtaFvAz5qA5OKpW+UB8G/2iyOP4HpDR0ZwYCX3Oi3essiNylPdwe1KiRFWHHX44jspqq94UxyPHEruhLCGH30yfhDbJfeP/O/g85Iejc+HBnPetznDRB7pdNGpQW2jDvmLb6tF0Eh2vo5ikwtiIh+KEMFgWLO5aEXa6rYepEJVY8o0pOpyirqaWvve5t/Wj9Hf4PL12vKJPX/GdzpiiFPlGbM21IwgeDCqhEjiGE91psAYN3DYhO5uToIOmPKCPTlNuBmbtKVMV2Fu6Fsr2Yp10kHu6/jrkAMSa85zWiZ3q6L2C9UGNnzpTzIuQke9vcuR5CmduEoqzm/w+0n9DVnXqD72vUoteBMa8OX2bpq5+der3gzCDJ0/51SxK92A9xAoUzSNjTDOiqIFUMAa+okk30XLPouOeLxsaBPVnffIDktjm9WqZbZgHQp+yg8v8MlyGptOBm/rkgtpg4jMD8KUn4IbCiXRaVdTTZvq+rDAFQ/cx3A0tizta0zc4zM
 LfxS75JD
 CoQH6Ssx4+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 01:10, Matthew Brost wrote:
> migrate_device_range() and migrate_device_pfns() zero the tail entries
> of a large folio without checking them against @npages:
> 
> 	for (j = 1; j < nr; j++)
> 		src_pfns[i+j] = 0;
> 
> @nr comes from the folio, not from the array, so a folio that extends
> past the end of the range being migrated writes beyond src_pfns[].
> Callers size that array for @npages entries, so this corrupts whatever
> follows it.
> 
> Bound the loop by @npages. The subsequent "i += j - 1" still terminates
> the outer loop correctly: on a bounded exit j is @npages - i, leaving i
> at @npages after the increment.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Assisted-by: GitHub_Copilot:claude-opus-5
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> ---
>  mm/migrate_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 162d29b2807a..ae9027421b80 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1415,7 +1415,7 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
>  		nr = folio_nr_pages(folio);
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> +			for (j = 1; j < nr && (i + j) < npages; j++)
>  				src_pfns[i+j] = 0;
>  			i += j - 1;
>  			pfn += j - 1;
> @@ -1449,7 +1449,7 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
>  		nr = folio_nr_pages(folio);
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> +			for (j = 1; j < nr && (i + j) < npages; j++)
>  				src_pfns[i+j] = 0;
>  			i += j - 1;
>  		}

What's the status of this? I assume this is fixed by

	https://lore.kernel.org/20260817120758.669807-3-sh_def@163.com

instead?

What is the right direction?

-- 
Cheers,

David

