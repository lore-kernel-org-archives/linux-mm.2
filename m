Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC3ECD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A176B0088; Tue, 23 Jun 2026 08:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4366B008A; Tue, 23 Jun 2026 08:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB7A6B008C; Tue, 23 Jun 2026 08:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7E96B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:57:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0DCD404D8
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:57:40 +0000 (UTC)
X-FDA: 84911179080.25.78C159D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E02C10000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:57:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dckFqZcG;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782219459;
	b=0rqqcKyBu5+LkexUuBpoyFBjn8rBZOL/IHU2AHHrVwCCXJT+oe9vLoGEOd6AqwbKTAB2Yd
	gxBpGM8ga/ZbY0K3wW2OCIWXUwT1P3zh9fSumkjW69ao1SXHvr+tW/Dk3+UhMmgmjhGmwP
	WKcoGkCz7qShcW1DBJmAL7Kf9baBVVA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782219459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BfiHcfC/HNrjdCzSHYaGKycjZwkd9641X8dMcVD0BYQ=;
	b=ilyZr2sTcjlb7Un5DgzuXDW3UbX+pcaHlj+gNqIXl9WCZ1q3N8oP0dz5O7ur3tJJ0cCm8L
	ScLUb2fVbX34xPODOcIhNQBDCXad4yZ+sG/OuQjlI+kFPXHW4b9gtQuXfCPCXRv4ApjU2x
	6evShz8rLE6J+aD7XhpfvJJHWEEwVW8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dckFqZcG;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C41A61A25;
	Tue, 23 Jun 2026 05:57:32 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4E5713F632;
	Tue, 23 Jun 2026 05:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782219457; bh=o0ziYkBcjN1jfdxplcuz3Rv7zoo2ThGtGLd1gyrqaa8=;
	h=From:To:Cc:Subject:Date:From;
	b=dckFqZcGc4E1g04tol6xOqpVVtA4tlcxyttraUQ8VaGmW+BTOJfcyQiuZIIV/TtQZ
	 qxd2072Pa5XKgFTPLhWIUqWjC3mPUK2Cz+9zA79y3ji1S0M856iHkKk6T3cPN7J1Ud
	 WIwHPqjAhw0qaZ4jAUHZvmZpj2MhLh/V4EnNylwI=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	liam@infradead.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org
Subject: [PATCH 0/2] mm: drop "sub" prefix from various places
Date: Tue, 23 Jun 2026 12:57:20 +0000
Message-ID: <20260623125723.2503832-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xrgoanxat7faadgtcbyntfu3jco4y7x9
X-Rspamd-Queue-Id: 8E02C10000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782219458-710498
X-HE-Meta: U2FsdGVkX19xu+NkSZ8+mV9l07fM5Oz/gJ33QjeVsszMgh/7dQGzssABnrHVMOVbUQ44ImpvW4pK/aGKA1oSwWmg1sLd6y1c8nDq8Yg0j/rHjb1qs/sSCg+XoAodQcUVmvRkM5SeltNOVMtKCQxOEfDc29PniZbKgm6pF+cfrErd6rLnCIfAU34FWim3OSt/dSu+tjT9zMoEiHjkFjydQFb0eIbiGtobD6gLiZDxD0MrZSAnvzXdIN7JFSLTu7Djt1FJaSHSjnqsSxA5YTfZ0ziuaPPYrrIRXrXLYMTJQlNtZtQqJ/m3qMTv+jyI6SfPUmv4H64zoYzZ8JXxApxF1d4G17lG4h/iCTomi9RvJYD6yQPeyh8gyi5s4wOF9Y8haXZNLrWp+QGMMPKPsO7m59TD1g9rtYJ6eILSwuJh6LRw5iufcw6xLIi7lofN3qhgCMyTEGVE5fu13AyMLPS9idCLLKDgfxzkFb5vlDZmFMan2BL4pez5eGRT8mrHmqiaVHmHzZ+sn86mMdc1tPWXVatfsELPr6WGVvbe+Gs3ucd1VZLk7z+Rm6pXlVxCx19bYYorg00NiB4u3KZLLC7A10WYWfKeVxc5+2wMLqngAeYZ/RGDRdJg8mftuzeeVpiZmCtA4DJ0n4ITsJsyFyyXVmJtAEIJ0mpmmJdZoMu3I/ReWD7Qmvv6nkhq9bTmoPOAJd1ZkBnlgipRXXErURjWL7bC+8j/smK+KwNe+bPYyMKB028+DdIgv6AWBCwJg8YuGMMZfaOvC4e6CxWfVdVl8/TvNdxeTD3bcNoaTUv7+zdhYMK41/09D6mQqyKN780m6fydht7qOZs7SRwCgexQ0WwTZxExnE0yayA2/HWpjpANlX21N6PqIzjK/UI850SN3ACw541cM2PwPNZVHmSv8IxhUxFFl7YhvxjRP0YybdPRKVWg9YGBiEG1+iyG2odU/gxdKrT2Oqdsu9xo5bq
 xxIjxPMs
 ZuF/s54ZlpN+arPESAgEDoeXeBB1uyDZpsgrGKXeCueInmhXmhDj3V7pAD/uuYGMZPdbumjsdaVWvTR4BNOcf9KioaWr9ynpB+Edt5YhWZ2NsLyhgTH0yLlpyos4JKMW4Y1wax1Nsni51sLslk3wCZj+Sk48RsOMntmZpzFr0H1o2TEzOCB3ac//t/0JTwiQG9F6opd3MSDNKATJLi7Ij5Laj37mr8BV7vZ4LtKqO3sXA/maO2cvpOkxja4lXXg8N8XrDtsKSAc8tHvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 converts subpage->page : folios have pages, not subpages.

Patch 2 drops "sub" from a function and a variable because the context
is clear enough.

---
These patches were originally in:
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/
as patches 6 and 11. Split out for easing review.

Applies on mm-unstable (81652c5a65d4).

Dev Jain (2):
  mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
  mm/mprotect: drop 'sub' from batching context

 mm/mprotect.c | 12 ++++++------
 mm/swap.h     |  4 ++--
 mm/swapfile.c | 16 ++++++++--------
 3 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.43.0


