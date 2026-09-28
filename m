Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4B2C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA956B0096; Mon, 28 Sep 2026 09:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB8E6B0098; Mon, 28 Sep 2026 09:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C31A6B0099; Mon, 28 Sep 2026 09:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3816B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:11:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACF521C1DC8
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:11:36 +0000 (UTC)
X-FDA: 85263207792.17.544E0A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 807DD40010
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:11:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/86+DIc";
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790601094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U1oksysxdIEOFzBPfANmMTd4+i/t9FKmSwmS/c9F7Hk=;
	b=tErkaQEnx2gdEFPDVtCpUmDYZmJ0ZUWFu/0nnvsNRowgNB0vn7eogBg5tdAmpcKDz4zjzV
	JvpjE7oOIeyXa6t59KSFfreNJ9bQsW7SSPQuyxHqtJ9j7krFDO7bdfXojo/fgdW6q8I4YC
	r1scP5Awp9/fzNMiFPpt2GZYYBEdHzU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/86+DIc";
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790601094;
	b=ot7M0GjSn278OFNh2JYN4VJsgXeDFSo4MhtYl+9zc4XJ0t5coXKUNh8S1ob5BtNMtmnUUn
	moTxwVl4SMm2k9pJx7GRmT5NDkjA2bJSNSR3c6THaH1EKwGzoyejcDx+YaKUJLxLVT1m+e
	pVmTIR0ah88+rKQChryOuAsGBjugAtE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790601093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U1oksysxdIEOFzBPfANmMTd4+i/t9FKmSwmS/c9F7Hk=;
	b=Z/86+DIcO4VXE4GO80gPSlhirLrUiPcDSoqKZg/TegwIBGHUzX/ChE5uuUyUrRqQy7GDY3
	xreYnpMYGNh1ZRvWZ9Bq7d8+6DNc11hiHg9PKFnCbdT/Rm+Mmj983iudIz8H8HWTBgEUHb
	wrkPiiBRxO4OvUGHTQlrU5lOyzGDoFU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-nhfxfn3VNHmacMGaCHo8xA-1; Mon,
 28 Sep 2026 09:11:30 -0400
X-MC-Unique: nhfxfn3VNHmacMGaCHo8xA-1
X-Mimecast-MFC-AGG-ID: nhfxfn3VNHmacMGaCHo8xA_1790601089
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EFFB190F985;
	Mon, 28 Sep 2026 13:11:29 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 124F91800473;
	Mon, 28 Sep 2026 13:11:27 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: sashal@kernel.org,
	stable@vger.kernel.org
Cc: rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6.12.y] selftests/mm: hugepage-mremap: fix mapping alignment
Date: Mon, 28 Sep 2026 09:11:17 -0400
Message-ID: <20260928131117.231700-1-luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Tc_tXTJNOkVzuzhFpory0-GoGsNMB8Af6RcbbWI_h3A_1790601089
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 807DD40010
X-Rspam-User: 
X-Stat-Signature: 14aecttgng33wr8s3poq7oq9mhy9h4jg
X-HE-Tag: 1790601094-338139
X-HE-Meta: U2FsdGVkX1+D03hmpmtUghR/yGxf+yOSxL5+GpfX/IaUSbA5IxUC5Es4ZxmAuCnKCmb0iRvJxaIfnaTwHhvbxQ44yDROVhMqlf6EDtYTizNe3FzoZL/QQeCweB2nvaVKGoYnUzpwqFDAVtrTiXfqPJbaFccgm3v2FTjqjonFL11P82c+2Pvws7Y29e9YejZnGdQDwSEmv94f2bhEpbBqJSt9LZuI/2OFL24Vz4SelY6pvf3x6xxMz8h3Ve7t3ntvqHLTAkFhhf4HRUWfJXH7zr9esQ9k2b8OEUHWtiJVlcbTFjXnQud8DV2ysye3DbxZ2L1rg21aC0wQQHfGUP/HnY3K4dvf4/3lT33OmjKd6ks8lxMRpGnrcyyYmFXxhiOXx3AlwMFWH0ebA4d5Ji49d/in8IfGpVLfWyVk8gcrQvUwc3zK9hhmWI/C2q/timT8cR8p9DdWc5v4Fz+WS4rcTmw3/DndsdZUKRUgw/4Fg8B5SWicU75oalQsMrOWwfthsnWDczFsbYCRAxS5MLNGDREMXtbspcRmaQrUZ1xvh3zS7BBHc/35Pk1BsyqxJ0ecIVqkmFzcCxO9sUCCsry8tu83c7XbW/FUmuh0Wgz0UiVoymwgYXiQ7q0+g/pic0J1fdoLlP0DV9usYMXuIFoP+mAgJnMvfJihHlhyrR0u7b5iVmYYb2RPH7d6YPTzmZrWdL+WNjipVLCp1tmBAWp1idu2vg3WJCumQBJDON1AyfGJ6AV0GyuV5px/unHqPFlOXzo0cVVj1MGfCGjJV2xR0vXmHAlqGCrRkr+tV3Sjo65LzByt3B2b/2i0zgocTabIMspW00AqMGtedHHdFt+rktBUopCuHratVZnZwPlYKv9Ejn6itmeRfOHZP7V0oErGLsK/60UZSl18ZN9eOdyQzFwKxAHuhzBgvMA9FVWNwCCK4aB6fdjs0tTU8gZjEe4yHlj/uP65prhpgTYZF7L
 lsEpBseD
 EwnSoqf2U/qc3rTL25biQfMjMYgJ40f7WU6hG1o0zqM5i4j31BU3IvBHke3oipiC4+g2GeUIw1PkTxnitzqu4dNdYGEfD+GkVj7WKe1oHjR1naxHP9nYXX9f5DRdOTRLtxb8q8Jqo06UHCKW50zekyQ7zaezluhPhJKhVtCjLMDdlOFCv5eCriSdPbC69SMCnLaUHWzudzzH/vUpz3mfeo1uJFwpNZHyCetYGSA8TTsyByNqXaRdUV/m3YQlhS4hekikSe0DHiSNruA4wpCevoutdKFQvWYfLd0NqTbB8IhHHgXGt3FBIfUf0W/D2MzsBCLR7ZfFMqVvcmu4wOZZhHnJgnwxTeK/7OSPDzlaikYMahH0=
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
index 3070484f9ed0..42dd4eeba52b 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -87,6 +87,7 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
 	size_t length = 0;
 	int ret = 0, fd;
 
@@ -104,7 +105,12 @@ int main(int argc, char *argv[])
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


