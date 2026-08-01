Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 341F4C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 16:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A656B007B; Sat,  1 Aug 2026 12:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B876B0088; Sat,  1 Aug 2026 12:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D206B008A; Sat,  1 Aug 2026 12:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 972406B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:31:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBBBD1C0B70
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 16:31:41 +0000 (UTC)
X-FDA: 85053241602.27.CAB4F0B
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90737100005
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 16:31:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=RmkXFT2X;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="A M+GAMA";
	spf=pass (imf14.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785601899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GWeLMj6JRkBwIB5dZ2ML5Xr2ewkb9W4drJzAxuBpRM=;
	b=u2nqaYDyZ5l4KOCt4f+aCRwSKMDryV6UMsfYYz40rA43A9O1/nw6fZSLRTzGpNP5DVOsbx
	s3H7nTPAZ7eR7kYtytJMqNA3SslPDJG4SIw/z7qyOgIpealAKif9SlfVUtQDU9nxf9BuzS
	nfirufWI4ixQTvB3MzSs9t1WiHOSt6s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=RmkXFT2X;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="A M+GAMA";
	spf=pass (imf14.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785601899;
	b=JVpLXsJ5qC5B5Bxl2h+hXYD25tjiKrfX07U7q/lzaqwxcDGezYzjXVNJxumOH3Oas04mJf
	TrbrlUfMF2Ce5RUxE53pFMD3j6G8cNXNa+DhT0jfuqfZYr4Qm4DxstOIdlWBRcG53uO9M6
	H+nPbhlxNrB2gsPtAGdNvO/xB/5nM5Y=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 2F5F113001C3;
	Sat,  1 Aug 2026 12:31:38 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sat, 01 Aug 2026 12:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785601898;
	 x=1785609098; bh=+GWeLMj6JRkBwIB5dZ2ML5Xr2ewkb9W4drJzAxuBpRM=; b=
	RmkXFT2XRwFzTnZ4RUuvPxrVeMfPjFOnKrwCQsS1XptZmkGjnm0XK8zPm95SZptR
	vblyF6P+DynXIEReP4UCqbvO3IMnP26E8gPFZVvIKxFxpj/WP+jbSL0xKwAplAJE
	gEnbKFuaiMyMaFH5mrB8PQ+DMYdaPHXJ97/jG9UBaGIj3TQ7X1dTNdx1rF4YdDSc
	iMHjeqzRagEJLUxPukNwHDgpBumKK9kM6tgK5VD2UiZaQwlECGu1yKPHEkzUz/AK
	WkXrhcCp+jhjHp8Ngn+QB0Pt9guioRZlwl/hktcFcX6LZeI/fYbv/NpTjqirwpZn
	VVHNMIE0xu4DhjWBh1KyIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785601898; x=
	1785609098; bh=+GWeLMj6JRkBwIB5dZ2ML5Xr2ewkb9W4drJzAxuBpRM=; b=A
	M+GAMAm3QbbKNrAARFlEsFWy2tEQk0jncgzM/KHX319JOGnX3qe1BISPYpFfR9vm
	+Mw8Yrb5xv6kiMCyD9tEu8u1sJgT/x9+BwsfZ0I/5bT+yZXvmV7fD1LMhb+LmGvV
	8/4QEFQ2T1n45F2uJKEEeqD7FBWoiHWHR9Qu4WAZlxzzH52Npi94GZFVuq5dqBgs
	r16p0vkhDOqgX6wB8Ijy/G0nlIeqX5WG3Wlr3z9CEWwxsTI044OAmxg+Lr6NWXvK
	KUOKRdx6W+pcgXx5fMrK/FmdWe5guJFfuqbQPAsBnUKOzvrVxPucnnUVUjqaYPn1
	Je6eQuIup7l1UHNYKtBbA==
X-ME-Sender: <xms:aB9uauKFiZJTjA93RGjFnHFdEvt-HMy0HsgX3-hOAJlqrp1C3ZizVQ>
    <xme:aB9uaqFUWSmz2qOoolnQJtK4wKgpBNA245buXNm6-MRNEo9R6Ua67PC9nQciMCnBx
    wnk7tfBCvCeNvKWhGXcU30p2SuE3RCAmug5Hgz0g3Zhrot4cMOPIg>
X-ME-Received: <xmr:aB9uanPuOshfY6CtKMSGadEowsBukwEQX-vYlocgi_Cuevm95ob8-EiONsw-uPGosUE0_r9cndeMRUDj2Ba5V_0>
X-ME-Proxy-Cause: dmFkZTGysGsnMEekMD+PYaXQlblXcVTecPczGN+gVmqOxy4sIfPSEgEdEy9IGkXqGXAYan
    DgHFBKPnw/bMa6UCHHMC0exlwD99XK3fcXTSJ0QkvFhwAe2MTshN1slIIxFE3BXZADEpdL
    tUUbdbZ08888lAfzeLa8pD6z4j7mB1zFV/lVyxXX1BWN5uUA++eU/U1yOSrRvDozJBELil
    8rJAGQd3FpKYZxHzerbf/GRb7jk5KXrrlWQSt0HC55zxuWRowmB5ffELTLLDzjdJzr54fX
    bVWNOtgpIcH43ZWWHr4BoZH4xazltQq9pdjH9ZmzK0fC7Hj6xiEL60USKu+J8gJURge/pZ
    gNQpgM+Fy6NfM+eMiFCVI0shBHyPX3L7aWUnI3ddWuPO/7fY1U7bleIEI2rKSRTh3ddxqV
    y0PFC1MHUOu1nFyHSfUpyW+CPxPjQHUWXAPWjbm4posuz0kZ2WVdesFbz8wX7xOhdtoeQ4
    NIB/ZyX+wPhghTBupZRz2Fao6YdT5OVKu5w6QFEVPgjZUTS5H4Eqkn/A6SMTGffrhS9ge4
    OlLF8+/f+sQTWF9iebWeJwJoCqNe07ytko3fiWkDeSitzobrn/lY5IP6VGsTQmOR+EUlQ/
    UzXA2VVLIxEnMTc5gz5NwCEakiJBTEWt62brpYUVuKzUapbciJ7ee4sqm68A
X-ME-Proxy: <xmx:aB9uas_pMjHsEPoSSOLYfSz1vKmRwTmnO44j2Uj-tvYYFw4JuvSiWw>
    <xmx:aB9uas7ZWYyx1bGFlgWkMgfFvbwNqE7huNTq2hV0KbcluNmuVZat8A>
    <xmx:aB9uapXiIem4YDb63Xz4m0RJHUCh1r5m3J01ugYIx9C4daDSwLyfTA>
    <xmx:aB9uaqJ9TByhcsx4YSr4sAoMga6UtLV_5ds_HktryZHRG1gXKovEJQ>
    <xmx:ah9uapeWm7c0PJ_UJy7PEj8GZJ4vsUgV29GuwE-0KO-FsDt7a1mwCaDy>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 1 Aug 2026 12:31:33 -0400 (EDT)
Message-ID: <74625f78-15ea-439f-b9f0-939d2976fa7f@jaseg.de>
Date: Sat, 1 Aug 2026 18:31:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
To: Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Coiby Xu <coxu@redhat.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org
References: <20260731154608.153258-1-linux@jaseg.de>
 <am38qk60mpVFuJRi@MiWiFi-R3L-srv>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
In-Reply-To: <am38qk60mpVFuJRi@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90737100005
X-Stat-Signature: ak88a59id4ukhrbfax4t97p4enwouj45
X-HE-Tag: 1785601899-458490
X-HE-Meta: U2FsdGVkX18j4hybExQ4YJtAMdBqh0IDGASdzcYNVGVKAilERILYebbdFtvQoi8S8Lw6EthSY+IgTznGJZczHI7d2KOlWvsODlVrOvl2pge+qXmwcbSmAA0pUr/yshoU6sQzisx3mcFURQIQmXBWINoGYpNncmk8W9EcfB40GeO5mKdg+dVM0gw5mbeWp4xaFj7pefp3UIMFtv5PxSGWPFgPDnWXVrp0a/AHekM7jIC7gnjga5gCqAy5tCpiXR91Jbkw/UU0hw/83UCsydaEXEyoe4BTduXtDn1/Od1WGigk9Uk4bCA9hK565EmrPbD1iDjnRvV01IiC86HwLcQf5dAUUs+vn6NuE+nHbEDOd2J0h7LK6aZAAwHBDIrZJV3GnYeUlTJh4uzV0GkpTRICSxjcPdOc8hsUnVrEDcRLbzHWu74ZHTTZcJ0464n8Zb9LINiB5u2AIZRAbOdgJPfvH7zJIICGLW1Ow68/yoc2LX0W9UG/VDPj6DmRXV8spQw88DiZL3MJcoNmf0g5ju0jvFoCsTOuWQevmD7UWPpARqb5artmwv0IrI46/yW7x40rU+sRCKb5VCX9Vbt7r41A/P6LyDH6YJxAN/PvsOrkd4boME2pOZ1ddn5C6SXddDR0RAdviPgTCcfOGd+nMQYmBnvukuwfYor2LKUwWauG2O45I8E8XX1a0ZjYlqZ326h3LJydaLSwnkhspgadG9HVLtYIutIvQ6s2Gc0Hgv+Pb4B4+mlh/WgjW520ycVPeLps83/+stk0RfwNQslQjxe+H4Qsr8F9Dlg5PRw01BIxBU1c6pslWBhIIoC9nrTnaBzWxtz04NfZzi65Ayz7Y1sM1Q6I+opBMvAjsX3q0nQU9ovWFhl9XxqiRjFxCt4gpdffr3Wj6yNfMKCjAwwyrjEYOEZAVIxjY4Gl33RHRYM7idAmy7lRbNS8UjJQI+LBiUtoDh7UJWx9n7jpFbqIQOs
 n4fDZiO/
 Fv3riyBnZ5ZfJuH/0Ubecb5Qy4cpq2T3UDql1N+pSkEyZDYnx15oetDZ3rMiVf3r78f1Htjh+m2UXQCodQyHDUXwk1Nt85fRZZd1kOePIzhtrArABt0L2WrhgQI2cLAtC9/cdKctKsBsu1vfwBSdyykGsndu9cC+wUxmqOn044Uh/OT14Ktdy9uiDNM8fCiZQptUF9A4DG9FaOX2qe01L+ew9O6gwS74csV1tR6ZO2cEPF/Wgen9TBrHKL2ZIjyTUgHfkomBLJ8fATnvy5JkeWXUMaonGTGLplI9bLai++sAaGfCQW+8VESzYOKxXCXMyHgNDLZLShWyzpXB+vt0UDi4pkz0fYEKasHFzqi3GEBYspiwE+9IiimtTtgAhqsu4ZDrm/h2PwauvU+dFYr3WePczsFsyrKgjmn8JQNIitHE/Dd5ow2X9ie1nOK8c8Lfpk5emLvSGxWRZA0M3DjVoOp6qgTXG7ZdIRNiF8hSB+q+TwZny4fVYN7HKi7jTiJJV7VIPggnk9LL6vIYntJ29tPGxhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi there,

On 8/1/26 16:03, Baoquan He wrote:
> On 07/31/26 at 05:46pm, Jan Sebastian Götte wrote:
>> Add CONFIG_CRASH_ZEROIZE (default off), which when enabled makes various
>> subsystems handling secret data do a quick, targeted wipe of these
>> secrets before kdump. This behavior might also be interesting in cases
>> where you run a normal kdump kernel but you still want to keep things
>> like fde crypto keys out of these dumps.
> 
> Please check below patchset, you both seem to have the similar
> requirement. Please go there to discuss.
> 
> [RFC PATCH 0/4] panic: a pre kdump notifier list for hypervisor upcalls

Thank you for the pointer. That's indeed similar, but I think this 
patchset here makes sense as an independent patchset.

* The two notifier chains run at different points, and theirs runs 
inside panic independent of kdump. This one here has to be run after 
machine_crash_shutdown(), and so makes most sense inside 
__crash_kexec(). The wipe code in this patchset must be one of the last 
things to run before the kexec since the wiped data structures could 
easily lead to problems if something tried using them later.

* I think this patch series here is a bit cleaner. I don't think this 
needs a custom notifier implementation.

* Since there's lots of places that may need wiping after crash, I think 
it makes sense to have an explicit notifier list for that purpose, and 
to not mix these with other things like hypercalls. I think ordering is 
important here: The wiping should be the last thing before the kexec 
jump. Having it on a generic notifier chain risks that later, other 
callbacks get added that when interleaved could cause problems.

* Since a good fraction of users may not care about wiping secrets, I 
think it should be gated behind an explicit enable setting.

> Note that we usually dont' want to run a lot of work after panic and
> before jumping into kdump kernel.

I understand. For this reason, I think it's best to keep this 
default-off. As-is, the notifier list call is timed and on the (slow) 
ARM64 target I'm using, it takes about 3-5 ms to run. I took the "try 
lock, skip if locked" approach to keep the risk of this code crashing 
during panic minimal. In my application, the kdump payload is code that 
then does a full wipe, taking a couple hundred milliseconds.

Let me know what you think.

