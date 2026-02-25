Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD2BEFD239
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 10:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F5A6B00B9; Wed, 25 Feb 2026 05:05:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD036B00BA; Wed, 25 Feb 2026 05:05:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6476B00BB; Wed, 25 Feb 2026 05:05:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3766B00B9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:05:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E8DB13B194
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:05:42 +0000 (UTC)
X-FDA: 84482547324.07.61DE6C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 17A31A0009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:05:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772013940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4kZ93jY8LGCDSgW0RDiLbpieVJhr5PNMFMlFEWAMpwg=;
	b=GKjAcF6JfP10s6T0DcxYixzrgeURuws1KjYa56AjMwn0wIi7c4Vy2Z8DxFR2N23dQdb03d
	8B8+l+qihxK472omnlJYg2xYXtGIv0ezM0Xk0G6ycdUgIgNJ06/ul1ayqpmly4vznZpNtR
	jA1v8RdygZBFL4k11OGSAvkma/3lD/4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772013940; a=rsa-sha256;
	cv=none;
	b=0cPbhcgwMiUzUvJzAt9VsZ3KtXlC8mtF2KB7lvCCZAaBqDrqyGm2uSTYNEiqu939RxjkY1
	+kHg/VLmYbKfZWRqEtZOltLdNufO+SV8UsbgWedG3RkqellvpyW45gX50RozBFWZOfU8Sp
	VXuH/SVlsvdHGGa+Nx5hzkRIzKwTwIQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEF90165C;
	Wed, 25 Feb 2026 02:05:32 -0800 (PST)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AF8D3F59E;
	Wed, 25 Feb 2026 02:05:35 -0800 (PST)
Message-ID: <cc08424a-22d9-422c-90dd-54893bda1213@arm.com>
Date: Wed, 25 Feb 2026 15:35:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Avoid calling folio_page() with an out-of-bounds
 index
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ankur.a.arora@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260225092628.11687-1-lizhe.67@bytedance.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260225092628.11687-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4o7qdbcettcuwmwrwtrcryfiwfbw319z
X-Rspam-User: 
X-Rspamd-Queue-Id: 17A31A0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1772013939-193361
X-HE-Meta: U2FsdGVkX18o7zSGie59Lu476G2c4z53QY8MN+4wyalaVBnh2izDcTvsrtuq8XY7RN9gdRVYrLG2lqSrcsyYbTWF8EWSrB3kIFo19JUNt2PGN4+YyDO65/WM8k76u8gbEYBK4pnip0SLDsyuNfdtKJr8UV1CmZEY1ekBkRc036mlmYJuhBB/jBzuFkNvgeMSCyEonk0BlfyHiNRr6sGZVMOmYnkNl2yrCq6PNJ+k/npcHwO1dJQkDqAueE3hoEyBFZgxctiKVht0qjZVpRcstEJfGGx31N5wIrFyCB2cdwum6jfECeJ5KE0XO08NnQlc/AVzQdvkhnJIfboCYK9pz4tA9Lt6SokCEACxSXoNeoycDYWKePOGNiRFvq159OnQdq4698E6wL6BvYYVXkrx8VGg/2EE3Re9sIDDSsVGPNFYQc6PwtnUVW1t1KV5qDeyL5IjVRpg6SgqHVM/Q/Ygb+tk7llRTYzkwj7Oa7NmZHsS3ORLh4ntUm4+7emIBVsl8mX9LPcJHbePld1fp/pGHfDP5rPKSg2kLkW3h+f99w53wH906IOVPEhO0H/f1Q/rmYjEweTxuXouIGuhjlFt3QAVq6SyOGhjxw0uJLti1ypkZTupbIHPykMzdVzncBwlR+yufN+DeDwxMYog2gzFa4riDc67xpYFvK0WwwOxI7Sg8HjOhLf/IFdxWVJPuhoeetwUqfQJAUtSxMA6KZPYlM3YiCaJBqti95VakF7L1y69ve8ANwRmO76/dYaWKEJ9ph14Yq9oM4iKczXHYTRAMJduWzU5RQAqnvNzTTz8zexEYL5ngjur9F1zXMVYRQir2o2k9coeimObzkF97haP2J+QAgwebCnp98wbLw7anmRx3cn56N1cBulX70BTlzXXn1zr6vcnuyNU6HtXjlJvuspeUrbkCLYDPaaNlt6qVuRbmVTE1hcOn8D/NZ5J1WZNPh7fSIfwqLTBZNhIiu9
 KDc0nc3O
 kxEuTtyaUZoBe9JmuaSTD/WjxbsNVhYvx6Oqr0XXJ8C8eDUsRb8TvD4zvvZePCvJaeeDflBElGriJZ4m13AnZ6eU6E+q2ep4YAxq4fYMLc8fN3+pvxqD55VJY1B8KoDpIev1fcVEcgiHw5cUj2CoW3iCbAIa1g1ko0fpLrIV7OcSzirbPQivGjuWS/Y0/ng9t9SaK2iI2HkcYo6f2RjAqId+4T1T0LTKmRFB7o/icysmrpu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/02/26 2:56 pm, Li Zhe wrote:
> In folio_zero_user(), the page pointer is calculated via folio_page()
> before checking if the number of pages to be cleared is greater than zero.
> Furthermore, folio_page() does not verify that the page number lies
> within folio.
> 
> When 'addr_hint' is near the end of a large folio, the range 'r[0]'
> represents an empty interval. In this scenario, 'nr_pages' will be
> calculated as 0 and 'r[0].start' can be an index that is out-of-bounds
> for folio_page(). The code unconditionally calls folio_page() on a wrong
> index, even though the subsequent clearing logic is correctly skipped.
> 
> While this does not cause a functional bug today, calculating a page
> pointer for an out-of-bounds index is logically unsound and fragile. It
> could pose a risk for future refactoring or trigger warnings from static
> analysis tools.
> 
> To fix this, move the call to folio_page() inside the 'if (nr_pages > 0)'
> block. This ensures that the page pointer is only calculated when it is
> actually needed for a valid, non-empty range of pages, thus making the code
> more robust and logically correct.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---

Not only the correctness, but even from a perf PoV (folio_zero_user is a
hot path) it may make sense to initialize the variable only when required.

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/memory.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..6f8c55d604b5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7343,12 +7343,14 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>  	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
>  
>  	for (i = 0; i < ARRAY_SIZE(r); i++) {
> -		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>  		const long nr_pages = (long)range_len(&r[i]);
> -		struct page *page = folio_page(folio, r[i].start);
>  
> -		if (nr_pages > 0)
> +		if (nr_pages > 0) {
> +			const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> +			struct page *page = folio_page(folio, r[i].start);
> +
>  			clear_contig_highpages(page, addr, nr_pages);
> +		}
>  	}
>  }
>  


