Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE502CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9668E0017; Tue,  7 Oct 2025 08:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273E28E0005; Tue,  7 Oct 2025 08:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED228E0017; Tue,  7 Oct 2025 08:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E09738E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B999F117762
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:51 +0000 (UTC)
X-FDA: 83971227102.07.0736A69
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD1AB100014
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jsOZFN4o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839649; a=rsa-sha256;
	cv=none;
	b=Rnebx/q7YX42Nmd0wk1S4+5JXIKeMNtXYG5WyoreLrxDu25e2+d4o7e1qy7JVlQ/qlKe24
	U77TEEAY/wWGCazIYb76z1ftGb+WwpTh30w/5mpsTJpwkNUfeKl3dhsINFd8ku+9V2KreU
	IRE3MvD+qaUgjiZeIEE4AOVifCGn8wY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jsOZFN4o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R30emTvkjGHkQwmiRSKLnz0Kds8va1dPsb/YBIausdc=;
	b=5o0593JoerVOJ49VDmKCuWcJvNjX2uRhUDGdZnHRZ1hl8KN5ICj8qqRSjxtueoD+OpdQLP
	0oh4whSc4TvQFCN1yhyhMhQEN3Dx+WOno1QpjTAD21bF0/J8M774ovk3i1392zYByZyv2e
	m6kOhUGucWfEzcuB/jA3bK3MGAWl1Zg=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-578ecc56235so3782791e87.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839648; x=1760444448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R30emTvkjGHkQwmiRSKLnz0Kds8va1dPsb/YBIausdc=;
        b=jsOZFN4o2gkDZ2ev2kOwIo0YJOw6iXi0eQJfZCEOpeOTUd3i/0o4j0NHYlFNmQn0iN
         ZhafYQzoLhtfGJR0jyv2xWtgExVdkczeONgC4NotrlAz+xoKkpQFCJnUgIhTxorasNjz
         sIoA4EFqrZ4vdh5Re4LQD5qVS2Ww1knytYCaP7dGQscmk1q/t6RZcf/KvFH6EYTl8Vyq
         NradVTLu9t+lxcp1DymJVzQREY69Ammi4biid4aoz5MmD4t3O4xf+q1Vsk7xYXvmloyA
         N6cil+XHR+cUPAB0DxWMeZgAeqZ/JB7aEyN6XIb6uPTz/FIYHiW2X0TigWGnK9+EbmoE
         6LVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839648; x=1760444448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R30emTvkjGHkQwmiRSKLnz0Kds8va1dPsb/YBIausdc=;
        b=FaJspPZmqnYVPCMOEGnULYVU4YjMTHVmlGE9+nx8rvl8UaV2t5iOyKcTZJqJKTOzB1
         NfpJpaoXXFcUKaGnXt5+/kfPftO8TI1FjXTCfQXWHAlsFIAS6KlLeLR7U75FOiz28S3G
         mR8I+qLbgQfzof8WhmxfT2+1mKnf5cxTGc7wXOJdVva+1vGHXS6jdhQSxOl5LYSyO2FP
         NIPIfBFbDlQU0O1w33uXzDEPfVzjmx4sVl22b5mEv8zeN59B54SR2hYtPlyh4v/y2NxF
         8IqwAhZg0y76NSFocgWYxFeMtUye/id/aJtaj7O7h/CdrOuvACnNZDZ+nqAVVvArJr6t
         yt0A==
X-Gm-Message-State: AOJu0YxjFPwlTj2CNon8QlfqGfL2MiSodIY2jLYCxTAvc4zOqEQnJVQo
	Uc/X+LG8pbKxJ6mykGP9MaNRwltbXcGXheslHSUkGaLP4HFnXJhG1A2VALOrWmd1
X-Gm-Gg: ASbGncu4FuutPktVhCoR7HIfr5dLKcgYei6WYYLuDtrF0ZSKOc5A0VxKXqJpM7MJdTW
	6487PYIMfF5ZrYV1kWgr8scr+SbaRmj/LyF3xBZhuHhEk0lQ5APPo1ngy8VKujIs2Hf6SLIuoCQ
	dwVA5x1nGuUbKC48KFN+vd3y0vS/9W3DB2vfLAXcsXpbScXN+qaKqIFH5RuJRfGgvvnOYbEJmZb
	qUh5FRgBPQ3MXL0FiU13PfoCmJRx07bcQLv8MKFU8DScEfB5o8rw6ZyOae69zYJbMc2F0LwJdqP
	l6qq5YL0tQOvsyjU1Uvc/JnVSiul1Qoghruao3fhGdVKRv+TA0OnfarC797hz2I2+vs3pFkpbLv
	LR/nGPpS+D+lWfqxdylLUAcUOZc3FPKHR24jYzf2L
X-Google-Smtp-Source: AGHT+IHNWqIDadjqab9EoR4kVdLbVq3cRBaYZCy5fG559MhSdkjgavwhNixv0glhEVeYH7Z8s5RdVw==
X-Received: by 2002:a05:6512:1089:b0:578:f613:ed9c with SMTP id 2adb3069b0e04-58cbb62b98amr5731937e87.43.1759839647876;
        Tue, 07 Oct 2025 05:20:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:47 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v4 08/10] mm: Skip might_alloc() warnings when PF_MEMALLOC is set
Date: Tue,  7 Oct 2025 14:20:33 +0200
Message-ID: <20251007122035.56347-9-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kj1t4ef96wbnnr9n97ssp3zda5mt66kt
X-Rspamd-Queue-Id: AD1AB100014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759839649-71275
X-HE-Meta: U2FsdGVkX18q5dzTzNrlpLim+9ZsIj52Pu4YYHm58LzIRPK7D0WLmMZ2utaoDa/R+rxalPQCjHHtU0NTJKvmzW+2r2jR71mDs1J+wjutbRSpMXD39rtIrddI+AQ0bleagpGYEnFwpNwsCnCQElGGnps1j4e+BdrZu6kzPEjtHF1BwqE/B6zoLNeJvZAZpbofwPFHap/sXJHXCPP4M2tYLVCMmZOA0SPZe59RUfI2dChg0TzeN769bTfIZpodNYbKtp7SPsL0QVGUTUoPx+Ze9PLADSpkghCkkfGO2BWIt49C45yaX91icYWp1cqCNGAxmTSZGSJDM0tPWExDgdyZZ97GtKh4jv4uRHD0Djk23zCSMXXYnMw777CADc3hE1gEv234iDC+Ifu3Z6NRQeKLJCZ7TuRP6qzDXgZLbHhtyG2IQ9zdxvMZqtccYVme74X1GClARUmiYcwXB8WqmNXEQSp9lGc6OhojJdmDDJZgATWDqzFJwUt4ILW4zYVOppm5+3uBUFDIYslW4SboQUw8OAXvv2BdG6k2M1avRE0DJ1+1dl89yi0o4Lj/mPjr6uX6igxPYs5buX8OW6+1qCd50t7HpniBmBd5u0wZUNn+ga+ZxcA7YTI2Mn9M3OytnXCi6eyn5rSrLeil/QM6HiGL0QruFFSbB4qICE/pSpI94MfOSHOx3PaWyShZMdpwd+KeKyJwhRxZG0kCIk1ekXz9nAlZaMuNx+qGysxQTojxlB2nIBST8dX3Ap2T2zahFhBCC4cghVrpIlduMIiOXd250ljNo636sXDl6iEjR/pFLOBGkVYvuKAg40RA6ffYrCzjW/uBwfQlN1FM2T1NQyf1mQT2b9HKHCIoYZC41MA5CXh0vlvup+LPtqjX1otgyFLosZt89kDZyMz0rT90a3nuedhy5EL3fP3wfqUstmkSiYPM2kTkWCzEmyQrPx5VLG7MsmG1ZRGjrjjEiaP6GDz
 gReF8xxC
 h5Ar4tuFZIO9iK3KQo52taurR4WxqmZVqkCpaXyeum5Jh/NxvLJP3rldXj+NzNOntzvOYkrRBDoGhr143i8YgemP2zyuJjjC26Wedi0LTUKuS4veb4XLYUq71bLxQFBbhrAthp//89jISg0c9YqpBhFRLg7PpAODgw+wNs/PtzNT85iUxEkBapD+O9yvItn55o6JWoTd+Xt9ia7OKRlQAHCsNMqLuhcjuUTFJfhAqwBsFPkEsJ31Vjl0Qb7RbfCkxjFQbF39T7C0zvzay0vT49d9/5SER8OTqwZX7d5RVj/rzllU3mITPBVg7BliEn1w4BVp9QVFUgOLh3tZypIVsxr7bSVi8IYKw69plvokPXAyxu/17MZ35VlmFfbT8vQQmJipbGEX0ueZze0QRErEDWHXhyiu8wtlyI17cYb7gwMQsGTEfhNBswYolnmFpdVd2hZOjNN6iZ7MD0bYbfWg1ImkTKKdme3OWKHl8z0HNbkRh50PgO0kGuXGH0/cDaptUWrw6j95PGeivEI/I+5XxVhetAeQaLVBbbHCKoLgI9uAkCgbRM8UyVT61XgYMsrMpyPz9pciQa15gKjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

might_alloc() catches invalid blocking allocations in contexts
where sleeping is not allowed.

However when PF_MEMALLOC is set, the page allocator already skips
reclaim and other blocking paths. In such cases, a blocking gfp_mask
does not actually lead to blocking, so triggering might_alloc() splats
is misleading.

Adjust might_alloc() to skip warnings when the current task has
PF_MEMALLOC set, matching the allocator's actual blocking behaviour.

Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/sched/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 0232d983b715..a74582aed747 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -318,6 +318,9 @@ static inline void might_alloc(gfp_t gfp_mask)
 	fs_reclaim_acquire(gfp_mask);
 	fs_reclaim_release(gfp_mask);
 
+	if (current->flags & PF_MEMALLOC)
+		return;
+
 	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
 }
 
-- 
2.47.3


