Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0776FF532C6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3146B0095; Mon, 23 Mar 2026 21:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3896B0099; Mon, 23 Mar 2026 21:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592BF6B009B; Mon, 23 Mar 2026 21:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 447A16B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:34:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E0D41ED2E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:23 +0000 (UTC)
X-FDA: 84579236406.21.AE94A78
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 514C740002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KthjZPht;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774316061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=cCtZso8Ii5Buco5WrVMzOsTKER1ozgLspGxvcnFi8/JgzN5LtqC4YEYyi8PoVBIEQVrnmb
	sTD4Xj1d4iqHWM85vtTUan6G/7sNBstatD+si/8XyyMa0gQWnb/TQaYMol29IWHc+Ltf3e
	NO7kiY04oFmemm5WpGkAO9V+I68ji5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774316061; a=rsa-sha256;
	cv=none;
	b=Ato/lYehT4QG+5IIJ/LD30Mmahfk3a0dczjVBFEQJFP3ChsqpGF82ogtmBJmAlxd5Kalq7
	eveY/JUad1/PH8pSTzLnfuxjb6xwajF95bscmjEZhxgwAaVdUp4d+ow4hMtst4MlPXgpNf
	nk27HSVXyCiArhW0SCZpIDt5JSAe75A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KthjZPht;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774316060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=KthjZPhtFFtCwSyd0yo1HIc7799R8WpF1sF17HhHgISge4e1qWT4Sp4PjaUortdb5Ip8Fe
	bAafubBRxuXIUg+paCmAVF8Sxug/T0z3liFYFu4PD8XXlXcYv3xKQPH5lFTrWJgUiXRS5W
	sqBCkekXnmtnyXRT3MKk32+06jQ5WfU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-MFMT0aBONquvRkjdt7tu8w-1; Mon,
 23 Mar 2026 21:34:17 -0400
X-MC-Unique: MFMT0aBONquvRkjdt7tu8w-1
X-Mimecast-MFC-AGG-ID: MFMT0aBONquvRkjdt7tu8w_1774316054
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4B9618002CB;
	Tue, 24 Mar 2026 01:34:14 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0CA3180058C;
	Tue, 24 Mar 2026 01:34:06 +0000 (UTC)
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
	chuhu@redhat.com,
	Li Wang <liwang@redhat.com>
Subject: [PATCH v6 5/6] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Tue, 24 Mar 2026 09:33:15 +0800
Message-ID: <20260324013316.2590422-6-chuhu@redhat.com>
In-Reply-To: <20260324013316.2590422-1-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: lO7jNqYmtOre1n23UQP-Sz7nexSvh2uHj-MTghK_pUk_1774316054
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 514C740002
X-Stat-Signature: xy98t3jiyu8nz3ffgytf35si149dt3jc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774316061-385128
X-HE-Meta: U2FsdGVkX19r0TqubLG/Klw/21ih3RcyMqxPS4L5r3p2Rz0maLfH8BmrAPEaYwAEtPec4Cxc++u4PQhoSvbjhBciexmTFYN/LgUKzQe47gY9kOhv2aprU8nGOsCSmP6cgtITcmG5CpI4QJ6u4uzVbGkiHk+Vov27b2DmG3IvrXTa8nVnJdEufg3gwFGiYd+sq4reHpMaRDUaAhcF5Pb0G0+uIDZKfSp5zO4GRyqBykEWFCpPOdG1Rne/o65CpCzM4nDTjimaTNboGUQwCdV4ixuhmzduOIKql10CiZ4nbiFPGd04kIst0S7d3qoIvlvj6wIlNq6Xn6G3Gh+BMawVJt9lxWNZAbq8kvFVK2TZcCluKXBTr1mhe9u51Fhbunva8OkaTiI9gSA629G1SKC+BpY6ok/z4v2KJIjzT9N1Smecm5wdYjlexyMsugo1Li0QXGCIBrB0wzPufdescIjRawYz4b82JcYeVTkXXhWFfkNajNUatPCG/ipZfD5vzx4RDeHknighg9N74flWFlqySBXbQaJ19T7I/vOVczFto4Swbv+waIsv4lczjqhscs5KJfgVAqxpfghfjAzYvb5iVvQfyjOexx5N2pdgM/SiLeSkq3gZqArLFznD5uZjgE6rAn3RT7YyC0ahiwNmY2O/ahmmsSK+A2ulYg6Wf5BIE6OE7qYck4ixMdjEE1XKKY1IxgYzoWjQO97/WkpamnXsP5n+bjrvFlprotLtIufMl1qOd0omSpGktvxZBnyR60re58y+5TX19LegUtnF4/dvHlczi7RvTloCcEaH9qoKS0zIulMGr/zhs5ryxf9BFVrJ3RpauQ3Gwne5xuLhRXqpuZ1pxVIlc27f3F3CjDHfRGGUI/NFOYKSOHvo7jkRpQjhYlFFG/5U4ClgCEVo5CIb4fCW/qQwPmFr1fHEtSno4L2Sx6JQLxyyPZAyIJ35a2f3ZHLyiCzEadl+54QFOMK
 fkg7l8a5
 2OprEWtEwHXQijVnmaMnwn4sUCA+lAnIULBpEOx2YA79+Td3E+bx1ytpfaN1e2NsdUhn5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When thp is not enabled on some kernel config such as realtime kernel, the
test will report failure. Fix the false positive by skipping the test
directly when thp is not enabled.

Tested with thp disabled kernel:
Before The fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
  # --------------------------------------------------
  # TAP version 13
  # Bail out! Reading PMD pagesize failed
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1

After the fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
  # --------------------------------------------------
  # TAP version 13
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
V3 chagnes:
  - add acked-by from David
  - add reviewed by from Mike
V2 changes:
  - removed the {} in if block
  - removed the write_file helper rename chunk, as there's a new patch 3 to
    resolve the conflict with thp_settings.h by moving it to vm_util.
  - Add reviewed by from Zi and Lorenzo
---
 tools/testing/selftests/mm/split_huge_page_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 93f205327b84..500d07c4938b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,6 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
@@ -757,6 +758,9 @@ int main(int argc, char **argv)
 		ksft_finished();
 	}
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-- 
2.53.0


