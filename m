Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B75CA0EC6
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 10:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051658E001E; Mon, 18 Aug 2025 06:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0293E8E0007; Mon, 18 Aug 2025 06:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8508E001E; Mon, 18 Aug 2025 06:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D919A8E0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:41:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4199F139162
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:41:19 +0000 (UTC)
X-FDA: 83789536278.08.D480EAD
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E9EA100006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:41:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CtZPwud6;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755513677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEOAZHx/EHGfD/sfEV5SJgXP8RiWdRzDUoJ3dlTfHJY=;
	b=xXz0N01uD59sW7virGZ2T3JD4Dr8rUjMwZ0xu/clN1tuCnqEwN+lCUBfnpLIk9gBbMM6ZC
	iDQiVp+eEXak01ayKAZGJCtuBKKANe37QNHgnl5Cwr7o41hH5SIr55l72p6S2+H4wOxZw+
	Dpr/up4LUTo3GiiHHMZzbjyZGau8rEo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CtZPwud6;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755513677; a=rsa-sha256;
	cv=none;
	b=wgzDlypwNQFqcAV1NFfQYEt8dXyeR/GnIV8cUDyMd71jTM/qarEv08+VXxzmhMzbRKkNvB
	LarQntM/vdRRU2qrQw7hqNuaNEHytJDBUcNikf3hY9iITSKuaqcZxxESbjbUKlO4BBU6TH
	ncJZU5fH+hpkc7OLB3Nm9/cTTtLEgX8=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9dc5cd4cbso2725029f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755513676; x=1756118476; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BEOAZHx/EHGfD/sfEV5SJgXP8RiWdRzDUoJ3dlTfHJY=;
        b=CtZPwud6Udnc40Pbyk6CCNJIPsIRkZ9fEPVrQHPVvMLA+eHaB6S5EEYtU4SWs7zXxi
         a7pMJuqLG9bs65Bqz7jB4WxwX1ozsZSHlnXwcPdZUFGAAGv2kXqdEnB5hN7PuEgE0bRA
         d3Q9F8MxfKYihsFUaUbgcrPzZBl9S6b1AeQglyJ4lgXrJqpF+6fzJFHGbLGd0MKOrjFk
         zVZ+bbVo5q6oy+Blxb45RRcuqiOSow3Da1p0EnjFeyvlccUXgj1Icqm9hF5vTWJkkfqq
         SwUihInMYxEZweHLS05j4ZBubYnnbjdQgzzbaSEZbWodgXai5IlKxdPjO7EsL5u52uvE
         gG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755513676; x=1756118476;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BEOAZHx/EHGfD/sfEV5SJgXP8RiWdRzDUoJ3dlTfHJY=;
        b=sxPIPAyVRB85jWU2S37hOFnpBBLXUBd7ziczggV5DAjeCkThz+BWEddgErUbzRBFBJ
         I9xgalOp2ulVBwoEF4x94Kkq4s7sE6NPX1rA2Hi9g+1vJ0FRCx3Aum8onGbV5hdOZk5T
         W29FNDJS/NknV5JxIWrsj5/P+0ZQbnaBpMU0iGrPINzkcLmZsMMArZMcR3wbqIq+iAcT
         OqFhDyIfv8+FHHbWtA9nHoiKCob1vB5LH9lvXiuzrNitOBLOAZ0e63V36eDAfaxnfxEP
         5Cj6EiNj1pB/OUtX1yVNVNkZGT1/NcEXPtpShn9uxdQO5K63NJCwcrjUQxNEtLcPQQdV
         Iu8w==
X-Forwarded-Encrypted: i=1; AJvYcCWnKf5/NzDaqXjaaiiq2eQivS58pKf1xSDJFLb8+t/Bd/0GVniwSlnxRSRWdGKdXPRZoT0ibikUYw==@kvack.org
X-Gm-Message-State: AOJu0YyQ1TCcclsAYqBzv16Pnt8bcEEg3KW02cb72JtLcr4cQM58T8Wu
	JkoIfK4EaTK5tG6yOpGrqJ5B4o4MrOkJXVx9Zit+lE+fCzu9sgG21wB+
X-Gm-Gg: ASbGnctMcKzywnJJCCLt959RJ6C27swc6Zl+IKZspzhYWA3MuL3x4Vwe7so+woRqltd
	X/vmZsNG6FSdpE3KwIBL4iJa8tcZzxyXS5i1mjc9J455eR0pEhHLtxgvb79rQfNVG/jvg3MSug0
	iWi6QqBDbeLgv5wrHPkOYe+43bTPop5pDvtZtGIHKRF4a4XaOAH9XU0S6Q5LLK4asxjd1DE61BN
	sHbCYIw5uv2P1PT5rkKwtNQvEJJUVkTLQYp2c1GvQwoIMBEJRywtGOHjQvePojkPel7OQbP+NWG
	M1boYHVTvRubQnl+rlaImXKVKB2LIQ8SmQJ+4FVvYbsBHN7VblVUVjCbN/fY71TlvfkvZ6y/rB9
	+yu34Xgn2KzsOmcPmxnFWzJ09R40ZhPwQnagBNOhP8GInM34NHm/vOt4qfyNT5U2viGjGl2c=
X-Google-Smtp-Source: AGHT+IEA+CnzAZG5nqPWaucE17ppRYMiLY/83IrR6orHShs0Kok5GpAbtKiOzXR6WepIUKE8wXMAWw==
X-Received: by 2002:a05:6000:1a8d:b0:3b9:16fb:bfe2 with SMTP id ffacd0b85a97d-3bb66f10137mr7575027f8f.18.1755513675369;
        Mon, 18 Aug 2025 03:41:15 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::5:7223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64758d27sm12714320f8f.9.2025.08.18.03.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 03:41:14 -0700 (PDT)
Message-ID: <2d0ea708-ecba-4021-b6ca-e93f1413d60a@gmail.com>
Date: Mon, 18 Aug 2025 11:41:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
To: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250815135549.130506-7-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 61h48sketzxtduegt5yp4yxtqukp5jum
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E9EA100006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755513677-56566
X-HE-Meta: U2FsdGVkX19RwshhnqvmwcYP92oJlbf67vZE4rUEL8mZuuiVAJAqs8KGBbHDTRP/QzqS28VbcL2zMutmt2k+34yEeF1B7d2QGMoKaWT+s0tBWIWPYera96a2eOZueleGPH/sydnh5/Hmq8/5d+BCqe2aaoS4m0dxKPmxj7yEkQC/O+W0gYIp5v3VGe6nlnPiZBaHE6FFhtjzlD54+cSfAIeV28rkxytwwBo3FlIY7yAGXGaaKm1ilP7EqW+rWv0YKwpnLRWeHpCpCZsZFxA1oJe6spm2foR711zjVHsFImf5/5q1D/sNcRcFNtuwhGanELM0RKes6poXZGVkZY6SdkYNFTvKSKY74Um69bLpngOTtMO+BrjVmw0t1iL5e8RC9SOE2tVlV+1SmJTtTgZEcZFpoLtkb9otGnw4rRQ5O6Y2+5Eh/EwdOuMELQS55IrjSjv387sbH0eLpyVY8DtmLYkmpZ1knWV/04R08IZP4BOfsNqMmdZimvd8cfLK7g81lqaBmeJilooK9119m6oYWrPRGIah9E+GrLeLGGzHLqLBTWnYvA5zP0FLYXDZgcBBCQZdxwfed3JUZBNF1zTabT28h/ek7vkS9htqRZLRYi56xKOU1sdgUJkV3we7lRDB49CmU1PrPsW9voo4TSpmex4ZtXeAF59MKm1mC2OSQiZEpVOqLVAlqWuSlXlLEE1lS5EzgZc4XjOYwQBvt7t+QuAw0zJdwJotIUHKpy7yvSwm8soifWGQhISJ7KJDrjSn7Pjom/sFci1CWNBj05i8NMampCsrw6GS6yLwZenQ5Op4OHJMOm+/JENGBHk1u5gzyYwKTPabY/xYKiVUaIXCA3oWg/e02b2nzJHQuyx3j3g8qDeNSMZPc7feeHoIxq9ozXw3kA8t9nOHgEn3WDYyUwSs9YNTxeAumu3O2fr34diLe6WyLl4TJKugTfjPb9FmrOrCUId+hPkt9vrQV6d
 xKEUMcxs
 oCXIUmltzrRMUz7j3PxiemPYoCEPG6l/Kuw4nMq2CXKlSav5c3tcycp6NTTZk3Z6Yke/KtpwE3r4uWxl2uLFiq3lNMhDikyAHdGKa+3VNPEpl+biBnYIwFNS13hu5Sv3bltafSk2vBnMazR7oAMwKcWMxYW6Zcsxd70kOnc1C1rXeJ3vclQVQqTExdKTI+WxHTZ5zOFpBNp/w8JIsK/J1wFEKDJLAN2AtAXu8yYoMn5veqlMD9iE+L7n4zxOQtKrKgHuAWRxDRhO4XoDeJdPY8YuCf632H+xxKog4l5EgemXmGwm/A2PH1jYh+zfYM7uh8TkpnAprg5oR/zP5CdkYO9D1ji1VLJlphiOp9dSdKt3/yQ4mDhQLb3iW9wQGinkqQPoQXgrn/lmAqGr2GyKQlwIGh/c7cNYMOaRscpEE9K7IyaJVNYektT809LWl0kHGzWegUw1eiRN9SXJYj3UMsvcC52A3SXTfeyOsxaM04JAnvrfCR0UP6ixMXNtoHe05GWGxmlDStJNqaQNRYf7tfwFsojcSzxpSB1yT3CMlv5paf5WOWDjZCMxEtdbo1dAao2QlDKFnByZj2wiJmJVdbt8IKkrah9aQ5n2f9fc1+GaEzWWF5JLeTtpiOWGAULbw/xQw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/08/2025 14:54, Usama Arif wrote:
> The test will set the global system THP setting to never, madvise
> or always depending on the fixture variant and the 2M setting to
> inherit before it starts (and reset to original at teardown).
> The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
> be made to disable all THPs and skip if it fails.
> 
> This tests if the process can:
> - successfully get the policy to disable THPs completely.
> - never get a hugepage when the THPs are completely disabled
>   with the prctl, including with MADV_HUGE and MADV_COLLAPSE.
> - successfully reset the policy of the process.
> - after reset, only get hugepages with:
>   - MADV_COLLAPSE when policy is set to never.
>   - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>   - always when policy is set to "always".
> - never get a THP with MADV_NOHUGEPAGE.
> - repeat the above tests in a forked process to make sure
>   the policy is carried across forks.
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  tools/testing/selftests/mm/.gitignore         |   1 +
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../testing/selftests/mm/prctl_thp_disable.c  | 175 ++++++++++++++++++
>  tools/testing/selftests/mm/thp_settings.c     |   9 +-
>  tools/testing/selftests/mm/thp_settings.h     |   1 +
>  5 files changed, 186 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c
>

Andrew, could you please apply the below fixlet on top of this patch as suggested
by David in https://lore.kernel.org/all/a385e09f-f582-4ede-9e60-1d85cee02a3c@redhat.com/?

Thanks!

From db9306c06cbd6057c2a8839e5d4c1d2559b58b70 Mon Sep 17 00:00:00 2001
From: Usama Arif <usamaarif642@gmail.com>
Date: Mon, 18 Aug 2025 11:27:04 +0100
Subject: [PATCH 2/4] [fixlet] selftests: prctl: return after executing test in
 child process

The next step after executing the test is a wait, but there is nothing to wait
for in the child, so just return.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/prctl_thp_disable.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index e9e519c85224c..df3cce278e10a 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -161,8 +161,10 @@ TEST_F(prctl_thp_disable_completely, fork)
 	pid = fork();
 	ASSERT_GE(pid, 0);
 
-	if (!pid)
+	if (!pid) {
 		prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+		return;
+	}
 
 	wait(&ret);
 	if (WIFEXITED(ret))
-- 
2.47.3



