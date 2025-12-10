Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FD2D3E781
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C0F6B0006; Wed, 10 Dec 2025 17:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD8E6B0007; Wed, 10 Dec 2025 17:45:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBE86B0008; Wed, 10 Dec 2025 17:45:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C75166B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:45:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FFDC1406E0
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:45:04 +0000 (UTC)
X-FDA: 84205043328.03.9CE4FC7
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id A041614000C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:45:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lY/pGn8q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765406702; a=rsa-sha256;
	cv=none;
	b=CodSXQmY+l/d7WZ+Cpd3AvvGVe/3ppQIEwOrOkWP2JeGQ7zWKFGf01s2U6X6kyZ6Ivpadr
	LAwGrwabhXTdnqFCj9WEEcj9rZeG4USdANBlcB7T13BaFbigr9f8g9Zz1WriNzzQI3VEP2
	w5lUQfj7ME/PkzOai//CPfAMX+lUN7I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lY/pGn8q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765406702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQ2DSh18BPQ1A171tvS4unFLacQbk30zjgIUm7UzPLk=;
	b=LDhuJ78csM3oYELvChbjZnFPdust7JsWwNsp+0BLf4OowdfFyneQ1/fWda7RLnFb4zsAJb
	9rhCcgZ33kMj5G3H/kMMcKmMID2U9WSabjW6nS/ioAuuTIcq66uUzfweVCQX9fityzhmWp
	DQ6KzvUdXXyA8rjodhguDKksHcywsz8=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b72b495aa81so51652166b.2
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765406701; x=1766011501; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQ2DSh18BPQ1A171tvS4unFLacQbk30zjgIUm7UzPLk=;
        b=lY/pGn8qbWYgkIhWuXKDaolJTGNHXIc0LFgv/QiaCT3fkUREAbjGmlbvTXTUFsVLxv
         9aLuK9zlNM/YYePBS4RtwI/NfLk13GauJeFksPRCps8MW7BSWA0eBrioM7Qyq3AL0wrU
         6KUdJCko9yFpJ3uIMT3Rlfni9J/dIjDVobcmMaYFz+I+76g60zYNtHKORZb6R7xFdo0Y
         BoaKaqQ/ViUmLoxLZYVJ/xdoZ5s1+IoVn+KpM1rHBL2A049G7cABOWj/7uo+JwwH/nvr
         u7XZKBnE6je9V4rQihLyferePocd0DeG/ZxM2Z3q8Zv4t22Pa9erCibwJ3LvC4iSzNLS
         CS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765406701; x=1766011501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VQ2DSh18BPQ1A171tvS4unFLacQbk30zjgIUm7UzPLk=;
        b=R/vRqhmDTBt9P0bkqrxRnemmVKBL/wYpdd7KJzZdjB3irGGeV2h67g+5EjypSAhz2e
         nEuh5jFSJ923tJIoK0cbSI0W0/fDNFBaJN+kdcpgs5TlXCiJdFtmPF/vq+Od5rax0xsE
         a3fSIN5y/qNv9TRBM1SYba5dIAA8mV2VYGP9EIOb97DkIeo9N6nlrHucAeqATUODSCts
         mssu+rFltVAH4/iJ0QWB0GNLOKe/mdsOtkJEQxi64MZDokv8cjsmKEo2dQHuZmwHvz7X
         C2MggFaxkFhqhB6g7oRzxoKg/x1G0QzDRAaigndmHzVmCLbHq4fsMVDV+LeMHanvy66A
         HI3w==
X-Forwarded-Encrypted: i=1; AJvYcCX3Fv/KIoLrvyAJ6YR3uKcbACHfkTQupO/AVyqWoQD95Ed54KoyD1cXZc2yNd+D5QN8TbCcm5TyqA==@kvack.org
X-Gm-Message-State: AOJu0YxSWzpMiX6S/r7huC/kQxQifLWqxyy2s02Mt8h9wlq1hzDMypoN
	kbhE3JcelMX7lpJMhM3LQ7hQlHrjn56plsF/bdYi5jmy8dezYOsvkWDAZTPMGTlWgcfklPWvg17
	eFhZjs7xsCknPrF+4lajPyLE8Ye8vRlU=
X-Gm-Gg: AY/fxX4QjWiU9wOh7/ikrJel1ExGf9YBSTIIDstMChoEZ9Xo9gly1vACdK+a3vi2Xpw
	kw+PHwihFHXa3q88bqpBUmJ/1jMWmzdbWYnSIEsehrrFJuRcOivTmiC/VB4Ku5XWBAGWEkHN1Zf
	jWNrAstdpoPgFlWOCvdalINHAHUnHlka+l5OyScWUPZPbgs2Y0SqZkriEmHd/0TxV4pZLwfnn/I
	vG7n1/7RM1luRcYLqngs61q55zYFvByIjfELOkTOnGppL2ZaZxz03euoxTWfwVxjy9SICrDf+RU
	nXUOzMJSvZ+1z6BOtpwx0cMmK4I=
X-Google-Smtp-Source: AGHT+IGm7kBMJMQy3iQeRY+8zR4da+gs16KCJ935OvAzALtjygXNQLUTj7Hvy/HSaYzKQJr5Gk7AKONXf1Wc76/Jkw4=
X-Received: by 2002:a17:907:9408:b0:b76:e346:f74 with SMTP id
 a640c23a62f3a-b7ce83886b1mr452457766b.16.1765406700728; Wed, 10 Dec 2025
 14:45:00 -0800 (PST)
MIME-Version: 1.0
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin> <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin> <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local> <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
 <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote> <0a7b6c7e-c388-4327-b666-6225bc63c90c@lucifer.local>
In-Reply-To: <0a7b6c7e-c388-4327-b666-6225bc63c90c@lucifer.local>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 10 Dec 2025 23:44:48 +0100
X-Gm-Features: AQt7F2ry4ov7U_m6emJr1MRH_2xjP74GcRZBMJmKrPLSGtov2b2QEYXBsfTzJiE
Message-ID: <CAGudoHFcD=Wv=SEqaaks1TcY2CZQsozNzadejQA1uBbdNPSakg@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Laight <david.laight.linux@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A041614000C
X-Rspamd-Server: rspam10
X-Stat-Signature: cuojwapun7hbe4n5tnpbstrm4dtictdn
X-HE-Tag: 1765406702-480461
X-HE-Meta: U2FsdGVkX1+lXrqXyu0RfJbf0LsPtwQN22kSqTpcvSlT9r6ZFtnDWzfPwgLjuPXmWd1NPYYqpJjtAlK86gNRdQNYmeeATiIT8ubFEoogMX2dmu/Of9f6/segjrZnOkYbEstHDFKsG0l097Vw7i/1jtKLo8JDW8WdsN5EqwhtuGJeiqbpElACDZ3hrWl+K40KkobxpZT+BGDbxkTrFmRly9PonrPZDv0Ckf7CdHG+DB/ht+F++He7JtQ2FOxZitTBaiYBwA+WTq+nZPbdN+6tvVTn5j6UbRaJb5W320FCyDLrxx994GktJN+fSQ3iuwRJ0THCOiZfVxD90z7RPn9BCdbta72HxjZtzZddvw7NkwTQuh8yklq0KdzyLrvbcfUyoUEQD9GWgrcTxzl2Q4q7oyb1Ayzq4HUeR1rse381f/PbVi5UdGHIGGmCQPzaxIguKdTFGZB8Hs0AYrM8mkqljPlMzAtaXvmQZcG3mcPzD4UODDtRqoZdnKTpXCEdg839JF8qYOxWiiJG/E6qzGnTjR3PzlE3tIg/pN3FfS9JwqMY0Ct+vA+X7YDH/igO1aU/RtEX2Po39e5BA5AiZvUhhYSviBXFemFH/VixUS4B49ap+UCmL9UgY8L2wV2QYb89Ackw38KU/VtZa9f3yzg6KhTOEHGMz07oTdtXg+85sQeBfFVkHSk8yLcsT/sxXB2r+0nGG39tT/TpUDTC0DxkzMjyBd8YKCnMpkzc36KzBf+R2JwJXFR7dq9sqaZXyEN2vLsWB9rIP1GIYxx8PP8l/oDQ5CRoNEJgR95cZozX8Ec5GZmWWHv+/QDwGkZXkbwThvakmF1GamVz2FUuqbimFaCE6n6LpX8uIEnovFZn647U+VTx2FAroo6Zm0aBPR+Lpi6RaOV7rQbZp8+ogJ5E2AymeISHJ3Td7vlehHUyaOgv6hdfi+VnHKbVj1ArjR/L4iITa363PgjWAsIPx72
 /Xb1lnUJ
 8JGoF1UiYLuv5T6J3/warH07rv2W/CpQ7I1mqh02U3MmWtOrb96GOgN6uOe0fkb0GC+ED1YoLit9Z3oRJqhSyfu49oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 5:18=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Dec 09, 2025 at 10:26:22AM +0100, Mateusz Guzik wrote:
> > On Tue, Dec 09, 2025 at 09:28:10AM +0100, Vlastimil Babka wrote:
> > > As Mateusz pointed out off-list, the profiles look like mutexes are d=
oing
> > > less optimistic spinning and more sleeping. Which IMHO isn't somethin=
g that
> > > this change can directly affect.
> > >
> >
> > Not mutexes but rwsems.
> >
> > The bench at hand has some of the code spinlocked, other parts take
> > rwsems for reading *or* writing.
> >
> > I had a peek at rwsem implementation and to my understanding it can
> > degrade to no spinning in a microbenchmark setting like this one,
> > provided you are unlucky enough.
>
> So we're just sleep, sleep sleeping? That would explain it...
>
> I mean is this an issue with the IPC design or the rwsem's in general?
>

the ipc code is not doing itself any favors, but is probably not worth
working on either

the lock stuff suffers internal problems. while there is no such thing
as fastest possible lock, let alone sleepable rw lock, it is pretty
clear the current code leaves perf on the table even with that caveat

> >
> > In particular you can get unlucky if existing timings get perturbed,
> > which I presume is happening after Lorenzo's patch.
> >
> > To demonstrate I wrote a toy patch which conditionally converts affecte=
d
> > down_read calls into down_write (inlined at the end).
> >
> > While the original report is based on a 192-thread box, I was only able
> > to test with 80 threads. Even so, the crux of the issue was nicely
> > reproduced.
> >
> > ./stress-ng --timeout 10 --times --verify --metrics --no-rand-seed --ms=
g 80
>
> I wonder if large core count matters here in particular, I was doing this
> (albeit in a VM...) with 62 cores
>

you need a large enough count to generate enough contention in the
first place. how much is it for this bench i have no tried figuring
out, even for my hw

