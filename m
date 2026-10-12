Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D414CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18A36B0088; Mon, 12 Oct 2026 11:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9046B0098; Mon, 12 Oct 2026 11:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8A06B0099; Mon, 12 Oct 2026 11:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B88566B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:02:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 472E3160FD2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:02:53 +0000 (UTC)
X-FDA: 85314291426.17.55BAEC5
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 62214100002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:02:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YBMojwKy;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of rizzo.unipi@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=rizzo.unipi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhIDuBLHbJsBmFiUrtUWW1GlGqZnHdg0lmt6NThkZTI=;
	b=TDx/IGZ8WbsB+iNYzLuYa5jB9St0lUwR/6HLk9Z02aTezvs8Igl0AUS/8f6CE1ESIAlLtM
	AdYD1fxH0iOxs/g9D7QVndZlA8ZM0QQ9YHM1f5cb3Y6nT/PKUDNFn0RHPjjP6aMvfskxb7
	TFnjkLVz8NK9Mj04H4BNnN4O3sxuLyk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YBMojwKy;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of rizzo.unipi@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=rizzo.unipi@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791817371;
	b=jWx+laohavQtzWrP8kMUqMNFROB/Mn+yOiMN6fbrakKanYi1TfsdlKGKPfi+pwnquDuISV
	ObfhE7kPY1ZzqNEICnN1M/1vBJ+embuHJa9E90JpI/fvA60gGhCFkUtKz36vmHGhcMTqVA
	sitRlO37yIyTyki376LrQkGgAJO9uiY=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab9268d90eso809469a91.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:02:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791817370; cv=none;
        d=google.com; s=arc-20260327;
        b=G8TzbrMeU1EgyJbrNALYcg4xaA+fAXCJai+66y3W8nH9QfuP9yZgV4F7CS0noz/Kr1
         XNpAdATTvwUnT0Ab9D0rvo7FiHXaZRT1LdW5BZvkA1HwMQEkeKBFQ7Z2+3O9+LFlQicl
         o3WUbi0rsSYVur0ZRn9rcsZYeuDlcfo+mhO0pm3nBMEdJX6U54eaZR6f47pIQVmYoQQo
         7xsTumn/mr9mq/dkSUOIZ7z9s/zkm5QdU8JnZTn/8YYuqykIR4pm0K1rLrpXyo4Mp89M
         CnR8TGPecx07Lqah6rOpSmDj933XtdCjfeBOOtOURF4WfP7m3fuzQkAMH13HIj67RcRj
         Tf0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rhIDuBLHbJsBmFiUrtUWW1GlGqZnHdg0lmt6NThkZTI=;
        fh=2j1HVB5Xgx3ZeTAUYoOO+j6B6xRk/v8DOB4xLmTfOgs=;
        b=GePLkmqaaO9/dwbTRGv5Ktt+f2u+K1+rf2kpcUgNUig6taG3vvOAsaBnyzsVACnmFC
         96lWF/qMTq/ZAywjFZGn/OuoodXfFoBKzzKxGr6CI3OLQDxdeuX+WBR7c5KrXHj5g8DR
         r3iIo6Bia2zO5hEpVV2WhY8W+RL+x2I5c1JuXvG/z1XBTI5yn6nmPXCtSNekcWafPk/J
         hPYoC3HFL4wxmJHW03O+XF98v3MYnjrI95uZsyZpzJgfsTupMw26oPIge4AYBZ4Ir9BX
         HAEl1NpQKjqwza8IwIH3K6a1NbffeaD87s9pux1BH/ioawjNRgg2D77gP35APx7mYprJ
         /E2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791817370; x=1792422170; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rhIDuBLHbJsBmFiUrtUWW1GlGqZnHdg0lmt6NThkZTI=;
        b=YBMojwKyhSccJ8y+IfvI+TZfkYX39cQ9H738Dt1t6MKcFGRabHx1vNXsjJb+qLOSCT
         9X8XLu1hoNcN1zjVuwNjkCvnnXdSNFjxtv2Yw8xZMAgZG0tqpHvIzJfOzzw8hvo/uSU0
         dI3GNv5U7vPwSHCYOQuDwf8YFyaIcfWPIN0HMnrGUJV9rbboMSLbrEElGkUwsXNJO/Nu
         J9wTu+9jmOqXsj+5P8C8rLkFxi8SCxlt0x1ODTUmjM5ZAgCmT0coOqqOlf+ZS/I6tddS
         NBy1pt3L8EbM6/dPxop7nKDfu9cVolD65A+nJcLo47xIsc3/z4tm35J7SZHgcqb27U+9
         Lcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791817370; x=1792422170;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rhIDuBLHbJsBmFiUrtUWW1GlGqZnHdg0lmt6NThkZTI=;
        b=t7hWwAVDEPlUAUo9y0r0hJ1+4T2sQYk864Vl5tfGdb8HQPRZgRUcukIF8FX9DdEicR
         plZrN9xopMyeldsAnap87lkH1+A7SlAzyF0iEs+IdALhjqEv8+Gu7YYlrTENoseuJIlM
         b5jh72Gu1JBAWnRwSFUcppftEL2MNQuzs9PWnZxtL3ElO1TLNyzVkVyT+5YadeVNASRi
         YysxbFJtCmNOg0d8R2YwIbmGFq7ewey3d2Rw6VsWP2cUmY06F+lcZmDHr1Ib3CfGZKwo
         WZnxugXKM+GsoW4/QP6mxULDA5RheS2RntVDUE/uF5o0gdCAB8cMgOL+P15oflNTxnFy
         BitA==
X-Forwarded-Encrypted: i=1; AKwUvBxvFPMEM6xsfUfDqrxx+QC291i27CRH7LyIyULhi2VAPxL3qDRW+GfBYC08CObPQKWrbj7LkzdAgg==@kvack.org
X-Gm-Message-State: AFq9FYI15bqTyYlsr1ZfrhpGL7twD3BjtJgvAq0r4fsI7s5bHJW+xdBt
	KeVAUpLeJsVf0YipYYI5KM7FHBvx8SdsKhUJbElLzCxxjAtiARANI/9VLrNWAm4cO7lZSESq4lA
	N/s1Yq4Ky9a8YNmgoiYUpgCJiIbNcOCI=
X-Gm-Gg: AYBFou1bgwgs18B7qyRpuOFPWg93Qh8H9a8filpZxfqVGSctNXn111h2I4NlxitJbP+
	beoBIes0QDYja4brHgWlwrt+MPJ8XosSaYREh8nt98KngZoxaXeifITR2zFXJOJQ14xAg/gKfaU
	2RJmUUqOpuuKspozatx78y2xzPzmSoceMliPScSBK/UfhAy5IhOeRBkqJxgZvaicu2tR4GePktn
	aZGbUiDN6//FLFZf34ibplXeg61YJs/h3y0FCMEQbD+0H7Yn/KY5wBaLdA+FDauzN2JXy3abzWa
	WAZRlzSYDP0IfV0wz4OnNo/umRVkRHCe1/39pl9fQIgTmSHKXWWtf7QiEQ==
X-Received: by 2002:a17:90b:1d4f:b0:3a8:c0cd:57f3 with SMTP id
 98e67ed59e1d1-3ab3a94ff23mr7233060a91.18.1791817370093; Mon, 12 Oct 2026
 08:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <aszzcpW6fJWGcQCZ@google.com>
In-Reply-To: <aszzcpW6fJWGcQCZ@google.com>
From: Luigi Rizzo <rizzo.unipi@gmail.com>
Date: Mon, 12 Oct 2026 17:02:38 +0200
X-Gm-Features: AclHuK_RuYPmfWCEef8B345PmPnIk-csUIxQogHwwsigc85_8kdg-6GHSEnG77s
Message-ID: <CA+hQ2+gMGJH7J0yAx0ooTpWYfC50FnDXvCRRwRaJ_8bJ4b=QDQ@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Mostafa Saleh <smostafa@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Luigi Rizzo <lrizzo@google.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5fux4i8wpysoi638ye7ex7wmjyx9g1uz
X-Rspam-User: 
X-Rspamd-Queue-Id: 62214100002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791817371-98213
X-HE-Meta: U2FsdGVkX1+Mq5NckWLX0A5ieqTUfk9Yy7VWx5wHagH2XBav6fzDYqNGd6cPTeTj70DwtRRgubIXLO7EBqKeNW2Nm2ZDDZV2kPMpEBot/iYFzQ8d90E8qFi/7tu34P6eIhtnXNLeivrrMWGqxLSsJ/vTi/bFk1qS9MMdvLzW6D2+GhH11jYlzrezz3eV+GUvLuHF6LEEDehmup8DpWvbr5yxLEhLWzfFoIl+3r1pEhhn8I2xRAfLR0JhqwbZD9cs63Zdab4a//ag4oSxE7Ld/jBrozKVoiIt/SrtScnSlN65SUPDLj7EGY3Snic+L9tVCyPjWN0otsP3cZgmKsaWoen9jTR2f7B9i+ony3oh0O0P9OHplton9djIV3zho1E/GFVInuK7E+SPiuDL/R6NkxZhV8a0+x9WCVHZroBo7C2zhljJKJhEfyTOha2LM6aMJzmtTLbj4kBbnG19LaVyMxPGJ1mD16AB9EXIwywIH9Eg185kYXEcvxnw3XbC/JYmVyr/q8vRdtGkNDDS9rtpMHLx1DvgXM2Q3fq2yKDHCE5H8HI+Bqwdn8EQ0TMMNxKx2WjOr7nZkWoEZc1PtZogACozfYWZNd03oIWHRC5FDTPD6ZmZcyG9+1MsVmhZlBf3jbQHhtEtY9Fj4pPGllbUhR1Kj1fsHqZP7qqpIqY5adlYHlFvOMDn0kWfBSQ6lN55fCS3VCS9SJXk/vuWCfgl9dWqksyO8lnoAsaB5uoErfrXpRHLhhpSmhO4Yh9o1Cd+fQFvbuA6dLvP9ZFD+lTbBdgTZ9lf9kY9HN21GOJ1av4cmOEcENrW4W3tj7YsU/ep4uEig2JrXfmoN9pk9lAT9N4lfP+ccyDxrE1GpIvfFOkaznT84H6zH6t5niikOTTIrZoaPL8kBeEegwGNTGR7EWq3LfxKPesLRCgKnKwUv/HBdArQx937jAVyMc8ZNzoL2bMZIeakv2KEhHZAQjK
 3BiR3yAY
 tncqaNJ2EFnyo6obZoGAo/YVx0WmX1lSEEhMxq/IMUJmssalfwNNyo6Y9TxyIr14V+LDmNESMvu8c04T9QDAoq7Ghhcsswu7cmuB6xoUlNS+ADkhKUILT+qm5BHAgouylCqDA0HxXPzx+hqS18EA8ZU8wxwLzpzu35u5u3uJO+pKaixYzyGOZdsde6OirpZvnbRSv+tjJwDScNGGlBKNKvs2UL3PbqvuNlUPkOMADIL42z27izGrgogFgV9FmuQsDDy3VR2Y/a6FFljWEuLiVJgD1OMy/yPU8NxRnw+zhXsrA0CxfX3j/jQegYMEnn7ZJJYtDNl/jCFkoyuIVvKu32wakcWoEawdtXQ/aIvUZcZ0moZXkgsSuSqI52JtxGZVYo02tuLTMT8bkabtj48hKECFbJ8wll4G0wQiAWnjwCKF89nZDZA2Zy9z8ObbV0hrhhSdjOteqP6rIpJzKfgmti5x7OnPC7SD/S1pta4sfBkgbkJ0awfNQDBvIGeMZgE5J6LExy4Zhdxh0GPooU+1T+bG1NuBw3fAn8QvcsdpOWsa7eeof2HvB777vtNsBxm9l1NL1Srt+24YzyfLCgiT8r88X1vZxTG1mpLtP9VQ+onwgN3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 4:49=E2=80=AFPM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> On Mon, Oct 12, 2026 at 03:51:39PM +0200, David Hildenbrand (Arm) wrote:
> > On 10/3/26 23:22, Luigi Rizzo wrote:
> > > Here is a subsystem called DMA_PMD on which I would like feedback on
> > > architecture, possible enhancements, or kernel components that could =
be
> > > reused to avoid duplication.
> >
> > Here is a feedback to a subsystem called DMA_PMD ;)
> >
> > Why is basing this on PMDs (and embedding it in the name) the right app=
roach?
> >
> > On architctures with large PMDs (512 MiB on arm64 with 64k), would we r=
eally
> > want to use 512 MiB pages, or rather something smaller (e.g., 2 MiB) th=
at might
> > possibly also have TLB benefits (cont-pte)?
>
> +1 I raised the same point in the LPC talk.

See my other reply, he code makes it clear that the target is
reasonably-sized chunks (2M being the obvious choice with 4K PTE/2M PMD,
for other cases we need hw support, and it is relatively simple to
decouple page size and chunk size.

> AFAIK, this series tries to solve both IOTLB pressure and CoCo bouncing
> at the same time which might be too strict; as for CoCo there is no
> actual IOMMU, so there is no sizing constraint.
>
> Also to reduce bouncing, I think it is sufficient to use the SWIOTLB
> instead of having a new pool + recycling, the tricky part is how to
> abstract that to client drivers as this would be needed beyond SKB.

I did have another series to build buffers out of the swiotlb pool
https://lore.kernel.org/all/20260824152932.1583506-1-lrizzo@google.com/
but I found it does not scale well under pressure: the existing swiotlb
pools use linear search to find an empty region of suitable size,
linear scanning when one pool is full, which quickly degrades to
O(N) on each allocation.
I had some other (not posted) changes to build a buddy allocator
on top of the pool (so searching for a slot becomes O(1)) and
to spread the search order when a pool is full (avoiding O(N)
locking conflicts), but there is a bit of extra overhead in the
light-load case. Also it felt like reimplementing the wheel.

Overall I think DMA_[NOT_JUST_]PMD is cleaner and superior.

cheers
luigi
> Thanks,
> Mostafa
>
> >
> > --
> > Cheers,
> >
> > David
> >



--=20
-----------------------------------------
Luigi RIZZO, rizzo.unipi@gmail.com
 http://www.iet.unipi.it/~luigi/
 Mobile   +39-338-6809875
-----------------------------------------

