Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D240CEB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1176B0089; Fri,  6 Feb 2026 04:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F536B0092; Fri,  6 Feb 2026 04:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8D06B0093; Fri,  6 Feb 2026 04:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0EA6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:14:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DA4716086D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:14:53 +0000 (UTC)
X-FDA: 84413472066.30.DFD223F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 475EC140008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:14:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H5sOJ/AQ";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770369291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuySHAhI9deeW3BF2Ylr7RHH9fDD+nnFMmTztLmbx0o=;
	b=vhh2zRBRbsACLB4N6puaiV4G6uAxDhpSEZjujBNLSuSZAAtgDdAJbX8vs6D6cY+j+byIkR
	avP1h+W4WdAZP4buFO+bStyVoijx58W3GWsrzJt/WIAv/YyTtDxG3TAECTYiGtDKppJ7dM
	GusFXDa0rGlRaX2ZX70lVj2A+qmzA2M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H5sOJ/AQ";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770369291; a=rsa-sha256;
	cv=none;
	b=FrdQoc7x6IZd+NO7Odwg/FgImrzMUStAbZnh5M9yOsYLWpY63ekuRVMUPe9nkasi13jlcz
	OCUj1TQH7aG2l18dqIhEDhgUcGuxYuH+y9uMxXe2g9+3HcppM4aVnGXd/vLX4ITCOf0aea
	a4/mtEuXmtIq6vnLVrpWksq94OwN87Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54B62440D9;
	Fri,  6 Feb 2026 09:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD80C116C6;
	Fri,  6 Feb 2026 09:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770369290;
	bh=TsoItULYpmYPP5+qItOY9/D0ks8BEhX/aixQCeipdPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H5sOJ/AQVD4KQdyWWnwpvGbsCTZKl09ACof7WNuoWazmfL2kJlPFbD5heZfAYPIbz
	 d2CnLYUMcjF0tIbpv8zNS4Qg1isPdfN474/nNE3Eulr9/zFc5gyKGxM8T33/oy367q
	 6fs1VzwFF7AGydtM9nWDqkQuQxSLFHXOZFF0ABPsCQZ44YHHvBaD7f+jyCx13Y8Npu
	 EC/ISRF8qqpjKLGAUrmlvuTVz5ntYB1AURrL/xPiKqN0+TYLMb2W5us/8fIkpHwMrK
	 uKicF1sG7SysotASG6r7gI5GHQStrqKlaklkU1b6PT+Xqp1rJG9ZuVVg16mXQ3J1HK
	 Zf0C4zQ37KubQ==
Message-ID: <7b88fdcb-6bd9-4eea-9174-81ab4763a0eb@kernel.org>
Date: Fri, 6 Feb 2026 10:14:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 11/17] mm/hugetlb: Remove fake head pages
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
 <20260202155634.650837-12-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-12-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: r7q71ijb7jspwtdo4qutabh1h5ggzaza
X-Rspamd-Queue-Id: 475EC140008
X-Rspam-User: 
X-HE-Tag: 1770369291-100127
X-HE-Meta: U2FsdGVkX181dwIHi0gfBDCCdp5w0nosvbG7uNPdD8DwYWjg/w43ZakRelxW1dlk+kiab/Z9s8Cgkv6bfvz2gyWOfr+z6jR3B/wFr2V6fAMVQgjpeQVoXYsVV7WYR00Fy4gjGknlcuAEMwLm/G4iqHpzDWjgihPZEebfLlrp5ds7DLMtU/T9VRrEWqRUNoKChfumBOexWCnYzyqgKQ5q/bIrV8r1tzU1AmvBsim0bOJsRXq659xjkYNkL1bZcu8QqrgFIOaaTvgUiQW3eTg4duMuAVvXy13oRpMgViHylPGwR3B/PU9OzGX4luQJR/ltenUtVnt6CBP+epfSAxPjaiVDIJwQNjJYWIYAoFt1iA8D6PvSmxQuZh+1VOHMbXLvsMx7ys50SmQmwoB5koHM5PWsiPiDYvWus5YCq6jDJHDTYutDL7D4zEwTZd4wm8TFpxK6w/DXkDk1lRAp4JhjEfQr1CuK+Mh5AEwbSBgUCGuojyFA13DIcBSSUOopi3S/8xLqWMoQM1/eBAJ2eteTZyD/dnfrG0Q4jCFlVmW0aKausC315nVNf4ge04CO7uyMh6cN+rOBdVD8tIu5h7ghT+b9tf+z4dzL4DS5c2+Ea1UyzxsoJ8ZpooK+OhulFkhc/vzOkrVEOdgFXVZpN/EsNdf2uXCvoqNPBkH8yQchs8Ck6Mjw9aPPmn8Pk0c/X1+huS7i5L8F3hzqm4U5Ktu4VNgdAn99YwWHAmr7noM9Z6OEuzHfvOc/MIuwI3ptl1U3dehqKnUI2ELAhyIX5phO0kb3xFiebv2mYZoUl/POgPEMiOLYftWwMuicnqr2yBS6qsWCa1rnq307UzyX9Q9P1qYEtgfwpQfjyppcztxdyea/u919ZYuXSbdsGK0JARVBYwZJck2CY90Pw5PKy3tuc5BtKQeLzYjWDIQXl5XQDjDxr3MqY3Ec17sKUOQl5W1ipTmRV49GeS2hBDtnAsi
 pauEUqQi
 A0WeR5L6ZoNIj+yXMZFZvp4y+O8QO+4TCL3nazHbu+sA++3w0Lbx/DleefQdAacMNMOQHoEcoRL/uMyF0++7bWH7qkAcJiYF5AfpjcZqDGsJEyFm3QLeOOEuwKUdCK3rxD0gL32laH8Oa+3LDgU1Vu5FexuDyniZBL4i2N2IZkmzYzR+XUtmoaOJhT+txkoqH3CdtIAutI+U+VMKHi9eo8o5LKU9anbnnMwsTNStxAGuxrX3eJ6oqapQdz9Jl5gk+Xhxf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -/*
> - * Populate vmemmap pages HVO-style. The first page contains the head
> - * page and needed tail pages, the other ones are mirrors of the first
> - * page.
> - */
> +static __meminit unsigned long vmemmap_get_tail(unsigned int order, int node)
> +{
> +	struct page *p, *tail;
> +	unsigned int idx;
> +
> +	BUG_ON(order < VMEMMAP_TAIL_MIN_ORDER);
> +	BUG_ON(order > MAX_FOLIO_ORDER);

No BUG_ON.

-- 
Cheers,

David

