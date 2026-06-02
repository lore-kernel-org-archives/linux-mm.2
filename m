Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED6FCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE3A6B03D1; Tue,  2 Jun 2026 07:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49ED86B03D5; Tue,  2 Jun 2026 07:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D1B6B03D6; Tue,  2 Jun 2026 07:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23C0A6B03D1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:06:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC96A1C2122
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:38 +0000 (UTC)
X-FDA: 84834694476.28.40B8A11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2BC42180005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAy8d3bT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780398397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nb/YtXSA4AFvwmR+fJ8+A/Wnpj14St/X5BrSCu2Hf7Y=;
	b=1lBmZl8aLn3RkcKLgrbHK8QILyMP7oMq+JMzerRbd2b4HDj3fQOWlhJRr+hYh8owuZTuQE
	VQYr+fgeXwvWB4paAP5wPxq7CBaUxhaEkaxRSMk5zhaY9jHeqQDfSgztcD4j7FU/34DdxF
	QKhv2SeUGzJOyu6Wu1jCGpvINTeLLJ4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAy8d3bT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780398397;
	b=UwtlYLwV8SjkpymPdMUb+EfyqWvwUYCvmmwkTloR1CC9EzOGFkHGgI1aE+AA1LsEmbh0i+
	nHsQKCg3Pe4ZEwySGHwEY0mmKURfz5zz+U4KTqp8A9/dZkxnCavPsklSBIiffBx/Y29zLS
	lIVesmx1hNgh/FK2MU5cXIYc/a3G+nw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26B8744144;
	Tue,  2 Jun 2026 11:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1F21F00893;
	Tue,  2 Jun 2026 11:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780398396;
	bh=nb/YtXSA4AFvwmR+fJ8+A/Wnpj14St/X5BrSCu2Hf7Y=;
	h=From:To:Cc:Subject:Date;
	b=bAy8d3bTZT0j1mkgbxzsS/BG2eorSf/qllZbAYFx2KvjySSH0KRDTQwtkg+KcokUo
	 MXKS/99YYKm2GBH9/4Oua4+BN+LDJ0xPnX87weSrhHW0JOs53fefearo0q73KSlgBR
	 RuvX2p2cc/bk3AOCdGEhN/RSb5bknG24NLdgxP9MpM1XQRzdLjXWcAgyj4sTEFDAh4
	 XnjlY1AcH3RyVHMw6+W3nq+k6W9qPJm/DxuJVHLyaVttudbeangT9TaYGNQXRbFqK/
	 R7ROL3wqTNceVGJFODwBRMdMIZc7G6fuyei0Z58OVxOXkuxQ2s/44Kr0z0BJ/sNPIb
	 daYoeMOSz6RFw==
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
Subject: [PATCH v3 0/3] remove mmap_action success, error hooks
Date: Tue,  2 Jun 2026 12:06:24 +0100
Message-ID: <cover.1780397980.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: insaja9ei674uwsrkbedwfcycyffp56o
X-Rspamd-Queue-Id: 2BC42180005
X-HE-Tag: 1780398397-844771
X-HE-Meta: U2FsdGVkX1/F/8i6zxcuIE4RyuRBcnmVK2ehkJCv+iSRPFz+7UgPrGEIHHNfsobOGkwEh4k4qKq/aHqrjLH1KAJu5Je4qxdmzft0eMEVetKhyswOi9tV9HVcXkQd0ZOXzDWstQG6IIryIOjZyYmr1Gk356vYXKRdeG96mP5AR1gKfImxBVONTUKJxzcxEF8GjUWi/eMyfNKRiBjzyEuGPpOVD3z6HHWrkCHYPd2Lkyg15/+WJfgvQuzJQhOTtY/T8bv+EBP0nbW2qjSJppXJ0A9z1QSyOLdZ7T3WKlHomCQnCHNyXXKryAX/fAWJ7NxHono0q5Oaz9MQjXjiQazPna76bSw6TzlB66OFxEX25TmmUWXhHB22ga/tYUn0WSblOaEQDUcqIFKS2gOtx8BkzxkmOr5n7p0yFCw/OfHQ+60Q+mk/cwrT4fr3zlNxw/TMFwe2n5FRC87XcoLE8gxmqDuse4hO9FWf4uv2vrkm14XlZwLjiIxCqzg4XNn9O59jA6qwTBQJZefYxwkM5lZTuBUY/1dZmwoZBLBAp2YmHVskKt7s5hLOiOFgmj6I0YUdm63gqjPTYtjZLMbzB2QIOWtoIPK+nWXFxh0Quldbjr+99AkDZphj8y/A6j6djUdqG6cmNZWWzbJDqQ84agPNOeUkZm9eUpWWroK9AoEa+sYz07DLTTU2P3jFrv2GRBnD0ULSiaiw9MWCl5KuZAMzhzevtUnwcF738Pz0dhK+9meoGjUncTAX7aieTapPuBBTYDOTU2/YWNS5c4qWmcMFdtfBjQeQQ67df3bv/ChZBGgIHA74N4vm6X/EWHEILILwaCvQuvPCuetLUQLLDMUdV/1NZq4/9SLt9qCyezHZ+AxFbnJ2TvXASawAJotrwG/PUwJxOis59WFt5+TqzyGmkPJHMJBYRmguuIUSKPM9E8Dil516EpJ7GSMZwR83FKlYzwljt/XAFDeYIFcmtwN
 DK8GczU7
 YyCKb3N+669SoRQyqP9YXWuOd3pEx5ZW9jm82ohTlctC572z+bw8A8+jEBTfDpJPnHagMQyZ5sjrYVmaCEJ4B9RhdYDogXzu1GIBi2yH/6qe82xrGU6DXGRb6YdEUk/eLCqCfJ0GaRCfWZykAFTgOOJrKIKbR3JbfSZUE42aYoYGEdwO/Oz5YHFpTy4NLJfORgZU75cms6JmaS9J6LKvM7sh5PIIzMPxrw/jgSJkZ4xlljot9ef1rNa4l6KuDN5joTqcnJT3AakYdFbAe382krwHFoQ==
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

Providing the success hook was always foolish, as it allowed drivers a way
to workaround the restriction that they should not access a pointer to a
not-yet-correctly-initialised VMA - which defeats the purpose of the
mmap_prepare work.

We can achieve the same thing in memory char driver without needing the
success hook, so this series removes that, then removes the success hook
altogether.

The error hook is also unnecessary - the motivation for this was for
functions which need to override the error code when performing an mmap
action in order to avoid breaking userspace.

We can achieve this by just providing a field for the error code. Doing
this means we don't have to worry about the hook doing anything odd.

We also add a check to ensure the error code is in fact valid.

Again the memory char driver is the only current user of this, so this
series updates it to use that.

After this change mmap_action has no custom hooks at all, which seems
rather more cromulent than before.

v3:
* Rename error_filter -> errror_override + update commit message as per
  David.

v2:
* Fold fix-patch in, defaulting the vma descriptor vm_ops field to the
  dummy VMA operations.
* Update commit message in 1/3 to reflect this.
https://lore.kernel.org/all/cover.1779462249.git.ljs@kernel.org

v1:
https://lore.kernel.org/all/cover.1779379804.git.ljs@kernel.org

Lorenzo Stoakes (3):
  drivers/char/mem: eliminate unnecessary use of success_hook
  mm/vma: remove mmap_action->success_hook
  mm/vma: eliminate mmap_action->error_hook, introduce error_override

 drivers/char/mem.c              | 25 ++++++-------------------
 include/linux/mm.h              |  5 +++++
 include/linux/mm_types.h        | 19 +++----------------
 mm/util.c                       | 32 ++++++++++++++++++++++----------
 mm/vma.c                        |  3 +++
 tools/testing/vma/include/dup.h | 20 ++++----------------
 6 files changed, 43 insertions(+), 61 deletions(-)

--
2.54.0

