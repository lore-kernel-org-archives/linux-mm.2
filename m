Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A19606A880
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0M9m9bTX
Received: by kanga.kvack.org (Postfix)
	id 073B46B00EF; Wed, 11 Nov 2026 11:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3FA46B05B0; Wed, 11 Nov 2026 11:54:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E078C6B05B5; Wed, 11 Nov 2026 11:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B80286B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:54:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B01C140337
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:54:14 +0000 (UTC)
X-FDA: 85423436028.18.44A719B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51E06A0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:54:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0M9m9bTX;
	spf=pass (imf25.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794416052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZV0DCoX0z7OhXM84shwRnxOMC/GGm++gJpoqjH6j0k=;
	b=X6hIV2rJZldmVXX2EFwyZOJvoSUtlGUzG+ppXMTOP3W/xTy2hiNwDwWGBnGbzyGDVLGEDX
	Ehrhch/kfShiLA8mxEcjSl9HWEy/Kwpw0BDF56Y0bc0QqHl81WZTzsidD0n4otVux8xjhF
	5cpgr7nhq+ufGB1J0nND/La644nSk30=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794416052;
	b=z2fY9FD3hpkeuCl3pv6oKuJHyFODqfUc/BX/9S+AIHD9Ukn84gpzFC2Sm+XE4XwBnEoKET
	KVN8sMTgHfJpszUxrU8vbraBJvpWf3gxhh2hBT5A8xpglvD4a4Rh6y6HzMxxEbMqTqAiQa
	7WrfjfBDEzaIz5HDgIshnsLKo3af7Ig=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0M9m9bTX;
	spf=pass (imf25.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so42171625e9.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794416051; x=1795020851; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ZV0DCoX0z7OhXM84shwRnxOMC/GGm++gJpoqjH6j0k=;
        b=0M9m9bTX4mkMkuhS/98IS3cydduiDnwkkTZCZ8uICPxu17b2KGwvb78qxtwdrelsyq
         C4MdvFlsRBkQmMZCPXHzeYKt4EfAY0F7JVXme5sJGxBcPSHFJbLSGUFE93t/XTFbiFXH
         IhYZ6U/ekZf0YSbXcjEbRZUIEfhIhOKajl7lXcgEt1VbozkykPTD/iXZJvbynXgfE3xe
         26SRYTEbzktdfMke9vx+8ImG47DRQ8mRuOYKADYVVB6I1ts1APxQQVZ2yeNXKwtXo9QT
         mwBAiG9DgF2plmq2f1nNF3zXF1O797OOwgZP9O29o9V5k9LWjDiCXaRBzmAOTBzzEDPC
         MNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794416051; x=1795020851;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ZV0DCoX0z7OhXM84shwRnxOMC/GGm++gJpoqjH6j0k=;
        b=of+Xauu4L62tRgwqhgoIIe+a769Q2ryJJQiVxxgwp6xMWv75g4Eb0ogF/DTs4ZojIp
         +8HfZx1bvloBdk4BoxJ2nGtgwNl3cRVZJW9XPspYoFxBJv4grjxbRg+FIxGWHTJhIMJb
         Jil1a10WqcGdbhyPpOJIvOrpe0GwuZOGh5wy59pvgRbJThMZKRe2ohUDD8l45q6CuPPT
         jz+CiAryWE83jgs5JJg8tsDH7uJh0L+gOMff99fxZhpGUB+dZw+w8Q51MFf7TQF4LlI4
         8yjLg9MwfVaZSl0D2BqE1DAVT8+b5UEgov34aIRH5ZEb9ZCQtbqrVTM6Fz50Ov1RaJQz
         jPJg==
X-Forwarded-Encrypted: i=1; AL+hErEPi/xj8dghe7AmXFbhUHJKGhfzJckp+A/HMlOg/MdkjMpV2vmuj/QZcrRXteQdAuUsUsBpX7LKfg==@kvack.org
X-Gm-Message-State: APuU4Z9ZLVmn9GiXBUXC11fSm1p35F7a/EegMe5je7iz3CzwkHlYLsyZ
	AcJ10IMH2uHfsERqIXEAx9YC++FyNLmJ1BVSlizRMamLjnAtKzExx7EZ
X-Gm-Gg: AYBFou2JzfeaEsk5SXeJMGLjnjY7ZWX7qT6uwLW9w2fqBRXvoWMqvNsyVZP2BRLhT9N
	6MaAdgLUA7njg6I+a3DlV1F/Gi2g8jXh/HEGd4QTb6AeJ17IgA/T4J+moy5IXDXRzXX28p0Ey6E
	0UVlH4Jn9tU9kfP6YVOKjtzm+O8rO5zvj3XrsA/fKwX+ua6D6MgkFoEorCO4ZvHDflA4s2i83eP
	2CkaM/J5n1tnYc70icJKUphtb82d1Qdg1xIcoNAOkdArMn3W72DxR63uWHXi+XVk6Es58v69Kz/
	RtOb/YOFkm7rFFeFI3xV8vKiL1fn9NpXC/LkkVPiTUw5nfFomUN0xCDLayzFWwM8oUXkhCPPUi2
	8+pp7xfFEgJ2FNITG5f4qC6uRd9lLfP48QW06YDXzpeIjBAHTHmm0e6YrLqWpohD2ikzTjZgzQv
	ifZFIgW+537CaO28cPoH37nWSk1qXY02GlcB+UUDFAzkdgZjO6ve6IVTdTZDxPxcm6j7OSpD4m1
	G6hZuVE6lRAKPUGw5Fi6UX9jMlMs1XwAvJXpJUYxpdp8rMTSzUY7acnT39tVSPV6TBFvhopW9IX
	GDljlnLItVunrolt7rmZABO0tuiBgcCXHn44xZl71f2nzYI92KRbEwAhctKdzlM9zWQwRuZKw6f
	MJZ2txUh2Z71xvQ==
X-Received: by 2002:a05:600c:4e11:b0:4a2:1612:636e with SMTP id 5b1f17b1804b1-4ba0937797dmr51138865e9.5.1794416050686;
        Wed, 11 Nov 2026 08:54:10 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498363dffa1sm11523387f8f.39.2026.11.11.08.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 08:54:10 -0800 (PST)
Message-ID: <c1b4cd90-ed08-45e0-8e2d-51b52b16c4ca@gmail.com>
Date: Wed, 11 Nov 2026 17:54:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: don't report OOM when a huge PMD race blocks a
 pfn insert
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261111140655.34281-1-farbere@amazon.com>
 <20261111140655.34281-3-farbere@amazon.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111140655.34281-3-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: k3qr5kuu3jnjwzuqrrek78qhbuupzik7
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 51E06A0003
X-Rspam-User: 
X-HE-Tag: 1794416052-733158
X-HE-Meta: U2FsdGVkX18WkKyc1i83MCSeHa9j4onF218RiEn+q9ZmlRWrjBn4nLaSFXbWSt1+usuznl0F9qYCxEfAbs7LyEf14ca+WWn2qg5Anb6Pq1P6/nKqJ8dRuXIPGiOUxaseIiMiOih5sHYJAs3J21+XPYrATCRmlfmfNnfTp5M66KXSgXAOEVaBmiXOPAxLufDYkSemxj/OocRLBGBwpXGaWPgXCj0QDc491wMDAJ9Sf2PCb/x75B38BaUT2fajNEpOF1I38xGboCbd7exnc8wxWAULzX9U+XaBuuFP0e9JM/as6JCegHTaEFtUuddTUpH/6vqQHGbMT7Ebd16OqKcn8U7TXfrANTafBgRShwJ/t2UPbADywlk9OBfoE84SCHkOD2hL5hs9WQ76HeEkTMrpiAr0uzXyEe58xVExw/w/98JWVN5blfYu0mFp5IvTfNdZEjFEBjcI+ukyXViy26QFqDx0nILrc6SqRvspWNN5Y+o8p/ZXtRA1ABPULmV2IB7oKwHA1F/Z/m0OPseQif3mJZkYpMZoVlzqZXXOJieYXyDopokG0Dok8taMXrsA9RT6TfGbIVhI2KONzBbQ++ONCf7m0YMzUb1hvUYDnKl6h4E6n6gDlZ+Wxg9eWiXbLKBcjvsTNfIUjCCf+oSSVBXzX/1wdF5O3Uzrcm/q413V3flKsGs82tI2QMJNw+q/4ckmWHZOyLWFT8hR7/QE3Hrp5Z1VEwQjRz5lWfWU1ha9xRPZdhtjyF/36QmNo+XiRXWLNzdcKRggXxsyJI5C3iWaRdf8eb0/KQFjCmGt5TbPWO+ih29W2vUv8TJaEo9ImdlN9gvLtcApLnzJ1578vDwNDxwaNA5HT5vjOMdcMV6+xlS/Mz2Cq9Mneqz+zGPZN/InJY0eQy/jFJtyAv7ohhVoGsgHbuoV44/Qdz8pc3TL8SZjj9cvFTc8zNXstEE29EDJVFrBCiC5c7XPvaiZuOz
 VNeUu13H
 FsaBWxOAAzi/BetCJm28Z0zGxYgo3Jx4tuDMgb1Qo+He2VHTtjVT5SqEwQTLKIS8O14cnZ+sf0iPFXpH22qiXimR6JA2tG2J0WCLyAQBkkb3x63jh+xPBA7KxsdAV0E4JOm5mg7rZcdok48xR0omT5AeJRKAV6JnE+CREW4Qf0N4SW8JDMc1zCXgB1C/dV6o8Xg+32oz8NdkCSAa+cFnHFzWH3RDQ2rfcbkuPT1VtUtIyivjhNrZjR/9mYH84crsoIKg73rlfXvnY4H39m6JGGWKoyMMGSd8a50StKljutxh47RheGAHQ4XBtUi5m7sbZIjGCQTc2ycPTt9bzorR49XMW5majdILex5pEICH4jE576XwCeS4bFtHFi0k1JfXBQXuwW17DRw6dMtve+8xcQJtrzqgUGpR5p3K/lEv1bLe5olGRBkkJYKsVI6l2kyzAoMU9U9vORxXtHZ06KfhvJxHgX5HHNms6Tzk4866qf9GV5SN6U3nyaM/h/zONi0StIVBa2ByBuF2aK6I74w/LbArrRJtax6T+vETd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 3:06 PM, Eliav Farber wrote:
> insert_pfn() maps the PTE with get_locked_pte() and treats a NULL return
> as an allocation failure. pte_offset_map_lock() also returns NULL when
> the PMD is a leaf, which a VM_PFNMAP mapping with both ->fault and
> ->huge_fault can hit: an order-0 fault that passed handle_pte_fault()'s
> pmd_none() check can reach insert_pfn() after a concurrent huge fault
> installed a PMD leaf over the same address. The task then takes a
> VM_FAULT_OOM for a mapping that is perfectly healthy. Changing an mm's
> THP policy while another thread faults the same PMD, for example with
> prctl(PR_SET_THP_DISABLE), is enough to produce the mixed orders.
> 
> Walk to the PMD first and tell the two cases apart: a failed PTE
> allocation stays VM_FAULT_OOM, while a PMD leaf returns VM_FAULT_NOPAGE
> so that the access refaults onto the huge entry.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> ---
>   mm/memory.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0f54ee0a6d88..b7b89d041f42 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2866,10 +2866,25 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   	struct mm_struct *mm = vma->vm_mm;
>   	pte_t *pte, entry;
>   	spinlock_t *ptl;
> +	pmd_t *pmd;
>   
> -	pte = get_locked_pte(mm, addr, &ptl);
> -	if (!pte)
> +	pmd = walk_to_pmd(mm, addr);
> +	if (!pmd)
> +		return VM_FAULT_OOM;
> +
> +	pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
> +	if (!pte) {
> +		/*
> +		 * A concurrent ->huge_fault may have installed a PMD leaf over
> +		 * addr, which pte_offset_map_lock() refuses to walk. The
> +		 * mapping is fine, so let the access refault instead of
> +		 * reporting a failed allocation.
> +		 */
> +		if (pmd_trans_huge(pmdp_get_lockless(pmd)))
> +			return VM_FAULT_NOPAGE;

we should split the allocation from the map, which removes the re-read 
and the leaf special case. something like:

	if (pte_alloc(mm, pmd))
                 return VM_FAULT_OOM;

         pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
         if (!pte)
                 return VM_FAULT_NOPAGE;

maybe could work better :)

>   		return VM_FAULT_OOM;
> +	}
> +
>   	entry = ptep_get(pte);
>   	if (!pte_none(entry)) {
>   		if (mkwrite) {


-- 
cheers,
jose a. p-a

