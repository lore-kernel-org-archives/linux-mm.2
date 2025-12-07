Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7A8D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 12:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F476B0006; Sun,  7 Dec 2025 07:23:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEC56B0008; Sun,  7 Dec 2025 07:23:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37BA6B000A; Sun,  7 Dec 2025 07:23:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E36326B0006
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:23:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8138113BB66
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:23:05 +0000 (UTC)
X-FDA: 84192589530.09.CB9479C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id BCFB2180002
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:23:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HE85b2L0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765110183; a=rsa-sha256;
	cv=none;
	b=lOd+W3ISP8XHGxRsx4aqCRRei/tPzDPDcLFpkUWlFX1ElnFyNrT9LD7EIQnE/aU8SwHhk0
	WPulyDPhNhCNgm09TJnTM+E/k8N4M6pg4Oo7QMYJomXZ0R9R76zecXVfFa9YFQh2FxBUZX
	RgQV+cQFA+rk5GA/aLBecKk3qDCRuBk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HE85b2L0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765110183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/mYwJm8Tzi+N8+xqADIyDadr0oGOzUDKk5/OARZkss=;
	b=c85T+32EHazDnVS02pTjwzUWtVfW5kH6XE4BdjoAHIuZM47jmKTCZktq1/RRMI/BNylcXF
	acOQqVgf5I5w382fqt6Jiwwii2o6l/zA70H8IJIuxfvO/iZ9q+brlqXMWI9hxqFTZ6DIkS
	J+ahlzUY1S0UQ2wXfj9RFE0kRmZE/oA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765110183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M/mYwJm8Tzi+N8+xqADIyDadr0oGOzUDKk5/OARZkss=;
	b=HE85b2L080lQ6lXjuRvtJxSZ5nP2l+n3ojaKSqal1a1mnemcKMUcA3Qao68Pm4RqrAMM1Y
	k4omWQ47UGfyxbkcb7z4c0Y6h3vsag1TPGe8Q/Rp2tWJfPJg8pPi8IEhUB91KRYnFjI+w5
	ZbLJZaN/2ZLo5v4oBYuFFynLaa7j3uk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-p6xBXNGZOMy9_ueZddf24A-1; Sun,
 07 Dec 2025 07:22:59 -0500
X-MC-Unique: p6xBXNGZOMy9_ueZddf24A-1
X-Mimecast-MFC-AGG-ID: p6xBXNGZOMy9_ueZddf24A_1765110177
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 394E9180028B;
	Sun,  7 Dec 2025 12:22:57 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 294FB196B8E2;
	Sun,  7 Dec 2025 12:22:50 +0000 (UTC)
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
Subject: [PATCH v1 2/3] selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
Date: Sun,  7 Dec 2025 20:22:38 +0800
Message-ID: <20251207122239.3228920-2-chuhu@redhat.com>
In-Reply-To: <20251207122239.3228920-1-chuhu@redhat.com>
References: <20251207122239.3228920-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCFB2180002
X-Stat-Signature: 58w3jr7y959nx68iddd9mrf779ojw3ci
X-Rspam-User: 
X-HE-Tag: 1765110183-23918
X-HE-Meta: U2FsdGVkX18m9MeXBIjY3un4URGhDi+xUucwh79kuwwMp0PsE69VTaIbhtxavP/QWNp8vR4oXkXq+PISlmbrw3O+es1pX2ewMb82TDps36DvXwu4g6W80ORIKOty3UFKXJ/TtDe3Xr/LGbhA8DPtmBmKRk/Z+0tG1KszDJN74iEaRIhuGMlKzAgBqXw1iKvG35ub20QWZiz0SW5CWRGsVe5NyFuMGUeusXRJWaYByb+3FfYJCLFTEmkoDYTTQN43BDOutidiwTX/tkOeUNlj4LjDD5vgFKwkDZrFD+0XwMP3KfXO9/W4II0Y6qZL/WCIuW/IC+Znfn/GcCmhiu52BydWxEwVwlVUKMDQuBrWqB1c/WEtfn1PzrI7QQqW/OFoJ02kEsxcbp8PdpAxfYEJfmznOXucfHgxHYJ2wl9xnXqulDDx9x234gO8T+tpvqqMCRRslZ3Cepij7AtthwoTfk/tQNDCeOwT/abpCwpKCGEA50H1O1+4Z53QsH8a9czYwDJoIlKMqFl/NSbOawLP/fIhr9+ouKLjCOYTjJ/cDnT09WsyyqVeEIhlyGEINtIOZDOvvpOiKb1WfNks4DUSX2pN3t3uP0sPlqgNKKNfHcNRuOTzg7VH8v3xv0o6XG6rDh5CEJ0PpVbc4Is7oPP6zyp8/PKUl7yMCusqNFKLGifQgk0odlqMntQzVUL+kyyTpZdV9uVhPeQ7kyi6KpbRaJGcPaGYoyNNaZ+PVOlQvWM6v8+c8/qZGav53ErEYoRWSShTfpYlGZccnWa7VVGEE1IVrgh5U9b6l8+GE408ThQbL2UJALOAW76cwd1mbSDbYcKRaiVgC2PW+o/+0VO5gPhFb+3iei3nc6RWM8F0o6w7GhKAIY2sCPh9ytopEGg+Nrx7uTfj9zGWy1eA6BT85FGEDOC4KCfnpiG0iBL/+r3OZJMMkdcaMtu1k3a8FqIFi3TOJ2UzDpK2t3U8noN
 UZl7R55o
 skfJT+AGJZbXR59/CUb4RCzggyKRqik24iozHS5djKtISpYYHGZ5A7jz21riaPiv7l9A26X70GhpyPt58Iy3inVA3fQa7+DlBX+lvSVgZWAAz0kqYBI+DmjOYQ6PfWs1XwVmXiuOqX781BdpL74YHTe8R6gGSXIPQlLarukM7cAeEAnfGN9FPrs/FPv8wCMC+YmyVkwHUA7nmqhpfMfH6/fGBl27oAo4kHbl4VCLSr0E8/27yU4tvrvaaNXqXIqCAaJj2TXlpiCTFTB34/gmbN4mzl/3bszWfSERvICNffCRevxH5EmoVi7RJ33LYKQIZk4GRODw7IpCYmVZplXbmw7QL+j7KrB5w5UpbdSdc55OeVJtxg0w0+cLSmQidEyY1D2Ck
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
 tools/testing/selftests/mm/va_high_addr_switch.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index f89fe078a8e6..98f3dfab62c5 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -111,8 +111,10 @@ setup_nr_hugepages()
 
 check_test_requirements
 save_nr_hugepages
-# 4 keep_mapped pages, and one for tmp usage
-setup_nr_hugepages 5
+# 5 keep_mapped hugepages are reserved in the first testings, and the last test
+# requires two hugepages, with one verlaped with the last second test, so one
+# extra, totally 6 hugepages
+setup_nr_hugepages 6
 ./va_high_addr_switch --run-hugetlb
 retcode=$?
 restore_nr_hugepages
-- 
2.49.0


