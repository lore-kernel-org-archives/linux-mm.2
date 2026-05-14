Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 293A8CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213D06B00AA; Thu, 14 May 2026 10:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D926B00AB; Thu, 14 May 2026 10:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD576B00AC; Thu, 14 May 2026 10:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D51AC6B00AA
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 913A6C20BB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:27 +0000 (UTC)
X-FDA: 84766207974.28.2BD12F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D261618000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RF/nIHl+";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nVHD3p/QMlmGm9v10Zpwu4HmZkS6VB9jvKLshnN7tQ=;
	b=sE2Do0+OOKe6CkbM4BXG4aPOEMj/nq/xj25Q678BH8FVi+317s8bl8OSMAmoslPLlzfCP1
	kjNbVG5S68ej6IiX8lJLIP5qP9se2XCX8uW4mCmQ0njHRYYou8q7pDmgihQ4S1FiYEN0Cb
	DkVDdcLlAg0zcDi5aV7o4Dk4saGc9vE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RF/nIHl+";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767766; a=rsa-sha256;
	cv=none;
	b=2Mmn+dVCiUvrG3DehZPbVrTf+KSFfDRLWHadZ6jgo8C0GrU1qB0cXwwlcUzYqdEUQDZKYM
	L+mQEiSvYojpLwDO/HJejYdrBvBXDCwnFAbckWsLqcl/jBVlUHmqy+3HwnDL7dE2/pv3TB
	LwRIUmVC0JhHSNj9gl19EaKQxeh41g0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97FBD4470F;
	Thu, 14 May 2026 14:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA831C2BCF7;
	Thu, 14 May 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767765;
	bh=cN6FA2fDmcwC+JRPicLwVTnBJQclCA8SmpykqguB6yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RF/nIHl+xd7P/vWAHiQA+OmQT8Lpqd24rkXlzlEP90So6PU5fT5u/TFY+j8jZSBZN
	 WX9K56+F3S+JHfKAKD7OtN2E5NqNMn11xTZynFLRTOLZvPdz76Zpho68y9iPEIcj0K
	 dDFnLzWU/cuzN4PltomnYSPhEb1rITh7I8zjUgbsm3/A8P/kVFpZAWQ8NPN5d7Jk/l
	 9mw4wKt9TiyCwqTBasPmoEC9aW+4+9nt7e43dTjQVtvLXWe+Zs8N6Rjq4VV25cgEE9
	 2ETPd3PfmqHCCn4YW/MV653AOsH5tdjniv6aOklfsB+U8tO0vUyJMP9ydwfx0p36Lz
	 QgdEZV6oSxNrQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH v2.1 20/28] Docs/mm/damon/design: document data attributes monitoring
Date: Thu, 14 May 2026 07:08:53 -0700
Message-ID: <20260514140904.119781-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ze93uxz9gzkdp8i48peinm4od1r3czoh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D261618000A
X-Rspam-User: 
X-HE-Tag: 1778767765-634126
X-HE-Meta: U2FsdGVkX184BJwdo0zUI7CbQhg3kwYRwR1IpLfBRMUMo3NDvA0t6ZoZMWY5SLTARpdWPjwFFmlhTGJmamF2D3TMcGxVgBeqghzyjajluLNDDDVP1/FCot5P0JptOOrAHAkCweCNC7KglabNwGvSqhNnoxQ2w+j/gE7L5Sys/0nOzx1isTbgFd3IXtXfbGjZJ+PmP3V2GBAbmX9MQFqBbkDk/aof8A9uxpYZvtdKsQFW+gph7qV26d8ULZnWOjKvFGH+GhfwhdAENjNb3oWFXU8k0IgxJEp1KGNCUETVdc2E3N5elVM40kG49sxAoQiyAk2y40yMz9ArHS3eEMwfH/bNy0egXi1gjZgUDo3igUJ/kqwcwG2fMG6ieGsSFK8gsgwE9VvCnGacb0G/LVl0fgKSDOn9iwjAVeFfwXJ8zl18k+kxTXJajE+fhtANUxDgmxFPUc/jgqE9QCaqRg83Y8NAVvJMMQvDRXYFAwaGL6c9WJQrbhwOEdUsBeN6uk0xR2rlI1axOjw5bYD4nXCwfc2Z9DbcOaUcR1bHAJfdIwaDw48i+apCNLi/2bLQseTXTIF8wojFM2DCqWT+TzSiXX9kQnSFL5eUXYp6r82LYE5iMMEE1xJZ2OXDoaNYb0RYvOZFu+Cvd2WWs4EGRntL/sQP58dSX95XJQR2du5buFZ7xvMBfSDfk2BZGoSUftP+8dvAaOuFnxiuDBZvo0pIydbzVdugHYndTxeqOgaBwzRjMnRtkOgI9MaSYtgQO12hpQLMnazIb1Mob1c3E6g16ZYL8CksJ8ilFz3B7HINSU6VeFDLxv1x4DEjmdUUAK1EzBaUS7JFtkC7eOw+pjHUbh6TAGEGh7b7QSSoxdaY/lnyeD/h8Wz/GbHiVci2Dxm/kNzQZ/h0VrEntViSB86/rX0lNeVvs4DfCA/v5G9ex7iLlNlwisFyIE0YXI47V9pUCbP07N0jcyiZGfaCa16
 QXWRZFXY
 p/bkJ9Yg1lpNd3El8N4T5DYHCZCCulLjGNxna8psk4UnmH6WoDu0iwLN3QwPvUvvEpyEJOEdbg7wfOoC1nveloqRXGB+4TEszj7oDCUy+k5JlHflLm0eYX4JwZIAmI1uhu9wDgcPXOFRtLNbFMn3smd3UyQ2gPhozTZexic82S68OEwqRXnrWJPylRZDg1tolek4trJdkRjgjYVydXed8hBTk9PjpjlMpKrhbxPAVKaiUqrU=
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
index fa7392b5a331d..6731c3102d0ff 100644
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

