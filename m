Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F122CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE036B0005; Mon, 18 May 2026 05:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D761F6B0088; Mon, 18 May 2026 05:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C936B008C; Mon, 18 May 2026 05:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B40066B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:08:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AB7A40719
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:08:35 +0000 (UTC)
X-FDA: 84779964990.02.FCA2C75
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 82F6CC0010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:08:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mn/ebOCL";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779095313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoVBgObVlHLK3fouujqDYkCHlgaAhCdl77DK23kYJ50=;
	b=3jG77OyPL1Gx1d5FOowCPzK1N9LEYlSvMq4mEQQiwQdYX+wFXlRb4wfvOtve+aWF0+wtId
	hl8Vvh1sg6NVgTEx7IhbhhkDWEA5mbzlL9Tj93D+/e7an582G6qKzFscdzCjt3O1qcdLe8
	NfrKcmQU/PKhB8FjUwLusbvD7fWaYcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779095313; a=rsa-sha256;
	cv=none;
	b=T9BiOyf7IfbxgFT79VW7XJ2E1sAWW0gI0k9aqvgvttHqqKrDEcJU4ECduCe3EtqQpLBOWH
	JUjBmlAfPilXjVk43HqJF8PhIM2D5BemhIOW/hCGR0NuODIRxZJdUxRo4o3ev972dNiPF4
	XS4qHcRAo3emf2MugWBgvDP2A8gRfdA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mn/ebOCL";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779095311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZoVBgObVlHLK3fouujqDYkCHlgaAhCdl77DK23kYJ50=;
	b=mn/ebOCL9V/jPWdfLunYjJIvlB1wFcJxWyM07xrG1tHb33Hi6XaPLW1xtf2RemOdOWiOfM
	vcEALMSjJ086jo7epDbzh8QVdkJ4eTHs+Uof/0Hb2UYHxmu8uL5cgnyJ3L085/TaeYP7pP
	Usf2sFrv2Mt7agvai2wgWozRGLKTjHk=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	npache@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	liam@infradead.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	ljs@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
Date: Mon, 18 May 2026 17:08:20 +0800
Message-Id: <20260518090820.8101-1-lance.yang@linux.dev>
In-Reply-To: <cf552999-0b17-4abf-889e-2400c28628a9@kernel.org>
References: <cf552999-0b17-4abf-889e-2400c28628a9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82F6CC0010
X-Stat-Signature: saz7w5pwt87byqji55d74brhufnswkyp
X-Rspam-User: 
X-HE-Tag: 1779095313-945388
X-HE-Meta: U2FsdGVkX18BN78fLJF6Y0o44FX0Pfn9D+DGYhtM3jS38aysAG5U78DBJ5izqYIHfQC62bYgvqS8wtkaXHUzwEK/yeZNjeyAbXangXsTBqM+2tziZd8ecOhpVKLEx0Kj3+g8qOgW57ffikrkWHOUPa6+T4It1Xs5f63g/RRgb/uV/oFYthbA/3aB5NARPFmA65M4L9m5jjH5EYKFBIgeJt59AjwacBRQPOUmk0qrr30g0KyMwAJkuOwG23SCqJUqdBXvFsZSBebxeGqDniZ1feBIX7Lfh23NfJCO1aqwh/R3VXnGxBxUebcGK4eeX/zmJJqxEv5xe/PiKWrTrJnhHUT5VBD7KssSMwBYFgppVPtp//Vl2fgfgXNKRdh2cM4jZPgvItUzwWDQ+olk8zpCLFgBjQZwdM23X5WX/1neIez8gyN+IwLcdFazOtr9fZj/uHsJxTuHIETP0XJFI3nOkPzOutxCHk8HSxqmtybYXeRSLTOL84C8seiLbqIY2u2yUQ1Wp6hJH39lyOT87JKswSLY+HK+Lf7DUl4qvg91a/6EVld1b6doc/TII1HRGMGnQAz4B1ZgbsmQ+/TkSH2ApQrb4GL2QHlS3LEgMe220Gw40JbM7VaCFl5A6JUI9b+POGZNeOjEPGRWBIY3h4sF26CSEnQ6t6A9KwL4ZP/RBc7B9MKkVPcnNUnOGzOAHqlPdTmzb5epjR+oz8od8YNCEa71ropix12bqgvGnqEgDAE97jE+VOB6Rvhw983Ox2w4cyhjrUkVZJjdUPiKYLBK76pbtVaVmVnqfsbMZqDSG/caSJ5USYNxiLouWw7WHOO2vZmlnziiwkVwutcT3u0mFqiacxaMSOTn9Zsr8wNQP4b7cSReKCZDxIOXmPXpc/n2ZRW38pdQLqIpbisW2WEJGSSnzzVOr/9JV+gqT1/c/qSrHXvS40Cwr4sfFrIM4YCDCnH0DuzgZvaB+yS/kte
 W3ijJB2+
 XQUbLlSia7AfEULWRnvvY4mx3kyO1m74FikRepJ4kQzBtKWjT3O0gZP9oEka0lIFMglpQR5d2wF2og2llyf3kzOPlSxxJcew6Fc0PWU6p9iTQ294ZicuYcTWQgVlSfMNkWSmb6x1eqJ/9ptXG0m6Fh/NFvOyryywPUmHn4NFVXYTMdn/R1Rh0Z/ci34SLhStwPbFOSvZIvWr034XnhUSoWy4h8Kj3u3vEigmWFJpmTWP+/NV5T27ylA+ywJ0bVYrSJc4y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 18, 2026 at 10:24:26AM +0200, David Hildenbrand (Arm) wrote:
>On 5/14/26 10:11, Lance Yang wrote:
>> 
>> On Tue, May 12, 2026 at 09:02:38PM +0200, David Hildenbrand (Arm) wrote:
>>> On 5/12/26 20:36, Nico Pache wrote:
>>>> On Tue, May 12, 2026 at 1:05 AM David Hildenbrand (Arm)
>>>> <david@kernel.org> wrote:
>>>>
>>>> I meant before b1f202060afe ("mm: remap unused subpages to shared
>>>> zeropage when splitting isolated thp"). Sorry, I should have been more
>>>> specific.
>>>>
>>>> As in before the underutilized shrinker (and commit b1f202060afe), we
>>>> had the exact problem you describe above and no way to handle it.
>>>> Correct?
>>>
>>> Right. That's why the underused shrinker was added, to directly free pages that
>>> have been over-allocated with a THP, but are actually never "used" (remain zero).
>>>
>>>>
>>>> I guess at reclaim THPs would be split and we would swap out a zero filled page?
>>> We don't necessarily split during swapout, we try to swap out the THP if
>>> supported. But yes, that can happen.
>>>
>>> I'm more thinking about other reasons to split a THP (e.g., migration, partial
>>> MADV_PAGEOUT/MADV_COLD/MADV_FREE), where the behavior would be changed.
>> 
>> Yeah. Today any successful anon split gets TTU_USE_SHARED_ZEROPAGE. Would
>> it be better to make KSM opt out, so other split paths keep the behavior
>> they have today?
>> 
>> That way we do not have to worry about changing anything else at the
>> same time :D
>
>This is (1) here:
>
>https://lore.kernel.org/all/04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org/
>
>There will still be interaction between both mechanisms. So I'd prefer that in
>VM_MERGEABLE sections with KSM enabled, only KSM would take care of deduplicating.

Cool. I'd go with that approach as well. It should avoid unexpected
interaction between the two :)

That should keep VM_MERGEABLE VMAs under KSM's control, while leaving
the other split paths unchanged for now.

Cheers, Lance

