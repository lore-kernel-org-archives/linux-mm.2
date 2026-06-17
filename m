Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35CDCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4FC6B0005; Wed, 17 Jun 2026 11:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CC26B0088; Wed, 17 Jun 2026 11:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7945C6B008C; Wed, 17 Jun 2026 11:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4202B6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:56:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A59AB1404AB
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:56:03 +0000 (UTC)
X-FDA: 84889855806.19.1C85BD8
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id A723B140007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:56:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b5EmHbc3;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781711761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERwGw8p2/Jms/iJMYT/dn1PYwf2dRmoIQRea7lQP5Io=;
	b=Q2b2aqwZBq8udBxs83S1A/4+0XJkfTBjSEerSGIr32KWW0fXTioas4XJ5ecCrAjGBJGQ3O
	ynf3tiLDTcx1p3OtK+6sUyNYM7/3idK9YjB04LWSxz7SvdmFNEegMiZC/cWDoubxlTd0RH
	NcYpVPuO9bnMAGbHlLkPwOEsC/6joSI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b5EmHbc3;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781711761;
	b=uPrer2q3YghzSlzFFxGH8oSkQeCdB4fOBd9NxeiNEfv4pk4+xFgFa5YPikeEbGQDRdsSfn
	z8m7P32zHm8Ob7EiBzKxu/2MUlRJPf2Mvrk1JYfRIHjQrUMgq+BOg86TVS1+VAcoII5zjW
	SxLVzY/V1yMdx9xrMMhXmY4/3c8IkMc=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51765531803so340051cf.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:56:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781711761; cv=none;
        d=google.com; s=arc-20240605;
        b=fwlEkOKwpeWe9M/nHdFzUmlEOCWQUim4a1eTC+nLgQPAhb0oahFBZRY2AUb2/jg7Ko
         pOnLFK+nsL7Cwa64LT6WW+o/R+IWF/FWLfeyoJo/ZmD4aI81HZ4irOY7m6dhhBAnA4bx
         S+5WuAfRqoASxobxIsnDdGH9fMZweltn2Ed19ofojC/Q7idt1gr3laSu2wV+cgMxzxKa
         e07/K7F1BQA+SAmYt+2WXMAZexcOlUdbEvnf8TELar+WLHBN/c3pFFXI0qlEtHDQ2MqM
         a9ivolfS9yEEm5ulOgW+T5PyZlhKcYZ6kC2WcsdZJ1OQ8cRxdzhQrjgNHBwPgkzn9esg
         W0/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ERwGw8p2/Jms/iJMYT/dn1PYwf2dRmoIQRea7lQP5Io=;
        fh=LK1kizZCKq5kd6GbxHEURJbNzQVMGOpYycXDzzmUX6Q=;
        b=P9AmaczJ9cOo7TSIRg3MGS/gXJBo6arPVdSVvUbLT7ppBfKVe6B+kWYTggOOo0Aqa/
         GcDQ2jhCpeNfx49DDnI8alWtKuPyMpIYZPf1eEPnMiokew1asP9CbrhmQDlrHVzhHb2s
         nYtuYrJMXzwKj0sAzQhjKa7VcTT/0F7acuLPqutDYURykfHqXkAevKRQPjzorHMxFDjO
         cswizmfl0QXNldq4IW1kAJtEMjgwjDzCgK8F3XUbMAmoIMYSkOdwsIBI2hj05dXkuKM0
         6qYBBaZUR2gFheuWq0NO0neE803JT7RKuRXyCd+R6hzT2DtXNrVFyMqu0COLumoVW2eY
         Uz/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781711761; x=1782316561; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ERwGw8p2/Jms/iJMYT/dn1PYwf2dRmoIQRea7lQP5Io=;
        b=b5EmHbc3Li3RCOBGGfgf2f0tdOpEz+v3chqyQrDR4+MipFTU4cKV8o0NwSInGFbgyy
         YffNUXgrjNFyED/DyMICR1xhcY/VB4s0FCb5vUjDUCBvBR7dYN8N9xVR4agX9rS6j5Fh
         exRJrZ9DIVplFd4HL764oya1Ug2+tUXvEnNDcqJavTKyv0JPPJuDGn63AGBXGrufxNR3
         mPuC1yOBrlx5yHVBOy5bnxYH2gTFWKcvPXZZx6XEVOqal0Cj16SDuaIbZoNdhFKH1TsA
         abEpCZhh1hympNHAA2Ao97/48JpW8MTVNRjAXYjYRGvc/GiTby5FSYONJePC1tS5RPnl
         51QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781711761; x=1782316561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ERwGw8p2/Jms/iJMYT/dn1PYwf2dRmoIQRea7lQP5Io=;
        b=knxFyjM3KvlmX9kBfpuZT6t2M6HVQeTYtMqz5ViC906FrHNu7ZzqWBqJYB/DM4v7KX
         43qTGVGmWV9S5RmeHPDs2zin9BfLUkSBb/G/L1ZYyyH5yLifsEH+S4PuTxjt1bpiasxV
         4YsLdo0r6hlxV8ao+5GeZo0qGQX+TlSu8DBf1Cu7R8U38ErM2sjzfDQNRXNDYexA6uQN
         q1EHwXyEshzU4hWK9s4cru6WX++oBZY4rB2xhzFqTPe3rFiPA241Kqo32W3nqsb2rG35
         PGOHTqfJF81GGu+EymkJ54r2+H9O4f6Uh75/ZVHhisZ+WgVdXu0mMLofDC5EmvNZf8t2
         Fxsg==
X-Forwarded-Encrypted: i=1; AFNElJ9N7KtjdLqOnNPEd/QR2erYCajd+FzghZG9ZHaXcsRprFBeKiTkdN9+37SlJ28Je8GtotiUzPavcg==@kvack.org
X-Gm-Message-State: AOJu0Ywcg3vY83Uz2Ov+qJfjvaLCNd2F0YMnHCxQUbt1D8ph6khQFVm8
	F2SaZNV2FYLzO0L88ihfJBe5c2l+BMNBScU4xe8r5+gSd/PyT6y5YZg3Vx5TI0/deSG2ckJipE3
	D2T7m4YHRo7W+qvdZP1dodnaZZbCSOOR26/NLiwbl
X-Gm-Gg: Acq92OF7G942IB4oXJh866tzKXZMnnXef0c6fhbzwx7EP4r2SPLuPyhkoMebI4v+Jrm
	ktky4JKS3AF2RqDCZ1lb46rF3QenI1BcrWc4qV6smULRHx4Fg3PeZNqhdN2MvGHREfoTjMWWnuQ
	t/HzY2qT/Rs/kX1hcMHBEdrYn+lo/DjPeotoqcUYnkBcfwM/8+uTaSp9WSgaij00D8oPJPMy83Y
	bvI1CM2zRIlSlko07KuNTdyDrLT29DTiG63x/X1kni95qIpSRIkltmbL3qjIp5gPoSq0vo5aMI7
	IHHglD1KKAXZHdPoDj5r6hFtNwA=
X-Received: by 2002:a05:622a:4a06:b0:50e:595d:164 with SMTP id
 d75a77b69052e-519aa968720mr11073771cf.8.1781711760128; Wed, 17 Jun 2026
 08:56:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com> <2f9c58f6fd8a81325ec03e19327e03b0b7dca2aa.1781564384.git.abhishekbapat@google.com>
In-Reply-To: <2f9c58f6fd8a81325ec03e19327e03b0b7dca2aa.1781564384.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 08:55:48 -0700
X-Gm-Features: AVVi8Ccnnkvljr8vqsuHECttm3M8Or1Z6AydADGkWkp28nE9QeppOD0jXeg8YMQ
Message-ID: <CAJuCfpERhK341cxCqoLXEkkUBhP7fQ56U14gDms9rwbkWK1mTw@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: jww8sm4bq6f581zzu81jxeydi65ybe7d
X-Rspamd-Queue-Id: A723B140007
X-HE-Tag: 1781711761-629643
X-HE-Meta: U2FsdGVkX1+bqDSWgzwJ65VOIEsLY5JoKOC/HDUbqJdWODSUgMOamG4+ft25XolwuOkWW09sL2fpVYD/qydV0jXQ11tjWobrMgLmoWlEmXK5lYruk7bTpkacykBkTwFC7T30rAfohSpxKngzk2quF0i96FZnCSv+7cnmnb6Iguch2BI1HAt+Xcoqdg+jGlUQJLFaIPQI7lT68tRXviwhXCVFIdZXUQUF4Pd5RDtwc99U5R5U1F38DpGnx06Ky4/Jki2IyMSjFv49Hoh8Ydcpafdyp7sWw0ETLMjHVs4OP7W/qwoOtbQkExUT9dYpkwHRbR4srf4Iv5tME+Gxjax3gouUeSFkv5E2c76YPP+XqdueeuAqYlKMo/YHac4rUihu97AehUIFkGMaRstNMD+4bFt5G1Mxan1grw1qnnyHI/kpDC8BTjjkz73U+Ig1D7oYLdtm0C2LtoO4O79680TOXMWe96lIgF+OsVcpV3DdRuoNoVJTicrr1iSBY23yf97yHG4p6cr9frreFLwl9X28jMKmb9Y6XOyZd6JZvQopLm8HExNXlO9mmbNrchhJKfHvSiT/ZYNl4rG40ZtFsGqG3E83qeiDutzQo3yG57g/SKL8PDtt+0QqOI+PygC1U4EJMP+fehps542Mnxx8YUhbFfOJdoD4UEROzFD++7jwozprP/UPMnjHVGaAP4xaU3eX+394c82E3wdCFE917yCpP9q0nBgN/ncjzKBAvxvPQcXWpP+7oW+N30Di3/n/IOmnIawg8kKvdaWzcguYnOgOy/k+r8pnUKIWvmb4WBGl6UCAczuiVm8HRoG64Rh7taUq58WRKVJPt3m8VVBU9CnQf/C3ulnR12/V2OAnN8TwzxlhVkkHGg67pq2XNwQYS8XNtG25zS8glusQkY0V1hb71500MBCjspbZkK2L2NxKu48f/IOiOe5rkl66ykJ9/06BxegJFVB0bv90TUbQOHt
 1JBrPsFE
 nxw/d6fb37wAcCZNJskRdGQb58AXIl9Px9fvpavmt3Qrp/UDCaJov8XGHfpAHwso7QMPDP6jjIZgTYMSvUYO7YlEXY0pVT9HMzNw2j61mJur0hkOzbxjbfvZ3vJFxz59P7GLu9dt6KKIC5nhpaoDdfD2b/8edoWWyxgmkGuYaftEQSuT7sv9vz2ouCvQCC2p9D8qsTkofJMSSmSzEzvue3Cr79+nSrZN6P83CJUSSJX3CGGjtlQVY5Pec+pTEucfHQI33i1WNY+tVyiE9AiwsjnYldIXb5PKksxn7aUxdFqPNsHQ1bS/Ih83cwNVg6AVobLDIZAMeFc/5IJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> Extend the capability of the IOCTL mechanism to filter allocations based
> on tag's module name, function name, file name and line number.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> Acked-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/uapi/linux/alloc_tag.h | 26 ++++++++++++-
>  lib/alloc_tag.c                | 68 ++++++++++++++++++++++++++++++++--
>  2 files changed, 89 insertions(+), 5 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index 0928e1a48d49..3b11877955b9 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -40,8 +40,32 @@ struct allocinfo_tag_data {
>         struct allocinfo_counter counter;
>  };
>
> +enum {
> +       ALLOCINFO_FILTER_MODNAME,
> +       ALLOCINFO_FILTER_FUNCTION,
> +       ALLOCINFO_FILTER_FILENAME,
> +       ALLOCINFO_FILTER_LINENO,
> +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> +};
> +
> +#define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_FILTER_MO=
DNAME)
> +#define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO_FILTER_FU=
NCTION)
> +#define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO_FILTER_FI=
LENAME)
> +#define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO_FILTER_LI=
NENO)
> +
> +#define ALLOCINFO_FILTER_MASKS \
> +       ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> +
> +struct allocinfo_filter {
> +       __u64 mask; /* bitmask of the filter fields used */
> +       struct allocinfo_tag fields;
> +};
> +
>  struct allocinfo_get_at {
> -       __u64 pos;      /* input */
> +       /* inputs */
> +       __u64 pos;
> +       struct allocinfo_filter filter;
> +       /* output */
>         struct allocinfo_tag_data data;
>  };
>
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 82e3b5f32dff..5feb61d9fb92 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -49,6 +49,7 @@ struct allocinfo_private {
>         struct codetag_iterator iter;
>         struct codetag_iterator reported_iter;
>         bool print_header;
> +       struct allocinfo_filter filter;
>         /* ioctl uses a separate iterator not to interfere with reads */
>         struct codetag_iterator ioctl_iter;
>         bool positioned; /* seq_open_private() sets to 0 */
> @@ -188,6 +189,12 @@ static void allocinfo_copy_str(char *dest, const cha=
r *src)
>         strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
>  }
>
> +/* Compare two strings and only consider the trimmed suffix if s1 is too=
 long */
> +static int allocinfo_cmp_str(const char *str, const char *template)
> +{
> +       return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
> +}
> +
>  /*
>   * Populates the UAPI allocinfo_tag_data structure with active runtime
>   * profiling counters extracted from the given kernel codetag.
> @@ -227,6 +234,40 @@ static int allocinfo_ioctl_get_content_id(struct seq=
_file *m, void __user *arg)
>         return 0;
>  }
>
> +/*
> + * Verifies whether a given codetag satisfies the active filtering crite=
ria by
> + * matching its characteristics against the specified filter.
> + */
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *=
filter)
> +{
> +       if (!filter || !filter->mask)
> +               return true;
> +
> +       if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
> +               /* user wants to filter by modname but ct->modname is NUL=
L */
> +               if (!ct->modname) {
> +                       /* validate if user was attempting to filter for =
built-in allocations */
> +                       if (filter->fields.modname[0] !=3D '\0')
> +                               return false;
> +               } else if (allocinfo_cmp_str(ct->modname, filter->fields.=
modname))
> +                       return false;
> +       }
> +
> +       if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
> +           ct->function && allocinfo_cmp_str(ct->function, filter->field=
s.function))
> +               return false;
> +
> +       if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
> +           ct->filename && allocinfo_cmp_str(ct->filename, filter->field=
s.filename))
> +               return false;
> +
> +       if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
> +           ct->lineno !=3D filter->fields.lineno)
> +               return false;
> +
> +       return true;
> +}
> +
>  /*
>   * Seeks the ioctl iterator to the specified 0-indexed tag position, rea=
ds its
>   * profiling data and returns it to userspace.
> @@ -235,29 +276,46 @@ static int allocinfo_ioctl_get_at(struct seq_file *=
m, void __user *arg)
>  {
>         struct allocinfo_private *priv;
>         struct codetag *ct;
> -       __u64 pos;
>         struct allocinfo_get_at params =3D {0};
> +       __u64 skip_count;
>
>         if (copy_from_user(&params, arg, sizeof(params)))
>                 return -EFAULT;
>
> +       if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> +               return -EINVAL;
> +
>         priv =3D m->private;
> -       pos =3D params.pos;
>
>         mutex_lock(&priv->ioctl_lock);
>         codetag_lock_module_list(alloc_tag_cttype);
>
> -       if (pos >=3D codetag_get_count(alloc_tag_cttype)) {
> +       if (params.pos >=3D codetag_get_count(alloc_tag_cttype)) {
>                 codetag_unlock_module_list(alloc_tag_cttype);
>                 mutex_unlock(&priv->ioctl_lock);
>                 return -ENOENT;
>         }
>
> +       skip_count =3D params.pos;
> +
> +       if (params.filter.mask)
> +               priv->filter =3D params.filter;
> +       else
> +               priv->filter.mask =3D 0;
> +
>         /* Find the codetag */
>         priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
>         ct =3D codetag_next_ct(&priv->ioctl_iter);
> -       while (ct && pos--)
> +
> +       while (ct) {
> +               if (matches_filter(ct, &priv->filter)) {
> +                       if (skip_count =3D=3D 0)
> +                               break;
> +                       skip_count--;
> +               }
>                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> +       }
> +
>         if (ct) {
>                 allocinfo_to_params(ct, &params.data);
>                 priv->positioned =3D true;
> @@ -298,6 +356,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *=
m, void __user *arg)
>         }
>
>         ct =3D codetag_next_ct(&priv->ioctl_iter);
> +       while (ct && !matches_filter(ct, &priv->filter))
> +               ct =3D codetag_next_ct(&priv->ioctl_iter);
>         if (ct)
>                 allocinfo_to_params(ct, &params);
>
> --
> 2.54.0.1136.gdb2ca164c4-goog
>

