Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9722ECCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DBC8E000B; Thu,  6 Nov 2025 05:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55258E0002; Thu,  6 Nov 2025 05:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9923B8E000B; Thu,  6 Nov 2025 05:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 857E68E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:12:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44BA313B4D5
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:12:18 +0000 (UTC)
X-FDA: 84079767156.10.ADD982F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73C5A160002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:12:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pGcd8YVQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762423935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqRxpoiqM5R7FJ0Bje9XStDpO2nwBfYYDIkZku5MxP0=;
	b=rF+C6BRMNyQcYgAwiqfhoB4aa8q9JbowTvs7Wny92YEtuCYSJaIcywVYQMdQyyA+3VEk5B
	ssDIHog9bwT5vH+Of5qD/5mx+ZGLf9XXrnl0Lf5xOAxAf4l3S0u6kva9beywNPsdb5Wj6G
	OVZzbbAcf/ZlQ+742FG4fnev2NsjxIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762423935; a=rsa-sha256;
	cv=none;
	b=ty33+sxBola7z/HExjC4pLOX9dvIof6RLLP0tvxARaFm5uhpV/0DUmFsxjPQcAUt4jqSP3
	b+w15wZpUDQjjXvEOU7MIKV/BiApwBWe3DA/MFXL7T9IzCb/Xvu6kSD6KoST2GAG8rELJf
	YqM9ef1j7lvb2hAHiA1D6ONyWJ0bV0Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pGcd8YVQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E783401D8;
	Thu,  6 Nov 2025 10:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C25C4CEF7;
	Thu,  6 Nov 2025 10:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762423934;
	bh=vLdgMhMbqdRsS7pRY1HQBSMCzu007EocSaaqrY8zFyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pGcd8YVQCbPtN3a/2MKKJWJUm/3VAYrlUL9uGyjCFTmURjyQy08/z0FF7aU06fuWo
	 wIV6zjOh8o+RScH3Kt9b9ue2vDCjSvaY0/X5XHaX6mWg4dW+eacu2Nh4+bW3z48kgV
	 lOMycMl3uK9Zv5EoNKz1Xc8OovT3z0p/gl3bD0PvbBW9QD2SB5S3QVZwBr9YDG70K5
	 d1mdjfr/if7r7TPd1Y5wD+bJGFe/36tsTRn/E9zJAz/9z8d5235okzQJxHJssKImnA
	 2AdZJdO7vI4w36a88wly0Ryw/sdZ0eG/ymzjK7PwfLFyG4jznb73PJso7qsGIKERC2
	 IPBBH7hh2O63g==
Message-ID: <79509ed8-d6e2-486f-9e41-0290320c496f@kernel.org>
Date: Thu, 6 Nov 2025 11:12:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: kill mm_wr_locked from unmap_vmas() and
 unmap_single_vma()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam.Howlett@oracle.com,
 linux-mm@kvack.org
References: <20251104085709.2688433-1-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251104085709.2688433-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9aiymxtgn4t7z7s88om8u5k4dqaib3i3
X-Rspam-User: 
X-Rspamd-Queue-Id: 73C5A160002
X-Rspamd-Server: rspam10
X-HE-Tag: 1762423935-3774
X-HE-Meta: U2FsdGVkX1+zJEFEq2ctNPl2JbsnkHCM8n8VZlBmGICXe4zPFN841f4UvecM6EEoLAN93wL1otK+B8KAQwZ6idHMiSkt9wtr6ngUsiOAJ24GFhl9VTRN4aCT4wnuNw+C6FKVcmkJkSYVq1d1Rvjiy6Kms4kpy+vZxTyC8U7I9h+JkxGBjkJkAUirDoGIJodpJ9HvaUmrBEFzF6RYPenEgjarLW+jXP7cz9uXT45dG+kI3SrEXWhbijvi8RuPLn+/W2a/LSosc2opJvqcHmxgWGuh/aSXbB10AbIqg2bLEPtWfnExHjQzYv/GH93wpsYdAJBNwbVZSdMV0DpB01wsSyVacgMS2eH9yYIWx4BZm2udm8/VAe0Xv8tAE7Kx7xHaiiM+EcZ7EpVboGuKPi2/vfGGYeB5WhlCB8o654yhJik1EAiYL3cy7ntcYqASRemzBJ/9ONp/WSm6zgCYN4Zh97TYqh6q+fa8iJGexTxdEopEqwHHCQHwfyr1ynvE0c7djDDYQ0RXhLuzq8h3VedG2xyUMO6veCFFN0lKz/UW57HLUXNeIo7Iwbj3uvevl+ewPzDBEZ8dgVn4ai5Besv6L4WIzYvpJbmJht84sC2DsUCeqd96n3CcLq4XyxA6qKhZBw5uABaXzvxR7K8kFrfkPMH4ehgBfiOFcDA88M0TpcSrSbHdo/8ywyc8VM7uOYb4r5CU5p0r+1x5J0e3j04f9xpiLwak3Wu9CJRj+VrsB2mDSab0QZDexa38J9QEOoV7CsFT5fSvK1R3MroW8BOXWe17nkWDa5qCzxKTfke2O7sGvop2P6iIejSG0ZLMJszbjgxgsY15V7a8J84JtuZPIAgG7O7WihIY49qx1sgaPHOsU5CieoCkz4eWbQziwGoXF0F1m7rGK/B/4Qg4bPC404EgFuwQAslzyvlWXnegfew4GGLhGYJth7P8DEWasorvYg0uBSjmzH6pEunPnXo
 13Cg27/M
 bYWKESAN1BhHtLYLRS2abbbN0SjdHTJQZWGkvVsXTZKzJ08WkzHKwt+ocms0xr8aQJytHleUEylEudWQD4cfBMfbsPSpJEVc43DhIcp8bzS2bUfq2mIEXOAmmJ10W8rBCKrykEqDEK/hGl+wcGaGhqII6pqHhdZFLVujvMqmvIRDTwxo61tQcI9Tsih4zwacL9AHxzKTyOKy3seyDj8RvMKPsXtXBhBTJXYcY1ge+AE91V+LUlteDfqNoW8nNOXdfxh0tVipfrQwrY33OtmYeE7ZRhMJec40ueDfebnbMySLNzR9EQA2MRIJrgAJqbMgpYWdraIudVerey5rQoh/w53RrgCcsNIBf2Ec7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 09:57, Kefeng Wang wrote:
> Kill mm_wr_locked since commit f8e97613fed2 ("mm: convert VM_PFNMAP
> tracking to pfnmap_track() + pfnmap_untrack()") remove the user.
>

Oh, nice!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David


