Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1042BCCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 07:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE488E0008; Mon,  6 Oct 2025 03:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E388E0002; Mon,  6 Oct 2025 03:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D5D8E0008; Mon,  6 Oct 2025 03:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 226888E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 03:07:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B104E59304
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:07:43 +0000 (UTC)
X-FDA: 83966809206.08.4ED1C10
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id E28BAA0009
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:07:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JZ2Yladu;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759734462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmswEq7GLdNsE+6r+V6AIQP7tSdS/Lvzg0X92xx4hLU=;
	b=INundGDlH6H1c9dKTK/2tg43Hbv7epcdIagTpt26oFNyn/klbTyEPRgs8iHVLxLSofPLTn
	NN5pwdjUfFThXw0tkB14m+oyAUHnkEE9THXqYF4ot8nsKLHVORTaL981Ifcp4eiNAf3/fw
	nEG9fTKK684TfviC5MstisqvhvBA/m4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759734462; a=rsa-sha256;
	cv=none;
	b=hgvCGh/+/IGevxVY5+AWGYAZKpSloJQEljkb2INU4x49+T6+xE5yFpfV+BTQV0eBBZ4Kgm
	pK0Xqb65JmWHCgAqCsA8yXs/5d7/XUAFDxu6rgioxObRCs2c85wZ/nqULAh0H1fZxaAS+u
	mpxvW7yqpzX9Xr87rFF/nxtkr/gfc80=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JZ2Yladu;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759734459;
	bh=EQOgiGE+g35klH/QbOf0cf+PLrLzO1ZuuCOjx+b7EqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JZ2YladuvRsPBBU3RT4tqnwSWb600cQJGTiTxuqtg1sWx8PunjzZef1lb/R2yun1S
	 IEv6jpwI9WQ0Iht2SViUWTe7YNC7kPkidSDWxlceUKWZjn10fhQeB/+H6vSfg9dEfV
	 m8JqvuzZWCu/ZCBijPneuavvFHRIE15pHELuvluTUC96H8kZZI8K/IyB4CMl8wrAZk
	 xW8nU4m9CzGyjyXQZOBQWdbzNraNbynmBIM5A0Ua9q5T+mlBQGBERC7Zm/etJje+c4
	 vFlnyOoXVHitJmNM9LJNPyu2zTEIkyzLUuLt2MAcdxxye6DfQFXAe4XOy5kJDpYJ3D
	 TlZ/yFhzkNgBg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2138217E0AC3;
	Mon,  6 Oct 2025 09:07:38 +0200 (CEST)
Date: Mon, 6 Oct 2025 09:07:30 +0200
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
 Christopher Healy <healych@amazon.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH v3 05/10] drm/v3d: Use huge tmpfs mount point helper
Message-ID: <20251006090730.364a1713@fedora>
In-Reply-To: <20251004093054.21388-6-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
	<20251004093054.21388-6-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ndbp5b1ruqxt13yny64g37joqa9a7d9o
X-Rspam-User: 
X-Rspamd-Queue-Id: E28BAA0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1759734461-413668
X-HE-Meta: U2FsdGVkX19AXL9B1SfHBb2an1MlJUdMs9DtpBU4LOpX8IsXhVBDPmXgj2kVY1UBhDZ0ExNDYu65B0Wquzt9eJ9Cs6i1oOEEQE4ZhXL2LERo3cpjRDhgacxge+FLLZeRn56LezV669XLprYD7NLNxEjHiJcNXo5TbPoLqHHRpFqfCJScTPR9wBsR0L7J+kJ2OUvPF2iqIPRABwj8n1FlbQGclHQh20tf4oDJknWRzAbYD5Oi8mkfvPt0Xbj7EMscEmcUJ+klVUcitSIcefDg2Mmu0/XCSt7UpCF2sY8qmQlK+l3E8Zv0XVK7YsIJuNuSxtzHWQnPgxJR5UgGdZc3oMcFuWZa8/qzoofnRCZM94OxLgi0ZLQeff4NYNxWBoSpHZb0eqFJV6LhyfvVRriiPCv+xqk6GdecOkF90mBAwe2pSmBMpiTafYN6h5ohL54901OmXqbtdxqVmmnkWgiXLWjZA/e9urI1f/XFFjRJ6izmo75M+8k25KNpT3X7dnIDBwV0tuEMfDVEWP/fob4fE/+0Ov/MCSF5HJwMvCIweQ91UuI2Nb8VkDhllpchUF6Kdpt3eYSawcizaFyB79syVwmp/10yqSfDP/VDoNYlVghd5EOxjqqmdVfOVnvfHiVi4yMvNh+hrC4Dy/i3NBWIZW2YwznPs7GUEin5CmVmcvRgORyBvAguuz/CEN9aA5QifO9biYpGxuAJDsgSwvgypopVwpX8+B7gZFDk8hk8k5BgQcIyh31FzTLLKPf9oeqTY2IlrDa/ishZGXMK/nOlaTcEAyZDJErqCZEcAcXSEkgOu2KBq+0EEo1Mm9YSi/HY7PN1MxGbXA2HI+Mu8dW2Az0dgk6uL0hXRE3qoEpgkIAvFfDeQHX/l1HSe6K6RMLgMFhW1p0U/+GL5lEkO1t1BdP7CJQ4Rixuj9GuGG/j+rF3fHwyiALm2YhErW3Ks0CahTTvs5UufJ8F53Fkj5G
 CuDuzdjM
 i9+r4PcwVA7PpHFOCpYa9e0fI4o49OnIkBRQ9LORGIonU25Br4VgYeQhaaXlmiQLHMGsPWB5TcFURaA3L9c0573sproyY+DryelYD9XFo6De+XRiN9YMZ4r3w1J76VDPUx4jqC0GbFLM42T7vkJsaBjGNa12d1x+QGwptkNdRNSVzogNs4Cb17sINaTcY7rtrOVIQS/+JiBE6E/ZMCNi5yhNHkvjtdhhHM7KSYF8PF9MQN+i/DPADnaWwPgw1eo7HGuwwdW1ixzSEg5/e7jUlrjWwYI+7YxLWhwl3BPYVeLznciKKHJnI00HYnN3UBpSPN8i4c1c9E99desEVoB40xSmD0Msny0G/1umHJuIwRLJTnlOEfEPd9wy+V21lJBfhMaXEMWwwLwAJFqfs8il8BXBa9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Oct 2025 11:30:48 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> +static void
> +v3d_huge_mnt_init(struct v3d_dev *v3d)
> +{
> +	int err;
> +
> +	/*
> +	 * By creating our own shmemfs mountpoint, we can pass in
> +	 * mount flags that better match our usecase. However, we
> +	 * only do so on platforms which benefit from it.
> +	 */
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		goto err;
> +
> +	/* The user doesn't want to enable Super Pages */
> +	if (!super_pages)
> +		goto err;
> +
> +	err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> +	if (err && err !=3D -EEXIST)
> +		goto err;
> +
> +	drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> +
> +	return;
> +
> +err:
> +	drm_notice(&v3d->drm,
> +		   "Transparent Hugepage support is recommended for optimal performanc=
e on this platform!\n");

With the changes suggested on patch 3, this can be shrunk a little bit:

	int err =3D 0;

	if (super_pages)
		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");

	if (v3d->drm.huge_mnt)
		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
	else if (!err)
		drm_notice(&v3d->drm,
			   "Transparent Hugepage support is recommended for optimal performance =
on this platform!\n");
	else
		drm_warn(&v3d->drm, "Couldn't create THP mount point (err=3D%d)\n", err);

