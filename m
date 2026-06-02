Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95F9CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5DB6B009D; Tue,  2 Jun 2026 11:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D376B009E; Tue,  2 Jun 2026 11:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA356B009F; Tue,  2 Jun 2026 11:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29CC76B009D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:42:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0109409D2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:42:06 +0000 (UTC)
X-FDA: 84835388652.03.A18DB4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 160F81C0017
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:42:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgUThQiV;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414925;
	b=lzZ9a7kUH7HltMUoxB1OPd3KNLv4v+0ulNhxiaL3NbNTJDf9gqLXhHKlQi1xDABYMxqIty
	3GiXGg3e/iQFBQGiXykaFADi8WEdnSM6achVNvMyQ3y/1G+9S35JFday7hrHEY8VCa9NjH
	eCHt2dhIzWj83NAR86L+3Qn/jZzlcMc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgUThQiV;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2iPxik+gt/K9tv+LiH1rAAW4SyqMQzYLDmc1qnwxLM=;
	b=sOIntutMtWk4VHpK8787AFz4SDKgByY/SGzFGInP80j5l7wvIfBsgmuAI+hp+XhBMnR/GH
	vNMY4GRNMojrlG2U8q/MoAI8FJt7pKQTl7egDwZzJHmXU7jC+ZFyerWe5bqT/vkKhdheTQ
	YuCvs+3vaSebz0G1oCR39UEimCLt9h0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D890601E2;
	Tue,  2 Jun 2026 15:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B4A1F00893;
	Tue,  2 Jun 2026 15:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414924;
	bh=e2iPxik+gt/K9tv+LiH1rAAW4SyqMQzYLDmc1qnwxLM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=GgUThQiVtXfAn3sygsENtWy2bNcoEtDTKqD+k+4/dxd/WiRCuyxnl9FNmv6OIJ77y
	 n61AQDGralQUr1hgbaUDNeTezd62bqW93pXWmQ4mzltanuxw6RYc043O9G1+XSuwmN
	 oCrz8Fexug5hS+AzzYrnxpGJnJ1qfUUfNAqTiYpkhNSFZPwWnpVw34d6YD/b9H/iTa
	 yCLC9pFCfN5EZo6/RN5il4tU0859XGgEkzcqcvQ7BEu1ZAYRKuWCBwGu7onNxF6Elj
	 GGY+l0vvny2VAZOCXjjRCGM6FR/syqL2X+I30lSXL7AGM3536mCck0Rt8jP6ITh1mP
	 hs3aSoD6zTLmw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 19/19] mm/mm_init: Fold __init_page_from_nid() into
 __init_deferred_page()
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20260602101039.1867613-20-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-20-songmuchun@bytedance.com>
Date: Tue, 02 Jun 2026 18:41:34 +0300
Message-Id: <178041489408.457517.2991925440539441241.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 160F81C0017
X-Stat-Signature: k77kb4j4g7ch1izwabyiu6j5pw56meof
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780414924-30397
X-HE-Meta: U2FsdGVkX1+ZLMyTPr9dFiK7gkg4MYscys0y+Y9fMM5/vgcX9e3p7wUr4vsvM6HsP1JQZSs6CSXzDjZvHj3ROI1SWusf80jKfiZMIoumU7xJREdBmVMyQAy9qC0BFQnvNQuO4Qe6esiiUAjEeU4886sc9ah95IeLaI6YUvgHuPk9816AXabK3Jf4Mn5ZblKP9el7Dmm1I4aJBW8U4U4OnrygBU6U9yrvtXvzmic9br7+CJL8ZGcDTtiWCnohq/WOVAEx6jyyabr0uysKfO1WStbpbyVXKVeQflyLynbm2LRM5ucstyPfFFTeuKvkHPZrh8muU0qwZCjBAMXuDlAUBHrNbOPF9rwC9ZjpoPFtiBPTuNQW9DsciqUFPSLyvxhKOrdIYUhi5Kvo8zEuOieQJy84k4wH20tNAlprYhUixGf4+brxZ00AsdP5J7ksmsz9N83eVXRraQHcr6h4f4NeKe75Goi0pZcdtg+tVIRENrKL6bKNjjn9dnEeJrVSUl107kN2sYA856nOL2kOv9bzsbysUBZpjy8Ju7xianeA6MIzGyeRAA/zmx8nOjZQAQBwyCMWXQhOM0HAS4WyHHAFL9PXn+9fvgG2ceDUXDbk331diLwJxzxmbgSrpMiW0G9rIuiGYOyfLI9A2XCF+sGhAxQTNkx4liDp2MMOBTP6vHS9t4bgUYiZUxFpOqHTetZt4jP6NiNbpPaI7NoI/zEJdDMdcFJDQlwD0XoHlB28dhWRUj4JND4kdpa3XlR9x0MLVaShBnptQyeAdlUY5JW3GKu9tmUnSDK1IGl+MCcAfimfY7W0yEdFNZq9ArhlyQuiFlVtAXK1Bo8se0uxhFE5wiDNvz39eVxACG7s2kNci0wmSgxxd3c5wWNwrj4f0ZTsZqqKJ+3+qX+quLozuF0IitbgNAcsSrX92xMX22AmIKP7fTFj0XHcf79IbJpxrAtCD6HFkUT1LnCe9PofJbG
 Vxj9kIxw
 0AWWSp+qTjT8IRtQjVbHeDpk1Mr/umRWmIXj9guXYDIZaRgXmt0BF0CYQxCMUZagCPivn+LkA94KYRxAOm+3RWHGVoD/HTKdqP+255hv0KoegZXY1TJ22YNp3rnGnVXb2UARAKkNA1JoY52K/iYTpIFsTq7amKa5AHostHhqZ7uTWtwaIqPENUF7MBgmdXcF0SGGy4wRywZFNGZNOnaZ0mQO3PZOOFIKBm7+aRl91bTm45dmNnZ20IrrfVTF28ae5ZvY7F1txk2pleDRlXgMOtSL4ShHz+5EkGCrINu+9BXEeFnXubHpeaKmJ5/uxj8S/G4SqtS4tJCPu6asngeG03Wp9wwHbF+Sw4p5l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 18:10:39 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 41b83dd18c01..f1bbf3b9a321 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -771,10 +746,27 @@ defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
>  
>  static void __meminit __init_deferred_page(unsigned long pfn, int nid)
>  {
> +	pg_data_t *pgdat;
> +	int zid;
> +
>  	if (early_page_initialised(pfn, nid))
>  		return;
>  
> -	__init_page_from_nid(pfn, nid);
> +	pgdat = NODE_DATA(nid);

Nit: we can initialize pgdat at declaration line, other than that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


