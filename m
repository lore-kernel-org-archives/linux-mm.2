Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AC1CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4866B0005; Wed, 27 May 2026 06:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796426B008A; Wed, 27 May 2026 06:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB536B008C; Wed, 27 May 2026 06:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9E16B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:15:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0932E1C0448
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:15:32 +0000 (UTC)
X-FDA: 84812792904.16.CD62AFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E0FCE1A0004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:15:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oSq834UG;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779876930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAwRwAZbFxbaZbvpaaTIPyxaqw44nisSFRU/tIpXJ1o=;
	b=qXnObFqLBHsUkGNGb5VAK0Uc+2ELwcOvQ1gb0VVik45LPOEL25hBiqF3R7ROL3Cyp3JOJ4
	FfxpmZVK/u0rDRs40GNz9ip9REp4onSrAGymiG2pv2EqK1e/9BdiLjslqFe7czEY/y+eis
	64Rd0ReiTzaVWXKHi75wquqDfIOeLMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779876930; a=rsa-sha256;
	cv=none;
	b=IRjs+Dr4OaDyPJknhiKfyvOAxJ/0c8vkkJLTr3hqY+kTSst+ZUdbYTd8PAKPfcZdnjYotI
	XkAORdeO+QhKYSHTotrNS76CjjqTYtOgNWPpO87EkQp+bRQ9eebpLMg/kBNROQgkBbYZfg
	QTg4/QuL7pgauWbj0OUrwXBz7151Q1A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oSq834UG;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4003169C;
	Wed, 27 May 2026 03:15:23 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A9F853F7D8;
	Wed, 27 May 2026 03:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779876928; bh=11Ch8SRuV30IKc6WYj2PYORtmdlKFlKYIOyzxzCdY/g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oSq834UGuKiM2+78TjUMC/7CFpOQSaVkGtkwnwVw6wEh77IDpZniTH2Ll34ktWbVi
	 i10lybDeLgZpwDurSiUporQyyJRmE9NGZNsnDtMONWqT6Jn2VBTCk6pwvwlHwCFci1
	 PT0wbisNKGnc6MQ25CZJXU4GE2Nuq6evM+eubKdo=
Message-ID: <4ac24b2c-7fbe-44bd-9efc-c1add7785453@arm.com>
Date: Wed, 27 May 2026 15:45:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: update file PMD counter before
 folio_put()
To: Yin Tirui <yintirui@huawei.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Yang Shi <yang.shi@linux.alibaba.com>, wangkefeng.wang@huawei.com,
 chenjun102@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260526101337.1984081-1-yintirui@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260526101337.1984081-1-yintirui@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: inwufzmnmrk1denuun7efh7kh6krmaad
X-Rspamd-Queue-Id: E0FCE1A0004
X-Rspam-User: 
X-HE-Tag: 1779876929-58253
X-HE-Meta: U2FsdGVkX1+gJAIEu+5br4IWbFVD+EuHwRJe77mojZnaJFZYXTn9xugcgmQK4cRDjC7o0raSAxhfv4zslZXum85eVrbH9r5h3Szh+RdUoUFQfvGXuyXQjb2pqEsZjSIhpSg9kIQlryK02jws9o8db2lXJVwpZntdgptUktwt+tWUw6ynG9k8zi33yTNKozXwkmpsp3Wfw70f21uWvRQLVGVTe7VCkFyGjbEt4oUbPIMhyW6ZOUPtW8ONAZIg+6EVdyBkeQMPL0dTXLYEctm2Q7GTx/5L2Vr3qdcfYBNL+JwGSlDvImEz+QVmXVUYE3+hz8Q/orxuKJaog9/3omK+CmgT8N7z78mk2PRGgVHqlohKphixE2RPrRBhf2TcdAvLucDEFa8aIJ61Ytx0BUthPclSkkpIyxf678ogrNkvU13Z7mR5hg+tmtyT0tu30KAVJCtrz+aQqFP40R3voo5gaCQ/6pYDQbDqBCoOkzi75o/a5ux0kVtI0vMCWPQiQNiBuj5dtmK4Z6qhk4hfKiXZaZ23fkYdiwEX31TkM8AXcJ6LNzHQ5w2WxplV/i/QEoXSXxfo1kDYV9YTSCY1nx7H5p/o0KF+b0Tt26HAXezBBPbwSRoH70CS6KEebOIJT7CYlpwgQLloy1GTNyNszHk7xZQBk5/F9YimznlZNYzjtXPJt1dlwusXwbqpldz1fDRJbwQX3JkQwVr9d6yu6ThZTef07cQpOe+4Sn4hFrohoXG0vAwAkuzt0eEfV7naWKuRJ8ePBlnFJqSswy92i2fEJUNkcgClacrMi1pX/78BjGvcOxqLfOi0aKE3j9/4Nvo027AJpCatIvWr4JAeERT3UM2I7nCSXhUNe2lSK73NP1A56iorQ/TELuLK0xTx2t+VkyMuc7coyarUXADnEWX8F4YySU2FjbbHmMwOMRZlCglcq18DDz5Vn2JkURC4ZGcSLDiRArdhocA5GKGdD/A
 tCG4FnAb
 nPRVldCgKIDg92YXjg3Bi3MGmnAblTexiaIA4g6wkrTkX6AnKyLSvOMNHfw9ZpNsxTndH6poS/UqY/U6ENsqN5oRVaM1us8nMvyUxLceP2grBZwkkyRsbyRzpE6Rv6BLd8GsCpADB9XKn4nOHR2Vw2i+rIHF/3ZgGJJdkwESpmF4PcFTEy2RMpt8PieAuN2ch2Rj/usGAPg2fhS8J2Td6orG0ahf1zc5HOPelpN4ed/97Mif5QNfSsiPffD6ltsr5Iq3NX5uGsIA4vbX0CM2w8jF96ZRHvyM2HsZi8C2kEmB4vlWFwTTCmMFRXE5vkfGR5STq8WzFl1uK+CU1VoMC0XMu2odMKRIFQr97jpWuFkljbe8glhzUolEzI2krjTW2p5xi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/05/26 3:43 pm, Yin Tirui wrote:
> __split_huge_pmd_locked() updates the file/shmem RSS counter after
> dropping the PMD mapping's folio reference. If folio_put() drops the
> last reference, mm_counter_file() can later read freed folio state via
> folio_test_swapbacked().
> 
> Move the counter update before folio_put().
> 
> Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0135c29a4372..a5f4a48b7b77 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3145,7 +3145,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
>  				folio_set_referenced(folio);
>  			folio_remove_rmap_pmd(folio, page, vma);
> +			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>  			folio_put(folio);
> +			return;
>  		}
>  		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>  		return;


