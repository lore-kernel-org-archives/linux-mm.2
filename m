Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B217CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B6E8E0012; Thu,  6 Nov 2025 05:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C631F8E0002; Thu,  6 Nov 2025 05:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9FBD8E0012; Thu,  6 Nov 2025 05:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6D238E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:20:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 332E9140665
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:20:25 +0000 (UTC)
X-FDA: 84079787610.17.C097DA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9347240009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:20:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YNK2o/l8";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762424423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQNwyIZ0cRwSC5udufgelwCGq0n2Q5Y956Fq1SQA/ic=;
	b=11uE5CmTYOZI+B36hANktrcXGUfbi2GPge4MlrnQtc1NLSIDrBTtiESykPpt+XgrBRZ73z
	Zq0HTzCeuV3vOjeMzXXOnYXUIObysINJb1OglZYVk7m74EBOk0Qpy7+dCD5BurhcTCyViC
	Da6y0nALEhavDmsqNo60TxiF0wLpFTQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YNK2o/l8";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762424423; a=rsa-sha256;
	cv=none;
	b=AbZjJBSwG/AHBDIiM9NfxwRwaJyHK7hUB4tuy5+ByhVJPZf6TVHyp+PESjDoSLrKcvl4QA
	v2WBgawt79cmTvWBNdOs5hvZqTusIzW0VKbARjWYUdXEANdhmx1ZVPWxaOH9Ian7uzfgWo
	YwI5HiQo8q4t3+10a2Y0XyGhbIyFuOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D749760220;
	Thu,  6 Nov 2025 10:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E06C16AAE;
	Thu,  6 Nov 2025 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762424422;
	bh=Uzdv7X5iGSxhbYbbKV4x7uTVi8GSHnnYaDFqzy50Gtc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YNK2o/l8ETUrD1c2OGnHprJkg228pnjWczXRq6j70Uk4uvZZVSznUZe1qlDugwDF+
	 mD7NjGM05huSNRwxnmBIta8PddoKJJ25a/JWd0hHzlGfYTIAtyOOT5HPAtzaDsDhyg
	 RRf3NddjiE6LthZ9N972w7M7LRvaNpgLbLGSo2XVnhCzjZ66PRIZB8L/eAKOjEqv4H
	 e0jnRaZErWhP+2qXxGQcH1gAG9hYbnqk9r4JFCVbnD9Q8WD7WkfhCLmxi0P8qQK0y6
	 go8IaS1EILtePlaiiKtQykcy8v3JMZwj6CkPvnuiUMQni/sWY7bURFTOQpS9Utun8k
	 2BXHaxxkaOeGg==
Message-ID: <8e792092-11a4-4f50-be82-8a01512a5c1b@kernel.org>
Date: Thu, 6 Nov 2025 11:20:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251106034155.21398-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9347240009
X-Stat-Signature: a5o1nw4auxkwszkh4i59coqzgkr9t35u
X-Rspam-User: 
X-HE-Tag: 1762424423-442299
X-HE-Meta: U2FsdGVkX1+gn2EtE0HHzN0r0OlFcErzi+HCpLcmN8cQ3bWXcDI2GS3kbX51Bj2yVXv7zwC2QwucRuLQ5/0/MCZF0clqFwWcQWLuYE1s4DIr2uELzcGyuRzAS4zlJPaI1uK/S/likk/5+MaTYPiRdKouPOVPsjvMW+VQp6ZHOM2qrng0y+57WTKewrM3aMNitYq//yzqtgVkH/+bH1MGvOo/vANsM9+VdcPiLsRuKzXH6bZm0bvulsa6kAgfzOuPSFl0CqDqsZRNUYac0pCMhetnQoU0ZIshBesyfK8dYIkc6MDpWbryfGhzrs4oe/at6ouRXxra8Pkce4GMDc6YuRuQZv13TdtnzX6gPAVuoJV0+5arN9yBPR8mzCFfpWM4u+io1bFJ72Zffs9RO1ZC4qAU3qitVxH5sMLOix3uKyXHXS32wqKlmt55TkwJdJSpkUgCihAHMYiEDu45gHzhRzZlR6jrML3otrojbVDLqUQQMwUHBN2mGbrpjxovLJDOsNLq72c/Y4Gt6IJGjdJSafJdc8FrjywfmSpMpgAGFNlFsrZHll9UM54bb13Mptc6B93TWtuaJNG7fKcL25UKiXWHeOwmYh236mLEYiKVrl0uGxmJVt/NT3TnvODK8PypQyZ0CLGABMVvL+gWp6a27Pq7qhAi6MlrOkHSfUfyEF7w4AY7dNLdkU+6jsCDapwtPNY09ZwDQal2k0E4uGc4xUGIC5S6QMc/PbqYuCfMQU3Iaj8WBWVnRlxA00GzA7ZZqD1gdQwqRgVs+uAbOlmUH9vaAbKK90h8BBdy/XQTWCoftTdFzecA02fS1Smo5eJ7t75NXKBMHzzXzzMuWQYHl2VIMQ/Cl8eCQp2Z8szN7slzDdT6AS0qQuMJYJ7LqFIUS1dfZa63dLBnqhiK/s1YxHtCJrKxibPssRpJ3JBmomHOoXpKW6ZMsk3tfhMZeHlQXGiFCVW+0C43S6Rno4R
 c/Ggt+G1
 39OL09oozC34f4o/l+mNrkQRLkmBz16Zzl1swbBDbyU7k89lknL8xJ7Mi8l6Lowf4tsp+SVWt+uKnFl6bpPs6eUopNpCHPPvzhZa+u61PIOilB/f5T01Knp+CKIGggtQDhjHMr6HqYbApB2C0MPBRGNoGkJwm+QDJGPOofsQmM807IrQo3ezIAErjX1HtngzHYda8M0trl0TZeJPbEhI0zOkePySpZYqAcbLDZ4RAJDE17/snYOhRqiw+YewDsnU58hraISeOPcbkU+7YEAA6/qt55wO4PQsVd3R7x74wwIy3G/W7MEH68WqsRQShlafvpqe62yYYVpRPYR+1yt0NUYJl26JWM/6UP4GBrNCxIY+IWfCyL28C1VL4IFg0tHRa9OKem/JRJiT46CwMc6SVxv/aId2n8aTHslau9+LvY+ikC1maixYpPOzgZtzFv3KFP4Ba
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 04:41, Wei Yang wrote:
> The functions uniform_split_supported() and
> non_uniform_split_supported() share significantly similar logic.
> 
> The only functional difference is that uniform_split_supported()
> includes an additional check on the requested @new_order.
> 
> The reason for this check comes from the following two aspects:
> 
>    * some file system or swap cache just supports order-0 folio
>    * the behavioral difference between uniform/non-uniform split
> 
> The behavioral difference between uniform split and non-uniform:
> 
>    * uniform split splits folio directly to @new_order
>    * non-uniform split creates after-split folios with orders from
>      folio_order(folio) - 1 to new_order.
> 
> This means for non-uniform split or !new_order split we should check the
> file system and swap cache respectively.
> 
> This commit unifies the logic and merge the two functions into a single
> combined helper, removing redundant code and simplifying the split
> support checking mechanism.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> 

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

