Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F47A606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/aG3jxE
Received: by kanga.kvack.org (Postfix)
	id 43D646B05B2; Sat, 24 Oct 2026 15:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7206B05B3; Sat, 24 Oct 2026 15:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6C26B05B4; Sat, 24 Oct 2026 15:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02B5C6B05B2
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:34:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7342FC041F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:34:01 +0000 (UTC)
X-FDA: 85358520282.23.99E8EEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id F2164180003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:33:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/aG3jxE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792870440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B+9LPpeyWJrESAgg+ZQjlbIQ+zZneFd2FYznRyvKzQ8=;
	b=pmyEi8zXF/4uY7zH2mGow6Qyn9Mw0xV+zh9tfk8DLCapMLNawzw0Zs2s2PrqPmgFaa/hlZ
	lOwQfDFVIcVM0LLXwcbkLbDgBrIh23ssKNick/YP0GyvJs3LfjZalT6bpxL27mogyT7Dnl
	PvPZsIp2dMtP5JrJBMu13N5nqFR2qu8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i/aG3jxE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792870440;
	b=yB1V6ubddYvlPxBX8mAqMp3YFE46w+EPlU2NHH2WPQf1Lj9TRU6tAyWxdWHjXAICEyKkUV
	FlZytA11c0c6f79j3BDV4dv653LsOWjHDpfx8yEYL4ezGG1kNMRqpsOyD9y3WVuShH3UZl
	r+sxopr4BKXKrTlHaAM2WPDkRRnJOiw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 615F1601DE;
	Sat, 24 Oct 2026 19:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15F01F01825;
	Sat, 24 Oct 2026 19:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792870439;
	bh=B+9LPpeyWJrESAgg+ZQjlbIQ+zZneFd2FYznRyvKzQ8=;
	h=From:To:Cc:Subject:Date;
	b=i/aG3jxEddkj7xtQ9f3WYVMpUdNeqlPxwj4ciVD5BchuvceGln2DXw8sx1RReEiFR
	 yUVmEz/gLrY0iuGzOCzT4ZOJT0370ye3AB8krrxnKd1wmKG1YW4DrpbEPlesZhv3gf
	 y5buFfvDheBg474TrlT/ICDVbdESfWutV7RXpmfqvU1t/wAp+HSLivn9EOu7N+z0S1
	 ABLrHwhEMrzZLab5gnwJDJ6x81N/vjKB0x6VwpDFANxz0cRUq32O4u92UzI5ARUJ8a
	 Yp/czdUdLef0U0qPRlP+nfgwhdj3z14nxxu1b8/M4Gugutxah8A+1MBS8RxE0UYQ4e
	 AbWFYk7IdHHKQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/3] mm/damon: fix three race bugs in sysfs and core
Date: Sat, 24 Oct 2026 12:33:46 -0700
Message-ID: <20261024193351.87130-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2164180003
X-Stat-Signature: 6u3n3uew7cdr55q3jhiu5ixit7f3surq
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792870439-59686
X-HE-Meta: U2FsdGVkX1903YuPqSMYI5Fi9592U7CdtlsIX2bmCWEKklWmZGqmyjQj2lEnyPMoo8tY0zyLoFsA7f7Whft+ltfLdf5smtKQ/91upwuA8JAejJg9wEL2pbaZ146yVTm3Po/3sGSmacR04THfOfbh91KIJKPQpIWGVh3+NND0QgdHm60b7xZnfpkn2FRgFtcAASEnGXcRh2gquSFX47JeyCEZmMd6eWTiqoqO5m2+L6yyvHdVmzCScnw5d4UhyYi1uxy8FwZvYNO2f6RgnhaNzlvrZ4PBYpo22xdPuLbe/T70L4SP9LytLf+59NQjEi2mBj8BzOu0V8r0VRj8FhOA2orIk13u8J7MPJVkCQxiQJ98hL9K0eAaKp2pMjy+cQFyKtta5SKCV7qykkQ+G6Pcu8I0t4tpKBTIQ26drtkIsb2LCJIv59XdHtY6u5grY6WAsXU53yedebd4Moe/yNc135EGLxv9vJkMrgp/L7FySuB19uk5BCY/KsOVAEvnMBn5rGJ/C9y+R9QWM6nSEgoISswEtys868mU0rbWLlq3ukTxdIanI+eHiCDhsOQsF0yh6+oB3aIOwHpQsUoCD8rU5inso3qGHY97XYCjaXmSSeR8pbDTYARAKqN0+vFQNLcj4RaHxhN/6YWEmFlAc24lN77BZsgtPZGl0K5oP0ge1qKCImW7JdARGSr9COX2faoj3eVjXaqQPma46Aubcu83XSq7K3KjQ4fALFKysPjT1+wNcwAgzEI4E2FdcKPtVPZ5xJIn0eIimWU4AwGDBaYhAByD0YYeMfUj65GSiew8mrUYYcTssHqmfJbZlNMW935Y37lc+YMI3vJDd5VkY0pvfkjjqlYYQJDS9RLpgdiNwFUQDCuhZEt0TxZd5fu0WQ6D7hSozBsc/VpjM3bji7QyaiQx97mOdjVl2kO7jl6j35/o8DiFX+TvReJPhDs/oc1ce6Z441f6f8fSyO3Mp1L
 pLYOmZzE
 ivkKv0vU8C0pu56qXRBEG997dJ+BPgnMDV+bA93tj7biEp1N7gH2UxBAcgdFMLXUKaHblwwd2qSVBcyn7k9eRSwutED1LZbCHeNBL3mikDGo9+K0n1WUIkLUGq6MDfonAOE2yXy4jkfx1puXK2UOseak1H1uRPnRfkRxgqfLgSO+jgHT7QRqaX+snwIMt7wMtyg4Ed0l2aALMY9rYdJUay9R6dSv8sWRURMgBtcHsi3pNPjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are three race condition bugs in DAMON sysfs interface and the
core layer.  User impacts are not critical but better to fix sooner than
later.

Patch 1 fixes a toctou bug in DAMON sysfs interface that can mess up
DAMOS auto-tuning.  Patches 2 and 3 move static variables that can be
wrongly shared with multiple kdamonds and therefore make DAMON
monitoring results be a little more indeterministic.

Note for Andrew.  These are not urgent but better to take the hotfix
track in my humble opinion.

SJ Park (3):
  mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
  mm/damon/core: move static variable last_nr_regions to damon_ctx
  mm/damon/core: move static variable rotation to damon_ctx

 include/linux/damon.h    | 10 ++++++++++
 mm/damon/core.c          | 10 +++++-----
 mm/damon/sysfs-schemes.c |  3 +++
 3 files changed, 18 insertions(+), 5 deletions(-)


base-commit: f390255d9de653f4e7a9bae8c9a5ad881ad25a87
-- 
2.47.3

