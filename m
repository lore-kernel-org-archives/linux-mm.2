Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CA6C9831F
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF1B6B0093; Thu, 24 Sep 2026 16:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6226B0095; Thu, 24 Sep 2026 16:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFCB6B0096; Thu, 24 Sep 2026 16:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC27F6B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:16:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7224B1C2F13
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:16:33 +0000 (UTC)
X-FDA: 85249763466.15.F437DD0
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id BBE0D10000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:16:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZCXofWaE;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790280991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WT1vJAlJB3UqsXiDI150AgVhKS27Afshhi+pSW9AfhY=;
	b=LdcrcFARB5yc6qpZQaU/ZfOUCKPoef+a2o9HV76a4aiqmZLUSOc3MZfL2SVRJs+3b5b9+M
	cqUYBmeqp90z4wm4k1ihxTpzfSpiYrfypImv6AaBuZfVCHv1PC5ZEhCVZ90FKpIO5naOwm
	COtr3/Re2NU5oWP7LmO/VIi10cOHbcM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZCXofWaE;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790280991;
	b=WtMGPpbyZrG10fN68yCz66LvPZkMzGlR/Rv6mDpXn4+wQAIThPBawXPhpEsbdxGoE5Su+V
	dGDnoAW9MzY8ctRtc3vFJrErV4daDsvpaMWMwVcOt9FM6TEy3pH/5k3ciBGoDX5WAOFnpd
	NaUiyrub9ahuPGEEuNhTot7b7UH8WNc=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e2406so1063705e9.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790280990; x=1790885790; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WT1vJAlJB3UqsXiDI150AgVhKS27Afshhi+pSW9AfhY=;
        b=ZCXofWaEoB7XHB5dcGcggDBh22CL5UI4uikmPkEcjGgICbZ6cJX8PxkRT6u8hCZbf3
         xrTpg5QIaerbpC1Xzn4zBJvxjrDAM7+ycaydw1pMJf5u+NA0aPeaN/lVfCDcxJqeQ/rq
         3FAISqopBwXu7Cd/QY4MvXRTqHNVOZyHhG4gEpkH4vyeFMhEQvR8g46u/AzYUBT91rVA
         PN2jnQR29NOyT5VMfHe6qE81s8SzILeuYz0+1xcxTJxdNHYS0X+CBPlTRiDC54vIRHu6
         4Bv0xop+Cah4AIL7XT14jQJoJvTdNTPNHvtJtgteiIXvZbUtvf02NbA8qLq+rEBTgcp8
         DP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790280990; x=1790885790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WT1vJAlJB3UqsXiDI150AgVhKS27Afshhi+pSW9AfhY=;
        b=C2UzKJtFyPKJXtsyAN+FOffFt5kL/1ebRGGAwVVqiZQB8P0S9XVURCpYkLUb6yibFw
         vjHc6p3aWHZpn8m60i73ahHKU60TjERDDO+7ldayn12b2zPVA/pIUBGIwvZtBx7eSdCO
         sjjh9Jcb6tt+FzRmx02HzvdPljIzNM5giJpaC29faJXFPL6p6Jl43EikxZSJuaj8QJa5
         mY7MgKRPSS5VDvqgEbN7V4s6W/r9sP0rXXv8ARB0ZRGwEIq9xr11j4djFThAHVKwpUVh
         pfukuij+fJYgULG1QX/Fo9dZsVuXFwxVb3DAapjeAmN/t91z+ioSyA9SfuJ+C9cJk06e
         dyHw==
X-Forwarded-Encrypted: i=1; AKwUvBwdw4dtELdi7jEcYWPzV9d2Y6XCqvuuCBQev+zFufkC23JfKIiWcqcNd4BQn8DtMsltT905b7H4DA==@kvack.org
X-Gm-Message-State: AFuF++klYCHhGahcJ/gDeNBtQT5vaHnzXMR6gA2XjesfdnMrKklUFVLn
	Wax4x8IW+MKgUg6qdPtSHee7q3CV11qVwPnJM9AkVX/Z3cAAAgI4+xTr
X-Gm-Gg: AYBFou0PwNLKwW7vEApc7cXTqNJL281efAPuHIiYFRk0SUwHi8ap5fEwfA7Lkc7/l4l
	ErgGa3JKFv3ZmL56PnDfLZYiVt6rJV2xOBXAmhn8zLuhi0RayLvYQmPnEcGtFg424APHg0GC18R
	aKH7rY8pdh4xbspTScpQNbQeKoiFxr39Z6y3QkciNv9ZJdivvhqH0n2cfSxOK9UjnRc0SJ/JoWJ
	9Q592cnaxyKDuhxxyUh1LesMOQEBb+n+ook6J07q8Ysy4IT5ESBleAyVTRI6IC60l8/dUTL84TU
	Uo0CQoSCOkcYchWsikYO0iPmiftzoP2VclEKOy88nvReKpKLdn0DVe+ODfmaBQkXRgfb0ZrYH3c
	sOnZe2Dc712IsBhVojeWrn9PHSe7a1D8qJjERo2d09xcJfzHITXhP/wMTQhlu7pJSM4JxK+oYRe
	cttT/gQmCJw1/EEsbDDj+0feckpprDeRQ7l0/Or/jVHdNAbOlHr5b96mRM0wz/vonT93SdeqXZS
	jGowIhnTDi6/BMo5aoUmfAfKwceTma+esYrr+Iw5uwRzzXdHLpoCNfzUmkgcixFVyhFAkx57BY6
	mBPkSW5Eo09P6+ratL/uKFrFvg9xxIiRftdVvORTC+NMaCjeXuvIpwUsMoYncS/ombm5UVjS7dh
	JyM2C7et/+F54vGBM206pcA==
X-Received: by 2002:a05:600c:8b5b:b0:49c:f13e:e4d with SMTP id 5b1f17b1804b1-49fe66f17damr60720065e9.10.1790280989870;
        Thu, 24 Sep 2026 13:16:29 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-adbf-6901-3138-76b5-e9f7-b9cf.310.pool.telefonica.de. [2a02:3100:adbf:6901:3138:76b5:e9f7:b9cf])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5dfa6a7sm144818795e9.12.2026.09.24.13.16.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Sep 2026 13:16:29 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/damon: preserve quota state when constructing schemes
Date: Thu, 24 Sep 2026 22:16:12 +0200
Message-Id: <20260924201615.4478-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BBE0D10000A
X-Stat-Signature: by9dyxwt5qe17j8t9dosat84r9b49467
X-HE-Tag: 1790280991-826571
X-HE-Meta: U2FsdGVkX187tNy769ML2HjXX8yh08/k4x8hjXgJFfQ1sZyavfTcrvMlZJf4l/bFHj8Ef8lnB4FCH/9nuPzn4WyxOjjWn3thcVTEH9fVR7dTGRMkKxyq0ykmR0S8YUL0mqMcC8rVbiJkc/+f/EIeQ4IXJ1ikfuYXBHQypJH1lMDYSfu+fCatmDLiatRfeyFI/f95/kKK4rS0bxwzQJ5G4G5Vb1FB/Ws5+3iJP2ycvQ959cqQPho0VgSMBrJXEzk4hEgExNIlFFKLqSeKCXFp8D5ENKEe8YIu5URrsJ/YEi2lvKY5FqSnH+Y194hEgz7AHt0VR3IsHi0L2ZGtAkdN0oUwXTYFwXcVltjfKao1RPv7uZFx1g9/V/Ktrrz7chVfnhv/v7eb6thYCeF5ANfWHA+BQhRABn1pajtUuEY9xm2PNjt7G1PfcgcN/D3iJjXefPurJg9Y5irQAnNUFDyk/PkgJMcUYBNprsLGXfnRKzCBx/v8SrYudGvBCklYCf8lrZPgywEIVd2IkJQ0RD4fOeMIwYJQjJaHZcLAPoTMANIcJKXx6IBugXaaG0MxfbogUwpXVQyVX0ornzWfujFSREMtqqdwzEYvZXRPbZPIFwqTkHIlYZdVrcfHQ0isiKh4wLH1PVpC2f2DjzKZueK32GRIFsj5lQv9GKK7Lj4ODwu4bCltj87rBf1otiunMRnpHySXm+Jfql24Ey0PW/WtZlqFLEMtyMUPgaUpCc8S24fNdCMzNXykPAXcDmbsr+O7WPSDDZGGilWvNZgAzh5/CRsudl9yI2AGXNWppO4XDelR3JZfPAsh3nlqCgCqYenkT1rIqPbJEY+aDYPKtk5wOb/wfg1hMX1zmfvNeJlnTgnxhB7LOLr5ktI3E8vxmEmKFtvz6TR8dqVK1qkfw1oEsWyHSCSIZDjficrlR3YwM1Nslad9RivwcAuHl5RDDLiCA2pIi33YCkgB01McSJC
 Ee3xWhvM
 8SrucdU02aN+KeVZTfjyVOKlBm8C+gtOsFf+UHx3o1r9Fsl0ozXCDwB6gA2ty61hZ6J38eL7HWdxRxHl0IjZnfEWFIU/988iz9Kd4iqQT0V7no/YtDEQT7oH3frLFmMDqKJKt3D9coP6HjxT6nDDlsdoxeJyCD+JLeOr9ZugGGz/v+F6ivO+GtF7VRz4Sn8OeDc4eyKbr/QQi1bIKkFRsn/Wo/jKJwkd0Gg+YCUQfcfsBtOItHNYL80u02K2XNoB5M1FkaMWwOR5qSfbYVGAF9/REpNcucuLqtjhGi/zN9tCPHDmHy755vjYaPuYBJtbXhJAe4mAUxHEXCzH4m8cB+3HH57ET3jtNQZ/cRombNY1ZYHIuHEVhYCgxD2JlGkbxQVFpyhEjZqNOeq7l+3h8rwgUDyFQWjRrWybwEekUCFPR3Sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates. Constructing the
temporary schemes clears the running schemes' quota state because
damon_new_scheme() initializes the quota passed as a parameter before
copying it to the new scheme. Even an update later rejected with -EINVAL
loses the running quota state.

Initialize the new scheme's copy instead, and add KUnit tests for the
constructor and for accepted and rejected context updates.

In the v1 live test with damo, a scheme with a plain 64 KiB size quota and
a 60-second reset interval uses its quota, and a full "damo tune" with
unchanged parameters then lets it try another 64 KiB within the same
window. With the fix, sz_tried stays at 64 KiB.

KUnit was rerun after the rebase on x86-64 and i386. With only patch 2
applied, the two new tests fail. With the fix, all 46 DAMON KUnit tests
pass on both architectures.

The v1 DAMON selftests showed no new failures (QEMU TCG guest; the
wss_estimation test missed its accuracy bounds with and without the fix).

Changes since v1 [1], following SJ's review [2]:
 - Collect SJ's Reviewed-by for patch 2.
 - Explain the running-context validation in the opening paragraph.
 - Clarify which quota is passed as a parameter and use "commit" for the
   context operation.
 - Point Fixes to commit 60bd24f272d0 ("mm/damon/sysfs: test commit input
   against realistic destination"). Drop the redundant stable version
   comment.
 - Rebase onto mm-new. No changes to the fix or test logic.

The series is based on mm-new at ad8b9fe7a502. On damon/next, patch 2
shares context with the PSI goal test [3] and applies with git am -3.

[1] v1
https://lore.kernel.org/r/20260921003047.12041-1-kmehltretter@gmail.com/

[2] SJ's clarification
https://lore.kernel.org/r/20260922120845.44460-1-sj@kernel.org/

[3] PSI goal tests
https://lore.kernel.org/r/20260921020013.33105-3-kmehltretter@gmail.com/

Karl Mehltretter (2):
  mm/damon/core: preserve the quota passed to damon_new_scheme()
  mm/damon/tests/core-kunit: test preservation of quota state

 mm/damon/core.c             |   6 +-
 mm/damon/tests/core-kunit.h | 107 ++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 3 deletions(-)


base-commit: ad8b9fe7a5021ee745b61d6d33254a69af65efdb
-- 
2.53.0


