Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7513C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF726B00D3; Mon, 21 Sep 2026 05:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712046B00EE; Mon, 21 Sep 2026 05:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6016F6B00F5; Mon, 21 Sep 2026 05:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD7B6B00D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:27:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 513A64059D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:27:21 +0000 (UTC)
X-FDA: 85237241082.20.88150A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 884DA20002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:27:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaceTT7R;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQUCskKpKTBWKi4kkPNprWNPfV/anObyTDr0xY2sgRE=;
	b=xvPESaeSbVOH4wMrPRuyuSTR5aXkFjszfZhCSMTZdiZy216OrsTydqN9RXSuYd/Ep6msWi
	A7lWZxLqFzDRIilDh0igOn5tMIaEKWdwz1lfRWOgh7HNyfmcBFIgx7BMI23nSN2FOAePxB
	wAgRmokAXWN07MvqzuTH5qACXJiejpA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaceTT7R;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982839;
	b=2BjhAYrHtk4FLdBbutImhNpnmTXS1jRP4GK1hQvlEkTm5KjPUc8T0zsfhLqHRY4+9LycNc
	BghHUUzL20NCtgVrzv2DwtWuYnfc0nAG8sW8h+ehHUbQGiREjdI8K/Cu3O7WB2RhwblXzA
	lImk2rlUyvsxI0eUr5hdY+6vAxFen6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE454418A5;
	Mon, 21 Sep 2026 09:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D554F1F000FF;
	Mon, 21 Sep 2026 09:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982838;
	bh=AQUCskKpKTBWKi4kkPNprWNPfV/anObyTDr0xY2sgRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aaceTT7R/zCfIk4fbYgpMXkYmI9gOhWSMIWraMlPw5GPsrzfaEyo3Ss9KxkK/HJTo
	 nDsCfzHppkwwwd1MvTKPiNn1VJ7NDmlXu7VY1DfrfrXTOtVJgsniyx+aYcR0Q7lPd3
	 4nX6b+Bc3M1Zrd4AVhtPYHjN/X18d4Oim7mqH2zKOTV2jjAjc7WpRk9z4AKiBevqAQ
	 +28g9U+H0rbaV7HI5HnbsqBRaKq9WK5I2ndCMoBS8SqBk8dNvXJBIn7wvhE1FvKe1U
	 hXVswDIEPcxYnytq9GXmo4UEr1IhF3COC+erLSGuXlD9aG+PdWxvE0hSTJ09IjOEUm
	 RMc5mtcLK4gwg==
Message-ID: <6aaa02a7-29fd-4cff-aa4d-d8e63476ff92@kernel.org>
Date: Mon, 21 Sep 2026 11:27:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: disallow raw PFN mappings of huge/shared
 zeropage
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260921054225.28537-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921054225.28537-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: feuk7643zifxc9b8wg4wkaf86h5ykg4o
X-Rspamd-Queue-Id: 884DA20002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789982839-375959
X-HE-Meta: U2FsdGVkX1+KzsvxXo2F31QOfJrhWxf3zwG9q083SoxR3SdCbogunuukA61C/zsSQBMjAgL0fY648zBI4sBVRMJs3bLrGKmJOmAIuuB2fh5+xEYrIR95HOWzsI2MlaMARzgXoE/fQyPM9uujrq7I+NHWuy6D16tGqAZgMX5QyEeppXp9p8BrKfzUR8DmfAqtBgioQkMQcn3H9mz+rR5ptaG73mBUuQ/4L+627uq/QcqergGGIXTiCsjNzhCUlnjGcm3stvYHdw6ZYlio4Ezt4zjkYvdN9s79nYr9csBB61NXv/wbN5Jn5nPZ/Z6l7XFS2PL4EMTYCLknAiNPByhzNR/IQ/W6DjTVcAIiM5d9ynt42vmqAsmLx3+82ZnaioNqPGbohYzCvmrlWM2Hfz4/HQ6AyQsi3J9cm5gigpT6nb5DP+KNCmO8ZWMVOIyPmwY2N501biG4fo2yl9yRuu+TkUKcdA7uuEqGEmwRzkz5s9QrB0z1/JHjbo9HIF5ROTYb+I3sWxReAEA649wmp+e033tRkfnmbBrr68CAvA2eQvGtbG/xb2XeEVpoScoD8YbSiNXzMJiuuKv8c+sXXe3UWa2hzkbfQCfl9n6QGymSwZcX71sDZh5saFNengKNYwAArpl6EwIbHzbqf+vUNqIcZTP0H24sOEjpfGnkZeYvjkWytj9lmFrBNNInd9kW/VRAjB2D90B9S2BwRhIuF55wK5f/WQDl1PzPDy8ZJma07xV7asmCLOAU1rNfhq9Ktz7X6paNIatYZMYfuRjRQKVpwfQTJQ7RYqYV6wCC2DrRUHDGD2goAa0t9mZlDftAOcmGti2mu1I/Mbb2MbRkD3577gKQvrDBeE6RvR0fixd4NxODaOPJAIKaxLELBul2qvvF2NsaeVfi5W4f0wy0xx78ZBtt1+BiXCqafdzEDdzfCXQdV8546xZphONOfqjfRN+iTqC5OE69oiBUz7goxvX
 Uv8Q6WpE
 3slcbH+J+/Q0Jh8vrRmQGs3Y3muvIedsQw5VK//7UosmbhjohmEfuE0DNFfz/aMksSl+tKd+Mv4P+y+HPhPKiN7c271tFoHmJOxpzBe5dY8lQ5ZFj7kSPb8HcOkkguB+gN/s2zvliBXAY6VChocqYEK8jiGh9N7LhvAKeEnWOgPtMDPVCevLWsmIVKv66gMa35fqOLx1CELxue6UIO7N5iGTEMEJkOAKS7tpmEMwAxtp3gi/sEwo7buIYQN1JhB/c2NkuECmhqTgZsKjGh3sEZhWcSQ7bVgqx8TVM4hqJ6fBCE44K3aqij37Gr2UMmyMwXBSC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 07:42, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Handling the huge/shared zeropage correctly in vmf_insert_pfn_pmd() and
> vmf_insert_pfn_prot() is more involved. We would need to check whether the
> VMA allows it and keep the mapping read-only, similar to the checks in
> vm_mixed_ok().
> 
> No in-tree user needs that support, so reject these mappings with
> VM_FAULT_SIGBUS rather than complicate the code for now.
> 
> Link: https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

