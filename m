Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C456CCA471
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7558E0016; Tue, 30 Sep 2025 06:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7EFF8E0002; Tue, 30 Sep 2025 06:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB298E0016; Tue, 30 Sep 2025 06:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCCC98E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:57:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58E3D160692
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:57:33 +0000 (UTC)
X-FDA: 83945615586.12.ED25488
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6153F100002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:57:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lcUUCjon;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759229851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02wYc5m3nUghUOn6h6v6/is5clJELk5xW9EH5CMgQ7o=;
	b=IH0tGxVXRj9+4vItlk92gNUwc/rtDfHI8O4r4DM8/g268Tytu2zirXvbL7w2rJ5H8n2h0y
	UNXjqRhPp/cvRAK/07uyB1CsPdLwRn0LdDY5gHB9Be1u+l18e/KDHFLShnlAH9WknWMKuN
	k4fBSaF0BTkNuBi2mWVVRfUmSTGtkY8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lcUUCjon;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759229851; a=rsa-sha256;
	cv=none;
	b=UIlfLCHCdVQQ7yIl62oYS16DRggoz0ilPsveLmCBiGUJnNXua95Zz/hkaZkoHHdc8CNyP0
	+H4jbbJoJViFfdYqeDT9iHzOlxjpTbqPLywBADq8sCZ7/9VgYJ2lYrmJbeg76cZGOJcsKH
	dn0CNb92H+SVX3Xth7uGxA2e4KXWH0Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759229849;
	bh=6bPRcsgjW5miijm89Vj9ztPqCVHtA9OfZProSwKLM+E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lcUUCjonC+V4D2GtM4PuXn8rRIxReNC+RXOaJZ7hhwdzpU5mJal943IHtXfksU6wu
	 1D4iYmyYsIQxCHCBDNgn2L/cw/FXXWt6qkiOP9BOrFZOE5VtEVtOs3UMLbTPqlRi7m
	 sKXNlWf3l89UmYA7IFySASPm0/qugfjqrl/9Fy28nPJgbr6M6qH4YrQBz4x7zBUoER
	 1Im9nrbMPTENN7AdmsIDsaHOzwTV3uVEXlQrAUK8WQc5UWwjVWbhHlBwe+whDMd3ua
	 rnCpyrhWzx7KD6aATwtJa8IFUPOVSk/k5fYDLMd24rXPk8ymgdwszEHPAfqdwn10ho
	 td+aeBNfzDZRQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 48A0917E0097;
	Tue, 30 Sep 2025 12:57:28 +0200 (CEST)
Date: Tue, 30 Sep 2025 12:57:25 +0200
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
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH 3/8] drm/shmem-helper: Add huge tmpfs mount point
 helpers
Message-ID: <20250930125725.258e74a5@fedora>
In-Reply-To: <20250929200316.18417-4-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
	<20250929200316.18417-4-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6153F100002
X-Rspamd-Server: rspam05
X-Stat-Signature: 8zmae9wqiegigma83wdq3nfexdy77tic
X-Rspam-User: 
X-HE-Tag: 1759229851-107275
X-HE-Meta: U2FsdGVkX18J2fdAIHOAStra+7X78abJNhhzvRrb0iSpZstz2MoCQNQE0WU4l9vH4/6YIXcv3rh4GnBKVn2CcWMfb5M1qOgRrFEKhXvoL+CfmmsMEKHuwUOGjlTR0fuHIo+Tv9wODNTNp6gLIW3uMXW3hQVpvNyYsvguoKXQItOTtTOpnMC5JyQBgwhCRNqTw/yD9D1qYuxFsvlQTbTGOA7j+0fY3GbzAADZYQNBFfY34R7uz5ka/6GOJ30U4S2DuaWr+Ni8rpPkWc16L1rF3C32pZEsP2SHRS3+fYrCQy2HVZ2mtHfato3lvQkS86O5kJcaaTYd2itN3QAXxVapc6cSZWO1vUvllbKIo23FDTowv+JZctw9c1gkGQBTgdJn0647N3Ev890IIMMEpwaCACjDewRr8OrFdZYECyQjvVTnSuSCyWp/FYBPForzYQuRpeKDQpZyTcgG8i6BU9Y5KYTQ/FeE9YL1lG+Q/b82itvL0xyf10kuR9S8vBRo03sPDqvQUVdMu+7v8ERT/7XbqJIipuAzuPaI/Rtvit7Qvp+2GrxsyR3HSP/q/Xht/aVJvrE1LVtnoL0WKA2iZZGb1ucK/Imsgge1yU4eh3TUno+ibE1Qu+PzIrb6w4Dp5jSMMgZWF/UvR1jU/4TlF4Jco8zMu2v6hx5ys4a11m0E8b6rzveip27F91Jvbs/GOw9xKfcepw8SFeDlvUcMTYgeNHQXx+v5a0AqdM90iX6lkQncFavmMWnqUtkJbhCbhAU47eUiSlohATSXXnDRhjU3LdPt8mdDUT5EleabValPALNL1OG4/6G9X4s4rJfAb6yyfXfQCJaKgGOEoxQ361m5DGwyI0pz9ozpSrjfopQ0VLUoQ3qF5xzXr80XpGI0+fV7jmQbm7847k+iCEZKnnQ1b776APXXIriiQaKKIhX5YlVB0kDvXkACzQ8fDEGpHw8gc/FCtFnqp5+JawerZV+
 umnynod7
 Wrwk9JmGWasvO33BVCXX8bQ3r3zGllqg/nWJ/Rp4xGEfDLPg4cvveXv2+8wtBGfFaBXa2D38kZv8kUlM6V2pP484n2acMsKNe0N3GTR7t3jYCZiUn3iLKJ3YE+28FuzULrFTf0oYU7afP2wS3OYaoWo2Z7Ry4xpJd8fXM63ju1aVK3umYDcubQ1dBNWiIYFVbEap0HcwSCT4xMr19jUnBWArskGn0xooqi07LOTz9T1YwyhHC6NLQEVoYQuqrbsm+vuefu/SzDer+mpMUVbqrv/wask4ZIYZdXohg3c/bPH0r32U9k90HtEj4IQzNYGFLFoP+k0vOWqD98W46yTy0dTw6FgJZM6HKCRrt3CJm2mdFljuV8qC3JA6R/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025 22:03:11 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Add the drm_gem_shmem_helper_huge_mnt_create() and
> drm_gem_shmem_helper_huge_mnt_free() helpers to avoid code duplication
> in the i915 and v3d drivers (and soon panfrost/panthor).
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 56 ++++++++++++++++++++++++++
>  include/drm/drm_gem_shmem_helper.h     | 14 +++++++
>  2 files changed, 70 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm=
_gem_shmem_helper.c
> index 22c4b09e10a3..808721b8be3e 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -5,7 +5,9 @@
> =20
>  #include <linux/dma-buf.h>
>  #include <linux/export.h>
> +#include <linux/fs_context.h>
>  #include <linux/module.h>
> +#include <linux/mount.h>
>  #include <linux/mutex.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/slab.h>
> @@ -36,6 +38,60 @@ MODULE_IMPORT_NS("DMA_BUF");
>   * drm_gem_shmem_vmap()). These helpers perform the necessary type conve=
rsion.
>   */
> =20
> +static int drm_gem_shmem_add_fc_param(struct fs_context *fc, const char =
*key,
> +				      const char *value)
> +{
> +	return vfs_parse_fs_string(fc, key, value, strlen(value));
> +}
> +
> +/**
> + * drm_gem_shmem_huge_mnt_create - Create a huge tmpfs mountpoint
> + * @value: huge tmpfs mount option value
> + *
> + * This function creates and mounts an internal huge tmpfs mountpoint fo=
r use
> + * with the drm_gem_shmem_create_with_mnt() function.
> + *
> + * The most common option value is "within_size" which only allocates hu=
ge pages
> + * if the page will be fully within the GEM object size. "always", "advi=
se" and
> + * "never" are supported too but the latter would just create a mountpoi=
nt
> + * similar to default "shm_mnt" one. See shmemfs and Transparent Hugepag=
e for
> + * more information.
> + *
> + * Returns:
> + * A struct vfsmount * on success or an ERR_PTR()-encoded negative error=
 code on
> + * failure.
> + */
> +struct vfsmount *drm_gem_shmem_huge_mnt_create(const char *value)

Given drm_gem_object_init_with_mnt() lives in drm_gem.c and doesn't
have the _shmem_ prefix, I'd be tempted to move this helper to
drm_gem.c and rename it drm_gem_huge_mnt_create(). Actually, as I said
in the panthor patch, I believe this could also be passed a drm_device
and have the resulting vfsmount stored in drm_device::huge_mnt. This
way we could get rid of drm_gem_shmem_create_with_mnt() altogether.

> +{
> +	struct file_system_type *type;
> +	struct fs_context *fc;
> +	struct vfsmount *mnt;
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	type =3D get_fs_type("tmpfs");
> +	if (!type)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	fc =3D fs_context_for_mount(type, SB_KERNMOUNT);
> +	if (IS_ERR(fc))
> +		return ERR_CAST(fc);
> +	ret =3D drm_gem_shmem_add_fc_param(fc, "source", "tmpfs");
> +	if (ret)
> +		return ERR_PTR(-ENOPARAM);
> +	ret =3D drm_gem_shmem_add_fc_param(fc, "huge", value);
> +	if (ret)
> +		return ERR_PTR(-ENOPARAM);
> +
> +	mnt =3D fc_mount_longterm(fc);
> +	put_fs_context(fc);
> +
> +	return mnt;
> +}
> +EXPORT_SYMBOL_GPL(drm_gem_shmem_huge_mnt_create);
> +
>  static const struct drm_gem_object_funcs drm_gem_shmem_funcs =3D {
>  	.free =3D drm_gem_shmem_object_free,
>  	.print_info =3D drm_gem_shmem_object_print_info,
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shm=
em_helper.h
> index 589f7bfe7506..5e153fb63f38 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -107,6 +107,20 @@ struct drm_gem_shmem_object {
>  #define to_drm_gem_shmem_obj(obj) \
>  	container_of(obj, struct drm_gem_shmem_object, base)
> =20
> +struct vfsmount *drm_gem_shmem_huge_mnt_create(const char *value);
> +
> +/**
> + * drm_gem_shmem_huge_mnt_free - Release a huge tmpfs mountpoint.
> + * @mnt: struct vfsmount * to release
> + *
> + * This function unmounts and releases an internal huge tmpfs mountpoint=
. If
> + * @mnt is NULL, no operation is performed.
> + */
> +static inline void drm_gem_shmem_huge_mnt_free(struct vfsmount *mnt)
> +{
> +	kern_unmount(mnt);
> +}
> +
>  int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obje=
ct *shmem, size_t size);
>  struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev=
, size_t size);
>  struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_de=
vice *dev,


