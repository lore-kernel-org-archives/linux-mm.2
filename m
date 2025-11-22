Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9255CFD2F3
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 21:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67C26B0024; Sat, 22 Nov 2025 16:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F796B0026; Sat, 22 Nov 2025 16:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C086B0027; Sat, 22 Nov 2025 16:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A147D6B0024
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 16:19:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BFF61309EF
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:19:32 +0000 (UTC)
X-FDA: 84139509384.05.3AF84AF
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf18.hostedemail.com (Postfix) with ESMTP id 182F81C0005
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:19:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763846370; a=rsa-sha256;
	cv=none;
	b=EVsfVghASKJ0W0v0usNXq3RPgllbWW9tVGavddiz1O6ZqNbZLKmJePHuZ98sAOjb08wkeY
	14PlkIuYPgR0SiTCyxp8sI0fchZ8L+5Dzic/pF9QvANLLR4oWRCWJFWGNTdow55VRwSELP
	BrVUZtGooiDLsZS/eR8/OkVuAuJdFX8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763846370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+Rkzknj9zlr69ceunzTc8zTLJ8+dKdcnyi95V3lOBVg=;
	b=Fnd0EBmbaFSZQlkOp7WRHzzWd7I8fBTXwwXcg1ATKxMAp8AFdEu2EE3iw9mJaF7r40TZei
	+NcWSKbLj5SfbkpFIdrd2zXrAQitusQxujsNkyAo66mjvCDzj6nR1jMM5+9luualj7FDKB
	bhuvBms0gsGoypA5iJi/ttfNMQNx+98=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 5F9A02BA973;
	Sat, 22 Nov 2025 22:19:27 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 3Il8KscnqSO8; Sat, 22 Nov 2025 22:19:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 196282BA979;
	Sat, 22 Nov 2025 22:19:26 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uSCWT8cKas0p; Sat, 22 Nov 2025 22:19:25 +0100 (CET)
Received: from nailgun.corp.sigma-star.at (85-127-105-34.dsl.dynamic.surfer.at [85.127.105.34])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id 5146F2BA973;
	Sat, 22 Nov 2025 22:19:25 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	mhocko@suse.com,
	surenb@google.com,
	rppt@kernel.org,
	vbabka@suse.cz,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	Richard Weinberger <richard@nod.at>,
	Vladimir Davydov <vdavydov@virtuozzo.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] pagemap: Update BUDDY flag documentation
Date: Sat, 22 Nov 2025 22:19:20 +0100
Message-ID: <20251122211920.3410371-1-richard@nod.at>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 182F81C0005
X-Stat-Signature: hyapzd6ycop7y3tt4x6mqhte76qxfb33
X-Rspam-User: 
X-HE-Tag: 1763846369-347157
X-HE-Meta: U2FsdGVkX1/02YV/rUtUbX6zJEyvbbMUW2h/fM46l1zgmbMz1A9d4AniRArqV7vwuFjw0lxboHViDMJ4ayWPQwHNBki9WBwu7p+LHdRinjmYHpicOdxr4eWydNXXl8fU0Fw/W1SUrMZaIuAv1DVSgpapxUTti4QSUQ8kZFAvtur92IrwmPZqfXj5MjL7thnnrG8YAC+icIasbEjxPCh9/anvPWKtEZ9LKu74xBDcwpSz/qztP9o2iht4zmLv/1pTOm1Jhz/2EObn/D7t+Zs8XEGe+bHbeqD+YXDUqZxbAERwe3KeKTAPAy2DtUM9xZPYLksbQ8AuDZCwqtu+qFKYyUMXNg4v0a5t5isktVPVMwFY9mBhKLMtxalx/oi8dGyQh61If4OXgtXXwrCBdUq7CGysAG7smXAIASm6Dzxopw3PMJbfRG4l1JcWF7IWsfD/CzvVtrgCtJW1BzPBxuNZ36t+1NBji4qNpq01W7dR+jCN8ZmkZJ+sOpYgpThXtxAU7XKfeM7j5gPFx74CLt+qM1ImcICyr08WdCZGWpPEzXwbmh+GagTDI0raXnDgTd3gDIv15lMi4cdBpcXYQF6LeZqbYYUNFldzVRME1mJu5Sl0+qlOVJAyJUxYUTPycVRS+a+29ha6+OJ6CbJm9X/sg1258CJWnbtZVuYi+DuJVtouAxZJUEz1C9xFnVFZWLi5ICuf3fUxTxh2Z/r5D/sbS902yIrFXuHmL7pEuA6kHXt3UkLcxaC1xNj3etF/3FHevxUH6cvkpa3ohoT1wojypmQLv01GQu7Obrl/Y42AXGC/jS801u9BX4d6uj0lylxAzTX2pEVNWf/fe/pRa2Yctgbn2sxE7xRwi6noElcjYJnAamdRMLweOaYlrMVfUTxTUkVqlD6YFCCmAZd9UB3WYeAGN9HZEkA1AyoYqZoDzg59IXIZb5SkZeuQN6yMW3uRMKnw+tquicP2lvNkgcj
 cAHdgNzT
 /obt+psz70w+YRV3OZgoQy15zLNEb8R/FlC9okKtsRS+kV+RHb9PudNE0rjlM+BWqqV8LurkLp1CjtKSLjjfs28ZManOQ2alPm6wDpg7UR9qWhbZpllKNHqrdwmtWthda+FToFnm79vLfJOjUSkZ4ReIi2v6MiBXa9fc6N0AM2RudvpiSVxUAbFkQRj5fuMR6pKm4L8MNu1i+Q+/u7l0UqOGXt48ejpkIXMCy7ZLJrqsInXVHmEznio8YZUhCyrtYouhV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since v4.6 the BUDDY flag is set for _all_ pages in the block
and no longer just for the first one.
This change was introduced by:
commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for "tail" buddy=
 pages")

Strictly speaking, this was an ABI change, but as nobody has noticed
since 2016, let's just update the documentation.

Cc: Vladimir Davydov <vdavydov@virtuozzo.com>>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 Documentation/admin-guide/mm/pagemap.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/adm=
in-guide/mm/pagemap.rst
index e60e9211fd9b2..c57e61b5d8aa8 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -115,7 +115,8 @@ Short descriptions to the page flags
     A free memory block managed by the buddy system allocator.
     The buddy system organizes free memory in blocks of various orders.
     An order N block has 2^N physically contiguous pages, with the BUDDY=
 flag
-    set for and _only_ for the first page.
+    set for all pages.
+    Before 4.6 only the first page of the block had the flag set.
 15 - COMPOUND_HEAD
     A compound page with order N consists of 2^N physically contiguous p=
ages.
     A compound page with order 2 takes the form of "HTTT", where H donat=
es its
--=20
2.51.0


