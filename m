Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B3BCD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0D26B0005; Thu, 11 Jun 2026 16:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DF26B0088; Thu, 11 Jun 2026 16:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D8D6B008C; Thu, 11 Jun 2026 16:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9609D6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:44:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33F534085F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:44:59 +0000 (UTC)
X-FDA: 84868811118.24.1DBB481
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3552318000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:44:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wndcYd6G;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781210697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R25VakW0RBUev3UiF4u6b7DOEi2czhIVwldQzjdZNDA=;
	b=tAfoUIyiq54KI0u71tfzZUfWwljWs0sIzNYnGXoPYwsb/q5JJxS1Rt1tGBS8+lP1qrtQLA
	v0UULyrBx6tfNy3eZhXcZE7uPlEPivbnjKihWOPJEeTFoUYnRSvnrXxqRQbdDgPvvDGWsB
	CwogC3r1qdn3HeUq6/+vM+N6g2rHPKA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781210697;
	b=hIixN/7be+oFMHmQ6WARDBTeOjwT3S/+lBlbvbdwUKFIgQIv1SlIWEbhlZylfn9GNlW8bJ
	VDXh9R5PKjaWoGGA8IbUyifetbwsT5opQL2MHh4ZBbcGem+TDzGgZpajFvBlSRxJgWZi0a
	+5VG3dcLpytbPqP6tOsasFJxS5USXxs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wndcYd6G;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5177d1ff061so42231cf.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:44:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781210696; cv=none;
        d=google.com; s=arc-20240605;
        b=jqaizvDAadYt9X0JGeogMK4OE+GDmKL8DfVZhITWt8BV6Mhytk8LKsF7kODcdS5k3I
         mA6lduI423VjihxG5+RuZTM83xzFHZA0jBGIFJC23SBPcP9NzZRIM44IgHeN+YfIQzFi
         TvSxIIqWiTVMVzhIfGiBTaHKCtl04DlGHlfIzUPlYBqDUpTF2mJAzaAjjHHRCm3fCDDh
         PnU3LPHe71FkTWSV3fMpHTAB9zP2pXGZfCfXZea5thhnt8GMP6/irS3QERM3NfJ4dSdN
         lw+By43RRA/+dTy30JHa/dz+awB/nXCF84q5GbfvqP2yT6w/f2xYnr30VIY426SAsAE9
         bQ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R25VakW0RBUev3UiF4u6b7DOEi2czhIVwldQzjdZNDA=;
        fh=ssqs4MCY5wh49ZMSK2e2b4/q0hwmSe9SGDS0fMtfRxI=;
        b=hGb6SxFxqcwXPCAVa+tZpC91v2Hdi94McHC4MZOdRUnsd7RzgZ9KnCkkT8dBUYeOBD
         TcAKP7+5syiIOZGJAQeMTXuEElY/cwSIMzyVx4Ei2dSneVoXeU+sX8Y4lnMt3zFwdavh
         /nCSJZpMCL3OfIhkVegeAn08LeL5Gf2/Jnq2OVUM59VI55JJ5VZc+JmE5GsAzHFXbPNT
         qUdgRmYHKpOzz596xuNeAWiA44A3v+n64mceviIDI480161TSKsOyckfxG6TLHqAOYiI
         yROrhX/+z0zqUSd5qNdyQBGcTYDZUOWzMu+F/5bOKrxZtgsYeE28nNMnpSP4aWg2jrOu
         Ex8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781210696; x=1781815496; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R25VakW0RBUev3UiF4u6b7DOEi2czhIVwldQzjdZNDA=;
        b=wndcYd6G05vnEcmQxMAoBXT7Ik7R9dbV3oPtjUjB6TaRusYUeYTNhl+e+Zj/+sn/Kt
         BZY+1rnfr3fGwoz8Zqv+PNdGRlAHkzmvPGqJZZ+J2vvn1E/CJmCPtTaDZtVlhneEoiuP
         d7n/QvnNIcV+gY3xrrdMRPLSVg9g6S/gFnVkP5SknItrx4ZS5iYvhumpEdXblOjqnity
         6UiuOc/sG+d/McZ28GjRsb2Q9i8fD1ws+cI+jR+l5KVvR8/k2ilBEtSDwr3aH9J6j+Dq
         VRNxQn/PwM6vKAHVllLL1Kvp23V/U+mSXswomzWOoavKqMEDkrj04c4aKnzDx10E66Ro
         6kYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781210696; x=1781815496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R25VakW0RBUev3UiF4u6b7DOEi2czhIVwldQzjdZNDA=;
        b=gK9RUJQ8c0QbB1q1cISoaMRenKVcQdKRM24gPBUICoK8CsBlwoZVFpzjwunY3PpmmW
         1NhEv/nIhNhL0/BP9sHC9Z3hxoolS11uK8FGEs8XDySF9lT3sh4X6MHgdFPvMxx5XKOv
         0rt85a4JzS8o6ibuW28GW76rfXqmB84T2ijVgw5IzdS3AIQ9jv2Koh/00QHFvCoU6uZi
         lsGWcan3o8IAiU7lX+2rULn5OyvBuTFJj1Ezf5lmLDgGvOHJP0VKTfH7LiKC1vgHrQRf
         /8Xjj77BYKXTHig5Tc9aAhMzUlKPM8sqxGbpd6PCoAHnSfO52YGkInEgSC2lrukPBbfE
         NUrw==
X-Forwarded-Encrypted: i=1; AFNElJ+PU80xDa1C5nvs6M4+HHsCLs39XzCoQVSbKf4nC0myRCIpGfgdVPZZU57KBqir1YoJIjTi48papA==@kvack.org
X-Gm-Message-State: AOJu0YwE+hqTXqbJ3GyIt3kE14Io+pTIu4KXUSaHk6XTCjltKFkJNA/V
	ibVe77Y0nS6IvzkI7FruhTzCCfooau7UzcwWvKPhYL3lFc0elrIAJ0PNoI6MV4BCrcNVMKvWvlQ
	7jXtlyXXi8qEEyuVj4929ksRL2v4+Q7sDu4iovitJ
X-Gm-Gg: Acq92OGVqzQbqbHlNwpQ4qFsrK/ZdYsR952Ju2bKn7BvVHDPv5jnDeXtliJ3+zI+wRa
	GYq1WcRuJsLAeIBQ7qev5L4RsDMYyJKCgmno/F1pJ7hRpnclS2B5YxNzXd5rQxLxsZedgfNdJLB
	f8irriHm+13kVGUUynNpvl41aKHTBCsBu7n5yMLIilMprGLrhPnHuB++1jwrjYcVNLh2CEG8HzJ
	QlmRi1d5NIyvKpOORImh6HOMKGP/uWsNTsKedniH0bqo82TnWcBXWW8kK0gTQkhRXqElNAEFklN
	dhnmO7jYxIfbzd+GXjfYNzpy527cWUQbE3jKJscUrxT9W9Y=
X-Received: by 2002:ac8:5ccc:0:b0:517:99ea:ab79 with SMTP id
 d75a77b69052e-517fc55fcb0mr654001cf.25.1781210695733; Thu, 11 Jun 2026
 13:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com> <20260610230419.F746395F@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230419.F746395F@davehans-spike.ostc.intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Jun 2026 13:44:44 -0700
X-Gm-Features: AVVi8Ce6L-9b-YJ4eJTdZgAldSAMooh3Z7_4xrsEdTCFqBgSe6VDwSOKn0GixX0
Message-ID: <CAJuCfpHhTnJRoQJ_V5qLbeccKL6wKWy1z9Ri6aVkrhxir3i8pg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] tcp: Remove mmap_lock fallback path
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3552318000E
X-Stat-Signature: 37sxnsa4cwy4rdppg4pfjntyrks85jfq
X-HE-Tag: 1781210697-861318
X-HE-Meta: U2FsdGVkX1+ny3aN91jFQygqgl16nTN6PlWYwLNpmZoMkdvzkPYsF25vSH8QzOxDO1EZu4TZRGe5aLskMaB+28N0QY3ivud0hn/ljAyvPIgmVytKQEGsDh8xXnZpr59TBGV7NsaFbc3bjEXHwgh42ZclXx0dQWZ8h3Jd0u330soySrY1AFk0gzPWeHg9NsBdDbf1zJjR9YjMY5QaWPfWzPHUXbohdARD0UHw1ZcpNOVW7naWLyMy35nR9vtQ/aJCPyuJTIujbXKgIg0ocJSDMyihjxfGuP6nkrzIMEKXPwjrcn9f0uHTaD9OOjJxGp8W2hN4rR6F2WXIWJ78kwqN4Mg48YFt6cYOSyzAUXRJ7Iic1feCoeZdzSJ3bCGlpagtCyJuTa2arvpLxqFFYOwU4/8VNvNfi302shZgvVz9occIeYNTG3JTV6Ub2N2pVRrlkBW3GgDCq5BbQd3gUVzjzrox2QFQRdaq1gVZswwuf8mjdIwA5AlYuZm9tY+vO/f67tPLURib6EvcINpvbZ4BRHSuTuUwygzeNz9gA/BbbVl0bY9G+WBNUCb/iRJjSCpowKNaxLonnWSRq4rn8uqSd04i1LLiJ0V0enxzfpAPDEQcLoeZ5JvlbbQpESG1+KC/9e2fApg6i+G3X+CRO3PlisiJMpifBy45QAVqRDrC341hBJWTMCeOA6SYLmNN7KEQNKYlDN10LPHsGHr1QuAMNida7oSDDa5+yOZJLGHAU2mw6qy7FCwxt9tyW+RAUVmFOBewaBi5Csw17CqQuhUiMERRy0kARs3JdOnsFYRKYrh0zjLW+tvOCfhafZXYYxI/avfUBPoJMwcqKQens8dYWQ5/pYMt4BnE9TcFiXpmJ1Dn2YwaFRxabxqdM1Sqt8jnAMlaDifsViWbJBfTb86W0jP/YNeiPzBp29Ov3WsnOfRqzOzIrqOKfEt1ejFpIgXPTzwFIaQmhQ+1eq9aD1M
 XaWjJI3L
 /ujqYGaw4m8MjQxIYqSdhPxSMrhDz33CTCOmDWCswFYgcV45GP1wXBrr67O6toJaKF1oD4e+njp9zmPE2hCFY1bm8qsNzBvYoKoZjPt/dY2vxpLMDntV/XV/6ppVz2A4DfXW4hE3YccNtCwP+6bOax32u/1F2joM0s1xVEpE29j6wWwMYfCo6qVP9Nasdm/UTxGmg7AsRE/ZYyzRTAtGT//tsmfBW6hqfeMY4HlWQW2Mi4Y6uscx23PKxdaGsH78pn1nSyuWC1Xl2Z6lu5F/rP2N4r0/v/O/I/AhUFKl7iEzS0MqlUyWQAExFghpE01DGxZ7zJZuYwLBdN4OrMDoT7T9LKlplSygne0tLbTiXmAKmXMkPcG2EOHsT+hvsjLWqmBWfwN8C1mpuZ0/PHPbZtsbiMUyBlYNssIC6Yb07xtRlDRIWFUFJBRwfleASDNT0FTnw+xPPTu6s8AFrT9qfso16RTGFBTXGEW13BxhA7J/jArETkTsVPBpEmeT+3OlwN5vagKRRb7M7QuOCa18DTkG+hR946KW5spMUWAHrwe2C5+lmHMw6uSPfmLavAiiE3M/r4w26ncWHBUAE3sMgpWMK88WlnZgAsGVMSfXtVx5pDLNaNwkMVd0uwdCTXJpir4b4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 4:04=E2=80=AFPM Dave Hansen <dave.hansen@linux.inte=
l.com> wrote:
>
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> Previously, the per-VMA locking could fail in the face of writers
> which necessitates a fallback to mmap_lock. The new
> lock_vma_under_rcu_wait() will wait for writers instead of failing.
>
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
>
> This really is a nice cleanup. It removes the need to pass the lock
> state back and forth to find_tcp_vma().

LGTM. As in the previous patch, you already have my Reviewed-by.

>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>
>  b/net/ipv4/tcp.c |   31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)
>
> diff -puN net/ipv4/tcp.c~ipv4-tcp-vma-waiter net/ipv4/tcp.c
> --- a/net/ipv4/tcp.c~ipv4-tcp-vma-waiter        2026-06-10 15:57:56.97247=
2379 -0700
> +++ b/net/ipv4/tcp.c    2026-06-10 15:57:56.976472521 -0700
> @@ -2171,27 +2171,18 @@ static void tcp_zc_finalize_rx_tstamp(st
>  }
>
>  static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
> -                                          unsigned long address,
> -                                          bool *mmap_locked)
> +                                          unsigned long address)
>  {
> -       struct vm_area_struct *vma =3D lock_vma_under_rcu(mm, address);
> +       struct vm_area_struct *vma =3D vma_start_read_unlocked(mm, addres=
s);
>
> -       if (vma) {
> -               if (vma->vm_ops !=3D &tcp_vm_ops) {
> -                       vma_end_read(vma);
> -                       return NULL;
> -               }
> -               *mmap_locked =3D false;
> -               return vma;
> -       }
> +       if (!vma)
> +               return NULL;
>
> -       mmap_read_lock(mm);
> -       vma =3D vma_lookup(mm, address);
> -       if (!vma || vma->vm_ops !=3D &tcp_vm_ops) {
> -               mmap_read_unlock(mm);
> +       if (vma->vm_ops !=3D &tcp_vm_ops) {
> +               vma_end_read(vma);
>                 return NULL;
>         }
> -       *mmap_locked =3D true;
> +
>         return vma;
>  }
>
> @@ -2212,7 +2203,6 @@ static int tcp_zerocopy_receive(struct s
>         u32 seq =3D tp->copied_seq;
>         u32 total_bytes_to_map;
>         int inq =3D tcp_inq(sk);
> -       bool mmap_locked;
>         int ret;
>
>         zc->copybuf_len =3D 0;
> @@ -2237,7 +2227,7 @@ static int tcp_zerocopy_receive(struct s
>                 return 0;
>         }
>
> -       vma =3D find_tcp_vma(current->mm, address, &mmap_locked);
> +       vma =3D find_tcp_vma(current->mm, address);
>         if (!vma)
>                 return -EINVAL;
>
> @@ -2319,10 +2309,7 @@ static int tcp_zerocopy_receive(struct s
>                                                    zc, total_bytes_to_map=
);
>         }
>  out:
> -       if (mmap_locked)
> -               mmap_read_unlock(current->mm);
> -       else
> -               vma_end_read(vma);
> +       vma_end_read(vma);
>         /* Try to copy straggler data. */
>         if (!ret)
>                 copylen =3D tcp_zc_handle_leftover(zc, sk, skb, &seq, cop=
ybuf_len, tss);
> _

