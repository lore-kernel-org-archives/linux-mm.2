Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB51BCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907646B008C; Thu, 18 Jun 2026 12:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8D76B0092; Thu, 18 Jun 2026 12:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8B16B0093; Thu, 18 Jun 2026 12:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 454B86B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:55:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 960EC12014F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:55:57 +0000 (UTC)
X-FDA: 84893635554.28.695B676
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BA341A000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:55:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wao3aykZ;
	spf=pass (imf19.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781801755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWncoALx8y7YAXsHTWY7bN7qmkvqPbp54N8U5jbHY04=;
	b=2nkrYE4wDOKlG0H1bYYQgj070xS93K9ZmOSCv8471sPRZQ+WiPqCovWscMD5t+4WRtidp4
	TDRwLBYb+M1VscurWbAxOF44Vmg7A+4sdwnnDRNldwYlP466rO7ZBuzzljPB4ZWWgK5ELC
	5KpIc41b5H80m0gFU8z6zVF0Q4T8iNM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wao3aykZ;
	spf=pass (imf19.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781801755;
	b=Bkz7JhcT1Fi06dSMV7eUBYgflXr61cm+O8nlDrnouinPT8yf+CoZllagwCbBUTj+vplZrL
	gMDRr7iQ2sN+Gw++2tvDQzvVG5UyU2Gnti2sGh7ILYPqUzEKN2RzveOH12ZkzAmaxr2X/L
	Qy7tLlWkbrzzAN5d+edi1ISkfiWxqzs=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7e255c15ffcso1647947b3.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:55:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781801754; cv=none;
        d=google.com; s=arc-20240605;
        b=En8sSwQeuCcrktateInix2yvUqwTIe3pI3ixl12Suaf6CkcmDTHKxbGGKLI45VXeG2
         CKGU7srtLNMVWmVSHxQssO6KvcdR5xmsk5yRXhuHFMdqK4fdhcOdRofEjhWMUqkuKdQO
         TO57WUnvAeUdi9ROZHNsRlLx7ratrwncBIZmeuPRWu1Xge+WScdZJLV20VOYTplOduiu
         CrS7CfcGSlvR8IFKZDJy1lbdATTGEUHLxRcaOE3jMYz69sju7CH+YGD3kOkt4QWLAms0
         zQ8P1smdyu61ULa1p9NSY3eByqnLHmcNrHUC74Z++DW+PHwsdOya444SIj84A8sg6dAp
         wTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=bWncoALx8y7YAXsHTWY7bN7qmkvqPbp54N8U5jbHY04=;
        fh=xggoFpEJA1tOu8jZvwSfSXq19HwHDh2xrP7//ARiu8s=;
        b=RhqW0FYFAOnCZ6ZrDcx4EPnz4ElzkzNHr48dbnAxMIidEQEjqwLuLzIDYvi85nr5TO
         HGlhX3D+lCartqbbUC/Mk6sTUSDSns/3oZmVp+z4+JjDYiR3FAJlVIsQmBlRoFDnQiNc
         8POru9t8wrS1vB6tzlmu4AdZXnX6TyrXAdcYScQ5skGcdULoheWiV6/2oy7ToSd87JXu
         G9ZI+ozDVvTESxwEEqSJ3kPMmr3xaahV827EAl1cI8pYvU2tESbsKUXjRj3pwdPhchpq
         VoBKV7aSg+0n9XOC2/AvsdVXx6+ArIMQb3UAeYLY5anubH+wB6KvY5/5Ny5Z0EI1LjUp
         zJDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781801754; x=1782406554; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bWncoALx8y7YAXsHTWY7bN7qmkvqPbp54N8U5jbHY04=;
        b=Wao3aykZun994nQ/uDhoaOa9fOsDrVeG2HTW3mCf96O9yzMqO6hCajCpXUETe3trsy
         Bmo5jBzW/qcVf+UNv2WKzP4VJaUVchGOeigknkj8aWEfsWvChcUsVsNc1cPiOEzdEjMo
         XXUne8ZtOtKQj88S5ak1uTRetZn7lYrXZJq9hb11EbJYTiSozFiuKZXn7HkX0WXhpqwO
         O6VkRxylDE12xmSFRqVZsnG4kgKMunjWqXVG2xAdfnjjekrvbIv8RtbO21q4cX/0OsK1
         nRDpboIrftyZZkzlpT9ORZWNaQu0yCRdoOruWVbC/S2QP0CY+94FAfObhWE9dGqFeaGs
         kt9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781801754; x=1782406554;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bWncoALx8y7YAXsHTWY7bN7qmkvqPbp54N8U5jbHY04=;
        b=CPcsvq8gA/MQzv/JbgXX9zRtfDArPFEt8lUH5DqbxXkydRexMNtBdZLGAvQcFHceQB
         ZgsNMweZTdP4DDdnN2yQBD5hJMN8RUCpV80FHWk8EQNFmKBHrIQlPkJWAzupIcBCHO2k
         whqu4svyLHcMyoDZ80Arax3eenF8mpIcbCNOt5eVO0AXP7u6jW0iF6U2DX4DvoAGpU3Y
         4Z/AALtzpXDkLTM4IN8w56HTO2Ii5BxBQAtoO90OEBedvAUrHQErQC1z1pwgXfD5Zx4M
         khkIN+GbCDQdRxZwAJAKvdW4VuzvyQwkqAklWORsMc2NXXL304QAJCzRnBrM9XL7is20
         cF7g==
X-Forwarded-Encrypted: i=1; AFNElJ+ArdIe9AeiqJYgGSHv5T7mOVCaVdYtEvWEnYAqhXNStT13rHa2yBOzhObx8hgfO47za83G8jY6jQ==@kvack.org
X-Gm-Message-State: AOJu0YxPxUARkkIGXGkmXGo4IpuFGnI5kuqxkGo6cub7veHDhdTLfn25
	RJlI6PC5a6UaqFgHmOTwAqw4LMjaZl2mk/wNrwrD9Als9WysZYEHEnyhVo4uNJmpkwDlwkwT/mF
	0JPF/HXsOqEN4ofy2P118fiA1iRlnLvA=
X-Gm-Gg: AfdE7ckeM2HM+LKWGfbkNUgpeK8lP1MLIun1FzlkB3LhzqeC3ihKPRmKgPrjIFbsdH+
	z79ufd4RJrpF60IMBEPMjRFHLneEhcFzzoFyX1stW/PqqkQFF4efeIpo/L7bgnxbZeQEe4y+hai
	R9cGKynpLeK/4wj3M49Qze03os9LZrPu3ODdHsGCGHq+JtB8wnfiSCfs7yHut6s3975dMwkP0Ie
	H3AraaMsiOL1gHVpASC1ASXAXQFnl6SQqZ1x2J2jGQdujDIJLrwf+Lehvur7uC8fDvUI+0=
X-Received: by 2002:a05:690c:d:b0:7b6:40ef:6fb6 with SMTP id
 00721157ae682-7ffc7ea1c61mr30001467b3.6.1781801754498; Thu, 18 Jun 2026
 09:55:54 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 18 Jun 2026 11:55:51 -0500
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 18 Jun 2026 11:55:51 -0500
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev> <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
MIME-Version: 1.0
Date: Thu, 18 Jun 2026 11:55:51 -0500
X-Gm-Features: AVVi8Cd8zcauPYY70qCYHcPTSLhz0VbjxmEcRhSzqIS7BkkbKJS50phWPBzrVPY
Message-ID: <CAPAsAGxSu4JmiiXsXMebcH3dKTD89ksYUL_BtduHffgKbnwEAg@mail.gmail.com>
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: bpf@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrey Konovalov <andreyknvl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8BA341A000B
X-Rspam-User: 
X-Stat-Signature: ff39pos91tnmdm8j3w4it1e1aqptoepw
X-HE-Tag: 1781801755-630941
X-HE-Meta: U2FsdGVkX19RIYfvk81dklam+6dG+qcqIVJ3xBLNp8yEKRafu04EGKzSzrL8a52neUqS1uxq7VGPQXwqRR7B+ZQmWxqJftss5yuwFGrRqKhG62GWxJj8QyqW8gIyf17RrQ5oiPNBDtkiy9n+ZvbgSoXGix652Ohh5gBvNzyHMnAqwtKpkPAW+oDy9SKENFWyx3+ArUtQZv4Th6ES5wwTM9fMl+Y/N1nd89aFZUqBIn7M9LeCe3F+XYkvz86wI3uRsx93G/3wP+ZS1YdADg85re1MHq0gAjLGcQgVWS8rTdE48JhbajY1sjqNK0++aE/vyeKLRMcY5046tw6hkdfV7kHqi+VXdll7sSYl+Ls/iK0npYepIyF14nPkPggc6oAIAMdHZM9/gtN3R81NSWM0IyNPYwS2tKPUwSeGT5B4rcJwS26dTgbTz183zUsYFi0jDJvQCB2kzpHKtvE9YMGIqP0wwUoe4VOU246XdRRaqC+ZrygiR7W7tvY5EhBzYAT+AUafBOjBkWdWE5D2GspWOQr2ISKPCaNTATAj+FvaDuuRvrD9+nFHWhkzdqUEu1akH8f0SHbWEA3AEn83Z2PyUshU+xLmVy1mKpxE3aRXfD4YQiYtfNbim4YX/vkkCed6Xj3ML18rbJRDAEtqP3HTy4EQqnmDsTYvt6P0VTX2HY5sgWNKdJpXyFXa6G48a7uF5EEXJCErm5dMUy+9orF1DOtzjKZxRzv/rarWrWVh4XyrtkkJsMwZ5SKRPwz3NAnQ8Z3FJJHKX8Jw8j8IMHCmefBEVJGGsVPo8hDxHYepME6ABEuLKNtZ4ZtaW4PEXrxNVUE+18+1lY1verdv0L7PXZBLv+tvKII39DpVTaZaJQqHOIWsx6KqyVAKmMI9GlOjNjFXtXkvSmqzXzyDnmIbllMafDG/WDxOkBmbnnfVdLuUZhy2lFuPT2jqzkLACjF5GntdwdHatGojdjAlj8O
 yYgVKRZ4
 suOFhrbRzhXvCcD4Fs7RJO/CTg4TUvANiUHQPSQZO9+KrvJeJhg6Gjyvm7ngzSCEjoLe5lP7VLQ+8iH7/GjOvRFnnMP6vsW+vKDSU3PR4iTlFeCP9rr0XYXGaouYio4hMvF3qSKguQKC5cCFvv6ktHA5v2OBZpmSHvGFxSN0YeJtHH10L1MORKh2ir7t2sm+KIuZY2iwmedOg+mvucOYrj57KC8PmUl1RNTGfsxumD4iPVAY7vCXRqpa2J00WVLTI0wqOhOEMloJ3qCFT0c7kxckB9d3JcjJnVVnYKJCDeijZ03CLNZizxpcv0XKClmqBf2B0L0Y6gprEqPxCYiZeCkHOlkXR/FjH9x//VHIQCk1G/skAF6O6jmygmF76+mAY/et4iFhiTxgE8RxnsWWJY0t2fOuyQxMCn2leTKzI9vQ9jc6Li/QOu5dOobUfHpyn/3KhTRsiaznXWV0OC1M0CdrzCcBpGOgrmsDpPtYOwKy0Ou597a0/xN25P9GTWCdjAfj0V4KzTdYLzhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ihor Solodrai <ihor.solodrai@linux.dev> writes:

> On 6/10/26 10:56 AM, Ihor Solodrai wrote:
>>
>>  [...]
>>
>> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
>> index 2b8e73f5f6a7..b5f430f2dbb6 100644
>> --- a/mm/kasan/generic.c
>> +++ b/mm/kasan/generic.c
>> @@ -9,6 +9,13 @@
>>   *        Andrey Konovalov <andreyknvl@gmail.com>
>>   */
>>
>> +/*
>> + * check_region_inline() and addr_has_metadata() can run very early.
>> + * For example, in an interrupt taken while identify_cpu() has the CPU
>> + * capability bits temporarily cleared.
>> + */
>> +#define USE_EARLY_PGTABLE_L5
>
> Hi everyone.
>
> Bumping the thread, as it's not clear how to proceed.
>
> From the discussion, we've got three approached to the bugfix:
>
>   1. USE_EARLY_PGTABLE_L5 in generic KASAN
>
>   This one is probably the simplest. We add USE_EARLY_PGTABLE_L5 to the
>   files that call addr_has_metadata(). It's KASAN / LA57 specific.
>
>   The downsides are a performance hit pointed out by Kiryl, and that
>   it's an arch-specific switch in generic KASAN.
>
>   2. local_irq_save/restore in identify_cpu() - Kiryl's suggestion
>
>   This looks like a better fix addressing the actual problem of cleared
>   capabilities being accessed from interrupts.
>
>   An open question for me is whether this fix is complete, and whether
>   the scope of irq_save/restore is right. We might also be ok with it
>   even if it's potentially incomplete.
>
>   3. Static key for LA57 in KASAN - sketched in the thread
>
>   This is essentially a bit better implementation of (1). Still KASAN /
>   LA57 specific.
>
> So my question to maintainers is what approach seems best?
> I am open to other suggestions if any.
>

AFAIU, this is not only KASAN's problem, at least in theory, so #2 seems
like the most appropriate solution.

If we decide to go with a KASAN-specific fix for some reason, Instead of
#1 or #3, I'd suggest using kasan_disable_current()/kasan_enable_current()
in identify_cpu(), the same way as as we already do for a similar
problem in apply_alternatives().

> So far this is mitigated on BPF CI with no5lvl boot param, but the bug
> is real, and I believe we should fix it in the kernel.
>
> Thanks!
>
>
>> +
>>  #include <linux/export.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/init.h>

