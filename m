Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2047C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23B06B0095; Wed, 16 Sep 2026 09:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4216B0096; Wed, 16 Sep 2026 09:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2996B0098; Wed, 16 Sep 2026 09:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD996B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C106A5E6E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:32:22 +0000 (UTC)
X-FDA: 85219714524.23.7238EC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AC8BC1C000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:32:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNk89v3R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565540;
	b=bBTE0M2bEUImt0DMxzOVGUdvOzAHxoDDTZL11jFcerx6acOYV+KrkrnbAP/PnQWhsNt9RP
	194IPZOT6+duWyZSGsACWTgqxTDMYMeM1dwfTKJQiHHpvwmKwFhnmuH1iSlmcqlwun7WfG
	9fxI/rmYaOkLA3w5n5AVzrdwqzXTtcg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNk89v3R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKoMOvgofwktZmoUuUYwgSaKNRpTiD37gRdhxHcH9IM=;
	b=sv4qFZ7A8WsmoAuYcqAw68c6oY6mNT77NRV3yDbZcK4RLakEQZ/UZ8ojgp38w9gjs7+Bf7
	+jkw8FtvkpJONMaPlxfi6Hj/KsCqU8xBKipXKq+8NWjByRqvZwGoObdJoiNTI/k3L1+veD
	4VMV+hY5PAAHOtNlH1QH46hu57lijdM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EAC5602CB;
	Wed, 16 Sep 2026 13:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E936F1F000FF;
	Wed, 16 Sep 2026 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565540;
	bh=DKoMOvgofwktZmoUuUYwgSaKNRpTiD37gRdhxHcH9IM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bNk89v3Rdvd38fFvrhXtrco6p421SlhJ1qFm7IaLPOFUxKu/h9ghCRcc6TBl0FUuk
	 pW+G8O/SLu4S/+mCwe2OGNjQSRU2vzMj9hu4UtooAkrxqP2dSN2cn5H48m33qMrL+D
	 Yshy7d9e/IVpTidQ8mlVvmca86Od3soaTPQ54nJxtI6XF7I0RSAkuCsVS7Hgp+gbNx
	 NQ8xPZFF3vSt+TF0bJnYpRuN2Gr2FKJ1uTPzwS5UG2CJjq5m4OiIGddUfm0dn0oN/V
	 HZ1XMKE3+y6o6z/iD2WbXm8GPrr95SNcSbdHw/DF0gDeYQJTa0ysNz7EVh2t23BdXM
	 wDAvvkmOWtTTQ==
Message-ID: <dc0e039e-49ef-4692-a07b-2e4e4a067b3a@kernel.org>
Date: Wed, 16 Sep 2026 15:32:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/17] arm64/mm: Convert READ_ONCE() as pmdp_get() while
 accessing PMD
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, Mark Rtland <mark.rtland@arm.com>,
 linx-arm-kernel@lists.infradead.org, linx-kernel@vger.kernel.org,
 kasan-dev@googlegrops.com
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
 <20260729122452.3797443-3-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729122452.3797443-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC8BC1C000D
X-Stat-Signature: bwhxi531feypao8rh9hyr1w43n4jp5zy
X-HE-Tag: 1789565540-481938
X-HE-Meta: U2FsdGVkX19w3uhItpGY1l5spHwiP7cActQUAZbG/viJS6zX3+CRuia4r0Nk31QTUUPqGiv6QGDGi4Pzxj3lPNuzqhJZchQLLvSmir28vfiGowrEBt5zKuGSawNp+lkmLXeC2cz7biOq6gtU7iPoZWfGd57wpRvbB9DZ7CypclDpwcF2upqs8XEhntjsHRnOexdRUvhewMzwkjV1X7eVF8Rf0mksznoxfod8XPNT8TfCsLGJSpRMvxklunnmck4UwPj8nAvV3YWc3hrLrO8u0lojHD3owR+Xhme6aU55iTzKUEnymVpBGbmufLOEO6Cdo+M6/L/w1HkemWHgvbNKWxXd26MqcjE+/ay9yOF/PpgruvvWPHTfU5+RSj3JCtraUVjRgOmsBg0nMnLRfjL8GBqsFqDvzeKCdkTVo8wgdop+KE5EG89iuWOJEeEaSiSg7BdtjCLI7vjbBOw9VLZLLD6E3pT3i+3qwg4VIkU1J4VK9sawaXKe3Em6bnB5MCvti8TJgPC++UIKkl1+YXTsgvtOnfSrC1eyQoYjyCmPxVuBpKjhCtpNe3BrYFLE7tp9bDgCC9cmOy/UM/almPpT8n0NsMNfp4qWcLiEJXggVvBG4V4LjLhcCZMK1gA6KC6AbZNK3uRLmN+hrtJU63WXzuM5Y4HB6ntQ1JmTMFjvFnVtFZsDOAH6hwz2MUhCKXeHbhLzv+McCBW9NSuUJgcFO6v7ZfkfJI5RYBeKTQFOU6P4eveJuYHyHcHrMiG3HZydPXhm412woHzNCIh1ExVM1t5rDMHDTSEDCzEwJuUv8Rao3MFMknfe/QMu2FLtUnkI6iemHJ0CME15fleQDw3aPwBavfV2ZxcvU/5Z+FeOZGElSMSnWHMOOW/lnB4qmW2+ksjBuGtLnrn1j2vd3hDkRnWzkfHsZpjBnuI6kWw6GUVl/1qn4ZGIqWaY6VnFpnDaDwv5EemGu0aukqcEPsB
 efMdPd8B
 aQfEuSRaOJiADonBSwRTeiyHV7rpFhdYuL1wK6aZ5c5s9CIjPJPZZq/i1iXIFAlV1V6nfIRbS3MqZWQrZ+GzsXE6UEsUc/T1QzD+W3ER8JdPWCzfefy6QH5lv23zJdWJoRlx7pBz5iJO3/ku2J/Hj0IgTIjl3SbTVhq2tEVKMnkK3+vyJqYw4QXIcsDU46eKcTAjIGA+HZE6mhzbORFmdcByizrz8bjQ3kQyaQ5BjMsW78wI7EF6Ze/x7mP3QANvYpZ1TMYvmwFzZWkjNiyEtW6iKx+aK16mLU3wUpIwnILy+wl76NK3M2D/h60d1wtOSM0fu6b58orKz2Ow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 14:24, Anshuman Khandual wrote:
> Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
> support both D64 and D128 translation regime going forward. That is because
> READ_ONCE() would need 128 bit single copy atomic guarantees, while reading
> 128 bit page table entries which is currently not supported on arm64. Build
> fails for READ_ONCE() while accessing beyond 64 bits.
> 
> Load Pair/Store Pair (ldp/stp) are only single copy atomic if FEAT_LSE128
> is supported (which is required when FEAT_D128 is supported). Currently 128
> bit pgtables is a compile time decision - so we could have chosen to extend
> READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But then
> it's a general purpose API and we were concerned that other users might
> eventually creep in that expect 128 and then fail to compile in the other
> configs.
> 
> But worse, we are considering eventually making D128 a boot time option, at
> which point we'd have to make READ_ONCE() always allow 128 bit at compile
> time but then it might silently tear at runtime.
> 
> So our preference is to standardize on these existing helpers, which we can
> override in arm64 to give the 128 bit single copy guarantee when required.
> 

Best to mention here that no functional change is expect because the common-cde
pmdp_get() etc helpers do exactly that.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

