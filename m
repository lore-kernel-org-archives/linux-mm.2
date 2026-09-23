Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69B4C98314
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0FD6B0088; Wed, 23 Sep 2026 18:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91DC6B008A; Wed, 23 Sep 2026 18:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8AA6B008C; Wed, 23 Sep 2026 18:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76ECF6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:44:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EABDDA0175
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:22 +0000 (UTC)
X-FDA: 85246507164.18.1127ECD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 604DD40002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNekichH;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790203461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UPMsCT2qvWI8EN+jpV7cX6nzZkhYVxQZfqb9tn+GBjo=;
	b=b6pe+NfeoLx/5zUR3Kru2NBWGx02cY67jaoT3V+Fp/IGCsQi+fzncbdEIwaxfkJOBniqoe
	4MsuIIUb/Y0KEnQukAq1gMXbmVoaRLw4uo3rAoOAQGpCz8vr9rcQObFCped0jTROOqZNhx
	+XR3CxFb7hZwQ1cRKtXcayDdifWTbmQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790203461;
	b=3wFblFxpdEIC+8n8Gr8WEQzRSv4769YwBitIhRSEkb8PQCoWFjMf46qyeUuQNNi/bz3WG6
	6ORe28aOIhDKja95KQF3Ne/TvZgJC22nZXXMIR3ri9y5U708qTYJf4Zn5pyM82F2fG78Lc
	bgDnuX9rMPtsGs1Zh81QRDx6d1O4RpY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNekichH;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C371C41784;
	Wed, 23 Sep 2026 22:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5391F000FF;
	Wed, 23 Sep 2026 22:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790203459;
	bh=UPMsCT2qvWI8EN+jpV7cX6nzZkhYVxQZfqb9tn+GBjo=;
	h=From:To:Cc:Subject:Date;
	b=hNekichHgeFu9YAHhsC57ga8KbZeqqYNoPt9qyeJkcA62yO3zslm5ClhEnnIVKNa2
	 lHX2WsoedAGQHIkLZ3XtC1PusAva9ljvI5XsjK28jhmt2xLfY4QeX2JokCV99DkqAd
	 cCdPJs9y/eFE0DFmdSiwOHVB7TdDofuG4c4htxyj8fZNK1JzxU62wzdVhJfp+wxciK
	 I9V7sq80Jl+7oEhUZyKPyhOag00hsGuRo/Q27LFbczH2Vu6jWpHeYsJuQ8xE1Jwusp
	 sNpPewsakzebZBaMFoaMuhk4XGUzBZP5ZLO4flQ9qK1kRtSe2dDsuMSfqHopso6zls
	 Xg4N/8sM0wE8Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/6] luo: tmpfs preservation
Date: Thu, 24 Sep 2026 00:43:59 +0200
Message-ID: <20260923224408.3745689-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 604DD40002
X-Stat-Signature: a5pdsjgdxsbiahtzp59bbhiadknectf5
X-Rspam-User: 
X-HE-Tag: 1790203461-893648
X-HE-Meta: U2FsdGVkX1+DRLEMu0awvN6dpJgcy/n+LgLNCI7v9VMDwXeQYWuZdqdId1isn6EJEDuLAc+a3Tdw4blI3jswVhwQb5u36XZ7gOM2rve0fLCiPefL02coK61OAroK2f3eC3fIktbBwfUQ4ws57uPTIPX/h7t2gyesg6ihBJTKv9HISFjlYh8a9/Nfxy8qaRAx/xpfTyjMCnJVIZk6FYjVCavLGBC3wgrsUMPXKwhiwGmVSXKv4eFCUrvcynPsOZG+O+SwhObZ2SjfQ3xBPTODDPhhAj3hyoc4UqHH6CYcTYXAKA3QYxKbU3W/MV8uenoHJNQ2Q9CgorSJQb4UgCqwpLY85hI35rpLzsWDOthx81vXbkyzuFCSwd5RxrQWX5ewZxCztkr5WzmgvIESrJLDLu+jex+ILoOEQOA9aCDeLgzsnkWEJE+lmI6UcncdohC8aFMJutcMVLIQJctk49GhYr5zz6I6qW1IOf/2m1M8s7o58+FoOH87aB2jvBcEeAJv8X1AwipCLr3upbSwYl1bqNPX3f2Qiu0v8xlWaST5DlvLyxgbDzbHau3lZR/8p5uwoHnDs05DcBlrMnMItFEsgM/SmuQtkwc6OmjzN7DHeQ9EtPr3iaSlLxQ5OTBWal3lvOmYMBAF2oo7ocgM2LmWTE1RDxCa7syH25OxANlh7a4qTR371PeBkUZs6juNDbnOdqV+1Dx/+KT/MN9IAlwHm8v26HVpb/5jDrxTYp6C77GN1CUbhInbpmN2eEaqsOzn4roaWIabwTkfFqPGh+eZEOOkfsEqjU11GJwPcvzdS7akzR7biXtN2souMg/nqGrCDo92bWTZ6wDNJn7kDQdzrUanHzKtJofQCMdUsvLtVUuBkjUZt7rjY8Di7QuhVV13iJ7wFJUYzar9PPPWCwvBeMxxwvvfVQpXsBrrAj9z3v5S+JBzq/Ciwqhp2j+dl3KLYUzM7qTFuAOj372KKr7
 3LHNZaDM
 AdjUXMwPKEFo7X1xoFrz5xsTTEyQpEcTp8EKYralxSiZzp8v7rqCvkGWuC3S/r13yP4rmZ9FMydKs9+4fUn3bFNFZNRDI4PpVVXca1ygdCMSBTLWW8LICfJjpEqYCW1zy0sN/iT4m0Fd2MDGdu7mgy+HPOAYtlOApooTImRIyO8YzoM8s62BG6iUpfa3hhRrYJpiFY4ebYzLckMfu7IPvdc6ld08rSijkH6J5cePqxtLCIekXklcmdZwfYf09f7LN12iw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

I brought this idea up in this week's Hypervisor Live Update bi-weekly.
I decided to try using an LLM to see if it can produce a
proof-of-concept quickly. This series is the end result.

The main use case is preserving in-memory files that have a filesystem
path. We already support memfd preservation, but memfds can't be linked
to a (user-visible) filesystem. This is needed for storing VMM packages
for live update on hosts that don't have a disk. A cold boot fetches the
binaries from network, but that is too slow for a live update.

David tried to solve the problem by introducing
LIVEUPDATE_SESSION_RETRIEVE_INTO_FD [0], which lets you provide a FD for
LUO to retrieve into. This is an alternative to the idea. It uses the
standard preservation and retrieval API that LUO already provides.

The core idea is to allow userspace to preserve a tmpfs mount FD. Once
the mount is preserved, userspace can pass in regular files in that
mount for preservation. The files take a dependency on the mount token,
and that is used for retrieving the files in the right mount. This saves
us from doing a full FS preservation and makes preservation of each file
explicit.

Currently only files in the root are supported. Files in subdirectories
will be rejected. This is mainly for simplicity. Complex mount features
like memory policies, id mappings, or casefolding are also not
supported. All these can be reconfigured after retrieve if really
needed.

The code re-uses a lot of the preservation and retrieval logic from
memfd preservation. It only adds some extra file and mount metadata on
top.

As I mentioned earlier, this is heavily LLM generated. The code is not
very polished and has some rough edges. That said, I have read all the
code and did significant cleanups of the LLM output. This includes
turning the 1600 or so lines it generated to a more modest 977 lines.
So (I think) it isn't complete AI garbage. And I think it does get the
core idea across.

The big exception to this is the changes to and use of VFS APIs. I am
not competent with VFS at all so I have mostly taken the LLM at its word
and haven't done my homework to see if the usage even makes sense.
That's why I have not Cced any of the VFS maintainers. I'd rather spare
them the pain.

[0] https://lore.kernel.org/kexec/20260901180713.4185641-1-dmatlack@google.com/T/#u

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (6):
  liveupdate: luo_file: look up outgoing tokens by id
  shmem: add tmpfs_create_mount() to create tmpfs mounts internally
  fs/namespace: Add vfs_open_detached_mount()
  mm/memfd_luo: allow preserving a tmpfs mount
  mm/memfd_luo: allow preserving a tmpfs file
  selftests/liveupdate: add tmpfs kexec test

 Documentation/core-api/liveupdate.rst         |   1 +
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/tmpfs_preservation.rst       |  24 +
 MAINTAINERS                                   |   1 +
 fs/namespace.c                                |  59 ++
 include/linux/kho/abi/tmpfs.h                 |  83 +++
 include/linux/liveupdate.h                    |   6 +-
 include/linux/mount.h                         |   1 +
 include/linux/shmem_fs.h                      |   5 +
 kernel/liveupdate/luo_file.c                  |  21 +-
 mm/internal.h                                 |   1 +
 mm/memfd_luo.c                                | 558 +++++++++++++++++-
 mm/shmem.c                                    |  43 +-
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_kexec_tmpfs.c    | 191 ++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 16 files changed, 977 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/mm/tmpfs_preservation.rst
 create mode 100644 include/linux/kho/abi/tmpfs.h
 create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_tmpfs.c


base-commit: db3db4c33a1cf89a201ad1a11c63f503b248ee32
-- 
2.56.0.rc1.310.g51773c2048-goog


