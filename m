Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4304CCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B5E8E002A; Mon, 10 Nov 2025 12:52:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952F18E0003; Mon, 10 Nov 2025 12:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868638E002A; Mon, 10 Nov 2025 12:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 704368E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:52:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 428F5572FA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:52:06 +0000 (UTC)
X-FDA: 84095441052.04.172E006
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7FE6BC000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:52:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RAT9dRk+;
	spf=pass (imf22.hostedemail.com: domain of 3QyYSaQUKCCgaEOIPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wakel.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3QyYSaQUKCCgaEOIPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wakel.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762797124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VOdTjIkCGcjxXz668t416NZ85KBy/IPkSb6VbZHK7cY=;
	b=5s4XTJ4iH4+aDHpnabxnCt+uPWwrlAXSr1t1sPNThFJIPtECwHt7RG9lNqMPlrGVB6CSnw
	99vBRKn4CbJyhUh+JOdMOF4RVEgbKhtWkm3rUA05HWBRQI21ugY+MjpdD6kjDXA37R8ZsC
	C3NH4fhIoD3sGgmtai+Og0X8daMvdV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762797124; a=rsa-sha256;
	cv=none;
	b=e7gWUDd1DVfvU0THCfeoe0qjH4yfp9C34iv8FhQSCasoKY/AtGPVRJeloX9h12AB6LP3Ax
	vLrzOW2gomb5zzCWQE7p3MjjDQLoVwjeu92K2pkIL6kPj21fIV/EnqeS70Utmf9aFWPbVW
	VgVueC1znMSn5/KDeha2YsMhWbZccIk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RAT9dRk+;
	spf=pass (imf22.hostedemail.com: domain of 3QyYSaQUKCCgaEOIPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wakel.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3QyYSaQUKCCgaEOIPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wakel.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a440d38452so6088205b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762797123; x=1763401923; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VOdTjIkCGcjxXz668t416NZ85KBy/IPkSb6VbZHK7cY=;
        b=RAT9dRk+rWAeO8coDZp/JqtWnBTwd23ozMXzPT7uz7IIYGXJ+7n3TTUXOz646ivhPX
         Ht2hzS1aV7B7KUzshcwBe6NNGQTgg3Hpgp9/H3fduTOFKR/rTAneFeSpurDpdNTz0d9f
         wR9sMRUrIk1Fb807iSSWomFqEX31l314HXa3GNrI3heGJpA5tGfkdsnHuVQXlp2X44ud
         zYyWfLvQJLIbWFhgbowaz94u7JIMxH+kBuPNELCMx8f+kPJzMNnOHUJ/y441HnXrbz8x
         +vcbtzFUlaOj4Ed+kW85MiTxC7XPRCv8ZkKrcbvT+wzP4YcHlfNTEyVFnCN+uYPq8kfK
         mS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762797123; x=1763401923;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VOdTjIkCGcjxXz668t416NZ85KBy/IPkSb6VbZHK7cY=;
        b=Pw0Rp1KRwLrBWUNqNrQI59wWEqeHqNbG2P8BaLCvSK1eXqkz+F9KuDLttxHzIu28A8
         LkIyCVgXJzasIDF2fIg1QQi5gz0RrzBb1MURhIQN/4Cqm9hnEPzNxRhF1OBcWwiB3gZD
         1RedpxCPovWKlh9B8NWRrFSl6MXSimOvpxmXU+45EP5IgI31GwiUlFhJKwKnkQKnMKl4
         a4apOJzcCvE9+ZGWsd0LnNxUbBJ28xBHoAnAnrc8iSEpq73wIus7oWxGhzsBFiNwrmnG
         bRD6TBlqWP+bUXQ56adWxe64FM4rzoEcKubZUgAuj/wJBbhQsSb5aC+D4sE0KdOeEPjV
         VzIA==
X-Forwarded-Encrypted: i=1; AJvYcCVLv0Wm8CHywi1l6gypKlLYVMsJjVPOFG7nVUn8M0dKPmlteQZdfiUdFWrayTm1Ghe3ie6GCyN4pg==@kvack.org
X-Gm-Message-State: AOJu0YyPoJJGT3QEVz11hRUpTWGuNp0IIltgj8SeuAJw//bjhCJK8OKx
	Z4jZ3q30Lp6/FogRXYP2cK+3TKzfgucsfakHxPRXbd+gAzQMcot248rbHVaqWPGl7MZ4KUZ2//8
	qCw==
X-Google-Smtp-Source: AGHT+IHWYBTESQqB9OP6+smLsVWuqBi/TvADneKuVwr5HuxTOJDLAGYUSWDls+iD4ejGoWboD+KQ8QxyUQ==
X-Received: from pfbdn8.prod.google.com ([2002:a05:6a00:4988:b0:793:b157:af51])
 (user=wakel job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2307:b0:7a2:7930:6854
 with SMTP id d2e1a72fcca58-7b225b61a51mr10573564b3a.13.1762797123012; Mon, 10
 Nov 2025 09:52:03 -0800 (PST)
Date: Tue, 11 Nov 2025 01:51:55 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110175155.1314757-1-wakel@google.com>
Subject: [PATCH] mm/selftests: Fix -Wtautological-compare warning in mremap_test.c
From: Wake Liu <wakel@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Wake Liu <wakel@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7FE6BC000B
X-Stat-Signature: 8sb4kbgf1f8o46xskonaococdei1karm
X-Rspam-User: 
X-HE-Tag: 1762797124-867425
X-HE-Meta: U2FsdGVkX1/ZNB4ecpqIjiO2TgEb786S4oZ/Vm4onFezR3uUpToMcJ0wPoP6b7Vy5/SRpjGnuX5BYUq3nJil3MU10cy+rhyqryF9Pyc1UOv/L7XAGBbxVKzg7onUY9DS7xJnrPiY7gkXRkQe+D9y5gWK4LK0Akl8Pre2mLVV0hwFX+2JgOD2dVZeR/CdYIHocd+rJyL3l5J0URGUSI4zHg3PrE0en/dGYqCErM/GPGecvOjChhehz+EsJYQOu6cFLR3U5cmOOlcrdM1S5tyTrKIoqtyGlQuf0exdn1IcM3a6lvSi8vMfGihQWUmEp7RS7QIXw2YK+awIkOQuQ1JkrUsPzuNQ/xZlpsrMRSZHh9KUK4B5+J2RcSKYBDBOzLWnTzPtp0wkEYzpKIC2y2QwIRQ+sF/KfP0xmJx90McZQi9eROU2vAI80Af1MY8TAhNqNU3nxpHR+6P0LKtjREciPef52LGllO1IXoMqbyuO2s1LPYo99CcKxWlgP3NV88se5H3+tmdKiKnbLM/wrxHCsp/W4oIEGzpAYbb/xfAJVPh+9IQnG1HRB4/5PJI8SmJxYBKgfPlvysJoK4oISwr/afbREgyuuXU2jydMmecwMUX4yI0/qNNUVnp/H5AJI3aWHZW4CicwiB7WJ8JdK1247iP+64rrD/AIAtwAzmwR3E18ukYqRdCDWGoLUf0qWuqxsLndPyvucYrwihbpH1o6XW9UpYZ6RmtEkl6tBKwWZMTmiignrtznfyqPEEM3EtI0b5gBrMRlYcXlFfYpeCTWxsUqFxIWgX704nZlfudWYd93wFbwgGvXWceiD103cTe1dDLzyOVrF9tKFl7ycf29VUTKNB6POINr6qqwMPItiUZffvPVU9lyIEzaCH707+1oTftNnfEfM4z+1KeMZ9B435hvbxkR08GBtzVBzeuzF1eI0OEMozzglF8dsg6ukxmmdEq3JSk+cwuyfC5+EdB
 gBIaLmE/
 /WjiOPFS5xaZcaGmtiAF8kd159OosCuqWOOk3GxdUkbcmk8j27Fkni2jPxmraqdY2ULSgvkZP4OLF6/kBLrXcIezPVpcHkpnOBTLSs0V7cFkSqb77iwaxhTVb2ZXSr+nKi0qPNiUa0ilvu15/qixGD+uAuK4WqFiYMWT6emnnRNAJOQVfVD2ULsnwzuTgX+kIUeIn+Mb0yMnhtln5rSx4vVged6buxtcU7AzqNkQPP20f5VmQUSgfdU7Tm6gTYvAbaQGnhmj9Hq0LdbmS/1xGDkgl6cDNtyVDGdqFvEWX3W7LjtGez7Pmq0CK4OrntCgFYZcKWwYjRAxRDhD+sfxFimrycBxiKgkuogocN3OW6MhxzwG4T8fX1pNH7cbOZsVJrez06h9e0Y4mbPs4sKSsib+5rfAxmnZ0kFvU2+f/TXLLKdL2lKQg1PLTR1kqM1z992Xq3+Ri+cLEavgBL78W1RPUe4leOkVDJAvhsfPgvhHR+nRIxvoTFaLi4w4aVC368k5Wes97zF3bP/eQ4klvoxIiTbA84ty2LuCu47rf4LsWwqukQsfQYmFKT2wcuz2xsfO44LQRjhsRtYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compiler warns about a tautological comparison in mremap_test.c:
"pointer comparison always evaluates to false [-Wtautological-compare]"

This occurs when checking for unsigned overflow:
  if (addr + c.dest_alignment < addr)

Cast 'addr' to 'unsigned long long' to ensure the comparison is performed
with a wider type, correctly detecting potential overflow and resolving
the warning.

Signed-off-by: Wake Liu <wakel@google.com>
---
 tools/testing/selftests/mm/mremap_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index bf2863b102e3..c4933f4cbd48 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1032,7 +1032,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	/* Don't destroy existing mappings unless expected to overlap */
 	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
 		/* Check for unsigned overflow */
-		if (addr + c.dest_alignment < addr) {
+		if ((unsigned long long)addr + c.dest_alignment < (unsigned long long)addr) {
 			ksft_print_msg("Couldn't find a valid region to remap to\n");
 			ret = -1;
 			goto clean_up_src;
-- 
2.51.2.1041.gc1ab5b90ca-goog


