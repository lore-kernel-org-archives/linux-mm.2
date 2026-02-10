Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3932EA8126
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB1F6B0095; Tue, 10 Feb 2026 10:09:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BA26B0096; Tue, 10 Feb 2026 10:09:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B4A6B0098; Tue, 10 Feb 2026 10:09:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 050046B0095
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:09:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADB011C596
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:09:45 +0000 (UTC)
X-FDA: 84428881530.25.93CD226
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF2DB80002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:09:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pwno-io.20230601.gappssmtp.com header.s=20230601 header.b=OAdQikkO;
	spf=pass (imf02.hostedemail.com: domain of ruikai@pwno.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=ruikai@pwno.io;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770736184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RGc5OTHgcoocgxCFJU8w8WfHuJ5/hSTuCq2HLusSvVc=;
	b=i4P35IPDsuuggeAm2Ldh4xm6D6YALVvSyBXtlnAnpE47jR5qzqXMluP8+e3lRFrvr6jpML
	gRAlaEp+L3AwYxuo58trAA71aQWyUfzGvuwfM/ftZn4g2cXyUkWu6N2XbDx/lUgmto5nlZ
	Tjt0oiJsnF0Bl7bTtSor83p46vXCcac=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=pwno-io.20230601.gappssmtp.com header.s=20230601 header.b=OAdQikkO;
	spf=pass (imf02.hostedemail.com: domain of ruikai@pwno.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=ruikai@pwno.io;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770736184; a=rsa-sha256;
	cv=pass;
	b=jYSyrFYAhCaxbXrzoLlKggkOiuFtLWA1CYIF6Nv4X7SaQzzt20m1CxWOaxu+5sSotOeqI4
	kY6O/BKXKqoakwvhNyc/F7maH/27Tb1Ipe7fbcMcvSKq1bO9blTqK5Wq1m2e2uGI2Ed4iq
	Fie5/1V8JeNQoGlsFsWr4+hr+lLw/BQ=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2ba6aa57d5fso2470496eec.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:09:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770736182; cv=none;
        d=google.com; s=arc-20240605;
        b=FEn/DI1FEcl8juqw2txlGmSW8kRuP2xz5vBwvvHUNvnmMuBVc4KiVmJvDXBsLBhML1
         dIB8FqZ5O8Qcc3y2O63Kx3U8oG9MS7FBCt6TJr8/7eqQlWOJZsOJvxPlXWDVF6Fjt5MK
         6t9GRbqx00kocUOWC746nmTxjAWM/sym6IU3iZYj7SGn1dcpv1BrNEESyRonHALR2ng0
         0JJNV5AgHbsb+MKctthJUiB504enGH/mEUya8AahcecJssKCknvuNTZu+d9Rhgbn9B64
         X8tl5ys2iyraqkE+3kvEUluWEeZ2uUe9vE8NuWO0wCZblXiNiCU8u6IpcZKkOhzOB8NY
         OKRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=RGc5OTHgcoocgxCFJU8w8WfHuJ5/hSTuCq2HLusSvVc=;
        fh=mc9Snzhu9y3/rAh/a5taJkQKoRA0tLF+xicG3JT9aq8=;
        b=LFe9ct0A5HLWu2fladihhd06Zxi1hpaxRdC0OMksyNCAFstXlQjaBlIG5YPwqJaNuL
         UaTeyaRlron9JYNOJJS5LFcerC9bPAh8z0ISX0MuBilXrMjDydGVDF27E21+Zcm2PQUq
         HS9akEx+wDFTHbbFMq8andrPWS0AbqHuiek/cptmhbAULlJP3VJ7U+11vo4w0GdNqvxv
         fo20ou1kwItYqSipS7dk8s/2VAIpW0qC6zg7sweC98rVlLtRoYmzBq3PXoJr1rcIO+3a
         8d2JP2nRh1th7z5xB/ZZVvYpVsvK+w6lZ7PGzj+3RTB7r5Lusngnle29yhVm4M5rrkq5
         VZiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pwno-io.20230601.gappssmtp.com; s=20230601; t=1770736182; x=1771340982; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RGc5OTHgcoocgxCFJU8w8WfHuJ5/hSTuCq2HLusSvVc=;
        b=OAdQikkOt0jVDLkRGe8M4B25CzGJoFDZ/tV2uez0PQDLs7Kr8qknzhDGAPkEH8QpGV
         wf1dsNO2Gn9IZQQoXtYyU17cmUmN7brdk3eGJqRpxfZraYg/Ehjy6qj8qUn1SdzNzYD7
         AtQpNLlpqzDR0KC0jEGlYPAVROtNoT03Nlo5PvZebO6aW39zNhsDP4m6X7CInP4rIsUb
         FIhlC+o3hqJ75CdajvYI00krWTXlaTNk8R4bAAxKc2g/DQ0Tt4vNlKfKZw7NEO5KqR6J
         Xs9NaoGOu+8bNapSM6WQ1SmJncu5uxAR30PdOEnT01sLa1FHSojLefqdRzho68vEdwVh
         YNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770736182; x=1771340982;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RGc5OTHgcoocgxCFJU8w8WfHuJ5/hSTuCq2HLusSvVc=;
        b=QC+tS4oewBw0tdt0D/hKy4R3GZd+4Nnhzn1C1GhoT0nSI8fgGrLHL+xFc6cgMH1xpF
         7hAzmrwEHzHzccwa0FswCfBv8AK14VPLYb5/4jlxyyl2PyEfcDu5R9r1bqKBdMYbKC0x
         G+OZaj18z7NcoBzfdvWNIQD4I4qhuFZ8VsL8ywZDXy5yMG7hbbO1bdD/NxTuAxCMwDwn
         o8i30dsKy3cR5BzTNvtRgJyxPKSiVGqiYnkg9WMc8DjlAs2/H4ikNacPKioqNY5UY1wL
         CogCPY6Xkkl76JLaVuNN1wMSAKtpXbU/Wj+mtq9dedaA+MxmsSZNPMILRCk2qWfU4vOd
         VqsQ==
X-Gm-Message-State: AOJu0YxkGWuaZuD7ViojyRlxWNQ0pPN7Da/0YiDN+hasjxDCdG+p1oWf
	UDDfMeMFhZjS2n5ePHcutT9We9T+Q7qwcxRNcYxBNgYtHuTLedfGpBUibZ3r+ReIxE+ufyAJ8Pb
	NiVlC9kVGvYsMrNILF0MO46fF3iE3vcHd1nnhjNyFxqU=
X-Gm-Gg: AZuq6aJH2+aVGpcorkH86wK+9wdYjYz0toSVvsgcNDryuAvrTU10t2FXmQao7uO7A9R
	VwFA8L4nJvmDASGJMQpFLPJisF1Ol08EiFazNoizpmx/3xPKhhBaK4l7bJQO6E23mLjDmn6rqhI
	kOud3JojkvVpbu+o9MlZ9jJYSECrW7iAVHlpzKKBxktJLD4TLLdb1zmk1JLxXA3hKhM7K7esix5
	QEGylVQ4wOIX7NrQDOaqpHn2fv7Bzk6SMxWDSI21l+FOPrvW7T6sQsGXqhpdOz/lf6781at+YhB
	jq6d/brOJVHMDvW6aL3niOydpRGkrjKiw49t91Y=
X-Received: by 2002:a05:693c:6213:b0:2ba:75f5:72a2 with SMTP id
 5a478bee46e88-2ba75f583aemr2182461eec.2.1770736181962; Tue, 10 Feb 2026
 07:09:41 -0800 (PST)
MIME-Version: 1.0
From: Ruikai Peng <ruikai@pwno.io>
Date: Tue, 10 Feb 2026 10:09:30 -0500
X-Gm-Features: AZwV_Qh5UHWbASfm1jZpF_oayUh_n0GQOSgntMIbiash-aQw3wMkKP6fz1z-DCk
Message-ID: <CAFD3drOJANTZPuyiqMdqpiRwOKnHwv5QgMNZghCDr-WxdiHvMg@mail.gmail.com>
Subject: double mmput in do_procmap_query() destroys address space of live process
To: akpm@linux-foundation.org, andrii@kernel.org
Cc: linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BF2DB80002
X-Stat-Signature: ozp5rdxnc48jn6mt3yrg53dsafio33xw
X-Rspam-User: 
X-HE-Tag: 1770736183-186174
X-HE-Meta: U2FsdGVkX19yt07bTO7Vnepuh+g0WQHnWgrTjYVdp8q6z/h8a6j4AYbhy7IXGGwHwV1VQtTfRIVgzP26bqjhBrjI39N/mfbLKK0qqxGK1bp2JzCeL9vf7cTNkWAkEQRbe7piHtHnQhgzZ9IBUfNmUlzxg/WAM1TK11y7duMV6OWs1/m64viGdPaxe39+i/wOO5DhUwadWpqpWf07aKGJBCf2q0WHeQ/84ux9rgwBysspfeR0wMsnruTboZtdScf9f7vPWZo16xpcHZQVJ8bJVKAN0e030MTqP7y3ElkwZswY/JTpCwu6z+i9NG9dJMo7cWSpf5oHiJAbZHWoxyi/RTPq30lYTz2tns+6jDqnrHN1ZGhBeI2DGwuNs8nYT5UamigKE7FeMuI8zXxjbUXWOi0IQYqldaV6fyCM2G0KQTmmKZOIJuc0Ba/4U0ErbwpryfsiLtQnDDp09NKvf4S4w51WduDki4NeLOs2mUAz8Tl/+GFq2Qz/du8uvFuGw2mMyRAlv8R/ZdeC7GZodNe2niKmwHG/QqZWNxCIXVISCHw2GfCFInc2yoeF2QjdrmrkPSnRhcFQtynbd7S0tLomfNBXnyqPOh1EfgqIVQ4GS0nKgZSWb/1oxFauB6sAGcdt5YU8uQDG+WyMhQ6HTFbABPG5e81Tbly3lPcC1sW0j5OTlhWdirbh57amPmu4QrVlVwrPqDjaQutALGTZ8aJTf/7lrB4Z3KsxMmK6nXkR07Gul3dmmCAB6VnM+6HTrw4NMBUwglSOEbkSY5QXLhkuxcKrrG/nYwC+6nqCbEKyOeCYMJehzutA8E0bXiAPoe48nQARMa4cstm1fr2lhOtfU55OTeWscV1xhhzprovGJIHUFrEtfWETO/JR0+gi6pIBAYlXdJZq9Z3ZpqX1abJKzt2TR99gSfnZYWHFO5Dh+fe6pXvs6o5zBH9H++LkH+I/jXyVE4vxS1m5oDm7n1d
 TFYwC5wA
 9HofoCiNxQhKYLoVr8wCdTymdHZqpMALAhHQ7f4uYX+fcTb2bI9AQqlCy7D43zBLgREtOc4l47d3fE9G/5nzc+B/x0Y1mRuas0rGINfP2SaH6F9DtbJstbG1kG6QZU6og8UyHVxbIJQ6NBNjiU2gGmD+xUtAgZzy6jYCDWpc8qYzeMXv/5D60yoIJs1i4ttMX2ss9DrNRYb794lZDB1Dp2X44hdpQMIZIzPTp1lMKDZJKKg4dtwAXmt2dN3hj3Ktp092NPum1VBOxeRiq9gE0iXQUMIyqr79d+tJYx5sB1doJHSRdG9giKRh65qfXF6PNHXiOKMWWaodrU89Hc6eTd5XfWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're reporting a double mmput bug in do_procmap_query(). When a
PROCMAP_QUERY ioctl requests a build ID and the user-supplied buffer
is too small to hold it, the function jumps to the out: cleanup label
after it has already called query_vma_teardown() + mmput(). The out:
label calls them a second time. The extra mmput drops mm_users to
zero, triggering __mmput which calls exit_mmap, destroying the calling
process's VMAs and page tables while it is still running. The process
crashes with SIGSEGV on return to userspace.

Any unprivileged user can trigger this with a single ioctl. With
access to /proc/<pid>/maps of another process (same UID or
CAP_SYS_PTRACE), an attacker can destroy the target's address space
while the attacker's own process survives.

AFFECTED VERSIONS

Regression since b5cbacd7f86f ("procfs: avoid fetching build ID while
holding VMA lock"), first appeared after v6.19-rc6. Not affected:
v6.18 and earlier. The original build-id code (bfc69fd05ef9, merged in
v6.11) parsed the build ID before teardown+mmput, so the goto out was
safe.

ROOT CAUSE

do_procmap_query() acquires one mm_users reference at entry via
mmget_not_zero(mm) but releases it twice on the build-id-too-large
error path. The function has two phases:

  Phase 1 (VMA locked): query VMA fields, grab file reference
  Phase 2 (VMA unlocked): parse build-id from the file, copy to user

The transition between phases is at lines 768-769:

  query_vma_teardown(&lock_ctx);    /* unlock VMA */
  mmput(mm);                        /* release mm_users: 2 -> 1 */

After this, if build_id_parse_file() succeeds but the build ID is
larger than the user buffer, line 783 does "goto out". The out: label
at line 808-810 runs:

  query_vma_teardown(&lock_ctx);    /* no-op, already torn down */
  mmput(mm);                        /* mm_users: 1 -> 0 -- BUG! */

This second mmput drops mm_users to zero and triggers __mmput ->
exit_mmap, which destroys all VMAs and frees all page tables. The
function acquired one mm_users reference but released two.

The refcount trace for a forked child:

  fork:             mm_users=1  mm_count=1
  open /proc:       mmgrab(+1)              -> mm_users=1  mm_count=2
  ioctl entry:      mmget_not_zero(+1)      -> mm_users=2  mm_count=2
  1st mmput ln 769: mmput(-1)               -> mm_users=1  mm_count=2
  2nd mmput ln 810: mmput(-1) -> __mmput!   -> mm_users=0  mm_count=2
    exit_mmap:      destroys VMAs + page tables
    mmdrop(-1):                             -> mm_users=0  mm_count=1
  return to user:   page fault -> SIGSEGV (page tables gone)

IMPACT

The process's address space is destroyed while it is still running.
Returning to userspace causes a page fault (page tables are gone) and
the kernel delivers SIGSEGV.

- Self-targeting: any unprivileged user can crash their own process.
- Cross-process: an attacker who can open /proc/<pid>/maps of a target
(same UID, or CAP_SYS_PTRACE) can issue the ioctl against the target's
mm. The double mmput destroys the target's address space while the
attacker's process is unaffected. This is a targeted process kill that
is more disruptive than SIGKILL because it destroys the address space
mid-execution, potentially corrupting in-progress writes to files or
shared memory.

We did not find a practical path to escalation. The mm_struct itself
is not freed because mm_count remains positive (the proc fd holds a
structural reference via mmgrab in proc_mem_open). The destroyed VMAs
are cleanly removed from the maple tree before being freed, so
find_vma returns NULL rather than a dangling pointer. The process
crashes before any memory reuse window opens.

REPRODUCTION

The bug triggers when all of the following hold:
  1. The queried VMA maps a file with an ELF .note.gnu.build-id section
  2. build_id_size in the ioctl argument is nonzero but smaller than
the actual build ID (e.g., 1 byte vs 20 for SHA1)
  3. build_id_parse_file() succeeds (i.e., it can read the file)

Trigger from userspace (the binary must be linked with a build ID,
which is the default for gcc/ld):

  int fd = open("/proc/self/maps", O_RDONLY);

  struct procmap_query q = {};
  q.size = sizeof(q);
  q.query_flags = 0x10 | 0x20;  /* COVERING_OR_NEXT | FILE_BACKED */
  q.query_addr = <address of any file-backed VMA>;
  q.build_id_size = 1;
  q.build_id_addr = (uint64_t)buf;

  ioctl(fd, PROCMAP_QUERY, &q);  /* triggers double mmput */
  /* process crashes with SIGSEGV here */

For a complete PoC that forks a child (so the parent can report the
crash), build with:

  gcc -static -O2 -o poc poc.c

The PoC parses /proc/self/maps to find a file-backed VMA, forks a
child, and has the child issue the ioctl. The child is killed by
SIGSEGV every time. Kernel log shows:

  poc[65]: segfault at 42a78d ip 000000000042a78d sp 00007ffe5c090c10 error 14

Running 50 iterations produces 50 crashes.

TEST ENVIRONMENT

Kernel: v6.19-rc8 (commit e7aa57247700) including b5cbacd7f86f
Config: x86_64, PREEMPT_VOLUNTARY
QEMU: qemu-system-x86_64 -smp 2 -m 4096 -nographic

Best,
- Ruikai Peng

