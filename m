Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06382606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VHONlfEP
Received: by kanga.kvack.org (Postfix)
	id DD97C6B00EF; Wed, 28 Oct 2026 14:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1406B05B1; Wed, 28 Oct 2026 14:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC84D6B05B2; Wed, 28 Oct 2026 14:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A05406B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:47:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 830531C270F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:47:29 +0000 (UTC)
X-FDA: 85372918218.02.5C9ECCA
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 99B4E40008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:47:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VHONlfEP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MY1Ku2+QfFQ/w+5DBXT4XGQW5hbU1oOryqCY+B4XiPA=;
	b=R9nguJ6J/oGXVAbDycGYSWpD6PQY035Ez0/MB4AxP8ZG+EhLw1U0z6AA9CbKaWsI2BP3re
	8lo69eb4ccnI66b7MLWIabG9156sWUfDBm1IHTijITy8EhtHTjcoR4/OqBkoWmttdc5fUU
	XLpK97BnUkxR7b655Bg5ViU+Gr9aRKI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VHONlfEP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793213247;
	b=sWnKvUWUHCJR2bBRmds092quqZLvONdusGFRSm6peLJ0TalYAbpUputbj0QDmo0L0Z6iRY
	S//XheDQvzcFgA/aj+OgAosN1L/boT4+pi5fmbi9KXZ4jpbXJFKdV/BZlmEG3ke0YXpYPW
	QAiZSZsGvSLbgNV9Kmo3umkWaMdLENk=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e47347279so1019342f8f.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793213246; cv=none;
        d=google.com; s=arc-20260327;
        b=Dqcs9VN7aZg82iTus6+YqFVzSoli8YWEa/Nw3DOEbY0tTR91pAyaX6QqkDUmRguPdZ
         v7uJRGCNe+b8CIbsdhldgr7AqeBre2/qeQwB3JYweRpfVSTdoxgEUn4ZGzNSIdxxoWvT
         wOMWNIyGGaRou1rFM/RAsmXGzuytYcWuMpesU6utnidNU+d/eZ3MDa5c3XF+EKpHQKpZ
         Uo3TCgnho6nXs3NUBmnLNA4ALIC6xb9hvaNOHR+Ux1Dn2E5i7x8YZpx1ZImPRPSE4yEz
         HFsJOCDU5qGNVOK/Z/y7OFlPodtQorjEs9dbob4CV0giK4/UWiCQbtr6fwGDXTgLNgIJ
         jQkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MY1Ku2+QfFQ/w+5DBXT4XGQW5hbU1oOryqCY+B4XiPA=;
        fh=yK3y3IWlb/EM9TWJ/nRAJ6JL1N0GTrHGdu+GZmn8Pjg=;
        b=soX+L2cRyUmMC0uZdBtm3tn0y4hzIfqRU4pbqk+p9W1W2gx/vmHWskozuG7DUt4/Xp
         t3jy/x0lkweAMGpT3+RsaX6gpBedeJ/HfqH59Q979OBWoB3hp1Av3K8gk8t1NOkgcTnS
         a4xxgw72UzP1Df1GSFUM9iHzkaT+iYHMMKBtuQhJRpfDcEVHU+iKphASnyYdiM9p5EX+
         NvXgBeb9/Dq2Fk3UnJ5A6ykvyQp42+YaAu5AzhFExnArcReQIiL2IHwprTex4AnnWpgI
         TcDJgzooJ1YszlF3b9+bdUAL/jVlVLY63P1BqcCU+C/mnDVeM5dbEwJ1bSSHhnCfWhWw
         Gqyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793213246; x=1793818046; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MY1Ku2+QfFQ/w+5DBXT4XGQW5hbU1oOryqCY+B4XiPA=;
        b=VHONlfEPg1IGcy1hU+Dv/22v85mMUWf18z0/RU7KDltyTcrCcV4nmhnXFVltYXoOqd
         EBJGe0JnxZ+xCoAYX+Ffswg2s32j4HpFNxm6UF4t6P37PKPc/5ewie3/nA8HxH9Oz7NO
         3WIGt/6oswQvK7iVSVDvcrFPXf1JY/MD2Wn6Hcr6rTBzhnSdAd94haFQtUHs8mKG2AnL
         vH50HGHrgmSoek747ykFKO7uMRJFiKDz7zLW3Nnr77XjJPxxh82VqyRAe/bgK3zbkz78
         EIbZY0jjluvf+UEExdv5YWlTRgCOSO26fCvLI982K9JHG2AxfvI6GwGb42YWv5sqyg68
         BmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213246; x=1793818046;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MY1Ku2+QfFQ/w+5DBXT4XGQW5hbU1oOryqCY+B4XiPA=;
        b=IDUu7iAycb3RiUyiNAFdR5cceXEmnrKCHx+YyO0LfmT7HQ2BENjKK/SE9r2tH09oHy
         sZ5Ka6QcwHwRlyCTrr65s1hNGxf2RH6fjaSCv3uB2IchLJkthPRf8wviQ+JlyiKYyY5o
         ewutvJBpsjSNcX64V6w7EsbL8MFgBmXJ5wTVXJA0+15ksE6iMiJrb5pPLzwZWbAwT+G9
         z1lqUNRjSj3jm4fXJuVKzlcQi+SpAzmXMQUu/kIsxwa6Qhe+jXtlB8sjirddCvpU/7FH
         /+5u5TUCUeqGQMSTCR4l6y9oMLWgCCCKI3flfIpiXBnQNhey7PtVtXohuUFXZ8CdS5Ob
         EvWw==
X-Forwarded-Encrypted: i=1; AKwUvBxbGvxoAjGkt6UMFcDIXeFFDle74LKWX6sMoIIjjZtspmlaXIR2Qf0J+4fi/MKG91ZeiIMqMgwKuQ==@kvack.org
X-Gm-Message-State: AFq9FYL1fJ8Uzre9GX40joylLZyDoVZRjxk2rgcH8fOXKrmdv7jiEeCm
	MyfZtxACTZm5r5F17h/DHO49HuVij+qPDxv6AMvJMsfDgYPjR8Avvirk9/B5fu9wQuKysLTLdlC
	G+y3JlihNWV7iV+KSl81J1kwcABrO+eU=
X-Gm-Gg: AYBFou0FMdyF30YgHI8e+0Jox/09tSmdeheux+sSbMuLYJ71wIYwjhIGUC2InIgGLMc
	5//pYvqeKmNhIDlNQMIYScHX2Kb2zDyfBwREa0N2pdCHeACrmxxGfhJl4hjfVi3VQ2oWTyWyJeT
	EMjYRLUJWiH8fNe9nlaMu0/uJwJGvkXGEigpzm+7ZFZQhpCfPCO1kk7RLwfOQ2BOeOnQcbpFcZP
	ZL5KaZ9ZdZsVgJQl+U2wKOwQ+EeD0mt+PGt8aoh6VDgUPmv2BR1Bm9HIQWNnxjkUoUtOQWrqRq6
	ngOM9d/0qkyGrVBNRmTfym49rpGNQMepF617nM8NQHPQsWHzwVF3ViEamVqjUOuDACH/Uima7zQ
	i41O/ar3Bs13PZp9q2YNOMhSmrDS3wGUC2RS1SUxGnJIkYEwRMRanOSUffU6fZFaalzbHLwqw2x
	pCJuP4s4Ztof0IzJk2yvBI9C5KCPwjBuLdFNHW1h6m9inkL1384khP
X-Received: by 2002:a5d:5e08:0:b0:48e:460a:bb83 with SMTP id
 ffacd0b85a97d-48e5d5e55d1mr7015815f8f.53.1793213246056; Wed, 28 Oct 2026
 11:47:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
In-Reply-To: <20261028113619.38752-1-kaitao.cheng@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 28 Oct 2026 11:47:15 -0700
X-Gm-Features: AclHuK9AOn8SOZMNtF_LnCI6V3qWWsFm35NjDDUBYkIPrJA0RAhqgLPZ_tqYx2M
Message-ID: <CAKEwX=NfFNbBwhvNpYz8iWgimFuOow8J8x1SzV_6GcC_bb=Etg@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on writeback
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 99B4E40008
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4iq6ihorkmngkkwm84fwgmjoie79nksh
X-HE-Tag: 1793213247-879508
X-HE-Meta: U2FsdGVkX19NjdCJSnxJyjR5dyur9XqSn5Uf8GhXby4hR+Lor4OEVrPhVMwrQhtrh8ifMheIJuJ7Kr3zJ765B3oIuiWFUrfTVVHTsYHvgs6mn9sYs92jiJy5eEsrB461tzkWvi+1xuD0R2O1OHfjWpDeQzBrH1xuXWrWBieW0Ve0J2u3YrSyBikwVb8c/whsC664LAPg8qWegBO9kiwnYIWcZu59+drSSgKAZmOWHsQH9d4h4eFsnMpJ2D4NTCfmLfFbh9gj1utmMcnZy4mAR4/vAvIhVtUCTkHpG2/imWSl8/9ANf87b8ee14+fvj8dMTdDpL0fWa5oFzojEfj0/G4ftvIlxR+bWkA9/oKIeaecVaH0cG8KtvXHdxmjJphSBAJHj1hzqB1kN4zahjiJQmi7kio7WD98xqVPWIc0qXubnJlK8xSP5Fe83fbdNCt0ICzYscBuAj09t1M9hbuNoFNt4IM/O6O6+8dtHWH1LWo2A3D54EBlu8yogbNxQ3hA0vMuAYVtG30Xx3LSjYhw0sg7HYhGc2QoP4apTU626vhzQbAtjR2Ow1A8OeK/Jiyu4gglsPO1VxOXI/lPSgGkJP9pBdXZ8ADJJuB1kGFAZtnyeei32UgwjG132VFkDWUh3Qw3kW5dB3rbDi+QAH4/m8/Hz5EddPKxdoI2PsUPzb1NilD/Akn7PZd3KUTTc5XOlKyWKiJI/nwFxFwx9b/q3TFzTxeRbVZgyiFfj8WNSiuV/A2rb/dX+q+tIIaM72bKfs/THpdQ1KP3goGQ9ilHCLLEsw9JAvPbHVqMXsWNwZaHCIZUfjLgLDjwdSIV+0hMWkzPn69sWsD9pgdfYIdhv2O0at8Yv+B+6/mDgc8i16viMXsGbbuoQlupdh9KGzv8g9tFi0xBURYb8I5edDv9mY3uPyxWrF0Wl2RsyyXckTROd0MhGC+jAE8GKU4GUvcsGf5xi4zhSFMSMQuqoTX
 4WyT7rGN
 fMn/8K4yQ0Um8Ux1uDu9JFvf5ctaORIvGbDSVWeQFZ4ZOcKVR8R4C8t0Zk218YdvUi7qpNEN7PYlrtGiFpxnmIYNoPufoTYIA6FLbmo25Qb0nMw8/erVaR9HSij2keMuBmP9HP+BKhv2AtbkxxgJv3RobZjQCGHrkiZSTfRXZsGYlrMjMncaQOZHEOd82rJkSb93zUqW+tJBLnxPtm5NRxscrQ7ngFXdTqX4TQH/qdWbwBAP+oc+aOTMmNRHlO/vqMCkwYiMq3ndsAxTS1oTMWpOlBFsszp/ltwE5Lg+ymtXn+Vxlx9e2oAdytwGemxbAuAxhCW32NF3kNTrQJYRfDs7cbsW/xVxVjNBXaam9njTlCAR15kKE+kFaJoNaT1m6jb3UBDGQaY6ON+m851ofEOKqlFjwWW+uT1arn714iyWrfrF+J6rpI7hlpQIo7dkN5gjHp6/Jaam7cZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 4:36=E2=80=AFAM Kaitao Cheng <kaitao.cheng@linux.de=
v> wrote:
>
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> Successful writeback calls zswap_entry_free(), which removes the entry
> from the LRU and decrements both the sublist and node item counts.
> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
> to decrement the node count again.
>
> The affected call path before this change is:
>
>   __list_lru_walk_one()
>     shrink_memcg_cb()
>       zswap_writeback_entry()
>         zswap_entry_free()
>           zswap_lru_del()
>             list_lru_del()
>               __list_lru_del()
>                 atomic_long_dec()  /* first node count decrement */
>       return LRU_REMOVED_RETRY
>     atomic_long_dec()              /* second node count decrement */
>
> Add zswap_lru_del_nocnt() to remove the entry and update only the sublist
> count, leaving node accounting to the walker. Split data cleanup into
> __zswap_entry_free() so writeback can free the entry without performing
> another LRU deletion. Other free paths retain their existing accounting.

What is the visible effect? Is there any effect, be it in reclaim
dynamics or userspace counters? Can you add it to the changelog?

I'm not against fixing it, but need to gauge the effect for
prioritization, whether to cc stable etc. etc.


>
> Fixes: 5878303c5353 ("mm/zswap: fix race between lru writeback and swapof=
f")
> Link: https://sashiko.dev/#/bug/linux-68d2ca49-23be-4504-9a75-b8526ec9238=
8
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

