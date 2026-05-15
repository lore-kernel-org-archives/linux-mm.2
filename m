Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 727E6CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD73F6B0005; Fri, 15 May 2026 08:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A877F6B0088; Fri, 15 May 2026 08:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9760D6B008C; Fri, 15 May 2026 08:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85C416B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:00:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 145A41408E3
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:38 +0000 (UTC)
X-FDA: 84769512156.04.7B69256
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8774640014
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=igMatenk;
	spf=none (imf27.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BHfidlK5P3BMYoLyVgvpVhL1YRgXlDj6TmgAjiN+HNA=;
	b=8DH5JgOv9rlb8cRDk5CIeoCYraFIGLzUKv918aHAb29P/u3aGliVPLfJs5dyYQ/uxi54gL
	xqyDdIEbjNF5gyYPBVYp2r/zfHrpvJn/ZePtFdjLesbvxty4fM1JJjQPe2qe1SAtsK9++V
	HtGAHgRAZIZ84aOe1tULDl5VKJ83NoI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=igMatenk;
	spf=none (imf27.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846436; a=rsa-sha256;
	cv=none;
	b=iaQMV4jNp62uCO6v9wdewnzZC1B9XrvWQOAUkFtUWWsp+dLa2M3CLxTPpWMzzUubPB4Top
	bfGtGs8ylbsWWE5lO+uX0PFTqyREtpxDYPF9dk9x85cYwEnAs2+0r7VtE0z3EMUQbNP3BW
	3b4tEo0Gi5FUk+I/iLyR9DJCjQ48Nb8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=BHfidlK5P3BMYoLyVgvpVhL1YRgXlDj6TmgAjiN+HNA=; b=igMatenkTiuOR5nFhy0pD6W02Y
	DM74k+KyGZ9eaciesKcyAlIezcPSoB23A/x/fVqgIpnSYUnLgnEVfZiXT+y4uw5WGLTPBdqnmpA8k
	iPcAmOC+sjOaaVJ4zpRB6S5VmNRhuyZqZLdMtHu3ap+Tt1sV4b2LappSpLQQ/kinDnupYxTudoKp2
	/v+OkexLSPtjr9mtorG1h7xye/FrcnOAsonrYt1wwL2zawTl10dVUqA01ssPBRwVr4jiCrfJStH3g
	nJ/yqenv1oAwdEUMb4s1a+5oWFYNysAjoymn6OWkAoYEMdQ3zvhdMvtvYP+zs8G4bzHtnspre/xh/
	ES8F48/A==;
Received: from [2001:4bb8:2d2:300a:b132:4044:9ee9:7f18] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNrDM-00000008GSR-3NHf;
	Fri, 15 May 2026 12:00:25 +0000
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
Subject: RFC: better block swap batching and a different take on swap_ops
Date: Fri, 15 May 2026 14:00:05 +0200
Message-ID: <20260515120019.4015143-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8774640014
X-Stat-Signature: n9bznajiutx9mmqntkce31d8zbyhfphf
X-HE-Tag: 1778846435-370683
X-HE-Meta: U2FsdGVkX1+YtARn84n6MlazVNSIeOyYB/1ccVZ1gk/QJuITnRUbgaEgF+RzGGEd3RgogY4VeUwGeQpIdW0DnvZns+qoqOT+96XNrbKyrocu/F6wuFhYQfvKWlufBAVPRwh/n6m3YaUlYJGfzz3WroG3ObDqBTjhKncEOvkEO9zcKiYmf4WzsZJaP1eLuUwXEOpdPyemRV/PA4/yuJDLfoWk3ScdHRfsK0IO5hQ4Z6BQASJfw6aB8uSZrhn+ErO0PVbczpiddy1MSWWmKZIQlq5lTvhrOz2hBHTAbhpeZMsgQWrv6swD++NXjaVIeDuBT8iOWOATIcPO5QiUcIJ+rOWp/McDUrPCenAf+iXc2YKZCql7oRJBsISoo7gp84LKhe8j1jJcwu2c7RX+bMSFLbHZio1LBAYW6pHa0SZozaeKrrjIxX2fCq90nfnfOpnBd+r/pbDEwQokCYVznSG0HgqkcqbEtxFVr1eJ4PyHkdXxDU/heuoOD9hiQM9PNHguIeUoQN82Nz9bhAkvc22xwpVbgXBh/lhNbN/x7IxG8k85kweBKU08pQ5Q76OKJNuT2922VvZnVzAgqz0kEbid15A/gkVltHSz3ZU/ADlW4pc5HlUhFTe0ARP0zPFOn5+tXONAMsLM54s/56L36UOPtdpUNslPinS06ZujY7ZzFskOfppNbDW/fMKVED7h1hdw/xJLIp0/bsW49rp/DH9KCFjWLuGZZDdAuVU9D4OWezBe2MkxQxVfWK8s64TZ+rj0Q0bko2YmOlcA/4WqU0hdsh5/S9PuSRSEMQCKVj/zqDyv/w4Ufth4ofMGp0crZwA4DWiwSbapLHjDVMzOpi5Xv3g+AyWagHlEPNnRNs9tbrtXRkNgraNOX8BYt44M+r0ZBjDd+9Xg8/vDEwZBPBbBlktW4SjSbcBaxxudbqPSdRBcq3USCmDei+iSzdphBk0UdzBD6I2PQTxp6xZi4qe
 IOAxHm1b
 /PW0dJi67mCLlfKIlqxUSDlrYdtwG2892lS6sx/n65SRS5/g+TShhvNXlRYljNus74+FvKmdDUsOVXSuwT+iitVawWpNNIZfOq9PzM5CGG/QpoZaZr8MSnTA78qgz5U8KIgU+MmMRzC8vMzKl+qdcKzJFQAWT4hm+bMAWiRmRGL0rl7TuGzJuqKu3RUAatuZtM1QRWts9HZm46/mZhqCqnCqZQJxk21RAaDbu+rM+vFuQYUYKqHye7V8IfkCjYhEGiM6wV3zPVDu057ZPuRvbQQBTcxOdMWrFOlMHJR7Fb9BMoWMlJ3ZtwbGQIABeVLAKSKWyFSOpoWMggCKLV/L7gRXl6ULlaj0vX3lIcfUgtl8uDL+YVLEUrYukTz1NjsBAa9g8RqU6ZkXKpsRqOEu3JFbrOXj9SZrftIJLtpcI7ld8e8ePD1LPcfiWC4IiyMZ1imx8lzpFNYVQTPRD56nSZhaifr7avYFOTy4bvXCh3tV+oUGA+wPpebB4L6KwmwP+QwfWZnnZlXoAzv2Uyggasho+sTm9Bh5aNrR9f0u+67jOD0belayfaf0dFgl/O7S0dMwdBbK2ihhVKkSmSWUlvHp/M+hdJPptMOoS9Aj8NcodQABf6ZeOm8Ezh5EATab5FYzP
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

This is very hot off the press and has only survived very basic testing.

Diffstat:
 Documentation/filesystems/locking.rst     |    5 
 Documentation/filesystems/vfs.rst         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 
 drivers/gpu/drm/ttm/ttm_backup.c          |    2 
 fs/nfs/file.c                             |    4 
 fs/smb/client/file.c                      |    4 
 include/linux/shmem_fs.h                  |    5 
 include/linux/swap.h                      |    7 
 mm/madvise.c                              |   16 
 mm/page_io.c                              |  544 ++++++++++++++----------------
 mm/shmem.c                                |   18 
 mm/swap.h                                 |   52 +-
 mm/swap_state.c                           |   40 +-
 mm/swapfile.c                             |   11 
 mm/vmscan.c                               |   88 ++--
 15 files changed, 402 insertions(+), 400 deletions(-)

