Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C432BCDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52296B0093; Thu, 25 Jun 2026 01:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCA26B0095; Thu, 25 Jun 2026 01:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855556B0096; Thu, 25 Jun 2026 01:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58BB56B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAA9CA0544
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:09 +0000 (UTC)
X-FDA: 84917253498.18.59D0C15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3AF5A20009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWFqIUUw;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364088;
	b=ztthZfSwrNMwf/46/uxxZzA90sdVEkkxokL5GiwJpxrIASitDi0ao5FlEawpewUhZjw1rZ
	7Lv8hbXuSelOCa+2+Lhl3A4S1jhVxBQkFE+vbdtlLs7DwN+CU6oFgNB8Lx/CTrhKNlPqOJ
	ewVXQxA/DM0jx2L0c704aylkuZMrqdo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LvJ+WZBdNE8CHC50l21Bmx+mbLbHYnZH4awOTWd1p4=;
	b=r6z/ZGmbMtNpASuZT9bgvUxegRozo9UHx39vBnL8ZJ8tm8zBqeyHfIHX8NzLUP1Cffl3KV
	xzM97SRwdTV3JANqmBMC4sGWzsdFKiZuCEvEVdGKbwBQ0F/OSid7TTYjk30UrEAZhkYCuK
	FJ9gHsiBqFKuRVp06cZvIIQEWE6JWKQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWFqIUUw;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61268440E2;
	Thu, 25 Jun 2026 05:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143491F00A3A;
	Thu, 25 Jun 2026 05:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364087;
	bh=6LvJ+WZBdNE8CHC50l21Bmx+mbLbHYnZH4awOTWd1p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWFqIUUwrG2MVgV/BwcJOhJScly5CnEo8zWWGiNiNwyNQriyzq7Jmvsi9+7hTFyVH
	 MFm+5GQCGBJFHU48PDxJaOIwJl5GE1hZt+2gK+PsHtZTcr/yhMxSjYkU3Vt6ct7Qj/
	 I5Z2hDn8RbFGBGxspyrd3l5mApcogYQsWPxlmZY+cCxC1jRClPi0dpu6sitB9xA20M
	 tsPsO18Jt3E8W7mT9imtF06GfS9re9meCLNJevv2cEXhA5XCSUtPOqmVXOjo8qkldq
	 +7HtqR4Mr5LczvIUT4CSRheEG5RDEWAr03YbH84WuBy2EK0faPFXxQN8f/kheWV5Ue
	 QrssoAiUMdm/w==
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
Subject: [RFC PATCH v1.1 01/11] Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
Date: Wed, 24 Jun 2026 22:07:44 -0700
Message-ID: <20260625050756.91115-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3AF5A20009
X-Rspam-User: 
X-Stat-Signature: aphpe3m79hotj3duu4635mh1hiq4kr3y
X-HE-Tag: 1782364088-582726
X-HE-Meta: U2FsdGVkX19FwOOWKeZyL2x3R+LkH20uUV9bw57MilU4LXpfkK8wTnNX8pXZmbSnCVCwSOPDNNjjN0ZqW+eATK2MrDgF8k3zm5YvdopKc5PEXiNRWSqUxxwZL3YZns+HI2A6QppEiQcIaTFlaffZWgP0NdqaAckq5szfA9IQr5v4GWPVlyLzqISP1isMJM+ejbTZzJ8m8AXGfBYrX5a/dnTNNzZPLaZUxj7pyPk1ZRHSLhp4XfGC0WojMpIVrKqn7u2X6dBzZr6TfVk/WtrMIyw/be274VYVr/5gVxUgkeHZQTz2vnV0EfbMJIDZOx5p+h7gdWhivyr8xqmGMV3xjuS4CMnTjDKdh7pzx78lTsTNlK3iPLMqzyI0UKg3E6yF7Lu+JYbMSLsrxSqdC3Yx0sB2KaWh7zzlr8utMqauw69mB8Kgbvyr4BmfELwEvLxkAabHtqsRmL0REaxM3u+CYQJA/PJQ9A1jg38SwSiPBBtS3EzAyRHoPu/AO+ZHA3JWQLbZmQn4CnzKH06b8lmB7/fNKY5V8Ik/YPqBeuMFTsHzNXtXCm0jLwDOMgBBfiQju8QX2a9NRr2zov2hPdGswPpAEdaFUFgupwdrbTZkBx49YnxJDLqlSF83lRr1X5XWLJnggAsS0i4av/nnpP5yXFLbyl9X3eKDLm3iJ9b0EpW9DDXX3pA/ozU2nR1rA6YyNlZgVWsxsARtkOUGoJZpARoQeiZQRzRBYqakUTayVUYTzWzWADFKMCM355P1AItSmr4k3bIAX/n1DkMBBxYUZVMaRBUVoetzbjrhN6pUl8CL77pZs0i17SdObqlivqfKpCZD79r0VdBOWPA0qyH428DJsAbHatHf795d9bsjN5SvjQZzl7kUw4SMu/tMphhK28561xmSkAWAtFnzm8WF/L4erkG3vhni9GS6l6odkefjOlSlMzttIQ2dHDYmPG5PnZ/VyBPF9U1UNe3s3nR
 xdq9Yi8G
 PwtNsxUCSN8zWCXDYFi1pdcrUwMiR8K8LQFoqmUro02lu92lBLdJQpD1Nxi0XNZ4qSd/cx73ecD45BnxOs5HOO/DkKTiXORKMZ2RrBaNasQTIAsC3SfShvBKQOufCp/gGuf8ib22OHlmOyyhTb2fxgZSrLx8FEtQFHReMtIB1lmd4ShXoRgcEAX/Wi4eT0Y3S/AYVA4ryyfAr7ilLT7hZN9eI0T1gF5jpdDDThs3wLOlO4Ck6fUu+M+6AmKYeKVObi7yCVprlExLO58pXOSbU2j8EjfzP5LFREioj1ZNN/SxyavdrJ3ojMgCb+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
introduced DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP but forgot updating the
DAMON design document for that.  Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2da7ca0d3d17a..1ed02f2280790 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -686,6 +686,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   (1/10,000).
 - ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
   bp (1/10,000).
+- ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
+  of a node in bp (1/10,000).
 
 ``nid`` is optionally required for only ``node_mem_used_bp``,
 ``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
-- 
2.47.3

