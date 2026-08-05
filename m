Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3553C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AABF26B0098; Wed,  5 Aug 2026 03:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C116B009B; Wed,  5 Aug 2026 03:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D956B009D; Wed,  5 Aug 2026 03:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFC76B0098
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:52:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA5EE40401
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:52:27 +0000 (UTC)
X-FDA: 85066448334.21.283158D
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1A0520005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:52:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm3 header.b="Iw/XNB7F";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mFmJzGUy;
	spf=pass (imf13.hostedemail.com: domain of greg@kroah.com designates 202.12.124.156 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dSFb+twFlWMSsdiGYvz5fluO8g1RLT3MUlJuUwjpmI=;
	b=bRqxD5eWglgRxpQpHCnw7qz8Y+ygnysQx9zbd+7hNBc5gYUmeqb++IlfiPAIFjXBpbpGdn
	ppOcqQd2l16PBLEteF0+shyH2ljVeGh6OrCK9JNxEwwHMuGxPjjSm5Eqag3I6Q8VhSM8oB
	1e+FV7gtBMhQ49ImyxMwaOodLiBSX40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916346;
	b=ayIB5zNvnE73tD4J8yw2WMjBkuB1B3PwDYi3B76+NfrYxH3x9EanR9E0XwgayP511drUpo
	UjsX7i4TU5GWfpidgLPQ2CyXZNJi22xN5gmqQ4RI15xyErQoMHHSiW8cPs7vp3OOZzESIO
	vS3gugdpsjGunOXW0iRheJKnp4cKeWU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm3 header.b="Iw/XNB7F";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mFmJzGUy;
	spf=pass (imf13.hostedemail.com: domain of greg@kroah.com designates 202.12.124.156 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CFFEA7A0184;
	Wed,  5 Aug 2026 03:52:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Wed, 05 Aug 2026 03:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1785916344; x=1786002744; bh=7dSFb+twFl
	WMSsdiGYvz5fluO8g1RLT3MUlJuUwjpmI=; b=Iw/XNB7FJpvYuVSdWo0woF+rnJ
	i6kV/u7lmtR4Y/FztNPscNT2XG0jXQiK6irp+zn4EEnEhUynO4tm6ZnYG7T7Bz0B
	jtsGGvnZ6u5W6aeVi0WVWflbuphcl4uRsIp1S6jawLLhWHKHmJGjofXrDcVu9QhZ
	u9a4l9fbNUqwY42zI5Tdwo3Ws+VkyVqKV7iqOq/5U5QYK81VUM0XuUV9VXEg18dJ
	EC7VyV6LFy6fRBRSM8AoXZZ+OVvjLaT2znx0zTN0Da+eK3871vBfu0IvcwKU6bsv
	l8p/6p3qokEKVCcjK7DtLkM3I1rNbHW1smhbEuhRkCwAXBE+sLYLxqFSkuYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1785916344; x=1786002744; bh=7dSFb+twFlWMSsdiGYvz5fluO8g1RLT3MUl
	JuUwjpmI=; b=mFmJzGUyJv31dKU3p/a78+pEyF6HR5KOL1lJDWyveVhC2ZkvpEK
	MU7e04yvYsNCi1nf5o/3czvejwgaiw72KaRjtcVuGFwyQo4zmgJiuSqvm5IwHc7w
	VmcP5+Nv0G1kHJ7OvoD6F5m2umdj7FZX3flf+BwzrCh+II1sc/FsFt/9IoSe++dC
	ZFV0+4bK+CCkJPloPq1MLhTwGAVxu3Hqo+EuwOlvAamqEEWnguiNQ8aH8rI/j4pc
	/nmy7OMNG4aSgaAE9v1mfomvMW68sLyzwFhoFOAnDMnh+1KF6bpw96QccJu8Gwui
	2aiQ1kJAwwLbFEhwJCPafQ/ZPhZ3zfkWF+g==
X-ME-Sender: <xms:uOtyasz4-Lzm2IaDN8LH5rNoikvWKbizVVYlcgk0JZU8SoWV7TOIxw>
    <xme:uOtyaq8PP4yRmYsZkOe8ZXnJ8hjxjy9eUx2052usueJMHWtTrzx1Y7FxPYO23P0NH
    ZvmN-C1WEbBmQMu3KVSfMtziCFH-RLZqwkq8VLS2I-0bb1AhB8>
X-ME-Received: <xmr:uOtyak-aBKMqqUPjCQEkc10YPtSA56LP0TCDlOt2LQtT52N2kqZ1_mZpNarM6zkFw10QuQY97OJ1acjQ91hXbeHm7RQirmDcMljosJ0M_SA>
X-ME-Proxy-Cause: dmFkZTGzDTqs0VoUF5Hbo0kp33jNGh6y0/167eUXoUAvBXZXBg54ixquY2YD6TTz+/h1ma
    qMTgEAr84zACToWtd7VV9hTNBZgzeBeVspfs6VZ41sfrVDwzcrch2ifuKUejBbrs6iWmGp
    ezXdBogxxGnwbMPNi3wq4ZXCO6swQl2iOk25EdIPJ6IQE84VI6kg5bfuPbxW367yNVoyJH
    8GZC/xckjZ3VsyUxXYtivDZTrvmaBPPBPAKsDwhRrPZDizSFi1i09V5xbaDOqeGegQfLo4
    ak2rgOmb+DhKW1Hs0BvfOz/ZXWflDYJL8gWulK7iQMcLNnPf1h5LohhGMIB8A6d/B3t8fm
    XMl6cj7QVEb23RsNh37SZ0Io+75GD7D8bUUvoxPkKrjkMV9Tyi8L5iL9x7NmqHteCh+epC
    m8UPRL56rDxSCcbwSMA/CwpmWJazyY3m/2xMao1svjueM7OCf0u+WMcZ6XlgGIl9WUK0rz
    VFnjblkkTll/dUdpwJdRrK19nNu26nVISCmYNz1ZTDZJYZS3GLQsTtDUzIxaO+4hfbWw9s
    zSRIDd3JxNvSpZcI6Xa3qAPKNElemCFBmJI1FaK/OQ3QMY4GwsUocjf4fbfAREWlMLZxVq
    ywvB05/ME0mqhpDwSROP5/Co4tPw3/kyicF/HnKEgXnv8jL3OIhwmvuAlshQ
X-ME-Proxy: <xmx:uOtyaldJles4VawVGZxEyKLzG_DKgfHgQJU4FKwuCHCuUO0JbMVVYA>
    <xmx:uOtyaouDR8dpCBrh-rLZduVCuCIzIp3Qb2p3qteYLivOIwCbXBMGqQ>
    <xmx:uOtyam174EkivarNskFOka8Jqn3uyrI4kcovgciRhrzENh3T61yrkQ>
    <xmx:uOtyatA6qw1t1sr3hmbKMBk6u1xkUAXaJ2HZmZc4lkXmIZm0pg1Pqg>
    <xmx:uOtyapJbXTB2OBeeux-w8G7x3nOkLJCF5oMkSKboQgY1oixCo6kFbR9P>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Aug 2026 03:52:23 -0400 (EDT)
Date: Wed, 5 Aug 2026 09:52:06 +0200
From: Greg KH <greg@kroah.com>
To: dayou5941@163.com
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, linux-mm@kvack.org,
	liyouhong <liyouhong@kylinos.cn>, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory-failure: fix concurrent access issue in
 min_order_for_split()
Message-ID: <2026080559-expert-encode-c1b0@gregkh>
References: <20260805072625.2437636-1-dayou5941@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805072625.2437636-1-dayou5941@163.com>
X-Rspamd-Queue-Id: F1A0520005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tcrj7r4koy1ybu1qgnf4qz5y4gfmb4rs
X-HE-Tag: 1785916345-536626
X-HE-Meta: U2FsdGVkX19SnzC+9XqEJAlvCSC0vQnzmsCWYD90etopJgO2up+DPO3T3fpmNKH/neLPSEnXexzWufiqqp8uhUJwVMvZA8H3XeGLQ3a12Fzz/lFUNlDp92tetgNIIgVGL/Kzh6OtgDMBV7oJ4xI9FU9Wfh67XogTHXK9hHnfYpqQxstrBKkfaKkaySVldxf4jV0LkP9sYwdj/gUqdkCoV+c1xCbi/kIn2MmrmuhHijjKlUtSfUm2YS3O/ra9lqJXYqpg64KoR4qfkWgBBUjXA8o34qZ8R9z2ZmrUJadQ0pBtrfyRTehlKyHRD1rQqLyp/q468MqVHW/FNkuJKVcE1lNtElZQ9D/KphAh4rdCMTn30z/dlFDJYnbWepxy8hPjnoMHjUCYasE8FZI4MHvvOck8Jq0qOde7LzV8FYbzJrqW6DR9qj5KETIcQfqgzBfCBrQ//EhtANAo/S8U09H6Mo4XkgnmCg36QpCFjOEx7BxobNSLlMCY99+W9W7vSw9BAOX5TOaT0j0SPFTh5mW7AC/+iL3xreGf3UJh5jkJneMOZ4uSq+OTQy7UxkCeHIVYDkIeanZk2j5Y5WjpiB9HmGO/lmJTKFfTKUSU8jxZEDQzuFgUdUIIC4AFRqC4ykRDOgF38ZDKAiAqxrr4+22KLAQ/4ywqcOKElrYCZYcgfePouBq5gVUKoPt3x/sORx8yJS22CohhHR8aVDnjE/OWFg7VejvxRej2VGoofiCYTqBdsSeL0d90RaiD9OkVF9QTL7xYsA4z/6UD+yUKzsFHqxrKP8NcUgpXGEgSNtl/yldXfZysqijwn2PC8cKbqV/7eS9Kv9QAH9urlJjDKu4impOh+0LN9ROAVttoPFtWw6uXwKx7jgWP9wrHsnfpDL5qkVLTeXpEU2N1piEo4E/fpdxK3zuNRMLuSOaTjcUAlBD/I1XCHC2HoN01l3CmAihRAEEb3iwgfpC5FbroLqQ
 vTK4C9p6
 VoyxQQpD4jvdKOSsULhk1iGvOFq504cz/esNsI7DVqn26XmWLKs23rjBHvvLsTVK4kyi+KJFqLcXmckdXOCMm514pemJq1mag8tsUm/WG4WGzpuITWlJbjWQpKMCm9GaQJpBJwglH6ZsaMQr9ekPeUyMOT/kdMELdP+4v3pHRyWH101DnLNOzqBG8My0eIha2n1/L3MXn0Xti9noSlGvh5Bd82XmKasY665telxwGnKR1eqVhVw5mFE3W5nKhafGWoGq31r8wiAwbyrFdWePsoMr5uHr9mREK+j2d0YxZBigaKTFKhLOMzMGeThkbaDPLN3isjF6d9m3RGTjird57ztFcNEUoJtg0CWQ0RUVwcQLh708ZUa3yGSjn/fDbx28dWoKT7Oq9DmiHXHAmqXklvcvqLE2meKGBXMPxCBTLQJXVSonb413xQQlYPt18E+mmVAc/nTsOP+/K+IDevk43H/+RyHCzqxKAreER
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 03:26:25PM +0800, dayou5941@163.com wrote:
> From: liyouhong <liyouhong@kylinos.cn>

Real name please.

thanks,

greg k-h

