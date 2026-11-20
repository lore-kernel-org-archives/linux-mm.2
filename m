Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90E1606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ve3CXvem
Received: by kanga.kvack.org (Postfix)
	id ECA856B05D9; Fri, 20 Nov 2026 03:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7A986B05DB; Fri, 20 Nov 2026 03:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D426B6B05DC; Fri, 20 Nov 2026 03:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACDD46B05D9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:20:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DDD7A0E02
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:56 +0000 (UTC)
X-FDA: 85454801712.02.903E23A
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3CEDF20002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ve3CXvem;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795162854;
	b=b0oFbZUp/JqzK0k3lZdapAy0AlU8nGXOChlD2d5wJ6YYNJY6XY6VeXJ5UbOStGoIjkWc99
	RrS5DX/IfjfqpBrZ3AgIOroe30a00qCgIEcmwrPRzQjsJBYCBda18qAOP900TAXvFlX2K9
	2Msd9Ceu/8fcTO09RqNYwTJiO1ITrHE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dg/jopXxk1E9Yu4E4faWsNPyyS6g9t3vWRabNCt8U08=;
	b=p/QHqdtbfs93eP2KZGfv3djcH3aEPYXKggAqeMVBZqNxRxxA/WYF4nGwT0OZfhbH9XCCHy
	pVSWXSmL+tKLguihyiHoStIoKPZJ7zFmSvrv1Q0gRdECZBPXL91+He9Yj0J4hlWNoLpkHw
	2CLrwl5e5jBQfCN4eSfc8Ga/g1dlSv8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ve3CXvem;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso3119275e9.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:20:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162853; cv=none;
        d=google.com; s=arc-20260327;
        b=GRd0E9ZFgCJw+fvyirTMdSXmr9zEBZvzBr+8Hj0Z0bxZMqIlF3ol/DiMnVUKDAf/ok
         ZHcH3sT8623HC/f/vMA7XWFII4p/3UJn9ieGx2lvgS+wuMp4uUf2uvPPj2PeauK+ZhJY
         vwxGl5qUNGRp+iOJ1bmxB/e/B6uxYZYHZLSbxIEg92n8gfTJNVb7SrARRTafu/0yrmao
         fu9zNzLG3Mt59ATdOWT7YDG7s/TJtstNVF+TAxWcUHfYqSgBaYbEge6WOkfm7Yu/Fwgl
         MoSU1CB3X7oiOG5aS9dXpckQHFeVD7dDbQzDlEyoqdqP4KIvsr/rI6cDL+pR1bqPIR7i
         ka8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dg/jopXxk1E9Yu4E4faWsNPyyS6g9t3vWRabNCt8U08=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=O0dLKYQMHxOC7Hd03DiyFRvhumMz2LLIef4Ga5+4NnFrJHfRrnjMua/0rzZDvo6EY2
         tjLheY9a2hSon0Ld4/jq28dNrQB95yL2qCvcFjD93mK5DRtCRLoTxJTsKQP8nHT/6Oyd
         iJMH11cwBSkzIAgEv8oMHIlX40TYGqrEbJG+JQySgYq5mYzB8xFyewJXR7KCGupBF3yt
         akQ3Hy5A8NY4y3C4ooNkeCoT5wiSe183I81VPlyC3gBFfuVExbt2kpDUQCHig+gJusL8
         zJLZlfbS8rtkpXlLjjgJVPEHiPjakghR3NJWo3Z+dQ83Cswr9mxHSpnpgJYMMq1rBRWb
         TYEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162853; x=1795767653; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dg/jopXxk1E9Yu4E4faWsNPyyS6g9t3vWRabNCt8U08=;
        b=ve3CXvem9eyUETYNSqbjr6P9pNteYBWJzsY65tRTGCE48SFMR218f9enXnjpbc1Ywf
         vtmmkHget0kDMIFlqVviEDxb/AjmReNSSJ/ROad9lN9puZy7Q01I0pLJA1UlOjS7Vmfb
         8i0pBrDho00CW3DS7Yyd0Iwmi2r/LzNxgLoBjWCe2Fpcw0btYMLQ+c/mRuaqZvJ2ngqK
         1QtWy4v6LlyzRFRGXn+HASxOniLBTisWGXW2vPFCsjGDZ77uPCHz+35Nks3botCmoMRb
         aSrBul33JWvo0GkirtjsUoyyvvlWNSgI+tRS7skY8N2+Q3Rw4p4vI62YowZE14qd9Fq5
         SPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162853; x=1795767653;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dg/jopXxk1E9Yu4E4faWsNPyyS6g9t3vWRabNCt8U08=;
        b=WGyK9OtLzxMR8E3OKv94YOn/XiYvVcnLQWnVQWPSe2au+EOXniU8UaKBsP0JfXTEeK
         Fo/t4MxypWioJ8OnLQsFvAkUgSFEV2KtnglzCpYDZYzTaZNlxq3E7QF/KVqojtX7ECWU
         H0SUjXnaTFFOFJMxfYGV2pRvDU7XMu1TePwN3oIQdiIL4uFTJr8JPYtom1sBo5dqq0DK
         VPOQXTqT+L4FTmRQliyzvPEU8/2RKsz9k2X/muJ9+NbdC3dNkEMF8qR5nhyy74MThFq/
         Upd+XrqrV9GYKcIbdghHVJzFwZ/ULGzeeVChCu91ROaOSe+zL1BoOEpY+fmKULeQCtMY
         KK6A==
X-Gm-Message-State: APuU4Z9mkMD2Z/MoZo+T6GNFe+JrHacdR9zxtOmZwA05Ys5uxuW1zY5+
	NcbxARK1Iqd9jqtHJE3K8S+IZJ5zMj5jpZ+bStxmvnDUW+b50Eeh0bVPqLKs3N+28zDcjaxjbi1
	87/gKUTGT+nLqw8s2QjtS0hUBZQhV+6U=
X-Gm-Gg: AYBFou1MVaWnMlLLOBeqaYixGvXjMSXJGcB9h4binPxdz3/9I4icshxB3z7EU69YIZE
	Jm0Nltx0WmJT5WBF2jeBQGx+JdgadT41SkI8yxVjWKAQcAcdu3Iu5bIVy9K5Eb1ouDMel3ZKgL0
	4Aeeu+4zcVrUsXew8A459VpN168mLw/OaKlYGetNHiifQGUsg2WMDrrqI4L5tqksnw1Ukj43I8/
	SoiIS7PNcw9ZdpOeXXzCr1gzWOyPNve4ftyrBwhDILDUJHQ5XBS7eBnCqDef14OLtV8lYg6Zugv
	cyRkeVoufprhM1JE0kyvucWNljikmWJMBIsgRzIipSGcafHvQrgwOcqfVv0RTZBL7g02Bws2Z8T
	M81RZ0RHZpehDcrl1qKqFfDg9d7AqRiOMW+vemmjEF9XkUR2qZ6iiP0WjaKdloGruB1UPS+A8g+
	8YaxgCPH3M
X-Received: by 2002:a05:600c:5303:b0:4a2:1655:87db with SMTP id
 5b1f17b1804b1-4bb88785d2fmr48529755e9.0.1795162852274; Fri, 20 Nov 2026
 00:20:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-9-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-9-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:20:40 +0800
X-Gm-Features: AclHuK--KpLypcFnORd8WwLwhQcGdUQKeMSvpl7k7o-cD-MnrCJ80Uob7th_vPU
Message-ID: <CAN_Opa9CuEB4NiE_+c=033ziMxqo243Ev3JB0_ctgk27kD-GsQ@mail.gmail.com>
Subject: Re: [PATCH v5 09/17] mm/mglru, gup: mark folios referenced via a fast helper
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
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7ymbnn35ikpdnoakhz8zxgbjfzbz45tp
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3CEDF20002
X-HE-Tag: 1795162854-771812
X-HE-Meta: U2FsdGVkX19xqmstqFC6oOxKqnif3hrIpAquc9CsQ1hh5cOH1PszBOqQ70R3ymxJA+6sdZLTtC1+EMXhvIYw/AcMBKNJeZXU08Fl2crQ4b/2pxEDIg1peC0lmZHqt5tC9gumZeQMBAG1n1g0I1sPezyHWkQFZz3FVpB+fVpHK9pXvyhW9ZbsHexGEkZEHjpkVRo7qAiuOOPe2fD8yjkbw8ruMfFE6rcYOiVizfNgJTCcluIzYMyHUV4ZnsWl7kfYj55hxKEMAskIV38Jst2g7587DDpjtVjSC+WFI3+5O5oF2sgwPX74bn4/9d7PYSvj+pD80OpM3nCg4T7IIg5Jq+e5FvkKHwwUZgQxMOPqKh2MvcnMifAHesIN5DPJoBr0qYV7GYSVN66VFsNz3M8CXd5iStEkB7LPY4LpA8/HpTxx4sXKwL2NCl1pqf1SC1UHZNxS3iwkg5FpkWFNtIYb7qkyQzjsz9AR/dcqt+Acd8q5fAz7X0Ul7RFvYorvnvpbGEoR2QflDtWBHLubw8KgjhgESSlHkncUBUYOxz1z2nXM2jPQcxXTbsz7UEnQOncQISwmR9R8JSbR27BKdYWSClv42tJ4DatUplYlcVPHkKLt4wUd1eZaAsKoYU7vhCmF2JPeGd0Yb4cVZZjwdZenYBrH8lFzEe85gn8VJdz5gzOvE2hVIsHoPzDMz5YyMIBr7K7ebE5rzoyJfSKGOSFdl8dGW4XLODtygjdV7o6vW40TO5kHWO9Uf/Ug/nuEuoo0mZbrs8iT38ButIILD8SA1OSV+gRHvtaj1oQUmdTYDiPVc/1HqeVZhDdUwMaXLv3W8c08+fCJ8Ji11Ei3TaRv+HV7jsFcJvCLz1a5qnsqpyzG4c8Ghy5xrkb2DQ9leV/Q2qWcC1yGz9bbvCkDy3NweA2TNjIlrn+psiCyvWrmzbdcFAxlKbJKTv0jcvI3L6s/Jw86044QIbpuBQ4omsO
 +7ltcG60
 WW6BezN3PlI8qljDtJZJJR2lt+B+1L2cDDcezkkFS/4AlaXoryZzwMw41q9H4+alVzaOWyJQ60y4UzTk41RiQWfTSwyxij4z/Z7MxAdy6xC53etRKLCosotLv/x9gWPLFBnhzGH67MV27mwvWW9Nx4sXPiB+Vz7qHcLLw8WvKDeriax3Jobqtye4BM47FRxLe+t28U5a/QtdtSquETW4lsAeSauPZhK97WB6BPHhmj3i+WnZcjQL7sPiW18oqUasUkRG9Gy00+1iAVlrR24uoQO86uOL4nATwhD+1KByARZ5UQuJO/6wXJzDtWSnF7w0S3AVUPhEjCIEFOa6Mz0t+TnaGhtdoChxRIzJgZsE3Bw4qhe9FPTR5aK2GMFZyTL2uDfv+WRkDbyZg+WWwKAvgk0GoNqAqMnFePpyYbhhNTXA/Wo5ZVvSgP1n+1nDB3D8AKqwnsfdCO5cnjuQOJ5tr4G73TaLX68VCI1ISXDKYiiYM7HvZdMM3SRMDs/7WXmIPNGqzH6rHN7kgi9OLc784FGNScWCT/km7zxn8oPRczJi3c+RNp3+NhxnHrJRGUVBj3DhdEM+dxswkKJcMwPd2I0GO3aviED1D4csLxWgI0Eapnas6+1WWvn1J5cs1uhzayNKtW+lO9dLmqgVnKw0cUwX37pxh1GasxakPgUd8s0wqfypKmH8S7IoLUnYDMSTTlxLUzsPh/CNAlmO2vsXjQl2kmH+JushagzE8MVxI4zvq2qiqy74DkSw4o/M24g3wx+LWSOV+S6lCzAeXc1WXcq8PXc1AB5HMXe+lacfuAxEETsllAyWZuMyhDqk/gl/49U8k
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
> Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
> LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
> classical LRU as before. No counter update or promotion is needed,
> nonzero refs are left unchanged.
>
> This helper only aims to be fast, it exists so the gup fast path can
> stay a fast path. The new helper doesn't account refs above
> LRU_REFS_REFERENCED but that's fine for now as GUP never used that
> or anything similar for CLRU either.
>
> Convert the gup fast-path sites. No behavior change for classical LRU.
> There isn't any regression for MGLRU either.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
>  mm/gup.c                  |  6 +++---
>  2 files changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index b15c3618a1f2..3323a3c7336b 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -483,6 +483,31 @@ static inline bool lru_gen_del_folio(struct lruvec *=
lruvec, struct folio *folio,
>  }
>  #endif /* CONFIG_LRU_GEN */
>
> +/**
> + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> + * @folio: the folio
> + *
> + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> + * untouched. For the classical LRU, a plain PG_referenced set.
> + */
> +static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
> +{
> +       unsigned long new_flags, old_flags;
> +
> +       if (!lru_gen_enabled()) {
> +               folio_set_referenced(folio);
> +               return;
> +       }
> +
> +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               if (lru_get_refs_flags(old_flags))
> +                       break;
> +               new_flags =3D old_flags;
> +               lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +}
> +
>  static __always_inline
>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>  {
> diff --git a/mm/gup.c b/mm/gup.c
> index 2b405cce2ca5..596e62954659 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2911,7 +2911,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, =
pmd_t *pmdp,
>                         gup_put_folio(folio, 1, flags);
>                         goto pte_unmap;
>                 }
> -               folio_set_referenced(folio);
> +               folio_inc_lru_refs_fast(folio);
>                 pages[nr_pages] =3D page;
>                 nr_pages++;
>         } while (ptep++, addr +=3D PAGE_SIZE, addr !=3D end);
> @@ -2980,7 +2980,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, =
pmd_t *pmdp,
>
>         for (i =3D 0; i < nr_pages; i++)
>                 *(pages++) =3D page++;
> -       folio_set_referenced(folio);
> +       folio_inc_lru_refs_fast(folio);
>         return nr_pages;
>  }
>
> @@ -3022,7 +3022,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, =
pud_t *pudp,
>
>         for (i =3D 0; i < nr_pages; i++)
>                 *(pages++) =3D page++;
> -       folio_set_referenced(folio);
> +       folio_inc_lru_refs_fast(folio);
>         return nr_pages;
>  }
>
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

