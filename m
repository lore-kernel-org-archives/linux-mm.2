Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92067CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D506B00C6; Mon, 18 May 2026 19:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008F26B00C8; Mon, 18 May 2026 19:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17B16B00C9; Mon, 18 May 2026 19:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B12B56B00C6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79C5540B23
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:33 +0000 (UTC)
X-FDA: 84782164866.20.3665696
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCF744000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9+4AJ+2;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UZlQwjwnLqwmruXlYBhzfrL1mcReYJ3BslNLkxmoXs=;
	b=SvUtwP4Rsl1lDGzHwvgHhr4HvByonMVc2GxVHXqbGXdK1/5mzuOrYHB1HeocHq798RqQaz
	ASCtljv+c2h/eRVdDyJ2JdIbQCkEqtcbwCbbJLSUDGW7Yr8lP/dHjgcSITV32DuD9Zapa6
	bQnOOOmZFJf350CtI+uGpyClJCqDj9k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147691; a=rsa-sha256;
	cv=none;
	b=NFT6AubbWqlnU7IzBeZhJNDlRgNe3j6MWlEtD8/e8sNU7OVdpXJsmeRMDVQPCPET3c7Ryy
	Y2qkgskm7i47KcQCOd6L5Sz8nh8aQZYhEdu4s4m55BJ+jZAbxe5B4k5ya9pEnGe3b5KRuB
	TE4BfnWENdBZy9B0Kuvk4ymWhVNlSI8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9+4AJ+2;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F3BA60120;
	Mon, 18 May 2026 23:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FBBC2BCF5;
	Mon, 18 May 2026 23:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147691;
	bh=HNm5gFPN8L1pKPA5WaPz2373LNJLSB/ziwePPyhOuX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9+4AJ+2XpHGhfvlIpE0FVIE828/xPDXuXC2l4CBlXz+S3sJcPiVNjgK8MUgFC7f5
	 /loBhwXTsjpsiTpcEAIMx2qenw+KXYigVPTwpVj7hKj16msneT7LLIyDci4sU08Nc4
	 E1YSpgcWxCF4y2KHOwxj3yaup7Xd2mCxxEunhFSPII6A5GzPZBL2LQSqkGA76IGU8R
	 HOIg8OUH/Um701A46JC1GOdqvzak7u14vvnq3fX2JuT8+4x9sSP3DBCExpxAKMoG5+
	 sR0vuLYTqiu6ap8hgW1JA35l40Xr4UZYCfseDDcTM00WdH1Ivy2qxBX3Q6xDBmtrsK
	 IoxXCF/rSLf2w==
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
Subject: [PATCH 20/28] Docs/mm/damon/design: document data attributes monitoring
Date: Mon, 18 May 2026 16:41:08 -0700
Message-ID: <20260518234119.97569-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DCF744000D
X-Stat-Signature: tdq1d1dstwkwmcsxwpr61ibtscqsoa54
X-Rspam-User: 
X-HE-Tag: 1779147691-266495
X-HE-Meta: U2FsdGVkX1/xMVetxEcwx8wGfgv6l0elP9RtB5e8z2gLs1symVYjl5kWAJADVsndrlpZURqRQmxlZDzT3zcx/wufGCiFGFefbXpG0CiQ75bSK9u7+f8dnztf8n+Yf1asHXqXJLrz+SnwXHGlOTUN1l3BrdaxTVWvfMqRmJp1GUTgYqvOSbEtaAij38NNZZ5kTlymfmbP9Jwn4M7eErJZ2ZOxBtlhj+Ekaq8IzuI24oH/Wltac9MaIS706q/940xWi7IB1PumCNXGbRI7AkVx6XpIPyL9o/cqLVMUAY89jup0yUrH3ZFeVVVqV91BNNK/8ihhu1hJcJwZsWNBE61y+XZB3/AoV3M5a4Te3Ybw/Wsrib8qCBw0dIwu/ktaU2c7ecv42udp12N+zHm+B1zr+5vL7eDX9YtNUS0B2YGRW3N1n0e6dguhHXJL2MFjCiFGgF6dfdaYAUbMHqB24DUACN+kcclcdxngr9eeSTHoYIJ/8KOvELrcWwpf3oi7Hl5mNaILXUz3TBaVuMeJ9prNnidvTm1GlgRw68DBzGP4wY+JoxRMTszylqs4bG1uvKqNwmr0GYjyL8g2pnEfuOGEYKeCtWXCqznKLgvyUEhHfRjoxkq+sZMHK17XRFtwn+YoJLq8Qltqt4UROD3RA1ZBwwxn9MBK4rQNR5eEHjxma7qZXvlriVbWz9F3Uhaj4gMTcdOmoXhG0ZsfTE2K8Ikd6ZEjtEVGDlbNDWvUGUfBH+GMR6fbakL7U4fIL4MRCuHqRxQZnwYRyGKUgbDH5PS6mfxSjV9X1x4XbCAwUy2m4iNpRdyY1Ly9TTnn7HJpvkHADGkuRw8oPKiD9otBVtjaQDvIjEBuiBQdkiiMR1G8fG/kC6X4+Krfi3FOGy/x6v73lOrBoa4bEMIwEOvoaFaLkf4ZT8tLBj5uyPRNZHpSv7SBJABsM8uqFE7Meka6FHClD7d8XK+Wch8nLcwmBZt
 1BdLmu4G
 AhnrhhmZ5JaRCQH6bRmEYhCkK3ldY/X6Sk27ETb1dmRl2Wl5DVbecYFk7Ay5lvLhM0SXD08CBbzOzoFPiR4kLHnlGsEsm5dJdQONaNaE9Eee/PBxNHz3zwYmeO954xFSexGIowFEkcZJC0YLPRKWlUDtSww7nt/9Hg5hSF6FkMoHKRCew3myxPbpiMkh7wOeUaOLlnRacaPyAG+/jKap79izdlU6E+KdFY0cRiqOMbmS1WQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for newly added data attributes monitoring
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 37 +++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index faea09dc88d63..7fcb726263c1a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -276,6 +276,43 @@ interval``, DAMON checks if the region's size and access frequency
 (``nr_accesses``) has significantly changed.  If so, the counter is reset to
 zero.  Otherwise, the counter is increased.
 
+Data Attributes Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access pattern is only one type of data attributes.  In some use cases,
+users need to know more data attributes information.  For example, users may
+need to know how much of a given hot or cold memory region is backed by
+anonymous pages, or belong to a specific cgroup.  For such use case, data
+attributes monitoring feature is provided.
+
+Using the feature, users can register data attributes of their interest to the
+DAMON :ref:`context <damon_design_execution_model_and_data_structures>`.  The
+registration is made by specifying a probe per attribute.  Each of the probe
+specifies a rule to determine if a given memory region has the related
+attribute.  The rule is constructed with multiple filters.  The filters work
+same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
+filter types.  Currently only ``anon`` filter type is supported for data
+attributes monitoring.
+
+If such probes are registered, DAMON executes the probes for each region's
+sampling memory when it does the access :ref:`sampling
+<damon_design_region_based_sampling>`.  The number of samples that identified
+as having the data attribute (hitting the probe) per :ref:`aggregation interval
+<damon_design_monitoring>` is accounted in a per-region per-probe counter.
+Users can therefore know how much of a given DAMON region has a specific data
+attribute by reading the per-region per-probe probe hits counter after each
+aggregation interval.
+
+This is a sampling based mechanism.  Hence, it is lightweight but the output
+may include some measurement errors.  The output should be used with good
+understanding of statistics.
+
+Another way to do this for higher accuracy is using :ref:`DAMOS filter
+<damon_design_damos_filters>` with ``stat`` :ref:`action
+<damon_design_damos_action>` and ``sz_ops_filter_passed`` :ref:`stat
+<damon_design_damos_stat>`.  This approach provides the data attributes
+information in page level.  But, because it is operated in page level, the
+overhead is proportional to the size of the memory.
 
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
2.47.3

