Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64323C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA42A6B007B; Tue, 21 Jul 2026 12:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55186B008A; Tue, 21 Jul 2026 12:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945E86B008C; Tue, 21 Jul 2026 12:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 644E36B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:30:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED25C1401F0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:30:23 +0000 (UTC)
X-FDA: 85013321526.10.798DB76
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9751C000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:30:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="mBt/uHTX";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784651421;
	b=ZqMr8w2Mc96vjdeuFdRS5gMbe84nAkUP1iu2MyrMIdEfBHMYY+4cvtjfl0AkcNJ32lqhmZ
	B25z9CEb+tPYYONCxELkBnlet9w2PSDJGyiXoFHC0x6vZz9FC0WsAqydSH60DwDTmD5Y5U
	GgytjAQ7gv+bAkAhEQAVVX3x0/56xTk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="mBt/uHTX";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8I7k49xOlGAEsFgikc29wjt1dOh1b3rtxl0U2LM82Y=;
	b=EHXodR3u3EPmKlis5FGbDZEvaBN6rrn38yH7cZwmQ9L1nKc03E9yBCXXS03C7XuR9Uv2Kc
	YLAd9a4poghRfhWPgRTLQlF7+3z1q+Pj9jGP0Utcab9dFKM6GW2exUuU5ciROwHYCGABgU
	QEKSrQWrIqigPjC1ZNS10/T/C/2kXak=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so233255e9.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:30:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784651420; cv=none;
        d=google.com; s=arc-20260327;
        b=FrpLU0xc+T+pOPQORjqoGkOeGlCrzA7PsAhMZ8iTaEfWp5k1mqrwWrJS/PSapc3MMj
         4SVWxFI3u4gHWUdgydpOiuYNnamXFfBk9jvjf5+KTtFTswjSuxCiiijjDR/SfUm6rBMX
         aC0JbXpe+aGdvKWiQb3EX4I8zbdm3hiujvQS3saGZXpLj2COFFiASl/7R3fNGVevNKhz
         E6NbaOHriwW4tOXVvBXlqQPbI/kcq52BBOSVnny+rQgxL67aNJDQhDHBQGRox7BMZTyQ
         w0b6yKPxrvKNdBBXozwDKJj3Q/5OA4HkpdNvXkKmnDW3L/p5KeZ24iFDxtQuL8U0YFHq
         J/SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K8I7k49xOlGAEsFgikc29wjt1dOh1b3rtxl0U2LM82Y=;
        fh=wb3J1GF/RpHCbI0/5YI68VQeGBiFdyIzFOnd6DCo16Q=;
        b=g8ioGoU4QnCVLuihfJD324n3xHi1Irx8VFyG+PHtrp1GocR5Swy+LL36cIDnVltWwB
         o23lAjiOBAwbhifJCqROEZPkdCscMOSoNhNdI1Ibnu11yrIN0tEDKgYK9Q1naz61zQXr
         dvETmvBXs2tZo/YT0EL93Ya0amwiJKZNmo02BtxbGUqeXo9iMDxfA4GEOd1fFH7QmZNF
         lqIzTMXA3nufF+ABuZaXStb5x2Ik4gbaX1hvS8rdu+KDl83FjYbKFtNrq1zchrIQsMP+
         a92PvGnGky9N6gpF8pXjBy083Di9ZHVlC9E+uYehZOx/mmo38TG4M/VG+bkKaL+bOt4X
         wsXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784651420; x=1785256220; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K8I7k49xOlGAEsFgikc29wjt1dOh1b3rtxl0U2LM82Y=;
        b=mBt/uHTXWHTAxxKkE6KJrDFDEikKCx3vND0HK0a2Z1awhF3YLC2BMIM54ksp+tTis1
         ecApAeId+SfIeNlUfNrv1XNI5M8nqpMzCSLVGAtwKoFz8c62CUj0xUODDAb8yrEDlGs5
         cpFqICrAS6Onzf7E9YCmUBn9MF/2vMGvsW2Spi3bw5Olydn3EDAYeCQ/hTwAAk8HtP67
         rnSLu5ansllFOgrcGGg9kZq0x7/F3X+myeXYGNjsiUsKkejlXUAOl2ai38hOp5Ma5cvC
         SbFqGY6HvaejmD1IO83sSBavtgR4aNH4cjlYK4m9W8FyYTxV1OcUJ09PzTmyuQHczEXC
         gIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784651420; x=1785256220;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K8I7k49xOlGAEsFgikc29wjt1dOh1b3rtxl0U2LM82Y=;
        b=cBpkFRdHbUPFq6+x9mzjFgMwIHuvv5b92vZpPufjtVf/FOYWOTkhtSPBocxmUDhxRn
         uhuz93JnBE3gRuQnR2ugINgi1jE+xc993GBQ2uWzEtTyO0lTUXxKH3gAV4chs4ONodks
         d/O8Hn1d9WRx0gG7ZRCH+dbd+rgfITMHowbTTIufcAUPTu12WgZ4763xf5bsDCmHRJWr
         nigm+d7RhlDM/2PN9NZedCnPB9x3z410AxqFrxwUr7Zda5Ge6xheolm75m2wy9rtL6u/
         0Iw73cHAgPcR2SxBjt+z2vnAWX1UMt8zPbDrp8gLcy419DGMk5fWhQKQM8zUjVHTcY50
         bjGA==
X-Forwarded-Encrypted: i=1; AHgh+RpoIP5cZRjt17MxD0oBzT1juc+UWGFLzrqrjuPVIkvfeG+atv/UecskC+jxnSP6HodeheyAJdC/KQ==@kvack.org
X-Gm-Message-State: AOJu0YyK0O73pJWZFG7y9FtIfc8n8mMzf0gcDdjW1yK6IbZHmQOLV7bp
	lyBhbYfBzpaSv6hhfpYytFYv/ekV85COb3ZPkOWFuvdLV6RifUnFLUlhZbBOkzaWfbhBsyJVgrB
	6JM1DImIOC9TgivKScqO+eZ+7+i8hR5vkFiU/evAN
X-Gm-Gg: AfdE7clHghPNunauTPh5Acs4x5jjDzYcCW4/lg1/mLpscnYiojN/NKQFrjAP8G2VTx8
	vNwy/EsxyQkLfP7fVJuaKLislSsOBbPstAkRK3PJa8ui2w3WDoaycwQOLEgsBGNd9yyv524nFhj
	2Oxin/VF6lK0hF1d4626LcbzXPgtyLVaJNF1ICxxJwCiJHz4aerM0TtGeFTtzs54YBtxqW0bNbt
	/logB6Oz8w2nhcNtAkcuUTglcKww8AdHXx5Cn33WH/fO6YOzimY6AGhwmmbC9WL+GWLi1yryvlv
	XHE/E02DWr+0shChJa/vaQnHe8mGvz/xj1YVv3mWy+RrPuqj
X-Received: by 2002:a05:600c:300b:b0:495:4747:548b with SMTP id
 5b1f17b1804b1-495642ea594mr1347465e9.0.1784651419676; Tue, 21 Jul 2026
 09:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260721051903.691848-1-kaleshsingh@google.com>
In-Reply-To: <20260721051903.691848-1-kaleshsingh@google.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 21 Jul 2026 09:30:07 -0700
X-Gm-Features: AUfX_mwWPFeWGLweXqPq4OiKKz55TnsI3WKSOz-d3Exi3YhhjXQ1vIBnXVtyYOk
Message-ID: <CABdmKX24EKOaUoQZS-yR21v_yd=h1RVUQgq0wj+On-WcfE5dGw@mail.gmail.com>
Subject: Re: [PATCH] mm: proc/task_mmu: Use walk_page_range_vma() for smaps
To: kaleshsingh@google.com
Cc: surenb@google.com, akpm@linux-foundation.org, kernel-team@android.com, 
	android-mm@google.com, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B9751C000E
X-Stat-Signature: 8hxjywhwbziwefwec5itdpy5debdm3xw
X-Rspam-User: 
X-HE-Tag: 1784651421-27700
X-HE-Meta: U2FsdGVkX1/t+lS1QHIKQsQHxlkGntNbYinBo0SMBiMwinEutIqp5L2Q9huAPE2zqLfv9L70YHPAAVxnqg5ulyYUPdShNZfLt0+36mDiZBmitr3flK724JZMWdGdSuFcr+WJ1MpyuHGhUUXO9Y2MtdwGpd+Fu2/pIYO0EqgiOK46MhbCuStxzNeMr+goFLlj+1xEMo4WSA9jTT0B2SYj8tU+a9/JGfrr5SybVcuYeSeGd0KGAhuGFntZQyy6jodMKPgd7RgFgHD5vOADK5/OUE1w3E7IKwhPB6sjP7n3oCGrOlNR0DdVoLrqsl9YP/hVP0irmIUP2+/YQn4+zu8u17ayej2US2vkD73GXGB3K2L0kALBkPLu2H+VI9foqkqmqPurZ4CzY0n5AZ3Glv38zeZQgF1iZhp0UoA8AR1+MKGb3WtmDbjMk5KiYfPaRDgiVpYpjIybPpttW6YdpVOz18ArZqQJe+Vg2nxeCMJQ5hRSWBA2fqn+F1sCiQ0bBdJWm4fqUXQGkGhWuNYMwS921Ivv/wNZSMU0AbRR2o2eDvwgUe2I/isk432YHhtH4Z7beuV5BdIFD9T9vPAwQCfiovVgFZ1lymOjN7r9r00Q9v5bZtoyR7gTJPibyvARlWG/CgGTdOE5G9nNZ1Xd4ceqFvnFW/hk/jkABL+d3qOwVkE/7UUwrEdad8fuBfzf3oLcDIhz0tNMTijXNyTLOAd9yF4pstbFc3nA3ox7p/StPkkYKL2T8xBrJfe6TvfPipm66EcXeplkGenkIcTVhuOyo6DEzyCjd/nSl1HZqr7tareKSDzyzWkhwC4F4xTEaR1iXXgcNUg/WT8THSeXDu93MSFybuNJSbK5+Lacz4d5cYxDStX8thf3ZdnMec8DOCfMoJOatB3s7Bv/S/WVRIlvA6ogPCbJ/mRYCt3ZkbdMoPm9MI6MdZdk2sc7lkdPS12IV688zZcnH6rDPjfbTxd
 tHJWW80I
 ubnWPVxKVYUEbGD/aFHUVTFcs/3zHTviXUsa81oIk4/MM/2AA79kt6aZmRuA07BhWlmznT2vqj1VopVqARKOTmGkOdACoF0PA5Wuf9hWAr2UNayPVYUTRvEGeNfQ2ZJoX5pyY11i7+8LK+utnwMVMGVJxpg5bL4VFMdBepQprRxkXm00PBr8CD2ozBECKfJIrIobJNYc2TH8I9NroY4MAVn9e46PJ2ZsipiZMHvCWqoOHMxKPNYsYpfDpHmigOfGYIh2KZiBm74ZtaiaQ+8cktdW8NNDx+jzZNFMG8TOsKUKFfXfd308jX7EaPwC+S8qwEUGSa31n6oqTo25X8jcq8/O/kraCbMGYtaVXPRS4DxZwvebUEcerE7zup9kZoZQ1v7ZGtT5+1Ncj50SaJanR1OHSgwCqczY4QrokW62/w56uZHGWFk3zMUvbsBt1OnTlJLN3u8gACVYWEp/f2MHR9b5bho6sVguzF4Gn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 10:19=E2=80=AFPM kaleshsingh via kernel-team
<kernel-team@android.com> wrote:
>
> From: Kalesh Singh <kaleshsingh@google.com>
>
> Modify smap_gather_stats() to use walk_page_range_vma() instead of
> walk_page_range() when walking page tables.
>
> walk_page_range() internally calls find_vma(), which asserts that
> mmap_lock is held. This assertion fails when reading /proc/pid/smaps
> under per-VMA locks (where mmap_lock is not held).
>
> walk_page_range_vma() walks a range within a single VMA and does not
> use find_vma(). It relies on the VMA lock instead (when configured
> with PGWALK_VMA_RDLOCK_VERIFY), making it compatible with per-VMA
> locks.
>
> Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} u=
nder per-vma lock")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  fs/proc/task_mmu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index d32408f7cd5e..5d301bdd05fc 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1369,9 +1369,12 @@ static void smap_gather_stats(struct proc_maps_pri=
vate *priv,
>                               struct mem_size_stats *mss, unsigned long s=
tart)
>  {
>         const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> +       unsigned long end =3D vma->vm_end;
> +
> +       start =3D start ?: vma->vm_start;

Doesn't overwriting start here break the !start && (!shmem_swapped ||
... check below when smap_gather_stats is called with start =3D 0 as in
show_smaps_rollup?

>
>         /* Invalid start */
> -       if (start >=3D vma->vm_end)
> +       if (start >=3D end)
>                 return;
>
>         if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> @@ -1401,10 +1404,7 @@ static void smap_gather_stats(struct proc_maps_pri=
vate *priv,
>                 }
>         }
>
> -       if (!start)
> -               walk_page_vma(vma, ops, mss);
> -       else
> -               walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss)=
;
> +       walk_page_range_vma(vma, start, end, ops, mss);
>
>         reacquire_rcu(priv);
>  }
>
> base-commit: b95f03f04d475aa6719d15a636ddf32222d55657
> --
> 2.55.0.229.g6434b31f56-goog
>
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe@android.com.
>

