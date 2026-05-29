Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23467CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8956B009D; Fri, 29 May 2026 10:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A91E6B009E; Fri, 29 May 2026 10:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEAA6B009F; Fri, 29 May 2026 10:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9E36B009D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:46:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14DF8C0656
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:46:12 +0000 (UTC)
X-FDA: 84820732584.04.4CB53AF
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 09AA520013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:46:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d5z7EGuA;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6iX20sxRFgzRU/6WWLyIcEgqd92EjfEQ5ikoGiyUDs=;
	b=O06YZ95filhaYysvkkDi8z1/6usJ6as23DCx0EHLYO6F+15io90qny+nsa4vL9jlqHAwxd
	XtoiNErRIq5JyPd5678/LsFlSfxVZQe9pP8OP5XrTFBneSrgbjKyHIRQORnZ3fymRQOgYP
	QD897PY1FkIGUopIE65wTKuvXgF2QYw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d5z7EGuA;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780065970; a=rsa-sha256;
	cv=pass;
	b=xJOk43mTiOBr8/ZkZKIJIb+1q7HFz9wGmKA2N8DlBuea654XSGNB8gSJjBHiAgBruMQ5vt
	hnbfVHKmuW4vP+f/1JmAtSi4xjHhs/5ouks8ZnsO4UqE9VZK6zAbhcOKqn9en+ewdjhgoE
	ZZRf1pNJ4qVpOUsOCn8uEoND8oEzdhg=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bd8f6ef4ba6so2121011966b.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 07:46:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780065969; cv=none;
        d=google.com; s=arc-20240605;
        b=UqoBRkPqT8+TLJ+83sP/SfJ86sWdG9VVfvsL+PXFfh/Cc8dx39Hp4EGpTB6IlhN5We
         Yin1vTYCLa4M4qm9UBVMQ7geDSVTM9pqNxy1VwACLahQOsvNGen90E6G825mjCKGORUS
         whGdp1Kl+z1Izr2QWHdBd6BFweitJ0QUFlGNs8q9q/wNg39J/+LC6SP5UNWprcgb1DTr
         siKN0f3Vxyoie8g/CZw9kTfPpS0FrxY2wMxv5yk1q89jRF5mihLL0ks64xzBZo13/T3T
         YY7SIOlhBBrkqrbCmkHsaK286jkbwkcSOQbpUxHjqTyXNXITi/kz9r5vd7ut8njkE1At
         bsOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G6iX20sxRFgzRU/6WWLyIcEgqd92EjfEQ5ikoGiyUDs=;
        fh=XrMwMRhRa47VRwE6pnnQOjHM9Ph6KuzqWZZ9KYYGNmA=;
        b=PuusAE4ON9BzTkQMq5eP3MhVGwdoPZXenCG3ZfHcrkR0fZM0KEKe4mRXpy4jSPsnHz
         H+tQhh5Ycp/igJxwdKqvw+30x1wYiRJn0ZXm/Jz5ht7HO/KXU5jx7XrDC4TP788Vi5Gt
         XR5HjxPdfV7Hmk8HRnoJvmllWlCfoq9OySEwvA+a1VUh3t4i1f5J766QQQVFTUBitxeL
         4DgoXIojbCHkxPjSbUouNl8dYCAPkeuNmSBRR/EfV5s8qhY3iB8KsyS+mfieCt3ahc8X
         t5rBeCK/+LIPQIN1U6VJeqS9OplH8SIHbrJnkID/FyFF9QHxcEThX4cP+myIar+2ElvV
         9hsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780065969; x=1780670769; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6iX20sxRFgzRU/6WWLyIcEgqd92EjfEQ5ikoGiyUDs=;
        b=d5z7EGuAV352aBEGQYsYob04WXa5wIzrMwkOjtFPRgSURtK7FV2NOUir8ikSMDd8rK
         MbkFSXYI3cwwyLUrrJCuKzHOe1qmBBAN9h4MxBkG2ftbMfcinduqwch/VHsiUW+kaD2g
         6A51U6fkDoE2HcJTyNmAYDz00259Ux0+MsRCA/SLbyCxRhkYXKC4XzAj29LujR2qeTpT
         BAp1y2tnSaL+Z5or8jK51jHlexfrZ0NOajuntcqf3Ft1zynKq3QGOdaj49EpQPx3m+J8
         wMnpHnIFBZVqds7bYM3N7TCbzpxLjhswu+0+lM+847F8XDsMKBqjxw1FaNAOr87+Oie1
         09IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780065969; x=1780670769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G6iX20sxRFgzRU/6WWLyIcEgqd92EjfEQ5ikoGiyUDs=;
        b=lV3eqKRtIUv3XufF8bAzFBd5tROxF/mKr7pNXJH5t2aRcNjYhX4KZqwZrQ42jn4OJQ
         yrYLo6lp4fJ4lamMGoOx+X5WtiDABfVoF4AMWiVk6qmxqEnvq7vic8MHuARXsmx48Kns
         ruSeaPE8RU4axCNIiRLC9NLzqkH3tSvWsLKGmPva4Os5TJfMAeHLuHFQfEgGGu0htA5+
         OK77RGN7jM6LSsgzfNaedSz89EPldJ7F1HBatMsKhrsv2Kf1m6sJKLSsvOmPH/P+nEVo
         6E5WquRO6Epkfap/3mVTq9/cApNgFuISl0nfuFeQUQEXqYb3pG85rAvlmI9ntuPwR+qt
         kWYQ==
X-Forwarded-Encrypted: i=1; AFNElJ+LQWWfklNO4iRBxuoA+u6y3LXD7vG/U3HmLi2L8dgwrBR64XQqvTbY525HgMGbd0lOkSVhp7M49Q==@kvack.org
X-Gm-Message-State: AOJu0YzXyKvvWjlOm/2ElkWhYorYf8yN5qE8D/856k82eS44CI0igT9Q
	5cY9QmWFrUtzqzW33X7leyyVNITI4Bh8L1/l8JJHGKTWtcMTq4EbXpuZXUhlr1Tz+2Q4eYGP7OV
	Df6+Eal0Bo3HgTWusrwm60SD8DjNfP5w=
X-Gm-Gg: Acq92OHlZQbTqtsPYhLdRcGIWPo3jhDk8O9lz3bDudvc/lIk+pX8UZYXLrjv9msEab0
	eGx6khYLVAX8Je2G4XsShC/OGQWz3QGAukxJhsuTW+FThgKZcS5N0QkRMu+xleE+Qq+fC4KcJ5Z
	xhcMXcq5H/5KLb46c2CvcS5K6JpDskzXS88Rf2lbD/CtowpEwU9zDeOMr+nXWM7dB5blTAF475U
	HvTttkJosMhUndKdcFLyo316csABqv4IazajTEh9c86HA+h8lNrUjPG0AgYdD4Vei1vxBxxTJqY
	pU9XAVKdZnx7bivP4IQhO6dzrZO+4W7qCrosFtIMnvOE2exqUZ4=
X-Received: by 2002:a17:907:2675:b0:bd1:4da0:b0d3 with SMTP id
 a640c23a62f3a-be9cac109d5mr144354666b.9.1780065968066; Fri, 29 May 2026
 07:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com> <CAMgjq7AA_1esgtA8VyxaBLWBBRM12bCBpxO2Jch5OESBZSg--A@mail.gmail.com>
In-Reply-To: <CAMgjq7AA_1esgtA8VyxaBLWBBRM12bCBpxO2Jch5OESBZSg--A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 29 May 2026 22:45:31 +0800
X-Gm-Features: AVHnY4K86HI17pY8YJEJfJmy5evEk78o1qo-0ZFpkl9b6nLVN3I00fORb5XL1GM
Message-ID: <CAMgjq7AQwF6oNpnGTxxJWb=oyZ3dLfPL4oSNoS+eQxtuzZPgTQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/9] mm: admit large swapin by backend range in swapin_sync()
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@meta.com>, Usama Arif <usamaarif642@gmail.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09AA520013
X-Stat-Signature: 3hsqdudf5fg9hhnjqsnwamh8kerqfy36
X-HE-Tag: 1780065969-653986
X-HE-Meta: U2FsdGVkX1/3jNiJIR1Xxb9LeALiNCXN//sbkR9p2MbiLEtL7cOrAZG9YoOMCBCXaOXAbPq8A/KYLao536iCUEBxpmNsC/PLeZWUwnFyDU3IO0zijjRtwaNutp9HyXe0/QqTpia2kKue/QjkF26NhPdAjC3Q3nxw9oaZAHC07lkhTM7zJIDEMRMsuYS3cyULW39A7x+aL41b7EiNqu4KzRPa+iZu+IfxS/hg1dirtJ3y4LsADLLOa1n2IdNrvkZwL6hICyzfFUArz8kaaBQJUAkX6mcXMu/ltOpkSq6cuO+WeUf8VaXOecO7+2JTxL+sg0YIOChjeVLBeHnWREE37JFm6yBSvina7s+a/Ff0vtYX6R1snJ0ILJsE0jnhydVUL2PCkMscGf0A8ljfa+V+HL9GMIfQAtjarqwCOkNk68lqsYeRzVJvhfJ6bEjqu706BpGSiNw49/TY+uT+9M4+3txx9i4Cx4WtWWBXAO5ADVXz+lts4KrYJbnJkujVFGUKP6w87ZU7wGqRWzHfScnACDrIIhqUpjtwoW/HFUtaULJ3I2MQxKhB6wpOaU+EYj+Opp7p68qk4rMyzdXddIhEEgJnhSR/+9KZUk73Br7qUcluatuzX3e77RZTaNYvVIeKZSDZ30bsLOoAwzSaihNpRvoa1GLegRFlsqYXsj2oaO28rcSFFJdobayXO6siQ9vPW2E2CM9iqb0NxMjZfpLB3baF7jPrSqtFuq/hV+XXQecmx0Rz4NWPwOb8WsD8EeLp+l8frV68Wfoq4r6+8n5M8MAb0rxapwz6AbvXy7rOD/f2+JyQYgrM/4wVPHPiYFKeeibhl+CkwnNfunOIBxpVsCwb7VfNa85bEBSBY7R9ln6ygKX/gpiC/bu7P48rfw2GPlg34kraf7nCrEfZJFk/TmedGVA0muWeP7H5Gnb7T9CE5ETdz5+/hUP6fQu6spMHUVJumvjFi1DxLN1m2yj
 LbxzV/rg
 kYscqAc7+8+m/egU/CdCZwQFlIIuJ/tbU5jnXpJ5xzEmlrX3CiAs5LeZzCKHNxQ/mEgVOgD9bMZdHYXRZov8haHKAGEB/j8pppa+mDQLJNzMXLiSFqhMb3AKsXHCC3ZFSeXhJ5g3z/Z/QS51uwjDtUlVmdHjcTw++R/zxS/vqnGkrD3a/TiCtax+K/2ihqSkDfncvc10XqkheQeuBD2KluD9W1EFQZz9DH1lfHB2nzWAeMy7pSfkGtCfFPUDq33a8/BkEotIfRP2gp2sDbEG9X/yP8SiLQxbixXxgqmak0qNS+yE7ZUJWrDOlHHDJUG9gLnqFFR2vEdrKJTuLaqDCGgvR7YxnXOlrupVoRxDsag96spUr0kmCaZsx/7ON4lWO2GUI7bPaEvsInGw7xnbs4jnBuy05+C4OTHkKbtYiKz6UWYdF/CTOPM3FZqHjJ3rtxyS3sU5t4GKAvqNcFY2swjMQXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 10:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> Hi Fujunjie,
>
> Thanks for the update, but this whole defer_memcg1_swapin thing is so
> ugly I don't think this is the right way at all.
>
> If you really need this, maybe you can always defer the memcg1

Oh and I'm not saying I'm against this series or the idea, I'm just
saying this particular design of this one patch needs some improvement
:)

