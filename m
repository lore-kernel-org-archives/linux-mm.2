Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE7C606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnfYCL6o
Received: by kanga.kvack.org (Postfix)
	id 97B6C6B05B8; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DDE6B05BA; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC3D6B05B9; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0676B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDD9440948
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:46 +0000 (UTC)
X-FDA: 85399824972.05.D2A0882
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 403BE140004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RnfYCL6o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wajzrzMNwWMprOwxfVXw4rbgafdH+J9WHgqDAMj2GDo=;
	b=X1GsH3wKnT/IfqRuFXps5X53/CK56MFawsSGtj+HdKlNjmuuyQNynnQ5FnKMp9eKOSQyea
	Q/JShkOvtt5NdxUaw4tvhlUdazwRvMhyiEWm2Evs00nQJ5eXMOATa5Y6CcQRfvIpvNrRC3
	O1K4d8PF4fuTqCB9z0AdDFSf16DWPFU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RnfYCL6o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853885;
	b=MCuXP6aI+6vcr1gXiLHcWz9NUiTePAQbA8rG9qFLaVy2pNcgRs43J26ctjwMRh/OUgXrWL
	LpSPgB8JJeCDbt55I5iUQBtIvH02rZJWCxHSX2iZaSoiRPG38wrJz9nh/Y+qk2XqAnMYxP
	FesBoTj8Q79naxM1K7IeviRn4VMbyk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90793404EF;
	Thu,  5 Nov 2026 04:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7CF1F000C1;
	Thu,  5 Nov 2026 04:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853884;
	bh=wajzrzMNwWMprOwxfVXw4rbgafdH+J9WHgqDAMj2GDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnfYCL6o3nODbMVVbIV2YvD2g5Q6XTsL8674X3ii7XWst5EKMH86iZiZFjHmtrxeZ
	 ctT+rAeUYUt29hkIeTgXvvgnjyPuQJnR+9fPfmmglK4Sb+GN5s8EZxw4ykuyeuc9Nd
	 fyKK1yy/4gNVY4KJi9jIhFEYTfWZTNQS7CQQvqDUGB5t4czCxl28PkB9KGNwYUBHp/
	 RTRlb4omF/yU2yp0brJppk0phkWudEUut3ygogf/8WgzgA/NeFkJBectl7ozJ6rFDL
	 eBIFzrYqvkOeatxozss3IGM5+BWBJCEmH0XzZDYdsBmMGhHlU9BF0ZmVuVdlIemjEq
	 BfxvWSdBwptqw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 4/4] Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter
Date: Wed,  4 Nov 2026 20:44:24 -0800
Message-ID: <20261105044425.87142-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105044425.87142-1-sj@kernel.org>
References: <20261105044425.87142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 403BE140004
X-Stat-Signature: x89pra1bma3ziymhaaftqs95z8zemo6s
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793853885-177924
X-HE-Meta: U2FsdGVkX189n0HKzklBUliTW3uf5upz9x/OWi/5fswqQ0VkrbOol2SGP5ruTxLTPYgV+ikr/BnzCOA3F0G38LG2/wgj58GZy4P6RvGmZZzgGVsGfAp+P+QH+TLkaNInjn97iFcZmvD6P4ZGSo4P366QAjLoNqCLPKu+FwBsjrm9FpyWiTuWGkm1A8bUhaMBFQBlI4jM6WF/STW0rJiRvcR0mKTugxUWT214wsGABfXiq1Q68YCC5FFTIHgToFc8j1rYL/mApmBodr5AuWB8jgwwdr1/qisCo0zMmqg/yHDcRs2Qu47NVC7Gg1u1AN/i9oeD63RKYOEzJh00d5fYRCUgSbBbPrtyK6j1yf2h7I+iZlT+a7wnVtjAxNB/p40KIRnk57Xrvx0J0hiWWEGfok12UfznE0yx5r0JJGA19APawhRvkWg9iXO3ZPy7frqX/gXQxrCsvjrcYGZQJ+EX2mvtDpW5ylBjZ/FpgKFw/om6+89ehJEQWtj9cyujwlbfwggE+dUjW/wHcAbgLpIBRIkjV4N/tqlrGznXry1FJn9G1RWCugtuzbAgaAeehIP3x0OvT6wH8dWjsaiJPCwvMtwlf/5gG0u99Ncno9dHRpCi3xi33vmKZmlY4h+nemRBHpIfe5h7Q/gSDtnDIFBjsFzzjVZN85LVl2bpcolWjTMir13inyKMyS/irLCTRsD/eIvdYA9CJkeH7gojgbfSOEuoEl9xW8RuE/URnure6+YOv9vmZkQmBg1NYeZg/ZpyNZW5mXYyOI/qsyr+UsPFgjY72yksw1vZfcITFJjj2oxXW7EljGpSOOxa3wsX7dRO31xvQIh7M08sGqfoVEHcIaqGYucfzKqxA3K/KpgNrcLkyhY8ng5eOnx2ndA3PYsytzQtQBXl2GGDBOTvynA29ZWomy+qvxJXfNNFRdqW2E6Ls3q41WQhREQeCzxu1AwmFNfmH4N5dfot12ff+KQ
 r0xO9E9I
 ZKAqLu6YIO5Puw50quvh7DDR6Wngqtxw8xVQhBwrgOGcZsjzIeYpX3GVsK8UQiQCg6c4QjZn7PkdmIlnl5554wFVPIDdsg7jVHlDV6SjKl/gvLBTCXFwcupcj4eecG00pyoePPLNR8p1s/2BGgwxnjJAeANB/qfCrA7G1GwBD7Nkxbw+RSQCrOmi+u0Bi9ot5aZgXNXTRWuTVYjUug930T1fVw//C1zeGextq52cNln0viihHwChXkNLjcBLtWkcy/drEh++dkc9xyjJVabweHWplKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added age_ms DAMOS core filter
type.  Add an explanation of how the age range for the filter can be
specified by the user.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index cc7465251bb6f..6093b1c8fbfd9 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -559,6 +559,9 @@ For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
 hits weighted sum value for the filter to ``min`` and ``max`` files,
 respectively.
 
+For ``age_ms`` type, you can specify the minimum and maximum age in
+milliseconds for the filter to ``min`` and ``max`` files, respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

