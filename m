Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A22FCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665A06B00DD; Thu, 25 Jun 2026 03:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C336B00DF; Thu, 25 Jun 2026 03:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553536B00E0; Thu, 25 Jun 2026 03:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30A5E6B00DD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:31:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B31941205D8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:28 +0000 (UTC)
X-FDA: 84917614656.06.50A6483
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id BEFDF180003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OQn7gs5v;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782372686;
	b=F0p3Y/VEsFGFtORcsymcCvHiQWazfU/KBmiVJPIhCY+w5CZ3xJgzzuqie3P0kB64pC17pQ
	V/kGBoTqp3+iuZiT/HHS7m6MET1sQ2bgn+CsXZ5pP+cts9gRd/4KTR+Z5ni0SdyTBciL6u
	d0uJfEgdCcgUCgx0w8U1ypVfjqXcHDY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782372686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmk5iye4ZLJubb/NNFsRnqtpnOsNy5rDxz85TFxoSQg=;
	b=Ck9HKIVbJGxzqDqSkw5Peiaf1Frq12EtiqATV2yIm5jRQsQerkbQ8eUsrUVNCbum5z0pys
	ss7p+BO5u8HEdlZT+v+cTQZvgU1TiU8gQYRHjDHy0bPZKJt3BK1ju8WwLwoWD2BqeaapAB
	1R+kVNpuRB20epicTGApcGYGfvG0hZM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OQn7gs5v;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6611669cd16so2196667d50.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:31:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782372686; cv=none;
        d=google.com; s=arc-20260327;
        b=Qs/g0PptcbOYHR6I1tSZ0XLk00haWLfnfww81yKsBFwIoGdrhh7ci10In3K4wKLKVV
         aOBjIY+p2Ilpf96TzAgy/Y0LqFOYXpdRlCRvDyxGTL4d4xQtf9kJQdd5fzxjCsJU6WiI
         QyPL84iGKJmj7RVlPM8+FHa0BQ0H63/Wc8+/3uQEBYb6PRMnXnwOc7xOC50ykCLtxiev
         O97lYWnZN6JDersFh1Lrb7cdemQyaq3tCndI0mIW2n0XOnJKRK3bHB2LVUBX2QLP7yPZ
         vZi0loMxK0VaAhSkiSa+gt8WCklEr7XEZVzyHkiG+/fwOF+SIdkHfgiUxkdUY8yJNcya
         TBOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kmk5iye4ZLJubb/NNFsRnqtpnOsNy5rDxz85TFxoSQg=;
        fh=jbUPc1CNrZQHgW3WsD+N4amLe4HDKKHOVMbWGX/OJy4=;
        b=d4RuraawOW+G9z9+dJ9IwSE/JjHB/AslFY5a2s7kct3XyOkhnrkL1n0C21sfoSxKvo
         sdwC7kvEcbnGLmHCNs0LqzPxMrpACt4zW58gZEO8IXFUE/8R22FW5REci4w1nU3HaE2W
         vW9voWzYjAoDUYJsNNz5m+25sZodtJnXhbABK+Bs3Xh1rqZQtkfko9DuSWLSNXvEsTle
         cgxQMbu+pMHJHwcNYv85ql23qZmsXB508bDdhi27/Pc0lm0G1nZUWiAa4Ky5LcZfuav3
         l3Nl7ZM6retQ7fJeuQvcedHu5/ofVEEy4k1Zy/9g31bc8YgtF2QnoESKnQvyBbg4Q3ku
         aGDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782372686; x=1782977486; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmk5iye4ZLJubb/NNFsRnqtpnOsNy5rDxz85TFxoSQg=;
        b=OQn7gs5vigw/n56244EON+aF9A6r755b2rQKC7XpR1dnKftl1QAhAkoGOLjiYSQWHV
         zSui5/jl99PSCtdM2AE5i7IWgdFcdMb+OcnOIC5iM1b8PXlajZkqY/NHZ2imC+kSEiuK
         bUXfi95GLgwAbriviLrkgLGVziYGz6jmYDwlRaIPMUoGVrtC93BsYYF5J7AC8k4QSdM9
         wod/cvXIMx3NDYQLE3KlAhUAgOXweQ8zFDigVcf+UvR23yXRZO7xcu6SXk1x7PAAG5a0
         bYtzjQDgK7kzRTfxsE/XjLtt4uHK9AeyTbBMNhyVlM5g/e3pRH5TnJ26IUZT/FqKEKbq
         VlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782372686; x=1782977486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kmk5iye4ZLJubb/NNFsRnqtpnOsNy5rDxz85TFxoSQg=;
        b=fU40O89eEDz/M160d1w+edqNCEVumNuD97wuJDkQnw95q4Xq7dyAcg44n+FE0CZdeQ
         6e0vlDsBO9HqTw2rQClxpxt+z1ZYc20fOpvBo3NM+7W542TEFghVlgJCcwkHeZrsshC2
         kf6pQUVh9Ikz5fWM6ig3hqrczrO4DT7Vrrl15+7DXarq9JA3aZDQ3f7G34uFgwVwGESp
         UX0TvExNfTub4+fEzvDx5oleKPfAv33y67xXnANVfADRxXBUl1/6Q/EXfur4nzupm3KP
         SQ+AfH/bRFR51FcKqzaXe9oL/LZ9GUsOlH7TCPCJlTS95Wic5htv4adS849EDCOlC6qR
         SZWQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp8eGwTJwMGkxtG+0GuCCQiQgZLXI/5y4zBYQnnaH/ubSLuU5j1ZC/VBmX1HmHt++sltB1Sh9q3xg==@kvack.org
X-Gm-Message-State: AOJu0YzN23ygk6X0XWTFns2GKysYoazirDb1f+XyNqCj1i0uyZIbISei
	BRuliVGM9V+6h6mthl9BDpIWoceRGbJmFWCFa28dvXW2KQwR6CLF54EPR7qg6TCRMplaQDKDJ2V
	QEwYByR47YbLyOfhGks2JX+RQvwhEi3E=
X-Gm-Gg: AfdE7cm7NxjDAS5orn4MNgJiRBnR+SoWT6NjcTvBJJL9tabytnVgCshShv1ZkySi8kH
	u1v34yZ//84L5qzve0GHMWLHQ2QEvab5GmafRFpJhBw2RWXSiGDFddqjOXhMbpk74po9EFhYHu6
	Vy9UN/Kki76l4bNvwIe9wQ+s9govmlisc7GBvzO7WoAI0JS4ebIahOXARn3aSjdKjEz7j2li/jX
	OSWkaBOUp/LxwbbDtrA9pbvBXtgn21jLVrxutBaR4333J0GKo+DTw6R1dE7DePmISaLMw==
X-Received: by 2002:a05:690e:b4a:b0:660:3f57:9fc4 with SMTP id
 956f58d0204a3-66487c6ff3dmr1015598d50.28.1782372685809; Thu, 25 Jun 2026
 00:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260617163919.2544899-1-ekffu200098@gmail.com> <20260624204030.3c8baa67713b6ca1d537baba@linux-foundation.org>
In-Reply-To: <20260624204030.3c8baa67713b6ca1d537baba@linux-foundation.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 25 Jun 2026 16:31:14 +0900
X-Gm-Features: AVVi8Cf16h4yiA49dDNq8I7QKdcvkwxM5V6_GYgQOYh9RMn1uG-9O3yjxShLOm4
Message-ID: <CABFDxMFi9e-GgC8scDmhOt7AgEUsqxgJfsg8V=A=yGxFj69DMg@mail.gmail.com>
Subject: Re: [PATCH] arch_numa: remove redundant nodemask clears in numa_init()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rppt@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, 
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9fg7sbpojmcq9hopt3yeiykn9ou7ybki
X-Rspam-User: 
X-Rspamd-Queue-Id: BEFDF180003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782372686-195010
X-HE-Meta: U2FsdGVkX1+CfNPOhk9bgSCKOJaJ5VZDF6EuT9jZVAaajhPhJuvPnUGTlNus5+TC3nJV/3mLqryvnRZ39mWyOiBv/m2zNx/zLQ9F1e1vrpIenyps0ivTsv9xb8gj0eRPzXQyXmYP6Cayt+Qd7V76jA+ozrfW72wP0jqv0iNH6dXJ798okKtjBVuIMDUZ16cnzB8812qO4+2xYwgkoUognWw04ftTDaHfOu0PKd+FhWd3Z0RBBuyDa1Kii94cAAzpFWvhvY+RgnLakS5NeCqChEsZP41W8xnc0aItNZRHvXPOEnzp23VQcJgjmihEfog1K6mng+ucfIhGSuNy3unwCs3l89FF5oLKJB+ivDQbnbQ8syaxRnLunw7qyJ2wyl0+tnHin8eOVlbzlWd51HXw7kTsBxwBiUX3j8Ll5fp8q2cV2dPByhczu/6G1nAoGhiupAocbse4uR/SrnOmqdzqy0mgJSktxbavHSPAna2n4jEAAtdAZB8QsdMBfDMccgfBSpuwJ8cOO+zl3Hf5qAGDAbfNrOnKkxeXEZAyyRUlB0lFUOCo9HfyCVPVFNM+2aVmTNVfhUj27eouO+gZEnRDlwPD5HZvkI1grVoVRsbo0NFedWoJvaZzcnml3pnhsdseZ4zz9IrZwrJFJ0nCjH6YTfAGTDBXkLwYfOZLO47NqhlQs0uk9xkODGm8djaTdHPQYxSvET88gGmc0IhoQJx+wRe3++damZT8FJ899YaZZ2/BeI9UgFaWgkLNL0W1STe6kdeiFyypeicPk25Vv4Ji9wTGxrqzzpLOrlgbJZvc+sG2e43Qsq2g/5TsLDMh70944p9oi1vt8Ezc7t4cgn+0tNagkbg3MS+qBKrDDF4XBmTPIN2x/uQjrHimySsw3eddp3Pzpb3I85qedRUoflo9HOCO9utb5bCRisSEvR6M1xW3DqggADfUasfsF9II3lf342uuF0YvuqpW9P35jnI
 ga+npC2h
 dwwTf3MpWa9tskPXqcV+DKfuEaSJEIJVSuq3Du7NNF9pP8aliO1hAE1E+Q4YTGRXjbJj6U02e0iXK7ZEHw9HNkZ65n5wLus7LdaBda09IxpcY7gh3OsE3ynuyKAkaPp8vC53ypNnKgWyz0QDyz38hCQEwGSsbzeUSkU4y47ILBDNJtMze+az45muRal+qvEElE38WVi3bAh7N7eB9Fc4BvEEte0+PbYIdbykMqnWY5I7WuO4xF2ykoD/Nbg0SyEUL0xhuXd0Suw1XuXwBvKZeMzqPUH+WRppRbedVxwF0s8sSw5J42opFWaK4J1L94kNmySdyVTkCw6/P2QgNlv9hdakmZwb9ST0GZXahyWITlO+s5tfTTirg32f5rbIMguCq6aybCnqj2cW6/mpOOMPJl0oao/bJ3QALbcwUznm9D+/5NPqY/0IZuyCgTvOzS2OFVTaollSoXD8ZhfgnjpPdRB50T8uaTOo+p0PtKLKSuyjupbNbqNC0gO6Q2EhgRyKWJNe7GECstDgo6hU+14LFHGMGdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 12:40=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 18 Jun 2026 01:39:19 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > numa_init() clears numa_nodes_parsed, node_possible_map and
> > node_online_map, then calls numa_memblks_init(), which clears the same
> > nodemasks. Nothing uses them in between.
> >
> > These clears have been redundant since commit 767507654c22 ("arch_numa:
> > switch over to numa_memblks") made numa_init() use numa_memblks_init().
> >
> > No functional change.
> >
> > ...
> >
> > --- a/drivers/base/arch_numa.c
> > +++ b/drivers/base/arch_numa.c
> > @@ -231,10 +231,6 @@ static int __init numa_init(int (*init_func)(void)=
)
> >  {
> >       int ret;
> >
> > -     nodes_clear(numa_nodes_parsed);
> > -     nodes_clear(node_possible_map);
> > -     nodes_clear(node_online_map);
> > -
> >       ret =3D numa_memblks_init(init_func, /* memblock_force_top_down *=
/ false);
> >       if (ret < 0)
> >               goto out_free_distance;
>
> hm, OK, thanks.
>
>
> A couple of driveby questions:
>
> Are the other nodes_clear() calls are needed - aren't these things
> zeroed when the kernel is loaded?
>

You're talking about nodes_clear() in numa_memblks_init(), right? If
so, I think they're needed.
Because numa_memblks_init() can run more than once during boot, and a
previous call can leave the maps dirty.

More detailed example, If we first try to set up NUMA from DT,
numa_memblks_init(of_numa_init) is called.
of_numa_init() parses the CPU and memory nodes in order, so if parsing
the CPU nodes succeed but the memory nodes fail, the CPU-node bits are
still set in numa_nodes_parsed.
We then fall back to calling numa_memblks_init(dummy_numa_init). Since
dummy_numa_init() only sets node 0, those stale bits could survive
unexpectedly without nodes_clear().

> Also,
>
> #define node_possible_map       node_states[N_POSSIBLE]
>
> ...
>
> nodemask_t node_states[NR_NODE_STATES] __read_mostly =3D {
>         [N_POSSIBLE] =3D NODE_MASK_ALL,
>
> why do we carefully initialize node_possible_map at compile-time then
> zero it within __init code?
>

I also can't find why we initialize node_possible_map carefully, at
least for NUMA.
I'm not sure it's safe to remove initialization with UMA. I'll take a
closer look when I have time, and send a patch to remove them if it's
safe to remove.


Best Regards,
Sang-Heon Jeon

