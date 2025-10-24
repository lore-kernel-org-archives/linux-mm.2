Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E45CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5E28E00C1; Fri, 24 Oct 2025 11:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886CF8E0042; Fri, 24 Oct 2025 11:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C42F8E00C1; Fri, 24 Oct 2025 11:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69DDD8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:48:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 245E312A1C0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:48:56 +0000 (UTC)
X-FDA: 84033441072.21.EC17D8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6ECB114000B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:48:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eeyQ2w4G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761320934; a=rsa-sha256;
	cv=none;
	b=gYoMtEL8Zn8zZ2/ic2xUkJT+gxfz+gX+xZ3TcmFkDYvVa0nyY6dSbNY2+c1WBNZVoWWQby
	BHgckGOWJp030YbXfdxW3p0WlSn7gPr7qzkmMUdBf1e/t3HKhQiymXulBdJRmrEde4RDO1
	Bd7p3Pz7M/ybgqxwh7BkWDsvekiLmG4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eeyQ2w4G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761320934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tvfGn/XdlKQARapjs8Mg4cabOjKhVsaYsQwgeclrQY=;
	b=zmmTy9c+cb7CYn238vY1bHabYyXbvPA62gvcqQrmjIS/P4k4BsoM22UWKoUfbePVfBIU7T
	vBa9T0tQWendacPENGx+yHd9afFVsJ4c56JLEI8J7IumcAW1PBMsKh5CnDSBTFg10ASXGR
	zMC56MyTb5D+ErDGL/9spEUUCu1rodM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4F6C60443;
	Fri, 24 Oct 2025 15:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA3EC4CEF1;
	Fri, 24 Oct 2025 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761320933;
	bh=e4EnLs+KI0UqXaB1trgD5GCu2ZyhkG5qzX3ngK0Lo1U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eeyQ2w4G22fgbXxoT8z/fDtch/MDr4P8J+jS/S4kZVvSq07vPD2g07HC6/gwjt3b9
	 eKRbhTkgvc1CjUwEpcktXpKF7pdlISGVeU0VwVQTYiLNsJkzrTQXQnMsNzE+pitPRb
	 W9JWWIMd7VUHMM9klzJrBLZYo4w0udKVIjsw7lwdIdun+nLbG5p5vV9JRfGjNsUXgx
	 Tmuxh6syssT//GBzbaLZISmKSVYXxDnyh6b9n+69CGoavIhi+EiQ+qoNcQu4OvN1UK
	 a9HvHHoFkVgj8jLPcZcg3SeufvzmG1xld1zU8VpS2gJRQ8GRpAWrlt+J153+yf6Zqq
	 xtg6jP2zs76lw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  rdunlap@infradead.org,
  tj@kernel.org
Subject: Re: [PATCHv7 5/7] kho: don't unpreserve memory during abort
In-Reply-To: <CA+CK2bARUpZaymPTusZWM-kzXcUp_d1UK9nUudu3tHitpeAH5Q@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 24 Oct 2025 11:33:26 -0400")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-6-pasha.tatashin@soleen.com>
	<mafs0a51jfar1.fsf@kernel.org> <aPnXVmD3cNmYNRF_@kernel.org>
	<CA+CK2bAvKrfuOXTa-RWtcuSR8rkPMhurwCn41NcUm44_vT63rA@mail.gmail.com>
	<mafs0wm4ke2wq.fsf@kernel.org>
	<CA+CK2bARUpZaymPTusZWM-kzXcUp_d1UK9nUudu3tHitpeAH5Q@mail.gmail.com>
Date: Fri, 24 Oct 2025 17:48:50 +0200
Message-ID: <mafs0sef8e1wd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6ECB114000B
X-Stat-Signature: aoyurkm1txdsbmp94xw31utc85huopai
X-HE-Tag: 1761320934-729330
X-HE-Meta: U2FsdGVkX1/soex7CJRNV0fUaNKKAL/BipJK5ljTwynRAvzZTHgI1ukL//Me97Q7QcsXL+c7kcu2VgRFxDEXU23g+i2QPk4yIJ/JaPqyriKubLKc/d8mNUYOCofncT4C395c1EOwTwDyfM5pMOeRPu/SeauEinmUrIXvhyZz6z6VelktnZYdG76hxqQzot6ixMwmSAVscZp2xANfp2SdrSzUfQ4oH9rFjKFaOH+7bA93OYyamOjT7/Oku/AMN1Abf0BAqBmAMpL4sZ76cBhqEF+wYrivUoiuXXLXVcGaUsSar2sAixzLkFLiQPqL9N3G/aRtwtnNMhGs5hmsONR/dq3WNTkauE3KBWHbWQ2AiqeUGDkWFx2GJBJuoHkJIBqUXeHVGw8fxT1hP87Yrw/6WNuYmjE9iTntiqNLW9LT7COR8mIhbb8mLoXfVLH/82DvhreTMmazGQpLz+2X+awmvnC7Vb0YAm1lLx+gFJOQoqlj+Wzhw1r2ONz9XUeHZOevnciHUPdtq0nYyLH3yB9s1SIpkOBW9LM56aFOQ3zjF8JDLtiNclon/mgPmUZEd0gMTw3h7Hk+I14Dtu0K4NaloDtAXFt18grxXbBkEppoECIKsePQo69VfxXQuP+/itLgov5JgRfT1mAYoJ5lNj/YTJIZmvZJ6gUQxLB5r0o2C1kFPKCI5kQcnAKZEhyfOEX2t1eEmqrxY+Gudi93ZPW/nEtYvprwvMu6WrGAiAJKlaK/7bnni6FFG9ng3ONdxNfA0gBDaco5+9gunJbROCorMCxjQFZ+1qS7nzfdAPBCYkZbxA2svCQ48fFFpyuLR31r5jYZMom9AB14TsgYDjng4EzNpLb1C4S6T8pFdHJZlV0cEoQiDXaNowAjftcdKrnv+lqgX9jML5X5vsLikqMeUFoXklhc9/92ipPJfhcip+CArbQ12G06Iiv3OSsmYqzYEfGMEaQkF+5eoPlWSex
 roWi8BxH
 1B/xLwk9ZEpVKD5cBbs7401y7h58yLC3VhnQDmO9hlKKATzRScjwcD43yTXaKUIGtGnQg9c8bBTFo70Rt9g7kfWpeFlQS8RKWGfjZdC2rIFBo2iR45gd4BrxczUgVJ6u2zGrcx7YgrXSm469w7SvxL+yHSVmWZJn6ka+ygnBE+N3gP0ThovJ/Kab5JjzPROwPHRd3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pasha Tatashin wrote:

>> If any of the kho_preserve_pages() fails, the notifier block will fail,
>> cause an abort, and eventually all memory will be unpreserved.
>
> This is a wrong behavior. Why should the memory that I preserved be
> unpreserved if there is finailziation failure or abort? reserve_mem
> should still keep memory as preserved in case KHO later will be
> finalized right? I have tested that this patch works with kho
> self-test: preserve, finalize, abort, finalize again, and the pages
> are properly preserved.
>
> KHO Test and memblock do not need to ever unpreserve pages, as they
> preserve them once during boot.

Agreed. The behaviour of reserve_mem and test_kho should be fixed, patch
3 just exposes the problem.

So, for this patch

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
>> Now that there is no notifier, and thus no abort, the pages must be
>> unpreserved explicitly before returning.
>>
>> Similarly, for test_kho, kho_test_notifier() calls kho_preserve_folio()
>> and expects the abort to clean things up.
>>
>> Side note: test_kho also preserves folios from kho_test_save_data() and
>> doesn't clean them up on error, but that is a separate problem that this
>> series doesn't have to solve.
>>
>> I think patch 3/7 is the one that actually causes this problem since it
>
> I updated that patch with your suggested fix.

Thanks!

-- 
Regards,
Pratyush Yadav

