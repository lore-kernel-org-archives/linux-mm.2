Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E9CCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB506B025E; Fri,  8 May 2026 15:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C8E6B025F; Fri,  8 May 2026 15:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6924F6B0260; Fri,  8 May 2026 15:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCC56B025E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:29:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5BA8140256
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:29:46 +0000 (UTC)
X-FDA: 84745242372.04.D792C36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0FAD180008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:29:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NYCjmB8Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778268585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftzWKpyh3pYblCa6LlkgheH/fwNawJeNyZ5GDgDGHrA=;
	b=VUivVFAQrn8x1MA0bqBe7EXEMYhpYLVnsO8yfGQio8YOGUk8TiAT97xG8ENdk28GGpEwkJ
	J808RH5om84CzQV4B+RnzJ2F2OQGU6lOWH4kRVBSJhrEWJgkvC0+/GqPClPmtXDizg5B63
	MXiGxeRc+1snqPCeUPuD/+/VeLFPxOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778268585; a=rsa-sha256;
	cv=none;
	b=JNeslBBUZ/fGpxBnCPTogWwUX/odzRhZzWBOPwQ7o6QjpFiNS/Uq95H8jA22KyrNSAfbQV
	Ewvi2ULbglss0fI4dJ1nqniZQUNHT1TUQSvWGhPXjiC4c47jcrEdYzA+2a0ubTJVfREqzc
	N602dQJUk3OJ3FcnEMLQcfdVsGEfhXI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NYCjmB8Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB5564407B;
	Fri,  8 May 2026 19:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAF8C2BCB0;
	Fri,  8 May 2026 19:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778268583;
	bh=DvOFdRiUFMeuZD8y+14WyIcjv9e/aXkrpGSFI2MeDCs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NYCjmB8ZphGxAmlYSGsmpjEjq6irXQGh39QWaFPq+buycS5sVIog4/k+nuZVTAmIj
	 sqJltnYeiz189lDSwzBqzLuJCAwPUAomyRNAO+5zVt28zKVGMsi62bDts5zgn5pu9l
	 chZ4Z9sKT6wgfHlb1v0m2HkyBvH+OgKXLL+7a4xIok3r7Q3flC9THfiSILZCLJ6LXf
	 RvEfP/oi9ShH0Ddw6XmUn2RW+6Ik+6aFTXI/HghAJ4EZzIUazBelXziA5rsfWRUShm
	 +X6tRmnkJ55Zb6Nkt+fhJYKzPAhIpwzSOZOCcCEtA/6vO9FVQZGWTcNqi0Zug8tQWw
	 OB1486nsghd/g==
Message-ID: <f50cba12-743e-4f68-bff4-d3387b63dde2@kernel.org>
Date: Fri, 8 May 2026 21:29:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: fix spurious -EINVAL from sub-PMD
 MADV_COLLAPSE range
To: Lorenzo Stoakes <ljs@kernel.org>, Chen Wandun <chenwandun1@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, zokeefe@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260507070558.3064142-2-chenwandun@lixiang.com>
 <9eea2afb-8c35-47eb-b1de-6a08503c9679@kernel.org> <af30otSSGbPxHbxM@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <af30otSSGbPxHbxM@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F0FAD180008
X-Rspamd-Server: rspam04
X-Stat-Signature: fb3ryre5n3hjf7szm59gyi7qe5m1mes1
X-HE-Tag: 1778268584-768956
X-HE-Meta: U2FsdGVkX1+9DQUkAuLSofL7lVijthP/Str+uAyiiR5nmCbq/SBr32SCyUiPjAHj2xo/rOdtTxWE8FO3UxpXOjfSvOV2Jw7+omtQfQOvAzQ68cW/tLULLC4UD6OXObDcegsNdFP1b6tBY/x9/tGefI3PxZTRnQOjt9IdBzaEmDh7LGwnTBat+ZCXlhzvRqLFRK3po0a1++LTLSyc7X0XN9Q/v83ZXiNhcrt61MV8JvQ74TXNCln/VLdaVyHoMMN/OfHVkUUtnr0mI00BaBBta6fQCjcaht+UiwK5rCrZGHPSWyNal5Gzz1VPmnY1IxxvkkyTSGS5qcl+rx8Uim4O2FTIIURFDdr6E4BOc+fSkMu/q5vlLTy27XVq7l8h75qNy7mypH5XPaohZkp0Fo5T3Hhw8skvHpgEDCUdPGfPYvcX4kH5k/+u0/Gle3anOhty4UJG0/OERfwtbOc1JzO0Bf9sqLeZ14axg7nd9LIcWdO07FIG7C5+WG4lgpjgCoyTjKHaC0uvJ3i89xG+krLWZ4LLWvu20gphpgZTkCpvUz28ToafHQPmhnSFOBWM/KEbv47VQEfczCZZeiRsxyW5o6hR3f3rlfYeffPypsIhSr8Ic49m61pF2VK/sk39FmhkfXm3FF5nlkEc097N5gniuzanJEH1XH5/rRJitF4Fmf1MaplsRcIAyRMMIA6Sk3OpjrgPIEFTMzUozjVNEBn/X4GjAQoArmj+6qAUKPe3tdOyEGlctgrO/RzUvX5HUwg1ugKSL7YODT+Lcif+SpF1H1e2K2rhJ/YWL71J+ehpfg0llg/5R6cvjGY7CRE1bqS8Dg/HgJuBCogZhIJp4dCY2LTxBzbLfRKTuTs2SioUTmHeB2S3CSs+lGvfjKlrYhRVNF7JiqGLhR929RRd7mZSVgT7FVHb1YU5apZdMYl86re2cXZ0CofklPeA04LDNTzCU0OFo9AiriSyikye9Z6
 C2CAGLxS
 uPWR2ZCGFGDLc7diMWWgNUIMAecewjw/mSNzbzdlNsr0cKKH05Y/9wQe0GdC/ge2pqire+c+SdaqfzUA+UjNwctV2IXXyJqRxPe8OanqFvJVtid6/sdl4klhNvCjwc/+lQuCQV1hX7ugtBjZWO37ylieVyITzpPnxpvrj/6y89CvSWztH3p6nzxegsipnmnqb6kqmKL3h9Xs3hXg3fsuo3/r1wosz97lSIX7v04sByLPsPIbDVjConrwGpkUKgqRNt+MJJHYKx3E2AFOn1IdzF6neL6vxMr/Rdokv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> In general, LGTM, but see for conflict:
>> https://lore.kernel.org/all/20260409014323.2385982-1-ye.liu@linux.dev/
> 
> Please use mm-unstable as a basis for your mm work Chen, this is something you
> need to fix, the patch above has been around for a while and is in
> mm-unstable.
> 
> You have patches in mm already so you should know better by now.
> 
> But I'm really not sure I'm in favour of this anyway. I'll defer to David but
> this feels useless to me.
I don't enjoy the underflow in the return statement, so I think we should just
clean that up.

-- 
Cheers,

David

