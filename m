Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0654EC54F55
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AFA6B007B; Tue, 28 Jul 2026 00:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4E76B00B5; Tue, 28 Jul 2026 00:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20C36B00B6; Tue, 28 Jul 2026 00:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 629086B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:17:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1E4C1202AD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:17:26 +0000 (UTC)
X-FDA: 85036876092.14.CF7F313
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id C903C1C000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:17:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z2equDgU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of pratmal@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785212244;
	b=Y6t25w31bdRqeW1JpRYgi9Npkh1Cgpxt9ECDx3VP8BCKSsaOKgS6QprG4nlhgJELIi4sY5
	+oAePT5s0rEfRCH4v8nI/fCmxIxMBjn3pYVDQYdQMi4BIukSVaxIkngzW3zzex7vbPFjzg
	QGtuRtmKb/BmKhhScjxTQeeSbu+GlwQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z2equDgU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of pratmal@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785212244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7owlsROYEO2ppqcE5JktBXE7Y99zhEA6b9SfNDEP5w=;
	b=FwOFdG/W98EJPqgM8pov62UpZwBawppzQ2x3fUlzsu4cgcrm5c+BMRE+8MhEfui057lJYy
	p+qEphCICmQPKJ2Wt12Z5zyly/6SR7V5JkSQ2nOAwO/jpGSJUoykiVjDzHz+jFpCdxFnmg
	wmywz96zKVscT3uh6rcAiRMrtwhJJIE=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c01c79467so176191cf.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785212244; cv=none;
        d=google.com; s=arc-20260327;
        b=qN41JSqoX2ZSoXE3Hx8iWma2Z9KRj7cfBr4kQMmCOmfxw6bhIzPZZPG+ZIsNvj1urB
         eLquzP5wMvLi5EZy3hQ3w8CJNd3dKI0a8yXtbJ6KwEFv6AwVVhJbbUTJz5REQ2uEbetn
         VTnwmZd46Ts1t7/9yJlUe3MGZRimohVDcG6LXxBnZ6C1PQnmmQrL+po4sOkfo7inicFD
         VGgK2sJJFyDb7vLl+S0b/a+G3bSnztIVbyDAtvMg5nh5nJmld5T0hWNANyslg6BD1k15
         ucMdiWEst9BYs1ad5oKHmeBmBVNL9YhDNi03erRjGhpB3NToyJrquu2HaNtZVPEzrLD3
         Vhng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X7owlsROYEO2ppqcE5JktBXE7Y99zhEA6b9SfNDEP5w=;
        fh=QC8VTVCOtmYlMfaObGG65W3at9UZK1ryUgPjZkWR4qA=;
        b=VKcSH40zoRzmzzpUVXvAURjKytiKihXE+IeL2u0vgvDJMbOiGHf1uKhdtHVsLtMQKn
         NVXbtD8HucCN9NhDnQb9NFWIUq6tJZu7TZbUHBLlhv6F9auEaLjSunr989G2ZgMK01A8
         /6zlcfMn/IfO0F1KZeTqkkBMs0yq2dR2EoFO6k+6Vay524oJPLiTRgRtamIoUh+E9OBz
         JeQZaMY3TBRd2jhgIVP+lrrCa4P/TOnEwUIAo+o8zeLEKKCrrgFoQTP2vZAbOIxUhTab
         z5F1zpVobMi04AKfTO0eMmCkeXdnnXCmwf1HHy29q/aNTSeC2OhhCq05qXht09Urs3TT
         x31g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785212244; x=1785817044; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X7owlsROYEO2ppqcE5JktBXE7Y99zhEA6b9SfNDEP5w=;
        b=Z2equDgUb7W1Lq/dja0RnLPTwtbivbFTxLHdggOTTOcfdYYLuhUcQbxPnZzQ6BU6QT
         eqVEpg8wHDuZ3kwrQOVmcoUfaqfE+c14j28G6WltrqV6gzCS2Hu2rvPsKoh5Fhg4bZQ+
         O0qy55cFZT1mxdzzg6eIlp2IyFEwi18WLVKVNsiUv+cf1tJ7CEysjXLSoF3jaAJUsOzy
         b9lA6t98mhw+14MjcstzP+OKVgv82pzdBzPcgCbe6pCLqzbDreSEqB5Qs8oNUzaEocke
         jLNXuEVz0NMA+Mdg8Ak0jEkP4ybIcEJtgmX+9KQgIl4TXTfuwPJCurar0/XdKqPHpfAi
         OExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785212244; x=1785817044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X7owlsROYEO2ppqcE5JktBXE7Y99zhEA6b9SfNDEP5w=;
        b=YFnYXG1M5HtMqMypWvggUFm+LLtt/+Egdbg1LxZzpsxQWJZnyH1I4kKlBw3IgV23P/
         ZeXLQD7xK2SGjU9t5YQ3c7WrY6l933DXwhYO518WKqCuFgW1YlC1K8p8WxDLPiXdAZtV
         WI4XMvtn6CZFVvb3J1bFOhLUE0Ni7uI/pP1lD8Aq5mvzbKuL/L+TJ38YhkxdDnlfdfY4
         rS1QDliB2FX+EzMME5ngaViG2P2l2BmYjU4ucv4PqqNNYkrHMjJD9vNgCUBLk9ouqU7J
         Wg8yr+Aq7WvOg9agZxb4JKBAIvrwdLu4+L0m2zG9XeDnzVAuAT4Lan0bjtdyG0okXjL9
         YahA==
X-Forwarded-Encrypted: i=1; AHgh+RpdgpcSPT5QO6JwwpcUleEeLoFwbbEeE0tao0uDyBFxzEDajZZjOXXVlncmjaqQlIzTOnZnecmfYw==@kvack.org
X-Gm-Message-State: AOJu0YzeSQN+O2dj9A6Ec0d5LVvL9PIjCKoXEouUkfbu8a/ygJe6lg2V
	iNRyyeAZv9enhhQaaUUUMUGAtqkquH8IDBzbamGFD+Yxq1SQyQpXgpEmtXEWvQGtMztx4r4Y40U
	LyBw3oiC7aPRnyGaNtbJxDSOWHtxV5BsFnkLShjOU
X-Gm-Gg: AR+sD10YGCmP/INkofwe7FHM1lZomnQLr39gLLU6gUqQFnXzrQQZdI+q/Ry92jZ9HgT
	rCy4SpXHf+8+dVoM38xgIP88FcFlWCFUFvbDG1YcOEE0dUes9lczePvmjAejWaEuFx6l/Past8f
	wf2P+lGST16rWDqobbbOnwbOVSRI42dXK8p8JSqgK6Tom0kks4ZKi49w5okSKcY/uH7Mq9hqjUY
	E67sErbdtySu9GoUiDzeF4bkbwDB8OWlpfuH4IuRHu6207SLUvDD0Vr2UwuTqpNl3wrih6eid3r
	yCvgxxYdQRxwS3l+Rzut9CCLdia0
X-Received: by 2002:a05:622a:a918:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-529a5e72857mr44867761cf.8.1785212243268; Mon, 27 Jul 2026
 21:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260727230545.262579-1-pratmal@google.com> <20260727181355.481ebbe3b56425a760583f39@linux-foundation.org>
In-Reply-To: <20260727181355.481ebbe3b56425a760583f39@linux-foundation.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Mon, 27 Jul 2026 21:17:12 -0700
X-Gm-Features: AUfX_my12pzfxR6i1DbR2p-Q0yOHOYoNyurKaQ5wnjrkhicLdqFaVTbd0DtjdxM
Message-ID: <CALHaPKf84wq3E3ZKa1YwO4W-ZP7wO+StaYEiZieTPMwS8cCvvA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module parameter
To: Andrew Morton <akpm@linux-foundation.org>, sj@kernel.org
Cc: vbabka@kernel.org, david@kernel.org, corbet@lwn.net, 
	skhan@linuxfoundation.org, anshuman.khandual@arm.com, gthelen@google.com, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Link Lin <linkl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o33i71ahgjmmx9pbf4bwgqocjbs5myw6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C903C1C000D
X-Rspam-User: 
X-HE-Tag: 1785212244-917021
X-HE-Meta: U2FsdGVkX180GXqwpeN25iHoioCq+TeV3TMOGL4Bo0YXE7Ln9Ylt/SVthI9B2xv9SZf9yREyY6YwDlj+oSv+zSJRatqs85cX8373KxWwKs3fJdq65la62RSBerQ5iqCDa4hMuBA7ATHdIYDHCPcM7BxyhR3teKXyGA1K7KfUJjK+NVfvDqNV1jq907XYV4zLr9UmuxsuRnwBpAfGj9o0OC/k8PGMAkKoxn3x5zWkLuEmclXKSxIeoeFU11riEqjPyFc3ITculZpEvKB2cgnb3334fJdbr+y5L6C8uVnq2jXuO8L+2re5lRhEDB8wla7QEkmGgLnDNoL4Yhg3OpBsrQ2tGTJGlmneTIyRiv3kzC+GttXAfgZNZYKVzpPW3o+w+gCmqdzt0cSYqKXPg8GnGhreHf6lJta9v4HYog1/yZhFG8K6mMc4RpvRdixwd0+j0EozNfyW/m3v8UXuNQ/jYK9Gys1TpQw5Jw9LNpnMFEZ72tNhg3ZesWhlbhbXoTbinGGDp/ZPkSq0YELvBr+XrG6pmSGPOL5sggrzNz8uyL7xVKP9medmakScfVDkUopOzYbqfOkhruSYtUt42BUy8iDhirpQVs+7Sd52Uc+Ss96H6xPUafOcxLKzoJAYw+uSMyPfUjdAFvABPzH60JlV73JNMquTlpUuILVyIKIrE8/sgYfNI6T2xmeGxKwQjyagzjiP5LB7QArCsnvX/5Vm9GIoXFBoX6AWzkyiOlCD/3CFK7zfKgg2iw1eQxHVzzzsLD0e9gz4nXpBgdy6z7F3ORwHoqrWbpbR7REnEObg1Fo6g2ISaN7D5i+2IJCJWrvg1ErSeu1fwD++Ponz0Rom+btdx/xozYDhMYymcIIT+WuHYSJUb4ArGOTcxEngjmE4FE4uSFv5zt+5UbVzQQV+xauofX30nE/rneip14ct59EvYfb+fVdDj/5Ly+aYiL0cyHAOY/47sgOONwz1F4L
 MuC5ZjYI
 A4H5r4XvP8G7HAx8t+2ozRugvEmiEsgc6YwQjp0NwzPSr9X1113Y8huq7vFb5n636A6OWFkehGjyV7tcqZGMI/z4L4l/pR69YhEsmz+9maSHGBfkav0k+/aNeV8yCg57meTFMGVqHGoQYgCWZ6aVsj9HzWx1FF+YrS54NxbdOY3sXGBljnKKrgW8/6Eif/dmHhNNLMrmPY4Jf+sDb/Kud38lgcvQ56dppy0QOLfDA1hK2lYCN5f9W6FAgNdqy4yYtIOZt7o7j+fec0R2o77WThykmLfYhH7uwTb39b3N4VGrJ5Fex5NWq5QQQMG2LaXZjZL/CGrtH0YZcFYEvojmjftImP+lAzjl3yEjcmETDj0U+WUvJBKF9TTQcqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Of course we'd prefer some sort of self-tuning so the kernel
> automatically avoids the situation.  But the user's expectation that
> reporting occurs at a fixed frequency messes up that concept.

That's definitely a good direction to ponder for future iterations. :')
Thanks for handling the merge resolution.

Regards,
Pratyush

On Mon, Jul 27, 2026 at 6:13=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 27 Jul 2026 23:05:45 +0000 pratmal@google.com wrote:
>
> > From: Pratyush Mallick <pratmal@google.com>
> >
> > Currently, the free page reporting uses a hardcoded delay of
> > (2 HZ) between reporting intervals. While this is a reasonable
> > default, it lacks the flexibility to adapt to varying guest workloads.
> >
> > A low delay allows aggressive memory reclamation, returning unused
> > pages to the host as quickly as possible. However, during spiky
> > allocation/free churn, this immediate reporting can lead to a severe
> > performance penalty (nested page faults) as the guest re-allocates memo=
ry
> > that the host has just unmapped. In these scenarios, there is benefit
> > from increasing the delay to batch free pages over a longer window,
> > absorbing the churn without hypercall and re-fault overhead.
> >
> > This patch exposes the delay as a module parameter:
> > /sys/module/page_reporting/parameters/page_reporting_delay_ms, measured
> > in milliseconds and defaults to 2000ms.
>
> Of course we'd prefer some sort of self-tuning so the kernel
> automatically avoids the situation.  But the user's expectation that
> reporting occurs at a fixed frequency messes up that concept.
>
>
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Document=
ation/admin-guide/kernel-parameters.txt
>
> lgtm.  It conflicts with Link Lin's "mm/page_reporting: use
> system_freezable_wq to fix UAF during suspend".  Easy resolution:
>
>
>  Documentation/admin-guide/kernel-parameters.txt |    6 ++++
>  mm/page_reporting.c                             |   19 ++++++++------
>  2 files changed, 17 insertions(+), 8 deletions(-)
>
> --- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_reporting-a=
dd-page_reporting_delay_ms-module-parameter
> +++ a/Documentation/admin-guide/kernel-parameters.txt
> @@ -4813,6 +4813,12 @@ Kernel parameters
>                         Adjust the minimal page reporting order. The page
>                         reporting is disabled when it exceeds MAX_PAGE_OR=
DER.
>
> +       page_reporting.page_reporting_delay_ms=3D
> +                       [KNL] Free page reporting delay in milliseconds
> +                       Format: <unsigned integer>
> +                       Adjust the delay in milliseconds between free pag=
e
> +                       reporting intervals. Default is 2000 (2 seconds).
> +
>         panic=3D          [KNL] Kernel behaviour on panic: delay <timeout=
>
>                         timeout > 0: seconds before rebooting
>                         timeout =3D 0: wait forever
> --- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_delay_ms-m=
odule-parameter
> +++ a/mm/page_reporting.c
> @@ -48,7 +48,11 @@ MODULE_PARM_DESC(page_reporting_order, "
>   */
>  EXPORT_SYMBOL_GPL(page_reporting_order);
>
> -#define PAGE_REPORTING_DELAY   (2 * HZ)
> +static unsigned int page_reporting_delay_ms =3D 2 * MSEC_PER_SEC;
> +module_param(page_reporting_delay_ms, uint, 0644);
> +MODULE_PARM_DESC(page_reporting_delay_ms,
> +                "Set page reporting delay in milliseconds");
> +
>  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>
>  enum {
> @@ -77,12 +81,11 @@ __page_reporting_request(struct page_rep
>                 return;
>
>         /*
> -        * Delay the start of work to allow a sizable queue to build. For
> -        * now we are limiting this to running no more than once every
> -        * couple of seconds.
> +        * Delay the start of work to allow a sizable queue to build.
> +        * We limit this based on page_reporting_delay_ms.
>          */
>         queue_delayed_work(system_freezable_wq, &prdev->work,
> -                          PAGE_REPORTING_DELAY);
> +                          msecs_to_jiffies(page_reporting_delay_ms));
>  }
>
>  /* notify prdev of free page reporting request */
> @@ -337,13 +340,13 @@ static void page_reporting_process(struc
>  err_out:
>         /*
>          * If the state has reverted back to requested then there may be
> -        * additional pages to be processed. We will defer for 2s to allo=
w
> -        * more pages to accumulate.
> +        * additional pages to be processed. We will defer by
> +        * page_reporting_delay_ms to allow more pages to accumulate.
>          */
>         state =3D atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDL=
E);
>         if (state =3D=3D PAGE_REPORTING_REQUESTED)
>                 queue_delayed_work(system_freezable_wq, &prdev->work,
> -                                  PAGE_REPORTING_DELAY);
> +                                  msecs_to_jiffies(page_reporting_delay_=
ms));
>  }
>
>  static DEFINE_MUTEX(page_reporting_mutex);
> _
>

