Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2140D3940B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 10:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098A46B0088; Thu,  2 Apr 2026 06:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049626B0089; Thu,  2 Apr 2026 06:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A076B008A; Thu,  2 Apr 2026 06:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D63C46B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:31:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FB2A8BFC8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:31:34 +0000 (UTC)
X-FDA: 84613249308.20.1FD9994
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 830964000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:31:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2XuScKO;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775125892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2530tcOdVIbOnXLJnHbcRT1W8jVxX9axmcRQRQseDg=;
	b=M3OgNMiQHe38qngKaIAXkKw6S1b5ltlr2p4xJzMM5ExoiA7S3oQjCmcOtXJD9Usm/4D3b+
	JyFjJTy4vsnVhSkPLSLSvfaZvhjj2jB+9mz59iQLdSxyUO5zPv76f8hrBAMQdx72rwD9at
	GbtPO5xwUXK22gUF639Fui6dwZjtp6Q=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2XuScKO;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775125892; a=rsa-sha256;
	cv=pass;
	b=Y7Jqs8DzFlcXbnw+poFgaLNcfNYEvzzbpLc0tRn8FZjQWsdHbxRklG54xOw8QXagVZ+UgH
	WcSB6HjUP6ThfxAskeZekmXJ0Ee/19jN71m4wpn9lzc0wb3sslnUKxvgAyqh7bwPzsPX1V
	r13ALis526LhhBnUVZ71IsbNWkkEIos=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a1443780c4so1978772e87.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 03:31:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775125891; cv=none;
        d=google.com; s=arc-20240605;
        b=dUs63XA6y1/3gaU0EO4g4jWxMOl7EZUC0my+1ROxnQPIWWdTNPmRX/XPvb+dnQXeUF
         MkCiLvMzVi6xKSnXv1KVCVMwoK7/EvgE7wppux++G4L6g6vGewsjkcz/dI4h6iJaMTyM
         XY2pv/6xhkjSf0jIw1vRWIe32SNnkcUa6bki1ld2g62k9jQHSWEe6vWsNQO0JcGCnNVF
         h/f3PvVxSXn84PZsipdT71tJGeS+vzZQH78Mh28VTfnh6yv/vbPGMPjLt1pyJzqbCn3w
         /3bfXBF0WllGhxKb1fqf5ECU2D2wFejjWz9oE6ZC5r0VPz5zIETTgvtaM6adHoQwSfiO
         sLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T2530tcOdVIbOnXLJnHbcRT1W8jVxX9axmcRQRQseDg=;
        fh=jp/N3xgbdknenSk9UMvWLELxURZAC3lR8rPjbt0k0HU=;
        b=c80QoxsjzfxscyTqRfJr+FG+nOCOo+9AQ7ei6xW7VOVMAdHYc5y2NKQ1v00xg4RQKO
         GjrjKercvXBb5YqUrPIvIqML3z35B5DO1SFlMPCqtvOop0o0V1bw4lnvRNKeRhY20V9D
         cbIGfNJa0bH9TBcMTc9fYCsCs2sPHIyDFQk4ndNO5Ha0TFIehMecSWGQ4B2B/0pZ6bR6
         B0suWz+ZfdyU9R0IY4Xp7UF8/jd9VeEYWlwVbH1iryEjtn8VoxcZHeeP3n16ulG3gbjj
         s5aQBR2tJqYp3Pzh4nmSJjMJxnOmwlDVNf9d9n4HmfFdCflKwD7SQXlS4hEI2ENlwXER
         JFQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775125891; x=1775730691; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2530tcOdVIbOnXLJnHbcRT1W8jVxX9axmcRQRQseDg=;
        b=I2XuScKO9nIS6OOZ6eCrqu1zisDlkdiSYgE/C+e2tcXJ5YVmjvavR0GClGYu9DauKT
         bDj0SDyewNirnL+/s3IHN7+oFnfSsPsJ8WxCIHHrE+ZVYkw6lrCfIrd3LGCtCKEfHZ96
         F5H2T+5Qg8c+OgVlAJDcP7gh7cQvtsW6iwHqIERvw9fjZumZ9ZrYv85H2uaHOi/G2AB9
         tIC1UB7mu6AlrXJSWjvjAc/unpEfPlshhrorGJcwSILkssAY2d/3DaRjPalSY8mr3eDn
         oL8K1ZSCZMhCbIUcqHBaPni36r0RbGvlyD2B5iLqHEcEtZNcO8AVW4U3tBeZ8MMPStP/
         jmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775125891; x=1775730691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2530tcOdVIbOnXLJnHbcRT1W8jVxX9axmcRQRQseDg=;
        b=ICc5Kgqwa0A2WE/lI7WjisY6/+2PS1Gli1acF024JAhlc1rBdH2YQat6UunJLp7SCI
         GmGBiisaiPd3oJ6B+vtVQcRBdvj15yRSr2kyzQgG1rYjdNIm6+PAgbCtMKfphA8V+hG5
         RxWYLqEKZ151C9Q7nDCPAiTGN7irCb3VaSzDlsx3UE6jOqU8F+QI4wQFdfVVxVmy/X9Z
         laJvHbE/Ax4pYZb8YxMndOqUyjMA0nuZYCZeXBpcOsWoEZc9PrDWTNQIufwebwb4ePD4
         LYfZOGQdisi2oj7qZvtNJUX5/WRwIuada10qubHHU4ghkZSJ3fQIsIo+gMDvNeiLIKj4
         dr4w==
X-Forwarded-Encrypted: i=1; AJvYcCUWkjBcKtQVnrCT0QMWKcAQKYjpC2WfvYy8/i65imMH4u2ZuUg+3JkSgMTN5FEJzIiOeKOhng5ILA==@kvack.org
X-Gm-Message-State: AOJu0YxZ+xXXyTh6hcddoaUD8f3FGBbZ1RkN2hJy/jntszcWhQdP6Xhn
	wEvKPFaxFzScNsMDpqluKgQSOJFLXns7AQzqO6FHxoJDIyfWtk+eHF2NpAl9US7D9EevVnjFksd
	GQour/QaXTBqZpj3DYei7I0rgAcQIxC8=
X-Gm-Gg: ATEYQzwzd0ERK/a9cXlAFdanmo5LJ3K8QMjix8lo6ZmHD6z6aD8LJnmQAumAPoOgYRs
	boqWnmDgQGEeAPyRq/sM24dN3UjwSvuyrXmsiomNigMWJOKzcUua8GhPVuEirOrPMsTfmkUPod7
	jLwqUi5PDN/mDkdvXGXurXhhK7od+nKHpJO2w+Qz55+HdY4HEKSJSQsn9HSpl0L4gc20wcTn0QT
	dJc13JnIVyqEruRLQq/yVhrBjHtrSgIpX4YHnX5ehQqxArEIgFWB4RDZD2v91I9Yu3MUhZevpuj
	8Qw/yMY=
X-Received: by 2002:a05:6512:10d2:b0:5a2:9fb6:d010 with SMTP id
 2adb3069b0e04-5a2c8d7dc56mr694562e87.10.1775125890296; Thu, 02 Apr 2026
 03:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260402081413.1896640-1-wangqing7171@gmail.com>
In-Reply-To: <20260402081413.1896640-1-wangqing7171@gmail.com>
From: Uladzislau Rezki <urezki@gmail.com>
Date: Thu, 2 Apr 2026 12:31:18 +0200
X-Gm-Features: AQROBzA-PGqhWZ0ZO8KgZ1kkbFT1mx268QVZUEEEA_yMVSYD8H4UyVKz4M06DDg
Message-ID: <CA+KHdyVPn14n6o-KHP5mHbD3C37OUsYEjpDL-9LbBSH2pCOamQ@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit-value warning in decay_va_pool_node()
To: Qing Wang <wangqing7171@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 830964000B
X-Stat-Signature: oedpi65zsnuzm44y31xew7fsddu9p5yc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775125892-224246
X-HE-Meta: U2FsdGVkX190GVguThVq0urE4Lj56BD3psDwYPNyhFr3n1chDDmqNkrfF728jlf5bmuROPq9AtWDzruz/dBBPhm2ju+fU8ZrdUFTwQD0ng7r6FhJXnlP4RSKXRQe3nsRqb4F//ye8q9xJ8F6Y6NKXVupgom4HoTquROjgoB2NY8QIwL0azNuRkFbpXx+cS7xV/X+P3SEyAUigB/nXwyrXlduzU19EayoDuZNdLUt1qq/hJC2bpTq+LL1v7H5/NYDr5IhCWYEDjaZ2h+M64NtH34WcyTgOvz2pN5VIsJgigsb3eV8j4XzvkfyTaw9MB10khxOIMEHHj9aooTxWlesqxMpxMlE9HeKtXf5SJI0X7pLG05BakBMqua/D4SSxnlh6jZnqnU80RVzRue4DL3z0Vx1ZxeuZAWATnflM3FxVcXdNxg68xxBLqLsXZ4xk/jIbKq4tcC1FXTehBOyEZHqxssYBbTF/M+usOEKRqjUgWMiFUShvCAIYbGXvsYH8wciP+PpBNNAsM6EhBlQFvPfyrS3d0XFljI0GI0Ni4/sgRz+nzBurL/RWdfZvHx2FkWaZrPgRxuEqOlAZAEIPp5akHkGxhGjgQkrug23o6vWBn7zHtT1fAa83zuzv6oA8tanQDkxs36MiKpfC6rwRLZRHE5iydDFgAI91w0gKWcri1V7Zh1mgBRXz8dmFRVVIivHCdXCBgm5wPp24KdYx1XZ29kx0ervMiLw81iI0F9+4H33WuvQHBiNKXgl2JsjdS/3Lp6MS/yq7ldnWKg7QIRadviwczZuhdCiPzIgNOAcLbE0lQW68b+w6YVyKC7LXkMJldUJb44O14mEZildhxUW6olmYcJlsLS2wrqDkuJnGJ9+0JsmYwQH2pGNbOzmtYKDf7UlRUWURAE0Yuuj6r77hI6lxCSgHjep6RtWpQT0c8eEUiNnpBy6oa8AAECsRo/toAMTYHO9etUP7EW2rjE
 wwHCH2hd
 g8dzL+qolhjKojLjgFK3cxvSqFA1DmGJ5vTLkZjqucbvSPIhMr4D1MRkHvS93oNW3QemdmB1fA6fDDTIAAgzhIufZ5I4SniyHOrVwC8NeAPU3qnCRezSqdQdH/uYk+YB9s9MtCmXCA+/oXkUj4O3ryRHnqxR8pjVDEQogCAVtTskDyoiTixsaCJRjcQkX1sUwCiJwDa3QucDl9CYxIzEQOBHlN2IHyU8h58ocXR/mPE4rqpG73zriiVOqaU3QUqU7IbsJvhjOLLquLBHKxzAf2F4meU/AKm/QrnaSRU/8aZJEwjJwPM81NUKyStm3enkQNDzA1kDdYhfe03y0hGI1L1hiuR5dO2WhHjl97hQpzkWaGpUsyrHSt74OTNXsYPJiogirkFWZUrqCtO3T2/OmHdJlC1QRd47QeY4ZTqXqUxIlQ1+72Er+ZGz11GIBGeGy7/nV6TaGeccYJR1BmCTISY+i+egeascVlIHqnNUlnmKLpmJk4lhX12CfRI18SYxCdfpsT+fd42vm0X2WHaitvcbuITXvKOv34FPWvhzOKPiHEAqfX52z1BZmmsUEyJfc2MlELomeBWX0ZKlyQyAEcqs394TjYoSk46ORs8YApUX69XoAkxVi/Nm9yCwSTcdKTHuQxISCGQ1q/+HLdDkGWXT5AYNooFYDCu/PlcpnrgpDfPotBniOg+LIvWiqXsbCV93FFTWhl2uQrpXWI1jb1JfBpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Qing Wang!

Let me check it close!

On Thu, Apr 2, 2026 at 10:14=E2=80=AFAM Qing Wang <wangqing7171@gmail.com> =
wrote:
>
> KMSAN reported an uninit-value warning when accessing vmap_area->list
> in decay_va_pool_node():
>
>   BUG: KMSAN: uninit-value in __list_del_entry_valid include/linux/list.h=
:-1 [inline]
>   BUG: KMSAN: uninit-value in __list_del_entry include/linux/list.h:223 [=
inline]
>   BUG: KMSAN: uninit-value in list_del_init include/linux/list.h:295 [inl=
ine]
>   BUG: KMSAN: uninit-value in decay_va_pool_node+0xf78/0x1dd0 mm/vmalloc.=
c:2255
>
>   Uninit was created at:
>    kmem_cache_alloc_node_noprof+0x3cd/0x12d0 mm/slub.c:4918
>    alloc_vmap_area+0x327/0x2e30 mm/vmalloc.c:2065
>
> The root cause is that if node_alloc() fail and the va is allocated via
> kmem_cache_alloc_node() by alloc_vmap_area(), va->list will be uninitiali=
zed.
>
> Fix this by explicitly initializing va->list after allocation.
>
> Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D37b7f6cd519f7fb8d32a
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---
>  mm/vmalloc.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..8aebbb51e178 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2071,6 +2071,7 @@ static struct vmap_area *alloc_vmap_area(unsigned l=
ong size,
>                  * to avoid false negatives.
>                  */
>                 kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
> +               INIT_LIST_HEAD(&va->list);
>         }
>
>  retry:
> --
> 2.34.1
>


--=20
Uladzislau Rezki

