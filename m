Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CB3BC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2C76B00B2; Tue, 25 Aug 2026 11:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793C86B00B4; Tue, 25 Aug 2026 11:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9916B00B5; Tue, 25 Aug 2026 11:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34E2E6B00B2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:51:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48F5D1A0463
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:51:53 +0000 (UTC)
X-FDA: 85140232506.30.687DAB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49C1540007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:51:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FNI3GGF1;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787673111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPtaLcz8oyqb6Dhnt8ZxpZ7m467rVFXuKSe5zifAGbI=;
	b=MGFYBES+NMxiRzMqwq6+erv4KtmfmirxWShmZMR0svsJCtxxm/MDfbccTHzQRZijP9mas/
	8779fjcjFQ3ulYp8BSL2M36Yp+bXlBfeskm3dzFy91cxrQZdy8TSRBg1VQ6+ZLx+RXosMb
	z4fHfqI846Q4LAxKJqVzkOeteqso/pA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787673111;
	b=lOevzckzlkPQKNGPVt2yFLzNqfhbDIOF3O6GOZqrKHdk7e4T8PjqzUHoRfLDl/8P5/jAaa
	w0MkWwOnqGv6kWMk32ZYqNCIx4r005Nu5VTQ6KeZpmMy+Htpb45WvAuunTSvNacMIm/3kO
	T/VvoStZ0WhV4alleOXRlvVQqn+zWnA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FNI3GGF1;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82DF84026C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5EB1F00AC4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673110;
	bh=kPtaLcz8oyqb6Dhnt8ZxpZ7m467rVFXuKSe5zifAGbI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FNI3GGF122n8Ouo1BdnWVvOVLXIfgPKuMj24d3XuOq0X6YPaYmfBIfHCkE9Ycj7XR
	 PXx+f16gRbKpX3HXReGVlVEKmNKe26KbRJppXsHS9PzJIJ49NYSKXin0zl8zlhcH9w
	 FyOuAXFNP7AQTddzt1tyq/Px7Y8fnWM1xqwuvS9StNL9ONOAubutZaahfvL3Gym7go
	 CczlWMp4zg/PTvblLMth82n7xyn94trwKSBGQ435QAWLGnjKH1LhFxSVE8ISJd5FNt
	 O8RvWMgvNTwsZvqGJ3ntvKthl0A4OxaF+1/LSdXMT9ZuWWIOPD3EM75EX8x+lh6x7a
	 B6TJUCRRZb2ZA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c197eaaab00so823054766b.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:51:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqh8hXz3w9rqAeJn7klaApZZhO8GVvu9VXVbITowd+M3qxzKer3Sx0YVvSQf020gvWbw2azA9RbVA==@kvack.org
X-Gm-Message-State: AFuF++mgc85kUG64OQPz1RvdFxWMgi7Efgw0c36xOPyeD0FZnNoOQsVc
	B5QgaA3HGAfuLJ29uOQWZLjDxBuq7NDAgvXaA3lUfooxQI/fT4BnvwygTT+Tq32UOB/8oF46TuY
	2t5Z80euKjsCZqOd0hxxDH1f6Q2gAAeA=
X-Received: by 2002:a17:907:5c6:b0:c21:96e8:578d with SMTP id
 a640c23a62f3a-c24e5fd3199mr1048498266b.15.1787673109022; Tue, 25 Aug 2026
 08:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260825135209.3135169-1-alex@ghiti.fr> <20260825135209.3135169-4-alex@ghiti.fr>
In-Reply-To: <20260825135209.3135169-4-alex@ghiti.fr>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 25 Aug 2026 08:51:37 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPsQ9J_mL-eYiNEZNu1LdxoVXL-mQ+=QMUvcT_71cf7cw@mail.gmail.com>
X-Gm-Features: AcwNN1VMT11QiZ3TZSju0-KhHsl-_5A2hhHloThY4_24fIsp40qg5IR7wyqhkq0
Message-ID: <CAO9r8zPsQ9J_mL-eYiNEZNu1LdxoVXL-mQ+=QMUvcT_71cf7cw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 49C1540007
X-Stat-Signature: g9ge5i8brq7rem6cox54z5roqmo36zck
X-HE-Tag: 1787673111-922355
X-HE-Meta: U2FsdGVkX1+voe8i6eBCPfBZ6fYFW+pXbJ0/hLs/GGttARCGyAtw21h21xlC2Q1oN9PrAUuIhwht9bnVydQTXEDIXGJON4CJf58YhhvLjixPFnDUdxSt81fVo1raxp2ulbmyTSI1Ao19uTTPu3+QVeNS892IYw8fBOvJXrw2bKU/hWyYRQKwwfUdH7iS766qjYwMcZI+ISuZWMXz8rQ7ByWBoyFkvd4XgWeuVaCmIiIoCrBiaa5hGFlZbLb5fm3notVhZzKVCPyiWIoQM3hT6Rz1xehjF0suRc9BJYuLq8fAL8dMFceWZiUS94UyduId5H4mP0wa5hYCIKnJGQ7b+++8bpaOE1N3eLsJ6hPkYj/0B9zpPPwEg7gwI9MB5mMpEG3rS8GqYC0l/01NOjuJN3y8d3H4hKK5hfDGQGd0A9JbERATikUMk5+CwR7RFLYbCrPv53JsQZJsOQllEkqn9YKvksG6Y69sSa0ilyxRMiMTHYjglsr3eo1OMXfF6zIBcBuco6X6yAelfJ4YzzY5qiKtajJ6nWdHgPxIFct/SCsVyZAPmLU+XQkr33hnheAiwgN7SkHWhR2vPWFGNx9eMFJasTFfEnF5Epeka3LL2GrrUkw3gQm2vJZnMr+eGCa2LMyqRURVHFMCc9kT6589nhX5M0dRnAL+McT1jiQpkXGrmRxhP1hTI0ioMbdFmcA0XVSY9Jo05ZvczWjibUbzN1HhIzhqX2jh5EFf9QBCZfmnnjw2pbZjl1WCWw98OTMusm9IpB0xe/PSZu9Rdci0WSG81Zt5BqKWAb341yQ4WzN8cwGbeyZ1SlXJV9zBqhibgrnwCK30ps1bYXvPLfhN7Bpo150/DxfhoP1Jpwt9e4BrOOcBQ5DwAhIbouaHcb+2W+904WkBmr88dak/eaKOEZguF11b17wZdJIgJ1llohm4xsLkmVwbDgH8zTNlioiM+C3xj7dq4fO5zqMO8nd
 FE/eaoQp
 Ohiu2W4MHgEm5PscWEWyCaHQJtyJtJfxwriPa5K/0WOaGNebmjGssxMrDufMYypguEs2QtmN07lQgiPyRYY1QOkVa5dW4L+C4/Bawq+SbUcYoS8xzNeCuqabIMitcINMzyzt6r9D4kwcrSxz5fbhUiRpO0wydt6WEPIAh4lSsdxJGt1uFyI0/VDxBoYXmEwk7ohHRTm5b6EP5hW8HjiCHSoxIGg0ZoGvLDxpBgVlE/37CswHPnIpBMlBSdARhR7UiygMqpTD0P2Kn2rXBbJD0rR4DbKIr0wfHvbFhBPnmX45Wc0VaurwgLdm5pVrlemrITm1klAiQYUSybdhChX/xHl9TXCKf6RqQ2seeqO4zmOUf0K3CTgAZVK3Ipp1dtuFye8cxTnO5MK1AiZ30GnLxohXvZyyxrOfi+CwQcJwgHwuvaaP9vYWlZ+7DKsPWCRmMVI6a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 6:55=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> zswap writeback decompresses an entry into a fresh swap cache folio and
> writes it back. The folio is cold by construction, yet it is left on the
> LRU for reclaim to find and free later, wasting a reclaim scan and keepin=
g
> cold memory resident longer than necessary.
>
> Allocate the folio off the LRU and mark it PG_dropbehind so the swap
> dropbehind path frees it from the swap cache once writeback completes.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/zswap.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8163e6c5f76c..d16822a516e8 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1013,7 +1013,6 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>          */
>         if (IS_ERR(folio))
>                 return PTR_ERR(folio);
> -       folio_add_lru(folio);
>
>         /*
>          * folio is locked, and the swapcache is now secured against
> @@ -1046,12 +1045,26 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
>         /* folio is up to date */
>         folio_mark_uptodate(folio);
>
> -       /* move it to the tail of the inactive list after end_writeback *=
/
> -       folio_set_reclaim(folio);
> +       folio_set_dropbehind(folio);
> +
> +       /*
> +        * Drop our reference before starting writeback so the swap cache=
 holds
> +        * the only one: the drop in folio_end_writeback() needs that for
> +        * remove_mapping_reclaim() to succeed, otherwise the folio is ha=
nded
> +        * back to reclaim instead.
> +        *
> +        * Nothing can free the folio in the meantime: we hold the folio =
lock
> +        * until writeback starts, PG_writeback then blocks swap cache re=
moval,
> +        * and folio_end_writeback() takes its own reference before clear=
ing
> +        * PG_writeback and donates it to the drop.
> +        */
> +       folio_put(folio);
>
>         /* start writeback */
>         __swap_writepage(folio, NULL);
>
> +       return 0;
> +
>  out:
>         if (ret) {

This check is now unneeded as ret should always be non-zero here, right?

We should probably also rename the label to indicate that it's only
the error path. Maybe "error" or "fail"?

>                 swap_cache_del_folio(folio);
> --
> 2.53.0-Meta
>
>

