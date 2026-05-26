Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E99CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 05:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DBE6B0088; Tue, 26 May 2026 01:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DED36B008A; Tue, 26 May 2026 01:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4936B008C; Tue, 26 May 2026 01:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F79D6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:54:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBB61A02B8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:54:06 +0000 (UTC)
X-FDA: 84808505292.30.EED0866
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3443B16000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:54:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmlzAICY;
	spf=pass (imf08.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779774845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RC98wb6cU36LgWLCbGo1vO3EVKMDW2tOzzElJwX+SY8=;
	b=6PZzlYc40BkqX+WaSG7JTmXlCSMkZbF9sDftqQtM1ovCd5vXayZMlLdmZoGF2/t4k64qrA
	cQvPnxyourpooHrcRfgLUZo3rSef7+Pi14wVgNTGu0XBM2y17KzfP+xZfxNcNsouwfDNb8
	RlhNgbptZdWgwIjwO/2PXprn6jVWT4k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmlzAICY;
	spf=pass (imf08.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779774845; a=rsa-sha256;
	cv=none;
	b=77oI6r1GuLwz3N1Sazitw7u6czvLq8QrO43Skg5Inn12mx2amN1StkZR40GtGmRXKIDxUk
	W4GMIBoL2Nm0cU2n9C0MdVLuax37WNLQXFaZUpsCQjw15fBon8x3BWGRfWEM03jAguZXUW
	NpzWvbI7LezelKIQNcUGQgajJ/Wsp9Y=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49050bfe053so2224875e9.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 22:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779774843; x=1780379643; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RC98wb6cU36LgWLCbGo1vO3EVKMDW2tOzzElJwX+SY8=;
        b=nmlzAICYp3Ba3wBO3v5sZgvBRIrXbhnd2PMdVqzEfXIcl4au7BsRZbEcT5RA5WgJNa
         ywyo4uU3oJWDmCfm7JnSDIN7qt032fZMrSVzlfWVUEVKTXauUWErRqSQ+YAag4GpcUzV
         16CTt6PwAthFIZDlK2zAvlZWEkRrBhvnWXe3fLbT7GBcgBS7xLihCgsF74DYU3o9SrY/
         y1u2/8FnmiEQC1Bmz6ulPCEmi8w58JGdmNT1eY2L1k4HxFOKMST858javkQe6Y99z3DY
         xCwhs3OKiG7ZPwmAsh9f1UcNU/GlErH/Uu1yc1gQfNn0f7GdPWLSjkJHREdqjhYRonPT
         0Lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779774843; x=1780379643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RC98wb6cU36LgWLCbGo1vO3EVKMDW2tOzzElJwX+SY8=;
        b=F+sJVGYGoMqxdtAOPECKb8lLPsd6RTswI2cC4Cqx7kR+1erJjM8DvifVgfP5CqeNJ7
         JpYK2QqY2vjoMkD8+ta+1uYFxr5ViF7EaR6Kr85yq9e8RCoTppGYXQx0PLQtuoKlwhfA
         1bzP2cIsmvxteyoYZs2xZ2PPGaFqy54RtKpEUIhJuiSB6xtVbzK74DjpIuzS7OH7Zmz4
         Ye2wzLVfy6UHYfp/dRC+wVsfRTorWlwQFRG1RJ2810zFI6VDMvnVhyqEAZx8K4sWOiMe
         PmElL4f4I1E9fmrhUDjKvP/N0cyzqNlieIE2b0ufcWORnEjPPIi2ybmCwX3WDUyRpm2C
         rmPg==
X-Gm-Message-State: AOJu0Yz4/uQjWYQ1qxiICrxyr/FxMmm06NH0WvgJiEhmQw/ZLQVEgaav
	2JzjeGCbF1VU829Xmgtco927EfaKBd8Q/d7noJdexi1JWZf+J8HECmAo
X-Gm-Gg: Acq92OG9PIsA9gtGwoJCU1txmoofuDwl9oky3JQ1B9je9Q91haTj+9+246lAtiSu1HH
	uYXXQBpCE5qnMpffj6Zqc4vPSJ8uNi7jZsc6srKjn4hTmFbKtXnyteAN13ixxXEojUNdbu8pfUl
	S7LkiXgF98en/1wwxOZgTvemJRQJkNNkQTAzAMPj960CK0d05gpzxpgBr1Ue92H3ZMH4bl0LAhU
	DkJO8P3fvjklMxOVjC2gdGebs7gLZLXVIQh5f1RVJy6JS2XJ6ShGGtIaFPky05PRfhx4gzYWGQH
	7o9nTvuJGvf/rpTqUb1kn7T8fUDgxsTJxVfZ3xIPU99O2YtqDy71ji6XaEfNtVLzj5erTsdpfMr
	j6fpD7bEb+69m9Fn0wFKLSDPUqRPjk6tKwM8yq3kU/hUJVPe5Xz/kJwm02rJtVdN0LUj8VexaoK
	3CM8YiomLVGEzGDfV9PdYTEjR01wou4sdrkji54JvxEzoGhb8o8fImRD1QOE7KyEcs93reaXfN4
	qwdbxSfj6dL9AjBTKSp/g==
X-Received: by 2002:a05:600c:1c0d:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-490424b3927mr313992635e9.9.1779774843281;
        Mon, 25 May 2026 22:54:03 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d48e23sm31544499f8f.20.2026.05.25.22.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 22:54:02 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Keith Packard <keithp@keithp.com>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH] drm/lease: cap object_count to avoid order > MAX_PAGE_ORDER warning
Date: Tue, 26 May 2026 06:53:59 +0100
Message-ID: <20260526055359.17392-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3axcp3kei4ze8mcczx7rzrsqdb4puapq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3443B16000A
X-HE-Tag: 1779774844-626233
X-HE-Meta: U2FsdGVkX19VzyNCVhREgFoKAsEC6DdUznOUAOxjUb1pxxNWnFD/yMoMd9vEQltKkwX7u8SdidQLtX0j5T5dLYMUJIl63WADbMPAvvfgdxtkE4rx/w/H4hBGV0VyhhhELe5ix+JqtOcQMpxGyzl2GaqJUC3dRI+2jVt7ASVQlkcfjsVRD6ZXzx4ARyKc4lAHMMDF3SeLVmNQ6CdwH49nbnvMtkhoavEbu/LwZfy8T3Vk4MKcavDyJYCfIyUh2mVYImKqip3V6wSTJXp43ywcfAapSftwD62VeKsoqAD8FYCfgiI4Zqlxz7zTD44sPwsGubPEXSeco4K78VAc1SseyraJXDftz4tFN0evfn+mBKEyRlPP47CdcAi680Wua2Bvv6MqOiq/WLWn457lI09x2yWuxuHahTz2Z50arGdBxgg6trdJI8APZJJ0u99hOlglLMGSAB/sACLn9VOOG/8KB2tG/X/JlYnBvpuYZNvjwzyFVBReSNK2KYoyXkCszaHph+Xc778N4pVRNmbqnOgjOqKxagC78UoYEJzBS1nLyvIPMmBfUswNHc056Lwr3LHY/rRwh99Pq7rf8AS7o0Hd6hn4TtJKH/e67dzqupZ25UqA4WOmE1ACArQbSIM4NfIXhLlHEnyVuIkucDdSFzTwhBSsYgE/0E1+53qjZjjrsxaRHtiRpLwOByLUtIbKF3c82rkpUMswJcUm0lTAT9OL8ezhF5UyEtxVCa8pCZ6vHVaT48tRMCHhD6VneAsLfDH1vtk/N9bW/rX4VjvA6++zZ1NoaqnHN1QLJZmQktOR1LVxgrVUWX4Z4BuzqrRKWYoieZ2zA3mSrVwDBCJKeLu5d920n4koHv7DXMZMXu1XtFMd2Bm03cWr5OWKXyUjdeUNmXObD5IO3Jae7FR7JfKIbEPBbP+/D561pl04U6JIEeRd147tjN3A081sKR1rMbn71TmuqsR1ZJULIPkbfii
 co33e2xF
 c4Y6vseWaNdnb40A7n7yy6cFoFeoPvXIyPcdJ6PmIlcswEeL4t0mNSuVLR3LpW1is4S3ElWj/ErO8teaENvlccZGh3wcyKot9p6AaYi6NUwdK6sC7dR12dt+3z2IbhwDSkC3NsYAEZ0jOUkDXBNbIfF3omPFWUlbaeXmjmJ9YTj84rSaH0P4qzyt1ejUfsWwCT98ZQGjHT573ZFDf0Ve3CpvD8faHNwL9ydypzdBY/ltZNKwBFqll0pi5H4SeEz0dH5/F7wP7G5tLXwGpm4OL3aCqG4efxbvgDxG2Mx7sVOJ7BUlEti0mQ0cMQSuDALjQWK+l3VVDO34Xi1VePv242ayfoGxV+R03NuGzanTcbn3FoawJfs9gYsvsJwnp0KkNNb0CkES7bR/Yqbnts/PbVY5gGoPt+8WjUaWXmlTsXMR0yni2F5U1Ze3FY5Jdu9/NfjszUc93Scpwhg1HDHihfs/60Ur3pcK0e7IjNyW3vSpSs1PLlOmak/JwTM+9pahF6rbcvJMw80+R8TDydSMe68NUqFJUsejEKoO1TviNmibdVp1EVAuGvg6mrSXsjk5hBNTimJkv7YCmuH8/0ELMYFnafvSqmJDKxA0qVQCviIrnhAjt3BqTo4T7R5bh15DPWVZ+T2LjvrS8ms6zhouMRZ5ZvbMVAZCfZ7snOOccCfJsWA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cl->object_count comes from userspace unbounded and reaches
kzalloc_objs() in fill_object_idr(); a large value trips
WARN_ON_ONCE_GFP in __alloc_frozen_pages_noprof(), letting a DRM
master produce a kernel splat.

Bound object_count at the ioctl entry so the page allocator is
never asked for an absurd order.

Reported-by: syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d32c8bd82427f9c77cc
Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object leases [v7]")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 drivers/gpu/drm/drm_lease.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724cbd7..bdec759187d9 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -466,6 +466,13 @@ static int fill_object_idr(struct drm_device *dev,
 	return ret;
 }
 
+/*
+ * Upper bound on the number of objects a single lease can reference.
+ * Real workloads use a handful; this is set well above any plausible
+ * value to avoid kmalloc requests that would exceed MAX_PAGE_ORDER.
+ */
+#define DRM_MAX_LEASE_OBJECTS	4096
+
 /*
  * The master associated with the specified file will have a lease
  * created containing the objects specified in the ioctl structure.
@@ -505,6 +512,12 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	}
 
 	object_count = cl->object_count;
+	if (unlikely(object_count > DRM_MAX_LEASE_OBJECTS)) {
+		drm_dbg_lease(dev, "object_count %zu exceeds max %u\n",
+			      object_count, DRM_MAX_LEASE_OBJECTS);
+		ret = -EINVAL;
+		goto out_lessor;
+	}
 
 	/* Handle leased objects, if any */
 	idr_init(&leases);
-- 
2.53.0


