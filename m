Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2833C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06076B0093; Thu, 10 Sep 2026 08:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF146B0096; Thu, 10 Sep 2026 08:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3236B009D; Thu, 10 Sep 2026 08:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B68E96B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:09:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 290A31604E5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:09:04 +0000 (UTC)
X-FDA: 85197731808.08.CDC30C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 809C21C000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:09:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9XvPJax;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789042142;
	b=eldonvVqbqKAb9yaMT+abK1rKRAE53ehXogevk2xstq4ZzFJcuJUBOfF2e76q1fOjUv5HS
	4itJt/xeDP+ytlLePlOV8yilZY5dOc9fqVo2RxaeioEpeZreuHp4io8cMwut6GU9q8wkNW
	GCElSDmdkeF6Jcy1nDrjeIWASkDP5xM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9XvPJax;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789042142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8JhehTldcB3FE9LGKhQNq/e+HX2lvut2PpvhgojHPY=;
	b=FL2e/gT+xWkpshSqL+F9BEN6iq2vZ/D56OksQNKUXvVDvKxLVGh2J/lEtLjoL6+rlb4i9M
	Q1OWyCK7pLH60wUnRPvEOClsZe30NGF4xvrKnhSwwH6ZWfUzXReq0WMtX1TFXETZLO84Kb
	nDwfbHDZog5eG7c6qHTHKJTJM2RxCiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0947E600C8;
	Thu, 10 Sep 2026 12:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17AD1F00893;
	Thu, 10 Sep 2026 12:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789042141;
	bh=h8JhehTldcB3FE9LGKhQNq/e+HX2lvut2PpvhgojHPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R9XvPJaxnWBT/hhlHZmNBez+Xu7yQO9mAv8dduJTjSJl0gZxISR+BHcwPyiidi1F1
	 jRKYzFm5oXjvXRnAP6U2pqltMLSl2J8ZQ9WdTNMfl4z61gvUyOWbzyK3Ub4Mw8QuQ/
	 HFv6DmfgE3cPnMmOo+TKucAGzNXH2GdATJ/t/rZQnGcTM5RCHGS56zOQx045SPfRCx
	 Eh9nVKgokLYia9TMkboW3F9ft5E/ybtN5blbY1wMqkcJStzGzWhQk9A6OS1zAAxuLC
	 C6zxYi09inIeB3Vmv7mraQXhcpNdhDre/6j2qK0OsdoydY771AplJyUt5L0iTDWCpT
	 CjuHp3FDi2xCA==
Date: Thu, 10 Sep 2026 14:08:52 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
Message-ID: <aqKd1MUgFVHozVWu@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
 <aqJrblWch-lajp3k@localhost.localdomain>
 <c2239ef2-10f4-4c87-a23a-2753f1e18d27@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2239ef2-10f4-4c87-a23a-2753f1e18d27@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 809C21C000A
X-Stat-Signature: cih4u7rxo1c89sr66tdeapgismyb3efm
X-HE-Tag: 1789042142-638885
X-HE-Meta: U2FsdGVkX19YLMOWFg09eu2EDLdIiH7R4Z08dE4SROWsvdnZpK0nbSDeiP11XO5jhFCMdvO2exBX/mxfUFpEikj9nZ2ubqcTalACGJsIHB1662hTfojeOAkw5DMt6WM5Q0pPysqCvUdf2YngunyINyA7+BBjPYx0fBRwGX+/drGVeyg/PGdHfjDJQMto8QJmRZdIsjJaFKAdK+ZhbIMFRAMG2vCLSH6y0MCI2YbahWUN2onFDZvHQITqdYXkokdqUkZQpTODVFeCgbSD9Q2Trcjxt9id2imMwvGiT239+N3pLQTwuF1LzbQJELSzjTUp6vD+X7M+ysehSMfbo7Jb1uK3lkGp6nV/vK6N5YApBcflGT9t7eWcMA68XGXGZM4GcU7jSzfwKvJKDPSNVsm7+brfe8jsOhrbvtd7vNuXRr64RiT9k9hISOh5HAUAlYb7nbsRrjAyCYD9bIpx2kAsDUtdh5BgqVyAA2QtpWfaN/h+JplyqdG9wI0qGFguBTo1ZrfgOGMxb1O7I5lbtlJDi06plBaexB7inhAZpUw/GnAwsspyriRzjo8JhMttQwOCV982RlUZlp3Tsaw439Wix7+nlJtFPZhSxoy8q8vXzB0SWc1tYe1OwaX6fnB2nVSnDEFbBLPCPbl6q42oEjxjQNpvc2FmmZsrn8c4EJZ5Nsil46cNtj/s7ZPUcLEIbBH6AOxp0QBlg30q2QGUQ9Vf1XiovtPULrFFsZmxiovw2WxB2cwy35FVA8XZNtXCayfMJ6zE5f3dkncU+GJ36GiSoP4jRCX+7NtGexJzNP0Gr4Di8lwq4TH36m2gG8gMok9ZvfwMRWH0VaskaDlUo+dUq9A5bIi6hnIp/xr7KldDIrXLJrRo4xQWRdWtZib3DpIDfsXi8l5p9zs70K/csi1wcSF1PKi5chsCrA0Jt7+nTxrtBuaYg5rgUIBfeNNNJot8CjWRyYdNj8w1YrNdmm6
 SjtHaTob
 KU1skqg/QhqgpAthBdkOWSYodpFH9nPa94GQT3PiAQvMoBEiPRfXvRUqWwsei16XYLQ/vj6Kqm23Qs6xqzi+nucxQZNuo7Wy00tYTngl+5IW7M2pnPBJsncjRnqk8hjWwB6DipIlu/h9HZUpQqMi3fDBB5c6AMlVuiwhqEoXO0Rjaly3GhCrYdFbo1AZY/wu0zDLUkSwvsDzEKehBuYWr5aoaZ0laeMki8GIVNRyd8+G74o4rC47MUmAyMIaz/Gao4URQC53b6uBliJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:13:18AM +0200, David Hildenbrand (Arm) wrote:
> If you have something consuming __highest_used_section_nr while concurrently
> updating it, you might get torn reads/writes that mess up the value on the
> reader side.
> 
> For example, mm/compaction.c consuming __highest_used_section_nr.

Right, but I guess that if we get a 'wild' value, at least we are
guarded by online_section_nr() performing the right thing?

Not really figthing anything here, just convincing myself :-)

But yes, I guess that we should fix this in case we add more consumers
of __highest_used_section_nr in the future.


-- 
Oscar Salvador
SUSE Labs

