Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B87606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H4+8yHtY
Received: by kanga.kvack.org (Postfix)
	id F25356B05B0; Thu,  5 Nov 2026 11:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE746B05B7; Thu,  5 Nov 2026 11:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD166B05B8; Thu,  5 Nov 2026 11:27:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C43D6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:27:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61D4F40B4A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:26:59 +0000 (UTC)
X-FDA: 85401594558.14.92FDA56
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59E80180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:26:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=H4+8yHtY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793896017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXKLkTKvc7+/XeyXcf3gWRNGXsSdWTTIZy4YnfMAbSg=;
	b=rXJCfgN8NBry/dIOPmD0twqAGTBfl1z28MSV8FA28pgiqsAQEGYcZ1Ck2JnaOF0k1PN/KB
	LCuRGn4PLkjcCYW4TOOJ0IzUV3UJVEIFBZjo1jfWFYarpRdqKf65479faKSeccYDps4idH
	wP/gxW7+3jnGsAqpIH33j2EZuwSsRFw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793896017;
	b=x7IPaCtzhB8cNZx0zZdoQv5/tNEyvluKmljAi4kMHNJ1zDX1m5U+539QHRK3fFwZ/cj+kb
	A3oEOS/gZD8xu7Q8quXCjruEOE9cElWmTNZXhWDw5COfwey1cABjt27ggycPwrvUhHy+UZ
	pBsdjj28yhh9ETYeFZneSxnrhAyhgeE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=H4+8yHtY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e00eee27dso1264560f8f.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:26:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793896016; cv=none;
        d=google.com; s=arc-20260327;
        b=ZAXJk2mvM108D+zfRSdfyLnrYgqhMWp+An9LkMqn0vl4Vh03WpjCtm1Or6QlCLjh62
         AD8v6z6ZeuC1K1ZistK2VkB4JGI3XTDMpt+2lAkGk+KvcEwD0j3FfPfOS+mXLHx1ulOZ
         n44CwgpAKsiJUhyeeV43XbALna0m0ISmHTnDBm8X+hdkBphg712AAKz/9aLtViQcoMdk
         BfJqy3TcF6KSoCjQHdYUEbCfezRhas1Hov5w3R2UqvrawDFoPeuE4DwPP+Abm+Nmz1Xh
         FunOzD3dAwoX9ukzd5impw05+Fmp8KsDphzB96dKcvH+egceO4TM9A5jmGahXwuYDlFy
         LMTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RXKLkTKvc7+/XeyXcf3gWRNGXsSdWTTIZy4YnfMAbSg=;
        fh=I0LqeFeucV6HMMup5PF0G7uNwPcyDqDjWjCinu+C+Tk=;
        b=GQonwuWGkQWusVS4akBgqBZVrcezoO7oEKJJ089JTdwOrXdHAiaBaaXQKtxcuGL+Si
         0XlYmkqZaUqmGXxRclcjdQ8+1kXqNUDewyicmiD7YYhfuKt/yVKvVEykbPqMVxcBTW60
         uQiq3IhGQe15nkXi8yrUxiHQWyMrBGulkOiJC/lLbhTL4G5wcuEMRHzf5BHr4ItGWlZq
         TBb2fCvDBlDxdRop++W6/zD6tvuUBYyfSS2TxKAGgBv9n8enT2+lD2ztY+CAnmh5R7sK
         vd9LenhO+F5MksXyxo9zUVKEQJqPA0BqNrHRBNM/isTGxNKFQ3NmcCnOAwwmsMw4J22h
         vlKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793896016; x=1794500816; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RXKLkTKvc7+/XeyXcf3gWRNGXsSdWTTIZy4YnfMAbSg=;
        b=H4+8yHtY+RfZcUBJ3pLSb9hY4AMKCW4mwoMFxapT2D+YybcumMTZ+sXIXXd7jUrf1G
         wV9CWkVElpuPPufn4MYwXGBa+ZdeespQKY38m4RoZrVWgQ5fZR0iA4+CJooizvflRwvt
         aqIBwdJ3ve1blGUbeMO4YAGTzx4EePgpmJ70o0mys69ZwgH3Y8qZkZcmNb+w+8JqUKpf
         TGb/YvBrf2yZOhbmUTf3KBwrtoiKCQDyKZRFfiu7aFzyhJzadAHkfMx5uxysE9vP+PHW
         JJlcwYSREK4M2ydjemM5YHMCaNHG1Mb8IC2vkSpuFcfAfsgg2ejjk7ilPC+ymbsBxA1y
         3Zfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793896016; x=1794500816;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXKLkTKvc7+/XeyXcf3gWRNGXsSdWTTIZy4YnfMAbSg=;
        b=jDB8moHfbCet3bGXIlkfk3IpQ3IBr/gXFuXs5UpRVBHr89/FB7Kq80dVaeyEwbSbMD
         2+HTE9zahf8k1U6CaBhYgnx7a4JlAYm/S3NJP9PBwXp9C1G3SPG0jNKrzLyl3MKHJbv/
         5QngbQa1mrLzA2q9RytGy0tbD9wrXNCyJiydYH1ECU1N+Hraz09ak+yHohboL3jmtGob
         cj9TDu5UU6LECeGc6LNO9uzYDRKTJoiUfr//TZX+fENmlDAJ5cJJ5KwjLPYPqQR82DpD
         RpXGQd83p4o+nxn/JcMEpEJrk+WcPpBh+C017iXfe8INSz28K3+BZY127HBt//0ma6sh
         ilGw==
X-Forwarded-Encrypted: i=1; AKwUvBwiC5h8CGg0FeigEWo4P0WKwZx84NwOjo6SnKsN7rlwgrorWQOITIGykB6njAPxMqXl4LyDX56jnQ==@kvack.org
X-Gm-Message-State: APuU4Z/VcoMu5+DrDnvgJj9gRAMHXujrXa9a1+ig1YaZlFDjsEUWV0pO
	3CfkCbW7RT8ZRFBfNETAWJLQ47EptkBjJI3qFpeyueMpBJ34WSPaRoWPMLrm9zDS5T0cFa+kOIV
	L1GdA68rwyE+szq+3OF7uWDJwTAhd2zA=
X-Gm-Gg: AYBFou1/38qvuT2rReDCrVzuCgvlqagjjuKpj7Y+/35h07tPPbgTk7o/rnvZ/7TTvWu
	cxyXTfZNwzqJecGeHUcRrn4YwLhsDewpFjsve9isRAcyNET+BGfUC5u4sTy2Q+TbRoRStMEgzjt
	AWfVAp0/jLpn5NzioMNw0/D7UXNyFihs+1tCCobNvHPXCT2WmDSoXMryOh2YRqI4ehTx9mGtXOW
	tPjRr/gmBtnw+mvPQFPP5Z2vYVE+mtgjM533jqfM9hXRCUivwgarpB2aCRxGc3jln59So5h2Z9u
	zu3sJOhkWO09yTO6oQ+TozN+1pQfTuqydC9KagvaYCiUwiaA7S4ofwNK2N54fJk7ZUNHK9vFpUu
	/mxNZUbPOgpjBG/UYRSb6c/jHq9CxustbtAhUZFxut0a1k08qeTYbDJsfxB3aw5iybwYd5n5wN1
	lNttGZCHXUCkmaPe8jAs2a3t4ojGRd9W7vHQrjYsDldkSA+fKz9J1O
X-Received: by 2002:a05:6000:400a:b0:48d:cda6:4dd7 with SMTP id
 ffacd0b85a97d-4927f78fe8cmr3795f8f.44.1793896015686; Thu, 05 Nov 2026
 08:26:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105155032.240457-1-alex@ghiti.fr> <20261105155032.240457-2-alex@ghiti.fr>
In-Reply-To: <20261105155032.240457-2-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Nov 2026 09:26:43 -0700
X-Gm-Features: AclHuK8sRHnPT3t5LKUKIDgVvInf7cfuedQZ01ChQHUhD1OG9l446H6tMb9bWpQ
Message-ID: <CAKEwX=ML2oK4+8aaz89GFNgq=AwmEdXusG_EtkDNY8cbLbGtAw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm, swap: only prefer nonfull clusters on
 synchronous devices
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mnin73mn9zkyncoqgxkwb198q37ukxar
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59E80180002
X-HE-Tag: 1793896017-210430
X-HE-Meta: U2FsdGVkX18EhNTDrKZPkhNGWL3HoaaSBVPcjnpEA09Kmt7/39hUyBOZhEEwQHMlLauCso2cBSIsr2RFiJ4mYu4k4mldrUQtt9HmN5l5RNZQzTdNt/ZSaKIgJc8pNFIaGjJqvmi4t98ZAUYmzn6GOm45RjCPClKuGpiBW/vM7p9ci+NXhd/HtxbpXbVBBqTPn7fpmDhEr0UT83yW7jvcBxwjWVuCSqjijgX6wJWQvoj0pMhVHZrJj9yreX91tsrbVlzkeJx/QvJEl9K+U+fq8Wcezr8EQ+yBge45/3sot9VWYEwfK+BEqKK5UNHkTB3FoleEw1AONIvTQwBRKuKaZqkSeT72ytaovlZN92Hww2asre9uqk4kW6LOGwnWXxZLTUjD7piWMqUq0oPb5aa7coArSqsmoPpJxqdOZH+DZFthxlw7+549tUfSkVw/zJRJj4hVPfSlyljlhxoHk4RXllHn/ayAuIK9iRVKiTcRgldLrxaP28XunXJOHBY1/MZ8ab3Unj7hrpOc7felpr5tfy/4oi31ggwqr7VyCTy6pQWVG8WBy7m4FsrypkQg316XnVUK8f0Niw/aNOyhIrW48GJ00A+GBl7JAYg/I8rPIYGw4pwi6yicilpb1p3XufoMq4LiYuvtZbOQk8OTWlzwz3aLrCpBY4e9Y2Q1Vid9neSX3z1tCpIRxsCNFAHODc3uTjjVjXs/X31RSjXvklBaMnt6muI4TjE3kvidW3dEUC8VfW1C5pQOThzZqLaSiQxpsLIC9q+49THisD+u8Fa6OxRa1HwkiyWxED8qdOnTvl2rUUyO8a8d1wLC/ScAfPrR6MzKIzARzi5Smq0aLA3MpXghLjKBgPALsmWq7EZRD5N/KxZKJHJ9Xue+RS2s8RkAujJ0P3OjX2slaIRNxrIYlV3fuho///hsQlmcDHTYFgXxoRyVr5vGOD/cV/nZtycdryDG++x5r++RFMx9NYw
 6qTl9M/T
 of3nrRGYc30rFNuA/5HQHsaa3Enmwcv2NMiXP+6zpZb4S6Ms11qonEpFoUvZPhHDnQnUu5kgQ4QF7RTqDWSRMfN1miH7c1Gcnzmr4l4biu+RPUaVam3e/IVbso9kwd1vomqON8zS/unNz0UbihWpnKG0v5OqfpnESEhm0IR5xloOmtr/cp2ZL3F4GVX1LuRe6vvwFs6kYDK5uF5SQhSZmNtVKEKlIvC6nmvgoaUpRgbOLrqDFDY2wPuR6gZwAvQ44JyMBxKkuMzVvK2J7uK09JP2H2mnGWxhsrWnhwcws14LGb2g/LIWWsDT+3FzoPtNQwwXzk69j5WcKiP0iLjA1CFYUhHlwuW3YyI92rVpVG6PSkW2fJ3B0+wRNN1ewddCCW5W45Xwm45VFi6DGzn3RVMg1GpXWYYEarr0gHKBBuUfMESwxbEF+XxNrxSPCLJvxpi3J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 8:51=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters") made
> allocations fill the nonfull clusters of their order before taking a
> free one, on every device without discard. Since commit 3cedb745d354
> ("mm: clarify the folio_free_swap() for do_swap_page()"), an exclusive
> write fault frees the swap slot, so a workload that rewrites swapped out
> memory leaves holes in full clusters, which then go back on the nonfull
> list. Reclaim allocates slots one folio at a time, so a batch of folios
> gets scattered over those holes, its writes can't be merged and it is
> written with many small requests.
>
> So partially revert commit 9a42aed48421 ("mm, swap: prefer nonfull over
> free clusters") and prefer free clusters again, except on synchronous
> devices like zram: they don't merge I/O, so the contiguity of the slots
> doesn't matter to them, and filling the holes first keeps the free
> clusters for large folios.
>
> Fixes: 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

LGTM for the most part:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

Quick comment below:

> ---
>  mm/swapfile.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 189f04d8838f..1c1b5d0b724a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -973,6 +973,17 @@ static bool __swap_cluster_alloc_entries(struct swap=
_info_struct *si,
>         return true;
>  }
>
> +/*
> + * Prefer a new cluster over a nonfull one if the device needs discard, =
to
> + * spread out the writes, or if it is not synchronous, to keep the slots
> + * of a swapout batch contiguous so that its writes can be merged.
> + */
> +static bool swap_prefer_free_cluster(struct swap_info_struct *si)
> +{
> +       return (si->flags & SWP_PAGE_DISCARD) ||
> +              !(si->flags & SWP_SYNCHRONOUS_IO);
> +}

Side note - I wonder if it's worth it to also prefer non-full clusters
for zswap as well?

It's a bit tricky, but I suppose you can do a best-effort check of the
folio's cgroup's zswappability?

