Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F973CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 20:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506C36B0088; Wed, 17 Jun 2026 16:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8966B008A; Wed, 17 Jun 2026 16:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F846B008C; Wed, 17 Jun 2026 16:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05A166B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:52:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90C6D405E1
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:52:28 +0000 (UTC)
X-FDA: 84890602776.10.28B6420
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 70FEF4000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:52:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C1+2umhN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781729546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFPYglbe5qYHgRXrF6cxAEUo2zlYC9VGhGaVSLw8NmE=;
	b=XtbO4VPMyUPb0VU2AQHn49r1cnaHSkiNlDYheg6d7eydTU/frAShTZn3PeW1vLmgFoLc+t
	985zbZFQOKu1YMtSQvEscnzGeVv3UmlzVOrbA+gugRPPiNFDYJKGtw7huYtrV9R6MQQDh3
	Xls8zXeeIRizlMQ7KWV1TkaPV4UviRM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C1+2umhN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781729546;
	b=EVRDGLTYJ+eD4g/C9yONovr5PHI283payQ41UHCr3wANvDIq8K+4tgGFXr+WzoN74F3OpX
	+qQm4RxL+oCyKeT2geFAlvmbLMzv+4U5uIeaPnW+YLQ1xTqHinqT3tThHnlLJL07k6vr4o
	8SHJYvua1X307QwGcotd/UzF4gQI5Rg=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c6a4eccab1so5775ad.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:52:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781729545; cv=none;
        d=google.com; s=arc-20260327;
        b=PUnJhcWGb/FgLyeqaPUKKwZNP6IiQuGd2RP+BV4tMgwnh6wjuEq6zHSMy4O3BgUUEN
         c7QiLoNiBtLQjgnGnMW4qrNe+bOniqoDUWC20r7wnJaiZ2COfZopdxPg1sjxCaRc9U0Z
         FP2eBef5StK//naoXLhjpBYDIvoV7azXbj6PShy0d+R0lBTEw7bwLS5Fu81S3dhQdHkr
         2i55dAfa7XjGCDVefn2KyNEHqoGqPrAKwTg3DjCmmQ821LqihA3POSk38fyeXvWIfXgX
         6IMSixX8b+8LP345/uCxPIJjElqqU/dEsf807GVSRpHrY6vUpYoPxDMPe4y2DtHNWS9Q
         3vMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hFPYglbe5qYHgRXrF6cxAEUo2zlYC9VGhGaVSLw8NmE=;
        fh=DDbKeLe6JxXsUgvPCjQ9DkCzxayYhd38cW0uJ/3ufmA=;
        b=figCvGObvySZ1rnYVXdHt8RRIS/IwC3HfC7CoTAjLEvgUDBWdelZTKef/rQL6G663T
         hRJdh00L7kI8VfdCLtM5pUU6YVSjToEMyrTqCcgdGtW4+TLFJvXtIJDR1xQsAcCii2id
         hDZeeZ65sMKl3RqQFpEikA2dJS5rvW1xuIh1KKHYprHDp23lj900U/Hz9asEwfkqi260
         KXrVUxHiP3x3TdQqSJhFp2O5YsqgO9COI0eRP0NCLttGukc126SqwAUr9e8pdkxgs8OO
         AHrIfWE9doqqlot85lfwMH9mf0Zk57PoNysKRHTn2Y45MnHhVuRdh9CFP4DAeFqh4Nmz
         vONw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781729545; x=1782334345; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hFPYglbe5qYHgRXrF6cxAEUo2zlYC9VGhGaVSLw8NmE=;
        b=C1+2umhNn2NtdMK+OttY7d4aVfVzVSao5RkXOU0KlraWJVIMMtx8TO6n4W4AqoiSvn
         d58/hmE6hgOmm26g50jZtgVjn0c8GUoek0KYpc310izhf9Z2qw/V+ImEXanMN5YIcDjj
         MVCfe+MOQfJQ0a9AGl3e1Jxl/RgViAOLtmozu5XCG7NG79xWqYEBOh59ECIKzplqbTKG
         0pVqRThaBs0t5H5m59AC+CD8Jy3+XEBoi5jqo9iCwC1WtckkW13hkra2QH6N3FMtY1Br
         5+9mAjrHxX1rFhItcud2+744Q0gRp722KrnBA8AsP5dNVCmjUOcTQqyOn2tbuqcxElt/
         ANdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781729545; x=1782334345;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hFPYglbe5qYHgRXrF6cxAEUo2zlYC9VGhGaVSLw8NmE=;
        b=opVEAwnOGJP80baYQ3nX+PS8GW3PY51GJCMnWaVkeJ/CVfAtYkF8d7y+GdV17ngA5V
         +rcS9+S2u2fxlzrcAWt46EfMc97r6Wh23r19INCumR3L3aqnwlnmicqbYj6Zpf525nhi
         4crZthnFbUAJ5lu7mk14KTp9kPdE8gmBrlre1vR7lpVLC1jeGfbiFLwxni5+1XYYkTI2
         wBBTn26aPTT4BWHyxNH8jl0WDf29Syq51jXtnkBa46XsfBm47AJWmkMGTqPn0SzxWzKL
         CHT9KAys8cA4lMwki+5tQ93wXZENWio/QMamERtpPAg7K/IAnRS0VuLYXAt75zFD1vMt
         UUFw==
X-Forwarded-Encrypted: i=1; AFNElJ+YU3Xucu1gVt2EZyYG2JSFUurv6mbouDp8TojomgEIeNdivhmmu/GH0RPkDyubzHodrmlC5yiYyA==@kvack.org
X-Gm-Message-State: AOJu0YxIr5SEAUMk/4cBeeSCvhXQDWgMurBzbk5nDpcTO3XxsWtL3Ns6
	yA5esEeHB9Sg9U/8TMjoKTySI0wWjv8XewY4ZfARro8IYvyRlTp9+j3w4DdlJC3wFToew1dk0V6
	AEPjw2wZCpkBDAlSe2PqOOEhhQv1YXjo4/Ki2gyEj
X-Gm-Gg: AfdE7ckPSoOPIhBmOBnlBVLXRrgF5jRpwyjCeEtHJdkQwVW7PO2cDGg9EpGDVNeyr/B
	s10+HA2Ax5Own1K7aBo+xncQVY12JMb6cWftC0e6zNyYY+mjEmTeFWwK/CZ4fWHxW+tnpnNui70
	oLg3LjCyRNcsVAIKufIO1rLn7OskvmiVCtBSB7tVKy1KBVJOHBGxHi+tobJugre08SXIaErJfuo
	QotSuxV5+kGAiZs10N73FyfU5iv74NrxJH6rvjgElAKz8u0FA20BCB5ST8+83TbOwWPLX1NB9p1
	gnX7MyIORu5bh2mepwS23LAiNXI=
X-Received: by 2002:a17:902:da88:b0:2bf:193b:a195 with SMTP id
 d9443c01a7336-2c6e868ff0emr135275ad.11.1781729544657; Wed, 17 Jun 2026
 13:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
 <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com> <CAL41Mv7+t9_Ohz2313AM_CgCoFGkt6xd0VnCw+zQZd4pKrr8Ww@mail.gmail.com>
In-Reply-To: <CAL41Mv7+t9_Ohz2313AM_CgCoFGkt6xd0VnCw+zQZd4pKrr8Ww@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Wed, 17 Jun 2026 13:52:12 -0700
X-Gm-Features: AVVi8Cei1hvkIQoiw94PklUJfisrI5GHrBhQNDvkAddqFhLjD2UP9Oo229Uk7OA
Message-ID: <CAL41Mv7as17=_Z=sPRaC6HhwzSt+9-Mshg72Hga9Qfbh3fO=og@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: multipart/alternative; boundary="00000000000099f5580654793c1c"
X-Rspamd-Queue-Id: 70FEF4000D
X-Rspam-User: 
X-Stat-Signature: 75kwc9jk1m6a5mfzq83ymcbnqq5bdesi
X-Rspamd-Server: rspam09
X-HE-Tag: 1781729546-184652
X-HE-Meta: U2FsdGVkX1+75Nem5aFvvwtVJaRNYwVAKCgYCBZZ1QfRq4770Mgbe5wx366IAbUhyLx4arQR1YD+yAcAPlgsFXXuYT9i7DN69QP4VKjDt9jPy1cO8bOpHTR7Mzcp4lAJxKwTXllxQr8woKcO2dfh8aTha6LmFE7N/unLYu/WUzU+TO3FA8m7uI4QpCu+swm0PNGkNivg3BzDVbcMWog2rhEGuw8ZHpZa23do5y1rdhuW49aTyXaKqOGbAff0D9xBYIiE+hmKFloMtqnEuCx4fkX3Ya4v+TvwxNaOntAcMGdMpKxBPNzo/+3Ez9wE0UeNJkCUvHm2GHwnKbJbbA7xD6Q6GVhlLdiwKnIo0XmgxaHyLeubZWuHN4fHekksHNTWG7HSnaV7PIkoL4DiPVI2t6C11cM9aatekHVJO8U3NCMObHTWakKyzqgnyqJN5v9h+15NhaVGAA6GiYqexcupXJJS9aHn5mZC75WuUodbLFZ7WEk359U6BpLHDryBoC9iNgNZjWMJeEocoyitbGsCBYQGJds1vV8pFGxLP6WBS1ZstIhfqj74HtoISoikYJnWbLle8aIWUNkMdN3URyDiPSf5IVSGfjvZ8WQ6bpDcW2eId83+ynXXpXLH2jnTlA3GoO4MGB4SOSgps/R5+CFt7NguFmRkDmUlv69ylVwvgSZXnvDKIcfjScIsVATo+o2vWWsP4HQpwPfMuznfpRGwnvzZilvaxWEd5EmXmhemy3nvXkQtReqiuHpLDs6rkO9fDszWHLfTf1NmGPkCkDsSM18HRW4B33tBK7nO2m5ObkzTG6fgHBbtFNsWOWHlGTX9WHQH1oL4vngQpVPuPVVk4JpMC+x6gIIxJVxUkZLGkwuluu3s4avcoDhfx5yjNUulVgBsI7HXSFNSrnosKO5FkhcXPeiHqz+jT4fa0z/BkGDYmWUs+/5ehUk2/pElRdDoHpRfAXn+YE9mqv7fbDv
 dzHE11aW
 tm054JoClp3AHrNDq0tkGcd3/WcXA5FTeg7+bioMc3CaxTrfZHs1t5h4F4QbwtvUFgJfK5fwMjjC/OpdK5tAdO911DILVTIXZEfi86aYFQR2e9y30RC4ymgxoPn+RAYvcQpeZ7sUmBkNCij+Yv0uTzsZ19ZHnQxeGDfef8L612IP/Trkp6oBqc8DiUfP6V1Ufb1aT07Qyf53FVSUAWXDw1geYhuozNtZ2NY0bZky1l/Q9a7uM1OmjAH0NlyDOAOUL8rNsopM8wYPPp42rCfuCPPbTrf8I0fvBCXCQPDEvwk40iW2R2H9pV7XcTwtD3r96CXdPov1IMOmR9MnLaYFBjuIOj4fIW/T+QuKOmRoIjTCKGsOeKnGHTn5NzJYN5ysJVZTurJ35BzUkQhSfBs28uswDfMHulGAJ38vA43QhWqlPxtoZbTvMotKuyWg6/2lYmhWGCNdONZwTvsb6Fqar1XOL3WpYt4H7OrgBisffAyBqtpia+7qdnCqqstm03SvHfnXsDJauk26LpXJYFWEP2phZpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000099f5580654793c1c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 1:43=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com>
wrote:

>
>
> On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@google=
.com>
> wrote:
>
>> On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@go=
ogle.com>
>> wrote:
>> >
>> > Extend the allocinfo filtering mechanism to allow users to filter tags
>> > based on the total number of bytes allocated [min_size, max_size]. The
>> > size range is inclusive.
>> >
>> > Filtering by size involves retrieving allocinfo per-CPU counters, whic=
h
>> > is an expensive operation. Hence, the performance of size-based
>> > filtering will be worse than other filters.
>> >
>> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>> > Acked-by: Hao Ge <hao.ge@linux.dev>
>> > ---
>> >  include/uapi/linux/alloc_tag.h |  8 ++++-
>> >  lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++-----=
-
>> >  2 files changed, 59 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/include/uapi/linux/alloc_tag.h
>> b/include/uapi/linux/alloc_tag.h
>> > index 3b11877955b9..7f5acbb44c14 100644
>> > --- a/include/uapi/linux/alloc_tag.h
>> > +++ b/include/uapi/linux/alloc_tag.h
>> > @@ -45,13 +45,17 @@ enum {
>> >         ALLOCINFO_FILTER_FUNCTION,
>> >         ALLOCINFO_FILTER_FILENAME,
>> >         ALLOCINFO_FILTER_LINENO,
>> > -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
>> > +       ALLOCINFO_FILTER_MIN_SIZE,
>> > +       ALLOCINFO_FILTER_MAX_SIZE,
>> > +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
>> >  };
>> >
>> >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 <<
>> ALLOCINFO_FILTER_MODNAME)
>> >  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 <<
>> ALLOCINFO_FILTER_FUNCTION)
>> >  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 <<
>> ALLOCINFO_FILTER_FILENAME)
>> >  #define ALLOCINFO_FILTER_MASK_LINENO           (1 <<
>> ALLOCINFO_FILTER_LINENO)
>> > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 <<
>> ALLOCINFO_FILTER_MIN_SIZE)
>> > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 <<
>> ALLOCINFO_FILTER_MAX_SIZE)
>> >
>> >  #define ALLOCINFO_FILTER_MASKS \
>> >         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
>> > @@ -59,6 +63,8 @@ enum {
>> >  struct allocinfo_filter {
>> >         __u64 mask; /* bitmask of the filter fields used */
>> >         struct allocinfo_tag fields;
>> > +       __u64 min_size;
>> > +       __u64 max_size;
>> >  };
>> >
>> >  struct allocinfo_get_at {
>> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> > index 5feb61d9fb92..b3d21834b61e 100644
>> > --- a/lib/alloc_tag.c
>> > +++ b/lib/alloc_tag.c
>> > @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str,
>> const char *template)
>> >         return strncmp(allocinfo_str(str), template,
>> ALLOCINFO_STR_SIZE);
>> >  }
>> >
>> > +/* Fetch the per-CPU counters */
>> > +static inline struct alloc_tag_counters
>> allocinfo_prefetch_counters(struct codetag *ct)
>> > +{
>> > +       return alloc_tag_read(ct_to_alloc_tag(ct));
>> > +}
>> > +
>> >  /*
>> >   * Populates the UAPI allocinfo_tag_data structure with active runtim=
e
>> >   * profiling counters extracted from the given kernel codetag.
>> >   */
>> >  static void allocinfo_to_params(struct codetag *ct,
>> > -                               struct allocinfo_tag_data *data)
>> > +                               struct allocinfo_tag_data *data,
>> > +                               struct alloc_tag_counters *counters)
>> >  {
>> > -       struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
>> > -       struct alloc_tag_counters counter =3D alloc_tag_read(tag);
>> > +       struct alloc_tag_counters local_counters;
>> > +
>> > +       if (!counters) {
>> > +               local_counters =3D allocinfo_prefetch_counters(ct);
>> > +               counters =3D &local_counters;
>> > +       }
>> >
>> >         if (ct->modname)
>> >                 allocinfo_copy_str(data->tag.modname, ct->modname);
>> > @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codetag *ct=
,
>> >         allocinfo_copy_str(data->tag.function, ct->function);
>> >         allocinfo_copy_str(data->tag.filename, ct->filename);
>> >         data->tag.lineno =3D ct->lineno;
>> > -       data->counter.bytes =3D counter.bytes;
>> > -       data->counter.calls =3D counter.calls;
>> > -       data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
>> > +       data->counter.bytes =3D counters->bytes;
>> > +       data->counter.calls =3D counters->calls;
>> > +       data->counter.accurate =3D
>> !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
>> >  }
>> >
>> >  /*
>> > @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struct
>> seq_file *m, void __user *arg)
>> >   * Verifies whether a given codetag satisfies the active filtering
>> criteria by
>> >   * matching its characteristics against the specified filter.
>> >   */
>> > -static bool matches_filter(struct codetag *ct, struct allocinfo_filte=
r
>> *filter)
>> > +static bool matches_filter(struct codetag *ct, struct allocinfo_filte=
r
>> *filter,
>> > +                          struct alloc_tag_counters *counters,
>> > +                          bool *fetched_counters)
>> >  {
>> >         if (!filter || !filter->mask)
>> >                 return true;
>> > @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct,
>> struct allocinfo_filter *filter)
>> >             ct->lineno !=3D filter->fields.lineno)
>> >                 return false;
>> >
>> > +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
>> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
>> > +               if (!*fetched_counters) {
>> > +                       *counters =3D allocinfo_prefetch_counters(ct);
>> > +                       *fetched_counters =3D true;
>> > +               }
>> > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
>> > +                   counters->bytes < filter->min_size)
>> > +                       return false;
>> > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
>> > +                   counters->bytes > filter->max_size)
>> > +                       return false;
>> > +       }
>> > +
>> >         return true;
>> >  }
>> >
>> > @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_file
>> *m, void __user *arg)
>> >         struct codetag *ct;
>> >         struct allocinfo_get_at params =3D {0};
>> >         __u64 skip_count;
>> > +       struct alloc_tag_counters counters;
>> > +       bool fetched_counters;
>> >
>> >         if (copy_from_user(&params, arg, sizeof(params)))
>> >                 return -EFAULT;
>> > @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_file
>> *m, void __user *arg)
>> >         if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
>> >                 return -EINVAL;
>> >
>> > +       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
>> > +           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
>> > +           params.filter.min_size > params.filter.max_size)
>> > +               return -EINVAL;
>> > +
>> >         priv =3D m->private;
>> >
>> >         mutex_lock(&priv->ioctl_lock);
>> > @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_file
>> *m, void __user *arg)
>> >         ct =3D codetag_next_ct(&priv->ioctl_iter);
>> >
>> >         while (ct) {
>> > -               if (matches_filter(ct, &priv->filter)) {
>> > +               fetched_counters =3D false;
>> > +               if (matches_filter(ct, &priv->filter, &counters,
>> &fetched_counters)) {
>>
>> Do we really need this "fetched_counters" parameter? Here are the
>> possible cases:
>> 1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |
>> ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.
>> 2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |
>> ALLOCINFO_FILTER_MASK_MAX_SIZE and
>> 2.1. matches_filter() returns true then we know counters were fetched
>> because they had to be validated.
>> 2.2. matches_filter() returns false then we don't care if the counters
>> were fetched. We do not report that tag anyway.
>>
>> So, instead of passing fetched_counters to matches_filter() we could do
>> this:
>>
>> bool filter_by_size =3D (params.filter.mask &
>> (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) !=3D
>> 0;
>> while (ct) {
>>            if (matches_filter(ct, &priv->filter, &counters)) {
>> ...
>> }
>> if (ct) {
>>            allocinfo_to_params(ct, &params.data, filter_by_size ?
>> &counters : NULL);
>> ...
>> }
>>
>> Wouldn't that work?
>>
>> Ack, yeah this logic works and obviates the need for fetched_counters.
> I'll include this in the next version.
>
>
Actually, thinking a bit more on this, while we can deduce whether counters
were fetched outside the matches_filter function, I think the current
implementation is more intuitive from a readability perspective. I believe
it  should be kept as is for that reason. If we extract the logic, we'll
first have to replicate the boolean logic at two places. Second, we'd need
to add a comment explaining the boolean calculation, and the reader might
have a higher cognitive load trying to determine which function populates
the counters. The current implementation makes it easy for the reader to
deduce the original intention. Let me know what you think.

>                         if (skip_count =3D=3D 0)
>> >                                 break;
>> >                         skip_count--;
>> > @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_file
>> *m, void __user *arg)
>> >         }
>> >
>> >         if (ct) {
>> > -               allocinfo_to_params(ct, &params.data);
>> > +               allocinfo_to_params(ct, &params.data, fetched_counters
>> ? &counters : NULL);
>> >                 priv->positioned =3D true;
>> >         }
>> >
>> > @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_fil=
e
>> *m, void __user *arg)
>> >         struct codetag *ct;
>> >         struct allocinfo_tag_data params;
>> >         int ret =3D 0;
>> > +       struct alloc_tag_counters counters;
>> > +       bool fetched_counters;
>> >
>> >         memset(&params, 0, sizeof(params));
>> >         priv =3D m->private;
>> > @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct
>> seq_file *m, void __user *arg)
>> >         }
>> >
>> >         ct =3D codetag_next_ct(&priv->ioctl_iter);
>> > -       while (ct && !matches_filter(ct, &priv->filter))
>> > +       while (ct) {
>> > +               fetched_counters =3D false;
>> > +               if (matches_filter(ct, &priv->filter, &counters,
>> &fetched_counters))
>> > +                       break;
>> >                 ct =3D codetag_next_ct(&priv->ioctl_iter);
>> > +       }
>> > +
>> >         if (ct)
>> > -               allocinfo_to_params(ct, &params);
>> > +               allocinfo_to_params(ct, &params, fetched_counters ?
>> &counters : NULL);
>> >
>> >         if (!ct) {
>> >                 priv->positioned =3D false;
>> > --
>> > 2.54.0.1136.gdb2ca164c4-goog
>> >
>>
>

--00000000000099f5580654793c1c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Jun 17,=
 2026 at 1:43=E2=80=AFPM Abhishek Bapat &lt;<a href=3D"mailto:abhishekbapat=
@google.com">abhishekbapat@google.com</a>&gt; wrote:<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div dir=3D"ltr"><br>=
</div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">=
On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan &lt;<a href=3D"m=
ailto:surenb@google.com" target=3D"_blank">surenb@google.com</a>&gt; wrote:=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Mon, Jun 15,=
 2026 at 4:04=E2=80=AFPM Abhishek Bapat &lt;<a href=3D"mailto:abhishekbapat=
@google.com" target=3D"_blank">abhishekbapat@google.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Extend the allocinfo filtering mechanism to allow users to filter tags=
<br>
&gt; based on the total number of bytes allocated [min_size, max_size]. The=
<br>
&gt; size range is inclusive.<br>
&gt;<br>
&gt; Filtering by size involves retrieving allocinfo per-CPU counters, whic=
h<br>
&gt; is an expensive operation. Hence, the performance of size-based<br>
&gt; filtering will be worse than other filters.<br>
&gt;<br>
&gt; Signed-off-by: Abhishek Bapat &lt;<a href=3D"mailto:abhishekbapat@goog=
le.com" target=3D"_blank">abhishekbapat@google.com</a>&gt;<br>
&gt; Acked-by: Hao Ge &lt;<a href=3D"mailto:hao.ge@linux.dev" target=3D"_bl=
ank">hao.ge@linux.dev</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 include/uapi/linux/alloc_tag.h |=C2=A0 8 ++++-<br>
&gt;=C2=A0 lib/alloc_tag.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 | 63 ++++++++++++++++++++++++++++------<br>
&gt;=C2=A0 2 files changed, 59 insertions(+), 12 deletions(-)<br>
&gt;<br>
&gt; diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc=
_tag.h<br>
&gt; index 3b11877955b9..7f5acbb44c14 100644<br>
&gt; --- a/include/uapi/linux/alloc_tag.h<br>
&gt; +++ b/include/uapi/linux/alloc_tag.h<br>
&gt; @@ -45,13 +45,17 @@ enum {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_FUNCTION,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_FILENAME,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_LINENO,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILT=
ER_LINENO<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_MIN_SIZE,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0ALLOCINFO_FILTER_MAX_SIZE,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILT=
ER_MAX_SIZE<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_MODNAME=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (1 &lt;&lt; ALLOCINFO_FILTER_MODNAME)<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_FUNCTION=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0(1 &lt;&lt; ALLOCINFO_FILTER_FUNCTION)<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_FILENAME=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0(1 &lt;&lt; ALLOCINFO_FILTER_FILENAME)<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASK_LINENO=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0(1 &lt;&lt; ALLOCINFO_FILTER_LINENO)<br>
&gt; +#define ALLOCINFO_FILTER_MASK_MIN_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(1 &lt;&lt; ALLOCINFO_FILTER_MIN_SIZE)<br>
&gt; +#define ALLOCINFO_FILTER_MASK_MAX_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(1 &lt;&lt; ALLOCINFO_FILTER_MAX_SIZE)<br>
&gt;<br>
&gt;=C2=A0 #define ALLOCINFO_FILTER_MASKS \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0((1 &lt;&lt; (__ALLOCINFO_FILTER_LAST=
 + 1)) - 1)<br>
&gt; @@ -59,6 +63,8 @@ enum {<br>
&gt;=C2=A0 struct allocinfo_filter {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 mask; /* bitmask of the filter =
fields used */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag fields;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 min_size;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 max_size;<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt;=C2=A0 struct allocinfo_get_at {<br>
&gt; diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c<br>
&gt; index 5feb61d9fb92..b3d21834b61e 100644<br>
&gt; --- a/lib/alloc_tag.c<br>
&gt; +++ b/lib/alloc_tag.c<br>
&gt; @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str, co=
nst char *template)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return strncmp(allocinfo_str(str), te=
mplate, ALLOCINFO_STR_SIZE);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; +/* Fetch the per-CPU counters */<br>
&gt; +static inline struct alloc_tag_counters allocinfo_prefetch_counters(s=
truct codetag *ct)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return alloc_tag_read(ct_to_alloc_tag(ct))=
;<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 /*<br>
&gt;=C2=A0 =C2=A0* Populates the UAPI allocinfo_tag_data structure with act=
ive runtime<br>
&gt;=C2=A0 =C2=A0* profiling counters extracted from the given kernel codet=
ag.<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 static void allocinfo_to_params(struct codetag *ct,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag_data *data)<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag_data *data,<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters *counte=
rs)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag *tag =3D ct_to_alloc_tag(=
ct);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters counter =3D allo=
c_tag_read(tag);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters local_counters;<=
br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!counters) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0local_counters=
 =3D allocinfo_prefetch_counters(ct);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0counters =3D &=
amp;local_counters;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ct-&gt;modname)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo=
_copy_str(data-&gt;tag.modname, ct-&gt;modname);<br>
&gt; @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codetag *ct=
,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_copy_str(data-&gt;tag.funct=
ion, ct-&gt;function);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_copy_str(data-&gt;tag.filen=
ame, ct-&gt;filename);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;tag.lineno =3D ct-&gt;lineno=
;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.bytes =3D counter.bytes;<=
br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.calls =3D counter.calls;<=
br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.accurate =3D !alloc_tag_i=
s_inaccurate(tag);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.bytes =3D counters-&gt;by=
tes;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.calls =3D counters-&gt;ca=
lls;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0data-&gt;counter.accurate =3D !alloc_tag_i=
s_inaccurate(ct_to_alloc_tag(ct));<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 /*<br>
&gt; @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struct s=
eq_file *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0* Verifies whether a given codetag satisfies the active fi=
ltering criteria by<br>
&gt;=C2=A0 =C2=A0* matching its characteristics against the specified filte=
r.<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt; -static bool matches_filter(struct codetag *ct, struct allocinfo_filte=
r *filter)<br>
&gt; +static bool matches_filter(struct codetag *ct, struct allocinfo_filte=
r *filter,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 struct alloc_tag_counters *counters,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 bool *fetched_counters)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!filter || !filter-&gt;mask)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return tr=
ue;<br>
&gt; @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct, st=
ruct allocinfo_filter *filter)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct-&gt;lineno !=3D filt=
er-&gt;fields.lineno)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return fa=
lse;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (filter-&gt;mask &amp; (ALLOCINFO_FILTE=
R_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!*fetched_=
counters) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*counters =3D allocinfo_prefetch_counters(ct);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*fetched_counters =3D true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((filter-&g=
t;mask &amp; ALLOCINFO_FILTER_MASK_MIN_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
counters-&gt;bytes &lt; filter-&gt;min_size)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((filter-&g=
t;mask &amp; ALLOCINFO_FILTER_MASK_MAX_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
counters-&gt;bytes &gt; filter-&gt;max_size)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct codetag *ct;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_get_at params =3D {0=
};<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 skip_count;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters counters;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0bool fetched_counters;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (copy_from_user(&amp;params, arg, =
sizeof(params)))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
FAULT;<br>
&gt; @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_file=
 *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (params.filter.mask &amp; ~ALLOCIN=
FO_FILTER_MASKS)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
INVAL;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((params.filter.mask &amp; ALLOCINFO_FI=
LTER_MASK_MIN_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(params.filter.mask &amp; AL=
LOCINFO_FILTER_MASK_MAX_SIZE) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0params.filter.min_size &gt; =
params.filter.max_size)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL=
;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv =3D m-&gt;private;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;priv-&gt;ioctl_lock);=
<br>
&gt; @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct =3D codetag_next_ct(&amp;priv-&gt;=
ioctl_iter);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while (ct) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_fi=
lter(ct, &amp;priv-&gt;filter)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fetched_counte=
rs =3D false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_fi=
lter(ct, &amp;priv-&gt;filter, &amp;counters, &amp;fetched_counters)) {<br>
<br>
Do we really need this &quot;fetched_counters&quot; parameter? Here are the=
<br>
possible cases:<br>
1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |<br>
ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.<br>
2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |<br>
ALLOCINFO_FILTER_MASK_MAX_SIZE and<br>
2.1. matches_filter() returns true then we know counters were fetched<br>
because they had to be validated.<br>
2.2. matches_filter() returns false then we don&#39;t care if the counters<=
br>
were fetched. We do not report that tag anyway.<br>
<br>
So, instead of passing fetched_counters to matches_filter() we could do thi=
s:<br>
<br>
bool filter_by_size =3D (params.filter.mask &amp;<br>
(ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) !=3D<br>
0;<br>
while (ct) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_filter(ct, &amp;priv-&=
gt;filter, &amp;counters)) {<br>
...<br>
}<br>
if (ct) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_params(ct, &amp;param=
s.data, filter_by_size ?<br>
&amp;counters : NULL);<br>
...<br>
}<br>
<br>
Wouldn&#39;t that work?<br>
<br></blockquote><div>Ack, yeah this logic works and obviates the need for =
fetched_counters. I&#39;ll include this in the next version.</div><div>=C2=
=A0</div></div></div></blockquote><div>Actually, thinking a bit more on thi=
s, while we can deduce whether counters were fetched outside the matches_fi=
lter function, I think the current implementation is more intuitive from a =
readability perspective. I believe it=C2=A0 should be kept as is for that r=
eason. If we extract the logic, we&#39;ll first have to replicate the boole=
an logic at two places. Second, we&#39;d need to add a comment explaining t=
he boolean calculation, and the reader might have a higher cognitive load t=
rying to determine which function populates the counters. The current imple=
mentation makes it easy for the reader to deduce the original intention. Le=
t me know what you think.=C2=A0</div><div><br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex"><div dir=3D"ltr"><div class=3D"gmail_quote"><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
:1px solid rgb(204,204,204);padding-left:1ex">
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (skip_count =3D=3D 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0skip_count--;<br>
&gt; @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ct) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params.data);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params.data, fetched_counters ? &amp;counters : NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;=
positioned =3D true;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_fil=
e *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct codetag *ct;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct allocinfo_tag_data params;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct alloc_tag_counters counters;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0bool fetched_counters;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&amp;params, 0, sizeof(params)=
);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv =3D m-&gt;private;<br>
&gt; @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct seq_f=
ile *m, void __user *arg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct =3D codetag_next_ct(&amp;priv-&gt;=
ioctl_iter);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0while (ct &amp;&amp; !matches_filter(ct, &=
amp;priv-&gt;filter))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0while (ct) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fetched_counte=
rs =3D false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (matches_fi=
lter(ct, &amp;priv-&gt;filter, &amp;counters, &amp;fetched_counters))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ct =3D co=
detag_next_ct(&amp;priv-&gt;ioctl_iter);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ct)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0allocinfo_to_p=
arams(ct, &amp;params, fetched_counters ? &amp;counters : NULL);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ct) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;=
positioned =3D false;<br>
&gt; --<br>
&gt; 2.54.0.1136.gdb2ca164c4-goog<br>
&gt;<br>
</blockquote></div></div>
</blockquote></div></div>

--00000000000099f5580654793c1c--

