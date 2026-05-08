Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF66CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EEDF6B0249; Fri,  8 May 2026 13:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EC26B024B; Fri,  8 May 2026 13:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4B96B024C; Fri,  8 May 2026 13:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3ADC26B0249
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:38:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0F5C1C06BD
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:38:16 +0000 (UTC)
X-FDA: 84744961392.22.E415354
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A242120010
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:38:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XMhg/zvt";
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778261895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdrAIbvXGQAfegQzi74gkKk8/DZVx3+v0fHRsdD9oQk=;
	b=BxhAVE5Sbqrsg2pnxOXWR1lriCrxQn+PPupZRpCd9JVQvyg7NRwyNojW0nLqtAOsEYFagY
	NoFb3XGusjVGn8ZV4eXoIQqoOARJOHm9Vqiycjn+M3w8w/rA5SHNnWJOQw26qnDGdS9wP/
	2b+ZeSH36M658joE//xQD5uUbvHOSMs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XMhg/zvt";
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778261895; a=rsa-sha256;
	cv=none;
	b=JRvV3qFlHN8meKKOMk356LhI3o7BBqJYtM3jKIRmtiiam0uO9sPwvFMXddUyfORFtioIMQ
	fbZQc1yPLvjlrG1BHli+dojo+Uh4w1EoG94xYGkoo2vfwI3+0I4+JZxbl8vDW/nG9itFrB
	KbLUl4fAU96/jIzZl5tZjiXUaP2K6pw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 730DF60052;
	Fri,  8 May 2026 17:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A70C2BCB0;
	Fri,  8 May 2026 17:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778261894;
	bh=8O1+aE8sZNGhibwsXUzGKlGSLLVTQImi02JgLRN5+Wo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XMhg/zvtUQbsUJj0jEEmzzEM1sOuu2PmK5XEbqJjnz8o2pgGld2ayg7B3R8Gv48Se
	 SmstiDzpRJMQD++m9DEwq/Pu6nQPU4xv1OqaIy/PzhfSY41PXkak32EB72oP4Ti6rG
	 uMcVYCmNg5miEcjUE3rMaaeI0s3eawFjKU9a1KMFzXzW0OereAzwNY+rHfs34M23jD
	 KxIiqOHzrUuvw8uKG3GOmDHICi7Af+HNsA+C5PHINOKJzauazTtSt4ZdZszBLQxv8v
	 8Es+m9P0oiFJzZ8g+qeYVdj4nT2saQc/XKe/I1+f1XLeSyKjKCIJxedx3amZxr544i
	 so18H0arHs96g==
Message-ID: <832e4333-4079-4865-8ad8-3dd8868fb964@kernel.org>
Date: Fri, 8 May 2026 19:38:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: add tracepoints for zone->lock
 acquisitions
To: Andrew Morton <akpm@linux-foundation.org>, hawk@kernel.org,
 Dmitry Ilvokhin <d@ilvokhin.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Steven Rostedt <rostedt@goodmis.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@cloudflare.com
References: <20260508162207.3315781-1-hawk@kernel.org>
 <20260508102948.b1c687e623fabec65580f258@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260508102948.b1c687e623fabec65580f258@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A242120010
X-Rspam-User: 
X-Stat-Signature: mxkosb3ctxy9dhg937kxo9kiatyn198c
X-HE-Tag: 1778261894-146860
X-HE-Meta: U2FsdGVkX18O1uo8fVX2nQPI29HgIOAtkHCyK/Y82+HDJdbLXnktcRH+cJxkiKUIcyfhfbNk/5JKPpsGZ6YKxiL7HW/KuDqf8d8UUsC5S/+lwuFcmIFcYi52zL658y0q+swwaW8DbZJXt9NPqnBX+AZroLU1WY/61ylsrmrDoc0rI9NLhxIqaMR1XEgINNAWV79IhbsAu9nTPHgAR5a5Mzk4FzaqOhpgEaDXS0w8pbd1dl4uGz1VtMLl+VDWU/IEQw+uNSk+Xhhyu3AXB/NGmlj5mXoPZBECtQJnOeVMXG3XsBln66KHncgEJ6hdsPEtrG8gcqVPLo4EqxSo1vyqC9XQ3g+PnYDNwlAMcYVeFCAk+1Y2/DkfoIDXCGu6HEshOTwzWP8JxH8qrYBABMe6dhj4KiVV0xVtMIdg6btrUpkevG+P9VtWuYm6s1nBM6NOqf/95zcdQmgb2S/iFZye+H/uRSGW1w3ydnbGnS5eDxv5CWe8+IX1s542in4njZw3UBDJTnfm2ptCqmpjnbnQVcuqi4np18+3uB5gZl2heZ+HxlkNTnIUHKl2dV+GSC/hiUpKkLbJJJEFz+MeGFIhtR1pJ7UQwhqh8/E2NYvd705OfGJ7/qgnCVF5iJG0FjYFnIexLng8EXYFotX40vzZt2Vt2Giaz8rx8Cloa/G7grWEKP0I4KaX1Xp1o8F+D6917UGhMIAzHVT9fgY2WcnyPWDnrHva8iM0pLY0Yb2gntAzp+NrQqEz4pYj45uHojtlzqOe6rUk3QJ54di+AMWBzVQWBGpJW1/uQ+dNYMrg+Ye994NJhUTb7CxiDCXcmLOLIPFBJY0MtENA92BRyqctl6NxPwdtPHHkdR5cypcrpGcMztZAnbTuTgyI+ljMTwetY3pzQT+DgWyFOumzNESBoYnRDMLMyva0oR+E4N3lSAghOfuQHAzkm3EfMuPNZeKv6j13k8wR/ehpVtS2kgN
 xNDf+m/d
 rCPqiNAwlBHBCgqfo2LbJo0Iko1oQscExc28W/Uowotf5Yh9aYbrK0EzNW7LBpVsTBUlpi2pubW9M70q9Dzg/Monn9/okagas/8+HQt4uKnppLmiF7CF5vHeQZfbsvUxaVVtyligF5WgQj/4HDqPNSvuPF3gvLk03wneyJ7WcE6On/a+7q159suXiACoiVUbzHgWesZ/KmPnISsvjOopfvosj0THzgEQkCAfSN+CyZRQIX2PtU5rZ8GtQ1jhSnuPzjs/wGOzNyWLb6NEr6lVuAmUP6kDFi8pmK61D7vzHNfojj2rhETs7ju9gfBN31HPwazJjPAy9CXTINh1IJF3Cy2v+fYt/D8H7BeGq+eLrFhOHI8Ht6zeHy4bnueNj250yh19rJuNV07dqwmXOrMz+1XcDnhDtrv4h0D6I25udAdxO75JuvKA3WfJ35g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 7:29 PM, Andrew Morton wrote:
> e .configOn Fri,  8 May 2026 18:22:06 +0200 hawk@kernel.org wrote:
> 
>> Add tracepoints to the page allocator fast paths that acquire
>> zone->lock, allowing diagnosis of lock contention in production.
> 
> Thanks, I'm surprised we haven't done this yet.

There was a recent attempt [1]. Not being a generic solution wasn't welcome.

[1] https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/

> Unfortunately "mm: use spinlock guards for zone lock" messed this up
> (https://lore.kernel.org/all/cover.1777462630.git.d@ilvokhin.com/).
> 
> So please let's give it a few days for reviewers to comment then redo
> against mm.git's mm-unstable branch?


