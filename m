Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E26606D701
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WPRYgAS/
Received: by kanga.kvack.org (Postfix)
	id A7E526B05B4; Wed, 11 Nov 2026 13:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EE56B05B6; Wed, 11 Nov 2026 13:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945106B05B7; Wed, 11 Nov 2026 13:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 691E66B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:14:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE21A80396
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:18 +0000 (UTC)
X-FDA: 85423637796.30.1B1C15E
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id D224A40009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="WPRYgAS/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794420856;
	b=hoUnDREvFr+QMKvQCbd6A4KOpnFRABv1za6llAiVmCAnoRLIA/VYK7uCfLAgKTric7Vx74
	pw3T0VN2a+/rHitiYGLfcPUr0wQNc1c7fCPTD6xtNkdKSW6CidLLnGdY257QTq4wT88yCY
	NfXkYMIhHOGMJXlSXfsI6CebJNoggzM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/plPOsLmxcLve8ez+d90RlH8s4a6+KgPsXYYRGMH+s=;
	b=3829HuLyF982+bA59FHxTw2ctNEgr2JI5dSpno7/EQvr9JcQWIpA/rLJKo4PPH5iMvE7NY
	MINjTMDTL0+Hom+7Xp5Li/ia9V5YM5x+nnNBHKCTikp5EVALHJMSB5AGbN40d+F795EROD
	i27Xgv7rmcQedYjv+WHZoLW9NUVL3n4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="WPRYgAS/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso4222369a12.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:14:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794420855; cv=none;
        d=google.com; s=arc-20260327;
        b=A27cpIHCx2xGXgwOx4D+b6YEsC6fDPSngS+xF1qLx1VLE7DQSXZv3ZIWZGhEbgBiXy
         WLEiWgyWCV2usVCKOk2fdWZXrSBiOfK601jwbKMWYDxzKNpamd5ihb0x5z+Kj8crfmGc
         5/2r/4GcGmQUuCv1r7sIT6Cu4fsuH4KpSZ3gS3QyUA4QnRMXPbRBoXTiafaTW1Qozkqg
         Bw9NLgVjj/zNjWpaPxVXxqALOWl8qrckj1DBMOxT02pDmTxn7j8O2KLkr/XaXN+m1+57
         NaXHs/DOxbb2qECNP26DjhGelekSz22T8YmycDyBuOhMBYVX+Ymgu8YXRuyzlDU9UyLw
         QX0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u/plPOsLmxcLve8ez+d90RlH8s4a6+KgPsXYYRGMH+s=;
        fh=YlU2IY1e9KkXjQ+BnldOUvlxVpZoSr72FfPUGD8akZo=;
        b=nHyCJA4AhO/viymtEuAp006flFblBRK61CHwvOhK/Tm+pzuy15xeAvaTZwRVzP0T94
         fxNdsK7eFk9YPzE+CK/Qu5ZOow80kP8CIU82MXa0aFCGo0iJinOFVorqcL+dQPRsVquI
         +1JdeHRdVxKjotH4IybVw1x2hM0riv1EquGmwN1NR2TDEzq7ecxrUKqNNKKZsURq0jaa
         B7D2Yp2dnUqIz+0RMC2gjgMI8FawoAlHs9qTVQWfZGvo5EY1nnPBHEGbjDxpCXYHjnQB
         bOlQ5oPMWRGtzLNA+gf/X+0cSKX/rYixAtMo3CHSrbN7nR900g8lfaXe7oYimbz7ytpm
         zA4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794420855; x=1795025655; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u/plPOsLmxcLve8ez+d90RlH8s4a6+KgPsXYYRGMH+s=;
        b=WPRYgAS/6h4XwqQJXQHevw5MElGI07x+h8+DAbPcEPK+ojFYaa9OF2ZgkzEspTgQrp
         kEYrUHnew2Mk3kZGRVMCThRrk/sgsPwlUFf6uRSNjOeg8IEvVAouXlsJ92UdLtMCzTxI
         H85D+YlBPWOzhREGUwJQbR8AQVmxzaYn8dXEoQHBdmGEf06BKCehM9ZmugIuK1IdOWhl
         ODPWubS1bNsY2pnfxouyMwO2/wRBe+J+EkFz3v7ug3uORilTzkwgm+UJKOo8ODyNeOAF
         c5yoBP91BKpsYBwvA5A8ondr5q8BS9YFVGsIusN/ayn8CIWYsvpoYnWTHRL98jdxKlRk
         IDuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794420855; x=1795025655;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/plPOsLmxcLve8ez+d90RlH8s4a6+KgPsXYYRGMH+s=;
        b=AVtICaVijLf931SWuAQN7KkyIotBvGNQMnAL7u68M2eAFkqD9YHep+JIY27w9FFjCJ
         jnlXXs9eFJm8G1PdINmLZEsnANQzu351DMM/BIRs161TD9sdShF8YRrKz9bDt/zWMfnk
         4h/NJeBUgN81UadP8n+YHXCua/j54XJhVwP8JHVEqFOGiqsT/MmpmPRlu90NXam9jZAQ
         StcbUqhbD2/EY9deegVtgxabUGCU85juqhc62fQyrm5sogRKWhyHgNG5RtdRJ8bhNO/O
         Lg30ld4ZPTGiqTlU9A9RY9qOWFniIj47gpuiuooB/+2gEwTN1D1KMNxqoYeupDbfSM8C
         EsYg==
X-Forwarded-Encrypted: i=1; AL+hErFazn7c3r0Q41U0RSl1VHCaRyebVpgpOKhnKsZkBzjsUGcTLN/sF77KD5B8M+aKmZwPe4mzcue+BA==@kvack.org
X-Gm-Message-State: APuU4Z/FmLRtazzcEvlaDLdqVi5ge+4LFPH1homkTnKGHsdgAQ250B+c
	AZJYipyjLeu8tkkidqNbeOwdj7XqV1ortClZ8C4BTqB3J0Ahn05B6N53KRkTNnvcvDO5G+z7Z62
	e2P9kpehfCZJm4lA9j1CimltWvHzymn0=
X-Gm-Gg: AYBFou0MJatK8WBXvZ1aJS19BOpcXAmldIb7Bi/edqXeGHeQDPzjXsFbiLsC6ubfdoX
	Dm450LD4mSQ7LGr7rSBGUqagjLLrTMzTl5qZZJhetI64JkMc9+BX4ntqfbQJoJeof7EevEKVQz4
	FQHGMf0gY0UUmX2rrZD6e5wnewFjR87gEVAprGC3LqzdRfqEIw1DiaXW5MCoa0E5J10mlnxMJoN
	QM1b4cRipz+iFDOz1O2rNoLUjJqW2rlDtQtNZ4rxsYUfsnhNsuJUEerhVtb/tvnKWIpPy/Yzid8
	SkVASlPajfR6UNQwkLAApnEbkn7NmUX4kN0Swe0r6rjRvnsnzHVpQYa07qSm7QxklYoDz7S/nxi
	FT0jT+p/Va+KSktnxyrZhsHhcffZrhnJH/sy0JDKX8gbdr5vFcVHfI7w4NGwafpi36mIe5g==
X-Received: by 2002:a05:6402:1247:b0:6b1:da03:d010 with SMTP id
 4fb4d7f45d1cf-6b7777178f4mr1942836a12.23.1794420855147; Wed, 11 Nov 2026
 10:14:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
In-Reply-To: <20261111000913.22943-1-shakeel.butt@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 12 Nov 2026 02:13:38 +0800
X-Gm-Features: AclHuK8h0ELM0_haw4Gg_bsSdt3hCgaLBxy2Y7ejZe79euvCzbW_wpkEQNryCYE
Message-ID: <CAMgjq7B+PE-Tw_v3bKYzNOTaT6+0_fn8gW7sNpMwzP1tPGbDug@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a memcg
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Noah Feldt <noah@feldt.systems>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D224A40009
X-Rspamd-Server: rspam12
X-Stat-Signature: rrhupbpt47kqbazwjb7bztu6ezgt9md5
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794420856-482841
X-HE-Meta: U2FsdGVkX1/A5pA0IR/CsDJvFemDWLAmokfd1AqgY0AE/tlafINxcsL0tueBZu0m3it6ydXYs1tlE2UBOqdgP7ML4xvIibcKNn6G7V0ZdOsiu3OaR7e6lhNLafBreNVAfuYThO5iBnUy1jxGHLgOWpmJZMKYomyLqmQd+wPbyjKzmZ88kn7nIG/x61Ij5IKoCtbpiAXnVfjtddFtHdorMLs/Nb9FyKUx7S/YE2/fJHYGPIGV3rW6z42TO0Thyr/o9O4kxbcu2pxgEswqo0Ww78XWJSLdHqoesMpDYAg01BR5ySX19j/d9qr0Y6ZJgwDgSkxAda3cIJXRdrav3l9+ewX808mChqytg0BL0MrhBSm7rCBL9YTnEWKs3WNM/hVpaKGgg7MTkYj6GyRWHhU4asvVNvJzxN8FJFMdfC5PMAkO45DYoO86tb9tHHMKVI+bsrofNAG8ZoTAjGr4nkC5FmmrHwQzeAIXcQbmpQq48E0Cqp0nQPrBvydlBM30B4ygeRHSR6hJTVSLmALLEeCZ9TMz0aSWttG6htPP9oV165TUqWGihSY2jNa/7HS7nSStzgnYmGHYGNOutZmgzN1HiFMZ3jAkFrnK7vVkC7U1U7ujnDGkCvh8A90dZOo10QbZQ9Q+ht11Ee/0wkWK59kma+fNpGwZd74Qb8VNzKrom9wwk5F2RrDaDWP7UyuJktUGSHGyQQ7+Lw5GuDYZAIx+AOAhokaDqwfSMB1PStSXxafeXZfwSYxOVxVY4SrdG34GkakF2y8J7g34QBd6xobV5M7oq4E7wLBplKYx0o7krZvMwZRaWVUndFFAuClBh9fCP7iTVs8ALYLNxlF9647ErydWoT3PWvrfiW+YdnH+LnouvDYT4Qx7HfiQeh8iSzdgIhy0O9AU/P9kzSCvUjdQ9myDnWlhxYHEoGnYct+JMHuYeCX9hVBe0eQey4VJ7eTTxzqO6ELkCj8YLueq3AF
 hxtRaY6h
 n5FwFEoLIVfWaIPRJfGJTpwClJaGwKSybVi6E5SwmfDjdHdP84WULoQX7wY8S9GeIE2eW13er8YkFn9tAep+h7DX7EDYV6gEdyjpaF+ZJZHxJhZIQW+FbzI2zolEK31LIGxP8NTIu5PGa/9/OHuzMTJxUqKkbcICru9eho4dwLF31nQyqiQjAjI0hgR8c1oE7KL9aRbC+Tyj4IPh6t+fJwq66p674N0QNt0xJF1oU7SCe4PCtOk5kYNsVL83LSIvmI7vgjt0jWVAMRjEzPQZntUf9SuEO8EXExOeitDbLinfgYKrwwgY6lSXvScz5sP0jyMqLOEe0ZVJEmFajPyj1NqiAkDPYDoykS7sVp/T/L8w3a7yZl5SH6Tr3CH3Vg34daxCvo/FlUGB9KkGkqahDG4C1WLyQuzz+mfY+FWCFNUJhqAgJo7rZrw6XdDff+uzoqsI22G1X4D6givq2K9DP+6xvjQJli/q9Ntoe7fdNsgjgRcyxw2Htc9tIeOzDEvIXHQTol7Jy5Cg24HSQQCjNOjF1Q71mi4AqTtNnLY+eZCdeX5TGu4WBmeXuCKkhfMSjFB+mdwiCoLG/BIIfas0ooR0SiZrvjfqSafKr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 8:10=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Noah reported list_del corruption on single-node hosts running 7.2.11,
> which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
> as its node"). The bad pointer is an MGLRU list head in a freed
> mem_cgroup_per_node:
>
>   slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size=
 1920
>   list_del corruption. next->prev should be ffacf881ccc70e08, but was ff3=
1bfa36a3ca010. (next=3Dff31bfa36a3ca010)
>
> When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
> lists to the parent. It moves only the generations (gens) from min_seq
> to max_seq, and it puts each list at the same index in the parent.
>
> A folio's gen in folio->flags can be ahead of the list it is on. In the
> parent, the same index can stand for an older gen, so the folio's gen
> can end up older than its list. Once the parent's min_seq passes that
> gen, sort_folio() puts the folio on the list for max_seq + 1, where it
> stays until the next aging.
>
> If the parent goes offline before that aging, the folio is not moved to
> the grandparent. It stays on the parent's list after the parent is
> freed, and the next list_del() on it touches freed memory. This needs
> two cgroups on one branch to go offline one after the other, such as a
> container and then its pod.
>
> The parent always has MAX_NR_GENS gens at this point, so every index is
> valid in it. Move all MAX_NR_GENS lists, not only the gens from min_seq
> to max_seq.
>
> A reproducer that drives these steps through the lru_gen debugfs file
> gets a KASAN use-after-free on the freed mem_cgroup_per_node without
> this patch, and no report with it.
>
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Reported-by: Noah Feldt <noah@feldt.systems>
> Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.sys=
tems/
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/vmscan.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92349..902616a3b755 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4751,19 +4751,25 @@ void max_lru_gen_memcg(struct mem_cgroup *memcg, =
int nid)
>   * The same generation has different meanings in the parent and child me=
mcg,
>   * so this compromise method will cause the LRU inversion problem. But a=
s the
>   * system runs, this problem will be fixed automatically.
> + *
> + * Move all MAX_NR_GENS lists, not only the gens from min_seq to max_seq=
.
> + * An earlier reparenting can leave a folio whose gen is older than the =
list
> + * it is on. Once min_seq passes that gen, sort_folio() puts the folio o=
n the
> + * list for max_seq + 1, where it stays until the next aging. If that li=
st

"sort_folio() puts the folio on the list for max_seq + 1" seems not
very accurate as MAX_NR_GENS - MIN_NR_GENS =3D=3D 2, could be any stale
gen outside [min_seq, max_seq], right?

The fix itself looks good.

> + * were skipped, the folio would stay behind on a memcg that is about to=
 be
> + * freed. The parent has MAX_NR_GENS gens here, so every index is valid =
in it.
>   */
>  static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct=
 lruvec *parent_lruvec,
>                                      int zone, int type)
>  {
>         struct lru_gen_folio *child_lrugen, *parent_lrugen;
>         enum lru_list lru =3D type * LRU_INACTIVE_FILE;
> -       int i;
> +       int gen;
>
>         child_lrugen =3D &child_lruvec->lrugen;
>         parent_lrugen =3D &parent_lruvec->lrugen;
>
> -       for (i =3D 0; i < get_nr_gens(child_lruvec, type); i++) {
> -               int gen =3D lru_gen_from_seq(child_lrugen->max_seq - i);
> +       for (gen =3D 0; gen < MAX_NR_GENS; gen++) {
>                 long nr_pages =3D child_lrugen->nr_pages[gen][type][zone]=
;
>                 int child_lru_active =3D lru_gen_is_active(child_lruvec, =
gen) ? LRU_ACTIVE : 0;
>                 int parent_lru_active =3D lru_gen_is_active(parent_lruvec=
, gen) ? LRU_ACTIVE : 0;
> --
> 2.51.0

As Barry mentioned this is basically the same code as a prepare commit
for MGLRU-FG, which is a fine and clean fix, I just didn't realize the
problem was already reproducible though.

Thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

