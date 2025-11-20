Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39E1CF9C7B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 17:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2466B0027; Thu, 20 Nov 2025 12:43:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092D46B0032; Thu, 20 Nov 2025 12:43:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9CA96B007B; Thu, 20 Nov 2025 12:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D5B4D6B0027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:43:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2633E1A02B4
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:43:51 +0000 (UTC)
X-FDA: 84131708262.04.15E2D18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A28240006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:43:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wtd1LUKz;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763660628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5K529+IW3mfatV8YWxaIFFBbWKaoKKreOwOQ6h6naM=;
	b=PkMzXhWvcOr9UbgAz5YXjeYTkkbNoE0HPx9z8bpMYPT9srK649D+U43aNYzFBsOz9agusc
	O7PWy2iEJ0Bxwr2qNA7s0WPCHXdB3mDBBF4mFKlYaI7sje2UEJVVopIfXYfggABd04vT3Y
	WwSSd1ctPUj1SZtbyZOfPLOgEb88nYk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wtd1LUKz;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763660628; a=rsa-sha256;
	cv=none;
	b=Iav5qKg3SCfjQQnv3OVyRrH564za3Lj8bWTn2movfLt3vEx+czOtUKjGsev8NwQlqyCNzZ
	5rsPFW0wXtoCg06chS/EXKRbtmRdGrMJunrv1SeuGWqvm4rblZ2PswNFtFTpxSBd3Ey4Fi
	CKepeIjVnQU2AC0CbPoQjh3pPga7Vms=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763660627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h5K529+IW3mfatV8YWxaIFFBbWKaoKKreOwOQ6h6naM=;
	b=Wtd1LUKzSjHle8XADzKy3FNIb+Wa/zXtxcQ4YoEMpq9Bprn7UXyhZN/ViNttQbyDtxtLyn
	95ALb2h5fIn+C5WIj5aCXI1qIbwt51cW0+X8rc4MmDIqm08d4nnIVgjOmu8LMnvD39ZxWd
	9ustJRyIXkWj2m+8kcf056Qr07cTCAU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-hLSfgbIcM3aaD3FmqhaELQ-1; Thu, 20 Nov 2025 12:43:46 -0500
X-MC-Unique: hLSfgbIcM3aaD3FmqhaELQ-1
X-Mimecast-MFC-AGG-ID: hLSfgbIcM3aaD3FmqhaELQ_1763660625
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4779c35a66bso8484895e9.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:43:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763660625; x=1764265425;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h5K529+IW3mfatV8YWxaIFFBbWKaoKKreOwOQ6h6naM=;
        b=Sw4G+EAiQuszBkiqrLOigMkoBWDk9GmKBsp3sYTuL4EW5EX/HVmBiprnPzrtLoVphv
         jZv3GKbXjm6XW/YldH4lHUD48PYEChOldyuR7u6kId2Mmu+w4I1L6fVyZA9PIy45Dkii
         CH5xOymH6B7WLydsrw3phT4PXXH4eI9naTR/aYNEPope4u+QPysTAFErw74Wlr+oqozJ
         a7KVbUFPJ7i82lEtL7uX/g5xVc9A6ik6xwAp+MEVuJjsYMt6cUnQTJilAT15U3XaMWHG
         CtjTqzDQXOApBccze64YzW8WEvu0F9rIPcMK+UTp3/vDVix1+dNiF+gwEkVDh/94PmT8
         Tfig==
X-Forwarded-Encrypted: i=1; AJvYcCWbRS8+/Ezq02ZFUyiTXoLyOGycUmDfpO7a/drxldNqM4E+vGxRjIG8AMIQnIbXCQxIELlt9OBDxA==@kvack.org
X-Gm-Message-State: AOJu0YzJwQYA5EU2VoNmTmv2PsAhFtsMoyoa+S7Aej4eLr3v6Ap6s4GA
	bkuCK4EH98HfTulQfOAZ5Om+ygOVsTr6ZzJePTSCLsRWUylA9aXxZv5/T3P83kZI7iVcVhJqx6d
	hnVVecHOK2xpjKf5IJbW8Qd1LpGY4D6p4LAyH5qjCXfmkFh3GwOw=
X-Gm-Gg: ASbGncsnP9e/1wQbORwx8l7O3FyzzZOJVDj/oIEBbbVgArCDT7jk+viXQkI9PTD5Z+W
	aRVldkZDJKm40iOAGiq4eGOaPjeJ8r0PymMarG4HnnkXXj2SXw+SrsixhBRYbgzAM7/UO/BWj/9
	HRG3mVq0Mq6dPBpvVEnWd3Jc78V+LUjz+iI1cUPR4MXOcbwvwElRGyce1VVWubPKW1JYrDpsw3u
	eVZ4UFCwTNgR1vZ5MQpSQoDhbeAXcN9TjIVZ3xTpmrikWKpeFD8aSO66iI8JtmcUgjzqUM5OVeb
	JtKnJYb9K1qgHB1o4EXXqYtZ7aU+yMy6LBxuEUBJ162lLLtIe30REzGSmTEKp5QkfG4ucFUPYu6
	QsqkYkSTV06fMff9SApCA/0z3zf/X+hl7CmE=
X-Received: by 2002:a05:600c:3504:b0:477:9e8f:dae8 with SMTP id 5b1f17b1804b1-477b835b953mr41784925e9.0.1763660625158;
        Thu, 20 Nov 2025 09:43:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEdAlOF06qo3jtRC/aQhNuMM6LcKWoAE2dGW+pEN1nNpje9HxRmH/mDX+HF51rEmo8eT5UOvg==
X-Received: by 2002:a05:600c:3504:b0:477:9e8f:dae8 with SMTP id 5b1f17b1804b1-477b835b953mr41784645e9.0.1763660624633;
        Thu, 20 Nov 2025 09:43:44 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1df392sm1633645e9.1.2025.11.20.09.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 09:43:44 -0800 (PST)
Message-ID: <a6d4dff5-15be-48e3-9bb8-00bb44dc5584@redhat.com>
Date: Thu, 20 Nov 2025 19:43:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fixup: mm/migrate_device: handle partially mapped folios
 during
To: Matthew Brost <matthew.brost@intel.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Ralph Campbell <rcampbell@nvidia.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Balbir Singh <balbirs@nvidia.com>
References: <20251120170515.46504-1-matthew.brost@intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20251120170515.46504-1-matthew.brost@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c7tJQZSsQddfJ2Hx7i9Ll6eKwXrwLYwjKPKtfp38Wy4_1763660625
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A28240006
X-Stat-Signature: 5bnonti7njawonn75z59czmsustm3d35
X-Rspam-User: 
X-HE-Tag: 1763660628-263708
X-HE-Meta: U2FsdGVkX1/RZj2E7JjSEE6BDW2KGgKCvUfFJs4wy3X+Oynf7rf1nuMzgbsM3d/vSQh2hMi39ACtoocr+ADyokJqXNiLQc/IyuYzQssLStCz7GCiY+mmSL4ADA6RDGzqgUw/af8Ar05kG7e/qn485eUSacZLevLPTHRISkIIZpR7aMaKXGfPrSa2LRkTy6Yo0M+svrPb1c22TSTjB6DU48hz1mJMcXOCuwzkG5laeJSjYK/6AXckosRsvtsTfh0QSQEhmL4ch0DytIl6uGIoyuSOM6FNnOirisds6yK8XQZSLioXxUCs7BkgtYdmB3c2MQMFM05s2UEAfdVdP1j8Y4SrKjUEqksB4J7ShAvGp2RYeoGq8mAIkxSfybFF7FVf86mreisR9VLSBTJ8E01FwsCCHlr7biej/PJjxy7keRL5mBaLtAzEkDmSUB4WG5NdgwlzPpZOIfv46C25BOEohEmEREr7cVsHCSCfsbOaDAfhIwuVcOyuLPs4v/mB91ayCpaSf0UvYFPPo0ewB/ZVFOkE4fpGXI5rYKuUGqDSNKk+Mx6Nzddkf2tapPGp0AUGyYeFO19ZEmJFIHdk3ykC2QqwJcxv/n0ljsjcHHJsRn55RJlPJcLbhe8HZPdXSOcTfdseS8OSm1sJZJJ9eqZPur9WKd3XdOtE7Cl8h3qE6LdNoCTUMdHpmH4APzt001NQR+8bOqTZgce+Yj7oMBYpLMCh71p4jcRZ5NX0Z8FFd5wOBKLxf0nR5uBP5LLfufJdcWu8sVde7zCjTPE1SEH2bSA9XW7K9Xm6gClI2cd8tUm/chBp7jR1dK5MG3CnL9nR3A/SyWx6X//z50BA4Nc0m9BOA7jcfXFDyzSyUX3EokOiEqxyFA/HgcosZe6vXUw+WyM5j4LBtc7JVosto+eTFdeJDaYEf9lqyfi84K+h1Cw++0DHMWrlLN7mFR54MlayjtXORs2XcDgu+jMSvqF
 2Zc2KrDw
 sAN+OhJBdfmNvZvLm7jya9P5bs/T506XhitBQ50xBF2cyuDshjgSrPVaOdklKtocK4wK5hTGos/3U4BMo78s2J80sJFT7cC9TGcYyVoZQ38ouDSUlH2P3XZ7WZJvuyDirotFTkEjBT5wAb7XH3wVlMf8+qr4VktNhBOaV0vf83e6GmmLYJn8TXljvZT9hEUoyTxR2hhCaToCQIX9uK2eByOxzSZs+CfZqxnb1jS8RFcxSsypEz8uuX4QyYuV63bRoMF/mGz13zBf2rUfJFCFwGnAnoRlu4AIYq/Zf/Asw9oYqc+//TbVHknwbHVXg7tCZMnl8SfZrV1Yi8/FwKVGGK9lBQiOaCSbucjSTghgKg0o5A8Z6peEJ+SUgR/A7gtTjrrBMpTJiIMTcQqvQf5tFFWlZmd4icXmXcZZst6gL7KLJLBcv4S+xA0vUqWG1/UFl10FJTeMnEptZL0/P6DSOwTCg75wX+vN3iJf2MK6OLmXMON0u3KgFfAQktPb1M9oMwkExP6JOcONHKR1kJEUjxEfC7joEpjnzpkjC5UkT4CYeQ/kU1qXeOyhCIMf4QfTfaMIk/ZaALYGWDBXReSLW3g0e+OLUCCWvQdGo6ZHt8JrdZGGQTX5SG4tPWgePT1DJwvmyERkTL6TVFBVkkFGuArVPUoNzrXHu6UEC5LOs1xVTFByh+c3GayFNXRrBiuxUtItq3389KnpBIvnTRhct+DSQAOatgyntwtu6zS3kQrp/SdviWG3uhcJZj6Yax+vbRc3tTnfAcCc3RlUGb4YQEZ/QaC9e3/1sTt+JrZhEfq0BplY63SikSY/x6ky+kumj5p66392mp1p/HcD24o4ZJCxEMGn1ORxsTmlmDnJ4Mi+RsGN3g875nmcBOOyAPNL68w1sVmR9Pm2/oXI4TFKNHmsMLlwRPAKHr0cK4rWdON8RTsAoqEJZpUYtDm06bs11uJDR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 11/20/25 19:05, Matthew Brost wrote:

> Splitting a partially mapped folio caused a regression in the Intel Xe
> SVM test suite in the mremap section, resulting in the following stack
> trace:
>
>  NFO: task kworker/u65:2:1642 blocked for more than 30 seconds.
> [  212.624286]       Tainted: G S      W           6.18.0-rc6-xe+ #1719
> [  212.638288] Workqueue: xe_page_fault_work_queue xe_pagefault_queue_work [xe]
> [  212.638323] Call Trace:
> [  212.638324]  <TASK>
> [  212.638325]  __schedule+0x4b0/0x990
> [  212.638330]  schedule+0x22/0xd0
> [  212.638331]  io_schedule+0x41/0x60
> [  212.638333]  migration_entry_wait_on_locked+0x1d8/0x2d0
> [  212.638336]  ? __pfx_wake_page_function+0x10/0x10
> [  212.638339]  migration_entry_wait+0xd2/0xe0
> [  212.638341]  hmm_vma_walk_pmd+0x7c9/0x8d0
> [  212.638343]  walk_pgd_range+0x51d/0xa40
> [  212.638345]  __walk_page_range+0x75/0x1e0
> [  212.638347]  walk_page_range_mm+0x138/0x1f0
> [  212.638349]  hmm_range_fault+0x59/0xa0
> [  212.638351]  drm_gpusvm_get_pages+0x194/0x7b0 [drm_gpusvm_helper]
> [  212.638354]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
> [  212.638355]  __xe_svm_handle_pagefault+0x259/0x900 [xe]
> [  212.638375]  ? update_load_avg+0x7f/0x6c0
> [  212.638377]  ? update_curr+0x13d/0x170
> [  212.638379]  xe_svm_handle_pagefault+0x37/0x90 [xe]
> [  212.638396]  xe_pagefault_queue_work+0x2da/0x3c0 [xe]
> [  212.638420]  process_one_work+0x16e/0x2e0
> [  212.638422]  worker_thread+0x284/0x410
> [  212.638423]  ? __pfx_worker_thread+0x10/0x10
> [  212.638425]  kthread+0xec/0x210
> [  212.638427]  ? __pfx_kthread+0x10/0x10
> [  212.638428]  ? __pfx_kthread+0x10/0x10
> [  212.638430]  ret_from_fork+0xbd/0x100
> [  212.638433]  ? __pfx_kthread+0x10/0x10
> [  212.638434]  ret_from_fork_asm+0x1a/0x30
> [  212.638436]  </TASK>
>
> The issue appears to be that migration PTEs are not properly removed
> after a split.
>
> This change refactors the code to perform the split in a slightly
> different manner while retaining the original patch’s intent. With this
> update, the Intel Xe SVM test suite fully passes.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>
> ---
> This fixup should be squashed into the patch "mm/migrate_device: handle
> partially mapped folios during" in mm/mm-unstable
>
> I replaced the original patch with a local patch I authored a while back
> that solves the same problem but uses a different code structure. The
> failing test case—only available on an Xe driver—passes with this patch.
> I can attempt to fix up the original patch within its structure if
> that’s preferred.
> ---
>  mm/migrate_device.c | 42 ++++++++++++++++++++++++------------------
>  1 file changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index fa42d2ebd024..69e88f4a2563 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -254,6 +254,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	spinlock_t *ptl;
>  	struct folio *fault_folio = migrate->fault_page ?
>  		page_folio(migrate->fault_page) : NULL;
> +	struct folio *split_folio = NULL;
>  	pte_t *ptep;
>  
>  again:
> @@ -266,10 +267,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			return 0;
>  	}
>  
> -	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
>  	if (!ptep)
>  		goto again;
>  	arch_enter_lazy_mmu_mode();
> +	ptep += (addr - start) / PAGE_SIZE;
>  
>  	for (; addr < end; addr += PAGE_SIZE, ptep++) {
>  		struct dev_pagemap *pgmap;
> @@ -347,22 +349,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  					pgmap->owner != migrate->pgmap_owner)
>  					goto next;
>  			}
> -			folio = page ? page_folio(page) : NULL;
> -			if (folio && folio_test_large(folio)) {
> -				int ret;
> -
> -				pte_unmap_unlock(ptep, ptl);
> -				ret = migrate_vma_split_folio(folio,
> -							  migrate->fault_page);
> -
> -				if (ret) {
> -					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> -					goto next;
> -				}
> -
> -				addr = start;
> -				goto again;
> -			}
>  			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
>  		}
> @@ -400,6 +386,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			bool anon_exclusive;
>  			pte_t swp_pte;
>  
> +			if (folio_order(folio)) {
> +				split_folio = folio;
> +				goto split;
> +			}
> +
>  			flush_cache_page(vma, addr, pte_pfn(pte));
>  			anon_exclusive = folio_test_anon(folio) &&
>  					  PageAnonExclusive(page);
> @@ -478,8 +469,23 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	if (unmapped)
>  		flush_tlb_range(walk->vma, start, end);
>  
> +split:
>  	arch_leave_lazy_mmu_mode();
> -	pte_unmap_unlock(ptep - 1, ptl);
> +	pte_unmap_unlock(ptep - 1 + !!split_folio, ptl);
> +
> +	if (split_folio) {
> +		int ret;
> +
> +		ret = split_folio(split_folio);
> +		if (fault_folio != split_folio)
> +			folio_unlock(split_folio);

I think wrong folio is left locked in case of fault_folio != NULL. Look how
migrate_vma_split_folio() handles it.

> +		folio_put(split_folio);
> +		if (ret)
> +			return migrate_vma_collect_skip(addr, end, walk);
> +
> +		split_folio = NULL;
> +		goto again;
> +	}
>  
>  	return 0;
>  }

How is this making a difference, I suppose it's only the 
migrate_vma_collect_skip() after failed split? 
Why are you just removing the other migrate_vma_split_folio() call? 

--Mika


