Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10780CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A91B6B016F; Mon, 19 Jan 2026 05:38:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0573A6B0170; Mon, 19 Jan 2026 05:38:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7AB36B0171; Mon, 19 Jan 2026 05:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D78436B016F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:38:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 811861606BB
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:38:49 +0000 (UTC)
X-FDA: 84348365178.16.C49BCA9
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id C37FF140002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:38:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ggTC86J0;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768819127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6T1OAseONU5xESAp7DldoRF/tx4f3Urlb72aBL0shY=;
	b=r5pNYLYhnisdquxywy4M5Qby/AVjhxkBD8H5cCKyxzYeWmYEv1W/eJ/PYr1epV/LUv2rxe
	+f49exELWlX4VAztX0s11v9TEGXPHRkkdU0y4kgLPO17ViF509E6cAwvAbDC+FrahCWJgi
	qKbx8NeWf4SVQR09ovmKOIfolvdiGdQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ggTC86J0;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768819127; a=rsa-sha256;
	cv=none;
	b=MR2UBOxqxm8NsLcUfuUcqpiSm9lNg42TH+aZaJtFA4/or8U91YVAkc722Nd+bK7T1bgTqv
	AS3zwe4Op1nlbHR7YPXXIUOYPlNIfoSLxUHRX0BkRawegOBV3QSRdhxCds6k04cc9UpxjZ
	ZLJTo26WNOfbX+pnnyAjfpN4PS/EZU0=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260119103844euoutp020f33af9916496f7ff79a31d0e55a0f24~MG58_5X7B3199231992euoutp02w
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:38:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260119103844euoutp020f33af9916496f7ff79a31d0e55a0f24~MG58_5X7B3199231992euoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768819124;
	bh=h6T1OAseONU5xESAp7DldoRF/tx4f3Urlb72aBL0shY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ggTC86J0tuNir92HdO3ZuqKiwG+33RBa5m/KJMQHzp307IUNPZHcXARfyLutyZBlp
	 BwxzhDEaWMHOPDuafLcV+9LuXVZvuDCF3v0WlY7wPgYq29mYKCMJ8ETrC0HiNebEnF
	 3D/nLvqBlON+m5EAOKDFvMK3U0BDf71e8IrdgQZk=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260119103843eucas1p13969f70041187467385971a512493b86~MG58fQVze1992819928eucas1p1p;
	Mon, 19 Jan 2026 10:38:43 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260119103842eusmtip18efa3015d962d36d6aae889482359cc9~MG57VTnAg2814528145eusmtip1K;
	Mon, 19 Jan 2026 10:38:42 +0000 (GMT)
Message-ID: <89f8895f-436d-4a73-a2c8-d61a2f4ee41a@samsung.com>
Date: Mon, 19 Jan 2026 11:38:42 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Rob Herring <robh@kernel.org>
Cc: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	ye.li@oss.nxp.com, kernel@oss.qualcomm.com, saravanak@google.com,
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, robin.murphy@arm.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
	quic_c_gdjako@quicinc.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <CAL_JsqK5QEZfyRTDY4z88mX_eYENibea1ZM8H_bEfCCsOOwY4A@mail.gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260119103843eucas1p13969f70041187467385971a512493b86
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
X-Stat-Signature: d1kmsup83fp1ofx1dgzeh98scnuieuei
X-Rspamd-Queue-Id: C37FF140002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768819126-416937
X-HE-Meta: U2FsdGVkX1+QtyuU2z9elUgeanVIzLJ2en82DouFLmFu2Mk/gSHxAJpk3w61S0P1k8sKkIas3m/aEIOyv/wwm76pNgkLksdyxQHuShmXbqCZ0jmUzlWkN15t7Rq4SWFj3I+Vp5PuSUbxELRFlCByeEEkeRvpZIoFBJwyvTkYvZYK2nQPFm4NLdkEFegohpb3qQwOj0BGoMOTXRDpOLhiYIJkZ5KxGFqzxtQnS45f0mwGuNtZNtX4SCPQOLtXkXT8lELD3rszgfadzw8G19nFG3iD2v6fusJFYQPB60bjdtPdoFZkA3G06WDOe9AKcBlQFS/gHPEQmLLsKjq9pNcDBuuRCiKS94MrVLPgwDZ4J1Zuzo99vbzHwsmO2tL2ampZZYuq3E4wIuH3XndiCnZbIZZmhVEc+PDpmROeyh1SjMo26qiuoc04EmK+PtgYjE1+Qcvzeq7Vd1HIQmQaHC65ljzlE8PlJO51Z2G8v8ipF8K5crckM7XaDqUep+yNFOno9X//O357zfRwxaYbxqCqlxWg/rDOdt1J7Q1KyGMd4d6KcvBmg0ctkRQBzWn4wfTEGJMz4I8xgqz04ubZxI0bMeqdjs1LUEV1qoWqfTdnAc5m8gtBkvsa1TKcoDmU439UnZ78vyHiJ6WayEtYLdV7KWMV73/kztnZDY1xhrZ/up5VEoud8az9fBelv1OiWExA+HmXBw1kgSk5sVLDSKrZhfKXfau76nYW3HfIqt4GrctDCIa5tg3ChdxvX359ubSB4tmaY2t7QqZDEOLaqv/5MGS4jlANx7DjzJ9V9VGuVZ29IOmEmHOjtmbkFORh6OCLbuUSiuDHFyhwunxTZDGmcELqOzgMqgud/shZEqH6OmZoAOCXllbOOx65kyN1zBS3kHU8ojfgV62jwexPMgdrZgU0vLP7iPmeVLEsx9TMa/Mr820m2YWJRgaG1c3fCi7h/XuWZt/ISKUAhGhU19p
 /D8AkuXE
 vnsPWgyE0hGFb9AUohjfYFe1F4BMX4MDgAkSZ6xqLKNojdS4U23a4GtzbXxes4p4Py6DHKUW2ELxJWZVyl9r09bo4HK0e6TuN6uRbLDH0gKNGs3FMvhMLUs4u7W31TbjSbE/wwJR4ythH1szPDQOTJnu/q5tOXfyrUK06H5f2E5Zv6OgYUrgQSgQPcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.12.2025 15:42, Rob Herring wrote:
> On Thu, Dec 18, 2025 at 3:55 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> On 10.12.2025 15:07, Rob Herring wrote:
>>> On Tue, Dec 9, 2025 at 6:20 PM Oreoluwa Babatunde
>>> <oreoluwa.babatunde@oss.qualcomm.com> wrote:
>>>> When initializing the default cma region, the "cma=" kernel parameter
>>>> takes priority over a DT defined linux,cma-default region. Hence, give
>>>> the reserved_mem framework the ability to detect this so that the DT
>>>> defined cma region can skip initialization accordingly.
>>> Please explain here why this is a new problem. Presumably the
>>> RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
>>> early_param hook. And why is it now earlier?
>>>
>>> I don't really like the state/ordering having to be worried about in 2 places.
>> I also don't like this spaghetti, but it originates from
>> commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
>> memory regions are processed") and the first fixup for it: 2c223f7239f3
>> ("of: reserved_mem: Restructure call site for
>> dma_contiguous_early_fixup()").
> Honestly, this code wasn't great before. Every time it is touched it
> breaks someone.

Indeed it got a bit complicated and needs some improvement, but first I 
want to fix the the reported regression. This patch does this and it 
looks that there are no ideas how to fix this in a different way. Rob, 
could I apply it via dma-mapping-fixes?

>> It looks that it is really hard to make reserved memory
>> initialization fully dynamic assuming that the cma related fixups have
>> to be known before populating kernel memory pages tables. I also advised
>> in
>> https://lore.kernel.org/all/be70bdc4-bddd-4afe-8574-7e0889fd381c@samsung.com/
>> to simply increase the size of the static table to make it large enough for the sane use cases, but
>> it turned out that this approach was already discussed and rejected:
>> https://lore.kernel.org/all/1650488954-26662-1-git-send-email-quic_pdaly@quicinc.com/
> I guess the question is what's a sane limit? After 128, are we going
> to accept 256? I really suspect we are just enabling some further
> abuse of /reserved-memory downstream. For example, I could imagine
> there's micromanaging the location of media/graphics buffers so they
> end up in specific DRAM banks to optimize accesses. No one ever wants
> to detail why they want/need more regions.
>
>> Maybe it would make sense to revert the mentioned changes and get back
>> to such simple approach - to make the size of the static table
>> configurable in the Kconfig?
> I'd rather not resort to a kconfig option.
>
> We could go back to processing all the regions at the beginning
> (growing the static size), and then just shrinking allocation. Or
> maybe it could just be freed entirely. I don't think we really need to
> keep the state around forever.

I will check if this can be refactored somehow.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


