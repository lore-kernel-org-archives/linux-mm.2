Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0478AFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813DF6B0095; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4F06B0096; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9B46B0099; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 553C46B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 184D7120340
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
X-FDA: 84706244868.12.4A37685
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 815B0C000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eRybFt+i;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTSjVLYPguBmCdyYoU8/p+4xBT6J/c20Yd4o4tKZLuM=;
	b=z4DnqGqdTdfOUwDdDxMkJmsj03+z+EcFGN6Nbyo7Rp/12Xv19TW70WAUiNOoTiL5APHFMJ
	2t43nDQHwUzR0yg5w3uHzNzgBqaq5svAdHzGs5ONvjEZ3estTjZZCxyzUpuieXLmMn6Agu
	07DeLdnLeZycszXF2jxlJzo8UM2teJM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eRybFt+i;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340072; a=rsa-sha256;
	cv=none;
	b=d8ojIFZkQOMVauzLgL1o3kOUQxeKquJ9nqz2IvMmx6+0UN9GZ5N785uoP2AY29ryU6PmOF
	2FEE6AYThTUVO8X2THDYDYUAMeH+QeiN8sbs4d2GJUhcyxlv+99nzUocCT8eo/yWgjDj/1
	MNLcRbsLUkc99mhAGulyKr7e3Zk49TI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F173260181;
	Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CB6C2BCB7;
	Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340071;
	bh=x42u0yyujS0MNNJ5zIzlJ5WzcqjchBB5xjDhcoIlpNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRybFt+iabvl4JrFNGv5dY/wGWUCCwzlEEXQfKsMxsxrjea++yxvDR5XF/u7ItIK2
	 35B80+wBa+TSMM55i0ITO+dRZe3C+noXe0rY/avkO7Iu3UHGjA/N8LMvuTN3edUtme
	 tlc6oZAO9Sts5ivM85kHYH8EjfZSdq+kLTAC1hdaySyumzvR6sF/jOSmVv/jfOnA0N
	 7+W8JJqt1XI9HLfntRLLiKfhFinQNcNVicI/r8wNcxnyysXWXJhGFgkeZoShpw/uej
	 rfAK1I8xSUTD/18PKOnSNwrjSd49U2sel/eLfPrBXl29Enh9AeWFckvmPMznQvbSmA
	 OIoRm3UgAu+Qg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 05/11] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Mon, 27 Apr 2026 18:33:54 -0700
Message-ID: <20260428013402.115171-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 815B0C000E
X-Stat-Signature: dasu5rx4o9w5tgo84usj3446euuk481e
X-HE-Tag: 1777340072-876998
X-HE-Meta: U2FsdGVkX19bnaxoRvqhwg0DqcNXhaIA3mFnJZu/gtIBbKnV5TmyARv9wRH4EwzJQB+NkP8KrFDmVq6Ipfzr0MbEFty5ore8O2du9orxG42PXHDpbJ06WVQXitIl2Y8vWQyLAoVrQIbXu29kq0FaS7Pu/r7m5zfoEwAmKrlVr5S9QRof+KNJZodTNnk/8SuwLVTJe1wveqrXjP3qBgLPXzxn0iV/13/VaOQYTsWRchu2MhOUOQOThdCf2E5b/xpaTZscOwXRCZtmg69vSipKyZKhQ5tlaAnuS1GxLixW+tJFDYOzq+p8GRqK1dtTVR2TKBQtz7Yrj6fNjtT5ZxQzeMKOqHIJTfcrPARhX95/afWop5tyG+z1/54XPi2CZBW1Zt7g35p8RiokESiwtjYFSIvbcFg09+gMtPqiTSpLoLKvHq7EqKtryip8Vk7RQR840R4Br02ZJJoM0I1mussVu7esznXBuB9SWv1KS9DqEsJNk8wXmN3f7PhLvycjrOhb/mkFd2BNUkFnpNGBlltQG3NqaPLjL3ZzhlOURn00CW/+fpQlx1xxKu+QleaavZvUJElaU2FKHi8Sb3pdBKUd+J+YXkcWqB9HpPgLJtFrMkKvHDu3A9EXN38vqAvtMPaZ4NqkGJ1MB86ry56b9Urxb6u9j4eLhM8BgvP4ELVKgoC/wl6UbP5pZX9UuakVNy3KrbE9IUjy/AldfhR4s5qxIYKJzwAhh56CJksxBcoIz4NwahRceQOAIrYRomUrXkgKywxx93g2SW/l4W3qD2ghBQTeGo5lRNJFWDKGYxMofX3ehe4R6g3a9YXB/fvAdSGWWdcZeIKbJwW5T2YaK6YQRSBv9MK8KHC9OmOtD45Qnopk/d1H8bstZXRjT3xQk7Ifg9PH0oPhvms5yVqH2k1DvMTVmIl6pVh5uLZLSRSuJD3fFGgMQUiZZyEdjeyMBS7A9TxE4QgZcS/ntJYMoKn
 c+STYH8V
 fr7pSDg49FAkoXMGXpHWSWvmw1YNDDsSFar0ZfhiWmT2yWhfxdaednVBOAv7j/wp8AbEzkuMMQUb5plqTct0f440MpDq1rxyhyBZ1O61mYsemZSZmYmV9+UqQzPssn2BAQ/obtZEC79510rdYpXRK1h+9ugDyKwTqrkU4+EwQtMFxWjvyn7oPsDc/dZ0hlls/mW0kOPUVSLHHHfnPR8PDbDStT/E6zCMBeZEdK286P3AgbcRhAW9x4wgsxEwr4YxK0fg3mu6iYqZo+Gu+YLRfll6dlBhE8bP+dIRn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 622d24e35961e..fa7392b5a331d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -576,6 +576,28 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for some subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.  The
+feature is enabled only if ``fail_charge_denom`` is not zero.
+
+For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
+size.  The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

