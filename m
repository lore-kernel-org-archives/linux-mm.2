Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A65CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05F78E000E; Fri, 19 Sep 2025 17:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD638E0001; Fri, 19 Sep 2025 17:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2E18E000E; Fri, 19 Sep 2025 17:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC008E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:33:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 687A611ACFE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:33:18 +0000 (UTC)
X-FDA: 83907300876.30.DA1E92E
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA85220010
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:33:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hF8zs77A;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758317596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Px33pcPC/3cjqyKF20QTwtd0R9MElM1aDgx8WhLopuE=;
	b=da73ER4OwEw0sGWYmJq0LSGbFJaMGltWmNJokbtyl8B3iz79ebU033Tjyy3zBFdisCf8do
	ENi1ePzM8IS6Q+TL83IOTSH6iPHHpLum9s4jwQFPop7/DDhZKCrqD6+O78ZtJuReqouvjv
	Dl0j6foFcV8XTQLYdEo1/qxCnCl1fVU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hF8zs77A;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758317596; a=rsa-sha256;
	cv=none;
	b=dombB18bBiTZXd/WEpIPbrpA6XZi90YNOt5zb8KYTZ2r9IuiwgCtGWuWg/93STa4zmqLai
	DZf2vDWlyDB9pPKcrVtyvJJG7G9w0t8woZijt5tIRou7B4scyDXBfU/Qjc8/9n01ZSDA92
	hjrvuYkRHbztRaRO7TmGzPXHedwyfHQ=
Date: Fri, 19 Sep 2025 14:33:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758317594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Px33pcPC/3cjqyKF20QTwtd0R9MElM1aDgx8WhLopuE=;
	b=hF8zs77AfTFqlzlADpfZ/I7F7naSbcZ69FSeZIbmveId4wYFEwCfzXnvB5Tjn0Gobf3UdO
	hAdxcxsrW3C/Mg31+iUDWuwpH3FbvB/BbwVcwKoY6fvkgvd+00iOU5Gk4BYUEevJML37Wh
	qIjX/uLm5bn1uKBDZXMUdk1dq4tbzTM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 0/4] reparent the THP split queue
Message-ID: <svcphrpkfw66t6e4y5uso4zbt2qmgpplazeobnhikukopcz76l@ugqmwtplkbfj>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1758253018.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BA85220010
X-Stat-Signature: dq6tdy3zy9fumtc7kerco5eh1cw7b3aw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758317596-49924
X-HE-Meta: U2FsdGVkX1/SoQAB+2E7Q8p1gZHYdA8vVu7jMFsPuqjW1d7zUOdfpKkIHVvnSHCYcRPfmpuyFS+My0pdXreB/rXypdbYb85nPPb1lSuiRH0QR/08INfx50n3/P4+VKD8Whgf1nL/RqVP0Oc0k7Yr1vRKF8bJUGz/qrVQkJGYFaMVNLxE0ikJX50ml5NP+h40IT6xvX72WzdgVu+peKhM+TSA825eGhtnS+UoVCccEslN8SddxpGF441CC6jOizu1qGAqNgnhcJ7wTlZzucNoOXyV6LG+h9RfMeC3rz1y52DUsjiVfwr7Xn8p5/k8eiDXxvkeXESD2AIOSqi4docId+m5PEXkhaxRBVmvlDLhdwvvv2XVuENnJRRDkoXF8MI0UmG2Ekr3pUE2Q79sKGOuSdGfiM9JZyLaWNujJcJv88X3dNsY3Ho6b9iAWkz2CFPlF51vUDlX3jbMxGrQiITeK37yvHMVPyt3WnDps5mgmCjOyiGY5xsG1uxKl77xrDbpYAcaynqSkpNE4QwbhwGJ1YFtbep3f6H0OMox8ogeSfYt5P5rhRO27dCma8DRf2iakjklo/n+G1x6QA7oxdRRE2FE0eOyMwJvXQByU2aFNnHyqdstEc7DnRYs1xtAShR2NOky4W2HN94uL0CbK3TwIx81r2YnmtheL0a7UJTTdO2yw5+a3dChR5df5rUj8TxGJqHU9vfbRiHdVewpkz6tAE8twVg8JE0iSrBkehGjorUdZ2mTn8o0D5JTyNdRboKN/z5lwoZBFh08i7TLx1mxQLK4nlzzTdSrllD30b1nHGyZSM20p3VYSrTBq67W5n8V8EwPT5iGlCeAA1/R2aTEPrS5hIAnhZgJ5uFK1j0BCx0S1/tzr4nRQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

On Fri, Sep 19, 2025 at 11:46:31AM +0800, Qi Zheng wrote:
> Hi all,
> 
> In the future, we will reparent LRU folios during memcg offline to eliminate
> dying memory cgroups,

Will you be driving this reparent LRU effort or will Muchun be driving
it? I think it is really important work and I would really like to get
this upstreamed sooner than later.

thanks,
Shakeel

