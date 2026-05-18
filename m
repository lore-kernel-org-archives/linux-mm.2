Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54605CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72386B0088; Mon, 18 May 2026 02:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49B56B0093; Mon, 18 May 2026 02:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F366B0095; Mon, 18 May 2026 02:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 938D76B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:49:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36CDC1207C8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:49:28 +0000 (UTC)
X-FDA: 84779614416.01.D662C9F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id CD27014000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:49:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kEFpO79g;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086966; a=rsa-sha256;
	cv=none;
	b=Ro9Jo8tjkCBu8RLkP01Z9gpX2P6PHQgmhL2AMO7vKFEZCcFrIw3vYcGP98MMNYf+nx5waY
	XkzmHzOJf32I0tGMTS/KwhjhtfS52Xom++jP7Kpj2UOE1hYMH9zqySyQbNGQr3LrNgqn9K
	HENHJZY1X9ZN3RtikB6FTRwyuEnon4E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kEFpO79g;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHCMyUnnRTZRapPtA6kSd4XGD5k4q9LvIMlMevF60hU=;
	b=tvQS9cCHmXmOZEX0odDwG4dYi9Z/4luxwtoyQcsl5J9dG28H+Z9mxSrVzFiIxR1ldMFeub
	SOF0W0IhVrOisx8gYxKlFYxm7hmUA3x42rViEW9xBjAFibN6qiVU/3CW7WFzhxvhWNXh88
	0a67XpljOcSfQChDIfRWI65kZliCvpM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779086966; x=1810622966;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Pp22136772WwXYLLAPjyLquLrSfoMqoKNH1ZWLFjjc=;
  b=kEFpO79ggDl6AadETX8ue1nOGy8blenHi5YuUQ95N4xlbH/gxStqzH7r
   J7hn1PwoOnCAIwS9DKuE9C4ls8A/9KaSKIzzywnd8z7DOwi/CM0ZFiKj5
   ydoKsKbMoXFtEhQxR8CURPsLV4RDe08guBjTQzH9MT8n5xBbYaf77NZnv
   57HzeQOV0RguPIqnDla9CSH2mH9/jC797aKQtG77x8iqnYqUr9PSQ+D3d
   dF3/qYOqsAOZBBWqfOyi6kD9u/cukkMzw4sHbf75S6WY9VRFBIwTmgZk9
   zZmPobtCjT/pZfwVZbITiMtiS+EMoNV7dXXzJi07eJ+RwbRNE+PZCv9yK
   w==;
X-CSE-ConnectionGUID: 2NSjEp2VR7KGpL3n51/J0Q==
X-CSE-MsgGUID: Wnk/GRz5QVC9Z2UzjjCuHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11789"; a="102605766"
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="102605766"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 23:49:25 -0700
X-CSE-ConnectionGUID: yVlgg+uSTW+HRtFuYClfBw==
X-CSE-MsgGUID: jOQaz6jrTiqp7KBgwxJE1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="235106799"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO localhost) ([10.245.244.3])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 23:49:21 -0700
Date: Mon, 18 May 2026 09:49:19 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Message-ID: <agq2bwaKW9niKmYZ@ashevche-desk.local>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-5-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517123428.1181981-5-thorsten.blum@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Stat-Signature: zngggxc1o7jzd99hcgf87gyzh1ap8eyq
X-Rspam-User: 
X-Rspamd-Queue-Id: CD27014000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1779086965-692948
X-HE-Meta: U2FsdGVkX1/ly3IQmrD6sITYLVekWtVL5WVK8BLngUWQeqxjvf9GSCanPdySUOLf7Goy+J9R/lvc5dojnSSryiMUNPVKwPIu+QsT9bFTa2epXkosB1F+oPzj+Lk3OuT7oX7fsPhfZyV3Q17zSZe/i6Pw/xTiPXS6u3vDehE9R7JaxbTIfJPPuxNZ5bcay5k1NZP4i2IG2ncqfkijal2CAZkpkssY6RHoiuNDTZmTrJJ6y3afKXZ3klQ7GDaTSRjoh9Jk6IWrmwAPWlTTdYQNRuKyS36GnqpfXmrJmwYOfBWQg6gbVcOZX9HhxSxh1mesGg5ZSeSFJrpl/+QlONAywwjZIxhYeEL3RaXuUQdwij34aKD0xncZOpa4ShnrKCG4TjVeZkbZCu5SUOSegBzioWRP17MNZ61DZ+BfHdI5U7IFVBV0YAeEOzR3RVKDZ1m9aM+OxJpQ7KL/jCRfJuQm3GyG9aTOiSvVp7rWibFt1HitYYkX+gexSoPmk/FQKADoeP8QxGbRgOhayI9+WgGY6KAZ/eQRy9WSGxd1GSv5Gyb6qMt8lfVoT3PTYJ6momctefqQD1iyDQuWyr0ZvNI9QPj8NSPwACvtqDmkzh3NY3yLDkfPzdxNnp2rzaK6Rmzqw7kZwKFV7Du6p66YMHEwJRw7BNgYsoCs/fFqMKkfCVX2HKG0YzvOXmRTKHuCXi9dhSA40AuM8b/IuAyi4WJksZd9coQywJvBudH7TAWI/mClAgQkLYDkiGGq9wtatuBUatm0/dG0hqcKZvfiqnUFpJtmg/l9XRL0o0dpXfpH42kPrD1hWAERFy33k+8NzO9MHwIOTD0C2f3AxOKB20BM+4VLFxl1MqlqmjQ/C1q0HMJdDGToG9EnLetdGA1TFA37rloNJiiOVlcXYYpfhaefkPBNlOT7hNUH1AbqupUGHJn8LYRZzWAYmTD1EBuIeI7W+8sCwYq5iWdnMESUDdy
 sMaYe9ct
 NFp+wgZefysk/Vch6k0nLUb6tiejlNaK3ss22MLP2C6FQmRq9N9JWkDVndjdH0SFPKk5gmR02/NB7YVKAyKTL9Bn5k9RDdITasnQoJJhberQYlpAOlr0KQzjqle3a/fo8tHYa4kQngMJuRoZpuOBd/GKsudmDXx0u5YHZSrJrbJM21zvHR/7ub6VrAOTK7xI0uzeceHGD0pAmQnSeRs41QmwoXNGZl5Hm7lFi+5mzruJmk5glExQkuS8yKMTXmq1wCpvFf0Uk8K5RW68Oy4SO5g/e7NrVOl/7kMCRa1sWmARc1cNpYbeuxbM0Ip2khjpqUasRmq+/0XtpNuzOi2kpyZ4jwSEqg639k9Pl1ZyT6u2s3kg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
> Add bytes_to_page_end() for the common PAGE_SIZE - offset_in_page()
> calculation.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

-- 
With Best Regards,
Andy Shevchenko



