Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D016CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DADFA8E000D; Fri, 19 Sep 2025 17:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85A68E0001; Fri, 19 Sep 2025 17:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B938E000D; Fri, 19 Sep 2025 17:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA2D68E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:30:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E13D13BAA2
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:30:59 +0000 (UTC)
X-FDA: 83907295038.03.DA13A61
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76EA4100009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:30:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JaUd4+A7;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758317457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nePlvBxaX+05CB+7UEJ5zSphde1td/eCwPVeg6HHBdk=;
	b=bheFIc6TIpa+skAbmcHgF5ANfyDapXHdDRdd8K5Si+z/wkhaKJnBwprT+gUw1z4kHxsfHw
	s+bSpB8tvyEahuvJvhwW15dqCVohPizl3+RSUISTf2/SWnlanuMPU/59g/EauxlEv4XMhD
	ZePMf5tJnqjlZ5qBfph5nQAjBFDuRVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758317457; a=rsa-sha256;
	cv=none;
	b=0NAhWvZdQmH2Vj9Zz2ZLLD9liruKDU5ZmfQ1Ooe1d/nEl+7pdtkNtcUCOuqwWk1lLy/Jpm
	lPXP8RR6ml3swx+y47EipW5IwLt8FsL8Yuv2hUUxxZ16CGzypF1rmnC7AtGJpqNOnFM10v
	fp3MyvKNOM4aJTsqiKBct3wDV8+rD6I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JaUd4+A7;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 19 Sep 2025 14:30:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758317455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nePlvBxaX+05CB+7UEJ5zSphde1td/eCwPVeg6HHBdk=;
	b=JaUd4+A7i1eAbmEufsJ8+rltM7gxxF/Didf5CeXL6bRhg7LuWe1HFJjaSRQXnfhavpHCBx
	whhbAzGBSW8dpzIRgPSdSc8iKHulo6kQOW8YpfRiLkauIBSrQNL5McNsJt6ttzCjxI40dx
	h05Sr6BSAlLK5AbiMGXGTie6mKujuHs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH 1/4] mm: thp: replace folio_memcg() with
 folio_memcg_charged()
Message-ID: <yi5eghzjegjvu7tq5b3os6cxt6lcgfpu2xv7m3yiywppq2xcl6@lneq7zbtm6kl>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <35038de39456f827c88766b90a1cec93cf151ef2.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35038de39456f827c88766b90a1cec93cf151ef2.1758253018.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xe5c5n5z53ezie5tf6wbjj6sh6gynzdc
X-Rspamd-Queue-Id: 76EA4100009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758317457-405571
X-HE-Meta: U2FsdGVkX18p8Fvhw9MQMb9MzEJtOuql9NEnfG7WokqHOJrgoGkT8oYQBJ5zjxOAhvHyZFvrrbIYE55+KyTWT5PjUpnPtCzJd21HrFn4q0XTFwQwXXPggO1DsQqVBtO+qpsJN6xGurXadDOgUU2+8ixjvqUp2oKcIkLl4lSTVRKLy4FZiVAWKbQeZzNTCBZujtUoohUOwC0UqZS955THhy+KTkHIO9zmcLk7RCtv5bQtwcJQPiHUpwopz1Oo8ue7d+9PsAKVNTm/iWlGa+bHICMJiRWYemKit/PSNoTn56zFz0AWJQPCLBwAKyGljm0wRDa/S5CVczuTuxcW8u3XNMqjwo/YNbmvRXq3s3vHILzhoCxE7F/Ga6608fmdtB6zZEe1lN3Yvywh4VFOOsFmd5Bu2+XAXRG2L2t7OLj8qkcAUnNoqmsq2Utp/gzGgvilT207aDcY4pNxR9c8Ur9qQQgHmxGXyZJ8DaUfKaMmvo8VRfPhmZVOb8lqlNF3BME0xzfFW3ksEwE3W/i9hil2b86C28pS6bzEmLAhLMROAtgi4uu6NOvM3fthjQsl/pnQ9fkBQj3Yqn55uSn+61qtf5u6FiX8DMMQUUZYaesCL2hARJfT0xJfyLzzKGIRe9Ez45OPnOtV/ew3VHJDe/Y3nPMB7Z9Mi3TLBKTfOb6GGwtxal040nYvaoZNeQII/kfoNpJEpFEmC5rmaEy0XIUr53v3tPvZqFSD7Sd4yavcQxC1hWgyF2+JsP0UZP/W7+jcmnnun/Z2bfsN6f+e7hTdFwlsZB8mN0ixTOqLSRhXJDO5n87+F5zX1nv1caG4NZpLzKoA/WHMpZ4wbEY2rt25xjfRPUemoJuwPMpNTIMvarg5sxScAhVIsKeljGjmqPFgGXi1nwNRIH8e515VZ7aDbxUEwpjcTdhr584QeZweelAOXB34DadIgKmHIa4aKXqhwgCbmV9yFo7rwI+ATgj
 kG862Fj4
 l215+Myzgu5f8FLxLzOmsh3UqnkunYmxolO3EhrxtM3BMvzE7HoSzHOaIx6DSw5K6MTxmICMJrOHTJCaACPdM/UBYdC6+DXP6TC5Gl4RdIfp8PU3TlZaBWtz+nuqSLmEqFFbbtOb4UeB9ioFnJe4BgnS5vuBdKNb7ToiQfRgIyyz0RjfigOuy7qZuJmzRa7RhNKYCDzRxw8Z6+CxyxaBs6wS7YnG6Youqbt/21I/GFRsygZnWIb0+W0i++Ucs6/RXYIcVx6OllIK42Ru7rohqERyCDvWmyaW5kO1V2phEgc1o3MlRB/Npx9iFtmOydkRNpxQiesFvgkbsYCmL5oUT/HZkdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 11:46:32AM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> folio_memcg_charged() is intended for use when the user is unconcerned
> about the returned memcg pointer. It is more efficient than folio_memcg().
> Therefore, replace folio_memcg() with folio_memcg_charged().
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


