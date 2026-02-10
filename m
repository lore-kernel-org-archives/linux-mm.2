Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2FAEB2718
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA806B0005; Tue, 10 Feb 2026 16:05:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C984A6B0089; Tue, 10 Feb 2026 16:05:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B973B6B008A; Tue, 10 Feb 2026 16:05:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6B536B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:05:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64BCF13BB14
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:05:33 +0000 (UTC)
X-FDA: 84429778146.11.C033D99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED9F940008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:05:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ADuNhG93;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770757532; a=rsa-sha256;
	cv=none;
	b=ZhrwzLKKEre5UUlwFPi+14dos9ASoeJ3aupg2XCUipwWdGvd3fIEFr0xLH6wo8VdCEo8KI
	+PM2hlz3qPglBXCK3+BC6t3+Vje95X/x7+lmf9wFy6YmeB/r/CnDeSJj6ttM6gxBnkNo/i
	kQHlUaGY+CZrFVdSo19PcRv4XEuxkX8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ADuNhG93;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770757532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPJCQilhY6Uz/33gU1TAiubzOpzbPwI9Tr4vbtBqyQk=;
	b=Fr6NVOdkHqovlOkHQfNmDrh8Di+y/owdtqCnk/0Gzx3zFO6idHqUvYbZ8Xt/dz/hoC4gMF
	K8lwdUVCQrwAwhT0cHM7uXT5K8Hrx4lOJQ8wB3kzrd1kceIhvmvLrvq66fhSwqPQ9vEoTl
	4J1dyb3d+ejI7FOjzCpmGkHhzfH2sA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13F2560136;
	Tue, 10 Feb 2026 21:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DDBC116C6;
	Tue, 10 Feb 2026 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770757530;
	bh=nqsMeqDyha2V5IhVyoL07zcaPQjl+ZL5cDfvW4eff2s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ADuNhG93qnX1UMCAlhCvKko/xuwPARaQxiiVHgqAan5EmR6Der+UN8viz6wISZtyp
	 C0BYsSuhWpiNKw1jjnbvwr7is4CCN/Xnann6XcVmvuvWAz2BkHmG4Zh6TiXFvTApuC
	 OUydoUvR28sMoPf+KB+kZZnuFx85AiMlUgsBwFArc+dUG8OABfIyo1YM5ahDyAURzY
	 MYqlg9qhs2nbv5inCe+OPcA/KTwoSb/oBSSLQVMpvSM93KsQBUvJPfHK9tniJosW5f
	 dpXxSaio3TflnBxAXH4MYhlAptBWZpxR6XymTegWDYfoCgviUIL5W7irAWzL3sdYzy
	 rWhMNrgb6qeAQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
 surenb@google.com, shakeel.butt@linux.dev,
 syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com,
 syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com, Peter Zijlstra
 <peterz@infradead.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] procfs: Prevent double mmput() in do_procmap_query()
In-Reply-To: <CAEf4BzZHktcrxO0_PnMer-oEsAm++R4VZKj-gCmft-mVi58P8g@mail.gmail.com>
References: <20260129215340.3742283-1-andrii@kernel.org>
 <87qzqsa1br.ffs@tglx>
 <CAEf4BzZHktcrxO0_PnMer-oEsAm++R4VZKj-gCmft-mVi58P8g@mail.gmail.com>
Date: Tue, 10 Feb 2026 22:05:27 +0100
Message-ID: <87ikc49unc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED9F940008
X-Stat-Signature: znjbo6qijppchnegfe3w9zjc4yrr5arn
X-HE-Tag: 1770757531-766389
X-HE-Meta: U2FsdGVkX1/4c4iWOWyxMn6qlJ64YBei0LfuD2wKYXR5bngL2d2YHE2O5y0Z5FhJefR1hA8122dGL5hVuZ7y68rWj0yNxrNsCad7Yqdjii34bdR9FU1sk4NQhNdYRVmkh26eHkRqYK+lNZBf8e+6jYuosOuuDB7pRhYgswFxF8cdVEgwgjjmYuD5aaBdMs23UXs4LSA7F76CVPJzq6EyjXiHExka0MS4gcm4lZF8vPolUb7xdIeAgst8tsK42hiPG2foBDxE3o1YB/4sg4ZcxV6zAOGaGc96eFfqA2Rnspj9aJWVnxDnV3D0GCRZm4zZ6mAPluxPshsNnZ14QkstQ45CCSlW+SVseBHRN1Uk/9bUGYsKjeUDio0RkTov7BTquqFhFJbPqdFhE7Z1euE75BM9t66b0CkOUNMZptMOX6Ht4/cYa2pxBNjHToeCx8k3Bsme9odRD7IgKBVHRdWGB4sljv27CBCn1z/iPTe+sBph3N9HK76U2/sqW/6LQmgoNP+fJSlUwvpnyNX4TS0YAc/Tx1ZFRUuc9KHtckcbAEvRpIcJy94q9Q4DuUhnDxELtEMmEdITNZIm0XgRQqCEkuI0ynJyU90HT1yt/bBupUhZNHRJj21O+qzo3f85hFKcHJkmowmT4qN/s9fdnQDPVBlVoLvVkodZ+UObefTOm+Xb3gB5T8ILMhW1YKmPEX6ijRUERsKRDIbWeN2ais0+fS1JCVsCFMnc9wd2x2553J/hbFBA0o2dd9rkhrzAYdZoZYweDnZki9so4dPglX/He4yg/b3hVlmGSZ/OI5iQGlootrIPAJ23Cji9kXEPgw3xMxndn6XDlHEe0bsv7Zfs3S8Z+Pa9zIWYKFjzlugEFcZh/zous3Oifzajis3WldldPLFtgjG40kSUqFZIhKA2HZ4JNytTKSezo9iVRLed6+wcMhcVk1iey7PomndZLWRz6ol6ECiX/7eUwrt2b4K
 4fbIRF8j
 2p3rUWmfdyz8X1FchSz7Cr93fraq3UuxFMOn0XgUzA6fSQNn/EL94S3UsIUZZcPFWvNFTP0zwyn9QDgY/Ez/j80P+h4XJisRGwIWr48MsHWCDYUjpZln0Zar4hQBP7chPqvq/uD30y8imeuB3N1GLSNBeXoOcnoQAIiJJQaHJS3o8mJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A recent fix moved the build ID evaluation past the mmput() of the success
path but kept the error goto unchanged, which ends up in doing another
quert_vma_teardown() and another mmput().

Change the goto so it jumps past the mmput() and only puts the file and
the buffer.

Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")
Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Closes: https://lore.kernel.org/698aaf3c.050a0220.3b3015.0088.GAE@google.com/T/#u
---
 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -780,7 +780,7 @@ static int do_procmap_query(struct mm_st
 		} else {
 			if (karg.build_id_size < build_id_sz) {
 				err = -ENAMETOOLONG;
-				goto out;
+				goto out_file;
 			}
 			karg.build_id_size = build_id_sz;
 		}
@@ -808,6 +808,8 @@ static int do_procmap_query(struct mm_st
 out:
 	query_vma_teardown(&lock_ctx);
 	mmput(mm);
+
+out_file:
 	if (vm_file)
 		fput(vm_file);
 	kfree(name_buf);

