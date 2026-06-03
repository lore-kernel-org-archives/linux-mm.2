Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9C8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74AE6B00AF; Wed,  3 Jun 2026 16:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BAD6B00B0; Wed,  3 Jun 2026 16:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B620A6B00B1; Wed,  3 Jun 2026 16:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5E496B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:41:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A10FC1F2A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:41:05 +0000 (UTC)
X-FDA: 84839770890.23.B5CF158
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47C0FA0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:41:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VA3dD4Hs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780519263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgy0q+soH6ra9WOGTCpqCZxx4OBCCpEK1MDQ6EDcR7I=;
	b=aDvoLLUMNSzG0qAUAjJU0mSclfbpNeUO0Ab0vcz6cuZ+2lLg8wxc7conGvxCSi68/Ez6f5
	qHLzr4f5PdBynbRGRBX+mF7Y2nNA0nkjKmyjyt7+Ncly55XvIw7sBWHXaWUuuIITl5Fgex
	WXnVxu8NWI88Q4KfCrOlOvhPWnhKteo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VA3dD4Hs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780519263;
	b=3/VwTx+iPqE3PVEWjgKBe1Ne0ZAaMPwwRjpANs+StdS4SPyCfIEKLrq4Cfk4J1NZ2UxPEH
	HndUpAqCa1gopT7NpalOwh1ABIucTncjsD2/z8gIjrCTMf3DBjtLrOeJbDBOL419GnbJBT
	rKWmNuO035PHaUbGkqdyQC9GPNbgUnE=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5175d339e8bso153211cf.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 13:41:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780519262; cv=none;
        d=google.com; s=arc-20240605;
        b=IHVZy6Qzo+R83NqMjt3FwZsEK97srQD4Ggzk7rjfGOOzz3+bY3GeXxfwa0Q4J38PRP
         CZEa9k3iy2RMUXWWHjfx/uK1wFFivafMP/PqXJQ4Xlqae6xo4d7R8Ix46DoHtZYyo4/E
         uATna26VezgnObNHF8zGjFDHAPDEc//gOKvkRUO4vviOXYnM87KgAxWdiiG32Qp0VY0k
         am7zNZUGqQlf5SkUAjfBRVM3C2GnS8WwKh/I4g6dAOz2VOfrgtixQbLCRvSAKZ3fv3w2
         FoIGsjg00amDpogGB7g0Ckd/nfOAFj2OW9xHVhrKIuhAYV1cL/w3DckX94stAFOlw+YP
         2EDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kgy0q+soH6ra9WOGTCpqCZxx4OBCCpEK1MDQ6EDcR7I=;
        fh=gS9TcGn0lEhJUp1pjs8gErlcaNLADpWLppVaU6JnPaA=;
        b=ApCRuJhFmodGMwlgaAtlrkpMGNmZYysR4pKkig+xGWNRSdjTmJUWmuZ8lbpBnd0RiR
         BerhfSUJ77z06TX9hykaXR3Qx9uhuAW+xbaLro4BmuHZYUWqAJfJcdJUjOzdusxPq4hv
         flk2QG7Uo/To6t2I5dCMAccaOYtaVlYQSxzrsPhJOH8YEOw7+nr195Llk1wuP+fFGwvc
         sIoZTStIShJ/vh+AeXXNpyvlTgfFhzQeDI7Vpew15WyjYiC7m1cNZVhIsEFbiD/srSLd
         aRDReX0Iv12IhDMP9fVPzcm9Z19ldhjNvxQsJzrp/hVK3niU3qovIrGH2uDRkBrDFjEN
         XOXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780519262; x=1781124062; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgy0q+soH6ra9WOGTCpqCZxx4OBCCpEK1MDQ6EDcR7I=;
        b=VA3dD4HsIIjLcz3W8X7lCSyse8OiQHBauBoFpYOpkoDt+TNW6UAuw49E4s9OW2ZXFI
         dkQQPqvXU7ggXIEHsh/SUbBD1hXjwuduPHmL2TSUXl/Kzxhn8+y1zFV4ratnwe05tK2J
         jU6uXrZq0Q9WPPiU7aWAnsbdU+qUlj7gCjjjq8ckpYGg4cZuGVF+lUUG9hk7qrbKrxkN
         SmCo+g+PNcd2nw73a4z3Ov4ERVZ4zXmKZYIBnIKBwoUUmXXbwjP+otYux3pfjRz8eCi1
         CHNcCwyT72XWJEKHmDvQzpzcGDiVfdgLUnX+ASNAGMtuJvUqs4PzlHFkSOlf13m1+IP2
         K/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780519262; x=1781124062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kgy0q+soH6ra9WOGTCpqCZxx4OBCCpEK1MDQ6EDcR7I=;
        b=bLcXXuTNW5Tu5ZjjJK4mkud1SVBusq8i89bSR+p0ZTwWyG00j6uhrgzeY/k00gzU4V
         wRr6LQSWcy1AHtOZR0sXH+kbaQus4N0h+PgiTbmBhcvv1/wDesvoKBfB4PuRXVH2/F7P
         LCNS5bSeODuD27KHpQKiXkDk8Z26ddGotaQi2jncRo6M6Gi0QtcJRNwWXzXVY607K3ti
         FDJuzDezhXc4XK8e3zEWEB4w95klok5SkgZzBYMeGn5RsvKRw1AcKxT7EumRzZByu/c4
         tX19ZXbEbU2760ziallzxJMBHJIW0ikOoy34US/rqjcK1/8Fx3+hPowkns7OaFqqbziY
         HTWg==
X-Forwarded-Encrypted: i=1; AFNElJ8eKXqJD28prIeMKo7D1yGla/fpcmLN3cP2M0pY/VU0LjmQHErfk0qsAUZj7icrey+qYfQoR2qpUQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+v/6myo0L8dYVBj+R1qcy7zWUHIDlFWqQPt6j96TIxqm4LBMO
	yvr0zBnyTJo8EOiNwEbCMCbml13KXlNpOidLMsqRB7zbzknoPYDQxYpK/Upq/nUPYiukANuRzt8
	u3gbzpcfbfCkoZFTxzgpbvlPF/q3sMVWPF9bcFvDW
X-Gm-Gg: Acq92OHFYbYazsJiI9VOMRVKH0EZZA8KaH3P3h4Jl5x+3uY9RkozCoCUycIQFeCivG1
	zitk67S9c9yGtMs1ARs++x+NFu5cTBlunYWO4LWUSQQUTkxiLxkaU9NXBIN4UDrzyVvKIohwG1Y
	VA6ajS1V3FJQCtK1qgp5CUf9iI1hgF0bnZUKwxgRCHjTwx7MpUHTqVcxXz+dV4ULgasR20UVVTW
	7JeisHJGW0ipE2T3/vC1ymmTIIuX0eyE7rQBA3KG6C1P+1OE648sxxzbWv1m3CiYqdKhrKb2/NK
	yArn91V9pI0a71uRpVaAkcnKB1xSn/Z0+prVPRBWX09xGaGI
X-Received: by 2002:a05:622a:42:b0:50f:ce97:3b84 with SMTP id
 d75a77b69052e-51787999ce5mr2671201cf.6.1780519261443; Wed, 03 Jun 2026
 13:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
 <c4b425d1f9192caca3cad830f322aa048ed26d45.1779471082.git.abhishekbapat@google.com>
 <de0f2984-44ea-4098-9d19-c63ee035cdaf@linux.dev>
In-Reply-To: <de0f2984-44ea-4098-9d19-c63ee035cdaf@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 13:40:49 -0700
X-Gm-Features: AVHnY4JBte4PDDimU7o18M62S6t5FNbXE805byzWiOJZ2j9yZL0qusMtWj91VMs
Message-ID: <CAJuCfpFb1qEMN9t34un5BAPyFd4m9o7NY8w5DwQnzYrNqpK_Eg@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] alloc_tag: add size-based filtering to ioctl
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 47C0FA0005
X-Rspam-User: 
X-Stat-Signature: mastxuaipmiwbkpaynbc7wcqoxjbw369
X-Rspamd-Server: rspam09
X-HE-Tag: 1780519263-612923
X-HE-Meta: U2FsdGVkX1805yz/EycgChIImDzrLpjwfmNdtx5SvYF5gTgMMs+d4DeR48iBvPnbSN43Cs9tGd01BGg/dfpnnVqKcI/89D1VeF4TpYnpJ0z5DGRwY6mapsE10YpTftiFyetA4/9UZyKBL9ICxgYEE1chdYp0Bv17KgbkG+PLZen534dq0du8VDThcoKELcl9wSWvBTfktAv9oNmy2WfFVYM7PXrE0Z0+D6tj0a2uMC7HWKrKTGse1AulIQkKWXFEDqcFyBYH82ZmrIbqKajy04Huy1jusEe2KY6XeDHAOJLIrq8PDrn6wOr+TN3ahAD4nYuyUeeGoXAZ3fMhNlsDMaZvN8Vp4ha2kOFwk5jBqSmkmegOzneZiqucXSFIIvNTcjdGvX1fgE63FF2aKfwNfBYve7GbIbFDKEyG/LCxlAu1XdfVZtJLz23Tbps3IZA5z+U6gupS1XF4a6t4NPOwtq0NSpoQPdguUPGFQpBZ6+CmFxyb27zWdc7yE4fmQftO9mtAldwQjxhvqvU+tWTPiM4ouMHIuSbIZ+mh7Ff7wppOAmOZZVMMVoaJq3tneUbGodpyMVbYgwRuMGP6yt15Le6u5Hma5vTKbnu7lWTcxyu+tlQvx75kvUP8jnh5yyi9yIcYqWEEFLJATkoDcNMoCJRYeW/oMoZt9ejrNPSGIvBGOubVTGN2DnQ37UZCXA2oeTrQ3RF3XxFiiJ04Ll0iXGsIWZLX29FTfkkADVSuWaRQUGl9FVMU0v0OCTTB6Nl+E78C1SW4FOC9scIs1Ku8zwmN1qeWggSU+0rXv2Q7YQ3IMqVmkxGaR+X1sKS7ias27rDN/3vCH7txhig1j3JQ/fslKM9MSxE2rQ1q9Y8/yvlJOCU+MtJhNP86SLdc9472XI2MzDrFrl2BxdZg62ePxbV5efLdv1YkFybRgFeuIbV5hzUPblMbo1lJKnufH4Hf2OiqFxyI9YDQQtE5u+j
 n783iFh7
 TC0EETI4RVwXARa6NXOWUXfKbHORh1vTVhnH7SFhyOEjDA9ZQPGXwydlhnaNOt0H1MnrQnEi4KygzYum4sibfLcUgLD9guTn1Jjz7gsmbUia2B0hpv9fbjMxaRAY/hg/gxg16fZSEsY3sJ5C02cGE/7PpgwsqoQAbut1AjVCBuvK8f45phSWceO0is70qJyNKxw5ukyP2WOqOrJdOukb4JsNmXDK7RrIt5Ikw0S5ljzYgct/gwSNGG3L5JO4F28foyghBSDgiuuqSJwT1C522XQug45KyE9RwMsQSwkoikqykHnI6rL9UbuV6LhGM3LFVRfU0sMuBuIaZLxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 8:12=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/5/23 01:45, Abhishek Bapat wrote:
> > Extend the allocinfo filtering mechanism to allow users to filter tags
> > based on the total number of bytes allocated [min_size, max_size]. The
> > size range is inclusive.
> >
> > Filtering by size involves retrieving allocinfo per-CPU counters, which
> > is an expensive operation. Hence, the performance of size-based
> > filtering will be worse than other filters.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   include/uapi/linux/alloc_tag.h |  8 +++-
> >   lib/alloc_tag.c                | 72 ++++++++++++++++++++++++++++-----=
-
> >   2 files changed, 68 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index 0cc9db5298c6..45f158bee0a6 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -39,13 +39,17 @@ enum {
> >       ALLOCINFO_FILTER_FUNCTION,
> >       ALLOCINFO_FILTER_FILENAME,
> >       ALLOCINFO_FILTER_LINENO,
> > -     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > +     ALLOCINFO_FILTER_MIN_SIZE,
> > +     ALLOCINFO_FILTER_MAX_SIZE,
> > +     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> >   };
> >
> >   #define ALLOCINFO_FILTER_MASK_MODNAME               (1 << ALLOCINFO_F=
ILTER_MODNAME)
> >   #define ALLOCINFO_FILTER_MASK_FUNCTION              (1 << ALLOCINFO_F=
ILTER_FUNCTION)
> >   #define ALLOCINFO_FILTER_MASK_FILENAME              (1 << ALLOCINFO_F=
ILTER_FILENAME)
> >   #define ALLOCINFO_FILTER_MASK_LINENO                (1 << ALLOCINFO_F=
ILTER_LINENO)
> > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE               (1 << ALLOCINFO_F=
ILTER_MIN_SIZE)
> > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE               (1 << ALLOCINFO_F=
ILTER_MAX_SIZE)
> >
> >   #define ALLOCINFO_FILTER_MASKS \
> >       ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > @@ -53,6 +57,8 @@ enum {
> >   struct allocinfo_filter {
> >       __u64 mask; /* bitmask of the filter fields used */
> >       struct allocinfo_tag fields;
> > +     __u64 min_size;
> > +     __u64 max_size;
> >   };
> >
> >   struct allocinfo_get_at {
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 56c394ef721f..6c8743eead2d 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -173,11 +173,21 @@ static int allocinfo_cmp_str(const char *str, con=
st char *template)
> >       return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
> >   }
> >
> > +static inline struct alloc_tag_counters allocinfo_prefetch_counters(st=
ruct codetag *ct)
> > +{
> > +     return alloc_tag_read(ct_to_alloc_tag(ct));
> > +}
> > +
> >   static void allocinfo_to_params(struct codetag *ct,
> > -                             struct allocinfo_tag_data *data)
> > +                             struct allocinfo_tag_data *data,
> > +                             struct alloc_tag_counters *counters)
> >   {
> > -     struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > -     struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > +     struct alloc_tag_counters local_counters;
> > +
> > +     if (!counters) {
> > +             local_counters =3D allocinfo_prefetch_counters(ct);
> > +             counters =3D &local_counters;
> > +     }
> >
> >       if (ct->modname)
> >               allocinfo_copy_str(data->tag.modname, ct->modname);
> > @@ -186,9 +196,9 @@ static void allocinfo_to_params(struct codetag *ct,
> >       allocinfo_copy_str(data->tag.function, ct->function);
> >       allocinfo_copy_str(data->tag.filename, ct->filename);
> >       data->tag.lineno =3D ct->lineno;
> > -     data->counter.bytes =3D counter.bytes;
> > -     data->counter.calls =3D counter.calls;
> > -     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > +     data->counter.bytes =3D counters->bytes;
> > +     data->counter.calls =3D counters->calls;
> > +     data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_alloc_t=
ag(ct));
> >   }
> >
> >   static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __=
user *arg)
> > @@ -204,7 +214,8 @@ static int allocinfo_ioctl_get_content_id(struct se=
q_file *m, void __user *arg)
> >       return 0;
> >   }
> >
> > -static bool matches_filter(struct codetag *ct, struct allocinfo_filter=
 *filter)
> > +static bool matches_filter(struct codetag *ct, struct allocinfo_filter=
 *filter,
> > +                        struct alloc_tag_counters *counters)
> >   {
> >       if (!filter || !filter->mask)
> >               return true;
> > @@ -228,6 +239,17 @@ static bool matches_filter(struct codetag *ct, str=
uct allocinfo_filter *filter)
> >           ct->lineno !=3D filter->fields.lineno)
> >               return false;
> >
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
> > +         (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> > +             /* We assume counters is not NULL here as per caller logi=
c */
> > +             if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > +                 counters->bytes < filter->min_size)
> > +                     return false;
> > +             if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > +                 counters->bytes > filter->max_size)
> > +                     return false;
> > +     }
> > +
> >       return true;
> >   }
> >
> > @@ -237,6 +259,9 @@ static int allocinfo_ioctl_get_at(struct seq_file *=
m, void __user *arg)
> >       struct codetag *ct;
> >       struct allocinfo_get_at params =3D {0};
> >       __u64 skip_count;
> > +     bool sizes_set;
> > +     struct alloc_tag_counters counters;
> > +     struct alloc_tag_counters *counters_ptr =3D NULL;
> >
> >       if (copy_from_user(&params, arg, sizeof(params)))
> >               return -EFAULT;
> > @@ -244,9 +269,16 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)
> >       if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> >               return -EINVAL;
> >
> > +     if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > +         (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > +         params.filter.min_size > params.filter.max_size)
> > +             return -EINVAL;
> > +
> >       priv =3D (struct allocinfo_private *)m->private;
> >
> >       skip_count =3D params.pos;
> > +     sizes_set =3D (params.filter.mask &
> > +                  (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_M=
ASK_MAX_SIZE));
> >
> >       mutex_lock(&priv->ioctl_lock);
> >       codetag_lock_module_list(alloc_tag_cttype, true);
> > @@ -261,7 +293,11 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)
> >       ct =3D codetag_next_ct(&priv->ioctl_iter);
> >
> >       while (ct) {
> > -             if (matches_filter(ct, &priv->filter)) {
> > +             if (sizes_set) {
> > +                     counters =3D allocinfo_prefetch_counters(ct);
> > +                     counters_ptr =3D &counters;
> > +             }
> > +             if (matches_filter(ct, &priv->filter, counters_ptr)) {
>
> alloc_tag_read() walks all per-CPU counters which is not cheap, but here
>
> it's called for every codetag unconditionally when sizes_set is true,
>
> even when the tag would be rejected by modname/function/filename checks
>
> that are plain string comparisons.
>
> For example, say the user filters with MODNAME | MIN_SIZE on a system
>
> with 10000 tags, 100 of which belong to the target module. Today the
>
> code would call alloc_tag_read() 10000 times (once per tag), but only
>
> 100 of those tags pass the modname check =E2=80=94 the other 9900 per-CPU=
 walks
>
> are wasted.
>
> Would it make sense to split the filter check so that per-CPU counter rea=
ds
>
> only happen after tag-based checks pass? Something like:
>
> static bool allocinfo_match_tag(struct codetag *ct,
>
>                          struct allocinfo_filter *filter) { ... }
>
> static bool allocinfo_match_size(struct alloc_tag_counters *counters,
>
>                                     struct allocinfo_filter *filter) { ..=
. }
>
> And in the caller:
>
> bool match =3D allocinfo_match_tag(ct, &priv->filter);
>
> /* Add comments to help subsequent developers understand the purpose of
> this modification. */
>
> if (match && sizes_set) {
>
>             counters =3D allocinfo_prefetch_counters(ct);
>
>             counters_ptr =3D &counters;
>
>              match =3D allocinfo_match_size(counters_ptr, &priv->filter);
>
> }
>
> You may find a more elegant approach to resolve this issue.

That's a good point. The counters should be fetched only after all
other filters have passed their checks. Otherwise you lose most of the
performance benefits.

>
> Thanks
>
> Best Regards
>
> Hao
>
> >                       if (skip_count =3D=3D 0)
> >                               break;
> >                       skip_count--;
> > @@ -270,7 +306,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *=
m, void __user *arg)
> >       }
> >
> >       if (ct) {
> > -             allocinfo_to_params(ct, &params.data);
> > +             allocinfo_to_params(ct, &params.data, counters_ptr);
> >               priv->positioned =3D true;
> >       }
> >
> > @@ -292,9 +328,15 @@ static int allocinfo_ioctl_get_next(struct seq_fil=
e *m, void __user *arg)
> >       struct codetag *ct;
> >       struct allocinfo_tag_data params =3D {0};
> >       int ret =3D 0;
> > +     bool sizes_set;
> > +     struct alloc_tag_counters counters;
> > +     struct alloc_tag_counters *counters_ptr =3D NULL;
> >
> >       priv =3D (struct allocinfo_private *)m->private;
> >
> > +     sizes_set =3D (priv->filter.mask &
> > +                  (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_M=
ASK_MAX_SIZE));
> > +
> >       mutex_lock(&priv->ioctl_lock);
> >       codetag_lock_module_list(alloc_tag_cttype, true);
> >
> > @@ -304,10 +346,18 @@ static int allocinfo_ioctl_get_next(struct seq_fi=
le *m, void __user *arg)
> >       }
> >
> >       ct =3D codetag_next_ct(&priv->ioctl_iter);
> > -     while (ct && !matches_filter(ct, &priv->filter))
> > +     while (ct) {
> > +             if (sizes_set) {
> > +                     counters =3D allocinfo_prefetch_counters(ct);
> > +                     counters_ptr =3D &counters;
> > +             }
> > +             if (matches_filter(ct, &priv->filter, counters_ptr))
> > +                     break;
> >               ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     }
> > +
> >       if (ct)
> > -             allocinfo_to_params(ct, &params);
> > +             allocinfo_to_params(ct, &params, counters_ptr);
> >
> >       if (!ct) {
> >               priv->positioned =3D false;

