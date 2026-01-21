Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4371BC4450D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81C66B008A; Wed, 21 Jan 2026 07:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C326B008C; Wed, 21 Jan 2026 07:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942146B0092; Wed, 21 Jan 2026 07:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84F106B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:30:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 312BBD1857
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:30:40 +0000 (UTC)
X-FDA: 84355904640.19.E1478B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4AC3880005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:30:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3SHp4VC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768998638; a=rsa-sha256;
	cv=none;
	b=td3JRfXLKrlnvpliEn17fmDqiCr8QoKmfaHZ42g4MmPJvqeIiwasm6vZXY1J7vuMU8WYQ+
	hFhEZ0ITgr4cFZ60NH7JeY2/SiPO5QtN9IckxxSWnA+PxWCg0VYJQyG5dsSKSDUibjRxPo
	7i5xYPGO5o6vkomI8LcXuLWuMTqHDRg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3SHp4VC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768998638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyoZ4+dSjOfKp/e3D8RSt8wfTlOXvbPcnb3UhaT4/uQ=;
	b=l4s+BMfhPbbhecYIB4RfiiLUc4dZDf699+ZYC5rzaxfA4XmEo5xQ9nmYou/cenmZ6L06lZ
	SaT0aKBUkHqku1VPfZIueSjPUEAkCq0oI/6n7XSoJLWpVhD2YPUCt5uHrb22SwmyteyCci
	JGA4z7uG/OXAbOfQVDJDKwM6Qu4UpBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FF2B40A6E;
	Wed, 21 Jan 2026 12:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88A3C116D0;
	Wed, 21 Jan 2026 12:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998637;
	bh=/YHuph3wVHbdYXNEyim3H14Bppkw5WP2TEsCBJwpA9k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F3SHp4VCrmNZ1JKxHCQTJJ9bO6VjAZltSFRUGckGtAfwHVoG97YbhNuqqU/FRJTcX
	 EzcZ/ka7da+DScjOY1zVVMTfnU1SXY2TntQzLLjaSIkfyEjmDO+fL3a8NEK1K9QNVT
	 fDf93FpV3puZiXq5Way57ot8N4lFaovAwavuAP082DjfToib9oDPsi8AP/xxTu7Vkg
	 YijMp0b7storN9uYQts4si/dFuAFEFll3+yr2AiY0eWQqAngFTyWsfIdoZ0fRqZxqd
	 S1WY95z9E2Z6l7TMbmudRfRzPwXT0T3n/+8FXn3ooxaSzeRk5XzZ6Cp2YPhRYTVn8B
	 30wz7UYY4QPrg==
Message-ID: <cfc51f4a-ad96-49df-bcb2-1aa23b34449e@kernel.org>
Date: Wed, 21 Jan 2026 13:30:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] selftests/mm: add memory failure anonymous page
 test
To: Mark Brown <broonie@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260120123239.909882-1-linmiaohe@huawei.com>
 <20260120123239.909882-2-linmiaohe@huawei.com>
 <737310eb-05e5-4234-af67-9118b3f395ab@sirena.org.uk>
 <f1cb6029-9140-3784-5b44-ff58b4edde2c@huawei.com>
 <857ec09e-deac-4d70-af6c-5f89ba0b9798@sirena.org.uk>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <857ec09e-deac-4d70-af6c-5f89ba0b9798@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4AC3880005
X-Stat-Signature: ef5u8inhxb5a1mj35outda88w8njgn1s
X-Rspam-User: 
X-HE-Tag: 1768998638-189975
X-HE-Meta: U2FsdGVkX1/JiPu8JvpGK34iobE3cnUOMM7N+Mj+0ivGjxgGPen3QrnYfanxW2RAXOuOpmRB4MVea+e/UOw6S8Jw6AjYu8ingYzH0wzr2un6yM5Y3jghdBHokjCONzrkEi9z5ubo/QetrFTWXYlZ4Ig21g5u8ZOgH70i40hGYfhKScoji3LTBIXQKyc2jqWo2q+EAC/9TasgrhVIdOaWwLnUpBeoN7Wri8uWCfn/E29ffklx4ihkJgSY8M0WZIroLG+dx9KXa+WC5oD8hxSaGqAJh5efoFpnQZwLEwdtjFQRYOfVOg+qKWQf1YPjgLVm89dV2SyFGfZlbXj3SVm4PGdSETahXLUpV2JBO2L0Iwz6iePot0joIjIny52ZAfQEaxOtrM3ORV0c0//Xy/ughrAk2ZrezDKmJPHZVx3XZnYJT9Fi5QvG8hME5EakMJjWdQFQ3hBysPHDY1u4w/f085Q22sHPje+GA8a5jWJWwjglzNTBu7zgzpyht8us7Xi0jlsWUtIyLrMF/CRjUp3aQPtpPbxcxg0eXfsZUw5NTQs39fbnCTUdfY9w+hNxmM9LfzBQG0ZdRYWgeIbb9/bePlXZdBnZfiPJF9IJAIozAEa2L157ClE9Z2MSGEntuBP21CizE2nmEYQTiQfjmLT9PLoQcoUboLFR0nBwyz1W8cAREP56WUChAa4uEYgrdvjlGLQ2LVJE9XwWvmVJvxzyrJbreogLIauBIbHKCIL7LwMA0W1+bhl8DZM0KaDiiL1DQKPk0w+ryi2hZGNE6anD8MdzzUXTsiYQegU9thEqlqvKAdlL5fVKwlj5lGg1qgbAyXWvalcqGqT982SU9CIt2Yb9mikEyPWa7W8MNCD3PRP6CyEgh5WoqlOBhYHGJg70WPpaU7gJhLbACFgrEvkjR+HYWvxnYDEI0qFhmDpYidDYSaNNarSi6rMzRyKpI4NuZjx52J/w4IojL38gGpq
 gwIluani
 lpenzgx3ixIfR0NNBl7k4vTHZFqClu0jEb/OymeID8JL0KCgNjQVI2XsIzhODLEO4zefX8dhbDSyHg5uFG/UrSjEukBhSnkvMsKt5nbaVCa7ZQndywEs9/4OaIgEimv6BWP1HkajieDcdnxVgI9RA03hpF6gpR4/6uZTrMWJFm+h5P6glqGEh+LUYkajmzkiBvzbCJJJbYR1GFnv810NuXomxs7mGxF1VoDCDCWc6p3uK/7a+iHSdU7UbFEVog4u7uDyH9U+r4I9A+dEsV0XvzBCB/FBrEUWSvJu9d3HGIf81ZlcPIM6ATubi8U2aj1KW3wluta6XU3TUMkwBGUKdPXlO6gMGKxkrILG8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 12:17, Mark Brown wrote:
> On Wed, Jan 21, 2026 at 10:05:07AM +0800, Miaohe Lin wrote:
>> On 2026/1/21 1:46, Mark Brown wrote:
> 
>>> You should also add HWPOISION_INJECT and likely also MEMORY_FAILURE
>>> (which it depends on) to the config fragment in
> 
>>>     tools/testing/selftests/mm/config
> 
>> Currently if HWPOISION_INJECT or MEMORY_FAILURE isn't enabled, the test
>> will be skipped.
> 
> Yes, it handles them being missing correctly - it's just about letting
> people know what they need to enable so the tests get run.

Right, we should handle it to avoid misleading test failures until test 
environments (like 0day) adapted config changes.

-- 
Cheers

David

