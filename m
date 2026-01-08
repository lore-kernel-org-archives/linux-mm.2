Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99187D1489D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D186B0092; Thu,  8 Jan 2026 00:07:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02F16B0093; Thu,  8 Jan 2026 00:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01666B0095; Thu,  8 Jan 2026 00:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9BE86B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:07:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B3A4B9D49
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:54 +0000 (UTC)
X-FDA: 84307614468.10.7585AE2
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id C24C314000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qCSImdlP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3pztfaQYKCOwOjOUWbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=3pztfaQYKCOwOjOUWbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767848872; a=rsa-sha256;
	cv=none;
	b=6PEfI5S2xxxG43Ikbd800poS+huUeuCICmXEEaqTMfyNAAJqW43jnnIhBI+mdAnUv6B7gp
	xIrc12wa5UU0jOX5wJ+sATZYHmnrZLhlyRus8aW/4De67dNDxI0vs49dKBMGoDyJcrLP9M
	CnMwb1nUxn6f7sX2MnZxKLkjW7XePNY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qCSImdlP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3pztfaQYKCOwOjOUWbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=3pztfaQYKCOwOjOUWbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767848872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=B0VNCFFD6rMDix3svYgMGRaPMGUEIYmv4wVFO1Dxy/o=;
	b=a+Gb/0JtRnJ9p50hdhiP31/vahmMdlFPFdupznfPynTsTt+qLNUQH2eRrBiiic1lgpQdQ8
	SNhY4zXwtNe8DbR9LxMLQ0ni3XOHnEjWXOURnFsrBqm1N2FRnEQw2OEWnQaeyMMY0SP7Fl
	RBLJjOvZpSnNZt3IV0rqTwJ/hKl1MJE=
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65747f4376bso6055018eaf.2
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 21:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767848872; x=1768453672; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B0VNCFFD6rMDix3svYgMGRaPMGUEIYmv4wVFO1Dxy/o=;
        b=qCSImdlPkqrZKXLW2vq0nt7skTrbJzDsOj0OiGF97zGyJTjzXPGayPfm9b0stD1QSb
         UxfMfH3fRK7je2KGeRP5sZ4Ox8YYd3q7ducwmVFR/9BgqX+fx7p7Sm2kNRmTI+2nz9H7
         /6kXrdrF67HHnD0CWJaCdRybDqaz6M3AU4qvFCZOY+NMXmNt8h/AAP09On378cvJRPZi
         PWuy4JqiidRzsTCffzcIPc5R+7VP+9A8ujWEk1a4dit7IYvoxznnJ15ZVk187utRXvIj
         lAombWWrqZKMdWXY/XxppqIP80Pa35/pWF5Lb922EmJfwy5lWJLPpxyaaxh2tbC8gZzs
         rYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767848872; x=1768453672;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B0VNCFFD6rMDix3svYgMGRaPMGUEIYmv4wVFO1Dxy/o=;
        b=i1c630cV/RaJSA/kD7JrYR5U0mrnRPtlu/giJzQeXf0e2hPDv+SIrVPdXzHCZCFwD0
         TxH6REmMxmS0Go4g9ME+Ep12vvrzpeOqrTvLqG72zh1CbDcN2S+QGm2xT5XLyeiEamqn
         Bo8EVjdphEjx+3MPbai7C2+Hlk9NROYWHKUHY1pcs9gzMJVS5bEtLTbmvMEhxnLAKmsu
         IN2sfx//d2VMLi5YEomfG9xFTXk/5wlkBrSfJIo33pZtTGKz/2hdzi0iziilGV6b2GAp
         GBL1jQjkwj8XpEatF1vD9WZH1ynxXm3BkQoMV02p56TlRM2mCpeew4q4SLpcGnEiIPk9
         4PbA==
X-Forwarded-Encrypted: i=1; AJvYcCWhMEt+nwdckXEtiJf2LSS6ogsy3ot/foiGl/aL23/QJ0+ot17dn4P/2cNRgWbZ0j3kR9TCEUhvyQ==@kvack.org
X-Gm-Message-State: AOJu0YzyE8cnuQ5BfI/ER/wm4vU2DNwIAnh6F4Zyt/8YQzdFIAvRCAol
	PXDcNIxQsghxmyjkE1I831W/SiUUp2cUvZcusyl0SfQo7oA1wyDRdwIaaHiMm0Ic/5rNdK2XRcy
	cGkCP2Q==
X-Google-Smtp-Source: AGHT+IHFhgBrHzgkUSk+DJKlBY6YHJjdAJxwOsdN8kTtLoTak/dkQMUOAlEAe06z6JEmnyckm7jGXWgWufU=
X-Received: from ilbee12.prod.google.com ([2002:a05:6e02:490c:b0:433:7cff:208c])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1624:b0:65f:27dd:f565
 with SMTP id 006d021491bc7-65f54ee9984mr2161961eaf.22.1767848871676; Wed, 07
 Jan 2026 21:07:51 -0800 (PST)
Date: Thu,  8 Jan 2026 05:07:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260108050748.520792-1-avagin@google.com>
Subject: [PATCH 0/3 v2] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C24C314000B
X-Rspamd-Server: rspam03
X-Stat-Signature: hn5qschuyag3aksqzetuuqub8q4sjzk9
X-Rspam-User: 
X-HE-Tag: 1767848872-793994
X-HE-Meta: U2FsdGVkX182fgOZK0O4MmpBhtJo9F7uvzV7R/cjyW/OPd1ViQz1Qq2d3iCbUnXIVoRKqwKV6M97n1Wt/2PYLB+bfobjfVUTXfSzHkSLvLcNG57lNKPGkvnYlYG7V6nNgLx06dYRFhfXhoA9xROW87p1VKf4HUWADLArrxDJtcKPfb7a58y9PfDcBYH0t7KtDkEIzpSKRTrsKQjFT7skN+mJkVOdzq69FBfxcUgK15LAs6vo6vnA9PzoLJRr7+Fy6TgKschOdwPr8P3NwI3njDbmfmnRaqKDmUuuEowNZXV2hd9sc8P1z4NAHZ2ccCUs+8rnSnKANnzFBMUy4G35phMiNgzX+lhkJiIHQ6YI2oUyfm2ikHSr4x3mzJseiEyuWDWjRe88EcUpWWG3dvBZDKF5m0ezqIK0ws9QUyPopVxmo/giG/QOAPkgoEdW8zAhAZ/nqcWFzXVZKDkyAsTfwTJhwwlr8CNUk0TrUubCea6pPJjuzjWq7R0mxFXLFQegsUw5pXWl0cdEnh0jTx86DZc8sYS5/COwmc4lFt/wOuaDML10Qp/MA67NCRJjjyT/OHzxrsNM6J+f1qHa4Td9kcVVaOdLECXN9hd5IA4A5FSAcZuvJiPJ68vfF4Ouc1SzkoWKceGiBZTtE9NYGUhUe/vdFhZk7E37OmBKZ53pHE+eioD9hrBF5ifIy+6N1eNYFzMEiAc4fzC31IUy99txwuSd6MBDXKvvuBUo8FqroJihnkw3xcwaN8XuWi3g4nbZJMYI0vJ/Be+ExauDrkcT8pLLqXSai0Pktm6oCMhG9i8pUjhCMsUehU5A3xyuwxWUNB6wMmwEmcxUzP8HMz9fALBH7STE+hUdlJ47jc6Hm7DhfsIm70CNLEXpRbQNCO8Gool/tYiFLrvgeVbUGtvseb4/zB5yAn6H71BfErnnWB4iFPZ/EBmpqLui/ENOn7FEEXDdPjaOpbhJaCK34qq
 wHYpFf5k
 6mvWTJg4kp8oSZJbfW7lFaxDg7516ztzKfQdn7dLQLBBJMVWipJRqNRsWbYfkTle2bHYp4hiv36PWWj7qDkGVR9GY1hxGJkfKszBH34NA77ZVlKVw5zfW5pG6kdlhyJYCUOQMVYvisxPx6vo+prNXWO5aqyw6GI8/XlN+zmDJRZJsl236kBobn7o2Bb5mP0Oh/hKipgVuGLxIA18RwwA0GH0EMAwY+/k7jS0VizRTxEhtCiS1gR0grL+xwz8nt92K6QeJtlwzJ/RNxswGCFa046j/MZri7ajQbdLPDDJMb9IMzzex+zFILts3C1i1JBPvROVrRdFjxuiN4IsYbogp/b1SSoXvNzZanGGQXv4MkDp2AmeFMRNBQg+BDBiSCLaENHbPgsVgFpQgAgJsKmdk3jBwiKfGAY0ZJaF39oMucwc1APVVM7FN9ZoXz58ntMdgwYmoGgPotz6ah1ug0Q6ZiBhJVFmPLE2R/cNYUhLysJe9F8XQaHIzwFUOWi8DVlfjupN67SRjRRVuO41Nytd4joGUMwMBE+cUkWBWvOcyGxdtVTHUAf+MYYrHGhh7Hdxoyx65dKTZ9ftrdq4NRCXlsZqNsHD5ON2baUrdBKpv+Wb0MD1WF/cPxzFflwqhBQCqLbxZvy2y60856THlH5d/m0YMG3lp0xx8UHcRXt7AkjhnBmxDBYk9Ma1+JF7g6YcOJ3T8/BYD+4BFLA2+hFbTAAe6Mdk4yM+nj9yKt86a394cTjgAQheTMIyBAMdC8Od5cWROznGKVPNRoAPpm2SZxA/hC/WFOiun4Mmpy19GaEKEOdkFnCSxbuyhpp5MjiW++oJR4Z/0le8S0C9svalxHZ00NqkPLpr64YrkVQE0SM6Pote2q3tsSujBtn7u/FxCTp9cDNzDhnxUQ+2IzVSIduBLAF2tJ6b0bJGM/EELkxpiTl7OODUVbFx2q7r/tvKsarIv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces a mechanism to inherit hardware capabilities
(AT_HWCAP, AT_HWCAP2, etc.) from a parent process when they have been
modified via prctl.

To support C/R operations (snapshots, live migration) in heterogeneous
clusters, we must ensure that processes utilize CPU features available
on all potential target nodes. To solve this, we need to advertise a
common feature set across the cluster.

Initially, a cgroup-based approach was considered, but it was decided
that inheriting HWCAPs from a parent process that has set its own
auxiliary vector via prctl is a simpler and more flexible solution.

This implementation adds a new mm flag MMF_USER_HWCAP, which is set when the
auxiliary vector is modified via prctl(PR_SET_MM_AUXV). When execve() is
called, if the current process has MMF_USER_HWCAP set, the HWCAP values are
extracted from the current auxiliary vector and inherited by the new process.

The first patch fixes AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4
in binfmt_elf_fdpic and updates AT_VECTOR_SIZE_BASE.

The second patch implements the core inheritance logic in execve().

The third patch adds a selftest to verify that HWCAPs are correctly
inherited across execve().

v1: https://lkml.org/lkml/2025/12/5/65

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Koutny <mkoutny@suse.com>

Andrei Vagin (3):
  binfmt_elf_fdpic: fix AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4
  exec: inherit HWCAPs from the parent process
  selftests/exec: add test for HWCAP inheritance

 fs/binfmt_elf.c                              |   8 +-
 fs/binfmt_elf_fdpic.c                        |  14 ++-
 fs/exec.c                                    |  58 +++++++++++
 include/linux/auxvec.h                       |   2 +-
 include/linux/binfmts.h                      |  11 ++
 include/linux/mm_types.h                     |   2 +
 kernel/fork.c                                |   3 +
 kernel/sys.c                                 |   5 +-
 tools/testing/selftests/exec/.gitignore      |   1 +
 tools/testing/selftests/exec/Makefile        |   1 +
 tools/testing/selftests/exec/hwcap_inherit.c | 102 +++++++++++++++++++
 11 files changed, 197 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/exec/hwcap_inherit.c

-- 
2.52.0.351.gbe84eed79e-goog


