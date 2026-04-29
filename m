Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD09BFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7986B008C; Wed, 29 Apr 2026 09:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58906B0096; Wed, 29 Apr 2026 09:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74666B008C; Wed, 29 Apr 2026 09:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C81D46B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:14:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C2AE160246
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:14:06 +0000 (UTC)
X-FDA: 84711636492.17.99488A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79A661A0016
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:14:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4mPOguf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777468444; a=rsa-sha256;
	cv=none;
	b=xgJhkntHN2+x1nknJ+wjeOqoBkrtXy+w9SKkBMw0tMEoA1ypaoUNmI++TbYEjXN0FvPCzJ
	g6swUG4kerPAzniEWaxxYxr0cYp4Ya3aurv+wT+Fkw/79EoGdBSTobsMGNrRuAKLA5xF+T
	vyAZ6Os5Pg66qXxZkwl3Bp3t32yvgwY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4mPOguf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777468444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qktm8NvvIx6866Ax9tK2/mGrZ80QkMhvnay6NYBD0x0=;
	b=HA9ujdKLyOct7Jn8d0FAXoUPUWTskU7NL4R3LOXBubSOChDQX8YYO1aQv/6WTvyAKH9Z/a
	Vul+v2XFCO2sFAHaImZdT9kdYACvZOv8708ZCLViOVLWW2ik8P1o9ET99dSx19GydqIZmP
	pFcuAqiiD/wQ4uDk41qXFmKq3ppctHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D35C60154;
	Wed, 29 Apr 2026 13:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4052C19425;
	Wed, 29 Apr 2026 13:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777468443;
	bh=Ln+lOviPC8lyDW1Zl7BSxk4DMjngJAfX53+OE8S4du8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p4mPOgufJeMY1q3K5t4lY4ia227BGcQML437KJAShhLTaJE4dvY7JzvwA8ZSKOAjv
	 U3RC8RR9jDPKYhcceCIZMp5zboMKNCio0KKszuU8A37WWML2XCXZsTL8rZjGP77QSm
	 MJBqajJ7yUUOkboXc5Sdjjjz7PiEwKYO53J/8iiqanCfXwJqwDUWHBj1N5rD5ybZv3
	 775EB4OU/J+2Cy1OKIRUpCM/LrxLxXrO3UcwiX50mnDokCPbiPUgLPTSD4e0hT0CQ2
	 5thn/2pM38O+m1Mgp7kEV7WAg/LkjXc8LO4pkG5NbuFUVk6603ScyvrcQrpLwpFL8I
	 vPCBxx61zcNaQ==
Message-ID: <69bb12b1-386b-41e4-ac98-9d545818d67d@kernel.org>
Date: Wed, 29 Apr 2026 15:14:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org
Cc: ziy@nvidia.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260429115816.98824-1-agarwal.vineet2006@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429115816.98824-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jd4fiakf1e63j1ptq99xbguza3qs1966
X-Rspam-User: 
X-Rspamd-Queue-Id: 79A661A0016
X-Rspamd-Server: rspam07
X-HE-Tag: 1777468444-585556
X-HE-Meta: U2FsdGVkX1/QN7ebMQEthLX5NHb7M4EzRj1QwaU/RFAFFWERJ98Fz6VwoUzl3mMgmP37jONDrMv7ESniGwOXQ9ekDQXZ2Ahr7G8mDb6Zq5wSdVOTlRW/6qwInV48iMPH7dcvMZ8ZRwfCED4CKVkCMC4eWq6vbOCWrdcjGitE8u7eoFq+aKzNf9nFSsfLYOPGGwgwzKnhPOPquaUviiRMQKNUTiNxF8CxNPxg9UYPRXJSLMTqROB13yXggCRE7QNLFlbA0omWnKe4cEftTOGFN+E9YjfKsomaN0Y6B/GUA7eFuP3s1lwY2/hBIyergXj35FSBLMJ9OkGxI8vUXnJ5tgXcTvE68Pe9Tm5NhuxR8HsUS7oK8kF4yb9prws2uuNXGMcDbKYko2g+cFR4df2lE/IV0YzNgBDNBs+xlYGPfIB0J/XOCsud0o7qnAp1Qij917MGWFZncgDeeLYQSOzq3aZXa8IZ5a4fTQ7k0hlkD30VMmC/f4XapD2Gd/TVmtFFg2n/qP0R/TSIjGfed1pGq2YI9XZ6a5hRHBTFhQJxv9tRbE05genLdB62TpxTP8RebISCXiJY6v78S52bRQYlUmpof7YjCtyVVWBD6793DdMuRAfr0ErCPxvu5qAD3jXHny2oYZG+Iiecxlm/+3gRvZGi2B1VcAH/W23YZNBMgeLUcaodIXZxBFDvzqFLIt/uQhtscEnoxGlqShl00nuy7PcGsheWwZFgLyycg1HMx5SrB8LV+cFWXeTbUfnbcORYeZ6WhsI0F3igzITM0aMmtIkQi03HKnzbW0gBINW3+VVBvuAE2rnt+jmQhZz6dwzezOGb1m+e73HqKzg/ITP0xeHfuw1fczvB5TWF48qSX6tVjp0D9ndl36t1N2W6Y/BhexifLmTFpCUjIqH6TIc4mPZBB8rcywtAUlHKiNfeT/OrUnJGQuLzfG3hyhw50wfeiAoqv6CzSTS31VPdJUE
 0u87uJl0
 KGpIjV9OhLsPgUkyinOwEXMnaLDPYBqdejV+yVKaIbxe58cerXM0Hced28pzITMsFCY38CPiQpFYToHRfNEYEspAks4iWjuHMh0wMgsKZGUP1geWvui8nhfLU3L9LsQB3tZ8nJ2k0sz034vMnSaaBV/Ah1JNIzAPuzo0FBCr7xNd/YjVE2pLP3i099ygrkprqd3nE9M3Fj0FtghyRW5tVgzp5R1knOPYRcAs5J0d/vE562leq1wzvWQGpyIulpQkCfj8eg9ZZmrDyKAAaLU4FaxCymXzWKjVFMMl6u2Flb3xnOu4RkZkn8MFHvAs6ityTWcUubQl3jAzg+yonF+FUE9XXxGsAZ4Xc5AePbalVgamMm07aAhv8r8W85OjJ5U/Fr7i8f3rm6ZHZtN8USn9Mf4MT8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 13:58, Vineet Agarwal wrote:
> file_setup_area() currently allocates anonymous memory, fills it,
> and writes it into the backing file used for collapse testing.
> 
> Instead of copying data through write(), resize the file with
> ftruncate(), map it directly with MAP_SHARED, and initialize the
> mapped area in place.
> 
> This simplifies the setup path and avoids the need for explicit
> partial write handling.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks! :)

-- 
Cheers,

David

