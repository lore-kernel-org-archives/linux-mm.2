Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEF8CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998B98E0040; Fri, 14 Nov 2025 12:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9706E8E001A; Fri, 14 Nov 2025 12:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD638E0040; Fri, 14 Nov 2025 12:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B88C8E001A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:15:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DBA516042C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:15:50 +0000 (UTC)
X-FDA: 84109864860.22.46F4FE1
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E8E040009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:15:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=nU+iuGAT;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymVMtwjgmno6UXXJhgFJebgOvBqGXF5Cx8eUiiKU4c4=;
	b=PrajDr8TEu7KQo5/nHg2AeaNEo8MrkYjrnMi9Xd69N+HdST8d5m7Au6K9ir+3CyDnh+eHe
	DNk8i9urM7GHd3fc00YxcEWOTVKVyzqyFVjeo4gRbSV5SxRV//f6JaMStLnMps9ZaPQpKt
	WfIF4aj19KeefZRkjsOBaqBNiZGhmQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763140548; a=rsa-sha256;
	cv=none;
	b=G06OeeGCrQ7wCGb1LyQCGQWLLOUQcLWiyDBUVShoVO06vxHM61jnpt+/kyeAVhYOn66mb+
	15yyzzO89UbiYc84nZvtk3p6+/rTO9iMncfXWw2xQy4U2RK/nTMPsxsp/9oW7Twesyrm2l
	3bsx4M82jR6GLj5C4iakG5eP01ZY7/o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=nU+iuGAT;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763140546;
	bh=ID+wxlGDegTSQQqO+tfv+j3F//xuzjuJ6+40mXVWHgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nU+iuGATE0QjIxjGhzFYT6AUXWPCOhQdAJu/0W8EeKONVvx28VL4l3LWvT8ti+wnq
	 +xbEFjKI3wOXVR0b2FApQZpSaFWkNXCU7xXgw3rWQjBQzC1kj8yel2Tcrq4+ZhXBaK
	 uXB/FJPJC8jm5qEJo3pfFqZeRF1n4JxVzKCOBMj+QLff+2m4l/SH5OOUtWHMCXbnof
	 CLpAdSxKiln4mzIs+3D25R2MEZzE1f5fI//kmoSMdvmcWKx91cfbmxr/Rd8tsMY58x
	 TjHf1gQEWa/3TIK3bfNMqykgd6dcCBsivQWynhnjFE+pQmiAY32ASryZdqairHzF54
	 OSmSAnXo9ArXg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5EB6C17E12D5;
	Fri, 14 Nov 2025 18:15:45 +0100 (CET)
Date: Fri, 14 Nov 2025 18:15:40 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?B?TWHDrXJh?= Canal
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?B?TWlrb8WCYWo=?= Wasiak
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>, Nitin
 Gote <nitin.r.gote@intel.com>, Andi Shyti <andi.shyti@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Christopher Healy <healych@amazon.com>,
 Matthew Wilcox <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v9 07/11] drm/gem: Get rid of *_with_mnt helpers
Message-ID: <20251114181540.102789b1@fedora>
In-Reply-To: <20251114170303.2800-8-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
	<20251114170303.2800-8-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E8E040009
X-Stat-Signature: jjq9qq114hch6rddx3wi8bgepm17oucd
X-HE-Tag: 1763140548-9809
X-HE-Meta: U2FsdGVkX1/9EYUJrXt8WLP+worflMtEcqFAmMXA8oiZHOW0i5lnj2nKvCaRdnsAXFOagshYIVlcge/wuJq8oIPqd2uprZR4mi6jy/9Lv1py52cDZRfyBZwlJgVdznhDmgrjEGw9c7DtyylDEfUYc3Cmmhfyz4hdB5Q+5xB6ZPJEI8iwgbbFhASxtASL7jq6IBzKXNrOMHeEiSifh8CqdqV/bgSsgPf9AgCdNPzBD/yfrSROfp0FUpKb3lVPAQI8DfG63SjDiP3schCvx7d8m7/2V6k90lrQuNi07kPV8WaEpDV8YW9Og5PVg+r8nJPyedEd9FVf9XsnkWHm2ps88+RRpTDCAtKPvYzrRkdhTjOUS95RVxe6o5terAZyy54Ywnd+/MtjcUR98/Uxrf02RQnEcc6/XMXgEiz3HyuvT7MuMWxn9Q2MPr5EjOIsB8vTGhka01JjLYpGgVK38hC83GOIIAmOMVcVEP+BJVWtrtO6JTXsJ3XZrEiJnznI4Rc/upVJv82Glz432DB9HkuHDLFq+Xbi9n/puAf19qIFax031CPsx4hwYW+bP+VtV+dpWKon4Hk01Za5/Ljyhn5SBbvrDD/L513EKJ3Aqi4ysBPRVWkUihIhwLraDpwQj0BqN4bCIHRtEAR62Xc4vLgleqk55l+XHE+eHHOOWWST0JlfbHjWuVWwSb5JpaXtyjTtblmn8zOxT8eRFiRpOHOn6PD97koZ84ZInHcdcFQyKPZ2QjelWc2b3xWNjtVfbT9r/DahiUoYZxJ+/FLkl36LjlLIWtswjEb/CFYd6lWmn1EDfU40Ut8787Twti7UTz2DCvbZdaEIcNm42xMr9zugq4k/7OZ3+ABFzBXciNTYsc8wwjxCsuDfdrJQOnaZQcb1+pQ75vrQY6lw4bd/Ahw/UsW1yRw15Qh7Xats67Yn6TFA+bsPhc15z/hR3vJeu5mT52VShRB18zDdhnWLGtx
 WJ2Kvx5H
 PhjdBtrStk3hVD0Poeb+aIwfi2dcgG2rts8SloP2mmcjzQ/BV93mSwyJH77r1/YPm0wVvhNz8KAsY4eyhLmy5HKRx52LnpwOhiyFBgiSJRMnUGdBVI7JN/gJPngAn83O/92NzX463ciqiTJWyXIjfRJYHKR9JJrXQ2Z0LaMAdpBmqCA06Z11rxPGStVc8jcj/KZfba3i8uzyshNvucWS3k7YNCnUhCZWohviaBzFoEPsM1iJyex2XE+JSoxtS+pF8auiOO7XcsI+0KF7rjuEWjVk+ENEOb20pCn4ykw7GkaCqCMVEqj6AMdUWpnA2lCDyGrTYbPCbNpktNbRbNc2Jafs5mRCp9N5HR7JGiZ6TLR/7mJjGenkPlAxjiBlaKbJDByVZaFmFiBaAvXgILycHS0LzH+ofRFLKx0TRZCLQPM56gEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 18:02:58 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
> index 211578abf9b6..c4316b768b3d 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -153,12 +153,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev,=
 struct drm_file *file_priv,
>  	struct v3d_bo *bo;
>  	int ret;
> =20
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	shmem_obj =3D drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  dev->huge_mnt);
> -#else
>  	shmem_obj =3D drm_gem_shmem_create(dev, unaligned_size);
> -#endif

Hm, okay, the thing I complained about in patch 6 is dropped here. If
there's nothing else to address, don't bother sending a new version
just for that.

>  	if (IS_ERR(shmem_obj))
>  		return ERR_CAST(shmem_obj);
>  	bo =3D to_v3d_bo(&shmem_obj->base);

