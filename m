Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63153CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B073A8E004D; Fri, 24 Oct 2025 04:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB52E8E0042; Fri, 24 Oct 2025 04:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBA98E004D; Fri, 24 Oct 2025 04:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9B78E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:04:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23187BE3DF
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:04:56 +0000 (UTC)
X-FDA: 84032271792.27.E4A8A0E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6B2971A0007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:04:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EFyFm+F2;
	spf=none (imf19.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NA1EuLVhaXagkNkbEp2XlJIvkVm/6B2UHwg0o62JmEg=;
	b=eIq2YYCNGAsBtrU26RmW93bmQUgEC/xFlIUXoBjf2Ng+nitRqT0dd3tRfGwG+tcAzr0iJr
	9tJ9YXnOnUQLWmjwxspahSNK3VAlrlcVeCbrbCmV4n9eCAdygp/XgBuMSHR90FI0L+fYq2
	M8ytL0+18uoyUauxTI6xYh+3/q/upCw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EFyFm+F2;
	spf=none (imf19.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293094; a=rsa-sha256;
	cv=none;
	b=p8jVhQ2o9GFYpRpiWf/ZPX0VxBtv18n3Nl9bgrMJvoyztx0OQ5vfMBEx42iM4vsfhCGytY
	nqnjTA7xeGPKHtNaka1qZZGrlYCyMRe5FuEsWSIuNOLYardB+VFgMlQ6anizHGbdm4SOSO
	a3buCGP+qGK68vmIXuOaatJi+cuxZXM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NA1EuLVhaXagkNkbEp2XlJIvkVm/6B2UHwg0o62JmEg=; b=EFyFm+F20P3IJnCg0fyoCLJwx/
	iUjafVa3MnQpYacpmfc4FhY83ukGNrsi+RejEgHj/fS1IEVKt+ePz8CTV35hZRQCamiNAgvqGDamH
	G/bB0vfKuOOTJboHNrKU8b2hjoo58Z8uBGyWcaRUUcJPc6WmWp8CKv+P1pfXUE9fZi1StqiPTEl1q
	HIslYqKlVG2K5+5Q8OZdMGqwzwFPLr09kDx/GxHA5L8tPfeHjHs4BUFM+7cn6uFZmPAfxxCXlQRJS
	784JSAnaI4lZd+Lz3VWOA9xf4bhqJXX+qM2lSiyLuhgSCRV3wEGvfowG3PsaZ5zzdMVd0nrjtN4P0
	U8Bfua3w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCmu-00000008c2I-1Fku;
	Fri, 24 Oct 2025 08:04:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: filemap_* writeback interface cleanups v2
Date: Fri, 24 Oct 2025 10:04:11 +0200
Message-ID: <20251024080431.324236-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B2971A0007
X-Stat-Signature: rw164ks9hc6oy1yzaqbsre7t1u13p5fh
X-Rspam-User: 
X-HE-Tag: 1761293093-506048
X-HE-Meta: U2FsdGVkX18aGa8ov4DOZ6bKbr/kPfOBO9xddA6iVfK9sGwTZdBnrrDlVbieazbET1UY5vMNiOW+3PLb1TlbXX2IspR9yQuuZncCFlGR8fAqNA2Vr50n385ZO9FssJvbumxJCE5BUplz06qyVxKWgl9YEyE8aj1h5pS6QqU4Y4AWkk/M5jKeO15o486aLGxinK9a37x9H19WvJScqnnde3pIj6jAro8SeHlfD/IPbNk3LDfMnw6cViqFwCQEC/A2Up4aLj+wOPWuLaBaQG6tdbunRppN6vABUJTVt75aIkuQtuFPYsxM/VPOuVa3B1YxOG1+H5kJd2vqgm07Z2IkgxIG1jaTJ+0ervEUG/nWzVRdcV94y97+hfWgu260ShpO72VK8EgBW2U5Vegt+trgrw62VrKjwgbTQpLetjGN9VJ+zdXQlmyTMynI8YSIzSrC8mqo6Fwrb4WSUfqxzQwwXOZQVObQ57AzqSd3XTM1CpbPXRck9ReYMZPybB7oO4GTpCUxTORd7xJMDRrvY85AbwUiJZS7yRYssAzXBnxmu4Wr0TevPPHvOqdnCD2a2EUS9m+2wXr2ZzoaNLq40Fg6aC/9DBn8MkEGVG2D7Kuw5k+um3Thg1ZaJ4YV87g+YvtX1ehewO4G1u7mu3fev7nKp6WNOZBIuZBZ8C2dvvXwygiVVjTBr9vbvMkqrM8uz7/uk26v5mWGmjH0b69xEsik2x6gNpjsUl5RD7ixYy8W0Mz5SAtNY6X9mYDZBsyFVREx3EWx95o1FzAZLc2MZX+A7L/8LYNFGNH9nliB66fv52kqCB6nrRku7CTFnSKdM8CJLl+D6ArsK8/tigxAEvaKh9xsBU6oKL0YaIcMNbtFJpPAKEC5IPQ/a7VXTL9zUlfZZyqogtk3S2Un1a4yfJjaTRbWnr0BusXJrPXkCfI/4c7HJ/G91XJDyawbcgOR9GttlXaJKR3S3G7Beqru8nf
 GUGhy5hW
 AJNbmTzVPKQZtN+GYWbUZTJuqNk6MeIIH/U187kJSW+7udlXiPcmjcjWZmNP9XKwgPHYeg0DnFuEDr5J8+pDwsMIbnWgKWn5h3LvhopT3Cm5Hx8BBqHfzv+LIq27chZOuyNiDl58on4MdGz2fsMQADbxwA+s51NCwrP9P57I9QOSAK8l834JvKsOkYggJthxo9a/xPwjGvhiuZhFLbrgLQigkTG0GpW889bwnUUmjX0SB+4ZF+DT3BW8BYq2NMw9M3P+SWjgRr2Qiza+CxIfTp1+MA6fTCkShml34K3q+QFuvpfRnTW0dldtSLWJ3AFblUf9CWUhNtOfP6br15CyYW73iKNyGlVVBH6uwQF3xltoviZtO8w3EXUTiTSTgAZsHtwYRI5L4BC+Fg0em6jEwIV1KNLmjEUmPqMISvvzdfR/+0CQHzPn/Rt1eL8Om+rufzVjboia7KcjKLBLcTlmVS0Lff3Z29Ut45ZYoNoaxtRfrPJyy0idDiX7xFu3JQ+F8Rdsj4DBgId3xOK5hCX+Cpc3f6NhLzLEtOHPKZ2sZqEG+fkERAyoO4ut+8xQEgFrIJJWA/i1cmK9jzLimwM0qb70WFUDs8WoFz7AfBblqqca/M9UheIN3KNlD4fTh/GFK76zN8abfGOOFy0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

while looking at the filemap writeback code, I think adding
filemap_fdatawrite_wbc ended up being a mistake, as all but the original
btrfs caller should be using better high level interfaces instead.  This
series removes all these, switches btrfs to a more specific interfaces
and also cleans up another too low-level interface.  With this the
writeback_control that is passed to the writeback code is only
initialized in three places, although there are a lot more places in
file system code that never reach the common writeback code.

Changes since v1:
 - use LLONG_MAX instead of LONG_MAX in one place
 - two commit message typo fixes
 - keep the filemap_flush* naming

Diffstat:
 fs/9p/vfs_file.c        |   17 +------
 fs/btrfs/inode.c        |   46 ++++++--------------
 fs/fs-writeback.c       |    6 +-
 fs/ocfs2/journal.c      |   11 ----
 fs/sync.c               |   10 +---
 include/linux/fs.h      |    6 +-
 include/linux/pagemap.h |    5 --
 mm/fadvise.c            |    3 -
 mm/filemap.c            |  109 +++++++++++++++++++-----------------------------
 9 files changed, 76 insertions(+), 137 deletions(-)

