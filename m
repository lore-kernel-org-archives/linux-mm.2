Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045F7606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TkGJEPYR
Received: by kanga.kvack.org (Postfix)
	id A12A96B05BB; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2996B05BE; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BBF6B05BD; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1D26B05BA
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 811DC405AB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
X-FDA: 85460344452.24.A84A7F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E8D30C0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkGJEPYR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294825;
	b=SGsw2k3W0HtCII//KCdst2oYy67atM400O5cLzJaTnfHD/iXoz+Bxq5D2lktYz1LNeCZey
	uX2XoWgPQb5mTHprnmLyr6pf3JBrnlX5XAkS1iX3dO2iwQcILbpGhTxGLiWJdUjI2t/IWx
	ngptotJL4an7UP1SS8zKog5TDGmTz08=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWECWR/wrPM7KeaWI0Krr8Ji2Q6YoH9NbNYZaOEOGtc=;
	b=wkLUOILPr1uqaQOyXTmtVImkveADgxxA4VmXhI4IXzbu/Dp4EqWOmqXFe1VRjWegqfhvP2
	Nm2M6cCQvcbjnNhSl2HjU4SZgzr/3TDmBbKFl2x64jz7zPeKrEk78eptNPb0HRpDdib47p
	dticVGF9AseElMZx1QiL1WrATUnTeMg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkGJEPYR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 809C961C79;
	Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7931F000D1;
	Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294824;
	bh=KWECWR/wrPM7KeaWI0Krr8Ji2Q6YoH9NbNYZaOEOGtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkGJEPYRbjCMRYV4cH+fnrsZxwwpfzro44XG2rA8+IHI9sbtjzFtrBvKWMiH7Xw5A
	 pzBY/HvtAIfVoTENTXaM65pb3xh8NLJXb0IRB5s/0tnHj/IX2xsr7474KDLyVnoJD+
	 UVQuprOcm5rVXfJYyjrHRl8GnLVEh1L+qlKtzbvRMB3SEIv8TJ8Cb6iHaHNlsIWQ18
	 UFZWx0JhkT7qAsfvsSPPd1dOUQCmkuYhRoLjB51mM5AMhewPnuDRG2n1gHqFK4ldR8
	 5btC8SvmckF4NtTg21QouUplSoS2lUm490AhSmQTfbR8tY+sYMWxYNOjITeh34V28h
	 DzBgQSTxMIfTg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/27] Docs/mm/damon/design: update for report system
Date: Sat, 21 Nov 2026 12:59:53 -0800
Message-ID: <20261121210013.130397-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E8D30C0003
X-Stat-Signature: a63qh7u8emf1inexaw5b1kercuxtdz1r
X-HE-Tag: 1795294824-817785
X-HE-Meta: U2FsdGVkX19C2kAeFxhxpAGu92qxURYYQk6EoCsMDUOYFdd90tbTWobGPEv4PhzGTqK9VVuQjYBV7nZ7Sj3p6f8AVPlkGSCk9Uik4GZRbEjo4184qmQKPPJUzwp7QaPGGD+ODVZrfH/uZKpTQ6X1/Z5h/gHzqrgVA5xf0IU+2x7IPakDaAksh8nUnFoprZSTKKdv+P5ota5oCdbVMUHga10PghqCnn/baFZ54ZGbsuPLjm6ratmA9bod42VKIDcuumQAPFaQ726GiZ5kXdEmDEiZu5RQRI8Wr30BqSCk9oJq7EkgaaKyvFVce+ifTTfJnk9a3kawTRHNx+NlRTQlycsZV457ci+2jrC0N+MmdaXUMnKVCDPlHkJKiL0+STIDLzFYrc7VPspPtAAgLkuhm4eXA8md7itrk6OQJXCZsn02rs7bUeoXeRhEI0aOzuupbeX+D1hpff3/zC9cUD64oZApEocuwMNUpGXKRg1zEP+USBbJLFVJzgHndgPca+FyUTq1YmE7QfBFxzO+CW3pjkYqGNRMG3XdKiNEATce2u6CP1Wbsu+TDxDDJB7NPN83wm701sWPc6qi9wX3NnxDLE+c6ssqnhU+YJEyK/PxdXokOfMNVGpkWajOXRZ2wfK6eJgdLEYRl7AzwaZxmL8hGBMDVB2AlZE2CSkQRJzoCt/tkJJohevPsIBofFJHZos5cl6H/0pZ3wk9c221lBqvhxE5sWJMuI/8Kz7buUFbua1mpXyeTya2ZkdZuzm0s33cm0E90cHdF3OhL6GSw5tyXxxZu6xZKmgj/Ktx/mWzUepIcLERwEohN4mVwQOIIvtYIrjjSHRygloSQskvntpIdcHXiPVy0JZnpn9u/tKkZIYmOgBe7OG0Yn49OUzvCkw4hh7zLYSw+kU/15FXhMDrvCxAAoHTZmBdEA1BVQpPW5wFDJmEmo2Rf/TN24C2nCaraMDbkvjs3Z3ITRIfxqn
 7O8n/ERw
 ByuCLhoH8z6c37En8P+C3BUkI8zSHoGR1j6jmEKEilPTQR0BaXWVUr9eKnKeFSNkb4GkNTm86AantBKXbvpgigOBfQFHztsTTWcUMvPQ0jghU84uHxBbv76WQaQNVssK6pHi9wqAyWFxpSbXjZGf7iv19RwOem72r9pO0oqpnVwF7zuebMjb5CcdHvCj5JxaRlFecT1BVQcz047tKDTjBPHUcs48bC5JANMTOstnoF8a/EdV9tS9GLD3QDmFoZ7pSHMXuw65na5fuxDNo9LGvIpQv5XChZxvwpPHkvDOB0e2Lu+ZcHcEtuxSgru8Fc+RA7AhplZIftGoDqfr7hDXRgiKE/x2cN62sY0YcNACIZ6xgwaR3Aw5sMohw/7xnc4Cpcf1TQWA9dXkcYZOP50dmFRGPnx8/xDfznvyIrGihF3XAgJZ2tAzgXAnD+/hg/XbjLCXYg3nlUJZzuBr5AFn6XBFGMlOfQNDhO4+08n3mYCC7r1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design for the data attribute report system.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 6284b90054430..5a75a69021a48 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -356,6 +356,32 @@ monitoring.
 Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
 can use the mode.
 
+.. _damon_design_attr_reporting:
+
+Data Attributes Reporting
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+DAMON-external entities such as other kernel components and users may have
+special data attribute information.  DAMON provides a system that let them
+report such information to DAMON.
+
+DAMON provides the kernel API for submitting a report of data attribute
+information to DAMON.  A report describes what type of the report is,
+representing the reporting data attribute type.  A report also describes the
+address range of the memory that the report is made for.  Depending on the
+report type, the report can have additional information.  The report is saved
+in DAMON's internal queue.  The queue is automatically managed by DAMON with
+its best effort.
+
+DAMON provides the user :ref:`ABI <damon_usage_sysfs_reports_producers>` for
+configuring report producers.  Each producer is configured for a specific
+report type.  Users can dynamically enable and disable those.  When enabled, it
+can generate and submit reports of the given type.  The generations and
+submissions could be done automatically by the kernel or manually by the user,
+depending on the type of the report.
+
+For now, no report type is supported.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

