Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4A2CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787CA8E000F; Thu, 25 Sep 2025 06:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738178E0001; Thu, 25 Sep 2025 06:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600668E000F; Thu, 25 Sep 2025 06:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 495658E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:01:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20933160403
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:01:52 +0000 (UTC)
X-FDA: 83927331264.07.1EDC99F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id AC0BA100017
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:01:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ka4phyE9;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758794509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GYfmE+k0d5YWbdZiC8QhNj3hq9CWQkLFh7lpDQVQfE=;
	b=u69SRJcS7BhcSpbYrCgpRXj7FHJTAnGGsuJR1RAPSWAk+JM60MJouUTpmu3Optyyvge1h/
	in4f61gSmIJNgBsVXlfDB1wpMbGVTaajMY5+EdcAA8e9sgSxkaaeIQhPlLGxRv5qJV2rgr
	9bj70bM/2bMgiW4aONtlvInR1JiVny0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758794509; a=rsa-sha256;
	cv=none;
	b=M7KtE37tJqlJ258tvtgHYBH9MN8HoQL7Ent3lPhRDhZa61Uf1VMI7AZa3V5p0AlcYMSKGq
	fkiSuS4oqrv9juxrw30HlztVnFKq++UeKw1Mju3P4oiASj1YCT+tKhT/COwmS23FZTpexs
	uWBoiwqZ+Ya6KKcklLSpyxt7hg2ICGY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ka4phyE9;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758794509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8GYfmE+k0d5YWbdZiC8QhNj3hq9CWQkLFh7lpDQVQfE=;
	b=Ka4phyE9ekYRwz0gOkET1yr4t05rS0r8aUG013gQmqiF449x2+R6li1al8IqnYI+DSwbcS
	57w3RBogCya9+EZ0+TU/FNKeknHrgywv7O/RoAr7LqSCOOcv5teU/a2qeogf0IHrmjpsvY
	/qOpoHZdfgxXNhNZQWPEhJaY/Ke5fqk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-ibqqI5FoMamcWbjpKvkQfQ-1; Thu, 25 Sep 2025 06:01:42 -0400
X-MC-Unique: ibqqI5FoMamcWbjpKvkQfQ-1
X-Mimecast-MFC-AGG-ID: ibqqI5FoMamcWbjpKvkQfQ_1758794501
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso3931015e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758794501; x=1759399301;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8GYfmE+k0d5YWbdZiC8QhNj3hq9CWQkLFh7lpDQVQfE=;
        b=h0hXiW5vAZboUuU6IMQGLmxIgbpYurq+W1bQonvYzX+ErFA5pIlFbbT0NVD+ouyiRj
         Lv6MYTVBy6mB2Rhw5i3dLy95PTKgvkiHPM0SNKjVmb5bGYfvmgS4P8FYcgC/ULtw7/uH
         ZyPls36GzuKTjocdkuZNwYOZp8ptH1/qQhoMANk57mmjHiZF6JFIAABFtdmps9JgvBRN
         j+do3wQG+pY8xv9Y0vwA5ibul7lO3OdYCHjfGcjfh192t48taLrvE0aI7jLhV0gc2uNH
         a5UrDjjNstMMIbdyN53ft++ZZjh4FPuN2nNwMA/dZ6NKzZbTlfSnmKn3uM5A+fBKOMQT
         +wHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjSU3rqyPk/tHDal/Bv/8vhQqbn5Zt/TOK0EAzl6pD9EWZI6g6LVesvuItLbCd5C4vjlup3nWlyw==@kvack.org
X-Gm-Message-State: AOJu0YzS8RIs22x6AOb2j7+Jtk1k+NOXXw8wckJQF4Vz67RNxQEbz5wp
	b2mtd5wnaiZTi4a6m9GO2GKEL6xmfsYbQGgYjVMu9U6Y0f51n0YH3hbsVRH/EqWiA7GW5IPosVi
	+w3P1OEkn05kp9+wrTMDmBwFhDfMJusOk+Gl23aGumxvTT5VqOcIw
X-Gm-Gg: ASbGncuNM6+4267WcpwMRhi/6DOUu3gZ5xCmv1ZKsB3mbZctQOWJ0twFwAq2bd7wvVl
	ZeUUEse2CVnyCqnft7f5KBkbaxaCQOL8eSm7FyqeYq1skmBEkHRJKcseptLNcxl3cExncj4K2YT
	wYyVck6tBJI/EKxiUYqS3VAfSzA7WxFEBmf1+b2VzYg4V90c5sMQ8AgiHe87SGEv9/qrmv7N+F3
	owqs7nY8cirfoFsi9g+A0Ii8BsFJjA2IWiG3w9akXgN1l+8//I+x/qQ03Et6mE8Rzdg/yncPn9m
	NENcJeIDsoFum7Eb62e6dlLwHKCvuGgh/bIJ16JwsZL+SpIxU8Ni3r974zwKnX6W6AZG0eYdbfS
	KsWVVvIN4ifN0cub9jUYDhXz/wqP8oN9KuUg98uCOPi0+VdcQJWvGpDdC3l7Md+9obsdE
X-Received: by 2002:a05:600c:1d07:b0:45f:2805:91df with SMTP id 5b1f17b1804b1-46e329eb016mr27720775e9.20.1758794500349;
        Thu, 25 Sep 2025 03:01:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJBLgrscqxeUvK3zCTB81zQ03AZ8FMFwoE2WABAhafpLxL3o7HLyxi6RuvwKQYgGpl6h0/hw==
X-Received: by 2002:a05:600c:1d07:b0:45f:2805:91df with SMTP id 5b1f17b1804b1-46e329eb016mr27719935e9.20.1758794499610;
        Thu, 25 Sep 2025 03:01:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab48570sm68576145e9.16.2025.09.25.03.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:01:38 -0700 (PDT)
Message-ID: <b0bd326a-0ef6-4c72-ae25-3faff1fd6eb7@redhat.com>
Date: Thu, 25 Sep 2025 12:01:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 04/15] mm/huge_memory: implement device-private THP splitting
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
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
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-5-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250916122128.2098535-5-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vDvpnuD4juM31fSIhN1EyAit3M0mCRjIg6ukXzFF-gw_1758794501
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC0BA100017
X-Stat-Signature: 95xnzhn14wxciqzctz1iug9s7awtsaon
X-Rspam-User: 
X-HE-Tag: 1758794509-418559
X-HE-Meta: U2FsdGVkX19MIbb3E2BaJG1uWnJYDCeaAv4djETRK8SLt9JJNhN3UuWcYAtpTDIzf1UMrBXyOIR5z9cyUPNbhR54y9mzXqUcqnZeqnQQL6zFffLsg7KsDZ4H+ZYpUz3ow7NVMdPxVkPZb493IwXepnIt4SkRhllpdtZL7deZagfvI159O6lD55UfD+jytG/7y64tUzgEFAF8T6Rq8NmsOz6Wl3a6NyveN7OoscR9hBFnfsIzT90Ri44AH2bXE43VwQ5C4BjkNwcu/vGTOvjMxWXD9+QpZo5PCP+y0TnZ330Gi32kDJQ+MHbYXxavakcYnxNWVDNzOl8DpMGliVtMpfwapnafuVhO8b38drcCbr6Fn16dMAcbeXZmsoIvcwXiO8ma8wadlKr9EZ/x1jObKcufqEFCo6a/bHfkpKljs3gQkzvKlQvwQGf6O6coIpw/gSwHC85ehBieOPHK4rhO/jX9Auv3VsrKJe7KyCU0CTqEDpRH6u8xv9ieiMp9WlDDMR9Xsu7W0Syo+9WcpHnt00s+9TMCHmXF8zzAyUnKltxkl2g1C8f1y3sp20j4f38t9s5Ah9FGfbb8zIw9WL5hNiFMFnafz0X+R5wCUwndtrnjWsmMjdSxKJVy+ZsCLNpYkM9K7gIGrMd8ETIXSsZOS772nD1hNYZZt+EKB/oW1+Ob78YXirMn/M68C90C3HRoEhdmIWSjVLO540XhTJv56BbHwlgI9FT0zC1BWNyo1Kq6HMxJUAKf8o7cUbrrA8IuhpvzlOM1G4MKjKvdHyRBorm5Edn+ZiVkXv0ogUy18AigbHUfUCbGP+ewc2XczVVM9GqfEJx2MrzXPF1sAu1Eq5ZSAlmywHTnvSO5XBUhXnh1eVQE0j9vsKhdFIuAam+Pnmopqq6ZX+iMMiJuP6KvbxvYogAVOp72uynFk6AS6disy+/FWvP7oybQN29+byrgBZIop5gJ9ctTexNFUaT
 fnmyEeTz
 OpA85J3GRjzdH7/F7dJ/g4cp9Hz+WQRF/fcbNBGbi3wzvGPqjhhSevT8wB5NOfzi7mq4PbXBvjx3R71uWcg6KRPLVc8Cj9IZbDDOi/y+hoe53CrZWgIrrBBVRs/TB+K0c3zf8s0E6XzHYjEij/YIf6qrn79wpzkdjKaF5RsGC39g9BE8sPRLhIhlfNgVrfMR7Egcmj5EgonQ9gBsgE23obiVwyjAtM3f867vapz45dqAMpdQ3jARBEWBevdiHxKBfJ2UHlhly9vDpTKVZfzfwYEuu8DntkGpMN+AO+rEK2sNDIRESWq1hwzxqE4ahiNDUjrJl9OszpL2XnutfFmcHpIH0/ndKHy55dQdN7DBR2wtXGx6dKAlzV3W1FoTPdurko/O7reDURTHBrIHQzTDzKikFmBxXFi3j7RtiDw/23E81DxFh6YZhhaXnUBJ3Sw1Wc7Zo3zcD3ZkS6f2/Admz9ngRT++stJhyMFt+RoY4q8qVana3zlkajPEzr7mxp3sJBYp9bAiU51qLY+bpeU2wlP2tUri3G6Ue0vtmnrgHynnr7bNCScORZVyfJV8ks0Lk4n1Uj6+gCv4ezn2YHJzzJifkwNPSIlmym6ZoPBCFOOIXoNQIeYa1AJWNfKp0FjcPYNUizJwmhx3PRvSjtmuVdHookOSp4Kuo+/qYBu1LgynePX6RrqzQ0Q6txe+Vj7l8PcIgJMRNuqx5luDoKurOewT1S7XYdSXpk/sTXJ0+IWri5SzVCeJNXFGyAmKQflLUX3thwzM9MurITwxtAKQ6qeDgilgnFj4bq//3kqxncFH/4DpHa7FUYAarnEhyuYNb7xV33Z8TveCo6CQRbD52U3FIyvqAjk0Y2NoNJBnjidrA8pXtBpXdC17TnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.09.25 14:21, Balbir Singh wrote:
> Add support for splitting device-private THP folios, enabling fallback
> to smaller page sizes when large page allocation or migration fails.
> 
> Key changes:
> - split_huge_pmd(): Handle device-private PMD entries during splitting
> - Preserve RMAP_EXCLUSIVE semantics for anonymous exclusive folios
> - Skip RMP_USE_SHARED_ZEROPAGE for device-private entries as they
>    don't support shared zero page semantics
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> ---
>   mm/huge_memory.c | 138 +++++++++++++++++++++++++++++++++--------------
>   1 file changed, 98 insertions(+), 40 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 78166db72f4d..5291ee155a02 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2872,16 +2872,18 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   	struct page *page;
>   	pgtable_t pgtable;
>   	pmd_t old_pmd, _pmd;
> -	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
> -	bool anon_exclusive = false, dirty = false;
> +	bool soft_dirty, uffd_wp = false, young = false, write = false;
> +	bool anon_exclusive = false, dirty = false, present = false;
>   	unsigned long addr;
>   	pte_t *pte;
>   	int i;
> +	swp_entry_t swp_entry;

Not renaming this variable avoids a lot of churn below. So please keep 
it called "entry" in this patch.

-- 
Cheers

David / dhildenb


