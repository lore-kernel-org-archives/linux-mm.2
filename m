Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC37CCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3B48E0029; Wed,  8 Oct 2025 10:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB688E0002; Wed,  8 Oct 2025 10:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08AE8E0029; Wed,  8 Oct 2025 10:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD8218E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:24:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68F2BC0402
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:24:43 +0000 (UTC)
X-FDA: 83975168046.08.E4F9C38
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 78406A0007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:24:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759933482; a=rsa-sha256;
	cv=none;
	b=WIsfOZUuYHfyKFFQ5ITPwyfSYMH2Z7omZvGW/4qXEPYCPuLFbbGJx3C/hkQdyRDxFhcEuJ
	GBAkQWCouUVLbii+LTyBhZuD+a2V6B61io5RnZZaqVs3oxk8bP0J/ylLRXNIFaTHKPSM4J
	DQSKqQsQbndMfMfTs4w1P1p0XoSV1oY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759933482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B73FrKgn4NAPnPs3o33yjzkUaMpgvh1iXHM63x9uOwI=;
	b=lLDKW8jNGVDcKOIfEsfA8/f/lHYqzQVKf6BiMPeA3EjoCqurO29wFfGPa3eB09nBJDQ1Iu
	t/1X0tXMZXI4Nn/MmWpKNsGih3U3gkfJcEFLtj8iCebyF2WBoyUngiFtVSH5e21XRa6fKB
	R/32AC31LoA+dQo/ygHEbPbAAFcNeNA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61C5322FC;
	Wed,  8 Oct 2025 07:24:32 -0700 (PDT)
Received: from [10.163.66.45] (unknown [10.163.66.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBCC33F738;
	Wed,  8 Oct 2025 07:24:34 -0700 (PDT)
Message-ID: <2169e2a2-a2a9-4d3a-8523-6778b30a5a6e@arm.com>
Date: Wed, 8 Oct 2025 19:54:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 2/2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org, usamaarif642@gmail.com, willy@infradead.org
References: <20251008095453.18772-1-richard.weiyang@gmail.com>
 <20251008095453.18772-3-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251008095453.18772-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: du3wdafk6x4pxkdbousfjho4ocjhgypo
X-Rspamd-Queue-Id: 78406A0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759933481-307299
X-HE-Meta: U2FsdGVkX18HVrNvyGo8+gACqH/dIxIC4BeJV7l9g37Eg+Mq09Gxg7rawQgVBhCZr1gDXqcivaSivJZq65vV/ik2x15MB66ujbOY6z+/awS2rxP54DfST053wcNL21soCcqmTiNMff+humm1MR9vf8j0Gr09kZrG5JKsecc+YrBeMwAXGGge4YACH/Ioo1gt5GZvWWEFh2HMcVDQF9RG7UqHUcxYhXZWYwunjTqkt0tQ7EiiX3LHiCW7RKOrCuAW0laHytDipax0Dn4IVuigjY2Tb1fQM0RXmf08Fgy6Y8yuzOdjCpWIbXxCWVSCN7rHMUOuwQa0Y//kgIX0x0CO9kVtGoM6ygCaqfuEFZkMJRiEhDZzETaJD1PcxthSBi59UOoKL7B5JG2gt6BrS+DFNzFW9tmmk8awAQyDScbjoI7MkVO6bTFugDwinjT9FeSIaNP89ZkRU00HSOCAy1roU0pNl+/8wdvbHijD65m92iqzSrNpUocgR9u5QfINy3o6o552vioRGC2Re3KXvNxO4S+UxPJ8lvYp6qLLGmMK6R6H5Hx13QlMy8Wfa1B4xO3aAWKa3t4fS5BTd7lei1P2vA10IETtonGxXrxP1/HvIiQ5fMAKl9LMh8PL+giR17kISUej5DKzoxDv0ufrZrl3ZS73zkAQwqLanmEeLvNRlUVUYDyU8i7Lu0YRRCKL8npvM5Flv2u3/d6eqB0lyWVRQWyHT2bicsQbwRb3LAiZyKi3Esa+fXybqf6RE4y0dAuNlo7l2mQ2PGD/xwT9TMxHfru6OFnw0XsqLrmJICmURVSdwyrBxAe+ZhxdIH4+ilbepsnXZ7RLBcNmU+hV7WU0lrCXM7dhcM779yG37qA02v+uS8Mh0KwtZoWtiK3mI4Tv/E+pELhg8EHicb2oBXshQqqcfjio7tK0VX7zWHC/AmQDDZXs7P9QP83ev/FMJCLrxLRS3dh+5yDglhu0VK+
 GiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 08/10/25 3:24 pm, Wei Yang wrote:
> Currently we install pmd folio with map_anon_folio_pmd() in
> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
> collapse_huge_page(), it is done with identical code except statistics
> adjustment.
>
> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
> in page fault or not respectively.
>
> No functional change is intended.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
>
> ---

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


