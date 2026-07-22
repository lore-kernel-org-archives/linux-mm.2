Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F0CC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9977D6B0099; Wed, 22 Jul 2026 09:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9490B6B009F; Wed, 22 Jul 2026 09:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8366B009D; Wed, 22 Jul 2026 09:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 335776B009E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:26:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A76E2C01A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:26:50 +0000 (UTC)
X-FDA: 85016487780.16.6C2A8B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4497814000B;
	Wed, 22 Jul 2026 13:26:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZXxvQz/+";
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784726808;
	b=MEBqDC4/iJOeV/oLa0wFvRjkj8qzGy3dRClKeaMRNpka5C15JN9inasYErpWpMh/glmVQa
	z0BGqIOCQ5wVyaZZqE7HYSiIT96iLomtW90NWhPLfstnlqh1wolf9aRJsABYQ4EDhIQd6h
	I6/8Wp6tQ6p1IDRqtdc+8pObi0hGMCM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZXxvQz/+";
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784726808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+M61kMMTxzMqLJW/I9S72vEXtmCkFlbPyR+NRZBxKrM=;
	b=o+BUGX7TdKqFhF2Xd7RoFL565z2PwkcjDT8h9qOoWmZA/4znv3rW4YQfLoFE7gZtpOSgnG
	PzHgDwmDFtn9AjADBNPArqKA+pbi3TI3Fvc7dpBQ+MZYduje6lZX02g1OUhQXZeFZ9Vxyp
	Q6JOlmhIy16LQy1EFtkBITDkg3NSBi0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1195341830;
	Wed, 22 Jul 2026 13:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409D51F000E9;
	Wed, 22 Jul 2026 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784726806;
	bh=+M61kMMTxzMqLJW/I9S72vEXtmCkFlbPyR+NRZBxKrM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZXxvQz/+5vEhls9X1WnsdaijtSh4+KMh+sWHRLjatPV9xb4hEbr8G7i+SgsJpyldQ
	 mfdIbbK/dtwweQdY6q9Z2dTqHvG52A7c0ZGpajSxdgBLMT2ZHax1fZUdkSJwotodwB
	 GIZ8il6H1obl/L2YNl/gvIQ9I7nGSRtDtHY3VNq7vMpOeuCV07KK7YlHMiYwT2CMau
	 PsBYdDJ/BmBPkoAkpFxvcPBQkMkbFXmT76mSfEXcHUk8JW4aoAwNQKlZUyKfOxL3CS
	 hmwrMiEce5S8fEue7P5cjfo10ImHtxtE2AnFwqacXJFSzF8f9QoiB5KF/gtv5iDKns
	 H6mqJTkUMl9fg==
Message-ID: <848cc2f9-9314-427c-90e9-39a6e483a335@kernel.org>
Date: Wed, 22 Jul 2026 15:26:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm: introduce vma_flags_can_grow() and
 vma_can_grow()
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
 <20260711-b4-vma-flags-mm-v2-1-0fa2357d5431@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260711-b4-vma-flags-mm-v2-1-0fa2357d5431@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4497814000B
X-Stat-Signature: 8oquaa6oaobnmt4c8f8rtcsc7a69q37b
X-Rspam-User: 
X-HE-Tag: 1784726808-226701
X-HE-Meta: U2FsdGVkX18K+wDYJAP2cR7wTFSmIGENwb98bwcNdu4RcsvKmhQhG7mzwqwvtqEpQ8xwWCDvWCpmqRu8NzlnC1PgWWc5txz8dEajYoSu32rLkxanMdVyPREmOj1bKGr9no3H1jgL3p8NWQsCSPqCs8GhDLGCFAqNtGJihr3iAcmKMhruxgsoePfoV0uakttbH+z+b9+tcXkvgS6IgwACLxZXljHMKoRMVZ8pijYWUHF1bUVQgDCmqgCd/A5Tgn1lsfE4JvqYghz8uJv57IH8tnzgf7Q0lHXAypLLgkbOqjK898j8/ChmcKg5l0JAU8kU3AAWEuLGoAPWbH0tHvUZrWn8vvO9i8TzFK7lodEigxFlGW951ZZG+2lErD49iO+iCd8aXrQfM1NN1myuHS0e+MG6sStET+FCzHtibjSAeg6D5fMHr4Yijo8ZBd9lGqYed1QHz5aViGO/Vz1VG4llBQGVneT5tWjPABkES23vz0Brqg90OlrcbMd3Gi2iv6MFtSRuYbCpyszElOKz9OzrX+LxYi6dkBQ4bu3EJb0NxngEytRjzFgDwm4zF/7opDb7xARmVkevas/8JaIZRTUHd5OjW7D24qe46p0KOUUmyOHMDVeVXrJkZY2OEWE94eRzB+DU87+MbJx9/g60NIpay6CUXXaTwX1IUfLZZ4FkvGOl0VOem8XaBxvLUU5JvMgQ6NooTKrIUzg42PD+SDOUTWTlbttPqXeAMiMefyBA03l48xcO43xWHMxpbjRFTRZ09miS9GpFOa7R8G00xxQ5i0SGM/plb/I9kkeH3KB/C9dPUJDG5kdQhWJ+3fAV28wksyHATpZaG/h9nhKul6icre4865EzDMlmCA5ej8Z6hM7E9OloqQpycxvH2cupHbq7LpkTNt9ixNmwuJhFAurR4z+r51Jgxcab4tcLBfkaOPHbePYBcMVMP6T3bBZAgbKLeelDxV/U4wxLor2NI8j
 pMmU44Uh
 I4lM3IXr8btjLOZpi9lXdX1VrfR0FZ7E90Er05aGr+EWrYUIkwtEi20xPsN8AbNGKMhFI8b8U6mu3ICLW+nrBMWDZS53J2FSxm10vc6SRSPtQ4W3LEKvGhNdcEVHKbfQPyddQ/jBTFwv9DX6+VMkjWzSySd9+s9XK7XidlsQ2wroqo2OKds+oRde9pANiw9Y3LsPxjW9kXheD0FFyn/VUn32MlLlOLliyGHzDz1ZzRQu7ctQCd/gyuDmubTnPSWNo3MHXA6wCdNT3ri3VWLMi1HV9WLhKo6S5K8S6k0/Hm/nuFLLrNPAmT26dSR4gx8wI/EibhRymBheNs2pFu+oHIYMbi7GcQBGkZpe3HyYLP+DhBOR6BqKJNHSwEF+w7zAo2MTvOC6EFFwxUPUcOv/3yfEtFMzhVPKYdpaXVDHUxU2y600CSKMQmzIEoyOXHieKI9dMC6jua7sU/YxvAU1mvPLlJbYAUbjjQaBeSe4sKVcZPZyG90FXQli6dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 20:44, Lorenzo Stoakes wrote:
> These test whether the VMA has stack semantics, i.e. is able to grow
> upwards or downwards depending on the architecture.
> 
> In order to account for arches which do not support upward-growing stacks,
> introduce VMA_GROWSUP whose definition depends on the architecture
> supporting it, and use vma_flags_test_single_mask() in vma_flags_can_grow()
> to account for this.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


