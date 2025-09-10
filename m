Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509B9CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 17:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C5F6B0007; Wed, 10 Sep 2025 13:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2208E0002; Wed, 10 Sep 2025 13:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92EDE6B000D; Wed, 10 Sep 2025 13:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 811ED6B0007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:11:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3613756500
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:11:34 +0000 (UTC)
X-FDA: 83873982108.20.653FDF5
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id D4A0940009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:11:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757524292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pPunqbRdAk7Q1BPoWeHrXopoyeCo3AMqxUdPg7y0U0M=;
	b=pi0OlR1WCW7FrHUmAKVLE8GT33mSxza2Xq0J8S+i0I2P/Ungau2yv5pmJJ9BIjW3y+iIkh
	dVUzpe0If3xnDXO8nV/reGeqbSc0Tx05X70amIP183nd5+0DtvSTkVbq8isMfj1Y95P6YN
	+bT2j9DCPWOVKefoii0IfGDK/Aes+i4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757524292; a=rsa-sha256;
	cv=none;
	b=iQQVBk30vveprTYsAsSLG1cmV/5GP36reMuspw1gjkNXJ55Qe1eD/vwDuM06iZtfnHJtQO
	amyde/GUBNHCo3F/bNqA4D55yYRYCjNPsF+KTqv0cfJpGenajKXTuZHZvPfJHk6J4N96z4
	1pAw9WSaN3m63q4JVM9vuZXG0cl2JTA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cMS006bWmz9sj9;
	Wed, 10 Sep 2025 19:11:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mnbxQRtTxTSD; Wed, 10 Sep 2025 19:11:28 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cMS005XY2z9sj8;
	Wed, 10 Sep 2025 19:11:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 8550B8B7A7;
	Wed, 10 Sep 2025 19:11:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id tVGSEt2GMt0K; Wed, 10 Sep 2025 19:11:28 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id C99E88B764;
	Wed, 10 Sep 2025 19:11:26 +0200 (CEST)
Message-ID: <d9caedb4-41c8-4ef7-99b9-51d891aee555@csgroup.eu>
Date: Wed, 10 Sep 2025 19:11:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Richard Weinberger <richard@nod.at>, Arnd Bergmann <arnd@arndb.de>
Cc: ksummit <ksummit@lists.linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 linuxppc-dev@lists.ozlabs.org, linux-mips <linux-mips@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, imx@lists.linux.dev,
 Lucas Stach <l.stach@pengutronix.de>,
 Linus Walleij <linus.walleij@linaro.org>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand
 <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, vbabka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>,
 Nishanth Menon <nm@ti.com>, heiko <heiko@sntech.de>,
 Alexander Sverdlin <alexander.sverdlin@gmail.com>,
 "Chester A. Unal" <chester.a.unal@arinc9.com>,
 Sergio Paracuellos <sergio.paracuellos@gmail.com>,
 Andreas Larsson <andreas@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <497308537.21756.1757513073548.JavaMail.zimbra@nod.at>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <497308537.21756.1757513073548.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4A0940009
X-Stat-Signature: ykpdx9pax9b1spomirm4st9848td9gaz
X-Rspam-User: 
X-HE-Tag: 1757524291-645358
X-HE-Meta: U2FsdGVkX1/DDgcAMr/1FdK3ljeb2gutpUMhFI5xJj+icoOSFeyDS5NSwwvMoBbbtZ4peGAq4FFAK6pckfmcPKc/2Vc+ZDBOgTA8j///WjMurgFERpKMUdhERXf9v/Ix9jwVAYLT1Tat9Ime84SKK2n+Cx5mIRlosocUseg66ItCawtWhaKVS90UuwAedtUpncRRzlWYau8VukIchWg6NfUFXcIsivdZUcFCalWPQDtSVMh3EDyYYQdxxOQ93433WWaTddjqnGBJV8PoHW60JnnH+YtgCvATjgQzzJm3AxJAkaLhRFB3kLW2hTGYItPdsQhfHVkPc6bZr+jX+fHw8ZFPGySC1GvIrISvYiCkqidfoi0l3qyT/9eMvZXpa3pXwe0L35eyorKTBralz0gYW7EwOU8Per2qMvrQBP9QKUvSdNQknb2nwc4RdzlK2ArwG8/+6LC4PpP34zl544eIrHr22hQZjs0QXBJCpEciUWx7t8oLaSwOgj69Las+RUIfPfVSi66F3W0o6ewuJU55ndnzJWtE48Q4oAXGm5o8bVvmNRgGiaaSS45ipDqbcn016/yKw6chIldivKq0BUiu2+apmKqRc1dL0CmHh3aAF3gL+qnnHt91OdeQVQGAzUoVlSKE6vvysXK45NLUdVRdF+6yGTt/iPt+t7oUZapblQcxFBALi+8znWiF16d9woesded3VPbff9096tqNdcgdXiaSLWEZXJpfghHccqcVJI4D5SUgUBTjXj/kbjmW2r+U5P8ZpuoY8Hzr9d5gSLzBw2EFzQ44f2Z7qVSjfed0DhPPs+LJq5K1wzuKR7mocPjXmEqDVARAP74y6zZ/Ie+WoxwnTXir58fCuddAUmaBb4DyVTlnFWUiEtg8Oe32E3cj3dIPwLZCx6XKXdCJRYLDA3GBcd4ehdF67NcDAgtuEOJVHp8DZV/tl5aOHlgW1xIas7OOUe8VxzpAeIfxS92
 bFIi3A7Y
 mStiMOLQcjBP88d65uilL2sBWjV6Lvn4oq+dKwCujtRJco/igMlyw+Q5YMcv38YrFemjNiPiFQEcboipQdHyCkmwCpD+AOxXgJPiZXaHp3/cj6d6KV5ELr0sa/ylvFV8lOKXLBGiI05bLHFs46uPmlPMSU2CakgNUQ5yBhHifEQSF4MZhohnnAAhIpjgDkZZP/hS9lxwgtuO+BmUFJ6cKXJ7QR1EbEGbZnUcukTp5xHTiMFsD2rpIJqIkbPUf1IjdCg9DFKE14lYOI4Lgjkl+kMSmj+GPQo30VfrLqRH4ecdSD+SjFFE64IRuU/g819eKbQuicLLjHVPelFxXF1N507sSvkG6tyNrREdaBmX+p/6XlLCMw9APQDHNxCafd9fSFHj6+slrLv2VEbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Richard,

Le 10/09/2025 à 16:04, Richard Weinberger a écrit :
> Arnd,
> 
> ----- Ursprüngliche Mail -----
>> Von: "Arnd Bergmann" <arnd@arndb.de>
>> High memory is one of the least popular features of the Linux kernel.
>> Added in 1999 for linux-2.3.16 to support large x86 machines, there
>> are very few systems that still need it. I talked about about this
>> recently at the Embedded Linux Conference on 32-bit systems [1][2][3]
>> and there were a few older discussions before[4][5][6].
>>
>> While removing a feature that is actively used is clearly a regression
>> and not normally done, I expect removing highmem is going to happen
>> at some point anyway when there are few enough users, but the question
>> is when that time will be.
>>
>> I'm still collecting information about which of the remaining highmem
>> users plan to keep updating their kernels and for what reason. Some
>> users obviously are alarmed about potentially losing this ability,
>> so I hope to get a broad consensus on a specific timeline for how long
>> we plan to support highmem in the page cache and to give every user
>> sufficient time to migrate to a well-tested alternative setup if that
>> is possible, or stay on a highmem-enabled LTS kernel for as long
>> as necessary.
> 
> I am part of a team responsible for products based on various 32-bit SoCs,
> so I'm alarmed.
> These products, which include ARMv7 and PPC32 architectures with up to 2 GiB of RAM,
> are communication systems with five-figure deployments worldwide.
> 
> Removing high memory will have an impact on these systems.
> The oldest kernel version they run is 4.19 LTS, with upgrades to a more recent
> LTS release currently in progress.
> We typically upgrade the kernel every few years and will continue to support
> these systems for at least the next 10 years.
> 
> Even with a new memory split, which could utilize most of the available memory,
> I expect there to be issues with various applications and FPGA device drivers.

Can you tell which PPC32 model/family you are using ? Is it mpc85xx or 
and/or other variants ? Maybe we can look at keeping CONFIG_HIGHMEM or 
find alternatives for that subset of PPC32 only.

Could you also elaborate a bit on the kind of issues you forsee or fear 
with applications and FPGA device drivers.

FWIW I sent out today a patch that removes CONFIG_HIGHMEM complely on 
powerpc in order to get a better view of the impacted areas and allow 
people to test what it looks like on their system without 
CONFIG_HIGHMEM. See [1].

Christophe

[1] 
https://patchwork.ozlabs.org/project/linuxppc-dev/patch/28d908b95fe358129db18f69b30891788e15ada0.1757512010.git.christophe.leroy@csgroup.eu/


