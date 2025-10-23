Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD6DCCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7F88E0014; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F8E8E0012; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC648E0014; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 272D18E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBB0B5C0AD
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:42 +0000 (UTC)
X-FDA: 84027636924.18.735A4AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E91F1C0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p5VsN2Tb;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0SO7KgzgL/BYsuGtwTPwUid1ZNGVqo7C9LFXVfx7RvM=;
	b=XUBQCuy1ycv2YxNvDdD5Z7IiHXZQdf6Q0bG+ImsbwLiSBdDuP2PFGRp2smyhTajUo9/MuQ
	hh3k+pwiE6OO/7ID1oav/+S23CfvUqBfdAN6GGnWq1mOxRPmKNX+QT6+CkvIZiuJL6bGow
	ZJYRVjn6Iy4J/0hvgJEVxzK1K/PfkM8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p5VsN2Tb;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182741; a=rsa-sha256;
	cv=none;
	b=Bm79gvWv7GvgR9jjIYddYDNja2PjbDM3q82sqtbAaF87FZZLVwVSaz+Vbo2bXx4aMDjbQc
	js+bKJTvYjUiSCVNyg2Tl7ZgIN4zq9UXRUlh3kr2Lx/3WoK+RgtkNtwqME3BwvhVmZWK1L
	M6NBz/WpKj149A0mtC9lrnJlLyNdEJo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A56942D55;
	Thu, 23 Oct 2025 01:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D3AC4CEE7;
	Thu, 23 Oct 2025 01:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182740;
	bh=5dAZqb/8nKzWGonIOSbPc0VMsx+iKGKnuvKbkmMuljY=;
	h=From:To:Cc:Subject:Date:From;
	b=p5VsN2TbC2z+vM835LYYIWswWOiEQ6xdRmtG1t7XCvXQBthUHQD9ldMl2vCRCmGR+
	 FtOBnSJ1Uasrb35cEOosHVnRg1HeG22t8Q7NquQzTBlqF3eoLDcQ7P+hOlXAgoosfP
	 vbc6jEIZ9llkw5ia3cgAfZa2vMWWmy11FXlagHmY7EwXKYkKAm8UAyZZw+ZgIiVRmy
	 uiAqXUIecH4ayO+G397CA7tMAUsbWgGf1E8wuK4OwAUOBJG5I5412ud2ShTiiqhOTG
	 J3wCFqYtDdsHsjIKmKfbo+2jiBMSTuHroHZGzJvwXzPF4La1o37djH9LFvovvuDM+2
	 pDOY7sCbE04TA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Bijan Tabatabai <bijan311@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/9] mm/damon: support pin-point targets removal
Date: Wed, 22 Oct 2025 18:25:24 -0700
Message-ID: <20251023012535.69625-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E91F1C0005
X-Stat-Signature: 7z3sdo4tfc73ij7ui5no35mjm66qzh6x
X-Rspam-User: 
X-HE-Tag: 1761182740-293643
X-HE-Meta: U2FsdGVkX18evAr1G37FYdHZqwC0bZWOD6tkvnMZUYqXulXBl/AixLG7RwIQNOa80uhoL1ksRp7XMx+xdtwFLtcH+BfeGj0CrNoQfDp4/jUEPsjKfC/9ldcUEY+Tycr2r3tgGK+QyTlDMOLNn+T1sJ8P242UzBcLA6JTpdKtc+oOdsG12gQb0bhjCqsmwTxZQnBXqGHhn+IYWLN2g5bBcCxdDFd9IlKrcF/ncU5LuPOhqKD4ak4QTKy6ctaTS0skI6CcmOrPNXEz/wjQwLhYkWivgIPxnwoyF/JGR4uOUm3SAJ/ROJYwDr+2EitWo/bYD0QjdfdM91foKo2j+c6DckuBgPT29sEdbS78aeR/e7w4VS4OlXIH1qHgGwdqJU/Btf4/cKp2bzwO6PTeGmqPES1UbL69tQyhSYBlMCnTSxGTy7mhgVs99GbYpW5y+IyR5qZOPQzs0nU4g+O5wVpXQ8qwOZKQWcBR9pwIzdFJbG/a1//Gbpoi3Tc7lwZ9LCEdla3a/wwYpDG4bMHlhYP2bmfSV1TR7c0Vhf/WiRitTb8gTkeshkESyiozBMALrDASVRd3EBIQCYdPaBjc/2SXFYVW1bbibZ441edNSMhkn0DUHe3T8fdFz1DKctdBbpNaVQtEor9/h22Z/s6+v//bDX90b3cD5a0ZVkkJf9ma0+VjTVWnpvXEUDfO3Prldplx0VoaZ9bBoz3hhbb0QLHD4j/B1jUYp7FuNbBfvwxqwt2DpQqttv7zBq/L+C9VaRjUlm6ZFSCUgvEmK050Uy3zg8caZBdPHXM1lhnRjDuU1we2g0oWoSkEZU3T3ovgJ0X0c4JqmLQqIuPO+3yuCz+jdVFbxB2uxJnruTKAKjTT5U6ZoQpv7B9HeK3hjAEKVLp2kvDpGux8xS4EmjtLvN9d4/dysijLMl0WMw89537PCjSGEA7hB66cu7VlFWpBcd4o5inPJcjXXOOD/7icsb6
 3y9ZD2X/
 /hNVXKmaRcHY19p9F9vbqBOXwP+4fDGL7o8BFObbPQpXlDbpq1OoCnx58qDcpt/RSRJKTAZ9xvaPN20O9nU1HAwg328IFzcpyYhDG14y9tkX3e1DhlMG75bSi67aMMq41PSIW+/qrwUz/E83cndqh0ZrIqTDrqe8zs1FSHDlZDU7N+4iLUxZv6E0YsfT7OWELySNfCG3Bp4+29NM7E0tWZMCyXf2Jn8ANbWpHYZXqt/eY4atqXND4mOJk+I0CZ8o4JpvZaMnGdZsJ93PFf/IYGiEMTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON maintains the targets in a list, and allows committing only an
entire list of targets having the new parameters.  Targets having same
index on the lists are treated as matching source and destination
targets.  If an existing target cannot find a matching one in the
sources list, the target is removed.  This means that there is no way to
remove only a specific monitoring target in the middle of the current
targets list.

Such pin-point target removal is really needed in some use cases,
though.  Monitoring access patterns on virtual address spaces of
processes that spawned from the same ancestor is one example.  If a
process of the group is terminated, the user may want to remove the
matching DAMON target as soon as possible, to save in-kernel memory
usage for the unnecessary target data.  The user may also want to do
that without turning DAMON off or removing unnecessary targets, to keep
the current monitoring results for other active processes.

Extend DAMON kernel API and sysfs ABI to support the pin-point removal
in the following way.  For API, add a new damon_target field, namely
'obsolete'.  If the field on parameters commit source target is set, it
means the matching destination target is obsolete.  Then the parameters
commit logic removes the destination target from the existing targets
list.  For sysfs ABI, add a new file under the target directory, namely
'obsolete_target'.  It is connected with the 'obsolete' field of the
commit source targets, so internally using the new API.

Also add a selftest for the new feature.  The related helper scripts for
manipulating the sysfs interface and dumping in-kernel DAMON status are
also extended for this.  Note that the selftest part was initially
posted as an individual RFC series [1], but now merged into this one.

Bijan Tabatabai (bijan311@gmail.com) has originally reported this issue,
and participated in this solution design on a GitHub issue [1] for DAMON
user-space tool.

Changes from RFC
(https://lore.kernel.org/20251016214736.84286-1-sj@kernel.org)
- Wordsmith commit messages
- Add Reviewed-by: tags from Bijan
- Add a kselftest for the functionality of the new feature
  (https://lore.kernel.org/20251018204448.8906-1-sj@kernel.org)

[1] https://github.com/damonitor/damo/issues/36

SeongJae Park (9):
  mm/damon/core: add damon_target->obsolete for pin-point removal
  mm/damon/sysfs: test commit input against realistic destination
  mm/damon/sysfs: implement obsolete_target file
  Docs/admin-guide/mm/damon/usage: document obsolete_target file
  Docs/ABI/damon: document obsolete_target sysfs file
  selftests/damon/_damon_sysfs: support obsolete_target file
  drgn_dump_damon_status: dump damon_target->obsolete
  sysfs.py: extend assert_ctx_committed() for monitoring targets
  selftests/damon/sysfs: add obsolete_target test

 .../ABI/testing/sysfs-kernel-mm-damon         |  7 +++
 Documentation/admin-guide/mm/damon/usage.rst  | 13 +++--
 include/linux/damon.h                         |  6 +++
 mm/damon/core.c                               | 10 +++-
 mm/damon/sysfs.c                              | 51 ++++++++++++++++++-
 tools/testing/selftests/damon/_damon_sysfs.py | 11 +++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        | 48 +++++++++++++++++
 8 files changed, 140 insertions(+), 7 deletions(-)


base-commit: a3e008fdd7964bc3e6d876491c202d476406ed59
-- 
2.47.3

