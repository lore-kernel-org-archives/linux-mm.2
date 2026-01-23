Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B280D72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4D136B0444; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA11D6B0449; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3DE6B0448; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 954E16B0446
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39EAC1AF62E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:02 +0000 (UTC)
X-FDA: 84362540724.12.3978782
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31FAA120006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YwT31+aQ;
	spf=pass (imf29.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+ToaMMw996GZ44VRILSBmrGyDdta+DK0o/5glqE5fFI=;
	b=A9l2loRT4byF7nHJqCk/W+C9vCjwyrl6rQw/JQ8GZvDh1Gz+FprepSAwVnSq+Yyj7APVTD
	q3Uv55fn+vgnv0YNm0HHy3wmP9iTeobpXW7lyeeqx3wpn6kEcUFKZM6YdnMDPPNnltDGbk
	j2sUxf7bfup8n5sJr9kyNXAo92g2OJQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YwT31+aQ;
	spf=pass (imf29.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156640; a=rsa-sha256;
	cv=none;
	b=2ZpaMI97atUeTTm4Iz+azfFVX5LivcVqxielhXZD5InM2HwP6qTvxaYC5FAim3QoRQN3qX
	KxUf1g2uwBMIwGCLfhZYWi6pIQwd/qIfH7a7NCNvloRW6APjNXfDy1FB0MBwfka2k9W7hO
	bjGezOO75cjqKE7WQfB6Lwud1rgW5X0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769156635; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=+ToaMMw996GZ44VRILSBmrGyDdta+DK0o/5glqE5fFI=;
	b=YwT31+aQDwdaxAfZfdhmlwVvfDfObYQppf+M0oB22D3axc/vkMX22e/T7/kCx3qmXmVGNmvLj678X08IvmCzzGS+/SYkm9FFOAvvod+MWGl+PfNylYxOBARkx+8QXn9SVkHh3yvQ4SPVG698pdWmXHWBKRcVcqXiUc0VUy5Sl5o=
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxf8oqi_1769156629 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:23:53 +0800
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
Subject: [PATCH net-next 0/3] net/smc: buffer allocation and registration improvements
Date: Fri, 23 Jan 2026 16:23:46 +0800
Message-ID: <20260123082349.42663-1-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31FAA120006
X-Stat-Signature: jxqt75i5rknquxqa1adpjubmrdes3pkm
X-Rspam-User: 
X-HE-Tag: 1769156639-480574
X-HE-Meta: U2FsdGVkX1/8Kucb8BO9L8Ods7Ua1QUAZG1YCvtpxEZ9zuxoNxEifsBDEG6MXgzDpZGBF46u7qPdUT7nFAdVjVaLPgCtNR4V85BxVDq4cWbOvr2QsgSO6KG9JF9okJOo7CESrOWwgaReBNjKqvCp3uqECJ12hLqJYiIwbydEufx7zku3GE91Sv1+svseegpcH57sDn2QgUKxZih+i0kIdw2QV9WhzmS5H4ZF0zK4HCZAXBw3cQd8cqVIMwAc0h/UEky/T2ijmgELGCUSjHsy9N6l+gzgVNsKWIXfyhwR/aXRRE8iSNlLz2TnCvGvic5RIUH4oYSqyniiDtWPvRX5VviKAR7Jl5w/JXMyjBNveddLptsM2P9/P0h10aHlmNuF+SIGLnfNK1fMna9x3elVjhBPCFl+p5tpG0jgbbiT67hG23zlUCN0xVF5Y1cnUriI0NCl+TAiqzRZtRWAL6xi71qRP5MS+pT808MFVooJN7tCYbRRpwcXC7bMC4xdZz5Dx8+CLshCeMRq28dSKx4g7zeVPTbK2BM1izp8FlF/LjmL03/w1SMeklLtGZIJRXdWVDVieWMTaWCBEBJufE+ZCdKo+75CFKc1YjnaIUVj6kK7VIHOOyyAtnnL5l6qTHSBPoLw6QGTqy2e+nlMP5WgKS8jC64HgYSjCBCSOBllusYvfTjNr+fZFnMDCYjf40hwyLmKa3I2klkUcniHPyaA/V2euemVE2pLBps+cgOXeyiBdGXHg978Es4H8KXQZ4URxt8rfm5Fp/niSKqY+bG+X58KTGewIGJca2RGY6BnbXA90/ehLf/bC7iv/5tnrmvsdqi9J2GhKzAl9nwv/XkkfNZ+oztpp1wdFJ5Od456757r0IcNYmITG8c1j/AdQik63DV6gbLkQdycBywjHbJVzLYSFU8WnkZ2tfsXQktj+Vi31mkau7hQNNzdb9gw1e0SHX4FErENrzFnXdIMQsd
 UaXabipZ
 xPqMdYeTVrdj0/K4h9uwYcrCQwM6nGeIVXxgNfdtXwBHGRey3cuGTVLwVf3b/nLXFIrlHPLfy1TAeRSt1DHjK0MBdmCAea3HxlokyEulFpUqiKKoVR5Qkb4k3CdqblFDBL0u7DoAMkRtrryV2WrGybQBq2gbx4bo+KkDfX3R4DMXmZ/ifpTfyW5dvzaozPx37yg5xaahXUlIIlKY3+8vRi8iuqOQcNbSt7PYEty2OJ3ywpg6T5B6wxiG/H8zUJcd4QoIVsJHSaeESrrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series improves SMC-R buffer management by refining the allocation
logic and reducing hardware resource overhead during registration. 

The primary improvement is the significant reduction in MTTE consumption.
By aligning IB registration with the actual physical block sizes, we can
reduce the entry count from one per 4KB page to just one per contiguous
block. This is especially beneficial for large buffers, preventing
hardware resource exhaustion on RDMA NICs.

D. Wythe (3):
  net/smc: cap allocation order for SMC-R physically contiguous buffers
  mm: vmalloc: export find_vm_area()
  net/smc: optimize MTTE consumption for SMC-R buffers

 mm/vmalloc.c       |  1 +
 net/smc/smc_core.c | 31 ++++++++++++++++++-------------
 net/smc/smc_ib.c   | 23 ++++++++++++++++++++---
 3 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.45.0


