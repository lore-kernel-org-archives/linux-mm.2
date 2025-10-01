Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2407CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030988E0011; Wed,  1 Oct 2025 10:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0086A8E0002; Wed,  1 Oct 2025 10:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E607B8E0011; Wed,  1 Oct 2025 10:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D19988E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:56:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87EFEC0128
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:56:40 +0000 (UTC)
X-FDA: 83949846960.07.DA72411
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B5344000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:56:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759330598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=SzwSZXQ3m+Kme40R3quYwNfMFMwJBkhQCOTJQjhTiQs=;
	b=JSn98fD+WlbZxO75YKpGBr1550Mzz59KpvjjS6XfMFntmveFaDzFOleG+rOuUczaU/k3Lq
	e69EQBco8jid0Ux2K3+oIN4WegOQjE+BzFncA2/4ZFrdW6gCFRezxkZUNPwKE4EMqGTCvF
	uBr67taMKgcFLt/Bbig6UAvcMSwrZck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759330598; a=rsa-sha256;
	cv=none;
	b=eF2g70d98napMq/eyYub36D8Wh6W9hxXWn/a40xZ/vQ/OFjPASFAVHAq3wZGjQqw2MTktl
	UU1b4XaYlZeZ6lnMMA4Q/l1InomGIkRzCO1b4e0sMtVVmBihaY+gtL8Y0aqEPjiU82V51F
	Vk5uHLBXSYBVkPMnurofpob++J7jxFE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4ccJ0f3XlBz8Xs6y;
	Wed, 01 Oct 2025 22:56:34 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 591EuQFk092290;
	Wed, 1 Oct 2025 22:56:26 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 1 Oct 2025 22:56:27 +0800 (CST)
Date: Wed, 1 Oct 2025 22:56:27 +0800 (CST)
X-Zmail-TransId: 2afa68dd411b2a3-0609f
X-Mailer: Zmail v1.0
Message-ID: <202510012256278259zrhgATlLA2C510DMD3qI@zte.com.cn>
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@redhat.com>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <tujinjiang@huawei.com>, <shr@devkernel.io>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgMC8yXSBrc206IGZpeCBleGVjL2ZvcmsgaW5oZXJpdGFuY2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 591EuQFk092290
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 01 Oct 2025 22:56:34 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68DD4122.000/4ccJ0f3XlBz8Xs6y
X-Stat-Signature: 3syhareyhwemn7susxsw3e8agzexwh3s
X-Rspamd-Queue-Id: 0B5344000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759330597-768943
X-HE-Meta: U2FsdGVkX181EszxAh3w1ieHgEuKouF9fX6wMoBvSGhG49MjuZq/X11HRVKnm+G8PbS3GTpqQatiPhO6+HGaraDt8eAvaK/g83Gi9cEgI4x1vf9SuBXMLT1Ol7ayFmSkzWNwO9X5bOhmp/A3mq0cuzx7g7s3nmwxYywCr7kKP9z0DJIFe8VcA5smi6olJ+5JRbhZZAwGws3xfByj1fh5geY3Anu4E2aOHFZ75zU2jvVCdKJ43RWoOE+9iW/tHpaoeW0zZcrHzN8406LPeNDPl0WVpgyIcLwxawUNwRlWz7U6IfRSgyUUpPA9ZtCmbmJwqy+/sZOleQ7kol9BpJo4sO5koDJM1y2wIvG2uDNaCP+nPmh1tEo9ka7U+2GDTuRH67hmgNMhaX+h8O9VU+/bi7rG/GnXdjBdyj9MGPZ/TUv/Y3fJSs0DxDtbiIbg2reFQgaDTgIibzyyyKLQ3GcF64Q+l/DXNZ0VEkIGCP85NVYJFAb6GYZn2/dxswNnGurjIDUTJYukoxlNfMoL8XWOvEtVP+20dxCuML6P3fciqf+YZ7A1WxTmB0yFDcjKU6Pz74BfYGAhX38JvqnuAZi8Q86LsYy/UKWz5jQhRj7YnAdKLi2YT2BqH4zrwyRVVQUhRuhrix0HVztlqF2MwebtAeFO4prZbpzQ0UcCaQ9w4ESVCHVPmdk2+gWJBS9f3+k/vH87p1xBxT+TA8wMRgbEOTLgnb85e5xIJd6LuSHDbikV5FWL3zL2Q9zhDKITNIgqlppDTlImSNdAzpsNJuUNnLhq0gxwKPXeBMQ+SXXd+PqnPQIMbiugj2DTyVpsdECOIwETdJcEb1bfhfETOkkCoaXkLqHjo11+SBk8TYsb/zGjBQ2wqWpznzjZKuS2nmfnBM8qlc7v0SlAh423u89KdolP5wbBjKVPAVpjuCZH5cmWbacLi+ALqFS3WK9e7ox+inJG77FkE88iteF01Hr
 ePDd4dw8
 EfVAj/iAPZvVCiCF/uNgHLTabfyn4U5gnGaQk69odXTfW2L62EXKxmBZt9G21FEAh8w0cGdKJzE9L2ZdcLUrbCxZJxdS+YnReK2BMRi6l8ksx37oZl6i87J6111TUUPhX15+1oyGmr+WX3p5RIoYy2CVJsFPVKw2EnykktciegijQnySTV92rRD8RM+wY3Mv7oh72IeSVbd8oXfn+K1SYnqXbgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000232, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This series aim to fix exec/fork inheritance and introduce ksm-utils tools
including ksm-set and ksm-get, you can see the detail in PATCH 1.

Problem
=======
In some extreme scenarios, however, this inheritance of MMF_VM_MERGE_ANY during
exec/fork can fail. For example, when the scanning frequency of ksmd is tuned
extremely high, a process carrying MMF_VM_MERGE_ANY may still fail to pass it to
the newly exec'd process. This happens because ksm_execve() is executed too early
in the do_execve flow (prematurely adding the new mm_struct to the ksm_mm_slot list).

As a result, before do_execve completes, ksmd may have already performed a scan and
found that this new mm_struct has no VM_MERGEABLE VMAs, thus clearing its
MMF_VM_MERGE_ANY flag. Consequently, when the new program executes, the flag
MMF_VM_MERGE_ANY inheritance fails!

Reproduce
========
Prepare ksm-utils in the prerequisite PATCH, and simply do as follows

echo 1 > /sys/kernel/mm/ksm/run;
echo 2000 > /sys/kernel/mm/ksm/pages_to_scan;
echo 0 > /sys/kernel/mm/ksm/sleep_millisecs;
ksm-set -s on [NEW_PROGRAM_BIN] &
ksm-get -a -e

you can see like this:
Pid         Comm                Merging_pages  Ksm_zero_pages    Ksm_profit     Ksm_mergeable     Ksm_merge_any
206         NEW_PROGRAM_BIN     7680           0                 30965760       yes               no

Note:
If the first time don't reproduce the issue, pkill NEW_PROGRAM_BIN and try run it
again. Usually, we can reproduce it in 5 times.

Root reason
===========
The commit d7597f59d1d33 ("mm: add new api to enable ksm per process") clear the
flag MMF_VM_MERGE_ANY when ksmd found no VM_MERGEABLE VMAs.

xu xin (2):
  tools: add ksm-utils tools
  mm/ksm: fix exec/fork inheritance support for prctl

 mm/ksm.c                     |   8 +-
 tools/mm/Makefile            |  12 +-
 tools/mm/ksm-utils/Makefile  |  10 +
 tools/mm/ksm-utils/ksm-get.c | 397 +++++++++++++++++++++++++++++++++++
 tools/mm/ksm-utils/ksm-set.c | 144 +++++++++++++
 5 files changed, 567 insertions(+), 4 deletions(-)
 create mode 100644 tools/mm/ksm-utils/Makefile
 create mode 100644 tools/mm/ksm-utils/ksm-get.c
 create mode 100644 tools/mm/ksm-utils/ksm-set.c

-- 
2.25.1

