Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2611C606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JF5hF5v7
Received: by kanga.kvack.org (Postfix)
	id AD4616B0671; Thu, 12 Nov 2026 23:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A849C6B0675; Thu, 12 Nov 2026 23:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9287B6B0680; Thu, 12 Nov 2026 23:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 586046B0671
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:01:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42D4C405FC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:01:27 +0000 (UTC)
X-FDA: 85428746214.08.7C3B317
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 639F0120006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:01:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JF5hF5v7;
	spf=pass (imf29.hostedemail.com: domain of jocolema@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794542485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c7E91ugUUXL2RSD7YVbBkOLNFCGTuw0TRMQRMDFJplQ=;
	b=STkm2FjUJKHk4UJb3NMgfqp3mmsRtrVnLJBEPuZoH7RJw8PXlPHtkqTblC9fqZsiG6qUDF
	jMmNdjDMnD0PhV/RNwIgAdgtIQy1Mvz3ndnrNHDK5woZzB3fmXJPuUIGjpe/8VxF4fHzdl
	iF1zHQrvhDzPA04hoYURN+NJ5VxtmKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794542485;
	b=bO+c1XD7EAmcJRx880wF9M+iIZCJOaXC0TYLKLLem+FjYn12cGMWn75np44YMpwajVGpEz
	CcbvwiHC4M0MU1XEzUGuyPQDCji1bGx9lKcv3Rqf4RLDFMHZxvAT9F4yAyN4NDi5LTwJTb
	LWdqyAPGJBVxru/7xjtYrknZxw/oGO0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JF5hF5v7;
	spf=pass (imf29.hostedemail.com: domain of jocolema@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794542484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c7E91ugUUXL2RSD7YVbBkOLNFCGTuw0TRMQRMDFJplQ=;
	b=JF5hF5v7uYYnHB8xqar9UO2H9WJVGitsLSjziX0aofXOvVurb77pLhkVPq56nlWq+ZxKXW
	0ZXJeno1ryz8ZRRJFZxnaExAuK5tw4b1vBTtVzC7DYI0PvVTDR8wGpcmxl5XVfETMVvD8S
	Xh4OOsvf92WNvjIOO84J1hUwCFliTBw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-6EZoidn1OrOslF0C3bpmWw-1; Thu,
 12 Nov 2026 23:01:19 -0500
X-MC-Unique: 6EZoidn1OrOslF0C3bpmWw-1
X-Mimecast-MFC-AGG-ID: 6EZoidn1OrOslF0C3bpmWw_1794542477
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA9A818005BF;
	Fri, 13 Nov 2026 04:01:16 +0000 (UTC)
Received: from jocolema-thinkpadp1gen4i.rmtusco.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF46430000E8;
	Fri, 13 Nov 2026 04:01:13 +0000 (UTC)
From: "John J. Coleman" <jocolema@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: zenghui.yu@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	audra@redhat.com
Subject: [PATCH] selftests/mm: allocate nr_pages based on pmd size for uffd pmd_move tests
Date: Thu, 12 Nov 2026 21:00:45 -0700
Message-ID: <20261113040045.1439391-1-jocolema@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: y_V_B-dDL5cMESMBY0opIpGiKuxZliCwD00e94QgPnk_1794542477
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: o9wzk83n5xihxkq6h1renxebeaxgxwbt
X-Rspamd-Queue-Id: 639F0120006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794542485-85499
X-HE-Meta: U2FsdGVkX18yIfpdR6XSALuk1hgFq/GMKFo/c7ro2Mlwk3tSerIlgbojEIoyyXWXy6qc5H+VPCMPDKo89rScxk/UmBgBk+tHnvSulZGpJhM2ahrlTumtqq9ewnu/FFn/7gY3hUM0LFkRwky7oTtqdePiY1dvPcrEFa4PnjQCCIpY1jRv0gAkgWhYerWu28pdJzRf+GfIKxHEz02lM1PYIhTOZM1pSl61NH9Qu+gLixLFqtcSrJY7AAPdpQM0Z6IRAcpq9DlAIIa09KvoVdG+LcPr6QKEoogK4qLzOapeA9cM6wJcdhqojmIfDhbwKTDNeOMFdENo0Joi/Lxsy9S3JhBcKxJAAgd2MSMis9ZPI/rGZRQdTZG6poR+HQaACmMFd+gG7qgZXpcgMSjqqoM5gg/+/qtZqNr2NvwcAcCQbpZzvaIM1kiyr25LaS+IVxsQbJ72EtZKH8CisRFM96tNzVRto87lny6OORfSp1f1SL+0cynkroK+wWTUAkd/se+lG8XycMWCI8vsFgKIaVp/q3e0iRNv/xd8yBOLnu9f4i4v43OrCH+8IfXf7AvmO/Upm9hzUGnBmrZt+dPu4cp/H0ay4DDsA//+Cz+ukKyNSltwo7GXiwgxOfUWK+R4Ay4R4uW2Ft3NARAna4qyGH/v0P3ihCk0hRZ8nooCf4SnfdiblIRNvhBq7qrDjHwa/3wOMOhrpPLw+9cGZwJTOUQXzhq/9Oq1E51Qw9dkGS0BaAIKFC27QLhJB3iPNnBXeHQuWPkfKEULfhNBqVBVMSUDbQ0WFm7G4yLK51DYc5HSlrzHZ024kzy2kIo+plcq27WUNOrGihaHdfiLcYgJTks5sMgR8FqG55F7JQgK0hoGuz6f90N1wNjkscoHfaYETd7p9FWb3DxQeaEDtKkRbmqAp0XbCUt5RM85TG06VJZq07VD4Q/fBoYB8+qgVUynH+fyEsxpehajWamZtk/ze6A
 Y0BEoKD1
 /EXL5G3IViSrsCmURJW9KRdPlvqGgcg62Ek7ndFirbvBXOhRxUWSlYEehxxI1Yi0D26J0ByZQEzGT5osbdILGe395Cjmomv9PdhPaB3u+Ou0IVojU7JDlHRWHzT3nvVhsMjnk+PdkXlbXbfBRAnaTtfvOBueBcBCH/ybZU7TcZir+UEGFcZh8zR/BUnHTf9IuZhlR0GOao/AgVaDPpODmAk7yGZVHTvDcuMZpHn5uSVAlYuJ/suulN1emGiG81LNE+TOIzp1Rth9eZ3q+oDJVeBzS5w0oxHBKJRAoKQ/zl1UWCHE4U/lHsK8CQmXvCrhwXKfD8pCpK90G5irCTg6XZsr9M021sZc2Jt3eIuWC3/KycOgdp0O3lRFsNGQbOufM556VnOi4bSp1rScrcIZrLe5QqdDzXy+S30h/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When executing the uffd-unit-test, the "move-pmd on anon" test will fail
on aarch64+64k with a segmentation fault because the initial allocated
memory region is too small.  This only happens with the move-pmd* tests
because the architecture base page size is still utilized even though the
memory region is specific to the size indicated by the pmd.

Patch 9f5c2aec3388 ("selftests/mm: fix uffd move-pmd test crash on 64K
base page systems") implements an initial fix to the segmentation fault
by skipping the test if the allocated memory region is not large enough
for the number of pages x page size requested.  Since this will skip over
the aarch64+64k pmd tests, this patch is intended to resolve the problem
with 64k pages by pre-allocating the memory region with 2x the pmd page
size (for area_src and area_dst) for only the move_pmd tests by using the
uffd_test_case_ops pre_alloc hook.

Link: https://lore.kernel.org/all/20261103202049.499206-1-jocolema@redhat.com

Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")

Signed-off-by: John J. Coleman <jocolema@redhat.com>
---

I initially included patches V1 and V2 through the linked email thread.
V1 and V2 modified UFFD_TEST_MEM_SIZE contingent upon base page size and
a multiplier.  However, sashiko review observed alignment issues with
powerpc64 with 2MiB and 16MiB pmd sizes as well as 32bit type overflows.

Subseqent to sashiko review I decided to make a significant change hence
why I created a new patch rather than continuing with V3.  This patch
leaves UFFD_TEST_MEM_SIZE at the 32MiB arbitrary value and utilizes the
pre_alloc callback within the uffd_test_case_ops object to set nr_pages
based on 2x retrieved PMD size divided by the base page size for both
source and destination test allocated memory regions.

 tools/testing/selftests/mm/uffd-unit-tests.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb1b35d6281449fd1917793a64fab1..0846de62689f710bab320e399d0bb5849b9408ff 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2226,6 +2226,20 @@ static void uffd_mmap_changing_test(uffd_global_test_opts_t *gopts, uffd_test_ar
 	uffd_test_pass();
 }
 
+static int set_pmd_pagesize_nr_pages(uffd_global_test_opts_t *gopts, const char **errmsg)
+{
+	uint64_t pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize) {
+		if(errmsg)
+			*errmsg = "failed to retrieve pmd page size";
+		return -1;
+	}
+
+	gopts->nr_pages = (2 * pmd_pagesize) / gopts->page_size;
+
+	return 0;
+}
+
 static int prevent_hugepages(uffd_global_test_opts_t *gopts, const char **errmsg)
 {
 	/* This should be done before source area is populated */
@@ -2259,6 +2273,7 @@ struct uffd_test_case_ops uffd_move_test_case_ops = {
 };
 
 struct uffd_test_case_ops uffd_move_test_pmd_case_ops = {
+	.pre_alloc = set_pmd_pagesize_nr_pages,
 	.post_alloc = request_hugepages,
 };
 
-- 
2.56.0


