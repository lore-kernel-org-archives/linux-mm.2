Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F3DF9D0D5
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3256B0092; Tue, 14 Apr 2026 11:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA986B0093; Tue, 14 Apr 2026 11:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0B16B0095; Tue, 14 Apr 2026 11:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4296B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:14:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A958A140160
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:14:56 +0000 (UTC)
X-FDA: 84657508992.14.112E1D3
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9501E100007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:14:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PG7La2aZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776179694; a=rsa-sha256;
	cv=none;
	b=kEJF92rhKTJPJCXW3Jvz7vfrvw7YI35XX/4uF4Hqejg0DfdXUVaSw/P013DGW8+cwk1cPm
	Jh8PCN4CHsofezBNUsQ76T33x0P4og7d3wXZGauKiIBOhAEDAmEvaFt3JyN+9KyKb3ILWy
	+5hu+OOF4kI3hCbgZblatFKAsI86ZHU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PG7La2aZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776179694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiZcenKcp+uZ2L86StkfQt3dH2YY/Gv41Qwo9jPIrBc=;
	b=KgaJhUPmmDoXsSlEmavPLx2uHO9IegS7QmAi3tXyXXMULtHjBde88Ea7Bh5q0w/8EWWIpi
	oWul859iSIlqs7zDk2y8evMaR3y9rWX1JVPHPiRTaK/vi2IjuOpfRdF25Y6XilGpSs0CBx
	7QgT7mCQeXqT9xem7gk/qbVbKPYsNN0=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82f431c0ab6so1001838b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776179693; x=1776784493; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BiZcenKcp+uZ2L86StkfQt3dH2YY/Gv41Qwo9jPIrBc=;
        b=PG7La2aZjfI2Dzl1QQol+yy+mgy+hdFNRLw5NImn5OJ4tJvvO+WQUBdr1FnmfOFvuO
         LCemckZsvXdfKoZeYARnOuLZc+FkgKSRmcOnRWVrXhO1cInoo712Z+Yx2zSQ/GgP7sKv
         3Gopf9IBRlPbV9x6Lvc6Wx9RqgEgjeiCin1RyaqtBGwOC597YJZ8sLJxnleozZdi6Jvr
         8iL1mR93f8rBRjjyCJW+bKbZzTaQxzUsTzjHeDenjgbTH0+pKSbYz8siXd9sVEqEPzM/
         8SxrcBK4XehSvcH3o9kjgtnV7Usn9gFy9GAuqZpVycYoX9fWUJDiMSEu2ceFB5Cw9HIX
         KVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776179693; x=1776784493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BiZcenKcp+uZ2L86StkfQt3dH2YY/Gv41Qwo9jPIrBc=;
        b=tTm39umBuAJ8W4A7pfLAC++SONorgKGJkr4XsqwpWag6J9yezDXjqgQZcw62/6p+iI
         UfhPvQi1jW2iy1KmYCT5eT4kEDQgJRBwQtg6U58Z8Oej5SHn+QvY/HIP9dbtDnHI5r/j
         Sxz2B0Ogr3VDzPknt+StNoOTFGWh1CR4vHFTd3St3f/sXgzO+5u3xpGdZLKFQhF3FkoY
         a5HMXCnAjvMg+bvl7IQZjzBwyjuQbrnsW91yq6+ShjG4K6syoZXcNPoG7PKQaFWybTxh
         IjLrt5oeBidsIDN8HD5XiKhy/nJJ9lRv4zm/7WO8ikQEkwtlJGsE3XSx97xG0Zh8itOn
         hx3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/DthuaYTFUM9wftLv/AhA7+WPJ+qjiS5DBzf8Cw6mrFNaBN5Kizej1Cp0KPaxHptIZj8hesIrB/Q==@kvack.org
X-Gm-Message-State: AOJu0YwD671qyEHr4MOV0BLk57VfBE4qa4sayTL/7jTjJ9e/e7phfd3R
	DBau7c7y2iHls+1UAxVOTLbjQstS1pi19+ixzLv6WO3FV7GyNXO5DEKt
X-Gm-Gg: AeBDievRa0wFo4jtKGngpmG8ymnN0lpwH25DYw1dzNeUfWyVfrWkCsVcoXLBO2/XI4d
	x32JlHhWVVuKrsFoA+gRm3MJV+6yAYloJdXW+gASgkifLy5W29BKLHOVIWoGh2N9Unt4dVxBOXN
	Zgkot/zUOAZHz/1a0xHoaczTS9sPVYxtvzZnLPTSuOr7G1aLKATeq48kdTe9q0dmER5WAbMLiDr
	/lplrRD8VzDJfii3ISxkQzlMyohMbrn71jrjv8HCZ0GD23cz3S7OuIYJwPlaoVddOG95DdzoBxR
	9xjf9uV2XV3s16tf6P/2PpupwOtjy+/9RI+2ilJ+c6apKabSoBFu4QtE0il3KS/xcWBsnlk0IV7
	ozPYMNvLueF8XY41hp33VnKTtUmfT54wuBn2NDD3JvPCqyDoITnSixkSFzaUXp1Az+gOU7u34qB
	q6cpwnbM6ZyflkB5Qhy3b0s3a3APh0ulsuPGsikd8f2fM0nwxKJc1yWjxrET/XwhZY8u8nmLG81
	y1Gl9iTjR62d5bG5Mkxo/FQ9IB3yIIgu56qnM13KO4=
X-Received: by 2002:a05:6a00:244f:b0:81c:446d:6bd0 with SMTP id d2e1a72fcca58-82f0c28eebamr17636274b3a.23.1776179693156;
        Tue, 14 Apr 2026 08:14:53 -0700 (PDT)
Received: from [127.0.0.1] (211-76-176-103.dynamic-ip.pni.tw. [211.76.176.103])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee4bsm15916663b3a.2.2026.04.14.08.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 08:14:52 -0700 (PDT)
Message-ID: <6125defb-3aa4-494c-abed-982be684f839@gmail.com>
Date: Tue, 14 Apr 2026 23:14:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
 <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
 <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
Content-Language: en-US
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9501E100007
X-Stat-Signature: 6nopoge4nn74j9j4s5swptc7x3xgtqpj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776179694-841564
X-HE-Meta: U2FsdGVkX1857aJjNUhEbE3MOjECBdu2sNyjOwjqW6o1tQP5QJQ7dk7r499EJxRjTSFpNkezJYIh0AO+syL/5kFaJsdFd0vDAmIl+mJn2aBV93qm6YheqG1MMJBc6uFCRMMjvLmJY2qg7DTUpb8OW0dxZD9D7v8R0zHyXgggSU7orC+NGruo7EhFT10hh1X/vEvhKvpmH2Yl5PsoGj+RPL/6JUZC/Sb8AVseeouUFF+V5FAy5Q3jSz7Ril0Fpaco3hVatu7A9JTCfp1QloKHfvehm6eIuMbkqJS9//loX68n6+WuCxMQiO0bxfEPDYEop9jrUKWQS44vdnBgyGHY5r7Q83ZtHmyew1m1Rao983C81n2NBovFe921Exm4QCrkYd0eHmIYfYoni+plSfVo1dAjthq46RsJsEKiNNUiczR1SGae8jeogyd9YW8zl8qpc3LXX7ld1TvgBO0iosE5vWEYTAFYfdpAx21nXUdAfwH5ZP82qyogZYWIQ8jsCmwuhWJTKJEkie7jJVRPHZGinvxHoULkyOC6Au4NhLLbmLKsuTuoqZVFhqXJZsOQcYoTf5/oTYtm6xM4UL7eLHAMGfP0YdU7Id+2HANPL7i/Y87Kwe7Hix8WwxukU8ADy9zAM0YPDqIMdc5AgtPZW7A3LUmhkxNXbU+56UisbOsG9dwjy+9cXW1cr4nVJ1ZUtgFR7hbx/apwbipEpv+bCn2NZ1gQjWG2OPl75PFfIsL+Ggyx29ZkxgCvLi9f16eIgMS3kCia5HHcrrzs32E77C7xiuA3FNfGVapAIAssXj6eALT4XImhEv72AnKhu/fKItB8N6dWmN+vwTxBKf8Nbc9ziujEJ9qPgzq2KlNzGiNzaho2ycy1jKqkeI0cIcPUAtsaphY1u8AodfaDj4rN3UEjxhobSLtK8Dbr53peA/ScafLIl5lDNM85YmQ16iOsWg3Yvtz+CqPeg9AQBjjWU6X
 KPS1tXFq
 DEMWa/43AbxvtzZbqe7GCmUH54mVQoSduejCBh9k2R87S0a/i4J0DaRjE6xCa1bbd8C+TgrcCbJ/atmzAeMXxYwW0jSSvhDvWlIeU9BakmxEEc0yFoCBaxWCkg6PFQxvt8sorgFQBBgfD3EsPW8FzD9w9bgiV/poDWK8cLrlobGRw+qiqxzKKNPvad9C5loI6CSxhpCC/cqpm5X2Rv7Bjiqsq7chZVqiHrriSmDykJAsBNlXlk2RshR090XgvMcq8v5OtdO8SphWyuf2cpUSp5v1I/ivarDQ8gfpS0WsZ1c8f4HqeCJT9UQw8N1e8C9qsYu713H7WXrS9PsR7sJ1MRWss1RLm39c3PmwXgjWC5S8rFm8FdpbajQItAVYi/r/l58Pnlt3+UFia2w9M3yQTfMtHMUpW89VLbg8r4ce5CRysDAuUDwxQv2OTMeF1RsRuTjymTXpxQoHJPNiH96pDBV3128sfPGFjcA/EsX1nX0rscWJWmVmFBuqkIc+rzcnCdhXtjXiD2m6igWPU9Y8obJfn4BfU6POXKYrQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 17:44, David Hildenbrand (Arm) wrote:
> 
> I mean, we need some indication to know also during folio splitting
> whether we can just discard the PMD, as we can refault it later, or
> whether we really have to install a PTE table.
> 
> What if someone used remap_pfn_range() on some part of the VMA, and
> faults on another part?
> 
> Doesn't really work.
> 
> Do we have users of remap_pfn_range() that have ->fault set? If not, we
> should probably just disallow this combination.

I did a quick tree-wide grep:
$ git grep -l "remap_pfn_range" | xargs grep -l "\.fault\s*="
arch/powerpc/platforms/book3s/vas-api.c
drivers/infiniband/hw/hfi1/file_ops.c
drivers/uio/uio.c
drivers/vfio/pci/vfio_pci_core.c
fs/proc/vmcore.c
security/selinux/selinuxfs.c

It turns out there are two users of this "hybrid" approach in the kernel:
1. fs/proc/vmcore.c: It pre-maps via remap_pfn_range() but registers
mmap_vmcore_fault().
2. arch/powerpc/platforms/book3s/vas-api.c: It pre-maps via
remap_pfn_range(), but registers vas_mmap_fault().

> 
> Then we know for sure whether something was installed through
> remap_pfn_range() or through a fault handler.
> 

How would you suggest we proceed here?

-- 
Yin Tirui


