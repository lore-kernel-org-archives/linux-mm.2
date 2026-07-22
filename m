Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702D3C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAEE6B007B; Wed, 22 Jul 2026 10:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2DC6B009D; Wed, 22 Jul 2026 10:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442A56B007B; Wed, 22 Jul 2026 10:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03CF36B009D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:31:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BC1580203
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:31:45 +0000 (UTC)
X-FDA: 85016651370.18.856690F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 26B831A000F;
	Wed, 22 Jul 2026 14:31:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z312ICh0;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784730703;
	b=4l9jhPoPvCjX8kghCQzfL/W5ST0BL4eIob3B5xvtjQXvXrQSVE+rcO3Y/uwuvUrZxzG6rH
	+Y2ntp7aiOqN3GI4/5eEvGjIJNxIVY7uGujF+BhLeBcaG8yT+fvcqUlyvfOW5qXTbQU6KG
	RlGLuBryQehEdSN7QJ7IZsRLkXTgWjc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z312ICh0;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784730703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvPrDFwM1EEVYtQ4pZxzQ4Crg7V635gU058Fwjy4pjg=;
	b=38ySE4LA3bD17B04JYbWGNXFhSP5r/k1JFElZvEhpW2oBXXcEtUC3+yNR4fILzYlQkarEM
	j2Eh7EzR+1gNRToQNFKwIK4vSrIbjBv4hbqb1hu9vR4ggrlePrXCZJakbgpW0dPNfpD33/
	KYpxQQU3lOrTJVdzhQuuRDJeJnnMXeE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 664DE600AF;
	Wed, 22 Jul 2026 14:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735B01F00A3A;
	Wed, 22 Jul 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784730702;
	bh=OvPrDFwM1EEVYtQ4pZxzQ4Crg7V635gU058Fwjy4pjg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z312ICh01hwf5PNipjdUbCmTEpxOFlzpFrFpEbvVg2M62vqBeTEwf2myPaFZw7tPE
	 VB8S2/xH3Cb64UA1VtTgUUNTgWkDHNnMSRIScWWwylFYdqQUJf29ZSBT+8tvuVKFT+
	 qpgOuQvv4nbvr4jbtsA43T6qNk4ivRr13hGczyw/g2FSRI/UCbh4ijU+6nZylJLPk5
	 +vUMLKp/zTcjlaGh9h6kCxmkwMXMYDyA4hWh4uxOZC5o0Hhq3C4INZyEa9oR4qk8id
	 AL8BavBz/vrgJflUQPB3q0Ym1iVOZACXNzbgj3bOumnwJsWuqmyNhwK6KU112+LaeT
	 oiB3ruF4FVC7g==
Message-ID: <0c9b4dbb-95c2-4d19-935e-18a45d8aefd2@kernel.org>
Date: Wed, 22 Jul 2026 16:31:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] mm: prefer mm->def_vma_flags in mm logic
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Lucas Stach <l.stach@pengutronix.de>,
 Russell King <linux+etnaviv@armlinux.org.uk>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Peter Griffin <peter.griffin@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Clark <robin.clark@oss.qualcomm.com>,
 Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar
 <abhinav.kumar@linux.dev>, Jessica Zhang <jesszhan0024@gmail.com>,
 Sean Paul <sean@poorly.run>, Marijn Suijten <marijn.suijten@somainline.org>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Sandy Huang <hjc@rock-chips.com>, =?UTF-8?Q?Heiko_St=C3=BCbner?=
 <heiko@sntech.de>, Andy Yan <andy.yan@rock-chips.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu
 <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-aio@kvack.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
 <20260711-b4-vma-flags-mm-v2-5-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-5-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 26B831A000F
X-Stat-Signature: r45dn6qhzz1wrm15b5ypczhyjhwot5dr
X-Rspam-User: 
X-HE-Tag: 1784730702-475626
X-HE-Meta: U2FsdGVkX1+6+lTY9oD1XwTVXTnhLxmchrJ4PVrCrFBTlubEdtEDSbSkmWtEzTpgC12c36POMk+IDP7Ok7WmgYON7ZaWC5f1Y0Njlz+yZtA5yO4zxJDCZmw50xqnxeIGtpr3LD8Lepb0ITNc3LkHhUECOBywFBvio4oSHKeGtSz1Fd9Hjbsmj5iTPtU5m56c0NujQqPrDU5cGWNGbo1inxYMKHFHDfc4Mdk+syJ59gcn4OOAtdSl3h5cZgqOVuwAORZf8yQIPrCcAl6Lq9kDdUoOD7urCglgLbP+xkC2q+HaQLL/RWFgIzqz+ppNm5R9HIgXghgAA4nI60g+aZNjqEGG0xRJnENnv+LCSbZTpS9ciSCuE9w1wIRA5XSB8FLGUBe9HpWvvmwhsVbUueT1BDvHWm73NaPysWOjAxyQR2klJdVGB3yu9s/+aMCj2Mq7WiSlojM0/lfSdVDZWLxLRh+XWHmLJVOe/h2wnpZcLKwzX9mnibETNXgTWXcVRmlMS+JimMMCVLo5QIb9egbXH2sFp2WM0NI5fOfqrVlKAe5/n8AllAiH+XK3cS21i+tY9cKdb1RVBfZJCGS/+Kmk5gZP0XjUDH0rZOE1p9gmge3bl9hrUiPElAgg/9RxOpjya39c8rZXFkT2Hs28FXXp3QpxZltoRth6RVJHE6+Y9jAfDkD1D4I+mqwWYqOywlpbKmInD4cOOFGN3u5Vg/9Jze/br+7meekJUXW4PwPobFs542O7E8rTrMK9r9l6TlNS/Btb7sQrwQmgqkF0rkQTMJP28r74ql8VFkKbPLok+T/EDVvoaoYzTkx40EAjufboboqspik5qybuWYrHnlGMjw1KlAIwJtDtbn3Vqb7F7yxVGVhSPNK6tvFfT/fMLB1oheKeQkO5I5bWNr7TF4U73BdDdcwNcZQj5XpOlI+BgTt0e1HxwjAAlPe0USRvFhXqHNw8pWLzSjjsf6CCa/l
 hO4Hn/5u
 RRij/oP+45qRZR0/hTHGknHXpFnDZ/auC9MDdN3NvezUMEfReqIpJBh2r2rTBdWBOxd1Ml3LvqOwhHl4fi8tGRaibaSgBfbidPg0O0sCEajKjyLELfEUITK9/4x8nnbBr+ygaZTAD7HRWvGq0x3IWE4HJAzyYbcPFrOc2meOu6NDDtb8Xy7yReCnqxBXnbYMr0I3PMY6OlO++jf4Y9VS/3HVozTtb9JQVg0rJfwxePs3GgBUAGoFVnBce18DpgcyK8lAqflTRsLa84Tri/Aimlb1nOpydgvT5pjq9xEekOMxdTckZgtApaPNvUgAvWCONv4/YJVHBgc+qbXxWWRRqkiUjb0WJ7fKD3xtJ9WBN2YKTgunreNzNvAFwhntb2ZZLMjH9e+eg3JeOIwAp5Y7gdLAUTe0a+TzqkCK8WVjiWbmjkR9uQDRZa3wUlZhym+XhHNZwRh9fEC+ibjIFU5uwY9FHew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:45, Lorenzo Stoakes wrote:
> Currently mm->def_flags (of type vm_flags_t) is union'd with
> mm->def_vma_flags (of type vma_flags_t).
> 
> As part of the effort to convert vm_flags_t usage to vma_flags_t (in order
> to no longer be arbitrarily limited to a system word size for VMA flags),
> prefer mm->def_vma_flags to mm->def_flags throughout the mm logic.
> 
> We update dump_mm() to use the %*pb format which means we make no
> assumption about the number of VMA flag bits on output when outputting
> default VMA flags.
> 
> No functional change intended.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/debug.c |  5 +++--
>  mm/mlock.c | 13 +++++++------
>  mm/mmap.c  | 11 ++++++-----
>  mm/vma.c   |  2 +-
>  4 files changed, 17 insertions(+), 14 deletions(-)

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


