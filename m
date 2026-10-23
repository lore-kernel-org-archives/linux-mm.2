Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B804606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 15:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UiB05ZB/
Received: by kanga.kvack.org (Postfix)
	id 0B26D6B0B8B; Fri, 23 Oct 2026 11:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AE66B0B8C; Fri, 23 Oct 2026 11:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0BC36B0B8D; Fri, 23 Oct 2026 11:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7F8B6B0B8B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:08:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30486140124
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:08:04 +0000 (UTC)
X-FDA: 85354221288.05.AB278F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C365F20011
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:08:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UiB05ZB/";
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792768082;
	b=CtVEA2QIalSjHhVgo00n+YB3kZYbudW4frsNc95/OrfqtdG5fJVLIhwZQXjMeGKJ6Fay/j
	Q14WJQyvXIerr7pnDihtqgXECXGs6iwc6Tj65+z1O0F2gv6z/pJRF3/CChgUuEPD68aGvG
	0oIJgMMKYXq2szXbphEZm1cRzXUVN4A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UiB05ZB/";
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792768082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmpCPFVTuFm706ecVOsfIYsdS839wcSu5U/OGfd0cQI=;
	b=HUOyX5cKw1UNW3vRfyMs5B0he3VBHc2IgW7ilCO27e0Y4H4xYnLVaXP6fxYQQEAgE6C5/9
	QKNgkjkh/HW6AcvQH7nZNGNM6OU5wLxCLFrmhz3ocn2ul61s0tVZX2HXMdSJxWSlm3yfjM
	24frUpYBNKzvPBEMwVFu3snOzw02Wfk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73D5043EDD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5825B1F031E4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792768081;
	bh=WmpCPFVTuFm706ecVOsfIYsdS839wcSu5U/OGfd0cQI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UiB05ZB/3Uq5x4So9B4NBmFafP7Ei0jiihyEWg4x0dLS39ag4T6ds7bqXUGpRX2lZ
	 0KAAE/NUXvv+vGFJc/QZAt3ZsIDqzX0nExCSWPWioTolsSuYgZTRdRUNcveBbXM0IZ
	 Id2jYUEl28f4Ox8lkekwABydnEbJBVYVXjNNITOoMkmqYEJeguvGAAbXY0Qr/GDnWo
	 2BTHczmhCOK/aEe4yIoe8pRhFzuyn4IPCjP3HosPUn9+Edc9DLGaXDKX0cUrKNrJyG
	 970RybfGTatPmuTH25A7cW7jugRjSq44GMUXN2bgrGh7wWFgHaT7gZQePdhkCJcpFa
	 9MvjCqhjQN1ww==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c450ab1483cso139685366b.3
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:08:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwIIXPtlBU54zCQBQDfbj4JA6F9KqJjPInNOG/eWpJSgvFS6pN4qU/KQxVjc+OOOy6KxtJvObMT3A==@kvack.org
X-Gm-Message-State: AFq9FYIuvmOLMVvywp/+W0mueH/ukkd9844ZK26lmvrJM/Uc+4ZFRDKw
	cw2NxRDDXMHVo5rAx1acdIU0iV3ewUuHQAmgu4mdP5jUyTlpdh/tPSyckGTs2qNvHnUd/7n8yrR
	02Btcv6Igx/2vXzZVM67WV+yTvI7B5dc=
X-Received: by 2002:a17:907:a4ca:b0:c29:f5d8:9c6c with SMTP id
 a640c23a62f3a-c46a92b9cf3mr393227466b.27.1792768080182; Fri, 23 Oct 2026
 08:08:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022232734.496064-1-suseendranb@google.com>
In-Reply-To: <20261022232734.496064-1-suseendranb@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 08:07:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM=CgfgbEVg8vqjeDTuiPczQxH8+QVjfX08Gao3kyEJCg@mail.gmail.com>
X-Gm-Features: AclHuK80QTfSTqsKyXHLSyku97K6opYMGbTo4CD_NKkEdMsbk2RcFAsJ7gpjO1I
Message-ID: <CAO9r8zM=CgfgbEVg8vqjeDTuiPczQxH8+QVjfX08Gao3kyEJCg@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: validate dlen and normalize comp_ret on
 compression success
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kfqbpq3gx49jsg6sjbjiagfhm9ajxppc
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C365F20011
X-Rspam-User: 
X-HE-Tag: 1792768082-571318
X-HE-Meta: U2FsdGVkX18Gqk8dtI9NGYnaIKdjhtII+PReaKvJCv9aRC0tcruJeZMDT23spYolQZmQyRxXgin9EuSxUj/Zwr5Ag3qM8B6TjgiSubzyeX8kg5aYWEb4CY922i3bIky+ZRy3VS76z+LtTfQviwD/f5rbNThxEhUXbMOq7Mpy2cOyfI2vHab/xuZaNj02btL0Gy+6YfcV3yYKwck832y7it+UKQE/i1Fxu70vhvT2R47ecPhYrG9Cz5k1ONHGx86Qfp4k9Wg8GGU+OJcC5yFVBSJhEPf5X6h1Yu+UHN07R1O0VwLDTXS03JXJzMkKgwTizsv8piqzsvNRqUW09jJe4DDlgUzcn+ok6A9+/df9OxmdpMrbfA1IH/1LZH8s2fNxLyDZV0anOtNbrxBDUmNNJY3DpGqiNMgTF7aud+RN52SUjbDPxN4DkjS/43T2kowB6GSH6R5sDrluXNSUTqNSUOzMU6mZgeWYBc5xaI43lhz84Qda25eMQstA0PHGxV/LgZ+Sto+QkEAuVERkYvmGePMGfn3ZeloK0lRObk9wLgwWRS5DQc/ME+ckqF8Uv5vcIBxe4yQ8ubUNLOgrJz0iPOP0klq/bBZBiyYE5PzmngMjti+4POxO5fTGxGoNgzbyVltLCLAfAMVMm7putoTqmJwblc6wEBXgWUh1kHKVsZqr/zlvosAljekkAPdHNmN+mRfffsXeD1kl14t2m8HMIS+pjgQRiKlvmadY/6i0O8Pfj5Mg4EMQOcnFihzcizzSUoTgwbIZX1NtElDeP5e0oi1tQfqQmRnkTJRGecVb3+3Cr/8icME5ya7iY3S+ZEiZ1cwHmHS0ylKtxUKakS4gtZg6q2L67TELy4BX3yxYG41ZHqRQwqVjg0/u++jAijhREst7VZkoX6zorCrIQdi4Yfv/FCnnVTLKVK4TtLjJY2ykvDODMe6HA38Ant5MtQLghffBuMdkC55mEFRo/AS
 0rc6tG7l
 n7J/zVdSMAkF1TFWL6oid/Jfu+ucdsYCzjUYW8nN4iyE039jdwe29QxsWyO5VMuqFNfk6RxNYBbJb6joELf1GwcWFoEjbMKxpgPwbpK+f0c4vU+k/cYHYb/8KUc933MyK2aNWLoWV6qHvC9cwrjzRh1gGdKLjxXPLe0daeJ8EuXQj3SKWPSuuq6A7eQZg7kRgRWqAS03RQm5Mg12hdQzie1Bti7CR4vymngukKzwzl77/UFeahYvuABJVz17QrxKUh4pjHeFerXk4aHNI5YmiGOizFeph1damIPpUV8TBUEXk6uWVWF0jEYRWDhzyzzz++gjzgsfIGPS9NVS0oHtpzB6oPgOB9aUaPuHJ1/6g1KmunDjAAgr8U+7xtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 4:27=E2=80=AFPM Suseendran Bhaskaran
<suseendranb@google.com> wrote:
>
> In zswap_compress(), dlen is only meaningful when compression succeeds
> (!comp_ret), as compressors do not consistently set req->dlen on error
> (e.g. zstd, 842, and qat set dlen =3D 0; lz4, lz4hc, lzo, lzo-rle,
> deflate, and iaa leave dlen at PAGE_SIZE; hisi_zip sets dlen to the
> hardware-reported produced bytes).
>
> When !comp_ret and dlen =3D=3D PAGE_SIZE with zswap writeback disabled,
> zswap_compress() sets comp_ret to -EINVAL instead of -ENOSPC,
> miscounting the page under reject_compress_fail instead of
> reject_compress_poor.
>
> When !comp_ret, set comp_ret =3D -ENOSPC if dlen =3D=3D PAGE_SIZE, or
> comp_ret =3D -EINVAL if WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE). This
> allows simplifying the failure check to 'if (comp_ret)' and dropping
> the ternary assignment in the writeback-disabled path.
>
> Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page =
as-is")
> Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

