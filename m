Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D11C606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3926B6B0AA2; Thu, 22 Oct 2026 21:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B2A6B0AA4; Thu, 22 Oct 2026 21:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6A56B0AA5; Thu, 22 Oct 2026 21:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8326B0AA2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:54:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94F731A0375
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:54:42 +0000 (UTC)
X-FDA: 85352222004.08.DD574B7
Received: from mailout-l3b-97.contactoffice.com (mailout-l3b-97.contactoffice.com [212.3.242.97])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA73840005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:54:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=mailfence.com header.s=20240605-akrp header.b=FubXlR6z;
	dmarc=pass (policy=reject) header.from=mailfence.com;
	spf=pass (imf01.hostedemail.com: domain of brianwitte@mailfence.com designates 212.3.242.97 as permitted sender) smtp.mailfrom=brianwitte@mailfence.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792720481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PJkZhkXXrchYq4gsC5K2d7L85eJ1XLiR7+w6n85/cPg=;
	b=hmLWjdCQWFjeb6/e4RwARJjl47GGoIiUraN6mbriJCNshvsZSaH0io2y0EwYghtcQClomZ
	sBmv5X/jkvOtbUWvc3T3WHTQ9xXZ6UkvcCY72lOowjw70jpAsQzGp7aSzajizRgf8ap4jX
	LZH9QmGGMoGI1JwHoYgjRh/uF2TQWIE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=mailfence.com header.s=20240605-akrp header.b=FubXlR6z;
	dmarc=pass (policy=reject) header.from=mailfence.com;
	spf=pass (imf01.hostedemail.com: domain of brianwitte@mailfence.com designates 212.3.242.97 as permitted sender) smtp.mailfrom=brianwitte@mailfence.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792720481;
	b=VUPWo4K1+AdPiN4G07FTJ10+EBj+cN8zIugUrQkBiurv1yvtfs5RRRuOuJmGksxF7OUPox
	+5nT8ca56Ian8GHhQN95pnCMhWhMP8joOx9drRz0dDUIJxTCKg1gS5B8FbrQ3ptJ0d5xvA
	bL07K+/eTe5a/4f7sluMVYXl+MqGBMM=
Received: from smtpauth1.co-bxl (smtpauth1.co-bxl [10.2.0.15])
	by mailout-l3b-97.contactoffice.com (Postfix) with ESMTP id 1EB2A60A8;
	Fri, 23 Oct 2026 03:54:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792720477;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc:To:From;
	bh=PJkZhkXXrchYq4gsC5K2d7L85eJ1XLiR7+w6n85/cPg=;
	b=FubXlR6z1yM5mVmHNiqSXEFKDp30ljJDES3DB5U9Ify16xMUoLFYMQ//XPSHuHNO
	N/MjJqVhRoCj1/eRDwfWz6ovg1HmcOT7Mn2WrSks/5hhVGzXekxABaPQt1o7N+Y8l/7
	Tk1CSB1xneHqutOwSrNY3Gk3FQUkzR1TtwNKBErskGd4fr+sviDRirHXtoqGQWWU2QC
	aWt4P+iWGupxjYi+VKbuBbFZ7e9q2+oLf9ryhkb0q0JHGjPPkAT2LRnb5mfM0SXdjvS
	K8cWA2xZN/d9Nre63mB/6KyYaj7TAwqDa1XJqn5iHwV9et72wdJulRJci+pjoWUXPEA
	hGjF9g1UFA==
Received: by smtp.mailfence.com with ESMTPSA ; Fri, 23 Oct 2026 03:54:36 +0200 (CEST)
From: Brian Witte <brianwitte@mailfence.com>
To: Kees Cook <kees@kernel.org>
Cc: Brian Witte <brianwitte@mailfence.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	Helge Deller <deller@gmx.de>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Micay <danielmicay@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] exec: randomize the argument block's in-page offset
Date: Fri, 23 Oct 2026 03:54:37 +0200 (CEST)
Message-ID: <20261023015345.1594514-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CO-INDEX: xeqgj8PHouPosme+woQh6pFtig5yQF5AvYLqRg7GJhc=
X-Rspamd-Queue-Id: BA73840005
X-Stat-Signature: o7e4wqdjx3cu4ncs5jir8oborgros5iz
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792720480-540193
X-HE-Meta: U2FsdGVkX1/fVFrCWtkywjHL1Cxd7H4T4iZ0itw1qPgMm5Aiw5c3R7Ajz2AmiCOAVJSXJu0cqJs+Vb7KZvMmYHc+rvLpX1u6eK65zT1QBtKqn0SAmmDvy4pEh8o5qCIeuwDy9QN1j5Dz3/NAIlMS4Fri6lW1SqK5lBVngne/YvVFFXA6l2UkmhdV9Xt3hu4YAAAexfucJ6SC5DF6Pl9RU3p8nk1bRAMw8L4XV4VWhUKVMKJUFvOn+x1SbBdFw6Qnm8j4VAdmyl6t27/PQxYehBVR7zjIA+XHg4YXzScUP9rbzvk/916aF0zVdKG8zjSh1Rr9LLZJHz+wtHw9JzXxCgiSqd9P0gxPlZX7uuIj6SWOE1FHCNW3bx6XMuAlL/uj/ASWKeDPFUpS/UWZBvwS+4WtqU5mkYuguSnwHBjjYQcjtrtSanTjOmFuqqUBjmssIHQOX0f0x9mYNWsfOo/xOwuI6zOvz1hHZ+87uA9g2psvvEf6u0AQDu1V5Q3vU2wEghez4uw7Yh5PEJAa6Lxx5X1NRz5o3MrmWD9SjPYk9nQp9D9wQh2wW1vnZsEGu44P344Rx06RymUE3yjBVFz7cNU9VDqr0+pwcgxeJKj7ehwnFBTq1l/qv0scqlZoNyEPz83bnbRaBmBBHYrnuXsKo6Xa1sT1FXm4AhUfU0E8xph9cvhsbiBX7WelFeJC7k88UN3cy1eMWDcDih3oeRJoagw/xXS1Rw12ffzfh/X/oWCqMI/AuFGYRKeQnNA01lweMbDz0X7SOPeYhRTW5G/+/1zXIvF/yUZgMcJdp33OwAld8nB9YsHUPs7xB0bvdzty28cZzhGREswbslDLG3QPOgFNncQHuEK4lzT22ZfCD/DzMDHWymHDaX7ywdy4jWxUeKW6GnU+43ghOmeF5MjT8OyHTTBufxdZWB4ervsuIAU3VSVd4EslU9F7vuo9rRTVxfAp/y5eYJ95P9EsyVe
 OK25tnge
 w0dVqCoInf2XDQWSiqz8psZ9OmyZXs6kiwoquMB2an5qKMKeFMaf7vnvF34EM3LLg9KzFxY+eYhLLEio3K0mjeGqOM1aIWV5mWQ+bi8uAleL7llm1DMBBYMK8cYMVHLXpHYPn+Y95tMQs6j0UhcFlLBL0vwlV6GpXakGB/tz4YtksJulJOpGApSdOJsulvHxVhVdamrIhkmmmmGE7gdGNV4rmuQ2hJMw6+SrgbTj+qzB3oWIqUeOhQiqP/6M/AVZWLLNX+eg4oINJrJB/P5QeKgT/DA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Patch 1 randomizes where the argv, envp and execfn strings sit within
the first stack page, as KSPP issue 283 asks; today their low address
bits never change. Patch 2 adds a selftest.

Patch 1 repeats bprm_fill_uid()'s set-id checks; I can send a shared
helper as a preparatory patch if preferred.

Tested in QEMU, compared with unpatched for-next/execve (b36b990c50b1),
on x86_64 with ia32, arm64 (4K pages with AArch32, and 64K pages), and
parisc 32-bit and 64-bit (STACK_GROWSUP):

 - The selftest passes; unpatched, it fails.
 - 10000 execs give 3709-3764 distinct offsets with 4K pages and 9259
   with 64K, as a uniform draw predicts.
 - Cost: about 0.5 more minor page faults per exec on average, and up
   to a page of RLIMIT_STACK; exec time is within noise.
 - No change in LTP execve and execveat, CRIU dump and restore, or
   programs that rewrite argv[0] (setproctitle(), sshd, postgres), and
   no KASAN, UBSAN or lockdep reports under exec and chmod races.

The series is based on mainline (864c07de0c7d), which now includes
for-next/execve and the const mnt_idmap conversion. On that base it adds
no W=1 warnings with GCC 14 or clang 19 on x86_64 and arm64, and the
selftest passes on x86_64.

Brian Witte (2):
  exec: randomize the argument block's offset within its page
  selftests/exec: test the argument block's in-page offset

 fs/exec.c                                     |  32 +++
 tools/testing/selftests/exec/.gitignore       |   3 +
 tools/testing/selftests/exec/Makefile         |   5 +
 .../testing/selftests/exec/argblock-offset.c  | 214 ++++++++++++++++++
 .../testing/selftests/exec/argblock-report.c  |  24 ++
 5 files changed, 278 insertions(+)
 create mode 100644 tools/testing/selftests/exec/argblock-offset.c
 create mode 100644 tools/testing/selftests/exec/argblock-report.c


base-commit: 864c07de0c7dcbca58b61625dfa2e461ae63b242
-- 
2.47.3


