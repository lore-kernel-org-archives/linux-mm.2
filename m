Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B5EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25876B00A8; Tue, 30 Jun 2026 06:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCBE6B00B8; Tue, 30 Jun 2026 06:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A316B00BA; Tue, 30 Jun 2026 06:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE546B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:54:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01BD5120464
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:25 +0000 (UTC)
X-FDA: 84936270132.01.9326338
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 44347C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJgceCav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816864;
	b=LuSNCuJ1k73qB2aCeGxbh6LEUYczmTCq5z9p2I/PuIL4QcZlsKH4An8JMWrc3gCy6CktUK
	l4Wv8WsmB0O/Ajux+RpHY8N4F13EW1/pCCSZCX4FsLLrwRF10GA7viYU2YtvGrwpDNwm61
	KC0tMkwdaLcANX5AYgTZIfAwVqhIgBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FnV8WNv2U/2NeCf/652mdSlf9RYHKUxm9hACRNRtpLQ=;
	b=ZhgJemR2rCcO4D4aanN7b3aj1VoSal5HdMI4tuysfm9eObCsAxnqethwYjRd5eWR0wng7r
	+zYIIgq/UwxdZh37a4rkTCQ6J3nknAWjY8BvZlJuNUD7ehYF6F3i+PPkoV4cu72ZyoTzAL
	NBIH7nvsnuSUVsuDL3KAMGgNbTO0vFE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJgceCav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C3B84043C;
	Tue, 30 Jun 2026 10:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2563F1F000E9;
	Tue, 30 Jun 2026 10:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816863;
	bh=FnV8WNv2U/2NeCf/652mdSlf9RYHKUxm9hACRNRtpLQ=;
	h=From:Subject:Date:To:Cc;
	b=fJgceCavbNPcF66SdZ9l13sifefI0sGJa2R/z+GKzBrF6OvGDYZL9bxpDhALEYZfg
	 B+OQ9FyUviVgK11A9a03ctqjcK1DF0Zkcw8ZPHNR++4Gn83wGnDEYjJVjgMwN0K0jm
	 krV3K2OueN3a6Hvez+zmYWyAPzsRP9jxD+m9prbSRIIbyghVlpOmvsJ6uq+JpWTa8T
	 KdvIxZ1KHQRxye+1mO5tSoXGtsqWbl7ZVCJVHsbyyCPLsSUY3eCYmeNEUH60ZADbNU
	 VhftXGA08ItqiRlKnf37DEIAlMF+a4DKeh5D+AFXfXhJO6Cp79/Y0qO4UarPwEcDJq
	 ZffD7riVNrXkQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] scsi: replace __get_free_pages() with kmalloc()
Date: Tue, 30 Jun 2026 13:54:17 +0300
Message-Id: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFmgQ2oC/yWM0QrCMAxFf2Xk2WA76lB/RXxo2sxFsEqiMhj79
 7X6eC7n3AWMVdjg3C2g/BWTZ6ngdx2kKZYbo+TK0Lt+cIP3SAEtmWB25JjC8XQYA1T7pTzK/Hu
 6XP9sH7pzere8GRSNkTSWNLWJwl7zI8K6bqAOpNyFAAAA
X-Change-ID: 20260611-b4-scsi-d0b0eb4895f4
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44347C0007
X-Rspam-User: 
X-Stat-Signature: hst1w3f8ysy4xcizrim6kgtnjdyrcha3
X-HE-Tag: 1782816864-472692
X-HE-Meta: U2FsdGVkX19iEgEb+r456WeMKRa+5HGK3xUFcljyxre0UEYqNrhL/Yuc+S80UEZTLWbfTMEuRhsj9vfAmx8fPwD3hrdTbr74O+iw/hlGNarP0GphnAvr8FU4IpdAUCeTWQvNNieXVVF6/Gjj6UySZO3CWwzNhXuOBV+jzwHfgueGdCSjk+WIJ7gMZ0nT7C380mxVBchquFbODNUrThW3RE682EFn3EvdxerXSnfNdEJyYDYJdsXsOpG7rbV3RO5BfRlZJfEELFYAmBmICs8zPFGDIWz7ViRFUf7WuAfLTxTcaawrRada51jljnd9TTvycPEdoQ9nXTRDkGF2h1Z9VokzzDSMS6SCSomXkofQ6sCMq0UzNXruhlAb2fOzCwPWJ26qIpf94tQSK5IT/WvuHAMy3NuJRev2Zon9QN1A2AjLz1ftvipbK8B5nLThfZKMnwoTonu/zJGZQo1L77lLUtPTYorDFoYWjrYx5F1mozetPp22NDI6t2mpeSLcf81PlEPk6sqOVxhSHWGDD4RKFPEZ8STYM5bZLEDo3ZfQcV10PTrBxhjofbVpKOLZtk4aGCVcfB8n3ItT3Mhy1lkqy0yYgpjAxbgBFSFcT5+MwsWR6Rm9635uChq0cPb1eRd/peiPa5HVEomB/Dk0bNWl90SHSQOgdGQ3wdVkGg8O6JH91s4zZuYzMq/cyR34maNzIEZ+sqWmcYyi2ySMtBGsOZY0gipeNhtdNDsZzx2JQP1wl4CeBqpheVYendTJJLexutjmr9V/LYyLLcvf3Wir5LclX4kves6dnOQPBJUArEfxM36oGfqO+t/UIOdrcBpbbmufcLh/Lw6G1QsXOjZDminDrzHL4SaFI5kVerHplKvfMgXe+Esd1F4ohPmIFprASNOot9mwfDlsQLBPrfNN2dGpuXsiHfU3zloI7EiFJ1lMl9UmO6gJC9x+wWZ8/AWrVPDeNu2nHiNhmfir42i
 IhrIpcEF
 CJxZOY//1cQ0F1shu3Re6yc8FCQYUGbKbvQWy1dDnZqAXSzmJgT8m0Zg7bqfzqDoQcY75Pbm5oRuQ0ahB4CDu7/kwNKjMq1bbuzQWCDUzkcJLLBjTO26A+teizp8uPKOFsxsK0U7S4a8ZMkMLwG3hAcQLwiyL6QJ+YlZaEKeakmZEuz0ZFkuccJyDSDMdozC6eqtsu2csnRW+3sSpj2SkRh5XXNOIop4blbNPL1g0ilLM387e0WT0rCfKbtr06PY9qSXuZELo3+ok5k6oNVyrsY9FymTvlnyn30Gc2ebfTsuMk9enhvxXLw2C20Vz7DoDRs3a
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
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/scsi

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

---
Mike Rapoport (Microsoft) (4):
      scsi: target: file: use kmalloc() to allocate temporary protection buffer
      scsi: proc: use kmalloc() in proc writers
      scsi: ipr: use kmalloc() to allocate IPR dump buffer memory
      scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()

 drivers/scsi/ipr.c                  | 4 ++--
 drivers/scsi/scsi_devinfo.c         | 4 ++--
 drivers/scsi/scsi_proc.c            | 9 +++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
 drivers/target/target_core_file.c   | 4 ++--
 5 files changed, 13 insertions(+), 12 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260611-b4-scsi-d0b0eb4895f4

Best regards,
--  
Sincerely yours,
Mike.


