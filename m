Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CAE606A331
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NcxBb/bP
Received: by kanga.kvack.org (Postfix)
	id 0DB566B05B0; Sun,  8 Nov 2026 03:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094596B05B1; Sun,  8 Nov 2026 03:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE85B6B05B5; Sun,  8 Nov 2026 03:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C92616B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:49:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BEA0C0366
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:07 +0000 (UTC)
X-FDA: 85411327134.24.D7928FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E41A1A0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NcxBb/bP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c8Q0bWXQ6RT9rRjdC0o9m0ug2qpmw/mvlFkhYeZZerQ=;
	b=VKgOH6Y5YJiiD5pw+pRMzuomxw9AbwLZ6uBZ2RFejhJmLFIvMLOipAG9KyRAFW5uJYj6xZ
	ctriAOcVzG/VyUfTGxPmRKd3ehxxfL9JRhsJGBB5VXceaH99m2On8XKFEny58k3UPvZbvB
	AH//0wYpM6HvbwY4+Dt7gzWn2V1l9WM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NcxBb/bP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127745;
	b=GxqaBTc7V/l7LTPbra6kGDbT1JV61I3v8G0OuxeRE1JNYUWfvlzvwO4gcxJdbGMmgZVjIT
	ptmOto4B/jn+I59GyPlGcLy9As4gRD2NVwg4A16WDuPKxU3PBM30zagR4H6i09HAx25EyB
	AbMuGDI4k0d7zjwwRd4QVpg9ke52fsg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B98DE40864;
	Sun,  8 Nov 2026 08:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952B21F0089F;
	Sun,  8 Nov 2026 08:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127744;
	bh=c8Q0bWXQ6RT9rRjdC0o9m0ug2qpmw/mvlFkhYeZZerQ=;
	h=From:Subject:Date:To:Cc;
	b=NcxBb/bPYVzLh8IxCRGKE30mePt8i/4rBZ8VVI3ef0E7fDxYHXlazGBuKbJhZ2Q2G
	 GnPalGlnzQfIgbeidFRVYxH2p1f+XJb84Z5+7p074/l07N9h2ekPpUP+kZVt59V2q4
	 pdNplLXDejZWvHGmUlf3s5OVVAz2VFeF8AlE1ShlQd2bDXKqSXu6YJp+BQv3u9yCWi
	 Ybs9v83cYMnoot+oKN8gs9GI5HKxZ1ZsX3hs4cYQihKu46kA8ih77gMJJgr3aKerYD
	 mlHmF7dGHoCDO45XxO21DhfqTZs9Xvkw2ScxCPizfmqU7+cpLCXqTJduNDEPA8C9Zw
	 VLR7AskqBd3sQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/5] s390/char: replace page allocator calls with
 k[mz]alloc()
Date: Sun, 08 Nov 2026 10:48:57 +0200
Message-Id: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMTQ6CMBBGr0Jm7cS2JGK9imHRlgHGxGJm0GgId
 7fV5ft+3gZKwqRwaTYQerHykgvYQwNpDnki5KEwOONOxpsOtfUGSyUoFIYPOh9NG2wcu7OF8no
 Ijfz+Ga/9n/UZb5TWqqmLGJQwSshprtEiPHE+3oOuJLDvX8/1gHqTAAAA
X-Change-ID: 20260907-s390-char-ready-29b03a1bf781
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E41A1A0002
X-Stat-Signature: jneanbiqtrdmy5yoi66x4fibbwiu1z1f
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127745-819841
X-HE-Meta: U2FsdGVkX1+sEQRYqVqYrqlJSkxLrUkXbdT3KK4t8sltVBhQ4B0PTqvuZuwtGuuYUqWLTAVM+TUbQ2zr7+gFUGFxl+4BjgS3NuGEc9NiVqilgKlAcjwiruiheKnHJTeauh1WA4/p0GSwHc9+WDCodO4pbl0U7AO2zp8DC3KiQVl+cZ1HHm4EOSiD/gwFuT3IA+jFGqcaUqHfB/mW6pWoQY1GcZSQNnsKjyxCqjHI6sSKVLrJ2H/lJXrXMMLco00ICWFuMFRuLjUrxon48tug1iwm/bopmbnNYjeYUNJLUjshNxBSChqKmzGljUkAjDbJjCfapd8mzM4DweZWpI6JSwRi4x0e1qmSvcrdxfhuwUIrQZzcYeegAcwG2CSP4BcNljoCpN0WWFkbSVtwkYJoyXv0bl3+sIIklHj+0d97Ggr4vh0f9u3YO1OnJ4IyhDy2vp+WeGWh9Hh+9dJlWJ/eQrXgv3Kr1BaXvLA7mJcJq3PsTkVWX1AeifQDzoOR7IePf2u2u28IQSA+bA+253oO83yx8isJEnZs+jucbjjFx0A5hoSOUoySdbkdkDuHiZYju7KA9kprbagb6nh8O/t7MKayNSFdCgGZrh/mqtHZfMS65CGngmJMb89eQvwYMrKZwbwRMNp3Ai3bD9sj1LtNmgcCue2RQOFnD+cxve8Wlxd6JOrqWEfu/brh3WmMNKOqIn503dXMya0gdzbaRlYCqyWkUAEnVDjfwbzOtUXEDp9jT8ouWPoAYgpuM8Y8MwX8KRa1Gl9DjtUz/CTGaAiZUvQ4jn/tVnbpMuk0kJEg0gCdKFuV6Vu07U9d+EdlghDYDaeS6qKqKx3DW3zs5g8uJwbYa7otDN9jRsXQHC2+whn6mA7CAyY/BrusHQiDihnb6cy7Jo3Zq8RT2ZiROCcjHDrT2TpCNSkZ12ECgqqQYwKAgC4D7mQaWrrKh58IcUIWROv3DwpEwoIeA4wtIp+
 Th+Yu/XK
 nNBjh8rGokHfCfcewi1a/isdsWVM1W2yTmdulQy02BNA3HQTNyHvhjjTOMGBBT00zflTNirTewk0+CRazmu791SxgJd7PxB3U7M5LF6oukTVhGQIq+9fYQsdmNfKYBubCcLjYgyuWEwmvF3VRG/QyoPJjMwpdNw1bygQXmVAQFOnBkv6k7E6ehEtOaU9X3ev5NuBDTWiGZbAvhjtotfUB6N/R8IGLDy8aOY8k/1me7sW87XdKFvPiy3Bk7Tuy0E8ebKqkbVBelVsdXt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This the next episode of conversion of page allocator calls to kmalloc
family :)

This series covers s390 character drivers other than SCLP.

= tl;dr cover letter copied from the previous posts:

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

The patches are deliberately kept small, so that every conversion can be
reviewed, and if needed reverted, on its own.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/s390-char

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
Mike Rapoport (Microsoft) (5):
      s390/zcore: Replace __get_free_page() with kmalloc()
      s390/vmur: Replace __get_free_page() with kmalloc()
      s390/vmlogrdr: Replace get_zeroed_page() with kzalloc()
      s390/uvdevice: Replace get_zeroed_page() with kzalloc()
      s390/hmcdrv: Replace page allocator calls with k[mz]alloc()

 drivers/s390/char/diag_ftp.c     |  5 +++--
 drivers/s390/char/hmcdrv_cache.c | 18 +++++++++---------
 drivers/s390/char/hmcdrv_ftp.c   | 14 +++++++-------
 drivers/s390/char/uvdevice.c     |  4 ++--
 drivers/s390/char/vmlogrdr.c     |  4 ++--
 drivers/s390/char/vmur.c         |  8 ++++----
 drivers/s390/char/zcore.c        |  8 ++++----
 7 files changed, 31 insertions(+), 30 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260907-s390-char-ready-29b03a1bf781

--
Sincerely yours,
Mike.


