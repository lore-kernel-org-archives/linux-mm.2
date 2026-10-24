Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15246606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 03:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=Ogacobf/
Received: by kanga.kvack.org (Postfix)
	id 1493E6B00FF; Fri, 23 Oct 2026 23:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FAE36B0100; Fri, 23 Oct 2026 23:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0125E6B0102; Fri, 23 Oct 2026 23:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C582D6B00FF
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:56:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 435AB401F7
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:56:55 +0000 (UTC)
X-FDA: 85356158790.18.30EB3B1
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 99CEE40003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:56:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b="Ogacobf/";
	dmarc=pass (policy=reject) header.from=openai.com;
	spf=pass (imf04.hostedemail.com: domain of kylebot@openai.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=kylebot@openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792814213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QmLSHEUIlzA6b1Z8wErarn2CLIxesBi7GU7DAVJa58Q=;
	b=qkVcuWoPS42Idw2PNHfqv8PO1Y0hbtd6tP57/FK3F1D1l0FzVh7qvUTUmJz7/CpnBz+DAk
	03K3UWImlrypI5UmsUSA/Dx0OwC2xS/quKQJdlfkf5FQgd30jLLPRaVlQgVESrE78XO1oU
	6bRSAirTNdcUaFMZgpmSwVz9BsSv100=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b="Ogacobf/";
	dmarc=pass (policy=reject) header.from=openai.com;
	spf=pass (imf04.hostedemail.com: domain of kylebot@openai.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=kylebot@openai.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792814213;
	b=NR5KUmvPcoSSZMNNy5UGVu4L431hKSE5owVgqMLzSlajmufqBvWx3J/oBNUOJEEDnq9fRg
	AJDW7hKPx9DkUiMUbIcVvoRcyrB79eWO42EAEKMg83fvNgv34d8o8lwhj5NICoX3s8UE9s
	+Zyrkr9/ofXlg80ZYzEi/s+Nf+RA1SQ=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6d68de53053so796043eaf.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1792814212; x=1793419012; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QmLSHEUIlzA6b1Z8wErarn2CLIxesBi7GU7DAVJa58Q=;
        b=Ogacobf/rBZz4fJGWHgtSEz/4k9OHMuMcLe/Zj97CDCefy/z01OwcZCpnHXq7N9Omg
         XJzds5doJh+LJzK6gOcKkQZcd7WkWL9gYc+18IukvA/Kx/MfhmbfrfTgM4BbFOC2KURH
         98iKWQtz7U7nJlqF9x8LrcY2EZZBeyY5aALYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792814212; x=1793419012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QmLSHEUIlzA6b1Z8wErarn2CLIxesBi7GU7DAVJa58Q=;
        b=eOfXPcaFiv6N1h7FOlV8mhY7pSyikN8YI5vP1z6otuHbhuPhqE4EvKgGIiwedFSU+N
         s/1QCFAfu2TXWeBIVaDZ/ef5x7U1XUfbvWQrdCsjSlxt/pcNMS5BQs1DzzOcYho7xUoi
         DLQOzZUCuQ2duEPkYwSzbfqvSyq2P+OZcqHH9E9mFwq1Qrw/nW8czoDX/BiE6zNMrI22
         PyvQYywA1LcFeOvjQ6vAajmJQfZkfKTMItzdYeWka0ictXvJnQbxMh38TLzhnv+Otqzk
         AOZh8G5cNvaolD0VmsiB0v/V0FDautNjn7CrTAVwNI0SKYVLtdsFWF1+ojJPHx9kj87i
         Mhhw==
X-Gm-Message-State: AFq9FYKDRJYjODZYgU/9kvFAIoGCoaoEl0VLSAGxLOco2YbOPzE1vuuK
	+rAqOAWokYdILn1itAwqsnNq7oCa5mWIZJ/8539MXzNx6LhGqMqr15fGS36wSEzQiM10eNKcL/K
	fk6k75Ho=
X-Gm-Gg: AYBFou3RWy7mpONO2k2Bsvo90ttmaG/TN3TVMp8R8A3sdyDTo8+fy7iy559QiuAR0Lw
	oONgmYjQFdIt+8CN7Nlkvl8X1sIemvmBtxyi6aZichWb/21fBtIskxqGlffWROC9amuNhltCd5R
	LaYjXwlT+BO6kLTSVNhhR4hMNgtO4fg9KIVJ1Wr9Bg0koDBc/lrY3kruOEZ9TT6wTDG+5hk6Rlz
	KvMzXjuN+UADUHiZ68LtfubxexCZ0d9/IqljrA3uikJWNhvNDvxPGBr4zEhvABEBCumwwkv6Ux1
	KWA+ZPDxILXiTerWyqB90ZJ2iqevT27qD/aXF51cc9zoSxz6VsMwHXemaF0q0UuWV70AGttSddl
	uac+sKSfGPbV9Ue9rpnsIz7dlSx9JAYhd5TR+9viaJlpg6gzs+ukrPb6Q8o6K7gCnWuWsJAwqAO
	uIO7cSIOyEmmtXeoj+Nv3HVsoroj96f4blkhThvRa7p9NIs9k2Ig6Dq/sdP+pQdVpleq8FiMs08
	e8Hr2XttCrqszT9KujQ+DR5H+b7HH5nX/+CKaWtBUtflRQK3RUiZyCeNQmMAAH2EbewCuunZ0Sl
	cri25gkflPcUFgiQJUWyAYsR+PQ04RVb1hvGrvwdxdyT+4iUPWvQGef9
X-Received: by 2002:a05:6808:309f:b0:539:dfe8:9960 with SMTP id 5614622812f47-55c00335864mr1018155b6e.56.1792814212486;
        Fri, 23 Oct 2026 20:56:52 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.5])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c0429c56asm649076b6e.9.2026.10.23.20.56.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Oct 2026 20:56:52 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] fs/proc/task_mmu: pin the mm during PAGEMAP_SCAN
Date: Fri, 23 Oct 2026 20:56:46 -0700
Message-ID: <20261024035646.68348-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 99CEE40003
X-Stat-Signature: whfjr693c5aejiuuqwom5a4ko4ckzkmo
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792814213-982168
X-HE-Meta: U2FsdGVkX1/u0LUKteWZyhmXDrzhm5c4eWgVE+IzRvOWA+b+xAZYxCA+gGFyorTHuD/+uidOElHLskxi/blWoExSUd1QQQOWGokZaHSp9bGCWTF9uWxJuxTV0sEZH3v+rhS3JOBMybznH0qR+BLQZwW5/DSwllB38ihidLoLFV+WDWg2LoweOkgx3uYZlpJZXOa6pS3caW3/ClJqGoRdAcaIdh8Bcm8NhhCDRW5FSAFyNZyMOTjO8yauft+Mrh/+wB0w9zeLF04TX3DLNT2MKS4ZWQM0daZKelffUhP7WjzlaM6ex2EsBjGJP9KwugoK/RLxMHkGzwaW3Wv9b/v8XyjpMG4QFzGw64CpX1NXM74qEt+OucLAyj3Xh415digV3xKXm+4nebcb28ZowErESRHl9/J+OaoIgASovTl8HZprc5MzUoqSgpQyvm0HnVjM0N9OJTWyUf/iBedpItlNgTPK/pztXnDR4+kYea0fi3ZMWRQVGBwLEE1B+34bCvXsqnc9LWFJ7SUUlz6JPvDeYEvXsnGHrV7NWSADLv/rKMkH7cfcHFtjFQpDW9HN7F7sM9RY/Ah/1h5td23UHLf7R+RkbFnAjzv8dJrKhFHVHuddoNa1UZDlRnmExonClNYQUKLTHOyU6PiKQk82j1YehQCni3zlMSacPkcmYYDgdgzxxEGxaSvWda04rKsx42rFCNZo1knTObrsPmmheoNHgODQCO2E3DkFxoZchB8wjhYk/kv4Z56kAlXYrrdUe0mITFyUX3NtNtM7qDPymYMcG0BjeZK80CKetZORf9DNIRfPcY59ORP1XI7Io3qeBGZR6kDNmXm2EyjXcwDUZ2FWQTL1m1gVSZnVHeaHm/3obAHVpXuwoOBi095EdENrMlPbNHPMFZ+s0ng57rDA6I2hGuDGs9mjwe9uvyEeK5kSQj9zEbxvMds+e6eVB0iE63QydxVshO2u91Dr6GF8DmZ
 CtLuEo4Y
 IoeaqGgXplG/KhVSHTM8LVzyPy/usgyrDgA/0NhHfBZ5MZfsM5DbMFgjWYDEGwykPD9AxJxQ6xz4AQtmWvo2LNhgdds3id9UJhU4rKBUJoMx+oa/73z8qPJZ2AsQ20lDOcHwBh259sIgYmZe45s1l+LD2XEqD22G9qC1bM4CnVR0+5cGNXkkKeLeTdaAFmHfctKccded7YMshe7XlgvIoXJwpIqYjjJ2Cze7Kz4GESDMK/+zov65WPyWlJsnlYuXucoPsAd11zC7VVkCfIr0dIBf7E+AAU9z/Xh7zRHAKg3o/Qwy5zgJUDYiNF38hIO6CKNoyoaFM5ZkrO+5Qxr8C5DgrPOMQ0MK75BXWjiCWEem/P5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A pagemap file holds an mm_count reference, not an mm_users reference.
Unlike pagemap_read(), do_pagemap_scan() does not acquire a live-MM
reference before walking the page tables. Its mmap read lock does not
exclude the first phase of exit_mmap(), which also unmaps VMAs under the
read lock.

A process retaining a pagemap descriptor can therefore race the final
mmput() and access resources that have already been released. In
particular, a concurrent last userfaultfd close can free a context still
reachable through a dying MM's VMAs, and unmap_vmas() can free a shared
HugeTLB VMA's lock while the page walker is entering down_read(). KASAN
reports both a userfaultfd context read-after-free and a HugeTLB rwsem
write-after-free with unprivileged, read-only PAGEMAP_SCAN requests.

Acquire mmget_not_zero() after validating the ioctl arguments and keep
the reference for the entire scan, including across mmap lock drops and
MMU-notifier operations. Return -ESRCH if the MM is already dead, as
PROCMAP_QUERY does. Balance the reference on the bounce-buffer allocation
failure path and at the common exit. The pagemap file continues to hold
only its existing mm_count reference between operations.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
I have a reproducer for this issue.

 fs/proc/task_mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe2118..d2cee8dcba58 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3235,11 +3235,14 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 	if (ret)
 		return ret;
 
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
 	p.masks_of_interest = p.arg.category_mask | p.arg.category_anyof_mask |
 			      p.arg.return_mask;
 	ret = pagemap_scan_init_bounce_buffer(&p);
 	if (ret)
-		return ret;
+		goto out_mm;
 
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
@@ -3294,6 +3297,8 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 		ret = -EFAULT;
 
 	kfree(p.vec_buf);
+out_mm:
+	mmput(mm);
 	return ret;
 }
 

