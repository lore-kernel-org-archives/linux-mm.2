Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D63210F3DCD
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9362B6B0098; Mon, 30 Mar 2026 10:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D916B0099; Mon, 30 Mar 2026 10:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823706B009B; Mon, 30 Mar 2026 10:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE436B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:10:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCAE2160582
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:10:15 +0000 (UTC)
X-FDA: 84602913990.08.AD9F647
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id E928512001D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:10:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dczxyxg4;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774879814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xL8uHHzuWMbBwJ5+3HtVtL72FNsO/9cgkReiuuiZMA=;
	b=xTG8j4bKOlul3rubFRtXgbqDG2KBPLsCicnWfjw5sEUzbp0XJXDhFlCNdOsSbp01J6/0zP
	T4UYunuNBTikdrCX2XqG0lq3C65jwmFwuXU0UP2g2XRV4jUjMGysi/carexdBkhRRvj2Ec
	FTdtGrcGO65Y0TQPOdMukfHpOVfGXVA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dczxyxg4;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774879814; a=rsa-sha256;
	cv=none;
	b=OfOej59Dxr5Xkqx/4t/VVS5Vok9yImTYeKW1lR/s9sJ9jydi4FfjX4KYsb9VyS964VN1vL
	j2QHQnpISusHGu8bwXjnYsSrI/fvjbvXWPsmb4lvBdlXmdOCtBguOdLXzxPN6rlgoMJvJ+
	ABzir0baYD8oOKFPctLim3OR8P3A8zg=
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-40429b1d8baso1712894fac.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774879813; x=1775484613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xL8uHHzuWMbBwJ5+3HtVtL72FNsO/9cgkReiuuiZMA=;
        b=Dczxyxg4TOjVfas3igVrngQBuoMzaOGAm03YoGzsw+/1oWqTTbfVtR4x2JH4b26mNu
         NpKk3icQqzUl+sTWwPLT5LkMbZyV9V4gafZidAU7okf6K6nHTEjZxvjYMwpRr0WOxLmx
         oFgANmlP4BhChKEOPjtxLwMUB8OE6pTYbUvgrOjqL+ogjbOH/OKDZC7fSMYvhf/C5XtT
         /2qzJnyt9UlbinoIKiRPuUPosTYrrKHs6YEczStrDp/aEKtYFvX0LR3jJLxFYl/P4WJH
         eRO5GDtDskCUFdTgW+4GDY+2u5edRnwyja9hEz2LZpeJZAUMk4fA7L1VhdiVl9J+H1A8
         6j5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774879813; x=1775484613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/xL8uHHzuWMbBwJ5+3HtVtL72FNsO/9cgkReiuuiZMA=;
        b=aCqs/Zoq4/sNe84axy7nRefsRc3z1/B8ipP80IAl+9zEmvZ0j6upmFhPUg2XYZqmKu
         +JsNZDFh2+zwmFUivsut5I1nGNfBWcxc+ObBL/Q3FHqueb9ZJSgkZQcMDb3w+dm+fj6P
         R4c//crl9AmICV6XYEKuAYI+k+UhzpCXxo5Wep41+BGSk02Yf3h2kWQVL/NWDcYxlsYz
         x/tZkjqKYo9X4AhFtv1FZA0kqnii9QBdnS5pPCfDLP4leintg/B5Xwk1LDyw9LHHBjPf
         z7V4JcVPsd8xdhUTWOH4k+LORq7E7uj5yTUJYE8Eh5tXvvJ1HhgOiMA8qDSWUxRL2GJy
         FRMA==
X-Forwarded-Encrypted: i=1; AJvYcCXhZYoA8Z2nVw0CH7iBjX7ddE59xGma42EHulxaF+ywjANEbF3IitE1RgJFaWs9x3nhCNXx5KsFQQ==@kvack.org
X-Gm-Message-State: AOJu0YwPWaCj4QYI2soGxbFMmvfIy8OlwGx4kKsfoZY609GFlwM+6kso
	s2BRZMtAh5LdKbDh3WssTLMw+xAKQ0KyBuG2++cs/kdL8ABF0Cj/Zu9j
X-Gm-Gg: ATEYQzye7Hw6ODkVk0A1cd9t/eTNnZK9dGM9AcXOhWm1QPbrYHJ0Cua5E9ngK5n+4Nu
	DN9S6RBBvKdUQb/WQS8rk86Uc4TE/RzLLxDM+VehIiWYR7bFDNC9OJeLNU6DU5TOuOnQi9gLozz
	HXjUFPEgAqdKekhajWvYU+Yasoc5QNxU2f4umKvRF/cLhfFZJ1AtPVnu0znWnnJeFLt0sC2lCZK
	Q4SRLnUoyN0P0Cks0SKv05QGM9r7e+dkd9k/mkNmynymD8HnYE9dT4HwFppK54xT5FvC3nAy7sz
	Hz6QGOyuBOGGyRRHsF5mlso0N7+BQcsN5eV2HAMztDVfPa5HsjpJ/OE/oL028FQtbnRVHFIel+b
	3sudiqpLf3kqZ+3IPOJqoWUUE9lb3+4VW2yK/xBA6ou+s6EaNyALUy47NvPI2U17LNmJyMgDfga
	/kjKJmmwXceWRPif5laLTI
X-Received: by 2002:a05:6870:612c:b0:41b:e9c4:9778 with SMTP id 586e51a60fabf-41cec29a8eemr6470923fac.32.1774879812679;
        Mon, 30 Mar 2026 07:10:12 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d048e1961sm5508071fac.2.2026.03.30.07.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 07:10:12 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Mon, 30 Mar 2026 07:10:10 -0700
Message-ID: <20260330141010.3126996-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <acpmkY6_gWLdtJCB@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E928512001D
X-Stat-Signature: c3mowftkco3m7gup7dbyj5oznq8fi5oi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774879813-355790
X-HE-Meta: U2FsdGVkX19dQhOifA8aW8EK7v7wiCuztQGpVmYR1G0opjEf/wQtb9AJqhszZKBxcoyOLtBfFU0NKwPeYA570nRGVZo96FVwW/FrGqX5SHlJSQzQH6/GrRlLDx1+Xtdpufryj8g7yk/N/G6S6+pHes9HM8UzZzmA3lGfFKlnCIa5gD6sHoxDLUUeajqBIzYQquz1bcPoNIqcAYG2+sBprpHSudIRCRSzbdKze+osaVGVoYECvCmwUSegMcpEqWUEbzcU7iINLwRRVnw+hcpWSgMNI4EHU/wpexkLuzD05jVoIJfJgVx1xV4g4CEjhdBwIj3oYzUryazffZowlexSR2coRO3+DaBHH6wqVqe9KvMMci+46+wKNvDjewpiihbVkqJYbLX0+PBgxW+YuqsjbjAxuYMEoloURTOXbCGYrt56P92XoiOjPK7pzH5UkbBgEI2So6/6EhTLfkK3mPtyKfrN0kVMNER8h88I0bs1xyklxkFB7Kcyo9XIZcD7A4fNih3KRTF+/JmaZTlHq5rhw+CY6ji7SZkGDsZ+fLohFOVsUpZ/l3rJHlyN+v5xkOGpstKfyGBKBInZQo56R0xACkR+tm64HdB4MXZGvuz3dYK/ZzE1m+aRzBpBIOsTXksL6Y6ttm9NJHEOEo1DGh8ab0sFw4QnF4vYNkDZG+sD/Uw033IKlTxrmpmcxqgdfqWfHKILanaHwh5E9Y6aJOAV+XG/46mKhZHphTQ71ocV32+sHJfZyA9XtZpv7WsWa8/rRve16xMTW+tDxrlCVc5rV47q4CH1jf+g47P+9Bqag8Br6x+gzkwGQEZRPfQSuQca1/xIPb7kpYzna04RllpE2iTPTQ3CyHzkmzwRW7RZUbN4z7S8R+83FvPwv19Lqko3m271gKbjk/t1GM76P+xnFICYeBdKm5SVniGHRxuXB/Ju21zaPS8t9F50H9aWJzaReAFbdsoFD3minqD/82Y
 kMou06E+
 rxt0h7cYC8eia5z35bMy1LV7VmGIbl6UNUIt8wqPSy8L2dMlU/LBTK9CSgpbkOugIfYbjapFUoQ05R0ajjxZvZPYtdLJt5TmyersdOT7mHK41iGiO1pJQ3RRdlOt9kXr18dIRAq/NMTHjsbpnk9qLBSMbYkihPTie0giZnU1jexAwwiIpJqLdOgvZSNdPUDL/Exy1lMybWrPYQhSyOC2+FjhuBxK+VQS2LyFSJyEahR5qHgqL6IfoUYQvC0wGUpT7G2w0RvSRzvr631mWcDst9Q7gRxqTOqDhwXIw8Z0dukv0I8WyWVJlBha+RXRWCg8VDb+r6r1AWwS5qSmzmc5xjK8gCWzvJ5o3HkCo/nJ46PN2aj3TUR+if/wjFsGvOVhZl+S+hTHQacz2PePt6FxRgbIxwp2lQl7MAUos4VBtUe3gwxOTf6jwdFd5jJWIKtG80wlVIzorYrmXOeb9Jvwc/SnP7hOp+qyfrrV3R7ewYwF/0AQgkZsxkLFdoDCT/zvpJr/NTcjgu0zv6hEmw4EtGOhbYDzUeJ1NHK1Jv9PYhWS6WT1v7OdU8hna1JhBqiTsuWIkKsjCkphy+1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 14:03:29 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > to give visibility into per-node breakdowns for percpu allocations and
> > turn it into NR_PERCPU_B.
> 
> Why do we need/want this?

Hello Michal,

Thank you for reviewing my patch! I hope you are doing well.

You're right, I could have done a better job of motivating the patch.
My intent with this patch is to give some more visibility into where
memory is physically, once you know which memcg it is in.

Percpu memory could probably be seen as "trivial" when it comes to figuring
out what node it is on, but I'm hoping to make similar transitions to the
rest of enum memcg_stat_item as well (you can see my work for the zswap
stats in [1]).

When all of the memory is moved from being tracked per-memcg to per-lruvec,
then the final vision would be able to attribute node placement within
each memcg, which can help with diagnosing things like asymmetric node
pressure within a memcg, which is currently only partially accurate.

Getting per-node breakdowns of percpu memory orthogonal to memcgs also
seems like a win to me. While unlikely, I think that we can benefit from
some amount of visibility into whether percpu allocations are happening
equally across all CPUs.

What do you think? Thank you again, I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20260311195153.4013476-1-joshua.hahnjy@gmail.com/

