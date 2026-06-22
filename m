Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286C3CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C582F6B008C; Mon, 22 Jun 2026 19:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB286B0093; Mon, 22 Jun 2026 19:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84E26B0095; Mon, 22 Jun 2026 19:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73A456B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:15:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAB36C1909
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:15:49 +0000 (UTC)
X-FDA: 84909108018.07.AD230FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C9919C0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:15:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zvn7/3qJ";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782170147;
	b=36i7cpSlBooj2K6f1G+e6UvzsmpcIQedej4AG76HJmdjH6+U9aKYKG8cD7OTIYqME4TahY
	u4zK4N2ziMsosm8t+Pj88wDcTvQk7wP8Hp37jZaVwocP9ezOEWwHtLmqALIEKs8EcJ1gp0
	TyOlWFlqJMXr+uvV60FC/7PFFlHdLMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782170147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3KfhpX1jkmPRHT4gWNcnb1KIGtFV6FerdX8QWE6MyQ=;
	b=M7+bOel5ZxOxRKQy5WOW8lStwXIAUbd4HnyDdbDtY8noedHlOq7Ja1da9h3qdAWgezKU7d
	moZARLD+GxIpiC+Eca6ltWmqGTT0Er+9pyZSwtc/S7jmNsodTWnzrZxMK/A2XTcp/Xgf5l
	WMcB2s4JO6+y1oYspEZzfFIM15clD8E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zvn7/3qJ";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E513344482
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C01F00ADB
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782170146;
	bh=S3KfhpX1jkmPRHT4gWNcnb1KIGtFV6FerdX8QWE6MyQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Zvn7/3qJhrdSUrmWKARgdDyixWz1Txy5SoOc5gKzzDmI1S0dQqRFNJclGb03XhPVv
	 hSvSDCKuW92uBpyPQmiqxPMjoYZ6dcI0xFmfXLPWNrQA1hGr9zNE7xSxxTGHuWLTlY
	 0x3X3kgKc8tx6QEKhOygoSa97XCBKeZbRSi36Oe1pN1ZB6pcOLueQ0pahK+HCweKvR
	 E+bHtApuWkp3u8I/InUNoR9gl8EfwcSVoIzD5e2hMtwXt19uCzldlHNoslTtpXyILX
	 /TnN2QIQ/93go2XlukOoOdihISvMKGtE1HJGoLAJ86lExr9+7HV6wLLwAds486sbhG
	 HGBhLfdS+qJtA==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8dc544dda2fso43865156d6.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:15:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RplW+RLxFLORvhDnJnzYWLc1d8u+I+ASPFrGXWH8fCwPFsZIL3jw6DIoum6EfPui4QkvCVP26UDeg==@kvack.org
X-Gm-Message-State: AOJu0Yw5rcCxXtWTPBQvnJ16aZVPbkQXapDNUII5OaH6rIygb6aB/Fw0
	JoeKrbVC3BKmVRsabR+BduNnStbUO2yRI1wv+3ntm/IZ5u0SeyKm78wlmr1fy0dSI/9cfqkffI4
	85iuEHav+TXULPTdDwZ2W69rCuGNxNtg=
X-Received: by 2002:a05:6214:19c4:b0:8cc:10ff:cebc with SMTP id
 6a1803df08f44-8df8ef47a63mr43716436d6.7.1782170146132; Mon, 22 Jun 2026
 16:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com> <20260616031309.3036234-3-haowenchao22@gmail.com>
In-Reply-To: <20260616031309.3036234-3-haowenchao22@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 07:15:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
X-Gm-Features: AVVi8CfvWJquYv2yv8PPGb1dSrZj7plm4mtNpgHful3Z1ffG9cj-3Y0f51U9AO0
Message-ID: <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9919C0005
X-Stat-Signature: qm9si845zk36iqwg4thtwhr8rho793fb
X-HE-Tag: 1782170147-804765
X-HE-Meta: U2FsdGVkX1+naU6CegDXYlI1SdMsRdarJbQqydkrNSjndtcvLvPK1sc1GHNNXYlh9TGgi+/k29Gdqy+lfXoaN1FeOb3s/MtPj00bCyaVZ+ikY2Q4K7L2XiocLsOAzq9XMmWYN5lF+5QUcEI+tHLXn6nh8qZlUarhHuoTreSDQcSo+gHVu9JtGngzOTSKM76AerKdRzqN0cQs23XvApe+WirRubgrxPw0I0dNavaKd0cXKYNn+zky8HeFYlP7vEgzhM+YZIHKI6VXVTOCTlOtF51KYQCLoeNsV4DUUI/rVojw0/d514/kpl8wl/yUefBtbiFnJT1Vb3jSpt9coo8AEbiCJjiZzzCKqKOEA7WoWFpcQY1LPtFaZzKhJjQL/Dnp/YkzGhZSnD41K1o6kVAC6HTHM+d5nxM0QkyQA86r/q6mgiE6vLdcUXDeJZqC2FM3NCaKjqR+yVUEE54GwFR5YjbJWfiG9tg/uAPQUktgC0ZhUHLCLvC9BgjLqr3o4pE201rNrMtC060txZEo4n/iwrVdD5S6WuZuY3LTpCe8k61ISgJq8GPikSERUBkD+sk+3B/3e1iEPYmuP6trgdpSu/XWqqYxeoLWev6zyheIcLPMO9IXJ1iM6yUC5UYFwF3QE0ClCAF8ab6fMQcAKgAcEn0ZMUZMjstsWLaJWK/wQc9rSKyw2cdHUO5l93Ptc5X9BkFFayQoLP8I/Qr/+B2g3PiilzI4DshqPeXovRwQpChnue1Rv/e+bhCyAzYG/Fomotkw7+jU8aXfRnh/42hKxxdOKXtJagBflhDwi0VA74GouiXKo7BTMBmuM7noOBDPS5eDOkDYrOtA7wGoA2UPsMm4gdWWhDmOgkCkAEKUInnnaTCcmbpK4w894qXHmkoUcEyEDs+R6YkOgteylzwIpmmHVYdWAGLKqN3qejVKXwv3MhwajhE7Kp/vKG2ZnhseoJvc0bKpKu7JSqzFQ/y
 9lalIpA1
 aEbXiVPWl0gA+VjXDSLyo6gnB+vSOjvirrfiLYCnZTUzF70NQCDYBOkHfHP+ke9zITGTu872NPr+0kU/oPW47niqerQPR1G2OWZSWoO/Lf5EYX0vQeLl4EDss8Xq9i2XRt4EOx1zCqhhIOyr857AkZ8iY5o3wNIFAw7tHsZBGmrTiTdsVIkCbXYHvwJW/DvW8+Y9REiPPkPVTjqekY/qTR+ZVe4/QjiUk3JHRQLeRUhpxXzsLg+tds1Vl/wZnutAO+7ios/XDSqt/xSvGDylBzCegg+hx/AhNx9Y/N2aOsdI5oSTnHl8nRqvv4yhPitQY/xuhEr3HpzInb+BjLZ2JnBHFBaVFhyvcJyGIeN3H9ymtTKy8qx+IPT385lM+JYjqCDTgQxBekavBl5IMY/0NzyQZaQXSy5jSxoe19/bN3k51Hpew2959o6RAgLSQGFPOYyOxjYGR0AAFFHVGgq4c9JOhJThvtsHNTnhK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 11:13=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
>
> From: Wenchao Hao <haowenchao@xiaomi.com>
>
> With class_idx encoded in obj, zs_free() can locate the size_class
> without holding pool->lock on 64-bit systems.  Page migration also
> takes class->lock and only rewrites the PFN field of obj, so:
>
>   1. read obj locklessly,
>   2. lock the size_class derived from obj's class_idx,
>   3. re-read obj under class->lock to get a stable PFN.
>
> This eliminates the rwlock read-side cacheline bouncing between
> zs_free() and migration/compaction on multi-core systems.
>
> Annotate handle_to_obj()/record_obj() with READ_ONCE()/WRITE_ONCE() to
> prevent load/store tearing on the lockless read path and silence KCSAN
> data race reports.
>
> When ZS_OBJ_CLASS_BITS =3D=3D 0 (32-bit, or 64-bit with obj too narrow to
> hold class_idx), zs_free() keeps pool->lock.
>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>

Reviewed-: Barry Song <baohua@kernel.org>

[...]
> +static inline void obj_handle_class_lock(struct zs_pool *pool, unsigned =
long handle,
> +                                        unsigned long *objp, struct zspa=
ge **zspagep,
> +                                        struct size_class **classp)
> +       __acquires(&(*classp)->lock)
> +{


Somehow, I feel that obj_handle_class_lock() is a misleading name.
The function clearly does more than just handle class locking=E2=80=94it al=
so
retrieves the object and the zspage.

Best Regards
Barry

