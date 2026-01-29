Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAAEDD46C1E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 03:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B491D6B0088; Wed, 28 Jan 2026 22:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCB66B0089; Wed, 28 Jan 2026 22:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D89F6B008A; Wed, 28 Jan 2026 22:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8216B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:50:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B1AD16072C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:50:31 +0000 (UTC)
X-FDA: 84383624262.04.489C8C0
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 53CC14000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:50:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lw9Keiwv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769658629; a=rsa-sha256;
	cv=none;
	b=3/cQNOa+RZSQOBPfOfnPNrYnPhyNs1P3WMFRl5LwLpfsNTqFlyA+FHyCPLaI5/iTX0+CqM
	Dy0qZOa3QwD3NoYtUc+lyW0/zu36MGkIqVG+Mzwy1Wr9/Y8z4B6IAfyoORTlQ00XSXjHEN
	3YTCAAB+M4GZcwuQyQZKYrkl3chMaeQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lw9Keiwv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769658629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2/Qs/X84F7xqVULHI40NbrGxxf+fCcySI+HtrrKnXho=;
	b=uhVfc5oFhApcFy7/tHG4Xift+f1GIflv3IlM2QQQiaJd8Yn1j/o85cSqxj4R94utYmjk8O
	mnmr8Snbb93XXBfkBHluZ61T9FIae8+9zXHI61TF0ImHJ9hw61JsUWV0SxMUiifNoNX1Oc
	jmMZBy5F1dMn+EvK03im7HDvgwSCT6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769658626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2/Qs/X84F7xqVULHI40NbrGxxf+fCcySI+HtrrKnXho=;
	b=Lw9KeiwvPevGSEmicxuywrMDbeZB6Yw++8Iw2z7hTXv4HRbKT++i7fd0qktNzEVrD+p4zE
	T8dLoJOHcK9Bsy7Fy1UvhXDOBhAWzFI4AVUixU9uC6J8l5nj4GC/VhPejGAfEFkDpNi/NT
	MzgzM3e9ipworgrbd49lOyKRFcQqneM=
From: Hui Zhu <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next] mm/bpf_memcontrol: Add missing newline in pr_warn message
Date: Thu, 29 Jan 2026 11:50:14 +0800
Message-ID: <20260129035014.3283392-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53CC14000C
X-Stat-Signature: ssbcupeu5xjrb9wbh11y1untr8xyxztr
X-HE-Tag: 1769658629-398767
X-HE-Meta: U2FsdGVkX19ozabJ41XImnX/qj3qtcQReoAZmVd/a+M56sAbAXT56iPlNKvGHSfSa4VztWOfQupWZiXYAfDTKWPJaUdmwnyScgwvn1TQz8q/vPfsdd+LhYFCDKL1LxGPGh9l7a3uVhdNwiLjqFDI1qW0cK210ICWAUux1Pa2/oyBhoFyj7QchKinkKhDcHr24K2AkKWKVV65FjTtaTUr1sAV8rEKrlX+4QTxpUIY1qfkIMues1JeKll+0u9ocODdw+exhq/xYWKl3/TChxqXPrYWJKiqHdEmbPLtl8xjZn5+CElU9I2et3A54/IpeeC4noaXSfeObABcEoApp5igii+qPz5y+5+v+skh9kK2Kg8U0Bj/9Zg+kSX1dVp643yr1+hza9NbsSrUKdjyphKMVYZjdZTcFmbIP8UVvqlI9nDEj4WGRC953Y74RPQ2FY/eVz/k7QTHErkpqLLuQF4H0O3hSL2PFbJwulvt3GD3MxhfO0ilM034FmPexefJfWzhjjvPWsV89I2S7e9SV71il3k9xDnWgrttHEBA0jk+KZanrHgWo+wOPGndkAX3FSxGM0mfnPeySZuu/cGR3aWb5XCRvlfmMV5BMvng5t1kub0U1VR3PzI8ZLtR+L/Mm56Yi5owdVfFFEKo8kXR+3bMpwLTv7tupMRzeDKNQfLpGuHdqMtbl8v1n5D3QnfnB+jzldIkrziTbfZKgPzZFaLqpZyI6q1A56O+uzMuql4wiHDb/0nlfJNKdgUS/9X9dG3VC1aH2FJdgAon8QtMm3sCohWvTX3x5V0au4oPjrvndAer5Ml/sjRryTMjmbrAJMH+3duZJ9u5AyZZbodk9m7A0yvGnk6TvNRzO8oZHGup5a7L1QQhoICtm8w2YRvGamW/mHTkHt4ftqe6fok3OifXRs36EWr9LJzx4N7vEJhXPz3H2U0KMUMKKNt8M10wiNzcfARzD7wI42JcryctX+N
 +Izo1WEQ
 BIGZrCuZHfxVYEgMNBynKHr99pNIwS/M8ros6d+EeNc8aNYuDoi3WnW37zaHTE2s1I1h3ZRRag6iOKpOsAjvdEf5PmvDr+r0Gwuy/XAQd84Act25zBBqqmI8UwxY5zXGKg0OLHo0VaT/aQKNVRK0rDP6+czmW3S/5o2raFak08ISzRy+Vn3Gv+azgEp4vCWFCG91ccq5ClNoru9eroLSkQD3Gz6Y4go4oSf/wBwszwAIGrGxixYQ5+Pd3gQpIp0IGahVAR+IpbHY5B2E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add missing newline character at the end of pr_warn error message
in bpf_memcontrol_init() function. Kernel log messages should end
with a newline character for proper formatting in kernel logs.

This issue was pointed out in
https://github.com/kernel-patches/bpf/pull/10864#discussion_r2735018210

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..20999a29820b 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -186,7 +186,8 @@ static int __init bpf_memcontrol_init(void)
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
 					&bpf_memcontrol_kfunc_set);
 	if (err)
-		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
+		pr_warn("error while registering bpf memcontrol kfuncs: %d\n",
+			err);
 
 	return err;
 }
-- 
2.43.0


