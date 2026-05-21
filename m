Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F267BCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703256B009F; Wed, 20 May 2026 23:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6266B00A1; Wed, 20 May 2026 23:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA1B6B00A0; Wed, 20 May 2026 23:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 395A06B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 053681A0396
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:07 +0000 (UTC)
X-FDA: 84790058934.19.440F147
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8080F80008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGH9Qp1X;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOZYn/0HiUYme65VRURmz3VNOCuqOPU+0+8yZhbpho8=;
	b=0DY+7q1WL1z2zr9Mz70w+I+q9XwJGB9z2pOhI9Eh8SH+oPbUs/3Zs26nooA0zqdOcqi6Bo
	aRL0NJY6354hXhQU32Cfmp8HaUFdirhapa/wOJMfk5gYXyvyM9NvFsksCvEjl+VFhwirCh
	SOD74OLMpVMJf/N5lpxo7rggpFfvBRg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGH9Qp1X;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335645; a=rsa-sha256;
	cv=none;
	b=BG8ConlRrD8NoyAVc2suLc2pMKrZjJ0G5wUzj9hheTqYXnMS98xgIrq936Zm+7J2uVeRs4
	HGR4V048lyN7YowcCTu1rqGCzRLEWZp67hu7+RsgrO7nqACttdzLttViLvmQwEAvX6f/ak
	uv2HDorK8aLDIDgNn6pgjEcUsSdXdWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2723860098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC7E1F00A3F;
	Thu, 21 May 2026 03:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335644;
	bh=jOZYn/0HiUYme65VRURmz3VNOCuqOPU+0+8yZhbpho8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGH9Qp1XWEfEWjJYP2f9CMt2C3qFkQejYJvcjfvnC70ebGx2S1YF+u0Z12IQ4yYlH
	 yCMnQvcGbHktu/OZJXbUUw0BjDyMLZzrl0mWFEIxGlKC/6oVqWlg6Pyq3Sw037SPXj
	 31pxKocSJOk/36yWdtoHaY5joLIAm37ADnzu/yInGPvprG2tSN8OTXWjHw0Pu8+XRC
	 xhPlOO7ZFkp86enBttyIHBVBbfe70D74fThj0/cbF30Km93KlRiH00F2d6ceG4cg0U
	 Yle5EeyoaIUuYSc2kEvc4xYg2IFJceeHr6nae8YAENL6UZN1AJia4i7NGZgTsOviqB
	 d2Y1YB28vzxVg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 13/14] selftests/damon/sysfs.sh: test addr_unit file existence
Date: Wed, 20 May 2026 20:53:47 -0700
Message-ID: <20260521035349.87565-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8080F80008
X-Stat-Signature: ptgfbsf39cspnh15wgpmsmp69qc761qm
X-HE-Tag: 1779335645-582408
X-HE-Meta: U2FsdGVkX18/gh+9A+MJ1jSjn8C16qPH7xqNcBRZzrZ6S/zuispXZinunAogDIvPla1Jp5j7QO+BPZEhn6vkX1L7q/EAz5tQT5rmk2GD1nOfN9g+vSymcyiFA5Cl/NVEMUKjZlGPPXsT0HpJq4YQa2MwzoB34n00qE9cKLqp7EFFvLPF0++cjZHItL2ZMZxpaxfpcpsuIxN7h6ICm9xcEavU1h2kUKumMpI2N39eDykPe97xFwVc/ekDodUCBdn15uAm4f+nriQPwpa9TcnSI7D6jR0Fizt3RcB7srMpD9Y9L1ESSleddphUvBNzoPNpOn5pfoYhAuXKLtJfCCjt87me7XLJKZgeDkNfmupvV29yUAoJuKrr3tT/KjNY6HoISHFqV2jsWfB2aHIFd0HSciy/ESYIqoVEPbqR1v4JyrBNKCFMZfAKuMufbpAOUng6fnYsCdunZyISE57UEsgCDyFeNkKMYfJN0qS8ZIEbmA0OpRWiVQn+6fWMAV3uKBk8/dHW3gW/fB7RcUU1HZB01Uo687SAUBplBdBC6eZIIGeqXIc8mSXxjaSPBvM5Epwcb9Apv894IdDbbkbm9nZwjzpatprYhDL4Hv3KiUfRC/VBeLNuQYyN4JUjJdpKQL5H2G7jZXWlgNEV7Kc17Doi7lmFpM0PxL029sjvpZBJGZfoksphJrQwDhKKNkWylf1AHUnluuy0WgsYJxWL9vBXVzhchFyknlw0EzxjVYBC9a768YJeDMLbJ6nvN4gRnTA8t3thnsOQB+Vm2GlswOlRTjh7pqVgrhv6NQA5Fml2BS0Y1mYnRUcMvQBXPoqqXho5jqkIIo9NH4/BSFyecpBjo7qFHbUWsUDVJdGlUJT/CWSZzOc6rCwPW9nHavm5O4M9w2kfL9HPJaBpo/SfZOSYh718q+trya/K2fByYlrXEe2MK91kZ3OCdJ5Rs7uMQDnWXDcZCisvh77QUekToQQ
 1V3IZG+D
 X+FCUTFil027ddoLfdtJccBDGLTmfRRgeqZn5vzrnpu/hPLEyqsVBesjuuuhCC11/qn6LT6PubxXUv5ws+duPw7IlypzyR2aPqYY3y2dFvecdBNF/9koH7DZW9ngFuBkoaRXQc90U0w1MrKxaHZeB7Q9UNCC1gTq/Q2OE1av0N3n0k4fyU9HrbqlR16W5jT9iV5wwMc7Ny64XJQ8nU5rc9lDugJZfo3FLIKTBagbNFV1NQ69Bejlwj69/rA7jBP9ByqfOgrxaEO24y7xTmoch+fTHhD/b5Mg+BpliJrRAWKcT1W8TW7lTkkmWn97SjpAC7g70hHbFn5Ct9+SQI5VidRPU91LH/KFRwG9O
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

