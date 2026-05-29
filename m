Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF39FCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC6C6B00D0; Fri, 29 May 2026 14:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4846B00D3; Fri, 29 May 2026 14:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9EA6B00D7; Fri, 29 May 2026 14:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC1446B00D0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:35:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D2DE140265
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:35:52 +0000 (UTC)
X-FDA: 84821311344.29.1190C95
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9274380010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:35:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=invRujqj;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780079750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGl415x2fsqiOBBpTEJg/XXf8v3MH+BgP2tr0DmzY7M=;
	b=ENx4BoSeLMQ/bL70D8R59qeotY6H45TEHJLcFFPJF9nPESYBGFmoKksl1rxSLp3zs4mKjE
	FkPvFAujBNjONO4bHMXp3Yzy+Y2fdBmwNTKcLgivXq1yTP5Wwnuorzm3f3xVfe4inGRS8U
	rgOFhm2s/Ed1UW4FMn9XJLwafen/pV4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=invRujqj;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780079750; a=rsa-sha256;
	cv=pass;
	b=TtuphLu9Rf1FxAoAYRmxQZPiwQRwsHV4VFxyDdr2ey01gf5pCpOfEG+4NV/9t0oNe/lzEG
	K04o1jyIz/Z6A9Z2Og4mw/U/30rtsZutk3aukiTlwuSGsenZeUv4/VBc3A6H+P3Z5qZmwy
	RwPgLamX3Ky2FQjotj337C+LIQq01c0=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4909e3fa4b2so8367335e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:35:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780079749; cv=none;
        d=google.com; s=arc-20240605;
        b=RmMJ3O8128Yn87XCcpMG6IcA++wse+HsDfjR3zqmyZkRYKFWMrsmxGujZF1SRfTZQ1
         j9ca6eBh6SW1yqvh103dgU7Gy79YAqlbwbitYCK8XMdgk+uMD7pgCkeOBGc9y7Jh7Bk4
         w+KqFCmf/4LiLXQArZSdctOEEpSx+CmJLbmbU5Wmu1eesGiyQJPrTHCp65w3RXDJXLKO
         B6locIOhPYkznzehRyu89HealS/WgVvcBZ5rsMicEONGgteek1hy5fjmTHxOJXDa+zjO
         7k9g2OGZi7ssv6oS2b5giyELP+ghjvN7BtGqIm5inCyn2n53VU8puNZJxEufBeuDBCkq
         E+PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MGl415x2fsqiOBBpTEJg/XXf8v3MH+BgP2tr0DmzY7M=;
        fh=2QErpmKHb+u2TTKCFw1BCd2rW6Dtsk98G7G1d25zx9s=;
        b=K9GYGIOvzSUmn6hvTG+gDE9c91vF/iLgjBcTb93qYMFQ3iiyZhHjVo1VZ4VuUz5EhP
         nDrk7aXsWxATKW+GtxxdCC5ExMz5M3SsgxGRQJt0AXO3jDF/mTIovw8/UW7rWhMWPZye
         V6nSlg3L+TNiQ7A5kG9RSS58Hk5/nOgdEwm4hTFK3PZ5YKQnM3aJNnCoo+I6blRIwIQR
         YmnXio28L0C91vPzIkZix3j8grsEhhcWWmYJYaBeslrbZ/9k4EA42/4lNojiDRQhdCV+
         hVHtZYB8awzgIJa7yhPdEvcW7l/scLjAEQUWdA/6+9enaZC5LEGCjOZnL9NPgBmXTCiL
         aSXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780079749; x=1780684549; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGl415x2fsqiOBBpTEJg/XXf8v3MH+BgP2tr0DmzY7M=;
        b=invRujqjgJsip0wzgsIWcBvr679/QOIO27mwgiujT0e0niYB/qkab6iREwooWpL35u
         J7FNF+I2K24cd8/dFx+sVEIkUgtQCkzzH/Ip0jUQCUcCGx7rJCvE98aujSQlQm8L+aj5
         emi4oMM9bA6o3Bu+sg6z+naUVwRODPMQLv0mjiKpekoPk0nQA6wytTFNmZYPa+Dkdzml
         20JCAihpiPEU+aEmG4SIvMKb2N2Fr9ZwoRXOyTbn2b/bEOWh8cZYdmEOizM4Xpk7heCy
         AZswcRHXbXMwVVOydTDgTHVa2JX17m1fzLxX9hdjpY+b4eKcLK4zvQrIOfFLdpCl2dL+
         twaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780079749; x=1780684549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MGl415x2fsqiOBBpTEJg/XXf8v3MH+BgP2tr0DmzY7M=;
        b=lffCsmEMrwy2UavbvnKWX/TjeHpZ1wYN6Kjp67SOe8gdHILrAaP/eDvw0NkQ2/lsmH
         S3tDW8vPSdFbccRqVXuWAAYf5Oib8A34aKWvXd4ABpjzad1vAFbMIlBeXPV6NU3npkF1
         a396jZpyHGCo45FA9402trC+FycRL7nDsXJaMtc5g8zAOtMr82k8KmiFmqRTEfYRCfCI
         RIwYGTpaHnNs+Kz2xTWjGX2BJUx39HYWWaCOu2IAx5WLjbhfAQaHvcl8hEoRhrkS3rfd
         JdcFB+hUaaoBMKYLZtBh+2jVBehoiggoY4sqpjzuPZFu/AGGA87u86dexiV8L1ZTYORZ
         SEHw==
X-Forwarded-Encrypted: i=1; AFNElJ9CA1GJqReZdfWFj7v3XiFNfIc80d3i1Ti2MZVa7hA2/w7h3gNzd+ElWiV64kBm6D67k5Rg931+6g==@kvack.org
X-Gm-Message-State: AOJu0YwFMMO2BCHYnQxFd17+dNdc44UrcYgboI0Hqo7Zpo6Zm7AcDkG5
	WgE85Llk+FpCwXZKVNFoNgPYOg7At39MQHjp4j8QKPLbVI8OptmibxG4stbGTRIJLHDUITWVVt7
	MLqg5LF1fGH5omYaydool668n60PEKBY=
X-Gm-Gg: Acq92OF/4shvKJH7+AtFSmmukTx1wlLh/FYU5SBf3VG9URKUzFcSVUbavmaA3imCEv9
	tCLKJ/yKNi7t49uToIDo0m5lt5PtkZHlPftcykFRtRNoiEw/PsWQgJUWrUV7gC8qDGwUn6EDe9K
	Tzx2XVTBeVtNPUZeag5e3rAYh1VKfJbeSncLdYahnLb47STgfFN+UhbINcsCDNiO4qWQkbB1+lQ
	nZ3wdoMxiZhpfUCZpGZ9fYXfNxiMT5AVVlMtM6+n8wHIUgRrY+RRIC1Ang4cbjIKnafBmjiv3kB
	azMg3jZ5jFPUCETlIWH2zUgJE13LobdMGR/o09Ep8uemWSHufg==
X-Received: by 2002:a05:600c:4714:b0:490:53b0:9e53 with SMTP id
 5b1f17b1804b1-490a290bdfcmr14252835e9.1.1780079748969; Fri, 29 May 2026
 11:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com> <tencent_C78A02F3C41E15233C371816825C7DCF8708@qq.com>
In-Reply-To: <tencent_C78A02F3C41E15233C371816825C7DCF8708@qq.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 11:35:37 -0700
X-Gm-Features: AVHnY4LFWwMiv9dobFO7ohhoACD8Hf7dh6YZvBHF6MmRjK_iIIRP5J0Z3jFSKQU
Message-ID: <CAKEwX=NUQb5b4T49dbRV0_41QYRRuLkQNUg+FVDpJiobCCCh7g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/9] mm/zswap: expose range state for swapin policy
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>, 
	Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9274380010
X-Stat-Signature: 8bcz18y4531kk1mpsnfsrxut94yoazen
X-HE-Tag: 1780079750-709521
X-HE-Meta: U2FsdGVkX1/fms+w/KsMWw67FhM2IZrca8kE/FC4SVWCmWg4t3XgRr3A80meII2Do+EGB68f8mMt/EpfElZj8mvU165aNf1PiZ9dg5/Im/1ijmg9QP/S+U/o/7qxVxsN47dXEdsNzWykXerEYOgvQ70lVZZaHlfghf/sHhStXLyFJ3tbND8ACW3rDdKjIU9y6aQWa108zCnC5dBKJhbn0Xvn9/yTfMFxe4YHs/pK5Qs1D7IO1mNL+clZyyBNS5orfx/ByyTBvF7QntAezQt9DTe8Z++Y98cZoIcRBuwiJvqjw5pDvZiN7z5tHuY3bQg6znpnBxPyxb5oZleHY8HdE7kFvSg5e3sFKWn+MuC8I1fX7x1ERI8kQ7kxbs5YPphO9R6YTpvBA6Iq98b8pepoNURTz9JR4C8ZE+wkaF1NN/taB1JjtcrYtX31RAYOu7Ab66yfL/WSWo8OgFOKstr9ieqiwdRXn01++XdzKBOWpTPvHH3tffSznHwNL24tLSwEyevp5hrcXMMD3pX3yn+gg3v7chAzF7dhd6HIQ0gPYc4Dq/3Q8smk3PI32Hzj69QkCKK2hNxw9G5rp1yVirgHlDEk+M4aUm7kuupKzmEMXnxdNJ+SUykHFZ7iabTCNYo4VgwD+CKyNCw3gR56JgLKtt776Q8vxp8LfXq2/aGuOGJnLgQgQo/Zs26IuOotXDRJic8TPkyJ18/nBIsrR9jGQseanjOj2RhqIBNsw2QXQHDvzZYk0h5Nsr15IntEjnkuA6pOEl9h7T1YmzJ0DwkX12NS1GiPd1jeMLbANNg6WnHgSJ3+1yxS43g49/Ojpj39m+qSi8GndaWFsJTInNorJm8BUFg0XmNoa/pNwomhejjhZx7YpabEIfK5QFu3POS9yVLOkZlg8VEtMHy8w4/dmg3RmQzKhukEiMvuUjLKfnuIv63l85frEFDmSc/peuzr0RmGRxbhrOyJrBuA0ME
 gpZnTx2B
 NdOKf7sCkQ0UHDzjhxd22k9rKC/Cw3VwP1TtxWl5ut+acT4iAvr0Hu8XsmP8OG+Q0Lj3l06fozegzz5kbN0tbTtWo+vv34n4xrVyMeVN+Z3XdjHb2umQQDtATgbvZwkOZkAhwhPt+bTZsQd+7JCu35DJgviIsw9o3i4/TRmRKupiVjo+cy60D+ozlCp8PmustMUF6pfOHlZ/za+A9yFEi1JWd68zXrQhjvdYZ+hE6RGlqkuNvEA06wFt/HbvhnysjQfUvIqCKkeV/0I1qEPUi0QO52zMvU+87CJppRwi3XGBstqHRjtcmhj+y4UaFqdSYnr1GCUupspisdgzmlFAlaUIvAfJ22NiiQHcxqK0l2SdEu4kLDQdQXKhAop5ZSdJxodhi5qy0yUhf9rrU3TeSlvbZ66/phl7z0UVnAlnvZlah0FAB6KYtQIClPhAiEicfqgru2P+wAwjZXD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 5:19=E2=80=AFAM fujunjie <fujunjie1@qq.com> wrote:
>
> Large folio swapin needs to know whether a candidate swap range is fully
> backed by zswap before it can choose an order. That decision should stay
> in common swapin code, not inside zswap.
>
> Export two zswap facts for that caller: a lockless range occupancy snapsh=
ot
> and the current zswap reclaim-pressure state. The range state is
> advisory only. Writeback or invalidation can change the backend after the
> snapshot, so users must recheck before issuing large-folio IO.
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  include/linux/zswap.h | 26 +++++++++++++++++++++++++
>  mm/zswap.c            | 44 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..8f9aee97517c 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -9,6 +9,18 @@ struct lruvec;
>
>  extern atomic_long_t zswap_stored_pages;
>
> +/*
> + * Advisory zswap occupancy snapshot for a swap range. This is not a com=
plete
> + * backend classifier; callers must recheck before depending on ALL_ZSWA=
P for
> + * large-folio IO.
> + */
> +enum zswap_range_state {
> +       ZSWAP_RANGE_NEVER_ENABLED,
> +       ZSWAP_RANGE_NO_ZSWAP,
> +       ZSWAP_RANGE_ALL_ZSWAP,
> +       ZSWAP_RANGE_MIXED,
> +};
> +
>  #ifdef CONFIG_ZSWAP
>
>  struct zswap_lruvec_state {
> @@ -27,6 +39,9 @@ struct zswap_lruvec_state {
>  unsigned long zswap_total_pages(void);
>  bool zswap_store(struct folio *folio);
>  int zswap_load(struct folio *folio);
> +enum zswap_range_state zswap_probe_range(swp_entry_t swp,
> +                                        unsigned int nr_pages);
> +bool zswap_pool_reclaim_pressure(void);
>  void zswap_invalidate(swp_entry_t swp);
>  int zswap_swapon(int type, unsigned long nr_pages);
>  void zswap_swapoff(int type);
> @@ -49,6 +64,17 @@ static inline int zswap_load(struct folio *folio)
>         return -ENOENT;
>  }
>
> +static inline enum zswap_range_state zswap_probe_range(swp_entry_t swp,
> +                                                      unsigned int nr_pa=
ges)
> +{
> +       return ZSWAP_RANGE_NEVER_ENABLED;
> +}
> +
> +static inline bool zswap_pool_reclaim_pressure(void)
> +{
> +       return false;
> +}
> +
>  static inline void zswap_invalidate(swp_entry_t swp) {}
>  static inline int zswap_swapon(int type, unsigned long nr_pages)
>  {
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..da5297f7bd69 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -506,6 +506,19 @@ unsigned long zswap_total_pages(void)
>         return total;
>  }
>
> +/*
> + * Expose whether zswap reclaim pressure is active. This is a backend fa=
ct:
> + * zswap_check_limits() sets the state once the pool reaches the hard li=
mit and
> + * keeps it set until the pool falls below the accept threshold.
> + */
> +bool zswap_pool_reclaim_pressure(void)
> +{
> +       if (zswap_never_enabled())
> +               return false;
> +
> +       return READ_ONCE(zswap_pool_reached_full);
> +}
> +
>  static bool zswap_check_limits(void)
>  {
>         unsigned long cur_pages =3D zswap_total_pages();
> @@ -1559,6 +1572,37 @@ bool zswap_store(struct folio *folio)
>         return ret;
>  }
>
> +enum zswap_range_state zswap_probe_range(swp_entry_t swp,
> +                                        unsigned int nr_pages)
> +{
> +       unsigned int type =3D swp_type(swp);
> +       pgoff_t offset =3D swp_offset(swp);
> +       bool present =3D false, missing =3D false;
> +       unsigned int i;
> +
> +       /*
> +        * This is an advisory, lockless snapshot for common swapin admis=
sion.
> +        * Callers must recheck before depending on an all-zswap range fo=
r IO:
> +        * concurrent writeback or invalidation can change the backend st=
ate.
> +        */
> +       if (zswap_never_enabled())
> +               return ZSWAP_RANGE_NEVER_ENABLED;
> +
> +       for (i =3D 0; i < nr_pages; i++) {
> +               struct xarray *tree =3D swap_zswap_tree(swp_entry(type, o=
ffset + i));
> +
> +               if (xa_load(tree, offset + i))
> +                       present =3D true;
> +               else
> +                       missing =3D true;
> +
> +               if (present && missing)
> +                       return ZSWAP_RANGE_MIXED;
> +       }

Can we use xas_load() to make this check more efficient? IIUC,
xa_load() walks the tree every time.

(We used to use a bitmap here back in frontswap days. Good times....)

