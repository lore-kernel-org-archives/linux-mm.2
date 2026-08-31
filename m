Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F60EC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4272F6B0088; Mon, 31 Aug 2026 15:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF9C6B008A; Mon, 31 Aug 2026 15:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315F86B008C; Mon, 31 Aug 2026 15:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED1C6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:35:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CA571C16F4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:35:34 +0000 (UTC)
X-FDA: 85162568988.24.2EC2FD0
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf11.hostedemail.com (Postfix) with ESMTP id C87E740005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:35:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=jo8BJEkH;
	spf=pass (imf11.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788204933;
	b=D96p4UwooT7NCQkqM2q7aiVsgOGtc29A7H1z8C2WHrWw1DlLs7yMd8oqG70OjE6CUIGLHY
	6SjDRLxGr/pTzb1xl/s3PJsl97gxbqw2PBLoy81H2t8A6oGFU0upI+M3XjFcr6WA/5aXjO
	jdbp98IdNxRu8abWxchS9unhB36tosE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=jo8BJEkH;
	spf=pass (imf11.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4r5JTAjPRFzGTRUhOujGcrryqr5zQ6kDPhKqu52nI28=;
	b=xGspWGMncHLHqVWiyrzj3Y4WGtg6biD7Ek7jAmB6XHNpaGKSepK5b6QJYTcKeWqJ0icOYw
	dtxL2tsZD9EPLbzqiG0JaH9Qz6e/bdLgql/QODnP7S9zBvv5UPEnoSX5b2YAJQbSqFeUBg
	9QCTIMYBRtuXAtUt4pWix+3qL+dgt3U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1788204930;
	bh=fbQ+sLzbl7DOq8wHn4LVm6GA/66iK3V+I3RoWGMTJKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jo8BJEkHk2QBSsdYWRtzHYxDzsa0g3BvuCQEno7mmDGYUAYafq+jyRTHUH4lbMqCM
	 fUgt1vNegJDVYvZDqlFKFjSDaDUth4RG2AnGvxbtjIUntewpFrY1pbgvt4ljEtz/aZ
	 c7mF038QLb4q4+l2sXXxrPgAdPNMHGioVMA558us=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id 623725F579; Mon, 31 Aug 2026 21:35:30 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:35:30 -0700
From: Andi Kleen <andi@firstfloor.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andi Kleen <ak@kernel.org>, akpm@linux-foundation.org,
	liam@infradead.org, ljs@kernel.org, jannh@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <apXXgimKxgJl57qo@firstfloor.org>
References: <20260831143511.1133029-1-ak@kernel.org>
 <apWUsc-a6k1YkuMv@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apWUsc-a6k1YkuMv@pedro-suse>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C87E740005
X-Stat-Signature: ctq65163eyhyi8m6h4c7fgd44wyhjj5a
X-HE-Tag: 1788204932-926683
X-HE-Meta: U2FsdGVkX190XLemOD4A3LHEDteI2lprO1br1jl43CoXYuo3ekBJ+cQuhVcwq9YIWucsYpDkbqqoPET+GtwnaaC1DvAE9CBZo0JOj1tcEsns76FLTeJKNFCxwfpaM5bYwM6kHy6W94NgXVO3RMJILUUcaWahFczH/YRUoH+NGQpHBzfBK0FOQmFMAdvn6c7EQNI9XUZf5RSchkCznj0YUjsXV7UJRVItofPDk0aP5ByY/3wB1Csfyro4el3buEk4uLk3jki72G1nUSIIi2FZO93zLhXnAWDr5MUUQtJWxlTQopd7gG8ZlWeIBX1bvj+K5cidt6fW3lvncRnT+lkwcxDDntT/RnlaKdzOSUomGcQnfAZL7velET0ucDkDtDOzDomzs1L9SqAdH+K6fXIHaonHwWvsmwQVeh7qTGVqZLGSn0TWbE/MG+FwuvmTTfGjGu2JRUh4PcKg9SFmuciXZv9h9CGL1YIoESYav86VAVMD7J7ThR3Jv8wHr70Doo0i5LAKxXehEviKq5/6XL/DAX7Aj10xiK1VQyFhlkoPWSPF/jGnWhc4eXV3eUJRR6tP+7Re/J4hc2ahMiXMcwyDrKmbQXgAkmwaS63FkmcPEQZUswvrNW8gJx1xe7wq8IiDwxls5gsVflW42oD0z9YVXhjJ43ox7qeOtIcSc36VLNZLEYlp4jiLFHjqPx760zqZsrEQM38U4QHD71CAy4ZuRdktXsRcx59/UNohZ6+7Whet74aikmKGO9NVKD+nzINz1ifdZn8dhonMOA3pZJNhNKLhixEO70F5KKZKnQM7OIAjXNEtK9BdCZ0+rmyl7gDbvF35jD/vBMFg3Zl1ZMxTVqUhvvxKWKx1+T9Rs4ga5hfni4hZwxN9PGNZAmWkfBIP0mnE45ZEs70nUpvFAvomDXg7imnS8ALQ6Z1TpE1ATusv4j15lwSLd9yejGwuz3mVIsf+2FQlm/sS8OzpqVa
 LCZd/z9J
 3VB9xQ/IWYOXVRTpb1M1pOT5HdKnZZiMY8hj40HTrVlNVZFrVxDmoPpfikqXBPZ4hCEpn5yT1WnSvA2j1G/CjIt3hpFmbdIyxUx0nQzVwaEwCpE9dVwJVOKqAaBKGmCt1hHLbcSfabMrrQmcDr/JkOI/YnE6bcqFiErYZQP9LfM1rn9PeqOExuZS+IS4O/EHV2AnHcn4kEwLMwjqeBWL8zI81cfLOcMTyRKyh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> But none of this code uses RCU? I'm confused. 

There are two classes of callers: ones that change the maple tree while
walking and those that don't. The ones that change it use 
kfree_rcu (if that's what you meant with "use RCU") because they can free
nodes.

The patch changes both classes, but strictly only the ones actually
changing need the change. For the others the existing locking is
indeed sufficient.


> The maple tree state should not
> be keeping bad state. That is a bug.

It's more the iterators caching bad nodes, not the maple tree itself.

> 
> All of these functions take the mmap write lock. That should exclude
> against other concurrent changes. Using RCU here makes no logical sense.

There's no concurrent changes, it's all local splits.

> 
> Does the kernel say anything interesting when CONFIG_DEBUG_VM_MAPLE_TREE=y?

Was indeed missing. I'll try that.

-Andi


