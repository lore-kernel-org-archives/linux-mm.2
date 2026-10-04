Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470C1CA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B586B0093; Sun,  4 Oct 2026 13:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633466B0098; Sun,  4 Oct 2026 13:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548326B0099; Sun,  4 Oct 2026 13:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB1E6B0093
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:55:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE1DBA76BE
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:55:27 +0000 (UTC)
X-FDA: 85285695894.29.92F03F4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id C065B180002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:55:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sn9mxue4;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791136525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFRiHWm52m67lLPZ4QttIFc2/s9ESzUdGTCBMadUb1o=;
	b=DP/26YS4HeaOsTOOnkcZpSSSiRwGcmoV2r2wjn4LLxoNtcbV/u2lVwHV3Xmi0QsEhlHIBK
	gg2eoUQFtNDMy5U4POMPJCwXjKtsgmvZ7hidyJvWSzgIt4IFz6a/kWjUDLRhjYrsd13wNK
	kBUubChq9CmnIgySPPNRpYic9mTNSmE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791136525;
	b=xHZuqzMOjnECh1yA/IaIUnWMiOTcTc5hYrUqV8BDufeJLPPFZ3L4T2D0hAMrbwjW30bqII
	ZLYaVNePvispKBQO9PYK3yqCTICZfgg1DitWKCW9CuHfZIs/cLtIWMx9klpvB6cX0c9t58
	0ZkwXhAy8MabCz5Fo+zuh/1uYrBIDEA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sn9mxue4;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5351f9dbfe0so98361cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791136525; cv=none;
        d=google.com; s=arc-20260327;
        b=UPdK6W3bBd9ADlam1p8ooCPvxLWfvAa0lINwl6ZHxqAqmGsIDjmEWTZKwS1P9AkkQo
         aw5i+KNz2SYefmIN/3uz9CvoXvEmaf664Wm2I0uHJLkOpsa/EUaDRqJlzxPnyxrpsNpH
         7IEyGKC9DxM3WGZvMZ/xo0/XEnLfQestrgz8auuvmK4s+41AHbwtyEBzCVoDEmsUOOPK
         X6U0zWyn/IjxFgjCS67oijpHANTUfv9uBPRbq6VCBpAkqUauGm3uEHfvkppuX1zdPDU8
         zKkdGQs59N9QEGNCtfo6MUZSi90SpX0lasIhahyTzg0TvJFKHMz+4UrZZI5Bu5Vlco9P
         w3Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TFRiHWm52m67lLPZ4QttIFc2/s9ESzUdGTCBMadUb1o=;
        fh=0MLboac2X+J+uYtAVltxKvu8qNjWiVX/Hd14ub3JAmc=;
        b=BzTupSmAptKxHl+HnMnKzZRm0nI/CmsuE6OPsqs3X8ltobh7ga6+TIotXYTRy3F46O
         wM+GaHh96CbhV9t3wtxChi3tXkzr1cBQjyOHOC0roEmDglMC/Jx8OQsc5LVRubyzXady
         lemIqSQumQGldyWcDJb8xgoDB23juceFwbPVoyFRmK0Cb8/V7WONH/fS6xhAHzA/yp+K
         GhUUjOXZHsmJ4ZZeu4r/+TrZbcpPY/NXPIiB3Kz1gi0Po0Nyk2ZeSk9buTwVo2ednGxN
         EJAtHJks0O4eKTnXocCeIRR+1PsYHmqIRsTu4275ft5DnQ6MPDX7PM0HNhrhTqTtyaQI
         vPEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791136525; x=1791741325; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TFRiHWm52m67lLPZ4QttIFc2/s9ESzUdGTCBMadUb1o=;
        b=Sn9mxue4PXG3M9Y2VgPWZkQqnYfbwdG00e+/gpHMIM5rkaGEff0snVpeEhmA6fpcPa
         khYOfQ603xTYeCx0F1unKXet77bQ/kDAqamsQY0tQljzHlOTsmdJ+dDHjEZfSvJXQcH1
         AZW67DqPUBz3CcLe+eI+7QsWaMujOv2d/jWmyeqXEEBeqgOdprAWjAt9bX84nG+wZ5UW
         GgBiGhI8Xa8IbWR9t3p7GecYtXnsUyzqYoVJMnxdRur1vM7Ys9/b2T7R9SKeHtkTKMxl
         0Le8zRH5emDyQ9ntknCkI6nGxc25y3BPWXHFKFwXXLISQoTsUbzqtO+XvioTifM3rOf2
         FpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791136525; x=1791741325;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFRiHWm52m67lLPZ4QttIFc2/s9ESzUdGTCBMadUb1o=;
        b=BYQAj4dv7e9cSjXiWQEDKONwMG3Ba4wi9mgVsItaJnSt7sChmNnVPqDXckHUKh7hM9
         YEh/+iH1E6n7/qMfupKGBe7/JZCI+rH4vYs6bfpBwU4RE/3HNxCfTypW28ktIb+1/jWw
         bqR9AEXJQRLAJIJ34wN8cpFlj9Jkc9XiWaL8tO8AmdayT8uSrJ4wTVRQdEOHShAMO5iB
         ibbsuOMbzDaA7TlDyEL4vVYDxDiknovl4WcBi6/hC6D1YcFJNlrfnQhWjFX8q5WP+Q8b
         NZ+whvlB2PNKh9XT0vNxkfabBQo7Xk46+G9Bj1LfiLczI0UjdJ1t4uXmgWyuzSz5LGMi
         4rqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlHfn93EF5sB9sWHccYFAW8hgjrk41OTdU+BjxT1hZYnUCORcChm42so3uG67Al59WANc/5LQn/g==@kvack.org
X-Gm-Message-State: AFuF++mJ3JFQ2sm8xl1hYCm4Xo6n5yeF7IbymZtVeojWAN2ngtNV3DfC
	SiNtBr5eny2ClZ4ZcR5x+8mlG5HctlLVRL2SDaSLn6ZTeJpWI+pVtUbvU9NHMU5jFpkt3Dn7MZS
	JTmSW3cBUsTEIURU2VPEPtqDlsIc/9azIefpAr649
X-Gm-Gg: AYBFou1yomxxsIrHF/eZC6LWixzVa67L5nyeIw71N2ReJ9QMuEcwHLG9MGc97Dy/sAi
	TPx4jJMl9RuXibKMe78MUE5EARyIVyy+hm0pdV/ef10iN514Rn2t1uU33E2cEFOKUhdP7jBVQfX
	ZwH7akAxF9mCTWISqZkDxgX6YPu/E7gOCCgbKF4Cy9avZz6qtroAKVg66sDew66ZeP2zJxtNYlv
	BJb+JG4mXmgB0xnSMOu4OIMNUrRl07XxzYEzWPM2AS+bGSaPHWdo3XBBy2ZZ0+dhlaxMqpdgmRm
	JwHjK13sMVP0HfF64MXWrUMvaL7AnZYNTWY5iGLa14HObGhLqRiQL4W9iYVT55trQfU=
X-Received: by 2002:a05:622a:191c:b0:532:9003:35b1 with SMTP id
 d75a77b69052e-535146541aemr3824271cf.2.1791136524268; Sun, 04 Oct 2026
 10:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260929082014.160587-1-hao.ge@linux.dev> <20260929082014.160587-4-hao.ge@linux.dev>
In-Reply-To: <20260929082014.160587-4-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 19:55:12 +0200
X-Gm-Features: AclHuK9GuJ1R4AG2eys0TOfTlndz5Q1KT7n5Xy5IteGOVBALshKC8Ehhj3tDVOw
Message-ID: <CAJuCfpHXT41Y3N70xOF3MXtZm118-mR2DuXP=vt1M+TuMG2Uqw@mail.gmail.com>
Subject: Re: [PATCH v11 3/7] alloc_tag: clean up the populate failure path
To: Hao Ge <hao.ge@linux.dev>
Cc: "=Kent Overstreet" <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-modules@vger.kernel.org, kasan-dev@googlegroups.com, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C065B180002
X-Stat-Signature: 6dr8j8xgugfizrd6ukg4jt7kk5n1sbsk
X-Rspam-User: 
X-HE-Tag: 1791136525-145015
X-HE-Meta: U2FsdGVkX191AtJakp4lh6LI5Wd5n2S+jZDCdSknH6yOHF7qYnAoO6+tV7dQ+bIN/cdmn4hCh6pC6ueWzZcRw9PSwcXENfpK5zchECRtVW7RMMQJ9zGPhXT5nrXXD0O5vIBKmGcJAkvuDEez6ScMdsqB6ZuBmJqr9ggHjaaZWc0GAoNtSRofTyvOQQVzRosAVfV6mgigmGBIygxLkXkeRgIy2VDXoBhnEvsgyHczccghpARSUaQhBem6ipcfTYZdhZ91kenEGUACsRRr9uGUer/OXsp4L2oJw702mslZpOPOaHyVKZ57gMFN8FnB/E1Z8fvQJ5YRaOyqy6OQQbTQO2bK7pLhBXYsefE2qvFGRHZEl9YEKVXnBCCloypPyB8cETwwKqFjr5Lk95SyPylptYsvki8snD3XQIKp5MptCw1FLJ9maumw2TrycAKVOI8oKyyBHWFP4je20JaKJh31289gNDq+/O3TqpMkZ0yblaMYXKF3DHrMTAsbZv8RuRcSuDJIgPG2OaMiaQAJpUvKrJloKIFCq7nqWwKc2oA49LJZ+xQE31o7DDg4miBaa8rJbv45ok3xvtXaScr3xiu5zfhmYEV8bFxZNlEnLeamkwQc2ie4sLdn3bF7ZpAQANf2g1omxAfhi/66dRw/rt1tbksgMX7+8PQCaeNBu+FI+lSVGPt1A+uSCIVlaaZbaBJ5/s1t+LOAmFzeYbQOQq7u5E4yBwn4RKUpl3d23dYLoSj3I2fcDPfQQsvkpp/PcZzCIe8xrzaklKngJ1CfKFuWL0n1zWgFC/6j+PbM6mv4mHffDaop0oxU3Y8juZiJLLdDwTikHO8Rbw9trAZT90YNxdUcxYdxg2TqEtPkOQmjRR1QYCb6BsjsmNn+SW2ywuOTjHJXDUoA3baAQLMkaJEJz3d/7hGI+lbDOeTNACCvlYFB9NV/7obrMiQb3ZNo/KgMzBknNTvqog/uRGRnori
 dFUPY0J6
 y9WApy5gsVAn94mm0vIOQWefbxvsMfai3L3hMyerrgYIoh+7DAWBkuMmWORh/Nzkz4MvUQx/1D34h78Bt+N+Yy/j1zPf9Rj04VwgzsVthnx96uL2p9r2HPaDv6MQxobxSuzFiCpGoFfwgThjFaq5q9WOSS1CNiCwy6CA8PNMFaw/SF7vLazZk3RD396oPDzB7erJYxO32FiwRA5nSxSpl8AItsENjvQ2WVzOc9oaM8sxkpTQSxwkdt1mRk90CPPfFqwTGhVfcGfI7BMtGRCM1uvuCvo4ukE1kXQa9XLdRqiRbXxwysoH/NrOy9DfEtmOiTD6ZiUezD1qzyAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:20=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> The reservation is already stored in the maple tree when
> vm_module_tags_populate() fails. A failed load never unloads the
> module, so nothing releases the entry. Release it and roll
> module_tags.size back. Without the rollback a concurrent load that
> already passed needs_section_mem() can reuse the freed gap, skip
> vm_module_tags_populate() and write to unmapped memory.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as neede=
d")

I think 0f9b685626da is the only one being fixed here. 4835f747d3ed
contains the issue simply because 0f9b685626da already had it.

> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/alloc_tag.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 2070e682fe10..3e6306ee0764 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -947,6 +947,7 @@ static void *reserve_module_tags(struct module *mod, =
unsigned long size,
>                 return ret;
>
>         if (module_tags.size < offset + size) {
> +               unsigned long prev_size =3D module_tags.size;
>                 int grow_res;
>
>                 module_tags.size =3D offset + size;
> @@ -961,6 +962,8 @@ static void *reserve_module_tags(struct module *mod, =
unsigned long size,
>                         shutdown_mem_profiling(true);
>                         pr_err("Failed to allocate memory for allocation =
tags in the module %s. Memory allocation profiling is disabled!\n",
>                                mod->name);
> +                       release_module_tags(mod, false);
> +                       module_tags.size =3D prev_size;
>                         return ERR_PTR(grow_res);
>                 }
>         }
> --
> 2.25.1
>

