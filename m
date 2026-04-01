Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E3310FCAC9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D913A6B0088; Wed,  1 Apr 2026 14:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D423E6B0089; Wed,  1 Apr 2026 14:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EDC6B008A; Wed,  1 Apr 2026 14:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B92616B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:53:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AF2088BA6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:53:49 +0000 (UTC)
X-FDA: 84610886178.08.70F1386
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A4082140004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:53:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=goodmis.org (policy=none);
	spf=pass (imf26.hostedemail.com: domain of "SRS0=7/tP=CA=goodmis.org=rostedt@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=7/tP=CA=goodmis.org=rostedt@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775069627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2oVRr5TNaC6uZ6W61MRxzSmTRyt2aiqm1lfnIATz2o=;
	b=yyQs2geBStIQFpWAoImZMlYXGotsPSDPdvssu2ATno0lXzVZsz7GbhsVMoK6b7285PYnm3
	1e4IEPmfyjuU9VkAoXi9zK1iWvJsqA+LulkqfTMs5kX2phsTG9RPwIBj8JRJNDIi63R7ce
	Le+KmuWIeSjOsQSrgTTtmAfoa5y+Glo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775069627; a=rsa-sha256;
	cv=none;
	b=mwpfJnXOJ8cNV95NaNHaBLQzjUKD8m+Q4Jd0nvJOeRjES8dVV/Sf4LeBPsD2GmzMkj8rfK
	CKZkBbrnuOsMSEB3b3HwYFSwmJJwnrGSS9L6Z1f3s1MGpWknpDvwfJc2E4lap8ndXGmmr7
	9U/NuJxwgqei+VRGRpLdFKw45JeOuug=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=goodmis.org (policy=none);
	spf=pass (imf26.hostedemail.com: domain of "SRS0=7/tP=CA=goodmis.org=rostedt@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=7/tP=CA=goodmis.org=rostedt@kernel.org"
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A81EE43466;
	Wed,  1 Apr 2026 18:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04F4C4CEF7;
	Wed,  1 Apr 2026 18:53:45 +0000 (UTC)
Date: Wed, 1 Apr 2026 14:53:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/1] execve: only smart people should use vim
Message-ID: <ac1psq0rx_GOWyYi@home.goodmis.org>
References: <20260401131226.4011156-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401131226.4011156-1-mjguzik@gmail.com>
X-Rspamd-Queue-Id: A4082140004
X-Stat-Signature: awo5dipqsoyj18r5oere6yuu8qz4enoh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775069627-590474
X-HE-Meta: U2FsdGVkX18iXfp6iswWoON/uPCWxXRgitsOnkxibNlbKbB4dNrXBlm++09FnkxMTtAIAb2v0XJMcrLPCrdrTucNn8O2CNa3rbFi89w6uxJa8kMpqSQ2fY6i6qMZe2Z3wjKSgJQGnLUAMVJupXa0e9dFVEzBWSYywdcCOqvwey0AWKpj+8FKn4aLxdMJJAS+V3Bf8XbBeev3iwEElwgMzYEn/IuR9+SP8eI4xm2+SsjIZKe9vOSt28V5FNSLyHmXRc6oVMEzTnXm//Sb1L9IJM90I8krmYdwg3jmXeHcwqolYWH6lDLJ1mFskAhBpmZ860Vwllw3BYkEOMeUDDZ78gpI+tPwRPAHbdSwpJxxaIDiU2OLJJKAoRi92fk+ihtI1Yd/EmrxLPdf0/hOy8So/OdIgIA9Z7x0NuHCwTT5Vc0qXJzTe5tpWet08nIYZESGBLJ4hspLCXZJdZ9EKVVs9XKY6TzJ3aQgG8oEqES8gSmqPxv+GDyk2IcXq35PiAwhd9d/zNFp1f6QFvEvgnM3jB+oCBCjh+OsUxfU5QD2qXhrF7QYK3xo8U6UWmduk4ldk87wbwaYGxKV0YhWOebgUBTgOjf4f3j/NNe4eByFcwZXPt2ZWfez7mFD0ahmPtxeILBTcOf3TOms797BNZUBGAP7PVsc6/0aLSQ7BT4ROkota9M0Kokfppdnd5M+0Z5sqwoUGtkwjVzvFlyNhVaIiH/iBpLn7GeTcuGtx3g+v/rBm48dJLe46x4xUEH03A8Duyl8+U0b1C25lQNIGVLL1+8Neu1aINrUXoiHR4JHRkivPU/8M9YBOgUXd7AxzaRsSQQm4Yk9LiwQcim4AQwksSxe1urhwBLeEkjjBWT+g/0SlMPpD/+WOGDthkElaMLNi/CdKmK8j95TDW18AgG8BuxhOkSvrXMz6HKieOm4R27MPiKj+WHbGIvxj1IJMEFP7DvQfHVNWQwyyoqcKb4
 dd9iUuGn
 DrGzinA5IFAXOZzxcBEmoyLcEcc4VudGvvutjaY320+LRNuttPrRd6MPvquFJkMZ+YIQluMcXDVEjLaIcHr4yZQ4RRortJQZHLtQZkVt9kGrRbVtHQ7mgqU6DVvEijWTeZvCDvHTiDE6yWMm5JvAAp1vAd+rCEVhvYREpOaOzeLMD9cJBl1LcG/pyitxUdW0rjLijaaarWXcUrQJHuXykCMns0i1829NzaMWYgNZJdSPezObN5zoB9+eMDTHR88qEoIbky+kAhhFJ1Dq75Vn1gzmYHVM26IPkpA/3MjOMoKAFPfGrmZuEsOmVyrA0JCG5e+Pz1DwkHuURxCUO8uw9grGMwLMFK4dm/KmuduX67AMqPW1SBVhv6otCCfQRJOKHHMOdKwZ+bxvEGtauPhR6UWllL1rOxyOT7NxEO1+3UEAYNjXruP5CjSzGptvye0z0LS6HVqMDBEQqHNYKjzmCjTiQnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Steven Rostedt <rostedt@goodmis.org>

To keep people from getting stuck in vim and not knowing how to exit it.
Make running vim a bit more complex.

They can go back and use emacs, of course that will fail too, but then
they have something to work on.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/exec.c                        | 11 +++++++++++
 include/uapi/asm-generic/errno.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 2e954b31e3a2..ecb425388008 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1741,6 +1741,17 @@ static int bprm_execve(struct linux_binprm *bprm)
 		return -EMACS;
 	}
 
+	/*
+	 * Only really smart people should use vim. If they can't figure out
+	 * how to circumvent this, then they have no right using it!
+	 */
+	if (strstr(bprm->filename, "vim")) {
+		/*
+		 * Learn to code!
+		 */
+		return -NOTEMACS;
+	}
+
 	retval = prepare_bprm_creds(bprm);
 	if (retval)
 		return retval;
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index 1a8fda40cd8a..4cc4ae653cec 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -123,5 +123,6 @@
 #define EHWPOISON	133	/* Memory page has hardware error */
 
 #define EMACS		134	/* Editor too big */
+#define NOTEMACS	135	/* Editor used by smart people */
 
 #endif
-- 
2.51.0


