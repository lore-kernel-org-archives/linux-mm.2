Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E85C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7416B6B00AD; Wed, 12 Aug 2026 04:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D20A6B00AE; Wed, 12 Aug 2026 04:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC076B00B0; Wed, 12 Aug 2026 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 354B46B00AD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:37:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA5AA12033B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:37:18 +0000 (UTC)
X-FDA: 85091962956.23.C1365C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03B8C100009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:37:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FwO/fODJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786523837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOpU8P8P+PxqLc9p84dSuS0YMvy1T66zMdPUvJPjrCc=;
	b=eGd7ggtYyUhbqmhfwa8ufxQg0IlKzzwZQQnB2CCPtTvJakBMPGcouDZIjhNTA2CIY8X9+a
	mkI5QPkTwDqDMAdzznSdyiy8qSjHY807vvcRhRuwt7GYR5Pl741bkwVpdRd5rUekgZhyQN
	GQfV3F9ZnA49XMbMf/lezD7QGOQCBuI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FwO/fODJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786523837;
	b=A+x04MANFxGgjQgYwvAgHLkTkm1wY6HzDlrfECLR3pmB2+cBkA2ytLo5DfZqpixU3m62TE
	E9hUUpVh/hAgIltLLegUepr5syqVLr36GAMnhKjEYuxwSAE2ya8RV1u4dgAI7CYtgF5FP7
	myxamNphxNmqQRExUk4fDMHg23yCcHQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E8F043B45;
	Wed, 12 Aug 2026 08:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3BF1F000E9;
	Wed, 12 Aug 2026 08:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786523836;
	bh=NOpU8P8P+PxqLc9p84dSuS0YMvy1T66zMdPUvJPjrCc=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=FwO/fODJ34W2y5p1XaJ/TxWtDKvwLua3Avo8f7oObS0k9b1CxGssuV4216jM/MbSA
	 OVdHIvhGDF92847sktqWPh1EiXL8UJXCESHezPzPKBKeEL5NuxMj/StRAsHg5BJSHi
	 UW8PANn5sXcmiu5WJFhpTPp6nyJfQZ4DiSXdTfYs3yZ83xO40A3cUjF1F6Joqa3Wcc
	 DY1ogY6yJRN1jgHS8hjVE25Etr42ixaE3+mReDnAus5HIczAd9tjN2X/9wgRl6JMId
	 2/zxQdI5OnV00xkxVXl4/WgVsq4ZlRJ1YtQjlXISRSTbKJkQia/NxCTpX0z4q+95/N
	 4HWFOTGEAl8Ug==
Message-ID: <4535a2ca-d145-48b7-aacb-027e9ba258c1@kernel.org>
Date: Wed, 12 Aug 2026 10:37:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm.git review status at 7.2-rc7
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
 <6023e19e-32b1-4110-b9ce-5063f7976108@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6023e19e-32b1-4110-b9ce-5063f7976108@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 03B8C100009
X-Stat-Signature: twgh67degtd8cedkspeopjswgusskzjb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786523836-537146
X-HE-Meta: U2FsdGVkX1+VJNU2Zf8LbPVcOno5i9AlVVwj1ZmKWnEOp/P0M6Oqx+QzmJlGSeuE4xJUwyD+FJYOZa7NggvPNenEeac/zImnOPmnhb7A2wg7XfUbWoBiNmfWjz/P5RbSatjQkmtFYAVLEJUfoLedDUhap544yCG6O+3lRQ++6GMIqF2zP/E5hTPHKmnZcG/jjEFgkVNgZmL7S5U08cDGoIKnaSF/KVs5pfqUXh74uc9A7VUVO5h1eW4JDkKbo+x9xuEYNWQehOsM4HUhLnSsI2cuwHbfvFeESP7QLNzC9wOAsF9IfDbBCkEHBXdtEXrt/RBavSijF7wU517hqXUEfpp/8VS0lwjaEus7Fj01l2Io85z7so4wIzWGv07Ez3tVrQZ/mO5Kqv4swtcb09J8hHFqxNx/D364weX0zS5kbFVmX700FWS6CnkFyidCDTZi9pTF0Ds401bL6SRF8hP0GzxvE2TOqI8mnmJubRWTTAZdFKTMU9p/9xqq7sWQTRAU0IjTa8C3kw8yoZbUjq6OJ0k1ez8QDineycyBdLCHukyWgpMWW9RP+X1KnJWJ6PD7OFtcPyPfrU5Q/YhLyxFZ5y8PrENo1S5CATDNtqrQm/EGBXkjXFBSh9j/K6n9S3DV5o/AA0pBdg8DY2+pztDNb/n7Xzlax4KkGNzlu9wPlSqNNepbqcMHRiX1iK9HszAnlQ+Jvn/wIT4tDN1qPQVey3Mj2/2fuFd/rNCJRCaMhdYcTVzWYjuEaQpWRoKkQSyx917xiYKie9QjpnNerc4xG/mqV9ariQGfe75rz2IS2gIYNtZ8bULCsXAzP55pKTMRGcIBIygny6schvEZnINqnRM78VLtJcieXGbQESxWE4v2IaNMhNFssJgBivVIIFE0OM3EaoO9tntkyOOGY/qVu39ESedXlOVMilgiFOV0UAfLD1Q5gZ3zKyQ1hxmm83oWXI/kOUGQcVdY+9N3CKS
 Nd12j2QD
 bM9fmw/DBk4SutrpTl8/Penrr7oQZzfwsVUKofAW0mfvUZa2WhLciHpuiYfciOIJviJ0UMQipxisRIgLVZhUkpXxclGB1eiOvaKhjNlAogtz55C3HZFAFuPJZxNoK7yohJuWJcoFbQfvpfcanqM/qchBBBQU2svyG3UgFFgsNUcAU0gEsXsrFKHk8lHx25dlCNqFp4W2VFZ9TpLUNeCe0+I10lmamR89eIqa3x7YO6gvrWNsSIt9tBj2ABBkcws97aEpbowU2oqHCD8jl+DCkPdNYgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We really need more maple_tree reviewers.
> 
>> Lorenzo Stoakes (ARM) <ljs@kernel.org> (6 total)
>>     "mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic"
>>         Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org
> 
> I want to review that. I am still not convinced that we really need that right
> now. The fix was the important bit.

Oh, good, we fast-tracked an unreviewed cleanup as a stable fix upstream.

What is happening.

-- 
Cheers,

David

