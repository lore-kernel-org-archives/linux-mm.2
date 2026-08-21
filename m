Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7CFC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C426B00A1; Fri, 21 Aug 2026 14:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C896B00A2; Fri, 21 Aug 2026 14:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7886B00A3; Fri, 21 Aug 2026 14:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFCDA6B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:57:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A821140217
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:57:55 +0000 (UTC)
X-FDA: 85126186110.27.9384028
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id DE55440008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:57:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BGseqZ7w;
	spf=pass (imf12.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338673;
	b=cCoFCme4fkQh0UjPkH3di66JspUQS/RmuftM9PhBCb7rkGX3K0X9XszndW6gne1SCdnvYV
	rIg7zc/1kDLmL/1tjrksa2kO1pI1bpO32pLJmnPW7oGcZZgJ4oTy7k6eff8Af2VlFtH+I/
	+wxnxbxo6VkChjxU6IA3TfRlPpE09G4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BGseqZ7w;
	spf=pass (imf12.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g7+NxbGivt12D871ywA3vXdCtRMIy1dH4uv3I74lADM=;
	b=tE1bN5HZhgBbZ0nc9//kl7FtQIrhTx0Sk0sK0tiryxb/m4RK8K6RqHGz/ezyECQpf+Cfbg
	wLzP2RYq2NdxOe0vnoWd0/S3fe2nm1s6ZerRD4FtwXpVVOGOuac7C4Pg2GMhpMgQ2OXgHG
	AMeGqtAolNelOA7NBlZ65fc9nCblMRg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g7+NxbGivt12D871ywA3vXdCtRMIy1dH4uv3I74lADM=;
	b=BGseqZ7w3iKycabokBueXBw8eVrkCklVZHGm6OBy6DdmC9wBk0fkrbMfAGAkLCHo2hes0C
	lbL0u7Fp0Z6lTNb1lN4k7e25DKfO4PmMMCE9Ofu8YdF42BQcvvKYxSFVY7b/IoongEw0dz
	Ot7ZnDqUrNbT/cdyHuCeG7Ozfibu2AY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-rzCewSG9Oy-BWiJJP75v3g-1; Fri, 21 Aug 2026 14:57:51 -0400
X-MC-Unique: rzCewSG9Oy-BWiJJP75v3g-1
X-Mimecast-MFC-AGG-ID: rzCewSG9Oy-BWiJJP75v3g_1787338670
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9368b4c5964so100410285a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338670; x=1787943470;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=g7+NxbGivt12D871ywA3vXdCtRMIy1dH4uv3I74lADM=;
        b=mryflBBhWo/pujkavtAqKkzqVQ3l64+FzoT7/PWuf3SmpKYRh4MehLI9WLQZbfmLub
         t+K83XnYS5gknJSjiYtTRhh4+pVxycnR81OFc7WVjCQAjBgKtoxq0N8ksPtNO2Y5/ThW
         M6AZ/K02oC/dN8HNEucv6Qg7xqM9A9BBkX1JNiyuZEwdnQj4GpLgOt3u8/X/1GbPADS6
         3LOaPesuqBeckchPTtcPcNbMUXHUZjWS43stn15RipdwwM6j+1wO3mn7nKXWRMjqFpuz
         nfhLj8ioM6ueRR+nLIkEmjRF0wT6zgZwu+bvd4shyU67DYaB6435mlXQqeBm6JkBYwmf
         rxbw==
X-Gm-Message-State: AFuF++l3/IQCVnUIlZgkehBptsKmTmmJObYEBKnG+uhKKlwhuyx+1wPz
	GUbEdVm6kpMGTZ0n1YyZhZkuoVLKyNg1VO65HE18KlQs9uLqCscdhIo0f3go4AT9hojhBzZ+V8G
	oHXwx7fjsvXWduhKkRpi9LYPWRihbr52C55PZXgyEAd9ziD+JrN911qkWZGxaiRs=
X-Gm-Gg: AR+sD11CUAffmOt5OJPbr+LchrSPe/nm5gLzOVxRsrI3P5Xus1Zb7no3uBO7WPSx5Aw
	e07sGs4vaByPuTNuJN2x9iD9JDQl9YnZjZLw6mXuEMBbdNq4Cc+FRsWfiJ/skT+2zf1vOgWjYn8
	Am17DKirM+3yvmMHGvoE3CPoe2VavZaCTatwu1pyTGgOMLUngUuePDH2+8HYPdobyPklecNIiP5
	ahQR4Wfu8Djws1mbDrf1hna0TpV8S9YPQphM2qMCKqBn2Ai8W8AE+6axrboRFFrNwhmswAJ24q5
	o5KklMnUM0pX5voagbfAamqmNG1EH9wyHI/MP5iYIr5X62TNxqvukBtnX8k1p3iocnUu7aEuhNa
	Vd7pIDIM3g+RAHFGjw8rDZQHcXQC0z4YhyIUzseBdNcAE
X-Received: by 2002:a05:620a:6306:20b0:930:9585:e08e with SMTP id af79cd13be357-9373954280emr603127285a.10.1787338670389;
        Fri, 21 Aug 2026 11:57:50 -0700 (PDT)
X-Received: by 2002:a05:620a:6306:20b0:930:9585:e08e with SMTP id af79cd13be357-9373954280emr603122285a.10.1787338669904;
        Fri, 21 Aug 2026 11:57:49 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937205817f1sm658045085a.32.2026.08.21.11.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:57:49 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Subject: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Date: Fri, 21 Aug 2026 14:56:52 -0400
Message-Id: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
MIME-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvyJ7bsGENPtKdDBbbQ9WKEQg/T3pO
 DAzFQplpgKTqJDp5sLn0aDvBPjdHZGQt8agpNLSSI0+OUyUfMRMsckFtdV+HSgYa0do3ZUp8PM
 /5+V9P4pyRQdjAAAA
X-Change-ID: 20260706-cma-memcg-regions-696cb5ef7998
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ch5dSe_9Cb6XfWsTO7z0OF-3fJP6zIIoX7vpk7gl4CE_1787338670
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DE55440008
X-Rspam-User: 
X-Stat-Signature: 8xpiidx4e7rre8chnwqot1tesfaczaco
X-Rspamd-Server: rspam06
X-HE-Tag: 1787338672-405074
X-HE-Meta: U2FsdGVkX1+m3kiP0sVFwSYwurHBUh9iHIWNlHc1DxANiZ2y8pkRYnA4f1OjOf7y/CcvAyvh8kuH8Yn0H8cT0XXZV4u6ZEnpeAhxWKvj4MS/eG1MKv9mrSx+1foR5OH1qDY3iOcAWtgACwyN7hsqvTA5Y+JLdmq70mrhlb/81rVF3MyZW/ywkvdUz6v0WQNcXre2q21YcRYi12zV59zPUrytyePHXwbHiXX6ZcLuCZb+Nbc5UR9m378ywFrYsvcF2FIOOS7sb306gQDNz8a1eBkh0jlFCnyy+P97XIUnN9TlMCkP43ymTZ8gHjvJcZRd7xHSUtPkU7aQxcoKSOak7H/LgKGlsdcJy4Nb3aGLUWTtdx5B0SB/Lde09UriSilgG5uInQ+S1NCkdxTGOiJsDvybfoDfOJT8KtUUOcmwvy/eBggqUyRbhbCVY1Gi8QF2Ov8mHA6aehpFl0MPlj3sNEUo4ORPa/2n8zSW4gi97FJH1aGiK1VODxs3BxvBAhFTPCpy1114esSavlETh4smhDJlnhGtxEqJIgpFa4/eo3OgB3X4VRFSfQnPLfBzYnF+28qgaOMUyDNe+BdrInfnowVSOT7W51EJiOQ+WFH8ZLTwHL3R8li/D1JblcgoA1c1Miq0DlEfinkmAYVDhldm8ZeGFfhyJnaLEMw+tWgIYvw9YYQR7GAcAa+mBFK9vU9uBPKDV3LVS31O88x3JSVgpyhX8AGjULt40sjZpdWSYXwiqfvLqK7ydeVQVbPW+o8NrgDFYYXmwAHg34CivE5HHt9Ma+lOcfZqaVfGLskgv7zxfovhOmp8Iurt3et5WU9hgLR0/eXM5f+5VYQTbO7iddyR6b+DJjoEHtD4vbAePLgBxYKMueOlSgSJQ+OtOfYfinqaSAolE2ZDxvx4ZMYpYkmPnXrcXh4UIAvBvg1J1hRs39aVFOPCJ1Ufad6/ZAjww6HayccFMlpLr3BT8wc
 7pRs5RjL
 PAlFl8kTVdqBfapcJxaboZ/QhjXUjufV8pE1raEiaAtjYM3TiSesO6NVRQLsZNwz877JvbhGM7er7MESrDNePmYvpu3imLzsvfwXX66l/cqfkrO+zZyfZYfy4CPek4wJi6CDO1jvG72s6KKwqA+MKGOH9Y0PzGydIViJPE7ag/2KUUT8nI2ToEg/CaYG/ano0FSCUDHLCUH8IjXrjQkd03tw94hM7m91CCBPv2lqfV0mefTxF1HTH7ZSMYGUlE6MtZpCwiYA+z0XmOBZ09fes+ak27eXCmyjHhOM+cyYfnl7bUDobLuJ4MiNSN5LldNkbKpm2a8HWs5XFg0TeGzSKBGAo93RE+pXrVNu2VcRy6F+o0hIXvcc6vFlAUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CMA allocations are currently unaccounted for by cgroup memory
controllers. As system resources, they should fall under memcg, but CMA
areas partition the available space for different purposes and memcg
doesn't have a good representation for that.

Add a memory_cma_accounting cgroupfs option in preparation for the
following new behavior. Make it disabled by default since it will
account for CMA allocations in memcg which may affect existing systems.

Provide CMA charge/uncharge functions to memcg that introduce a CMA area
specific counter per CMA area. Charges are issued to memcg and to a page
counter for the CMA area used. The allocation's folios are marked with
the cgroup via commit_charge() (once for large folios, per-page for
0-order ones) so they can be later uncharged correctly.

Add the new memcg calls into the cma allocator under __cma_alloc_frozen,
for both cma and hugetlb_cma allocations accounting.

Finally register the per-area usage counters in the cgroupfs. Each CMA
area creates a memory.cma.<area>.{current,max} pair for reporting and
limitation for each area.

Selftests and a vmtest script are added to this series for convenience.
The tests are simple accounting and limit enforcement verification using
the default reserved CMA area (cma=) and hugetlb_cma.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
Eric Chanudet (11):
      mm/cma: drop const for struct page on release API
      mm/cma: include linux/cma.h in cma.h
      cgroup: add memory_cma_accounting mount option
      memcg: add cma charge/uncharge functions for area counters
      mm/cma: charge cma allocation to memcg per area counters
      memcg: register per-area usage counters in cgroupfs
      selftests: cgroup: add cma configs for cgroup selftest suite
      selftests: cgroup: add memcg cma tests
      selftests: cgroup: add a vmtest script for memcg
      selftests: cgroup: add memcg hugetlb_cma tests
      selftests: cgroup: amend vmtest-memcg to run the hugetlb cma tests

 Documentation/admin-guide/cgroup-v2.rst         |  35 +++
 include/linux/cgroup-defs.h                     |   5 +
 include/linux/cma.h                             |   4 +-
 include/linux/memcontrol.h                      |  19 ++
 kernel/cgroup/cgroup.c                          |  15 +-
 mm/cma.c                                        |  14 +-
 mm/cma.h                                        |   6 +
 mm/cma_debug.c                                  |   1 -
 mm/cma_sysfs.c                                  |   1 -
 mm/memcontrol.c                                 | 205 ++++++++++++
 tools/testing/selftests/cgroup/.gitignore       |   1 +
 tools/testing/selftests/cgroup/Makefile         |   2 +
 tools/testing/selftests/cgroup/config           |   5 +
 tools/testing/selftests/cgroup/test_cma_memcg.c | 402 ++++++++++++++++++++++++
 tools/testing/selftests/cgroup/vmtest-memcg.sh  | 197 ++++++++++++
 15 files changed, 903 insertions(+), 9 deletions(-)
---
base-commit: 98f21c54f99519329c18e2625b0ea6db14524d09
change-id: 20260706-cma-memcg-regions-696cb5ef7998

Best regards,
-- 
Eric Chanudet <echanude@redhat.com>


