Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC99CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4216B0088; Wed, 13 May 2026 21:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0656D6B008A; Wed, 13 May 2026 21:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95F76B008C; Wed, 13 May 2026 21:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D72E66B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:06:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82F26C1371
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:06:12 +0000 (UTC)
X-FDA: 84764234184.21.1C3BC47
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F2DC40007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:06:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AkFpUodF;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778720770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmskMcUjaRVEW7z+TehxMGjokLyc+2WiFHOyuPxRiQw=;
	b=aobA36RWJDgfS/xp0jxn5Na7FwWGAsA8JbNiWWElQmWoXVOmjAGzOILgkrBfXeB2DW3+tS
	xFsDQ+LgJMEbwS2pw8hyOXSG/fHW9UQHOek1gjmaYuoYWZNjLlJZeQm2LGKK4Ur4ZCF/YP
	YT3/ufVjvBIZuzDECyCX1MPe/6n3E14=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778720770; a=rsa-sha256;
	cv=pass;
	b=D3ud/gl/2sFBMrLJ2NVMtTUpLsgjgn27yHFGa2ZLXHhe6Z16gToPdt5W92HM5gicQ1WT/E
	JWH5HTxxYrBrXYQHWzJngM7qo1mNb8CRG1tEYRh/kUDXdVgsjfGPr60hFCm33HLJTK/8DG
	7qRxPFY4nPNQTyUYL/GtCB/oDau+zV8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AkFpUodF;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d864c23bdso172021cf.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 18:06:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778720769; cv=none;
        d=google.com; s=arc-20240605;
        b=b/OFIB2339LYWeWwzW6Nk7t3eZ0dI/CpBEIzUxa2cQ+epZzyIo+qF4MM6ENbfDLVbP
         tL4S7o4dE7NT/x3BiyZlJx5kU4B6cZuH0o0ZXZVmtdF+K8sX/EsVWQahab7mKS3CiooX
         6ck10WYkdvwbljM9gtYP6+NU8fyEzR0NaN+AUlJm3J2HA0qbgBi0DTPhyBfPtMgMbPay
         mYp2sioqX1DDMiaYJ3qs2uxHqVeRzYnvr7VIK0BIlSpu6/VPMns3PbOwzuwneYhe9dIO
         jZL4JkSmJvBsDyy0xQ3wBkFRhWU+LS4AKq6zxk7U9TeiMfDGEs5H3Q0U1uP4jwUuRl1Q
         uKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WmskMcUjaRVEW7z+TehxMGjokLyc+2WiFHOyuPxRiQw=;
        fh=whtAjrdB10/YrYnhqdQBhe/9bKWe0j4TIlpxg8LkVDA=;
        b=Eqq3Gc7vslzCNR8KHErZVmlSC8Xp/sfNeQ/X08Xx966q7JzR6HhXS5vu2Lv8Pyyfwe
         HGtctXAclFB9T986zDSSr+Yu6wd145qGZUxPkAmPy7/mtjg33Wsxt9f3FtPOHvGVQmZR
         NwZ65XJF7UkCHJeLHJoUStEq3PacG/uXQ5W42D/SUqemvRXBUW5mxHUXR5fAabJYrjqW
         drr/M1JejmqCzXCwhux+FKbvilCmCDjrJGhEp3SW2Wfq1YiSeZ2mvJkBP6SomL5AHVex
         ic4O8h58eK7qbzESeUvkFWuvJLb+OafbrrBi0nOw3N+awCtyKbzNSb7nWZWWtLMBgha6
         pACg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778720769; x=1779325569; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmskMcUjaRVEW7z+TehxMGjokLyc+2WiFHOyuPxRiQw=;
        b=AkFpUodFMr7MLq/k3Hz1K1fUoB6nISuIniroON61SlFQb5oAb/JQdB+DLD4iYyWnlP
         3l3Kj+p4sMyXUfv6lu1vWk5afIAsqqN3yx9UDh0X96iC9VD5W+k04q6VFY9bjnOugG0r
         v2nFRNY/u8E9h6sHyHr0pHK7J6TAHsnwWIqHTsJzmf7Hpls7kzamB6JW0UkqHoXxGIaD
         JBMP0eGSEvMFApPIcZfuPf1krAOVvqpxcK6Zrz8fTeyIbf+h3SkvS0h0d053Nc+J9nJ4
         sFsqxPL72sXhTTh8QFb5o0PwRA/glovSyXgoTDSsBP5t8gXQEEYV3aO5NA8WFsg3DGHp
         c8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778720769; x=1779325569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WmskMcUjaRVEW7z+TehxMGjokLyc+2WiFHOyuPxRiQw=;
        b=q9Odf1u/HXxcitzb3BAXvuEZRwhWwSe5SLsEFoJRmAJG5ti1bECs4l/jzl1JLiKqAh
         VYn7aw4o5HnUOjHDUHsv9pfPRW4ADba4iGMcEBViwONtj1wBFqC9aXmM2XcFTMi9ja79
         BM+hfP6iFxZdIMZwVjhCplFP7x5zOdbqBwVXWiu+jCG6pNx7tbWZb0+1KSTyo2qO5n97
         ylj77Z8/2cAQ/Y2AiZUn1Ns1w6RPkK/CvAUpIonqqUE7bWDYyEZ5A7r75u8VM2Xplsy0
         a7EGuhgQp62it6YDaD5r6Dgwk1P6lE2CKxcpGnyTPJmVRBFJfZ3e+dYeT94V7CPCcPRP
         amLw==
X-Forwarded-Encrypted: i=1; AFNElJ/c3a0zZrQhNvk7VQpSQyzMaI5DNi6hmqDXVnb+0T+tiRfBqGhc6cjKMWOHWGSRd1RvTmSd/6hbJQ==@kvack.org
X-Gm-Message-State: AOJu0Yxl+n1fuw+Z8WDH1V4/HbmpJohSLRcgy4Ide0Bk+FjkvhMWjWhq
	g8+DAUd8EKjh/t/ZpJRXdPJmlfUqRIwEC1RYiYr8Ywq8KjiIvmFdCXnEoV/4IcM3onLDZIm1UAJ
	YDKxg/juufL1cJQaq8c28oYF9ozr0vyE8nlm18Cxz
X-Gm-Gg: Acq92OELOtJz5fUx7Ul0YpTCF3uGprQ6rabsT17YQ4/IyNIlZ1dbBKrKFT/GsAdin1Z
	RxFL/NN55wyfdW3HwRBvOBezGLsdkE9URbYEd+bPHjKKId77FkhNmx4SYc6oPLOJymy2DVrSMv5
	KAqa5jVA2/sbPH993sSaEnOaunipTohVxUPnGAcPBqJhDviQQe/9qvZ4LPRiFYmMPUQThJiFHOR
	ogKyb3atzzeVzw4rgV4nZ7BuNK8fSt0NHHb5BTWmTwz6XJRplPdiPs2ieW1e6rCA+BsSQlRKHRs
	qARYIX80RIUOgBXo
X-Received: by 2002:a05:622a:2307:b0:514:c25e:c164 with SMTP id
 d75a77b69052e-5164235e9edmr5546171cf.10.1778720768858; Wed, 13 May 2026
 18:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182002.BB61C7BC@davehans-spike.ostc.intel.com> <af4dkMq5D1wZk1pP@lucifer>
In-Reply-To: <af4dkMq5D1wZk1pP@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 18:05:57 -0700
X-Gm-Features: AVHnY4JsghMXFPJouXM9BWhdd1g5yBazq4Ymb-w-oufcb29Ngpest7O21oXjGtU
Message-ID: <CAJuCfpF1bZPpUyLNaB+NhZ_QxKh5e7fY4+ufYV-f=EcMyKpizQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] tcp: Remove mmap_lock fallback path
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F2DC40007
X-Stat-Signature: nudans1kosthjr59jwjyofqdzg89139m
X-Rspam-User: 
X-HE-Tag: 1778720770-590017
X-HE-Meta: U2FsdGVkX1+DhEyBWgMSVVrLo+260cq3H4R/Tbk8dtjpztUH+YBuW+WXCXJRFj8Ds/Av4N84qZoEtJzFFiO/FEIKIIlayGNA/1Lau5lmfEnDkTDci/KnUJOA4Y0rLL7foUWKodPWH85Qd0UIJdzGq47elRhwWpMUbaftGISujwYz7GC1v2cI9OG6pN4aUKmiIPUXq0WU2WcqJ3eWXx2CPKxHx48nNZAC6sLhjuKALhOi4M5iWX8m9bSvRHW3QwnYqRPAIMJQnQMfD3gaGPtvinOXwSx3NRWSAFO3o5LVwTXcik9yaaRUge/cZOi+TG/dtsVYufn5cElrzMybgV8M6oklc0x/rJJMTCYBgJXSmuf6v5f1987Dh9qW+NN5mRfljPid39BIxLR1KS4kv5sESvlN+Ej66Z1zZvTVzSGQMHM1cwELUbj57TxF2JmOlOlESI0+OHBFxzxjLgFmHiVKBEYcvs/B+Bhs/WblbzBJuF3orwZPPzz36T1mUT4tIvPgAmAS321nAcmsc3HprKmsk2ax8q0vSerHUZuWTAexVfJmTsc66YAS2PxpDbwjSdg9oSxkS7jleKnyBAaewpZrUHi29Bzw61HaKMULRi4NoCIOirFweHNlgO+VU3e+RngJab/eI5Bns6Eb1kYxCQqUf4+zJtJ14NeEiXLePafbRAn86DMGlW/sM+94Sx6P0JmLzrEEgNpMF4hePPKHzzBF7l/YLmQbz5UUS2BnHotpPj1vy3TGM/BJliyH1xB0zc30FrVJ3SMVUxuiz2lpY5KCPHX0Gjr3emtN0fDoFTrQ4ttKYiNP9Wg/ivW6KfwKkU2s+OvswHqK5xpX1E8Y6K5DRN6TTCVnSGocsVEQNdGuHGz+yxuHB1Rj4FK4r1reMoct0xpZJeSTy3IIHuZCzLBNUSK5JY+mx9nGxg66zJBSB1gmwe//9up+ot/mFAz0XZ8rzC/wv75Yb0k89ciEAN8
 31k4as9n
 GguQmgcp1DBEQ9SMfPo/HXaZiJwTJOBazpFNc9QRbwlluH+Sa2tTONMKzrDO3Px5FPLlsuY0lsg8nSoLZlCp1zMIydkR3FVu3cVzsc6ZlgOovIrrQ7DtqCRff3wfLmbKjr2SlaxN2qHt47YuhkUcXp/CPHnD7RUswTePEo9Ip28jVaPDZx3OGCkHiiM0wwkrjfWu2zUmLvcC6M3NRUwFgOf0wp+AxvWQuletacBL/wfjsWp0xNo4vkgb3Zcy2h43QAocRLWQtLzO/wq6WJUHgfCBXTeUbZR8D7e09E4gWRTgjNd42hBpHIc0kJfHS4DSyB5BUcbyNcrqsbWhZnussnZx7l4S6VYFYEnzmTTEaxrU30p7tcn5hiQvqE+BHYpXKF4/TH0MRajjYKCERiFxkbYT123SIBePgu8asB/4RhMNs65BKGIqiHQU+Zwgqqc4lHMF95jH3++yOOeypC5TyeFVLaCA1r3ZoPYx/FSgpqisd3Kv883tPzYANFIftpNr9tbSDusj1nHOkwi/aV/Ci9xLu5AWPeoVRuPlzx84xjhBKh3dG5SQyYljSfSsD+b91GOxvMb/zoklyr6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 10:32=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, Apr 29, 2026 at 11:20:02AM -0700, Dave Hansen wrote:
> >
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > Previously, the per-VMA locking could fail in the face of writers
> > which necessitates a fallback to mmap_lock. The new
> > lock_vma_under_rcu_wait() will wait for writers instead of failing.
> >
> > Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
> >
> > This really is a nice cleanup. It removes the need to pass the lock
> > state back and forth to find_tcp_vma().

Indeed!

> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>
> Yeah, LGTM again, though am not a networking guy so:
>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > ---
> >
> >  b/net/ipv4/tcp.c |   31 +++++++++----------------------
> >  1 file changed, 9 insertions(+), 22 deletions(-)
> >
> > diff -puN net/ipv4/tcp.c~ipv4-tcp-vma-waiter net/ipv4/tcp.c
> > --- a/net/ipv4/tcp.c~ipv4-tcp-vma-waiter      2026-04-29 11:18:51.87067=
6498 -0700
> > +++ b/net/ipv4/tcp.c  2026-04-29 11:18:51.874676652 -0700
> > @@ -2171,27 +2171,18 @@ static void tcp_zc_finalize_rx_tstamp(st
> >  }
> >
> >  static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
> > -                                        unsigned long address,
> > -                                        bool *mmap_locked)
> > +                                        unsigned long address)
> >  {
> > -     struct vm_area_struct *vma =3D lock_vma_under_rcu(mm, address);
> > +     struct vm_area_struct *vma =3D lock_vma_under_rcu_wait(mm, addres=
s);
> >
> > -     if (vma) {
> > -             if (vma->vm_ops !=3D &tcp_vm_ops) {
> > -                     vma_end_read(vma);
> > -                     return NULL;
> > -             }
> > -             *mmap_locked =3D false;
> > -             return vma;
> > -     }
> > +     if (!vma)
> > +             return NULL;
> >
> > -     mmap_read_lock(mm);
> > -     vma =3D vma_lookup(mm, address);
> > -     if (!vma || vma->vm_ops !=3D &tcp_vm_ops) {
> > -             mmap_read_unlock(mm);
> > +     if (vma->vm_ops !=3D &tcp_vm_ops) {
> > +             vma_end_read(vma);
> >               return NULL;
> >       }
> > -     *mmap_locked =3D true;
> > +
> >       return vma;
> >  }
> >
> > @@ -2212,7 +2203,6 @@ static int tcp_zerocopy_receive(struct s
> >       u32 seq =3D tp->copied_seq;
> >       u32 total_bytes_to_map;
> >       int inq =3D tcp_inq(sk);
> > -     bool mmap_locked;
> >       int ret;
> >
> >       zc->copybuf_len =3D 0;
> > @@ -2237,7 +2227,7 @@ static int tcp_zerocopy_receive(struct s
> >               return 0;
> >       }
> >
> > -     vma =3D find_tcp_vma(current->mm, address, &mmap_locked);
> > +     vma =3D find_tcp_vma(current->mm, address);
> >       if (!vma)
> >               return -EINVAL;
> >
> > @@ -2319,10 +2309,7 @@ static int tcp_zerocopy_receive(struct s
> >                                                  zc, total_bytes_to_map=
);
> >       }
> >  out:
> > -     if (mmap_locked)
> > -             mmap_read_unlock(current->mm);
> > -     else
> > -             vma_end_read(vma);
> > +     vma_end_read(vma);
> >       /* Try to copy straggler data. */
> >       if (!ret)
> >               copylen =3D tcp_zc_handle_leftover(zc, sk, skb, &seq, cop=
ybuf_len, tss);
> > _

