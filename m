Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FD4C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27EEB6B00F3; Wed, 26 Aug 2026 05:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2567E6B00F4; Wed, 26 Aug 2026 05:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FB36B00F5; Wed, 26 Aug 2026 05:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D98256B00F3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 722C0A02F5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:44 +0000 (UTC)
X-FDA: 85142888208.26.61DEF11
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf04.hostedemail.com (Postfix) with ESMTP id 219A340005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="4/tAT6Kh";
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsSkMIhsameVeQcyubflsAKjqyDPzlK/Dltq516R/Cc=;
	b=RId5mX5d/vgwZkP7rufyVeYRcY9wopEJTp6+nQ6YFmHC5zZ95/RlucaBhDsGxOtyyqVsCE
	PRdiUT8Y/WoaV1pwGqmvrS6fjcsJJMjaq8VhcpQBqTXp9kRQK4rmlyJP796G7p/b2xz8NF
	06Vq/RZ1Gd8dhoB8s2Nx2c2sInL1T5Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="4/tAT6Kh";
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736342;
	b=RApjOGPyX0wqBd1qhGsr26/1SbVTSNiCRLiUYavgawRvymDP4kzHrjsWGVQnsNsxdRqUkB
	XX0wf4hNWkVA4xv/pW+2W72SIWT6dLJkSpXF7iXBYLeHbu995XavITN+Es+eSZunZC12Gj
	zUAMCPs+lE6bf2J9q2knKjNR9VBm8FY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OsSkMIhsameVeQcyubflsAKjqyDPzlK/Dltq516R/Cc=;
	b=4/tAT6KhStANNCVtYQC+DB5wYYXDiC3tT34fBpKlCqPTh2I1YSkgN/f/nRnKQCczgulZrLa5x
	SMtVukw+4IMcbUBzz4us12yj4rcnLybfHqc3ah2t+jgK2r5itK8c4c82rj9Gk9VcSKgK+3/ji5n
	r0Yl4uQkkWaI+TBCQprUFWY=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrX05jqz1prQB;
	Wed, 26 Aug 2026 17:14:52 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 8733E4056D;
	Wed, 26 Aug 2026 17:25:39 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:37 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<thuth@redhat.com>, <gshan@redhat.com>, <jic23@kernel.org>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 13/17] crash: Improve elfcorehdr segment identification
Date: Wed, 26 Aug 2026 17:25:37 +0800
Message-ID: <20260826092541.3905933-14-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: i8u1mwe7kertmwwkifor19ia7nq3o4hg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 219A340005
X-Rspam-User: 
X-HE-Tag: 1787736341-54152
X-HE-Meta: U2FsdGVkX1/xgU2sKmDaYdYyDE0nkpYSwBPSyXs2S4jDWkqKJxaj++779IHNDLcpJggVl4xDLVUMRhhyYMCN8T6tCZFml5lnMq4ewd1R3A4RSsKG/sqQ0+DUTbt1SP0Rq6ObkML8wkMyXwNfI/UDmQtwrkC3cv2rI+XVJVLFE/TFMgTPKlFwcu6F9rt0Q5YHi/bJlS6CPRhkMstlUzzEA7vKQAOdkLnULi8Mj0Is98tVGjxa11Jnnb5BR7po5CmUhD/1uyuIsqwmltAN206TPDLeKWSWQBcHPpCNr5Umf8kqsBYRi2iqJMmhE60mndm0lGx/L6DOQoLRRJsVsYKE5Jx9yjL0tKN2vcMhp7WZBukyTAyEbFm4itfYrWxkz5ySSXinyoNP9WAnykb42SxzanvrQzWOOjFJPOBUwS8grflMSj5NLrcYOq/guh0M1aD8/GwDDC1mKFvmHE8G6oZ2zifqZtceDpUYvBE5C9HMYDP/Hy7D4MZ+hwq5lKBppDJ1uH8ShIRauwJf3OEuWW+imwmEWK7risrmjm/Q68o5EWq7/lTgia9QG/iqbLdWsQ/mwyvCoqHJ3gDXDBqHSpJgfKFYkv9ujNKZWmmW7vOX2/K9mhCZzC1+we5wdxRHqicVmUhowAV1bWQjwe8LUpTp+PT/lUeA6+IBUZhknIg87WTnlcyYKeELNE9FezYD21cPwalaV271kVqmz0CA4Tisury1uAMZlivlC+7jWYuzc1Z45637R6XfN8O5slV7nob33Gwkue3Wo6X+LYHJoARbmKrnh1mVctMbWN/OarEzAAlb3mtEZtCMTSR06MoEpW4Nc4EoCFnDWP8loT4wLF6ROTwRxMWgn+lCiNYviOavEmXgj2H/pNlPOKyZT0b4GlvvuB/ytpptJJa5XN46aAnz07uiZD1ADyVepVZ8JDvw2OQkOre763CduhLpgW203ZgckURTMAgBeDCcDHDz/aB
 GGg+YHDi
 X9WOUp+WqjsUNZMR3/LQy73YbMUHC36ymBG1lEQq9ap5blAQv8adMnsd6SSmuykkIyValMQOndrS8hU9fJrw72Etr9LVjqEENh+xe7SY+tkdbFyp9aT9YUO/lnMbpNvm2MCt2bJINmG5c8SSIelqgFtZILqCxRA2vkD/tHL2f/ct1V1Clx/CLmsjecHsxUJ8ISK58nhZoORfTBdcQkY+ajIp3lXNOD818uowzSXCj2ZOsupy3fp3Ndj2VlbEI22c7nkjX2GxOeg+P1KNPnXaRMnuz/CF0HMiJJ+KwbbaE6Skndlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only checking ELFMAG is insufficient, as other segments like the
kernel image or an ELF initrd may also start with \x7fELF, leading
to misidentification. This is especially problematic when elfcorehdr
is not the last segment, such as:

	kexec -d --t bzImage -p bzImage --initrd=/bin/true

Add an "e_type == ET_CORE" check to ensure the correct segment is
identified, and break early after finding it.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 kernel/crash_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index bd3f82b62751..0730c4ea8054 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -737,9 +737,14 @@ static void crash_handle_hotplug_event(unsigned int hp_action, unsigned int cpu,
 			mem = image->segment[n].mem;
 			ptr = kmap_local_page(pfn_to_page(mem >> PAGE_SHIFT));
 			if (ptr) {
+				Elf64_Ehdr *ehdr = (Elf64_Ehdr *)ptr;
+
 				/* The segment containing elfcorehdr */
-				if (memcmp(ptr, ELFMAG, SELFMAG) == 0)
+				if (memcmp(ptr, ELFMAG, SELFMAG) == 0 && ehdr->e_type == ET_CORE) {
 					image->elfcorehdr_index = (int)n;
+					kunmap_local(ptr);
+					break;
+				}
 				kunmap_local(ptr);
 			}
 		}
-- 
2.34.1


