Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48EA105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125E16B0098; Thu, 12 Mar 2026 07:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ECBD6B0099; Thu, 12 Mar 2026 07:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026F86B009B; Thu, 12 Mar 2026 07:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E08DA6B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:26:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A489EC075A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:26:36 +0000 (UTC)
X-FDA: 84537183192.23.A22496C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 921A840012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:26:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KOSW0APa;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JLOLmlCltARAzo4Ra4aoARZoUrqPZTtsYu32OxPUdU8=;
	b=K/xc8ej6hmHmb1JS0mz+PBRd81R+Qzn8IC87AQWP1lULhlMW3DF8H7XhPMpp+CR0q0odOM
	X7gzFEs5MH9b2Sbec53wRxzTKJCjQ9KvKD/m0KIYvtho/6wmG+4pvkKRHhuYyeM7DWfOMv
	0Y8d+P86Wo1Rmc/W1UnyXE9eTXhpK+Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KOSW0APa;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314794; a=rsa-sha256;
	cv=none;
	b=tJIpbMEiUZyx862HjmFYiq/85Qf59PLJFhwym7OmIX2z+/5sxcfK5Ps//qr0xvtT6OQlsU
	RC/80rofTUWYO86yEXMEi8vLBZVmaCGeueD9Or1H7gaOdEnh9RqP+X7ymRhnZORrBQAg9S
	gsLEaJCfq7bHh+rQKC0p2PRPxRacziw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773314793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JLOLmlCltARAzo4Ra4aoARZoUrqPZTtsYu32OxPUdU8=;
	b=KOSW0APaYLP5I4ucNbagh0SG71CzRQCwkLr8TXMPZ2JGZj7bWqzGEipULARuwg0ilDpWVh
	tdc24xL6zsxTr0ZUX2BiQHpIHVcC+gXfqrpYYQR7mCzLxMd0jStJQSsAwU9iq7f1CURSBb
	DaGQLap0C8Hpxk4k5vfo+e/o4rdGC2w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-5ICvTF1sOEq5bTnqKo9IpQ-1; Thu,
 12 Mar 2026 07:26:30 -0400
X-MC-Unique: 5ICvTF1sOEq5bTnqKo9IpQ-1
X-Mimecast-MFC-AGG-ID: 5ICvTF1sOEq5bTnqKo9IpQ_1773314788
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A48F195609D;
	Thu, 12 Mar 2026 11:26:27 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5BDE18002A6;
	Thu, 12 Mar 2026 11:26:17 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com
Subject: [PATCH 0/4] selftests/mm: skip several tests when thp is not available
Date: Thu, 12 Mar 2026 19:26:07 +0800
Message-ID: <20260312112612.633138-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: mzKYbpND3acVD1s9IUvseOkGgvG1bdERI_9jkVyLZUA_1773314788
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: eoijdoq93b4e6hayhqnu46t7gi5hp4p4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 921A840012
X-HE-Tag: 1773314794-633406
X-HE-Meta: U2FsdGVkX19UuFnP7uwRiqHJGI7U5Uhi+M/5uY6NjGI5dnzU1pX9RMeKaEFWXJUgX1r/Gdjh4l0jkr6WHuWbP7eHcf13i4DxD/hj6UZmnGZYAxCsTuEyTkxtfvv3GgvUGJk+iZXS6/lfSTMyea7wjaNlsUOP19wvMSjurdE3KQWu/6TuZIIMaq+PO20P6ms9mILOTclW27ZARzPNtQ0aimKk9xa/VcCNdRoOJm5r48z9FvtXbLJoY/GueeFxXqqBC2qKOw/RVRopqM9Q4P5J0bav4ihdOUK557K69sRAAk4vmnbYSMuda6UcZnwO5teEUU2hls7ESRZhirDSDrakwsWIDxfDWh0PEfc9ObSISlf0IWEYFC4yqyXqdVUQqMI8RSTPLMWGRbGoa2vC6M3YZ9nR6U9I5bRdxCMb7e+YvHJLOYKmcN8LnnLvf+6oOgRfq4on60iauLLLXugrVb6x/smqnV+byvgcStUMNCTsswmgmSwRUPalufV/2Jxn9zP4OisgMBZdH1bWca6dtBvNpxTbQC+xGNaMe+Jv0rJZ6XinqRk4kDL47nWVYkfey8Jued5moJePpYZpBJp3W5e49WS8wCxg+Z7brEfNsLomWTiUGZc3cE+snK4Ti8D0y7uKTGK5bdoLtP9y1gHT3HfmeFsNrpLQTttoaIdyybUnXCP2bI5FQTuMgQIAXblDVVIDY5sOsNYcXHAW/z6/4M6uh+i8LVp4Mvf5oHr9Y32YET+CVAUgjI9O/i8YHU/pTmtj0M6N9aK5G7r8qYgXhItcZVVbqh5yN4YCNFoOvRvfpSmqHKU6HfWujCqiZTGNCEVQiBw6pxPEifPI0FFgIKbPXPon9qVkzNiL6QG9X3hHEBROVw4D9ljQhhhlp0i8oTPK3TFzCx9L09EOtUiwSJTCV/Jn1+eKNZFEX/ZZBhZSRrAia46rEC8x93ucFJzRcUMvGxNuR3vozpJ1KHtLcF7
 a3q0AmYg
 2e7A2F0dg02po5tKrQrOGpbNy4PvEQP5a0IYVnqBbgEnYgshoFm2nPkwh5BW25gImWshPZvIfJP9z/5PoNgLBud8POJPwfbmM/1DV5Xxbh7xgpXI7PK7xOOyhp9lUQrwIIQLZlz4lLlXMfswcHO9yOntHFDVisRcmfX/laPm2xjcGEZXYkOGqSPc5FbAmR+ALKUBs4xgPqMzBsRbCwTFBuf8hpn/TWlm1tWMLexRBvZvIVxdDPVAmUgUTO3Pacs8CQAspo5H1YYviSAxt4H2Yfq/DVlClRC2Vy6/iA/KNk+8ZUqa2aUNE0huvgpt+EJH/n2eB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false positve.
Mark those tests as skip when thp is not available.

Chunye Hu (4):
  selftests/mm/guard-regions: skip collapse test when thp not enabled
  selftests/mm: soft-dirty: skip two tests when thp not available
  selftests/mm: split_huge_page_test: skip the test when thp not
    available
  selftests/mm: transhuge_stress: skip the test when thp not available

 tools/testing/selftests/mm/guard-regions.c        | 4 ++++
 tools/testing/selftests/mm/soft-dirty.c           | 4 +++-
 tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
 tools/testing/selftests/mm/transhuge-stress.c     | 4 ++++
 4 files changed, 18 insertions(+), 3 deletions(-)


base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91
-- 
2.53.0


