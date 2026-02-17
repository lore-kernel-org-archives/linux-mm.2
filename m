Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B7DE83844
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC8C6B008A; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F116B0095; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24DFC6B008A; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2A0A6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:04:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82D331B5622
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:18 +0000 (UTC)
X-FDA: 84452001396.14.CF887AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DB96C80019
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uUP1y+fp;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771286657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wLdOKIPgAXW+q4FHsk2uD3pcBsvghNe55xWnonLQKLg=;
	b=zkfun5XmFylu4YxR56TKU8kDg8NSbk/vpIMePuV3jzKkpjauJfmZNNeLyE+Gey47o7eawY
	AayZG5SvGxToFdFywzcj+jR5NEKtV/nd9kBLiwm0UCt+qeSW7Yia8MoB/qGpLiShQANATm
	/VOmU4Qbv8yhKrG5vjBJwfG8s3XtT3w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uUP1y+fp;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771286657; a=rsa-sha256;
	cv=none;
	b=f42v83tViLjHa6teKKi+F4xCoOEKhAO32u9DqO02mnKx7vVbTIqNSvi4utHp6r9EtXMnAn
	MFr7A7sRWoHLoz33qyc2QLHHputne0E0ilpy/CEyiRtDJY2zl+TgTKbZdaiALXpGJ6493f
	CEn9FDB4ZhG8pFdnFrgoKepKcSKuMTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 964DF4097B;
	Tue, 17 Feb 2026 00:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447B5C116C6;
	Tue, 17 Feb 2026 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771286655;
	bh=twrQwH1bkpvsVozV0dRxg/jGZq3IRMqY/FRfwyIRdm0=;
	h=From:To:Cc:Subject:Date:From;
	b=uUP1y+fppjXoA5BxJzcb7hGC5Hq+CC+SYIlkkw9j0jDzDGZ4WYzgTkUEU0KLNly4d
	 m3fDW1xXRzLNLrBU04JG0rWEqOGk31ya3yZ9w6dVG9yD9d8EpbeLmi4mvlTY/UC317
	 vMAc7mjDc/V3WujOaCRYjJ+e6sgnR3LC4t4EGJUIZpkTOtIUi7sfuNEGk/4QSTQr68
	 tYj4Uk392olIM2g/iOIfRsrQkNA649wH7LZnw8sJsvAIVnrqoJOFTzN7XQEFVOx7m2
	 kYf1dbtfH4yxSKg6NIi8Kl7KI7yAsvndK1/kJgZwgCPenRE+W/gHAdfb8r9T7cAG43
	 n5RoaWHyXvySg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/3] mm/damon: always respect min_nr_regions from the beginning
Date: Mon, 16 Feb 2026 16:03:55 -0800
Message-ID: <20260217000400.69056-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 37qenbs8kc3nnng6noe5x7nx1d774m9d
X-Rspamd-Queue-Id: DB96C80019
X-Rspam-User: 
X-HE-Tag: 1771286656-718859
X-HE-Meta: U2FsdGVkX1/YZz3A7c8W+kF55p74BV2biOIVoOy77a8DFZvCa4T5Q5/w9Zp3W6G+05GPpAN87ye9kzDX0NMNCWASBb5nNeC1VBPr5qF0lIfCU4fjWUup5Lw3I+fLrjIYhJrHJFUU9fzaVMF0bLns2ifvQd+YnesP7abtL0/vqhF7oNYI+wazHS4R7d2EnrjyEu/fDLZMOtIvDVI4w5iB/hwvMMl4uQu9ZWb6Zrp+qEAGFCgtsN0TNHhSgh9m5EqOzCiwmkeFx0Gcxs5A/DntTG0pSqKEIeYs7CSgfdDukmd79BTv/e0QTe1B7gZJmVOU/xK/Ag5uJLQvPLqn2mf9NR/GwapAhJviUGXLyc0TD4k/vbX8iWx2xrcpTv2T+lUXLjeUtYNlaGu/yHo2E7BemO/QxZbE0qTp0F3pHfmN/Ri+o8nrWkXJWrdvbQhgpQbyQNGtKwHNsuTjy791iKGgncmFVwdwjjzdxcVLbWtcVvvUaEmEJyCgdoYUSyBOVdHcpG3qeKPP8gTT4Ft1lRpTAbS3NmUdv+GDFPjh1Q5q3Dh8rxiOMaw07JHuht+yG0+u7waLENvdKOzlwqpwAn/BAoTAlNshv3EQZTqx7wWGKV953tVDXyBU6AZkJoneYqvxIPATpa/Jn4Ef+Kyvy4MVCWT2MPth8WW6q6jmGH3bOHGiQUTeTpivMGdU3nWkuIYps6T1U7CLSr9HmbLrHsnJoh7rfOfjW+xPtoJKSFRaPFNRbTMvfo/cMVMjN6aV9LlDeGatrly9WZtk16wuTfLZZgtSxH00e0bnpHGCgsgBvE7GT75yTAW+WxmY4tCJDX68gt/keN+DQiVMFiJf2RDT0XQM0VhlpdrtmEzyY7P2N1X9K5TqYboSdhhMhMobCg3nKqZqHdVtK1tYbPOze8TMaocGZBofqGd3YbcMT/N5uZlowjgHOyW0hVu4nfaHFw8aDq9BbtBaX1sRIe/7l1S
 VtfDJ69L
 +XOEOCm+DdIwSGexTK4HEI0mi9Zx5xJoanw7hK8OJ0+hH904pB+1341byVNT0BZbCizU7Kp1/dmY6/qlJ4wWFxcHASwkWRVC/ZBhhR6tZLisn2NZmKDe82wx/o7tzlNj+4cCAIFII5kbXeL1fjCJEhFNmY4f3+m4mDdvgaZcLLSpqv2iv22RSYh6OojVbNkoc3Ba6lP+FOHJCMP7+9t5QcixUgT28cXRMzxd103YUTQzwuYuSNM+ApvYtf0kzksBJ7ZIcB2fw6roNB3Ls2vLz0GjhpnNYJNRb6md5dBVXOj6r9MI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core assumes min_nr_regions parameter is respected by initial user
setup or the underlying operation set.  That is, users are supposed to
set up the initial monitoring regions to have more than min_nr_regions
regions.  When the virtual address operation set (vaddr) is used, users
can ask vaddr to do the setup entirely.  For the case, vaddr finds
regions for covering the current virtual address mappings, and split
regions to meet the min_nr_regions.  DAMON core therefore does nothing
for min_nr_regions at the beginning, and only avoids the number becoming
lower than min_nr_regions, by preventing regions merge operations when
needed.

The user setup requirement is somewhat too much, however, when the
min_nr_regions value is high.  Actually there was a report [1] of the
case.  Make below three changes for resolving the issue.

First (patch 1), drop the assumption and make DAMON core split regions
at the beginning for respecting the min_nr_regions.  Second (patch 2),
drop the vaddr's split operations and related code that are no more
needed.  Third (patch 3), add kunit test for the newly introduced
function.

[1] https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com

SeongJae Park (3):
  mm/damon/core: split regions for min_nr_regions at beginning
  mm/damon/vaddr: do not split regions for min_nr_regions
  mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test

 mm/damon/core.c              | 39 ++++++++++++++++--
 mm/damon/tests/core-kunit.h  | 52 ++++++++++++++++++++++++
 mm/damon/tests/vaddr-kunit.h | 76 ------------------------------------
 mm/damon/vaddr.c             | 70 +--------------------------------
 4 files changed, 89 insertions(+), 148 deletions(-)


base-commit: b2e07b9d93a9696f78fb21f2260d5798c6040b28
-- 
2.47.3

