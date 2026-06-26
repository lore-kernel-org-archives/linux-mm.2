Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39702CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16846B00E6; Thu, 25 Jun 2026 20:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FCA6B00E8; Thu, 25 Jun 2026 20:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967DA6B00E9; Thu, 25 Jun 2026 20:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6604B6B00E6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6781C183A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:11 +0000 (UTC)
X-FDA: 84920149062.03.57EE00D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3267E1C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqBzHIjB;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433030;
	b=phXInGZCdgJOngzTcnWfEpfDLkGozH6UvfwyOIaoS9e8+XnYqlHsEat78oi/COqnWokUrm
	0tzUDjesBYF4wBIwLhbZT80saFymc5+qprHnUzYLG92snv/tclbNy6K/P28o55lA1F2+Vr
	thWuWc9LnBPPRUi8lC+QTzmNnA5t2cY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qRUF8cwtcmB/nbdsXtxrh3TaDK04SACL0YdAxUm/I8=;
	b=XroxJ6bSmFfeBp/tFXEBCzN06+RbN4wp308cjxEVl62E+/cMxa7WoAzs7z7+8rueRrrAk/
	CdCHu7useY3rziPztkqoelKKQsfP92lBTX2Svm4BgZBDUxHfPK6oIMD06J9TMuek1glWdS
	XnQza9t9opM41xQMraF1AUbPKKDjO+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqBzHIjB;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CAD1443D0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC4A1F000E9;
	Fri, 26 Jun 2026 00:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433029;
	bh=/qRUF8cwtcmB/nbdsXtxrh3TaDK04SACL0YdAxUm/I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqBzHIjBTACgUQRKvnjym4tU9icnx+QDF2K6jMeH7lDOrvCFNMfDKaSOK9JKIVg1N
	 Bf8CfJ6OUp3r6ZzhFUZdX9lA3clmvogOzrw2/PRqZpwDqIIGUfSWdDCsMQjdfiFvfo
	 5GGk1jmhQQ8wLLBeV/oHT6h6K3odVR8aumEalB0gMnCsCfH4YdhURgWt8qEXixxZ2o
	 kXEx71WLNgK0TJL7RLf+kXaTaoD31IyGh3DA6J6pwL+mFXPgr3ly2XB9AufqarATP2
	 lWjyk3egT6VedV9TH2somhXwX+KxozUiiqQJCW+v7QtFk2rf8jF/5cXCZ17capZCKU
	 ldR0hujJlAI4A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 06/11] selftests/damon/sysfs.sh: test dests dir
Date: Thu, 25 Jun 2026 17:16:37 -0700
Message-ID: <20260626001644.85825-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3267E1C0009
X-Stat-Signature: nmd1b8bpsfqzki18kcp1m9t7qdj6z7im
X-HE-Tag: 1782433030-58051
X-HE-Meta: U2FsdGVkX1/cnYEsObOp2sONnF4T6Lzcre3hu119AcsQlQj67RKfSv3DTKOSL+sI9N60r4UD+Fus86kUBiJUxmrSlPLlYwIswpoEPnbmKJIP8XNXUDeJ9tRc3lqbk3cy/SFYjRu2w0PzQLelQ0KrRRV+N9Zt//B81J6Zk5kVTZN9NhJomS4dXG3Zm8TSJHlaYZXMD8qzc0T56kxUEKFEzKNiyCZD0Zm1DCCXIaJ9zws00mCJHrw+axGfAPdzadkZXDkCFgXQVBucqdqyxxX+SQboWTjo4WsjnVPlJzEIk1rcJwysh7Ed5ZgBs6i3DQpv4MmiZ1kP9GtQ9PZAUJcRb2X/ZyQR2CBg5Om4nQNK+rg0dnttAlv5DPBEs3ZXYPLHmh7Vv7wO+0zWx9ZfQKWKoPBunIDlLBz66iZE9MBNCHClIx/zKbUXdNKmkzaey6GIwe36+hS/5iosd0yNqeMPKsnssOybO35PY+5JeqHX1F/s+lYO/T0D6/eLffM4DqEWjYX9d1vZ4qn7WsiroRZXmJfk2kpqdvwDeOKPrdFQzBjBRx6DrPBvTxlwWK3t5Yhhm+ANPGXrWqW/Pe6a0/42raFPyQwDIjUMebqsnAa+aLbaN4VCofARCMjtu/kBwgruseljh9o1nkChe0Whs8gGV55u7JikKpLoow7LuhEropLxCT7HddAAX39nqsHFjiwHJ+dpuoCpPXIpUfupC1pyDRObRkGVbY0zFgu4AGm8n9EZJ8B7DtmWNE6sEa8MzYvCEa2eg8aylfuQBTTm+FKNrB37qEPKD3QaPY6EJQIHtZgCS7JpSGXUAeXh0qOhYhC5j/1tsc1Pil5h3z0yWeBTZCI9yWqAyr9sxPI8/oVHH4stWawtckgtb9Y8KxctlwcNng1R/as5PTp9U+l1ngMw5gBzVd5NDl0VLrORsoGPaT7HrwxhGXuhVSztilUvx+twEepQ72tLRzuq8hm/RKs
 QHbbqtSJ
 o2KQsTYm4TPvaR+IyWAXssNQ7LVA64FTK1yBIAH8ctqseX6hBGbyeRfCe75ggEIltGc2mEl/5mxTKzd7UmWoC5JQ5+wzvyG85M1eEDjBy5cciFt48cow6rS6zYy4bCQ6WZD10vGC5ZtIYvz+CwymSsKYPzHLSinHa5IroHtCYLKfmsUon4SUiSUcPmRGkcfuYEZqO10WCifcV4AkIpz6QE7lTJAGoD5JdwQAAm/LZ0gRIS9Zb36x7ESIO1fNQRgO1X+KJ2wFe6c1dzTZYpHqsudPm7AGC6eZTojYBCUqnoVH87UI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON selftest interface essential file operations test (sysfs.sh) is
not testing DAMOS dests/ directory.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 07a33995be852..b88bf7b98d7f7 100755
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

