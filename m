Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C90CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A618E0014; Wed,  5 Nov 2025 12:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3818E0002; Wed,  5 Nov 2025 12:51:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AFD8E0014; Wed,  5 Nov 2025 12:51:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 641A68E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:51:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07651139C4E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:51:09 +0000 (UTC)
X-FDA: 84077294658.27.CECFE6F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 89431180013
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:51:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMtEWUVd;
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762365066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISFGpQkJKSZ1BMPwjfpatM1IANu2Zxf0CyPwVpdWe9g=;
	b=SWn2RSy7ecNCCbrZUgIXuYUixfHKO7H2+KrVk159jc6lDce6fFCua/FJw8iy9+0SayMVpQ
	7kJehmqEkx+4h6Tz8pszQMxCP1JPTjBLIYJlzN1pFDJo9xPDJQn7YCTW8LuW8UqUdlnb7g
	59pJhYkIdqbqWYAhJ8cmBs/O5TPCNbc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMtEWUVd;
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762365066; a=rsa-sha256;
	cv=none;
	b=71GlkDGNw5Utp4uiAw6cTwyBSVynkYtKgYj28TvjrkiVUS7twxZK7c93vzurADkZtbP+en
	c2WNExkYsHE4nhdixh4OYvGvu6LUiaT19KVYvkl/gU6jBFhfUeoFmw8wBYOcsi0I+VN/yV
	Du0gKXQ+vRoVQEJcSelq1EiL5Bpdqpw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762365065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISFGpQkJKSZ1BMPwjfpatM1IANu2Zxf0CyPwVpdWe9g=;
	b=IMtEWUVdvUqcUFxE3dTECNzF4EVxg0jlrMXVEUqURsjYoPgtTwjF6gJJzQC1rQrssYbz+z
	3GruAyWJnyzWIiwxd1EDkxd0OB8R5ISZYjFC3vBBLAcCIXjYF9daqdH8dANabiNPQ1pW7c
	Rtqgc7NwKmLEDo4+kF90WbOYNF+VomE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-Qk2GhauHPwC9DBMehFzz7Q-1; Wed, 05 Nov 2025 12:51:04 -0500
X-MC-Unique: Qk2GhauHPwC9DBMehFzz7Q-1
X-Mimecast-MFC-AGG-ID: Qk2GhauHPwC9DBMehFzz7Q_1762365063
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429c9024a1dso61183f8f.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:51:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762365063; x=1762969863;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISFGpQkJKSZ1BMPwjfpatM1IANu2Zxf0CyPwVpdWe9g=;
        b=K26rb4fYn9Sg8ooZ4TJ4QF9VdtZRFFwFWTCAmZSEUIEVfAZfXRTYh7b1R/BOpX7LC+
         hnx9K28Zf55AKBJZM4CoZjodMO0shfDVAiPAY6tpEGfUmYCyiubv4jZj1iBGQdEStu1J
         MKFR4no+nxAEQ2qEDY3nOabfbE3nv/vVRKvIXsY7feVys5rV9kVeKdl/B21m6+nepdot
         XpLId9ZCuKrQ1ovbEstglDhk6HcsaI0dk4NUxe/gCYwTpJ6ptTQGmcH7uMvr6BJ5/O6i
         Ze1oSHM8pjhbb1VJADbVQefwx2/P1HJw/3mSzUN8nOCQIRymY7FZnLqlS7Q4d5/usbme
         4POA==
X-Forwarded-Encrypted: i=1; AJvYcCUs98ck2oZmN60Q0nAxV0fUHNuI6mMRGiIvWb5GdZM36Wkb6gXVxV4T3WR9vd7qjKiVlzLPAbTyJA==@kvack.org
X-Gm-Message-State: AOJu0YyXlN7pyrNGTWNBMWEuxDK+k8sQCQtXbaGBSFGskoHhOpGi6Inx
	qBz5mAdUy1hS5sZUtI+So8A1KqpgC/sxd/VAq0ImhRcO6/Il7qQLlslvSJ+yHnrMeTibKSPzuc8
	6VFHnOps/IplXvwhfkpR9dzqeiASkgPbPRndsGPJKb8aKlgZR5i8O
X-Gm-Gg: ASbGncuGAd6+pAEEqMwb2IKszMc14gJevCsx7/6kmDnKg1vPf6apEITU+MHpVIlihYu
	z4FSdLRXKyvXjjL/VFNGb+nk7wIzpFkLfJ2z/kT7nk41uX/v5eDS4sRzKwcOGvQVNpzTZi5q9vd
	AAknLvgPBndaMdWMTCHY8KgVwhRRHqQKx6E29mifKdenVm3nf4RWkwtJK9zjU3I/0x2SVRHfOV4
	uKE+u/oexBhZ0mJWI7m6ioLKtOi5R42n+Gx827ssMo3uCmcRRPkPjn6LOTcxia35Q9dpMzfghB5
	7bLfNkBFHfkwYpgvU1P2Jpvh0wAV/gXh7MDokBqBrOkDWUJnOV3RMgEOd95dgMad/Z15pJPYzJs
	MO7yfg0olg+VZcl1DVfarb+1XWELurEboguRKgq8MxSGORBmeeQynL8w7amJcxX5vKJx5jeTmK5
	mbza8bsM5kUjG2Z7PJI7otCaw=
X-Received: by 2002:a05:6000:22ca:b0:429:c774:dbfc with SMTP id ffacd0b85a97d-429e32c8168mr3732767f8f.12.1762365063484;
        Wed, 05 Nov 2025 09:51:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFewf6v4w5Te5dYAKTDbgxc9eRX6QAlJrRl89/5s4XLBna4xlJJ0Gt+LuAOvKZZlMh4VyOouQ==
X-Received: by 2002:a05:6000:22ca:b0:429:c774:dbfc with SMTP id ffacd0b85a97d-429e32c8168mr3732746f8f.12.1762365063082;
        Wed, 05 Nov 2025 09:51:03 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1fda36sm11649953f8f.40.2025.11.05.09.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 09:51:02 -0800 (PST)
Message-ID: <021e8194-14bc-437a-a4ed-5e6abffb9827@redhat.com>
Date: Wed, 5 Nov 2025 18:51:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] Revert "mm/ksm: convert break_ksm() from
 walk_page_range_vma() to folio_walk"
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251105172756.167009-1-pedrodemargomes@gmail.com>
 <20251105172756.167009-2-pedrodemargomes@gmail.com>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <20251105172756.167009-2-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5qK2ooCad1GbTADI896xWaatyqdEowoPJVVHXkY0o2Y_1762365063
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 89431180013
X-Stat-Signature: ymyqishp3oho3zt1psr9othhigc77psa
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762365066-320290
X-HE-Meta: U2FsdGVkX1+PO/3VAJBKex3BtPECJ9QH8DgNTI1e4hQkuXyifGMb/3BVi9falhbLAUb9XHtquqW8E6xv1CjGlFjF97hVwquhssZ4Znss9CAiGhLMouVAf8WQ2aPQhqC/th8yF8qAAukKAOVwP2QfMgzaVZfy9BqneEExXw3D71jmbHxFuLu8cMzJRKQieFk0jwADnN+xBc5rgIgoHcqHsd5aQctv4V6q8ypwMJEy1zbKWCAyCDVxl8KDkgbwYLwOyncjnoRGAdK3mlxtBMtbSCp1fmchjIoswcR4/nvjvxFaMC8xCUSP2UocCYGzLGK8zTpxF3oPc1+5ATYs8vWhSjb5SCP9J88MnsNmheqgrCMa0A3vrtoSHbZfUERzvXppW9ybl/doEk8XPL4VMIbIxwbCjXBQK3ohjCOw9ugxK5uEpr5QVNrDa8lWEgAE5w/4eSUtjtgl6k3+kA5gJVdEQUur3UTY2mYnOpT9TkHlKAmWFcfEV/y3Q4UkrolbjBimBSfjkyWZV8o15yWQTysbtauoDLL4Ao2ja4F6CCWmOWiSG9r0xOtvLRSScbIU4zJ8XIVZeR7LxmObQnuV48WQlkVo4HUVGvLh2R6EqYyctl8jC4TIOicxrKtHvao9Y+ITiwX2tL/wMZbKNaL775LgdernRmvyAz7nSwE5yg24KFmB36skLCbKKhli8YaPi44TK2U0nLYTm76MiLpu14BYm04t7faBmG7dzkruPJ4NWtJgONeXOuXxrbqFL/ig00CXJYH25cRJTJ+1wluleuRolXjKvYhcEiX8bcuCYI/LlDsG2+lBO1vMP7XqD3OQ1bJgU/O2R7ZqNo0KkV4uqANx9XgFmlKzo1DkekBFkofwpvj9arBf7FlUOu4XfhG9Jf2DTMTgxApwjnS1TxjfRlJMqlR0dS+Q7uJc9x+B11dtlZQqn6eXfGL2HjtDFE9FNDzo2HPECbGa45oAX5esx8N
 qeA9Ivys
 E2V7xvCx+205tGng8xrBv5Uy+YJE9NTIRWstjlIiVIAYHn0bn9J7bCO58fdBpZ6t47NRqTq9XMjrsZyf3QJFZzrw2wSsdr+1FPSfqatlg1WFLYbvm6c0gIKSiD6WB5ivIjjbQ3iS/Q0LoZwB50tWozKKdFSFH+J4FHAUezdwuuf3MBml9KmmQJNxOKYUXG74kECUpFSCox+ebdgDKfOubVlGfzTH1pk7KllX8KWwRq40CD56bbndzgNq6vL6RNIKhxZr9W3ZGKvbl6LO0RlzhhZN0eX4hdXG5A/kuumYGcj6dX+ZbCX/jS7M00uemxrVsbG9WS6KI9nv22hqDX5Ba8iBvWInw7qICBkwR7uso5+ePs06Paihbb1U50zZcLALoIUa5yP0aCGvDJkmxL9fqom60/D1WqRJX6z033wwo6cawJhN7ukFJPrdPbKCtzjZA5h6cgH+bbDADcJTp/fztPtJcRodn9sKg6tFBU0bXNLeoRHRaxw//a8gS/hDpym8PfEqgRTtC1UHuTzK0ZB3Jpx6WPm5+2hQhLnggj2INWNfC0L0bnw+ej8R/Z3w5eD2u81SBAkm7Z1k2CAV+9SAyxY3rPQb0QPNfsQ2bZC6xypqXZ//xP8qcAJFptAPPZrA0QznG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 18:27, Pedro Demarchi Gomes wrote:
> This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
> function break_ksm_pmd_entry() to use folios.
> 
> This reverts break_ksm() to use walk_page_range_vma() instead of
> folio_walk_start().
> Change break_ksm_pmd_entry() to call is_ksm_zero_pte() only if we know
> the folio is present, and also rename variable ret to found.
> This will make it easier to later modify break_ksm() to perform a proper
> range walk.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/ksm.c | 64 ++++++++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 4f672f4f2140..de10ebcf3509 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -607,6 +607,48 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
>   	return atomic_read(&mm->mm_users) == 0;
>   }
>   
> +static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> +			struct mm_walk *walk)
> +{
> +	struct folio *folio = NULL;
> +	spinlock_t *ptl;
> +	pte_t *pte;
> +	pte_t ptent;
> +	int found;
> +
> +	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	if (!pte)
> +		return 0;
> +	ptent = ptep_get(pte);
> +	if (pte_present(ptent)) {
> +		folio = vm_normal_folio(walk->vma, addr, ptent);
> +	} else if (!pte_none(ptent)) {
> +		swp_entry_t entry = pte_to_swp_entry(ptent);
> +
> +		/*
> +		 * As KSM pages remain KSM pages until freed, no need to wait
> +		 * here for migration to end.
> +		 */
> +		if (is_migration_entry(entry))
> +			folio = pfn_swap_entry_folio(entry);
> +	}
> +	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> +	found = (folio && folio_test_ksm(folio)) || (pte_present(ptent)
> +		&& is_ksm_zero_pte(ptent));

Nit:

found = (folio && folio_test_ksm(folio)) ||
	(pte_present(ptent)&& is_ksm_zero_pte(ptent));

Thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David


