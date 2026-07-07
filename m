Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C593C44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091B46B00A7; Tue,  7 Jul 2026 10:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042796B00AC; Tue,  7 Jul 2026 10:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F0D6B00AE; Tue,  7 Jul 2026 10:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B98CF6B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:46:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DA081A036A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:46:34 +0000 (UTC)
X-FDA: 84962256708.27.3B83F8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 758F0140012
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:46:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRGOucgc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783435592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyJTjmzLXvUvFLzrQN34wu7M/KTk4kD6uDDPgg62Ebo=;
	b=xbqkBiCpHKMimVo6+wP6D7xt2Ey7kDCWLogLq0lM6tZAJgeTRf5CAVpEOW363lRQNBpAjq
	DNSsfVnsofiEUzuQ7qZCmoTbXRBLODt9wSjJu0FtNQODN0h62kAFbEzUVWE6lsGV+p+iDX
	WKTvEawNRMOnSebQqlX3UO45J1Jdg98=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRGOucgc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783435592;
	b=LYKKy8S5O6RjEofjEib/pnWe48Vw+MK3329/bN/NCZ+IgSoGeJapxkY1akKRidMmBCebwI
	Xd0+Ra8v8CRNneQoYc+l4ST0P40WbbWMGlazI1LhKwuYNO68GYdHaxoWfr5w56o6gbjEt0
	zGzgUKDzw2wiSEPKsomEUTSAletku4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E938E60018;
	Tue,  7 Jul 2026 14:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390961F000E9;
	Tue,  7 Jul 2026 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783435591;
	bh=FyJTjmzLXvUvFLzrQN34wu7M/KTk4kD6uDDPgg62Ebo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oRGOucgcfN2Yes0Extb8h8W7tLIHXjvV+6zuJc++fMaVdFnf1IsJQx3tVT4bew1Ka
	 34nw4k5PU+suyZGMV/UJ3kr4xAHK/n38Vd7ZBfh3O2WuL+1X5CJzr0C4g5t9SWPRBP
	 GNLn6Bx1gtPzwOwf49qRGTS6B1blWyWH9GySpfW2+nWTFzf4gJjOpk1PJp75bjFNyo
	 +H9vyxQjzKLBKM2jALz9WcbY8GshYzUeOj5qP+RsL57vyIQL0HzZVxpHG3jRVUugIs
	 Sz8bz0HzW6G0Ho1SK0s3w0QOqUtuiDC4V8QsppZD6WMtrbDdXqLYlerFUEnEubiBD4
	 OqLxGA/LgHBSg==
Message-ID: <03762de9-c695-4cdd-8c25-4fc31335ea15@kernel.org>
Date: Tue, 7 Jul 2026 16:46:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett"
 <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>,
 Kees Cook <kees@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org,
 etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-tegra@vger.kernel.org, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 758F0140012
X-Stat-Signature: pns6e9e7q48j5iarchkhk91tsn9eim3j
X-HE-Tag: 1783435592-451659
X-HE-Meta: U2FsdGVkX1/hCO5tYUm/ZDdONFYwoN1jj4DWixW5NlOxGa/lwMzcuSRSoFMGaPRCEPzFGPvricHcaxBsoG/ClAtTFmeO73XqmXly8oQ2ioJqDtDQe4nNkq7h9w+wswNm3fZILC56z7pcC0aXdZtwQWu0pJM17ejbyJlHTMcl29mNvnD8iO8pc1WzXNJhsaXhs/3Ts579uwH9oPa624xmDQP5IyyiGZUd7GeeoX0HzR+8fYN47Qq10Yly3jTOm08uvHCqnOWtlW1dS+mc/VZPfyWQBACWcupxpdWjBXMCdDu2v/On/a6lRaVu31EHmVqOcWVX6Vxdy26h5OdAwmvXGA8fgNg28AjjYZp2CLIWBjusNgBestk6XbTzqwmnZI2a7kOsg5g9bcHL2NVveqp3zf0eSlvuuvBc6MTZqChGABuAT5U1U/Lzkza1FROSCJJ3rrZw2ehNP6pCJgFmdk5RAjhV4DaL/RhVhe2HH9hUmMWNa5BkxtjOOYePre+IT039mveB7oBcQu6RvN9PM/CLNmyuwREzViEDPNmCc3gLD70PSNX+oqaElF2Rncn358SjhKflPV+g3rW04LqWvS6h48sZzB98qXimjZL1A+KPFr7TtAfJST5/8V0K9K/94OD29XEeUqErs7dmSY/Ba4BRmAxRDl5EaFraxx7Q03KHEBw9vlQaklOq/uQwYtwjqHsAqnoiEMXo5FXV9vVu9G6maI2deyyAj5aPA96+cU5+UtXCfOTcLCuVCSAz3nFaeq5x6mG6k3mFZy6YJr3eK0P9d80AXOVNTEXQ+dMGe/k2XGnBg2p4Cyx1kNmEYFOzJ7/BR/gXg90sY9ZHnlF9Db9DO4HidiXrR4TpgvMYb/4vlrbU8+p0yz0Zqu1iHgZIJB+/EfDiciTSK5ZkIG5lGwPxqppmKAxPsmInqEHg0LN7rRmKM5CrEHw9c4C3CqtwJMSvZUCp0tg9CjFv7AnUHhv
 4SzgL8nj
 Wap6OidgYcZgYXedkIqXoR1yiUi12Dxm8qaRUjI7tE1/9du+oXWHCKqMJsys9nXVP2vD3bcG5Zgd2w0vyb65uDt2NNTVMjj4MXVDAzYMHa8MNTklj0VystGoZ09tWO6f1If/jHnWf5Q+J44tthI3my7xLDEYTDtpndDM6B7Cp71+BpVWNLdLActdKfkRBUBKJq/XIzyYxyOxq0EwfGJK4DmI5qWByOVQqYQqi8N1d0pGld3+AoFIeAXlFGlCtYQBUYuLF8AeU2bsFTn5WvfWLaBiBDqNkxX8CUSfv6QWfEGcBLEAdJNQMhRRXMmavbNeE2VHPjGugraY9UbSEiJ6m/BRxVRJEoQJ4QiF/4LGv+KGY7oMewVPO5/ixebbYPFDqdTJJyJgkIogplzjYe/NljaGQVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 14:23, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 059144435729..2f00c75e66bd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4278,11 +4278,37 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +/**
> + * vma_start_pgoff() - Get the page offset of the start of @vma
> + * @vma: The VMA whose page offset is required.
> + *
> + * If the VMA is file-backed, this is the page offset into the file.
> + *
> + * If the VMA is anonymous, this is the virtual page offset of the start of the
> + * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
> + * virtual page offset at the time of first fault.
> + *
> + * Note that if @vma is a MAP_PRIVATE file-backed mapping, then this returns the
> + * file offset.

There is the ugly case of @vma being a MAP_PRIVATE PFNMAP mapping, where it
returns something different.

(remap_pfn_range_prepare_vma() -> vma->vm_pgoff set to PFN)

-- 
Cheers,

David

