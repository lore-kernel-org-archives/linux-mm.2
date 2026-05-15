Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58B9CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164086B00A4; Thu, 14 May 2026 20:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137D96B00A5; Thu, 14 May 2026 20:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028C66B00A6; Thu, 14 May 2026 20:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAA076B00A4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 959BB1A0689
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:56 +0000 (UTC)
X-FDA: 84767809392.21.6D8A4A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 114AB160004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBvWpo62;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfeX6x/Ktb3KmB6TDO4M5QdJKq9cy8SwqCGik7CGYn0=;
	b=75LdMfbKIlw8unn9Uvqg//EGe4ZEAw5/W/BcuXElStNiaQaFlGnm6C8K8w44I1BmO6kY+4
	yl7JjrjAGWbW06MG/eNkCX+o1RxkVZai+DOXBfL3LbkieitTx12BBpv+tThpGeeG3cVBun
	5bRvsgNSLVzEvGwR8Gjjddbm3HiDDmA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBvWpo62;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805895; a=rsa-sha256;
	cv=none;
	b=XfMF1dqYpIGe17SbWitPfPoILOIzyajsq4XY4tb+EI87W3CDCBj68Jj2D4iEyykjKges3H
	J8th/B8qpkUHbT/VhSir5X+QjnlDT9DGFXcD+izEUbh3/Q+oi0EHSqNDnlvIaGo//tt13w
	2q4Sm1FR4+LZCuwsBYqcDccc9uYeXV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 808C56132E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EEFC2BCF6;
	Fri, 15 May 2026 00:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805894;
	bh=EauBIBzKjl6rFCRlEGSo/s6NrgLL9HoVh8TIqUsq9vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBvWpo62mOlO3ObITlgIcEpOhOiRt8SLNFUK5KmPQv8v8WPs/7Mu/dE7LDh9WkapF
	 J5ubOl0wKlyp5EO+VA8fgamp8Uj1EOWqho3sQtQqlamiIhQl7a4wce/OOWe++3FN7e
	 HOviASILp/932wzcqVp7a76JEXl9CXy8NiJmpkEQP5Vc8H1sOmqus75/enTZlm28HJ
	 31ofJkGdnD0eS1PYJ8kR9B7s2do53LtQObNudtkBM8NUtcd7dMzVxaXUOr0k0O6D3w
	 CKXw9JqxDCyARlrgEMXFzTHmWr9Rwo0XaCrdDGiEbyKUmvV9EUiIDNCSIE6Yi8zoyo
	 oqpMw5OaEqltA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 19/28] selftests/damon/sysfs.sh: test probes dir
Date: Thu, 14 May 2026 17:44:20 -0700
Message-ID: <20260515004433.128933-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 114AB160004
X-Rspam-User: 
X-Stat-Signature: hoaaftqhe99ati53r47yy7pqtpqxskj1
X-HE-Tag: 1778805894-574074
X-HE-Meta: U2FsdGVkX19bF+SuktdZ5f+7w89kv8OHkS91MN2KnZMfweGDiIX1jUxWIz1oRGnJm27oJnmLVvNPq/Nt1PrWA68WVPwTi0ELpaCUOsbRmCCwOJJnW+bOsjr1xEOf4sidQtiwnJd8evIHTRcI5kF7vc4nJpJkTlsfN3A+Wa+jR6FitsgG0Z47DGYu/GDVvNuOMTn4jCxHXX6cMVuh2AmsIjeLv7FA+WA01ht4lOPEFR/BCEW4xsl8+MyV2ZyoSMOk8OdpS+sdGoY4hG58Ze4dBDY5Yr9MfRbQwY5i594QlGhxrmqxFJEdYIKD2Ibi5RAdxilR18OPShBUuNNub0LwbKp5kmFwblJvp1YmjuowsJiLI/uGGaRYvYhIIWjPiJ9hOgnLHrSZJIzujJdprn2abdTQK3z3uJFbkHJql6ziZVMsZFHbCVY061GmK66tAdfCDtu9ldEszwRoedTt0wD105t9603MiyUn0rUp5tF/8iawk2y9BL03PhhgIKtCZGj72DCrJiiVu5j5oNMC+itlb3443AwWXnPk6Fvg3T0e7FvKTON/Nftwe6nE8PSiIcpU0JTn85z4+lUDp/K+X05Rh2283wjHQZNok7DJPXc2QzxsqnA6v6y480kq5bP26bsIAPRqFDIT0Q0rMpFv7CO+67cFGRLMYzSczQ253pQzjg5WH6wseoQv+lsicNbK0Y58x1b+oHlTyqGNDcq9CQTETG2IDL3ymydmXcK/d4OewWwaknvQRErZdXivcwaKv9LYwobWKO83nLmmgOXgcOiuKQFu9kDFB2y+dPJsJsDbGcKRvFK5dPjAbCRPtKk5wKnfwZPfsrLUU8McpDTcCGgls8EeH08va6zEX6t/DPGOQNARQWj4GLoukDorRopz4j4+izNbgeTM2JY3IJBFc5cyDL9Kvvw+c4skd1AAiebuyNnzaUqnEK1vphUy2ck9yyK5eE0OvSfBI+l3ZL+wVFL
 1w1SohXx
 IccxaVa4sSBy/1Jm30v0x+b/5ggpIFJHHoGiDnnvioXQ5lt3SZIZICUKUDDuT7EVB81+w9JiaFd4GbNFrwcBl9r0LzcxacwZkhsnM0rcwI5XNAUF35axjaiY9h6sxsqb48zK/kuTX47gf9MnAsg6cUH5w/Tkkl20Pqh9ziQVR4E7iqGF3E1Bo2cFv9qxu7k23h1eEYe6AdvN/aFS/Elbz7sXluQsyG2HREvvwLd1IEu/gSHJKyJQsDpLWmDMFfmix6pS4+qHTVq/ENd8PZKQMP7Ub419GnssLSH821woZje6cff0=
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

