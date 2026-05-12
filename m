Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0558CCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7566B0088; Tue, 12 May 2026 08:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69FBA6B008A; Tue, 12 May 2026 08:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6016B008C; Tue, 12 May 2026 08:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7C56B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:56:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B0328D073
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:56:42 +0000 (UTC)
X-FDA: 84758767044.13.57DA9A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EEAED100017
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:56:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmKf42NY;
	spf=pass (imf14.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778590600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/3Udc5nzTpFH3ZNPZ40mqdHxD5oBSqWoFzFOzQyS2M=;
	b=Y3yXRtk+zzP0RJir8AhQ35S1opVEAFyR7xNnxvhDQEhs+h45n6QY6UixIYHAE2BlOZ02N0
	D+bKxTkpKndBK/A2j0CUd4w6EYVpULIz7fGCsBrAaHlfu2bIid+2FSFHzNM3VHD9EQWY6l
	/v66ngXnsN/XAfpAFZCZYwTEwllDICA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmKf42NY;
	spf=pass (imf14.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778590600; a=rsa-sha256;
	cv=none;
	b=4N7Itdz9/ctnjlp/Wx0tHO2OthCp9AnOeHCIWGJT8PBM/irnTMlwjdOvh4azqYG+lirA2v
	Ved+58GPdknjGAluqNc8gKW5pXWy7faqBzSnGoHH8ou1kr6Lk1ctDSn8zgIwdSIZOpmyLm
	3ZtWDAl/AqMMhhEkifO7UDOpWX0om+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEF8340B86;
	Tue, 12 May 2026 12:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED8FC4AF09;
	Tue, 12 May 2026 12:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778590598;
	bh=Wh+lZzPFifVjKQxtwMnmuUW6xrspawFbZuPQ2q0YSpg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=DmKf42NY0WWRlCkkNzExpTYBmIQ9HR2Doig1JCAiM4ihoFWAuc3Y+jenpQBYH9ouN
	 CL0jpI7Lnp9A0611CRZs1ZZIT5Vghp2ksNxoDzCBv0nzMfFX7zITspw9YKuNE0TLMY
	 gk6sU3nlffh4023Q1JioJOXjMlVoSsyxtYFE9Eb7V+9U5Z/EK6yqeyD6Xnk9ydaUaA
	 yqTCM6RLXromyApfdUkRviOmb+DSeynH8dazyjF6aXYfHYeEd7p49AUIWJmTN86qNc
	 33LuNGnkfvhy2kDKUU0yPz3OVRwxECsq66+VBx7Q8JOm9vjK3uWKpu1g7z9o3ZDuwz
	 w2CfjG6Uv46IQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 83F93F4007B;
	Tue, 12 May 2026 08:56:37 -0400 (EDT)
Received: from phl-imap-14 ([10.202.2.87])
  by phl-compute-01.internal (MEProxy); Tue, 12 May 2026 08:56:37 -0400
X-ME-Sender: <xms:hSMDahjr8fBgo0X2A2B8pbiCglvSsihFvMy8aFmE9oRvch_oaIh0mg>
    <xme:hSMDag1951UAdP4pjap-AlawMUnIDjVlal4tByB7vjVGOV7cJkeYwt8-wXc4lc_JO
    RNfZDYr-iMFO9ZUB0Ip3zzKeIp63vMsMYZ5dPYKJ3MJn_WRlGxvIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvddukeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeefvdejhfelgeefffejgfeivdejvddvleevffeuffduhfeivedvudevveet
    ffejheenucffohhmrghinheprhgvlhdrrhhonecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgvrhhsohhn
    rghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppehkvghrnh
    gvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohepudejpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhshhhumhgrnhdrkhhhrghnughurg
    hlsegrrhhmrdgtohhmpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghr
    mhdrtghomhdprhgtphhtthhopehmrghrkhdrrhhuthhlrghnugesrghrmhdrtghomhdprh
    gtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphhtthhopegr
    rhgusgdoghhithesghhoohhglhgvrdgtohhmpdhrtghpthhtohepjhgrnhhnhhesghhooh
    hglhgvrdgtohhmpdhrtghpthhtoheplhhiiihprhhutghkrgesghhoohhglhgvrdgtohhm
    pdhrtghpthhtohepshgvthhhjhgvnhhkihhnshesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepuggrvhhiugeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:hSMDasgmoBdlr5QNfHwUEzI8JmBqWi4-fEZBraqA5kxJ3519fRwUDQ>
    <xmx:hSMDahX96c-lKMxhuUioA8VjgSniJeeFqXTtHKY1vCxuWJ9iBg0Gkg>
    <xmx:hSMDaltCU_8JA2q7fkHE0P2all3FAwUxdl43M7L2CMlgOMCyq8Ilqg>
    <xmx:hSMDaqbBOePMI5ZHODv8aZWZyeiCX99S5zw_gaQs9q_LHhkN8TFMAQ>
    <xmx:hSMDau4zfN_MC61dB4OvUNbnNDrGEzRZ8v3fCbfFfIis_ErU-AQ-YiyI>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5FD6EC4006E; Tue, 12 May 2026 08:56:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Tue, 12 May 2026 14:56:16 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jann Horn" <jannh@google.com>
Cc: "Ard Biesheuvel" <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 "Will Deacon" <will@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <fb5749bb-bc87-4f0b-9ec9-8a1eb7ded3b5@app.fastmail.com>
In-Reply-To: 
 <CAG48ez2xJwJDgxSH0u2G==9dOQJQxQ7WsQfU14O1H5hEWic1eA@mail.gmail.com>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
 <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
 <31252c1d-a98d-4635-ab61-ce5b649e256f@app.fastmail.com>
 <CAG48ez2xJwJDgxSH0u2G==9dOQJQxQ7WsQfU14O1H5hEWic1eA@mail.gmail.com>
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EEAED100017
X-Rspam-User: 
X-Stat-Signature: ndne8afucekjhfa6ah3c1s7ogzk5pgi7
X-HE-Tag: 1778590599-607727
X-HE-Meta: U2FsdGVkX198o/IXF3KsRCHRMwymVoT0w9EAQu/Zsz4Fzsj6ycEIzeb44CZrGp4Szc8K5wePFe0PgH318QyWmVi5UK+ymauYci7VojH24LpfLw1BrAZ3ihnE+quVyu7zgyV0Yki4QrIoTwmGS/Z8nnXoPRrE+nXDsxbGlAVM1xVjY7pgQWECQT3nx4gWRb8CRzc4lDTOS3FybRm5mIZODeFQwprUiPM1pWM/V8rlGywwGzbzyxeUEi5pBh00bfV2RjYKacubUv95YGklRjmJapiJmy+1JCkgD7rZorK2BAnF42+UM1tWJm1OH+CMIQj9qQj6rZARFUgjWJRKlVPxghIM23eCHJuw8rXPDPeAhkCpenUzFMbLJRKyBykkN4JPZuhJl/KvjWgGMMIRycR/Ibjj6xo/rz3xvvsHf1EbYPiQe/bbtAOL+qoCWsNbkonXSZBYhZiztN6ddMZ9t4ve3cW0Sw32CYeZvDr8PnKb3T+quzmKDrP1i7+Zhc3cvd5tknoBL0PWw6QY7Aw9x7ARQlp4qMvj/2P16ZdGkOwfnsNhUVnzzR/zOIFJSi/9isD3+UGxHID1aKyWt0wl/P2AgvmA0xHgN86MNPPcJvJ2nv374Dt374RTU5KNUVtIwz2CNKtfVE0IkGxtTnMo/w+TWCcZzQEo7TwoCxaV5YIA2W7PwZIWMkanVhXou5aIG+6G3zhbUKxstCuGbgoQqveMepVFr9OAR8geCYMxqj7U2Rrr0CX5affS41bDGRuWpfg+MSKjY9OmyV/F6mbAH7XA0IQHP0k77HBXbakDjqvU+3bigFWmfp7LPEd049AKuMZQLaHlFLSERbtK3BHc/P5SHcfT5iFdfh72Yo7nTsDqBXGg91dX0r8S1A+gZ8/0JVMdmXtO3EKx3bJ9k4bBVM58VFgX7dZSDCxvBRUJrAZyxWBiCQ09t1OhjH72DxhX6bWLQgyjT5OjwjMtRPo5b8h
 G5qxZq1/
 w4GAj8GiiOf5u2IRduAnN4XsSAnZ9qfLoa2zb/Ymv48QV3OaJ/57zmlE1AzZ71wNUrD+UUaIjxAJ1Fj3Ea/LDiy6nsC94y8mxNXfl2f9JEW/leuKt18KqGgIjxeLFegtGoENGIZKS4smsTzNqUTBHC0BRg7B9EB0PKwOWD3AwPaTW/CqLc9cOKK8CYz7X/JJuaSzFcPJlLIziIFvBv2ogbf5O7cluQfuLV3vp8RypP+iLWhu0+D6JQSSSg1SP9N2Ck4YbwODm5Gann4GpqRhRmgN1NO3LVrgLGe+e0NF5ZwEl7q0OjD1f2qXFfltxt4HS4dCICFtvB55qQzjg6WUaLp9MZIJw21YzdO5spGVPBfjS0cL7OWySWxR/9YEMWe6iY6QyuKZKoNwaBD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026, at 16:40, Jann Horn wrote:
> On Mon, May 11, 2026 at 10:59=E2=80=AFAM Ard Biesheuvel <ardb@kernel.o=
rg> wrote:
>> I think we should simply do something along the lines of the below,
>> considering that the size of a data object tends to correlate with
>> its minimum alignment.
>>
>> I do find it rather puzzling that the compiler emits empty_zero_page
>> *after* zero_page_pfn - ideally, we'd combine the below with
>> -fdata-sections so that the linker sees all individual objects, but
>> I suspect that would create some problems elsewhere.
>>
>>
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -452,7 +452,7 @@
>>  #define RO_AFTER_INIT_DATA                                   \
>>         . =3D ALIGN(8);                                         \
>>         __start_ro_after_init =3D .;                            \
>> -       *(.data..ro_after_init)                               \
>> +       *(SORT_BY_ALIGNMENT(.data..ro_after_init))            \
>
> Oh, neat, I didn't realize that's possible. That seems like a nicer
> approach...

Neat but rather ineffective, unfortunately. (I don't see a size
difference with the arm64 defconfig kernel)

Given that empty_zero_page only ever gets its address taken, we
might just move it into the linker script if that requires tweaking
anyway. We can just place it at the start of .rodata, which is
already page aligned on most architectures (and will become page
aligned unless EMPTY_ZERO_PAGE is #define'd by the arch linker
script to something else)


--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -472,6 +472,17 @@
 #endif
 #endif
=20
+#ifndef EMPTY_ZERO_PAGE
+#ifndef __HAVE_COLOR_ZERO_PAGE
+#define EMPTY_ZERO_PAGE                                        \
+       . =3D ALIGN(PAGE_SIZE);                                   \
+       empty_zero_page =3D .;                                    \
+       . +=3D PAGE_SIZE;
+#else
+#define EMPTY_ZERO_PAGE
+#endif
+#endif
+
 /*
  * Read only Data
  */
@@ -479,6 +490,7 @@
        . =3D ALIGN((align));                                     \
        .rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {   \
                __start_rodata =3D .;                             \
+               EMPTY_ZERO_PAGE                                 \
                *(.rodata) *(.rodata.*) *(.data.rel.ro*)        \
                SCHED_DATA                                      \


