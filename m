Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7FE0D232E4
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 05:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A236B0088; Fri,  9 Jan 2026 00:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37BF6B0089; Fri,  9 Jan 2026 00:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44D76B008A; Fri,  9 Jan 2026 00:59:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1A676B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:59:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D6CC1603B4
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:59:42 +0000 (UTC)
X-FDA: 84311373804.19.FBB08A8
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6FA13100006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:59:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g1Y3HnKo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3SplgaQgKCFEu16z21t7z77z4x.v75416DG-553Etv3.7Az@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3SplgaQgKCFEu16z21t7z77z4x.v75416DG-553Etv3.7Az@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767938380; a=rsa-sha256;
	cv=none;
	b=5R3x/tctgp+hqD+xcIj4v+9JOorW08zYh66eXJRZEn+H3JRTy5HzsCm3r7dsuHrMPJ5SA/
	XN8XWi0kEJYvvbsh+UR2ryMcvLwcigJORlu/YClFTQ4fXd32xpA/NvFCLQTn2xM+++US5x
	39xuip/XB0bxCQUdm2XQuL8MfpUVGzo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g1Y3HnKo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3SplgaQgKCFEu16z21t7z77z4x.v75416DG-553Etv3.7Az@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3SplgaQgKCFEu16z21t7z77z4x.v75416DG-553Etv3.7Az@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767938380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VJ52X8DJw4332ZGcvwO1T13NvF/pxnQEOtkap7ms7B8=;
	b=i9WdAE+5Z3bWtnLq8LwBL2rofFNZOfswduUTnlvnb8PlJLj+c+XbOe2cV8tEnosfJ9FUgu
	6J/E4wpazm8K0msoUw0g1ExrTxweqSvQz3TUQFtBa+3fPpkJmh2L2kU8K01MqNhFq0lqkr
	Y4J3GqchPtjm63lHOzpenyBk2Giqv5I=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12055b90b7bso2949180c88.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 21:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767938379; x=1768543179; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VJ52X8DJw4332ZGcvwO1T13NvF/pxnQEOtkap7ms7B8=;
        b=g1Y3HnKog3iSe0rOjJlEGdRVeoou3o1RDEIFbx+RULeYwTzwFtQPz4WE7O7kzJ9tKS
         KyYJuTyUmFpJXU/UVjUNCX7bIBSjj9hNW5T8LIRw3A/Nn+VO28Lss1Y5EoCnyAhNT2vc
         BLwGdVjktFtMee31hryFvmlSmNZnoIHzbxO8tjaW9bpvcWEUnON6Zwk7Qe2sUavnAKpz
         tMgcXSshzu+AYiTRWywP4sY/V49Pm2XeEWfAmNmJA/5zlMddoGygxj6nOIIkp+uZhxoG
         0CXs3LzPDAkJUt0rqD9sltHvPmRYkciVUeHSLPu1I6J+Z7txMXinK90ICNVgZx58LQLw
         5Rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767938379; x=1768543179;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VJ52X8DJw4332ZGcvwO1T13NvF/pxnQEOtkap7ms7B8=;
        b=G83pk9nCIR/W3rHYRrI0+2G+YKoPlk76ZUgTZZ7iKtsBgrKUK70o+2wG66cG8auMAI
         WcUt5gDZi384Lz2HlctgVlVAsrQusMSKorVpmaZHfS4M8bA4t9C2DlurTSBGS8+kjqHY
         YUV1TRvZtJGVvp4TLSa/twAKucU9H8wJxlIzWflShck9GVFCA96T1XgK7Ud/AH/HcR66
         mJ2lpQYCekTbCW+758rALLlGPP1+ZCyfUc6beui6Pf3k4E7Q/FMUZbr4iPvgmzFur6Od
         QK3ywZWbm+QEXgZFpNzzJNKJGuAyBPZrYBkerPYx2PfizS61KALF/DIKaMi75XbF8IgA
         bhlw==
X-Gm-Message-State: AOJu0Yy3fdesPh+6iy3NK0VY7baEjRLp0Q/NTssvtbMZQt37LvIgnoZ3
	e8Bfhr71CviXAJL3Xaiw9xNqvOWGEog/oqRhRfj/XbV6O/nO8mNgJU+bKUVvYPY7LdBb43LqSG5
	RTLb85Ce+erPJW8bvQkvqKPdfh7nOaWwlc8kJGslvw5li0Y6Avwdd3M98pI6AiL3vs5NOpW794P
	0xUgzui1awyhhg4gxOj0/QHdnPuZ/I0e9VBp0MHvgP0g==
X-Google-Smtp-Source: AGHT+IF0mQn4MseMrVOa8p8Zv/hsH//maZC0uffsHloMQe6o/1cJy2BKOd5wYY8oJTAqJA82ez4XIf9m13dkEQ==
X-Received: from dlbbo38.prod.google.com ([2002:a05:7022:43a6:b0:11b:65e:f6a])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:e08:b0:11b:4351:2687 with SMTP id a92af1059eb24-121f8ad0889mr8025015c88.17.1767938378896;
 Thu, 08 Jan 2026 21:59:38 -0800 (PST)
Date: Fri,  9 Jan 2026 05:59:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109055937.3739860-1-bingjiao@google.com>
Subject: [PATCH] mm/vmscan: fix uninitialized variable in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6FA13100006
X-Stat-Signature: e7p1c66bfaxm1srmkiw9rpj1poqj5y1r
X-Rspam-User: 
X-HE-Tag: 1767938380-713054
X-HE-Meta: U2FsdGVkX18a8/Y+DjHq/KyWwK62H3Bu9/GvTdvL6bhClsPP+oe89qss57HtKXpWm0z/c7nA+i55r1d2oH99X9FA5woa01zagerYqasUXBF3Rec5BPZw0knDZqFIzTDpRcHW7a9QoStBw7Kg1Bjn+9v44RqaEAuasBjPNukw5r29y5rmf0g7sG98GvpeBCSLlZr1onR8oJDOgZ87QQTuFtgS6bJ/TNL/efHwM2VMemATrq4tuE8WJM8ud7cVENpsyZbSR5AIMCbajjILtCAVvT+gcPxEW9+iQuKWjm+sj2O77ouAhENeIZUAlZvRdgfa1STgNnOOBsXC4xDD0Wk5qTFEoMSAz32kZqslXMbwCcHDCkJAT6w5pipgjIm6oz1phNVYZCIVhrMnt2lR70MqN2Xbo3iTue8lpkxZlLGiNdwEleyeiyT3aPtI3axY0kCLUawnzlIoYSs832rlT57ABaHrkTvUk907xAH/S76QZqp+2v1iw2BQmlZZrxAcL4pz7FDVXk9/pfL6vcEeNShrzrdooxiEBPJmyH9okoP0XPojA05pGTWW/4ogf7wVOy+K4NXTRLfzIDdc676m1P1Y4L+g7idkss0damNtJLJll6aBvtqeD4v+gzsl6Sv9RTXsDA/y6sW+bR4WPDly0oLncx/DuEEV6fJMJtyINbt7qxjirEKkHGj4VKimOKymI8yHj42ctsFqi9hZYC7DI8DL3sodWhvWkwleIaUAkUsJ4490EH9B1m40qZVygkJUzZLSMhdsgTxWcry7g5Ru9mykGaB92QVN70O9234ZuL51jC5GZsD4VB4R8fkv6Cdyy97258B05ns3nLOETsHvR4bMNLEnahbAK5VdR1Egpbbjeu4F27hDRwIEPz5g0EYVMU0XXppED8WsV8jDZuw/XS8LQSfJh15Re1B7gOjiTCVe7BMNklxNAzdUlU48tHBeNBgksg0vrfytG8a0qIMPyTc
 OfnirKSE
 u98lV6I5vG72qF61WHgTP+5vZc58Be36XRXR0OhrrUKsWUV45RfshNLv2O9Re8xcwKOwEsfYUGGUFu/fyKNqfeku0TqCxfTf+QiTKbXpnpv0n+LJnQ508Ny+tBgVtub9AXkPnRzDCBm+OZcNuI188bn5V2Czc5MLZcrLilTRz3COncA2aIR0h2ZtKK06Vq+uCVrcfS7xJ+KhQN3M4CaEzHGan+UcFnG893n7yJ0Mf1LEtDz0072g61RfAqlTJ+DvIQRKKdPhR+SThbNlmldsUSwECqRFYuad1XawNlgPNPIK8FqP1/hFx75SvQRJLu7uUE8W6q2JGXOP0F9dcr/n3JGqJ9oWCA+v2/NirRc80aXcp6FT0KqZP5pQB0CXLi/b89KloN9WA8jABsO8K02RzZz5hkP4QMftUVZWZobSRTGVePXFOthVogz9MJCcc1pNUK+q1h845g95RdBVEQu9XKyfXU1i5y+YaLuZg2fp5CZ05+JsuIeMrZjBW9m1gH3rLhT8mxOWq3Ae22P6z9HSmS83JJSfqbXUy+k1rNZqp2+yEbiTeZ3uwHI888LMoCJVUHIfw44gryO+vOlPYkcsSVq3lVvpuxn9qCRVGmJcbHdbDolu04lSCwxEz7+7Quq94PlIJDFOkPwaEKhEwoMx2+Dyfvp3Pc3rDo9boZNvNDD86yko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
demote_folio_list()") refactored the selection logic for demotion target
nodes. However, it removed the initial assignment of 'target_nid' while
leaving a premature check for 'NUMA_NO_NODE' in place.

Since 'target_nid' is now assigned further down in the function based on
preferred and allowed node masks, the initial check at line 1046 is
redundant.

Remove the redundant check to resolve the compiler warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
Fixes: d92027a5f30a6c ("mm/vmscan: select the closest preferred node in demote_folio_list()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 213ee75b3306..590ab3ec1998 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1044,10 +1044,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		/* No lower-tier nodes or nodes were hot-unplugged. */
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
 	if (nodes_empty(allowed_mask))
--
2.52.0.457.g6b5491de43-goog


