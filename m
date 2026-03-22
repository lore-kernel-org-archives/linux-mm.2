Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FE6D58CAA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1F36B0005; Sun, 22 Mar 2026 17:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53C76B0088; Sun, 22 Mar 2026 17:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69036B0089; Sun, 22 Mar 2026 17:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7C076B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:53:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53BE01E3AD
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:53:46 +0000 (UTC)
X-FDA: 84575051652.04.8FB5D7B
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 279FD40009
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:53:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=lURDETyr;
	spf=pass (imf07.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774216424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WF2Jc8jd49SvUSReADfs88mf3NQmxL0j42Z4CgklKLE=;
	b=HY4hXuMZ0ledYINtTzwYiwMaX6kLmE9iWMN7BTN5mvUSABF5f+Nnj4MwKU5U7ehAR6dYAh
	WZR10oCbKjW6SfsUkiz8QzjgBrNufQ4TawhyEJqYQVdXRw1KGoqxOSmGfCb7akHzl5M0Av
	vLqXZ7XPq5Lm0+09pr45y6+i2Db7PtM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774216424; a=rsa-sha256;
	cv=pass;
	b=126v/E8W+lKnxL5IMvD+CpeUC2hymzRfcA7Wfgyv+leGprcsJuks5gy164H5p2sCZi7R+A
	N0e339RxYuFLfIwywx+NJEYfinzO5BOhfk1wnrz4pCcUrASVWcbQELf+CIjR/gNte+FHeP
	t0TCpa8RbIg/WvUVyAYrANFW7xCCc8g=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=lURDETyr;
	spf=pass (imf07.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774216413; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=VidU/wf5Kvvx/sTsGhtWEGH3ltaSypCbWXvnDUaFc9c2Rlr3hC0nSHazcAlX/EVrLjULlihQxgGTHzr8xavN4dGBKGDpE7UPzA8VJ39SX/vfPo2+DfG97TkhkHKsmLJ2DvS1lbVQgZfCp3J1lOVmE0IKg7aLAaOvboV/By6GrMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774216413; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WF2Jc8jd49SvUSReADfs88mf3NQmxL0j42Z4CgklKLE=; 
	b=Q63SMqXzOTh0Rb1p4XJReNpIPZuBtshCuJMDq7pWJ8LR64zFlAPCVSXps7wYrWQfy7oWFwQ9r78LnYQKIyoextx9a9jT6139eqCcz+wCqh3j6WjVaYl40DZ4qyS6t5vOZLJAU+HWge+42Fq9oXFUbVtHiLCYUepiKYPgMQQrC5c=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774216413;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=WF2Jc8jd49SvUSReADfs88mf3NQmxL0j42Z4CgklKLE=;
	b=lURDETyrJVICtD8UJRuvXuKJ2KZXOS1pQk1AKY5vbZ7DAob+k+fxHbINdCs5+Me4
	SEab9bznZcPkM2vwJpSV+do/um7Dmcj0k8pZxuTs7NDH2hww7wqiKSoFLCUzlz3o1mw
	2jNHXkHYv/llp/iba8ohv3CbKpWPQvOgFN9M2oV0=
Received: by mx.zoho.eu with SMTPS id 1774216412426730.3504676121884;
	Sun, 22 Mar 2026 22:53:32 +0100 (CET)
Date: Sun, 22 Mar 2026 21:53:31 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_1/2=5D_mm/damon/core=3A_optimize_kdamond=5Fap?=
 =?US-ASCII?Q?ply=5Fschemes=28=29_by_inverting_scheme_and_region_loops?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260322214419.89419-1-sj@kernel.org>
References:  <20260322214419.89419-1-sj@kernel.org>
Message-ID: <19250970-62DB-4151-9170-BD2930C6D59D@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 279FD40009
X-Stat-Signature: paaoyzbkr1ae414h636zrrxojgdof63q
X-HE-Tag: 1774216423-546608
X-HE-Meta: U2FsdGVkX19PXZFd0TJNfJxTq7pRz2l3yh2+RZx8gELfHI3ARw2+p6M6FaNRPuAH03ZhXaS5VxzRr868+G1oRioFrw+6Rd1lfWtHPj3wiAQYqxkSFUgvLv9Ogo5VUuVw1JRZQRzE90KHZubFu/pYRusrkUwqgY2xBiLCkuqk6It/Gn9tIiRMV60YOZRg9a4ZL4FklbOQiDE0oOkeG4urThtvnvhZhKP2+wtk7pCZXFH382NzXrNm8Wii80tuIUISct/DLdD3anC0mQgnOlEH5bv7uCN+2UVkUhwvpyGODSaszpnuaIYgBOHfA79pPa8zELGXWvqMFTZP1vopTgbvnIMSOqUW5vd+hQ7ifv8kE8YlyJUbTHhqr220I9DkcNALiLnkfavwPCVcTmSQFRdEhDSIfCPfXFa/Z2O4D57omP8FlPLC2cyMkJTayReBlZUWEWmlOyTZnp/U7fjGDJ/qYwmDIFoGvahPmCzpTi877oN18jjLYc5HcGfyUHhck/e5XA1nK21OUhRut16YHwSWNJxljNRO3bvrtprc2KRcHlt64mcEddoLUNaimDyC3huhohYLOwIr3Gkdh+XK6Ki72ilJWcuFuNTorcazJy1Y1zuZwoxAaxqRicWtCdghop5h8PzzTd7uJin+Al3Jd9ohTv+XCF23K+v9JhuvTrcPH9dUi5LfCqkg60hAMbep7t/HpqYhqpgpyTiKQqhZ2hn1xdbDw/ayvT493Unsjh13N0m29VjSwns6Lfn/bvGQQuDMhfbYblj0/+6k/KJtwFTtHuc9jXfVk0QkZ2+nIw801VOeR4pIWa/MKD7oie4Ko9A7tkLSLr9OEW+rebywuXHw3JNJfvZZ9wNXqWcCb1K+a0cyHQO56CSnjhFp2U/Zp6WIXI6WeGlYIy5VGoHzH1KL1AMtZtQhjLDLnY2k42hcBKdCELWmK/ZrdJnRLW2aiouZWJEEoQOLwHENkR/bCYs
 zhSSeARN
 VL1oH2ZAiscnFwGLEyHMpaqDGF7NM0xHoCR/kFgxtVesRW7N75qIrMqbMw4D4lK71BFSoY9NjVn/l/Bxs/78s0zJq+/Bkyc79C2A5abHA4K8xBdjKIAjJRu3X9dOD3mfpIstREzyu0odhIFIGNibYl6QtstG/Ft3JDzNVsIGiq1D3G/zcPUjwxZeKgj/mhm2NEGERFr7SyyMf6zq14HciyWX/PxWS+O37aG8oQAKg7fcA85taLshkipRQa9OWVAV2moKUi5WQNyw4ioftJpmNTirA7hiixC0bKXP39+yXlxWYOboGoHTHcsbuTAHBOHf+P2Q6D2JokFDsmX8rnvqG5VLr84x/uktt28QHSzLh/Nt8vGhgoVpBTmYpsetuAAOnrRPiBEtn5XzwLog653thVsJ/464+UHoHvndh9Tg3wbnYIRrhgaScZj7ohXVqXOENUhkdmuaTRNtusRINsuamOOUSyPf4l3orcr/BQnmBBWZHZUkxIn3m1CXNZPTHwD53ng0QRWHuuYiY5kq+8VyoA1+8htFW0f/v0t0zP1/7UYgdOXgwtwGJNlrKZvSbcY/dBq3A/KhxKbFa1RDPJM6cR8cT9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22 March 2026 21:44:18 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>Hello Josh,
>
>On Sun, 22 Mar 2026 18:46:40 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>> Currently, kdamond_apply_schemes() iterates over all targets, then over=
 all
>> regions, and finally calls damon_do_apply_schemes() which iterates over
>> all schemes=2E This nested structure causes scheme-level invariants (su=
ch as
>> time intervals, activation status, and quota limits) to be evaluated in=
side
>> the innermost loop for every single region=2E
>>=20
>> If a scheme is inactive, has not reached its apply interval, or has alr=
eady
>> fulfilled its quota (quota->charged_sz >=3D quota->esz), the kernel sti=
ll
>> needlessly iterates through thousands of regions only to repeatedly
>> evaluate these same scheme-level conditions and continue=2E
>>=20
>> This patch inlines damon_do_apply_schemes() into kdamond_apply_schemes(=
)
>> and inverts the loop ordering=2E It now iterates over schemes on the ou=
tside,
>> and targets/regions on the inside=2E
>>=20
>> This allows the code to evaluate scheme-level limits once per scheme=2E
>> If a scheme's quota is met or it is inactive, we completely bypass the
>> O(Targets * Regions) inner loop for that scheme=2E This drastically red=
uces
>> unnecessary branching, cache thrashing, and CPU overhead in the kdamond
>> hot path=2E
>
>That makes sense in high level=2E  But, this will make a kind of behavior=
al
>difference that could be user-visible=2E  I am failing at finding a clear=
 use
>case that really depends on the old behavior=2E  But, still it feels like=
 not a
>small change to me=2E
>
>So, I'd like to be conservative to this change, unless there are good evi=
dences
>showing very clear and impactful real world benefits=2E  Can you share su=
ch
>evidences if you have?
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Hello,=20


 Performance Scaling Scenarios (Speedup of New vs Old)                    =
                                                  =20
 | Scenario Description      | Speedup |                                  =
                                                  =20
 |---------------------------|---------|                                  =
                                                  =20
 | Typical (5s, 1k regions)  |  1=2E9x |                                  =
                                                    =20
 | Large Scale (5s, 10k reg) |  6=2E9x |                                  =
                                                    =20
 | Multi-Scheme (20s, 1k reg) |  4=2E0x |                                 =
                                                    =20
 | Idle Schemes (10s, 1k reg) |  6=2E9x |                                 =
                                                    =20
 | No Quotas (All Active)    |  1=2E1x |


This here is a benchmark full of multiple real world scenarios (made in C)=
 and the speedup


About real world usage, this improves performance massively with most cons=
umer based systems=2E


V/R


Josh Law



