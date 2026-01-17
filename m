Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6127EC98315
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4536F6B0005; Sat, 17 Jan 2026 12:46:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400A86B0089; Sat, 17 Jan 2026 12:46:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2506B008A; Sat, 17 Jan 2026 12:46:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3946B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:46:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63BD9C08AD
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:46:42 +0000 (UTC)
X-FDA: 84342185844.23.3E5D3DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1830160005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:46:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kNfalDzk;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CahbkNJhnRKa+WQ65LnUzRjG8c006DOyWRh+CoTY5s=;
	b=wS100zink7r2moxVO9GyCR+VsM1tRFHDzJNd6ki3GHHd5uqNR2mti2VntE4vU1hI/KhJQC
	vXOHyjPhlj4MvsWkPE8r8kTeYsJ+09TdNYtBhZI72Rn3P8c/bMv4mm2AW72HBbtF1CKqSe
	xUA3NB/oNyugaW5c2eES9lTjAuJxB7k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kNfalDzk;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672001; a=rsa-sha256;
	cv=none;
	b=NNIvPeq/5mk6n86XPnFSw0Pp5H9yvL36Sz1T9nlStbFUf+Afx49FhbMJ0q8ArZ0SnfSaye
	1M3B90C63KbmI4Ykh+bZ2wPNUtyArVsH/97/NiZtZEeMAx4TM5dRHeoidBTCZrny0L5m5R
	cgWJ+0iUvnyUEsWQmqO512MSalu3Foo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89BAA41AE9;
	Sat, 17 Jan 2026 17:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA647C4CEF7;
	Sat, 17 Jan 2026 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768671999;
	bh=Yf9fuX/LpocU3iC7fEnAmijlZODHBllQLyN7/P7+mHY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kNfalDzkGXY0eL+rMGMaqu+qfHrwgvKsHzPG+FMokeleuDrY7l3Osae/CLgcpBDKo
	 YKEVP4aVRyfW1EbzNH0y6dq0MT6R9ZYu30B/Qg67zXRfNtzcrraaNaavT6txKhqTfa
	 FOK3WrNVP1lekv0ft7c8CdRJ2YfdLsPjjpWh66cg=
Date: Sat, 17 Jan 2026 09:46:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, ryan.roberts@arm.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
Message-Id: <20260117094638.c570cfffb999f0952ca7ab36@linux-foundation.org>
In-Reply-To: <5af933d1-8c64-4d3c-b835-d90c8e9f771a@kernel.org>
References: <20260116082721.275178-1-dev.jain@arm.com>
	<343f8462-44fd-4190-9fe2-8120b5403269@lucifer.local>
	<4b784eef-e874-45a6-828a-4fc2acab6fb7@arm.com>
	<5af933d1-8c64-4d3c-b835-d90c8e9f771a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1830160005
X-Stat-Signature: bbrdd4uz8ssxaxqmr1jbru88xr3da5n1
X-HE-Tag: 1768672000-959569
X-HE-Meta: U2FsdGVkX1/VuMrlQKCiLIuxBgEpYsWbx4BFKc26I90Mp4wI4mbquVc4aYCd0Mu8WNKKS6bZ1vJzxz9uJZKu37HAAvjU9KSZoMT/QPkQYuDIUTPIFeE3uJACspJSxsmDhqwmJmlyZ52EISuIf0DQ+/HGjsNZCuLic1inSQdBHqdT2B3CMAkUgA71vSv8OVt9JnqP2kZ59F4h7TquCPpN2nqZyrwMTalf8/PSL04VhbXFFFAIvj7Kj1mUHj/KoRzxSZLR8+J8ck9L3MgHgxzmFz9878mmuNuxtQ0zOqnoyh3p3HDG76S+gYQE21aOmYBSv4Y8GffhND8eFwYq4w/8RCyPF1rYhtM2h4YNNz0n0EDy4tmkzx2BS5N2vnfX/dCVpPZ6+HAIJI5KMOtSqkSLxCXzutb8Vt+V2ljtNSOao8lZng3aSywZYPlCzwOivQH0UoLSS7pX5o1ht4GmXzj6vTDJwZhSfNRMNpD4+msE4s5MtxW5SwgVGNaEr4UH86FJG7lPdR3uSTMRRZMlHmBe+zuFvyLh/OslX9VtH9gX8Ry6y60qzmGnCDtVrafoncF+GcpKoMzJ7iITk7iTmL7EqZaNjDTkMQWbwOaYPmQM28mAKy5YGAvfIMVQ4rJTEUvn4KN1IWBD9oqQmu2F1l7+G2pWeEh03V/Dx7yiB9F8u/euRdqPMdSadZZI39IV7Q332nTwu0QEh0E1IKOllC0oLvDg1ngrxbQhqD3DLVH8UO59BI0KpNfcpC28IV8WcszQA7xCYqE4pt0U00L1hZjrbR4uxgQXFJUyMPZQwaEgPec/ZXLTpfBihxCcd+BkSOfFThHyb6ck4X2p4OwrRCRbUQmo/pT4UrahcrDIGGi3cuEu+eZUq3TDU/pa25gpeCC0BF8sCLU1HDnKQV5ODnQnxrZMrBXgbFWrixalN21Melc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 11:51:17 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> > I saw that the last comment on that series was more than a week back, so best
> > thought to just do a folded fix on top of it - and I had formed the impression
> > (from the conversations on list) that akpm prefers fixes over respins : )
> 
> That series is still on my TODO list and I hope Andrew will keep it out 
> of stable until I get to it.

No probs, I added a note against this series.

> Hope is all I got ;)

There's also "tell Andrew stuff".  It's very helpful!

In the ordinary course of things I expect I'd have judged this series
to be adequately tested and sufficiently well reviewed by sufficiently
familiar names so I'd have moved it into mm-stable.

But after learning of your concerns I've added a note and I moved the
series to tail of mm-unstable where it will be easier to drop or defer
should the need arise.

If drop-or-defer is to be the decision then please let's make that as
early as possible - we don't want non-merge-window material in there
perturbing testing or causing integration issues.

