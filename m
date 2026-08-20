Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1C5C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC95E6B008C; Wed, 19 Aug 2026 22:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A446B009B; Wed, 19 Aug 2026 22:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68F76B009D; Wed, 19 Aug 2026 22:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 854C26B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:12:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E661B40676
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:12:20 +0000 (UTC)
X-FDA: 85120023240.03.C59E76F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 08BB71C0009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:12:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FgbNhls+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787191939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=graB34iLa0Kk0Tx7Qpqn2wsH9QXAWSlPPhQbARAB87w=;
	b=o5HvdUXF9m/sONY+MS3hk/a20rW2f5NuhZ8razMRVJHMD7iaBinTgbkEOWXetAfbTXK9hK
	EZbTiz+SRgfUhK3Q52GpsoYYomHH9Rqj9SXYN5uSEvLDLAC2AyT9wuBXcrOjY7On9Yy9Xd
	iUmDUYJeDbwLjT13X0Td/Vw90Tw11Ik=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FgbNhls+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787191939;
	b=vcq4y1h1sPWjTV6EjPfBctxKFZBoe3MnlBuIxbeLygtRRPV18hFIrZYhslYnToI5yuQYQd
	W8Qi655O/ZkvGWyzuuLPoCzvbNiiDSoC30TuClFO8kCt+e68uSsNE2oMkEByMRyXl//x1M
	RpRVlisGoAYmo1L5Nqobc+qUFuTw41E=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a18840e2abso2795205a12.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:12:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787191937; cv=none;
        d=google.com; s=arc-20260327;
        b=PcpLYdXU6KysDO8AXPv3I3v0gTSy/7KAiEjVDRusB0FVXLiBlc+DMv/1s+gAOSv1og
         QmdzQrDi8ORWBP8hbjEZNxXPyNR9TJKmqhblPmwVpQawX+7wgoKiV2cmVw9ks/eh/pkX
         xJKbhqxXgTWfu9wUQrTqin1J/px1EcHHHVbgufjlyiuaaVeKayDAqQVaDRhGYi6HIzpe
         FBYlscMi5MKaRGLQpC8QGwGf/UTSm8oJzu9/gB8oQ+9JlQ30LcK2Mf9Y2QovRX4FLoIX
         Whm7iydqViAY+xsPEswPmo9drDudwITuLP3Uicv99XpNauBdgSHWQR1SyCvVB+5A2d3I
         ewUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=graB34iLa0Kk0Tx7Qpqn2wsH9QXAWSlPPhQbARAB87w=;
        fh=l72JO8vd+vDXU2g7X+jwI+675MKfepCEWNDjvwrBCCc=;
        b=h1ExeiXxDzn8gyv5ok/MRBazoiUDUDvZJ5RfDDqKvYjYEHG6sp6gv2BiUhwhN6JXrJ
         wgYtr7Y9bPinO9oJR3jbz6WaYoqzp6zpN0SArTAxwaBD65jmLnQ8Wc5lYwKj72fGOU28
         k3sR7goF9nNht99qhCWCvkNWFBxjzZUMmIiQNs68vs1jVBkRIfbMQO+5IJcX8qasJvEr
         TH9C6tPLzLO9DYvDmNtnmunZ7bbCuaejVKY2q2wW3uhA6NTnvk3Npd2RtFTrYttNkHY+
         dZp11OB+7JdjnrwT5+RC3G61Xzm0jZiMqKi6bFteN9nhyVzWrbWFfpOkXIW3KljYoG6V
         YPkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787191937; x=1787796737; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=graB34iLa0Kk0Tx7Qpqn2wsH9QXAWSlPPhQbARAB87w=;
        b=FgbNhls+AT3JNUuHh0mevHHy3i0kce1tgNrznWm6D5Wz6fBTIhkZoWa3jctSRoI5Mf
         /2SyleLU0xp24bsHmA3NnuPxsiI/a6ZO7QChTqFnNmN0S9o+gFJ7wY5EqpyoOyqU7+ep
         OFOhkku87HLvHTLwtVlyyn1oRbSSjNHqINai45nyZ4P+Zn6WCbZsR6yVrjQUz7ZzvWYP
         qd0dRMkIvjruWUJ78ZNz5k59yXO/NhgU+GV5Js9V7cfaVDhV1QFHU8oZmlX8zdH+cX91
         DHJ8uuDrvAEh0guxuTCdOw6Oy85YAWS7KQ3LhEFRXp/OaQgo7Ct9XTG4uk2JTIA1Yiu2
         QJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787191937; x=1787796737;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=graB34iLa0Kk0Tx7Qpqn2wsH9QXAWSlPPhQbARAB87w=;
        b=A3Dm4oiuZV4U7OiLk4Ex2bU1LtnIyJJ2B40luqXau7II1WfN5z2JhpkUcJRKFvRy7I
         31mfb2aWKBHIgIQEYXCM3DTZpZQUkzUnPO0JsnyIS2xHmH60TH2ajM47Hv/XrbjqNfVn
         aPn3UXMHs4QS049gGY1mYYGKHAO/vQ25UNgr8Q+R380aN42nStrvmBJd2QOblS23Zf40
         BQAX6x/Hx70QchMxlUo051XlUAQs1SwQH4PlT7WNs4n150xddB/NE8XpMltWD9SNBACG
         H9JjM0NmBzu2F9C6EyrHuIpXyY9wtQ1LqJkNT/xyiit/k7rsIUDKt/imzsxHWu97uifG
         I8Lw==
X-Forwarded-Encrypted: i=1; AHgh+RoV+6wvuBFwss0wvtRPSrK2fY65GsO1kshMUSzEVctS4WZ+QFIHc9Mr+VlIJngQc2OToP7pkR2qRA==@kvack.org
X-Gm-Message-State: AOJu0Yz2YVKFQONxNAH2CGMW5oPxSw+smZdfcKkp62lgkhfxa8WK3RjY
	KPHbCOwJAWV5Z4lhZUAQUZ1uhNStANb2AzaoHulCmY4qkLz5jfp5s/LY8ss0u/vdEn4M/WSJ9F6
	jjU15yovrbu1p/87R04zkc/xknPqsI18=
X-Gm-Gg: AR+sD11zakXJX7qkReZSPzYGHB1Wvu8dtr8oISmct+4c7YVt/2/Fa4Mz2DInt4Qeo/4
	HwOlCLpOODUCa+DVmLCmp6k3LPCib3nbT1JhYUMFylTJrPrS363/kcr5lTdyGEKoJa97QCGoKYu
	glcjuuDh95VIa7+jeBZ7q8B9bK2BjXvphqssIAvhSLn8zy+LHas4FNvkCxglYQFCyhgHNrMOIhw
	BwkP47pgznN38vY17TsAoXJf9iTxqfAz2hNDQRHuVNph/eYdeM95hK/qDrKU0GTzJPjULs83bsy
	QRadwAFwYE7DywFvw6voiDV3AVQTSFihNourSl8DuiHe+KrcjHthmIXhIpbzS8dW10sMecxq2lQ
	i3g==
X-Received: by 2002:a17:907:3e0d:b0:c20:768:af62 with SMTP id
 a640c23a62f3a-c242e6ecba5mr624658066b.22.1787191937206; Wed, 19 Aug 2026
 19:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv> <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv> <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
In-Reply-To: <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 10:11:40 +0800
X-Gm-Features: AcwNN1XJQCCoQ-p0IrCgrj25pFFXkct6vMiMz4ZC14CjFMzHp920L3uC49NVjkA
Message-ID: <CAMgjq7ABr1Km-BoM3o4dXZ7xdRHy=PdcB2q6rUtEhP84PXFACw@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden folio_inc_gen
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oaksrq7g9bhzia6mmt15jjtkn5h4cjur
X-Rspamd-Queue-Id: 08BB71C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787191938-962361
X-HE-Meta: U2FsdGVkX18hf+Zqej+H5blieMmphi1G3hgpOLdgiUmUoFqU7NQN3dkZDCBWYhwcSglrot81k5SXV8JKZGgXoRg1Fp9I9JfZu5n2XuVJUWOzreUNvDWAyoYFtNP0GCjmxcSjsAW5hVWcr5manLvwu38F527LZ/JAPivl/V7YM6rNyrpnU/EOD5jL9FFvgzLtiUbIpNUejGB3f20q4gnpNk8UPakoGmlj2t8kKyz2wyZRBHIPnkWA899VhvWHh/erFd95mte4DOBkTddtiCQTpNxkkU/Cmf96RrwBYgzdsJ0MoOUAVwVsrbMryC2F1F3/Z0cmemdRPWLaggVWpvmEWXwEW7sFmeK1dbrsWoebls6u8t5uH15oN04UsEB4S3bKMw4E/6WxeT73uMgr52kwxYypz+VL2Epker68jDS//jPyfXQDe3c1uBGQac7O/p0YUwDjbprvwZwI7c6VtRYQBeMBU3I80UsQ9XbsqL25d/dEEr/zdCA5rcecAA8IDfuMu0apcMyTjFrXFEaGE41+w6gKoBxjfhdR6gk3X+F8tjCR8OVQtKAuKWRhXWotxK3M2dVBw7aspKhdIHFhEQLzRqJXRgpZ+tTJ0L2HcYky5bI+xKOQfu1BZ75OVkntCbQM/lXqP4X2l1XpjjtOKfuJQugSFA4jegD6/1AToL1SBbiANsdAvTpn1bkj9hkvxBfHCKqo16CmkDop1C15puc2zqjmhX0wogUyCAQfqzbyjGfvYZXgtcfNHQ+AE1VGg3mAtNl7GZ2bYlJfB0csfiaVb1OJ2MnK66NzI7TtoVsCfLqk+AJjrv8XemrZbvytxuBw84pRS/CNZuiLjm3g9Hxi+pe2X9BgCXMQ3IflUUH3m1J3FYlW/eFg8UQhbsuZIZ77974L7O6VLQOZQjvD6RgwI/Hw7QESV9+p0q4Q1u04chsfaKuiJOck6bb1w6dPqJhq/q+ZTHvrYw61jYT9AkZ
 NLglLAO7
 ptXbHmWTaIBikLHbxehTU6iAG/oyvQYqlGG0FcKS+znDMPyBRUqaLrDAKpn9tFhE+wItplek5JwwsXZ6u9XuDDddYMLu0s8Xo9wcVY7fwTCwkFjgEWKC+cZcjOzEkoTCu0XW6G00ZdUNidk4yhu4BHTScirDrkqtcatOE54N/j6353Fyitpvz+YTCJXRzYpjsjJefw9sPxkRGE86ElEWg6SxrIZySHqkUPbB8qnauWw+JrvfxD84po2eaGXeNTMi2swB62HIXDPfbA72Jg8onJqytsR9cqaiMoQaKZMgvpq57avq0h8ItAOciCqQJjxmK9FtaEm8tdbxTj/NX9LFTkj/ttHO3RYJBDNIfzE4JU0e6HbpzkidIZqEjkEL81nPE29rhF+cq2c/d410bPPs/o8F27vuZ1l69bcMo46gf5frZqChpct7cgf97Ox00d29zjMj778XbJinktLBCprpMTh6D269gV47a+eBHsGRauRiCctQ3rfpXcAgRSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 9:02=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/20/26 8:57 AM, Baoquan He wrote:
> > On 08/20/26 at 08:53am, Baoquan He wrote:
> >> On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> The helper should never be called for an off-list folio, and it alway=
s
> >>> expects the folio to be in the oldest generation before doing any
> >>> cmpxchg. Add a sanity check for the off-list case: if it is ever
> >>> violated, bail out and keep the folio flags untouched to minimize the
> >>> damage, instead of silently treating the folio as if it were in the
> >>> oldest generation and promoting it updating the flags to an unexpecte=
d
> >>> status.
> >>>
> >>> Also rename the variables to clearly distinguish the folio's current
> >>> gen from the oldest gen.
> >>>
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>> ---
> >>>   mm/vmscan.c | 14 +++++++++-----
> >>>   1 file changed, 9 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 7169cac60869..7e3ae0c6cba3 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruve=
c, struct folio *folio)
> >>>   {
> >>>     int type =3D folio_is_file_lru(folio);
> >>>     struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >>> -   int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> >>> +   int new_gen, old_gen, min_gen =3D lru_gen_from_seq(lrugen->min_se=
q[type]);
> >>>     unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> >>>
> >>>     do {
> >>> -           new_gen =3D lru_gen_from_flags(old_flags);
> >>> +           old_gen =3D lru_gen_from_flags(old_flags);
> >>> +           /* This helper should never be called for off-list folios=
 */
> >>> +           VM_WARN_ON_ONCE(old_gen < 0);
> >>> +           if (old_gen < 0)
> >>> +                   return min_gen;
> >>
> >> As Barry doubted, I think this change is wrong. old_gen < 0 in folio_i=
nc_gen()
> >> could only happen inc_min_seq() call it. While inc_min_seq() call it
> >> because inc_max_seq() need increase max_gen to max_gen + 1 and found
> >> get_nr_gens(lruvec, type) =3D=3D MAX_NR_GENS, it has to move the oldes=
t gen to
> >                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> >> 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it wi=
ll
> >    ~~~~~~~~~~~~~~~~
> > Here, I mean it has to move folios from the oldest gen (min_gen) to the=
 2nd
> > oldest gen (min_gen + 1). The empty min_gen will become the new max_gen=
.
> >
> >> be put in the lastest max_gen. It may not be expected.
>
> But how does old_gen < 0 actually happen? folio_inc_gen() is called
> under the lru lock, so how can a folio listed in MGLRU have a gen
> counter < 0? If this can happen in any case, we should fix this bug first=
.

Hi All,

Actually that's the confusing part, the "new_gen" variable here is
actually the old gen (the gen number before the CAS here) of the
folio, and the "old_gen" here is actually the min_seq gen of the
lruvec, and that's why I'm renaming it.

The current new_gen (which is actually the folio's current gen, the
old gen number) or old_gen (the lruvec's oldest gen) should both never
be < 0 in any case, if it happens, folio_inc_gen will corrupt the gen
counters or page flags.

This change isn't fixing anything, this commit just make old_gen to
hold the folio's current gen number (before the CAS), and if that is <
0 (the folio is off-list), don't touch the folio at all which will
further corrupt a already buggy satuation (this should never happen,
so I added a VM_WARN_ON). And now min_gen will be meaning the lruvec's
oldest gen.

There is no functional change, except one more sanity check and defensive c=
heck.

