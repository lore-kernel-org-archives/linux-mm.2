Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE6FC79FA3
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5031B6B0095; Mon,  7 Sep 2026 11:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2556B0096; Mon,  7 Sep 2026 11:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9786B0098; Mon,  7 Sep 2026 11:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 161206B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:57:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D4B31201BA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:57:49 +0000 (UTC)
X-FDA: 85187421858.22.45FA698
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6DBE14000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:57:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+GK5pQ3;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796667;
	b=0KNwnBxsh8duWvsfgznswqfm2/rPULkglfAXkz4M8S2tnpPh89BKFzBB0QMlhZJaJe2Shm
	vm9wQhFPpjbQC0/uXE3/5yGC4MZ92KbLplmVYmyHAZb6SWM+1Si6EujKDI7Kj0Llwbn9Le
	AGudFBMw6WymteozUk4hFJynD+zK2cE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIGgYkgMrROU3MHEa4VfOwV2akjMs3UT5a/zWa4VUfA=;
	b=nMkJCefSGCT7wXCr/1Uee2GYo7Xjw+diDbhAlF3pVd3Lr96c49WT8PFPGXOBagp1Gpf+Hh
	824rrQGaPz9re0kSrN7ksfS3C44oadgJyyhUi16pEbr1qrEy4e/A4OrCCS2MtP1xv+4Zx1
	nAHLFdbkIDHwhuwhiUOIJ/R9YKF2+dM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+GK5pQ3;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4113260A96;
	Mon,  7 Sep 2026 15:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42781F00A3D;
	Mon,  7 Sep 2026 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788796667;
	bh=LIGgYkgMrROU3MHEa4VfOwV2akjMs3UT5a/zWa4VUfA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j+GK5pQ3w4bKqZ1gVSy5osNL+pM4a1aa5geA+3I85ebNv6x8GyIEGMn9SS/53HNz7
	 4uDVJgt6zxplSB6gjwgZMHIgDhXoVvi5iR3qXXfv9dj++EirOz1M40tfHdPv8C6rYX
	 WaUaC+ER14UCTJ9geRdY+G1WJADc2Yb31s1NQSc66Y5V5GULxMKsm5mzZtuvb4WWZp
	 4ocznmh2SEQk42ihiOSDsbG5Xa2dp6Nv5qZqty5Lc8O0AzLwaPZQoew2X/yEPDvQHZ
	 anIB6CPAsDkM2MXXORA2NUDyvc/peOe0JrXOdpotaRKRuPR+9yQCd5E7CeagKKmXAN
	 9u7RDHLsmNEjg==
Message-ID: <555a40cd-0127-4b8a-8e1d-32e6517f76f4@kernel.org>
Date: Mon, 7 Sep 2026 17:57:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: remove stale hugetlb check in try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260831082849.3573957-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260831082849.3573957-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B6DBE14000B
X-Stat-Signature: 6ipjjxqz1fpgtt1q63stujdxbjgxd3wc
X-HE-Tag: 1788796667-256352
X-HE-Meta: U2FsdGVkX1+YuI9/qVRGY/ntr+YEUoodSfN61SpZr0ilM8iCd1rTWCnfgiRtzZ37zAHVviq27X0tzsY2u/YvPu584pIanc39C1CJqFnn3i2OfRGoleB+L3nTmpc4hk5TM3yWxdgnzlyWRbS7bm8swlYX4tsBGGPHV1mjWq453mSkuRLz4DzjLpdfYqWufP0PTZhoRMrhjTXA5aa0COjEWCRzB+nnspH31m4OmfpAY6Vf3S2HfEGWxzCdOc5kLq9lNnBHgzGvU/VR5WGmB1ynkfh0AlAfTU3pTljqXD1nRs9u8Ak7mrEc0GAWMfnGrZViVDty+9CPCNLsrKgaDwTyTGgJ9JGHwtlhE92KMrgHQ3pIB3nBzzFXRgFInYkyzfMdDiAqrtx0JyAEGY5fv7NPSRjDqq+//QbJBzukDPDWiraYjPY2waqMY3A1z2IIXUDxZb+q22B7bZUoar1i08VCa1iCAfuVcNCarJuPULAHD80GMUFoKVkhDPvBYBV3Bty1T3BZvNwwMODirxkyZZBLsg0HqIpOmViUGwW/nBBV2Kgtpb/NTepeNQMb1yla8Z+4jBqacQpsYB0zb+uS3tPa5iuosZ4KfJ9yiGx1NwiEoIFuZjoTc6yJJvAZn0K5PmNHSKDYHm+BUX78QE0EsEVXrzFGA8eH03JbM9od/OK/tIn6D//M6+sQS/eaS9EwGac42Q+CnawK1Zd3ulZaYuVih6h024F9DqydQYsw8gHFuiPaoMOAv0P8InyGIllxioifWBfzDrQ6hbkx7DKI7uk98wuFdLU+uzU+iblu/feaxAzHofazmdy6U+y/zbfJbYd1vY2sbv9WulJtS0PGsjeNrh3Fffl2nW8K6yXHPLNMwbrlOeX10naMnZ8FyBgZBqriKUquU8DfZth3P0oDwEtRH1uMt0Qo4+GUQTYk1R53b533CLB3mby7zZ7UiM67XqQQB+uJ5M958hc+ecm/z17
 ks4IPls1
 S892kP3rSSsEZhM/+dIgf+s4nFpfMG+uzanS63C+8JbnyHccEKmw8adFxTgyNIwR62Ny/7+FF8TZsfU5KC3x1H8d4unMxqm2kFIJtJ9eIE0B1UskYMw6p9hU6ZbSEpVZ3t6dKHkRR2n4JZPTCHI+c/KZfxY9ZLJpVH5dXkI6PIa+Gw6lPNV3dt9s9ZPuq1OPfMpRQsl4BsxWrJ0XxLs6cbF+PxBhbZLlre0+jZY8RdvLlh81MFSMN/ipO703m6oDAs84A78IiUGh0iyYRG1AP5Py1pII9ss+tuV5uh1xCRx+07ya66+vlaiq9ou13PkwXJLuOgIv+U8wAXQQcYcwh23BcDGDQLGDOMz/N3fxie8eO2yQ3ovukdrs8xxUJAiQwuHikXhdhAL4QQXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 10:28, Dev Jain wrote:
> Post commit d4ec5572825a ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
> try_to_unmap_one() cannot be called with a hugetlb folio. Therefore remove
> the folio_test_hugetlb() check.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Rebase soup - my huge_ptep_get() fixes landed after the refactoring.
> 
> This patch applies on Linux 7.3-rc1.

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

