Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 636EF105A589
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0716B00A4; Thu, 12 Mar 2026 07:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82046B00A7; Thu, 12 Mar 2026 07:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77416B00A8; Thu, 12 Mar 2026 07:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A137C6B00A4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:40:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 437F8C08AD
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:40:50 +0000 (UTC)
X-FDA: 84537219060.18.DDEBC4F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 41A0C80012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:40:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xwyq+DCj;
	spf=pass (imf30.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JLOLmlCltARAzo4Ra4aoARZoUrqPZTtsYu32OxPUdU8=;
	b=c5NVhEfXV8eqwfD0yUrXBBGa8o1LgAVpfm13/QIhL6Hv+HWP4lBQ8qh158NJrXRqmuOjp1
	oANEEaCdR6Mim9DIgm2MgGLIJHkAtQ/kCAxXnnBF3NpXGj8cWjxG8W9113HoAJ8j7fAie5
	P2iKcR1HCuIlL1hBNWJ7dlO7v27GJ8M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xwyq+DCj;
	spf=pass (imf30.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315648; a=rsa-sha256;
	cv=none;
	b=cxOe7yai6oaN/pCoB+835CAqG888GOHCCPMJGgU8AW0FfjsXtVUWWNGfwI1WIj9zrhUa75
	zSxFJV5xBJ+Xfm3WxrHp6VOiaRJ3w7uHysyH9M4h0SrHxCF0eec8KRWlHl9jT6vt7N+tV5
	7l119irY6PWwr5sQ9l1yZmqS2Fz3ybU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773315647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JLOLmlCltARAzo4Ra4aoARZoUrqPZTtsYu32OxPUdU8=;
	b=Xwyq+DCjrUMZPLYi9C2ldiMxjWNmK3udaPPbI3magN1lEQd1rMHAu4Si3e1Retd9agInLo
	AIsm2nwy5HQhMenNfkADIyKhb8QX1sUedY57XO56PkpTYc3ZpchZP8sF3Cv01kiLuepxqf
	O61tWkZtRj4Bo+nOHyLAkd8n3xV67kU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125--EGgtS22OoajaihVTkruSw-1; Thu,
 12 Mar 2026 07:40:44 -0400
X-MC-Unique: -EGgtS22OoajaihVTkruSw-1
X-Mimecast-MFC-AGG-ID: -EGgtS22OoajaihVTkruSw_1773315641
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AA981953994;
	Thu, 12 Mar 2026 11:40:41 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57CE5180058B;
	Thu, 12 Mar 2026 11:40:31 +0000 (UTC)
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
Date: Thu, 12 Mar 2026 19:40:23 +0800
Message-ID: <20260312114027.634559-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: GfmZLnjUXORVh2l251ffMkzVIHpr6ziXquWFAp5cQEU_1773315641
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41A0C80012
X-Stat-Signature: eoijdoq93b4e6hayhqnu46t7gi5hp4p4
X-Rspam-User: 
X-HE-Tag: 1773315648-840686
X-HE-Meta: U2FsdGVkX18cgSrxaGNTiMsF80jSEH0AAgwHSF2yGQxPKaXEOZ095wc53dBFt1lABaSs1y7aNgaHpBw8wSqEAl+u3nKINcCvx6IdhaeeDS41LnE2GRtplPhdU4Ss/tOgDJ/iZA+UvWvm116jIaERiGc/Nb7yx7jArz/eHnc+NZzxsv96ykTWaWfg9/73ygmDKCB160pNP9t5HgKVMhuWl3bq1TnNyCmeXCSlPsSkP20Jp0IgHgbV60zCb8lzEtOZSykWPpAqcw8coq7fj0U05JnWBwoQ5cZwF+u1ok90DmPjTCD7w3tKGz5oI2vm7DwFjYJr9Y8mIM6hVh118/1uMujK0EOz1XPej9nJbpsjVyLDuzmvi+IKvKx8BPIccVl+f9gHVFka86cTjcVV6ASQnwQXz/43N6vz1RFPxHvHe5N7ZiZYStvyZZwLkE7QSULKaaza2At12lIUAT6sD06AMrRRZ0Djt1FqmkpMnQu3I8+XQeVFOuToNfZZfrlTo923BwaMyztkUnyCg3125un7tdZJHnzuwSfiVcgkzBaZ6HrIgJKRL5BCGaeQdBC02uza0m+Pt2oRmqt9DOrNWfX4/sBv61U/ROclHP4pAY0CGENfAS0Y2jQixDL0veFNnb8sbb4LwDMpntiIXVIhHblgpEw+uEORRwgBgQYo6yettGe6H3pe/6Ndlztg/LAAcRQ4PUlUyg6YCg1bBpQpIm5evUZit0Be2JWKpdvQXCUz4DX7XXNs9N5+B/UA59tFkiM7T+mRv6ndr7a8qzy/Iq9kcoJyHS/8UmLMCIk7LZBd36nTs6ZsXlLSj9gW+WyPQS/CFQURMUbENB4OYWljRQ338FY+t/8vzVYHx3GsVts+pfngZ0uMx4sYdfKCQHP9jjoGUomFJTIB4Bx+prAeAXex+C5Lg0oa/OE9cxgSchU/lNxB4IFaOSsbk5urSf8+WiD1qnVq35M9SkOG/33SIKx
 Y6iOJjyz
 zxNzZv/B8yIyysC5VpAks79EIlsqd5E3D3d4DGB5/jiTPv8e9IFrgqJKQ7hfW614VTrIDZP8C9AdA05XHz1cnzslytRVaIVN75R60ioKVtcTn5cYWeSDVuGcWR6lt/qH64NN1R4obMBHjKMyrmQ41uBfq98AHqjvxE05eVuK5+thnuOhsO71zPBBlwPeu0WEQRoSV/YLfuF3zRFaeUsCi3bINdov4GqJioVB5PY3cRcgwa0vbBKzzeZr9dhp6ch3UE0jdPTCDVc2HIpFH4sb+oIJTHZcgkPXMIi2t3AWsrf8Dwl6PN6epCpFVuVIDt3h45Sb5
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


