Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8398C43638
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2406B00AE; Tue, 30 Jun 2026 06:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610EF6B00A9; Tue, 30 Jun 2026 06:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4643E6B00B0; Tue, 30 Jun 2026 06:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17FDD6B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:24:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ECE2C2209
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:24:09 +0000 (UTC)
X-FDA: 84936193818.27.3E8D806
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id 67FCF1C000B;
	Tue, 30 Jun 2026 10:24:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="F6AsC/aT";
	spf=pass (imf20.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782815047;
	b=EEGlAQd760oM4Sz47z8Q76zuXBsC1TPk8n5zaP35ZaRood21W+tsTpQju1ZUKrwYNV617P
	ssDhyIENP5qDO1YfH96DwdrYttu0tUba6LqwNljEyGB+X+TRaLh7tCrWQSrZxhp7MdTiVu
	KD6JKl1//tHos9a6xU87nWrupiriIdQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782815047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYZN8QcmTZB0XuTqOpasOlloDru9xfoOYzlyz+jRrVI=;
	b=H/McqgCzQ7J4sTChOOuaPqwBzswHdS+ht+8v5TVvDxrcNtbBs2OYkPRMRoR0UFAJ9Zjrco
	DPvaNBfedCmMdmtCFXUbgjBtzj5g6X0wWnJojKM4KW2ZzDPOVQdOXpYV05cdmFRINTSWZi
	ZiaOJlWgDexut5i91Tz66GujnyvTRaA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="F6AsC/aT";
	spf=pass (imf20.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782815047; x=1814351047;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=ktunQaDDS5EVOVO47fVPmptPD5p+avnAGjEgEXLkbp0=;
  b=F6AsC/aT90NURy+nIBMPDQ9d0+/chwhGF8cLyA69gB2+vHBgThgQS5du
   MwRBomZ51VBPfWj1CxiGTHW18hBmuypZ3BLzMmM26hr2eYoXtWdzH2vp9
   9zp93Fl+V0HKnr4X4xhBX3Do8oxDL+p/jvap4t7FwWAiZVyvG9mwDrY1K
   IonbJKHpRX7ltJuM2U9GR2bRsjSQ88+pzQwCllfbu0/VSTwOgvNFBI2H7
   UTmuL54fZswHci0/P3xqEPXp5XuVwMrqDvtiagKyRUmm08juW+ThebUV6
   sLm7OgAbVyzwtQjQc9BfBG6oBfARZzzXDlQqPNIf4Oq4OnR3r3pSOnBRg
   A==;
X-CSE-ConnectionGUID: xNVt2M09Tj6yRoQ0OC2Uig==
X-CSE-MsgGUID: KGG4tawdR0O/MbIYQWPJWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="83581407"
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="83581407"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:24:04 -0700
X-CSE-ConnectionGUID: jgq2xSQuTZCC6QLcUYS3Dw==
X-CSE-MsgGUID: Tgh3e1tLRQ2N4h0xSzOsDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="245877673"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.148])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:23:47 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Lucas Stach
 <l.stach@pengutronix.de>, Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim
 <sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, Peter Griffin
 <peter.griffin@linaro.org>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Rob Clark
 <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, Lyude
 Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, Tomi
 Valkeinen <tomi.valkeinen@ideasonboard.com>, Sandy Huang
 <hjc@rock-chips.com>, Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
 Andy Yan
 <andy.yan@rock-chips.com>, Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter
 <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, Dmitry Osipenko
 <dmitry.osipenko@collabora.com>, Zack Rusin <zack.rusin@broadcom.com>,
 Matthew Brost <matthew.brost@intel.com>, Thomas Hellstrom
 <thomas.hellstrom@linux.intel.com>, Oleksandr Andrushchenko
 <oleksandr_andrushchenko@epam.com>, Helge Deller <deller@gmx.de>, Benjamin
 LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Kees Cook
 <kees@kernel.org>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org,
 virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
 xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org,
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-sound@vger.kernel.org
Subject: Re: [PATCH 08/13] mm: introduce vma_get_page_prot() and use it
In-Reply-To: <3bb8bdc4788230c33102166d56cbc5abfad9d4cb.1782760670.git.ljs@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <cover.1782760670.git.ljs@kernel.org>
 <3bb8bdc4788230c33102166d56cbc5abfad9d4cb.1782760670.git.ljs@kernel.org>
Date: Tue, 30 Jun 2026 13:23:44 +0300
Message-ID: <d6d75626287ddd46d7da136cf013f7b21b1afc06@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67FCF1C000B
X-Rspam-User: 
X-Stat-Signature: yhi7s7pue3iqkshrh651tq3k3wxopthw
X-HE-Tag: 1782815046-807022
X-HE-Meta: U2FsdGVkX1+oudVAdzF+VnYlZ6SD4hZ8diQogwfnsIDLbzR4kDUcc5QHc7q2W8wKOLCuhGzLEHUmZBNIkDgf16GKvO36jd5yntRA6MDEKSnEw8kzlIzgUWbGsLoJCKDWDXz6IVreEh/w83NKXJpVM+oVKduFg0r4mGZGdyUfxpEHfx12pz8avWh4bblRujfjfG7nIUFif+58RTMUh6AaKEl6w4uGf0LJ40GHTWDxzH0gH79dYYEHOXLKbT0OhW0QlxARmarMmkJnvnp6ETvxe51T12bqf6vibFCCB7/jmnrbWHuIT7rcNUULUbM6nTfRnirCaBv3AD8wFwbzTumKmM10BRYFb8R2NcJtwzVfi3dOEOYLzqCK2NMQI5JMfjeWHbkQ46PcVj6OYZTLTi4TsPyaHWw2P6c1ob/60MX9F/m/a/+k3fiLyWHOQGRN7nUa/cKePUjGP8PtkMrA2EimUXwZ5d6lILoTt5gGExjU9ArcjwQhDN/yYAQBMr45BkGz7504isRhoMkMzviUqBdGQmOcK8sHWg8lzISrmugvdxVGWOgywB33emYZyK/35yLMJSisAWqgi8C7DAFDECrS7vTmThqY6TR0gkgA97O4b85qZiF9CuDcnUDHc9KWcg+oCtIOlkZY5mc0cEC6yltCKhQ+vH6YDIPx+87+OTawzWIDg/JiejV90o3i7ceQYUX9+0IKGouN90COY4KfNEZTiV8rn8UhzAyn57IkX6shoS4EtEr0siO3dzh9tdZ7g2yAvfYp0LukzFbLsScNhNm6YeTi3/kwdunWaFILzBZDRciO80HNFTOwXUDoGklKaMV9Vsc3ZDlA0J+i/IVJs4fw7i4+HikNL7EV8n/wzwxvEJG/JYaGxyQtnCwjEJ721swtakuw41YQLOckokGzUjDCy5Mtwt5P8525L36mtgZW0ruQUMVA6Shs7kpzITjfQU4YuqY8uUkaS7p2U8I4TQB
 O5cF5A+N
 Pb4etOjurK9ZcVZwhi0kos97pEGiy95xuKlnDN0T2RUGPCiWPbX+jf8KjpUOAJaD1BY9RRLqelE3Q2xd0eEGmNMTYI4F346B1XsHWXAre5LmS0bqpITqkbWBav3Oz2iBLAbRboJjKLDRchUAP+aLwTFAzpOvwOQGCY5uXzZLW3OLf2l6IQNqmltEMSsYVGmb0EQwxlEycODXrHqzoCw7RXLHEx4gVPUspH02aeCbOVzGMg782BG0tlFr862uXZzo/cZW8F30Gyxxjq6vYb3n4R4dB/XyM2ISUknJt/NthUMtKIWK0sbduxIzaNYHDHv+F2UDAofUEtmxyEvxgFnx0lIeGfZm8bfbbqoGPyEF1mD/gM0zj8MQnQ12C2dFhCjjERnJ/pCcIgEwRXFfFksMsxxZhKyr3ysl9LzYnhMQSfwNKHmVu+vFs+7HYkSJ1WuJhJAA08LanrJan1rwfYEHopQj4dCN3J2DoWzCRNRhq2aiUosrapGVQ8pO8I2PuXHSRDbbt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026, Lorenzo Stoakes <ljs@kernel.org> wrote:
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c    | 12 ++++++------

For i915,

Acked-by: Jani Nikula <jani.nikula@intel.com>



-- 
Jani Nikula, Intel

