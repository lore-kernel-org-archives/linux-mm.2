Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7F4606A33A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Mv3GWYME
Received: by kanga.kvack.org (Postfix)
	id 244B66B05B1; Fri,  6 Nov 2026 15:57:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CBA6B05B4; Fri,  6 Nov 2026 15:57:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EB76B05B6; Fri,  6 Nov 2026 15:57:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDBE86B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:57:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 479DFC01CF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:57:48 +0000 (UTC)
X-FDA: 85405905816.17.1FECFCF
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5FBDB20002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:57:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=Mv3GWYME;
	spf=pass (imf31.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793998666;
	b=4NVFInzPSIFDeAGhgrOYkXyWTYgTFhGGW8VMABuFB8y77nrzAXl9xe0cgYsortK6TaXwbB
	QCd/rIiyQm0xXJUZAipTAQwahSvb999Tb5YSK44gmtTFkMhe8ibHTxsK92cQI5K2EYiFEi
	ulpLnwJXeW3C/dhiIApQAlx++rUx7Bk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=Mv3GWYME;
	spf=pass (imf31.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793998666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ewn93dkGZpHFDMZE/S6AafHhS3ce9FIqGUZ6Arv8zrg=;
	b=R9XTgnzZifIpuKURXORqDEfYP3RIDUjMiYZt2eBt7o7Fwp2cCZvVCKbw4rpGxo9Tbo2+jJ
	ePbiBGwQ0Ybp3cw8AoGpj5azqT2nbsT4rBEUAjJzq2BC9c6iu+8QCl53wXR3cTCdXCyDIz
	eGpzsmDBPTinuHNB75Y+EQHmad0w1Ag=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=Ewn93dkGZpHFDMZE/S6AafHhS3ce9FIqGUZ6Arv8zrg=; b=Mv3GWYMEFCM7eiGpjj3
	uF4GYhEcOV4jBfmRKGr5s0EI8qwwQ4us6ZZvJ0y942mTk09d5j9V7IN6zHwjW+BQi5Eqeij04NHmC
	Crd+o5ELCViaYPXNE7qtXjPSlEbiARRFiymLyc4ujTv0c+rp7jOaVL819btqGLe3ZFjZrBHFKdQWM
	0oBv9puUVxEB7AaWSbQ1q6RjUEtWWhcZlu8GICNQFdKOlkpp+nbrs+7OB7dCgrIpgKlAUa1g9P/ww
	xp+ImbaSeMFYQ+wtjhNB4qnYmCBkX4DCM9RICw+NGHhHQSax0skCdicclCiXl68zAZ6fqVv/yNps1
	tLLxr9hAIfet3nQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xPQwI-001xD7-1Y;
	Fri, 06 Nov 2026 21:57:38 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH v2 0/2] binfmt_elf: return the real error when program
 headers cannot be loaded
Date: Fri, 06 Nov 2026 21:57:36 +0100
Message-Id: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-0-1c8b7b1dae5c@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEE/7moC/6WO0Q6CIBhGX8Vx3d8EMbOr3qO5pvCTtBAHyErnu
 yf2CF2e7ew730I8Oo2eXLKFOIzaaztswA4ZEX07PBC03JiwnJ1oTjl0HEaHI0QfrAPK6zOvoNO
 DMuGOLwU4WIMGXraVkHjspfNQ1KVSnRJFgYxs29uE0u+9e2t+7KfuiSKkWDJ6nQKf/Vikyfv3Q
 6RAQRW1qLgsS+TsGrULk51nexTWkGZd1y+qcgVREAEAAA==
X-Change-ID: 20261014-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-395ffbfc33e2
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Paul Burton <paulburton@kernel.org>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5380;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=Dz0Kciz9xbnWEFdZaxNvTnIBk+1RrMxzuXIlAdPSDXY=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7j9FV1ZzsdbwOi0L8boH1E/7Jho8NXtEqsL40
 Z2PFEx4R/+JAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCau4/RQAKCRBRlgpH+WFc
 KqqWD/9Z8AejCCQpb81V5vdyXSd1fqohKRoVPs7S/FPAXVswFZ2PsPddu7DZWOUdRZ+mRp2oBx8
 4DcCwaS2xXEk4kslcBmN4rttJ8rJ8Ui+O109HvzYw9sNZkgbmOLqTRFOUFbmXN6ogaux9EHiZIR
 2Yat/CaXdnS90VvxY9meIVKQ4ayH+v6nMlnX/DkUj5snYPEZ9E7JoQcovy01C8wUmJLovgBB1FY
 1T7M1glzJt8j2bOwSKHBv+pagL98UrFMHV3j7DqcRI/vsDgGZyrwtk5uhqlsjCXaPH8TiYmjxIc
 Q/X2jfwiFl0H1I/fB4tTs3SRJBHiQSwJrOSxmL0NQZnPif+ITUpn603i7sMz9cCjh3EPhUk1o+Q
 wGNmSFGm+6g6Yv9ni/TLuFbBt1UA7wMTCk6ycaatWmcuIEnDYcNtHSP5BOfHTSNcDP+fl6Oq7IX
 eVs7PhOUIfIvRfiDVwA977aCUxggFCswisoUNbWU94VaFoQ7GfaTbR3NYBUlfYhXa0O3OZcx46W
 Z+vzg9XzAk2/yileHr//m1yvMVBx0VdJaEIukAUOTAlXdFN3OUzbrP1vFF8BKse46yUBJzty+Iv
 eGnabYz3BgsTDbyXp2TPW+/AShFEe+g+DY7YU69AvSq/4848IX+VhhyrTR6/CwLaEEWO6Jv633p
 DGkF3j/dburSnvQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: 75trpthmwtzacq8jih8htdhbrhky7rii
X-Rspamd-Queue-Id: 5FBDB20002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793998666-471498
X-HE-Meta: U2FsdGVkX1/efEI2IBwja6XtycEsqOG7QFL659q3nyfEA6mQM9yJgevdAQ8RMrsAIzpr0MzjLm1ql7PsyJXHCCiyZsZzzWQXC8WikJW1/jNBvXedgFr6pWerSTM0Tnn4Ar9kpCRFHNiSNWAl9dVmy/0nIp8wOT5mxHjEpsih75r76Z99ZROHKHYMzN+k42N6kRmyGRhbYpfJwGlaXbWwTFriwVHnQu+WRJj+O9hCOLpFglY2LzX0E6x9odtdqPojR3scMYTD/FeAWzCfi/WRVpmcg36BbQd7VWdWZCfkrX9AveUH5QjuzSu15U8G9fmwEQSfyLFcy7uzFg4MjT1vCiPtMkm5V8yf+beLq3HzKIHKL/1plyGvqabnACiZzceqQ9WZk75/Jz44LDmhlHljdal9Q4IP2P0EeuWtQJox7n+sNnU8ZdI0yz4w4VHMsYg9lLMC41n/NxJaJGEGIQ4afyFvep4v0PXOf6lYFsHVhQzEm2LdGLI5kZe8Lws7Meb8K0hNhVj2zdrw6nOMs6YJJj3a/6N8w0O/N6PHTAhQrgPU1m0joStsmG+XeV8RSaBG5F9UvWTFUCs0ZBBljeFX04/QS5PRVgHWSpI/pwzEo9V1jKIo/Bzc0J5wR2yMup6RfVLmHg0nARY1eXIp/M5JTFceN6Jauuf9U2ln1n5pMUv/lugAtatYWyTxkPorQy2r1EFUd41J2+F5gxbLWsbKDHdok6LnLTK9rr/V41nOcb//QPqp3EYKvv7D4mDaMOaC0xMRcDTFA2iwqKLVW9/iFek94oSxo0TMZ5nPyGwVSI/xBiK76dcEJE2/jbtHZNrf78DHv6VgynE7FyAQMxNCDM4GTGYUQR+mXRAGbpYh2FKAcqpELsDZ9gfW1AEPJlmaeRy6wVq45XZ9RmZ000kMxIL0MkLRXpZ73fh8QIS1TbXP3PSfj458QOxz76vQrNqWu6T0yqN5ylPZfpFLgel
 FVqyDf23
 /DXO1mj1i0p9aE1cBy0BXfuYFet96iFJcM6WFEj/AghxbEmCBUmBTqZdQInTZkZ/cQm8m/xykhfQbz9A71VpI608Ddfih/EtaTeB/Loy6biIwAoxF5vr5oGfADa0Bav6aCKsVm4LotN/d5zjCF6KwN0NAqQuS0IPZpg3AEUSIRxQKV87ycGfr9lTASrSswi/C70WtxmaDyVQxJn8mkqLC7csr+FoIT+lyeuCrPf7T3iWDBIftMO3X9TAdHU60Qtw8/eC/TI8Wv9PRJAnktcu2gmJc02i/t4N3gQoHf1MYQXvFYiTg6r4mCQ1iZuXL3ABwv88g+KdU/4eGf/BYZnbDO/068CjhKEPtZLFeEUsuXwUNELLyby7SRRSvVSsrI3GmzqIQkj8dueSGOvS9+TZ1HhuxuQzOopUzabT9Aewn59IY4YCttoqd5wEfARdi5VZ/w64d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

load_elf_phdrs() returns NULL on any failure, and load_elf_binary()
turns that into -ENOEXEC for the executable and -ELIBBAD for its
interpreter. A failed allocation or read of the program header table
then looks like a bad file, and glibc's execvp() runs the ELF with
/bin/sh.

v2 changes the errno of those two failures and nothing else. Patch 2
adds a selftest for both what stays and what changes.

What changes
============

  +--------------------------------------+----------+------------+
  | the program header table             | before   | after      |
  +--------------------------------------+----------+------------+
  | has a bad e_phentsize or e_phnum     | ENOEXEC  | ENOEXEC    |
  | has an e_phoff past LLONG_MAX - size | ENOEXEC  | ENOEXEC    |
  | starts past the end of the file      | ENOEXEC  | ENOEXEC    |
  | gives a short read                   | ENOEXEC  | ENOEXEC    |
  +--------------------------------------+----------+------------+
  | cannot be allocated                  | ENOEXEC  | ENOMEM     |
  | cannot be read: kernel_read() error  | ENOEXEC  | that error |
  +--------------------------------------+----------+------------+

For the interpreter's table, ELIBBAD stands in place of every ENOEXEC
above; ENOMEM and the read error come back as they are. A read that
fails after some bytes were copied comes back from the page cache as a
short count, so it still gives ENOEXEC.

In the kernel, search_binary_handler() now stops at the ELF handler for
these two errors instead of trying the formats after it. All of those
decline a file with the ELF magic of this machine, so the loop ended
with -ENOEXEC before anyway.

Userspace
=========

The patch adds no errno that execve() cannot return today. Other reads
of the same files already pass the kernel_read() error through:
prepare_binprm() for the first BINPRM_BUF_SIZE bytes of the binary,
and elf_read() for the PT_INTERP path and the interpreter's ELF
header, while parse_elf_properties() reports a failed read as -EIO.
The program header table was the only read of an ELF exec whose error
reached userspace as ENOEXEC.

The execvp() family acts on ENOEXEC: glibc runs the file with /bin/sh,
that exec succeeds, and the shell replaces the caller and exits with an
error such as bash's "cannot execute binary file". glibc's
posix_spawnp() does so only through its compat symbol from before 2.15,
and musl's execvp() never does.

Shells check ENOEXEC themselves when they exec a command: bash reports
"cannot execute binary file", dash runs the file as a script. With the
patch they report the ENOMEM or the read error instead.

QEMU's cpr-exec live update re-execs itself with execvp() and resumes
the guest when that fails; on ENOEXEC the guest is killed instead. With
the patch these callers get the ENOMEM or the read error back.

Testing
=======

x86_64 KVM guest, mainline f66469d9905b with CONFIG_FAILSLAB and
CONFIG_FAULT_INJECTION_DEBUG_FS, selftests/exec:

  +------------------------------+---------------------+---------------+
  |                              | without patch 1     | with patch 1  |
  +------------------------------+---------------------+---------------+
  | load_elf_phdrs, bad tables   | pass                | pass          |
  +------------------------------+---------------------+---------------+
  | load_elf_phdrs, allocation   | fails: ENOEXEC for  | passes        |
  | failures                     | the executable,     |               |
  |                              | ELIBBAD for ld.so   |               |
  +------------------------------+---------------------+---------------+
  | the other exec selftests     | pass                | pass          |
  +------------------------------+---------------------+---------------+

Unprivileged, the allocation case is skipped. A kernel_read() error is
not covered by the selftest, as it needs a filesystem that fails the
read.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
Changes in v2:
- Dropped the read loop: a short read gives -ENOEXEC as before, and
  only the errno changes (Kees).
- Patch 2: a selftest for the errors of the table.
- Dropped the Fixes: tags on 6a8d38945cf4 and a9d9ef133f44 (v3.19):
  the errno has been this way since then, and the change should not go
  to stable.
- Rebased on current mainline, f66469d9905b (after v7.4-rc1).
- The Assisted-by line moved from the patch to this letter.
- Link to v1: https://patch.msgid.link/20261014-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v1-1-f39c74d55e42@virtuozzo.com

---
Konstantin Khorenko (2):
      binfmt_elf: return the real error when program headers cannot be loaded
      selftests/exec: check the errors of an unloadable program header table

 fs/binfmt_elf.c                               |  38 ++-
 tools/testing/selftests/exec/.gitignore       |   2 +
 tools/testing/selftests/exec/Makefile         |   4 +
 tools/testing/selftests/exec/load_elf_phdrs.c | 399 ++++++++++++++++++++++++++
 4 files changed, 428 insertions(+), 15 deletions(-)
---
base-commit: f66469d9905b39d2c260a15d7d6db450f4db67c1
change-id: 20261014-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-395ffbfc33e2

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


