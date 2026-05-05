Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDB8CD343B
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 18:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86986B0095; Tue,  5 May 2026 14:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0FB86B0096; Tue,  5 May 2026 14:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF1C6B0098; Tue,  5 May 2026 14:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA0FC6B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:44:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CA02160666
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:44:56 +0000 (UTC)
X-FDA: 84734242992.17.40A751D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id EAEBC40006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:44:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CJziw1ci;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778006694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=1KI+hnXzz5ptiR44KbwE0dsYhwU3FqOece5p5/9thOmZVnVqxKlRNuc0Hxz8C7KNHLvpnS
	5L2NsIuktKSaJQSEBQwcW77F2lf0Wx64p31+sjgM0uI4Qez+fsAB0msJa2BfKrrVrJKUVL
	RlxVWGKipT/BdC5x3gxo3l2A3vxhgSw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CJziw1ci;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778006694; a=rsa-sha256;
	cv=none;
	b=Om4Af3iz/QYCBgV5+HeSq7A07to68F1T4X4V5ANh+XugUlCfzbjK3TKweomSiS6omIha1K
	lDDx7W5zZl4BePt3O8sGWgiGMOoeE9S+su/OgTu/txWEpy1BS1djm7NrxAJjx0JON7T6HA
	lzKi0yHz8+riaDPIs+6J3K/UH+JFRNc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778006693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=CJziw1ciPjfRtDVwWls0ATkXzN/iPFMJZywvnAyy0j34iqPfIJka8z+HJ4adj9gzDVQOdm
	4Wz0Fem2Rjy+iQoDPij6IZR4yV9TQfCxhXZo0m/NT1eMSVPNBIlw5xWq/G/Se3oXNicz9f
	3rNBLtHO5/MQurwzxObQSiex0beYI+I=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-9yw4HNP6NbeZEeE4dGiEIA-1; Tue, 05 May 2026 14:44:52 -0400
X-MC-Unique: 9yw4HNP6NbeZEeE4dGiEIA-1
X-Mimecast-MFC-AGG-ID: 9yw4HNP6NbeZEeE4dGiEIA_1778006691
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a880c25d05so887550e87.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 11:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778006690; x=1778611490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
        b=VgIEPQCkZb0IqJFqQE3ffnkk6d45ToIkJBM76YukQDXRVmILvx955lGL4m7MtRo1k4
         IWnU4IzJZRTgJIkNBWteXkc/wVOMJsM7x58uQX3mECluSGI68bLtuaBIvxJDsdDv9+gc
         IMoqIhuw7z74Uy1XUIifnfYlEE8Ih6islmo4dVBhx9DbmLPq5EdboKMYvx3qbIKIFe4e
         /cmPNe+2s9usqpjSDy4I4jijuPNcsPr1ErX6J+Y3S+qgpAB8zRDvzAbBL544zkv8JT4y
         Sk68GmK83KZLiaHobIOLXEkFd/v0z4bAPyMZpwkds8BO7xWrt/gB1OmEdmds2VJxOM/I
         qukg==
X-Gm-Message-State: AOJu0YwDUH1mgFcu/BBqCJ9u1iC/yhGeMXuZD/znRDVyFE83DW43f2/D
	n5gy/oRUkkVDKlyVOwFPI4tQHIADplbU6ztgNZLpg9s0EYeUI3J0gctQM/cL+Y8WcyLYMaY9FPn
	qhPwPYnC+6al5pB2tSOLxgFYlbrelV882zcMyR5tU7ub2Lzan7+eP2GuiU1j2PtARX2HMEmY+3i
	GoXezhJy8RjygJu13icWJ00sBWeQVVuaVGfdpbbg==
X-Gm-Gg: AeBDiev87hgbNm/9uc16MdK7Cc3MjcO7N0xdZl71fvmyfwfL5QgrT++P3QQWxodYcXx
	s8EASYa5csrHFQlToqgUjIuiMbgIzEep/OeWyjZm7yJkzsoPFZ8T0MgqHUU5ds8tZuAA+GQj2sn
	tgptrhr24I1jb8cM+YnWPfAgPDDAX7eScxMOY4AdXUxBmLjdDMxilp564LCnYvYHiau02fQHCRA
	+LpeuffY4ZHTYp10orFYkMpToMPwGNvPeA5v24tCfk27OHYxoSklSsYa0BDHc3OM2ASZIkIty9y
	GcmIMct9d/TchlNjvtCwc4R6vGg0WAgTxVdc+0kNanjOnI4oMY3wPGMSMgtXWWMd+j6/1pZjPu3
	eh3HJbeHJbyLvURz6hkvA6rweVUsZAFcC1w5kNTGiaOBJqhY=
X-Received: by 2002:a05:6512:1241:b0:5a8:638d:6f53 with SMTP id 2adb3069b0e04-5a87f1a04f6mr1942779e87.6.1778006690487;
        Tue, 05 May 2026 11:44:50 -0700 (PDT)
X-Received: by 2002:a05:6512:1241:b0:5a8:638d:6f53 with SMTP id 2adb3069b0e04-5a87f1a04f6mr1942737e87.6.1778006689860;
        Tue, 05 May 2026 11:44:49 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a86e65fdf6sm2504437e87.78.2026.05.05.11.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 11:44:49 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v10 1/5] mm/Kconfig: changes for migrate on fault for device pages
Date: Tue,  5 May 2026 21:44:17 +0300
Message-ID: <20260505184421.2324798-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260505184421.2324798-1-mpenttil@redhat.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 49wvqgGW-9gcoEmxbzD4ss38zO9s-wauJME1Mm6dP1k_1778006691
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAEBC40006
X-Stat-Signature: xiwh4k95kniy4tx7re61pn7zukjhezyq
X-HE-Tag: 1778006693-33009
X-HE-Meta: U2FsdGVkX19PkFAjaVyuwYPZYFgFUY/e9vdhqAy4Re/d+EB6uaG4xUmbt4woPSEMA6MofbvD5tGjo0F3GvwvXOqAZMrVEgypl+xQbVx6jExPQFuihqoU5/7vLf+EPg1t/RAm1+hqHXtrIM8//mGf+nsOfqxeorl3hi5rBQP/qx9ANsR+MBupJte0D+4xdHIot4iCGfx22rCHti82WyUwtxeUoAPYgflkCgcez59JobHFRxmuAa7aOyDzHfPY3pXx448089o0SGwlYZYzqp8aFtYuiHlnrT7rPIywCvRcgqgJOtE9geuE7eLQiFgCeekywWg2ITXmXGHm1b4aO+qKhS4Q/D3Vf//F0LoC8zKcn7fYezAk44Vsu5A/rj9aMqKvdkpLo8S4YTei8tSYlrbBj1TA2r+O4BRiZZy6SPoReHbShguirowCkDtCdMhWcGrFz85F6Br8pABn+hXwc9SjtousYsboONfy1YY1YPS44QKZd79PTHCDYIDYDvqNAV1cewctZp5ZNY76U0PXeww9AomUCWMXB+JFfN8kQRcxAzUXOlZGHohGpn8rv6GMuCqJeCv/FrYl8JhYe0ESfnM3W4/d7lmdemSKdnr/DXoOx7/S97yJhjZ7TUwmiul4o/L+0zpq9MohF0jPCiYINvd6UWSVTGg4RW5nLnOXyE3t6mnwxQJ2Vv97rOd47y9uvJ5mFmz4aaklMIiW1i2h/VRgW6i6JqngjXPHosqW+tse7qpFjXHO2PKkzc0o/SfYAPBNnj3WHcYMpkygxHmFlVM0WcrmEpK/kY0Q6awnwIt9NMHmoB8d6vThPwn8dYSNnwgJ6oMG9SklVV+n5jRKAdbKhom2VQVc08se+IkJEcuSdL0r47eeQlAbbR7D4039nbaIfCQ/9Nhokh8N+qPDAFPYAr9c9/tM0Ix3tfu8OlF6hc0tvhuedjddetbywwTfGhUPywiRn2/g8d6Ncp85Pmb
 1aU5igYv
 YkypqHYz+7x7FqoRIVlWzzfRAd+ogCkK0CKoYb1c7Qh2t00MSdfjDh7NosSYJaH/5HcH0yatECLQ7JpgJR+zpav5uMsyyNrvd/y24YkokWseR9CVVRUuzibTvWjT/ys0cHlLqHRkOkQbHbGoV2viPDffas3rSStG/I1IWrGY678a3o9Xno6Q2GYQ5xgiNzv4WAwEoxNmfVe6H6r4wnJJUFii3Y3GBGbfVCx4DuRG42qmqCU/4+Xg6B69fZNjT9EQathpgbg8+/ca0fDBaRYF8OnuKmHlfaFCuNuYeOGHX6cROrcjEMTQrLjT8muVMdZk0rjNiPbllg7FaCifd4VbUeLJ5CkOGmVwm13iFgjSonT+IqrlckJvkGyGOd9qpcoCeNnaBWSmX6YcMAxFMhsLSWQ+zEtXB1HCv9PpBWskEicIjGzqDr3dBW2IlPOolwKId1Ozw2FM8Bo0nU2VvaeUb9oRmJC4Vg6EVomN6YEBH2gKyby53CYzdhxq7yxaJysXInffndRwYzr8s6c4ykFwRVrA9eLcy5kZnEqWSz9ldCCCpCxcV0zRBGsA1YLM+QDhAyHuQ7jcFEXZ/tonH7EYiJML8dhsjBAmk+T3SwezaOEgkYCP4udYvL1aNtHjCKGyrdupzL2Z+fD1tqUIkh9Qx7PsQ3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

HMM depends on MMU notifiers. With the unified HMM/migrate_device
page table walk migrate_device needs HMM enabled.
Enable them explicitly to avoid breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..0d8db75ffc23 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -646,6 +646,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
@@ -1221,6 +1222,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
-- 
2.50.0


