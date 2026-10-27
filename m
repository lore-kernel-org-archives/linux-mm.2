Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D0B606C904
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Di/vOOUI
Received: by kanga.kvack.org (Postfix)
	id 32F276B06C5; Tue, 27 Oct 2026 07:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3069F6B06C7; Tue, 27 Oct 2026 07:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D5C6B06C8; Tue, 27 Oct 2026 07:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0B5D6B06C5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:40:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 920A31A0966
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:40:04 +0000 (UTC)
X-FDA: 85368212328.19.01359EF
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 95F8A140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:40:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Di/vOOUI";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xwtJD2tDU+fIoTVWwQ7vdURPVaDHGIK/RJJWfEVHd4=;
	b=loOXT9ITQBTOdZWnvzCOpONisNkkgBVBDP36L19mpAAFimH3dDPrBTaLCGpG1l/P+6Jd+/
	UNDVP9SM45vt1ubdT9P/1EvkvAVcjEhV4VqZHwU+ukS529BZ48wjwXWPhuFPncMVzk2wgd
	TFZBXQIwLiP05c5upW74SxVbN+pmsyg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Di/vOOUI";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793101202;
	b=UxcOLDGIjBzXbBd0vAGiwaYruAUbqKdEg/gh+WuIfFVXVEPEwDcazQiazpa9SHEx1+qOTs
	GqEifPXJTDOlnn3PSZGPOFDW6ZTPgKkgliZevC6x48NlHpd37ZVXjMwG0urAJJawBjYg0U
	K5++f5n/5FRf7VEtAhSRS3ylqLHT/ds=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a01cac8733so3009315b3a.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793101201; cv=none;
        d=google.com; s=arc-20260327;
        b=kVXMxhcTQWLHqKKwVJQhawOxY82jXP6tXSEZC65HhNbSzozFICp++JyC/kWiGXBdg9
         xmcM9V+8Eguh/wyYGdp6lr6mUL4ilTMuzr1bKbVbqUROx+IcjoWoNZZEFdZ5TiVC6FjW
         FruB2udcvjXgJXmKGu9nStkiUwiXL/uEAXjSV8mw8qKaeuQHaI2XxYYJ2lA3n5fTNlBC
         QGZ3frTQ2WjZmb7OWkYEMzs0/uUo6Zvf4kvXfD50lMw5/BE9kBV4L+kbPr8r2I1yDmEs
         uJ5dr8UG+/tOxuICWnkBFMwYrCi36ZYZGcy8KNF+HA3Xas8r5cxhJdV0VyP/EwAcfP+o
         b2Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8xwtJD2tDU+fIoTVWwQ7vdURPVaDHGIK/RJJWfEVHd4=;
        fh=LEOIgHo8lhdXKHi0kgIYELfY5e/oGsY8aExH+1BziQc=;
        b=BG1KhVqiTCj4/ciMCF9IP1qe5X7LekfGW7cqa2p+IMkjC1E64AzB9JGiC7oZ+v3sAb
         nS2c+y+cIfxx4jj8deIX5GRaUThrC27yTHPBUlKsKknzleDHTNPh6ZQGlehkly6l4MqF
         bCHVRq9S+lw9IKo70RRrPyAueOOu9wjwC3Siu7cwyGGe02P0Xa8PAnO/w9U1MQ9VvXcc
         m6plzwLL1K0uOU0vzHhMJBaH5SusQ2yfahA0XadGVLwmOg1BY8ibIS+iQalwVNRXgiV1
         tAXXNatXRxXXlAyz9vhJP1SwIZZVl/8ppVXgtYpyUMHE1+t+ZDEuT4Hx+xDaEkVfCXuM
         CRcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793101201; x=1793706001; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8xwtJD2tDU+fIoTVWwQ7vdURPVaDHGIK/RJJWfEVHd4=;
        b=Di/vOOUIzq1bHQwDAttBBRv49y+sRoVmb7qs1aCHYezlLhqXT1zP3rLmR/ZywNPJpP
         GaktYxmQrwLn/6gOAhCLfDfIfMwd0FU4fFwON0CrscOn30tBwj9pFvAbecNR0/09vOdl
         Sk7aOSmKOioZX3FMRa3TdvvZsOaFkgJvVd8bJ29vbJ4XNAzeEc8u+0Aa4PS5bsg6zRZp
         UM+fc327Bgk/2p5xPSPaOZYS/Jg1cqkseJSrSQVb/GMyJsFR9EE5UPea1B9NIruhPyqe
         CpV1RBJFhVUi2V+RGm75GtiftL/qZwhNMjKXW2ay7KIm1eCevskxYhgMNLerCzb+HquL
         Nc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101201; x=1793706001;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8xwtJD2tDU+fIoTVWwQ7vdURPVaDHGIK/RJJWfEVHd4=;
        b=m3log5it9NYmypIpdCMu+qyZGHYPqdqgP+nlyT5KrIstXJTg9OtsUacNaG8r+EhbYX
         LGvmKaHWtNxjqUhR8nfmHhl0ioMZP0IL6uf06nfPU8BzczUGHRNpTfLJ7jgp2jHhX3g/
         hTTd9vsUmyhYKMj1U8OXkVH+ehCrtkmeh6jvurYXImY2mF+6leCnMC0T4TksvbjDIDL8
         s3fn3Dry74vZkBXFtHgi8e4njr+Hf1Rzy5Y/XEGra+CLaki6TgKRfbA2jRdCryU6jRwP
         RE5rNTkysc0uRCxv6krWI5VPsDdObdCWryAahTDE1JM3PvDz3XzIw6bM6hCw4WuOEvJi
         MSYw==
X-Forwarded-Encrypted: i=1; AKwUvByi5xivBo28XKYsWspaz9hOZ/lfomrEfdP36OputxopUNix/CWZ8i24urE/U0r1HGnu5/rvqIOoyw==@kvack.org
X-Gm-Message-State: AFq9FYIcZ+6fM5ZWnnJRuh765nxZufy76u7K1/RsonDCOVOU6edcAVJj
	yPkCsEXCdWSWVY6b+aEZxWDLZ0RS6NDFCRePS0ZT6gYOkS9rjK3KnRvJsRCg64p3pygrU6PZJPM
	37f7kc16IGtZ3R5z5V8RoScgneZMydTE=
X-Gm-Gg: AYBFou38f0oK/CW6jPm+Bbxt+2ZcBNSKIYD3+WK5kIWCDjd+aPS4BStuHntMIwbl3s6
	LHOKuR4eCOwq+f2+eCoudxAH3XrHosNjpt8Q17A0dZBjqGHJXCq2/LS2VzhJl53rfMgKprrGO0h
	eKDMu/cCP1guTxv1JFT4Su921O5s+HW0wQ/qI3+LNoKrfDnBuXA5BKEGBJtBOApqHGyl867ABxv
	YTgrC9rjIJpAS9e1UdxX7A9pa7JNgV0Ku9zPJhG5D4r45AGblAsmPiMBR7hp5Cg7HSQJhPYdZAf
	wrL0BpJDuvOAbh/PiNBwQIkN645PMNtS1HihrkmvFRTOpBl/sGWUJfKUlkKYY1slGLaR9MuqTl8
	6QXvOaOg1uWQRrwrWU8PhBdyvofVxzFtgPKzQDsy+QjI0K/glmwqmKS+TJdW9WL3AS+Rc1g==
X-Received: by 2002:a05:6a00:98d:b0:89f:5ac6:32f6 with SMTP id
 d2e1a72fcca58-8a366f67343mr6490150b3a.24.1793101201328; Tue, 27 Oct 2026
 04:40:01 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev>
In-Reply-To: <20261026084035.535989-1-hui.zhu@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 27 Oct 2026 19:39:23 +0800
X-Gm-Features: AclHuK_TYPiGSVgmW4A3CkA1FUOBB7hbFiGmI0M9h0LRJd1ARuctkV948Qsk3Ls
Message-ID: <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yu Zhao <yuzhao@google.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 95F8A140002
X-Stat-Signature: y9daqtxrc8o9aykhokeq3y75og36uemn
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793101202-96510
X-HE-Meta: U2FsdGVkX1/x0aYjSYisRPazap8RB3uErO6TyXwzuYGd8qB3xjaHMSR9gDygqcnZmMlr/iAjXNa6rwc3/GX7E4BQ3z1Vr9zVguYA5XYT6c5k14dJAuX7qFyfMGMlJZoGMyo1F4wg62PZbGuDSNBin0KYz0i13ZtwI5XgHZIfmiyZ9/TegkqAmQEDHHrFfn8ffZVpbf4l1dCfpP+8vgUThOAj2HtJvIawM3jq04GCS7tLluAm1MccFeEkUyqU/5qvKy9+h23vh+QEA1Y1zNp6XGKrXdSesIThhMZ3nuVEPq3Hz4KyWjWmL8JgLmnfb3PmDx9D4eEejVdWgiesqJEWYWoJgqdRBgQd+p1DQkCOkk10BnhaJf/O4dtjxrGWbrJjRUU0BcUGoOLtvuZNw+idWwgDz2GUNaR+TG22St22gIP0ekv5wIb9bfLqyGX6Naq1woaSiXZYT+X7CIF2tl2loU1cL0W/mz0mWQDPijjpqlsNG0AY6doNQsgvrqyY156KzDjzBL2X4rWCc2x8CimPwJ4nwHJNvrg2jw5IY8zN9cAjRqh+fZWgIMy4IrbO3FXwOCxr8mvZMgP4KDVxmKheayMwdbL4rV7lwGsb1B41qEuhp2eMK9cdHlkqbbMRZUKuiBG+BM+qB/VmE6krCuLLc8ovGrz2hvHvQQZ6KyGrX5vlHM7j1hSLUlH2WL5J6JrDbzpv7viF5RRNjagJ/ILPFpPYWXsIzogBI7QbpQzGg2nk2t3yM6gauDCusDmNtKU5gBjh0tY/m9alXXus5sauGd7CNK9Far0fv5YQzYuJ6dG/ESOVII2WN2YMM0iVTzO7E6nfchS9x46RQUowiF3Xgr6+QtB6qUpqetSOFtQt1ri1GNVxee6dxmVnDvQEOsD2nJAjeM1NIylRjwO0AM+JJ0EEEe4ag4nSOjRskHK42hkV3bItuDPmo851s+MfMHx09jH7LPyJQ51T3SJ8lYl
 8LNgKFYt
 B37QgHy/dzhN123ExCx6Ez9UIhXXwUIWH50zwmugDQOArqNr8pbB7MqvVKMRZY1LrECUyKMOFj+9W6AkE2Ap+/WxNeg+5lnE9DlA1uz6Zpukni5CcZbYnZqzEA9hvTSKnNpOu5coXakmI59Tevw3SFi6fwTbVyjg7sKL2PiU7Bmxzy61rMxTzDE5oeuA50iIfD9Xv0RxasQp1uOEvbioX6bt5GRtQtkghVUwnMo/pbjDXeXGBGx6TnOe6/Db3y4fhLYZf/APxeCPz47B4oKwbckstBu14kEXhO6X1v+WgmM00wkc1CGE0Ee9sso/cBLqTa35i1C7F3Xd88yiI7NmvLwNyprIldf6tF/4uUkyocJb6EzBKs9+ogFr2Yph5h01brNt3pN87NVMcEWat9qsfpxXacTJKLouFsKcZIKGRr7+PrFZC6vyPtyGkAsYnUIHPWF5IyMIHTpILfTN5Z6BPJAEidY72D/OSXlgjiMRDsxllmdht41pGcIqFGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 4:41=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
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
>         lruvec_del_folio(lruvec, folio);
>         folio_clear_active(folio);
> -       if (lru_gen_enabled())
> -               lru_gen_clear_refs(folio);
> -       else
> -               folio_clear_referenced(folio);
> +       folio_clear_referenced(folio);

Why can't we just call folio_set_lru_refs(.., 0), and should we clear
PG_workingset? Keeping it helps PSI on refualt / redirty tracking (not
sure if meaningful but CLRU does this), clearing it makes eviction
better, but the eviction issue is MGLRU-only, CLRU keeps it.

And folio_set_lru_refs(.., 0) should be a little bit faster and unify
CLRU / MGLRU. And we can detect lazy freed folios in sort_folios to
avoid PID form touching them?

Something like:
diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..416cd4beb182 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -599,10 +599,7 @@ static void lru_lazyfree(struct lruvec *lruvec,
struct folio *folio)

        lruvec_del_folio(lruvec, folio);
        folio_clear_active(folio);
-       if (lru_gen_enabled())
-               lru_gen_clear_refs(folio);
-       else
-               folio_clear_referenced(folio);
+       folio_set_lru_refs(folio, 0);
        /*
         * Lazyfree folios are clean anonymous folios.  They have
         * the swapbacked flag cleared, to distinguish them from normal
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..e64b7f544d15 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4835,6 +4835,10 @@ static bool sort_folio(struct lruvec *lruvec,
struct folio *folio, struct scan_c
        if (!folio_evictable(folio))
                return false;

+       /* No need to protect lazyfreed folios */
+       if (folio_test_lazyfree(folio) && !folio_test_dirty(folio))
+               return false;
+
        /* promoted */
        if (gen !=3D lru_gen_from_seq(lrugen->min_seq[type])) {
                list_move(&folio->lru, &lrugen->folios[gen][type][zone]);

---

BTW I also tried to cover this in MGLRU-FG series (not including the
sort_folio part):
https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-13-2106750c0bfa@tence=
nt.com/

I tested keeping min(refs, LRU_REFS_WORKINGSET) / just set to 0 as in
v4, nothing different from the workload (testing using Android apps as
workload), so I think it's fine either way but the above patch I
posted might help to impove it by a little?

And if CLRU didn't actually expect PG_workingset to be kept but that's
just a leftover or trivial, maybe we can always do both
folio_clear_workingset and folio_set_lru_refs(0) here?

