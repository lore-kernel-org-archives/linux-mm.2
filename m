Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EA8C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462796B0098; Tue, 11 Aug 2026 11:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC9C6B0099; Tue, 11 Aug 2026 11:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3E36B009B; Tue, 11 Aug 2026 11:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA496B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:18:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D3B6C0441
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:18:30 +0000 (UTC)
X-FDA: 85089345180.01.467B3CB
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FF651C0002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:18:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=OkSvpkPh;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="K 7EYS0G";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.146 as permitted sender) smtp.mailfrom=contact@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYPUQb/d6rtWx5BnQSf1H4D0Q28bEWH3XYlE6Uyuoic=;
	b=yRyTBYLSUuOxjm/+NWrEz6OdFWRowL8Wr/bjecOn7QLzeZySUMg/ROnqHntos73riGtoO1
	ApzGsaJddwXZ+v644GV2UOk/0P/K8F5yU8ZjLbWpQGFpNNP1dDjwDfFyO7hgMLRxhDW+iY
	vfUL3RuoyZuz3T9lwyKGPcfT0ODEOGo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=OkSvpkPh;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="K 7EYS0G";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.146 as permitted sender) smtp.mailfrom=contact@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461508;
	b=6hrf260hcXpfOJWQ3NSy5X8IXKOWgF5R0rKKCbusoVilrpdcDT66VTwRO2K2A5SZPWwrBG
	heJsifo/T5QjYD8+HRK0KG1E1WqFCi/xt7Z+XpFsihw+kLnLk2cRuK7F9DZsWD9xbNMYHb
	tiNaVDvO0McKhOm9VWpZBBAfmP6iM04=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 760E61D000BB;
	Tue, 11 Aug 2026 11:18:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 11 Aug 2026 11:18:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786461507;
	 x=1786547907; bh=OYPUQb/d6rtWx5BnQSf1H4D0Q28bEWH3XYlE6Uyuoic=; b=
	OkSvpkPhbeHTAcVVg3AmAySuMVjgbNxxP3uxRdiYbHOs0sF4N+a8Af6lAxFCeciR
	wu6W98srl03o966LRpvbI6dXSTGyGUKoSH9Y7Stw1DKpCMR9RxqjavChHm+KjXFo
	HdfIM30xNhBumZ6uCBmCcrYpGY+l5/7810NNJyhF3BGmxL1lrZtOeKonJ+1wzcB7
	s/ay0dAEsspgDynnSUtwLp0+ll47MBUwqMaPCF3KSiG/NdOif9ore4nEx791Ncx3
	mZ7aSLIWKituUM+M+I6aIpZ6SXy3EMWP/aXfv3QcjU/ZV1teoFbN40ySm+jxVkVV
	NXzA+JB9bOPj9CP4X6RXRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786461507; x=
	1786547907; bh=OYPUQb/d6rtWx5BnQSf1H4D0Q28bEWH3XYlE6Uyuoic=; b=K
	7EYS0G1lPTQBmRCSdTNJOn8V508rTAsyzavsErMabjLIuEeivNIa/cqFtZ2NhCSi
	06tIuA/GUidsVD11tCw/cnEAOYYz5qD4eQDlSLz3MXU7u28No+8A5KW6GTAdgZxe
	8UE3x3OmeXuAMl0+g9Pf+C9L45OaANZh2ZSPScpgJ+L+iytQsEwOQ8eAQPHF/omx
	lE7/486UaaN9pafGgEWlh2ESxFlJX9IsXeLhlQ0H4XutFOEnZkTK3YZlPY3345VJ
	oeyleDy2R/rfNccKfgHcDSvUXuWBpKMLltMe8DmDyXGPr5kIFu+h81M3Ns0ywPL7
	LTO8VhPNp68qXdpbXR+uQ==
X-ME-Sender: <xms:Qz17akNPKX0OxXUkX1v7c9E3foI3R4NvivvqsYZJFT_4Ws3bWA6fJA>
    <xme:Qz17ag9pk2xjG7J96KVZf5zkj8tEVtb8vY74IejtVoAFBUalsf2wZ8ieNJZWHHQBj
    1wpsQarDLl-j9vt9ZLNoYLKCItpbjSUYJjIfdZ45urV06pGF9hYkA>
X-ME-Received: <xmr:Qz17amGeuxr-y1203H5JfCm9H1ybIkO-QP8IXdfM7CI2D5NDnceA0S5_S4XSNmkVbjPGlCXm6TRtuIXXF2_8dPA>
X-ME-Proxy-Cause: dmFkZTF9j4zAQxgbDG6gVbK/YuBSXn93w2o9WEbs1onJj5cVOHO1pJhDTQ7y5iCIxOZoeF
    5+I77TJ2q++EwNWn730g/SqLCLX95BvKYwbzlqmG1X/+4y8w91l6MhhT1PBBsFE916FBkC
    eUTPrh+Cbys+pDTrOqP/ZYKd9/VSruWA9j7Vn7zpnccy569U7/91s2bm4HKduRAEQiFr6G
    LlKkJuihRtitGPyGZ/V/0MHI+BV+QUg7oHhPAQpBps0ZQskM/gymw8HIzF/g10QzEKnIYr
    8+9p32zu+31L87XjHlPumT0bweAGh0Q+CYtqHJI39sg8VIK/g7XAaJO7GPyYCN6yVvSlEp
    +xCE/iNAcn6yMJBzM69r3T47jHjAoywMYYVC7b1VgjOa6y+ZPPdfN1LSfuo0jRcQ9wJFx2
    tlfQpNVfP3L9jbccbsRn1bszPrjwPJ0qAGL4vdXI0Wjju1tyABeE29/Xef7VSI4NChBWtD
    +8jn/VO89qL+8/PqPqrmXe1kj0MFtaCcw0SujK/0eWXXEuXVNzmk5UQf6hgyt0uzjwncGx
    LbmGYIwgeoTZ96EBNn+cLMMWkv/fm50MKCPh+c+ycpCd1LmrC9fgKKrHr0vyzzWBX7UpPc
    S4M/ldAkobWur3AQRmWXOta0YaeTvjNdmpGY6bvGsL1Odth3CPuzsDmdf6DA
X-ME-Proxy: <xmx:Qz17avilC9RkdUNWDSCNJGi12eX60AeuuWcBlZJzevlRiWdcMyk60A>
    <xmx:Qz17ars8LVp4tWPWLkPwJ6iUYxgYXYeI3C6o3iMRNQY2WbpYWUj8sw>
    <xmx:Qz17aqtjr5K1fhAJJgNik7GOu9eqjPAWnvirmFZSrV45y-Gi1YMEzg>
    <xmx:Qz17aoFVKytuSbZCAmGDTrBfz584_Nr1FfuHvokU4MOaN1bjXwok7A>
    <xmx:Qz17ah3dJfPjGwQr7etU-s3avOcsTH9tdae6n2ZEYT8_t7rGW_RBJG8S>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 11:18:25 -0400 (EDT)
Message-ID: <69d508db-93c1-4dac-afe3-3e3fdfb5271f@jaseg.de>
Date: Tue, 11 Aug 2026 17:18:24 +0200
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
 <adcafa9f-2365-484b-b31e-19006833efaa@jaseg.de>
 <8bb53d9a-8870-410c-9a41-f8b536ef0780@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>
In-Reply-To: <8bb53d9a-8870-410c-9a41-f8b536ef0780@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FF651C0002
X-Stat-Signature: gf3sn7swqdbsgfxno7nm8usy3b33wdbt
X-Rspam-User: 
X-HE-Tag: 1786461508-964212
X-HE-Meta: U2FsdGVkX1818QV6nPksiVwkehwjSPt8sHP5Vuh31j06k2JrXOjGshWLpKLCt+oQreYL3ZLV4qlS01OgOYEURi8fQnV5pxfDtSSwvyPkCvsSY8KUccidhcSRu6cZWii9gb1GR7gA1W23dvFRQELDdfnn18t/516VapVh6ozCc/fbDHZNAT+u62uFHqUeTrYAbcI+SAYGQ3S1MgsG0I/EuKC/tDF/dtAchvq9Tj1izsv8NI6/uL+08vaLFosJHCWWFthY0mhkMXFv3E3qODDaTaCO+/VoNqI7ZCue7Hvyjhe3oDaz4EzNkoo5IKd2fJ4QRZmI39CR8vLkzUANALhjXs5db4JYrkqkM+BhXz+eJkrw0bC0mzlH++uLzN58BHwA565VYx4/iYkuMaPqVngiBSVFLkZyZtjN8S5xhxLHEZvwcYDGU571QArLXlIzGrrdbo+wGJj90A+/tF/tSh2WWDhtaUCfvuYwr50K/jmQTcaFI2sBTNxnSjm0/hx6NrPqT7TxT2GEn/iSo0rTUu/sSy/v2lj25syPHGKbe20Ji8OVhq5wkiuJHObtJNHjQ4dV2dyAudj7IluECrwYTkidEli8c31FBIEOYp3QF/JeaBNTBJKq51t5eYXKCyobRH+gxj/rtSMQjNqx0vJfA/0YA3hajJGTo5k+9QjarxLW0a3hkPKJRg8YJNmlo9ck6FvONHhd1XlwiLMQXezO3Sp1E0XwF+Sni0d0TmRzrAYHDumX/AaEL/l8fx9NnbrTds6TD1KIfqZrfg8cYELCWAfpQxM30Vgx2/yBu0uMMzcE6Ax+0k/dM9+KSvzB1rpkIiZSj/qj7GGiQbqjTeTOBJYZHAiEABiXmKsxCNQw/zYL7BlxWK2rWTVf6CjrAXBrlxhKzkn4EibjkNVVME6Zw4CzVINYTMH6U9Xsd4ISYl0K3FhuTwFp4wYj2H+E2CV7gFTSkYrmc6bvYYscvBmQpLb
 RgdmrQ2i
 VHUdeAsbBmysLlkfHolzAILxJjF8eIDnSCyZyaT9vcwGUe1tOwUzJPRRD/CKMyLo0R8Q5eCEgkRZjhKkY5ls6gaqeGq0hX+mr+GgdBNEhm5C3sERaa2Nu1dApJAujzbH5J0g/n2OYd77cyvdUsOKfLZfe/EzJvB0MeyD9506KjW5N7JBwm9ZcrHrPHe5R4THexgji5skPvx1EFb112iki1IiO6OOtcilVdELCpUGibcswnmJXkmb2Fcbq2byNB+PvVCD+LIHJaDPVH0WBtBpWATWDtq71sjKxoYBv7PsMEnvHlXLqiVmXMmrmDQ9xbvqeWHXxFLc6O6IOJXI6dnCENyN+e4cJdxiTD4mioS0cjj6z71XaP0vZoTPsrNIMgexPbdHC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 17:14, David Hildenbrand (Arm) wrote:
> On 8/11/26 17:05, Jan Sebastian Götte wrote:
>> On 8/11/26 16:53, David Hildenbrand (Arm) wrote:
>>> On 7/31/26 18:27, Jan Sebastian Götte wrote:
>>>> Register a CRASH_ZEROIZE notifier that wipes secretmem folios. As a
>>>> result, when CONFIG_CRASH_ZEROIZE is set, secretmem areas will be
>>>> cleared before the kdump kernel is kexec'ed.
>>>
>>> Are you actually using secretmem in your use case? I heard some rumors that
>>> secretmem isn't used all that much in practice :)
>>
>> I'm aware nobody is really using secretmem. I decided to build this on top of
>> secretmem because it's an existing API that actually kind of fits the use case.
>> While I could have added a new API just for this (marking userspace memory as
>> wipe-on-crash), making it part of secretmem instead gives some additional
>> defense-in-depth protection for both users who only need wiping, and for users
>> who only want secretmem's additional protection against kernel memory read
>> primitives so I think everyone wins here.
> 
> What I was thinking when I looked at patch #3+#4: 50% of the users you add are
> irrelevant in practice.
> 
> Or are you saying that you are going to start using secretmem for your use case?

I'm in fact going to start using secretmem.

