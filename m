Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77E9F459F7
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 18:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051D26B0089; Fri, 10 Apr 2026 14:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D546B008A; Fri, 10 Apr 2026 14:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BCE6B0092; Fri, 10 Apr 2026 14:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD41F6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:10:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 766831A0622
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:10:32 +0000 (UTC)
X-FDA: 84643436304.23.3928A51
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2EB0718000C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:10:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nuw8MoyM;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775844630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=802oF/H6a+B4lDmycprkM+qCP7smCI+z0EEXR6Ni5Oo=;
	b=YqkhzXWMxKG3QebwQjWaAc9qtW1GIpu5v8UBoIpMCl9d/EXD6CeZeLaxzHKESPJJkP7SAI
	Tr06vkb6dkfOJTkzdYppQreApTgMEhtPTL/h7j81asD+jJs/ttqoYmEdIRc+YO/thTVj0U
	pYaBXu8WxqV1HBLPvIJ24kT+gCDxdGU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nuw8MoyM;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775844630; a=rsa-sha256;
	cv=none;
	b=4O+v0t9X1WG10//7lh0zMqJGRqJF0eCCSWSPY+8c8iPJQRVHEfP6nmyteBM7qg2geVM8kM
	M44jhRtnNWYH9MU/mBl7S2Ul7TPDFBYTONzCO+WQmJO7eUo6QUpT6Bo7UGwJVTqhFE/tGd
	rHgUdaVC+0pUzCn5qiD0l+3SE7lR1zo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06FC347E0;
	Fri, 10 Apr 2026 11:10:23 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21F203F632;
	Fri, 10 Apr 2026 11:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775844628; bh=+Xbj23Mi6qAaExaiR0u97sstQzaeHen25NLGeWwaLoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nuw8MoyM8SAW6vRkNF6p3aAK211yehk3V3tPN2NP5D36DfkVdOl+OZT5ogkGLDIQE
	 USK4yLGGYX428oeGpi2j7Bh/lvd5jFP3A9ZKj1kIcfkWqjjfLFwpXmyrXZORrwBp4n
	 Ax9kj27V5KCovEAIVO5YSw09ax1F9edXQrUs1OcA=
Date: Fri, 10 Apr 2026 19:10:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>, Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 1/3] vmalloc: add __GFP_SKIP_KASAN support
Message-ID: <adk9DjVvKDDAH2Pt@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-2-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260324132631.482520-2-usama.anjum@arm.com>
X-Rspamd-Queue-Id: 2EB0718000C
X-Stat-Signature: fo1htoa73oeurfy6dxpgdwdu9k57cbre
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775844629-428861
X-HE-Meta: U2FsdGVkX18K0bjCLAne0dWEZokxO3yiybUXi3j54kp1GJVzM+tQYP4zaKyig87CiRDbdxluuSMU+PNb+AF0uebOtX4DOrO/Fu6VcfFUMFIETlDn4MgltWKVoPxklU286q6aZZp2iiCVi4rlczTD0+4VyILhoU1QhS/UgOOOvxVGdYHSu17Adz7UnT1ixaxZ2a+6fDrCnqCLlPBL3k4fxHVhm/lAXmo60bxkkICX68GtrWmwFky5ZlWB0E5A7iKd0ZSGcLCVUUrA4XGahJ/dSxYD5AZ+6iEyOfuN1MIBS8oJhOwPhI889WE/6idoLO9OOP3NpwcAnyfMMuthPViES3jadMFgfcgh0OxzJCcG9v+0Fi/P5nQT/O8G0ENoY3fUdJjDXgcdq9RjIjjsxpfnYgdwo+9GghoN3RkFmo+xV/2SVeDSOh1UQcH9UHkCk7ULprgf8D+xgYeBF66roxIj8lrjqu8OlJ+Or5mp/5xHb37sG9MOFrvEJvzZU0nYN4kd4+oHwQQPmLwEpWNatpVPwixqjTfV2ZhrE8Zz3pZBHt3CeQTp1BQhX62K/PDRfZHZFaIDY3RGWMFKuQLgOdO9sqCKd7ZZs3LmF5qdA6dNqdVXKgj4qISvciXSPkoGfI6roH48sKAwH1GOlMCnJuZqH8ESXpbkF9tNQvTvG+GSkliP6FQxUji2VtXWby/a/p1pHqNl+xVWD6gNqhpOGngY/95bMA4dl7247BjfHbT6/4Uju0H5sBPif/a3Poup7Z8lEv2od5Fp1cuLFhVJQUztFArlkda3QZ5SQBzW9Z2iFUQxLrO1pfD98umg166v43BVzxFPkniLFKRI0tDrH2lF1vKDCDN1v6aQuiaUdkcyKTXD1DswnwQ1FWFLyZeAPK9X1OdjsoQIU1UrN7+yT3VpZbs1DiPAwtaqrx8OGbjmifwJYJKxeelMHVuqcsrZfMnf/nBnqVircrbh7dwtMVi
 SIti253l
 a/dnU8qiFUk2lvqpNL0K490aEmXAhyIpg8CRMm6EPT9j9atw+HGJ0BVPjKe5NDWL7l7LHmvp7rrVNWq5/pO09TDRK1793Tsn8T/xSB3uS1Yenqk3YcJ07SeM2keJSvqfYmKeMpCWzsIEZioyekQJgQ/eciyRBpic9eOar661F5ncAOiBjrE8VmR8kaZewCKZ1i53mU57VgMkiYeBRDd5Dcmd8O+Ec2SllbaZ7O8AoT5uAPLY0H2D+NKXHRYSP898J3j1wTnCO3LEMhlZd8vddnJsqxaMK4S363lq6ItqIEGoXDGAl30vvBllXAzAMJzzF1nowzWOKk9WfRFG6vnOxtd7GYxwXIZB2ECq62+i1sIE0dHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:26:27PM +0000, Muhammad Usama Anjum wrote:
> For allocations that will be accessed only with match-all pointers
> (e.g., kernel stacks), setting tags is wasted work. If the caller
> already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
> don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
> returns early without tagging.
> 
> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
> APIs. So it wasn't being checked. Now its being checked and acted
> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
> defined there.
> 
> This is a preparatory patch for optimizing kernel stack allocations.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
>   is zero in non-hw-tags mode.
> - Add __GFP_SKIP_KASAN to GFP_VMALLOC_SUPPORTED list of flags
> ---
>  mm/vmalloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..69ae205effb46 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				__GFP_NOFAIL | __GFP_ZERO |\
>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> -				GFP_USER | __GFP_NOLOCKDEP)
> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>  
>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>  {
> @@ -3980,6 +3980,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> + * %__GFP_SKIP_KASAN can be used to skip poisoning
> + *
>   * Can not be called from interrupt nor NMI contexts.
>   * Return: the address of the area or %NULL on failure
>   */
> @@ -4041,7 +4043,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	 * kasan_unpoison_vmalloc().
>  	 */
>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
> -		if (kasan_hw_tags_enabled()) {
> +		bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
> +
> +		if (kasan_hw_tags_enabled() && !skip_kasan) {
>  			/*
>  			 * Modify protection bits to allow tagging.
>  			 * This must be done before mapping.
> @@ -4057,7 +4061,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  		}
>  
>  		/* Take note that the mapping is PAGE_KERNEL. */
> -		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
> +		if (!skip_kasan)
> +			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
>  	}

In the cover letter, you said that __GFP_SKIP_KASAN is only meant for
KASAN_HW_TAGS. IIUC, here you skip passing KASAN_VMALLOC_PROT_NORMAL
even for KASAN_SW_TAGS. The flag is used in mm/kasan/shadow.c.

-- 
Catalin

