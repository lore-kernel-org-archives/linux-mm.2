Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE7D606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TYBwJEbI
Received: by kanga.kvack.org (Postfix)
	id BBA336B05B8; Tue,  3 Nov 2026 14:45:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BE76B05BA; Tue,  3 Nov 2026 14:45:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34A36B05BB; Tue,  3 Nov 2026 14:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 718636B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:45:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4850312051E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:45:39 +0000 (UTC)
X-FDA: 85394837598.12.8F06ECB
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48AF6A0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:45:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TYBwJEbI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793735137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xrzu60BVjwa7oRsGi7Rx0IiJTLDYAKItXOr1GPbw5QU=;
	b=ty2oXbBkCx3r+g0Hs/6BA1wcECUMC9frgePX6KhB6qz76F3q10QGsVB98ywWwOrcCwhIAV
	Qw2tXbnf9NpZctxFQpfeOFQOK2A9E+AX9IHf9kFYOH2jiyIzRuA7ddMIv1QmROXVzD7E/0
	7VebU1+8g3IhTzIxNtcT/rQHKYma+6M=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TYBwJEbI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793735137;
	b=Du1AgoqrhumAqKqyAknvYIYRFjMWbvnHSU8wfeEuR4g9fWRxhCZ2gH17xdb4RQVnSkD95Q
	uZqYWJ/ckyqS4IByXXSkg1f0px24t0XYlxjuGd0uNTJYBufsTZmtElj5ZtEIZmQj/N5pUC
	Sk3wnQeELUGKIYJ9GCscMzgdl7Nj+ig=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a4dc547987so23266015e9.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:45:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793735136; cv=none;
        d=google.com; s=arc-20260327;
        b=LRvzKUASDX/yeTnrw7bPGNRiyth7k4/PaZEF1KTWjx0UYlvVvkHbriQaNzuTUycALj
         7uFM5wLmE/E4AUP59ojLolGbGb3FBjEGZvkF/SOo0XusDKPjylTly5TLgGgnLX7nF+YN
         4XHsyJYmacGXU7tMWsr4eLUtxH/i68PxKKh5vTEaASDsbl24Lr5XuES1z4S/q9dSg0H9
         tzBiwxy66SbkPyng7yE3uY256tjFUVfB2s/jAU2iIfwq0DieOlnzsKVeSTk2ZA9lnN5e
         GTpRxSYFiXigt/yyX74uP4I2vkcfuUMROK6ay44LFZzSjRtslk3Pjw7EW4JBhVOAhEMy
         LFSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xrzu60BVjwa7oRsGi7Rx0IiJTLDYAKItXOr1GPbw5QU=;
        fh=/77V2xw0QJvg8cAz1UQvhsqu10/G8W/Yy+fa1oo/k5s=;
        b=Dxaq2aUQk9G6iqfggfVyApaqLG5fL3nVsBjvrEZdya1kuQ+yl3ZGb9O8hJ4gOgg4p1
         JzQjBwzo9aqsig+vgv7piWJNhfH8LlLfLI8OZksDGKboxeYMC67zBzW5Koadv89VQ0WB
         hTgmLpOcXzLU7LzaS6DGnFINn5uCmKjvz2UDN0Zeou8crFBbAQZ8et3sosWx5CexMLNk
         Vkgs+OEKvNEUEcQSMzVMP2N/bx4pux+05si/r70W9yw6OytzG6RLvPiKbTltseT0AKQ6
         cqwr2a75YMXapM23KPlEZ1FiyY2JiCBQdwYbYoWhhTXNpnCRxxuhTjLv87WESkYOyy1y
         7PiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735136; x=1794339936; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xrzu60BVjwa7oRsGi7Rx0IiJTLDYAKItXOr1GPbw5QU=;
        b=TYBwJEbI1kRm9NEEESHdDOYjuTAZF6/oYnHFHCqth/uEnP4RcsRxD9q7CMBwPO7mSM
         ejX35XhwzilcWG0tf/JxlbT+zp7oYgpHQexwg6l/iBgk93Se+idEGTIzD0V5A/FbsOgA
         2AuROctPQoldKS86jNJYTWHG0BS7jLi+GKDe30jU7UK2npxWRbSD6TYTNFAh1nyhc1hY
         TJNvnDI3MXWMCQVeKAsB/T6Oub0ZYaKHNKAgwEAqabJ455LPaeeAjhY/s5FuBfSzwCI1
         dhT9lfcHizeaGJG0AjBC5k99UUu3zbq0OixtpSUi29Q0rukrq0ycb/ul0r3PHXPQjR42
         xHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735136; x=1794339936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xrzu60BVjwa7oRsGi7Rx0IiJTLDYAKItXOr1GPbw5QU=;
        b=BVGNr6MRfwmK1bcYF2icC2IIeECnmpMLNQMFUQD6aUy4Ucgn+TiW8skzG6lTTCb+09
         EQYwMRr2Hrs7GVds4+eTCL0HbU3T5FQyqU+cASYR3CGa2ZW3duDOiAz2nSxz2C4waSQC
         mSFs/1VqSCaJ7sdX+0sZ//TRToBqTDeLqh5drgJJyRBj9QNdipB0z77jAJ6AFiohFrnJ
         DF5KkHXctbWVkNaA45OfWqb08CCuATiHyy1iogTfZb6vokfGWP0qZVaGb5zsaXksMoT4
         kG6LcomoBS8yPuhU2wPS1SLzPGTTWZbcEeoh/MXNDt4HNxwpKwOGAzo3kWF3pTKqXN5v
         kABw==
X-Gm-Message-State: APuU4Z9b/sHiRohX2/6S0Q+mjhs0dInQm/qkmeJtWo0yVDEIylpamqsG
	HKlKSlDV3u3cifjqgFxYxvrPM8g9ew07WENHdtT6cJ8OmKSBpyAtM/fM78xd0HxLJ1q4a2Lg1Hw
	OqmeeIZCiZXRrSILIIaoS07DVdWNENDs=
X-Gm-Gg: AYBFou2PM5GPyWIQ+eX/qnZMOpGOKXtKMAfZok8xEuBL1c/LhvKpjAnRMMy//ih4c99
	J40JcQEbK1kOpGEoIDpY5RrCW2JLjdjBHBJjW9EX84s1gAw8jkK4HVJncr7KoERwu88r4h+4+ch
	mZoC/LoEnNxWBYKPMYiQT6m4TucHClaJ+apuAr+3h7vdQJCmcX+dVYkiRZ7SOvrR9zkALLO39fP
	DhVB4AIIFuB6Izr5jVMCd4nWIG6mkSR9Ywc8g3d0/jUkMynF8qoeNG9sgI2nF350F8ZY3wMll94
	9V1PBYm1cRSlDVMvpuo/AcVqvqkeTCd0SLItbN5Q4UgeBD0zWUgjji3HU6epN1MYLtDTXeJ0bIE
	AfMLZ8mOINN/XbpW0DREJwtsqJsK6eL9EHg0nSr9YGghkZvn7IK3A6VNJXYNqtxOg0hTABgJYR9
	Uyh+dcuLrI+lodw6H4q2nyLyaC73ukuhjzypt3K5l1zRE4myrvZwfG
X-Received: by 2002:a05:600c:a41:b0:4a1:ac66:6ac6 with SMTP id
 5b1f17b1804b1-4ac18c73d85mr309539565e9.26.1793735135531; Tue, 03 Nov 2026
 11:45:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com> <20261104-swap-fixes-v2-4-204be064be5b@tencent.com>
In-Reply-To: <20261104-swap-fixes-v2-4-204be064be5b@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Nov 2026 12:45:23 -0700
X-Gm-Features: AclHuK-8sWcwe4Xln3PaMip3e8lQ125iTg227I53p4aJzPC4DtppR-OvwmegPAY
Message-ID: <CAKEwX=O3DfyPNpujz1Uwnkaqd1yPYyv-PbwR6SZF6ABXz1X5Og@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm/swap: keep the swap-in pressure window open
 across a batch
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Usama Arif <usamaarif642@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Mani Tofigh <mt4022@columbia.edu>, NeilBrown <neil@brown.name>, Christoph Hellwig <hch@lst.de>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 48AF6A0003
X-Stat-Signature: rxa7iw1a6s54o9dmnqzrcsufdzmnj96m
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793735137-999716
X-HE-Meta: U2FsdGVkX191KrnlaSmQlgRR8mPmayrqNUXv72NDv8cdCHgvNjqqSYM3LmaEGLxPrvkGgG6CxoMws37bKtTkiPF3Yz8GALQYNg9AlWHuIvOeuJvaB3pJo+ZRNErDL9UR9X17bfOOB47nyU41uNeHs0CqJXhe71n4USaC5Boiw+F9sWLwSBX3V1Hvg1C6vkuIVSWynO3RqQkMmueghd3jn8fP8HLF84xHPPEy2MO/VM8HPVwDDJ8Vs4o31B92O5TRZou8eTjxy3Qz1GvkeaFlo2vYXeubV9Z76etsMTcJpESBopHpAbWi6Bweyf2lYjcZmAtv6SSjwSZF8DYDkYDLqBrfe226CT7nTW1C1k+GkT+vhOcOFcvdxAyYXeXeqy8L5jv+SO/D222527vY4BRk8ecbLlT09SnyAs9iBCiME7IMx6yW4oEzIWkJ4s753y9FkQoDvDz5pX3KrwIJ/+rIkIQG9tMvZfuGb4X1qr+x2kL8EDPKJbVPGbUDEa4H/6jYFE8UTy8gM3ThOvW3XTwiQztPGymbBF8bPlb7orZjdJDdU+oXRn2wCHvo1E+AUlZ4/HxHxrRl6vNhGflV+n21uyhkZNlrGUndeLlZvZkMeGGhBcNGK/u4X7pZEbm3/UK12waYKSY8mjUEvMpjZUHe7LkcKHabjDblcVGaLvTCWo3FB53N31JXDf58yr6d/8XrFSRBsXKXah4PxKucfd1ew1lB8ZttOqBX25aLxhUmHy/mk5/33uP1p+pxrNs9KJSQBhMSDuq/OqXl4eT6Q4+DDfduVMxhIgx3hVILjfB3/BfsggRcd+k7oOwF3diFRnoNnEY+yyQ3a/zCYYGxS61UuyJZia11K2TeDA1QRU5FSocWzu39waQ+nTR37T6nVHINtghJHpOn1WVUgwa72gIKDxKhblt3EDHFqG/0jcnVOuTUXC/koc82gpKqE0+wHQgx87rpRNvN2pv5KrTXN1y
 HIO1IIY0
 HsqnAlwDpgDFbtlAGVd5T8yIIL/ES0nlNObwhuYxB4XovxJ2P5FpKp0kTkiriPvrLRPP+NgetvclpkGUnRRMHgisJjkrU2GIvuXLdwxWuyxXKaWWt+0JosfUUsMKJOyxGrmqbHV4LgI3dFsIQEw3tTfUbKIzL5m9mDeudaqVuCRv4GoKuiPw+PMYyx24VErzNAVMFLxDbFsFrtht3FAq/b3qfIfhOXbZOsgXmqmrmxz6kTTQG0p9xAaZhzJ3T+26xmnlEtS1dLcBbBKkULtxZK9yY1qip5dSsI1Uvboc3+wjI8gCGxRemj/TDRREqgJmlwovQBGNJf/pJKxRjzVgYPn9Zg+ftjmqjr2ET7wMQhvy8Ov0JGGpbCjqwMpHY9NaxUPqMqZjZqIX1+c79UR8orKXf8LeiSbL8wgUNlh5aGqYzb22mcQYO7M3tR2UsFDDFdKfwi0jiYaAM9b3hgtjYdmIUPsaVs06ShbF4zTJDbKTxgc4v2JK/4V+aKe2AOJigBsED/WmUeIIpsbBwl4shfSMTDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 9:18=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Johannes Weiner <hannes@cmpxchg.org>
>
> For asynchronous block devices, swap reads are batched and submitted late=
r
> since commit dda8fb68b590 ("mm/swap: also use struct swap_iocb for block
> I/O"), but the caller submits the batch after the pressure window in
> swap_read_folio() has closed.  Batching is cheap, the submission is the
> part that can block, and that is no longer counted as pressure since then=
.
>
> Keep the pressure window open across the batch instead: swap_read_folio()
> opens it on the first folio, and swap_read_submit() closes it after the
> submission, also when the batch ends up with no folio queued.  Each batch
> is then billed for its own read.
>
> A single workingset refault marks its whole batch as stalled, which is
> fine here: the batch is submitted as a whole, so its submission holds
> up that refault too.  Before the batching, a blocking submission was bill=
ed
> only to the folio that issued it, even when it also delayed the refaults
> queued behind it in the same task, so this might be more accurate rather
> than less.  Synchronous reads are already one folio per batch after the
> previous patch, which keeps their attribution tight.
>
> The same hole has been there for a swap file on a file system that submit=
s
> through swap_fs_prepare_rw(), since commit 5169b844b7dd ("mm: submit
> multipage reads for SWP_FS_OPS swap-space"), which started batching its
> reads and deferring the submission to the caller, so this covers it there
> as well.
>
> Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
> Fixes: 5169b844b7dd ("mm: submit multipage reads for SWP_FS_OPS swap-spac=
e")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Link: https://lore.kernel.org/linux-mm/auOz00OGB_8dgniC@cmpxchg.org/
> [kasong@tencent.com: added commit message and slight tweaks]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap_ops.h | 10 ++++++
>  mm/page_io.c             | 79 ++++++++++++++++++++++++++++++------------=
------
>  2 files changed, 60 insertions(+), 29 deletions(-)

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

