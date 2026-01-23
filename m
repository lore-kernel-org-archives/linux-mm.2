Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFEB1D7234B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050C66B0452; Fri, 23 Jan 2026 03:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028A66B0454; Fri, 23 Jan 2026 03:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAFA6B0455; Fri, 23 Jan 2026 03:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5A226B0452
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:34:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C1D28B949
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:34:04 +0000 (UTC)
X-FDA: 84362566008.21.164F023
Received: from out199-18.us.a.mail.aliyun.com (out199-18.us.a.mail.aliyun.com [47.90.199.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id A268B180005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:34:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iThvwSmC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of alibuda@linux.alibaba.com designates 47.90.199.18 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769157243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBm0JDk7EhK8byASx/pot4VMZ/7c5vuPMnvsfOBUnCE=;
	b=e1tZOZg21OgdCIL6s+E2l33ORoOkat0G1JvAQbEgA1areStAKDv8qKO+P6R4QNikbe4OoI
	XCjB3WyFeCMhujVG5aVZGtbs86biWbyzViGadRQdhprIiE7DqgdF04jM3PJVRI4/MvVX/h
	n2ZYQGP8tb++DeYiGh4fPzO26wvZmRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769157243; a=rsa-sha256;
	cv=none;
	b=2PprdnWMgxIg5KhQhy260pcU4vgX6UAfHBo51zf+TArVPB8OUL9Jr4eytgTZh0EbezTSqn
	0rdY8pxFllLO6PlNdB+bu/fkuf17bcyawEtxOuur4GZgtDSoneAO6LoCpiVUc+ZdVQoDzM
	LjKvCZcn9sRY2jpsnRuUIAkiY82ySDc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iThvwSmC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of alibuda@linux.alibaba.com designates 47.90.199.18 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769156636; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hBm0JDk7EhK8byASx/pot4VMZ/7c5vuPMnvsfOBUnCE=;
	b=iThvwSmCe9zTcBWIDB1rbrn1vrh94TL4bCYPVBTMxdUevCygeT6x8Ap5G17RYKMSlLRReGp2R8UqAnE7phsCgTiYhai58xbGeG+AmPziVjMEAehhoKQ657R1jkugzvEFLqyzGslvoDW0kLkkC43dLSCFwvE7a6wH59MhfBxNdaI=
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxf8ovm_1769156634 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:23:55 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Date: Fri, 23 Jan 2026 16:23:48 +0800
Message-ID: <20260123082349.42663-3-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260123082349.42663-1-alibuda@linux.alibaba.com>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A268B180005
X-Stat-Signature: 6bykzyms7pwesqg9okeepg3un61dsefq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769157240-221142
X-HE-Meta: U2FsdGVkX1+aZ4ElK/QqHS4XRXjt2d6+WJjNC4h1O/fvAgGXmk72/RNkp9Ug6KJYBGygKaCBZqOl1Kj0SBcrV1T7O8CHJXt4vW100Lhl/u/32M1DQl2iYG/qzkCWhpjrKzJqjlrsyhNwgEWdswRrXPYQ5X/k4P8QyzJ81P17Co5kG5E5+wdUoaZ7BfOb8Y6CDkkagD5lkgy8H3Pp7a43pZe9mRfrZbuphRpt/qU95y37C47GEiZ1bFnK/Xvcf481IenFx8nbU26yWHY+Ly/c45YtxuJmjF9yT736RdyDsHiDZPKo0CKSF5GM5GW7jDydmvnlgbRmwc/BX2/9QK1qj7HI24/ETtBLmi31LbDRGd+ddtm2ys+hw2q7WwvI+CCrxzxvw1mtk10BjbuaoED8LtWhcXY47GLko2rjPF4axqvckGnNjPCh7Hpvfq0q6HvEtpgvZhEa4DWUVoukf30BNY3v5aP1442Jl2Ud/dCfcKFo4/acB4QnxCN9U3MiiNctTbNpbBFRfA/Z7D5SZPBN3VxWt1zjjG4n2B2o9/QpvWO/PmCrQ78wkrnEM7Gq+vUtTdJUQ/rozaArfnsbxLcgzs7Jycl3GiZOsab4WGFnARvmpiLmOSJ5c6XbUwaoyU6tVFrsQaRNh9095pFciBjjJfKa7kyvNNOME/I2SBuyjvRm2moZtG7sknzvPOv4Tujv/8ak6XrRefvHL/xE9Aofhv8lx1Q/7JT7Gl9G/7tqXSgHNX0oOfhUESL0SdQ2UYYEsZxYi+QIL/Y5HZGvZOHX38J+bIgW2tMzxHGDaVt11kN96lsMRA+KNfWSbpB2RIqUl5y3KkWaCOlR4D2nH8c57mP7czJK+WgZAacAhZQ53teckX69nwzkw9GShOOVVQ7+HfzANwQwwZBGjYPrI/2B6kcz9s6zUvcL0TFm/LIl6vBsql4TtNgvJGOiOqFeEqSh3MoBEmQHboKhSN5z+u1
 +5JIbWgH
 E6LUA/D/EMncCImerICbt0e9kF9TOjSfIWCcCLaWER12y8aBN/3mJBFpPQPtkazOCIiQGg3dimD3Fv6jA2F61u7aFyY8ZsEjXHOm3L35ie0zmTqadj1ByfQkoszZ0pCGBzW3IXvPn93EgjXKUmUb2HvLY3o3R7hKDOsH+kAZ8FPjqcTCFvwZyrieaA2/gQhtvu0p72+53gF8J9uiXdS4zQv3gErH/nhTIPPutagla1WhgRqKRrIZXOetEs/dAWrVWCOA9O64BYQ9QT2r3b/+DYBzV5fh+ejPNWv2pvgcVaUqsNcL6+W3xGamvbI7iHrKqUAs5ipiQxbwMhPs+sjtzBcu/+n+s84QM/nvUwDNANr/FU1npr7DxfjkKJ72LQt8broqD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_vm_area() provides a way to find the vm_struct associated with a
virtual address. Export this symbol to modules so that modularized
subsystems can perform lookups on vmalloc addresses.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..3eb9fe761c34 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
 
 	return va->vm;
 }
+EXPORT_SYMBOL_GPL(find_vm_area);
 
 /**
  * remove_vm_area - find and remove a continuous kernel virtual area
-- 
2.45.0


