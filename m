Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C71FF8855
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA8E6B0005; Wed,  6 May 2026 09:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2596B0088; Wed,  6 May 2026 09:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1416B008C; Wed,  6 May 2026 09:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09DE86B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:50:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EC02C106B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:50:27 +0000 (UTC)
X-FDA: 84737129694.21.AC6201F
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 71D1418000C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:50:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=exOq+4sv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778075425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uvRH5NWwaeNa0HniCOROnjhGHZN7wgOdieTGzloLRI=;
	b=wWqjSk1cUL+oat/lS8d6gsp/dOaHoa48j6pbVd0OdhlxKtVGX2HKYV5YUSeth7cNr9AaY6
	QecvOVb3rDGYCcpdVJqiTWHbyZSDY2TSrpil001ObY0FcTU4ZKIL1CZ5DHoDkLltWkWFpH
	nNlBWhT7YY2escuqZL9MFeuguhlXLoY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778075425; a=rsa-sha256;
	cv=pass;
	b=lzTWYZ9alVs4otRMwmPVfwSyzmTIPW3ne48HzMdNnARZuzxfUskdHKDEyF8ccRSo8/GKa+
	HE83REfdx0nDR/oGesinoKf3jqRuCufKJapLWte5rWhnGzI2V+Wks3iQ/URBRu83qDhLMR
	CXx9rak3bpHp2H/HnvVpaloax1PwyBk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=exOq+4sv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3937014be0cso44124551fa.0
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:50:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778075424; cv=none;
        d=google.com; s=arc-20240605;
        b=Z6dcD/Pdw0ZfzskWFrqJPblnVmARPI8gzmbYNwGBR3o/b/0kxcZ20nvQo/iJcKIslk
         6Jz51C3WM9H33p0dLY94EeM+O1CekSjeEFp5Cws01jg2pZyRDyRPr3eAGu+27BfUKpGb
         +Xo/R0gOIJIQg6g6GKiFI+MlD0iPT+xNWHUO8gOQIM4GZofI0j6sbowluHtaIPQsJGBl
         /qcbR7nde7G9mfrQZNDja8dszUb/6vwNFWFbNqnFoUWrLtkuRMW4/qmO9bTq2Ajg6mf9
         V95enhj43VktsC51pVqCOEVn8yWclHXO09Dzq5kUPOvF6qiYI59fsvbWE7fWeg8Y0aNU
         CLrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6uvRH5NWwaeNa0HniCOROnjhGHZN7wgOdieTGzloLRI=;
        fh=4edmkQAaXHOw83Reloa5Z5WwOYfb1DgSLS80S+C3q34=;
        b=UQQtzcVIy0xoRrApH0OJL5cNuS+7JPzHyNG7OwNhekjtYSwwuuEKsSkDD4SIlL8R1g
         vlINWUFLNj27H6ZBQ1uIol+XisA+YXLa+cBumN4LJEy1jLvNeBf6TRJhUVSP67I05VP5
         uUcj8DkG3UxyEpNZtCae/KmfSTJGKlp3v1oJFF7GMc5O3XocVZF8JSdfeiQRTjyzg8e4
         KPMDU8tm/g84zFcoiqvMT9ASGaVesE+/b3fFsRsYwLEEvW6jGS2yC1Q6odU6EKS4mGo3
         PXL6n9HsZ1BYt/GZvEWqBOhjnolBwU37Zp3pbqDPoSmLSsQLxyLJgikRiws2chz63Bl7
         QK+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778075424; x=1778680224; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uvRH5NWwaeNa0HniCOROnjhGHZN7wgOdieTGzloLRI=;
        b=exOq+4svoPbyuRzRKKBXXLsz7gDB2QdU49npzqm1I3QIighzgzyAUi2Rb++NcRBmrJ
         8rAhthVYk1atdIMr1SuxJrCrfoRO9XaipOrHUKf1vARKgA2feDXlN8wK/RjPLf/8ME6s
         QPqvoTWexTvlmP0tjV5Hb9K0T/f4o1CAcEjnXK9WcnEUJpWZdYLF1N3ZOHK2Gp0D83zD
         pc4jN2HoTpP7wb9Q2hX3TL573Ear2N7dVEZDg1wJveuK70EKGr8XebPvdx7WAK5UmyfA
         4TB+uPe2PRrcwBe4nX5rHHhWtIfihs+k9rtKrCVWxEYKH8Ds3UJW2QmdhJSPW3/HFfhJ
         zzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075424; x=1778680224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6uvRH5NWwaeNa0HniCOROnjhGHZN7wgOdieTGzloLRI=;
        b=FnUOYYXv5KaU0MWl1K+h0ZgVCDH56mOaSfVUVBhcZW/jUICbVzBjbSJDTcK0Gn1fah
         6z+RNhBWwG/Ru2GOKdcvV0PdE92pLVUkR1cQcVUUkaLOKiqJS0k5N2QrrB6P3XxTUVIj
         OTktylEx5PDuHBe5MPc44ViW2v8nv4Rwf325FhwaXztiMP1Ihamo+196x9LENIYYN6n9
         R72qqCYCn2LIyt7oFHhq2pI+RcZy8eEN4oJ618xGrOmSE3BZcKqsPGcr6InlpGSFJwl9
         JioAT4WZWiDnSqH6UXWQpsNFKq+BSPDDUb8DuGlOpzPGsdMoEXrJFXVkHlwriKCMiel/
         C9Mw==
X-Forwarded-Encrypted: i=1; AFNElJ+CcXSC5orWdf97Hqvj4vsFlQHeSqmy/2ZVRCaAcTtnfDBLFcvwmdZGWScRO97OXYN5bGQeSTRflA==@kvack.org
X-Gm-Message-State: AOJu0YwyeTnydB7A6j8b8l5ka4ASu2uOFSV4BaZl5e41JWSeWAPRYefa
	Q1mP3DRXIBEbP6gOiBpkX2mI8/8blLX+dEzlpBaeu+KmliLLhqO1MwuNeFGc9oybw0uhq3uuLlr
	Gbyc0aEne5LMzKlatSPZYErx/RGPLC9Q=
X-Gm-Gg: AeBDieuI1w8ch+LX6At9seu7+aSoNykbKMnTWtQWncD1su/A3AEpI9ivbArEWRuXwap
	YcdFlYJlnma0ZVia0NirpouiTcw8Gj2uFqTc8yGrmByFnbaJG3RhW+gyHlzpwvXMnyuWDte3E2q
	r+ySlIWg2TbLU58H5ZhgRf3KN+P1nXHUbhsGM8XPjyRBwauaoKHF7PZE3yQeiXchim+d3wfyOpZ
	g9GyQTBXASbP2jwM3ragr13JKr8usUqTIgyG3lDtSbMB27TCD6PGVhsHAFG+Xmb3USr6lkchzI0
	9SGcJm5DnyuV1jN980x5
X-Received: by 2002:a05:651c:984:b0:38c:594e:ffd4 with SMTP id
 38308e7fff4ca-393c421098fmr14049071fa.25.1778075423200; Wed, 06 May 2026
 06:50:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-5-vernon2gm@gmail.com> <20260503175737.6190AC2BCB4@smtp.kernel.org>
In-Reply-To: <20260503175737.6190AC2BCB4@smtp.kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Wed, 6 May 2026 21:50:08 +0800
X-Gm-Features: AVHnY4L5VjeFMFFAf0OJw7QnVXEiQ4TczmASiolBkquu7suKzugMa7qGCYoWr-g
Message-ID: <CACZaFFPb+W7VzRXGKvhMOwLm+T62dytC+zYUKa3-TopLOVO=9w@mail.gmail.com>
Subject: Re: [PATCH 4/4] samples: bpf: add mthp_ext
To: sashiko@lists.linux.dev
Cc: bpf@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, inwardvessel@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, ast@kernel.org, 
	Daniel Borkmann <daniel@iogearbox.net>, surenb@google.com, linux-kernel@vger.kernel.org, 
	linux-mm <linux-mm@kvack.org>, baohua@kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Dev Jain <dev.jain@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 71D1418000C
X-Rspamd-Server: rspam04
X-Stat-Signature: o8dfoktih3awmhc5xbfei945ggrbcmjj
X-HE-Tag: 1778075425-618625
X-HE-Meta: U2FsdGVkX18sEwRaiO2OyghPQmS7ukrJ5AIuXRwSlCXuhHhz3Ngr9DXhVBDeWZRjkm3TT3PValHzVcBDeSjLcI1KUgaSq8Pp9JNpY0QpqC12sQ6Fn3XHS4qCWE97mQYKfe7EYK+fpJY0bJhAfJoiDUCKq0LOtbOyDRmxfCiRGZulL1iIKm1dGrPXHTm6/+ugLtP1LsrYgXob+oOlauKqbGUIq6riDX1OPVxrLLPFK1S7eXUs6YA3rCdQ9KnDeWKbY1U1S/HuW8Ahcy2exiKOkbXhXNRJ0IxQGJzqhHj+X0KlXzqtyeKLTBdnGr7OGkoqji9uFzZ34qr7eFXiG/GRVK7oVNuDGa5uni+KdHcht0ceNrO7/nYSYDlwgNMui5fcd6MWcCXljie2vein74NaWE6uIKJRHvOyyw1teGqSgurphmgX6hZ3CsaSixotGWfCf59z7WNGMMgTPkihcimg5UN4Jf3u4ubuJLT3qZ+TO/AQelAjhnzFccKI6ylKjItzBWYzRm1PAc2B0wFMR/YmYt+106GhK4gF+NFlzwq/7E0qeIiYDh03cmPS1Vx7UH0C8Yg6W1gI1YFHMiqeyTSc8f1HQg4ioRMSE0PG27HHCy2WTdHQTfiDz9kKnjU3LD/mBqZeeTLez89ZWijTVnl8xiNRD8LXA4NXcg88NRCT3e8qBRkC8i+sYgzl3YwEMU4KKTWVMTazzhjUowIeiMiUeBOQ4LEW2chn9j5D5ULXRKO0jWQlycqSSDUmG6qgtaeDU7hE29TcOYqJPdILAYuix0F5v04+gdHXWpOl82jCZvpdzspIbmykCig0W4o4DvumTDRHNs2T6fxhmuEot+LNKEyzRYTZIbJRx5uWXOk7oTy5091vIMzl8BdoDJU5cxLqX9HlgPXHbC3epCnAILMAbJBS0TKQw5WG+GQqIJEjhyPogyk48ZoujwpB1nyI2PVnG7DQbnkkZUKJIMKF2FN
 DpLoAONC
 pnmorUk8lLyfDSSux2dL1Hxqk6AesJlIXvJh5WeX09gWhqup5lQzvPlHVwUudELKD9rAxYoy5G9ntjiPP6Qb6FD95Wh7oWupwUh1I4kMVGuK6vEoCelkEAYkCEoarecOWcU9VVVf/o7s4oGJNMX6MYxl14WqczVwIGpobfFG6iAVnAMLjNX3KKGvyWIoXvUxFabpO4DO7ryab2fGvX0Le1/ggSLPFpIedPIc/ILf3LYvgz0TyXllWWrunhMFTGyXVzey3QrkSpJNEVCDT6h3mzEFrocuXQrvc5vqsaEgLGphMQOICT/QECKGezGd9cchXV8R8rb7JZleF11YMHGx+M2Zy0NlPFdJfgprzvs8CKZfMC8Y1TsqbnQdvEklHsgYUDEjyIygyZeY3Yws92thdGq3IlWnQQg0EfTkZUQwgOweL4vzekvOVCnXbZvjlkR7x0bwSr1M0lK4qhZo2Dofevw3HgK8JBjKHq/SUzMG2JFbFeAfnnD+OlOKBPZm0e2/pNH/oYjAWTNr5Py25C15hgKTaCYUV42xDHZvtPCZO7/Fr5mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review

On Mon, May 4, 2026 at 1:57=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
> - [High] Infinite loop in `trigger_scan()` when `read()` returns an error
> - [Medium] Integer overflow in `FROM_MB()` macro disables fallback logic =
for values >=3D 4096
> - [Medium] Spurious mTHP fallback during initial cgroup scan due to zero-=
initialized baseline
> - [Medium] Failure in `setup_psi_trigger()` masks the error code and exit=
s successfully
> --
>
> commit d30597e7a4d6ca7d5532535074e0c66c2c92f486
> Author: Vernon Yang <yanglincheng@kylinos.cn>
>
> samples: bpf: add mthp_ext
>
> This commit adds a new BPF sample program, mthp_ext, to adjust mTHP sizes
> based on cgroup memory pressure and usage. It monitors the cgroup directo=
ry
> and automatically falls back to 4KB sizes during high memory pressure or
> low usage.
>
> > diff --git a/samples/bpf/mthp_ext.h b/samples/bpf/mthp_ext.h
> > new file mode 100644
> > index 000000000000..33dc01bcebd3
> > --- /dev/null
> > +++ b/samples/bpf/mthp_ext.h
> > @@ -0,0 +1,30 @@
> [ ... ]
> > +#define min(a, b)    ((a) < (b) ? a : b)
> > +#define FROM_MB(s)   (s * 1024 * 1024)
>
> Does this macro suffer from a 32-bit integer overflow if s is 4096 or
> larger?
>
> If s is an unsigned int like configs.min_mem, 4096 * 1048576 would wrap t=
o 0,
> which could silently disable the fallback logic.

Good catch, I will fix that in the next version. Thanks!

> > +#define TO_MB(s)     (s / 1024 / 1024)
> > +
> > +struct config_local {
> > +     unsigned long threshold;
> > +     unsigned long interval;
> > +     unsigned int  init_order;
> > +     unsigned int  min_mem;
> [ ... ]
> > diff --git a/samples/bpf/mthp_ext.bpf.c b/samples/bpf/mthp_ext.bpf.c
> > new file mode 100644
> > index 000000000000..bbee3e9f679c
> > --- /dev/null
> > +++ b/samples/bpf/mthp_ext.bpf.c
> [ ... ]
> > +SEC("iter.s/cgroup")
> > +int cgroup_scan(struct bpf_iter__cgroup *ctx)
> > +{
> > +     struct cgroup *cgrp =3D ctx->cgroup;
> > +     struct mem_cgroup *memcg;
> > +     struct mem_info *info;
> > +     struct alert_event *e;
> > +     unsigned long curr_stall;
> > +     unsigned long curr_mem;
> > +     unsigned long delta;
> > +
> > +     if (!cgrp)
> > +             return 1;
> > +
> > +     if (!cgroup_has_tasks(cgrp))
> > +             return 0;
> > +
> > +     info =3D bpf_cgrp_storage_get(&cgrp_storage, cgrp, 0,
> > +                                 BPF_LOCAL_STORAGE_GET_F_CREATE);
> > +     if (!info)
> > +             return 0;
> > +
> > +     memcg =3D bpf_get_mem_cgroup(&cgrp->self);
> > +     if (!memcg)
> > +             return 0;
> > +
> > +     bpf_cgroup_flush_stats(cgrp);
> > +     curr_stall =3D bpf_cgroup_stall(cgrp, PSI_MEM_FULL);
> > +     delta =3D curr_stall - info->stall;
>
> During the initial scan of a cgroup, info->stall will be zero-initialized=
.
> Since curr_stall represents cumulative stall time, won't delta be a very
> large number?
>
> This seems like it could incorrectly trigger the 4KB fallback during the
> first interval regardless of current memory pressure.

Good catch, This is a Bug exactly. I will fix that in the next version. Tha=
nks!

> Copy from cover-letter:
> When the redis is under no memory pressure, RPS drops by 10.3%
> (from 1.4M to 1.2M, compared to always).

After fixed, when there is no memory pressure on Redis, RPS equal to
1.4M, which means mthp_ext is a positive optimization in all
scenarios.

> > +     bpf_mem_cgroup_flush_stats(memcg);
> > +     curr_mem =3D bpf_mem_cgroup_page_state(memcg, NR_ANON_MAPPED) +
> > +                bpf_mem_cgroup_page_state(memcg, NR_SHMEM);
> > +     if (curr_mem < FROM_MB(configs.min_mem) || delta >=3D configs.thr=
eshold)
> > +             info->order =3D 0;
> > +     else
> > +             info->order =3D PMD_ORDER;
> [ ... ]
> > diff --git a/samples/bpf/mthp_ext.c b/samples/bpf/mthp_ext.c
> > new file mode 100644
> > index 000000000000..0e064bad136f
> > --- /dev/null
> > +++ b/samples/bpf/mthp_ext.c
> [ ... ]
> > +static int trigger_scan(struct bpf_link *iter_link)
> > +{
> > +     char buf[256];
> > +     int fd;
> > +
> > +     fd =3D bpf_iter_create(bpf_link__fd(iter_link));
> > +     if (fd < 0) {
> > +             fprintf(stderr, "ERROR: bpf_iter_create failed: %s\n",
> > +                     strerror(errno));
> > +             return -1;
> > +     }
> > +
> > +     /* Read to trigger the iter program execution */
> > +     while (read(fd, buf, sizeof(buf)))
> > +             ;
>
> If read() returns an error (like -1 for EINTR), will this result in an in=
finite
> busy-wait loop since -1 evaluates to true in C?
>
> Could this be updated to check for > 0 instead?

Yes, I will fix that in the next version. Thanks!

> > +
> > +     close(fd);
> > +     return 0;
> > +}
> [ ... ]
> > +int main(int argc, char **argv)
> > +{
> [ ... ]
> > +     psi_fd =3D setup_psi_trigger(root_path, "some", threshold * 1000,
> > +                                interval * 1000);
> > +     if (psi_fd < 0) {
> > +             fprintf(stderr, "ERROR: PSI trigger setup failed\n");
> > +             goto psi_setup_fail;
> > +     }
> > +
> > +     monitor_thread(psi_fd, &skel->bss->configs, iter_link, rb);
> > +
> > +     close(psi_fd);
> > +psi_setup_fail:
> > +     ring_buffer__free(rb);
> > +rb_fail:
> > +     bpf_link__destroy(iter_link);
> > +exit_fixed:
> > +attach_iter_fail:
> > +     bpf_link__destroy(ops_link);
> > +attach_opts_fail:
> > +load_skel_fail:
> > +     mthp_ext__destroy(skel);
> > +open_skel_fail:
> > +     close(root_fd);
> > +
> > +     printf("\nExiting...\n");
> > +
> > +     return err;
> > +}
>
> If setup_psi_trigger() fails, the code jumps to psi_setup_fail. However, =
err
> was previously set to 0 from a successful BPF operation.
>
> Does this cause the program to log an error but exit with a success statu=
s
> code?

Yes, I will fix that in the next version. Thanks!

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260503165024.15=
26680-1-vernon2gm@gmail.com?part=3D4

