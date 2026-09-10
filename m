Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0C7C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 19:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDD06B008A; Thu, 10 Sep 2026 15:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494EF6B0093; Thu, 10 Sep 2026 15:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC636B0095; Thu, 10 Sep 2026 15:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF906B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:32:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34F5FA066A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:32:38 +0000 (UTC)
X-FDA: 85198849596.20.9192FEA
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1CF8F20003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:32:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kJZoZxLt;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789068756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qs+4dAeRcuXrttzNVWkBNKR76Uk00fy51SodlQZkPNQ=;
	b=hpN3nc6tE5Uqe+L3T0/rSi71Yz9szlv+5jOgAAFJceFEIqw7hT9g8ucLW/KV97dpvoOCmW
	M0rlBQy1thPjj41EK//OFncXjcGE0VOYfuQ/FeWdDFhz7SdajO84E40hrHfg/LGME4p9X3
	FFcNb7FU8DFYOsmLaCQUYPLgrqeE8XE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789068756;
	b=qDIDJpeeOr9KtgTyhNKvZFL5LbmAx9cFm5W34EL+0hycn1FzyGwH2U7V/2ktSfW3mHRJ50
	w0N2eV/xdFNmBljRzTDCjtNMIPoAnTCGka9usNbW4oe0jELL8n14A8QaSTeVVv0+L4Kuxh
	5uNWNKZKvvyvbJGqNBZBrIX/e809UB0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kJZoZxLt;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-90cc107c451so623186d6.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789068755; x=1789673555; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qs+4dAeRcuXrttzNVWkBNKR76Uk00fy51SodlQZkPNQ=;
        b=kJZoZxLtTNHGHSIoyxsK+mKYVsecaBVYVPoqBy4ZbzwKKinYzWZCmnuv/J2rIh4UxT
         Um4bJWg7xOYqndqaN2+vwkRS/T0BUdPdPbgKoIb2L9hrNvsZSBOsAXx3ef6PsAfJHeBt
         WZa0hdnlHR7SdLF53IMZV6drCcirIV/tblJ7nLrhID97j8tFC5zPcwMi4Z6VR3gJYnKU
         qpi6SKYrJK6/LS3m6fy3qHUwQy+r6wlSDx18YM49v/jMKO3lWmFfaUJa+X9e/XGGB004
         0ZgbSLC8q0EOjPwkIprdmPIxg0f/xxCv5eUp3f/mZdA/KIABu2IZjVTGx5UjA2N3KQzu
         uxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789068755; x=1789673555;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qs+4dAeRcuXrttzNVWkBNKR76Uk00fy51SodlQZkPNQ=;
        b=YYAvfl2WyRAPkPfn2LYfLP6HglJ5TFc35TkIcOvvuXxdN0kwRjrA8pxiKwTjteheKN
         4K06aqmCTasbnNNziEfk+zSXEKPbzMog//8fcUZj8Z9r9Kq2eF07P0Vi2n1zRqyoH0iX
         fZCaBvTF50+T+32LvPSL9HJSVLUURWtlRM9+IV0JLNrL0rB+meXUIazicjtHbASifx2F
         wweF1wykKJ6Km81Ng5+eDWFblVrS7Wy0XVc+UCu+UkRATXu5sxfrWfDPsVOmrkaqSt5l
         RNo0gVZHklYJRh8UXUQiQ8SBJ3Vkgw0av/DaYHAJHnjBJ0JWfbGAN8aXH6qnsqBHYy86
         yWuQ==
X-Forwarded-Encrypted: i=1; AKwUvBw5LIlW93IPVY688W6OY3cAQmS3crZeUXk1jnxzbXY+pNINP6FHFlxHsSdDWDrm9/S/qVBNzylamw==@kvack.org
X-Gm-Message-State: AFuF++k3SzmTs+63gfELZ1CliE5DBT6LOH/TRXxFmldas5B8d25dnxaP
	fCniPnjM6YsZeO5JPIZ5VQQIyFD1YF/uyZENySbTb5FgkVCt8CTLmubXdtt5yt51toAHh+ck1PQ
	iG25++CI=
X-Gm-Gg: AYBFou2hS1JTPl5wVfOidPAOoJDHkNDabAFjVeaJodzdpBy6HZrdoCMcq8h6EirprY6
	73J4uaHLS5QK9xncBdRuSpQZk5DIcKu+yjnqVtgNCvxGaCQaCfWbjnVN7OB+LEBUQqArtq6ytvz
	Kvl7s32OtXMe/DHxtNM7QKDC+X5jr7dcLEnF0EJ/FvF+vi25uwYPvNBJdxd4nLm5YWNdkqlwVFc
	Rc5k2WESV8BKpxlBwb1IW6r+IkrEc4xzH3dvvXDyBO9zr70XEv35a7qaUOzDvWXG3o8qKGald/t
	M7zr5CEWrSNpIXt8ZN/n9W3C73PbLfKqkaZYXC5cVxjxEA1wCpPhAdnGR6GxZSD0FKekj1esQh2
	M3Y/2cZSzIuUW6bWG36cI3htVCYoE2NIOg3/tbnCAkXu5IA7xh7Ysnzsa/KUs7Wx0rHliueK6bR
	kygqSa/cMCb+NevCLcajYrWOD531umcRq8YnNm31fYB7XAfJAgeRgHmR5FqpePfjRs4sQTww==
X-Received: by 2002:a05:6214:3d99:b0:90e:855d:6d3 with SMTP id 6a1803df08f44-912120690f1mr4494086d6.8.1789068754955;
        Thu, 10 Sep 2026 12:32:34 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f45ab71sm3244466d6.12.2026.09.10.12.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 12:32:33 -0700 (PDT)
Date: Thu, 10 Sep 2026 15:32:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 1/3] mm: zswap: convert zswap_invalidate() to take a
 range
Message-ID: <aqMF0b_OnZEmQFrK@cmpxchg.org>
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
 <20260910123544.818146-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910123544.818146-2-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1CF8F20003
X-Stat-Signature: acano9mmi86a3r5epfipj5mcdf6bbjcy
X-HE-Tag: 1789068755-904451
X-HE-Meta: U2FsdGVkX18v6lRM4UJYjvch9w4DZT+xAyBHzYCeJhOeWntllxgd1vgCSYZGSbNixy2qozR2F9FqYFt4FLNJ2Sy20Ge4DdUJS0rf53qbr5TbVFFpwAImqmpKP71elriCkPryFwfkI/7uI3M6259RIMTFs4OeMAdoLz/4MEG6YV2B4iCcFbRSK7NLymnj+F5HpjgaHpsWTTUq90d6otkSWGOy2nFy/5fSl/CErG6rgNU6CP9TtLMKmSSuqOzstES7I59eTbCTUvWCI5JwGPoEj+t5PQaYsASYgHjsPMi5j26ilTQJJbcwmizNG7c7570OQhoBReK2ZOHPnDnYaxUEzVDNUR01igzCma00LA4B24OYmunpbNmrRYPlwX1ZgkfYWdcpd8l0lMZd//WC5dye7V9NLZgWAzttd4BKCkDUKdKuPl747Tr7KpDvV6GrAuBlO2u2+uOeKXFWxhFyahZYt2D63Y3F+JbYGKfOgMcLzZCyt9jx4qIye/9N/4JaYE694vR0Ga5tRdhrxaSKe7s20FwCW1xB6M9tu8SkGnBz3GHU3sOftGbFJOECQWQ7xCy7N+FHQkbdjS2SBLLAh+Ft4qyXfhHjemLUJ6ISkR7DbQC+FuWaIWjZLAvIyq3d7ZGbzF3LScGO593V9eyKh0ADRSYmtinc/q2Geo0laIyiJTBdm0Uoi77bmfPemLIDh+87Qmzk5/rk+1aGISyQAT1Bl2yQqxjtAMl1etito3wn8f1j+Y4+2FvgfgzSTUDXFHKriklqsegIuk0XFmvNWR02xg9QynUlxYlEuvDmheX2zixlb/9vt6xKTmXImcxe1c5/7qSuQMRcgCgP964nBs7nGL/7a+W11EeWJtIj7hkPKvQI4gHymeJPB6XmyNoOAWAphy7dBIJehX7YkpQa+GV6lU7D8/cCykAl/RFzUYcbbV6N4BSKd3S9sOCdc4EqYxztdskb1mRBP0Op1KR+KM9
 n4IaAj29
 A61me7rlZpav70J8Je/cZ2nH0o4Cews0UM2/mzPHgdw0HtICp2tLa214gFpLDJaEz8H1bxhWJuypsJI8DcHesN6NUWztO9m+4DaBpJSKsPSEgPKeHbbsqjo+oIY77kMCKYE6Fh9DFC3i21jstn1bn48cp9Q504roQDPDulNtsbwN0NNKckr3CuFb9++wnN1crcG83Ztt6CT0+84UWaZhEiHWtuUGcTx6sUGcT33WIPP57/TiA62o7BEcfadk6o5ZGoZe6zLbx3+9TU9JHLrRNsyiomEP+h6epDfv1b0r0KrlxhoXzLFYicjpzNnKd0EhBuFBoweU9Dh15NcLVR7jZTmeuuGW5N4d4LLkTZDjfEfAFBUYeZNcntQXRVixZa3ltGvkHyUJBnOgcwmg9Ek/2eaPLkfpjzvtlLQ/T5ucrIl2ens+AnRdOCK/KOD+5krc+OmkwSIrrUNmJqd8MdGcj2M2xX3h8HCHY5x/r7HdN+othZk41EO/reZ3Wjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 08:35:42PM +0800, Kefeng Wang wrote:
> zswap_invalidate() takes a swp_entry_t only to unpack it right back
> into type and offset, and both callers already have those values in
> hand. Pass type, offset, and nr_entries directly so swap_range_free()
> can invalidate an entire range in one call instead of looping in the
> caller.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

It keeps getting better :)

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

