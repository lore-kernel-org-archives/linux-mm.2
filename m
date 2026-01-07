Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BEED0D154
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAADF6B0092; Wed,  7 Jan 2026 13:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A586F6B0093; Wed,  7 Jan 2026 13:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AFE6B0095; Wed,  7 Jan 2026 13:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 862326B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:15:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4396B8BB16
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:15:06 +0000 (UTC)
X-FDA: 84305969412.13.126EA60
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id B832EA0002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:15:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lN5NJtaR;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767809704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6gQmrBLod72VMhYIjEsbgkDI+rMTnWyrfeFXZA05yw=;
	b=m65IjbuJIQ1DDhJCkTw8Z6kFSX+fjA6q5sA9zPuoA9R16tR0m6BEt8P3K850eiQGuTYnmS
	Pj20ROMbSKA89hH04jK08lLZHRJIMlK4zlJhjDkPUPGdRRCSMq4LmsS8nxQlCrKy5ycoPZ
	xN/SA7UnuKariFHDenEf+80j8blszWA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lN5NJtaR;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767809704; a=rsa-sha256;
	cv=none;
	b=7kRj+PZytyRo85yT96pkY7dFJbishFkpZRwC6ykPa0GVhFHdLwJ5rhPz/bOW0TDy8Sx5t1
	5lOs2SOQbuS4n+2eDiH2sh0iD+WeD8iE7T8nWhCRi8uSQV4g/wI5rs8Wpx8wFcf7yzlGP8
	7223FHD0b9FlIujFj5OTtYVdil4VbpA=
Date: Wed, 7 Jan 2026 10:14:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767809700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c6gQmrBLod72VMhYIjEsbgkDI+rMTnWyrfeFXZA05yw=;
	b=lN5NJtaRtMTo4VMFcEOZZPN4+z2UhhQnzdoOLBsH+NcWlYgHwEGPikBQuMd9TKj45W8DLp
	Ys1p7ifbN4obItJklJTP5IPlI9kc/2l0CR75daRnvPOIqjxHv40GquxxjetATZQ6j8BT5a
	lPvUjMto7oLx4kBEW0us9vKo0n2w9mE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-ID: <ovqxo2mmjiuymqk36t2xydcyzvtppcqsog62yx3qtwsknbkgzq@3phadh5gfyjd>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-2-tballasi@linux.microsoft.com>
 <62ia3v3oduyt2srkaneccoei7cwimifwduarteyn2ugpmmbw3p@rivcqvcksgpt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ia3v3oduyt2srkaneccoei7cwimifwduarteyn2ugpmmbw3p@rivcqvcksgpt>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B832EA0002
X-Stat-Signature: oxyqeskzmp47pw6enerpbrdqhwxf9449
X-Rspam-User: 
X-HE-Tag: 1767809702-160059
X-HE-Meta: U2FsdGVkX19cG4MTa6kOM1EOgU143TsviL/kQhN8f+AXGdQSugJBtO/wkHEcUTvA8yBau4Ly0fOhyiUzzISEsAl53ehly7buLcEsWaMXWEwipqhO1UPduZJ4QiGCY1UheTC/SdQUjr+HHAszgaf6HNBBTQuLAUUkj+u7lZ9vceg8mvDH5PppJfNm/Fv56yR2HV3En8xk2pAD1KjGtUiufJ1mo+NXKbDGKplEzSw2KMDg+aZaKvc8xWpv1S163hhJ7YDMsAXBf3KMWWtVOY4MkLmo9vSekA1c3ORXdC6oVk8KMuqYu1LPu5rywawYDD/e/5hTkDF+S30/n1KHlAh2cX4IAjKEgvZq4SaJErFEIaTP2A2F38ghEuMPULHAOio70EItVo6TJ1mCBr7qu8CGwrOgHAYp4c8vebWjgTN8EPs/P/PuUgc31MWEao7t4mstY2KN/0OGt55Md0keUbRiBMfYxKky3qU1GwXrB8oXzLi1IIB5Br00U7C6/8BVo+Q+4El4LGNSEj7eGQjpevEIWUHTgrvl9/kGDieaKBhobvkx42XLomjwQM+V8F4qZ1UO7TNl45X+L5PBJi7evYS6aCjAttM59KDd+XDtRk70aMlyHLHBEXrq95Z9Keufw/oUfnPZ8DhlSPaULfYr192tqVVkh5eQtLh9NVkSLIQ134lJTQ0loSYUY/aqwxwqfs3zcwZFQFKRiwy0qKEW41DjyHAQXjYWLNCfepWkkl7frTysLL0Hg4DwTjTj92fmBCFhJXcGCHzZhz2v8UsBsZ7Ua2FqTEEEqTULNkCytwKN5jENn7cXVOv+GJ9SjcttWCRHPxNdDsY18b+gCsMVR0QRcolkX4ICcXwCb5Sk7jNC15ulnxb+o/9qFvLPx3yMBkwoT/Xmt84U8f2IiTN7H2Gx2isAyxvxoctb31E13lhhb60a+aU9v4xZ3HooZPSEf+A698l76pL9+Mi6h18QFtG
 K0F5MjbC
 JyKKFhihekwOxXve5UYYPAdSgTVboDzCBJAvU8kYaBQMiIEMH8pj5VJe4e6PNmoRNPQ9xoUVl0HwTXncuSgqUBeiE4b3vgAxdmkGVBYryXIbYKZiXVBqUzBRNpu3sRyfuiIekOy5KpeWSGSAzBS0JYr9YcJDB9vRE3WtiZbGoIO0KxDXL51JRUiIKDKZRB7LxMeGL5ODcmK3V4+o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 02:46:39PM -0800, Shakeel Butt wrote:
[...]
> 
> Orthogonally I am cleaning up memcg id usage and after that cleanup,
> mem_cgroup_id() would be preferred way to get the ID. No need to do
> anything now as I will cleanup this usage later as well.

The series has been landed in mm-new. Please use mem_cgroup_id() instead
of cgroup_id(memcg->css.cgroup).

