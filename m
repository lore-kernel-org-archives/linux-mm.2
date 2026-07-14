Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4525C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35EA6B0093; Tue, 14 Jul 2026 06:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CD76B0098; Tue, 14 Jul 2026 06:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD716B0099; Tue, 14 Jul 2026 06:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5D16B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:01:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3946A034F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:01:16 +0000 (UTC)
X-FDA: 84986939352.25.FD95971
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 90B7D100019
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:01:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WbTn73Ca;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784023275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSUnFP23E7MR4lFPLdnwHJ9sWUfwgVFYkHzPKHpXt/4=;
	b=dVoPGHEJjkAe6y7jks75txYaXhLTQHdbGHbatTV8yhz/pVwab6WC6jRrblvM7UzGI1EHYL
	Js6fGLDre1Xf4ldJQQTaeAN+Pv3dkogN0yFGPFU5ESwPWXZ4yn+0zLq90UNyerDuIuhpQt
	r8EzCnY0K8mW9E/nWU4eYvB+CsNA+xU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WbTn73Ca;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784023275;
	b=Hxo3x2wLtKqucNOfOxKkWWVXbtcc/3MFlB+p5yLWsvUwRttt7oG73FFNqEV2kkLcqFRAMT
	RELoZxx0/bTiaKC+wMXOUsfqVxXjIAUHBbTyTRRw3eGRBpiBMjhuyWPywqGOJNaWr59daA
	jp3p9DDgno/K66iTSn7qWBwzXJOOWgs=
Message-ID: <aa5f1c45-169f-4eb8-9b50-1be4fd0d804e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784023267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSUnFP23E7MR4lFPLdnwHJ9sWUfwgVFYkHzPKHpXt/4=;
	b=WbTn73CaweoTDIlGnKps0gEHOLQxXacKRHGEFej6SBrTauU5zvpNnGlY3MKVEL8/krECxL
	9x5oiBWoDl8b/FXsa0ic1eRT1XgSgSXh72DWoDHo3zd6t1WCZO6AUlmBTPdM0UE45FjnYK
	V5ion/OdhO/A/eMwVT8E+NOOwfnftk8=
Date: Tue, 14 Jul 2026 11:00:42 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 04/11] mm: zswap: add range lookup for large-folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, Alexandre Ghiti <alexghiti@fb.com>
References: <20260713133613.2707815-1-usama.arif@linux.dev>
 <20260713133613.2707815-5-usama.arif@linux.dev>
 <CAO9r8zNVnwAS-6jOQtGrcN_fq8C+6kRiiRX4=kp9h=fTC+XYNQ@mail.gmail.com>
 <da9458cd-f039-4c7b-9e00-a473b05aa3b2@linux.dev>
 <CAO9r8zPhwmJA8MyJPiBJponaMETbgMNd=Pz=_bj_PBo1D-Bw0w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zPhwmJA8MyJPiBJponaMETbgMNd=Pz=_bj_PBo1D-Bw0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90B7D100019
X-Stat-Signature: 95fxq9r41qz6867wj39r6hrdpjbaemmk
X-HE-Tag: 1784023273-66289
X-HE-Meta: U2FsdGVkX1+Ow+L5olUGNnS/vvht7dbp09LgOFCrfEyflKYwsewqBsik8giCZbAM43iXyIC29gbRtYd6T7ujQPqkWHuVYoK5EC/tFVuDEJIL1s917MjCw6nLV3p7YlYb1rOu4UT6WlBzm+ifriZA7ASazWLA5lPD6XD62tEhh2PVWFrdXAjCl32xM3bec9JEhedo4Aw2Cb8hjPBECxMdrSXkYd7ar6gKVxypbiOh3d6bTVQW6vC5L1E/IbKcFu3oXeG03K03BDfopEBn483TbfyPeY12kTsNwoI8dmlZWZ+RjNwSA+a4Kw4n96aHj1c/wJQ4t3Ssn8CR45UpGb7r8m2FQdkmbS/OrjdfKOqINV5ryKgUI22ymVfNroVFTmerzaNF6+PBRTK4nKmXU6pr27+nxsEXKLw67F9rFJIx7g6kexGprrP5tJfdbgL3jFTE0N0yRnohUWi4hd15v4kGKQ4FOfa4zuu37quWYW1i0Hibz8JmvlpNeU51E3aEhrJ+KYYM3wGWCBzPZRL235vInc4IFeo3kY1J0Nmi7KFhxwFBSWLwL8oLNj5j8I4Wi+78zfGB3Tx+TzPPreHnTI5ozrCKdJmpeWWuAcLlIM+dvIYVzyXKxH4CnAsHSVnKV6Kue28SxT75vOSlZwFqJZGzcjUDmEBAv9kECcGyVVTkJBPY8+GGrM9lAZcjSZNuMxDWJWYrvYRqC8mJl8RdGaLtw6YCRQWY0zFcH53tXe/7o+OIOMwzbrjom8glq95xsAtzpqnXRxqVT8H38KQhx1Od9EVoxwfOJx6n8arSKZ0vYC8qi0ihkTtUrEQemDmKy2m61aMDrvwn3HjD/BzvINQYK5LBSbBTOjxWQ6gHqOx77bSZgwAmh3lhwtUXqENVQAuyXRwoUj7J88a+KPigmsmCi1LIKke7v0h8rCpBBVVjOZw12B7n3yy61hXC3nD5MERwZw0FqUNiH3cmC1fluIn
 P7OK9SAP
 SBw+jb1iyJvhAoPvlUjqFTSUU/SZUiTqW6hXCFx5Pb437GE8uN6tzL0I0vtQVDEyVPmO4AZ77BXjlUz9zJ4LY28qCOZP8aVUBN3KpJh/e/8Ie4m5U3QWiSwAlwSxmuCEOx4SobY2xTuZVmRWmiDPWLRrNwP8x8d5FZrVuDCaAkMla3oYkEMzfQ55gvyCo1U7CJ2P8DLJ2EcxA3Su/v7A9ZL6vNxRcN5xEPEo3Pn+rUgsYroo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/2026 17:55, Yosry Ahmed wrote:
> On Mon, Jul 13, 2026 at 9:29 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>>
>>
>> On 13/07/2026 17:02, Yosry Ahmed wrote:
>>>>  /**
>>>>   * zswap_load() - load a folio from zswap
>>>>   * @folio: folio to load
>>>> @@ -1571,10 +1588,9 @@ bool zswap_store(struct folio *folio)
>>>>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>>>>   *  will SIGBUS).
>>>>   *
>>>> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>>>> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
>>>> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>>>> - *  do_swap_page() will SIGBUS).
>>>> + *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
>>>> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
>>>> + *  error is emitted (e.g. do_swap_page() will SIGBUS).
>>>
>>> Just curious, why the change from -EINVAL to -EIO here? Does it matter
>>> in practice or is it just a matter of personal taste? :)
>>
>> The caller only checks for != -ENOENT so no functional difference here. I viewed
>> it as a change in semantic, -EINVAL meant that you passed a large folio, which
>> wasn't supported to -EIO meaning the request is valid but zswap cannot safely
>> complete a PMD-sized read from per-page compressed state.
>>
>> I dont want to speak for Alexandre, will let him comment on this properly :)
>> But above is what I thought of when I got the patch from Alex.
> 
> A mention of the reasoning in the changelog would be nice, even if
> it's only semantic.

Ack, Will add in next revision. Alexandre, let me know if there is something
specific you prefer to add in the commit message, otherwise will add something
similar to above.

