Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E25606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Np0FC7wl
Received: by kanga.kvack.org (Postfix)
	id 7A89E6B05B2; Thu,  5 Nov 2026 09:50:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759966B05B3; Thu,  5 Nov 2026 09:50:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6498A6B05B4; Thu,  5 Nov 2026 09:50:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35F8A6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:50:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0B8D1209F6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:50:58 +0000 (UTC)
X-FDA: 85401352596.28.A545665
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id C093F1C000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:50:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Np0FC7wl;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793890256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
	b=wxSkBDnQkCXN+NjLylJ4bmmkxk012VaQOTjphRC6BuvUfwVaigKIXv2LEKV+zLi/XjfkBI
	DABDm/GVnirkF31nckbR9jyceUxa0rFdmuyul1pwtYQLg6nnSygNRrQ3kmfoYdItGD8kSu
	YuxdKqlUSpZKGwnTkNAX0N/JAO292y8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793890256;
	b=pHuVm6mb2WKtQ//s1rErxaET+mjYcHYEGGaaxJ0PzIG0gM+gFtm5n8NyKDMJx7qlcDUwgB
	ykZHiTZLQCZOnZs9+jIo3LVYCMFgKa49VVC6wlQh3TuLTOEIzT0QpBKjM+1ssHlVGvjkNE
	wZdGFNfzcx11gnuuvmAra48Csr7eo44=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Np0FC7wl;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-990835cec4bso1099467241.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 06:50:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793890256; cv=none;
        d=google.com; s=arc-20260327;
        b=iZQpnPTOr0u3jxuEHdkSJPX5+F8u1qdAw1oljXYLPGcJC6aIQHIuzdJu+QtW+Aq76W
         x5IXleQAbwEUUrpjdZR3X4wQRGJdN51SKlYm1Og7273sggDbhyuVTjFTaWcvvIOAe9at
         B4RfSb6HPAYUNuNxNxCxHCelYQ2mdlppwbB3ecKdzxHQ9F/+8ySQOxpIrHQwvmfyn/VE
         bo8CWavEml1oHV48HlndmgHilc1HHoYu4tdyZ2mSUBvLM8QzTdCYN21f63fskegfgxFN
         5zY7M41UvRhqucrFViChPlPCkRXFgAvro5CNozMB8qPV6tDpn8n+/g+uV3d5P2DvwJDS
         p1Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
        fh=b5kJDo13zZh92IFCXmk5cx2N3hJnFpjhJ1O/mDr4k7Y=;
        b=U4ctjjmpB8FjlmA5XTpdoerje3XZlGWFV0bBYusuNYZEkV6UPdJ/xvmgNtEdLggk0i
         BgF2XMvJtSRO9H+hPOJ1eKO70zwA+TAL2u2ZZdsjuC9O56Hb9a4aexHsyEmfQlsZFHLC
         nOk59g1BciYR1nWzfUlNSdCl9c8g8IA6Uy7N4QOzRacLJ6tQqrfnhGlU+WC6IjQ2OEzh
         4iF7XpSPtImnEmVepgoZc5Ebhzk2Kk3cM7eQxwQMLxMnj/g4ayL4/uG1l0HAqmrILyWe
         sGYbo0iRtPHiBWofhaNqkMCySBGo+J2rLOYVOqLCobs9TahpRSumDZC3rJbd5Q2GQPJD
         dFwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793890256; x=1794495056; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
        b=Np0FC7wllijPGdyBl3mZgjVktE1Xlcx34HEuJzHpHRpIN1fH5dkj+LC6ag4ltDIpX0
         Ux31BtpIaLRJmS33O6+dLVBupBXId2QU72oIpUt0SejYDuYILurwkkQgyqMsyk47ybNM
         G7RrbyKDWz54+pe7fJWmwod3Y7uYlDJiE8rRBbYAdIoKBdTV+q7+5W/Xauv1Sg89N7ON
         L02fAAz7PMcct9R3egjHlL65bO+xPJ7OABSunH1C8J/eip8jJaOHsZdyfFzpnvlHMQh7
         /2VyGwHpwb04XsbWAinVRUEo2u8MxztlvfpEEOng+pcXo1bYfwP2/UTGmEl5mw9OdFeo
         F/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793890256; x=1794495056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
        b=0GY9U1urHy2FOCp7LXQPkLfDaT5I5YnzA5zLDFl6GR7crKdQHorLJg/HnO67yNaDCk
         EoxhlExqKvHJjR8XD2hv+cpSVIpZtc5jZCwlXURbXhbp4knJIqwU3qmpeSP2PCWDxozI
         8TZtsyAmSGYGTnP5MvZS62G5LkRVpR2AUHu5Pe2qWmpbFFz8NTzr0nXWuOiQWlYVyLBW
         JrNDsZhEd9EEkg2OmsFsuUKhZylGXO3pQIb94orNtcmNb+P4YnamZRLG7S86odI/wFTj
         G3xBdKP/y9porpcQrpomcG6kENr9rjW0eKZoPNoKve0V2pOAVL8S4WGBr/RIblsUIlWv
         ESNw==
X-Forwarded-Encrypted: i=1; AKwUvByY+K+HyuRqimFkKMU/eknhk6sH/xlLFhnl+POhAjh0ldyl5iDjvY4L8+WsOTZjP12HV8Nl1kvBbw==@kvack.org
X-Gm-Message-State: APuU4Z+5wCKS+qQI/Sx27ZtcKtoorzs0g7//25y+Z1U3YplEbRlFUex7
	EvGa+ls8fdMpCXFNkzxTESb5SbPrKlgHzwJqeGhVbOahZJHQxX61nCYCAFjbEEku0jQ+XFubEeX
	7OYWohdukriDWXX11qmZ9unvKDNgJb78=
X-Gm-Gg: AYBFou07BZpVwMjw7w9KByGt4PrOoUa+g9I3lC5aGNerRJicfwh3QxJPppZz04XfJ6z
	eTJaTO4ROOFh9YvXYJgLhfInW5MyT82JZw+JFsqp2hxTt/qt2AWayXBMui91y99KgxvRHmkq/TA
	RecSEORw2p+Kg8SHfHnlZR3cUFFXIJcoV+jayKvpj2jSogQCX20XW6AJCD1Xl4ZkZ81TaVV95cx
	q1dqS0C5gzQgT0JWFLWwHgDOasifSdpDInzEKoq5mZQbz8Iph/PDTmP/Pu7Z8gmlYCU5ObeyllF
	KcA4OS/W7iEQKtQX4OWCjy8QspCDgNfeKPUgk+ok822TGGl1wXWwfYa0D6CXUAQiHV1029oOgvC
	+PSBr80J0HAeAmaUgjAI/bJeme+YogbYgsvcBWep7H1Fkrvp4A9QQ0tiBT1wN7dM1VjOKYOkTWg
	DT6R7YGUiP
X-Received: by 2002:a05:6102:5243:b0:7cc:115:ddf4 with SMTP id
 ada2fe7eead31-7d072cafbdamr9042312137.25.1793890254113; Thu, 05 Nov 2026
 06:50:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com> <auwfZj6QTwQqFIZb@parvat>
In-Reply-To: <auwfZj6QTwQqFIZb@parvat>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Thu, 5 Nov 2026 09:50:43 -0500
X-Gm-Features: AclHuK8f94VBTeNgSM335yz-5hAFVlY2uvlhDStBMta91PSr4DplroD4jKbuQCM
Message-ID: <CAN+CAwPNsSWyqbKRGEL_rtrz9CWTdFvhKFvZpbUNoJJONXxuZA@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] mm/page_counter: move stock from mem_cgroup to page_counter
To: Balbir Singh <balbirs@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Harry Yoo <harry@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kjcoisn7kks57e39oa5aa715ajtcrqnq
X-Rspamd-Queue-Id: C093F1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793890256-903253
X-HE-Meta: U2FsdGVkX1/wEoofPRdGYZ6qolSSSsRGZ23KAHKU8zMc9grCglVVYcV1ajZFHrIwHuOdzaLxTOqkDC76dZwWXMJUFUvMfiQ99HdTaAM0Hj+nfuTGPMb1Q2MVRfOzE51eXXwlPYnDGF9ETgAmgW5Z/P2yS7lLlVxJotK+Re1DqMOSdzElzJSv86X+bbDIiFXQB275BDA9XawGZdH7AYBQYVluY1ZR5kQQ3unZTFKXXXMliQsEY6G1QjNxM1rrGcmcLwr2w86k8k+I06yOBtrYc5eBuYtkYDM2FJlUsguhGmOsel134Tv/IXAE0xuSlTqy76tI8BcbHk0WgyngyfeMO2DmsMDfz0LrlD9NW+LJ4pBk1Juv477z2soiBlZUbnm6Up+X/lA+jWD82S3medvyRoS2+HzpHjDpduZr3OrP1QQDaH5lRf4T3+4s2B3fzLeudQQqvrwcNnwEKBBzcLJ9r8GVLaH4lwl9HCVHB53KOWshdNxr6c/xpBwCd/f0FMY4B6uMWaFcG1pTyMLrKKe420/UnlBgAPyMd4a5vTfHZ8koJVe8C5HoRmQgYk3aGdCumij31UPBHT+vudgZWx16VIYqD3H4HOFEjPMhz+GQMy1xgdMYJtBmtlo/OXz2dNnx6VZ6eCgILazOyTGoq/eDhdvduJIctPd02wEw3OvU8YgqWOZ8E5+Qo0TqPl/qmdsvJ3UWCOK7kOChcplMwIhGhMzXiFS7QUpV9u+hWDZLr/XVNnmL85wZRD96ICnXbKDZn9421Tjo8NoEPXzMtzdU1Lc6cOdiuRVt0iZJDfloEcCwoV0b/4o1EAWAn0a8Ej2s/+ML+hbZ4ASi+gaDRD3AFdPcz1/hcZmpHVfPq6PY9PXqCjkJpxikwm3aiL/vhhq7htjslBJDd4ZUQwLikOXGR1fNbBeylz8ZhiL6DHB44lzF535RCxLYJzYNb5l+F1fTxRiexgfi9t0JyPqSc/5
 y6azY5nY
 smgE47vbYqjLGXH/qygdZ+Nueybwik4GRnBJNQBGIR35gHIOjWocsXLDUaaLZdPzyYY6UtuMmh074iY2mw2/TZLMZ4M5Uj8C98NjOn5ntcFu6XkpQhb6mTNct9bVFCbVnTQ5B/lpg5Kkm1R1jKAAoJvm5z1EFhJeVWeMdNV7LrBB+Tms1xr+PANmVhhQRaLtF11Btv+MqM5iYJqhgB3jTo/Nk+QS03CMoWRz73UZdg6MG5h6GE7u7lv8mGmTKDHAP5jOAKQMqvE/Ae9yzvssy7U446tw0bOMqQ8u4VfMSb5JE5If8CAFhoIQ3EuX607H5xdBk98pAiXC0ebe/6wDb1Yhb3IWcMfzy61Es61FIhY9F8klSL08RtLjEzDnAMdCt21AKL3J+jClXDT9r1bBhChAWKidfQX0HxntD2FsADlsyrCtL/zr2pEmiSnhdbQI5D6wHnILlJdKzgQOlRwAk8E5L7QnIsh/mxSJ8GO0eNHy1kyPwKsjTRmuk/Frj+37pyAtTbddesjgCcCWd6Dn8YHcgZYCm/W803/EPPRBcvBSvAgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 1:17=E2=80=AFAM Balbir Singh <balbirs@nvidia.com> wr=
ote:
>
> On Wed, Nov 04, 2026 at 03:30:21PM -0800, Joshua Hahn wrote:
> > INTRODUCTION
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Memcg keeps a per-CPU stock of precharged pages so that small and
> > frequent allocations do not walk the page_counter hierarchy every time.
> > Today, the stock implementation lives in memcontrol code, even though
> > the operation it caches is a page_counter charge. This makes it
> > difficult to add new page_counters to a memcg and preserve the fast pat=
h
> > behavior.
> >
> > This series moves the stock into the page_counter layer.
> > page_counter_try_charge() consumes the stock, charges a batch to the
> > hierarchy on a miss, and refills the stock with the surplus. Memcg no
> > longer manages the stock in try_charge_memcg.
> >
> > So the stock keeps the existing layout, which is still a per-CPU bank
> > of 7 slots, each holding a count of precharged pages that it hands out.
> > It maintains exclusion using local locks on each CPU, and for remote
> > drains we schedule on the memcg workqueue.
> >
> > This change gives us the following benefits:
> > - Separate charge caching (page_counter) from charge policy (memcg).
> > - Makes it simple to keep stock out of interior cgroups on cgroup v2.
> > - Prepares for future work for stock improvement, which can now be
> >   isolated from memcg changes.

[...snip...]

> Is the main motivation ease of addition of page_counters to a memcg?
> What would those counters be, why not add them here?

Hi Balbir,

Thank you for your interest in the series! So yes, that is the main
motivation but this series offers standalone benefits as well (which
are right above).

The new page_counters that I want to add track per-tier per-memcg
residence. Those are used for enforcement (and not necessarily for
visibility), so I think they wouldn't make too much sense to add on
their own now, without the actual enforcement parts.

What do you think? I've also linked my tiered memcg series [1] if you
wanted additional context.

Thank you, I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmai=
l.com/

