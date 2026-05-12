Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BA7CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EC06B00AB; Tue, 12 May 2026 10:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89F56B00AC; Tue, 12 May 2026 10:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6656B00AD; Tue, 12 May 2026 10:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A449D6B00AB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73AE0A04CD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:07 +0000 (UTC)
X-FDA: 84759020094.29.29FB717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C58574000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LTWx/evL";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nVHD3p/QMlmGm9v10Zpwu4HmZkS6VB9jvKLshnN7tQ=;
	b=w583hGXa9AwrJPr9jWo8m816ZyMym2s0+nOEg9h0/93DHNH9Man8QpTi7CU/O/rOz6JKDv
	nSb07Eqxhw/OdKKA33M/6VVFtNb3JN5pAPPHEYZtKO29mNjt7itMsnLowGasn7TotBYh3K
	uKbtt7wx6fEbf3IN3EWqLi0OJWVB//Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LTWx/evL";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596625; a=rsa-sha256;
	cv=none;
	b=JhRmxV276mYrMtfzyJtwH3GSCvKG2YTBoOtVEgSvujwUp3xgUOi3kepgtI0SztXEUIcI2B
	PwbMxAagthsIKWw9X61mcIXgMCj57sESJvJtSbQgOh66dOtktnbt+mLAFewtmw23FFkERw
	t9Q7D9gGF6jIkONzRantqAYXVsZYMoQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8591644AA4;
	Tue, 12 May 2026 14:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20FEC2BD00;
	Tue, 12 May 2026 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596625;
	bh=cN6FA2fDmcwC+JRPicLwVTnBJQclCA8SmpykqguB6yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTWx/evLkEIOQCvFjEkds90ardLj1jICgbB/sGDzJ27fRJvQKLYXZpMtYVbPScrk5
	 2ryZsSH8EFSpgycvBipXDC/X0qiKrHo5sCzILuX7KOGhSsYSYs0Dqte8qbo/Sfn9DA
	 J/VoC0sCOSmkfZCgI5Ibtza3Nj80WZeUlFp6MzY4JBD1xUqd0SvPNRXnIla4q/Mv+s
	 RTDlRGrrOc7J9rlS+wJCsEB8U8kVJvXiBy6vkx6a4V75tEn9G1B/+G0ylzRepLIGk3
	 CbaHNK7nI6t5OEkuRv/+/oHXm2+ToS6dWmjZ4yH/6sI9M7huyeM/cYsD0nnodOcK82
	 nTAVOBSIKs/+A==
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
Subject: [RFC PATCH v2 20/28] Docs/mm/damon/design: document data attributes monitoring
Date: Tue, 12 May 2026 07:36:35 -0700
Message-ID: <20260512143645.113201-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C58574000C
X-Stat-Signature: g1ffq5rw4cddokwu7nykop4fubduiy1x
X-HE-Tag: 1778596625-516033
X-HE-Meta: U2FsdGVkX19rLmEgM+SKL/cGyxasM0SrMwqm8R+ZEo1AdYfev/Au1rKeiPLjiRugNRt7HLXeZIe2Dxms4RXRWieaBQTemgBcfJSFZO4HsXBcJTusxVfYYv0SpkLZO/OzyQQnH0nVBhPV+rCkjEq35pkZXTFi1LBE2odoJAJry/tWSG2/5x4n32BlGPWtcHCkSUFGIhcnnyG8wrPtD1Ume+flDGgD9HOL6EjBPR1bf6DpMfhds7hAgTGlMFYmimyUTI/mSYCcs28JsuYTWE+RKJ22Ec3qysV5ENvOaV/qoY730gYAm7rjFrJLpbuK+MXqLOGnzkcSDLtkPSAHznVk+SaYCCeph7yi78pcnaZ7/QbzhbePmCw+fVhvqfw8TVmdgWuhanXMV4O8Myj7dfn95nO37VdNlAtRhdOBWbrHRL5fhYSn5jyWle9/VRc0FgWkXP/fa7ZnUBgA5VbalBjqHVN8zIbTI7hkSF0rej7891Xowgd0GBEyf/bGK97MQb9blkHwq660tbt03iIvb+XIK6yUjpPamVaG3GM586E6fMnw0Lr7nY3lMkx6I4/EpJexzY3W8LWRDYJ1DBBo3MzlYmSTJkSDjPMPevHEnkmrh1ZWtJN778M9ap7+uHfnZjFUiKl79iH/b5ZodnxXF+FmUMtkUSc1fp7AXjTYmKlp5N7N1Hvepx/zCBzFsOksaJxeWbVMIleuDLlFGndr98ihaqS6M0qem7n395sqtC0CYp7sgLb6F/GC9TsjDpuY4w73SaF7Obl4+4qI3XC03lr+BJK+K8ZoupWU9hMs/WEGOwA1o3XdYxfYlQhAnWGr8rR255ElfCmycOXFT4QF3+lcFOqIBWcQnWaZqpu1HnCdz37a1y9dqhpvr3v96WAmAiXNMbEHF6t3sAcan/MuyK/vH0kO7GeKMIVaCbDBDc1SPYLZAIosj1j5iS7wUr/kpAhqc0LBOLlXB86lfst9Y/D
 fkShFA/w
 D6oG25+2Q+wYftrMkmSRP5LZUfmOF5ERZHJKemW3xApWeoGBndygfLvv/dcUOswZ0WHQikcaj5Ggp5NA4YipMF/8H9ZcI8YUhlHZA/jDSoov5kmvAJWuYuOMg5PrLlakkXWhZl6r7JXYS3nwm3LaLckbepwNpVQSGN3Bv22niaVNT0N9nrYYtzI+MGeam+vF/aIMrDISZ2ZVTnfzzhNXv5gW5n4YxUCoQLOChuWMvTizwQe0=
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

