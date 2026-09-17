Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD397C982D5
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A758A6B0098; Thu, 17 Sep 2026 09:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF2E6B0099; Thu, 17 Sep 2026 09:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEA46B009B; Thu, 17 Sep 2026 09:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67A2E6B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:48:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA1A8A55A7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:48:00 +0000 (UTC)
X-FDA: 85223382720.30.E42CE29
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1AE2D40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:47:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OZbSwR3S;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789652879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ei3la3t9mnU7egxeLLJVw2Dg0OUQm68UUC9EQYYQZPU=;
	b=cQGeFCikfbVUX6jvl9icVM1+TgkDHMNScmGaHk8jKdXKq7Cc0B+quH7h9yWjZSp/NUXV44
	r8+MBZuwUgHHWnKSu1z4io10g8PnSHIJMnjs4C/6kQB3I0EYA1d1IJjuSE/Va1PWvVRY2y
	d8HMTKFJhA0yJSGX6bvZKrud5UAxQh4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OZbSwR3S;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789652879;
	b=oOzgfKZ9ESTWyy3ISfYXxzpvbRYGjDe05sMhxpAaA9+wzaCeMHE/Phz6zT97onNEke9A73
	6djFP537Vdy5LS5uDJceu4MINQnJgONSvGEFv449xvl3Q69GrTbSw30MSlIaxvR60XaoGZ
	g1pQ+oDVnmlt355rcbE6LtTrqZEc0vQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Ei3la3t9mnU7egxeLLJVw2Dg0OUQm68UUC9EQYYQZPU=; b=OZbSwR3SjmBfb5UAnj4ffQD6uQ
	TnjMK9ApQipb6geHD2ciiCEgIrqtdkUn9RlswO2B+bAs0vnx7Cdt7JFqDQN7Qq+A4sV7TVoIFiJjQ
	Fz/Eyp89W1W/SDkZqdLsWxzn2Et+iLJI2l5v2/i5ZHMffUItE99Jrpx6ezW7bF3xYFQwW6LCRMgeq
	XoWbleh2m8YDA10ftf6zFEU/KyfGOena69dRPNDTHt3R8QlLFwNRvS85ZNvIz3bhwN6Y86F653ks1
	7watHq8HPqMgU5esr5b7Zuhfv53dQJgHbLLjc/zT+Gc/BXnqajgprSnmadIY99+ecjiSyM7FN136t
	Qau2ZyAQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7CSq-005zBN-3A;
	Thu, 17 Sep 2026 13:47:50 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 17 Sep 2026 06:47:35 -0700
Subject: [PATCH 1/3] Documentation: kmemleak: describe the metadata pool,
 not the early log
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-kmemleak-doc-v1-1-84fde6d1f749@debian.org>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
In-Reply-To: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1862; i=leitao@debian.org;
 h=from:subject:message-id; bh=Eto8hzL6OaM80EOgMASH5eHiPO+2/yag486xyFWRXFs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqq+97bAZLPHORsUJDZJBGyd9jqqoLSrsRu/m3E
 VBvWYZmKpKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqvvewAKCRA1o5Of/Hh3
 bRDoEACF4IxIhijugl9oV3FI0E3zTWGkO2KSgHIGnOFvv3K+Mxi7194KcfTdMmIjI9ji7+GZoNt
 NpL8YVh1hCdQCSTm5HgQoDZ9WYjsL54UDncCxyxP8ambZSREXC6bJ8XllyzuDj5ssVhbQVmEnDd
 o3lqWniw3AIY9G9fPj4XnhxEXi+4g0Rgx4aHU/8Vr7xtqgjrTv/tmeTKjyUmiikvfcFC97wisd0
 Gj+gh3tJtMEHxQN0QTCY0bj/xk88IQqRFTxAExrs2Nx9QR7RjBwUSknYB5epCfhXUiPIMrpt08n
 eCwD4bBW+JcBmARaWxuwFNijmIJR+x/BbX86Vc3I31xmMpOaA+cVS4N8HZkdDv50E0wTZu0nMgf
 hYQMTt14KYGauGp6dYZG0SOINEcjLnpxxBRLa0ziC8wjtZh9QeRg7LLJCoTCHtHhZE+oj5TwWcI
 JHFFCM+WAa7qnbLEC8wWSizAbjC5SnzVO3O/AH4w0yPQBFhLaC2EztbEFSUq6TZdTi6/soCw2nJ
 OE5tJqPQbbWO/VSu6Kl6vxmbhIKqFtzcByJHi3eQBPGZWvzelhSOb2ThoGeDFjXONSrp9ED1kfO
 fh34x+4Iy6sntbm6zwD9b4zoRPNwSUGqlf3LHn7UH9oMrW6O5bjxbS2j/flSoQ3KQXElTYt8OMg
 Ozo5kvCKQkEis6Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AE2D40007
X-Stat-Signature: m7z691ck1ziz3rtqzbwewop55po87e4m
X-Rspam-User: 
X-HE-Tag: 1789652878-103302
X-HE-Meta: U2FsdGVkX1/Sq3gznCq0VfC4t+lvu729XWVf/L5hiRAzvpCUt65Y+ct+mww16wLnhvGyDLsoXa9C68N2SPqIFvPZNAmh/rIaHg5IaFUjYJdCtoyB30bIJIK67RJRXgOoaCFA4usvkW1ryJ3SNB8+C9/uMhiUj+/LDYlakyCEYKOiSmiDI4P4JJ8xgUq9EvX2pMNiOD+bI8CKvDPXalbHZRgqZbE5GNe6OHreRLvwQ/19p4Y95FMrne9FD3PgiFPkm85DpZu2wyUiuzF1Yza4D+V7aBCy6+LAiSadOeuQsWSU1slW9OLtd5uNdiRMyta+CmOru37dHE0lxZK6XiU6Iavt0gyxx8dmnDjM0SETUYiSzE+mq1Jz+Sl8hh5hXol5n+Fom9Ww9FnP/aNuiTfuMCb/QtoqOl+9kEqTsQUxhO797Z7dnWXZxknatFAzmBmZlIYrZ8ULrSL+V0MKMF+EXmSdXrnojUPgQcd7Fbm9AKfvo8Pf7/Yf0kHxgYhaBk19FUgrZyqwlKeLiZUrEWuqm7TegdKKZZFiRSeGKhXVgpciEAslyqLYeZ6D+yrSG7a8eiyLIoiwg648ggogT/GTjOErF6Gfh0XGJEIN+9GyU3Jg5H8v4aTx5ydYGcWNHZyhERbNGVwMAwZMxnx8iz3yj0Az/bcCusNik6+7FhfUULO0b8WviCj6RjjnKYt+/NJdZ1Di87SvAY1dBh+Qktg+mYaslin7/9Q/SEu+l1S19zZGeN8DVHkRabDFJz2gv/STfafJFE/dc8f/tzkiiZHwOAqkkbPOb3GXjyUd6iZ6nGsahCYs6qeJqy8XfyVIvFdo+uLLRZ3kSbizgFwHM+Hnjia8O34l8iYcECLaLzMxZW7IsJXj7e7YEOJMRmcUkKkTCCFfKlOQH9pRp6Vs41Tr8F0YKdmVaSTVpuCtCrE9PNsbBG6uEt2J4sTZNcnGIZlTF/clXTsepjH6xFIS5nx
 z7XzvKp3
 WuzoD6WOiHgiwUqW6i2oZ4C8JEpbgkgNdNPXT7wOw3V4nMsUfU3G+hY8v6J4Ydtmif9CwSmV+M4IS2rQoqUEK7XP3i8SdeMFI0Zi8PuGyIErc6YzNJF9IGuJkXiu1KlDcYrH2LrW8BxVBXatswvMozE385wvoAF9SD2Asf8ZTOiLYprxZIS1d9Kj9s1GgshKqlA2csOpdMZlVy6w+NQKTeJ90l57RTpcsSmes4UzpYms5GuvkEoCTC98k1nJk472tUmqBO/rWLi63D8MGmAGs9k1+bsRKPjIt0xAI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit c5665868183f ("mm: kmemleak: use the memory pool for early
allocations") removed the early log buffer in favour of a static pool of
kmemleak_object structures, but the documentation still describes the
old mechanism.

Fix the documentation by describing what the pool actually is, matching
the Kconfig help text.

Fixes: c5665868183f ("mm: kmemleak: use the memory pool for early allocations")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/dev-tools/kmemleak.rst | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index d1b690b171696..8dad7647742d3 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -66,9 +66,14 @@ Memory scanning parameters can be modified at run-time by writing to the
 Kmemleak can also be disabled at boot-time by passing ``kmemleak=off`` on
 the kernel command line.
 
-Memory may be allocated or freed before kmemleak is initialised and
-these actions are stored in an early log buffer. The size of this buffer
-is configured via the CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE option.
+Memory may be allocated or freed before kmemleak is initialised, so a
+static pool of metadata objects is used to track those allocations. Once
+kmemleak is fully initialised the pool becomes an emergency reserve, used
+whenever a metadata object cannot be allocated from the slab. The number
+of objects in the pool is configured via the
+CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE option. Exhausting it at run time
+prints "Cannot allocate a kmemleak_object structure" and disables
+kmemleak.
 
 If CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF are enabled, the kmemleak is
 disabled by default. Passing ``kmemleak=on`` on the kernel command

-- 
2.53.0-Meta


