Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E2DEC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDDA6B008C; Wed,  2 Sep 2026 02:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DC26B0092; Wed,  2 Sep 2026 02:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C1F6B0095; Wed,  2 Sep 2026 02:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 671C16B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:15:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E53A8C0769
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:32 +0000 (UTC)
X-FDA: 85167810504.26.A26A65C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2E4F540005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drZbWKHP;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788329731;
	b=2AASuP1BzZHYUDW2cPgcrDYkr67XbAlX9A8OemBTUggK6stmH7pqTmKlJuY4Bq3XkEvF7q
	3OUEGJuVOS7AvSsO6hYkm/HthKZ18mdOcMqYii47qnZTbU32FMcGDwLlspv2UL0hOkPshR
	TxLyXTxXSMt98DtwTjFJlyOqcXT/RT0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drZbWKHP;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788329731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GmSsU1jxZJ3K3cHXPdQ2pwKw5aWYndJA6ll/0Ff4QV8=;
	b=WTVEL7ScD79OsS0mWr+X+9VCZC5r57Ft1Nr1hCxpntJG21HT4Q++Jt4TL6eaDHTi3oGwK/
	hGGmnGovdJJo2khpUcoqEZ0Cxqh5Auqxo8ymHpghK0beblI0jMKlaiLk3ueRMNmAMjzazB
	yiLSCINuVM995+CUkUXs2XO9GIZvuvs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51EA042ABE;
	Wed,  2 Sep 2026 06:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195291F000E9;
	Wed,  2 Sep 2026 06:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788329730;
	bh=GmSsU1jxZJ3K3cHXPdQ2pwKw5aWYndJA6ll/0Ff4QV8=;
	h=From:Subject:Date:To:Cc;
	b=drZbWKHPEVv1/wUpkmlyciVkocNy5ez0dMGtcuXpx5sJbb1MQ1ZxrtbDujmpD065R
	 e402b22GtB3geWHpTHo56KoLzNEi+2eLEW9lOYqIQZ4dpxiIMqzkFyl3RTEk5x+huf
	 WQBKX/4jZv/Bc+QxkHuU7ofEwn8DyOSBncnPRHXV75QENbucfUoTaOn6ui9+4F4Ukx
	 M//UQjTFAuG+ebFeGq3aBvx0sr0LcHTEydaJpubgXCUE5qnbb0k2+IETFHMTIrgWHW
	 fmDRDvCcBcp+Pb+ezYSY9XZbCnKURk1wjDGCOigfDEKfA2E8JRiZPoyEX8LZyrZ5O4
	 n2Lv0DESNwnOw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] KVM: s390: replace page allocator calls with kzalloc()
Date: Wed, 02 Sep 2026 09:15:12 +0300
Message-Id: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ7CIBAE0F9p9uwaoFGqv2I8wLLa1YiG1cak6
 b8L9fgmMzODchFWOHYzFJ5E5Zkr7KYDGkO+MkqqBmfc3gxuQO0PBu/TA52xu2iS9z4R1Pqr8EW
 +69Xp/Ld+4o3p3fatEYMyxhIyjS1a6bc9FrKwLD9kkKdyiwAAAA==
X-Change-ID: 20260828-s390-kvm-2015b0d777dc
To: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, Sven Schnelle <svens@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: 1xb1w98pd5knitbauxr1pxrs4tz6txw4
X-Rspamd-Queue-Id: 2E4F540005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788329731-194586
X-HE-Meta: U2FsdGVkX1+Lp2CgFR+HGs35nNtmOxfec6AJeUorLn+ZzLaSp1GOxRxMOnRvd/Bl1yvZOzagczH/gRtme0/LGJlWiIsQyfuP0OIMqg/M5isdYscDmsw3oPA76COtOY3p08NqWoX+A0Ep8U+fa5KUML6lRJC9WZt7/o1RtaDIujkVed6p9XKt9JWTKW8C6Dv/kQ51H929YF5t43gI+PoZTVPoZ7+9ZvNu7SylQbGY/PgOzaDUwEctKmtcVefhJUfi0/FP0ywAm1ZMyVyrwZ/3BxwXNJ+ASopjJQTVbYkOxGkYtXhg+uDxWJJ5Va43Qit9j7IObpvHHbO5amasSr6LamJZ552MV7Po7jn7lPnUKFWg5ZvFzTjSXhg1koVrfwTtgahDOSDBnZGGmpKYMSMIn5tXEvpVl1IEdr/gZ3uUhbv+tqjs+4LSB4kxtvW9orm1pRANK9eKxXzk2n+w4Z4qPK/ANQH09693fLRqKr5pVndAP2WXt1d7LJf4b26hQhbaefI3QUUiIp4/BOyfu2cNaaQqDEGXRAxvAswCLqwqY/3iUZ5nB+T5LppeGYPa/nN3uYPw+ibYsNW4hj4uUKqvhQovogsDDiwy1xebK+uY3hqWRER9xB/pRNL3lKxXN8SIm6AI5vQZ2Xx8WywxbCnpoZ3GZyyUJ338P7i0JjOwXqZx+pDVSs+7d1bvLLmwaZPLhxmHAc6Cv763rGCwNeJiog46RLoOVVz1cGUa92lkx+iG3Me2olA035+v6uoKB4LfoLqtB1fQ1heFyJRkKxVudelvKc9IAUqO5K8cWAmEPgnzjY3HXj8dDoGz1OGkJwJUsp98GxqrGed2uuC7GfDo2Car2DeIucgNZXntVsOLsVLavQcPTy1k+W0MGolf589O9V9mm8830m50BkRzM1qQTa5No9N/ku2x9+jR2mTFTc3CfGRov5wH10nK806oSaj0SlwsFmNi8gx5+E/TvPu
 nQp6NEBy
 1RIZf8ckJiMPHn9L8AxElgaFrBDkfGo9rGSKaWNXZ/adq6gbJoOqq6UCcvgA6fLWhGRG6/pOC0VtnBdsgOGzyf5xMKuewwa9MEqeqzYlZeEiitvyRZVApDnyJapkSS97UuTmqdp4VVRnFKgxBtswOKDh5hRwcQrct1zwwdDDHh/Sr/KPTkMfBisZgWLXpQEEw2JLWczoo/LKd+hb56HBXVS5ffOkalebp6e2hG1iBH/Zl6Ki1+5w0P9cf4x0QOtlHGVAwFLdnMio2rv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/s390-kvm

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
Mike Rapoport (Microsoft) (4):
      KVM: s390: Replace get_zeroed_page() with kzalloc() for the STHYI buffer
      KVM: s390: Replace get_zeroed_page() with kzalloc() for the STSI buffer
      KVM: s390: Replace get_zeroed_page() with kzalloc() for the GIB
      KVM: s390: Replace get_zeroed_page() with kzalloc() for sie_page2 and CMMA

 arch/s390/kvm/s390/intercept.c |  9 +++++----
 arch/s390/kvm/s390/interrupt.c |  8 ++++----
 arch/s390/kvm/s390/priv.c      | 19 ++++++++++---------
 arch/s390/kvm/s390/s390.c      | 12 ++++++------
 4 files changed, 25 insertions(+), 23 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260828-s390-kvm-2015b0d777dc

--
Sincerely yours,
Mike.


