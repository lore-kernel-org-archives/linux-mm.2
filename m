Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857F2CED624
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969876B0098; Tue, 18 Nov 2025 06:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919E66B00B3; Tue, 18 Nov 2025 06:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1946B00B4; Tue, 18 Nov 2025 06:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA9F6B0098
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:48:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 207724DD05
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:48:30 +0000 (UTC)
X-FDA: 84123555180.21.F26CB25
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id 29E6420017
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:48:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=gQzkmSZT;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763466508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6/kLrRa2f455JqtRCfVFIsy+tm9Wn1NEx703c9jG7s=;
	b=vbWUnncDzRf8dG91eOvQ388gR+Rv/qYS4Mc1+leOMmrLNOUEMGhfJS59jg2bl2l4Qo0Xi1
	3x0xSQ1OGQG3tA6yIRLAP1tqmpsZf/ia8FeBoF5smUu8P4dbIdRqPIZnhCCtnUX5mkFibb
	A/lLyi0q0Z18liDGQgWqAWBzMKWtsfk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=gQzkmSZT;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763466508; a=rsa-sha256;
	cv=none;
	b=jJbT6gRQkyuCkZQJIXJS2LifGwljMLo1tcN4NnkCxijOS3w20TCZGhYv74cmjQq3RKFfnh
	Lj0b728iqKz0hmW/CiS6/JL3ZBWPMYX+iO45B+7Vii07Zd0AQ/mkNXcNrLQhXN0Hposl6p
	FfpuuGT5t3mkcCv0fFviF2oyaot4yx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763466504; x=1763725704;
	bh=n6/kLrRa2f455JqtRCfVFIsy+tm9Wn1NEx703c9jG7s=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=gQzkmSZTz46BncYFEP31UJ2/MYDxNGPsZbGhkfP7QuAKwi8wAXU1m+gFTGDBW1nrl
	 DTIv0nmFW1CACxQKrZae+ZvUHuHfe5FxxKl0oXPpOtJU3maELH1R29VkX/LuutU5nv
	 ArErm4j3DOfExn1nu5YKzs9Ng0eGJwxyVAyUfhOgGSkXSBgvWp5DOqTgp/lCk4cTAB
	 m7m0PWLxZH8Q2d3dvbLUErergde1da/CWqSwtOMbZa60ZnJJAoYOM2MaYOyEYk83Rr
	 l1+di0PmSIdW9qsulupjbKBkIDAf/OUoGZfR7ZSfuMhQdLGdsL22Mj9dXyw6gTBrkl
	 MYdo+Scv2CK2A==
Date: Tue, 18 Nov 2025 11:48:19 +0000
To: Alexander Potapenko <glider@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 18/18] x86/kasan: Make software tag-based kasan available
Message-ID: <bpyudbe6kvzlj37j7c6zo33zxfc537gos3fn5cbr32yz7ebu23@oeaxjofxyeao>
In-Reply-To: <CAG_fn=WPQZ4ti3Lb+A3jSXFWLtn6291sTKJBwKBiLD2E9YbuKA@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <d98f04754c3f37f153493c13966c1e02852f551d.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=WPQZ4ti3Lb+A3jSXFWLtn6291sTKJBwKBiLD2E9YbuKA@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 1f509888f40154949953d5f9b6464c2363ca1311
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 29E6420017
X-Stat-Signature: fpd9nrj6mf6weagw8qu7i5fpci1t5ayh
X-Rspam-User: 
X-HE-Tag: 1763466507-679113
X-HE-Meta: U2FsdGVkX189btSw+NIjsNhtuhZw+aMA1KSgd+0sxJKo7ViElXLg0EbP9XicG3mt2afEUQwqytYelGzA43MpaniIdj17XzN9nZU//RA6UFEQkZndNwNpM9JS1A23DEC7gydpX6wy+xU0Bn43DE/RVyo8RE5wggUvZlRkGChkTCuDH+0sSF2GRjojQfICv5nu8+zkRQvewjrejbyDLNo6ZcJ5h6+ykZUC+ZuMECYI8cgxRF4t19G/SkFPAU+Ka+mnTTv5tgwmiCAzkA24cHBUffSDVxkUlvDrucXnYnNgYNJfyGJuC7bpakZ60BE0MPmAkfyw+29mT/VaJCLS6eOnOSNuj8HrtWeKnq0HMzKDKQn7nwPNi6GXpfyh6+J135H/fb7myEv/5No6LQEttbIzAyw7t5LgaWsTW4neI2f5uVkWyjf4mV32qmg1Cmk0Abu4vag9eefbRpPI9PeL2raq1r4BiwX/r5E7O5MCRKtAHaGQchcLMwpUSNDF8eZnfFpX6EZaNaKUxN/++gVJEkXnTpnug/kMizzUleMJbAIq9WeQutRzNYJeVt9Q5vdXoSoBm+fDZP9SsOKEl/1vzNKhy/5N3ycofyqyBRtWrCepo6RVq3SIhecZLdRP8qSIDN7ihv2qXhldDobQcOYIo/A2ZXsKQGs/oyYmKv5lEOnFinMtVn/0QRD5gMXCZc09mUqyd0p7hj/Y1sMoha392AaCL0VioQKL1ClQKFQFWATIhnmtcA5K7ZFJLUfmVNqCGC2f1Dhk6XbFdQw1uRe8W9nWbVqfzHyT7jbbObKCDgUpQUfXSy0hldTvU03tXrR4UJJGzq5cc7nlErb5A8oaHhSL+3IKENPGSE0oRdr+dpV3z3VzOy8edc9GsEUkGqWX2NFORCktSw3zY8FDW2mzXmbBCkJ6skiGkqOe2xK4mxcfiw0MyldtbQRVgUPsvfioTKuqNLbl0Vtjkx4HSTfRSAf
 +uIPZUXh
 pIWwyz5yngHUo88wuHi1RytSW5r8P8DyQqHaUhfsx+vduzbQ3H/uIEN7C0WXrbfFXVHY8gyaVFMWsbMccTKJTSE7tbPLKS1KCbpy0a2V5pYhnLSPoqH8u7gqDwpwiBOdhyi6ssKIwX3nSCIdpGXLHMfumZzFtDZSpkkNxlaDFj/xEZ4vw4YvtR2CnlNEcXvwQFkIiaR+mTQV6NDYLlU2XQBxzw56EKsPTDt7LSJSqwncj6gcHXx1i+oK6KAwlPSSqDt72YpMKYHFuB39vTwrjpB62NIdidoJoABJl4z7D+IaGDsNzcs9CKt57GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-11 at 10:00:59 +0100, Alexander Potapenko wrote:
>On Wed, Oct 29, 2025 at 9:11=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>
>> -   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN s=
hadow memory
>> +   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN s=
hadow memory (generic mode)
>> +   fffff40000000000 |   -8    TB | fffffbffffffffff |    8 TB | KASAN s=
hadow memory (software tag-based mode)
>>    __________________|____________|__________________|_________|________=
____________________________________________________
>
>
>> +   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN s=
hadow memory (generic mode)
>> +   ffeffc0000000000 |   -6    PB | fffffbffffffffff |    4 PB | KASAN s=
hadow memory (software tag-based mode)
>>    __________________|____________|__________________|_________|________=
____________________________________________________
>
>> +       default 0xeffffc0000000000 if KASAN_SW_TAGS
>>         default 0xdffffc0000000000
>
>Please elaborate in the patch description how these values were picked.

Sure, will do :)


