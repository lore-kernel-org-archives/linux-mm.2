Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F0CCA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 05:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447EF6B0088; Wed,  7 Oct 2026 01:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9F76B008C; Wed,  7 Oct 2026 01:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8EF6B0092; Wed,  7 Oct 2026 01:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3F006B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 01:46:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4A57A77C8
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 05:46:35 +0000 (UTC)
X-FDA: 85294745550.10.4060FE9
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id C7F7B180003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 05:46:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnCMkB3r;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791351993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lICY5WSOFzmjBp3zqHxgBj253NHuaAGIzHQXH6pqh4=;
	b=kctgeSKrPbkYtpi/f/hvq+U0+xkbwyh8YWgLwDRp0HR1TAvwgK6TvnZSptTeJ4RkoWBYXv
	A/p+wem8CgNicavOYBxoO17b65ZDG6w9G5Nw2GKg7+ZgyS88tUjV5wFZpMn58C8lXHEm2d
	bL2CLTgEOs71+7gpvSu1ZXbFGxcaJDg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791351993;
	b=i63Hj5F3rKL0QpfsyMQcl/JszmXt8O3wLGoe/EZdFvUKnqIA/iPVopgOnRVre/OFL27vO4
	EPfNdwKeWmxxyGGCtOtexjKjKrM/tdMyZG9LerHqY6EwTusWkLH4TJuKCUtpJoyYm9uvmL
	zSHgEi1FHp1sQL4Trtcj76csozbCmH4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnCMkB3r;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b0946c2c2so942330f8f.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 22:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791351992; cv=none;
        d=google.com; s=arc-20260327;
        b=d3tzJLikccYwt8kwIxLb/zRBBELUF6h04JvlkgIAA81ZLdct2tZvE0ZA04bv9lLGXo
         XxGvCbR+7qnooa4ftMyKaDA6818tDbRlMnevdp00kGp04W3iIK76N1hs3C1Ebx7NlSXE
         VrY4kURzm0mOBl50LDl6vjaIfXg0iwC4+H5vOujnLze5K2uLPzLszo0CMAQqaZQlwhiQ
         19oCoAOAlc3fxPJ6ryU4C0i8bKUDxdu7XWlMPSIfyYvIjBJRAiq+VefhBPix9fq8K5XQ
         g2va4Z4cYf/VJTNkfA0dwkuR/gGlW9KDTw8iWMvNTuKPLwL7is3bUUemSaFaSa84QEJl
         a8NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0lICY5WSOFzmjBp3zqHxgBj253NHuaAGIzHQXH6pqh4=;
        fh=Dk82eDrp2KuWMxenORmWvKmEif94XgPEkLd0VyUZWdU=;
        b=HkjClNhEtoWgxLlb4dHPwSWhbel8k/6oAPVxLFV94Uy/Vf1RM2i5yHboyDH1YKp/pf
         +YHyt/Teop85wD8zThTvwRahObXX0fquHBnu2VervDIhoxMUwLJCWk+e1ne5SK1fJF4D
         IukK9C+4i5A7YmAlZYiLZqCv6epyXwzXOUGR+7AqQLd5NZrjGZVZywRRFOgSDQvCkvYl
         cZAC8W/U2Gzx+i7AVOSSyRIGIzLyDdnxNXwccNWvHqz+JVu1Gdy/JjtMc2nblVlcJZ/X
         +UQKAob7ll2KclsFkJvj8oBQOaBCzBIfuxqrdVoS8XpNIgHChDipjlphVn81FFyieql3
         1P1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791351992; x=1791956792; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0lICY5WSOFzmjBp3zqHxgBj253NHuaAGIzHQXH6pqh4=;
        b=AnCMkB3rSoaQEakvVzY04Mirop2HCweSy9kwmE32e1nN/29iF7qAgL/0VGTlJTTeJ/
         M/ixVVRtePLqbOfmFujUFWuqQ7vPybSZFERuRf7A7ldwN5BBnp0dzpQ+5bVloEcbswjW
         yD6pq6pPxGSnGpLdLQIMRURizYYUTFx2pRoNkXgM40cWix84DWBtnQzWC1oxw4DVQTec
         Eop8d3nvVf8iaroC7nzFMh1yvd58z4nF6DVKshM21SjhNAS2YYMiKiO9vFP2vSx8UAaw
         1K4ZpPZtbD7nwYzFz6Fy4/3T9YX7S8mZtweCfhGQJeBm6cexfheo2daFgvWHJpAcG6Mi
         RyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791351992; x=1791956792;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0lICY5WSOFzmjBp3zqHxgBj253NHuaAGIzHQXH6pqh4=;
        b=tPKVjFWSSVMHXk1aJD1Y4G6LR/aWI6/Tr9G8Fg4nGsRYgfZImz3PuhRM7gMz5XkE49
         Efydi6swwOqbuwM7ZU97T97LKBVloRrfhkJLWTZrKjSo6qjEwL7l3rMZEE6U8OWqgsVr
         NSm7UD5SMlpFOpSlZ9DYvBXhf+krkoaFcI3V/b18jiM5fRoHMJKbtqeUPoVnQxoyD5xA
         TFTgF/pIghwCufNZWvSi3h6vGkyujFwgoPpd9fh5m2cczmUcpg1d4pZykAvNppcSYH0Y
         VUYsNoOrES2797Ar2zeqDriDjh6zkEkF8W8d7g/9EX6gx8gYMP8mT9wchGICoaurXe1I
         Qp5Q==
X-Forwarded-Encrypted: i=1; AKwUvBx4Ki+3hYNfOu2bl8XXJHSeHRrHlvKcnXxWvnhe5AeIFsdm6M9lr1JO2GDrFJHM2Ye+h1gFMYEK8Q==@kvack.org
X-Gm-Message-State: AFq9FYKrA6InyGhcIit95kdHQsp3h/N8PZUUAq9I1Mmc0bkRoaeYb0H9
	jLCSQypR4NEf1bwMCDdmz7Vbz2p3ERugpj9ZGjWEjX3tnlNN8q2kW3GZJarU0+xj7YpQpkrJIYJ
	Aeq4WPtaYLmoHLPGyKi8grrxKuI+zLiQ=
X-Gm-Gg: AYBFou0k83PWKxuDgO1Otx8QFs9O4SwkcJVYDW+gIMahWnZAACTBHS0RKlXSE197Plt
	KFBbTG0tCGjBwCL78SxMtbjbYwnoD/ieWrF2eUkIZOmhO9R3MT4EL77a2rJL8X60567f2pXiWKr
	dd2kodjt3T0HJr8Ey3LoOqtUsoX2lZsOtMrr+XL+QgQL1NiHOJ/9uRB6fAGFsSFRtGuQwhlFk0J
	viDUBePyojStSm+Gpfza8nMxK6yBpqK/wjQtttFR+nIMFPbwXDj0Ayz/6tMEQwanmhWrdZjSYT7
	Y+VznOkZCK8eo0/8w4uzsP3e6VF0mzOhG0C7z7t/BbS2MiJK4iAp8nwlYhwgIyYcgFK+NH79SB0
	7RnjwTD8BXSXJ
X-Received: by 2002:a05:6000:298d:10b0:48b:10c8:2181 with SMTP id
 ffacd0b85a97d-48c7276b5cbmr1543779f8f.27.1791351992147; Tue, 06 Oct 2026
 22:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20261006002307.2669023-1-usama.arif@linux.dev> <20261006002307.2669023-3-usama.arif@linux.dev>
In-Reply-To: <20261006002307.2669023-3-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 7 Oct 2026 07:46:21 +0200
X-Gm-Features: AclHuK-kf0wWB_PkgUsgFRdsEqx0C7L4e5ywAsWTaXOzlhXgNykWvuMnXDUaGPw
Message-ID: <CAKEwX=NgO7wZ5thKeq09swYEkoc97sUAaCo9H4QO93UQcdixng@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: zswap: use stack requests for synchronous decompression
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	terrelln@fb.com, yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C7F7B180003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pcj7urd5mbijtuw11g57xhi4q88hcyw5
X-HE-Tag: 1791351993-805878
X-HE-Meta: U2FsdGVkX18foQbf6us/hZUbSrudOJo6WUIX/8MCzfiv3CpaeES0wbJjwGacGCVrMit48LOstzUvIEkmNyi9lleDTFAYh0OVjHs3xYhuE8p48V3Sd82rxQ2OXg1xQRo025c6qXmJEtU49Hk+VoKid+UFaOGQThX7Kb4sXF0YbL2PXCSu4l3VYuY85ZA4TSP4QIQ4rgCtvY5XgTXIf1hi9UpEgRGdhflIvGJ09pzoCxgCKmOJ2Ps+uW1nRVvrG2QfNDyW36cGd82dAwAEgkFCCESMg50ZYuPza4Efs5rkqOSPs5casol7nq17z3bbNnoKwe4NcAFVjyW1GuIae1IEJDO9QmknuYufTogCpmSv7xuNjuQDYu7s7HSXnvA5EQhK4cTG8yYspEU8v5kQXVoyajheIDHTRWigsFLlddanqifAgjE7TgKE9ob3HSW+CtWm/raDSLSFolkoGie0ibaYGjfgYCj6NuTKK83nF4U9jlfYR26rxo1ZKv05bDwveOkQ0MX52X2jTigtkSXoms29cR6sjcbZoL4EI7BDwXCFsPwV72G0SyryeAAiTS5Xw6WOB+yhZc+KGM93jHBl0WHzzKWMCDZttvcZwYQiYs98Zduth2ts2kZ+iLtC4n5CvnrVbVzEU0SNnazpUR9KBFQXumlggYCo97ev4ZEiHhE36KvlTwP5TmYDQ82WdI2NOF1G6Livbb40S/E9kpqb/VS4SDrX8DbJL6YY/oVv6GF82mLPd7/druiXubgTmn9dmDka8Ky/0yuq3wfaLbdyQ3i6u19KxvnVDjSykz0HIkivx0Nyu0OVG7vMHazvi1xWl6dONYp6MMJ97kVv2pRwaH/lop3VOLYchpmyZa6Q8emGdx6db89mESIuHNEP+zkiXF0kNz7CtRflqF76c0Ai4EUGlcmLh1csMoU6IJr8ogyzPoMqcDiquyu2Nyu8lOXPvRX/eUjzMfja/mJAsHiCNDo
 vmf7YkZZ
 a7MXS9hVrT0PmLKkWUGYfkvEKj0kQyDUTdiITbQqc9B0COn0155PEQdnc0djio2XvRTwCftcswP3hx0uueN4ltCQKX3dwBGXeyzOf/9OVMOX5hT+OYI6qjSHoj/mghfXjys5inmrT8X4+Fx1HQZECMa32ooqoFGRz348dINmVBl+sUEy9ggiQB7s6+lrcU95TKc+XJcFJ6DDTHa27p1oqPYggk4PHPtNKQEZjgrTeQYKr52RwZ9bOjYuPokVDfF+9TYnGKDrPgs+et2beUtqvAfKo+pYRFf/SJQW24mr7+eCWwWMoq/MWQodvjBZZLziRNrWplKHZE4zQ+GKVerP/i7ljQMQSTexDNNNkUhmsNAR5SuDZuOK1+h4Qjv4PrxzDZoGA7/Q8Si+Dmn0tXXX8LaMNPPxEgrZBKdn5ueeXJTEpI6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 6, 2026 at 2:23=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> With separate requests for compression and decompression, loads still
> serialize on the per-CPU decompression mutex. A low-priority load that
> is preempted after the codec drops its stream lock keeps holding the mute=
x
> and stalls every other load on that CPU, including higher-priority ones.
>
> Synchronous algorithms whose requests need no extra context can use an
> on-stack request, so decompress with one and take no zswap lock. All
> in-tree software compressors qualify. Asynchronous algorithms, and
> synchronous ones with request context, keep the per-CPU request and
> mutex, which is still taken before the zsmalloc read lock.
>
> Reading the per-CPU context without the mutex is safe. Since
> commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
> pool"), it is set up before its CPU comes online and is not torn down
> until the pool is destroyed. The codecs keep their own stream locks, and
> crypto_acomp_decompress() rejects on-stack requests only for
> asynchronous transforms, which never take this path.
>
> For software compressors this drops the heap request added by the
> previous patch. The on-stack request and wait take 216 bytes, which
> makes the load path about 270 bytes deeper on x86-64. Asynchronous
> algorithms pay this too.
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

LGTM!

Acked-by: Nhat Pham <nphamcs@gmail.com>

> +               ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
> +               DECLARE_CRYPTO_WAIT(wait);
> +
> +               acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLO=
G,
> +                                          crypto_req_done, &wait);


Lol this got me reading crypto API again.

