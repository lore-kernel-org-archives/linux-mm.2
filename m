Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5B5C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C388E6B008A; Mon, 10 Aug 2026 04:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE90E6B008C; Mon, 10 Aug 2026 04:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD93B6B0092; Mon, 10 Aug 2026 04:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86AD86B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:36:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 202AFA06DE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:36:34 +0000 (UTC)
X-FDA: 85084703508.27.EC46FF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4714F40003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:36:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPxT+DEn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786350992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKcSjpombA8EoTFPt4A4SBdVO6OcBscJAH1FyLZ2ZJc=;
	b=js+0h+fP3NET3tjHTNVX1+xF2yCwKgAt2PTLxJU9QfEIbUNrKY2yAoLT3CrgdwMgQ1fOlU
	qsMR5Bb65EN/C6jpQ6/NAQFoIO2jFymwCqCZnVYXRxX2tgBsi7DTCl9F5MuPwfgV+TaFAv
	+sbVG99j/p/x8R/Z4V+hoDJU4rM5lyY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPxT+DEn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786350992;
	b=dDzjkNAekHDe5EzUOhc1WUn8Z5hTQGS0yyzcYRb4LMqSpeh7Ft3txD7n4GEkAklTV9S05X
	yl8EalJ0N4GL+2NPfnEQZAM/QXptDAqDgULPgcXOYOHF1dL5UAxFuO48vy5kdCp9E/hCFp
	EJVrt4FI02PZ/9hJfpGSzXsttr1qmF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1E62601DE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB071F00A3E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786350991;
	bh=uKcSjpombA8EoTFPt4A4SBdVO6OcBscJAH1FyLZ2ZJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PPxT+DEnsl+J8i9N02JZ4Ci9TmvJUw8HUKAKvrfLnnzQdtDX3Cqq+6xWG3DXljFjv
	 vslwk/D2EJU+1yu4Takm8AwzRA4NcfYDi9VUwidWj5M8YzDBzNDNS3uSKMl8XFxRdp
	 t1AJFo/EO8+gaGj/JiFS410sqmEqJ31sqh0M57dtCh8VeVuiaLlOv6jVFKslMA56xj
	 Xz4/kLz8yNcZDaxKnoJxMCL2qeU8VuqOawLvEwBcTVz+C/Q+9wjn3NJsnYX1fVlxlK
	 Nw9rrDwPRozzkyoOTuVoal2ZhHHWcmO5FAC2Bkotwfd010xUZVI/KaPaNU/QKdRxdh
	 EoBNipvel8Kiw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e533aacf2so72385985a.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:36:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqRYXxexrgAtwXQlJqOabE2g9JQGj6bVxRsYdqXvqdg3ZqeiBczTkvCcQnioXQdh9daTYOfcJ63qQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7FsOFnvz6gCi3faAXShD0rbWHpzIBPNkz2yPE14GO1Gxk3RWJ
	LjlHJpkQbrlMe9V3pKJCZKZ2zkDH3OChZjeuXFEimT4L77booK8XHX2HZ0ruAJtv7RDfW4pJQ8g
	jgnMBqT5hKiz6uNUdF97jTltq6+h1DB8=
X-Received: by 2002:a05:620a:690a:b0:915:5cbd:1d96 with SMTP id
 af79cd13be357-93671f1a852mr2444324385a.33.1786350990936; Mon, 10 Aug 2026
 01:36:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com> <20260720-batch-tlb-flush-v5-1-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-1-db943a0d0d6b@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 10 Aug 2026 16:36:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x7W3Tgr_VNY+RLK_pXnFdehGGbjaVH29JsYipXGf7Z9g@mail.gmail.com>
X-Gm-Features: AUfX_mxRoFTLC3dtD1DDoLdf0jvSVzrRbtnZjsXds2hyokyFRa-d3L9CHAUZBRU
Message-ID: <CAGsJ_4x7W3Tgr_VNY+RLK_pXnFdehGGbjaVH29JsYipXGf7Z9g@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] mm/vmscan: introduce folio_activate_locked() helper
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4714F40003
X-Stat-Signature: dzpp3ifh1k8zmc9jwaxd16za5oa8478t
X-Rspam-User: 
X-HE-Tag: 1786350992-602286
X-HE-Meta: U2FsdGVkX1+VkveuWStXsqGOcZnZimWcnBbT1rSIOtkf1WV//RuFzfnGo4Rrg54viQPuhD0AsjZjlMzQQIoolFiyey+XcPp7Z+ejBn3nUWJt7cyNqEimgyUhfysvALGf7FCheqPzNt1mOyvx4C6Q3Lq5Pen1GoDtbuHrgpKruvguqqBxxczDQK8KdyRoIoNrXh2imSf2opZy3pspWaYS3+te4t7mFz7rSSlUQg8lhmJMkL3wl88ezi/O1UwJe5/1il3zpuN5Ney1xQARKeb972t0rliUThXDuWWB0GIb2mrEWAsgH91lu8bJHtMmtItiXPiaEuVq6DizAN/vgHOXf0IRudAKr3UFti9bPsvvg3IH/wb3NFJBZ3xVVH6LltebSWu3ZN9vMjUy0rx/QlPVCA2lfJrbtKAnmklqJmewnXsKmoXcgVtns4LCXtpIMoMmxYr11+YXGEU2j1++k2pe1fMkUsbsTtEfvVNm8mWfEBJ5BVNbjm3OYKwM+R0nEYwX1VTLLSieEir0xkrTldf0MhgR106kGAJ3d+gs12zNw05cZgHPGgN4VKGfF+2223x/ilf5G0WMVN+Tmr5ImSV6JIQp67A9ahnwzewl97EteztgN+Oiq9uLkEuVuIz5Y6UGQlIiOfOG1ycdrfCdBCg3jQzjFBIv3UUbmK8SkxNSUiZcYRGWaXDkXHVodRxK3s/AR7dIq4SFkTgn6jj5eY1GcGp4cIrpH017puO6s+jqGK941vk/BBOR3QajZPHvwygw+h+TVvGFx7IRHrY9ac4ilThGpsIcsqJBE8jZPA6hyVKYqIVUylqK0rrujJ39v1CqI3JY5KGR3bmbbvDFmVj34QZmxT4+7C1yloI2UW7m2L0CS1TUoip7l52aDzBLbh9i9MtWXd6B4MMjFK6kFofqJYWoq32CuZ9VeNDQ0THzs11gZPKqqEKdWGCj+m0b7KTxPsKwl2jUMECiGgZB0vH
 Y8iS0tJ4
 7QNBKdXq1smqCf/MotUwqQvyIIbA1JFGcJfiAStMSRr4lijcrhw8OLmAyZapEAAe7/zXh//K+orqIjOaAGKq303sdp8UmoDt0Q1EVigMBEXc6HbN8TpR8mceMw7CuLG5PnRlYIf+IJiDyvd/7huQDlA+mSWDJaFF4LOANzrNNs62UzM1gWRUJ8h0sZgjnMFV+MwU06fs2LSZlk31CPKubwcX7SEPbzV3y5HHPrXQS4Ee8bZM8EWQlRCbZp73X8t9BuT8jfkU23CMJsxIWhlzOfsjxwH+jnZKTAtM3/Os1yTZXtKHmgHmKap91MD9xI0zv+HqdzSzoCW5P1dtc8b4/S1mujHA0n7ruG+q59ewFx73eU2khYvF5VjtW1Jy7QG0or/mQcEuy5r4wEJ1QKq5QJBiP3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 1:08=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> The activate_locked label in shrink_folio_list() reclaims swap cache
> when needed, marks the folio active, and updates activation statistics.
> Extract this block into folio_activate_locked() so it can be reused.
>
> No functional change.
>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>

Thanks,

Reviewed-by: Barry Song <baohua@kernel.org>

[...]

> + * Prepare a locked folio to be kept active rather than reclaimed.
> + * Reclaims its swap slot if it will not be swapped, then marks it

I'm not quite sure whether this should be "if". Because, it seems
to always be true up to this point. BTW, if we really want to use
"if", shouldn't we use it to check whether swap is full?

> + * active and updates activation statistics.
> + */
> +static void folio_activate_locked(struct folio *folio,
> +               struct reclaim_stat *stat)
> +{
> +       unsigned int nr_pages =3D folio_nr_pages(folio);
> +
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
> +
> +       /* Not a candidate for swapping, so reclaim swap space. */
> +       if (folio_test_swapcache(folio) &&
> +           (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
> +               folio_free_swap(folio);

Best Regards
Barry

