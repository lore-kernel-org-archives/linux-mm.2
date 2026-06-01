Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECAEACD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3BD6B0337; Mon,  1 Jun 2026 07:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAFC6B0339; Mon,  1 Jun 2026 07:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC00F6B033A; Mon,  1 Jun 2026 07:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A86206B0337
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:35:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57A1A4063C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:06 +0000 (UTC)
X-FDA: 84831137412.25.C5F87E7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id D264A1A000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XFA1zOTS;
	spf=none (imf19.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780313703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Hysc+udobRkQwekN93sUO0TQ7hEgNPhy7lmH/KiO6OE=;
	b=CBsSZg3R3e16v2RBy0QAIVzgSevbUsucu7fvBM+67E/LwuwBEs7OAy7qfbbIZpaoikITuQ
	AgU4LRga6awH0tNcwJqcbglX0WxPe+3VspgETMFnGFMIxg2VJd4FH0vEWI9gT7IqN4YNoL
	XJAOxb4gmAPXoJGVlo4H5n/9gmb3O1M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XFA1zOTS;
	spf=none (imf19.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780313703; a=rsa-sha256;
	cv=none;
	b=NOs9xYhqr4jZQs3PG0xwExXWxEeHM31AN48+XcQTQhtsr8UISTOuRz9naZa5e8F+CNmKqh
	LVAyXKrO9dTF0skU3G98twRxxxjM3vMJerJ/DaEaVOT7TOIIn5i2uyja+YZeb4t4aV2mpb
	xjY3T8HVIfiw8blediTEj5KxmEK/WEU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Hysc+udobRkQwekN93sUO0TQ7hEgNPhy7lmH/KiO6OE=; b=XFA1zOTSPxn+Io+ZgCLqeeQSEW
	W6LAAph4Uo1qbFVO6koylgyggZVxWHNPlc/jxt4SSto6CG50aARk4rGRwJY3Vv4Z9NmlUNwqJBNSK
	Ryj/RfmL7l6eGLv65mw3Npv3nKpM5S7lxjDVRSNn+5f3TUdxzE82LBjP1nygGcLQ3QYra2Hm53m9E
	H0ALcxnnHB/DZAU0DwDo02u8GwIZSLPxNadmJNFTzW7Y1yzJEvvWLio7q2oENkftBj3axHaGLmosV
	oQlGiuFI/cZN1cWePKcqKaO7NYOKSQ0+YSXa2vU8Ks4SfuFif4BPaf/6b2JIjqEY4L/9VQlDrABNV
	LnHE65ew==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0uz-0000000AkZ7-1AcM;
	Mon, 01 Jun 2026 11:34:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: better block swap batching and a different take on swap_ops v2
Date: Mon,  1 Jun 2026 13:34:26 +0200
Message-ID: <20260601113449.3464734-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D264A1A000A
X-Stat-Signature: 9e4ucgio5q8dbc9oyqer5w61jzipd5j5
X-HE-Tag: 1780313703-472621
X-HE-Meta: U2FsdGVkX1/mT/D+Jn/0qXuEH+mOqUeAhOhG3ky3puaqKsSCH5UF6QyAzr/NWEEnhAfszV9wZrOrhWvkX5EDddzOHt/Nt/pwl/6VuTU3XUDsHUdoK5bRfbBmT30rR294TdIWUbEjM8G4Iv/2OUScOoGEQkrOlH/aodi/lf5ON56v2sMInkk8z6riTdbw1uYZUAbqrDsXOaIOAffP9htuFS672WmAInTJdJssCOVJnKowsxGLXtd/bQ9qHlJkgaZXd+IH8gL/DuRJahIZ+uBV84kYvSAb2aQ0EG9NwXdBRxx4avv/y0UKLyoHvEFHv/UPFORH/pdRbubu6m4RuYB7mE+03odyr0CKEPxMg69WykA0L/Z5YG7Pb4jAp3m2ZO4NryzOfDTPIwK427NOVj/EtHjD41nexDGbJZVldddbxXz2/1zdp/WHpHMzJPiZ6H8zKDfgkQQP5DxO1xMUcNPtlVSnW4x7ReVaddNgSelYzKaijh5uXUv2mTGF3ziD4HU5PTrtay8Eq8ktAPAxB9bLU31qKqGo9NOX0/cCejumvemzDdLcL6BuRWVCrH1KQtSJhHdTCYCEDqB4MIxZQOFZ/JN6RJt6A+TEussWWe9xLDBB4j7bZ5MSGqHKBqQLa+9XAj+ekl26TfwRVCBaFJkORAcLfEOa0aS1FjzNz4d1ifvRk1uVS8BWEgYcCsHHsaAubiOgFol/+SI10XhWGFofOY9GB/l7wVX+AklLx9qpt05hGNbWbGEonvE2Lx0NxNhDe5Ay2Ol0m+2MON0mGZPtosgg6/vL0/KIRWqF/MKzFnfQYE/yZA7deP9fuVv20rweG8ZdigEQGXPuu70ga+mfRsj0HoH6CAlTkC0GQ8R5JPFVoVz2UXtMGb01yG8zOY1R9eka/HsJ1KKZC7iZk7b9LBH6jVI8ip8xT0udjxygHZFE0DrAqMQGfpvF0Y7Dea9+xENg/nesVccUsNuWbYK
 R8+xTdGV
 y+fN2HxcqqSPM3BOHGKujPqOMZFkHY1f2+bqtZZwJTuv9jKdl/Dsb/4bej2Y+wRGb4MarhAnSh954Hi2qVJD2QarsgxbLF+whfJ0lX3jmNnlH3J6OepgqjewvT7fL7joRTpNqEXI3/8db4YGkqbnCgu7o7CCb8KTBjlDWq2H9YasjRFGjQNDNnfCvVRzDMBo2UUMv776Bs43Fu0avPVHK4pYa4aAQLtOTGrVCkGUjce7A8kVT1HlCGw+Or+83zoBnE7a3sAhVXwkpX2qy32MZdOMvO9OdNXpW5W57tD4N/Va7YfRBdpeetrWzPdKpXNapWgf8xQIgCOkrhxiLRpWQ53uzVrBEP9eRLnIiaIdQSIMoFDgb21bZFgSRqybeYtmx063o8hjOK242YqqeToHcWksTEjOj+yWgIX+fvbaqo/nO1FTPQX2dsXjeLCOqjBjF2PHl3xh0t17U74L58BVehm5ZumuutHsfF9gdFa7Atah6mLdC+t4wPxZSNq8R/9y9+tNL++nrvG9adV75b1w0h/1/zIolFaGP87c1tS+qNQ95MnFAuoDnS5MxmDund3RWhegYK4CC7g6yBiiJVjpHKAkaTi2orWlZEUZa9BioXVzdFbZlilPfGF5rgAHFAHDk1MGD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series makes use of the swap_iocb for block as well so that it
doesn't do inefficient single-bio I/O, and then rebases the swap_ops
from Baoquan on top of the now very different method structure.

When running doing kernels builds, which is a workload that doesn't
really do much THP anonymous memory it still gets 2x clustering for
writeout and 1.2x for reading back swap in.  The overall times do
not actually change, though.

Note that the buildbot is slow at the moment, so while I fixed all
issues from the previous round, that run did take multiple days and
the new one is still pending, so I'd rather get a v1 out now as
we're most likely to have additional roundtrips anyway.

Changes since v1:
 - drop the memcg accounting for fs backed swap as it can't really
   work as-is
 - change the related refactoring to not create a bisection hazard or
   compile issue with the wrong set of cgroup config options enabled
 - remove a now dead function

Diffstat:
 Documentation/filesystems/locking.rst     |    5 
 Documentation/filesystems/vfs.rst         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 
 drivers/gpu/drm/ttm/ttm_backup.c          |    2 
 fs/nfs/file.c                             |    4 
 fs/smb/client/file.c                      |    4 
 include/linux/shmem_fs.h                  |    5 
 include/linux/swap.h                      |    7 
 include/linux/vm_event_item.h             |    4 
 mm/madvise.c                              |   16 
 mm/page_io.c                              |  586 ++++++++++++++----------------
 mm/shmem.c                                |   18 
 mm/swap.h                                 |   61 +--
 mm/swap_state.c                           |   53 +-
 mm/swapfile.c                             |   11 
 mm/vmscan.c                               |   88 ++--
 mm/vmstat.c                               |    6 
 mm/zswap.c                                |    4 
 18 files changed, 450 insertions(+), 430 deletions(-)

