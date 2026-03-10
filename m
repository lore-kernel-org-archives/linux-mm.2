Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 851D6FCC9A5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CCF6B0093; Mon,  9 Mar 2026 21:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A8D6B0095; Mon,  9 Mar 2026 21:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3ADA6B0098; Mon,  9 Mar 2026 21:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8481F6B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39D9258767
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:43 +0000 (UTC)
X-FDA: 84528360966.17.8EC1EF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D57C4000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gBwjHDJb;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtMbNh3H86JFY8kZ/Eo+JjcntGif4NW9YtzRYc8lQGU=;
	b=BeD/KPMyPK2yY7Xku1qOvzd4aLgEYmcT2kBCpnDs+mBD+3vPb1M0/ay1Q/2mHnPDDUSwyv
	hDPhk/GgkUWb9I8cLip37Maj35MmrDM/5Ljf3z1kZQsIbrTyKA8lIQQpe+lfb/iUM92LPf
	lRiuBEmf6hcEez5VCg0cPndwF8A+Rh8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gBwjHDJb;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104741; a=rsa-sha256;
	cv=none;
	b=i1ILIUB21JDAwQd6M5DFUXdcasgDzwIX06INVQEdsdEnWcYi7x5egiRp16YtsRIgq1+iau
	QOjWgUGIZQ+BaS8PkGCYx4BLf3K+fPHS9I2OtLJZ6py0fT08/5+9fwUZvXHNpIl0io4okX
	+ZFuyFD9H+awlK4j8TqakHtPM+RZRdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83C1E43C5B;
	Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F16C2BCB0;
	Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104740;
	bh=8g5RM84PzzTOH9XhkrAPhPyfvWGkJhpn6rsV5ukGTjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBwjHDJb5FNMs4+6fg//+BneuH8gokx0udvi/q2s3S9GwqombT+uPVubEw41mquHE
	 UuxckTAdvSweLAQLwEUFz5Ryfw6r0J3YtrYe6dR3C9GSzp1EbGMaTIBNtKUS90y/wa
	 /X4w8R210/TNxc1imAGaUtgPWt4VkMELhjnNx+spUf/N0CWxP5mez3pGE7o63VHpsx
	 TQRXaUY2jRdnYMoNYStNFqNCI2bRb5vQteR3qBhrUoHXnQdoh/CK8yY7lnAaJy2PAn
	 p1G9XxX2JdLXPjRQoFBxyurqvS9jXtpTn+gXn4EhdDl5cLfyWweNFv1TOEY7c7iHM/
	 3/l4Cc3Avg+NA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/11] Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
Date: Mon,  9 Mar 2026 18:05:22 -0700
Message-ID: <20260310010529.91162-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t8kqyfhj9gscbqecfnotodaocpjr5ucz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D57C4000F
X-HE-Tag: 1773104741-226504
X-HE-Meta: U2FsdGVkX1/aULtNnlK/E/BF1X8P5Nz5o3Yw2Ifp5LtHtHnjXCxNz/P/hKmRZTTm0F15yCSrt00CxYJNN06wX+pi/N/iG4ZYWEnSMrBCI8x6CyrEAszGhTF5G5LRGbPiNj0UJhVS3oPXDhls8aAMvX4B6v3Ish9PcCQKhfbkbONx4y94pm29bZUwlyKzMcmIVNehXjhlwHeT1r/q+/gT+lDgjbpEIusiH5qjEoJPgCeGAHSLGEH6Yz0wrlaNVvd1O+jAZzrTFnThFdT2t8Td99z+2O2LAArjk7B9c7k5Ud6WsqBzvoq3bBN0L3Yx1RYwKk/zBKGwTTAulmyS5cRA+1ScYp31EcGV26RDKsTtlaiT2Wq9CnWEx6S3sGMa+b32+sqvTRkYiETj8Ml88oOsc/vvacQ0ccU55vdvBNXpU1qWI8lZR3xkAP+4XL66XZa9hNJxTNNhhfG1LjUAUG+CbaguwEj9cAsQ1u2dtkUHYoail13QTqYdvraBJKf2M57C6Tft8u6d3KdYFF4r+Sd3vwqXcm3x0qUi+W+5d9T2C/tbQww4CIeSQWmoXbNDk9+mhOvdWejzNnpP6rkhld4SiAFhMSVlLtLt+MfVAtwh6eWzXkr1PiLypdQrkzoZVdluNWd/p2puh6CA4z3sNcT5iyWbeKRtE28ebNidd1gxZ4ohY/vgPFnaAsWaqBqVHWXOVLD6U4ZA0Woc+DBtO6xoIQZdH96+iSMrvkrBpQ+wmLaHknRzVU9x2n1jDjNdfJUCWk6fDZ9Qnh4poFdNQ0mt7t9Z7/KJBJLqiMNKSfspStqX18T7LVRpkiiVU28asGKFu8XbNB4jk5BK2uVIe1vRHxcfn8ipaMbWLSQXzfq7rMsEhd+8SUrMdQerYohTWTuvAEroTZNDOd5T0MAgNOVMk4qT5YgNB6iSiDivbPd5DrFlS4r+1rVodfqDjzni+DkXVfhsQ/vk8MgZEjTDfv/
 qqDflTnJ
 AKZJ/P0xC/b2HhLL6ddOJaXxZT3aYUHR91Y69ZBe4wx/c8WQq/JvmU7LymOIxvvoMJZY7ijCOEg+FJ1YBzCRtngIfW7p5cNEQgIzROYUBkgM/jTYJVk3g4XdB3RQF4ji3RyajXdPD4JW2aXZtYdHtNofELZSxnh9ArCveuM5DnBJXCjDdXz3Em7kWOYCWIWT2Ti5FQ/UFipqxnBUk/PZUwrzOU8yCg3azrGqZnkSc/C4noqOE4e8s0YhjSijkAr+1PNudWnjouG3+Uf1bujIMpUwzcJU9INNgMEQcelUzFReCPB+ij1mr+VI5rQYcZYwpa3Qx1NtJvHcH2N643JX2SLzoli2syGoTOqVphHcwMNFzU9sgRLglnjFCOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the DAMON usage document for the new sysfs file for the goal
based quota auto-tuning algorithm selection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index b0f3969b6b3b1..534e1199cf091 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -377,9 +377,9 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, four files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes``) and two directories (``weights`` and
-``goals``) exist.
+Under ``quotas`` directory, five files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
+directories (``weights`` and ``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -390,6 +390,14 @@ apply the action to only up to ``bytes`` bytes of memory regions within the
 quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
 set.
 
+You can set the goal-based effective quota auto-tuning algorithm to use, by
+writing the algorithm name to ``goal_tuner`` file.  Reading the file returns
+the currently selected tuner algorithm.  Refer to the design documentation of
+:ref:`automatic quota tuning goals <damon_design_damos_quotas_auto_tuning>` for
+the background design of the feature and the name of the selectable algorithms.
+Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
+setup.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
-- 
2.47.3

