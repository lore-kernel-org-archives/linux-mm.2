Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E00F3CCF2D2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EA46B016C; Mon, 19 Jan 2026 05:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2A96B016E; Mon, 19 Jan 2026 05:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DED06B016F; Mon, 19 Jan 2026 05:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8D06B016C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:24:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D42A91406C0
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:24:34 +0000 (UTC)
X-FDA: 84348329268.17.46B4B7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F2C6214000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:24:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4nln+Na;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768818273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0/jgUo8tmW9BjuAbFG4ailzIKb6ntZqkiYQLo+zz+k=;
	b=5Uy/F8/ykxaZ7LWV1S6+idLqp+Yvh3dOQ4pL2xxogDk0RceWEVeaAuzFpbK07sST7T1JL4
	K0urD3J4/yhaQReGzLPL962tQO3jH60HCFMQPY1tr+hc9hhQASNR66bCm/rXUskDs3DEvP
	aqUIsIM15kPYfQAIzyWVCE/ltYN7JEU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4nln+Na;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768818273; a=rsa-sha256;
	cv=none;
	b=5AgQSz4O6KX6GJ8akvQ/QTxhAsGulOc75JWsbDRojBWzgDE6EyVWmWU7WYePahtR6i2lZ6
	hQo5WgYbBSw7gl9U84sXwYfIqg5lVbOxxD9nGnF6uV1/9EWTS3G6ifQS4X50RTn8Ykibnh
	H4+na+wHi/M1ui1sFLilZATjCbbiLms=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 015AA43870;
	Mon, 19 Jan 2026 10:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B14C116C6;
	Mon, 19 Jan 2026 10:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768818271;
	bh=mvbJNpYvsETd1mG8DraHNTHLW5xgdBsDlbvoAF/9yQI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u4nln+NavliRlvW+V5LE8N6xgqj02GoxWhuVIDrYUfjsFNEISVOdnWqf0O7JTZIXl
	 2mBy9mEHTsN1x8znrjSpB7ibrCtysIxNg3IMGPp+0Nu12OF7okcg/H9Ci5NKlNtrTB
	 dQ0CeU7o8tCDELpgw4YdyS15mnK0CXO2tXs85zasypH5tC4UInYLeQDr2S/ps3A2O5
	 5mkOIDEDm3FXztOwxugvMkABZh1ucrM/RggYTZFcMiScUCYPmeTgm9FmSaM2Dr2jnM
	 erG7PwCB2+DembD5GWvHRzW/q267AZZcZtj+QZsKscSBCxLpATRsIkagSA4En0v/0f
	 dhpLErbmKBeeg==
Message-ID: <ca6d1d7e-825b-4e6c-bfd5-3f36c6a1d10e@kernel.org>
Date: Mon, 19 Jan 2026 11:24:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/5] mm/khugepaged: use enum scan_result for result
 variables and return types
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-12-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260118192253.9263-12-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F2C6214000B
X-Stat-Signature: tufny33jym3asuwb4yf4kcfjecxt9r39
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768818272-339548
X-HE-Meta: U2FsdGVkX1+BR2e0ii9Mgs1mwssW7K4hErj3caZqIDdujG1u3/T14uvXyfVelWApDgJKTYaibz3KA6uK5L55oncHNZCPqKkmBl9ab5EFwnemIRoPAoANMjCk1hpx7qegD4NZ7QCrSFCxlk+CvVADMyzCVtr0kPOY2PhjqI6sPZbxY6JeOerM32jjygoJ4ZZ1xflqMu+J7+rbNc0+08g/spvCqaUcfrdWeodZl6tuoID48S1zQY+Ij5ep9OIH1oUnw3TrFMOlxBu/s9TH3/M2zynR+K9A7paKR3Ul3VXDb56UhW8h/Y12DgiKZ5vRPVDMghheN7T1ygSBzWhf3wnrB6e2WQiaiqs9klHVYp22Vl91ugQkgw4zjcEYuY4XjUdluGPc8aEcxYB3es44hs5wnr5PNEdpRalC24iD4tCKPeowoVBU49qkpnojQvrSkg7z+aNtLFnUfVNCsvfzvvauOSEsGASZeLKElesyTNGP58wdJ4uDVKVElNaY3fAUmmmXyi/TTWe/VBkFS7lN8aM1lJo8roETuduHnSGYb1cM9t8tag4ZAb5pfTh/kWprhS39A79nrx0MSFZvJ/bA/BNN8xqQcWQ/NpPO2ub5ifNfhsDrdCCTcHczcA4/nUCKjUHmEXO+jKeuRVRfqEtr/GGx4N0Eggbp+zrUYOOq6rM6Ee6wmIw4fhMcBoVOgL7WlnuJgX/cLPuhXeeLQRdCepBuIicmGkAlWBQQbfbsUdHRbDuEZMToc/YSQ3AqV2dp3qdQeMYg2XDXAWiWqj4tJPgepvmSkonABuVg9afxNj2tOVoTkFn9Gg77h4Can2pNuPNHgYZOetBDMh1uqONk3tKQJWv9i8lt+LhAXJJFFdw6gFnrvBmE2+KXZ4UKeU8ulaxZAQYyeCDyaSbdWBQenSqikDWk7Z8GU2dFBRpJ+GpcjP9XVbKHma1pIzD4as1yGL1TjTzLd9FyGBXcvarRn0C
 5me+Ycuj
 +Ul07Xh270ys+HHq1mJDnwpkVYdF6QGMlukSOBogHLVERH9dzz24ZgQ2WbJzQm9OG31XRCx6Z8ggb4PviEIGYLBOt7l9apFTipxtvUFWKai8EqRRJ3OE30YVNvmZrUGyRZ2BJ6XnToX/Tstdv/SCUjINRPdnyDAN4lr/H2sRW0Hb3nVkL0SciBMlb7ptwzBwlu2wxt09Xyxx62qDQRMgPomfaq8fNb3fgYG2i5mdYjAoEsleMPh0aXwLZbAiBuUBeiopELfh+JcaxnjwB1J8Xu3SQQ37I5IHMFX1I3bl6+KMlmSrHbmjenrwTO5+k2TQqk3iaSAee33FiYx+EMCSt9PUIU2IlDP/+VewovHhIek9mnGO+z+L6/nPMmICzNrS7Gtj0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/18/26 20:22, Shivank Garg wrote:
> Convert result variables and return types from int to enum scan_result
> throughout khugepaged code. This improves type safety and code clarity
> by making the intent explicit.
> 
> No functional change.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

