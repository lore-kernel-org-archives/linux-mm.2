Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8A7CF3942
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869B86B00C2; Wed, 19 Nov 2025 10:45:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819B86B00C3; Wed, 19 Nov 2025 10:45:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708B26B00C4; Wed, 19 Nov 2025 10:45:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 531066B00C2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17FC0160540
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:48 +0000 (UTC)
X-FDA: 84127781976.06.044F3F6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24AC4140002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=S9mJ6qzk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf09.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567146; a=rsa-sha256;
	cv=none;
	b=IlTtOIox72/5vesw3/Tumsk9n1xwUWUXYO3X9RIzOkQw9amNuZhp5fGO0g42rcqPWYriNk
	k8lDaUFNmB55FNRPkJ7a6PGDAWisom3IebGE6wlGkYAGrhqk3y+jfLePJ0JDA8oN/ynehj
	dMAP1F3BNfVtCNpTHjRsM9q7vFitcSY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=S9mJ6qzk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf09.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qf0q06JpGKFVTNkejD0yb20CFvUyN2OLH5ZYFwRjaWU=;
	b=OrN8JgRbgKQkiJ3RNkI+9jGZeA2WqVZUg0rNCqrl/fHzQECCsUVNzSpMWwrouZSbpLHSCj
	9R5PO1AlwAnF134l83YSBeVNXKrkj3kYLDiYw+iohii6iSaIlFLXEVNSJGiWsdGuHO+Jnf
	x1lPmfmwRUaQvvhvrs3Er/hRc2HLDP0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477563e28a3so8031125e9.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567145; x=1764171945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qf0q06JpGKFVTNkejD0yb20CFvUyN2OLH5ZYFwRjaWU=;
        b=S9mJ6qzkrZZZcYhWS9OJjwj46HWggUQeB3c00GSlTodDkwxq0Zi/iWQPRDtbZoDXFB
         8e6lPUrjLokVftRsPErTQw9pUku26ZAYlaTJmxF1S5DyERJuP5v+8Yp9cP5AdHAYCEDj
         SbDjBCuVH1Sw/FpVsWqeoNCv3YIWd1kS306WZbvUytJKQdl4eYTFMv1BqEqLyj7wo5hW
         z63Gn4SzotR/cQaeTnhwsW9ws7pnay/5lAjoMTBHP7fUZ4ITVaSieqV0kegnWv7wsMed
         GZFdBekh2JTzfiAVaeMNl7avFUoD8lNKvrAM8yB5Hdzk1HYUX/pLjM2S8gLx3u763txG
         iMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567145; x=1764171945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qf0q06JpGKFVTNkejD0yb20CFvUyN2OLH5ZYFwRjaWU=;
        b=GHcSD3a/CsTr5Nq5fEWAfKzpwa0QuQgWUbnqC2/UXoWgl3OFpfaYPynAZuYJUUXRU3
         2Qy3Jg9BLTpSmXbIJQlOGurTDU7gZkF0Jme2YytFoShaddCZgHODaMKFq+TOGrTNyXxd
         XxlPAnvXJLcSVWwWCh8U872YgAF6wTHtRevnlIyyccQNLHJO0x181fY+MJsDcsSxnRhT
         g9NF3LgAta3n0flhl6xbncLhBje7pwnpS9LzqhAWJ6Mv8WyI4bf2iIlQbZh54oy3L6HW
         zDhkHbKtJ2XKbAOJ+dLJRu8yk8HtdUZyh9aaZ1uAqhj8Np99g8G0hd/bpLVCidn+Pkx2
         yjRg==
X-Forwarded-Encrypted: i=1; AJvYcCU9cX0CNkQU32g/zaKFNNPChgD77CmJAuXKc14RTPXvJdq5CorUbUpV6YhrNAci1eQ1UIP0zLHx4g==@kvack.org
X-Gm-Message-State: AOJu0Yx0lSVnEGuGg4nGzEZuXLgrXPmC/YPMu1pnEkMbB5z+dftBBccf
	8VRvGhTbgptxQPFtKgo4gatlmJVxMb0bSyKwYzi4w1vFr882Sx1ES2j+GUXoGb4bEYo=
X-Gm-Gg: ASbGncv9YfIQYyYanjqLfzU+JTpP/Daq6IMt6rMC0Jifb9dR2ZUEMrhhgthxxbzCUh3
	xnXipWCEGsPgQwdp7gInP8tDGmZ3wE2WIAokEVYEsrLBqgftpbrijj6GryjO0sRR2RGI6/dUAxi
	6qYDmD7cBv2M5BpvTslcMwNuuvlGBfXoSTEkDW+OgqkSBFjuVrP7rY2PQfx8bOjLgUTM0S0M8CY
	VHVYdGYVhHDnwDzgG8uzuTcTPkTYtn+z+pH6b+XLxzxfo1L41t7dNxhZDpm87TIx317zktsh/2w
	B5XMPVPDz+s+MaJNEr5DzroaXQ4XpAQAlKsuAqd9HA1xR6OSbm/TkifLqDueOzUz8Yg9K1wz/I2
	ETvxahUFUEilSsCIq5CEDM5bHBb1XmuJf3w8/XxmDPKi4FB6gqHj6zRDNZXyaFglmJmqsW7WAiI
	/Ud0MaNKlTgqkZPss1IICKUDp9cVYLbA==
X-Google-Smtp-Source: AGHT+IG9WtxjjgmkiAX9yQZlIznike3yBomBYuHSDjoJXaquW6OMMeXhxlHfzRespLZJBzb+ERriSg==
X-Received: by 2002:a05:600c:2313:b0:471:793:e795 with SMTP id 5b1f17b1804b1-477b1787bafmr21362035e9.0.1763567144657;
        Wed, 19 Nov 2025 07:45:44 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:44 -0800 (PST)
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
Subject: [PATCH 16/26] mm/mm_init: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:17 +0200
Message-ID: <20251119154427.1033475-17-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 24AC4140002
X-Stat-Signature: tfkc3mr4on5hfkd1ax3ptzrxh38zuhz4
X-Rspam-User: 
X-HE-Tag: 1763567145-960351
X-HE-Meta: U2FsdGVkX1/gzmHNEMn6LOmIhpXLifRzeacricujZytFbcys1lZFY8dzwvzJdhKB4xNsm2lezdEuTwr/V85gFsA/SDwk9jTiigLLXswVgyv1Szn5HIZC01gcRTiLc1dUIhBZRH1X8piJ/X2hRzIe1Yj+nTXho7CjPtbxEgPGM70nKTf5/2XsIcI86vQfJhfOE+2XcTZggem/2CDxn8wvX8+IBS3zbyOqowY2L5vB+7zN0gCiuuFbPbZd6WjrG6my0Uo9+7PotadZF8MuKTZ2Uq28BFdH4vAk8MWJSWIYGuylsKm4+P0AiMcQTndJn1AoS8D3T0LK8Ks0DkITp1hD3475aCGHZi7FSxg/zsuDhqtpTf8W58W4gJ14ocOJd4PPAkTrlCBG/0Dxen+XclVltM/rXxKglM9BvhMGbV+lCXBrj1Dum/cYYf/4vwFa7oTa1iy9utBzywpBGyYT/d+sjRpkCvsYQh0QiZ/NXi88X97Kl89FZrxYeJmWrlg7Rp9T8Ydm3X+FzcxksjDTsQfBgvRFP31qFtVXLAJHl25btOPrkN2QN5hGB9P/p5/lcpWo9PAMUZDzvBQ9H/UeuyFF9IT7WPMk0UMw7coT9/rimn02d+1L/QIrL+eyP6/F4h+ot4dR29kBwmWpMiUYEG+FVJEjlzc4yrsPSXgb3TrEPkMEPQS2XBSGPLXkpO3h08YMs0tYoqCcM/dUIgqIkxEbPJOKkExs70NzFlq60DK2yj5WgAVmDdt3IivSrYvf07DXJxC4FPZ2skVDEl0H+ihYZ+ijaY1lrK0fyTvlbNbvGIe6B9khAcYDizrVbgkOGZ1YjMenBzTfXKP2fvmA5sWGpql53UarQp/rSMgoDTSKHqSjgqdm/6PZ9snZksViR0hhnSmlfe8cN9Us3xASxSlYWEMDl2qek9DLqn7nOT2m9DRrlflKxyqf+FrEig2obUwKY5i9fHe8Q1Gc7PaLzpQ
 BizI6m4d
 jLHop6/74gtALkEweFe+CcpO9+TaIn7KCwGEDhM9YnoubCDUPDeKnPFaDL8oLXy4Wtx0sm/ALZYiiextKhj2p8txifIdHXLQE8BCDDKAwcrU0QYUaEW9/0HY1hfR3sDtFIj+LR6ZTgQLC4yhghEVE4b3IFEWuByNmEG440pjKJfIKwZ/aAc+IAbhd79U9Wp05TUelDlOfi/1KWMz/6dRZQJzxOzqLu1FskZZyRlhkZY+5Z8jRXItyaMWVJ65nv8PExZ5Tc7RElQN5l9h3vZC0CF/D1LXAnKZCzxaV3Zic3ZWO2ormDI3Ms/im0+Z2rVAj43Tq1PcAtztPjuirxax5RthIVafdunt/mpcF+SkHVtEpQiqGcagVpxbGUYmwIwAF8Q+1iOxy1MpQoxgULarjkvKh/LAME/9VOO2I2cw0plQUFV55uEZzkwSgf9JM4VQx+VLq4Q3d8C4bPshA7O6mFH5hKKeAtyMgZfeiWO+X3OaQhvInhxeEwgq7I0LyEuAZp422kUBcqSBOAzrVWyP+si5CsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - high_memory

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/mm_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3db2dea7db4c..c31062a3ff47 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -32,6 +32,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/meminspect.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -52,6 +53,7 @@ EXPORT_SYMBOL(mem_map);
  */
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
+MEMINSPECT_SIMPLE_ENTRY(high_memory);
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
-- 
2.43.0


