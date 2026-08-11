Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9126C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953E76B008A; Tue, 11 Aug 2026 11:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CAF6B0092; Tue, 11 Aug 2026 11:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C6D6B0095; Tue, 11 Aug 2026 11:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 500296B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:06:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D08C7140482
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:06:04 +0000 (UTC)
X-FDA: 85089313848.09.E13EB38
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf12.hostedemail.com (Postfix) with ESMTP id 95C7240015
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:06:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=DUWOYSVs;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="j lpZQap";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.155 as permitted sender) smtp.mailfrom=contact@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786460762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+R7JMANSoPU0Lo7IzhksLdgglky5VdSN1BAdqtQvJK0=;
	b=2Ysj6x46Hlc9KTnCcSWUW7B1VOUkdy02wU7AMgDMcrpnZXMZCo4J/QWAwFnXIqRe52aRgs
	Kcd+9XkC+qzQGKHyzU15PsRM5NAXiozCi1viPPenqSTJ8yJUsXEQ9uStYlHHUpMUNetB2m
	lapO15HDIUBSOGIRKQuvH5kMRzJn2UQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=DUWOYSVs;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="j lpZQap";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.155 as permitted sender) smtp.mailfrom=contact@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786460762;
	b=FNNw9gzH/Tl+rxBbvum+LclhrqISbxDt72E1dzrc6PVl0jvIEpHpESX62bQ5S2ep6T3BXG
	qIybVGM7rJA9d6ideW0p+fJK5rkTAN+djO81VP8gvqQhjbHZ3Y7/+Ar77eUZFMY2dT51Jd
	RLMGFsfkNBsKeIxfae4J1ETaD/Cy72k=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B24857A0181;
	Tue, 11 Aug 2026 11:06:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 11 Aug 2026 11:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786460761;
	 x=1786547161; bh=+R7JMANSoPU0Lo7IzhksLdgglky5VdSN1BAdqtQvJK0=; b=
	DUWOYSVsIpLVmKjF/IUlILPEMxDBvO4sFISJOuzQouSq7xBMC3EiHDoCsXZeGn/w
	euv5pKnuG2TpICvHrI6NQRv3gcJ+Q22zvvhmOZhwa0+FjvQDvHfo3G3ohHOOby1K
	VkqvZ26a3FC/AhHvg2icA/n61RglIhgkUmH/zEoT90/zc1v2ySLBzYx2k8I3S2VH
	bEVmP2LIr1LTq4wugyZHXcKeCL+2qnuvQMdvVCOmx42/+cgPNt1boalq6lPlc2iV
	eC2J+VGuUJzk8CdXEN+dOp+2kZFgx60YEHXLKdIsbGnooQPAHJEfe8NOrrfzCiPH
	3hCcmpUnfzpgrzqVo7XozA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786460761; x=
	1786547161; bh=+R7JMANSoPU0Lo7IzhksLdgglky5VdSN1BAdqtQvJK0=; b=j
	lpZQapPqhsyo0fVD++SnG85AILHWB5Wd8YIPSfiqcJfVeFxqq7XQcRhiXz7fv/3s
	Ugqsydv6dIWLt54KeHQ1cAp5F867ooOZcK292nMX50drIQgCRqN8g9l340a3xDRa
	UlKpPROVSWfZWHPWtFzUPlX9JnE7bMicUEG04ipR6EWChf2pbMQVFVclBqZL9n5p
	eyGNe/E3xabtplwUebsD0mxeeLkj2gS42vduVd3JLG6sqr6EH8x5/saufriwrnZM
	zCxLxSS1WjbSFXLPXWO+gyb6WyajYCLn5Q5vpSoL30zoepi5vz26LhfFU/AYS64T
	3MSNNF/jq/RNBWkL8eaKw==
X-ME-Sender: <xms:WTp7ahuVXkaO_fLso6p8gNYsCct6uUXbXX_JdV6NujKqUIHCWNdMlw>
    <xme:WTp7agc2IqgE61_WDHIPY4ZGxjBXWDJYc4SXs-fvyfOJJGkzj2-R4-rhK4lmBBDjL
    HKMpzAIslESfSf25FCILDWmIDHc3Q8xXCEGqWy0S3iAg_OOOjUxjQ>
X-ME-Received: <xmr:WTp7avmzT8cHgBdGUokViJIN5F0Rf9OJZ0HGQyZhk33Ey3bhAtwtiR2Q6318GxU-ylG4wbC0H-52-eQ--6qqaTU>
X-ME-Proxy-Cause: dmFkZTFaFhDTW9a+ci9/L6pvJA9qM5lpDLTqExtHVIRCEVDj2T2FGJP5tMn7RDwcMrn7qk
    nmtfjcoqgLBPcIFpZn3Dt/xrL4D3cnW3PvgGo+7f0FWlFXXUEMwiL50koRLeu7RvcjqJ0N
    yo9W+3LtgZmY1nd/bnrZ9RCoW1aOMJS/T+Gs/KEmr40y7tZoy0Qv6NM8Zuv0sTcKfD7rPi
    Tr0nLbR98w0As1ewCc32EOlrGy01CCfK2wfwvYgs74GhRytlkG+aPsOso4uvvcKn4gT/Xl
    wIvuEF9sWzRmG5BmTVw8x+fJIDI+xi3WR9f/sIGAM6JyS7cQlL2Tck2SfguzjWcLfVmWQb
    ECKcPDpnZOwc8n6BTMokL9nkMFaCqpfwl2dPlinwXUmp80krxIn9VK34Dt4sEjmCOPVzZI
    /f2XWTsXyHT3ZOiI+5Yye2d6HT/9Nl2bBEQExnM8wmuziPZd+NSSBaHyIXxHuY6ryUWOop
    Sez65xfX9kpda0ez8yvQLjywGwcixMSBDTbWQyVDKGDIlY6Rxdu51dxq7j8qynea8it8k1
    tNKwCIsK8KyyLgqUNiqQddNPJumWI9JYRzjLoww0Hj5dVIxjR1+avD2vmt619qEHP0qzMI
    6FWY3wbYpI+TeJyJtq+7d0XcZSEsrzqdxpEDqRtJiyDLmMcRbyJ+5bZX4PrQ
X-ME-Proxy: <xmx:WTp7arBnnxJkbgy1HxUpCWZni3V4ul13WTUeBYV9tOCNIZGXbdcBdQ>
    <xmx:WTp7ahMIwuQPghocYLT9MgVbDQS_WZneiQXxeRq6tNBu1Fvpg9l13g>
    <xmx:WTp7aiMI2wdw5OU9e8Sg1ytfJ6spwnAe57F5thebQO2Gng88IAmcFA>
    <xmx:WTp7apksJPOZUjU-C3Ozy3iDVi1OcT1ORMZHxXwvkQUHetKX4UJ1wQ>
    <xmx:WTp7ahcaGsU5R_6NpuyLx3az9b4EJH2MvGNbLPQC7hiSjNsfZbXS15c->
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 11:05:59 -0400 (EDT)
Message-ID: <adcafa9f-2365-484b-b31e-19006833efaa@jaseg.de>
Date: Tue, 11 Aug 2026 17:05:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/secretmem: zeroize secret pages before kdump
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org
References: <20260731162739.158320-1-linux@jaseg.de>
 <20260731162739.158320-4-linux@jaseg.de>
 <70c578dc-769f-465f-a146-4a4695f747c1@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>
In-Reply-To: <70c578dc-769f-465f-a146-4a4695f747c1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: qh3nmfgd5az9yan1rgiwp9fbkgkwos6h
X-Rspamd-Queue-Id: 95C7240015
X-HE-Tag: 1786460762-742915
X-HE-Meta: U2FsdGVkX18JzYe2fsGQ4M4osE+R5iWujGn7x7rd+UMGNSchBtfS/wNuwrCVmOAMpD4Q/68HgC9GLXlqMkq6UjsgsI7IW2ZBvewZ7zgv5tBaszIP4+rPALxQWKOwVp94/A2jF4XLVOy7HyqQDRP1cfy4vlsXsJcqWg6WrnibVE/NviPWK33a5ROIrSZMsJFiDJfgSxrY3MEnrzxQTJc1PsF49rOGj5MEYsqciEhVvy4FvkD+l6R/18gRMV2lnHVnTlCOOGqAPx8Gu+Wso7JtBpg+NQpqwxvacOYObtaTh4q3DUqxes2lOrYwmMQW9/GvCFT4LMccyMcVaPXsp3tt6sg4QYt1/leWtRyFVFn20ZagN8n8QrPuW7zGVq3oOAqPJCzc7oBHR/Q3B2CGhT0eqiHsuapoQvYVzqkT4BD12YnpVkN8sHRhVNs5kPBRPoCzADbAOCRGNocqE5f+m37Wl/q9MVqHpCQjuW0AR7U/ReRsprp3VOYZa/UgH1zAWlVnwtZU1yFodsEa6rTq6tG7NLWUSFxVrR2KvwA0Uy4ApNCFU2DVn58GTSSeH/e/PAMOwxldOR2F6p0AdzHOWMN4PiLH/P/RFBBrdtFke6Qg76W4PvfuSGyMoNq1rL/lXsg4wvO0MAMg2SP8QW9B7xas3RtfetILTMuyn9ggFWsJPavLb0Xrn2QdhJR958fvBbvUGNjQI1wRMx/dCFusJDHU1svG85rZHXTzSyUHaVGebAp7H+9qWu5/Ilu0IWWjFxnZsMk6Cl47EER4sYB1fv4MTK1YAhbe+8/IwPfBgz0hndRRXPkS/hbn4uctKHbB4jEdzOtyifmrAu6ejgliWawxjvLDCCwErcrHmn+NkzjTl07jS2bmeBani6O+0CUkt16TP4VO7U0CT4apXtyGrxElbMIKAge1zvgNTYLPLh4O3Px1iIs7y5pjHT2a0/2Tik7Ngjwu/blS6lo+Yv81LNT
 dFxojMXU
 YvyblDADTTxjcJmNZEKU+PwhDSH3qVziwDJr8rDMoaWeXbGfwkf/qDuWVcHkTFSEWDnqQWCvzxHX3JX89Qse7jgqbgd0qtnnNalbPUutMo079PKCl1JUIsD1rKu/Aa0kO4SJ+lQHz6gY/JM0gZIIlQuFRz8CZXGlDRTlq6d9Q9eKagvpvk5Yp4kVWxYt6Izsh3m8tNeJcm7cE6fzvuVUhI880Va2mibdEY2QTcqI+8W4XdMzVQ02fcN0k9kkAPIBNroqQrsSrI/cB0bhjYlVYb66MnOIU56QtF35ZShKIPLHWqjG9sElptZimDKSWjWc7D2sJG8HfjL6ilHvxBH6+8auI4+iFLFnqFGBWxS6223YxcqQKaesTCMY8A6Zghtr2TLvZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 16:53, David Hildenbrand (Arm) wrote:
> On 7/31/26 18:27, Jan Sebastian Götte wrote:
>> Register a CRASH_ZEROIZE notifier that wipes secretmem folios. As a
>> result, when CONFIG_CRASH_ZEROIZE is set, secretmem areas will be
>> cleared before the kdump kernel is kexec'ed.
> 
> Are you actually using secretmem in your use case? I heard some rumors that
> secretmem isn't used all that much in practice :)

I'm aware nobody is really using secretmem. I decided to build this on 
top of secretmem because it's an existing API that actually kind of fits 
the use case. While I could have added a new API just for this (marking 
userspace memory as wipe-on-crash), making it part of secretmem instead 
gives some additional defense-in-depth protection for both users who 
only need wiping, and for users who only want secretmem's additional 
protection against kernel memory read primitives so I think everyone 
wins here.

