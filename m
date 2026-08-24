Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7C7C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C5F6B009B; Mon, 24 Aug 2026 12:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D8D6B009D; Mon, 24 Aug 2026 12:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5B06B009F; Mon, 24 Aug 2026 12:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5246B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:31:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 088DE1201F6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:31:36 +0000 (UTC)
X-FDA: 85136703792.03.840BED2
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 15C1920011
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:31:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lR0HAzuf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787589094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6jDXnJz5bszG8pnLHnZK0KeQdaX8tcSfusG1JTMhO0=;
	b=cfDdOQyGCQoGylvmdw5EzY8NzwvC/W48wPoxMg6HIlXlkcn++J1e2A62inIyg07+xvMFw4
	hbRWEPCl50rcvNKQwijgVoxkCutKL/yTyjuCVSgkCxj9Z0fd8MFHAjYJoZAGApIVu408Nz
	IOr2yDQMgisiGken/zBXf2+jKoEHQXg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lR0HAzuf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787589094;
	b=MBlQCtZJsMdsP6js1iL99FC8yPFs1XVAdrVkGSKS+HBqIe2PGjqhtd1Nn0vnQZD4ZAczuv
	oPCKOyZJo0E/+sjoLyVYqTq86ONMYp8ivEK8+cq9Eo4bDuESg5xSeYJDRiFfXVEKPHK6hD
	KtxAnwgxBQRn0nsw8hkbtSYhM3ZaFa8=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cede6375caso195125ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787589093; cv=none;
        d=google.com; s=arc-20260327;
        b=l2npskzAYCzHB9g8ekwTqOE4N3lUQvfwuK145X5DlR7JY1P5QZmp+v6IcJ9JDf9Y+l
         QsbmKl0Zyzxhjwx4KQ1Wa8Zinb8YmIN5wVUmKfp7r0AVDre7ZK7coS2Yq4bWNjugwSa7
         qw2vmahPqfHvohiyAWdw2RZbzQi66cEI011ukWyZsFg8gzNPe6JZtNVOXph5M9SXPfAI
         kUgdwq7S6LNIcj4lP4+gz+QtIw9znBBFHjLK4AMMaFo6ByzX2E0EJkcxGdpPp2vTblqu
         v/JFXRABPiympcYgJhqhwjvYd0tRFkwI2xW7t4Bs5r2Xf7v8Eud7SRZHnj9qIK6TFBlz
         WfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q6jDXnJz5bszG8pnLHnZK0KeQdaX8tcSfusG1JTMhO0=;
        fh=XhMqX/XQeHTFgxHmUbaf8FW/EG5CCx02AhHMPh2Zs9c=;
        b=mmKsjIU4R3hEmoUCDnTh8ix/xdWHKmpMdcRoJ2tyY5NVBpZzaP9qS4VV6D+as3BtEC
         wJQvcPgZQBN3+5zTZ5VFTGIT0Clx73aySP03wuPlDABBxRjmHWGBv74Ujmks4UC0MzRR
         3Wvxs5af2QK/IhA6Os3tC9bRtlyQmxPQAWE+sKWVyR531dYpczoN3ls5wLXFpPGyKWUK
         LcaY+z60AOiRKZrnftobCfiNConH/ZLBBc9vxWLKhf6JyKTq5dnqH9X16QdorLIVnJ+d
         02VkP6htZNh13aXiiVrr2oqUI6qoOKWBPgk25z5Cc1T+0IC1qjXH1hkrtKYBnxDUos5g
         +MwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787589093; x=1788193893; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q6jDXnJz5bszG8pnLHnZK0KeQdaX8tcSfusG1JTMhO0=;
        b=lR0HAzufrxRVIvQ2oCMN63m7V5ySun9sJFnASWeSP1mO3/9qvMbyl3v7zQ0gpwkXAZ
         4/noz33Q24S4ylMhnSbG4fDK3+pB3OsnFR6uK5fT5Cavh2WDzvg+OnAd+SAbJ8bd3y+P
         /Emtpj3cekeLL3bTs7zJlFjFyNN2Gxu73QdoI5MAsUiTItKOxA0Q8tUTp1jJGhzaayKs
         ufgmLLtL9NZ4TLxx/TxQh1XdcvrX+47QjSThY+BHAllRiMz0CT+9wgUdQ2TqUVoYairV
         OeajZKapQy3E+XEcWsXwJHJTUDvxPQ4RKrw8W+mcuhZ+49LVr88Z3nee3YSJFYv6UxlY
         ZfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787589093; x=1788193893;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q6jDXnJz5bszG8pnLHnZK0KeQdaX8tcSfusG1JTMhO0=;
        b=c98pmKtvYWqMjhmzXvoB/yz4sjOUfn7Wo7WDE6NKW6YS4mR68kQZXhP7FGazNLCNjo
         8Y3pUsQy5VIVcH2Ls6gxBgAueugu7bN2iwztkihjIkEe+C7tJKbB1UPviSianf/yPQC7
         HNQzqWKO5z2b4ZE5yLQDLzohZJfGZ7rIV3zmmFWsblXzXw6tIp4KwimZ7Z/F4bO/jWL4
         bOoHDNBCuc3Ovie7wR8lYCWWvehmb+cMKCA5nY2tbnjZBab967IMrzRW5IsAWUiLBeV0
         Hm7TzH/tm33Gc28jMpFmXpOhlb2wYj0Pui3w0zNiYg3R0uol5p9DCWXR3P8p0ZOgmiW+
         bmCA==
X-Forwarded-Encrypted: i=1; AHgh+RpViKTI0mDOwAz1+MDjjptsqpucgy9mq0ZgsxWiSjwPh1kB1C/OViPz95HisL8G1PeE3oxv/VdgDw==@kvack.org
X-Gm-Message-State: AFuF++nIFXryYbeLxQKQBRZGn1u5fo4EKBpD7wbpl7R40EcXmgSzYa0o
	9C0F25Q/Q4U+cxEtBP4imCZ1K/gFRPq9geFUl4/Bu8gmd3BZfKR9apUl5/5mduhT0NArzQaEYQZ
	HGQN1e37tnWiUsJF5FerYYcD1UG5tvWpJGcSebbLo
X-Gm-Gg: AR+sD11eHd09zzUHfVgrvKDJP+mS/k8mMzmWGrKb+zwRaa+Ppcf5ubohyzmZTGKP//H
	mhTTgfxCsQA7/k8OFAiRBMCM1lCu4EJGGwnJ39uK1HfBx0Tq+JhUbNs5pkhvHrnITu9hikssjzt
	FksBdVRYj/JrxnR1l7qih6CWlDtap/KSzi6HT42C9q3P8eumnAL6BIbyK6evl+jEIqEnG2OVQH0
	lQMlTws6XqsTgr8jzCuf5THnSylfplKH2jXcmfKV6HVDZvSpYvVyaZPqMuMvv4fYwoL5iGe8i8e
	9qgZ45/HlSP+mG/5iAyg4mpKGXHbQBZ0WgZ1mVXLqjQjog==
X-Received: by 2002:a17:903:3c4b:b0:2d5:db3d:1a45 with SMTP id
 d9443c01a7336-2d66ffd7057mr11511785ad.18.1787589091990; Mon, 24 Aug 2026
 09:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com> <20260824152932.1583506-1-lrizzo@google.com>
 <20260824152932.1583506-3-lrizzo@google.com> <a826c7cb-5e77-4c21-a649-d40a9f0ef564@arm.com>
In-Reply-To: <a826c7cb-5e77-4c21-a649-d40a9f0ef564@arm.com>
From: Luigi Rizzo <lrizzo@google.com>
Date: Mon, 24 Aug 2026 18:30:55 +0200
X-Gm-Features: AcwNN1XmT87hJkoGkp9jcEKvjnY9kL9lu9ePxKQtYVAUZgS8n1wQenRujPZyI_4
Message-ID: <CAMOZA0JstwiwoWFuFjpoC1W12ir2b=SrWPO9i9tto1rOksKGgQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] swiotlb/mm: Implement SWIOTLB nocopy page allocator
To: Robin Murphy <robin.murphy@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Luigi Rizzo <rizzo.unipi@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dragos Tatulea <dtatulea@nvidia.com>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: rzebmsieq4gykg6a5j3tn5xx5johfryd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15C1920011
X-HE-Tag: 1787589093-425260
X-HE-Meta: U2FsdGVkX19dzYX2nQSLmsW0XfKuMJKDxX/F+3nObBhLkTnN1v7IYlTcjmXL35DAdws2NtibEViW1O3Dp+CIMlPXu0jQGpsUBnxvypZL1fvJ1ozvWF23+/jJcNlx5QY02Ju91tQo4xuyrv+YjpBzieh76PyZ0cnLjvHIeiZ18NSHoqOem4znBEKxn9WXAFkE4bKLe4TIgznAXn6asIjC9RIkoS1jK4pnyDXZDSb6wv+Luoup0Iu3BJorgGQfMjHVqpF65OkbyQGoehP4G/wYSyEs4Ey9wHunIBjYBkPot57yIfQ3tcMWsL9c1Qa0Xxp53RlK2VCiCp2mHk/jYLl+q5rShVvYf111J4TQjXYiWDHsaq0SYMIviW+WXdNamHifTZV+xpcNSg2y4n/rpYR8Ud7dC7xa00kZvdyxg5EEkxmZ6wgvrlNApsJ1rZ1oiWsyIgJoTxrxVDMFgBkfFqMgnlFnZybTezwy/SN0RRywexM1PGR28G/3se3r6VH2A5BEQYRa/m2ADpdGD508QSzbfNWcGw896ELuksgZiTjkJK47ShAfUtWWvb9bEhcq+d/q0HuFZEneM/092HEMxITriy0cUW0B/6QXdPpVCF/K+CW7sYfGAIxE9hGEH6BidWlyVfn/4RnKntQ6mz2+xV+Y5su1z2/GpXbRzEKs3MTEw9yt7P8sV43TubDlzixY9s/aa+pj5hJX/ayCAchHfh6gNO7Co1aIGWNKP4CyFivEX1b1/zC7aK6T40/iadKKCCrejt6AwBi0WCy5xap7y8Ti+y4cdSp1K2OSyIbV4QdBNeq4YZTNeO6zSMVK6eTtoc7vHpbV2pKRHIVA6b+I1awoTpD1ujpfCpAFuODCZ+cDU9OJy/QuDsEsA3piKgzRVX0yaC+3St9gWaVacdxoL2XbjzIbw/QfU0F/U3NPZM5dHXqkZssEBT5G5KO9hzTerH4Y2E/noAUekIxJn352M2F
 bfyIumqn
 bA0qr0SsZTfbuI3DrXlj/SN0+dFvB1qWWca+QbXIN9mvxafJbvp+5zTI10cuUTLowARhuM/miPsNalADqD4FzhN/wvBl82Nh/yFpycxjc93kVfHek0sqscOqfaWkgm6morhG0BogON/2cchJxgOzv8Jh7U9Bt57yqHx80bJ4UoL9h6qBy95w4/SeWXajQImyONrT3fIF+LlPI8cHKvsmQ9R1RiZI4i7CIFi46VoPrM7g7ED1PSox9bhAkHcEGW0Unx6ywCFYE9mnD+m3z9HkHD0hyAlNT9MD2p2+Axn/xog11Ax5I0UT/aUBV6VwWeUMGAbMw4EumZGrbyotPWOC2O0LlwcbKYRjt6XO2orwTBnHJbX/XRVP7gvDoaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 6:06=E2=80=AFPM Robin Murphy <robin.murphy@arm.com>=
 wrote:
>
> On 2026-08-24 4:29 pm, Luigi Rizzo wrote:
> > Introduce swiotlb_alloc_pages() and swiotlb_free_pages() to allocate
> > and release compound pages directly from the default SWIOTLB pool.
>
> Huh? The sole intended purpose of SWIOTLB is for bounce-buffering data
> which already exists in some other memory that is unsuitable for DMA for
> whatever reason. If you want to allocate directly from some kind of
> pre-shared DMA page pool to avoid bounce-buffering, set up some kind of
> pre-shared DMA page pool and allocate from that in a manner which can
> avoid bouncing entirely (see DMA_ATTR_CC_SHARED). The idea of getting as
> far as calling swiotlb_bounce() to then have a special case saying "haha
> not really" seems entirely absurd. Don't hack stuff into the SWIOTLB
> code which has no business being there.

Ah I see DMA_ATTR_CC_SHARED did not exist when I implemented the
swiotlb allocator. Cool, one less piece, it should be possible to replace
this chunk witth the DMA_ATTR_CC_SHARED.

The other pieces are still relevant though ?

- use these dma-able pages for page pool allocations (small)
- [PATCH v2 3/5] net/swiotlb: Track bounce device per socket
  or one would have to unconditionally allocate from that pool,
  even for e.g. local sockets
- divert socket allocations for eligible sockets to a DMA-able pool

cheers
Luigi

