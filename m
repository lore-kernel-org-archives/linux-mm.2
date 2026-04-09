Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E02C9F31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7AC6B0005; Thu,  9 Apr 2026 12:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF3E6B0089; Thu,  9 Apr 2026 12:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40CD76B008A; Thu,  9 Apr 2026 12:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 337066B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:03:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF8AA1408C7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:04 +0000 (UTC)
X-FDA: 84639486288.03.1CE4F0F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3CD2A80015
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=h1GNWoD0;
	spf=none (imf30.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SxYUlZLj1gmpCo8eCeKIGiFpev17tNAzKybkLp/40nI=;
	b=BV8gbr3y4eSQn+wnM0G14wiJVW/KwDU972QftoEHeyEiXmzG+ehkEKSCvRzjrGKv5mIqPw
	FmjTmNYmXZdzpyew5JnesjQXC42TEGugkJ22Q5D96U+qcjLaBo14bgXE/2rDI4Z7LOAjbg
	lyknURNyxHEp8BjctrvriOeoTRIUcCU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750583; a=rsa-sha256;
	cv=none;
	b=gS+BrQBOjl3sQqnG75xFHCBfER5GhPZtDF6tfO1duUGEK2u44WJXfUq78wmnEwgG49gQd8
	O5u+WCwqaxVQhK4/5NMHtlT4nJZgWqB3eJUveZE+YL9Uf0O72OP/k9+jpBjO1wYQgYukda
	xxr7N1YOxMTM+Xa3YtnkxT9VVPvm1XU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=h1GNWoD0;
	spf=none (imf30.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SxYUlZLj1gmpCo8eCeKIGiFpev17tNAzKybkLp/40nI=; b=h1GNWoD01ZSYa/9RK53eKMGQb1
	pR3bWB8r+lqXQGNAfbDaoppHO9yJzu6TVAz1FBtkAuv2UJXybU3NPyHtXfnnldQdTCk2Lem1xXdCD
	NtgsXzOkwgjvGy5+pgs/+7NVU8mSGDWkfKsloQY00RzyNk6q/fLDR6L0frIclJE016YKFf4jtwmwC
	pKn0xWdrvZi/5zG4ZL2hRPaoq/MwDZ2no6r+pRr8vGp9n60IRZXUUkN2LSI90ezMaS5sAJteTs2XV
	PGB991wT4VMT4up40SyJD74ssZchAv0VmSSmrK5nt+iqGBXIv/I/aoVN+APRoQgFDKIvoFVagV4LZ
	6nh+Keqw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqF-0000000At1t-0EJp;
	Thu, 09 Apr 2026 16:02:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: bio completion in task enhancements / experiments
Date: Thu,  9 Apr 2026 18:02:13 +0200
Message-ID: <20260409160243.1008358-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: 4ienmqb1431ieed5o5fs1h6f3f78jqft
X-Rspamd-Queue-Id: 3CD2A80015
X-Rspam-User: 
X-HE-Tag: 1775750582-917312
X-HE-Meta: U2FsdGVkX18shik+0WenDEpGs4pJejjaJisHuKNhTTy+VNqwFY+58DyN4Cpoh8uriq1braYpGYY93plSBbM3gWIX0/gaU/r7iZsVjQBE+OIksPVmEkIawRXKSRIhmVvdBv+2NTX653vcB+u0iLgDBSYBiMDHrBl3t9l2Nv4CibG8soALMrQRmCc3wX9NkTJ0k4hUHwbLdjjQ57oYEIGOYjYrFZqnWzuLEarQWbbb4TztUDIsL9J/xWL2x5ryC6Segqf8pFWa5MSSHzXOid5nXv7ih79XEK7JhGaaFz97PHvK41WrIZbdsyTgWx0GlUBXXEDBczQQgKZIg3EcDKXyRBw8UWEKlgVA4mi0NBk+CWFVsfTHTYN4QwF0osu7JIm8cU6BAsH9dy/rTffRAEVvhCkgGCe1q6bi3eUI48Vd7QJuPd9e8Pv/JopKo6DMGmPQ3luqt85UYdZlVqd0g0/OHH3pI+LE1+qSV0rs0+QG4moqdeMtDEczuNYnBAxAqk9ba24hH7BR2Zgo20D2hTmaTRRTmENSVpNlAwSfzcLWvnZ3SzkHHzycSHnQ59joqrRDHljAEHxbrPtCaKBHXPuh8nJKQ0lEzg++xcgN8y9z9oiKSbFZR+g9ELM1u5vYAl7ZoN2hmYY6P6I94P+O3GqhgGUSpgUr6t0TLgi5o519nKUzE8+iVOl8jT6/c2IInSAPUyumDNI7moW2gfnd6SaFeF+ysS65h7zU2X9x4plbW3lyTNYMsq+K4XecPdfkmeq0uMGup75AYRn/IEL+Z7DupeHw7zTEIaRjGhyzx7KXwPoccOBeYxxZVGWsvwdYZMJe9wbOHaH6sdlW8oOawSVS8R76/s8tCEHaSBRANLEKsiEMQrKFhAc7V7O3FPhL9W8NSNU1KhrZggiF15SICb48hb3aShRkaVraGPgLG/S+bY+3XDvk+O3LOpsiTJbTZEk8eE1EeB3pEB32Hy6Xxlu
 KnHy9JIQ
 ufO6Qt1HOi1hplIbXk1gctlQKX5bJjI4hlBofsz1xRG85fvlU5Owa5laMjhEysVRm4g8prlEKsNXZQl1m3j+Qnqy7hcU8n29MxrwotKErE4MaTxpeFrNZUcosxTPZRlO2VO6ZDUURuZzwpg2o8s0KEGGYlD1SGykttr+psp7DEGxMNCI2AlL6RgXYqF3sSOhbyIY25LBOOVkhjsKEu/KSQvv1DWaevHeNgMni9MDvIHHoR5wD7aWwFWhJNINkDHMA0BWRm1lMXnu77ZVLv6JmJ0alYgiDTPrHxJJDz67gGFIr6khupM13fpYe0OItj2wvDKzZBmFbDFJORIgjMAraDNmnW0OeSLW9uvF0EosQh1KOJZWWZMjv4/EpZ5u+SHWMmo76BudJHqLJC7HLOlk48pWMXa5pei6ezutV+6WbmkDE3bqA0b5QasXxfKSAloqFZHIIuttbDKObS/Mrv0OC2rs9uZ8TlixXyGrCOl55S0h1s/uJyEFDAlwLNJIwVSmLwWU3pYEKNWMXJQppndqSpYwainDr9yuWV/O2KCpLqd0kDEaUnLJPTSiJ7Ps2DJ9kAzaYyVIaMUtAjIunCN382g6ts+QysvevJJlEyb/p4ce/+cU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series builds on top of:

Subject: [PATCH RFC v5 0/3] block: enable RWF_DONTCACHE for block devices

which I fixed up to apply to linux-next.  If you want to seriously review
or test this, you're best off using the git branch here:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/bio-task-completion

it first makes the complete in task interface more flexible so that it
can also be used from inside the ->bi_end_io handlers, which we'll need
for a few uses cases.  The second patch fixes the offload condition, the
next two then convert to uses in iomap added in the current merge window 
over to the interface.

The last patch plays with the implementation and reuses concepts from 
erofs to reduce the completion latency at the expense of more always
alive threads.

There's a few other places that could benefit from this, like erofs
decompression, PI verification in the block and file systems paths, or
fscrypt decryption.

Diffstat:
 block/bio.c                 |   93 ++++++++++++++++++++++++++++++++++++++++++++
 block/fops.c                |    5 +-
 fs/buffer.c                 |   25 ++++++++++-
 fs/iomap/bio.c              |   44 --------------------
 fs/iomap/ioend.c            |   53 +++----------------------
 fs/xfs/xfs_aops.c           |    4 -
 include/linux/bio.h         |   28 +++++++++++++
 include/linux/blk_types.h   |    6 ++
 include/linux/buffer_head.h |    5 ++
 9 files changed, 165 insertions(+), 98 deletions(-)

