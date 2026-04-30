Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE0FFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728B76B008C; Thu, 30 Apr 2026 13:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700316B0092; Thu, 30 Apr 2026 13:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6168D6B0093; Thu, 30 Apr 2026 13:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51A7A6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:20:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 899FFC05B1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:20:47 +0000 (UTC)
X-FDA: 84715886934.14.E1EA449
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F0B91A000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:20:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dvxodKko;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777569645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xktm5ZORPAHANEo1eksB+LvGJjfR5yfLQilO/NnDq8=;
	b=ICqRlF5fmUV7VMEs0KGczwEB843vZH0AgJ7khAycEG4Hpvg3CbrCj2Q+n8OkyH/oE9qQbk
	PJRG9Z4WldP4xTXbuec8VSjpfYAXYt4BKvQck26zFZU++ZbZWGY+z6kdXbNdfBTSa19Lhx
	OyC8Yh5gDjpr/lcNb817PJ1d+UbEvS0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dvxodKko;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777569645; a=rsa-sha256;
	cv=none;
	b=N5T4QhEDdq+N5wzpYsj8Ona7AtJRTvfDyPpOfM46v4C3M00XLm17/DX8QEEJqNQRhdcIA8
	nkAphVuMCxygVe4QXveUYz2pmOyefewGzUSV2EyzRjGF0yNDYNy79SlEBmsJWLwjS5oyju
	InVI1/W59IZvKjNj1rHtniDQ5S7Tuu4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777569645; x=1809105645;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+xktm5ZORPAHANEo1eksB+LvGJjfR5yfLQilO/NnDq8=;
  b=dvxodKko2ZIG1NtMMeF9Qgz/jxBmfLEIXb05rbPNzFl4raOGFoz55nmi
   lOiqbRTjMYL6GzT8PpXewlGpsm25iQ+1LB1oqkbZwP1DmViy0EOA1/JPE
   AXUzSJdyIUmqQ0VJ4qBzRW1qQJwToN6AU7q6vNLZziuempn2A4M6g04Dj
   rbtfLcqEJfvY/tYGCz0JsbbyTV9M1yBehgXR2/8YtqeR0U6FulcbmOIh7
   lv3ShMKbBZGACu74DepNg4bj9LF0xJpEPv3apJElZ47uhw4QZD99ifiAD
   H8e3IOldBYx2+ZAMXbPWHDFHMZU5lU2qfPuA8A93dadvOKnTty5UA5lLm
   w==;
X-CSE-ConnectionGUID: g8E2CT61RQaEhfty1jd7xQ==
X-CSE-MsgGUID: dE5lb/u+THm+wIFchDH9RA==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="77559495"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="77559495"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 10:20:43 -0700
X-CSE-ConnectionGUID: dkSeNbSlRDSaD5LEP2PFPw==
X-CSE-MsgGUID: mjdDF/9WRO2yWYBYLW2IPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="234530387"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.109.74]) ([10.125.109.74])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 10:20:43 -0700
Message-ID: <e057e2d6-84f5-4890-9650-94ef341a519a@intel.com>
Date: Thu, 30 Apr 2026 10:20:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <3ce3f304-12bf-4e1f-b85c-11fa5832a0e5@intel.com> <afMOmZ2FjAPQ_0ug@lucifer>
 <CAJuCfpEF8VTAErMPCLnv-y5Hzo0JBpGs=L_dNfb=5C3enp2_dw@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAJuCfpEF8VTAErMPCLnv-y5Hzo0JBpGs=L_dNfb=5C3enp2_dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F0B91A000C
X-Rspam-User: 
X-Stat-Signature: buyjqomhbksj4coofjwky6f75x81bo3k
X-HE-Tag: 1777569644-982317
X-HE-Meta: U2FsdGVkX1/dG7anhGamuoPx4WpITLIUQni1JJsICVImb11YclS5d8mkjXK1rzT5pxCj/WOYld7GdBg0iw4MASDecYiL6LIjgW5IKqFOWiRpKHTCKn36oJz6vaoY8lHfiehSYzih9eC27jMkjAYDAlc1t0zXoGKbTV2F2xcSIkduChX4ZkyxqAZYA8wHMcYh5ZVv76Gu+dM12CxjauD6Ct3PmAQziPGtNW1KxrGQvO74rzg2Jr3xqPRbkT+6KP3XBEdGMF5ktl9BI8pBc1ZGylHD37331PxAkVgwnupXmGXMfMUCfGJMqFGKQ63t3/xuMMk8M9IorrRh+KtKD9aRRuuCYhgcOCQayN0JO/ttZD4eZbDwTwQ4CdANW1kaQM7RyoVjFB4GK75oLRwzDFEZJTwomW4DKfimDd/KiVLO8t8nIwe/zq5ub6DBTMvbGCIDmL2xxmJBvlqaOBuhUA/+LZjSPPxQBjmLslq0UXwB1IWfHqt+3fRw16phJ9SNEnRmpuCIqQR7kroXuucGLxUHqWXHOIIkNYM8XrHWxT21ZD41es/buAkr7P9olw7zcvLN1C5emPSSRU1hk2kVs2DPxYaGcO7E9Sfjw+h0z4T84ADJMPwvVvdtkMYVmuJ8uqUB+HNEDaUC9YveKx0KFii/cTq/zq05hOnXx5x9JwYbMYfiWp40XxxyL7/4dKacIJyqVovzkZI+hdTdchE/JrDt9FrLMdENJ9HCuSbl29CSV64ISMMAFUNLNUjRqz87+jnZdqzQ1BKuvLT8E71sw3pwnVzwyb1VALUhzDWDMGdcS73AX/qxP3gp5X2qVECQaiJV/m7N+nqQl83BvwoYMUouyb0n5CezMcKSSa8GbdLlXfXr1NBFpOp8ol5Jrhp+ndJn3M4iluuCZfRI/HsdOGHNrQVtkPkA8C3z2UffRpUXw6a4xXKSLYYEPTGBliB/RrNsbLOTvYqizdaN3UsJRXd
 UisOcAV9
 q6ijjjDgvXFW+IL3L9nCpuWVEIr/pegfcY3TiZBeGpWiYvMlZlsLeEuA3OoROPXxl/OHprfxOz6X7e8nfh4XelokjJ333MfCzpTvJDNqn8gkx2bQKpVjg4q8WbNVwa3V5TIn5VT0MGCOm5KZlgHkxU7AZtMPx4kTReuTGaGSuj0lLeA9eTOkVRXvovgcfsX8uPthM2ZBDvyJJKh7tXxQWeqVHpTYYsBR0leNI1EIGU3wCKPIdkH8/0fKGyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 10:17, Suren Baghdasaryan wrote:
> On Thu, Apr 30, 2026 at 1:11 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
>> On Wed, Apr 29, 2026 at 11:22:28AM -0700, Dave Hansen wrote:
>>> BTW, this is *ENTIRELY* an [RFC]. It's just not tagged properly.
>> Was going to say 🙂
>>
>> Not going to be able to get to this until after LSF... 🙂 Likely the same for
>> Suren also.
> Yeah, sorry. Trying to wrap up all the urgent stuff before the trip. I
> might be able to review the patches later this week before the
> conference starts, but can't promise.

Seriously, don't worry about rushing this. After the conference is
perfectly fine with me. There are a few things that Sashiko complained
about that need to get fixed up anyway.

