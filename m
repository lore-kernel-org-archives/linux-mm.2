Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5650BC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184626B0096; Thu, 10 Sep 2026 03:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B966B0098; Thu, 10 Sep 2026 03:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099B56B0099; Thu, 10 Sep 2026 03:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3EB86B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:56:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E2D11A0481
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:56:30 +0000 (UTC)
X-FDA: 85197095340.07.C181DC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF9561C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:56:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDi8kUuo;
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQQcusQ9LLT4yN0vtE2+JJfBAM0whRembcwi5uPMBmY=;
	b=kpYsxEAowDhqNRMv9QVtmw0gXzjsZJpwJxpriX/zCSJefxuuLTNW37Si2MWZQBQbodf2Te
	ho+9K8O0v3/WZQYKGs9ksdZGXqUKR+qI1kGLqzjt4IT9VXeUmAQv8vj6B1GI8RmWrJRgOg
	hx/bIeoKS35mgXulf8F5PcBB0JE6YuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026989;
	b=auipaGUnybhUXtk+bmJsfcyRrzIq+0fXs2+D3zKcX+j5moJCmWbgTWeiH2pBHP0lnpfZLw
	JE2NNiLzWStzfMr1aKGP9YKDrp7LnFnr83cu28MnvVTYvTvPKhpVtMPTnLyMigtVJgSWLk
	Ej0D2Sj4QmverTdezC3VlWEFQZJ+Vnk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDi8kUuo;
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CB17600C8;
	Thu, 10 Sep 2026 07:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13BA1F000FF;
	Thu, 10 Sep 2026 07:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026988;
	bh=BQQcusQ9LLT4yN0vtE2+JJfBAM0whRembcwi5uPMBmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UDi8kUuoLd3sQBFJGPIWCqcoyztj2LTiq9VJbAroJS0NmrWzlX881kEKj/grf85aD
	 +iFSIOSNfcbhy3RVHR7B48/NMY+1sQNN8ceb8gy99B3IgdUR4q6rQoNiKgy/V/oR4y
	 IcrtbvcrheHdS/YlR1R9Ro7LmulIoPjpSMZdb2rjWIBYgKwC7c915RPLwMJxcTsicl
	 iulfu5rif6jCCo7NCp4ZGfR9WkDxd/Gq44sL7rA8DWe3cYda/Vq+rKC4j93AxOuJGf
	 I70H/S0fguNXRnW8yk92n+a4QZgcvHR9wkwZ+V09rj+g/x/JqT/bPLYUa+vK1YkvwQ
	 EZXJMANGawwbQ==
Date: Thu, 10 Sep 2026 09:56:18 +0200
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
Subject: Re: [PATCH 06/12] mm/sparse: rename __highest_present_section_nr to
 __highest_used_section_nr
Message-ID: <aqJiouyfI716msmO@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
X-Stat-Signature: um885dybm8c5jo3scgawi6a7m5yc7z99
X-Rspam-User: 
X-Rspamd-Queue-Id: EF9561C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789026988-281147
X-HE-Meta: U2FsdGVkX198zv9k3rxnt/bmRJrYwsRMKUTSDRp4Zole06GUjvs+IshTL1jWj0mHq7rhy1RPT8l4cQmd8Zuy0P00XgGyA1e0tT7vqJzDwH7LMuqMB68/YQvPgc9iF0m+Xo3XHxQaxEnsPsx6A9iZ5zVDGcv7k4dcj0v9WfpWxWUGkRi9QOhqC58BYhrhWrnd0h+rbvHYCiAglc9qB6XDX9scCuIrEFZXjH6cSIQCJZ/QiD1pn9KHDyiCZLsV4lYnQTw2xouhvn3YH6Z35a3GG2f6j6cv0V4KarJ5G3IkKvKTNb9AWAVGUsECvlKqeiRGG/nDI373BBBT/TY3jDByBp7tOwzjeo0Vri37fIAJPFBgYeAwmfrHs53O3u5VCVigj8zJnc8ntB9csvcFZilxyDPVH5MLW62Ti4VU/9pUN0wmnWU0SIkHfscvZOfH+TSz6HSdfAjDvXYqJeJPfYGvkbPVT435lu8u70F6ShXyXw3eGl0595VQMLbx5zZBYiWNazJGN6zifJOP60c2PCvwotBjUwZvvxL7dP/dQuUX/GTW9BEPD62RDLRJLmyY7sH9TOiGBKmkajG2DKKrE0Fcl1edKOymTJN49D2VmjTADOWqFOLOAX4rgKF65LeC7Umd5no9odZHQN1HffgA3+/Attu2+4W4W82EC+utAz+ONtbIRy+EkGEJN9YoXIyOAutTxOceMebiAgigfF/GD4EfHEqS7uEwFQMt9p586n3RWMUpuNYJFMLHp0oT9uZwGBn4/3pTV6Ug2/DCKpKBq2w+jyxf6xWQeUdykGeIRSGvp/Six2UN6xEw8OW7/atvY6wewrA6EgmepHtINJhhtqZWxmzqS+IvqoSehNRmgsw0tGn7gqPw6tfCz2aQD6MJ8NA1XrPnUYLwZmngn1IUfZ+bONE6BiMYkStx67b/Qf8PytFgURlNDoTwBArYe3UZ+1v4juHgbL0MAsK71AwkFiv
 MDs2DF/p
 gx+Huha6chjZ5IOyGH+iJI5hUauGDvX7SD7ggCpAJ6SSlpp2Q6vB3z3llhBnIp1gHZUrFuWIO4QJRdo7MlMeod7YMp4MiEWiVE0eqo7sZYsvjRUGQ3c/jKMiPoS2lKe/vGmujSgDjfIAaU8vnjSqiG2NpwdUJoYviEp8vmD3CaQa8CV/oGyl1ujFG9/h+MrjzUvQuj+JlVbds1/9H3K5fNQp2roPYezX5mAaZTCkOuxiG1aZ2cu0Sh4XtzgplnU0GD8WfobV7LXJd1uX7uDNpUyFGlg22B0E3Tc0gK8efJuiLKI69DhdadLrFPkhAJyTS1qso
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:59PM +0200, David Hildenbrand (Arm) wrote:
> In preparation for getting rid of SECTION_MARKED_PRESENT, rename
> __highest_present_section_nr and clarify the comment.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

