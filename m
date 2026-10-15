Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7404CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B585E6B0088; Thu, 15 Oct 2026 12:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08596B008C; Thu, 15 Oct 2026 12:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0EC6B0092; Thu, 15 Oct 2026 12:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2C96B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:07:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1342340A83
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:26 +0000 (UTC)
X-FDA: 85325340492.21.2890C57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 408F2120003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9KrD+0Q;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CWGMfzP4w3Zs0Y7JyHkmxA4Ab0jJqfsVdlDpuxARv00=;
	b=4esnNDNzkvLwkSOEBUlXSpmKZZkT965Q9nFfB9k4e0cGorcIQeoB1MFUIRt46qParIPtcq
	X7iPOBqMz3VS8Cf4PZ7RJvtkUEAv6BETedigmY3rnWVD+WWD0/bjo6RiScwxjFnWe1YIKY
	FIKBH0ykmpHDsK6wPkvw6Ys66aAd8ck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080444;
	b=uaUyzT0KXY4rxb+SG1GP//pNIBg6pY3ATajtg/b6FsCtVFRsnH9nPNDD2GDxE7B+RUcSr5
	SIEFMNlFcZVdcobn5p6FXgU3VOtvhD6IHL5qFYutFUezDn0r/Xg8s4zW1Y1VliZ81krmaB
	VVdSt9Ry4Jq/dkOO5z/n7TZwkPkupSo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9KrD+0Q;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2396E40E3C;
	Thu, 15 Oct 2026 16:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82751F000C4;
	Thu, 15 Oct 2026 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080443;
	bh=CWGMfzP4w3Zs0Y7JyHkmxA4Ab0jJqfsVdlDpuxARv00=;
	h=From:Subject:Date:To:Cc;
	b=Q9KrD+0QatR2fO6wXqm1uuSgDXYAHIcUEZ1gLROc6UsF07iyL4xlAvO8d7IKEBeqo
	 L0U8huXAcNPaswmMqa/GsAqk/R0RP85ebMSNdU53+QgGfw6qR5cfS+5z5hCW5EBIoI
	 je8vP4WhScOHpnCpssgJLAST+x1VvNuRoc9l4Hr8dD2o+DfAZXOAhhovfRypbfCixh
	 oTTwiLcBxLNcyelXdvHdbeYwv1Mb+ryUXOm0qjmUB0oUucxCjQj3eSETvLEysMy/xx
	 L4pJHMi5C/w+B47GFhmhaZQev3xvsg6Ev8ta8OoH3f7UIdAQkSI6wcQosYKiyCr2lR
	 2xpaPIp8tIs0A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 00/10] mm: various (urgent?) fixes
Date: Thu, 15 Oct 2026 18:07:06 +0200
Message-Id: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACr60GoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0NT3dKi9NS8kvi0zIrUYl1zQ0MjMyNLYxOz1CQloJaColSwBFBHdCy
 EX1yalJWaXAIyQ6m2FgC8oPgdcAAAAA==
X-Change-ID: 20261015-urgent_fixes-7112629346eb
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2238; i=david@kernel.org;
 h=from:subject:message-id; bh=bhdP739rykh9+cxbAvZcyJkbfwJi6RgLgraAvwylzjI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DKUPn5d4HXm1P47+z4f2JMwW3+pwclIvoeCrPYHd
 aqnsc3731HKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEkjwY/qlb6KbN95oowTDp
 k3uS6kVTO4H13evfCZiZ33u6yilI4ggjw2NDyYNK4kfD7jnXxL79onjyrfschgRBO/ZI6bsrp6W
 tYQUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 408F2120003
X-Rspam-User: 
X-Stat-Signature: ywzcpx8gzme65ntxfw8im3eenqdxcn99
X-HE-Tag: 1792080444-836072
X-HE-Meta: U2FsdGVkX1993Zgp8vkTzmjpcDvu8z2Yo1coveKCveOeGBPZEe7VUERrHzUa19Sgf3MnEBuBETWF8B3z2a7W40gCOZd22jQOxaeU8j2lUHmAMtIP0tyhHqWC0jhYLxQZPuOPnCFSgnmRPdEV9hFKb37J9yaaVm8P631lIUMYVT+tBAng+LnmwO+bzvWVowuOM4gpZlWOZomTvCjNy0FivPoClIWDJTSH1iU/A3mYMlcu3V2PFoI/TAA/tosmMY/1KtrN8J8302ntGmFbH5YxohJ+xtR5NlFx1lKQhEkUkbLrxAclwifHQtBHIU6tF1Nz+G81qhqkJXTM8o7rSqc84+xNRgEAulZjjqt5pRKSE6l1FRnzjec/Og3bxytUZ+MJbfbxKp8r57G21KSVvYLfsu+gUqDiUb5wBCIbDUZaYRtsfNAzgC6Bnh1BeVNGYa3kC/JeVWWms8HjSeUbkuYmoPfUNIGIR3TbwetTylse1qT6qvtVL7JDJnxtkUcSCkgqkgZGeKKmA2Tq5W79fj0oLWXjuAvqfHaTQMtiFWTHhZPO3/L3SQHgy/5FA/641SaZyjEVlqOxhBvbzd8jty8YzIu3v0ozZApnFeY7h//CEz+zk7jRcOD5F+YtLqC2pdqlpyvE+EqrvY20e/jQmdTP3ILeSpeLOqV/SHOvB52YQJUPTF0gwXj0VVe4U+90aNZapmNYYdfgXUiwjGjPnNpflXSNZHOJQBxXFCPapVu7RXiLyeHJ8ha7Z7+pBxsKwPxhCg5yy4TeVuofTgnp2qcDt5E0BSRe0dsyFM0Kg3/m4Zd/3dkTVrlQ2xLOHEYnNLzSXjNqQ8spyN1cGlJMLRNdg1chckVy0rDkj9dJKhYQUGeTJlIQXIBiLZOqja1Vcv/IFyn9cV+RwhMRR8g+TgeAK5J3vLBLNype1qnCqKJwF2VQnm6TIBvfO++sP5fqTVNnkDIpbnRLjA06R1b1Cm/
 3+V+Z4ME
 czHFMBRixMiTWTn1TOwNa3nAUA2aN8L7GkDHsMp062o69M2Os6TXhhzC14RqLjF0+o6mgrtz8zc1+sMd7bFydY2qtbKK9F5iod50Mhg3eidhB70IDFX91O4Go2d22W0HFtE2rkiOQPNbtoyoAWye8xf2z0maSOZglxWDTv9DqZE2QmKNTa4nJ4VaGPoWHRbWW2UUCFzffGIitdToYuyP8IzdsidfBqqdBk4+/tWvDYAIlOSK136MLi1fi87zIaYnuRuNTwH0iSCdS2ssQxbl4NQoFLss4pTla9tnhlK6A4rMtXqjZOTEgVOgTCnzkaz+D4eAN1cU+28ALVhQ6KF0kCN6ewUnFlEdaiUCYvYY7phfJ/eM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

here are various MM fixes. The majority was reported by Josef at
Anthrophic, the remainder was found while reviewing/overhauling them.

Two issues/fixes reported are not included, as we are discussing
(better) alternatives on the list already.

I left most of the original commit messages as schloppy as they are: I
don't particularly care as long as the code is in good shape and as long as
they are not actively wrong. But I (and Mike) could not be stopped from
overhauling at least some of them.

While I don't think there is anything too critical in here, I think this
is a good opportunity to see how fast we can get pre-screened/pre-reviewed
fixes upstream that might be security-related.

The majority are hugetlb + uffd issues, that are not actually that
relevant for most installations. But all things that should just get
fixed. Some uffd fixes need proper follow ups to fix some more of the
root causes of leftover UFFD PTE bits (or proof that there are none
remaining).

I ran some MM selftests and nothing popped up.

So let's try to get these upstream in a timely fashion.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (4):
      mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
      mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
      mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
      mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA

Josef Bacik (6):
      mm/vma: don't leak the commit charge on mmap failure
      mm/hugetlb: fix use-after-free of a new anon folio
      mm/hugetlb: unmap the page where the other VMA maps it
      mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
      mm/hugetlb: fix endless write fault on a leftover uffd bit
      mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP entry

 mm/hugetlb.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++--------------
 mm/mremap.c  |  2 +-
 mm/vma.c     | 11 ++++++----
 3 files changed, 62 insertions(+), 21 deletions(-)

---

base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053

change-id: 20261015-urgent_fixes-7112629346eb

--

Cheers,

David


