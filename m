Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C945C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C2B6B0096; Tue,  4 Aug 2026 17:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303F06B0098; Tue,  4 Aug 2026 17:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240CC6B0099; Tue,  4 Aug 2026 17:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 028BC6B0096
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:14:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 755F6C02E6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:14:05 +0000 (UTC)
X-FDA: 85064839650.07.A61B462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 67C79180006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:14:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRdWik1s;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ak4eb7x82hyzr8ov8geZx8LKpCLMPbm88Qx3xLS8pnI=;
	b=ifIzjhsWETZRqE9yEEoLVwc6m30DsH31/k502HVyDfsSKTbCid9MbHI+PbppUE95eT/htd
	M13TBVWrcVOTm2MpvG1zdHOln5p66nraUZ9PanS+znTIZNs5ASt6Qw9t1gVhFGU/2WUJTp
	MdzMql3SRFWRxajZLvdfyIm3+o3QIhg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRdWik1s;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785878043;
	b=LNnRMfwSQ0cJOR2hj9xv8UpvT7FRvkL8NK8Qh5EO2jYY7Zc6kJ9FxPlUuTuxura1TL/TST
	kozLaf1yAXbOZnSCYzTwLHNbsa1SwBmh2sjTg60syV9ybZx/S2/tAfhK2XCC2No+uIZ79X
	f2Q8vk41BjSpSi17LjLQC/OFHQNwqE4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCBF4411EE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B82E1F00A3F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785878041;
	bh=ak4eb7x82hyzr8ov8geZx8LKpCLMPbm88Qx3xLS8pnI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VRdWik1sQ4yV/u9NXlzXdRb52gFL0zXl76yKis08qooA0A1IChP/tGrwg6ApPP3+D
	 gCU1sjhR2GWLHioxNR0fPRgMe1jKcdgg2kgJpb0n92sUds3wRmsM2HwPnWLPrEsrzQ
	 FuVzoXJPMJCcdrK59Qv9uyKh80tSdYnSc49l9vEGcgGES2VMetQp7UPYuq5E8iDveh
	 W4fcDwjlK9c8WCINuO8ZoJGHTcmYUq0sUDiZgMi7V6G+LmbZ888Aiafk5YqmX7tbXK
	 z8aM5NgMaNSVbzO/NFu0Tg0SKzvXMQSxJbHDSOjbWrQjQpIZ6Di293r3mToKxXEhJ+
	 /urL8V4mZcEnw==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-934956bee57so32246985a.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:14:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqwBOI2Ddhf6j1deTCzwtU7hiYruxncDqCv5hu9s5CEOkFkvbNuGakeyaJthuRNAgOpgCFCJsX9wg==@kvack.org
X-Gm-Message-State: AOJu0YwabV98e6D+GrrNTGJAhhhsBLBkBtZYZvbttAdxh5D9jGGsAY7W
	UD/Gk6qJXF38CDgBx5PwXMuvw9yEFXJ3yp4yymPZytqT+Zq+5Em1bl27qcpQRTiDgpj567z86Bx
	MiW/cqTmUxqB2/8o3vCqJYSu1oWocsBU=
X-Received: by 2002:a05:620a:9046:b0:92e:62d8:1faa with SMTP id
 af79cd13be357-9364921c204mr102766985a.46.1785878040982; Tue, 04 Aug 2026
 14:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260804095219.46213-1-zhanghongru@xiaomi.com> <anHMe4jFT9EIQe5q@lucifer>
In-Reply-To: <anHMe4jFT9EIQe5q@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 05:13:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x_ed4m57-8rZ53PBoGy-aa-z1thOvGOp7RAb2qP28dKw@mail.gmail.com>
X-Gm-Features: AUfX_myvaI_2Xa1nIyqQr12P8ShUZE1bi8PR-nAZSpWQ3BvQUdcHiygb9ktNvo4
Message-ID: <CAGsJ_4x_ed4m57-8rZ53PBoGy-aa-z1thOvGOp7RAb2qP28dKw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock retry
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, liam@infradead.org, linux-kernel@vger.kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	vbabka@kernel.org, willy@infradead.org, zhanghongru@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67C79180006
X-Stat-Signature: ht8aot1eu16yophssuxk5by3d3dbr4x1
X-HE-Tag: 1785878043-511453
X-HE-Meta: U2FsdGVkX1+7RGiyahrnSxS/MBRvVwGTJSSZ6RwURBeU2m1FpDwEMshoJmP/nqG1ltMBsXx2s0DhQyuzAolH3i/4VI6pC6w42KAHwtI9/fsl+KeXff6svAz6Vz6YWoGbFbg14lpaYdp+9MPaLs6wQdQHKWSFzSmQMCExMxAMqOWdOXTp0BXP3VkeqKzMuC8Beo1Qy/4pmc5yxPpn6aIMmFK2k3KYD1SoepcycPLX37ifQGXP2MpH44jxJFP9oRklopjM7fthzpPJzE7PK58Tbv/5YcGwkK0Esv3p3RVcXPOy+Hw2/NGepZuAAlvqMK14BtrKthZvzRAunf9fv83Lu9WMo239BhzY2E1Bd+IDOmOYGJerkWDNmWyAMu+EisCAvyPCXZV7njiYh/Sk+sItT7vOX6WEZuXwm1yaqKpeFB5KMDBqdXfVM9Xqmd5cvgIuwnRhQuXTPkdDBD8ohnK1a7UVD7szXm9t73B5Sn1IcL0GW2S2RS6r1qOMCfgS+S2hit7l6rI248vDZWpwt3jpi7Qwv+PTbyxcwCZP9soD0oWwpb0POpZcaxNizcF02Oi/S71Yvcwp96UYdIKCUNG5V9TK4oTFM3OV7AcZWBSMhxcp1D51wQ+y8CYKUE1AIqEnIqRGuiBt6sCDCIE3ykAaM+F9AR1l/k43u8K7mVELVuex7mdQqOk5nuuJIGB6Wi78NPwKjJGBPkQLXuvNZoHbSYd/GaDJoiVe3yCvXGf7eFjwcH+Cb/1TvJvswE3HRcJTb9iuShqLjmHI/KysGit5IokllK91nMcOPQ2CI3PPcAQGhYLZjD6zUoQ/MyKnYJghbduhLfgatDVv3YBdic9eS11I5Y7E5lB2ACfYxI7IdEja3Msh3x4IFyRQ0mywYmRuazej0QqYPo4eyIBTJFRFvK763debRUYKW0CorGOIYNpeOocJ4QEUvxJCI6F8pVjw0JsJOvAhxOQNnhF1k9L
 xuTP/Nm5
 OLkgSlStTtC/F+o5ruZVTHzkr68i4AJ/SIcsZ9ANo8jb0RNZaaKpwuuu0WBCgyFR2segPV5itT1dj3pN1KZyLg6fNDX2xCph1ORuBac7Vi+dJySWBXIFAp10JtpNEJKHdIIeIWiuElsOYPAAzf1kx3tl5TIVGLZC2kKVVxARkJcJRJFLhsmAFRzuFYfGNMNVwzGH+iyZO1Cs/aYNmiqEae+Z5xN+3Jp3I1LY7Lyj3czkHU15rVd5DkhzcJ/N0UDpNe7izKcB+0p9DUcJkylowyy8AVMJbCn6NMHtufzhaldjkCSo//AY4Q3aJkQB+pf3Fde+aH4gt5x5OsA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 8:32=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Tue, Aug 04, 2026 at 05:52:19PM +0800, Hongru Zhang wrote:
> > From: Hongru Zhang <zhanghongru@xiaomi.com>
> >
> > Page faults handled under the per-VMA lock currently fall back to the
> > mmap_lock path whenever handle_mm_fault() returns VM_FAULT_RETRY. This
> > means that lower-level fault handlers have no way to tell the
> > architecture fault handler that the retry can safely continue under the
> > per-VMA lock.
> >
> > Add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit that can be returned
>
> I don't love that name or that faulting retry behaviour is _modified_ by =
a
> value that indicates fault resolution state... ugh.
>
> It's kinda confusing things 'VM_FAULT_RETRY' is 'you have to retry this
> fault'.
>
> 'VM_FAULT_MAY_...' is starting to bring in effectively configuration
> options into it and that's kinda horrible.
>
> I mean is there any reason we shouldn't ALWAYS do this if a VMA lock was
> used?
>
> It's not too expensive to do a single retry with the VMA lock before
> falling back to the mmap lock.
>
> So maybe simplify like that?
>
> And like that this series becomes a single patch right?

This is a brilliant idea. That's a genius insight, Lorenzo.

I guess the conceptual model could simply be:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..3592bcc9bbd7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
        struct mm_struct *mm;
        vm_fault_t fault;
        unsigned int flags =3D FAULT_FLAG_DEFAULT;
+       bool vma_lock_retried =3D false;

        tsk =3D current;
        mm =3D tsk->mm;
@@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
        if (!(flags & FAULT_FLAG_USER))
                goto lock_mmap;

+vma_lock:
        vma =3D lock_vma_under_rcu(mm, address);
        if (!vma)
                goto lock_mmap;
@@ -1352,6 +1354,11 @@ void do_user_addr_fault(struct pt_regs *regs,
        if (fault & VM_FAULT_MAJOR)
                flags |=3D FAULT_FLAG_TRIED;

+       if (!vma_lock_retried) {
+               vma_lock_retried =3D true;
+               goto vma_lock;
+       }
+
        /* Quick path to respond to signals */
        if (fault_signal_pending(fault, regs)) {
                if (!user_mode(regs))

Nothing else needs to change then. I wonder if there is a cleaner
way to implement the idea, but it is really stunning.

Best Regards
Barry

