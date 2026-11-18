Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F0F606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzPwKcZP
Received: by kanga.kvack.org (Postfix)
	id 7B4136B05C2; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78BD06B05C3; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653646B05C5; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 412826B05C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BFC37C061C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
X-FDA: 85446641154.11.5795E4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E41820008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzPwKcZP;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968556;
	b=mLFgUTGya+4BZ2Icx6Z+uBiDlDRrp/dO/6niLF2S3LRMqAel8VMYBL+bj8RNnPiyHuRzL0
	msuuF4MdcuMWKuGiqDcwmfbXa3yH2eDdb5wqL7FOovn0SDzfmgAx4rykFamim+HAsnv1hW
	La72/B5SLMdJRtnjaBezz06DDhPRXWg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzPwKcZP;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWECWR/wrPM7KeaWI0Krr8Ji2Q6YoH9NbNYZaOEOGtc=;
	b=SmZBlKR/rHVzzdM8X1XYjTXJCY/MalfJyKCgBl5GlNyWIUn5gnsVEQDt3gJzqv+JCQUUHh
	U+qICAor66Pp2FxY+w9AMMCVJ9TnL7ylsUq9cifHJA++Uond0daGVE5awmdpy5wdmnQmgV
	gewcpmt7fBha7/9MACXRZt5RiQQhZmE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDA3461F1B;
	Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664111F000C5;
	Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968555;
	bh=KWECWR/wrPM7KeaWI0Krr8Ji2Q6YoH9NbNYZaOEOGtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzPwKcZPN45I7MMRE96UwlHeK6+Og/m7Kj/gGEDesua/hFjUQ0W/5FC0eZypsRRt0
	 EFdAnb2pKxaF5JFzDt2Nk+PsD1i4mV4Qm5Rr3uehMPB0WQeI1Oj0kAhS3xQI28Fz5U
	 HWvW5GSVEWUREb+gojOviS1r7xBPOPHw/NcppARv1sfjdg9jIhFoJ3+F/OaELcCOL4
	 ZrEWgqp0DgLru2wymRWhNfgLDvAFO96qQffpuNfgjaYmUQXn4SNbXQVbaV/h5h5eeE
	 r4BCkXfiGwxSZ589tXtt28z/WqTREsZ9jhGcGx3caGtVmzJ7DugcgRYiUWCka/IkT2
	 jowOohlJufsAA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/27] Docs/mm/damon/design: update for report system
Date: Tue, 17 Nov 2026 18:22:04 -0800
Message-ID: <20261118022225.100659-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E41820008
X-Stat-Signature: 6k9hongzp1mck5m5zrrfderfncdf8xgb
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968556-63478
X-HE-Meta: U2FsdGVkX1+vAXkIznqFRfEq8Wm7d1MoLBP7j7X5xzKNw9iG+v6TQYUWqFmVv2ubPLF0TuRQ9wGUkZZUpj1wJ2retA1a7MOujr66Z9qHmDWR8mmtNVz1omq2Oecw7Xbs9KkyuRG5j3e8rjI3+bd57qm8EANFSTvby3/+uKv9MibQoqOzi0R5wfbkJVysJKbp74D45mjc7wwx1j66nZmMwEogFkXYQEkG7JKCWfhL7wXQR0YVy5Y4rzDtINU0geCRHBQnWUWFHD+jW8ha/r/Z3qCxWX5Monj8ejpk4Dj0XHKorkLtYprVyKOjAHavT7WganTlapIiHxNl2FNoEr1PTcOL9Nhd4i1BAmW+oqHGW+0wTcquKQcUJ+iNbCrrnJetz4jldKfWKKc2MefeeNhPBoogrTpU5CwNORBJLlF80js5U8l8j5dhI4uc0yjDo62ky2nKtvUHi4iCZha4n+QvOORWGUtJxGEeGV3t7B98ntz/7kctuKmp6YFjvGxte0ja6cj2pXkviG4RAiq1lbADeft8+/al+5EItTTQ5hLk/x4lZP2/m4dQAtENvSOiohPK6aHX6L5k5yeqvZ5KqZf7bzPX2hISdyG6Uc9UnRYaUde6ee+C5r7SC3Y7I3p7SIzBchNXRf7QpzzAa3XEtgHY5c/pKLw6FFaN2JnnODuVkg9koSbkttdXRtLUk22Ox0CKvrc45HzQ/J6+EA7gyJjxvbmsmq9b7tJk95c69l9OH2AsSNZ59x1td5D23fvr9km0V7zyYQqffLkWtlKEDhmyosc0XwiyXgvkbrzZPCuWauzlxyNhE+7rznLhxzPDISnkMs56E1nk85OaJvj3vSe5K1hkKDjpIywcPI1pWBD/ZNX6hA8XswUpYLv5OFou0bzVDrzcIl83muHaOtAhlZ83dURCKq2xcUv7U9LpPm7HwiMGu8QH1Q7v+tWfktbGIvlayDRUXOxc521Fl7yBs+5
 ksOKWycG
 MD0HAzNU5SwCFewlfuX54Lo7EUDr2bE89zILwikwka5i+iKhmem8Zh0QMs4a3IFTyFaujN1HN5xfBqMmFrh2HayYlJqCCDYWQrkja+mIl5CT/3hpKtMR3dEvIyMZyhOPlr33VcWqbSAp4Nwkqfq3e+6t21083f+oIV3IO7be5/qnbE3w1sQwn+xkRbVJ5+ycRws7B/rCkhS8EF+/IFoVv6m0eJ51EvW7TCrjOxmA2+PglkcZrrIKnEPVnprYaTNs8IT8zCVOh9iJqlSk=
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

