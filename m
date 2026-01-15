Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A73D39010
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246186B0088; Thu, 15 Jan 2026 11:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F92C6B0089; Thu, 15 Jan 2026 11:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109086B008C; Thu, 15 Jan 2026 11:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00F5A6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:49:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A64821603CD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:49:51 +0000 (UTC)
X-FDA: 84334784982.13.B42AFDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E098214000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:49:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYrzVqfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768495789; a=rsa-sha256;
	cv=none;
	b=L1AnjxgNHTMd2Oj2a0CS3xuUX93c0E5Biay95QuvLmQIH+aPxxknyWtaV9YMz7EusRX8ax
	6WRv4vErhdczxfvo8cHPwBOYkq3cwnemaGbkIPwpiUEKhbt1rQk/CKITyNqbyJr6KgriHG
	xYeCS8Hap5c6DQs+pU4EipIpfNoBO+g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYrzVqfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768495789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANYD19zVm1JWh1JbyYi2C85kNMPGMA1rYPyjQ1oZb3U=;
	b=t294ytP9a23Taqi6VCij8tTVXewfmD5eMMjHyjmzMEW5uoOELCVKmN4iNEmResSuI7cVGz
	p1lk85/sF4RQ9bv/jh4YOw23zagKjORjN5N8b4dA8XvxqLDQq/JlwsXG7cxdOM6wJYuGZK
	ElcX8GACyVumbZoiWotASPB/W1EVsLs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47A9A60121;
	Thu, 15 Jan 2026 16:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4344C19421;
	Thu, 15 Jan 2026 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768495789;
	bh=IpZqoR5qAaoKI8w1KTi83tkryc1MfgEtvAY62yPtvPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HYrzVqfvqaeT4uBNVa/cbuS9BTam0Js1TKLqrPNiFk8aBczK7nXvKIHUpt65VkwCb
	 CDZV9rG2yPmFspuBOwY5N4n8g2rELHh2qDWBR+qX/76buwnVT9k8Y3Ni1NqZYxue+B
	 pYVDdGMSy9uLD6wepEFOLv3OWj2F3fkNWJmzR/KC08NmgYy3bw5ZFH/fIglxYcFE+A
	 lQ0mbp9V/1+faH5BEvM1YMdO6r42QX0S9XSQ6rBRohcUvFCBujKZQ/3rlfPGvaCZ7L
	 FIAwHMAqnawHANWDmMFFuYLPirZFywgHXtdfdiANmYCkMXoGEgnX1kc0Is/k7TbGpM
	 AKPmMLws8a5uQ==
Message-ID: <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
Date: Thu, 15 Jan 2026 17:49:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115144604.822702-11-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qw1dwnjhiyiai4w5953qe1rc49hy6fgo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E098214000B
X-HE-Tag: 1768495789-286371
X-HE-Meta: U2FsdGVkX1/bkj8HqR+GOrae9e3K3NQCD4mxaDtSInoLTWl1fhCI+kjabn2ldEmbdEqVzmYfPsAYQslf3c9ly0va0H0/65NuK5QuRhUyzH3rveWgHis5z0wc1ncMQ2SnQVHue85fGBzl6nQzVWmqkLfYnixzrZ6DujE5v9AtPhpyjiCkTv8ovEkPvpf2yw3j+XrB80fJRDNVJNQTF6hbda8hdiaZNL4VAtQogjU96ZeWhN5pKOl3KEH2DJCasDfrfzs1UmaxUGQwiMYMqafE+Hd0/5s7eb4mHKEjBxENYyJqHdQ225c5yGontS2rto3CxaZVbG8+tp3xA29sG8JIcjn9hbo55m62NXwy/6F8FjumbsI1xy+96IOOBu+DUxo3UK3Zy18/veOHuTjn2VwL0mgcRkEqk9HnoIR9aLb56uxxyYxQ9muHFSb+DTwrO5qCOvrf4kcIh1Gc2VyDU56mY2S6w4IgvTeHA1c4lYyfXApWjuA0Hsqm+sHTQ6+UVUcR94Iio+MYb10HjuxmdFJ3ecsYAGN1sIUqsIO964MuFQOIUtH2QpnpXnpVjf/wc1gCtHaZEhdwtFa0cl9fv2OzoEchuijeOGrnQCSuk2YmL0ioIkHvSulYTbTAK359nWMoOOFAatFO85AnBdasGnVk7Ei/JmLxDS/d4eWdZUgcUgUI1QHC2AzZu5i1F2GJeYg6uiuBFb8VTMk9mCLaYHzznS4m7Qpj0dCI5PLUukXxFzEOfZ75qZWixWoG5lUTGnQCtpBNUIxY8/Yf6OpIoo14xJT7K87z4lEXgdRZjA/fdHs6RIJ7grj8ecsSEDPMThm15H4AFF7gfQMkl6jWBAXg5DNq3uy05EqPFbxiQEqO9O/jP+iuMr0+ZVOo3nA2hyjnGP068SfEX2op6P0cGHIB3yQz7RJsD+sWYFPLtaYwMLueDyipT//lgprbxPslSV3IHB0oC8GGHt2268+0t7/
 klmP3r7m
 v8nSTBDqhxrAN5yoWr5gVpjiSIBv2GpytlwEhPgkxUS0msCDfpeyGzA/D5+hly5/EkJpjBBX4LZspHdcN64XWi/1pdtzk0HigNdiHPDHLtE7f2pznxDao9QR61vF0Z4fS/d8FovOiaNXWu0ioDa4R34HJTlrDulZeiduKZT3hw3GxxEP1vJQRMPE89Y3nvdvqcdH833oz96rMTBtu7dWUwiog1cIcgMa0ZD+qJ4ZIr+IPGs9qleLZWm/9u++utkcr78MuWMj73A5WDaf8PGULwpRABw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 15:45, Kiryl Shutsemau wrote:
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
> 
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
> 
> Allocate a single page of initialized tail struct pages per NUMA node
> per order in the vmemmap_tails[] array in pglist_data. All huge pages
> of that order on the node share this tail page, mapped read-only into
> their vmemmap. The head page remains unique per huge page.
> 
> This eliminates fake heads while maintaining the same memory savings,
> and simplifies compound_head() by removing fake head detection.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   include/linux/mmzone.h | 16 ++++++++++++++-
>   mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
>   mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
>   3 files changed, 93 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 322ed4c42cfc..2ee3eb610291 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -82,7 +82,11 @@
>    * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
>    * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>    */
> -#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> +#ifdef CONFIG_64BIT
> +#define MAX_FOLIO_ORDER		(34 - PAGE_SHIFT)
> +#else
> +#define MAX_FOLIO_ORDER		(30 - PAGE_SHIFT)
> +#endif

Where do these magic values stem from, and how do they related to the 
comment above that clearly spells out 16G vs. 1G ?


-- 
Cheers

David

