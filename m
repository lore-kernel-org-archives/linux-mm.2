Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B9CCCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 04:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018186B0092; Sun, 18 Oct 2026 00:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A816B0093; Sun, 18 Oct 2026 00:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9C76B0095; Sun, 18 Oct 2026 00:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC5206B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 00:52:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BB3580353
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:52:43 +0000 (UTC)
X-FDA: 85334526606.06.C20CD82
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40FB480008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:52:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xyx1ibDx;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792299161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/j83INDW+E0oYwL7EQYpoQA+T4KbuWW9MUJmzBfXlTw=;
	b=THGtLaVkWRg4+gNL0YY2yZKHFGrMa6p+VN+GFlYSozclOTAfvUdUp3ya1U67o1c97fP0D7
	mR3kpyIyL1A7OECzLPlXF1+6AyPW1IXa1fJiocZ8JhFtkVp35Fwm+BeEoBpocqB/tCRXD9
	ssJyd2MLa4AMt2yRlhz33p25LXypmGk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xyx1ibDx;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792299161;
	b=7Cbq6AGWeS0qgXVK/051LDuuUuf8jObaQn3PWnc19iW8rkwmVITae2np2ObHQyRR1YuFbu
	qbEZxp0elaN96XVr2J3sOYpDn2gmw9AwtuC5HJ2uluv/Czu6e3JmHk9Gi6WwtFLUTgx+H7
	OTMEducVmFcloY49WsJ4Y/W0mLd4qr4=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-533202fe429so237121cf.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:52:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792299160; cv=none;
        d=google.com; s=arc-20260327;
        b=gRk/Zj5zOmEXp9MT73z8dOOliMMGCNfBcqOzkmIvGEllckIAlAICwFTlD8ifSOAXxb
         tws/koOSMomVfa4aD84YT+HYVXUtL5YttXyOaC/MIydZ9LJIUqI7IlKzWole5MjlZ1EW
         0iImfxrPmpzrM/3rc3sRYCuUXp3vKi8S85HcpZcK+qTxjJq4RRlUCvjNFvK5dre8Ns25
         +dXLGi4FOlFETGHXRkuGNWevCljflW6CqQmfgu4XGutq8BWtSMwwIyl6rmCl6BBFfo1G
         ZKiVVsWG2KHVyZLa/oKY+SzcyRKoU7/xIMCfCtA1Qv5zYTNSFyhzsqw/pjTk9aEfMWMf
         i+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/j83INDW+E0oYwL7EQYpoQA+T4KbuWW9MUJmzBfXlTw=;
        fh=SijFgeq37n94g2N+eMLs7lI78g5n6J842n+LOfDv0BM=;
        b=NNUSHozLumlDjPkBSQKqLdk2qeiQAbCXNm8sTskjzmqkpGPYxBN5Q1/Bz0zqryUc9/
         0CkIYrOevrUy+WdY6yFi/oyupyi9uqPTpi4haUrrObRXohN0MiKMZBn5eiuFzQUmvqHz
         N5FYyz+6x3SW0w1PA20AixBSzQtw5blymfpqfpR6Fu+uBfyu80aezIxfIwWWyJb73h7D
         X4224pyOJo/+nGDqQ+6yaU5f4CJ5e6fYeBKfRyuD5jHqGGBEznUJt4wFN1XgWnrmXbLV
         pzSrKiFQgUvltU0zYqto/7/dM0LBZHbFNiEvNiJP0dIMqysJ9KaP4Nt4yM7aqMDI51FS
         tuvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792299160; x=1792903960; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/j83INDW+E0oYwL7EQYpoQA+T4KbuWW9MUJmzBfXlTw=;
        b=Xyx1ibDx0Y0pgCXKv0WRo73v0JZokxVmNNjoKPbwZSvvoeeqF50D4F7sakdKXQZFHP
         YpvNGWib+FEcNv+G1oFnvOdwCNKFVIlqkq37urcyyQuK443BkDO4WNh+qEk/QJZyEnx6
         vzhL7HMuy0+BFuCJ01AsDisA5g0Uu6YgHA6PgS8tkq9D+wnEoNhWFjTwotvUWBRcFjan
         XhJ9L8zpNdHP577W86dSQDFCy9cmPKNJ4JmlX5cAE8uVj3isagv035OvYk9th3zSgJrL
         gL6NF0JDdWEBU2vHxsWL2SVUSOqhjNdLDZRiOfBWLsxb3z3GZViNuXpy4E2I2Uc2pBXd
         duOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792299160; x=1792903960;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/j83INDW+E0oYwL7EQYpoQA+T4KbuWW9MUJmzBfXlTw=;
        b=POfAObZPQ6U7XFn/O17u+mFBMFl3TUUcxLcQqloeeWQj1085DrR0Tq7LNpn3KuxES+
         h28nQQOMN8DqQMRtFPcu6y3L3jmsNsGDahc7j4g+ekLh5R/zETfMx+9ZWBLhXoYYxmVs
         JWNwMDlam3fBguhAQznmGo8msvgCfMhYuK9RFpNjKpvmLkWNRYFcSQn3NzU0Rvj8VOH4
         +GBdgAMhEV1agldXA4lc3mZdNNQLymCtBV7EeDOwoKHPluG1KqpzEh7ujuxLFxMeYE3r
         aFF7Ox4Agg0KzOxQsHmbvct9xFjLDeUyXoJ99Ua9fElPqjImVBDGnLaQ97W4xhVygVK2
         axUg==
X-Forwarded-Encrypted: i=1; AKwUvBz1fp2G93G9+QwQd4XUmMiPdaUp6UwpZ4GtOz+q64aKzGMvebXz1NEFvRg5JK7NPG8Y6lIGxpSrKw==@kvack.org
X-Gm-Message-State: AFq9FYJotF6z4pP2byugltw5Wz0gYmZKXrZPz2W2qobppSuZMfaCbv0v
	gNU4J70jBkMDegT48KU56ThKaY+dwd9mW0sXFeDX3H0D8GkLVCRNIj7506cTu25G8GHC/spMjB4
	uJ66RRcayZWj4jSwP9GtZh3o474zpW3EAWxk7Y9xG
X-Gm-Gg: AYBFou0dBErTs+kd2H0UQWk8ouJ+v4nvL5oyO9b9e6KKLiz2J3VDYutVHO0cqy3j2Cd
	vBfLYnkUEFG3M6S8cymQtbechEzrz8IsfeyT7berYZAaf3OPGDKVD7BjIPNIyamJSgiNQT1UcI5
	N7I/bHkZW79hhqrjq/x2XTiZg6/2wZ9LdGl+cevYgclix3DIiflZUvNieKQ0KG7o6b2Uz20adLV
	V6F9hsX6so6VCbmBARBRmqK0LJKhUFeDlncomHjpxnlX2LGZlq91gplLC0pqae/E48jkPVpuuZg
	Jbbavo/I7VsVSXyjEUBlNkPI/5y1nNMOLUyUyTYCxTl0yWTuKu7+b0LzesXBUDsgx5FY
X-Received: by 2002:a05:622a:15c2:b0:534:d386:c3f1 with SMTP id
 d75a77b69052e-53646271decmr19987131cf.9.1792299159704; Sat, 17 Oct 2026
 21:52:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com> <aae089a81ea891e1bc7e3ad171064d37d800ad1a.1791410886.git.abhishekbapat@google.com>
In-Reply-To: <aae089a81ea891e1bc7e3ad171064d37d800ad1a.1791410886.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 18 Oct 2026 08:52:27 +0400
X-Gm-Features: AclHuK-Wl1wHq9C6FbkV2z85b221S8kRzKVDRSqQmdSzTuR5W-gPJA5u6SMeDIA
Message-ID: <CAJuCfpF+kVSa0Rb0pW2gSwkBF57u-JC0J6gwFk62iGUpXVNwSw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] alloc_tag: Extend allocinfo_filter to support
 tracing queries
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ojayn93benzuo46gjwdcrjuzn4furmwf
X-Rspamd-Queue-Id: 40FB480008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792299161-226405
X-HE-Meta: U2FsdGVkX1/Il+zS+GFjSZOnFjeJOZoQTzxrJqa+Ox2HhBxXBNqhjqWu9sLqLwDn01w5eWEksXGqvdm6lA4q+Vlw1mZLrzJxDLNr3agQL7s6boWjMgglQZnO67xElIjGvHZthBGfX/SHgcNGYlxaXtqwDygwLRyMlzwTWVLz/JMVIniC1SVJB9iDe1h+hS9n0esMrHucauSK6ywDx/XMj5NF0O3tZDoTYg1WCyv7JYcOHobezrNElX0OZHTnl0ZK4yU1jw1tdodsQOevXa0ivYCceH7DnADIWvUemF9xYDPBl8uPG1Gfn+OMUDrepIZ8XiSnWlSD+90BWRami8dFVVEpp77NtQ4+FEcblAfU5URGplpsAq3E2F4bmYLOnqGlRIac8i9xgNLyQ+QV4jQIE0KwPpEwocs5XY1p5r1vZbARnu0JBNyrAB++OeiZK8+k04auvCuYnuTWFzwFSun2QPWuNXaFYDeIA2EP2rgZ724qz3RhffAVqynpXzL9tWsPwaslmqzFBtG3fZOHeW7Kc1BRarbo5AXlzArUXXRN1wl3yKtCGnsbgBywxokZhkn+J5Kxvkp3gTyTPogJppbNO9pgJGbwBVDRyWkysxpZhs/xVI2a+Bfk0x0HksfylWPNy1fW2JL8vJo0tK06g01dPIOUfT8OOoBI5maJg9CdnySwlfjicOzwXULP1QoMb1w+1Ad2j/LZKfSiHHEr/7kJftrjpoUB/H349iwKuoUw2vdNKrkAUYh9yN94r0xtI62OedJ1VJFoe8Q0MvPg1TLzoljW+qZgKX7PsWMl7Wt6A8qu7qvJgzRjV4vciLgv9cytCmyz6YeaBpy4qjugi9G7UHxPyZHnQ662HSyDf8d4vdFyKeLpPlv5Ehyd7x/N3csYH2jAmK6+NEi4B+1XTeZXdRGkz3Leo4OFRu4afDV2Z2Dh8GxbiaVsAubuqktDrIYrfsNY+GK1FCcIwE/Ghid
 XVJ1bIfZ
 y0J8VlCnfF97E3YzxpPze1z8WAiKczdzN/KN8zaFQuom5L8+sgYYgidVrTi/OHrGZRM1wmrq6a7UPjrMnGGfnHrdqrb0c1fDGkjPST5yNTNJvvIzKRzZHQigGD2NbfjrV8L+jw53aK++2JSCUBPoq/uIGo5M25ZSeXPzG5ZHoWluIqfOHjNMze+t+KlBh6bJv2d435IQH+bDpWcfMj1k9GtuZ0incM8sQw7LRauep3SFEvkO43n+GK5xYgryJF6p0y+o9meBr+9eOMwxdbFlhRgNqgnF5Kisz7rtcXtJYUCrzCq9qW1emX1mejw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 2:40=E2=80=AFAM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on their trace state.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/uapi/linux/alloc_tag.h | 8 ++++++--
>  mm/alloc_tag.c                 | 8 ++++++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index dafcba2f7e2c..a96054ac2237 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -38,7 +38,8 @@ struct allocinfo_counter {
>         __u64 bytes;
>         __u64 calls;
>         __u8 accurate;
> -       __u8 pad[7];
> +       __u8 trace_on;
> +       __u8 pad[6];
>  } __attribute__((aligned(8)));
>
>  struct allocinfo_tag_data {
> @@ -54,7 +55,8 @@ enum {
>         ALLOCINFO_FILTER_INACCURATE,
>         ALLOCINFO_FILTER_MIN_SIZE,
>         ALLOCINFO_FILTER_MAX_SIZE,
> -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> +       ALLOCINFO_FILTER_TRACE_ON,
> +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_TRACE_ON
>  };
>
>  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_FILTER_MO=
DNAME)
> @@ -64,6 +66,7 @@ enum {
>  #define ALLOCINFO_FILTER_MASK_INACCURATE       (1 << ALLOCINFO_FILTER_IN=
ACCURATE)
>  #define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_FILTER_MI=
N_SIZE)
>  #define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_FILTER_MA=
X_SIZE)
> +#define ALLOCINFO_FILTER_MASK_TRACE_ON         (1 << ALLOCINFO_FILTER_TR=
ACE_ON)
>
>  #define ALLOCINFO_FILTER_MASKS \
>         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> @@ -75,6 +78,7 @@ struct allocinfo_filter {
>         __u64 max_size;
>         /* filter criteria only; see allocinfo_counter.accurate for actua=
l accuracy */
>         __u64 inaccurate;
> +       __u64 tracing;
>  };
>
>  struct allocinfo_get_at {
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 262f00f2bba9..8e63f347657b 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -250,6 +250,7 @@ static void allocinfo_to_params(struct codetag *ct,
>         data->counter.bytes =3D counters->bytes;
>         data->counter.calls =3D counters->calls;
>         data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_alloc_t=
ag(ct));
> +       data->counter.trace_on =3D alloc_tag_is_traced(ct_to_alloc_tag(ct=
));
>  }
>
>  /*
> @@ -323,6 +324,13 @@ static bool matches_filter(struct codetag *ct, struc=
t allocinfo_filter *filter,
>                         return false;
>         }
>
> +       if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
> +               bool tracing =3D alloc_tag_is_traced(ct_to_alloc_tag(ct))=
;
> +
> +               if (tracing !=3D !!(filter->tracing))

nit: Compilers are smart enough nowadays to convert u8 to bool without !!

> +                       return false;
> +       }
> +
>         return true;
>  }
>
> --
> 2.56.0.385.gd3acb90ef8-goog
>

