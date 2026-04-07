Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C44F0E9D814
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15726B0089; Tue,  7 Apr 2026 02:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC9A6B008A; Tue,  7 Apr 2026 02:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29F86B008C; Tue,  7 Apr 2026 02:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D16706B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:49:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AD871406D9
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:49:19 +0000 (UTC)
X-FDA: 84630833238.23.7ABDEB7
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5D9281C000D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:49:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WERdu//K";
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775544557; a=rsa-sha256;
	cv=none;
	b=HPkS9b3S4Zzw+7ffM+tJO8hkt+KyQqvu3BzbuSW14edAuCKjBUHQXMU2UX9tsMaoyhCvSP
	GUQVALtE4WMcm63ETg/Rjs+RBUupkJKuRN3XawJJpCxrqrz6WlKUR+rPjhFx4q+ipYFInH
	Ku4mmpsGPNV1HRClsB5n2KWVlCsbyBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775544557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZeY293QSxwS94/+8C2N9QAoOiUfZiEZF2lGyKP5AKE=;
	b=BrTCjTVHNNWSKJX9Xi/7mfNba4AWXk3nuuZvKsAgZs/Ut8FgEKKevpGYiLJ951C2BXYTL7
	TmblYv2lIMF2kfuepaG+xSQZ6B0M7a1jCI0WvIqtxHgtcylO19xtSc/zsNlFKNrCD71eaT
	rCnZKhAooh4sTdNEx1RI9CjnZsVsr5Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WERdu//K";
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775544555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZeY293QSxwS94/+8C2N9QAoOiUfZiEZF2lGyKP5AKE=;
	b=WERdu//KTfuanPQswZOKAavLD5SrF/saVav3K5wcfXSgigtMYYuOALt64YernykprSFtXw
	i6mFsg7QITLNACQ68Yf6b8XHZqhXqSBB4xHFlQ9UfOi3vFvZVPltkhALZ5vTUoXQl+OyL8
	Jt17LZjfw2Dt1Pu2fMhJm5px5C1wyKk=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: shmem: don't set large-order range for internal anonymous shmem mapping
Date: Tue,  7 Apr 2026 14:49:03 +0800
Message-Id: <20260407064903.69017-1-lance.yang@linux.dev>
In-Reply-To: <cd5c563db32507c9c090a0ae8287e1851cb0a5d3.1775541661.git.baolin.wang@linux.alibaba.com>
References: <cd5c563db32507c9c090a0ae8287e1851cb0a5d3.1775541661.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D9281C000D
X-Stat-Signature: qkgc5pfeu8m51cz4hdjf3qd7qsrenwnr
X-HE-Tag: 1775544557-922868
X-HE-Meta: U2FsdGVkX19rZo/ldOQbsZJjmZNBY+UgV06kLeT2t25YU/X2Qnxf2P0rhQZWC1zviwdhh/qLHQQCpmuyZAokazMN7Bz5VjSHSPNCQMwsgi8zlzyCaKOV+XbFgw377yI1NpTauG4tQnnalXyK+S5sR58c0SI9UNqbVJ6e0IocpheTIcITKWRi+y2dsV4ilZv+I27f0+aBUJCHCwTo1wWAq0ab0SPMbZROeqE+In/0o0BfnTcloYJUjIF+jT0jGobJVTtkhqHpbiSkjC0D50rqTG5wonOihkdX84BFuSAHChtO/oGBk8MOvfzWjIiRmybtJ3w5UHeDJuAMge3kMZuiyxUfGG4OGHQI4O8lqstTsVEayZoHRFmHaRtmaNcnZ8jDnXQ4tMncxz85ZyI83tjFcatB+HHT7Jp/sknyJWL1OgJ+hRge9VTTW5/incNwAwYZ1DtEfvncP1s5UuJYUDFBtbXYn1vYvi8cm1AkN2ORXTKmAwlo9XJQhuUbzdSIiMWfKTjqsuKZB5HDIii35Q5S8ufNTdMvYxeZeKZioDZLQzbv2IqIFA+1hghPsqEiNG6r6L527vQaTxah64t39VtS8kEh7mnpe60DoGOGhmJwqbeJNoRjSWM8KXwQTZ8WlB+21oliDEg6AKdBm4FMxs7C8WhNfVAbBHQyHerl6MxDdCKCi99r0mMqqIhVdNy49R2fLstL2oVagPh8R7mkYK/4LMXwAuCABFb9rLxM6XnmokabQCp+bV/0J8zBSw9wiCS8yGA1Ugln4V6gV8QRpKY18qRYWs3OfQqDuDiICUit5hqymT9FcEv26f+jLWKW2WpI1YUnisSRbyHhSK/oYz7GLrLOU066hYg6Xi0r/0EseunuAB+8COwTOm3QS0xnJnQV4ZTZHIRiwSGyWhApjhReZMQbKnmmwgVQsbVjLgeqq1ux9Cuodn2I4skAuqFmVm0ncehW+/CeV9AqCt+pqlr
 OZ3mQMye
 3URoLndLHDjRB3l8uESXMH8mOE/1Xm9IsajNks+lxwUZA7pAvrCJMMws5/EAO2sL+KzMI+zwmKgq89XiQ4h7e86rmdrxVoseY96Mr+l63NLanlBX0Ac+vRSzKPBPqX5ASJdn5C9yK9Ngs1dw2QSVCOLnHBMCF2CCVOlvOIz+YE71gHwWVay9TUkg8Zs6FTczAWhROaFffYu2z2ADVKP0EhCUeyCDF++fon8+ZYQaAFE/xfM8fqQmkDsntgtyCWEYhV7lH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 07, 2026 at 02:07:27PM +0800, Baolin Wang wrote:
>Anonymous shmem large order allocations are dynamically controlled via the
>global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/shmem_enabled)
>and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled).
>
>Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
>which large orders are allowed, rather than relying on mapping_max_folio_order().
>Moreover, mapping_max_folio_order() is intended to control large order
>allocations only for tmpfs mounts. Clarify this by not setting a large-order
>range for internal anonymous shmem mappings, to avoid confusion, as discussed
>in the previous thread[1].
>
>[1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---
> mm/shmem.c | 13 +++++++++++--
> 1 file changed, 11 insertions(+), 2 deletions(-)
>
>diff --git a/mm/shmem.c b/mm/shmem.c
>index 4ecefe02881d..a60fe067969c 100644
>--- a/mm/shmem.c
>+++ b/mm/shmem.c
>@@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
> 	if (sbinfo->noswap)
> 		mapping_set_unevictable(inode->i_mapping);
> 
>-	/* Don't consider 'deny' for emergencies and 'force' for testing */
>-	if (sbinfo->huge)
>+	/*
>+	 * Only set the large order range for tmpfs mounts. The large order
>+	 * selection for the internal anonymous shmem mount is configured
>+	 * dynamically via the 'shmem_enabled' interfaces, so there is no
>+	 * need to set a large order range for the internal anonymous shmem
>+	 * mapping.
>+	 *
>+	 * Note: Don't consider 'deny' for emergencies and 'force' for
>+	 * testing.
>+	 */
>+	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))

FWIW, SB_KERNMOUNT is broader than "internal anonymous shmem" and covers
all shm_mnt users too.

So maybe "internal shmem mount" would be a better description of what
this code is actually checking.

> 		mapping_set_large_folios(inode->i_mapping);
> 
> 	switch (mode & S_IFMT) {

Cheers,
Lance

