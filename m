Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E96E9D408
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B8E6B009E; Wed,  4 Feb 2026 11:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF5E6B009F; Wed,  4 Feb 2026 11:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1DA6B00A0; Wed,  4 Feb 2026 11:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8C56B009E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:15:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B30C214024E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:15:00 +0000 (UTC)
X-FDA: 84407273160.27.EAA4306
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CFBB118000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:14:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qq6PmPjD;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770221699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5iDN2vIV71qjvt+RitJ3eEXc5ng3mYIItXp41S3woo=;
	b=8lR+sxuob2M47sYwEeuaVST3VgcAvKQayyhvYNBibAD+XrpqPOwXlpCVJyFpy/OBI2BIKX
	RPrjJIFCILqgWBgtaimbPxFBNCRNa7GLXX/8MOkHuISff4oiDO04A4tzSYOfdwhgPJMciO
	eXUKoB/fb1ASLe1B3dJiJXrte6HvL7s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qq6PmPjD;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770221699; a=rsa-sha256;
	cv=none;
	b=sWaHHvyk7d/UHt49Y1wBGuTN39ixrxrqTiwug5HGs47DS8yGJFghJeBATgC4kfjiPanSW6
	ATF3s0vwr/Amozo3cVXpWba1y85/bzONDh8BdRhE4IRWBeGkmIHONwlSjkh5n63ZRwWkdV
	H2Dgcv2i21J1Waq3LCNCSXHwdkoYGA4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 096D043B62;
	Wed,  4 Feb 2026 16:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD053C4CEF7;
	Wed,  4 Feb 2026 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770221697;
	bh=Yq7rjOmFg4CcgdWMbNPzzzqdWj+uSBMikYGgvwuzD/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qq6PmPjD7zhT9ot2QC9bw/em+sjKidISKx+M6635S/VLsnSzIHdkjtN3GpT67jcVr
	 QKlfXbkrjUsEQPFC2Jpef0f3usL6xPZI9xZieC3loEmehrI+znscnN4is22oUYPksR
	 rLNA6LbvFNFQvaNtCFMw/183u+J4q4YjuNpPXp6sffxhBR5wqIFTUEdaQ65autXc19
	 r+6Ehby9ipL0DS9jDaoAPiPGn1RaSy1oDCFzEP+D7twyWyIz1qzdBZUqdAS0Aunubc
	 msROGZeqxyTwEBrXiYGhpKhc4MQLyN1l+teThtvVP0lC0IvtsOE4AYyeMp8bbmQasP
	 Zp78VUUPu8HZg==
Message-ID: <7904198f-f4cb-492b-9e6b-4d9989b8d40d@kernel.org>
Date: Wed, 4 Feb 2026 17:14:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 03/17] mm: Rename the 'compound_head' field in the
 'struct page' to 'compound_info'
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
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
 <20260202155634.650837-4-kas@kernel.org>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-4-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: atpdg3m1388czxk8kz7bgr5gas1gn4z8
X-Rspam-User: 
X-Rspamd-Queue-Id: CFBB118000E
X-HE-Tag: 1770221698-571247
X-HE-Meta: U2FsdGVkX19kFgBFW83GR+BZJ27mKblIHY26qD8b7soz8nn6d2kdEmKy9dVAEpAmhnJrXlqotfPRr6lnBE5gm5eVJkw6UixZTknS1VIyLvOLSTNQAg1ZRYvdVZ++ER2SNpMs6ugi6q3t9ag/eR8z7NIZbbcLv5dHs7E6dDGuWUlT7ZS58Oj7q6RmvjrGOXQy0/stXTLVzkkUIHvMs18rSuYL/e3K35psgiGdRjahfqjjFYsmh16hSVJpY4YP18rhDiRkhRGzpGlYsfxS9hVWYDbUo8iaG7sBJ0mHhGBmhbKYg3aW3ufEUA+Jlt9H+a36ro80zlTKajs4+yVERr1y2exNF0qM9wBUMrhIs48HSi6zL87+9k8dNfZBSc03t+f8xxRoujudiBP0r0mEWPIjhlgtfyfrBnWOCVFn/QAYvu+U25BdmE5Qefa7p6F4yjdUcvqI7akQdQiwUIQ7gzkM4L9wHxfn17U9Zw7J2NPsyxWAhwBr6mESCdJ2LtVX6b/UB7JiJInq2vqClvK3SNnsYE/DcXLA1YEN61V9zN3dwNpYybf7jnu6py41FXvxzLfL5KW6K4YhjC7aV0IoJTaptICDA+yQZOgzD9pmdrB+WZ8UT1+hrSJn1zahz0XO0dp1KGJu0N4q87xzvL2TPaZZSva80MrIZR4mqXaaBhvNqi1xUkN34gj60eIUQ02kGUj/g/JzF5YgLNvSo5bdVQ25bTXki6dxITIYJrEDlrv9rHjLvxUPWOMYZdGzC5zvqU2FG+WPadwzFNjcHK7l3qPP8+neV+p3wPUecjqkrNXg72Fqob4XwNTHj9JER2sf/pMw1kzwbI5oO/9IornjcO6UPlmQdQZj2uahuPDFCkd+iy6Pj1WIc1w3pFWwmOrU8wSQzcFZf8lGJ32iYvwD9cDX8Pg5CKlI3111S9HBY8S2UEfEhYXUGgp+f9SKpfYYfTljS4s1NiTxRhNir+mLsBD
 FVkjqC3v
 gRJDxLR6nsBYwbbpqqFZRvQ4H3bS0yXEADZzSaf7q+bJzPKmSBJJNiSfl0NyKRNgUEImdx7mzv296O28WDd0yUF6OzpjsgiG/DKuedIDGeUkmnnEMtezQQt8i/w2XNgjWIoS9p+vGuB6svn2XMPRBpLy9vFrbcg7iMWj0XmqgLbSa0/BRGtbIDQA0J08jEibJRoBYe6f37SKQw+C0oD9aLK4nL0YhO9arEic+0j8KO53dQ8s3A2uKMagS9J3+D3VMn2zlvgexH/lVJF+DLBGsxZ3uHhkuOdm3qawIMf/qgVLcoPzNTiJcK0RHyG0b5XL7iJpOf4tyXb0VkeyrzZIIERRFMXqIChQEictw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> The 'compound_head' field in the 'struct page' encodes whether the page
> is a tail and where to locate the head page. Bit 0 is set if the page is
> a tail, and the remaining bits in the field point to the head page.
> 
> As preparation for changing how the field encodes information about the
> head page, rename the field to 'compound_info'.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

