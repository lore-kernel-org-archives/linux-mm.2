Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A18D34098
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE1C6B0088; Tue, 27 Jan 2026 10:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1423D6B0089; Tue, 27 Jan 2026 10:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D4A6B008A; Tue, 27 Jan 2026 10:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFAC46B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:56:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FEE7893C8
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:56:57 +0000 (UTC)
X-FDA: 84378197274.22.DCD4AF3
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88D5340002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:56:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=hOX1JPJp;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769529415; a=rsa-sha256;
	cv=none;
	b=U6HVt5VigLZGpVuY2AmEhwZd0W2/Y68z6gypyBJdXm6wxw2yuUgbcFhfUMO+4BeGRcS+Fy
	Mo/CgrfVUpLaKZbwyUKNc7YgkZJcVi0zvt477p4OoDG4biEF893Gx7Rj57OWk6vS179Vd9
	FgDwNREUZbz8YEqKxDuPKIc2IbpoT3Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=hOX1JPJp;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769529415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCrtMRiCQ2PVnDjFu5h4g4+xZ5mOaLNSIm+Kpg7O3gk=;
	b=G4Fu62odpCPiTlVwg7yhm4ObYNt66ziKMsPgndO0xdcgfCuFOBvn22Vv2KQs/gDs0GC7LQ
	BhK0tsdXOqNB0TryNzNFubvYB85HnJmE85YhtqOZbP4zPp9WTHLqU9JTrMaxFzJtbM3u/1
	378yFVOXCbfdnUbtdudUwQ7ZaETC4EA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1769529412;
	bh=1jKQDBenEWaJ7TFf0WrfzC1mycbwa8UujGQlMExWCaQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hOX1JPJpzCqCWc7TlXWIgZRV5N7gH7GITOjU48pflKseDKzQWDlLvhkcIDpMd9MuT
	 wQE9nwUxuXdtHzPz3OsVckwsUq3BFIoU9I5lS0fZbs0yaxht2/h2mKGJmmR+5ZkyFp
	 xRxNVZ5xRq5RVzEV8ny8LeRWDZDKG05bZQUEVASixaR9CZw/xafnzpcaINuKXlb0Sy
	 PzrnZzNVWYdiTBcA9JI4keBfODhf2PsR9RpaVXmvRv7n7G8zcxRJRDDAO2ukDZXEmI
	 ZvLR3Ur4tCTjoS/hW8DOVaH5yTPvJO6uMifpzmNPxPVgICZ3cWSfOIPlGv1jkH9PqU
	 bMru0xzfY/JHA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 7070217E12E4;
	Tue, 27 Jan 2026 16:56:52 +0100 (CET)
Date: Tue, 27 Jan 2026 16:56:48 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, frank.binns@imgtec.com, matt.coster@imgtec.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] drm/gem-shmem: Track folio accessed/dirty status in
 vmap
Message-ID: <20260127165648.4fc27c4b@fedora>
In-Reply-To: <20260127132938.429288-4-tzimmermann@suse.de>
References: <20260127132938.429288-1-tzimmermann@suse.de>
	<20260127132938.429288-4-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88D5340002
X-Stat-Signature: p788t4ujxwmu6tn8p78h4eg6khcegwow
X-HE-Tag: 1769529415-534576
X-HE-Meta: U2FsdGVkX18ycaGFZ7HZngwhyt9NFiRhrh7UAk92wolbNX7qjjZvN0nYQIncdANAhPMF+a+rXoWqXr4zgFri5QufnyhGxB8Qwf3am78PDFuqM1BE5Bgmau26kFFlMNjaw4dnNuKi1HtNpZSPq2rNvLQVGjHqphAtgM6N3nO/0W/IyWasSDWcfs6Bg4H/yLNFuA49KRHJ1ihl+vlpqt7Y2srJxTtUyB7Kg/WhjGUv8K8x0NnmEmQ+69miZ4koIFjR92iLm71/cKEHoJIhnVxjXtyh9WGQegcGpxD2uHVEGkCIZ4Aot9yMj+icc8Vrl8joN/ESHXuvKIdGgMZGu8A6Plu5hJew5g6md6us4vvu55aFagu+9S1xseFS/yqjMEYAIm+SjrfSTMnjDRtaCW/VIhfud+VeCkdCXaqbOXfrbF8oGbOdx/ZAqngMHBkeqry0rSLTEdbjZZ4hqqAGjgrl1Kfkw8AuoudOKqUEN/nrTA26QFcLYbyiu/qDbc8zrxkgLnVXjIpLKQIBQqgblHaa+2sFIoGrA9vLB3wDPJrFER+b7XldibQtBGCZQtGRkafbfB90sDiXyANtujgJZeTsbjQpkhMEMIuiNsPJkOOXIQbdGgV3dqe+D0LpEwzvMbd/In23nqwZjPZ9HzpyOR1zelGde5O2YHwI4ZII5De9SJWsntgf69P68zR700l6qcspbTnYaHZlL/X0ohb2K6J85BmKHbFqEF8ouA7PSB5TMO3AbEBAj/x1VW6jAGHFH2az/67RkH5fKIJmqoTvAUAxxIyVfcqzK9eeZ525/eeA+smhdqpWY3KqFip7BBCR5kAYgMKu8PEn5miRc+Urga6GyJbj8orcYApaKXJ7mPoJOI/TGQk2kn8bX9Qz3lQ6cos0U0DsS1i4+sIDSfkwDIXmGKI/gZepqOfL2/9YtzXBM+cX42ME5nY3C1Rd/uqW2CbzoB3MFgHcUxRtyRvUBnI
 0oQ8e3dn
 1v/gqSmPFmXc8qNw8LNPLNKQA0JOh5x3Zk4Wx0/5tlgk6j3z+7tVElzYoLLVwHbwgNsiqMkdK6rQmU//4C+rzQU142QdlN6pISzAf7aujCWw9Zv+yeUkJI+2hn6aNgRuTYak4Kto4wAbV7qkxUvubuXomR+H7slKngo3Vd0nWBfjKFyOT63czub+O8ruFUQe0GzIE6AtCUOQFq8V1gKjFDXsEqi0/JXLg9ckoGUz3a0nUof4pllTTHVC2xMuW1ue+trCQFCunJpQWu73nBz9UtEeh6HiKR4WrgRgwXKivtz9ov5wjhKE4lFwVIQLbq7OxU/9KoL9YtcmHyhKcrEi/6uCwDkAAOGd5ybGNcGEHmvsqu21oqJtLgXTgAV4VzWRhYIUDDw7yEixNoxF+BUGt6PS2Ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 14:16:38 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> On successful vmap, set the page_mark_accessed_on_put and _dirty_on_put
> flags in the gem-shmem object. Signals that the contained pages require
> LRU and dirty tracking when they are being released back to SHMEM. Clear
> these flags on put, so that buffer remains quiet until the next call to
> vmap. There's no means of handling dirty status in vmap as there's no
> write-only mapping available.
> 
> Both flags, _accessed_on_put and _dirty_on_put, have always been part of
> the gem-shmem object, but never used much. So most drivers did not track
> the page status correctly.
> 
> Only the v3d and imagination drivers make limited use of _dirty_on_put. In
> the case of imagination, move the flag setting from init to cleanup. This
> ensures writeback of modified pages but does not interfere with the
> internal vmap/vunmap calls. V3d already implements this behaviour.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>

The gem-shmem changes are

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++++
>  drivers/gpu/drm/imagination/pvr_gem.c  | 6 ++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 30cd34d3a111..8c07a8f81322 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -265,6 +265,8 @@ void drm_gem_shmem_put_pages_locked(struct drm_gem_shmem_object *shmem)
>  				  shmem->pages_mark_dirty_on_put,
>  				  shmem->pages_mark_accessed_on_put);
>  		shmem->pages = NULL;
> +		shmem->pages_mark_accessed_on_put = false;
> +		shmem->pages_mark_dirty_on_put = false;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_put_pages_locked);
> @@ -397,6 +399,8 @@ int drm_gem_shmem_vmap_locked(struct drm_gem_shmem_object *shmem,
>  		} else {
>  			iosys_map_set_vaddr(map, shmem->vaddr);
>  			refcount_set(&shmem->vmap_use_count, 1);
> +			shmem->pages_mark_accessed_on_put = true;
> +			shmem->pages_mark_dirty_on_put = true;
>  		}
>  	}
>  
> diff --git a/drivers/gpu/drm/imagination/pvr_gem.c b/drivers/gpu/drm/imagination/pvr_gem.c
> index c07c9a915190..307b02c916d4 100644
> --- a/drivers/gpu/drm/imagination/pvr_gem.c
> +++ b/drivers/gpu/drm/imagination/pvr_gem.c
> @@ -25,7 +25,10 @@
>  
>  static void pvr_gem_object_free(struct drm_gem_object *obj)
>  {
> -	drm_gem_shmem_object_free(obj);
> +	struct drm_gem_shmem_object *shmem_obj = to_drm_gem_shmem_obj(obj);
> +
> +	shmem_obj->pages_mark_dirty_on_put = true;
> +	drm_gem_shmem_free(shmem_obj);
>  }
>  
>  static struct dma_buf *pvr_gem_export(struct drm_gem_object *obj, int flags)
> @@ -363,7 +366,6 @@ pvr_gem_object_create(struct pvr_device *pvr_dev, size_t size, u64 flags)
>  	if (IS_ERR(shmem_obj))
>  		return ERR_CAST(shmem_obj);
>  
> -	shmem_obj->pages_mark_dirty_on_put = true;
>  	shmem_obj->map_wc = !(flags & PVR_BO_CPU_CACHED);
>  	pvr_obj = shmem_gem_to_pvr_gem(shmem_obj);
>  	pvr_obj->flags = flags;


