Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC53CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3F86B008C; Tue,  9 Jun 2026 10:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D456B0092; Tue,  9 Jun 2026 10:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C7C6B0093; Tue,  9 Jun 2026 10:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916236B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:07:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 551961C2CCA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:07:44 +0000 (UTC)
X-FDA: 84860552448.09.4A68338
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 495111A0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:07:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Hmjro+z/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wt6o/EznFR/k4GQholhfxjjaCQtWzd26qREhKs6Ou4U=;
	b=ArNAgRbVNhVxt5v5E6GbuOf40xFFzOTOtkCqJP9r0dbOz9hcgqdHeu263zk6weJszYDwR/
	VBpkUT2AsVMJ85TIIPrJ6Oo8tNniSmsTAxF/KdbhpqBB1b8RkDDfIEle1uG9Ugwg2Bjy8E
	omPIpE3Rxd27mRcBAXAV08bkCjytS1M=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Hmjro+z/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781014062;
	b=exUWLKkeF8VYBCZKEBzZBmoRjxut/sAD3LmXMRsJO49gFIY0fJclfCDHMpl6qdRMuL241t
	1qLr+ytIkrWbbXqSc19pAfLipGQJkeE4Td+nOu87x9vdo0sooFkfKI/I4nu4hX5nISSdH6
	7DjINDuE00vlrdvTaEoRphSchn5GpGo=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec449cf976so775938466b.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 07:07:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781014060; cv=none;
        d=google.com; s=arc-20240605;
        b=HjZPZd4Pooz8JLgqNB7WQJCQIOq3yE4QjCsOe7eLBP85fj6wpFARTwQj89ZCwXEvrO
         ykHr6wVjOWDwRGcGn2ma4v36dpb/kx10BiGWhY2N+OkqJXXK1St+LrRYVY40ZuLvHxoI
         9gLj7Pl6vENDRzexQ3Vs4zIuJzerz4I5dlE9YZWamP32aEm13icap80xzELARUutPH85
         SG30zkVAwwNVWs0xASQ1lg+ptNm2VHaqch4A/bP8VZG7pt+8LenKqpjKDIqR3SLevMa3
         7zWhhZ0G+fh9T0v1z8DHNnyu6MbspD6Ki75yQ0mEG7nzFNwl2jqXFdr9eMqsFSI/572/
         i/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wt6o/EznFR/k4GQholhfxjjaCQtWzd26qREhKs6Ou4U=;
        fh=59KW9WfCYA8HqT2MvuMj3e90WdF1WzCsImMuu1VYGDM=;
        b=l1/fxvhRYt7TOBoqmUFlP1xFrs5SOtOxFmw5MkDlAubIZgvDavQFaYKDqIE7E3ciWe
         1b3PPRrms2CQbIygZ2bJ8bt2qFjRB+EsuCHQzBlF6myWvjG+DHLK4UwTuAvST0yrtWTM
         mvg9KJ4/YD/sold/HELvpdvGOAww8+DBiughw4pRWdArVyXhBeVCTih7JJWpIAnD5Itl
         fBTpeunZpbGG+7Fz4ec5MOo0UFWwaXvRTeLlHiGg2oqHQJ/VgFRuyD41MInkG3Ak76ym
         b4CVwBI9vx/AdFKHZwjC50+Ij7lcFr+3UUfvfVLFtAqNgdDH6evoR4KP5dKvBSNVvbgp
         LjDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781014060; x=1781618860; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wt6o/EznFR/k4GQholhfxjjaCQtWzd26qREhKs6Ou4U=;
        b=Hmjro+z/rps5kOcAw8V4whciJlGoX1tZEoRcC4F0MYOaNq66ute5rcELYWyjvc0k8a
         1Jk5nsH35pFFAxAg8eNYvQ1UPtH9lQLymoMkOVZSOYqUAnR7Sst1+lYJDwy0AHPy9W+1
         Qs071syDxY6nRsDUUw9Mz29vRj2XmYJcavvw3cXuHQORKVawMRuvMFa/MKqtgi5HX8kF
         /aWK079bbCvLMnO7CJn7mHmBv+tM4yG+Ovr3LBXKn+kUY1q+FwK8HaW6m+9immVEv1Sp
         CrQ8VocuU/7bsD4ZzuapVy5Tj+UI8OSkLMWWI48vcV9QjheKHlpfOzkDIL1DqNhJHoZD
         prkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781014060; x=1781618860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wt6o/EznFR/k4GQholhfxjjaCQtWzd26qREhKs6Ou4U=;
        b=LI713cdOVatIn/X6qhiVJBrzlAvHMxj/7bwIniMkXZfRnKgrQv2zkHaHl5KdRjb0Kj
         RzDrh0AJ1cFn5cng2R1/06ie+2PiIzw2a9wdxJnW7tG0BdGzh6tKCLMXTRr8mkDkAfVJ
         ElVrlnWfXS6QVu1gqVbV6m+IFV0e9PPApF6uaqgztQywhKPQ9hG8YMy8AxMhOym0tgTe
         uQbX3Xim/PwpdKVfZwIXqX5zer+eMy3NUCq9tcQAMagzWJ3G0Icrju5PHRydWFXQ1P/+
         WrVE4eTs5eMKU7zmOoqKZxn8fLSSjiZUM7/xsJZER7gs0uiN/Skcist+5bJIUbX1q+So
         fw1A==
X-Forwarded-Encrypted: i=1; AFNElJ8eNQ9WtB42HaZjB0tuKZVo+FOG2f6G1wvyx/BucJUwGBnY4estI6uKaw4Ig6GVGL0d2+AjbYgOiw==@kvack.org
X-Gm-Message-State: AOJu0YwNA12QTTvi1NKk/TLZwfBx8IbHuiw4+jpeyutC1fSJxs2n3qUj
	dn08y+zZC+rlRoZBQG7NAEHdJdxXSGbK/CjZQXAhH+R1C857g7aSW9cq10si+6MGAj/vwcWOJSj
	uqCjAa1ynh0VrouziB8N+kLXoMWgE9Mw=
X-Gm-Gg: Acq92OH1k9VSl7P6MExlHvhIU4FvkGfg9b02kXe61q3/6w9BdE7si1dfuLVQFq1sq9Q
	hSalANeVh+spnPsVVHQQqRt1oOlPQ5x06NcXvIHE85mcFSl1H0Okdbv7kDgercnYJ7tw/5yqp5g
	n8VhHsq3HD10slzSt0p82BW/WOxwo2K2pdVD7BfQHLW60Bpz7qa0pTJZc1rl3FJIdp76A0C0zR1
	lDvcOT7RQkWp2FW45/MJ/a8kdIFyhxSMOB/6KseZcf2yUjBBdpO+Wxj7g7vJ4iHk+MqrWWSqdqh
	qo8X4jgMZBaXCBXM6Hn39W5UYFQfSOQ9/s21tN8AuN6gYwVi
X-Received: by 2002:a17:907:1c0d:b0:be2:11d7:8b05 with SMTP id
 a640c23a62f3a-bf37234b77fmr955413666b.24.1781014059950; Tue, 09 Jun 2026
 07:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260608143242.2869392-1-usama.arif@linux.dev>
In-Reply-To: <20260608143242.2869392-1-usama.arif@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 9 Jun 2026 22:07:03 +0800
X-Gm-Features: AVVi8Cci0dNQnERKudte59zrkbuYB_aCiWIkJHOx3eoOMxs3tM2KtU7-W6HquQ8
Message-ID: <CAMgjq7D_VVJy_a4dT+eSzUBXHvA-L=C-mrvhMOBBLrTO3J-3Rw@mail.gmail.com>
Subject: Re: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from readahead
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@surriel.com, david@kernel.org, 
	baohua@kernel.org, baoquan.he@linux.dev, chrisl@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 495111A0005
X-Rspam-User: 
X-Stat-Signature: asgpt4jg53wzk1j56qbkgpye33xu8gmo
X-Rspamd-Server: rspam09
X-HE-Tag: 1781014062-103998
X-HE-Meta: U2FsdGVkX1+XUsHtsleLf4d2R2HiRSMlIMwmmcI9PAHJ1CqB3VTlRPsPbqpNXPmAXsjh9B7Y6E7xiJYAmiyECTRryVNmfD7gWI8KrSXUaMTsh6bWxcbHQIp8qCzfJ5TEU2X9HO8RMUxYcUm5JqmqcF+kLaAr5GBIFAv0MCYF60qwt7DKx2LwWjmsQOJd2cv8aUVeP+KIUxEoXctE8YOzAAmZqhkvnVIrq3/5ffKgjereXLLH6ovOS215hXUrFc1J8u9bQulxv22cb07DVgQlJjsByxgp22u5GL6CZSquDmViZOaVCWI7/i9CuRtDoDkidSTmTOgKiuQnhgJfc2YotsSpZbl7H4XAUMlAAoJ6WQ9B7AURTg40JaoCVbahha/qiC2gesTqljyYAaZHxdYbzMKjTDE0anW4sxJEUzajvtwwukY74ZcUZDHnoLqkX9coKG7G+Wo0XGu7fiG6opHVXrnchDfBf59zMrIspdOzcN16h7WppaEJe7xNWYFxJFTBPXZUYzw8qKlVEpa+TJZ/0DmG8rcYrIhTg3JQEF6HX1IFD/JvoYYKr5uvAbjCOrxSaVdan15v6HMfuuJKyI9TVqoqkhc9bKfrXrgKBuwSCQ4zlFWLE4xmk9bvHUfzsWYWRYLyojHVEQxsUfbeoewvNizjKLAkMYArgycoBta+pJTxfmV5TsGpyvGRG/7fIwcNx+XB6FfzUDIeif4DYWyYippHdvjuSzNgeSsBSfdiSJt1y9yfkqwl6h7ph/mmtYG8Ty/n8HzMrMTfjTKa7ezwRDphdhPR6q8gjechJFVOvy55DmV4iTJEq7DezE4FSxQtNupwSAVdUBdKwFVO8kxml9eqZKrmH+Tw6EQvGtAcUhdZG8LPDwXKJNVa62r8V+PHwY9VC1J8tAqYoSusYfgaYyOpSjlEKa0uL2bi216mLz+mC7LfgaHiRn+HQNCKMHvBGBd06zjO1QLqaf2QvP1
 uh2bYoVi
 W4epaPokWreDjJfAOAQokW/AAA4feWmgiHr2w6ICPkFztJbsPPWPcwlTRMy25qfBWFC4PAJvDw0PesrDLj8/NNSI+yNW163oJrqqK5L+dWN9xs3sbeKotTPbtwtfSum82VbwNVEbgZRqRTtE0Ly5t90KaoWDT64TkhnBkyBliVTPAebskXD/VTS18J0tTE5PfSN43NAb9tg5lD06+5QVS9QFwTE5Phq/jHB4OtLvuSTquYsh0rGgTh6gnQ576wDuH8988Vtj1zSrk9NICrrEK4BZHLNo+SDpKTbIVnbgiABf6f1xuVZ6LZRjBv55yfF7tkGv5MPWCc5qwyr6ZCMOj16j8tYRke+cgtPmgiJqARwNK8Ego3ndp2y8sG9NcpD676BgD03sEXNS4W+k0kCopftQyOSkcBhrwVP8vBX/UcYtC9jTLkYYqBwhW+dtQmDbcmAhOlqD0kw7mAAqDxh05dScnJNmplIZxHjuMuxyWRmE1tXvCf4Vs8aU0F1Qa5Io/XkHBwSqa6dCAkyk8ys8ou/+cXSAG0OB0f7mVCeE5eCl2KRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 10:45=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> swap_cluster_readahead() and swap_vma_readahead() end the readahead
> loop with an explicit lru_add_drain() call. That drain is a leftover
> from 2.6.12 era code and serves no functional purpose for the callers:
>
> - do_swap_page() ignores LRU residency for the readahead folios;
>   it only needs the target folio it called swapin_readahead() for,
>   and if the write-fault path needs the target folio on the LRU to count
>   references accurately, it runs its own lru_add_drain() at the
>   wp_can_reuse_anon_folio() and do_swap_page() sites.
>
> - shmem_swapin_cluster() immediately locks the  returned folio, waits
>   for writeback, then operates on it - LRU residency of either the target
>   or the readahead folios is irrelevant.
>`
> - try_to_unuse() likewise locks the folio and calls unuse_pte() without
>   depending on LRU presence.
>
> Folios newly added to the swap cache by the readahead loop sit in
> the per-CPU LRU folio_batch and will be drained naturally as the
> batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
> lru_add_drain_all() and so on.  The unconditional drain only
> synchronously flushes a partial batch and forces contention on
> lruvec_lock.
>
> On a 176-CPU production host running a memory-pressured workload, this
> path was observed to call folio_batch_move_lru() from
> swap_cluster_readahead() ~28K/min, a very large source of LRU lock
> traffic.
>
> This is a direct continuation of the cleanup started in commit
> 1aa43598c03b ("mm: remove unnecessary calls to lru_add_drain") which
> removed the equivalent drain from free_pages_and_swap_cache() with
> the same rationale. A detailed reasoning for this is present in [1].
>
> Remove both drains.
>
> [1] https://lore.kernel.org/all/dca2824e8e88e826c6b260a831d79089b5b9c79d.=
camel@surriel.com/T/#u
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/swap_state.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 9c3a5cf99778..6fd6e3415b71 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -836,7 +836,6 @@ struct folio *swap_cluster_readahead(swp_entry_t entr=
y, gfp_t gfp_mask,
>         }
>         blk_finish_plug(&plug);
>         swap_read_unplug(splug);
> -       lru_add_drain();        /* Push any new pages onto the LRU now */
>  skip:
>         /* The page was likely read above, so no need for plugging here *=
/
>         return swap_cache_read_folio(entry, gfp_mask, mpol, ilx, NULL, fa=
lse);
> @@ -951,7 +950,6 @@ static struct folio *swap_vma_readahead(swp_entry_t t=
arg_entry, gfp_t gfp_mask,
>                 pte_unmap(pte);
>         blk_finish_plug(&plug);
>         swap_read_unplug(splug);
> -       lru_add_drain();
>  skip:
>         /* The folio was likely read above, so no need for plugging here =
*/
>         folio =3D swap_cache_read_folio(targ_entry, gfp_mask, mpol, targ_=
ilx,
> --
> 2.52.0

Thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

