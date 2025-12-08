Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB2BCEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A546B00AF; Mon,  8 Dec 2025 01:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473066B00B0; Mon,  8 Dec 2025 01:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0AA6B00B1; Mon,  8 Dec 2025 01:30:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 279C96B00AF
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03E4E52E8C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:45 +0000 (UTC)
X-FDA: 84195330450.15.07E881F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64FD5C0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0xtLSkF;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175443; a=rsa-sha256;
	cv=none;
	b=UtDTJMDyKhWiVxxuZKDxa/+FMJa7mYhI84teH4PWizzt3B/lX1eK6wt4ZPHSz/KKnv8FMY
	EITDJsqiwQTIh48RQgcRs4L/wQuFsbj7WEGccrwJs/3qx1S1HqRgu3jQkWW0UP+MVxtxJU
	jJVtIIk+4RwaLlEr8Yv1AgbOWbIq8jE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0xtLSkF;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TASd7ypsbHELRl/iQIgcgE3faoafoP9DiIxXpNk8vUM=;
	b=AWBN0exDBN42WCpcC2tq5uhsJdOvEOyfH1v/4aFVEXzh9UEAnDhqogsSqMoLmZWtLsbWUn
	AgbzIYwTrHWTh4kmuXM9ow5J/sBQcRfQ6rz0oLcEesIb9MHaMRrx6+P4D0QGi3GOVsMsVu
	4UK/dOc6f8Wpq7isB1HUMWtdeVEAOjI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 969354390F;
	Mon,  8 Dec 2025 06:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA08C4CEF1;
	Mon,  8 Dec 2025 06:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175442;
	bh=3vYcUeBmXr4garxcQHjJx07QLWWSN2yZSMq4StEXQLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0xtLSkFs7pqEae043u1j3xnB95Eun6fs+QGZgZO9d81R7nVANe8WzFd7INUNaH5J
	 G0cu5g13QicS+7SpfXLfFYjeCO7OZky97UtEnCU1Fg8vOIqL0guCnn+Met1AgHKg5M
	 5NTPXJXNgEVF4hk8vk1FGAsAu82jhb0v522m+QxbyOFfL7UlnXHN/ha84/c+mqS2eq
	 0qSRuP9CaCpfcNNAkk+LdrdatyCNz+99Jk1hlLUrlAc3UBxmBAqyPlfv8/yoebiFZt
	 WeGrFytSTuFCntaqviHlHDTKBMaMONUSg6xP56TYbN2K/XjRoJDfgJDnBS6pPwmnAS
	 6VzqV0nDquVZQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 34/37] mm/damon/core: report whether the page fault was for writing
Date: Sun,  7 Dec 2025 22:29:38 -0800
Message-ID: <20251208062943.68824-35-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64FD5C0008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 5kmmkq5txy3zhnyut4edzdtatdocwgxq
X-HE-Tag: 1765175443-798716
X-HE-Meta: U2FsdGVkX1+zCVnfMaMTvhtKZbj5KhYyFvzO0O1Gn1R51rYK0zhAlgBY4R6QprtkzFmf8Emu9FF4V7r92qa+aiRtSOiHMhjZ0d7gifQi2RrS8vPUYC3SJ3eOOrVNe6evvrDIykVFxRlZsF5VUgsd3FJPr/7bkefREh2IM1RU7qvPW1gIGGy9tbNIcNKrWQ7I0xclujP6awWb7LD6qK03wphJU/hNFngdNlEwg9AYPYefzTomV8D+kzMlaO+4d1W26jhlEBEqA3bhk7/AdeoTKrC9AfP4xRnbIvgTuucCUHkbs8vI1W3OH9PH3nrx5Ja96FempwWHwn1hWcn8Jx+mTYF9jjOo3CrxPP3m7fActGoS3hGw77/PD7nT0lAvUO/aumPTevXnMJMtFnK4ChmNytRBrF3rP88MPbUHZLM0dSf1XnWUQ7uY6WRWsB1cfW5A3HEFETVvAR4k38p5AXoKVZAbXib6fWXdh/9MBt2vVNEGqTC7LR04ejinEii7ecufv4GQb+Fjr8O+CQgK3UA7c7jL/9ibsETTHaCFPhJKaemwVdXAG26GRcuxGqjok/jezJfzgnmm3srw+cIQgArs241hCOY2JZ5RxrlSEkEkv4qIQ4CHFKQH5RFUGx6SS+xl2l6J92JrOadpB/VsM2193ARwpsc3/vR8N8WAioPRRzY9oSE3eSukm/JQEcDQCTtoMD4WYBCLFFcoMmEbv/2YEvVEL16L9VjkRoTbrxglJnZ93BUjEmAKO1Hw0IuTnOAG0ZfhvbMytXGkE03gKxDEQqMU5HwHMll6O/qvyuUh+5qvoZ3bMtJ4UT1gefVrFlSKHWsNixFiH0I9S97cMBis4Prabxru0rEfrpfbZhc4lkb0kad1mBPmGS3X8VhizVgW8NcXnXgzmJZG53VIyf2Vjvqr8V96VuY9n3oZAyfmbNDqx/6NshNaCcyH0pAHekQYlXQhClT36HINS3w4com
 C047fW4x
 7tZCiiTRjHSUBwe2vz07sjeJagMc8h4MYZpHxUYySDuyEjMylReu4TgWJIcFaG3jAphOBytIU5GKw48A0Hsj2O5voV9EjWBfqwef7uQMSat2HRuzxIpFtw6vNof/7dPRL/H2SagMKyJnHXHHwXBkRwX2HS25YBWbdIMW9VAmT8MVGK1A8crTvkgs1lW7TZ8lcKvU8TtLmlyjoKLEFfHPR3cfuHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page fault event reporting function can know if the access was for
writing or reading.  Add the information to the report.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 782af39ef0c0..e2fd17b83a92 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1732,6 +1732,7 @@ void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 		.size = 1,	/* todo: set appripriately */
 		.cpu = smp_processor_id(),
 		.tid = task_pid_vnr(current),
+		.is_write = vmf->flags & FAULT_FLAG_WRITE,
 	};
 
 	if (huge_pmd)
-- 
2.47.3

