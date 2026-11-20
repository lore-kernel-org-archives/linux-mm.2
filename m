Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB76606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dZ/ANrUU
Received: by kanga.kvack.org (Postfix)
	id B15F16B05E3; Fri, 20 Nov 2026 03:36:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE616B05E5; Fri, 20 Nov 2026 03:36:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04696B05E6; Fri, 20 Nov 2026 03:36:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72A406B05E3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:36:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A6AC1C487F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:36:28 +0000 (UTC)
X-FDA: 85454840856.08.30BED46
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 72328180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:36:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="dZ/ANrUU";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795163786;
	b=O0Ugd1tjmSdRBnHhA2Pv0ymxfhgYyfd1LpkKCzqxGq7qfJykPQrZeO25phSBnWDT9W93kd
	hCD373KSh/tbodX+YQjqh5529ENaOgP2NDr5J/Suc6Mh56YmWxkxNnlWsi04fx7w/GAMRV
	vvj5Hwe/+ZdCojo+5FCsn/+5L9gpikw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795163786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
	b=tiLHscTrgFhPRbaf9UES+BQj8rJR0vrptRggRJnjUdu5TQerZLka6bbuCdZPNTbpgvOarn
	d/2ir8rrgVKlq1EQKGU4kvDr57qwU/CdL2moCCkqQpyvwg8vw7f8vEpGoB1r1ua90gsLg3
	aCEJnNEQQJo4McysqzQwikp6QCHG0EE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="dZ/ANrUU";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so1038181a12.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:36:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795163785; cv=none;
        d=google.com; s=arc-20260327;
        b=A0qpob6KPnY17/pEdXLjlwPlMtKcUzgm1Bu2XuRT/mxLkDLGY//SW41H2Q7dpaSBT6
         /4v9uwVn7J0mbswywgReIJ85799Pp6lvdtSDUy+h+8iiZH500LfDQ4Iu+jTu/4E6zEGj
         SeHIUQa0xOIaOjEOc0cNpSCAFT9atVEtFvx+XAM+SLSTMmZ8AvbeJ+FC1x7Hs08jQ7+x
         r4jFLt9fxcUGAgrHLIOt55pLAciF6hn+oO82A7200tE99iCQ4s5E6clP4iIrhqWQ6cmt
         d/C5aMvK5oa8sTUT53I+zU12B9hXMEp49hfLTZxjepva72IlHKmtD5wzpHTN2nnfhIHs
         Q7fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=lv4RSUz4p0akpmzPOE1RKUtL9jnNQ9sn4HAP42/OTPEx837dOL923/ySpyH+CL2ZUY
         IbZnCkyTb1FHG8l9OhZYbgPszlRiqY8QYh4bkxfcCJmLblds/QuOPnV78av5tOPoiR8n
         J7mPECiREBBvlaPLasIEKLLKUixihGnOR1xdVdASr+tMfZBcM7gQGamEcRpudA1bHZTx
         iPVLLLRHUkLhPACDuDCGkJjx+ZHdslbgpUiDlkfUN9may5npVm54AT+4+b6iL79o4Vi4
         Pyf42w4Qh33O6rESV/4FUTv8/tcjZRD57ANAB8PePxrrZWoRj1cKJmNy8xlB6BP3IRT5
         KKoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795163785; x=1795768585; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
        b=dZ/ANrUUCrgBB0cJTeGmZQHRxMHUw68ok4v3QgzkdmjnAxm86RDN50Y+v3CjNaH46U
         7gd0bMU56rbPTdJiC7/mPO5t8jG9tVcprKZ+0bhK4rHd3U2Q9VbsYTy9UadDUN7VfdVZ
         Puj8WCWXUB5GeFWqQep+tNesQyfuYl2r5Kv9qJyv+QiJifUtlmLcYS1i9JIWwZSqQ4Lj
         MQnWBPefMFoB3xdvXTtKct6BjA0Jm7bX2ZnB/gsfKVfL6owEQauqpoFpFZUXQI7L4BNQ
         hrn8sRAqG6t8fezLloy4z+A6IH5iBfcb6pMSkGa3uo36qqzmqewxoc+fs14BXWwZm5x4
         zEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795163785; x=1795768585;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
        b=Z9Z0hki7mvZJ5WXky0jYW7T2/aHU/UFwTjIiG2tCxrKS3SR8knOJxZtMXHi+gtrw6b
         HWb1k+q0qANkWG2RkA7tGb3fDODXsWaCb4+bBe6WiRGKXEcoSbcTYI9/E8hcAO6HpoTy
         PVNro/nNOskyel6keGnH6NvE1vzb+l79Cjg4SGMKpM5RB/0bdpfem8C32wgF8FpbvBpR
         nv0TwGQDO4id9tp9lnxglFeIKhlPL0fpv8vdjI1wmiNus1NfcECwdbRy8BLu1huVR2z4
         gxIeFBITLDIdVl8lGXYtkdsWsd2ArWVKCJnsKVAs1XH4PzOq5KAD1MB2vZYNs6uwNyL9
         AzhQ==
X-Gm-Message-State: APuU4Z8/7IiZ6aHoTdij7+wfGKpjBNaZ8jOEPT4qyKXMp9wOf5edHbkD
	UZA0fIDRHL2lpEWoBMvHG3mso6KeIKns1tgBQCan+cMChuPGA86pZ9Uk9mhwdHfVtAE/TiDHdtb
	yezNEoTx6FnbWMWXA7m+v8pPep2bRIpM=
X-Gm-Gg: AZFdTZd9M4pMgD0+kR98QhM/s87bOo4kWKGXe4VYoNZi+LywutUF858z7v3s7UBJO3b
	1kRXACm6pslpLzackE8REGW7ms5dGbLaC/sSdBUVwyCNk6elt9eS9wPaKkPe6xUmSWjCkbgF5LO
	WAk4LWJcclUQV0Ju8VUARxDD2Rh7rjAb142E573BQg14SqC7y9TpmWUSSazLnb9tGfiGJHrEIMR
	KAx5iU8lH5S0gyK38UovIvnUj4Kqn1bvAqvS1A8WmqnqsOhGFGhxdGw+Jxda2btNE0lJrNylBjJ
	4zlPKV9IzQUvOXPsyUHoh0BwIy1tZTngB/XMe2XhvdUx6Jpi8djTR5wqld386K918vj9tbIX/yt
	YA1izmmTbX8hGvAdqZtP0hdfcEZl9cs7TtIssoACTgQhiGJzKVlT+RgUAAulHNgbp+g==
X-Received: by 2002:a05:6402:1512:b0:6ba:12e2:46f2 with SMTP id
 4fb4d7f45d1cf-6ba37d18d2emr1237841a12.8.1795163784752; Fri, 20 Nov 2026
 00:36:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-14-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-14-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:36:11 +0800
X-Gm-Features: AclHuK9a_uzFGbOjQzRBvuGpHT7FEd2GEgizUKayktzr9rLjRf8PKuN-UHaqZ64
Message-ID: <CAN_Opa9qsHLGSPUjUJB5rCfD8T_zE8R1YpipcmYCqv3tGYuO1Q@mail.gmail.com>
Subject: Re: [PATCH v5 14/17] mm/huge_memory: mark folio as accessed more
 accurately on split
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 72328180002
X-Stat-Signature: fkufztpwqafr1j6mz11zfm4bf4d9m619
X-HE-Tag: 1795163786-686757
X-HE-Meta: U2FsdGVkX19rxHcLB71rRQLFQCyoelGHeiwu6/+9V6HIUgkkTmo+74A52o1dHI/N4quVcQIAAiA7tuBTkSmquC+ocTbbaHtyb/VoTy8wGDW0JDcp3m7ut3GFW0BZoQwUufO3jXNjnODqteqEh7D6m/3AxdBKJe6TfK/AKMRorHvPP8PJfJWfsfCC2JbpspavlJLTYY46yve1zHm0Pb7ymGI4m5elXW4yNt/+qGfiEygimLtyAibcxT6FJ74lMe+VPn8HVeR22UIqKn34FNU4q39d+EzgJ41wXVUtxG/Kl3JgoFnfuDp4P80qBGEyL5kxoBQfafDJ6Epq4kwnIT8DcF+XeIc+Dhy2PfIYMEQgcwbohumJq1IyyyCgRzSyR7onjpc66S0kidRXksYdg6b9dLI0dedpT8twR0rI5vyx34s+eg3rJbz2ywGNq5aQrfzYWfodGKiVa/bJgUjsPk1MyuXL+UmbR8Fczk2DR4NV8yxGRdY+mdABs/U8HuLGTYyzSiTr/WcgN0pAz2MGT85Zvjp8XoSiwoj0lF82TQNQBj9NdvarkXOe8Wz3BSrDzcyfI0Nu2m9ifdHZOWmkqzXzBNFlipJNxPX1WzdOV8OLTazjhzEOEyGGDTLUbc7c6yyMPrgpSXLGGPUqIATHFn4YVmk3Gtfb64Oqt7Eq1YqCCInXYn1UxZ1xn3jQ0oHvzNTnMDzc4Y5s9pq/voN99bcUdiCgTyciKaL0QAWrWDpl8nq6HoImNx0Bkf3Qf8RZJM9dvERI7Ww2GAoYWsy3cZ9D9OuJnK5MpRe0F5WfZ7XuCnxsay/SfapIYFpP+x0bTsATQdBq207vOaLqB8LufS+TBQK6xybH7CyLcYPOkpFeadwcv4rXNke/6kiqIQK13GaodsR/rTzw8pU5QXSuJHg1O9fSus7BsVKK+MPzwNyJrxBtOGfNFXwy+1WRc9eFZwXl6BM2/L+zI51i/cVjibh
 bZtmtYe0
 dnF0X813222DSvvQqZ6TrLBm20FchoPNMce9HzOzN2l7vgvP1d9zXCNP0t0qd73s2JbNs4OYkq4Plx2euzALavGvFbeTu+ghilDDEH/q5B0R1NP4GAE9XvWrsHF9Xfopd0U+Yyv4Ldy3EyEQZHp08L9ppefM0RRTEhb6guRssnwIesJEKd9irc6gvtvOqrJxiwkoiPjrJk76V+5qDsl/FvC71XdfBQZQlNnyynUdUk00CQCwyzpY0kxjk/0fvzRf5yPJE/oHM7quIuiGujmt/vgxVnjf2kHb0D/bozPSP1beWsGa6omyjMRcK8z/IRpdATEATmc5RZToAJRu20vtQUqbtb+ZsOyK+mTlaTUxzvxmiyHcmrIlReJsZvbJjrEEIej8rHZ9pl4CyAd4mYCCKVkkgUliLsjXqMTpSg/wOwpaz+vSGrCYgNc0Np4BtlOrGlEZddPJ+Fa0YWtOwErjDgxdjrT0qSffuk/qPiXJs7WtXZkYznE7dw0hkr3ayc4Z3/NlM2NOYXpkv1MeO4GrMtunP7GcTrs+aObYR4ICvqy+eH+jbetM4RtU5ftHaciOTzmW5cd4udrH3IZN+TxMvvYkgwkM8lcWy1+9JVy6YXvr+FB4U5cdwYGtVtyGsGM10rCC2KptuFcEkCBY1/CUbwdOMv545jTtkMIiVQ2L6nP9pRrcpYz/pZTMWk1u33hv0Fdfi9mD3lmEo6qDLFYOk6VGIF4DJd26Z+SRnKUZg1KDJP6WJSy4YQCJPRW/XuBFGmrkPVT6y97wuDtWN5hKKgrFbFQngnQWAI8N/UkBVh599TpQWz3mHdFGqwDGu7lomkWvt7BoMbp4M0d4IlTnU7v0EIDRSodGXBvb+eEuf2qZHfxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The behavior of updating the folio's access info isn't consistent for
> huge mapping splitting or ordinary unmapping. The page table's young
> flag has to be translated into folio's access info.
>
> Right now it only checks and sets the folio's referenced flag, which isn'=
t
> enough since folio flag updates on access have their own rules. Ordinary
> unmapping (zapping) calls folio_mark_accessed(), and it also checks
> if the VMA has recency to avoid false updates.
>
> So first just use the right helper here to be more consistent. Keep
> accounting the young PTE as a cache access, sticking to the current
> behavior.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0d589be136d2..1a415a6704be 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3104,8 +3104,8 @@ static void __split_huge_pud_locked(struct vm_area_=
struct *vma, pud_t *pud,
>
>         if (!folio_test_dirty(folio) && pud_dirty(old_pud))
>                 folio_mark_dirty(folio);
> -       if (!folio_test_referenced(folio) && pud_young(old_pud))
> -               folio_set_referenced(folio);
> +       if (pud_young(old_pud) && vma_has_recency(vma))
> +               folio_mark_accessed(folio);
>         folio_remove_rmap_pud(folio, page, vma);
>         add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>                 -HPAGE_PUD_NR);
> @@ -3227,8 +3227,8 @@ static void __split_huge_pmd_locked(struct vm_area_=
struct *vma, pmd_t *pmd,
>                         folio =3D page_folio(page);
>                         if (!folio_test_dirty(folio) && pmd_dirty(old_pmd=
))
>                                 folio_mark_dirty(folio);
> -                       if (!folio_test_referenced(folio) && pmd_young(ol=
d_pmd))
> -                               folio_set_referenced(folio);
> +                       if (pmd_young(old_pmd) && vma_has_recency(vma))
> +                               folio_mark_accessed(folio);
>                         folio_remove_rmap_pmd(folio, page, vma);
>                         add_mm_counter(mm, mm_counter_file(folio), -HPAGE=
_PMD_NR);
>                         folio_put(folio);
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

