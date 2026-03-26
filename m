Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F301210A3D81
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7796B0092; Thu, 26 Mar 2026 08:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF056B00A5; Thu, 26 Mar 2026 08:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C566B00A6; Thu, 26 Mar 2026 08:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 317206B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:32:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D004CBC68D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:32 +0000 (UTC)
X-FDA: 84588152544.02.4C636E0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09E6F180013
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ENbXfW5J;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3XSfFaQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3XSfFaQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528351; a=rsa-sha256;
	cv=none;
	b=AJaz5pKlo2BN9srYxIBCi5FwQZw6cmoEl9BWEEgz+7sg5nKpnQWaA02MqkNqhiFp7b+k9v
	27b80hliLHzseNUn/IoQgWdioIe0V8zAhW0kMHO6bggfftBRoywOX5xKflkmNnJ095cIn5
	e+tNASOZ+NTYZAEmBUVp4Ab+aaKy/T0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ENbXfW5J;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3XSfFaQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3XSfFaQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yH9b1Z9LWNEOI2+GECgyejSXeUsvyBElCPTE9tOWLWY=;
	b=8lhwVg5noRc/WkFBOfrhq6cc7dGqzHcgaCRJ4MxoqoynnOPbqtzRLtQbEzdZWrtikD2LIB
	foTHNE6KTbbsIm21cXwV9rnpfI2DGInt4bptM9hI/3oSQuFEj6VyBK2yuvdBeCnp/R+6A2
	bgPoOJ/1FPb+qlkvCtPVAtKanujEthc=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so7924905e9.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774528349; x=1775133149; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yH9b1Z9LWNEOI2+GECgyejSXeUsvyBElCPTE9tOWLWY=;
        b=ENbXfW5JujHBo9htEkvRDdjfI6mCQi/lPPVHxUcc9kFO6zcoHmeB7Z0JtLhgJd6w4Q
         j4aVl3neLWLdpg3NC7jQ0DbH0EjLntQgQwhWuFKV5Bbz7jtmcF8aQK+fr6d0p+t/PVL6
         WhRN48D0ww5s/GUCWCsg1VOdOHmhpiB6D4E/YesNhfIRqtALmyjQFYypIXXpSuOlHLuz
         PcU0Zx/79pSN3pm0SIFJ2J7r2/AGKi2UHy4MaDghuLFZnIiP9giiwZwk0oG/51vhIyo3
         HAFKaVTrJfRzsIJLu9DuvZdEWex+R8NNcV4WpucV/b6tvkLHzv8u1iE0UCNDpm/3L71+
         xzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528349; x=1775133149;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yH9b1Z9LWNEOI2+GECgyejSXeUsvyBElCPTE9tOWLWY=;
        b=L9tui9YullMTMolalq8wcQHp5KxcaDx/6bjlc6rWmgWxk/3kFmZnfaEV9/DZ7FlnFu
         vFQBPsa0+9OAezRlQben+0NSXWefJLl3IDSguYZHlP5O9MfHH6zd8zvEQzgrm0JZfpt3
         slToxIHtijAfbtFjKpa66QR785Hnga6gLfGgCc0mdqTa6jDLqOdlS2glRTx30pON3HCj
         hIQjnTc27sKwjKzNoMHYxGjhTN2OH7T3CpORXiey6crne73egaHicIrYA7sO0dBD4IAb
         7w6D4bBhoEfTb2yFFpuFzLv3/SmD9g1tech8fl5f0UG2mVTm87Om4nYrpNboanGJiTWr
         r7cg==
X-Forwarded-Encrypted: i=1; AJvYcCVQa8YHMYoapvYvx0jMA0nXEiF+vpjln9MQGXi4pTDBTgXtnAhLXkEhFxow+8Zk57Wk++yTdODTCQ==@kvack.org
X-Gm-Message-State: AOJu0YyEE/mkPxl88FYlImbxhs6u7tE7Bi3IhISNy8AajzoqeIMS+kV7
	s9tzxyzvjcYvRdpWYuKFATi2RhNOwqNoa5kr7orUSKm/G2M606ZnMJTrQXJ62jSrubTrQpvRcgr
	hlU6vOknL0DE/HQ==
X-Received: from wmf21.prod.google.com ([2002:a05:600c:2295:b0:486:fc75:1429])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c177:b0:487:2e8:69c5 with SMTP id 5b1f17b1804b1-48715fe2aa7mr107288655e9.15.1774528349254;
 Thu, 26 Mar 2026 05:32:29 -0700 (PDT)
Date: Thu, 26 Mar 2026 12:31:56 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIADwnxWkC/13MQQ6DIBCF4auYWZcGkYh25T0aF4ADTtKKgYa0M
 dy91GWX/8vLd0DCSJjg1hwQMVOisNUQlwbsqjePjJbaILjoedeOzLu9l0zpUXE9cKMlQv3uER2 9T+c+114pvUL8nGxuf+u/kFvGmbCqM8MihVFu8iH4B15teMJcSvkCegKY1ZsAAAA=
X-Change-Id: 20260319-gfp64-7a970a80ba4e
X-Mailer: b4 0.14.3
Message-ID: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Subject: [PATCH v2 0/4] treewide: fixup gfp_t printks
From: Brendan Jackman <jackmanb@google.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Stanislaw Gruszka <stf_xl@wp.pl>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Allison Henderson <allison.henderson@oracle.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 09E6F180013
X-Stat-Signature: y3jysx95h1z33xxc6cc9jg4qtw3re3xo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774528350-411108
X-HE-Meta: U2FsdGVkX1+qPpmqcKFpT1bVPK3x3ZVyLgcYnNX3uPwdZxK3NYI3V/RnztEQhiIbj5d/VrrQnTSm3X2uA7/RMmHAQ0vNMXS7ZIFR/V36y+eh2rFx0Dg5SXj9nC5LoYYPHZo/6iIbUm6FXz11rVAPehvntTVqrup820FzLAuUOPCLJyBSfbvh8vhSQ4ALRYiCuqXpLuIfq7+XxF4Ow8Mzj+Rs/snw9GzQZ8pab4rnzOWg2JnKdkhwa7J3Uk+JRpp3UMcVYr2fn9UyzXZ+ZyaDmZI6Wey4UlekyS0KYJrpoC9sCFex5y6BieixkHqV0D5rvfg0XlGg/0dtovQmXMNXAcfWIOWESsQJSrn3S6qh5/2b4k1JLu+Z2Ocs/dOVikqhpFAPoh4qhWsE10mQiYVaLasYD3/LfpPXlnyXZv2gK8OGJh9GLP7w6U7wO5pUg3TXIRD9RxiXRrAP0Q9zwEsBDySl7DaOAf6UKORmYdNv/P3anlkUiIE48xVZS+EbYnLxmuZc8ktdkEP9Y+N/khW8gywnc0OmeNXt7cPk5SeMpalcnHaHMKf6ySoQsCbEJGgruqJka8Ask/6BtWq7vyiFp5JL5jHlk1n+pXU3Mm4/7pnHW5HuAwMxZqwGsH5VR7FubtFBwM2pMFGz6uf92yIl1PCi67h84YPNHZIFCCR1Sgw3N9LFs9U4FB7/Dfbo2YUnDE4ND/zv4sOPvgLg7DcfkYnIfr32fmxnN7zJvMdhQF0LtHMIISZX9ExuOI2D+MSMr+yLhpnWqHDqvh3X69gauv2aQ+uLgRhWIaEmOd5KCO3o7/u/W9HgCIHmvBOfTyJCwAtYmKz0K+qO6y0T7F/FfqzUFoyMYh0KLerknze5PShc5JP77fO2fcTuAbpevxUDvuPPcYOJNCnXDg8z3Q+vZGWgzXC6CzaraE71WrX3xGGgJzyk6pTNL9CETj6Nj4PQG+dKboEWlvkOuQlhMJP
 xfhgf4K0
 RXChsaALE0OuQSF2RzpZ+EvpqDqJyIaTEgfELx5tusL1JcYVC3Qt91kLHa0XF4NxdXKRYblhmFmsIWA7d7AqU6FXMwcVG9dNRKjGvdgIo/U32MaUxQ58A5e0pfhVjOUeEu5uSxOOreaJsMyRdfRr8AAv70Xs2Dm03YI+pXIsljK+0jNASv71PXXnBVMbAslOH9ixlKc9Wp4H+Cf09+DUet0p6cGnDzJx9ZWpn57GRJJuVs2n8WKfgU8FnNHD9YzZPkR586py31iJbpBJhsqFpxN7f5Co7IroLajXn42N5icVk/T4jS8bYtBbaT+QtFtgNML16RdjbCVmNQ5xTdVGnjREI524WyaKeQXvQSjoVwfnB09BmtZ2BvYr0F1c6DNs+a+zy+4Mut8jrKuGRSqdVDU7tPWoMuPrxyCFk/j+ZklE5qqmxdBRVLSLAZaY0sYFPk6vXiCMh0rRdpgrJgqpZVtt6nkyP3u8xlbqlTN77gymEISzMdTRP6Cr03sXgix1AhA8DPGKMVf5J5+TeKQ+sNR1kX5PtrHPyGfY0hEbABwDfeOac9NRxptCxGI+JOiQ7arrQSEVN/Ymynlw/MgRcFBBsTgEA+ejTw07Hd8oQJvzbTs4m2cPpf8+N+cY6ofoy+OggOrdg+io/wCdACTT1CI2EF3zxSSlmWHtJq30em2DTYHtLPO1hgta8+O0gfEKA/xi7un37Y6qYi17bZCMc0mldyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset used to be about switching gfp_t to unsigned long. That is
probably not gonna happen any more but while writing it I found these
cleanups that seem worthwhile regardless.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Drop gfp_t changes
- Add correct CCs
- Add minor fixups to preexisting code spotted by AI review
- Link to v1: https://lore.kernel.org/r/20260319-gfp64-v1-0-2c73b8d42b7f@google.com

---
Brendan Jackman (4):
      drm/managed: Use special gfp_t format specifier
      iwlegacy: 3945-mac: Fixup allocation failure log
      mm/kfence: Use special gfp_t format specifier
      net/rds: Use special gfp_t format specifier

 drivers/gpu/drm/drm_managed.c                  | 4 ++--
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
 mm/kfence/kfence_test.c                        | 2 +-
 net/rds/tcp_recv.c                             | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)
---
base-commit: c369299895a591d96745d6492d4888259b004a9e
change-id: 20260319-gfp64-7a970a80ba4e

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


