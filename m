Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B69C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6336B0099; Fri, 18 Sep 2026 06:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABEB16B009B; Fri, 18 Sep 2026 06:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0B86B009D; Fri, 18 Sep 2026 06:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 712E96B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:16:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13E07160606
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:15 +0000 (UTC)
X-FDA: 85226477910.14.93B573F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D166012000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g4cbWMx9;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726571;
	b=d8sxvLqO7vJ6d8FxEJ8p/ldNRBGJmcUGUoEb5Z1Z4zycrs5wi7A5GeEWH4iNaIbcY9K08s
	7NVOmKTgkVrkcMI19zDjckUzAKCtl7Tg9s5I2cAvhL4AESUIKEemY0TWHi+Fb4T249CCHd
	bnY76z60VJaDGg4sbmQJWloCbVSGXBE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g4cbWMx9;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/KT8CaYVgENoBnBehwFNNAA7M86YyAVDRxMUHoxzJc=;
	b=tDLU2PCzplmxQIVUkexidEeSuSiLhHroNgbTMaua32bK9ssxwF2Td7RMITh/aVzEShgIJ+
	uClCv/6OxJQXIEl7LYn7aT1bETaJqe1gG8pNnRsyZUDVLEuKe1wdxWarWNjt2eAcS/HHpo
	Pdhed43rkiKYSKOF0gJDzCXX7BoQgFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DD2343CCC;
	Fri, 18 Sep 2026 10:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED75F1F00899;
	Fri, 18 Sep 2026 10:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726571;
	bh=j/KT8CaYVgENoBnBehwFNNAA7M86YyAVDRxMUHoxzJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g4cbWMx9ITaRMwD4Iu1jVvbSRZ65VkM0tg+J8eCoN956MJDTnJ0/1ZQUSH9LcwT/A
	 +CxUwJ966rSJWrD16IlVMX19HMSOI5geKsZLCb2t8A/aAnOXtbWYe4EH97d2UpYLkK
	 owJ7KvLvllOvV0U7PT8Sh+gzSGxwufszw3euaBqrwaIl4cNjOVOtYPFO5MNNY5FI25
	 QAL9avs+4qTBSPHHRgXTT6Js0y2of5Mo4wqiShbN0Ubqz8Liz/yMce9TsdjTOgMMT7
	 QR7aE0oJBx76N6ddp1iyfOEr7+9+7SdqZV55irtHUGSty0tvBZdXivpeVQqHKI1x4x
	 C7v0LtJZiDR+g==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 47B4C1980047;
	Fri, 18 Sep 2026 06:16:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 06:16:08 -0400
X-ME-Sender: <xms:ZQ-tagGxIKryv0h2kKRf1N5IxcObfzeZQquU4u8pgjJMF2-FXW57hA>
    <xme:ZQ-tapPCwPqMptl6cL6ZKg5UEsC11N0svDYmC2DIkkqM0QR8YhTqOug8tEpdxkkLu
    KhJ4alpO-2c6Q6_ZryBuCQBVcOZro0vqjmxnNLh6iZ6GXIPJVbE-wxD>
X-ME-Received: <xmr:ZQ-tanfxPiOfkESC8Zkp3KfuW4d0rANv9mKp0dzReQjvygyXQMyFc9oweek>
X-ME-Proxy-Cause: dmFkZTEOZ5mh9pB2mQkbLNd/JVewrfyReYbYsYpHX+sU1E7TAzA2X02sav7XGPmJwjEopb
    gSm3mcRSvQfrNRQx+gl1o3R5mVBCbrzb+9xfcqyiKQGuFhyGMbALNgGogqO0dXHunRbFXv
    hBE65m88QBe1DTtGHOoTdVCIfiy7LwWjgqUF1VT+qmajYRigSj9gU7BFtCmwpxBXQFtfqK
    +tlrMyqw/O/fSMUPgKKYSqT6ge07Wo+3EslpWQuRVDoLAVwNkHI5kjC608Md7H7yxtjaq6
    IkUSrXO69POCdqg0HYisCpvJlOHIXqjW/gyjGk0JvIwaVgyOJOiq0Eaav1BsIe0j5Cbelr
    Sd13dADcWzOptfOTmRhSRoxboaDFljwqHs1R5Y8AxuGaz2h8SSIUpsTnw/G0HNY9ngY05t
    2yFZCeDgWit/VKF9OzuSTH1y7Lb+7MkroNYTFIqhRaVD8N7C/hxhdaqu2cQhc8XyzLhTH7
    Zn/DyzZZh3wmz62/Tqljx1WmFL5Kxu50uzU8tV2xvQHdtEkGs9IaoMFCkFR/nvox0A4WUh
    znnqZ/C8yAcPjK7vx3zLis4sazkYBCPUqapifkheiIm0Z8+nVqKK89oh/B3hBtV+cFP9mn
    MGwGfDnFl31+37BpdLplVB/PHCk/cli1iZzLLkud763iPJpdb2B8a0OzP6dg
X-ME-Proxy: <xmx:ZQ-tauRwIkLHqj1L467Bw30Hy_TY6Ucyh7C75AthiPARTxQWaqWEgg>
    <xmx:ZQ-taje-zhreKVT4W86R-AqECG2DKfevDzfEslp9OEMLR3ci5MksFQ>
    <xmx:ZQ-tamqteojjLfi81zol6s00R9cXq67OWMGgM21BMtLwdu2jl6x8KA>
    <xmx:ZQ-tasfNETwnaPmzNebKa_4hhBm_p9R7n-pOgKOkf-pBNyS6ykVTxA>
    <xmx:ZQ-tamkALkLOudePJ9_YHh8dGlhuak0gKwAjGtxByFQDL41RFucFSYLB>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 06:16:05 -0400 (EDT)
Date: Fri, 18 Sep 2026 11:16:04 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the
 huge zero page
Message-ID: <aq0PRa5SM0E8zjCY@thinkstation>
References: <aqwPHfWhKGty-Q_4@thinkstation>
 <20260918025214.89109-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918025214.89109-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D166012000E
X-Stat-Signature: q6zkcdurxknedf66gjsyqxhr1ybhsgie
X-Rspam-User: 
X-HE-Tag: 1789726571-661456
X-HE-Meta: U2FsdGVkX183JOAXtGNVGdjF9QEOKTnXTHs6NQ24EX2OY5uuWlSx5cTGVr+7Myc+Es6cONx+Gqz4vD87IbBckMmv9qntDuxYcl+C1qAE5zzMdQEf0kEb+aw+6ET6ECzF9cYwclgx9IBgz1ovJFovvExGIGztWSZL+GZ6v8Mzv3/Iok9yyTD2ut7F6hPV4kY0slUmt5ZK661V0UWaY+x1jKECpH7feLoZ10ESR8eLLahANy72V3lyZCI7hpb9rhFKIU7JX9fOneoRNqjh5dh/d0J+cm3eyesa9CwDytyJhJTciy8rq7rvNlLyLiweQqRphsfUpAGbz78DMhwg9+Z8c3n1y1Wa+DKs0u//EzWJNIUUNnN5gWCtdIC94KFCxxLjQXbV+bDTOy1umpjdyqIfNC+sVK96rFn6so5x28h9VpgtimNZFdWpMmXuuPMBgGIzyoPy+HE290VKWecU2KTgIkQFyoG7Ag49GbXbTJ0nvpruqG+pSlKwuTljBhUjE4okMJCo2xhWB4+Ll4auobvLqqoXWOm8AG0am2u6FY2XU1bg3QRJad7W+U821o7WIrcuPK0KWaqZoNtKeA83jCzSTpne3wtQRtgWYrezAWJ0SITM6X+vmmA1GmnIEbVFL6ntz6HBi2Fen/GDTLtp7Xe4MjohJr+PnkrDqu3606+Rix2Vaq3EefxMTCGo99BSZtr5Pt5063YFanCWzCeSb+uLR9yWrnylZgxeo8QP7Odz0X9VNACET6lUaGBVy1hEQ5Hu0185Rcb5TGgT/YuLiPWcAhc82ppjIeHRI9WgjwaFElieIPDHQg3lAoWFPGKzaTc9XGVrajbSrrReqZ+rvtRUAohRmbc2dqBOSptVMEbesS4OwmLxDNj+vpqQ9kMP+qhRyeL8IzjRtTWH1LPb7vPjCQZdUIXLG41v4Cdy+aSpVYp+kJieQk8Ies8yCXZoHNoDspv+j3sUgIOEONc8mhx
 +DmpIlgc
 Ap+0LK9E/hjHOfXACpH8qqpSeGKN2kfu1uN9U14BDFRKPfE+R2loYIfaUNBVZep/2c6tS+/+ZNDwM1OEv7srl4o7uTGq22Agk6fTr+g+cRV71vn6+wnncSHrAyj5SRotQOU0bQnMhRHXUSgxRAIg9MpIiGohWX4N0717TnWyVgJfqrykzGW2H2T/Zy3aFKhviMjWLlIJInCw/h4Dfp2g3k8B737QaNCMU7nm4WeklemadL19h1z9CnRdOi/rL7Lw2A0JfTP2phZNvF/yc9cWQtMDb2HFX2GK4D7WLZt4pi+YfmIleBOCr6glQioBlc8JUaA88Se+OSwYeVb2aF1EUtS6I9t3TldclSbXV/9TJtMAN0IwSfXZg2v1mBp/sjTgGPk7u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 10:52:14AM +0800, Lance Yang wrote:
> 
> On Thu, Sep 17, 2026 at 05:03:09PM +0100, Kiryl Shutsemau wrote:
> >On Thu, Sep 17, 2026 at 05:29:48PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/17/26 16:32, Kiryl Shutsemau wrote:
> >> > On Thu, Sep 17, 2026 at 08:10:10PM +0800, Lance Yang wrote:
> >> >> vm_mixed_zeropage_allowed() validates zeropage insertion into
> >> >> VM_MIXEDMAP VMAs. No in-tree user needs to insert the huge zero page
> >> >> through vmf_insert_pfn_pmd().
> >> >>
> >> >> Return VM_FAULT_SIGBUS if vmf_insert_pfn_pmd() is asked to map it.
> >> >>
> >> >> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
> >> >> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> >> >> Suggested-by: David Hildenbrand <david@kernel.org>
> >> >> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> >> > 
> >> > The patch looks fine, but don't we want to cover the same for non-huge
> >> > zero page in vmf_insert_pfn_prot()?
> >> 
> >> Why would the zeropage be a problem in PFNMAP mapping?
> >
> >Nothing enforces that it is read-only.
> 
> No in-tree user inserts the zeropage through vmf_insert_pfn_prot(), so
> rejecting it there should be fine.
> 
> Something like:
> 
> ---8<---
> The huge zeropage is reclaimable, but a raw PFN mapping does not pin it.
> A PMD mapping of huge_zero_pfn can therefore outlive the folio.
> 
> No in-tree user needs either mapping, so reject both with VM_FAULT_SIGBUS
> rather than risk making either shared zero page writable.
> 
> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

