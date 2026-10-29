Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F65606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DlimMrOb
Received: by kanga.kvack.org (Postfix)
	id 33E316B061F; Thu, 29 Oct 2026 13:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF256B0620; Thu, 29 Oct 2026 13:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B6F6B0621; Thu, 29 Oct 2026 13:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00E796B061F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:30:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9229C1A04E8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:48 +0000 (UTC)
X-FDA: 85376353776.26.556A686
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf27.hostedemail.com (Postfix) with ESMTP id 96A1B40015
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DlimMrOb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMDApzLIDOAKE5Gyc0kBJeDtiPqWtLZVQgfI5VI22BQ=;
	b=VT2nnyitSAsDahX1cy6zzlmldir8lKoTKK1llhsPPRIAB2oRRlmUS4lXqlzi7YKvm554ox
	j/0Wr82Isk/WrajKfmJ9WKxyFDHipXRy1HpaCwRpOmqt5KNhOFEBEW3vZM+9rHtCJVZX4r
	6a8dwYogUkEmMlQ79pjYNjC67FdTmfs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DlimMrOb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295046;
	b=yry9YmGrdB4TVwuyHLtlbjkG1cN7eAslS3vVoULQwrLWHCbrwIe+dw7qAmQDjoM8SwAXM+
	SrzyC9v4vKhOAYQo0fC+w+lSKmu5iiDYyODc+nzDxACYBsp+9C0/SvVEJ9oTzD/z+pdeas
	fD0PEcd+GK4jzIfcItFv5v4IKefXzuo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LXdJ2wzcp0hoHVE9cbEq+7Hky76xZdetmi2maoCyhPM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295045; v=1; x=1793899845;
 b=DlimMrObNqkXb5rzzvGt/o5MlLGzTCnpncP0VUWI1dg2+CfU41UO9p3lvJQnz69v18Cywvrp
 px/On5GsE4FyXiNd8EQRj6TXLEiLlr5Mtt1AVGx+tkk2prfJRp1trLFlgy55E+DuthYgyepjnDS
 Ho07kMcgRMyyjJwh4u4XbJzQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9eed6b1d4b951111;
	Thu, 29 Oct 2026 17:30:45 +0000
X-Mizu-Trace-ID: 9eed6b1d4b951111
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 3/8] kho: Include linux/mm.h in kho_block.c
Date: Fri, 30 Oct 2026 02:29:50 +0900
Message-ID: <20261029172956.20791-4-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96A1B40015
X-Rspam-User: 
X-Stat-Signature: 5bji57phgfr5wd9ybdxujh1a6mmcmw1q
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793295046-887535
X-HE-Meta: U2FsdGVkX19gO6VlTHsQ06fXpdnsE26sr+QH6cbIsejPdINa5lmdrmntNlgC16eQmNv5on9u+8QAdOPdni+hvpJT+LNdVw6zT9ayMOmILa82D+LMiaItOUN9ZWh9CXENtJhoEgQSyJSBOk6bGvYwiA+4ndUycoY6xL5JCndAapKQdut3ukPSmyr4d9dtd+ijYxytFIQ055VBi80rClFWiN4g3SWEEWnRPImLIdVL2+C3tHV1cPUcAlptUr0BNqROhhOf8FsY95GYlmQj8wSCmVQ+mQl9O0i/SEx1SuW4dgpzNHwis9vfv/1Ac3yffpiTrSNAT/YSLtbURDk4qniXhfrYoFCQSpr+ZGVmf1l0x7NnWM864MbmVFP+61qkXfQFGRCiYV3I17ki+iWfSGMAeaMlBGlrZohFDkFaqonD8K8ZX3WGOlbNCpQaRwfIV2XbLX2A9Cd5X0EAI7qWy87WmsvWhIAVr39OpLf0meWN3vl1K9aEhVFobx2PNh1lp5rUEUnH0wAWgXbfNy0C78w4MLO/9X9uk+1Va/udyMQyiQ5XxvpiUjFVsFn8zJ40VLzzm8SgcgMsId4UrCOMgsjygS+D9Xy6cI0TzccqEMB5AfWR0Topn2RCGubeJcOpbAvfyrB9ILWmS/ZU1lPKNx+rg8Nle+N7Ju3tbTYNGkM7xfoqxPopWW5HNNT8PdR/ShD7vhmGqMSWhuoqCDuNxSBWqCgzz2zATs/o6acWj42wzmYMyPwASVJpeGRwetfY+9K41292Lb+zc0Zms3bgML1W0u0CgDIWiMKxkujrJSpKxyg7uTPM5DVgddp29hAjr4TKvgNGGB8p2u3WNuMYD81IoMb7W+Oyjc4M54npCsS1lNrQSsAEF7j9pTPsWI1k809hMPKGvzIMJyTlepK6A/c4u4tCsrJAk7FVEeaWV0gI1fmjjPxxwBowwlNYl/yGonYad60fr0b0Pb0t+t6Vuvu
 bcpD89AA
 SjQu/HFVGsoQi2nDXeYwyB1Nsih3SGOxtYUwyznIXRdjW3kcLIzpJWHDn4mmnKtKrDdNDf9ZRQLEklza4JYDknfK5Fnzn/MWx6oS5q/nXJpUlitSFrjmwBZXDGnlAo525w3hRTpE5kunSGv7hoCmirE5LnYDuv5RDPtJrz27MDGnwE4d1mQgfYdBK+7qx3KT6ojYnWNUe8rJm/ugX5xC1sOvsN791nI7270YREA5bJVDH9RbbVp95fWRdWcbg9ZbaeCXRQvk6wL6uMB6Rg0+nl3dNVqYcOpD4GuIJU7srdrfLf/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

kho_block.c calls virt_to_phys() and phys_to_virt(). With CONFIG_KFENCE=y,
the LoongArch implementations use offset_in_page() and page_address(),
which are provided by <linux/mm.h>.

Include <linux/mm.h> explicitly to avoid implicit-declaration build
errors for these helpers.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 kernel/liveupdate/kho_block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..0d56891b2f4c 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -25,6 +25,7 @@
 #include <linux/kho/abi/block.h>
 #include <linux/kho_block.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 
 /*
  * Safeguard limit for the number of serialization blocks. This is used to
-- 
2.53.0


