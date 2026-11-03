Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6763060A5BCF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gaF32EEu
Received: by kanga.kvack.org (Postfix)
	id 929696B05C2; Tue,  3 Nov 2026 04:55:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900946B05C3; Tue,  3 Nov 2026 04:55:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF9B6B05C4; Tue,  3 Nov 2026 04:55:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 572396B05C2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:55:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC635A7D73
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:55:26 +0000 (UTC)
X-FDA: 85393350252.30.E12AED7
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1218E140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:55:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gaF32EEu;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKxZ1A1j5PkyV/iA+/kwIGbenh4oNStIZE9tQOwmG6E=;
	b=H4U5wf31/pWW8GiV0FH1jR03dZ3ygwUHjUyRD5vvo13XG1Ow5jQ17chUYuf5HtTtO42hXk
	JWNT7wmOXmcfHi9K/6Z5/fqXn9cXg+LyHzBYu88DqNKbpbxeCS2SJSfXECAiwUmY3Vz24r
	fcfEI333lGoeaJW5vFHZw5qllSOTGOo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793699725;
	b=08eKi3c3RS/ZG4Wfvcw/TgC6rauOHL2Pxjd2vMqHGLczg5QUbl0TJW8S3+Mf75/opjGHiN
	goKNeMXqKoUCdSwZmkrAAMupwx0JGOerSCtCxFVxEG9fy8dtwA2N5SwWpC0aEGWydlsmZf
	ocOxbLj3whIMtkpLYze9+XDYf3s2o90=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gaF32EEu;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so38252105e9.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 01:55:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793699723; cv=none;
        d=google.com; s=arc-20260327;
        b=U8bpeA+kKNYr+mH+WIWaeEOT8K/aoCZSJhEGi+1imkMW66GcYyEKefcpSJ/kKwx/Os
         heHAy5nJ9qMaKD/W6xdg/3SFGyQ795qP/p0dXrenepOz4nxxb+Arphp3zcJlfDYyKQJr
         96xEVOxQKaEy0ZJX+sPTYvIWySIvA6vciRHEanTL4bSEIxZ+6QivcMW5J9IxCsldi+cT
         boQ/QKPvq7Fy4iQWeF3TLeSQrWOOxDewcbkutGyQQDkrdUhXfX6+1pzR6bqXWvf7u6jv
         8gboX2zLfHM0Kumj3CaRlgGUthSeLysE/cIXvvHreqYguRd0uC9TEpxFkg8MDrawBR8b
         yLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aKxZ1A1j5PkyV/iA+/kwIGbenh4oNStIZE9tQOwmG6E=;
        fh=Jnc10Umap6rGP7C58IXbYu7fCiwIJrqdm68k2QeeF04=;
        b=gM2V7dOoq6UnBoq5WCo+fNL83Ot6l+Q1+Z7+t05TmFjVLFVSPK6xn/YD3ZYzacp6i7
         mok/pef/L0ZKTPKVKAlPihWikjZrF1PByqiPf4H5ipLc4MntfQDsthXAdxIwet22O6nR
         2NTbkDfQOo3Opt1fpK2fKYjEsslKeyWegh/CjGrRcHBgdggT6t9NwehFtO9apVqjVPe2
         GXV6LVehfdddA/TSsGCb0RcvktusdvA9whgW+6aD/EzvjMbb1z5F4WQndOpkBPAFbvqm
         xg+2vExJMFE0ekIQYnLOTVZiG/WX3tB43D+lfylXHsfwshvdr7WuKtdYAgtAZ1jDgWMz
         jrvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793699723; x=1794304523; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aKxZ1A1j5PkyV/iA+/kwIGbenh4oNStIZE9tQOwmG6E=;
        b=gaF32EEuMB1qC+gXJSu4FkTHXmfY/8aLPxuOXGlHTC8Vi9Y9zbF7JJMyLY6I5anGgB
         MRLmo2BQn+qCs81QkJjY6ZyIx/UXOMoHYnL/1ru+0yhV5YEpfI50N1QTehSpqjcOB2hq
         OiDIy0k4P6kuAABMqTS79C10gWAXy2Ew6M4Lq0vK3+E9K+zXoOd5EPRgXunpDDaRGIal
         zu58zZKtI3ZtrK4+MiicB0vCUEzAnUNR2da0xjnvJFZxYf2tAm+ohOSlzv/hWGqMEWxw
         oswS9duYNVuferCIBSc5kH/wlsWFei/lYVcZAIyHnVC+yDPxg+qaTazHfTk+DRYVLVw3
         dsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699723; x=1794304523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aKxZ1A1j5PkyV/iA+/kwIGbenh4oNStIZE9tQOwmG6E=;
        b=fwCnKEkdJyB4JcMFyBgxTaRat2+ng1Tzjujmw6mzamJayRmVGqKLYD2CogzW6to+bU
         I9ruKTRpwJHnGZZUk/AdrbOZZvZ/IjZ9g8bOYZ5cxG151J/uorsQg06S0uCBtayR4hnY
         /PgxnmIJ17i1GqMW5kwfadkGceblpn0y/WH+i1o+C8hb9VHCOub2cOysIVqWr6aeEJlQ
         lJ1x1LwevVVQwqy4pdbwsYZrRhdr+rJDukGxwYXRzqALdmz/l9Uv+vFvsTdfwe4RcifN
         y0B74tUl25co2HHZHJlbnAbvsDKuHswIbDNY8Gz4M/yvaRUrDf8ZAPCgzn8VfM7ILMPa
         qe9A==
X-Forwarded-Encrypted: i=1; AKwUvBzzzBbDqhJzSQUAdN064kfKxPebRSRJNJ1bIzNrLaXKNx5qK6RtaUg7JnNxpNQcFQa3LTOX/oTShg==@kvack.org
X-Gm-Message-State: APuU4Z9JWQFWmOj6pF3UU0NhTNMrpQnnRTF1aiHwTgNjxodo7puvQ+oO
	8grcaGINrDDJ8Y7271VEZhA3/ZeuVSLnBy68DrwFzYAEH10V6v159X9bmcTQMpiCn3SmNjtXX7T
	Fe8FNirWMCqtlbVhr3Zrnk+C6Gg2D44E=
X-Gm-Gg: AYBFou2Vkg3v3hNs3b+A4VNgKiZkfXvntbDUSNXU8iUjVMS6Ji+v9Kp1oGb8d+i/0WW
	B8DqVUgAjzrBw4/FwfpTx/0FWgFVg9Kf4ieBcfugOpOIxYv9iDFll62n+VFyziQ/lgXyMfS70Jd
	iEG3+pzwBk4mzbid0bmaZnq44uoZ5E5JfzRKJI+kvK0rhfNbdtseqmU+5b+JEzBg4DC0RuG2CG5
	L4Cg0iag9j+FN+gZU/cWI5XRMI4aT1SQZpMeJx3pGHL6EoJDF8r3RPXW7fWuxGkdLlnPpEqIrWH
	juTdahvyfPct2/7TFdKIxjADrrk9p8QrRSttjgbMWaVvYfaHfuFrYqHzeE9psDW2iH4pOuZjw6R
	PwrTxL0FQ4XJk53RJLPf9AiOjB35kZD9XoVh8GaSVZ55D+mShsRmKi9hqxUAIb+nkf09vI+c=
X-Received: by 2002:a05:600c:1d23:b0:4a2:167a:c946 with SMTP id
 5b1f17b1804b1-4ac185bccfbmr287062505e9.13.1793699723045; Tue, 03 Nov 2026
 01:55:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-10-baohua@kernel.org>
In-Reply-To: <20261022220203.91911-10-baohua@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 3 Nov 2026 17:55:11 +0800
X-Gm-Features: AclHuK_nvUMoVLkjwOljmlj7612c9xcGHLHJRZ07_eMI0YGDtIC6c9eYytDVpYo
Message-ID: <CAN_Opa_NKPsZkyHAinuFYcXpH26V7JDQ9K_WvoOK4n6Nf3noEA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 09/14] mm/mglru: Avoid placing rejected folios
 below populated gen
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bjqbuz9bsd44uk3nqr9wry7epixjssos
X-Rspamd-Queue-Id: 1218E140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793699724-134702
X-HE-Meta: U2FsdGVkX1+kY8t9LDheB2ZRgdtPrp2vNKlBMo3iFii+u1FeBnZwcxu4+Tlm+SSRdeLBvXC29wUn54oOgdk0idY9wbgQNAOxaK2u9fsBm9UZoz4WTrGwsM4LjUaM3iRQ+LzHr2vEw6mOJCXdJ/2wBFuRh7uq6YTAyfXNF/WVrcZHGIos2mCDD0+l8az4fQbwIFgIdLDGP3Wem84jqr6wYO6krmsA1xyMt49YpZWux6OIYDWkfdACT/YjDeJHMnv2M9bZJfPYUGKW2owYryWdnj88Uq1yGdGZ8+wNIWAcUkeaCaiyantRBxBf2tChze1M7JF1rn4IAg0nqJj10O0+eQxzqW0qZH63cDe3pmf28YEYqf8F+9lOnRAucw86PjxXJHFAGqyjYYqBiotDBmFfjyVH7m3jDTatkWJ9ArgkyU38seACWXts7q3nWoEOmv0Zmus0uVsTu1LAgavF0Xq7rG4O8r3VedK1X+cb0dw9DWE0eR6r7lxX7yzulpufJEEz//HfOAs/1lYJtUHczjFQVfEKbG0CC+QkwbekncBhj6RRK2ChI09xlxrztmWejwrRdkRn49JrfXiKxRWfZc3cSAg7rlDRvQXY1V5Tl0JfjTxgO8yazFeCIWMWmbkZL/9hb97ETVskoANZADgoVvNs07d58CdRZgG2od03VR/179Z7VtNNCF4tlo64ZpxxVVLDXNBBSd3viYdNwE/TwObczKGagAoHJKRM7W/Eme/m5si8lkn2BiU4Mam+xi3/ad5a0vFu6vx4RIbzBFG9hZj+1s1AGlmJjCw6/cf8TYDGJG94yb95PXOf2pAGQ247k3eCjjf2qhlbB3+y4E4m7bA0PYOXJrCEC6scMUZMeki6vCWfWDo42mDBzPYr9Beu5zVpqDWmreRyeGC7UCn5rWP54tw7wvLBnfkcTREfrsm0qsP3BJfSjO2rlpuvEC/2ogKo3K+zk9AmIKBZhR4/VrM
 zmvT5fiK
 25hU9VDk3kDkoIShBmztE0P4jcHmvzDfA/g5ZsNo4CCW7tkrQVAYlpBVXaqMmDUSQvyEU4wUnuZdVRTnhtxNbC2uIdxJfj76o+kJfq+OdDLH4IjuSkc7BejF+StW1CE3vj5Crq5o5Rmzvwt+rAN/4PUi8bpTFeMh7o6zCM0CN9mbRhJvVxeYf1cGV0PtftU/crcc2UvyZlFgWr8JRcJFLk3Z2eybLmbBviYUeUpqPAV6EQSQWTns8fYR3bPLnYxJ+7EdMpbP7SHb8YRJzp984JCJ5IoADXSa/RZ+v8+s7C4XiwE9gFKb68sx8rO7VG0T/iU6fk1bvbzPhQv39f+u3/PNs75cjHvGIQCgYDYTdcZ0LMNSYnHvYY0RubMZNmSCwQzYJE+Jx9IpcrNncIyVteMlHOPh7Nrrt9d8H9MgoEiTm40sXURb2AmZR2hdxqliE5AcWEGbY5p6cv4Ciy8kFlRGN1jFuG6asLKhRZAW6KVhtCFLK429QIVNROKJo+jzKY3aVoTZTe4gSZSI5y33pGy71Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 6:03=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> We used to scan only the oldest generation in scan_folios(). In
> evict_folios(), we checked whether
> lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_seq[type]. If so, the
> folio was marked active and moved to younger generations.
>
> This was itself buggy, as folios in generation min_seq[type] - 1
> would not be marked active by folio_set_active(), potentially causing
> a cold/hot inversion.
>
> Besides this issue, the old approach also differs from the current
> behavior, where we can scan fewer than two generations.
> Now that we can scan younger generations, including the youngest
> generation, this no longer prevents rejected folios from being placed
> in a generation below or at the populated generation. Such rejected
> folios would then be scanned again and again, resulting in extremely
> low `pg_steal/pg_scan` ratios. For example:
>   pgsteal_file: 2312605
>   pgscan_file:  36465693
>   reclamation efficiency: 6.34%
>
> We pass `scanned_seq` to `move_folios_to_lru()` and make sure we either
> promote the folio or place it in the youngest generation when the
> populated generation is already the youngest one.
> Also, folio_set_active() is no longer needed.
>
> With this change, the results become:
>   pgsteal_file: 2683815
>   pgscan_file:  4224244
>   reclamation efficiency: 63.53%
>
> The sys time for building the kernel also decreased from 4m30.532s to
> 3m50.188s while swappiness=3D=3D1.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  include/linux/mm_inline.h | 22 +++++++++++++++++++++-
>  mm/vmscan.c               | 24 ++++++++++++------------
>  2 files changed, 33 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..f6f4bc9a704f 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -332,7 +332,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
>
> -static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
> +static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct fol=
io *folio,
> +               unsigned long scanned_seq, bool reclaiming)
>  {
>         unsigned long seq;
>         unsigned long flags;
> @@ -347,6 +348,8 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>                 return false;
>
>         seq =3D lru_gen_folio_seq(lruvec, folio, reclaiming);
> +       if (scanned_seq !=3D -1UL)
> +               seq =3D max(seq, min(scanned_seq + 1, lrugen->max_seq));
>         gen =3D lru_gen_from_seq(seq);
>         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
>         /* see the comment on MIN_NR_GENS about PG_active */
> @@ -362,6 +365,17 @@ static inline bool lru_gen_add_folio(struct lruvec *=
lruvec, struct folio *folio,
>         return true;
>  }
>
> +static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
> +{
> +       return __lru_gen_add_folio(lruvec, folio, -1UL, reclaiming);
> +}
> +
> +static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, str=
uct folio *folio,
> +               unsigned long scanned_seq)
> +{
> +       return __lru_gen_add_folio(lruvec, folio, scanned_seq, false);
> +}
> +
>  static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
>  {
>         unsigned long flags;
> @@ -420,6 +434,12 @@ static inline bool lru_gen_add_folio(struct lruvec *=
lruvec, struct folio *folio,
>         return false;
>  }
>
> +static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, str=
uct folio *folio,
> +               unsigned long scanned_seq)
> +{
> +       return false;
> +}
> +
>  static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
>  {
>         return false;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 12aca97be56b..39f77a68be37 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1971,7 +1971,8 @@ static bool too_many_isolated(struct pglist_data *p=
gdat, int file,
>   *
>   * Note: The caller must not hold any lruvec lock.
>   */
> -static unsigned int move_folios_to_lru(struct list_head *list, bool do_r=
otate)
> +static unsigned int move_folios_to_lru(struct list_head *list, unsigned =
long seq,
> +               bool do_rotate)
>  {
>         int nr_pages, nr_moved =3D 0;
>         struct lruvec *lruvec =3D NULL;
> @@ -2028,7 +2029,7 @@ static unsigned int move_folios_to_lru(struct list_=
head *list, bool do_rotate)
>                     !folio_test_referenced(folio) &&
>                     folio_ref_count(folio) =3D=3D folio_expected_ref_coun=
t(folio))
>                         lruvec_add_folio_tail(lruvec, folio);
> -               else
> +               else if (seq =3D=3D -1UL || !lru_gen_add_rejected_folio(l=
ruvec, folio, seq))
>                         lruvec_add_folio(lruvec, folio);
>
>                 nr_pages =3D folio_nr_pages(folio);
> @@ -2147,7 +2148,7 @@ static unsigned long shrink_inactive_list(unsigned =
long nr_to_scan,
>         nr_reclaimed =3D shrink_folio_list(&folio_list, pgdat, sc, &stat,=
 false,
>                                          lruvec_memcg(lruvec));
>
> -       move_folios_to_lru(&folio_list, true);
> +       move_folios_to_lru(&folio_list, -1UL, true);
>
>         mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
>                                         stat.nr_demoted);
> @@ -2258,8 +2259,8 @@ static void shrink_active_list(unsigned long nr_to_=
scan,
>         /*
>          * Move folios back to the lru list.
>          */
> -       nr_activate =3D move_folios_to_lru(&l_active, false);
> -       nr_deactivate =3D move_folios_to_lru(&l_inactive, false);
> +       nr_activate =3D move_folios_to_lru(&l_active, -1UL, false);
> +       nr_deactivate =3D move_folios_to_lru(&l_inactive, -1UL, false);
>
>         count_vm_events(PGDEACTIVATE, nr_deactivate);
>         count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactiv=
ate);
> @@ -4910,7 +4911,8 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
> -                      struct list_head *list, int *isolatedp)
> +                      struct list_head *list, int *isolatedp,
> +                      unsigned long *scanned_seq)
>  {
>         enum node_stat_item item;
>         int zone_idx;
> @@ -4941,6 +4943,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>                 seq =3D lrugen->max_seq;
>
>         seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + =
1, seq);
> +       *scanned_seq =3D seq;
>         gen =3D lru_gen_from_seq(seq);
>         max_gen =3D lru_gen_from_seq(max_seq);
>
> @@ -5135,6 +5138,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>         int tier, scanned, reclaimed;
>         int isolated =3D 0, nr_isolated =3D 0;
>         unsigned long total_reclaimed =3D 0;
> +       unsigned long scanned_seq;
>         bool skip_retry =3D false;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> @@ -5146,7 +5150,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>
>         tier =3D get_tier_idx(lruvec, type);
>         scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> -                             type, tier, &list, &isolated);
> +                             type, tier, &list, &isolated, &scanned_seq)=
;
>         nr_isolated =3D isolated;
>         if (nr_isolated)
>                 __mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
> @@ -5172,8 +5176,6 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>                         type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>
>         list_for_each_entry_safe_reverse(folio, next, &list, lru) {
> -               DEFINE_MIN_SEQ(lruvec);
> -
>                 /* move_folios_to_lru() culls unevictable folios via foli=
o_putback_lru() */
>                 if (!folio_evictable(folio))
>                         continue;
> @@ -5192,11 +5194,9 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>                  * so this effectively promotes them by at least one gene=
ration.
>                  */
>                 folio_set_lru_refs(folio, 0);
> -               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
> -                       folio_set_active(folio);
>         }
>
> -       move_folios_to_lru(&list, false);
> +       move_folios_to_lru(&list, scanned_seq, false);
>
>         walk =3D current->reclaim_state->mm_walk;
>         if (walk && walk->batched) {
> --
> 2.34.1
>

Passing `scanned_seq` to `__lru_gen_add_folio()` ensures
that rejected folios are placed at least one generation
younger than the scanned generation, capped at `max_seq`.
This prevents them from being repeatedly scanned at the
same or older generation.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

