Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F99C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA4C6B008A; Thu, 17 Sep 2026 11:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D726B008C; Thu, 17 Sep 2026 11:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624FA6B0092; Thu, 17 Sep 2026 11:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 356B96B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:27:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 487D41203B1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:27:45 +0000 (UTC)
X-FDA: 85223634090.02.37AC7BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 912B2180013
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:27:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C0d/4Q04";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789658863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kShlOwXZOiLnNTcZN24UV1pqW1Tr7XKc2Bdzz64GFwY=;
	b=k5uz+rykh9dTRAcT6gaEe5U4LghFZ028wwrEazCeKrEx5mmRz9G91ci0TRjOATjjnkPqRO
	YRbn8qDPipq5Rr5jAohJfVCBb6rU95CH+o2X/AQpqw/+KGwrIYiDwuC490z2KHRGJb/qAn
	667C0hMZHpJsc9t3+F18NqDutrbXzHo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C0d/4Q04";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789658863;
	b=N/CDsf/02R1lyRTCveJEh3rQA1hxj8Ai9Eb8kUlYpmEN1Ctq0FFed50yy7fOcwgxocEqX9
	82AOtsNAovTew7dHcped/pekSBsTz3b3kEGQ3Kq2YZRPEU/5VzsQKUhLguCRJWCg7D9gr9
	auAXKIWm5Ryx7fKtwutv8BdYaB/phYs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 470DA60214;
	Thu, 17 Sep 2026 15:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2804E1F00898;
	Thu, 17 Sep 2026 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789658862;
	bh=kShlOwXZOiLnNTcZN24UV1pqW1Tr7XKc2Bdzz64GFwY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C0d/4Q04O02HyFFNEtydce6Piyzk943RaY9kGhvSWle232tOluwzNBzYY2OrSb/G/
	 x5VENXPKhHbLLs7BUpIWPA1W7w1U563nEHR2Gr8VXJEdTANI7yoszdFkIw4lgiUWjB
	 tYwuzzFrek9o8V8fpi9VJe/msaP74i/nZ6NSdvicIe6tiTpn68HfSb8EqDOSSamsmI
	 p6gWMxDSGPlLU2RmDusWaVF4K1msBsUs73zfO+plVDSdasJl5v/OJnYfVGcdOHOKFw
	 2xlls3vx0517/a3tkjiVV27TyEJAMKjHJD8YStlRKxAKoeFMfcxxgFIPMeWrzHmSJO
	 1/VYiKlpr/u/A==
Message-ID: <2c9bbd00-32f5-4579-a6c3-7b18b046272b@kernel.org>
Date: Thu, 17 Sep 2026 17:27:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit detection
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260917054015.23553-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917054015.23553-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3xhxb7kwe41y7ohnr6xgszb48an8jx4c
X-Rspamd-Queue-Id: 912B2180013
X-Rspamd-Server: rspam07
X-HE-Tag: 1789658863-862675
X-HE-Meta: U2FsdGVkX19Z/5E1dLazV/wxVI257dlC3dr7+RXgOWTMXNokFxbJsGcg6v9LrU68Dvd30JbJ3NgBYU0aQZDyEZRSyvIFgh5ErlHD13gRo/FdvvaNLd3dTNpbW9RmTK95jQVLPzm4sN72J3QrqZGWcR13r6ROkhk+dF6ODM/DO+PWzkofwiLjNzEpx+BTGL0bkOEYCOaJlNEo6TTVzGXBb3+tQFj3gNyYcVHR8n31ihesujsqew9KUdMNSvPSnHKqiTrobDSra3YcQq3wVVsU2voBV9LfG86SvhvduE7NMkskGNYK8AwPDPdsOaihLq6ziR2PLG3olL1LR6+BNcW1KpWuF1prMqshwbvaNBennMYfaOm0W4qhI7XFYn195PZ5rjpHgRYFXlVIy7QRISQSZFvl+M8k2U5mvvLqzOXtXV7rs0qL5+mSX9oAdGs0KH36FcAbD7VpD+pPb9fsI/eOP20pt5vRC+pcwhnAkbIMfxvVwPFXju601AXCtglGFJmSql6oy1juvlS/bZhUTaD7yvfrnsTPLfsb8GUIKW+GyAJg8MBvqq8frfvsnwvaj9aBIZhL6sInf+tPrQlOGvPhI0dVPxPDUj7KIp4WT7BUX4QuxM/1gHz4GJYtiDkTxFuc+hl4WhK0sN7xEMC+eQJBhTNpZVLXFf8Re+Zow7BI/O+sgzOgka6CDtGpijwci6MpOT9IlhGs2zxDz4D9XW6TpJElHp/sqUyXEWET7QhYEu9ptacWxxM3RZj6OikbHwCOQ5feh9vLM1xeAXHJheipC8PDmDK9F3/l/P+2Oxg0LQbLg9UmnD1ArwFmajUGf2L3fRJbYs6MQS/6fZrJ8XSaycp7UczJxSy/FYiEERmkWFDajAV/80HCDpUnfOaZujy53DMH1vM5lUmrCj++AA57V1Qmtw6asPFzLQmrexlBQWrKDZFxNsNfwv109zs97gN0VOYlD73dToFb/aAfrgA
 AojpNJYw
 ziaImt6q4R/UpG0ZAGMAS2isutEQxyBPlZE34mRNuPtuvwFPZfG0bkurvLrR1zCmqxOItsC9M62xhivdAsCbdW4I22R6Sv38+DWW3IWjt+tN+gYYAL6aso54ikaIJlvZ6Fsv3qtvlm9z1AiKSwifL5JjojuLtXgVFn00pytgANZWu+LQDhCqxlge3UT8s6bc+LeZgKMIJKYDWAbteXKtgqhfML6Z7Gaaoa+wNoA4bMsGUkXtQKMnr1LTxGkwCKRjS9bGAYwpsyJP4IDX26UDOsSkMOXJjp+ZX+eqoqYJsW814coDlr+kuy4mK6ROtxYA/PydSVKcMNywjREk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 07:40, Lance Yang wrote:
> Whether a PMD has a deposited PTE page table only depends on whether the
> architecture requires deposits or the VMA is anonymous.
> 
> Implement this rule directly in vma_has_deposited_pgtable(), avoiding
> mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
> to withdraw a page table that was never deposited.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

