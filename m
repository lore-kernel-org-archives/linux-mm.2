Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B9ED5E136
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A2F6B0089; Tue, 16 Dec 2025 06:57:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107F16B008C; Tue, 16 Dec 2025 06:57:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F776B0092; Tue, 16 Dec 2025 06:57:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1F3B6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:57:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82B9EC05E7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:57:29 +0000 (UTC)
X-FDA: 84225184218.07.695B3E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3E1918000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:57:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=levK1FBG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765886247; a=rsa-sha256;
	cv=none;
	b=3ATR5c9NsG1arNkk6UDDZIVI5MWZe+PW3OI7b9RTrO0MuVWz4BOL90EIHzo4bRWWN8F4y0
	VrLxUCsWvabFMrhQq8+skDkS9r2SE7GoYCu2xayXYbRpXKw4erTP5On+glAfn43rwKmRF1
	iV/rAfPXZDvt8KNTJuRDtZt3BgqMWFA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=levK1FBG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765886247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EO58j438GWnjkv3vbMcJ669DRDtPdBQzG5P7oj/6KS8=;
	b=m2F0Me61mQH0HO6jvhDWfnJ5Yy3CWJN2X4u101EweG+yiBPp3oyND2aMvFJx9W1QsoRDP/
	KS0I2JgRM2XHnEp76bOOgZfS3dbzm2PX+++aBMY0bz64k8RNRamVFWOZAFBrmUkhFYk0br
	iaRJtVFfPo4VXBg8mRflvcwl+wdO24I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 202A0602C8;
	Tue, 16 Dec 2025 11:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FCAC4CEF1;
	Tue, 16 Dec 2025 11:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765886246;
	bh=7ZFdnmw31SZNpKwCbTn3VwLXjfFQMOPztHlF9Mj4Qrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=levK1FBGpysdmLQOMdTo0qNcTtB0s7RX0y4zTPIEcUboIVYrPZOuGFhUa6bo1W/fU
	 Pkek4dlakV/QjzQcJYVYOoV/eRv457Rq1NkDVdejTSJwEFwt+UxkCc1PWpnmJO80LY
	 OL/lhVJqjN+0W60eOuJJgkdiDtXm+r/RhggI5M/bwpZsNd03GHw3XpSEsQwOWig4A3
	 gBVT33D3IxuFbVGr9FbnmTvRhBd1ELZKiTNHPGscDsPTuppGV24iZQyq64K8sk0rYj
	 SIdtnuzpZ8U/M8KggrJqRCjAmPMIXZl7O824bvxFkO6Vj/GpuSPgGhJSrKDsxcmuzD
	 JbumRAVzfWYHg==
Date: Tue, 16 Dec 2025 13:57:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aUFJH9xzJXYOt_X8@kernel.org>
References: <20251216084913.86342-1-epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216084913.86342-1-epetron@amazon.de>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3E1918000B
X-Stat-Signature: iu34kmtqaygg57h68gqu6n4qjhhf5y43
X-Rspam-User: 
X-HE-Tag: 1765886247-740184
X-HE-Meta: U2FsdGVkX195Go/3VLL5MqcSYaFuUzszXxjEjYMUjwWhvydsVmBfTY7PS1CDaOr50EHE+ZK3IxfpUL2nyl4aLJ/OX3x+iLzLHwL7R4gTHRFSjKK4QJG5HLkYxPFAvylg12sZZ8ZXWqRtVeufokq9n8Na9qKzdpMZHD+Hs6xuCdnyCCwpYDZT6pC8dtE8Ej76kLm8lbmHgChj4mAvn4qQpqTipUvEBpcqfKHvkcjec5ZR64939MpjTNNha6n0zI2hxKqbb2VLKIGgdGK8a2hDlasaVOAlDhnllrbDIgyb0474gymngzzJkoPXeB6IkqsdgwbuypplwNl9qWd6yBpaYj39BaHBdD8InLsYd9wK9QdvHqd0B+0n9YFsXHREhwLyH6Twuq5bkrmogA1HCpQMHQWq7cEa7WdNoiNFqJ2QMH0N/kK+xUgUABoVt2wtcTuPs19uPriMKRSaDfut2z0jSeIoHdQCmk3yBZdhC0dXRb4REL4pEYosoZYoVS+CVIkm9y7t91imstEB+pokjVHQCLBcLHXxJHm72CtBNrE/8/kQryD9wLPquWw0ZSKzu/QRwPhjYoTLwlf9vIe/6Hj4lKbxmWX3cPR4EGoVls9B84xQTbxKwKBvWSXkAdMwlDkLavjeaKAa4D1c6VVULBRh4nwBpt5e55vx8OpEWyhFMoujZtpWygvubr0l20vzEFmC7vdR15aXgmFJ0HGJ+vBYxubCfiFwkKDK3nYa0DlhzQMH1z63ocKIuTKdLmngRBrHiH3s3UuKhlrp4j4fFYw8ZCS4r24o8LDiKszChXfv0JceS6Jn43EJAa7OYA2U5eZ04nvU99Yt+/9SEGBXfdLDGuhNnY3QAguc2BKk1JIzKzsESNsHPXzDwdHxRXuBcwHyhN/yq4pQbv4+7ezg9NZVPhwB3OENHOc4maFe4X1K76mjcESsy4Ec4ytMYOFr7osjeDmrzuu3aBNJh/4Zy+b
 8hCBq/8S
 xNkGl7iFhIKt1VqeWHn7qyU0kiu0IYBxTjCXu7eGrjX5I8enZA6kcP+UyjEql82mj8ZhjwqDbzHsj3ZhV1fDPZiSvbCMtVvN/HcRsADHqFC5jMlgzCZVJh1NMaC+qLKIRkQJiw8dPUDcvaauUpqvy01lpY69HCwGpCrUWJvUg5sWRq7TiR4COan5F35XGc8Dbjww5TNSe2Pf4ltJP2Y6RuiH11ejU+pLICjh6M5MoLbatZm0V+re7mxDmTm6re4mdv1fm0gNEZBzkQVJdNudQIErLog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Evangelos,

On Tue, Dec 16, 2025 at 08:49:12AM +0000, Evangelos Petrongonas wrote:
> When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page

No need for markup formatting in the changelog.

> initialization is deferred to parallel kthreads that run later
> in the boot process.
> 
> During KHO restoration, `deserialize_bitmap()` writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> ```
> BUG: unable to handle page fault for address: ...
> ```
> 
> Fix this by introducing `kho_get_preserved_page()`,  which ensures
> all struct pages in a preserved region are initialized by calling
> `init_deferred_page()` which is a no-op when deferred init is disabled
> or when the struct page is already initialized.
> 
> Fixes: 8b66ed2c3f42 ("kho: mm: don't allow deferred struct page with KHO")
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---

...

> +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> +						  unsigned int order)
> +{
> +	unsigned long pfn = PHYS_PFN(phys);
> +	int nid = early_pfn_to_nid(pfn);
> +
> +	for (int i = 0; i < (1 << order); i++)
> +		init_deferred_page(pfn + i, nid);

This will skip pages below node->first_deferred_pfn, we need to use
__init_page_from_nid() here.

> +
> +	return pfn_to_page(pfn);
> +}
> +
>  static void __init deserialize_bitmap(unsigned int order,
>  				      struct khoser_mem_bitmap_ptr *elm)
>  {
> @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
>  		int sz = 1 << (order + PAGE_SHIFT);
>  		phys_addr_t phys =
>  			elm->phys_start + (bit << (order + PAGE_SHIFT));
> -		struct page *page = phys_to_page(phys);
> +		struct page *page = kho_get_preserved_page(phys, order);

I think it's better to initialize deferred struct pages later in
kho_restore_page. deserialize_bitmap() runs before SMP and it already does
heavy lifting of memblock_reserve()s. Delaying struct page initialization
until restore makes it at least run in parallel with other initialization
tasks.

I started to work on this just before plumbers and I have something
untested here:

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/deferred-page/v0.1

>  		union kho_page_info info;
>  
>  		memblock_reserve(phys, sz);
> -- 
> 2.43.0
> 
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
> 

-- 
Sincerely yours,
Mike.

