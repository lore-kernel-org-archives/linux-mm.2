Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62780C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 09:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418096B008A; Sun,  6 Sep 2026 05:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8FD6B008C; Sun,  6 Sep 2026 05:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE946B0092; Sun,  6 Sep 2026 05:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AEB86B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:09:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9A101C20A3
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:09:41 +0000 (UTC)
X-FDA: 85182764562.04.9F047E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22B80C000B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:09:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHPel969;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788685780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nH4A7uyCnX9683K2mdDFMS+moGbfR1sarWe1L3aCMg4=;
	b=yhERvKnb/cS+NYcE+I5uCP/EWQskCnA3aGZZZZGtJKrlVbXNoptNftNbUp0UNKfKsUK6m/
	bKq65ipR/GyJmucrV2P6Rusq89xjRE9+otIGYIQ1dxrJ/avL8py8lj1x8uyHC8XcRxbWXR
	kdl3TIN3t9Xcv8GLIhYI1MofS/re9hc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHPel969;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788685780;
	b=W3RraTV45jRwBK/bo9l/fJBy06KbiyiZyuUlrKIgsykIs22FovtCdQ6ipK/a65KBcDKVJ4
	h+aEnY+s8E2jjxdT/uE7jpcloC2+nyPBLII6C4lZx8Ut6ENk/S/HxjN6ZGmtzZkWtvwSpQ
	N9OoMvU1BqLYkQfX3sTicQAow0NJplI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFFCC600AA
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8775D1F00A3D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788685778;
	bh=nH4A7uyCnX9683K2mdDFMS+moGbfR1sarWe1L3aCMg4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cHPel9691HQBonsJcgG0Nr14oDhDKzJT8fA7eCckwQvTFQCTvY5Jo7wfnvapL73YB
	 V8y0SPdYNiVOs4EerniHtsKDP1hZLOkh/RzptKyyljwKO2Js0bAOf/4Cw6WOgC/Dzm
	 wqQkU5SmUQhw9vmP/1Ye6JBjkihscQG77NNxtH33q5VmOb0a3KKWGePZtJkXr8fOZ/
	 uuPIbQVOQQS6By0ADYna6v0B/i2ySQ2iO5jnSjyhRQ0Cws501QDc5SS6Ry/cnXunro
	 kUBqe2tudE2BNB2b6jgRG4ap54oa6WZ2QV76uqSQMBSYQFToJo7ZdAny/A+31D3KQ5
	 YWYQtt+zyIfaA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c20e70a0962so303672466b.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 02:09:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByCAH+INDFCIkuAJmbSSkxCg5YboC4m73yLY7aDmBB70O37Qpw6YGkVwek95DmfVEPtFtE/5rM16A==@kvack.org
X-Gm-Message-State: AFuF++m5p6mWLTpCGgGWwsiLYop8qBh94sC79CwhWlv/9V4AKYlTs7M6
	Yg5Ze4ooTcqaHZsdiBYQIhUCyXUzrkkIaqym2focAB1+lu+uBS6eANY+w2o4AtaU0wKWOJsGV0y
	LP/Jb9XS/PQF4G/IiChiRSuO4S+bS7Jg=
X-Received: by 2002:a17:906:7308:b0:c20:9447:bd5e with SMTP id
 a640c23a62f3a-c260c8e77fcmr1298228266b.9.1788685777487; Sun, 06 Sep 2026
 02:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260905125101.2970456-1-xialonglong2025@163.com>
In-Reply-To: <20260905125101.2970456-1-xialonglong2025@163.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Sun, 6 Sep 2026 02:09:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPC4v_S80Gn5M7iiAujebP9QHdRur9fL1ECh8ZDxOov7Q@mail.gmail.com>
X-Gm-Features: AcwNN1XZ613eE90Mx6Kt3nAJ_FGJgWKRfz04Z59yIKo804bDCOgN7oWje5B6Cm4
Message-ID: <CAO9r8zPC4v_S80Gn5M7iiAujebP9QHdRur9fL1ECh8ZDxOov7Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/zswap: enable static key after runtime pool recovery
To: Longlong Xia <xialonglong2025@163.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: npdwmkoxbuipckgzz9ei1bc196tanxgu
X-Rspamd-Queue-Id: 22B80C000B
X-HE-Tag: 1788685780-446904
X-HE-Meta: U2FsdGVkX19750c/irvv4CKDcp/oEc07wvrhngNDO3TQnmu/PQz5XjjwXp+v4F3rD8VRV2HTk2L1GaKRoAAfIMIn9fp2h55J1VCxraGcf85dNbVh7IaKc9u/vKlmuTBD2+5guy7u1OayJ9UV8eVeUZ+kwF3eZ/lZBVuo09/dxXWhvL3e4k6Bq3jXccRbqv11YRN/BaJJ/fekKWy0qjj7aTx+hT8186C+4wcobGQtPU86EGD0zGj4U8vXanGN76NmzZcUlXc1KN/43WtBGaOfh/uuxE0m7OzteVmyurIDyqXiOU13NM3hsN9gzXJ5M52t68jBxEtLttSh9+LHHiWNGFFvcJyxFM/WxWlLfZGaOOv2dsATQTrQnM3JPFENB0A/ZkwvG8XBxOeL3vUHJO1cMVO6zOJz9faKVRrhgRfEI9if2o2vacsoX5XioVeOgbIYUDM9p+utBV7lBm0HibGbwdzyX1qwtf6qM0kLfZgoIeOuvV90kcKKV3DRlKzhhzGUOFc+MnJg/4lYxsokckC7f1an+LoCEoetiHqXyCylHekVlls6w20NMg+AtR79oIWgmbvNHeFBnQ3rgqMgn33G0RMtuHSFN8upKXMAzwQI4kyGmcdwRRqg+ncHMDVrmgCBxda34EEaTW/CBMXjP4MkS5lWoe+Q3zhkuOk5Rut7ATlpNHvpYBo/12Ib+9kVG6zn4mt5w1dqeaG5KHT4Iacsr9GKqlrCV+mUo32lYXS5ch1u5lSVQCFBADpDkaToAuP3mztICDflEIIt31/2aOUzeeTQc0BKPyG18XhZaQXvq3Nz9yqweFXixbO4K2DS1I80V0FL8Q7FCBw4C8KnQZoS8HvAGSydnPRfZnCrMvIuSIedUh6EDOysUSlBZWVYsTk1ipJAd04R4Pdth6BByeBc/U2GmVzd4B9gTW8tbBOnfERplGQIloK37GIFJFZfRd3igwySsCsyuiIhLjsjpPr
 yL9dZO3n
 QNQjRtwI36Dja1Xh1eMz5QputJ2KuNVlJIQBKbyqeLVABdbcZHMf7RppAnB9X3ku0AbXJCGoDyhQrd6hFUdsO/FkuP6WI3lyr4TwS9pG77CjMuzK4YcUknjEjxI5Jg3PlxkgfhFvetZtt+tbdSLne9RcmInMpvsQ1oZ6fY/bBoCcDMBkbwSE92fv/AK000jRy6bU4IlqW8kDSvv2uXFOANZf2LERl9nYnwD8OwZRYvxS6IndKpqMFk+lYywJ86yR2f0Vgo9ds4K9qdv+ZlfBL9mfeTpzSjSkF19GcNJBg0UtFX4qjYgPAcd75kG7CG7ifWXkX99CZQ/Q/imk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 5, 2026 at 5:51=E2=80=AFAM Longlong Xia <xialonglong2025@163.co=
m> wrote:
>
> From: Longlong Xia <xialonglong@kylinos.cn>
>
> When CONFIG_ZSWAP_DEFAULT_ON is disabled, zswap_setup() can complete
> without a pool after a failed initial pool creation. A later compressor
> parameter update can create and publish a pool, but does not enable
> zswap_ever_enabled.
>
> If users then enable zswap, zswap_store() intercepts swapout while
> zswap_load() still returns -ENOENT without consulting the xarray. The
> swapin path therefore reads a stale backing swap slot because the store
> skipped writing it.
>
> Enable the static key after a successful compressor and pool update. Do
> this outside zswap_pools_lock because static key updates may sleep.
>
> Verified with fault injection on a stock kernel (compressor builtin,
> CONFIG_ZSWAP_DEFAULT_ON=3Dn):
>
>   1. Boot with zswap.enabled=3D1; pool creation fails, init completes
>      pool-less (static key off).
>   2. Echo an available compressor name to zswap.compressor; a pool is
>      recovered but the key stays off.
>   3. Enable zswap.
>   4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
>      fault it back in and verify.
>
> Step 4 reads back 131072/131072 zeroed pages (zswpin=3D0, zswpout=3D13107=
2)
> without this patch; all pages intact (zswpin=3D131072) with it.
>
> Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
> Cc: stable@vger.kernel.org
> Assisted-by: Zcode:GLM-5.3
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/zswap.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..c48c4df63f188 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -586,6 +586,9 @@ static int zswap_compressor_param_set(const char *val=
, const struct kernel_param
>         else
>                 ret =3D -EINVAL;
>
> +       if (!ret)
> +               static_branch_enable(&zswap_ever_enabled);

What if we move it from zswap_setup() to zswap_pool_create()? IIUC
this would cover both cases?

> +
>         spin_lock_bh(&zswap_pools_lock);
>
>         if (!ret) {
> --
> 2.43.0
>

