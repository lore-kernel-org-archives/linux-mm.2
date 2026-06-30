Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B53C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052346B00DB; Tue, 30 Jun 2026 10:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE556B00DC; Tue, 30 Jun 2026 10:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F8C6B00DD; Tue, 30 Jun 2026 10:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 992F96B00DB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05425120523
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:46 +0000 (UTC)
X-FDA: 84936782574.24.AE02C88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CB79180003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ATUnj+kT;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829065;
	b=a0M+MD59aaYYKie145LnIh3i/LQk+ILiR6y4QM4au8CEPJVN+lcrzVl9rwKnIQxE4HmDtI
	DZTAbfH0lSU9adqxH1ONQKbQABadFzeLeTgriRK180VHuEn/ngfJ8UMhXk06lT1PtZ71aF
	3P8Vokx0Jsbzo1+pyhpJCcu36K2b2u0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEUf8F4RbIBWLyJQ2G3eW0zg3VzyVrhvSny1dfTtixY=;
	b=u7klps7M36AHgcPT20lXT94TnFErh9jxJJ/IqTp7/C5+aGxXzG2NJSKJ/VLtnSiGZXTYuw
	fPNeOM/TWrZnW6oT010pkNu9/D52tFSrxSX4rGMj+rX9wdib4eiIkVsNlgO5pPNemigBTx
	HQpJ1BXo0jITViBs3/7is5ILCH+TD64=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ATUnj+kT;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F243E601F4;
	Tue, 30 Jun 2026 14:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5661F00A3E;
	Tue, 30 Jun 2026 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829064;
	bh=WEUf8F4RbIBWLyJQ2G3eW0zg3VzyVrhvSny1dfTtixY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATUnj+kTdpVkQ41lxS5ZrlHQGxJMnNnG+8ghrWnxxRmbKnJ6R9n5SFAGEEclO2/Bi
	 Uhw7Q8f0ad3pFRRZL0qCN3X6v0NwDTdEpsbbVI2mP3R5USOpjt+2vzDUexqLgC+7U0
	 rrd1X5jndbIXs3cywSOrn98mRQsuZq/p+nGyW3bPwol6kk9KItXz5YiibNXT8bhLtm
	 70Uq1cAZRao9kA/n4hDfaP26XX0Fd5J0tfFcqaKJcMOUSC8HPOnSua9GnWfFpX0d2S
	 AII4ktWw9oybqVav30+mDS1sq/Ikt1Ob/ZWgR6CY0rHgNHPBCFihaOGN2tbG+AnRNp
	 f4UI/8qM8RdzQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/11] selftests/damon/sysfs.sh: test dests dir
Date: Tue, 30 Jun 2026 07:17:20 -0700
Message-ID: <20260630141726.92246-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wedbyxcxbzrtmpejishb9wisrzazzdb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CB79180003
X-HE-Tag: 1782829065-42588
X-HE-Meta: U2FsdGVkX19ynY9Kgq8XijDWM2jwHoij+eZJry7x+SrplQW/GFLaTYyhnlA3b1tm1gqA8WU+fvSJQCeXljpAY81QzmzgACAXiqjJFgUwyDZb1M+KyD+KT3fro9jmKmu/idIOdwcVaN/DswnCviF8tFM3xnO5V8ttaxAb+tbQqgg8A63qQzAwcdB760txNPO959uUOm6ILrgucD38U/CCoMrhs0b87WVVs162Az+6bE4GRPf3qQ0K/9NXeZSEdfyDj9hbjZTsgSteBNqHBNvqnX8l/ruqILInPgf7ZIi/FkU9s8iYnGXFH1BVy16s7k2comPHetHDGzcqCjZY/T7RB6uHBJsf8y2mqENIC7T56nrRhp8mYK+Aj0ZE+l9C6LuG356d0/i9J9A6qYf8Q2MmFFEyaA8Dd29X2lETbDIL3NBka9zjNd2MqpukQ8fmEFgvYJrNcF8AXnwYUKDU8yQIdIWLJHnNP6vbpJUCUxNLbN3XToBC2WXUSoIbsm2R+8VdbQ3S0pmM8tF1MgA6RxTVJprdTX6kuY9T0DsU1lnD8Tk+tmwfLixS4AMx7XQtob6SyMGqTNM9olR0ixyrHMiNmSJeaYvugTNtOkB+X5H63vfSZuY+/OJr/CE3asuo9L1gIIJCe3qzKy76sVXpyzOCJNo+1xiLVzeqVlFX2ubYyAnGk//jKtwci2tYbqqiKvW55yMgPjTQy1VTqwxSi791rvRSKLpZkMfAE9CjJ7mI2mYJAvoXKzUU5AUUnf7kpSiFpVKjL8YA8GNmPTRiM0c7BSsr1lcbWWBvjv+zboRLRXZrxqeUlnUiBmH/GEMKW48tfcBTaF4q5tL5hJjv2aXK07FV0WCZFraHxCrvhgPlMl4UbRzy2a+R0sbIzUl3F7XtqHOvI8H6U1QVP91K4IehoeSmDIA6eVZOs2mIxsnDPJ3KBPtGOKNQikhtpSd2xm6EvocxFA9tbT0W7em5UVh
 zqEu6DTi
 RzKr3hOXBcJgKl145/kJ6SGbfa0I85Ur2EXiX5uVWTDF7rviNH37vdxehX1wX+NJuy+gE/Koryi/4EKzqVHnwwoIvIVVgjRpnJ1TmaVWg181UNOeX7HvIFSuWGCfJqLQVWfsSFqJCpDYV+O/qpEv65xowivNMDgeVIrW4d55gSVhvaMNQkAbtxTV6t350nL85wIZo4h1807WM4/vFTbcMwYggLEjgPEaBlZCzYzBQrzU59yg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON selftest interface essential file operations test (sysfs.sh) is
not testing DAMOS dests/ directory.  Add the test.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 78eea0d13c271..f8d2092be004d 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -99,6 +99,29 @@ test_stats()
 	done
 }
 
+test_dest()
+{
+	dest_dir=$1
+	ensure_file "$dest_dir/id" "exist" "600"
+	ensure_file "$dest_dir/weight" "exist" "600"
+}
+
+test_dests()
+{
+	dests_dir=$1
+	ensure_file "$dests_dir/nr_dests" "exist" "600"
+	ensure_write_succ "$dests_dir/nr_dests" "1" "valid input"
+	test_dest "$dests_dir/0"
+
+	ensure_write_succ "$dests_dir/nr_dests" "2" "valid input"
+	test_dest "$dests_dir/0"
+	test_dest "$dests_dir/1"
+
+	ensure_write_succ "$dests_dir/nr_dests" "0" "valid input"
+	ensure_dir "$dests_dir/0" "not_exist"
+	ensure_dir "$dests_dir/1" "not_exist"
+}
+
 test_filter()
 {
 	filter_dir=$1
@@ -225,6 +248,7 @@ test_scheme()
 	ensure_file "$scheme_dir/apply_interval_us" "exist" "600"
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
+	test_dests "$scheme_dir/dests"
 	test_filters "$scheme_dir/filters"
 	test_filters "$scheme_dir/core_filters"
 	test_filters "$scheme_dir/ops_filters"
-- 
2.47.3

