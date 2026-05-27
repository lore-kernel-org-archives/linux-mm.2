Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCDBDCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354D66B008C; Wed, 27 May 2026 06:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A876B0092; Wed, 27 May 2026 06:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268EE6B0093; Wed, 27 May 2026 06:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1969E6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:17:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8668140519
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:17:08 +0000 (UTC)
X-FDA: 84812796936.17.C7AA0DD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 10F4714000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:17:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fmxXQqKU;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779877027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRld5Wcck+NQkl+Ba57Ewi20eNq6fNg4mXgw8XROWm4=;
	b=GN+XvkaLzQJ7rHX5dDy/OD49fcINFuaG4OELZuIo8eILSAwMVVktzjNUdn0+DKqujOcBdX
	AgvKw7dxvbDnoHhqMHWdT0P9boJNMMvDeRJVLzQuyAj+v0nj78UKagyITvcjFmDqHoHNqZ
	AoC1sYMT/ZWQQPqSke57k6mcMlpFtG0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fmxXQqKU;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779877027; a=rsa-sha256;
	cv=none;
	b=ApmTn2nYEpgXu6fX+1n16B1zWjAI7NkWlqUPYxs8nLXfRyx5SXWH0enaUmSvzYq6jHZiyS
	78f0xXR9h47637lJHj5+lxi1wIVmWgjPkifFrRGIsLT4LgX77atRsXBeJq1eGW5pDhDvPA
	38ZDI2V+bHarSb1bbzhnnb48LI9LEa4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D05ED169C;
	Wed, 27 May 2026 03:17:00 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C95A03F7D8;
	Wed, 27 May 2026 03:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779877025; bh=dxunWLVNoBTNDPHHustbHNmVfyF9OQc1rk7qCoIqqx0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fmxXQqKUIE7YXewLZD7f6o3CN6kx8C77ayMefofVQvhrdkf1NCB6SbhjaoezhKQGS
	 izyuG3SrVtn/se2hI6rcmbO6WJ/pAuc5SiYa0yYFxfhtGZBEdUOAUsyHtwavejCSt/
	 gMty1AQ7C57596xePSczg9VbFzWDLqFL1s0GZ8Ek=
Message-ID: <48cbab1e-5547-4dd4-8820-6c918b3db537@arm.com>
Date: Wed, 27 May 2026 15:46:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: update file PUD counter before
 folio_put()
To: Yin Tirui <yintirui@huawei.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Dan Williams <djbw@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, wangkefeng.wang@huawei.com,
 chenjun102@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260526101355.1984244-1-yintirui@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260526101355.1984244-1-yintirui@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10F4714000A
X-Stat-Signature: 5pouieix9udbqsfeiqfj4yzcu9qk96oh
X-HE-Tag: 1779877026-453507
X-HE-Meta: U2FsdGVkX190EaHFfiF/EZ3pKKTf3td4ByBjumq5wUCsD7+2RrLWZg2jaERlDpJlEaUMdbwFiam41EIP3WRennEGQkotw432HRkOlKt+byeFS78QrzC5o1XkAsEF8li/3iSCkD6dAeEXkpu8ZeQqMxG1z/N7khaU0CSXne6AcxwNhwbyI/hgEGhkFNgNGcNCiXtnd9mpQJZ9DTKebam0sUsRSYvSU1hZr9qkL2P2xtSI5ZebYt0cxqPYTMi5L6Su0+WyPKGBz6if0jl2Un73SeFRLQDoddZf9vIl7KCvvlL/Im+DxiG2QbQycMb9nBq4QZw/dVh8K439xpvt1X0XTkii9YxAtYGv07T7NE6O88LuPBR8XayqBSSDI93wimgjmJ2Z9fgERCv8u77FCrD9WiVFjV/JTbi/XnULR3/KZOOL2EoDk1ruc6hz5zlogFamQ4T7gV9DDRIg6E4/4kTTBg14aMhELByQFH1nvP8pm1xHe6c8wLvNUizcYF4nEVHs2x4i0kdiuerRR7wlInlc7HWdrr9eF+vjqEsuA2OJ/Z9Ihd3Mm9AzTackuHwEaBAA9zlL9Be07CagATvjey1FHiq/sUDiMgnZvH1uXJmG25FD/6H16kauXuuYSFNL/u+/5oKbNwxXCCJljm0qinnyom3cr/LZU/drKui0Q78idwub6Q4yLTeYlPiWso73DzUjKMOqeSmNXkLWiP5MSHa70PJZWdY7w2HXU6lFRUNv8/c5nftm5Iz7GAJgsBbaha1HNYSp4vESoWhOBnyNkCF3+VEbiPBfGkWRgk+RbjN31iNvNWAhpyuFzYWV8cREw15lW/0Fg7EYzIXUQXqBTDlxM6vwOvSGU3i6jwry31GtX1QvdwP6zfxPerVerha12UikdBtnasRZcjrepNJ/oXHPLy5lbPfQAsoLpkeu/5npYPOYKR1dAjv2/MoEQ2rIuC1rjZo00Ua5Fjf9I3yfbvG
 hMrzokZe
 UX9eG0UibfbpwyU0jvYSzcu3OUv8n01CVI3Q5UCrHZ5jEHHSB4pjXGvcaEe5BFJcg/OrLjotWoOLhkMZDKFV5OUJsUu0gvyUc4rN4S7e8yBsm/0w9CDOxOkDOO4P8qQXyTwXPExjKOWUS0tYt1/O7c58rjIssmPJh0yK/b63nuubPam2qys47kjip1fdPjNpkhsYq+ooNEcqL6m4r7jzWd3/csETBRzDJKlzatK1RT/J2j6nvwC5Vo84pRgbYi7z3Il/iBcW3EyWIAR20RlZgpxbELJ08blNK3voyXvty3mP30VH6UCL29ofG8ONNKpY7WHX3dILCepyZ+URt0f7bkpqJWkL5ykyTPTzYNZWOG+mA5HmcExdQEq6bvTWQ0oz7h5nx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/05/26 3:43 pm, Yin Tirui wrote:
> __split_huge_pud_locked() updates the file/shmem RSS counter after
> dropping the PUD mapping's folio reference. If folio_put() drops the
> last reference, mm_counter_file() can later read freed folio state via
> folio_test_swapbacked().
> 
> Move the counter update before folio_put().
> 
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a5f4a48b7b77..9832ee910d5e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3027,9 +3027,9 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>  	if (!folio_test_referenced(folio) && pud_young(old_pud))
>  		folio_set_referenced(folio);
>  	folio_remove_rmap_pud(folio, page, vma);
> -	folio_put(folio);
>  	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>  		-HPAGE_PUD_NR);
> +	folio_put(folio);
>  }
>  
>  void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,


