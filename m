Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052FF109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596526B009B; Wed, 25 Mar 2026 11:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5471E6B009D; Wed, 25 Mar 2026 11:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435736B009F; Wed, 25 Mar 2026 11:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1546B009B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:19:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEEA8C1F3D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:19:41 +0000 (UTC)
X-FDA: 84584944962.02.AE49C53
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id C0F61120019
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:19:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WhAYH9vP;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of edumazet@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774451979; a=rsa-sha256;
	cv=pass;
	b=eb0+iYm0o1XiWnFiCl4Wd2djHdmIxg6Fwfd/4PA7EoDc7dWle0yA3rEwYkpW0j9EAzGKmd
	SmgEJ8hmlvVC19SWcSqsmG4WjbgLN6vOmsPtBHuqYnrilpnL8D2NAC1JQR+Uwy+Fmr8+8e
	PXNOYGGfXLf7fKBWSORNnTKIFvVd3jA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WhAYH9vP;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of edumazet@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvBjbNYuOfQPBkPo1/MnWaPV78PmnvKmGEivqUzAi4A=;
	b=N//zJfOAOh7m+NPo8wRn8h8j3dIqonR1zyYJpotW4/xTK2viSVTv2vSff3owH+n7r1IlEN
	/Auj6Q8MPyBLbPRHa/b80wsjl1jYSBZ41i5Jz52LVnlciIxXgmbDgY2KkPHg0DLkfuPkco
	8MVSpkjFRpxWmMzaScdjZI+U0JYFyIg=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79a2ee65171so53922367b3.2
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:19:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774451979; cv=none;
        d=google.com; s=arc-20240605;
        b=J5gk1KUm2O7o1idbsfZ/phSjLn9hjBaAeYtYW16opU2cdj+5FERdL5LSesT/qlGHfA
         pIw5iNtLEFG6rdbMVx2Hmv7IwYCaL7Jisn3IcvyJBZKsU2lxtAeROje3yDqYNQ/CJEl5
         INPprbCMEughpSt817Y/d82kTIrcJQ27jVctRfhe4OwTDV7aRb4D/xntxHN97EaMNhun
         Pwe4Bu3zKH4LKEhRWMFzORA9kXHh+enq7ggNitDAAnjhiPlifsxPWNfliKD6uJ9yDWZT
         6gAcvj4AyWegHIPnzV0iSIZ9s1Txutgtbly7dWzR7qIp33Jjev0Fmeg2s/p2X3gZ8zbN
         DX2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VvBjbNYuOfQPBkPo1/MnWaPV78PmnvKmGEivqUzAi4A=;
        fh=UatE7lWVcukoKbllHH75n5PowBqYoepNH329cZ6Agoo=;
        b=HhOkzv1XvC88EkysAUwA5vDspdEmWcjfq7qC6oKCW5S/xD3APl0lfTGZUjOlMGu2zk
         5s+beMBtg7Q4Xt95V3mYIDpK2N+anJcyxQeX3xCRKr0KlGkcID51ci1ZxFCKKbmCuzdB
         GPDzegtFFSCKpEZKDfO862kDGQcteDWbi1mu0+2rHkA/24xi1guv1NEA83ug50TF+gJ2
         7OUr4lS8U1VTLnr00zUaX2wSu6l1aGnSAfHMkVZK/nErdl/GGx2MhnnKh47Ib6+zPCoE
         Dd8jYcsXvTLfyHZ7909ogfhuRcpSfFveAK9rQDnAOUJgGOGdstkOBi/r6oP7t/KL47+G
         tRLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774451979; x=1775056779; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VvBjbNYuOfQPBkPo1/MnWaPV78PmnvKmGEivqUzAi4A=;
        b=WhAYH9vPztl0iPvQNSCg1vqGM54Du3tYFIpQpd30mAXRtklLq+G4h5mNatl6/RRwZz
         UtXI/iSCKhszTlJZgwGCaF4UiwstPKgp+5RNgiCTN0BiYpF163noCt1mcGTYgLopJtPU
         Hon2yiskw81k8h1K9UXf6DuLLssT8rvx/LkIF34vdO1h0yrnWblHtvMyxMasMv19hyCG
         zKvImF1AK59khVcac4odgAsnCW5qyf9gL+kfhvdPXjPibEU0PLsmmgwTu318iFLh63xR
         YYZBmcPkwcoWbeam0qNpA6xAparu6fDqINJlPtfSdImnKLJi2D/tr1zE7/heS/OzY6xv
         OjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774451979; x=1775056779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VvBjbNYuOfQPBkPo1/MnWaPV78PmnvKmGEivqUzAi4A=;
        b=cMFkQdSQyh3Cq4xWMeJ25iOhEs5wOgTXwfq9Jv97R3dxbpnE9gCIcDFAXHV3pAjJ46
         0Nx+SLMwm8JSSHopfs0z9SJ03c18rkbyxSdpCpJQ+UTiMsbL6Ml4VKcBXED8SfbsYgat
         TQEWIUs60czlqte+4P0PnglguhDHCag8Pk01/2nFb2J+TI8cfLvehGfTiFKixD0mz0P6
         UujVCT+mFVn8GIeP2VYuIxClP3SxL9FMu5HUL1MVJ78EgEAqBppKiMal4pxszJBCECfE
         bBlALidOEDhGPLY9kGrGlpBhd6LL84Wy2Der1W6LBhpVO4t6i04gYEWQH7NTSVQLWs4A
         Lz9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXK7yY5uzksE4lWxbOVvdjlKTmHNuIMdV909l7uIj4GBKOKX3Cit2PA69WIyfmojDf/XkKZ7qnT6A==@kvack.org
X-Gm-Message-State: AOJu0Yxaqdlx448tvpaa/h7egL9sl4zICVwCvUFF5ddUM7GXytrjGkAf
	HuhHihQoy3/YM18RgYt9q0aPHh7/vqxAMxFxLkfFKo7gzekUQZ8eSonVwv8XgxpCFpSJr2zcfpH
	80D/c+IsX3g7FPi4VXXUDLCBgEso0VpECEWsHxCdk
X-Gm-Gg: ATEYQzz55gOHMjaCpFGttGLdX86dATllUtgrgsrJPXZVYvkeLhEDcsUEi+MKq1UWfxi
	KFNW0LMNwG/EjbBE14Xb8egsICYLCICl9PmnptrWF9dDWK6dYpee0kAgyVXO9InT5s2wQ8aBtdi
	W2ioaim+Cj3snRmrt+Yx1CmXU+mVLb4eKA2zOufbiPoxvVkN+hcSksFYma6ELsBtaW+VvsWcrQi
	lgDZKos9hZdH4/PUIYAY3WZY2sOqi9bDnecOmeerKPLgWDy1LjFTR7ld8oM2vF22K4NoS0AhhCH
	WCRqRY4hrQhcMsD6/Jr8b2a09xwEW/Ytuidy
X-Received: by 2002:a05:690c:d93:b0:79a:bde3:703a with SMTP id
 00721157ae682-79acf0e47f7mr44110067b3.0.1774451977911; Wed, 25 Mar 2026
 08:19:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260313124756.52461-1-naup96721@gmail.com> <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx> <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
 <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org> <20260325151445.GH3738010@noisy.programming.kicks-ass.net>
In-Reply-To: <20260325151445.GH3738010@noisy.programming.kicks-ass.net>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 25 Mar 2026 08:19:24 -0700
X-Gm-Features: AQROBzAUmHy-vGR7yDPTfh3cxu-nNgKFGprDXruCCgpyhHCQedncOVA9IlmG3oE
Message-ID: <CANn89iLnJv9_HRV1vuURFM5uVA-y4SqBsBRD24kSJe7UmBtXSQ@mail.gmail.com>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
To: Peter Zijlstra <peterz@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Hao-Yu Yang <naup96721@gmail.com>, 
	mingo@redhat.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C0F61120019
X-Stat-Signature: maoeyumw9uzonmwjx8q9x8p9po6w5zoh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774451979-211196
X-HE-Meta: U2FsdGVkX1+CjHkczdo6i6zCadYHgZF0DsxdyYAFN/RJeeT4EfOuVwHMVYkM/kdSN2suq6+T2/W+8D8y++X0buomH7S9ULyAe8HofxMzdGt/sK60tF6VcM48Y1EjI4LBotZSFWPz4GaEqJlhSTFadfZgT1TBF5eVGUl3qTXMGBPRzAcbTsPxrkGnh54oPpDr6lpTlJF6TIuNwq9yJW7ziRh7mtvyMDmQDm9Chk3XwlkP68M387B/cYJC1aoeOmA6XL4IvlqeG7nlgCnUg9wZ/8k7qSWVcd34wrXKJpgIzTwZ+O6pGKfGx6IX7gjdObWZHaC6No1BlfOT70p8O7mKpcicMooEHb2CxSVdB8qnnXf2ts63soVA+TmAYyAs0LYVWawgl94urtjoVuMR5Lq3qySB4VofQD21ePam6IHN+TH7nMK14dBA0XWJohXbYEAZXdJq7n3CQySMaKU+UBRkKK7uotZrXUtmiEJ9fAycApkZLxfswkfBpZK+2DYmR6NYElngrvHjLd/Lfx+GfWc/otmjdJN3YBCpInF3YlJOabdrSuaxlQOCcsj6FzvTyUkctnfY6o7LsrghQtDSoRFINE7YUUpCkdj0lzyxVWJA75yVSpQ9gsMUJU2tA5G0Dl5aVlrEBj1ABZhc4gb5Pm9J7sTBlIJI0lPzTcQynXu+qAi/xAXsUaokDO61jUCu36shkGOux1vUXpnfGNegR6IX/xDJG39JEyxbuPzOs27sxlSBfcgcROKt18RrKT31jsUABbKyvnu8Evm7kTkZkaaMT7dHqiyC/5OO8rOjzd7WsMXmF6/KzA9izyIBmTAF3X5ldzf6xeaimE1Ql5uNAWxE0rBrx5sBHjieFsYAS2BwYo/fGGXsOKLM4VM1cMPYZAyI8JA99qHaZSK1liPg1RhWBFig9xU85ncf7xnA8AsTCM5kvNxf4LsXYV6CaIxdwYQzpXShfXTU5Msrp6u4z8c
 wp0+2Llr
 sKgS+YPhIY6VDcoe9K0KOXU0I/XP14VGhE/XXf+rBUTsQ9xST24CmxEFmbM6VfFFSaRwS/NmV2ATkDlDNQDEJu2AMCtScurptojXnPJxabaN3MAtcVXV4r8/xbP+I0/0nzSHN7lfv0OBeb5pZ4aXj1B517wSPloLjozJmyRBXrH238uJ92IvNoe4C8Ws3Yc9VRa044NmShUsqE5stcIEByT9Dx8Uj4Ir7K/90rLrHyy0ZYo3g+uDHVdncUBzEp5HfA04J93J7TBDi8HXj7qcwz8N+4x6CeA+wcyN5sBtKv1KtVdRg9vdHCmsLWm5p+KhJnCwEBjLdr6yqZXfri4thBunqCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 8:14=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Tue, Mar 24, 2026 at 09:27:41PM +0100, David Hildenbrand (Arm) wrote:
> > So IIUC, futex_key_to_node_opt() looks up a VMA under RCU, without
> > holding the mmap lock. Concurrent mmap-write lock is detected by using
> > the mmap_lock_speculate_try_begin()/mmap_lock_speculate_retry() seqcoun=
t.
> >
> > After looking up the VMA, we access the VMA policy.
> >
> > vma_policy() does a straight vma->vm_policy.
> >
> > What prevents the compiler here to do some load tearing while it is
> > getting modified by mbind()? Or what stops the writer side to to some
> > store tearing?
> >
> > Shouldn't we be using at least READ_ONCE/WRITE_ONCE() etc?
>
> Bah, at that point we might as well RCU the thing like so, I suppose.
>
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
>         }
>
>         old =3D vma->vm_policy;
> -       vma->vm_policy =3D new; /* protected by mmap_lock */
> +       rcu_assign_pointer(vma->vm_policy, new); /* protected by mmap_loc=
k */
>         mpol_put(old);
>
>         return 0;
> diff --git a/kernel/futex/core.c b/kernel/futex/core.c
> index 4bacf5565368..6336a80e3dca 100644
> --- a/kernel/futex/core.c
> +++ b/kernel/futex/core.c
> @@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm_struct *mm, =
unsigned long addr)
>         if (!vma)
>                 return FUTEX_NO_NODE;
>
> -       mpol =3D vma_policy(vma);
> +       mpol =3D rcu_dereference_raw(vma->vm_policy);
>         if (!mpol)
>                 return FUTEX_NO_NODE;

Yes, but sparse will bite :)

READ_ONCE()/WRITE_ONCE() on these two locations seems acceptable.

