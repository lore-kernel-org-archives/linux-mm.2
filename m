Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E09C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B47D6B008A; Mon, 29 Jun 2026 13:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665116B0092; Mon, 29 Jun 2026 13:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E9B6B0093; Mon, 29 Jun 2026 13:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9ACE6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:39:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5757E1A01D9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:39:11 +0000 (UTC)
X-FDA: 84933661302.11.B137D53
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57806180007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:39:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iRWzIEcA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782754749;
	b=zoOVaGBkdD30OFNjktH5jLk3NJGDNDCZ9CVAgaCl5+rgds7/lOtevv19NiK7t2dKXE6gdl
	fZ3QkSKyQ5hqLSjbzyr1F44QSe/exqDgJV14uDtPfw7HQAtqbr0SxZ2z9o3UTGrXlGIMDX
	36M3Ae4FVUfLNvrK1MwLwSlaVYEPv20=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782754749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1GXytc1X/vRQKTBGmcPyuHMauBvU5XlQmP1PkSX5fs=;
	b=v4txjyh612gUCEtax3cYoWgVz9UU6YSZvqQHol8kDyZif1NGtErus7UUrR7+vBoHGRMMFB
	g7ma0lfZDYgobV30381TBG/yd1Pn2ak5ctdcVaNjKoB6/wuEOdLDIMPIBMumKVRFuypoQ8
	wMEk7wu22AvbHikLYfwQVEGyRTafyoY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iRWzIEcA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782754749; x=1814290749;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D1GXytc1X/vRQKTBGmcPyuHMauBvU5XlQmP1PkSX5fs=;
  b=iRWzIEcA8ywBOOPBa9jnxoI+CljvQFi94//iAyjBnYNOptFl77OiFL6G
   F9sdkvDTNUIcUs+lYLkuZ+1d4VzL5TLQFiAhmwGSx2KOYvLgrAGwvsrtn
   HLmzbNPT7b8eVUNLV6QYhkPU2eZS5yJoKH7Zwd4Ki2E6ihn91P8BP3PgQ
   TYX/7MsOIVOFIMvejCwZaTp5nBMmM8Rltmo6+iTFtS30L4BOau+V4qilE
   xBk2plA29kRWDQ0FUpw0r7Bg9ENMQ6TT0v5ZKg3Q6nMQ9MubD3pv6XKKf
   9U/ycAPkU3N5o6ekiKn0ZHXSUm5DeyxM/1lKhVrP83aBpDJrUgV+T9X7H
   A==;
X-CSE-ConnectionGUID: GZPQzi2nQZuG3ezeMMc1tA==
X-CSE-MsgGUID: T/y7ywbmSWyd3VSeJxldSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="83334837"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="83334837"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 10:38:50 -0700
X-CSE-ConnectionGUID: qRkWRLFFRCqreiUNtyGdMQ==
X-CSE-MsgGUID: Sd1XGlJmRbmz3Pk62K3T8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="253929541"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.109.197]) ([10.125.109.197])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 10:38:48 -0700
Message-ID: <684d054e-b3b0-4fea-93f9-94b2f07487c5@intel.com>
Date: Mon, 29 Jun 2026 10:38:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Zach O'Keefe <zokeefe@google.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <87cxxgly12.ffs@fw13> <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
 <a1b4b0ba-45c5-4de5-855f-7474918b52ff@kernel.org>
 <37a630ef-1574-4415-b42c-1d23993c6084@zytor.com>
 <CAAa6QmQme+d1rOCEMF_ySwCANsUEbq0mHoq8ijVELBU=d+qPrQ@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAAa6QmQme+d1rOCEMF_ySwCANsUEbq0mHoq8ijVELBU=d+qPrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57806180007
X-Rspam-User: 
X-Stat-Signature: 9mimshbnhsbcjxcd5zdw9se8h13774hp
X-HE-Tag: 1782754748-873148
X-HE-Meta: U2FsdGVkX1/JBf2IGMEjumYrkOUK6i+z7HPY/fb1ysdUoyO8QKkGPwv62PTl03aBJ4GghmEoNrq8mNoZE6MSHHHTcwrivMyLFsbxcKZRejE8608x8O8ay0vvguJLeDmDSaxgKMgBi/FFdTzuTcE3S3n76nkAjn+DIL1UhRMWYBLrM+xvwEjX3G2Tq3dFYAbbUUnQj6uBQyQXtiwVv0MVHXMGlyLLpTtgssPoQPz6Fr+wQRue2MW6wOOJuXhh9n45hfzRkUJ95f6pwrniMBXYKajAkywLKj0LXeqnritxMFosJ43ZTSoqFcQXq5Wn3m9rt6KyPq4K+3ngWtQdDHxXKvAlP3BS83GRw3S7bmwhGOnJlPZGfqFiUIvUuhsi5GyFBlWT9uDSbDewLmeART7DQlZFotB8ADgxjjvY/d2X8RSeYI5gtFbHxBGzZQA0S7OTNZMyO5diIFSwvxdh4+BAfjtNB1JNlskH27xp3ABnElMsQ6iKOCHVAFohJkuIkqRit0mPqhypeBW+uABUsyDXrTX+NQl6+lp4B9MvxQusniosboLqdodP9Oi8RQPfi3mYTgsWxA8CGGMnyy0DpWvnU3WAm36Rctjon2LVX9olzJNuXhXQzMq0OerwM5umTccHgrynpLiYP799vVwnjaIW/S5/YaChzz6HyWivpb36YO/umZXRmyfUccN+JT67pbLHyYwB8sWfX8hphHrjWw+Gch8JQf+cF7iAkgCD2KTygfrcgnRDdSWx0DwR9569hfXpZ4KMVdNKfS1eZEi0r0DYna58slYTPY/bh8FpulL9840LWfslX0ELH4VCCvqOxEP0lFZm0ZNh4ScGHBgqDsLoRf0fT4k5URUzoi8xipq9NRPKB96IuT7tJI91EIlyuJCgtJKtAplLOwFQczobzLe8tl2F35KG5JfZ5efenIniR7mK16IjkwZbT/tF5RyJ+D8oGiaStVAG2LafTVj1qP/
 2Go6lMJy
 qeTCsr23uVbeNhTjX61C0AKpJARH7B4AKYlm+wfBABBqfVBPo5vSfhOldoVqqUdIUquRWhx5YOVJ1DKZeCJqdycSznNxuISBv1htk9Ea6abQvko1GORbvY1vCT/8/lxj/8OAwTasZSPw1FhzqhuSSEaz/OTz2INWAloWtN8jTUFBnIoBlnx+epP6dIU1Z0RhwHKNVv9Gytry0cVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 10:29, Zach O'Keefe wrote:
> Yes, we run with CONFIG_DEBUG_STACK_USAGE -- which allows us to put
> together information on max stack depth usage per host/task.

Oooh, I'm very glad you do that.

I wonder if we could ever cajole the distros into doing something similar.

