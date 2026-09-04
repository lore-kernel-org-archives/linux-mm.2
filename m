Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20386C79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8324C6B0096; Fri,  4 Sep 2026 06:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1F36B0098; Fri,  4 Sep 2026 06:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E8B6B0099; Fri,  4 Sep 2026 06:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 516766B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:10:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B13EC160457
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:36 +0000 (UTC)
X-FDA: 85175660472.01.1B4D9EC
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf13.hostedemail.com (Postfix) with ESMTP id D333D20002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OMDA5LLr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788516635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CceRez2/ldfpLjVhVSMoZAznwntxXxH+q+GNhQlA/r0=;
	b=iZUoKLMkT4S1UBe93C2+WZ0i4LAxQ7I8hqlqpSeESmvgWMKjvirmTIhjTgjcZSC6K3OZP7
	jqWzEpfnzgjHehDrG0dpQ3x92WZY5y5y7KFz2qYS1lSbgSlmYCyIJRv2HgKLa1yna5ppn8
	E+LQguYUEgXZp4H6Kp+w5aEA8wd3NA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788516635;
	b=bIyvB8QP/z4m9gSjFNLWiQwoqSImcI5feiEI+4vMzq73m1+a3eIU7Cb5ffDSkFXmlznJSR
	Xce9JMrvaK+X09xywBfcgN2VuAUNVtIj9Rs29wiqcuii1XKCbwmysv0QTSBaF897ziJh6Z
	fjMe9QYTDELZbdoKvjXiAn9MkIzkclo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OMDA5LLr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9aOZu5joPDLJyi4gz7dO0f9aMIY13LvVV/UJCIG+uIA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516633; v=1; x=1789121433;
 b=OMDA5LLrG8KDrfPVcchlsXbhmMDk865MrwFysRUs9ECTzubH+1uug4zwb1SxLQgRgJp9sDPU
 pfj7iDyCFWimdOIUFY3t2hkpZQ+W6CkKvuoIsdKvaRe8pZJdifYCaEboSCRwYEXnZxlVV+TDQUq
 IZXhR/Swxia4qtJDty0ZJ7oE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 94f18b2629cbbf22;
	Fri, 04 Sep 2026 10:10:33 +0000
X-Mizu-Trace-ID: 94f18b2629cbbf22
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
Subject: [PATCH v5 3/5] liveupdate: kho_block: include linux/mm.h for virt/phys translation
Date: Fri,  4 Sep 2026 18:08:50 +0800
Message-ID: <20260904100852.26006-4-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D333D20002
X-Stat-Signature: i34ricg4wpsjewq8eq6fnegmzrdwenbs
X-Rspam-User: 
X-HE-Tag: 1788516634-587890
X-HE-Meta: U2FsdGVkX1/n60Az9DqE/XVmrXBAMhUXJiCpjK/CKnEP22Pdj+J6NCDfmDqLlQf6+w/+B53elQfvjpWSDAi1Ny6tSzRTinKblBhoNxdadK0s8qlAIU9sR8p4tLyTjMDPJiWljDj5FPkqAX6Ix1QhMR5Rkca9aawTMlvIyv4ydfB6HMLgHvLST0RTYC7cIifhg+ODqX+LbP0jP5xaOOWfG+GSzCSg9WCoKqcEOh/zle8QUumrXp/Z6QIpAlwVJ7HTawnMvfQqCxBWZjyUUtekSGh3h1GKhvHDodbG4iOYNrMdaH/nIhKxYFIdgFQBauN2aj/OEUaREtOpecdtWx9SMc/cxSk1JzcMGJjyeI5zyNLb7uA2nd+8p2eiKw03Pvh3GysKzHBN+gKA8DyomuAU83Plj/kuGMsoetR++pV9eBAuE0ufbjAf6v2V5FlyAWjs5M+Qo4Qxu583pX+rDIpr0v3K85XHkeleYt6i+5E4OJfjSyAy4c+dixXJ4mT3I2UjWpWpycZapoMPK5Pc//TixlqWNqfiPxlpu6W41STXsGEA1MwOsm7cB/w6D9+eWqmpZqBgJibcVddwtONB1YLnyhKRx4o3+5anvDCSrFrpytLFpD5nyoFWx3vUTb8JMkA9DMtCnGrrAEKqzvEIvys+ELO4CADuchgdpI26vE9pR1LsRmR+THkakI1xA5IaW9enPJdmzzfwM3UJTRgJjGLN2dQkQZMpw9p74zbmYeDiljN4YoqVZvoY6ghLzzV5azrHS9ZXlHFDAgquhJplUSBdPvY2f1bNSCP5JcZzAHKgmRw5MmkcIfLqmHLJS9jX1kz5AhOjs9XVPYtV1Sf4luSxahsv/MfPevErneUQPhERStXeDqUpzbXO5oHs8vCR7NRWRUXgGZd20wcKeIhv57pLs51YCSDwtKpWSct+ZQn2Yc+PLN8WFSJ3ZkfPHVZYnOrjOpWfQdXo0h3LHNIM3D7
 B/SGChN2
 pfzqtVvrsQRstqOJgNR0poekKAmqEC4iZRM3B+5BQ78017IFjCCMOFfEvRlXgUG6ULgQx54SgUOZAToFrSS5OxGqPcjFoP8z4te85UTeldwC7mYFR4+e1rjPqnP1KSZhj4ZrlQu9lW5HliGdMopujtLG0/E2IyrL6rF8Jo/zfbiykxLi4uTJUhmlNxgdcgHND2/nahAqIn+umXNnhC65VsBGvDzd3rCrGBqANgdwYgV0CRJ+VCC1NSAVst7mMJEiJr0V5ZHEmwB0C3kiN3Ws+6TY7qizNxnnuXXU8awF1iKsu9P8LUQho3j2to4Uu27mvUzvtcVq3IvIUwAo8E6aSP/rJXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

kho_block.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
CONFIG_KFENCE=y, these macros (in arch/loongarch/include/asm/io.h) expand
to offset_in_page() and page_address(), both declared in <linux/mm.h>.

Since kho_block.c does not include <linux/mm.h>, the translation unit
fails to build with CONFIG_KFENCE=y:

  asm/io.h: error: implicit declaration of function 'offset_in_page'
  asm/io.h: error: implicit declaration of function 'page_address'

Add the missing include to fix these build errors.

This is the same root cause as the luo_session.c build fix previously
acked by Mike Rapoport [1]; the virt_to_phys()/phys_to_virt() calls have
since been refactored from luo_session.c into kho_block.c, so the fix
moves with it.

[1] https://lore.kernel.org/r/ai5nYlbERQBXRHSp@kernel.org/

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


