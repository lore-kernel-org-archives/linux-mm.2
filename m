Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561DFC98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281C16B0092; Thu, 24 Sep 2026 02:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258B46B0095; Thu, 24 Sep 2026 02:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E536B0096; Thu, 24 Sep 2026 02:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4F7A6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:53:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DFC616028E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:38 +0000 (UTC)
X-FDA: 85247740116.09.ED06A43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7B05C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cg0AAlg+;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/j5EYytItjUwk1/CqHyOHSfaQ3+6rA1AecV+p7hbPA=;
	b=mPUkMYqziB1A4KvAGtR5Pw2YhzLu5pYYYtRMhHjV6EDIi8VeMy2GLM64bJCEj+0ZOKjgWE
	EIE18Ahchue0F9zzR3jRmJYgBeBUS5/gZvg7+JT7yvmWiVSTOeNhD4LaHC65s3mDjx6UQ+
	7sUoCrpzSUAe+xaEEZpM2BAp+YfqIuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232816;
	b=D/hoWLghY5yfm4d8bwK2Q0gTXueek0f749jaHFb6c17ZbwlTFvxedKPTOcg3JjJ39YoOWG
	JV/9D4HxYJDrr8pMCCxIL+0n/lSon63XqIpxcURRwnb5fpAmASrjc2CY9bZ80t6KR4FDKG
	jHVxh22a7+i1IX852iadIlE9H8SgyTI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cg0AAlg+;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h/j5EYytItjUwk1/CqHyOHSfaQ3+6rA1AecV+p7hbPA=;
	b=cg0AAlg+T4e8SoiFKy7kbgHE4WwhHAIOPh7rQw79WqiqJnp+HXkWJ1xhCtBw02dOPuFOfI
	gt1H/3J6aybmE+59zcaSuGMQ6dE/Ylt3oyc32/svFZWWGrcbUvzAS52ZmPUx7K2wFdt1T5
	f5D+21IHnYeqnUJG4AiC+6S3uNl0aLo=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-fl1pLaNQOs61o_kFGipF5A-1; Thu, 24 Sep 2026 02:53:34 -0400
X-MC-Unique: fl1pLaNQOs61o_kFGipF5A-1
X-Mimecast-MFC-AGG-ID: fl1pLaNQOs61o_kFGipF5A_1790232813
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3a35015f2afso3927261fa.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232812; x=1790837612;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/j5EYytItjUwk1/CqHyOHSfaQ3+6rA1AecV+p7hbPA=;
        b=f6SsHG9gRm2Zo2uPZ/+LocYn10nGVIRZBOU8i2cwhqcHu89QCOGH2VzMmsZpS85tOr
         TXOioWqGqNVLRfU4QQDAEyDDu0quU+HEIgUSUJ0Yy1H1wnz0Wv0Y3LkVYerw8e6NgFh6
         Z0UcohnN72bkDNPg3LT89aoBVvBf0n7+ovK3Ag7yuX720rdxWKLP0qS82lDVgm+eUMdA
         CX/w9zNZLex97G84/nh+qeLQvJLqz+speil0/IDq/gLi01zhMwPSfECCFebst3LqOfJg
         mHLX3mS6t+sK7PZFHTHpmcAEqlr4f78Ve1s+X2SES8nmybEdFE+vw/93kmRyP7prSGWx
         saOQ==
X-Gm-Message-State: AFuF++lXDHDphfvvrfnzQvJ5l13bDUF4i+ZS8UzxM3JsAvPp1shSW4L7
	fccWP4i2awC56cxy+VB9oOgpvPhkHL+9dqmbcoiSVy4GjFwWCnWSRtWoOgFM6ZCkS3nfat/CRV+
	DPK7Iac+sPJgusDIrI5oHYyFTWcq4X7/De6dNlVod7qmvf3frtxVaPzJE9KkB+oJDiHXsLKXLNn
	+G7jbIDFRAj/7V9hVCXTe8iUpwZESZ1fWSMhN2tQ==
X-Gm-Gg: AYBFou2TVeAMIT4ENn28P23RX4Y9f4QL1LHIPdGAbOqpdvNkqDeyG8m0UcG8oh48RiE
	oWoNolH5v5XuvdOVZLJLHzpRkwIvnXKm5QPY2DUHNjbF2yhB7WgkbHNOlFWLTndwiZ+uvtprEx7
	o6xDzk8c21g26M3CuZyrt3LE7wm/OQNeLhLJc3BrdTdBK4ZfFtFRlFaI4PMMTB6yG674vt0O9Na
	RPRW3XInC9mdw79Be58EyrlzUsA9XFk2zS3QJu1tj/sbnrs8/HTL/WiH86Vau8I0JO2LSv6CjhI
	NFub4QiUlOcoIVuWlvc24rRHXFLXUlLxmbArs4rMIsEDjpugdX7NRfZpfT5rycz7ydRQD8BKUWs
	D/vrr0utTfeJepbxzDGHZ
X-Received: by 2002:a2e:a593:0:b0:3a6:d50:e26e with SMTP id 38308e7fff4ca-3a63bf1c44fmr3484811fa.2.1790232812435;
        Wed, 23 Sep 2026 23:53:32 -0700 (PDT)
X-Received: by 2002:a2e:a593:0:b0:3a6:d50:e26e with SMTP id 38308e7fff4ca-3a63bf1c44fmr3484571fa.2.1790232811952;
        Wed, 23 Sep 2026 23:53:31 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:53:31 -0700 (PDT)
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
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v15 01/11] mm/Kconfig: changes for migrate on fault for device pages
Date: Thu, 24 Sep 2026 09:53:03 +0300
Message-ID: <20260924065313.899730-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OPLX4daEFxHtstwbTnvP1kRvG0t3KyHPep9jXW9JtWY_1790232813
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E7B05C0003
X-Stat-Signature: dkktuccqfjxr5z1475fkcuwbunxq8qh5
X-HE-Tag: 1790232815-330643
X-HE-Meta: U2FsdGVkX1+PavaeyewkJODIkoDAB4VQSwaobeSXoaqaBtldj52XWjXJuLPjObZL2czVif0Sg/KR6sPgLck4phixZjbkVpHRiHinWu134MGsT4opwmSuyt6kjUabXQCkIcXHPNuPCIEyZMr2qp4+RZUf2hp5MnYG2v8+XzmAywF+MKui5fSFNkanT1wm533y/V5OaYrTRyfrecP5L6MvKZt9Ol7LEVgDhuxSMwiK0P/BUTk04TeNJF/Rbp/pKAtuH4VBELQqNOplq3s4zL7yzKX+xf/gdFlD7Mde0lUas0mHsa2zL8s2SwnmjYAQYadJNQE5MeqJ1qylh/CqnKKAkthDBXH6ZCGdZZgtS4k2t6efpJrNhY6s28fAi/H+HXi4qhRd2M65DT1rH4th5WTo2AdPBYbVSoTzKTG0RlGXHWRoIwvvMhXoAuBzUq0lWZk3A5UYZTI5kEquTrXKqUIgbpMcR8HjcBl4MVmMuu8jCqEcIqDEyUll/IjiO5eKmkIOOAkcDSSE5nDkG331zcAhn/xjEkBUKmYVVf97tgOT9B1ozoyhPPg6suWow+P461YVJ9b1dk4MLkoPNGqLe3pGV7Jm1gK/UCOEUnjnYluB00kppJsh3kN4mbG56jOR36pNFPt2p3xBVLyTx+Z/WUjQGKYQgqqOMEtETdpKoRKHwm7XWAUNHV0PX9V7Z18vjkKvxLaPnLkGqxXVuXTPlb5my+dYsk7ChqP31NIwGIok4eecGAytdcuFyYACYaPerNcb/xS2fvaalBDEQO2ooO9PcHKVmWpdHOJ8RGcF13x0JLDMcTip/sWyW52P0YmSxqT1KzaZx72lQ1KNms7TMOby4vf7zZ7/TvGbhWWYlYurAAfhEAdu4Tp/9l5eG60z904k7sRkCCmMMoe7tNvK83k0deWgRDV3fPTraeCPqUseC053GEKOnqW9Koz+omgLlxz4ylA5bVZbTvE+grynvUk
 faZXslaE
 tKOAArIKVY+JDhiDWrary6GeXKGHzq56VW7SwiYXkvvmI4QKFwEU2/2LAvTYSd6JBuFsba2iYl1VYq4B3pXqwddCTllVPOcr7uT1aBA5vycN5cif76qL1M6v0VDrWaqeBV8/DBvckELZ19su70CoTvLTrbfy5tYi177uIQMIQ82qQilDZzizL+SxqeXypqQvkdYOoWxpk6bZOyEiv181bRZnvYus+V3o+5LYhJtmFJxBDUFuHoSxSBv1M5sfgMLuhGCtMraDhe7lEgQgrzHfOrdFZkZ4Lxa//x+X5WhgvvLLHLSkEjZteq9+hlmmP2jOcBtrN5HngxQG+ShMUQ6CbWUdJ4NRrDrwdcIILQOReFjgxUgwClnMdTVIIuCqChPU7b5GkCIk3ptFSF7LXKP4k0FuUzHweW9ncaoG22MCUmiAHzU9LppHWjx+zzvk0CzCUP0YZxvQbNAKQRo64K5tSCqSNTGV8fK1JLzVGFeAk6TNis5y/+yz5SDZpOgmIqjeQ7Xg9VkQ/N+E3pmFdcoLpvBy9dlVkuagKMyJnG7BGM4K7nBjEYnvUOon0MsWWGP4Fp2oNT+vAREWQH04pWstHPpBXT8zFu6J7NyAgkRV55qpcMA8GTDlBPEyDCOZYFetvCrv6
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
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..b7a485beb9a7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -687,6 +687,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
-- 
2.55.0


