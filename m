Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC8BC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8030B6B0169; Tue, 18 Aug 2026 05:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3BD6B016A; Tue, 18 Aug 2026 05:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2796B016B; Tue, 18 Aug 2026 05:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA1F6B0169
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:24:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACCF9C0BC7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:31 +0000 (UTC)
X-FDA: 85113854742.09.6C558B3
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1204160005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3W+6SbQ;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A1pbnb70esMHiIG2GjQa1pvwn7zF1O2Mpz4YdOsewSo=;
	b=b4lLQ8EtKHPKIgzGC9mytEvp6G+oH5UVK7Fw5gA2QQvXDYkhHBVDLgSsvV5seGTdvdwgDa
	BDam/xpk+QOU82siaPQzaJeJ0hOFfuXney86GAmYPpQhC/dwimoUYYo5gCQoVsVTf4fN1H
	brKcMbZ7tUGrLXH1np36fJC5BvEC2vg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3W+6SbQ;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045070;
	b=L62yp6oMyv6+29baSgcA76v9fgdabg3jFKBUNd9J844uyVTnTwuAeERqgCS5FmtLY3s50u
	JmwkcK1ghjW9a8232AdJw8cjU5ZiHS7mLpUxTKSfe3uQxFN2HREI00M1NEj7hT9spGEAFr
	Z+8M2/TDrrOJbY64UOY4+X9EXJuACMU=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-cbb92a1213fso1618603a12.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787045069; x=1787649869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A1pbnb70esMHiIG2GjQa1pvwn7zF1O2Mpz4YdOsewSo=;
        b=E3W+6SbQtr9hW2aS5g1l04lb2HqgfHa0J+IpsKuiUSi90AiAvySWbNV67VElt1PNrw
         1k92XJvk1VE0PjpU14HHcORROx1AMM688tHYQA8JH2vccQp4ZBBwUsyHWQS2kDBr2qdk
         KrHix/fn2Wlb2QP5Q1uWUmwPrZcWs97/QiwgipUycMtm13UdpFAyr2WquE8LIA4WbvjM
         MVNE3OpwendP55sArTeSWn8Qb9SYjddBr9OmCq7+yQmT3AVoJ99ScWkQOoRm/rr6j5U3
         xkpnKcKag+6qU9bkYqOquvyYlUqHyQCAmGytVUN2jhl5WAbftCEEmwrl7AllMD7P2XsV
         O/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787045069; x=1787649869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A1pbnb70esMHiIG2GjQa1pvwn7zF1O2Mpz4YdOsewSo=;
        b=Xtne2I+G6alyvc80M44QSszV7dXPRL8MQPeOWU+xC77ypXxINuPNtklp2Ljz0GeHHj
         Ry0wK7vC/rdgT8l+7P9//F9GxSr7Jofb3e2iVo92uwKv0IaHzblDJWrgQvPxK28w7cnt
         0XdiLgrRQvs3cbIqw2zvJZfcAQG5DV4dZxZNQQudjQQFElgi4pVRIpxC2tOUZV+5YFyz
         tR11JSSObUxiV1FkFeTszDaYXBWB17Y5+VZoF+0TcLswIAvj2uYmvkWs0zFOf+QRr9Ik
         zoAPeLDYXl6HR9jZ6g5+/mC1hDmMWtFiucyob7VAV1PFszXF1xDPdaJkqbCvTTrUQevZ
         ivuw==
X-Forwarded-Encrypted: i=1; AHgh+Rr5koutKcAEL4CFA9BDBSaDux1t46DPxqOCmRoqA+zBfqUpKQSXh8HL7NGTdv/iYQO31aSuVae3Bg==@kvack.org
X-Gm-Message-State: AOJu0YwWxTsEHut3Z2Fa3DnOr6mbvbLn2iL0FnOyhrDI9AhThwapoeKO
	otVYz7nSdcYcxkL2qhgkQvBCHty27iHCES4pGtoGI1ecjZ+LQNkuwAWJ
X-Gm-Gg: AR+sD12xOi2Y8YkpUOJ0997h2P+qVOAuXezm6lUWYh7aq50TmOvOp//BMCMrej6QyEm
	+y/bw+Kb3x6l+v2DFUQNRW+YXnTnB9wyq2AfQF6Qw7O7Oa0WMpLq6OzwVY267IHhmE7+M7I5ZTl
	D96yISQI4eXxm3dm/0GViSJMpw9nJFDUldMW4/1UPCDMWHcEydAuvIK+ol4RUs96IPuvQzbhX5I
	8kdJhb5vUO72Y71l87xadoaRUwbhFU4S9rJ1Cgiv40XURbEVrlbAGuhemHiex5xWhks0NFf6Jru
	SDSmoAhBAcouKQksIu7h6AojJQfxZliFZDa2Nhl3ijdzWd3sBj0/3BY/XkQI0FXKK1vByoBtoNT
	8iQi/e90V7ziPn2C6lZr0p6ryyJ6jGnVRxFX4AjcWx+AXKxNYqrx/FpfFXXWi6cHGyOEGtCzrzv
	MuZjpEfX7vfYRs8G568589goNMY0MsP++lrLvryFmRRJc55fRTBsQa+UssIQbv3REdu/lRKmoW
X-Received: by 2002:a05:6a20:c90b:b0:3c4:2cf9:28ad with SMTP id adf61e73a8af0-3cc71ddfff1mr40412723637.12.1787045068712;
        Tue, 18 Aug 2026 02:24:28 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13c036c50sm1855975a12.26.2026.08.18.02.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:24:27 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v2 0/5] of: reserved_mem: several fixes about reserved memory
Date: Tue, 18 Aug 2026 17:24:15 +0800
Message-ID: <20260818092420.2859026-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1204160005
X-Stat-Signature: e3txa9ordznj4cs8kck5prbhc8knnmhz
X-Rspam-User: 
X-HE-Tag: 1787045069-530761
X-HE-Meta: U2FsdGVkX1+ohLlvPBF2i+WMmdRyOJ/bvXsG7qloD3vp2p+SeXJ5grF+3tniKlC3PqByn4eUwqhWSacu4pTpYWe2BWKQy9YKGSdOtN5LUNx3HrIQIrFrOxDmX0N7JM1G6Rms79W6ZLGIymAKh8EbyZMoeQcevKl2KJgBnpfF2M9efRNZE0ZvhuLYeo597CwZiwd1uxxfYJr9cQ9q+bhFC8WkfNRwHvCj+XiPF/20S+WOtNSvrBCscwucZMfG7/CCSSGWGwGohO3Dp0rTum89ABHbAuqwXjh99RxKSrb7pPMEeZUL4BF5xzGbQ+ctSMbwpRbTzK0XY9MxuBuOZ7Ne6SYCwIeut89H8lOgrzkVai/ZAD8QBDRaOiIANwMZ84oOd/RWL+6eU0afzmm3s33LWouGIwh9rD+0An7WjGwRd34gGPFUI+mDohyRCHGB3B7oFeiKvI+9c8UA9ZaF2FIK1qsN8imbb39KH/0fCjFB+dVZvolDaePLyoGpXcT1C2MVQ/tWVA1PGYbvvhePRigJgwXw3FBbyuHsq1ODUnsP6BnyUj+Kz/jjWULFhKqp6qDcQPF6Y9yVFFVKtF1LQzMEjDc3XLI8JENc4KpmlxG63ldtbE1XE3hvQja39PN3K3Bax/EriLxIRZu0shSpAoxT4GyZ0TXR+0AZ2gEjuXMjJ3uAAhg3Be0p4HPW9NQNxSaf9c0IY7LJVtxhTZZOBYm+Pp4EUjlbeXPKIyLO0T2VdYDoXbS0FSIWa12KoNc3c8XAMg+CeGy7T77iGtdn1CmnIim8Pv/9hEm2LNhWLQlId0BsAX/KG2g9DvMQRAMUZWCmTdSK52Tt9Q163D9BurHJk77rozrP4c3RGyUNNPhwFNItLwofLxBRU8Ybviw1+ePUeOy037ia1nXw6cZ8dtvKfH856Z1v+SlQ3pcq45+n0EebN7eOw1o6FeALCfax8xgrIKV/qJQ/8boc+GtQX4M
 fht2tZHM
 niZCDkxCfz4v3NI6fXiSsvOGmcLdsyWC00VQVDG+QyE2XHyy0+i1plRBmhEllWB8w8U6fZOK7j3KEPoIG0I31r2L6tCuUpYtbj4TdNGd28PqncoXNMHklVPfczQXpJ5GDvBGmEX+Y3C0LCdi7cqQWGEoP+Gz6ihhL1jzuu+UgNbaeyn+EBk6sk/p1LuAnvQAb7ZnuVi+J2Gn19szx0hKqyzSgN5PoOrNfcV04ysft9Trl5mmlodtCrYP3QZhC7d3kE7mcZPJaKCKZ21XtZOoZCtnuTs37AijufbmOVQ7sJbv13jait4CZJZAB02XUTKDMM05KIvf5+2RgXz0kUd7qHCCYyTGHbTlnjMBZbads9sscx0EUK/xSVyhXdLMIPkJCSzi7djL//dD81MG7C7xBAiWH/U1PzKZGmqoBocrLB/ha9Mlji0PJDvnducWpcxNRDaWHCWPcOs4XIOenKA4+Gp/UBc/ytlbaxVP98DX3iHP3CHxfBlAmN/MqQST/SjULjFnu/P0N4WLoKSllR274OPsnistzojaQjEty
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

This series fixes several error-handling issues in the reserved-memory
initialization paths.

Static reserved-memory nodes are reserved during the early DT scan but
initialized later. The first patch prevents a node whose early
reservation failed from reaching the late initialization path.

The following two patches reject overlapping static regions. Without
these checks, overlapping nodes can be initialized over the same
physical memory, result in data corrupt.

The last two patches fix cleanup of no-map regions after driver.

Sashiko reported these issues in [1] [2] [3].

[1] https://sashiko.dev/#/message/20260814090305.4C8741F00A3D%40smtp.kernel.org
[2] https://sashiko.dev/#/message/20260814084718.29C341F000E9%40smtp.kernel.org
[3] https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org

v1 --> v2:
1. Rework failed-node tracking in patch 1: do not track zero-sized nodes,
   and keep a reserved_mem slot when tracking overflows.
2. Reject static reserved regions overlapping existing no-map regions.
3. Keep MEMBLOCK_NOMAP flag for static no-map regions when init failure.

Wandun Chen (5):
  of: reserved_mem: skip init for regions whose early reservation failed
  of: reserved_mem: reject static regions overlapping no-map memory
  of: reserved_mem: reject statically placed regions overlapping
    existing reservations
  of: reserved_mem: release dynamically allocated no-map region on init
    failure
  of: reserved_mem: retain static no-map memory on init failure

 drivers/of/of_reserved_mem.c | 87 +++++++++++++++++++++++++++++-------
 include/linux/memblock.h     |  1 +
 mm/memblock.c                | 14 ++++++
 3 files changed, 85 insertions(+), 17 deletions(-)

-- 
2.43.0


