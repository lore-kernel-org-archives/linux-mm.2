Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F223FD9E30
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825FE6B0005; Thu, 26 Feb 2026 21:43:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2626B0088; Thu, 26 Feb 2026 21:43:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6AE6B0089; Thu, 26 Feb 2026 21:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 500266B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:43:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95B64160463
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:43:01 +0000 (UTC)
X-FDA: 84488689362.03.BDCEE5C
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id BF862180008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:42:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mMNDeuAZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of jyescas@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772160179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K8KhaunUckvTcRy7Lod/Gle/UM5Ecbqui4XVaTb405w=;
	b=hARV5m+vij5uB8URHEp2x/Sz4wzxnHJb1pXulJ/wx2+vpyzV52NEZQR9ZZZSaz/Lf+vjx+
	MGXi90NBvi+JkhF+Ds7Bx0NFmcDKKCuupRIXEZ6DiFJHLxGJRU5ZqLa9alWmkNTms39Fso
	R/c4RB14mbiHitceKLho1yfSNZwDuAY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772160179; a=rsa-sha256;
	cv=pass;
	b=yHBiT7E0Oz/EWjrHxSDs7s569b51E82z/Dp8H7KdlMyNHxb/DucY8AasXl6Qg7i2cTHdHl
	XnTS501DZEUNip5Bi4RKWqtcF3GdotUCUDsxCzUnGibsYLILP9THYYdg+ZQFKql0VqktTb
	wKoNmSR5KLIyXryLYrMUTcRTPVEb7es=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mMNDeuAZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of jyescas@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48371d2f661so22845e9.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:42:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772160178; cv=none;
        d=google.com; s=arc-20240605;
        b=JsTH9nTI1XAtxIeQ13MlgrUplawP3VtyDOexC2Q8yNvo97BRq11xqpgBOdiFzdUF3g
         KyokRT797KRObDFHVj5eKT/FDUdVjxT2rU6jcqPTzLkpkcyDGRSCUWY/A1IMGoZ0DsZ3
         oa3WGM9YbNiIwjPKLhJM87hv0eL2SWib9vKcrAi/G+R5tZcjPUlGjQSGOf62p2DE3h6W
         NbLxF904uokPkFXtoHuaEvdBE0qfkuKxtcJiDB6HezeWrnKvmlUI2xhRFT0kr2cjXdj/
         i64NSts0Yx2oOueHeJG10KQUcJBxFRv75XDxP+4+xOj7gZL2/SeKvsHhmTbacGtu6tId
         kDWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=K8KhaunUckvTcRy7Lod/Gle/UM5Ecbqui4XVaTb405w=;
        fh=Z7oKZOdjCaEHoVIOIgC0SAFSzUH3dsXLJXJ1VQ6jkDQ=;
        b=OtVpCRRc3CJSmZ2djAc8ijQ5pxsrmfR02Xoym7GINZfdy/Za6Qf9hTMfjTTCs3UxzK
         smBWmg+uIs4QOzrOyMjTA0IBWxSEv5o3vjxlRnnCasy4PY83VLAs1rqIkIOaT5ZpzLue
         tDQmsp7bFqkBHjEJdAHAcjAmzJ+Kys6woCSN/3oFuAgtad8H2bWDeohRv1ejQ/Q6SEDM
         pxcrhH+eXXMBopby80G1iTwFcplYUdRD9Gz7sJ/Z6zZ7MxRebdJ03SL79Yuravtu8OFf
         tKacBDCXnhFQ5VUbMPxLilRaoDh+S8dpxAVii4RhYZx76OsWuAJC9sI4srSz6qdb8Uoq
         8V2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772160178; x=1772764978; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K8KhaunUckvTcRy7Lod/Gle/UM5Ecbqui4XVaTb405w=;
        b=mMNDeuAZ6dn0up0A/jeU0JWmojl6msF4zl52jy56/LkKdWwWGeBijNLW2RofiaXN1T
         IbbZb4l4Z12jM+P1uGzRNImB/PpH+OzFcXPQV4FqfErPRkW38yPhd4exlYoj5cN0rc6W
         noK96FRyswv90MRsLm7HFk3WJYXdfjfEU7Vi/xray/KvcBHW74G0QhCOS7tESFcHUsDx
         9DVCYU07KYaqrLcIM2QJQUuGg8A2WUkXXFgWa9fnDCQIxpjUp9YNtky8j1GUD6WPZwgp
         +BXR5N1Wz9dbQmBbeS0XIv82qG9UHE2eKoOyvByKLYOfQyyck5yy/YAMmSwn9vt36bIZ
         8FgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772160178; x=1772764978;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K8KhaunUckvTcRy7Lod/Gle/UM5Ecbqui4XVaTb405w=;
        b=B96+Nma/bOghNhjeCZzmOpj51gpgLdwgnBXr9Xm2ZvB+yLvxC0u9s0kanfTkrSbU37
         Qd3cVYf6bAJuzNAGgUa3MAgSgN4VitZC2MNt2TM2I3T4d1LRhqglhiNJGO6cM9XsgIhh
         bLfXuYY/99ENnjxRYzGqMXRlIN5tACK91w38V8gzDTXqNG3OeSa1ROlFOGNjjnr0ni+D
         djpwlEaI9//9BjE/8M7WZ+x5zNPLbdIjvp0tE+zePilD/wKioWlINghA+znmkJTPmCs1
         I2iWrMSHuMtXhlKmP2/efHOp3sUF627zF5YAavboqBj6VvD8/Kc4Ut5UAT5oBPka91PK
         /MQw==
X-Forwarded-Encrypted: i=1; AJvYcCV3QYnbzaj5pVdnheZqn5e9j3nj9uuujxmZHaH5j4bb29UzfryE29WgXqAMbjT15qfk7gWdDwfnEQ==@kvack.org
X-Gm-Message-State: AOJu0YxVgYIeneceCrROeu24aDws2IhWG4lXt+Q5lXiQGAI0rPFuEQRL
	a+cO8SCE2Az6LwlSvbF8/gziejNqoVP0zMLU3eokyor9Z1XlkO7XXy8vUVt37NHqksYSSUOQ7iD
	7fRfTh56gtMQ3lpcYHNqP7U6W97edZuV4ZgJk7qaa
X-Gm-Gg: ATEYQzy6xk12Vh5m1zH1vT/F9gNVdjN7fiq1FlfIDAzgS34OqbxsksXSKeXYM0X+i5u
	rghF7IzE7ViQRFYGRjrUfijjvmPQh0m24qb8QdzxaAfZ81FmcJvLtvNgAGzyhmoGkm0ZYgPZsao
	NWCQ90m+N4Lqv2fmnZQtVDp39CkbH9+dui3f/4WNsojlkJwPKkl5DyEbMoBpL3tn4VAZWJU0OLS
	7HdWluRsCkOCuUH23niGBav9cDvu+NsH/wBwXbfegKWITyEs30/KVwlVc8aUy0VE4vAcHqnIClE
	J32+UTAlhYgZa0zEfvIXD1NiZ7XcSYvgIHc=
X-Received: by 2002:a05:600c:1591:b0:483:6f85:b16e with SMTP id
 5b1f17b1804b1-483c39ce73cmr1075355e9.3.1772160177705; Thu, 26 Feb 2026
 18:42:57 -0800 (PST)
MIME-Version: 1.0
From: Juan Yescas <jyescas@google.com>
Date: Thu, 26 Feb 2026 18:42:46 -0800
X-Gm-Features: AaiRm53ptxz4THgccfpAqfjiwNQILu2CJgmIYBTAP-wyvl2ZuKET-BwG5u5tVeU
Message-ID: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via debugfs
To: Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	android-mm <android-mm@google.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BF862180008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ougbez5d5kqo5cp4s8tu1sdmciawdwaz
X-HE-Tag: 1772160179-241129
X-HE-Meta: U2FsdGVkX18mZqz8jVDM6FVFLw3WcZpaytH/GemnomxOogdCZXJ/uEcZBoqsocAiwmSXdcWXAxXO8AjntAprk8l7vPizcxEtKug33a9FH/Ln6eFfStUgBdGHZK+pR6No5bJe387ideZrQmF3XCyua9hbR0aZi+eGkAWpjlyaIRr8eoEwMXxAyDoSRZDm7Ue9fq5ImBVqcIdCbd3vS9GM0Zod0pknQ1d1RlfK676AC2ZnU481/36W1iv4tbBWgxxYrGX+n5YXOHcoDwsBCSuVhVQdi1NZ92DGGxRjaj+6N+ch8rhro6j6oqpAve6a1q3IcmJhFmZGtPMzRIyx6sFaIn5V4dBv3+eEq8Utmqsmem/YRvcjwc33qhiT1kZHpQy+ujluTK5Grfh7xjGDInwMVHMrw9gV/qOZ/uBwPfDuC6ukFvU1zUQdXkdT1mtH4vVvaNSqgRKRUOTYaNP18Q+eRoTZJkBQUMNtOV0uy8NriYx+Z5mm2wa/bgerHaYBVt1Z1niCdtRtagFn7eXM4YBcXLS7vBOy4ntraENBCUqCRdq8MDySX2TXh1w1SsXNIlDwWEcw4kDMWDVKTjHas91AoO6feIlg3Zmeu5zHYWBMhkNyQN85iuN6o5Tw/W04nL+N9lTzhp9KdZCVpXLzggNajOCYpfbqBOQjXo3laYLJvzB5VEREaDolP0Jcj1dB2pCp4tWyRPqcNvoQKJLRxnmPSZENkM2Bivj6R/vY1+/QAqWI0uTufvjeRWqEdzeM31sIH/fAdJbn+AL8Gc5yFUNBTLRV93FN1hyv7UdfPZ7viSFSlw4j4qhvKF7vLrShAlSGjwk7HDA2aauBEknc6jmSbT+Mtfm0KMafLHa0EGUJk1NNqYIf9aPiZWaRFa3dx6CoBJj56mjXiC49dGImzc5BYKI8P0XHOwC7eWFl1tNOLFEmzRZWBb6d8oMAm0he12UfVXZppNR4pB52u1EhGZp
 wZO9kCet
 ij6GrGYI9+LKDVqlKhNi8v4TamMC5iqft+PYA58L5HFWLZbDqhEiRCBz8ptSEAWsCRWcMg0ee9V+LdxwL3U8jWgrLXejpeEtmwhM9jWisEPmgYWKbdz3DLZHTFndiXo6SDtXn0if+AKFBcpx+37Trkw4KKcLbSKM1a8lgLC1nKQR3hwlVjtxkNuisrUonQ4RaqAnuUD7nze839mXNb+8rJyyr3SbRcAmC5V9Iqhbm18vlamI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi LSF MM organizers

I would like to propose a discussion on improving our ability to
reproduce complex memory allocation and reclaim scenarios, and solicit
feedback on a debugfs-based testing interface to help trigger these
edge cases.

== The Problem ==

We frequently encounter complex memory management issues in the wild, including:

- CMA allocation failures due to pinned MIGRATE_MOVABLE pages.
- Page migration and compaction failing during reclaim.
- Excessive reclaim loops triggered by specific workloads.
- OOM kills.

Reproducing these specific memory states for debugging is currently
cumbersome. For instance, consuming most of the available
MIGRATE_MOVABLE memory, or forcing MIGRATE_UNMOVABLE allocations
specifically from Node 1 and Zone DMA directly from userspace,
requires writing custom kernel modules or relying on unreliable
userspace memory pressure tactics.

== Proposed Approach ==

To simplify reproducer setups, we are exploring a debugfs driver that
allows us to perform highly targeted allocations using a
straightforward path-based API. The interface exposes the node, zone,
order, and migrate type.

Example 1: Allocating 2^11 pages from Node 1, Zone Normal, MIGRATE_MOVABLE


$ echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-11/migrate-Movable/alloc

This generates a unique handle (file) for the allocation:

$ ls /sys/kernel/debug/mm/node-1/zone-Normal/order-11/migrate-Movable/
8343cb1e-cc57-4753-a060-e152e0584e36

Example 2: Allocating 2^3 pages from Node 0, Zone DMA, MIGRATE_UNMOVABLE

$ echo 1 > /sys/kernel/debug/mm/node-0/zone-DMA/order-3/migrate-Unmovable/alloc

this gives

$ ls /sys/kernel/debug/mm/node-0/zone-DMA/order-3/migrate-Unmovable/
b5f607ec-eae3-4aca-b8ab-4335a4338a1f

To release the memory, userspace simply writes 0 to the generated handle:

$ echo 0 > /sys/kernel/debug/mm/node-0/zone-DMA/order-3/migrate-Unmovable/b5f607ec-eae3-4aca-b8ab-4335a4338a1f

== Discussion Points ==

Rather than presenting this as a finalized driver, I would like to use
this session to discuss the design with the mm community:

- API Semantics: Does this path-based structure make sense for
targeted allocations? How should we handle metadata (e.g., cating the
generated file to show allocation details/status)?

- Extensibility: What other memory shaping or fault-injection
functionality would be valuable to add to this driver for the broader
community?

- Alternative Approaches: Are there better existing mechanisms to
achieve this level of deterministic, user-controlled page allocation
for testing?

Thanks
Juan

