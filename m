Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C340BF364B6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EAD6B0005; Thu,  9 Apr 2026 16:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02096B0089; Thu,  9 Apr 2026 16:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EC56B008A; Thu,  9 Apr 2026 16:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3FBA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:39:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D2A3B6F51
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:39:11 +0000 (UTC)
X-FDA: 84640182102.01.F12BE00
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id A470A180005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:39:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EBAMrbrY;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775767150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+34jg3Tc1cAOq2VG9ePh2ikhel8hzpDfd6tWSVvepI=;
	b=RJew7WCea5DJ06XZIcx4UuHbWReEAyHUotNhMqpvq87lIG9KqoTX65aq1pGhsANdoOsvHF
	xJQ0CMuj2imSpPIiZ5rIjX+xAY5ZR9/3byBK3k/wDVYHVA1eRAKlXDUYMu7AjILlW1Bemr
	l9ApLfNnUurIO8xYTfdV5TqqPYy7Pi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775767150; a=rsa-sha256;
	cv=none;
	b=DfZXISTOeXskfjSVaEAeiQI4eopR1/729NXFCAgBqClFNLUi1S8pJRWIXO1M1Vwyyp3byG
	sjxCFPMxoBCz2UQxjJPih49xLRvtNoT/e7HSkFDdoJLwPeEAgh6ei9bv4n58GRhNRuYAeJ
	WMDmmii3pNzC4ydGw0gychTGdDbTCNA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EBAMrbrY;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e+34jg3Tc1cAOq2VG9ePh2ikhel8hzpDfd6tWSVvepI=; b=EBAMrbrYaPjGRUi9kRwsbPxgbe
	R6B7EZw7ZTEhMe3Dei/Ag+nxK01Nwn4gm0lyUGtPXiDW+xu/G+wx8UeW2KyeiG7EvGpDMxD7fHq2e
	p5GuYvuCWyEF1J4SCjWEbwzQ2HAKwIVpwN9vJqGXoyqoayTxShijE0ki6hQfDuJxUo2M417EU5Cc2
	KoKYbxOBQj4hYzA2QS+mL8BxIW+B+ms05YRqoH9p0XWyF0ShhO84HojHaOoeUz46Pq9Uh6ipdTt+3
	5MEBBc1nnzDrE4f+5zgWVin4UWXpR7+cjQa6b5EdJygqzmT9WZXJr2fy9ZB6Pg2+aZz65cjTw0tve
	lOQHrksQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAw9W-00000007X0O-1GC3;
	Thu, 09 Apr 2026 20:39:02 +0000
Date: Thu, 9 Apr 2026 21:39:02 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <adgOZgCfSeWjwreX@casper.infradead.org>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <20260409081619.34f172dad0e5a56923b7eb2d@linux-foundation.org>
 <adgA2IKrdStZJ6AX@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adgA2IKrdStZJ6AX@tiehlicka>
X-Rspamd-Queue-Id: A470A180005
X-Stat-Signature: 4osgg4po5ntyh5jo7ir6ebj31db6korr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775767149-473592
X-HE-Meta: U2FsdGVkX1+aHw05YpoeTy9BXXGzFm8Pc7rivxNLm+1RsX4xAe0AGUGryUOkyO/fmCHyvXlHyWheaADxK9M43bPMK/M6HMEV6xgGNKAXXESP8lDrqMKB2tparsRifZxbePVY7JJAacYELwGRI/YF1/Jgl6e11EK5gdmflH/9XpQJOGXGAOj6vPmEqp94PilFs4NAXKDYNlS43A5G7SbdGQkRQOamg8O+2BRKlT2VvupAnSA4SSbFvwL3H3H8YbDOadsWWupUKN5YsHZ2kXAmkBssEQthNFhLuhLcOOT/2qMtPR68m4pQaKenkc3O7ll/6TIWTgbTwSHJfK0Ajv63oxi8flPHhviR+oK+5DYF2fGJvAubi/nzYWOaWrOt/HoEhYOOVM68E4P6ZoT1obXoYOg9DJk6eUAR0V5BmmPqc4ODBzzi3oKVW9FEUtK6er6Im+9UG9nu2Ln6kPkh8bgXNAKAgyrDjMJP0ta8OaUmDgWib0+zAImxsVf0uPpyZ9H0eucPYs7IM1PwqxiG1+4gkQSloMZCU6lFYgbT+ViFQsxQFiVlP5MFKIf8ZkHHZPG94NrnjDIdoe4qi+o6XT3chqOf+QxFVlbjtaVSgbacrDAYo1Ki/0gSiAZuNwDFtMo54lOT7JEiZXPkL6OJhkYFWhSrabDBvjMK+P6eDB2SVF3zeFlI8QGc2VPUyo4HIMFNQ8Ml7z6Ww7E2xL8DyGxA4esj+CAysxNrDIYdjPeY9t6c3ENOMhBoerjkCjlqOX57XG1yHPu9PCnDHnWq2amYqV14qrEKyInc5QpQToniDnAZZQnlmsW46Mk1dXtAEELofs9MrTwUxkNojuY8XJReMuhjMX6+djqj0Gp+WubN6vBmo4lfZ7JzEgS+7V/LGqZ6TYXjCovbM428FCNCqAlbvCZn471X4L1LqRe0cYUZV46iMf/JtbL6iKrvZ3VZNniJus/uUCAgFmJ4pQ8j6Y3
 soLer6vp
 wY+HZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 09:41:12PM +0200, Michal Hocko wrote:
> <rant>
> Our caching strategies might not be fitting all existing usecases but as
> usual we are targetting as many of them as viable. The problem with
> drop_caches is that it has grown unproportianal amount of cargo cult and
> grown into "solution for any performance problems" magic pill. Even when
> proven to cause more problems than it solves so many times. Again and
> again. That is really sad. Same as THP causes more problems than it
> solves and that you should be using 2GB of swap space or that swap out
> is a signal of a disaster. There are more and they are hard to die.
> </rant>

I get a kick out of seeing articles like this still being published:

https://kb.netapp.com/on-prem/ontap/da/NAS/NAS-KBs/What_are_the_differences_between_hard_mount_and_soft_mount

'intr' and 'nointr' have been no-ops since 2007 -- eighteen years before
this article was last updated.  We should make more things no-ops.

