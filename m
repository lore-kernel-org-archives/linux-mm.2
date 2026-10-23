Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC15606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 10:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXKV10Fy
Received: by kanga.kvack.org (Postfix)
	id ED3B66B0994; Fri, 23 Oct 2026 06:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83D16B0B2A; Fri, 23 Oct 2026 06:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D729A6B0B2B; Fri, 23 Oct 2026 06:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF1946B0994
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:06:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A22958034D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:06:34 +0000 (UTC)
X-FDA: 85353461508.23.59CA8BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C771D1C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:06:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXKV10Fy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792749992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTWmeH9i/zciPFKRMIAo/+xF0ZeK70HJ+nGUDNQqdWo=;
	b=iExR7CyjflE+bG5uRGsfbNHicDx9EmsNrw+vI6QYU13Tv/4G577AEvjELtG4xEggeJy3aC
	H8+0DXioMMDucFiA6uSnBL8bNMh93DsF4sfQrKCfa6SlDazQTRZKIA0jBkCm9/jcsnEcIk
	uR+Elt8QnWkraL854DJ7BAd4gvZreXM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXKV10Fy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792749992;
	b=vFYTqdrPb61H68yP7SkzQ+Cw89FWgVU7yXMJOjsrQqUandbCOt4CVXw9rPt5j4fxbzIFBI
	Fs900n+bJseUHJDR9yasjY0ta1YR3B4GJcFR+wae3Dq53nec8H/GpIemn5JU/pAtxm35ah
	/GL5EgYXUx3HlG3vw6Jh3bkACHc8ECs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BC326053A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81DA1F031E5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792749991;
	bh=nTWmeH9i/zciPFKRMIAo/+xF0ZeK70HJ+nGUDNQqdWo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kXKV10FyDxIC8tBXivP5X7olR25twvFuz3ZrYMs+uyq6s8KX95pkNqWl7A0DDs7kQ
	 dRMYCnqlED09DR+/ajG/r6r43Rt3PGKo8HgX8i+C4Y6fm4zzy1nLxsQlFSh9ffizTH
	 Oeza9LBLOJ07JK+Zrw9nIupH6k/RkQIt1cj1/hxdNZK1UHmK+yGFYObEASoFi92Se3
	 +u7+FmPtUWHfsQMV/r86gZS2CyspoRV8030KUqyn68EumHESpWrg9wZ4Jhb9a/dcH8
	 pSpfCI5AA2EqUVDOGuZ0a5tStDAZElP5V+5EuGCMzbppnnvFg22KLrxwK4XGW3H3S4
	 pgCBzpTH07Svw==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f3c895a0eso56004985a.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:06:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz1JcKsKRBpWBaX9wDa7KeYpQFtsLMsJqQO64XmSRcS/WgokVhAAJbn44KgsoPtSgYK8ZqBfvU3NQ==@kvack.org
X-Gm-Message-State: AFq9FYLGg0D0AcUS2zg4YkdhUa2RUNnxqsHh8xFrTlnejOMlTRNg1bc1
	A1cC26nkqV76vh4WJ/ffVDMe5/EDPayU1EukWLH8v9BI2eFnzGsxWoAoo3xL3eXEFti/3lHivcr
	UX55qxP6T7CUXv/t5/l3fm+jusyoleQE=
X-Received: by 2002:a05:620a:1a10:b0:93f:309a:ba5 with SMTP id
 af79cd13be357-93f6f8151demr326659285a.47.1792749991048; Fri, 23 Oct 2026
 03:06:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023080430.465305-1-hui.zhu@linux.dev>
In-Reply-To: <20261023080430.465305-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 23 Oct 2026 18:06:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wJ7bBNF2DW_c7MboNFEa3GaOs=N_Sd_KkokCGaaCH3=Q@mail.gmail.com>
X-Gm-Features: AclHuK-Xdt5eGkfevbiMmRq5JHr_XV5TF8iVL1ErkFcg48nEdYLaCtJpU1OZ5wI
Message-ID: <CAGsJ_4wJ7bBNF2DW_c7MboNFEa3GaOs=N_Sd_KkokCGaaCH3=Q@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yu Zhao <yuzhao@google.com>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C771D1C0003
X-Stat-Signature: 8fm3oz9auj583y94egg8xnifxneq6f4q
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792749992-814338
X-HE-Meta: U2FsdGVkX19qAR/4kO0DSrt/Q0IAI3QE/vnduniS1uvgA+j6wzzx2lx3F7HRkaF1cdwbpQSmvMWwU99BXwxjBGBvZK0HgCyIczHFC/WusOCAyiqVHm2bYj8v8z9E/ETbGcfEqWMkvJcLVOsJtghTZmGhwyLB2/nDSrfu+1Dqnrb20cNfE/uN1rm96XJeRjxEo2Kd7p/t7NRPr55qkNLreRVJY1FE1e6iEx3H11bquviow0RCs26JPM46IlpPi3GI3kSPJC1mpn9EdCeZgYweGjibWZ3nrSkZdDpxXIuH7UUg0QSjsOqrAot5UMCxyPxAwtMGQZTn2EO3DDJck4YhWtPn7NL0ip2lUYYPvTi810k33BiQcY6w8spnFBe4P1aF7hHrjIEwfJDkiDuycvnToi2/1s0A5ocQcerviC0lddK2LkVf+9yEaqHnjssM1v55B1hz9n+Ue9YbzcX+RVoZ7/AlU4osRzF/b+Oe+xLcHwS/peL0mBRuNX2aE0lYi2ZQG7qwSoqEgQ4DVnpqg5+SjrfKelYXAB12RgO3C2o7OPxyozvcLxnGVgd9haMyMGqpm95sE6Dk/GHbR++NXzd9yP+m3o47CGM1swrwWpl4SvMIy3fsYW+6cFbu14aoYcVXQr7z91Z3v9WXniaJoj2qrdKjLhNdSkVex7s+F7CwhuBDXRqaoIJReYYkY2E3+mqlDtI91+gtn+9Q+iJCMVUwZyJ2TsPs1jJffjlmOuZO0ALB37Yb0t4yQRdlr9VgACXi9wYIJvpM0UustpbJCMcUUCCHigZz1rMeskEaJPhn+jaKBxwbkErUJIy13TrgGXqXZO8F6CBcNXUq/KrqO4PevBPAuNP84zVFAjzEEAM+vUQpm0rRFk2oKAPS80/5ymlK4bAJjtkOorox7CVsHubocrHVXOGvoZpJbE1yj62qPBdk7ULWgivxdDdAk/XhwCAOQGgcX54fQuTDulzs7Z1
 2Tfx9e2L
 kWDXx4hip3U9zPGJsImEbZGWCiDXD8Y0CO4Gd++MeHywHJoFb2UWcj2cD4gwX5sU4SILR22pjoPNxJqa6YPViJBNVsNC1+IaNMup1cnc1A4obzwembl6qv6hOMcGuQ3NMJMALanrYcAErlpHmToeBv8D4i95DT+lpInB6Sn/e785mh6ff4RaLK7uZTcnuhhCPsV8th56WDlFccDumghT+SWHiiWde6BQjTDgPh7oAQMQ5UX9Qcv/TqUdUuLvde78yDGx5reoPg/kZ9CQZziGK0MTgytQ9ts2fUQaHF4Mx87O7P/dhQh3MoE6w73f1NiDky0ac9f3NQ4uIbqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 4:04=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
> lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
> returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
> clearing anything.
>
> A MADV_FREE folio therefore keeps the refs and PG_workingset it had
> before madvise(2).  lru_gen_folio_seq() places it one generation younger,
> and PG_workingset puts it in the last tier, so sort_folio() promotes and
> protects it instead of evicting it and charges it to lrugen->protected[],
> which read_ctrl_pos() uses to balance anon against file reclaim.
> __folio_inc_gen() clears the refs but not PG_workingset, so this repeats
> every time the folio reaches the oldest generation.  If the folio is
> redirtied first, ttu_anon_lazyfree_folio() keeps it and
> lru_gen_eviction() packs the stale state into the shadow entry, so a
> later refault is promoted to the youngest generation.
>
> Clear both flags here instead.  lru_gen_clear_refs() only reports whether
> the folio is already in the oldest generation, which lru_lazyfree() does
> not need, and moving the call up would still miss the folios that are on
> the classic LRU while lru_gen_enabled() is true.  Use
> folio_clear_referenced() rather than folio_set_lru_refs(), which is not
> defined without CONFIG_LRU_GEN; PG_referenced gates LRU_REFS_MASK, so
> clearing it zeroes the refs count as well.  PG_workingset is cleared only
> while MGLRU is running, which leaves the classic LRU unchanged.
>
> Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/folio.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/mm/folio.c b/mm/folio.c
> index 47a437e0f7fd..03be101334eb 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -599,10 +599,16 @@ static void lru_lazyfree(struct lruvec *lruvec, str=
uct folio *folio)
>
>         lruvec_del_folio(lruvec, folio);
>         folio_clear_active(folio);
> -       if (lru_gen_enabled())
> -               lru_gen_clear_refs(folio);
> -       else
> -               folio_clear_referenced(folio);
> +       folio_clear_referenced(folio);
> +       if (lru_gen_enabled()) {
> +               /*
> +                * lru_gen_clear_refs() skips an off-list folio, which
> +                * lruvec_del_folio() has just made this one.  Left set,
> +                * PG_workingset keeps it in the last tier that sort_foli=
o()
> +                * protects from eviction.
> +                */
> +               folio_clear_workingset(folio);
> +       }

So we can't do the below? But why?

diff --git a/mm/folio.c b/mm/folio.c
index 45c814f3857b..6b779a1ad2f6 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -611,12 +611,10 @@ static void lru_lazyfree(struct lruvec *lruvec,
struct folio *folio)
            folio_test_swapcache(folio) || folio_test_unevictable(folio))
                return;

+       lru_gen_clear_refs(folio);
        lruvec_del_folio(lruvec, folio);
        folio_clear_active(folio);
-       if (lru_gen_enabled())
-               lru_gen_clear_refs(folio);
-       else
-               folio_clear_referenced(folio);
+       folio_clear_referenced(folio);

Best Regards
Barry

