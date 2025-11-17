Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79F1CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3216A8E001F; Mon, 17 Nov 2025 13:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D18F8E0002; Mon, 17 Nov 2025 13:43:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7F88E001F; Mon, 17 Nov 2025 13:43:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09BED8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:43:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B549812DE3A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:43:19 +0000 (UTC)
X-FDA: 84120971718.13.5CB0B1A
Received: from mail-244127.protonmail.ch (mail-244127.protonmail.ch [109.224.244.127])
	by imf02.hostedemail.com (Postfix) with ESMTP id D946C80012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:43:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=h6XWinzQ;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.127 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763404998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lJV/EDhYGKx5mOX0qR2rU2PR81YfrrZnkEYQ//hRhU=;
	b=YyFc/zM+KwfgpUePRKyE/rz+CsMI7aGMXStKqqzDIYANfxZOET5qja5FYMFUl8SnHkB11S
	CCrpTRJfoj7HHpIwitgnlQp5Hx1brxV7NnTO7XC0Z3gPPJx2KRNsOwOblSM6XzBfjXAjyi
	ZNgHFvYg73+DB3itTkKq8D7dW73xyCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763404998; a=rsa-sha256;
	cv=none;
	b=3S341xs+nliG8czDucftx7yjsH0yty6Ar3eKLKUudSY3P2k3MwrqLSIRNViwb4Ww8TBnXl
	kgw/GLkoXfFBzvFuAqxsE5uDAVevalWUu/9YkvyPRG4/23DzvOt2zqa/MuBwRjPBjpEj4n
	MWeGeLrhfZZ4oalnByMuPakeRiDhFWo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=h6XWinzQ;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.127 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763404993; x=1763664193;
	bh=+lJV/EDhYGKx5mOX0qR2rU2PR81YfrrZnkEYQ//hRhU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=h6XWinzQKp8D5CNY87Oa4RWY/kKWJKZBE6qNvqcw1rbJHPtnOUbihBOimh98MWfLV
	 2NN4ZeZ3TnoxsssymM+T8mK6KuXihwDQF3RmO7k/DBoOpCU6VI4fCVbqnfG/xF9Btx
	 sc8wYjQMFnII0JJmBK7yg/fI2XpG5HXFbHFTnnLuBLgIbNB4v7ahSkExGxDO1YwXHV
	 MqNYX+gthKlwCPgEne66RZEjKBvlPBgVqlk7zMPCy6U7hbZlGzEozZB3FDWBuJdMgK
	 l7vfSfDaAUCHBN/aQrFSRnN6Qtgy/aKM3G8OihotTxcLieiPrjGVsucbVvybrnrQl3
	 fkzFLFPT1YyiQ==
Date: Mon, 17 Nov 2025 18:43:09 +0000
To: Alexander Potapenko <glider@google.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 09/18] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <5ty6jsrleekmymktmyayidc5jdvqvzz622vsh4fqk3rjtgyalu@argn7tfm3efv>
In-Reply-To: <CAG_fn=V4jVyS41MDxJeN-A2zk6WhTnxp7m3FRWmkXMpy5f+haA@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <d6443aca65c3d36903eb9715d37811eed1931cc1.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=V4jVyS41MDxJeN-A2zk6WhTnxp7m3FRWmkXMpy5f+haA@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 267961a08d80088fa15811f1ce81d028c93e6629
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nfr81j6ab7qdgnjaiy94s6o16guueewx
X-Rspam-User: 
X-Rspamd-Queue-Id: D946C80012
X-Rspamd-Server: rspam01
X-HE-Tag: 1763404997-624754
X-HE-Meta: U2FsdGVkX1/S/GkXhvBO6l9oHoKv3Yxrg82rPIqSW0vaty6Ixx8ScRECHFqXn5bbCNTMbSxyRlmlAyuGGCX9+0EEXa5LWvYnbYUndNVkltoxDwzU8CbGN0sAUOD+M3Jojss2eqSCBLaE9s8/tW4e6lZnZWT8s2SXgFaGWexi+8NAdkKAERT2+1hNRqYyAY3Vbye2nIn9uIHX1nvQij/ta2ComshnzOc2JtQltynv+IsN0qgh/SeUm4kx1RgB0lABNutteSbzMWUBkRLe/Y1s99/imzXHkVqKaQYud+VIofrOZ7skeoHPFvxWjX+vAtbX7aDbcJnEJQCtEX1syYRS+zxevF7DJR+JwSW7yEt0qfr368sgGE7+nHmYhbX3kcDK0mClZR8UzfH8oVhw/5tM3ABTqcvSa7kfywue0KV5RutLL6Md44saLNDR3UYTc1bLEGcn5dBxnI7gscD1uWf8cdAMK8vz0eookHzAiVZUI+ZteHq7+BxBXfb9E5Oj41NMRH1HZ0pBtnpyrDbajrrOrAQ+cH0iEpcWX/fHAK9cfoxWGWhk2wCgPIs1jI3vd9XPisMtt8z2WnoUUp8C03Ihnu7HMxTQp9PeUkgDrufnC1j0t0gfivLsf0bYPtMpcNMgV4rQjXI69qwODr+Gnj/Z00j31UtoRekWbCaF60uuobqHnQFSCJfAnEzt4znOvIOhrbIG0hOU0/IsRpvLOFua9locZL2HoPCmhAo6lYB+87e8bQu7BIU5mVyEFqhOf8rOIVHt+bCOnXdGkKVibTI+SHqlLTEdgJEIUjYtFJKkPZdpkUkGjyJ2vhikPOoeCoEKEMPflg1Zczj4QUXISSMOz3eVAXrEHU7Rr75QUaIczDABJWrQACcdAAHMPUNHhFS4I+okyaM6bsGGta6nruJm9f0chd73WyzXm6LSoTFEXMOHRaMpjjeGjKsZysOQ6BYueuJ9URlslDoebn+fyR8
 rGHdQTZI
 CzuquawwPQjrWcgt+bl7RmYaRUxX/1m7sq0qkUJIQUkGHDa+mcfjQQutS3XDmCc3jDpM+MjI0Y4udCq/eBdoNqytbvO73FX93CvULt33HeGn1LH4QNYW8qgHJ7ELykS7dr58uWVh4EHH5JfxcJ7w9ioF6OwGaiIJqt1GDkU6qqXtSafrXmQ+sUyaXKd7D1Q4VURScmtSHoZYOsPjyMB0z19dDMIbiBAtkcAM56b8yAC+E2DYP8cUzOi8Q809z1R8QJvgvFjAfX3+L/K6eLqJQzHMEN8tbOdKfkoNslDL2Yka0aRV6gmHiN28SwI1PBfxyUJY0z7tORVr+9rKaGMHad8gJEpXf8aei/UiclsMZCG0EOgHzrgM/pd8dRgBTkjLMtyRDr5Wo+priRv5XiU9FXQrjBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-11 at 10:13:57 +0100, Alexander Potapenko wrote:
>On Wed, Oct 29, 2025 at 8:08=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
>> vm_reset_perms() calculates range's start and end addresses using min()
>> and max() functions. To do that it compares pointers but, with KASAN
>> software tags mode enabled, some are tagged - addr variable is, while
>> start and end variables aren't. This can cause the wrong address to be
>> chosen and result in various errors in different places.
>>
>> Reset tags in the address used as function argument in min(), max().
>>
>> execmem_cache_add() adds tagged pointers to a maple tree structure,
>> which then are incorrectly compared when walking the tree. That results
>> in different pointers being returned later and page permission violation
>> errors panicking the kernel.
>>
>> Reset tag of the address range inserted into the maple tree inside
>> execmem_vmalloc() which then gets propagated to execmem_cache_add().
>>
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>Acked-by: Alexander Potapenko <glider@google.com>
>
>> diff --git a/mm/execmem.c b/mm/execmem.c
>> index 810a4ba9c924..fd11409a6217 100644
>> --- a/mm/execmem.c
>> +++ b/mm/execmem.c
>> @@ -59,7 +59,7 @@ static void *execmem_vmalloc(struct execmem_range *ran=
ge, size_t size,
>>                 return NULL;
>>         }
>>
>> -       return p;
>> +       return kasan_reset_tag(p);
>
>I think a comment would be nice here.
>
>
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3328,7 +3328,7 @@ static void vm_reset_perms(struct vm_struct *area)
>>          * the vm_unmap_aliases() flush includes the direct map.
>>          */
>>         for (i =3D 0; i < area->nr_pages; i +=3D 1U << page_order) {
>> -               unsigned long addr =3D (unsigned long)page_address(area-=
>pages[i]);
>> +               unsigned long addr =3D (unsigned long)kasan_reset_tag(pa=
ge_address(area->pages[i]));
>
>Ditto

Thanks, will add some comments on why these are needed.


