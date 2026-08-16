Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4517CC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBF96B08BD; Sun, 16 Aug 2026 18:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4626B08BF; Sun, 16 Aug 2026 18:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CD16B08C0; Sun, 16 Aug 2026 18:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB7C76B08BD
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:48:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44835C05F1
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:48:05 +0000 (UTC)
X-FDA: 85108622130.10.76FE2D8
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5EAFA100007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:48:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="G FVDPNv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Hz4HNAaV;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iai5LJEqyfwXNhMcgzy+VoGlTqvQD8cplGNN5rO3Gn4=;
	b=ZBGLpOuvx25A7G2QzXvczA7M8ftxyBFiRP1dkZTmUnT0MOb8s2FCpJYgQXiZhn38V7ZC1m
	kk8kvxHPhouNAIeqTyFXHtsoOUN02kas7DbdZCElxE0b+ehZVynnkNMihikH3aWb1gpNcE
	G4a7KwrT936MdvdH+ks+BtHv/Y0ORhM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920483;
	b=LKcOfuZFHy59EaaNX1QNcpWaoPDlQkm3jPSicHv63pfmiGhZzmwmp5vB+9AHFUxo+rr/2B
	0diaTUD76aH0fOigxpmVgAgcOsJlaSG8b0yS+8CQZS63QNr/fSLlipp6ghE1Q5iqE213Z4
	sdsVlyJvmakz2F0RbsakMSWbNNDdpEI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="G FVDPNv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Hz4HNAaV;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E8B7A14000FD;
	Sun, 16 Aug 2026 18:48:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920482; x=
	1787006882; bh=Iai5LJEqyfwXNhMcgzy+VoGlTqvQD8cplGNN5rO3Gn4=; b=G
	FVDPNvEdF/lL/bDhKjUQATKlA6pTWX5pDq2Wh5U6aMTM9BzGaSDO688Im2i2YsZr
	RgZLwS2n+5inMq7Sob+xaV5+TCHHdQG1qDsXXUMDes8OSNoX72MFONQN46UfiGaT
	gmUPI3kN38+KKJmS39xN5epeDUOgbe34UYQSTXxEscLFjf44HpGbu46bsYtgURrZ
	hz6oW55iwh5iz4ibfqIA0SlbLWZgVWwx5fgQBGNHTH0sDswgjEjq2xeCLlqIwx7k
	OjZXiy7IskzyAQXUmhglwRWDYBI7GyO6jyOInK7bkJYi7godKmrDUlhG0svHBspK
	BKCCz6S1+MQLpB6oJhZ+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920482; x=1787006882; bh=I
	ai5LJEqyfwXNhMcgzy+VoGlTqvQD8cplGNN5rO3Gn4=; b=Hz4HNAaVKEcF2CWJo
	Om6xPuGHGt2tE6CzXz/iroFOtOXu9jVJ8U1KDKTNufChodRcuF6N/9cR+S45Gc7g
	U2qTpO/u8LNLszJ+pDJwpQfivAb1vmdzkS/riL3/qXvhsLcKxH0fNGh4G6ViFzFC
	tlhWV4G6yKXiImzcb3QnFXD/nY+PbuOc5yUw15F6eAa5vnCNtOnYN9ZbnxZuL//0
	qgPvJyeIyqZPA3gpeNlSE77SZhJx9bF3g3hQp2HA7hU3CDoVLugXJIMJZSUwUysW
	d7g98jMRabHLZTxC5QOF9JigdxfvevOF9qGHTsmEueBRNVNgfHonEANULwlpslQ/
	iq3cQ==
X-ME-Sender: <xms:Ij6CaioSJsqUhI4Aqnx3wt2s0nWySiT1NeBSaIjGrFArF2py7iF4RQ>
    <xme:Ij6CaqNvDc7Td3dMzxJdZ-Kt7IR2H--Sf4Cf1huLpTAyGgeUd_Dfbvp7yhcZKzlIF
    YLyqI_5sCybxeqxZGp1SVgxJMsGCxuP34foHNH741tX6Ykq-Zq66orC>
X-ME-Received: <xmr:Ij6Caird1e9QSdZLPmEkfVKsG-hEMJo4kzWBi2nFYPgFp1GlibN8QyRHddY>
X-ME-Proxy-Cause: dmFkZTEdkpHxwPvghylIRiDh2DXj/W+5rHHxiNSRAV/FnUvF+pTHTSRogpF51K0JMFOoNq
    FXR3xXOJwqbxi3xnpOR1gVnxkOx0+3lmAqj6HIZkTE7HCsj4rfJi12LdCUf4noPIB2xzxm
    G7I/52H/Ds2kSEPPWl68t4mZYEFuU9+tOum6r1AuUpSuXeb/EuVzDQV2mgKoQzhJqWy9WS
    TVItjwfT9Ds7erymUHvJC6I4UFiVodQ+tEdI5cAgcJk8Vajp+hbWnlKpegW2smcmqEpO9y
    vf97AV5jaic/zQ1Bw2Y9IMD/RUnDCUvC3h/3BgvkY0X8lg0WF0YKtDhM/4K5gFEWm8G2hC
    o7UOq1ARSQoAFN87IS8L7LmQD0NqIPY7B3lg1mFqX/Ux9m5lhs/bBn3ORbVqzOiq5xkBQH
    eMvoSuKMYDFCUz5886MTOlInYpH1NMOThGQVJpNdwJoccgzj6LI2NAzcCnEuDStOxdS3Ob
    t7IJbEzdcGjLWgq+oRueBNy4DT1TJGHM6PcqkdDdDDoeUE9kieAliwATf6dSYT+wGv4zS8
    PNNAWvqZZQE8EQod+tB+wj3MtC6rQT+AzOTnzegSlTSw16FRcdIH8OOwF9BXYH+8WCobx4
    N+1qrWjy3Npgs0clVyYZ0uus3IX3Vf/faSpYjpWgaZtEl4vpp9FuSha/Ga2Q
X-ME-Proxy: <xmx:Ij6Cagko3JAvb8fMKFhrpQD__u94Z7-YYZku2lum-7QB6QLigMaibQ>
    <xmx:Ij6CaixAAkAfGekw3AatVXYZGsAydjRbujxVMotnnR75tf2lPNujWA>
    <xmx:Ij6Cam0v9fPLp8U5tAs4LmdJjkJrrczGOd66tLnpOx7H2hI0mGhMUg>
    <xmx:Ij6CarbDdgMLosGVqBmC_0tjhS9tqo07XH2nWjprpLIOJsowtDhxPA>
    <xmx:Ij6CaqEsI3e8D_SGUBLJEtTHMZ4NMCfxEflyw8uzpoFBx1MnHHKWyloc>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:48:02 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 57/57] MAINTAINERS: add an entry for collapse
Date: Sun, 16 Aug 2026 23:46:09 +0100
Message-ID: <20260816224609.308019-58-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1ebr1qphy9snyys5kq4hn5rsarmy99mk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5EAFA100007
X-HE-Tag: 1786920483-14401
X-HE-Meta: U2FsdGVkX19T0ApqTQbHAwHwUdLBS+GSY2Wb3RF3/RK8HSRFohFOuYlqBI87JEi0aMJEVPueG9OtSVCEThsObvJZHFJPyN+5Y431Fy07D53s2v/TtPELG7ajGlAIdryteF9b71qtl5UQ9mYdCZqmsO8kWJkuUDwnPlPPNl2XVVByhMYdeVwcRoXxM7FO/6vYIQmGmRneBI+CWC4jBqrsVoBfgjowRcLBTrJaIuzbvBcIRc9KPG5W2Te5MJ1fwFcTsMRgBxKu6YZSIyJ7/RP7MvD8Hv8BR8TvH6j0bIxqQCv/7PSlQZXoRhYgJ0yvGfz2PZ7TOjIqyleh2CF1LynDrMn0hVoPHsEuywyqkunLFghP0wnFBzU0ugzNG+o38l1AHjpN/rT+Qan/kaf/dSwjLoL4Pw5Zn+vTl1GucJrXiCdfU3i1AXhI1Exs/0AdeVdfg5EcAwjbaoKf328Ch9vM6NSCIx97uMATgFvmRZRyUVwAkxgXF0HgZB6jcuwCbK5i2DLfJwdS0PUUpjSAyWBv+1RjiNRIS3ZWoAQBVsyxT3aSLHh9flRs94xBlzLgFR5XD2YjSrLdlzkPGXcbhnAXAMchgpwsm8ID8azewFZ57x2oWS+kqIr8kNAa5UOkYFLTKTgka+sF7n0jYe68X8VK7GFf9HVxjYQqhmR4DH4GeWWEhBz31DSvrJuegRjHuumvOLNVnJ0DjJhxdEfddJ3kB7yA9iaQEc3+yvdmw9EA0fP4kp5hbfkaXJ7efDcanis8nmBz6BTuBIQ9hSDqsU0YfI9YFHHkq/p3MrwTa1jy9DfuIjkTX5czs3Pmav1wMZJq3od6fBim/9Edj/DDNwTMct+xRbQP+q31IKvV9knmuaZ4bPc3HRK/Oab6MndxSgMbFi256IJYjXiq9IIqibQMQh8Ad/pL0LttdkcAj8ExWDZ2WU+7cdIKzTqmWBOwaCj+E/QwNRbUIlKjDopLxev
 nDHGwfmc
 CrnFSpjNhgejkjqg73DjMZRW9kk9YwkYlyM39KiE6thjs4eI6NReoKsn3T9CyVbdMfTBI9eoZ9N/7bpm159jYIL/Eg/q0hf2xrfJTptFZegftp3NnLi0XnxO+s95OD94KAv1yCIX9IRC/uwakd8zGQ20PygKp/mV3fm9WVCJua3RokOKQy1G3UiiCTHdeP0PhQhVrbufiGQGFvWPV1sSa9BJDUlTTludOyFak57iJIP1hkv3s5TQq4FM6tDejRWJdFREkmaCj/1cL3AcW2hEKxtYnY6gXlLVX/+FjcysKD1qqF+Lm/zxJiu8wm880cqo6g8o8uGu5PP2HQHHjlnGZDsZgwgWA+aVtSArEvrERL7tVdH2+dzlOqaGdZHDl/JrGnT7b9GdkWYaGYRVVlAacIsvB+/O8j+KruANkOjE89NHhgMb97Y13iYL/Pfrz/vRQxmPH8BY4W3FvGpMyF7cmjSUxPqFKBXxseJSAYHmYuEkWMrNvdK24ySDPlkPyMpNzJ755+aTz1EdVm2BNWpRocmEupJ5Y0ojXP2DQIq1CgYIrG+tQjJc3VSHTutvQsRvJvR2qd7f8QbC+PK7A5MQAw+ahgPdwQ5n5o5zqY6kVfH0zGhxQ1CE0b/vOqYN6KxljyAlR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Collapse is now its own body of code: mm/collapse.c, a header stating what
it offers a caller, and its own tracepoint family.  It has two callers,
the khugepaged daemon and MADV_COLLAPSE, rather than living inside one of
them.

Add a section for it, and move what belongs to it out of the THP entry:
khugepaged.c and its header, the trace header, the selftests, and
mm_slot.h.

The selftests are matched as khugepaged*.c, which also covers the race and
sync-check harnesses the THP entry did not list.  mm_slot.h stays listed
under KSM as well, which is the other user of it.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 MAINTAINERS | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c179b333e4e..4e4e5030b979 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16955,6 +16955,20 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/balloon.h
 F:	mm/balloon.c
 
+MEMORY MANAGEMENT - COLLAPSE
+M:	Kiryl Shutsemau <kas@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/khugepaged.h
+F:	include/trace/events/collapse.h
+F:	mm/collapse.c
+F:	mm/collapse.h
+F:	mm/khugepaged.c
+F:	mm/mm_slot.h
+F:	tools/testing/selftests/mm/khugepaged*.c
+
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
@@ -17272,12 +17286,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
 F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
-F:	include/linux/khugepaged.h
-F:	include/trace/events/collapse.h
 F:	mm/huge_memory.c
-F:	mm/khugepaged.c
-F:	mm/mm_slot.h
-F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
 
-- 
2.54.0


