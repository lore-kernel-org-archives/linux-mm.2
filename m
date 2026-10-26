Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1B860A381C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6hPdZyj
Received: by kanga.kvack.org (Postfix)
	id 485EE6B05B0; Mon, 26 Oct 2026 05:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4370F6B05B1; Mon, 26 Oct 2026 05:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CCF6B05D4; Mon, 26 Oct 2026 05:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1554A6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:47:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A08DE806D3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:47:43 +0000 (UTC)
X-FDA: 85364300406.09.0A94EB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3DA4C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:47:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6hPdZyj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793008061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPYRliWsU0Z66rDxbPPakZCnWJzqb2ufb8ueBJaSZh4=;
	b=dfjcbnJ1gSifTs5vhQsy9xjEpt5EUn8QULH+4BeAU0JIzx8QqCTRG963LgGSmLCBhiGgNk
	j+2knHZalLobJJ/f3jBcQnGRDExCRD56jsvBSxCq8x6SRlm6aQ88FsAsygQvk4r2nDREtJ
	IKUS5r02ueiq6xJ53U9YYfIFvxji3vA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6hPdZyj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793008061;
	b=DFGqfB82krOcyO60i5iGRQn/rBkNlZ/rZrx/mYZhZejHItqrSyGeanz7mmr9r3/RduE0oB
	HSThgA23Wt600SHwlhlG7RC0lfVVrpSBh9x9XjJW+z9LYf1yD8Mg1RMmFkdipVuKLd/E3K
	nJMlbuVoqve9hRMBzMKCLws36Ae6BiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B81DD4477C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A03A1F031E4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008060;
	bh=UPYRliWsU0Z66rDxbPPakZCnWJzqb2ufb8ueBJaSZh4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O6hPdZyjp/WUul6/WqzGfWPcKmuShX3G88MfwmxpOVv0QhAtu6/2LUs2QX/g18GK3
	 RKj8hOGyUvomBvD/gqqD6e74Wm8cEH5FJNPnFEsqa26veJjRM18lXvSUMG7pbkh0Hh
	 5ydMYWnKcPxFR5oRAqicS45TQY9YlZJPSm1bStz9GiJsme1FZtn8Y1qTDui+s7eivF
	 K0iK/J6FCtMCxkqV9OKS3Uwz7rttx0dNYHXTvOk2LxwWT1E7byux27941wxykn4GQj
	 LTAjEzzE7OoI/H+a3+c82oIIiimBMfM5Ek4QDkk4XFHwzgMZ4XSiOdv4k0dJ30AlWR
	 VXVVLXvNudvGA==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f259cdc86so259329185a.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:47:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwysXDUmFnYyUlKC4AO6HqLaPhyArpWEapu1qv31vTF9oH799xv/DAxQg/G3rJRrQjMgB9WSKzWrQ==@kvack.org
X-Gm-Message-State: AFq9FYI/qI4HkZjVkH9MbrC1eaXPocJZZre/8aTZJrKFBcE1NZUtfgLr
	+eE91jEyusseo8RXMOxNTL0jA7XiCR1P8Vkv310IRDnfRA8GKJp4XKKdni9Isz/hPU6gxABSzob
	8kx69fLb5jUPEblp6avBz5xuEb08xhek=
X-Received: by 2002:a05:620a:17a9:b0:93e:50ab:10df with SMTP id
 af79cd13be357-940ef7ac82cmr824571985a.5.1793008059753; Mon, 26 Oct 2026
 02:47:39 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev>
In-Reply-To: <20261026084035.535989-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 26 Oct 2026 17:47:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z46o6fs16T0ctLcTXiinL1+0CXpvueDN1rVc2-rLT6NQ@mail.gmail.com>
X-Gm-Features: AclHuK_NRJA0B-x0bJfZaCvEv37_IFIwFzwcGPGyMJ6wMoTgtUrxCpJpqOIo_rI
Message-ID: <CAGsJ_4z46o6fs16T0ctLcTXiinL1+0CXpvueDN1rVc2-rLT6NQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yu Zhao <yuzhao@google.com>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B3DA4C0004
X-Stat-Signature: q5ty7wd7x8n1ayqt8bcpfn5knfsffoyx
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793008061-292573
X-HE-Meta: U2FsdGVkX1+WdcSjQlkxpbAfyiAloN0aYfMH6iy/W5bzquM5mwZX02+3zFJiDt+YksjwpgjhiQkSzP0CdijIYt1jFvV4jhbhgXSMkYBpZ6Kx5tRqMf1pNLN2wd2hCWhs1cI1VhVr7YW2BeWpOCJG2u79vIZt+anOp8VWodyixssti/4e9lTEa7ytGfUVfZyl/YvTXNHtpIBJa2sFg/7w/2lMh6BUpTjnTaDKANMDoDzieC4IN6B8bxansSBtvhGbxzuaMc7BBcktQPWyFEss3ER+uoXxwITSFfsvQ3pDcxhTsnFE996cW8nOgMRIwzKj/EgtiDdAo02Ol9Kzcm7Yds0uIrVOyg4fJtgxRemEIM3tN4wvuu9nGVtwseZoAiZ8xrnjPdCxAzec71GKvPQxOvJ9he/DpvLY7Iw0zBzTjlrC4c4ogy9Fyapeb3lHMvAhwaquZRleqRvg11YKE4I63Hmlzc3WcWbGcyEmW82w2ITxBgpCEYch7MAV35U7GcVVcrHnHtQ3yU9DLYq7Iso53EKokvDnbKqobKX/HVY0D/YDgcFJu8VKhRJ/GVm4MSAE7hC4GpUrfpb/Q5nCt37BWzKxrf4Vb+aMw5f/gOPpI5U3hUC0fogD410OvzkRwt1dhEnbzbMgBfgpswIQ0eCtIEWXZhKoYhcV/1t+mmw5fSSgfhi78ArCXZlXWAyBWdGWlEubP4gxp+/dmmv5jud0W+eg+8wSjiasJArtvU8vq48UOk/dL7hHL3sGHgcnIrFm5u68+ImqWIQLhzyWVk/J2BcN2DjZleMaBVDVsrDplOc7hQEEW0hRh8hJJPVlm/5frsPgB9ULJ/DIJP74ByHibAFf3TTbOSB7CqPndl62RANfjn02vD5IsKWJBiqFoS6UuDLf3MbbUH8sGkMGaLoGijJ88kc8jD4ZKsqqTdgXlkex24OnvmWdjLRCGbaWEVWNbSi3IT11JdsCBIECSsE
 JVr43TYh
 bu543Qhwze2CSPPMoejkLeGKz9T6t7DzrzEhH8oeOkegbSeoVsVhDahPqUN6WLlTg8GNEx4kEv2biqowY9IN2ehIlQiL6mcN0evKUSduR0N4QztzPXfuZTSstry4OMwb+KIwNtLGRsFQh7C0d5pkI4M/4AgWkeJaJD+99VKbxWqifDQlZxzJ9KElC/xtk4vkHjsqiznUhiyjVCPx4iQZ6SCLsD38ALif935UHeUho8is5uVOjCUqBygql1Vvh4EZBq71r02OGFvqH/FCmcI6Lt+vVb2xhMt3sIEf3FGefZme6lqXBVOmgmoupavEHmBbZr0+blq3IBHRYdKRa6vj9Kv3Aw1O+MXtUJFZQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 4:40=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
> lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
> returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
> clearing the refs or PG_workingset.
>
> A MADV_FREE folio therefore keeps the state it had before madvise(2),
> even though madvise_free_pte_range() has already cleared the accessed and
> dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
> younger, and PG_workingset puts it in the last tier, so sort_folio()
> promotes and protects it instead of evicting it and charges it to
> lrugen->protected[], which read_ctrl_pos() uses to balance anon against
> file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
> so this repeats every time the folio reaches the oldest generation.  If
> the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
> lru_gen_eviction() packs the stale state into the shadow entry, so a
> later refault is promoted to the youngest generation.
>
> Call lru_gen_clear_refs() while the folio is still on the generation
> list, as deactivate_file_folio() and folio_deactivate() already do.  Its
> return value only says whether the folio is in the oldest generation,
> which lru_lazyfree() does not need because it re-adds the folio below.
> Keep folio_clear_referenced() unconditional: the classic LRU needs it,
> and it also covers the folios that lru_gen_clear_refs() skips.
>
> Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v2:
> Call lru_gen_clear_refs() before lruvec_del_folio() instead of
> open-coding the flag clears; drop the lru_gen_enabled() branch and
> the comment (Barry Song).
>
>  mm/folio.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/folio.c b/mm/folio.c
> index 35e242b48870..ea3adb6a89d7 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec, str=
uct folio *folio)
>             folio_test_swapcache(folio) || folio_test_unevictable(folio))
>                 return;
>
> +       lru_gen_clear_refs(folio);

The only thing I'm not sure about is whether we need
if (lru_gen_enabled()) here to keep the semantics consistent
with other places where we use it.

...
   2    676  mm/folio.c <<deactivate_file_folio>>
             if (lru_gen_enabled() && lru_gen_clear_refs(folio))
   3    695  mm/folio.c <<folio_deactivate>>
             if (lru_gen_enabled() ? lru_gen_clear_refs(folio) :
!folio_test_active(folio))

So maybe we still need

+ if (lru_gen_enabled())
        lru_gen_clear_refs(folio);

with that, feel free to add:

Reviewed-by: Barry Song <baohua@kernel.org>

