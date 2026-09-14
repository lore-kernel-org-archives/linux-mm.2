Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57953C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107796B0088; Sun, 13 Sep 2026 22:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9966B008C; Sun, 13 Sep 2026 22:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11CA6B0092; Sun, 13 Sep 2026 22:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3ED86B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:07:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07D2E140DD3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:07:06 +0000 (UTC)
X-FDA: 85210730052.17.FAD9F84
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf28.hostedemail.com (Postfix) with ESMTP id A5682C0006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:07:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZRStdkI1;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789351624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgzKCoOLIarGhDXj37aERpIPf1VVGbogeSsR/DLyI5E=;
	b=Imtqep1hVv8fDWemNNt7fQXK5iRomDdC8gBTsqP9bqpQdYR2IjugdQWcYLF1Vy57S6fuMw
	tOxj85qcuI28Dj2tH9l5nwcViOM98gEeAEMkSYeMdl4O02NeU5xdSM+n1N0NRgvOVBG2Yu
	ZL4HYhKivgSgBg+ujJfI6SnqNYIkRzU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZRStdkI1;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789351624;
	b=3kc42+Ex5QGA0QtYCpc4v8UvsXWVhN37lrgiZyAJsJIsEltGmReuJBuInvPXH4IjFAUVKG
	a99qpdvg3w6iV5EVG+Dpv/1Z2Lm8KR540udyFy9mkEfoCxou6yKuKFcO6Bj7ApheUfdUQc
	N0dYov0tEl+EHhqya0z43rBgFqmbdnY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789351620; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BgzKCoOLIarGhDXj37aERpIPf1VVGbogeSsR/DLyI5E=;
	b=ZRStdkI1zSc6cojrgYZ2LnOJeXJgJ/mpgdIyxl/6+ar0ClqL5op0n0iOcvo5BfN5J1ZPAcrCA3QIZR6JYkocB33Z2yDm2YtVw8m0wfi/NPYi2Jr0g8rIXsll7S3NFwT3jhc3SjupkUNC9ZZWIBjc9pFLuo/3/Lo82EIaD/9h9O4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XApv68c_1789351617;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XApv68c_1789351617 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 10:06:58 +0800
Message-ID: <a3632566-ed3b-4af8-840a-7895d0e47f14@linux.alibaba.com>
Date: Mon, 14 Sep 2026 10:06:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: ignore sysfs configs for shmem forced collapse
To: Kiryl Shutsemau <kas@kernel.org>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org,
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, ljs@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
 <aqPmxRkJokRyVzdU@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aqPmxRkJokRyVzdU@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ypep7wwswfn1s9m8isw7k34m6c33p3fh
X-Rspamd-Queue-Id: A5682C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789351622-743432
X-HE-Meta: U2FsdGVkX18uw5cSMsfz8l+CsDTprCxeO46300J4APktlItp4vkB0SVDNdSr2eWOp0bUzI5ct0yeVC/SbxlpcGpVITl/lDDJLdh+zWzKNat37118PgKtPWBx+MUZF2KF35Wfn5xmaWZzkguXFcJA1ShwVypfHKFozXInxap8BNVGXMQ4Rdm1lmOxuHdvtiJgpq0GkOWCmho4AUTZg8OZsfSkWs8uSNbl1bFrPiTZyEraVBpQ34o6g8p2NfsLM8VJ67rseHejTXPabpQ+pXzelD08OWL3+RkOR/7aCPze1TgkQ7V/iBlVgj2ORF6bMDlE3iLtR0sP2//AO1h05ZJKdYrfxftDw6+zVRL6iBwyVNIq9kqopYHjrslh4Tvg1tvRMnhIAp/T5YH/P6srQ47bIlcIMsj9MfyxAnWmrlfS7XMXCukWuOlGUhmLbwlZajtr2mHCyxVxJvlLdMUSZ3+it6J7kONqR/PPlKDmM0Vdng3y7hSyzKTVHwYpas4ZDQu5ucIntRxXj4iEFo9O9FufRWOaESksEva3OVw3eGltHgfLvZaA9+w/KO9TdbmCvEcftrbGNtKbC+LR9q7d/uzm8adhS6Un1sTvQ/5b/T1cfKSRF3Ux9IQ8WYia0pd4GhqVGhFBYB741VcmZQ2f3LZGNsAs8ZVHHJX7bLWezO89IxB9dtU/Imc4A86TIUfosGmn/75Lptha+u8LEVE6BnaPHcjnO83oHpyWW/kwNInUkSezqYdVWw6DWrlpcoI6ssbZboxDjxs1SiUtmlx0936s8cGNlPIaNFJd8zAlNbl1CgHKM4sJtQHns/pUEgR2gZGB7UiAstPwZJHOZufdncy5hdnKIantbrYYP88DRYZlPVNx5mSuOlFQdYkkCBOI7/ynsGB8N+pRcvrAx3UKg4S+kn1XBxJKaiPzcozW/y8HmQRtqM6mFdTEeV4nGyUqpigYH1klAlh7bLDWSZff8C4
 dR3tlx6+
 KzfFPwEcN53yCvnf0Fk3BeG+UT+MD+McZwYiZDMufjxdVBGTbb0/voyMMZ7E2FJfHQdv09Wy/991KSRsornnLprMmr6pAQP8iiMPvMrOXDU64xEda3dSJ+YIeBVSkPW4bpenIv0MnUTCneE60mYwFNg45l+YIdNp+YNVe+oaPapzhNmr9KnPj/01MpGPdsVDR0QtvxkPlzMbySFLjytqjTn3Q7NgkcTz9CwFNqZAJLdsQtkl6f3ZyfCg61pYQhzxJQSOGeY7Nycu/GzggKwaj+OVbTtojktQT6yLtAOGibXNSDHr6d01ASVkofSzp9pRDGrT7Vgz6QcR+6Os=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/26 7:37 PM, Kiryl Shutsemau wrote:
> On Fri, Sep 11, 2026 at 12:04:33PM +0800, Baolin Wang wrote:
>> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
>> ignore any THP or mTHP interface settings.
>>
>> However, after commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
>> into shmem_allowable_huge_orders()"), performing MADV_COLLAPSE on shmem
>> will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
>> (although that is the default), which can cause MADV_COLLAPSE to fail
>> unexpectedly.
>>
>> Fix this by returning the result of shmem_huge_global_enabled() directly
>> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
>> shmem THP/mTHP settings.
>>
>> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
> 
> Hm. I don't think it is the right Fixes tag. "No functional changes" in
> its commit message seems to be true.
> 
> This might be a better fit:
> 
> Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")

Ah. You are right. Will update in v2.

>> Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Thanks!
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks.

