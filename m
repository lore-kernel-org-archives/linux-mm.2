Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C34CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D146B00A5; Thu, 14 May 2026 20:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA6D6B00A6; Thu, 14 May 2026 20:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865D76B00A7; Thu, 14 May 2026 20:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68B856B00A5
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 338301C01E8
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:57 +0000 (UTC)
X-FDA: 84767809434.20.09A806F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 88BFE180009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohlBmz1q;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j6np82r13jQpEEY6/4Y2MiOLGFt1xoGf15AwBJBSXM=;
	b=KLw4BooEMQixfGpehcaqFlpM1Cnm13Rwca8VS35xZop5X4jgPHKrrm2XrpJjOLaP/h+12J
	wsxNutvwrtDeUa7JUNebGUKx8tlTsuyv86OjM3vKiT1DmLk9j9Q3pM1XmXHJ1oJzQnlTkm
	0ZZ5ygRq7Wf3cB9UuOgGVAWXh2BdPDM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohlBmz1q;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805895; a=rsa-sha256;
	cv=none;
	b=mMNSj6X7cq1sHmXSOWFE1A9auwoQy/5+g/db+dllYuwupCJcnQT7bfiDhJtdARdD7DpW+X
	YvApRSve1OMHSOirBCZq7N5yBOspkuKF71yh2VJdA0sLU9HO4CQCMKROI8tQujbufCd/Xn
	WAjtl2WBwdr/nfr6jHVVnVmp1ocdoKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 446AE41931;
	Fri, 15 May 2026 00:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E130C2BCC6;
	Fri, 15 May 2026 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805895;
	bh=OPFhEPDzos0mBFBwhii/0BwgZM31nZ+rfuFNwzzIAKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohlBmz1qbNNoMP9c5FxOa8/YODHQ5n0SA+R8HRu7GjSSZ1xpCFzWncDcwlqH46mTP
	 6h5EolLHb5duvzp9CnhnedTkjwgXpKGg7giStJFccWVuaYgOdSt/QVYkw32ynp+mhx
	 YES2bCwdVnBCef1Kl5RJtqEkWj/CbVYniOLeqqTe6sh1aFOb5y1PItrnWvgsDPznSC
	 a5y30OTM5iucG438qFNqCWyQ4tN/1RJVeNIThviv4jUuIzJO05nGH2TDeHHfC7T13f
	 Uuo/VrsEt99FXY3vT6c0o9R695YedJ5qkBP+iYs+1fmAqCGsHMC6K6KJksyKDV7cIQ
	 mLPaqTjPqmhpg==
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
Subject: [RFC PATCH v2.2 20/28] Docs/mm/damon/design: document data attributes monitoring
Date: Thu, 14 May 2026 17:44:21 -0700
Message-ID: <20260515004433.128933-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uwq4nhqowkf5p3hu7xfzsnhxgc7yf811
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88BFE180009
X-Rspam-User: 
X-HE-Tag: 1778805895-887768
X-HE-Meta: U2FsdGVkX1+MNUCqBt5jYANgIBKSgF/PF6wmEq8gEPAEE40Pr7LlVIALviH79L+PN8MIdLYYdxrxnmF9qEkipZJ7JEOb9DHHOAPQz8dw+5TcgwiK0UecYgx84kAno1FAMkVvO5+SZueL3hxFJzE0M+V0Dm14Isr0wGBAK0WkTHcwQ2/2WwnJtGRYlndkCKWT1Tf0AdQFEn/bRlZLbqpTPnkl+N1n50D19U+sxNNyoJt+YQHf7b1fM9zgd9sHU9KF0vV4egyRnjEShSOMReflTpsUt0rRFNlxxFb46eJ55V5LXzz3ILxP/9BdybKOs5ZPiDfqDKN057TVgA48EagRO5dhgs1ueY5BA+uhr7SGdL+oV3s2BON++unlEl/oa+M4I2jQsLbLWyAojxPPq4OCiG7ntDhcX5tjjFE1S1smR++OYAKx7jTD485fW8upHV9/gndbRMWqVbeUTESTlmf651NoCImasUuM9XDzBtn33tmhCgcT1CwR8ZIXTfA9TqGwzFwuNXmNzi92wWCgUIwtR7vVrGxE7973vvmT94neoIDROUTGeN/tmiqQuDjWUBR52e8NRP/ie6fxa3+3Eog/SjCXczURLSw/bihNR6Dhpg+gc1YPkZRFiRAGokcb0L6j7QXNUGy618gbQARFBXsN/X062Cf6ootb0SoT4UnWpiVL/ehDGODzq8IUDktCkPO2CL8qxwblkt3JOGjg77uNJhmEpc7anIBQBYB1wZwP2g1MMngkSI9HIFwPViDGeYagXJdaLtNcQHdjN/Yx+VJRlPfSwum6kd4+6bmblwGWRZ4PZxNwbdeUdQKyY9Kxt4FXf7FGYCELMZI86+GjDKLL/t1ghqNLAVRY2EeVUJ6eg0rjIMxB1GXHsXytp66PdhrbndaBXVORRmjJGYozpipgUX2q9T36XkDQRuPqLQrjJyIoYTqRbqfbrGsOTBX8bN2HzbZq/JTfk9/rIvb+AbO
 ndrHifur
 3okpwFseiIx9oyJmsnFW7IMzvnRTLlwUUVM8UaFr+PzM+t3/GxT5Pl+hpxp13bHe9sslqMm6NQwShI4RfJTLACYhwIbLlnKBGM08hsC6EJS5Sbp3+ve5ZPBIFKQ3ySx2JxBA6v7TT9uhjyrYWlYW8P6qoAEMMR+cCgnKtx+iK8N2TgHNuruTvbGKpRGo1gdmQSE+a/aVeQYWRte2M0dtZw08e+2tzx4OgBMKtVAsuhaooAOc=
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
index afc7d52bda2f7..aa08c899a3e5b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -269,6 +269,43 @@ interval``, DAMON checks if the region's size and access frequency
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

