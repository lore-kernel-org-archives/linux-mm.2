Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E65DC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A736B0096; Fri,  4 Sep 2026 11:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B836B0098; Fri,  4 Sep 2026 11:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233786B0099; Fri,  4 Sep 2026 11:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 014016B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:41:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 864A1C0119
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:41:25 +0000 (UTC)
X-FDA: 85176494130.28.C15C46C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id D92F34000A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:41:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bfUp/KRQ";
	spf=pass (imf04.hostedemail.com: domain of paul.dolan.dev@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=paul.dolan.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788536483;
	b=wGjjD1nq7ChKCYOBYmm68h1//CY4mZKpxllEUaK0rGDCuLpzqXXLgzYBAomMP5Oa48y/vb
	tzBnX9XWUbcVHNYYTHqEJXsDFhCgebRQ8662LqX2118dZUX8rg/8lz/etaolIEvC1V2ZCn
	/OV4AUvvBkjDjonQYZ69SrmC/fpYqwc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bfUp/KRQ";
	spf=pass (imf04.hostedemail.com: domain of paul.dolan.dev@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=paul.dolan.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788536483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BjL2pXlHfuAQFc/3GOIX7IQe1y00mLqM+xdgaQa2Gmw=;
	b=4t0QXdu/f1airF7k3EGJDvvUjQRxd/BErgqGiP856BLzCMIVPMVdKwwpjEmwXt1lo4Ru/n
	sW/p0juVXwB0kVsMQE8wjtHm/twbxNY4Es2mUT05WiGDS5na8BDx5MleyWUIzqkUwj/qfy
	LJkg9BK5mxZqNSAFq7uSfGQyCHgSvfw=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso9699845e9.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788536482; x=1789141282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BjL2pXlHfuAQFc/3GOIX7IQe1y00mLqM+xdgaQa2Gmw=;
        b=bfUp/KRQK8ZdbcSOuttpqPfUluVVeZcAXtRTUNEgOHSzNkgClQVgJQmHHToLQ0ck37
         Hy6WZf4bFdNy2fZhkMSbkpMPtYO78j2pdOKlXoPtMoo7Ave3ffDEma4DoOoDF2veqyrK
         RPDBrZ09TngIDUCmjGT8H/YcRhcJGRGU+4vKzBNOV3peZX3LX6GiztjETWYJe6DHWEpu
         iy73rYzYh5oCz1fPkTvH3bUzyl8qcpeofM5Nvmx8uxHJ4pQ1wbETKCtVZQ0P5uh2DIF3
         PWi4sAnPP/BtE+dIGE5dP4QGacvjpL8J4NaIVb53sxVrZWKA9CegigGeJHjxircQ7GX4
         opog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788536482; x=1789141282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BjL2pXlHfuAQFc/3GOIX7IQe1y00mLqM+xdgaQa2Gmw=;
        b=CzSjPVNUvlMlAHwzR+0QyzlsqFZUv/tH7Y3lf21kbaJ5O5dI52PCYKxCSfIFIo+L94
         gbt78s6R2XhJ0x9TrRP/Z5aTiIhwFLRoD68Cq+y8Tx5I8gdDqfi84srkPix9W8d3ZHEV
         3JvqwlqpjrEyNW0IpIOnDDG2kpg+/5vPMBWxxb4wToUfkXPN6ICT1Uh/KwfGHqTPPjBr
         xlB3ezt5f/Vd3PSds5fCoAplsL8z/x0dvcsZloWa3IBmStlpBWsDIQAL5KTpBFC/SYRY
         b9gEt2nv0STKVUqLkn9W8zfyTf6JYq2BHQIFiJR6MuyzaWoIUKbo8/MH7Ybok9o1e+yw
         2EtA==
X-Gm-Message-State: AFuF++mH2kMc8z11t2Kl72gcCZnY8VLaMS91JKs/DsLTJAKjuNZeNImH
	/+n0XKDqls239li9K4Jdq5FjsdIqOnbxbdd/tSDUpHHAe5zyTcxpsSA/
X-Gm-Gg: AYBFou1cpsJKGFL7Gz+E/rQPkA+fLso61lNyTNcAHoGAKW0XGiNE4TObyuWc26abvRO
	JL7bbUK1pn25yRLzsyc2rzD45/OhIqmjXR5pvE2zcTbAYeO4ELR78fc2T0HcnmlTRoyirID1IRN
	Jf02h7i/Y3xO/EEIjai7nCQyam3Sf9MRa6XX7ab24NGPW3eHEq0BvHABgdXo1EOsPQNzVDqGHUm
	0UKrN1ulg/y5/NFdpLG2LXAMVVp9saV3+ytjvodp5Wfzth64x6zdOCvH3ggroYbxFjvqFbUVq31
	EClcytrkh5stpCeeQ7V/IfmrFRRmMZCZXPkRa4u39UAbMqr8rNFpT2uVaQZYy9WRAfDaYP9Ip0Q
	MK20Nhe4q4Epih7tvqcSUHWJ1I2sUG+f7I0B4YPF+zC6W+pt2fLUpr3Z2sUcgx5j4Z8yjcCqwTa
	mkf3ePbtKq1wfX6pGFskk/5p3SG1VMbWvN91xCEC+Hr5NWScdYldjxpNf7WWQlj9uYL/FNxw==
X-Received: by 2002:a05:600c:3495:b0:49c:dadb:18a7 with SMTP id 5b1f17b1804b1-49cf8244260mr66326485e9.10.1788536482119;
        Fri, 04 Sep 2026 08:41:22 -0700 (PDT)
Received: from fedora ([109.77.55.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d00031c95sm5959525e9.11.2026.09.04.08.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 08:41:21 -0700 (PDT)
From: Paul Dolan <paul.dolan.dev@gmail.com>
To: Kees Cook <kees@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/exec: reject zero as power-of-two alignment
Date: Fri,  4 Sep 2026 16:40:57 +0100
Message-ID: <20260904154057.160753-1-paul.dolan.dev@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D92F34000A
X-Stat-Signature: r46dz7qh4fy5w8pcjz793unignzszkj7
X-Rspam-User: 
X-HE-Tag: 1788536483-795632
X-HE-Meta: U2FsdGVkX1/lhgtl0JI7NIUwBWeqzohq774fSbR8NjZ4zJzxu2r0yJfs8VAfj/nAuPlzcOVou5tn7WCLsxfaofa0sQtWi0mK9h1ht/y7QdZnFU8aRkyB1Iz0Wd6mcvwHKIJPa/j6CiYrpvqovIjjudLYxGZg62jO0B/FfaE7xOHv+Lxvu0Bmn4dUCXDxQI5Do7GX8lh301S9W6gVX9MErK9Nhro2PBlMyU3YLGamhvloovENAK9QUO9BGS0vCgzZGdI2VEoIpFh7d+Qq2iByhEhZPG+7yCXMjrf28UpPVf7yyqDnSjl5oh1om8laRuH11n3LLRo+F+kzjLEVKxTu+qcHFVP9up++IdvWMs3LolqBJMREDYx6OvkLQSa2Q0tkdvOoA6FCtuyohyIiyPEnYd6I5kmmdc0YHVxu09f2mimfJNSSub8OizRxql52vt0yI80v29GbWegG3j+wjAUBb8v1JvfqH1S+KOB10qxx7w91g7tl4MNt8ZqTnkUvMM3lby/mPx7gJnGNuWyF2dfdt8aWOqUGSB8vsRxKFBzPlSN2ezk/Sc8JKunT2p4+ZfImNzCz8CzRkg0MQY/y6uRwSbdZTbrG3toHuDUJGwt4Ndih3BD1SGTZGnAui3F8PWXxrKoFosSZdOvVZhzPLwW7nrLdRxqEnnP0vSRBXg2cQ/X24BmeCFwJ7V6FPFRK0PePMwvNnjJiWfiRv5qzIaT76AYFzXTTq3A6QX9Q27FDeB6xrxShtBo90LAxMlVLpdRFi72Z26W9uoSpRO4w9VukLqXZwtlkf24F0d+2GuAzWBDwN7lPLtJ9nZd0L5NiYjewyak5bUWymeaGr+uVJIZKDm1Rye9MwDTEYjTQpeTndadDwZJlS+Bdkz1/2gMb8ASrmUAREEAtkDSV5b3ecuSYQtKExLXZbyvtytQXhO4V5paDirSmbHb5Mmbqw9QjkfiixalpOWRuYJ/zq8dbdIR
 NFgudkG5
 X7PgHH8EnODPN0weTsWhRYBUBkszB5rDyVbzdlTYL2wVG13zaAk2r358QN5NnOTIn+ODl1lJP32t8Qe1j7o2jhcqTw4BZ2NNVR++vzK/criAeVmUiOdWZ/wm3YLwIq661AY74c8C5p5AlNXOR7DbsDzZZpUAAHDnS05UHxE4tV6ZwUlbfdg9FJE1NScQ/6wiWWBzrjb+4s5wNU8G4xUhcm5LQKxHb6ifHDzXU9pq4fykIZDrK9lSRZddjTRPyir66QyeFMj8cxqeBrrfgcvbpuqt6ZZGNmsFhECSkOnklWurvFHK1Fa1ODvXkvVULo1f4pDzyyoIe13h5ZtSCBTGVEU4yv4RLOKEyeWpSQBSwF5fd3R7oyKHghOoGy8OEBi4ekXCMl/vZdySXA1llGMNBeKMjIpidMR9GE8cN9tJaYn0lttm29a7ZRwPM/0Wdp9ggpTfA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The load_address test reports whether an alignment was found separately
from whether that alignment is a power of two. However, the usual
x & (x - 1) check also evaluates to zero when x is zero, causing a
missing alignment to be reported as a power of two.

Require the alignment to be non-zero when reporting the power-of-two
result.

Fixes: b57a2907c9d9 ("selftests/exec: Build both static and non-static load_address tests")
Signed-off-by: Paul Dolan <paul.dolan.dev@gmail.com>
---
 tools/testing/selftests/exec/load_address.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/exec/load_address.c b/tools/testing/selftests/exec/load_address.c
index 55fd3732f029..e279d85e8f19 100644
--- a/tools/testing/selftests/exec/load_address.c
+++ b/tools/testing/selftests/exec/load_address.c
@@ -92,9 +92,10 @@ int main(int argc, char **argv)
 
 	/* Is the alignment sane? */
 	pow2 = extracted.alignment & (extracted.alignment - 1);
-	ksft_test_result(pow2 == 0,
-			 "Alignment is%s a power of 2: %#llx\n",
-			 pow2 == 0 ? "" : " NOT", extracted.alignment);
+	ksft_test_result(extracted.alignment != 0 && pow2 == 0,
+		"Alignment is%s a power of 2: %#llx\n",
+		extracted.alignment != 0 && pow2 == 0 ? "" : " NOT",
+		extracted.alignment);
 
 	/* Is the load address aligned? */
 	misalign = extracted.load_address & (extracted.alignment - 1);
-- 
2.55.0


