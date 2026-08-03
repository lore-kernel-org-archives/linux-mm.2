Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FFBC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79786B0092; Mon,  3 Aug 2026 18:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A2E6B0093; Mon,  3 Aug 2026 18:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F766B0095; Mon,  3 Aug 2026 18:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD926B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:37:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4716740858
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:37:47 +0000 (UTC)
X-FDA: 85061421774.08.5853F3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C76340008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:37:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1BtXtRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785796665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uMo1mqds7+ytfGnAG4j5G/sObQBuQqDwF+7pp06uTM=;
	b=Nh0MwO3+XZRfc/x00hQfrT+Z8JfXu+gICSQe4dFCoEvq3y/AfoxCtHt2QO46sVeolZbJHy
	fiPId1NKEzHJvP91jh3Rg38Dfr5I1Gj/zH/Ex/4/AybF5PMOjxR37lgTxM8uNodYbyr+Tr
	0NG2Lx4ZsRsFiQVpxNsdcFImFRa4UAc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1BtXtRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785796665;
	b=AIbZSrUDxjMD/qfO8QPDTFkd6uNB77I9ygpx4NDmVlfZN32Z9YPy/uo42X35eoOti5pRlS
	psEIAsuaTxgveJeuYTdhbQaFJcLtaAqWQFAabWeVrZSLD8KmrBdn8RZ3nr/3Kl1up+ItkI
	EeCNyTdQ0tPWOl0tBVwzlunJJ7BJvWg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E08D43FBA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612EC1F01558
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785796663;
	bh=+uMo1mqds7+ytfGnAG4j5G/sObQBuQqDwF+7pp06uTM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i1BtXtRv4xGPqlKGtwXrDU4q5r36CweAM1IiXE7Sp5iOJ3efGsRXBGZDn1Mbkjwh5
	 BUI4HdjrSKmaLqEdrLwZ3fe193A82tAdMHasMPvWknEzSgHR0CnBuxgeOR4CTnv778
	 Tals4QQoYMf5obfygtaAl4pPwyFqjtrMEhlycg4CP7eBzRgR6JdrRrfiPgVwsWM7nK
	 VxJ0xeDWhMgnLectVPMTCNqnvZTbK47DqxqeeVLIux6TiE4yD451jDxK4QJG33kUID
	 3tWT/wdHVNrKrg6TN8BztbjwGLT8IHQRDr/f3XzBCUVFk2VXQyh0yjdt6augvQKB6Q
	 SAvdE4o8Pm5jQ==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e602d2c0fso27656185a.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 15:37:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrL3oVnSnbGzGonl9r3HUSlE+yPd6pgO8Jvicq1t1SoFPg+IVXlVy2O+ENJVbeDmGKIHdDirXECXw==@kvack.org
X-Gm-Message-State: AOJu0Yx2yAtAJTphSKsqstdcRZW5ORB9OEB6Ti3zcW9Y9YbFGPjyuOt0
	nyx7MHjdJJz4qXPVXBh+CnSc/v16BpWoCQq/QrH5LfbhuEtxYgCa0dypKyrAoXznoNPllSf0Cil
	Kc9RxW5AuMr9hbu3fvXtly+lr46MZf5c=
X-Received: by 2002:a05:620a:11aa:b0:92e:d2d4:2d04 with SMTP id
 af79cd13be357-93631984d68mr248278285a.23.1785796662708; Mon, 03 Aug 2026
 15:37:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260802074018.73887-1-baohua@kernel.org> <20260802074018.73887-2-baohua@kernel.org>
 <anCu3DOrXDeMrwi5@lucifer>
In-Reply-To: <anCu3DOrXDeMrwi5@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Tue, 4 Aug 2026 06:37:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xM7mmv_Xa3g2mB_0gW0_VtYhMtwz0idgYLyoAYiHFmfg@mail.gmail.com>
X-Gm-Features: AUfX_mxObWP2k3KVrcuv9diuYZ831nvuzQqkRHE7nkurJp-mPMd32XGLmVpvk58
Message-ID: <CAGsJ_4xM7mmv_Xa3g2mB_0gW0_VtYhMtwz0idgYLyoAYiHFmfg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] x86/mm: use VMA lock for kernel faults on user addresses
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, surenb@google.com, liam@infradead.org, 
	vbabka@kernel.org, shakeel.butt@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, zhanghongru@xiaomi.com, willy@infradead.org, 
	zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wi71d19k5x81dki7mpbsqrqrp4s1hwyx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C76340008
X-Rspam-User: 
X-HE-Tag: 1785796665-911352
X-HE-Meta: U2FsdGVkX1/cnBYnj/DfTzd7aMFLhJ/cHXafhD3VWoOzgHS3sebvqsqkn/9gbKPFj5Z0Yo/KGd4za+yy9oCXifXSRHxbJYwgWTk0TBG3rJU2W4UpKvX4c6QJr7o2jnIQqIIv6LLzhfuarGT1iIcjM8z6TbovpJvRUa8XvVc75YQOPuynHKCTTjOUkHZZWI3CWRsP6yaB+5vd00ieNwagHFVN6tB0/FxzPh1FaJRxvZ09IshbO+SM8QV3B333nJO8U9mltCcLC3DkmdTssfm5hOsWgIiQJTtT1bAVGg7wOzXQrahvXq49eaAKuqdnw2Gt9T9mYmcDYCUWqlyp47otcNCnHCqD/C6DgYkQwMC5+T74o3FAkpd7PgNPIzJHC111jSYjW+B7LVZmMrmeeuH9B/sCJcG88i84S+1fvcwwj3SGEr/0BmlKwMUSEAZifgq+CWI/RKlXA9woI0fVK6/xxQYEL/hCYjGrFGcGe1vpWCC23ny5fcg/PT1A8/6JIWzWYNPRB1c7SJEQsIcfpTq5odvZ8+Xc1E70Pn+1i+UppnzzG+n1mXZ/OPgg3rP4IoyyB7At1fG5nmUu5nC158ad+RpqWwMzQmeWJnGYnN1h8njVer/InlemjOxwCR7PPKkK5P/1OSFz3dAlWpTAp6yrV4RiBUW5Vu+S65y1p0FlzdnLInom/7/rVIKIqYh7b9KcRiMLpD70U7iKjDCYSAA5fqKteb6KwJO+XDsq91fOj8xif1RLm3oeSZ7LCLmIn2uowvbZgvL4jbARnNSgcHA+FJ+eMg6p0tFteuxC4EQH1Ac9jYCGit/ZdfHbeIafzdIh3ak2sR7cfkMANJlQpjgTYVsoIdtWud00BAL2iCQUy0jJC1qUuOsQPOgEssab+0j0Iyf79CFAYEsAnxwN78Xs6GGknZCdVN4weCBUmbRn/Rv/d/CINhFlWeZJlaJQZaCXNiCqLdacb7hFX+wzhnn
 M1RgcBq2
 Z84xAtVgC/pW4s+598qn60Oi0AObs8iGuVmpsyUPpnfEDIVfskXiXuv6HxTNE3xg0U7Xay22TosOj18hTKTd+C4l15pRQCsY6tPbrHBVJqfxsMjhln0A407Zp6U/a30fjuLwLjcu54vMnkM8Rricis1NhMJlp8C2U1Uso8aJpHXV3I7985lNVoQbGfpRS++V7WQj0XnNknhsBESZNsmO7tRx2ZOeyV2UwMnZngVu5SN5cdUVopd0oFd8+QlCVKIXcJFzGzXElHQXZrBvswdzoHdf0UqNaYQjJbeot056Bsr6iIIyZKnlIDeJjP9HGMpkUPu3txwcRHcUxbOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 11:18=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
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

vma_start_read_unlocked() could completely avoid falling back to
mmap_lock for binder. For page faults, however, there are still
paths that must retry under mmap_lock, such as
__vmf_anon_prepare() and swapcache_is_device_private().
So we may not end up with something as clean as binder, but I
think we can still achieve a cleaner design than what we have
today.

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
>
> Also given vma_start_read_unlocked() is coming maybe that's better for a
> cleanup.
>
> And finally - Willy is working on a grand clean up of this stuff _I think=
_ so
> you probably should coordinate with him also?

I have no problem waiting for Matthew's work. It is the right
thing to refactor the duplicated code across architectures for
the VMA lock page fault path.

Thanks
Barry

