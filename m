Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED334CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B68F6B0005; Fri, 12 Jun 2026 13:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567D66B0088; Fri, 12 Jun 2026 13:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F666B008C; Fri, 12 Jun 2026 13:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31A0B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:44:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB78B1201FC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:44:25 +0000 (UTC)
X-FDA: 84871984890.26.BBC8DC9
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id B157240007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:44:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tl4kxtiL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781286263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvH91KjfgwfGM1w/oZyTbnAZEq6BaV0f63FH1RCgTj8=;
	b=bwEkrL0QdDwfJXMSqGQpWy3hpPsgVS0rlcj6YhgxpCT2ksLXpHWuuIHrByNt7cVR6Pmtkw
	5AF7gjt7LRA9empYDpAU3T1vIm6N30w5pM9pgaQ7u+3f2JCxkjfiUWtKNE65NQcqX8mFHb
	sZ4W4SGiMM0jQfGo46//PEuvPxbo3VY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tl4kxtiL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781286263;
	b=OgMI3SsEb3Zx7Qxi7hdEgU1y8DlXcdi/ZEV4avhrlRHQLME3MVL06tDV3Jk6ZwfMbUfBMF
	j04kS0waGU6ZuQpygsrBGYLLggiu8ZkGDzZoaiieJCQUG9WTS8deTBl/PvdlUmd6YS00c6
	uEcq5REy553s/MaSRg7LXSqoRU5wkVc=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51765531803so41211cf.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:44:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781286263; cv=none;
        d=google.com; s=arc-20240605;
        b=TCVS1ZKQR7KTEfCMjNM52QnsB4BJctRidGo6L1mx6pysCPo0lFYIMBFEjBvqslbQ+L
         6s2/wgfoNNFOexlILk7w5KN2dsBkLEtVOBe1dlRCQKGK74PgKStxOR4PZiAatgaGfndr
         Zb1l5DKeta5KjvTTKqjFQ16dVfnAY5/uCVU/ngP9KXDipiPHnLns5J1B68i4eIEnvQ8c
         CffHCiy6MpL8WumpQzl+jT6lKJpyxU+xhdrJfSW7QvZXwsOZd8XmXAGEJHsCdK8i9eEa
         oTUQZvDBugmWmA0QmdLzpndFRVt38Qropt3jC2W75UuICCPYxVoasA94uK85JHu28ZPR
         BJig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jvH91KjfgwfGM1w/oZyTbnAZEq6BaV0f63FH1RCgTj8=;
        fh=g/o5Ly/Ucx3iVgHXXFbn+wCUSwp8shJ1xrsm372G3xs=;
        b=a/6dRhSnzcG9LhUnsz3SJVTUJsBmGD9H5piczRyOyZl42Mee9seVeM8dpz3AKCYaqn
         Gz2e/rUxiUJMDOCCQtklPQlQ+Mp9zPKzJIEjk9Pb6QzQevzFLzx+3otprd7bvIF5S+rL
         bCQL5hzQzqeYs/a/FPYCzOwonwqPSxGyZsYIP0h+HaLcD4x1vXz1z828zntTz+qIE7XE
         fy9ZNS99MeLM4savhzDRUjetngaDFOgzMPlKsw4zKSu6ljWgHv6jQIjAjVLPTaQlKX4Z
         pikq8cq7PFRJzoNlLRMddLZPBwpBAvenQccrSKlUfbvfeBS1htpXibwbFqGx6WiVbyWH
         48Iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781286263; x=1781891063; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvH91KjfgwfGM1w/oZyTbnAZEq6BaV0f63FH1RCgTj8=;
        b=Tl4kxtiLp3uQa0B/aRZtSwS9Y5m23Dr8uJmA87sJgYTFocblGtFM4StDMBtAmnM8yv
         8PFCzNfVos3w4VqDUMgVXbGsNhLw2f4J3aG8bVXS/GH1bGqqNE7CmMeYEedScURFhQ1K
         IcOI/hWzjvA5qD4AjjHz9Ngxne6FZ22E8bPRUixBFNELoJaisM/EzLHvZq9Ej8BVqPRl
         mgKrdyDsLQAONQNZpscoPwNUL78DEGKXv5VVhVUlgyn+mdurtLl/K/4wNvR4ldr6qIyB
         9qMHyHytcZ21tIUnUqm64JPgo2ssla/VvR44BRM+XKcY7I3TVtzAigGQnctyvBzd1xaG
         MhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781286263; x=1781891063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jvH91KjfgwfGM1w/oZyTbnAZEq6BaV0f63FH1RCgTj8=;
        b=biD7na0QWXFCVDAskV/yGVpLDAvh42gz2e4oUSb2Niu7Foi78Uby4yVPuw8K4TL5wT
         NLcNoa5Kdxj4sC8e3bavd+E8TL3dG405gReuC/PAfSiea9OSLyAQcCbeqKC3fPVrbCvG
         9Mi6y7JdBqzwnWU2knrzITBqpE12fMm4ybRgBS2BY67xC1hDRuTfD3eCmJ76Ee5Mspj1
         /oPh/M1dFfeN9JCM+GcLP58Sv4g0yYZFmEpwHUVwFhFzNwi/HxEJqjvWL/mBe/uJnUS/
         E9Bp+Tz6f/bX6NvZFvgxkzOxynMrwD67lfI0Rkzi/1/kM4Z2M/LcfwcfH0NvgInoa/CY
         eOTA==
X-Forwarded-Encrypted: i=1; AFNElJ/YSnSRyfS8bTpE+hZLFV+xReYtB0I44zA+G2nDdfdxFF+AQN9Nek2NMBzaSCQYN278S6wPmcpquA==@kvack.org
X-Gm-Message-State: AOJu0YzE7aTAaYIP3O8GqrpOa6/BG2eWWKxBo/bHuShbWE65v5shOOXL
	CcuJk0AhXpiL8KuOielmMCLGQ8XDiMYtghB7AlqVx6ORHu0rDQW6z9pV8hvpvTjaetGKkTGUoHw
	vefZCYT9smQaYmu5vqRlJB8ecwICiFpeK1WMUzuKj
X-Gm-Gg: Acq92OEzkG58/KVQOJO01OnkNDBTWfLR+V/4rJUDcJFTfYKV/Mism+U4UfedbWBT5Z0
	NgP6Bseko+CG9aypJamVGFQo4q6EgbA5Wx+LUDWE0810FCf89S04FWL6HXpEWGJQkbUqe1YbP7H
	bPFDJic6eGPcWXFAvwq6v5SiSBVKexHGvkVh57tYVWBKF9QXWs6UFNmht1fyWkNZcEOuLrBwaVO
	V4pGkeWIb42qb7tATiMfnLNnMpXaCFhh8DDkqIDUQGX2qerUuUf1lz3hSBIg6sNnxlSlImo6Lpx
	D3+7RQ==
X-Received: by 2002:ac8:5a0b:0:b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-519549f51e7mr524351cf.12.1781286261753; Fri, 12 Jun 2026
 10:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com> <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
 <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org> <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
 <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com> <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com>
In-Reply-To: <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Jun 2026 10:44:09 -0700
X-Gm-Features: AVVi8CeRCVUJzted88F_l8zeTuoKptNmS5kyY3W3pYtyspwmpDSJybClcBV4DHM
Message-ID: <CAJuCfpFo_avdhpOviX7EsPqLgDJ3DfeGpth+yu1-ahfawqaSzw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B157240007
X-Stat-Signature: 36e6dj9cgxrm6nkuexz1izgwddp1dn45
X-Rspam-User: 
X-HE-Tag: 1781286263-273309
X-HE-Meta: U2FsdGVkX1/hnhl1UMDIXzv18HOjUOvsX4FuLutjTm3PIGWmkUUvbsyrTGWyJ9b23nddEsJ11FzGvPNZTnIfS81ELeSqg78rYZa2iBeCaKHKVH4Cm7cz5ewtCM2a4lz+eX3t7+PyuOeRVuYqV0KfhCvMK3YA+2Dx3POQswlJN96e6nnAGMffNXgvVoZh5+O90kQknP5D8WUJkA6Zmk69pIMv0Xfg++KikwoFW1O7FppHNF9iYqPPVBMsaw4fCJQ569AfqudQddcPUCbLpiF0zqAEFOQYZQCPeAoz64CSu6G9fOqh3MC1PdbdHeAMjtbJao3Ky2zCZCPBi3srXE9v18NSo4V8JJO6UhAnF3xgiSssXnfqXOHilfwq6NRdfZdcydcrSHgStSJEpqMVQZyUsXAFLMMN1TDgYiUhem0B3PiFE9NDrsT/hXkTDcZvwuy4SV6/yyHUheKkDMFCUSc6O82kwXRHzkDyuuwuhdxaRFAzCQOJ1cuHzd6HXI52mcZW16mDyYr9xAfYvYXzdC/LAXTEw77UEzhUb3ziY3BEJILXZTD0UYfnhKlAompSsbK0nIMN4bU/CBrqLmJgVfs1UyuCU5r5ThSGt754N3VyGTfBxJ4cX8mG5XbX2l4HQ6+9BilfqNy2fPe3n2yGhDNrT8u07o8PNNPcr2adA6rJmKe9MD9qXNvPKe5JvKJzwguvr/L20O3OepOqGnp5mmCwGnoLG4QYJ/pcdwinpQpKYT9NysnBiXaIt5DdXzrtOiPkZEkiy6t2U+2MAs77DzRKS0agKHkr5gnx6syaJ+sibDhT3s+qmb4vb2eOLbALx4izrRKTHvuM4m4TA76Fctj0wjUmVvxeIDyXizLSpdE4qS8qVV2NBnhHjM2Z28McwlHaHtRAhnHWPhEdcuWHYiA1GLCT9mj3gW3k2OCKF+TIarAsuT5iaseAr/j5lYETauhm+XrmA9g2ZwdZPsDsL9m
 qrLZa45I
 UZnkMJZRQfe52VGMPsQ5Ov6pzqQa1+7U2CATis5nyfUHnHKy1CZBiOtoXmuCiT1JlXn6r4Fbh1jRjn6afXj51Tjejz6sKgSpm5Uuu2txvaxUPH9jof0H83tNetJDAujKI4C6cjLIA66mcbrieBcuPJpP2plZFo7w7FipY5fNbiQNZ4Yx8ueIpxxaWsOrQsdn1CnMeOMTE5p9wOLKfL/uXIja6FrDSLV63eheN38Q9H5VHJyocwDwCFwqEWbB0wVMvQ8YW6bT4D4Yjnqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 9:55=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 6/12/26 09:41, Suren Baghdasaryan wrote:
> >> I think the key to distinguishing between:
> >>
> >>         vma=3D=3DNULL because there's no VMA
> >> and
> >>         vma=3D=3DNULL because of a trylock failure
> >>
> >> is binder_alloc_is_mapped(). It won't return false until vm_ops->close=
()
> >> finishes. vm_ops->close() shouldn't be able to happen while
> >> lock_vma_under_rcu() is held. So if you've got a non-NULL VMA, you've
> >> also got a stable is binder_alloc_is_mapped().
> > By "stable binder_alloc_is_mapped()" do you mean it would always be
> > true?
>
> By stable, I meant that it can't change.
>
>         vma =3D lock_vma_under_rcu()
>         mapped =3D binder_alloc_is_mapped();
>         <window>
>         vma_end_read(vma);
>
> During <window> it can't go from true=3D>false or false=3D>true.
>
> false=3D>true never happens from what I can tell. It's just plain
> impossible given the current code.
>
> true=3D>false is locked out because when lock_vma_under_rcu() is held.
>
> > Asking because in your patch you removed this condition:
> >
> > -         if (vma && !binder_alloc_is_mapped(alloc))
> > -                  goto err_invalid_vma;
> >
> > So, previously if we found the VMA but binder_alloc_is_mapped()=3D=3Dfa=
lse
> > we would bail out and now we don't. Are you reasoning that this
> > combination is impossible?
>
> It's not impossible, but I do think it is irrelevant. Or at least that
> the *VMA* is irrelevant in this case. binder_alloc_is_mapped()=3D=3Dfalse
> means that the binder VMA is gone. It's not in the maple tree, and it's
> not coming back. If a VMA is found, it's an impostor.

Right, but before your change we were bailing out early. With your
change we would be generating the traces and freeing the page. I think
that's a functional change. Was that your intention?

>
> That's why I did:
>
> -        if (vma) {
> +        if (mapped) {
>
> The question isn't whether a VMA was found. The question is whether the
> binder VMA is still mapped at page_addr. *That* is best inferred from
> binder_alloc_is_mapped(), not the VMA lookup.
>
> At least that's what I decided after staring at it for far too long.

