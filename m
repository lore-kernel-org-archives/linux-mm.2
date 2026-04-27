Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAAACFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883466B00AC; Mon, 27 Apr 2026 08:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7972C6B00B1; Mon, 27 Apr 2026 08:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2E26B00B3; Mon, 27 Apr 2026 08:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8806B00AC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:04:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 070AE1401BB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:12 +0000 (UTC)
X-FDA: 84704202744.28.263FBE0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 30A3710000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FrcRXtyo;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777291450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47qaqV+mdeqKvFvgNpCp3D9H5gjzcSrJHbkUmsUuFfA=;
	b=hyu/TQCNYBWwHNJSLeQeW94LM8pOMOf1k0HkzXLjqYvrlKQldlWQvSKTyz0HZ1Mo6dnDO5
	7C5eF5SN8WbCJpU7CtW8FPUq9qs+uu435sQPNovMS2gIIFvyvScmwMFRl+p1D+B4aR+FHo
	env3YNx+LuldCz62mQ4Mn6umvo95afo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FrcRXtyo;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777291450; a=rsa-sha256;
	cv=none;
	b=LlaFsbnU1tmE8zCyW7MKmSg5Rdjc57q+35gZRAcm59lnRx+mqT2mD5f419rrclTaOf3c8B
	Eaf4WKNGTuoZeq3lYfaS3cX5z8LEd8Wk+ZeIrLBNeO8+VHsmuj+YRjgoKAFOf749wTaTBx
	i+/kUm+2reFhr/pJvcA+4oDD81HoLdw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA2391684;
	Mon, 27 Apr 2026 05:04:03 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA1BE3F62B;
	Mon, 27 Apr 2026 05:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777291449; bh=W1D5lSXRtEDeQjde+9XAOouOpPIYvgXYBK0Xv65p3K0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FrcRXtyoVN+V5QnRWUBcPP11+5QJboDFs/HJ+cJcNWlVL73mrj0coeJAWyJ6c00lz
	 Ma1oL+zHBHNZpHbpiurhIeqZM4hAmR80fUOAiPEn+krHPySnbUvDCwR0rEMf0VARDX
	 NM2JVBbf7eizQct9FKyZ/R6dTUecIOJ7Qf9bSXmg=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 27 Apr 2026 13:03:37 +0100
Subject: [PATCH v2 5/5] kselftest/arm64: Add tests for POR_EL0
 save/reset/restore
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-poe_signal-v2-5-2bd9d6f16ab4@arm.com>
References: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
In-Reply-To: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777291437; l=5057;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=W1D5lSXRtEDeQjde+9XAOouOpPIYvgXYBK0Xv65p3K0=;
 b=5XkTdq3N2XGqgMLfy65UGbovi8wThCf1OhK2p3M89xXvnTmO/hRQNDs1NU+gdq2uzLZO9C9BO
 laUnaCvsYZCATe6H8kHpDgAZSU5TxOL+f0VbJZHTFkICzz6VO6ioq6C
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 30A3710000B
X-Stat-Signature: enrzkqk655g38supug8i6u6csp4tdjkw
X-HE-Tag: 1777291450-570861
X-HE-Meta: U2FsdGVkX1+rZpmhrw4by84Ou6NprQwTRL4giQfcCN68o5NbZLZdm3dPrm601XsWjERdapAW4qNfJv+PyAhUQFhftrvsFZnhIMGE06q733f96tYZTYJmRPbf8C4+5rlZCygnxR7y9I91+i+YaQxq45wRkH4S+XWBDGv9TvIBsR1+2IYL7c4AxNK8iBjBDDRQGczdYfiocAQkbVaPK+W8xDmYH5xov8nMk3V0gVh/rxsEv21A0OcwPvYLHM86JgzXn+aWtrSE6+s8IdytsU9v0bllkmuIIZ8+c2RXGG1TWf4TweEjXhGb9krmLLSMbfT/1+90ueBwN8Lf36nIUqOtXG3+RiWzO3Vyhe/veQTQOaSW7MdVRxfCujfO+HTXA7PQYE0W9HHizWkBUChOQUqPUayFyHJ3PthkP9PVrlk1FYCGuPfK0bHzlXWCzv7FJKTcXzbjmP1x6BnpWvapQgPLrxU2VDLbhJkmLAJoYRG716J0UhTmFzR/K3WxvvajK0IpWNQIevKE7/9DaAm4dVuuP32S/iimK3WS9Ifq64jnmiOmzZErrZqK1WVWrUS3zD0TNrntMphrDcppl04ulL9gAj99U1h/V89OjCFBd91k19t/iChoC1B5fSsOMUVRFOcmRzd8wTQAPMFWOxF/R4R/mCY15R3sCny8fv2HP/lMErufxZH3reXf5mwlViLVI+FnIlZpt++TxJyU0BhMPUO8QN+PRUfZ50YJb4AvuZVjrv2IP/LGW6R8kvSZysCExE0WTPB+/d9snBGklIF13HeHPdmctEG6PJ4eloDRYmwB+HIZICivHJveBOjrWbavBqFExVhDIaVnVhuJa2GxLiUsdw4Hp5A4omWXHHHoCNZ19zqQEImbH0c/fI2jfSmdVBCX+JAiYP/t2W3h6Ui2CWgEy7jpMX6cN2Vn8G5iSa1Lg5YVho3acfkHjm+vG1B3vf5Jg14PwZWVMcLQsxB29++
 st2rgxeF
 SmYEzVXay44uQNYwiNVPvYoc5yL22+NH4pGcJu6cWkLFR9NS0BQnKe8lryI1ZhE7m7cNa0nKsfzobqnkXQQtFGtTBvcZetIcHVoOJ1Dpz8OppPxLA07uvpN/uqjR/o+Lw5gbUDzAjRmOqDvAuOmSP/RMfUj2TK0s4C7fY/2GppXX5wjOQt1s+F2puxThrGLICpVZSeSk7mvRGfZeDrCk1EERFL9G4HzbVY2B98RxG/1qx5R6vaLQBIZt6YzOo9x4Xf9RY4gv1HmUf1gn6V6UiPVl0ftJ1953v38vYpYYS0Z3/wZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

POR_EL0 is expected to be:
- Saved in the poe_context record
- Reset to POR_EL0_INIT when invoking the signal handler
- Restored from poe_context when returning from the signal handler

Add a new test, poe_restore, to check that the save/reset/restore
mechanism is working as intended. See commit 2e8a1acea859 ("arm64:
signal: Improve POR_EL0 handling to avoid uaccess failures") for
more details.

This commit did not handle the case where poe_context is missing
correctly. This was recently fixed; add a new test,
poe_missing_poe_context, to check this case.

Note: td->pass is only set to true at the very end, as an unexpected
signal may occur in case of failure (especially in
poe_missing_poe_context if POR_EL0 is restored to an invalid value).
Failures are tracked with a global, failed_check.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 .../signal/testcases/poe_missing_poe_context.c     | 73 ++++++++++++++++++++++
 .../selftests/arm64/signal/testcases/poe_restore.c | 64 +++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/testcases/poe_missing_poe_context.c b/tools/testing/selftests/arm64/signal/testcases/poe_missing_poe_context.c
new file mode 100644
index 000000000000..3f22d8cf6106
--- /dev/null
+++ b/tools/testing/selftests/arm64/signal/testcases/poe_missing_poe_context.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Arm Ltd
+ *
+ * Verify that the POR_EL0 register is left untouched on sigreturn if the
+ * POE frame record is missing.
+ */
+
+#include <asm/sigcontext.h>
+
+#include "test_signals_utils.h"
+#include "testcases.h"
+
+#define POR_EL0_INIT	0x07ul
+#define POR_EL0_CUSTOM	0x77ul
+
+static bool failed_check;
+
+static bool modify_por_el0(struct tdescr *td)
+{
+	set_por_el0(POR_EL0_CUSTOM);
+
+	return true;
+}
+
+static int signal_remove_poe_context(struct tdescr *td, siginfo_t *si,
+				      ucontext_t *uc)
+{
+	struct _aarch64_ctx *ctx = GET_UC_RESV_HEAD(uc);
+	size_t resv_size = GET_UCP_RESV_SIZE(uc);
+	struct _aarch64_ctx *poe_ctx_head;
+
+	poe_ctx_head = get_header(ctx, POE_MAGIC, resv_size, NULL);
+	if (!poe_ctx_head) {
+		fprintf(stderr, "Missing poe_context record\n");
+		failed_check = true;
+		return 0;
+	}
+
+	/*
+	 * Actually removing the record would require moving down the next
+	 * records. An easier option is to turn it into an ESR record, which is
+	 * ignored by sigreturn().
+	 */
+	poe_ctx_head->magic = ESR_MAGIC;
+
+	return 0;
+}
+
+static void check_por_el0_preserved(struct tdescr *td)
+{
+	uint64_t por_el0 = get_por_el0();
+
+	if (por_el0 == POR_EL0_INIT) {
+		fprintf(stderr, "POR_EL0 preserved\n");
+	} else {
+		fprintf(stderr, "POR_EL0 unexpectedly set to %lx\n", por_el0);
+		failed_check = true;
+	}
+
+	td->pass = !failed_check;
+}
+
+struct tdescr tde = {
+	.name = "POR_EL0 missing poe_context",
+	.descr = "Remove poe_context record and check POR_EL0 is preserved",
+	.feats_required = FEAT_POE,
+	.timeout = 3,
+	.sig_trig = SIGUSR1,
+	.init = modify_por_el0,
+	.run = signal_remove_poe_context,
+	.check_result = check_por_el0_preserved,
+};
diff --git a/tools/testing/selftests/arm64/signal/testcases/poe_restore.c b/tools/testing/selftests/arm64/signal/testcases/poe_restore.c
new file mode 100644
index 000000000000..9f9a61a4214d
--- /dev/null
+++ b/tools/testing/selftests/arm64/signal/testcases/poe_restore.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Arm Ltd
+ *
+ * Verify that the POR_EL0 register is saved and restored as expected on signal
+ * entry/return.
+ */
+
+#include <asm/sigcontext.h>
+
+#include "test_signals_utils.h"
+#include "testcases.h"
+
+#define POR_EL0_INIT	0x07ul
+#define POR_EL0_CUSTOM	0x77ul
+
+static bool failed_check;
+
+static bool modify_por_el0(struct tdescr *td)
+{
+	set_por_el0(POR_EL0_CUSTOM);
+
+	return true;
+}
+
+static int signal_check_por_el0_reset(struct tdescr *td, siginfo_t *si,
+				      ucontext_t *uc)
+{
+	uint64_t signal_por_el0 = get_por_el0();
+
+	if (signal_por_el0 != POR_EL0_INIT) {
+		fprintf(stderr, "POR_EL0 is %lx in signal handler (expected %lx)\n",
+			signal_por_el0, POR_EL0_INIT);
+		failed_check = true;
+	}
+
+	return 0;
+}
+
+static void check_por_el0_restored(struct tdescr *td)
+{
+	uint64_t por_el0 = get_por_el0();
+
+	if (por_el0 == POR_EL0_CUSTOM) {
+		fprintf(stderr, "POR_EL0 restored\n");
+	} else {
+		fprintf(stderr, "POR_EL0 was %lx but is now %lx\n",
+			POR_EL0_CUSTOM, por_el0);
+		failed_check = true;
+	}
+
+	td->pass = !failed_check;
+}
+
+struct tdescr tde = {
+	.name = "POR_EL0 restore",
+	.descr = "Validate that POR_EL0 is saved/restored on signal entry/return",
+	.feats_required = FEAT_POE,
+	.timeout = 3,
+	.sig_trig = SIGUSR1,
+	.init = modify_por_el0,
+	.run = signal_check_por_el0_reset,
+	.check_result = check_por_el0_restored,
+};

-- 
2.51.2


