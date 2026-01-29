Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA46DD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1322E6B0089; Thu, 29 Jan 2026 17:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A626B008A; Thu, 29 Jan 2026 17:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20AB6B0092; Thu, 29 Jan 2026 17:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBA726B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:11:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DCBFD4637
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:11:49 +0000 (UTC)
X-FDA: 84386399538.19.06821C1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56250C0009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:11:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfGjjc2a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oeajPHpO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfGjjc2a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oeajPHpO;
	spf=pass (imf22.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769724707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=KVlZugfeesUjXxUp8XL7oCu+INXlZXm1IjcFnO+T5egrU7uAflxsBUZVD0IH5DT2iitKb6
	Joo8CC/CLgRuCgtjOhYPDn9/dc6THF9KAgBu8vluuyYStnlRjf0CExcZvOyFnpOG2Lqo56
	V3RtJ8w7kCVoh/aGM5ajWTPG9xBwFXc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfGjjc2a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oeajPHpO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfGjjc2a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oeajPHpO;
	spf=pass (imf22.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769724707; a=rsa-sha256;
	cv=none;
	b=kDOgTAoRgaFl6Kw396nzraOAzqWVTcc8I0ex4X9PWPSJOjTnYjtF/fE2DRQMGXoAn+PJv7
	X6rqIL0rPN61O7Dn56+cr9RrI8nxIYR/5g1S78ASCBE2fcvQribeuSB8eBPLCbtDM9peyh
	uQEQC4X5s+Eq1flmjmwl0Yq3GhuVHHA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B24815BCF5;
	Thu, 29 Jan 2026 22:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=ZfGjjc2aM4bFahKNUOB/B1FzJyZy7SAKy97LdrJYti9LxebQtgjxsk77Gk6JTsI/MKB5uA
	vObmTPyZRHuhNiGGGuZkNjm7HOGpYD/sXbQNzuL1li/yUm2PAMqwmNo0Ey8gFOETPq8yMx
	LAPvXNPwheEK36vFyOJGfvYY31x2Inc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=oeajPHpOiuGa2yxIAsoB8410i7RA2T6/Ay4f+3uyPHpxAsqZ/dgPQvpAqWxOL6MhUbDOis
	IfG3YpJzGPfZk4DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=ZfGjjc2aM4bFahKNUOB/B1FzJyZy7SAKy97LdrJYti9LxebQtgjxsk77Gk6JTsI/MKB5uA
	vObmTPyZRHuhNiGGGuZkNjm7HOGpYD/sXbQNzuL1li/yUm2PAMqwmNo0Ey8gFOETPq8yMx
	LAPvXNPwheEK36vFyOJGfvYY31x2Inc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=oeajPHpOiuGa2yxIAsoB8410i7RA2T6/Ay4f+3uyPHpxAsqZ/dgPQvpAqWxOL6MhUbDOis
	IfG3YpJzGPfZk4DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 590943EA61;
	Thu, 29 Jan 2026 22:11:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YYokDyHbe2kDbwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 29 Jan 2026 22:11:45 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: [PATCH 0/2] Introduce IORING_OP_MMAP
Date: Thu, 29 Jan 2026 17:11:36 -0500
Message-ID: <20260129221138.897715-1-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56250C0009
X-Stat-Signature: s1rz3ajz87ug7h33idgp7dyna9psrri4
X-Rspam-User: 
X-HE-Tag: 1769724707-499315
X-HE-Meta: U2FsdGVkX1+/quIuqRSvgDEFXsVkrnZgC6brN9/orwVRjQDltXrk6mBwZAXTOX3Xx6ZB5csuZaU6G+diHXqThvsWO8G840ro3Tsq1QaIy4wp9y326iAe2YFqzKrhf9V8GvEFCuP9RAr2kv05IEOgehFAiJKWV1mrSykKFEsCpkmTcCPN7PQLJm/zndBM114SSeqLmQhC+sMe/R0UB8dM69dMV1d6R13rJprkecGiPU28+HgaRhkecawrDGvupnGy92oL+yCu842pl+ML2yp4qbOIK1TPrx71I9MiObuOjLet6N6P5jcVSbefsNtYLfyGNlpTo3DDzY/wF8cikOdkuEg8XufPqrdrIRZAzOCulkssec21209fNPeFGmvMDILrNKv09gIHKBvgnj+BrzgNDBGjh72499f7QIVTmGercYSHFp5x5N626fJRMyMiM/iFqWt0jRZZOwjtVvR1zmjBA68JERtX6MKVcXaezD3fiyVoYcDJPNxy58DOTngT1FGAj+cKTYPXfl3anvc9EWXacvnhY39SowXmVDM9gONjZ69fgOzh4Rw0lgOyxdLqGh+7g2p6LqrTrDAIIYF/8nHC864Zdllr/9QRqatiFsE3FLjWKlMkcR/SMhUfSWB17DOWqBh3txenyF6e6nBsPtaDsStqLNiVJdB00OExKYPq/8OwcnO6cLVleLM1JcvoazeqpngdPv3GlhGic09t1VZZH15bSk6lUI5GG15J1sypUtqwzTMAuKgC14J8izuM27/9IPLqcUDyhyFaY5aACiZND/nQSWINuGDImJNM3DwCYWH5ocyy7GsHoKqhHXIVIFar1h3IjeddE9gP5GD2mArSpN08WIWFrCjvQyJsTd3uER+gE13TKjzygm5AR5RpLQmvCU0T0YBbMJzrsin/9RpmQXIi0bUEjcE2XfYkkewzkGGpxtpFu3xIIESnpjZHI8QUcyjD/6UqMpIJq7eRrxK
 VWXYly+K
 GGtT4YzYsU65jwwUuglgiOGxe/Xu8WQ0ULR8gt0azXQUTwpdCAXWO9vFIxhMw3C6UQsC2/u+JSq9GJ4msNf2Suksxfu8G452uJhx4dnIjqNlKYCdmHSsU9iln4lvMoprB2Jp2thyA2R/oQwE+dLFr4AATWrccbgBeNii7078AG1i4+KJLn31LEeAoWH9ILQjyXTtqW8pSHUFoRUKmX7MVgsdVD/pU18v7/0ivy+XB/Eb7XGUzXXSY2FxqBRdl5cMMUqvri1qG2W11jahdmCrQDUK/ZwsgAWQ5PtVkcOGMxbDDjTGAiifmwEsbtWYGk0uf5IrhDXWQlhvuOj0v2XZlKyRq94VkLOl2PRGIfSXrPgKf6+o93ZsRbErwgmT5BR28jTBsHa1QejUfe5t88IX4x+fDBttfaSZOS/qwMDmYGMgXuExkpk4LNFn1WYsUJHbCWqlf1oe67aMf2ONm4MlDJ9wgLBtHO+KOTsT/ONSfL5Z8zae3Mw9GPOEA08ppX6neHN+MUlf4rmMJLF87E4oAYsdSzW4D+GbXqrNMj3bBOKCjT9lA3ZiGmm6vxAwSzoSx9UOaVkZOxNMMUNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

There's been a few requests over time for supporting mmap(2) over
io_uring. The reasoning are twofold: 1) serving as base for batching
multiple mappings in a single operation 2) supporting mmap of fixed
files.

Since mmap can operate on either anonymous memory and file descriptors,
patch 1 adds support for optional fds in io_uring commands.  Patch 2
implements the mmap operation itself.

Note this patchset doesn't do any kind of smarter batching in MM.  While
we can potentially do some interesting optimizations already, like
holding the MM write lock instead of reacquiring it for each mapping, I
wanted to focus on the API discussion first.  This is left as future
work.

liburing support, including testcases, will be sent shortly to the list,
but can also be found at:

 https://github.com/krisman/liburing -b mmap

Thanks,

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
Cc: io-uring@vger.kernel.org

Gabriel Krisman Bertazi (2):
  io_uring: Support commands with optional file descriptors
  io_uring: introduce IORING_OP_MMAP

 include/uapi/linux/io_uring.h |  10 +++
 io_uring/Makefile             |   2 +-
 io_uring/io_uring.c           |  15 ++--
 io_uring/mmap.c               | 147 ++++++++++++++++++++++++++++++++++
 io_uring/mmap.h               |   4 +
 io_uring/opdef.c              |   9 +++
 io_uring/opdef.h              |   2 +
 7 files changed, 183 insertions(+), 6 deletions(-)
 create mode 100644 io_uring/mmap.c
 create mode 100644 io_uring/mmap.h

-- 
2.52.0


