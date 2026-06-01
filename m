Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8903CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359EA6B0296; Mon,  1 Jun 2026 03:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B5F6B0297; Mon,  1 Jun 2026 03:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220396B0298; Mon,  1 Jun 2026 03:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155C16B0296
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:14:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D4FE16226A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:14:01 +0000 (UTC)
X-FDA: 84830479482.13.34C909D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 86E47C000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:13:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GikPScST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780298039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJvEmv+W0qDNB0rejgQapdJuH96Fa9lGuF//EYZmLLc=;
	b=BvTD5IyU22Yv1CQT1NxZ65bNNEB2CaM6undeQzGd3Fd5a20+uzxCq2pN/7+GvZGIg+nmtG
	kTK78Pzr32vG5IL/oRxpvYbGDwHR8BD6ExLDOnR3DBUKK2mlJcIIjc4RpMjG7gVLfjDxmS
	CG9lZu3bjbioxtkhlqJntWvvrt0uj7k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GikPScST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780298039; a=rsa-sha256;
	cv=none;
	b=7/Dwoz9oiLrbQhWEJkYGKv1hl5GBaI/vZ1vKsWLfEF8AXfSDdbjZJ6ySKg/yIF9b8m45Vs
	gKaFzw5H3hbPv47rfVI66Po0iRBbn3TXiQ7FtjMNBy8rYJnucc9JSeBYQ7coXHQEWWypMd
	Qe2lHmqhcG0RnmPB7BRTsTtiaVL48D4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED67E601E5;
	Mon,  1 Jun 2026 07:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EDD1F00898;
	Mon,  1 Jun 2026 07:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780298038;
	bh=uJvEmv+W0qDNB0rejgQapdJuH96Fa9lGuF//EYZmLLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GikPScST/JdGxywFRDULWNH7RT2OD7214GAe1g7QCDbKOyunBXFEScW2eXeSdFBPX
	 1nmcWK2mHQDwPeaDPZXRm/6Bvs/9e5PY0+uhi6uaM8IM3pMX3wxGR1mqYzxqKy9xXN
	 ae/gKZTG6FKLOXf0W8IqggTU5Qm1U2lkWpnzmJcCIPd/8GPvwIjoIPiMTQYXz9zgM3
	 OkrKoMuqeZLFrg+CgQybiH1dWrvfv/PMV20Px6ijnfJ2omnTN7SO/hCx0nccWkLV7p
	 Jf6WK823XOMgBj7INRW39n3G9pazy3NTIE1Ix6CtCLZRH0GMC/mD4oQdQtJZKDtell
	 zPk8/h+cl6k2Q==
Date: Mon, 1 Jun 2026 10:13:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] riscv: mm: Call mark_new_valid_map() after hotplugging
 vmemmap
Message-ID: <ah0xLeD1_6oRKDkx@kernel.org>
References: <20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86E47C000E
X-Stat-Signature: to8uwx5pa4af8asyoksr6zcb87c5d1f9
X-Rspam-User: 
X-HE-Tag: 1780298039-990960
X-HE-Meta: U2FsdGVkX18s1jE53cW5IjHajfSQQZhFh1yXt8cCW9DcsxGvdILgxrqnKkl7uXsr4a/Uij2+/kuBXgCwgXtzEpjpRV4yxQPygJsLDz8TgJhBnMA4J0BdbaDLCF/P3XFlI+TFoqMAZy3bvnB58rk24ZpbNvQK5bE4M6nZ970vKOK3WJrRBZHNt7xIK5PG+1NEdF0hknStwHpM+u+5daFyKc+wr6A+EaMykRB8yIkxAGl7k92QY4rd7mEfmy5D0qpZicNhW/BZljp4QcS7UiPIZYMvwuWcjcHrYphHlqGWgRxRs4obAN96lOuA5IfsJlmtpZlqxlBoByHsLddnnIDrLG1FGo2rfIp2I8iVwqouupKNEhYcAXRnMNw53rW/JTLJUZB1fExByGexigtJYxhLdtJJcigOANZhcaA81Vof6A+lfIyCN7Qdyr0UUFPBjiPOZsZNQQqTvgGJc1nQFDkQOKcWbvyEe3ItAEEMLkyfbC6GKahIbN//jQlfkqdBYDCwMZT9AghCg1XGkzLYd+jgKS2VVgwBfm+MrzGjDj3yoyEWvRkQbD93Nfb4ddqotpdNdGtEYc8ZhX2mzgbJuZ0pCrNeeEqGDYfOr+W5IYbnJKwvIGgjAtJdydH2V+ELTU+kkTqWx5OORTRNW7GO2WLh1cHvAUuH9QuRXU7kbSbN5vdxOJwqvyG95Saet9bzp7iS5JBJxKAHJHw/GzxO2bFxv0jSlEQSC3Nc0ctbHyXusvmu/iA0zw/Lxv0STIVLpMdbp5xc9Cj3WJ+Ri3AJ/+c0MLvFMqqVMtmYdEz+/5Rt8OSXphM/6osZarmOLLBA5q5OnF5zBL0JBKGQ503z3OvDsYr/AfZb4PCg5hE5SB99nHR+ROErnbbrQCEzzIAmVAhoNd1DcHcRkF9Y88iJ/GIbslMlUtas+D4yvHPX4mh/KH5kw5aBvrEb2rb51a8OLRytwpYAzyVVvyx7ivGv0wh
 ngeVicfJ
 77GY8K8VN1HAk84orv0COHoQdwowXlUjOQSfmz6vTUgzx4vMEja/dHZC+frzx46RqhoJ5NYDs0Ogjun2HOMgV8ZjnFr8TL7D7wKLGTwfBzxhBuDwiezTI7yH9BkB1GGfxhIoaJb0p/qUKkTiIyveVnxT9SlMDqHjm4WCvAVLcCBw30PDCdz2vW0XHsZ+jRENl0uGNpG8bADaodKlVpRQvxpG7TzbtYG5LxRsAGfX2Wlb9GiPr5FYsAwNcWTFybBd2bBOjCyOwn58p5lQ8ki2O1SghxoZxK6TiFmtT5gXRdHWqy+LFGWqYFqfwud07r7qG0RfWd6++GSDavCcbrv9D4+7xP6BaBbVIAAuY3282n35pStk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, May 25, 2026 at 12:23:29PM +0800, Vivian Wang wrote:
> section_activate() creates new mappings in the vmemmap range without
> flushing TLB, which may cause faults on some RISC-V implementations that
> cache non-present PTEs and crashes.
> 
> This seems to be most easily reproduced with DEBUG_VM=y and
> PAGE_POISONING=y, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
> 
> Add a hook vmemmap_populate_finalize() in __populate_section_memmap(),
> and implement it as calling mark_new_valid_map() on RISC-V, which
> arranges for the exception handler to deal with these faults if they
> happen.
> 
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---
> I'm not sure if this is the right place to add this hook. I didn't add
> it to vmemmap_populate because it doesn't seem to be called in all
> cases. Please advise.

Indeed it looks like we'd need a new hook to let architectures run
post-populate actions.

The explanation that says why a new hook is needed should be a part of the
changelog.
 
> Depends on my earlier kfence fixes for mark_new_valid_map() [1].
> 
> Found while testing AMD_HSA/ZONE_DEVICE on SpacemiT K3. Using
> ZONE_DEVICE requires another fix [2].
> 
> [1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn
> [2]: https://lore.kernel.org/linux-riscv/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn
> ---
>  arch/riscv/mm/init.c | 6 ++++++
>  include/linux/mm.h   | 1 +
>  mm/sparse-vmemmap.c  | 6 ++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 706f43523935..cf9ae4099f82 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1360,6 +1360,12 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  	 */
>  	return vmemmap_populate_hugepages(start, end, node, altmap);
>  }
> +
> +void __meminit vmemmap_populate_finalize(void)
> +{
> +	/* Avoid faults on cached non-present TLB entries. */
> +	mark_new_valid_map();
> +}
>  #endif
>  
>  #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0b776907152e..65deccbd7e31 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4882,6 +4882,7 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  			       int node, struct vmem_altmap *altmap);
>  int vmemmap_populate(unsigned long start, unsigned long end, int node,
>  		struct vmem_altmap *altmap);
> +void vmemmap_populate_finalize(void);
>  int vmemmap_populate_hvo(unsigned long start, unsigned long end,
>  			 unsigned int order, struct zone *zone,
>  			 unsigned long headsize);
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 6eadb9d116e4..2b860d2b1703 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -544,6 +544,10 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>  
>  #endif
>  
> +void __weak __meminit vmemmap_populate_finalize(void)
> +{
> +}
> +

The existing hooks in sparse-vmemmap use #ifdef <hook> rather than __weak
functions. Take a look at vmemmap_can_optimize() and
vmemmap_populate_compound_pages().

Let's keep it consistent.

>  struct page * __meminit __populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap)
> @@ -561,6 +565,8 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>  	else
>  		r = vmemmap_populate(start, end, nid, altmap);
>  
> +	vmemmap_populate_finalize();
> +
>  	if (r < 0)
>  		return NULL;
>  
> 
> ---
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9
> prerequisite-message-id: <20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn>
> prerequisite-patch-id: fdc42f2647e21d111f44a6532887a6705cd470a9
> prerequisite-patch-id: 096fa339c84c36643ae4311fd8362dc63e23d950
> prerequisite-patch-id: 305c876a5f4a23a840a8142aea79b796ed297545
> prerequisite-patch-id: d78cb55d6a616b1170f06a401c8fd44acd11e5d5
> prerequisite-patch-id: b02b4a76e94f3e2821291d4c23b46f6e5ecf5203
> 
> Best regards,
> --  
> Vivian Wang <wangruikang@iscas.ac.cn>
> 

-- 
Sincerely yours,
Mike.

