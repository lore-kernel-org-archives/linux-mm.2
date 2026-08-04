Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224EEC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F266B0092; Tue,  4 Aug 2026 16:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156EC6B0096; Tue,  4 Aug 2026 16:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C4D6B0098; Tue,  4 Aug 2026 16:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C80FC6B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:39:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F74F1C030B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:19 +0000 (UTC)
X-FDA: 85064752038.29.9D65E1F
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5D72B10000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QL7vGd2Y;
	spf=pass (imf05.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VvjpSGk2j7wEi+0eGooFSuN61xYiJE9ZIQ63JPvePM=;
	b=8UDNhDAFXjedVepG1kK5Nu1dI+XHTtP3AaG/91NjomA7G9ZyhjCjmdfYnos+qYwO3Rk+e0
	lUrI5rrxKJG9WrWHPRJejZJjNZbnBI8jdr7xHlPLs8BMdFdWyhY84I2vIGDeABATqY2Jqq
	7doBEsl7OFcyjf1isAXKeBwznoMd5to=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785875957;
	b=Mu+7K8xb3yvgyC6qbhhUMOiupg+lTxCEy8GRZuQLIRZxp8zoAFo2dIyaaeKGyl276i1fXw
	rR6+eWi/EIKCHsNepyzxD/CXTc+kqqYINbdwV88VEpu32joS5xAAzodXq+UpqRAemzR0ZU
	d//OE95uCeSievFuSLotlIaXaLKWPXw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QL7vGd2Y;
	spf=pass (imf05.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785875955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/VvjpSGk2j7wEi+0eGooFSuN61xYiJE9ZIQ63JPvePM=;
	b=QL7vGd2YCSw9/c4n/5pToSUUL092xi1wVowNHWu7l7DB6mX9ZgDeh4sqyOgF9EdvU2epIA
	EGNQ+uBmyZwrzOOnJblnNUNdBRrVC/zV0B9PASLszFj0qhwU73z6PZCJzHVFSqkRQ10kyc
	G1BSOlXaI+2qa69x1jC5FHtZwrq7B5s=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/4] add anon mTHP collapse test cases
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
Date: Tue, 04 Aug 2026 14:38:43 -0600
Message-Id: <178587592371.79283.16750931617435580186.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D72B10000C
X-Stat-Signature: tn6ygesfk4qr1xxdjbw9got9trhdt1y5
X-Rspam-User: 
X-HE-Tag: 1785875957-7806
X-HE-Meta: U2FsdGVkX19sg9a6E3jpOGxTgUgVw1eIMW1KcQM5YUuwE47vz7HWWrlHnwzlE/OUzA6L7ONMXSL7ILNIHRe+mDQOmOnJGVwnDHldanNWpcT50MXFcTGVL/JEMrzEQUoLnz8yZ77bKo/sk1c2J493MjgsNkFN9xHbeYPGIuOhtjOXT9WhtD6Y42pBOf8m4+O6wjOU9YAbb3nZMlXe76mrcKOX3qiqrTZ/EcfKk/+NUPQ+bJVGb96Ps6sKXbdyECfQsEFwqOWbBXCEvsPjDPHlmQjs4MdXFPe3BkpjPknFB3u3R31vnnMsY70o0LUXrdRd3yvpnFQP5qXcm4gCznZkIWYvUpCLX/ASICOHpYvNvpa9jA92FKv/GHcr8aghJxuOo9eyfvnvo85FX3RKuNi83CkMcy/lxtSPlzx80Qg1CMjzdHVlfoWNV052bXBuFEff+9vtJ+Ka/P2Jul3L9Cxcy6eVyBplNsoDwi4rmTQFlXJoNUQnQdOY+P3X6bYm146SUZJTEtQG+QYco1PiwaNowCnjvscH1oeBHCwwsgHwxZ2izegGr4qGMOynJbLJGfpf0LnnJ0sCNtnrw7t0nsSuWcCGNgxB1pnSH3B2VOeXIyr0SfNaLO04EfU4wqzROcIea4EORRqq0Vi09ooKyxMzZRSUzhi+Os5YgEdObDfeHUfemsH6QNUrHv3gz/vqAW2vt15J5l9OybQlJXrWsfkhRqJl3gzXpwlhKLFI53VOXA6z8Z2FQMNWrXBubljmrFhRsImzYkOwQCEQaO5dOTHvgdbQTnJjgO1XzslMArOw5gYq70nXxPUBpAIVTr4ja/D5JURH1YI2xYbtp+VFIowKyJI/fu+S/Dyu/K4vwyPZi8iZPSIKpgi3vNtUaSslqbDsfW073yfTQKeyg2wS5kULfjqUysNB0SeYmPP6lMlW/ON3kMSqgTrazbZ8JLoE78TY5RN11mGx7nBdOvxBGpn
 kxrPmHOk
 5FgzQJQ+iVegr1+INKT8B0I+bkAWPA/YMO8nhdGHORKtjPa40v6ElD98VwzATaRy/hM6lEag7LXFqZTHUSFsJaBBpllLOoyg1ilj6MNIt6ZMwwu2VEU/K12m8dHgHUMVFCU0zVTtV7BLv2/q9cVdjiWKX0D0ABhZNWfSTcFTlmwGI9r7x8m8A0JLKYcW3a6ZH0398OvbJZBHow5zaaRmNr5lKqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This patchset is split from the previous shmem mTHP collapse patchset[1],
> which only adds anon mTHP collapse selftests. All khugepaged test cases
> can pass.

Thank you for sending this out :) I played around with it and it seems
to be working. This lays good groundwork to expand khugepaged mTHP testing
in the future too.

Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

