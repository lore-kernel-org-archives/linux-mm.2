Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54362CCA476
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA7C8E000B; Tue, 30 Sep 2025 12:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1848E0002; Tue, 30 Sep 2025 12:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF278E000B; Tue, 30 Sep 2025 12:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DABA8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:09:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36F6F87CBD
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:09:44 +0000 (UTC)
X-FDA: 83946402288.10.CFF9F84
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4EB49160012
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:09:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kipK6wKf;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759248582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7Q792Hya2crtNGLvTmj+/a9REAcmnG/Y5xPxAa99WY=;
	b=fLnCzk3h1R5226BlLdh+/Q92DLfpBnRB1WjORnkPL3EN2khRZjw5fiqC+p+CCQ8NBkZUf8
	Fvj9e2ne4iV+nHMyTVIzMYrB7SoeqX0rA8JXHEvPOsXdPMwfWlC2+xoY8qQkAEb/DK7GXj
	DReUVvaYKVZRwOrznqapQcg0wztXCmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759248582; a=rsa-sha256;
	cv=none;
	b=xyt2Ll5EW6F9XV7Sx8y4M572yMPpw3q5b0zFDXbG9KLWZkM/DRy3eOm35rM10E9u54kkZ2
	m1lVaTZN8cgfEEfa/X6MGJraC/dXCPxhGc9oF3aDdidDkp67Lb189AzjjOzMrEooSJvnyK
	pH0JiuY4mt993+o1bxdSTGyagnvoK3o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kipK6wKf;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759248579;
	bh=zNOqW8q3K8VzrkGpGhn/Rwg2ryt2C/LYQAHlbYXM5zQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kipK6wKfCNDwXwPqAORdhW6HgjiNlNdE0KuHuBqz2AHHfRWmbcMjSrLfFIdXkLnpz
	 p1M8hRm8VMktfTq1sULOVF+By7uOvMef3OfFPZW2hlzz9zlCbIZuc7sVIVHE9kTpDv
	 Qzqu6Gi2EkT6BOpsLFvjVo8Hz++DRwsTFSAf+jF2WKYTxEx1pDJurafyWxK1JdrQnS
	 tPyt36VADlrD9S+otqgz4MoUQrrys9qZIfE9zLIvuFBzDQ6R7DFGoXNhgUS0YjSY+V
	 xuFkAzEubr5lEy5gp9gpYnc0Y5/rMd3WqyQMhvoOhvrdT5DBqq3Uh1o5d3t1Q/3q/G
	 F1rT/b30CeMFg==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6C64D17E010B;
	Tue, 30 Sep 2025 18:09:38 +0200 (CEST)
Message-ID: <cd9084e1-16d9-4fd6-9c64-1876d53d5225@collabora.com>
Date: Tue, 30 Sep 2025 18:09:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] drm/gem: Introduce drm_gem_get_unmapped_area() fop
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?Q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, kernel@collabora.com
References: <20250929200316.18417-1-loic.molinari@collabora.com>
 <20250929200316.18417-3-loic.molinari@collabora.com>
 <20250930123003.75370854@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20250930123003.75370854@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wbtozxkp5eqmui9pj5wzrawgxrcooqgw
X-Rspamd-Queue-Id: 4EB49160012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759248582-946155
X-HE-Meta: U2FsdGVkX1+rEhZb212nCkv8WRNrLTTiEp3Ni0fcQSg10GcNmjyIvEzKIb9Z7V+UwkD6Np9FtmJxm/RjRPPPurdoT7K7s0dXYjipk/7Y93WwxK6M9MugfWMTMXJN1d82S3WpUxSK1toxR3mvXZdiyx+ARkUMyq5H3rPOPoo+w6+c44NUBU+1Etqy7OQYsK9XLOpm4cD2bSgLGAjMJJfzRLTiR62yW2zKpUtrcJuni7uosNRQkuYIuf2nTiHVDKHLDp6nuugqlCQbIrXRIeZAMz7ywBQ7wO5wRt1dKtBdVRu7z1G9eAD1U50Y/dgQ5mYkP8ldUs6I8/CM4uhaVfzBFHku15AyiCheUt3sd4T15awKaALaXeGnVa4RedntA7HV8KmmJ+LJ+HspxXde7inaXcz4B2AqVtkGroMYk2BvDhJMptt/6op22CuDcqkhlfRCe/9OLmNG6mIVZpKGfw1/bZtLs7pl61iQGNOnfB6Y56vQcwUJbgfJ61c2HrOgUaW7NB7JYztk8RqkMloMEwUXdgAeKnDD81DXLTctcnbfs47xmuBGjCrrYH+8ZVuPnPFMuQDkTLbiOXphKsCwbYSTaa7tNslYmNgmaP4SZbVldCSmwOS+4jl7fp2pCUkM3kISzRvSxFxTBoWLPI1atSd7WAqkfJ7fPBfiaCudbLWjMcOvQ2TwujctJbGx/6gbV2oUThoxkSB/6i450wK8xuSG1ylYV+5+xDy12JiRljBTMRmGAkcgwpvo8bP32EEbudMt7Xyp1gM097nJQxhKLZZx4LV2hR39A21XO7m6+s6rKBQQqvcVr3IEzk8xUpZnfAm5AcnOJphqUsolH0yHmxN3VtRd0NbNdHe+hZUamkOCkFhvuUGu8B5B+goLnf/9ZxA8vKXQ68H5ZwOqgZh8iscIGOQNAAqV+GBk+iN/KMvEqioyaGAwNvv+SjNCH35PID9in/5196wjriVP8OoPmUb
 Afs7nPZF
 GsYF/fJ+dzenJCyZJ76GkpDbalODKN8Qew4F6SzbLUN7SzUfZz75FoNyfUlolL2FsJHw7aEJkhesqhoifoAKPancu8fC4EJruPpQV/itqTTNnwyNc6328v/C4hu86pDepAs2iulfoTLd47eY8l2NrBY9/TJbBKYZ5UvZW155nTtmQk1cbSY9W7eQJya7+kK/U/B0OcY4++9TMt1M7AQTwPbCn7XwSqc/s2NQf4NrgQo1C6eKLJtSlxjKFa3hHa1RXxqorPi1MMRhFjD/Rp3RxFVflo00rTITWtc5jOJDiQi9wsCutjnMWf4EYdCqMHVt8XumJdIo8x8x9ZfWWFTCpkKy81A1V8qCGAMVWZtWokB5YhmkzYirjsHo7aJpxms1JU94bkgjVB5fyg7Ar2dLbndikCI4y6afU70nMsFWdiMMWeQ8uZzJY2OwaCP3a57ETAHLuSx8+mu2qziT2WstZIrs/PFdjniTDBbvmjGMqI58yLG7MAvfaWrZN9oHJRrOZ3PxV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/09/2025 12:30, Boris Brezillon wrote:
> On Mon, 29 Sep 2025 22:03:10 +0200
>
> Loïc Molinari <loic.molinari@collabora.com> wrote:
>> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
>> +					unsigned long len, unsigned long pgoff,
>> +					unsigned long flags)
>> +{
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +	struct drm_gem_object *obj;
>> +	unsigned long ret;
>> +
>> +	obj = drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIFT);
>> +	if (IS_ERR(obj))
>> +		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
>> +					    flags);
>> +
>> +	ret = shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
>> +
>> +	drm_gem_object_put(obj);
>> +
>> +	return ret;
>> +#else
>> +	return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0, flags);
> 
> Looks like the above code covers the non-THP case too, do we really need
> to specialize for !CONFIG_TRANSPARENT_HUGEPAGE here?

It does cover the !CONFIG_TRANSPARENT_HUGEPAGE case 
(shmem_get_unmapped_area() would just call and return the 
mm_get_unmapped_area() address) but the idea here is to avoid the GEM 
object lookup cost by calling mm_get_unmapped_area() directly.

>> +#endif
>> +}
>> +EXPORT_SYMBOL(drm_gem_get_unmapped_area);

Loïc

