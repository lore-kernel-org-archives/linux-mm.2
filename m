Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DD2CCF2E7
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338616B018B; Mon, 19 Jan 2026 06:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FF86B018C; Mon, 19 Jan 2026 06:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211E46B018D; Mon, 19 Jan 2026 06:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7F86B018B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:27:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A27011AEDB0
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:58 +0000 (UTC)
X-FDA: 84348489036.09.2750545
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id EF69D12000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ftDxZ5sH;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768822076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pP6KPkEm66wfX7plJqqUtylJcknJM7pwcp7nxWzHOCA=;
	b=hwoQ5+tZATmOAPUdewOnZs1thFo3z1+VMqeZxy74LfkPlQL4i1mcReQzrl4jqwZIjp5a0S
	565bb4l5Gg3uM2EPBz6kQCRPt9HzIRpuRbUPghk9EToqyACJgcSueR965a6TkHh/PjgHLo
	3cTZFIZju9KBtNQRWP3YGns3JjRDw8c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ftDxZ5sH;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768822076; a=rsa-sha256;
	cv=none;
	b=61VjcMom8t8gijWO3m0Rjvcu1WXqVueiaVYfNhMjVFvfCT27nHdlMGXzPQ62197C0BItL6
	i/C0IGn6HeaOmLMtXKrw2tpe/vDDRL8LaevgIqrCrT1xMnfbYJA++Jlo0VJVEGqDRKsWLK
	Ln15QFAF4k5gb9y5S9zCk3CCfCYoFgw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768822074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pP6KPkEm66wfX7plJqqUtylJcknJM7pwcp7nxWzHOCA=;
	b=ftDxZ5sHXurctM8gzOCF0c2IWFtHaLqQ17ttYAGfPv8BEVBuDn9UQA8irk98N8XvrooW6R
	v3Sf5Rw4Buxqgm97qpik/0sDPmh4f4NpEu9ncy78BBZzx+qNuYr6IFu7B86vjsXN95HaU4
	kdz9+ZMBUWl4OJpVjLliNvZIZC0Oyxc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-hZ9UXX86MCKry63XgnU0Bw-1; Mon, 19 Jan 2026 06:27:52 -0500
X-MC-Unique: hZ9UXX86MCKry63XgnU0Bw-1
X-Mimecast-MFC-AGG-ID: hZ9UXX86MCKry63XgnU0Bw_1768822071
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b6d0fd157so2840372e87.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:27:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768822071; x=1769426871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pP6KPkEm66wfX7plJqqUtylJcknJM7pwcp7nxWzHOCA=;
        b=cWyaHLnex6XEbm49mHyBfkDZpjJLkz43G8UbpN9lpE8mlkmPYBli8CcyZLrUq9dcYG
         YBPPs/+r9L8iDzb7LHxNPlnVqeqc7COwNx4y9sVz+2ZKhDa8XnnPNOAEJnSbYEMdkW1N
         Sd5OIG4Ddiop1MfTqrI77uWl8OLdXH12mEpO1C0fwrEVdm3olW8/3sTj2bdBQwUsQQYU
         CFKHZhC2FexPk1udeU1A7zcKGjgSgXGT/tV5WTVoyOo8Isua7uA6CEg13vWwwiqiMuKr
         QiU/8v2nmo2VqslHianOFOpZ0KTCaEApTfCjgcC0HSx8OE/5HvPweWomUHuoUmPIoJzl
         F4ww==
X-Gm-Message-State: AOJu0YylqjPqwt5KtOG84XiwaAqLBIX8By9Jin4AhU4NQWNMRzK5XzsT
	UOHGTLVwmKUTb4q88iXhoQJgpJKTq8o1XLoTP0GKQKV7lxyYMEfJNKJUcl0pH3/QdApJbTuIHgb
	AyRHgzgRs0ZsLWwOAPkw6tsgjurDpzSPkG4+W8KByyINbmORqbI4uZkhCP6639WJZBaLtv+BWwa
	NgYNvNpbHjFrcbQtIYmEWzPpqS+gngjYpYCu0=
X-Gm-Gg: AY/fxX6TP5HrLfHcly1M3PK13sl67fKx2oc6/dmjrLAecKo+fhl2qU0g8qQAdUcKiWO
	TA2TVgSB7l616yXOxFwXheOlTYMEB2nI6AylEXIeSbEPcDjRxS9hUAYbvpPjF+2Y6oIL0p1N83y
	kC25IbXJm78V3OrX1ZpOsF/qVNgxRwkI7REbGdkl4AVYzWoqyCY+lw3CbpNgVLEgugX+H1k0hH+
	sc57vnRYivcnzN1jMyJGYmQWtJi3wh77f1BzHe1w9kNQT7agZWcjalsI6fnIk2bX9tHj0eF/TrA
	zaeEf1u0GiPe/xDkjG/x0APeVv2yD/ySVFwhwTK+Iuv/DpSdY74rSjSk2hhs8Ck6GAXBpLHxgw2
	iHNHaFuGu00solK3AK4PRu0ah
X-Received: by 2002:ac2:4f14:0:b0:59b:6f38:9083 with SMTP id 2adb3069b0e04-59baeebad8amr3861492e87.3.1768822070776;
        Mon, 19 Jan 2026 03:27:50 -0800 (PST)
X-Received: by 2002:ac2:4f14:0:b0:59b:6f38:9083 with SMTP id 2adb3069b0e04-59baeebad8amr3861472e87.3.1768822070247;
        Mon, 19 Jan 2026 03:27:50 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38384f8a1efsm31226411fa.39.2026.01.19.03.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 03:27:49 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v2 0/3] Migrate on fault for device pages
Date: Mon, 19 Jan 2026 13:24:59 +0200
Message-ID: <20260119112502.645059-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HcZcT4p0JIokbngb86Dnq77dvlZDkQ0Y260YG8NcPiI_1768822071
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF69D12000B
X-Stat-Signature: 7zqocsjhu1ziykt6c4kztdjpt4g8g1kn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768822074-192698
X-HE-Meta: U2FsdGVkX19Ek08wWOp5AqgruydGFkX+WyBHEw5u3+DgvcAkids6L21zcxS8y2Bp4tP8terbfv1YBFW8JsuVFzNtNqzmUb+MqqE+1S+qYPdTCpnOxxODGa1xO0ZtmIhOB9evsC3g+Q7JThiggKd5siq6vov9hwvj5amSt4BTFw7QgGvRPyiVQdDG4E5K4vRLbX+vhuwwTp2hMLPzJfgxEFNkE0atni++HEIuo7qmvH08pRt2S3N/+tEu+pr8nMy9gls3QQR4EaUtFG4NNwRLrNzIi0D4Ik5xYm8HLVtcoegoJdmtiSZONQd2Ko4fP/L3/q4gAF4Dwd+w21AHO/qba+uIB/iDwdmJmYLx61v26r1OU0VAk7dpu/pP3K8h+7Un4berXfNOnU9FsBIepKfKRwmd6p5xtDb2f10HPnFI7tyAYKoVJY7KFq5WJsSQWfZjPcV+9rvOZE8798gaMVMMv3O1ZnjAB+bpX3kepmTgIIQkxt1u14icK5lQxy5Rbu7Aj4e3hcm8/clDQGu41gwEpnt7so/Tovc1KmNdBCgIq9CwVCAwKu77sS+kCkLHGN3sp0zeOVRlqj56beMuUz4KyTFZiMaxmd6MKmo/sBaQgASyyOxb6k/mwtVkelpOT1SOB5k8gSC6EJjBPfD/wLJzUA7yER4Ee4q7K6wtOLtkBchRtYbHsU8iHTt3SwNvX5WfVT/8884lOmfm/IGY52M3tdeurXkL7nzTmBcHkWklSDgkYUzNdqLUwg8jvpyyJvpPvyAI7rMgtcxTIxtkjhXMd/fpr4MbVPBtwCqIKAmUAVKaNGi3Toq0D5AbNZtScSsXldXBwDzqnUPlrB3WGslr105prrsbuB6nkFAbV2mE9pHuycWphT5DKYdnb+0hKU51FxS7WOtOOusrjQ3OAApFQEJrJiA2gW3g9gJizJaU9nITtjNceNO28dszwC9JbId9ow3b9MnhgwxTeEmUSBM
 YZhRPuTF
 IID6PO+c/rgCN3aWKDdEOfh6YKwsDFC2GZTzkHp8BkV+rfGqP4+kWZgngkPRgl4oig+IHo3RzpLzasYDCat6qoXj1mffFd6nizjORN4R2r2GwvZPoqIYP168El0YLYhXChmM0cNweFBjIEmVfUiOvgAJIYP8edr2FUfUebAKZq+dJDCmP2vByYb7GipwKKhwMkxh4BcWNfXbl3hNcerK1jiwY+G1VzaG0aUxX8PjGpgVGFz/30EIweL3XhYcX+Lc07BUHNgY7owYaxBmiNuWDr3xrgOWE27Fs3MT7ekWfxjnpEGLolLa09wXQAOZv46RloXHmihxK6kwUXl1xzGujay5XzfIqYbKuU08uAhEfRYbC1Fj2bR/7sl2I2hZzjEVyAsVPegfp5FCOkiWCB7A1IOZDykw/9s2SLadS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Currently, the way device page faulting and migration works
is not optimal, if you want to do both fault handling and
migration at once.

Being able to migrate not present pages (or pages mapped with incorrect
permissions, eg. COW) to the GPU requires doing either of the
following sequences:

1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
2. migrate_vma_*() - migrate the pages

Or:

1. migrate_vma_*() - migrate present pages
2. If non-present pages detected by migrate_vma_*():
   a) call hmm_range_fault() to fault pages in
   b) call migrate_vma_*() again to migrate now present pages

The problem with the first sequence is that you always have to do two
page walks even when most of the time the pages are present or zero page
mappings so the common case takes a performance hit.

The second sequence is better for the common case, but far worse if
pages aren't present because now you have to walk the page tables three
times (once to find the page is not present, once so hmm_range_fault()
can find a non-present page to fault in and once again to setup the
migration). It is also tricky to code correctly. One page table walk
could costs over 1000 cpu cycles on X86-64, which is a significant hit.

We should be able to walk the page table once, faulting
pages in as required and replacing them with migration entries if
requested.

Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
which tells to prepare for migration also during fault handling.
Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
is added to tell to add fault handling to migrate.

One extra benefit of migrating with hmm_range_fault() path
is the migrate_vma.vma gets populated, so no need to
retrieve that separataly.

Tested in X86-64 VM with HMM test device, passing the selftests.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260107091823.68974-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes v1-v2:
  - rebase on 6.19-rc6
  - fixed issues found by kernel test robot
  - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
    parts if migrating
  - other issues discovered by Matthew, thanks!

Changes RFC-v1:
  - rebase on 6.19-rc5
  - adjust for the device THP
  - changes from feedback

Revisions:
  - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
  - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
  
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>

Mika Penttilä (3):
  mm: unified hmm fault and migrate device pagewalk paths
  mm: add new testcase for the migrate on fault case
  mm:/migrate_device.c: remove migrate_vma_collect_*() functions

 include/linux/hmm.h                    |  19 +-
 include/linux/migrate.h                |  27 +-
 lib/test_hmm.c                         | 100 +++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/hmm.c                               | 770 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 594 +++----------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 7 files changed, 1002 insertions(+), 581 deletions(-)


base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
-- 
2.50.0


