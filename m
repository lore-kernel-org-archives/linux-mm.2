Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9F7CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA618E0054; Wed, 15 Oct 2025 12:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A19C8E0005; Wed, 15 Oct 2025 12:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7378E0054; Wed, 15 Oct 2025 12:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 696108E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:26:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDB3F16022A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:26:02 +0000 (UTC)
X-FDA: 84000875364.30.B25E68F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf02.hostedemail.com (Postfix) with ESMTP id C74388000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:25:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QmwTasLp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760545560; a=rsa-sha256;
	cv=none;
	b=6rn6GjkJswT9CeU5IGQEpRGvuwWgeKsyaQinYZS+Z5Twivwidk7NkpLMH4DOStDFjau2uE
	MR10pDAv0P5Hsr7EPUDjsBQCNZe95BQPDkt/aqgC7f057EAXF5EdpSLf+aoZ8YYcd9d4eG
	luFo01FPa4eq/qC2h+zsXUH3bI3JgPg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QmwTasLp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760545560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35ekPIjYYzIReJcbi4WesQ7j07gzkbIvXHGJzCouMX8=;
	b=M1O0DrvXhZcuy1LUkCMz0QD2b29nCl1SdnzkNDaZJNX9fW+7yaG8SeUYHiSXJJ5ON7A3m9
	rLDv/yV52bpQsdLhEeFGRYJf0aSVZrAy6czCIgyY9lvufL6CZQwsSvLxACfCBUn8WeFz1h
	k7E91GYbJDot5aWnyKUvkGcOLUM82N8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760545560; x=1792081560;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZMHqUjjRMecUoMSYtZ3448DhY0XDVwqidZ24uC6AjB0=;
  b=QmwTasLp52/POxj5jwNLuly8vY9AJi4Q0AYasnidajdJ+CvhnMTl+ZKa
   Qe0+rVuE0tWt6eLF+3c8+4z9XXv2IoycEgiXB4pr6ZosAEukZRX0WVxXO
   ZUwqXxkKTuZnw1BaMnUaDak3NTQBKvPNlndauVgJcbXGXMYzybhPNDIa2
   Oma0bC5RMSW8R9iHyryE08KyHFt8XchcLnotrc0GTJn6ZVV31FTKDshlY
   gYSmI6Z7oNnalamheYT+/htTWfIjUQtnez0XGtdX0zMrfEYBqWnW6hsg6
   MGZL+zchLj4sSMeDfvlkpjJxRF3088PmbRczkmcXchxLDybJd6wGL9vL5
   Q==;
X-CSE-ConnectionGUID: e1ZTlfngRACCXA682QuVkw==
X-CSE-MsgGUID: y6ekSWQ9Tmive7rXWI+iDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="66378799"
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="66378799"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 09:25:58 -0700
X-CSE-ConnectionGUID: 4oqxeFpYQJaQbWtbCxrgeA==
X-CSE-MsgGUID: J/iikkarTcGc2GuVi06PPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="205919283"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.111.202]) ([10.125.111.202])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 09:25:56 -0700
Message-ID: <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
Date: Wed, 15 Oct 2025 09:25:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, baolu.lu@linux.intel.com,
 bp@alien8.de, dave.hansen@linux.intel.com, david@redhat.com,
 iommu@lists.linux.dev, jannh@google.com, jean-philippe@linaro.org,
 jgg@nvidia.com, joro@8bytes.org, kevin.tian@intel.com,
 liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, luto@kernel.org, mhocko@kernel.org,
 mingo@redhat.com, peterz@infradead.org, robin.murphy@arm.com,
 rppt@kernel.org, security@kernel.org, stable@vger.kernel.org,
 tglx@linutronix.de, urezki@gmail.com, vasant.hegde@amd.com, vbabka@suse.cz,
 will@kernel.org, willy@infradead.org, x86@kernel.org, yi1.lai@intel.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jaeogh5fdwmck99h9xqenkxsy6hxbemt
X-Rspamd-Queue-Id: C74388000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760545559-836306
X-HE-Meta: U2FsdGVkX18P5faBVg0wRvP5LzSm7LNKlAQem50L8eQEUNHX1K3r9AeyBYPL3qQ/bG6pNDMVgxvzEhsbGy8actxdfImOVvuTPyJW8D02/YfuUlEazbM30UCqjECNgAOPpybONd99M3QXTzYfPloYh7vChhgZt+UEqG/MaZP9+YWfusyMqYysaxfpnKCseEfgRdKyb4s0XOisBJDXk9es7wne/lgD/xskuD2H2SPKkBQa5Y3CoiaMz5y1BerEVdlDnhRsFYmXDVCODZElzm3qW93qs1pbJO56OEQTzwE5JhPhJGYzklCxxASijvveRxJQAi+NZmd8abTJoiK8uhnvoDRUKsaJkrjxkFr89KVLZdjI+9upY7Z2RQx8c8Ua1As/IJ81K3u7icFmRUM07s+SIXtp6gXZFNwMW/0mmErtKWcPtIYUH18BQQKFGOrqDWDRqudEGpcvsePrIE3vSqlav0znAtVBSlH4aJwxm1AKVukvndpjEI3ZNu+rRqc6TmAW5vwBbaVr0PsYMz2d/Bxn6aR2kcOnMQb0biZ/Z7X5S/PeqgFim1UhL4XnQtjSjZ95xhrtucbeUL2dTB77c2ARzrVFbJxWY6xPaJvRHq8Wmv4vv9Ol5TxEWj51mvqOsriK7jX8BPiUWq9W1YSHQaC2c7yOqP8Hzq1x49JaIUUw92xEMkQmsHDDnI6EcWlcj/S1/Z2k6/7NBwrz5SxE6YrxLPugpIhx2/k7Cj17NFr5gf/r8o6P5xYU9wc7J8jr3SrMFqhrzNf1FLE70jITok4yTVb2euhyWP8sNbek+0kx+5MEdEKnlHdYqSL5lDYu+EBKj4zJ40INPBKdWhqL50Q+fc5Qgjiq0ausgrAYR9lk6mQSPbI5QhJ1gxGu/9GSq/GTdQXiDAHS9A6LIhlhrygJLarAWMHN196oylh+P5W1MLhI16aWNf3WIuWsNhAPRyqu9nxu85q3yrSK2NT9XjQ
 89h+4QHu
 Ia542xF0G8xBchBsmINCUBYQSCxdMcqBAn+cfdfYZIChrKQw0z79vvJAvR3DGZh/Wv0fi+4iUr17H0ibyZT+p9Om1RH/1HbPDJTL8HYt+YEpUAsvlDyuzckxVdZZBcFcr7H2NXvgoL7r6K/GIsIRft740Qm0E4xVs3Yiae28N5bi68CFSxXrVNpijncodusmHeUwSxjU/jS3g/jyxohpxKJq14NMl/cMNnULv5Pkvp11PMQ2dLwvhrznU712MyO1B5DDFNxXTzYk5a3m+9M7KYqI3Ozrr1WDnOcwHVSTFpu7ipiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's the part that confuses me:

On 10/14/25 13:59, syzbot ci wrote:
> page last free pid 5965 tgid 5964 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1394 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>  pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>  vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
...

So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
stuck around so that it *could* be used after being freed. It _looks_
like pmd_free_pte_page() freed the page, returned 0, and made
vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().

But I don't know how that could possibly happen.

