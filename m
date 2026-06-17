Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8909CCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 16:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C6F6B0005; Wed, 17 Jun 2026 12:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDE26B0088; Wed, 17 Jun 2026 12:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE306B008C; Wed, 17 Jun 2026 12:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4028F6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:31:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A5021664E7
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:31:15 +0000 (UTC)
X-FDA: 84889944510.19.668143F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id A29C71A0018
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:31:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OKQqCX9N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781713873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwqItWx2zhoOu+jNLo6XBphjqE31Cnx/skDcn/83dd4=;
	b=XhB62XDT6wGoCD3Yq+UbqSThNfaPVlGqtLa6CPd6k+UAv+KB4zan/PCbu2xKV2LUaBYp0W
	7tCDYRzvy54+2fryC8fb2X29kPy48dfrS8dJoPPHo6ZfpC9YG6pfq1GYUo3cRf+W6beyaf
	SCd7/WOkNRwkvyC/AUtgK/3z069zZcI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OKQqCX9N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781713873;
	b=XOYbdaDcLLmX7seGQwEWnThn3z90ut+32B6tUMuagQX3/thGzFOjm2au0Q/y+Z8820XqhR
	g9PLx6H4vHd5E6UU0yl7TEc6zUCAM1Z0MIMe7oeIG+K9kJSMjlnscq3fETP19KhxgwMVzR
	IN/ubn6uTCdEvB40L8snzIwaMmM0BBk=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5175d339e8bso831cf.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:31:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781713873; cv=none;
        d=google.com; s=arc-20240605;
        b=TkSbPNiRTi+E2Y9WBqUqvQkzDo32RSlPU/p4bgpceWgI/sbxRaYDj6YhPeFz4eAdSI
         qUahppa9uTEIw4aJUlsrwbyqWdDq5vCSCf6YTicwebzDUT5G078XEIkByM+ZHAOyZ72A
         MY1/5bQ54Iu2FUENWiILm+wegBA4ivGeTv2go62eClICagdzd0h1ela/S7Qt3FPIwn9y
         K/i4fqd9XKDddtM9qbEANyvpdRvAdSZTvIcvKpKR9KbJfg2WdoE+ehsAGWHHR/XUOz2m
         j9ytDCia6E1XnDKoIzfGYJqNf/qzBNYPbY+lStp40iysV9VAjS9GW3sDXc/Ss+k8EZIB
         0j4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nwqItWx2zhoOu+jNLo6XBphjqE31Cnx/skDcn/83dd4=;
        fh=cQPV964Dz32tAiO3h9zPmY/cdNOYvauZP5Lm+BC0K28=;
        b=LBeR53ljF+G04zwFl00jiVjcDobVHGV1kvw8gtPw3r1Jg6YuEeqkswA3+k918N91CA
         DRgNgFm50v4FeuLdqWF1rkVysrCTWqPdz7ZJjTtqYDkqxUQwELXicLB/D2ReZzcYh82C
         YgyaVjUsXG82BbA4ta7vIyqJDMQtuG2e6hKEho8deuZrE0iwB5XdX6sohTQm/8sYgDkb
         sOBQie7MNzM+S4XGUwBiB01lDFDMOinWQ9JXO0dtuQlu1UQR0U24zF5RxNxD9gzOTnv6
         UVgetVAx5yQ8Py5tosnN0C5RcPzI+q8LTgadt4mv7ymroAsma2o3GunayQAJ1C/yddT4
         7CZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781713873; x=1782318673; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nwqItWx2zhoOu+jNLo6XBphjqE31Cnx/skDcn/83dd4=;
        b=OKQqCX9NiHIQSqkwaXI9cDqoV9oEp3EV59j0Nq3JmIlTTwEo/PBlp/91DiVVRNcJ0n
         To8ggfi4bTM7NYqbkUnIpMF2vmfkiLzuEvzdsC56J56CU/QAVdBLttnpiAYihbDGHccC
         MaK3QtWtS0z0iA3wYUW1MvYa39RedIiV5fULFEN+aRinBiHVkxQWAEMiZ4z9zvXdV1kU
         SKOKquPfskLFbvOUJUyai7PeDQrqerTSNEwLb+bMcN7yDHUzSm9SNdV5D6CZw5KM2OKB
         0WioAOcj3w8vrfmpb3JfXZ1LEG0IX4Q9LBdHO5JAoXNYfz6B+47WxZqFgE4fI0TaUeaB
         eplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781713873; x=1782318673;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nwqItWx2zhoOu+jNLo6XBphjqE31Cnx/skDcn/83dd4=;
        b=Ewszn0gCxkqcUJT+WrDapp91+m70WC8FegvAMjVsa+sh+9XSiYclE1ZEz4SUH4o8Xe
         S15pz1TiB+0xb96xOSlnR50hgBv/GuTFt2FIpLPxuRJEq7a4afkShWYr+f3VhgQHVbqg
         ZpqqwOsRuhnr5t438BxANfPZhv9mMM0KIZkPn+05sBQ3IbgZsW57x/kHsU6RLSVnCysK
         KlsX8e59Dv117lFJAFMAqXPjUbVRwHMJOONSMqdhm8mZ0bBDcnjQRwPFnyH5DJY6zYGg
         GwZ2b4ELtW7RoBRb1A12UwTefKY4r4IOAY1pQSmYnQ2BCtiHI8O1DQM4NeRLZ90FTI20
         0stw==
X-Forwarded-Encrypted: i=1; AFNElJ+0iZtyZqhyJ8zupXf2Crpga8Lti0N0XBXqhkUH51u9tmfckhpyP0ZYe6A7O/Y09WG0DSxcU+aszA==@kvack.org
X-Gm-Message-State: AOJu0Yxk40vVB589LC8u1f2swSRa2+oaw4yibvKY0+bTEziGOKpR8S7p
	eeh0i5aYbQ1jgiwBKQuHaCM5R+Bo8bxJ3r1QofLnL9/lLLQBxCX2HBo22z4Xu1k1k7ztEpCtixG
	DVOwnf8R+XHJGkSPOoBVXk72P7Wumerre51GvVGve
X-Gm-Gg: Acq92OFiILChQmCo7HvMH6vVOCK7wBEFwuPpGGI8ftZVIuZTr8gM9h1BevujJKKjuU1
	rKA6yT1cWD4nmpQr0QhX1TJUl750ZqcLHh+qWxVfT0TqrRdzV2YkrlQcMppTYO33e7n0u37VELM
	3Z72tcTb8bNpgLAxifuGJMfaa9zV8msNtg44iwbN7MftoqwoOD6AcSKKDp3sDIfPOZhCSyBYHNB
	Mr4Xkk96XDtu6HVFANlNlzvWH7524rdGhmhAw4Qf1b47Pi/X9e4mDGO3y3N9hzZ2oUXaQTkb6gA
	zdHxOKhbYskddWc66ENWvDKVZvuanWUSG27deQ==
X-Received: by 2002:a05:622a:c17:b0:517:99ea:ab80 with SMTP id
 d75a77b69052e-519aae433f3mr10984371cf.26.1781713872147; Wed, 17 Jun 2026
 09:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com> <db41f6b4a1ec7429be79b3b342f1ac8cf1300e72.1781564384.git.abhishekbapat@google.com>
In-Reply-To: <db41f6b4a1ec7429be79b3b342f1ac8cf1300e72.1781564384.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 09:31:01 -0700
X-Gm-Features: AVVi8CcdfMAr-2IUGIwuq0ed5D66f5ARjmPrvoZSjdivlnH_oGVPzXV2FjX90bE
Message-ID: <CAJuCfpHvDhdVseywuk08iJKhos_rU0bsaoKKRPayQ0Oo1OJamA@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A29C71A0018
X-Stat-Signature: uf3zr6ugqxqa1miwg3xo1dnokxfzh6ic
X-HE-Tag: 1781713873-699808
X-HE-Meta: U2FsdGVkX19XGVzu18E6/7gdrQouUrr26ZVeU7NG7Ic7vpUG3uALoGoHPSH3/FhQFNCJAXOg4b+d67aaiL58VAVQcsEco+2l84qnovTioWV1GIy/KqGgrEU5aTf9ZxN3eS4OyTa872mRWzRfcMh79pcMI7/Ht3XOOnhqZ7FHmVPxtU3XOmR5l6MILASzRBvy5bpPJKD/yzRvS1Hlbh71OyZpQZlg4vDFFWAyCquqtzf3fj5k+PDSI1ZE+4I3K0xaKfjKqiJq9AxP2eqgP4CroiliYczdyXHzJAoYTkalk4GYgXo/UI/RlmPXirocToMA6xnyw8E8AYq588ty5LARThT9UejbZZIzrsiy59yDZWWkvCF+MnuSLz3SQvhthlU2yI4yH1j9bC3WcCUzgfohmZRERONSiisbdpzQTYTaybUzw5oMhEwkSXWbp8Hnyyj3LDDDm4UVdPE1Xp08z4ro3uYzPvaPBhKCxPdXtsIms0sTij/u6iufdCXaG1wO/RWLWQfDARaGBHpUwt7d+av5DszGvC83n6oV1gyicqcEPkeA7esv70mQjpvzmVmHxrO3h3vSDAp5Z02zfoc2EnyAFv8jHsDHwhHk+fCkgi9SzgqdD2KBgqcRqd8iF0y6tLg5NG/qOncOa2K/20DQa3GYaZCJ8OScAxN3sCn5qwBb/5VJaVO53PI/Fhz7vXHnkeMM24zlxoVmjTLEdvOs4EUrFHU9fGX0MgRb2X/5FiBtmRWqdRGUroTV0EXyTVC6nxHgBuAp5acd224Y/EyVLBNMh7vICMJ+anw5K6UhF2CGQDx5urM1kVoHXrgLZb4ZnC+VGrnEoIbMoKEqkn2qE2fbHOsDYVxf+u94IskA7K564hKZ2OXYoukOPtpQ68xUCzm9t1xRViOo6EDw3P9KjJIG2GqwFm+WQmG/TfZf6H9o2/xGDiaEolZcUhpH/EIwBEch8hYC5i0Zs93GDxNeHdg
 f1PzAyYs
 ymFI9DplsTya8uGPdwdR2ivVMV/yFrKjzWjfiKjrPFo3RurLK37zb5sF4xwRc5RHV8OGKYt7XcmC1yIqRAEu3YvA46Jq9C2llKGmdFam/+Hfs9fKXF/vDYbot5RcHj0Yg9WENqxpskBiaRk9Odl3jJwF2F0ddB4YEOgDbAttEX3fZNT8aJMQChDjOX+ZsQ1FWLYHMAIyUO2LmU7Rw62TXhK0TaNcL+AHydc6TvrlM8gKq2Wi9VhfLOmsx74BnhznRaxXHLgBcmD9Q1VUTMnaL6egcU2t/cOw5jGj4g8qKuHNA7ahoACoSmrLLJYHvRnXnZHb0QEo8e6Kv1fA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on their accuracy.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> Acked-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/uapi/linux/alloc_tag.h | 4 ++++
>  lib/alloc_tag.c                | 8 ++++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index 7f5acbb44c14..6ea39c4869fe 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -26,6 +26,8 @@ struct allocinfo_tag {
>         char function[ALLOCINFO_STR_SIZE];
>         char filename[ALLOCINFO_STR_SIZE];
>         __u64 lineno;
> +       /* filter criteria only; see allocinfo_counter.accurate for actua=
l accuracy */
> +       __u64 inaccurate;
>  };
>
>  /* The alignment ensures 32-bit compatible interfaces are not broken */
> @@ -45,6 +47,7 @@ enum {
>         ALLOCINFO_FILTER_FUNCTION,
>         ALLOCINFO_FILTER_FILENAME,
>         ALLOCINFO_FILTER_LINENO,
> +       ALLOCINFO_FILTER_INACCURATE,
>         ALLOCINFO_FILTER_MIN_SIZE,
>         ALLOCINFO_FILTER_MAX_SIZE,
>         __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> @@ -54,6 +57,7 @@ enum {
>  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO_FILTER_FU=
NCTION)
>  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO_FILTER_FI=
LENAME)
>  #define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO_FILTER_LI=
NENO)
> +#define ALLOCINFO_FILTER_MASK_INACCURATE       (1 << ALLOCINFO_FILTER_IN=
ACCURATE)
>  #define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_FILTER_MI=
N_SIZE)
>  #define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_FILTER_MA=
X_SIZE)
>
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index b3d21834b61e..4fb3653cb876 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -253,6 +253,8 @@ static bool matches_filter(struct codetag *ct, struct=
 allocinfo_filter *filter,
>                            struct alloc_tag_counters *counters,
>                            bool *fetched_counters)
>  {
> +       bool inaccurate;
> +
>         if (!filter || !filter->mask)
>                 return true;
>
> @@ -278,6 +280,12 @@ static bool matches_filter(struct codetag *ct, struc=
t allocinfo_filter *filter,
>             ct->lineno !=3D filter->fields.lineno)
>                 return false;
>
> +       if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> +               inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> +               if (inaccurate !=3D !!(filter->fields.inaccurate))
> +                       return false;
> +       }
> +
>         if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FI=
LTER_MASK_MAX_SIZE)) {
>                 if (!*fetched_counters) {
>                         *counters =3D allocinfo_prefetch_counters(ct);
> --
> 2.54.0.1136.gdb2ca164c4-goog
>

