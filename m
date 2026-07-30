Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94211C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363226B0088; Thu, 30 Jul 2026 02:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313F56B008A; Thu, 30 Jul 2026 02:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202E16B008C; Thu, 30 Jul 2026 02:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDFC86B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:28:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A12B408FB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:28:42 +0000 (UTC)
X-FDA: 85044464484.27.491F374
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0BEF160008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:28:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=A6wnZ8UD;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785392920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYuSkRMlAL8RFmXTAhfpgmHH3OtvbWBlkpFHBuC4V6M=;
	b=Cr/qb0kx44Dy/V5QDBysdqq2iXiErudKfZUoQuXdXI6wrP5vKWljqj0ewFfhEmv4GyKpXt
	9qdRA97boJ7UToxCM6eNJTemXOFZxiEf8wKvzpCTuU3Ujp+vCGUBv85GZ0OCCkUS/0o3oF
	aMa327cY/Wmn1cJCJzUAeKK03AqtRXU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=A6wnZ8UD;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785392920;
	b=GekSOmiWkTm66OjdKqeoOEaHYVnE5YDXM56z+Gyu5VOzW3iMtVLNGUaIgs7kgrvC3MpcYs
	/6lJ99zCTbHsEO+m1aGqStJnp6nPdFX5CqupOfkSfwqgAbzLyuF9g/IfSJxdZx7Va7A5W9
	HvUBYi85Mg92/tIFhlfReUig4Z2AdgA=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e54f8c051so96606685a.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785392920; x=1785997720; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BYuSkRMlAL8RFmXTAhfpgmHH3OtvbWBlkpFHBuC4V6M=;
        b=A6wnZ8UDCdTjrCyi/cZfTvnMem7hRQq+wY1rQnSDopsdnrGhUFhy8G2OnDh4r/cCj8
         9RZrPmrMjwlcEXIi3UspvgAd4aqu28eD6yqTqaQdFSJPq9LVQc5HfSE4RiZid6TqKhRv
         OdsiHzwdnpupRootAirqSX3wShiHKF5IX+YaF1OomSyANqCYTC5We9OPKlmjESMmOR42
         axKsa5QBp7Wg8zBVa7sGYx5jRQrJ64lHxGxUFiZ5teK0OlxFY/etrATJ6KgpUowIzwwC
         c+fQ6yYmT/tdBZSEcpAFA8LteK1/OXfxC9vZRSnqNwj8CsFn9oEyVBeeNcTp1eRJR+5h
         CgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785392920; x=1785997720;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BYuSkRMlAL8RFmXTAhfpgmHH3OtvbWBlkpFHBuC4V6M=;
        b=drVMjuYMiNQ7WQ1ijlNs5K3SVUQxSbW9hp8PDrTyHzTeM1Rc/xCAs05SRa8Qmeo2MU
         iK6OFJdaxhAkLicSOJokxm90AJWOJTpefIJA6D3f4SixnVbkKG+WwZ1aGP4A4Ua1mLWE
         OZ3jQHXMiiaiTI5m0avW7hbgnwcFg5sJVmssXqsc5Uz3sRy6dvaLUKSsgrnuxhI9XO3Q
         M+B1XOuGFCMR5Wc9f9RNDzLI9OL5+KuY8+8+Y4vWEe+kp4C/mrcNi6PNfi8WDzcJ3kls
         4p+5ekJEBssrOznr/j/Vqdd2qPQC2xMhFSNvungxmo190ND4mWI3XnIRgNv5maXRyK+T
         +mSQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp2JBeHoa7AiXtekI4/yM8owO4+17cwwKsoKwNTx86a483vAr/tZaTemGa+aJYK4Ehy4xPIm67GHQ==@kvack.org
X-Gm-Message-State: AOJu0Yxs8EAbOVT2GWJNzVkW0RpiHurrcpeEmT+Pxwll0dvnkHUQZSXT
	+SyCLM6b7GJp/wM8OT+6Up9FAToKWjjlvjS9jzdJJWMTs75eYMC526Qh6hqKS6L2et4=
X-Gm-Gg: AR+sD118owMr1hxFgGREc13kuD+OR9PsGf5MGG2zq4dPuGTf50JChokOxE5COCAbHDZ
	NlvP3SjRnZ8ttRaENtJ88CI1lnpDILDUzFy9P06Fwgi80nB94oBB35irAQ9TU7D+tW18R+Uvb1Z
	HciYuQS0ZxjctrFy9Y4OL+ClwRGs6iTLSEUZENygZRSx7nI6JdRfysqGC/5kT5x+UXnjaj+Hxg7
	JqY+JBL1keJcjvnMdmDZk41mzLaK0zF93zsg/3l+y7zbKQ+3O3cYxDx2UZvMhBcV2LbHOeSST9Q
	lRarG5EV659beBh3t/Q2Rj3Rd0rHRp4Saa99hIEzXm82vzhVWVjd93d4ooE4/1G8IX/ujFwQepD
	kMlfqXzCXf/pLCdNHWkaut8CkKBLRYQUWkz6jdscq+KxVsH9NvTDVM2KxjgNBz9s0am4KqbHO+3
	sHLyvUFoVpFOZmi38KXWO2y21nzSdqg050Om5bLrwjtTWlTvWOzs6FLEnDsQqgbray0njyh7TEr
	Gz2ujW7DjSK2z2Dz1NQctvsBxdZq0TsjtH+ZtQhJRaDbboTE9VHLDQ=
X-Received: by 2002:a05:620a:252:b0:92e:fe10:3f02 with SMTP id af79cd13be357-9348613d64dmr94585385a.51.1785392919868;
        Wed, 29 Jul 2026 23:28:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933e7318180sm346275085a.28.2026.07.29.23.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:28:37 -0700 (PDT)
Date: Thu, 30 Jul 2026 02:28:35 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 02/15] mm: introduce linear_anon_page_index()
Message-ID: <amru_6sVmelONPh8@gourry-fedora-PF4VCD3F>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-2-e8ecfefea812@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-2-e8ecfefea812@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B0BEF160008
X-Stat-Signature: fik9bz7qd6w5d1ckn6nt4uizyqxtmspi
X-HE-Tag: 1785392920-144576
X-HE-Meta: U2FsdGVkX19datRVVwsuf/mrrTk30Qt3jeHWxq8gOouPxc+Bbbn40gdPkl8OP2+0yjXTyD6hTrZEVUbejZmW1XPCoD5Cy1gbVSrO93kcDuqUW4JOCd6KPnhLX6zY/1hiiPPlvHdm+LJvG/wZzo37KIk5v4h+r4dYSUEAE+x0NKih8vGVOPOrWVwAGPFZewcBe9RhvaypeuOMqiHTG8Yfpo5S07DF19xtl9afbES6g+xZJqQZ1x8k6sFd8cDbcbL2rxBJ1oKQu1WsM0XmIsodDa7cZzFyQVOfaAtlMtTrdn+2ZRHYbcS/GyW62jJrqZEiu/hgm1pQzOiC2iwMK57wXlzYkMNyv2c2A5wNaHixzwNPjuEjPZkNJFmKy1n1jOUg629ryFktRGmUE7ODhgyf9dwlmIGvCPpg3h1rnhBEtZkouJJibb8HBzwriOSAFSiqn6FWM4Cijh1ByscklahqdFaGDpSydtjeHgf5NryQR8KohKNNdFj2lu7JEEFHHowsDDEM5GA0A2fw/Ig/qstjmR3mRp2u6uS68l1DzlreBY2143JvL3gVnr1F2o+dL1XLMJYPUtmOBRxd0I30RrxpldeHhfIeq5ER6cy3SHyeOHDLodUi1wTvDC964xeTBtsqXk9pTbeod79/BPvurv1ktcl+8JpLNuM3MBgaOFQmzzn9vGCnOPFGeeTJdSDA1vsjrCNBtzey0HSn5ot0jLfW38kroyAVHqMvwgSOfkEMkBWJ/SYmzye+Bka5l56X2luhJ44kEWgi2PZsrMB+B241SoKppj8O7zYeXaqoA6ecVKbJQGHqN6ycsOncQltq8hlL0mpJZz0FHQwklrX8QnjKzJKRIxMT4RPUmiQieWmvEV/oDPRHaRKpqEYrrNmuWNN8/haEz56YMiusvWRzxAjpU/ZWi6L++yUqWRAW24A6RVYWDsuuqgUh15M/jrAVkcT7ogi/YZmmAESBw05YmFu
 Bk/R8cp1
 j8An5TrYTivnV0ompkU5Zqp+77fnjiv4xBzvoX8IcC+U1Q09tfdBfhjl7cEfToZNv/XBtjC9GOR3+3RnEsZoUNFnLigxyiACWphMHS4hICf+ugKHScoD1N3vesxwO6rVK1UlSFdy/HGksKuzJymwaUdso/Jq1x+P8qMhTvzS2AJubUCshBjiyOZvjDrwdCtNK+Jg+U1XW8hkg6V4ct7ZdhO/pKnwD8/gGPUoTYinPiIix+UYppw1/SwrxDF99QF7b7Ou83vttxr/m5QU5lbFAOh10vuwCg62IxJ8Hxg4cevBJ6hJ3sWqnXFj9+v4XSGgFpdsKoagpdNuykevgoni0fsXRM5yi/UXd35HCGX/CmBDbNZON24KaYYaaU5VFSMjaTs3Y8rkopFvLQbG2Huti9kmnr8XcTeBtaAil6aZxJ0jNXEjXBA5x1ZeezCftqoQvN9f78UAEewNHS9aDN0XZ46MSPiYCwFfKiHJUFM9ymB+vTJKEtm3Kx3WnXNbmjhzdn3DJFxMIo7jX/ToRKpe4WCCiNM269TCqVWSR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:48:37PM +0100, Lorenzo Stoakes (ARM) wrote:
> This function provides the anonymous equivalent of linear_page_index(),
> instead offsetting based on the anonymous page offset of the VMA.
> 
> It is valid only for anonymous or MAP_PRIVATE file-backed mappings. It must
> not be called for shared file-backed mappings.
> 
> For pure anon VMAs, this will be equal to linear_page_index().
> 
> Assert that both of these invariants are true In linear_anon_page_index()
> and implement the algorithm in __linear_anon_page_index().
> 
> Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
> but not fulfill this invariant, so when asserting this we check
> vma->vm_file to account for this.
> 
> We do not update callsites yet, so no functional change intended.
> 
> Also const-ify vma_is_anonymous() to make it compatible with the
> const-ified linear_anon_page_index().
> 
> VMA userland tests are also updated accordingly.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

