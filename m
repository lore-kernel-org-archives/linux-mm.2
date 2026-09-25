Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11043C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 17:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B36C6B0088; Fri, 25 Sep 2026 13:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065416B008A; Fri, 25 Sep 2026 13:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF326B008C; Fri, 25 Sep 2026 13:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE31C6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:21:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5674BA6856
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:21:49 +0000 (UTC)
X-FDA: 85252951938.01.CEF8F31
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59006C0008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:21:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ta1CNbiz;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790356907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2y3SWVL9xb1mi6/jmBV5roo3osTXZ0gweNVe3xO+8yY=;
	b=BaBihyiIFawqSrY2/bGvo79FYuFH6vOW0ip2FSmwHbhERlpjrgia1pfNvQ3sTtkAXUrKND
	yzGWQWJxl8IweCWQo7DpWwabm1aDGoNN4dEV377m+OwxV1uEMBNlmCNFNzp7dk3PcRFuC4
	iMQuSjCRxYQyjqluU9unQpoX9ahUO8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790356907;
	b=PB95YhplsEOO0pvUieC0VA8sSXLbrkjylzVYCcxuXXEBM7FVeCADQ3Di9JKPYyXvVpMDkY
	24VZtJxOpEiwpyzO9ZMYU3o2WaO2N7mFqtJOGGd7e+Lg0Fdawms0evRhlpAxbhPYpp3nmB
	T3CArYqInxets7YJ1cwmY8BRa4DZSuo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ta1CNbiz;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790356906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2y3SWVL9xb1mi6/jmBV5roo3osTXZ0gweNVe3xO+8yY=;
	b=Ta1CNbiz9EPLki7yTFVbbLqhN+bsVGHN0Ky3IFd6lDwinlCsTs3OW2y1rdIU/eZfY658iB
	l8aEYwxq+xnfimOS4p8sO0eDU1lSwfcvwZizJHCjbPGSx6pTmxUJ5UOTmCZDxANsCxglJY
	FwHZK1XLCK9skPN65QcH6RWRo+6qdJw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-Dpk2Qw1wOKOy6r-1EGkHgg-1; Fri,
 25 Sep 2026 13:21:44 -0400
X-MC-Unique: Dpk2Qw1wOKOy6r-1EGkHgg-1
X-Mimecast-MFC-AGG-ID: Dpk2Qw1wOKOy6r-1EGkHgg_1790356903
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69C9B1955F75;
	Fri, 25 Sep 2026 17:21:43 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 876B71800473;
	Fri, 25 Sep 2026 17:21:42 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: stable@vger.kernel.org,
	linux-mm@kvack.org
Cc: rppt@kernel.org,
	sayalip@linux.ibm.com
Subject: [PATCH v6.18.y] selftests/mm: hugepage-mremap: fix mapping alignment
Date: Fri, 25 Sep 2026 13:21:29 -0400
Message-ID: <20260925172129.2962208-1-luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: aBs6mRDQVAy47Fqbcdoa59Rjg4kN3Ue7sVe5KT8nFXc_1790356903
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59006C0008
X-Stat-Signature: k3wuus3ifugwyqewuuwz8upexqxefhiz
X-Rspam-User: 
X-HE-Tag: 1790356907-109557
X-HE-Meta: U2FsdGVkX1816JNGqNh8kcqVC8W3zRUnvP3Q6jD+Vtl22CRvkGCFvrCDtcSkbUryrMB1Q7dCoL8tXY305EF11E9+INNKbNk1hgys+2npemZ3NSvVNZ1gav9yO9VN2TcRSFmnqxXDoc3zSI3WZVjaA8JT2fbGfixZpEOZlKm4ULDt+W9oVgqAYOxQ9LtQie2LD5DAhI2IgPJ+K8lfnqq64KVMT7nm80luURW3gKNtFx3mi7g14s3JDjP+OMKDVIW2Zr7DS5CnxHg5pSD606e/lFGVAeCzwH8g8G2CBF/pa2JdTP+znAGS81S+u0miSD27ENeUx+Jw4I3uGnv93mPod/TFR0HufefPV1XEhkFR9jByKVzbEH+JDqowUpOfI2+oY+4exEzpDulsbK4Z5BDGHIrpoQk4NabiySbO26D3B9wmMAkmxiI+z2VrBSefdjO+dd43BzNWKfrpwtz3j+60sjRX/AMcBgG8Kwg5l79jYQodqxG4grCYNw0/UoBLmVPT1KFZrctwKtd7KhHi0j0hJUY67KDWtV9+T5AxQVoiohn2WLjEIM+LjCwFdmPhc9yGb+hmuSk/SM/62UfDv4EdsoKEG2ggq0igHYmWJKi1cjZEjw4oHIQJ2MNyxPdO4/A9pTh3cJGQmikmpGqfMxFy3bju8LY8tRyeKxb4ULt0pfdAFmtQGaWCx1Yp9wbGMeeoWvJ7m7t94pdvOQrZOtJw3Xc0V9qhwKlCs0W6512fYgGjl59qOrqQVzDrS7Ad02Mwzpaw1zbVU5ghAG/quwIBCQXmlsmPsWmMCVaMI/sXRuD8/K69eP4dEhGG8hNUMx+PSDMT6k3e/bspGAC5q9xxF5/UpzWkg0pQg+nuNCJCZ60f/k/j5u0Ls0Q6JWsHDBZQdVoXTdAIcrKHfZn8fKiEvFs6dvfbkBcS7iXRWohGaQ+7meDHhi5qA6S9RzdmZDmPSrlP7vY5L4gALFP9Z6c
 tcr93Rc0
 m5BRiJnbnnjfcXLOYp4QJRZwDVrwq6Z2/m9x7weQxSD5Q6dTr+m2uaQsK3wKvVDQHuxn7XAtbUNY5U0Shs8/AHYrnIwdTv02AaZEsIVBV1BGfpMlBajy0ck87+YwUftPma+xhEPU/OtFgmqBp9r7o5ztDiQjeh5p4YcDa7eXAxlOd6jXOcfk8QeHca13Hu30zeYVR9en2Wk7hV6PN+AFX1nZkmNWa+dEG+8IuI1M/ru+EeJWa7sR1vJQ+gWgXdUgoIa9JrpLubdiV+DSuSQ/PzO/SVH0R0/tyOC6OCNDjDJ2Jq5b5LrXptLDn/JfFJ83Dx/h4CAT5t1tDO++/uNEGmqER5ECptomoyo8Dx+Xe6cAo5xc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Two notes:

 1. This is fixing an issue upstream commit a914785f6349
    incidently fixed
 2. This should apply to v6.12.y as well

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


