Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0D0CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487668E0090; Fri, 22 Aug 2025 05:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4268E008C; Fri, 22 Aug 2025 05:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2808E0090; Fri, 22 Aug 2025 05:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 013FF8E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7A1BBAEED
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:18 +0000 (UTC)
X-FDA: 83803917876.11.9001D92
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8FF831C0008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TY81k4+BFDMfM8GxTXqQlFduDFRtBwJflYDAIcGUlT4=;
	b=3AxX+M7WOV2ISuIbM9vUObVvoZ6pOr2O6du+Jxi3KNNcqTMvLhaic34L65Ficp8G1xkYaK
	lfZ09+UZ8SveoTJEjyBwrnkAn+a8D5LDjY8UYZhSzOCAZ9S1rxGdZCKB7dcJEHq1FT2WUW
	2LgBl1mqE3Owdj10Ws/Z/VlhEbipm6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856097; a=rsa-sha256;
	cv=none;
	b=C8d7ExXEMJDVmXNZGbMOAwkxsEPJfUA75PWdPz3Sgh4MLTpsoNwk5LIY2K+KtbK5PA3KWX
	eEMsEFV/aQ8br71RrqplCrgJzB7jc0b/8YNzcYhvZoS1pzoZdoRjDZZKLQl61fWvvby9dK
	76zSreeWgJtN7zGjKKg6TWqatI0wEAQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7b006GKqz24hrS;
	Fri, 22 Aug 2025 17:45:20 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 16E80140109;
	Fri, 22 Aug 2025 17:48:12 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:11 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 10/11] Docs/ABI/damon: document addr_unit file
Date: Fri, 22 Aug 2025 17:34:18 +0800
Message-ID: <20250822093420.2103803-11-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8FF831C0008
X-Stat-Signature: j8f676b8qb8u45omc3j6ebnytq779rfu
X-Rspam-User: 
X-HE-Tag: 1755856096-949154
X-HE-Meta: U2FsdGVkX19/2wvPJzRShJ34XSKwFyhejovUoPBne7Gb1GXNn5ED8RivcCMs/f66MqkSH+QUjt0hZThz9G/YNgLeLKDeau35YCAmFERWJwoC3uprboZBf9RPT8oP/Lie8PlqCcu/neI5RX+xKQxWhKSfCc3Y3hKf790rjaxsGy3cw3j6JyX8/ODgNHNSPdTqsAutuYIIa6S90nnT0viqYkJPATULtTNUbcWjleYAAlOdWr9OYT2qKAkUGnnqXfRsRRqtQmf7JCUV8zaRu5n+PF7//JKJlTEBAgqblcsLZJ/lroaucLWDK5Imnjx8HbAcNQKVok6FIPJv7ihP2mw5ZLFVIITIS7tFg0BFm3/1U7F5uxqnV5iZHseWGuO19ejPZDIAD/3TK74Zn7ze2aMXZzjnwlWbwQ1m654scV240AgPqplLUhPDHHvFZgkGuRNMXU8JvWB6DEW7h0H2rm4pMkojF3uc3uaU2iit8ELUSVVgUUN7giD5Ln7lHVxOEp1C2L/Ul0rvjVzri9WQB2f8/3MWmFNqGNJw/lBGruXitl/prXxNCXL+e8YE6JSvoiLWUiPgFmzvPPvxeG1on9ey52OTj/JRbA+MEgkk4iTll5n9gJGpVhvoahePQwEjnojWwyhkytO2H8BTiQPLYDrehWZzzvVCrG9cJChbRI5TS2XGCechbx6AkuRAXpfBNzTwOuRPp8e+4snaxoYORSPg81OkvkCE9sKJxT3zo/KNB8jZAzCS4d+Jqtz4N+iWa6O+4qGZkm1eBoRM3+C4lvtPiS/yu3nMnDdsOO0pLg1Flm5kgDHrGvPYDPyIMrtz8Aalfb0wvblVvQ1NvBDmmlVgA7gbgHoT8/ZAgGG3wqIeKeW8HuwJAjp4IE34egZNBqSxNE2SBku5thKZeIi7i6HmOPWitFVlB3zYfqfikNJdlB+Is2COOywX+jhyKNfucNJvNXyZOiNngRgb8D/ExEl
 wg/CN4+W
 I9r4XCWzb0L2YZka0340Bzgmfqiq5shJQIxWQnszXMeg1L33/JBbAsLY7vfBluAaRMbXFMi77MfAG5u9dQQ+UfU5IzzXkqt9KrmM+r45lPSHJ1JwfNzmeYshHrTnnrZXktaiqHsFh2tVjmYQ/5dcy0BkeQu2StQktvxN/iu1s6uee7voZ84X3MMG4OgI4k1XUlvA6cFOBvjBOopOI0inB4BQo4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Document addr_unit DAMON sysfs file on DAMON ABI document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 6791d879759e..b6b71db36ca7 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -77,6 +77,13 @@ Description:	Writing a keyword for a monitoring operations set ('vaddr' for
 		Note that only the operations sets that listed in
 		'avail_operations' file are valid inputs.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
+Date:		Aug 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing an integer to this file sets the 'address unit'
+		parameter of the given operations set of the context.  Reading
+		the file returns the last-written 'address unit' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.43.0


