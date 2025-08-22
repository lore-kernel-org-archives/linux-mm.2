Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2165DCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 16:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E1B440150; Fri, 22 Aug 2025 12:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715E78E009D; Fri, 22 Aug 2025 12:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C3A440150; Fri, 22 Aug 2025 12:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F00C8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:58:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 220AC140269
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:58:22 +0000 (UTC)
X-FDA: 83805001644.16.B153FED
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id DC2101C000C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:58:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZINRpkSL
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755881900; a=rsa-sha256;
	cv=none;
	b=QlH1bbMX3D1uvNSv8KfacYTQ4zWVul2JV+J6g4ebd7Nti03FQIoT5MTmGjgMJaYTvJMXCE
	A/O8Pqo1Tb2wb0eDbS/Vwt47acTC0lCXkI2vZrmRCpU4DUBDYl2dpnqqJqMEHs9jXZZkaS
	+k1J4kbVs1hGyGulIVAkppd+dAL7388=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZINRpkSL;
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755881900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKdbhKjsfZrzfYbtn1iE/cK3FQ8I6bHiqoIsBnSCrPQ=;
	b=QxsuYJXjZAMtat2mvwcWE3wwnFC6vDGvnvawg72X3GSY3bJbuyw6UBR7RSGwh7Lc/MN+Y7
	kpYTwKd4l6AnknFX+zeYPeLxlurDc7WsQIexo35e5cj6SRN00wGEglRh1HOW99vM0xELm3
	93p/aloIU00RyHAgK5MBZjwLFUGZeHc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=MKdbhKjsfZrzfYbtn1iE/cK3FQ8I6bHiqoIsBnSCrPQ=; b=ZINRpkSLs+zzHOpnO/AeTcLNTx
	7ZG4vzDmX1ipSKMRU+fnZn0agxdGZbZdjHkVSREkYS1xhEsSmvMK7iJ+Ilm/pW/6GuUlMHa5L6Uw7
	MNI5QuKzn0DTlYDcFV3/EHHEM0fACDNrZ0he4MTi43kKskVuuJ2LvO8u1T89RbTyOkQVe2RfX5Suf
	7nH/vi8G1fLCPKf595NZDHC3XIt5BlSiQhKCj4L8kaEnu5mJzowQePe5HbjAymTGpr4i7kOHC/rfa
	iF3u1ulTAXl5Ge4K90XNO1PmR4CrclcsIu24qcsvPvGYEFkKeunmP02Up3FTDiyUMy6S6PC1Aiv16
	LBTdrJMg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1upV5k-0000000AJAe-1UEg;
	Fri, 22 Aug 2025 16:58:16 +0000
Date: Fri, 22 Aug 2025 17:58:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: ksummit@lists.linux.dev, chrisl@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [TECH TOPIC] Per-cgroup Swap Device Control
Message-ID: <aKihqI8PWLFL1b5i@casper.infradead.org>
References: <aKgm+wisMipLqnL4@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aKgm+wisMipLqnL4@yjaykim-PowerEdge-T330>
X-Rspamd-Queue-Id: DC2101C000C
X-Stat-Signature: 7qia31r9xxzt5jgdwq7szu9tajbqxomt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755881899-374271
X-HE-Meta: U2FsdGVkX1/Wbryv0XiOohhS7jkKdNa64ANYCN5M9aqi/zw+NHnaW8Y9I0ABsyDH5YECsAp7ept7mclNjIXTLL0qz3GwLTRvj/9O239UyuUC6DEleRg5rwz45kwEej578AtwHwMcaruNwwXvuXeS33M4yhiCv9ExUMT/QHd0uGw+BJ1ZO3g2uovP5kJ0Khb5W6y5qmVlzt6ETO4zVDvyQm9y6wl1viS1GjLl96s0o3SOteRMlPrOrfN5p/0+qDuWHG7w5gqWbT8MduoeRi39qyDk+vp0iKE2VCAnRsRgdrystNC0ioDX5JoIhspsK/IkpLXTINT4tMyrlvLp6lXsfEMG+HblbCOTiyFguV667oPROOfkaG5HZv1pZAjTRb31saeJBnQg69Cwqey3KQCxAWouO/MAzTJji3yA/K1jUwKTkWGvnlyOjdVAarjZqaDNmr3T7pjORCTLFKd+oJxwu2ZCTRSdpWiKcXhmkxxS///oYihiEEgeChf+mQZSukBTNU6hZ1hW0NXcs3ecrkShrv7F9zLhNAnyXBph7vpa37Mu+iuMhGBS6vXuZF5GlvZxlml4ozC2coEF/nwC/FbYfR1oJ9/BZjQfvaBYqOgFbl0epeRL2NG8/QxbIInE21w91BNANF6Eg9XuuxtwGVJAa6J4DxVd1EgPr4cwj7nR4k16sYsj6S7BLdRwEdMAbyeC8Ey190EVjqSqwiEH8UhHGGQaTsHkfmn8p4K4ot3L9WzLwXysrBE3kGW/xH51o7glFzFVlHnALBHp+shlanYqRKy35BvtaEgrUAxRZ6WVAuxLe6H7eSbaU9w/Y/LsyNvENzsVaPIHij6CpNTs0wqnvmhBJf1r37SEM6EHc2qzCmatE9X8+7FH5FsQCwsMHhFcmt0iHOmS5LYqTFTkMEttXyixC1OoGZNuXGjTGoQIjTL7Ua9rpYvo0Lt8aI+21Qs/YHaOyQZuwge8tTqzpTf
 GVIMy+HQ
 QbreEfvLsUmls1HicOnRZBvr7nBvdCfg9kraZ5fJUvx4dcF7cEMSMlCtz543hwd2V34c8xxrShf+O9wQqnrUwlYOymBF5+ZZq4dSB3mH+2jeKgp+rpQSZv55ujQyCXYea+akDXtEdr3MCsXFlBcJsZA0IVwHXXzcsuO/CgMcJgxtebHqsfvpB2T3UuZ5XpmS50wNm/sZ2KJog2M2HGLg8xYuOse+VNYxJ1sXrCt118HS+qIzpNO3RYSslisGLqlwaumOj+HxcLG2gGM4t7hJoV1ljbxv2IZCiickFAYThODiV4WWxQ5DsmQgS1T2Bo0SOnatPLaYYCqsuqMCE+FeMcTFCDcPnMx9Dt8o5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 05:14:51PM +0900, YoungJun Park wrote:
> Abstract:
> Enabling cgroup-level control over swap devices for diverse workloads
> 
> Proposal:
> I am developing on a restricted internal platform where there is a
> technical requirement to use idle devices as extended memory.

I don't think this is appropriate for the maintainer summit.  You
can submit it to the Plumbers MM microconf [1] or LSFMM in May.

[1] https://lpc.events/event/19/contributions/1995/

Also you should have cc'd linux-mm for this kind of thing, adding
it now.  Preserving the rest of the proposal for those who are
interested.

> One motivating scenario discussed was to configure background processes
> to use slow swap (network) while foreground processes use fast swap
> (local storage).
> 
> Currently, the kernel does not provide per-process or per-cgroup swap
> selection, making this idea unachievable. To meet this usage need, and
> after reviewing alternatives, I reached the conclusion that swap
> devices must be controllable on a per-cgroup basis.
> 
> I would like to present the motivation, implementation progress, and
> directions of this work, and invite discussion and feedback from the
> community. Through prior exchanges with Chris Li[1], I also recognized
> that this topic has already triggered meaningful technical debate, and
> I believe a broader discussion at Kernel Summit would be valuable.
> 
> Agenda:
> 1. Motivation for per-cgroup swap priority [2]
>    - Comparison with alternative approaches
> 
> 2. Implementation reviews and problem solving
>    - Changes in percpu clusters & swap [3]
>    - Consistency with cgroup parent-child semantics [4]
>    - Challenges with NUMA autobind and swap priority [5]
> 
> 3. Criticism and alternative ideas
>    - Technical concerns raised by Chris Li [6]
>    - Introduction of the swap tier approach
> 
> 4. Further discussion
>    - Topics expected to arise in ongoing reviews before Plumbers
> 
> These agenda items reflect issues that have emerged through the ongoing
> RFC → PATCH development process. The presentation aims to summarize
> these discussions, share the current direction, and invite further
> feedback and open discussion from the community.
> 
> [1] https://lore.kernel.org/linux-mm/CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/20250612103743.3385842-1-youngjun.park@lge.com/
> [3] https://lore.kernel.org/linux-mm/CAMgjq7BJE9ALFG4N8wb-hdkC+b-8d1+ckXL9D6pbbfgiXfuzPA@mail.gmail.com/
> [4] https://lore.kernel.org/linux-mm/rivwhhhkuqy7p4r6mmuhpheaj3c7vcw4w4kavp42avpz7es5vp@hbnvrmgzb5tr/
> [5] https://lore.kernel.org/linux-mm/jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko/
> [6] https://lore.kernel.org/linux-mm/CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com/

