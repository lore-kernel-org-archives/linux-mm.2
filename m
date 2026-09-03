Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC86C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453976B008A; Thu,  3 Sep 2026 09:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4179A6B0092; Thu,  3 Sep 2026 09:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307166B0099; Thu,  3 Sep 2026 09:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDC676B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:31:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 906271A0535
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:31:11 +0000 (UTC)
X-FDA: 85172537142.13.AD19578
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 87B381A0015
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:31:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWM5Cfl2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788442269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCmY/J0gqYQ7Ycc4TXHwfaeI120KcyF9adJuR9ZmWuY=;
	b=aqzoa9qhbm9mFrcq4B3vrjNZw4UrzJ8D5mynakpWlAzFhw8/u+6uOSojGNMnQmm9lJYZ4B
	l5kW8/ZIvh8JdvrxQbXcMmliDS3LH9Zd/0N3NMT3Sv9dDHuLU9RjGDfa2XZgM6lpAjQF0o
	Gwoi7GnFc3FeC/KtA3AHf0MA1zIu7uU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWM5Cfl2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788442269;
	b=BPCjI1M8XYm0Yt4Qa22kSYLz8Uz/8DRNufGFWf/Rop+PnvT4n1gGFoMxHxAzBOWhQ2X/Zo
	mkuvtr2TR63rJ6ThWCoO+OW8X38Io+89P/tcOBzxpAfdnORYuRDJixh7TreBj2ktW90VRp
	XP1EnFp7hDDPqpQkWUBX0ryWzEKPrP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6455447A4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6F71F00A3F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442268;
	bh=hCmY/J0gqYQ7Ycc4TXHwfaeI120KcyF9adJuR9ZmWuY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dWM5Cfl2FUwhgvlMA6GiVioPrBYRJrW9Ff0J5wen4cVSdmVAM20qHj/WuyNdjNi2w
	 i9VxG5nH/Wvot1e/oV5XQyNhXr36x0hPGcy4nxxWFZvx+7ppXuWSxETHcqIp8qIJq4
	 NsVkth9UI+ffrqwxs5W5qb/XIJoPYAIU4VsWAkNTxHS8mLmxhW9xkFw/Qp+T0qzlOZ
	 WQAvhHVcfyWL1NwkqXcI60Ptz5BMrn8Ovp7sINhT+0o+MCiw3t4W03qMGB6Ane54Zk
	 h42/mq4jPwZ9stZSJbJ7iiOIk3UJPZcEwB427EYbpi3wscdxTqUMXA1OZ1J/tRsLJy
	 Jd2Fki/3UXp5g==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c197e7e4e94so364539866b.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 06:31:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwzk9FC6Mnq2T3I31Dx1YWYh2dPUMbVRV2TinW+lYyBUCu3DAQyKQkn+AuX+U0lgX1KQOgtBB41Uw==@kvack.org
X-Gm-Message-State: AFuF++kdIPrIIsCPK3aVcIQSUereP0QuIu4oWS8xQ1iGK/cb4nCbwd11
	SmXVsoo3Nhm9ZfwETQVBia5xdoarqV8g3NEI0IfLtN3lls6X5ef/Hg7QGmjsxwdIzCn057NAqZF
	6zCFCO5VAoMtQmoV83kLYK0s5pg5IhV4=
X-Received: by 2002:a17:906:ef0a:b0:c25:9102:ee with SMTP id
 a640c23a62f3a-c25d5450105mr674029766b.3.1788442267343; Thu, 03 Sep 2026
 06:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
 <anJmOMqCVugycC9x@google.com> <DKOLND2TRB15.2Y8DKB3ZKEYAY@linux.dev>
 <aoOomzh1ErtSeKFb@google.com> <76dd87e0-cd34-4ce2-9586-d7ff019b1fb9@kernel.org>
In-Reply-To: <76dd87e0-cd34-4ce2-9586-d7ff019b1fb9@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 3 Sep 2026 06:30:55 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPpAbU76yM7TFW+vFugk6H+J5PwW5iM+qef-D3Oa7mkYw@mail.gmail.com>
X-Gm-Features: AcwNN1WFofe8gNX465KLduO3JcgRtjh_frBLWrk3HB7XJCz-hoj8Ik5N4ZEitco
Message-ID: <CAO9r8zPpAbU76yM7TFW+vFugk6H+J5PwW5iM+qef-D3Oa7mkYw@mail.gmail.com>
Subject: Re: [PATCH v3 13/26] mm: introduce freetype_t
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9k7jxetcaprafo7m88msx3rou3379r3y
X-Rspamd-Queue-Id: 87B381A0015
X-HE-Tag: 1788442269-169305
X-HE-Meta: U2FsdGVkX1/GgghAMC3lYcFA+y6DLE8wZSIryXeTtThc4iMnnh32w5+T/sRyIMdjLNp9ZUjr0KWfYPcWYO7RGanVexx88yTr47oBcqclOxXqE/QbsbXLWeCqqFhSyVEZ0VyIqGuCaFHDCg1kSH06KVvwAdW6oZ4FkNIKcoxgPBIYgmAsSgI9ogqfazKaDU1kAVoqPzE2+HDrvD15Nmg8iHNghnOiizsXeWUixIC8uvCKi2NEEBRR1gfo23qGU05ybio5HIKFcZa8hlUKky3u6D/lQ15aUjixVGq4xmeKS3f6n+3yYfA+mkH7B10+jZV/8ynES3Au5RZT6tzl7xhvdkqAB0FqjM+SXiluGGVVLEUaZsCCi+XrsK97c0eHjedTyMKpp1owE3ogeCzs/NDTycfTmNHH86yhwdncrksoZcuqcN6e1UTUikke5XNckGgDX1CgLEert673UJzvfc1qWuE0Z8yVyohoKgbFTEmchpC4xQigYGZGJFRTVIrNBI8fFBYtuOZ10koufzmPj/uCqSFPidexDsDOBANgIMmCuIhhLMDiNZZsAQy+yN0oUuc9u2zRq52u6spBpIpdAoKcttgKKjYdbA0PNSitXODE0vvT75s7r7UEv1sPkl6ClCoPM5O80yTGcSzeobgPRRgQFnZXXdSsB0EIme3WOT+8cYYeJcFoc2jW+2cTcT6/KY3uMnJbkLjFFW24zUuQ25lNrD7pMYb6uOcp3UERA0nDGu6EP2CFhfM7J0HO4JYVuX64TACe9nWEjhlQ/4SR7eV0bit6ZWCr5pK1h7nq4AlNfdHJH/b/UwDptjkA0bfZVjU7ewm5OH2eUdTZGZKaVdkALn/OCllvqKYn+Yj/8YcRswbkOTsvAUKzP88ACWXNq4Sz8PamkHgDbZbkOEjmk+J50SHRzXzxmluq+6TP4OWGrSrvMd+Qj8JkyJkfHuWYs1fF2qRYYf5eBn7TFceSwQQ
 h9Yo2tjb
 58OAiLFGYUCe77hLu1FGea7u+Ywp1dJapMSQ4fjurpuuVmtS7FLV2aY76QGhUjgKzM88OWM36x/MzkFFfJrcLEQVpAQ3t4/fWFHXmKqMe0lZyTQZ7XTIH5wT6Vy3otSNMxVhOusuSCbsP28y940/CiFugm7NiD66q7c3u/LqzRyZgAkBg6VbRH6FTwaV5pR9CgVivZg/EBtEZZHZ8QA6n3q/GPg871SclvjYZZnX13EnVzhGytTumFhZbApptH6/Fm1JKNInaPNVIcdG2BflJHIWqbzZ5EwHQUFjojO6cpJsAMBDi4hUkpFbELDriPPSjrmOHsvGhcJs7173VyEmWlXpE5oRPJZFivXFOcBzD/FAPGpWhdaMVpsa25mer/ejhJiEaH2fUEmE1/uw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 1:00=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@kerne=
l.org> wrote:
>
> On 8/18/26 02:35, Yosry Ahmed wrote:
> >> >> +static inline
> >> >> +struct list_head *free_area_list(struct free_area *area, freetype_=
t type)
> >> >> +{
> >> >> + int idx =3D freetype_idx(type);
> >> >> +
> >> >> + VM_WARN_ON(idx < 0);
> >> >> + return &area->free_list[idx];
> >> >
> >> > Should we return NULL here if idx < 0 instead of an out of bounds
> >> > access?
> >>
> >> TBH my descending order of preference is:
> >>
> >> 1.
> >>
> >> BUG_ON(idx < 0);
> >> return &area->free_list[idx];
> >>
> >> 2.
> >>
> >> if (WARN_ON(idx < 0)) // OR VM_WARN_ON
> >>   return NULL;
> >> return &area->free_list[idx];
> >>
> >> 3.
> >>
> >> VM_WARN_ON(idx < 0);
> >> return &area->free_list[idx];
> >>
> >> 4.
> >>
> >> return &area->free_list[idx];
> >>
> >> But I suspect[0] Vlastimil (and Linus) would order it the exact opposi=
te
> >> way.
> >>
> >> [0]: https://lore.kernel.org/all/bd36e972-8900-4476-a66b-4dc218b21a4d@=
kernel.org/
> >>
> >> And I care more about making Vlastimil (and Linus) happy than this tin=
y
> >> detail of the code, so I'll defer to him. The current style is a
> >> compromise, but maybe it's just a compromise that makes nobody happy.
> >
> > I think I prefer #2 (regardless of whether it's WARN_ON() or
> > VM_WARN_ON()), let's see if anyone disagrees.
>
> #2 can't work with VM_WARN_ON as it returns void. Otherwise if it evaluat=
ed
> the cond with DEBUG_VM and hardcoded false otherwise, it would be ideal. =
I
> don't remember why it's not.
>
> Do the callers all handle NULL safely? In that case #2 has some merit (ma=
ybe
> with WARN_ON_ONCE()) otherwise #3

I don't think callers handle NULL safely, so I guess I'll keep it as-is (#3=
).

