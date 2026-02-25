Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E327FD3777
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 17:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559A76B00A1; Wed, 25 Feb 2026 12:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507496B00A2; Wed, 25 Feb 2026 12:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8CF6B00A3; Wed, 25 Feb 2026 12:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA7C6B00A1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:24:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E66C31C7A1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:24:11 +0000 (UTC)
X-FDA: 84483652302.15.54C7E39
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0DBD3C0008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:24:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WHCorz9T;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772040250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFBUeSrCJcgeVZQHXlbB3qF3h65fAHKQt2LY2SMsUkk=;
	b=zqRiGsNhT16DAYZo/FdhII9/d7xp/UFnBIsfsoDgdoDYdPmfUN9HcXxtroA3BbstHp9MDs
	l5zV+pN3LUSCIdQs5ZzJl25M4rlDMxLIaHhDBqHNRr+pOgXkpiJMjHf534xd7TBwU2+pfG
	PCQxw873mFiSN9VcI8ruHsSmYIWgKf0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WHCorz9T;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772040250; a=rsa-sha256;
	cv=none;
	b=iqOMNPrtw6F+AbXq8REUI9Ptqp9p7wmXO4fbH2JYkrJ0v2CKfA/k6NFsWwkmrcjm3QKXQJ
	MmnEJpRw7TIdh4JRFrCHmSUNIFKRGv5934u9VrHoIr4ngEFzl/6nUqEXKf3kVXEs0ahvhT
	H0MniLvqGceZ2QTdCy3jxUyFZphV0eQ=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-673ee2a98b1so19990eaf.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772040249; x=1772645049; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFBUeSrCJcgeVZQHXlbB3qF3h65fAHKQt2LY2SMsUkk=;
        b=WHCorz9TLDH20BWzo0pkSfC2O1LeHZahrhIP07EqQSA297oki63m6MKGnqO5mZWUFN
         kPkGx/om/g7f95wJ/xA4mgX02a2V9Daqs5IVuelgdC4j7IjcqamL7mi/RHYEPx2M8trd
         A2OERLtv38lmnkCDfXJhNbBiqgWHn4OFiOqyq9K9r22ysJwwu9SdAAiuxVZYcW6FNlbp
         4fnbF+whiZH3XVMi1Ryy148U+Ljl4s+18XLcX84Vrj2Jc8fwcmCwUOGZr4BkpFpUG2C8
         HehtJbpq331DAtDiWnCNVEsZe+PCDOPc2aqfbjU6TptnQq99EU7xAIgiTMQCuReh6r5b
         oreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772040249; x=1772645049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFBUeSrCJcgeVZQHXlbB3qF3h65fAHKQt2LY2SMsUkk=;
        b=IC90tN5eF+jP5yrI9F6QynV0eIX1YNMLsZtPGvzuCcruTNyeVz5sZeIGg+KBRb1Ano
         pg0J7uamKvimicJHWbkB2Bs2cxOyUQjFQolgX+CldjgHuuJknuNka3V3SCN8OMsW4EFI
         Ka5eyYjzgEQNTTNpueYOyTwIWYqNsDAOBkeRVLzwVmTXP5p2PVXRFaMtTk0bAy8NkyHP
         gpTQ/EubcE46Iz+hpCC341/CYX6LauTas9gd39fBb/iD+K+HdUBlLJJqQUOLHm+8q9V0
         dJgDPbZLXinOjMm+GeLPfrzjCUXEzW0LKyfGBbFXpsZZBASEg1d5U/ifkRkzhISfrJIa
         MU2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWHmaYdugMBWYxiT4mIwbjzAsoepigtAAgq5kplNSu8S6Mv4fLVcgdklAzeRe0yj9UVRZgAwQoGfg==@kvack.org
X-Gm-Message-State: AOJu0YwbEu2AiVfun4GzEznJJjp1lP54/mu6snZn7e75mEsLchgb/l/+
	EnLnA5hNxjXVX8iMgZp0xgfjGCTLmp/YObk1FjgIKV39BNWz5W9aTTnj
X-Gm-Gg: ATEYQzykJAJEirO6MBQWQQOxvEsSsPpvlKrbr8Ox7ISSOzAqaMxXy/azkRXy11mt2Bf
	upMWoxFfiJMnowDTDGBeSBRMI1R8z2zyzGT/DyR601HCJAuqAgklndDMuo9ptnv4P9iRFSjUgqD
	Uo9uNhaZqtBQAS+BnNrKl+IYZ0cVIJmixpWJoxulZbe4rGIM0mm6ZDoOy3w57TpX/MCyBPJIRsS
	pc9uAl80frlTgarcn/i6oS756TEHwAbD1nbde5ppEdtYU5RM0Zb84pGP5Ul4XXO699k/wBA2irC
	iSUuoWu0TI2RqqnDXf2C/T6E65Rph4t8EuICO9B/y/L51UVKcosxzmbu6DpsaIpzeQ11EMuPlUb
	krx4OttNSHnw/JN4vzOTEpnNK5v65rvaNTZH0Qd7BapLGzVbAPn+hLHY2NNn3ZDeOgPVs+Pkw0B
	U2aaApmEdFuxEjapJpJvSkZA1cyUIiE7S+KAHVMQ==
X-Received: by 2002:a05:6820:1799:b0:66e:e441:857f with SMTP id 006d021491bc7-679ef9832ffmr601352eaf.51.1772040248944;
        Wed, 25 Feb 2026 09:24:08 -0800 (PST)
Received: from fedora ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679c5630827sm10737190eaf.3.2026.02.25.09.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 09:24:08 -0800 (PST)
Date: Wed, 25 Feb 2026 09:24:04 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
Message-ID: <aZ8wNLTx4e7ZwCK0@fedora>
References: <20260225031231.2352011-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0DBD3C0008
X-Stat-Signature: f8aen3yxg76zfdiibwfcp4tt61yi3ach
X-Rspam-User: 
X-HE-Tag: 1772040249-332931
X-HE-Meta: U2FsdGVkX18r/JKLOr7e+rXWjzgaKL1LmDay0eHgRgFOuu66AYAd5uski/tNAm0+pWKHV9NSlpUMQc04ty/z758vE2HEkuV3qIH2ed43wRT8ctHWdAymCumqw2zGVA9kQnMwgF4kkEE/5951xz/bdKfZjTYAbPTrfoA8wSfa/8yw4vMBKaTWtGp+/BlTNXqWqrxV5TfOvpGDcpAdsuxBteO1rXnu4qiExuASIfeJSDCq1FATTxquTl9GinwZ75UwWyEx43yAqGSj0K6AIkynNtL0aOLsr15iHgP3hHDBNVX9fWueBVElD09GKQWoq89K1KWKI+arwecqqipO9aTiQXUN2dbVFv8caLMLskR7dtvV99Rk+RvgyItHkE4On6qPkg3VOmbuKCaYFhFT6OLg9EK2IcWk9R31bSMDb/nDljul0jM1ZDlGdnhTfnuPv7ASKQFLLTx/WzTRxYedG3ZMGSwKFxW70Ve1H/2FiJn7x0jx62x2JFhQWrrWGHLCx0zU3D8YVjMTBRSTiFnEoaxOGB6gqL5VlFDfkwauvmnhmdLTEWOmKiC+vM7xMMArwTyyMy/qjZz3CKV152lh2/5H80BGgCGtfV5hDB128usqkjdz9jg+9ahnB72xo1eAU5Do1GrqtxV4J8pnd0EaXH459z7RdRPlR1Sfo2044NR1gN6kHrFtK0NITempKMw8TdbMnbul56+qrWKBSfPYZmbmSWLZEDZvwMB7i+HKzVjjSFrguhpqSKjj2mRwJLA9mvLQf7+Q3SAg5b0dRlrIy6mKIEnbrhQJ6lWvFdZxyC2gLXotoAdSZjygGcmo8mfTNNhauZRZtUbWx3+QvIxXNKBtzHqYKb6o3Xjr3FJwkGHyO6mNUlR/x5WNEN4FOK1tR0c2CN0ZDrM/h0jMqe9kuiicOsWHiJmVdr729nMjqkvyxdDHk+BqMQM1uQeJCb9f1Fc6PTCSOTgonAHQWoZpllt
 cwRvU1sg
 UkjUk2lIa3r2oIe4g7gDJsq8wEbSeFawr+pRBR59pWJtj974PDKPLt+624KF7zSKg8D2EHPqwRDlzv6EcZ8pK05FU+0ye+PlaOJmKuTJ8sATKujsdSKRSEY9mdaim5hfk5ZsWWRoexNR2IcH3QQQtqhR5Z3tlYrUsggbrXTEcd6WMx+z9P9T/4th1pGSpPvnFDihyQl/cBA3RrCbMA2/hIfSU74Ehd45Je6gaoVBdfkaOk4nX5LOMRPAHLOVsC/Sr3vcBlsRXrRxuLFPkgPG1T3icL7M8yOn94AUTDh/8ALkS132fPOOdOo2UMDVCco9/szevMDUqS1w5fcrATiFhapQWgfdvL3e/TP3k4uz4GZwCD1QMuS/LzRxJN2mu2VkSj43zcqqLtrWJ9DUBHz4CuYTnYKB/nCmA7JHzNBqp4g39vCpelqyGef3QOGbFJqvrXn8I53WR1K2VWj58Ytcf2SQb0UBRWm899zOiX4bZnCyBXRB8S7JYocNzzj9+VINwobr0McbzwdEa95tFD90x01n66mBbE4gqUiFo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:12:31PM -0500, Zi Yan wrote:
> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.

LGTM.

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

