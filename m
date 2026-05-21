Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D719CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 12:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73166B0088; Thu, 21 May 2026 08:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23D66B008A; Thu, 21 May 2026 08:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60826B008C; Thu, 21 May 2026 08:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9F386B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:47:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E7931C1652
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:47:09 +0000 (UTC)
X-FDA: 84791402178.26.F4F6D6C
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 64C0620009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:47:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stlV2eyd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of elver@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779367627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfHkA0nrfTMBedFezUAOt262MiL/f21Ttj4Z491TkXA=;
	b=T8IQFtAXlXujWMrJ7xNwr1ZbZm8LuIAJLdzUFmHH3E7HYRAUJId78IbiZSNXdG0GQzG8Pe
	+qAGR6sJrWhow0KsXecHMNbTyS9FRrjitrhTOuIre3wMgoIaToqAEPFT95RAZky/akIF0X
	stGNjZALHpn0yEc3VOR5O8V36Qh+dKg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779367627; a=rsa-sha256;
	cv=pass;
	b=w7FxcxWuPM3wSmGBNrSRQz90Si9D7gs1zlyatKoJEvMiX9ZZu5c7an5VbA2m/4Prbzo2ga
	OAjnojMp9VTAHcw79Wh+m9STSaUiQ5QtusWvYNBRQt23DApJzPyf8Nm3h1/gJSqtlxInIm
	aB898+3Axj+t/PNCQYMqS9eDhCWWDtE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stlV2eyd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of elver@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-132d1b2519eso13418488c88.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 05:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779367626; cv=none;
        d=google.com; s=arc-20240605;
        b=cvXPYaHxBc+atgs9aSh3sjPpq/48pfZ5JTaee+H6SiaVBq3uqh8nHU3b9p0iFF4nYx
         OghC4QdPu3Fcy+fPn79RSqGH2jC9aTiGy7xiHlUCnOb4yF0qwVeMFhgcTtKPYctF4on8
         bTlDciWkE5QVEo8ILm4vVpEDA5y1tR0eG3U6k9Kn3sBDlIR+1HlOBTJFXcSiuUniuowj
         KJoQ262sXWT9y0cARZLdXHkaCjDl968VwJqH9E1bWQ39ex/AkC3UgUiPUr4msG5RDR9l
         3qWTrzcCWgSdtwyhpwixZ4Rxw+iUkbMjg0veWvyTNTyN1jUFAYwy7YQ32oMJuDncMb8t
         4ulQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bfHkA0nrfTMBedFezUAOt262MiL/f21Ttj4Z491TkXA=;
        fh=PSzuQc+isOCzBDYqStAcnY2sRnqM98JFeKYLtoLvNck=;
        b=PUXlHZxOPtJMrK9EDoAg0R+E/Xn95mft00aeDKpn7mae7nd7bj3hFrxjuvmRJaWepk
         AOoJNUbLfaF29xYkFFBYrkldSj0i0G/R6V0fWbUxZXAqmmhvu7ezvtKGf+1eogdlzcTx
         75aMAzKxBZJdcZdJPEWeCKJEJAq8J0YV4xWlDNtWvZLOq8DOzTYcTTFmg7y/nuS+2Cnf
         8zXeV6bqPBKpfPKxbI8q0XYN7WHLIX8WZ4Wct5I6lOmIEmidniSEL+cW/Fr0FdyCaY3m
         O1KwVbb4kxY3jKjKTSiiGfxIhRveH1UXfGHrxXWsX74/GRIYxDPLI6jMlO6JyunY0Uwy
         VhUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779367626; x=1779972426; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bfHkA0nrfTMBedFezUAOt262MiL/f21Ttj4Z491TkXA=;
        b=stlV2eyd4czljTK3frrUgBBQZM+EOc/3oDnFBSx84jxtl0to2E3ZMj+H9UgPKnjLVo
         90A+4tXkSIkphG9DJETvEKTY8m0Qc40+0w+qFO6ndhI1N2rpirMrQulvEnKwO9O5JwPo
         vQlD7LhfXlR3mFUs/Eb977fuBA3q7QC1ArmGU0UVKrmJRajOpbXvdAs/xp4K/suc2IXJ
         ZVsnOy+vONPZ42UA4jTCUhX7GTIy6AI6hnQurQ+E/qgqbUicLJh2twuLxs/PWanZTSas
         8D6jJ75jtohfyULuPSbtMAMW2zV8kYlxqAS9tOp2OuniwNxgDmsgBR76mWb/6MjH08zs
         K9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779367626; x=1779972426;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bfHkA0nrfTMBedFezUAOt262MiL/f21Ttj4Z491TkXA=;
        b=lSDE8l+wDykPcglwyO5nAgIz4UTwyIiTA1/qkqaN0phRWlVsbCrC2kJQiMtSjnOBLo
         BpV1+IDtjEekfWeNThcPhvuiaMNbngAeSkzXyEuxTuGO6PmucqZx80K3ri2NDqvPxHmu
         zn3uod33XgkGGgBLrJwNydJexH4ppHKsqdDCb6jXlVd8gZIzHR2D4r+0ZEvLLNBqs9Mn
         WRmcTE/CdiIkCxSVvDo+w4K44S22TIEPd//dKUxpkh7Lc3c0YP3pCv29NM80zh0SZxkd
         c5wM09uak6fLtQQdmZ+EmE6Z4TDERl6accNBmb8d03EJDMweRG17mlsHlcg5+95ZvA7G
         +/nQ==
X-Forwarded-Encrypted: i=1; AFNElJ+E8Fi0uriaD6/Dq0ZpvUi1udprjeSIoxNCSTPGbuB3MuZDjTprIA/+pPEdTbGSde83akO9l0w4sQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8O6gl9hlR0M6gwxuZESkuCbzZili92dtfl7SVVRQHWWEbyEN4
	WeuZ6lWv49gs4FHDTsc/K7rINjqONmmh2eE+EeCVGqpRVMDrqyo8wDm9j5CkCi2YjCG6/7NXsvq
	2VZvvaPy8dOeoD+U+NDccIekb36HnDy8KGR1webup
X-Gm-Gg: Acq92OEPXXNT+n8x/yHc5BgXQm+lG/R9ihfZKmeBMcKKSAhK2ik6FyE39gdA2Pw/nWg
	ZYxAJdVFJsdnOpb12cqdnDjtqhMQCjbR6xEEKVNIqzA+Av7qhiIShhw6hXl01962s2MUmJ58r70
	v2qResfWbkcQBbZ8NVj2kvvOtTvwe+E3HSL23c95dPswWVtzyY3rlGD/KbMqHzqUY0/Pur9EQ8J
	Ek7iZs+m2//TkXATWdMvV5+smP2A/F4wsDzpcwzDsd03pMq3wI8ziieHZUCDf5U9h3EVWKQMczD
	UhR6dPxcvrKMLznzHDHi8T3nZDySM/X33NbbfOqsFkb+Z4vE
X-Received: by 2002:a05:701b:271a:b0:133:54fb:f563 with SMTP id
 a92af1059eb24-13632d47501mr902318c88.23.1779367625531; Thu, 21 May 2026
 05:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260521124026.work.036-kees@kernel.org>
In-Reply-To: <20260521124026.work.036-kees@kernel.org>
From: Marco Elver <elver@google.com>
Date: Thu, 21 May 2026 14:46:28 +0200
X-Gm-Features: AVHnY4L3IHnERTLKoV3YcNfiEp2Dd5pISRDPTRx2YrQ-J231SBVM-n7vqCXkjZ8
Message-ID: <CANpmjNNPXZmabX+A=38JhTb6_rPWTvE9RfJGs3KiA3X6dthbzA@mail.gmail.com>
Subject: Re: [PATCH] mm/util: Use kmalloc buckets for kmemdup_nul()
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 64C0620009
X-Stat-Signature: jw1r1b1oruzsqkstbrfqrw398ws6fmej
X-Rspam-User: 
X-HE-Tag: 1779367627-131909
X-HE-Meta: U2FsdGVkX18ABpjfh+zVBxtiEOj7/u8mn7zoL2xDx7pRfkrLWujAj0z7rXLCqH5Iv5fBK5X5Kn8Wv/Umr/6Yt8URjFROn5zYKEpL6DkD72HZRIBLZJxqD1Miwtk5KpPOcdL2GjLOjg/I7jIljkidbs49TqxSERUZVj6YyU/pwjAgB7+PT9cNdnItJpRA0xgqPWXYaBUWBeku764EyusZXkFQL3iyq1ArcRzPbDxcfRs7lp50XitM7jRmyIQ72gZPC/Kjbub30GXtv6MhtB/B6iooW53OqlsaKwt99OzeSr63FFafW7ZhGHcJ5v/K4XNT9PRrYDB5rr+obKcWfMbXAQOmipixJfhiqVXrRmrJDzfs4P7eE//2IX9mjFElRVXrtJQrajSYV6iglP2g5GjzqOHPWJ9GKeAZ8B/hJLOaOqY9O0/0cs6xSK2iuBIsV70LR7C/jwqrf5FSGahUSw6E/imVWOTz29R4bYYRWiTFeYM9iV8WYlFCK5SRylTDjD3ErtMjm62OT5BzF5VN36ZirKOaf5SH/4qF8kf/7W2x4AP3hSrktwHfw0F+JyQoOwz/ZOz1J0wC1/2aak6T+H4IbYJ5EUWn/BU/QnPyK1/l5f06PZ1XEb75Ha5e+TN55nTjcAfTH9R1Nar4UYoAcNbIluVSQ3L6bPE2jbnscy61EOnaY5WEDbmiKJwRAaC8AXbFNbLpM9IGKtjsoZ1QXyp9x/yMUljOvvdcCokgLZeZ6dmxdwkFzk/fkuTBhhqjtrXp32gnt+d5DVj9I/M40skSX2oMJbTjWBx3rLHjQDtHWxYNSPP62NF8j9CaiEp9PxoKR5PUrqR85QfopfLS5U7OGD5VWb7nall6O815ulKSa48Ydsfl1+rEKLFwdOdKuVuekPgT08vMdrUOprTMwgaNy23HKSnDI7lGJobDAgTlJ4n7iWnbtq3bm01MbT3YbbAoGHcondII79qV523KH/U
 zhjKRPTf
 JqDh1qy7+oteiz8uWpIJnFjNgNX6HMT4Ra8wjhg10au2hhxmQZUlYv6urDJEmDs6zGPYzgZAyjsu0Dysvb7hS6REwBSzOpq9XvRWp1akSvfe4GXi8Ldw7sDI+wo9aIyfNP6Ldydj1KT6ZoAsiZ2N7KCY5hkU1bSjIGkFmsr7EqIjBcJIo6AJ6IQKwx1Bedap+gSuAt/4t09rqZkYLpZoCKVDB/XwcIHDX05uuuBc6nGxCc0J0xK+eHslIexjv2FcEJYyvFcvxy6JgYeDaz0XCyJTzt7xbnYWLfmqFfF2e8aPt5vGUgzqFukm84rQqC1Yb+BkCNsKUKW7PPu8F5QXf/T+N3bXewE15evGQaD1i1iM7oh+XPZ3kXPHLAMKKV8NcBfUAkjUwKBE2wPbb0HNnv4AaheUZUpMmA3vkwv66k9ufJzrPOC0KE2DsPv1Bo+Hj3D6RPVAc2YdEoSdk8gMrHHpCkUYcpC66bi15ou+Bk/TdSazvyAaWtxaeLv59YwP7BFXlFDZm1WqhbCtD1yU/4dkHxmRrGmkRKcA5xs0dueoUZvvwB3a2+ciEcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 at 14:40, Kees Cook <kees@kernel.org> wrote:
>
> The use of the kmemdup_nul()-family of allocations are explicitly for
> allocating NUL terminated strings, so these would be best separated from
> typed allocations, as they are their own set of arbitrarily sized
> allocations. They are not as risky as userspace controlled allocations,
> but these would be good to separate as well.
>
>   # grep memdup_nul /proc/slabinfo | cut -c-25
>   memdup_nul-8k          0
>   memdup_nul-4k          0
>   memdup_nul-2k          0
>   memdup_nul-1k          0
>   memdup_nul-512        28
>   memdup_nul-256         0
>   memdup_nul-192        60
>   memdup_nul-128        60
>   memdup_nul-96         60
>   memdup_nul-64        180
>   memdup_nul-32        960
>   memdup_nul-16       1860
>   memdup_nul-8        1980
>
> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <linux-mm@kvack.org>

Acked-by: Marco Elver <elver@google.com>

> ---
>  mm/util.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/mm/util.c b/mm/util.c
> index 3cc949a0b7ed..419269bb53da 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -34,6 +34,9 @@
>  #include "internal.h"
>  #include "swap.h"
>
> +static kmem_buckets *user_buckets __ro_after_init;
> +static kmem_buckets *nul_buckets __ro_after_init;
> +
>  /**
>   * kfree_const - conditionally free memory
>   * @x: pointer to the memory
> @@ -61,7 +64,7 @@ static __always_inline char *__kmemdup_nul(const char *s, size_t len, gfp_t gfp)
>         char *buf;
>
>         /* '+1' for the NUL terminator */
> -       buf = kmalloc_track_caller(len + 1, gfp);
> +       buf = kmem_buckets_alloc_track_caller(nul_buckets, len + 1, gfp);
>         if (!buf)
>                 return NULL;
>
> @@ -195,15 +198,14 @@ char *kmemdup_nul(const char *s, size_t len, gfp_t gfp)
>  }
>  EXPORT_SYMBOL(kmemdup_nul);
>
> -static kmem_buckets *user_buckets __ro_after_init;
> -
> -static int __init init_user_buckets(void)
> +static int __init init_buckets(void)
>  {
>         user_buckets = kmem_buckets_create("memdup_user", 0, 0, INT_MAX, NULL);
> +       nul_buckets = kmem_buckets_create("memdup_nul", 0, 0, INT_MAX, NULL);
>
>         return 0;
>  }
> -subsys_initcall(init_user_buckets);
> +subsys_initcall(init_buckets);
>
>  /**
>   * memdup_user - duplicate memory region from user space
> --
> 2.34.1
>

