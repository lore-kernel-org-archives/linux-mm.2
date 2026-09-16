Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F2FAC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 20:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF2A6B0088; Wed, 16 Sep 2026 16:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A900B6B008C; Wed, 16 Sep 2026 16:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E866B0092; Wed, 16 Sep 2026 16:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF656B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:44:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F101D1A014F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:44:58 +0000 (UTC)
X-FDA: 85220804676.27.837E47C
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DDB71A0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:44:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=jCHyUCJr;
	spf=pass (imf19.hostedemail.com: domain of eva.kurchatova@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=eva.kurchatova@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789591497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XPqpgfCd+NVaFwI3tbS5RTUSF1zYM8sxZ4o4/8h5BXg=;
	b=kxIxTKBABAnJZOujXIWZJuYaUCuRvo/XywEaURFDnNVXQsYfuOphT/lFdtN72pXuj43XAJ
	D+vCwE57yMBamxkaCagVPdqcj4IseZLetEd9kjEK6nOlSHjenbRBgDfHsW4J7fLtaGvhu2
	65NaTrgBdUWhsUAuvffc6HH5Y5JjLi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789591497;
	b=p+xFdelAcO2CtViSEQB5F6RE09XBoICIYh/bXD1sc1un4CaOBIBH4hRmtjYvPSktffBhP4
	Zeh98sLxH6xRrsMu3DX+OHt5ZbCUjPiN8KkFLnNzG0mxxmbhdsZastXUam13dD9CfEjugv
	KCRTKR9xF5NhiYQ4zYVh5xxxaataJrk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=jCHyUCJr;
	spf=pass (imf19.hostedemail.com: domain of eva.kurchatova@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=eva.kurchatova@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=XPqpgfCd+NVaFwI3tbS5RTUSF1zYM8sxZ4o4/8h5BXg=; b=jCHyUCJr9WhX
	ih7kzgf/yHidk9RuChcbpZvi+tVtDRRxw08PY6vidW74MKuku5q0JfmzUvyO5ETx35QwCz5jUyh+K
	MeHdDYGWmtITH7NMHX9LC7Kr9WGpl2lE+dAGryNrZZEYwAbEe1l48wsj8UUtPkURapQR2I5hANXGi
	TJpWXTjeAQbDeC5xiBjxFHcb6BkcxGjckC9bw7yLLSHBN3GCK7vZD3w+3q4ywuAU4Z2vP4Bm6DzCB
	147Nz2GA0tT8gBh2lI9/DoEldBjb2i8IG1AfuVIz8M5PzTchHs1uNFrZqG9j53W1i4t/wTKsHYOp8
	hIojTPDlMTxpIHxgm8ZJAg==;
Received: from ch-vpn.virtuozzo.com ([130.117.225.6] helo=LekKit-T14)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <eva.kurchatova@virtuozzo.com>)
	id 1x6wRz-00CfhM-1M;
	Wed, 16 Sep 2026 22:44:41 +0200
From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH] selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode
Date: Wed, 16 Sep 2026 23:44:31 +0300
Message-ID: <20260916204436.821378-1-eva.kurchatova@virtuozzo.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DDB71A0003
X-Stat-Signature: ary5do8hzfqk3gjrew58d6inbcbbb1xd
X-Rspam-User: 
X-HE-Tag: 1789591497-77045
X-HE-Meta: U2FsdGVkX19SJEfI/t6B+6nixXlrlQftQ6qU/gaWrqWhGyjS0wf5n9o5BU6G4r6WE/uKVGTYwQxilm/ZfuTbOkTIq6OV3ChZVSuG9/FlWlQCghcj39sf8KnpMwFKCn6ucjYZ6PgXKOAOsH8zEX6qQUYgD9Dhv6WxW/lNcd7xU4kS0fUERmiqd4UcrT6ARm07eCpaAp4R6nW/M3xpfVuBayU7jU2RvodKwGsBCtInHM574q8sml6vMjA60en+QB6r+ki6r0maaZOAIIOSygUXLcuNf9McEDwP4sJ5ijUVnLW861VlEk/1Om9xGzI03ZOsrtKwAaiszdgmjgJnQzscOffI++5hNZ6+MPjdcl2rtsU9tOEnNK9/E9EHeSbn3h99mek4wvOsJCKjDNgQ/i2bywOTtV2rH4WjE/PLXlcRaYJbRiPQ2r0khXhrC7i2JsCZed8b+KePPfbZakIBX5v4XeDvePUzjNXZGW2pAwCBVmpBMUFkEt9lgI3OiFkY+4bgYkwJaOL5VOU0MwCqEBcUTm2PqQYIpqZMAgirgAfvLFcTnUArsEDFo7MukxpVpHu9UULIU3Cz7EKsikdYTMJGAKPtv7BhSCbq+1BZQF0BuXNgn+9wv8qwcUybY3vmuvnlQIYTZ0DJqK5jrl/13Hx+SHVdfWLI1uJU4N90gHApzf9cZ0eaG3l4xMWqOsBpxj3p0ylM5Mz+rVYs9+ly0h5X+199e0pOWvRk489czqbnFMpQ1TczoyHCkf4i0Nx2mhdAEzktWuikrR/FrNTTAHRfrVC9YFdaNWCVaVDPX1irBkYIG7Sf/R7IO4xC82TMzrvKXa/SpCssSvsg+CuLYqfzLBNBO2xuza52EulOw8oKLavfEYJWxFqPdhAur7Uui8rBd19NiqvVDTHC507Oa+b5T26dUrM5xiCQN4UqfYV0nqpAyiiHB+kNKBLgVxLJ/IBfj0OhcyZ6iucudKZr/Sb
 vat9odkP
 u47fbEOkjhOUMjzwEZT7+8tXlf8GprrPWtxYAvCdBmNCIiucYujFe6jkICfO05+jIsb1gRaumtZioF6jOREG4xfWEOHWKsp8bPFvTpVTXzH5JMgfYNYNVZO6qDATNqTsCksE5aXYmnWj/ZOksuUvEDZ1s2te1XE+UuAe4fe58T1JQQW8Zwru1tNWXzuJPyseiR5XqzhQjR3EVDYUIs+J7Mw+yggOsFvQmsh7WHX8hi5KS21jjf9E39anClPDsBLMsfR93BD3OyS3IWwAoUq2tELRzZNSdWRJruLlUGzybR+QQm/zy3GdxcFnfFDSHPT2wubyr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

O_TMPFILE, like O_CREAT, needs the third argument. Without it glibc
refuses the call at compile time as soon as fortification is on:

  In function 'open',
      inlined from 'get_temp_fd' at test_memcontrol.c:33:9:
  /usr/include/bits/fcntl2.h:52:11: error: call to '__open_missing_mode'
    declared with attribute error: open with O_CREAT or O_TMPFILE in
    second argument needs 3 arguments

The fortify checks take effect only once the compiler optimises, and
cgroup/Makefile builds with "-Wall -pthread" alone, so this goes
unnoticed in a plain build. Building the tests with the flags
distributions commonly use, -O2 -D_FORTIFY_SOURCE=3, loses
test_memcontrol entirely.

Fixes: 84092dbcf901 ("selftests: cgroup: add memory controller self-tests")
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 3a84d068fbf3..0ed82347044e 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -30,7 +30,7 @@ static int page_size;
 
 int get_temp_fd(void)
 {
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
+	return open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
 }
 
 int alloc_pagecache(int fd, size_t size)
-- 
2.55.0


