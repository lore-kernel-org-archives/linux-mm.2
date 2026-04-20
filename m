Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E35EA71BC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 04:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E006B0122; Mon, 20 Apr 2026 00:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CEF46B0125; Mon, 20 Apr 2026 00:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F006A6B0128; Mon, 20 Apr 2026 00:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE0046B0122
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 00:52:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7159013BAC3
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:52:39 +0000 (UTC)
X-FDA: 84677713638.23.3C00B0A
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E395160008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:52:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T3puM95r;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776660757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTkXYM3+vM/fkB3bQ583so5PgFgZAXqx93KFOXQCWO0=;
	b=xFn52qp+tidBqarGkg5PGBfj40cCUkB7y78R2AJFKrzgbjMiac1BwUMOQrqGxwVSw8jIPV
	nHYr9tHIPau7oN3CCcDsQkpiMk2OOJKX6poyHykrKopvJD9qIr+3YAeztf6mGJznoj06kl
	9VyYAMQSKzWb81sGBPMuI1hq3MHQ97Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776660757; a=rsa-sha256;
	cv=pass;
	b=H8HiTgA+BxpAwgpKEq9UWi04vx/1Xb5I82ETMrR0ILXxVl6I/5Es5DrwokAKkpbok7gydk
	HWsqOjzOlVNitgfAnhXivauRuOCCuikZ1IY2X8/S0eHNUu8+CBG2BsBm/U8dRHhf9Nzy5G
	P5cw6BDZFqakp/S7Hb1m7lrnki1yW7k=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T3puM95r;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cfce3a195so1559880f8f.2
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 21:52:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776660756; cv=none;
        d=google.com; s=arc-20240605;
        b=M3DT8UJ5HmkuocyBmBXTMxjLTJqyIDooRhKfy0E4YZp8n+zPs7uoeEpeI2sXLyRy7I
         zsYxfEwl8+li3OCcfgBkBFHIKg7qQwtrs7gmmmKwPhGpRFP8MyMYy0ZkUX4bA0ajrlgp
         ktxK113Eh0rOy57XBw2YiHm+of+1eaPuxUET8kyXyjtkBM/lJ/SPRlCofDRCME2BhYCU
         CPHbw+0ESkylLATnDiwLnHbR+o5ZsL+LNB+UbM9x3smUU7b+xqRlFp4LhPp4m1Xu8gZG
         cO5G+DFlTYOODHrsVT2nuRqeqGMR3E2unOkdoEktRI5IpuAaq8+lFeg6XBiY1PHPiEhg
         Qw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TTkXYM3+vM/fkB3bQ583so5PgFgZAXqx93KFOXQCWO0=;
        fh=xwe0RVgQmZEMJTY8hfg1B3xrvCX2Oh503onJVDbi+WE=;
        b=cXVVXACOiuN2FCqbR2QUTKq+fBfO14IBXlCxqIhgmVmSERF3IlFRMColS1RmW572sx
         2D3L7x1lB5GtGFueRs+2KIb7niALj1NbmXZBuBjR7vidDhRK7Dcm9D7bcExGKP2s0HaD
         9l6BlNlyp+j0xlBLcT1qA1DGOmDCEleSJ+q40b5xM1TpL8wPZignhrHfGTZvxcknbZLZ
         UV8MHloyNMiV0Ius+a6lj7DzIGTaKuAZkC0qm4JhWs2vQNoXNqIAtk6slzT+OHIFbwFg
         nDfbkfevwR14fQpyhu33yAD8+tKg8kmwZIVifJJf/1K7sz6f+Ahqe5MTqvCUvFezibHu
         stlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776660756; x=1777265556; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTkXYM3+vM/fkB3bQ583so5PgFgZAXqx93KFOXQCWO0=;
        b=T3puM95rvBOxblKr5+rQFATuQpA8U9DQ2Ukzpv8/WEOcTf2BedBSf3sgKJUW4crNub
         u8hzMXAwoimYfGd7iruFjaaaeLsC6oVB1NU7J0qfPyDTK6OAh/GekcLKbSal2fqFetSn
         Fw0eKKY182yixxbx7KeTwbcvl4a+n/8I/1q55DaR0qyz236m/Z+j7smuW+utjp8ys/cV
         aaKorCAvM8gL7uBxExLVfUzSKgGsXTUpQzSMZ6iwkObF0b3QgiZhYZn0CV4fkjthpnLF
         v3K65tmdh6c8wcEflPZfF268C/hSvmqUYi46l3KAKaov2boE8syinTiXrke9CzU4DMXM
         TKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776660756; x=1777265556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TTkXYM3+vM/fkB3bQ583so5PgFgZAXqx93KFOXQCWO0=;
        b=nGXtTUv3kSLALK7yZKu7YBE3q4SHiJcy8TPh8ADd5tHuOydQHLHzZ2tuqWE9XJKmmz
         ldGAi6zQ1n07lu+0BOuESOFW+J/jB/2xsd37rIrOsvCepGEFT7+eHmRvwMzRVdihmFku
         1Xn4PQmLZ9Ag7eQnheSpyQ7NUXWceZ7RI0TmZKoZGrrPq9EnfsZGhSW8hnemxs6HbWzA
         Q3LyhM7WWfS+vUGgvT7IYTpRvLu19swg+sjSIyKYbmsQiOS0Bd0UAmaRMC/44xvsAAbu
         GI3uWRNMmrQ7R5eq5cydyKLxpbw+Go29wwnXM0Rd4jpLCzV97jNPBSJaezHgPDQs7/1U
         JPAw==
X-Forwarded-Encrypted: i=1; AFNElJ+cI6o4u2o+2i+wdOrVYkeMSaNp1oILoHzc8v1evEhZ6PfgMWHOX51oNPoqXxhPdXztkjeNEf88OQ==@kvack.org
X-Gm-Message-State: AOJu0YyITpUH0fhQ5TmnUX5txGkY45kpu3RBQC96sqJkoIKQvF9lsfbo
	Zzuny4lEAPEA0KndWGu1hjaZW9cMdnd8l07G3cCMl2YjN3pDSTQ/kiURUvQU9DZEqttmrbJ6DTW
	ii5iFDL7Tx7GQmul7TSLQnj23BMpOkMg=
X-Gm-Gg: AeBDietjlxhF8I+sl0H4gP9O3UeLeldWSPr+SuX2hEbbNBhviCAcOokIE4yL2y6OFbb
	Lx7cD3QfqYxPTr0rcf8Hcgp5FwGgf+qMJU/JY3CQOA7UPj+F2jFUi6cJ1LxOgXfgFMzWCWPb0vI
	XuXlbaeARmpDiNpD+EUR0cQT1QqMgj5c7MKVh/AmRcJOyop1TB02ImP3JYm+cDRaAVuPIsYHp31
	GiOO3T4bAoXZJWI9hgvMtSzlPIyLPZzH8HjvhiI+c7G8ysnWxQjMWEasb/7Rt9JaHory2nSwOPy
	hX7LDsSNzkl5RjTHMQSI/CrEFLS5Yxz3sA95DOTmyAZSeu0uxDo=
X-Received: by 2002:a05:6000:1785:b0:43c:fc5c:a9fe with SMTP id
 ffacd0b85a97d-43fe3dbf4e7mr17847813f8f.20.1776660755454; Sun, 19 Apr 2026
 21:52:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260418000635.17499-1-sef1548@gmail.com> <aeNGbNyPxJssnkbO@lucifer>
 <aeOuCH8ydw_yzdXZ@casper.infradead.org> <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
 <aeTTw4gziJigaNbU@lucifer>
In-Reply-To: <aeTTw4gziJigaNbU@lucifer>
From: Nick Huang <sef1548@gmail.com>
Date: Mon, 20 Apr 2026 12:52:25 +0800
X-Gm-Features: AQROBzDtqw0sj7vxacea9IIB6u61yKmS3jNiRESpvNHOCSzoOOtvbaVRitY5ACc
Message-ID: <CABZAGRHXtjzGJrgR1NAmVHFMP9eL5zZr3DaTAtAvywv_1sOHdw@mail.gmail.com>
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab documentation
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kcqk7ij8ux5hhduedqczm4f3js8x98ny
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E395160008
X-Rspam-User: 
X-HE-Tag: 1776660757-176900
X-HE-Meta: U2FsdGVkX19aSjga3rf2/ttA643cvBDWcQKTqNiAcpwp9bCRIRQEAuyRgG60q62EIKzhyVgOi4P5Pr7Cif9u7GOcBv2rJfeMute8HdwggbXbcvNMD0XHe2VGewaq0LXrBfzP3B3WIWVi4BV94PaGO9T0GMaMtfWeYlKrWOIrcc53vWBUHbDO/wxShzy/b22FyV6TpFD2DxZMl1lYjtL4wTC6GESAGjLfYg3wjW000BPtQDqqHGuwTgZhmBtSIIauXCXsb2n6c8Fk78OEgvPoxixfKWbt79br/+jN7v1o5KZJH4Psiorm5UW2E48lN04UnvPmoOtx8tSswr4DU/mGH1cnCaEJYGiSqHdkcVtWN2OdayKN6pJ1A0QscAR/hMTCz5DotMsNfOrjdtngv8ehF39MdtdS1ndTavgnO2fSiMrcb9cOXzhloIEyYyNbDFRlnyV/ovZZYgbHvAKAca6NO+DAME5BCUj54vB7IHqjF1Gd4A/Af5V52DxxY5bebAhDUa34M57dS3wqVEb7OCleCR/EpFL22/HvaF7MdcyV4xKknSfJ9Q8L9xQoYn9tBjVreB1f30zFzIWDChXp7t5+sSKedGKq7T8fOlCDGYX8t8lA4PiZd7DXxBg1vMKqZbdQm0V0J88qGt3zxKzIxCrf/MOkkkKliNNJBvThk1SoP2h9q5a817eg3JWGtyKlDieGG9eESS4gD2LJ+goKs0/BJQqE3N7OCRG9q4IJVIZs6T/Rukf6yDFsXHRe7bVPGm00201gR+cftgM87Oy5tAH3yKcdXegm6QpseIFDV+LLhQHhYfooJuBEPXu/zZQnA/hLhonek97ss9ohRU7/LFHDf5pBHDs4reszoR4o6rSeGQF/Z3hYVvsZ8zl4DdIzWubcbY3I1D2WL10R/bnFS6T2i8RzOO6rIchtXcL7+RVg6mdCglH7AE+JMyuxzFtoFGGay7MQV8oOIeU4lw4R0Lx
 fBj3DaiV
 Bys0z0FHlTPMKtp3CBQcmtef1UCpxi1mnAdLNdsjOoMkE0OOfmaIXRWZt1irmPQNEzgpIM5qEhGOiPBS1oWDsDRuTRy9FMdSA6Z8znRFnsT9aOxk6cHR2xs141Iijy21bN7hMBPY4jC5fOhvOViupF5c9X8xkd5IUjHFhGadEJWv6ttam5XMcN+/6y5yblinXcckDWo4pX/aeu9r/1eBjqQ81GLJH5Z2pF8evxVM/uKNozH14E6V+xSdr+XzDWPJ0c60coTqpQ1yA+5l25q45CxQJBqScL8NWxZBc1w1Pg95n+N1ErsRU2v5BlnbZ2P88MT4BT2N88lOkXhgztorDa9dzzQzF+sK/0xhb+51+3iKUQ9fCpHp0gmLupkWEfCIyZvZ4z9Ie5NBKrqNR1R92vxBY/O8f8Kc10pK4bRDIfGn6h5IKRf/nZ1x+Ooe20ZARPBVik+n+CEJKb64YQg2yrKOESKSiDGgQ4+2IpBwQCCMvOGE9As7nPCV9PGzdNKNWigd7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <ljs@kernel.org> =E6=96=BC 2026=E5=B9=B44=E6=9C=8819=E6=97=
=A5=E9=80=B1=E6=97=A5 =E4=B8=8B=E5=8D=889:17=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Sun, Apr 19, 2026 at 10:35:44AM +0200, David Hildenbrand (Arm) wrote:
> > On 4/18/26 18:15, Matthew Wilcox wrote:
> > > On Sat, Apr 18, 2026 at 10:07:22AM +0100, Lorenzo Stoakes wrote:
> > >> On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> > >>> - Add "Overview" section explaining the slab allocator's role and p=
urpose
> > >>> - Document the three main slab allocator implementations (SLAB, SLU=
B, SLOB)
> > >>
> > >> The fact you're insanely wrong about the current state of slab only =
makes this
> > >> worse.
> > >
> > > This is actually a new low.  We've always had to contend with people
> > > putting up outdated or just wrong information on web pages, and there=
's
> > > little we can do about it.  Witness all the outdated information abou=
t
> > > THP that's based on code that's been deleted for over a decade.
> > >
> > > But now we've got AI trained on all this wrong/ out of date informati=
on,
> > > and, er, "enthusiasts" who are trying to change the correct informati=
on
> > > in the kernel to match what the deluded AI "thinks" should be true.
> > >
> > > Let that sink in.
>
> Ugh ye gawds. My attitude is nip this in the bud early.
>
> I'm very harsh in response to these things for a reason - firstly, it's r=
ude,
> obnoxious + disrespectful, so a negative response is wholly appropriate.
>
> But more importantly, I want to SET A PRECEDENT that if you send this cra=
p
> you'll get a VERY negative response.
>
> Clueless but good faith or bad faith - it's straight up plagiarism and th=
at's
> totally unacceptable.
>
> > >
> >
> > I think we should make it very clear that we don't want doc updates fro=
m someone
> > that is not a renowned expert in that area or wants to become an expert=
 in that
> > area (and already discussed working on the docs with maintainers/expert=
s).
> >
> > Otherwise we'll have this same discussion over and over again.
> >
> > diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> > index 7aa2a88869083..8c5721001c8bb 100644
> > --- a/Documentation/mm/index.rst
> > +++ b/Documentation/mm/index.rst
> > @@ -7,6 +7,11 @@ of Linux.  If you are looking for advice on simply all=
ocating
> > memory,
> >   see the :ref:`memory_allocation`.  For controlling and tuning guides,
> >   see the :doc:`admin guide <../admin-guide/mm/index>`.
> >
> > +A lot of documentation in this guide is still incomplete. If you are n=
ot
> > +a renowned expert in the specific area, but you want to contribute big=
ger
> > +chunks of documentation, talk to the respective MM experts first. LLM
> > +generated slop from non-experts will be rejected without further comme=
nts.
> > +
> >   .. toctree::
> >      :maxdepth: 1
> >
> >
> >
> > LLMs are just the tip of the iceberg. It will all be developmend-by rev=
iew with
> > inexperienced contributors. And we are only willing to put in the effor=
t to
> > teach contributors if the contributors are not actually worth our time:=
 i.e.,
> > LLM kiddies that will actually stick around and help the subsystem in t=
he long run.
> >
> >
> > The whole doc update stuff is similar to people just grepping for TODOs=
 in the
> > kernel and then using an LLM to produce code they have no idea about.
> >
> > It's the evolution of typo fixes: review load without any benefit.
>
> Agree with all of that!
>
> Let's do that, happy to give tags on a patch for the above :)
>
> >
> > --
> > Cheers,
> >
> > David
> >
>
> Cheers, Lorenzo
Hi Lorenzo Stoakes


I am really sorry for causing trouble for everyone. I would like to
ask which aspect of mine was disrespectful, so that I can be more
careful next time.

If I want to make this kind of change, should I send an [RFC patch] to
ask for everyone's opinion?

Sorry, I really am not very clear about the process.
--=20
Regards,
Nick Huang

