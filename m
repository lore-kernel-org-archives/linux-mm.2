Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7479ECCF2D2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80766B0168; Mon, 19 Jan 2026 05:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D576E6B016A; Mon, 19 Jan 2026 05:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C597A6B016B; Mon, 19 Jan 2026 05:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B81526B0168
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:22:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64A02D22BD
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:22:37 +0000 (UTC)
X-FDA: 84348324354.04.F48C9F4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7934210000F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:22:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oGSxFtNt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768818154; a=rsa-sha256;
	cv=none;
	b=g73zxfu7EisN/BupHb71qCztAg0VwAZ/D13RCZxzKKf+ZliwybdxDdWzG+A0GSy/tSWlhf
	eO+ctBNhMpdftMfpYXLrBCLgjf83SnvjTo4daad6xSKxhRsPxQ1jYrAKSIFMyDVaCdeYjS
	3JB0cJvzc+oPOJ9zmUZmWxDrgPdcl5o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oGSxFtNt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768818154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9DEPC0wNb3JyBIssTILIglxHqB65HK5X12f/ozmJ8Q=;
	b=CsQQD3nM0pQbyQ8ZzaWOhk0os/MfDDZ0PM3ItLChIVlvf4oKPNblJj1+GtPlzdxHrjKdpJ
	nauvU6xakPEH6zJR5Mhz4tPdnIAIUuackUJqIyDPS+sg7YGHKMkiaI2HCXA+NXY3oMsVA5
	8DoD3scHNBGVY1prT+WNMGO/u/LbBVg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768818153; x=1800354153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w9DEPC0wNb3JyBIssTILIglxHqB65HK5X12f/ozmJ8Q=;
  b=oGSxFtNtlWdSVVfKxSFmh9mSQJGiFVQiP640p+Vprhl0457ZbwcC2Y33
   b1Wa+8LYYiWHruUDEKcSg1L/jlZxE5nploQRe0P0tfVdIUO5e+Hd08IP+
   zuQM9FuruKEcrT0cvoOVKt6mhCgxF1ma0docbCNfeENwkIKbou3qdTazx
   CMS1JnEYT6JQ55LnmR+iKyYR6tT7Cofc6b+phRGcxv74zBvjAdcpFcZWT
   7CDkQizAj/kSQjCSxCjUkVMoyolmu84J3iX0S83sxTbuLo2apBAKMJiBr
   4fhtz5tTMXIY9Sa3qSEZRei7ZneSQ/TucwSvNPoM2QKo7Qz8NvlsIvVdV
   Q==;
X-CSE-ConnectionGUID: i2SXey5ISzmDTib5EFlHGw==
X-CSE-MsgGUID: xFyC7uhdQdCEKZkqKxzWjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="81469780"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="81469780"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 02:22:32 -0800
X-CSE-ConnectionGUID: 96O6kVZPSJ2/mkBRj6UKTA==
X-CSE-MsgGUID: zBVrWg+/SESBp98w+Tn+vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="228769596"
Received: from linux-pnp-server-15.sh.intel.com ([10.239.177.153])
  by fmviesa002.fm.intel.com with ESMTP; 19 Jan 2026 02:22:28 -0800
From: Zhiguo Zhou <zhiguo.zhou@intel.com>
To: zhiguo.zhou@intel.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gang.deng@intel.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	tianyou.li@intel.com,
	tim.c.chen@linux.intel.com,
	vbabka@suse.cz,
	willy@infradead.org
Subject: [PATCH v2 0/2] mm/readahead: Changes since v1
Date: Mon, 19 Jan 2026 18:38:08 +0800
Message-ID: <20260119103808.923966-1-zhiguo.zhou@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260119100301.922922-1-zhiguo.zhou@intel.com>
References: <20260119100301.922922-1-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7934210000F
X-Stat-Signature: 4ah8yoxgfwrc3bzt49czzuzm8n3pt5yg
X-Rspam-User: 
X-HE-Tag: 1768818153-363626
X-HE-Meta: U2FsdGVkX19Sddd9IEKQRUR9lEoxvrBJlz16LJ1c31lmO4o4wzShj8vhr+kE6PF5wxk5AKresIp4jm+TkvS8K+U9lRKi+pR8b8ImiSm5KOixQFRqkVXXYHZmyuyLAhPkc3zNIjJd/MZaYNdUU/4abmewtPGhrU4Drt0d86AuvY6bC1pK+SV+ANxQ+7p8SfWvQnmjvYIofLcEOOq1NUE6RMKvtdxmKFIMkTh1xh+oyV9ycB3k6dibl+tle/ckMQIRp1CEQn7vID6h++0CKDa9wvcq8r+ZZTDAwiq0tz5OOshxU8VrBU4THuAHNhx1D4uDXnepJg6tZRFu5AbVJybedaxo0KG3edqgqPMTu7mP4l+N7XGGpA8IpL3WF6sAk3/HVYtrc3rC2txlQDUJ698kRG+npHSb4g69zMbkLlUOQh/XlugHB6/jXuwvkEVlPk7OQE20EN7Gg5SRjOfN2g7HGIyCFTXIyv2E8i9bPML/31ykkfTtLQecpVZuq2sYB7GGhjdc0adOuST+Y0IfYO3jQE8Wnx1BUyOtpslZf1f84om1G/ajMPFUiouS6xAf6bizVaEAMy9VvgU96v659yDWSzhUXK2MYH/MZ3U4//mEwu7WGWwAs/DMabPiLWll58sZX972n/7DV+dxxGf2AXSpALIigxf52ju06zWyBjBI0q5kHm87yV+PGegQr95tIcDWigL40KJ4FHFYz7jFhaJf/Cuul7oGc1fqocdCs7nHzs86sBRt1p5VHEQiqm1ZZyn1xPUZCcTG1aV8WpGnD9YF8/kH0SAb1JUvup65cvOTwUyqeqy3iwjqS95ZXQhEZqeJiS74w9K7L7YQdocKLCIEllMTighN15dxumF7hXaK0CWwtSmyT38A9gAEO36u3m0cNIdV/TAa7xxxbGvrP2RD4e2e3rMkxV2lLgfAaD+d/Ijy08PhBkIhUV+vPRL68wMX5eV2+C1EQYp0W/F+2ZV
 h76Yfgzj
 q4Gr9zRZRDDX03yZwLoixKSXjDmgl7ZZNigybJjBjARTeTlesKMoICT2V/ya2QJDBXAdkCtZxyU/w4rCTd7agk5dlTHViLIbJDM/FbvVZovoUKIRwwIewnS6iUZi/HGtK0BjYbXnCJNP0BZ1cFnHcblUPzlL6AcUo2fIDOYSugBNm1IsdypnBhb3H/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Changes since v1:
- Fixed lockdep_assert_held() usage (now passes &xa_lock)

Sorry for missing this in the v2 cover letter.

Thanks,
Zhiguo


