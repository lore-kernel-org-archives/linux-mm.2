Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D15DE63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 19:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9786B0089; Sun, 15 Feb 2026 14:06:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81F76B008A; Sun, 15 Feb 2026 14:06:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7476B008C; Sun, 15 Feb 2026 14:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A72E16B0089
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:06:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52C931A0B5B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:49 +0000 (UTC)
X-FDA: 84447607818.21.144176A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D61718000D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1KgH7+L;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771182047;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=roatK6JAiIY0XCcW175dv+YkwIYtlj+qrNNN2ohQyio=;
	b=8mZ3oVqFEQ2DRocT98JToPiXFzHOgR16sPKcnKytjzGCfTapUpp2NqMhwfGY0UqAvRsBNR
	cgUPFxYVbNdIAYFZnuQG5onhSaBKGISRCX8haFq/tX4m3Y4YSIv9iEU+lhlHMPuUuQred7
	z6kK86JI7UX307j9BeSeGs1KLDBxmuY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1KgH7+L;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771182047; a=rsa-sha256;
	cv=none;
	b=Tm/Akd+a5Cex6V7wCim2jWrwyhQbNIgnJilzErM8Nd6/z43r1vAMwlDOhxBKCjV3zYRAKs
	KzwG5EnuTstTR4PLmYHSC3B77T9Y8f95W0HpB/A4AXpR0zjkDKarw6GBFnYWT7RMpInZA3
	El3VpPuvIO6L2AA7vip6EI5B8setCGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A76D41782;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E037DC4CEF7;
	Sun, 15 Feb 2026 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771182046;
	bh=dF6Y79PNFZiEWY4PL7UAYOsByXEL30pvzMVmxPOmG+M=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=o1KgH7+LhD3TEf0tPDKzs1kn7jCsso0QwavbDCyLHecAK4XCm/GNcyjjZqgKTk3ex
	 RumMat0lb0X1jHE4nvAhMsq3PaZTM6mISazj4P0ETFPYbdrfb5EU/KYCl3PWsXOpoB
	 DTZT4x3v6t1qjXlHZrvrsC6sUV6cW8vlqug6WueqsAdE0j7CaCTheeCsAuGcxZd9QW
	 SjCYmkeU9ry8EF6kV91Z4PoewvDDqyG9BeWrixIPrskNEWSC0ORB6463rnk+u9YWLv
	 PsbXiQfRf6XCPWDkZ+wZrWl2LXXkucTT58UxNyoJbo/9lZRMFfxea1NSRf3A3mDYbK
	 2eCiYwr1CcosA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7130E63F0C;
	Sun, 15 Feb 2026 19:00:45 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v3 0/3] mm/swap: hibernate: improve hibernate performance
 with new allocator
Date: Mon, 16 Feb 2026 03:00:24 +0800
Message-Id: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33MQQ7CIBCF4asY1mLoVEp15T2Miw4d7CykDRCia
 Xp3aRMXunD5v+R9s4gUmKI472YRKHPk0Zeo9zthh87fSXJfWoCCRkEFcmCk4LtEcqLgpENj2ho
 BQYMopymQ4+cGXm+lB45pDK/Nz9W6fij9S+VKKum0JjoRNabHSyJvyaeDHR9ixTL8B6AA1kFrj
 UZ1RPMNLMvyBjRrLPjvAAAA
X-Change-ID: 20260212-hibernate-perf-fb7783b2b252
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Carsten Grohmann <mail@carstengrohmann.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, Kairui Song <kasong@tencent.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771182044; l=2672;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dF6Y79PNFZiEWY4PL7UAYOsByXEL30pvzMVmxPOmG+M=;
 b=5uoOa6dYgg4V5j9K4LZOCSYQHHvdzzvl/ZfwhWzim0Y8GqweS5RWo5Oj7ZRfTiSEws3cK37UU
 m12I+YzVF1MCrOSc0F7thaGgrMnaF+aPi3RmD6LyKbPtfzcj9ZdLYcB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D61718000D
X-Rspamd-Server: rspam07
X-Stat-Signature: y7qryuzia13az8apq6yd1e8drrkaa891
X-HE-Tag: 1771182047-223911
X-HE-Meta: U2FsdGVkX1+zwyQp8kP+3cshaOR9qWHX7b08H9/vkXVzB1h9W+QAcKbDPHzietX0r4TMKvaSb/BuOb5P0OyrsDitTCKS9iE+M/sVaeWYe0UqCJ8+mJqmRLjUbYrlJuik50ncvxF2f61Ju3Gn3H0QRuUQZ1iYcYFA9VMWIBHOjj3t+wDu4KYFzcM4q64v2IKahIypv7QGhNkkYSHE553S5ve4fNJOzoCQiio4LlhRqoyijlp8CCo2Hp186zAi8qLMnvvDKc1oPMYrgVlxP2cprY3oN44lOqXMidmxF+pwTmNtzBDrAvaEvBnt3ZX8lKolpxn0xwhzgQLLjHK46pt+c42jGbB2v4EUZ03V6JhKArisOw8z/XRZcmveXRrEh4Jxsiyl/WUOQEixycBzFwLf0XVVFYGQsdMhfTMVNHgY1sMDXVxDyG3evZR+rhw9cWG4BbHQgmwdnqOdXPv+mcDzXOfPokNtY+r7znwjuGVU9WB1lTTVqaOBr2AMLRMbeKuIY1IFMAYSMa5MgZv3mOZ78jfoY1ZOlEGY5pFD3YRXpKlCfqPbk1HoOMAoTu26x4tDo8zUa2zhvVacsu2s5TQVz9KMmY9o2cSt4AJjl6PcOAvZFVwcvbnONkdJ9dzimMVZ60OAshYmOvhnX2Tvr0DITPuUityTZHLhVqPuBUtxLXgxs4ZpmfV+YpGPl7YD118dLiGLb5rTPxpCKdN5F32DeB/XzppocKy3yFOqF3uQQCZ3mM/nRga9D+kmYzabHZpTlBWmtU7u3taUJJLvBDeT6W7Ta2SzPBXL1UAqZ2Za79m2HAMyRgxyeIMkV/8zwxDaVQLWgoUO8g+JifofFmdDQGTat8R3nOi1jXaMuC4edxCtBMXACBU3HV+CjphEJ7W+6p4K7sL95UXiMsM5vlZ6dgRMCdHIjzXUfCM+rWz0ufJEPh+aVcT/fEV1O7DAiG1vEkNrDurpdjrP5JdhyVp
 ABZC47jy
 sPN0Rb1hnF7PYQQs=
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
Tested-by: Carsten Grohmann <mail@carstengrohmann.de>
Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]
---
Changes in v3:
- Split the indention change to a standalone patch.
- Update mail address and add Cc stable.
- Link to v2: https://lore.kernel.org/r/20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com

Changes in v2:
- Based on mm-unstable, resend using b4's relay to fix mismathed patch content.
- Link to v1: https://lore.kernel.org/r/20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com

---
Kairui Song (3):
      mm, swap: speed up hibernation allocation and writeout
      mm, swap: reduce indention for hibernate allocation helper
      mm, swap: merge common convention and simplify allocation helper

 mm/swapfile.c | 55 +++++++++++++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 30 deletions(-)
---
base-commit: 53f061047924205138ad9bc315885255f7cc4944
change-id: 20260212-hibernate-perf-fb7783b2b252

Best regards,
-- 
Kairui Song <kasong@tencent.com>



