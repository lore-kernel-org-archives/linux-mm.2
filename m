Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6EEECD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313026B00A4; Fri,  5 Jun 2026 12:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3346B00A6; Fri,  5 Jun 2026 12:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D97A6B00A7; Fri,  5 Jun 2026 12:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 082AD6B00A4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:16:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA4D61C0E3A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:40 +0000 (UTC)
X-FDA: 84846362160.19.8324DC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2F8961C0018
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1kCUpAM;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGh7xKS+6dNdAiknFwIkf2jb0tCAsHXdEn02Ydj68R8=;
	b=ZL2pU7WeZ9GwE8mPOyLHAyyYDc903x8q4KH0+LK/eal2FfW1PfcYqGiOZyok7ojSQ01Iee
	D5ZEfCraR+RSYLIo0tJPywfZhjJtPuWZ1RtIP6bUdC/Fkr0Ol3YKVGLcfSwXG6TB2mLBGT
	tUYOyfJ2oRshHFqAyEIN8yLyZ6myI/Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1kCUpAM;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676199;
	b=aEe5tG4AyDkVQi6zJJbJagc5QaXUzeED8H3M0CEdmmAt8OeE9LIIj4b7hdc2bySlGfcX0s
	TwWESWzIqV1tfQmgM0UID4XOjjtaUb+XdyYKnjR9qRklaN6IPO/62SluVbti0JbxaWsyLZ
	c9Gf3Am+oxRhuErMmNY2J+Q6CwIeh8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B393E601DD;
	Fri,  5 Jun 2026 16:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347E81F00893;
	Fri,  5 Jun 2026 16:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780676198;
	bh=cGh7xKS+6dNdAiknFwIkf2jb0tCAsHXdEn02Ydj68R8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k1kCUpAMvDwlpBNYkHI9NMCiTSmoOsgNAVNakc1A8kZiCr4n2U1+A2bdlXGWl07+C
	 kf2GdGWcXWooA/3kLETM5eaOMqPoc7GwsAdSPuOSgDn1QFcfH5q+/F0VvnhyLSe3iN
	 Tjyt3sG6t77L37h+j48FqntMQejCFF77tjDZRz9h5zogKgk4pSDeAIW7P+UKQSTSnj
	 r7z00dgbzSeiExwB/tIaTLFMK0MxNnvfsgKr3Ne2PDAKkz8D6x7fjapPQ4NkI6DfTJ
	 ph6/zmep1QfX4suunupnQxrGPLlrCnoRB3uulyVUwWSc0cH3tUx1eZZfJLFxvClxO6
	 fTYAK7S/6669Q==
Date: Fri, 5 Jun 2026 17:16:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: xu.xin16@zte.com.cn, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH v7 3/6] MAINTAINERS: add myself as reviewer for rmap
 section
Message-ID: <aiL1nlpPk1xEvC8k@lucifer>
References: <20260530170624912AfpqJafVKV2Xmz1EPfHH2@zte.com.cn>
 <253b529c-273e-4346-91ae-823c8313c31c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <253b529c-273e-4346-91ae-823c8313c31c@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2F8961C0018
X-Stat-Signature: 91b5p4bfxnnnzyuk9j4qs8tqict85ssb
X-Rspam-User: 
X-HE-Tag: 1780676199-325075
X-HE-Meta: U2FsdGVkX19dxkgXY3bFso9kLJ5p971tIl/gs2hoKkQVkleQrYNVszRBjB3uPj3YkHC+FeWWP7jpkerJ1i70g0iPjlWA1SYe8fmYBB4a/RMw/JZEBfPNt1xAzZX33oriJ82pjB1P9YXXqgYEA3Y2gieUHZqaRw/1tmW/bHjxnXlUkpRaCCzQfCDyN9bamDQbWnKrf81NeSY0+3dO3XU7MloNYW7JdqzYN/ypTl6MaOARSFu857vAT5GfIKP1X4b96DKyi/cYlH79/h7TjGAOz+7izzZtB0KSqbz7D7F96Pc+IpP8la2u8+Ek72KEibNGxIPw+3Bom0z0xKU0wtDLddRNyoD3VbyvtwVlFAE5zKkznPhjnTaIZ/mBPQ777Rp3QwUcEv5ahAkxwqMa9Q4Z9/m+h90soyA4bgbcw7P25Vi5m/gaRA2BNyF4Q/IH18uKYYtqmxLsX8qERUbC315mBi436xh+wpr9o3B2LJMXKgzdcDkgRA2IIoyCOpsZHU8C2dCA/78q+50dO0+cVmZsEBQncNfiHPpl+7Gj7H7ZN1TpEb1SGksEIUDog17pcOZf/c7d6dT/ZbeMKdyEiiKBYhHH7H32eXN00xix1HNkjWDq8YGRfVdOs6nl7Wpey99mR79StTA90xxoHaIYndD0v6KA9gU9DhvApngRu+XiCkYVxFYMoZflHAnKGTcrvmOyhdE/L4cbUzPccwdpl4PJEhn8/E61lbz1yxcBu4jBaHICdeOgeerjvIotFF30hJ9ArgVdx5qjDC8jyu1+F/3TwdmXLTWxOFxI3sBq/+B/lNepDt0wqrazdKyFmoy47L1tV2Ko+oJrhYiasZDn23GanvIg9r2iEZE3N8TAGm148LVoKa9lEa+ATCUbsjJ94BkZippIhY32Hy2UGcZV1kvnfjl0ACD+WCZV7NjGrDiMGdElx/pDZNCl9eolfZ00cvD0peeiuDShNZSzjyTy0bv
 WG/cQl9z
 l+0bc0h11MgOneZqB2MhkkaO3PdhjHYsEkLJnQIZVmkeFK3j0ACldmRUmiTtKfU1lZdu3PwQRr7bm7e1MazcfW2LGUVpz2ty97/npMt1sDKb91rAxfWlbdtRnTe3V/15HTMSu54cP99Y77JljdczuLgFo+473vVw4hjug/UuvtWopyZU1p/Cip9EfT7JWeAqh1FlCbZVzfWIryp5H8UOVwzopz19NFB2y+f/grun258AMIuv3HIYI8QF3lQy82GLRSn6lm55/t2n8ir3sHY7TtwFHrvvBxfpQEZYsqOddDXGoeoPyQw1/ir4y/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 06:03:37PM +0200, David Hildenbrand (Arm) wrote:
> On 5/30/26 11:06, xu.xin16@zte.com.cn wrote:
> > From: xu xin <xu.xin16@zte.com.cn>
> >
> > To help review future changes related to rmap tracing and testing,
> > add myself as a reviewer (R:) for the rmap entry, and also update
> > the file patterns to include:
> >
> >  - include/trace/events/rmap.h
> >  - tools/testing/rmap/rmap_benchmark.c
> >
> > Signed-off-by: Xu Xin <xu.xin16@zte.com.cn>
> > ---
>
> We always appreciate more review and I am happy that you want to do more review
> officially in the rmap space!
>
> However, before we add you as a trusted and reliable source for rmap review, I
> suggest you first engage more in rmap review, and provide tags.

Agreed - reviewship is meaningful, it indicates that a person is a trusted
and known member of the community who has contributed significantly to
review.

I see you're already a reviewer for KSM, so simply we'd ask as David says
for you to contribute more review to rmap series.

Since I intend to send a bunch of code for this relatively soon, that
should be a good opportunity for you to do more :)

>
> Thanks!
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

