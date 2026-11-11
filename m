Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A069260A2605
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0s2AqJ+5
Received: by kanga.kvack.org (Postfix)
	id B4BBB6B05B2; Wed, 11 Nov 2026 03:57:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B236E6B05B4; Wed, 11 Nov 2026 03:57:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A384F6B05B5; Wed, 11 Nov 2026 03:57:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD256B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:57:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F17791A0244
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:57:42 +0000 (UTC)
X-FDA: 85422235164.24.97A126F
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1745B40006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:57:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0s2AqJ+5;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794387461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+2GeyeiktPWIYhPCUX0ezs+W4stQcbxkOT2VYFqeLA=;
	b=AUPLPkDieWblDa4CKbcI1jzEOp3jbAX9twMetIq0p79rm297DdIllBaeMqadFlYg4tYsN7
	X9pZ41T0c9TLnIotHpnHV5Zt6d3eGYAQJRgbEPKNolQ+vrqjyjNWReeNykB7bpqiG08wdp
	Z71SyyOtK9I+Pf1FUbGqZub7Pvykv8s=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0s2AqJ+5;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794387461;
	b=7OgQgPyE0v1k3aVwnWxFzs5npp1KcqjkOYY6GdkhE/Zzr9biKNk09wuakyk6f0QCWe+Fv+
	8u7FDb7q6CvpUs2DbzZxqQAqM8CV9ybKcegUmTA3PPAF3WHvhYOHKDAX0lxDiEic94xt0m
	fQOJXZtOlwiHMgwnLMe4rKbxoSFmFTE=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so4711556a12.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:57:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794387459; cv=none;
        d=google.com; s=arc-20260327;
        b=ecQAUKk1kXjB73GsNt10N4vJ2DiXyHojERVpd30IovhHawq+ZzyaF1Lqex333B7brw
         D3+Jq377dq0CihV5ja2XTfUc8/eYDcQm7B//Nq1JAh6Nh22HE6Xn6rqoT25ZC0yqbYkf
         V5V9RepwR9x64e1MlGNiDStOvm5EDNNzBBtg4RXzITZPPMqm2yfFO9bdYxTx7pKv9Ndc
         MkSKh2HWY8JB5HpGpbrq9X5jhXV7TXDgcsA/cv9s8c5nszgatIiSOcDHCcR9h1uA+vpq
         kYO6qCQ3teWdxyOd+JwISu6eeqhJgN/21Tky36w5YnvpVKUol5MAOgkStq39fhxOuLmY
         PH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3+2GeyeiktPWIYhPCUX0ezs+W4stQcbxkOT2VYFqeLA=;
        fh=2OQVFigy5xDqNSSiX4sC01zIDnjuykSFH1AHqlRPfTY=;
        b=iCcd/UQOfEiIVyL6mAVi8Dd++u/9yrTiYQn9kQdu6dkp9cva5IzbZxdwllHMDQdqvQ
         tkM5JMGLzhg90FpYM8HKDUi8pOVIc38/n6JzoexFZTTabN+LHElV1LTij1wtoIOwoN1x
         ERA2YHqBxlRFSpUS8lraDWlI+cLwcu9J+A4uJxLMSumme5wdXJBO30SLY17ngCj/fjD9
         HRPweX2J5dhseznpf24q/xn1zJ987XeTY/tsBL8S/9eTRQpDDKCC+wuER7RW/LKcBbhe
         uuw3ettDKYnrBMgTuX2vo6uc0BkGB3u6gyyWZ/cBA/b/Qz6+DwKskfOrPV7Z/2Tanhh1
         NkfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794387459; x=1794992259; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3+2GeyeiktPWIYhPCUX0ezs+W4stQcbxkOT2VYFqeLA=;
        b=0s2AqJ+5zUbG1IMXg8wDokQ7r+MORYqPsJmT2riG4pNna+QwVJHk6XIlzGec+98siF
         oxr/1xjg7h2faEJfLegLtrrXO2Li4rEKaDvvOa8vQUUD7/offZpQHQnpDhtXOCCfCpjK
         oPU3Bn0FHlcDJtzbobszVjg2+z5xDqJBki3xUxolxfNPRwRG4PwRsDAwp6txwiF88YCL
         8ZYM8qW2tE4V7cGHu8PLTAUcPd7MYdI6g4ZvlPRURYvpA6G2I8LA2gSt/+KfFeCcOgKf
         B99JuE7TYSrl4AWm/OzC6L5zGplYA9m3BOuVZ7YzUIdRJWmpOPiUYedrQmtlhY6N7I7f
         BppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794387459; x=1794992259;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3+2GeyeiktPWIYhPCUX0ezs+W4stQcbxkOT2VYFqeLA=;
        b=U3xInnRskpfuoGcLkNtKZhFNWVGBJ/57HQrr4OGft0fF88MCvo3n7eOuQUKImGHsql
         9T743oaJzt8OxyyopZg8i1XrncuxwVu8ndngjdNaL/7FUh91OpFvHWiauzn93DEvazNr
         lkm9aZsHZUtmLZCj8uaJp+GPMrEYAcc5q6EzxuaBs+n+y+6TCDHUHr/MMPeaG62nXEuJ
         1tXJKxdipED+S2ZCPnfWnE+cwEwly1BUMlga5nQtsgVZAhHSm+vszri9Kgj8GlbljzPI
         nGSZdRd2pa8yqMi/q91HUvC4T+rn5xvIYFV+rLCGHMfMHMWibl1rkfgNYL1SHpqCyAbW
         GMFw==
X-Forwarded-Encrypted: i=1; AL+hErGTI1xzBZGg45bVNNvmmE/dsfu7QXXv6hL08HfU+sj5Z0X3nNJkGt+kiM/xudxWDyulWDDiST86bA==@kvack.org
X-Gm-Message-State: APuU4Z+5KemcrwYZu1pNbE33mw2yv5ESiiFNKimTdP+6eVfRmWcdFKX/
	AU9Pa+cfBgZyPcxjc6lCQXQJ8f3kAOu/aXqgDWKc4fnsxJksXwS6/4nWkg6nYcxCksh+MGzzWbx
	hPs9vflpy2KCbsvvn0A+1yn5EOaxqRJk=
X-Gm-Gg: AYBFou0uHtpxchpqA5jCOlokjIFJ+zjlzg6UK4nTNRHL9RT6BMgxepkcv96/OjzPOSI
	aEcmo8aM3vsee0+W8QNJ7q+s8kDIYgVov9HyF3pxqhxrQSkF+ncZkYPC4fhr69mDzm3Hr9aYo9s
	AIYh7cc/Ft43SsqeiBS6t9Lh1gGNzOu29s5Sj1PcmAoswuTCb9zUHdGmqrLpLdCoqWsE5w4ky/M
	uPXl1u2wEyHgHlXp1pysRc9oE9k4Zyr5VyEOLn5/sDvTfSQ5Hjlui3Z7t9pFaUqMYz7N2Sw8ERv
	0Bl6MGuEZzsoIXu66MVsfk6urBc3wLfPciIIzk6w3oqVg9NEBezH467S29KqVl8DOBsndxEXNxm
	3QTRGVe1wE/x+4ndWDRBWcZsrzttwAAKUdvouihKOtD2LFTaUsfW5Y8nYRjNvWxOZOcnTCQ==
X-Received: by 2002:a05:6402:a512:20b0:6b7:dc8:c814 with SMTP id
 4fb4d7f45d1cf-6b7775eba61mr879038a12.27.1794387459367; Wed, 11 Nov 2026
 00:57:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111000913.22943-1-shakeel.butt@linux.dev> <CAGsJ_4zRycX9dcW6P1J2R6f+xyO4+z6_LXz1i+qbNbMEnYm9uA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zRycX9dcW6P1J2R6f+xyO4+z6_LXz1i+qbNbMEnYm9uA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 11 Nov 2026 16:57:02 +0800
X-Gm-Features: AclHuK-Ok8BVFpQUzx9SWnWjlX8eBeANeatd5JCiC55UEIemRs5iAoKwKc61kM0
Message-ID: <CAMgjq7ATR2RDZBg97ihoqDV-G8dEA+8XBy-G2xujVC7ZmMX8QQ@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a memcg
To: Barry Song <baohua@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Noah Feldt <noah@feldt.systems>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eibyq9wuw5qzajkff5i89f1d4mr35zge
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1745B40006
X-HE-Tag: 1794387460-366530
X-HE-Meta: U2FsdGVkX1+qCWWYpuzq0EsgoQHWzq7NrOE4OLumTBPDbCJYeKzEM3skqlZGeo3SdKim4eb/ryWYx957E/fBTKgTtdooSH6WHsnDJyHBEUt7aCZaIBBxK1JNaWTs9eVyrPsoLhwRimhGd/P8yXi8oy4q+RrnJmPiRPXJ9/g1Fml00QODD0upWkeSyuMWe/tHY/nCeSM3DPLYelRjjVFYHh6Ri/HToz0fe9hJusA4589jyY3o+vKVvO3X5CvTK6Zq32rZmi4savVSNQPFPGMORM/voM8pHXVmicpO/bu/3LRqNOo0wbOCUs6KZB3YvsNayi2OX9r3bOMc4Y7N1FTIQlk8DVK27j3njdP0TJe+xDBaBYC7C/KwgGBD7exNmhzRYlSiu2vuvPd/hm2pF/6wIki65q3NdoBZrPeDBEsjsvttYcjugZybxNTPW8U+uimu6rZ8jujFzu4tZfTCqILJTHTs8eyYnHFmli+zgKWxa26zbMT27Hp/mKyRU3ERkfjatJk77fxjdYDhSV1tcKqfKwhoHUxN5LGUNzlkOyFslnZgGO2ok5qeqnI3QrReItdvw3pkPyVJuDoNvuCPqDPxzjdJCAqmQO6oTPh2rI9D6wnWfKJ08xlJjNaFAwuUokIiSz/IFHa8kQOAyDiC4D0A5KR5KxLObysC/cdx69wQ3Ez4quMQQ7XMvpBvTAPGjJ/zHPBku3zcXTFaFXSeKKDW8sqtAGME10dbncZErelUTqiaaKg0VAF9uTv+tpzOylLIywcLyPwG0pb5PdnnonMOIXCqfrwDqkpFbVlCPCQeE8PrrXy2rnk46m43ion3XKFfeq3lWpH8U1BYTWCGmjyohZrGFPymZjJAc8Jdd2yaUHJTYM+0YhXqV2cTEM10sgqn8+QqRaCezKZjj0F5oMWaSyt0duTcshTo+ajGG6zdxSaOCr/Gp3kYKGnAq/QxqjDQD5aSehdk1eKEjl2XOej
 caenZShX
 jNJ7yJSORvE1tqokga0HOJfQbGeKWBHDO9MG+N+sqpPtb1q/gjIZRyLSwiFa0GWaLVVpcymw9X3CulzIveXNebV43LAxajJFacGV/pZmG+IU9X0RTQ2RM4IcPUoeVwr3LnIFdblYU7v3kTBLvO1rZ8RJ25j+xnhCWIRa1z75uFFLXvgObhTg7Qh3XqdBUtsxBqgiWnX8mglXmy6U7rEXGAMK55jD66++51n36XtVbYSIyKgiX2GF3rod4wKVQaU0cEgqaWuOPbOtJx3Lmyzm5zzq+qwCl4mGly0Y5tvnoXzqllCWDc4x4XnYpbu2jq45+6suFEWZftkcfTczfh1eEFavm2tIFv5kDyX1/IeW9Mml7/DL93BvjBAfjCWhyPd9JyjBnUR7jPkE3U3/bUVEZiDI8aD1EyoeZLJwYgHGLUn+wapuZeX+Oo8Fczh17esv2Clg2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 8:29=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Nov 11, 2026 at 8:09=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> >
> > Noah reported list_del corruption on single-node hosts running 7.2.11,
> > which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
> > as its node"). The bad pointer is an MGLRU list head in a freed
> > mem_cgroup_per_node:
> >
> >   slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 si=
ze 1920
> >   list_del corruption. next->prev should be ffacf881ccc70e08, but was f=
f31bfa36a3ca010. (next=3Dff31bfa36a3ca010)
> >
> > When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
> > lists to the parent. It moves only the generations (gens) from min_seq
> > to max_seq, and it puts each list at the same index in the parent.
> >
> > A folio's gen in folio->flags can be ahead of the list it is on. In the
> > parent, the same index can stand for an older gen, so the folio's gen
> > can end up older than its list. Once the parent's min_seq passes that
> > gen, sort_folio() puts the folio on the list for max_seq + 1, where it
> > stays until the next aging.
> >
> > If the parent goes offline before that aging, the folio is not moved to
> > the grandparent. It stays on the parent's list after the parent is
> > freed, and the next list_del() on it touches freed memory. This needs
> > two cgroups on one branch to go offline one after the other, such as a
> > container and then its pod.
> >
> > The parent always has MAX_NR_GENS gens at this point, so every index is
> > valid in it. Move all MAX_NR_GENS lists, not only the gens from min_seq
> > to max_seq.
> >
> > A reproducer that drives these steps through the lru_gen debugfs file
> > gets a KASAN use-after-free on the freed mem_cgroup_per_node without
> > this patch, and no report with it.
> >
> > Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios"=
)
> > Reported-by: Noah Feldt <noah@feldt.systems>
> > Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.s=
ystems/
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: <stable@vger.kernel.org>
>
> Thanks very much, Shakeel! I saw Kairui has exactly the same code here:
>
> [PATCH v4 14/17] mm/mglru: reparent folios from all generations
> https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-14-2106750c0bfa@ten=
cent.com/

Thanks for looking into this!

FG needed that because FG's folio_inc_lru_refs is a generic MGLRU
lockless lazy promotion, it may cause race between aging & lazy
promotion, landing a folio in a stall gen list. This isn't a big
problem, the worst outcome is a hotness inversion, which happens
almost once in a million times.

And right as Shakeel pointed out the problem already exists for
reparenting and lazy promotion, so we can fix it first.

>
> somehow, Shakeel's patch makes us need the change earlier even before
> mglru-fg lands?

Landing this one first is totally fine by me. The code is actually
safer and cleaner, in my opinion, with this patch.

