Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686D7CCD183
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D24E8E000E; Mon,  6 Oct 2025 02:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA428E0002; Mon,  6 Oct 2025 02:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6FA8E000E; Mon,  6 Oct 2025 02:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5858E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:58:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 159AF1404CA
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:58:52 +0000 (UTC)
X-FDA: 83966786904.07.EC26BD7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 25C0AA0008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:58:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Zf5e3uLc;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759733930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qz2f2ookJOudOG1myt9qH2P2FFfpw3fE/hX8Eb6YG+Q=;
	b=oV8jCX18DK/ZPd6xArUCEla4fGLwJHMmTwppg0aTKrag5eB2XeGfVuB+T3zr5Wa8KEUmwN
	h9GAaDLKAY/pyJHiLc6KwXVIG466jDHSDgWrntNI2cTBg3tFe00V0oG1AEzx6Lw7aDz5Su
	q54fWARnIx0tnxd15JycToYDvpLjwIc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759733930; a=rsa-sha256;
	cv=none;
	b=XIZX7hjnhPyumZ6aHu+LC3L/kOQDE/umPd3E+rHP7+LNVlAKT8x107v1juSwwcqix5iVF7
	SimHXr9jmhTEgXU7HGNPlnEX4QW8AO+SCqiV3Z8YgKeqCZVPU+oTGuMfc4brHDOo8mRkGw
	fp5Hv/0kZXA4SwlD9KkJsDekDdSESSQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Zf5e3uLc;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759733927;
	bh=T/Ja1FOgn9EpgL2xm0d3pUaom2fzzJpJ3Tr2OK+bn6U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Zf5e3uLcS6C4R0EznG+pU2ETh3nNYwFJCsPuTxX9DH9Nt2oab3AHIzKVfKP3NhKMl
	 1reRRVxi0l0bdJIq5hGeTPMzlQYUqT/2sMhAqxqet/lFKU+n6XlcX6JM/bdnelbugF
	 1eNq/3GhfoLsie/T9EWeqXjiC0+T0h+fVR0fdlynHlez/s9Lg+lWOausjAhOWvSf5k
	 vESRzzc9TvEaCMu5WG7AD5c8Vm0HwPQvd2dHIXCCXUf4U7zWkHyMmxs38i0afTon1i
	 z/d5DcpiRVxJNkRdIGB7MEW7IM0Tk3cxgacB7Kp5Cw1ZoXGWn00fQWhe7a01RKQ4wj
	 xL0111m9iCWxA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 389F617E11FD;
	Mon,  6 Oct 2025 08:58:46 +0200 (CEST)
Date: Mon, 6 Oct 2025 08:58:42 +0200
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
Subject: Re: [PATCH v3 03/10] drm/gem: Add huge tmpfs mount point helper
Message-ID: <20251006085842.047231b0@fedora>
In-Reply-To: <20251004093054.21388-4-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
	<20251004093054.21388-4-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: az7qmckpdc7gpc5soyf6tjtu1jphpsqq
X-Rspam-User: 
X-Rspamd-Queue-Id: 25C0AA0008
X-Rspamd-Server: rspam10
X-HE-Tag: 1759733929-678764
X-HE-Meta: U2FsdGVkX1/tIHmir6zeckqEkxPQ+2pSDsIQWgJt0NYGUWOupH8I0zLqs9aD+OBHkowYNwKFNfY6PP87bux0KlZ2EChYNg+4ox0sP/iVDAKLwHCxMrahq1vD8I9/PvFBCKww/8EYv+f3DshrM4Gj651g/VnjrowDTyKEfvM9Ew5ifpJJlecywR8pfMVhkj6jMY+nJhY2hWJeBFM+MwUoKKSJh5RQMcujgYkxKDJ7TGCsxgz04t76n17HbjeUQVLQ7pfbvjkGsppt6OlOV8Vwv0ULHjeo7V/h9poLk+Y2GitlVleHiIFCRQFkCTVl1EQYIxhvw8DrMhfwYqWTN/cwPD9MzMwbAv3VEJHlYSop9q/zksjrfQ4152chTuWGzTAC9052L89lbx4s4h7EQqgpKvDTe+MJgJnGAsWV/YAoffPX9kXS5z1To0/Rb617a7QjnHneEC1uLryrumpwWum2Er/yON5pvs3mdntz4C+2QqJtBxRFvnVSo2ekxCseUhctXxRh5ED4ZhyPAOplFqJ2pnL+9GVQNzAwx3Ykz2TDFAstxo3HyH9EMN21XKdT9uLOF9qS9G4dsRR8LLBhPwIwTBVgOwVFKIBP11g4Viuf9WTiia6APi8z3/EkA8d4ERTnfiTafbZfvS1Z3kta289kzv8CAH7+Jyps+hDEcUIUEepA/wJB4uV6FQ6Du9CP4i2SzK1aYW1MABE7eCkxCCquMVgtZw0HeO6+SejRIsH0mEVIzCsPLusI9DM7ti7inybcLDQ0Jb4NT7BRLpRuu1cVCcLNKmo2zk+Wg3Asupv7+P09E8kE6FE91k5swZcQ3x8Jh9mdt06S4Uz2NzAixeTvs05vTM0UJaAJT90krImkIlZ1vac2OcPsq/PwowKC+MiK1AndIzBWAmlaX3bFDUMCx7Rr24vOCAnCmrwH9nit3utofeml/xXfq4RWarzBN9qGexLBEZBR0I7joa205Bm
 NiFVqGbO
 mqrdiFjmv/p3cImsGcQd8268i/u26QYo+/3plzfRgCRPW8kzg8k3pWX8klXn0WHsQ4R3T/4MGpxjSQZOBx/AGMZGf4PT50xtGaC+2PVWG5JlPAcMnuiRgQPPJf7l4CVCLAqIZRyXN6NZ4QDwiLJXs+OpnGTQnk6dA1rzYpxyk4bo4ihkYMAfaWz7VtPxywF40LPYk0y9J53N6Qmix+qi5iT1yiYzeHWBkp/shpiQTAP+PHmk54ZWDPBOkNuX6VEQ2oeUPmMPggfA7j3XpW8V1VwCIMSAiB/w1pgt+2xGT8rHlojNAQLeeciCWCBVXw0Fs/uApgSRywQe4CktD8NjnBlV4irNQniVpvI5ZhDaehYvBODHDDH4pT1rkRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Oct 2025 11:30:46 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Add the drm_gem_huge_mnt_create() helper to avoid code duplication in
> the i915, V3D, Panfrost and Panthor drivers. It creates and mounts a
> dedicated huge tmpfs mountpoint, for the lifetime of a drm device,
> used at GEM object initialization.
>=20
> The next commits will port drivers to this helper.
>=20
> v3:
> - store huge tmpfs mountpoint in drm_device
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> ---
>  drivers/gpu/drm/drm_gem.c | 67 +++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_device.h  | 11 +++++++
>  include/drm/drm_gem.h     |  1 +
>  3 files changed, 79 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index f5a10ff363c9..b4e4947210ef 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -29,6 +29,7 @@
>  #include <linux/export.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
> +#include <linux/fs_context.h>
>  #include <linux/iosys-map.h>
>  #include <linux/mem_encrypt.h>
>  #include <linux/mm.h>
> @@ -82,6 +83,72 @@
>   * up at a later date, and as our interface with shmfs for memory alloca=
tion.
>   */
> =20
> +static int drm_gem_add_fc_param(struct fs_context *fc, const char *key,
> +				const char *value)
> +{
> +	return vfs_parse_fs_string(fc, key, value, strlen(value));
> +}
> +
> +static void drm_gem_huge_mnt_free(struct drm_device *dev, void *data)
> +{
> +	drm_WARN_ON(dev, dev->huge_mnt =3D=3D NULL);
> +
> +	kern_unmount(dev->huge_mnt);
> +	dev->huge_mnt =3D NULL;
> +}
> +
> +/**
> + * drm_gem_huge_mnt_create - Create, mount and use a huge tmpfs mountpoi=
nt
> + * @dev: drm_device a huge tmpfs mountpoint should be used with
> + * @value: huge tmpfs mount option value
> + *
> + * This function creates and mounts a dedicated huge tmpfs mountpoint fo=
r the
> + * lifetime of the drm device @dev which is used at GEM object initializ=
ation
> + * with drm_gem_object_init().
> + *
> + * The most common option value @value is "within_size" which only alloc=
ates
> + * huge pages if the page will be fully within the GEM object size. "alw=
ays",
> + * "advise" and "never" are supported too but the latter would just crea=
te a
> + * mountpoint similar to the default one (`shm_mnt`). See shmemfs and
> + * Transparent Hugepage for more information.
> + *
> + * Returns:
> + * 0 on success or a negative error code on failure. Returns -EEXIST if =
called
> + * more than once for the lifetime of the drm device.
> + */
> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value)
> +{
> +	struct file_system_type *type;
> +	struct fs_context *fc;
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		return -EOPNOTSUPP;

If we return 0 here, we can get rid of the

	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))

tests in all the drivers and let them call drm_gem_huge_mnt_create()
unconditionally.


> +
> +	type =3D get_fs_type("tmpfs");
> +	if (unlikely(!type))
> +		return -EOPNOTSUPP;
> +
> +	if (unlikely(dev->huge_mnt))
> +		return -EEXIST;
> +
> +	fc =3D fs_context_for_mount(type, SB_KERNMOUNT);
> +	if (IS_ERR(fc))
> +		return PTR_ERR(fc);
> +	ret =3D drm_gem_add_fc_param(fc, "source", "tmpfs");
> +	if (unlikely(ret))
> +		return -ENOPARAM;
> +	ret =3D drm_gem_add_fc_param(fc, "huge", value);
> +	if (unlikely(ret))
> +		return -ENOPARAM;
> +
> +	dev->huge_mnt =3D fc_mount_longterm(fc);
> +	put_fs_context(fc);
> +
> +	return drmm_add_action_or_reset(dev, drm_gem_huge_mnt_free, NULL);
> +}
> +EXPORT_SYMBOL_GPL(drm_gem_huge_mnt_create);
> +
>  static void
>  drm_gem_init_release(struct drm_device *dev, void *ptr)
>  {
> diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
> index 59fd3f4d5995..895b0ced972e 100644
> --- a/include/drm/drm_device.h
> +++ b/include/drm/drm_device.h
> @@ -3,6 +3,7 @@
> =20
>  #include <linux/list.h>
>  #include <linux/kref.h>
> +#include <linux/mount.h>
>  #include <linux/mutex.h>
>  #include <linux/idr.h>
>  #include <linux/sched.h>
> @@ -168,6 +169,16 @@ struct drm_device {
>  	 */
>  	struct drm_master *master;
> =20
> +	/**
> +	 * @huge_mnt:
> +	 *
> +	 * Huge tmpfs mountpoint used at GEM object initialization
> +	 * drm_gem_object_init(). Drivers can call drm_gem_huge_mnt_create() to
> +	 * create a huge tmfps mountpoint. The default tmpfs mountpoint
> +	 * (`shm_mnt`) is used if NULL.
> +	 */
> +	struct vfsmount *huge_mnt;
> +
>  	/**
>  	 * @driver_features: per-device driver features
>  	 *
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 7c8bd67d087c..7285a62d9afc 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -492,6 +492,7 @@ struct drm_gem_object {
>  		DRM_GEM_FOPS,\
>  	}
> =20
> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value);
>  void drm_gem_object_release(struct drm_gem_object *obj);
>  void drm_gem_object_free(struct kref *kref);
>  int drm_gem_object_init(struct drm_device *dev,


