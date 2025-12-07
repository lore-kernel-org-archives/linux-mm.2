Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322D1D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 12:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9D96B0008; Sun,  7 Dec 2025 07:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A796B000A; Sun,  7 Dec 2025 07:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87FE16B000C; Sun,  7 Dec 2025 07:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 754496B0008
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:23:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 819CA13BB60
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:23:13 +0000 (UTC)
X-FDA: 84192589866.09.DFBD769
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C79D32000B
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:23:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dx1b6V0Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765110191; a=rsa-sha256;
	cv=none;
	b=BEWtig6zOhmI04thBmKBC2kJI5duwB0nF+lXsv72IBa/HbfKn6F8lKrWsYuilThHlli8gY
	TvrCpUSgVTDNrxbcqJxVqD4+vyZHeaNOI+Y3NL/kRR9qL4F2cZ+0CVOZSoUGZaXRnriVf4
	vG4wVImvD/0hFha7uCaoYrX+p3Aj/As=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dx1b6V0Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765110191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIr4yWg3c0IlqDRS8WOEFXdZ6WpgTutD/obofZ4OxYE=;
	b=UvQRZGglFPDNQWLKQd24bmOqmqGo0paDr6qkRDSOYqnZi1+M0d8/paFTbbz19rY5VSG8E7
	ryVJUN1imysnH4vW4Z2xXf9xVCHPT5EVo/kX6G2kDYnGwolGgrcbbM3E2Hn18bDPRCuNcL
	oMttU+ZVVZuuMcqe9w4HluPRliivhIs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765110191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dIr4yWg3c0IlqDRS8WOEFXdZ6WpgTutD/obofZ4OxYE=;
	b=Dx1b6V0ZRnJw90CYwOjz5gv5IDvXhErJ6Zv/KtFeH9ClEnYBHsSzkgblW/baoazBA58Gbk
	nKzvgzwDv4kLdYukKOP5zGNWzvhYJw+fnJYSn9BOX2I1j883g6bSEqumwmkO82a9JxzU/5
	UUzJIFeyderkT7YQYUg2mhtJaPweNAk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-o4fuTUTQP5WdsDxWjSF85A-1; Sun,
 07 Dec 2025 07:23:06 -0500
X-MC-Unique: o4fuTUTQP5WdsDxWjSF85A-1
X-Mimecast-MFC-AGG-ID: o4fuTUTQP5WdsDxWjSF85A_1765110184
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C1911800358;
	Sun,  7 Dec 2025 12:23:04 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2381C1953986;
	Sun,  7 Dec 2025 12:22:57 +0000 (UTC)
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
Subject: [PATCH v1 3/3] selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch test
Date: Sun,  7 Dec 2025 20:22:39 +0800
Message-ID: <20251207122239.3228920-3-chuhu@redhat.com>
In-Reply-To: <20251207122239.3228920-2-chuhu@redhat.com>
References: <20251207122239.3228920-1-chuhu@redhat.com>
 <20251207122239.3228920-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: kz4icqytob774eiaqzqhj9xd1bjsxuyx
X-Rspam-User: 
X-Rspamd-Queue-Id: C79D32000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1765110191-328222
X-HE-Meta: U2FsdGVkX19S08tnS+hZORkOLxrLc/kxZ1xvAE+SkcRtsS+6rWAhX6qtbbIRycT57KI2y867snqubCWPIuZfM04rVW+hSEsNf90gX1BJyd2xrGiftcWhcyKKssgFa1f5Eju5Jp58Vc7KnMS3QG7dnLq/HgugJW+h/O1+Fr2LCX6pFrDfn2zQcrTFCLoouAE6GgFX+2WKOHUjnrnZZKJGgw9NNvlSPTEPP8GmaCOBngUY794akceEMZyTBEuylgf4RfTrhkhFNNAHCWFPr7i57EGK0Jm7hLlvGDLghIh36ujgKTmcDjwjq4MMc7kEf2v0gIMvTKOn/A+KqDRfwhmPBxjYr5RiA0zUi1P0zxHuoYGnbGHcNq8Gp9MMGf0oqfx3Visx4ybYiSwjppHyPzN9DYE2r+HStFL35m8ubMgFeRDgz649DrQHEJW8JapZJeivP8n0jdubyuJ5BklcbHJrlH1N1m24e9moSJF7K3tVNLFLXLWVcaH4N2jRaxXRpPMr5YEd/ZSBdvCL+2S5btYkF7vFXt9L8t27MCJINSL3uP5mwXHM7GJPaivkU2xV3shrfTojktq/OF2+JwhVOdxlyNURTwctLb+pyqfi5rbtiZtYdDT9Np3HWZQY+JQ+kYglUNmgz6eVEaJG4+wM2t/xLTJmNUGYVNVgZ5zABUzC/dC/F0HV6QhFegfas9Z0mYW1kpv876bX9a5xaKBQ/6FZDUiI+jyyL16fwu1nvedsNAWuslVo1Jt7r3FtSQIFTbdOn20BKshSZ70C9aQi8NAq7q2r5x7MQVl+PzkAIOd9pv1tBPGQ8X48rlqOhWNgU0rx+xKGingihXMZ35vVToQHM0Pykr+rdXCbAQSZCGNGyRlQiOhAp52wQ1DinZxCJW4poIjR4S8ri0riL7ZD7KUc5vqQxT1o0Yu4i7sgtctOJWv1cne1Xt0L/jS8eb0usMpvHj+Kv8LXto4d9GMZ/9o
 wGdPcm6d
 arXEDfBh5pGjfsZ5mWkM+fvTWOsnHbRaBzkQZ4pQ62UVrQ1e97XFOTfz3VoCP3eDfQ+PH2RzHj3Vvr89NmQrEiUZSWoRFWkpEglfTjL4hicT5QjA3yDywKsmJ9AG3FICWFOOYm+7Dp5W9Sa4HZDwfoPSsWM0/MsLPcU4ZxL4PUSSBX76O6WpM1VZlByVTfaxEnm9eMiw6lIfy99fPaPKlbwAJfxaI9MbnHFyAqJqBz7l337BAvd9bfd0ES0TgDnfaUWcMXng2I3G8HV/PwaQh48bVCJJq/xYmKvZXjtidUvpA/DTW+yfYBuKY17MJJTgrOWMr4sL4WJJjCiUyBIl0SGbeRDM/9P/4IW2o3dMv68gW1fxg0IdWgB35eUUrSQH+ffby
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arm64 and x86_64 has the same nr_hugepages requriement for running the
va_high_addr_switch test. Since commit d9d957bd7b61 ("selftests/mm: alloc
hugepages in va_high_addr_switch test"), the setup can be done in
va_high_addr_switch.sh. So remove the duplicated setup.

CC: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d9173f2312b7..2dadbfc6e535 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,15 +412,7 @@ if [ $VADDR64 -ne 0 ]; then
 	fi
 
 	# va high address boundary switch test
-	ARCH_ARM64="arm64"
-	prev_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo 6 > /proc/sys/vm/nr_hugepages
-	fi
 	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
-	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
-- 
2.49.0


