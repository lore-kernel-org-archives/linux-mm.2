Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF5BC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97926B007B; Mon,  3 Aug 2026 11:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E486A6B0088; Mon,  3 Aug 2026 11:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38016B0093; Mon,  3 Aug 2026 11:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A90E46B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:47:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FE8D40760
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:32 +0000 (UTC)
X-FDA: 85060387944.17.AAF809D
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2D66C000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BN7P5Azs;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785772050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mktbwwZKpKyEAs0u457WQbvPR8j8TvSInGAQojhS6ZM=;
	b=j2uWOeMWsv4ZwV7G0cFfRhL+UHn9YnU2kUUcbFkuWnHg3S9svWeee/lh+6sBtI3Olz9Avk
	OU2NDA/dLYoLYI489lBLH7C8MOKzJ8m43fegGWq81rVPeWAyVXBsV1/YH4/m9oLHCTqSFn
	ZC1urt1cylnIAUDlKrK6/0qsH7qEZ7w=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BN7P5Azs;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785772050;
	b=Nnc4HIpP00ibJokkZx3+YCrcHmUrV6eRtHgtm1IPKfEFZW4bSBFBWhWmNT/EXZj6Hnd5T5
	zIVaEcwV3aIgGopjP4m9XLhxvecBgQpdoMpwHxpfAFMrphVwe0AkQyrLESP9BTssijbiZy
	y0XXIKiOqvDomIr6hX+RgQJHofOWI0E=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c15a5b265so439931cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 08:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785772050; cv=none;
        d=google.com; s=arc-20260327;
        b=U6lGjGCd0CZ6tuCo8iTKvGLnItAmwKiPfpb/99HJ9QCCp3+syZ1lQXu59rd66VNAMZ
         SXMT4F36+78liVSU+q/5c/kDDRsGAFDlHKYa43pU02cWRA2lYe0UABH1SUqbwC1dTSqc
         TvwAhtl0woqiI5g8LAqs3ib+E8WckkQrj9+EUZYRPt8sRSrKI22VU3jbhYzxaYQ98h91
         V6ersKMsfyTKBz+AwX8098kkpxKWUHmyPsDr0OaOFFhUWLidgrlvz+BxmQBkdLM+mddx
         vlIlsb6o+Zr9q3olvtU9hMgaKJj8pcqzy0HoYnlPjC/8yRAbslqZkOpTLaodcZulkiES
         XDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mktbwwZKpKyEAs0u457WQbvPR8j8TvSInGAQojhS6ZM=;
        fh=j66RmW0cHi09pUIchOm9E2mIh33oYp3eFR/3XW0dAjM=;
        b=TiKwGfqkzIOyYOEFzrZg2thdRFPWf6T8Ly2QzauoVpCCP/mDQS0b6KRXCrmQJDIvS9
         hwxL9g/mogssPaR4qNPV8slXxG3FrI44BQRoz8sxIGUp6CblWcl2/LA3y5Yy6CIDLsPD
         LHqj6Hu41o/OUH6XFgd1WTeAd6ULtGCbkHktG3ZKucy3sZYfCGjkVoFUott4dVYgNNvs
         epr+SMAqK1waIxJ6+K8pR8sc63ZiwHxVEXz1TsVnMUNTrQYeD2HEGusaSV6Hf7CPz8LM
         hZKyxw8OTd6deI1KsmHL7YRTB1tH6uo5y97kfi7OClzCalV6/UhEQ1oLlYnNTWXDEL6y
         /KtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785772050; x=1786376850; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mktbwwZKpKyEAs0u457WQbvPR8j8TvSInGAQojhS6ZM=;
        b=BN7P5AzstyHnkrpBNzT0/eznjNTUecNM8uhGIPK3FHTl83F4Jr2PiU8h1uOS49w1vb
         p/O2yaMceXxekR2apxuacKdJuAvWG7rkxvvr4nJ7kjatDeLWAMvLpKDIfPNdnhUbVs/q
         bYv1UrzkP+jUEJRR59TVG2Cpu3vfkrMXrbM0opqL5J3jf4l+pLpa4hlO7moD3H7O7Tao
         NJcKzu/ssbaZaz0vAujcCKHC275Q9sH8zeMo2pWkEE1cefQFyv1WCIQbMsh22bIHqizV
         C+/KtZpw8+ZpM9K7fFyi6akq5A54j9/skLCdpSat1mQLdD8g4eAdt3t/KxZCoyxaq5qU
         /ZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785772050; x=1786376850;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mktbwwZKpKyEAs0u457WQbvPR8j8TvSInGAQojhS6ZM=;
        b=FAGkvGwdQyiAp7IHA2xhy0+CbPwJOhVORGRH1MPbcbf2pAyfZUQOUgqnPu6cQNzQn5
         7KXppTExUicVfiVOrNfivm1UokjjOHCyvlE+2RpS9AklEKOR5qHAxDKqnTXxpVutbwq2
         SKY8nGLaCBER7oZhglUzr9sH1+doGnNTXvExWrUV7qFNwj7bvD+WvkqfRaIiUV/GFUCW
         lY/KaIrE9ws3ZISNIY1SyO/jePpKhIS8PqFXjy3U7Q8mcXfE7Fulh4EwL2zV8os2hd38
         uTZf4J3SkRSM5o8XwThIQHKjSVMuPlIBX0+bqzS57+kQ6u+fzJUtoFPtLpjyCxXdt0Z3
         P0jw==
X-Forwarded-Encrypted: i=1; AHgh+RqV7UrvPycgQVTthi6GOaBkCuZLHLx+bGc9Q3q4AGqF6e1znbErzpx3Ohm6TkqJF8JQZvNUkAK1tQ==@kvack.org
X-Gm-Message-State: AOJu0YxWAl9UJF15AXkooSJ8hNrsFWwuu0RheSKmgQ6AjUJEv0h38qxf
	VLjMA5nQ5hWSod6/CwC8KuookFKF3m6pCdp78HXmv9cwvoFkrSJ+zr0zbAOPWcuKAYptVtvDygh
	fFGNyfq+ZthU0jz1+jXMASjwQa74T6CAwC5ioWlBAerp3ocRq/V4hX7kl
X-Gm-Gg: AR+sD12V9ZQ/ViMifLaBIDb5kD5vje0ofWGe29L4eEsOsiJwMoFTd9JZ+FVYvGENET0
	HpRpZK3KbR6z0asXzK5AxWtI5aWsAAod79ZmN5KqjlLNyJ2woYXn84gXiELi8WEOIvEeVVmWDyU
	J9OVOGDAU7jmsbECFwU/yle1zxXfCp9wnSe/5Y8meRNY6PkJGWiTG5mCqLKC2hhQ2mjm66ZJAF1
	izWhLRwVFVcQnmHRRwnMNUTNfmmADffiFKvs/YzWrkXtxINhw9V7f2p2p3QKnHcb7fQYiTRwNKh
	5X+1qe3xIrkUtu9DaDXpUhx+8LcXU8BKtmgkeHNzYqc=
X-Received: by 2002:ac8:580e:0:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-52b5b0b0160mr34599361cf.5.1785772049129; Mon, 03 Aug 2026
 08:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260802074018.73887-1-baohua@kernel.org> <20260802074018.73887-2-baohua@kernel.org>
 <anCu3DOrXDeMrwi5@lucifer>
In-Reply-To: <anCu3DOrXDeMrwi5@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 08:47:18 -0700
X-Gm-Features: AUfX_mx8f-jBcOKi9pZdnfOnnZVSXkXmF-pD1Lo2stOVOrv2fQeb-q7PoBUMwCw
Message-ID: <CAJuCfpHLT+MLTY0B4bjQbCpt5VUD11+KF7KY9Y4u4OAfc=3jtA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] x86/mm: use VMA lock for kernel faults on user addresses
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	x86@kernel.org, linux-arm-kernel@lists.infradead.org, liam@infradead.org, 
	vbabka@kernel.org, shakeel.butt@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, zhanghongru@xiaomi.com, willy@infradead.org, 
	zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2D66C000B
X-Rspam-User: 
X-Stat-Signature: eruc5y93p7y4ga6u35k5wob1hcrqgm6h
X-HE-Tag: 1785772050-792766
X-HE-Meta: U2FsdGVkX18TiEzfyELVB3HeU9fQnVV+qGCXyTC1JR84mCFvK7GJupY7oNpxju1CsHTgD4yjAIw2hpnkCsvgkAhJ7aUvZd+xJjhLXfcy4h20U88lBe+rca4IauFxoBU9gjFAwnYVGFd9RjvdWWQc/y43/LoSv/KIFlkv3xlhVzr3i59G7B3PxJypLxQN+m9q8CDTBePtd3oqu5lzKKVQEAbnbmTmE/bqAItPSDOMFKrgyVGucClF/HQYTxX6poXwt7RlpjRuhEXTUc0Yp9iYwsXU2NxHClSMCIsPOGf2KEMG80yMkCs2IA79swtL4/Z24LpHPVcrrTSQYSPveNV51IvzoqHYDvyXuMBzCURYDf9lIgVKEb6UJSkK4dJSHtRq/U7U7ZLAp7lr99Asm/ymVmgUlE5pkp7vOzvSPRhmMpDenIh0XEtRjYHtNZq44Niohmx5xnKu0sAT0Lx2U1WYjtWLW4IyHFDTCJwC3jBaylCQ3c0sycx36AOppBsu6P/N5wpiYCbm3xwPCZbHAjpzh4fRr3iMuiRn5CTRfQkBjBb6ab6OM7sc2Xgq0rQ3kx3CezuPXNZkjcB2IY0Iq326zZ7cxTw1EVaZjnZdUL1HILShKxdUJEsqiUbWNvZXkOGdl7g6LsfkqMNvn8X8+1uTLMPyLF6N3t34ynWBXUTvk0/xAQQeXFrBPNgA3ykSUMhVGr/zzPK4v4x4BJ0FXgwuYLNCGUcBCLZGaDGsMn7C4k01enIi3Z0YCgDG0mgC/t9Ckq5zXdXR8uLMqodBJgxp7u7YM8E2ZbxMzRDk5GFIPeqNikRe/2u95l+4Z+RA++Jp3+AZ+jgHwjCE8ILvRjf1FLPie9AgCjdrxKkM50ISzizGYAZ6GoeHLRBxUberowqfHqRhdI+mjYq/Cuoe2xRHL1GTWwutRONzcnHtwEOmF7POCgq5aHc90hUpVguwFN0P1b1cE4haI86q7+al9RA
 rbRzrSfm
 LXAO1UrCZn/6jpw5b+2gulUv2EhVOt8Q+PLtj371/+ZsOb448JTXtHHgInLSI0UDWQ2sUgHxQYmVCSOg0ugU62WvNW+qoWxRoIHN1fYeFOKRKfrKefTCBwJvoDbrwscjbSdg46YSfkcK6pddaGqDFYD+2gsDe0wsg4ay0nWpTJ90FBVQ7PnBl7zMwgatbE1Ywj7rotKnvU6ZJmiLs147/UrlQlgQdxL7EVBRpSa+uiRfEYyww14VEeZCcHr5LlGlWqcgdYlEkyCMTNhBBc2vVzSccgig9/o7YJ8F7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 8:18=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Sun, Aug 02, 2026 at 03:40:17PM +0800, Barry Song (Xiaomi) wrote:
> > Use the VMA lock for kernel faults on user addresses. This also
> > makes the existing code below meaningful:
> >
> >   /* Quick path to respond to signals */
> >   if (fault_signal_pending(fault, regs)) {
> >           if (!user_mode(regs))
> >                   kernelmode_fixup_or_oops(regs, error_code, address,
> >                                            SIGBUS, BUS_ADRERR,
> >                                            ARCH_DEFAULT_PKEY);
> >           return;
> >   }
>
> Hmm yeah :)
>
> Bit weird it uses user_mode(regs) and the early exit uses the just-set
> 'flags & FAULT_FLAG_USER' too.
>
> Some horrible duplication here too... the user_mod_regs() etc. code is ju=
st
> duplicated in the mmap lock path.
>
> I think you mentioned it on Suren/Dave's series but vma_start_read_unlock=
ed()
> would avoid all this and could lead to a nicely red patch.
>
> >
> > Right now, the code above is dead because !user_mode always
> > takes the mmap_lock path.
> >
> > Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
> > Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  arch/x86/mm/fault.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 45b99c3b1442..c22b74e0eeaf 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1328,9 +1328,6 @@ void do_user_addr_fault(struct pt_regs *regs,
> >       }
> >  #endif
> >
> > -     if (!(flags & FAULT_FLAG_USER))
> > -             goto lock_mmap;
> > -
>
> I'm not sure why kernel faults of userland memory were excluded initially
> (Suren?)
>
> Given that it's OK to take the mmap lock here and we're necessarily in pr=
ocess
> context anyway surely it's OK to take the VMA lock?
>
> It looks fine to me but want Suren's input.

Yeah, I don't recall the specific reason it was excluded and there was
no discussion about it. Probably wanted to limit the initial series to
the most common cases and avoid any side-effects. But indeed, if it's
safe to take mmap_lock then it should be safe to take VMA lock.

>
> Also given vma_start_read_unlocked() is coming maybe that's better for a
> cleanup.
>
> And finally - Willy is working on a grand clean up of this stuff _I think=
_ so
> you probably should coordinate with him also?
>
> >       vma =3D lock_vma_under_rcu(mm, address);
> >       if (!vma)
> >               goto lock_mmap;
> > --
> > 2.39.3 (Apple Git-146)
> >
>
> --
> Cheers, Lorenzo

