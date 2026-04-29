Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41CDFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111936B00A6; Wed, 29 Apr 2026 14:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E98D6B00A8; Wed, 29 Apr 2026 14:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41AA6B00A9; Wed, 29 Apr 2026 14:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0D4F6B00A6
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:22:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2F431B9677
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:22:32 +0000 (UTC)
X-FDA: 84712413744.14.0594EB3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf18.hostedemail.com (Postfix) with ESMTP id 06EFA1C0007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:22:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HpkFdlgE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3EX6r7qZ2X0uPU4V922cyyepeSTqXHFCNkyIkSV1ZQ=;
	b=DrcwoDbay+Gz0cEMeT1lSJjw4v4Yhk+JUNk35G/d7Dj/l+yE208z9VcpDkGHix20OrGb69
	ASdzy5Av1U0yen9AhggHxfnYbpgB5hi/luTOI0QsgesMAkamTxJ2JJrVolvFDeeY2oHRLk
	dGcMmNpZo2sHPvJj4riO04Xe/dXsgeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486950; a=rsa-sha256;
	cv=none;
	b=mnIaiqCQJQLaTx4OIle14xkJ6pz17iCHXhwc15A4fh+P0f2Y2v4LcR7K2plMcYMpXCB156
	FwIGCeGFnUkHgdwETf6Fs4T7SIoVfUk8cvkFgG9Yxp/R5/8gevkmpL7KEXsawJNK5+w4al
	3VDYPxYW+wD/YbD5oPN5QpQrvO9QPtc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HpkFdlgE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486950; x=1809022950;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P3EX6r7qZ2X0uPU4V922cyyepeSTqXHFCNkyIkSV1ZQ=;
  b=HpkFdlgE4yuRnzPVDFdGTZieDUr9t8lgGB7I+6mSrgWXMSWlZw3556os
   QoaCP5UwnW8QAiGzocVJDYfI30m+HBZ/ac5QYfW87O6swqoDYy9FAdDGR
   EZa9v7F5jl+86gUAmEm+AFeu4r/uUmW/TT7kjKPqzyXUiGX1IEu1YzW8+
   6VHEWnToPAJGM3mo17GuViNQbFkz2YNnrnyQP88h0aoUMoOAq4DsNb2K/
   P+m9Dzn8tAGqgvZwLKnWjvmwl+JrGcaRwTbRGshpOtLuYT7NXpRXCWIJ0
   04OF5bHI3DBpmRNkHVsCMC4yVsGT/QwhKOd0KGQh1HWj0s14iatPAuDx2
   A==;
X-CSE-ConnectionGUID: PiEWZKpARUKoPDk9EoqJHg==
X-CSE-MsgGUID: DS4RQcTsQmeTjSrS/i/lpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78136339"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78136339"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:22:29 -0700
X-CSE-ConnectionGUID: 3yoxo6ScRVG5yh29Wu1uzw==
X-CSE-MsgGUID: qPzI/ZVMSy60/SBijBUrjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="229744756"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.109.40]) ([10.125.109.40])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:22:28 -0700
Message-ID: <3ce3f304-12bf-4e1f-b85c-11fa5832a0e5@intel.com>
Date: Wed, 29 Apr 2026 11:22:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06EFA1C0007
X-Rspamd-Server: rspam04
X-Stat-Signature: dhaaht5jos7ohra41inpcs8h1fn3kxox
X-HE-Tag: 1777486949-12531
X-HE-Meta: U2FsdGVkX1+BAVhl+vmudW8dHrscP5BC942aCNr/XiF4H6OfWgnCusuwXuakezjBnEJPqaRKaZ3+sHCWdGpUj5F63csZVbaLLsMuCbXSRbtd8FSXv5atkwXb9nTjZBXKiZp2qm1UpmoQ8Znbv7SCi+QtvJxe7ssXQbWdNITZd/DnSDX7dWKWDtyp1OU5/01YV81+3HHC7M32/vfrUALMp8vAHcgqFpAuhGxyAC7cQUG1zuQfu6wHJowMiJ6LBtTl6GPeNiX3I23Eo1aqf9/rZ+m9jtj/EaRtnZ7th9nm+GuyPOjpmfgeAO/17QyhjOJCgU2ETCDMIYbXLRS4jOG7Rll6DrIU/qftXMUbMJ+LBz8YEFKRYtr00ZNWinCqQ1dArO9qC7mkhazAATxGGIoa5gG64aWBIAiZOxDgzQT+akIr/rgkyd/fM2NE5hWc4Y7XwqpJomAII6DVO1pUYk2Ag2B0DbHmcohaGFMeK8B74bjj6PxKkZsVjCZoHqNHOPTR0cDn6YQuwAECCsVQuOqi1Q+pRHm4q1/W9TJJuTh6hXThP9vXAyk3M+4rzIkbm0Wa/XdlVk+udNhK4N8AjGrK0BOaQ34yev7P9uSriMZUXqd6szfk2raO5D+E9V731mig4kPUXSJUM/MWWx49mhf5h4KK7rFFFucZb7D5oIFyULLufA+iqeK1WFMOrhuvVIzBbjwH1OhR3cMo8sdN5WjpQQ0vw7whZP2LFFePc3y0GCvPpGZIVdPvbz9dbTBHgg6J8+neYHn9jNadrlIZ22a7gpj9TAQIITGwc4VshfaKs8D613V3khRQ8u4wjs28u+bT6gyhv02NQqZfdr98c7Rr3Ib03eNwN0crIqXxI+oIRqiFwdSqmj6B+N89fRecF+u9v9ktbjgZwwi6IkXo/8mtjQ2HpuDWECW/fqFK/HfUHRYorJgMc2v7sKrfP8M15tYwayBwLS2VslJfQA+b2WI
 JLiZhYe2
 kH2d/7gwz+M+5MofaDaO6uCBVnIX13sAO2aFEd5Axgfynx94YhC4/2VwkdCFVk7NkBXc8dVObWORGXs48d3Vmf4zlIiZLNL4AqAt5/pTdj1Ij5sp2r0UADf1yrDytxQlIVxy+61GpHcpe8twpD3nfb//EkzRjNIFri6eJ18b0RGzPaFbpZJ+uFHZKoBtP1iBk70YbPCbH3rz/FfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BTW, this is *ENTIRELY* an [RFC]. It's just not tagged properly.

