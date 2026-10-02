Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B82CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9EE6B0099; Fri,  2 Oct 2026 15:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AD56B009F; Fri,  2 Oct 2026 15:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84DA6B00A0; Fri,  2 Oct 2026 15:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8FC56B0099
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:24:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5824A1C3B4A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:24:30 +0000 (UTC)
X-FDA: 85278662700.05.0EF4802
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A12BD8000F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:24:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chO1Qb5t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790969068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rzfgjzP5hpWkIDbVjSr96pef66B/RZc/I1AlCje57g=;
	b=b9IFKl5da9wiq9cj6eYbtE15HUS8ZwD6+WC5unxTAV5AEmgTjhx/wTvB2PwBLMxaJa6m6Y
	fdRA1zfsDbDo6mYSryBz9n71+cnALkgoXPkCPZ4klKnHS4oSh7MkASyKEts3WHTRK7DYbr
	FGt73TuLzOasx6vUWEEifbK4LPOdX3I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chO1Qb5t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790969068;
	b=7igpw1vr+B+nwgB4Lp2/o68QB8WWmmU9D+MQoj4H1d8wz5suQKGobhei8GkEEaqTVB3Qtj
	zXK7cMcUWXDsZ/wUmZ3bbk4rXpC8rx8Az7IhcW+OkNEqt9zrkb+zOPaW1rM63K70cvBvvI
	MnCpTmB4XahWAzIYXEcwag1m0Jk0VWw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17C5960AAF;
	Fri,  2 Oct 2026 19:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C3D1F000FF;
	Fri,  2 Oct 2026 19:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969067;
	bh=1rzfgjzP5hpWkIDbVjSr96pef66B/RZc/I1AlCje57g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=chO1Qb5t7ZzJSgbtGI4XzIshPjgG+GDMD8/31mCdnKdBDh7IfBgRZl6RoKm9acU+r
	 uG9FaaPtSfnw587NCy+R4i6H6jHfljlL2nSucULJbn48Qwt96reOegxeFCyxRv8F3H
	 vBV98RXnsWVYNEus0QuqJ5I8PoLZWt+fdM8ri3H0YBoUYChjK6ajBPFIx94OlD8FRi
	 W9ONN7fN7FbEId9jwnw+18fftkrGnJroF/UyMQXV79Ba4TrdIeKb6XEV/DGCIYD69Z
	 Jpo7LOA/m9z1YBkLaOkqWrpmK+4KzOLgbmlFGv3aJ/kqDRwnyL8YgsonJeJLImuc+m
	 gcbAbyUnw1JHg==
Message-ID: <cbb3ad03-a52c-4719-9be0-6cc7414ad870@kernel.org>
Date: Fri, 2 Oct 2026 21:24:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/14] s390: move has_transparent_hugepage() out of THP
 guard
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <a2c5f62c812afa5b84ef16476efc99281930c124.1789695931.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a2c5f62c812afa5b84ef16476efc99281930c124.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zhqm5o4n8rhi8drhenkpt4wio3mia8gj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A12BD8000F
X-HE-Tag: 1790969068-722148
X-HE-Meta: U2FsdGVkX18FhtUuNOk/+viWOYgjmnhg/T9Rfz0phv4APZwsE+yYI/to0BvPAMoYoSd4QzGUwBrGT8DSSYfpyLNA98hvmURSZtUnVkGK6obwQ2e0FLTywLezUzMERptFQrgRUUl/FIYsBxOsU7ClNf16J+dgrIwDK8h2Z6QwrywuO4soWE+EzpVN4ZytpJiFT83XUrvjT1noSg9RLHUIaqR34MyEyxCiXCcT4D66x4VSHTK5OJfV2om/YjbmIsv+UnyTa3Ukh60775VxUu7C3Zq6Ze5zqk8U2irTNRdpCOm8qEDe5og1lS2GmbQ3xVbRAGhL2nTiY5+axEMq1Jw+XZEratgFlKCJXdkQPJvpQuPARGbz3T6Gv2abgiJHnRoAWOVPZIh3pG3Y2Ba6xcDJviKMKKWkl/6QKTTSY7crpxng4F9MjDDitzXK/hi5u1+LwRWwP5DJMDIPhE4DddK1OYBsbTtzb5/ocgvpDesVglfG1kzM5WjuA2Y30IbWyiEddko9fxy1uiRUVqHGvv0W0bs1BECZf86S/CnalolZp84/N458eufJ6TXEZV6EvAFvAG8jfmh2S1jsOsinu9KxszySyS5quHgl5eohb4dctdvIeO43lPqeAqJbr0rt3v52FJeQSG8xQlGSa0d9ruw31n6oNk1IIW3BoluwH5pG9uY+AbrrLxapAiHn4NwWsXvfr8/S18FCglxSqXsZZL5EjQcEGqu2mkBE7lCh2s8+ltEgkCVI8Qiq8SdrSgJY2cZsqfkhVSNmzhxkObZa0AzpJO3hQ3MQNJQ2CKdzd7ru1/a3LPX2hHn7gkpRfFalnNR/VMnikdscu9Y3/Y8TBjxLigSPyA7RHgZtycDgZWhjTTx0XX7SRM3+myveVk3E8o8vkR4bxHqFLvAeV9oqXA7EVeDVbuOv+Vk8SgMSdNSwHnEqNfkHwx4s0pGOStFriZ5Sl1wuk1Hn0FeiZdR6IiG
 cmKyaH37
 T5Z6MhPI+W7W+vR1sVajdBEQRRLYJdKC6BdwLLCJDq88aCXVNKriQIpr0pN4Ba/eftKCdOyU2e8tPyr3CqJ/lyxoPXMXIOAtuGCc9aLNcRvgRy+mwp0ZqwGrNCjOnWoJWMc5QLwo8O+5Um01Y/rlrUtaDHjo0MAcHk5OUJW8pUyhUTvjE7BOBf5ZpSn3ki/1ODLhwaWVUXkqfh/KHsageUmpxMCtkrh74XUTQpWE1xOSkS/A+Ieo3SYeagwvWwXzBSFkje//EXtZMh+ILQ4akPboZxjjVvmQKUeN4dg1tQSY+Llw1efSqWkZ2sPF/OH7pwPW4PMPL8B6nSySlf4F9EBu+bEpDiorgdMlAjogCBaT5ItqNoSeX8rw40DEc9aEyacgw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> A future commit will introduce a kernel API to allow for checking if the
> CPU supports PMD-sized pages. This API will be based on the
> has_transparent_hugepage() implementation but will be orthogonal to THP
> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
> 
> Move its definition out of the THP guard.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

