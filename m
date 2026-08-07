Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47D1C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA72C6B0088; Fri,  7 Aug 2026 10:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D581F6B0092; Fri,  7 Aug 2026 10:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46106B0095; Fri,  7 Aug 2026 10:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7A86B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:26:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32324803A5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:26:43 +0000 (UTC)
X-FDA: 85074699486.28.53362D6
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 640C7C000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:26:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EulSD6E6;
	spf=pass (imf22.hostedemail.com: domain of 3H-t1agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3H-t1agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786112801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JwYnx5pOXpjwFV+QWoWnf2v54gIRTTlRhb9BTNCVN4Y=;
	b=alnV3oGkGs7q9XVS6s8olVedWAVzYtoY+XjziFb4TwkZGcTSxi7N6zeT2ST4/SsSYNsrbd
	ktnPaxpUkuo15HoWpk30dukuH2vWx16PY81vQclifcwosGOnthwRqfFyZnvCNffpf6t536
	v428T4de5UVUX06FzkAdrRtZiudtweg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786112801;
	b=v5yKE5vsoJ2xM68+5vDDCu/4I/WfciZRHay7FuTTysijKraP5/FHjCZfy6xzrzXG1dXmbE
	dVW1Cb6jRvKwOLdkogA5piLWsUlAWqmF7rUdMp/i0Dv/6JAc7+6M20WzjsaQYgYcFTWLB/
	Xkb7cxcdnBGFVYZBYZbRDiCcIPGnhnc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EulSD6E6;
	spf=pass (imf22.hostedemail.com: domain of 3H-t1agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3H-t1agYKCCgWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848568a6f62so5725383b3a.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 07:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786112800; x=1786717600; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JwYnx5pOXpjwFV+QWoWnf2v54gIRTTlRhb9BTNCVN4Y=;
        b=EulSD6E6jeZG7KWDO9V28WA5u2CSsdQoDGZ2ZYAw6KOtKhF/rJlKPTrFjyJJIbzM8s
         MwYyqi/udo9/1i5DAq5DkURGn/dVRk9KMVYPCeIoxTsO63CbqB7EOsh2YkKYkUsFNr+0
         bkC+mE+ZY4g3y2hWU5+MpQ3arPluUqHt7FjUIW4LBfxo8SiyFs8nq1uw25jx76dnidbv
         ZPmbDE64G4eCQk99gN3GlxWSnB3VeMzbxYWSVgZXUwbhvIJA27w6kEuEV9K7UTniRjmX
         qm2O2cVzb+omDK+5ZgYfR2B2TZXJHgyID8Uwp5IVj9xN2Rv0HgAyVHeymNqsmqJRdFzA
         DTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786112800; x=1786717600;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JwYnx5pOXpjwFV+QWoWnf2v54gIRTTlRhb9BTNCVN4Y=;
        b=qQpYQADdDQCoYcDme0vncLqttfhrcniaI6xN0Aiu2EM8+8FakPIG7wOwExDBOaBVNV
         CmGE9nyCLXk11mjpf+n0reNZsjCnZPLZ3+xnDAyEzie+OfWX1ZqPxs+Z9s+niDi5kZAK
         kLncIAa6aKURufcyUCu7IXg2cyEiu/4LMQonU9kaCEPbcoiEEeeoMxnW0Z4TJEYLQsY5
         nq5pRhv1RLUtSnWbUyM8I3U7JkqpEuofj7v7e/QkuUThDjUMaE8t9gssJB100grT6cGH
         vhZT5VM2NLTtG2qU07Do3OK10YlrLLZspqFVIm8P5U6VAalHewEK5v8BZaCd6vHx2Ovz
         ocDw==
X-Forwarded-Encrypted: i=1; AHgh+Rp7cSNcjL9a0oBBH0I1W94MzPMUhJOqs995OZ0MGfevcCLRm/QhoS3UjtRwufftG3/Sa1DGccELnQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1+66vctSdVOJrh8IVcpn1sPFBB6Abit9Ps5fq2iA33GquZOjt
	Eq6PczzRnpP5JaQIN53tlFKYxDI7YIVpp1/uYM9/AcUYJIwAcQy8E6VPkJfjptfiuyNT4EGJxN9
	UM0fj+A==
X-Received: from pfam7.prod.google.com ([2002:aa7:8a07:0:b0:847:926b:dc15])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b09:b0:842:3a98:b34d
 with SMTP id d2e1a72fcca58-84f2e032626mr25108022b3a.31.1786112799701; Fri, 07
 Aug 2026 07:26:39 -0700 (PDT)
Date: Fri, 7 Aug 2026 07:26:39 -0700
In-Reply-To: <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <anUgqnHKShicIK7C@google.com>
 <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
 <anUkfHGqI07cgSHG@google.com> <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
Message-ID: <anXrH_6oQTtDxzX9@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, patrick.roy@linux.dev, 
	Takahiro Itazuri <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 640C7C000C
X-Stat-Signature: 9rsbaqyu4ej9m8moaiggnwbix1hqqujx
X-Rspam-User: 
X-HE-Tag: 1786112801-863164
X-HE-Meta: U2FsdGVkX1+n36i4DG15hs1nrOB9LZiq9dTxew2baviTnHuuqN0TV9phWz5vg2mYlx8qMjVGFpL6s0Y/Rf8yabZw21M+mdux5Q16GmXzQaMPbnXJCu3/j21Y8ywOiCxFNG93hZiyZlZhBq9eem7ELtOLXDMnpBcnLmLSaHPSVrah9vjarljvV6WNeQj23mdgKJq5lP9MxejxxcMA54mlVtG/vOtDsasNr8dGhaxYOjwAogPYu77aRYADIRi/CW4VTegOdqlhPAdRIwPeeql64rWqQQUup6T7qsvBRxRn4zJCLHp3Q0IsyYSJAJ32GQwSeGmijxn5zA0iIC+2uG1kf5XzPq5rkqS3Xk5Lq3/A1j0lQTh0GSX6RYda8YGuKkcLlo4QnMrMB5ATI/vQJ4qID0Cq/PhSyfuaE7+kZO4o9wMPa4slHtr1LyIU/noGNaJlDOB6KTbg/A66AxlmHkS21MJCvkmEt0QdpIy5+dvLbCkIrHEiiSLpf2lOZr4sodj3jngOMQl5Tx+yRKb3P8FlPhYERkykHMo5UlTZlRQHGj2oGyKQ6dhSzWTyySGQG7Bz5msW3fnBrMorBZyWA2JhxxECVsA+xMq5fIEC2ZBF/nK9n8WQNKBsyJe7TQ0n9w50bslgPre01L6Y6LRHmbdiDMp1wdLvIMgj7qxjDfDJZ3LGYSLUBUVPD1+4z0u//5+hZeqS+4SWJnlYtkjzmHkxFyf1klaYqKy0FPlUa+EIY4Bt3EnJbNmHvlmLWObnRaFFnHFkiDBoKnZWSnhHn3pdC9Xp0dEHtQD6jSere2QK6sGvJaqc/st9m1EaLdjAMMZexgPgD4a4ataCTRP0rdd+zTiXtxS1SXcTC0/ZBJEvFTPIBeZN4Zu9o9H4YVy1nv3lMXwTn6YxQQGsGluX5E5PtJdM3Mk5ikSuGTLLLAlLzyem8wDIcbEjYKZ+iRbARUjTAYx3sKC9IL5b7OahpbK
 YRoJmJuc
 0z+1APIODzmvSzgOqUAMm3p/8eR8ByZme0l36K/AoNuhBzULBPmV4Y8sJCBU2GWXWTn/8tKTFwmX4TV/dzVgPmBN+SwUstJudKnLsbA129K4Wx9Ka6Zl1Otz6hGJJ87ul+ZcpLKzEpNnGNzx1mjx4lpdJXCOhMQ9IaLJyWqF9HCFHmjxnRudIAUQflrZw2aycSnP1EGaEHA51t+7VfFD0hD51NSKUJpwfnjkYm6k7PAz06w5jFBoaHPupcpGctsfxnA49rjhmJmVwpWaJaWnlRlbWjac2Ye8kjnQC8ym2f8AJRj89PD1siOcKzKE4jh6dikaToxbd7Jv2wfc/oXHHdMe/CyI29EqBte2oAHPxonDEvD/o3XhMAoIE9H5rST9Xkc3KWowwsC4iuvn1CE7MrLnNIbMWQBXHfR3z4DydnFGkAk7CnuUkg/unG2QTzB5USBaypLD+fG/BaazH5vrC9ytJjzcw+qBepF9h/jokfINgnhUMp3rEWB9ozBIzF9Q+Nm7hSIz9iBxDY64fpdP7+UBbc9yseFufDXAPt5tTCdKW2/Wj9QAV7ma3efLWsYgamZYpYZsPvoZEYxUu6VQbTrsMUyc/I+XEdwU2aszsPQ7+cCpGLJ3dsrGDDflDKiKm6r+o7mUYJquLzNIPzentCHz9hxvJTXlG9xcZkaWzJ0AUoc2T7dy+R0hP2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026, Yosry Ahmed wrote:
> On Thu, Aug 6, 2026 at 5:19=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > > >  2. Always access guest memory through userspace mappings, i.e. thr=
ough uaccess.
> > > >
> > > > #2 sounds nice, but the problem is that it effectively requires han=
d-coded assembly
> > > > sequences for anything more complex than basic load/store operation=
s.  Which isn't
> > > > a complete non-starter, but it's a pretty big blocker.  E.g. see th=
e mess that is
> > > > record_steal_time(), and then imagine trying to convert something l=
ike
> > > > nested_vmx_prepare_msr_bitmap() to use uaccess.
> > > >
> > > > So, unless someone comes up with a clever idea, KVM will need somet=
hing GUP-like.
> > > > Strictly speaking, it doesn't necessarily need to be exactly GUP, b=
ecause KVM could
> > > > poke into guest_memfd directly; KVM would "just" need to manually t=
rack its own
> > > > mappings.
> > >
> > > Ideally we can have shared infrastructure for this (i.e. the mermap).
> > >
> > > > But on x86 at least, that's not really a viable option because it o=
nly
> > > > works for map-rarely, read/write-many use cases.  For one-off acces=
ses, creating
> > > > and destroying (very) shortlived mappings would be too costly, and =
so we'd want
> > > > those to go through uaccess.
> > >
> > > Not necessarily (I hope). I think the mermap pre-allocates page table=
s
> > > (or some of them) and defers some TLB flushes, it's aimed at
> > > short-lived mappings (e.g. for read() syscalls to map a file page,
> > > copy to buffer, then unmap).
> >
> > I highly recommend testing shadow paging if you have aspirations of rep=
lacing
> > the get_user() in FNAME(walk_addr_generic) with an on-demand mapping.  =
I would
> > be (pleasantly) shocked if dynamic mappings can provide acceptable perf=
ormance.
>=20
> Oh I was thinking of existing cases where KVM uses kernel mappings (e.g.
> kvm_vcpu_map()), as these are the ones where KVM uses GUP now, and need t=
o
> work for AS_NO_DIRECT_MAP to be usable. I assume the get_user() calls are
> already a problem for guest_memfd. =20

They aren't.  KVM doesn't yet support in-place conversion, so when guest_me=
mfd is
used for private memory, the backing for shared memory must come from somet=
hing
other than guest_memfd.  If the guest does something to prompt a host/KVM a=
ccess
to memory that is private or doesn't have a valid backing, then it's either=
 a
guest bug or a host userspace VMM bug.

When guest_memfd is being used for shared memory, i.e. was created with
GUEST_MEMFD_FLAG_INIT_SHARED, then get_user() Just Works, because again it'=
s
userspace's responsibility to establish mappings for memory that KVM may ne=
ed to
access.

All of that holds true for when in-place conversion comes along: if get_use=
r()
hits a fault, either the guest or userspace screwed up.

> AS_NO_DIRECT_MAP will surely make it a bigger problem, but not a new one =
:P

Well, if it disallows GUP, that will be a new problem.

> > > > At that point, userspace is basically required to
> > > > maintain mappings for all host-accessible guest memory, and if ther=
e are userspace
> > > > mappings, then not using GUP doesn't make much sense.
> > > >
> > > > Note, I called out x86 because x86 has the most extensive emulator =
and shadow
> > > > paging support, which is where the isolated, one-off accesses happe=
n in spades.
> > > > Other architectures might be able to squeak by without userspace ma=
ppings, at
> > > > least for now.
> > > >
> > > > So, in all likelihood, KVM will want GUP.
> > >
> > > Yeah I am thinking that the check here to disallow GUP completely for
> > > unmapped pages is aggressive. Maybe it works for now if KVM does not
> > > currently have any use cases for accessing guest_memfd memory. But if=
 it does
> > > (or will very soon), we need to think more about it, otherwise
> > > AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you said=
 KVM
> > > "will want" GUP, I assume it currently doesn't?
> >
> > Doesn't what?  Have GUP?  KVM heavily uses GUP, including for guest_mem=
fd that
> > can be mapped into userspace.
>=20
> Your wording made me think that KVM doesn't currently use GUP for
> guest_memfd, but I was obviously wrong. So IIUC GUP needs to succeed for
> guest_memfd pages with AS_NO_DIRECT_MAP.=20

Yes, though as I said early, it doesn't *have* to be exactly GUP, just some=
thing
GUP-like.  E.g. it could be a new API, if that's easier/cleaner.  What I do=
n't
think is a good idea though is handling this entirely in KVM/guest_memfd.

> To actually access the memory, I assume the guest_memfd side will need to
> handle this by either using ephemeral mappings (e.g. mermap), restoring a=
nd
> zapping direct mappings, or using a userspace mapping. I suppose for the
> purposes of AS_NO_DIRECT_MAP core support we just need GUP to succeed?

And establish a (ephemeral?) kernel mapping, because general users of GUP w=
ill
expect that they can access the physical memory through the direct map.  Th=
at's
why I didn't want to handle any of this in KVM[*], the rules and handling n=
eed
to be kernel-wide.

[*] https://lore.kernel.org/all/aeemS2wm38Cm4qAf@google.com

