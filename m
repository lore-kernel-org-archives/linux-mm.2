Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D012CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9987D900149; Thu, 14 Aug 2025 07:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9427D900023; Thu, 14 Aug 2025 07:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AFB900149; Thu, 14 Aug 2025 07:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7C1900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:40:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 228DA117BBE
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:40:06 +0000 (UTC)
X-FDA: 83775169212.26.92393B2
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 32E5C40015
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:40:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LIpjXngc;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UArTXp3Hq+mbNcbOcxemSDB3MaKfXzy1pobCYymFKQg=;
	b=NE1uwHtS125r4aGsW0nD/QQ2fpl9wrxzRf6uggw2a3houfAwQO/xU/ym9gupTbe9w/b9wh
	qL0fuCnC06+WMoZvLNf9QiTVm8pbIT7J/cdDazsJK4IyU5ZBFcVxoQVciZs5M08k2Wfdwr
	5hw0e3omIc6C3KkVY/+HyOTbGqaTUBk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LIpjXngc;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171604; a=rsa-sha256;
	cv=none;
	b=YwtQxeOS0WsNwD9bIXgILZsfudKaLs5p38vDHhE5cAdN1fMzMCqhikcSnnwiM9/PCb8CF9
	4c6A1TqynZ442Ydu+biz/TpvRZM5h/lrmGJ1rocG4E1mkncPsX57Za8ZEOG44hJHEEg/4o
	FjztAwP/MW8DUdexgh1gEuQ9Olh36dE=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b471738daabso647084a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171603; x=1755776403; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UArTXp3Hq+mbNcbOcxemSDB3MaKfXzy1pobCYymFKQg=;
        b=LIpjXngcnzor6VyNaMVYIeTTMiWEwJaQDtPda2UzCqTn8v+o6nXAajbAQg6hVz+cGZ
         iYigOegQVdFdkJ7nOzuzYhmU8MxpYU8JKSiHa5OW/VQ/lUM1DSocpPZvMyxAoLB+ijtJ
         BGCoD0BReTVu5H8vlcF8UTCTsvCSV2PLikTQJgLeZP0IrODYEHlM6YoIbx4wIG3Yyr3W
         XmekCEUo7pfzCOtq4wyvEHNjpyOqCrVlpXHWUi10kt+c3Ca1knTTJUoaJe2wbBj5WxvR
         kn5yNPfPEcJT30IZSogPta5DA5AycHSKzfcNZqqYwU9CMr28daA1FyS0nJAxVxqBWsZP
         FpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171603; x=1755776403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UArTXp3Hq+mbNcbOcxemSDB3MaKfXzy1pobCYymFKQg=;
        b=jQLoDdsfZJ8x9C3jbT0onJIKX1rlE3SESFy3LMCHbPsuvZT+wBj9ISt4pHe1+zpeoc
         NuPbiCYK7z9xqlW4LhH4K3HSCcDe/Ow39MunvkzM4OLb2LtChgxdoSTcKQ+tGZ+LQsca
         xJWZCsuKGl4eQyuQ6Jl8Y7wzRdSBvB6EqeiySToCDAVDSUiDQHVURmU3RSb66ExQUWNU
         zUiUOSkiYnikX/0+Hqc2FTrv0y+rs9LMgU96SaZWsikAQjSIBFQSAyfEbPCKqpZfrEcS
         WSCgzEHinnw2d2dJMPH/bxgIRjC9CZm0ScRii6qqFSxbI/ZsqRm5Obj6ww4biClotvnp
         UUCA==
X-Gm-Message-State: AOJu0Yz2Kw80x+1DZ0khei0xIpncmUXmBKAvl27P+1ZpnSI6fNDUcAtY
	OJcRTuq84u9HzFjY0mcMO+4BNWPQ6fCAz3IeQOezqbqDTNUsCneWzFHX
X-Gm-Gg: ASbGncs2G3F21kDMKhLDLnY0syyv7WWTjY6OtFwwsAP+mrLRdL08VGWXvCB0a4BhGfR
	qOYszCJaFWA48R1+eG2/TzRLDvv0XqK2itr6yQM1fGeuIB+Te1RH5kU9U49PVXNRvAeV/9p5SvQ
	SU/tq94lhQiyBsR5guh3bJlIPeX3yHDwfk/FwblldouHz1nDssYr64Dzc0cEIJoXUWXD2DVXEPF
	Z9Xp2+EV9G7Glcn84ekolH4oIArYSRS/yrtyjWygi0SOJBfFwMz+dbIRC0Bl20AQeFIJLl6OmhY
	+872AX2ak7vQ+D14UHhXGh2ObWXuYsZ8zll9t/xGclk1OHv4BhKhidqK/DpEXHrFIsdEHRjbFkn
	W98nJXPsbLlilw+5jg9JXhF9cpOo=
X-Google-Smtp-Source: AGHT+IGwUAfXN4KQiQgbnxyLq1NQf2dT/Iah65zRG8p7QtWnmVS6K3f/iWmzK8+w4TcvIKMHoj2lZQ==
X-Received: by 2002:a17:903:2947:b0:240:3bb7:fdc3 with SMTP id d9443c01a7336-244586c46damr28681005ad.28.1755171603003;
        Thu, 14 Aug 2025 04:40:03 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:40:02 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 7/7] selftests: mm: support wp mTHP collapse testing
Date: Thu, 14 Aug 2025 19:38:13 +0800
Message-ID: <20250814113813.4533-8-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814113813.4533-1-vernon2gm@gmail.com>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32E5C40015
X-Rspam-User: 
X-Stat-Signature: omxt5pk7n1d87dwhsab8haaee1iyrdet
X-Rspamd-Server: rspam09
X-HE-Tag: 1755171603-24392
X-HE-Meta: U2FsdGVkX19nbX9TbWhEhr5NzfgodFW8rYMSC5tSL69zbxmXFXMzeIDI0XZDd4A/ca4VVl460F1uUd41n/wMgnMnH9JzDzH2TtMoZVI37tqnnu4jhPUqjKoY15YKWZKhaO5HFBiMP5NL47ZrXu4YCmaOP1tOzDzJFz5/K7VS8vPtbWG3e9i5BABAt4h0EImzoLGDPh4XZIKYAtwkSSrVEW3ygCVEpcjP28gMCGR1nNTYKLXxt/V8MAC1Zql/Tw+kIQkdS8Ms5O0tlcIqXLnu9pHaGvTLuM03W8YJNcdwAusweXd2+e+F6TgsAIrwYgrs0pIjqWk86aP57MyJWurNmBfnyOGgM5UkEeVmSFeVyCyxhNrDjCP01h3m6uLlTMY+KCLcG6oNJ6yvLToCfpwz72JxigD3BZxawckVJGpUXWpTvCntDfydJbn/eVmeU+85nENc2q1HZoUWLTLhEjx2kkM7xrbXT74FnIJe9a+VgciYddiOIsZ+d2efHoNEFhTKs8IeTfN0Qt9oJofNrba6R17gA4wQpIs7UJ2VGkPbbtn5fNLnItIkU6mywHjmmu0VluLzhHAIiEvw0kzS7H21RaqIOYIaQB0YRbKR9koF8GROq5Dbe5EHhzaMb2IHvDnJrPuwdnlJPSfTxoneU4ZT2ib/cJe0o17QjPSsyI02DGwXwoajVAk1IempWuuhfmRwZk06G+67jcjtqNYPR+YligyU0adB/NKyuRAPAI2yI0cXZX0uUPXhBnYTjH7NavuhXOKx50tZdw8O8soDSe5JKQVHI2nQKDz+k4kaCd/q6RV3DknoXDewwnrqtVst3Bx4crPHhK0ULQX2D+NreyV9PUWXUBD+CFprg8rW38+7IdCNH2JIl7kKqAtlWaC1MbJ8EhrsvIBm0pm/ygEUFZvWXHcuBckibePHhWaywb8O8xSM3ObDvdj8SZfRl4WwGJlMX5uoTWEsfI91nizdBiD
 uGZsj1k5
 cJUxcRY5kcdOd3YWJI4h3dEkqjDogL0xsIu8LOTZ9jOOsZLl33EsUu02cHj3INF5WEprMZ1o//wss6yaywNvav2ryCGiQrIqmhBBB7GSgmRcrrUmDMi58b/KdNolMfx8aZso+uqpAxY8CtjKZZHVL0VgKqTtoPtLzqKA3i6vDSfvqAV1d2uLt6MJW8IzbnhyA/1y2TG/f1+ZnkQ15CYoC7AnEfM/RONJayhebl3x9yqj0LvrA///3kk8CSpKq4Qyvzgjb3oTtWa/kIgq/Wvo+WnSgdKMlJ99d1qDgsusaW/YyYdsxpn1+Je2ja7q7n4o0kfgoiTagR9VuU+attx54sV6S87msMpNyjMUSnJBYoCcBdQpQog4/W8fINQ67ZeYD6OOsdxsNnbqdmW5XlkG41BkHtNkCmtxjwWVvXfz/5+M7rf95ASkMx+4rEAKMnvn0bWs1HUdp+9EiYvJhLGE9Dyvxsx4CQpzaSHJCHxUfkrPyiviRykmVhCfkQ+K3YrcNFPoV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add wp mTHP collpase testing. Similar to the anonymous page, users can
use the '-s' parameter to specify the wp mTHP size for testing.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 8a4d34cce36b..143c4ad9f6a1 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -981,6 +981,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
 {
 	int max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared");
+	int fault_nr_pages = is_anon(ops) ? 1 << anon_order : 1;
 	int wstatus;
 	void *p;
 
@@ -997,8 +998,8 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 			fail("Fail");
 
 		printf("Trigger CoW on page %d of %d...",
-				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
-		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
+				hpage_pmd_nr - max_ptes_shared - fault_nr_pages, hpage_pmd_nr);
+		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - fault_nr_pages) * page_size);
 		if (ops->check_huge(p, 0))
 			success("OK");
 		else
-- 
2.50.1


