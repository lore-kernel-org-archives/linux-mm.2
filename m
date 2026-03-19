Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869461088E70
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9606B0246; Wed, 18 Mar 2026 23:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69CB86B03BB; Wed, 18 Mar 2026 23:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F806B03CC; Wed, 18 Mar 2026 23:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 427356B0246
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:24:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B3261601BD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:39 +0000 (UTC)
X-FDA: 84561370278.26.2906A48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1069E40010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hZJANnuI;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fI9rzW2aMBEATJKy6J7V1Mrvg5oTiG1wsCzQGFVE56A=;
	b=rQUJL19WhSrjOfz7TUVrbeR0NzfyioMd1sS9+mp1SwXudw6jSoCdaDL+wVKWblJBLOvCAc
	si6L1zqkjZeLk3POp9KWgi/LL1X+p000cVYDlsmGhrEfnT2SjNmW/+KWuTXPzt+6JZ3ybZ
	MVTotoNxsV3g6NY0fbURpLxnSd0JLfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890677; a=rsa-sha256;
	cv=none;
	b=1z019Ez2OPoj12GA7oDksWCQ+2tuZ0AQKWvnWKd2OrXXdrJM7c5smtG57085QOjVQAyXAv
	QDH3kvyHa/JiFLKvz5Eakigtly6DE/nMdpEZr3I5PjX5E5SuZI9YH5VQpAzUBGdg/vxc2T
	BZbwl07j7P8vDbnCpzfzs4+tEd9cKHs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hZJANnuI;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35b97ed057cso344015a91.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773890676; x=1774495476; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fI9rzW2aMBEATJKy6J7V1Mrvg5oTiG1wsCzQGFVE56A=;
        b=hZJANnuIkmkIZDdeNTsxMn5DL/pV/qHF+xKZslcPH84L1LiUuZCK5lzmjfl7zaTqOD
         mqeBNusuyEebP9cCKKnIabhrr13C10ny792nh6ptfte12cm/Q4JKzVMUsOvnREBYHa5Q
         2PH78DcvFH3Svpa2dpM63j+z5MMH7wgJyEQwE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773890676; x=1774495476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fI9rzW2aMBEATJKy6J7V1Mrvg5oTiG1wsCzQGFVE56A=;
        b=GGQJqOFyO1bKH7WD8TyQbDfv9Kh+e+Tsz20RQGDeFM1g8IhFNRWEcRKAxvKgpA/th/
         UuMZmC2r9RKEU5Mznf9ykDC59hrmLJ0wvlHSjiRxu/NdTq66wZYXhqGUmjVNXkZ5C7bZ
         dwp4VRSkJhtgqVgF9wswxWCE0QrNB+lORZf6ThT6eDyssYfZtDOZCcHLbP2X1Ad24A5J
         HgpozBDMdwcvjmth5uKw7H2ukaSduALg4DbC7E9gWt3hTs+Q6r5PaEpW4611Tdk+50xV
         lS7A4kPlySMQ4Bb26RWArjACEVdoOUXM85D7w/DwxNKuh7lfoH3N5t2PlNCHTaEghJfp
         aGlg==
X-Forwarded-Encrypted: i=1; AJvYcCUQKGrK9zGxD/aon7tOmKxiE5dyGXvJsV9aQZLqcOo0WZrVl3/HlZoc4oHBTBJv/W2zb9024UFwfA==@kvack.org
X-Gm-Message-State: AOJu0YwT1c9wQF5hGaVLk9OeVK32quHyZbU7TSrCdk+Bc0coDXbnHoWh
	eunGU+/gZaomEobiCUmu3CKXVb0iffmvH15jSwJ3xeftYVyCd30HO4t2ddJmB4yWHRyd1votOpD
	uWWI=
X-Gm-Gg: ATEYQzwfkVFDWb0/m70Hr8Eb8iblTtgZR4AY87uuRqqI5ynQwj1aYn5C6lohHxCSr3W
	jg7xswdl9TKt5OawvSoGOrX5itA9c8NcIOqDEUMSF/UHhtGCSi1VKqKexWH7qxsFs4K6EZqB9Ij
	NxGdpzbTNaiHaO3btewxBxRP3F12PSZlf+TQsBOooF0xD6e7l7qwRPn0r2p6TGiZba094QKpUM1
	nqHZ81fsqDxe+3/AibxsaPglpASXih1bg/k025UeqPXkFZSbFxTXD+PTToyW5I+ufmg8AxXp5o5
	Yda5tIJxPhH5XArgpb0eNaW47sQn7gmpVr2OTCNDaLAlgf4T795wDu9ONGEd7MCoF4uKUwQ6JWV
	pjoJle+lp4+o/x2p5UogJIPaEpUvm7ImSNE8/HqQyLlgZxjtIDK+EgW8ZryHeG195WUckDyvdUY
	EKspBB5+0eTpca1jZIDrKVWixBAa+IzRkyLcejAurp3Wy22pCGznaMkoTxl4j7MEY=
X-Received: by 2002:a17:90b:3512:b0:35b:9a22:deb1 with SMTP id 98e67ed59e1d1-35bb9e51036mr5058277a91.8.1773890675925;
        Wed, 18 Mar 2026 20:24:35 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:13e1:7517:52f3:cfc8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc62f8e55sm1293261a91.9.2026.03.18.20.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 20:24:35 -0700 (PDT)
Date: Thu, 19 Mar 2026 12:24:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	teawater <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2] zsmalloc: return -EBUSY for zspage migration lock
 contention
Message-ID: <abtrxh5Jhrw1yHRO@google.com>
References: <20260319030709.62556-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319030709.62556-1-hui.zhu@linux.dev>
X-Stat-Signature: mgz6icm1sdba8dkgrurt9m75it4cbwwi
X-Rspam-User: 
X-Rspamd-Queue-Id: 1069E40010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773890676-797672
X-HE-Meta: U2FsdGVkX1/J0F4KwJFUBLl4YtebFPXwOFJe4+S42Sr46kHUJh1pm8rWoNfMsW+Ti6xkCwag9ceqTuheN82pBDEsoka7RGYTKgfXcVfSVVuz/p0oN4/5Ln1wNg8vbCTjx4c5eXgdI/6HPV1D8D61mgfTdn96ZXlMRzce35oBiTMkZAgI2ijZWIXM5We/6U8DtmVkNpae9IKuklMOZD7uXbzSLXYxwJ4Tigz82bZ/zA5k7hWra1JNgu/bUUfOpIzuXR2blHoR8BrCxuqeHAm2IaIIWmGRr+T8RIdWXviflmaF7jw77G/CJUeuTRTKG/RHoPU1l0G7Le5iKi2BJdM1Q5luBryd5FG2vTEWnl+8WYrZdGv2kPXxG8opJrSIVC52cGZzBCkBm4rBOYVpthYlsLsrVcGw4xkuRMcsGMpL0eOPxBVheGpXE+MD1PivtfrIS17dsyK1IXNUvCOGgK+uEYwAanHarCN4ZZEnQH7wAy03O829p0l6y8kgf306PUb4/Cdk+7QSmUOgTa1rBjgyyvta8Ao6a47fupar16X10S6y3LV4bR7BaYXQ7xRNyeYav2STjKxfkAUbJbRMHd1lPO3/aB7LICoSRNU+Rzj9F4ZTPBQkPq6SFFdF4D9yR69+YJyiCp5IeT/cLavAbi0wrqALKYkoOo18cNX+Vb4oRkHgkVkayDsp9QFD0QG3/E0NWXSwQjDMwbtYsayi4Ty11BhoR3FLMKbw7UD8TttdZq9jVOIapY7Ae30k5b4yz+V+Ehce6w+8z9i1J6/KDv0dhHAo0N/c8sbyY1+3q+feq1RNmr9IVCn2ahG+Z+f/tTM1h601MBPtgY/JaM+9pofoGoPWdg+0GU4vW1lTL0Nu4mCSddR9rIbumpnP7eDk350J+IbJSYb7QAHjjS6S1mr4iwH8+GjXVudGGkTRxxMXYHZuwXmwc2LTGuHULFkDpRcCDXqoJFdxFzy83WcEVwB
 uy2XapSz
 J0YspSW+x4W2bgQWS8Y14Wp140tYIw+WAwRlHJ2ZAlgWrOOp9Lw+QOAsequgJoOtzz1IdkwBj2LfBWG+tOdwQx2SwwpcUXOT6kyBj8qH0qh8nANoB/d40FHCNtTuf49lFP9phk1XoWKW2eHTHofIq0db+8GyQyKfLjEgp0ILzbzQ0LMP2jONYqMQvslUkf1DcmGW1jkHkTe4ZrsDe+IrDEgHDEmuojMZoU+Tq9lE2Npre/mDp+gL3TmrnTzTX7uwRU24rEUjZDnVmqmqLKQZ0GLug/acjV+9Za0AzSPQjlBRCr2CzMONDwbWThsqHql2l/IuC+NN2j/3fWc+rzxv6yXCk4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/19 11:07), Hui Zhu wrote:
> movable_operations::migrate_page() should return an appropriate error
> code for temporary migration failures so the migration core can handle
> them correctly.
> 
> zs_page_migrate() currently returns -EINVAL when zspage_write_trylock()
> fails. That path reflects transient lock contention, not invalid input,
> so -EINVAL is clearly wrong.
> 
> However, -EAGAIN is also inappropriate here: the zspage's reader-lock
> owner may hold the lock for an unbounded duration due to slow
> decompression. Since migration retries are bounded by
> NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no delay between
> attempts, there is no guarantee the lock will be released in time for a
> retry to succeed. -EAGAIN implies "try again soon", which does not hold
> in this case.
> 
> Return -EBUSY instead, which more accurately conveys that the resource
> is occupied and migration cannot proceed at this time.
> 
> Changelog:
> v2:
> According to the comments of Sergey Senozhatsky, change from -EAGAIN to
> -EBUSY and add comments.

I assume this Changelog was supposed to be under "---".

> +		/*
> +		 * Return -EBUSY but not -EAGAIN: the zspage's reader-lock
> +		 * owner may hold the lock for an unbounded duration due to a
> +		 * slow decompression.
		^^^ or reader-lock owner preemption

> +		 * Since migration retries are bounded by
> +		 * NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no
> +		 * delay between attempts, there is no guarantee the lock will
> +		 * be released in time for a retry to succeed.
> +		 * -EAGAIN implies "try again soon", which does not hold here.
> +		 * -EBUSY more accurately conveys "resource is occupied,
> +		 * migration cannot proceed".
> +		 */
> +		return -EBUSY;
>  	}

Otherwise,
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>

