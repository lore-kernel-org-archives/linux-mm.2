Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29909EF5854
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 11:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A260F6B008A; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4876B008C; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892DA6B0092; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B38E6B0088
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1E60B96BD
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:15:11 +0000 (UTC)
X-FDA: 84446434422.12.E3C1E3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DFC1814000D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:15:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXe0MFJA;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771154110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QJ8/FR+f1EtdAHO1cOSqhsxGSG1goEI5OUc+wgFA+WI=;
	b=qhPF7c9d+Fuh8tIHbx7vbmU6Qn2Sa5Xf5zaeQRaoiFA2lpcOH0uTN/wimNf0l73eg+3Tsn
	+7hg4gE/OX/R2zFGxpJ2Bzc1Vyx4HyPVALbXDxQJ/bDSfGzjOENuxydVQcONLrC+rtg3fT
	VOaqyyd2xVAKfuWvcIP4iGZVwtNqcTQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXe0MFJA;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771154110; a=rsa-sha256;
	cv=none;
	b=5fIrxfTWzD4L0Rat8wJF8Uj+SLNeB2s9y0lqbltAKCfdVPrfWOnDewc/Q+RLMB6CSFLjah
	g7fIjwrVFze6kwavNb0O5qWv6wKqNMsS57Rpjmai6T+azX0R4aQkdEMIvtAfmn4zwNlVpW
	O81qKa5KdSnOqWiAyntvIx0sm/XxR8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4035400D7;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B4C9C4CEF7;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771154108;
	bh=NQIjZ4ioUQRkgBsK3tTxiXoZE9AA6RuocC+q3Uk/4Y0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=bXe0MFJAxMqHNS+DxiBiPGrmg8EZPmuoYWrJRI4dVgC+dozLZaWmQRTYJC8huGT9E
	 Eex7GWe8Xd6b2t/u6ykH2MC03SzCBtp7eHLr4dE9A5HIvXBV7ZZPirOlaVM0qX5qXn
	 vyEvXiaxlz9LQQ7ppL7xp6ZnHS35IGpFIwh2nCq7FHYUnekHFxZ0recwfMPw0wXJXA
	 EugGk+n4AokfzQ7Njo9AoMl+FjiqbMbEEUFxz3t3oYJwM7JOtTfcw/gd7DLkC+suTh
	 Jpk2btFh8eDZNl2yFVRRudx2AvSuoit96ntl3zgvpiIyXwvmUY2Ms2npaDE686bG6L
	 JeoSH/QA/tJfA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E367EF5854;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v2 0/2] mm/swap: hibernate: improve hibernate performance
 with new allocator
Date: Sun, 15 Feb 2026 19:15:04 +0800
Message-Id: <20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MwQ6CMBCE4Vche7YG1pSqJ9/DcKBlKnuwkLYhG
 sK7W0m8ePwnmW+lhChIdK1WilgkyRRK8KEiN/bhASVDaeKa25obVqNYxNBnqBnRK2+NOZ8sW9Z
 M5TRHeHnt4L0rPUrKU3zv/tJ81x+l/6mlUbXyWgMXoDWDvWUEh5CPbnpSt23bB9Yf3cauAAAA
X-Change-ID: 20260212-hibernate-perf-fb7783b2b252
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771154107; l=2398;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=NQIjZ4ioUQRkgBsK3tTxiXoZE9AA6RuocC+q3Uk/4Y0=;
 b=S3NiucafmUUST/nkOt+IvADfvetNDt1JzSV8IQDhzqNXwofm3wrAiMiPz3Uh43VWuydX61Fvs
 qflPpuuZ78iCwE76Uq1SqsbxlVzII2pvjz+ZZUo3EfmkLMiXfTvC13J
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: o7sxnux6wxn1w44cym4py44akrt3nwz9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFC1814000D
X-HE-Tag: 1771154109-896351
X-HE-Meta: U2FsdGVkX1+CwUKNX4DdYjx2Fuywci4d3TXmdWRHIU/bP+OSDjpqkZF2c4TF2xWD6w8/hVKTn+/N7wZscfWj3TgY+fJ5M7AqQzQ9A4FUuNR91zCqS4ydPRc3tjXTmKO+MCCsGsoEbm4cY4HedXTz4hA9zFQ5DX4++2jk/qM2E1vcECLcQth/cdHdhZE8fJfaXUGo76y6iNhVL/qEyzmJpO2a62p48dGzUdR8JQ9cult54sYzuonwVkalxlgaAR7mjq/Jir24eH1c7VZdXraGhmuYo4yeV0+VJc+ITNVrtUyIRbN68OW7FhioqhFpD5R5iWvtkOrs/sC8sWAjX49Z02Vd9gKsTkSe/AVuNfHw+BDa0UasBJ2lb+V3rLlio5IddhlYgKoPgtmA88lbHZTZflO6BKxJqr2kD2iUHIWjPwfp/Fqo+U1/TndtaU4CnXH0KK5SmUs/VaXd+GRnrOvreVCHOKCVfnc9pRdWHF6z6+YlNDr26QQ9e1H7UiIsVFWwk77HWfmg9fp8rkqX15IDt8UwrtQBBAQPA7aVwWC01OhrgG8AKQVoCCIKQgpQVPDftGvTFGByJOqNmQMdyXr553bYuLbbmDyz856LG3FUPw8HNjZBGWqyo2n0/r90hUZZoZEmbWJEzgxro+8BlObU9qALz+5FJ2V/oKtS+Bn2UDLOxReFuz3uuveyTi8EwxtQxLtGsdZx9xtqH6R1CbTdkgUnL3hSBQ84YzMYkaQD3vhYma17fAC15A4UKElhT6AgA3UrU0k7HAiwAH5caZ/Yw9mPzAkCjXUK14uIOiHXR7PNpvYDMt8BXeFHGdzPG9C6+HgdJ5xnwM47FG2tRE4yxf6rPivpYI5IXXk7wcfL5mFDVPiZPrNP2rl2HQ023lqUmE7Hdi8wY7US4AEX/tRGXEuqF5FpA+iK8jVgXc21KwIeaOlDDv3quJIFo+eLy28ckQgML3Ia2G3mWNCvVpL
 p8FJKGy8
 moPN6qtrtKfbcSI6mT+t1uBFUv7ueUkiYpt1fjtkT8GET8uFsQzjQ6xPjCTZuHltXEQnrfpjMmzkn9PxvkZiOJkg6swtEiXuw26i1dHEuXl3LWsj7ATVFIZZwUM5LqjOWRg5cDl3+74gnVQCaUs4AuVIoBrDGhye5RiKc5MSxQiT0JXtUXuU/bdVAP3lSt8K3wKkxWjcHnIBwDwHvNl7hWSN7Ppnee8Js+IaFFLr+6T4S60YQN7KEqLfX/mHgPmI2WaJNGL5ChgRou2LkFdqcjNqq2kCMNo4MZ0mWNBoq+bZ2TrLdYd9RO/qbZUOWmsFvv1fuhJZUFx3p10pcGhuzGhjkun5IfDZ/0gJjI3vVUCCrAWWhK2aFs+QiGdf3he3R0r82kWDyGI1k5x0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new swap allocator didn't provide a high-performance allocation
method for hibernate, and just left it using the easy slow path. As a
result, hibernate performance is quite bad on some devices

Fix it by implementing hibernate support for the fast allocation path.

This regression seems only happen with SSD devices with poor 4k
performance. I've tested on several different NVME and SSD setups, the
performance diff is tiny on them, but testing on a Samsung SSD 830
Series (SATA II, 3.0 Gbps) showed a big difference [1]:

Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) thanks
to Carsten Grohmann [1]:
6.19:               324 seconds
After this series:  35 seconds

Test result with SAMSUNG MZ7LH480HAHQ-00005 (SATA 3.2, 6.0 Gb/s):
Before 0ff67f990bd4: Wrote 2230700 kbytes in 4.47 seconds (499.03 MB/s)
After 0ff67f990bd4: Wrote 2215472 kbytes in 4.44 seconds (498.98 MB/s)
After this series: Wrote 2038748 kbytes in 4.04 seconds (504.64 MB/s)

Test result with Memblaze P5910DT0384M00:
Before 0ff67f990bd4: Wrote 2222772 kbytes in 0.84 seconds (2646.15 MB/s)
After 0ff67f990bd4: Wrote 2224184 kbytes in 0.90 seconds (2471.31 MB/s)
After this series: Wrote 1559088 kbytes in 0.55 seconds (2834.70 MB/s)

The performance is almost the same for blazing fast SSDs, but for some
SSDs, the performance is several times better.

Patch 1 improves the hibernate performance by using the fast path, and
patch 2 cleans up the code a bit since there are now multiple fast path
users using similar conventions.

Signed-off-by: Kairui Song <kasong@tencent.com>
Tested-by: Carsten Grohmann <carstengrohmann@gmx.de>
Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]
---
Changes in v2:
- Based on mm-unstable, resend using b4's relay to fix mismathed patch content.
- Link to v1: https://lore.kernel.org/r/20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com

---
Kairui Song (2):
      mm, swap: speed up hibernation allocation and writeout
      mm, swap: merge common convention and simplify allocation helper

 mm/swapfile.c | 56 ++++++++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)
---
base-commit: 53f061047924205138ad9bc315885255f7cc4944
change-id: 20260212-hibernate-perf-fb7783b2b252

Best regards,
-- 
Kairui Song <kasong@tencent.com>



