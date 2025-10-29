Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F521CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9678E0063; Wed, 29 Oct 2025 06:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081E78E0045; Wed, 29 Oct 2025 06:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9988E0063; Wed, 29 Oct 2025 06:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBC688E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:33:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AA3DBB89A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:33:09 +0000 (UTC)
X-FDA: 84050789298.28.A5C0EA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 251001A000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:33:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BkRgS09h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761733987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TDebEJmKrapkTDm2SQS84/R7MOsdaEIy1zvcb82V9E=;
	b=5fLHlNN8ITzEK8/DUhn2n0bbl0WYcsLLkAGinKOAFc1w8iEC8hb9+XLO7vpFRemYVkmsg1
	RkjlxhxMuyNOfhpWg1GeS3h7/wRSMEBGAT98pDP9Y9aYDA7m4F9yiwqR36LmyQI1JbCcvC
	9keQtLIumJhWMZgFlwbMCPUHXxRinJ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BkRgS09h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761733987; a=rsa-sha256;
	cv=none;
	b=WZU97ABzylGxAJJcGZhBO9bgMynVzMR+PTTkb7eDB5GPdpiJZGBfqCbsJfluBqNerxLa0S
	YjiGalmsDDwr8/Qx9sQ4LtdJf8hVpIFIKBbOg64w+jfwA2VlUl9O2PNUHzU2oDYEhoWPA4
	8nuCu1vYq/N9myjIYkZftcd7grqTX5Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761733986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8TDebEJmKrapkTDm2SQS84/R7MOsdaEIy1zvcb82V9E=;
	b=BkRgS09hvR7WO62DNhNuc5U23hKtV8jf4YmgE45PP+yrVk+1OV+VXeWbUbHdVBhEmJ9QWk
	oewDYr6VfqWtkUPGaZ8GtsHJiMKHjwa/hUQgaMoUA8F7XG9ZosGcT85E66s9ILIGqt8W+z
	KwBC5Rpiwe9hDWZBopIfVoS6UkqxYjk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-gFgjcr4JMS6naIX17T3EwQ-1; Wed, 29 Oct 2025 06:33:03 -0400
X-MC-Unique: gFgjcr4JMS6naIX17T3EwQ-1
X-Mimecast-MFC-AGG-ID: gFgjcr4JMS6naIX17T3EwQ_1761733982
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47496b3c1dcso53689595e9.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733982; x=1762338782;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rJM20FESPr5Q3wolT/mFDxUYnwba82V6xz3P+wmiM7o=;
        b=VrPLHwVDTz3lcCJg8uT0GL6DlE9o+30oFJt31x2WSAXyjbW9uWyhrniRjCEyzJ9eKL
         ZcuBYMpACmDlyoek22gSK9bjQAi9naY+lcPh3zsEMVrO++0zbZ6Kkwiel/kHVy3JZO2Y
         lP0DMamhsL1qw9TgJvH1v0pndWmT/vesBMFkOJsPYOA7cpKi26W71qgG5xmKGpZgGaph
         4rWhco9gKkKFyt6Vc94XMJ9TG9ux1+G6e5YCL0o2IOj8WSZ+BD0aHgVnJ4UL0KYT4JR7
         yYMlUpyp6Q65N7fl0ptlUej1L5pv73ABOEPJvy0F0f7e+M43Vw+fmPDofbJ+CynH7LrA
         JG7A==
X-Forwarded-Encrypted: i=1; AJvYcCUmvvF/EqSCtmP8ocTFBoOyDcv8KgonxdVkiabLagbC89x5FtPbfxMxgfl5nAXpxdGQbXfnWhqUcg==@kvack.org
X-Gm-Message-State: AOJu0Yykp5AslaLpbLO4NRuU0ZcSoregzCyWhcoYw6H0rcZeUmLsTFaI
	w8qtiCtNRgqas46V1y4SrygduSyWi1tz+B5W0qeyLL1PRFtyyuKGbX+YqVpDjfGf0aAvxAKglro
	cq7oK1M8HE4S8WypwbnHSq4DGOhXMznY5BTM+XxI1HLvYA1CTdMQx
X-Gm-Gg: ASbGnctTcykGP8z09fy8TS984zn6AJsLh6TACsHkr5fGC/JoJdDmbJulJdlk9RYpufQ
	du0Bm+17VJmgIQ+Iz2rgbOmlIYPSDWml55uDltPuC2rWzgUGHbpJCl0SydCnfYCR2eOupgEXWIJ
	rXUkrxr+3+x0J0NdxmILlOYirY4E8cQ/B1Gf/FvBZ8jfF1/HQats7wqpXepFENqV7ZrquQHy5HP
	Njc80RPyPqaXQ8m1VuG92s4j1Zv821CooUtWGlkE4yrXwV7cA1vOB5Ep9x0vlXYjiBy63pGxs9J
	L4c6NIqdHb2aujawPm9kRpM/Mpz2JDQgDWUEmRh+tnoIXWlApK5it9CpQmhMELJ+6HmfGfClFf3
	vPUvywyGcFJNsM0nrFrq22yrKSh2uPpyEXKEDHZukRtEqnE0UZTD+qMPqcKAG
X-Received: by 2002:a05:600c:64c4:b0:477:bb0:7528 with SMTP id 5b1f17b1804b1-4771e1da0c8mr21409535e9.22.1761733981944;
        Wed, 29 Oct 2025 03:33:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxlh/PGW1+wNXuO1RQYN4fEeAqw5AdQXtt4ynjbr63hSK8Qg5GeiiDecSDqHTa53KxpVgVKg==
X-Received: by 2002:a05:600c:64c4:b0:477:bb0:7528 with SMTP id 5b1f17b1804b1-4771e1da0c8mr21408835e9.22.1761733981314;
        Wed, 29 Oct 2025 03:33:01 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b79cbsm25638297f8f.4.2025.10.29.03.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:33:00 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>, Phil Auld <pauld@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Paul E. McKenney"
 <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, "David S. Miller" <davem@davemloft.net>, Neeraj
 Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes
 <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, Boqun Feng
 <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
In-Reply-To: <aQDuY3rgOK-L8D04@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aQDuY3rgOK-L8D04@localhost.localdomain>
Date: Wed, 29 Oct 2025 11:32:58 +0100
Message-ID: <xhsmhzf9aov51.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wPuYp2w61BXQRfXHmp5pWTQR4Z8jvttY7O1u4_ylcNs_1761733982
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 251001A000D
X-Rspamd-Server: rspam03
X-Stat-Signature: wic9feuee9g78k98oq1x7m6yqsjjgr3c
X-HE-Tag: 1761733986-169302
X-HE-Meta: U2FsdGVkX19rlhLI3OfVjKHg97dez4BrVpvGwBvSWEXp+9mBWX2akHps/JR2LdvGz+HF5Iu9teYrWUMLyJeP3u2OyokJ2zxwjODmaypiYe5ffk+2g9f6Rk1ihx9OOsXGEU8mw0NoTs8vay9oyKmkYj1ntAt0DGbbcmpCxddf1TRf5F8MB/hxjaxCcH0vSafXzCjWX3QLPTo0gEUCgix8tR/+brOkLe2S+4I/8vgE5hJt3r/JXBqg490/aPkJAyrlTyW1+kXqyZZ2EIQgj9VUMZlvITf96uAw49pF1SajyHY/bsyblt6+u/IgvMKwSfvjtKdzVeLbNDxraCoSBQsxJ9WoVli5HZa0uCXAY8AzdjrgSyFxOo6tRyLbzYHn/HKGZl/TrUpX6CVCp69O0gG7hXnS05YdURYTVGORHJiocBYyTG+zvOZBQh2uwIUZxY/no1ItTpA9SBBganCD1ltR+tjvYkP8N4iieNsIjkIs6F1zIdKCJb5FWhbiQmJqM+a2ji9ofAWa6FkhYTM5TMyAFb9+hB0aHHcBzZzUrilAjt0XTtZo0ErddZCCEmNX2icShSVeQq8YRfkHu+l4olOC3Abw2J31Pn2ncObDRszhyPchpeZk/jw1tn8Sc4PnmS9djc60m91G5BXvo4y16hM1NhMGRYCXIDXfsZxVxmSeOP0ZLC6Vmn5HnAmJ3EAc5i/3amreJmo3bmC2JPuGE8tci8lm4nikB0MKGKH7cwGOuEm4xdu2XbVjfvhtm64V/Djx3RNG8tKIyZuOy2HvZyMhpTK/CO39wUW4XNDbKvuKHGy7fm9Y4qky5MbJB6Nchg2eIcp/33Lj1lvq05tHLuemBJ/GQOk4tsS/DnBrxIDSB35U8otCrEvR9CR9/Wtb1Osh9B0OulOOoRxsJut1aY9NW3+729KSeKfJBxO2eTRsjXRol2wpTLkBvOj0MAHODHIK2EL7Pi9YobpKbGG1mTH
 QDW+gqXO
 BJXtd7yo+S0o1be+kZmSxkrFP8Z6MU6hsulhEfA8Om6qq1pubNiutZLhANgwniNzvJ7pfQSAgrgsExiCiMCHJE6GLCcrkSH7nRh6ignpw9+aAgBYGn6yCmo+Up4P5QVbZaYGFVDnWArK8K+n9Zo/Eop3D8R3XdOrCpU2wsc3LVJFMX47bx1w6OTFvdBlgpd2JtGjMWxV/OHWG5KRHwAB9xNbD2U1GppW14pxJ6WktCQEGOSJ46hHBawz+7bPKobOwFYRIL7sT/H9kx1KaVBIlbYHihS5A9dxrPuaRSjOoQ4nOIpxfhWGDbtzvn2JvH70C+hS8JtbxqeFdAAwGx66jW2t/MuGNAFWlhndz1QLRpG6Z09yZ/1uuoXXiR7Mb61kC2BeMNwZPL993LzVC9laHFgTwHC8WNhjlIUgeaeIwX6vXD0DCDqcxxmgX2REC6dfgvU3UqY8k+z8uLlk/gDDbqVUsiA0CHPiwwTh9zzmJuXKRXsgbhvX/vBtFDFiUbO/S7zzyEiCocnfnQKfeDPMEiD/16x52lq94A+gGWzuk+fforY21h5jfNeiPt0egBf+3ooAG2CaXB3nrrXDRQBbc6l977jhesQIBsJuxrAHFMw+TyN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/10/25 17:25, Frederic Weisbecker wrote:
> +Cc Phil Auld
>
> Le Fri, Oct 10, 2025 at 05:38:10PM +0200, Valentin Schneider a =C3=A9crit=
 :
>> Patches
>> =3D=3D=3D=3D=3D=3D=3D
>>
>> o Patches 1-2 are standalone objtool cleanups.
>
> Would be nice to get these merged.
>
>> o Patches 3-4 add an RCU testing feature.
>
> I'm taking this one.
>

Thanks!

>>
>> o Patches 5-6 add infrastructure for annotating static keys and static c=
alls
>>   that may be used in noinstr code (courtesy of Josh).
>> o Patches 7-20 use said annotations on relevant keys / calls.
>> o Patch 21 enforces proper usage of said annotations (courtesy of Josh).
>>
>> o Patch 22 deals with detecting NOINSTR text in modules
>
> Not sure how to route those. If we wait for each individual subsystem,
> this may take a while.
>

At least the __ro_after_init ones could go as their own thing since they're
standalone, but yeah they're the ones touching all sorts of subsystems :/

>> o Patches 23-24 deal with kernel text sync IPIs
>
> I would be fine taking those (the concerns I had are just details)
> but they depend on all the annotations. Alternatively I can take the whol=
e
> thing but then we'll need some acks.
>
>> o Patches 25-29 deal with kernel range TLB flush IPIs
>
> I'll leave these more time for now ;o)
> And if they ever go somewhere, it should be through x86 tree.
>
> Also, here is another candidate usecase for this deferral thing.
> I remember Phil Auld complaining that stop_machine() on CPU offlining was
> a big problem for nohz_full. Especially while we are working on
> a cpuset interface to toggle nohz_full but this will require the CPUs
> to be offline.
>

Yeah that does ring a bell...

> So my point is that when a CPU goes offline, stop_machine() puts all
> CPUs into a loop with IRQs disabled. CPUs in userspace could possibly
> escape that since they don't touch the kernel anyway. But as soon as
> they enter the kernel, they should either acquire the final state of
> stop_machine if completed or join the global loop if in the middle.
>

I need to have a think about that one; one pain point I see is the context
tracking work has to be NMI safe since e.g. an NMI can take us out of
userspace. Another is that NOHZ-full CPUs need to be special cased in the
stop machine queueing / completion.

/me goes fetch a new notebook

> Thanks.
>
> --
> Frederic Weisbecker
> SUSE Labs


