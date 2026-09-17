Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8315AC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20AFA6B0092; Thu, 17 Sep 2026 11:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB4B6B0093; Thu, 17 Sep 2026 11:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085D26B0095; Thu, 17 Sep 2026 11:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C33CC6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:29:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4ED9B403DC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:29:56 +0000 (UTC)
X-FDA: 85223639592.27.7D6361C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8E24414000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:29:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fxgCSlx5;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789658994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WxPtrIuAEb4+1h/R5tbokixOnDPh0mmusu48M2O2g4=;
	b=0T5CUzBst5uO0AParvPhcW+HPU1Y2ZxSBA0vpO/EViZIoobU7yV8oNFn68cdUoBfvdP+zY
	rMuc7St+kQCPnGeNEZFlE4z7R/Nxv4Q1ZDBQgcMTf7yvlpR2QDU2Tr1n/NCXILfmwM5aDd
	/cxSAcP476qogYViYH8TSDJZ8pYxf4A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789658994;
	b=dISSu6qUfLVSjAC2oqFuCccnlPPsim/29dOMnuU0Fp+KCdFpxrHkErtu15jhwMcQUAhHUT
	G3/RyZqj+ZEpAdXDip9D4KKR8qyeK4UxfVL9t2RVMj1fVEbmHvsBvUMq8RZr9Wsh7l19vX
	Fp+lXpjFMENKwg+jHwEU1cAGDNp5C1g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fxgCSlx5;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE37D600D4;
	Thu, 17 Sep 2026 15:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90921F0089A;
	Thu, 17 Sep 2026 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789658993;
	bh=/WxPtrIuAEb4+1h/R5tbokixOnDPh0mmusu48M2O2g4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fxgCSlx51Fk9w6LKE73pPGRFcbVnACo3pctojXHqHqz3aUqccWa1r7ZW7mbkZ/vrp
	 RrqubvT3M7YmFzgQgaSQOOfzcxNsOWyW85r4GkrpdUfJOO+nWj5jxJhR/SZRYvzrW3
	 ffiSBfA7WOyg5BtEDQJ2HAlzcFtfr0s+W/H0uPgqFl9nNVw5jhnoEX7KMTa6AYXkp5
	 4u9pap0dbIVXzJE9wAIWn+ZEyW0f1Nf+LmylfWX/wU6GwnUY2edAOfTF+szxCgdanI
	 Xk5UtLvWogbI6/OwlmgFmy+dNflrFZsjVRSqvZxTl2wtF7bf6R9VQutQoVQRGVdbLK
	 vwgZuxilUXpHQ==
Message-ID: <8c70259a-94ed-415c-89c1-572145c64670@kernel.org>
Date: Thu, 17 Sep 2026 17:29:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the huge
 zero page
To: Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260917121010.60966-1-lance.yang@linux.dev>
 <aqv5r6Ar0vyKXa_x@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqv5r6Ar0vyKXa_x@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E24414000D
X-Stat-Signature: sgnjgjqkjqny7q7e5m3zdi3g443oc11e
X-Rspam-User: 
X-HE-Tag: 1789658994-361421
X-HE-Meta: U2FsdGVkX1+/wg4dFlnNe4YT+JdiniHjuDJgJhl+WgNhuFPslFEfw/x+SuxIAjaXQmjCT3dNG7hHPOGFlSMr+jvdv13xkm9AT7EX/Kp3H4At+G7CiUaRIaccwtDgs6WSMnK+RWv7nv2hi1/aAf/aSYlB/Vcz5F91Rklw7Pno6qGKwt03j+wyUhLl579Oo0S5DDtWY3SE9bIynUlpm23Zwck4lRcoRFVPqGhHXcS82Ux/NtZzHFEubL82tOnkjnFIlfuIJDC+pXsgcERX+buKtwvGGb3NQ2jVobr4u5+KQ7v2uWVgh07GusAKo9ymtRuYuu60fmqy8WVDZGe/JCj6XQmMTaKdw54W/p2lnI6E7brD6zRfAutc2/uA+lcrEYF10n1+SN6uqkUTEe/rBy5vsRyyTEfH9/rW1NvCpu9qe8IvyymDDXKdoScrCgSFd1/CRgYpKBQvk+EBEpsgwRzvIFbhSrUQj4PjM7eiJy/wxr/x28E4LOlUJK4pyR6bkPsAhA53eH0p/DM0jFCSXiygb4b3ToM4MGtqEx38P4S4W4rQhRVSULvUXIMLZeSwc6KHeFivinoItW4fCfztA6sP6iqwcqA+Z91xPALzzcOq5yA5c9kw/m/4L0NmfAONEUAMYZA1lHmVXrrVUYAidcvIB0ar03b22Sbl1+fu0pDt5JM1hL4NjUSLmvKb7oc+YlwntcvQtQCxoszEOkk1hSth77900JfOC63QZp7VJQKyoEQc//3ry7Wk6PN08vlZpQ9OIpchCxyWo0c8hcI1fkZS0WLyn5BqIbR38SVzXJJM/WFdRQ9mKQNTo7U6wWgxTngoDbzSeo2VJZvzm9EG9ruzT+D0vidI8yEHiZ+zMGAIM25LjOIaFTztawLcSj9fjFywejGBA5X0CEIysPKtO0eGmKA6lgu4KLq6LQoqAkOwTIquJ8b7ipgcTfib8FV2YGKKoL0Q+7M+FHuGYON8u1d
 bEGacjRU
 LjsUIAiV+kB5cSM/2VUj8Bp7vfvdWscUNDZWB0wMn8lR1KgOLiJn4UXMp8hKJvRrMEu39O7in1sWchtIZ0Oelm3HNQ+d0bCTvWeGLMXKa/ITRuC0LICfyUM84dQQcXVUcARZOobCaNsR9y0RBXVRJ3Tr4lpYkpuMjvv5MqpFv6hULjdHE/3QiZPUy1h26tZHFoxYsZJcXs0EXe383xYHA28zt6n9ThgC3J/Gh8vhQuVs5xch2dkKurYBLxkfbJUCChF+N3q227Hh14VbQ3oApa7oP61JhJWujqAIM2dCVaT756jxkoisPVDZuX5n3g4AhnPM/AV15egkUx9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 16:32, Kiryl Shutsemau wrote:
> On Thu, Sep 17, 2026 at 08:10:10PM +0800, Lance Yang wrote:
>> vm_mixed_zeropage_allowed() validates zeropage insertion into
>> VM_MIXEDMAP VMAs. No in-tree user needs to insert the huge zero page
>> through vmf_insert_pfn_pmd().
>>
>> Return VM_FAULT_SIGBUS if vmf_insert_pfn_pmd() is asked to map it.
>>
>> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
>> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> 
> The patch looks fine, but don't we want to cover the same for non-huge
> zero page in vmf_insert_pfn_prot()?

Why would the zeropage be a problem in PFNMAP mapping?

-- 
Cheers,

David

