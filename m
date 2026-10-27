Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BC7606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mV00BLiX
Received: by kanga.kvack.org (Postfix)
	id 8951A6B0707; Tue, 27 Oct 2026 08:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86DD96B0709; Tue, 27 Oct 2026 08:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734C86B070A; Tue, 27 Oct 2026 08:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486A46B0707
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:48:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC8E08099E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:48:46 +0000 (UTC)
X-FDA: 85368385452.22.44F8012
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id D75ED20002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:48:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mV00BLiX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of glider@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRikYyGwbdnPYSLwmUXp7oJp/UdHT2/wIJEnDpsdz0c=;
	b=2fHa4nbg/6VwWKaaPM0IqSMigSB3iimbRuF4x48jVuHaVwj/IUSujhZqA6J1SnnnBfja2y
	1KMVq/66cMxGtbeWuP8hoBYVnsUze/dW22ixMTiAWCiOyQCCepTVOXC0TCMmOaUv+4LDyv
	QaSwyT8xnZIBDxOhzfYVwYcH5UfLtIs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mV00BLiX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of glider@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793105324;
	b=PZGHmgyO3EqvTcmi9bIpmX2LY9Ch75V3ale6O6rgkwZ6XU8Nsid9bmtlqP0EvSFw0Osa7L
	qk6reT0jQkZE2udP+7E45jm46LUcdPRuTN0Muuohhnt+0Dz3ThZ/ZqqqDwoOOwMFgitQju
	xDYtLds8W7lio62vtBMwEfBFlyxJXG4=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-185fd3a4ca3so3571079c88.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:48:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793105324; cv=none;
        d=google.com; s=arc-20260327;
        b=bKy3koqvnQDwo5bCXg3OuE+TntlxbBe8eJmdBbgycymEY3nfqIsSKZl/svcROnZPnb
         +C4yVA7gxUsg/aasjQ3s+umIB6vj1B9EnCiKeoHnN4KhZNrnXGLxHJPmndE0OxkG6tUC
         +Uc7kJZn4Z2DRDyzOOrpsz10J+OgTwgQCz76HzxdKRFRM4xxtC5gDgdzPyhCT2q0GVJ9
         +qIwiD8qJaeURmRfn2LQnqnIa9P3OoQYac8/ix+dxtdHsVCNvXlKavAjNKopvQex6rpf
         jc8TZcjhOkvAXMI0xPAe52Pls062z/9wcooxk77q4bQrxB4oRBs5WOGvA5/dPStLM8vR
         XvrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pRikYyGwbdnPYSLwmUXp7oJp/UdHT2/wIJEnDpsdz0c=;
        fh=kUoWYci6SWQEH4MMw7JFjctKHdzw2xxt6kdzTjhMvB8=;
        b=es6a8e6YskEYeIUEFFhEuUMH9F4AZsA60gAYy3Mj6QhgX56+Ht/iLBPRSA9mlPh+ux
         Z7wAyjbttfHYU1/K7PiZIAMBznNwPaKnKnjRWDbcKuB6ssrmNz0GuV2tXOg7UuyL0Ik/
         ZtTHwZIcSB8onK3kujPVf7NZaGXNnntLRY5JpiXk15q24o1tRFYgLgEykMaSgSAhAB2j
         HZTcBOONsotKKL1MGYwsOxp6P91MDTQdiiUmitWW6W8cAiHv9ryXaW9B2g9vF4gUqCPD
         yc2DPwkxHCFVNEY1XNj/pp1G5iBlZNCI/hEQntyYWO63ROWGvHB/gcRAt8J7QBB/Dg+q
         p03A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793105324; x=1793710124; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pRikYyGwbdnPYSLwmUXp7oJp/UdHT2/wIJEnDpsdz0c=;
        b=mV00BLiXjboUAADVMHg9+sbnyVjfI0nSUZlZn6D2fj3QGNprScAvJNjwwBGJ+FOZGd
         26XT6Y0gtiHZ3vXG7XD8/iQwNCOO4sz6rNA4TVJ7wvgpHpkHm2hrLuQuAAs8u6iBkgsz
         KPSIEz2w4Qdc2aeU3ixcAuw5g8Fd3/TawPAw2/l/UvHTzilCH1J/tGhdtWlnZiBu0fE3
         Y/nRyKpMCuHJ49OnvKlFgMRSrZJrHx4D/nn5pbjf8RqNQGJhtPwYZWLR2QaIm22kt5P1
         OVvoYnIjJYKBhAeSPSyFIg3XJNU0Roklez0bRPvHkHpHJlwRbxo16CDn5jLc+rwbQHKd
         yQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793105324; x=1793710124;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pRikYyGwbdnPYSLwmUXp7oJp/UdHT2/wIJEnDpsdz0c=;
        b=doMF7XKNPl4NPkWRNe+IYVnzpERlPNukVGGnYeTC0iVw1AQ+6OVEPiA539yBGqrPsN
         s4svK/a0i8IxdGFfkZj3aEBUWe8MyIYUL6geobCs06GKCgICitN7QrZkz2ZruXwa7nsP
         7qozoUXLskWogR1qrTkqY1qWb0zaqDc8jtNKFKauQHfaYBhtdB8j6nHKcU/N3pue6aLU
         uAPAdn1cU1B8G37inb9t50tePRZcOx0cdE33zVR/u4zxOLij3MzeSRleH8mvX7Ksq3t9
         0nqy+x+Qm5bCbjqVN2UOahsu6bEUIrQsodcF8Qy/Osr0oqA3RZToAC7sDFe0MgqAp+wH
         zpNQ==
X-Forwarded-Encrypted: i=1; AKwUvBzG3pTaeBIoqqLIyobbH0r0pUX1bDFmxFLXMK2W2Alu2sKxekGsSdUikrwqxnceH4qvFkLgkdgIqw==@kvack.org
X-Gm-Message-State: AFq9FYLhEz2/cE/4SWR4DwT68olVvnTCo7wyWmtTxR3Ddqe9dEd9sbTt
	uYuWocgu49cvdIYMKCA6/TmYfU7T14MPwuIGeUi2OnvQ4ZpV3wqtmOUbXaGNTeAlcUOihLNjlCn
	h8GCgCSxa3tZ6deMjLKSEA/Ryj91UTwSLMJ5nqY1a
X-Gm-Gg: AYBFou31UPH+X8rM75knihaOM8I7TUIttlFWIARakPNuBgSjuhpMlujCO/1VMaKzU5f
	eyjH2jjY6ptEe6RhjB/LgtZU0IYL1CHMAe5VuzgM3fj9hIX1pcxJsR7vrc6vlfjS/4Vs3BX6uUG
	xpj58gzY+j2zfi1fKYANFfvx3evmXh3RdTsj3n4qBgOiTeyXVJDgARz1AlpxXtIQpu7BMUPfIhA
	2uW/kdY1PXgRuHLP3MYBoK3GU6kyUem9YdJcSv4zCJiKALNnBnzw3hQCF0H6PMDsBoQ2z7T+Gyx
	Kkgb1KepOUp/JbYemSxkutoJcc8xF5ZGkPM9MjUsefQKxawd/LhYV9+OndWzjAYMJcFnoYItzNx
	lAnPd7h2b1vng4NjhIExuLnRUyNrAiGeKvWPNA7YH0VF1ujPVrvwgQk/g5xRb6j/Qcw0=
X-Received: by 2002:a05:7022:f503:b0:1a3:8d5f:6f93 with SMTP id
 a92af1059eb24-1a38d5f6fa1mr3742509c88.17.1793105322524; Tue, 27 Oct 2026
 05:48:42 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261009214639.2878857-1-kuniyu@google.com> <20261009214639.2878857-3-kuniyu@google.com>
In-Reply-To: <20261009214639.2878857-3-kuniyu@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 27 Oct 2026 13:48:05 +0100
X-Gm-Features: AclHuK_sedPkChg2GEPpBwSlXnlzTTkUxsjGSqQuV2hvVswVw7VUHJ8Y8wILVBU
Message-ID: <CAG_fn=XQXEdKSNG5L-dPMoNA-q_CmQsZ1G8c+jXaGBBWP5Jpmw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D75ED20002
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j1m78y5iy5k7teiekemewzw9q8ixxrej
X-HE-Tag: 1793105324-28005
X-HE-Meta: U2FsdGVkX1++fyaMCIYNVc1H30u/1frKO698yfVbSDX3Qyl8iVcwQZolX+vHEcRb/MXwpJEOShAWE27IRq1uCytLCrAE2TUqewmAgFJ+MlxWvji0uLHvW4bnf8b5C/JPvOrcBsiUpuMJZZB7QLubhsi4ABuWaNecXfGjC5PEc4zuETNCCe0YlUukTUVYGv5inJjBW/k3jiiUtSsoP9prLjr5ANBLBbR+yFjrZZpfRVGfx0twoiKK4FtZwmlhXeZBLUS3JCqtO38dJepbhNZJixnNKdquWCDkMvPsvTEfs/+UP6KZy5WovwkdQ43wedyOzcGxH0pDepEhrSyUcjcr7t7BUekQapZtUjTQ1eEP/kqysRwNgD8SBDddN3WBObrcaJ/iQhu8BtJeOs2GPpqT7SlnfFDVIzMzzKTcRRqJXM4kkRn3E6s35h86EKPLI/WOSUhq4uUkwZpwa74mUKJPhE/KXmgziEhSFecCWnSfgKUfQqcGbxmJx5kTEOzteMDVargUsp4rvk/AvKn3gePEJp1x9XOU44boQzDXtG1Fc7mt+Kkcmw5KtRjf3/tTGdKR/0Axs6hNeZH+6D/zAEIeriieKrAFmb8hUeK293J1INN1b1V28CZD1ySs2OQNOFzm3hLa+WBCDlg5PFls/Da3XmdSfxo1PY/Zygjg+tfEMc/tijYp9B9APHDHaX+5ZJq6tRd0AmNoPI07FVqLHJ3KPBUwYe9IjLUsb5kpx+/dlmDj1ksL/StFlSggv9JDkrn7kt41/1ZP7f7Y1NqD0S4ldaWdX1M1n7ojmOKaOo2lF4y/lse2i8nN0Zd08yGkdHKp+HRSYWrv0pHpD9Uf/RAwYeJZDJMK8uuNxhEpfZEYyDbeRNcnp/LJprV0f9h9R9OJVarKWpMX/xApLBUjhye8AXD5miJBgHq+1ojyKf9RL5SYMXsBaUoyuXAYPpZsfM9knaDnKF/WW3//oKpl9Ed
 CulcGU5d
 0BuqcGa3GRzCFqHReXstVkkWhQZWBE+pI/TyPUXxsPpV1iJIsDVZglXxVhF9xFuA/uoy52gJlQzbJm6lnRXr5uxPf9RUpYnu5LkEf8gkbj8H0nqJcmKn105WgOolSD01+zyI8qBXlOBOcAVM4llywKIcMjeBv77NeDGZc9M+iM6HqFXloGJR5XddZqH02Ottbttlg3H9BlRj/I9OfjEjXcLwkbm8qu/fxfwh3YzeNGq4xn9k/dpSeF6D5cZOnRE9ok3dN5f1R0G1PJpD8wOxxVHFZgTjGDqcHkNc2iMp4P4TRBfkryZ5yyx8+qKa9XFtFh8vgb0zI4CIuKegZFL9mlet6snzSm8eSUUaWTB1K2q3hbYf2AHUPICxUUHAYI1pfCD73
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>                                           ^
>   ...
>       ok 2 kmem_cache_double_free_rcu_2
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Tested-by: Alexander Potapenko <glider@google.com>

> +       case 3:
> +               migrate_disable();
> +               kfree_rcu(p, rcu);
> +
> +               for (i = 0; i < cache->sheaf_capacity - 1; i++) {
> +                       objs[i] = kmem_cache_alloc(cache, GFP_KERNEL);
> +                       kfree_rcu(objs[i], rcu);
> +               }
> +
> +               KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
> +               migrate_enable();
> +
> +               /*
> +                * Move the 1st full sheaf to quarantine, keeping the
> +                * 2nd in pcs->rcu_free.
> +                */
> +               rcu_barrier();
> +               break;
> +       }

Unlike the existing double-free tests, this one can misfire on a
healthy kernel: __kfree_rcu_sheaf() may decline (local_trylock()
contention,
alloc_empty_sheaf() failing under memory pressure), and
kvfree_call_rcu() then falls back to call_rcu(kvfree_rcu_cb), which
never sets rcu_free and
ends in a plain kfree().

Could you drain pending frees unconditionally
(kvfree_rcu_barrier_on_cache() + rcu_barrier()) right before
kasan_quarantine_remove_cache()?
In the good case it's a no-op and the victim check keeps its meaning;
in the fallback case the stray kfree() hits p while it is still
poisoned in
quarantine and is reported as a double-free instead of corrupting the victim.

