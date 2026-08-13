Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BA6C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5526B02BA; Thu, 13 Aug 2026 17:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FFC6B05D2; Thu, 13 Aug 2026 17:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8286B05D3; Thu, 13 Aug 2026 17:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFFF6B02BA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:40:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0B0AC0135
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:40:29 +0000 (UTC)
X-FDA: 85097565378.18.2BE14C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E4C261A0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:40:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A7bH+wu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786657228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fweVNNDp4X+C0oZdrdmosRiPjw0MChkGQ23odeO0QmY=;
	b=CVyGtSEB0DtfOx8coxDC4yOZvcWFDCUYwnIz9H+stk5wh9DqnHTbRmLeHFFWyqtE2TXDAn
	v6naFzEk59cnEGdybVht+mVQACuLXMPX9D8CurDErpLVD3jBi+5IfUToXgv8JYQTOI+RGh
	DT6sHX4sWM84B/y5EVOn0+SD/sK/ZII=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A7bH+wu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786657228;
	b=SrpikRckMR2IGSCsB/F02Qp86x3+AC28IotNz8FbxCJSpbUBp0X2aolcatwjcboUceefRT
	cgz1waHlKGDOAUTm/HCiU1dzT0vxvq8z7ppOIn/O1MYVJ/NNiLV0q8SmZAnMWOdJCr/ghv
	1TxEvGGl4m+hTz2sV91K+7KKqMdjXzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06C90439A7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69811F01558
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786657226;
	bh=fweVNNDp4X+C0oZdrdmosRiPjw0MChkGQ23odeO0QmY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A7bH+wu517r+/stDsIeXkofwJUiV60iWRu76LZLHM0h2x27TSbpaEWS1hDJ0+VaDa
	 3JP3VzsvT1vvKxshG3UNCyuDFUGiLhOYrQaUh/7OD8otp24IkllJ1hEytnIXmydqHT
	 NsqoigWt22qj1Am4rgz05BpvGOuUNNzEbUuM3Th4lF5+FJYSaEnZIMOA7snipPRvbH
	 T0odf0RQcD+VS/L2G2E3BHuTiFvgWX0Zb9KV2kn6ADfWFZ5MvIWtIuB0tjlyJOxOR7
	 TDZv/MlwgA4IyQ73i5cHQVoZl9UTBqUQpLFb7blWvYs7ovjzm547IWjIUIfBaZ5Ti9
	 utt56ihwb07VQ==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-9063b380982so3658156d6.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:40:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq/vZK224kN3lfGbvy0y118ltv1dcQVyjHPRyNulPjZY8grSg4M7h+iQo770FmxP8QGJVAt7RIKLg==@kvack.org
X-Gm-Message-State: AOJu0YyPlysNzeF+66JoH38iC55RsB0NADYxKeFQazbcsFYkFciOvmxZ
	3O8HjrfOKUvoHN4ntZ34kIXfGzGk8XwRBehzlmf0kbHjuFmNaqDZa2+or+0xwv3bkGs/1J0XkN4
	jbB/bNjN3C5JfTqBNjTDBaMCgAM0AA6o=
X-Received: by 2002:a05:6214:29c8:b0:907:88cb:2ac7 with SMTP id
 6a1803df08f44-90a91e313bamr8939706d6.24.1786657226174; Thu, 13 Aug 2026
 14:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com> <20260720-batch-tlb-flush-v5-2-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-2-db943a0d0d6b@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 05:40:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ykbJKVqEv6uGNKZaQhtV1UxxV-MWt7D1jx6SpdMN+cqA@mail.gmail.com>
X-Gm-Features: AUfX_mxuYjoATT6-XLf6NdmGhS9u7tr2ixSFmLUu64tLRgxRG_LgHV2x0MHHf68
Message-ID: <CAGsJ_4ykbJKVqEv6uGNKZaQhtV1UxxV-MWt7D1jx6SpdMN+cqA@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] mm/vmscan: extract folio_free() from shrink_folio_list()
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E4C261A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: s69rmkqhrpmm5h7tkfo543ydk3i49d8a
X-HE-Tag: 1786657227-807734
X-HE-Meta: U2FsdGVkX1+ZayfTW6Fq4gmuvQdtdipZ6bLaeaw5OgGGKuZQ1cHI0on0dsxiE/as3iNrtc887d9LFZQ/ZvgFoKrt8646S00bvYxbjYqeyT1nvCOqWHxfCYnOSVo++YYUuEKbQwszfaYP2IqWiNA5u8AY9F42prbup3fASzxtjaPbQmL7kdVBNPPGoWsmRRPZ8X5sgw0Hln/fcQaLs283JI/2Md9g2fhZLTefoLB6tfgageuQQTkmjoE3EkgKaRDS5t34vfm4P4JiyhdKWkXAglY4x5mw3jhSrp644LOqCssVhkzBOf+GX+i3TeSOFW39fngrXWiYnNZxyTorX7UCWt6k0MsrtoRh1iYM9FirVZFi0QVZ3pZoi1zx3RwuPCYWivaYpZmdyXMEYdC6E+97elVajeqadGbCcdf6qzEvRzvUjCFDY8ovp2y1TDaur2cz+UH3kFBDOxz9/9KwW6x1xZYjgxLvTIZQwCD+p3SXnUGWVqEiRvUXG8aNxho/W6zsPHk0FH6a9naQIsHsKuswsCwSwCVBu5GUQXwUp9kGVvsdu9E3XpjY8BM+FkMGHID713u57q36yK2WcRebUoUhcapa5MAzlrdKCc3shbQ0wB7VNMcuJKtI6PAasHz/D2hfod727FZUxJjcc8D9WU7EzB8RhGWVMYstOnQ5+SeFDyjnCYXyiAXyPFAIHkeU7bVuysZQXfK5JJ7c5OM6SLNN1KJ4JQvN+F/3GtQMmrJe/DJ/vDQXRgusz2FgrO4zonw3Pf1zjMEotsrMdDtWP2fu5QRZYNS6pr3TqFdfY651NYxlkF9zH01BJ11jA2n/7hzJGIRoKcZb6rxcW3oUuYW6gWuQHRGvVOYsAteMJ2flPkq12iSJdo7arWwa/0JfSYSwJhdIgwxj4Nm9KvZ0pHbnH8UGqxYiF6KU6MJTJZXUsngexzIZSBI1Jr/i8nhg6Bxs+tG8d+xOfIELITUnqfo
 mfaVFwvR
 5DkIPLoNl66jUTehnwAlGBsGTIsD2KCEgaznwE9oKjkDZzI+9svZZpWp3PMbWB9HoKZfkpW7Ods+muC7+VIZSMpmuqZ00ttQpH9zGO/fepMKBHliZ7dT6Quq26nsnnG4srx/U8uFxuooUHL9ViZhHdmM4EJAYC+v5IKxRsdUdLCcjzQhmI/C5lYH5QBYI/QZ2uWOSmG4IxvB99CjCMeqf9G+wtm38Bzp2cgp2C8aPKSAI1iJRzUT2dphg+AE5+1DATINTW8IGAD7S2o+LQPXkjoQ8a5wcXFUm6inyQ7ymbMj6J75aJtHSIi+HFhvtPFxS4kaE11o2emzhEdn5fFKqWGM81mUPGd3mKL5KfoILmDcmRnCFo4mMNVdGNFkMAbJ4ABxD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 1:08=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> shrink_folio_list() contains a self-contained folio-freeing section:
> buffer release, lazyfree, __remove_mapping, and folio_batch drain.
> Extract it into folio_free() to reduce the size of shrink_folio_list()
> and make the freeing step independently readable.
>
> No functional change.
>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 164 +++++++++++++++++++++++++++++++++---------------------=
------
>  1 file changed, 89 insertions(+), 75 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5ba880dce21e..a0807dd01c5a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1076,6 +1076,93 @@ static void folio_activate_locked(struct folio *fo=
lio,
>         }
>  }
>
> +static bool folio_try_reclaim_free(struct folio *folio,
> +               struct folio_batch *free_folios,
> +               struct scan_control *sc, struct reclaim_stat *stat,
> +               unsigned int *nr_reclaimed)
> +{
> +       const unsigned int nr_pages =3D folio_nr_pages(folio);
> +       struct address_space *mapping =3D folio_mapping(folio);
> +
> +       /*
> +        * If the folio has buffers, try to free the buffer mappings
> +        * associated with this folio. If we succeed we try to free
> +        * the folio as well.
> +        *
> +        * We do this even if the folio is dirty.
> +        * filemap_release_folio() does not perform I/O, but it is
> +        * possible for a folio to have the dirty flag set, but it
> +        * is actually clean (all its buffers are clean).  This
> +        * happens if the buffers were written out directly, with
> +        * submit_bh(). ext3 will do this, as well as the blockdev
> +        * mapping.  filemap_release_folio() will discover that
> +        * cleanness and will drop the buffers and mark the folio
> +        * clean - it can be freed.
> +        *
> +        * Rarely, folios can have buffers and no ->mapping.  These
> +        * are the folios which were not successfully invalidated in
> +        * truncate_cleanup_folio().  We try to drop those buffers
> +        * here and if that worked, and the folio is no longer
> +        * mapped into process address space (refcount =3D=3D 1) it can
> +        * be freed.  Otherwise, leave the folio on the LRU so it is
> +        * swappable.
> +        */
> +       if (folio_needs_release(folio)) {
> +               if (!filemap_release_folio(folio, sc->gfp_mask)) {
> +                       folio_activate_locked(folio, stat);

Could we avoid hiding the activate semantics inside
folio_try_reclaim_free()? It makes the logic harder to read and
can be confusing.

Could we pull this out so that the three possible outcomes are
explicit?

1. activate
2. keep
3. free

[...]

> -               } else if (!mapping || !__remove_mapping(mapping, folio, =
true,
> -                                                        sc->target_mem_c=
group))
> +               if (!folio_try_reclaim_free(folio, &free_folios, sc, stat=
,
> +                                          &nr_reclaimed))
>                         goto keep_locked;

I mean, this is confusing because an activated folio ends up in the
"keep" path. Can we make the activation semantics explicit at the
outer level?

Best Regards
Barry

