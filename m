Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09FA606EE90
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wvYX7M2M
Received: by kanga.kvack.org (Postfix)
	id 3CFFD6B05BA; Thu,  5 Nov 2026 04:53:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333036B05BB; Thu,  5 Nov 2026 04:53:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270A86B05BD; Thu,  5 Nov 2026 04:53:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 076556B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:53:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FB5E1C4394
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:53:12 +0000 (UTC)
X-FDA: 85400602224.02.8614FD7
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20431180003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:53:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wvYX7M2M;
	spf=pass (imf06.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872391;
	b=yz+oyGwn7HTlkt/NT93FxjtgnulcMOQEw8BFpmvddGR9DnTJsDsuq3Sox9svJvfMnV3ibM
	UdyW735T22SDL7UVnWQo7ln1XvkaEpqYU1kCO0cWm3s7rE6wQI6R01JRKFHJPIev0Xft92
	2BQt5+AU9rwL3AlJIpED76ujY95rl0s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wvYX7M2M;
	spf=pass (imf06.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akx74pP0EqF+1pksOPbSGjk6x7dhXiLrhRaRT4PeLV0=;
	b=tY6+T5TY5+XvX/T/udpyePWdRYh3aFn2b23x9wyv9BgIdCcWn42nY/nak/mfFSCOhAGIEq
	yNh45BfLWiaVKVL6j/8t5aClbqt7FObT4TglddTJ2YysTb5xsa++VqkyVXJsIybB/cl5qz
	TPooNr3oAbuUoypmJuXeM58+K8NcV4Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872386; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=akx74pP0EqF+1pksOPbSGjk6x7dhXiLrhRaRT4PeLV0=;
	b=wvYX7M2MuEFm3EKKbzxk67gLB67khQiNTrydGAw5gRhlRvgEEhVgNqk5VRShQmZvn5WrmbbwyovhqqryxORYZJ44g2WHgPuuJ8BfegMTLvcXzntNGRbDJrQne96Hf3TJDWmlbLNp+57jrbw918Y/yeLdHP0u7AnlsjYfrNndgJ4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XE8JNsC_1793872384;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XE8JNsC_1793872384 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:53:04 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: catalin.marinas@arm.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: kmemleak: serialize disable-time cleanup
Date: Thu,  5 Nov 2026 17:52:49 +0800
Message-ID: <149d93f2cfe20d355f4d9882ce2bf99030217772.1793871596.git.tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1793871596.git.tongweilin@linux.alibaba.com>
References: <cover.1793871596.git.tongweilin@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c6n5dggnk6qxuwcahenibswe17d74zmz
X-Rspamd-Queue-Id: 20431180003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793872389-526820
X-HE-Meta: U2FsdGVkX18CQJ5A1+2yUfkMytW9X9X+/LSDspQiikvfyIoOq0QnEidqSBKi2aHgdS2+GWq+Wd178Vwpw2GQ2tWqAheNZ3ezQvil3YgFdFmLhwC1xdu1yjr/Kdps4mzr9F1PVeEAQZmFnJrHxxc8wijKStd0bkdChTN8njadgoszy+OCNC3XFYK+5vvnA67MtkPUIv/ijD6EOg0LbzhZBxQFoI/k9jwu1LGQqEc7ifuHfhqpaTod+4B1AcRBpo8M+a3UroEdHx4WPkL4tpEdwU1IhPoNge1DR2D497/v6AfTP+YspMR6RxQgbUiR1aEsf/gHFwRTrjH68M8TsnIiPUiSZTlxcYSmdXZuXh8eE/ve3MaELibTOBh2evPreq40r5UESO7+M3ddULJuvoPsO7z4P7s+JxarxoM01oAkLnvQqGrluZBadg+yEJH8+c21QEcGDoMfS0Mk1jwwIW6VuhI5r+GPDm/RHpNZELQ/u6qDxMZrBu7ygLr0ThVyh0XNQ9QyUM3YRYsQmkuLIuWKoUSM5XtgBMn4Qa5bq09OxtlpgPJYgePmmMH5XNIv1TyHjf9GFYknkp5U17usVuMiWhT+utFVq+56vvoOXnJ+NKL8zTc40cKdMrlW1p5SOB0VQDMdVVIRZQ9k6DhGwSpu6GGTe21G6RB2gsg6MXz0poGmGUbC1245/Q+6+pKkuTQZ/YtlgFOQ4woqNbzj4R6JyU8T1u4jHEScrLWYWQaJz+rdsQijUx1/7b9skcdy9z2IO85qiTBx/W6HxXoEmDZs8EvbeSLaL1g2EplYsTWt9DWF+2HhcSJ7iOfybVVS+cbrF/KgwtngbA6I2hLeyVluLFxpai3Ikjxq9fR7sgcxKJh2qNN4jY++hngWvZCttgaUzCx3SVYaDR0n7ghgBgKQlDS/gclVxxpvRhWXLiUbd9DPYjdK5A11mEphwb5WhHj8a9/iGklShAb9rPS5qv6
 IBkGxvo5
 7dDxwWw1BfZFFBI8+NeTx0JepuG9kvyFZhxqLqnjnbN7jsgo85kF24UdwSQ93d3iAQGvg21HYWk17dn3+V6L9hdoCL7cJqiLMvsWmnQLDZr2HcX8yKQ6SaJmsYQloAfOr4rSQkh8d/XcSdRhoRHXr7pYic24VbOLh7akGPcFw6hO+puyyne4A0pt+cU2Zuyr6V/3z6AnwUGAMn8pxgr6MxNsM0K+SB6mAO57LIotx+/jrf3HjHfLNR6C7Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmemleak_do_cleanup() drops scan_mutex before removing tracked objects
without kmemleak_lock. A concurrent clear command can therefore start
another cleanup while the background cleanup is still running.

Keep scan_mutex held until the background cleanup completes, serializing
its lockless removals with explicit clearing and report readers.

Fixes: 2abd839aa7e6 ("kmemleak: Do not corrupt the object_list during clean-up")
Assisted-by: LLM
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 mm/kmemleak.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 20c0eb41c..d959d11f6 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2507,12 +2507,13 @@ static void kmemleak_do_cleanup(struct work_struct *work)
 	 * function.
 	 */
 	kmemleak_free_enabled = 0;
-	mutex_unlock(&scan_mutex);
 
+	/* Serialize the lockless cleanup with report readers. */
 	if (!kmemleak_found_leaks)
 		__kmemleak_do_cleanup();
 	else
 		pr_info("Kmemleak disabled without freeing internal data. Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\".\n");
+	mutex_unlock(&scan_mutex);
 }
 
 static DECLARE_WORK(cleanup_work, kmemleak_do_cleanup);

