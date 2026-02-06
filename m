Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48513EE2086
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F03B6B0089; Fri,  6 Feb 2026 05:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E246B0092; Fri,  6 Feb 2026 05:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072946B0093; Fri,  6 Feb 2026 05:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE6256B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:42:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91ED21A0773
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:42:20 +0000 (UTC)
X-FDA: 84413692440.01.A3557F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4A2740004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:42:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VTysHtsF;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770374538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+jkxt/ep2Vq0npqHd3kAgPL9311GOhIAkMuXW7JH0U=;
	b=Q6c1I9EjcAUcHA811tz9hcClOBRxu/vazdgGuiRy1ALxwP60TlLtx68ALbfNBySt9YC2CX
	Kd8zafoA+A8FC+EfsuUdlwaJ8k2rBMRHlIpE9NNlc7hRIwE4Orf8IirBTUg2qz+W3izOf8
	+MdSSq3jQYvPIcsb+ZMgmytgtFZdvXs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VTysHtsF;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770374538; a=rsa-sha256;
	cv=none;
	b=pYEFyA2014aVGLtFefuD7fBJL4cz04verAEYmTDh7BqVwrgPFBI4wGCuqG7y7qC0dMWaMu
	TCBI59nQY3FeQ90QngkzlnZ/azTbkWdXoAkI8vApQaU9W7+vJ5Sj4WJQW7QD2wfyByrAwI
	Ia2TVWjhrz3A0Xl3r0979AD/oKEE6Q8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3316360051;
	Fri,  6 Feb 2026 10:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA05C116C6;
	Fri,  6 Feb 2026 10:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770374537;
	bh=X4ulH2AmDkCSg3stSWU0qmNiUtFh+CTtBIZg9eTnXM0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VTysHtsFbDZOc9nla0Q2lgBis/brgO6Tu+kf3ZjW0lCZpL1uJplM9eZTkXQhCcum2
	 UIQVwE1+A3z9/osnfEUHa5wrcr52RX4ivjXktLIzY5oVFuwODBON2ufk5tTgU6mn+R
	 kRQjtEeQq2irifXeO/1G3CFjPn3stmMk/VvAx3qvWB8gbBiWAQl6yd0+kYztL1a+QJ
	 eagSYMaSu7JIt54TiZMwJU+j3SfNPW7mc3mRGstPV06L/k2NOUTqClojWUxdl8PEiw
	 /vumUJqdqpNOYsec/0f6JZTDY41m2mszc4Rs+BB36RPHPk/B4ZAjutUf6q1FNZNSrq
	 eP+Xw8P8QMVAg==
Message-ID: <0ecdd75e-ccd8-4217-a409-51da756ff1fe@kernel.org>
Date: Fri, 6 Feb 2026 11:42:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 17/17] mm/slab: Use compound_head() in page_slab()
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
 <20260202155634.650837-18-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-18-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E4A2740004
X-Stat-Signature: w9m3hhti47c664zpr7srrtggkyzk1156
X-Rspam-User: 
X-HE-Tag: 1770374538-159734
X-HE-Meta: U2FsdGVkX18C5cUXYZx29FeVhgoKU4outSLLfkHRTLQFw/DWG6ztEC+FXXgqbpAEPo/mH7VqCPjZKdgXES38X32mya2LIJz28GmNUnd8ovrlQckYDYJORR5PDp8iMp8noJe6ierhwfEIwCWD/v011paE/lOMP1O2lo04k0OMcwmq29sVLFMW3Bl42cmJvz+RuKr+4+aJofLBc5GBPCZTQUxEt/0xmKkTHXGf8duVQ9EGdzkKP9vWX6RRzhhSk1BRN8IxDDTBjzt0gU3Au11XHQRz3D7oBmF325kYxXKQbQQRDhsbHLA5fRU5Do7vMTS2FRA6aLzdFlkChqth2nPl9B4bIqeO9CzJagqFweUsXRgiAFR1Y33033JvKVe5JGgT23b7IRS+0KCZ7yF5aAyWw8iyxDMxLKhMvTFZE9Cfm2sVKWvh3t3+raiR1uP/qNkZT/UZyqvKr3e2wKXVtyioZxPytWz0VTCxxb9I87J9tqtg727zOoc//LRDEib/9mFItuTNKSswHaPCI2XF+T9E1uvHpLiOVgIcjyQfDkdvVzyUrSYeky2jdUTzmjPUW7KtXcwIDYXClpLSl3AuL4JRvuRMT0g4nYp2+NidKFQbg/l8TvX9j6T1sTz3bYV63CoTd9TmhJA6SkexSPcwsPvJxNZpOY/oxsmSy6oVke5v2SgRPCt9OiGTwsDD004NFfzRTeXIT3D1TwSm4k2GVLynbCQBCu7ThCWnyKg93tCP70PRFK6Qcq1hl5ucQHURGU/qx8xyBBUY1qaZVJ7DEHZkKOxk8fU1p/a8D9/k78KaPipQzK6/oGwKW3owwRNShm0jnXesSB719boBW/UQMDm+vU3c5VPgmInNj/QQlkI4HE7e+c1S5RHAlcghV0ZiQvnK8uRhEVNaqfRR6Kz1wGCkhBRz1h157jm2iFDzQjLG7tjBll/UwJhs9UtTEmEySomlb3L66VzGAjnUjiZA7EO
 eAykrRPS
 vHc5SOhbyJc5dUR194zD1mT/u1TpKw6nxEDsrRX0eFGfIPU/f+3iACxnZ1d1LpQuvq5HORKLIFVmAujODYMoDhgearITx85OQKJPENo2TlPM/AQtQ0UKC5wvYcQr0ojafvZoinqAh98BVYpvtPzKVws69s+4QuPqvume6fiXBfk6TInXrOhKM0PUGqN0RL7f8xaF0Y21LdDveYlOvtFNnDPpPomS0HGgkNBo4ODwUClPwoA3cvV4wlNfKF/ocIA2gPhUiUeQDNOwgF1aAn2JfpxbdezuthGyixJGIknjxO049dLvT/H9Bn0vgU29rXUJxHrpylvXC/Gaj8dOXok/pHQ8SGjfHgLsq7sFV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> page_slab() contained an open-coded implementation of compound_head().
> 
> Replace the duplicated code with a direct call to compound_head().
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> 
> ---
> 
> I am not sure if this open-coded version is intentional and required for
> memdesc transition. Drop the patch if it is.

commit 2bcd3800f2da1be13b972858f63c66d035b1ec6d
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Thu Nov 13 00:09:15 2025 +0000

     slab: Reimplement page_slab()
     
     In order to separate slabs from folios, we need to convert from any page
     in a slab to the slab directly without going through a page to folio
     conversion first.

     Up to this point, page_slab() has followed the example of other memdesc
     converters (page_folio(), page_ptdesc() etc) and just cast the pointer
     to the requested type, regardless of whether the pointer is actually a
     pointer to the correct type or not.
     
     That changes with this commit; we check that the page actually belongs
     to a slab and return NULL if it does not.  Other memdesc converters will
     adopt this convention in future.


I think using compound_head() is fine. For memdescs the function has to be changed to
lookup the memdesc either way, and not go through the head page.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

