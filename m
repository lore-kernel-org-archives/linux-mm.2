Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC697CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCEA38E0008; Wed, 27 Aug 2025 18:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5A68E0001; Wed, 27 Aug 2025 18:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D738E0008; Wed, 27 Aug 2025 18:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4D058E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:52:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 669BB1608C8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:52:33 +0000 (UTC)
X-FDA: 83824038186.03.073C031
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 35871C0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:52:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZqUYD5aQ;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756335151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJgBl10AZNWfXOOB/pDgIkoKh9accRpxxsoejJNG8b8=;
	b=y8jhXVYzM15DX7ZntRkRPdZg/uYV3Vc+jfK0bdK0HOGpqStparizXcUMkt45Vko+Q18ew/
	dgmtzrdaBdaAiJjqx+SGg8VQiId7IIk75qTgbNLfnNFK1SVmGpWfDRdti03zhUtqa1D/Hi
	bXDkaf6EaRn/IIWlvVd1r1ZLryuKinQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756335151; a=rsa-sha256;
	cv=none;
	b=f6Ylw8+P3i3jtTHxt2agnikF6/FmRD9zxCnIIqo2DcAjibdbnocNDcgA7qAUHGEX/m0fJ8
	RAQFqJ56Buhp60b8jjPTnJZjxzz8EhRtautrNNNDtvtH++eIj0EBxFWlnxCQcvXc5k9W+G
	DRw07E+yoZZZwUk8PHAWIbAj7bFnPGc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZqUYD5aQ;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756335150; x=1787871150;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vJgBl10AZNWfXOOB/pDgIkoKh9accRpxxsoejJNG8b8=;
  b=ZqUYD5aQ0RvN9oWcS1wHmKoTChfKlOu12uMrFqZBvPjU6ATwEN5wI7OI
   XVQZEpU4en1EEhTZAxFf1+jxaH+/k25YxS445oDGl1euSAha5ZmDWNH9S
   IDC4d8klMHt7K4xv8tW+pg5eI1FpOhUSI2twTrdCL/l6Cebg2i2hSrGMx
   mJOK46brGFPvECj/NrDVavCjrGNtVeGWb0tzL5v1ZhiuxmiMubvYDNnim
   JoLZzCK/cEC21TGZpZyU5GEGpqVTVppuy/9KiL4gBAF2d6q/x7UIWpek4
   Y9Sy+46ZrrvN0TuHsue52dirTThVNWl3PbUzp9DLy2ziscChJdE67ShN4
   A==;
X-CSE-ConnectionGUID: 4w9I31BvQ5moCTfgteunUg==
X-CSE-MsgGUID: +heGVLbgTNOd+2ZavGvZxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="62418173"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="62418173"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 15:52:29 -0700
X-CSE-ConnectionGUID: 3xdHidK7Tq+UjmDsKE0yNA==
X-CSE-MsgGUID: CnrtJs0bTmqQznqiw11SnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174125255"
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO [10.125.109.56]) ([10.125.109.56])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 15:52:28 -0700
Message-ID: <ab1e0119-85a6-4b2e-a734-275b43e6dac4@intel.com>
Date: Wed, 27 Aug 2025 15:52:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/36] x86/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-5-david@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250827220141.262669-5-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35871C0007
X-Stat-Signature: 6dkw9w1nqjiu9x5irm9kegbhe9rw4axg
X-Rspam-User: 
X-HE-Tag: 1756335150-611872
X-HE-Meta: U2FsdGVkX1+UZf8+rsRfzq23RfmD2todGnacH/DBnF+IzuEeIT2KaV1tCkm9qvhJk1bsgAiW33PX2cJwqd9f2i6uaZ5zcVFL8yyuEwC+3WuW2f59b8+UAhozmVxMCgju6tkt3lUYgH9e094ugV3VTRDY//OCKxwXBVDfYpNTjGKLgMleV/33t91zraU4m12wXpcUk0/o8Br+Sr77QJBiw8xS12b3OYthIfkkXT7UpCy2snvN4wp5x+3P2DDsnHvJNcR4VISpNaRUrWAJLkdeoc5p54C2onTKnI4J8iCiL5Lxjv/EuvMbwpOsEdnDDn9iSSkF/ulqLaxPCjsWEfbdVjZr3+Wq301xSeZiN30Q4Iu+RowmpgSZvLn0upweNqSNqqSsh8vdVjY+obJbu5PalBSO3Qg+YiyLTwgEx9E4+hvoYPE/UeAfG5fcgK3VloIl5fMSUCVZ6X1QPi/vJcaLhZDX2Bwghx3gtP88p+Hc+/Cj5lz+q7UXcUTgkAJ1U7xAFeOAIxu7vhLgTxa4k+Fr261NI6A9Tz2nqgpAdzcIyaB2/LP6um1c3+l6WNhAlWER8kUMcLqH/eEsU10YByiRkuriVJqFl4avrSIqCw/MyELFNG4LbxhBc74bWYGU9fIb95dxqX2YrGp1c6WIf4CZjFQun4NXn/RhHzqazuIaOtmEHVyKaip42T29hErXV/3onZdhvNOfbEhEfKK88Cr9KYJ2pJel8hh4f/t39f8cV9C9UZ8PupewLlm0wl6ylyqD2+rKaRUx4/AZ2nEpL0M6xFUbJj+0ZdXZZ8KsRTiSOuUQvj1BH+nSRRHKOlkgV0ztHnYbTPlEw1pR2ux4T27M52vC+jOyl/mbyB1wl/2Bgkes0dGjCZFz7OOJ1do9bhaP+yl4oV3UEBLMgx+exKCFxYmJGdO9NXp9Zf8VDQRcBoGIB49KngTLxJ+g65KiThEKvzUQ4sT2G2x1mmJ5nG8
 xvvi4FS6
 c8Z0CrNLo+33g+hhUCut/FWYzf11Pp8xj13mmL9hJmCa9upfnR9gZn3AfkxJeAJhzsqeAy/5D2Hg1Qq3PKUuDyVwCZSWeY0UgJvXVa1R/TD0OoM80C3c1538YK2yEUTApBfUtrjx1SmsVNlXAsri07g4YvOr9J0A80FgqCCxGpVYMU+maUzk9d1FpNLvyEtgG3Ik17sPDZcyHhBmhiOLDPyFc8jKzHdTGZWAYz5opjr17oBcj6NeNiMuc4yBHY6rK1VNYTogISrYsKRZ28VAAgywXsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 15:01, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>


