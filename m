Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28924CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 06:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BB08E0025; Thu, 21 Aug 2025 02:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B538A8E0002; Thu, 21 Aug 2025 02:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A912E8E0025; Thu, 21 Aug 2025 02:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 968DD8E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:29:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BEDFC02B3
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:29:10 +0000 (UTC)
X-FDA: 83799787260.26.9A69C8F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63E0A40006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:29:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=f6Y2cmZR;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755757748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8iArFIfxqGzUj6hXNEgyhSWl99z+xDKYDgIsnWW4qQ=;
	b=jDH1jl+8vb1u7htTBRKMHsCxtBYuLLBtd3B73IEXNfag6N4zq4JwAgJB2+MjAOGOiV2cGI
	7e1A4BGIneVC7loCGtxWbSCjS4Cg/qGgSpClT0b4dOacv/fMiWBXE9QREkv7ypDANKSVXs
	qDsXTOfl2aSEr3AQi3qKd80//qj+/L4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=f6Y2cmZR;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755757748; a=rsa-sha256;
	cv=none;
	b=PpxgGLOg00CmCE/qXar0m6/66cWZHCwX5x7pcxXppFeIsv6dUCrjbEew3oFREomhzp7Jio
	qCyEaCJeIBrHlUY6jbu9JGekR7GpjIpQ+A0AuS3JmcmFZmSCmnMCB+xp/ZBmVcRq2PzlrX
	A/CbuidXG+uEEv0hTswqBNar3p5y7w8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755757745;
	bh=oScGVxYxElRoNaNscAJZx59aF4CUHiYp5n6VK4Ekqhc=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=f6Y2cmZRdX0cSOHMuO4FqsOTJux5OXhWeAM7PKzyf/AvbVdC/hR0Ut2G60gnCOcLd
	 WHkFIy04wlGPbqrVNOkRtzxXuwp40/FsjB5F/cNFoo0snKjrhjXDL9OvJ4gakMBvSe
	 EFxgn7j03S8bcHquAEPPCMNw0oIORItPyMCa7OF+/3w7YQRe8xSzOLp8XNNNs6ED6L
	 ktwquup+Hbdil2LZuNAafnNmwFe6WUmXd2bgLQGsXEYuQlB3Ieay6kKworuFEzSyUy
	 8RRpiEKY53Rq1mxHbMxoafLh4lvtLODu2WQT4ROM/v31gkqyjUlCzhRh22bEKigAsr
	 p4ja4/QcAy+YQ==
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A1EA517E0458;
	Thu, 21 Aug 2025 08:29:00 +0200 (CEST)
Message-ID: <8e9d7c59-46b4-4e1b-8a55-1898302f5080@collabora.com>
Date: Thu, 21 Aug 2025 11:28:59 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@collabora.com, kernel@collabora.com
Subject: Re: [PATCH v2 4/8] selftests/mm: Add -Wunused family of flags
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Shuah Khan <shuah@kernel.org>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-5-usama.anjum@collabora.com>
 <57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 63E0A40006
X-Stat-Signature: ctha53fgn59444gz557iapw3881q4qxi
X-Rspam-User: 
X-HE-Tag: 1755757748-934329
X-HE-Meta: U2FsdGVkX18p/ISsGPXvQ+EeP05kRP0oxxiot779zInKCKCScE73rJNmlzOVTJuB35HyAHZmmSiyEjNzfIrc6ag92hYojw+vNYQHOifATco+YvQ5c9uRAB8dCWYUq1fAhE8+wP5K+skRuk7cPdFr/OHxPl/UVro3sQNiAavbiwvH3un1MG8zTl1/JNaswn3vxKXHvzNYQ8epi69jMiZIOKgCJsJk1FEKsMXOg0lKlgUkiHBP70MO9ZxV4oTFEWIQiLXPG7Zr2UBFyIA8P9VG51ldDdVbqZucrYKpteUk+DbEsD42wm/FNS/+4V4wJ0oFModziHzIH7sTXKvOP6sTA9nSS9CZV9YrQolakURAgnvuC9NGtElVa0yvL6XY4Thb75bmphoXcvkugH5L7hx5u+/duVgnnnTSGs9Y8HIOMxqQSMIm4OUNWrVeJucbo+VLP0maTKzSo1HTZlpqou5ohXnv6HKk0W0ivJgUL9KanysUaHRKZF5v07E+ayQV8ekZelEzDFI4OdUCjCozp3P/XVrHWVVhMZDE7H6/CmpqklyU0JCeKvVbMPVL10e9KXHwEEsZFK/o8XAH3LWMRiCZoRMbLpBvnhru0pNke6yQReM79UeTv/8Yz5qlHSyGJdffXPLfmIMEs1MKNWV3tZho4Vsa/W0ZreYyzqlwGVlIsaTonTUQBnIQceu35KOlx+UnCfyNQIL6CgtPg9MNAZaxqwbSIdLrTlEYjeVxD5SWinlCHHfGAS3jZd2ORc7RRvRRgru8uJgUmKXBZxG2wFv7gmdi3EklsfvV819lt/g3FRR7tLCbi8jbwAfQMBJA9v6R5NrIjns4CSyR62JwZOnz4YQt0GFGxhOZ/PaL1yjDCVCy9XPzgwSGG88XKTuKQjDQITF4rl/3yslCB02Z1Dj24Z0Vq4HK0NhQIcvt9h9bjg6hVYxWKZb4aWIk7fR0crXM+Goy1mvWX6q6+ZhyXik
 zCiwfmHj
 pACw2dd47wMY9kn7ce63xSwU7vMUY0wDriL8iFdKa/r/LLVhqrGCasWSIHQYTGkL1rVj5CluqPR9qWniUqvup5yPKMbbbNVmsmS5nk4y20vdSeohkjYEWdY8p+oOwFsM0F1ity14wdhNRlzquOAs2Y9zw4uleFnt0T6ZoFdq94MEnOY/t+y0o5dhYJs4WYvRatwDmMGbryPWb3E+/kuBV3Rtp2D8OjQK8iOMZOjymQHn5Nf4hxygld7Thv4VLTzKqb5dTO5UDn3+Cp4aUz9owYYQHRQ/P8j4iyeIEnQEm4K9UG5ShD04TX2IX/V5whsMIAWv0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/25 1:16 PM, Kevin Brodsky wrote:
> On 31/07/2025 18:01, Muhammad Usama Anjum wrote:
>> [...]
>>
>> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
>> index 23d4bf6215465..d75f1effcb791 100644
>> --- a/tools/testing/selftests/mm/Makefile
>> +++ b/tools/testing/selftests/mm/Makefile
>> @@ -20,7 +20,6 @@ endif
>>  # thus tricking Make (and you!) into believing that All Is Well, in subsequent
>>  # make invocations:
>>  .DELETE_ON_ERROR:
>> -
>>  # Avoid accidental wrong builds, due to built-in rules working just a little
>>  # bit too well--but not quite as well as required for our situation here.
>>  #
>> @@ -35,6 +34,7 @@ MAKEFLAGS += --no-builtin-rules
>>  
>>  CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
>>  CFLAGS += -Wunreachable-code
>> +CFLAGS += -Wunused  -Wunused-parameter -Wunused-function -Wunused-label -Wunused-variable -Wunused-value
> 
> -Wall implies all of these except -Wunused-parameter (at least according
> to gcc(1)).
I'll remove others in separate patch.

> 
> As to -Wunused-parameter I am frankly not convinced it's worth the
> hassle. We're getting 90 lines changed in patch 6-8 just to mark
> parameters as unused, in other words noise to keep the compiler happy.
> It is not enabled by default in the kernel proper precisely because it
> is so noisy when callbacks are involved.
> 
> Patch 5 is clearly an improvement, but I'd rather take it without
> actually enabling -Wunused-parameter. The rest of this patch isn't that
> useful either IMHO.
Patch 5 removes genuinely unused parameters flagged by the compiler. If we
drop the -Wunused-parameter option, however, new unused parameters will
continue to creep in with future patches. The goal of enabling this warning
is to surface such issues early so developers can address them during
development, rather than later during review or debugging.

Long term, I’d like us to rely more on compiler and static analysis just like
kernel to catch these kinds of problems proactively, instead of waiting until
they’re reported or someone fixes them later. While it may feel like noise
initially, this is largely a one-time cleanup—once done, developers will
simply fix warnings as they arise, keeping the codebase cleaner going forward.

> 
> - Kevin


-- 
---
Thanks,
Usama

