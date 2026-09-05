Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A399CC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 13:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98ED36B0088; Sat,  5 Sep 2026 09:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F806B008A; Sat,  5 Sep 2026 09:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F036B008C; Sat,  5 Sep 2026 09:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0DD6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:16:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F10951A033D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:16:03 +0000 (UTC)
X-FDA: 85179756606.07.ACA3173
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 00046A0004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:16:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bv7+ovCM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788614162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIDLuR2kbCh+tksJuAQN8RIab7rU28NTAOGf9YHRpSo=;
	b=uyuMpLKXQqeH0ZSrCdp2+lcw8/i7kMYjFfGo700W2T6OnSUmEH0ljSSH8aXMzuqv00ZGml
	Cfwqgm5YoWp+35yoY7KwgGQFNbvyQEF/80ms0uhN6SAN+50EKhvRoK/VCTTgseITuaIz0W
	wMr1KW7lYTjB8otsJ8KkhQKwHhhUL3Y=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788614162;
	b=37lSOU0ZpyoSss2LxmyWcgqOOqJ21nm3lDj9BjFlexLbFYK6KWBbjz23SE38/b10kLiEr4
	hWZZeKM3Gi4cdudTgn3m4T84srN2NzEjCCJxBY7891CCIFzK9Wn3V9m3d2yjtiuZlLZBbs
	g3AF82CSeld4/eUWi3ctLzljpOkxwfY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bv7+ovCM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3a305310ddaso19656091fa.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 06:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788614160; cv=none;
        d=google.com; s=arc-20260327;
        b=fwfwkTW6rWWxpWbRiS9oI4lVdMcy8nqvud+FJ0ftVmP5/03QX2LjV1+i7IjZYHIo7+
         x7UhrPCxEjB+kHv3XQcx+e0mdfSuIgc0vTOgVD72ZMwBQYW774NxivbM+Yl6Ig+k6ufv
         QMYI8g+WHgjoB9nWxjKh4uSg5Av2nQ+pbB3GcFYYW7HOBaNggj9r7s1DCEYRhw28DrUq
         4LxggEZqHD4MJIEsCgViStJZ9oGRtHLVFyo5KrLn8UHXxKExr5upz4PmiFagpC5yY8BS
         ud+NbVC8lSy+SA6rShJGhNdtGFzmFaeKUjSc18r1apRGOZ1Qoe5eeeF4WJ8TSiRXXT2w
         DUsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BIDLuR2kbCh+tksJuAQN8RIab7rU28NTAOGf9YHRpSo=;
        fh=7C1EjVLkaHE2rxOifubOp+gfyYTMr4m6eYAahTFeCXA=;
        b=bIuosm5fLaJQVG6CDHI2Tt7GxHNs9dUKjpvxJ7wiIGvvpLwSK72wwSDyxgssdPUfMj
         2w2sFoU+hgwgM739925fdNx7tvN8zOghFZz+AYt5HmeNtY/ejM9qXdahFpwieHoZ+KZn
         xKmLAgKcTivUcwEaUp7hx5q6A7MWElWAUjg3N7XNNkRxyWGnxHDBinKQ8wo155GA8ydH
         XKuE4DhNAOBangqV6Sm3nQqZwvxA1q5sEZ1TFe1Nv9LPYhyYoDX5VDoVDIk7ab2lB8lp
         OOsdOdpvNm7Sd9heov03j28XE1VsE2TUuFxvaBCVqU4w8tL4JwVWPG3MWkB0It4Upbm9
         1b1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788614160; x=1789218960; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BIDLuR2kbCh+tksJuAQN8RIab7rU28NTAOGf9YHRpSo=;
        b=bv7+ovCMWPKrPIuNu6kgZ5y3VF8BJpNoX0goSWr88UlLfFTfOgOAmb1ih3WUPoGLNA
         /C5kKGzaopkxa9ZLiH28ZZtIjVtzfI90WSCBAPfuf+DCm20X7TLt02n/hmGN67P8DbQq
         c4zpUxhT1vUWbBZ2MpVWM0QbxIH10knyOM4THCx72cis1GaBUdRImjYlJqxEzjEyoKYm
         su/hclx5JsMYHrkCNGZkXAE4FVaO42X3NBs8i/y+WQrHmqHag3I5JAz1OSBr0Qp5M3o1
         xe3wfZ8pOZbQXhhQC4rrlLgi2JU/rYtZAGhkQsMk64wCU3vIx6hRoX3G+MTjXkcyKTY8
         gTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788614160; x=1789218960;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIDLuR2kbCh+tksJuAQN8RIab7rU28NTAOGf9YHRpSo=;
        b=T4H8GVJ+gxMXLCr3Zz/zTL+Qm0JocstzZvRAy6bc7qVFNCZymEx3PZ3nwIlWTrlSGI
         ZY1ZsnuqnwjcEtd9UKl0vOr+R4v3aJrbFJAqsMuBy05DFtomVG+xFtZFo21qEj6Ueqs1
         6OImshBgTgdqPuySedDRPdWv8ON+Wukc+a3YbapXtS+0QePv9W3IomiZ+Uueubmp8zGM
         +BEn1ZU7aOQs1qK57Oh7hnqYHHoNJhfDXuMEPd8HKqkGtPnSzUOHD9SKFJVyuClkHNc9
         hD8XY1vYotuXGMxJDQ2IxcKei3RwNLkhYGwQwZXtjrygPamvNu/vtqTnl6k9P4FFSW//
         /MTg==
X-Forwarded-Encrypted: i=1; AKwUvBxa3cJSy3syQt44SjHZy+NwVWfVa/vPoaNKt9XxjAzoDyOPEGdtksfspA8sj1TEmlA4CwS42YaCPg==@kvack.org
X-Gm-Message-State: AFuF++lr/03MKoq4/xYLIfs1JiL14BWcGiRcb/O4Jsgp/Ze4+z5ba3lA
	RAGwkBvNyYSEDmd+PTJKzfMFBDm3JEl6dQzl1Oar9chGFBxRXGVaZs8Bcal5Ztr2dAgfJegYBSS
	ganFdOtu1qckqfeNSdGOsLhunv/kKZ3A=
X-Gm-Gg: AYBFou0dM2ABmCnpz/xx9vQymfO6pKfAN8uRlkeUMu1IbCafUADsj4YyrOVbfi/7wqn
	5aQfBTW+GNvmTDDrrSxw7thwvTCgDC1D0iXdSx/6/3FMx5sohe6p+juxwvLo/xmmslVAaDauYvL
	16narg9+Bks1PNvn19j9WqqndXWJGgmnmRDc4/VbQ76ukms1Rwz3wwGHeYa+EyE3vpY7aRXKtdU
	yMdyiAnRRLft26l4FLWoo/VsGJ7xGYbeRbAQQPJkRi2ZoBUICbDH1XvE7BL+qLoqSjz738rSfkZ
	ko4ussyGC1zrlSr6z6xWxZDIDj/B+P3dFL4UhxL7b/NFb6RXcd7VZf+VqV8yx3FxuvsmAN+LS80
	=
X-Received: by 2002:a05:651c:b10:b0:3a2:72c:cde9 with SMTP id
 38308e7fff4ca-3a371aa4067mr15568791fa.4.1788614159830; Sat, 05 Sep 2026
 06:15:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <cover.1788528216.git.wujianyue000@gmail.com>
 <22625ed4915936814f766092e9d7ac6637c5b2f4.1788528216.git.wujianyue000@gmail.com>
 <CAO9r8zMiOvhy3BZ0NjvL6Wn6e_VpVb-sZzk5bpDFuoXBHbzATA@mail.gmail.com>
In-Reply-To: <CAO9r8zMiOvhy3BZ0NjvL6Wn6e_VpVb-sZzk5bpDFuoXBHbzATA@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sat, 5 Sep 2026 21:15:44 +0800
X-Gm-Features: AcwNN1VskVyn78MOpZJIqhjd6iWsQ7_GA-bFD4pMhIW8yua49SmVA6-bbHCeXls
Message-ID: <CAJxJ_jhfJ-ZTnvXvQsKFtyKK-ScTa2HUjnSpK+sOvgtgdZ=bcQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm/zswap: replace the zswap_pools list with an
 allocating xarray
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00046A0004
X-Stat-Signature: pxdc3zjf7ep5ab7738mrico6fmjdanzw
X-Rspam-User: 
X-HE-Tag: 1788614161-175208
X-HE-Meta: U2FsdGVkX1+WBKJ2sM7rbhxiOTL00Vtz20YarfPzf2/sUREhTN6kg7nbiRS8+c7rDnNnrbNTE3uzE1stTtOn4keRGxHjXaaCeSIrmym9FHUod/2/1NQaSBPekcfkrhA9yZWWBdpKyM+RmZ2FY2onMrtscoJ/B1LEmVmwPS3jzbCLhkiSY2w4ANuzQ0sfz8yN9BfPD9ee/gvhkbILFUZfmrvFfclNe+TM/VkDesRwbk3HMEuhhmqEumzIdOwQFJIMMq3xjhgmZHPh88uJTePOsLmrScOewj53MO04fgioODMxVmEwUSiDWM5BOWt8f/BslQPemgKXl49N2vBouu2SWGMUp6VxRSD/eau4QaPyRtii4kwxN+GUQ/E8MBb56buzS4VYyRnEXEnlIMIuC2lkQvV56hh/l0NfTEWctPMqCXrg6x5rhLsmzjdCW5pAegqD8ZRhBYnSBm6D6HQIc7h4n4LGJDoaOmT4+vfmEQmbWW5Knt3OA7tkTSkNLEecrsnmotoSDA/1FJq5nL3IAiJrq7Sv98+bMLoqNmfebSRHG/blngGRcQZ4VrDn73q8qwI4gMm3KIRPUdGrWczvKZ1t/QxQYOphPXm8nwQvn+bA8KPjoH+TkPUrp5MoQ6/B2+jXjotlmzq75CzfZdBp4XD03Zev3VrUx/RZvKesOnPovOWq2N+PL4HtwEGUh8IBqt4B5QdFUMFTHMU0xgRNpTX437vyo7QbGRpygv92YREgFgD+T59rIEzek9Awo5wMtshnEycYcAm3r+Y/m7RMqIVyvezYtFQxS3zd88JbViXAYzirbazISM+Y3h1WeY+n5m0amb/tiejYOac9r8J9VEgT7zSDZwleG3PSyviDDgXfoiN4vr2nuUI6i2eX/ynFSBURikq0Up7+/Mjbt9y/Ff9f6sRW7V3oBwrkXQ1RwzGhZTQGHshIOy/eM5jVklZbZnP1DdBzzsda90E5b9E143b
 t9AA/3N1
 l9wq+f/AX7IhBSE83yPOVyicglLUsl9RCtUzOxxUSTR/VBVcJJdh0aMbF/NtnMBwvxKrfOCl9Tjgu0zDR/+gHTcWOmyBOPpnuOKGLEMqkZnGGWWBG7X2JE5t1NVV7jcue1s0dezpqUWYW5RT0dBC9aWFrM6w9Zo/wVoD4MWjIQf9NZ0ySJ0/9lH7qzhA3Gix1uGx1nl8e/DaJbu63qCc9t9Eh3Fz2xe2S7qy4LPw4GqD/dil3/36jCwlUS/eqid1p8Igc9wDRbZDanHzZlQB81CNjG1cU24gP5ussrHYtHhmUAaAicvSY/vz67qvSrrExF9Q2d9IqHsSOBR/SezYbb6gGZ+OQJ1Tbnu68b8tOzknNv7AWSXBbZ9KfjFgMw+431qim/JnEkZ+Q8+HaMOXQw2jVl7uZx9xXi6OIkITxu5jQ9PhgBkPCzYBLlu9HLefHUorG+UvhcvXv3MillGg/eSoufKTF4SPA1ycfcfGVa5OZ2yWGOl52V/57Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 5, 2026 at 12:04=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > -       list_del_rcu(&pool->list);
> > +       __xa_erase(&zswap_pools, pool->idx);
> >
> >         INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
> >         queue_rcu_work(system_percpu_wq, &pool->release_rwork);
> >
> > -       spin_unlock_bh(&zswap_pools_lock);
> > +       xa_unlock_bh(&zswap_pools);
>
> Do we need to call queue_rcu_work() under the lock? I assume not. Can
> we just call xa_erase_bh()?

Right, no need. queue_rcu_work() only touches the retiring pool's own
release_rwork. xa_erase_bh(&zswap_pools, pool->idx) is enough.

>
> Doesn't xa_for_each() already handle RCU locking?
>
> >         rcu_read_lock();
> > -       list_for_each_entry_rcu(pool, &zswap_pools, list)
> > +       xa_for_each(&zswap_pools, id, pool)
> >                 total +=3D zs_get_total_pages(pool->zs_pool);
> >         rcu_read_unlock();

xa_for_each() only takes RCU around each internal lookup, not across the
loop body, so the explicit rcu_read_lock() is still needed to keep a
concurrently retired pool alive while we dereference pool->zs_pool.

> > @@ -554,20 +584,17 @@ static int zswap_compressor_param_set(const char =
*val, const struct kernel_param
> >                 return -ENOENT;
> >         }
> >
> > -       spin_lock_bh(&zswap_pools_lock);
> > -
> > +       xa_lock_bh(&zswap_pools);
> >         pool =3D zswap_pool_find_get(s);
>
> This is the only caller of zswap_pool_find_get(), and since we remove
> list_del_rcu() below we have no reason for holding the lock here other
> than zswap_pool_find_get(). So let's move the locking inside? I am
> also not really sure if we actually need to hold the lock here anymore
> to begin with.

Agreed, and it turns out we don't need xa_lock here at all.

> > @@ -584,23 +611,17 @@ static int zswap_compressor_param_set(const char =
*val, const struct kernel_param
> >         else
> >                 ret =3D -EINVAL;
> >
> > -       spin_lock_bh(&zswap_pools_lock);
> > +       xa_lock_bh(&zswap_pools);
>
> Do we still need to hold the lock here?
>

Agreed, no need lock here. Compressor switches are serialized by the
module parameter lock, so this is the only writer of zswap_current_pool.

Thanks for the review!

Best regards,
Jianyue

