Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39326606A33C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i+ceqcdc
Received: by kanga.kvack.org (Postfix)
	id 43DE06B05B5; Fri, 20 Nov 2026 11:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415AE6B05B6; Fri, 20 Nov 2026 11:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3047D6B05B7; Fri, 20 Nov 2026 11:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F11996B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:13:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30F4D1A0FBC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:13:45 +0000 (UTC)
X-FDA: 85455993210.30.FEA9A36
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B14140011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:13:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i+ceqcdc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795191223;
	b=AU/ZIEEcw2wphyC786pMeJF6rF0wrhken58lYIznS0fM4qCrgy2ZgEKjqefoUDDXlTxyr4
	HZYJqI56KDphFyt6FkcFTleWWcpCFGxocFd81GUuad4JR/f2r67lTI163riyIfKxkj3Fa7
	Y+yulH7gyEi1TGmBcUyBs6Vs7htbjvc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795191223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWRoFimV9/d02kSLeG9kMmtSjpsU/IDUSmtfjH9hqHY=;
	b=IXMwoMi2DU/2vLzFWsM57k6XIsC9sADrrxZ9qtbAttGAjzAWMZC+033TSeiEGSaKE0Dfpc
	DI+qqLFhZ4W2KsHXxICPkk6BmHy8l1f2Vl3kia8kCq6rCCOv3t5W0fHdGEne/jhtzbcX7i
	x8gBO3/uMItvaQh8tfMMXaakrFiwUXg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i+ceqcdc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4acb44dcd7bso614276f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:13:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795191221; cv=none;
        d=google.com; s=arc-20260327;
        b=CnDdCV8AMyG4jSLJztlMUSPQCVhGwmOGrUqMB/KRLYteSfLU6j0Sn0od2eFK2fwIJX
         GJsLhLKXKWTDh4fSwG4tbRk+xsvxy0sg1a4mw5B+MFL0Slx7aWKWLNcFaM1TPlA/wY1M
         oef63jHRMuEqeR6PLc2Jhy/Mp6OJ6ZR05PZVzNJVKewKFOG+py2tJyW0VOIcG/258XL6
         QrWjgslkA70VWUnALaYPyjQZNtcq04+GgdeRK2tDQtF/0xAq83/JyC5iReXoO56JhgMl
         L3faq+vcjrGLy+6DyfFQpMM4IAQwMIpUkZC+p56R8LkcL7tx2ymX2ntGf75rdvHtyr0D
         jFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BWRoFimV9/d02kSLeG9kMmtSjpsU/IDUSmtfjH9hqHY=;
        fh=5Uqshfv9UV/9njBsrpyWNaMWYqOt8GvoRRc8qdBOleA=;
        b=OGZqm2SP7uZ/JEBYp3fJLaa3bjclNDg4foKoMlNU2ls86VZVJ9GZEMma4YZzywgPq+
         /mwoaV0CWBFJBZJPDABP2LC0kKlX/LVSZIz3RFAdKhvsMQ392p/sy1JL/eau/RCbBT1K
         lk6z6qf879om5Vcrj8vz+s9QbeW9Iu90UlMhIIxPrYmBN5ZY5WXi3fFVI2/Yu9Z/P0NX
         lAtK39XXwzDT32HSQRJYHCJWkf+H2eXPgZjlRl5b3CCCbMgXYgXAo9F43pTLxR1UmJoq
         6H6FcM07Yzh8dGP48OApHZ/6J/ILzlwXPBxKb9KaLFcP4sM3yZ8L6vgcUpUnEEpePykt
         WCBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795191221; x=1795796021; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BWRoFimV9/d02kSLeG9kMmtSjpsU/IDUSmtfjH9hqHY=;
        b=i+ceqcdc51RpXGoTQ5o5GBYey+Tyy0GBkEo901np0eTSFuwoKf/7lzleaBkSqS+MXM
         zObteMumF898hPd+w9W+5e3Ngmfh1M+0C928yCpxU3OBJhJZQ3rMVKVRZRWBVUOv6MlB
         CdK99ofazY6T1vtcMIunUM2Wp0QiPdokOnGLxcI32vqM9twhSuQtqFaqcRQbO9EHskSq
         3tq+gS9nAwmE3lFqTWGvtVlC5nAlUKg8j26JV6ILahKp4Y+lKysvEd8KBaDrv2e8jWgC
         whoz7VgjKMOOwxYcuaNfifPtyPU6yvJvgdYlhq15xAXpKgIpfidknDg6amKxxVbdk3Rb
         YsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191221; x=1795796021;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BWRoFimV9/d02kSLeG9kMmtSjpsU/IDUSmtfjH9hqHY=;
        b=1PBaZHwEzNyynBH0JBJlv/RpiohlEaCqRzaT0QFnXRB2VI8R5YhkS4NqCAQwG6WfuA
         yupgprpJJ8yLfPeKotuPrylZuwRX+O+ldNTa2JnhcwSaExkewjz4NLANn+Ro4dIuzeIk
         V7UsOYYhXCI33GvFP3/zj2Iv6QZwDudDxBQbNowKpOGztImm8QmuQW0HhCDA8TUuIuEo
         o68c+NLlC1w016Y9VzpEDuhIcLRfEmqbCcjFrszGuYaucVcCzgi0tJiTj89wkb/62Ymq
         az4APECRff8KMKh9EOdyrqcggzp6K27hRyE4TIv1chddw7cD18dVOgcFFAZWHoQuag5s
         qATA==
X-Forwarded-Encrypted: i=1; AL+hErG4v1TI19wSMFn8Gc3bpk/XdKmFP4BmppjiKwAjgIxRDGgH02ZgeK0+RY4Yh8evMlifLCmJSWxA/g==@kvack.org
X-Gm-Message-State: APuU4Z9bbr7fxXA0cVZyxVr1NIQRmWcKrUhBUgZW1EgXBzF2gmofE2LV
	v3bVRE1gOiqmaVY0N7VxohTfaB3BM/Cp+RnQlitWuWYNntJvsVbYLV2308HkYo4KG1UFPEw5+w/
	7An7qgdKp/gf1lFEDvwFEnCW9/SAnJCw=
X-Gm-Gg: AYBFou1umf4G6vqrcdds6mVgQlfftO0Z78RHWQedcZTLzq5xePVq8vZtRpUIFdQEVG6
	qWdzGAWbXt1byIwBs+yxR1HTmemDYGfwzgLik6ojkXEQCyVcBG16/q+Yh4rO4UbvNjiQoSAWWTG
	2g6cwIUdTw8Y0GAQtdX7cRyksVJEu8tuYhXF9/uD+kxqUVUs1qZ/ySzf7pOmEFBduWbAmcEh1Wr
	BdRUCGUHp4/pOP845BpXhjl6CTwf4kAHgmQqYE0Z55qoe6Wa1o/285Gr6UTWD2PpB1tjo5+swvZ
	hm9mQndm7wVEj3yT/PXVW44lejskRmV0S3JGGqAY83pkrevKfBD7E0dq93j/G/K/ayFFzqd2oKP
	1p/IXjU3PgSBnAsKTjMRghNRPotQ9KDczERv5Wnglr86dVP7ppmWOxKYawVX3ggs7DYbxgM3DDZ
	humOC8hC9wyUsyGTixKU0=
X-Received: by 2002:a05:600c:820e:b0:4b4:262b:88a2 with SMTP id
 5b1f17b1804b1-4bb887c9f5cmr90227095e9.1.1795191220930; Fri, 20 Nov 2026
 08:13:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114200803.23129-1-baohua@kernel.org> <20261114200803.23129-8-baohua@kernel.org>
In-Reply-To: <20261114200803.23129-8-baohua@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 21 Nov 2026 00:13:29 +0800
X-Gm-Features: Aa3M54qyqMhmK0d32Ed8NiqligUKBKS04r1CMK7vs2xYjZPQQ_emX3mKSTW2UBo
Message-ID: <CAN_Opa86-KD+Ct1Rq10q6i46XXxVm96z0VbcS+a8pOX-P5gC8Q@mail.gmail.com>
Subject: Re: [PATCH v9 07/16] mm/mglru: balance anon and file scan budget by
 refault rate
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, liam@infradead.org, 
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B14140011
X-Stat-Signature: q85raj6uirrdw9jtpbz7hmmj4m5mi3ct
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795191222-561588
X-HE-Meta: U2FsdGVkX199pemocIvjNwlay0pkFgwROZxCe6iy4PHJmYsXnlv4KEAzRsTNLqpo7IRfUCriSXBYeCRCSLb99Wcr9Uv1V+0uO1ZYqhTWEz/82MnQDd6BDA8NpRghe7Cv59/zyaPFvsSJXfHyIn48V/BBM/AMmhWYR3JEhRguCNoKlMa+WL2Bq2L8OX0rtgfaFwWKtfLNfa+xZ9Rbd9dzpaktk2ZyHOivpqeNSZsN3kv/Cztat6XQc/p3mF3JZyOYu0r1fht23LLnVQ20pddVQqGQEeR88x+NT6Hl/crsnDcc8Ftzv38uVVO9kgf0R5cRNfAArPwtmyFRlBWEc18D0LMWnWzK2WJdRrDdHMZ50dqLbLOrRMiWp1XfxeZ0sztg1Sj1vQO9Tsiqd/esmbj7noVKMmQcnNYBjQByH4EimJIeVzkeAH28UXNBx3oX6y2u75uy68zXjzWoUFOjpe6pv3y7+D/QggoZ+Him9o4ogtI97ko0bZjIa6KIlr+LxhXqMqYAOnnk7Ge65Ue89dmOn3JDTkp6C5SrBvhEsJ8MqQI38Ckz30SO7B36n/MM6ZaqJ1Piq+E3Fvmq3nVcGQf58sLCl/HViYvI1K/9WRH4+bfi9ihEAZmWbAxCmn9TnX4bVmkitRZCJ/2NFJcbI8nLm6yPIVlnAuEHksdTNmXxuCEhA78ZLHn1SnbcPx93pQ2lqVaL6Xs3DO30OCssuvrIFGTrW5R7jpd/SbjoWWQM6GbNugVrYWqmkkoGMzAEWUtL9ZlSAscpUlQtUjcOHQeOlbe/U/1WnQpENAXPmXJAqyVg2Wi8FC4tXduBxzrmuvdLmd/D1vBSPOeOWxD10gXG98WN88i0eNVwRx1xeH5EFZWyLgWOxApTWIRJeUNnRF9pCKudW0PosFVVjMCFKsB1/PiZ6LOtIUL39PDrGI/Xeyzd6LuXgWnnK3NBBanV++eFAtrHM8jJBUwqrHZHeGG
 MRevfzdM
 6DzIbC4/k2ddqzJIEkJCDXkAA47/I4/Ui3evKO8x6AhxUrXopARpS1RR1Gag/dqQXvDC/ktVtyQhg7NZPnRyfiMJxbz/g1UQ6+qr/V4f9d2daMB5LdoopXJownnDJa/nTgNm5wdc/R68HapKByvnv+S0dogNM4uCvn0z3bgErOg731FOWFA/7dvFuC/GN+dj1oVqE/+zTY+dFN1YvzwueniIgtq4uvU5oS9wRs5xoQF0yt7pEtYQ1wg3/PFDgna28fyNOCJVzoJ61PK+C1t1T5TwxFxysfB0lYBnhoKS52dqcE+86+F/u9Ot3h2xReRicWfnKxiKi1XDpdPdO3qX/32GUZ7Wfwg6YBG3W9NmPDVH3h9KM2r0xznynLzHrIpThMLvBofaExS3gweCEvAl5Sb57LhkrQHAZNrfqqMzurHb8Q9c84J/yJYGIx4Y9izsv3HJL9ZERHKHNklsF2gRs76MKBfaJOI+HHPqNqhL7qa7U6oem+2eMf1xrkpEtfG8asB3ZprtZfZwuRP+p9sXRdghzjgvfkbP1pkacJexRNIOTtwDUyUO9Rh/vFUFXSm5vHSBmXsZn7US5ZmQE8sdmU/sxB64C3qIMgE/nNX70JjRTWspv7+trm587D6+RtwhQ7dScIGV6l/d3MmhpvPY9K8K//OAAWx1aSZ4SowJKCzfgL+eACyQAKwdOAQAniTMeOzkU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[...]

> @@ -5769,8 +5822,8 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
>  static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
>                         int swappiness, unsigned long nr_to_reclaim)
>  {
> -       int nr_batch;
>         DEFINE_MAX_SEQ(lruvec);
> +       unsigned long nr_to_scan[ANON_AND_FILE];
>
>         if (seq + MIN_NR_GENS > max_seq)
>                 return -EINVAL;
> @@ -5786,8 +5839,11 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
>                 if (sc->nr_reclaimed >= nr_to_reclaim)
>                         return 0;
>
> -               nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
> -               if (!evict_folios(nr_batch, lruvec, sc, swappiness))
> +               lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +               lru_gen_balance_scan(lruvec, swappiness,
> +                                    nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
> +

When nr_to_reclaim is omitted, the first split here uses ULONG_MAX.
At swappiness=200, the excess anon budget goes to file, so we can
scan file in the first round even with plenty of cold anon left.
Is that what we want for the unlimited case?

Thanks,
Kunwu

> +               if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
>                         return 0;
>
>                 cond_resched();
> @@ -5850,6 +5906,7 @@ static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
>                 .may_writepage = true,
>                 .may_unmap = true,
>                 .may_swap = true,
> +               .priority = DEF_PRIORITY,
>                 .reclaim_idx = MAX_NR_ZONES - 1,
>                 .gfp_mask = GFP_KERNEL,
>                 .proactive = true,
> --
> 2.39.3 (Apple Git-146)
>

