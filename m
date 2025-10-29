Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCEECCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45198E0043; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3D08E0041; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFF68E0043; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 783518E0040
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EDA713BB85
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:07 +0000 (UTC)
X-FDA: 84050547294.17.DA2D981
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3969C0008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761728225; a=rsa-sha256;
	cv=none;
	b=2OdFHyNVbTmUeSE15SKmO0dQHfitopKbGVfA0cLHHK9i3ahxhPy94jMPsR0DETqQm3Tuvs
	fv1XlTugtNUV3BBNo0CKwWe484Xb7du+p1Jr35rdFWRxh6Snjz/n1Kcja/ZhrxnRzEAtmg
	rdLUZLl0bk/XCSmxbKX1HRFrv8bvZ4A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761728225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=QSdveRWM+Umrd/EdORAvvnsQmRNZ4hgpved4j+J6jWA=;
	b=Y1Td7PlfOmBEiDlWgnjXpOt2oJJQoSJAPKuWiddmOwl6nn8DK23POgUHmpkegFkKPhfXZN
	gC3F0soWLui5XFPaCXw4P/IDZcQRZ6Z6RFiQvuH+jk3iTNP4otcLe8tPuOzbOVop57TDEe
	wweWFQ7XRaHkm6NeBNdo2/zkMYG8lEw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Oct 2025 17:57:00 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	gunho.lee@lge.com
Subject: [PATCH 0/5] mm: swap: small fixes and comment cleanups
Date: Wed, 29 Oct 2025 17:56:54 +0900
Message-Id: <20251029085659.2005942-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5j88skagruwkqb4kzpfnjd4ptojcn8p9
X-Rspamd-Queue-Id: F3969C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761728223-969640
X-HE-Meta: U2FsdGVkX18Vh/2phxfTKTcghtWw1lKfNeMzmKNfpta1BwjuPNJJ66QrN9m+fGgDonFLoTkBDe23AbsNnUGr2aEYBVbttZjirtGc7zs5sc5kLnZ4qtVkRStCC4V8AHFV9nLQp1+QrtZKuEQMD+dDeXbL7UcgPxVhWoovnjyDd2yfksrF0isxjvCoL0AhLh8BNlTm2pwBACqvZjyqN7jBeziPl31FEkvTxsMCa8OqljW4S3ZvkXpzSdLRvPsAM/thwAcYJqtxHeNVoJtum5Cft8Jw1+WpRy+xlyIyeN/ptzYSGp1TQ1X5T6DXKKU/N3xaynEnbSuINdAe7rsjLTkeUACfgGM2iKuXYZ7x7Sp2rAInYZSlV2bfnPi8hGxUI9saawvXiGfY+K1LPdnKvSqoW1lndwk2qMggNsb7NUDjUZtQIdLZB79n0KQWZtI+nP0EUWqnA+oZfNZx9dIyQ59tG87DYkOCtn9vabc+TNOa0jJqfGcIRjxsCrbtTUwdqDjQbqJEoAC/Stba6+EIRwYaawLdGm6OP7dsgYsI2wOy4SKbpxk9JxxYcoRioIk+IXh+aEque46bU5ZTDMEn+0AGfqvRvybW7EboWuplpObP7xBZHzJDlTxtUQ1KC6+Z3Snn88FPIrBbzAiHg5NJf00QyPSAsjKB4N8n+z+aHqhYTG9VJqQnNeRt54HlWklHgGtznJH0K45DERdELuFwV2r+PV8Xfz5ZixrWM3loa4pSJa08XK6/CqN5Q44c06ba/8dzVrFM9BRcyjojPyD8p3fFl+feywL8Nx9FXSe52Fv3I5V/JuIgPy4MSC74JIaHLfscFv2rNauS6JgblUGovufKQ5cgOjO/PSO9Uysd6OSQpJvsdIz2bvQfd4EVVlB9xJF4AI8bPIjwxDmIvXNEyfgf/koxOv5InRYxJEM0+nNMSLtPQ0a06ViTdJnZ5EtXR8hAHrcY1hWUcikKnc/iapz
 jSKfbHbl
 5snyGx6Dk6ESzJG9RTUdTvobp0Uw8y5qvhrUdkCvKiHPCRaSNgBapnuXqF+oNZ376ffe4RUGsykQdyh/g2j1njTMwS76ogt2+Q9Pq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,
This patch series contains small fixes and cleanups in the swap code.

It includes:
 - A memory leak fix on the error path
 - Minor logic adjustments
 - Removal of redundant or outdated comments

Thank you,
Youngjun Park
                                  
Youngjun Park (5):
  mm, swap: Fix memory leak in setup_clusters() error path
  mm, swap: Use SWP_SOLIDSTATE to determine if swap is rotational
  mm, swap: Remove redundant comment for read_swap_cache_async
  mm: swap: change swap_alloc_slow() to void
  mm: swap: remove scan_swap_map_slots() references from comments

 mm/swap_state.c |  4 ----
 mm/swapfile.c   | 35 ++++++++++++++++-------------------
 2 files changed, 16 insertions(+), 23 deletions(-)

base-commit: f30d294530d939fa4b77d61bc60f25c4284841fa (mm-new)
-- 
2.34.1


