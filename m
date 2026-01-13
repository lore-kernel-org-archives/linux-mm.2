Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1431D2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2656B008A; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A5A6B0096; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDBD6B008A; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE2C6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECD591A01CB
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
X-FDA: 84327319986.07.01B57A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5372618000F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXmaPVkG;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318052; a=rsa-sha256;
	cv=none;
	b=xGDj8kBDkQm60oUn+nQI5gskDm/QGvvCCKAxhbqkFJ9FyIBtB9OMuzSPu7nsLfhoM02BzG
	G7bNWC/F9qTME+EgRh6G7UJmZpq8bM+1nZihh6pA4uvPmU/9U/Koqn0JFMvChY+/vKux4e
	WHvYG0UvLXvcpNv+izs+diikSMRQAsE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXmaPVkG;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FTKVC0Vw+V7At/WYQ6sSPW0pQ5YC3SXXgca7F7aQzM=;
	b=KZrBaeGiTBH+7oazZ4a+Aa0P3ht0Sp+ui4wOi8flo3vplDwNgK9g+O/9FST+Y6CD6fTcZx
	DIrgzmrB8fwpG9VcLTxYO34gcH1fBuHQot+wRRbTVGjJk7OPhfbC9A3g+PPm2QGkkCCO+X
	dTiVCwtsBodJBJFjqZ+ZzIlgZdUX0Cg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7022F44367;
	Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E992CC19424;
	Tue, 13 Jan 2026 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318051;
	bh=PXBZmxIShUHTOj68WkS5j6Xr3CS96XOQ/oFi936N2Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXmaPVkGiyyRuTCvCnLqVaThvQ3h+a38mIaYB+PZFZhn4IN/Cn60g6ooaw7JH5I2V
	 cGzQEFzxre6EdaYJ5uLKTVM3rhM2cPexg1CduyuSQERI0g7VL5auvOcPErCcgx92Hk
	 ySNH3Xod/O0xh4WWbzvdc+uwm9XXsX7hpeH3PJ8QnXZ38JL+hLr/k1qd1tnJ9AAXrS
	 uT/E2mPhJMOKx33qEG2A3G8wmNGQKkEBWFhNbJI4xy4ybABdAORyBFTuAb2yNLUzBO
	 YQdRuKS6YytGN+NiRpCmOwQSdNvZLgHJX8NnfrIlUfPEdogwGz8pg3N6MUeJI1T0Xb
	 6YTEI9pUCLKvg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/11] Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Tue, 13 Jan 2026 07:27:08 -0800
Message-ID: <20260113152717.70459-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3yemoxgtrgmcc4x7k3e4syknjwncqcni
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5372618000F
X-Rspam-User: 
X-HE-Tag: 1768318052-666988
X-HE-Meta: U2FsdGVkX1/Eyg1YYmE7+KulYgZH+ku/hzADEKUngA+x3Jgob2gDskEDFN6cQLxbKli0vgIsCRJtceMcdcidnoj1g5EpnhhdWauWLqofHvLTHhtuE4Uu1dVEe2ETjWE7pqzW2VEM3JAhQjpLWU93KFyUScy0PO6ZBpF3imeyOeLIcO4rRqw+OsDb6f1dB+jO9cJQCDatYBu8t3q///1L5y7FYNiatYl2W6bPKdo0w0wZsvbwn8zyAhZ5xPUMMJuisMHsSEX8eBLnUb2GT4aclgqOTYhXUib7W35yD4spdiSjKQ1kl+sy6KKK0CQ30vhlnTGo+i5Kfg+n5+MMvoOWP58we1IuwWNPKRe8rRYT/5onpd2dK7oaGPEM9E5LNQc5YTF9NnPScm7or8hhzSQ3SPNlc8HOi/ZBsJFPVFb5kWdkVBKYaQMolSm3RY7NoyVOyazKaKvLrjNMN5cbxC3xdEGUlM3eHO64nEnY3qXIdhrBccSnPScWoWKb/YKYgd6Nz/YTd3LSB834lZyziA5c3MlvSOI3u9vERfRy7l1DYhUrBtZNtu7Pz/bVVfhxmm7vTUVN1OQBwyfCMvT05A8ysIjgByQ5tXs7NxO0wIChbP0Oe1XjvMCSQDCyVHI3uvcyhUfAsIGkZgxdyVJ1sDaIcJT4AEj8nkmYiaAy+WR5RqyAPFscFqA46cJuWdKLKY/HKdHSEFeLI4mGWfndNAQ/vpdyHpovAoc4N4iU0H6YB3M49L0x1JPilMOvHWNF32+gQBFN0vEccWJNGiKytynlGzyhR9KKaoFxVKRKjzPXSiLpywI6VHYis83AGNl0wFoYwlLoP3v6a/SrEXHH5zgmLrz2448RYNyD67NDN3jn57GmHr1Ci6CIvxRUPHHJgvC4DpDdjl2Xj61xKwr2FngczVzJh6wqFugeQM4LgWm/I48fm4IIuh/zhecZTFXw7BjMHFSwm/JeoZ0w1iRrujr
 EO4lUI/2
 LcahTZ8tkrqQkI9I/cPIq4Wv7/HjAMDzz5Iv1PBTTjYcHkHRDdOMrdkanoJLKEhQVRiFFLyzx7XL9h5Q+wEKUP8sQ+s/FVkJGAWC3BDRjSDABLnqQDHpmSwjrU65u7P285ooMN7iF4H8i9AB5J1ECFK8Ony3XZBiQwZpyw0UKUxgSyV9TVBA9B7BhAEScFRFpGrjZKJf8CBrdm21AfhKE07lPE6vweRtNXHXQv4Gfe7o1KJpvJCiHFj9CZJgKPAiIbyV5S20kBEUneSFFC7U/uZO3qvk94qVQQNIk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update design document for newly added DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
metrics.  Note that API document is automatically updated by kernel-doc
comment, and the usage document points to the design document which uses
keywords same to that for sysfs inputs.  Hence updating only design
document is sufficient.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 7fd819b8bbf7..0cfd4c25e92d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -585,6 +585,10 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   specific NUMA node, in bp (1/10,000).
 - ``node_memcg_free_bp``: Specific cgroup's node unused memory ratio for a
   specific NUMA node, in bp (1/10,000).
+- ``active_mem_bp``: Active to active + inactive (LRU) memory size ratio in bp
+  (1/10,000).
+- ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
+  bp (1/10,000).
 
 ``nid`` is optionally required for only ``node_mem_used_bp``,
 ``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
-- 
2.47.3

