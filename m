Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DD2C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24976B008C; Wed, 14 Oct 2026 12:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD2E6B0092; Wed, 14 Oct 2026 12:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874D16B0095; Wed, 14 Oct 2026 12:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 443A06B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:54:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C760414068F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:54:06 +0000 (UTC)
X-FDA: 85321829292.07.7A0836B
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id D38B540008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:54:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZeAczDS1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=linmag7@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791996844;
	b=HJ3yeiC1lofHub0WS9fQDzWIgaoxRYUji/DNiaBvRcLkJeArZpUZugsBIQgjtpOB8N4Jhk
	cU37JsapdT7X62llnCgbS7b9rlbw2tzQap+afJx88jepd1Re2nTKfa/nx3sPJly2qoSMOU
	GWVC/vcugj9vEfB0UoGXdKCjeWB2nuM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZeAczDS1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=linmag7@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791996844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+F9IeTlxRgN2/qbGE0mzkiygL5YNuqfvZdlqx/Or3SM=;
	b=PYkWynyRP8zI5Xq0sSFY8JrtRlozPcbQjn7lfTEyaHMOzL+banSQ8e0J6hfCBZkryT7QIQ
	/rRQEuX/4CLOZCIG/R9g+ihenPJdu2HSJmhpXtIzyXsbHrOds+kcQCefuhnDVJIpsf8hmW
	Nok2cCAHo6uVdtgs5+et8La1/SL0f2U=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso4659150a12.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:54:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791996843; cv=none;
        d=google.com; s=arc-20260327;
        b=nKezLvgRXUvig2FVga36wLHpzjzJP6OO5RqipUripqqL5MA2/PbH4z6CefhjIKW3Xa
         kRkTh/wiWVJ0yoInmi104KsX+vswMArmkTslfo7Y994kFc7M4WcOJHjxruQ8ClRO0W6D
         bQsv2BmjANS/Zx0Oa3L/1hkGcRsfro7ofUbKyBl7u2MO4dRvwyKWiF3F5cEs0QP6z9B0
         CXZyJIwny2QHxC3oH//qHHGYbQ3c8fjrMXpb96MAaTG+TIgSqldqqFNv/Mmzg4en+m1M
         6w3JQ81hnAtgiKCPTRWnY2TsufvgQIRrNbckfXaivbRU3LFlS6bRw7Bz8gpw4NbFntFm
         DRdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+F9IeTlxRgN2/qbGE0mzkiygL5YNuqfvZdlqx/Or3SM=;
        fh=PoHTBDtVyel3cVnc7N31cYh7edTMFEwJ0991uIazM8o=;
        b=WofLWtSD9M4VWy4AhOPgSjBGms9hyh9DWEDvfaRu2ciOaQAm4sVC+eXaeLY8JOhZ2W
         tfB5QaN5a7V6UfQ1miKYsP521s7dcIUacnYQC7XFZUtxifm4BaSpHXnE9iHqxaz+iAdG
         icglw86cU3Z+yHrjDeOe92C3vO1j5Bd4wnU2k+P1kc/iZAv+ScRbxT/uR7qwe1N+F4aY
         yx5rGAWW8zqfI7K3RXSPvXLIz9fy1Rc4y8FYyPSYT490mkkStZO6ZvSHqIqEmDexYEc6
         l2URqbShI+/SVBRquvjp5bTEmrFVbcTCG1OX8/KtSWvYw0JDlTef09WRDS7bReVDcgK1
         bO4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791996843; x=1792601643; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+F9IeTlxRgN2/qbGE0mzkiygL5YNuqfvZdlqx/Or3SM=;
        b=ZeAczDS1086NZijla74CXtfX9o9AcFdlntJkTXjPK8UQMFJpRlb9PDNttmBOtxINYi
         f8vQNR0nJh31/7WkLc/9nKLBMcF0YlfvZjKdPnXPGHsopflBLFNTUj8h4lRdE9zG9Lgf
         oSJHMzbxh+jgnKs4o/mxjNpWP2rz82NGdpkiTpbV0uKMXL2bAl4YyaD5CnxLGEtu4s+y
         XtBtcf2NWZ9nVJW8d0W2/CsDUpw/oRxLqBw4IAxNwoRF97X4RwyEsnfqcmSqHuQW3/SC
         DxeZWWvgkYVSdhdy2aE0nZ3opn9wAmvVmLO8HclnWYTq42lRcRXdMTSyO1XnEteQu4rf
         A0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791996843; x=1792601643;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+F9IeTlxRgN2/qbGE0mzkiygL5YNuqfvZdlqx/Or3SM=;
        b=q540B4Y1ImtyYB/yn/8vl97FvPViKaB+le85FF1dfLGWaZaSox1KeFDpki3QA0D0i1
         nby/SMW3a/qgIx2+rWbgDkAWOmo2S8uNSh11h2LbtIbYh50oQMMUUoS8ZNZPqIW62arw
         fANCf+jQoXVjDKTary87SUNDJjJ1QwYsKwuA6uv+ot7nawKkzlgEf3CCHFNliiqRtxiZ
         IXOOK7ZTE0P1Gs0CEDIQ265nKbKbLJ2f9+Ac0UuGhKZiCbyp/koYFlCjoqf6kw6O9y2l
         y/ikb752bB0CAm5dFjrkIUcCRueD+OSzewZlVitHdE8kX+THbwF11+In84WsDnrPeR93
         rTkg==
X-Forwarded-Encrypted: i=1; AKwUvBz7xBnndfronC9pyKN7/z1We8qAVAI66GflvtFOVwOb28TsX4WQtDzdiFspFdVXRjbJHqn7hkzJFg==@kvack.org
X-Gm-Message-State: AFq9FYJUW9LfjR7odeBNjd0tDzxW5QIIc6dYRCbBekLxZTFj+TFyNlwr
	UTyAuWQ4e0iiIyVChg4ak09EXGNwVTnaHC9lZJji+wxgkO1OUDhCM/OG0c/dhDrEB5Rr8hYtyBy
	6ZiG40uO1Fx5ymcoomG7cLQk9w9bPdIo=
X-Gm-Gg: AYBFou04Qyk0YkNoeyAIE2nHBP+38N4KT7YbHeFwvKHSygpmoZBZ0YjJfzDsW0CUTHw
	2PyUbtbM5bNmpoFcMFT9ujNQsgVd8mjqIuOKpXaiANsvDr8GfJJsb1BWpoLRAW5qDwhszHNLwZq
	6j1ZCZ/Lv8Ou0+dJ2K9JeI/4q26W8BwGgPPhCt/rCA+Zelf13zHEVBYx11Oixb5hv+qMbZuIppi
	OObwWrqhACsQif+82jceyAzCWVD/Ki3V+//RQjWhEQsG75K/xWzAfk9B7Z4Y3O6UdVBV5G0/j42
	/bL35jCjuMIKl7tAQQUVwvm6ox78TQxywGY9KPkc5+/t6sTGYZFKsHROWFm2at+/0Y2GIZYu9wa
	C+bsrXB74QJ9YbWU5KCulgp9uxR+RfPgjaMY7ePmBjw==
X-Received: by 2002:a05:6402:4486:b0:6aa:f630:f846 with SMTP id
 4fb4d7f45d1cf-6b17c26a90fmr13938672a12.31.1791996843244; Wed, 14 Oct 2026
 09:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20261014133431.8003-1-ludwig.rydberg@gaisler.com>
In-Reply-To: <20261014133431.8003-1-ludwig.rydberg@gaisler.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 14 Oct 2026 18:53:52 +0200
X-Gm-Features: AclHuK9TLvgiu8pYEXVwGaLOF66o-uRXsc9jGTrvXgaMGrNaXMoKMLMJO_l4JHs
Message-ID: <CA+=Fv5Q_xcnwq0jjJ1RMw8DniNG9jwAuhODTGSPcpaw7G9SSng@mail.gmail.com>
Subject: Re: [PATCH] sparc32: Fix pgd lookup in vmalloc fault handling
To: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
Cc: Andreas Larsson <andreas@gaisler.com>, "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 87dskrkeettgoj7mb8zaef7yppqnyafx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D38B540008
X-HE-Tag: 1791996844-635408
X-HE-Meta: U2FsdGVkX18DG0rrINaaQIaWQPL/rbys9/J3SGQNVINNaP2L+8MSxzsb3rqOcC9LjXCUvMV4TmmAVKv98UB3LFf4079+EoHWjW1Q5TOZgQO0P93awFqVjSsKXxDdqYIhRnuK70RBILXDEqlwO7my6E1zqwhEv+twYYT5VLOp+AB8yNDIevxp9u6jokt0p12Z62UTGz3e13e/6cNrlj21nFh1XAIxFJ/Fg7jA98T1V4acD+kzGK/vBvQmsMBVIqHz7fpmviiPzBbKB31dok3iLY3GEdWjsk9Xc/L3JoAaHMlQZkqNnPrqJXbzUfEB2eTOaqYXuswLoYvnFbH83T6EaUE6f9t+ADaWeLe5BIkstH22Ti2uuxS9zYfbN6RLB1z5yMykmU2JAECOZAh/r+A9NJ0b+mRAyu/nsptXISJ3IsGHhKgKTYGd+4tyw/COn5sJIQhG7ApJDLr2RDdpXUWb0cHXPPyg7TZuwTydLxdmKK2jTCQXXERKlF3/VSRP2KqixGcVzb0s05iT2m2TufGipINSkmXGDU8+V4hRjKUTd6mSZaHWTSSzPP+1ptfPO8qaMbw7YszYaTqIBmsPjkeqvDvrD748jKeQ+mqN6A428zHtjb5vgjc216HjTLE8JU6QlPy309KvuEHaxF6pCdYzZIhUsB4qMXzL94o9dN9T+nICwqKKplkkH//PSnkQnzYWSb0Arx+NR5BdKhvC0nJtAsFaRaSJ/tGbK0VTmUHqCdUe49c+2KjTkjv9bJ4iNPWYw7f1cLaBnm15cfSpS1v8y7z9SdA0UXbgZ+xQNDdfHUd9JxyUhzpN9gjwl0KRd2OkbH0bp5nwyJ+oHFWtiXcapVNxAr0uCl4wzGxabyQEn80OYrnQhl0c0iq0W1+rSqxSr9gEgsgND0BvpH1Zr0gyv+n0Sbj24tVlMg/f8JwVoEPGjmqHsoB0Ppe/SjhMYXL0Q/Ftl5q7iI76couGNlS
 6OlXLJVG
 7Zj5fTe2GgQ0cxk7KwT04LXvlMzp5/kr9MgdmY0GR5isMScm0LEipnubka6kNUlTouBkz+fXVlrXI0GRzI9tP4hjrmnCTZ/j+hQA4ZUlPUNee8l9jsWlMSvc47rSEdvnLhoJXbwiOdATSlbkpJBaC1t+H5x03+OhI628pYk1T5OazFoTICvhGEXhMwgiJR62xN7nNNxgRboAeEqEqHYz3ohva6KnhE/JxXWnyGbd9sR7lQCp321C8hlCW790LXiPNt819GWYOjfjeaYrMXOKXaK+1QyXIhDb0PFwE2qwcgA2yR9y4aCJ3Nzo6wKioTkYq76bs2+l+SXPjc/7u3DYPHASb0i8QYdax3A82qZrXYG13kckSoBUKhHgWubevCJH/Dee+YMdHtzjG9fq2qZ9WtCQxlKGpv9byNZv67eHSqJTvCqRew6Xij+1rXHF+XJPG8S6pqbIXOeWgwwxkuofzcujiJ2d18ccivUnv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ludwig,

On Wed, Oct 14, 2026 at 3:40=E2=80=AFPM Ludwig Rydberg
<ludwig.rydberg@gaisler.com> wrote:
>
> Check and synchronize the level-1 entry with the PUD accessors instead
> of the PGD ones. SPARC32 folds the P4D and PUD levels into the PGD and
> pgd_present() always returns 1. The PGD accessors therefore skipped the
> synchronization and the handler dereferenced a PMD pointer derived from
> the missing entry (seen in this kernel panic running v5.10.194):
>
>   Unable to handle kernel paging request at virtual address ff780000
>   PC: <do_sparc_fault+0x20c/0x3c8>
>   Caller[f0007ed4]: srmmu_fault+0x60/0x70
>
>   do_sparc_fault+0x20c/0x3c8:
>     pmd_present at arch/sparc/include/asm/pgtable_32.h:193
>     (inlined by) do_sparc_fault at arch/sparc/mm/fault_32.c:358
>
> Fixes: 7235db268a27 ("sparc32: use pgtable-nopud instead of 4level-fixup"=
)
> Signed-off-by: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
> ---
>  arch/sparc/mm/fault_32.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
> index 86a831ebd8c8..f9befdbb3e72 100644
> --- a/arch/sparc/mm/fault_32.c
> +++ b/arch/sparc/mm/fault_32.c
> @@ -276,21 +276,21 @@ asmlinkage void do_sparc_fault(struct pt_regs *regs=
, int text_fault, int write,
>                 pmd_t *pmd, *pmd_k;
>
>                 pgd =3D tsk->active_mm->pgd + offset;
> +               p4d =3D p4d_offset(pgd, address);
> +               pud =3D pud_offset(p4d, address);
> +
>                 pgd_k =3D init_mm.pgd + offset;
> +               p4d_k =3D p4d_offset(pgd_k, address);
> +               pud_k =3D pud_offset(p4d_k, address);
>
> -               if (!pgd_present(*pgd)) {
> -                       if (!pgd_present(*pgd_k))
> +               if (!pud_present(*pud)) {
> +                       if (!pud_present(*pud_k))
>                                 goto bad_area_nosemaphore;
> -                       pgd_val(*pgd) =3D pgd_val(*pgd_k);
> +                       pud_val(*pud) =3D pud_val(*pud_k);
>                         return;
>                 }
>
> -               p4d =3D p4d_offset(pgd, address);
> -               pud =3D pud_offset(p4d, address);
>                 pmd =3D pmd_offset(pud, address);
> -
> -               p4d_k =3D p4d_offset(pgd_k, address);
> -               pud_k =3D pud_offset(p4d_k, address);
>                 pmd_k =3D pmd_offset(pud_k, address);
>
>                 if (pmd_present(*pmd) || !pmd_present(*pmd_k))
>
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> --
> 2.35.3
>
>

Hi Ludwig,

Tested with one and two CPUs under QEMU: a test-only helper cleared
a vmalloc level-1 entry in the calling process's page table, flushed
the TLBs and accessed the allocation. With your fix, the mapping was
restored correctly and data verification passed. Reverting only
your patch caused a fatal trap in both configurations.

A non-injecting regression test also passed on a dual-CPU HyperSPARC
SPARCstation 20: four processes completed 128 vmalloc/fill/verify/free
cycles in total, with no new kernel errors.

Tested-by: Magnus Lindholm <linmag7@gmail.com>

