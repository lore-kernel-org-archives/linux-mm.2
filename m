Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0D2C4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 19:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FB2D6B007B; Sat, 18 Jul 2026 15:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2FF6B0088; Sat, 18 Jul 2026 15:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC146B008A; Sat, 18 Jul 2026 15:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0989F6B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 15:24:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E0101A03F5
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 19:24:04 +0000 (UTC)
X-FDA: 85002872808.25.A0A5A3A
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7B412140005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 19:24:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bv6yVJpO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784402642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJyNAcyDjaN+fTO6jyorfeC57GOZoi24fbSsPWreW64=;
	b=JDrR5Nx5KeSY+C0cXI0XpAihiCSVsrlA7G3AAzJKo63uVbrKH8cTYTzYtNTNboZxeYSBdk
	AUQTN5IM7LJe2REPCsKWfqqzcyc4/79YZEaOcCqX7jLOPhX8NKCwvQmqOoU++VXEdyIMPl
	oUOkLemhOCN9E6pHsv96zZVy1G8Kd0s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bv6yVJpO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784402642;
	b=BBPgtJJusXsPith3KvQj3UHVba7fAYBEQuliP5PU1Rq4MsHwCaUejjV/t1cHI3L3SKb0Ng
	3QbRBRfBCBqeB/vMh5DnmhTWA9prWo3Qt29rlG7a0lMSJ7dm+rDHqCAzL/QJCHzOUj8J82
	90uPTaL6BVtmU2qrNz9GekK8dX40EqA=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-699fbcd23ccso12728080a12.1
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 12:24:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784402641; cv=none;
        d=google.com; s=arc-20260327;
        b=Nj9i4zsrU30UvwNNOU/cNUoApZ7t9EDYI44PxJSKgsBr5rQTUK44ulhiE0NYJ6uqm4
         4nd57G4Rgs4tZj30UuC+o4MzDcuL1QdQ54WHhBoeGwBGDbFs2N3N8hS9wH4aE8zCLAdO
         KLxhBJCkeux7RGJlEsYPxBiXxfExDPe4YFED3MaG8G/xbTn+dnenDSXtRcmEZtAvfeNm
         LTg/OrUmCDBigEScTELJ3s0c25l4WKsvMA/5ga+xRWnQrcxzQdehoN4YsClrUO/RJgCK
         ekqxsEXVMYA546HiTb8A0puUSIHH1LG7E9f+imzwfqFSNqXeAK+jr4ncdtPtK9h7rm+D
         TB1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HJyNAcyDjaN+fTO6jyorfeC57GOZoi24fbSsPWreW64=;
        fh=ADkH+kRZeix7avaYAdYF2ayiGXvHDmcw2gO5kWV2KMs=;
        b=Az40x/SSbonJ4N0GRW5YTHn8TxBe5JaV+NOw9t49dwrgzU4tbZ8yHLz7Y/CBa4A1qC
         bpU7yxcevhcaOJFMA6e4Pou5IlZCTRJulDIrIT3y26bdbBv57WxdLfraC3IrquFdTTmk
         rbAEf4hXfM/4Tj970/xn8ukXsUZiAGZ+tXwfvuWfoFQbZvfx+L4g1lAIq+rl+9JNf7I8
         Hb0XxIjPBwC/djbySuNVmh+MW+etqvG3HDQBD1fpOi38YIcIAGeS1Zsomi8wEB0keyDK
         Wr0qpOf8KNveLJR3qUVMyZd980GJaLFH9OY8HS8kKuvHQnJ8wRPMe7Si6ARFi83l5MCd
         n/7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784402641; x=1785007441; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HJyNAcyDjaN+fTO6jyorfeC57GOZoi24fbSsPWreW64=;
        b=bv6yVJpOschld8OQxS4/P4M4PX4TI13lrPuwkHt4uG44adErDHVVQS47kIUxIA2+eL
         xvTfbAqdDL8qMVm2PdnCWhENRYo5fIgmWPKkLyXnRjhJmqFebtMEwYvhJOnRb6F9Mv4Y
         DC0HLyv0dYSfC39wZhOD+82/LEiP2vLIqdlPNtup4e/Ow00rly3D3a3sieIMie+j6Qw0
         N0EWb1bYZBFHaNGZ4ekGBCioGu/Xcf2GnCCnFcgFZqIy0S3xfKJ+XnY751AZkVxfprF9
         0qYSai3B4Z7k6w4SRTNRa+xClxUId+8i0FxK6W7B03H4gjMEctvxS0MdwmFDj8l4H7ql
         z+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784402641; x=1785007441;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HJyNAcyDjaN+fTO6jyorfeC57GOZoi24fbSsPWreW64=;
        b=djHfKkebj7uqu5TBtqUat4NFp9wmHiVcQKhNzzuCkiPOTtu0UY89xZJelZBT1xmAgQ
         33OhN8q/g1qTyJ3Xw5p3I8DLXf2NfVMeaYzFyk+Zdq9ItfUsbY8wN5xk3V37qRJDwy6e
         b4ppzPS0BjvjfekID9i0Z8+N89lZ3nBoGYatm4a9dQ4mDRnfz/anwgLn7x76uvROG1rG
         uhL36xxqz8YlxxRZvZY8+dJOgEadZRLUAMY0aqWOiyV5KSoYvks1pAhd7W/4c+Oy2qOu
         +3l82mzSESxrkVVrdB1NoR1c17CTnkOwjMh7oxJ5Vf0ra9LNU7rN5dINtB8iwQcEDO0k
         HKVw==
X-Forwarded-Encrypted: i=1; AHgh+RqTF1B5ckAwv4g0aRW9eJecujArk3Lla6BL4239EElS2P4EAckaf+hBsfcPhcIyEli+hxb9gUZPLA==@kvack.org
X-Gm-Message-State: AOJu0Yxx5JaKR1lGW3eJTYrFA9n5oZcBFcg4V9sZWRuiXORuIdaAh0Vo
	EwhOhv2Z00ITYvs/aIUZX5r6LgrD/rCAiFZtotObj/4Q2UbhAXTzu2ZFSNugMb2EzkEqZqwrS27
	v/zKPNVHAyBCah2Oe0P/nbzCJ9OhStIE=
X-Gm-Gg: AfdE7cnpK7Ng269fY0859DzQpRyMObi/tigHW5+dgRS1rLEXdYQEr0TLNJlQ7vyKpK0
	SbkKT0tT4XXKvI7GmxoPcDgcqGz6LIAReWWZsidfLbxFrdPxTLuU+/yl0qGi3KZZ+Fe85jlSu2b
	+08Xzf362CqqizpGrt2qYQCvG+pnMB/VXv7B+22i5eDCzHwh4mir2jb9oUgDJwPKxLC6ernmhG8
	1lArxfT4G6dnH69pcnFEgM3Hjm6E3+g0ElPGvcd/Y18oO6DqPomoYTuv9bdVnFn8TRT+56NYxrz
	oQURFrcOEk4lTG7Y++A=
X-Received: by 2002:a17:906:f587:b0:c15:df42:952c with SMTP id
 a640c23a62f3a-c16b46f16ecmr337195466b.28.1784402640895; Sat, 18 Jul 2026
 12:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784268206.git.baolin.wang@linux.alibaba.com> <7db4d1975cf04e3e48157f98bdf398565ee189a4.1784268206.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <7db4d1975cf04e3e48157f98bdf398565ee189a4.1784268206.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 19 Jul 2026 03:23:23 +0800
X-Gm-Features: AUfX_mzGn-0idPGuxv7N90VW1l5CZJ4fw0XmM3Mep1puMEXDp2scjXVXcLdGbBc
Message-ID: <CAMgjq7CkuWfPfrMe9jPypW4zibHG-nFCmH26xR7u0Z6zhOvQpA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: mglru: promote mapped executable folios after
 first usage
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7B412140005
X-Stat-Signature: 9kwo5zw5ruc6z4zu65bofphm4rd15s8c
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784402642-500566
X-HE-Meta: U2FsdGVkX1/mflQuvA61z+5ER80pcyljOO8dz4L99tc90FzYYtQFwpwrJn9Lp6GTTJKsQrk5V+efbAy7fOLB+0IVoJZlDuDDjSQLu51ub/rjWvWNGeoYtXAj1FvJoss2XVPRMYhDs0THOd/K4oDmLx8IOO7+u5OOSnyJCVU9Kz7Q1e5WAKN96iNIUruMLaCINu55bPjv3girmqfjuySwBWfueZvU/rkHbY9Je8LWcgqq9biONue2O3vv0teFVbOOgIsRAa2V9xxXPoPCWPSNS/gLpEGwDmbtILyppMizpKMKQVvK5T/qA3zPmcM8cvWO7wMM9cW+9+8hw+ThKOSzJd1eNszOX25HXFT/tJw2gFQmb+xPVNZCjjauV0tOv7BSB1BrPwuz5X07EVjbW+X4IiR5FhI6L0GNJojWuONocwyFGVFxyf5FWyAB6615DAMt6PUVwcf8B+Yt8pQXy86kgGGi7sYH0eAvt4jyx+GWT4ZoEyeJ1jPh7va8FBqlmPpTgCmTNswZp7X+4ODOjjTQ339Th74WhmYYhjdUBqazOf12ElekzXsESXrWm7+zwkbp8/jAbidGGu3U4WVX1/EfvPLcHODvgkDwzzfoKnk0u57nX/dsIwEaRq2lACdri2okAzJsO61Q52JZhYfMEtmNZFuN6FJMRv2r3hC3m2dc36nPDXaCS43EgwE5i3i8bI8UqrS96F1MchK2JxIVsnRbe1F578wwXokuNhIohhLlrQ0f9p63xjgTNqt0WFx71ZtyIxHnIdgyPjwwf7OX8ctphCtnKFyCDuCNwk1ZgXobOOSQvfloGruRnj5h7HTfL5CwJysbjvH3raScGW1QrA0VZklurn5lQYQExGxE6ps9cWQZOGPbl2oxCI72CyOTxiac2hLDxPv6mhZmo+pHEUkhbT2PhsvVzzXX+zqSIuL0ozCtrNqKzhCciYQGcyh2Q8udx66G1hRpf3kFzKdzwEj
 lDVVCG7Z
 Bf7W+hrbWcL3u0M9Mw0Y13Xo5t/t1EMQ8OPvlmkdcAsEJIALhufgEOeR9mw/z18tV5h/aaMzyx8TJ0WzRhjNTpntTAx14F5Pl1CAvAabrXDpGV2Ved5VwMQ9DlJQb/TIFZIqKpmQEcPGK2zOs/BHWQgHvX1PbRXvsPrRDUwpgjQSezOMfe0681990S3GnKNHie6q3E8mJ5CCFfxUCEi0SJnRQMFqYUJdGc9dj22NjCS70fx8tNRJdH5z4u8KOyTyBT20+wq4u5hfiDVgeG666mE6UQs8CCKvM0hKVNPWsC4ltHtB9OOuKJ3Npd1a09LRdyevKGSiIcnnXiumhktLh1gVAlo73waNDColHvXpfF2yYJL7IK/shXBSsczOaGNoK7JMlr7ayH+dBb1DGjHPWLf4fjDDEwKHFrp7l3uiRQYNR0es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 6:06=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Classical LRU protects mapped executable file folios through commit
> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
> after first usage"), giving executable code a better chance to stay in
> memory, avoiding IO thrashing and improving workload performance.
>
> However, MGLRU's protection of mapped executable file folios is less
> reliable. Although shrink_folio_list() checks references, the access flag
> of mapped executable file folios may have already been checked and
> cleared by lru_gen_look_around() or walk_mm(). Additionally,
> folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
> flag for mapped executable file folios, which causes shrink_folio_list()
> to ignore the first usage of these mapped executable file folios and
> reclaim them easily.
>
> Follow the classical LRU's logic, promoting mapped executable file folios
> after their first usage in folio_update_gen() and lru_gen_set_refs(),
> giving executable code a better chance to stay in memory.
>
> On my 32-core Arm machine, with the memcg limit set to 2G, running
> 'make -j32' to build kernel showed some improvement in sys time.
>
> base                    patched
> 9248.543s               7861.579s
>
> While we are at it, introduce a new helper to check mapped executable
> file folios.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/vmscan.c | 47 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 31 insertions(+), 16 deletions(-)

Hi Baolin, thanks for the update, looks good to me with two nit picks:
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index de62899c108d..1040bf9f96e8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -268,6 +268,12 @@ static int sc_swappiness(struct scan_control *sc, st=
ruct mem_cgroup *memcg)
>  }
>  #endif
>
> +static inline bool is_exec_file_folio(const struct folio *folio,
> +               const vma_flags_t *vma_flags)
> +{
> +       return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_l=
ru(folio);
> +}
> +
>  static void set_task_reclaim_state(struct task_struct *task,
>                                    struct reclaim_state *rs)
>  {
> @@ -835,11 +841,15 @@ enum folio_references {
>   * with PG_active set. In contrast, the aging (page table walk) path use=
s
>   * folio_update_gen().
>   */
> -static bool lru_gen_set_refs(struct folio *folio)
> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma=
_flags)
>  {
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
>                 set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
> +               /* Activate file-backed executable folios after first usa=
ge. */
> +               if (is_exec_file_folio(folio, vma_flags))
> +                       return true;
> +

This somehow missed the PG_workingset below?

>                 return false;
>         }
>
> @@ -851,7 +861,7 @@ static bool lru_gen_set_refs(struct folio *folio)
>         return true;
>  }
>  #else
> -static bool lru_gen_set_refs(struct folio *folio)
> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma=
_flags)
>  {
>         return false;
>  }
> @@ -886,7 +896,7 @@ static enum folio_references folio_check_references(s=
truct folio *folio,
>                 if (!referenced_ptes)
>                         return FOLIOREF_RECLAIM;
>
> -               return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE : FOLI=
OREF_KEEP;
> +               return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACT=
IVATE : FOLIOREF_KEEP;
>         }
>
>         referenced_folio =3D folio_test_clear_referenced(folio);
> @@ -914,7 +924,7 @@ static enum folio_references folio_check_references(s=
truct folio *folio,
>                 /*
>                  * Activate file-backed executable folios after first usa=
ge.
>                  */
> -               if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_=
file_lru(folio))
> +               if (is_exec_file_folio(folio, &vma_flags))
>                         return FOLIOREF_ACTIVATE;
>
>                 return FOLIOREF_KEEP;
> @@ -2119,7 +2129,7 @@ static void shrink_active_list(unsigned long nr_to_=
scan,
>                          * IO, plus JVM can create lots of anon VM_EXEC f=
olios,
>                          * so we ignore them here.
>                          */
> -                       if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && f=
olio_is_file_lru(folio)) {
> +                       if (is_exec_file_folio(folio, &vma_flags)) {
>                                 nr_rotated +=3D folio_nr_pages(folio);
>                                 list_add(&folio->lru, &l_active);
>                                 continue;
> @@ -3188,7 +3198,7 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, =
struct ctrl_pos *pv)
>   ***********************************************************************=
*******/
>
>  /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int gen)
> +static int folio_update_gen(struct folio *folio, int gen, const vma_flag=
s_t *vma_flags)
>  {
>         unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
>
> @@ -3196,10 +3206,15 @@ static int folio_update_gen(struct folio *folio, =
int gen)
>
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
> +               /* Activate file-backed executable folios after first usa=
ge. */
> +               if (is_exec_file_folio(folio, vma_flags))
> +                       goto promote;
> +

Will it be cleaner if we just:

/*
* See the comment on LRU_REFS_FLAGS, and we protect the executable
* parts to avoid typical IO thrashing from reclaiming.
*/
if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
    !is_exec_file_folio(folio, vma_flags)) {
    set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
    return -1;
}

If we use same check above we also get the PG_workingset?

