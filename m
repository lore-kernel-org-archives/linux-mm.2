Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1D8FED3EF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC156B0005; Fri, 24 Apr 2026 13:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC9E6B008A; Fri, 24 Apr 2026 13:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2936B008C; Fri, 24 Apr 2026 13:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A39D6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:06:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D75C8A4ED
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:06:57 +0000 (UTC)
X-FDA: 84694079274.01.BB68A3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DECA7140014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:06:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SXKSPlI5;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777050415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2gFLDef7K17GXcpUdvhrcI/j84uqLWBjhSOY3wi5dU=;
	b=RZ+Yt/Wfpbo2nYU636sHiy9tnI5YkCW/q80G+lWxJz+2VBB7cNxOC2e0PEStQy4NsagO0f
	xwUha0SlshM2ObQLQTlS4mqeWsAQuOAJMRCM/kW6DJ37waqf+to3wBshWg+cwZqtSBtr5P
	YmsByz3HPUtCqZWYYpPsR0dLpcq7x9M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SXKSPlI5;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777050415; a=rsa-sha256;
	cv=none;
	b=Bm4qBaHQByE/0af/GhHfq5GVXmg184LiuBRG6u/Yx1VlmShsWlNGvoka/8s2Apx54GaA97
	rX6A3NWml7qhqE9TeuREMdRWLmMKuqFwVkrWaeo4Cu96BEOKVOjvZgC+aoTELMoNlAh4Uk
	hjEPUD/AoUeyudazyKTYwBE3YOh/JSc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33A1B60123;
	Fri, 24 Apr 2026 17:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB7BC19425;
	Fri, 24 Apr 2026 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777050414;
	bh=Cq07aegjH/barrFFwd1M+y5Eh+awY/eNj97Z/kd9gvc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SXKSPlI5VBgMhrWrTOx7SwhVcEga+/4fm5gt8lsrW2nNd+A5cbnTEoIn2iyfNszzh
	 AGN6fmbFgb5qX4fW2L0zPUyY1miJQzJjXuqgexuRd8/ATlHcmmXTx1Q5/N0RUoQg57
	 1xRda5V/GIW0iKoS8M7LEVufN5EKURNzFgzROme8=
Date: Fri, 24 Apr 2026 10:06:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ke Zhao <ke.zhao.kernel@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, John Hubbard
 <jhubbard@nvidia.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mm, KMSAN: Add missing shadow memory initialization
 in special allocation paths
Message-Id: <20260424100654.6379109008b57b4affd1cd8f@linux-foundation.org>
In-Reply-To: <20260413-fix-kmsan-v2-1-9cc8a53c36c7@gmail.com>
References: <20260413-fix-kmsan-v2-1-9cc8a53c36c7@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DECA7140014
X-Stat-Signature: x18ncow9gawr7t7fraqj7rt33w3c366z
X-Rspam-User: 
X-HE-Tag: 1777050415-121635
X-HE-Meta: U2FsdGVkX192n+GjzekRYlDS4l6D6/iBziHJ7h5ynLVRZ8Ru6GF/XgNa1upx05RzD0GopP84OZclRyymQm8IEV3Wb0YHNftreklZrOU0Pv7ksvnW9qYTvqlBqgHC5LTEWFQ/z1LhPaYFMjn1eHVtsdln0WRIo7NcR5raX0OMeoWuK4Wzk2izVTHJniImG2E0iq5bFWwdAVK2PeUmgdKswzdW/QetxAk/8xkTEHGDnSBHan+V8+nh5a7w6tzGW6beUyCkWXEHqZnwz4PrRgHGSVrCBYWw0snmOf0j04VvV9pvo4AAk2R0j1J9zjgpRHJMh+a6oIYc9IozCT7NYvw/2apAwNI6vlwcYb/P+BuYN6rv+XJa4N35Hz/lLY8lvOThTmviqzeVIKS9gMkXZhyaK1Wf+Qz8exB1Yp4pIkOvqCz/9E68iNNGTcYhzSoRLLnGwB/ZNzvi3xwU0GtU9FhpwGIg0dFHEEi5TfDbUq8bTSagLlMapHE5oxkkoU4FdjjB6orsOq57Ytu8T2g4H0WuH7Y/It941NO5MKf7qGHGay0dRyZV4bCTgX1zbppbhPVScFyt0CeuIphCZLInvo6b870ZjPa+kdxS+UdZDRU9MRCjuShbVaWyl8jlJqh7apllndF7DW1wiiiliqNWw6vu0wE2Dl0KDXJvEfuSTu8H146PPsXEEcukD8ZqdtZ/Y+dsFyMuOTqgJXbtGHTUUiNr3mKY8HLCY0gwq6KySV3agamNFhwD/kyY3DV7BbZE38JMs8NcBXptzLvkMJmIetXFzIguPHzvbLHy6TdH+1l14EtniR7YcTFuLA4wATQzSBg2Dn5IPQ0HAxiiNrcF/tIXtzVElIScqKLulIeloHpRE2DLO5qSKgAep85tKIc/pfDe8qPYrqYuASi7Apt+7bGWx+73l14BMfJICgyXkztDHn1FzHr9YlFH+ogdimFvlIS5lZneTRoTdrj3Kp+9pNR
 r3OrCX5g
 Jcwi9YIJrGhroasOqHq8aofQuaTPvAyTLy3ZAHLsDfdTUkRxbGzE4XqnZZiHjyQ5/YolIHbSVPZPvDhr9MBD09TxjvDwm8lPOhyT85h4DhRfOnB0z3Od8p3F5lroxStXXygdbNvIlLvdc7UVgpoFUWzQFYNamniC/dxRw/W/7OSvpWsgudLogICqDMnRbLNY5qcZpOdpCzfS1ZH0raxroXt0CLGLCNlzl4LlrG/04Ts3KqL37Mm51HMXan97263XxY58W3bnoXYapy/29NxInJE9RTfog+lHUKzhhDLSqlQxc9vBlbaklWhhNT+0mbqU2fXPXM17GYzABi1sJ3sNFrkmHY9zEBBr2bc6RLIBCNgwX4sk3M+jw2EKs0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 10:12:40 +0800 Ke Zhao <ke.zhao.kernel@gmail.com> wrote:

> Some page allocation paths that call post_alloc_hook() but skip
> kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
> Although there is no reproducer for this issue, this patch should
> be able to fix it by explicitly calling kmsan_alloc_page()
> after they successfully get new pages.
> 

Please refresh, retest and resend this.

When doing so, please cc the people who commented on the v1 patch
(Vlastimil, Usama).

Please also cc the KMSAN developers, as listed in the MAINTAINERS file.

Thanks.

