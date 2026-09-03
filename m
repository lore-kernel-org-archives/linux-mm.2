Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFFDC624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858AA6B00C9; Thu,  3 Sep 2026 02:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F306B00CA; Thu,  3 Sep 2026 02:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C206B00CB; Thu,  3 Sep 2026 02:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51A756B00C9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:42:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EF38C0198
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:42:31 +0000 (UTC)
X-FDA: 85171507302.21.93B89C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87BB4100009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:42:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhbKpu4e;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788417749;
	b=7oUE/2G7AonJR5SCsEvS4OefUoIzwSuB2htxwfo8yQ4LYNv97LyRydlARDN8wVo50pKomI
	qYma4ye4PANIZgCJojUKRWywJzUJKh/42rKQ3MeLiGmiIbDHiy/obrT2d0d1hMGhIG/Rxe
	EWKfncDtyj1leeTG9qk6ta3wFsbvI/c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhbKpu4e;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788417749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NoreS1c67SI6AUlE45CnZ5o1zP8316Y/FnI+L8qchEI=;
	b=DHYzJ2c0xrkiCoSy0/Jp8+NnWXCr0y55HwyRf02oMvgff8ayB4hRe4DFvTL2uvuMfIyKmP
	/Ys0e68i2HiG2TCpjO7XVk5KK1w6ce/5ixiITofbGXHmrGWFAjkt8puSEuBtjBGWkhhXOP
	IRhJuo5eoMkEMGKKtVeaGazQ/cLRgo4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21B5E60218
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E21F00A3A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788417748;
	bh=NoreS1c67SI6AUlE45CnZ5o1zP8316Y/FnI+L8qchEI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NhbKpu4euU3J54kuBewdoHitvzC4s0XKkJbtFRar7UcMxbaZ7Gv7lBMvrP9w36xSw
	 2+8iojnoVDwxMeAUCOee93Mp8p1ONeExTpgtO8oFLQd96LjWAWbZ9lpmZqHzaT0Upd
	 ct1nRoEbswWioW6g6JRN2Pvs/vnUvVWAFi9Dt6l/QpSwO9TUMwrXv72SZwdCPvY2Oo
	 yfFYdVNNR4rvKO0cTOvavhsjC8NOIA8wNKksOuQdp8/6GrYxzo/NBnpk8wJVf6ewmA
	 mImhjfdQ1Lh9psq3Yphl5NJsOdXPzLPM9QVumnmXilSJ/vtpspNlPJe8LjfFACA91O
	 t69ZgAaWQXTOQ==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92edb12cdf2so171773185a.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 23:42:28 -0700 (PDT)
X-Gm-Message-State: AFuF++mxPpDnEzUQG5iZD5twFC1sxS/9EnPsjHGZqdK8fDI9gJoH01v0
	x30fBGTIvnCVXIovjMNkFIXiNnUvDa7ecMG7vt98elNyt+UV1l5Dx2Q6rA72tcYi47KXIe/4dIr
	0oZSr/sYLwFfheRF5/GeePvB70QMcUVA=
X-Received: by 2002:a05:620a:a20e:b0:939:3b56:c416 with SMTP id
 af79cd13be357-93960ca35cfmr1181035685a.8.1788417748183; Wed, 02 Sep 2026
 23:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com> <20260902-mglru-flags-cleanup-v5-6-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-6-9db761d779ef@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 14:42:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yqwfMJCaonibg4Bc9AosthroQBwM272eg+Qx3oa89PMA@mail.gmail.com>
X-Gm-Features: AcwNN1VD2akl2VUX8YhUPLeb6jEb8u2mnb-VNQovUDSfTJ95mvMn_WCutxEh8is
Message-ID: <CAGsJ_4yqwfMJCaonibg4Bc9AosthroQBwM272eg+Qx3oa89PMA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] mm/mglru: fix potential generation folio number leak
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87BB4100009
X-Stat-Signature: whr43dbgnru5xmzs1bp1pg6dnds19x8b
X-Rspam-User: 
X-HE-Tag: 1788417749-702144
X-HE-Meta: U2FsdGVkX19EtsV5XgNPs5y0dSvgVTHR73zMyD6RcTMJ6JQCaFwYdO86eEeXv+B1OfHCc6sbujRYzgeLcbJTS9MdxAxZTkroyAHHfXKqxpdGtM3uP/nywZB9m1/b2o5rwlQcY2772mmM6vqR1VzMmZZmAQdQwFH7gKFLLTuKbw/xa1ygdmrPvfr4SS0kn/AQL/qZFZl7iT/hWU3kBAtEmmDGyMuXgLfzvbzAhNilWeTHmHHC5Lm40ODtRG0nk/gx3TGMQWnQ+qTmHmkcfnXI1UwqY0nb//XFwLJUm19v+2qimYFC+WiqyiVQXRCSH0ADyjq0WpFELirBiEZbvoUkCXt+UjTbQ8eKvPQb6wapQ+7WwOOXXL0T8rtvM1CGNcGJEuswcPcWd0YrtzVQ5R0nRoViwWaBlSvBKGzN1Vngmo4tW0ecB54lsHZyDJ/3+zjTO6wJfTA+OqAM+TRTB8HqnIgfkw2MtxOaXiR3e5MI4KJdeWPk+5dddxMy9mt3q1p/dVkWV2eaG++mlXTG8EAmvFViZtKCgba6Sa/gSpK/AXo3Eef9c+l/Cy41ku+1RdBHRAhXLjuorCUO7HUqU6teY4C5/dFB+LWdcc7ubD807IRN/5iz+qnOKf0aS1RcU3Md+CfnzYiecgX+uc15/uDOQxwSBax0ZnXip5tTfo9cJm+xH5bqbJDVCBMzHTQjRkJrTckQndYTunhlXcBaObE3NeyXbmPMx0bfo6gy0qbRnrFJTYCfErjRxrglTJDaxLFdjYjlxsY1yAYHfYcy9YVYWaL53j6YQTLv7lxduAr7D/PoAWJFK3VoUL9ZD1S3Xw9Hg0G4uyjYCT2fKhzhObVhawrUww6bEmCLpyrTNGgLESuMMupQBBHLkTGOchV49OVDy0+pCHXtZnUqHmm6nX7dhmbC/gsTcIk3eYA2fZG0Cl+Pbt7jd8XNjBir8j7U5FWaSC1IX5scbY5cMY4jNr7
 BhcdXC5a
 fThS2FnkCB+EQ6VDUmeq6UUign3/FgACSEmFMf4pvfWwXGNfLEj7KUa1TkFBRWQxXKDVKhgiiZX4rRO/coOhnINHyjKpQQCTngcIrXk5xkzgcdWOSAJtOqabco7e8/cdUPFRbqEtkVCRhowWqYqH3bKA+UYWex1gQ6Bg8Cs1d/B/rkN+v7FRfDUut7Bu2Fe/HDspCZof02b9WXGHWnn6tNZY5ecDgtqKeOy0Yc/oNdf7zABzaN5mTybTDsvM6krs9c2bnukjdciCdeKr/oqNZJov8K1PoZ4uxVRQI4ELCrPB575snkMAtuHUPwioEWoFBV3VHK0Vzbij05Bv9lR+AHf5rmOUkpfaopxvcNa0ZnkyhLk6Znat+yiLDBwXN9dLFEkc/nEeaqEV600x9q/6fmWxHig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 5:51=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Each generation of MGLRU accounts anon and file folio numbers
> separately, and the page table walker updates each generation's
> counters in batch once the walk is done. The walker promotes a
> folio's generation with a cmpxchg on folio->flags, and
> update_batch_size() then reads the live flags again to pick the
> anon/file column to charge. The walk holds neither the lruvec lock nor
> the folio lock, so the type can flip between the cmpxchg and that
> read: the lazyfree path clears PG_swapbacked, and reclaim sets it back
> on a dirty lazyfree folio. The batched delta pair is then recorded in
> the wrong type column. Nothing reconciles it afterwards, permanently
> skewing lrugen->nr_pages and the reclaim budgets derived from it.
>
> Fix it by capturing the type from the flags snapshot the cmpxchg
> linearized against: folio_update_gen() returns the type of the state
> it transitioned from, and update_batch_size() accounts with that.
>
> A folio's type only changes while it is off the LRU list, inside a
> del/add pair under the lruvec lock, with the gen bits cleared in
> between. The generation and PG_swapbacked sit in the same
> folio->flags word, so the cmpxchg snapshot captures them together.
> Let G be the generation that snapshot captured (old_gen) and G' the
> one it wrote (new_gen); the CAS can land in only three places:
>
>   - before the del: the folio is anon at G; the batch records anon
>     G -> G', and the del later removes the folio from the anon
>     counters;
>   - between del and add: gen =3D=3D -1, so folio_update_gen() returns -1
>     without touching the flags and no batch is recorded; the del/add
>     pair accounts for the move alone;
>   - after the add: the folio is file at the fresh generation the add
>     charged; the batch records file, that gen -> G', matching that
>     charge.
>
> Unlike the drift of lazy promotions, which sort_folio() repairs under
> the lruvec lock, the phantom deltas from before this fix land in a
> column the folio never occupies again, so nothing ever repairs them.
>
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

[...]

>  /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int new_gen, const vma_=
flags_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, int *type,
> +                           const vma_flags_t *vma_flags)
>  {
>         unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
>         int old_gen;
> @@ -3298,6 +3299,7 @@ static int folio_update_gen(struct folio *folio, in=
t new_gen, const vma_flags_t
>                 new_flags |=3D BIT(PG_workingset);
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> +       *type =3D folio_flags_is_file_lru(&old_flags);

Though it is a bit ugly that an `is_file` value can be assigned to
a `type`, it is not your fault. We've been doing this throughout
MGLRU. Technically, it should be:

if (folio_flags_is_file_lru(&old_flags))
   *type =3D LRU_GEN_FILE;
else
  *type =3D LRU_GEN_ANON;

But that would be too long, so I'm fine with the current code :-)

Best Regards
Barry

