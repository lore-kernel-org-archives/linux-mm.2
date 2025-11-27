Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DD2CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC386B0022; Thu, 27 Nov 2025 04:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D186B0023; Thu, 27 Nov 2025 04:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44D86B0024; Thu, 27 Nov 2025 04:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7DE36B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:47:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60C828A7FA
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:47:03 +0000 (UTC)
X-FDA: 84155908326.23.F60E3F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A444E40012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:47:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u48OIx4k;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764236821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZ1AIX/pr/AF1dAsTkT91UVWbIAtdo9lFMD+bRgD/SM=;
	b=eSloqU/16VZXzKAMWs68LqTeXQy0UiK7n3SAAxL7woKnwtMDcGsfMTvG98cAHH/VCd9sZZ
	MXajK4ACfO3xRFYmFFLP2fhbNaDg1E+MtN6C+XvUMKo+C817RpWEBKWnyUFa3RzmKACQow
	xusCZTQcM7C1PM06+yoU4i3OVjgws/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764236821; a=rsa-sha256;
	cv=none;
	b=eqw+MISDnhm7dUlQx77/RV9RJRtvCj68RpyoxQWhYyyDT1MTh3eunhz4oYC7WqAe7eRhA9
	BeDMR9IHUKL05yvuC+3ZhAZcEMArrNJXI6FvjJtTZ5EisW3kLQXBbaGOfdYVFwrjLRl74T
	2K1yWpekk/3juF+NMv0BMh94ZKwiNlc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u48OIx4k;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C46E43E6D;
	Thu, 27 Nov 2025 09:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B008C4CEF8;
	Thu, 27 Nov 2025 09:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764236820;
	bh=8qVHcabnA49Sme4v1DjOvig6KKg3B6BN/BlcApPPU2w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u48OIx4kztoXzuQrFDcaaGigRWyx1EP/5P7xzkGPI54p9t6YAU1D85k3XSOGaZUn6
	 S5DxZTPz7BZoXdKb74ZAiSl3N6xiIJDJHvXU1cHZyR1xUQHBBvZSJ86Fsjcti5JDCu
	 75vgGd90Wai6tFuYF/fJazVyYFkyXiV9hEeFhNV2jq4epqCVX6NV2I22hOFl3NdfcE
	 n30/KysDCOg8vcen7PsQr2KcR9sKNC814b0us53HNDDQIsC73mQHGqhRHAqgrJqvbS
	 SA9LE4fio7UlFXNqBN7E1kTyvLquid1/rztOGXWZMZBxqujjzx6hfIQeAIGBryiVb+
	 xPnIfk0l/GZKg==
Message-ID: <3cdc6bd6-f0c4-410f-b2a2-8cc2b5d1c522@kernel.org>
Date: Thu, 27 Nov 2025 10:46:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: Fix sparse_vmemmap_init_nid_early definition
 without CONFIG_SPARSEMEM
To: Jinhui Guo <guojinhui.liam@bytedance.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, fvdl@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251127092512.278-1-guojinhui.liam@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251127092512.278-1-guojinhui.liam@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A444E40012
X-Stat-Signature: mubnz58mzkcsz9zb5c1nzpbdtd5fxewu
X-Rspam-User: 
X-HE-Tag: 1764236821-232386
X-HE-Meta: U2FsdGVkX19Z3KQVlC8/CgEHRPcZm2Irt5ju3T6V/ktjTeZ5QwAjf5TiPZ+VkncJ69HCuCAxljVafbE2VySG1t7dwhsuoOUEcAC+y8UCkx//9FIDLvA5NvhcK58KTJeFgfCXMSi+Q5gKQ6eTWtJFrQy7bMoBQe7PB9qWPk6Iu9vPwLy44W5YWYFey3G0+aYX54uGv3MgVBxYMk0WvQM9iASQbIkmyw2jgwig2fuDY0eNOtvSxNA6Nk3M3+kFpamqwdqImoNlzzv24L9L9QDcEyr5IKnraU8D7v7tnM15OBjcrp3cZIdaofyx+o4PX3qrkg1S7HaDKUXxuMh8iNNUIrJYST1/4OE0LQLbdUbVS+aKjFSkhMQqn35wo5xByEjjaFUw1qXJ1/S10AtngGcxBrDUhvnj7rlEwk/3I9zysIW/OTIaYiiMXWm0dhcNRMw6nogNwJlQWJccpr4IlezM68FemAyHCt/owOAQzFgZrCdRhA0c3hl8UHEFxSi6iS8A3Mb6hU/NxhRYeKr1QaPC/FMNTo4X3N8sNyLFHpj+gYcCnsFoq7ByGDZKc9yHpjADR957RstxhbfcGDnBoo3D6m4gH+XXuoRE6ea/aVFLfv0s9z/zRA2pg2xmFGkcXgivNGsNUt5ajONT9bVYcauNjoCIMgoiNRqyg9BxtPHzNuJ46ME6ygLHMLT++f2Ktq6Knnzvu7tkr7Tyf/DI1hv0ktS+nzh99tJbRJLDWyDLJ1HT2LaOSKDkUhUx+3sBb6UvuvpPJ3ov4PM80M3sHiaDGA4NOOYphc9TRXlaVqcE2gM0L6bBDFDdoSQryXrs+YAAEcUa7t1BWlWgtsqhDkNC11JjjWKVPMN6Xp4HCvE0wu2KEqFWt+EmhMyIxUefT33Ekk743G2yUyuD2cNDN6GGo5Ovrp3+bYY2xEXXfy+gLOC2kl4WrtfZf0eN+oGYT8SpKHclXtW1V89rNArZhPM
 4oitaHt5
 aMb3SOcbBzp2WFeJbGgSbO2uI6O8gkHrGgmRfF4ng0JR6aTrTSNhj8UFAFfbfYJy2qXLGBtR9C0YEKZmNkzbcUOj6lHcy1QxLBh5ZE+lapf0Ul3ie5I0uZOU++d/9uGK+2ARq0pWE2qMIDzj/fQHqedv00l5ex/2E5ben6rOhP3+PIOYD108oRnT+ZsjXQgTZtnDYnnhskkAQKGtWB2kiIR5qWUCwOlwDmV7gfpeq2wkTvPhkOs9f8rymIL5YPJ85XvwJkKpBzcGmEQer9H2dviiJqy7ZyHjhUo1h2CkB9MvL+Ntt71bf24ZF+pIv6f7QY4NdtpLsicgOq/P/0j7cElf/yzw2SWPMnkovGkxWOwq8oBFdguMalu9aSBjw4nfEMCJFy1I/mQyCXUcOV9UQfly0tcNm/LFEUXSn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 10:25, Jinhui Guo wrote:
> When CONFIG_SPARSEMEM is disabled, the macro
> sparse_vmemmap_init_nid_early(_nid, _use) passes
> two arguments, while the actual function accepts
> only nid. Drop the extra argument _use.
> 
> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
> Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
> ---
>   include/linux/mmzone.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7fb7331c5725..f6dd181a4821 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2293,7 +2293,7 @@ void sparse_init(void);
>   #else
>   #define sparse_init()	do {} while (0)
>   #define sparse_index_init(_sec, _nid)  do {} while (0)
> -#define sparse_vmemmap_init_nid_early(_nid, _use) do {} while (0)
> +#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
>   #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
>   #define pfn_in_present_section pfn_valid
>   #define subsection_map_init(_pfn, _nr_pages) do {} while (0)

That commit is from early 2025.

So what are the symptoms we are fixing? I would have assumed a 
compile-time problem, but no built bot caught that?

-- 
Cheers

David

