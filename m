Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F6ACD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38276B009D; Thu, 11 Jun 2026 07:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE80D6B009F; Thu, 11 Jun 2026 07:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDF36B00A0; Thu, 11 Jun 2026 07:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0BF46B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:35:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5098F1C3472
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:35:23 +0000 (UTC)
X-FDA: 84867426126.08.77E59D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6491B140005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:35:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0ALYO+c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1dIK9h9F6B8P6ZX2JnxaAmWQ2iiYkZNoF+WtZ1ufdw=;
	b=EX/mABHKqbeZCLQD+KOR7WpyyUHocUIg76ZUnE1I2LFT0Wrlw+SdDlwjZtIL+DAmQqA+yy
	ii85PAIiHyS1dkyxV8TxmscSIH2+ySKklHXnDnFwL5QRKKOnGrld2tFnDvzxvCyAzvCQcd
	R/NHsVpXwEzlufwBhWXuQJPITrdn8LM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0ALYO+c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177721;
	b=61zYQkeQ3+un99T+0s5VcJamWamuEZ7ROF2jhXZTI0oQcQXlphv4Dwm9R4yllXkiGX5Ct7
	g9j71mFz7jmcY8RxkcjEZd/icXqqGzkrdnOCo+ss8iFkgxQJAZ+DE57A625BDaznitl84e
	2MjmlBnRvsAz+iN3p8arJF4vqkTRDw4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5408E40DFB;
	Thu, 11 Jun 2026 11:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EDD1F00893;
	Thu, 11 Jun 2026 11:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781177720;
	bh=M1dIK9h9F6B8P6ZX2JnxaAmWQ2iiYkZNoF+WtZ1ufdw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j0ALYO+cihXouwnl9RlcxbW7fllqBCjrCwcZErhIN0bfaGBRL0YmxYlVYuRYuO04q
	 8GQLKZ/RokYGc00ft/MTqoAFCVr+dhfUNUn3kB4uuXDPco+dVj7dKAiJYY5jXS5TK3
	 mLxsauYdIbmMFkw/hJ7tLRld3I/om5FqlhlZOn20zL9t5ruKAULsZxF8jqRP0TZfoz
	 lNYX2zjQx4/pij6lpt8mdehMD2f9iD9C13rCZD3awXD8V4Dp/MOYuOfQBgT2BCyLwz
	 ol9/4VltxlAota3ZBfgMLtr/cDxM5NMb9Q6d7HIaSghu3OsYHf6mhP6sAOoxh3I71B
	 z43yyz6W/Ir9g==
Message-ID: <7c9f0524-edff-4186-9e28-866e00136543@kernel.org>
Date: Thu, 11 Jun 2026 13:35:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] include/linux/swap.h: Remove unused leftovers
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Sayali Patil <sayalip@linux.ibm.com>
References: <68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wsitz6pnp8haikniptgipxtj3pohwa3h
X-Rspamd-Queue-Id: 6491B140005
X-HE-Tag: 1781177721-930109
X-HE-Meta: U2FsdGVkX18UD2CLZWIZfRVdtBfhzegIzcI99Zv+O6vJsDZ73fEbq/xUWxpy58cGgx1vOfBMmcubxK/eL2SoKptWDezDCja6IS8y8AuDXL00p9CZqhMwqYhi7TsttSflijHiTIIwPPTC5iDL8IgJ4Uw25neiO6s1Ts5znEPRVy1RVWBVNJLFT1r2yV9sIV4QG/5Kg/rWt4G1V0mtbmOHc/xipvDf6tX/jqg/AkFcdpGA1IxoZOXu4UHd8Thc0K6hFHLdivkiqXP8C67KcsuOVWl7hN61EyOoCnByKkekjK5XuzEqff0z22+elMLWO+d8qk61kqoH6RCP3Chdv3POl41ZESpxue8sstO1D3EmRd3zhFIbwjGbGxvOgwYnnG1qCxpn7YKFENOg88BpUg6k5jlQZkQ0ifM7d/ruzu7Wbuk/XoO7unLP4hDMj9Okli1mErmPMq8YNKbaBaVEtJhOlv4PX/gEL59itYrtYvZk+XWXw8Lht1NOQVC7N8tDqaFx2m+HbD1Kfc6bvzzwqhdrRV4PpCqNYXJIfj883zRiBnP0Wb7DMqkW7CBQ3nEtb21rOy6bI+UHNpdo0IPxiRsP/3Aas0QIm0iwlB2DzXnkuN3uIVAhL6zGXXWYdJv8z/VrTOrf3izFFKFkSRGSbQArgU7US1rtZas4b87vOtRhT5ec13StWMx03Xkc4Lnp85/Vl6wqwRjPVPbIlgAc5fKOMNu14OW9swEe0I1IXHGJOzVpH8vx7hpgoWwK0bqOXPmeRHyw1cffniA1q+uabR0ArP63pAyG4bMK2EyawCTSXzvHd0Ixettsjn3BHkr+gK7qurEm7WBvTgMq4uqzd+7X5/SbB+9ZNY76XP4Lpxgn2m9lZdrLdgJJ8iAtQ80GTds6vwce1rUZbEx/JPrCShU2Bta9PQv8Z211tHmIaq6K3jsIdplpeU+W1eBVz7p0ecHkvFP2VV05xFtVqfaLm1K
 W1Gpk+Gb
 pRDzdRFZpvbGzXLljxvO4OHXJHFoui9n8exuIOyFLqv5OWPRgvzBZjsKhTYP65l4ItuaGoo4VcUeDYMfh1GQYkOPEVX/C/my3RKuyZQ7gqjuTgCkZ5qwI4NZTZp5OsSJciMawQxBaOihZr1yvudQleiv+82LAadqmvH9P2D8yo/okcPbajWQieLGN1DxsJ6D5G7BLjWnVVhlgWqtHvxn3qzHwe3mqCak5HrXAJ7UTmUhgiP6uLEeJ/HWfUPVz49V9LkcXOnTwqpzt4ZGiAP5PW3iivgFYKMNQEkmfF/xB7ZKp1KAYciWbm75cLvUluWHw9lU1HmsqazObrTonkDHhW1O6UeqKQElfXb5SV8lXAdgoIWjBvEfesZVRr7u0+KrZyK+r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 05:09, Ritesh Harjani (IBM) wrote:
> This removed unused leftovers, most of them are forward structure
> declarations. Also removes SWAP_BATCH macro which isn't used any
> where in the code.
> 
> Found these during manual code review.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---

If it compiles we're good :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

