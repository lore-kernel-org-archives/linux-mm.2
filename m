Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51FC3CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 05:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9199E6B008C; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1196B0092; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806B66B0095; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 594A76B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA4751A014E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:23:47 +0000 (UTC)
X-FDA: 85320089694.11.7D707BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EE09140003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:23:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IFFOjUFY;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791955426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fxsf/nP5SXEDzQE941HiSMs2LYMrqlNVsr3+X2+Gtj0=;
	b=dF5m7BI4RW3n0PezKTFBUey+YBbN48UpOmSPqka5Wo5xbjqGVglx6AYCnstr2Om98eNgwH
	PvFJUtwwQztdIdc2L7OQyshrdEviSXokDOGSgC0SLYdXetbV2j4e/JJ8gyOnFeOkOzc1TM
	AlhXaOZWZcWMQnHNBTQ4HhB+l6+E1UU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791955426;
	b=YUiSI6uaXCS6gb7CkrxCb71fKoTg2upQqjovMIir0uuARfVLXN/g+Hi2S3drV8FjYLgtNv
	NXJx2+pd54klLmgjA1HhEmNhmsqg17STCcLqRXbyOiNfbcjjAHoMW+6jZMGhJgvYlG0je7
	BQxY1zHtltbTWmAGbZGkzRMQFWiimxg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IFFOjUFY;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA2774408A;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27301F00898;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791955424;
	bh=Fxsf/nP5SXEDzQE941HiSMs2LYMrqlNVsr3+X2+Gtj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFFOjUFYtKfiXQRi+/4VGn8Cho3PFcrjt/KLhzAkEOul4ZhDMTbBc8/8jnakxDy6g
	 u53u66hNQWsQXxC1bFiGsUWo6mjwcEkvdeUGeLlyvEMAUs9PbN2psfT88MDLt4ZXJN
	 m3e9Ffg2r9ivSVzyurM4Qn00rgI8ldjMXoiOVLn/Hriu8HOarpxNStEcgXVFObFOvh
	 3CcmRi90wHUY5mqzDStkVnK9Lo+902pPPVBfTub5HgiqkrBy8CsqLp5b8uuE9pa9Gu
	 Eq2BIWK8KoH40ON8I/joRIBlLtboMK+UzRp9S53IB0mEe4VtuhneFrf5nl/ZGU9vdN
	 aqLaVe7bG3hzg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/2] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
Date: Tue, 13 Oct 2026 22:23:43 -0700
Message-ID: <20261014052344.384723-2-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014052338.nothing.279-kees@kernel.org>
References: <20261014052338.nothing.279-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=kees@kernel.org; h=from:subject; bh=4xzljaoL3zgY9ToiX0DtctuAz0Su3Z7YnVQTIWv8yDY=; b=owGbwMvMwCVmps19z/KJym7G02pJDFnnBe8Zz9wX0td0zKxNvuJQ18PvdSY7ejrT1y0uYhF9J TVtZ2toRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETEFjMynMs8c+Nvx2Hl0t/P 8gIqCgKaxXOWq/M9bfQx2530uDvKjuF//Wo+9ZN8JyZJOJi8ab8Zc+SDRPyGx9NvFZTPFJQoX8L NDQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1EE09140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9umgjc9fjkei6izd6x9jngxox3ooa5bh
X-HE-Tag: 1791955425-726287
X-HE-Meta: U2FsdGVkX18DTfc1WSdERls7zSkk2yHwVSpdM/oQik4HjGWmY8MCQd33KlSfvEdLCxJvIHO/0drYil19f9upjHgSgkYpQtp2PFs2BOmzR5rCrc9QKfIxWCc0Whena0Yg+v6SQ+CDQY0Thm1URjVYsR4lVoAqZUYD6ViWzkD4Fo6Cv5HBi5CyQoVqGvHWK74PauiuNXT+xegqwwhjHh5k/7Dw6Zi/sT5PQpK5tVbwCE1dYgmBm6gScFj+9s3vStp7sldch/oijz6j7lJ6Kpi+q/lArzFWxxtqEr1y47+Fhmyec3Pk/lMjFCDqIkk5joGg5/L2CrO+rYA78rzqdKKwlcsvw5V1iAQVDgYFLbk5gTEXcCItb/QIdT7QcU2ep0Nf2cZkU5qbK+ZTqjcQHldyI+dJgRquJR6aI0zCFx2txduigWaJzlIPP2OnkBcxOL0uD73JB6/ci1+YoSAV8lvZR+r0pjk09/0oYSC+9plSWMjZvYE9Wom0JMKFv5H7S8FAaJFdvS8n6yMgE7XDurq1uc2X1yjEyjJ2BNWzfXjWyslbgtadvp+Hd6aYHuu59xI3M+rLB4AmRRyQgXt31/U+RZKyYJiEHCsMsRkEdbYfP4SYwtV3D57ndFceHxK9W3OIOE+HcYifhrh7AcTUaeeIABOR0mEMC08894ZX5ZuGTDk+hig3n0NjI+krYqxiT03qlQvivd3aYNk9OPQrMGPU+PojaCmnTH1bJ1T7DcWE495iAPhXQIZYoJ2H1oWz4E75SqQuUx6wVM+oYfwtatJA51Y+q+6pXMmMVVZnECAV4Hq3i2el0mAd4vMxLyqWT74WhpDnX6EjQ2nGkwIhuSwtDtc0I18dDM71x4Y21WcLEeaRRIv7t1NPFHCvbA62LUMweUK2d1I3CTRaHjWtq/0No4XBWeKQi8LG0+2y4xdCVXHxLFIo4A2A56lKN2vM7Ogur9kUck9+AMbm7X6UDEo
 l75EPzXD
 jLg2avJxoIhUDzAeFRNGf0rYx4hh/iMenVTZDk1YUYQG481e0vshNoYIaZ5VvV/sumM44xU7+MXt2A89zfL0f83Hp4FDsiibJdsXnCXGWx+FuDRDC8oBUEoag+oD79NULpcRtlY9kuEZWAiSPzpmMGuS/nJq6/lTF8RleMDzaf97LSIBuT9AJmuqIkXRcNiw3DnnhJoxAUeAT44ofjHBlhWDfsSvlFtXJy7E49Yfj5hzx7qpkLjguNAaW+TRl18M2CO7R054ArGFHP//ho3oU+hZsS1pDuIRNA/J1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
accounted only through SLAB_ACCOUNT on its bucket caches. With
CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
which do not account it; the same happens when kmem_buckets_create()
fails. Either way, the allocation is not charged to the sender's memory
cgroup.

Allocate with GFP_KERNEL_ACCOUNT again, as before that commit, so the
allocation is charged whichever cache serves it.

Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n.

Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
---
 ipc/msgutil.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e28f0cecb2ec..12663a40e9ae 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -58,7 +58,8 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
+				 GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
-- 
2.55.0


