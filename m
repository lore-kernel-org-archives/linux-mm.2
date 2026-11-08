Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39CE606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NWhYI2ps
Received: by kanga.kvack.org (Postfix)
	id C92536B05B0; Sun,  8 Nov 2026 11:46:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BD76B05B1; Sun,  8 Nov 2026 11:46:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE43B6B05B2; Sun,  8 Nov 2026 11:46:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 889F96B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:46:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A403C04A4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:46:14 +0000 (UTC)
X-FDA: 85412529468.04.CDD9CC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65951180004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:46:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWhYI2ps;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794156372;
	b=znCM0IcxcS4F45t3zR0Sv6Ybo2vXwnuc/g4SIhYM4z1/CLk20SLvlkeRdyhDv3X3M97ews
	6VU6EGfwLeTEnQvtJyftsQlJGgQRf2ujdtFgWahBXdDuGsFYwUK/LR8/d3q7tsGsx4PTEz
	Si0SOnXJhpy19WsD2PP+hyyGC8sURQ8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWhYI2ps;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794156372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTpoKtd3vzCAsB1dOMCmLm3Zvf15E1/w6LHbWorVquo=;
	b=rjZxsot6og7oAlQ7QaLz5Q+AGPU90WdgYmnwlWliS3xUthPnHaiZSs+jcaZmJyayvFpPWG
	jc4Ev5JUDJG4Q9V2rfGQ1Spxk30A9l7CgdNP32XaKzwbWVK/0m4RVCSRPsbxAKbrbk7epI
	5eRm6AU9F1WPM+FmwQBE7zoArAXvZqo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CB1560A03;
	Sun,  8 Nov 2026 16:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93871F0089F;
	Sun,  8 Nov 2026 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794156371;
	bh=KTpoKtd3vzCAsB1dOMCmLm3Zvf15E1/w6LHbWorVquo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NWhYI2psVTCKqIZTsbwQtjzBFvbmwGZuvVNRCMiWmXne3KAdYAP6TMQ8kVVCDDw0z
	 1BFzQamYFbWzlaysWhiE0ke7fEJHwlGU4cLDrxRLS2uI1cwmzFKHFclV7SN2tDte9v
	 4V681jLFcelMdVrdEQdNM3qTOlAbiQo3Bh3xEp6jJhmwQ1PofLERefIkIHBBxkeH6S
	 XWbVnImzTDxTQhPLYaTjvh8D6LyMRlf52GUaA0swMFUPU9VNb45DrePqNaIz7Aw07S
	 uu/7N+XzRel7BwdEmU9Dl2vQBVN7yoQXd1VdzTtM58ojog/chB7vEi4X0th8O13kqf
	 NAJAHZCPx1TZw==
Date: Sun, 8 Nov 2026 16:46:09 +0000
From: Harry Yoo <harry@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Lance Yang <lance.yang@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] x86/mm: Tear down the direct map when memory hot add
 fails
Message-ID: <avCnM5AwhuvToFwP@minisforum>
References: <au_l5MRyDbYfsUVe@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au_l5MRyDbYfsUVe@chrisdown.name>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65951180004
X-Stat-Signature: z8pj7bcrhir5weu9acdaruced1i81qde
X-Rspam-User: 
X-HE-Tag: 1794156372-853241
X-HE-Meta: U2FsdGVkX1+OrSwb1q6iX5eXAXFZyl9EG6KhaiCgnOTkS9Y2EwP1UshDlV59WKevmxAu7ssi/NUgg/4ajmoYwwKagbFpImVCSg3H1WiPcd3FnOur4rNlKnFuwIP5KeechPYMKFc3M2plT3q2mcZo1mx71Ad3fLzUGifeMDY7UNASDNqhhAb1HgcPh6tZbjSgA94C3zA80fVhQy/biBT/MUNiZaH0U+mdWHWxEkgsimgWfbE8qspL0Z11QSc5Yzg/EwALAF3fwNLCr7dPqU7A5DaKXAYUOWVQwkLiK6dUJnHaWMtsH2UiEP5xvd02GxLTK0syJo9UmK7WfeVqVmpjd0tZTnZ6FwuhIehb1SI5EImRbCkZNMf6PCzhmmzl6iN3phIwkyLYfVRbxSii8rOJDXMXm44Eyss2pIDrQjQDjFwX80NB5Wo2Da9XA8GRfm4Pq6HFAFPA1fB1U+0hv1xTRwBAnMJsHIhhtRxy70GO6C+4ntFgyoh7YXgTqOyrBS/7UDuxnt/O4rtmC9aT6ecX3bSN0SvS/Yu6YQLA1Dl5ZQLMmweOL1CfC+pTxo1MWCyQ0Ms03gb+PHAlHvpzmiKW9VFmNGsTcRCnni79DMB9017tC7+aU8EnNvnEL3cgASMroBpbAd8VTQJWk2nHpweylJu0FCjbGK+RdAz5pgjrKFdBHXV6Ld0smMewnhZHICGMPo6dAG3nDVEDWyiTzTxrCcOKcTQ4lfk2gmMWWJfHW2N1U9sNedGp31J3sqZhIBH/HCtNwL/dRY5+DAjyJXVfC5UWRq8F6C4m1Fq51Gpi8sYGrcP7TwDji259ruVJwwY4FaD2oSOGYGdrUWbCmt9El9jjxjxKJltSYgk+UUtTD54X0AvgGvaFsn6EJfRkIIs1V1fNQHMg++UKXjfogfjdxTdpylfnZcUIiyqGETUNWfRtwMcrT6uAXIinEYUtop3mblG7hbPXN9YPIISbgT0
 mXsJ/6E1
 0We6JWFnPCBANhIcNR/aOK5Ci2SiLY3IaTyxluJDdMA68tVD/4mkNvZscVNsnqeiIhyXNTSsM/ozNFBdo7cU53qEvLl0uWNGX+wJvGi4OCzdgvnII9lW6uiGisJQOP1eq+GUTqFgCAwqblIRXPlnYuMEIkf8F+ZjrpBXygl4DEBQbZrdgZRUzuxaaiQRDzZy7W2650E9VUtrzDUxLtuIFrzOWmTtkg6zivCy/7OKrgNu4LcdQMOvDDl4D1FetV1vCpm3wt3lg0ypNDxXkIzCCdZV1yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 07:00:52PM -0800, Chris Down wrote:
> arch_add_memory() sets up the direct map before calling add_pages().
> If add_pages() fails, the range stays mapped and any page tables
> allocated for it are leaked. A later hot add can reuse the stale
> mapping.
> 
> Remove the direct mapping on failure.
> 
> Fixes: 45e0b78b0532 ("[PATCH] hot-add-mem x86_64: use CONFIG_MEMORY_HOTPLUG_RESERVE")
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---

Looks good to me,
Acked-by: Harry Yoo (Meta) <harry@kernel.org>

>  arch/x86/mm/init_64.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 8b6d86fb5a42..846cb34b38dd 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -989,15 +989,23 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
>  	return ret;
>  }
>  
> +static void __meminit kernel_physical_mapping_remove(unsigned long start,
> +						     unsigned long end);
> +
>  int arch_add_memory(int nid, u64 start, u64 size,
>  		    struct mhp_params *params)
>  {
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
> +	int ret;
>  
>  	init_memory_mapping(start, start + size, params->pgprot);
>  
> -	return add_pages(nid, start_pfn, nr_pages, params);
> +	ret = add_pages(nid, start_pfn, nr_pages, params);
> +	if (ret)
> +		kernel_physical_mapping_remove(start, start + size);
> +
> +	return ret;
>  }
>  
>  static void __meminit free_pagetable(struct page *page)
> 
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

-- 
Cheers,
Harry / Hyeonggon

