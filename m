Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2F2CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38246B0088; Wed, 24 Jun 2026 15:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8CC6B008A; Wed, 24 Jun 2026 15:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27196B008C; Wed, 24 Jun 2026 15:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2E7D6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:47:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18A6D1A03E7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:47:05 +0000 (UTC)
X-FDA: 84915839610.30.C4FD61B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3CCD340002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:47:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZPfrZqdo;
	spf=pass (imf17.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782330423;
	b=zYP0DYQm3owbowNIXU6aIqYkPiQPVHnIYLm16qlKF/ay2ZAnapWE7FZxjOKJnuZxG1tGLe
	7UncZMeVT3dLG407K2tODKvDExKg5FxC9/1J3NAc+CJzlpJuGkONio+5684AC9hxjDis4e
	LcZthGdP/xxI6jLYuADS5nAafOWWVEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782330423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aGwSxMPCxEakwoSKIAkNM8dD8i9uBjtEeqjT8n3zZc=;
	b=51iO+xSPEdrEbgidjeuyUlMvt95NwKf5RW4BZuIA5sFMl5XOlfT7rewMxxiyTLC4DAMapy
	0PxYZ4WDzJgBcs8lIBHmiUI4w7dp9kDHWsjVLIEHcF2gvV8oJK7/itcG1h1FasZ1u9xBx7
	sLYEn/BoHabsHyYpXnavh659wd6EYCw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZPfrZqdo;
	spf=pass (imf17.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c7eb0deeecso12025ad.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782330422; x=1782935222; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2aGwSxMPCxEakwoSKIAkNM8dD8i9uBjtEeqjT8n3zZc=;
        b=ZPfrZqdoFc8WVW81Wo11RIwrUrOntPbHJFcjLQKPMGyoYglGcHJqwx/tAyGKSRIMxI
         AzDrAAfSaMzK2M96JPQXOK2zErZURCn9O97PUDrItpMRU1CIwG7mifZYnihL3k5XxavO
         nnVrG5YUxjBPevzhenJ/8HvvrZwYXcKQSYv9HyNmq9S6I8owNwHT00UMFCD/wJxQ/AnW
         vm0PqiImR1fGIM7gmJbLGPuJ8UaiWbpdr8SBiwSFbMAjLJKbI2FLeo5cWs954d7LhaBJ
         uN3QqohssNJfYyse1OltT+cov6dsiuxuI1d0g8dDK0ledhlsJH1MtPASrHQEX6k0uZGS
         g+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782330422; x=1782935222;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2aGwSxMPCxEakwoSKIAkNM8dD8i9uBjtEeqjT8n3zZc=;
        b=T/jDvK53V84lODAiqRzO3jDSTPcmVh9T0O9NivgYBNz2I94c3PHPYzpTRqtf4gBmPO
         Esy5fRa25qbpOqac8BuUhny6nOZUIZYkw4k3CzOrpyDWRxGNR7aQpFkRmjIGm3Nqizrq
         N1zsGZrFYtX7nfOLszvavrP6wbjZKHUobEYZKZ7GdFuw5XZz9njnLN2qJcox3hZbq3jm
         iqrsmxvrz3X2vLtTz+cQqoRbq2X5ENxmE8Ev6S/jJF33Te+EZ+pdiv4kApEcU5Zvn5rP
         IXDIIU5ThPEl1Jny7Zb4+7KdqrFobRggQWL0takewRQabMXL7pHwfO6XL6+pdoddYUsR
         9CHg==
X-Forwarded-Encrypted: i=1; AHgh+RrpjmCUNzSzhCz1YD2h3hKUT/GxjPtDtAOz+GgFWaXM+nCGnYDbVbgqHgTUR+gDtkNp8QF2M3G2TQ==@kvack.org
X-Gm-Message-State: AOJu0YxRZpMvteQaYKZR2KeY3bwmu4vnwkyeMBbHBtNEBY1QG5Nflagr
	xiMB/2qN29efHc0NZ628XUR7gs1Xdzu4xc3YrNzsupXKipOt+nSd0HsAMGaWqod7MA==
X-Gm-Gg: AfdE7ckHJPACjvAUGY/AxGDkh4uS+Jo3NxYHoqSdedvoDuXLiXIdcjUabe7b35rZjpC
	Ba0z4Cn9QtWuGtRPvpk7OPlduzK1NC9DetUs3ZPKWwpLsGg/T1yZfShdMAaA/wk+93+Gl8qygmg
	B/WtSED08jA9Fe6wOitezoAURDzr9vBLmWCocIevhpNB3YUJYt53F2o+fLVXZNIGctnVYKCaye7
	yehFzlUL93VcwK9TyPSbpgTCZi9IacRjV2R7rSZYg+wpOlgk/bY10l3sJ2WTEnViO5m8f8GirEl
	bwz2FFfwxqpEpOxmgofNFEvORlJN39GMV5VgKYNJnsoia7cGoeeVrOQ8XS/SxfAU7jI+63K7K7e
	AteTlUg8N//29a2X7awxYAVrtUcL/4ydzzBEb6qPt5ig9ULfDUZuHCVe0i7QuUgGsjoRQ8Tzi1/
	jxDctZrHezw/wibjLwMwWliu9VScu3/HrG8S8yUNgksLgXxo5Z6uHJoPNk5EWYZKPDtanpIv9BO
	FMQc46v
X-Received: by 2002:a17:902:eccc:b0:2c7:f348:2110 with SMTP id d9443c01a7336-2c7fada6dcfmr14055ad.5.1782330421347;
        Wed, 24 Jun 2026 12:47:01 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5b07bdbsm4752985ad.36.2026.06.24.12.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 12:47:00 -0700 (PDT)
Date: Wed, 24 Jun 2026 19:46:57 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 1/4] dma: Add DMA allocation preservation KHO ABI
Message-ID: <ajwvUwWo7j2Bsx6f@google.com>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-2-skhawaja@google.com>
 <aicBp4tSyzyYBnzn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aicBp4tSyzyYBnzn@google.com>
X-Rspamd-Queue-Id: 3CCD340002
X-Stat-Signature: rkx6shb8bo4bmo7rtxe4s55j4md4uogc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782330423-695463
X-HE-Meta: U2FsdGVkX1/3ZezCF5sLJXVRqSWoxSbv0YDluseTV+ckUrPHK0hgrmx5mSvEysOzidXpXonSbdn244E159w4UDrTNjs1bhkC19NT+/EzJEpeGLKb3WX8qFmy8V1ke79m6Anvn1szEV8UbnA23eHc+xn3+k5viw+VlIA8xNnOB76/FniFzsGY5DtquAHXqUFNNEpsJfJq+iDwX90fM1jemVY7R3oGgs9fKMjTJFAmsxuVjQHfTPWtNsPl/mgGWRP9cVw0EJqrVuqIvn1dp0oyPpmmGngEzOwYBAI24RTmVewe2USDPQGTsu8CI7dkuxQLpOIZiMMFD+RDwxkUaff05oZa67rU1PSEcLuQ/uu9L5N5hdZhTfZHLE2g98xH3r85YtLETBylqWzFzVGFap3QfysXe41hrj5zVf27u5CAzENHsqzRMb5n2Z1uDJ2+3Db52rtybJJejQlkvOOgPE4K4SH7v5sGT/bVLomZPtfZeOj6z//veOhu0KSooFmsrRPW1c4JX0n3dfN8+psOl20Uq11BiLB6GtbomkGlvCe45OuxIwFUZ9pAhDnhLQ6XZzRFsYKJl8CdEJzxqS4crxfR4LjvH+dPJ4PLpsQwSuwkCd/IybIpppplIRxRO97GfxlE1xMI9YvHhp8N2QXlxG9Rh5a9qekNOVAfARttZJnD3ly/RpiZe/Z+2IzYHivbOrRIfQhmPQeBA9HjqZJMhc7UlVd9H+XR9HLV6d4aanHixo97yMoTZz945dwaE8hu0gvKDrWq+5sxx5dnm/0JMmo+DpNC8Fnknsg21U71i/IU0jlg7S8hPkaaix0cgwHHLkt5vrq5YEjza4CJgKpTOSkgpfPhpal6F6VBFrHKVgLOUgm8+EOKIYP/k+ap8nX2lNYzrU/medq61UgZ7RndLOv5S4hmUfUmHQqPKBdv6VifPdUIxxnk9yUpQmYjsuuARLgL6i4QXHqcZ6VcazyRZTl
 QElf4oOy
 QF6vgnV3P0drQDlYOoYMYDVUEgQN7pbbkj2aZYcEuKDu6bIYbd0ky66gPm995azRfRSuoNgv1DaW0gkBFnkWotUNJ4B+/AECOFG2NIlBQ+mSd23ThTyg3pxqcaZ3Z0K9YhuOze6Uxnj/ygdk/F0ujaXUWrs2/dF6/JKl+hcKzEGvTPzXs8yE98DdXAN0ABJ9osWWvDrp5j7E5NAa8dLAGnyM7rvahZaY/68LqgfX3LiLNujpX9rgLrFdB8Yfp1bGjXM+RqExCc5m7Cx11W4o7FU8ZstRsl/7F2LZ2/7jTYBWEOK098AFfmJmZlAUPg6pZwEaIJmKT2pwTq+3eJpGc54r32cAAJ3TH3Qg2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 05:53:43PM +0000, Pranjal Shrivastava wrote:
>On Tue, May 05, 2026 at 12:27:34AM +0000, Samiullah Khawaja wrote:
>> The DMA allocations can be backed by a variety of allocators. Add KHO
>> ABI for the preservation of contiguous allocations that are done through
>> dma-direct.
>>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  include/linux/kho/abi/dma_alloc.h | 30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>  create mode 100644 include/linux/kho/abi/dma_alloc.h
>>
>> diff --git a/include/linux/kho/abi/dma_alloc.h b/include/linux/kho/abi/dma_alloc.h
>> new file mode 100644
>> index 000000000000..46e61db81abe
>> --- /dev/null
>> +++ b/include/linux/kho/abi/dma_alloc.h
>> @@ -0,0 +1,30 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_KHO_ABI_DMA_ALLOC_H
>> +#define _LINUX_KHO_ABI_DMA_ALLOC_H
>> +
>> +#include <linux/types.h>
>> +
>> +/**
>> + * DOC: DMA Alloc ABI
>> + *
>> + * This header defines the structures used to serialize the state of DMA
>> + * allocations, done by device driver, across a Live Update.
>> + *
>> + * Only DMA allocations done through dma-direct that are contiguous and
>> + * allocated using alloc_page are supported.
>> + */
>> +
>> +/**
>> + * struct dma_alloc_ser - Serialized state of a single DMA allocation
>> + * @page_phys: Physical address of the preserved pages
>> + * @size: Size of the DMA allocation
>> + * @force_decrypted: Whether the memory is force decrypted in previous kernel
>> + */
>> +struct dma_alloc_ser {
>> +	u64 page_phys;
>> +	u64 size;
>> +	u8 force_decrypted;
>
>Should we also stope attrs in this ser state here? There might be flags
>like DMA_ATTR_NO_KERNEL_MAPPING which would need to be preserved across
>a kexec?
>

Agree, as replied on the other patch.
>> +	u8 padding[7];
>> +} __packed;
>> +
>> +#endif /* _LINUX_KHO_ABI_DMA_ALLOC_H */
>> --
>> 2.54.0.545.g6539524ca2-goog
>>
>
>Thanks,
>Praan

Thanks,
Sami

