Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22DBBC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 21:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFE86B00BE; Sun,  5 Jul 2026 17:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C73C6B00BF; Sun,  5 Jul 2026 17:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6266B00C0; Sun,  5 Jul 2026 17:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEBB06B00BE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:02:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69CBB401B9
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:02:48 +0000 (UTC)
X-FDA: 84955947216.20.93FF42F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8585A1C0007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:02:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E41w9rZK;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gCHWKa4Bf1jecM+x/DY8mFkX1R2/+i0CVe4zKSjV2w=;
	b=Q3tvDnXtJpwM7q5rvFh/Kt/WTM9LkhyMRBF/fEB+y8z9lP5l/fjFDqJGgjDSE2WJXQ+6qv
	InQzZNTC7W0kZ4DiRwk4pw6PUnxMdG+gZWJROc/cHnCZvD2ifdqBOVo5czVeCfRTZ3sLhm
	jzvkX9l+u3c5Wl/HrWHeWtYEGixg7xg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E41w9rZK;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285366;
	b=PucyhUlrVNxbDK6HOSwxaUT9H4/au0wF4EzZskAIgQtDwG4g3FxDtq7r3Q2L0LYIlmtydS
	I4zaMQv3jpFCYIe7SgK1uAs5llhVaEgVjbsoEqH8d/jLkbnPo+Q0m9vr7ixsyS7QMsdZkG
	bPo+y63+FSi+Gb1nk8zih4sIVfzzV9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 160B160018;
	Sun,  5 Jul 2026 21:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CD31F000E9;
	Sun,  5 Jul 2026 21:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783285365;
	bh=3gCHWKa4Bf1jecM+x/DY8mFkX1R2/+i0CVe4zKSjV2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=E41w9rZKWqcMtKADxjBWyRinhU1EDTBk02trbkitXaR5Py+y2r6IIWGCZ4QE9eOX9
	 zvKOQQCdsLIhG8oJDZwuDDyq2aTzWkw2N8B3ri1bCyw+vIUB4ah05nrijJAdmLvQhu
	 KXwnd0Kl744NfRIVbWFogyDhYHXhUKjWhXz8+uFo=
Date: Sun, 5 Jul 2026 14:02:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, Jiayuan Chen
 <jiayuan.chen@shopee.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcg: reset zswap settings in css_reset
Message-Id: <20260705140245.179017e8360490bc3c9f5ae7@linux-foundation.org>
In-Reply-To: <722b2c40-6d82-4eef-b3f1-245fba465bc0@linux.dev>
References: <20260702024827.353185-1-jiayuan.chen@linux.dev>
	<722b2c40-6d82-4eef-b3f1-245fba465bc0@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8585A1C0007
X-Stat-Signature: qd613qkojipx3i6urk5q5j3zxykmpsau
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783285366-93046
X-HE-Meta: U2FsdGVkX1+jkA6HvJ4YioSZ5neZAPTWnOFgWX4yTV77Kgsh9xsCkxHV6RCbcMxr/Ngoqt0Rr6Yf46LLcxRy2aep28fpw5ghH8Du0rVaDhe6MQSHZBYhmd36tvllg3OS8js7ud0VLtdmzoCLZmKQEzpCtdCOSNQGTvtYeG8zVwtSB2AQ+6Z6PCQ5HGonAmv6LyD9Nyp3tLVMZ7MfGNplM23rmFD6k5CSRYRNFYhW5PzlzMu2rgWMnMVfxY/x4Z6Hstrxc7u690ziD2Jkhw7WU/SVs381L4cL1yJmqtZqvc9infpJh5XQqJo1HCo3lhHHa53hhI32YdEW7aL1VCVM11ur0VBChZVkUoxkoI7BZT0PNqSshmmKJHWKg2Bxw/AJdiric/Zg6mvmTJCcbI6mSH7VR75IXZ5tncfxbl8qGe1OLJSGVGo0YgIDSo/cF/RymTsRMioaKyqYBG8BHy1Vjzj/zeSXJgatCUNZmoIEGZeTgZKNtZ/5IZtK8q4jHxITvWduyqEs0ihoPDc3W7fRhMZO1tjp3JpSbuoOyyw4iXh0BdqQsgX1ZxI5Plxel6a/NIot0hANZLHIIt+P7hkfsjxqqFQRYgVPiboCWPnTJE4ncEOq2K23yjyOTJl31G8MkDq/VXHB2ZXtcpU7RQRSWLaF1P+rovFlwkkqUP3AT/7GqMLHRQn95SBBqv34iFwV1xA+C9ewJ77WJKyfnNu+/INXLqg2RNfH328V2ilfFtf9VhS1lj7wvPX4D1ZS08YHZMtLl64cGg2YbhgcsYWsPxDJVz1yOD0poRYeed3q2fVCFQNWE6F69IWw8Ppr7zl98CWHdiPc0D0cANBuTFUNjaZzACzFl7fcve8G422gaelT4syUWIUWHG1mnSkmc+rpeIpqnw5a8fmcYf5DHSnjQE/y5GfP+nYDYYX0gDa7CJ+a/45povl44VXXiLY1W3912z3K/yV14hMTk/af8gR
 PLTPvfnj
 u1o611m9szPPMfRXUirNxG4IUWcrtCrJdNG26XAzLqZfvq3P2Juji6FEtGfEGk7XY/dijKewU0qP06pTxiweIZ57NNQWjlZDhvIXy72JKbIECuzLBgeyMDGwnGtBi0E0Lpxx70CCeHthzIN8c5nHqI2vTSD4jDUSWJYWxg2nqNLVShzD5JqpQoQRJjlHzVZZj9jtj5BsFOd8DjCk6kBoiyL9kJKDhbiDHi1bP85mnASFs51R8WQaxYxf6bu8GNu9aGxTtHsWiRS3i4BuGOMUSxUMxQDBM5s3CJQ73O9uyCm+WIS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Jul 2026 12:07:23 +0800 Tao Cui <cui.tao@linux.dev> wrote:

> > 	# child/memory.swap.max and child/memory.zswam.max disappear
> > 	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control
> > 
> 
> Looks good to me.
> 
> One trivial nit on the commit message (not the patch):
>   # child/memory.swap.max and child/memory.zswam.max disappear
>   zswam  -> zswap

I fixed that in the mm.git copy of this patch.

> Reviewed-by: Tao Cui <cuitao@kylinos.cn>

Thanks.

