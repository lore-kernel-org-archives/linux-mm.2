Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68390C61DD9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 14:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884946B008C; Sat, 29 Aug 2026 10:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8351F6B0092; Sat, 29 Aug 2026 10:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724B06B0095; Sat, 29 Aug 2026 10:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4579C6B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:37:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1BDB1A0152
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:37:26 +0000 (UTC)
X-FDA: 85154560092.29.629017F
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD49480002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:37:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E08a8U5C;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788014244;
	b=XPcDzSJpJSXzeAjw02Zrtef87QuJXu90h9GNh7FcVmai+LH1m4No/ovynS5YYA1F1m8xPN
	U6C/bOMPy+zCO2TTELl0AMGpVjMrChz2NapbWrVV4NLsL4ietzDpzVAYL40yEwJBqF57iV
	M2AKHvD7uQEGjABdHz0lqMQbtFKPYME=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E08a8U5C;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788014244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZ9OdMIWwS+HeVefiMGtXz8F2WL73A/c0lBq2ihg7xE=;
	b=QEue3qrw7PZO0CHDFpaa2TQ6oJSHwi7th9TTXyp1YIz4r9Wlru2Q5h7jj3s8nkKhnRsKNI
	qThK1gYbOute8gJCn+faW9pIC8wGbMknGByhWKHiDooc3wprR+Q668zTP2GWgJU9tlC6WF
	p4GdKrm/saTj9+hY4IkrdXLXSaEMmkY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495437bb891so12459585e9.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:37:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788014243; cv=none;
        d=google.com; s=arc-20260327;
        b=lODE34s5nX7TUjNwyZ7Y9olcI6UNUUY3gIx+Z2VCu6Fh1xm8SLgyE0VmcEhABJK+fV
         z31RlSG/1zGxKC/bzBoqRBKB51Kw9apzsCT/BcTRpqthOi4eXrxbuZOYKdZQMPbIKott
         tJw+/xP+ZMTt4pwU78Hom5eDMVdL8rV9H8G0LdLFk5VL8HXmR5OWL6F4zz3CdUV0Nkh4
         rEDGIThWAmcq9gNIsIDqke9JJc93jrIX9J1C6kbr1V6omo4p+RTHwB5Cc5bH3b/a3h7j
         aa1/wkQIWsNRT/Mr25rD2lFtenCC4KOEqQWtey44ffYc/62G+ipaM912T5UHdoiHpa2+
         kc2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MZ9OdMIWwS+HeVefiMGtXz8F2WL73A/c0lBq2ihg7xE=;
        fh=S29gcK4Bw0VNNfgsg7mpksWyFABFmmb3N/U82c+FoAA=;
        b=cLnRsIuQW1WLk3czoaaWpaE85Q7c4x7l28x2RhmbLY3bsy+r6GkmxqrRD+SBy4oQ4h
         BJKRuT3QgZmP5omZUC7XpOJMmJmJk/6SBQ5BxZtbWI+5HichchwsEXEw6BhBg8ClnPvk
         QISm3AI7SprWsxO9V721ZZdJiSu7ImOoOfji9YmFT2RcRVkwaA89X38WM4XURE19Jx0P
         EmNHcs0py9mRHpesPv+1Bk7Gh4il/sHbIt2cr/sMymg68EAXJ4p7dR2F+yc4b141AeaJ
         0MEUnAeoP7AqyoXBbHImlJpZg4r2oqYuFIEm6T9Pj9/OBCMKkrM/a0Wusp0+wk/7ELKo
         sokA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788014243; x=1788619043; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MZ9OdMIWwS+HeVefiMGtXz8F2WL73A/c0lBq2ihg7xE=;
        b=E08a8U5C+YUS0tGMIOTa3QUnm0zKe5VBGXtqg5EZaOtopGjY2ZELm7K1kcIN4H5VNY
         qS2MdcHqxN0k21YEeiaRemi0JFgAbQjJ9OtlRgBQszDWhl211FKv9cboQ0zosFU3SU2P
         a/BCm8t06GlO4vxVBP+OXC8azolrSPyi/RYZnxrBLpyu7mPn3H0lt4RQvFbioiF0l9Bj
         w0s+Ehp2N6Nr+9L4gcB+7mY0SEhdduQx4Ydbh2C6/C7yjftJ2XqZfkFSfryLAdGR6VVZ
         OE/gDgXntvVqFQwe9uAEJUyA6vgXonUXbjHZ8ZiSmqNtjg7B9uFk3dlqNgPyuhL0wqWH
         TjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788014243; x=1788619043;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MZ9OdMIWwS+HeVefiMGtXz8F2WL73A/c0lBq2ihg7xE=;
        b=DxxmzvDC5B3KbJa1RwGy9Z8GwooFIn+B390ZxjEW9odWJwHjROPkQ8v+5Eq12uGFsl
         bRk2CI+nDGUOmY7OLcfKysk3KOHib/Q88ieHq3VZacpooLrFO/LST1ZoPO10MeeonITg
         ctBYfnBlrZiX8SIhWb8aq4E6gcJ7vjGm5YbLmo4yk4Ko93aEUZWrED6zX+wqyZBIi7Ns
         mW9LsDI9v7YdV+31sanlwHdMrJpGClRS+ULyRUWyDUWi9g+tqUgxjntvYkOrH6Xyrqa0
         T8+MLBZMMH9SA6JvMQePzuTLS0iKzGfOlNhGoqXVxyG4urj60olFi2m1NqsaGSz2lGlO
         WJew==
X-Forwarded-Encrypted: i=1; AHgh+RrE0oba9L4vLwYus8OfoWJiJaVmneY7jEnUM/9OQQkEuytEKcU0j7oqn6yG3l13+drr/mK7IJkTTg==@kvack.org
X-Gm-Message-State: AFuF++kwSC+y7jKCaUbYKcOQDdxSxH+NVS5EZlsla4403st4ByLOvyeF
	XnYcqNifxe+pGZSBFGULF/7UB7Sgqa/iMRcFwZbr+3EFoiSxgShvHwac3lct7s0dtyRk4f2gYxf
	33dEgTKj+vS7QhaNGK4pvPv//iWAKQlmqK8At
X-Gm-Gg: AR+sD11sxs8ucDerUZlJrNp6fAgVYnuBStO32xEWvQZv6SfakMhgoairCtl403UhNkM
	vyjRhmRARrTLbpSAUk1PKjz8iIu9QHENUMVI51HHOXF7woqR0a/fvPzZN96BNOkmsLNyws7Zq+p
	T+McDlh3MOmKD+V4s1qhPjSnqC+blv0c4T6Kt6PHncXAKZVelZBZvZk56HHV2A3D2Y4UZ9CLP8H
	kMzWDNXXT1V3/x6DnKC9lX6D7BdMfl4jQS6nDodg4iATQszu/73xrqbI+gIuccAUilUjCTbclpo
	yVKW0hHjpZ+MspjGNURnjQ2sS2PDGbA2gemNoTbEvA75y2g=
X-Received: by 2002:a05:600c:190e:b0:49c:799a:177b with SMTP id
 5b1f17b1804b1-49cca2b74a0mr76687805e9.2.1788014242555; Sat, 29 Aug 2026
 07:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org>
In-Reply-To: <20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 29 Aug 2026 22:37:11 +0800
X-Gm-Features: AcwNN1VHoiYexiUTsHD52g-4kbK1C6nEM9rzNia-_c2hFJVdgL6ptuoVUWOQi4w
Message-ID: <CAN_Opa9CZUTUyvveTnVXK7Wy9Xq-9wc=QkASceLv5hTE-NiNnw@mail.gmail.com>
Subject: Re: [PATCH] mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ouaqruqtwesjkmzce6haun4q8z7jb9te
X-Rspamd-Queue-Id: CD49480002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788014244-370523
X-HE-Meta: U2FsdGVkX19cBkg+zwjkIgI8bNikNCN4o6QlRYR0FNKwapyaoOo+Lrr8qzr1Z3LKzgRrcIzLc9CakknymtyeMDRX6bFgq7sge6G2odKlYZgDusoFFO6tEjNRftRXmSCcbyASHTZEEx8VdyneGRkcm7zlZHYM0MwL1F2QLK9ATajAN8b1FMkYOw7+peZNRgx2x97eylpAVIldkX+vbqZL5im5a2zzJ9q/3xuo/o0HTmYYjvuRtBVnvWysJfBL+IFgWgy63VBlcXdWFhiKxyz8R2HrrSgGt87ntP6hYNoCgHzZgHz1rnaDWzid+LjVyddumHHzmug5KiDL6kRt+ppw8YX2KSVGi+bX4tpjMphFyV4YPotTMt5zax49CMapPrUuzXlhXkRuwQVfI1biozwvgKB8/sGjZRVRfeQz3ALJoFtZGS7pkDkhK1v7Q6NxpX0KbQttA2Vc2BV9lBgIwsQUjwpQpiTjmqmAK80obEt6Lq7jwbJuz5HrRVUJ2B8ycVNhSWsF96z64P4dgC+NmGzzqpPB38h4gHaV6OyfBlKKNpvHDWRQrhYlUFudm/B19MJ/DYlhB2H5d9R0lBlCubtknBgPo/DbpdkrAMJQA8n14h4XZE62XH9+L+NxNXaq+vi1kMHd6S/qLaLOkB8vEXwggXD0kQhVm0cybdKXR7ay3npYIcGCAeQ8nVOWp0cE0QLNF4r9qjPavgQo7TxJLTcFYbgOqMG9R7pYkHLCdCB5WNhViEGhx6RO7Hq7U/ZTznf5PUTXeCdVuvQRYRtf3Kr9EGGuPdHcSke2GYafjc9v8oT9wmmhuO3XeDXa0ixy5l/QNZatCK6KRvNU/tI+fovgFgM1knJfDGHRZV/5APQLIbKnc6DLmBOrL7ApCS0GffRK6jQ0XZN+PfJWf4mTYH+TVMqTcX6aAddYLWNqaz3BBnDWcLcRB1aXjm46cVyQsunue/pTuWRNR/LY76XSVQq
 J9Abux4L
 gIVBgOiRS4KK8ejUbloUQHbiQZO8m6uWxuvv2NbdF3wG9G/7atykrGqJPLeWPaXUeMYKIECTHC8l6rgg48aBf+CkuFT4d5Bj4TKhXRh+5JkF97IANa+NlxzOIGwoDe36HM1KzZK/43SLJ05uyK3bIcX3D0vWKi9Q0jSyJ0MariG90gB1yytjr0SBZ3E90VNmoLLLz+Zk1ZroAtAO37oNfLFzOPPJfeqqL93kBRCsfVGIt5k3YfEq60lV4gaM3oF+tHuNpick1yGUICkr7ij5o+cQMQ9u7cbNLXbz+HC69NvWYa5RTDwDo32RcrPJRKrVkhpHbgWbGhhz1c+KSu27GvQvV7DhTtuXoKoXAfbItqd4rxF8yIWM0K8Lwlfof4vvCLDou6CNbU+Q+JUKRnodzFLBXftt7XPFKmDHXa2oACW9JHM7qBlsBxWddRQorLPKs/3TdyaR08wQOc0+g7JsJtfXm8Z1ty5JreffrPLZf54VASTEIDOOOotYjBzCRE0w1Ms+WgEojElmZ953mMuen5syTi5wQ4QZl++Y82ma6l0Zhjy3f/q8FbLSNI6RCrHlJ1RVI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for the fix. I agree this is a very clean solution.

On Fri, Aug 28, 2026 at 7:20=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> When a VMA is mremap()'d with MREMAP_DONTUNMAP set, that results in the V=
MA
> being copied, but the source VMA not being unmapped.
>
> If the VMA is mlock()'d this is a legal operation, though the source VMA
> has its VMA_LOCKED_BIT cleared.
>
> However this is done in dontunmap_complete(), after mm->locked_vm was
> incremented via vrm_stat_account(), resulting in double-counting.
>
> Worse, this is not even corrected when source VMA is unmapped, due to
> the VMA_LOCKED_BIT flag having been cleared.
>
> This all works fine in the usual mremap() case (without MREMAP_DONTUNMAP)=
,
> as the source VMA is unmapped with VMA_LOCKED_BIT intact, at which time
> mm->locked_vm is decremented accordingly.
>
> Resolve the issue by invoking vrm_stat_account() only after
> dontunmap_complete() has run.
>
> Note that MREMAP_DONTUNMAP requires old_len =3D=3D new_len, so no need to
> account for a delta in size in this case.
>
> The bug was introduced by commit b714ccb02a76 ("mm/mremap: complete
> refactor of move_vma()") which incorrectly reordered the accounting and t=
he
> clearing of the VMA_LOCKED_BIT flag.
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgof=
f-v1-1-39a40b2c98b3@kernel.org
> Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> Closes: https://lore.kernel.org/all/20260828094823.594279-1-kunwu.chan@li=
nux.dev/
> Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/mremap.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 2b4b523a86b8..7c368440fafe 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1355,12 +1355,11 @@ static void dontunmap_complete(struct vma_remap_s=
truct *vrm,
>                 if (vma_is_anonymous(vma) && !vma->vm_file)
>                         vma_set_pgoff(vma, pgoff_unfaulted);
>         }
> -
> -       /* Because we won't unmap we don't need to touch locked_vm. */
>  }
>
>  static unsigned long move_vma(struct vma_remap_struct *vrm)
>  {
> +       const bool is_dontunmap =3D vrm->flags & MREMAP_DONTUNMAP;
>         struct mm_struct *mm =3D current->mm;
>         struct vm_area_struct *new_vma;
>         unsigned long hiwater_vm;
> @@ -1401,10 +1400,10 @@ static unsigned long move_vma(struct vma_remap_st=
ruct *vrm)
>          */
>         hiwater_vm =3D mm->hiwater_vm;
>
> -       vrm_stat_account(vrm, vrm->new_len);
> -       if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
> +       if (unlikely(is_dontunmap && !err))
>                 dontunmap_complete(vrm, new_vma);
> -       else
> +       vrm_stat_account(vrm, vrm->new_len);
> +       if (!is_dontunmap || err)
>                 unmap_source_vma(vrm);
>
>         mm->hiwater_vm =3D hiwater_vm;
>
> ---
> base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
> change-id: 20260828-mremap-fix-locked-vm-b8991ffc4181
>
> Best regards,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

I tested the patch with the following tests [1]:
1: test-vmlck.c =E2=80=94 Andrew Morton's test for basic locked_vm accounti=
ng
with mlock()/MREMAP_DONTUNMAP.
2: test_mlock_onfault_nofault.c =E2=80=94 MLOCK_ONFAULT with no pages fault=
ed in.
3: test_mlock_onfault_fault.c =E2=80=94 MLOCK_ONFAULT with pages faulted in=
.

All three tests passed with the patch applied.
Tested-by:  Kunwu Chan <kunwu.chan@gmail.com>

The fix also looks correct to me.
Reviewed-by:  Kunwu Chan <kunwu.chan@gmail.com>

[1] https://github.com/KunWuChan/vmlck_test

Thanks again!

Best,
Kunwu

