Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613EF606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FMFE3BZD
Received: by kanga.kvack.org (Postfix)
	id 6D6226B095A; Thu, 22 Oct 2026 10:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685EF6B095C; Thu, 22 Oct 2026 10:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574F86B095D; Thu, 22 Oct 2026 10:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 290476B095A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:33:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A63D640126
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:33:39 +0000 (UTC)
X-FDA: 85350505758.28.E7D0E4B
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id B53151C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:33:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FMFE3BZD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792679617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/nVz+Qmk+Tq2vmwCZBWANvE9dUy6Fp4Dxh9VLxLk90=;
	b=bgFtujpdCs6/zPRHrt6TKMTG2P8rh27iRv3b+s5YaQEC0fxVU6miiojaXfVicQBgJTJzTb
	gTjTE9dMqYX8W5QF4hJ2rqRQ/gGlmvUzXF1yIS0ffHFj4lvd12M1yOJQn6xoSLEvBR4Nlq
	orQhX5POtHA0HDKSHoMGxJQZbgV1gxE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FMFE3BZD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792679617;
	b=AoyYVqZC6WO/BKPKZ6zWoDvYBCkhVdc5IuiFnHxM+rfuDcrEyonJzrGn1uEJn/0oKWB76h
	K3/ZZtujaHpwViAgeqEHqjl1y2LfqkDza4paL7g5ZEn1iPiVuQPXJsc8KKiEMdKCCehaN9
	fxpZ1Jfuz5KgojgfBILz87rYKUmDb/M=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-677d9c68d09so273085d50.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:33:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792679617; cv=none;
        d=google.com; s=arc-20260327;
        b=Avl6DD6ZbfrkXPJ1hz5cHbYPn4J+QIxpjYZ24ToC541D6mEL5S3ddeEkn+dyWN7e6Y
         t/H3dtpwCP2J/Soxo8bAwzugxdWQX1fYtaXvV+jpjKqeysOVXYfuMFbtLOZJWpB+VKMU
         VDKuM0lyi3lRswWuS/OVR3Mhf2CjWJ1uULnIqaKDUIDJ850uR5JZ7UWKfuhsBRDLrFsz
         kZHim5TTpzuDo9MSNYuqD5jrV3vZpORXXyrWSl6EhGaF25d/RdO1+tKoemMIP2N8ba5V
         3inkyTDuYZelIZM6B2d4UuhKA1lw05tqqjiWHdkvAlEv8HeOCXKtOQSBKxtfjrvJtlnQ
         SCyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=y/nVz+Qmk+Tq2vmwCZBWANvE9dUy6Fp4Dxh9VLxLk90=;
        fh=Y5w0C1q/yug1YgdNiScg9jqNPu6B0MGSnw2QkLMhIuY=;
        b=Tp3NUGauSDZNU1mgLY5om6kwkydYw2gfG3T0o8bO8lghmI58fUu96EKgyY0FOkQ0Wa
         dW6KYsMPh4Gu5GuHrR9XbB7O5lTzBKHN7Vwsj5GCEFlvm5FgUIroVMlXVbTVyNIaMmwU
         PRlNtqYyXyV4Tq2WKxoo+EG90fGjvhQwZD50+mm9zwVE+6n9K/n9vkCODQoG2PMyXGYg
         0BGZ84KYW9xa1eBDWX0lz6AgWv93Wui3abbdOxl+uw+lLE/PH/tdMHnIGkdCm7rwHZUS
         obLofMjhF/HRr/dHByxef44bmFQL/6qBJZdrHAy9LwPHY241uu5De0W+oEbbEGlxj3J0
         bCxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792679617; x=1793284417; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y/nVz+Qmk+Tq2vmwCZBWANvE9dUy6Fp4Dxh9VLxLk90=;
        b=FMFE3BZDtzpfye/HsZuAWwLUAD9QCtwuj7yQhchgIaAA9TfyDFlYAZjNKLitft99cv
         2n3ATOtZEmZh1fNf7OfHnFgsZArbKB+FRsEYlEB1+LrBY6DowSpwCO8fxWCbqEB97Ief
         bpR3TuGYImLWI92CyfDyiVuWJMoLNlMCu2bXD0mxSdRkR399eF/u1z6wZQbvtwasMXtx
         F2rEHLo8oxDQ0KDBZt/nTlyqY91bL+RVGO8XXd2mIcCPTHcnbaCwuszniGyAYK3HLLQj
         zjvlSZhAKz1uAwqfKKLONF82dWtL9r6WxSShj7Ne3y0MjZfm4JrhTLXMsk3Hd8tlhunx
         d1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679617; x=1793284417;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y/nVz+Qmk+Tq2vmwCZBWANvE9dUy6Fp4Dxh9VLxLk90=;
        b=Zp+l5ZstGOATUAPP+5AdaIxPHvkRdBAs5PaBA1WFGNglX2oVWB5l9vKOR/LUXNfRNB
         jkMXSnxfkwLaMp4ib9jG0mrw5qv/UMQQF4edzswmEVbE5lwfaoOJtbumI8Gkfz5quNOj
         +AxofDRR/BqZs8EC4RA+ZZpqel0CrQpCKa6WAcwQCdPBCbyNJsnI6wmZCadH0hQ7XBBs
         fkJPwRWe8SpsdAjLDiq+pPtW4OT/vKZ5y58/9HnRlJJw+1RmL0ASd1LkeF+9mzOoLYVw
         Np2vDVCqKMycOLNAQFwQI9ldqfyAV/GvczYfMHeND74o1IefIXkXhM1CS8gQquPnkyC6
         +S7g==
X-Forwarded-Encrypted: i=1; AKwUvBwBrnlRnS/bgDH45dwGjtvx+MqF3t23aEMISI0L/jXCgjECD9/Ei/weNMkQKU4st/K3kPTk9K8tzw==@kvack.org
X-Gm-Message-State: AFq9FYKGs1D4GQyev7lPqMZKAdnZXo6RVcxQ8PXBLyihtFE8z+gSUBLc
	bWPzG7+6jl36JUt3cQWm9cp/ZjMh48RS4cN7NrRNiOzwS8mjbvQAxLEgXSxgs9GJLpNTPcOz9im
	C5MavTQMHg984g4+kIhhlDM+UXcIOAKc=
X-Gm-Gg: AYBFou2roTrkG+y87wqs2MdUULigI8o0L9NpRKl2/UGJ/00A4kW7FAwCVaU8kxBI0pD
	85lJ9Wv+0qysUQp+WbttRo0PFmb8W3oxyy+yhVQXbLgLz1OKEKt71/GktLUIO5SZ4CmSZVGJ30r
	6+cB5jd707/AuY8rN7zA2skyKnHi92tngx2R/10V0sLAias47TwlrJJkohgyqZMnUUznMg3cW43
	7cMGykVh00tRsoumAsPsdAe43f8CD64fpgBbUriyEQWFuMuo5MyPasZuAdp3YUNNl7kUillEJO+
	8r4Enfo5pjjvu8mK1MXZLP+a3C1y84D4wBM958UU6isSppQg9fwQ6vJbgh93wJzH+VIfoTYQDpF
	zTXeGYp2oD/NB0FT1ta0SbqrNhxkAYtMZ46Y=
X-Received: by 2002:a05:690e:4504:20b0:679:9e25:316c with SMTP id
 956f58d0204a3-67a0e4f7118mr3858513d50.5.1792679616649; Thu, 22 Oct 2026
 07:33:36 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 22 Oct 2026 07:33:35 -0700
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 22 Oct 2026 07:33:35 -0700
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261022021820.1789083-1-odys.yuan@gmail.com>
References: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
 <20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477@gmail.com>
 <CAPAsAGyrH1quaLuyui6Qm5sokid8=yjNbAM3cOunynfPNQtfgg@mail.gmail.com> <20261022021820.1789083-1-odys.yuan@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 22 Oct 2026 07:33:35 -0700
X-Gm-Features: AclHuK9KZnLcDmcb3UzjebEw_JXnOgl4qhgoWZHIOId6L7KU5VJDln5TqsxLBMU
Message-ID: <CAPAsAGyA=WG=z6a==N3O6oan6WVmZS-VrxEA7SrxRQs5d+Dsfg@mail.gmail.com>
Subject: Re: [PATCH 1/2] word-at-a-time: check the first byte in load_unaligned_zeropad()
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Marco Elver <elver@google.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, Peter Collingbourne <peter@pcc.me.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B53151C0009
X-Stat-Signature: fq8apemow7u4fw9qz59n5teiahmqpk8y
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792679617-957300
X-HE-Meta: U2FsdGVkX19B+tBktxaawb7pHVYVe5hfdyXicK8sCJ/WRIpopPrQZq/mmwdkrLhkag0msyoDosOYp1x18tYlYJi+rw6zSeEJJ3e3Zas5iANZG1lWMVwDiwHtZz91ThRkAnz53PBgocBdxlRcGc3fD++mTgBVtL3cGarjEPZK6UgdNjAp/OHiZWWPcMeeFX/yzgMG04TDsRDPanjMlahqQ2xWEgcndJW509Jk3sHxytQu1Bw1MmsA+d8YpTypctqEnEUt8hDeaTcP2OZIxw//O7CJWmBev+/CaQQ6nnDMhG8P/6FQ10qzkmY+fRkqDk07g5hOTUmAugqpKFeUvjK2sU6EX4cHSeM1opeCEnL5Bvw59u9Cytk6Cx2LYDeUXPxIKCOuc92zpa985AyHRQs2/RA9f68kbQSZKpUPiENofvIm9B00TxShp7cSB0C+KQLmAg6v98pIs1taJXFEB7jdwlFnrSnpOGevTzpaWDDpESImOyLa6HTyGuEEnXLSZjAbCw25vWi69GktWxUYUcOLI4OuoAa5g8o7CUnYuEAMZF+SGWm73rdT8b0KUKRHuyBGVttET5E2sR9WLODR1aMLvbWLCL5Za+3UdDqFzMDhhSSL7IdJHzec+tlCMs/bDLhNhkjLSXACOEBn9RtkAjie9icvOjPtmngIYwjsIhhCMU7Hl9L956egA5L7kTXzQy/rcfwAOOB5u8Up+gcqfQ7hHeW4swXqvU0oMGd/9nCRsG/CcYV9oI7kaq2qQ5tIsUxHZ4OFZ9DvUQsPzVw98Cm/vncwTSypc21pfKJEeT0jDeCvUj8dH3XqHj4m+FnmYw5vTScRT4o1Zmb9wuL3Vbg5ICILcDV4QJ/+2TZQFGcPOEth7mGogFXYmsLbWxQ18yhnt83gTh6u/7ZmyAaqZXsDwfmDAa3joByyuMKh9VIFTwtDGr41RI22tiEnWCLvf1NJh/le7t9fA8/IkBjHGEE
 9xF+22xo
 +AZck9AAMolnUz3FWVkF4RTETOJMQwGmOWeCmMLrmDIhwdfak4K57ib8QQwlWyuQCa+15m25gDz4mEnnzih/Hd4edZGcrc5Jf9EtN6JUUz0JB6UP8cBF7GEvDDRGDW7uqXbAgYygTmmyJ5fXBVKR5nFYyLbRFXY7D9aWJ6JLIuQD1WTpw+GiYNiO8kFTRRGRqs2Zkfd+hBQZ9sAOhrWMqJNh+r3pnfYj75zy7GXw8IayFjeSuac/x9r+5YsYNHMo3Uv0vltsCtRfzvXEOj9oP7DSdoYxexJH/BtMdMATL4sGoM/+ByXJ/1MYKHXJms42pwwcEsscoV9Y4tKmMYnoAAGl9eRtBbO2mcwWzRiuXAfbHRhGGmg0j0Xit0ygb/0Wyu8PE56exZKEz1pflCBLq6mT9tOjWrNHgNbM1IXJ1GEz1i/anxh4LYXtQWqLMARxahXeI9v5ePboNPm+ouVRR3L23BUJHzDMLuGVdmNby1nuXUYFl8EseBr5LbHbcWboR29BDXbRZ8ifYMbxbQw4C6D5L8DU/Rf3E3+DA8/4ZEMvMxWCAWqmgU4+PQtukEjdbRkJJ9n4e66zjZcPA1UmkwVhHPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Qiliang Yuan <odys.yuan@gmail.com> writes:

> On Tue, 20 Oct 2026 12:58:54 -0400, Andrey Ryabinin wrote:
>>> +	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
>>
>> Why it's open-coded ?
>
> For the same reason as read_word_at_a_time(): commit ece69af2ede1
> ("rwonce: handle KCSAN like KASAN in read_word_at_a_time()") open-coded
> it "to avoid having to pull the entire instrumented.h header into
> rwonce.h". I kept the six asm/word-at-a-time.h headers to the same two
> small headers, kasan-checks.h and kcsan-checks.h, rather than pulling in
> instrumented.h with linux/bug.h and kmsan-checks.h.
>

That concern is specific to rwonce.h being included from very low-level header
like compiler.h It doesn't cary over to word-at-a-time.h

> Thanks,
> Qiliang

