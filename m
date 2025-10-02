Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B10CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78808E0008; Thu,  2 Oct 2025 03:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EED8E0002; Thu,  2 Oct 2025 03:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90ED8E0008; Thu,  2 Oct 2025 03:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 968268E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:48:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06B9713ABEE
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:48:40 +0000 (UTC)
X-FDA: 83952397200.15.D4D3EA3
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 252FA4000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:48:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="VD7/6vLQ";
	spf=pass (imf04.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759391318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaMCyd365HqjUCgEcANKW5Dc325UlPuInMIKYt7GQt0=;
	b=w1aFaxT3y3ZHUhyUieixpyzhDGjpa1PDi5XKYOHtxZm796rm96bmZCGZn+S326qtLZw4Ch
	uf3vmuQ50VNWf0BBm4wUKi4B0QA7nr3+uVl3zQA68d456Vyw/69jQyCCDLrOcNUxsoX69Z
	CsPXzoNVnO0Br6n5B4CQnVMJ5i92eXo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="VD7/6vLQ";
	spf=pass (imf04.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759391318; a=rsa-sha256;
	cv=none;
	b=zrgyhxgAN271nRSE2oVbuHi3SJDgJ6OLBuRyBvUuYKBtECJzRG4YquQnBrzf3Wk2YR6rhT
	GswKIWRLPuRky2lyTxowWJExWW0uLSzMwL7GpsJNXohzPF8cz5Y/i+mWzEWGlmyrdSLBBJ
	4N5cDL0Djikrpv8UyyLeVCTRnhR74nk=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so5580a12.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759391317; x=1759996117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qaMCyd365HqjUCgEcANKW5Dc325UlPuInMIKYt7GQt0=;
        b=VD7/6vLQFHTL2zvW/CGIvZdb8gq8HTv6mSLMU6g4vkZ8W/Urqp6pGAcu1j9cE9yXIs
         ABFn6a21ffS+uAhsZXo51O9w0jPtlEWzlLsLG66rxDRgXC8I0ROQ6XTr/e8CqpA3FVMu
         vTgvLn2E8zlABaRzl6pw7frwvo7forlWJ//sa7JA4FtZk53wvoiDynu0w9MLjL6Usub+
         gQDlCAFi6IE4FauPPP095G10PuAPfDTcFfLtmOBAZQmDVSl4LkR9dwBLMMJmv2O7AZIm
         NCR2CmzN22YWWyngtcMF/onT/5bsU3WrrbmzTlNBEVOOwgYz88t773eheKd329dg9P5F
         LoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759391317; x=1759996117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qaMCyd365HqjUCgEcANKW5Dc325UlPuInMIKYt7GQt0=;
        b=vmyVF079FkVDcpXpX1ochniYjt8dX6FBE5BiHNaKmZu6+r8h/otD4MqH9alz/u1Alr
         C7htxDf7DxhfQ3T3YhADZOYmimOYYrQ61njYJHmIpA/DyZYLGKCN1njoKKnn4DZjpTGg
         3MZuMWSzkZpFp/tCG5iQsxJ9vkj98mhtgepltTLP1rYtWqMY6wSOT4hDvJHC834WeTWc
         i6r/USwhow7X3kYLDQ78DDDZQuDyig5LetxVGV2HKR0NjHMOirHu/pED8rzfMhc3ZXi0
         1vRhrsN4vO0DSfNjbHc+9ZHiU1+5Js3bi9RyowvIXhuVT2+3ybTVpW7EuJxeFRGjE792
         /q8g==
X-Forwarded-Encrypted: i=1; AJvYcCXtFlpiMtUFyzaTNXbqGv2KoIG7G85aGFQeOEyyposi1ighF/VRGtEwNgaSlzZ5oCs1iJbLTumynw==@kvack.org
X-Gm-Message-State: AOJu0YwOP8rmeH9vLa8J5Vfg60zZpR5yLolfK4XptijImUSA5bQRVcQs
	G0IU7XRvffvyYPbQcX0WdyrlLM9WWpsMzCSAJXDhub5Xu7rB5qxiUw316drrNI7UtSGYoIdTuTt
	MpAGVLlD5NKJOhYONwzPD/iFqrCH4sTrdIG7pVUVv
X-Gm-Gg: ASbGncvIognieq+AlaRW/QWmCCMqV4PMGFVJhjP/VjmXucgqqsz+0xQ2v71Q8mQ543Q
	RtFcGZ93AIMc1AHThxUG5SVvsK2cQk/LKxZiyJz5DeG1rswyJQGdgf/Bks/9qfRHjQwqsgFRqQb
	7FTOOcJr28pqxb8SdBlylWQEucTzvDTVAW5c6qb48LC9FxGbcecPyEuVjyg7UHeXZgl4NnWGuoo
	OVZQ6CCPHyllNb9KSHL8J2JQKi/EF8DmDeahYhLi8tQxFcym4NBwhNryA0+QBhDQD+mN8w=
X-Google-Smtp-Source: AGHT+IHbSf8AxhBNwSY6l2em3dvUQkF4NKMAFPf4S8akCNQ4PN/ThIsYfxHtUlYMoa4/Wrvttpf4ooWEajgIDfcMwe4=
X-Received: by 2002:a50:baa3:0:b0:62f:9d69:9364 with SMTP id
 4fb4d7f45d1cf-637e1653c4emr46248a12.5.1759391316176; Thu, 02 Oct 2025
 00:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com> <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com> <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com> <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
 <4909d194-58b7-4e94-b730-f916100238d3@redhat.com>
In-Reply-To: <4909d194-58b7-4e94-b730-f916100238d3@redhat.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 2 Oct 2025 00:48:23 -0700
X-Gm-Features: AS18NWAQRxKT8_i90yjxjvofkGTlb4fxvtIEYzb9hAaeCuQcGRtrWIaC1n-ptRk
Message-ID: <CA+EESO44kZ5_tgsBvqZGHz=8DLbBumSSCFptW8EaY59Yws7oew@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Alistair Popple <apopple@nvidia.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 252FA4000A
X-Stat-Signature: ggozzdfop9np1i3hntx1554cz44s7trz
X-HE-Tag: 1759391317-443596
X-HE-Meta: U2FsdGVkX1/z2Prjv6T553jizBsOhW1mH4Qu0X0VUHqOfPiTDOJxipg3buheHwAIKPlws2Vmvx2VHroFNF4DLCzlSE5j3BEY1OxEt/gDdaXunDAoWmdTBKHsrjUbjXGbHAKcAtphRk7L3E8EFj3NdddZDNzDoAXa4YqkGP4e9yhZvjhIl22kB7aoVWBA70Tkyj1WnKBtUyKsblK2npFCu+3Ww5EvM3W4DPHBYPL4dEcqgan7iRKs2oJhqCtEbsv43TQKl3ImZ8x1+n1oxZ7KKF8lYUKyofqeunhs8WV7CDsrzJUEv51czpjXxrLaLjAWC7BRwJKpAjFyf+pWL4In1bM5K9vjpCEn75dLcErTE/5fG4HxJanoUiw+N7QMZwsWX8hINCwiTm9ldZWdRA1MTYPdOp/WjZ7RQPeTuXkuDGRu4k9QmGtNF0f+Krgyx8H0+KdooIMiIzLBonp8cAPctsEz8TrPc92aEGSq07LD36HvG+ub8VKRYIV6kKdIeCJK1xCs6AkjPwSSdxWrBt6fjRaQPwtjRK+DIsAaSWL2w5d0qGxmkMPlh7fpGj0GC31imLJPdJoKYakWY0WJghGChmqWWvYP03CQ/jJGO0sZqBNY4Bre6FqkJZTj/r9bKV3Bg2DJ00m4NGfgFgf84neuBkBsTe2OU7USaDiGLWwymP1uT/mePtqVjYk36bpb9Y+gTMPcaxKLK46xvfMIwmbL6ZdAdzHawCDzKMhp43lzdV4ivIRukdpippF66vIuhgYz6l1bHGsR3e/OuXbuAqL4Ez59/BMiSr6mtaDX31EMs0boze3Ctng7EguALJps27oq09pDFUVzYZID/KAe5UtMXYFW3V5dB2L5XvGgyICbYYk+nnxikDYqCi7yF1n7fZN348x/nmxwDluQ233fyIBpLeKDVTS/YDIhw1KCXg9vIUZbraiWoc5O3tBXOJhUKJyadP9JXdx2h3jTS/bnqGk
 eduBIIEG
 vTPtNX0jVx16HpHaL8ankmUE+k/HetWywAsCuZm+vz/DI0ganbyBD/rcfJGGCceshXVJnpIL/B2M2IAlJPS04X/JG03UfgFE0ED0ToAURSrCiPvkaKxqMc5rGtMojxWHiF3L6fPUkwtb4Qdeo7yEHyn78FlWwpp/fRO1uaujjhwRZVV/euCaDCK9kYMW0Gz9mgY6DaaUlQCZ/zyvlYW5w8N3A5CbK5rUiZ1cKyM0FE2zvFw1fhVknxTcRBAm8n0Vjv9hzrR7LdUlXWsVzwnhgdKa4ZFyea1zrFbL4NR9amMNEC4g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 2, 2025 at 12:22=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 02.10.25 08:46, Lokesh Gidra wrote:
> > On Thu, Sep 25, 2025 at 4:07=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 24.09.25 21:17, Lokesh Gidra wrote:
> >>> On Wed, Sep 24, 2025 at 3:00=E2=80=AFAM David Hildenbrand <david@redh=
at.com> wrote:
> >>>>
> >>>>>>
> >>>>>> Is mf_generic_kill_procs()->collect_procs() problematic?
> >>>>>>
> >>>>>> The dax_lock_folio/dax_unlock_folio part confuses me: I think it o=
nly
> >>>>>> locks an entry in the page cache but not the actual folio ("Lock t=
he DAX
> >>>>>> entry corresponding to a folio")?
> >>>>> Yeah. The name dax_lock_folio() gives an impression as if the folio=
 is
> >>>>> locked but it isn't :)
> >>>>
> >>>> Sorry for the late reply, I saw you posted v2 in the meantime.
> >>>>
> >>>>>
> >>>>> IIUC, a dax folio can't have an anon_vma (folio->mapping is actuall=
y
> >>>>> an address_space instead of anon_vma), right?
> >>>>
> >>>> We have these weird device-private dax folios that are anonymous and
> >>>> should have the anon_vma set up.
> >>>>
> >>>>> So, I thought it wasn't
> >>>>> required to actually lock the folio in this case. Please let me kno=
w
> >>>>> if you want me to still lock the folio around collect_procs(), or a=
dd
> >>>>> a comment?
> >>>>
> >>>> I think we can end up reaching memory_failure_dev_pagemap() with an
> >>>> anonymous dax folio.
> >>>>
> >>>> Not sure if anything would prevent us into calling
> >>>>
> >>>> mf_generic_kill_procs()->collect_procs()->collect_procs_anon()->foli=
o_lock_anon_vma_read()
> >>>>
> >>> I must be missing something but dax_lock_folio() dereferences
> >>
> >> Maybe the code is missing something :)
> >>
> >>> folio->mapping (to get to host) without checking for
> >>> FOLIO_MAPPING_FLAGS presence. If it were an anon folio, wouldn't that
> >>> be a problem? And then in collect_procs() we obviously check for
> >>> folio_test_anon() on the same folio before calling
> >>> collect_procs_anon().
> >>
> >> Right, if we reach dax_lock_folio() with an anon folio we are probably
> >> already messing things up? Not sure if the "!dax_mapping(mapping)" wou=
ld
> >> save us, likely not, because it would be an anon_vma.
> >>
> >> Hopefully Dan+Alistair have a clue how this works and if it already
> >> works as expected with device-private anon folios.
> >>
> > Hi David,
> >
> > Any suggestion how to make progress? Should I upload v3 with
> > mf_generic_kill_procs()->collect_procs() in folio-lock critical
> > section?
>
> Staring at mf_generic_kill_procs() once again, we have this
>
> switch (pgmap->type) {
> case MEMORY_DEVICE_PRIVATE:
> case MEMORY_DEVICE_COHERENT:
>         rc =3D -ENXIO;
>         goto unlock;
> ...
> }
>
> IIRC, all anon device folios are MEMORY_DEVICE_PRIVATE, so we should
> actually not succeed in this function and just abort.
>
> We still call dax_lock_folio() earlier, which likely doesn't do the
> right thing for anon device folios, but that's an existing issue.
>
> So regarding your patch I think we're good!
>
Awesome! Thanks so much for looking into this. Can you please
ack/review the v2's 1st patch also :-)

> --
> Cheers
>
> David / dhildenb
>

