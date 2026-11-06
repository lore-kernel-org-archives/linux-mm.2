Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E24606A336
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lKunDg2N
Received: by kanga.kvack.org (Postfix)
	id 0C3C86B05B0; Fri,  6 Nov 2026 11:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0747C6B05B1; Fri,  6 Nov 2026 11:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5656B05B2; Fri,  6 Nov 2026 11:04:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9D106B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:04:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6567A14010F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:04:39 +0000 (UTC)
X-FDA: 85405167078.05.D040B80
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7C06160019
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:04:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lKunDg2N;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793981077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ge/zVN4OrHH3glz23GfvxcZb8aPxUfChE7sml4cA/3M=;
	b=2mE7kowjNON1K+q08+BGvaeC24VWGGc+Amcp5L56kHsJBIFcosBxSH4MBzM7ibfyt1nsFa
	skFpWrS0xVUqxK3dV5kMveV9nMFmvcCgrDPNFv2YQpV52GMv3ceOmhRhcooLqxKPTDcce2
	578K96VxeB+3m9i+Kslspw59vlBB3AA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793981077;
	b=TuytoWBU9IRXJ/Xy3eY/YSSfLKBbTbKmAURDI7NEaIMWAP5ht9XjzAHVy1hHaNVnL3PePZ
	70F0TAW//MvljzDjQiuNq7RVQhMYfXjHInSZV+IVBui7BCtZ+tpqMJu+qXtxIV7+cbXBmU
	BEKj6GzKWpOAKwpsgzddPBhzTxLVIYU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lKunDg2N;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-67990a45e02so837813d50.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 08:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793981077; x=1794585877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ge/zVN4OrHH3glz23GfvxcZb8aPxUfChE7sml4cA/3M=;
        b=lKunDg2NQi+dixw064EH88BO9EPcOIQ85vya6jpiJDcoCWAT6XSUIq1hzu60gqtspZ
         GD/Zl3bpfOL0L5VIFWk519dUBZr/T2YiXpDEeI5qoUlnxkI9qbW7LmEE+AYlWEXLImh4
         M6fffY0P+l0gf1f0MdwRNNjGLeuU53vnUEn2THZ0fWAb+rHHd+p1rmifnXBOsia8Si11
         lTEP/Gtnyw2ZNYHOx8CLpGdIn6L5EKjfmjcsTbxNSs0u5GsiONYNfsVSLyFVtwvKJ/8g
         FBB7CCfEydsX5xEKM7fo5tmNYC64GezP8GTYUaSbhbibQ6BrskHFrl8Rrc71fngzYN2J
         WLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793981077; x=1794585877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ge/zVN4OrHH3glz23GfvxcZb8aPxUfChE7sml4cA/3M=;
        b=OLSZrF1mw1qMM4yL0ObcD8lobIJ5HQPu4vdXerh41ya29iIzZR2AckO5Hfiu+xc+dL
         prCNbRlfm4s8c9T2lben+7rSm+GQ64wN9RvG5/pnfxBHYZRsfTFxZlORG4HZLrkT7PhQ
         5GsdBukFOwc9KLpbWXhfYgAGDrZP6+lBgX6W9++QAdrgJnshF+AMlo1/E1GF3hrXTd1F
         qi4FzMc/uE3HyYFqGQ5ZTgZi0sgcPKt8JD7LAFBLKeuMu6gUv7lCrTkXc1GcQ3c/h61X
         t5DEnxFclq+14i53YiYIGvw70sJkCyeqnjqlZKSnw07HZ6fAepwq20WWPg9HzTY75cg+
         xf5w==
X-Gm-Message-State: APuU4Z+3GUOpU7M3OhHNsJ4pHTMQIusQO3/Hp3DnQuIMWfExBXD85RB4
	V9oPStXUwZ68OTzkzMIzwdlX+8ZCHV+sxS8OcKi3hkeTuF5Ce3j3KiFnL8XcL2I+
X-Gm-Gg: AYBFou1u9C8e4mBQjc3941zFeqrr4oeLJgBQEMwh+UkQRi9zyr6GAHNdd0+0bBzqaVK
	hjaG98kfk4DJMqYzJtJ7XxXraFac+2gSPQWXk3EjxA1V74XyjkWxcnkOHtmZRZSzR2mZ4DJwhFk
	F3bhsR8ah0PhFpyO472OleGN8Un5o/1nrUkRIh6FaLkDa0hH+R7dauv0vD22Qfuwb/Xgnp2i/WO
	xFI+dT0CxBU1hybivy8wNLRQe+eBvGTHR4eUYoLgvhg75vLb0q/YGztBP+qfNOm9HnNgclzrer3
	ecKJES+as9hMpMCU1sfnZK+G1SLz4HncXggcXw3NuHY9ca7iY2rqjM4HJBD5OMWg3x3dfDpqWjB
	xNcJRsI+drwkmNjm81Xmk0FoOhcX04h7dA0qzP8xldY3nuw3wwGRILlMZIE5nCR3lPgt+XTdKzS
	1RkTwrf9rYI2ou4izH8LOHLYJAUEGb71urX6DGMwqQodXy4IHpbBzowOdLtIzF+cpCLdmfOFr4c
	gBxkx3xSjUyDCn9b2CfQnoQSLa4XywY1xo9/IUSCsoaT0J4DPK+8lWnKw3wKDkmXnQKzfNpfbz3
	szCuT8WGZ61ExsVDMR5nkifT1O/wH4pCyVOT9QA/sNIiuIpDEvaLdm2C6r8Y+xuqhO4WVUjoW+6
	jNYWyPU8XigY+LuBc3DzDXgbahtmqnPnCMvhWaw==
X-Received: by 2002:a05:690e:228b:b0:679:a650:a083 with SMTP id 956f58d0204a3-67c1428a29fmr1291761d50.21.1793981076502;
        Fri, 06 Nov 2026 08:04:36 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:1a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f770cc6sm21382727b3.9.2026.11.06.08.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 08:04:34 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	brauner@kernel.org,
	chrisl@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	ljs@kernel.org,
	mhocko@kernel.org,
	nphamcs@gmail.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	weixugc@google.com,
	willy@infradead.org,
	youngjun.park@lge.com,
	yuanchu@google.com
Cc: stable@vger.kernel.org,
	ryncsn@gmail.com
Subject: [PATCH 0/2] mm: fix swapcache writeout and cluster table publication
Date: Fri,  6 Nov 2026 08:04:30 -0800
Message-ID: <20261106160432.2552507-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: prmr3ocf63jegqwpamy13nnsgep3gd11
X-Rspamd-Queue-Id: A7C06160019
X-Rspam-User: 
X-HE-Tag: 1793981077-770640
X-HE-Meta: U2FsdGVkX1+Fm7MQSPAImljK2pt//sPzDTVCRhmKju19sEBfMiqgG5bkKQ7coRUpL5wUy1IDf1KaPzj/Y/MuAObDudzJqDT+FwQmrooRYpqgvDZ1tVguIWwpDDksPm8dZsJPHxbJRLD4n1brMOqFZV9JGPcwD7omZ73A3UNfhIdskeasCbo0bte9ROsxVlLNXvGmyVexnjmuqjR2w5kV5haQwGTdnlPHMgaqnzdt9Q/OkpV5hInQ2vH3YH2Kt2AojKI7OifbT891bJfS9qRaIdBrzYZA+PDm/0K4Uke+Frj9SSguip4pFX0MjE794nU9Tj/xYPu8NcxT5w2a93NN5XXaNx8b/Xl4mAMGZyAwQqRqqgtFbdmLzlx5d/wnQODa0/wFpo5v/TbfClzXAmN/mrlRtXkOA40qAl01TZNMjGDJgOFmXYbZUWOpwe5PmAoiti+zCTJ8VKZ2c5n5YY97dy19Ii9SBr6cDkcs5egEFHRwL9hrNSO+YAH7PBTTLW+CAyqhVQAfEujwXAFalijRD9JOljVfWEgjmQIxwqDuzRPRL8Zh/A82ifiIqmbwImrjtYKtETdkPCiDjX0q3Gqre6xf5eAMnxFpQ8WQxpdWHFV35pJx5mzuZ/+eocrxGqWhJvdLZW50/yEEmmpNInforxm6w3l3VTHeCUVGGHoMMqK/tTtAnzino2IWXCrsM+x/9L2YYrdQg0zGeBcKSwDU/8uReRnizUpj7+t8wgeP4LgsuKpdZEiL3riPIuNOZJuJ8TFGlWn/6rlFH3cFAUunCsZkWU8OfmsnXkRzt7thep8dcvF2xc0Mq01jgP4EFprE8OzYwgUSVAAqs9zIqSeV/vbgWJ4m4LUtGI0yYltvP/I0Ir6BgMK9D4N05BnYvLNUfCsQLc2djhyxHbq/Qogyma3TJWN4Xqpp7dQ6K1WOhRvrwOGw3I74R6zjIcsmQjK4wlqhBcc/BW+fNJBlPGj
 2C9GmvV9
 h2l22v2eISrpjp59TTyeIvXEJftJmN3rGvbRZfZH03iiKdPXyPmisXF7PpG24p7ivzf1nUvWFMK1Ph/SosbLbY+gclis4CGjntwjYTEf1efdxMnvSSONKDbAs9EYFAxaPl+zc0bdF3XseE3MenYg/wNsXJnaCr/AQVbzPBew4ZWKPugIdJAN7E9h9zLger57F+CHKRKe0EUhigzZesXRopchF1twSJ88lbkR99URypa/IMX+Eer5q4mM5rXxIn6aMCpmTH0n11aXXX7Wx6WrGskAnne680/yzZqLVed2fDJBs7WGAhdPuSe6dw+x6p7Pd0UiE6ea23Ywjb4rE/zIO7bzKZ4+WaFD0+CoXMXDyoJCvaeC+damHLhZmzOzK3Q2d/2/YC4XY9qDV6Wz18vngAZWDKKThtEmGpPzzJ/Lg2hVIIKZ4C6XPwje+HQcYpG0Hfe2nFNVHnQpynpsWaVUF6b1ojR0g4AtrKuBM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sashiko's review of the vswap series uncovered two bugs in existing swap
code: reclaim skips swapcache folios without anon mappings, and cluster
tables can be published while allocator locks are dropped.

Allow swapcache folios through pageout() and keep cluster tables private
until the allocator locks are reacquired. The second patch completes
Kairui Song's locking sketch.

Nhat Pham (2):
  mm: vmscan: allow writeout of swapcache folios without anon mappings
  mm/swap: publish cluster tables after reacquiring allocator locks

 mm/swapfile.c | 106 +++++++++++++++++++++++++++++++++++---------------
 mm/vmscan.c   |   3 +-
 2 files changed, 76 insertions(+), 33 deletions(-)


base-commit: 32959c9a49d24faffb39413322ef80014f88dd16

