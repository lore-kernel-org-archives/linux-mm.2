Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD9DCE7A8B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0088E0003; Fri, 14 Nov 2025 03:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50828E0002; Fri, 14 Nov 2025 03:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D677C8E0003; Fri, 14 Nov 2025 03:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFE248E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:36:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B629B802A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:36:21 +0000 (UTC)
X-FDA: 84108555762.07.69E0400
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A1BB24000F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:36:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F2Owpah+;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763109379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0Mlvum8jZR6EKzyOx5npEmTROCPH5+4gCuSMdmM3qM=;
	b=hNIyKUt1xjmzXgJJovuRlPrrdMx4bZUK+wey+BPU5e0tN9CYUmY61oGDMKiGHEpGGL6mmn
	KwV7/MIZxbyuomF00fBS2hMbH/LBK7mnyikLuwkStIoS9eBcOch06gfK3zTQLea0dhCDgR
	5SpTNKV9uW2T6yFCoH5aceylyAbQ1k0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F2Owpah+;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763109379; a=rsa-sha256;
	cv=none;
	b=ZFDaLpCbSLCVhNnJHqXlYiPQ6+6fjisgp/+iASfp6laetcRGNFkfgCQsTwuzbB6TN1nZ/b
	BE3OJKPDS1ZqYl0eFZE4rVMh5k3USxfEjevYDA8ggS0WKykMPPZi6kIEaT9/66TQDjqL+J
	42AymWRosn+zKo7DmCVUxOMbgSBVBE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E834A60163;
	Fri, 14 Nov 2025 08:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD9EC4CEF8;
	Fri, 14 Nov 2025 08:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763109378;
	bh=eWGYBsLmz/5LRmgat5KjGwo91+k4m6JF84j9BzT5HWE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F2Owpah+gT1P6oR4hero/YLaRllSRs7/IqzcWjr8T6aARmKxVkvyShYWYDdo42U09
	 I0tb8gvsHii5Z1jLRwgYMVs50vNUqptG5dKxPC9vcxPQg2pZG1p3TAjJ2/jhwYtuQ5
	 XbB6k3q6lLNhalnzHcv+m6fRwGqipdvwZ5RTzt9IoLYeQHATZNbll87iSb0q0sobVe
	 icktECJLCoQY8NUs9bpqyPXgrzo3agn715qYlWap3mK9KzQ0xfVmOdtqisTZ9L389N
	 KLCbRBEH3ZgdTT8voj9FzXxCxBT9xNVcd/CgNy4jFUL8qlhb/yv0gHAxBfaLbH7oZb
	 sQLWG/OrVaYyQ==
Message-ID: <5b481d76-638d-46d4-ad98-5508fc8b715e@kernel.org>
Date: Fri, 14 Nov 2025 09:36:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
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
References: <20251114012228.2634882-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114012228.2634882-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1BB24000F
X-Stat-Signature: o3eu7xugmjpz5fpsnmt81i6xqba1fj4e
X-Rspam-User: 
X-HE-Tag: 1763109379-367109
X-HE-Meta: U2FsdGVkX18M13w207Ls+xQb2QVZ/z5f4+EkwAZQ8d8uwxd7LgRg0NB7x6yo8aJIAkiKIWIpGX2jmwwwx5bR9Lbm+sO96Z9FPRW8eXWyd41acGkN0EwZDuP/wm77EoCi8FIpgXI8HvdlPVUjvTEY13O+zwzVU6hm+B8Shz7CIbc4fR248KFahTxWQYbdPoxqtxpWF2y+sv74DS40jE+jmKvcXLv1qvC7kiAY8VIF5g4g/cUsQH32WH/Jau+KycI6AgHWasoSReM8j5GW3NED1GdkQtSEmRdHPLiZSulRg29GRvf1gcKjVag9zKZjmDGwsK56yGmJ0EuZTWA+WsMCK4OTEMhl3fhxjn7WrolOYfYYoKjYe/Rxhi5oORyNeqm+KDISpFOOAdHrvTsTgztdloqqv0Yma6u/q7W5pLBDSp+vxnywfpxgxKOEIi0TRx+Hwrji52TWQiM34o3JfQsef3mtIIA851GOz1+GLyTOKcusavkPePM1rMZKazxm74ZPDI/Bw5qu/AoXWzsnkOIih8Bm3kFlLV2kTGxj3Anhp+Q5VIsfTufK/Sk1lKEPI+nIYwBRLK0hrxhZXahz5cfJdHSSk1QSEQ7tqZVm0SDtIP8cDIWh9yusLC9sCtF1djyalZvrle4zhpPN+AMgcpFOEVX+fyfEcUuMUR1gQaumKxny+wHXJdHE7EurQqMSZ8skDAcCQusg7FELsVFjXDztAWRHvRNcOZ9ynPAZ6vAEhySxDZH5RmBc8poGl46Z20PykhVWjP7zgW73Uug4/JG5+sVwDMPyF9uspGlW1WA0BNJjzhYqxOPgjKk83eHLaV42aBZZBAkbPR6BYd7E01xUzVCGT4S2E0IVufc/NtuwG9172sgWd8Ov2oIv4mrRTUHrgLv42U7emhEeX80sRozlf0AVd2jAKABKS8Vh2w29WWGPIoezTiGfEMc6Iht8hTR1BDNF+OihqddHG0bV4+p
 yoJVmnv/
 4AQj2L8jQzdtfSgajvhVEtxR+risdvk8e5NgQaxwfD2z8JwMn+hxp5HI7QdsEs4amqW9AEUqtSwV12VaKE8t7D3mF9OfSumn/XmqaLNEh0TSjVPJGJ4q0e4IjskZQsw1KJA0KHyR3FoHrsWMjJOXzHakwPFEiaHRc4K2igxH2ukww0aZE1NAJFveawV3CrMiSlLgfmbAL9t+xtfK5j0KwTJYrXYCyLm30F6zdUzEHm+7ThTG7YK/WomGPa6dGKJ0aa+mzWA8NFGY8BbJlXic8FC0di5ccfQYy74u2qRYboxValsPUD7EY9DZ40pCPjIkyI8045sv4BG8576GcIV/jYCVEC7VQhUFvWrnILJmAzrvCo00=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 02:22, Balbir Singh wrote:
> Unmapped was added as a parameter to __folio_split() and related
> call sites to support splitting of folios already in the midst
> of a migration. This special case arose for device private folio
> migration since during migration there could be a disconnect between
> source and destination on the folio size.

Didn't I already comment that the subject should start with 
"mm/huge_memory: introduce ..." ?

Yes I did: 
https://lore.kernel.org/all/048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org/

You know, I'm a busy man, can you *please*

* take better care of addressing all previous comments?
* wait more than 12 h after asking a question before you resend?

-- 
Cheers

David

