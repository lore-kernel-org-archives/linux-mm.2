Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267F2C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B476B0092; Mon, 28 Sep 2026 09:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBCD6B0093; Mon, 28 Sep 2026 09:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1293C6B0095; Mon, 28 Sep 2026 09:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E15AA6B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:09:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78403A4E3B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:09:43 +0000 (UTC)
X-FDA: 85263203046.12.B2AFF46
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8C70AA000F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:09:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fIyL2Ks9;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790600981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Yjx5Iw05PKfzTcktcgSYhYGCQtJxiGcu7fODO6nG0w8=;
	b=l6zZJKSG2pl0OP3pIQdluu9zqduozcM1qyCkUalaAs3JPZNxxFEmpDCrBRtLgJq85MwY7v
	PTKBVmhyrZ8IYzbaR9n+FjFen1kC11Sg83u13LQQLJ9Edz67e05k0Etiwj9EeByyewgv/S
	2tYKRSAH09BDWUtQqKKVtLMAJ1K/JLs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fIyL2Ks9;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790600981;
	b=6ciLclqXfRfPK/Woi9bkx0r2iromC5pLNbSclGWvxNParaSX8ZiFUQqcmue6y5APTE3qIz
	WRJFv5J/dMiVGHCkrNQSXC7aU4adTvufVbGLXjoTBXA5lAHVa69NPc0l0neh6nGII0GmAq
	SIN8oIqR33GejoaDM86KJcZAKPStHk8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790600980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Yjx5Iw05PKfzTcktcgSYhYGCQtJxiGcu7fODO6nG0w8=;
	b=fIyL2Ks9pYorUIAHaialDzlCxNtupAXv90oaeAojYhNNa4NyunTesJjWuHqwDlFFqIYfXf
	YZOvt+MW99mSrq+p/wss2ywDZOdrLhUZE7KWeId6TK7zWEdLOFLHqYmiAu9E/w2A6XzLfk
	OPlnUOVhwg+vZBVDtWyU7PpIiPydkPk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-Hqf7Mu5fOTSULuafHwoTDw-1; Mon,
 28 Sep 2026 09:09:39 -0400
X-MC-Unique: Hqf7Mu5fOTSULuafHwoTDw-1
X-Mimecast-MFC-AGG-ID: Hqf7Mu5fOTSULuafHwoTDw_1790600978
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDF04191DFEE;
	Mon, 28 Sep 2026 13:09:37 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C3D651800361;
	Mon, 28 Sep 2026 13:09:36 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: stable@vger.kernel.org,
	sashal@kernel.org
Cc: rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6.18.y v2] selftests/mm: hugepage-mremap: fix mapping alignment
Date: Mon, 28 Sep 2026 09:09:16 -0400
Message-ID: <20260928130916.231112-1-luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Jczol2KscIrUy4AsswyRzx9_iaSIrxg-i_VKbhyo4Dk_1790600978
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C70AA000F
X-Rspam-User: 
X-Stat-Signature: nx58pi1qsouia4jra5p3sgqhydbwdqxg
X-HE-Tag: 1790600981-744651
X-HE-Meta: U2FsdGVkX196gji2vKxVSW++jfVkJz870TlBvvp26G3hLajKjjUcnKb/91Rd4cnClgjLl1S81Kox+8cBsuBcwSypTKEc6lUiELq9oQl7fskXk8SRWPydBXi668JV9jKggMkRZtgJjSx+7fBOwClWzNKBe3jkhuFeIjMplDXmXHXFdRS8yvE/oQDib7N5gGz6EjON3OEKGFdJfXenwdS+mqAceJFqM23ITrxgxAThPqCEP52ZNeQFygXi6Tz2dgd/+VUf7DGZAXz7sh9KqZxvmElcw4rISV/dYINZgcdkmgE1TVU4IwCMYUFzbV51ehpGTH0mCJm/wetcjGCwlFBH/+5qRLtWftUg2XapH4gkaTP+JzxumAfzZrIBjoDgETeFaGcGV0HhQCmrve/m+UcP4M0o8C2GTo+lq2g0x66u0mEESxhEWDy2y1Jn9KvUXcj6vQgodMJBbXtFwfOCi+PhLmS/MI6gzH7wdHuMgMzCAiEJJS7G/dXmpJQOReQRMdHsNnnrXNm7cMUPWa/aXzuRZ1VdX/b2WKqOzdJNuq8/AztQTNfa8fQQXWouVOBpvmwzbXFIkeXKcnibLA+H8pD8mtdCJ6+8C9EfvgrZm+bK6aC9H/WeaSC+spmSDo7/vFch2XkYqxJYthkU+I45xld3X/h6DRCLTy1U8MKN+uQFMeWKye9a1sWW5OaVSJh9fpm7KMD1HKWBcvteAphqXavoG1QBpVJkUx4G+EzHMOaLtBoJA3S7koib5T7YnCwuqbxrSQWT0pMrQA3EkpPw8C5KHkQzPSrbpDHTbwBquIWJnXzHJ9IkOidSTSuMq7hY6t/6r9OQWkdPA5ntUKi/DGpkwPRE1z0nUPsIKrarKgrlTXZsJ/0YsPtf7v2bJ5ui+LDumtpwjWv+IFt8odNxwMsFuby4Bm3L/7nr4DtIh5J3Lt3nQZEsWXsTQc5Msx9ZfnyAP6ApqBMQqGQXhKp35ff
 jFAtCvbM
 JU26FNST3NHRq1pwkZMiC2jovupSF25DX47X7dffVbLQdUcoDcXgaLqN+AbfN9GsjhriH4WOUNhvuyjmoigIBntlVE5HNgzIypcEJEZE7NeX0VKv4PNA13Yi4y80zkGLGUhIje+6vNU0ZhI8d3xJxnpHtUAJryG8h0ubSE9q48GMAvZpBbu35PSSkn17TJ8Xt1xVRQhGuqme3wByUher3X8B8kMaPfG4K9ZqV2LcQ9RicVoSpoODWnQxhh5xJQBJ242DRordiC3Q2PmNVH7fhv5bAHyty+ZUEkMNIwz3iLP8+i8fdoQXuglbzmWTQ+nkwn1U89WhWU4TC5g/t1miFxTeTTIAxI6qaVXZ56vyrv8jCKX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit a914785f6349da754e1226420bf4e51961956769 upstream.

When running the HugeTLB kselftest suite on arm64 with 64K base pages,
this test always fails:

  # -------------------------
  # running ./hugepage-mremap
  # -------------------------
  # TAP version 13
  # 1..1
  # # Map haddr: Returned address is 0x7eaa40000000
  # # Map daddr: Returned address is 0x7daa40000000
  # # Map vaddr: Returned address is 0x7faa40000000
  # Bail out! ioctl-UFFDIO_REGISTER: Invalid argument
  # # Planned tests != run tests (1 != 0)
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 hugepage-mremap # exit=1
  # NOTE: These hugetlb tests provide minimal coverage.  Use
  #       https://github.com/libhugetlbfs/libhugetlbfs.git for
  #       hugetlb regression testing.
  # SKIP ./uffd-wp-mremap

The problem is that the default HugeTLB page size on such systems is
512 MiB and 'length' is not aligned to the page size. This causes
uffd_register() to fail as 'length' is 10 MiB and not aligned to the
HugeTLB page size.

On upstream this was fixed by a914785f6349 ("selftests/mm: hugetlb-mremap:
add setup of HugeTLB pages") as that commit aligns 'length' to the
default HugeTLB page size as part of what it's doing. Since this commit
is part of a 50+ patch series, we backport only the 'length' alignment
bits to fix the test.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index 928c1045e295..0d4e1a5b185d 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -97,6 +97,7 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
 	size_t length = 0;
 	int ret = 0, fd;
 
@@ -114,7 +115,12 @@ int main(int argc, char *argv[])
 	else
 		length = DEFAULT_LENGTH_MB;
 
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		ksft_exit_skip("Could not detect default hugetlb page size\n");
+
 	length = MB_TO_BYTES(length);
+	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
-- 
2.55.0


