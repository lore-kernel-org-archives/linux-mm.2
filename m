Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A641C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4066B007B; Mon,  3 Aug 2026 09:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064FC6B0092; Mon,  3 Aug 2026 09:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70026B009B; Mon,  3 Aug 2026 09:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5FAE6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:17:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 578961C1120
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:37:45 +0000 (UTC)
X-FDA: 85059456090.17.AE354F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC94740004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:37:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhSdC25k;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785749863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXyZXVLZ2cKjGQ01KvKu8F68JgDydaJTqMDqaHQUQGU=;
	b=mZsvtnq1h51W8ZijZTMpv6G2JgA/SPOwq3NHHQw+8RTjiECjLvcK8vuP14IsPy08UdXKhl
	FGvjiHK0gNfcA+rx8K4HXiXWHrdiJa/Quxn6jYVuSFeWzp2tUZXC+vpF7s7bXkl94YbI1O
	zotLkbEvaqX8CeRpshaQuVkMUHs0iW4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785749863;
	b=rpB2iAPnsd2/XE1vjbL/PYM34q+VmAoSmSNDG95m2egqScSoDHCBklvhNXyKIWXzwNCOm9
	2XPnpyi5HzsjbDYR6wabj5TIwqYyDHKl1s1PclhulDZAmWqHWEBSk9YHGdtPvgM/QtMohf
	8zdJ2wGLD3OnwzwFNIWgq0+FL14nPHM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhSdC25k;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37F7860A64;
	Mon,  3 Aug 2026 09:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380EF1F000E9;
	Mon,  3 Aug 2026 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749862;
	bh=hXyZXVLZ2cKjGQ01KvKu8F68JgDydaJTqMDqaHQUQGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IhSdC25kYuJBV/OO+NKRzjHxPrWMZItLLRr9nl5V5uI7xEgOV5iXkntOSXjjYIZui
	 65vvEhard0FtHNQg1rwnAyyeH2J5nRVKmPsnSBC4wcmJrE+SYFnNEwEzbcWj78LbPN
	 wCfdsGki3O/7fQLhDFx4bfOSZoOpngoXt+u0vokfTAnQ9FQawmJ/XPYcG46OP5jIF8
	 adFoy9xdUxiPjgl+5C9qYFp27CjoFI9ZtPhgW/9hKZ01HXRNUp0avT+EkkvdKzG/6d
	 S/6MHgYT2jsnzRPU7P7SD6Pn0yOuuJgy93+FSrxlVaOcMJOVo5SuZkY+IOr+HxTAd6
	 KTb9HbgmtmkAg==
Message-ID: <5d34aa86-c083-46b4-adde-8dfa520d51ab@kernel.org>
Date: Mon, 3 Aug 2026 11:37:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/15] mm: abstract vma_address() and introduce
 vma_anon_address()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-3-e8ecfefea812@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-3-e8ecfefea812@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ftup1hzkigodxpt5intifwo7d6z5arr3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC94740004
X-HE-Tag: 1785749863-279765
X-HE-Meta: U2FsdGVkX1+hZoZ6f22puTEX3wr5Z9wnQj0/sUbOI3OpAFxa//Zuyha5ZaQNRnDqps9GCEJPYZbY9X4jSmzNFPQjpYCL0CqKTQvN8BivsTinaLydLMSvW+lFgMd9dsdaWv7MEri3g9kEVO7hv71i32zzhuFxm/T+y0cUpE2Wm4ImLp41dFNm3dCT/zhTOnqvTbpDFY4/J+DmzoDIKKNsisoIl4BoKAvdfGflbvzFzLHazOTA7JUKOGD5SxqXxiYkdBz/thEF3kCiXxlqqRMfxVPVd064lo8QwK7REAH4q3pnrwVlRhMJ1GdP+icBq0LEBURpIk/j2AYFr061BN1FMsYobbnqpzkDaAA7QscTgKXa/F4iG/EYJizox/mjs7mJmGj9nF70fhbpFesePG5siaIaxjE2JbHJlBKkPWvjEbXW6LMScwRdB8YAN+jlXNVZBvSyCFoMMTZUMfS7T/kRcnwUai8CR9cA6iZSo13S5S5uN55qCApgAZeNHtOdzFKmjz9gi6O/w8SObKSCeEXQAfwRS/VVskj7muME0JMQvufaSJ4QtKvEsQ3vHIY+AnY2VMdOtqx53H6nSWCei/gZmWJUv9clyYHv3ntrF0VfYQWtUAPQWGUoktZ4A1+CL9tMCjgWYc7IOo5leU9YcKIx83kQdD25r1kYtvYIZlM8Zwk09CvoF64mBoiPTTZeyMkSbu8H9Qgtu/LXu4M2L5x3lYmZmIYF6Rv1QFJ4VAmRzuXgKf4PA0o1cCtmU/8S8QcDvdo0CfGiYcJVea0L3dQ7SkMjEBZIaGSgXy0UpzycB88Okpu/SN0062/K3p226RoHMrhmJIxTUAysgOOiO3sCtQdteBIMdXAjwdxxLrBoqcKVkUqACoJKMt3Vp1xvcyjFbSJ6ws72yewGtntgEtGGuwv05sHFbUKkaG48t2gdLp8LorPVkKj3cvXPLG8EgT6jTqGn44cNlPC7CICajWZ
 IfdHmpXy
 1YD24k5l2VD2h0GLt3Kd0upGrCfVz9UojaHvGh7T1soBsbHT/2bnDUHjMahp/LpyYaP5fsP/38aOSVkxku/DODvTLFx3uXnkbO2Rsr2l5VXPke1GRrAxU6ivkYPEwkCUWxkpN1FWO6Dp8K+CTGeUySMtnP1DKnzwL4n31sR6tEYVlkCaAE35zGAK9X4AkT9PDZjWbj2CRvzG10SPD0my8ZIn/o+Ig1ILq8OaQcK6V11fLGHAROneqLGLo7qYkUzh4ZorAIC242REoUlIrWPOeHM2CzRNY1Qc6vlycB8hj2HRJS59IteJOnQ7rJX4o3uVDGIxEaU1RvLoomImbllRcgP2rhHZ+ZevrpKJU2EZps4pmPaCDCMUbHWcFBuXogMBCx4mIVE3zE4c4pyobJ7EJjYEY5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> Introduce __vma_address() which abstracts the VMA start page offset field
> as pgoff_start, then update vma_address() to use it.
> 
> Then introduce vma_anon_address() which does the equivalent of
> vma_address(), only using the anonymous page offset of the VMA rather than
> the file-backed one.
> 
> Also add an assert to ensure that the function is not called for mappings
> which are file-backed but not MAP_PRIVATE to ensure it is only used in the
> correct places.
> 
> This will be necessary for determining the address of a folio's index
> within a VMA when the folio belongs to a MAP_PRIVATE file-backed VMA but
> has been CoW'd, and thus is anonymous, once the anonymous VMA page offset
> field is used for the reverse mapping.
> 
> No callers are updated, so no functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

