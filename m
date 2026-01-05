Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B63C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907D36B01A0; Mon,  5 Jan 2026 11:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3AF6B01A2; Mon,  5 Jan 2026 11:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2F56B01A3; Mon,  5 Jan 2026 11:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1A26B01A0
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:58:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19CB41A0143
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:52 +0000 (UTC)
X-FDA: 84298519704.18.3D7F98F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 89D8BC000D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=svrBcNYN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767632330; a=rsa-sha256;
	cv=none;
	b=aDdugK1pF8xbTxy9jZb71sBxlmFu8KDLyziQZ3fViQjAPWU8fBjvpXZG/PXOH6AuO6+apP
	qfttphiOeJFZeNVvOuzqC46SVqt7oOLUu01ZENELyE+OSwzKx0F4rei/e2mwaSHwWaH3QI
	i+gvzdSH2tNHYxA8WUjrg7WdIz44gJk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=svrBcNYN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767632330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3p8/iARn7Ne+mgy99vOdquYnoHq9+JHvsSKe/gLUKJ0=;
	b=oNCSdJw10s0RnPpMGrm0uBJEqF5jWnfuGmoSqbpHxekbI2qKPPkxokMM2Uh3hN9MO/mV8w
	uHSm6yOOocD9w+c3iuqYXrdUI8qMYULi0TNHa2+cr6laTMPmUlkPUMsjvFRgu18Ij8H2s/
	dsWyVm/7j3J/kpMBqjdpAFqeQogMJVY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B44AE6013C;
	Mon,  5 Jan 2026 16:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2367C19421;
	Mon,  5 Jan 2026 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767632329;
	bh=fx5hU4O4QRxBLang5mD6EyamP0RPBzh181UvkxPwN3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svrBcNYNOWwFsNOsZuHPbsSLKKggkG3B9iIlMNA0mv8rsCj/DdlNBKj8SMVRsg9yo
	 jwcc/xtvtmEogZ34qkeP3/spCawq8zMu5sVFjAXs5UG25LCW7lDMpJ0oczS+ItrJY5
	 zwJETKF0vuG9yPhjn9jDmtas+9mkk/cPdRarDLjFFGLsBflYfDFpk590OWg0YgAZkG
	 NWlFQtC7p1/qa86uOxuF2wRPenf7iZ1zuq2MKxUBmISN7MbBGwnu/OaVghj9JJtJ8L
	 M1Sn1VXyGh0ANtc2LaBCUj9j6OAVykRJ1iYNQJsojsJiiV7nPRs3sr+9Oh7dOIkjkT
	 1Ba7g+REDsqpA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/6] kho/abi: luo: make generated documentation more coherent
Date: Mon,  5 Jan 2026 18:58:34 +0200
Message-ID: <20260105165839.285270-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260105165839.285270-1-rppt@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89D8BC000D
X-Stat-Signature: enj944yxdmhqi89y5gokworribdwwwnz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767632330-787287
X-HE-Meta: U2FsdGVkX18WDk1buQ1PYTSWGf6MtJwCpAaFo93f3t0adwdIuNOwD36d1RO9/8/rgBkGS8uVOcnC3ty0cqDJSyme1ioa5iC62xRrFAYlLMzMO0Ipg3cbduIy3gD9WuW9E86M/TuG6f9qD7tPdMvMDwdnrIfZLBiAf5mk6U0dC6K2Uu9Fjog6/dfvy0RuU+Dok10o8bRXKfEg3uHNhXcyUUozYvclAnLl3iS7afo0saonlD4FN1hMJnfAlWhW/vikGFTTUQ7kom5tod7UDW8lbPTfBdM5F5urtkO8AYZkkEz2SwuBeYTmQdIVxBxGwgfUSR+fvSYn6+OBL8d4QdMzCh3m8L8jVRjeWor+Wgv+lTXWKOrvExxmE2I6vUTgdCW4EBLl3HG5rkdQI6FYqhycv91bn8gMUhaDh+xVvGm7FDdktCyWbT3xywfbXYIdAe5TvFCgE54zDWTn/pHzquvonM4qFyzTf9G8rNnlo7N9OV8Z81Wnldlfuc8Z9dkeuOxMyjaNnjcygsu1danCOYYdpptKnR0NtE/iBi2U8tW/tqhSus9zMrw4ls6gy7bCZDv68JoJ4ZxUUd3Jg3T1iHogpLJ8X6OYEBTU21vZ9wUt9U7xZiJ2DIW8I8PDpxvZJLMtPwzLLMkwtK86HeMI2sKTrddlNZ0hQHxZsP8iZBt5hHSER7umcYLN30avjymfU3HdCaGtRE8aan8uQiHl+dgW0wEydzkI2erKvs8Ls1+35S4eT1QhCG/wR19fmWa3Mh+GYF5h2sCeFDGD+70uwlczJORHmDOG80YuMcDXrH6Vtb49diQ0M76I5M0ty1i9LCMiYzSfTZTiRRrJtxjObDAs9q1lCBLC+bwbBw91HO53gmm80R0R5Au1n2E/FBg97arfHGnUXo5WLFAU0zNiRIjKgTjgVuL/PEIa1Ca4YvamneXRNq48Fw+ELwvP83vmsUEReQ5GoI/Wdcg1AN54rOJ
 f5x4EO63
 4e37Lc5B1vgUbywWENJmm+k2e38H0fYN0f/NLVnsJAWV/9AdzMENb0PZDZr5clXeqdvP7siXMlr2t4vn4G8aJu+TDHeF2j14bd5hNj8eLaMpnEi3KDwVVD7Upxci6CUlDuT+3nEEckkZiHtKzeYwCIMEW3UwA807KUFRCOjgH8lL2T2P2HGABQex6G0S7kS6mjeEc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

LUO ABI description starts with "This header defines" which is fine in
the header but reads weird in the generated html documentation.

Update it to make the generated documentation coherent.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kho/abi/luo.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index bb099c92e469..beb86847b544 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -8,10 +8,10 @@
 /**
  * DOC: Live Update Orchestrator ABI
  *
- * This header defines the stable Application Binary Interface used by the
- * Live Update Orchestrator to pass state from a pre-update kernel to a
- * post-update kernel. The ABI is built upon the Kexec HandOver framework
- * and uses a Flattened Device Tree to describe the preserved data.
+ * Live Update Orchestrator uses the stable Application Binary Interface
+ * defined below to pass state from a pre-update kernel to a post-update
+ * kernel. The ABI is built upon the Kexec HandOver framework and uses a
+ * Flattened Device Tree to describe the preserved data.
  *
  * This interface is a contract. Any modification to the FDT structure, node
  * properties, compatible strings, or the layout of the `__packed` serialization
-- 
2.51.0


