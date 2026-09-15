Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752A6C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 00:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296106B0088; Mon, 14 Sep 2026 20:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247146B008C; Mon, 14 Sep 2026 20:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188496B0092; Mon, 14 Sep 2026 20:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFBF16B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:45:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB7461C0AAC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:45:36 +0000 (UTC)
X-FDA: 85214153472.11.3AA6C9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2C4B340003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:45:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AAQSvdrw;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789433135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwnBmXu+Cm2L3rkXgurvwPvyEX3pI8+xK1duHUjRx2Q=;
	b=28lYR1mMR9D6144QvuSIPkaVvlRP1VPewbIiT6fGx6pLlnNfKI4N8yiG5BxRZIdON5ukxg
	WzLQyjTRTl7oKn/B59PztNKGNcf1OV2kol79PemVepmmhMT8X/4pSF3lSi2fKgLqYbr7/q
	0CIb2xiS8WuaamLeQeROVIoC/xCUDcM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AAQSvdrw;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789433135;
	b=xNer3IthA45j9fqatKFke9H+vWuHSp9N+FK8ZiOEekytVtTXNvh5Q1DmPeNwc8Pagm1ihp
	wyqceBDx8iGGdobNkFzYsnGkmOS2fdrvXkjjbc1GUVD71J1wVruIvKf52QTJBViOskDMce
	5XAgtma1hkycd2NKRJVV962zjxkwnSA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F4460261;
	Tue, 15 Sep 2026 00:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBCC1F000FF;
	Tue, 15 Sep 2026 00:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789433134;
	bh=CwnBmXu+Cm2L3rkXgurvwPvyEX3pI8+xK1duHUjRx2Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AAQSvdrwr4NNADTRz+gNg87kWuU5fpErVqpb6tusYGKJQXBNa52EkuXFMdT/Exyhf
	 O+Q7baeJOvVgymMRK/0VXlhBU/Un1yaDTNjXl4sKAMZemU5eK4MsRaPFEJE2jsNCll
	 kTwRXjrYEJ7SBojl6BkHtXL8bBlvirEghTFi+sJw=
Date: Mon, 14 Sep 2026 17:45:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance
 Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li
 <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Yeoreum Yun
 <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Shivam
 Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 00/17] mm/huge_memory: clean up and decouple the anon
 and file split helpers
Message-Id: <20260914174533.6b5dba602fb66209a700df09@linux-foundation.org>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C4B340003
X-Stat-Signature: 6o17gdbx3hghzdke3z8hdmszpegywd6r
X-Rspam-User: 
X-HE-Tag: 1789433135-193048
X-HE-Meta: U2FsdGVkX18XONZA4FuOTw8bKUDa7maG7en+vmZ0zm2HAQFeZiMr9aEZxQiSoeOfqY/IAK/Lh1zMU/uE3ZB+bilucuyYaFiNB0N8dbecAyqUAJPR/RAi97MrPiW9x1e7+sxoFAorSrQph0Y+/rvFyZZo0PUnbl0K+F6U9nYV55a2FHqqm8R3C+9Lm/E25mWLawWJ/XAVKQI/NNAzWgDkyoFPtNGqbpIPIpfCvZk8fpU61j0xtLu5H5qTqK27xgZNdrHrwjnOfleCBI6//FeyPHk7tJha4059f4TLBCMrFx3Lbz6VdW6tXRYxk/jC8QdlUlMWqpQ4MclKSCO7zJ+ge4eWFv5qOacJMYpaoB3DG4hRx7dL9dliKj8UFy9mnDzK/7KT4e2r+X9UY5gpmkItbmZRZhTfUpZHqM8c4r5NkUIVz2dyDX4fiK+Ovydu69pOlFgabDG3Mf0zgA5XRbo62zsnPoa1CHzXC/B3vt4WazIiBcJpn6w9H+RH9G337Co75b1ixTPHb+RYxp9dtdDaPSN5BA6DfsIW2z12ApLQXwjCtPF5XWYZN/oYB+VEr9H5bzgix6/rI/QKScX2M0Pqs7wE5K+O3DcETnPRchkGPDuspmPkNB1bHyWlk4msQFHtQ6+j5oxcTH4FvJGFtl0UUn/4pZ4bR5A0zeztQsYKRCko0ssiDjgWhOlApoEb0vghD/lRr8ymkFE7Z+yYwsCeV+jmot0DdRnfNFcuZoRZVdQ+ybQSjxZCGMnq3XS34i7jXN8G2YYGVq/GLP/LpmOlD0qnYOYYoR08fjTSE7zULlbycXSb3wqNapoawJ/NNKXAksA4Y/2ZE/GrVqceQmi3x6RhUjliWAt9y9hei7FYuzMKYz477H/wpfzGo7CXaa9G1ghtVwPlW4rh5WNYstRfdsgGrcUsKVdzGFy3eW9ly9kJF09ApJRMyI656pOphwQb/YKVgkK+vG3+zek0yU4
 7ARrOp82
 6ELu91gZYBLq6ytdAC16VHvET3cqGt/9V9jhxAwfhUrnGn5oeTncMWNb8vKQnNgKUHHYdDppL0kxcWnoF7OFkD29HqUsB5glVsFAN6l6GxTMMetHEUvC3ZEMn+JoHHy/yqBpKJqOjhYPZnJAzPwVl/XjaQoQNPfBMnnCpe4/NHjmg6IwyAv2Ykzvwy+udsuzzq4auA1V5aofv5NeVOMYaITXsOx9Fu6ODZbwgQC8kYOMTYEAzhOlQALj7yMPFLFwpBVOQbDD0RL88POy8p1/qc6+dfR5SemIc+kHtFGkoK8f3fSX9uedbKbgs1ZkZLHw/Bd/zLUL3qoO1BVbzfZqTmAUoBo5SLJiCpcOHUxwgTGQuDEcajTAasjHcK5lBM9jnpmNUNhtLNzHZqEdtPISAQi1K6yLg/omb1ekDZfgvVSBS08MjXsFvueQdf/mmACw75wpCM1mS9MDrlW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 01:14:41 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> The folio split path handles anon, page cache and swap cache folios in
> one routine.  That mixing is what makes the swap cache split
> restrictions hard to lift and to review. We now support uniform split to
> order-0 only, and no mappingless swap cache folios. And it has left a fair
> number of dead or redundant checks behind.
> 
> This series prepares for lifting those restrictions by cleaning up the
> code first: split the routine into an anon and a file helper, and keep
> all swap cache handling in the anon helper.  The file helper never sees
> a swap cache folio, folio_check_splittable() rejects them up front.
> 
> Apart from two bug fixes (patch 1 and 2) and a slight adjustment of anon
> splitting (patch 12), this is a pure cleanup.

Thanks, all queued up in mm.git's mm-new branch.

