Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1B2606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IgwUdmAm
Received: by kanga.kvack.org (Postfix)
	id 7E9F46B097C; Wed, 28 Oct 2026 00:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BFDA6B097D; Wed, 28 Oct 2026 00:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D69E6B097E; Wed, 28 Oct 2026 00:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 42D0D6B097C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:14:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 603CBA0532
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:14:45 +0000 (UTC)
X-FDA: 85370718930.05.700094B
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 74B2440007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:14:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IgwUdmAm;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xy0VWwyzp+vpTOIBzIkzfVFw9LGMzZjvLAPkrrf1Zcs=;
	b=T22yLMDPAC4t17MfXq9F4Fo5BnqlS1s1/IgyJZLI/dkDFCrGGHNDuIZz3ApE2r7A4SUp/T
	45AP1acC4V6BNC4ViKZ6ZuaZ+FKTtRX4BoO6iTyafQ/nvjqhKDhzs1p9V4fTnVMs/XX5pK
	xmdTa+vJFvfr1UzuZzJ28tUMJ/umYwE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IgwUdmAm;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793160883;
	b=Gs2HYeZ+6bJf0Ahhc5lMymIraDd8RFFngHLnOjgirLKMFU1hyymUrZ1V2TreyW/8YVp2B+
	Vuwrd2eBR/gZ8qgarr+86Qs+kWQal6J6bCAKLdJ72cjn0KUlstp7Jji8Oq+UfFEmRgoUvP
	YbxjGnMkoMwAY/4XfNpnSofcrflyC4U=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso4129485e9.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793160882; cv=none;
        d=google.com; s=arc-20260327;
        b=U+cJY0DLzt11QqFOkvQoMRUIjresoXSWDjjx77+U2ujbxcgtvejmGpwWcgZtWdxGk3
         II+GMczljiCpBk0GDwpGoUtOtcCmspba1yRqobejMPFZ0RJbe+YRvow8FTGJYuDi0DmI
         CWRznZfSdlCipanviFpn/7zGfKG9ThPbrYZ675TrcfoIqle+yfjFc5XQT+KlugG0WNEn
         hQBv1/ZnENIdMt886oOgao+TESZT+oPaIsTycN8s80VsjfEGxq5O5OVxXa/egYBzq9PP
         qzezu4Bp5ktno8HoZIFQuwlH4SZPI8BYvbOXULsM0FRdOR7n+sOHLY9sWVPIUzbWIUcW
         ZVdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xy0VWwyzp+vpTOIBzIkzfVFw9LGMzZjvLAPkrrf1Zcs=;
        fh=yzRNKvaaq+82Xu/PFvLwAsgZSs7bqL0H1/T8Bglacuk=;
        b=aDcLJljFGlzHsP1kN9dXFt0AolD9EeLTPc3l4YaRqV0eo1ImUPe+fh39cyv/vq469t
         Q437Ziqx2PLfE71wXObe1doqj93n+3myyudc+VleMS8xoYbFnJVl24H5/ESvXv++RYDl
         FNaoQATQf13r8QjWMxWE7N7S8ZiqjrEbnQjD2hXLHzfh29QL8ymc8Y7sP3qOzPrtWU70
         JzKcrM3w+bYR3p3ndfz+Tr4XsAG1HxmOWwEnqRIq+ucsNS9oferIUTMj2jx8HTqk1K7i
         zlBOFr3zRdmvtGqY214mLe3wxlYquZ4LMNLGmjOdolLqkUjhvcGy295f/u32EjPZbPUP
         8mAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793160882; x=1793765682; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xy0VWwyzp+vpTOIBzIkzfVFw9LGMzZjvLAPkrrf1Zcs=;
        b=IgwUdmAm/QkVysnlXTlYPkg6Ol1bzmGoK8ojzb4nevVor1rEjf39IKiHQNvpxh8Qsk
         dfr1gkzPgpwGZVSJePGaHuiWR8UWcHDgO1o/akFIzs4KXLfl5scuCsz4vgDdKo1SpCDP
         ssMJC4CisUANqQZFIcgYfpqYNkSFWghypVugo52P8f5cEuQKZ2nRldttMimMKHM9LRED
         aIY6h6oHGdUsEqHgOJSHTFJGSvP2zKnxzsJ2jDdYkn4U7o5VVu7y5dMhyL0e5dMTd9Yx
         N7U1spaInjvhFWhH5hHAE1chVSwhgnAn3NaVPfkG9RMHD0LG6xHcfLcZxB8QKtvaLMaT
         kcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793160882; x=1793765682;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xy0VWwyzp+vpTOIBzIkzfVFw9LGMzZjvLAPkrrf1Zcs=;
        b=muSFi+RM9OWIvdOmu0LKMZsuI8XIA3zBMrmSu/9QOPx7sIwp3fDbVj3VZKoxalY5Cg
         1Ju4aUExreLemNtqUN8N0RAuB5opMHZpbGomlrbPvRPyYPNXNYb8uQHV+RE3yn+OxcXo
         jbbmM0aHn3XihKbRWovDfHbpH2k6lrVzETXsUxo2yRAmoJyJSovKACThJkhISnVRRi+C
         N/gK1yLZi/5/XijWFc0d4p58LezQ8UJfAYg+k95ANxfcgeBUnkdokUssduSJX0u+rg0X
         AfZlYtYJO1G1/CuE0fcxkrCj9pxAZqdxFSmOrVlg8r2ODWDvGpyZyA58E5bByWiWuqN2
         fYaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYdtf9LFTLOgvG/zITnVfhKT4YpIbNqgBxYsmkIalMHmMLms4RhUVBMCpgUJaBCYt8wQ53+crGFQ==@kvack.org
X-Gm-Message-State: AFq9FYK3fLF9T3IPP5JEHSGCklij5AD8GpucwTKkB/kwulmpvoF0Y6x/
	R9JV09at0oyYscLrhkyLy5aiN9Kuafcw0IR2SK62fOvDZNlVrWLYDBi09VBgYChDFnHgsCOvnfj
	QlatodeeaMzxj/HNrI3GGkKfJIhbdZSk=
X-Gm-Gg: AYBFou3I6dKYB25ZDX9bT+t4BfIkBOHFBjEi5x7uC7tWTo//HATLpHb5ewjhZDfMZh/
	l8U20wCZzVBZy+gn7hOed66SMVHKog4Xg0suGnq75bmE8IaQov4nVByHwkeX4YjncdubQlEJmSP
	xspOzK+mJaHSHYXtNmuwUf/Fp0QRZaT7X56wXzPbeE8MrXAe4tCisg1u+gWXrUc/lYGV+L6U/T0
	ijhQZzbCAhtECOH6E2H+zuJmUp/x476Nd0HDZgx17trSxw8yBUhrr5eD8C0SydSo+8tbSsbWyne
	FmoqSR5+MQ9drlJdTl4h5XN60o+JUo5JGWkkypRUKHU5+6+7lCVTob82SKlKYuVxUbLksWlDpdi
	km+dR/yK3re7k47YOAmMgSkWmszPzApSQx/oqY/3RGi3Et0Hj596uZk5+Iio3VEY+WYJW
X-Received: by 2002:a05:600c:811b:b0:4a1:f625:2108 with SMTP id
 5b1f17b1804b1-4a967e8c045mr18383165e9.33.1793160881597; Tue, 27 Oct 2026
 21:14:41 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-5-baohua@kernel.org>
In-Reply-To: <20261022220203.91911-5-baohua@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 28 Oct 2026 12:14:28 +0800
X-Gm-Features: AclHuK_O568tS_hpoQdHxuabg70CVmUWc9FvgfE5clXj_iASH0laiWXtqK5hoVU
Message-ID: <CAN_Opa-5jikDWQs_adgZ6UHLv-FVNKwpKpOZJU5F7zhWQ-FeXw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 04/14] mm/mglru: lift the forced protection of reclaimer
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74B2440007
X-Rspam-User: 
X-Stat-Signature: 1j6nydges7zyznt1nkdjrt1nf5dpcbtu
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793160883-971597
X-HE-Meta: U2FsdGVkX18ubE9ftGx3AJghte1rPvfy3DlLzHrWcdw06QSde78vQls2B6LJpQXpO5UyNAV4McW1Ubp5eUviC+i0MS0l36rE/E81oup5wGAle66TdevY0FlH5ZdRR6CTsQ/3V/rF7mXeSZQitYqQijxCeBBFgbvHq+YUwfDCzUihuzBsWmSqYgzXP2RT40q9jCZwXSEQwTTYGjlbpYZSF6uCUwPpelyDYU2G2XG3ZlOGDXpECyHXAceU62rPf7vQOXMRBULSBwQxugtcPKJRIKl8aYOEGouFijhRdGdul/faakNWk0t7p6654Jf/js3CilqnLA/1zUseprI5wfg+ssXp+/iw8YGsGOlpjZ5+4dSRQe6hYroTKAcdZQfm3V+GAAAE0f1dV5dbmy6erHiYiSTtoUBjsd7SImZchM47nMvkd2exxx/O2/5ux6K751beU/CykzZbntc3DSz/v/bttmU5bVYo45qBwzlUDaf/8IB2t7Qc3l1vHEjWorxgf0Q0LAtDAvu2JDKHu04/fpH1T30oQWfAtaCm2svi8E5Tr0Su8oRwDNLSiyb3HzP1GMVb+ZdQRQLJTFGPY0z5G0ItcJ2tI5WI9vyb8KVaL3yyO1ID8NIZszqjvirlsuAjbvleI1gr5gc8vqH0qBzN2yOtjb5BEKfy50dVLt9NMUBVSFMtPXwZSuh+FKhsU8j8gqf3AQhCAmvyfX65igxiAPN68aVaXkBXflNWLZaoHJRj+HoGn2vle3M/MrEAKJSMVqL3l9xC6rk9bqbE46+tlPzrTP1+yKvcphYxYSCcGD4FybMTjKSOjjZpszLU8I1MK4u3AYzOWysWfa2VkVPad4FKS/o7osevllwRB6huhBsOP46+3h2fVzKySuUZqwkP7jLHn0U/Vao3Vbu8LUlQKOSqrcxPj1RGYenb/02E3PMaDojjRbGbnD/c3E1VURJKx0rOzXopIfRDtz9E32rYZxP
 bLFgNaJ6
 ZqXAUQf/OTIa6d7frC3LG4g/HXujiW2h17CTczRNaoQdLDClCMiIDAAPr50Tzfs7WfljBU3xDh9SpZz+AICCscgyadhhEZmsuveg0hn8+Ngc7sQ2VexpTY9TxiyvADzM4ZnKm2S8hAzXlOTBKoCJ5EewFTQI2P2aAe9wxXHpVcQa+0ugH9pFT7eUViZ671nD9C33tKncvSz8GBdY24P3/TW8Ctdj8uTxrXGe3NJFVynuIudZ2v1lpG1Q7rntfEYGQij0hvvsZt1tDeun3r24xZ5hg5Er87msaJkIGF3EFs8clB6Qsu7Swsw/3zLmNapQnsJHDc22TyGbpEEWQtw1luqzsvdKwrcmHfsARtotXkalJojPqP0B8c3MSUz5COww0S4kRobFMvDNg7aZ1m3GOlkDe0AQSN42pgVX4ENt3stZSRHW4P10NZnuDsYNG3G/KkUp7hC8HOeGSlOewgWKSgTrBDzPnGri1McaFBoVg72jouxxaw+CQlFHscy/qm9sNvdEDdhp5ko844CEHTilTHyLBVhsiu0LRyQLV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 6:02=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> When a type is drained down to MIN_NR_GENS gens, the reclaimer will
> fail to make any progress on that type without aging.
>
> However aging comes with a cost, and it will take time to finish. Even
> if we do aging more proactively, when under great pressure, gens will
> still be drained very fast so the new gens produced by aging can't catch
> up with the consumption. With MIN_NR_GENS setting blocking the reclaim,
> we will run into OOM. This OOM can be reproduced by the previous test
> program [1] used for fixing another aging problem [2]. When running in
> great pressure, certain workloads will keep seeing premature OOM with
> MGLRU, and never see any OOM with classical LRU.
>
> This might get worse if we implement async aging, or avoid hotness
> inversion in aging, as they will slow down the aging process even more.
>
> To fix this, let's first drop the get_nr_gens() =3D=3D MIN_NR_GENS early
> return and let the raised-priority scan bound cover max_seq itself.
>
> Mapped folios will still survive as the rmap PTE check will keep them.
> Unmapped cache folios may thrashing more when under great pressure,
> which is really a problem that should be fixed with refault distance
> and frequecy aware promotoin instead [3].
>
> Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mi=
x-pressure [1]
> Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb=
92dc43@tencent.com/ [2]
> Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d=
9@tencent.com/ [3]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d7eb15533de1..2cccaa5dd4e7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4834,7 +4834,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memc=
g, struct mem_cgroup *parent,
>   ***********************************************************************=
*******/
>
>  static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struc=
t scan_control *sc,
> -                      int min_gen, int tier_idx)
> +                      int min_gen, int max_gen, int tier_idx)
>  {
>         int gen =3D folio_lru_gen(folio);
>         int type =3D folio_is_file_lru(folio);
> @@ -4851,12 +4851,22 @@ static bool sort_folio(struct lruvec *lruvec, str=
uct folio *folio, struct scan_c
>         if (!folio_evictable(folio))
>                 return false;
>
> -       /* promoted */
> +       /* promoted, or moved due to reparenting. */
>         if (gen !=3D min_gen) {
>                 list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>                 return true;
>         }
>
> +       /*
> +        * We are reclaiming the last gen left. Folios in this gen can no
> +        * longer be promoted or protected, so just isolate them. The one
> +        * exception is lru_gen_reparent_memcg(), which is handled above.
> +        */
> +       if (min_gen =3D=3D max_gen) {
> +               VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
> +               return false;
> +       }
> +
>         /* protected */
>         if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WIDT=
H) + 1) {
>                 gen =3D folio_inc_gen(lruvec, folio, min_gen);
> @@ -4911,15 +4921,16 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>                        struct list_head *list, int *isolatedp)
>  {
>         int i;
> -       int gen;
>         enum node_stat_item item;
>         int sorted =3D 0;
>         int scanned =3D 0;
>         int isolated =3D 0;
>         int skipped =3D 0;
> +       int gen, max_gen;
>         unsigned long min_seq;
>         unsigned long remaining =3D nr_to_scan;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +       DEFINE_MAX_SEQ(lruvec);
>
>         VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
> @@ -4932,18 +4943,24 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>         if (sc->priority =3D=3D DEF_PRIORITY)
>                 min_seq =3D lrugen->min_seq[type];
>         else
> -               min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen=
->max_seq - MIN_NR_GENS + 1);
> -
> -       if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> -               return 0;
> +               min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen=
->max_seq);
>
>         gen =3D lru_gen_from_seq(min_seq);
> +       max_gen =3D lru_gen_from_seq(max_seq);
> +
>         for (i =3D MAX_NR_ZONES; i > 0; i--) {
>                 LIST_HEAD(moved);
>                 int skipped_zone =3D 0;
>                 int zone =3D (sc->reclaim_idx + i) % MAX_NR_ZONES;
>                 struct list_head *head =3D &lrugen->folios[gen][type][zon=
e];
>
> +               /*
> +                * If there is only one gen left, rotating the unreclaima=
ble
> +                * zone become meaningless, just skip them.
> +                */
> +               if (gen =3D=3D max_gen && zone > sc->reclaim_idx)
> +                       continue;
> +
>                 while (!list_empty(head)) {
>                         struct folio *folio =3D lru_to_folio(head);
>                         int delta =3D folio_nr_pages(folio);
> @@ -4954,8 +4971,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>                         VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) !=3D z=
one, folio);
>
>                         scanned +=3D delta;
> -
> -                       if (sort_folio(lruvec, folio, sc, gen, tier))
> +                       if (sort_folio(lruvec, folio, sc, gen, max_gen, t=
ier))
>                                 sorted +=3D delta;
>                         else if (isolate_folio(lruvec, folio, sc)) {
>                                 list_add(&folio->lru, list);
> --
> 2.34.1
>

Removing the MIN_NR_GENS early return allows reclaim to make progress
when only one generation remains. Bypassing promotion and protection
in that case lets reclaim attempt to isolate those folios, while
scan_folios() skips zones outside reclaim_idx.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

