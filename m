Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1975FCD0A1
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 03:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB076B00DA; Tue, 17 Mar 2026 23:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2176B00DB; Tue, 17 Mar 2026 23:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8DA6B00DC; Tue, 17 Mar 2026 23:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9F26B00DA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:30:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD9E21404ED
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:30:54 +0000 (UTC)
X-FDA: 84557757228.03.5EA2D52
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id C120540009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:30:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C8E/ki9/";
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773804652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5SCah/fhL34m9rfez4mGAE7+9jp8zf1TNTywaWKmN4=;
	b=Alax2z27RZWhHYmExCpygHwOVzCyyo3v12QfoiXqDginq0NhGuRuJVZ/sm7mDmmCUepWIs
	gZ7r2RvfybZCyi2zfuq5lgYVopuQYUw2qcAoc0nW3D4uIzxISeJCb3bMvvQ1q3gqP8sHbl
	Ss5Ak8doo5oFwq+h0y1ZHkTMr9iO30E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773804652; a=rsa-sha256;
	cv=pass;
	b=3SDtrEHJIIkuZMuEko5+Jr5L04zr+bC89nxCXz3DfT85LKoCm2CBp8nfkW0Jodepx/WHPx
	eEPtHmEA+Zgjd3S0VpQHZZJmylgIUp67BMinPCjo5eqypkq4tqPY9LEFfS1DrSoaU1LLMD
	NzrRa9RuCudCcYYymJ6AmGpMH7WtJNg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C8E/ki9/";
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9358bc9c50so803010966b.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:30:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773804651; cv=none;
        d=google.com; s=arc-20240605;
        b=H61zK3R3yDUjVKazjd+psvvVO+BCbEvA2vJ7H+MbPD4/o2gSe6KytfYOPZqwnYbwMs
         9aDeSYpHBo7NOj55+K9JC0s7BC/FB0P9ZWTKgYhxftQ3YS4LNSvOUVfS4Xv0VzkomkW6
         uJdVhRfKd4P8n1R3eSMEpXRtoEEuVw600Q6tUq4uEiNSt8AAbTexVAHAGrvjKEh9e1Ll
         dwn3PiEdVPaKtHyzCE4peZyKbHoaDfl/9J4v0pOXzRlVim9PjoMfiE+wsakConFuojBL
         aEnzuxVSp+3JhQwCoyrgYfhfdXqjNVxAvwC7HA1sJDccWb5Fk58/9ao0pglbmya1ImpW
         ouRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i5SCah/fhL34m9rfez4mGAE7+9jp8zf1TNTywaWKmN4=;
        fh=acbwdqcRWs3GtGNna6oGtkNVU/0UHSn7+hdk6PlJNdE=;
        b=gLATpnwUIuirxzldGLGLicyj2qDkd3DCBxgtmDWbY9GMQfK9EwHckNYCluqHvXaWVy
         f54xXvBbXH6A047VM/PTdNwygo4CV2jFOcIR3RlKTpypd434azGFtIcNlJWEydYcPYq+
         ZpTECqbto09eyfdo5XajvhCZ6ITEYoBT3hpelCqiKkqM3mXKvJVN/h+SCv48teSbX0kJ
         YMRaP/eNloH+jT4gz68tdz2sNj1kD/331XqgTkZ0OIOnCkCEZ2gcykFOUsQomyf5DN5/
         x7KzR9c5aPr9fQ8TN9+KDSTrqhVjhnVHdVxp0Jpe6hmIVSyUSWqx/3iJbAUIakj4hamr
         wBGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773804651; x=1774409451; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5SCah/fhL34m9rfez4mGAE7+9jp8zf1TNTywaWKmN4=;
        b=C8E/ki9/Mx30Mr73BjS1U8vfuJi5XejWFp+T0eHh1P5vMLP1GCuc/Q/EeCDBD6+bh7
         iW/kowG7KEAGxsx4dcx0zNjEWZVZ4KOEZpjnUbYYBtB80mFRQDtay4o4Qw9/jGIWrhcu
         kKt9jvy8YeJD5cW70DZZCKymiCfs7M+fBCvdSxqvETG3zynAFf7FaT74lQjO3wuzCY3A
         UNNDWKVcDRrbpoD7fcu33QnBjVTagpI/d6q5oodW4nBg6ZNwN1yFhuPWgr9nCw6TjJfB
         XCkKF8gj3Q2KMAhtU/gljgkLCKEUaLxTZrEYaXQo4zhlhWhWBd+6sqd0f8QS3J4LTjdI
         0zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773804651; x=1774409451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i5SCah/fhL34m9rfez4mGAE7+9jp8zf1TNTywaWKmN4=;
        b=b0+GWtDPtN1UXhFWvSXSRWnsIPiyseZUsYBpR4LJbC/VChd8B3qGbSUe+Hmo6+Po+Q
         4Gzev/UzUrfcsVo51WaYTMRGhiQzyFnI1LmYRK9mKosOjuzmWevTYfXCkRnZvrYDpyl+
         iEX3DOiCY2DNQ+8VMr5IFXeZUZI7QPr95VtJY+bp4t4OgYOWXsLBghCwqGQYI4hqy/6t
         3JSX0FyVGv3ASmMLOFwfSUbi8D0m8YY4tQK0khlyH1OsaitB13lrTCXIHOLzuec1mSqs
         rSlSwG8nznQUUYXiOX9ITxs4L0sqE4NcMONSwI2Wr6bRdELG+suiWsYDUndNIZJToA6m
         IyXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlJDNo3jKyqyQsgUCKAho8gT6epeIWEuVunmr1SLJQd6sXe19mrGTS0Hi2VG0JkeTGmYgD4lnuxA==@kvack.org
X-Gm-Message-State: AOJu0YyL1kKT8KHmiEuygKb6RoWGvOcoucaFRbyR87m0swDxetgyCb8c
	ZA2Iw6q+AiViB0N71l2O7kMuTwkvx4x6c2yVMH0pRhkWB+KucnoEv2u8jrI/T+9OD/v2z43juN8
	KfmZCqpXG2XddHwF6o0ikfZIUsVe7oeo=
X-Gm-Gg: ATEYQzwAQaiORcczQ1wtFx9Keijr8SS/kFm1thR6xJsYS9HiTuORNT/kueTf3++Aggx
	ezGHL2eaZz84co3Su1a1vY81FgJP0LxIstaIOThav4z61XUf4+On8Sq6AUfcgCMxAQlN5VZiaHH
	HqWqL4VjUBebsVkdOJAcNPivHq0DAfFrzcR57mcXNjA1Ro+9HfOWRAztZ0vwfvzRLZvaU1PXRyZ
	OJGcqEM6KY2Cql8D72/B9LmLPXaKDvWDtJ7jRh4+ufkdjksmoDuMbpCxtSGjbxFbtJGoSwE2ygo
	SiTYK2FIFRVKhBlrF3YsENixjeePyExUGxxFVEc=
X-Received: by 2002:a17:907:c03:b0:b97:89ac:9e72 with SMTP id
 a640c23a62f3a-b97f49c8194mr106141666b.45.1773804650723; Tue, 17 Mar 2026
 20:30:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321@gmail.com> <20260316-b4-switch-mglru-v2-v3-2-c846ce9a2321@gmail.com>
In-Reply-To: <20260316-b4-switch-mglru-v2-v3-2-c846ce9a2321@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 18 Mar 2026 11:30:14 +0800
X-Gm-Features: AaiRm51gSpfwUoV9eQTgAPO3dac8kI5Ia9a1Vtr-RUZ4egYrdzSm9JozL5z1PqQ
Message-ID: <CAMgjq7ACdzXbte3ESz4MDAnBExop_zFvCi4PXwQXRPD8dvnmtQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/mglru: maintain workingset refault context
 across state transitions
To: lenohou@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Bingfang Guo <bfguo@icloud.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C120540009
X-Stat-Signature: rxou76jekt9owk1u8e8i5w515wwpnhqr
X-Rspam-User: 
X-HE-Tag: 1773804652-69281
X-HE-Meta: U2FsdGVkX19MLefiXG0HGPKsXyIYyr/vqxCZBe4Prn/8n5ORRWTk/oVJNjPha/ItTusyJ2YSyIqufEpb3XIVWzDC6nSx/JBxQquouk8XbRzRcnZyBUoPLi5640xac7kDOSpA3hBoe/bTF8EedklWkmlwCZR2PitWRT8OXH8M0qo1586k+iBV3YsonyTir34gvx3/fscejLdZzHGlLBD0mLG749vgMqPqVlTx3/5BJvcVLCRVCauwRFW+SJsdfWF/7fyepXZnXz18QyWphkuHrgQJQCooPZXgh4ZILqLJ77ahNkLXkn3yrlsSb2pFms8494Hfe35tX6pqYq8v2/B8/rAv7QmIfifKzpUhLQoMyBdQVPBPfAqIbHrViYUcf5H79n2hQUPKCa8bHZgxp9lxQMUVhgbotrfKmNQrJg/ky3wd5cURGjggZ/acpesTzg27f63C5CbTrLO3PGxKTA0gwNgw/eotAJ7N9h3HICpT5adtGXJnVWcZWuE/PuOeI5CBPVdmJw6BLSEDbG6uHSzWrWyIPgYEGVWi6t9EqZyX0Gw6+9avv8uuZin6XVw/fUIL97xV6HPPKk/8hTTsSTj4H9t7+vnkkx5sc8zhy0W9WuyHnVkf/wZatByd0iJkyRVofRVtS1nclNTvh46YObT+v1C2fKM6JAe4wHvFQWMNHctxpbcEdVjEJit8OiXxdFzPSgdO4AsW+IQ088q5pQ8038dGUjIOZ1KHKOQy4FBwjTciV2oBjIYk+WnU5hwlY3c/yvvM5WSypwu7YCfQ8n5hebF/+BGm+O+t+5skzrSYtFIGWLTl10cx7hEdodQ8jdbixbULquCHY6gT0CNDDf++hM1LO0tjWmmJnajThacXxMgGK29NBmYCpwQ9ZTL783cfVlv/9KZTSILgTqpvEPN53/TZs1uPQhU5wV65hc++At5KixfIZCtniAQOMi0Md5DUIYTfDPK1mGQNUJ/N0jt
 Mn0j1IRS
 pfe0JEOVVzx6DZPBLBiilzhGfD3JKJyu8Rhm/4Pgc0KkdMFK/R1AqS+zEXON4GZPEFuK7vWJ1Ye1C5TGIuIKu9HDB6KwXo3whEynxJ7o1PIkuMBwE6FAoTZ8Y2OzwhL95fIiDPKmNK21TawNlu8/y/TIoC0Rgw4CxdcodZUu3/adHuJbsf9bXUchgBJvcGZpYn/OOM9Bvxs5XlCbH1Vk6l2ULXHbYWuUlif+dK90uuKxEe0XAz2Zdr7jeT7KDaB6i3nenaVyG8qxKLcmSwnVGMxpxrvAVDZz/T6dDysLnIvzZdsbugLtqhZdFUMkXe2TVYtqAHNqdbOOOYxK0bjlA331AbQK904Hd+Acu1B1XZSOh/W7/xq2SeF1/CTzokiMmNkpMnrDXRG9mdsgG04ztesuib6hT5Lflu18h8R8zeJjsTf36gRyQkxOdb5qKmDvdwJC/AkX78UZc9H+KmcFQaxh7SYQi/sd+NKfN8otln7gJ2vEAgo7gcvjeihLKm8aCw5Was+bzdTTMjReh7vVr3ikGR7I1O737s87kC3xf+4kjm9OrkoMzXJsE5AbMAybc/UjG5t16T7cl4AyU28H6q1C7rldcZYYH1/FbpXm9LXC5jlJUryC0IJFu/10zFjRHLub6WWMJ5rKdh2odSglvnr2RVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 1:56=E2=80=AFPM Leno Hou via B4 Relay
<devnull+lenohou.gmail.com@kernel.org> wrote:
>
> From: Leno Hou <lenohou@gmail.com>
>
> When MGLRU state is toggled dynamically, existing shadow entries (evictio=
n
> tokens) lose their context. Traditional LRU and MGLRU handle workingset
> refaults using different logic. Without context, shadow entries
> re-activated by the "wrong" reclaim logic trigger excessive page
> activations (pgactivate) and system thrashing, as the kernel cannot
> correctly distinguish if a refaulted page was originally managed by
> MGLRU or the traditional LRU.
>
> This patch introduces shadow entry context tracking:
>
> - Encode MGLRU origin: Introduce WORKINGSET_MGLRU_SHIFT into the shadow
>   entry (eviction token) encoding. This adds an 'is_mglru' bit to shadow
>   entries, allowing the kernel to correctly identify the originating
>   reclaim logic for a page even after the global MGLRU state has been
>   toggled.

Hi Leno,

I really don't think it's a good idea to waste one bit there just for
the transition state which is rarely used. And if you switched between
MGLRU / non-MGLRU then the refault distance check is already kind of
meaning less unless we unify their logic of reactivation.

BTW I tried that sometime ago: https://lwn.net/Articles/945266/

>
> - Refault logic dispatch: Use this 'is_mglru' bit in workingset_refault()
>   and workingset_test_recent() to dispatch refault events to the correct
>   handler (lru_gen_refault vs. traditional workingset refault).

Hmm, restoring the folio ref count in MGLRU is not the same thing as
reactivation or restoring the workingset flag in non-MGLRU case, and
not really comparable. Not sure this will be helpful.

Maybe for now we just igore this part, shadow is just a hint after
all, switch the LRU at runtime is already a huge performance impact
factor and not recommend, that the shadow part is trivial compared to
that.

