Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4B1EB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5398D6B00A6; Fri,  6 Feb 2026 04:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDA16B00A7; Fri,  6 Feb 2026 04:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCB36B00A8; Fri,  6 Feb 2026 04:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5D76B00A6
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:43:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 965CB13BCEE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:43:08 +0000 (UTC)
X-FDA: 84413543256.19.5D75940
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9549A000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:43:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b0q2M1Y1;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pil0x8aMOWPYAkxrkAL2f5p4mgdOAz5LX6MF3fExWkk=;
	b=X9UmlsqLB6L7R14N/5YGHOZHzgvHcMc9baEyIpvbtV70l8p8pHUDXEIVAQiVvvJ69EtKRh
	xdQr9jXem42ZohkmiNR9ipyjiyt7ivk7FaVsh9TkjIb4f2j2fb6uTOV3II07aTRs/kryok
	zQ/9brPwMnBvlTV/ZYA4v02WXtQ+kpU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b0q2M1Y1;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770370986; a=rsa-sha256;
	cv=none;
	b=IWbJVuyMDs1T5UT6YRnKeBXNuududGUtGCYV5orDuHGjqbbmkCDsnx9P3zdoiihPBYBsj1
	qCZEtOpD4DUWAHw3TteqmGy5sllXeQ1DZ0oDTDHInYj5uOFh8hCT/toUg8HlWCo5thB94I
	D6cogdKpoToqVjWspa10Xz5SxmTLGmI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DDE2600AD;
	Fri,  6 Feb 2026 09:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C084C116C6;
	Fri,  6 Feb 2026 09:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770370986;
	bh=opKNMeKc5dUGPWp6AFdxTH7O+3QX2spoWarAppjxqc0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b0q2M1Y1+zFPHhE8ZfPQRp3VzxIogdG5i7e6pVAmwCnkqZPgiOkhMl2qkj3kC5NEg
	 Axto48z8EEp6E+zuf9FLH4pnYtMWe46vAG4eYCOmfS+gE2nvNHhyCacw8WicO7aJFN
	 iSH/EqOPEgf+At3uRYkyWNwfZZNKNh9bPQUVdLdW5QDEojnAfrnUJA5DKNufmuLMHd
	 GH6RBqlMqSwoEKrcIyfmIS5x0Z1ZkDgRhnPL6MfhgJfpbvx6UJz2WqOfW7JACfIbgF
	 GN1R89A+idESDTjIRjGwz1hS/d6rNe5iGfc9RKewY6R+4qqVJj4clFyq6YJNw8/AQA
	 KIT3r+LwgJSTw==
Message-ID: <33e5e080-6e07-4cc0-88da-0cb55c9d0ae2@kernel.org>
Date: Fri, 6 Feb 2026 10:42:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 14/17] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key
 static key
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-15-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-15-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D9549A000F
X-Stat-Signature: b6j834fbezaw7smmfds3hdht18ip3u49
X-Rspam-User: 
X-HE-Tag: 1770370986-667295
X-HE-Meta: U2FsdGVkX19Mv33pgeJNEdE48PaTxvVgI8ld97adkC1Y/nCD2FayKJU2J41VJbQ+qh7BWl/aXuipO+ouDHCvRwrcjVjNtKVaR1ZHbXD+CEABgLNa9lVaXD7dNiVFhkCZHpm+vqfUGHU75i5O3XiMssRd8FkmNEDPvgLKFqZutLrU0vLZpG/L/BV7nhBK8F6AOqZ8rIKxXih9AASSstEryLMEep0uIby/xvhD3BEMd/pOFb4FwDFtVHlEh51m+iY/bj0s9pylCbc1vap8/nsXaq/Cx5uSZzVUJVP0iNr5SdfzK3JM1SPdGgZ+H3s/cJUst3H6xUZJ3J2HnqbWkrcrvoIoa4CsyUQlwuJewPdG3SYR+R0/USXN8jxsNTKNGf3a1eX/n14WE7RSigVhhNGznpl0+CFwxnhml27emD2B14q/NjbMqvjpErLurop5+TiXsy/a3aGS6E1cfaDVkrZQVKgi02M5Q2kw3hfgBkyF7tpOPdyrPYCN2MHsxwkPtsdd14oG/DZIhGGmvMYeUDXcpVfxX+ZeE4RUgGEVg53M98MQDqDEJjm2I5ovS85roN/KY/cgmrY4YnZSl9bVa1pBYeMsrn4bZapES1N4z++W8oMLtkUDNmW26J+iYwh3ERWa5ZWTL0bYwO0swsMWvJ3TWlGxomWW29qwIK/JVwgrt/VeZDCoG1FvHc8Kua1l3LhdmgJmY+BHB3JbKu9euVfwBBEovE/jCIqldVhqIqMR4NbdXZ79wVCFuavLm3JAlNNWbpgMz2XyrMGBI28IwKhhJ3KKhpyzpzMeGnjb8KsyG7IGswGxiRkii5+skk7iqZjyLtWD41BYUkYSgczSaPxIpQ1vowXx9OUeEZg+SwfIU57qMwBymrRLSqTwGcFP54mcKQ8S7BidE9P7nzTyfyXTidxAgic1azGF8fa/xbRcYflxa1z5BJzCY5YqjOatUXQy7UwycRpi+hbKPm0gdnJ
 NXB8W1X8
 tn1xQ+DsUpyH8oDO6OnUvNFCFT28lTLO5HLQOukligEbS55n4YHk45aFHUHvr0Z5qpULftPN4DVmcLfnoUuwinApv+bjdCf2TyElCa6meOo7dVnvkJxnKQIwpF54aUGB8gJ48Klv7AgG4XPA61Qb0+sm/hqQzKOny6CYEj/KDIWwxPS7wSIh/g6i4UCCz2DEO5fqSRuG59g5Hc/GGrwTKSSDAVWJkWqoVRw5f1+k8WJ8Y3Ys8rktVihEI/TubVguw+Ky2Cs8ssvaBnnEa6qf7zFmVHr56JGBgxELV+EBEbfpm08xpinbiWKgDL71Kw3UJemFBcIketazy0Sc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> The hugetlb_optimize_vmemmap_key static key was used to guard fake head
> detection in compound_head() and related functions. It allowed skipping
> the fake head checks entirely when HVO was not in use.
> 
> With fake heads eliminated and the detection code removed, the static
> key serves no purpose. Remove its definition and all increment/decrement
> calls.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

