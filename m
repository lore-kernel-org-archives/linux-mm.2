Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B255C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6929C6B008C; Wed, 22 Jul 2026 08:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6698F6B0093; Wed, 22 Jul 2026 08:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE376B008C; Wed, 22 Jul 2026 08:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39E686B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:51:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC780160174
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:51:46 +0000 (UTC)
X-FDA: 85016399412.27.AA97798
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf07.hostedemail.com (Postfix) with ESMTP id 242474000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:51:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h1V8DxcR;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784724705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vbxJv51ewBhlo0MME6tK7srEAnRYCTzOsiJppgEy5qw=;
	b=rGyu7+vQd2WZk+kHsDQA6OrSCJ1fFfQEA78WYF5N8vXRkUfxpm94rrOr1k7jj/czsQzXAE
	GCz2ZUluYvc1p9hDxv+qpeB3iQKqUw33rdF9FSwO/jaaj7QBhmTqyQZOQ5bF+RXW1E/k1i
	HkuSI+FNuS9/CT8uvDmb1aKZTsywjw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784724705;
	b=7jHGs0MUKr/H7jBqus+RgPVUaAtbQsaAxPrlNSYEstNIlMnYImKn0lOiUReoC6Q6sQnctL
	cVIlkZnt520isxgFdxZ5EgnMHVFpdz8jCScN9Y7N01Jv7hUvJbXePfADKQdnC2rCPqOcf6
	YxG1PNIhjDXczEUu+L9SMCJNwbd2W6k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h1V8DxcR;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38e47da25f8so3053062a91.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784724704; x=1785329504; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vbxJv51ewBhlo0MME6tK7srEAnRYCTzOsiJppgEy5qw=;
        b=h1V8DxcRRd5TLf+EV8Ayot+oYspU6mhkOPjvcJTsPcNxbDy66tUVUw+kzi+VQmR8YW
         REda4Qmsv+jNlugMj5C+yi/5JYH6KACAXIHBGJopJyiCigi/EXOUDA3ji4ucY4i6q9W6
         3Ncqns4H+4V514BFHCVRqaFdWLgwhTVp0y3pimZyS9C4zU5s+gfJR1S2q9eKTKcO2NZo
         yH14wTFfzLess9kpXZd2Mw0joKM+XNyaB8wZvC/zPz/URXVaFYsCf6QUibccH1zmjduV
         ySxp9K3bOflhPLN1AllJsUysG3Elm6k2UQqnzGlqkXmekjp4OYfZq6kaPnVyRiDXJBd+
         2b5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784724704; x=1785329504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vbxJv51ewBhlo0MME6tK7srEAnRYCTzOsiJppgEy5qw=;
        b=RXjpIIrfCayRVhpcDonT1wSBQXjwzCitqDBt4Bx0P+TFdWkJt/n3nNg9eVBwbARK8h
         oScbn0Tc+9BPz4YCc9Kg4HfJj29RMTAT3YFDDCdwKrjgCfcDb/B5rROKwsO+WR2rzHp4
         2/ENFX3dZRktBULulfc2UdDmNgSc9gIh7Py9L15uZOTYvsyCOLIivcy8euu9N/hRz4y/
         PAQs53TdOsNn8yqPwmBC+fUhpOgFxWZdzU+J31EKyBMVVbjmCBH8ciI2buXDL79FMvgU
         NEU6WGRKLG+6zQ4NxN5M+VNXL7xdLFvVb7mqt6gb6pIv4/Dy9bLDMezgVDdV4L3Di+6A
         K8FQ==
X-Forwarded-Encrypted: i=1; AHgh+RrKSHCLxBEOjpfREDpMP0ylZMmh1LehROxvV4wqbr1fNpCbPoFkRBKb+tlyUqDEKgMoSM9/ygq1xg==@kvack.org
X-Gm-Message-State: AOJu0YxdwmUN92b6X50gtBdnX/aQZQL8O9yHv0OfbbVjCL3FDqM+/yiM
	QQ1RzMBt2UooyMtZccVlOwO7+P7Xy0WKi7nxMdPtBOz9R03h+PtT7Zo3
X-Gm-Gg: AR+sD130pJTcX+/Szu5vTP9lu0xhkHouQBi3T2YolVj43LZxMdG/AeYK47mVtSrgZry
	LPbN9hw3xolFCiw3VmPRwbJUwDQRa+KgkoEoeSYa+m3jNAtn1dSqTjLxJMSyu6VgS2/NlZc2qhy
	gx15+gPzZNo28ucOwFkuo4z0gGPR30PjIeGUksb3OnuKEdB7ggGBklqxLLqmCvitKzRT4hGKZAo
	yw1OoNb+COpBMALfrHroeiAAlJZ/uplme/qdFfL7XJlUQm8NAmBwRLfPMIKXlm9DAMi0pgpBTRa
	o8bFNRv9GETWZ0qT9t9sJIhSMC2ogG1ZpNf+CfQhAjIKc0faME3T/w7IthjEq3B249EvvB7guZX
	bTUb0IY5Sdl7RVjnaYgZbInccXbRg6V/HE1UxiOOsjfowTjESDrb5/6iYGDd6NbMTS2kQ9HFL6+
	z9M2I7RXXh7fvMKw4uSMaQzlMIjg==
X-Received: by 2002:a17:90b:1844:b0:37f:9ce1:cdb2 with SMTP id 98e67ed59e1d1-38e4b55aeebmr23831940a91.32.1784724704025;
        Wed, 22 Jul 2026 05:51:44 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38ea78484b8sm1021162a91.4.2026.07.22.05.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 05:51:43 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: liam@infradead.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH] mm/mlock: skip __mm_populate() for MLOCK_ONFAULT
Date: Wed, 22 Jul 2026 20:51:33 +0800
Message-ID: <20260722125133.543441-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 242474000D
X-Stat-Signature: nks8t3ii9dykj9axwerp4mf4um5jrw4h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784724705-55584
X-HE-Meta: U2FsdGVkX19/7/Rv+MGQlxxSzrxcMrXlYkH6HLP/lmb5wk9PLeLz86LAcVXLnKA7aRvBrdrAlSUYwZnIzTmtfwmEBp5dKOztDVApqGLQaRcQpnxUQs3k+ExoG3JHMbVKfqUsvdRrb7JfjcKVpzXFKEMt16L5eFDfNLuP3iLHzpfkG1dhiaNqeMFw9WcJAPd3CyxPart4+/UYhXDBC+FlIwvhOWDLiUn80vCORI5nlqziP8euNR8wxecugoJ/yuhpeX8W4bk2Aet6JqxEzR4sHv8OIjMQhWuNcaWu4T8XXHzNLFdf+esFuafJUilsc1mITAdIlyeVl/hoa/VjVqdy2FegUVlgqa8XwufJKe1CqRaPP9I+aV/yTYiErDeFKiLUyRgHTv9RxfJ1hxbQ/IYAjxzl7y2yQ4934LPUblaUTli0rHjRCzCpCZto5T98HZwjRksU1nACpfi/A30VJkgRqByJ+MO/hkgSuwUd0DWuoAp8l0FO9nS+sgnJ48w23BNWMB1YfzaNYKqKF4A//zBh88UB3ciZV28BxyUO4d+Nq8ZMN/xkWn6ozKeQoU4KwHpWhH1uDxhl5TeD6ZckmaWtBHMVxvN9CYK9GvP9FxjlROTzyNYELiARs5Vp5ICVEGoKHqce0fjQg/XBvBGyzxZVeiVNI9p6dW08mlo5ISjnLB84Lmr+7hXQkZIwmj4Ff+vET1RYWzzXOWERS2OCR5ATLoV4ekn4e2i4HLoRxlW5kSetqpytAFmTDhYw5H0b1FiyaJed1xistJ+3NpyY2fo6dd8htBRqw29dLxguvpHEFGmBJKmWYtakV66q/Nj4OBId+7UL0n7AuZ+2hc2sAXA9PddjH7qTp6dXDUC9rT0CRFSwWPwyKnCpwm11Fh56QJI2omoSBOt9upDWRROfVbo2nmOTbf8GZ44j25UQCMI5tMzArYs2EqDl6pOaJcYl8uwQdZg254MpdJ/xLo9c55L
 BAQnglp9
 /UNs4CsmcN+bXRfS31uudrCJ3mf9ktCFcJ0cee/pOQItFsThMe0Zl91ORteUV+WzSXTP04+JVNUzSUAAgnuZxCEkk5SOwXZ3iAv9P8FBNe8haPYSO4dqsdp8Sc3o95eTbsdlJbBiB5vtcmKGUY+pnod+wNBZOpOWuXq+SeUhQWVUvkY0yN+KYVlWPjHge71CqdH6lqCoRPvoc2YvnnSVmomqT6M3ZgfpErmZJuYkeqj2LXWiwmv9bYLJuTq7dAUOlQqDBMhYiu21PeACY4FKrZN8Mv2SCIbMcZWigmwKDd3iTjcsQMaVZRRjG2I4kJgzOnyz9HEb1XkBou1tRUFIgNLZQNSi0Nmr6fwZSs8XlEJ6zcXuEROX+XlYpCNpOle/o+SZs1ERgL1w8dt0sH6h+6S/cmRDlbuhJwdkH3+BlST8oBr+RIEET4hU0m35XKAAx7PlH5roD0ltZMskLJtUMeMyB0K4LMiHXI7AN+8N+0uvmNqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

MLOCK_ONFAULT only locks pages on future faults, so there is no need to
fault in non-present pages during the mlock2/mlockall syscall.
populate_vma_page_range() already returns immediately for VMAs with
VM_LOCKONFAULT, which means __mm_populate() just loops over VMAs and
holds mmap_read_lock without doing useful work.

Skip __mm_populate() when MLOCK_ONFAULT is set to avoid this unnecessary
work.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 mm/mlock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfb..784bd4bfc3bb 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -658,9 +658,11 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 	if (error)
 		return error;
 
-	error = __mm_populate(start, len, 0);
-	if (error)
-		return __mlock_posix_error_return(error);
+	if (!vma_flags_test(flags, VMA_LOCKONFAULT_BIT)) {
+		error = __mm_populate(start, len, 0);
+		if (error)
+			return __mlock_posix_error_return(error);
+	}
 	return 0;
 }
 
@@ -778,7 +780,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	    capable(CAP_IPC_LOCK))
 		ret = apply_mlockall_flags(flags);
 	mmap_write_unlock(current->mm);
-	if (!ret && (flags & MCL_CURRENT))
+	if (!ret && (flags & MCL_CURRENT) && !(flags & MCL_ONFAULT))
 		mm_populate(0, TASK_SIZE);
 
 	return ret;
-- 
2.43.0


