Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3007CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5861D6B00AA; Tue, 12 May 2026 10:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510F56B00AB; Tue, 12 May 2026 10:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B00A6B00AC; Tue, 12 May 2026 10:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2766A6B00AA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E93021A04DD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:06 +0000 (UTC)
X-FDA: 84759020052.25.5FAB94C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 23B382000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFJZVSu0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596625; a=rsa-sha256;
	cv=none;
	b=gsUXTNR8ZkvSKvLzsQWMS02SKhl4tA/kuli6za4NENuuUR96EPji3Xmx7yyfXJRLn8th2/
	uQicYPE//OkGF6SoaimKAoTgRBPGO/TRT+7aCCRDSD/unpCQYlTkofK3gTZz+ZF6HeAt9X
	kYE1qZ0T6nowA3Q8wBhzJM60g5vLKAs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFJZVSu0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfeX6x/Ktb3KmB6TDO4M5QdJKq9cy8SwqCGik7CGYn0=;
	b=ib/oXpBzrzPhx97kFLjnL/UHHF4m7fFOLXiZCa58bH8YzViAJ3Z363mJc3oMfoFavRH9Oj
	m4abCXOrt3dqIANdzD3bZ9wdLrXita5/BJ2HKxd8Pa89lnraFDeTkRMMGA6ACZSV6Uhke1
	Dc+LvGTEPdWl7rRCN0q2n0C0SBabIws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D94A744AA0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833EAC2BCF5;
	Tue, 12 May 2026 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596624;
	bh=EauBIBzKjl6rFCRlEGSo/s6NrgLL9HoVh8TIqUsq9vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFJZVSu0GDYBqvaQBc63EdHHe5GXKyEp9CdmpKL/PB+nApIyvzw5Akctb1w/Xy8r6
	 7A9I+VMxFFCc0HCWCPzxBkxT+ypJbAyd4C4ZM2OCw2974pDynugyPPuJ4E2xk7kTSG
	 JPBfu/WULl77WKdP98o29HR/uQE+xif1sDGa5YgSC4+LeH3mPsLs/Z6QbNKcjxcDOI
	 zHVpnKzLQiCdkOMkoAJSmasVHliI9sSOhwng+UzFBfctZl0fK9isp6uFl5fZRiiKNd
	 9yxSrrGvUv5g/zH/+oOAcths8s6xjXowv+QZPKAbDdcCb/ngDOkzJyotlfts3w0aJf
	 VgYJAXwCRY6Cg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 19/28] selftests/damon/sysfs.sh: test probes dir
Date: Tue, 12 May 2026 07:36:34 -0700
Message-ID: <20260512143645.113201-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: woimitzwcuxrjs7ukiwnpicjrm7u8h5z
X-Rspam-User: 
X-Rspamd-Queue-Id: 23B382000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778596624-141340
X-HE-Meta: U2FsdGVkX1+NxhBEilD0ht6AXB5jSwEk/ZaAnafM6lFY01MBiVPQ2AY6MqPXbz8Tww6dn1y6voWBxk3lSZhFhKj12a2td4Da+Li9AoCLWsngXRENDkTS8q9Qb9NF0H920Wq2m+G3KoY5fOlSCUTyuLjuyW+y07nm4oa2onRFA6xAP8tCYdclos3dova8LIggBBz/Nt+eso3/w501oQJ4Fe4q9m1Y2dqbhi0c1ImU9ZaF2mxLZJai1I98FnbPvGBszldZ/sBBys5ym3eDaDzn0c2Wauyhq6Ei1OlAP/x4xuwjLHx8yCu9gz0BYZH3EgLvtyLGGqeR5uzbfUai+UvifKLp056RvtySOk8XgQQa07Axg2UQ9iT/k92eXExWUucNnzV/nBbiHP6SDRZJ+xVyXHoNe7ko+qUXzqX6qJcviI30tayc5a6l/49HC42XYuZsEwKRqrpliOsDoAXJp6Nkr7qj5EEB7m4JUKpBn2LwwOlV2FG4bcwNDFzXOrtQsx+EXXiVu/9xAB245jMK884Fxupi9rh4H4WcDbiKiW3Vz5VbYTdDdxOclDZ9gRyOEVPVQpZbl8hg2/wOS7+Bqj6/TvPqsrHG13WwJX6H8yvSkblMTdxMNzsOI3UbEpjzpnCNuzX4NoOKvC4n76lesHeV6ilByZY9KR2XaEnJb4QFNaX/uLStldS3vgDQvBpUeIDBipTUalR2aoVEXkmc0DDHr7+xqdtAy/1H0lIpgHLtbDKyGGUX+H236S/r/b2rp34UmUmyiVXWe5M6S0k/fLjvx+Wvo2VRrBKA+2VsbNpnVTWM24h/kCC+KGlJms/UYsUsb/b2z5Y2ULVGjl0o+h3byh1DmhB+Uidr6GHjY3lbr8/lSZQC8za49lq86cEHyCIXvcnMzF3D8SFZGT/XopL9FVUXGg4TeM1pzsg9C4da/w2R8k3tMZ/sNVJIxqeLOWYigql0zz95WV3IrHpWXbM
 z9aScdqJ
 ZGzYVzUXCBweaFz2ySTx+IDxL3MfGX6q5MbjXpwEEvuPQmdJWCpoFTE552RfBh7TQvlpMVE+3niO1vRlL986fIePYfFe25vp2YlGex4HOaJQm7gSCykMmOcw0SUZigUFh1Q9M+FI/JHTAJM1i6H8z4iG2MUOzGCpQEXyPfgEAljqlI1ZBdyMqtWXz+aDME+BvUhw9jZSUYeeb/n7XSYW/Ihqzby1sLaiY5LzPQXPZH5z7ojqPg0gVdQ8o+8VkY0YPBxfznVzXRqYInlsoHB+3QFEwF3pXL1J2L07+Z4CVmEIHjKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add simple existence tests for data probes sysfs directories and files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 48 ++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 83e3b7f63d81c..1ac3e2ce8e448 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -291,11 +291,59 @@ test_intervals()
 	ensure_file "$intervals_dir/update_us" "exist" "600"
 }
 
+test_damon_filter()
+{
+	damon_filter_dir=$1
+	ensure_file "$damon_filter_dir/type" "exist" "600"
+	ensure_write_succ "$damon_filter_dir/type" "anon" "valid input"
+	ensure_write_fail "$damon_filter_dir/type" "foo" "invalid input"
+	ensure_file "$damon_filter_dir/matching" "exist" "600"
+	ensure_file "$damon_filter_dir/allow" "exist" "600"
+}
+
+test_damon_filters()
+{
+	filters_dir=$1
+	ensure_dir "$filters_dir" "exist"
+	ensure_file "$filters_dir/nr_filters" "exist" "600"
+	ensure_write_succ  "$filters_dir/nr_filters" "1" "valid input"
+	test_damon_filter "$filters_dir/0"
+
+	ensure_write_succ  "$filters_dir/nr_filters" "2" "valid input"
+	test_damon_filter "$filters_dir/0"
+	test_damon_filter "$filters_dir/1"
+
+	ensure_write_succ "$filters_dir/nr_filters" "0" "valid input"
+	ensure_dir "$filters_dir/0" "not_exist"
+	ensure_dir "$filters_dir/1" "not_exist"
+}
+
+test_probe()
+{
+	probe_dir=$1
+	ensure_dir "$probe_dir" "exist"
+	test_damon_filters "$probe_dir/filters"
+}
+
+test_probes()
+{
+	probes_dir=$1
+	ensure_dir "$probes_dir" "exist"
+	ensure_file "$probes_dir/nr_probes" "exist" "600"
+
+	ensure_write_succ "$probes_dir/nr_probes" "1" "valid input"
+	test_probe "$probes_dir/0"
+
+	ensure_write_succ "$probes_dir/nr_probes" "0" "valid input"
+	ensure_dir "$probes_dir/0" "not_exist"
+}
+
 test_monitoring_attrs()
 {
 	monitoring_attrs_dir=$1
 	ensure_dir "$monitoring_attrs_dir" "exist"
 	test_intervals "$monitoring_attrs_dir/intervals"
+	test_probes "$monitoring_attrs_dir/probes"
 	test_range "$monitoring_attrs_dir/nr_regions"
 }
 
-- 
2.47.3

