Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFD9CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31DB6B0096; Fri, 22 May 2026 03:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09926B0098; Fri, 22 May 2026 03:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46796B0099; Fri, 22 May 2026 03:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95B496B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:45:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4B1B120A2A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:45:13 +0000 (UTC)
X-FDA: 84794270106.09.F34CCCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 26D5180011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:45:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ENLrYjDI;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779435912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72bkGf8TpFe7R7yMNosUxkxRGjLquylKLDOkA3b7X0o=;
	b=zcq1cS/IB+JOVW1UErka1ljIMeDiCg/HPvvwwaZAT99milE8ExH6HfJicgaCFSdm3AxDFq
	89E6Dvl9sq++6wea/lD9TJ+GDNnIWBIRQ0b9lhemB63E1eKPpQhwt8A1Znd3J5W+d1zy+g
	/E1Ez49XzaBNQJF3Ph28i+CVEgheBYo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ENLrYjDI;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779435912; a=rsa-sha256;
	cv=none;
	b=OU4guFjOZ8HiRQfDNoNsbGNu9c4o0NLKIDtNSWKUiQJR0B6wd9kHAgnQPgQvvWD7wbsiPL
	THX+Xis34bUVuY8bxyBuzXG7tTMMvyiCwox7y3iZgVr5J9ZNizaKavERIIPsNlfrTcMmbD
	MwOV9Spm89pcfA8BLR2mS9JcUYqYKcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEB294332A;
	Fri, 22 May 2026 07:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D525D1F000E9;
	Fri, 22 May 2026 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779435910;
	bh=72bkGf8TpFe7R7yMNosUxkxRGjLquylKLDOkA3b7X0o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ENLrYjDII187/GnAQyg9/9GEbmnQHyUDrfHVlxPS1r+9N1XUrnCRiVJajy/KEk+k4
	 mziLakPQkRE5n1+HizkVqkZ9qYX9TZxmCcuJuTxO0O94S5HG0MK46sFnRYAvkh7GXU
	 groMkIJPE/luoxAxjZf6VEuI0c7TvkWMxVj+3Ar2Y+IXtXwPHcwYDKtNWjDhkTUOk+
	 DJhafpe64hzzoEDowEiu1osDYYmyWo6w9i0hfmWCWytBqMTQIJ78Oq5enrW0GLYkdR
	 dPBJdnh0cCoyMZOl8F9cYTq6y5TCB2v0H+XQsUE4VLcRNP4+0FWkqD1LMZVmwE4EUy
	 Yg3TlLabpy82A==
Message-ID: <d9c882ae-3ac2-4466-847c-07823a22f257@kernel.org>
Date: Fri, 22 May 2026 09:45:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
Content-Language: en-US
To: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org
Cc: kernel_team@skhynix.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 kas@kernel.org, willy@infradead.org, baolin.wang@linux.alibaba.com,
 asml.silence@gmail.com, toke@redhat.com, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260515034701.17027-1-byungchul@sk.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260515034701.17027-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26D5180011
X-Stat-Signature: dc4rksxmkje3jd8efxktgntiy9si4e99
X-HE-Tag: 1779435911-944112
X-HE-Meta: U2FsdGVkX1+xpeKVVpwMEwilIJQsE4rL0cXwZMzYIkssF6YXhfTSQFMAaq0TChiD4dcmxJ9hbXas9aj/sHlvvBMcUqVYxD0/0kUYEYAN41lOLL8p7FuAfXuDHYYqeVZNuioonKdFAyo47wiRTEMDIeGU/8DUQTKDo4z+F6GF9y1e7/3n8ADi5x+o8ysvTha/DYo2jh3a+WSCLbSHpMUnHkar09EfzKBEEWYlXO4xB6ZrPuXpXVoeI1M0rTpflXLVmUFlOTTrHy804cS6vy2QBeotDsM5LGwYTqsECYMZYUi5Nm7nJZlxfNsjlTJNOMb2Kr2NPmsXmOimAioupNhbML7sPAW1ldTRfnAd32TJEwU8L2+K8lDMvguTpudIBURky8Z0M+VWmI3d4/0uQ+JOvF/ecMd4TYOEdxjqKvM1qFwcXrEw8rVlnfxLvx516P9VIp43yvLVzjUYdN5xMskcSQx2ET+ITHtJLhP1MXqIMKchobOGe53x+ZLUQQQmCYf8i+UKX1Rcy+XPc+XGp3cUry6emEowWkCTFLq39L+ni+wby7WmZYkANd043H5Uthv01/DTTTyU0aEwN/ucCR+A8K2kGeB2TpzCidg28b2V4U0NoIBKn8eY6rWfrT+YVRMy6qMDMMB2Lo6BI4AjLNkaj9eAZJQGlRNlhs71lU4pzrzWS4+XkPw77BK3C9JzedNgPQlm79xLhY8GzdLKu0PM/cmNbGEQ4nJ/YUyeVpz/lHovJroA0IYh+LkcfJ/wLB4KwV6Xc4UQfTcbsnMY93fxAwXuM5Sg8njjNKLGcdrw2AaCviSOxLGkKAQ02rwF7F/AqIUUJTIcMImmK3ItYLvJCsBYAgnDs46j3stT4f9dJaJKfvsgMMLNrd2UcJZ20YFuzEdYmqiIetLDL19x/jwZmJjTJRqeUlkXIRGpOL+RpInI2CzREY18FNAfBRDx1Z124epIu7ey2AY0463tPZp
 E5QnorCw
 uhm/H+dTu5zief40iqEBxvMe3Cs/0LjLb018w06qAUqS9mDH2B3K/LechsU13867vJR92nPRM+ho9LhFrTmOQOLZ3SO2Id8DIDHfu4SlC25OiSxYTbRWoETT0uYl3SYwrMJCdl7dXjmgyvqwiQvjIkBCQq5gB0JDHZF314NEVwqmCAwbk1+W8JFw1ffU0KSa6lDdhcmBHX1ned1ni8v31lxjBXbkYG3j5+ml307wX1p+vI+VDAKCGbq4ysp8lVy1hb7douCaY14dRl9jHh3TKOBa+kG5Pr9Da9Aepma5aJBsBwtneXNm+gqdpAsIHttahc2h0OX3Ts770js56VtqyAUC/bPdCxrgNo38L8FQ8KsQ3iYiekHZ0p5Ero73AXBj/2xAk7K4kirEEy2IIZu1A5yJPV/Jc6pL7Ab7X6ByPyWaYlp1EM0voCoeHhEZzw8ZlUyY9A3RJFlYazkkpl8UcJUkaPX9JlGckM7pq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 05:47, Byungchul Park wrote:
> This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> 
> Netpp page_type'ed pages might be used in mapping so as to use
> @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> struct page, these two can't be used at the same time.  Revert the
> commit introducing page_type for Netpp for now.
> 
> The patch will be retried once @page_type and @_mapcount get allowed to
> be used at the same time.
> 
> The revert also includes removal of @page_type initialization part
> introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> to initialize ->page_type"), which will be restored on the retry.
> 
> Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> Closes: https://lore.kernel.org/all/982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Unfortunate that it didn't work out yet.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!


