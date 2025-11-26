Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B092D10F21
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45EA6B000A; Wed, 26 Nov 2025 05:28:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CFC6B002B; Wed, 26 Nov 2025 05:28:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A766B0032; Wed, 26 Nov 2025 05:28:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4A9E6B000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:28:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66B5912C1F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:28:46 +0000 (UTC)
X-FDA: 84152384652.28.D259523
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BCD92140011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:28:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DWrKodc5;
	spf=pass (imf23.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764152924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xP62eMhiTrUn/ttJl4hVabchrHgL5KmYXsFlhLxuaNo=;
	b=QLvfTIjbmDZNn9KWSJyaWVjQwBSuONFsdthNzmYNFPQ7a4IN+/hBXjfuIDTiZEQqwoPjz3
	ATsYlQh3Tm5Bywqr0+vCecGhnNpSyVXwmTiCS7dg4SzDwgiraiBElLTmOdcWOCaqdUUVeb
	V2EdyTCnjkLInR3r9Pc39d60jyjpIQU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DWrKodc5;
	spf=pass (imf23.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764152924; a=rsa-sha256;
	cv=none;
	b=licDSKx5yB/AymhDXM1iE0dgBWBBQSqL6HBtMPSUqTxbQmK6qwuZJ/NloEAbBy81udTssk
	dCcZhmvT9Up8WDcQzpzMD/EAigYviVg6e/6RwZ6bBIkWbfu3XtTbW4J8Sd2IfFPx6ajY6l
	FDri0Wen2+9wpsXbUkMqLqibmJSB9R4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25A1E601AF;
	Wed, 26 Nov 2025 10:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B9C113D0;
	Wed, 26 Nov 2025 10:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764152923;
	bh=7t45ycviA9DRiXW89pxkIhRhDt2NP625DD865+9PuQk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DWrKodc5blYaVI69fJIrDSGH9j1sOrV8vB/q+sxVcMiuegDCijI2eRY2C+QCv/Pt/
	 V48UICyFiQu0MJt6Tgvw+XCneKVq7WnO98Ra1wmnoD3UprrvqDlEcMTMZW9nQ1A55A
	 OOQgdH9I1bK5jXj+G87t3EJdSmIF6fCi6c/+tMJH221Hzq4HefplVg6JR4cG9I8x+h
	 l3WGHKuEOxXQdQiQF1zKEL3LtqAUNhFwp+XOUcZXNAiIAKMwgprnJDP5ho5q4pc3Oz
	 leMwxhzxP6mb2GKe8FflUvRnj5F44WzvRAw2cqCYJM02hvDuII3R/l96N/Hwiidb3t
	 XoG+Ue2Tcs8eA==
Message-ID: <16ae0a30-c6ee-40ad-98c8-ee6f4713e653@kernel.org>
Date: Wed, 26 Nov 2025 11:28:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use standard page table accessors
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
 <9c32675d-c48d-405f-a38f-4c90a8edac74@kernel.org>
 <20251126100330.n66n3uvt3junflao@master>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <20251126100330.n66n3uvt3junflao@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BCD92140011
X-Stat-Signature: 5gdypx1poksypbbsmqc4m9miyos7rugb
X-Rspam-User: 
X-HE-Tag: 1764152924-561145
X-HE-Meta: U2FsdGVkX1+ZQgGMyTwpJzNlwjc01iNDxk0ezdrw/9X7r+l2MB8GTobXKWhT9QrrZoL4nOhgzejv9THraYh/hqo53Uzg5ogIbQMBHW7NhPBTmw3xbgPGDCYsQf7IIJTgTIO5r4TtxjjekrinEndwZ0V/QU1Tkh0JGqpCkRAAFHDH/MW0mfpYc5nLZ1BExAY5xiMuHxgm3mVQi1u379baXsINXEsLD9gn6RWwUWTAXDHh+XvYEhZnmlwR8ZScsZeFh8VPEUpuvLW2s8dpqkxfvlAFDipJwtmsdkk6rXIiz5BzBtskoq24Hz/n2HiLyDsLSILKB6aRXcmu1iuZ8OZUAnEww5nWH5vs2fJrxKkHFZB09f6DlI0zNggrh+8k2UVXGF+873eFRrmfx1ZupghdU9u0WNX/Kk9r3zWWzloPm8/ArhOcrYpwLKJKfasvucxD6dZuXElpCP1DDeT1VcZ4tnG1xqqftT5aV0Wm+m+AfN7yPtbgnrWy9fbsAE7KQr33YkNtgtQiwLlv5qPuzdV5XISp3Lv+8HIty6KA9+eQRtuiMInuUC6HWJUJE3XMwSeJ2sne4e3jhyYRh0kjNfeFKtx9/ExK42aGAMO2QEe3JnLJKy+hlEOy+0y0DvLx+LrNy/zt81Gtad1cAq+LoNgtAVRxLV5U00fCI+AE8O+8fAZQWJm5vYzi2IBnpSyY+hN4HANum/01hGit4Zv36bZP5ZL+EvJfM5NEr9Mh/lTfikKejHeywzdMEd56lqbhAWs7Bao72TOZE/7PPRDk0YWO7eOF+wpuYfojnuEnSwZCI3WsoUNS/gT7c8qAxYiXndkaN6LI5JpyIHzTFFuqQAzjPJOaiU+qskIed5eJAnno6bqKizG3DFdw1jNVo7pdParWLutRw3AlczhwzFpYvVcCORqs+QaFXkWWONjxah5x65rQFz1KcrIDLLm/l5/pDwF9J+A9mMgPyBrumBmDyl7
 xB1cIB3O
 KesFfG6t1YVX/p56ju9FvrEBT/8PzXzqEuOs/KCzBUnmurpigphv3GiVkBvp9EdoMuozXu7b62kzXj+WzF7Zx3E5iTgGP0kBqQdzzQ39hCmGE/jbZm4yqXYo9/IaU5qlINP61Ko7NruqoLcYXMZFWXMeeGPGg8u6nkpbBgqpmIlBleEBQOPC0AHJVfDrHnY3ZpYdNwQZEkkv/yvb4WzCa/rrWLfIVxz7beYJAM36iRSRBJqKsJ0DrdjxVHEozzaJB20qT8a9vHfZ1lo9DEtTmNPxJE5k2NhQMOm/m50T5s6dJagysrnis9QmHido+p3q29tLnJeThhU9yXegyZ5D33giASEZBNpdjYPDinI8BCIEN0YvCN1Q6oiAZAsvEMmcyuAzi7hti4xCyk40qga8GZfPL9keMMGUWP9GcbFi0TU60dValYUBNQKQbhn8oU3APt8XJQ4ITYNfIgnvz0XzaZb542P6PD1zRquigb0V1Pukh0vI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 26/11/2025 à 11:03, Wei Yang a écrit :
> On Wed, Nov 26, 2025 at 09:15:24AM +0100, Christophe Leroy (CS GROUP) wrote:
>>
>>
>> Le 26/11/2025 à 07:47, Wei Yang a écrit :
>>> Use standard page table accessors i.e pxdp_get() to get the value of
>>> pxdp.
>>
>> Please provide more detail of why you want to do that and how you are sure it
>> doesn't break existing implementation.
>>
>> There was similar tentative in the past already which proved to give
>> suboptimal results, see discussion here:
>>
>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2Ff40ea8bf-0862-41a7-af19-70bfbd838568%40csgroup.eu%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C63a7608567de4df0a16308de2cd31076%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638997482180349327%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=ly4LRRjkKqQNBY6ZpkbHS7%2B0xuu2c1r0op1eysPtbSQ%3D&reserved=0
> 
> Interesting.
> 
> The reason is P4D/PUD/PMD on PPC32 actually just has PGD/PMD. So it is not
> necessary to retrieve P4D and PUD.

More exactly, PPC32 just has PGD and PTE, no PMD either:

arch/powerpc/include/asm/book3s/32/pgtable.h:#include 
<asm-generic/pgtable-nopmd.h>
arch/powerpc/include/asm/nohash/32/pgtable.h:#include 
<asm-generic/pgtable-nopmd.h>


> 
> If this is the case, sounds other platform with less pagetable level would be
> affected too.

Indeed.

> 
> And this looks only affect when we walk the pagetable from pgd. If we just
> iterating pmd/pte, we won't have this issue, right?

Maybe. I have not looked at your changes in details, it just lit up a 
memory in my mind.

Christophe


