Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C0CC61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52CB6B008C; Fri, 28 Aug 2026 21:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03616B0095; Fri, 28 Aug 2026 21:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3F96B0096; Fri, 28 Aug 2026 21:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3CB6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:10:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3E4F1605EB
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:10:20 +0000 (UTC)
X-FDA: 85152526200.29.D4C14C4
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0C156C0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:10:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YNpCoD8X;
	spf=pass (imf22.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787965819;
	b=2uO1Ny4nfureMcpFm+WB2zareBo7BmZ96l+oUcyX/IlW8C4ofmWK8TeSjwDk+pd2kgQJrt
	zzuOvFu57qK8EkRllGG9jQZrqalm9wJ+FwbmMFoM59lftR5Sl43w3ozmFD04CLNTK04VW4
	EQ+/x0XPSkOyyBarbwX5Ytq5yujgPaM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YNpCoD8X;
	spf=pass (imf22.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787965819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDkUuQMIHGGiLSZiYVg4s5IjnV+PlGExO2xnMcJB/98=;
	b=UBVvflctD/I3DGldiphuOrv3L/VYMQvt3AaKfifZQfi3vs+NxpmV0xkq1R64xpomgKIkwK
	4XNhMualtK1v5PV6E/70278sCEUpWfQzolm58BJa2mvnb1v1Su6RSnBNy5Uh+9R5RcAAWH
	45MoKhq51POR6w2OcUJB4A4nOsbTeRI=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c250a2bc3b3so221153566b.2
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:10:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787965817; cv=none;
        d=google.com; s=arc-20260327;
        b=KXo2G7q7Awfck7MrGxU0EHSxuqj6R/JqVbqlz+SfTJC57gr2+Tcm6Eo76mHDqM91fE
         b6hRhCQzYAhv7F86o2TRl5vdd3OdGHC4HAl3aLLVOYrWJ0zjaS0X3JCuDJOq24G45frV
         f4vlp7YDGE4KS7L2tDg7Pq+MuWVPYPd1vhhguAA0y7gSNWbyFGDkT5T22f4vYnDnJRA8
         0u4FQurXAnz6GwIOSDufkJJ+otjg21tNaBpUMi0tB5TCusqEqpqBUSXrLWJ6SeMBYqDV
         umyO2WVY9h+vQZPLxnICyeiicFtOkKtlbD+dVRNqBzKaFsvre+6TytCWmgOAKSk5PCJx
         77Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LDkUuQMIHGGiLSZiYVg4s5IjnV+PlGExO2xnMcJB/98=;
        fh=dQl/l5lTlIqezYm2lavaOD7DCLrsKX+uV9SvGEAEUHg=;
        b=ooc3jZPF+uXTRrtCcBl/IaWsAPlr8v9xsBR0pnA6AeZ0QbhGwsDNpEQkCttPZqQ5pI
         CJ6YuLqQuvAbcU1sVtbxWaKDK65wYhEvmDix5E7se+M5VJF+IOniE9N4KN+SNEOmUEm2
         em9xhlUBCWL/n1UnHeijn93fkOQVZsLyXnAUXbDaRs5nVKnhK6qxuQtwIAMaG8jiJeFJ
         BhWoxfsbaYo13V3Vm9JAWQWoRYDkRV4lgg49MIXwrycqZxuCj6G8Zfqs8vRSUzv2nOvt
         NK4XdYSWf6Yk9emhsyZNck/WAaKUPmh63nxiBhuvJ/nBqmwnAcdadaraUWdpAlJZcVHB
         oY7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787965817; x=1788570617; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LDkUuQMIHGGiLSZiYVg4s5IjnV+PlGExO2xnMcJB/98=;
        b=YNpCoD8XtqDmNzzxtR0+m32NAoCOx1WpkGZw7SzLwkJI7abX4nKNejBJdpXdkiFZPy
         w9pSgRMAbeDtCDbPmih6P9C+daXJAFbK8xNZiKdpR3nXpKa4Kk+2dP7hg9wrYquqhWUI
         deJnV8BY/uH2QunEmPDLZqUkVnguEL3sOoBFDSbNwHJV/m6HKUI/vvLbo+IKxkMEpz8o
         g3aT9LOT59fuTJZZ1u2Fz6FTD2J5oFDdlyPlCJpxO7u1dLx/qVIslKAixVbHer/BfP0f
         5rQlsXBH2vIAGxVlok3TctI+ccSQnIlROrSY1CyR6mVrNf7cttFCDdcT34FGjKtofe2F
         e+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787965817; x=1788570617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LDkUuQMIHGGiLSZiYVg4s5IjnV+PlGExO2xnMcJB/98=;
        b=ihg0S1TVwU89JnC1SWWnrZP1ZhVsUGF4evx1/2Quvy0Ka6jnkMFHYCrEWaTzJwA1I3
         wU7ByWSDEAf5VOybGPvhsVz2JOSrmxAbNIHbpanbIeOhP1/nvIITjwzuFdDefzLEX1Qg
         ts33RwmgUhoYn2ERt/H69l9732fYJzdF0uhNgqflAB4ianG0qyS0+cRPxuBBdyXjCydm
         1fuLd+Wm0bpsSRnhgVidRPLLXNf/exRrG0qlIwA8VI5ieEQcqL5fM/l+Rzl4kdEV8Y2Y
         kLux1U7vSzRu/oJM0QgcNil2GcWXnBq3tI7I3U4M6Sm5n25E4OEYa3JxAS65T9e6NNU0
         XBkw==
X-Forwarded-Encrypted: i=1; AHgh+RrDSU7nt1xBdKopetjQdX9MRdyeVnVbikm8gOo9FvLpnuLB9PTa2akqX8LtCDBdvXQn6hOD2Rx53g==@kvack.org
X-Gm-Message-State: AFuF++koAbOA8NsxdOGQwhWxl5XfomOdH1oGdbiqpS64SVDiCJvc0k1r
	3DqqVVdhdTxcxfSnuzeRMGDEv3JnGBLwdw6IY0q1wZZdam/lVgo7rjLl3hoi1SnYW1mijMQOaVo
	Ji40AaqYhKeLMHJ2EQFWqzU2GRQi8JJYCRAPbZm1L
X-Gm-Gg: AR+sD114mT9cgdIktwV8gKlsM6femy/CqycY/wIir/KjFhcLkDo+Ti2CvQgpJ4upO4K
	/aKljlcH7s58Vu6iuIPnlsljopBtBlj7yrRqEn+IOzhpockYqepKH84UQZPmxsuheZcs5Nvq9sn
	u9tw6LkEEMU0yU3p1f/DhZac2hiYtC/SVs1JI10RoBREP3ZR3D14qDyHyoKOqwtOLvNwJXvsbjK
	sqJSEcl9/SQV7x2gCqV6GGUGbLKZBMgxZzjDNWI2Bvi4jl98hd8yyRIY57c42ldZ2PH52QBuG2W
	LwcbkqH3CiF9x6WWSd+/FrWzgxoDJUfMZRBY8bbRh8nagd1EpKcI9/q6PWKAyHKrK1xCjDGJnlz
	iV5z8wEIoGdRH1LeD2nGAmpEob6DNjqQueNLYVF33Rxp47wqlmoYJ1bD7yA5KnVMYZJja6sXg7T
	OlZt6mjD6tNzrL
X-Received: by 2002:a17:906:f592:b0:c25:d03:6794 with SMTP id
 a640c23a62f3a-c2557416218mr792240166b.16.1787965816803; Fri, 28 Aug 2026
 18:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260828222640.1638457-1-jthoughton@google.com> <20260828173302.29778f1bf802a1db932778ad@linux-foundation.org>
In-Reply-To: <20260828173302.29778f1bf802a1db932778ad@linux-foundation.org>
From: James Houghton <jthoughton@google.com>
Date: Fri, 28 Aug 2026 18:09:39 -0700
X-Gm-Features: AcwNN1UYXr9aSh6ZJb7y7EO3U_vx_4UVQ4qPVOOoPdPKw3zhEMSrjR8DApQcQpU
Message-ID: <CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/khugepaged: Don't install PMDs in
 uffd-minor-registered VMAs
To: Andrew Morton <akpm@linux-foundation.org>, Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, 
	zokeefe@google.com, hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C156C0004
X-Stat-Signature: afkz8btdgwqk5teq695kgbdpieh7asx6
X-HE-Tag: 1787965818-955902
X-HE-Meta: U2FsdGVkX1/mGKWMGKKQWUbKTKULB+WqVYEr6yUGUWHDYvXEKUfPcYDkY9YSsNKcf5eBirLASU/cUNCfl6TOtvYCfD81zfF4TMzrPiCCmPOB0EKvQ4z8X3pTiFObs5wCYP1scRN5Jna+bs3dcuHrpnT6nFe1TVdPJ2A4r145HY1czmQPopqsTqQfowW+1sfTe0UiI8PQUJMisVlBOF0wvto0rA/nc3yNXC8bwestnwQ7MSS0OgKtBED12RGPlDTWygNKIvQxqaEiZggWBpdfcLlND+45ckRl2HZoljNPde+PpSk9qCCVYakV8M26sJw5u554zRcwBPnaRZNsf6qAXVBFkou1VjhmXiUuKbWu01+f06gR6j6aQJkmtpccUQVw1rIwhsy+Y5bB52/QmQPy4Um7qaSx8Pu+orcOUq7+d/x+VLNeGQNkGBWNzqljFdZ2tvsAK1BYYDs18XAeQVpEx95WxepD1Mt0EPwPx1qHXP9TH1fjfh0py6ylv5S12mM2PJHPeKMv3SbTyfbdHsVktonCir1PwiVKkEsmvlyguyHx27EAyGYhxW8dUdGtP1lqIjnaLj5cilSj//u7RfBVU/ypN8cxFAN7/qG8LPuvIvigAjTV5eq3JPET5Al7O0C11w1zOXfNFPDWM1duxi4jaCOMVjM/dCOtkPb0QmvhZbB5ekDPFUSpFEvg0Rx6TWep7srmK4bop+dYv8PQEmOSBc7tftcGe/8lZgz5FOqQZNE6KzWARLGiExUDZJZjBhtVWXj4XtiksDHb2rq3QFOB9NNDERcO4D6PRoUzthKNieP1rwOxKl31kDi6BWT7YQMKTD8aGz0I0Rov9qosZHGe7fEzy3o03sDj+CLYRu08DhSeTzbPtPXPkuPsh+ySyumEyrJj5sp5PrI2GFvObApVzSY4AmfosJpVEGQTuhYMUj4zxpcYYsDRyh6b+E0JVgGzwYCCMNpN+cnp2khhqf4
 ZPOcwfwb
 rqaiwYENcQYguISOGTI8GPtF2k9Kgw3OH4POgNCkCRnMLrtgl6T5XoE92DGRL6pdTUPa56ZOef1+80qRFN5t9SgTMpf9O/YmuHlS0fxCu5hm/uNFGJ/O6oPn9UvR6Jz11ujZ6HVAJ6imJeBK2DN6nBnHz3crjcXo/6x4iYxwrfgrMLoBAxLPpRCEzdmlIHA5t6yiWViM0eL7ykHRbQwOhnpxP4R9MOuNewdBXM2OWb/6MHT1nIdiJnqscaO2KiNuQ9RrVhbtD5/deGdwhUDLFJHBlqTeTPRPRsUi366cCfvBRTjwk9zTYQCaBT835PoHDqcecOBmP1x+WZyiLwUMJmFlHKjTEBK1w7YrtvdfOVznWpD8Rb3Tw/kI4kUh+vufpeh1hLylpId1BpBkHJNjnWmcSCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 5:33=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 28 Aug 2026 22:26:40 +0000 James Houghton <jthoughton@google.com>=
 wrote:
>
> > Userfaultfd minor faults provides userspace with the ability to manuall=
y
> > install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
> > map holes in the VMA when a naturally-aligned THP is present without
> > explicit action from userspace.
> >
> > This is a problem, as it bypasses userfaultfd minor faults that
> > userspace is expecting to handle.
> >
> > If userspace implements post-copy live migration using userfaultfd mino=
r
> > faults, this situation is currently possible:
> > 1. The VMA for guest memory is userfaultfd-minor-registered and nothing
> >    is mapped in the page tables.
> > 2. A stale copy of a page is present in a naturally-aligned THP (from
> >    pre-copy live migration).
> > 3. khugepaged collapses the mapping of the THP, installs a PMD.
> > 4. The VM now has access to the stale contents =3D> VM is broken.
> > 5. After installing the correct contents, userspace attempts to map the
> >    page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
> >    unexpectedly mapped the page.
>
> Did I read somewhere that this it biting you in a real-life scenario?
> That would use useful info to spell out.
>
> Or is this a theoretical thing?

So far it is only theoretical (but please do keep reading). I caught
this while debugging a related, real problem.

The real problem was that userspace was doing MADV_COLLAPSE (*without*
userfaultfd registered) and assuming that page tables wouldn't be
created. This is of course incorrect, but for some reason we only
started hitting this after moving from a 6.6-based kernel to a
6.18-based kernel. I don't know what change caused this (most likely a
downstream change), but the real fix was for userspace to instead do
something like:
1. MADV_COLLAPSE (let's assume this must be done)
2. UFFD_REGISTER_MODE_MINOR
3. MADV_DONTNEED
and we're good to go, right? Wrong, in fact!

I noticed that there was indeed a circumstance where khugepaged could
create PMDs even when userfaultfd *was* registered, making the
userspace fix technically incomplete. That's what this patch fixes.

I haven't yet seen this in our production environment (as far as I am
aware, hence "theoretical"); we don't actually have that many VMs
running a userfaultfd-based live migration stack anymore though (maybe
tens of thousands).

I hope that extra context is helpful.

> > The naturally-aligned THP case is the only case where this is a problem=
.
> > khugepaged otherwise requires all PTEs to be present for
> > userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
> > correct. This check is essentially bypassed for naturally-aligned THPs.
> >
> > No changes are needed for file_backed_vma_is_retractable(), as zapping
> > PTEs is safe. Userspace must already handle cases where PTEs are zapped
> > without explicit action (e.g. due to reclaim).
> >
> > Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed p=
te-mapped THPs by pmds")
> > Cc: <stable@vger.kernel.org> # 6.1
>
> From the changelog it isn't clear why a -stable backport is proposed?
> I assume the userspace-visible runtime effect is a rare and bogus
> -EEXIST from UFFDIO_CONTINUE?

Although this bug is likely pretty inconsequential (I'm not sure how
many users of userfaultfd minor faults there are), but rarely getting
EEXIST back when UFFDIO_CONTINUE is a userspace-visible bug that
doesn't really have a great workaround.

Because this bug essentially breaks userfaultfd minor faults,
*technically* live migration implemented with it can sometimes corrupt
guest memory, and the hypervisor (like QEMU, but QEMU doesn't use
minor faults) only learns about it after the fact, after we get EEXIST
back. IMO this is enough to backport the patch to stable. But if
others disagree, I don't really mind.

>
> > Suggested-by: Lance Yang <lance.yang@linux.dev>
> > Tested-by: Lance Yang <lance.yang@linux.dev>
>
> Wondering what Lance tested.  Was he able to reproduce the bug?

I assume he just re-ran my repro, but yeah I'm not sure, heh. Lance,
what did you test?

> Sashiko might have found another race in there:
>
>         https://sashiko.dev/#/patchset/20260828222640.1638457-1-jthoughto=
n@google.com

Let me get back to you on this. Best case, I'll send another
(separate) patch. :)

