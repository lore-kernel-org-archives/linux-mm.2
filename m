Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D88DCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461828E0022; Mon, 17 Nov 2025 12:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411AC8E0002; Mon, 17 Nov 2025 12:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301388E0022; Mon, 17 Nov 2025 12:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13E258E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:51:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA8124C94B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:51:27 +0000 (UTC)
X-FDA: 84120841014.29.B2610BA
Received: from mail-43189.protonmail.ch (mail-43189.protonmail.ch [185.70.43.189])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1303C4000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:51:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=oQBqUjSf;
	spf=pass (imf07.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.189 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JHRGFc+rtU8gXb3Jyiztx9jQrUCtKtMFdopnkmvtTw=;
	b=lCM1f4UKntt1Dh92GlTFVGJxMvtocgFc+vKVJeAr5PXOiz8hbjbhRPBtka4x2bWlgBf0Uu
	Ku2KBrBIitFeZ0j9ZEf1NGL+MJWYDpC0KWB2uIXBTOb2GVR1RWnWI6mhirJgxQrQ21QpiS
	MovMGw2zqLPJQtzuYu4QKwWfbKAYvpw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=oQBqUjSf;
	spf=pass (imf07.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.189 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401886; a=rsa-sha256;
	cv=none;
	b=f8/V0o1X1rLt2klZr52K49w/Apy6t/4ss7Ks/3y8kwzGxA1gatrwKz2Is5nEQRa6B90Cu7
	wDEgvhTcvfCOb6Ymz4EFeZXIdgsI0Morx1HgxeL7N7JCeBNSwfX+3umFB3hzeqn4l4x1rF
	X4quPOhqzRWZ/A/DR/yBcCAZ9ahRdYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763401880; x=1763661080;
	bh=8JHRGFc+rtU8gXb3Jyiztx9jQrUCtKtMFdopnkmvtTw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=oQBqUjSfF7G2kJQrbbupyMiiL3urxY+IOjodFvyRKJ7BeHY/Dcl/doiaaDctJYfkJ
	 neWOwaOGLUAaNvOOA9Lnkn/V7Zxs46ZLspzWPnHWqsqxS/d+3JQ28pmHZyaP3ROCiP
	 lPORmcpqbEa/NLboQDALyeNMJy7OAFr681dFCiyvFWO465XYCDffdIMULNoQdGBZG5
	 LqsCEq8v1qizeghermjOZkDdSKpmudU0KEGcYzC75rPAJEG8nR1gQFIh5UjtYTVp5L
	 Abt+RNltqCl/40foE++yjpzIs3zTJ+mCRrvbsrD50yTsJZVBuZlmevHhrdCKoaSwyO
	 yZDKI/Aa1I0hg==
Date: Mon, 17 Nov 2025 17:51:13 +0000
To: Alexander Potapenko <glider@google.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, stable@vger.kernel.org, Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v6 01/18] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <ha5gz3hfjtfrmldzbscrbbtptecyqkwzkwdkjxnc2puqzquurl@nthv7frvqatw>
In-Reply-To: <CAG_fn=Wj9rB0jHKT3QKjZsPYce1JFcb1e72QBOBP52Ybs3_qgQ@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <fbce40a59b0a22a5735cb6e9b95c5a45a34b23cb.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=Wj9rB0jHKT3QKjZsPYce1JFcb1e72QBOBP52Ybs3_qgQ@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 7b84ae9accb4bc7551e617e5e7661cf28649358a
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1303C4000D
X-Stat-Signature: qmcfog8kgw59i4f9cceedm6r3qn6cgk9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763401885-671033
X-HE-Meta: U2FsdGVkX18WrE4ZOb7vAsdja71rtAMdz/5ySRxTZrhbHZWPxchlK65tiusoOwI4t3HeouhPGd7xJhyNthsD48vHAEcBlNtra1oMDrOjkrTvjrr3UxCa+Y5VWRUQB/EjcPC9x79X9NJwt8mKlkTzKYiw6ghbjy8IVYjFTkHrmuwlRnw9yB+9PhJP5hlmJLtrTbMfNQwgnLkNwiRX54lL//gU6W7uWiQaN6MWJ3RRDZuwfEMIC0Bma6Y3/HF+WXOR4qe3UKjqojoczv77f57RM41KcSZfZJHV98mJxEDH8XVvOUfgxIiBZV4oTJ/vbGFF8TeBXNg2AxGtRRfuqV3LURZbrfXdSNlygLogRytKWqgnE6NgvNh1WC0LM/tNhqmhnmdTMVLMYtO/Aqz4smgprc7ab+bVl5OWbssXyIoYM9dJx+LL8cIr9DwsduSN7XmJypSXwFibqsWB4VIRKVKAh+BCBUeUwEWdqDlgmJBlG+DoQ83A3A1cJHQ6xl2pXJhTkgTPz5zikygy4s2WPHvzzIL7mXcq3k4Cy/I4yFJq0vhQUeIi5Wu+yGorzzEh5zD+IUQR7vy21b6qb8TtD0dIuEw8ymyGupvy3HRNcnBMiOwQQV/3HbaQOx9vRH3UkBKD5RuBBJLG3XWacUbn9zywH/RBg1JUbooPfS2EZUO0bmY+CA+bCiFZ9q4xC95hbTlz+d3xxn+jn15c+5GMbaF5/0s4lyscHrgOogb0dlV/ky6osmLA7gIdoP8AkRL7+xRTWRpAZpqgTpnFB/4Lz0d0Kc1BA5Svc7S8kErMFGoU5Mr0YHSs+Wp7wW0GiFX4LIGg8yxJKq4ZLII/2X6hr2a3Ez2NKcQpDjeEBAkaggevFf9QCLLKbidBw6tIuIBfal+7apmb3BK9TEU7+/Ato1EQVh5gXyS4c5/c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-10 at 18:32:21 +0100, Alexander Potapenko wrote:
>On Wed, Oct 29, 2025 at 8:05=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> The problem presented here is related to NUMA systems and tag-based
>> KASAN modes - software and hardware ones. It can be explained in the
>> following points:
>>
>>         1. There can be more than one virtual memory chunk.
>>         2. Chunk's base address has a tag.
>>         3. The base address points at the first chunk and thus inherits
>>            the tag of the first chunk.
>>         4. The subsequent chunks will be accessed with the tag from the
>>            first chunk.
>>         5. Thus, the subsequent chunks need to have their tag set to
>>            match that of the first chunk.
>>
>> Refactor code by moving it into a helper in preparation for the actual
>> fix.
>
>The code in the helper function:
>
>> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>> +{
>> +       int area;
>> +
>> +       for (area =3D 0 ; area < nr_vms ; area++) {
>> +               kasan_poison(vms[area]->addr, vms[area]->size,
>> +                            arch_kasan_get_tag(vms[area]->addr), false)=
;
>> +       }
>> +}
>
>is different from what was originally called:
>
>> -       for (area =3D 0; area < nr_vms; area++)
>> -               vms[area]->addr =3D kasan_unpoison_vmalloc(vms[area]->ad=
dr,
>> -                               vms[area]->size, KASAN_VMALLOC_PROT_NORM=
AL);
>> +       kasan_unpoison_vmap_areas(vms, nr_vms);
>
>, so the patch description is a bit misleading.
>
>Please also ensure you fix the errors reported by kbuild test robot.

Thanks for looking at the series! Yes, I'll fix these two patches, I've
split them off into a separate 'fixes' series and I'm trying to make
sure it's an acutal refactor this time.


