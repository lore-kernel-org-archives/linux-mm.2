Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269D1C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 07:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C5A6B0093; Tue, 15 Sep 2026 03:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEF86B0095; Tue, 15 Sep 2026 03:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBA96B0096; Tue, 15 Sep 2026 03:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06E886B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:04:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 052731A0336
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:04:22 +0000 (UTC)
X-FDA: 85215107964.30.8519ABB
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1386EA000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:04:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tMYRanjG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789455860;
	b=FKzGyyZ2E6xqDI8c2PYNVF/uZkz5pirnqMHeNj6Wq44cZRlACySAg1cDsxe2kIfCJwZPaj
	odtN32S2cVp221MfpycT4atqr8yh6trAhUVRuVnewpdOBOq0UCp1F2Cvwpph4H1wALM8vF
	BGc+4szENYNq2o+Wbs4S4/i2aYZtbWE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tMYRanjG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rBX2/r5Oc8pD3Msk2TcE9A0RNIhE2Nvsx1mMLMnh+I=;
	b=YX3C5tkNv33qUpBUuLFbcmizX4+weL9tFHylqx1eD2nXhEXKVhm82GwAf8fuR1syCtZral
	GXAKMMbq7T7qjHRRDVhY0f/D6niB/d/00DrCkTFea6yEPc/ijdpvpSX7UhpiVps7pltsBl
	Xvq5AP64TO9j2zCQWikuc4OEF7UhvMU=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so45259955e9.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:04:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789455859; cv=none;
        d=google.com; s=arc-20260327;
        b=OyUeq/0hofNH267FrHn1M7v7MeM9VMb37WE08q4PFkyu1Q54cACsubp6IKxzbxKIOO
         CcXafr3QFrB46RwYdQfja/h32ViMl1UyEHc1pmQQzvgf81F/Eo2JvFDawYO05oKa+TXV
         DBYWL5Nh/DuZRKuj/DyQZ3Hi5GngY7mTdGMFOLM9wUaws1IfSANjje8VR56mXafCoFV7
         wIhhOflnmBue1LAt1UuduZN52bh+qmWksht6MLzo5mb8xfP3VIAk09rP4RSO9kN8MnEW
         p6Ljx5FamNVDapMu9KefAf0zTATI5BjjNB4Iw0Mz3YyoaXHYrDa7Gm1V7EiV7hWEfZt5
         ZuyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5rBX2/r5Oc8pD3Msk2TcE9A0RNIhE2Nvsx1mMLMnh+I=;
        fh=KJXXTSovU+AOPKFKeTO5fZ/q6hOo+aZe/m4EQdNCsGw=;
        b=KQh1gcDGF0u1rMBNECMvRCurqI2l7IIo2fLNEb83lnHbmMRvuBRz6+KrbkXo+b3NMQ
         A9aRE7lZuFkyLSQxc142cSDCZMWY25p7iLaE3tZLqqKm+vOU8AeHzh/ESRU0goZqGKa/
         uyaS5Nj+2kYhQD+CozYCj5/n7PWDbZY73ubIZsrvawGpEI80sEX8Ou/4Foqkd+UDAI0M
         AraFXIZbQ9+3tBd3Z2MMEVgsn/fOI5zFWHzwg9wAK5F/LWMEouTEuxlpF5Uzikw+yuGb
         1n90PC+Yc/UP66XTtnw1IJgu89zCi2qzRrCSv2KC5cXcMZeZzBtfhDGRHBeqWbLOLB8z
         vVnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789455859; x=1790060659; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5rBX2/r5Oc8pD3Msk2TcE9A0RNIhE2Nvsx1mMLMnh+I=;
        b=tMYRanjGcuQLrqQhxvT0zHiZ/rziTD1YFauVNwGiornWM76RRSw4jWotyZ6mDgldhM
         rWBp3s/VO9NNhk2MSOZKPxD9OKQHc6jQyC1t+eXso7S0pvzeDKrgCDGXjYGvuKdygnTk
         9N9HQ35css2Ubx69B2DzmihAMhNWFniWJKD3al5966R5ATrh1EK0f041dRo/CMaPeXBq
         evS00285pD7YDG2ISzRS7kTSypi5on3OzALVPSAJZY0oxpSQaXdjGs1C23SJgjhYQWJj
         1fte2BkH0fX0eOuePADo8c6zJJtSgUYXl0Tzty15mTZuNHvzhMyLW8vmtYzapU+Tyt4Z
         /3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789455859; x=1790060659;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5rBX2/r5Oc8pD3Msk2TcE9A0RNIhE2Nvsx1mMLMnh+I=;
        b=sIONwsGbg6qNTU+K6e7G9cpyEUiFCe4CCK8nhMsr2pC5TtZLzwumZ+zayhdd69kZ7g
         TIxv786zO4S0ghfpJWag7+zeEU9vreTIX4CcasnUgqZSShDO2CKBhDs+SURyANKsQGq1
         TXYdv7xPNH85YU6vg3e7rbP4OGzBHs5v2E6SAsjQI7Bi2M8L6rmlHoDNqTVzUUuO8WWA
         ORNYnRXF41O5Fs+OvhcLnA3jUlFTeZrYJWX0coLebpAlvEU4/aXffmGCBwXzhj/mbvoR
         ltpVlEO687+pR2zZU4822vFjfxsR4C0E4jcJPQMKhDaip1l0Su7fvZb335fLVxZekkYK
         6wGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwfrXDLXxnWbqv93FdEU28TjgfaC9ImuBeDs8zfpKaB3zdlhTN6oO924i8kmyu/c0c3Y6VJeJHSig==@kvack.org
X-Gm-Message-State: AFuF++lzAaU+c+IzpDnZRnsFUAX+I9dIfNj5u/q0ao031ORYNu0oWuSb
	XyYNybZConAnWQEsN7RhrNfjChjX4ZiNYAxcXwvUJkGgL/v7fgPbu1FihfW7isahtlT5t+3ht/U
	9CRzsLTUleSbboAF63VOC+hYnraUeBv4=
X-Gm-Gg: AYBFou1hcNyvSj6UQcJ9Yj61ihM7fx3F+SizkL6sBP5KKytVR45W4aL05PU53ECA58k
	zaA24Pm4HYItTlz2q4L98JeTE45PZdRg/o9NnWmw5UiRBJpfW7Sny/W+/bVMIPh3GhdEMNgGNFc
	K+5uVxmSN2tXJpwNC1hnSHC6vPWEjT9wa7VnJh0N/ZVITIdCThlZ48TCVj7XVagnGY9LplqnjPO
	1FVc5nij3Y1RVcprKfa80e5wjeRr32HD7rgnnQG1SvlSHtEXYbqIqoPB8T9SYZNUdOnGJF+a9LP
	csvJ8UC9XgwsGT1JTGH4RwgbbyasHRoxfUfGJsIgRu1F1sRER4LDtOoUmz5cogEsCUTDqR/8BoA
	db5hIa/k77n3zeA==
X-Received: by 2002:a05:600c:6218:b0:49e:7423:687c with SMTP id
 5b1f17b1804b1-49e7a65cb0bmr63673125e9.1.1789455858317; Tue, 15 Sep 2026
 00:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260915060937.3423-1-kmehltretter@gmail.com> <20260915060937.3423-3-kmehltretter@gmail.com>
In-Reply-To: <20260915060937.3423-3-kmehltretter@gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 15 Sep 2026 15:04:06 +0800
X-Gm-Features: AcwNN1Us-54OWzGUJ1Z9_Z4eN7azOm4Uvr77tQtD9tUxI7JjaSi59KP2yTRjYgg
Message-ID: <CAN_Opa9rS45S_MHbmf63KC0LY9AGAdAC5r=vv_qcYMVAenWosQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/damon/tests/core-kunit: test PSI goal rounds under
 the temporal tuner
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lian Wang <lianux.mm@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1386EA000A
X-Stat-Signature: 3crehstjfxq5psdfrsojy17dq9zyjhzw
X-HE-Tag: 1789455859-560240
X-HE-Meta: U2FsdGVkX186IPuNGkYq3HrbJjH1YpOEJcqSZ4wemtxdEpm1nQdf6dlPcSBTYzIL1FdQib9aiVo3Njli+MzE9Vk+h6sZuACCnZz2voDp4Fr7Y1dFouA5wCIots+4LxLvIPu0+vxw9Wpo5JkdA8W0/De69cQZR4iXB9zRgnLQdPQtxjR4gpKAAS84uSKp8Wq+J61toAyKKYOgV4fZqeKEL57CQa3dpVg/CvZt56X2956fIDDbrTfDry6hL940RXNlV4wpZf7I0zVwiUxIbmyeZwSw0Ac5OG3SYjFxwg/4dEOiz3pM6gh4voCeLWa8HG5u5tk37au/obrZAq/laTSK5QsnbvR+BxAaJqsdtRnWPWMXcZrQrltyKh5uhTuQIr9noZJOpXSxbzK0VfGbJFqJoh6qPnHJkriDXE6eOAv9cxD2cIxMbOtxC5Rsi8T3eGvRq7PybdZVLx/8KxXnsDjcyhOVv8mErt7t4YgfB3xJR1khy3T+nrFUh+GalKo4VePBlEDdunHNrF0lBg+FLIya/UopvPu7/9ctKBvvp7Fv1cZEOtaKCsan4WmgZDPKHNXFBX7dqbtt/GrYjB1B6f7oTm0dZ5pNoYyo8wUm8ocbVCWIC/p+drShxm1qD3jd+8yYELpliRoxclPBBd4qIyZNIvDmPDvjbwx2McXAE1L0eZkEcozfHUU39pNGzR1d7icC3z5k/FaK9NeFuWu4I29/4RAgesSQItqd5Wx/J4x3yhkk1oA6eioFk/uMIwVj5dDifTXrWgqX9cAsjIWcG2fJ+hg13eSWUgw1VUSkQXOVwpKlN+eZsfvJS7CTGKmn0RYzRoKDvYamqnWAi5Me5BSTWRNXPKMSxvLAPEAAeaX4ZcS0iMMVBV6SasUuvO9NcJ6VUoU9wtmQ6RBy0DPyiI+MKVLTgNP9sq+dVHuVzNSoILCRCtpg4zPuKrUv8ZL8TK2ngiusVeCClHUJ1CANdIK
 lpQLQlRp
 wJF+JN5BNPXRaxn9uJDc8Bm9u43eaUfm4v5FbGb+MJ2na2umjXf512KR6x5YZZDwZbXnRKXrf3/SEwosId+u9I63BpKlcUzWwK2kXLktMXpwr1u49Os4ZLuf8q2h1yKGTsmPqVqYMEinsLXMsBEC4KHpGKmLE4NNF4Fo+o6NLTJs8stR38bkqH4ZxVT3NJUKXBLHSvdQ8uTOneYui0VvBX+C+HC6JO5gIe8zIJsJPKqoGKF+JZHRRnRzJaJ5/7u7u8kQBqg+haWp0ps8c3CGAXryoeUX1bG+T76HcmNSylnsmyCWhoOhiyq5Pvq+HG8oRB91QbOiUUtUP6WPKnIxdcMUAZRe4ZtoKYXyrXxo86OQ6xuBys485dnsWLNqWDAyX9DzLqRUcjP9yv1l9C0ycKJqcRLRDVo1JZyyjrCHmdy10bMyRYGO6kO3aZMyd+4/CeQ+J2chwiV3UvkVpk6cQfGzSvUaqaJIcR65SXNKF6ewA977HYsXiXqNi0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 2:09=E2=80=AFPM Karl Mehltretter <kmehltretter@gmai=
l.com> wrote:
>
> Exercise a PSI quota goal under the temporal tuner on its first
> round, its next measured round, and after a goal commit. Use
> ULONG_MAX as the target so the goal is not reached during the test.
> Then check that a measured round which does reach the target sets
> the quota to zero, and that the consist tuner keeps its quota over
> an unmeasured round.
>
> Without the previous patch, the first and the post-commit checks see
> a zero quota.
>
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 69 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
>
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index c01e6a75cadc..2b9b24ce7dad 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -889,6 +889,74 @@ static void damos_test_commit_quota_goal(struct kuni=
t *test)
>                         });
>  }
>
> +/*
> + * Unmeasured PSI goals must not disable the temporal quota.
> + * Keep sz * 10000 within a 32-bit unsigned long.
> + */
> +static void damos_test_set_effective_quota_temporal_psi(struct kunit *te=
st)
> +{
> +       struct damon_ctx *c =3D damon_new_ctx();
> +       struct damos_access_pattern pattern =3D {};
> +       struct damos_quota quota =3D {
> +               .sz =3D SZ_64K,
> +               .goal_tuner =3D DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
> +       };
> +       struct damos_watermarks wmarks =3D {};
> +       struct damos_quota_goal src =3D {
> +               .metric =3D DAMOS_QUOTA_SOME_MEM_PSI_US,
> +               .target_value =3D ULONG_MAX,
> +       };
> +       struct damos_quota_goal *goal;
> +       struct damos *s;
> +
> +       if (!c)
> +               kunit_skip(test, "ctx alloc fail");
> +       s =3D damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
> +                       NUMA_NO_NODE);
> +       if (!s) {
> +               damon_destroy_ctx(c);
> +               kunit_skip(test, "scheme alloc fail");
> +       }
> +       damon_add_scheme(c, s);
> +       goal =3D damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US, ULONG_=
MAX);
> +       if (!goal) {
> +               damon_destroy_ctx(c);
> +               kunit_skip(test, "goal alloc fail");
> +       }
> +       damos_add_quota_goal(&s->quota, goal);
> +
> +       /* fresh goal, first tuning round */
> +       damos_set_effective_quota(c, s);
> +       KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);
> +
> +       /* second round: last_psi_total is initialised now */

Could we also check goal->last_psi_total here?

The first tuning round should consume the U64_MAX sentinel
and establish the measured state.

Testing this explicitly would lock in that state transition.

Thanks,
Kunwu


> +       damos_set_effective_quota(c, s);
> +       KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);
> +
> +       /* commit a PSI goal onto the initialised PSI goal */
> +       damos_commit_quota_goal(goal, &src);
> +       damos_set_effective_quota(c, s);
> +       KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);
> +
> +       /* a measured round that reaches the target disables the quota */
> +       goal->target_value =3D 10;
> +       goal->last_psi_total =3D damos_get_some_mem_psi_total() - 10;
> +       /* U64_MAX marks an unmeasured goal, keep the sample away from it=
 */
> +       if (goal->last_psi_total =3D=3D U64_MAX)
> +               goal->last_psi_total--;
> +       damos_set_effective_quota(c, s);
> +       KUNIT_EXPECT_EQ(test, s->quota.esz, 0ul);
> +
> +       /* the consist tuner keeps its quota over an unmeasured round */
> +       s->quota.goal_tuner =3D DAMOS_QUOTA_GOAL_TUNER_CONSIST;
> +       s->quota.esz_bp =3D SZ_32K * 10000;
> +       damos_commit_quota_goal(goal, &src);
> +       damos_set_effective_quota(c, s);
> +       KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_32K);
> +
> +       damon_destroy_ctx(c);
> +}
> +
>  static void damos_test_commit_quota_goals_for(struct kunit *test,
>                 struct damos_quota_goal *dst_goals, int nr_dst_goals,
>                 struct damos_quota_goal *src_goals, int nr_src_goals)
> @@ -1887,6 +1955,7 @@ static struct kunit_case damon_test_cases[] =3D {
>         KUNIT_CASE(damos_test_new_filter),
>         KUNIT_CASE(damos_test_commit_quota_goal),
>         KUNIT_CASE(damos_test_commit_quota_goals),
> +       KUNIT_CASE(damos_test_set_effective_quota_temporal_psi),
>         KUNIT_CASE(damos_test_commit_quota),
>         KUNIT_CASE(damos_test_commit_dests),
>         KUNIT_CASE(damos_test_commit_filter),
> --
> 2.53.0
>

