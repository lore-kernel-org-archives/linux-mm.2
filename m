Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4502CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 21:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89328E0109; Tue, 26 Aug 2025 17:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39888E0105; Tue, 26 Aug 2025 17:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA4F8E0109; Tue, 26 Aug 2025 17:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A52188E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:08:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52EA716031B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:08:49 +0000 (UTC)
X-FDA: 83820147978.26.CD95599
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf27.hostedemail.com (Postfix) with ESMTP id 63BE440011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:08:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lZ1QooXo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756242527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqOqdffvf7KB4vMaL5w+Dv/zMtJAk/Hj2i8/2FcrH/g=;
	b=JaJhjHBU4ZEnpWlnR7lZBarSAFz7bVpOjSWfzO8Iw+nsN0L1h6Rd0q2NCbRuzkOAnyGb8j
	QXcHb9C8a89E2WuBN/rzNcnsXPtCl+WCT29nrkubVcfR/yZdd1p079olIVy0RDTHsgS6dM
	rN5u9/iln5QTs6xnHFTb3YkkX3Hp/lE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lZ1QooXo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756242527; a=rsa-sha256;
	cv=none;
	b=N2sDUZ7pZpxYB5Q6YOo5e93430LJWs11AmqGJmiQTasPoe/RMhPLug7pfQVdZKZHFt6y89
	Es/+qrjZl1JEYvc16aexLCXxL7tydQ5BzyZMtukeK9KTVMoj9kaAmTmkdW/AGF5jkzWV1Q
	qCP9ZB+S11mJD75ivPlk1n3MuU7iUlA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756242526; x=1787778526;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HqOqdffvf7KB4vMaL5w+Dv/zMtJAk/Hj2i8/2FcrH/g=;
  b=lZ1QooXoDD8q9XkZTsVgDuq5Jse9h5fcWOXh0xg95gOYhEzBzNrY7fBb
   z/uqo/ypMhS5K5miAXQu2l6g0WrKhQ8LkMH23UxUP0vSC45jMUAdlO9wZ
   Ao5kRyQ/mzSKaQ8fagkgl2CaCtiTOegwukDWlSkMT14a96BDnwMzXijn0
   FZbeFH5gB2bL9vUIUlfLFeWrRp3sevv50osBdh8V05f48MRAQykIthGOG
   ak/jV+k6Rovvq5ZUxpm9v/i6Qxpq9bi/RTd5V6n7BIp0gHFbxFcKVU6XL
   Hqioj0dBRORZU09uFydUQM+5/GSbeKagCr5wHv1A9pOYCnixowYulvDGq
   w==;
X-CSE-ConnectionGUID: sVVtiEJ0SvSfm+Du+M9J1Q==
X-CSE-MsgGUID: AwoX0lEJTHeRppscxs5MLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="58348233"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58348233"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 14:08:45 -0700
X-CSE-ConnectionGUID: ViaOYWAeSTWCkdHES0RzpQ==
X-CSE-MsgGUID: 3+skB+e/Ruaye+sHq22jbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200571015"
Received: from ray2.jf.intel.com (HELO [10.24.80.148]) ([10.24.80.148])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 14:08:44 -0700
Message-ID: <1c312a60-9c95-44dd-84c8-bd29c6ba78bd@intel.com>
Date: Tue, 26 Aug 2025 14:08:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86: Stop calling page_address() in free_pages()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-4-vishal.moola@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250826205617.1032945-4-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63BE440011
X-Stat-Signature: 3t4hdxhuazn83gwpmazf3kb7ewt6i6zz
X-Rspam-User: 
X-HE-Tag: 1756242526-378376
X-HE-Meta: U2FsdGVkX1+XStAubVApzuWWGyQSZ++7gpP7Z23LbSCtJNI0a5L56Ivr2OoELNNUYtR/cMDTdngxBYf2edbcgjrJvQifzKS2sx2cmdFAEDvfH2O7cvNrQIaF0YB3ibWyogltS08tTUz9NgoTg10aGiawWif8TwZQ/9djXpq/+pMrYXJZi650piVQq6GT/g90bulPktMoDDyOauZ1JmMVduOg/8FfpXamlSE0H9koela9ESGZWzMsZNDcoawvXg9LA7nNcPuCyK6gCBKHnb7XL8T3tDs/9+VOgyGpOBPFyjHCaueQGQ8xOgVsKyaVIqtXFYfxcur2TsCXieVaY1EnwE0cS2Wo+UasIDwrmW59fjH99LQgafkYJUPbt/2wqW7yo7EHplRW+oJiK8jhAKzbbfR+Sb3j8KI8mviYBMk0z3/iOsoPq1ELSiIcHDH+Yb+QlGmvMCFdlhOjPFW5c0yFEB24ybvU3zRG2weKeyGXyMskHalBm+VJuF99aqqNlxmceZB9AW4hSzCvI7aEtOAB7Rbz1n5mu5Ml2xS1og55KLz4MRMLBEdNIlbttyfLeNnvK7vxiShAn3ukBuBlLQwJnUPg1UKGvS3Bj6kdZu02YkhxawpxOTPk5wasWoButL1zJsUdFTWl5yifp26hNE+iswGcUR25HcmORBW7rhl23XMK7RRwg7wGzBI7PAtfRyQauoLkAs2+aNdQo+aIertFi8uO/xXkZbT1F+XSugRG9LlJRUKMrQoHwO/kx//XP+NawNvFUoYFTwtt2ATb7xz5rdjEtQ3AN5NIOeAXkosy4GfOlTG4h2eT+mJfjQKm3H+NpZDrX7zgMCfI+EvRdH7eAGXL9VemhhnKd6QLQ+Tmxxif3KmfLwE7gJgrfmIoDNpnf+tNCs10hp2i5+0ZaLWp3x+SUG7rvjCHJCffS16iZphdF3AcOAWJhdTm0zzGoN/8x09nZfYfY2bGrkdzA0v
 Tr2krdcg
 QKIIScKEdFXSnDiGsMUzLUIcs8Ljx7Lj5ijY1XmME96IlzbPxXLvezyeOtB4TGl6gvTrb/IElDBwZQR7KgN3RSgY2WGdgatdgCbtI6Qw6+WDuznUyifmycjkWUL0NCD51V2uPKIGZSIBgJZo05S7ipJD08pQS5qZqiDapMNBZmk0vMq0has8RIOo7p6bW/QuDCuAnJCV+e0fHSujHMucZLgtzW2MZvQaKwfPRwCjv0JKnoYcGwzH671bAoa+BPYHfs2tzS9TeXwG2ebXvyY3nWqJsgdxugBQDdtBDEVxrfJyzHncJ4WTJ4HVcVX5iWcN4Q+8JAwPnGSk2eZtirT2rxxwf7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/25 13:56, Vishal Moola (Oracle) wrote:
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.

Thanks for doing these, Vishal!

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

