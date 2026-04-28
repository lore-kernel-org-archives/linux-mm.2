Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703E8FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59F76B009E; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0ADF6B009F; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA6F6B00A0; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEC16B009E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AA3A403BB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:37 +0000 (UTC)
X-FDA: 84706244994.16.E7CB302
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AEC9E180011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4mrjTaJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340075; a=rsa-sha256;
	cv=none;
	b=8hRZ+HZy3kKFad8+qr1xu904pBYMEr8a7S4j/9bW1Rj0ZB2V5GEU2QePpIK4urhBaD9CeY
	6a77ydbHBldYrP7Q/rh/oQ8eyY5mo9O8hz4RD7xxtry6bkX312PMRvdXoSxUCQHw9Tqtlx
	ED2+Hh3ZKggvE+UUfWySW1Bmwlwqnf0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4mrjTaJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+++C4FbPvLuI+LhwloavFM8OGN025XzDv0RO8kBiFY=;
	b=UtiOSeehVgT/HSzc5xfVsWVCWftUaDqKZQ28CqErEUSGFse+m704lzwKmLOYKhWihxrT7E
	D0pWFawgcwWRt4iHp9MxmjR0yjHLsB8GRHBBECKbJfZDDYmVW38LV7Wnw9sSOoNGUi/wxZ
	8+kNWb2VAusfpFoJ6JVQvfP7JjDxaPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAAAE4195F;
	Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFA3C2BCB4;
	Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340074;
	bh=t5zJdXrSXfUqeg8E0cFC/+8XELPbXvEetq+3G/tXFao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4mrjTaJBTN0LzIRNCZj7pwECqk7KOMJnhlOtYO97I5PT+9fPxsDE/ysqobr7nWJ0
	 qbXfihTA4bcntw0PWuME1t4oJHc8ORBXew391Z/AL0oCpDDFjY9ugusHUixJlT4woj
	 Rq7joVjF+dQ3mWhvML7nPXUTEvV/geWePDQm3CE+BcTeAD1b5AI722A1C+U0scEf+M
	 gVcTladCAVdvf/ESfw60+Z5TtgwPgb6ZX9tB1ZQKHOvqVXvPHtM5ge88lxwn/ZZPvX
	 YYHgHh8hjxVSEKzmVn/B3IV+yfXjify48hbRUvnTdd6j6kgiWf4jWG8dgbDR32C28G
	 sb6qtS5S+kRWw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/11] selftests/damon/sysfs.py: test failed region quota charge ratio
Date: Mon, 27 Apr 2026 18:34:00 -0700
Message-ID: <20260428013402.115171-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wae597rxc3b6taj6d563y6qkznzs6t8q
X-Rspam-User: 
X-Rspamd-Queue-Id: AEC9E180011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777340075-1993
X-HE-Meta: U2FsdGVkX1/KX9n8PEUyJ5GuagkXip/ZBsQxym+PkjnkpjTqUMAKQUB/gH+UeoQsbvwQ11OX+7ibKDOwHEyT+yYvWpgNu4cVbDAwn/+WyYKgSfL1NjSVFH28WXBKJTEAiBWZ5Fgb1PnaKWJ19rTiIUGcx6ahSS3OI84KRfZZXVaiaI4KgzS57AFFVAQleu7p8iTnyRTczwZXZUzBQvEP9DIQMu9SA3FVBuD8MhkZfDkEIPnnkEFjLzQm1TA1denqcSVdldFc4gSpPnki/Ks3r0mzv3F75YK+07F0HVRj/lxPbimh2ph2mtgLMSydb9ssNFbvorQDoz8CV6hyWrTfiQjbWb09RVJw65yipew/zsEeT/RHZHq3VlJVLUgBjbjLwhYOXtke0vAnXOEkKWHFZSjhixzEDDhlAa7cS0LFG+5mun/PJmu+Vj72pMsU9z5Wc+xJPrThPcv8UPxY27GF8zoIjcw7FChMD58ELXbEqKZ4dUOtrjMFBwOdHBFIwXK05sI+3t06DPY581HsFphfg8U/k2s/rax4liqkh6ORVX3vHCTPrw48RCACCX1WAvqNEdQ7XMTnHurWqhGynj/UurbOhUkTUCmZV7RyKutgIPlOwrLAq311MLp1juMsNhXz0GAn0jOZwLCxy+QX/ZAjkaWHmaddZnRWJfEId4ti1YNqXwMNKvdkPXfLwP339s0sS5Uc60j9cAd/R/kljaHRp5/Z3rnNtlaNcQI/9VABQ/ra1KeV3HL7ZgG7FfJOtNTfpO39EnSv31+otUCtAogMAmjWYMdOaVgGk7N5YFYvNl3ThoOSaHu1Ji5h3u1ZbmVAShmEX0ovhs36AzgvIuThmf+mvVwWu+Bnl9bxfplyV62+pciOiK0zfIWifnFVPNobqX11kL9qeyxcYTUNjRtlD0vvLqaulbXK78q5E2NtBb16Q8s7C9eUqHUL0mOHkfjT2LCJmGffibCpKUua4nE
 0zW1w4Ha
 E8EDvUAY4iaD577FYTR1g3nocMqA2MZUOUmYXBkwbY63pH+Ksj6ELo/60XnzngD+Afcg5oH/as6hj539GsGlgkufPD5GJY8z8qFsyKveoYs9g7FbFDXuvl02qTC9rGbfEDP40+QkXbbSgrUS04lt12tcrTMMkI7q3kUIgEDFeRS0R7ETixww0rVLYLTZ5eM6UZebzL+Rb/KqM2uQ8bX9gipwJsHidbYK5Co76ZvGVJEv0fps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py DAMON selftest to setup DAMOS action failed region quota
charge ratio and assert the setup is made into DAMON internal state.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 387286dc449d5..cd4d82c852113 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -73,6 +73,10 @@ def assert_quota_committed(quota, dump):
             }
     assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
                 'goal_tuner', dump)
+    assert_true(dump['fail_charge_num'] == quota.fail_charge_num,
+                'fail_charge_num', dump)
+    assert_true(dump['fail_charge_denom'] == quota.fail_charge_denom,
+                'fail_charge_denom', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -278,6 +282,8 @@ def main():
                         nid=1)],
                     goal_tuner='temporal',
                     reset_interval_ms=1500,
+                    fail_charge_num=1,
+                    fail_charge_denom=4096,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
                     weight_age_permil=1000),
-- 
2.47.3

