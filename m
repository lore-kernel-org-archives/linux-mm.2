Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8672A104C00E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F226B008A; Wed, 11 Mar 2026 07:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16236B008C; Wed, 11 Mar 2026 07:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EE76B0092; Wed, 11 Mar 2026 07:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0E16B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:03:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B7E01A075B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:48 +0000 (UTC)
X-FDA: 84533496936.11.110FC2F
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf04.hostedemail.com (Postfix) with ESMTP id 19E274000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=W9/ZNjdc3+W5R0U8ddAgwUAszBz9goFvu3/zEzSYz74=;
	b=dEicBPeCAd3HZFRlhOfz2HYZObF9yHOr/tK/LV+Q/Phn2jt9nkCdO6Mjo9HvSDdlEenuPI
	B5qDHDxu4OWsYPkjvy94liynUh9JcLGQkHLNV5hbU4JXsjLUmnTiNUgpqcFLnSu9IH3ioX
	qma+XBQo/LtwxiA3aJjp7Y4u2cs86ng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773227026; a=rsa-sha256;
	cv=none;
	b=bNQ07cWh6/SM2+2iN0oAKU3/8QLyCz3LsqpUy1E1kEMLHqiwzdrTg4sihnmAxFWCTrcYEl
	MQd2hR5GbYZ42EJLHGbWkDeLf5VfK/w1UnJmhgjqox9EXk7h5I7BCwt000TND1lpekDVPj
	rtfnKnzCGWT1x+Y3ciGGeU1d8GHc8VA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1A16743311;
	Wed, 11 Mar 2026 11:03:37 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org
Cc: alexghiti@kernel.org,
	kernel-team@meta.com,
	akinobu.mita@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	gourry@gourry.net,
	apopple@nvidia.com,
	byungchul@sk.com,
	joshua.hahnjy@gmail.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 0/4] Demotion cleanup and fixes 
Date: Wed, 11 Mar 2026 12:02:39 +0100
Message-ID: <20260311110314.237315-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeefjeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecunecujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedtvdehjeejudeuieejgeeuheeutdfhiedtgfehveelheejheetgedtffdtgefgtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedviedvtdemuddtugemtgdtledvmeegtddtmeemheemfegriegvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdeivddtmedutdgumegttdelvdemgedttdemmeehmeefrgeivgdphhgvlhhopegrlhgvgihghhhithhiqdhfvgguohhrrgdqrffhgefokeeivdfrrdhthhgvfhgrtggvsghoohhkrdgtohhmpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpqhhiugepudetudeijeegfeefuddupdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepvdekpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrlhgvgihghhhithhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvghtrgdrt
 ghomhdpr
 hgtphhtthhopegrkhhinhhosghumhhithgrsehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
X-GND-State: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 19E274000F
X-Stat-Signature: eikipr1re53dw5dpwzsyc67gikea8m14
X-Rspam-User: 
X-HE-Tag: 1773227025-940391
X-HE-Meta: U2FsdGVkX19amIsjmp2kPaGBucn25vM4CUWTUzf2ypWHPixdrJZAlz4JJcGkFjnqUnovw15JXehfyLTrfrj3ex5PgoYOxpfg25GEE7nTU5sA2c7DTTSkN5PODehe1BsC8Xjr6EQiX7RcZgT5gjfaI4NSfGfQi1b5CzgyyeYlmgPhAuv3+A/OWjWX38Z7D2L3g1JJZxMeSV5p1w+1EBEcHqbkkpGBx20OAweCHzsn5xHFs7pn70wCEuH0N23P6FK2cy1HvgyxiFYOjgszNzU1vIcGjVahssVkJmzE/6EiR7hrYo0yZSid5SIXqPUf6rVtjphbOGXMg29TNLcu7evkFeNnw0rNAbOv1Tg4frkvVb7wgASpjL7In8wMAan4Vd2ZYNzzMXqkPAqvfW6Vcvi1H/C2DYReI6QX+xGho0Nv2T3BEMqKJ2PJ7fZ00fYAKhP/spMsYzbBSK7dj7c1U0VQURMa+hVvu+srz4aUvtwidmPhaXm1tH5mF+K4D1CU6E/lsy+ipVBQOaLxEXsDHCylPnI3jVUn+Njet9AfO581vY6MO2fE9tEaaTQXpaZTJ/E3Vf02eLkia6QwPJ3un/n8y9Kx8TvWzMUIeeiULOXv1NnxSyjOwrvDg1n7STN8b2AquL7M2iwujVXpCLxjFQ+jtJbsXKiLS8FU5Zyx5hA24daegvN/0M2hrmTE+0X+nAwpwFVRuf9WmgHwNw4hbSFTH7vtnS7L5T3ipXZr5Lg4c+BM+NwIQyijNnf/fz40YrMcC+zlQqI1G44m2jbQ5w4RcdIc/0OBzrzbOKed7yXfOZaf8/Lshp24in7UAtimKQNhuFUrd3nI0JlwwGXfxvTbmDub4svHpI4m1C6yafMNFGbhJuDKLNIAUiniwJLCa5hpvJp6sHbgQMidI2eteeZozadNnhRR2wn1Pd5FWyv7JIxlYE0rlsQj7j9Gpa3y7WvszljUyCkGA4KDwpXsEjS
 W/ZmmkIl
 A9PkgfPgOUrj7d8yTvLd8qoFHayO+JDhuDCD6/FZyE5LiaCpHJj7TyyEBuQ8YX8lPDVaQDr9VfUP8d3zeotWQeTu2j3gxEg6tz5h09gn/dsGxlLz3/uh7Xn7cb/rp2sLwpg9wXCMhylQt3gzErDTadvPyyccybvZO0TwT7we6rEpZ0fQjJ79WfaIwkYZ8ZXJwYxOvgyMPYCwi5Mw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Small series that follows up the discussion at [1]. Note that the
initial issue reported there is not fixed in this series.

[1] https://lore.kernel.org/linux-mm/20260113081453.8293-1-akinobu.mita@gmail.com/

Alexandre Ghiti (4):
  mm: Move demotion related functions in memory-tiers.c
  mm: Rename node_get_allowed_targets() to make it more explicit
  mm: Fix demotion gfp by clearing GFP_RECLAIM after setting
    GFP_TRANSHUGE
  mm: Fix demotion gfp by preserving initial gfp reclaim policy

 include/linux/memory-tiers.h | 24 +++++++++--
 mm/memory-tiers.c            | 77 ++++++++++++++++++++++++++++++++-
 mm/migrate.c                 |  8 ++--
 mm/vmscan.c                  | 82 +-----------------------------------
 4 files changed, 104 insertions(+), 87 deletions(-)

-- 
2.53.0


