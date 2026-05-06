Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F43CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62976B008A; Wed,  6 May 2026 08:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF216B008C; Wed,  6 May 2026 08:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54186B0092; Wed,  6 May 2026 08:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9821B6B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:00:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC1591C0388
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:00:20 +0000 (UTC)
X-FDA: 84736852200.08.8A702D4
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3CD53C0010
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:00:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=sLy1RwEV;
	spf=pass (imf28.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778068819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MAx5G3WSi0kn9ozTKXHHjJK+xQtPpNgVE01pyUEzytU=;
	b=3Nofi6L2c343WI2dmfMjd+VmwcV0TRaTuuMQKNxwRoj+/aqc3eozQB3Iz7OUQm/RE14ZUA
	lHP89YjmyOfE01+e2qY6vdvAYzS9JJKgeTgVLXyn92wQrLIno8EP03kRsS8KaisNoslXbU
	WLJ98UqcPetz7Rm8g5SXvUbdRZBmPSU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=sLy1RwEV;
	spf=pass (imf28.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778068819; a=rsa-sha256;
	cv=none;
	b=crJ376aQBZ2zPQc4Jx01dweCXpZiTaUg5EvoqZuYTjkbplVl9XPgsAYcE6rVkM0mQ4jgy7
	CFUkkorLUt/cxJDyOueyFJhqnWumcA7lbhHWajbQtvJuNXonVLyt9x0sDajAEt5QUussM9
	W3FSLmVDRLBm8N2LTAtJshA42dQD/Pk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MAx5G3WSi0kn9ozTKXHHjJK+xQtPpNgVE01pyUEzytU=; b=sLy1RwEVyh+Up45cOede75X0BY
	Vg/Hck2X1D5mnV3o4sM7dwPt0DX+j48Jhgbhth2lR3Il/K6IKrrqlsYzsYDIbqWnn6QSdVo/sDyMJ
	KaLFEfuhgC1kead3PAhLt9BZAo31HyJtSFh4qk9x0UG3f7lPFeYz+9yRcHU2YA9xgHuQK8onDQiF6
	1BCDWpXlh1BNcGm5HzBB9em2GVlXOuMbIBzgYbtDHFAo2BHfC+dMPPOlHKN3dG6QFstqZdzJuLNxK
	sWn+Ti2u8XjwTYFi7jaLxRZiaNJfWIOpJaooY+KDmi3n/ZbN8IqlihtXJn5UEYFNPSfk0CDIBCcmM
	bBkYCi3Q==;
Received: from 179-125-92-238-dinamico.pombonet.net.br ([179.125.92.238] helo=[127.0.0.1])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wKaux-006sxt-VE; Wed, 06 May 2026 13:59:55 +0200
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 0/2] cgroup/dmem: introduce a peak file
Date: Wed, 06 May 2026 08:58:23 -0300
Message-Id: <20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOAs+2kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEwNL3ZTc1Nz4gtTEbF3jxKRkw6RUS1MDcyMloPqCotS0zAqwWdGxtbU
 AI5qMh1sAAAA=
X-Change-ID: 20260409-dmem_peak-3abc1be95072
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, 
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, kernel-dev@igalia.com
X-Mailer: b4 0.16-dev-62088
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3CD53C0010
X-Stat-Signature: y7o17g98t54g3574j6ntw1tngjez61k8
X-HE-Tag: 1778068818-369461
X-HE-Meta: U2FsdGVkX1+QcwObbjOHKriNQZ2FAO9kMkOdJk+6iyl3g0FXaBFnTOWcuRSMViRr/kUtTpzTM21/23zL25EYsjepT+r4R+X5Xeym/x1g2j+KGbNspLqmrXsugA4E0KOA9+9ZZYdSJTL2wUhnch9ONWTqEnZJs/X17zuxAdQevnic+YqJfO+MHC+tFLEeLczEwSmPwetKDV7w3XMhmn8YNQHoySUIdKmaNn5NXEfRCCdZFI8Q0N5gcRF+8hEQX/MoLJ837uDyaIXiGPAEQhfa+rPaLGvritLx8TlUxzXd2ePFJn18D6MBc5fMn7ytzZ6xko3MpDgQqpBGnvEkWepO8g1oNXi+6/SbkbMzpxmWagj++9n3SDoxX5mO7ELsYF4cJecMG454q9tULwHGbh/h7b0wv9CPY1LZ8jiHuxWuD8cJhvAl3opyM5LUScbAUUSbIf7kkiAAtXEa8ueaIHkakMNBkXHYKs4o1zVsWDw6QLDbtwRgK+NYqBjGPphzQD8nObB1xMDPaJIrOOmS8dF1BPQgRIZHChcA8wS009DK7HmDmDADxP/rsrMl3yod8TwNm4KyMRCTZiyry9V4q25xhnVbUCqEYg5sFMUXNf3M5xncLhVF4N7fFza3XYUSB+pdzcWjycNBaK60j6CznDRnbXYe9c4QDaKUewm4AqbJ1Yu8eb8nR5KJSgnby4ImhewF6a+kDIXDf7/s1+lIUDzShMMhF4ua23/SWXUdp0TKgpWn98/LbbDIyWBMeGlaNHmAPc0yqZ6yvFvOaSa/UrZAn7HSi9zOs4tRUAvFdRYljh4x34gSCpQ4KHfzSVA9aMKuDR1Dre1SR5S9hkQ2Q26qIDTikN/6JvhSCjje+otNhADzw3bbjihgVzLoDnYTuQzc9xfoZLObxtlUOy6n9d80TjJS8tmh/14iDVQwRazAlV3MLT5qL0bL3UK4l6g4XAlwUnp68swzZZQ3nS9zLNd
 TT4VSdTt
 oJF3JFHL7AygEC8hLxwgqOX6d7ecQrTdaKNU6X12SLN6B+eirPkuSrjQvbqAikQ4j6BaT4o6s44GgpX2ZYYL7Kf+G3x2l9xBHGosiSzvOpru0N9gxBqT7Hag4Q8xp4GBlObzrvIh7iVGtYcQFXEhyqCTz4PPzOCo562zjt5CQ81PdCahVx23azAkCzEQnZmyu+nqhICfnR6xlijRe3yt2y+Vp4Iitlsfs2Y6FY9+qUntWOjwHfGYqcEYUhLv7RDNtFHY5sUNNliGZj+eDxGJPpHy/LQMAFpYJhFZD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just like we have memory.peak, introduce a dmem.peak, which uses the
page_counter support for that.

It can be written to in order to reset the peak, but different from
memory.peak, which expects any write, dmem.peak expects the region name to
be written to it. That region peak is the one that is reset.

That requires ofp_peak to carry a pointer to the pool that was reset.

Writing a different region name will reset the different region and make
the original region peak get back to its non-reset value.

While at it, we reuse a helper from memcontrol, which we moved to
kernel/cgroup/cgroup.c.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
Thadeu Lima de Souza Cascardo (2):
      mm/page_counter: decouple peak_reset from peak_write
      cgroup/dmem: introduce a peak file

 Documentation/admin-guide/cgroup-v2.rst |  10 +++
 include/linux/cgroup-defs.h             |   7 ++
 kernel/cgroup/cgroup.c                  |  32 ++++++++
 kernel/cgroup/dmem.c                    | 132 ++++++++++++++++++++++++++++++--
 mm/memcontrol.c                         |  42 ++--------
 5 files changed, 183 insertions(+), 40 deletions(-)
---
base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
change-id: 20260409-dmem_peak-3abc1be95072

Best regards,
--  
Thadeu Lima de Souza Cascardo <cascardo@igalia.com>


