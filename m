Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D99CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8608E00E0; Fri, 24 Oct 2025 13:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A87B8E00C9; Fri, 24 Oct 2025 13:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496E18E00E0; Fri, 24 Oct 2025 13:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31B0C8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:32:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6DD55DD1B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:32:35 +0000 (UTC)
X-FDA: 84033702270.05.5C01861
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id A94DE4001B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:32:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TwyPgzHx;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761327153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68b/g5DOQEfyTkIlrk7BVq23q9O97J8PIirLY9E/558=;
	b=CvjFDqlpM7BHgx0PHvu1pM69JEt4hjovK75lk9/iixqGlurBYB+T79X9kXear+g7n06qnS
	+58Q1vXuNkhNIutJqKAf0G2eFqMJjNRjeMGtQaMd7I27+UsMCsn5QeRTNt8Amb4ohxoGjg
	W+Bc7NjfFrHRQYshmFTDYFnC28XD5a0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TwyPgzHx;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761327153; a=rsa-sha256;
	cv=none;
	b=bWrsr6mCw7zuMVX1n44KvODxBvv+U+vqBLNy4Mx+RisKDn5Dns5d9WWJTuNR5hP/zAChcx
	vEdeig9O5I9VK+1FB1oIhG6xIkpmdIFrcJHHb5uImCTUmq2JI/g1tnOArxcMtCBmPEs0He
	B8MuGajV07BE2StglW0PZTJ9PzsZ034=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-89ef0cec908so12655285a.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761327152; x=1761931952; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=68b/g5DOQEfyTkIlrk7BVq23q9O97J8PIirLY9E/558=;
        b=TwyPgzHx/Es254au6mpgV0MaoKQfZ7AUoPHnan/U/Q7l9lD9Pq788C5nLseArGbYOJ
         65gqMu029BBnbZYFUhjpa2iPiCmR7hHxanI5ui3jxIbc5beChXmNmN0CisktgDYUHEYV
         KrdasXSHtBoXFNJCI+cn6XfoXmu/Ki/uW2qUhfMiEtoFfpR3Ps9uS74PRPcUOLO0ov14
         JpN0NypG/2FnLD4Wm1OQBHlWipwvKYnQGGFP3ImjAPsF7az4nkbF+7qEj1iwIBXCCr+T
         cjrtgIAplUatikD2w05O3SSM8GiAjREt+9LkeWHzWw65/p2FOhL0ZoUdYjZ/kqEjx7ua
         FjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761327152; x=1761931952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68b/g5DOQEfyTkIlrk7BVq23q9O97J8PIirLY9E/558=;
        b=MBtRAgVDRVvFR4Cqu6e+2xiQFkrejougsVNZOAOXRMd9mXb5nE5nhMrdo3xFM7Ab44
         vyFlOgp1AVGrULBO811wZ/3lmg8oN1DNp4WHIwFlX9Y+JYmnNVQfx57/fxp3kFQmmugt
         dK3L7ekjYb0o7Zxlvr3Kw5eoK40is6jA6fVCZVnRH9CJEdWTSWpVHU1KRhXMKKNd/5TX
         MFJwpWarCYwldvEFjgRI0YUgGcjVJDob7qKzQ6B5ctPZ66Wyo70ibs2zkEFCZFaq48sn
         SjHIbzMNRIVwuwzY9PhGNbkdKB1+OUK278U15fRZW4A6qPVziokxjwGRixL1y/IB5imK
         3cJw==
X-Forwarded-Encrypted: i=1; AJvYcCVbUotoUuGhGWKP9yyVwxaOpdcjx9DT8E2UiOhQmSqGtj/DPljKgGwZGXtLT0LiUPz4jYdHJOebbw==@kvack.org
X-Gm-Message-State: AOJu0YwyiNgUJYdRsm/ehHYvHd/6ySMFdMqCshdvHy0TQ28SYh71BIqE
	9GdCXDb5qyLUoQA1iXGhtko8Mtu0zlv4eyg6OBIvxntSvFgrxpIbif0M+OscD5V5wUc=
X-Gm-Gg: ASbGncsKQ9XNhY9YypkRw7j7m5oiMU5DxE0OiBO+zoOmnKevIxkXAMtkEB3+xTYeNHk
	nYJKSdvZPNje8XYjVgTBtPTF1bU8dWn6j/0bpltxH1C2hUhevL+ejusmX3QO7FJ/3fliyZYVzmG
	KGUKf2gL8O5JwcOmDc2oOIod6qFUapqzkVFHmJuFnbTkwcRrtRs7dvZB+H1bgI4QUrUSxy7Zqlf
	lnlxlpP7TrL0zEIt/1w2HryRK43U1Z1vF9s+kkwd+hddUH6Yf5PXOweMOhqPNIKh8HNUPSYFvQc
	UBhazibGwyP0rfXURIrOCPUI9jRYfNhNQIHuqPVodhOFje4L/RZkeU3jX2E0XAIyaoZr/ofQcds
	mk+D+vUbf0FWQSoBKpXLXJqf6gPZIxIGYcee4DGuPmgdQsaaI6ku5FiOWWqJIcre8TzCAPirjhh
	SKhJv/Hnr9YHpa1D6biaRiwGj3DhrKczHoNxvg90Z9lmyJe+ofaFAIp1cBTuUMNdRhDrUUEw==
X-Google-Smtp-Source: AGHT+IHmBN0+9+r5KY4AyoghUj0jEXWjqZKGqzuPjvXeVNzt6iAcmzIlgz93IE1ZHjH55zZ3g6T32Q==
X-Received: by 2002:a05:620a:2950:b0:88e:aae4:9599 with SMTP id af79cd13be357-89dbfc9f46cmr377281085a.10.1761327152303;
        Fri, 24 Oct 2025 10:32:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89eadc0ab82sm58312485a.53.2025.10.24.10.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:32:31 -0700 (PDT)
Date: Fri, 24 Oct 2025 13:32:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: A94DE4001B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: py3k5opok8t8cnkix33xmo7kyx3knmg9
X-HE-Tag: 1761327153-747384
X-HE-Meta: U2FsdGVkX1/M5ut15fb3UMAbaFA+3wVZDry3VZcNq3VTfSjl843q2nlGYcZukPekiKry6fDADwXYZ6wup/9GUMA+Y+pmEhUBN84M/DVolG2dCUhiIqovQte/3cXRDZchZBOgQT0elEVMeYYH2/EKAlvSgol1ZKr+WMl+tRSEx9WESPsEC3dPzx+tdd5HxEDEfJHrqwqbpUktxiwCbbYBRTs2rBL9IOnZ0IEHdsM3HDayQ2H3yQ7jTbOkBqtBeyUl48vWhiAutqIA1xQ+ZBPGr340hkQuGn9RcuzE8dUnpMdFoYQjaIiyhdAKwkZpMkPtMDKXpuo8CjmyKp/r682WXywJxhsrhNGWVREYgk9/QrLMZgj406StFY1m3tRPLX9OHo3fCvImmk29eu1bxJlvjPKg1pR7q1mS3qhlGJP5nBrkBBqXyrHVjlC3ep70irTMorzxzB8vK6x9j9NJDKwrCNlstcYu63PJ8D4pyt9H1whXaTK8OYgXmd+F4rcOITGJJwaq5o74/U2dI3Z6uF1WUf8O3MGrsGQRbCM/1ywI+NXxNWB2sGh9tKoTQp5RCzrf2BPZxBImiLeQWlWNjNXqHWRXMMVhBReH4oemrZMb1J0zG6tSbH83rHGugCEehxQkaVY9oBeU1C871FXwdqve64oQS9fLzjrmA9G5VF3e98gFAdUPq/ixPgCyec5DvVjrjZfHFX4ffbzJAjPqC2wqzn3fEaHBBDGSLOf6JfcVbBTpux/Z9oMEUruy0xSt3tSxlNTuXuE4G9F8itPnQ70JUBhWE6rVwvzNITEwovfcpUW/YkiSqb08Waih7in7YXvPq9IQBkVFtgr5GjaFQlIfNORnZDhpFJsu+m6nFsy6hcQt/mp7eg13DKB16HQgsL3NurVoBVedqj5WtinakMpPHDYKnRPyDWO9OHk596aVgWh1sLzeBfZu6ZrNE5wY7ekhzMcfQY7Qd0dSfK8xYjX
 DMGAynBm
 VvqH1sN+/9D409Up3kDoIgeh5mzxJMmtPKWJoEoC01ED65N8jex3gkMAtgwUyVqES3hNcvlN5io+/a4RPISKw8sSFrPz18iMtU8LjvXQ5mmXiQ4g48XP12r/VyF9IZX4s2yvJMNtWp5GdNdnryXrRj+Jcv7POMe9YrBFLgqnJu2Q3cd5MrZ+UBxoXS8i7rxWAiz2utrW5ANOd/p2N1GrP5ap9xI9TeO3I3/ivu3OiAB0x3xoef6ZXZExLrjyAhGFwteTl00X+G7BadV2TEynotDucQV5JI9SqHZvFwbr0MC8XSflI/okxQ9DksWQjxQyZaCnQ/b3f1AMcCUE0vCistoSB/E5Go+kDM5IwfHPLiIZlFnxuu8k/J4GYpUTq3wppWj7MsLT24g5WnUbqfdCZLNXMpwmgDT/9IdY+B7AE1wFiMBfr1f0Bl7qQ2vm8u66VROXFqoPjJfvwmj2m9Uv4qKMw8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 08:41:21AM +0100, Lorenzo Stoakes wrote:
> Separate out THP logic so we can drop an indentation level and reduce the
> amount of noise in this function.
> 
> We add pagemap_pmd_range_thp() for this purpose.
> 
> While we're here, convert the VM_BUG_ON() to a VM_WARN_ON_ONCE() at the
> same time.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
... >8
> +static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
> +			     struct mm_walk *walk)
> +{
> +	struct vm_area_struct *vma = walk->vma;
> +	struct pagemapread *pm = walk->private;
> +	spinlock_t *ptl;
> +	pte_t *pte, *orig_pte;
> +	int err = 0;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	ptl = pmd_trans_huge_lock(pmdp, vma);
> +	if (ptl)
> +		return pagemap_pmd_range_thp(pmdp, addr, end, vma, pm, ptl);
> +#endif

Maybe something like...

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
ptl = pmd_trans_huge_lock(pmdp, vma);
if (ptl) {
	err = pagemap_pmd_range_thp(pmdp, addr, end, vma, pm, ptl);
	spin_unlock(ptl);
	return err;
}
#endif

and drop the spin_unlock(ptl) calls from pagemap_pmd_range_thp?

Makes it easier to understand the locking semantics.

Might be worth adding a comment to pagemap_pmd_range_thp that callers
must hold the ptl lock.

~Gregory

P.S. This patch set made my day, the whole non-swap-swap thing has
always broken my brain.  <3

