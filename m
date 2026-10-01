Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B758CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 18:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B8A6B0093; Thu,  1 Oct 2026 14:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD626B0095; Thu,  1 Oct 2026 14:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E36D6B0096; Thu,  1 Oct 2026 14:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7A256B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:15:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DC361404D9
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:15:32 +0000 (UTC)
X-FDA: 85274860104.23.A427A74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4C12E100003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:15:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g3KwxhRY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790878530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A0IEnKIIoe14yk04bwWgYY6XA9TxUuiuYvjrXGnIi6w=;
	b=GtQQWGCoA8ljNLHVpCMNqgyz88cfvq2P8AnNHeu+t+6U+Xsvnde2Qy7m/5ahiyA7SX+PiQ
	63ubV6d8YPtQNgL6du5pDK2HMiTRWhBiWTzPClsZnBlOrVKZtxrtypnLnf6sgJZJPWDYRI
	98vCg1UL0D8mbmaN/T3elc5gfj4T5RE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g3KwxhRY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790878530;
	b=1zaaB2rOCdgj12q4x20FA7U3cwW6ERqjsfDMb2biKKedqIOU8BhRMDPkPLaxbcSldQbPWE
	U/hA7vP4WzkEvfSLARIIAU76DUb9A0eIrWDq3OUIN1p+bb8B9tYr3dYmBfft7CNqPbpe3o
	Yq/G558hacbzZohmQ+yMDntcu+1j/lE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790878529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=A0IEnKIIoe14yk04bwWgYY6XA9TxUuiuYvjrXGnIi6w=;
	b=g3KwxhRYwVFgXSfGjp2IyjouCCToHtAbT4upAh7FBz2Y3zgc+oTQvY9QoXdcM/eQBbczth
	URe05bAxGUF3wfgNaXg0t6PCgyVJczEBIUjFwOlbLfOVA5RnbFgJ7S4Ek7yFmPrjyvu5qw
	JJUm1wcCZXAekvKiKQK/tqCPdXLUc2k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-3j7Aynp0Me-5pNw8J8K6SQ-1; Thu,
 01 Oct 2026 14:15:26 -0400
X-MC-Unique: 3j7Aynp0Me-5pNw8J8K6SQ-1
X-Mimecast-MFC-AGG-ID: 3j7Aynp0Me-5pNw8J8K6SQ_1790878525
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1EDD180049F;
	Thu,  1 Oct 2026 18:15:24 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7CA3430000E4;
	Thu,  1 Oct 2026 18:15:23 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: sashal@kernel.org,
	stable@vger.kernel.org
Cc: rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6.12.y v2] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Thu,  1 Oct 2026 14:15:18 -0400
Message-ID: <20261001181518.685129-1-luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: TWer7w1-GvVEKeJLrkebqqPBYWbo2J4uOUrtgi-nqIw_1790878525
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: 9nhfco7nhcnmme5cukau439oam8froy3
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C12E100003
X-HE-Tag: 1790878530-921338
X-HE-Meta: U2FsdGVkX18oYh9KN866ZWgjB6oDPOlHWa/lackFlEshHRpVcv+i5mWs569Cj2kuEQxU+kJrsOJMDoFnA4Fj1ez7qF3tzwc8T29ulAtfgrkRliU28JyzKifwmuPHtBBKGDM8rwzCitwmSajcnGsAm0OQ1LtxN88Q9IBNVQl5lAWgGsJSk9WwdlWidXoav8L/UowzJEHV39Knub55kdupKvciT2QotOnIZQDCQZTQ68Qux4QEpnPWVfd/tA6m3RB9sbXJt9jKVbFYBlbuUTFm/ME1ZeOpGYfeWdr3MJz9CjH89CBXqC2jqIaj7oxnV3HnjOU+y0h5305O5/u3cobVVRuJRn2iC0oJogOIfV58pmGtxZWJc0ncKp8nwvlcLKukmMtilTdx3YsB84BI/7CbaJqTTZlrDy+L/QqlWq1WD9Aw8o/PQOVyLmlWAawiMCI6pCoRAqI3enM73p4kLGsaxccAmdmeMNPghL8xx/yvu0EIcKm0FOrYeMkXwGO7ww/7bF9PQhlcAh1Gt9FqKiKBx9K2tvYuVWLP//PcXc4+4jadSy9+FdL6rLnWJ7ACHRhczr0IeiIqB3wy183Ez4wihXI1dPhx3AlAdzDPIdHG4Hwq++h08qwGDmvcpH5rcgsJQQtsNFw0tErOw+C9Am5Xo8YP/tDKLmSe16HSpbj2qKYI046oEH2Z04WqQhhDlk29ny6ochqFY/GxJjSAaENdJctBU81tPLQAEb+oBQDnGyJsWMRMrtSKWVxqzNPQYneEUhi+iCKPd3dfJsbRJNFr0L4D0bRT0llU0PbLY5AXusJoyBYkOvtXdYL9O9kCAFe3l2HiyZDo11OkuF1sJoAMhrM7EUixxXMOikXfkMV8t2NwkUli2trvDleAn9aFQ6NZIYO+GLxWOXg1C05b0tI1/5HqWUeGnqCtNi7ElEF7K8esLvqYNZQ64e63Hzci2/EaAtxZJFDuENBj8ZnXqbG
 S2OcAF7T
 CnI0swRa9yTErB/Jv6bPT1HBpPJScsDK92NTMYZDaBd2uMwDqb1kjmAV9BbHgkOYgIcO16Cr1zpcX48tSozCbCsfrq6HaBJAgzEJ/SgPsueusyDZhiW41n8BXjD7t+5e3O/9EJkVHUSqat4+BFPdFvXHXA/sfeRou9ruqRGY1wOn7vGBNtbIfG9MfN/DpetD/g6pjSvKdKvK43x4tvbVpeaZonhriuFEbPTR5eSaBq71lS/whaNkRnwk2V3c/pn/4Mjm2sQ+pJW/FE6C2v0ZAGfiprDmFc67vs/Nrif0HBt6mAEqBfJd9nH3JoqzAR1SUmxliMEM4NZMlPyv+MC6Y3iOnHrcbpNkq4cyJC7hG7N2Wb7ZH1hmZ9mRbk+JfqU6VUyIZZOO7Jog3nm94hA4qJBXrEhQ7utYAh/s4GloQKG6XMsCqXy7N3kUDVDe44g24XEPpw4eHtiiPitabtQXlqyxkXb9I1TO277SSqmkTAzhPXidN77ww9dQCa4hUq9EjoIbkgmAZmP3yHVGrT8tHtoquStlpyPVexUAz4m7bmT+qnEWgzrvd+ejg6qHkYgMtuCaZiZV7Lp14hW6ds2ie8kyiqIqR90eBP//6YaC+pize/fy+ObNO2iUSmnkw6y8IXxVSkslVVBgML9eqt/YzobbrTEPFZMSoyVoVrSb4k3SFeo7cficowgngecBE0Qxq+9zVJ700m6SrZBLLyCSOIT1TlxjsI2kq0xu6c141NOML0CpFnTRyQIRpoKxYBINYiXiCja9g+xi2cdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

commit a914785f6349da754e1226420bf4e51961956769 upstream.

hugetlb-mremap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-42-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ Backport-notes: this is a partial backport containing only the aligning
of 'length' to the hugepage size. The hugepage_settings.h include line and
the hugetlb_setup_default() call are omitted. Without this fix, the
uffd_register() call always fails on arm64 with 64K base pages and 512 MiB
default HugeTLB page size causing the test to fail with the error below as
'length' is 10 MiB and not aligned to the HugeTLB page size.

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
]
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 5 +++++
 1 file changed, 5 insertions(+)

v2
- Preserved original changelog & subject
- Small code style difference from v1 due to git cherry-pick usage which
  preserved the original commit style

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index 3070484f9ed0..164bbda8128f 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -87,6 +87,7 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
 	size_t length = 0;
 	int ret = 0, fd;
 
@@ -104,7 +105,11 @@ int main(int argc, char *argv[])
 	else
 		length = DEFAULT_LENGTH_MB;
 
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		ksft_exit_skip("Could not detect default hugetlb page size\n");
 	length = MB_TO_BYTES(length);
+	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
-- 
2.55.0


