Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12E3CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC8D8E009B; Fri, 31 Oct 2025 05:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566078E0042; Fri, 31 Oct 2025 05:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BC68E009B; Fri, 31 Oct 2025 05:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 321528E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:59:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB68B16042A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:59:25 +0000 (UTC)
X-FDA: 84057961890.01.846B0FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 73EEF4000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:59:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/X9S9bo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761904764; a=rsa-sha256;
	cv=none;
	b=eYgZBU2yc3mlqIvXKE6kV8zI4VR3cw4IcOVswvW6DsFbZ6sjPGN7mYJR3FRKaxNXS9JsPn
	4Elnyzrgzr2UakZd3CerOqBEN/I5pzi2CBu3lv8bAEBaAkN6hWndkx8GC44zPsIHJfMVPb
	VlzLPkv01xzKl/pNu4Z0TfeHwa5R2x4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/X9S9bo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761904764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdTwJ725mNnVFFJf8mEcfunSejT3cCwGVy8KIvMvcx0=;
	b=lSMoXeGU5R8/0w750/P6Cep5vKVhbct8qldv1hL6ZFZWJnKQVua80UndBPDTFz8NSnmkZ+
	ZEkiLebhrXTx3QMs0Tkmfb9UX2Kv0UgwaAFLWZ0ULtSFIMbp2I2sxy/W0tjoyWXUFRdiX2
	kxa16tAC13+oVxDvhI3PMtEX2bfxf3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7112160403;
	Fri, 31 Oct 2025 09:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00199C4CEE7;
	Fri, 31 Oct 2025 09:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761904763;
	bh=fbWfcUSRmmSGBIa7RvGFKILcyx2LFQdk812Ih8G0axY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B/X9S9bovPQF50GHgjwW/vIf0AsSsp64qbJdE19thdNyppfFyHrowADfIzxgilHha
	 A/jpOa69Lv0SgKllffjaNRCbjvkRI+7+1JiP9CJCKDYqqZM6Tjm/7tbvPhObuzx/9R
	 BO7w4YmmWcwxi2Yg6d9QS/dTwBEXtoFACYU+hbBqz4p4LUt7imQtt+5wEKXZClcoUY
	 DkyhTugW2NZiY/Pf8gSGz9ZaHj1mHzJQRPTPEnKgxiE2CFWnQzq9ppapfN+GQeS4Vw
	 DV+f3c1KGZWPnuX/3/NeCVIaatiRrx6mXXSe+YVieVb3GpCdgVdqo+ttN1IEHCm06p
	 7jJojaeQqffYA==
Date: Fri, 31 Oct 2025 11:59:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, big-sleep-vuln-reports@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, willy@infradead.org, david@redhat.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/secretmem: fix use-after-free race in fault
 handler
Message-ID: <aQSIdCpf-2pJLwAF@kernel.org>
References: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
 <20251031091818.66843-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031091818.66843-1-lance.yang@linux.dev>
X-Stat-Signature: gp88qbkjzyn5wgatoyq6gmr45itwn7xe
X-Rspamd-Queue-Id: 73EEF4000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761904764-108546
X-HE-Meta: U2FsdGVkX1+C/iBe6fnn3o7Yr3HFDwmhfPA04dl+o33gYa938O04LP1k0N/XFKf1TQZcANPNbb8TNHXhf7LB3Xf4qGLsDp+w1qIfZQlTtn0kZTfL8dNIkk9W0MtK0eCjY/+CsvCnSqmZmsQOjhEGaIcxFqhHHLMmd/4GHvovf5FuiwT1d17j8lz7RQMfLLtG0UstkWu5ur/c6rPRvyYmunxp6gUsEvBiDKf2K6EwgfAXikh13aP1SWsh5tll2aXYkOZ8N9Ckw+EnV+rpS/GyaHz4qRK98khliGbSRUxuxKnrejjhfGV3wa5njh5bcCTIfwKwf/VXE5pLDCmYXPNcclUFT+hqEI1pL+pFpwqV+Y/jkaF0NBw+hSG5PeOKG48jJ0ei2qxL2/oEuy1ilAmYAr63DOFyX4tUcIpjTm+e7iWtCZ8ju80ZtLh18hZGJykffXkb8JlK8kI+odgDyl9+lBRNvwQq41prf3xo3bA1DY816I40ozH43KYz3TUxiqbG8h69njP8Bc1aGLkj069kFh4igr5ODmuhj3is1BCLdXjVXoC6b7cE5cHfAoHVAg6u4oIxbzAJlU+Eo4vpr+5RriHOXYdJ7zpMJw/CpRBqxJb9dOwo9Dzig8dm2y4QI+wRbyQEWohJw9WmRXDKRBlSlT/NwLlqZszDMW3mmCBLC38r+MICKWsOotBJ74wEOBx5AibBpJtYJMEwPAQM1hpknpBnD4ryjd+z0Q6P69YCxlIA5PThVx3U1c0PAbEPlB9pk2Zoejc//flB/B2jarxfNXfD6iDUarEi5zvyQVVPysvarPOIT6Dm/UPDwQ+O3eR1UjshJoqd1if41WjufVULewJxA3o1AF2M4SMlIlCk0eDJo4RNrmESeywUkECE08lPfXPMIHpKX3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 05:18:18PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> The error path in secretmem_fault() frees a folio before restoring its
> direct map status, which is a race leading to a panic.

Let's use the issue description from the report:

When a page fault occurs in a secret memory file created with
`memfd_secret(2)`, the kernel will allocate a new folio for it, mark
the underlying page as not-present in the direct map, and add it to
the file mapping.

If two tasks cause a fault in the same page concurrently, both could
end up allocating a folio and removing the page from the direct map,
but only one would succeed in adding the folio to the file
mapping. The task that failed undoes the effects of its attempt by (a)
freeing the folio again and (b) putting the page back into the direct
map. However, by doing these two operations in this order, the page
becomes available to the allocator again before it is placed back in
the direct mapping.

If another task attempts to allocate the page between (a) and (b), and
the kernel tries to access it via the direct map, it would result in a
supervisor not-present page fault.
 
> Fix the ordering to restore the map before the folio is freed.

... restore the direct map

With these changes

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
> Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/secretmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index c1bd9a4b663d..37f6d1097853 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -82,13 +82,13 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  		__folio_mark_uptodate(folio);
>  		err = filemap_add_folio(mapping, folio, offset, gfp);
>  		if (unlikely(err)) {
> -			folio_put(folio);
>  			/*
>  			 * If a split of large page was required, it
>  			 * already happened when we marked the page invalid
>  			 * which guarantees that this call won't fail
>  			 */
>  			set_direct_map_default_noflush(folio_page(folio, 0));
> +			folio_put(folio);
>  			if (err == -EEXIST)
>  				goto retry;
>  
> -- 
> 2.49.0
> 

-- 
Sincerely yours,
Mike.

