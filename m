Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E93AC531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D38D6B007B; Thu, 23 Jul 2026 11:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D076B0098; Thu, 23 Jul 2026 11:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91EF6B009F; Thu, 23 Jul 2026 11:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B148D6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:38:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A6FB1C0AD2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:38:43 +0000 (UTC)
X-FDA: 85020448926.07.81EFF74
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D1E918000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:38:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TpPfRi6M;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784821121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0L6BTG4czRYdQ6EfwGUAWi2A2+4jjv2ECjLUnPT3t78=;
	b=jqoYcYzy44h+RcZXTLqlje8iFXxlU0iJZkEiA3AM0OiLs+47OLb5FTpCb9fr8ko4G2ZU2g
	HfIEyqglQLujVr6XsSQUTqDeyjQnvVJoiAKtLhuPAUL2s52lXU47HXm3cSlHH4IGvQAyr9
	CF7OGGcaIzo/Y8q8tukti7BvlZfCcO4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TpPfRi6M;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784821121;
	b=LErVrZnb2/PFZtDMVETt++XTLSnQ03k3XTDWDAyiTphwk+mc73+FconfCKeW5S7iOCcZ5/
	h+5ROBRM5RZ9bpZ0eHd8pwrehD19xf8vz4G5ckfJyB1ltpRipQGo+Q6P2vu8qgy32XQsGw
	JomQWcAM+JIY0PFOdihrc40cBxzGwqs=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-476a130c138so824243f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784821120; cv=none;
        d=google.com; s=arc-20260327;
        b=Pe5UA6rBr++61LxPiZMxK7Esui1bX4Ipk97kDE7MzqnmcErV4ij20oYKBalFUK7689
         DIxE9TkulqydVsaWAFODjdVWWKzI2Wtsl6hvWuzxKjq7DPkKpJ6VNqDHKqLVzJyr5Xaa
         TpvoRHD8mDCDRZ7OL/ldMUb5CuzGoXAuxBc7IlBWnLPBju4iPhGNVENB/Q/FwQ5bqdUS
         8xEGgC4koIr68SpzdeRRQRor+x2i45Hc7xzI6+90fF4z08rHZFxfaFwLgZ8Q1SgnuQgu
         fxhDgSzThtwYdeyJZVA5XHNgcv6va8JkxSy6wkUNu6oYpK2XQ1xvm4U0N9s5mjoKTarI
         jHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0L6BTG4czRYdQ6EfwGUAWi2A2+4jjv2ECjLUnPT3t78=;
        fh=VKjO0VF+O3iwgTRX5hRXQnjWxoPMOxc6kFVMFLxhC9U=;
        b=mmiYMPfLlHmDeqRh7EjCiRYW3htK/90BWwf2OQkzt+wJ3/2FcOL54H5FJhAwP0wk4E
         XwDH1RVpU5pfevONN3r27VMv+mrQYxKryWmO8//SxS7RLvzO9HV76+jeSb6M+NhuTEZD
         1q/pCL8vmM2az823a4bCObap62Vhvf4m+LcvXLRPOrVr6IgxVV0WG+Q8o7nSGZcQniIl
         rr5kw4UqpS9wgfIQIIrGB2vosFJZU0J+Q2GRACWu2W53CHCzq0NY33Imat00tRAsm/IM
         lHF4D1OeLTFPVr2R49NT8fZUijMgNUmG15+isjnibET86mOJ48mrEHjHMZ7vQmsUjGqs
         Nnpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784821120; x=1785425920; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0L6BTG4czRYdQ6EfwGUAWi2A2+4jjv2ECjLUnPT3t78=;
        b=TpPfRi6MpxO45SWyDuVpVJo0ydCunAwHkRXoLGEUcmjtz4OqUe8aX23pCpBroOu9Mn
         ILujWx2cm+IklW1b7mnDQUuAoj6cWg+a9EbvIlfoe3m6kPE0j14WezbyHmF5I0BGfj1S
         pGd4/7wfod8d9kG3Zlj0saev0jkRlE2A3sxibjYgf0/cIirspD00kPiHz0ld8NibuSDU
         5FfLUTdqAvo/iL1cEsWembx5kb7/XihJX3K3Mz+KR+ljKdIPRkd3a0g4bmm64fyctAHQ
         R5xsZQSlwKC1aGGRPHi/8wg8B/v7mZwm+J37xC0IjziCa1SVT1INLrN+p6MHwrVop1y6
         WFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784821120; x=1785425920;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0L6BTG4czRYdQ6EfwGUAWi2A2+4jjv2ECjLUnPT3t78=;
        b=ChE63YESy2b9oQhD3qdlWQbc8pZWjUg/Hu0iSfaqOkReegXzEiBJQPLv9YK7Kxc2Uq
         hwsymtFFgdFydNdpWrFsUbMtPC+hjpbdO9IUHe/NhlaXe28q1qW4QW27B5ljvz3EW2oO
         M6kiF99cGOOFNOurDiR+V5Z1xlUj+5gkXxHS136XPlCKtKK5WJaGLjTFJPH/lBsfdI5H
         O1v91GuPuC5UCxzDTAhVwjo/RkjPDj7iOADRIoumZ1emE1eijr8wg8l1z6nVMmRrvN1y
         DN4tRYEFnSVIVRQ7uOQOe6qHLJYdU9J8Xk/cH3FIBotc8O9CW6F5mPVikST3xvP8tiSg
         voiQ==
X-Forwarded-Encrypted: i=1; AHgh+RqIyxhtj+tft+ofRCjJzo9Ba3fgOVnV2meAUwI47hravEMD24Cotg/C91hGV6kormZ33c/bP2Veyg==@kvack.org
X-Gm-Message-State: AOJu0YxCruqBRNKLmiMcVqkfJFZeVriPicLBTyhgh8/AyIUE0ucjRWcI
	0MwoA5Hv+fZMAfUyggMkymv7SzvfZfksrKunUWfEpUIcGQWmgS8qaWYVIQa6mgQSoPEM7NadC0O
	0jknFlmGvY5sFqm83FAecn/PmBI2bagI=
X-Gm-Gg: AR+sD10iV/PV38Svi35Twd3TVbB2yoZN0LA9lsgPO+zA5k32jC2/yJ1yn29yIOWK1DW
	0VCwix/1UvScjAvSqBt0ldnipD/7i41OwIEGm67ym/npQ80V8HMFCmk7E2UZQkIyvkNulIOzIo5
	G7s72avxOxcnCoOXAygXVtM7ABD4QDjF3M/TyrHixG6RG/0sdbhSYKSUHOnIp+LsWZD7nZXpuX9
	zeB9x8ZqKI3g0PeutO1JdP3LZHbblLv8IzXkDlKX2J2yTeA6ZnENTcoAnrxpvmMovXjSTCo2o1N
	tJmMpBScDajOb6eJfw==
X-Received: by 2002:a05:6000:38f:b0:47f:6fa4:58e0 with SMTP id
 ffacd0b85a97d-47f8dc8cf80mr4468005f8f.35.1784821119603; Thu, 23 Jul 2026
 08:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-2-alex@ghiti.fr>
 <amIZp7Ual_6Gu86T@cmpxchg.org>
In-Reply-To: <amIZp7Ual_6Gu86T@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 23 Jul 2026 08:38:26 -0700
X-Gm-Features: AUfX_mwHQ3blZ7P6gvbmhVAOte3aZtlO1MRJXjAm_VmD80Tv4wDddJ9EXfV6VAY
Message-ID: <CAKEwX=MxufM5aNw2xW0f1UcyfcCJbtXR_u3cK+coRaC+_bLspg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D1E918000C
X-Rspamd-Server: rspam01
X-Stat-Signature: 1zj4yt7hxojsq48mm3kagt4qq88f6pta
X-HE-Tag: 1784821121-326900
X-HE-Meta: U2FsdGVkX1/TFUTexhSPTbML0yH1bUcN4+c4VKfF5cpNASWduizC/qausq8BiTxw+6ZDsmKYDH4d0LhofB7lvy64DfSQHwOrqVkvMapnyvXaG4csqP5nZyBKVf7joyfCU3Fh5N2n2PqOwFwGcmrU0dCXHDzv7ICWxytbmYBJfxkAS/WwnUqRDZ+0jBR6uwI51kogamCren+sv9AXLS8C47FvRqySpPFTwMRNAbCUvJd7lG5Y4D5mqfbl5Qjs/QiiKEFHf/NFDI7UznmX0xldJ9JVCiLc2z3thzZKtuPsZ55nsN9W/fyZhVH65ekWeCWsUEv7QOzK8Vt9eGv/lCN1oAx1udMcs7nUzPEicb+miTRnuuUyrYmCE7tpB9UhUhaKmRCede+LjZKgnbzOiBjMwz/MrdpGSECkT4PTw7lO6xqAUm7I9291W/vgcs1cAUuwdCQIFLyXAhVgqa1L+MXyVgjddvVzbqwqktPoa/QlNvSZFl9fusqOxiFzI9XN4bDqb1qSimmyBz91YprzQm5oROq9iZM5Hp2+YsU5Wwds4lwc+kVGCIukeMO+X0K2l0S1bZcrApbSwyCyzyJDqwFM54TrMCmcsMCD92Wky6g9XIek5R7qnY3YQLKMHB7oStWQffza0gCddXQr5kVV93iY1zJMM+h04/7nZ1gc9hPYGrJaD/gol+nQow9toojrOFMNfsZ5NMIHE9R5/ZggSSohqg1A+QDsfBmDsSUuy5NzTvIZ7/i5P1QbaCn7j1yipA3H2O29DRKzR4ImRiG+fSefTTDZAqytvsJgrGNFqCNTrKWVftXV8w0FIlarZgTZvS4TSD1cKq8+EbbfWd0ruBSHz6kDlG5D0eNAkShtr3rHOLy9/KWQNf512Cj8H8LJozxXadVFb8Ktr0kZUl9Q1A4tvm4xPC/A0ht+u4q2Kjs3l3wo0KAYgs71QtjuZIGo4PF2mb/qCO/AgW2rbjeOUpu
 q+ezngsI
 XgQT3/WAfbCi/fLjklyg0D3l5asgzMe10TKfHIhO6OV7VnC3/CBEbNVl0P1muGb1YxZGEyQS7X82/RkMl4xhUV7cbxeuIQ4pdglHPbLprTYgOsiQpmPr6eAexLPSO/pKM59w7++dy2upH4y+Kf2wiLg6bqjHY6Od0GSGgd6Oa1/Zeg2dHlB71At+C6ZoO8hSpErTjl37iLGnSrtj0iQIocdeC+Iuexo4680h91oxN148aXORe4YP8OqkxsKLzxCDVe238B3iGUv6c8/yGPgFk1tdYI3mj+5xUWc701q3LA1kXpr0QfxjkUTa2O/W0B8ijTBgoWFeADUKUV8y16mtwIczsc80J7WgvnIv8ava6q2I64d3Z5JXQmofUPD6rL6FmIe9nLkdE9tCAX4O2LmhiGYgFAv83Fk5mr08/x5RQ6CFXVsNiMf+vrG8O+4v69nNVlCNsfw9tZiG4TbBDa4rLWF5Q9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 6:39=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Sat, Jul 18, 2026 at 11:36:39AM +0200, Alexandre Ghiti wrote:
>
> I just chatted with Alexandre off-list, but this path does not store
> an eviction shadow like the reclaim path does. That means no refaults
> are detected from dropbehind pages, which can fundamentally alter
> reclaim decisions, zswap shrinker force, and pressure detection.

I think it's a zswap shrinker bug even before this patch. When we
allocate a new buffer for the writeback request and add to swap cache,
we erase the old shadow :(

I had a patch sometimes ago to fix this - basically, what it did is
when we allocate the buffer for writeback and add it to swap cache, we
save the existing shadow and hand that shadow to zswap. zswap will
store it in the zswap tree tree (in place of the struct zswap entry
that is being freed).

Now you will have to juggle it a bit in various path:

1. swapin has to check the zswap tree for refault.

2. remove_mapping does not create a new shadow, but instead restore
the zswap's owned shadow, if there is one.

3. zswap operations have to now handle shadows stored in its trees too.

I think there is one edge case where we still lose the old shadow (I
need to check), but the rest seems to work.

It's a bit complex, yes, but I managed to find more uses for this
added complexity too. With this, I was able to add more monitoring to
zswap shrinker - you can track how many shadows are being stored in
the zswap tree, which gives you a per-cgroup counter of inflight zswap
buffers. This helps with diagnosing when zswap writeback is generating
too much memory pressure with these buffers. You can also use this
counter it for zswap writeback heuristics (for instance, throttle
writeback when there are too many inflight buffers already and we're
not freeing them fast enough).

I have not had the chance to make it upstream-ready, given all of my
attention being taken away by vswap and other endeavors, and the fact
that swap architecture has changed quite a bit.

