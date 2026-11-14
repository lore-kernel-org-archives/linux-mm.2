Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6366C606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hdcH+wdd
Received: by kanga.kvack.org (Postfix)
	id 5420A6B05B0; Sat, 14 Nov 2026 12:57:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519DE6B05B1; Sat, 14 Nov 2026 12:57:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4308C6B05B2; Sat, 14 Nov 2026 12:57:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 162CF6B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:57:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AF34C0447
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:57:54 +0000 (UTC)
X-FDA: 85434482868.05.D8AAF77
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E91040003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:57:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hdcH+wdd;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794679072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bylSQ/tfgEhydnCX+X6ude5kn1WgMfGriStlC3xv4iw=;
	b=nnavMpydV5v4cg3OQkanL6KXuvrYvCirHQL9l1vW+izxAd8UzEZiBwKwreETONJH0XuCvb
	0I6VQgDQ40kwsKRGm6TR66l+BRLGujRETGYJG2O4BnIozmZ37u3qHwRfYnQ5sI1Yi9Ah1z
	TvbeAWtC8GK+TQ0Xmr8XF0kQx74iMH4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794679072;
	b=2Lj1zNKv7ohpKuIG92CIhqzllsVhdGrQ2l7a0LlgVHy2ENhyF56HC3my5BjbPTeCat2UsS
	TSxxmm/RodRuL99EAYIQfFT5kzd+g0++qMELiMvnfRWf2dGOdRmSpDbokfO4neOOxtJZwT
	CxA/Sj/j5HDv6TektWDq/dXp102Lt0Q=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hdcH+wdd;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d30639709so334484266b.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:57:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794679071; cv=none;
        d=google.com; s=arc-20260327;
        b=OGxvzVDSH4WkhLp1QNew1kGXgRHwLqlqLLj3IQ3xRHEzhklcEC9VXStH7CC9pFk0Ic
         Yr8vYI3m3LlwB0ONdhC78vp9VLXK0n1BvbMSYJ6aP8Rtz38OaXqKYMsVO/HF2SIRhSuj
         Q02FypNX3AWNxA46WNk7ArvAFvateGLOgOatbHUqhVB9jNjEsTCyKiLOAl0ZjArH5ePv
         1TOIUUd+ENrailopcY+kTMRgtNy+ZupquGRWnPK6RWVUo8PTvVXXor2iT+bNoV8Ks9Pf
         m9cIToXN3PvtxU1UbQOlQH0+doA5L7gz18Vu6+Bd256PlNt8GQGEdS5afcMvubGFgcE5
         6FEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bylSQ/tfgEhydnCX+X6ude5kn1WgMfGriStlC3xv4iw=;
        fh=onU6mbAyhhmKVzikP0m8uGrMzYLBG16JCOZsNmTopmo=;
        b=ItqXcKaB23MZcUFmXIODoQv636XX34rjppTkbk3C8wp7mhq0pwZ8iIjYTz6xM2nfkd
         5Z3gSFNIq9cMSLNA9CpiryiFIdAaUQRGlMJGyg7ggWQ7QBXxtd4mO5612/yBHBjrchWu
         c+gg9lyA/DoSZ5q+Cv1GBg0jyDRmMoeriniplRaO7GF1uomFGVLluKTZFNkf7U5IQieD
         IgXBmx22Bzx5jRpgUyVb/uSG9fvyfsroG15FMtGqUQ3nwbFR0eibOBQ59aI8vSmjhEjt
         AVkfdUM9xDzTKGuqHimmZyfRQ52ifXJz76e5bZGXivux2M187ZJwHgBJBe5OOqsycMmr
         Ualg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794679071; x=1795283871; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bylSQ/tfgEhydnCX+X6ude5kn1WgMfGriStlC3xv4iw=;
        b=hdcH+wddnew8sAeFvhqzWD+dtCHAF1ZofBvj8B72T3IE7yzMFCTnNYzXEwLof7ORv6
         QZwixmDgqEq22KH+tiTv3f11TqV4i0iUbB3IzHNRNqkJ9wnNvwZ1MVQmlxvhP5mGjA2t
         tJQ9gDjTvJxCRB9qtL5itvHwgKsVF8Wj6sajouxrVORgerKjRIx/jJrzuHGDNs+ImSFG
         y6eOFsABgl/yWEfGQuaTWfrRrzoTCq7shuFSyNPHqwU96EidMBlU+auvexFxLZJGDp87
         mAhykohtWyksrALP1yxN5ch8s5vP08AGRjohgfM1HRGNigjfLy3IJI8Gz8v+UhGHZnGY
         c7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794679071; x=1795283871;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bylSQ/tfgEhydnCX+X6ude5kn1WgMfGriStlC3xv4iw=;
        b=ZYjWkoB7U7OjHxToypaJI76yxg4j1zP3oElhTB44kwBOXkEDBE44jt8MkmY3u8bJEi
         pgujFPz9iCoouNAPac1N6sxqMyBaKjaXd6Tpwen0xApyvAAPGMaZx2fmeXKKOE14XGQX
         kdCMSrV8/SdzGHkJwq3+sxIfzTriaBjk57g5Tx5W+DI6fcmoiv9lBqBjzrxyc6UPwQdm
         T7BCNvGYUnlc18QrgV0L7oxh+WlN59P13+DDW6/QgUpDXhKtFkpXG/Lm8lWI9C9E/eRz
         jwkD+M4s351xMtujgBZDluS+QD2uYvBzG5f1KXCzUvYC5KQ5h1X9uA9yb5wfs/Uh9bb4
         M7pA==
X-Forwarded-Encrypted: i=1; AL+hErG4r1nowtvfJW+9Gme1RbAePwZO3mTs9BV56Cw/1e7XUTFZM3nn7OkW8HyJKyzyFCGLk8Y7LA95Aw==@kvack.org
X-Gm-Message-State: APuU4Z8j4N7WzkPFksRANGtxrmxMrcTKjyl518t5vQOp95AFH6xScCpU
	VY8s1XBBjC5yAk92V+grIkRk0xf6r4zCnYcwawyoQ5OG1ysURm+TcOQrue/WZhmVSUq/HOtNORJ
	/0MG5dW+Gr2bnBIsp145qu77Chk9dGS0=
X-Gm-Gg: AYBFou2CWpPZ1oqdpPAsZfq2SpruEnLaD5i4tuYu+euee65Zvzu43tMjuPsxtkFOLvb
	19tCjx9D55XHAoT9qc/MqTiAKOeGUgLxpp84YdJlgVlN32OcmQik/zli0dhxqQMxW1S8wt2dxTI
	oWoRStE8wlmQS2yxRUV0lLqcPVkAiVvPdEaiGzso5YUqMzA3rIg6AAkhI3bF0G3XcPSdCX15B97
	JTKvMu+cERTYGb4D8SmLvxspruEHnQkdlG7DA6gJUBGgIaBMkeokoXgl6MYZInAWRRgdiAd1V3G
	JeMIfPnPcnxec+PtoD8Ltv/3fm+Zuy5O4x7izs1vNshx2gXlXo5J6GuToree23oLznQCW6k7cOX
	pu4hqv9Gq4Hdpqai9FFX4B/9e1v1cxwYAYZFg4++14fdBz1cGRf0zA5tefFcunwEy6QojxnQgTP
	VG5j+/DqvUGoBkcdxd
X-Received: by 2002:a17:907:d0a:b0:c2d:d408:5d9c with SMTP id
 a640c23a62f3a-c509684ba8emr445498366b.48.1794679070813; Sat, 14 Nov 2026
 09:57:50 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261113185541.70203-1-baohua@kernel.org> <20261113185541.70203-11-baohua@kernel.org>
In-Reply-To: <20261113185541.70203-11-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Nov 2026 01:57:12 +0800
X-Gm-Features: AclHuK9E1krSsTGkkXWgcbJbCojCN75Kmg6w82e28JfpuFnCTTb1-n0fzU9ZEEM
Message-ID: <CAMgjq7C1A2axrGiQzo2_9d6N9MQNP6Lg+ZqcHsac+qGvt8OL4A@mail.gmail.com>
Subject: Re: [PATCH v8 10/16] mm/mglru: Run aging when pages are rare outside
 the youngest gen
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kunwu.chan@gmail.com, liam@infradead.org, 
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, 
	sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 5iamfpr8c9t3zdhd9x1jxo8z6i59xx4j
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7E91040003
X-Rspam-User: 
X-HE-Tag: 1794679072-246603
X-HE-Meta: U2FsdGVkX1/fVP2AkXgqA+osEnsDlJZb6WHz8VUg/kNz/V/tgiHpJcso7pomRl63XJasqDRxGkec1n8bJBDR6ZDgeR2W5P1H/WyU87rwdumsia2gRgjd8DHJfUS6QF9izBi9hFmtY9uJEqTXEt/a9JuMoYZo5WvnQjHHljZcyzph+eP2fIU0t0zwr8Sb/Ez8dGzPe0i6/Xi86DHvvMyCgjesSjLN8rlf6b/DwhNdITFwuVGIx43fW4qd6q/ywRAua//tljeJYBXdoEkH/pzS2YM37CVofnu1SrNQz4y8EtGmneff6NutDxAqP3RPNVLHJce0JvsrSydguQptvTDehNXN8M2hyuEs19Xst6xgFAHfbJWZCaCLBcR6NOXuEgsc54j/J0fYiS+Ip5+mzHB2D8slVTex0vQgCq4mF87Fyf+1L/9TSY0IaImdnELdwaiv1SNBGsqTGZuP+fmIL5TnNsvaflA6YF2bd8XA3Fqte1MR1almHVqG6ODQG6C+hQKV3B89I3IY8VRrFPpXSGwdoVctpK5VUbFRIE3MVLg5DmTmhRSvNI/oMNT3DaefiMlBsqSXBC6K5UNMWo/cdoxOzg8UnyoOaXPKZnEexy+jpFwEca20Qpsa1fqvKBB8ot1bfmq03EnIcJp2ImE6UMZ81eOSQlnAgT/uv9tYgHo476M0PXcWeNVgaPnDKYf3Lt0Eee7NvJwcKpI/PpiGudnd7L8yWKeyGe6TCNpQp5WxZORuckKbeZZr4SSwTi+9M6he+Z3lKNhSs5okZwJSffav7yWhuONDvXbNKZY9JBva3fkLDvbZkak4+1qSONPjZ8pM3jcxuwz0xDDAUGE2nT3ZOVDdj7eean/Y+/0hGycjFyIkTzbDFgqIshLTjP/oOBQBuJ6xa08AP16WrXn1AiAKOEpS9VF+lEt1pkLiHUvI2Pu7+aS2xHfodfOhPNC632kNEGpqCFqYV54gn9W5eRa
 wJNSdk5j
 inD3mzbin4685EnDub4MIGTiZIDcsjrWV9b/yhfZAmXI3VPNOq1l5TQmrEpn9pnV/75woUE2yokl9yhpfoFVLMjBoddDk5YtcCQCbvkr/gVgsoGyp9m2duG3+zc+3x37yIsSHF+v0hFDzDu3fDNzqFX8DuT0zwjwVIO6q69rHeeSEXPOLy+GLf471l4nXx/ptCVVxKvgA5uH6mw7PGnOq1xj9ULpS1PgShTcNP9CDDTZG67Mg4tBr71Ho14fL/zY4Cgtu7QXdRJpk1eJFir51we/dEiFsx61y6kjRuwtdWN+FrdXYnqnrM/MUH44qjaOhKx//plA2wyjhIU2KxJY3+rgR+GZCEOkTm6ew7Bbq+bEfL7nAfI3VmbmEeD1mL1AiTSNUrYKzVBpycTT2g3ZTYl1+U/iqS1K+aKNJf8tbmEkYKLpEci5GMeW1armdiVpmZxekGOhhWp9WOiuTpfS2Y8UdVd06d51iSufKWouv4yfMAw90bX67wsboUEQNw4/xgrNucZTV1TbMEGPLY1th+lbwLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 2:56=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> From: Gaofei Lyu <lyugaofei@xiaomi.com>
>
> Run aging when the total number of pages outside the youngest

Huge thanks for this!

I really like the imbalance detection idea, as skewed distributions
are very common in real workloads, and this significantly improves
accuracy.

A few trivial nits though:

>
> +static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_contro=
l *sc,
> +               int swappiness)
> +{
> +       unsigned long youngest[ANON_AND_FILE] =3D {0}, old[ANON_AND_FILE]=
 =3D {0};
> +       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +       DEFINE_MAX_SEQ(lruvec);
> +       DEFINE_MIN_SEQ(lruvec);
> +       int type;
> +
> +       if (sc->priority > DEF_PRIORITY / 2)
> +               return false;

We have been using "DEF_PRIORITY / 2" so many times in this series
maybe we can introduce a macro like "AGING_PRIORITY" for this later?
And is this condition too hard to trigger?

> +
> +       for_each_evictable_type(type, swappiness) {
> +               unsigned long seq;
> +
> +               youngest[type] =3D lruvec_gen_size(lrugen, type, max_seq)=
;
> +               for (seq =3D min_seq[type]; seq < max_seq; seq++)
> +                       old[type] +=3D lruvec_gen_size(lrugen, type, seq)=
;
> +       }
> +
> +       /* the vast majority of pages sit in the youngest gen */
> +       if (youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
> +           (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS)
> +               return true;

We may increase MAX_NR_GENS aggressively in the future (e.g. 64 is
what I have in mind), will MIN_NR_GENS work here? Like what we had
before 798c0330c2ca.

Also counting only the youngest will cause it to drop to 0 very
frequently, as each aging starts with an empty youngest generation.
Perhaps we should look at the yougest MIN_NR_GENS gens (still just
like what we had in 798c0330c2ca).

> +
> +       /* Swappiness extremes: the corresponding type matters */
> +       if (swappiness =3D=3D MIN_SWAPPINESS + 1)
> +               return youngest[LRU_GEN_FILE] > old[LRU_GEN_FILE] * MAX_N=
R_GENS;
> +
> +       if (swappiness =3D=3D MAX_SWAPPINESS)
> +               return youngest[LRU_GEN_ANON] > old[LRU_GEN_ANON] * MAX_N=
R_GENS;

Maybe we can do a "round up / down" for swappiness so the two explicit
check can be unified, by reading the right type in the for loop above
directly?

Like doing this before the for_each_evictable_type:

    /* Round up or down corner swappiness, to balance the heavy biased
type better */
    if (swappiness =3D=3D MIN_SWAPPINESS + 1)
        swappiness =3D MIN_SWAPPINESS;
    else if (swappiness =3D=3D MAX_SWAPPINESS)
        swappiness =3D MAX_SWAPPINESS + 1;

> +
> +       return false;
> +}

And BTW I tested this with FG on top of this using zipf and the result
is even better than before:

IOPS (zipf 1.1, 40G workingset, 16G memcg, mmap access, 3 test runs
for each setup):
mainline: 2,215,641 IOPS
mainline with FG: 2,705,460 IOPS
after this series: 2,182,625 IOPS
after this series with FG: 2,772,968 IOPS

One thing I observed before is that when testing FG, if the generation
number is low, the accuracy drops by a lot since we are trying to
distribute the folios among gens by the frequenecy, so we have a
compressed frequency space. This patch addresses that well so the
performance gain should be larger now.

