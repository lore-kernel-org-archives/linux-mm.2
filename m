Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCDDCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213536B008C; Thu, 28 May 2026 08:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB0E6B008A; Thu, 28 May 2026 08:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2DB6B0093; Thu, 28 May 2026 08:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE46C6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9456D1C1BAA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:15 +0000 (UTC)
X-FDA: 84816801510.03.8D403BF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F457100013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AkZ580dc;
	spf=none (imf14.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A3BzwJIIGY9F6C+HCCYFCKhIv3s663VnBbBbRJQyQYE=;
	b=K81UDZlTVFL+V5q0nfRmDw41nKYhyYXcYAgORuE2rpTkZMli+z6d8qEbbIEGEKvC2mU+8i
	mdCu+TG7SfgxWKRmQcLFz0RDzqgLfHdeKbO/nclns2qtWS/O2dbroCVvUaJE9GF+T6GgN6
	rWUv6hrOTIE/UD80y2xhEMCNrxVkF5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972374; a=rsa-sha256;
	cv=none;
	b=EhS8pGOaBEeBmg/Dg038NwVf8iscT87f1g82HBWYZTqSj0N1QSvTPUQeICSTMWBk7s0bv5
	DQGk8iUQG4ei3Y96RPUu7prN+qcfV4jI5PhQYCc8fFaXqqcAPvFzeVbXwJNsOeGJOuYTMf
	0fN1Vu+BKKbfjIbOsf9YFKt5J3YgEqQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AkZ580dc;
	spf=none (imf14.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=A3BzwJIIGY9F6C+HCCYFCKhIv3s663VnBbBbRJQyQYE=; b=AkZ580dcsZcRIR9kqbrmhkPMan
	NPHiW7Tp2mQTXNV5cb2bx016FyM9C+AdWzocJDHoP8Ngkx4kVMKOWDJ1Q8DyZdRtJI1LMoyxRbmS1
	DFCsyUi3Iw40GzLRNHw3APGufNii53HWZB7BVqwDv966+bGRNHw5pEo4IEsxsJZ4VTH0945qYcQ0K
	nCOtsESukS8++1jIpGe0pbZ2hAu3zwp6anodW6uo58E0a2H39leNEvi8940fjyUdOpaw41a5WKQPH
	/4Zwcyek3E93VPfuO7s5A1ihxv2qfgLohjVDbuasSK0bNcOIRjUphGfojUNGnMbPMYV08d7ooOU4C
	UM+uOXWA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa7g-00000005jdJ-0W1U;
	Thu, 28 May 2026 12:46:04 +0000
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
Subject: better block swap batching and a different take on swap_ops
Date: Thu, 28 May 2026 14:45:16 +0200
Message-ID: <20260528124559.2566481-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Stat-Signature: 6t6bgteqeedq3j3z7ynyecrbc83pczr1
X-Rspamd-Queue-Id: 4F457100013
X-Rspam-User: 
X-HE-Tag: 1779972373-109469
X-HE-Meta: U2FsdGVkX19k2Q5vJyt/4dU/DlNgVllfGY0BEvC8IOODgcyZpWww+K5wVglU8jn8ePWxEucCtiwXCfx+o5cpCtS6rPZ4nvEsLgTgRFRGRceDnTlOAl128rnSoupEYAF92ylnrTXL8IT9oR4vczImwASZxbEXVpX9cqxO9syTkT7swAQ/EGVBn0jVWuIm0bk3c0KR+Rd02WLrcSDu/Atht0IOkKlW1Q8w3KtGpNfowx4W8CGngo8r3aoFjwnYJt6WT44wU+VJ4AsCio+QeJXfNSRtTh/7UrDZ4VnbPvYOL+JaGqMRGCPh3lnH0dIULHV3bMAs2IGwfEkVGUDM3OKo18B/TVW8Nw9s5by7fS2+Z/PD0wcykFSKNo6WTxtyRLPlgvY6xqSP9digZSixfzfHelZgFp/ly6BHRU4oiICP2SjUEmDDWgHHDuVhPN7cJZWXCUSnMy7Noh7k8XBe/P38ctCq7Uyrj2A8+KQnd4+ph8R6A3Te3V74pBHhquBQvH75nVWmNkL4QPmmUiKTCqPQJxTNIjn7Uc7p5UiF/zdhdmBHk6Zl6yqX3rWAIVTzXx6wUFAs6TG2esDodZpf1FZjIHmVyMCtKrOBv8+dRrmobYOsiB83OE92G5JbcaLDXYpvWoCH2ZpKl9uUGcQRPuow/VZVR59ULbhHxfrMHoLBlzNv5fhDVRMRDYBrraNx9sBXXGKM0TbjVIxp8fgRLHdi8LqwNr05DZC0EJ3zpF4YYUuxfQaoiapA3L24kPSy9NIXDq1IQL3Ll9cC36X6aDBbho2HBhCYZD+u1K/WuGBnYEdoRunwffTdQD/k3PmMum8WmfFNYiDIZAfSxg/SkVVtloGqdZtAWT7vCesSH9tsBmhVzssRLsO3WMTwyUItcBHx9QHyBLRVPGmSwTKzeFh/hm3/Dm8tB9BnO74xOtuxzZILC+FsOweT18yTGYZSsDgcaH+KDN7/34gHf0b32zF
 mFSgvRGP
 4F1JJ8qtwrMxJQuvfNk9lbJQZbYtA4RWGdrnLt/WZC272yYfZdHlcxGDVPyBTEVjL1WQ6/zuZvxQr0xZOgsvoyDyuf4ADsudP7GPt7nh6TeKFQnZY4+swshWwF8SthyaHsd8PoBq/O78dnplPUTK5Fj1ZZxIBsvLZ+CUila6+f7tgkCeRRTicJMRAm9af2IzFuZBPxrtLb0aLPKPGYFn3h5vrdvnb6hYTGrmY9DTomfm80qJ5uKU/TAlY3jY9B5jioKQbnes/UKOEaG/8siNKxivAgV/zy6/TQ1r+h2H/VsZZCtDQTtmf8f/g6D0eenPtzQsdGtSkg5qpMXKRxcIc16ZvgDZLX6ed+D7I4fAPW2FT/dSX9wOTaVoMMMn5sZRqOcFkXyuni8KqvHzROhT4KtAB93v5eRfpcmx8HQZPEZFgb5Fp/oQ1DOpt4PQ75R4lA9SKScmQlmaZ26CShCrZYteQC7QVi8tEjWhQhPRxSn7gScaMVhBFq0Tb+hqXm/L6ZoE9M3svcsoIREg8sjiOtUx5DbqUsWVhkYiZuWLSF4XnWxkWDtpAVCxs85c2pICf/2VXrcEdQSSQNOOTzwNXPYnZ2DiRrRXJvBiopsz8rzDlAql+a/8+eVcrirMck8pcPXg7
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

Diffstat:
 Documentation/filesystems/locking.rst     |    5 
 Documentation/filesystems/vfs.rst         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 
 drivers/gpu/drm/ttm/ttm_backup.c          |    2 
 fs/nfs/file.c                             |    4 
 fs/smb/client/file.c                      |    4 
 include/linux/memcontrol.h                |   10 
 include/linux/shmem_fs.h                  |    5 
 include/linux/swap.h                      |    7 
 include/linux/vm_event_item.h             |    4 
 mm/madvise.c                              |   16 
 mm/page_io.c                              |  568 ++++++++++++++----------------
 mm/shmem.c                                |   18 
 mm/swap.h                                 |   52 +-
 mm/swap_state.c                           |   53 +-
 mm/swapfile.c                             |   11 
 mm/vmscan.c                               |   88 ++--
 mm/vmstat.c                               |    6 
 mm/zswap.c                                |    4 
 19 files changed, 444 insertions(+), 419 deletions(-)

