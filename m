Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00730CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 05:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCF68E0003; Thu, 16 Oct 2025 01:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594C68E0002; Thu, 16 Oct 2025 01:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D13C8E0003; Thu, 16 Oct 2025 01:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38ED38E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:49:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C34F2B6DCA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:49:38 +0000 (UTC)
X-FDA: 84002900436.12.35637B8
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E7B61C0007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:49:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8SavXB8;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760593777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EFi/2T+JfX3yrnVTv+ZbY4H4bdONoS55M7+1hOejhnA=;
	b=Oi+QlexNqbNGpfmOsl/UqzFTbtfZIITl8xQut95rhjFNHAI1ygCzezuqe12Yro/CxSC3xG
	4KJpEafcEotcu8sJw/5C0R4WDFBd0TgFaS11eEITT0fC5bcyDMmP8PFQGQM4nU8+qZEMEn
	kGhupLqQmG8ywD7KsnrQT7AEEF1XPV8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8SavXB8;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760593777; a=rsa-sha256;
	cv=none;
	b=B06kfzBvBNwZ+SJq38IkFeiSo99w5w0jWY6wxPpfMn1HiZH1V2CH3UKONsRNEiQw/Acme1
	lcvdZZpzVE8SO5CNpP+5qDw45sGYUDn80z6JWeU9EfiTK2ZbWapWbX7pXOgtEailb5WbRa
	ZxtAGuEjrK0OaZ8IOzn+TogmyTi1NjE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760593774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EFi/2T+JfX3yrnVTv+ZbY4H4bdONoS55M7+1hOejhnA=;
	b=F8SavXB8nlOB2ONHaUbOYK3T3TF0cql2RjsVnXIRw44j0XDXkxtkV1gbyE3R1E3PxK2U7I
	0XWV/LSCy3sl3yl+YNGMbRFkfyqhzl6qkO9wgvWPyIGDi16IUcaSR21zuqD83N/IjDn031
	ed2sPRArgdY/G0EnKe7R135bMGaGNgs=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/mm/page_owner_sort: add help option support
Date: Thu, 16 Oct 2025 13:49:25 +0800
Message-ID: <20251016054927.138510-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 54ep8pqrhhij1ksqj7te3ze53uhcxqn1
X-Rspamd-Queue-Id: 0E7B61C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760593776-867476
X-HE-Meta: U2FsdGVkX1/MhLF6cBpMzDYii0xGhIjLOtyvvz9A8JwJt1OjGVHOdT5Le5LZ/LHpDsu2D3AZsjGtPZ1WKvde6QYKHBgL6vv7LBrGZMWVSfYU2NzfHCgbuDfXhNMjoTHDAqiLT02htAciwS8g3/LLCE7U5g0gXtK94CM9uahIXz7bPvY+TywNYGaiQ+W9KeZvYTXt/+O9+bdDQcc7WQPi/YCFZNIkffPzifbYpjtZYlnEyCu5a3VlBLzUtUKnAaWQ2780pBOEsHDvTJ5dV1Sn5LyzqzLZCCslIjCFd0g7iIfd4xGdyEMoMWpYNDToZMqfuxOB0qn4wKzApWjDzHYxpTP0xUPEKE2Nllb/ivcMtRFl3n7HDzmrnQur1biOr5Gs6OnyZ4YWlnOwt1BXA34M1iP1chWoc7ZDGTQEmYqS1xrNurCHBLwFA3qmAS93+CaxbUgij8m7P9+Cz6Bzk2i37Rx42dt2jn/fCXZaI5B1n68uIqF4VxCcKcmzaVC1meRoejVievgpvH24sKN3bdg5usUucj0nqhuyGhYf7SGAM8WGxSYhYiih136y6cbSOKDx57rkQ9HLijJem44ED6vM4a/3H58rzNf4QDMSjBVK/L0kDEqTueGFAcJz4QrEXuefO3dUoz9Ikhfe4GxGU+qaLEz2t94wcm3C2v0lUTEST4DpXBMrbWz900h9kkpsvjJg2QCA0n0/trPxUatLA2lhox8AG0XfxwVVMeSPJ2RAjAq45Tr6942KAPBkGStW/iZ2bGPc6WmC+IzqHkcAW/r+AHVIHTqD0FB2weW+WSHrLnpf2EjxF8s+ZxEnAalqC+WdaNhBN9NEVCTLzTxLeBrCwJQc0jwryX2fp51mWeOG1JI0In+oVIl6zYLhO2aVcIIro5T/EwkoeKKMJVbVV1T2h3eBlLFHjxZl6osT3aGWwfW2Mzq/3yDfrfaQqUv5WM5lOHT/j8F30oZlvqrt5UT
 G27jP8OV
 JsorG8j+atzYZWbARcPakqZlz2zukLLvC3i4b6lkToNegSrCfSPPIg6T66Owaa2ShiCPxWNNwa+YGTkvhVwJ0m9HkT7dQN0ZN7SLgmmYL4j+RJMh0OGD3bl+1a7YvoijzqpNkMd3xCDs0H34X/USkjPutiVy18czhNzkvO4Do8D7yDMB18f7KG+qU0kSTnlzW+WMQqJBTJC/TFQJca3h+2/Bq6wLpdB6GZOVuBMay10pybGTwFj+YsSvC+77HfuMmeBGJk1Ij+BN2kKLl9LVkIxu+CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Add -h/--help option to display usage information and improve code style.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page_owner_sort.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 880e36df0c11..202eafed66a9 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -669,14 +669,15 @@ int main(int argc, char **argv)
 		{ "pid", required_argument, NULL, 1 },
 		{ "tgid", required_argument, NULL, 2 },
 		{ "name", required_argument, NULL, 3 },
-		{ "cull",  required_argument, NULL, 4 },
-		{ "sort",  required_argument, NULL, 5 },
+		{ "cull", required_argument, NULL, 4 },
+		{ "sort", required_argument, NULL, 5 },
+		{ "help", no_argument, NULL, 'h' },
 		{ 0, 0, 0, 0},
 	};
 
 	compare_flag = COMP_NO_FLAG;
 
-	while ((opt = getopt_long(argc, argv, "admnpstP", longopts, NULL)) != -1)
+	while ((opt = getopt_long(argc, argv, "admnpstPh", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
 			compare_flag |= COMP_ALLOC;
@@ -702,6 +703,9 @@ int main(int argc, char **argv)
 		case 'n':
 			compare_flag |= COMP_COMM;
 			break;
+		case 'h':
+			usage();
+			exit(0);
 		case 1:
 			filter = filter | FILTER_PID;
 			fc.pids = parse_nums_list(optarg, &fc.pids_size);
-- 
2.43.0


