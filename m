Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46E0C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8368B6B00DB; Tue, 30 Jun 2026 00:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DE26B00DD; Tue, 30 Jun 2026 00:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD346B00DE; Tue, 30 Jun 2026 00:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 458B96B00DB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:39:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B52061C2B37
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:39:15 +0000 (UTC)
X-FDA: 84935324670.28.90C6316
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id C75BA20003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:39:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ad7A0Wnq;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782794353;
	b=YdbevYa17s3/XHijIIA/i39C1Mo+apl9BcEKyV/0A08Soppl8jwDMYbvBXPsP7QB7/pvL2
	vwwuIi/DgQ3Z2/weJrSQoovQKWQbhpi9XTElc6+yoMGv2JlTVY05xtPZ0NdK7v50SEHzpd
	8BM0G58NVqtD0BeWyzvE8Aljihk1BTo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782794353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvkzfzattQGcZj/xGT4njtzG81mXcFmv+CBP0enhAF8=;
	b=VEGOOBvp/1ZGJZ/5JSdLlGpYNMM1vN7K7UUZeSK3vy2TBb+l5vOplsGDj2WzTMys+4/0Zf
	FQ1nb6DtdYluqxCSdIzkLP1m7S5LPkoD2GMC83XjCPN4kThWwv3f8M+Cy5xuD9nvqK3faq
	YIn81A3tfdBfjscjsIt/YbvLYHzb/0Q=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ad7A0Wnq;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10e86e52so99291cf.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782794353; cv=none;
        d=google.com; s=arc-20260327;
        b=JLCkrY3cgFgTnw3lSurJGe4OABWGHxiUS+bLzu0FRwtK+Ortubp+sZQCt4BnNmFghW
         UpNUjPxuv82W4PCDiP/LXles4I/fdWWcqm8C61zQQ42zaWqrGuqQcKREZhMsrnwQ+Ip+
         A6eN0+MLqjs7HyfVIsPZUExLJsPAZ0JpoGXAGjV9EiboRNhVH8g5qZUg0dU0glXaDdOq
         X2BfTz4ls7G+8l4CbQBKzNSs1629Cs1f7q2ciFB9dzPt3s93sUPedegxOS/RE+x/lzjI
         wzzjL7SZOkoKLPsk8Y08l4amylBZu4pUnimURJwZk1ZpKPRaLrYLlJB3aTpaEp8W/VeZ
         obvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MvkzfzattQGcZj/xGT4njtzG81mXcFmv+CBP0enhAF8=;
        fh=9rO8ZAOUvBZT6SE4pfjlsyEvWIC+ZxNbqm2UZjOJtQs=;
        b=A3b7Kh1esgoltm4N0bOcvJ7mL4IBDqFYaLkLQgK+Hj08gM3dDesuviQa0H9dDhLXVk
         Hh9nuPMCRB34xN0Geae2qwupSn6DakDeDEEtUOcsJ5iyAJhYuCyDHFXfvulbJgQCiYJ0
         8ntLU3UdU6YpksSeo3dKP9xupPYUodKIN0XAykfXWxDtFCb8zRv0yw7kyB3k5EE5jM1h
         qqzk/75tXtpCZChKlQT/Wz07iZTjPpSrddSeBU4GwNRQOyini/eBXuM8titVLySZrlXA
         jp8pkmnT9bA2+ei5ayMO4T8JCvVXLrAF2Bw/K6SSf/JWaT9/4TfwEwWliZdS1jgu59k0
         ks1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782794353; x=1783399153; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MvkzfzattQGcZj/xGT4njtzG81mXcFmv+CBP0enhAF8=;
        b=Ad7A0WnqWLkEJMngiRu/UwxsXebDL4LQE2OeAM5oFQTNPnB/3yLDYcKvblgw1ixRsY
         /iuOqS1Q2EAYoiVWlMCHXvUzwul6yY+sY1DwZ4CYUvAwjIa7cghR63EzaKT2//5tdQk4
         diCvs8R5S0paV5d+KSHuAga468zaMZq0Zeu4/EHDmhCbH8HKA01vVm0F3pjYoXPrHv7H
         xP65d+v95m/Nyj+e2cTIqCAvQbP7VldnggRhI/CHFP72OoTbnG1T90bZbiI4fj5KttDV
         yOpcSyGxkB/6kx5vlaz9f0J1I62Xc0n6dpmJBuANW5BVJUOCyZ2pLKTAytbjmukvdtOj
         xbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782794353; x=1783399153;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MvkzfzattQGcZj/xGT4njtzG81mXcFmv+CBP0enhAF8=;
        b=C8HfIFfCVh4184EyXUd4t9oLrhRLpTOjjpoerUfovs/J4gbb3OWhDn/j5uCU3rdIkT
         bS4y8geHJxvjgB8lRsTXKIqa2A8BHj74yoXzbTVv5d7xNXBeedVfEATEgxNBzoR19sFv
         DZiZYp6qKDSrNIqzQJe4or6S96ZfldnqqlaUnmfvuO+5GIXWsS6fkJuwK24Qu5yByoht
         XrvSx8iGcMja5KZgyzFeAj46xg+v3jhDzG3/KJRXTcPK5Cdror2MO40R9o/efmI+UHNL
         kqDVyBnMz4XfPmi32jK12cipA00RI/oCdkukNvq2IYpQ1KrySbRqyJ6oH0J1iVD1ys4I
         i/TA==
X-Forwarded-Encrypted: i=1; AFNElJ/t8Kg79Tfpie6ikb5OTRPaWWHi8RYkB0QwokAnokOIu0ZFCSAY+B5Tug+Hyn3FEcCftM1Qk5i7Lg==@kvack.org
X-Gm-Message-State: AOJu0YzBLQ6PWUCZFNlhTBBEj7LiW9hMXwRLeqFZ1uWQAZ4UyDptRD+e
	v38B9dPZNkiXiBBtIQ0Wle/Aq55FSglwOx+DXMHPVcpow09TdHE/1NWrWhomhTgmqNXeQo+fyKi
	s50t4GokX6YaDZNiQzAhjCSke1170SnP4eqinQE9w
X-Gm-Gg: AfdE7clb0KE3KapCS8vWMPgOSWjBqqNF0P3BBPy/qOC5M8PPi3Wymp1C363KSj5zkjT
	yBVZw2R2mHbtXrrlv1E+dz0pdaMEeMsK3t5qPnz3AQoYaZ1xY6vcsdPiMSS9stsL7TdHn6EWRhV
	ryxPCj2BUZYSgYJkG3f5PvydOuQpGLvXtcYMRIxndgUfMsfaZytEPLm1HpuWitX2k78tZviebrp
	YKqNy+IPjNQNT8IHviQuFFVbGYAD5BU7HF5nO/7JJJK8javeX/kiiQYQoCswJFYpIEvuzc=
X-Received: by 2002:a05:622a:4d4f:b0:51c:289:6979 with SMTP id
 d75a77b69052e-51c15c6ad57mr2694461cf.21.1782794352086; Mon, 29 Jun 2026
 21:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org> <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org> <akCJRTnmA2um3CIy@linux.dev>
 <akCSftF6mrsKsz1V@linux.dev> <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org> <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org> <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org> <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
In-Reply-To: <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 29 Jun 2026 21:39:01 -0700
X-Gm-Features: AVVi8Ce91qe409wtAt-8dDcpKS-nxkuJwHPbZqlJj2AUXB_x1rxhTzpVNZUiz58
Message-ID: <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: du8yf7wikdamxcy4yk6gye46iiu7ts98
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C75BA20003
X-HE-Tag: 1782794353-60208
X-HE-Meta: U2FsdGVkX194vQIafZjBakOWFEV2REcJVaHT794UxZOMNsDJQi322zmJyaQvprPNHlhmQtdrDhavUbi3VRh6Xl69AxrDHB6WVbqW93WOiyWGyCe62eyzbZ0tuyglsqoN7+mh4r1oc2cRUuOVdCUcNc6CR7Xn+HeBS5XiphodB62JUQ8ilab+kYpQ4GwtynnHGP0tQu9vGqUrfy781HoGr8E5k2mCTdL1NQc5XQAOEFUhU6DLub38cPs1zZRHcYuL2pW/+VttpnL8tIxsCmFn7MIR2KgbuVTSmBwIXv7k54glmq5Lbp4QGgSQNK06irjQzA1M7ek9fX/CbAK3GA/uuWfcEelHLIzrYp9lqtsaaZhHc788IFQGcO6SONRGWgEvetzncCb63kedDPSpTsZoxewHggkWX9++2MjpBnv14WPmuI0QTZ+4frScIMEun7TFbxkSsLIFXYS85xttyX3IleKLtmeVVOVCJJHE2jZgb5DVHvKS30I7mHwmlSPJPCiuHcFMY5ABGkmkiuRuoqL1rqlwzSc6ZzjnlzrAqrA6X6TkfcaU4VQuoyVlLpbHZ2gRe0X9jJrPcaTU90Ef4m9HP3ATUVhXF4RZWxy/vlrxUs2VHcIO94AVdn985C+S+U3SdQQeersNiDdDFhebyz34+pECo7Ppg08WaDayHpvrNVHsG2dDwMnHs5TFVRcMGY6ym/CPQOwJp+nNqYRS5+PyBKT9Q+AToHsQb1eK2haERyZW2lfVgZtDOTB6d+orlMAYqUz3QQ8DRZwr6LigOuyzjsh2f1KzrE3q/RkKiEQfQ/FhfPzLBgY80jNfgJH39i0YbNvJ3zG4dWLGf3tfHjG1w4PgBiXjn4PuU6OFwowQBSb2PCJKBoAd1J+f2kmJtPX9r81Hf0A/d7Hx3Hp3po9UT62ZGm0zX6Og+zo584CncZCD50ZU0F8EtVBlZtX+XYmc5fxhS1aPdk5cbM2F5Zd
 aTFsby2U
 LhthcOp3JgL4pr+/5ZPFrF/pc4n4895bdxyBCixmn824jg9XMkVC0sjGJKhhlbD2bZKFNMeKsGQgae7eSXr7DVTjr+mOb5fByt8jdELV70zlEetNNbyvJMSyaHyP6zgtGZHy27nWlJRdNRp/KgW6Y8dgKxCEc4Z1vjWPqSFmJRI2GRZjY6qOEAruFjBgGaUpwBAtrYcj/WIvRjeDEU5F4F5OxQlr3LtFy8VJBoEB7VNc2zi4n49Kc4TIJ4bX53z+2tnx0s1ELtgR8UF4QB2BoQoAQw31RdZuXMRm5Nnk0gbAIq1d60nG77/U+1hQ7IGybTInrSZnh2yPD3a8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 9:38=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Jun 29, 2026 at 7:31=E2=80=AFPM Harry Yoo <harry@kernel.org> wrot=
e:
> >
> >
> >
> > On 6/29/26 1:28 PM, Suren Baghdasaryan wrote:
> > > On Sun, Jun 28, 2026 at 8:57=E2=80=AFPM Harry Yoo <harry@kernel.org> =
wrote:
> > >>> I think adding a new KMALLOC_TYPE would be the cleanest way to fix
> > >>> this recursion problem once and for all. This size bumping and the
> > >>> special case of SLUB_TINY are quite confusing.
> > >>
> > >> As mentioned by Vlsatimil, in the long term, using SLAB_BUCKETS
> > >> infrastructure would be more straightforward than new KMALLOC_TYPE
> > >> because (I think) the kmalloc type is decided purely based on GFP
> > >> flags and we need to somehow work around that. SLAB_BUCKETS provides
> > >> a nice abstraction to do this.
> > >>
> > >> Luckily, SLAB_BUCKETS is introduced in v6.11.
> > >> Unfortunately, SLAB_BUCKETS is optional.
> > >>
> > >>> We could define that> new KMALLOC_TYPE only if memory allocation pr=
ofiling or SLUB_TINY are
> > >>> enabled to avoid new caches when not needed. Does not seem too comp=
lex
> > >>> but maybe I'm missing something? WDYT?
> > >>
> > >> I think we need some enhancements to achieve that with SLAB_BUCKETS
> > >>
> > >> 1. Rename SLAB_BUCKETS to SLAB_BUCKETS_HARDENING
> > >>     (w/ SLAB_BUCKETS being a transitional config for _HARDENING)
> > >>
> > >> 2. Make the SLAB_BUCKETS infrastructure unconditional,
> > >>     but the decision is made at runtime:
> > >>
> > >>     1) actually creating a kmem_buckets vs.
> > >>     2) falling back to kmalloc.
> > >>
> > >> 3. kmem_buckets_create() creates kmem_buckets only when
> > >>     SLAB_BUCKETS_HARDENING is enabled.
> > >>
> > >> 4. SLUB decides (not) to create kmem_buckets for internal use
> > >>     during the boot process. Use the kmem_buckets for obj_exts
> > >>     array allocation.
> > >>
> > >> Side note: this would unconditionally add the kmem_buckets parameter=
 to
> > >> the kmalloc slowpath. Probably it'd be worth introducing a dedicated
> > >> entrypoint for kmem_buckets instead.
> > >
> > > Yeah, this sounds quite complex.
> >
> > I think it's not that complex, but quite some churn, yeah :)
> >
> > > Maybe we could use the new> kmalloc_flags() introduced by Vlastimil
> >  > in [1] to avoid using GFP
> > > flags to indicate that we want to use this new KMALLOC_TYPE? That
> > > seems simpler,
> >
> > That indeed would be smaller changes.
> >
> > > though it's not backportable because kmalloc_flags() is> brand new.
> >
> > Right, I didn't seriously consider that option as I was (mistakenly)
> > assuming you or Shakeel would want to backport it.
> >
> > > [1] https://lore.kernel.org/all/20260615-slab_alloc_flags-v3-0-ce1146=
d140fb@kernel.org/
> > >
> > >>
> > >>> If it is more complex than I imaging then I'm fine with Shakeel's
> > >>> approach as a temporary fix.
> > >>
> > >> Since above requires quite some changes, I'd say let's proeed with
> > >> the fix (since it's one line of code change that fixes a bug),
> > >> and then see how we can make SLAB_BUCKETS changes as minimal
> > >> as possible for backporting?
> > >
> > > I was thinking Shakeel's approach for backports and
> > > kmalloc_flags()+KMALLOC_TYPE going forward.
> >
> > Oh, I misread it then.
> > I was assuming it's critical enough to bother backporting.
>
> Yes, it's worth backporting, so we can merge Shakeel's change as is
> and then once Vlastimil's patch is merged we can implement the new
> KMALLOC_TYPE as a replacement.

And Shakeel's patch is easily backportable.

>
> >
> > > Just throwing this as an> option. I haven't looked closely into
> >  > SLAB_BUCKETS yet, so that might
> > > be indeed a better direction.
> > --
> > Cheers,
> > Harry / Hyeonggon
> >

