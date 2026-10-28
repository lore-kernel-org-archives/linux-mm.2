Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9970960A6F5A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dR4CJaEK
Received: by kanga.kvack.org (Postfix)
	id BC5726B05B3; Wed, 28 Oct 2026 14:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76166B05B4; Wed, 28 Oct 2026 14:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C4E6B05B5; Wed, 28 Oct 2026 14:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 761076B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:13:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D8F61601CE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:13:10 +0000 (UTC)
X-FDA: 85372831740.04.E1040DD
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 16F211C000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:13:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dR4CJaEK;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793211188;
	b=01LtFD0tGRNS0zjqbH+zmslJrfmwr3aPGONyKIJTRVc2kNquYkY7iHwFne+HLmeSL6OEAi
	TFHn9lcp8nz3vS/37UX4xtKKtQAQ8LgZ1J85tLt77Lhyt1e633jTHjYOIMkuG5SnUbPOdP
	EMVj/MQjOGoJVCWIFDDGnbvfYsF/wxw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dR4CJaEK;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793211188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6a7dafXzCuVY0SuKCn+C2WrispsSpIJi0yQgUiS0Ew=;
	b=lI4aacFjID9pWIte8dj+3bjv4wh+WuNLw9Z/5gSnOrwGIGA9cYRT6K6+FVcHIjljzQTOx/
	gxIz7CXzXnHGBxhqskKFnfWR7A6Qau2CoJj/7xGqh3/ouO8c4AygkB10nS7/wIb4RE2sjg
	9ybqMv3sp79CwfHh/R7aRU5yYPGaMXA=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6769322f226so143683d50.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:13:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793211187; cv=none;
        d=google.com; s=arc-20260327;
        b=nHHd63KmjcmhufNTO0OUMHruS/4p+TadQiwvrBxMaI0eqXFB4widSIll2g9ZCfemr5
         9bOkGsyvWMb+Jy2kUpAgeSstBbmsRxpXOHLyexWGrBSeO8AUylA6crknp995aod8xK0M
         HLTc3titQxZGoNedvNwtcCu6Q0aXNsDB65MGxQO3P+Tfs03WGaTCN588znPiDZTCDUT9
         FmxnqReaEyhCxsn4BL5FILIlQcE1DOtn8EapUZF1lXn5QdDS0bxL3oTR2pgpP+g3SF3Y
         IyH2Urd5bw0UY0iBlBdsmVjBHjyIQZoojULWsZ1SMexZxJVju3IcFk5WLHJGZpIbT3aA
         0iZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=V6a7dafXzCuVY0SuKCn+C2WrispsSpIJi0yQgUiS0Ew=;
        fh=BFoE/mtvAqDS9b1IjpQyMqO2LxZmfHsUZL9AO8XC2s0=;
        b=QL2eYtLKMJUnedO5URDPgsa+PN6xtWUMgolrrANygGikG/78Qzol13Ev292xNOfrwD
         cAi5mCzNBeudbJF+YDektLADH2knricVuHm1IE8ueDNCLgsqNcAHUgGSxE1nOv04v4OA
         eGxQ0HsBNd1TII9epakuh0RmlEZYDnvhitKel3z0pFca3erWdwSxBNslaPl3rKSq0lh0
         w+krqeXhWTicrANp+TKbRSAfCOmh1KBiKXzK+XcFY8F0iPgGLFs1TpGsqfFh+7MNwRP0
         GQUIQ8wMJXyuCcdRihRacngp2ipzQi1ASgdxxa93RhD1PTybk0cGJdkj2HPpPXYQDhwx
         oPmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793211187; x=1793815987; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V6a7dafXzCuVY0SuKCn+C2WrispsSpIJi0yQgUiS0Ew=;
        b=dR4CJaEKs8rvK9FblCEm6j1hVyBIrRHlMAIqa75SXTWAcn3JE9IXJnlKY0tYGL2SPZ
         H+vFwM1f9zl6s8us7rICsoNne10MneNoU80GiQQa9FghJYI6tobRA9VDQwVvLrA8+iwl
         C7xZtr/GRMZF80cg2qzHIlMWzl3ffwlWyTEKbsnUbpYdF4IEPv9ay/QDAIwyCv1hs8P3
         21n61UYRSrvmJgvYA2VE10gxQvUUcqU6PdypfJfOo2ZnQPNQQ5uid0EF8kyEuBh49J2w
         0CS2HB+fVRl5W8ZAoN72Ov+5PlUYtG/04m5WOT76g9tcOn6ha1AgBCMBEXCfMbzyb6gD
         J18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211187; x=1793815987;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V6a7dafXzCuVY0SuKCn+C2WrispsSpIJi0yQgUiS0Ew=;
        b=q+kTAAcyq/YVUARKzqFhGPBiL/DBMEzBTePjcJfdPoApcyQLDgGPvc93nIraVJbS2U
         rtAFicZjJnee6iJWAslkrRMr4WTsNW9C8LJpuHVTKAFmPyf5Or+aUD4iO04U7eJsMyZ9
         UzNZ4BaZVsJO7ZTNmUN4EL3vizuBd+C6yRoJoq/63Gto2CSD4CWzitDy7Xa8Sm3ZwxiL
         Tz9vRaxBlJJe9komfZJhzSzACMCHW/zNs4BQ3KF7ONbnhOlkNJvwH/A4iIF1B/9dIBlC
         QNYMzAcMEZTk/uePKXv86Qg56YCffDTIy2AQ1jgrUaA4Pru9Avl9METCt4261g2RAONV
         A8yw==
X-Forwarded-Encrypted: i=1; AKwUvBwQKX0oN7uGb3TArGYnkr3Kuw9SCQ2f2W0qHJ1uo1asgCDkiY4YxL6wqe5V3/Kig0BiUz2VSMdE/A==@kvack.org
X-Gm-Message-State: AFq9FYJY/BwxXj8d3qHFx4Ol+M01DDf2UswTQSV7pm/28Q/cZFeoI6/M
	tJ8n5qjUqEoennOWtijnZFziviMZdQzjuJ9SFT68dInZ8DmS+08znXd/XjFmC5knp55QDRkbaTs
	zX/YA0knlWKIuv5WUxf8Dy9fpzKPGf7c=
X-Gm-Gg: AYBFou1TDkqmWyWLSXvVuiLjXd0OFKyOT/mwTRL4eHUXRUmLFHx8EIDxWDY62lR0rk1
	TuVvQTURQUb+7BxxqjVOf1luUiuNvNSyjvUXq/MX3pTEg0JbL0kuuUtrlwJebfpcyR+SinQ1+A7
	FCZ4QKDS+hM+0seYPhULF0azlgatH48YWeKJm8GOnMmanmPAykHtNMFElE9/1lMdrKwKMSEIgvs
	w/9c5LTCiZe0UVsRTenPmEducyj5bLY2ZX2xTaJPO6pSjOe/GxwudVERWb41XFSULsb50cWZQT0
	3FWxE4tPlqvhPlfx8+XoKZW2XnXmrZVwWxQAs9H1xzOtA5s95c9Z4OVlvT6v1OkCcaMttY3urVm
	HW2Na7lrCgnQqEQP8abjOM+KcrFjrIjC2qSM=
X-Received: by 2002:a05:690e:dc5:b0:679:b8df:29c with SMTP id
 956f58d0204a3-67a7b9c67d6mr4419227d50.2.1793211187215; Wed, 28 Oct 2026
 11:13:07 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 11:13:06 -0700
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 11:13:06 -0700
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261027222557.1072105-2-kuniyu@google.com>
References: <20261027222557.1072105-1-kuniyu@google.com> <20261027222557.1072105-2-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 28 Oct 2026 11:13:06 -0700
X-Gm-Features: AclHuK_GqFk856IAy32S9yAqvvqTMrzZbh6E4g9ZbLF4Vu3sAjM9QAsIhJYmt6w
Message-ID: <CAPAsAGzCBA0HaXNYHyaw-UOxcsE-Kr7chQhikEXNNAHQ-wYQqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
To: Kuniyuki Iwashima <kuniyu@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ekxzw3t8f1zbsn58ucysardqzz63b7m8
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16F211C000C
X-Rspam-User: 
X-HE-Tag: 1793211187-286971
X-HE-Meta: U2FsdGVkX18l2bsUWkbf7ZbPlX2Gk+xAr0cW4dxkw1mGvM4ig2/AvW5o9Z/zAK99+BHt4plWd4p93r/FpLXure+5p+WJ+Bhoncjqzvag+LAI7NQMib9li/p2m5d8bf84cDCx7zaybQYszaD0k53WU2ul8IXX8NSaHuG0ffAHQI7BkgEH5sKk5kd/hraaMkylktW4wOtEU0bJNtcLMWlFeDospYtA6x8LOzjXF25KOMTvSv1paapKgS6pUs1w2xtrCuyn3PJTUc2/DhynxImHcUpGULY3oEPpVscoshMC0WXNGMoOFcNjb5av9HCSguSplEGJ0/lqsBg2DpUlpYZpkCk8wDY//qZvNBAT3MvFO3/1bKBtN1QNhTp9cXRBu/ts3N3A4Hie5K2tcMvmkeECIQLqYQhvo69T/K7i7NZOWLDe0DzmSp3+9hz6uSeM7BaxffSN/fTxB0Hi7VsUaPWFP0aW5s/1pr0gSLLTRrV/HsB4tUJr2uQPp6MHQ0ldlDET+ys795nsVsTA+8+HIw7mlyglEFUpL2KrxurAS0tXn+Ow0l6q7CqbTRq6eF7gXf/3+5WEwROptWAxhRLD/Uh9PqmIniFZN9HPa01O4Pm/W3ZIjuqkljZWcy0QNCybiJiSAHuMCFhSNEKR5DfaadpHfxcvZO7cXYdi1CIkpd8udkZ/Kgob1gCWde6y7tOjI2s5if828hX0Rf/KzPcAEAc7qgRTuYRsiEGNAFb5kJv1EpNyz2aMok3g5gKKwsiwasaAYr5GQ5k3fURYB9L2SIyjPJscD5ECXxQnBgX4qxtQJXs01Uq30Zw8w5jap0VSY1QNh9LewxJG5l5zJ0z9ckPmZe2DvOGigPK43ox7c90slKAEOMH/SMZLq7JUX+lre5CEpUM/Twy58i+9Qwf5o8tPHoZ8kRoPYP4H3sqp1VjhGvtAoBxHSe0+rYAMhZReM+03iG/zPGrJABd7CqFgyo8
 KR6cDQU7
 gkwYIWV2d9M8mordkFf3N/GMEBPhUSZLy3KHNX2HhNJTWQph6GFwejqja8DYxiTG2aTE7naSCP7ML45cwUd0hnn4atr2Rc+mA4lIOPF8UqtV7sioPh0JkxC1OT0lXkKzsOOOcpUiFK3U9E56vhwkxqN3OUXTnCpJkjDFp1XRuded4H+8G9ZjPiBQHBQP3D3rO+TKliuU4RpBa4Dv3+CKgtG6TFML9h0du0NyDTxdnkHzGEdtECy7Iib3vzCr4lofNRXUSnLeu00YUveciorEfigZO9KZeBgT1+cNuLf+TCpseF4t9oBs8qatdKHKMY3jxbE/Aw+hTCVChvIDsjMoqvk53H//Gqz1fkOxX8rlQr38vcJA4kLSLj37lG3nVIHUCSfBdr6CQ+Ae6CJKal1iBfZVsfqJ1q3dqCGO8FSp+suPcChLt35fo984BUVmqzpod54hkVZkegG1expOuN9j/KaeR7E5z3pZLn1Nz0U8Wi46xDpibmw9ARsTmxwFzqsejR2dDkOsPh5VdrKzffuH+/pm+AYRuAgIi8OkxiS6dwNHwen7JyQzCP2JiTXCVHjf4jmdCjeZ6Va+qwnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Kuniyuki Iwashima <kuniyu@google.com> writes:

> syzbot reported a weird use-after-free splat. [0]
>
> In the report, an object in the kmalloc-64 cache was freed via
> rcu_free_sheaf() while it was still in use, even though the
> object should always be freed with kfree() (in xfrm_hash_free()),
> implying that the object was a victim of a double-free involving
> kfree_rcu() somewhere else.
>
> When kvfree_call_rcu() frees an object via kfree_rcu_sheaf() and
> queues it into pcs->rcu_free, debug facilities are skipped, e.g.,
> kasan_slab_pre_free(), kasan_record_aux_stack(),
> debug_rcu_head_queue(), etc.
>
> As a result, KASAN cannot detect the double-free at the call site.
>
> If the object is still in the KASAN quarantine when the sheaf is
> flushed, KASAN can detect the double-free in rcu_free_sheaf(), but
> with no trace of the suspect.
>
> Worse yet, once the object is evicted from the quarantine and
> reallocated before the sheaf is flushed, rcu_free_sheaf() silently
> poisons the live object, resulting in a false-positive use-after-free
> report on the new user.
>
> If __kfree_rcu_sheaf() simply calls kasan_slab_pre_free(), we
> can detect the second kfree_rcu(), but only while the object is
> poisoned in the KASAN quarantine after the first free:
>
>   kfree()     --(poisoned)--------------------> kfree_rcu()
>   kfree_rcu() -> rcu_free_sheaf() -(poisoned)-> kfree_rcu()
>
> An object queued in pcs->rcu_free remains unpoisoned until the
> sheaf becomes full and rcu_free_sheaf() runs after the RCU
> grace period, so a subsequent kfree_rcu() or kfree() before
> rcu_free_sheaf() cannot be detected by shadow bytes alone:
>
>   kfree_rcu() -(unpoisoned)-> kfree_rcu() -> rcu_free_sheaf() (too late!)
>   kfree_rcu() -(unpoisoned)-> kfree()     -> rcu_free_sheaf() (too late!)
>
> These cases can be detected if we call debug_rcu_head_queue()
> before kfree_rcu_sheaf(), but ODEBUG splat only shows the second
> free.
>
> To detect these cases with KASAN, we just need a 1-bit flag
> to indicate the state, which can reuse an unused bit in struct
> kasan_track.pid. (PID_MAX_LIMIT is 1<<22)
>
> The bit is marked along with recording the stack trace when
> deferring slab frees in kfree_rcu_sheaf() and checked in
> check_slab_allocation() so that any double-free pattern above
> can be detected immediately.
>
> Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Tested-by: Alexander Potapenko <glider@google.com>
> ---

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

