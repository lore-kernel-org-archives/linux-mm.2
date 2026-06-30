Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994A6C43638
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66AFF6B00AC; Tue, 30 Jun 2026 03:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642666B00B2; Tue, 30 Jun 2026 03:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509E46B00B3; Tue, 30 Jun 2026 03:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04BA36B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:57:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71C7F140376
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:57:43 +0000 (UTC)
X-FDA: 84935824806.30.DDF2FC3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 35B2E160006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:57:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TCj059ky;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=scbLV3fB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tB7o2hVE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H4eo+7cv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782806261;
	b=47wtkSyLFXueefwe3/AIkVFYJP5tUpzFh2wrBY5wSpIjm8LXTFpoLLjVWQYGKOTRWRUg3R
	Nd3s0oNCz/6XDm+G3NppgY6TmdP3BpdWN+jaFZOG498AKBv91D+Cese3O1zn9sD33Sb5pL
	1vuOGlYZkadAevJ7hPyuazSlidhjQ20=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782806261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQHCNvm5iCydx06BYNg5wSgQa22mMWiSbgAwpdJ6eo0=;
	b=yleP1MiZJH+SDTZ3CZt6Y7XG050NrAVfi5ldfxoNbHQa8rZhifbrpW9OWpV53VDKtchhOF
	czd8hAG/w3u69WsJwOPIFRHVInnKrmLp9MmO6rs+FCVv7+iIMAA73ETh9NwQVQtLs4XCHd
	v0ySP+NHS0H3vz8cIJGDjWvVYF/HNO4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TCj059ky;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=scbLV3fB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tB7o2hVE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H4eo+7cv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 554717351A;
	Tue, 30 Jun 2026 07:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782806259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iQHCNvm5iCydx06BYNg5wSgQa22mMWiSbgAwpdJ6eo0=;
	b=TCj059ky++vMgM2QvNFn9/ABeGYUawaK8Dv/kSoYP+ONT6VTlDX8yQqlAkbG8KhdS9avzJ
	TjAiLyDHvWXVfZpZ5bmxGOTg4MGdzM+Ct5x66dG4naG7kv5tlRXLM8+fpoclCragTQXr5z
	l4T11swnBl8LitfRbVCHJqJMI6RPlNY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782806259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iQHCNvm5iCydx06BYNg5wSgQa22mMWiSbgAwpdJ6eo0=;
	b=scbLV3fBQVk1L+SWml2DR27VJhqZ2trcAgXHjdB505du65np2Jnm8pG4xRF2kLQLD8tU5y
	LVJWgD61d/WhcNBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782806258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iQHCNvm5iCydx06BYNg5wSgQa22mMWiSbgAwpdJ6eo0=;
	b=tB7o2hVE2NY3ju+y5PzpGlEPnSG+rDztdj+v7T6UMWhCGwDkS9Aczg3Kf0cGsxji1WsIwW
	+0lCSt+f8+3jzgwe/84P9Nf/cP++BiG9bTzoQYiJyKjLU6mKxnPEj+y+NgWyZeG+g8KeXH
	rfE7zcfrtlxtXLoy0H68mQZh35eK/BY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782806258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iQHCNvm5iCydx06BYNg5wSgQa22mMWiSbgAwpdJ6eo0=;
	b=H4eo+7cvHga0nEJD8ke0xovVvvECqvwyQliBIgkoG2uIQw+ZoTpxfgvLHVsTGVHJENshZ1
	5Ib6rR6lGiHJjNBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 78828779A8;
	Tue, 30 Jun 2026 07:57:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id argyHPB2Q2qYcwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 30 Jun 2026 07:57:36 +0000
Message-ID: <b64fa406-f66d-4b98-9916-d2a4896e5c81@suse.de>
Date: Tue, 30 Jun 2026 09:57:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] mm: introduce vma_get_page_prot() and use it
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Lucas Stach <l.stach@pengutronix.de>,
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Peter Griffin <peter.griffin@linaro.org>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Clark <robin.clark@oss.qualcomm.com>,
 Dmitry Baryshkov <lumag@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Sandy Huang <hjc@rock-chips.com>, =?UTF-8?Q?Heiko_St=C3=BCbner?=
 <heiko@sntech.de>, Andy Yan <andy.yan@rock-chips.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Zack Rusin <zack.rusin@broadcom.com>, Matthew Brost
 <matthew.brost@intel.com>,
 Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
 Helge Deller <deller@gmx.de>, Benjamin LaHaise <bcrl@kvack.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Kees Cook <kees@kernel.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 linux-fbdev@vger.kernel.org, linux-aio@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-sound@vger.kernel.org
References: <cover.1782760670.git.ljs@kernel.org>
 <3bb8bdc4788230c33102166d56cbc5abfad9d4cb.1782760670.git.ljs@kernel.org>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <3bb8bdc4788230c33102166d56cbc5abfad9d4cb.1782760670.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35B2E160006
X-Rspam-User: 
X-Stat-Signature: rdbdjmib9bx7iwgx1jscuy3xg8pqcuy4
X-HE-Tag: 1782806261-872316
X-HE-Meta: U2FsdGVkX1/pFs0P+IoVWoTNWro0A6n5exglnfWELDxsa3fZ3HBeMcBp6HoDuJOo6WVDGnjh488osHnUDl2wQhX4sSpLEQcyXBvEXsOfayp6PQG3bE+h7SIrNgWvEfbFwmO8S1iMaBytYFSGXikk18+NYU+XHBADPfekQ8AUpVXen2foqmZB+4jcgbCVD93mvVgzNy6C+lcCZS/+E3k/Cpt9unmcg9qL3t2n+w/n4Ua45Pvd1act07/NvY5wAcTrQFDk3JkA5t0uGMteajSUmr8ECne0+Q2Dfmba3ncekpPKybWvuqjkBsb8SlJZFUphUKupvHQs8LqMdcDR3vHCEySzW2vfensOLTWFu0HILx3wr8ZLRLTZOE0GW2Jd2W5fnDvBS6guYqGJOpVlW6qc6Hf46NLqtUAwBdcHWW4ofidTlOGLvbt5JKrtEW54aBMjHC5lHWGbKpNIEZ4nfOe7mulTTkdw5bbcDlniehK1KWJ2Kf2R99spw4jZS/YeSv6aEHkWUR5D/CuJUHnSkORffIAtm5O4PGZB/pApSqVxjoFR27qBgdtyPHXTPj6FC0KPG9/ghItFHoR2/xeiPZNQDLgS1zuY38oEYOozjQWWMmLHmUejKMPh90Kjd8qj+uhajNbUmPVV2RpPLsXsFuTnC0UpMcGaRVAcg1u+vUHvy2zcsgBVSuWtbIPonAw1pKwCh6TNid6TEbxaYrQDbX2l3TvGL54tkxNQpJmaW2BdFYzLlz5JV+lrOVV7zDkrP4UXoLm7VYh+egTzMudWLtIZtK1cMdpX4sawsGn9muE0i1j9tJ1ffCkwn5h5zRkMJ5XSWeUpZ9LlnUr514OJGv/ulzhXwNewctfz1QCI3aeHvUlebKqRmuoq+Pq+46gujNroOSncIeI/lVOIO1Il29mzZOvTl0s7rxPbk4L641Z0fBcDH6HlVK8YrFebe2F/OC5fcxOBuauT62TFYbukdEf
 j2D2UCVl
 EMxI3OU7awJQguMNdFvid3FV++N3skvb6gVasNsf1Oo+G6YGJpsekzfG9Nt2jA0LoZ9sp1K8vKeYJ/dozyeU1noCWj/bLeQiKitvoQXxi47/4NOiBEOOtS2w52Z1wFdpYtZaRhx9OHhXnOJbsBRFU9KCu+aoGAVf1Q7AtAPl3MDs2PBzSz2HeYtXCbmlTJAL1cIuCW9X2UW87B0sFG6WPYsuFrd0ietiTNQdkjJbJyLZWX/MM8dNtYrj9/hDM7zV1dR7x0zBfBBjtNDLlFbsocNDZ6RNsdjHVfave4vECtEQaU9rvvnFpCEuf1LVpyDkq7HWafbEn1pvBVvbTHz5jQHJZKKSY0D3/C1OZxsesFfmNGuLgAQUeqZ+MlHoCUobVpgphTYr3OwxShZ/qsZvoaPv3OOHI3g5ECVDLUU16mvFkmicig1nXIbOVahcCXRJi6wpI061dqoAtRZe7VEslB7Hdrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Am 29.06.26 um 21:25 schrieb Lorenzo Stoakes:
> There's a large number of vm_get_page_prot(vma->vm_flags) invocations. Make
> life easier by introducing vma_get_page_prot() parameterised by the VMA.
>
> This also makes converting vm_get_page_prot() to vma_flags_t easier.
>
> Also update the userland VMA tests to reflect the change.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

For the DRM changes:

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

> ---
>   drivers/gpu/drm/drm_gem.c                   |  2 +-
>   drivers/gpu/drm/drm_gem_dma_helper.c        |  2 +-
>   drivers/gpu/drm/drm_gem_shmem_helper.c      |  2 +-
>   drivers/gpu/drm/etnaviv/etnaviv_gem.c       |  2 +-
>   drivers/gpu/drm/exynos/exynos_drm_gem.c     |  6 +++---
>   drivers/gpu/drm/i915/gem/i915_gem_mman.c    | 12 ++++++------
>   drivers/gpu/drm/msm/msm_gem.c               |  2 +-
>   drivers/gpu/drm/nouveau/nouveau_gem.c       |  2 +-
>   drivers/gpu/drm/omapdrm/omap_fbdev.c        |  2 +-
>   drivers/gpu/drm/omapdrm/omap_gem.c          |  6 +++---
>   drivers/gpu/drm/rockchip/rockchip_drm_gem.c |  2 +-
>   drivers/gpu/drm/tegra/gem.c                 |  2 +-
>   drivers/gpu/drm/virtio/virtgpu_vram.c       |  2 +-
>   drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c  |  2 +-
>   drivers/gpu/drm/xe/xe_device.c              |  2 +-
>   drivers/gpu/drm/xe/xe_mmio_gem.c            |  2 +-
>   drivers/gpu/drm/xen/xen_drm_front_gem.c     |  2 +-
>   drivers/video/fbdev/core/fb_io_fops.c       |  2 +-
>   include/linux/mm.h                          | 10 +++++++++-
>   mm/vma.c                                    |  2 +-
>   mm/vma_exec.c                               |  2 +-
>   sound/core/memalloc.c                       |  2 +-
>   tools/testing/vma/include/dup.h             |  4 ++++
>   23 files changed, 43 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index e3ed684ddcf2..32a05d889b9a 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -1252,7 +1252,7 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>   		}
>   
>   		vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> -		vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +		vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
>   		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>   	}
>   
> diff --git a/drivers/gpu/drm/drm_gem_dma_helper.c b/drivers/gpu/drm/drm_gem_dma_helper.c
> index 1c00a71ab3c9..7d9612075d31 100644
> --- a/drivers/gpu/drm/drm_gem_dma_helper.c
> +++ b/drivers/gpu/drm/drm_gem_dma_helper.c
> @@ -540,7 +540,7 @@ int drm_gem_dma_mmap(struct drm_gem_dma_object *dma_obj, struct vm_area_struct *
>   	vm_flags_mod(vma, VM_DONTDUMP | VM_DONTEXPAND, VM_PFNMAP);
>   
>   	if (dma_obj->map_noncoherent) {
> -		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +		vma->vm_page_prot = vma_get_page_prot(vma);
>   
>   		ret = dma_mmap_pages(drm_dev_dma_dev(dma_obj->base.dev),
>   				     vma, vma->vm_end - vma->vm_start,
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index c989459eb215..06d019d51d3e 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -764,7 +764,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
>   		return ret;
>   
>   	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vma->vm_page_prot = vma_get_page_prot(vma);
>   	if (shmem->map_wc)
>   		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
>   
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> index 2e4d6d117ee2..f9c8b7b2bfc7 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> @@ -133,7 +133,7 @@ static int etnaviv_gem_mmap_obj(struct etnaviv_gem_object *etnaviv_obj,
>   
>   	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
>   
> -	vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vm_page_prot = vma_get_page_prot(vma);
>   
>   	if (etnaviv_obj->flags & ETNA_BO_WC) {
>   		vma->vm_page_prot = pgprot_writecombine(vm_page_prot);
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
> index 9a6270f3dca6..0208c9259572 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
> @@ -377,13 +377,13 @@ static int exynos_drm_gem_mmap(struct drm_gem_object *obj, struct vm_area_struct
>   
>   	/* non-cachable as default. */
>   	if (exynos_gem->flags & EXYNOS_BO_CACHABLE)
> -		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +		vma->vm_page_prot = vma_get_page_prot(vma);
>   	else if (exynos_gem->flags & EXYNOS_BO_WC)
>   		vma->vm_page_prot =
> -			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +			pgprot_writecombine(vma_get_page_prot(vma));
>   	else
>   		vma->vm_page_prot =
> -			pgprot_noncached(vm_get_page_prot(vma->vm_flags));
> +			pgprot_noncached(vma_get_page_prot(vma));
>   
>   	ret = exynos_drm_gem_mmap_buffer(exynos_gem, vma);
>   	if (ret)
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> index 0644f85c6c8e..9ca90c1bb5b4 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> @@ -112,7 +112,7 @@ i915_gem_mmap_ioctl(struct drm_device *dev, void *data,
>   		vma = find_vma(mm, addr);
>   		if (vma && __vma_matches(vma, obj->base.filp, addr, args->size))
>   			vma->vm_page_prot =
> -				pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +				pgprot_writecombine(vma_get_page_prot(vma));
>   		else
>   			addr = -ENOMEM;
>   		mmap_write_unlock(mm);
> @@ -1024,7 +1024,7 @@ i915_gem_object_mmap(struct drm_i915_gem_object *obj,
>   	fput(anon);
>   
>   	if (obj->ops->mmap_ops) {
> -		vma->vm_page_prot = pgprot_decrypted(vm_get_page_prot(vma->vm_flags));
> +		vma->vm_page_prot = pgprot_decrypted(vma_get_page_prot(vma));
>   		vma->vm_ops = obj->ops->mmap_ops;
>   		vma->vm_private_data = obj->base.vma_node.driver_private;
>   		return 0;
> @@ -1035,7 +1035,7 @@ i915_gem_object_mmap(struct drm_i915_gem_object *obj,
>   	switch (mmo->mmap_type) {
>   	case I915_MMAP_TYPE_WC:
>   		vma->vm_page_prot =
> -			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +			pgprot_writecombine(vma_get_page_prot(vma));
>   		vma->vm_ops = &vm_ops_cpu;
>   		break;
>   
> @@ -1043,19 +1043,19 @@ i915_gem_object_mmap(struct drm_i915_gem_object *obj,
>   		GEM_WARN_ON(1);
>   		fallthrough;
>   	case I915_MMAP_TYPE_WB:
> -		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +		vma->vm_page_prot = vma_get_page_prot(vma);
>   		vma->vm_ops = &vm_ops_cpu;
>   		break;
>   
>   	case I915_MMAP_TYPE_UC:
>   		vma->vm_page_prot =
> -			pgprot_noncached(vm_get_page_prot(vma->vm_flags));
> +			pgprot_noncached(vma_get_page_prot(vma));
>   		vma->vm_ops = &vm_ops_cpu;
>   		break;
>   
>   	case I915_MMAP_TYPE_GTT:
>   		vma->vm_page_prot =
> -			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +			pgprot_writecombine(vma_get_page_prot(vma));
>   		vma->vm_ops = &vm_ops_gtt;
>   		break;
>   	}
> diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
> index cbf723a5d86f..6a78e242de7c 100644
> --- a/drivers/gpu/drm/msm/msm_gem.c
> +++ b/drivers/gpu/drm/msm/msm_gem.c
> @@ -1125,7 +1125,7 @@ static int msm_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct
>   	struct msm_gem_object *msm_obj = to_msm_bo(obj);
>   
>   	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> -	vma->vm_page_prot = msm_gem_pgprot(msm_obj, vm_get_page_prot(vma->vm_flags));
> +	vma->vm_page_prot = msm_gem_pgprot(msm_obj, vma_get_page_prot(vma));
>   
>   	return 0;
>   }
> diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
> index 20dba02d6175..9a6ee2e880c0 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_gem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
> @@ -55,7 +55,7 @@ static vm_fault_t nouveau_ttm_fault(struct vm_fault *vmf)
>   		goto error_unlock;
>   
>   	nouveau_bo_del_io_reserve_lru(bo);
> -	prot = vm_get_page_prot(vma->vm_flags);
> +	prot = vma_get_page_prot(vma);
>   	ret = ttm_bo_vm_fault_reserved(vmf, prot, TTM_BO_VM_NUM_PREFAULT);
>   	nouveau_bo_add_io_reserve_lru(bo);
>   	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
> diff --git a/drivers/gpu/drm/omapdrm/omap_fbdev.c b/drivers/gpu/drm/omapdrm/omap_fbdev.c
> index ca3fb186bf19..4881777642d2 100644
> --- a/drivers/gpu/drm/omapdrm/omap_fbdev.c
> +++ b/drivers/gpu/drm/omapdrm/omap_fbdev.c
> @@ -84,7 +84,7 @@ static int omap_fbdev_pan_display(struct fb_var_screeninfo *var, struct fb_info
>   
>   static int omap_fbdev_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
>   {
> -	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +	vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
>   
>   	return fb_deferred_io_mmap(info, vma);
>   }
> diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
> index 00404fb6c29a..fb0e6f556b31 100644
> --- a/drivers/gpu/drm/omapdrm/omap_gem.c
> +++ b/drivers/gpu/drm/omapdrm/omap_gem.c
> @@ -538,9 +538,9 @@ static int omap_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struc
>   	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP | VM_IO | VM_MIXEDMAP);
>   
>   	if (omap_obj->flags & OMAP_BO_WC) {
> -		vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +		vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
>   	} else if (omap_obj->flags & OMAP_BO_UNCACHED) {
> -		vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));
> +		vma->vm_page_prot = pgprot_noncached(vma_get_page_prot(vma));
>   	} else {
>   		/*
>   		 * We do have some private objects, at least for scanout buffers
> @@ -558,7 +558,7 @@ static int omap_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struc
>   		vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
>   		vma_set_file(vma, obj->filp);
>   
> -		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +		vma->vm_page_prot = vma_get_page_prot(vma);
>   	}
>   
>   	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> index b188539dca0b..9a1dc9f12072 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> @@ -255,7 +255,7 @@ static int rockchip_drm_gem_object_mmap(struct drm_gem_object *obj,
>   	 */
>   	vm_flags_mod(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
>   
> -	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +	vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
>   	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>   
>   	if (rk_obj->pages)
> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> index 1d8d27a5ea89..f76af733ea79 100644
> --- a/drivers/gpu/drm/tegra/gem.c
> +++ b/drivers/gpu/drm/tegra/gem.c
> @@ -602,7 +602,7 @@ int __tegra_gem_mmap(struct drm_gem_object *gem, struct vm_area_struct *vma)
>   
>   		vma->vm_pgoff = vm_pgoff;
>   	} else {
> -		pgprot_t prot = vm_get_page_prot(vma->vm_flags);
> +		pgprot_t prot = vma_get_page_prot(vma);
>   
>   		vm_flags_mod(vma, VM_MIXEDMAP, VM_PFNMAP);
>   
> diff --git a/drivers/gpu/drm/virtio/virtgpu_vram.c b/drivers/gpu/drm/virtio/virtgpu_vram.c
> index 4ae3cbc35dd3..544a6abddbc8 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_vram.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_vram.c
> @@ -55,7 +55,7 @@ static int virtio_gpu_vram_mmap(struct drm_gem_object *obj,
>   
>   	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
>   	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND);
> -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vma->vm_page_prot = vma_get_page_prot(vma);
>   	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>   	vma->vm_ops = &virtio_gpu_vram_vm_ops;
>   
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> index 45561bc1c9ef..a9fd4015a0ca 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> @@ -481,7 +481,7 @@ vm_fault_t vmw_bo_vm_fault(struct vm_fault *vmf)
>   	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE)
>   		prot = vm_get_page_prot(vma->vm_flags & ~VM_SHARED);
>   	else
> -		prot = vm_get_page_prot(vma->vm_flags);
> +		prot = vma_get_page_prot(vma);
>   
>   	ret = ttm_bo_vm_fault_reserved(vmf, prot, num_prefault);
>   	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
> diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
> index d224861b6f6f..758acaae85d3 100644
> --- a/drivers/gpu/drm/xe/xe_device.c
> +++ b/drivers/gpu/drm/xe/xe_device.c
> @@ -281,7 +281,7 @@ static vm_fault_t barrier_fault(struct vm_fault *vmf)
>   	pgprot_t prot;
>   	int idx;
>   
> -	prot = vm_get_page_prot(vma->vm_flags);
> +	prot = vma_get_page_prot(vma);
>   
>   	if (drm_dev_enter(dev, &idx)) {
>   		unsigned long pfn;
> diff --git a/drivers/gpu/drm/xe/xe_mmio_gem.c b/drivers/gpu/drm/xe/xe_mmio_gem.c
> index 8c803ef233cc..3741ae60f532 100644
> --- a/drivers/gpu/drm/xe/xe_mmio_gem.c
> +++ b/drivers/gpu/drm/xe/xe_mmio_gem.c
> @@ -149,7 +149,7 @@ static int xe_mmio_gem_mmap(struct drm_gem_object *base, struct vm_area_struct *
>   
>   	/* Set vm_pgoff (used as a fake buffer offset by DRM) to 0 */
>   	vma->vm_pgoff = 0;
> -	vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));
> +	vma->vm_page_prot = pgprot_noncached(vma_get_page_prot(vma));
>   	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |
>   		     VM_DONTCOPY | VM_NORESERVE);
>   
> diff --git a/drivers/gpu/drm/xen/xen_drm_front_gem.c b/drivers/gpu/drm/xen/xen_drm_front_gem.c
> index eec4c1da3f9e..dd158443f55f 100644
> --- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
> +++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
> @@ -80,7 +80,7 @@ static int xen_drm_front_gem_object_mmap(struct drm_gem_object *gem_obj,
>   	 * which is mapped as Normal Inner Write-Back Outer Write-Back
>   	 * Inner-Shareable.
>   	 */
> -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vma->vm_page_prot = vma_get_page_prot(vma);
>   
>   	/*
>   	 * vm_operations_struct.fault handler will be called if CPU access
> diff --git a/drivers/video/fbdev/core/fb_io_fops.c b/drivers/video/fbdev/core/fb_io_fops.c
> index 6ab60fcd0050..6d0a8c8e141a 100644
> --- a/drivers/video/fbdev/core/fb_io_fops.c
> +++ b/drivers/video/fbdev/core/fb_io_fops.c
> @@ -161,7 +161,7 @@ int fb_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
>   		len = info->fix.mmio_len;
>   	}
>   
> -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vma->vm_page_prot = vma_get_page_prot(vma);
>   	vma->vm_page_prot = pgprot_framebuffer(vma->vm_page_prot, vma->vm_start,
>   					       vma->vm_end, start);
>   
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c8336f68d7bb..b55790c75038 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4575,6 +4575,10 @@ static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
>   	return vm_get_page_prot(vm_flags);
>   }
>   
> +static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
> +{
> +	return vma_flags_to_page_prot(vma->flags);
> +}
>   void vma_set_page_prot(struct vm_area_struct *vma);
>   #else
>   static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
> @@ -4585,9 +4589,13 @@ static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
>   {
>   	return __pgprot(0);
>   }
> +static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
> +{
> +	return __pgprot(0);
> +}
>   static inline void vma_set_page_prot(struct vm_area_struct *vma)
>   {
> -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vma->vm_page_prot = vma_get_page_prot(vma);
>   }
>   #endif
>   
> diff --git a/mm/vma.c b/mm/vma.c
> index fcdd2ac3ac68..b81c05e67a61 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -3429,7 +3429,7 @@ struct vm_area_struct *__install_special_mapping(
>   	if (pgtable_supports_soft_dirty())
>   		vm_flags |= VM_SOFTDIRTY;
>   	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
> -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vma->vm_page_prot = vma_get_page_prot(vma);
>   
>   	vma->vm_ops = ops;
>   	vma->vm_private_data = priv;
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index c0f7ba2cfb27..b01c4964f2c9 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -146,7 +146,7 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
>   	if (pgtable_supports_soft_dirty())
>   		flags |= VM_SOFTDIRTY;
>   	vm_flags_init(vma, flags);
> -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	vma->vm_page_prot = vma_get_page_prot(vma);
>   
>   	err = insert_vm_struct(mm, vma);
>   	if (err)
> diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
> index 9320671dfcc8..5bc7e586b430 100644
> --- a/sound/core/memalloc.c
> +++ b/sound/core/memalloc.c
> @@ -851,7 +851,7 @@ static void snd_dma_noncoherent_free(struct snd_dma_buffer *dmab)
>   static int snd_dma_noncoherent_mmap(struct snd_dma_buffer *dmab,
>   				    struct vm_area_struct *area)
>   {
> -	area->vm_page_prot = vm_get_page_prot(area->vm_flags);
> +	area->vm_page_prot = vma_get_page_prot(area);
>   	return dma_mmap_pages(dmab->dev.dev, area,
>   			      area->vm_end - area->vm_start,
>   			      virt_to_page(dmab->area));
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index 1ffac38a5377..d86bef8cb37f 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1577,3 +1577,7 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
>   	pgoff += vma_start_pgoff(vma);
>   	return pgoff;
>   }
> +static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
> +{
> +	return vma_flags_to_page_prot(vma->flags);
> +}

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



