Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1554C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F836B0089; Fri,  8 Aug 2025 03:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357DF6B008C; Fri,  8 Aug 2025 03:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294256B0093; Fri,  8 Aug 2025 03:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1853F6B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:33:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 277A5BEF79
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:33:51 +0000 (UTC)
X-FDA: 83752775862.06.97F2135
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10B0AC0005
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:33:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf22.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754638429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYY170L5/j8gQmCV0i0KP9yMXLZ9vOW8yjQXrZqWtaY=;
	b=am8qZO1vStF/K+VGaaqiq9hakClOni/doFEoVJLN6YNxuVinwgarHB0PsuqrenQsRfZkji
	i6Y3PTtjidUwYnsX0x9MDy48a8K6+oC5DXIWX5ixNOTUKYdnNrIWfBOImorYtRSZERJNHr
	f8RqNC5r7E9JLwflh4XOz8s6Gxmm3Oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754638429; a=rsa-sha256;
	cv=none;
	b=jd6LzAhdiv9Ou66d2C4Dzk0Fd6d37jZmOgWvcGQyYFd+azUD+pVdq+enBAdB8H/r4DZNAl
	gqCibKd3N9k0mC27vpemxo6zAKuAY+oBqgM5D+IbN0w0+6kg2HCao3qcIYFq2p/xrlIiA/
	6h8TsMSgZ6Zm1z2gbISchCmgxIaU45Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf22.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4bywkg3Mhqz9sS7;
	Fri,  8 Aug 2025 09:33:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6-UTSoBBRo41; Fri,  8 Aug 2025 09:33:47 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4bywkg2Vk1z9sRy;
	Fri,  8 Aug 2025 09:33:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3F40D8B770;
	Fri,  8 Aug 2025 09:33:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id UAt1KEdP_5VW; Fri,  8 Aug 2025 09:33:47 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 1F8218B763;
	Fri,  8 Aug 2025 09:33:46 +0200 (CEST)
Message-ID: <59ce87be-0a0a-4f6b-b439-bc7a4a037fc2@csgroup.eu>
Date: Fri, 8 Aug 2025 09:33:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, ryabinin.a.a@gmail.com
Cc: bhe@redhat.com, hca@linux.ibm.com, andreyknvl@gmail.com,
 akpm@linux-foundation.org, zhangqing@loongson.cn, chenhuacai@loongson.cn,
 davidgow@google.co, glider@google.com, dvyukov@google.com, alex@ghiti.fr,
 agordeev@linux.ibm.com, vincenzo.frascino@arm.com, elver@google.com,
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250807194012.631367-1-snovitoll@gmail.com>
 <20250807194012.631367-2-snovitoll@gmail.com>
 <22872a3f-85dc-4740-b605-ba80b5a3b1bc@csgroup.eu>
 <CACzwLxiVURgamkv2ws5sK9BQVMz7VPSWGy_aQb+MT8jtv03d3Q@mail.gmail.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <CACzwLxiVURgamkv2ws5sK9BQVMz7VPSWGy_aQb+MT8jtv03d3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 10B0AC0005
X-Stat-Signature: z14nie88itpj3oibyckp711z5g34udys
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754638428-244499
X-HE-Meta: U2FsdGVkX18rAaAXLOayYct3SqG4J4PLsvhfCalTMG1eIiqCgfl4EGoe7nNlCAqi0AfQ094aAKxbnC8T776diiMfg+ZElchM7ztXac/E5YnNuKmm2mj4o3EobAX79ofzFjhyAp8E01rR18Bw53VsuKXY4fUAqk7k1k5gsFh9bm4SMXA0lduNBlVmsF4yYU5EiFLS23AiY/tunGzIDj6Pmfn4QMWAc9sgNqlw9XSiVLvlEQ7WPJcds1LveUq6Obcq8wKHIj/zqyFUyYKBr34hAqd2+O3fYCg5g16U6EG1bmz/Z5cxIiGvRSPFt6fvEXc5UWuIAxhXPACsv4nnkEP2GClrjkSTLUJu7mWnagSB32iSb3eDOm8MNlr942dNZL725VtmJeOQdNemHDQ7ocLxpT++USDxV+AG5SodKT7t5qXb9c/lQ348/yA5R0iy9RO+dYgALvsYVHQpxHxnevixLPptTfkkjA/3w3oiYYO3y94ZER9iaRXgeM7iiwmF2WnQIP2eUswiJre8/sDz8+VV5TI5BjUlZ7gzdxEpaffSzgcjsJVDFp9WsP6hiHHdxkMKEXgp8/2TCpec5PSERy4xcTe7hoN98pTRDLe3CzNX5b3Mhv2prRMP9eCkOr+NldGgI6PCWD5jagIV/AFBTllIsX2zpehnGvCeN4Cm1XL/1sKkNOejfT34jJJD/Wn618Fu4z6iNzVE56AjmALnHoS5ox7qEgPn/zP04djUWmpWtgCQlhZfu3P/ykSbONWJXv2eNdvM3Z1SdrW6ekKg7/JPswH0hmIt9F2WwChXtic1M/tGNAqbxlx372LmwxQWB6n6QXYswdGAZADFSceN5EnP1x62B8sbt8oqaRPLc08n9iwP2N7Bm3slQ1xKWAzZpJsKTIf5wOnm2Cr3Ix2o3Aeg+pvwRpbp9KYXZauxBory2zRuEB6FR8AXJALuZ6aW2HWt4YPzNGc+Bkvrgrjr53M
 u1Ws9TR2
 okp3gO2jmtYS/de6GJDuPAz3f4tFfRbOvnXit5FROVw4fSOg0uHMxAEJ8Gry3TnwhkT479lP+OI2eyNtSPz1q4KW3BMsSZKLs3s6gZFLZS3y5/1bdqcFrG/xwugdOYCcmnVdfVaGlNGR9ZeJnSt/ZSUi39qXZMRVoAccvhMIF6kZfvHeYdIENk///pDMs9NEvXmdRFuBrnUa/CI8P8wMuVB9owgLfm1na/tx6qTbuIs/VOAs1anPy/k2Zs5EjAeMLDxWrLYUUt3hTbi+nMGxDoMaOyxBuE70uqcs/Lm6ykVwXnjWopTAWuUUcJhxIqT+EzPOKFVwk+thnD2POeEUQTCn9sQADxRw+2lHPyHZ8RugJykAvcFwZdDANIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/08/2025 à 09:26, Sabyrzhan Tasbolatov a écrit :
> On Fri, Aug 8, 2025 at 10:03 AM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
>>> diff --git a/arch/um/Kconfig b/arch/um/Kconfig
>>> index 9083bfdb773..a12cc072ab1 100644
>>> --- a/arch/um/Kconfig
>>> +++ b/arch/um/Kconfig
>>> @@ -5,6 +5,7 @@ menu "UML-specific options"
>>>    config UML
>>>        bool
>>>        default y
>>> +     select ARCH_DEFER_KASAN if STATIC_LINK
>>
>> No need to also verify KASAN here like powerpc and loongarch ?
> 
> Sorry, I didn't quite understand the question.
> I've verified powerpc with KASAN enabled which selects KASAN_OUTLINE,
> as far as I remember, and GENERIC mode.

The question is whether:

	select ARCH_DEFER_KASAN if STATIC_LINK

is enough ? Shouldn't it be:

	select ARCH_DEFER_KASAN if KASAN && STATIC_LINK

Like for powerpc and loongarch ?


> 
> I haven't tested LoongArch booting via QEMU, only tested compilation.
> I guess, I need to test the boot, will try to learn how to do it for
> qemu-system-loongarch64. Would be helpful LoongArch devs in CC can
> assist as well.
> 
> STATIC_LINK is defined for UML only.
> 

