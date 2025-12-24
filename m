Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F540E74915
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FE36B0005; Wed, 24 Dec 2025 06:51:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE276B0088; Wed, 24 Dec 2025 06:51:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9336B008A; Wed, 24 Dec 2025 06:51:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA2496B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:51:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50C9113902C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:51:52 +0000 (UTC)
X-FDA: 84254200464.13.7FB7930
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5AF4C4000F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:51:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bj9MAiPn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766577110; a=rsa-sha256;
	cv=none;
	b=pcC/z96iK1d8IWWUg3zvahQ7rAIlfeXvuT2OEecb4QVzcW2enwNO6hC9JLIoRPBC9h/OJi
	YsIfFe/CA2Hy0JFwVbh937PNAtbQg8yCVE1HzAybTgO8oIGB0Zeyb5ss/wQFkc41M8C26m
	UCydVj7gpb9XAdu+l/1SnvjmUWkW/vg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bj9MAiPn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766577110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlj+qYNSD9ArUgWjMNVWYsSJk26ac0eHZulc973xx+A=;
	b=5ewMz14x/taKS0YUDzYLvAC5O0GIsaOR18dqaxu2u9nCy8q1YHqpmJP8lUN7e5saY7l203
	ivZ9jTEONIZDiNhtGItn6JLe1fXBgBq2iqa3phAvBICnImodQoFpy+E6K30g7ySyeOnZjY
	hYsrZhPn5ItuayHTJWr1WZpCKRE8KrY=
Message-ID: <6b408736-978a-4d40-adfc-97819951c3a6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766577108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dlj+qYNSD9ArUgWjMNVWYsSJk26ac0eHZulc973xx+A=;
	b=bj9MAiPnFohtWISNZ7PPoZ7tjLLSaTi0K1CtXYtDt3lvFPDrc6zfS39xupyWiDikLXkSuD
	k9yJeZSAuLxWBgul5JkeFePrADnjvQAE9q2e43ONFoemonNfka+mQpDGSE10pWT1OgKcih
	SzzVjy5zSySzckFTYl1o6Tfkz2SCeQo=
Date: Wed, 24 Dec 2025 19:51:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V2 2/5] mm/khugepaged: count small VMAs towards scan limit
Content-Language: en-US
To: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-8-shivankg@amd.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251224111351.41042-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5AF4C4000F
X-Stat-Signature: qohchi1zdxiq8r4tt4hcxtbu8zs6hkdo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766577110-395733
X-HE-Meta: U2FsdGVkX180tbIfkgBHWCMVUWuZXEbMmHLQlzEU/VQcp8FLTA+kPcJs+4RLH9SXkvgRbzJBVqlUdAAngqqTPTQC29Wapsa1kM65AaN6eOt1slaajYHWRVF+DmVmd7BJoCDiP7JAypjgG7xGvMYoSX9kt0sFWCTksnprDRcaHGsl4tH2Sgt5s+/dm0dTgLs0ZofLzdyfwVsAwARuyz4rNN2hqAKV2pT0j9zCdCCJuM7WNv5L3SrI2hr+gvbzGXeq5aYuHQuKNzXOP0ms9wqAmNj6C+6c5OymdI6jKLrbJttJHQcAX6fuLmmEYvIQV9iWBvOlqIqi9sfQeYPbwY71Kzr3yUkCP/ayP+A3HxkyFVW7gbvfrXQpwqP8N0AK9PHEanOSa/wo9N5BWgYmNXoISaXvYUgCcwVItGeS/NEmK4LDurVdyPtCEoLwU6aCDJymvJEFNP/uPcqOw5oZOKQUVoxu9mYmhIezYscW+i+Cdbuua+7o0zPpG3D4qFej/KcXHR12iravK3yYpZ12BFpXWkZYGjkaTdZD5E7bCR5UkYuQO7l23pCBIhB/jiJrtHEe+dPpN2ZEtfmfInZrJlPcD0rXUFV6c10AsN5l8vkMPvlUawgie98gSe0Gos266Bk/zBLkeKdj4FaJVDp2Cp14XQtF6MmVGNZuM8MeamEoKAQXv7C9E7mkFiZdAxr1jd5zQ8gFobI9hCTSnsmv3P41aw/Mw/wXOE9fpja6jF/3/XDGqhvk66Mhqd5QUUHqKhw+YAi/1Y0KfO9O+B5hhK11VtXPVVkSuQEbevR0RcE+qt1t89O88d3OAAicFFcJBmUSmYTOkbHW7nXilHGoJureBpQ6WPjihiMbom4+4oK/n53I1RcGGjkOxAe2cOArYni+PcJ2CANeAF21MZ53q4pjWJNk2Ra/f3dV9WhzYpndDM5dBNBF6WmnUVX2SY27Dg+WyruOcR0bOi3DjuD90LX
 DXr4h5SJ
 IGoysXIHnv8dc60GWRu7mT2UK42geQ5pSJptuxjmWceY+V0+xxWuBkH7+v4zcatJqeB8BrXS6Dwdx28dPv1wQGISSF5EjLeMmmx1TYtRWFHnK3lscKLagseStBhcXZ4Tqiu0QQTNKdNdXhbx0i9KfAhaS5xHpQVXWzvsFri0e9+/v3z0I6dU7vgWitMz/4bkSeQubNp3QCLrBdbxyCzZiZhN1Z0+1EGgVReLdqA/JW03/byosqaMfuWemA4XvGal6PT41UEnXOJYHzG+ShbbBwVTFtzvdiim1XzbzmsT/MALhIbJtAIwOojRvNRplhwYh5FVU9wtFluLWyAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 19:13, Shivank Garg wrote:
> The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
> amount of work performed and consists of three components:
> 1. Transitioning to a new mm (+1).
> 2. Skipping an unsuitable VMA (+1).
> 3. Scanning a PMD-sized range (+HPAGE_PMD_NR).
> 
> Consider a 1MB VMA sitting between two 2MB alignment boundaries:
> 
>       vma1       vma2   vma3
>      +----------+------+----------+
>      |2M        |1M    |2M        |
>      +----------+------+----------+
>                 ^      ^
>                 start  end
>                 ^
>            hstart,hend
> 
> In this case, for vma2:
>    hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
>    hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment
> 
> Currently, since `hend <= hstart`, VMAs that are too small or unaligned
> to contain a hugepage are skipped without incrementing 'progress'.
> A process containing a large number of such small VMAs will unfairly
> consume more CPU cycles before yielding compared to a process with
> fewer, larger, or aligned VMAs.
> 
> Fix this by incrementing progress when the `hend <= hstart` condition
> is met.
> 
> Additionally, change 'progress' type to `unsigned int` to match both
> the 'pages' type and the function return value.
> 
> Suggested-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   mm/khugepaged.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 107146f012b1..0b549c3250f9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   	struct mm_slot *slot;
>   	struct mm_struct *mm;
>   	struct vm_area_struct *vma;
> -	int progress = 0;
> +	unsigned int progress = 0;
>   
>   	VM_BUG_ON(!pages);
>   	lockdep_assert_held(&khugepaged_mm_lock);
> @@ -2447,7 +2447,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   		}
>   		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>   		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> -		if (khugepaged_scan.address > hend) {

Maybe add a short comment explaining why we increment progress for small 
VMAs ;)

Something like this:

		/* Count small VMAs that can't hold a hugepage towards scan limit */
> +		if (khugepaged_scan.address > hend || hend <= hstart) {
>   			progress++;
>   			continue;
>   		}

Otherwise, looks good to me.

Reviewed-by: Lance Yang <lance.yang@linux.dev>



