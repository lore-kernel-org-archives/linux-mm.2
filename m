Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE412606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZoQr7SUV
Received: by kanga.kvack.org (Postfix)
	id E22C96B079F; Tue, 24 Nov 2026 11:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8F86B07A1; Tue, 24 Nov 2026 11:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EA26B07A2; Tue, 24 Nov 2026 11:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF3296B079F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:01:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A7B640C48
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:45 +0000 (UTC)
X-FDA: 85470478170.01.C477F49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D28840006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoQr7SUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795536103;
	b=hpzl1B/fPexf/1ylv4V00tPIwNvRoJOBMNzs9bhyBJr7zG9T47sCNJYJ3eQPRMstqAKEzI
	IuO/wkmGtEkUjdd6olCMA4fVRo1jpPE1xTvA+ixCUV+i+hPyPIoY5aDapeEycF/DweYZre
	dd3OlZ1JXAOHu0XDdeyEpVm9ta+bPdQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mWj74VB0kUOTyAfecmTtKijm9c/bCkxbRVrYTWR0WM=;
	b=vXJoayXa/WxT3IsO0PIsHt/67Nbyh0BegzzCONVwLGLRQWpHHrw4Eu2MVHGSsZvvDUDmue
	V4QTHAdLtWU9KlCREl8Z6Kuu+svqKuwjOH0yT2g3TCuTirspdCYgIU4zWevUlCqyCWwAfu
	NTpc2FB+cCKDaecpdLg+D1A3d79CjGs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoQr7SUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4EC862753;
	Tue, 24 Nov 2026 16:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83CA1F000D0;
	Tue, 24 Nov 2026 16:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536102;
	bh=9mWj74VB0kUOTyAfecmTtKijm9c/bCkxbRVrYTWR0WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoQr7SUVcRQap2yuBvwxxP4A34h6k+ANMkLkPjL5sA2i6pfnV13DEyi5+Ss5PLYDD
	 0GNC0XD7zsu4nTh7zUHwtTAo8axJhTRADXECfqbXMWAPyS8Wr0NjBsjTAYeaBd26er
	 9YHRorqiAzHtdO1RtRjfoCE/aLkdtJr3KnGQhIF5ksN1lM9zYRVirAS8x7INfdp28w
	 V3FuwQoiR0j2Y56JkNaV5xgeefwk2CTvUTR4a45EenvTEM1R6oCi00lwCZtGl9EdIo
	 eiCk5S/jLrKFHZM/0wWSxpHCT/of3pcq5mWnUwo7BS65fqCgct/sElpSl+x2kkaW7f
	 coGoeL1iVXWcw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new 2/4] Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
Date: Tue, 24 Nov 2026 08:01:20 -0800
Message-ID: <20261124160124.93482-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124160124.93482-1-sj@kernel.org>
References: <20261124160124.93482-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6k6cionc1kugh3ntjjrf69ei1dco5nin
X-Rspam-User:
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6D28840006
X-Rspamd-Server: rspam03
X-HE-Tag: 1795536103-43973
X-HE-Meta: U2FsdGVkX18rYsz4dwVzsygMQ02G1rxTqDpQPkKEOklO0O2M+WZT9NCJjcy3KO+G05HlsG8I0BhQHfw7wFajnsNp8CykpT+0Muqes8M47M4rXShxRayR1qwXW+In8m3Jm47x868i5k98hy32gk37tRr2N98rdiu67yI2GQF/Hd0Uft60GCzt3SjC9VhRUUVDcaotE12/COG8KaK6m4fNECh8ARVbKs35JsJFa4NHb/uJm6c7mLHdG5g61DzSiSHi2Ptum8FeouyzVd7p522oWaAFs32B8T6rSvrUnPk5u5FQA76yTO9HB2XMSSFwlR7XBfhDTgxgV5XxOwZwLmiseJj1DIrsJDJ9RMmNqSf7w4XKoaArAuyETetOwJhSzaUQ3iMkKwTMZpYfXKkjwAMpH73AJHKLwZ36BB5i/pyOkxZrS1iWQQPtPuXfq7qtP5lpsfGmguFKir0MT2GLIzCFy1z4ac4MdTU2yWoDsgvrjDMmPYGoQXDp+EbPUPgKnM1prK2jrWdhhjzLdiCe3Hj22HKdHYmziHVJTIQ90WKT0y6LONYungOIZRmIREHYjTCqbyoM028Ylkg/VmrMyS6wXo4XSsE7DmagWLlplpWt1eZCryL9EpoA3uf6SGFXDAo4pfixDMj5EC2bRNML0Zzd+adjqKn2cV7GAWSLye0noXg3RkBdseirbMS0UO9DnBqOlAqrqvYSz1nwE+SLntuwKkc3Cq4gtwo0GPgPX6L98gMxBDT2TXVQIiZB6F8/DPt5UZCii+ingeS9lV/PYznoVTyIdaH6NaaN9eSIn034N1m15o9qOaaSqmc4e++nH/Ok0tiz4fUVd0djeURokDAj2Qg6JDMriWHQh2NjKAdGRc30lsUCDQRR84a7y6h5hnKPfF3jKRVlRegQZnL4OVfy9taNOmQoGW38102GjwWVrSo97r3BfSThe6qXvU3TWs1l+leI5Znu9QYFHZyBr7R
 mGzxGjNO
 3CsdHLFMAg+EkClnBMI2qTywONAq7feZ1GiMmGeIT+cr5wOnSXWRGtj9EKyQG+uMywHaAIH+yrpzG/FLva/VW7j8J2d/VJul/d2elMECd2tzQmbet4f3vYn2g31mPvVoWO75guWLLhpM0YlfofMIsbgpcH4sfyBLgUlgHCioQ5wFOdHAc09NnRx5Lvi0Smuq5VHPlhtwSM9u3/43xZ6iy8uZP+9CTlCwhxIZqM/H6/kOtorXWL2JRGH0Fwm/taL12YLbwdFquakU/diKgkGSeR/s4tO2iknrRnRQF0oSEATZVJCKD3oQbcpQTFpLvJ+6unPi+Ld6l0UJxi2fc7QlsL4rZDb1ukoCBWmIjS5NT2N58J5FKDjJ9JAjFY1hs/o6xufGRW7Rox83xwZcjS/NvZ4NpUfE0Oiyud0GOVsbtGIDe19RCJCLw0gbu5URjUNYnaaD2yDHhExhba9N2MlH5B+Bkje2TacRbKCaLkRY/zHdvmy3kz+pYSS0MFvL0efxyJ3e0VkESzpsKXeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].
Update DAMON maintainer-profile document to suggest using damon.git [2]
for-next and for-next-fixes trees as baselines, following the mm-next
process guideline.  Together, update the DAMON section name to match
that on the MAINTAINERS file.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index c482690320249..cc6b79c066a64 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -3,13 +3,20 @@
 DAMON Maintainer Entry Profile
 ==============================
 
-The DAMON subsystem covers the files that are listed in 'DAMON' section of
-'MAINTAINERS' file.
+The DAMON subsystem covers the files that are listed in 'MEMORY MANAGEMENT -
+DAMON' section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
-linux-mm@kvack.org.  Patches should be made against the `mm-new tree
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ whenever possible and posted to the
-mailing lists.
+linux-mm@kvack.org.
+
+Non-urgent patches should be made against the damon.git `for-next
+<https://git.kernel.org/mm/damon/h/for-next>`_ tree.  Urgent patches should be
+made against the damon.git `for-next-fixes
+<https://git.kernel.org/mm/damon/h/for-next-fixes>`_ tree.  If there is a
+reason to not use those branches as the baseline of the patch, please explain
+the reason and what baseline is used.
+
+Patches should be posted to the mailing lists whenever possible.
 
 SCM Trees
 ---------
-- 
2.47.3

