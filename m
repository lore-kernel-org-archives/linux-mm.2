Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F412DC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 20:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82806B007B; Wed,  5 Aug 2026 16:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33206B0088; Wed,  5 Aug 2026 16:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22A16B008A; Wed,  5 Aug 2026 16:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66E496B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:13:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD2F01405C0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:13:36 +0000 (UTC)
X-FDA: 85068316032.01.5D059C7
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3E77160003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:13:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LvxVqqp4;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785960815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADCnc/FtBR+Yt7qlq3IfA9GY1QXXiS1r22j7WPvZmf8=;
	b=N3etYfwz/GH1Gyq4AJPIYUZbMRDF+pKlOnIZsiSyi3o/VP2uEdG2QJy8928/GU4K0UkXyK
	/FNp7xsxmolW0p90NPwPGKHgKBOWraSyfAgApGhW6xzQkFNrNaHo9muBYnC1Uc0qcagRyS
	YAeo5djnZZIf1BxRRZzoWXekhJOH0oA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LvxVqqp4;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785960815;
	b=eZRMm12cxGbicOLefI8x+RJowM8qu/KzD7yJVJfW3bz+jO31ac9FPsrhNRp8/f65XaCBwq
	N/obs/Lv6lYM4R/GhvV5JNxJxz0AmB5Qrx1nnmXNN0n/hhHJnHZ0ylio9YY4z5WwaNZZwk
	pWoXnx0TfRPV8s/B87WYcT/x1x7exjg=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so10091cf.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 13:13:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785960814; cv=none;
        d=google.com; s=arc-20260327;
        b=AsGCs5xluosVBc675m1QwzwcZ0RvWCBk2KjRkkg3HdQvu3WmfQ88ENbDMK+pEkiPov
         MsiaIqfD+jFiL598WZQ5z+cs+Ky3PEPHKr3Spx36ZDIu35sqvwLsnkGfVjSTGBIALQtT
         lrWFzoTtMSIO+5suZkTNs7o4t0E1kDAyk3T99TSTGdDTtAPC2aPulvuEWsg+p/wFLBPP
         ZpM1vTwJPjW6P1kebH4As0n0khybO0u14yNQwXCvkEKA/AtAvyJVkkegDELx5SPsyWro
         QD6xJ5Nj37snqZoJeVplHLamJJxveSpVq2H7ye1OZNXoJKHTkPwC92yKaM4R6yb8L7Qb
         hgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ADCnc/FtBR+Yt7qlq3IfA9GY1QXXiS1r22j7WPvZmf8=;
        fh=vi0j14fsiUHRmllI7VUsBL1O8ZRJo9XMPBg0vxAaVkU=;
        b=nMpvKX4Pz5hNV1JggenTTOyWfrMZ2kntk0pLmHL0juP67gXAznjBF0EGhyEHJX53X+
         OdvAJ/7nYJCHV8vhCVh6oNxSf+xJhslLlSBfcWcyXoCFltfhumAwuK9Tqv2dewlFKY+M
         AUyaSq4bXNpmTTNHWbB9lFW+lVVeW0oFD0pK9CwSoqIdWtnf2mzS+rHLIL7vEC7I0Fy2
         o3GE6SRgnn1qwD2T/aTSOFIky6AWSHEyIPxhiBEDorHn868wBIra4IfArl5VaZ5hW4CM
         lXucPUtHipXG0u5nfnoGrfaHDep/An/FJkrL+47pyPNOG25yMIkq01BRWCbNYsCqansy
         n70Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785960814; x=1786565614; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ADCnc/FtBR+Yt7qlq3IfA9GY1QXXiS1r22j7WPvZmf8=;
        b=LvxVqqp49cP5RcTzdBiPq0BywawSKvawWO4O4cETFLdEQHn9XZge94nl1CuljuwJbJ
         tQeM7Zx79/RudhZGEiruOqGmGfzo/NxXDALyMdeWHtJbTXVI08RakXoyMqYyqpPtx3wK
         snYkN4GXbhSjBbg5PAIp9Svi9SFqef4PTLeSFEstAE2z9BxEzC8nXYujpmLnPNistSkQ
         KoYuv3ZukynWNPa/pyzbk9OipuTv5n5sOEeOgFKhk+uwlCwo+Rup3Q8558/DA6O9Ms6V
         rXb/7BLh11TNyBq2VEZnwH3HnF8q8v4ThF7RjVor9B3au7UrxOGHkHFz7EOo86M4Y9fY
         5dqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785960814; x=1786565614;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ADCnc/FtBR+Yt7qlq3IfA9GY1QXXiS1r22j7WPvZmf8=;
        b=iJMovb65mnAogyIVvOjkSF2xHlWIXyN3O0/JWH0l2cBFHgBligOezcHWmCD9X4ERru
         f09NQRi/1rFCLEuoLv2WE4gw9QGhUomHgdFLqOzeodxZo3n9RVm7T5TvYsPMBMV010rP
         K7FGBGw/6Qwfqx1rEDXemhoPJpL2Y1mpkNvZipnHD2hu6Z51PZkf1euBQldcis7DUsG0
         EW++QaVUW7uLzoXPmk/YiauxbR8OUqteYZl0rVwhXoUyhSeyVC0j6ZNO7CeHcMtgGuOj
         L26R+iiM8vsuVicoP0fLCvMQj2/CiRQsVVEhXeUk4kWjs9sBTiDrKnfoIbpmzk5J1JWP
         sv/A==
X-Forwarded-Encrypted: i=1; AHgh+RrYitXqOH+Qx2iaXhS45/awHS0xkPGaa63Y6cFP+Nlg1tkfIFrx/aZkj8WxOCMT36F3u1XcJ+a0OA==@kvack.org
X-Gm-Message-State: AOJu0YyfkeJvok6TWxLHAsHR4NOjtd+c69lm9MyVvJrIJHJ0x6agSh/F
	fP7T+9RApxw3diWDgVUpwZhhsbhMdDTaFlrOLHpA866n7KUaJQU9PkUWrmKqiiPG2QFbnkH7ngN
	YP+AmroXVdPRYQfePyB9gxQYLD0SAPe8I3A7NDwqMLD6h/YrKC1s+Dqzi
X-Gm-Gg: AR+sD13Akk8uhqtSQz23rMapSgADHPXOcWCchQ+IeEGvuAAvks0Jn6qku6xS2kbIsxW
	/uwIkG510qi664hXu8IDz77PZlrlk+4NosKCNENJKW8QR+z+z2mpHTeVsaFrEtwL4bMqsCJ1/u0
	8zu4JgLkKfiygBg8s75vbA2N+3vfnNwyG1G62SF0F6kbfK9f91u8hAhAiUsUeDHskWfQbIu7KIZ
	EigoKYTcuQrHe6s47zqca55cEx25RSbHYOS6DD8seF1Rwyy6cIIC8tENxkF7l3aXN+OgVQPvmXv
	AgDYOah3D8Tg8iEBv8qK4bL1Tzy2BwOEHkdLoeTiwr95dtm1rY7v5vYPGyfuTKKkbpr0tkCl4Mo
	=
X-Received: by 2002:a05:622a:9ce:10b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-52cfc0cb726mr4580321cf.9.1785960813363; Wed, 05 Aug 2026
 13:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <c795f8089f82841e8a6e00d7ca286da2b23aeb7b.1785950530.git.abhishekbapat@google.com>
In-Reply-To: <c795f8089f82841e8a6e00d7ca286da2b23aeb7b.1785950530.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 5 Aug 2026 13:13:21 -0700
X-Gm-Features: AUfX_mzf39-bsRwpGcBa3cjVj341l4DEa9qZWVyKWwAe4bbPf3pd4npdn87EHqU
Message-ID: <CAJuCfpHn4wkRf97TUUBW5Kr2TbtMy4bn=54VubRFo_b9NSMR2g@mail.gmail.com>
Subject: Re: [PATCH v5] alloc_tag: expose boot-time compression configuration
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Ge <hao.ge@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7ieac4twuhchnebjdf38wwqzeucqx3ue
X-Rspamd-Queue-Id: F3E77160003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785960814-863442
X-HE-Meta: U2FsdGVkX1/gjqZRJbt00pj9NNNjAyi0B+xiF8B3kANoreee3Ia9wBrG85FYejaIE7SJN33H+juT5gTkGKY7PzT25c3XvMzRY5TGhoipgmmfdXFC6uCG/D7R/HO8sZ30+kCtS1ts0k42CTTHJ6jtBA5U0dqxSV6Y7AqZksBqJfu3cRNzHRZ9+eF2rmFQ+b5bcZU5Q2nPoSjqZPhES0WlmbKxZtfBInq6TpIbp5isZlx7NKGcjLZEw1JAiX2nVEjxdR1HvV4u7ywrK37FEJqUO2WtOZzcDOQW71IuxTdQiZO7I+C9L8K5ouduFo28e5iCy3rkioh08PrYochOxxirkYDpLmrOrzjiz6wqk8XCmKaPXF5FPzkM+fXchQjmdPWewCYAhyezB43NFZK/Jmu8mUphJjNBHUVoYjU9fSwPLodQupPN07YYKWxqr2CMf/b5STmjXdpluwFGuMJBrFD82I8M7lH/vewoL08sUW1JKAYD8sDdzg3ZuHqaMb+ssPSDu2axksjqpKITeN84DptjDptdXpstSGbkSh4VSbLm/5LJtT1BhsbP8vmwiruD/sYuJCqjRxIu04XQAhp4ZY/nkcK1T6KsLp2Pae+zC9FGas01qzoZ4hwCBr2G04GW28Y30+dQHNsTF92l3xPeHAkKFsNX/dJAhYslowbHK0g0/uxfNMRpSplcsej1gsLHbA5EuWfJtteYyYDD77wanY1O8gP7CqNPHDFy+VaD6W74JwTJojY192L5DMpB4V3TBiqTDXorGekmSc9JCQsuv15LXpI7C0xgwZ2TUxL+upk1G3ALNXS+oORwYZWegaPd/4T1jx0rC+WkK62dC/db6d1AgabspzVKG0kUTRqg5jU0++gI5a2BYc1be1xXQPlMkBAxVEOXdjZvVbX4q3HnLs2O9V1UPZsmfRmndy05B7H9H0yUiYIwQSUqiVOo4C26Q1gBAYPc1aeyTu1jIWPNRIU
 ssSYDk9k
 FLKK9oSjBqfe2OjQh2hxWBgWvf0Zbfo570tfyfybk0bZgi0ufIIT/o1++euP0iIFaV+YsktaHwV3iRbvcSaUFtNInyyAhp863qT+fc1Q5mtJpMq5wf8WRMF1UAf4aA/7kJAB0hJQ4QuTzI9uKsrYq6+60kAEb54Qm9DIjh+Zg/MJdfhsH6FMhkhDgJF5Xz6/7iO7YcSfeP2GHIsAaCd5dcxuyPH+YfLSkm5A8rMJQnvAK3MPuwAM9NoPS/jowtmUCcn3buebljsWWzyL/VAWNYxReVCxQWy8Q6SamG8YlaXewWOGcCuGc1REmyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 10:29=E2=80=AFAM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> Currently, userspace has limited visibility into the exact active
> runtime state of memory allocation profiling and its page extension
> compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
>
> While reading the sysctl provides basic on/off status, it is currently
> impossible for userspace to natively determine whether page-tag
> compression was successfully enabled without scraping dmesg boot logs.
>
> Add a new read-only sysctl representing how compression was configured
> at boot time.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
> v5 change:
> - More documentation and commit message refactoring.
>
> v4 change:
> - Documentation and commit message refactor.
>
> v3 change:
> - Added documentation about the behaviour details of the new sysctl.
>
> v2 change:
> - Moved from displaying the state in /proc/allocinfo to a new read-only
> sysctl.
>
>  Documentation/mm/allocation-profiling.rst | 11 +++++++++++
>  mm/alloc_tag.c                            |  6 ++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm=
/allocation-profiling.rst
> index c3a28467955f..b2ebcef8af6f 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -43,6 +43,17 @@ sysctl:
>    warnings produced by allocations made while profiling is disabled and =
freed
>    when it's enabled.
>
> +  /proc/sys/vm/mem_profiling_compressed
> +
> +  1: Page alloc tag compression is enabled.
> +
> +  0: Page alloc tag compression is disabled.
> +
> +  This reflects a static boot-time configuration of how page allocation =
tags are
> +  stored (in page flags when compression is enabled and in page_ext when=
 disabled).
> +  Toggling ``mem_profiling`` at runtime does not change the state of
> +  ``mem_profiling_compressed``.
> +
>  Runtime info:
>    /proc/allocinfo
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 84c5c3783ca4..b33410310477 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_pr=
ofiling_sysctls[] =3D {
>                 .mode           =3D 0644,
>                 .proc_handler   =3D proc_mem_profiling_handler,
>         },
> +       {
> +               .procname       =3D "mem_profiling_compressed",
> +               .data           =3D &mem_profiling_compressed,
> +               .mode           =3D 0444,
> +               .proc_handler   =3D proc_do_static_key,
> +       },
>  };
>
>  static void __init sysctl_init(void)
>
> base-commit: a946fa1d96648b92c9f37f0488e0e47a85f9e235
> --
> 2.55.0.508.g3f0d502094-goog
>

