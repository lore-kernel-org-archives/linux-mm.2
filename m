Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3995FD2F7D1
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 11:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF9E6B0151; Fri,  5 Dec 2025 06:33:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570796B0152; Fri,  5 Dec 2025 06:33:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD0D6B0153; Fri,  5 Dec 2025 06:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 373F46B0151
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 06:33:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAB14891C4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:33:00 +0000 (UTC)
X-FDA: 84185205720.11.1100262
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id CD4BCC000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:32:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=obWVFB1o;
	spf=pass (imf22.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764934379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSCLZDzuWO0wYnhswyk5hnrbmKxce6VWhX/0hwQwHMI=;
	b=mMci7CnxzG0tDTiGR/fFRLO/1a0R/j28qJjHJsXNFrPcy2aX02H5YBQBM0LhWGX+mJBuHX
	DoX8BvyyAFEtnJc7DVq4fgNMQ2VNniYsxvRgWw7SQjese3vGw/g0vPlKk4zTDqsqCPkO45
	IfvY77HA5GJAMajK4ZJ6RtKZeH456fk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=obWVFB1o;
	spf=pass (imf22.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764934379; a=rsa-sha256;
	cv=none;
	b=mt+CLRn/sUcAxseIqiQMF985XdSEMZF4wDbu6mENzopcN8enT0XSXEU9mlA1FqYIqx7Qhx
	8Q9YPIKFBGV05+X2vlnnDNcKIclfWh/k2qD1g1MEEzC7HwCTZVuyubSfvflT3DpctQfLBi
	/dRkiAYY+2Ngqgbxm7E57mbgVeLsd5M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764934375;
	bh=DSCLZDzuWO0wYnhswyk5hnrbmKxce6VWhX/0hwQwHMI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=obWVFB1oMWyJkSF6loS4HncN7i9Ql0hdOuGalrXv06mU+dIcDKHhiJ4R+4UXx+I23
	 g9HcYm7KXuJKP483J63eDlx1GQvlliyPPybavYxfYv3W+P3cJ8Jd3zZvZ729e6z2HS
	 UYXvC1o22O+5yD4d9ZreI5EFCcFftFz2el0vLgP5RWVgEEJ9LTd8dMYN03ZtpI3/ct
	 vmV/93Hr0i0azBFvqKe670evUKESnmsQt7v5vR25yvyG90YVIiX+334xD4XLZ6rU1s
	 h6488w4j18hjTJme+WJKRYy5YFIiKK8mHVwJ5gTq/cLGvnnFsVV4Eos2n+NlBmAuPy
	 4nAbURxWl85wA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 84A1217E0610;
	Fri,  5 Dec 2025 12:32:54 +0100 (CET)
Date: Fri, 5 Dec 2025 12:32:50 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>, Liviu
 Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 =?UTF-8?B?TWHDrXJh?= Canal <mcanal@igalia.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew
 Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
 =?UTF-8?B?TWlrb8WCYWo=?= Wasiak <mikolaj.wasiak@intel.com>, Christian
 Brauner <brauner@kernel.org>, Nitin Gote <nitin.r.gote@intel.com>, Andi
 Shyti <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v12 05/10] drm/i915: Use huge tmpfs mountpoint helpers
Message-ID: <20251205123250.7672fa41@fedora>
In-Reply-To: <f08c170b-714f-46d0-87fc-3218c42ce93a@ursulin.net>
References: <20251205091216.150968-1-loic.molinari@collabora.com>
	<20251205091216.150968-6-loic.molinari@collabora.com>
	<f08c170b-714f-46d0-87fc-3218c42ce93a@ursulin.net>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CD4BCC000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6xjgckmmwi77rnbctyc4p1x9pj1jknb3
X-HE-Tag: 1764934378-2295
X-HE-Meta: U2FsdGVkX19nwpqFu7Hl13b+HeNXoN5Z7F+VZzAYMKs/dGU7xIZ/VASvrt4YF8recy1UucJSdPOF0ds332+viz5o1U+BmBE/8klN5mEZeHjtW04WJ/u3N11SXPFZThkFF5zuQ5zSus/1nBLbAMNqOVVfLSqyaxai6MzOGfJUlk7xxaAeHSfv8K4x9TLC16vpMAH5I1PexMGuJ+WigdBpRw8cBXEUlqdSv3xlS0CJy3aJXf/vZPE0mFjOZxkfzEtzy1YLkp01hr4DoIzNe8Ge48R+SFPeFcMSjFpOBF4USFaM7ye19Gow7edk6owRzI1nCO65+pJY4Eh2nuR4wma3gzGdgMtB6oNE+YWdzHBvbcA3z7FXa6GCgJApsnIl7FLfwrCy1YnAatNjKowuHiqx313RzAyCAoXuz7/C0N/F6+zA6p3VwrS3lB0LPZL7+HY0+bQkGDJNI7aDdVQclq9lI7pgE5XXHSzGSMViOJnpvUUibpf6pyFrItK1uTalXpVufuj6YIPSWZ7PBAHpBCeNKpoxCUW9x+sW+F21Uxo28Ji6ovvzqmb/ZMrB8mWvgWsqPG6XOXSlRub3tZawhWqHniXw3vkqaJl/wzXbzlv83Q9C97Q5YwngNTjHbV12RFQ+Pwg7L/1wMdCUMGpHy1ltVp/IU/AKR3rGyVToHfHQtEkVEWbX+mNna5EXwCZNBZ0WRtUELIeFQ5i5K+XePc5ygW05nXsl6tR19TcsIOW1Gw6KrYllIPsIdcF1DnalOkzQo84K4jUyIvIOrvJIwzjV2Lq1ICPvotUHtD5gGj5uwX6furWEn2M/SSbD+d/ghv85vog1oOS33qWa+Dhzc1ppzluX/0uXPB5jq6lTnMiH7ZU8/ACHtwWhZfO+T0BabND1xuvRNvFhgE9i2Tz4sI5FZoQ/SCETjfwb6KMN5i0ZABkKzWH9DppJ7hD8W9LRAg6odxxz4hpNpVw2S+J8y8H
 O1yqNzD7
 HXRuwE+E9GcOW91ZWu16sdgn0g9AwV8+FQnQjNbYLse2/ir+DZ34VhmrLOn1gekkh4c+llA3VMbw2bQ83uO7RRd5pmbXt3VRiYuf6vEUmoRpmdsFJLXTxgAGZgT01RghARuGdcep4JXfQlSRjz5XFw1G6XRRd0/RX5ODgGTzux2yY0RhWOqCZqjA1VQqsijYDEXwutGPa/ByjLZu3ClpjrrcNM84X7UB88mG2rsH7tnhNoAyU9Ue/1nUpnp2qCbJcATR4eXRRC618t7hiBGqxQdVPcToyb5LDtDYbRVUkOXmq8JrD8Gti7gVat1cXCOONNBPTYraETe8CECuUAfdH8Q7Jj2Ycst66U0i9Bob+y7ZwIxBDdXVt2azCvwtRaEwDEO80YpQhSNDoWeqysU3TsS3iF1BKaDTUuFtkg+VtNWdPofM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025 11:18:39 +0000
Tvrtko Ursulin <tursulin@ursulin.net> wrote:

> On 05/12/2025 09:12, Lo=C3=AFc Molinari wrote:
> > Make use of the new drm_gem_huge_mnt_create() and
> > drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
> > it's just a few lines long, the single function in i915_gemfs.c is
> > moved into i915_gem_shmem.c.
> >=20
> > v3:
> > - use huge tmpfs mountpoint in drm_device
> > - move i915_gemfs.c into i915_gem_shmem.c
> >=20
> > v4:
> > - clean up mountpoint creation error handling
> >=20
> > v5:
> > - use drm_gem_has_huge_mnt() helper
> >=20
> > v7:
> > - include <drm/drm_print.h> in i915_gem_shmem.c
> >=20
> > v8:
> > - keep logging notice message with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
> > - don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
> >=20
> > v9:
> > - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
> > - remove useless ternary op test in selftests/huge_pages.c
> >=20
> > v12:
> > - fix layering violation in selftests (Tvrtko)
> > - fix incorrect filename in commit message =20
>=20
> Thanks, looks good to me.
>=20
> Acked-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>=20
> What are your plans for landing the series? Presumably you'd like to do=20
> it in one go via drm-misc-next rather than in stages and different trees?

Yep, ideally this would go through drm-misc-next.

