Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E45BCD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0AB26B00A8; Tue, 16 Jun 2026 23:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2056B00A9; Tue, 16 Jun 2026 23:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F90A6B00AA; Tue, 16 Jun 2026 23:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 671676B00A8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:19:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B774A1659D2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:19:11 +0000 (UTC)
X-FDA: 84887948502.22.EDF49E4
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id B788240002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:19:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZfayOJWo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781666349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAy7a9czQBZBVVerCM7ZGuRtq5E5UGyMaq1waArothc=;
	b=INCazXCtmW50Rk1DqBeFx2Ip60R4Asf7E5DXN6wyuRdmtd1SpEA/kGFjNiR3aWwJERyWZu
	Q53Stbj7omvKs0IQkI0TPjpbvakD22xsQstW3H8B4yh41h06hb/7Rq51hBlN1Now7iq7xg
	j2sYddbW+JNINWBWClEHcl/DqvjjkBg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZfayOJWo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781666349;
	b=WsbFuokp2YMajPe/6/Od4ZYs2p4MQev92Y1VC9iAAQafMVi3EFqWMw/pvrRYmvwvJLEkAp
	rLxCporyBl7uneO9L7+Y8VRaSGCde8lm8VHzyv/zJs7j/25HenUX1orTiIM8QkvssoQplt
	GrZ1DeDfNsDSrfZntHPXMimZtbzC4fQ=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bed2195323cso811950066b.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:19:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781666348; cv=none;
        d=google.com; s=arc-20240605;
        b=IbyT2+8z9CYg3ifTtyoLB3za3TsoF9Q0NZlkHVoG2pjJytl7FYUKCaqm+1jJbxR1Sy
         OdfKuJWUg+bvJP1YMdD3ae/a3OG/8s8hMyaCw1miZDWqJ2tVpCx63831uNbvzILIHdRe
         2Q+ypkJe2VhvFePWzw/osEYDyt2MlkSXEUnbMm7dM5iKD6ivHaohJkRMldrV+biRBnIZ
         3MlRLC9T2YExMtT6azdQhEzWfxRcDtKZkKCW8QJgS92Vc7cpbyBw2qo7QIukCuQFkesQ
         6vpY+rF5bhCZghwi3MrdKpdcKoLwphI4mfv1XdKuMcRUR4iJexNqqBUErqhxOV4eLYgj
         X26w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qAy7a9czQBZBVVerCM7ZGuRtq5E5UGyMaq1waArothc=;
        fh=kvrzMOMfj4SgBjIpBawZ591WmwcwG47MsDwaObAAE54=;
        b=X5F1ksJjqW6UOvXWPEEwN3B0HdnKIcZZlkTbIdm/b2mo42XiOtP4APDYdZJwRJ7aBG
         QTTf/RUD2hf9IOhs1op7OgHvDCB5VBXZ0gZ3HKzqwkFkHl9Q5/RVHs3BjXZxPsN3zvQK
         kSkR0u4i/8Bf8RXbiRw4mR+mvjMZOlUN6PHykUmZJDA2KxATk17Gn1N4voKD/y96pOj+
         gxdHolOLjakyGm1n7virUIesaK+u8a1GX7qRz+eMhpn+IJR3gvGsMjpHeS0TJ6A8sEAa
         YXBBXkbwy71Y4+Mc7tBXR+KPfIBlTo1ZrCe60YwghqQF7WqmCJWIkm8iXDM4/yhQnTE1
         0KsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781666348; x=1782271148; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAy7a9czQBZBVVerCM7ZGuRtq5E5UGyMaq1waArothc=;
        b=ZfayOJWoXv302bwl+xPMi93mEO/nj56/Au/X5CR8iCzHkTCR6PNeDRrV+oIeNZl/TF
         yCTrD0XF88uc3B1DtZnsG6tPgSjmcYYhu3kbGnfpI/tE8LBqtJldNoKQE6bAEvlrSjLZ
         kGpvcfxYCNyjGJj8T8nDyOzsZDyQ4w+Fdd4l2by0cn3gKuEIAb29c3TYlMQOOd9vSazK
         BQB4JgmSbi6Q1x+oisPH84BJ7CV5ThCe+yUBE1jCmSB8ikbU2aTeKrPKgQU1SsHUhoCh
         XpXXOOhxyA2GlZKHHtG+gjtTkJLe5KC5LmX0ZeGmPkdcos1eA/7DUEOzwRn5zgJecuyp
         P7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781666348; x=1782271148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qAy7a9czQBZBVVerCM7ZGuRtq5E5UGyMaq1waArothc=;
        b=NLEU0I2TLOlybdwtq4dBQdXqq5jyhQ8YyFco/D3au2jhdahhkv2U70TZYRxkoHJlMG
         Us3WaVVEBsRj87VkR+ZwuTllKPMDhXwYINtmUlS99mn9NVrHG1FF8cwLxWFUzVBKyrQQ
         jFS2xBS0dRaXoujZnNoQVFFssxmFfOAOHfqhMFjzKsyoLjbFz2znmfBYbDvAOTY0gPrw
         XB85YDlGyhsiXgRbpdu5aipj4WMI727jddVh8SjhXphqPIiG6RDudHekYAE04r+FBmhm
         +i/UXMArqnjc7S5El+LM/rmEWOIMjYHl0QbS4HbenfyJJUt8Ejcs0h8vJ5pzGtQmJYnN
         2rGQ==
X-Forwarded-Encrypted: i=1; AFNElJ97DR0DVSLamOO589PoJPUFxqvVZVpvLkMYemD4DcvmtmYcv6iEvrqE1ZkS3f2BnnaV/qV27fM9wA==@kvack.org
X-Gm-Message-State: AOJu0YzDFCyeNpYL0IZ/WkrblfrG20cdW5pDdPWWlS1h5Iao3F0V1RaX
	r4/9Zo3+tEByonBurmso5Avr4AbHuEmcZpKCB/+m8p4pkdWHOsXMETMO4DchZal9UFmtAox4/ju
	r6Hx2zHyUSGw2rwq6lflQOYXUq+dpaJA=
X-Gm-Gg: Acq92OHlJFOuPl5m2rs/yaCx6ioB7tuCRTV0dzoZDoL73vhQ5hLCQFpgEz/M+tEeW+p
	N9xzt7AZRQ+KjufiH55yBZAVZ1LXmhpDZHducJ6bBVUR6xlrE1GvkEb9i788LFSFroRAnO8K+pf
	WxLoHbpJtcWHzTTH2va355MtB8ghPtbYvYVNcnIf+8UGNC5LswN13WpBs/NqkzqjhXMk06zPMGe
	XDEW3YmqY5gABB3l0naljL0mgExTfYKbuJvq6HiDQCK+T9LjF2f+pRpg7xn2vI3R+tHsPVyFBTI
	UTd9iYh4tOJfxKO6OxEKezCQLiflVQ==
X-Received: by 2002:a17:907:7210:b0:bef:9f62:6bda with SMTP id
 a640c23a62f3a-c05d2184cf8mr79227966b.10.1781666347764; Tue, 16 Jun 2026
 20:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-3-baohua@kernel.org>
In-Reply-To: <20260611105124.98668-3-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 17 Jun 2026 11:18:31 +0800
X-Gm-Features: AVVi8CcrDCPwKB0b0t8CF8_JMaE9tfJENvFaY-91Wzouqg7XhDwcEnpHalO1BSI
Message-ID: <CAMgjq7BCRc9jKe9QVHPQ7Z2vfxvN0HdW=8fcAD797fqSAC84DQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	jp.kobryn@linux.dev, usama.arif@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B788240002
X-Rspam-User: 
X-Stat-Signature: e4ue83iksbojb98ptje7xeium1edjo9m
X-Rspamd-Server: rspam09
X-HE-Tag: 1781666349-21939
X-HE-Meta: U2FsdGVkX1+v2VuvBehm2MEd2WZUuwtfSZuWBqkRN6jGMouze1iAvPb2bL8zLSOor0OZKlmcQmpclfhXmMz69D9HBO6QD3xcCPVG0hyi/wmeKVj8G9jdQJOLParChG1pgodO/YJd1Rlkzu79gb+FPXdne1/hpF6T0zUQG9lMpBUahsvvR0W5d+XodEpBUSXAyxhlWUdqks/h28EoVuHThe5Z9a1mOCKUGwocB7wSLqyD+SYmCyApPegPxsZS5cBC9zdqFpo5ITRap5UNKGrpDBEUEuGo1f7oakRQ4B4EUTnkqcam/nqLH4Ka9JJBwTKMOpZU7dRXAAWYdDdGv0j/RTwtQs8JO0UG5fmMr+ouxlm4isoLsOzc9TFv0SPYMYg3b8DdMtyFRQLljIHpGWucM/TaJk32J4UEGiBhHW/T231ETwdkG4N4/CgZ6uG+YzgkoABqbBIA2PezUYSrX9EXciBU9EuXTlr1KNiljYKMvssueapQuL+/9C8Rgm+E0f3XtMuD4JOgFFEznjE1ugc/0gIlGv1Ze7jY9LFFmqjdAWjeZamoMerEPe+8rmAKCmmKyvhvopQOGsxns4dQa60mcgLSNk6HnH7ttPjgNXnKeK4S6EopNPq1EJ2COvgd89AoS5HjCYnAUx08krJCGkhunxbXIyyxNGtEzTHM2U4lVDkheVqRuO3dQWAlH1silKpcJsbtydPOvwXMSkqhDSxZKqb7X/5HFnbqou37eVXN7rImZeHT3OMiQ6ul94wKcbm1fpsMnBzOUq6JeIk7iXJPHmJlH2rBAnDktLW2EO0Ki2X0XtHF1wFglAqfnbdnrY7GFtRn2qfmFbL53UK91Rvi4ErcOv3J/Imp3aLxrA4Xd3jpYoOlghgvkyQBpWaL1y6eogh6bFUensVlbbnDfOoHQ9WdBk/e2BIkkjyVZAYMuFwxk3MXWOlGJXaSuz7fHW94JwauUn/KS0i/4peJOI8
 4LKkAHgB
 fb5HyAGhRIHEXOj3YsXInt37npnowgd3VaVYLZ0n4IIx7mcMQL218vK5p2Mw1qeUFJfPOKGMA401hCPX9K5A8bfHYEod/b7oR+RJ/OZ2Nd+YJUqh5CqWdjTP7YmvUHQwdCTvy27f/WK4hv/CyaR/aoisMOzKpmZWxknq9+odvffFqZyxwcnMZhR5lfDu5ZaxVpTP7lqoG5iFqwmx4Tj2NOysYNp6cGXklHqNG/WTJBSVD8loYVOiXQfTYQHgyaHOqu7ZD54iow+1+P1ZK154E7sSZQVOvDmbozVD5rs/2edN7Gp4wqXsfrrQxgHXiFNsupi6i3s8zyTQ/cdcxWOINzHR7+R3/cQNa026t1sZzI8CrG+J5SACpwH2jDFJ1r9VwUIP2u7JHz3t/KBWagmZYGeQT+GxthRef7riZyTwKoH9CbrnJ29YLccvatLvfhTpHcPPAAdADm/FNkbvEiTMEZzI4gtp0EW/TpCr5DKzavlqlKWTmcEVxMrJElw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 6:52=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> The "we just allocated them without exposing them to the swapcache"
> case no longer exists, as Kairui has routed synchronous I/O through
> the swapcache as well in his series "unify swapin use swap cache and
> cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> in this path, since at least two references are held (base ref plus
> swapcache). Remove the folio_ref_count()=3D=3D1 check and update the
> comment accordingly.
>
> [1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@=
tencent.com/
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 487a34377a7b..ce8ef27e7a54 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5049,12 +5049,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>         /*
>          * Same logic as in do_wp_page(); however, optimize for pages tha=
t are
> -        * certainly not shared either because we just allocated them wit=
hout
> -        * exposing them to the swapcache or because the swap entry indic=
ates
> -        * exclusivity.
> +        * certainly not because the swap entry indicates exclusivity.
>          */
> -       if (!folio_test_ksm(folio) &&
> -           (exclusive || folio_ref_count(folio) =3D=3D 1)) {
> +       if (!folio_test_ksm(folio) && exclusive) {
>                 if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma=
, pte) &&
>                     !pte_needs_soft_dirty_wp(vma, pte)) {
>                         pte =3D pte_mkwrite(pte, vma);

Reviewed-by: Kairui Song <kasong@tencent.com>

