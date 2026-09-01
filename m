Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C570FC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC2F6B0096; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4786B009B; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBA16B0098; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91DCA6B0096
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1834B40504
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:28 +0000 (UTC)
X-FDA: 85165975776.27.3CAB894
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6BB26A0011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m9SUp6KN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3WxSXaggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3WxSXaggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lAVN67JT5h8WIfFlQUOkXfv2BuxQF89IX1lkYdIpCWw=;
	b=6vlHbBXHOIBTTrBIsrCKboLXMDJMqv7sgO/b80LiqCi+1eshY3haa+QO1iqP1RMbfj1vqv
	AAEGsaoCDiZ3jMc/i2LMkryKViDa64h5b7Hh0UmopotjrkmuMWSRpDo5m19hSxM30dX7DR
	CmokZxXGVwUGQHsYhdncSwI26gI7XYE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m9SUp6KN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3WxSXaggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3WxSXaggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286046;
	b=NAx8flGfV2CUbUdgpsGYmtiOvaQmnV+e59myAAerqv6BgY6SjeWtU1QOBsbuf1ym799baK
	g+oEtmOZgEyJ6gFnU3XWA7akTp+ujulXB6xL5aSpWSa1xJHuFwAAIovEWcSCzk+35gj/Yi
	mvyMhBGYUmNF/ptRiF6GZCoG8OBpAh4=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-398e1f7d1a5so207685a91.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286045; x=1788890845; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lAVN67JT5h8WIfFlQUOkXfv2BuxQF89IX1lkYdIpCWw=;
        b=m9SUp6KNNywK20bxyszFiGd9WwdjI7eLiiBtE8+biPUWMmKVgz4cRPJeVYr/DrRVhy
         VmECeJWpjBVPF2nfB0cePNfB5Vw8SS2DYHeaSYgvdrxuMwGqrE5+KFLs9WeIzDIPgcUN
         7luaY25MI3k88ukdUkt9gKIIyn+izvhWGHky1euRZbr0h8gzD1H3WeEYdYvCibncWvov
         +0zvawhcriJWyqL/A8948bx194ZDqAuTP0hvRyLcnS3TZTL6E5yKH/ElcTlwOTHkZGzF
         xnjuUTrRkyT1x54rPijH7GHFP348sbdpXEhUsOF6cUQvHh6Z+81HSZ5I25BvTGCrm6Ug
         WiTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286045; x=1788890845;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lAVN67JT5h8WIfFlQUOkXfv2BuxQF89IX1lkYdIpCWw=;
        b=NvuhcwrMt7QI+aC7EuMS/1TxvxrmevOtKBheu5+WUq40WjGL0NqA2ltZfax3mqBo85
         V3w+71Ps8P6jOw7pI2klR2iffAgpVIKNJQ/9tCzCyi2AUGoFP9eupRQvczn43IQlBRSZ
         NzbEmguDLYdPM4lef1BM3p71xhdYqrOZjfRy7O3xi4y1pz8GpAxxn/DTB8EzguN48iUP
         8U9LRiQOCP1m1Om1RM4hzz8aCG0Lw1Dk1kuwbzY0sooMIBYPbY2mFlkTIQDUrjokheb3
         TWhD8eQUN8fMEj9sGLERWfknn6yh5DIx91AaDLVVbbQP3XS+AGc3ghmMApVKNXggQhUe
         H8zg==
X-Forwarded-Encrypted: i=1; AKwUvByeQkfHjfc11s0+ukzbc0atWjXbznOo+buOOnaa4v38tD08rW8NG6lH7JHxMaCTylQA20FGvqUGQA==@kvack.org
X-Gm-Message-State: AFuF++nBpJH3nIYVkiC8i0/c5SK4r4E19hvUo5i0ZNJfnbmCpI1VUVas
	NEweb8OUOJLGraCzvsXZAx5a1uULKWxuoAJaaaeMwh4+pUxOdVnJxe8k/aq495lSnVs2mfCynzp
	qYleWN2YV8QoFPA==
X-Received: from pjbnu6.prod.google.com ([2002:a17:90b:1b06:b0:396:61d1:58c7])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5544:b0:398:bd37:6a49 with SMTP id 98e67ed59e1d1-398bd376c65mr32646461a91.12.1788286043659;
 Tue, 01 Sep 2026 11:07:23 -0700 (PDT)
Date: Tue,  1 Sep 2026 18:07:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260901180713.4185641-1-dmatlack@google.com>
Subject: [RFC PATCH 0/5] liveupdate: LIVEUPDATE_SESSION_RETRIEVE_INTO_FD
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ydar4cxoetgoabk48j9jzn4753fm7jwh
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6BB26A0011
X-Rspam-User: 
X-HE-Tag: 1788286046-459545
X-HE-Meta: U2FsdGVkX19lG4hgjnHOGKcAopa4pUq/jSf5JPa9Ih2GjW5fXnq4XVQ1JOWN3CO9+TvLqTmoY98+CefqfJiZmmMuZrJc0jsSaZ+lrGV+eHHdaKWDeQnp1cRU9dt57eplf2gRYrHIdGUXC7jUmr3DzcoT+642KxzDvNAe6Yg4MJK9f/8K5DQI4xLQ9ePIYGAN74r48Vdj7AHSggE7jyAdALczqqIWKWrmizaIWBuwERujjLxPHEXBhrwmug+iyclz4INVXPX9Cb8d2ZGRM8vXwaYxHF2Pzg4vXG03M3FF/31iZAi0x1xivTrPzpgvM09sJL2T7V7DmRoLR800e2pC7+88/BTSkYzd/LW4zJdrdMU752kEQhg3WHmPGm5VrCktIUks17X/3lKSsbjDy7EvqmCeW+Ou2CI8ry4yYTgrvSdo/jfx6uaFwmdC6DfrWjIPdOCc7ulimsQ1bvuoYfqt6fMuvrP/1dqrZprWV0e6Qf5a8DS2fl77RE6UO8xq8FMGX+NBt0eLS5E6mbHCLgQxWa59yOiZUmYYBrBw53cHpM+7npNyVvjzvBkwcUuWN038VB835xObx5Hek3UMeK6k+4IvymO1XRMMpeUxgNTtKEtzyYaQY2UlF9JOnzjUpICQ7v4zILzcLBekUx4xD3nb2eJPXh62IXpqfXjLp0+gGO895pj2mybAuVxTlbjx/10w/U5tHlZpnu382Pzcw7feW4Gm6XPUHZtdSBnrXP03eeqztlWA19A7bHaIjJO97B4UuZKMnQheheHLJ4AexzlgZocp9GxYOs5eTEkT1cTkwWZx9plFB2r/lzJ88Bl6SfhFdo+tQxiZbXxE4Bp/lqBc2pOsmtJTgraKhZQZtWfSIlL6LyyGkPs7Vs3n7LFsqWYekUP5wAliv2yMlBxc0mZVxn/gtxanMHI4zK1wiKk/YMJgTvhkaplWRv9fnpY/QLuVHT5M8CIw9pbhHgxDi5l
 KlQt59h3
 np2qUz4/7dCY5b6pwaWvyKWfTtAQ633xF1e04BA7LAKAwD92D9AKphBA4In7xEp/kOZMIWWd7K78VFCRuh65PIiolHJ4cp/PHVk36v8K/zZffh0oYfA9Gz2UMPn8qARAxd4WzvuGdqU3+/xJJnXKONRa7VroKjWsVoH0weI8tXjCDkilH5upqaf4hhBL/El80XCCaQi4ULF/j+WhscEYwszetjkiiMttmddzNEzGcsFYEOa6qjEc4AR2btHghbtFIgNJuFQFM/01tlim/eyQGRAp5Xqa3MGsipxvrBDWkYgthuLo55LH9Hj7v7D0Qgd8pWDAZdV+emG7GPJuDCCj4zrIEiQ6o0op+rz6NkGAULt0d5Jq5vzfRLdadoV4WhvTxpTlNJ77VqWK35qp2RQotJm656mIlhDRYx5w9aGcsJos5FXqIO0QoPkRKap6RmnTXl/vzfV306CrHSXjfz6o35apl0QXKhkWG7kIYhZ7A3zv4c7u1o1sBvA76IjeOj/FRw3sTFZA5DGnYdsRFZIjM/O7q0FBj4vb7htVHCvEMml+0YNTOPabNUnR/Q0qyQ9rUBLRWXsWIPTXodsAxQv/DqGO51WJe0uqGmKqOsl1ETyXMCTHUFNju66fQDjRzQwTdFYCxURb5AbrP6DLUcEHQ3j9EMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds support for LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, a new
UAPI to enable preserved files to be restored into a userspace-provided
file instead of a kernel-allocated file, and uses this to support
preserving tmpfs files in-place without any changes to the LUO ABI.

The Live Update Orchestrator (LUO) API currently explicitly returns a
new struct file for every preserved file during retrieve() (e.g. via
memfd_alloc_file()). This then forces userspace to use anonymous memfds
for all in-memory files it wants to preserve. This works reasonably well
for VM guest memory but does not work well for other types of files that
userspace may want to preserve (e.g. in-memory logs, binaries,
configuration files, etc.).

Preserving entire tmpfs mounts in-place would require a large amount of
kernel support and would effectively make tmpfs an ABI, which is a
non-starter (or so I hear). Instead, we can delegate the reconstruction
of the tmpfs mounts (directory structure, permissions, etc.) post-kexec
to userspace. The kernel just needs to preserve the contents of tmpfs
files and provide userspace a mechanism to restore those contents back
into a specific file on the filesystem after the kexec. Hence,
LIVEUPDATE_SESSION_RETRIEVE_INTO_FD.

An alternative approach to restoring data to a named file would be
supporting a zero-copy sendfile() that can be used to convert named
tmpfs files to/from memfds across the kexec. But this poses significant
challenges on the *preserve* side since the preserved file might still
be actively in use. The benefit of the retrieve-into approach introduced
in this series is that it does not require dealing with two different
files. There is only ever one file that owns the preserved memory.

By leaving file and metadata allocation purely in the purview of
userspace, programs can create the target files where they want, with
the names and security permissions they desire, before directing the
kernel to restore the preserved folios into them.

Currently, only tmpfs shmem files are allowed as valid target receptors.
Attempting to target populated files, or anything other than an empty
shmem file, will trigger -EINVAL. HugeTLBfs files could be supported in
the future.

The coding work for this series was done with assistance from Gemini. I
am not sure what is the latest recommendation is with respect to adding
Assisted-by tags, but I can add them when I send out the real patches if
this RFC looks acceptable.

David Matlack (5):
  liveupdate: Extract luo_file token lookup logic into helper function
  liveupdate: Introduce SESSION_RETRIEVE_INTO_FD API and core support
  mm/memfd_luo: Implement retrieve_into callback for shmem folios
  mm/memfd_luo: Expand support beyond memfd to all generic shmem inodes
  selftests: liveupdate: Add multi-session test coverage for
    session_retrieve_into

 include/linux/liveupdate.h                    |  1 +
 include/uapi/linux/liveupdate.h               | 21 ++++++
 kernel/liveupdate/luo_file.c                  | 66 ++++++++++++++----
 kernel/liveupdate/luo_internal.h              |  2 +
 kernel/liveupdate/luo_session.c               | 30 ++++++++
 mm/memfd_luo.c                                | 68 ++++++++++++++++---
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 33 +++++++++
 .../selftests/liveupdate/luo_multi_session.c  | 56 +++++++++++++--
 9 files changed, 249 insertions(+), 29 deletions(-)


base-commit: 4e1b74c6004371b046338325011a47cd7ab9dcc1
-- 
2.55.0.966.g6673acef38-goog


