Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23D9C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC87F6B008A; Tue, 25 Aug 2026 12:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79486B008C; Tue, 25 Aug 2026 12:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F996B0092; Tue, 25 Aug 2026 12:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90A5C6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:55:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F40FB140112
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:55:53 +0000 (UTC)
X-FDA: 85140393786.07.E45740B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2271B40008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:55:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bD/+50qH";
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787676952;
	b=dlq4rripKAVGE6G16zCni940BJ7DwaVlE8WdcQsv4A9VgIvShUmliaGD/XFifOduWETbiy
	h7WDeGXP0wxo5VeONUq/NhsQisYzTJji5leTP0gjCCyhQXQI0hfEiE3iMtATCs1wOa2X6A
	alFotzwZFFE8uKK+YN+6bnWTfET7MPs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bD/+50qH";
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787676952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtodH4ePqYNUd1xafLHkHKnE2CTxkQO+HNMDBGq3kKQ=;
	b=SkvtUyqu2+ra+Y8MThKeUHySr8tbfnQwx+s9wjlLlF+gTnjbeSmwxTa7ykItSSENUXJWoJ
	OKdEv42Vm+uq2aQXFaukXTltTKxI8vruzTwA0omA3vUPJKj+QalbIQrA9pKN1IVX0WvpoW
	XPIs/F3ncJ6rplpFQPkxY8duXl/Lxp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EC3860A77
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAE01F00A3F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787676951;
	bh=EtodH4ePqYNUd1xafLHkHKnE2CTxkQO+HNMDBGq3kKQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bD/+50qHXoV7t67vDJZT72HJWp5mnQytMtwe4Nya/vG0E9JUmmpM40g+uWCKUrHhG
	 7T4s54277nqzWRMv+ymmT6r4SAODdfVjB84gyDiKEaDsnd2YmDyUP3af8kZFJWpJMI
	 D8qB04dUrVg0fDRh85WIk2DCTpZtTBDyj1ID+Ti9EJguMMDGAOCh5fP2MZi7QlMHrD
	 OFPMpTiRWOEtim2bcqZRvIMhBPlP1aFaaOEb1k5hfA+0huTSqTeT4W7f92KpQ2+c6Y
	 v3Rm0n5Qf11v65z1EO5UXmkRexlulzyHmrVkZvuDnWGmLFOrkhYZyzmP6mGDc7Et/1
	 UH9RVSIApYbZQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15cd3fd760so616452366b.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:55:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoA8h21NZgDpscWKTkdFzeo3VcbKKXAM7E1ZjGO/NsbOf4Qoes4YUkJBpJ2EiWtKE9BPj3UQcR1Hg==@kvack.org
X-Gm-Message-State: AFuF++kt2c9gUdW4UCbcGcmbK3eZGSZG1r0zUJUfYdoKLUpe0pQz3JqV
	SIRYxX245PDu80VnOCPRKEOUD1b6hBwrI93zKPTfsW0cwAum9jYdjDadRWS39Nirrtl4xydgKB2
	DepsBvWOx1kZbu2ytC+gmOA32OovdPU8=
X-Received: by 2002:a17:907:7a94:b0:c25:541:fd3a with SMTP id
 a640c23a62f3a-c250bb76bdemr1260666b.7.1787676949864; Tue, 25 Aug 2026
 09:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com> <20260815-shrink_zswap_entry_0815_v2-v3-1-0171bd86a667@gmail.com>
In-Reply-To: <20260815-shrink_zswap_entry_0815_v2-v3-1-0171bd86a667@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 25 Aug 2026 09:55:38 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOGUKnyro5G7p8dnWchDKJ0KWobJSPv8aRw_R3QnjvS0w@mail.gmail.com>
X-Gm-Features: AcwNN1XhLX7e-NhXbAWqedG1K-cjSN8FsgLrD8FErtrkVatFmBGV035fO2ZasGY
Message-ID: <CAO9r8zOGUKnyro5G7p8dnWchDKJ0KWobJSPv8aRw_R3QnjvS0w@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/3] mm/zswap: release retired pools via call_rcu()
 instead of synchronize_rcu()
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 1cfr5147oycsydqmazxgnpaaerf99wss
X-Rspamd-Queue-Id: 2271B40008
X-Rspamd-Server: rspam06
X-HE-Tag: 1787676951-727497
X-HE-Meta: U2FsdGVkX1+IM2Ub9ggAqsrG0Vgiu8oCKEs8q1kxK+i/9MHCG2rTGrA9qhLtDRZC4iwLmQckGOV/bQNJI+9Q+hFtwaUm2aUfYTYig1941mDWJqv1mfCs7uTXG0paixINARYQYkvc/8HJiIcN1Y5g0Wd0jlZyt/ywuFAJnMCWuRLUn/CzRa6HJRLloXHAfm3RkL8RUNi0aiCCQWv3S8U9zBZb+9uIbedjWa4YfRPkUjyUwNpR/c6N+S2tfEZBdHLriMzPD7SrYPGpQRj6lPJKH/vLId8L5rsfUrIXP3Gqz1zCJBVhqq5yU0y7oukKhRGFTNymjoHD3nkgc6SBWL2h/8aoQqPTpv6ax9zsWcSUtPZfEX1LdV70jWupX/4+EOyrLtPX4Ol3I7Hhl0t0pTtALUUSfL4+HqcUoArz8zQep++IErU9O0L7ei3cIUMeBnwDrQY4LgHOizfA+aUTAhTA3GIkOvWG0/gcYxjEgY5ZyBtiZ82Zj+mfQbyM7Hg3R6jaQ70v9O48iNUiMHRUFmpP2IYAx9fyidNXmEQ20dR9BAUXroZICmPY40uCiuX0MqO5DGd+MEH7OpvAphGdrKRBJX8Uo97AXgH7mByCSxxF6by6gtwzac3/LS03nItmqMu7xYmHxT1AiBnbHIaFErirdtn6oVmQ3nRdOhhqxwL976yKa/Nt2XQnCxDguY39C5YLn80lcCNVoa1lFYwscq4kIdRCARKRXByJW+NCjusCUOWpFo+JItOa1RCf/xj6JCeNtUES4ZKyjgEnGWiRfASck8MoOQLKOr/HNdDFxGc9FDTR2ZgK6bBFOgUAcdFhv72lTolEVuXLgHEompy2Mp+92oqIOsRFTjCkw56ogF9bNbQOIf2bwwd75SEBySuyUbrQtCqKoocn86HYD+59aj1Ho9zuBizhA1lF6RWBHvl77ixQBSLtHnlwp/on8XhsKAaKcr+05e+c1mBNolXzjBc
 /qqXLoqR
 Cbjo2GHLAXJNmrJ80xPMGwFkvIzNQSO1ieo3L9V3mL8bi/0MifeQLvKy8bMTpzMnkHCLTqEUzYI91qaq84pOiYgAREURHrk8rPO/B6kLyJIg+UKW8Cr0yucUZQIGwsnzS+KXuKfgALTlSUfa/NXHJfiXtEHjm4A40Cz4BIb8r2zOy61gf7CBSHyqMoiuEjY9+Ig17l1qa0sy3qqTEe3oLCeuEo3OrOoNf4RFpg3UXzneh5OzjP3cwTYdhNuJsMEd3jrNNcD0CN9CyXG9P82RyPem7OYCAXr2bD6wyHk8gu4zdQpOt72cn0Mb0E3VO2iDSEnZOBf2dEZ+sRWpwqGnvcwiIr3hvj2BclTqHw3sUFgDEuM6WzESSJNZvvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 11:54=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com=
> wrote:
>
> When a pool's last reference is dropped, __zswap_pool_empty() removes it
> from the pool list and schedules __zswap_pool_release(), which calls
> synchronize_rcu() to wait for readers before tearing the pool down.
>
> synchronize_rcu() is a synchronous, potentially long wait.  Replace it
> with an asynchronous call_rcu(): __zswap_pool_empty() now hands the pool
> to call_rcu(), and the RCU callback defers the sleepable teardown to the
> release worker (the callback itself runs in softirq context and must not
> block).  The grace-period guarantee is unchanged; the retirement path
> just no longer blocks on it.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e..cc4243356e21 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -155,6 +155,7 @@ struct zswap_pool {
>         struct crypto_acomp_ctx __percpu *acomp_ctx;
>         struct percpu_ref ref;
>         struct list_head list;
> +       struct rcu_head rcu_head;
>         struct work_struct release_work;
>         struct hlist_node node;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
> @@ -382,8 +383,6 @@ static void __zswap_pool_release(struct work_struct *=
work)
>         struct zswap_pool *pool =3D container_of(work, typeof(*pool),
>                                                 release_work);
>
> -       synchronize_rcu();
> -
>         /* nobody should have been able to get a ref... */
>         WARN_ON(!percpu_ref_is_zero(&pool->ref));
>         percpu_ref_exit(&pool->ref);
> @@ -392,6 +391,20 @@ static void __zswap_pool_release(struct work_struct =
*work)
>         zswap_pool_destroy(pool);
>  }
>
> +static void __zswap_pool_release_rcu(struct rcu_head *head)
> +{
> +       struct zswap_pool *pool =3D container_of(head, typeof(*pool), rcu=
_head);
> +
> +       /*
> +        * The grace period has elapsed, so no RCU reader can still obser=
ve the
> +        * pool through the list it was removed from in __zswap_pool_empt=
y().
> +        * Hand off to a worker for the sleepable teardown, since this ca=
llback
> +        * runs in softirq context.
> +        */

Oh I didn't realize that call_rcu() cannot be used with blocking
callbacks, sorry about that. What about queue_rcu_work()? Seems like
if we use that we can drop the intermediary callback?

> +       INIT_WORK(&pool->release_work, __zswap_pool_release);
> +       schedule_work(&pool->release_work);
> +}
> +
>  static struct zswap_pool *zswap_pool_current(void);
>
>  static void __zswap_pool_empty(struct percpu_ref *ref)
> @@ -406,8 +419,7 @@ static void __zswap_pool_empty(struct percpu_ref *ref=
)
>
>         list_del_rcu(&pool->list);
>
> -       INIT_WORK(&pool->release_work, __zswap_pool_release);
> -       schedule_work(&pool->release_work);
> +       call_rcu(&pool->rcu_head, __zswap_pool_release_rcu);
>
>         spin_unlock_bh(&zswap_pools_lock);
>  }
>
> --
> 2.43.0
>

