Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E704606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fLdXTVBD
Received: by kanga.kvack.org (Postfix)
	id 5336C6B08AA; Tue, 24 Nov 2026 18:46:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B2B6B08AB; Tue, 24 Nov 2026 18:46:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA776B08AC; Tue, 24 Nov 2026 18:46:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1417F6B08AA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:46:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90C95120CD1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:46:08 +0000 (UTC)
X-FDA: 85471648416.19.2158908
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9DA841C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:46:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fLdXTVBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795563966;
	b=jLo94+hAL24dV0ys7/ja6029IT3rg8v/SUWkKkockaqgStyI8YQ3mJR1lEUQfDe1Ub7c5H
	Wa5ZK5SeH8X1qUjEilbZqWwSXNEj/8z18BoTav6f3hoC+eMdyIRiRiPkGEYhepZftdwq0g
	mgHUuM9Yp8TXD7jXUFJ8AO5bhg+J9mY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795563966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
	b=FbDC8fK1lY5F5bcWmIb8Hh3CBpUw5xycjCoyIzGvcjeHaz7/QfU2n+6RA/bJUUI9EdKV28
	J7ZAKLlgqY78j/eJTQyLovf6S6uij0Quq8TBP1IxwpYU4WrGL4ooL11tJqs7rk0TOxcxRP
	V8WP0/OkIMFhgRKAsz+t/sb904/iqf8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fLdXTVBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3ae25dcbd81so45343431fa.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:46:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795563965; cv=none;
        d=google.com; s=arc-20260327;
        b=swTw+yNVxmWAzZTnS7gJuvLX2eF3gYRznVfs7R5uzL4zGECKgimVhYCmc+ONT6L4vk
         uIidOOEXaFrBW6HEX9eGOMb8k+vgkAdjXHrG29wQpJPia5as0FKtt2Da7i48C9UH4k4n
         yCII1cWvbbdFoq3skguxRQba+Vff3Mu2pPmFucaPYaK6uI4NvLqrWJ2gmu+ULrxTfiHf
         gTzYYqAdJx7nh9V6rciStjKrnbv7YfECNzI9D3mcG+kqGRJSMQPh66+yaf+WToT1Isvi
         gg9Nkupz/N14FyIbi73zY+Bv2HkJf0JoY3g9dYgBHwllV94cWKLRpRTkE/aB0yCZ4CQ4
         DmXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
        fh=xmI7GIy35CSutxBK2dXMEX590Du9Ig2srKhPbap1MTw=;
        b=cLk1XszvKOMXvQeHYt0cHs24sXaQVz3xsqlUvKlNscHVKf1s64Xxq9IXvA9YHTPznP
         /L9tm+ZfAfuxRta32LA04jFzxUN+OjF5GQ1bAuGEstloSQOntHMTrclW+mwazIBHZdBi
         9OS7FsZNN7PTI903XIOsQnzrd2n5XocdH3SDozJc9Fv7IWZvlY+3ApyiE1qw39pmRqQS
         +92LleP3KBCGltQvgBzYsJQZ+SUvBMppAlaSIUGWKg/Mg0s43yWPVLxRqlN9YL4T6AqU
         3NzTzlDvnuqZgXU1DhiLrjYYkP5QG9rbli2STyQ5xV0qVCiovJ64bTJ/BcjwppySI8gN
         l/Ng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795563965; x=1796168765; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
        b=fLdXTVBD35CxaIUGCow8ZaePAgfihxwxsjz2+cagCApYh0DXkOxOMequ7rZiCQb4zH
         YRinrUk0N3AQj2WHNpGbMLjo+ZuFFewTlZlMOnjmE+t7Z5+iXb8G6c8Bin4NrHU0bPcI
         xkbBFmggg6g0DcXw+c4HQ1CLGP6/9WqxzKSjDGVoHILJ0W5VSY1+gffsgSqpvvvIJYTY
         z0Z3iDbnzqdpJ00TXgF1NiJifP1pwmITcrXstk/DqQPlCcCoW+4IpIYfjiWl+LGtKFU8
         zz22Y+ZKbLBEJpLq8mcZLNjOd0xFBZQhUZ6EramGfR7S/FRyVFt7HFipSMW/OV/XVmEh
         HyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795563965; x=1796168765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
        b=kUqzR+folNGpW0Zsh6MuS0bHrZtMWbHOjhBm29KYYq43kBzPFyIVGdWGQa8I1dq9jh
         D6t3FysFqJavKgS5lyWurIteviZ4P93znFLz7CfPw4D7uhE1agrPgXGrdqx9r/hEYNeA
         80UJpVW1OjVOQ9uMCpuXgWA3fb60AF9RqAq1PJ4SLAtVaRnSfyOjxsF01UfxCOjiAxA1
         2xHxZC7k/CnrYD1kNV76QRvNH2PC1dYNf6SbFuoqNAiuyU2/yVqpWjuYD0hjZnoJiL0+
         VxsWUCVzPo45lbpth7FAfyCGAKPJUP8ogr0FxLHZ2S6Za9nGuleQYHIvmXEQpPB1TprM
         mr5w==
X-Forwarded-Encrypted: i=1; AL+hErGQwjF571VbnuyNb6IiXvxiX7LHz+Jm/1REVeyHDfH0eIixi29jv/m0w/eBqBOOH6HSALour+hCqw==@kvack.org
X-Gm-Message-State: APuU4Z9/r9H7cHxlCWFc29ln9r2AbGVDzfPETF+8eQBzJ1aIRDlVhIVD
	EChk4c5OecBfholsCnKBis8Hd9nqXcBQFreZ1mW3QBBk6bHMB1ZIgoGKc6BO7pXQMo0IDgDH4ob
	llQoUVsZzQgEm/nlN2xiO4xowDI+HQ60=
X-Gm-Gg: AZFdTZfRXi0/8zMU7+4hYWPJJAobCBkWxPwlSobq1ScUbIIgX5rrnj+7jrmWrp2XD9z
	2nwWngiXJc+zaJQLshx/755zx7AZg9tKlR5DIMRwiKnZe8G8ZS17IRqEy5RvouDLRxz73Yltqu8
	MKhmn6R/PQ3mkY5B0lNJFW86AbbGutPsa9ggCTe/pBYE7gkJtmPj8+f42RSKT+/kpYk6fq74iaE
	OwWESXcWhxmRb68TUweiaW7UDlI+78xW7z/+Ad9pX+0ZcBa3rbJ6d+4rVAHwMttLwW7+wyT1GjB
	f86R0RjXAPJp5LW9fD1AE+fP5HBz90E3dBGi8kJ23LfnDMFKORxmDMQuTCNozWF78cwJ81c4Gr/
	0TdCtNRIw1dG/WCM4dioOrONrutLh7G7J5PRf
X-Received: by 2002:a05:6512:a819:10b0:5bc:f29b:1a5c with SMTP id
 2adb3069b0e04-5c1bc7d0b80mr3077117e87.23.1795563964504; Tue, 24 Nov 2026
 15:46:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com> <awXr6iHBR54wBB05@google.com>
In-Reply-To: <awXr6iHBR54wBB05@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 24 Nov 2026 15:45:52 -0800
X-Gm-Features: Aa3M54qHuVeAHaNbCxo4wz47haXUGhMN7-gFVY621Bx4vmN82u_-P6KIceLACFk
Message-ID: <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 9DA841C0009
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ypbskjj85u6eujhs3zamnzcq8wunuo6y
X-HE-Tag: 1795563966-127009
X-HE-Meta: U2FsdGVkX1/4kfG0R6XZIk3zOq49+5lwXFc5l0UePW0d5U1cd3InUCa0Zw/51nnHxIkwjhzQcj5d5AiDoFITwoycIit6W3tTmsuGMNkUmGuE7ovjRgJV5YltpOVxynJrrbDW9TjfeY5iM6t2szIemQRiyPDajQnPejJ36EzvrkuvU7maUoPBUNK7a+FOcO3AXmF0dusBmXZmKN1Ng9aZw4qvPPbaGLfCoOc3U4TrCGkGVeYz3SNS0OKrBJqJL9VvjJD3c7om6zEfBCWoO9G5PHlCXraoi1hsd1dEEllQcXlD76sBeljC4rXr7fm6DyxWSGsvBO1Xj1vXUhgfz03OUSZzUc1Zb9qOIdDKOqoY2LdKdn/JL5WABVLiwbqDZk0A8xpmLgYvlUxIxcejTnMfr6qjykpzVP2ngZ8umoyVxPsLuedE0pSPse7jh/lGOVamyn7x7ZHWBG+DSIwBNFXHN4QguLyAgevuq+cDA8UnFfD3lsY+5yFhzxqIHnmuATtWL6ne0vqWg1t+VNtgRfc0zWh0slL5tdM9bUFLvOhDeM7yPOvT8gbbjZGeGSdVvDpVaSloafi3oP9XNLfTjeHSNzWTWfk54lI/Uvhg6q6cjxRN7U00YTzi7Hr2hPYlcJ78GqCek9EVVTB8oSbH0O5+GX+jSl5N9ApcvI3us7neOKwnUEOCWAg8ur9gFkVwbfDTvO75A79LsDlJTjrId2jUv+hyHAIntjaUk/75qOg6KJIwPivUpf1dUi3XL8Lw5GIjcEz8SJRYFtQR8lsjtwhcSEx/JOr2FREzAhKEGP3i/NtM+TvkzsDeFsAie8Fi8xI+Q8LE5yRyZHqEr2dDBIwjI6JnKIhhAk16klTGLJXDN3WCk7+Oq2xnIdRfDHr8u1uEGJcGnddDK+7T5BcCL2KP5iAjJAcUZ+VW/PguJZMeqNYz0IahSO20WNgg711afPW37d3NBUDOVHT/nLqnZAC
 wjb5fw4o
 /V2qbcUM1yY0ENeJhS+r0e2hEgnaQuGYXDUZixu+GBgQtJbYuvNG05/UMrgU98xNuipQtsguZJ63viOKns75lZ3trfkkttXD+fzQn9ZZV28dUkG8a6ifuUn9mEJPTSn830eACppOEmnlW9IBaF7NKI9NLj5fjKSDFeZ6M9Fma/qIpRkE5hVAXSRYpeKUyXJPt3SFQ43/Clx8s05F8iyBoM1EySYcFDnhjY6YS4Cc4qFnTPa+LBd1rcBzbif9McOoxxzI+lfzY5UmA+qvZZkYIYIUKn4qkAtrUDKGWhgwdlIfe6w1nVdV33U4mlOZbCvdT01KqgwFOtXadeMunfBAfLegPZqq5kSUyfVT1T4ILNzLcqPk2GztywD11kFTnF49dvfOWT6w+uPdsU6lPgcItZ3ohbbFuyPqjVz+VvUvmHx4c3H6S0Sso3TRrRPZd2Y6KuVvRE64HfUafIFv/1J70D7LbF3CjLToNyviDbsBFIedmHNjSLoZzUf6+3hjkX80pG8MO8VBWmLAnLfX//qScJubyaeyLE6CQH2mWyCkP6sQiliIiFCXckmUMByRGXTEANRBrjG2gz5Id95hmJNRkjb2HNR+Zfy2M8RloxjFT44JJ1FE++31gNN9pca8xND3yb+Tm4ZWahOxraFyhdD5g8aDa6j+boMo0bkbeIwmbddFZ2VEzTAn0Zgr9Rg2OqvDu2wyXwQB0pMjYsB1ebtOskASddEmaYgdCyA6R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 12:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Fri, Nov 20, 2026 at 03:16:32PM -0800, Nhat Pham wrote:
[...]
> > Have you tried perf-ing the store path to see what was the overhead
> > source (before and after this optimization)? I'm curious.
>
> So I was able to reproduce the usemem30 sys/wall time improvements here
> on a Sapphire Rapids machine (both in a VM and on baremetal), and I
> threw my LLM at perf-ing to figure out what the overhead was. It's
> important to note that the sys/wall time improvement I observed was on
> the free phase, the write phase / throughput (which involves zswap
> store) didn't show much of a change.
>
> Batching made more consecutive pages that compress to the same zsmalloc
> class more likely to land in the same zspage, so the freeing path gets
> faster as the zspage and metadata are hot in the cache, which alleviates
> contention on the class lock.

This is a real performance gain with batching, correct?

>
> I think the memory allocated by usemem all compresses to the same class
> size, which makes holding the class lock in the freeing path a
> bottleneck. I confirmed this by a hacky patch to shard the class lock
> into 32 locks, which caused the same usemem improvements and the series
> doesn't improve performance anymore on top of that change.

I think we all agree that vm-scalability/usemem is a
microbenchmark/standard. I am not sure I understand the value of these
"hacks", when my patch-series posts data with the standard mm-unstable
and my patch series with a standard usemem microbenchmark.

>
> I also tried usemem with Silesia to get realistic compression data
> (similar to Kanchana's testing on previous versions), and didn't see
> similar improvements (because the compressed pages get distributed
> across multiple classes). I also tried a kernel build and the munmap
> microbenchmark in [1] (which Sergey quoted in [2]), which also didn't
> show improvements.
>
> That got me curious tho, and I had my LLM explore other optimizations to
> the freeing path. I think we can get similar improvements in usemem
> as well as the munmap microbenchmark [1] by batching zswap entries
> freeing. We can batch both the zsmalloc object freeing as well as the
> LRU deletion. I am still looking into it and I might send out patches.
>
> But I think this series doesn't really move the needle on realistic
> workloads, as I previously mentioned.

Your statements and hypothesis based on the kernel hacks don't explain
why I see 6.56% additional Sys time savings with compress batching
over the gains observed with store batching alone. I am not sure how
to interpret your statement above without your posting any data.

Did you get a chance to see the usemem/ZSTD data with/without compress
batching that I posted in [1], and my analysis of the breakdown
between performance gains from store batching vs. compress batching in
[2]?

As per the data I posted, compress batching of PMD THP with ZSTD
yields an additional 6.56% Sys time savings and additional 1.12%
Throughput improvement over zswap store batching. Combined zswap store
+ compress batching yields 13.87% Sys time reduction and 3.85%
Throughput increase over mm-unstable. I think this clearly
demonstrates performance benefits to a well established
microbenchmark, run at scale, using upstream kernel git trees and my
patch series.

I would appreciate comments from Nhat, Johannes and Andrew on these
posted gains/analysis:

[1]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026=
@gmail.com/T/#m33e586ec89ed46790da284e7a2f6d99b50c9f935
[2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026=
@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc

An independent replication of the gains posted by me in this
patch-series, using standard mm-unstable and vm-scalability/usemem
would also be very useful.

Thanks,
Kanchana

> Regarding the bpftrace
> measurements, I couldn't reproduce them. I think one factor is that
> probing both zswap_store() and zswap_compress() makes the zswap_store()
> numbers different based on how many zswap_compress() calls we make
> (which are less with batching) due to the overhead of the probe itself.
> When I trace zswap_store() without zswap_compress(), I don't see
> meaningful changes in latency.
>
> [1] https://lore.kernel.org/linux-mm/20261016120927.3191690-1-hongfengche=
n@xiaomi.com/
> [2] https://lore.kernel.org/linux-mm/20261123054746.2579253-1-senozhatsky=
@chromium.org/

