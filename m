Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E890CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 18:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4516B008C; Thu,  1 Oct 2026 14:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155B46B0092; Thu,  1 Oct 2026 14:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C396B0093; Thu,  1 Oct 2026 14:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D84116B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:13:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E9241C3203
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:13:54 +0000 (UTC)
X-FDA: 85274855988.25.80F3BCC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 658C610000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:13:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FT22BYDW;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790878432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2K6+AjrHHCLY+3zXw5HOJ91vX9fbZQsVpcAGubvt7/o=;
	b=6sSYHSpFKeGJ4+I3MN5qwi16Z3rIrw+8uq+CaJJvY6hO0G1lzwQdKb+cMb00+TONCes4aJ
	ir7r994eKz7MzO2oDEpo9MKefXx/itkKG2TE1R0a5EDL8E3QrDCMhLeZwkck4KIQVea85G
	fCSJ8k2GFYlAl6Vb15G/r5RkzoqQQdc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FT22BYDW;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790878432;
	b=lRhs/ZXb+IknHegU0KVwjxPU632qmrqM4POQgTHmVZKnar03TflBu6obyaq3RPyOK8xa5U
	CCxnJBlVrfTr+FcRcu1RI7jwx1bnDkgBsjiK1og8WM579HgZZG9n3TvCck5PzR7wGAI6m7
	w4+D9x3xZAzSdr8FwM0NOzym7qotp18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790878431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2K6+AjrHHCLY+3zXw5HOJ91vX9fbZQsVpcAGubvt7/o=;
	b=FT22BYDWFvDn/eNjJ2dXXe3Bs6B/WQdk7Ujl/ixp4AOqYzGrtDzh2Jxm2n0Egb+KDeadvK
	p31oALltnfbp9yV0uYXAlgv/7xR5g0ze/b27ebX4JYibarJCOjOVJDjh7uZam+u161nabs
	2YS4SpLOJrM2LBaMmIQd8dtPfMvf9jM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-l93d_TTfNca1FqR8r5n-pA-1; Thu,
 01 Oct 2026 14:13:50 -0400
X-MC-Unique: l93d_TTfNca1FqR8r5n-pA-1
X-Mimecast-MFC-AGG-ID: l93d_TTfNca1FqR8r5n-pA_1790878429
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B36B218009D3;
	Thu,  1 Oct 2026 18:13:48 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4CED180059F;
	Thu,  1 Oct 2026 18:13:44 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: stable@vger.kernel.org,
	sashal@kernel.org
Cc: rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6.18.y v3] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Thu,  1 Oct 2026 14:13:30 -0400
Message-ID: <20261001181330.684841-1-luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: KnymzyDoxVerwxeNqLndR8CtoOdSqWe5TpZWX-0ttzY_1790878429
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 658C610000B
X-Stat-Signature: 8afqrqpuhx5j8mo5bq1eyw49eomby4u1
X-Rspam-User: 
X-HE-Tag: 1790878432-960078
X-HE-Meta: U2FsdGVkX1+a6ILRRXvjXXI48T21KYMqZl7MCW4IuggPxh53N5FOZXpl5h8yz/frV4++AY+Bdeg2zPb9lU4qoMrUcBm4zAT10LJ9h/iFS3i4UOkb/UKYBBQMxnUAepfRDpo0Ll9/z9Tna1z2N76C5F6s1pAi07H51lJkzb3tVjLx/QnhNb6cyUiCUgEv0DQ83xUV7Sihu04hRqlQMD7yuZ4D4Ky3LVBRWBz1rSRc7sIna3Wp7bAhOrNk5OGbL6h/X/1LQhoM/FoVukHL6zOXMi22nHA+rUoNsr7ZuXjy0PSB5ranZgCCh/ebyuRgyVDPZPPs4xWvtkA6r0rYLd7szn56bTjOpuf8ElewQvJp9V/ejYraNs2AW3jLSL2wIDb8YUiUuagL2SAZ7ug4tau/ZYYmiQQiavpHgLEs37vpN2cs0w+CmKfIjSilv8E2C9sjQdPezVwf/sj++gBLdGnwNfTvQx6ePilvjB+nFWEcrSBPuAB613dWryry29rplgRLaNrdz/JcGFuCk675mBXEIQEHdMKsB1bEXMsuilvL/oQL6e9EtcnZMsWQWDt9O9tYyvbJaJRSXn7M9cC9eNkDjZX7xSOoQvF8qF70xd2NbRjVxjq74ultdofv5KqEJjwHz2AG6SWcrXP6fCHjNP1eQEMLqqq/TrBZd91MieEkv3gyAPRQ1JYjbz1ouFzTTO6dJdEk9Igx/J+B4zgUkVYZ9AE3TXrYU/zayP/PK30PBVbbJZfkuUu/IWZo9ZV3i1G81mTkL5gISpIlf4t4+pwaf0NrIE+cJZou8ip79SuKTjA73IJe1xYE4QcQ0jjOpLmWCHYX9jjfQC6gIeCu9WPDDSFm7vu78q/s+5exwW9Ei0GSD2Kw2bMDCOR/y0aJaFjUPx+DIqvCjRqVDzo1Nrtf0nJuujSMa1JJLuF5ASy/fji7kXu97tNbE+32fu3ltBrq5sVsZEzfiqwbI0Tr+7G
 HYsgeVr1
 ScsZr+KIDMmy5Z+Nxw6cPmOpC+5Bv3FU38hfeqWEGTvHg7S6yvgUhaT91c2GLFWoKkCcxqwvZkDLKvQ/ILY2uKkV2n9YC5P9Wu2HmO1T8MMWnWKhQLN24r3amFs+5SAasYCYlI1pyd5iiSpArOnztWE2vuXYmYKRwEyrREXsKqa82BQtBx4YGRI28KE7KJhADL31ttJIzI1OG3a0qSQD+6T2NBi+NsL0FRwPOsgD/ePUFrptguLKeQe5dQK9FJN2UseMZpkF/eJYPsnsJrgg9avn9TCewHFcLx/3cPqr0FImG+fAhS1Hjg7iD6QhQltxNgkrRrTTQRoqmdQ9BAyJabZM7H2sGwQH4a3RPsgkXjsoSmI4CclyChhTgAW6U9SsnVG9XKqz5JVBN1Mnod4vz0B7c4S/2gQf2nKnO/dR10xQ1iZYEgPwv3+UojzBxjeM8slYybYTGPZ53NfymKoJhAR7coAg9Z5s/DnoNoh8GhCSY9X4Kr6FROa77ADtOfFlKNtZv2WaHBE1wG9JZjpwyyc707AevSqRY0OwA+JrzpzwQah8bcVd3SHcii3M6GX3L2QxxplVUH5W3z+BE/XtZhpUWl19OPIJ09H1+ny5YvXkMx6B/T7wAmqUH0CY8dFV8L4SedVSF8d7PCNDQzi0sximQxJpYX6IWTqTGMKMhJEs4tLgGBAqxmt6HWg==
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

v3
- Preserved original changelog & subject
- Small code style difference from v2 due to git cherry-pick usage which
  preserved the original commit style

v2
- Added "commit <sha1> upstream" line to changelog

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index 928c1045e295..d6caa075a86a 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -97,6 +97,7 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
 	size_t length = 0;
 	int ret = 0, fd;
 
@@ -114,7 +115,11 @@ int main(int argc, char *argv[])
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


