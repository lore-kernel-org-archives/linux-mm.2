Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C69EF8A157
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7849F6B0005; Thu, 16 Apr 2026 06:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C306B0089; Thu, 16 Apr 2026 06:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671B46B008A; Thu, 16 Apr 2026 06:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B93F6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:37:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A135BB231
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:37:14 +0000 (UTC)
X-FDA: 84664066788.26.E98D025
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28A27C0008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:37:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lSvEySs5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776335832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wlY3RSevRuq3DaBIrMyQdYxp5UuY4sfTgf8TKMIySc=;
	b=DZbUxnxOogbLYF9KJqjt37bMsImvBm8fN4/zL0xLsaMtczrQnAbrNruKq0zKTls2EpfCx9
	nhDnmyvC1EXT6ZFNDDlqm2SkkrXBvMMaCSvHi3ULuHff6Ysycf3+hdBTMCq4TPXIVD1R7N
	kePehRTs2BZP9wb+oi/3njgEln2byaE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776335832; a=rsa-sha256;
	cv=pass;
	b=XOdHuMwReefRgyz0h46srwMFDWQoOFBTmnZ8qT4Yn1KIdjGJdZwXDYVyZin4nCDG4bzEss
	Fem4rq5KuOVwzQXugQy6lgv5nK7McwfQ0921ywByO0zW9K33DmiLAromwdAmmTrAGOdtoT
	peagCt2AVu/VQ+OCqDU4OLixXP0m8Es=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lSvEySs5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7b81f5ab95fso13694267b3.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:37:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776335831; cv=none;
        d=google.com; s=arc-20240605;
        b=dNN3/2AP+93K9HBndNXGutF3vVoHvQa+9itaeD+eEM1GWgFFt2GxCwXqQ99PilNwLd
         GhISbwDKzs+bWSKAaoqVQdQ77PvS7c2JFBxXpMuqhMuJPafD+8oDOWHhUer9zgqAqdWd
         tsDt7aiAR+vEmA5Cb2fxMA39H+yl2q2r0AYnUj4xuKLMwSCgtvjX3y1MxlKV3b2TmPiJ
         bdai0w6wm5esMJawblaQI0fBfOIfxsmvbxKLva60STJxOC392TxSNWObaohGQNxBmSgy
         g1vgGgDGg0MhuQQ3zFRqNEbhduSlIEjw9s4wV5kzE7Rk/jmpcacYLjC38W94h9EO6fMe
         KrnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7wlY3RSevRuq3DaBIrMyQdYxp5UuY4sfTgf8TKMIySc=;
        fh=PX38tVck0k1B0O5o/9FsaJj6D8pDxyavOZT6baTm6Fc=;
        b=akSxaY+qtwJ6JlNOnEXJIVBu87eIEHZpgrJYsi6YmEfzmzR/1XsOSkrhNdhN+tB99j
         TBxvYDLNa5S1WzgJhHNuf3VHRIiVJ/KpCS1rMoHmsP5Fw9oTTT9yLeHkgzKpAXLQ/GNA
         8pz7bHIZmHNr6f9xjtcSh/ufPOeOuB//VUw8QcbgpxNMQJwqSpzGwwlUK+jnYY+jWynj
         MeVcR9mjOQZBIZ5yaAVq9yBznnnN4/Y9MbVQAPU+RhIGt3lYsBKz/p29F97Bauo2Mqep
         Y65sQLncf92CgUD7hRrXLKc0sk1z5q1JzvTaLwOs7hVCRVuiy2grjK3OOmzvph0ssNl3
         HIjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776335831; x=1776940631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wlY3RSevRuq3DaBIrMyQdYxp5UuY4sfTgf8TKMIySc=;
        b=lSvEySs548vYhf9HfTSlQ2Vb1hhm3w21HGi8fkWVa6Gox6xghbfdwhFzMnxPMlwax2
         EpapM532wmLSmQ/lVen7+/G4obPS/OHOIC+h+trbVhGQ5cZ7NM9yRCW9rRvvmlO7SfvD
         Pp+SDLOTfbnDnnk1lADHID5WwqKsb3rkPGWN8do45yuwYgU13IN+/z1oY3ZPLU8vB4Yr
         Wl6C8p76nTawD3ud707qQACfQKJb04tA7LYMSxmk9Oh9gb7fbiAU2PV76FVA5GhUViAS
         9UOebi9Nfx7qoz/J5+tNoy8SHWFW1XnQbrdrIC1qNkSaX9qOnfGvp19CFaZ0pGZITjHJ
         y0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335831; x=1776940631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7wlY3RSevRuq3DaBIrMyQdYxp5UuY4sfTgf8TKMIySc=;
        b=q5A39gy8g0Vbkw3id9AmBEVitlyMcTajN3eFx+Ct0aVl+FUQTBQIdyWgd/078aJkkT
         A+x8MuLHS4q6dDhIE8BCae5+ToNuXx7C52SV68s5zVwhTujxXDEghhAlxf2JYTvHWqAP
         t0WdqusvG1z0lIONSuNZKLJSUl9H70LF4aE/JXjAjen+4e8Tmq1nDVe8Jtmqpe8xF3Qi
         KuVmEmkifPhSn0lweuBdbqmrfZ99LSe4Ji8C6jxh5Ri//q25+C/LSesX5zPOgLWWo0fJ
         NX3fE+nwKS0SZFy3Q418g+GmWFmxWfLnGBhSRu22DhO8B8ra6qZLA8qFahsbbI9bTveE
         9nEA==
X-Gm-Message-State: AOJu0YzKczCEFcY5TnlWUe1teVpkaVQKbYxees3WLyy2QSJWX/FrC7tx
	ujjkrrf5geTkG/RjTT4pjJ8As5Ps2DprBoikPSHoO1WUJ7CJT2weSWkfpCSbK04Nkl3w9SZXUaU
	dL/Wn2SHvFe6X+zlneLvoomUuvrIIkKT8vIg/
X-Gm-Gg: AeBDies77+miTRsOxnBsPduBxJZOq8JIIpUimR5kX76KKKAVoN7FBAUPXxBW8V+UB+B
	7MPMY2u3BkIig8jBO4UlRwjwPyWfkk0EAWI1nOzLwrgY51/vhKdGreETsCn8O2F11LdTmQ8PBW/
	r7R7wHQgSiR0iZfvxO7B2MyAFdLrSoZBRKcU7/HpJzCtr5S12imYrY9XwjbavxfmxQCCLGpjmtl
	sRFxUmeLR78BIfkT3bkaq/292JwJeYrGxOJfZ7XouJ824bc5pQZe+qZDh6GdTxdJM5zhiEZherp
	hUkhZn88W+Kb7y4=
X-Received: by 2002:a05:690c:4992:b0:7b7:5f48:d9aa with SMTP id
 00721157ae682-7b75f48de35mr60601227b3.50.1776335831119; Thu, 16 Apr 2026
 03:37:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260416102558.575210-1-ekffu200098@gmail.com>
In-Reply-To: <20260416102558.575210-1-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 16 Apr 2026 19:36:59 +0900
X-Gm-Features: AQROBzCaJ7C3-yC0pAhxXvwZz0sb0SJWM8a3VW0L8TPCeER3AAgbFVST7RSQDT0
Message-ID: <CABFDxMEx=GTSNc5kOr=aip=Mo6qBG9bdsTtQRcwLoyd7mAvYPA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: akpm@linux-foundation.org, rppt@kernel.org, djbw@kernel.org, 
	mingo@kernel.org
Cc: linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9a5aohynzzkp6dg7emwoga7gpeuagkph
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28A27C0008
X-Rspam-User: 
X-HE-Tag: 1776335831-449971
X-HE-Meta: U2FsdGVkX19HMVKLs9QnOXj3GusS8g6++ijpf1kEE+pcoMpOteEHSl6/V8Vn0VOxIdqHJzgLGO65bbluP9/NbL4BpvsDA4v/KPmCJCnD+vuYsyGSH9UGqr3gMoH0kAxmAhtZXNmMuQMSpGdj93xsdDzlGlHA2zKoUWVcjAjJ9rcsLQA7aD3pXzLnW5lMD6a99RvbvOOWBF7hnfqPkpW1zEyMOlTYsy3TJsfHP9wTCQK/K0dTWsecaA3OWFCtofsMJpYnS0Ztix+NtiG4gRbVNWHtZZx+6o+Gco04tMZXHziGfY2aIV6KOZX25Un9mAluuFGV5VBN2xiqG1dlI7JQWrokT3XdNDpc4yooFpFqUmY7hWyiMYWiZC/xwroQrawviIjI4TY9Igid7tQAw63N2RaSXyj8IvWcOCbqLgb5CFfKfU9fGr4k5V1ndbUNrjJLXzRDmfmupGT+2uUG4FGnSLWLbdinS7KVg4yWYdwD28G+YUg8s+GrmgL6KSwvYbW9cZApAAsv9jLIc2kotekzIb9mAaxukftB3vV7xnue5Ai2kH6o4lqjWRB/9epuTi2/VuCFpMhz1zQ8quRCpumIz82flgecNswUlwPqK3J2/0hKBifsu1M3DbMd1PsI/OXO0XT9GXouAQtN+QnIGjGK1+2bXEk1vP+K4dYmkedHwwwn3f3uMkUej93HcTjVZkG4TnqcPld02PkAvRTw5dJ2GS/uGbkGT0OgOV7Z2EHzgi6Y0OpAbHRrXDn8VQpPhkvXSFrYGDfxpnUcdagn9zXdNNxWugJMSnAdwMilx1aEqecARXvvRyS9A9SShEqShOrNcKwCSER5ABaM4Kkerw8slum8Ow4S/lH/sc9turUNUTuATRv97pyrNpzwVxwCkd35TRHye+RcU03ab4LquvY6j7YZujhbJ/VoLXL+vRfkElbhxh9nrtgTZUd3XtK2X5DUZCUTtVR+2PeUaoU4vyS
 yq8kOkfl
 udCOhn0ceCDDChHSt/s5KkXEzC3ULaV0D36KxSuiDzxyftuNoN1404dhNCE5wcVyB6eUL0gf/wXyhAWe2Odo5TLONU9+YO5CJJ3G6TufRLucws9XC25RFwFu7h1A8Nxx7GLToINNUYZvOIDXOYdsxOQ+C7DRZfYGZE76c680yDNwAJw87nd2WfuNTxfzoQjylEOE1+OLaK0FcIc4xET6yVvVA+C/9LqXmOyR+3HmUH/tE2aDHKfWXH00EQhFdRMjAtcVyTGmRDPqBE64qIgex0ecJU+cmDDt6PiUDvN/zK56sKUMfHsAabJ86oNatixyersOdXSwmPTEcnUTi1rSPu99IRlI5Q78OMXNbeSLovdxYXNh1y3KzlbNK6TQEDO6r2S5bYp/RCve8dnIjcs9tJMmRO+T2m07cChzya6t19NAVGDcUTFnTKYRNcs7uLOtLh39s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Apr 16, 2026 at 7:26=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> returns the next absolute node ID, not the number of nodes created.
>
> The existing under-allocation detection logic compares next absolute node
> ID (ret) and request count (n), which only works when nid starts at 0.
>
> For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully created fro=
m
> node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> fake node nid starts at 8, but only 4 fake nodes are created due to
> current FAKE_NODE_MIN_SIZE being 32MB, and
> split_nodes_size_interleave_uniform() returns 12. By existing
> under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> under-allocation will not be detected.
>
> Fix under-allocation detection logic to compare the number of actually
> created nodes (ret - nid) against the request count (n).
>
> Also, fix the outdated comment to match the actual return value.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Reported-by: Donghyeon Lee <asd142513@gmail.com>
> Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capabil=
ity") # 4.19
> ---
>  mm/numa_emulation.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 703c8fa05048..c1d0a76aef64 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 h=
ole, int nr_nodes)
>   * Sets up fake nodes of `size' interleaved over physical nodes ranging =
from
>   * `addr' to `max_addr'.
>   *
> - * Returns zero on success or negative on error.
> + * Returns absolute node ID on success or negative on error.
>   */
>  static int __init split_nodes_size_interleave_uniform(struct numa_meminf=
o *ei,
>                                               struct numa_meminfo *pi,
> @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *numa_=
meminfo, int numa_dist_cnt)
>                                         n, &pi.blk[0], nid);
>                         if (ret < 0)
>                                 break;
> -                       if (ret < n) {
> +                       if (ret - nid < n) {
>                                 pr_info("%s: phys: %d only got %d of %ld =
nodes, failing\n",
>                                                 __func__, i, ret, n);
>                                 ret =3D -1;
> --
> 2.43.0
>

The change log from the previous patch was accidentally omitted, so I
added it here.

---
Changes from v1 [1]
- Merge patchset into once.
- Change base from linux-next to mm-unstable

[1] https://lore.kernel.org/all/20260413154438.396031-1-ekffu200098@gmail.c=
om/
---

Best Regards,
Sang-Heon Jeon

