Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBCBCCE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254158E0017; Fri, 14 Nov 2025 10:03:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B6C8E0002; Fri, 14 Nov 2025 10:03:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1421F8E0017; Fri, 14 Nov 2025 10:03:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 045D28E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:03:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0D9C86D22
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:08 +0000 (UTC)
X-FDA: 84109530456.11.3C18405
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC53F180020
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibUU70vn;
	spf=pass (imf06.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOlu8hBDGdeSMsm+Xh5M8vOkl2dHtZBdnmdHu3tigmo=;
	b=nyB1s3e+Y3E8JZHqHmYYURF6/UCsR7t4uUMwYzMzFotmo6mMV/FU2ZyAuLzKAgfX143CCm
	A5fw4LCctVrfWQa60x/k08+mj7Qvn4Ny7xZ4iP+tI7j7je2Qr80coRZB6ev1qmDmR6QC62
	hNISzml2T5M2TTbCDQoSWXrodrSEok8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibUU70vn;
	spf=pass (imf06.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132586; a=rsa-sha256;
	cv=none;
	b=h042dATAdi4WG5N/MPgv7/FEqqCRaKlmAy0BBuBO6yGulIm+xGuizeChXJyNBA9cP4wp8A
	U99kY7dUnSEufl5En7b5ScvoQXZc5xC5R9ytwQUa+NMkELYVFzXC3Ka8UiwLl/bkT7NLDi
	3jwaT6vy/GNPN+0AU1IrnypqACcapwY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOlu8hBDGdeSMsm+Xh5M8vOkl2dHtZBdnmdHu3tigmo=;
	b=ibUU70vnGUX/h61D4wC0fqi6a+3z5VPnKZAoMIEi207O3z3iHYKqe3quUElWTrBI088W1R
	de535NpFvMIAdmWhNVbIvpf/tQKBRYkXyOuU8lQ/au2GWmVL+bJ/WXXDt7ieJgUv3xqTLz
	+9BJdnY7wab/F3TA/B3eqTr8XQuRUQY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-eCuXdCzbMACz_ODxDptErw-1; Fri,
 14 Nov 2025 10:03:03 -0500
X-MC-Unique: eCuXdCzbMACz_ODxDptErw-1
X-Mimecast-MFC-AGG-ID: eCuXdCzbMACz_ODxDptErw_1763132572
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 976E819560BC;
	Fri, 14 Nov 2025 15:02:51 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B71AB1956048;
	Fri, 14 Nov 2025 15:02:36 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 02/31] objtool: Flesh out warning related to pv_ops[] calls
Date: Fri, 14 Nov 2025 16:01:04 +0100
Message-ID: <20251114150133.1056710-3-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: DC53F180020
X-Stat-Signature: qe5kkyci9oyydtdtiuq33rf496y65rji
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763132586-728867
X-HE-Meta: U2FsdGVkX1/D65V76thXtcNmuKkTFIw/N5uZlSi5AsQG531YacGiMKRd332IilQYn32l9MRWBW+wHUvm004FSRV2UXxDs2iCP18gHN7Dc32+VT5h0yA1L6Odtqls5Sr1gDJxMLgzPs2Xcc3clZm1AgPr6P9paVECqGT7an7QcbpoGIfY9ZJOA1XFSfWfFWtM39Q4kjLVK9PHv6oex6J7WdsphKB5VXia1v1LNIV6dcRaEnC0d0/KdkQbQiw1XltMee8SirX23HfY+PqaOPhM2vSiN25CjZTx0s8YDuN11Dt3O3pSkIxVeKCtPBxKks11vFuBaPJQCclF0KvpzvGP5l8H6em+xYvrdb82UxK4GYj2YyYmQPto6UnIs5WqSuQS+tt1d0aLoEugQhxAr0No6w3SwHzis2ND+1DHnR5LLpkiJsp65RQaAXILje0Riv5Igcvijc4J+sDACSE2HwKHM+7xOSX+jtMxsuxrK4Bouw732v3BoSTZ5cGMsvws970bz2gjxAo+o6K0iBbXygoioNDXu99OHW9zszx2cZQDswo8zYjyobMCpId3mGQeYACr7MmZd9pUWgu5kcBQj7FN1RlPdNpznrImr9tSmdpjktWTpk2FeJhlpr3iMMT0rLro5L700r0+qS3qtWkt29lElJcvQa2+EUfCvLbnpWT1jAnmhzDVUzxoGFBtUMgzEo9lheoJx6wcS5e9L7pyt3vsOiCgLQxXvuWvPpobyxEDbd5QI7Rw3NWcj5157W1l2pdIYEw0VJsi5/3jmvc89Q4tKl4dwsgoWDueuqOkZHcF4xDrcZ1hseYx1ZZqx09/zzW/TxrHuxwTSXYVOTIA0f4VvDF8uDYn5SpHr18fzOJ9VTh4kUJj6sOSUydKIDawtlGeOvaHGHrbn7sUy1JGWSuO0/ODaPdxeDY7Cji1Zdamn/j3eTM1+7DmzHNqooT12Yuifzh3qlRnA91NqK8ySyO
 gs5sam0Z
 bGm8j3DYPmPIJ55Ph6bgAuC8jiDrXasw1L+fDco905rAsfs1YgrnWWF4MFAemFp8OB2oonZM89iUDKGDqiSgI+X+hjC4Nr2MQfUGS0/pzACl7ckuUC45ruMC6qkovmHGJblW9ho1eZWdEUGztN9lSaV6yygSwN/nVVXkELNECg2qqHGl3Fnww6zWQl0Ti0s3HxhXWfzlqw5PZ6VjzSkQ0hI9X8A9tZTR4iNLqsiaA4FL2+8n+lkipnxQrRDoqcpCL7JQ6hNLYUrJxpS6d1K2KUA2NaJ8guqxygydhfzMU8b6HK7ZK5yavsD96WQRu0Yi2l48uB6+jk32+fKvUGWiw5/k12YRbF5Qi/VGSyb1mX+9Ge9iBEgSAdUpjHsNDzP9PMlDHUkJQ+EXGeJrV362dN+25Aj2EdGH9YE2ifCvVlAW+fMVmNfSOQ373ul2cvC041befBjgcGznW7F/nRE92wLKNos3Cmd1uYvGlRc9k8QnzlSiz157B2B8MAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I had to look into objtool itself to understand what this warning was
about; make it more explicit.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 12b6967e5fd0d..1efa9f1bf16ba 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3363,7 +3363,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 
 	list_for_each_entry(target, &file->pv_ops[idx].targets, pv_target) {
 		if (!target->sec->noinstr) {
-			WARN("pv_ops[%d]: %s", idx, target->name);
+			WARN("pv_ops[%d]: indirect call to %s() leaves .noinstr.text section", idx, target->name);
 			file->pv_ops[idx].clean = false;
 		}
 	}
-- 
2.51.0


