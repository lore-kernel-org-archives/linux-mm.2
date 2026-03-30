Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4408FFF495F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 08:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE8A6B0092; Mon, 30 Mar 2026 04:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C63A6B0095; Mon, 30 Mar 2026 04:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DBAE6B0096; Mon, 30 Mar 2026 04:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF0A6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:06:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 362911A0604
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:06:50 +0000 (UTC)
X-FDA: 84601998180.10.DC91AEC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id CCAAA1C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:06:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0KiiUpi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZXX/oXNb";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0KiiUpi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZXX/oXNb";
	spf=pass (imf20.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774858008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWmpX9DV1uhzYVPASmxne39l3PVA2qwD4djw9df0ADo=;
	b=8RklkHxE95sKnTPmU9o9L8cQLdrhWwTIPQMNpxAU9NX1ky+fFSQ0M1zBy35hrWI+MeXFGM
	aw8YkYZkzYP+/AAdIM7MOER4t0LKZE/k8cqaRLRugBAL0EOxtdAiaxk2hweKIJQ3KO8mz1
	2XbCjxZOzISw6PfH4jF8+yk2FLO6Mec=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0KiiUpi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZXX/oXNb";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0KiiUpi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZXX/oXNb";
	spf=pass (imf20.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774858008; a=rsa-sha256;
	cv=none;
	b=FqeTemdrdMX45ZfBmZ2NXMLyCkwYmQL2Z9PXNM9Ls6ZbX8DQsPhmwu93vt4Km5FjgyAwCp
	K+ZJm4PuFiznJgWxjWeXzg/NJ4ozMzwBxlsQ8xyUrh7Rv9r9CWFhb+es1+Qzuq3wotO+2F
	oBgQ7WN8PBnHbpzvvoUiPfXNCfivIWY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 210B95BE85;
	Mon, 30 Mar 2026 08:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774858006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CWmpX9DV1uhzYVPASmxne39l3PVA2qwD4djw9df0ADo=;
	b=Z0KiiUpi+mjkZoAO1laz0YQAD7cd0VkpeEZSQLqrUxxwufGKu4MjJnSIVLagGUccDHtDXj
	FHjWMoUSRk/FTCKCDgzqdDV0D8vGCgbCXCAl6nlTBJCHCdKr8SjaSpXKveyTJsYjG2j9GY
	oJWqX4wtQ4hUsO6JUL4it0xYx8Fn50Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774858006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CWmpX9DV1uhzYVPASmxne39l3PVA2qwD4djw9df0ADo=;
	b=ZXX/oXNbKy1KXwpFa8X9Vmxkrku+HP7PjiCosE1EjtxuMgFppr5Vetqt4j2u8CHWNufdjn
	fzJ2TWk/ldcXEMDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774858006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CWmpX9DV1uhzYVPASmxne39l3PVA2qwD4djw9df0ADo=;
	b=Z0KiiUpi+mjkZoAO1laz0YQAD7cd0VkpeEZSQLqrUxxwufGKu4MjJnSIVLagGUccDHtDXj
	FHjWMoUSRk/FTCKCDgzqdDV0D8vGCgbCXCAl6nlTBJCHCdKr8SjaSpXKveyTJsYjG2j9GY
	oJWqX4wtQ4hUsO6JUL4it0xYx8Fn50Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774858006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CWmpX9DV1uhzYVPASmxne39l3PVA2qwD4djw9df0ADo=;
	b=ZXX/oXNbKy1KXwpFa8X9Vmxkrku+HP7PjiCosE1EjtxuMgFppr5Vetqt4j2u8CHWNufdjn
	fzJ2TWk/ldcXEMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96B004A0A2;
	Mon, 30 Mar 2026 08:06:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PpdaIxUvymmnRwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 30 Mar 2026 08:06:45 +0000
Message-ID: <1ed2d223-fcf2-46e3-8d5f-864440a49491@suse.de>
Date: Mon, 30 Mar 2026 10:06:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/shmem_helper: Make sure PMD entries get the writeable
 upgrade
To: Boris Brezillon <boris.brezillon@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, kernel@collabora.com,
 Biju Das <biju.das.jz@bp.renesas.com>,
 Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
References: <20260320151914.586945-1-boris.brezillon@collabora.com>
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
In-Reply-To: <20260320151914.586945-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCAAA1C0003
X-Stat-Signature: 91sfi1m3aiik78pk8eamft1n7isxcpxs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774858007-937386
X-HE-Meta: U2FsdGVkX1+rc8OhqcBcJUvQ6OMN1uKfJ18HsLihvdmtlX8ZvEeH7ARyzwdMTaKAsf7Y9Vbnaa1dBE033pBk6ZN0njAbEmWpkz7NKg73m1DKcBgiwA1/TEQdJszcsqm5NB4FnbHwNzmZSxmTUGZZ42TgX718Kqx+BvPm1yhPOkLvr9LXcLDRjCvI4P5C8Q02zZN2bjR0nqe46isWwkt+AoohvmxDYB5xPazaj1im5WTo7zPt2C9RJvUHegMN4YJ2G868+zutGAI3b2+55S1jyV+eKOmkACdxG3LIlmdsHeo5YRDmOXqO0XD+iK7s3l31KD5KpxupATz7axjXcWcVVxjBmLRSBc8qI1elLUzEIrvwtdwZQz9zJBsZzEpzn/nLvXnGLomvKKA8IlYAbL410gbdR+fw52znCabXsiokmKP3MGOsroLSI5m81sLG1NbKmxsWZm/0ReVfAuvYDKZNegKzt8/xDOKHmSweP5fAo3vNtNdTpH+DKRpOQQ3de50Uwe3MPPY5j+rLXnr4Iw+XuYQNwLfUiDrMnJoojC5KP/SYKQeIw8ztQrnoLg/ossz6pdBgUKJuOAbsM+lgbRbfLRA6wXEeCloEsUk1NwP54kGHgy1hIGV37P8ON6NArZr6yRapIDOpv4m1+/ml4BhALvQYc5iQeCA4SnQIhdYieAk7HUg6WU69yhG4ZEno6nWROkwQ2/8r9RPk4Ht4xp9Xcsxjy3j2zpidDIGe3OxAuZxqN29yJ0/nQhmagzMF4oZC9K7FLGp0TaE5W48IQsaNe/3QyeCENwmras8l2E9kWnfYB196fgatLW1fe+j1YJzwcd+09l/2rA8zFEiPtpAFjXFhDUOucw0Mg217KQdHUTnXg1s1doV5oUBLFiDupoeg24mg/PzU2QIK3l8DZItTNNk3pDuYRzNYfYERvoPW8Rrk5ZvlRfVDjmx9b2ZlVCObLgUxIuxcAgi++fwMdkS
 lmD6/gBX
 hwgQHuXoXV4Y7mYYnBaz8zwzS3qFzFRqspIfwV1Y7Lx4B9zmvP5V60phtipzGknoJ3dbGmI9WdM36bKcW+qkhALlNSoSAsmlt0fmWNVud+MRMuQHMMuNqafT84Y3klpTdCJnqnNW+gxVIldNFWgEHMiEO5allGl61w7rE1INBRPzeZKwr7L24PyzFgkhqjiBX8cY9vRDd8kOu70H2xXuytJW7tbmq5wIURDwNB8Rdrxhad906CMKPLuj0Vi/1YrWRxoxZUnvD7EacvOG76e11vb2Y6nnc1F1JYw0pncwzNMWxiDIVYgK/wB7YeveaAhBzXZxWzvKCE6DQ4UqRjs4ejVHp7mdt2ROFSQODtEFPAazV3B+ER+PnWyZcn5dNjb+Mmc5P5mMTGgXsANOIHqKKB0aaSEOWGXB3SIjVH0tozooE8M/wD5OVcwHqUMezyt/y0aSNnfI7i1Zk2KA2esyBITk8O3es11bkSg+SICP9/2BDHUKjLx0UNmBzKjEzB7TZ4LJxVe1iA4pp9gb9f7JBbA/ofWUWquCCQcO8LMRMUIQu2YsamBTP4hFYI49tSwVLQc3aGdh5XP9t9ziTl9Kg6R68VLPm2EMZNGpftEXDd4WHOrOMP/hQJSmraeQff56r1mQL116nLqPZ6VaUhPengSGGiGw2tOLV8nTu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Am 20.03.26 um 16:19 schrieb Boris Brezillon:
> Unlike PTEs which are automatically upgraded to writeable entries if
> .pfn_mkwrite() returns 0, the PMD upgrades go through .huge_fault(),
> and we currently pretend to have handled the make-writeable request
> even though we only ever map things read-only. Make sure we pass the
> proper "write" info to vmf_insert_pfn_pmd() in that case.
>
> This also means we have to record the mkwrite event in the .huge_fault()
> path now. Move the dirty tracking logic to a
> drm_gem_shmem_record_mkwrite() helper so it can also be called from
> drm_gem_shmem_pfn_mkwrite().
>
> Note that this wasn't a problem before commit 28e3918179aa
> ("drm/gem-shmem: Track folio accessed/dirty status in mmap"), because
> the pgprot were not lowered to read-only before this commit (see the
> vma_wants_writenotify() in vma_set_page_prot()).
>
> Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>

> ---
>
> This patch is based on drm-tip [2], because that's the only branch
> that has both [1] and the dirty tracking changes that live in
> drm-misc-next.
>
> Also added the THP maintainers in Cc, so I can hopefully get some
> feedback on the fix. For instance, I'm still unsure
> drm_gem_shmem_pfn_mkwrite() is race-free (do we need some locking
> there? should we call folio_mark_dirty_lock()? should we call the
> fault handler directly from there and have all the dirty tracking
> in this .[huge_]fault path?).
>
> [1]https://yhbt.net/lore/dri-devel/20260319015224.46896-1-pedrodemargomes@gmail.com/
> [2]https://gitlab.freedesktop.org/drm/tip
> ---
>   drivers/gpu/drm/drm_gem_shmem_helper.c | 46 ++++++++++++++++++--------
>   1 file changed, 32 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 2062ca607833..545933c7f712 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -554,6 +554,21 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
>   }
>   EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>   
> +static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct drm_gem_object *obj = vma->vm_private_data;
> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> +	loff_t num_pages = obj->size >> PAGE_SHIFT;
> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +
> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> +		return;
> +
> +	file_update_time(vma->vm_file);
> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> +}
> +
>   static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>   				 unsigned long pfn)
>   {
> @@ -566,8 +581,23 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>   
>   		if (aligned &&
>   		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
> +			vm_fault_t ret;
> +
>   			pfn &= PMD_MASK >> PAGE_SHIFT;
> -			return vmf_insert_pfn_pmd(vmf, pfn, false);
> +
> +			/* Unlike PTEs which are automatically upgraded to
> +			 * writeable entries, the PMD upgrades go through
> +			 * .huge_fault(). Make sure we pass the "write" info
> +			 * along in that case.
> +			 * This also means we have to record the write fault
> +			 * here, instead of in .pfn_mkwrite().
> +			 */
> +			ret = vmf_insert_pfn_pmd(vmf, pfn,
> +						 vmf->flags & FAULT_FLAG_WRITE);
> +			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> +				drm_gem_shmem_record_mkwrite(vmf);
> +
> +			return ret;
>   		}
>   #endif
>   	}
> @@ -655,19 +685,7 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>   
>   static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
>   {
> -	struct vm_area_struct *vma = vmf->vma;
> -	struct drm_gem_object *obj = vma->vm_private_data;
> -	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> -	loff_t num_pages = obj->size >> PAGE_SHIFT;
> -	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> -
> -	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> -		return VM_FAULT_SIGBUS;
> -
> -	file_update_time(vma->vm_file);
> -
> -	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> -
> +	drm_gem_shmem_record_mkwrite(vmf);
>   	return 0;
>   }
>   

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



