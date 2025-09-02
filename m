Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20117CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 07:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669B28E0003; Tue,  2 Sep 2025 03:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A7D8E0001; Tue,  2 Sep 2025 03:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509868E0003; Tue,  2 Sep 2025 03:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD578E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:46:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6C6C5CB08
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:46:36 +0000 (UTC)
X-FDA: 83843527992.17.3029074
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85842C0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:46:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S6o35P2i;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756799194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qzr7tEk9QItwIeF7TnzaOixRSPGJEnioPW1Itw0DucE=;
	b=A+4ThMM/4oYuMkRfRRL1Bq6Uqn7d2lB8hVuXQl32HK2N7cNoZT5Q5IqlHMMWnwTAqbBzl5
	XUM+7YuaQdclxktSyC06dThPVOTUn0kQNRItiw+PbYhDJVXlHp/OHfY+8vyzv8W8mHpVdV
	S+fmCXbQReoMq8iCJxlx2oPCm5hY97s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S6o35P2i;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756799194; a=rsa-sha256;
	cv=none;
	b=Mqq4P1di79iktaUJuwlxCGK4iOfNcSa/tMwZL42gt/hwt0W7MnIR/jztCUnpgjv74U7III
	CW8QqKpQFxvHlyDD+Q9CoLihlslPiNnRLD1oZMomO2DfOhbsqj/N+uwflWzMgCd6cw3o+l
	MjhtchvoTVTVkUr+QtDiqlPwdabjtIo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756799193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Qzr7tEk9QItwIeF7TnzaOixRSPGJEnioPW1Itw0DucE=;
	b=S6o35P2iu98VgVd30fXsT2U2hKTd/CRoGd+A+Qh0f10ew1YgNOUEQnLx+5j8CeZ5X/iotc
	FjmJGeB8pOd3ICb7u6lEWGFZmEnLoPG/qmqsKoJRp3f99Q0iviDs+fNOvynmPX4e86wq5c
	/gF2EbXyf2x/aK6B5wzEmMUwXNXVfdM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-c_LyKRzyOJOtfnb8jetgFA-1; Tue, 02 Sep 2025 03:46:32 -0400
X-MC-Unique: c_LyKRzyOJOtfnb8jetgFA-1
X-Mimecast-MFC-AGG-ID: c_LyKRzyOJOtfnb8jetgFA_1756799191
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b467f5173so48180135e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 00:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756799191; x=1757403991;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qzr7tEk9QItwIeF7TnzaOixRSPGJEnioPW1Itw0DucE=;
        b=R6FaP1pEEXZY+uY4eWlc0ayqDA9QrdUedj6SFl2/KM9IsS0XN11ykCu7qf1JYEUM1L
         T8CTY9A45nrj7QZqvTL1JmR/y/bqPq3FA6bcvTsjdfwMG66vnsdIsKw96a10onbG92+Z
         xE4x2jyX81wBKYwFWpmFQzV1lNh1pkm+9dqhU2qyKjj4OVykfgFmKpo5o8QGNPUISGp+
         p14up4rLUQZV24GnuT08ea6U9n1PX/M1rO42fZjynt2qIzpqjRkWl4lmk/fAGhE671t0
         8FY/CAG923xR8wnJMvhZ3wWHPZid1gAP1a9jadxLFS/WRhySSv9+Yi7Kvi2n2B754uqN
         CyTg==
X-Forwarded-Encrypted: i=1; AJvYcCWGLhIoNFPGxO9YNkkX3SMPkd/PNOH0T/USRTTGdLfm3yg/vgsD2pa8QuX1JEGzlcRyV+lZ0fsgnw==@kvack.org
X-Gm-Message-State: AOJu0Yx1JgkuP61oyhlApHvulTUZaibgVl6+L0Eoy102mFk3wtfiXfop
	HoYPTw8l9F3aikgxDCJbpSKlmNvP7des5pnnYul6zA2XHy9CBaZyVSVjWnW1XNY6+SHcnoc8XWI
	U85WD18wAWtJmqg5fqyJ+7B2IEu7evjfjexOtoqEFLxbMThyPxZce
X-Gm-Gg: ASbGncui3z6MVnlEq/7uH1HPQF57yo/Qy59lcLOv0qjNZujkxWadMw0HgeKP/jVUZUw
	iRDiFsP4KpmFF+PNWY8thMI+XASiPDV6A9aFs9GJWoIXQ+TTtNaqqPWfoaxPre37GZVna3D+/pD
	sHuthOLiTmWnIupQZqFd1ZpyTD87xPtqXbFhUfxt25ALO3nGhDmBiZb8oILhdnbnUG/xf3weOKG
	Jr6VbstXkAKJ1QgVViu+OkRd3Rea2u/4GLSIjjtoohYCGVRG51uosLI3dEkvZx5dBAcmVWgprbh
	Pci4EoLMybpMYewltZ6pZRm3hoCzjhmhDIKLDQqcKJsO7JGrE0fEP6G5HgQgBXdtIbCODLmxq7T
	2cKWJRINjkoj3P8QGux0yDr5nfDlf9IXUen3Myk3aIzs2URR3mQ2H+xcE4qMx0CRw9q8=
X-Received: by 2002:a05:600c:548f:b0:45b:944b:4317 with SMTP id 5b1f17b1804b1-45b9aae5a3bmr3712105e9.19.1756799191110;
        Tue, 02 Sep 2025 00:46:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5pO0lIsDBZdbx8V/mVrz2LttNQMwlq6E6UrKsC2j3HgWKZXpWhllYGOkAr7VnCW+kCacaog==
X-Received: by 2002:a05:600c:548f:b0:45b:944b:4317 with SMTP id 5b1f17b1804b1-45b9aae5a3bmr3711835e9.19.1756799190691;
        Tue, 02 Sep 2025 00:46:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7eb05fd9sm185570505e9.24.2025.09.02.00.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 00:46:30 -0700 (PDT)
Message-ID: <ee3ee18c-27a0-4c38-a639-e93e91a392ad@redhat.com>
Date: Tue, 2 Sep 2025 09:46:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/gup: Remove dead pgmap refcounting code
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: osalvador@suse.de, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20250902051421.162498-1-apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902051421.162498-1-apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8ARsZlfwRscc4_0IJ9HjoUbLY84eoKNhsrTz5lmPc20_1756799191
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 197cghm97bgpxzx43sa7kft8tz9e34en
X-Rspam-User: 
X-Rspamd-Queue-Id: 85842C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756799194-116253
X-HE-Meta: U2FsdGVkX18TjwYeu5aNZzbj7thCqyU2Oi/7uQgfS/khoc+oggHBTH6g+697G4Awq9uyAX4vLDy+xNApn3guarIMKHnmlYuDh5QuEhobh5VwoBlRpOoS2uGlnmyIZ5h9SM+AGznXKeRecM0h/EVz0ItqsLII+kROBcO/Xo5GThfBBo7kpHELsXCR6jFfibfWjV3nB0O0dRhK0e2npUjUjKUJSuQ89syVK3vRNRIsjYnSBQuxpJVUOr2Zfzdf/3ZlwbhBrzYNOG4R+XgsnpJCvn7RbA4ccUx41J8f27HTVtnbGuZEnIKl1iwlFHDPHsZY5DDos8nFqVVHGAlNbovIqPwyyu7NgnOLODJDVBFJ/dw6FvawqEvM4pzqhJNwgrvENr/Hw7GjfXQtreAyUFqD0iiIF6gPCpoDoUebG+MyUZrUrO8zEqKOvkiRZRwznup0Uxrr1/SS5imU9U47tW1KtFYfHZLK8az+sjAASmLKxXFaoXW2AYol2hGlvifXvgXCYcyHHDixETjCo8CKVrMzTL0mcjvsc4bP/jrrqh/GB8VHr48j7Qb1cUpS234ww1im83/WAvpXZwVVWu6Jlq1XbkFjQ7BGW7I6/6UiWkCT01AQ8dENod0F0vceJBUae0mGSYdRpCX977dZE35zHYTkZWwYlsTy+N26E0qlBr4O4qjT4qyQjtBt/+CE+1udRx0BNdMiSZc2mtcqQdtduLWbQz0IqvcWfHeeZMIijUKArfkW0I4HrnUIoxDQzmLnZnmsgNzMU0Bv7pQLGKNVlnmumpm5ntZONtY5FZG3ahp6NzpnF+CAyaQDzVfIM1AiOzFxHnLgMdktN63j1xtYx84EBwPzI7fthQqIo2TPXu6xEu5sX1A57QObI5ZZY3jB13itLZKIRBgYgNnkmwwM55YqQueghrvi8Tj+2krqVHH2pw3xQF+ctiiZcXUtHf7ZW6Yvd24xX2hjxK9qRTL3sH+
 v76yMkCp
 lvvlKAeP24CZXg9xRuoX8jvb4yJUhXSV0H+Y6X3U+cnyT8NJw0/ANN8h6lxhW4sPPFVSaPu+unYfXqiQIPfsCq3JHRLXdyMfE0+YV4AP8QvFITv+P8kud6SJ1WgM6CmYIxGEicPPl5HsxpxiMwdDGeozFlCzjXCNL6plL3j7Oftflf1bHqh5vCtdXfYCxT0/3zmvj0G8hkfSz6taTfJf0sxPZkbErQt5BBglF1m4ov3Us3515TwcL/iLspxSEJsKrcKwcLPW91/hnS+2LdaVAMQd0vWm7iku49JEvYcJwFxtDw15+t3zGTzrO+ICsZwp7vK36q6c21nIgngmVXxL7apk6KnNVNdwSimeGeqLOttxNmZg2f6aAoGP/OrASdlB8rWGSMcRy83QEeCkqhh8QTpyQIXTDh5PGTBKq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 07:14, Alistair Popple wrote:
> Prior to aed877c2b425 ("device/dax: properly refcount device dax pages

"to commit aed877c2b425" ...

> when mapping") ZONE_DEVICE pages were not fully reference counted when
> mapped into user page tables. Instead GUP would take a reference on the
> associated pgmap to ensure the results of pfn_to_page() remained valid.
> 
> This is no longer required and most of the code was removed by
> fd2825b0760a ("mm/gup: remove pXX_devmap usage from get_user_pages()").

"by commit fd2825b0760a"

Otherwise checkpatch complains.

> Finish cleaning this up by removing the dead calls to put_dev_pagemap()
> and the temporary context struct.

[...]

>   {
> @@ -661,7 +656,7 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
>   
>   static struct page *follow_huge_pud(struct vm_area_struct *vma,
>   				    unsigned long addr, pud_t *pudp,
> -				    int flags, struct follow_page_context *ctx)
> +				    int flags, unsigned long *page_mask)
>   {
>   	struct mm_struct *mm = vma->vm_mm;
>   	struct page *page;
> @@ -688,7 +683,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
>   	if (ret)
>   		page = ERR_PTR(ret);
>   	else
> -		ctx->page_mask = HPAGE_PUD_NR - 1;
> +		*page_mask = HPAGE_PUD_NR - 1;

At some point we should remove that page_mask thingy as well and handle 
it like gup-fast: let follow_* will in the array directly.


Lovely

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


