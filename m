Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB1B0FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16BC36B0096; Wed, 29 Apr 2026 11:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5D76B0098; Wed, 29 Apr 2026 11:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26356B0099; Wed, 29 Apr 2026 11:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3C666B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:03:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82AD7C1615
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:03:22 +0000 (UTC)
X-FDA: 84711911844.08.2F54217
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CFA11C0003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:03:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ape4TI7d;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777475000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2CRlWYwcvL5VBSWIoIpbuCKnztY5Svkt/fnPPA5QrUo=;
	b=J/0o8mnX93J0572sBFFEZXY23Nw+ypW0ghxgXNiXlpQ3y5Vk2ZZ2YsR1CLt5eIrEfZdjTp
	R5QuJ/LN7O31I8HeJM2aK08j3qHhb9x/3FnJrSOJpEdbr7eYZLO0Yjn/x+MEX/vuEGd2tX
	GNN0Rp35sF65nbSUewOoA34svd57YeI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ape4TI7d;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777475000; a=rsa-sha256;
	cv=none;
	b=wo13MCIDOjiiI6ZRRS5KdIk3ZrxpEGonKAY6vlP5zP3v7AqF5/uq6ghwcArfXj1niTi4kX
	Dr53w76NVnzmeV1kAB7SB/xsHQrU3bMgi1cnf7KbBB7Lwv5uO4n6YJZaAjn0JiJQWjcxDY
	5UtmzZ4xnfG5cRsgRRFDb+jMLFysVDY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AEA16024D;
	Wed, 29 Apr 2026 15:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF6EC19425;
	Wed, 29 Apr 2026 15:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777475000;
	bh=wHY7NZ09E2YAzVEs87LZ3Rdze2bK9PtC20hVAyMT/fE=;
	h=From:To:Cc:Subject:Date:From;
	b=ape4TI7dvLir+K3xFlQYl/KgbBgUzEQL3hP3X85XEpm/V92AN4y1fkJv1382y7kSu
	 DjlQcQkQBUzL+98SjF2DJ7pHZmg1CoCjBDsNDOyfPUsXFUaHb0DJDkHOrFrz3IEwta
	 NunRwOnns40QklKQ1QHzdKS8dQYWrM0b5RdVV+8J/UosmJUmYn1VC+RjadM5iU4pxU
	 ZzHv9KSXgvQykSV9QCNxSoqVQHERRepdFEUvF5aY+vzf1kSQoB9qVaZmsGZML1JMQE
	 d14iKo4UE2hyfU8chAD93vVrWETQQrV25fPVGjF9D5dmwUK9rVNPEnrMVs/5lvxC7O
	 BCV7SZzDUFZwQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/sysfs: document filters/ directory as deprecated
Date: Wed, 29 Apr 2026 08:03:04 -0700
Message-ID: <20260429150309.82282-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CFA11C0003
X-Rspamd-Server: rspam06
X-Stat-Signature: furkc5tceqbmpd4g1jdea3kkf43mzsfn
X-HE-Tag: 1777475000-920117
X-HE-Meta: U2FsdGVkX19NYL78muRfCgjXei4Rr4t1YLCIDJYI5dWiIN2aD3LtZHNJ/uwJhlmQ6q3jHUny+uXE0Ei5cajuMR+cKYmwkLxOrivOuZLdu89b/AF82m28NxfSzPILq4bNfrmAL7tlPCo5r+GKQFYPrKcm7+2mS0tpLJnfM4XwH4gi7u89SvgbrtO0K1/Rvx2wpzJLkKkE+oEkIO7TRY317+pTWGKDojkCbNo1XeYbOZNCx1giST5ejHw4O5mVgMxlU3ibXyirOR1MjW6FY79hukDm73beDg5/4iD2mv/IRAq20rKPLCmiuVCilvrHq2q2iAJq3XTjd+/nJ1u94Kp5gi4/bGD3j4Oym2d0SSZEkQM51BeRI9CcXgXSXA/BDS7C1uCRAs7C6Pu36e1JpSAhkQLnmBnr+WUmvOq//YKJ8L5BFBtP9xtiHCUFNhFbV89syamkscrxTn0Y4zFH4I2u2axt4feXe+klxA4U7SArmW72q+13usNVPuBb3qZpO/XgdMGDDiQEjJibN8B8xwCsax8PqrU6KOa4eaouicEse+BMlm8sS934uiVGqd08PLRBk845d5zn+Dk5L4um01xXaCbDGFUi7/wU9WSVSdPYMlDFVZEdLn6d0/GT1Y+cHAngiMDQfSFhLk4nGC8XPiITPkHi50yr4lQHmvxp6V26hx6ZJqSdFr4bhhiU928ESlUINFPXVhhHFefAs/8hEgXJHySbT8dibIvwlBXrNshFjLWVLj/AoYMHUooca2yZn40u8k+A+LJzNQGq1L7jyCfeWsxmALbl3TEHpKoCBcdfdJ+nRRD5GH8p80/nVXf14BhOhJdS/3okAU3OEw5iiWjjf5k0+ebXdATFnEuAQHynbtlAVOyWjyO31LxLTLhfNJVrPP52WQILFrlqLS23h8XH9PD9dICu6euLy+CqGWzNDYSULFljnllKlTX9beErPyzwMmhcEUIL98n+FTKABhx
 WAuDJ1B2
 VdclYUomzD5C8EZAl5IwIIiHtHRAHK7S+wIuPUJc6OXfQCZ4m0D4bJbb29N5yBD9LkzFCT02FDvSjrzS+ReA88FI9ZxQPZXXfW5cX+XgkhdvkZ6UKDsAMcoDdE0SRn4zzSTGe8DnzEGtrGWgAOB0oP+wz6y/QXW6MQvrJrZJdPeOec6iZPsEKe3hyfPsHFTnrakIWfV58G5XWvPjO4CAggrd51Ppym7CyPFNG/Z7c2iZjzqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ab71d2d30121 ("mm/damon/sysfs-schemes: let
damon_sysfs_scheme_set_filters() be used for different named
directories") introduced alternatives of 'filters' directory, namely
core_filters/ and 'ops_filters/ directories.  Now the alternatives are
well stabilized and ready for all users.  All filters/ directory use
cases are expected to be able to be migrated to the alternatives.  An
LTS kernel having the alternatives, namely 6.18.y, is also released.
Existence of filters/ directory is only confusing.

It would be better not immediately removing the directory, though.
There could be users that need time before migrating to the
alternatives. There might be unexpected use cases that the alternatives
cannot support.  Doing the deprecation step by step across multiple
years like DAMON debugfs deprecation would be safer.  Start the
deprecation changes by announcing the deprecation on the documents.

Every year, one more action for completely removing the directory will
be followed, like DAMON debugfs deprecation did.  Following yearly
actions are currently expected.  In 2027, deprecation warning kernel
messages will be printed once, for use of filters/ directory.  In 2028,
filters/ directory will be renamed to filters_DEPRECATED/.  In 2029,
filters_DEPRECATED/ directory will be removed.

Changes from RFC
- rfc: https://lore.kernel.org/20260421044928.141388-1-sj@kernel.org
- Wordsmith deprecation notice.
- Rebase to latest mm-new.

SeongJae Park (2):
  Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as
    deprecated
  Docs/ABI/damon: mark schemes/<S>/filters/ deprecated

 .../ABI/testing/sysfs-kernel-mm-damon         | 62 ++++++++++---------
 Documentation/admin-guide/mm/damon/usage.rst  |  8 +--
 2 files changed, 38 insertions(+), 32 deletions(-)


base-commit: 97bd4e9ac10095f9b55f4a38d5d0757bc2a287fa
-- 
2.47.3

