Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7904510ED66D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8CD6B0095; Fri, 27 Mar 2026 08:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999406B0096; Fri, 27 Mar 2026 08:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887E16B0098; Fri, 27 Mar 2026 08:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 727A16B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:35:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF97A1B96BD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:35:39 +0000 (UTC)
X-FDA: 84591789198.11.C845AA5
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5F02140003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:35:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A+DiUO5q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774614937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cOyBNoqrTish9nBBS87UAnS6CU3/R9H+gkn7UHvmow=;
	b=V3OmE3Qu0bmh9HZ46mDHifnfr6xjuaCSadoYlXLv/ZlgUmpcz647M7pDLkUy6EdROgRuqt
	JVC+HzvGkGJgw7SRqSqkILpk7V29SvRNk3uyqiSnfSBWRNj54mnusQj3Hvrqwy1XqZKpLe
	lvcM59vgwhwzHGuBOBRS7+dD0C38fdA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774614937; a=rsa-sha256;
	cv=pass;
	b=O9ccm/StJKb1ev33ydKo10jZOLUz5Im/rPCAkQ9WiXxhOwq97OiFW/MQGbojETa+d52mth
	qNDSSOMj9S/bNAH2MQ2OHJOFUHfEb/I/VnV8XkDyj8cmow1gtIK65ugRxz6Cy7F/C5M1pB
	/Z68VHajlcNbi3NJ21TNpFTZid7CraQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A+DiUO5q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b98133bdc4bso241467666b.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:35:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774614936; cv=none;
        d=google.com; s=arc-20240605;
        b=gyMmkS/n+bfoTbsdzoxrEuVnKJJM41g/42yBNbR8BPSB24LGn2CNxciT3sdr9ZdI4V
         qEwAhKhETMkuFR0f6C0WqMLdjhE5Y2vnYAee/lj9NHW7TZB8yoaVFi9alVVwlTk/0422
         Adc4AvN/iaAHYrNoA0+f8G5UWQnWcYyCeIcIL6Dtdfz4m35ovAbK6o7vbN5NEErqpHMy
         bfJrgF+6vL0KOYrnNbSE2t8wwTqLtMGl2LrzHap5S6ceiZS/ckdP4hvo8ejlXW908JqE
         dMt8SZEqff7BbZnhU0QaIUB18w8V8PdfK//Km/gHbsAFMBWnpYNyc0XmpDoH/MyoS9TP
         6HTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5cOyBNoqrTish9nBBS87UAnS6CU3/R9H+gkn7UHvmow=;
        fh=dpbwxV39jNr+QVSFAlvKP0Jwe6iRJ9KA3J4Cmxd+Kxw=;
        b=UMishCyYFjRITfXY6T0gLwXbCCXhofEKJfGqdWP49GZqLFdzFNskev7U8n8R1XatJP
         Q4O4Kmkd650q2DDSLa4rBBhiTVvVa7VTuycAa2LlE983f7cAaEcHoQ5B/8vB+oF3jWqA
         Ku+KjHv1Y11Z3fSrCfFIk3IScoOIVSwE+20XI4/iIL2AdDA54n5W8Eh4hdu0YnMs+UJh
         4yczvpx/a8KX7lL5+7qTqUzuVWwziHDw+cBeI1xyWoJU/od2mgYJbAp5lCnC7uvcX4wO
         KlEEVRjZdc8aLXs2Rtaime0Ny9ht5l8hFE8c6EUi1dxXfvhbbMih93rid6KMBpEV8DXn
         Wc6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774614936; x=1775219736; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cOyBNoqrTish9nBBS87UAnS6CU3/R9H+gkn7UHvmow=;
        b=A+DiUO5qBDBRwfkrTAKfiEX1nWWQ6a9pbHlhJKD7hlaJLI7e0ADGnO/lwj5cshj9h2
         GdJUQYcT38J7DFFAEeVHuYuX908RnO9N3Sl+68ptLbY5FwNYFWp3Mt35eEAhAdmiwAgN
         CP6lC8AnKMphXrlplfqO+cYTzsdIF1Edt4tJtFWwOY2bfyMSs3Fd+oR/PwalI/Qxxbi3
         qND6WCJwujhbCcXNg49T7adIUvrV2UPCdizpmsO+cI2dPkNV2N74Hf4BjoZay0lpO/hW
         vO32/t5jg/7cUnlP/Im+Rx60tGA/2rxtmujX5yUYKhJYmWRQ1O1vYRNddeBzqzoLTpPc
         B2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774614936; x=1775219736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5cOyBNoqrTish9nBBS87UAnS6CU3/R9H+gkn7UHvmow=;
        b=nsXrLKajEHzPv+opgFtKfWt8VM/rDih+b0XaeW/VtVSmuaj2eS3aFr6GBGr0Lx1x9h
         FEU8YnXuS/PJ05H/nWVxXO3e0azFvKC59W7QRYGUnDGH2iQq4LM/J8dkY+TM0pgT4Lvs
         SPGCxsR44E7U6qY8GVtQ0zQ2fjPU4tjiuNKPLFcBLUPw6B8tbzOI/wR8eZ26ILxoJW0d
         Bli7SrQOoDzbxG/Rpq/ImJYXuoFryHRKgHCUtCDfZSGWrjzkBVkGLw6+Tdq0WCZJe5rE
         eIQfZ0ydgDbN3kpSJn3xukisoKT6AXPWEnPN3yLXr0rZAr0AdlV8IOByAaRtnhgoJfOA
         BKzA==
X-Forwarded-Encrypted: i=1; AJvYcCXj8fRj5fJGQYlq70YS42sQlv8n61mrFRM0WXRHsWM8cR1qj2bdKz1pH6iFegusP/tpdbl3k4phCw==@kvack.org
X-Gm-Message-State: AOJu0YzieuindLQ1TVSXNbBIuam/rGumG8NCPmxCqLU1Lk8pqRVjZBtH
	AmJsyjpqouwtaj0DHVu3dLahgJDTrVAMGrUVCTHabAMTTWiKKfStwFicZxlm46S7slf68vbi/lh
	L/IzLwKagchy5uocXD3zexfPPJBU8zjM=
X-Gm-Gg: ATEYQzzBV1U56Y2yzEgQFnaz82KRMXLu0vMjyoGIG5tev2uttBQmY3mgFMrDuzLi64P
	bHGKDHaCQKA0FIRfLtqpQeeKPscGlbhk1lNLhIl1J0NWgZ0I/pViIrEtZQCvWmGzmFtPS0/fgKg
	f7RQ2qTp9J1zITqwWHXXoaL82qQwzQFsQ9+kUunuN2iHX10zHhf92Ptdkv/8G2sBZdeTULl6ZXt
	WEiXXmAXD/e9Rn6x7bPoXTKBA/1X/xVNjKZbQ1klsU3g+w4RukCf+hlq0ns7RzGb/zTG4gI7fyi
	7j7AgjqnDaq2ub7Q+PNL4JIQYVu1JH+zETmClQcyye8WSoRtUGeHkYJCCj/j6BuBUBIXWAXhV61
	uS9l5dV0=
X-Received: by 2002:a17:907:3f07:b0:b8f:b32e:e196 with SMTP id
 a640c23a62f3a-b9b507b20ebmr158948066b.30.1774614935669; Fri, 27 Mar 2026
 05:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com> <acZ3ZUXhFHpSXzYS@arm.com>
In-Reply-To: <acZ3ZUXhFHpSXzYS@arm.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 27 Mar 2026 14:34:58 +0200
X-Gm-Features: AQROBzAf3n6UCCCVOWz8_h19fmxDUeJxeUYrZ9qKYYIvgXaEOz3JyzyW2dWdB10
Message-ID: <CAHp75Ved0H=QE0CDfThdOexi0BE2JKrcmTnv1GQJyrf0_-M9fg@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, vbabka@kernel.org, harry.yoo@oracle.com, 
	akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	stern@rowland.harvard.edu, linux@roeck-us.net, hch@lst.de, 
	Jeff.kirsher@gmail.com, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A5F02140003
X-Stat-Signature: swp861ckucuxeknmxuawaip1op9urp35
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774614937-938552
X-HE-Meta: U2FsdGVkX1/fQmayFc6WGHCOS+yqIcNMYJN9NM4dYqkxUIFP4IdkUAOHVJE3Tw6TJIPx+17XBCr72jDtB7nLkceq3M5T3EjCbqxGmOkSwRqTtqicuZvyL3hg4Tf99OCWJklbfJ0/A3+zlXqzdWeZQbt7ie2yF4ruiN9CcAvt0pJisyVVylUtZpGmTVDf+ClUNrHzim9q+ggpqfEqMiJmMQgqPAuhYP/TJkortdkJ6XWk4OyAKrYvh9OvbbBIOrRmlsV5cEPkc8cWivqCULWtVKri/N1xpa1Qs8QQtOI0kt01ChuxX2Mfwz0kj/0ws9/E2rd0jQWIXgN5VtCqtuAzdUwJYOlgOROj8Q5gsN6lV+nd93tOXlwXMleZdm1463n+sKp/aM4FN0Ln5YarA/d01S23a2uU1rSTmsFbLD19LlQkZjzSmnP7a46/9g/fnKRjzJmQ/ExYfTA5FXHnwTz3OSSDjLdlTWXWXCmUL6U2Ltzxm9xLQq+lTvOnGqE6c75yhN4Vu592xivC41BXpAeu3be32mhASXOmygVnDBWzBlPVOO8WcWrXYR8K68FTfGX4t8GfY/Q693v74ePgltZVnmdOHmOoXEeMzbncQxNJOAfbHnaas3TMTGxYOHGsRGXzB9RGsmZLXSpGN7nUddQM8mE76N2+Eo+ZLRyZjTT8YuS6rFJwnnxqNedERP4mE55DyJkSJvBftaRYtAWjLsfw6LEwfyzri81kvVlu+WBgw+M2kXSezl/6/AOzMZdW/Ho0b7g4SXF8uQ9/454DbooeOJfw3UJaQUhBhvedYQ1F+Yl5isvr68DUcxD1+Pee7wCbWLCVrlPEQYmjMZLlQmjVv9nowcopi3GMDDHbpDlRETvvvgEsKxQFGTmbVyA32zVNYVF2zTU8UswKpHBxQ5/Q6NlBZKj9Pebb3oa4QNfyRYEsPKSEPGfl/H4G6Sj11r5XIqYdxAjzE0ywP/zP8WJ
 YOBevdVI
 hoXcrNxQjQqV/WCTCtMIJbGwUAWH+3HqaOI9qMOIstMBDqny79dAUXf4PBrgzwNKCY5AxZH/wsA++u862LPN6RErntdrMJLM4EWHmHDpmN1/RtIV2LLY72Cn/JZcoQdO+53rjb0w8rmq5kbseIGC2eCFoEP9HbM6dsmpbJ2UYs5ZvqR1bPwCmp96/e1iOkbL8GMmE0oCbiGJDWJR6jTJaUJsNQtFZRHKvO6yNNTHR43agUGI4vxxMHI3798UDqOzKA4qDYYyltyd5rR9Y/ojjNbEiGANsGTcxwwbzXXPfBbtQS/vazCJdTwkuKukLMYPnJjx1tAG47V80dwKoMFNiNRwobcg5ubLwUDZ7pYI26tdpP5gEokRPQh9bKLfn7iU/DUqBPHIjlTHwPYUWNFeToeLbspPhoVdRcAKFkPcYK+J2JjDlHRQUYgPSWhrp4BRa9a1orDXchGpKaTEVVSK9nMl/zAqJZscS6wlGp7B+HdeGSRWtofPiwlPRFA6kztAkw9pb3aHMaOHmNtpVuxE9Zrf6W8yA4Qtzx4cUwFrfTsKdJ/fKkCCyshx7MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 2:26=E2=80=AFPM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
> On Fri, Mar 27, 2026 at 10:58:46AM +0500, Mikhail Gavrilov wrote:


> TL;DR: I think this is fine:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>
> I'm not sure that's the best way to hide the warning but there
> are no great solutions either. On one hand, we want the DMA debug to
> capture potential problems on architectures it's not running on. OTOH,
> we also want to avoid false positives on coherent architectures/devices.
> I don't think reconciling the two requirements is easy.
>
> When DMA_API_DEBUG is enabled, the above will change the x86 behaviour
> that could have implications beyond DMA (e.g. may not catch some buffer
> overflow because it's within L1_CACHE_BYTES). Similarly for non-coherent
> architectures that select DMA_BOUNCE_UNALIGNED_KMALLOC (arm64 and riscv
> currently). arm64 defines ARCH_DMA_MINALIGN to 128 but
> ARCH_KMALLOC_MINALIGN to 8 (why 128 is larger than L1_CACHE_BYTES is
> another matter but let's ignore it for now).

Maybe for the cases where we do not warn we should introduce a
dev_dbg_/pr_debug_once()? At least users may be informed about potential is=
sues.


--=20
With Best Regards,
Andy Shevchenko

