Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37C9C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 08:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB796B0088; Sun,  6 Sep 2026 04:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74F26B008A; Sun,  6 Sep 2026 04:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8AB56B008C; Sun,  6 Sep 2026 04:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91E7A6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:27:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09A661A04AC
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:26 +0000 (UTC)
X-FDA: 85182658092.06.D292438
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5959940008
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ke5hoBPC;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788683244;
	b=hYo/pMZuMjFKPmEBw1xlEAsPZLHExvsPg9r0c2M/3D8+F3WuxAO91gq58rhIAupfe8WZYp
	G6/VOGIwqVUpcgaMLUpRmQoAAwbf0QOtMGv6vTNmsumPLiJagRTv67v8P47RL+XHjASF5Z
	cQYSH9W6p2YdBwVthEFXiRIqZaASJco=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ke5hoBPC;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788683244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=unXDzhDOfQIn4PXJKkkXKY5S5G9gVC+CucPNUSrjj1Y=;
	b=2kedBYifo6bh1IUs+rVMysdsgVZ3FizQvmEHf7LkgGabGwnMszHTsFkophBvy8Oi9oJf5i
	4M6RB3cyqHZxgt5r5KQ4ZRDBHHOzENyxeRfPu0B4gYKxhH9o76/QkDfXCglKa/JIttBVTM
	s1sFgke1wXUwP9bhboslwKzopjrNzQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90162600AA;
	Sun,  6 Sep 2026 08:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C7D1F00A3A;
	Sun,  6 Sep 2026 08:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788683243;
	bh=unXDzhDOfQIn4PXJKkkXKY5S5G9gVC+CucPNUSrjj1Y=;
	h=From:Subject:Date:To:Cc;
	b=ke5hoBPCBLJfy7v18TrpdtuvZX5gMfZZthDjmoILRiAamuDXoSFO3XcwRb11byypO
	 gUkfNiPCaQkZU7GB6HMSY8QEB105yNJawxQaP6WADohh06xSb1VdKXlXBwG0jONw8Y
	 HsjiaGzJYDz9ykUVvwsCapLoCTz+EQ9cpQNGJqdGr0vefP7rqDw/8LdwNc/Zhy+eD2
	 mcMAMfoBGZP45+TNodejhQskuczfCfx5wwcq2kSpZFJJHVNyEaIGIaEkUsZ6eX2QA3
	 QDbdGvNGmUNfPVShK5fwPPcmmkO7w3UGCig3HHWTFlnTd1OYvdgRAtulAxPFq3a6tV
	 iZpW+SWVbrZ8w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/4] KVM: s390: replace page allocator calls with
 kzalloc()
Date: Sun, 06 Sep 2026 11:27:08 +0300
Message-Id: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0WOzQ6CMBCEX4X07JJtCX+efA/DgZYVKlrMFhsN4
 d2lcPD4zczO7CI8sSUvzskimIL1dnIbqFMizNC6nsB2GwuFqsBKVeCzGmEMT1Aoc41dWZadEVv
 8xXSzn73q2hzs3/pOZo73MaFbT6C5dWaI0o5lmgEbGe3B+nni7/5KkLHmWK1R/VeDBIRMG6yrI
 s9Ry8tI7OiRTtyLZl3XH4EKmajSAAAA
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5959940008
X-Stat-Signature: 8x7s99ite588s7qkfxzmub4sf9noo54h
X-HE-Tag: 1788683244-472147
X-HE-Meta: U2FsdGVkX1+7YmvAcfjQwLCFPJ6EDULW2kUUgbwaLSb6wgXSOs/sULXyvx+qLZXVkujXvOrFTGCMpNRbA/LzkZ412zjihB9BErm7x13apXcYYldOu57eANtJzkbTycjO5JSXZpLMBBFKNg/kN006KyuxZKvHNOMjfT4gYKnubIt9q25FkFvsij6pZMnlv6x8qOtepQfvz2TCOBgyMNM54f26JEiFgYxYWC4vTfa5UHzdKKYizm6e3jIX/wS0QrNCnIMGqZsZOJ91rjFVL3mZzNWkCJjeFSavM/4TPw1fCYa1lxpsaGIRu9htVNGUuko0Fw0pRz0iBWXNeF0f1dfySHSr9GGInj9UssqqBPvw7/hsSHqUYqUREHQu0pBGBKwGpzdOvkMrMB5d8Zmls1I3tjIzs52E1sWvRKs6q6kcIlIBToEAddm7nLgm9GPN2Mmo+5w+miabxWtJdCt6NZtOmigdQRbyBnL3eRdGa1bfw7MOa5PLtvIir9i3G+tz76dGFj6lMLXuRB1TZu46/KVTrM0Ug38Vobc9enohbfmR7pq6sbN9W+iDTRsFQFYFVGTfEZIMNHM8Jtx7x6Uu4Vv+Z4MTm6oRVHeRi00vBkDqcV8AheNxtrhFjUrFwzCZ2r84wVjsyn2+LX7MUSsOOe0YUyXxtae2RfiPsdBH9SPL+1K9TiD6Ukph176vlP0Tn1XPYD21dbkL1/pct+Mj7i7ji6wSo2ZuravZaX5d1wEahRnJjTPEp0bRX7+kpCxfrhmWxOZ3eMI+l8kP2ntH4qyzsgBLqT7GwLA3jyFlu7gn11lwSLf4PzKPy22v5g3TFZENxHlqCsRDNJt1VOgUSZUj7Cosd2FJ6yLGYdSOJHUoQQQdBhREtZy2QETT3T1pyboyGSFfngqeAIJA8SvMxcB7okBba1qg5j8E5IDkPpv28JiAhW8E053zWKt7hUo58OfwWnI18SMAbwEmMjp2TdZ
 0URUqTwl
 zFMRf7P3lLoBhMcg8n8ZH80n0cu/qRa6EOLv1uk3FyCmMmnjDqPN4NPyw5OqRKH2zbxo3SO5Ub0mu9rw9fovw6a1gTyulxF3vxOuYdsl5ffw/db2q5Nn6zf3dWDNC9vqsnO+N0gpSyM+/jzLLVMtmYpC3PyMk06pEjtPqdu2tHMl2539CuRCNG4evyi+alHKBlI5ATjoZ8DOuDUmsbfWJfGQf8z/zwKLgi/NogFG2xWDFJBQgXlJvfWTHdvatgjliNZEYAbhKmf28BLL3wcr1Xl9KQfaGoorKAubLbwiSEGTopSc3Aa4H5gWLFmcnd37mp1pklpjwp2eW1+/ujvIJBJl2ZJnIMqwBU9pj
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
v2 changes:
* Mask out the next CBR entry offset SIE stores in the low bits of cbrlo
  before handing the address to kfree()
* Use __free(kfree) in handle_sthyi()

v1: https://patch.msgid.link/20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org

---
Mike Rapoport (Microsoft) (4):
      KVM: s390: Replace get_zeroed_page() with kzalloc() for the STHYI buffer
      KVM: s390: Replace get_zeroed_page() with kzalloc() for the STSI buffer
      KVM: s390: Replace get_zeroed_page() with kzalloc() for the GIB
      KVM: s390: Replace get_zeroed_page() with kzalloc() for sie_page2 and CMMA

 arch/s390/kvm/s390/intercept.c | 23 ++++++++++-------------
 arch/s390/kvm/s390/interrupt.c |  8 ++++----
 arch/s390/kvm/s390/priv.c      | 19 ++++++++++---------
 arch/s390/kvm/s390/s390.c      | 12 ++++++------
 4 files changed, 30 insertions(+), 32 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260828-s390-kvm-2015b0d777dc

--
Sincerely yours,
Mike.


