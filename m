Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805ADC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0A16B009E; Mon,  6 Jul 2026 09:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688286B00A0; Mon,  6 Jul 2026 09:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EEF6B00A1; Mon,  6 Jul 2026 09:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30ACB6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:22:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1338A0345
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:27 +0000 (UTC)
X-FDA: 84958415934.03.DB03438
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5AEA5A000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QUmHvrdC;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=69Iw3ttPHMSwqcKdtxg8NfnU4eIjfpVhtKG62i044oc=;
	b=mK6j52CT1tk9bDkqXyZu0/9/Sc2GWsJ6miOEFMDIEG6wwoVhd9y986l8eJI8aly8PTtSe6
	ateOBdT+sXB6OcMTuHYJZzs4tcU7p/ouc3YbS/Y+hDKCBAOFs3/A735LAUjqKWDDFe2e07
	ptsnipu/ISY8ORHC+T88GGYzHd2u5sA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QUmHvrdC;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344146;
	b=LSARCCP74vuHUTp8xQ54U5InAu4KK6xrGk4fGMJSORhy9rF9D0yfZeCPGV9h0IUmNq99Jj
	PsCI6wE4CKbcll5Rh3DeaXN78UJ2jGg5MB5TJPHCuu9ywEh9/bqqyQ0Uc7n5Ex3movhDW6
	ZQB7sU0PYZG+AQMkIi9yxjR3x2hrexc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=69Iw3ttPHMSwqcKdtxg8NfnU4eIjfpVhtKG62i044oc=; b=QUmHvrdCiFIEabWfyxPfYJbr8M
	1gJuiLnpAIGJTWu5hEoMKjk9f+bmNm7uy8tkl4UjlG/il+uQVyoYrZihJ8RR2J2FyK1M+I3oifHxi
	7vu4dS8HImWQ/N9Wb3Nl6SBIZ+t6E5aKoKfL/h4Re52OBrI3SG0iK9F6h95M1MtXwHAMS62J6GF5d
	wyPGu2BL5b9l2GLtOlf6CpknNumGmZQesmF70GueNnjbFcU8ZVFaP6nhQj50+vG5Q/y0UKrIOhtH/
	S98MzfNpUiuXcx8+vw7UfnWskyhVqQMcEv7dg783EDcVl8pwUSV/S77C3NhEifga0atpfXVoWFaGw
	wlFX5MCg==;
Received: from [89.144.223.34] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgjH2-0000000CaOx-12wB;
	Mon, 06 Jul 2026 13:22:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: better block swap batching and a different take on swap_ops v3
Date: Mon,  6 Jul 2026 15:21:52 +0200
Message-ID: <20260706132206.935272-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 5AEA5A000D
X-Stat-Signature: gyow31co18rpkoihjxbp3uqjxrz8cqa4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783344145-180415
X-HE-Meta: U2FsdGVkX19S09fZxnC9zkvg9jqTJRw3iWzTLOsRc7rz3CDnHZ1Aa+bDhXYZ4iq0aA36jlIbIMickzPaBurjvvNrOiVnfxme+sxUll41aO9ldElTVwwvpz8YOjNdZwRgIWEXLiWgVkhqvzX162pzFIG9PS1l7oqxKTMZKeuOasbgHNZD5mbgA7BmoRoaP8dMeLFO0SbnDoxck4WV+CNWdyukqNJRvQSGcOpfdkJrTLiJLCQ1gKGT+MxAN5Vx1BwABsC+ibgxiG5+fg96cTVUluU4PSOKBeN/Cw8FKwzKflGcwpzTad71n6AeCkr4ejSzakWBBF9cV1pVdkVhr2B6/G6fvkPI6qM1gHQGYsHt+QPw3gJ3U+uMsfCqK45UV1poue7PdacCUnT0vD7YCMpfLhkbSrK3o5nxWOnxPX7Z8PCF4xTl0JjUKdI5YgFkM4teQVWxRWdV1SXnRbD2nflxyHPk/LXIk+OQPbbUZQ6B8dkhI2vFw9hYpcRUmMFxi/j4SYNfTNMr1S/ywU+pXsBDf/VfEHpRXyX4XnWOZY4HpufeiVMEWK007QpUm0yZgVypWJ2CM78b/VzoX5jkT03ys92PpvviFeiP/klk18oXC0F5X0VGdAfyZ30fX/LGHxeWBf3zcFSdpepbG8h1R3B/tKx79JbpH+YdFYLd5JDIkmrkLxsZqax6Tl4snchf/FGwHyeeO9mxMZDoGIBkXnKHfzetmWiTuS4RDR9PzQ9LGMaW1WFdsJvQOIS2OYZk4KXUkSsaOXHCs49VBIiayVvALAxIfUDGjgkQmpxUky92KUWRk+ZuMSUivi98FJMH9qk3DyZrULieyBZsb60AGydjbWmEw/sFgPeEmHwz2lP4WYwkQMmah1kPFrncJEAdeOVlIAA8TO/InbM7h9U2OgSVHb2ro6HbYRM5TPa21EF5meBAKoDEA65Hh5zB+x1wpVevyuro+9IHu4hP56HB7y2
 oKhtPKM+
 nMy09tXJDk8xCZjwWoXs1eogSEXmoM8r0cxKx8LiXUugQmLA9Vbq5qC8N5UZ9o6V6aZFJyjt6rcpRnrg33H4iVlmngp5SBr3hOLeUKnEFqUUIhPSsoJP23deQ+vZLxOo4sKdqmuNWYYZ/ipZQr2x30WKVgtPqY9LOuqYh7FQiBVl3SZ2WdvH2nQSekawJq/yFS7YeGOcgZiFVXjZ5DwdYyB8SkCYhol01BGVuW/I4Hzd+ea8HXR3pEo2Ytq1onUGtJZhq0znH2Qw6eScz5cX9wRBOJqbDTw1+IxfCo9DTR01dBzyTbKCsIu5pwYZxGP6RW0mXg8EFiAJ6F+xqAEg1CAUtzWkX+aDHHLWBzZzKy/FjnfCKlqSEyvgjZFeXhTenkQ3o5gcEfgcZ3L9f5VD2TNiaVR8X5BJKE76TmFzot4JJu6H09eUOBCIO7TTA+Jng5Srw46NhkRCoiw6JwFRS12b53XdNldX+x60NM1o/C9x3zLmMdtVtF8qCwjke0I292V4285DMenR7wQlI1VMuF76nT8c6GvYzuXznuyBV0X4xyotMwzHONsdCl2RZaxUDBYDyNY72NN1qck2Hn6g6CKw2yOuoXSOdh50Wo6CMAYwRyVpAyKmswk6SdxBaBHqGy6BS/TygU5Ngkpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series makes use of the swap_iocb for block as well so that it
doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
Baoquan on top of the now very different method structure.

When running doing kernels builds, which is a workload that doesn't
really do much THP anonymous memory it still gets 2x clustering for
writeout and 1.2x for reading back swap in.  The overall times do
not actually change, though.


Changes since v2:
 - rebased to 7.2-rc2
 - rename swap_add_page to swap_add_folio
 - rename SWAP_OPS_F_NOFS to SWAP_OPS_F_REQUIRE_NOFS and document it
 - improve various commit logs
 - spelling fixes

Changes since v1:
 - drop the memcg accounting for fs backed swap as it can't really
   work as-is
 - change the related refactoring to not create a bisection hazard or
   compile issue with the wrong set of cgroup config options enabled
 - remove a now dead function

Diffstat:
 Documentation/filesystems/locking.rst     |    5 
 Documentation/filesystems/vfs.rst         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 
 drivers/gpu/drm/ttm/ttm_backup.c          |    2 
 fs/nfs/file.c                             |    4 
 fs/smb/client/file.c                      |    4 
 include/linux/shmem_fs.h                  |    5 
 include/linux/swap.h                      |    7 
 include/linux/vm_event_item.h             |    4 
 mm/madvise.c                              |   16 
 mm/page_io.c                              |  585 ++++++++++++++----------------
 mm/shmem.c                                |   18 
 mm/swap.h                                 |   67 +--
 mm/swap_state.c                           |   53 +-
 mm/swapfile.c                             |   11 
 mm/vmscan.c                               |   30 -
 mm/vmstat.c                               |    6 
 mm/zswap.c                                |    4 
 18 files changed, 431 insertions(+), 396 deletions(-)

