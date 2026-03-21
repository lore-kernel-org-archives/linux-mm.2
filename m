Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6111099B58
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 01:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6A26B00CE; Fri, 20 Mar 2026 21:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE496B00D3; Fri, 20 Mar 2026 21:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B4B6B00D7; Fri, 20 Mar 2026 21:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB77C6B00CE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:22:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1720E1B8012
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:22:31 +0000 (UTC)
X-FDA: 84568320102.07.BA68B90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 39605180007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:22:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=easAh+v6;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774056149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3Fln50KPb/i+9ECR/br1AXjtqVc8affVPNuKf5dWOw=;
	b=Pt9wW17LT64DhOQhpU7KVewrQTTxwgiJBGdLmyeTbwUblDFVaXBAR0ScaY3tVtA9Pxw1+s
	M4CZSJ/AgVteyOHGaGkDJHau7+nebwLK329fgRO4VY3zB7q0Osw/2koVgIMYu/2I6TdL1r
	B8t2OIcw5xlDWiUpmivGrUPp+YDY8Mw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=easAh+v6;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774056149; a=rsa-sha256;
	cv=none;
	b=Em+EXCHZeC/oa3wukC0pQHmW3UC9jXb5+KO2YeYt7At4WXTr2xLUSrEgWSwSZu3e7H1qJ6
	iNZGKxlUcmhRp2FnY9qoeI2Z51SsgwqUcCnIxl4xOPr0rwol14gJqPUXFmbUxNyXDTLBrd
	LYIlO5rtC36Rkz2bqWClGXZMoTaGrGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C3EF60128;
	Sat, 21 Mar 2026 01:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68BBC2BC9E;
	Sat, 21 Mar 2026 01:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774056148;
	bh=HlmLa0kJjSeCy+9OOKWr1Fj+zLQ3H84FVLAmSQm/oJQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=easAh+v6nKEqi/K5Rfgeb+BYrIYk1k7fMvJxHgH7HUBuLhygBVECCC12LJM7dP7Gs
	 fbRON4QcPeWd/gQjabYo3jMc22htOLARdKjjZa9uRtHOLx+HGCt+bQhkaOoDnimkzK
	 um3RhFVH8zZl/vTxnUQ9Kedx2n9BvasF6gwd6Q5E=
Date: Fri, 20 Mar 2026 18:22:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 0/3] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-Id: <20260320182227.896f9ab62d62961b2caab5f7@linux-foundation.org>
In-Reply-To: <20260320170313.163386-1-youngjun.park@lge.com>
References: <20260320170313.163386-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 39605180007
X-Rspamd-Server: rspam07
X-Stat-Signature: 81m7rmttgqf5ijes3hiotftr7yk985an
X-Rspam-User: 
X-HE-Tag: 1774056149-617296
X-HE-Meta: U2FsdGVkX18vS1NWbhq8aov6BAuDwafjJniphEIaQ+LQeHiVm/9JFLhYuTcoAVDnC9iDQHJQsk4542+WKHF34XzzDv2qpwi7oTcOUeJCRsIlolCwBfV/Gfze9i8QlWrENV4504tJOO2ICaCZcVVlPWswsC33VVUTiGvk18vNgVc+c40iQ5OpgcwqNHxfs4I5oOwsWFJjQIpb2bzhDbcKvNVrR3suiWmrwEO0gEUyT2Q3Sig0MIV6D7+SB7yIyrFZcj64zedK5zthjoVyqvUDCwmbA12X3VrJI8PVfX7XGNxXmuRPgxVTvkS8mBzXRJGO/cbNmN3NnYtF2pMpHCfhut5uIzPJQo3mNI55geXj7SA6yHopq6gcw/BUb+hDMjgQ1uqTNf316yd5+p7m5XmlFEJkYLeTjjqkmeKAtg5oQuQvD3U6iiV8UxTdvK3PNPFR0hVPDu6ou4Fc5fPXS8hQPc7/OH01aKM4ryHZBjm0nFPOMFUhMabQnIls85/zm1fIYGQKr93CBBp5ikMuOKYtzfjS39/QwOECL+SMlTYPAUx8W14kp6QS2qBpuLrA41t0roWgDddGbNB+v12Cj08KWgKJOeAo7/yfFkkzqY5nCn7UcTDHg+urTbuBFdgOcQp+oX5wOjZlvsgayDUijAQR0Fqqfo1ZROfqKRZ/TvT/SWxFx59sIYLEk0WX+kedOGIAks6NxGmW25QIcjK3dLzMvJlXD2SB1fMCyOyShrua2RbN8UpJLJM0txWvJ/jHzcZDFcUkeSPppDPmXHZEs9W1QWlERwU4jYite/VJQsq7ZQeMp5VCb5XLnY3Bpj800BbwDUWnqBb+6E3c9lDXfF0B1CUgQ+QZ1cZlzSq4wIV69ursRgiK8lXeFiEy5j8wdxjWSDV4BserwmERHUQS1TIQ8HpolGwwf4uUpnZ+dBXH17TYPRg1OPv5nVmdpmIa8bFll4kOS03WExtXuJxupkI
 rsVOxEhQ
 pEk3Gl5WxNBPmCJUabkI/xxMnnEidG/2aIWGNeAUkyAxW/lVH6+R8ySWTZ30e4AfdGsAqLQA8rExaOPZ/AirqNpav9BlYnnlA5G3cTsXhx+ePJ5xheYA3prEtGQGTwmgk5DU46Pddl1E9jeMt4IljVKA6lkOQbXApdq37SOZ7TY5ZRDfuN+JWJzZXvljLCfFoSSi0j8K0wNXPOxn8WFJgeGwgovyWEm56rU91gP45ZHi8if9qCY+gG6ywQRHd2AcGVH1yAR6OWqQNeAh2rXi3z/KBan+kK/yKtmXAJuOraL617fgXDW4VGzDnRDqgKrp0OUCsR4VicJWLMKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 02:03:10 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Currently, in the uswsusp path, only the swap type value is retrieved at
> lookup time without holding a reference. If swapoff races after the type
> is acquired, subsequent slot allocations operate on a stale swap device.
> 
> Additionally, grabbing and releasing the swap device reference on every
> slot allocation is inefficient across the entire hibernation swap path.

AI review has a couple of questions:
	https://sashiko.dev/#/patchset/20260320170313.163386-1-youngjun.park@lge.com

