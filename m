Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD784C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4AA56B00DC; Tue, 30 Jun 2026 10:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85E06B00DD; Tue, 30 Jun 2026 10:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75106B00DE; Tue, 30 Jun 2026 10:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83BDD6B00DC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 120B51C356A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:49 +0000 (UTC)
X-FDA: 84936782658.09.6FBF60B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7929C40009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGDSF9eW;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829067;
	b=A8o3tfn3oMJGmpo1Lyw8d4Dsp55pYh7sAGo9fGPslobspyRvqid7w1tLUM+fsqeGfZZ4GX
	TY40vaVzC+12M9X65mNPZBi6nrQDjySQHYKhdDYZu1RCkm+F8Xtjam2Or/Kz648+lRaU7I
	7WxqiuQvlQ8fBbVkS53Owd7CTTyjrmQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdcCZC5+16+6AUY31I6DEOKh1l2S9+UDKyW2frHuiC4=;
	b=fIR68KIfgD4P52lW8TzY6x0bk2cj+3y4mzRh4Z1+ztT8zMhrSrR3WI86PhOC5c6yaOauN/
	hsrld7Rk1BK83w1FnMre/9S4Gjik8X/RN2ngCjFv99hCjfzCFhrm93CZYhQYyoucfCru4y
	HYqMwbiSg1QE3DBAsZH6mZMf6RXouTU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGDSF9eW;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DDF0601F7;
	Tue, 30 Jun 2026 14:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887781F000E9;
	Tue, 30 Jun 2026 14:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829066;
	bh=TdcCZC5+16+6AUY31I6DEOKh1l2S9+UDKyW2frHuiC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGDSF9eWezY7AOmV3hce+Aatjtmmvb4UhJ4cNMn+ahNooClledOIQVYD5XakxAxU0
	 jrGkvaDMtG++MkZw21q1GjavHnrDLzgzRmdWbcjF2nnL1mD6UQMiWUYvplegTiBNIC
	 TOvSzhjzn216+x3N+Jn1TjsAKlAFzqGqvu9O7t4AKK95IyDHblhteFOEi0KZ4DG9UX
	 uI7MRNuj/nwASfjt4c6jmnAX94f/8cubbslUAq9RTppXcNYMXhhnJZzIppT2e/ahZi
	 ymIplfq0Zexz9H5UhbzjplxYKWOQShp6dBtdQ0ONner488g7z0NvmwUxGgRaFSG+Oq
	 C/Vb2R2Kbu/KQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/11] selftests/damon/sysfs.sh: test all files in quota goal dir
Date: Tue, 30 Jun 2026 07:17:21 -0700
Message-ID: <20260630141726.92246-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fqhwh68ipiu7ecu5c4gahqgejdtiq6y1
X-Rspamd-Queue-Id: 7929C40009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782829067-224282
X-HE-Meta: U2FsdGVkX1+llSSFKYKyZaATkpasdrIX+O8o3KxXjvN+WCGYzFaeMW4fNkkg3x/8Z6kP2FQcchj6BDqlPSQFUWQ7Vpxt2OY4LA7sB0QqUYqbW7r0jI/gtBEilZKDwnui6/FoSdUVOqzh2nJ/5uKQ55s6UfLfcjWBj+Qdy3YU22MDhWBhRhkRNI62VbU5c+oTlIWk/qUEww9Gh8dAjlLbhoVpqkEj9fIYcDUnUPuSok3mZGOE1CQP1RwcBieWAi/inWykmAfxbPSYnss3Npd7X7XpAvr0Pj0YvcAaiOgXRHyDrllccSbRKpgaTBZwt34kvB2usukKr1r/WPWgROq0g0Suw6EOgKeogdFhqf3RfIUqlrndPOp6SdN/tae6SopqCruEjqy8ZS+110ZBmzoBdq8Pmqfl1XUImNaMyMqfaczbg8g1V+p2RWAKfLoQRTACEl4njiYypqTtxisCqTgD+D9C1M1ublG5KSzSzRKs7S5si19GWpPExmzfPqW1oZuLulu+ecCwP774ByhtAEJvhB/rPhy0kS7ypdqit3iyjUOgBYgOxIh7GZLU65HX2180+h2rrPA5e07S8Q3HxpWvH/HLwNq8ThbLrjS2aMADjSLFVb34UlDMfe22O6vQMJhRiuz3E8ydz5dmD+n4CMUii+RC4QsAVaTbOqqoSVimwGw0W/CgoHpTpKLmnhUqd/3kTt9y8jJI5UZz/MsORhEJ6xxGptRcP+pTPeRemduj9Qadx31dd6eOvZG+etD05HDpRHa8yWU1StGrfdHuFPGEaow+dAvPWGCXanqKrrZVYcoVz9kaVEeOIXPcw+umuKJRRm4LkYjnTY2FrWdWwvmnLCBZifzlPDbAMBqQXYWW70pyTN2GvqJP3azr+k65TlqoZGxKm+NULWpNNhSHfwNJfrpfemJnYz3OO2kcU0W38Igf73nG4WI4YGNWP03vsoEjmZwna4lHkQ9oA5RYbAE
 gBkdpkUq
 kzD6Ip0IXkSiLGdPcaf30pTU1xKP/xcZze3pHckXwwy6/zgwipPRXl3704DRUF63+mpD/eNwJNKjnJ8pdtdBNSuzbULSuKi3fguP+Eijt++KH7yVHv9Wvc9E1ZGKFpyYV4oQlxSEAcPH6t0W2NnTJUIQEPcUdDIMwQ+cb4K6UtsYYKyiybohzX/HSvafa6CxZaEiZiki9KtsDWc0HD9Y5WPgarHKvQzGC1T2DZ17r3cz3R5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface for DAMOS quota has quite extended since its
initial introduction.  The test case for that in DAMON sysfs interface
essential file operations test (sysfs.sh) has not accordingly extended,
though.  Extend the test case to test all existing files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index f8d2092be004d..b43deee60fe95 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -199,6 +199,20 @@ test_goal()
 	ensure_dir "$goal_dir" "exist"
 	ensure_file "$goal_dir/target_value" "exist" "600"
 	ensure_file "$goal_dir/current_value" "exist" "600"
+	ensure_file "$goal_dir/target_metric" "exist" "600"
+	local fpath="$goal_dir/target_metric"
+	ensure_write_succ "$fpath" "user_input" "valid input"
+	ensure_write_succ "$fpath" "some_mem_psi_us" "valid input"
+	ensure_write_succ "$fpath" "node_mem_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_mem_free_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_free_bp" "valid input"
+	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/nid" "exist" "600"
+	ensure_file "$goal_dir/path" "exist" "600"
 }
 
 test_goals()
-- 
2.47.3

