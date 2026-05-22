Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFA6CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753896B00B9; Fri, 22 May 2026 11:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C2C6B00BD; Fri, 22 May 2026 11:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5211B6B00BB; Fri, 22 May 2026 11:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 411C86B00BA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DFC431207F5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:41 +0000 (UTC)
X-FDA: 84795468282.23.F621DB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 42F1F1C0006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THj1T9o2;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOZYn/0HiUYme65VRURmz3VNOCuqOPU+0+8yZhbpho8=;
	b=rJeMvyMx+mMIjeACT4CCZzhPrXtKRQuQq71uYCYyXYpsxR0zmnYg64kxfkHwIY88s/jWvw
	9VDSGWkGJKImK5HCDb3pv9v4/1ph6Tm/RcN/5rRqtJY6poxC86wyL0FhKjEmo2rl/y36yA
	xXpdNtl5SPLc1ClExT87Qki2epuEv/Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THj1T9o2;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464440; a=rsa-sha256;
	cv=none;
	b=nDgVqyvHy/pN1g3AXjzWaUcEn+yS9dNlE969iZwmnr8jBOfK7l8788v7yexmzaCcP3ZekJ
	YsIc2V+52r1PV8ZRjYqZFiR0rPefpjESM0pP8zIMmXmCxKjGBlGJH+VfAg2sDeQWo2fEos
	xOs7mpGPy2BGGN9crDDoz2D/srIZ17M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7174A437C8;
	Fri, 22 May 2026 15:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AED1F00A3F;
	Fri, 22 May 2026 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464439;
	bh=jOZYn/0HiUYme65VRURmz3VNOCuqOPU+0+8yZhbpho8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THj1T9o2CnuL0MdHENnw+FQNkvI1dj8JDEI0VfoLZQLXUeRo9fxmsexSReBgbSrcK
	 DyfaivafSeIuI6rDpSC9hpkZcrYU26TMXreW5GsZuH6TejAXSxtesdqoEZqlVPcMZp
	 iEQ8YrTt1MA2wKQXSyfHnBOC/r3gtKL142Ueapg66R02Ump+wEvO2F1splBkLti0LS
	 9XRJ4G5lu0qRPbG0iP9zV+0CZrmwLAV2Yts/LQTE8GVDygna0mY4UGMUZDyUiTF39w
	 EP8oN3k+G95w9XCLRgHQSYaT/iBeLmF3FwFWrQzhAxN2dc7hR18IjnZxNYhqu4ZhpV
	 c7f+6MXb0tnPA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/14] selftests/damon/sysfs.sh: test addr_unit file existence
Date: Fri, 22 May 2026 08:40:24 -0700
Message-ID: <20260522154026.80546-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7561uiajwqqpjfmozi8pwhtdfmc5xahi
X-Rspamd-Queue-Id: 42F1F1C0006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779464440-409376
X-HE-Meta: U2FsdGVkX18/KcpBX3NxRr0SWIy+Vk2MHOx4n6LcUvay7IZw6/AsmUh+CQzMbqw+XPEwBOIxzzkjnzxINkvVRaKEPQ0qE1tlzXm/LQK6lhS0WnHDfaFMsZSSBjsANcaSMrof1Ny+C7vy3ACGFgkihV55skWEUn1lhdrru2Hd8QTOfdIkAo1iDuYvllv9e1vFUQYtxOE9kVswMbpEyvgJlgsE9Uwfgiv9o6LSATadfgtchbQ7mbi8VIzIRLKiCAQ4Ud5N4Wr/Se8s4IM0dqR8SyhYkRVwZHdM+Q01rh9dKjZmu8LC0kWcFre7ti4lBcfsuJwIvZXF2lKGS73vr2h7zTkujgA4qiqtiYGV+dDUlqTbZiUNTRor37Zf5h4Nchrfny6jlYyQqx7XtvmAx/6rgve8IwWtpyyT+vas+lj5bRzoDPV6YAN+GvNW2MMHUTq+mg7LtMfeaVhHVqRgIz8XXRGoRPC9CEcDIaH7I0+eQ7DyJ6jqD0IUEQTGYzcAk/Qn4daAnn+BaVslcRKf+0L94ZEOaN74RjuLmBwLVKGXyYoKX4kkIq//bTKOSIAp4tz099s2cEzU+etzn4Eg2FGmWB31Dq4PwUvhZ+GAxSGeriRCU84otYE6cxRkyonkfIhr7zuVBnru3HJH/ldwjQQP6kFPmXklRHqj8S6rWMJ7Yne0H6ILcNEOHzCRGiXm6dx7IrBV6eq2vWW7M4l6YJ8/fkdeBOF5quFtVu4AEjRfcG323liaFtgBzg0H8aq3rTsSFjvXMsUhAGh/LxbdwMi3ZiX42Xc86w2JBLfctnYTsA+rVs/9MLjSon/t43lHFBSCaees9LRCMhp4tyBHTjU++tZzPJb8NRsVo/rA3Xv7ukTKh2+io6JPgpDyrB+UHI9ld8qlO86bZnWmRtKHdmKS2aIB6mZiqDD97+2zbAfQMgEOeFpRPgVtUDfMuvvIAsGiXYGmUbLqJhayZOUePPO
 AqYK+F9F
 WfolMsXjzPYRfAaDroKs/M/Jna0mjHgN436uCG4Po9hw/zH+f6kuQJ5vCs/CdZ7Lfa8cbnJznEu7JHNQ0g+5DGCl+p5Q1yoKP3hWID4Xo+UJIZ6kRrobS69fWIeh5UifYXq4kqI+tn5f3tZ1X0XxNmyaDdziRy8P+BHjaa5IagecKsr/fdqBwmOAo3s5Eddlp+Z05sWBqidJJV4Uh8MSRh9W5wthveiXH2spJVLcJ5Xzy9IJ7HQx4WB+vfOLioVsvmf68swaxUkKnuEi82/WfkgqWxtPVSl3r+A5H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing the existence of addr_unit sysfs
file.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index b3418214ed358..92b44c86818af 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -365,6 +365,7 @@ test_context()
 	ensure_dir "$context_dir" "exist"
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
+	ensure_file "$context_dir/addr_unit" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
-- 
2.47.3

