Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA776CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 10:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0516B008C; Sat,  2 May 2026 06:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70306B0092; Sat,  2 May 2026 06:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E7F6B0093; Sat,  2 May 2026 06:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A69686B008C
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:15:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 417F6160615
	for <linux-mm@kvack.org>; Sat,  2 May 2026 10:15:48 +0000 (UTC)
X-FDA: 84722073576.10.BB3ACB7
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 39AC7140006
	for <linux-mm@kvack.org>; Sat,  2 May 2026 10:15:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CpCsdJD3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of anindyaandy1904@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=anindyaandy1904@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777716946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQXXHYVJIY4LKZoouvJIbB7tnUE2GiZVxM8bW2pK/w0=;
	b=TXDYdIpBU09fRL9ltrb9DnuRxEgUaW4ZQgfz2Pp+Ub7O76zYaIE/LObFkLd6RlEC5yL4HN
	yWopqapDF9UhE80iOSWpha2y7jNHSbDW5NICDSO1DO9XhqRUUX9gBZEMssJkCECYRwBLBY
	Qx5xe2aeECzBkrxpBtt/b52LBnC/+4o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777716946; a=rsa-sha256;
	cv=pass;
	b=c5uavK88CiopS+8n84IZvOMZbLwcrCOwhn9Bl4XvIlPM8qT3CEWtHfyo4MBh1wAeP7rh/U
	gglogDjbVqCBF1EbGcrTcYPeBjaMgQbtYm4ef1JnBq+TTYzKzUKrFM8KTV60NP+GzZYFA9
	grtVH2ZaFjNNQN3x9x591qs+3CLvZ+Y=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CpCsdJD3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of anindyaandy1904@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=anindyaandy1904@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7de4e6c5a30so2325164a34.0
        for <linux-mm@kvack.org>; Sat, 02 May 2026 03:15:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777716945; cv=none;
        d=google.com; s=arc-20240605;
        b=jm21uukrz/lIaObUDON8X7pYYjkGkzkbhV3C6KoQRLWSGwO7UIcEeLKKhbjvVZ/0cX
         h0Dh8xpjtAmnr1MpCBTkWrNVtpO2Xs+hi3fYOL1o3NjTiYcHNUt1Ou0ZiFT7+t7toRxh
         DbDwAaYXeqajzV4tssKILIV5h1v1PbFTUYVtlp9hbIFjPR3FI5szEJtdMgGU0de4u4yT
         nBjcaCbgr4XESzC2UX/r/xZ/vtq2/HKybXMEvOeWZXXkX9wMnfUpPmGMHlysF87pCs3h
         iZG5WDaxCEmwYWs9sbhgtgiaQhqspkHSXc1UPNyoDKKR4XYM9CVqrcG3v4vLdnSm9HXw
         vNUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fQXXHYVJIY4LKZoouvJIbB7tnUE2GiZVxM8bW2pK/w0=;
        fh=iXukfrs6/ym4hh/e10q/O31MmX2tFLeyyNhr/4IbHJo=;
        b=jVMe1bILljnFA+R8GEKPKN/r4up4m/HRmJ8lEilRB2eUI6R4bO4wRdBXeeYHOUst+1
         Vd8Zzw6afQHpWEvi0qWgSf8wCCbdt4Sa8/9eDN22nhRvMuWj7Z0xcXuY0sZzqxFNXb+M
         zBr+GCrrJhhG6vBdXl2HAEk7Yn3ZD6uFYN3aoBaB3Rjv1H3XIenlQwYxjEyKVtUR0JpF
         7iES0QI9RJKYWDkhnzjC++3lGX4BMb5rzbFv94ZdfPQ+MhHZe1z1FXDjZnLMvXOokAVg
         TtwHs4QfPDZA6tWq8GWToBBaPZO4yewt0Sqh0hp8ttTifX9PKRNfVjriG60ZRvcZlZmm
         7U9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777716945; x=1778321745; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fQXXHYVJIY4LKZoouvJIbB7tnUE2GiZVxM8bW2pK/w0=;
        b=CpCsdJD3fElnjGZZItXo3DPbh4Y9HawJI339Pv4E7SRfcscZrNJQhyp9Odk34qR3P7
         dsSuWUm4T4i/OwU89kqmGy7XwZlZdilhLqx6p/wEfhEdK/2MRTg3gR+PLuqMHWh/qlJG
         gyhwF3eeNUZYoX7mRLz7SyeJ9WsUmW7La0xvB0owVqbLEt/Dj8i7IhPq44+7hlF/Mi9k
         37sdPuyRIqWyloK2MQtyYWAw0YZbQ4kun/djifoqP5fGilFDAlZNZ/aBoJgR1kudVet1
         IR/g3fH6AWY9sNrRQXTjnDDOfBOU0n7xMfxD7/NyeEwUGQRNo+DmoQP0w5PShpCXcICL
         35VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777716945; x=1778321745;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQXXHYVJIY4LKZoouvJIbB7tnUE2GiZVxM8bW2pK/w0=;
        b=KZ1iSbK1px6MA3y1+aosTTStZxk+tV56vCyU0Vdg3AAxCTEop3B9Z1xAa5WfKQ4Taz
         NIDcTplcsaslk173lRzj3tUplH60PJYMx9l4TeRLbsNnqcxVnAaeH3ghJ7duu/08z8pA
         AwxRfuuTuz7bdlU2TWzQXjE+0ocsxvthi7UMYwmBVgM87azK+DiGZtG5XTo4BmY0uMPT
         n+2BRGEICQbppENqLFN1VmQnVAsjVmtqUE8j62dPOuV7S1R1WGJAIOGmZjxBpjXfQ2Dp
         owoWjT8PZu6evJJTd86oPNy58XcHQAE8EEg+apXmF6+fNMnlpV3xT9GsL/s/8cAAZBZp
         sO5w==
X-Forwarded-Encrypted: i=1; AFNElJ80xTpSr8oBoAnSwCleajrt1cNNzravfSDvlVVn14QFODuOekM7EA3YsoXFn45zGV/5c6mEx4XaQg==@kvack.org
X-Gm-Message-State: AOJu0Yx/Cqj3GHQ+NUlVB4m2ne1z6D522DLj34iAWmmg3jdONiyzOQny
	rG32eXR5ck/VVo/C9pNZ9IGOf6C/Kf/x8qh0QLuPORMMngkMipU0XOqngoFTxuFK18pmwD5pkp6
	S5Hb7J+6yrI9xCJpoxhltspdqWAU0/P0=
X-Gm-Gg: AeBDies/zwZEn8LxHUgup5AfpUbHXGrDsKPw9TU5tunCZBShIeBKaBaxQnmRbP3Hmtg
	t0KU5WyRCpul5+mjr1z8wCFYRcdt7YSeL5coNTAGw6A9++PxKXi9aagFa8c1vIjjgpbR7/K4uBP
	DDyIVHCduHzQ/tUTwtbwyCLyPPVIGnbpqsAkImSZWGLUxbBX9dzxGnD9guo5S7Woe1n5ovn+vA8
	YKe3VgfBUpyh95FgF5udFT7Neu7tN5OWLOs9HL905gBnncSxqesH0Ij0cwDzf3bdliR56M91eXH
	tx2z2buiXiDHtSqjHgkj
X-Received: by 2002:a05:6830:4422:b0:7d7:eabb:2a5 with SMTP id
 46e09a7af769-7dee148a3a7mr1654707a34.24.1777716945145; Sat, 02 May 2026
 03:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAMyZbw_ppC7F98+5huwmGjz03UGv8L8MoU9zL2_YYDU=fA3Qxw@mail.gmail.com>
 <20260502024012.30be89b2549bb18a1a1d0ddc@linux-foundation.org>
In-Reply-To: <20260502024012.30be89b2549bb18a1a1d0ddc@linux-foundation.org>
From: Anindya Roy <anindyaandy1904@gmail.com>
Date: Sat, 2 May 2026 15:45:31 +0530
X-Gm-Features: AVHnY4JFedDdm29mHhzw6e61QKtUV9l5vUgkzAXV8q67gE4CyZTcX2NS_wIc_UA
Message-ID: <CAMyZbw_tH1mOqwzsPqvY2NLW9gk3q-hpjtQPBm7wtj8OZad-7g@mail.gmail.com>
Subject: Re: [SECURITY] mm/userfaultfd: cross-inode page cache injection via mfill_copy_folio_retry()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rppt@kernel.org, david@kernel.org, ljs@kernel.org, security@kernel.org, 
	linux-mm@kvack.org, lokeshgidra@google.com
Content-Type: multipart/alternative; boundary="00000000000006d2860650d2fb1f"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39AC7140006
X-Stat-Signature: 46hhf3q5kn1457x5eex41p5ncrstfoqw
X-Rspam-User: 
X-HE-Tag: 1777716946-464014
X-HE-Meta: U2FsdGVkX180ZyYmKaZdVV3Oz/AP7GOmBdj327H4j0E7zq8tTFAMZxtp7ArnPH8G8O2+mcILTTwzgoQnl1NVw4+O1Yr4IEh6pmVvlMu5zjPD9tlfM6bezEm5MnfvUTuh7Agx0Ze7AK1swJSHnbqk1M61iDEzouL87YZ2cYb0iqGCYvpQQVKS7VCifabwdTPhqtatNB0k+dAhatjEImVlCp/ncaG5rTWR6m5JfKKxP6VVDV5fZ32TSB/u2gZfiYgMTdKR2EeovFpy4RvKDQmN3mpIiLAoSVio+Ba9yoB86NYdvJciabs3X3quF1bIXSr3wPZeVHZF+XTYPf3XvRL0FyWuya84yNetfQNh7u2H841pvnffGTK0gC9yxpsxb7/IvkxlLFryn1wfXYxrwoFlaybHIobuYv+e1RNB6jo64TLfh8YVP+lc6uF/xcTgVqQVSBq2h0kzILDQpBtNBFHuVl0vVJtET4TyunEKzTS9/UyH1Zq2Rr5U2Ry/Ght0uYeE07EvhuH3gVf5nEPZGDpgNYS4ekdUEjuNJWtnPRsMDFOJtCyGWWGEePPzzcE95/nofIpC+juky8YROagY9WsMr4qnKZ/tlyvh8OucE9ydxnLmu5rF7sqdOxklS3U8Eizj5s0eQ7GenQcjWSpROmWyM1xahK2FGHymX6oVQQVWgIHBksokheWV/GWgQVLNCfFgTul57ANNwoiWyp8xxmiB5ub5sTbo1tzI+T77Dz1u7iv+GH01nXEbniLqfXc7KL/xZL7jSPPc4LqGF4KTlXBxW/r5cK7v8+QdnOrB8y0QNp72n6i3ER/h0fegsvXAgz8+mbpqI6koZxhtwH2q4MtRBD324cu7DMEQ3bFj4QoCxFodZPJGrtL/SYmBl5xMLhF+fFTQ35pPUq6MMM1gADkkOmmFHNoR9KPCFFufd1SEIdC0773GZ/DCKYfDrvjdgtj0ZbQWBNpyCVfEB5F+zCW
 2cu0kJit
 yPAnDq/7uZux21ST8zfL/e/uaHJFgkpf5C8HPp3Sg16nGPmJZcQTrqDsm2yi8eMbItREZ92px3WCHJ+c20RmhE8yYCSM74F5f9jjPJcDUp9jfVk5fjjio0VVQSKhIF0lb7oaTZBA2G8SNDeyDSAHXZccDXtdyR9E3vw2WPzXg8nivLmu7+vifJ6qWOcFHeGAp230UWIdC8bFlBRoGcbaLRBCuJPxeoNy5D2WlqslM9SJpwSULyz5KRrZ37myYqLMhQWHZrsOuZSb5QxZ7fbXc/PCVEbx3dFskepUE+c4fT4srgEYFPdqf27yHAdTmQAgFxDAO3gd6y7qlgiNEwnNcxPc3YrwUVboRtfXUqu2DdlS91t5aUeQZ/0gNTm8wVWu2PWq1cYXUUPb8EdQSBrTJiasi3nunfvCadi2slK2S8/FcORIFQAiX3G9QpwPWYcES/KFCY6ZFufgy8FJg//Wb+e7eUaJ33c9FKlXkVNyCt/sXbYV2bafSgnz26TPc1t13LVLJJD97bs8aJzLkx3rFpqRGRnOnDhIvwCMFOYWoo5yPn9dqqJ6LZB5iEe1LI+35Z9ev9ozdmUkUELpR+lKEKAuKxSKMHGZq4Cg5EuVJms2SeWFJaSdO7hg8o543LHC7h8utCTYtxWMi41KmbvJLEzCt+e1b9R3+HRW/q05TSZMxd5dhcQSgtLouxO0FIPrs317xp0FkqX6KF0rNNr8L7cOiXDIEBf28IVOkjlR7NDHElPTwwim6oX/FrHB4EebCTiIqR6LEHq5vRO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000006d2860650d2fb1f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Thanks for the response.

I used multiple agents to analyze recent changes and explore potential
attack surfaces in the userfaultfd retry path, and then followed up with
manual reasoning and validation. This led me to the missing vm_file
validation after mfill_copy_folio_retry(), which I confirmed in my ubuntu
VM.

I wasn=E2=80=99t aware of the Sashiko report beforehand. From your excerpt,=
 it
appears to focus on VMA type mismatches, whereas my report demonstrates a
deterministic cross-inode page cache injection primitive due to folio reuse
across different vm_file mappings.

Happy to provide a reproducer if helpful.

On Sat, 2 May 2026 at 15:10, Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Sat, 2 May 2026 13:50:02 +0530 Anindya Roy <anindyaandy1904@gmail.com>
> wrote:
>
> > Hello,
> >
> > I would like to report a vulnerability in the Linux kernel userfaultfd
> > implementation that allows cross-inode page cache injection due to VMA
> > replacement during the UFFDIO_COPY retry path.
> >
> > *Summary:*
> >
> > A local unprivileged attacker can inject controlled data into the page
> > cache of a different shmem/memfd/tmpfs inode than originally targeted.
> >
> > This occurs because mfill_copy_folio_retry() drops all locks, allowing
> the
> > destination VMA to be replaced, but does not verify that the underlying
> > file (vm_file) remains the same when execution resumes.
> >
> > As a result, a folio allocated for one inode can be inserted into anoth=
er
> > inode=E2=80=99s page cache.
> >
> > *Affected component:*
> >
> > File: mm/userfaultfd.c
> > Function: mfill_copy_folio_retry()
>
> Thanks.
>
> > *Affected versions:*
> >
> > Introduced by: f5f035a72423
>
> Only in 7.1-rc1, fortunately.
>
> May I ask how you found this?
>
> Annoyingly, Sashiko found it:
>
> : If the locks are dropped during the retry, can the anonymous VMA be
> : replaced by a different type of VMA (such as hugetlb or shared shmem)
> : at the same address?
> :
> : mfill_get_vma() accepts these VMAs and returns 0.  When execution
> : resumes in mfill_atomic_pte_copy(), it proceeds to
> : mfill_atomic_install_pte() using the newly populated state->vma.
> :
> : For a hugetlb VMA, mfill_establish_pmd() will allocate a standard 4KB
> : PMD into a hugepage page table hierarchy.  For a shared shmem VMA,
> :
> : folio_add_new_anon_rmap() will be called on a shared file-backed VMA.
> : Could this sequence cause page table corruption or kernel crashes?
>
> We must have simply failed to look :(
>
> It claims to have found other things:
>
> https://sashiko.dev/#/patchset/20260402041156.1377214-6-rppt@kernel.org
>
> >
> > ...
> >
>

--00000000000006d2860650d2fb1f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hello,<br><br>Thanks for the response.<br=
><br>I used multiple agents to analyze recent changes and explore potential=
 attack surfaces in the userfaultfd retry path, and then followed up with m=
anual reasoning and validation. This led me to the missing vm_file validati=
on after mfill_copy_folio_retry(), which I confirmed in my ubuntu VM.<br><b=
r>I wasn=E2=80=99t aware of the Sashiko report beforehand. From your excerp=
t, it appears to focus on VMA type mismatches, whereas my report demonstrat=
es a deterministic cross-inode page cache injection primitive due to folio =
reuse across different vm_file mappings.<br><br>Happy to provide a reproduc=
er if helpful.=C2=A0</div><br><img width=3D"0" height=3D"0" class=3D"mailtr=
ack-img" alt=3D"" style=3D"display:flex" src=3D"https://mailtrack.io/trace/=
mail/6989cbc25ae6c2b553a977b8156212ad5302d126.png?u=3D12810248"><div class=
=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr=
">On Sat, 2 May 2026 at 15:10, Andrew Morton &lt;<a href=3D"mailto:akpm@lin=
ux-foundation.org">akpm@linux-foundation.org</a>&gt; wrote:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1=
px solid rgb(204,204,204);padding-left:1ex">On Sat, 2 May 2026 13:50:02 +05=
30 Anindya Roy &lt;<a href=3D"mailto:anindyaandy1904@gmail.com" target=3D"_=
blank">anindyaandy1904@gmail.com</a>&gt; wrote:<br>
<br>
&gt; Hello,<br>
&gt; <br>
&gt; I would like to report a vulnerability in the Linux kernel userfaultfd=
<br>
&gt; implementation that allows cross-inode page cache injection due to VMA=
<br>
&gt; replacement during the UFFDIO_COPY retry path.<br>
&gt; <br>
&gt; *Summary:*<br>
&gt; <br>
&gt; A local unprivileged attacker can inject controlled data into the page=
<br>
&gt; cache of a different shmem/memfd/tmpfs inode than originally targeted.=
<br>
&gt; <br>
&gt; This occurs because mfill_copy_folio_retry() drops all locks, allowing=
 the<br>
&gt; destination VMA to be replaced, but does not verify that the underlyin=
g<br>
&gt; file (vm_file) remains the same when execution resumes.<br>
&gt; <br>
&gt; As a result, a folio allocated for one inode can be inserted into anot=
her<br>
&gt; inode=E2=80=99s page cache.<br>
&gt; <br>
&gt; *Affected component:*<br>
&gt; <br>
&gt; File: mm/userfaultfd.c<br>
&gt; Function: mfill_copy_folio_retry()<br>
<br>
Thanks.<br>
<br>
&gt; *Affected versions:*<br>
&gt; <br>
&gt; Introduced by: f5f035a72423<br>
<br>
Only in 7.1-rc1, fortunately.<br>
<br>
May I ask how you found this?<br>
<br>
Annoyingly, Sashiko found it:<br>
<br>
: If the locks are dropped during the retry, can the anonymous VMA be<br>
: replaced by a different type of VMA (such as hugetlb or shared shmem)<br>
: at the same address?<br>
: <br>
: mfill_get_vma() accepts these VMAs and returns 0.=C2=A0 When execution<br=
>
: resumes in mfill_atomic_pte_copy(), it proceeds to<br>
: mfill_atomic_install_pte() using the newly populated state-&gt;vma.<br>
: <br>
: For a hugetlb VMA, mfill_establish_pmd() will allocate a standard 4KB<br>
: PMD into a hugepage page table hierarchy.=C2=A0 For a shared shmem VMA,<b=
r>
: <br>
: folio_add_new_anon_rmap() will be called on a shared file-backed VMA. <br=
>
: Could this sequence cause page table corruption or kernel crashes?<br>
<br>
We must have simply failed to look :(<br>
<br>
It claims to have found other things:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"https://sashiko.dev/#/patchset/20260=
402041156.1377214-6-rppt@kernel.org" rel=3D"noreferrer" target=3D"_blank">h=
ttps://sashiko.dev/#/patchset/20260402041156.1377214-6-rppt@kernel.org</a><=
br>
<br>
&gt;<br>
&gt; ...<br>
&gt;<br>
</blockquote></div></div>

--00000000000006d2860650d2fb1f--

