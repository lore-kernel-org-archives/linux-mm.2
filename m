Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 318C6FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEBB6B0092; Mon, 27 Apr 2026 12:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5FB6B0093; Mon, 27 Apr 2026 12:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCE26B0095; Mon, 27 Apr 2026 12:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7B96B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:30:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AEAF160355
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:17:48 +0000 (UTC)
X-FDA: 84704841816.12.84886EE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id 54CFA140010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:17:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=atAyF5V3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777306665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dcTPtEgCjh2M9mDrwUavxI8BYuK+Pfj9ubprxVb3P8=;
	b=sZ7yjZPI6aFq+ecZHMeI3anAuFKJfDk3UtOxWhsteDmj04WpzCyygN2elaq7nDLit8zrMC
	Sx56wViCHgDjfoLofvrcYM9RpD7XTqHDIFtdvGZhIcxMebWLcVoIRMDadkiKyFkaNkK1cH
	9Mj41dM9GkxJaC85Pvep6t+86pW18tY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777306665; a=rsa-sha256;
	cv=none;
	b=h71PTRsdvnHH2SEdonqM24lbsfUeio3dAAz0+6MI8p5tfVNwpeXZTrIGSRAaVqrp93zJ1R
	OMCFAS83ziPP62r2NvjxrA6SarYLc4uiYDYdU6TOCZ+f3d8qOMM1eQTpXWqvYNtU+2CRlh
	IEIW6rjaNGdbE+53V2MPiHOv/vOfxwI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=atAyF5V3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777306665; x=1808842665;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OKcVM/2JFrfKvnWNn6/KDnT/Lc2ezyX/R1wGDJqtOTg=;
  b=atAyF5V3PofcuE9OA1yQlTG+B0FVRt9hRHFba5sFXDrkufiTbs+C3Pam
   R+mCecxHO5xXdTNMEKedCVed3I9fUTUqUrRLtUXh/COYmSw63H0lXQzxM
   GlZD9uUg7LjzGAJiBPkgbvTkKWk+O8fma7eG61I+vSKHJZIxY9+2dvhqR
   Z0dtexAtc/yhRKqLQnf8uqacvzF9tW6ebDCb0Ya9Ln/42SIbAgVwNVLSH
   ks/RqwtkMHK4ckgc4VCYOzZqvBwELlgwlyM/UzlT+CmzHvka3t7DB3NFs
   Z/3RjGN4yhk+lnYPDAmKcY4uKaieN7x2MpMmlqhKaNlhBrmJt25UelYzz
   Q==;
X-CSE-ConnectionGUID: pSELxDSkR6yJpDK1vjo5Nw==
X-CSE-MsgGUID: X9V8RZZgTWu20AM9TJYtqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11769"; a="81808053"
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="81808053"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 09:17:43 -0700
X-CSE-ConnectionGUID: 0X8Mh1oSTgypmIqwUvqNEg==
X-CSE-MsgGUID: jjeY9LeyROCMyQsTgNZoEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="264087496"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.163]) ([10.125.108.163])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 09:17:43 -0700
Message-ID: <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
Date: Mon, 27 Apr 2026 09:17:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 54CFA140010
X-Rspamd-Server: rspam04
X-Stat-Signature: mqtwjhiphi1esob1tb7nsmaf893gms87
X-HE-Tag: 1777306665-625998
X-HE-Meta: U2FsdGVkX19s1yrJIxZNRixnl1I1DU5CodU3TsXjbJdhrBbOz5UYUw3Y3WiEbJtOvaw4BGjN8z5dygzvrDYtpg6DNWpzWKuz9YMQeqCcsvO/D3Amg6Kg+4B35pUgFkiv0A8/Q/yY/3i3zwQ+huznqzGei/q11o9He/CycEOULUj4GaxtqDNLebwkXVbStbk3k6nHvjxrw50psso/LkJRmW1xuAH5J6oWpozmDHa24fjrOCJ8W7hhTjkKPIGF0ShHOf4N21fx+KczOU8rHjzGgYMZbbdLPMIUbMIB2QUZqTYjYDc/X+dgQV8mNeqQrDjS+8BuaTBAs+5cZelONbMP/ppq1OLVKNvGNG8INck1VN6Wc213JtoJiByy27gfRf/XcUhinMItvyqy7k7g7mToNlmR/aUxU9i6he0Q/uASfEgLeykoMjYlL5VaCNNnt01pefLB4Iy2BOGS59DSZzvr5FNXb0ex+7Mc67WY+lKgZv5nNwEzVJKJ+SmADLW/0dDWDSiRI5F2yZTSESlvG40nKbqnD/Bn2IFa6sMfbgnc5e0Sj1wxLN1ReCVNsa97jeJXGVW1UHaT4lZj5+TlVFFblI1ggIZmcPyR6DupjA1mlMpQLHysSG/lO/WjkHYoEkhoGtyklksC02Hyb6mfUA8tqKC0WlZ8mo2VR2xvscApLJsQh/bZvMypNsvDRb84QuY2+cQe1dd99Ymw2zAM23ZKkojvfQ3brCt49Fx6sfWWmfTWP0tdA/UxvqJMUCSeiMkaGaU8BnrzASLqhhGu/wO780jkeh3VC0p0im8qFPXpNGkU3MdW46CbE8ZRb8Ul1Dn0KYWt1mkxZRTmD3JbRxN7D9p4COP5fc+4c998H9433VKDt1Jcm/EeDoR1jteWZxXilLcDz0bjGKGqpr31CaTFBihDA34B2u+P8sz+20Z6Dvz7r5HKVBQbweVvauoTpHUSEcxU4+VbD9VONa8Y53n
 MBNu6pc3
 n84kz+jYeII5fwqJ8NGsp6G38QukrxYOY6fesoMg/Rxk8j1IFgUtfeLJBjcN3DEPsmxsRCRW0AfLcvBoetm5ruRkN+hYX2qou5brpBpC742zfgP6LthX3RcEDpjM5sfiTYMrcrGglbLEMIZwIg4kSBC8qzEh+z/dFOOIIkpQ9YNd6Fd692zKHRjSMtG2R3QhkPYvwiFEkGEmvSu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/25/26 02:19, H. Peter Anvin wrote:
> It is worth noting that this was one of the VERY early design decisions that
> has shaped Linux from the beginning:
> 
> - No swapping of kernel memory
> - Kernel stacks are statically allocated
...

One other bit to add here: In the past, kernel faults on kernel memory
have been allowed, like to populate vmalloc() page table entries into
the parts of the page tables that are not shared across processes. Even
*that* turned out to be too much of a pain even though it didn't involve
allocation, and the kernel has been moving away from that.



