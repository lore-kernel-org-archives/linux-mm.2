Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05840CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 14:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D126B008C; Wed, 10 Jun 2026 10:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CF66B0093; Wed, 10 Jun 2026 10:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B836B0095; Wed, 10 Jun 2026 10:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41A1E6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:41:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8C37161823
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:41:39 +0000 (UTC)
X-FDA: 84864266718.06.9E14607
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id D118F140011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:41:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hbhtbieh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of doehyunbaek@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781102497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3ECnoRaw03PN8SDn4t5pTOE7Fjc8A5WosNk33q0VdQ=;
	b=GTMNxQlGooz33kFEx0STLKyPBu56xyQzfrWJT19T6LZQCxmsl+OjEniFPt10cjXKBtcEJT
	lXZiQWFK+sWCxaZ48XGfFcyuLpoCTe41kksdfTBnh4WheaAXThSqr0UzEu23fYLwUPUUnh
	MhdZ2mwpegYtJtHJPGDX3Ukc58kbRPw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hbhtbieh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of doehyunbaek@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781102497;
	b=FJJZlxa6NBVf9z+CmHkdH+v4QoCUGNMk5DlF9+YtRHP+q+5FwlbeHb/XyLF7J7KXGDxv9P
	i5X75nq5qeXZMMQo4Tr1jNcERLDaxTHn4FTXGyzRgZKk38sYyQoNHb1r8yUhMbTlDcdZFi
	/EbU60avNpmxxPne7mQ91CKzVPXkWjw=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-660480b3982so557525d50.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781102497; cv=none;
        d=google.com; s=arc-20240605;
        b=MzsVPYQ2SzWPZQh3qIo4Q1FfkaXJ6Ps4A0iJU+jnlU3C9jy1c8lgyUSknF5CaLOsNF
         ehWZFbCCChy13jEwmceabAMk5Ap6maj4pyZ3VlMxp9Z0Q1Rt5DU6N7Hqj1AnleS/g5zc
         rWd/ybEkSe2VhuCiWRVP3uHtfW6RfRE4NJCaHciXqbszElpZ3IrFdvi+bBKEBSeDrqeg
         hRnFhtQ0xP5oAUcdonO5VoB5cEdnYmyMyOOCm3J4xZLg62mfTDaWN2LrUgO19FiBDDts
         PKR3dh6YuqXw1i2mMGZ+84a6DNbD9dz1aAuZrjRny+0gm743ElkwCoiCiyPplNE98R9C
         w4ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J3ECnoRaw03PN8SDn4t5pTOE7Fjc8A5WosNk33q0VdQ=;
        fh=QSUSxbPxNs+PuBItX8qyDBtku7lQovHRLqLjOgFb1pY=;
        b=V3PZY16YYgMw19N6Q5s9EH2MFcq87YIzLY+qIA6eEvyrLZYjRKLH2GPOaV5tSlD3BC
         uOHG+2pBJivXwHUBQdQX4BgczsLesZUaXwzqqqwUZpORZLEXdTIGgnAEnvxtz93MjUXj
         Z0EFGdX5w3gQU1JBcNR/ESn0hV9QbxV7EN73AuK1AX9Om6USYI/rLQBu080UDDkODx+9
         2+jhuEDlee4dnXJf4EQyhPrTGWctzatiQEPG50biXJJlpm0jxTqDQoNhVgmYs8Jdab99
         yf/WkJ/wo/dbLzWCf2XAOspCOkgrSMdXXUGzqBkXfpUhWKfH7V8LCM9Sq/oER56Au1XJ
         a7XA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781102497; x=1781707297; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J3ECnoRaw03PN8SDn4t5pTOE7Fjc8A5WosNk33q0VdQ=;
        b=hbhtbiehdKVgSICziEPLLJcx072QVrkci7MMnQ8orYBAfl+IBPgi9F+K36MK3PxHAF
         JRZEiLlXYAj6iGXbpDL9XPJzbK6Xg2Ll1JZa9pqE4CPe3V+y4nKc2UmrRBBfKpM6/QZi
         RNGNUobMsFDaiFu9T/pSJKAARfidQW3gTxOdCWPjLL36dnpqfZYfCCqz6nxX6Uujha4b
         JugQLqUcAFd8RyUlHxVdyWrk49zcOENTKeIkkgRWmihjkpVQUOFXDZuHn8Folpc0Wk2l
         2wmeZ+Gvc5XMLIepgqlQtAX0cdVxq240xNj+g36zQBhC3OZQtsnWmVrUC6rZXt13BMeI
         IFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781102497; x=1781707297;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3ECnoRaw03PN8SDn4t5pTOE7Fjc8A5WosNk33q0VdQ=;
        b=g0DqJYkWcPlFgxKS92Vg2aedTrkunQsyA2Wbjfof8wyCwgA8ukYPQ9CR1YOoFa7yEV
         P0j+3K3TcYnL2fQRGPlD6kWc2CheJaTZ6XK2hTvBtCZLcCV3UNUW8OC+x53ahMTkPPw2
         LUzqlcFBNOfswEu6/VCDRuSNgfI+cVdLwGU8KKqvPBSxjsDmdmAR4LLMtdY5hpMpSHbU
         upeeOU+k/LdarUC4nr41BU2FAW3IW5cCzO+W6m5iNLshmU/wCOvjr4rY3pp86dUNJkoN
         gB2HxJ+RdO6ZFd7BTVF1lQMUALPs1/45HcGz7pLEVNAQSYvfXiyYNRaegoe+q2+yQohM
         FinQ==
X-Forwarded-Encrypted: i=1; AFNElJ+DrZzYZw1Iz194A7/427NoluWD2dqGMp3byRXCfAFww0T+ULC9EirI0Rst6bb749iqUwQ9fZCeGw==@kvack.org
X-Gm-Message-State: AOJu0Yxv+3GDNVj45tz0q5rcS+HrRG2TY6W0X8bmZCC3OIZVZpAKDjms
	YG4vM0LpP7qtxYtyz6JN7VVa5N+VpJjRAlDK1vOxPgu8TjEmP4QZeWU2h6ZHKUwbwKQNirDp0ql
	68ASuBRUNis1LWW51BIoHqGPdU8vb/tk=
X-Gm-Gg: Acq92OHrDex6a3pvF+MnWWmnN+JWUaOPN4Yw1HznjXjO9HDsZfi6GL7clpCPOg8Ekp+
	l0pPHgJ5ywi1Uox6meWoeQOzdBJYs3tLEnr637rFWhw40mOxxpxdaTbVOFDD7yW9JasopN6UJ6Z
	f8KocsiZGaHY0QUSK8lRyBNP7EB2ovwrVfUCAGUHFuj3cl8sz7Sg1JGLTlpQQKUbBAxlhIfQxQ0
	87Ae8WVnXPpF1l/7j3wgdAWU5mJhESjewAErmZ7N64NGzsEnh2MPOSjYMY9IoWZNYP1dPT2LBuV
	RgLaEaRmckrcXYdRC65ayjQL9Dc9ge7qmTgOj8jaD7PNC+qjN2oNj4b9Y5mnnGQgPmkzm4GXGEP
	JWe5eO10=
X-Received: by 2002:a05:690c:c510:b0:7ba:d784:8b59 with SMTP id
 00721157ae682-7f2b24517e2mr46666727b3.7.1781102496564; Wed, 10 Jun 2026
 07:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260610053951.553739-1-doehyunbaek@gmail.com> <20260610140217.65110-1-sj@kernel.org>
In-Reply-To: <20260610140217.65110-1-sj@kernel.org>
From: Doehyun Baek <doehyunbaek@gmail.com>
Date: Wed, 10 Jun 2026 16:41:00 +0200
X-Gm-Features: AVVi8CfkGlQtzkdy7N4hrt8LYt2S_-OHJvl9Twtw0u9LuNxesLYSD1U1AF8K38Y
Message-ID: <CAN-j9Upu0grcp=AL42m8b41GCnU3+CUYJbj9=dg1esUAJ0hguA@mail.gmail.com>
Subject: Re: [PATCH v5] Docs/{admin-guide,mm}/damon: fix DAMON documentation details
To: SeongJae Park <sj@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D118F140011
X-Stat-Signature: fmdqhumhyjpctmg898j6ih8iiin1ogdq
X-HE-Tag: 1781102497-86543
X-HE-Meta: U2FsdGVkX19KGpFyIvvDfAr/2bfzZK29W2LOOPcuXOJkBvAOyPomCByk956djZzLcWPRl/hAw5w7QmXph1Jl9sUnzTvx8jUbGoOatJ5f0kX7Cby8UMbxtuiq8ip+c1Se2YYb2xOoClO/RUHGoEc4zfS+jI9deLZJU56kb4dqnGoYGt2dMuYDctLxFRfIaI0v1sTRVStW0Xyah6I88ZR8ZHTWNRiccI9Dkz2CJt7E/YjvxkjHUWCPLoHbMWkjkck4a8i71hbFnNLOYnPfcuEDXsGANHYAuBtf9rOFXmv7TUz+GqP92C+VuKm2xPWFKsG2ljcUtzIOd6dbdeN1LR7z5UfBgKc1K+wmkgEBI9TIMOg1Ev16srHYirKgky5Gu3bShGfqFGueY/vbgtMZr19ukv78nPQgPdOidQX9pb/tpANk2gnWiOdWO9E9YdnIQaJx/r+hNfuCFsHLjEBwvfq4phzc3j/ynnHMfrAfPWmmsPc5M8uTBy+XW1ZsTD0Z2W7JXFZio3RUOtwTfhf1M/2eOsM3qwZHFdAzAQAJB03UDyV1aokfbqbWj+rx7KQ+qHJMEQDxLkXTP5Buabzg9lrcyw3UzGK/ZnwJJ29Wl9CI6frE3LIi2pay1NG2z2N8Uy6GtUno54wdEg+vEUxijA3qS/GpldBx/xrj6N0ucrEbnyrKxSESTgFFsQFe+uPmu+9fWwD9YgrTwG2VtbWXyhlbmJZQxUEdEgQtV3P/q0XOqqax2bwZ3ZwhegcjD9MYafE0zEpmlIFTjqnIQzdqr/byK7WPbYMroamr8Qg7wCUz1jDBdkHcTJdV3RE4WT+mlIlF/KFESEbnMJ3imH2zuQoKyuJfa9c1ApIuFp2h/bSdrwNqIXz7S1/xoIfQZcjUKIQz+JzmgpwxlFtinuyb0zlYS4I0X3HOXPd0bc6PVOKjcO8H1IA5KtX6tKFSAUw+uaFp7+4GQ/zwWT3D6JdiMT8
 FZ34StHY
 5G8cZntIpjgLcTPO9zvn4uLUoq8b6IVqafMkTOG5g8qZWGJo+otAiT0NhRGleDaMhT1uQSZxnHzIyv5h5Tz/++SbOsS4SwvUlSUdnOfQ6tCBnRGLSlhIXQRLOmGBEi9+2OMKaGMJZMxs8aLtaYOb7O4yEi8uWMP3gx7FdQQve08VOq5i3zEok4mZrawON97anf+bfrOFdVf/ShvNgOzRgvh096hxZz+SjniSX/NG6vSK3vrzee1Xw1R9okRMF+4FiILWbaz32ZKpvIb2NN2cKSIEXwnB5NHH5HJQXqr1MH4w+ZHcvM7HRtdXXJfn8XXw2LCofpgS3p6z11zoPi1eWr/BEhBbcHNdzMrtmj1ewW4BR6HNJ4Q5UluB54wsU6Ec9xaBzy/dJxS+04C0bXM+dnu38Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Let me know if you think this is really urgent or I'm missing something, though.

Thanks for reviewing and applying it to damon/next.

It is not urgent from my side. I needed the English documentation fix as
a base for the Chinese translation patches.

Dongliang, would it be okay for me to send the Chinese translation
patches based on damon/next, or should I wait until the English fix is
picked up by mm.git or mainline?

Thanks,
Doehyun

