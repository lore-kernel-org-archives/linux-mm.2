Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D182C606D812
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EuKmAoxP
Received: by kanga.kvack.org (Postfix)
	id 49B5F6B05B5; Mon,  2 Nov 2026 19:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46CC06B05B9; Mon,  2 Nov 2026 19:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382A96B05B5; Mon,  2 Nov 2026 19:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 108756B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96C298022C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:53 +0000 (UTC)
X-FDA: 85392000666.25.C466143
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1D844C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EuKmAoxP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667592;
	b=lkinm17rWNZpNxRIW/dPqlFwulymgVR1wfLay1pP0xxB9Yhz4/2j0iLe+DJ+nvJqNyOuuE
	f6vyTtyqqeFYD87ZwEBQ8jgc7u+wCsDGr6KaHOvx2EavMx/aeVi6DayyIHNXHSHYIn56AI
	/y3lfdrXPxns+Y2/KmDixHPGOyQRDgE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iRmnLuflCl7MrpW9F1BaNAFdZpZANiW6H3XK0CDxEM=;
	b=tme+xe+MO8jhp413t9mLu7fwoV1GaaHe/I27IlUdY2Og1rQRvWqpgUk9y7X7WfQLGE95iH
	pzSTNUsR0GQDnoWJnUN8VrMuFJaUnPL5gr+r8Uw9+5ixhIsyPaRPxDgmRjUWt6FbAZJXTY
	CpDfEJiGWUO0NGjgct0E5Wh/1P3X2oo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EuKmAoxP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B78EE605EF;
	Tue,  3 Nov 2026 00:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E701F00A17;
	Tue,  3 Nov 2026 00:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667591;
	bh=6iRmnLuflCl7MrpW9F1BaNAFdZpZANiW6H3XK0CDxEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuKmAoxPUZd1e7NVeSBwZx2Whlycgt1C3G4NUbXqptUWAcrd6tI393dYDWQ5NQPbv
	 HCbaS/JDXyVh6fE+bZREr2FwtnXUCh09Gk0HJXKoCGbkbAy5mwAaGONKY7VscihMzh
	 iJJ4UfOovxiwJ1k8g+HmWt5EunQy0yjhx1oaYYotm3ozcOQtVQqTHOUAqMNHmS36Oa
	 /dSHq86YJ2xk9xwuGXD/+w/bo8SRDanqnZ5s4D3GhVVytqd1AvX73HAhlGNi+0jNWb
	 aq+LkQui7L8doXVYbxcCQ/6dpkmVIFBN3c1WMetDaA02IqrTsZg74ToWpLl1HdSkhC
	 lvAx7YSg9NUWQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 6/8] Docs/mm/damon/api: fix verb form
Date: Mon,  2 Nov 2026 16:59:36 -0800
Message-ID: <20261103005940.91432-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103005940.91432-1-sj@kernel.org>
References: <20261103005940.91432-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: 87dihwupzyky4m48fsspi7f8fkrw1qj1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1D844C0005
X-HE-Tag: 1793667591-256382
X-HE-Meta: U2FsdGVkX1/lyeX97UUCkWv1BhENARoFcSjXkr2FK3poflpnqcsRNNf/B/Q67SkxGU8ubFMEH0aJ3NTvIqzXvaoqGZsSrgE4qEVER+uebklhZ4zOg2UvHDdDdUMel4BU+1rr2eHmYn6GIxhKRAT85aa7BW5qry53QJPhN5zrCmyGF7Benl2ZcGcAIl/Y3Pb/W9RBJXjtiR3/JhMFPBv+f0M4g0k5D7tj6l++fClzMf+CjE1RT6C51p+hFUnlkceWw5Vbk2i/Dlep8BvRv1+Zimsosxdbo2cvuo3K/ASeQ+sURX2rAhW1mxhVrndVUXR8PtN4XEB3k/5W6ii+ZXU2nuT9kr8AHWshsAk2lWqPinT0jWsU0VuNnCVG7DJCfLrwI5Dm2XEbpP62mKIKPx7rN/uOqvLc6OFeYyIJIYm3HUzCk+SQwbtilKASszCXJzUhfk9Pih+TKxC6CUCxsl66cjkP8LU3cNjIYwA+3oZOtqVxhopz+Wj6vkfEDOCGucSbX3eIaOSd2oDIGGrhTpo+9+T2nFJ0UI8gk8Llxqp1a3ns8nLkkoFnD9GuJ7F9AkgpPuTxk05pSIJHX541tZXz5hH82vBioCdnaEHuAr8Ak2UrjRvp2+WKZlAq0YE2VqPwiOUGtc9S/a/s/05ET2SMv0lM+nMGHToLq6sIDpK2kEATYOf959gMMMl7jaQb7v3Xodv6hEy+q5t/oxnZNplx0xqfhBEG9i++rrAijmipkXoa3pydQp3L/4vYZPBJiZ2TUNjqBM4xLXsfCQnfp90VBXIginbZfdPoreOZJQ9S8GlHIv9tLGERBb61p2YY3cbYedr3GECcHG/EytCnH3R4eWNuJYmI2OPlhwaMNYlDbHG3W4tXfpGd0WqSD/CP4i8Be62Cpo4u7QhMsG+iNtKz8niHRBn4PWlCf0zB+SKGIo3p6VFdCpAjsef75ErnrolKKPLsh8NYQRPPFULDJiO
 qzjIJ9iE
 eu7vvM/IJ7K6Je/TdEQfB5/2+HwIHiq2N5gP2RxuhHkMXcpqEKagZ99RX/lSWD6Qwyxjei5JKHN0vTLkNzBoW6rXXdE/YgKPRyeEbdszjP+te5IQ2Q9pOlcsKmkip+XYYCXlMfC6GpxhzILlvkvubXTRuWtcAO0HeGEvyzttMiAZRiIOskUT18tnsHKw8zCfm83vuKe5hYzf3zqCWeSpczpw90QcViEZF4LRiR1gqXI4g5nYJGxhDs/A4MZHw3EO2jvw4DEA3ZA9DKnGI8UGGBYWXEUJZhHRKikwZLvdHJq2rRjXteA54HvknywJbERPTOEPVXriQq5+MRcgJn/2Iet2C6BppSa1ig+KxxoMWq0ImS+ppEyagiP4u9rvk7zcBeZXPX26MlgSKaCArdKGyxCCrS2RHruFw/FdPxil6mHx1HAoK21PLy0S9ozUHKER5aUhtCVsgjzagFJk1td8SByCwI6Apv9H9n22MynLAO9/TSJG/l1i/IjWctHTHtD0LpGKa5uo4/+rdW9paVlR8gaMIc4DV4L1k1XL+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

It should be "All you need to do is include", not "including".

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/api.rst b/Documentation/mm/damon/api.rst
index 08f34df45523a..1f330429b486c 100644
--- a/Documentation/mm/damon/api.rst
+++ b/Documentation/mm/damon/api.rst
@@ -5,7 +5,7 @@ API Reference
 =============
 
 Kernel space programs can use every feature of DAMON using below APIs.  All you
-need to do is including ``damon.h``, which is located in ``include/linux/`` of
+need to do is include ``damon.h``, which is located in ``include/linux/`` of
 the source tree.
 
 Structures
-- 
2.47.3

