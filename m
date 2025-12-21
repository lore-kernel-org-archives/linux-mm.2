Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8774CE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 04:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0FBC6B0089; Sat, 20 Dec 2025 23:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5F76B008A; Sat, 20 Dec 2025 23:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBF66B008C; Sat, 20 Dec 2025 23:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADDD96B0089
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:00:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5656EBB2AC
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:00:49 +0000 (UTC)
X-FDA: 84242127018.30.447CF25
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9345214000F
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:00:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XfUd+49C;
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766289647; a=rsa-sha256;
	cv=none;
	b=hvgn9EX5SCnX8mNSQxcKVv9bUdbwPFLmSTvTNvc9QmVsl2qE4gUPQTfrLwL7+watN8+fbV
	qa9fxiQTjKD3zP8oVI0vPHXpDQrdlfDQU7qPn/NSSdV49VijH/+bskc0Qz1t5qAbVOAhvB
	y/z1BA1QKD7+KVjzKHn5kVCnbQUXbcE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XfUd+49C;
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766289647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Iwiwi0KTXOWWtzFhZ5xpfUZeHt5Hce7t6it8UicZpM=;
	b=dkP4WV4K6DvsZOUZ2o+jhjJGFQSzPAAYvNsBT+qM+bFDRvjiDyRar7aYYFYAfRDKHTmXvZ
	KVWttp/8gQ28IOJXii8wFcaYccJEkx8gGEkzSR0JaDm/9Gzi3smaHhtLqlAqi8qsRfsfEE
	M1S9+gqTS1xOcay9gEKA+uDZQj6I7/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766289646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Iwiwi0KTXOWWtzFhZ5xpfUZeHt5Hce7t6it8UicZpM=;
	b=XfUd+49CqWcqOgQREdK1w+O6Wl7oQvJH1THOxPZKwAyz8kOH/oc6tTbiK55CG2gQlQY3RO
	aVrJHbQNVBGqF2RT0eQf9EyfPM6p/U3UnfH5g2zlIgh5/9jDDM5TtQRgzaO3OhsK/VeQRu
	dI8lWuoD3KIc+5dE6VvCxa/VjHeWETI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-RWfc8m6_MH2csYwq5VBgKg-1; Sat,
 20 Dec 2025 23:00:45 -0500
X-MC-Unique: RWfc8m6_MH2csYwq5VBgKg-1
X-Mimecast-MFC-AGG-ID: RWfc8m6_MH2csYwq5VBgKg_1766289643
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F3AE1956088;
	Sun, 21 Dec 2025 04:00:43 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51D1819560B4;
	Sun, 21 Dec 2025 04:00:36 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2 2/5] selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
Date: Sun, 21 Dec 2025 12:00:22 +0800
Message-ID: <20251221040025.3159990-2-chuhu@redhat.com>
In-Reply-To: <20251221040025.3159990-1-chuhu@redhat.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9345214000F
X-Rspamd-Server: rspam04
X-Stat-Signature: g3i39a7hfzfzoyzrhz7moxxp634rbc3y
X-HE-Tag: 1766289647-248451
X-HE-Meta: U2FsdGVkX18VjQ9ZdnwPTgRfBfN/73wIMxWqO0l7j82lh3M1F+g+9L87T0MI05radg6cSQQmoVtl8Ec8G9ZSDmAgvwAk7sgKKAbZ2yQoHzSg9+wIZD5iK2FNfNuUXTgCGmNtaBAc+2NeE3gjaFu5ZBpKoSelOiBWiAcv0r7fZH6KiDtRAVoqZehajrRiPxBhi1Nf/O26h4BzulP2kMYu5epNn5ghcmVVk2MvmF4jCcTej+5gpRyCwL0UpNKAk6NOw8NdtdALEr5vlCjk103+6ULzOJU6FnYOjc1se66PWofDxv298yfAxASEwIJjelu6AVtHFR/xao33U8yavUGbqWj3xTS5V+dtxF+NB+5d+L2pXNUAN0oiytlHwgczkCR9fLDNcs6+NPliWxAGYy/xScMp5f9BUG4jMBmJl0qUcqE98IjdQjP1MRm+9t1yzvIO9M/G6LMUhPxsRY25bjyTrmS/O9m0HcC73retUAlI2BEKveFjaJ9nKR2D3ZP6gbMo02v3wQmYlsXjH9HJGsR1JCb6WbEBMN0x8aHLU7EruZLRZNLR9acOmgIt7TTUEB+B5YldOE5z3Nhd88c1yW4Rtc0+cDFNm8dhlkTzgPuIiuVU9Zm4gnxDXzCWXGQL07k4LnFVeZDKIKh4HZtJmcjRoF971TofVZEX/0xJR5VHfftf1vFtkbisTGP80GU6qV/A2bEQFLMAsDqN4jTNJPQSg5SEU7S86iYh8uSBbnBT7J9hrkj8MC8BYw037chsW6/WrbZF0K7yc1ulSX+arSlQ8ZIjbBtCGID16DJh8eXvFsOSknyJD9PydeiMaMWQW2ERJejDj9K4VV8bZd+nb9h2NNsxR550uyljKmZOE0QQqDciKfEH2+Viq0P5HedWReK57QZBlz2yIlZgbpBDWvoqvH/KVj3Crnvbd7EGvnviTdQP0gWrmxOh0LUxeGOgiZoPaStdMcYoT5JXtZw1/BT
 J1DiMOw0
 m+NL/StKwd51T3kadxTPqi2Gt3+0NTo9SjjJNFP4C2iNrEGDWB5x/8+zuyo3o5EqIpQ9HnRm0ErCnIHKirKyohRBCjm2M5U5rYPeYkCJ0JAL/n+O4hdFVt+sot0kAzTFG1pRRvPxcQxQbXfIcvKfe9NH3O5VoDHoSoWTytfuTvVM+1sgalnb1HjpLu64WzKs7l4nTw97n/RTNr+PoFmdDc37cBmn+K40Ya9Z3jP0NKvhBVEsKa/eOKoBRUBHOc7Fq5jNu5xwGzaMZTeV4bwxJRsaPoBOPCyz8GJ4uaW3PJholzbOYUfnNdWpyJ/GtOiDFHOBbPhWg77VmmyKeaDzq3n8t5aBbu4VIq/Vue8AOf2opprkmEXI4cz+CPo8LJCDeAtIi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The va_high_addr_switch test requires 6 hugepages, not 5. If running the
test directly by: ./va_high_addr_switch.sh, the test will hit a mmap 'FAIL'
caused by not enough hugepages:
  ```
  mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB): 0x7f330f800000 - OK
  mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED
  ```
The failure can't be hit if run the tests by running 'run_vmtests.sh -t
hugevm' because the nr_hugepages is set to 128 at the beginning of
run_vmtests.sh and va_high_addr_switch.sh skip the setup of nr_hugepages
because already enough.

CC: Luiz Capitulino <luizcap@redhat.com>
Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/va_high_addr_switch.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index f89fe078a8e6..a0c93d348b11 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -111,8 +111,8 @@ setup_nr_hugepages()
 
 check_test_requirements
 save_nr_hugepages
-# 4 keep_mapped pages, and one for tmp usage
-setup_nr_hugepages 5
+# The HugeTLB tests require 6 pages
+setup_nr_hugepages 6
 ./va_high_addr_switch --run-hugetlb
 retcode=$?
 restore_nr_hugepages
-- 
2.49.0


