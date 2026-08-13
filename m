Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A8EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89D76B0197; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38E06B0198; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C752B6B019A; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A10F46B0198
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31E29404E8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:43:56 +0000 (UTC)
X-FDA: 85094852472.25.585E97E
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A97920005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:43:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fVqV4ht5;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786592634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nfcGx0YSMLP1yfpj8Odjxu7UM2DMjOzTVUn/eVe9GgU=;
	b=w8folklb2xkEtD9lnG/Tgv+DSLETpuaDg0mtKylndkLNxDxetMEpYX/QGp4gKijLDaOqjv
	C6YWuKziRMKM1rrjwVRnD3zW+dtF64QhBMmkMdDbxu2S/sj4VQ59BkH+Ln5RLMSFqLTLuH
	uH1L+UcA4yZRebvzXhSRPbycDYEVzH4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fVqV4ht5;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786592634;
	b=Y7zgQ5abKUVOvIVFVOtxEJjEcdgr8k3fQzy8cUVwnNb+V2MNhQ9SW63JSt+Gzk1fuiEed/
	wdEnsiol5X/eOrq/hLf9a8ISdfENQL+sDL9LIvl4p19O6xLAZkKxUVcr11+UklH3JjB3r6
	BCfC58T+J51+TogdogYCYAQA0YDqpxg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nfcGx0YSMLP1yfpj8Odjxu7UM2DMjOzTVUn/eVe9GgU=;
	b=fVqV4ht53hJl1keWSbKGqRqm/hOB8jbkpkwlzEQiaY5hFeoa2S/l+ZcmcyHbPofGkp7Xs88dG
	RdFBZAuYySQ1r7ZXvcfrP0SeIW4fVkhonDEA0HjlZhkhCUTWnD6ZoW16NGUv9MVmk8cnZTyvRvd
	Jw4QKIqLpMES5zI1PKyzq5Y=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hL9t65bSLzpT0F;
	Thu, 13 Aug 2026 11:33:02 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B637340537;
	Thu, 13 Aug 2026 11:43:47 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 11:43:46 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 0/2] docs/ksm: fix advisor documentation and comment
Date: Thu, 13 Aug 2026 11:17:20 +0800
Message-ID: <20260813031722.569983-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: 9gxa68yyua55b5t9t9yc1y6wcd9qs68x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A97920005
X-HE-Tag: 1786592632-412946
X-HE-Meta: U2FsdGVkX1+T4AGakBZ1MVBNK6WnkphDxA0t7KTDfNfVPPNht+9ocmKHsTNwLLBJ3Bfk5OA9JFz4b/40K8SFFSbVcEQk1kTUC3yBPvQFJuy6qtctWXbb3jzH4dBhK8N6X2cj6fNrD/g3ubqmtAfhwUDtVt0o6Z/O6i+hua0NWHq+B9SW/WfdrBdhguX3dhN/twXibf66HYrGSlLp75xvoLS7KR+YQ5a2VBUxIpIv3+N7hRPNLfZmgzwK7GrsJ1F8GK4EAsoPwsoPzo7KpK/GvVbUUvKRdgBs2Ms4UaiULT6GYqNqfD870zOkhI7lKnJ6U53jqEdYy+70vmxUDBlpJOICRRb/H7wzrxBtTa6TJQ3dzjZLd1cWhvRd55vdWBWYz8YPH0kaZasW07iT5KYvHhCXU5W+MxncGJq+M2bp88i7ShtgfLV+nYqctYtEsI+bnc9q4wRxUO3pMY3EabESGwm8cnLLW+0owitFv20ZADHUk2vcbOY8OBYd1n1Ig2DQxYHOeE64AuCZRUEVHgOASaEccd3Kl8r5qNGKhj5Ch3k9+30C5c5pvnsevKOmd24gtU6gu6X2p3CNUjVXGGO42IrVIVLc9tKUM0pNxehlrv4Ieou3jrIOpO9fa2LdBHkjJpXKjI2GTj9ckaAECRv/IbN7ismxLa9d2zpo7ONTw9kxnH2dIpC5Dzsa+ApwRbUNuLQHheezi6QzJ1U6wL1MlxDbB2F6kZOiDhmwrcG6vl+YnNi3OTeY+cxEbl4z1XFMHJOSNCghAayiHa7YdalZaJR40YQjDAk4UmD6oYYItKSTzyzrb0rEi9s07/Y7g3qCUa2/Z1wUTdgS4kvlHkNEAneyOer40Xmd4KoM8kzgoMcNbYfg/qixXd4Z8ZrxBc8TkJNmLD2BSBlmQpGTi8GIwcC7a1BPSQeY4Pd/CZMsFlCFvbbquWJu0VWHLhIqYqWqFv11p6YDeEP3Cwg/Ut4
 zsHJ5yWv
 JxadNq+f2wazr8FETCQ3LLZ42XcJoIy9hwLRQnfOGI8ZF8u5a1tTXyctw4cehF9OifCjcfmpVcvl2JDb1ZiBW9ZvCeWTSAH6opaghcdI/vP/vZXUAweGP+i1QrM/Ge+EIbDfGmYy1zI+3a/wZMa4WAoRmiXI+YXw0RDJ9nLvz/gCTwuVTNT/cB7odKvkuMSUDXaLnPCKPcVf/8HLsMQ9ofgE/UwuuKLy4P/3FMEAn1r13bpoyFyQRQT8M7twqNZJpY/xudFyrfWcOYiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix typos and misleading description of advisor_min_pages_to_scan.

Changes since v1:
 * remove fix tags for both patches
 * update commit message and comment for patch2
 * collect Acked-by for patch1

Jinjiang Tu (2):
  docs: ksm: fix typos in sysfs knob names
  mm/ksm: fix advisor_min_pages_to_scan description

 Documentation/admin-guide/mm/ksm.rst | 8 ++++----
 mm/ksm.c                             | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.43.0


