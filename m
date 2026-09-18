Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F5D2C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 17:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674636B008C; Fri, 18 Sep 2026 13:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625156B0093; Fri, 18 Sep 2026 13:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513026B0095; Fri, 18 Sep 2026 13:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EC656B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:13:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBF0816070C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:13:53 +0000 (UTC)
X-FDA: 85227530346.26.32BCCD5
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	by imf24.hostedemail.com (Postfix) with ESMTP id B032C18000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:13:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tIvxKBhk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tIvxKBhk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789751632;
	b=lHOCGRzWnhq9VD+LKPIxdA2k5IzNO/W2haCxz8R9HhniUPKNB+x8/kt1kHACQbm6DN6id9
	AZ7gcqul/6AHnEmE+BVdtDR45j9GvzO+paRd/+Qj047BdXzPoF2tStTSgI4oRSrrKLMjFD
	x/70OHCnPfNXrfV/PcEIVgtGhKGzSIc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789751632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5jMG29jRuJVc8t68lBUcKrwpKK8UNIt37/XeZ/o2Xk=;
	b=Pe2UpoAv2xKqKnvdoQf/yiXOSx2Dy7b2R/x5K+vUPBS/E2X7aZAcjXOECn1jZ6iyHKfcuc
	cShlsPpMVVD5fmFXNpXJLvA7kL37k+T1wxSCJUgRRv6mHAqrtToD89H3ExvqwhicbsLwVp
	hfvf7ehSIkLfVioQgSmA1fdzoUkDsSM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ndCnKZX/bEAj9SYGxAyrtcS4Yu83eV0J3O5oABweiBw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789751630; v=1; x=1790356430;
 b=tIvxKBhkPyO7goTYX6PJmqef51HP2r+oLbI5JwBsiMhX/5IyxLK3YKKf+4Ax8qXsJXfTTWJQ
 TdOz7DvubI4E0BGpHsrbZUpgsVUG9kdnak8lYASp/wp0W8Xvv6ZI7pGiYzZ8uyHivEdkaztuPyy
 NMBTfUgdGYYV2T1AQ3GSehXc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9871b9beb432cad4;
	Fri, 18 Sep 2026 17:13:50 +0000
X-Mizu-Trace-ID: 9871b9beb432cad4
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 10:13:48 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 1/2] memcg: remove unused page_memcg_check()
Message-ID: <aq1xPIhfzvUUINle@linux.dev>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
 <20260918165601.1014666-2-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918165601.1014666-2-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B032C18000C
X-Stat-Signature: zrwtukb6kiscyc6a3a9mapuxxcj5157r
X-Rspamd-Server: rspam01
X-HE-Tag: 1789751631-363018
X-HE-Meta: U2FsdGVkX18JhU+3d2B9gtZQOzAQEhYDJwiLR27Ui+Y7850uxl8NbtLvJ2vorBf4TcVEXlwqgX4yjel/tmBc9KitNqdM1aInvaoy37Hapmbt+HanrYisShe+FyWppZa2zndZm4sDZU1c3YEiPkX3I8lp4bFbQt3TMRbXrVR5kgMWxRFcvKR4vGvPVdzU/ciY16I1epeU7G76JRUWA/WjxOi860DFc+DvbXe4EiNYF/4IHBy/4f6IHMOS5Sa8a9puzFNCCVTdBUIWGv5iiXF6IadkirwZbUK6F8cjeyNkJj5jgTFK+v2lntBVQkE5pE9942P/jT5PT6l4AFBGDmkxc9H2UcuWmKkCbH9HHYP2sE2Q8Dp8YBqQCHWOwuo4STOq/OEgJn27tudUj7WU2jl8Ovysy1ViSv+TowsHABom951BJ4Q/uQ2TYaAhVuAlvylJ2dGnLzDJ31OOEZjZjD46D+/y4F9+qla3t04dLneNp53BhMCxMb9X8cNmsyRjkDEk26khHC0KtLV8BiFU2WtBv8S+uHocdmkbnmDhmWuU0pZqwVCJLgjDAawMWtCnjlnNsg248O8zKbOo916QXgHLRY6TAyWdp15h6nvkjAeqVxJ5XVxtT/t74oi5J6DcKjD9QDd6/0ACT5tFYOBT78Ir9ZtVsCLSq2qRC6kH/IHEwt0s0IQka9E0KjtFZkdkoTZGKrf9FW4BU2YLU/tTOy4CeePJi0zOEeIL6M2CsB3kwtq+BUr6xPtaT26ccFkSgVzWEweXbjc0jaY6stkFJE9WUA/uV/zbmbkuwU59pOvlNYcbzwfqRUDRrP8V8ZKNFPVGHM2cta/t9T4hFpfHhtWjDNWafB7XKUi1jKJydzzbgWfotXedIVJ4c4CXBRhSKpddCZNuo0GHEylJBZhB6AeVYBdVmxjTLVcoD3lIuacipd58Zh62tnPHsFbOX8tCpHByJxr9BDXJNiypexfoxFs
 1poY/Fke
 PKFPlw9r2mICHleknjIh/1I//cRKWYWptkC8bvSfFYXBKZH5zvKGpx7xSPKN3Poin11aC4YD+XTOdgcjlAxGtjd0SD9LY4+YEgLJ5U7/T50mroVSd2Y2eXkyAVJrPRQM97FByCXBeNV815Urt+LceHu2RSn5nI94wuDGtroq7jypv+aumJgf4oskymOXINq4S3FiBokMOaiarAJRtKS4Q9UkIhipAcvU0Guzsq9Z0GusmFYV0By46INk8UJyHQVrFonX5t5DvFqJ21o9sgdp+3tCTDAd4sc4WuWDjr4XpaT9pfuA+M7XPZSJClCzwp8KzDaLO8yQWj0IUNBu7YHYzIOjHQpqYKTSUlNh+b+6UvhGWIu6334AWdRIajA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 01:55:57AM +0900, Sang-Heon Jeon wrote:
> Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
> avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
> callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

