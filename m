Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB505CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252BE8E0012; Fri, 26 Sep 2025 11:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22AA68E0001; Fri, 26 Sep 2025 11:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140C58E0012; Fri, 26 Sep 2025 11:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02EE38E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:34:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7D7F11AB86
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:34:13 +0000 (UTC)
X-FDA: 83931797586.15.D4BE0B9
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id D813680013
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:34:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=yVbzPYQr;
	spf=pass (imf02.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=HMO5hgJCbwtV9PK2cFfsUx2fXWFzdBYn4BBsNRBK1CI=;
	b=HX6UG/Na22MTLgA4UczLbFmN2jdN9m5P9jcIHRMYt8JE+8JjQhFB7ZoNzrFOITAtzuilV2
	RiVuFkx3+YbAOm5xMJyzlH/5gpC8ERxUbLS459YuVKWBFyYdO4niarSrX65QgvgUHk6YDZ
	+mEc89JDVA/72VUa1P7EAVtiifVQYsU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=yVbzPYQr;
	spf=pass (imf02.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900852; a=rsa-sha256;
	cv=none;
	b=GWQ+wqdDewt4eeT9OX2R8T+S2T2/7KJcP5On8c5GHWfGrr9D/je7+YL+kqoMw5XR4Zv84F
	+MYFn7Ns0P4mV8l3OwOFGge0wqJvj0ui+kpBbwqEMIAj0EfJ28P9J6+D1TOYcH9MfSo+DR
	TU0lUCn/7O9QKpEyAcKgibUe0zHAGEI=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so22438725e9.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758900850; x=1759505650; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HMO5hgJCbwtV9PK2cFfsUx2fXWFzdBYn4BBsNRBK1CI=;
        b=yVbzPYQrZIeTyxstoReB2fUGb6aLGgf6hIHwol5LnEI6CK16Oi3hymFJGZW+p6Xe/E
         gTLIBb7le9e5D6RRMb/KGqMWiYkPLoW9yIErxovs6nsFrLe272WSd2QO1NRFfS14mEU2
         CzOHkS+dPb5Gk1Bgyuns+jdPiM6YKOjbZLyC7Ah/Hc/5EYJ/Lp2fpDICZdYVj7EemqMb
         2L2jRwC9U6RNAQdg6wUZQt9iDDyPlJug9iumjCX91pbmt/T+2d/jn2eGRNYvSrblxgDj
         atqRrjVG6M/c0xTNUQrY+c8sDe4d1SD77mfI1DJROk5k7bYCboPuEk+5ZsLknfRR82vu
         1C9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758900850; x=1759505650;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HMO5hgJCbwtV9PK2cFfsUx2fXWFzdBYn4BBsNRBK1CI=;
        b=jGl4gLMHmVHc7R+7ZudAMUc2LOuwxSyg6+VTdACeuUOV8T+/dfGwJeIXuOhummq+hD
         /xRrMZaWt8TDZCsWcFKE0Meb3+V9ue4FMQaf3gidYvf7ZUjybtGXVcRSt7HM+bulq0PS
         2hMzevtfdJKQ1EsZIQvSqBHzsBbRluo7WQUZ94CaMVAy8dJQO8zo9UaRiq7zmaaC+b0a
         BggKMqDMtSLOHLYPKW5+l7SQHCkKskDimR5EokrPgYO/n7q8apt+tSRxoC2Xp2GuS2E5
         kOIoHI1I5jIyQI7D3IziNITF9ImFG6eJji2A6oAUjCqS4O5Hgw1H+i6E3TuPlD6D3fRQ
         DYvA==
X-Forwarded-Encrypted: i=1; AJvYcCVYkdWmx1kLtKw1GcsvGT1/nSocvda/0OsiHhCeRYbG/LdB2B2YevX9LnuHIlUl2HpXGj8jVp8nqg==@kvack.org
X-Gm-Message-State: AOJu0Yxajn+cJgL4XTsNUOtY3jg6YvbBUUKfQRfa4MutqJ5UGzoEBgGh
	bb3q9CEL2YlrBdixrJWM9DHrTDoxmKkHHD+W86aFPQVGQGkB5eoZr7YMlf+HBgd2fQwIUz7K+w5
	dyxra
X-Gm-Gg: ASbGncsNybWcn+Y07wZ133e5u9f7Z4tQR7hZhdBDdajMBWEMx1YczKMetg5aATTpw+r
	ZdL2FBJRkp9B5MhZlL9Aj9If79gkjbmC8hMZXzTp4Iapxau4prqpWj+jZYURw/xRhPuIZpJsREq
	ces1gabtLVDVcsvLu28Cdpn9Pt1ffy5yCbTE4O4BpsA67qwJ40jpHbCP6N8O1RDz1O3x+6/2fX9
	JDpB8js6MbNXfnV0QfKFR1VyLvXM1ClcRysIwPMzE6aHaERN4hGWdn5UrLfYtFpR2Pe2O7JGAAj
	8ChOHh2w3oWX/iReRUfMDcE6YI2eKe2CViExjrNRb/aCWUY/+IlCrE5CsfD1kD8OKg5cAL9zFM1
	nEbGTFgAMHWsUrebgTB3nXpUUO8+E
X-Google-Smtp-Source: AGHT+IGeo7JSWe4sg6wC+JHBWfGr9CcvjUdGf1N82kHCNBejo0CZ5f4vzEILeKedV9H4Kp7q6LdOzQ==
X-Received: by 2002:a05:600c:8b62:b0:45d:5c71:769a with SMTP id 5b1f17b1804b1-46e39bdf9b4mr41759465e9.26.1758900850403;
        Fri, 26 Sep 2025 08:34:10 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e33bed6basm76990795e9.16.2025.09.26.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 08:34:10 -0700 (PDT)
Date: Fri, 26 Sep 2025 18:34:06 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Mason <chris.mason@fusionio.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify
 refresh_cpu_vm_stats change detection
Message-ID: <202509260132.awvdNKqF-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924204409.1706524-2-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: D813680013
X-Rspamd-Server: rspam05
X-Stat-Signature: dutaurnfceawhba1ztpichu5175not6b
X-Rspam-User: 
X-HE-Tag: 1758900851-223885
X-HE-Meta: U2FsdGVkX19WSitq1vOLeJHqXtTgnakNxJzA5G1wa4eWGI++cAzfHYyiU+af9jJ02qsppOVcfzLIIgQwxaaluMiml2ebA2D8FfIK3GwwSZYZKdpkL2VWPQ4tK0G6H9oqHhzwDXnh8MBZQIxQBrSmjmviHzo6dyf4Q86AOqdHLOXzpqTI+KrFtXD5HMTbGHaVFYZb/0zLWI4wHbNcR5PDZgJnaIaxbhn8zMoCuq7fkweW5yveI8Jpt1wunsydS1x1tj8oYwBX+9Q35piWIL8UPUQkwudw8jo7khwpjLwSSWrcnspQdjSNksY/cNGXowl0FC3LgbHFpyfzZLa1cdsjT3/RzrhR+2OcNLqT3+BcOXv7dAHHRc+KRkJMgcJ0tNrBeHoGBUrENh6ni4+keY1yjERTlRtyZ/5z9ySVG87Jf1TN2y8Ng2fUO7e0Vsz7z85dMYwyjbWjPlXtaTkX7RmJxkrcv7GRaIA/LaNZTuVKtID28Euepo0dXkYpfah1CaEwQdVCzBZc3qffM9WmnkwEwtpXX6ayD0NZu65Ra5te79GwMfMjqNHCm7ozYzTVWcXd3vx+oY++sGRV3TiV09AQSs1TsIjYrMS8sElcyFgjYk0ZXfcSKpgUKA77aAPqkf+IejyGzKhsF440sdMiWLv2M7nRyLjTnH7VHpwkAM4WysDS+NkG901s9qrhOVJ6L3TcAhb0sbgxZNFw+fkyINNTvXnzysxQhWESWqCa6SlzblqOWMU2NbiGCIMF0chcYDIotDqvf7Cd0QPj/3cih5IJzXO+Ek+3y0wBKCLbz3Nv2UhsYprsBIwsoBE6hClglEKH+MAcVb02L7Hfd0NByGNvCjIQyM0eArTLVBsxPrOZf0Ii3H4JFVfZ3Mm46Wk7Gx/Lq56fiqT/uK1y3Qmj6Q4GcCUlkkhnh1WO0CVlsmFXdKOPttDF2U8XSL9zU5gURP5tISKhe97geqZ/Ri5Swt2
 1QQUPnFg
 soeAb0uaUgYXhcPrfXn6UgK4ymaLQRt6cLmtY8egOf/iJPqgqYhzfQumqRSzQwFJE0tDYlSopdNiXBiEhP4ToqSuElWHQ2TUiUplZtxu9aPTJNspiq/OqAvrqEC9PuRDUCb30AjlQD2l+CUNpEMsNId1ZOoyVd2lCohzRce9vFsFTyaRP/Lm2Zvp1Eq2y7IuVrBOTGsa0cHLIHuFvhnisCRMA2ejXpxNTFGayRE9x8sfkRM3+HbOAiJmXa37gQkrs0Ef6LEwctzFWzhUGBtMcqkT/3E4j2ZGMl5j/EWC0cPbqJ6X5azoJDNEZdOuc4GfrgSh1O3U4I/7d0nqe/ok6S7FaPATxUsELeogAIcjOdbTKOqEJeaiSXMbw9sAWFXmyhyzEeoB6I4qCuU2hno5OtbjSZy2otb1DPgsiWQnvUfw1zb1L13JL1AFULPwxLQLhTUn6R5amjKA+XLw8nXsRaw53or7OnWYSWLmtSeZbBNHhUnlbOiQi6n1JKdtojOLYOzJjoG3xOCVM5DIe3nLcAom+ZVETphvD/tdcGq1iByP58m3Pk/K58DproVnyvJFwsK12hCsSjby/X0sONg+up+tbOnp3ceL3KHbU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-page_alloc-vmstat-Simplify-refresh_cpu_vm_stats-change-detection/20250925-044532
base:   097a6c336d0080725c626fda118ecfec448acd0f
patch link:    https://lore.kernel.org/r/20250924204409.1706524-2-joshua.hahnjy%40gmail.com
patch subject: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
config: mips-randconfig-r073-20250925 (https://download.01.org/0day-ci/archive/20250926/202509260132.awvdNKqF-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project cafc064fc7a96b3979a023ddae1da2b499d6c954)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202509260132.awvdNKqF-lkp@intel.com/

smatch warnings:
mm/page_alloc.c:2591 decay_pcp_high() error: uninitialized symbol 'todo'.

vim +/todo +2591 mm/page_alloc.c

06fb80866d37b0 Joshua Hahn    2025-09-24  2564  bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
51a755c56dc05a Ying Huang     2023-10-16  2565  {
51a755c56dc05a Ying Huang     2023-10-16  2566  	int high_min, to_drain, batch;
06fb80866d37b0 Joshua Hahn    2025-09-24  2567  	bool todo;

needs to be initialized to false.

51a755c56dc05a Ying Huang     2023-10-16  2568  
51a755c56dc05a Ying Huang     2023-10-16  2569  	high_min = READ_ONCE(pcp->high_min);
51a755c56dc05a Ying Huang     2023-10-16  2570  	batch = READ_ONCE(pcp->batch);
51a755c56dc05a Ying Huang     2023-10-16  2571  	/*
51a755c56dc05a Ying Huang     2023-10-16  2572  	 * Decrease pcp->high periodically to try to free possible
51a755c56dc05a Ying Huang     2023-10-16  2573  	 * idle PCP pages.  And, avoid to free too many pages to
51a755c56dc05a Ying Huang     2023-10-16  2574  	 * control latency.  This caps pcp->high decrement too.
51a755c56dc05a Ying Huang     2023-10-16  2575  	 */
51a755c56dc05a Ying Huang     2023-10-16  2576  	if (pcp->high > high_min) {
51a755c56dc05a Ying Huang     2023-10-16  2577  		pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX),
51a755c56dc05a Ying Huang     2023-10-16  2578  				 pcp->high - (pcp->high >> 3), high_min);
51a755c56dc05a Ying Huang     2023-10-16  2579  		if (pcp->high > high_min)
06fb80866d37b0 Joshua Hahn    2025-09-24  2580  			todo = true;
51a755c56dc05a Ying Huang     2023-10-16  2581  	}
51a755c56dc05a Ying Huang     2023-10-16  2582  
51a755c56dc05a Ying Huang     2023-10-16  2583  	to_drain = pcp->count - pcp->high;
51a755c56dc05a Ying Huang     2023-10-16  2584  	if (to_drain > 0) {
51a755c56dc05a Ying Huang     2023-10-16  2585  		spin_lock(&pcp->lock);
51a755c56dc05a Ying Huang     2023-10-16  2586  		free_pcppages_bulk(zone, to_drain, pcp, 0);
51a755c56dc05a Ying Huang     2023-10-16  2587  		spin_unlock(&pcp->lock);
06fb80866d37b0 Joshua Hahn    2025-09-24  2588  		todo = true;
51a755c56dc05a Ying Huang     2023-10-16  2589  	}
51a755c56dc05a Ying Huang     2023-10-16  2590  
51a755c56dc05a Ying Huang     2023-10-16 @2591  	return todo;
51a755c56dc05a Ying Huang     2023-10-16  2592  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


