Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741F6C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0016B0088; Sat,  5 Sep 2026 10:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6608E6B008A; Sat,  5 Sep 2026 10:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F8C6B008C; Sat,  5 Sep 2026 10:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA106B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:02:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA531A43E8
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:01 +0000 (UTC)
X-FDA: 85179872442.07.A1A9163
Received: from mail-wm2-f6.google.com (mail-wm2-f6.google.com [74.125.225.134])
	by imf01.hostedemail.com (Postfix) with ESMTP id A27CF40010
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:01:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dq+WoF3t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788616919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nPpHNOPG2eF6hIZslIRv1KyfhI9ApkPtiUNXBEjR624=;
	b=PDMQE0vyHnXpSpSgZVI1EC7VSq5k1hWFeJYM3Osvab0OerQRhvMcIxVGKk0QpWFs8u+Fe6
	yl7QZXlK0jpEcRfJodl4TjAnyIn4QzLkHgkqDJHboL9REoFyKBMW2zPYXp+FafthNNfe//
	TJDMO/38+4sO3pP55PC3VMeU3GxEQqg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dq+WoF3t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788616919;
	b=rZv4Gj+mGFMqC6Cp+XwWZ5CU6zuNflamScUjC3EcENhKTRGjSIKT88SAmzhRxF/KpgUUKs
	7Ku9UM5Al51UhKt7topLA6GrhfCF0Bz8Kz28vL2heTnMGfjCd+5gCb61RKfgM2t7O1+Eog
	mJKdmHY56OoHvFdeIIO+i2A2z2emqZQ=
Received: by mail-wm2-f6.google.com with SMTP id 5b1f17b1804b1-499aaf0a723so7144975e9.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788616918; x=1789221718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nPpHNOPG2eF6hIZslIRv1KyfhI9ApkPtiUNXBEjR624=;
        b=dq+WoF3tpw7Nk1dcmJvml7z5UckI57IqDEcqPodF1Us/gNiOAl+PXIz4Obg/gT1vzR
         OOUufMappjRVkZ8kFWWbjXfNYs4/De44KFK5fYdozgvvL9yhQ9lc9Q7wa+6i8hp+IcR2
         YB4lsxN8yH6aq49sGFBpcUmqYivWHnwnctEY46gQu2cnPi1/Jq/6WkXRpX34oioJZCUc
         zcbeoSloLO3qr9jht4xHp3ZeVkkTFMjabLLPSV0WmP6GqgiHjlImR7N4K+VfgH1unf9S
         GXXH93s4UoVSDcj538RaaDzuL91EkZYBo1HZDDa2rQ+A0JzeWIztM9dYq01lPAjZUi9O
         4qgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788616918; x=1789221718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nPpHNOPG2eF6hIZslIRv1KyfhI9ApkPtiUNXBEjR624=;
        b=XEGt1jAPsBiIPT3tYRts8HagDMs3WnQQkzMc2nnEBgq3ify/RB51bWtGb31juoO2Cq
         NSUZ96MP21Q8HEnRAWkeFeSC0vt8TZ51GzmaRrvecuXG/7ntmmjL1URjD+ZqlRNv/Azy
         /O64irqcSFKq6NSHvcmLUYzy5/qHQuUC3aGp7QvyHM9QBeLWTZOSS6YXybthyXqco5An
         HLZBS9SKRzuBQKsCE/Wp9ODhOe1rsf38d5ius7+15QSP/Q660BxqA95tq6dLFnywT/LL
         onynQrApMWraIveZCYXTJzroTjNUPk7JIdGbUd5sHZTGNq058KzZFKglQSLv7XUhp1wX
         unfg==
X-Forwarded-Encrypted: i=1; AKwUvBya2bGxZ1usHpkj0FynUIR4Kz0gOgn05By5W3jefU1bYzChQlJ9GnsvpBfZ7KftrOBOjXFcOB1dIA==@kvack.org
X-Gm-Message-State: AFuF++miTv1Ghy3jkI/mnanai7NPoYU8h0sZwviYwXZG9yBRx1/XV8sI
	rW0cNDT3Bv+//7u3YrXrhi8FbN9WeB10e7SkfY/pzbQuTGhmkfChmUat
X-Gm-Gg: AYBFou1N0hw8gMMHW6xWBQaaRUkGfdLa1G8ZJ4TF/MrRBtWkqbm3yFZY0dR+VMWnU7m
	CCoxkgHjfOcgEKd2TN+kVGgoMUOHj95JdFUX+ihl9PS/tod93/FaDCQT9wZnmuIOla6qxNEpwYm
	Yu2rpz5hvBc+kt7j+eI4QXV1RDYFOiBv8kM2Y+F/xFi7vrgSkgLQ4KsL8Zm1snVTwnADvNSPAAq
	P/YEONPs3JwB9Ttm8Rk0dvWZ8D8TIZCdTs8mSSVg7sSPQndQVlWP6xGsu/K/zG/q+idI9Al9BUy
	NoS/mdEB2061nfoYaTVmIF0kVEH4s/bw6ZQlczeAejR3QglkHzGh8jNsktyLJ1Xm9TyMdVfEIW0
	2OWmFfmHFlVUVa5VYA3FH6E/AXTGcYLhS24LMjRfQJ2JKUi0h4DewYtr4FeBUpIvDCozdkL21DP
	mRAjHiKGxNVE1JCsTSJfqyJZ75byld5DtVHNG72yUzJeALG9APB5vwp8D9l3wR5lPGTBNuoWNdw
	8BeN7nkxDgmkPEPbQeLySccDZY28yqmsnK0qt7g
X-Received: by 2002:a05:600c:8b6d:b0:499:a277:e8b5 with SMTP id 5b1f17b1804b1-49cf7fdd67emr233375335e9.3.1788616916740;
        Sat, 05 Sep 2026 07:01:56 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf755c22esm149866765e9.0.2026.09.05.07.01.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 07:01:55 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH 0/3] mm: minor janitorial style cleanups
Date: Sat,  5 Sep 2026 17:01:36 +0300
Message-ID: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ceu9rkeck417z41e45tkbsofjacaad64
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A27CF40010
X-Rspam-User: 
X-HE-Tag: 1788616919-840826
X-HE-Meta: U2FsdGVkX19QI5IdaDbsaUvG9SBvZv9bhT//w3Cvup+xBtuWvxDjmd11QXh7Idi23xTYw3ztcS9ZF3NCeKl81wb1EIrUS1Gcf5g7Y0AVy6XHijoRF3vk9N+FL21pdt788GuYp0jHuMkV7G9juHwNOREozn1Dbu3VpnkzV7DjYEOcNJZht1epCafmDy9T0kC30CZoql6BRpjlUtsCiDBFJtL/ZlAIYLXCKzJDb1c67Xjvieyf3ZcHarfvPESrhyX5vkLhKZQYoXSEOU2KdjQfO0EyhXNiDK0s3SLzwUiRss3dPb79sx3Jwnla9d5TG2isfX5Yi+VFyeLI7wY1oQfouLEHMX2nEiFFznA+MHNy7Pr4s6hyIk3DyweAqp8Atnru7WL4yJ8yUauW3wgD/z+sz3q83BVOikMFoUXywtizWzxDx9/9VHFD/SmdDFDywLC2XZstN0jLvvLMTjIg+pfQwZw6/ByIaTseWx1aangkqxREHvaSY+doE0LIrMx9be2cjg/c9xq+80nrBHXB4e1NM1q3kohVLPUMO9dLXukGTaXEWunAByyZqGsdlBRtdVgQ1DlKJOx20QJsF3IRU0iq4hRV72vhKX5ZBUbjuiRTypGFK9Vtq0o7uH9DI3GUAcvcSyobGsSFKF/F9/Bw7yL85ZTXRId9UDURXu9pHhp4rH1hZxwMsaXOCf24SrPQsdOrPUepIOrdfiz2ASTpbm7jaOV3oTWRBiAlLarkmxXA5KcCMms5QexjaOyVRGdQQoTDEZCQydCiUJjcTwkHbp9+ewHcDBAapastd8rXjWQnhDkNb4emzVYVnuQ4AYc6OEFsGnc33HS63WxdbISGdVypH8fvLCuMXgXpqwRx6zrBVQEibGQHujuVSuWHpe59rZKOOV/kKjGjBcCXyZSA+4GNaEGGeSCqKrJfPMbXI9aHpbOoxjDb6xkx2131NIZK3NRzVL5kAN5EM+zXXK94itG
 9fKnyfN/
 C6hbAugBOs1eBJmn6Xy7r4mZYO4gBtTEDSFwmjNDIMPzmaJ3b0UQMgnzF+06klJftddYUQTtoO93UOMpMSHcy+cB+KA9fKazIOd4SnQqTvfCvHQDyXSoUoPmbY0oig5KQQMQB13Dwp3Tyw7q+TGgW1rtU3K4xXciqh/EaCNsnrBWRvugbp2khRMNJ9Yx1+tfgtY9IbfkBwZ5bKP2Z8fuu1DDNHQJ/9NooXGnDlyfK/DtAdHqcSNkpQv+iMEpwUgyYuCA9EPe3IJXTheuPk5kLMPcoYuhQUPdFXKow7h7JdgJXWcEFp+xXwkIeew6APVTHdJ6u2R+ZYVc6d+9D7maetCr0n33bW7Cvk7QN8lM3tyLNBZ72Vho/FtG21CiTuwSAr0TYuZiwllhB1j9c2KDXhehOL9SoInpazYAiDoloQ5qgJ4g8NryZVGI42vFBsGNuAIb58BPgjwTZnBGYGtTgUz0TeadWOdF6QZ4Xqtc5yNwevXHWZ77qHViYl9pfCWJGf7I/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series resolves various coding style issues flagged by checkpatch.pl 
across mmap.c, vmscan.c, and hugetlb.c. The changes include fixing spacing, adding 
missing blank lines, formatting block comments, and removing unnecessary braces.

 No functional changes are introduced.

Christos Skarlos (3):
  mm/mmap.c: fix various coding style warnings
  mm/vamscan: fix various coding style warnings and errors
  mm/hugetlb: fix various coding style warnings.

 mm/hugetlb.c | 17 +++++++++++------
 mm/mmap.c    | 19 ++++++++++++-------
 mm/vmscan.c  | 12 +++++++-----
 3 files changed, 30 insertions(+), 18 deletions(-)

-- 
2.55.0


