Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE02F1090224
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCCC6B04A8; Thu, 19 Mar 2026 09:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D3A6B04AA; Thu, 19 Mar 2026 09:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282766B04AB; Thu, 19 Mar 2026 09:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 144E26B04A8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7387B8F86
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:22 +0000 (UTC)
X-FDA: 84562821084.21.500AE1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E77CE180006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NwrSrQ4n;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zsW5oHufADg+8fCIm6wMohAMRyBpLu0ZNQ/d+QZMsXk=;
	b=Ijrm2qnsE7IBxYN4DiNz/WymC5yhDBxRnvZzfp8+5/tqN8mVzIUlNDyANYeCRnROnoSC4K
	VuJP8UQ1N1aFaamMHB8RE0X9M04ItSkc3h3Ly2ZRBWQx9J3k6Hvm6igJ6N25BkiXrb7Xom
	PJ7AMEDCCxw7lEtBoTfjLHp388JfUrE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925221; a=rsa-sha256;
	cv=none;
	b=Q2zjFu9eS18W7KEmihvn/JGOT7dG1B8sUYcb4bQ29v4KBgz3n+PxRX6RfKeiR7eQpGunPg
	3jgE8HfOI7cRlKytFAm/FrVmpSInQU+AdYD7vfgUAJvqc6ZyR/CB72wPeIQDOHhu3GmKe7
	LtuMBtuvccJJreBz+eb4ojo1E5oZjyg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NwrSrQ4n;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D29C543CCB;
	Thu, 19 Mar 2026 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206D6C19424;
	Thu, 19 Mar 2026 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925219;
	bh=3MiP4hdPB4G8SsgHRaYWC54kCzT1i0VZfFsgmWsL5ag=;
	h=From:To:Cc:Subject:Date:From;
	b=NwrSrQ4nGZ05RHaH3tM9BK2AkchwEf1OlaR8TntUqSeSQfcXPrB2CaPhDZRMd0Spy
	 8CKeUnleDvtJkJ5Uf2PfYHOeIos0Z+HU0/vcwlkEf57LYCy68qQi7EsdNqjrDI7et+
	 FpiApDXM1c2glnuiSk+WhG9lRcQ4rYXHv4vIXz9y4qjkblc9trVG560s7AYir2VnAG
	 PVoGL5FAEKi0sAlKx6b4Q9fw/xpnyNKYUqvLqoHu6iPyLuWEL/3oltgVnL0N4ifxH0
	 EOLmtIrFZ6Cc6ufnjQsS0zpJczJyvWLkxC/Y7FHYi+MrdjftFvhGSlqtypz1LMUX6z
	 JUv+lovSkTDkQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Date: Thu, 19 Mar 2026 13:00:06 +0000
Message-ID: <cover.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9miykiq515rqqabjbck6tfo7eijq3x7t
X-Rspam-User: 
X-Rspamd-Queue-Id: E77CE180006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773925220-284048
X-HE-Meta: U2FsdGVkX1/sWpncd2dVXyI7NHP/lUWAlyI+EdPo7fyce4Dew98TFuSiKAh+RIgffomGozYnBN7zelJhOqnUJyYPQYay59QJnW9CKCk5Zbkt5HW+xFCTDoKnrdkr7MCdG6LqWog2blhIsbhisbtkdUdHDTbZi/m/mrgF8XBtME+GmPMxl/RvQYtHIVhUKV2sLpsuFPHoQWt/wyYM3ks5PkMI45cScfPs/0HMEB+Vj4EbeWL9y7gstpFVimnNNCFGq2V/pTrEm0bptQZ/+LuE4PWV5Yx4Oq1fKdWwESVkMasLmjwDJOpx2Bkjbhn8m9X68cDvCOqamz2F7Cj56dl/qTWTludFQfyqm2zCOaYZ9IPfNunOx/Qohj9ZwpqwWzbG8dUq+KQTPuBWzZVa1+21UvG27YLSY0K/IAVgMqBJCif0oT3/vRyOoiRF8wbFUwLQkcqVInhDmTN6IOHAtGO5YZaVy/ugjm02c7eAbuTXnFZBGsiRK3Sx1BTswTiL/GuNTtjloeXq7FfGn/z38a8clW2MZWkfcJoFAPNEYOVgiKVPeNamAcxtlqqbuF03wwjKtYYucrpP27KwTs2TsEMiRkDZFs3OqvCgo/b2EdSaRXU1X+ZBKnj+XDECRfQ0QZFtUZq1dIrLdScSioPPafurx1e1RDVILOZr7meskUcqUwxpsIlDocKyP/LvKkunxRjDY1OkY0vdRDigkt03vRpNWVYjlVTHRSphoVEBoKWGNZ+rQmctg6FRHjNLO9VF7qt53bRXrb0x4O+CoqgrOP1Q2eSvoJMdv3aGC3v4GlRN9WqYZZHHuDLOCp210oiRKrhjnuAxAyRxhXRMxdIeT8kkPqdefnAh2WHkpYVoD9djRvZUipHkriloBQ0Ivygx6aVJTQtJoxJ5LXZRMSn8mxYfZu6FZgjjJSwSidcoZx/hOuFMVk4O0RJUWUmiYWfjHSO/h933yamg4f7bnR/X2E1
 3/7QScan
 MZdiC/B7/3lF6JKt8qXpdmLoMLHWAimIt30fmSXI20RKWRRzawKAmWGutc9NdxpSqwOsmAbJEGgcADDt5kusJsiaNU0dIw2lcZCp7EQ2fYewoLEHDVMhhrc7OTlTxJJ+UHhHD/O73l7BoGVWSZbRk22WoRb4qwBfrsXehPbOnK6iZQEGWvN+34gKC6b3zjHs6LMGXcw9xuKo2sk969/TM3mhxxgq0Kvw40RKan6017Oa+hodW4d1PU4s4j8Mnw5fzdTsWTSZ4e2/9bD8OHNKZX5wgDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zap_huge_pmd() function is overly complicated, clean it up and also add
an assert in the case that we encounter a buggy PMD entry that doesn't
match expectations.

This is motivated by a bug discovered [0] where the PMD entry was none of:

* A non-DAX, PFN or mixed map.
* The huge zero folio
* A present PMD entry
* A softleaf entry

In zap_huge_pmd(), but due to the bug we manged to reach this code.

It is useful to explicitly call this out rather than have an arbitrary NULL
pointer dereference happen, which also improves understanding of what's
going on.

[0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/


v2:
* Added tags thanks everybody!
* Fixed issue with returning false on bug case potentially looping forever as
  per Baolin.
* Fixed further issue in bug path in 5/8 with double pte unlock.
* Add patch to use vm_normal_folio_pmd() as per David.

v1:
https://lore.kernel.org/all/cover.1773865827.git.ljs@kernel.org/

Lorenzo Stoakes (Oracle) (9):
  mm/huge_memory: simplify vma_is_specal_huge()
  mm/huge: avoid big else branch in zap_huge_pmd()
  mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
  mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
  mm/huge_memory: add a common exit path to zap_huge_pmd()
  mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
  mm/huge_memory: deduplicate zap deposited table call
  mm/huge_memory: deduplicate zap_huge_pmd() further by tracking state
  mm/huge_memory: have zap_huge_pmd() use vm_normal_folio_pmd()

 include/linux/huge_mm.h |   8 +--
 include/linux/mm.h      |  16 -----
 mm/huge_memory.c        | 141 +++++++++++++++++++++++-----------------
 3 files changed, 85 insertions(+), 80 deletions(-)

--
2.53.

