Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A495BF45A0F
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 10:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6D16B0089; Sun, 12 Apr 2026 06:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7877B6B008A; Sun, 12 Apr 2026 06:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69CD26B0092; Sun, 12 Apr 2026 06:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A78E6B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 06:42:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6A11E3B07
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 10:42:16 +0000 (UTC)
X-FDA: 84649564272.18.36DFABD
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id E3FD31C0005
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 10:42:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dmOnOnmu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775990535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nhr4iizw0k0+++Lyk5+s6oL67qDlXiTMljjiFK1kX3s=;
	b=nCjhB3PRIV7c6dxs3wiYPuqr948iI4RibOHyUDiGi+SG2bFQ6engXhFDDw+I/fDnGFFpMk
	LJta36YhokdAr3NsI5ocWB68WQ1KlJoO2sSt+pTKhMTYwe1bM5OmBEglYiX6r/UJcuBb0E
	DHB9FqdiKdv2ugKVcgPS9mFNj4wjyPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775990535; a=rsa-sha256;
	cv=none;
	b=N/CP9A+KUj5TOm8gDzPWzkHVD42LdwGu+CyEquZRPhuDKgkBN2nyeQYPMLvSmmtaah7Lte
	eDW+wuovtTGamtT5pvLpQ5RU2V/JAl8oU+PQYNHmSQ+t74ZuJpKDOO5Adp1oM5jc1bl9Eo
	VRaIh8kS0QD5AkZ/vq5rOPjwNYkR0aU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dmOnOnmu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82a7ebc729dso1611651b3a.3
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 03:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775990534; x=1776595334; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nhr4iizw0k0+++Lyk5+s6oL67qDlXiTMljjiFK1kX3s=;
        b=dmOnOnmuBum8WFDhuHJr4wr4sZz8KjAZRHMIbr/YR+p2Tqg9VDrm0GxoHMHaGP79kE
         We03//0NP9BMxFb8URHaY73VEqXx67ygNtWM1PYRDPH3MglQ2NrNEMbnj1Fd7wh1z3IV
         P+bUffGcQzV5GjEDfDYDv3NIEbBYf7LGTpeCB5PVgkkYD7zmWH6E5i2W7EKsgDidJMMQ
         GgpTYeWERN3dzuNr6nwnnYHyVKT5Zugj/CFM0mlNBqPsvd28g9Sgiz/Hllnq0MS0ziaS
         +Rmne921cXqPdp0kAQz72fuy7OBaiBQblj7wM9w1tEQPfl5EYDf3oAVA/kfw37c64ah4
         WVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775990534; x=1776595334;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nhr4iizw0k0+++Lyk5+s6oL67qDlXiTMljjiFK1kX3s=;
        b=DECBrv2KBYloub6DqbmJRGRjgJpx2CwMEuDWOsCxEw5oypJwjiDcWeyKHpZkMHVmSn
         MC8/OyUJnDoB8t0yz9YnVtfHWCoH05JOT69iUZ8tXamKkpy1dZJLdFw+29FEiGY1HKz1
         s6tuP5EPvEbIMgr3vJMGzfcZn0qqHyA682BA9a9SZlm1+BH3qk/T/OkRTUrL0974SXwK
         4UbtXKd3QuPNtoahOHJnUDyYI1BVfBqEL8na/RATQXfnZBY8lXBfJAGtUJWmLW1T1Yka
         T1rEwr6u3lIhHn4oh741Om1tMMExb+3WHem9ReRc3J6wFvYE+24JcPEcwhfSyifsQpqx
         DBgg==
X-Forwarded-Encrypted: i=1; AFNElJ/V+U4Nc9w6cEK0hWsj01qQdA9d90u2eEPYmp2zlQhy6bkmQqa2bUCJcSY3+900H3x7nbi4Z1eEUw==@kvack.org
X-Gm-Message-State: AOJu0YwvuUaYrfWFXIQtxU9bsIWp3FCQqVPUGy2V7w03+AHC6h3u7G4G
	T6u/xT0UN3JTjjGrv187FbNSnR/687KIwrp9gdyJS/mIdov0AP0t+28F
X-Gm-Gg: AeBDietM7B/FVdTX8EHC7Zibxs3P/YKyc+AJgDnuTHxSTDORfwaMaWEqPtj2te15qyl
	m9IM4a+AYHeB+5Q9PfyzYLh3Zuf3nZ1F4f2BETTI0kRY5v4YrBQhbh5NuXCyGFgm/t4GHtpoqDU
	xUu/OMB55PRLv0jNR5ZFOpPSNFrAQf2OsB4+3aska1UtY21jPU8ohsuoYJt0n7W0GfwXuyoQhy0
	Ho+pgfO/RpM5Xzj54b+Dag+orc/89a/MBp9j6Dh8GrNW4tQ6MXcwuPZVnP3iphTfYQzzSei7/MY
	A0gPDACEEvN9/+uH9O3fQkiPsL80/AI2wcCqpjvfjBjQVq1DUGEbUobOY1TH0Z6BKpP3yMQnjXY
	4skibmcEdxaRCPNlgAOMSSiar62dxki/ZjCiNXoY6Xaq5TCPOFWcsiQUUDfs9mcU1ZNawzMZ9sl
	vbPfA8ufP2EKmPBTIzM7xQMLXYRWnc7NUMnZJOy4FHY9/u32hFDSNp/0d2DtI=
X-Received: by 2002:a05:6a00:ab0d:b0:82d:24f:2509 with SMTP id d2e1a72fcca58-82f0c131fd6mr10276431b3a.1.1775990533717;
        Sun, 12 Apr 2026 03:42:13 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c52cf05sm8070937b3a.61.2026.04.12.03.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 03:42:12 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:42:03 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v4 12/14] mm/vmscan: remove sc->file_taken
Message-ID: <adt1lU5ta_IAC3lO@KASONG-MC4>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
 <20260407-mglru-reclaim-v4-12-98cf3dc69519@tencent.com>
 <CAGsJ_4zpNLtx6rFFF7fG83TKZ2PpX3JyevZw0KJOL0=cv-ke1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zpNLtx6rFFF7fG83TKZ2PpX3JyevZw0KJOL0=cv-ke1g@mail.gmail.com>
X-Rspamd-Queue-Id: E3FD31C0005
X-Stat-Signature: abxysjibre98f97kczw4rcxkojcrcy5e
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775990534-97315
X-HE-Meta: U2FsdGVkX185zGsf2k8Dnr8wSGpROup1trKK0eyfLJolS5sj8pZotFmJWQ61amwxlGzuNiRkCmMMpFLuLwEKlhj2KSwxiklK0OerAkFo2u7bDrfg2eRKvmOckrUkBQisYM+VE0lWwtRPJhuCMhd3XFw508bWnIulQmjebSgXnstyqHXtVV18fTPfRFuPX9BWTTHaEcZW6QJd7UFEcUcv5fhO6pAmK0UmPlesM2ueWa2W3QgRACK5dh1bAaKgS5kYkr5SIy88GF1yHNxdCSZn1aLbvDd1c3d85F1nhhZ72OpDQNF3CNPYOBEmaOpSqQc4Eb3dOyRAL9cICc96JXynuq6EQKMkATb7BqPOufv/kQY+vLHWVqOIbqF52u5zFNPyvn8NeHPn3QUxVBzorir9c1duco4IVcm4tnoca93rR+Aj8sq+Ra8XxqmS1btWouBsKHK9rp1INN199upr994Z2oLqyUMBwMH6I37+2FWxrC/daVALevJNXtrRqyCovdAVLcvVa0XfGU31+s+C36yCvStj1NaQQER++ZSoe1bju2zadkogbSuxG2TO0G68uJBR0oi+X/IaN06xhhTpoOny5Ctdb30Z/deTh4Y/lqXPp36HfEGggXkrQFDqIdpkkv/LThuj/k88TV7miTLZVrsNUkusLEf4XSQEKtLpWcr11nvu2lwC0oAUe0gFLFso1J+oJzNpK7nV9mgCjB+rw30mZ8lCQp9+WUy8qZO++oX0MAYdG4SObLhAYASGRdvwBp8RK/4gH+xun9tdaNWOyoJCqxQyVz/RtyfQiIad27vBRBdoPMc5R6jDUAbj/31yfyaJ+jVLs/HC7Io4CW5gsAY1Q0KIRkd7/4GUOIU2mvhTWI0mg8uOkr45+pSE5qTm7XPNjiish1feH8wXAH8Tp4UrzlfekswpV1r3GPw7tgx0a6ujrFGe0rmONc98B1ZD2Anfpf3qp4ZCkxpYCjvLAcd
 mMGyI3Au
 qYlWHXZHHG200O5lPiCT9ZA7irVRgSQ5bjrhwkuk7a8b73gcJeS9Cspq3xjvaFid0tWFnY1rDqz9QnKhFIMPcncS9ILICm8/EOvdbMr5n43ILrrptwNSASVeP8b/YyqpnLHFyBuPLKtwq203xDCXU/1BsPccMi/0/woBxaqjjLt2ROaySdETSTuZz7vcBtpUV33385HP8F/q6z2VuOAWzqFxx26GhwHoohVSAI25i9Ewzaoob4l3rw+4Es8vjpNTFwQRAhEbwNgbIxQTmQRdP9uJh57AMR5QyEcONWC0Ged6R69ZcP4Ys+y/rmqXWXM7MI1aYTQetRXxG16+lXWJ2uw0l7iQdyOxLu7lghUK4+88uSCGaBnAendH8E2xlceu2gSSyRo89Kfo9CmI/iRInWHt8/oA/xrIcFzVDjH3Y79ABA9cvvrsGKNE96yfuJe21UjZNptHDnMbH/miK0kro+j6lryq7PyvsdllwFiTp1e9iHrohWsU1zQPseUFQLi7MYoQhbRnDh7FUW9CAdbfCAdO/tWhPCORHbRjlP8IVWU2/oR05MKaYqV0oqXLIixQc+HbQ7DNb9F4NfYsdp5yDkbcIonb48XjvMFvtYOBC7AJTZe/+FOjac8XlqsGQaHNJgt6STy+5+fwywlqkZjMmZASBGw4JugcXalm7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 12:43:00PM +0800, Barry Song wrote:
> On Tue, Apr 7, 2026 at 8:04 PM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > No one is using it now, just remove it.
> >
> > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> Can we squash this into patch 10/14, where the user of
> file_taken is removed?
> The same applies to patch 13 as well :-)

Thanks for the suggestion! They currently have different reviewed-by
and suggested-by tags and I hoped to keep the credits for other
people. Seems trivial.

