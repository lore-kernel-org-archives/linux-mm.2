Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C52CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 23:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2DF6B008A; Thu,  4 Jun 2026 19:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53096B008C; Thu,  4 Jun 2026 19:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B866B0092; Thu,  4 Jun 2026 19:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD246B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:53:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4420A1C1218
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:53:25 +0000 (UTC)
X-FDA: 84843884370.02.A9E5B03
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3CEF040009
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:53:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MIeYDlKN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780617203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sayKnAkcvjh5O6e9c0QpImq/vePww6nkOl9CjIY9+Y=;
	b=gDeSrkFd3Jwrb06QemiN1beyMVcu/JfjCvb0uaLl42ed5jonj1k9TPx353uR7V065HS4t1
	IpDOxRAtb+llkC0ziDnXl6VIVm0NzAWKurb6c1L3HLoT3UpSmP195sd6GszVjzxJEtIPfp
	yw0KDoHSFToWuEdFjhcRvUpUaxOyjTc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MIeYDlKN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780617203;
	b=JD255jjJ1JrwJDczbhuZEx6qDsYYwAQl3YSugPTODP3NAeONt+ddADcI+mQFt46ku/4R/+
	jL7oRebS0uDFfkhiXFo2MMGXNc/xLD93IwjUb+U7i//qZITepz0s5xaYN4KW9BUwP//cKW
	YoySUhNPhBOj6SrUKFmJW0uaZUDU10A=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bf2d865383so30425ad.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 16:53:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780617202; cv=none;
        d=google.com; s=arc-20240605;
        b=gP3/g/alh0zWeVFuhIPcjPjDxUtZmv/kBE0jp6iyVz/xup1c6yNy2vtin3xbsEDkbP
         VjyLGf0iO6h9UPan0HlTv6uGUZ/nHwDqUrR+1HoEAwBNRC8Udw5ArI16NMScQVJqH/OX
         c59nTvhXizqFNMiAhErc8JcDo4jVqHGh2rUus8lvK5gAagDeQBK6EBqyT/0tz1luiud4
         pFgtqGI+a8AItzgwPM85cMooCYqeIhrpZdllWomC6kQlwLp4BjqytoJ9Y+3pnbsM+0u0
         FX334/FLONksgrR7FnsBx490MvarjebC6pVzqrCnte65x+qGjdyWKB+7K/jHT8zsfTv+
         zCYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1sayKnAkcvjh5O6e9c0QpImq/vePww6nkOl9CjIY9+Y=;
        fh=IS5dAkzaZa2A4We0NeVCuRxlHIXJnj3umssJQN90zWo=;
        b=B1uZiPJvuRPw6QVMwLOhWVx74Yx3D5RLSTvghz9yoe8wJcd5jTxPU/oKusZZFbo/MR
         23cc8pL1NUECg1KJxMD35v7OjGTI2AZq4mR89sO2/OaqwCpA6xlN8TorU4dziyixKybD
         TkVM58FwA63DK+MAUDrLaVBBUY9mW7MvHkrm2INuAfIjnayHIi66HPWME5roVOOFl3c5
         y7mfM0k2/5OJo5YDTsol/RobAsQbEwDUfPV70QftckxALLJaky5JmVofYi+7vRuu2PPj
         kx4Un9fZVmnIjACzVJnE1I9gu1YgN7xUb2dJJpatkN5OKs8WLE7lGiFzpf7uR6Cs5j6L
         E65Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780617202; x=1781222002; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1sayKnAkcvjh5O6e9c0QpImq/vePww6nkOl9CjIY9+Y=;
        b=MIeYDlKNSfMmlwjy6fw1P6b7zfC8iIhwk9ph1TtZOcgZly2ybTj9yzDB3g9LExqpCZ
         qIL1ZpTu3/cGkgdJQl7KQ/qzAGJzR6T+WopTM9agvPGlnxj6I2b9mvNcIjTdFr/O6V4H
         bv0zox2wwgSuEAYrFxvvFQkPniV32Ci2pwMADHUqfl5nbKx1gRuMNeoDSABaiNI0Giog
         aw4jmFa5JSTXYD/wfBUY8o2FFQmmO0Ze5UVMItwe1ri2V3jSbAhP5AtUgh9kpqmftXQX
         EovYjAzeayQpwYIjRn38vPV4gwDJa2X+XouwRh+SgFklcHFi7++xQAGM97iRy9VgoHdJ
         l1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780617202; x=1781222002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1sayKnAkcvjh5O6e9c0QpImq/vePww6nkOl9CjIY9+Y=;
        b=b/QIbEME7bmy5yhuhFuvjYc708F9krDyR+BXoCSbydvh04CjZRTgM+2ZfczzeXkMFl
         tlAALHF/XeXpGc69PWPupCARdiK+GjtkH+ILZc8MynnzBnmjrzdGmoXJj1toSU8kf+Bh
         lg6s9al6GGvCkU3XgyRyt+dBZGXJq4xIxhLeY6XxX97HiEdNpZtmgL7c+pY+YlDl5TyP
         e3h+wQcU5LUPfCp3IbRYMM00MsPEUUdCkFUL9LtsI+9kB1pERVBtQLtwevgW+abAcWWI
         Ch+1AA9Egn0Dr7Qrzz3sHjpgMYjsjflRNEqQlKAY19FNvGnFDVr0NIs6lC6Fw+yGW57k
         s8XA==
X-Forwarded-Encrypted: i=1; AFNElJ8pb+8Yct6Y+1cMF3lbhpGz4hwEleD1PJ+Dmx+KMOIkuRcejvHH462PsuKvpHnxF5K/EulHVKRlzw==@kvack.org
X-Gm-Message-State: AOJu0Yy/Q/M6c1bv3w68yHlIKqdMXA/1ORaOvIhS7RL8DDoopqiUOijH
	UEnVfCHwBK5abneeDtxvXAv91wVqe2pDvRglxapEqUXPkB7ju2FQ/rfhu4GcXFoBqwDFjE+7qs2
	3ILv5qp/oKygxWTzW3MFHNX/FxyWeJwA0xY/E+1Xi
X-Gm-Gg: Acq92OHcsX2WI2jjKjJnrxqKD7dNqkfmSUJKA88ZQbAgZmQAPppLqbMY8TZQMUDZWQq
	zJy16oDROuEqe4MGlm+lebwVLgu4DHneFvWaYte+0zaa6wwKRuNbndVCfU8wyoTBiKr746OUjst
	dO5gMdkqLnsC/eKDyZyRax2WdPdF0W/CdCj18iA1FqAZx9OIGENAc89zbwfs5A4B31pRqHZ+v1E
	Uigd7hc3jGUhrSNfZbR+v+GiniEwBf7rL4uXCBiK/EK+I+tL11AnDOcth8dRz1F7OqOcaoOJCQV
	MOvAz9aPGhy6ipVBdTzYDfx2vKd+R+a5a+UEWv8twc1fvoz/
X-Received: by 2002:a17:903:3807:b0:2b7:b03d:9dce with SMTP id
 d9443c01a7336-2c1ebeb5fa8mr261515ad.18.1780617201343; Thu, 04 Jun 2026
 16:53:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
 <f177efebdfda5c2a179d7cd6768e0c6f37efb9c4.1779471082.git.abhishekbapat@google.com>
 <aba73999-dc29-45c1-b6cd-54a7c1b824fa@linux.dev>
In-Reply-To: <aba73999-dc29-45c1-b6cd-54a7c1b824fa@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Thu, 4 Jun 2026 16:53:10 -0700
X-Gm-Features: AVHnY4KyqsDiHrH7JcfoQPZjpkORjY20gfnuwslf8qqI9Nu431iLe4LIAgxAv_o
Message-ID: <CAL41Mv4fkK-t55GuDNTe9fie9nUBfY_Ap3CpgT1XDpn8sSU0qg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rfbwe4kuz8wapr5qizepn8fi3e8hpybi
X-Rspamd-Queue-Id: 3CEF040009
X-HE-Tag: 1780617203-551850
X-HE-Meta: U2FsdGVkX1/vx7CojW3y4apbI/94X6Dks0MeQGfLjlolV8lA0yi8pMQlt9JvXuAeRK8+4RkZKrcFlZnLbM4ujCk8BjlpzZ/Sk0ACswUtitKTaoL/FMN6C0g/lVdiSNrjVF3ZZ5hdG2LH/aaB3VxLjpW3RDwiyt86pHbxP0ahMffSCA9urUBPRLbSsVPy/kvX9cVJqUHtFED0tjCkuh+3ThRZlSWHw24PiaUK0ENb2HgvFoTGPsgczh926wmZvVmMS5NMl0vYOQ2nednbMKyjgyugHJ4ItfRfpHN4xYVVGKZ4RciO9oIDuAvsTwwYgG6Yxy6VFAg0yOWSa9vtFbGOf9h5mnqbo8ygTH4E7HayEpUr+jsyq7YcraM2EYSoaDzKpD74NsVNnvGlKH0rstyfnzKkldNDAThMpzw9QdqCapnCd8/HwBa+WHB8JwAZDMLiroJaa7/y6cyZJc2eBPRC3neTYUtf/ZEPFnMKSZVSLtCAg/ZIdE1sUoIPWZ574vElIWEFFO2JYvL1SiIl1Nev6i2OknAnfizxfVxFpFgzlosdVV0QhxnOBJwk/lj5CIMfg/hueYBzi7lpUsB11A9sMmLr3FvV2l89/jOY2OA97v8lkxbRUZRSmFKZuEY+nW0kdpul3Ykbp1OCNcNIFoESU5I4+w2XwUUQ1iDAa6eGwo5JLd8jVFa8xYDfaJLOJvdvJ8Tm1KM0wlniC6ye12md5WzgKd4vDBdex7lAMYX8/yJ4Cj9ZttDhWR0fbQvAKCOycwtDatpnAz5f6E9IW3o9d9ZcDxfFRIZh+EVN86RfjWkqSzM1d7FNZx0x5400z4qjuAXwq/8GcxeM24O8AMcSj7Qpe98vaUnjo58bGqIzNrP92mIM3qr3rKSk6a6DcVD0MEsbdZQQnmp/XTjMd3dEnKJFX0ZoZCcCBRfeOAx7n9l4J7XmisKktBClIPQMAapncqh31sfXklPT+EsYVXB
 MM1xBW/g
 ufuliPWC8JOrdI2jhkA22nm9Rfe1WtgIEFlKaAcmEvi+n3pHYhshVQK3I4yEv1PtjFVAlipYyT6tfGGCDrx1J3dsohfN7Z3KipBUPNu5wQY4yEn5D6E4P/iqRTwmTZmdakiLp4vIQ/GndUT5KJXmf9DXCHdiEQ9FXu4Q1nO/BulCdHU/USn1+zLlen/pop3oLa5gpt+aEuKn98rSeSo7yF0WrqcWCx5egpdqZ6rLVwU3gNcQscEJUN+/nykExxn3I/1Rj5W4OwA2MAYwSOC1cKsIIhJmbYglnfG5nuHtw/B+v1/K3Uk50D4xY3QR84Wzdacu+eJYBhcDzwIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 8:00=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/5/23 01:45, Abhishek Bapat wrote:
> > Extend the capability of the IOCTL mechanism to filter allocations base=
d
> > on tag's module name, function name, file name and line number.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   include/uapi/linux/alloc_tag.h | 26 ++++++++++++++-
> >   lib/alloc_tag.c                | 58 ++++++++++++++++++++++++++++++++-=
-
> >   2 files changed, 80 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index e9a5b55fcc7a..0cc9db5298c6 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -34,8 +34,32 @@ struct allocinfo_tag_data {
> >       struct allocinfo_counter counter;
> >   };
> >
> > +enum {
> > +     ALLOCINFO_FILTER_MODNAME,
> > +     ALLOCINFO_FILTER_FUNCTION,
> > +     ALLOCINFO_FILTER_FILENAME,
> > +     ALLOCINFO_FILTER_LINENO,
> > +     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > +};
> > +
> > +#define ALLOCINFO_FILTER_MASK_MODNAME                (1 << ALLOCINFO_F=
ILTER_MODNAME)
> > +#define ALLOCINFO_FILTER_MASK_FUNCTION               (1 << ALLOCINFO_F=
ILTER_FUNCTION)
> > +#define ALLOCINFO_FILTER_MASK_FILENAME               (1 << ALLOCINFO_F=
ILTER_FILENAME)
> > +#define ALLOCINFO_FILTER_MASK_LINENO         (1 << ALLOCINFO_FILTER_LI=
NENO)
> > +
> > +#define ALLOCINFO_FILTER_MASKS \
> > +     ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > +
> > +struct allocinfo_filter {
> > +     __u64 mask; /* bitmask of the filter fields used */
> > +     struct allocinfo_tag fields;
> > +};
> > +
> >   struct allocinfo_get_at {
> > -     __u64 pos;      /* input */
> > +     /* inputs */
> > +     __u64 pos;
> > +     struct allocinfo_filter filter;
> > +     /* output */
> >       struct allocinfo_tag_data data;
> >   };
> >
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 3598735b6c93..56c394ef721f 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -48,6 +48,7 @@ int alloc_tag_ref_offs;
> >   struct allocinfo_private {
> >       struct codetag_iterator iter;
> >       bool print_header;
> > +     struct allocinfo_filter filter;
> >       /* ioctl uses a separate iterator not to interfere with reads */
> >       struct codetag_iterator ioctl_iter;
> >       bool positioned; /* seq_open_private() sets to 0 */
> > @@ -167,6 +168,11 @@ static void allocinfo_copy_str(char *dest, const c=
har *src)
> >       strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> >   }
> >
> > +static int allocinfo_cmp_str(const char *str, const char *template)
> > +{
> > +     return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
> > +}
> > +
> >   static void allocinfo_to_params(struct codetag *ct,
> >                               struct allocinfo_tag_data *data)
> >   {
> > @@ -198,27 +204,71 @@ static int allocinfo_ioctl_get_content_id(struct =
seq_file *m, void __user *arg)
> >       return 0;
> >   }
> >
> > +static bool matches_filter(struct codetag *ct, struct allocinfo_filter=
 *filter)
> > +{
> > +     if (!filter || !filter->mask)
> > +             return true;
> > +
> > +     if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
> > +             if (!ct->modname)
> > +                     return false;
> > +             if (allocinfo_cmp_str(ct->modname, filter->fields.modname=
))
> > +                     return false;
> > +     }
> > +
>
> Apologies -- I previously suggested the "!ct->modname ->
>
> return false" approach, but I realized we broke the ability to
>
> filter for built-in allocations.  allocinfo_to_params() returns
>
> modname=3D"" for those, so a user would naturally try to filter
>
> by modname=3D"" -- except it never matches because ct->modname is
>
> NULL, not an empty string.
>
> Maybe something like this instead?
>
> if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
>
>      if (ct->modname) {
>
>          if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
>
>              return false;
>
>          } else if (filter->fields.modname[0] !=3D '\0') {
>
>              return false;
>
>          }
>
> }
>
> That way modname=3D"" matches built-in tags, which lines up with
>
> what the API actually returns.
>
> Thanks
>
> Hao
>

Ah good catch, will use the following logic that's a bit cleaner:
if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
                /* user wants to filter by modname but ct->modname is NULL =
*/
                if (!ct->modname) {
                        /* validate if user was attempting to filter
for built-in allocations */
                        if (filter->fields.modname[0] !=3D '\0')
                                return false;
                }
                if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
                        return false;
        }

> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
> > +         ct->function && (allocinfo_cmp_str(ct->function, filter->fiel=
ds.function)))
> > +             return false;
> > +
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
> > +         ct->filename && (allocinfo_cmp_str(ct->filename, filter->fiel=
ds.filename)))
> > +             return false;
> > +
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
> > +         ct->lineno !=3D filter->fields.lineno)
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> >   static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *ar=
g)
> >   {
> >       struct allocinfo_private *priv;
> >       struct codetag *ct;
> > -     __u64 pos;
> >       struct allocinfo_get_at params =3D {0};
> > +     __u64 skip_count;
> >
> >       if (copy_from_user(&params, arg, sizeof(params)))
> >               return -EFAULT;
> >
> > +     if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > +             return -EINVAL;
> > +
> >       priv =3D (struct allocinfo_private *)m->private;
> > -     pos =3D params.pos;
> > +
> > +     skip_count =3D params.pos;
> >
> >       mutex_lock(&priv->ioctl_lock);
> >       codetag_lock_module_list(alloc_tag_cttype, true);
> >
> > +     if (params.filter.mask)
> > +             priv->filter =3D params.filter;
> > +     else
> > +             priv->filter.mask =3D 0;
> > +
> >       /* Find the codetag */
> >       priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> >       ct =3D codetag_next_ct(&priv->ioctl_iter);
> > -     while (ct && pos--)
> > +
> > +     while (ct) {
> > +             if (matches_filter(ct, &priv->filter)) {
> > +                     if (skip_count =3D=3D 0)
> > +                             break;
> > +                     skip_count--;
> > +             }
> >               ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     }
> > +
> >       if (ct) {
> >               allocinfo_to_params(ct, &params.data);
> >               priv->positioned =3D true;
> > @@ -254,6 +304,8 @@ static int allocinfo_ioctl_get_next(struct seq_file=
 *m, void __user *arg)
> >       }
> >
> >       ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     while (ct && !matches_filter(ct, &priv->filter))
> > +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> >       if (ct)
> >               allocinfo_to_params(ct, &params);
> >

