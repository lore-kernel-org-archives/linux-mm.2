Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B457CF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C7B6B00B5; Wed, 19 Nov 2025 10:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C9A6B00B6; Wed, 19 Nov 2025 10:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BAC6B00BA; Wed, 19 Nov 2025 10:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D34C6B00B5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A20213B2D0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:34 +0000 (UTC)
X-FDA: 84127781388.17.5096DE9
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C62620008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IJurSALA;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93DS/ScHi6FgD35ajGLpv/dHTyNaaklJOjylE6wX7jU=;
	b=PfjOhqHiefntx3coAvHLi0wWNdtOrZyNJYaXsZfDTz75WWtBGuLRLgfRvV9LFxIPV13R/f
	UIZK0QvRRA+lP6E48Mt80D4y86sb3BCjP4GAaH98dxtXCF73riHrMdNeaO/NwS+BghcMWe
	5nxp1aeXvmgQlaBGUHJSf3SQkkhQAnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567132; a=rsa-sha256;
	cv=none;
	b=yG1sQkZC04AUeASkhyey+5A3xypAJTl0Vp35EgzE7egTcbJsFHBRaHhxGSpww59jxzUQrX
	+x8T6CyyNTQBx99rOVYwqMPJtb3PmYJneYL/o3j66OegcATc1iTCSbyYkqRCFsrWPBQCZL
	ou7tWzxkOdOG/h0kdohQ5zWtB+TMRsQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IJurSALA;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so50064935e9.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567131; x=1764171931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93DS/ScHi6FgD35ajGLpv/dHTyNaaklJOjylE6wX7jU=;
        b=IJurSALAulmxun07lBLwObgvZwmRvS0HsgOHfZ9J50ZlFq0HyBQBpiSdNRHiHzvXw+
         6Srz6M74IKpIrWOfgy4mhn4crUPJiBfoRJRTi7BkcfK2q/+MK4cS8nBdSzxZ+ZriNQFf
         IY4zLoYnjv6ZGnn4v6DfYMPuEaCQZUWp+FHZm4V8RKsIHyuwNJojI72xS4GiAF+cWKNf
         QCNDugfNARSmgx5b0aoZHCGDvtwbcFvQCY1MwwnZpUxOkLAswSR2n/LM4wS8c85iAxBM
         yL8LxlNRVSF+AdznV6FFtU2IDInrHwVqZxxe87lQNriVv8UYasGGc173o1nZGdATgw4s
         91SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567131; x=1764171931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=93DS/ScHi6FgD35ajGLpv/dHTyNaaklJOjylE6wX7jU=;
        b=KSJbiXvLtuzjLLMJMpeu2O0ZeGIKCeH7DjfK3rVDEDmKhZbh9jMOAXrwVMFPukvGEf
         ozIDNGeVbn3XfknJ4v3eTm4jOut/h0P9gW02ZW59fkMxmV7hUfRXEKtKRwOcgWtUPzja
         S+wDKXGWHGnjUQLS4Bxzp3HOM4iGI65ACxmkUQbjHmHUbXnhzDoXHLMRrN0SXAlEceYL
         GS606p3J5c2E/cPdd/HW6K1uOikTFQV+b2gjQCcNcAMeMlUouIPmMyxiYjp5LOm6zGOt
         fQd8Ht/nJqq75a3qM4hvzBcEiMeRQNFlj91pwk1bErLRFh0+5cTXn5GlWEKVeTQN0YVg
         I5EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwzUXT81lA/cW8Zz31w1xq4MBWQ6VdrCSvQ28Z/cm+qZXFq1g9w35U7lpE3UzYupvd5quTHwybVQ==@kvack.org
X-Gm-Message-State: AOJu0YyvgE12qQdfDuIpLlDXFJrOlBgP64qvsmuKuhaft6t+JDH1xNL9
	PmNc7FY0QSoNEJPKiYHVl56PVlLuzvShELm3dGiSidSMgfRtoxsrZ2z6dSRuWh8HnwY=
X-Gm-Gg: ASbGncsSAtxDkgf3Oy17JDtUZmNAbLwM4FR0E7dKD7MD3uvGh6DY8QqEY8pf9oI+h9T
	4Ldv6XeeYP/ACX8rpi/Kyzq/J1PLb4jLCKko9Dy6ya8oEpIZUyFSRly7YCAI8xhNSgxKcv8joSd
	fpU8SWhZh3c4aGtXaPwi2zUKDe7FPCFi25MsuP5ep9NZHasqmy4m3VHgkyPN5RHtVwj3yzBARTK
	ZTuFuCaXZ2t8LgW7HS2WgPjIvOKrLFeN7LvZ88p3A/ukvm8KhkENZFf20aDIwavzqs5syS8d1n2
	Fu6PeiJhsg4A/Z518xgm/hJbfWW5iSBKhlBx/QjaEqCXiUoDRdhQ4+TCO/Ytqu7fNllfLQET47x
	tn3BVPgF0E+XjVYu8xfcGTzCU19BK9Xeho1GTEomTyJO8yYKnlAT4VdH+xf6GZTQ9qXAX1vc5Gh
	/S3Dm2SiEmzq7KHgPkfdqegl6AoJ1afyDnFAe5ufzT
X-Google-Smtp-Source: AGHT+IFTd+L8MIsFVmd5+4R/tV4nej4oyMMzTvyobs7oRMR9eeDnvkZRxA29k7Ua9rj2plkllb3d8g==
X-Received: by 2002:a05:600c:c48f:b0:477:7b16:5f80 with SMTP id 5b1f17b1804b1-4778fe49c0bmr204044185e9.10.1763567130586;
        Wed, 19 Nov 2025 07:45:30 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:30 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 08/26] mm/page_alloc: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:09 +0200
Message-ID: <20251119154427.1033475-9-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C62620008
X-Stat-Signature: rbst6nedk166gjinquc585r9aqs3qfud
X-HE-Tag: 1763567131-189675
X-HE-Meta: U2FsdGVkX18Pic3njwyYcMYeyVDPf2NA9MvRX1A/gzut2MK2z/bwKUYA3jd9Uu/aXNLgcpD490vGuFQhT7csJ04+SxN8Yxb/se78dnx60NElw/NNJRXABmSFYNxe0aHsmPvuYQ1tX5bMbx/EGHzpEWop/Brw794VhzCnJIK99cc2GF2+amf2bQ2iU7SkQlcOB4Gd/w/UbC5lbVg48AijqJE8lrR8StzOF9xm4atPhFJD98BQMQcM0bQiJyJRNxlIfkSvR4ObVP88pzc4U0pbtL93p8hSDp1Z0TwZvU4uQnPxETS+YENuwF5vGz7tpgxxCLAvRBXSw5fnWXLPKnSM9Jp2ZIgWIufns9hVFNnwkqLWaOrpRe2dE3XYj14IiE5BafQVLr+3k7Wbq7Ki7lSSMGUC0ecqaSD2M8LwpcxuMnM+eh41Qp95imHTnE3wb8qGMA2b/43hRZUYFEjGkA3qwf5OCbaZEgJxOQKo6vDQatsoBuEiq09pQbwizrq6OO88Z+iHEg/nDyCJfdxchv2RXiz77cE3eLN1EsCwgqiA4nWgZ2SOiSF41Sl34twofcDxlOE6tUhf5GmhHKxNOjeSnjy6Ph2HB5DgFAvL6oxR+s9h1PAYsfRU5GN9m+AiiyKKdWhrvMj0oR1RhGIlEB3Qtkg8C7T5g0rerHfQQm6V+cHtOXLa8Qc1a2E/BXn1zHCz4T4JGgEAtn8LaApDOlOeD16+DJhs6SXgV3Bx9VtG0+SyYmzSpfaiNL2bDdR0JgLI1gM0rpvL9BPgM6+sVSntDG4aOkkep0IrnwW+xFmw8rELv7DYl36RAoA9/PW2nNZXA0fUo++1gREVeAQ+kfzEJh/ziji/L8OUvDHnCMM5ULI13Dxg8fbbSMgTRLyBplrT3jVBsNqHR3yuK1ioP+OC0Xg/RtMhii/dZZuMCT6bsPiT2suE24fuNNL+6hXF2ZxjpmxrwixBHBXcn45MEEu
 ce/ymwQW
 Lu1v4Xqe76+PKvGutMukL4fGNnEBeEgA38Snqr8Rb+9xmyJ5oQjDyK9Ydw6dKUI4BrqDF2T+Jwc+cWQp3pzSRCJy1Eyk9j20CPGv1Yt38ViCYJHfXWcJxrEsjhT9AiTTiLEo6kPqyrw6QIBFVHveZlxc4LeJ/TPs3+t8pGs9uXQysADqpv6QKlq+7WRN1HHlGvgyfP1Y7Jysh1bpGD5o3CVKdUAE8hTI78p0iQrS41ZbPLY4wHwXzFNJ8jLSuKWZEaPnv27HkfzML/DUhzr9H8QjDlRBLOro4FFu5mGeGwB1EsuX4Ex135v4zBrQwK8pilUMWpcrG9lgqljNYZhrzNK10rugjzoF/rubJma5PhUVAY2tyWlmGq4VPAdUXzP07uY8Lzwow0pgBGy5pbxsZ71oA5OQLAml/7XxcX/aEASIZxPnvIqFafTlVt0JmwbiBeEQKHs/hoO//kzOb9b4GJgop6K2krmW0p6yQyzF37isrz2NMZpY8alVJcjdVJrWzCsODRI6ajJ13k94mt5DN3rGw4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - node_states

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..323521489907 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -55,6 +55,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/meminspect.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -207,6 +208,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 #endif	/* NUMA */
 };
 EXPORT_SYMBOL(node_states);
+MEMINSPECT_SIMPLE_ENTRY(node_states);
 
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
-- 
2.43.0


