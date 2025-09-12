Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B75ACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BFF8E0022; Fri, 12 Sep 2025 05:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BCE8E0006; Fri, 12 Sep 2025 05:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D44E8E0022; Fri, 12 Sep 2025 05:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 589E58E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:37:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C41813BA61
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:37:47 +0000 (UTC)
X-FDA: 83880096174.18.34A0CC4
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id A372A180003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:37:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b=jxIBuKWB;
	spf=pass (imf24.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GE2ISEvWqh9sN8UYw61P33fDsnFm1/nb1kUiiX/ifUM=;
	b=grmgLAj0dAx23Gi5alg6fvXpUT3j/dy/cUOJfW9eeI79KidqrsWQ4MziOPocR2x1TL2OHX
	CFUxMW4DyHuEPYLZoL8J3UgJMnBKm2STJEFc77lWngq0r6L+ksCWD8m/Ss5hBF7jxI2YlA
	u9GmaIzeGLJ7P2GA1ec1A34+vJhH0Uc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757669865; a=rsa-sha256;
	cv=none;
	b=KA1GcCcYz16pEOt8RdtghGSNHJmgHMtK2nyFCATsXm82UPzOpJ6TpLUaaaQ4rY60BPseNm
	634k5bTDqI45ET6xUbKLzyRPP8R1llEQN9KJmxUjRw64ONke8R144BYV3zXkLQ70K0abdE
	k+U7RLodx+Kd6opmbnKhbXkuItTg8Ws=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b=jxIBuKWB;
	spf=pass (imf24.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58C9b0xv1357625
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 12 Sep 2025 02:37:00 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58C9b0xv1357625
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757669821;
	bh=GE2ISEvWqh9sN8UYw61P33fDsnFm1/nb1kUiiX/ifUM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=jxIBuKWBOuwi8Xn/pfTljgb3zhi4Bf+6TpFn4wY12CV2bo/HBYvEFlNNTSG8fPcmd
	 Jj/Tfu0GL4cwgOIGmCy3Nn+jkWh8vnC8zuP/GErTXN0RQ77TNqxFkI31NPKxEScs+g
	 3vOnPn4RJLBqsy4KnA1eIay9kM3VJsautov8wGzn+movTKqUP1FRL6RWjeOsUKd4W1
	 PzI9yWN2VGly1IKj7GF6C15ow1c72iThcEsS5Y7nUNwJIqldXBZ/Cz0CDjQetsdIXJ
	 cSf1aezna12azQgXZfQWWPOQrMR8BIbyp5qTPTfw3ynfjS2Z5IuCtNAHsMLsakvOcZ
	 RcYRHWLQ0/FWA==
Date: Fri, 12 Sep 2025 02:36:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        ksummit@lists.linux.dev
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, imx@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Richard Weinberger <richard@nod.at>,
        Lucas Stach <l.stach@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "Chester A. Unal" <chester.a.unal@arinc9.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
User-Agent: K-9 Mail for Android
In-Reply-To: <a393f6bd-ac30-4861-818c-ba0b558df4a4@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com> <363853cd-7f10-4aa9-8850-47eee6d516b9@app.fastmail.com> <a393f6bd-ac30-4861-818c-ba0b558df4a4@gaisler.com>
Message-ID: <0FEA041E-A07E-4259-AFBC-02906D122C3A@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i4c58ne7wdausgwjpponiepqxa37bkff
X-Rspam-User: 
X-Rspamd-Queue-Id: A372A180003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757669864-426351
X-HE-Meta: U2FsdGVkX1/87D7ZLHCxHak8oCNwINZDkPBIQgTyrxNZdLIdvAa4k78pwSBtNyLQ9yKhJskLqCvR8VZGDdZVmBIz1lBw6Qd4Q3vLNFbCLCH7NYEzo9AAUkPGD/JBnC2zO45v9Q513TO+Je8QTE4fxPoYLy2R2TQh5LLoUBJhMf6GvRMa0Ur2aFWe6astmwoq0iEDdnEmZs/8wmYYHmKv3gCjzFXoGj3FAQm3t5dRx0BlssXm5dOs/W3ib+qjLaJrB5aq+geCyZYSmGUTTKegRNkbENcyiWhQohpXEvzD5NoyPmIMz/R3igbAdrh45v/iv9mtZp/2Ntel4PVJYw6Xv+1h/c45SYbKQZZ9wMJgdQNtzSvSASgxDL/aRBwf0UFB6U7XP0z6m4SQzaJH0vbzIYsrydpEwvhee0P1eKhyMtruYc2pEyfPiCkCmsmMMESKb6exCk4FpEwvICFRnzr+Lk9jgNxhloyEuLxMHjBNXA9jDoipIoCOMcATV17zFAiiKdCcRW9LYUQXOUCzM0OkTy37g8TWcwaZkMaBRReozR3IWi18w679YNdOmxpUsKWpad05Xj5j1Tf8Fp7nlObl4o3j49ULq4+C8vMin2TMDSNvsyPduu0AlmW7hjWE16evkRUX4Nm/2v9qnGJJD1YgK5OpHmS/SSI+33wlYZNjGLNlvGEdNExl2kJdC3yXZjbGKZWdSlSOcktmsNW/G9pFqKmo9orghCVcm5WhrHRm+KwoCkDWgIN2cZ6MPwpdL3jpF66uAsBXGeolADyELJtDu76BzVK3fvsd0dRhF5SHUgij79r7k1uNDFKyzjqSrugZ/oafTDC/RIdNp3dSrN4zVYVUEW5uHTMVxyiXU6M5uHbLPaFaFK/eRbECZTCwgyQBUIk27Yq0ZTYcU4cWF1CD4CNMvmaOYMspXQAj17PyHbWlshKRkkS37mtimiJvmgiPpgVv9+KMnZepRojnLnA
 6guOckoK
 5np6PQIrCkDcZpYmV7ZsmuU93esoIVsDZ2P+3VXCUoxxFbeDf8g7G18dziz4sIFR/StCIbSQG8EZ6v3IU9QM05JN2K0UK3l001z7D/g6NxAlEqhPph+zZPdfhLLkLOq2925gjT4ciujWtoFKaTz1nEPiTmiWO3PjRp7lIYhByRA8nI1g1HB79iJ57A/1gS8Du+3L2MKQvsJ9JNLcfbJ+IkDapbcBADIN63N8IL8kfOxmlkPzfgo7iDCpZJjGaT14TE8bT5M4fdNg2SyU1uNAdwJABilEa5/qCCzQZy4Q596X7sWg+3CFLL55CfqlYn14k26jBsmHDxDtC0zAQgcGgZBP+G0ktNWl/FJ+AQD1cyFy3NLc+6F6VT+r2TW61SOqfKpi3WEqzzDhXLLPxd+dZT0IIoCJ+bUwt3YiV+BfbQZA3l5k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On September 12, 2025 2:32:04 AM PDT, Andreas Larsson <andreas@gaisler=2Eco=
m> wrote:
>On 2025-09-11 09:53, Arnd Bergmann wrote:
>> On Thu, Sep 11, 2025, at 07:38, Andreas Larsson wrote:
>>>
>>> We have a upcoming SoC with support for up to 16 GiB of DRAM=2E When t=
hat is
>>> used in LEON sparc32 configuration (using 36-bit physical addressing),=
 a
>>> removed CONFIG_HIGHMEM would be a considerable limitation, even after =
an
>>> introduction of different CONFIG_VMSPLIT_* options for sparc32=2E
>>=20
>> I agree that without highmem that chip is going to be unusable from Lin=
ux,
>> but I wonder if there is a chance to actually use it even with highmem,
>> for a combination of reasons:
>
>I would definitely not call it unusable in LEON sparc32 mode with
>HIGHMEM gone, but it would of course be seriously hampered memory wise
>without HIGHMEM support compared to with HIGHMEM=2E In NOEL-V 64-bit
>RISC-V mode it will of course not be affected by these matters=2E
>
>
>> - sparc32 has 36-bit addressing in the MMU, but Linux apparently never
>>   supported a 64-bit phys_addr_t here, which would be required=2E
>>   This is probably the easiest part and I assume you already have patch=
es
>>   for it=2E
>>=20
>> - As far as I can tell, the current lowmem area is 192MB, which would
>>   be ok(-ish) on a 512MB maxed-out SPARCstation, but for anything bigge=
r
>>   you likely run out of lowmem long before being able to touch the
>>   all highmem pages=2E This obviously depends a lot on the workload=2E
>>=20
>> - If you come up with patches to extend lowmem to 2GB at the expense
>>   of a lower TASK_SIZE, you're still  looking at a ration of 7:1 with
>>   14GB of highmem on the maxed-out configuration, so many workloads
>>   would still struggle to actually use that memory for page cache=2E
>
>Yes, we already have patches for 36-bit addressing with 64-bit
>phys_addr_t=2E Patches for CONFIG_VMSPLIT_* are under development=2E
>
>Even with 192 MiB lowmem we have being using up to 4 GiB without running
>into problems=2E Could you elaborate on why you think lowmem would run ou=
t
>before 14 GiB highmem in a VMSPLIT_3G or VMSPLIT_2G configuration?
>
>And even if 14 GiB highmem would be hard to get full usage out of, for a
>board with 8 GiB memory (or a configuration limiting 16 GiB down to only
>use 8 GiB or somewhere in between) the difference between getting to use
>2 GiB and 8 GiB is quite hefty=2E
>
>=20
>> - If we remove HIGHPTE (as discussed in this thread) but keep HIGHMEM,
>>   you probably still lose on the 16GB configuration=2E On 4GB configura=
tions,
>>   HIGHPTE is not really a requirement, but for workloads with many
>>   concurrent tasks using a lot of virtual address space, you would
>>   likely want to /add/ HIGHPTE support on sparc32 first=2E
>
>That is an interesting point=2E Regardless of workloads though, it still
>would be a huge difference between having or not having HIGHMEM, with or
>without HIGHPTE=2E
>
>
>> When you say "used in LEON sparc32 configuration", does that mean
>> you can also run Linux in some other confuration like an rv64
>> kernel on a NOEL-V core on that chip?
>
>Yes, boot strapping will select between sparc32 LEON and rv64 NOEL-V=2E
>
>
>> Aside from the upcoming SoC and whatever happens to that, what is
>> the largest LEON Linux memory configuration that you know is used
>> in production today and still requires kernel updates beyond ~2029?
>
>The maximum I know of for systems currently in production has the
>capacity to have up to 2 GiB memory=2E
>
>
>Cheers,
>Andreas
>
>

SPARC32 has a 4:4 address space=2E  You still use HIGHMEM?!

