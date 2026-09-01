Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A6AC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909B06B018A; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1B86B018C; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E096B018D; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 650486B018A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB95FC041E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
X-FDA: 85165248840.09.370B91F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 39F5E1A0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/r6dn9E";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MqAfrIBx5SvDHugoYUw0lcd20KCbw1hgg2CnccvhE0I=;
	b=V8TX1SphjyaP7qbx8UIz1Mmot38X/+OqZjXBpfW64/5JVuynx7W9nmsvooDqF11LWudckA
	T1afnOqqnwncvKZ9JRvzk6eQXuW8qpEhBTDlH45UNh7yMHk7g9shQPYN2y1up/JPghyyOu
	wYCSVKfrmhvmoGwQ4E1GZR36XsW7a3I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268739;
	b=ab+BtHfcacRP2zzFFSs9xf5T2Rnhl8g588vV6GrguoZEHQCLgz/4sUpAjSIpI285Sg2gun
	/3lwiyA4TasAZcHnYAQZv/at0VGQW7T3MXaaSBetqFkbgYmOIa2ISK0Dd/LP52JfiUlrWY
	MG8T4ICYz120a5mqB5Lu8QdVnAwEeqo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/r6dn9E";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB3C7602D4;
	Tue,  1 Sep 2026 13:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312871F000E9;
	Tue,  1 Sep 2026 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268738;
	bh=MqAfrIBx5SvDHugoYUw0lcd20KCbw1hgg2CnccvhE0I=;
	h=From:To:Cc:Subject:Date;
	b=L/r6dn9EC67/opcBAX3umt9W1+djaQGCUF+kuSFFcp+2TcORzFbd3Z0bc0Vpi9NUU
	 s2R3ApF90dBL5shgUoExIvYWPnHHqUSRe39mTY4F9izZh6dLeC3dkpVlOhxWSYfqnL
	 n2IotXA3GxaCr+FYyJ/Bv65wxb1tJo+wjwLKXCNil+YGkBW1NabNNU+6z9914M/TUL
	 vv84Kn0t4Xvkz8j3e8fK4xMPCHcRjWSotZh+0GC8oP4SpJS/YJ8+JXlfkBv2caLIqZ
	 M+Xl1lD5wCcKJt8rh0R0WdwZpgPazAsT8TbAFqqNC8QIk3FT6l/S5n2eiw4flNhTbV
	 lt+SnTUybEVvg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/8] mm/damon: fix DAMOS bugs in core, paddr and vaddr
Date: Tue,  1 Sep 2026 06:18:41 -0700
Message-ID: <20260901131850.98037-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39F5E1A0008
X-Stat-Signature: c5m7ojyhyox85ni8djwhimm9yuzszcww
X-HE-Tag: 1788268739-566970
X-HE-Meta: U2FsdGVkX1+rJg4UiWyFXsNRIOalH83LrH2GyL+DxA8DO70X9aLEe040Q/nLMLwggnsHvQtbHEPq/jlftwU0OGc/hKKpgAOHKkdCaNC0aqDsSli2bJxtTvTxdd+KiI8ytovDX4dQxu0tWaQ4EDN+N5yNbeN5BZkutUZ/jZERdA5M7rWF1n07ZIGDJ7u5lNjf2vsOZ78xpGSNGQfJmd3XneAhtsGVJeyGU10muUzcYkO/oCWz7pykUihIi/KNfqhwiJVZQGk642IFr7cFuu9Lw+9j7j3dHyPvGVJUczdxqiggWVRtyZ9NpXBGP5PcTak8T33fuIX42PO8rmAReHRr5LsP+4rsQ96u9pzeLp6nqxQbr0LkwKPwtaBZw+cbEKYbPmNrWKjOXZOWzdpN9QPYTGrY36yPiXdRw5ImoURjK/gZRevzoKWdFTJ8Q/NXTeVzS0FCHBda6sfY59Cy/AFI8qfyYDOPk14A+95CjeIPDgasi0f2fRUz02oXkcnCmnJzYNlX3TdOOVIGieZcL0pL+pt0iG7qB9zrJfdB0uQFC9ZhJiVr4flaHUPKr4eJoOMAQTGtJrpystl6OsxgTSTOqnExvgvgjVgsepCyGRyrIsFBipVief4O1k5XT0pE1oWUFTagfJrB2gs01NqNPFXJCjU3WONh9M0v+sgLX+abpUWlqvflLshT5v/Rzd1GP31Fl2HVucv2jW/LgreQGNfFNBLzUu2Yn1y3D8yYceSQ8+uFfaWi38SGeBr2q/Q2Zc/rpavk043f2ZfmRtPuMG+9LCKn1a6WiDB4Z6jHmaL7ynelPdyS5LHAAA4Zu+JLQEFJETYGajFlLHjqBC7xxcTf+dY/niEKN0mBC0Z26BoGcZd1MB4d6S1AlZd8/5pEiCYirKczE7FoTbXukbXJRYIchpGql5SG8f5dS0Zwyl0/oAXltV1wxFbE7wsXE9EQsQcc2h8otkZWARbsMaiaEj3
 RdFPJkEv
 mtaX08MvHbGifngB1A61KYAp4KVB21NIujNAR0zaEQk7yOJtrY1ghx8x/nFGVYhIF6yxbylFiy8g0hNGWxKD8S9Axsh8SiQUl3xrS35TrfCUiG/MfyKF6wg0caZg3KCIUBsDUzPfyilwHGVP5fLC9PNeSNAhvambnfquehNlWMu6eLLVHSFJUBLjbqHaQWpULLRQkZMiiqx9rSDFdCyY+tTt35BVBos5wC5YzlnurLExOdAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory
allocator under extreme situation.  Patches 2 and 3 fix wrong folios
walking in DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in
DAMON_VADDR.  Patches 6-8 handle extreme and unlikely memory situations
that can cause divide by zero and underflow.

All bugs are discovered by Sashiko.

The bugs are not very critical, but better to be merged sooner than
later.  Since mm.git is closed for urgent changes, I aim for 7.3-rcX.  I
will drop the RFC tag after 7.3-rc1.

Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260831140254.72004-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260802162631.90304-1-sj@kernel.org
- Fix wrong commit message (patch 7).
- Return 100% and 0% for used and free memory (patches 7 and 8).
- Drop incomplete last_psi_total initialization (patch 2).
- Rebase to latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260801173554.94710-1-sj@kernel.org
- Use cached pte content (patch 5 and 6).
- Handle totalram < freeram case (patch 7).
- Fix wrong function name in commit message (patch 9).

SJ Park (8):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/paddr: respect folio end for DAMOS_STAT
  mm/damon/paddr: respect folio end for DAMOS actions except STAT
  mm/damon/vaddr: respect folio end for DAMOS_STAT
  mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
  mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
  mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
  mm/damon/core: handle extreme memory state in get_in_active_mem_bp()

 mm/damon/core.c  | 18 ++++++++++++++++--
 mm/damon/paddr.c |  8 ++++----
 mm/damon/vaddr.c | 10 ++++++++--
 3 files changed, 28 insertions(+), 8 deletions(-)


base-commit: 0926ef526f90a707f59c0790cafdb5a9b9cdebe7
-- 
2.47.3

