Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BA7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA9B6B00BB; Mon, 29 Jun 2026 19:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B27C6B00BD; Mon, 29 Jun 2026 19:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7E76B00BE; Mon, 29 Jun 2026 19:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6554D6B00BB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:30:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBA3D1402D4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:30:18 +0000 (UTC)
X-FDA: 84934546116.07.36F1F08
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1860640014
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:30:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E+pStYXj;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782775817;
	b=SVAAgz4H3HTHsNBWdd8fodcwHptx2Eubh2X8picqaDDoHCm7XRB4+DvLREQXaer143BVDg
	an3cwpcTZ7Vn+4mTIrNlATze0g9UAhlgNcif4+FPQngEEZpIeruLuTkLoD51jx7w/qx8a2
	jMEOhPdmRPfYMSScBj92cOvTYrPNHok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782775817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GFdypiSpH095gJ4CTwl0p3mqZVHOelsR9GAvKC1fb7c=;
	b=aLiBWms63J7qZOrVS66U0IA3ODdSn+9w6CwVUARYTDKP/pUrUZAT+oWCwTIG9B92+bTdW6
	crbkzkV+hO9XCfdMSd84mAGTvkLLDZrqlLpTW66WY5JU8GvDUOUC5ERVih8egJhKgpyJFJ
	PPlCyCQzAPQA17cGYsCnqGabhaAweJ8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E+pStYXj;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ca15944645so6038085ad.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782775816; x=1783380616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to;
        bh=GFdypiSpH095gJ4CTwl0p3mqZVHOelsR9GAvKC1fb7c=;
        b=E+pStYXjQTU0HUrE8dhQYLTR4vHhXiPZOTxdygb2agZI8iyKDb8LXpXoYniiAgeI1B
         RhqQWLWQ4louJEKbxRKzV8QQ4NhjIWmrGBYc+yjjEbFJj+W6PPSzGtnKFkPwZLPDQYyj
         c5O37ASewILahxDtvFOWwqYY95+NG0RYoz9QS1Yzq3Vv/5RXNCweORaPXakkMitvTpbS
         tUq0p6gQe9fmQR5T2XYCQlY/3dhFZ6KuJHSXQZRyThkps8GRN7UusC8SgcHpE2Om/c7C
         8a/V+t5l7PaOrbkL0XufOGq9ePNtJXb0wj0xpRisQQWNiESHtsJmLDiYMa5kI4LxBNQH
         5q8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782775816; x=1783380616;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GFdypiSpH095gJ4CTwl0p3mqZVHOelsR9GAvKC1fb7c=;
        b=SWH4YvIt4msQyoKanUkujlWAU9++n4cPAouMcdrm0H14Fxd31taRG1ZCW7fjQQ91gY
         xZ6dMZnTKO2AiVYyOCoe2JjQjchnhU/j4nyOv3QRAXMltSD8ULwOo3/6H3AewblF1dkH
         88FXJ4FQXIAJcDE4IKKuvKBwxLOnLQTrnjfECm2ANWJnUjzdMQ4u6HY74+wZOIAuREoF
         YS8JVD1lKLDDNBThgLp0UW5vtvKqM58nvxGupiFYZ1Xt47VWApLLqrELAh7nwrWzTU2X
         OHuINdwOfvTlrqhEkS72C555W1O0qB3c51p+ZJr/oewJtbeUg/nLTtLMdXLv+Y3ia4DW
         4CSg==
X-Forwarded-Encrypted: i=1; AHgh+RrnbHQUo5lPS9ul1hOtuECERRHlFGvEmexwTjzGZG6cnGFWVm79zRdPFW375VEAc1TTxIpHJYcDYA==@kvack.org
X-Gm-Message-State: AOJu0YxpIls2h5QM4DoTN3l7pftTYvrasjnYUmTaVsaZWel/nOziODKY
	F2yZo1mzjlMvrS//qjN5VsCdQmtQqmM3/uG8E52LgP64jCCJrazIzeWu
X-Gm-Gg: AfdE7ckRFTqWL/P8k3resb3utXH3VDeWx0hwwddNIXCBpBLrYdGMpa3BYOKd4EV9NUl
	8lMChZeXzVAaekRhMBcvV+U0wAtlNGa7c4/qrT0NJA4yCR73Rr4m0MSpPE7A/YdzN1s3k/cWF2J
	ArBKHC57JU+/QYkll//B541HMGt0MioiTxZ9uQg/hW7zUlIybGrqOHa3mSYfigcaarg5wgIDTsJ
	6Arl2qmG9AEBjlwZVhvdbhEw9kHr9Z7G7Jdf/e3JUy4sTlimRaNrZaXYUlePI7wdNa+htMzQdpL
	xkCJLW+vT/FlWmEY2NpGi5lExYHZYcf3XWcoeqUam3SU+4u7Y/UA9bbF8ccBkMRF89gxw9iv7uM
	wEAVsp35tJ79LWtqrrLWHkMhO2hes9jf7Mms5ESo9ZmvP/NKzIJ5mixIgm54Myd/j3mHhZrmCZ9
	cbyHZiU+OWVcUsQO/N4PoWGRmJDjeX8ch1olZgmUY70k6i0hN2vMNORUqlp/M=
X-Received: by 2002:a17:902:e548:b0:2c9:f0d2:3a11 with SMTP id d9443c01a7336-2ca2ed3193amr8812415ad.31.1782775815794;
        Mon, 29 Jun 2026 16:30:15 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca3828c6d2sm1366065ad.39.2026.06.29.16.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 16:30:15 -0700 (PDT)
Subject: [PATCH] lib: test_hmm: use device devt for coherent device range
 selection
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: akpm@linux-foundation.org, jgg@ziepe.ca, leon@kernel.org,
 skinsburskii@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 29 Jun 2026 16:30:14 -0700
Message-ID: <178277581197.172200.16265155329935822153.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6pxypm75wg79gsk9be7wka4y4cthsbbq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1860640014
X-Rspamd-Server: rspam02
X-HE-Tag: 1782775816-263209
X-HE-Meta: U2FsdGVkX19m+6+6Iuw1En8z3Qk5FuK1zoo35FD+uZ7EE5j+V4Ushw/3jsKnUEZfTB/w//kff/lPUADmlgiSxtfZOuZ7iqa26C3/TtEhTfhD932IPhVUdN/WKDPAzavPowzWWF7wcScuwa/OMcDBLmj9OAKHDodyIDCGUoNVz216qFbUJEdKF+bpaOlnlFhZlcSDdityXMbKb+OUIur7XUUIH3PM/NWaFxkdyQ7hTyR43NijbVhCx/+D5CF/OVKA/6YlFMv3aIcYLlmzMLDWrIntYR4YvnwdsEen3vNCLst6eX7IjuCHozu9mp/8BGCuyoGEVXevTdxinOV19c17P1I3rQJHJuNejsXX3J/oZ94T3Kfe4XmacLQ5bP1Mm16WQAQWShXyzuXotlnAgiRZWD0NzDTqlwflQEfh1CADCXTscq0xZZGIGAdyD7re4xuorqZpB/2i9bl8vN0UYzaj+as/0WcJuaYESAH/IQtMHVaF9mzINaNMo+BbQ0i5B+Mrgf9efql+hWdenNuj1HQv2CL+HOPFaTphYrJ0PCv6uPPR5H336dHGROaGZ2eHw53abXTaXBCUh8/GQABAULuEdNV+E15BX69M9gwx6w1yaTgLxT9cx7Za9vP0kKYx0GYf+oE1LXl2I1T75npRCWffT/gDsK4n6Ldq6uhmuIuGCnWK8q+dBFExCifzby0e+GVjWLZ1qmucDmmAr6oDycauJdZWqAskzgYqi7F06WQ/T+X7MwtpHexEQczRk8CJGIAoMksT2+zITXoM/hLCo9UwSPmm9EEoK2S+etijvM11zmlz4i2ITwAXrY7g/tgHCfbGQQwkvCNK1FF8goS1zvBMiSx4Ri+EP0Oa1eMtqj3M7y1sFhAVuscY4d5sksNCSQ5IKmL4gHebi/PdhibfTREXS45uLWfT8zSCDkzE3R7Xw4sQrVLV5BtNjlJ/u/5qxXMEbZPmhqAiJIGFFJmn/zq
 kjCeh+W8
 IBwtPf2iFql7Fyj/4NaPbOJovrL8a8i/U+3tnotiSxk+b9IfbD1eKZIb4a9/IBDpJfKFa/C+MwJyoXsONNOSMEhIPIn5lwR0ReSQBG0HLktvJWhh+K2o6pyZH3z9NLNKlL5nHLnsewbpZT7ghiW7pterxhVS/VHh1yLd/96vEKwh4el5rgyg9gMkXhCOGDtT6DWwySY+8eKRu3Pdp4qbZwZmQW4Sx3FjeBAX0DX6i8tD2t70fzgn+Wr+yCuookIaoA3D+atlzs0hCAeOiDKXG2k9ak0pGXCToU+aZg35zdA8e6B8ezFJpQitiHhupm7K2V/SujzUrv/HZzomEZB5rDqmtDewVHUaPsO/aQb0hmtpUKa7Oo5K0eoq4dsDr81Okf4E4OuOe3HndcW1NkYYQyl3V3wJQq4yYqzCPZk+38aqMt8VT3lV+d7pQSVcaFSaQKJ97YLdfw2t+bQu1kJqos6SpyIr58uMXavVGjLmR2y76O7BdgfXTgn8BmY6o419Ipb6R6e0snddlYwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit af69016dab96 ("lib: test_hmm: implement a device release method")
moved the initial dmirror_allocate_chunk() call before cdev_device_add().
That means the struct cdev has not been added yet, so cdev_add() has not
initialized mdevice->cdevice.dev.

The coherent-device range selection uses the device minor to choose between
spm_addr_dev0 and spm_addr_dev1. Reading MINOR(mdevice->cdevice.dev) before
cdev_add() therefore always sees an uninitialized dev_t. As a result, both
coherent devices select the same physical range, and adding the second
device fails due to the overlapping dev_pagemap range.

Use mdevice->device.devt instead. It is initialized in
dmirror_device_init() before dmirror_allocate_chunk() is called and is the
same dev_t later passed to cdev_device_add().

Fixes: af69016dab96 ("lib: test_hmm: implement a device release method")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 lib/test_hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 9c59d1ceb5b5..c4adbf98fac7 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -581,7 +581,7 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 		devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
 		break;
 	case HMM_DMIRROR_MEMORY_DEVICE_COHERENT:
-		devmem->pagemap.range.start = (MINOR(mdevice->cdevice.dev) - 2) ?
+		devmem->pagemap.range.start = (MINOR(mdevice->device.devt) - 2) ?
 							spm_addr_dev0 :
 							spm_addr_dev1;
 		devmem->pagemap.range.end = devmem->pagemap.range.start +



