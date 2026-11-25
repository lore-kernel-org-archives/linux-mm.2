Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2BF606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b5B+RGOk
Received: by kanga.kvack.org (Postfix)
	id 5D2D16B0AB3; Wed, 25 Nov 2026 14:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9B16B0AB5; Wed, 25 Nov 2026 14:35:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0106B0AB6; Wed, 25 Nov 2026 14:35:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21A9E6B0AB3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:35:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A28A61C4BEC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:49 +0000 (UTC)
X-FDA: 85474646418.26.43F65EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BCBE416000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5B+RGOk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795635347;
	b=S2vMDeip76QsmuYaU/UAVltb6JvNbVwv/y/mAf9gtNWjhCGPs1KSXLBnufwO88qaHRYwpy
	2EWQol1t+T3YfoDp0rNDhN/yTMfo2uh+1ehYhCCoGAegXC2yd2lVctAGjlGJvd/FbKF3eq
	esxXstELMUMzuNXcrCGeqSWQ48wxho4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795635347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dozySOraoRh7tHjX6TfMaOwoErXGfJLcHLqqnn8hwK0=;
	b=nZ3wVtD6czgOjQvx9CznKumX818XfWvEpKy8szWWa2xW2Cdkw46KkDI87S2a/F8STDcR8c
	hjXbKcKWF7ubfnHBL4CExpZf5xm7CS7vxi/XwkSw96g5+y2Xwmb2/UKYQ4MN1gVMOH6nv3
	fyaLb/9iM3T97WUwkhHCb6Ps/TrynOQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5B+RGOk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49F5B623CC;
	Wed, 25 Nov 2026 19:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222D51F000EE;
	Wed, 25 Nov 2026 19:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635346;
	bh=dozySOraoRh7tHjX6TfMaOwoErXGfJLcHLqqnn8hwK0=;
	h=From:Subject:Date:To:Cc;
	b=b5B+RGOkttFdjhnb05MgU12UGmw7AUUPPnCDqyZW+JEuZBtevCOUi/phCy7VKT9ED
	 nOf05pMt6MajS9JdwbvMFhSBVrIJrruhPKZbE/tfx/Mv0zyL5tIzHoTnu5VKAxaqif
	 qBGQT3N84Hmj4SjeRVdD9pvcBiDvqCu1vYFyNuTAf7o1+bT9XwzL40MPW26QeFUm55
	 /ip4fNCDX9evQ8vA8lhDMXmdQ9dg7vjmJh72J7tAO61dfn4sIdsvo85pIljAxeSFIc
	 amuIp9JO/TqIVxOIr6Er9d4FQPbuVE2i2EO2KOPqURv9iTehOALhN8kCTjemvJkXUe
	 P4XXrHN4d9Lmw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 0/3] mm/slab: update the sheaf documentation in
 kmem_cache_args
Date: Wed, 25 Nov 2026 20:35:11 +0100
Message-Id: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG84B2sC/yXMMQ6DMAxA0asgz7WUQBVQr1J1CLFDzAAohqoS4
 u6kML7h/x2Us7DCq9oh81dU5qnAPioIyU8Do1Ax1KZ21toWNbGPSHPAbSG/MvauM+HZkCGKULI
 lc5TftXx/buvWjxzW/weO4wSa8zQkdAAAAA==
X-Change-ID: 20261117-sheaf-doc-update-b680c43d0ddf
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, stable+noautosel@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1468; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=t6Mq6j8OEQxc1F8IgxRwVwsBIQkzVUMpQPtrRwrlp10=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrBzh1ld19dTE9S3u4oa+7NvtVtl3OY9eEG3QUg
 Ae7yLEmQLmJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawc4dQAKCRD6UCkIqsW9
 0ATZD/9ACQM1mxL4rKBnAWXizlVJGajie8C6RmmyNdP3xEhvWal3C5GCq/EseX88nOLAYyos8FA
 g9q1HF+SqulmWOuPd3uYC1tLxDLU4CE+ZkhnPn0CYAH6noQ5nKdpHZlkc6g7+mb3VegPVQTj8/y
 kmVf8vO7vcEiadpW1PkicAnkIbaTbHdTSzjr2OogHs2cyyDkwfkv1nF1vIjRy/UfybPlLTL0eYe
 D6MeBeJkUYCfdtynF4XgX7uPlvzNXW3dUvZREAoqdwf2pkJNAe2YoXCQe5hbpGtk2SkhqVLOQwC
 P/6dChCI4bOJuu4hWE7DQBhvA36jfU466DldFiSINmDeZ6NOpDlV/TlHZ3olZ7xH+OAWbD36RI1
 Xj6dqM1iTk2SYdK3CxAbI+s9PXCD/+1okNJ6+YBNjiqKSJyS3IkiGGf7UqgBR+Cm4OJA1o6ygq+
 xriKmTqsZ9s7zxlC68KwWbmaJvDegI1LLqbZM3WVYDpQSAt54GEmoCl4Wei1wgF/SDgCy+6ceta
 9UcbDmGgoYNVBOir7VqZVP/RZCLqOL+NvdwzR4PpJatBZWdc7Wo0o5MoU4gb7I1E6Eo8N8Tew/G
 PRBvp40p6vCnh+ZzqYnFEecyRRZI0Z3utYKUEx8yLqdhjteJx0TTqPpcAFupXbmxnKMdSblJPNe
 4nuzFSF296Rql3g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCBE416000A
X-Stat-Signature: f8n7zb5mt3cwodfjbwg3k48eeakbps3m
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795635347-409640
X-HE-Meta: U2FsdGVkX1/kGabl3J2+D55SDs+mB4iZ2//8Q/yj2ZqymIyhhnn9O43OrC1UNdaYwMyMERs/HpUx4NfB6DEkRwDHDzoCYY0TqDOp1ExU1UpgYjPiu/nIUtSpRvqFx4bvTAJn5i2wJsg+aqh/SblZ65fjKlkYyYPxyiVvXETr8lWf5aiXVXwKtk5MrISp4Sl83dk0RsqMgChYKad8RAO+TUqRXSPclCCvJmaeZZCwIOHctb57Aw3vvCNxd/QM++FjyiZATjuhA9Lc3n4+0AGvXsZebb0/B73+KsINVu1ZPEpcUJXCyHYsuy8wL5wBGWty7O6p5LSZnd0yWKwiL0/FhcTnLPtWeTcj/5CL5CkFNIZf6v80RlyCmj36rAlYe3LFaJ2F2rHN69DWYrybJCMsv9V3K5EyU0CbyAvhvBbICTEuB7AHqACwLtUl1qwBp6/eafbzavKQemqScyZHhC6ngnlEqno0QzRfEHzAObfi9ivoIkimpPg5IhdnQWNtHua98Dc8oLNIZQAiZwgyE1V56HD4yIh9R0sTBAm+6miueR0PtXruy7n8DAttiK4KQHX4vqc+oxxiPjAc3Cykj6mpLoPHgzC8IdJAi531b5hVMIQ4E0QlP2r1RWuqjXEtoWagKDEKc1VjM+nYp2TheX+nUFtlJ4R2fUxvxuJy5lqCyn1kj1laE+b5OGxjOw6eGDkiyViWPEk7vKMpRYD5FHfMkLTy8MzpdUyQg6+81BkLYRpxYJjy6OcqD09V4Z3mojd2CGOVBDn9Ff/reDKmuzxyyp5fa0StUXkc2RfMY/tMIPqPFqnRYqS599a0dm7KkcKSL2eGWldr00xguHmWp/LN/eDLHgkbBInDYsoJG85nI7MDVwvx/QThfjruu4xMNwmyMVqZpQgc4yWsWTCphuVltSJBb4N63SkK26nozFH7VESX7dAdSHlHHPYvieys1YfPli5/cu0fzxuvYNdGy+K
 dEJM2BiO
 1yph+Hmd+psXH0dIkoze2nFPy4EcJH2ehXXnGqW5GW/+0PoCDFmIfhkIsJODj4P5gXWVcvV36t9C4MO34X8W9ozJsRsQ838cbpuznHhhdlxH+8Xkx6lI9nQchupUgJ2KyTM0QWQ0YDZdzq+yVmJVlJ9RMrnUqf6/0/qLMxppsbkElRyz8yjwuGbnCeLKI/qBlvTbOiYOD6SbUeSX3kbmkLMB2YgqC6evjJVGscGlT8x1o+eTcV3Q+jM3e8TNdAYuUaG+Ak0rFp1IDtVtkRrQ80gPtXm1lgN4SSp118OAVoX8k/w8LbrwZnzzPaZCjan6wqEDuRExRa2OBKqzVu95Xp5H99Rdqe3DgGETmafCXr5YuKxHkdpAgm0TjU07AEIk84ySdDVe6FU9XZCTCHL+xZ6hvGhYXZvnZzdi0RXtOvrYJP6oe4oh8OuTnhFkIMQirBTi+G3Jh4+Q4c66Uzq1elXKUgVG5gQvFFY+hDRW7jOl31sXI3vkPtUsVsCJplRKWp4wea434m283omU6OL+vIzV4c9iUT15eOYZZpjyu4BY4o9tUMORxkGNQxbvbYmZLBAcrAZYrSNIXQL5PWGNvO0lELC0i7Hp/mCN93VHSG7N1DDcIws1Aux/My/Hk3NHusSwF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series is a few documentation updates pertaining to how and when
sheaves are enabled. I discovered the inconsistency handled by patch 1
while discussing the Rust abstractions for sheaves [1]. While working on
patch 1 , my robot assistant found the other two inconsistencies updated by
this series:

- Patch 1 documents sheaf_capacity as a minimum capacity, where zero
  selects the calculated capacity, and lists the cases where no sheaves are
  created.
- Patch 2 drops the statement that refilling a sheaf requires gfp flags
  that allow blocking.
- Patch 3 corrects the description of allocations that request a specific
  NUMA node.

The statement fixed by patch 3 has been stale since v6.18, the ones fixed
by patches 1 and 2 since v7.0.

The series only changes documentation.

[1] https://lore.kernel.org/r/8a73da1c-0167-4aa5-a62c-4190327685cd@kernel.org

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Andreas Hindborg (3):
      mm/slab: update the documentation of sheaf_capacity
      mm/slab: document that sheaf refill does not require blocking
      mm/slab: document that local node allocations can use sheaves

 include/linux/slab.h | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)
---
base-commit: 0b0985aeb9979c5fa5c3b872cecdf97ed4ed2b3e
change-id: 20261117-sheaf-doc-update-b680c43d0ddf

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



