Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FBDCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357A16B0092; Wed, 14 Oct 2026 14:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A0D6B0095; Wed, 14 Oct 2026 14:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F97D6B0096; Wed, 14 Oct 2026 14:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB96E6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:28:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F5031A025D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:28:45 +0000 (UTC)
X-FDA: 85322067810.30.7B54EEC
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id B658BA000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:28:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kuk0tOWz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+JRXvl/R9u5pNiuiBxqdsVIx1pGWTS2oCduhPjMn+0=;
	b=PE87IlDmPN5YjhYNIIku88H5/8vYnewN2sqNmyZs3Y4iwyJw9yvTmN1Biv4uLLhfuS+4qw
	4RG99ut3w0P2PhvHaPlV+fVbO5XXw5jmwPfsNH56Is5huVJKmITSD7H8akIsRaaXXRt9+z
	3Xt1KlyVa3toyjb559tHuhp1566ESj8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kuk0tOWz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792002523;
	b=Hi3ja1K9NNzc2v2laoKncVR9nV2Mg7+GGEYKymN44qvx1OUh6iML9r3ZF8vo12Gu4Oe5XH
	X8nQ94XzBNf1KaWcw58QSQSe0n3LRZ2MTfIimxt4MTHrPF4D1zo/fsCcqclei7ajS/ZxMQ
	tm2+aVCAu916GwfZlWigQPw6uNVJUkU=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so237165ad.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:28:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792002522; cv=none;
        d=google.com; s=arc-20260327;
        b=eqdY6+TFJnm18OBpZTiVbqLoXZ9tRt35ZMDbgfUBBMrPuDuHR8SXWpaI9DtAsV/Xmm
         5u+7mtVOkND13aA9Oi5qj5Pp/+621T1+EPlA1OHbrdSUdzmXHhlgwpBnqyoiAG3DxRGZ
         iIVR735WiAJx3gDpFwArqI2ii+MxAy87+GTvNIBXpIhzukn3l+8wOMy7cII+6i9DXuzy
         VwaRt3c9zmika6SDE6IMmnWt1cUtQ5kyDhiC1P5g8F8GT7SMq7e1bmRh1jYRGG+zq5oN
         yGue1EJ9NnTbr+L2rQhJP3qnwqeZz2ewT1TKornoiuGb/JwdaFZrFVr6MCDVfSaLMgsu
         3Fyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0+JRXvl/R9u5pNiuiBxqdsVIx1pGWTS2oCduhPjMn+0=;
        fh=YjzX09EZV/pBzTiuOGruSoqLKKzGq0OMFBdGlQAu+uU=;
        b=k/yRiNrzMgOkf17bFruqsr9K7El+iIaRV/LB1/NtNuCIsatBugJUiECoYbNHXeOYD/
         GSfE3wDtO24qbP9jjMeY1pMnPu4OITbz9gefi7Hhw0hGvPlv9yqrRnbGha9WNShSuU/M
         GhLbzepTJGKqr1eZu5oqKxIaCCslO6P0fQhwB6BJETwi8sNlJmm5ICjj66BUErKqb0jM
         VgufcAVL0ObgrMngMsrq09zuakA4qQ5zCoZ4qk1uox2J0LPR/FdtQ/OIL1p0CQy7D6t2
         pIyNYqhHSMzPmSkclnnt9UkTNh7zzIJEzNTm00Wr0ySi0nWeOdPXutvvZZWqIbCAMhtg
         u5pg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792002522; x=1792607322; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0+JRXvl/R9u5pNiuiBxqdsVIx1pGWTS2oCduhPjMn+0=;
        b=Kuk0tOWzLUEDR0eSwM9tkzZDBcejdmqv5wmfVGctYxLcIsA14tSCxBB7Eg8GWuNB1c
         o38QYEkA927RvKmEsdW+UUhiwDw9C6KPCkObJRzihPQXb86vy9rnsP6GqvhgZ7mNHTVs
         Fu5Q6Uz04WJuSsZ50RnFnl4EPP66s9iMj4NaPPTZ/WUwGzpN/i4/rx3zfiszauW7mBxj
         4U5o/1wRbvuA5tpQ/vQjxxE9k0XgyfaiRi2LJXmd7IV05jgulQBTR5ewui5MMKi2Vpk9
         fo3Kydw7k1yItOP2ki3m3IIySrLBUe6mT8O9HDAxqtQRG5KCLIEp76rlT32s5StdomzK
         878A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002522; x=1792607322;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0+JRXvl/R9u5pNiuiBxqdsVIx1pGWTS2oCduhPjMn+0=;
        b=Zm2OChso+f+cRy7u0ZQUDsGFjM1wQwt2bRlgBhhO4M0X0VBnJJNYtJ1G78Z73RyLKw
         7mrdX/5RwcDuKWhMjZKV4SQiIIAVmMq5D9RrqJNg9rCKoNyQhggL+tJUMaMbdFCuq5HX
         zQmZzabHetLUK/3Lotb/dWpSqVTOcDc6+hYrp4sygL+Bi9o1RBLhSYRxc/KHUGTytc5z
         1mb4pcGjRlzDZpir/6coIYjoapoI5DWA1PAGG24fxtZCX7V6MJs6Wr4zsu3jMOlQRsw4
         gt5CimqzNLWec0NXz/6JjcPoQCb+qGJJhoayjzBWcPCDrr1jxYuWHseZPIcOjnnivq6x
         RhhQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuMwYO4+LLuhzZyTGCfMIGAhhNKWAw3W6Iq/INhc+ptiO1aOcHyNKQYA9F74jfqI0TcbgOYxPQ4w==@kvack.org
X-Gm-Message-State: AFq9FYJrhHf5GZpIb5iXSkYqXiHDoXh0V/ejC7C91i4pkyu+PH1XPm7R
	wEXoO2leAeaqDKNaRGmM5J42oCABpQgIabMPAvCpu72T0he6rFZPsbAMXbuQ/6XwODzOJUuTglm
	EJDHSWDpVwoAQrQ45RwO5SYxVwRhDFFZHWyKtjHDA
X-Gm-Gg: AYBFou2sRrIcjqFEszv4LT1HpelcTZjrTrRnfD9uEtdkHtEo5TE1aUOfyU1iTxTbT3n
	rQuTTwfFmruG/+WuabyQ87vUi4wBHj6R4uy1z8lrl8KFJEgPRlDV8hlAMMzSozfte1bEEZiPxq2
	spz45P5kfxH+dSpaxBMRMUI5dMu59gDmbrpHph+0vsT8oUovcAnzdIG9oBJnpQ4TtZCbvlDbP9l
	zXoHTSwbGQVAXs58/6xskqIYzWkkbzPOAi6f8UgcaVvwTK1cqWTZsCmUu/IBMaldLnk54GMmgi/
	3bLjZLSC3VJgcc1GwH97U7BMHvpupQzkkojDCo+10GBNdZym1TYay7wp
X-Received: by 2002:a17:902:e944:b0:2e5:4604:c37a with SMTP id
 d9443c01a7336-2e87e303708mr18554105ad.18.1792002521805; Wed, 14 Oct 2026
 11:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <20261003212241.3432303-20-lrizzo@google.com>
 <52a702a4-14eb-4617-bd29-e3140fd36780@nvidia.com> <afff5a1f-000a-4216-b4df-dd3d0406047c@nvidia.com>
In-Reply-To: <afff5a1f-000a-4216-b4df-dd3d0406047c@nvidia.com>
From: Luigi Rizzo <lrizzo@google.com>
Date: Wed, 14 Oct 2026 20:28:05 +0200
X-Gm-Features: AclHuK-6TbXuD5dQp6Q_-RxWjRRPPqkpIpvGcrKlslQ4aEjsOkMcO7VIrHzh1iI
Message-ID: <CAMOZA0K4ZV53pE41AKoKz1g2wz3YENBz=HVoXng=RZbGyN3ssg@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 19/22] net/mlx5e: Use DMA_PMD memory for tx header
 bounce buffers
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B658BA000B
X-Rspam-User: 
X-Stat-Signature: 6qkxekqiqw6s5pmpzi1zsxa6tadbss5r
X-HE-Tag: 1792002523-392593
X-HE-Meta: U2FsdGVkX1+fCo3R8OICSaXYwoghsmaFjaUklhCEnXKlaIa/ri6Gp3j4IBcZfvwAlqUcmJ4QCBwUU8/YFrDKrLvSHxG7aqnrvpKiEVtygVwse8u00/e/b6JnhvDrp08HtUDeOG+F0n3lzzTzAvJo1k6W1JgRbLqCxXrlmAiYvmEwKwlN9OVKkcN0HoO4ttDOyL3tRHfKwsGG5Wgn1VuMMaV7Hywr9gskL9OMlxppyN7YlW9Nb1Y+8oTl0CeJtwYnkIe8X9B5P/Fy9Qz+zwtuUs4XwaKTR1SH/TnJELqQIti/w4v/GNg2PUsG9fuwRPs+G/RB9pnUAnAmzMIyp1wo1UddWfw43+P/Zgk0kZeULjVicnQ1YqzLoEkZn46YSfWSZ9LPdrLldPRrJeBOBqRSWMXL2wTJ/XwCDvI2Sl5VEBAb7GDXtzVXjxaYpm2kROYAKot7BEpzOx4G/p6OcqXv13uLf2c2DujxU3LmgegB3gy6hLYegB12DpJjUNGwYKu79ZIoE3UGInwrpGwiEEO3COldEi5EvLvJmgLDOObJ3P+YOLR4hI4jKskdigEwS0YCijllWfiHx5ClJAhl3jCrGl/q2jnul3/frhpr72Cdt5/5mrHL0pTgbkhJFfrpHsFtM0wPjzuh+1/5Qp+XmMmXDS5415hAnVg5JghEhguTDVNe4nNZLK5PQSGAu8dlD/1IKkIuM7ONUY3AkRA+iD0oWUKh7bS8MitUuZ6fuDCe+r2PmwfJgCuB0FEHwMK9MEobgJkxF+geFitv7uUmHKRbg1PqlMhcrWliNbm6NL814mJD3xGPOQgdqC4Wsc4Q8/qI3yCV6h6soRzYoWQ8dSnTAYC3I0Ay6npsTeU0fg1phngggbACuxBvgD976fT1g2fuHxA3fXI8ykMWHgd6DjyZOZtNolpzpeX3QUKitBJwOJhMGZqNB2cNOLc/tfrcYjHmXAZKxDyzmxrF9/g5tOO
 /rYGDV/N
 DE5SP0yjEMI7Rk1rzB37gR9hydgKIE/kH4sdP6hn+Yr9n9JxkWdfjtA4WSuzttsYhWkTsAtZz8tUIgd5QlhYN73/IwpwWENFU2ct+6jrov1Yc6+IcLONJIG5EL9MFcLVwYUJKgj4RRQTA1ZxHssXr/u+CMINlGlHWVL7gBN857DEGysyCddGm+EcZ8zbjIXWQEJKM51IX6Y+n6phCB8ktGf3LHuPm50ksdg2vG8mvCpLsBm9gWDNMwPMBfvuxDbTvZ7hW/Ih9rU/7rWkOPCeM+jdgGVJWNhe3NEsIwfjkLUNvJuf2hExGJTKWE1skDrQJGKhmXusmvnoxZ6AzUf1QvhdeFk163Kjg6cPoIpv/WLF2qGdqSCLKHrI+HHrqM7D3U4bX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 7:51=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>

> > On 03.10.26 23:22, Luigi Rizzo wrote:

> > Why are only headers considered for bouncing? Because they have the
> > highest mapping overhead?
>
> I meant to say headers and small packets.

Headers have a high cost for the map/unmap (especially in strict iommu mode=
),
and also cause significant IOTLB thrashing, because they come from skb_head
that is not pre-mapped. The impact of IOTLB thrashing depends on
the hardware and load but they consume one IOTLB entry per packet with
almost non-existent recycling.

In the following version I have modified the slub and skb allocator to
feed skb head from DMA_PMD memory, which removes the need
for header bounce buffers. It is a compromise (the skb head includes
skb_shinfo, which we may not always want to expose to the device),
but gives an option to those who want it, and in that case drivers
that use pagepool can get all the benefits of DMA_PMD with zero
modifications.

> > Note that TSO/GSO packets will copy the header inline in the WQE
> > already. But not for small packets.

Yes additional bounce buffers are not needed on hardware that are
essentially using the WQE as a bounce buffer. I'll double check the patch
(mechanically generated).

Small packets should not be too problematic, as long as they come from
fragments allocated during the copy_from_user.

cheers
luigi

