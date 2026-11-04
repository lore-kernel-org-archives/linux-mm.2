Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF15C606D80F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qE/M9CC/
Received: by kanga.kvack.org (Postfix)
	id 2618F6B05CB; Wed,  4 Nov 2026 06:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212106B05CC; Wed,  4 Nov 2026 06:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100E76B05CD; Wed,  4 Nov 2026 06:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2ED46B05CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:11:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83CF51C3FC5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:11:30 +0000 (UTC)
X-FDA: 85397170740.13.7F708A0
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96B63C0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:11:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="qE/M9CC/";
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dGhPXkF5fybGQPWWCMqIGqZtY7L/k+cbfx9SzNUbl0=;
	b=5V2XlRsWtLGyOqLUGglGHyf/KdB7jurTzXAa+TAZllnyqaE1kRuBG+N1i2X/E3bZ88So58
	yv1ShS8092MjlsQf9WwVlnbdczUUsbnKR4ouBvTtIZ3qndEObObNV0moRDXGaevtM6z7oR
	Sxqjye3Novf7ePZ8QrEz5aXsq0Bw3y4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790688;
	b=G4/lerVjkc07wR0ZwFL4nC4IvQVZlcA4lBhymDoZAQ1UpJ2dRojs0JgfLLXa5gg2ATSC9Z
	7uO/tWx9ztUQNgSHdk99t/ESttsQR4mI2+z1bmIc/V/Ug7KDOl0jCF+oXiraAjcNYMyC6H
	QrJO/VlMpWuR/WKOKJHny1+CgGgwRRg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="qE/M9CC/";
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso83056066b.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 03:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790687; x=1794395487; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9dGhPXkF5fybGQPWWCMqIGqZtY7L/k+cbfx9SzNUbl0=;
        b=qE/M9CC/XxzaANHcbVCQ1LhY7BnsEOqbWAcqu2fY1MdYGE6LU2Mos+8rOAVq91MHXL
         HiEE4lE91UZ1AkD7YwW/XUGfHAkIAQuN5qdWFFDgfV5r11QZCwRibmNmOgkHOYkgybaO
         3bxDgXQYG03rADC+TqHbhva20gfysLg+E8FEmhv5gJITygkDiwEHhyAn4kkQWHlW+xH9
         E1YwJ3IA83SeKAxe4zKYxr7td9CSv/TVqFv5AQekP+atPV+Nt/L/J42QciB+AhGzg9Wp
         SMxjzsNzAQhgBbcAZMdtx3X5iv0Io3kw8fzGiVr9wKV4MXgwaU1FD12qLpRxJZK4fAUh
         NU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790687; x=1794395487;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9dGhPXkF5fybGQPWWCMqIGqZtY7L/k+cbfx9SzNUbl0=;
        b=SfOit6+k2HPYe3HQqJPYjeyinUyF7dCC914qBX1Ftx0mp+NIJAujX3Y5ZkHZpcvGn+
         Oh/9gYH2lDtupL0nRyIu4RBhoqhNQ7hHSILEloxXa+HGBDDYn0pZ9ede1cXeTGA+mBuM
         4rte1XcTQS7nfZ0OoB/11rF7SH20OtkDcYdY4rcuZ3XMXKt+94kXXtj3cdEkPNtE8Hc6
         f2jcFTArj/rmrWLPSaW9mxJQfsxhHna0UCbq2cExHS8COWidt0LmmrWQfUfSeO7gXwx9
         P/5/BgR5PEoMpDplBujGh9Gh830w7NFD84/NPDz9DJqOQY1CE7ixyiY6hIh2tpl6KNa/
         pPHA==
X-Forwarded-Encrypted: i=1; AKwUvBycPG2tiiRuYLGhNwvmiyLC3dNgsGfiiSnImr9oNeAW7JKc6xE5Fm+L7J+L4xD1K0EYrlhTd9cPmA==@kvack.org
X-Gm-Message-State: APuU4Z/V+Fcz1Bgsit9fueSN6BlOuSuAeTv+Oj3F+Gh2O0/xQXkbkK0O
	G/dCItwY4fK5zQt8Nykb+gxFII534dbnioJ0uxC9sQOKRkt87Oj6KaNu
X-Gm-Gg: AYBFou1Llj8HicL0iAmJKcMY7BNHiZxixEMoA5Wsc1RAh8Z/i8kzfO3GpPv3UND1szf
	TnUxG4jp1oTWqq/skJqdtmZtR48jAmo5PuLRNXBk9u2iwCntVZif/+B9xWNXdNjX7ioPJ1fKLzs
	WxVV0X7Prg7n3scPr8PnNnvNxL3UhbLyjmnUQInGnB+jj+6W9i92+7qn0JtgytdtcI23vyfasXZ
	MzQTUbNkxKD/4yKw/ZMDkxDGz7J+HiLTeDwkg3we/mZzUMPslXJ+rbuRonrS6OSuOGPYiNK/Uni
	ETBI0jo8BejQWMFv6YczD/PRL+wWtfgpcw1MIcoKM7pHKSVY8IPorbwWbbG9Ip6FmlwIY4oi/aq
	y1cFPQp4sTyA3POERkUZNrzEMhoeKm7qROnHPlQ8biykh5yHOppGAfty+1WN4oAKgftHEyNuRWt
	3iFVoRAOJL5f3PXhi+UX79kpazGD1Q6z76RZoCNG5DyfdOtjjgBPxUYZmkIaaG9EITsee13S8ye
	28y6svirufAY1BSYznHZr9CfBzkEpep5azYWVPI9iq3t+BOivPfnW/EfLZB5dIyU0uzxdA7sMKM
	8rd6gSUaPx8wVQ==
X-Received: by 2002:a17:907:980c:b0:c40:36ca:9d1b with SMTP id a640c23a62f3a-c4ca7aaffdfmr1376456066b.40.1793790686850;
        Wed, 04 Nov 2026 03:11:26 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e4a4bb5sm55813666b.80.2026.11.04.03.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:11:26 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 4 Nov 2026 12:11:24 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <ausS3LQNkdc6lBy3@milan>
References: <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aurJZ81qnbiHH_P1@gondor.apana.org.au>
X-Stat-Signature: tar85ywch95r19f3mauhwnorjnuu3wrm
X-Rspamd-Queue-Id: 96B63C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793790688-370130
X-HE-Meta: U2FsdGVkX1/1mPJ+AATgmsi3EFjhOkHPCQsM/lQ5rXt6HWBTy7NIKO8Pago6tqHeHXaoftFtNJC0P90wert4SD14lcTg9QHI1b/BCQEWdPtLN+Im7Dmk3BAgwqtI83dLdLth5wgwhWgMIZFrr1DCWmQwfjogsKq8TzHmI+oZDfgh7bu21AvR2gdHWe91vRLE7g6tvA2AHV/3poC1DOFWuGSzbXtcCSkHj2VpPE20Y3YvlA8Yc2VQYy8wNDXKAI1hHbpekQcRWsHetKrdpOkk/jpGAQKqXKfSRyETLQacqcbN5Ag1D7TG/aRdFA2ygXsJ0qJr8d/cvAm4fMWKHNDtRvjH1MOg8Qo3wbF46nGZ119oCw/Z2NP+wyAvTLjnILaga3ErNiyJ+chvbttXPlupAKkb3G2kU8AZQIiRfOC4dfV8i5Qzs5kBazrU21ODriRbR3qFs5e9lnd64MrmcjNVoDvCLdXpPTBIZvOqEpUyHkbtMjXXxQ5JxiVfnitcRFapy+ZXBvbdZrtPNwnAVzjq/hq8yANZHM1cOU9ZqtH1L4YmA+uhDfOtqbMsacGK7v3PP+Tafeq8HU18vrC5y7rgsuLT0umlLsDZA/ncfTHFv+P+aMv3o4kX0bNDp+hhfXQO4dvs5NmNoEZsZAcUKngFzcsQ2ITUHE9lEbJ+WFUi1JeGUy0lSZlccthh1tEQadKLU5BJ3qAom7r9QaSudnXZ9iNFbP8pgzCcBLy0aKA7ktVgez8ELISISWUHn1fLW/ASbDHQUr6DEwi5y7PE/tmlarUoa6jM9KRZJyrMcyEbkdqpeEep31BM0/racDcXbSXcT/NGgMxf+nlHVLhTojT6aCxAHg7Qs4yDryih5Jx7HyLaAqPyN09KKX6//hOFVXO6lcBhfdlm5JNbSaXqgsW8qAapdB+v60ACkV46rt8s3WTgVE5DoQpOerTBRGC43+HLrhDAzWSBC2Hkzpgpe4b
 v2AI7lqA
 M1yZcQOGFSRBiW8MrGbTu6B6XyjgOY7NDiEjsZLK3qdFndWb3VchyRX91Ldp+PwmSxGTDcPTCepFrMjWC9h7KJLYwwsznRaIMU77XwOm8/yW6P8jkSq6FtC/CvcIxum8JSGcCKztBWBHFCo4uk8Vaz/aIbf+7gyt6leJE35RDZD2+zL3RD0KOZcHmW+yj1jS9X+eq3yFVTOQtOcYzoKYhISuXPFFbrNmEg+p0wp9EQS6XHpcq9QnbRo3JXWcZzElRGoDR9sAHVpMnkXkD8/qZJ0szSfsUTvDrrzVMYRvdC/grywc2DPPyhw4aYiKcHRnCGU/cpGPXgJxnuhJKWVil52chP7OcRbESAssWYPhL6Pq4qj+E//LhVNTPJxoE4n8LRKZb69uh+huFg1o1NU3nC9fZ/BelUnoqKorJs1ba4lbcvsV+HngjUdGdp6p3zPs3JWnMpEGDSdAIREgApNHKcxihkAF5HmuGlAPtRAAQG5UU/1AB+X13JtpVF5Huqnq5Zd8PlkZ9IK71V9UoftnG5XHGlTmzprKVYN8loT6v4uIPoAzWNNYkToqU09uXOxQAWhKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Herbert!

> >
> > None of that says why.  It only repeats what I already said: it seems
> > to be due to kmsan doing bad things.
> 
> Fair enough.
> 
> When I was told that folks needed vmalloc under GFP_ATOMIC I didn't
> question it any further:
> 
> https://lore.kernel.org/all/aeiHkG7X_dieMdw5@milan/
> 
> Looking back, it does look like it was never explained who these
> folks are.
> 
> Ulazislau, so who needs vmalloc GFP_ATOMIC support in the kernel?
> Or is it only used by out-of-kernel code?
>
There are users in kernel. For example:

drivers/GPU
    /* Allocate the file in vmalloc memory, it's likely to be big */
    iter.start = __vmalloc(file_size, GFP_NOWAIT);

AMD-GPU:
    kvzalloc(size, GFP_NOWAIT);
    kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
    kvzalloc(ring->ring_size, GFP_NOWAIT);

Virtio ring-testing:
    (alloc_ring(0)), gfpflags_allow_blocking(0) does not allow blocking.

net/ipv4/udp.c:
    err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);

etc...

Apart of above, the obvious user of GFP_ATOMIC is the bridge forwarding
database. The br_fdb_add_local() holds br->hash_lock with bottom halves
disabled, on rehash event it invokes rhashtable_insert_rehash() to allocate
a new bucket table with GFP_ATOMIC | __GFP_NOWARN. In that scenario kvmalloc()
can fallback to vmalloc().

This path runs and exists because syzbot hit the old in_interrupt() check
there, leading to 04aa71da5f3 ("mm/vmalloc: do not trigger BUG() on BH
disabled context").

The vmalloc() fallback improves the chance of completing the insert on
the spot to minimize -ENOMEM hit rate thus minimize queuing the
irq_work_queue(&ht->run_irq_work) to retry allocation in process context.

According to XFS code and comments it wants non-blocking support for
kvmalloc().

But indeed the v4 cover letter didn't name a consumer. The bridge
report came later.

--
Uladzislau Rezki

