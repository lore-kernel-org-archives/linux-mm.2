Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78325C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53AF36B083F; Mon, 17 Aug 2026 12:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBC26B0840; Mon, 17 Aug 2026 12:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA3D6B0844; Mon, 17 Aug 2026 12:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 212DB6B083F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:19:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7A591A0830
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:19:24 +0000 (UTC)
X-FDA: 85111271448.07.4DC7B20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E27201C000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:19:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxQbKCg+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ij7X98dQT7QjSb8oQzkX5bBuHj5CSK9JHsY1lSWnhg=;
	b=3Z28Bai7FBoTvL3SDxsUVfagF6u+K7d9aTtbAjohakywGSPu9Qv9xUwbG0qQeN2qSdsu93
	kebZB0VRQbYCXxFC6oO2rGV99Dwh2LYGz+yF2arONoCIgz06UPO2PLjTyBBlvH40Eu5KGP
	3QAGAHrKGmR+xMxKyTl+2lnGFRmMHR0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxQbKCg+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983562;
	b=PFQRQ9SId0LUMTB/GxvemzftN2OAqR9P/7kU5hwkh8vD5TsXGjFFsq4jxRsKHl3wivU7B3
	H8Kw2vYoB3F8KYBCjcdZR88IJqwHLbThuzxlj/CSqTDYC2y9q5b1eHeNhp26u2hKNLjXwX
	4X5svpk83U06u3q4B6L+5dKbVQYcybM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53DED600AE;
	Mon, 17 Aug 2026 16:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9DC1F000E9;
	Mon, 17 Aug 2026 16:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786983562;
	bh=/Ij7X98dQT7QjSb8oQzkX5bBuHj5CSK9JHsY1lSWnhg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NxQbKCg+gFl3E5wPcZrVYSzHF8bNiAVrhmlYLO7wG/CYXDHxijrKAQc3WX2YeDbx8
	 RF915yo98iZ2nG+JKEtJY4HNIHHDGxMcvYM8GrikGndsY00A8uk0GsDzR92Q5phGHm
	 X1gS5kdwQW2+O2eRjqtMRuOw34zaJAQszMTskM1FjO78iCtutgnPbijhr8ID2rS4Ob
	 aRfD6A89SCAHUxE9RKGob9d1DXgaG+K2dey/SzGjpXgovKtNBuRkrHUB359+h2CWqH
	 MJbXN485NcJKbAF6HD9vO3yWCiOXixFKZrVeKVFKSxL8TKbT0lv7qUjVSoHaRSMImu
	 zQbnUjy+ThWow==
Message-ID: <cf1d271c-f002-427a-a843-00a1fbc59251@kernel.org>
Date: Mon, 17 Aug 2026 18:19:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>,
 stable@vger.kernel.org
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-2-vernon2gm@gmail.com> <aoMs79VDCnYvA9S7@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoMs79VDCnYvA9S7@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xttc8ns1n95oh8xk46w94pobj71dyftt
X-Rspamd-Queue-Id: E27201C000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786983562-21458
X-HE-Meta: U2FsdGVkX18n3FO4NA9g5LwvP2pTLZC1kbczNqc4vCuexBVNtls5WHNl1xeoWiN+mauLJ60Fps+h4YzlILlEnB/6Cp5A9hvJTaZ6KO/ft/otNurvIiRuolxPu+TayvgVmUHTVRYgpKliI7Pu6ta/ohPRfdvEWn3YkFtnu6XspcJ1zb/2nUUGgGx+gip9EJ/CLRfOVBi594xFWzL+aRidpo+wzL5sQgAnKg37ZW8uxGUv7tBKov7wT0Z/TN5Wyc0lZvR9PE0Q2XiR/5g50jvM1MVUxYDwInQeIoviAVXn9Uzcj9l8x3AI17EYI66YIHNVPk6HeqSLRIhkKRGk1rZ7Cj0ol6/kxgZqjsDhJkNuSlLxnarlSHqXO0YM5ULT4y433KzF0t+nZHCcRZdhMgL31/ZTksVHEE7crbcxV+IdiKY6LwQxgn6umMALkDfbtPJ5YgP2ikWqdKBQvzHne9QDBNzBQTzF9ekAxxaZtiO5L+o2aD48OomCiHJ5oR0xgR43+TP8/CuIxdxzE1AFUIF0SVRN6ZyuLOW84YPt2kf2/PbClmJGznz3ypjdEeMRf4OIcrMSmKjXqhmfUzVa994M2+rmvHK/kohF2PpO0tu1usfST58eZHqbPMSPLm5VnfhVW054P1BkNl+lIs2RaZTNrlfBLIJLrbIlEkCZWOLpk7TDGHQtzDEfWXUZIAKsH+nEKOJkfyV60+noQogbZrxxHvehFTS5silwu6Vc5wcmDfCG2CezKeP2J6TdY/I6KdnveaOdPt9H4bfhG3QohkcR7NUmEym66lANDY4vjduLqU5z4pgKG+W0L2Lr+w92EA7EKP0sjGsfmH1G7Ir0KfDWYWy/rEcEE3NsbMQqW3dkTWGI+rgKW+pww9nHy3LbsbnnfY0mEyHd7Dsbi2EGJn5lczVXjgnzAdmFB4/EBloWiLC0P4nl0G0lAzMR9G9lpElYOUpkNjQ3Ly5ZOqRmrN9
 MGROPdz/
 3JMIa4aBnDASFcxghYX1i3ps5Su35d6JazQJRF5iPm51R0CQq2l03/K3dSFW+1r7oTsLx1mDIOhrYeTZnG1ewXmMXBQp+RqJG0rRFSzkERIeoFICqgACBeXnFAmDcpdYkxVqra9Ptb72T4iDZ5C22BkxPvz15B0g49aVbZgmb4QVrKwOdupqGGa/Vxf3vKc4oZLiAN2QWsZSZXVc0M0/xMTQCTRFuKORniIjpiDCyk+V7qLvEUT+9kNvaxJ5floHDsfIneraa482uAxbhvdnCI/ss/lSwoWcjQ9f23mAa+xuNYUkUmp+EhZ8IE1STF3DY6zfCjeUkES66PTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> I mean maybe better to just reduce this to something like:
> 
> 	/* folio is NULL unless exited early. */
> 	trace_mm_khugepaged_scan_file(mm,
> 			(!folio || xa_is_value(folio)) ? -1 : folio_pfn(folio),
> 			file, present, swap, result);
> 
> As the least invasive way of fixing the trace + limiting the contageon?

I raised that using a folio after dropping relevant refs+locks is in general an
anti-pattern (IOW wrong if folios can just get split afterwards and are suddenly
no longer folios).

I'd like us to avoid that where possible (and suspect Willy will thank us later ;) )

Isn't there some minimal way to just calculate the pfn once we obtain a folio? I
was assuming that there should be an easier way to do that.

-- 
Cheers,

David

