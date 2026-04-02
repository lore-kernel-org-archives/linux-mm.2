Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76EB111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFBA6B0089; Wed,  1 Apr 2026 23:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088D66B008A; Wed,  1 Apr 2026 23:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92DC6B008C; Wed,  1 Apr 2026 23:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3C916B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:24:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B0A1140384
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:24:02 +0000 (UTC)
X-FDA: 84612171924.12.276ABB4
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8410D20003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:24:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uh2KsN6B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775100240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lqj2Tio+D0Je+/WxvKF4wZKr7nks2J0BqcNs9XZouZY=;
	b=idxqJLFnB4u6GRrN4vs4bPmh8hAhu4F4afvG47cb1znhqZheukaS190ndQbnH8+CGe2m4D
	j6mi5QB9H2fdX4dcuJ0QLgU2e1fQWD5kd/5yrBkdEmxWeDSCTLVSQiRxc/N3AvVdNi4QSi
	6m9cN2UEAXOEzchLj79NkQmQ0XtgRN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775100240; a=rsa-sha256;
	cv=none;
	b=fdusXrsbU+8Y5h/JrHrnS5vRiYfnkiYAEcKexqqCuf+W6HBZhT9FM8a8P8PQAa70Kt8tPn
	xKhR5MeSo/58bjSu1Xta+4PhH8nBkjmp5Zmz71zRl3Oo3L214zT3KXIAj6lv20ksbEL/Td
	Zv+PYzVPWNodCKXTM23PDu6vWLbqMvY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uh2KsN6B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 1 Apr 2026 20:23:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775100238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lqj2Tio+D0Je+/WxvKF4wZKr7nks2J0BqcNs9XZouZY=;
	b=uh2KsN6B7yqPK29082ZutM7eQ0dyxH/WQp2cANLFVnU3V193dgA4yDbFjcMJVd0kpzPIZG
	iVAyQnN1veHmFbp/zUJ5cUAOymPvUSWcQG7BdktrDTkiyrFvMdove7BA8aQvRHfbZFA0aZ
	AhZu7U6Ws1t6vPmQx9nGWEkUt6QgEJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, ljs@kernel.org, 
	baohua@kernel.org, kasong@tencent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jingxiang Zeng <linuszeng@tencent.com>
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
Message-ID: <ac3gP_OWXGnejtwk@linux.dev>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
 <ac18iLvF-nNtxk1-@linux.dev>
 <ac3Pqq2WrGTJZLB_@KASONG-MC4>
 <0498d924-d76a-4d82-8767-e6297442967a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0498d924-d76a-4d82-8767-e6297442967a@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8410D20003
X-Stat-Signature: mt47an9fet6eti5pzz4wtrs6cbx1s88h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775100240-615120
X-HE-Meta: U2FsdGVkX1/l2enajSI6WfxXGirVKZQwCPNn6wfHOexh1a9fReJfbWrbP73bdSuxCkr0BGFKU3hIWONA+LavfS7SBFzFY6aep+DE25RvDlEqkthiGhWi9mTRqMz/Fxj7b15+r06+wX6MnXa495qnMCch5n+AqraqZ04RWFQ01aMSjLK9x9qCY4d/QNVShL4hE9W/Zt6+xpwIEkFn6gIWnrnqFmH2ZoHZRHTogK8lgtE1686uYy2qDDIam1LO0F0Sl5HIPLY4c4o34MD3MF9n2vV/i6ozXgbRBiMHCGOWuJoevn3fhA7jgHNz7kftSLactas6QwgomcHGZlxsGsSbhs0/AAg2rB9S7AiH/HO7CwDmic/i9PhRcF8eq+9DkAm39G+wX3rgHjjmzGam4oVhaQLdtpt2u68+BxquDcqp5d2y8gqmC/iykbltfsDcq0USUWcdfzxye3XbGjg4tZ06K6OFgimP04M99HnEHGARR3gutjjvx4+fr60/ukjUIpKr4vEM2qLl+uauBMXDB6rSJWRc/PTgtGOrzM58/KparaGu/K0pa3+dvt/j8H1wQ7c3TDKEcOG4yrCqwl8mdR8fVlUWaCcHv09qVTYRtI43yWcjx9QQiYBrM9qCOWRhrLn/eRDEP5MfvWyLonBgHqqJcLLq4YF3jtJcvo1LDsbagfe3dce6qsL6i7wzFVFk79b5Hpq0xHjqrcoNMPU6P4tAHStDpjF1wTxrEaQhj61JJa3e0K8Tv8y38JuLjzUrNy4Q3WyzcDF/KCfw/Bq0lawaqGAOfD44wIcJV0JfatIXc1gvZHv77CHghHI4JpIO4RhJIo4LftnS1OO7CFA6BFhbs9P1V8tqJY4x2cdbzFxrFJtZ6KHuEUyjrTFtrjYp+nmUebYdkB5Xdexc/N9S3SxXz4p2m1OTnBkZXC9L+NiIZZ7a8VmnLI1ZbmwrwrtzHU0WWLhl3nl51HJyczffVrC
 L9nKSqO5
 D+/cnYR1sLW5uKWtGqGWap75+qmFWbWjgyKaORJ8UA24rdtxi3bRrUWPMp+zxZPgNO0ct0Q7ZbDGbxk/3Q02sPZbOZOPu78CkwvbCPqQ6O+tNmx7qT/U8YMJSBsib7UmJygkPt8WDDBrnWzRp1P+npzhXLve3NDVRx5oC0cHrOoqSknJj/zt/dGHfmmr8NJbYwT9/fQQ8RsF9O65Iz9Y+l3PLM7FGTbtEaph4xzF8wgEPC7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 10:51:37AM +0800, Baolin Wang wrote:
> 
> 
[...]
> 
> > > This is v1 only and I don't care much but what is stopping you from moving away
> > > from v1?
> > 
> > For example memsw?
> > 
> > https://lore.kernel.org/linux-mm/q2x4drxpjbxcxgns6bjp446ynsxgl32ckcljqcol7posds4nit@3n3tjq35anvb/
> > 
> > I remember Jingxiang's plan is to improve the page counter first.
> 
> Additionally, we still have some existing users on cgroup v1, and they will
> need some time to migrate to cgroup v2.

Time is fine but is there any specific v1 feature which is a blocker for you.
The memsw is a known one and is the same for Google (data center). I am aiming
to provide memsw like behavior through my memcg_ext proposal but performance is
an open question. I am aiming to have a prototype before LSFMM to further the
discussion.

