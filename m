Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4500FCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 13:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCDA6B0092; Thu, 14 May 2026 09:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E356B0093; Thu, 14 May 2026 09:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4776B0095; Thu, 14 May 2026 09:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 68B0D6B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:55:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E7A5A0196
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:55:23 +0000 (UTC)
X-FDA: 84766172526.29.6D41A46
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 559B71A0002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:55:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XXkbY33g;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778766921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqYGPZxgNRcYPxPA7WQ/pm4xhwUDd+98HNryuL77oaw=;
	b=gmjB/oSqwGyYWXuqRfwLi7ohR7+3XmvYDsWF9Ii/SQVjkEAzjgfjqjCGZXSujpSKSkN+zO
	PV9wm957gWuRXdQyqTdZqOdFQhPlMB6s3ZI4HbWoQd2Cj8MxNVOTZryK43CBaY8f/+CwHc
	TjoGviUm7j3bFi1P3xnvG+zbkuosslI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XXkbY33g;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778766921; a=rsa-sha256;
	cv=none;
	b=Ov9nJZjAcPUN8bWFztG4wM0HASOUrdeIraBKEgoNYku0S9C1VicT4kXTSDRlzwCPqfb+qw
	00raoS1XudiLJYymDT09g6L8jZZ47w0NBfpqBkQvXCwKNzTrar2tRMm1IRy1n2tRyaNYQS
	npE5c21tukWnNC//h0Sft8TU5u3P2f0=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9102e90bcbeso188253985a.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 06:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778766920; x=1779371720; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gqYGPZxgNRcYPxPA7WQ/pm4xhwUDd+98HNryuL77oaw=;
        b=XXkbY33gM9duvzHfaN1Vu63+WWJRJUjdHAffXlZyBWL9hpb43V9zoR1Cw1c110MogK
         lUenzX8dy8FHaC0OxQfbwkfawnjn8zMX3GSKbOU+0xuk1NBZwD4CpWjOnA7NSO+brcAM
         gckfydBwV+fjrWLif/+aTw2pOObY7U1fq+nEOhldKfH09wYh4D6jFEWEzXF2PksMZPGY
         3kImJQEo9vxbmOeOaUOIX7zlQiXIyF5gf0OHxkrG+TFUiRBejUd8b3Dghu6bw9IHUeux
         qhD0R9/ukLk6ca5y/UdJI0lZV31YEPcGM0TbIWpJIVkqA/OAmP3sPKdADsjjZig7pfJo
         PayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778766920; x=1779371720;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqYGPZxgNRcYPxPA7WQ/pm4xhwUDd+98HNryuL77oaw=;
        b=sZhCTrwnvmAb7WzrFmiaZ/1MfkNMD9ofvKq1D73tFigDO9s9J7L+QJc/P/rJHHcpDN
         SBrW/Vmdixw+57Yp1YehtcKX3efG7I5dcczhuqEreAi/a/CuPBXjOzlFGJP4IpBbWCgx
         4bFP4R6VwXNGeZSklLkHpDyv98xZirsFj6Sqv0t4u8b0b5Bgfh3RO9YaEpbG6H9f9zuu
         QRQSPlDqy5zWNT/YgWRTfXQwrCwcSVBETny8nyrOfOf/x0rw047M/wfY4S/2OQMN6c5f
         UhlQb7ItpVHf/bVlLxAN6t58LocP/MHkhYCfygF/oEqDk5TrXthmEKYbrSn1rOO1hpl+
         r/gQ==
X-Forwarded-Encrypted: i=1; AFNElJ9+CyswK9Nn5rRtrUr2Lp1ipaNCK1hduHxHlxAPYT426QFDxaz0LOohevz67yXIucwZ4aiG+UI4zg==@kvack.org
X-Gm-Message-State: AOJu0YyLq8GssQ0QIjWYXDGQ5RN3eJ4QEjs5ckh3cfy9xWYQnrrqOj75
	vBVkvhNqLokf3ZNZP3HKeCL4fYod+ZqNmoNn5POYnwZCaDfG38ezwnwO+iEg7DUZHx8=
X-Gm-Gg: Acq92OG0rViB0i/vEvQ1B0y+YC63LYy/QWj6Ild/MYtncN0nFc7JtMysXTJjpD69n6E
	wAOrPm3kx2VFhrUF0maJWuxXr5PSjaVqx+5/zkp1FK6uSJk6+W/WxHUtcdr6CiU2my2UDN/drV8
	9hrlvhXjfD2FXousWgecKXY5TbzmdcP8+TNRDd6ltgl/80YIDL/C/7mTCVw/NwCwL2FixF94fuY
	JgZ96EyXsS32Ftng+YhOde9VDvTG4eWajU+LCq+DxpgD2lYqIz9aeSO1FKt/E38Ob7FljexhbUe
	Vy082Mny2Td9hZ4MiOuJz2sJiI7hnXJqCCawGHQbuVkJ7yYBc5WLly1g+yWwR3fAsY41CKmj2FB
	Zx35oNY8pAGCy0SKJ6p0pYLpjZou77575kkPBRxMIMSRczZe7iNaPuLSdhrWc5IfSY4iqv+JCqd
	DAolElwAH0zI8Fpk6F11ve5pjN7xAhJEo2z+Dnu0jxjabvajMTpcCq/skl5APreTZZld/nvUaRu
	vnKDTTTfHi2
X-Received: by 2002:a05:620a:2a0c:b0:8cd:9033:1724 with SMTP id af79cd13be357-90f880ffccemr1218244185a.9.1778766920104;
        Thu, 14 May 2026 06:55:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910c0ec392bsm238411385a.41.2026.05.14.06.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:55:19 -0700 (PDT)
Date: Thu, 14 May 2026 09:55:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v7 15/31] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <agXURY4899YxaEXn@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <411a7b6a750c1904b99be92fad0e678ad791ca82.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <411a7b6a750c1904b99be92fad0e678ad791ca82.1778616612.git.mst@redhat.com>
X-Stat-Signature: hup7juqjyry6azbzd7s7ahdan5ygseia
X-Rspamd-Queue-Id: 559B71A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778766921-769767
X-HE-Meta: U2FsdGVkX19rpj+aqJM7b03+f+tjfK5Dj6eMRpg3PXAoAF7jV91TXQS4Powyvi/NyHSdeu2BRw/1N9ICkjO4jyWkZDzkAoX3ePN8CEH/cFADslZgY13/IGC/F7pXc9ZGz1syVj3H64gKV0i2u0zUkgVhnC547cpN5413W4AMnLiCMdalA/WIzAbDoaKMZykQZ04WT4Wy/WGZVff2uWEGYOJDM5iuTUWpzSS3XWuSDzTOOyrC4XxNo6eOAXtiM2D25ESFCVXSOrpg7KuLnmh0lljzk62fzEDG+Q/u2E/ZCDtNrV+uravuA6iBmpkGXqxBu42sRL1RBWwXoWIxIxltuuLFvnM5q/KsFwofqZFHyl6Xc2I4FbNmMmYMKMPVtOf1EIm7BPVgM36ek+rs/NI91T4uMkbzaJD3HaTijoVp/UQK6PqWLbQ7zxDoUAO1hhIdY1JC7XNGllH2HmFaHAoj1N9Ln/oH16DzikLnATTfoERt+PCDncQ2uFWc3xkgpGr8tBoxISCymVvw7QbxLeoVkGxc1X4duxVpgIrak41d5E333QfE2siCSU079MDOa/eXAHcZCxhGCgiCuk1Mj7PmRT9OqCDNYFQYIC6N7lUdSvicX/PbdV4pZoz3lcD+EAbhpow5WOYbsykIV65apOmFx2OW+LTeujXIKtOP4RmbYuGT4+K+COp/2Zc74hFMwjAd4cVbvDPzQIhYswgL1XhtE4SwRhkeJEA7Fy+P2F+5boLccKWK9F5swo6+YgnBhrmjsTad4jaLNUtJzCjMa1IyJM5a1aOEfYIpyYf1T47rofIZK7vjmMS7gGm1uBEPQKA9mmogkeYD3koGOgDguKmZKflRk/CVCLuUhtt0yccORWDcL44EIckc4O4O7tfdIH55xYVyLjF4pEqjZwuFlWelQIX4F2AahNfUc3MeNpbAQxz0p4DxVJB6b9NILSkl/Qgekeva9za3V+11TWfAXqC
 VRfkjfB5
 wFIz4NOx1r5yAWi14Nc+HWmHVP54A1Zd0FgZaGqi2N72omWQvRm7J54PBIe8KjprKnpmnGhGVw0R/JJetcIKXTBSBywqhd/3RvZ8trOnerKLoTl1wOPCQaO1LnfyTIRe8dTPLN6lD0nzn0NEk8M0s0ucWG1JMDY9kzjRkX0//Rgs/85VEO+19WdvMM5je2jJxE+zalzvIQ2Xi1MMYhpzaeE1Ac8ZGjvXrm59KIjvKZGarVS25ugq/4odD51PfCsJzo9rvAOjYrG5c9y8XKKEJM+VKkdKzx1txV465z+QVYeA+FIxz7MWiRcB4ppDij6DEaZhFRmHOn5dejbzzF6MQ4g1aZY1k2aDt5HzdjEfwu8uFr22GP0kMlk/CpzOI1bNT7EoICb0dQbi+4pJEEh9kpteduXA4AsQ0kgd0RR/I2jFfdZZqiozcGDz5Q/czLYF9oQRZxEoNvzHH+SLluGII0q2RlXO+KCr1HOXkqQmsVMn1DOcqXJqLyLDqJAHObk6H5hIwFH0F+dHq3QpKxgmApQbd3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:06:27PM -0400, Michael S. Tsirkin wrote:
> Now that vma_alloc_folio aligns the address internally, drop the
> redundant HPAGE_PMD_MASK alignment at the callsite.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..d689e6491ddb 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1337,7 +1337,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  	const int order = HPAGE_PMD_ORDER;
>  	struct folio *folio;
>  
> -	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
> +	folio = vma_alloc_folio(gfp, order, vma, addr);
>  
>  	if (unlikely(!folio)) {
>  		count_vm_event(THP_FAULT_FALLBACK);
> -- 
> MST
> 

