Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35068CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 13:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758556B0088; Thu,  4 Jun 2026 09:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FBD6B008A; Thu,  4 Jun 2026 09:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646CD6B008C; Thu,  4 Jun 2026 09:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53BFB6B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:43:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE78A1635AB
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:43:12 +0000 (UTC)
X-FDA: 84842346624.02.A9F034D
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id C14E640029
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:43:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3yh5Pqqg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780580591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqAH+jkzeCPdGtaLFK/vNcS/ptJTugJ6NWWQSyS0myc=;
	b=Vfr8eNrSeUFvRKFlScfA1zATSAX8lZUcuTPnrH7pGBD/2lf1UTO3tnryM/0lR7w9e300Fn
	FS6OGl6PRD+2dzP3oSxfv7gcoZ6HhWJtfz4Y+ASTcI10ovzmejztFVv0inAeEk2EApPnbu
	zU7jmtRHLywvJdtEErIZLMQBgRWG7bo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3yh5Pqqg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780580591;
	b=D9rCbDnUbJ8O4gHBpKITiomJ/JTArA2dXupvmGk+c4ScqoV8/OdKCHKbDPLjkfdTzwPICQ
	/ZKmyAAuV0ACkEPjodqcdOVbrkaPIsk8apcpUTiJnIobsHiFs4nMLgsYaDwjuFz292YXi9
	yWyZ/yiOcpoyuxQRMmOTvhN5DBp6nR0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zqAH+jkzeCPdGtaLFK/vNcS/ptJTugJ6NWWQSyS0myc=;
	b=3yh5PqqgSnBSISBzTBPiZwewd95hdoGK4zOI9D0d4eHRtNow6c2R3WCcx+OInBv50bJXPiRv9
	4hfxuoWEHnv7lWdmLGMhF1N52MQtX/fq8+6avM38jhqqSKdhlN+cA4K6k9ackulgXZ3ouMqQHqe
	ZNdDvCe1UL8/eke3vqzbyZg=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gWQY028ygzcbRy;
	Thu,  4 Jun 2026 21:35:00 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id B624F201E9;
	Thu,  4 Jun 2026 21:43:01 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 4 Jun 2026 21:43:01 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>, <qiuxu.zhuo@intel.com>, <bp@alien8.de>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <linmiaohe@huawei.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<mchehab+huawei@kernel.org>, <tony.luck@intel.com>,
	<torvalds@linux-foundation.org>, <xieyuanbin1@huawei.com>,
	<yi1.lai@intel.com>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Date: Thu, 4 Jun 2026 21:42:09 +0800
Message-ID: <20260604134209.111533-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4de75e51-025c-4926-871a-4b9da479cefa@kernel.org>
References: <4de75e51-025c-4926-871a-4b9da479cefa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: tsc8jhr31g9tende5atg5ukhk19ygrat
X-Rspamd-Queue-Id: C14E640029
X-HE-Tag: 1780580588-801341
X-HE-Meta: U2FsdGVkX182hx3tCQQxqoDNWyvUsh9UWR7CSzlWA4GZvzPc/NO7gkuQ0mfK0A1yC1iKVXQYSOs7GdQG+AyplzwntqVrx5gK5/M3pDYtlxy3F3UEu6uSLGhKGva0Bjp1iFzQpvdcUDc9A5ba2egIsOOnWNrwBZhj/ehGdVNJuhb2CB2+JfmmvuBxHdAmN/hGYodoAc/oZk7SLkaJQqIcsw7PxuzFt99GMv2APW2SsF4MCB3n2XSb6WG1jIu9K00Js4acDhJXvpGoTLwi3HX0jMT4DMLH+vYSf6kjZ1uULQcuqOAV/2aOGrEfxOXx/o3/NXjqDBVZ92yvL4hJj5YFvybZVfHn/YF6T9hzcfnUcN0NkgvU8wtDK58eOVBjjX0zjuhBlRYFas3g7q9icQ8JYCvFw4u1mcNvKMlqWu/hyza1E3UwhrmH4O7oKQEMrx1uAuNxwml0BpNBznWuRtbzeq+OzPiJV3gPsFff5HAP8kSuTuAOa2EM0cR21tmTErAaoRDG37G0DWBi+LBxCVqyfSsFMaxVvhHpnYfknNP9CvU9ZloYDyFZ9KR4Zwsf3mTGn9n7cUpE6Ku3qNG20BA0clsJ85G4iHTdB4fOszRcEJznEdp0hk0YDbnSy0ZNypZZArpL7HV1s77rA1n074FtyS4gaT2iw70/8lUPl9kC2zZ7ykjUdTK6bAOrcVwppMCFerFM8HsO2yfNi+hi7MSfQeRWebQ+ICX38WTOix01blOOq8zy0StCeIeVH9RP1cPHxx/+3Wyoj+OMkVTPD6ZMM0RVvsjisLftlotvJTW2X93Yr7CkzsB8/ogYihU23YSHv++GcTBTyww1DzKnKkpM4+YUPMmtTwh9mLaCTmH7aaRvjXETkjwnSP1cHhU5qshq3z1FAvE0y+xDau7TjMwjy+dJK9Ss5+hZuDpBbWXslpE59lx75t8mplstS6r52Eo2D/g4V3Oh4I1HFdSxxKX
 OBggXslR
 VQQmaeS4TVsobJ3nZ/YmHgvVR//vif3ETh7hbHC6CjZg2fPN2R5tJLVEIyJGHgleEc1wwuHE8Rlsnv7rLvDNeRVQlmB6+5xz7KaMvI0cRy+kYKk+m7O+VFXzribjSjNMM+cWHcSaF6KjZSC3GxwOh+qZISprESShwgHKtxNQF/jwgn0Jg0tdPzbTt1JznLOuwPfkURM6z1I72l+wlyE09yTPydK0uywOca4C5A5sluGgveQShjqLcMg4eA5F053zQ+6YoVmEyB5HyVLNFwyxbRH+jftWxeMmkeWNaZ1b2OPOWgt0CSMFYzQU8gvpSRUowuUOylH8+3YNoDTEwDSfoCbThAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 08:42:37 +0200, David Hildenbrand (Arm) wrote:
> Yeah, if only I had known that we would break user space by changing trace
> events ... now we know :)
>
> Do you have capacity to send a fix?

Sure, with pleasure.

