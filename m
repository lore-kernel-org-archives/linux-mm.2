Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 719ADCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B2F6B042F; Mon,  1 Jun 2026 11:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04046B0431; Mon,  1 Jun 2026 11:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B405D6B0432; Mon,  1 Jun 2026 11:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A77286B042F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:44:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5977A1C0C66
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:44:20 +0000 (UTC)
X-FDA: 84831765480.18.A664E45
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5BE6B140011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:44:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SW2HVAvw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgxgY8d+G/6RTOQ+BJPpqzlDf4UdD5DQTydgCd5fyJg=;
	b=VFM6+FwLKVRw3lWhkx57r/ZgGk9pnWDj4U/89VZkPjEcFHAna3vRoMdGkhCISm8ITkVX4W
	mahs4OtDrdCr/Bh//QgvgI35dZR4yf/oXQn/wXmLGx9DVFrFW8Gs7i5VxRL06VIJdzTGs1
	HTiN0rNgJ6lqeJn5lb7bx1FQb8rllWU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SW2HVAvw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328658;
	b=qz8u5G3FiVlO4hkTWW0/pu83h/JGETk9H9MpyLX3wg5lr8YBA3NQhM0eAKiC/gjIbjDss7
	0bpYVSajFn5OtipgqWC6aT8/Vz3VVyy882MZb1z89PNBGWRpNYhU+8xHpM7OBZJWlLvk75
	5PqlEyq51nK2pUToHklf4EvrOBHMlx4=
Message-ID: <bbecce76-c677-4045-b0d1-ba822b84dcf5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780328656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mgxgY8d+G/6RTOQ+BJPpqzlDf4UdD5DQTydgCd5fyJg=;
	b=SW2HVAvw2yZu4I9MOOCod0UfssJYy4pt1A9hpEgVLqAe2/h1H9PZfGvrqmQ/pQbWApbAVx
	B2oofFQxFPT+jwLRowiWeqH/MqwmXVsj9A2gLQChaPYxKS5mCUEsoS/sy7zrgP4Ss71B8M
	J/USgdBKjwLAy16nGeLo9BqWWNTSL38=
Date: Mon, 1 Jun 2026 23:43:56 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>, Xueyuan chen <xueyuan.chen21@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, ryan.roberts@arm.com, dev.jain@arm.com,
 yang@os.amperecomputing.com, jannh@google.com, linux-mm@kvack.org
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
 <20260527035607.14919-2-xueyuan.chen21@gmail.com>
 <4e0696ee-895c-486d-aacc-71146f0e9047@intel.com>
 <929875a2-9e94-4dbc-9c98-b342ccc3f4e2@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <929875a2-9e94-4dbc-9c98-b342ccc3f4e2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5BE6B140011
X-Rspam-User: 
X-Stat-Signature: wtbucrwstnhnd6661e4mqgr87rwmmabd
X-Rspamd-Server: rspam09
X-HE-Tag: 1780328658-265008
X-HE-Meta: U2FsdGVkX1+u9MU344qNeCPcSiqblpng1tjC5r4OOeuzjSA3bWedZ8umopPkz19uYT/FLxF7Ce/eAgg56hDlgEoSfbbsqiLCiTdborwQfTCbx7tJVstmCRqUin6VfrQES80p3CKPfr12AALR5IEixCQoZIJDpceQALblq3FPDiMv6CTgKaS2cYtg4vPhDJ9mXUyuqBVqnTaS77cMoU1mzbwwCKoL46kUPGBdKFxE32RTYtpEtlEdTM0jB9ifARvAyRuQX4GDNsISO945qRQQ2ZWPrnZ++FGqCpdl/FlyWPQ7T0/9dIBkGZWhu5fdR7q21tJx64jzu9JF97vQy0LHVhO9r/E/qTVVsO52KH/xeq0fiPU01AHrm2aNCWIt8A0//Msrc/C/SlLMetfW3nruoBOz669s5BBHXPQZVmnOCN1nVxr+BgA0rh2H8tp+bQssrsDMKavUy3vs/IhD9G5mvHN4IYxkufJIQfzf3PE9qfTkyDs2M+2Ihk7LHAKktKxWdsBKRs0xEvYV0LM1Fcpic/AqlbzEnLYAeCnHx9q2xE2bhs1yJPm9C3D6ddX35bDd8AtY3+KTCf0slDJFdtSyJP/ofIzYDH2lSm3hmT73aBsoK0rdhiVwQtEFNHTWR/LXmioRqU+FLXhmct7g4FK5EKaRtto+jkD0KmhqK7fjhwUkhSVSVY06dQeQP2PNYkriSTd+PM6BH5Vhe1N4sTzi395+NH16kZEP0KxJ903GBCSQ/j7kVCUWDCT5K3x2thV5yf4Fa29h9AuYwZNVe0PAeFvjmBxzDk3ZRcFwoEr6zFkLbXBAx65cdOuu+agtV7P88KufS0pRH/ngVdsU0hPASH+pnGuoHUshyo39T38l4ytTgbO3onmwVDF663njCtWGEZSBuNlZalEUIVF75VIZ00qrcxoWcjR/s05LNHkLqrQHIQ625lr0tiYpTN4SM9aj6CnC+g01GH227p3l6qO
 kRZ4wWEk
 wNGBGtOvm9fC6pyn5ZmpdDJCdqAX2oKnbZ2PWmj9KQ06ThLAteLSodpnU7JuOc4urQbz63aSJmum3XY8UcIGzYRO5NqEjK0yKnqDumuHr0vq4XyFPwNgeQaARx64vfbUH5hZMMLMZgaXuZxNn/n4A1D6UGnEyLJx6/6VRW31WZ0igSaELc8VELr7X4cBxSQ0fTE4vZR4wRg+vaGKLfB75D1y/x/FP+aDPm8DLiTKGZjjs90XeC9CeSgxUrPfEQVYEU3EE+Ut/TRwFsu4+cvWlDYU9BH217HPcfIWV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 21:49, David Hildenbrand (Arm) wrote:
> On 5/27/26 17:55, Dave Hansen wrote:
>> On 5/26/26 20:56, Xueyuan chen wrote:> +#ifdef
>> CONFIG_READONLY_HUGE_ZERO_FOLIO
>>> +bool __init arch_make_huge_zero_folio_readonly(struct folio *folio);
>>> +#endif
>>
>> All of the #ifdeffery needs to die, IMNHO.
>>
>> This function is also a bad idea. There is nothing "huge zero" specific
>> about it. It takes any old folio and tries to make it read only.
>>
>> Just make it:
>>
>> 	bool __init arch_make_folio_readonly(struct folio *folio)
>>
> 
> I'm not sure whether we want a folio-based interface, though.
> 
> This will likely be the only folio (that will actually have a "struct folio" in
> the future) compound page we'll ever mark read-only ... whereby I'd guess we'd
> want other non-folio pages to be read-only in the future (encryption keys etc,
> maybe?).
> 
> So I'd instead use a page-range based interface or sth like that.

Just to check, did you mean something like:

bool arch_make_pages_readonly(struct page *page, int nr_pages);

?

So it can work on pages as well, not only folios :)

