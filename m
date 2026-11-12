Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1544D606A885
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RUCJ/Hji
Received: by kanga.kvack.org (Postfix)
	id 339316B05B5; Thu, 12 Nov 2026 05:39:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA1A6B05B6; Thu, 12 Nov 2026 05:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B926B05B7; Thu, 12 Nov 2026 05:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 045236B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:39:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E38F14053D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:06 +0000 (UTC)
X-FDA: 85426119492.04.1E1F5BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 588A5140004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RUCJ/Hji";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oTUZWvCTLZ0AEWIKU42P0/UyH3jve/9SVlOYQoSE1jA=;
	b=8rniyI0xAoALyNyF4Cx1ykBEMVYTULCTdzuMZHKj9vn1iWTngdyJIEhWYcHVaaogxAjGIo
	+D79Ul3Bi6Y3wk4m46NuDJLa0a+t8qa6ykwrZNYqQLHunPHGIyqSJsPBIlNgDzc83cBEBq
	neEe+xbDttur7Jy9h5vx3rvIq6aSP5I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RUCJ/Hji";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479944;
	b=HISEFQ75vsDER33M1Q6jX0qPlb0Gx+XCu+eKdjx1bsvW0lmqcErYmvq7LXjPEVu95znwqK
	dwrFN8Vu05bRej5vejnn/EJ8PmgfWWt3fpj4mUI6gQeKkFUNkT5XbhA9sV9Wwy2Xxk5nVN
	TsQ1z/szfeMvjVE2X6ALgDI1Wec8epE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF4EF63832;
	Thu, 12 Nov 2026 10:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2DA1F00A05;
	Thu, 12 Nov 2026 10:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479943;
	bh=oTUZWvCTLZ0AEWIKU42P0/UyH3jve/9SVlOYQoSE1jA=;
	h=From:Subject:Date:To:Cc;
	b=RUCJ/Hji6vJbi9GeyfPR/yScaM67RJyJ07c4TUAVyvtrt157ri2exqt7V6+EpyBGm
	 YU6yajCa1XYY1SVCLwHTnTFhR8d6f40hLZptj1bimg8BWaMH0AVK4JO/8vERHtPPwl
	 cwdvYENODncQKxL5+xSw8Srk5YhxX5kNoO/2QEp3JKINk0mOc7D6ps84RBtRjDhwz/
	 MTUReUGmjGn2BUh1muigy0WSxMy0MwVS4aCCIO9Bpz+auqEJAQd0vgrh75IYkxaow+
	 0hXzLguDFgM+3DqRUU+WVo4qFXX+MwHn9A95thaTcg8gdaKIrwMyYSPplI43YZq2Gn
	 cBva28lqN3/tQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v3 0/5] kho: fix bootmem sizing
Date: Thu, 12 Nov 2026 12:38:52 +0200
Message-Id: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33OSY7CMBAF0KsgrzF4gqR7xT0Qi3JSSQqIjcohY
 lDuTkxvuqUWy1/D03+KhEyYxPfiKRhHShTDHOxyIaoOQouS6jkLo8xWa2XlqYvSxzj02MtEDwq
 t3NRbwNoVYJwV8+OFsaHbG90ffnK6+iNWQ5byhYeE0jOEqsujyNRSWPeQBuS87ygNke/vVqPOz
 scCo5ZKug1A4dRX2Vi3OyEHPK8ityI3GM1vw/1rmNnwqtZQWleUqvljTNP0AjBX9RkrAQAA
X-Change-ID: 20261103-kho-bootmem-sizing-5d6aed47a243
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Mukesh Pilaniya <mpilaniy@redhat.com>
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 588A5140004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: bgh6y1faqzp89kb6q7yxhsjbugjyrwyn
X-HE-Tag: 1794479944-821397
X-HE-Meta: U2FsdGVkX1/IyhJejbq99j+3XaRuPugxgXwFBEzx2YWE+yADOn2lKtdgweB6uR/hEdwAgvo4/lDVbsvvk6eb269PFXXMTcim2mw7+UCRHV4GD9eAE+FltH9nUnkAfJY+25HQ41Tq7freZ3UHys0izo14g/x3F7uqGZAoFc1l/nxaAKy6kzJGo40cZA1Go6C4L8o7wnXR7vEvPBMobefOfo9sshxc+igklwraF4fwGajXxkkAYebZlOpotm4M9CkIikcYEeIfwO2GQnfT4xfBzXtrIR1bl+u8LkCQvxRV7Se0GchnzVND38CqB4O+HWlZihUlfBfzaMHgNRhygpvKuztWBkD8kMZnDDUreSS4rwR07KWP+slehWaTsSAdTaiUo8Oh7wGxNnCOnsIgn/12Dd+hnQhF8xrZ0I+kqOKKr+/DUhFkbTutUtAYKnHYF7bJgTuGin17Uce1J00HffLfFaBBB2lGUESPR+KnDggaQphtea5TDmJE92WOdy97wnoa2iCDzc1TTHg+83hr2uSX8nAisGARxLOkib59ZYVWIPQ+tLf/xCbIdLy4eW4yKfLqY4vxOU7/smFdBAQ4Rmi2PfTuudO7EYSa9ucrUpgR+SplzDalmPkbpmhO3JSWHrR+2aYmK58JVtExMx4SZGurj+C4PQIFOu5BWPGY/DWTkPwocDwnYGeKZdUiv8fmcmvayMa9voUBMF8zBVHTQKihfO1hDAzh8GoZh4abO4yqhR2BbIwIvKyxOFYWYbraiLRT3Ukkb9qBh5ogStSpHsVdpNNzU0P8w74GUjBu9ikKk88x9cuIBaT0gqJf6railygjjz3dTcOxY84gw9EQBMY5Zu+nPP4dXFYlulytluvJeVud9vFB7fMzDk43WkiJLlbuSBwTqffKXHY5CZfdfyqHDBl8MnaReA14XKgoKP6tblabHYcJ91f95jj3FfNHXH3YZNDU4q6rW7VinNw+xx2
 A+LtqEr2
 hr3LsRKghk85drNBCjgy+AZNNFoDa0NVPRXGzPkvpDv9dzSLD6V6GRdDvGj8q/5ub5kk+z927TP52yrx4vD3Ow0fyBCCzMQSEZWJXNxFKLJbjDlfhMVYzST13yl11CBbCo80PEGSGWMOCv/F1fW+wWtsfmr4W94KjT3skbiMnpTzEUUCJU9ddmDR9/zHo7QKBGHQkvO++dx7oCmswTkL/LU+88K3fRwp62p2H32KRHaapPsmodnP3gPrbK7RKVuzBlLN/W+q87+DkrP7sCs9AUSBpjqx9VhAne0RsDJhcjIGfyTuAevoO2m15+KBrxxEFn7W128Gaurznp6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There were several reports about issues with KHO bootmem sizing.

The bootmem areas are sized from overlapping views of the memory reserved
in memblock, so on NUMA systems memory allocated on a node is accounted
twice and with CONFIG_NUMA=n the lowmem and the global areas are accounted
once again in the area of node 0. Besides, the lowmem and the global areas
are reserved even when they are empty.

The first patch rejects kho_bootmem=0% that leaves KHO enabled without
usable bootmem.

The second patch makes kexec walk the bootmem areas in address order.
Otherwise kexec on arm64 may fail if a small area at the top of the memory
is the first in the list, and with smaller bootmem areas this becomes more
likely.

The third patch skips empty bootmem areas, the fourth one makes the
lowmem, per-node and global areas cover separate parts of the reserved
memory and the last one updates the documentation.

---
Changes in v3:
- add a patch that rejects kho_bootmem=0%
- set exact_nid in kho_reserve_bootmem_area() only for a valid node
  (Mukesh)
- free bootmem areas in forward order on error
- add braces around multi-line for_each_node_state() body (Pasha)
- add a patch that updates the bootmem documentation (Mukesh)
- Link to v2: https://patch.msgid.link/20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org

Changes in v2:
- add a patch that walks bootmem areas in address order
- update kho_bootmem_cnt directly in kho_reserve_bootmem_area() (Pratyush)
- don't reserve the lowmem area if ARCH_LOW_ADDRESS_LIMIT covers all
  memory (Pratyush)
- extend the comment above bootmem_size_update() (Pratyush)
- Link to v1: https://patch.msgid.link/20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org

---
Mike Rapoport (Microsoft) (5):
      kho: reject zero bootmem scale
      kho: walk bootmem areas in address order
      kho: skip zero-sized lowmem and global bootmem areas
      kho: fix bootmem sizing
      kho: docs: update description of bootmem regions

 Documentation/core-api/kho/index.rst |  31 +++--
 kernel/liveupdate/kexec_handover.c   | 225 +++++++++++++++++++++--------------
 2 files changed, 158 insertions(+), 98 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261103-kho-bootmem-sizing-5d6aed47a243

--
Sincerely yours,
Mike.


