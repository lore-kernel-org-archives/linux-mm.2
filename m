Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E14CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 16:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F856B00AD; Thu, 21 May 2026 12:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0626B00AE; Thu, 21 May 2026 12:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F69A6B00AF; Thu, 21 May 2026 12:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6C16B00AD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:22:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36DC51406E3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:05 +0000 (UTC)
X-FDA: 84791943810.20.9C818B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B14792000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W53i71Ip;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779380523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nyXx/nFz2WVL3Mg+IX9KGNpEsXsUOSkqwecVU0tFer0=;
	b=00/emObvnT91yu+UqJH2pm71ZxHBGNGW19ERfIvAgQH+oUVO1K2SlphrLYwzWnle08up40
	WXwf1nU0oWL+rPHWW3Ugxd5ubc3LRlEVo8H362uyoUYmOFJF6w3L+FBz6TzS+0KTx28bNi
	0Fq/Tx7DtvP/vjzwjRKoutlPgPGZS+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779380523; a=rsa-sha256;
	cv=none;
	b=npQDx8Nn9yha8PU5a0flJkv+4hztipzw1WwfA0MeVG6oY/5cAUnzHTrX7w7WdL2GZRt+La
	yaRV8orWogwQZcCszlDz21lfXHQjPLnuGeVpMQF8S8BkvjiQmbL6ZQt/zvmZEHWraok3OQ
	gSVAFQNfUvXLOw4rhOblZ9AcHtqNWrw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W53i71Ip;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2258C60098;
	Thu, 21 May 2026 16:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558D81F000E9;
	Thu, 21 May 2026 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779380522;
	bh=nyXx/nFz2WVL3Mg+IX9KGNpEsXsUOSkqwecVU0tFer0=;
	h=From:To:Cc:Subject:Date;
	b=W53i71IptRQPUfkwTH/FfIa6gOqjMQzF4UIYgofFtpGTEAoQYTbQ58J6ZDVwocULa
	 vJp+n+EQKGr/16kh2LBbI95jFoAJj2RkR/iRfijb30D4vSV8XPh53fM3IM17CSUZiZ
	 SG8BuilUUAwCTwwzLE6w75DHWXhqeovGXtNMaEUdrUTS19xFTDsjSeWVWmCK0NtTt+
	 S1zsFVVhFbwauIx9argLcCvN6SPbiFVeVkwL6xKFrnOU6dglEQgqgVeZLer8jITHJp
	 9WraL8tOiY6s76aI/oILFHBAai2VRPd3f3WkOIXlk7baPyB+2GxWcVzL0JbbhsCkn8
	 gRLVRxzbEIXtQ==
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
Subject: [PATCH 0/3] remove mmap_action success, error hooks
Date: Thu, 21 May 2026 17:21:51 +0100
Message-ID: <cover.1779379804.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B14792000C
X-Rspamd-Server: rspam04
X-Stat-Signature: djc9nntwcwda1w5ymuizpy8p1s6esgtu
X-HE-Tag: 1779380523-690911
X-HE-Meta: U2FsdGVkX1+SIlvB0JMfCiFwPhRcgTFiToejYOjVy0pdTYdPBTudZ+zusouFPYmr1Sdgwmi7jWqWIvoXcI9SJrZCSkW8XLQwNUa4mAZ6HQwYYmweNtq0SxlM4gMIJQc8tpVToqW1Hq1FwzdKqXOR0cZS2z8ED8c5QsG1SHxPFFg7F0DQLwY8Zse+aCYfHyjhvs35EF/YEIlIihPGe5kVDktXVeufrEMOGbOjixdP47n8R0sKLL3nxUo79NzHd1uzvXSCbSt8Cj5mTpTvnYlRykltm3TwnJnhbBMY4zwVO1Ja8GweN1z7YJmmXN/duaisHJxS8Z26BtIhrUBfCchbTaIojrv0xaelvqhRMBpC0dx7Gp71YaY3/NaCKRfek+XB+F9IaJBk7D/CoiHe/pQQoJsmNPer5QBM4SviKGEFBWc6CEuGk7e7VqdZ2XM2Yp9MBvmOSX0BmCFZUmEuR4YCYxiwmTFA6MAX9M4L9Ysjt+1mf6ewtuwRjyrzciVEpOanlAejTUeHwEOx7XqZp1VLsiavxh7aYPkpVzn1x4EbnJdMFjbzvrrFYr8LGRnJkj3FmQtwYvYpdvZ6UE/jVWQZXGKj4eJ+FGdtPsM30Uqroyl5PZV151Gw3dXuLwcrb7yU9+FgWiiMqwS0nP2c4LC524XN/+kSF58XCqa9zPSP4SzwY0FRg1Hprq/2lab0+UvgUvNLa4kzLevMRGQHQm69X1NyPNwmX7MzK3ikKSzWknhdr6x15WNgUjupvhTgvLmtJxpY9d2TwzKB8qaXtV2ejbXHY2KP/7bXLTWRexctcl3Oq25ohyBd1moXsHhIiZSbW7wwAGmyI+k0O6aiBMHb47jRJzZNW6T0qC82P/5pCYs2nxeuThI+d7gHLW1qxAj0NI5gpfzVWAaFXSXSomyPfamlwoIwqwDs1ynGKAeyNgypDdXBL2vKuyvXb42blMqjwyy5iBlBAigS9Z9euan
 vcYo4CoW
 DRf1dA+KdhczRro/DEqPeUthJkQtCwrVqs68A4K7NJHMg1rr9M94D0Fkrh9X4/deqM9Wrt5It3rF9MqcdwI5pMFA2pUs3fW+n1dJWw/ow+da/DVM8WhR3oBEBLhdIKWPdPuMiAZAUoV9Buln1sJoZn/UUGjUz9ZbvLClaeeSaeEwc+1AA4jiNjVNuKL4HafhxoHltuiM11oBk1ffRUvkiWSLP0V/kdZTldziW3wpyigni5v6pdkXrDOFWH1uOMzVNRB9D
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

Lorenzo Stoakes (3):
  drivers/char/mem: eliminate unnecessary use of success_hook
  mm/vma: remove mmap_action->success_hook
  mm/vma: eliminate mmap_action->error_hook, introduce error_filter

 drivers/char/mem.c              | 25 ++++++-------------------
 include/linux/mm.h              |  5 +++++
 include/linux/mm_types.h        | 19 +++----------------
 mm/util.c                       | 31 +++++++++++++++++++++----------
 mm/vma.c                        |  2 ++
 tools/testing/vma/include/dup.h | 19 +++----------------
 6 files changed, 40 insertions(+), 61 deletions(-)

--
2.54.0

