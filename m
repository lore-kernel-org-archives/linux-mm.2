Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26ACAD1953D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E1A6B0088; Tue, 27 Jan 2026 10:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811366B00AB; Tue, 27 Jan 2026 10:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709C86B00AC; Tue, 27 Jan 2026 10:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5376B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D7071A027C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:08:08 +0000 (UTC)
X-FDA: 84378074256.26.10A0D43
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 308DB100003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:08:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Cou97s3W;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bI7n7EMbVTLXkomvFX5EEgGQqwrIiq4zfj25LpKIMGc=;
	b=29av0z7/9Kx4sMIDHkQ0QFVPq4YFz2RROJT3qpcEA/xjD9gsULvh94cpNqX/0ePILdMItJ
	Qml3TXoEPKIkhR2CobR7lVQkURqhisfbjhkf1uho/RxotLifyTW9IGFznxI1LLwpcedgDq
	13w15BU/g8KYQCl2TXhcQ9eTF5IEsW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526486; a=rsa-sha256;
	cv=none;
	b=dONhod8wbmW+kU6EdqjeEapgHLltgtZdF1U5sOPFZqVZijE8QevkXmIi0VVrmuBRaz06yL
	ljcc6ivc8YTbr2EzcLuhHw3RJ0cPEkjGlAv6Khaxa1Nlqg+bjxJNioGRR8M7/KHGlkAV48
	A4CfWbzTS4IcgVIdTdthmTssYgYrEjM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Cou97s3W;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260127150802euoutp02f3c2362e9dbc193c9bc948297b5ac05f~OnvXqoD130435104351euoutp02X
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260127150802euoutp02f3c2362e9dbc193c9bc948297b5ac05f~OnvXqoD130435104351euoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769526482;
	bh=bI7n7EMbVTLXkomvFX5EEgGQqwrIiq4zfj25LpKIMGc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Cou97s3WqBllpiKXMOmS6E6nyHX8cyRUsq+55z/ymrDXGb3vTEKta+8e89QekioTA
	 hTEyh28KTJ1noDj/M0ONRFNqgVHWLXgHkTH4fJY5Wm+oHflOHeujbfGYiUXK0hbH0O
	 7c6E9uFgQksYxE8gHL1gHsnKGGI2iNTxwrlD5b9E=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260127150802eucas1p15c9f15f01f36d46c5d109e71c41ebad7~OnvXOxVPF1522415224eucas1p1K;
	Tue, 27 Jan 2026 15:08:02 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260127150800eusmtip28d6317572cc161355f75102851645d8e~OnvV-5j8K0406604066eusmtip2u;
	Tue, 27 Jan 2026 15:08:00 +0000 (GMT)
Message-ID: <4df6023e-310b-4da7-95bd-f2952f40a873@samsung.com>
Date: Tue, 27 Jan 2026 16:08:00 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Rob Herring <robh@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>
Cc: ye.li@oss.nxp.com, kernel@oss.qualcomm.com, saravanak@google.com,
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, robin.murphy@arm.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
	quic_c_gdjako@quicinc.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <CAL_JsqKWd2H0bV9Z8REMBYd2hPMTjDO1T4dYehM-QvemB9zrDg@mail.gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260127150802eucas1p15c9f15f01f36d46c5d109e71c41ebad7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395
X-EPHeader: CA
X-CMS-RootMailID: 20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395
References: <CGME20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395@eucas1p1.samsung.com>
	<20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
	<X-TH#1.CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
	<99dc91c9-59fd-47c5-b1d9-157bda86ad59@samsung.com>
	<CAL_JsqK5QEZfyRTDY4z88mX_eYENibea1ZM8H_bEfCCsOOwY4A@mail.gmail.com>
	<89f8895f-436d-4a73-a2c8-d61a2f4ee41a@samsung.com>
	<CAL_JsqKWd2H0bV9Z8REMBYd2hPMTjDO1T4dYehM-QvemB9zrDg@mail.gmail.com>
X-Rspamd-Queue-Id: 308DB100003
X-Stat-Signature: dux5m1zk4c3j5s5d3gazsgmb3u5wsprp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769526484-167260
X-HE-Meta: U2FsdGVkX18j0y/xb5/hJFFZgYXxQCqzH/uHYSUm8vMDKK3Urca8NtV4ezM9PEy8B0EZ7o4DbvMVAuffLJndhqm5kQScHz6bzqdy8Vu4n6KnhpUSJFYjVPhGshW/nzrzUWs57OjReHq/UY8M0Ccxzl4v/cxyXUWZUds7HGcFwJa5O2X725T/I5OzW0xjT15BD+qJbVkV8wV7bB9I/bU76LkcKYhkXxEcnUAnuZ7lTAXdO1bvbJHoxCf3IJTUDUDYbWdq0BSkL6u36AQaYF3ZxsIqmWR6gjptzWiABdUiBTIZN3jXBSyl7TnurVobr3NiFQHQ0nwqtPv8XYCe1FQp7V+tvdHjfXy4JvMxI9r1Uo+9M9Gtmiwt8ror2h2zR2+Vb1wjruCq71cTxZxhyPgzNhQlMboOsfRnTp/I8uewzNTKHvCSa54skAL1bz75piu7DBRF3MHLPOzlpCUVdBYyQwS7+4oP+ZjRnDKR3m679pl+/fWkbOR2PdqNoB1oyTg6+wRGHfycBGaTfPu83IagQBAwNpFBuRe8JlvM1Ibc2MNOEtOwADzo+/HIh2ZGN8gb3tQaxbHz1crmjxa5WhHDdVGxhKyfhL77nl/um0OkDRkcb570hwvI4oAeR+0SET1MZtIKMrtp9uuuhjwuaCwc/MCNofCNUwQ93avb9clxFyBNAPdVIOE5V+5FXVLRn4doXmAPkk1zjVOK5vGQ67lXFL6nJCWR7efDfE+rojPhij3QorXt4BcDKfffOcz1V+fRcRs/kUrCqKcfBmnQV86wN8BdKetgYifNxIdo3BxYBs9JJwC7HPprIa8SPT2kUI7VOYlv4B4jwDBBceCY2/M5jlVBcwm5Cs18TL5dcmjpa8OXT11ByZ4mouju/PsjOJ2bGkWjWrUTXiwfw/A38/Olf8muf2QvLf7tcTcNdoTugP4f5Lyy0YHOPb9lFWQpGOljQj1gzbgb6wQbBXuUyd+
 +S8jgf5E
 6vYciPfjGphMt648FVTrepxhZDDzobJmHMwx8ZtbJj689EMjv/UwoJyHke4pZ0yPfgtgvGDj92IEk3shAdrCUVoIcArtyt2nI/xydjatsMf5PyrT4ZDTw68FHcUiMJ7xuPD/etRgqdudTKULeVLHNTLujseHnGQTfQdeoFxHBTBeQ9uH5iNqyR9U3Iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.01.2026 17:33, Rob Herring wrote:
> On Mon, Jan 19, 2026 at 4:38 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> On 18.12.2025 15:42, Rob Herring wrote:
>>> On Thu, Dec 18, 2025 at 3:55 AM Marek Szyprowski
>>> <m.szyprowski@samsung.com> wrote:
>>>> On 10.12.2025 15:07, Rob Herring wrote:
>>>>> On Tue, Dec 9, 2025 at 6:20 PM Oreoluwa Babatunde
>>>>> <oreoluwa.babatunde@oss.qualcomm.com> wrote:
>>>>>> When initializing the default cma region, the "cma=" kernel parameter
>>>>>> takes priority over a DT defined linux,cma-default region. Hence, give
>>>>>> the reserved_mem framework the ability to detect this so that the DT
>>>>>> defined cma region can skip initialization accordingly.
>>>>> Please explain here why this is a new problem. Presumably the
>>>>> RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
>>>>> early_param hook. And why is it now earlier?
>>>>>
>>>>> I don't really like the state/ordering having to be worried about in 2 places.
>>>> I also don't like this spaghetti, but it originates from
>>>> commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
>>>> memory regions are processed") and the first fixup for it: 2c223f7239f3
>>>> ("of: reserved_mem: Restructure call site for
>>>> dma_contiguous_early_fixup()").
>>> Honestly, this code wasn't great before. Every time it is touched it
>>> breaks someone.
>> Indeed it got a bit complicated and needs some improvement, but first I
>> want to fix the the reported regression. This patch does this and it
>> looks that there are no ideas how to fix this in a different way. Rob,
>> could I apply it via dma-mapping-fixes?
> Sigh, yes.
>
> Acked-by: Rob Herring (Arm) <robh@kernel.org>

Thanks! It's very late in this kernel rc cycle, but I will try to merge 
it to v6.19, as this issue is really a problem on some systems, see 
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1116251

I've rebased this patch onto v6.19-rc1, fixed the build break reported 
by kernel test robot by adding a stub for 
cma_skip_dt_default_reserved_mem() if no CONFIG_DMA_CMA is set and added 
following fixes tags:

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved 
memory regions are processed")
Fixes: 2c223f7239f3 ("of: reserved_mem: Restructure call site for 
dma_contiguous_early_fixup()")

With the above mentioned changes I've applied it to my 
dma-mappping-fixes branch. Let's give it a day or two in the linux-next 
for tests and, if nothing explodes, I will send it at the last minute 
for the merge.

I will try to untangle this spaghetti a bit and cleanup the code in the 
next release cycle.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


