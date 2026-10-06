Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DACCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 13:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4E26B0088; Tue,  6 Oct 2026 09:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856A16B008C; Tue,  6 Oct 2026 09:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7452B6B0092; Tue,  6 Oct 2026 09:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEC76B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE7C11A018E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 13:26:28 +0000 (UTC)
X-FDA: 85292275656.27.2F50424
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08F1CA0004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 13:26:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Xo20vtU7;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf25.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791293186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilvLBZmTUTzmE/0HmWSaWsOHx+yR2B5vrGdgJnqNXLU=;
	b=kPWO4lz8kZJU3lNnv3CBV9ZwDtR7s172GWajST/IIAq1zN2wpldl5HTQiAV+Pd2W0CiMoO
	K5al7pKfLRgabIyDxX8SfyjMzoBDpfm+Syj1DQzB3f8hj+TjaMB7ZAdDIZVuavmQ2fLKQZ
	jIBE0LuA34HZxBpP4db7osDlbkR+Chw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Xo20vtU7;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf25.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791293186;
	b=NiBc+GgnMkdPX7m1zT6whibZ+HyOZz3/N5P1BrHOmvAWZ21HA3r7/Txg2yhasIR7G2BvRG
	z4m131ORPaH7lF6QdSLeyhwQCvxCyYmSWw7kLMOxZ66rqAThNhfunT+DtaKkw+uvZ3pgTy
	OAMsr81YtarInnb2YgCbdovHjThw0a8=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261006132623euoutp01edf1c49739f2db08f8e45b4019f95719~b86jw8G3P2389223892euoutp01j
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 13:26:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261006132623euoutp01edf1c49739f2db08f8e45b4019f95719~b86jw8G3P2389223892euoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791293183;
	bh=ilvLBZmTUTzmE/0HmWSaWsOHx+yR2B5vrGdgJnqNXLU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Xo20vtU7vpz6oPUoo5J+3OTaVXCzYEoQLwGJLQfKlEieZQ+4aq6ct4FxV2dwnPz/D
	 yx4SBODk1XoQCa5j4HwJKEaIxs8v9xdtu6dfama+2U5eK6SntjR0Uh3iaxA3MvMUdy
	 /tKoGJSPDOTQ2YTToVsh2PWc+iaolL2UY3RkF6XI=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261006132623eucas1p2f095ce115c383348370c030aa9756bab~b86jfzdIa1161711617eucas1p2E;
	Tue,  6 Oct 2026 13:26:23 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261006132622eusmtip134c8b3d58fbd753bef81a132148a358c~b86ibB-YQ3255432554eusmtip1f;
	Tue,  6 Oct 2026 13:26:22 +0000 (GMT)
Message-ID: <5dccea9b-a9e1-44f5-84d9-bc9efe04edee@samsung.com>
Date: Tue, 6 Oct 2026 15:26:21 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/5] of: reserved_mem: several fixes about reserved
 memory
To: Mike Rapoport <rppt@kernel.org>, Wandun <chenwandun1@gmail.com>
Cc: robh@kernel.org, saravanak@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <asC3DBvtlcO5AVsz@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261006132623eucas1p2f095ce115c383348370c030aa9756bab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261003080438eucas1p2bdb68c248ecad088559285a4f736bfe5
X-EPHeader: CA
X-CMS-RootMailID: 20261003080438eucas1p2bdb68c248ecad088559285a4f736bfe5
References: <20260920092852.614973-1-chenwandun1@gmail.com>
	<arJA6fOMetzoBhDH@kernel.org>
	<060fb694-ba1d-40e7-8a18-f32d5a4039ab@gmail.com>
	<CGME20261003080438eucas1p2bdb68c248ecad088559285a4f736bfe5@eucas1p2.samsung.com>
	<asC3DBvtlcO5AVsz@kernel.org>
X-Stat-Signature: kogr6qduwg1qtzw7uxqjpiyrrjyhzcob
X-Rspam-User: 
X-Rspamd-Queue-Id: 08F1CA0004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791293185-569475
X-HE-Meta: U2FsdGVkX1/1VLSqO0RP6Drne6v39X6lPf0QkMrJwhnk1wwlAwiJ81xByarc23WbCKJ29CuzZJJHht4O8vcUzn4NP1YM5HF+j6JlrtufU0/UkoKKrb9eZ1j7ahP5uURkGxPs1cfZJ/J+8KqB8GmG0vUqHCuENfsOhLcx+4dD3Ip8gItHurvuToXLpbT6u+sx/JW9jg0JFUXSSTYDCpovgvrjG8V3DxZtFlIQe+27UCR3/HG6XzwSaVLeKjrF94CmsT3C6pU91OHzrPL8zJH7lA0HzeGs1ysL/0jkWu+iLUjIMnoYvQ3I1zDzZecXK98BU2BpqAiRIqtCj424SeK9HGqzWamSerpebW4/mwyPGRu73nrEruM3AGWUSXT6raUo00Qp5oM9/wY6rtIvH+Nvv2ZgebfFcTp2u/Z/6y1xozAG8eWIJCNL4QhdulgTxpiJ3KqFXzZHkRDOmJgGEYGTTaXKkPbFpYj9YmPc0Vh7b5JQAFjNiAr6+xUvPaTzP1ayUxW2YPEHbs+jei1EF6nwuuNfUpGqNJT44OjouJUuV2EbHa/1D4Ct4LKu1zKzr5VKRgNSdjRdvq8w+b0clJAYxyGY30TwsjIV8nDNHXzWvf/hBk879RSQLVbsoIpNiG2Q35TQYOlkHK+am+YDLwY3ciW9AgGD/vHWmDToGYmWfGlcSnvi71IJE6VVk8CPv4XPMbKA5AhuOtFqkMUlyZ2vEft1y0/cKUSTkFyG/cnOCWaLX5+rGQIq8+yzXYXXTjtob3jOWvbdSC6l68CQnmk+5E9JaglMBBmJw2P6eRl++ytjzdqtMloOAGEZyTouenykyP9EyEBiNDcCt/jlRT2RMNak6xdievK5LSgIDJlaTvCCGp/Cm2uMZHjgA/0D5bAFjqZ9hd2FpCEAnyfgGPERCjyU+VMUoShG5W2gt3MmV+9Qel8QAl9qHOQGMstDzv5kCJ2OArAcyTCspYWzhig
 XYxtnDVZ
 QAWKud3th3ms/DrENUPEg7RtBE0zZn7BnhaHRk4V0gQF6LmNX4V6H77N+IPXpTI/f9MO+3pq2hIWgsIftuhwu/Og265HFtilAvvYl/oBRAO6oaZ4mOTb2taGMrjCjjCsqdVnU2Y3+D9IHMYraK/J2pzTsJglJDZlBq0AF1aBZNzzKXyCL+2YXiF9pbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.10.2026 10:04, Mike Rapoport wrote:
> On Tue, Sep 22, 2026 at 05:24:32PM +0800, Wandun wrote:
>> On 9/22/26 16:48, Mike Rapoport wrote:
>>> On Sun, Sep 20, 2026 at 05:28:47PM +0800, Wandun Chen wrote:
>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>
>>>> This series fixes several error-handling issues in the reserved-memory
>>>> initialization paths.
>>>>
>>>> The first two patches fix cleanup of no-map regions after driver
>>>> initialization failure.
>>>>
>>>> Static reserved-memory nodes are reserved during the early DT scan but
>>>> initialized later. The third patch tags regions whose early reservation
>>>> succeeded, so the late scan can skip the nodes whose early reservation
>>>> failed.
>>>>
>>>> The last two patches reject overlapping static regions. Without
>>>> these checks, overlapping nodes can be initialized over the same
>>>> physical memory, result in data corrupt.
>>>>
>>>> Sashiko reported these issues in [1] [2] [3].
>>>>
>>>> [1] https://protect2.fireeye.com/v1/url?k=7e2f7441-1fa46164-7e2eff0e-74fe485cbff6-619f01488e6b7010&q=1&e=f3c07e6c-275b-4aa1-aec1-d931cda5f11a&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fmessage%2F20260814090305.4C8741F00A3D%2540smtp.kernel.org
>>>> [2] https://protect2.fireeye.com/v1/url?k=a92ba57b-c8a0b05e-a92a2e34-74fe485cbff6-5f58f4b0f32080b9&q=1&e=f3c07e6c-275b-4aa1-aec1-d931cda5f11a&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fmessage%2F20260814084718.29C341F000E9%2540smtp.kernel.org
>>>> [3] https://protect2.fireeye.com/v1/url?k=4f58aae4-2ed3bfc1-4f5921ab-74fe485cbff6-f4c4b3d0ed61b93e&q=1&e=f3c07e6c-275b-4aa1-aec1-d931cda5f11a&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fmessage%2F20260806100605.2C2C01F000E9%2540smtp.kernel.org
>>>>
>>>> v2 --> v3:
>>>> 1. Rework the mechanism that checks in the late scan whether the early
>>>>    reservation succeeded (patches 3-5, suggested by Marek, thanks).
>>>>
>>>>    Patch 3 adds a new memblock flag MEMBLOCK_RSRV_RMEM, which is set when
>>>>    the early reservation of a static region succeeds and checked in the
>>>>    late scan.
>>> Can we keep this local to of_reserved_mem please?
>> Probably not. I do not see a way to keep this entirely local to
>> of_reserved_mem while handling the issue robustly.
>>
>> I previously implemented an approach in of_reserved_mem that records
>> static reserved-memory nodes whose early reservation failed in a local
>> array [1]. However, the early scan runs before paging_init(), so the array
>> cannot be dynamically expanded. If the number of failed nodes exceeds
>> the array size, some failures cannot be recorded and the issue remains,
>> and that is why Marek said "partial solution", although in practice
>> having that many failed nodes is unlikely.
> Even before paging_init() there is memblock_alloc().

One can call it, but such memory cannot be dereferenced/accessed for example
on ARM64, because it is not yet mapped in the linear map.

>> To handle this robustly, the late scan needs a way to determine whether
>> the corresponding early reservation actually succeeded. Current approach
>> uses memblock to retain that state.
> I can't say I like the idea of keeping this state in memblock.
> This add flags and code to memblock to deal with corner cases of bad
> firmware that reports weird memory layouts, and once there is a flag in
> the common infrastructure, people tend to abuse it.

So far I found no better place to store the information about successful
region reservation.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


