Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F006606A328
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Z+h4tP58
Received: by kanga.kvack.org (Postfix)
	id EB4FC6B0813; Wed, 21 Oct 2026 21:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F226B0814; Wed, 21 Oct 2026 21:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF066B0815; Wed, 21 Oct 2026 21:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 909616B0813
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:26:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08DB7160713
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:26:48 +0000 (UTC)
X-FDA: 85348522896.03.E880B3A
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1678A1C0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:26:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Z+h4tP58;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792632406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
	b=8DtvEbAPtPbEb9/0gUp6sZ4iqMUUI8T6JtQetmEgdPRLPZp2tp0/+hr1JzIXhL7yGM76mN
	RfedyPMgGh1ydG0flRP84XZTo+5kAjQ5Y9Bn+RPqW+v9SJqAJzotrMgGQn763PLp3YqucD
	ZyU4Cr0b/Rf9kPuBAw8l1RDpeB3rtkk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Z+h4tP58;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792632406;
	b=G4pFscRomLSfNJEyM3yFVu0ZV0E6R/VaI/amWRxjwhXVy5sQQGOMn8hRvFXw2uJayx27Dh
	OT1l7JVJCK7I9itaOkPzIuFj/fkazKoziDUD29dlznCTajTFOODiLdFz6Y4mztDt1N90XD
	zN+OyE95F1aQBApipZBQHtIvT2dinN4=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b1f4d8e09aso1997398a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:26:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792632405; cv=none;
        d=google.com; s=arc-20260327;
        b=Bdl/iq9vM2ZnULHsTVgPVhyjrVBLRCE5+s3kPXePtNRkp2lODlAXhNHmXPmISgiESW
         vajhL9cGezB+r9DjxR1OlPUIEiwljSzkN4q8EBL2bA7oL9NtKDiHRbAeqOT6UgOW9MZw
         18S8Eiq7Ab2i5vG2uTrr5NZr+EeYwl6e9RAbOBOLwYE2csb8JHtvaCVwTqlZy+nkZvLy
         /ntVclUkaI8adOP9sDcpWcUtJqK29q0ePfQQCiIBNmylL0Ar4WUTKMC8vkJFY27hms7q
         NySYqay9TSxx8N3A9hKBFmQESXeFyGQrj4VN3bN904WEFY2SHOuucQ1wIobwITPII/LZ
         oP5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
        fh=CUHnOGIgs8nzRMdrnMe3u4Kxax15nSWsQ5pkmD4Wmos=;
        b=olg1ysxvu6d8SuyjkXaiFHFW+FH1aFak3Keod/L5GnxZTexKG/JEdEopYI376tHCtP
         nFItCx/5ZYPyJoqOvpIl1v+hA/w//4ujg/1HpU5ImsEqm8xTJ+tbJqq0LZmCxzcWkhC4
         Con6z9sf658AUNrQNaERK3qpBMEogMTWZCbDNfpHWJczeIyTUd8Abn3I5jsePHOJybh8
         rZe9xLeWSp1TU82n9oAvuFq92rKcHUTSPdknYzcZPZLhBBx9qqMmDzf1pN2re8DjoMUB
         ZiWNvGLDUghtpSNLVmGz6jFvQHjk4teRYuiKvbElJdiCi1A35dptHXMu5NR5GxScNThL
         LZyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792632405; x=1793237205; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
        b=Z+h4tP58lYdPqsc2GcRJgdXMr353eilMvbcYtoShABJsO3AY8uk7OYxFN5cCRyFxrk
         uYYMO9nltaqkcvupOVgp039jYnvjth5zVi+aNlTIcucx/cUMcGG9nE9INxrBIKvW3kDb
         C/J7C8fmcbKLyleALm1tPT3tegc805xWFqiWMUvryksqccEkmL1rh06qDG2Dk3yjL0Bw
         XFeCB8t/1zYp00Y19pjksOpsAQcq5c7O/h3xr/zpmW08CEvWJeYaaL79KdIMRu0y55uv
         H6OF/vgLUL+TX1UXH8pGEwmzCrV343xfPHGq5BwhSPGgXSi6p44cgzzeISwPAooGBpMX
         699w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792632405; x=1793237205;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
        b=PPURU9CwCOUJhBWzwcgj6cFlW5vyx0UFX7yY200fdXUVc3+rNNT/6ZaKfI1BjfJ11h
         aJaQjB0pQRU7nSGgjpZkacjHpl30pWiJNar3wnfjzhTrtW+WtU+D6WW4phMenhMuVQki
         6LhcNue0phdhViPuU+lpoUCuVEVMtd95q/wMFGyk/zz1CU9DiYrYAs24gM3/h0z7kVRE
         6Uv/06V0YuxQTO2ydBW1XlfNmqtudW4CdN7zy4KsKBfVlhq0j9yIBYOVuIjkp7cBtjxF
         gzsR0xIjPOOF4nMKYB6p/avKREL7l9B/WAcsU3XJd5LahHtMEiGk0mpWvf6ZZQtkaTw6
         m91g==
X-Forwarded-Encrypted: i=1; AKwUvBz9AvvUPfpquIXKRV+lSgRu6vSeAKDvvFaiEY6CvuLDJHtZvSLpYFgIE00dvXKvZMIpGa4nJZI+gg==@kvack.org
X-Gm-Message-State: AFq9FYJUP927tqua+AfwmT/28cdZcnTLJqQuPBTzTV4qQGbRY29VAXro
	/OumOENRZXzcYMd+XWfZWk0QXhoKFe94T+P+5hd1GppvQDF4phEgIjvTCphu10BXK66u0d8fxCK
	G1M7QIKkj9fvf9InEggzvlDqLVFyQJZLBOnxWrZC2Og==
X-Gm-Gg: AYBFou2qj+9CtQfs+MReW+FV8rU7TgFuq+pJrmCUkMMuMJS4TUy1P6jXzzM8wffbMxH
	VlCCbmwDSIayc7WWor+CiNq8eVWTZclWqhkzlYAdEmgj0z3gEgqLQtNHEFNbC7uOXB9N4r7nPsP
	YncZaC1nJLtKA9TdsqGo9jMdvEq2ZDX8JyGFp+hjxg9HXo1VmYv+f834uZ6I83CHbb0707I8yZm
	bBgDfDjHP+0jZVNkuPekb0MwJy+Kzxwd+NRnU4o/YFZGuVQzXT9oRRJnxYoyJUtaL5xgyR7RrMc
	ykoUM6OcUM792x8xatUryyLUnA/y8quTrTTTBAS1tAovd/iP5NAlsUEcf9ktuI/kYjHh+J1vKwy
	09BVoOHG+ucKkoYqLC3k5dyh+Gck/r0YVCPv2NK68KWT1SwgP6O80WdIkno+Qt4h/1P4=
X-Received: by 2002:a05:6402:2801:b0:6b3:a1ad:ef6d with SMTP id
 4fb4d7f45d1cf-6b408dcce19mr2969744a12.6.1792632404378; Wed, 21 Oct 2026
 18:26:44 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com> <atlKsD-aJB3mJr2j@google.com>
In-Reply-To: <atlKsD-aJB3mJr2j@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 21:26:06 -0400
X-Gm-Features: AclHuK8Appp8OBdUFGLxu0V1hBTCm-a-9f142JZiexa4wOQOsDrRrU21F_J0R34
Message-ID: <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1678A1C0003
X-Stat-Signature: 16t914arttxrsotr3mq8i1nnkffi3w39
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792632405-288569
X-HE-Meta: U2FsdGVkX19RcMAuDnigqatAzG2bnkJoOcrYqm6YFzJ8lg8zOWi9I4Ku3//KzoRajumsoXHAVgvSwuYjJ4sP2xA8b5XJifAB4ltSU5VhzgxNmedkXVPjgM8vQuVvrBCS/XcYkLU7ixsUfHeYqhldAyhXvGOR25Zy51bX3PUQAKaTSpB2mjtBiHhIScDwrgcSaLbwYt9MIZzYseq5qrqlz5c/jrrNSyHRfGNjOaPWF2wkb2xH4C4XjnhkEEzhRVpsY8VRF8+sJ7XEMuzqxbc+PaIPhiAWEhgpiojHzbTt2rLqBCFZE+TNYI0627W58vw/WjYzRSvviMpq3liEgEtdJuDcLRThctw3dLtmhtyeLmrXsGtHfzAkXF29LJzqH5+p+29Vore/gTI1rDGCO1i52P5GTWt2qmh0oqrv9k+gIotnLqlrTFevTqQF+kUMG35qCkxfG0glWp+NYfUTiba/SE+xUUa3YwdSnWtzH6ccaTB4kfmuxNQkGivjgFpWOVYUvaqFC60UfshuUr/JNKP208j84y0eDetRmorSnzc+xGkp715kc57kaKrZMwrrzK1xxc9TbyLEbOC1dje6cI00HWhLQg2fJ8yq+hgbYvpFDEW6fWgWm2Oq/TOKaJ/JX6lggS/SadDAjxObrGs6/JBLavMmxlhWvsU3YAxyi/mdAb805U9fGtRrZQBMwnYx7KpTZmjHeYZq+BrzQmk5ng7bB0ZVxzhSIXGAg7mS61T3Cezw5X99qsT9tZySl8yJrj/1/hYtOPBhLmhYHhSfDp5Bdvd8uCdmK7VTESh0k1HcmLYc99CDeKdEi7EYjJ2It6s5uHdeZfyyeyXPfMC4j6oLC13dg0utMYBfuWxzQSspkhY2UWs6IIDgYyxD9fNpmKCi0xqz33vrFg9Z/32IxmDJc1JxCzYSRSA5Rt7/TJ3E2SQrHYCr7VHisph0i6kmz9YYN+uCVeZHOTojUdUiQyu
 EaiAB3hD
 8M6eE7fQVkjszI+ZwR/ugU7qygWCypEv0CwzHUmpMH/OblRfnlJ1PZ82e8pSC+W6+jqZ5/6mWMB4T5z+RA957tTgGNLIGJ/ij/A9rpWWwVrSrxKYkoqeUYRd7fMXh+10G0+vXR7XNNEFUlCytst/W6nsrndVOKKONEhvr8Scq/ISf4LS5ejNIYxmKn5I6w8mkZeApHueb6eWPAfYCRDQLjMtrtzuc10MT+7npkGWm/BZw67SFuwQ9QqYljXhEwmcYAesKMljQs+NihDoA3DUNKuhwIP0tRt1/L2lfA50xB48RGWTzsWc+J00Fvp9+XTvbqEdN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> wrote=
:
> > > >
> > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > >
> > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@go=
ogle.com> wrote:
> > > > >>
> > > > >> LUO and its file handlers validate handed-over state with monoli=
thic
> > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a se=
rialized
> > > > >> structure, even an optional additive one, must bump the string, =
which
> > > > >> breaks live update between adjacent kernels. Replace the string =
in
> > > > >> struct luo_ser with a feature header, so that the target kernel =
can
> > > > >> accept or reject the source kernel state per feature.
> > > > >>
> > > > >> struct luo_feature_hdr is a fixed 128-byte header: the serialize=
d
> > > > >
> > > > > This patch is all wrong; 128 bytes is far too large. For every _s=
er
> > > > > struct, we only need 8 bytes instead.
> > > >
> > > > NOO, It is not. It is intended to avoid complex mess with unnecessa=
ry
> > > > over-engineering.
> >
> > 128-byte per serialized struct is not starter.
> >
> > > >
> > > > >
> > > > > The first 4 bytes are the size, and the next 4 bytes are flags (i=
.e.,
> > > > > 30 feature flags + 2 reserved bits for flags extension). The last=
 two
> > > > > bits of the flags indicate whether an extended flags field is pre=
sent.
> > > > > Each extended flags field is 8 bytes, and its last two bits indic=
ate
> > > > > that yet another extended flags field follows.
> > > >
> > > > If we will have dynamic extension of flags, Think about this.
> > >
> > > To support dynamic extensions in a backward compatible way you want
> > > something like this:
> > >
> > > struct luo_feature_hdr {
> > >    size
> > >    flags
> >
> > __u32 size
> > __u32 flags
> >
> > >    extensions  // offset of first luo_feature_extensions (or 0)
> >
> > __u64 extensions[0]  --> but the size should be specificed in
> > declaration macro that I showed in the next patch.
>
> I think you may have misunderstood what I meant. In my proposal,
> extensions is an offset to the first extension, not an array of
> extensions that immediately follow the header.
>
> If the extensions immediately follow the header, then the number of
> extensions is baked into the struct layout. Every field after them sits
> at an offset that depends on how many extensions there are. If we ever
> need one more extension, all the fields shift and old and new kernels
> can no longer read each other's struct. That is the problem Tarun

We can structure it cleanly by nesting the payload: something like
struct { struct header {...}h; struct serialize_data { ... }p; };
That way, the header can expand dynamically at the front, while all
fields inside `serialize_data` stay at fixed offsets relative to the
start
of the payload.

Since the header size is self-describing via continuation bits (e.g.,
the last two bits indicating whether another flag word follows), LUO
can
easily compute where the payload begins in the incoming blob. This
keeps the implementation simple, avoids linked lists of offsets.

