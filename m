Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9FB1061B20
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1516B0005; Mon, 30 Mar 2026 17:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A729F6B008C; Mon, 30 Mar 2026 17:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AECB6B0095; Mon, 30 Mar 2026 17:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5F16B0005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:33:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E045BB791
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:33:13 +0000 (UTC)
X-FDA: 84604030266.30.A81672A
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5560B1C000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:33:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ebBG0uKK;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774906391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moEpRCpq574YyVeyFq2uxenxnYpIyIFq4ZFl80/aQcw=;
	b=rGrM9Zxjznbdpwm1iwIBXN6DHAuucr69Bi8pb6iHDtCdU0RbZv+YfaZF0npaUriXgeKIJe
	ZTdveFdDnAslFMJWBEYQFlq06TxjSj7y+ojnZhx/bZ32t2r32xEEir77kYiT79oRAh+rJV
	VGXP2IO7fBsC5Pd/Z/C9/6QAmjj/NSw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ebBG0uKK;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774906391; a=rsa-sha256;
	cv=pass;
	b=7xhklEzPqmAx0KC+upY1T2+cIP2kHTxxhc5aDzeYQBBtik8ouhZI9z25XWs8qr8aHVMr9K
	9WWDKaoWIJ5tmBac+w7p4tYOTbA3vExYzgfsqiFSrkHcGtXbpzkHzbpoDW9WGs3uJoYz6r
	SUy6fS3HuANbUOBcJEOeFGgSsulSnyk=
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-67bac077116so2341591eaf.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774906390; cv=none;
        d=google.com; s=arc-20240605;
        b=GTOCmdkivZrCrDrEMVNYXcDbujAEo09ZPQRNapS9+mW3igmFX4Eqw+3irseoQtfg53
         q4GhfzTBeXdxmqzWhS9ntb9LV6JCx6xo+ZkSe6/PoGc7aYf9Z7ROdajaXnnYZHOu2Ec3
         SQF5joh/wZujrcLbxrtzoFWmEnH0e77LXbR7BeC66AIhDQjd3zIRNJyGldqBCa5I2qpN
         FIxMbc3OOpxkYtnyj6vmIJbVvhta69QeZAU58YZowayTYq4YhTIYeHYr5vkJGYDpSybB
         pcVbchjGiMtZ4aQvbKXKA/iYvp3j54pNa5ahl3FPFChU9ucvvCUG4dl0Q4PiCH6du2Hf
         2WqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=moEpRCpq574YyVeyFq2uxenxnYpIyIFq4ZFl80/aQcw=;
        fh=qiFitk34rDSl7g5Xnzyq72n0OTjU5iCK4PzT+mL2MJs=;
        b=GPkyJbIr3D004RXJvVXFeykgSd1CpvT+8Ga1BJuGZCbCozuQs9Zf3hbwlodtR1KAGW
         127LGhsX3LxMN5MAzPAAmzs4dYXRtJn6J2VaytEFt1PJazT1i577o3NTV+ibhI2PxfdL
         JOEMD4XV9+FeU+Sw84rZBRicQqP4NtiTYmwxP6IB9bmhPyHpvKE+vCLlDatQ5GN/y8nC
         RZGaJrOJRQvzw6VjR1QHLCSPADMqrpjD77M6aUgYA5R6SgGkHcor/2ACI8bvrdQ5q3E9
         LBBtJgb0MSTB6WTiiw7TPfHqU+eUjGZtuP6hNAxvocjL+ll2HdlTEaEvzxLet+kzh+PG
         VRww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774906390; x=1775511190; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=moEpRCpq574YyVeyFq2uxenxnYpIyIFq4ZFl80/aQcw=;
        b=ebBG0uKKr+nwC7JIbvvlaGf4YRIOCNm2isARNyxEK7gjnol8UXdDC/dhDEfWHmoNX3
         BxfD2YhPrSPvJTUZj1z9UFfGEGU8OY075FlQ1aDT0KTWrCmHFS8Ywtc9zzyamQsZCvSS
         ZiMS+KF7rrxNhGuH0hwgXfb4Cw9HWUClkxlAlAMhsE5ISaYYWXmImEuPacyc5nvti5o/
         Xpg43n4/Bto3BP7WxseCzto9nERQESFu83epDXRFP4bLGyVGPCKj6JpKE5/593evLcR+
         xlxSLMSQqwQ4NkW7Dl68aG960U5UBOVxIr2A98hotGyyhc9u86nBFo3jzZ/pSw83l35b
         nRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774906390; x=1775511190;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=moEpRCpq574YyVeyFq2uxenxnYpIyIFq4ZFl80/aQcw=;
        b=SAavgDQO/YyvHPriuScHZfS8J92outplTVtmfcWPlQNWScCzxO1KSzrMrTFjz3ED+s
         LUPzbXVj5uUluIjDDR+XGlQ7NBUVbx4pigk54+r9CueAX942FjcUG5RAuXqXB5AI0QuL
         Gw56vxUnCj6ANVOQouO1qbzppIaO/O5Staj0pOkzHAVB3mJFqeQ4oPOm98oBZnSvZ8F1
         XXoqoWMuYNu6lLqZRRM4jJBc1EnUZlJ7f3tNp6gn5BOLM/lxYj9MRHD2AHPzAXh3mluo
         DJzEZDT6HBRY0lPUaTzjv3wyY/pguQu0h+ChE/kIqchN3Dib1k624dsYuAMgXZC/mzQK
         isPg==
X-Forwarded-Encrypted: i=1; AJvYcCXgYBEm/CAwyuGpjpsRuGHxeGwxWH/tQ5jL0f2q0xgcVCObzJcc5CaVB2MR0z3YH+9XbDwmkF66xw==@kvack.org
X-Gm-Message-State: AOJu0YwDEGngzyDX9RMM4Y428UaP4IOTDzS/aGt2+nU9wQ43Y+CSnsaN
	8wxjqgWTT7MHDfXxUW6Ezbmgxn4anp3MxqVnkjwcR7Nu23e0KfgILJd2eqan0XFsj+YYJ5F8/EA
	mvlu0skXNyILyqO0bTkCOMEuiZ8ATH2o=
X-Gm-Gg: ATEYQzw+qDMXjgbQN0GHeVfkrTVwdaKAH/cVhxyI+xor/FMHNQmw4Bu3X45hRswX4N3
	BpDNjmsXnoDf4pgOZtxxeVrxiqv7k7/T94o5YYIZ4+tfn1AZHkc5EijWtrNKmflPBxmSJIq/+Bn
	FtF2+aHtw6AidDp5kBoiSI89ArtiB0hMMuuvGF0BmqHr8z31xp5XeKui3rfkND9MmrfZOvECbQ5
	56Eb3ntEHvYo53T6fPKob4hqWoBq5U0nvhsmgNfrhqBhg4Z2vDDhaf5zm6HjM0j9/sdvrBSGvBh
	FgehNy9ZgWM6kjMn6PaM8nuX87hqI98L2vJdGg==
X-Received: by 2002:a05:6820:216:b0:67e:1fe6:7ffe with SMTP id
 006d021491bc7-67e1fe6860emr6647636eaf.67.1774906390359; Mon, 30 Mar 2026
 14:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260330202909.136776-1-devnexen@gmail.com> <20260330134021.171441c4c236b03efebc9a77@linux-foundation.org>
In-Reply-To: <20260330134021.171441c4c236b03efebc9a77@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Mon, 30 Mar 2026 22:32:58 +0100
X-Gm-Features: AQROBzCX61R1EwhWV5PQYdrsvBaOkAZVfAx1L-TQw6ZPca5rc_8wTirTBL3rt1g
Message-ID: <CA+XhMqyZaOpSqCYpH-13eusaNvZDXmtprAy-93EsB+vFOpnqEQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5560B1C000B
X-Stat-Signature: 9w198muyc9uwm9x7ifbh5wruihce1cfo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774906391-950745
X-HE-Meta: U2FsdGVkX19VuwRWN1W5RB675ISNMEofOtwdOFveIhXyWR6VH+aWxwvB+H+s+MyAppYagc7dAP+urFkeLr6CnHP5zRmDj/fLOyaYfWOWL+UabwFHBss3PjCzCbGQhydIPn5m2HzbjND+54uZW4+e43fafmXBeP/TviJyEQXIwogvkOWYUO5QZOpAc3I9MPalbvJMV6vTmpoHPhXGUHYrxn/7saT2OW/rdLOq/cXBwaGzViHztD9TO2MHuEfHo80FC4yTVSyB1BSC/B/ctPEQqGsIXlq36U/dFE+dMMCU3eQSCtbmxN/jgXWJkk/A/Vaj31kalRS03LcYO+lI+3N+maTCmofEWR9FI/BW7xLGs9fZLreS7g8LB3827mkAA5kHGOE2vy+gOy1KxaxM4TSwN8BcX1hyGBR2JJeRquze3CJFCQ3NzQ1KcB+e9c3RDo0ccFs4MTGTSKDliyNVX2Umlo9PlLDUIY7wKvTraA1cFflkVO9wseDmH50uffZSYJAbnw9p54YvpOQZ/3EL/2qhhyrFLXPF2Cznk/Ex8L9y2pTXN1FL+JfuP8A4JiqEfFBEibnIlNZbaCrrr47DTzvb6Y9tMH1mPztKFQaNuRePpgxO2Yy3ZJfXL5UQ+qphB8b/YSbSMoK/gl12AEyJdvbMZHxP2TEQ0HLYsQYxxlT+zpCMq+0hIWkKi5qxoXOKtXiKSlgJI6aEW6hUDdchUW8GNjw8I0wNT8GHjmzORL1ol8T5uuLzMejc7Y8K4vl0EZH7/qmBtSmh38a4be/YO/IOrQ4cDvyMiSIvZJVnE1PJBX41LuJMfd4a39N0S30NPw45W7u+BSwXx14ibZEfN9zedqVk7AAZXGYEVZ/r4GUhNEzORxY2cE95TUptOWIma8nwXZVQ0BrdSY5iRYDyzKO4fPaUEQjxA0WRMoDsqzKS+3FmWp+3G/JV+e2vfKkGhJG/icREoad7ulDaacQWWpc
 9qL8jz0u
 UmF6uJm4/NCpzUT9UjC1/jwyEfnBuMbuAdKMNvPJdyyOP+nRvBvP3QgUt372X8vCnbPYwuqjduOiOP3G7mvgvdVC/waJKkZhy8qoavnRd1iymD5swdT9j3Ba0i1sZ3ZBC53hQKMaMETr/QFu6VsgoIsQsFpvcbhNHjXYDXM3wVQA6jpMdkkfz3dkAJsNLxDp90lFRI/JkUgwagvcdqzOQLXmEkn0ydxWvcsdvICanqAVpup+cXpD9iN0jbQHeiMj4IluJxtdK74+3sFrhw9y4VS73zcB7symHpY8pQ5fkS3U7HFCeJEh4jT9i3kYso5g73x1QnEap+k4C4S7a23KYxORk7+r7US/yKOegpCtBQk7QvmvbYZaBF9MxLUeGZdEq/o/0uR1xzTrLGe6O2rGfGII/cQML0tzjYJKQOWGyrtzt7Bo/8JQo88VQlXm5C/zCI14SGgtN/KIJHSCtKMytMEGc+oAkiewy7HYl73IAhcar3bbJyaQRH8KopD8TGc14VZh+PHsLkQdmAehgsq2mGJlokg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To "mitigate" my previous answer after further digging ...

The userspace-visible effect is a kernel NULL pointer dereference. When
  a shared shmem VMA gets replaced by an anonymous VMA during the
retry
  window, the stale ops->filemap_add() ends up calling
  shmem_mfill_filemap_add() which dereferences vma->vm_file via
  file_inode(). Since vm_file is NULL for anonymous mappings, this is a
  straight kernel oops.

  The window is particularly wide when copy_from_user() blocks on slow
  backing stores (FUSE, NFS) as it runs with page faults enabled.

  The Fixes target would be 56a3706fd7f9 ("shmem, userfaultfd:
implement
  shmem uffd operations using vm_uffd_ops") but that's mm-unstable only,
  so no Cc: stable for now.

On Mon, 30 Mar 2026 at 21:40, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 30 Mar 2026 21:29:09 +0100 David Carlier <devnexen@gmail.com> wrote:
>
> > In mfill_copy_folio_retry(), all locks are dropped to retry
> > copy_from_user() with page faults enabled. During this window, the VMA
> > can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
> > another thread), but the caller proceeds with a folio allocated from the
> > original VMA's backing store.
> >
> > Checking ops alone is insufficient: the replacement VMA could be the
> > same type (e.g. shmem -> shmem) with identical flags but a different
> > backing inode. Take a snapshot of the VMA's inode and flags before
> > dropping locks, and compare after re-acquiring them. If anything
> > changed, bail out with -EAGAIN.
>
> Thanks.  What are the userspace-visible runtime effects of the bug?
>
> If they're serious we might be looking at a cc:stable and a
> Fixes: tag?
>

