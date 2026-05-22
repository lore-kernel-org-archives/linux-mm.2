Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8652CCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2946B00BD; Fri, 22 May 2026 12:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872F66B00BF; Fri, 22 May 2026 12:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761C06B00C2; Fri, 22 May 2026 12:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59B556B00BD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:00:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF4FBA0AC1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:17 +0000 (UTC)
X-FDA: 84795517674.16.C72DB4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 556B6180016
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CWgvjUmQ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779465616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NlJymXd+YDawqDDSaCcMPlme8lTIf2JfXZ77UMlGIjY=;
	b=fjiBk7uF6evMiNY9kK3L/ig/upi6fi6Qk54E7lbTMI4hKNh4rKTdsvPa2jpADWAJhZKqUu
	H/S6yDfWNKHfi8ryx9Y9yhMQCUHtk/EigkzvhUDYYxU6BFrtSRhWq917Mf2vEL8bwKCm8M
	uSmET1HtF0wHrhO6ObLZs6UhrBRIzH8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CWgvjUmQ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779465616; a=rsa-sha256;
	cv=none;
	b=D/7HWqeDmvdDwGcHIcu+d2QIjpWOk5/o2rld79TdPkRfM5/VuW1XwafrlttGPA9/r7h7/C
	+K4U1W99hLN4TMaL0EK3tmF0XvPAh4TZGeMyAuRDA152hLqJuG7fB/sztFHTzmcxI1Xrxp
	g8vA8HcyHx80kZ2YWLoyAIjfscKtBwg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA0C260138;
	Fri, 22 May 2026 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39C31F000E9;
	Fri, 22 May 2026 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779465615;
	bh=NlJymXd+YDawqDDSaCcMPlme8lTIf2JfXZ77UMlGIjY=;
	h=From:To:Cc:Subject:Date;
	b=CWgvjUmQXF8y00NI51Ncljz+jWVO6e78hlNekn5O1d2dqhJICpOWRwpNA0IVzRHp3
	 of3fhm9X5k+xnkKdTgcCSxanym+pKhbHDpFDxQkAHXdTqQ1XHQLHAT/8+kEv+PLXhn
	 8fPMK3PxLv2s9gRDpETSAo5JRXAGEi5RpgEjaUUdzLYQErdHZf1CBIWdtWS85+z9we
	 2tPNfFenn3jwkoEIeM6JXvgwnOSWXqgcJ4P2wsMYIzEhZHDgwaUlkbfMHMCNYJG/Wp
	 8Um4B4g2bTRc0gUi1iWidBEobmVppkkVgx0TvSeQZYw2WwyXLFHQBcci0CObR/RH8L
	 dti5bkQNZOi2A==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/3] remove mmap_action success, error hooks
Date: Fri, 22 May 2026 17:00:08 +0100
Message-ID: <cover.1779462249.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 556B6180016
X-Rspam-User: 
X-Stat-Signature: wpms659fmdxbzsukbsr19zntsd6bebc5
X-HE-Tag: 1779465616-658603
X-HE-Meta: U2FsdGVkX18PCpumesD3spPiQbBaPW5XYnLcK9UNr7cDT3GcOdaSCiFgjgKwxx7BvTjYiBIN/Okw3CtDU6amOymdlWi14Aeln7kAO/X0SNIou0D8o3YswvMQjloVeHo7kmHVvRAmYoSmQhQQYABw7eQ/z9VmUZmrXFANGY1TankrOhphQIRaELPlsZth94MMJ6rVJBtxAQArrafWEUtwIvCO0sb758y/q/fy26CVuXBQ13hfRA9LJlpMrQtBmztcTbzZ3RMyuRYgBGEhcG04vV7gqm5UxnrZeNUWWkXLmP/XkqApi2M4z5cuiG9ovU4ps7rGbFnN07Xgc9LrMaduBmOfLa4Skm63Pl6U9/6dq0nCdReJtALE1Ye+ui8N4KRNQYSnvYKKwloj4YxqOTV3uR++7dBo9KDGhHzijfUAJhrgUptP7pXtO8wP/c6csxx4rYxGZytKvnUYDKjLV2tbYfo4XkxpVgEfnJR+haMNsPAfiF1/l68sHd8lIJHLvTl/4D5JNf6itdNPHBoltpNXFzTesPuj58GcUvEVCia+TPPvrz5s8lMaB083AwD5Bvr5seC3rxcoU5o/TS/Wfhk1bMwpSSkp1lIzV/vrTwfmmQJcyXjdRo2zYyTgKJFWdSrwInKIHv6pvB4AtQiNcgu0zZGnqorErXI5XXUpu9OmqMYqTKbVQYJ3Dbidq60knCxhrVU9ese/ByuyW/nl+Ri2TBdla72UVlmJ5e1lYCObKYS6/9FpY1/DkAFy/m1PM5yQ46zYuAgsI4293RLY4I53NACMJKuv2huy3z3qFm7rkjIA9B3rsmlO4D+J0ubFYBxpFVdbA2Y7ASlbOFOKC8AkP8aS4cDn4vDhf3XLNrphMH6SgAQV1RxHr9pw15yjMM6udHuAbzTdk/gAh6my7mfkTDvRbBnnYo+W+NpLFSGAow6y7w4h/19hHpzeOeklr86hfHTK8oALovFRoHg43QD
 4AcGDuN1
 l2ouV64lSMlsu3sdgBTa11Ai9ICeqK2Dd91OKsSSVKrygYkBidsUz88fuKADAJNzd+PnTkgG2Na3GIcRSUgxQHrye1rB4c/FYd8NS9E3uJwsvR/IrS8ccbHZ5jEuGGodvcFkGt/E4YIgZs+RVqCzbRF0dOleOrVmp0YlN4r4oF0WREFOTfENmGKVPEYyQoA32YyU5wkUyr+kOykk55aqNrLedkutGBvsCZNNwMG4R42p3fxv6e3CbqxzjlY0qZ1dHgpWa0uT7RP6NwBpAed8XPRCxuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_action->success_hook was a strange beast added to enable code
which appeared to absolutely require access to a VMA pointer to work
correctly.

Primarily this was for hugetlb, however a different approach will be taken
there, as clearly more work is required to figure out a sensible way of
converting hugetlb to use mmap_prepare.

The other user was the memory char driver, specifically /dev/zero which has
the unusual property of explicitly setting file-backed VMAs anonymous.

Providing the success hook was always foolish, as it allowed drivers a way to
workaround the restriction that they should not access a pointer to a
not-yet-correctly-initialised VMA - which defeats the purpose of the
mmap_prepare work.

We can achieve the same thing in memory char driver without needing the
success hook, so this series removes that, then removes the success hook
altogether.

The error hook is also unnecessary - the motivation for this was for
functions which need to filter the error code when performing an mmap
action in order to avoid breaking userspace.

We can achieve this by just providing a field for the error code. Doing
this means we don't have to worry about the hook doing anything odd.

We also add a check to ensure the error code is in fact valid.

Again the memory char driver is the only current user of this, so this
series updates it to use that.

After this change mmap_action has no custom hooks at all, which seems
rather more cromulent than before.

v2:
* Fold fix-patch in, defaulting the vma descriptor vm_ops field to the
  dummy VMA operations.
* Update commit message in 1/3 to reflect this.

v1:
https://lore.kernel.org/all/cover.1779379804.git.ljs@kernel.org

Lorenzo Stoakes (3):
  drivers/char/mem: eliminate unnecessary use of success_hook
  mm/vma: remove mmap_action->success_hook
  mm/vma: eliminate mmap_action->error_hook, introduce error_filter

 drivers/char/mem.c              | 25 ++++++-------------------
 include/linux/mm.h              |  5 +++++
 include/linux/mm_types.h        | 19 +++----------------
 mm/util.c                       | 32 ++++++++++++++++++++++----------
 mm/vma.c                        |  3 +++
 tools/testing/vma/include/dup.h | 20 ++++----------------
 6 files changed, 43 insertions(+), 61 deletions(-)

--
2.54.0

