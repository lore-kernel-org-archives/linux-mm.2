Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FD6C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68AC46B009F; Fri, 18 Sep 2026 06:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDAB6B00A0; Fri, 18 Sep 2026 06:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC906B00A1; Fri, 18 Sep 2026 06:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 225E36B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FE72A0621
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:30 +0000 (UTC)
X-FDA: 85226448300.27.E23A677
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7254C4000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h20MzYgr;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h20MzYgr;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725868;
	b=HTsFJcJoWR3y1WSg5zPwiArUDFop0nHPvPxdYCupZrksusPHfJ+jV8FVuNjB07zwgLs+kx
	ZmtoMDxWCpXJd9VcpHqCpXpgWA+7YtQ9fpupPet6OT2/12ba9TzypNWdNbOnIJGLfhJcBH
	xz9js7hAmtXAtY2NCvqQ8V6ZnKw0sEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20ZJiQbk77XpGyt2zLlFzhTV8L6cgd0AT+Mg72ZNP+o=;
	b=6F2rKyeWJPPssD4FpKBb5hQR+RGu6mfipd410GjoZnhUtUwVV6LnE7Fz/CFU5w4aJigCl7
	AAZO/RGtwGfIey9lErFgBaJvGyN6vUphv+v3Qgdm9Dv9urW6eoUBsSlA65B2AoVoq6FiKW
	UeErailSrSjaYqI1K6DWPksqCAVv5qQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=20ZJiQbk77XpGyt2zLlFzhTV8L6cgd0AT+Mg72ZNP+o=;
	b=h20MzYgrtfLEEV4IsF22m8M0aeU+9fIDiLpJWraCVTgEvlTBvhYu0irkyY7dZ8KlR25j3eFDX
	uDHiuEi34Vyc2FyCL6c39JSfjX+M3Cz00j/vkUz1PTc66H//7kIYPJQEJrTEE3IZKzXvZCqcFXg
	laCNtc/NvKopW2lnm4CTtD4=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hmScJ5pDBzmVWf;
	Fri, 18 Sep 2026 17:53:20 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id DC0BB40586;
	Fri, 18 Sep 2026 18:04:20 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:19 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 08/17] LoongArch: kexec_file: Fix a modified_cmdline leak
Date: Fri, 18 Sep 2026 18:04:33 +0800
Message-ID: <20260918100442.3841135-9-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Queue-Id: 7254C4000D
X-Stat-Signature: 7kbgtsq93js1m71ieohytppre5aspou8
X-Rspamd-Server: rspam01
X-HE-Tag: 1789725867-208620
X-HE-Meta: U2FsdGVkX18XlCQCmAT4gdLA1dvVa2346OK1b22uFYHGy7ws4sY6/K+z9g6q/ZPaPbS3OwuP0wHf3rM2lXr6EUtWaNHLmGeEbpMvgdV+4WLeEjtaTlM9XPMAvchT5HtWfG61sg3IvPD1v6Mez3/1KQHkdc5F0xdGtszuo2ghTDxryTKuHg642zN4+hiSul3yFo8zCfhhmC6lIzCa1Kp/4OOBRWaYY+3S7vEJlCVmz4FNoj60rd/KTqlCSQhqED6l2H2YOWHkvOYQGsyubxcCVJ5TSBLxR1/Q2rU7sIVat1NIWKAxwSYBGMVLAfob8aDPyaSXHYuI6a5yw6MkCDM6m5IXZIy1uKnSbEpOKjXFuz0gYMoaiO6GrgYfxWN4Guy4SaQiBgrjSRph5nv6yLI3tF3fBmEui1ji0EGx5SO99J99ItkefW2OZsJgEdJ6DsoGSLJPjQS5ANG8EY/j6A4bNwIMCh1qceMGji9e5RhprHAoFuypbKDTcZoTWsgaSi/mP5VzZJuDzpUID8c2ClW8am0plGsusEA1oEVuCEsOMFnBKMsR4xM6N7ric4phu1FxUtjWS2X3L0KfjsJkkzIIwhiv7K0hZD0kJZJXQAUnOM1HC2lsUTEMlcXcVDVXuAmosMIJqQi4a8itSYAtxJzUVw/ns/dq9O5s0TLOJKaovrIW+UEXrIzLMUPrzLE7z6KFTk67/FxVJtvUmqgbCKVbVYx/8rQeGCDvFEIvxteHaYrMLJFEj8r0OeZpJb5n5+L0didgGJ7YIE2H6tpTByyZ3NX+t4olMP9kn0Y+kimAP5+3LXmHoHxHM3/b1KPGUCSTb7JRCeOrQ6/8FLlX3yKVYTcSkK+Nx3y2Ge63K4z8pVJMChVAe7X8bNjTxbDjfFH/8rtQ8Dk6kFAo2LvFE7/MYIMZ3dfqUPdOAtUhdnQcc9ACs4gmRC8wm/DN7GndMZ5JG7gUB435Ss742me9aWe
 ZhicNvF2
 DmZH/uCeyajCMQtw670hBXG3k0L60eCll7hgzFtol1CKG6oZ290/DI+JMcpt9dBTwr0ND+tLbJ9Euhc7loG4t5phVza+4j9y75y2iMK71h/ipVHr9RG7vXx5sOHB/XL67tcD8o91oFsMcUk6wTY79VMeJ/OatmpkFsYvwoaXA//T85LfvdbCutDzLjrtITEM4Jy1hM6jQOUbPah4T7RlphxaGWK/OQML1yPuHTD3kEgQ7v3p4es5R+iDUjELBJ0yDOp2lBDi/u4NmbILGCinb20rqzeVvld0utiBT9TY20xzzGRJx/Axgyk3gxsvei4luRbTMqoMAnvkyYax3zVHqFZTUOFNpziWCGIrJPpJ+lLKkOLKtyI2teT7UH1SkMOZGt78fzV1Xmecr+6obqPYoAZWgAoue6C4Zga/a1GTtdrKFA/CPMsMA0BfOiXER5XUc56IEe1m5h9rBhLua+3ueJtPDuUJ3Egw2RdTpvbPbPrCoQwjlatw88vhYUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

load_other_segments() allocates modified_cmdline and stores it in
image->arch.cmdline_ptr.  machine_kexec_prepare() then copies it to
KEXEC_CMDLINE_ADDR and overwrites the pointer, so the heap buffer is
leaked on every successful kexec_file_load().

Free the buffer after the copy.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Kexin Liu <liukexin@kylinos.cn>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Qiang Ma <maqianga@uniontech.com>
Cc: Tianyang Zhang <zhangtianyang@loongson.cn>
Cc: George Guo <guodongtai@kylinos.cn>
Cc: stable@vger.kernel.org
Fixes: d162feec6b6e ("LoongArch: Add preparatory infrastructure for kexec_file")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/loongarch/kernel/machine_kexec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index 1883cae93bc3..19ccc91b6f2a 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/of_fdt.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 
@@ -56,6 +57,7 @@ int machine_kexec_prepare(struct kimage *kimage)
 		 */
 		memcpy((void *)KEXEC_CMDLINE_ADDR, (void *)kimage->arch.cmdline_ptr,
 					strlen((char *)kimage->arch.cmdline_ptr) + 1);
+		kfree((void *)kimage->arch.cmdline_ptr);
 		kimage->arch.cmdline_ptr = (unsigned long)KEXEC_CMDLINE_ADDR;
 	} else {
 		/* Find the command line */
-- 
2.34.1


