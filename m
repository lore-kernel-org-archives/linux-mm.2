Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 814EBC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391B96B008C; Fri,  4 Sep 2026 13:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369696B0092; Fri,  4 Sep 2026 13:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FDE6B0095; Fri,  4 Sep 2026 13:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA40B6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:23:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57FE9140186
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:23:40 +0000 (UTC)
X-FDA: 85176751800.20.1DFAF61
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88F06180002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:23:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W0CKor+O;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788542618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCVI76HnM719qm2pNvwAM4j/ewQptWjm8pfKFuUJMF4=;
	b=zMrlR42VJ3H39J9C4fSP3CecquxJRGBZHgEh/a8Ss2MPbfpzVQO5PNa9koPf35MpOXtpb6
	lIreLGxu/3sgMyaICBf3l13rvKDrkCuve0Ch87azP/KHXZaTxUSH/8mGttrIMvvTxjauw/
	ej7AcdIRE5BJIvyx063+1BVcOcYca78=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788542618;
	b=XfXNZnvpknq+q5J1enRJFvgjNzNFuiiDVH2WCyIttT5ozaegRRrAM6bgetAIIStaxh0zZp
	PoeYwqvAE5WOK3eSwnC/VdRZF67WFhFKnUvu019MT3XGkbYkdSVHTiggDdACSFdwSNd/2C
	1YRupeqJgxDbxonRL5LMKv/7ZKK8bDI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W0CKor+O;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4ab70b882c5so1062580b6e.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 10:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788542617; x=1789147417; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YCVI76HnM719qm2pNvwAM4j/ewQptWjm8pfKFuUJMF4=;
        b=W0CKor+OpNbVeT7yhERWId1GCZtlUxSnpB5q9CEnYxRckrrb/B1nkA2+cnJBI27ID8
         WmEuAZkuMAcr9uI9NzZ9H8r3sG2SdnEcO+yd+FVcmGfgK4pqjjEMZc9t5CGJklF9IqGR
         ItJg/9xwBbQGLHn68x3ouLcoc6Q78+E5wviNr2tPIJ3TxL/FmSMLH2ZXcHkh6tGc8iu3
         kiLPZ8hjcOun3pVk8gk4n4rxsk1qGs9JsWYGnbFktosnPTDRbZ23yMmH/9FCSazNOKHv
         s0n5my29sj+xOVI5gOKwrO26+skzxps/vI8jy+vl71rzscHD5wGSSQtcQX+DhTnP6Doy
         gFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788542617; x=1789147417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YCVI76HnM719qm2pNvwAM4j/ewQptWjm8pfKFuUJMF4=;
        b=bilkwptJxXgD7/pIwqe8p+k9aE+YCTreDlioOCZMXdtt51dFgrJsMp2TM7NBUBiKJX
         vjwdwNIeLLEEFoSMaLFrhTBFDsddmA1VpjqtW6Jcpn4tCwfOfluDBF6lkyKS03KeniUT
         jM+7uq228M77t1rwpQ/Vfp+O5g+D0UdDngF+URB4vOG8zaaNv6Dxid8CvksWQVAgnLgU
         fbyQRIapfbvw87lGG41KoCHUGVlbnqc5p8s9bgR86UDNHUsG5PVOG9AvOkrjWmT8zpIa
         mR4l/fSbG7TG2/NnStqsH8WQBzwfDk1FGvkiCr8pEt3KbK0QHTlmUFgvfXpbCUeppbSt
         g66w==
X-Forwarded-Encrypted: i=1; AKwUvBzRIL+KIgUyLnsC04gaz/fCHcOre5zIYwxhUbSeDCX3K9XFMHNguU3wNuhlCORzp5v8Xus5OLIDNQ==@kvack.org
X-Gm-Message-State: AFuF++l5PbZ0aH/BBph5jQDcoSamXrp0PeV90dqBVW6nNgQGM5wHFcpF
	L7TVMJXhRluujwG1BshS71sK4vVeRDDhiiLwtVXzu/Dk64Iy6FMSvkGO
X-Gm-Gg: AYBFou3b8VKZUvJsgZX3CFFE1fViXGPUHwK48GJai3s0gfIqlB89F03tunKv6ngxAFj
	ksirIqrOorjSaYjkS6sbWNxSkatsuxTCdvlhm/WDIjomejveAIoSa9vWbYgshS5jCuRJzW5jj67
	LjvO/5Tu3rY6ILPLhPs5DOcJg6YLp+/8AG/Bn5Tco9O+Y/2csq0CDBIE2Wv8PeaUCdsBG8K8Qok
	qgGKdFhKBafjNe7d07Kc4UqX5Hp94ZnmcS7tJJeSz3UTwaWueVfG8vQA1al2+5vf/iivbJa2Fkm
	2SsvmAOMknnXPb1Izf/YXeHcbcNVYNYE6hrgOe7U6zQg0seomso1efk0nt2+pFqgLQ/IEr91N8L
	x9Xd/QzI5flH4SPl8UV9ymEfeAzgadGjUV8GZA9iIXB45y/ITe65WRcGZDusPerdI+bKVTVkq/V
	7JwLsKtE/M80nHF33IotI8xEbmYgPHPpPS22q/XE0GHq351Yo8aX/W/kwH1NFw6qU3hcIhAtxkx
	4QizGbHaqqU6qG8KdM=
X-Received: by 2002:a05:6820:1c87:b0:6b6:d4c1:be22 with SMTP id 006d021491bc7-6b6fb0ddb89mr5397329eaf.13.1788542616324;
        Fri, 04 Sep 2026 10:23:36 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:24::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b6dc6aca49sm3331420eaf.6.2026.09.04.10.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 10:23:36 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	jthoughton@google.com,
	fvdl@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: hugetlb: Drop refcount before freeing on memcg charge failure
Date: Fri,  4 Sep 2026 10:23:33 -0700
Message-ID: <20260904172334.322019-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-2-e3e8942c141b@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t6apu9ydzm7ta8gbs956o7q8smt39pe8
X-Rspamd-Queue-Id: 88F06180002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788542618-165404
X-HE-Meta: U2FsdGVkX1+A3SLWQacgp5I3GUvQ1MCg69z6U+s7ctkdPWFhr8IMb65U/S+Of/dZ5mNfKAMp/5vDTvGpEp1WN6WlCceTmqz0YviZZgJvfvp0cQSKM6z3DcBDM2o62hXL9tQUX+DYux61BIZUxGF37X4ZXyN8KhmFLR/0VFCboy1zR/v00u1tbVY9lYzOHHD27gGD2ePUrhDRIoybZ079mIelOcCiST4NSDjGW93W6SUO3uh0aNlpCWnGLj0VDx2kIAlOfudT81Bo13jmQoIcLXKUJ0j3CMIzqm6WE+1z1GSlFo91tdkYpEnPb9XXP9GGzkmklxOpwoc/h28jfWPmkf5iCZVoKL38l2kDUn+fnoED0ZUuon5AEmpS7Nj9xvXJ7GPt32ofE0cGkdBa+4rWsHqNMBYpSF7fggSAi0kN32ZuOZjRzjp6NXVpNQ+tzOTeafwD0mh2XJ1ZbFEblR3d3ZBlp2mSI5Oa0eEam0Z/xnd7w/NsOXCDqp36eqp+gOfRELTXw7DLU+aItmqELXbPBvKPIt0OtLRdsC95TfaI115YOPpSz2/sL42l/jAWk6pjMMs/Cibs1YDMq0zKOiO99BRbsSgrVaq9kDpNuts6MG6z3aOcTwxPXIqrPkXsaVU6W06r8U+/0GPYeQ7fMbG9IdwGmh9IvsYAb+jZQdNbOiX77GrpFqKy7RLLKiUJdpuRnB9jyoAB49khCu5rEhiOZ/fZLBuiARfCVYAzyx5H6KGVHOt6QUWBUV96AxHItl+zgZcCX5g4xdQlJVxKC7ZcfwhiNyomUx1K/m4hzwDn5JrOar87Vz6XhMZ4ZAaiR3Fuwdg2xSFG1Ot9ApNaOmBhgetQpZN5ba+C/W25HMtqUB44bHXfvlqZacXGUlA/51XJ5sJUTNnN4X27Wc1qbQzeeLbZFTYXMOEYv/vxmkT71XocrlFgLMBcLbXs400fF3msEDveraGzYTFDymd6kzc
 YiUCpmpD
 q1WhiAO7NqPlB+Y+qOj/RwcRxaJCyHfZP74rM6SAE4MbQMAiGAN/gBkXCoFQ9seErh87ku+v7Z4T/ZMkznCAN8kHDz2prO78AKgA/slR6SMpCeWKTzDcHmGdHLGqwP+TJy1GbSbl85n81bqMRD+Exk6V7vsrLuS8qfm2t+214a+x69PWI1Z0bCXaNVKKpqByQ5Zl4FTu7WZwOwYpFHVtlTa0RWf2GsjjWX99+fJnwyTeWTn68WtEWXcZNBhMoB4llTZpzJ4woX/pT4KygMfxFIYdCcssYUHKiVB07foEc5uDLop3U3gYXuvSNZ3w7KA95dvR+xRcljP9svkoMgVngzxBCqxGjKF3E5r0CZh7I/tKkWML316UIS4GMVyvVomkWTzkLi++in6a0Zzw9WuEHLFqWF+LdRBesXQR4hHOsBQsarC6m/geHIU2+iD2uGlY5mfTibRISIfwYv8TO4a7r9OXddEkDg34dYe7icvfZlkOZgMyZIoR+iyYWc+LzlMAsD3wZb13ofMDUcLDsXYnDq0RewLMgqSovvLbt3gI9ygH12jEbl1BGWiHM9BrWMWvxzOU2K0QSqX0PBTD55IbmMvkpRLARDeXvjnarljixOjNXkpoIHNKRGegktZQfvVbbsm1xuBRor6tQT/mDjIk/7r4N6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 01:22:57 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
> its refcount set to 1 via folio_ref_unfreeze(folio, 1).
> 
> The error path calls free_huge_folio(folio) directly, which expects a
> refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
> triggered.
> 
> Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
> the freelist can corrupt allocator state later.
> 
> Use folio_put(folio) instead of free_huge_folio(folio) to properly drop the
> reference before freeing it.

LGTM, thank you Ackerley!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  mm/hugetlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 01b57f6d3b804..97c06f227ef8a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2889,7 +2889,7 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
>  	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
>  
>  	if (ret == -ENOMEM) {
> -		free_huge_folio(folio);
> +		folio_put(folio);
>  		/*
>  		 * Skip uncharging hugetlb_cgroup since the charges
>  		 * were committed to the folio and freeing the folio
> 
> -- 
> 2.55.0.970.g62bdec98f9-goog

