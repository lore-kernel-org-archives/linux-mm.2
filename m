Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8896C61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 01:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674766B0088; Thu,  3 Sep 2026 21:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6259E6B008A; Thu,  3 Sep 2026 21:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D666B008C; Thu,  3 Sep 2026 21:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3286D6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:05:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E8A7C06FB
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:05:53 +0000 (UTC)
X-FDA: 85174287786.29.7AB501C
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf31.hostedemail.com (Postfix) with ESMTP id ED51720005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:05:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c1r7eiZl;
	spf=pass (imf31.hostedemail.com: domain of liqiqi23@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=liqiqi23@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788483951;
	b=qHiOVLkemHkf+VPL3rLJMyAZ91yH7PxIFDkVrFAPmTw0CiMQ5dakxvIWd0G10jMspDQLD3
	fFF9rvXriLDKIWZFFZqnWSP8pzbq2c2w2F3P4r4bQT0R2WqrZx9UkIyXSiTT2TfAeyqO5/
	V6elQ/pIxaAIRrn0k3iA1XW5RcSVW3A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788483951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R44xkW68vjRLhEKdA9HxJ22eV9oyvArt4A8C0/wQSo8=;
	b=H7zqH1ur1Y9GFXqMMI9J7ezJIO5ISVGUBObmE1C0cMSygmghT/yV+K1L/vkk8gkngn6B7z
	Wt6aD/IbtWCWVDkB5gk+nbyrCUpFMwBT70ambmkKGYAwLe8EslzOHbkLQg/rUhAlu+GUmj
	6+3rXcNmno5oC4ZlNXKUhD+yjxHvAQ4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c1r7eiZl;
	spf=pass (imf31.hostedemail.com: domain of liqiqi23@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=liqiqi23@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=R44xkW68vjRLhEKdA9HxJ22eV9oyvArt4A8C0/wQSo8=;
	b=c1r7eiZldp5+In5FW8BEUxdtlU5u/WVo+hSCJWw91lCBymS2tcgwWI/JzJA041tHKqqz4v/Nl
	hXo7ErQV6AgoBMx7gU1AaEoW5lxF3r8HvNXZJwWBGTpxd9MgOyQkHUYa6XLn1XNdCt00vy8B1Ug
	A1o7hU9teks1R0J1f8bUgiU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hbdJz6RXHz12LHt;
	Fri,  4 Sep 2026 08:54:27 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A59E40579;
	Fri,  4 Sep 2026 09:05:43 +0800 (CST)
Received: from [10.174.176.101] (10.174.176.101) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 09:05:39 +0800
Message-ID: <0334fe7d-d949-45f7-8914-3012cb11b740@huawei.com>
Date: Fri, 4 Sep 2026 09:05:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Qiqi Li <liqiqi23@huawei.com>
Subject: Re: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE node
 hotplug
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <Zhigang.Luo@amd.com>, <arun.george@samsung.com>,
	<balbirs@nvidia.com>, <brendan.jackman@linux.dev>, <yuzenghui@huawei.com>,
	<apopple@nvidia.com>, <alucerop@amd.com>, <matthew.brost@intel.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <gregkh@linuxfoundation.org>,
	<rafael@kernel.org>, <dakr@kernel.org>, <djbw@kernel.org>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <osandov@osandov.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <pbonzini@redhat.com>, <osalvador@suse.de>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <yury.norov@gmail.com>,
	<linux@rasmusvillemoes.dk>, <longman@redhat.com>, <ridong.chen@linux.dev>,
	<tj@kernel.org>, <mkoutny@suse.com>, <sj@kernel.org>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <baolin.wang@linux.alibaba.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<lance.yang@linux.dev>, <usama.arif@linux.dev>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <driver-core@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-debuggers@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <cgroups@vger.kernel.org>, <damon@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <kernel-team@meta.com>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-26-gourry@gourry.net>
 <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
 <aoJaaYp30LnKLj1w@gourry-fedora-PF4VCD3F>
In-Reply-To: <aoJaaYp30LnKLj1w@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.101]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo500018.china.huawei.com (7.202.195.199)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ED51720005
X-Stat-Signature: cgjaamc9b33f6gy57haxxseioo35ry4j
X-HE-Tag: 1788483950-166802
X-HE-Meta: U2FsdGVkX19H1G9lnWEvwwcdDIcTug5c/LMtPYKQaF50Lpa/N1v734aaDbK0WfmI3oLyRjG0vo9tn7erqMiY/TtQTXuAOB4eSVQ+5PoYEkgNZ/PIEqMEI+0zJxHW0YWQvxKCM3lPGsOoQI+u95jLQTscMMq+21wgaTHW5K/hDcfPlC7LapKR9PxmMynasBkx3PauUS6XsVHuhcD0saiiVbcSSkxbmcJOiFi7YUtfk3Lxkt5ohWqadBJJCBXynSf0EU8ac9CIme0dKb6mvWsakO5s0r4RL/IqcT/Z3G/2IiJWoMBRhqqL8ePctOe5WAiDdZBLKxAZ1wQLWYh2dqUbbAfQb1E3MJrhqJImiiVkXeAZJ13w7aFMKVNIe9v27K0g8XKvWe8293M88eh0SSnGjakbCKmqVEmNaxJp/e/xOu20yLIHOdN3Bwa7e9ZK+9JgxK3ZkaspRZNyenPAKMQbm8XvfRACnhGySis7qN5xq/wuF9jpG16nkaHvk7FqxQdgYJxEpdFGFq6DHeVrey5VCJ0JvgUzU96JEyX73RoJIF0Ky9AnJi0aR36ifFWFAhT1iwRBJSW1Z5B9acibUWtRs/w2T8CksnyT7gOs95DoDH6U0I46BKezXjDPCkY4E3tczvo3MyJgmEnvU0RtQQYdIzxN41UrPLPqdU6AcrSebudcCSvm8OdXFM0M2A9UXnSYznd/S9nLDGLU2l9Z/qCn8oKtNT8WQaexjeLTNixG95TUiPUjwu/T39qixUPfr7K0Yo786sx6OYjT+7RRzuD+wF1qEOJH7rKs9QFfkVHBqzQsUcSt4NIkwjXkGoE6P+WM3D6oC0l5uimmEIf3Za8ZZbBvLcpD1X1hSlENCqCvAjMRhUCLWME+AoHqmSmEcDTwvhqr7lHrypZX87+9k2qbJAmIsgF7zK0UUon0CcTsrkLBCnAQFPMh6ST18xfmP+2sKE8Xtfk70ONUQ7+HvT/
 +7dPJrYI
 /2lqUEePNMh22BPpx+Eihh4oR6EP0V9DcfUANQYFmk6z6f5mViVWxYlQRVR71YPlRfcuNOqd1XCZpHM5akhDfEKDKD37m2cTKIMuzGZlRy5B5Nm8gDV6ek7fmIYOfPLoNvathABTBeLSjL5isIrklJZRrkpk6SgCU7z/VqI09rkwgg1vP7h0dIX+Q20w499PWAdF54ZoyaHEhBvqCWMfs1sMRErchk1GE3TbgPmW1bHWo08iUBJRyvHZHnnxy+0zWI2MVwJatbWLx0pXQac7ktnoQB5d3ev+ZDL8J1IYOaJeunajFSkYtdoSAGJPiaRaiYMBzPVmVIi8G4oqUYOyuzbE2gepyNGcZci7X+JEMfuxc9VPDxq86E2HNqBP7DuyEZUvd/mzFDftqMEcBqC9Y3cRn2YNbseB4AJZr251LERXzKXbYdhRgexGsN+MOM3G+9bdUUy0Pu7disvxAbX/33QfqXLmAPmmTRJ8z/oUAlBVd815vVMh/pG8yaOdMPQhb+nmQ/oer/u8bICg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/2026 8:49 AM, Gregory Price wrote:
> It would need to be reserved, and you could use numa emulation but
> that's clunky.  I have an RFC for exactly this issue - though i haven't
> pushed it further yet.
> 
> https://lore.kernel.org/all/20260610014517.253609-1-gourry@gourry.net/

Hi Gregory,

Sorry for the late reply.

I took a look at the exclusive-node RFC. The approach looks useful for
device-backed private memory without a firmware-described NUMA node.
Thanks for the pointer.

We are currently looking into the private-node and CRAM design as a
whole. I noticed that CRAM was not included with the v5 series, and saw
that others were also interested in a v5 version.

If you already have a CRAM branch or patches based on v5, even if they
are still work in progress, would you mind sharing them? It would be
very helpful for us to continue testing the overall design.

Thanks,
Qiqi

