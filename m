Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBBCFC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61C96B0088; Fri,  4 Sep 2026 04:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13126B0092; Fri,  4 Sep 2026 04:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01C86B0095; Fri,  4 Sep 2026 04:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A38896B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:49:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AC2E140DC9
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:49:40 +0000 (UTC)
X-FDA: 85175456520.26.348E35E
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C71DC0002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:49:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=k+xjfBZb;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788511778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRJp0dKoJ0AAnYHiw2vjCZISve1u5NQsN4lNqiqXCas=;
	b=cY4GrHRrHX2sgk51WNBbWt6OZ9D58KaaAAotYtJT6VjeG0CxkP02BPvwpRpSKW04fXyoSN
	QaBWNYT7TNdOD//6Ucul4xDnDtzWkepz5OAh6dn+FYlfRfmsFNj1xJCy5bCDDP7I7MKe55
	5dbK0j5Ely3SG8SBP5/SFBqdyr1GM5s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=k+xjfBZb;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788511778;
	b=k1452bOJZl2nvUgMqgEp8tZ/1kFMIZvySihBtnIsxU+CUnYHLphUMQGOsLPQ+1rYaFCfjK
	oATy1b90qLwJjInRpoS/8PtYum5PvdNEha7YGNZy3dW1weaGE41zG1D2yGtRcnZZ3OaINR
	FfRWa8QpkWz2poyrkd47/dvUQ/CNd7c=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260904084935euoutp01310a302402056a64ea5865001ffb8a95~SEfvTm7G81000510005euoutp01a
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:49:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260904084935euoutp01310a302402056a64ea5865001ffb8a95~SEfvTm7G81000510005euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788511775;
	bh=TRJp0dKoJ0AAnYHiw2vjCZISve1u5NQsN4lNqiqXCas=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=k+xjfBZb8EOgq/nE1LFiRwgk5san30m75zav5GE5AIdFn+n0lmmiAZtv4FivAlksh
	 bJ5/si4pfBP2lD8+pAhcxxk0v9sRIdacAvSwO1YIzUbUWc6vSx15ara/qBcyWU+o8V
	 4RUUlXPJK6m6r6nr55E02f5HQmfNf6DFKccChJsM=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260904084935eucas1p13ee1a4294211aadad724ea4db531ad41~SEfvIXAcH1432814328eucas1p1d;
	Fri,  4 Sep 2026 08:49:35 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260904084934eusmtip2ef0e7280d599597ee308dfec8b910eca~SEfuw0oom1654116541eusmtip2n;
	Fri,  4 Sep 2026 08:49:34 +0000 (GMT)
Message-ID: <7a964778-adc3-4186-9122-3858bb61c372@samsung.com>
Date: Fri, 4 Sep 2026 10:49:34 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 1/5] of: reserved_mem: skip init for regions whose
 early reservation failed
To: Wandun <chenwandun1@gmail.com>, robh@kernel.org, saravanak@kernel.org,
	rppt@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <af87036b-0809-4880-b088-545780b4d963@gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260904084935eucas1p13ee1a4294211aadad724ea4db531ad41
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260818092438eucas1p20115e5d33908e32ef4433cb246da8098
X-EPHeader: CA
X-CMS-RootMailID: 20260818092438eucas1p20115e5d33908e32ef4433cb246da8098
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
	<CGME20260818092438eucas1p20115e5d33908e32ef4433cb246da8098@eucas1p2.samsung.com>
	<20260818092420.2859026-2-chenwandun1@gmail.com>
	<72074a49-2963-4f96-b939-79bf95a829cb@samsung.com>
	<af87036b-0809-4880-b088-545780b4d963@gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wr687zog7o4h86k45i7bi9kgpkd1wxhc
X-Rspamd-Queue-Id: 8C71DC0002
X-HE-Tag: 1788511777-610792
X-HE-Meta: U2FsdGVkX1/MLjTT9Z/MRepqDEhC2jy7eTUN/CKh2RQIPpoTNqhZOhwbpJQlZYd9t2yWemE3wKgGpN/GhrfAaobUWcyj536TAKcC/VKKeSD7UaeBV2HuD+0f1SIvxeUbVQR4dUPSLtHe8QlY5oRQGLWZtTy2GIN108bgcgCIAPg3y4LkbrV0TLfi3pMP83iNst3kh5WtKNF7Hlyz9l9TKUWynq6SUpRAPc/2fdVYq3NqfnJUdkrcI28pvCa4D3J41nrPvJl9dkMmdLRPP2PQ91EEPaNXa70A1v/x84trOTecDfY/b3oGAFe0or6WE3mqt0qfgYCNWqk535eN03U5EY122Mfv8KLszGXl/Braj40e0arCDOYG/VGsz/0MnVpsBx2zY5VPMV+oyyWZy3w/jfS2Ahos6clHuCq2GHztM+sfHwwPfdo3cG6dmr2xTusHqCjT7d1gAtokVTVucbt1oSlyqh5j3y54kC69ByQ7YTl9WgzwTdsrMPYuziVD7+B3Tir/E4dKIJSlMjZ+k/qs9anEAepXFWFL3TZ+BUNz0g8JYc1FwPCmpU0udQlS28pd6OVP3dGAWoa39f16w8sY4UHfXrw+q+SoEV2MNVCFirXTo2dRi3Rihop5PknOoANGZUmf++wLQ52INMkeCQeE0DwVKB2F6ghBEU8/XDoPbrggebSAKOgXpia7h1DtGAsekaqzcVTlv+YpbUfTOK9Ss/3A3r307fu1DmAQrWWbK37fMBARx8DnAcr+kJsELN89986u3chOR2MHJCcbknqcQzoRiFfqckE3pBReKxWBPX7sJC9WVvchFV3ODrNGkrixZluW2WwOFsC33wIqTu9AEx1r7yRFVlGuT/2JrW/VeYNRIGeVzHbIdEmtKHJ5vqmfC8uQr4FFmCpVNHwoQecwhB+qK71jMvXj2mndUCboBqARuv5wEfg5OUVdhkxWxAyvfpBztDvLdETE4cR067v
 CRCocWn7
 vLVq18+KA/rIEo/hXd24NEs+G6vGdz4tF4KBSpxpeNkcowVLH0DMwlpzie3c+LUWK1F8VLu85MnKMIikHYsoZDjFWG570+LWOClOjqxWlGbcWsblDuc5CZYbR2oKF6og70bOzd31/KFbCrWdDEoAIDKKBDV+EjbDE+HBw+s9a+O34DDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.2026 15:04, Wandun wrote:
> On 8/26/26 21:14, Marek Szyprowski wrote:
>> On 18.08.2026 11:24, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> __reserved_mem_reserve_reg() discards the error from
>>> early_init_dt_reserve_memory() and returns 0 unconditionally, so the
>>> caller counts the node in total_reserved_mem_cnt and the late scan
>>> initializes it without checking whether the early reservation actually
>>> succeeded. A region whose reservation failed is then handed to a
>>> device assuming the memory is protected.
>>>
>>> Propagate the error so failed reservations are no longer counted, and
>>> record the failed nodes so fdt_scan_reserved_mem_late() can skip them.
>>>
>>> Recording the failed nodes explicitly is necessary because
>>> fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
>>> tell from memblock whether early reservation succeeded.
>>>
>>> The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
>>> of static regions is not bounded by it, so on overflow the extra nodes
>>> fall back to being initialized, which is the current behavior.
>> I'm not very keen on such partial solution. Indeed we have no place to
>>
>> store the result of the early init call, but we can check if the given
>>
>> region has been earlier marked in memblock as reserved or no-map in
>>
>> fdt_scan_reserved_mem_late(). If those attributes don't match the
>>
>> region can be simply skipped then.
> Considering the later patches that reject reservations for overlapping
> nodes, checking the memblock state in fdt_scan_reserved_mem_late() may
> produce false positives.
>
> For example, if region A is reserved first and region B is a subset of
> A, reserving B will fail because it overlaps with A (in patch 02/03).
> However, during fdt_scan_reserved_mem_late(), B will still appear to
> be reserved because its range is already covered by A. As a result,
> B would be initialized even though its own reservation failed, which
> is contrary to the intended behavior.
Imho the overlapping reserved regions are some kind of configuration 
mismatch and it is enough to detect them. fdt_scan_reserved_mem_late()
can first store all regions to dynamic reserved_mem array, then check
for overlaps, and only then initialize those, which don't overlap and
have proper memblock attributes?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


