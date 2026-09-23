Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BA3C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C44C6B0088; Wed, 23 Sep 2026 12:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C566B0092; Wed, 23 Sep 2026 12:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1C06B0093; Wed, 23 Sep 2026 12:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 271556B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:47:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A19131207F3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:47:22 +0000 (UTC)
X-FDA: 85245607524.29.2332BF8
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id A712B120002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:47:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gfsCC10o;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790182040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAQcvfsEw2NREatFJ5f2rKVMnBOJ07JjjvYvVs9Yqug=;
	b=BRmVDJ+VXYajHGTdc/xampqZM4EyKX2BpkeQq4YBgiAPRHnmJd339fyYYIZ/NZVt2ccJad
	PDIXPAlUFsemmDHHGDPajq6MfI1YVZlbcpRwK+sB3vohxYEMNV6gnz6lGIM+hgHOcWQQN2
	2yiv6VirXhHv6+FRg7brdUqgZ2GfH8Q=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gfsCC10o;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790182040;
	b=Ht0sbMUM+DVWScPw0/Qvj9t2tikK0QBpfJSnCdSHtEpvCzd2fZBxHlT1lzoOOtbfbBsCRc
	fu5Nup+aXwBOfoKY6qdYQB02IFsLX3ruw1DswwfKltxyiQ5JL1XkweYgNtEchrbj6MOzJq
	/r2y44zVZB/4w5my7X+5HBuI3ymPkAo=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd4ba9f68so13227925e9.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790182039; cv=none;
        d=google.com; s=arc-20260327;
        b=UEu5xrqlt/CYU0rQ22LV9wP3hg877tShtn0I4dS5oLapY2N1e4eqNFBQXS9odETxeg
         1O25nfUvIcp//46MXYWtQKXuCniHqERxgJAoAIZYQk9P/6ub5woAvjS7PowuezLEP4dK
         j5V7TVdOld89rK7zxQuBN9OZ6wRWTzdZiPLViSHqOUEUxkAOG7MStwuu+GCDAAoaonLu
         caMXfj8vGjcFXC6s5mZNqlEyQJ+6ZSkFkp+l7UAlIsU0xaaHk13pOT1Ga5t1SHEv6LLw
         2fFnA8SG72AjHlaRTWjzGVBHZY8Jt2FRuXDhwOTXKQUUqdigPX/DrqfoiArBxOtqDEzj
         cIFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tAQcvfsEw2NREatFJ5f2rKVMnBOJ07JjjvYvVs9Yqug=;
        fh=jsN1zyZCO6Y25MgNj4yEg+6MaRff5+9twZxfFzMkryM=;
        b=DRD9Jfrn6S3ogkBn7GZML1NtfUhPOw+qR59PY3I/pg8nXR+f6R00uU7j9V9Bre3lQG
         0Ya1KbjBiTbWXDGPFJ9NG1+yjkNGr3N6D2PhgnuLMJvdV3ogzYrwevpPDO5uPINQpxaI
         qVVT/DC8gbkk3QvADcKWGFlR1dPzxTgn0EWBf5F40BMVHpBeJYy579+UGiyBv5DklqS1
         8mRpEJ63q306+8hYJJ3wan4q/ORqFgcwPuQp5nPBE+Kzr11wMRwXbQPaYtp66x5qkezK
         tXIjZ+Zhw0mbMxMvaL6ODB/+EKl7vOauzthLuSDN/TT7gJ02PCLWgBFtpSsogKQqXq2E
         mN4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790182039; x=1790786839; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tAQcvfsEw2NREatFJ5f2rKVMnBOJ07JjjvYvVs9Yqug=;
        b=gfsCC10oludWEWd9NY23yYD26y3wzzLFRSh25bTE0awtIPwPSUTIUWdemru+mPtSTY
         JSelw6b4ndKAiUADPF/QE14JHqS+edDihHj4U9jIGRDELJnXKwWyYDacpBssasDn5XZn
         /XEOlewF0TlDU5A48co8WJ48uBpJqFa8fomFbyfLvHQz8RdeG1BoSARNXixCPZoWXUoG
         L+PFWUn0+t1VPwgmDw+3OQzK9omD5JrCFu6tNEEj/3gYh39FgUgeOEx9WexhhCU9BstM
         uLZDy5CGnLgmIe5oVZGXo2L9rvH0nuERFpTh+G8DnMCq8OteQSVCFkN/fMCXdSSyuT2w
         Ai1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790182039; x=1790786839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tAQcvfsEw2NREatFJ5f2rKVMnBOJ07JjjvYvVs9Yqug=;
        b=TIFSgzJn7j3/yHl0PFEvmjTXMoGHt4iVM5o2rql2/DmZhH7jR10igE99R7mvBiL7WA
         IdxZ7IbtQGMEF9dB51GZ6xXcrvg6LRoKMBTt+BL90lyJMggdSVWMQrYi6GmF9c0pqeDp
         AqiF7gHjSuSksN1Rl5IlRIJW75NYdl8nau1TMUDWF+vWG6iXi746yxjf46rHf0BQADhO
         y0Cyq/3aGBFbQMhuQmDwFPGwd52Wb7iXFOyshMQwj1pAISjMXvKR2bLqAMPeKtxnY/FB
         q/CHraK/qiQzrlBKO+UyvI43CeumqLvW8d9mn/voBXAeYQaiyQVtBYvOZOgYlXmrbeDa
         SQ8w==
X-Forwarded-Encrypted: i=1; AKwUvByvce9HOzST2i/dcsY+Tp1xOntFRnHhZZmL6KGSWPozpWFohVq5+qjwxk7yYlSbCHbWQOL9I10NDg==@kvack.org
X-Gm-Message-State: AFuF++mxo087SgyXkKfcxuMXJeHTL6jd1URDC19u+B8XUr4qyLmdFBfS
	38x5kdPNxJr600n3Y1CKLIOxpU6Q9BFXyvnYYaEsZbeQunDcNQ8CJOxKVKmZH9jFYHVBIuYpoIN
	8E8shB1jTV7hh4w+V2S646A52BXyt50I=
X-Gm-Gg: AYBFou1iwTAggsaDjdOAoBQ5fFWxxKEYahVxSjc0qi17D555OKdPrxVP6Ryf7oUaVzp
	CIi83ZLzm0yiTVL09cD9QXQGYV/F3EJ90tl3hmssaN+zJ7O304EVBApCuSNz1BKBdRWnCE9mfXQ
	1ZkBSEu0dK70lIS+peka8eqdKNakeouhoyoSE5IS+1Dok7H8pEKHkGJUmhnbk6Zm0GQdVQdMAVc
	DpdoTLcTZYy7BcQ07A9mmkEraCjSZPMxJeXVcfJwX9Dzz6O3fwLlPcNCwPcg12AliP/ANroLK3m
	HfHZa4mHgBZkW9yulHuaO0GnFQhTAzmWUtgRYHW7uH1yMiAsCRnR0WzUVOkJRbIS3M4VhV+8TU1
	JTNwYRjOcmqXWRQ==
X-Received: by 2002:a05:600c:4e93:b0:49c:e27c:6b10 with SMTP id
 5b1f17b1804b1-49fdee0a952mr49666665e9.3.1790182038728; Wed, 23 Sep 2026
 09:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260923055139.2982-1-sj@kernel.org>
In-Reply-To: <20260923055139.2982-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Thu, 24 Sep 2026 00:47:02 +0800
X-Gm-Features: AclHuK-q8bibuGsWXEsNmxKAcN1nnzvypJ4ztbgQ6XSyFRq2oe6A825P900qgHo
Message-ID: <CAN_Opa_d=Dta4hRcvXuyi0wj+uoOgLxOCuHU3K4d9o34e_Aypg@mail.gmail.com>
Subject: Re: [PATCH v3 mm-unstable] mm/damon/core: keep the temporal tuner
 quota over an unmeasured PSI round
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Karl Mehltretter <kmehltretter@gmail.com>, 
	stable@vger.kernel.org, Lian Wang <lianux.mm@gmail.com>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: pqca3y8jxnqtdoqmr3dfwpgrnuam1kne
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A712B120002
X-HE-Tag: 1790182040-697353
X-HE-Meta: U2FsdGVkX18n3GxBi3UIr8V4ChspKcUs2CHJOUZQ9vL7uUMS19YsNQxb9deKy4QY93Au2xTAWCu9Lp3XaIsmIPOg5diIk1iwppexwVrFaF+o6FOnGy6tleGWZO9qdan3C/xvKg4yCckagVdjT/5LPSkwAcDkUjFiyRXPLJsYMhXWpq1QwHH0ZvLjPJN/gXPl8J2NRqfj1uRhmaDCqPCbn+H7nauMs15fNVjP8obgq821Gw0oZHHjZ9EpTfmJzwHCVQ/ArXcQJpk0teuq/0t9RL6rvRBH1itaVBOlGUdE7r7VqiFsVuW9jlQ/TaFyFW76J9uexECHK+vHkJR2kqV1upjEy3KyXLlAoduQS3FZyKd7UvIhF+njTpZtXX1LkVoZL1t/9ETGEcVlX7Kvr7U5vIWx40RsOaRHU5f6Bki+Tp9HrbQ7zpCNTcbcwCKGiuYnRq3hQUJcgK8AZvVmkJJlxLDI52KdYB0/0rSwBgS3PDOtb7c6Y3phJv9cvrkOMB3SxlgOaEyFxKnPA3JupcWe5rAw5wqFphA9MJY0h3CQNHo6c2iQrA829UdYzxkdK1ZpUsXohVSpmEJAJNKNzsS0nLKMUTgoQlb90TUN6Es0qAxcER+RhiUaTz7FIZyEi+3vyr+c0DaEKbqFycCwwkekMBxpm2l6Lk97IHfxSl8MItNWzp8gFKaObqBIKFEjVM1/ZHPdC6p0ikbWlTFF9cG3CvUlIEhdSC7gOQIGuJfAbfs29vVXnXU8etuVqw5u2uqqzyH0kfrx1KQ44n56k0H73Q41WfwwoCq0p/i/U26XisoBDnZh3gKtebWHP8NQMzHmruGL1EJHoBaXeucqLDPUOFyPaOr2ISAhQ8/egyOxkpjkEkIcEwrjvOAqCPNEwQ9fP2PdkLYJRav2xt1l2sliBlW3QAQQ8wG67UfFsoDrYBbEOp13Iuujj/OwqaeGCnefaStAec+vd7EMW9oOU8H
 c7N8/Gu+
 d5SKl8onmscdAzuK6OGMFGP4zZItVe9ElffK7eRdjwnHW3NI3JWN2MkhZQAOXPMcaWsxMw58Uct4dklmOHXVjGF5JFukxHVrGaanPO5/v/XaaUOU28SBARHl7DXLMVrBnN1c44/+8V4fuHxxjqGMN/xH6PTo6aXJfD+Nz337j2NWQD9CblUTBeVqGBNHDz2xU6PxEYQ04uaap/LHNOIGwDnwelfm4MdpWjq8P20v2Xx8LGvKDwD5vysG7AZcYpNycwikIi72XN+77hNbK2MmYDF2oYfo92ClfDRl/nrJtiRdsQZ8qSCZY16x4uxRGR+vmRIqZEkNV5kvw1PBD2C/ywtT39u94Ye5X+TX/ai9KwBUyV2xbrQRAPA+fq2krqGXUKl7PVyHEUIF9t3SgBqXzD7aNd6LxejNd9KOpbfDtGYueDRAPCdHAUCfaZvEsLJk5V7pavq5RyPKtMXYSXEobOxMrDa8J1pVuuyrNz2nZ0Xc/R2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the update.

I also checked the issue I raised on v1 regarding unmeasured rounds.
The temporal case now uses the effective quota to determine
current_value when there is no previous PSI sample, while measured
rounds continue to use the PSI delta and update last_psi_total.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

On Wed, Sep 23, 2026 at 1:51=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> From: Karl Mehltretter <kmehltretter@gmail.com>
>
> The patch in mm-unstable of subject "mm/damon/core: handle uninitialized
> damos_quota_goal->last_psi_total" scores a PSI quota goal without a
> previous sample as achieved. This leaves the consist tuner's input
> unchanged, but the temporal tuner sets its quota to zero for an achieved
> goal. A running scheme with a nonzero temporal quota therefore loses a
> charge window after a quota-goal commit.
>
> Use the effective quota to preserve the temporal tuner's previous
> goal-achievement state during an unmeasured round, as SJ suggested [1].
> Score the goal as achieved when the effective quota is zero and as not
> achieved otherwise. A new scheme's initially zero quota stays zero, and
> the consist tuner's behavior is unchanged.
>
> Move the PSI current-value calculation and last_psi_total update into a
> helper that takes the current PSI total. This lets a unit test cover the
> unmeasured and measured rounds without depending on system memory
> pressure.
>
> Link: https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org=
/ [1]
> Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goa=
l")
> Cc: <stable@vger.kernel.org> # 6.9.x
> Cc: Lian Wang <lianux.mm@gmail.com>
> Cc: Kunwu Chan <kunwu.chan@gmail.com>
> Suggested-by: SJ Park <sj@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
> This is a fixup of a patch [1] that is still in mm-unstable tree.
>
> [1] https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
>
> Changes from v2
> - v2: https://lore.kernel.org/20260921020013.33105-1-kmehltretter@gmail.c=
om
> - Split out of the series for squashing into the broken patch.
> - Collect R-b: from SJ.
> - Update commit message to make clear this is a fixup of a patch in
>   mm-unstable.
> Changes since v1
>  - v1: https://lore.kernel.org/20260915060937.3423-1-kmehltretter@gmail.c=
om/
>  - Use the previous effective quota for the temporal decision, including
>    when it is zero. Keep resetting last_psi_total for new and updated
>    goals.
>  - Move the current-value calculation and last_psi_total update into a
>    helper. Test both tuners with explicit samples and check
>    last_psi_total after each call.
>
>  mm/damon/core.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 4687b909d42c..733025b36745 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2956,6 +2956,28 @@ static inline u64 damos_get_some_mem_psi_total(voi=
d)
>
>  #endif /* CONFIG_PSI */
>
> +static void damos_set_psi_current_val(u64 now_psi_total,
> +               struct damos_quota_goal *goal, struct damos *s)
> +{
> +       u64 last_psi_total =3D goal->last_psi_total;
> +
> +       goal->last_psi_total =3D now_psi_total;
> +       if (last_psi_total !=3D U64_MAX) {
> +               goal->current_value =3D now_psi_total - last_psi_total;
> +               return;
> +       }
> +       /* uninitialized last_psi_total; make no effect this round */
> +       if (s->quota.goal_tuner =3D=3D DAMOS_QUOTA_GOAL_TUNER_CONSIST) {
> +               goal->current_value =3D goal->target_value;
> +               return;
> +       }
> +       /* let temporal tuner show the same achievement as in the last ro=
und */
> +       if (!s->quota.esz)
> +               goal->current_value =3D goal->target_value;
> +       else
> +               goal->current_value =3D 0;
> +}
> +
>  #ifdef CONFIG_NUMA
>  static bool invalid_mem_node(int nid)
>  {
> @@ -3208,13 +3230,7 @@ static void damos_set_quota_goal_current_value(str=
uct damon_ctx *c,
>                 break;
>         case DAMOS_QUOTA_SOME_MEM_PSI_US:
>                 now_psi_total =3D damos_get_some_mem_psi_total();
> -               /* uninitialized last_psi_total; make no effect this roun=
d */
> -               if (goal->last_psi_total =3D=3D U64_MAX)
> -                       goal->current_value =3D goal->target_value;
> -               else
> -                       goal->current_value =3D now_psi_total -
> -                               goal->last_psi_total;
> -               goal->last_psi_total =3D now_psi_total;
> +               damos_set_psi_current_val(now_psi_total, goal, s);
>                 break;
>         case DAMOS_QUOTA_NODE_MEM_USED_BP:
>         case DAMOS_QUOTA_NODE_MEM_FREE_BP:
>
> base-commit: 4b811cf44e3dd87981f18631be832027385f7d4f
> --
> 2.47.3

