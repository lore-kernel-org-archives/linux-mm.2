Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0192FC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8386B008A; Thu, 10 Sep 2026 03:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B386B0093; Thu, 10 Sep 2026 03:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005976B0095; Thu, 10 Sep 2026 03:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1D7D6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:59:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70444A4B76
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:59:20 +0000 (UTC)
X-FDA: 85197102480.23.3F96E9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D58E6120008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:59:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQFA2UmQ;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789027158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRs/chg0KdnpHvHLY9kfJ9kqDasmfHkg3JlNvfdFpxc=;
	b=drbT6gNWcm/aiGrAWN+vu1BLjZo4N/ZZVM2O6x39rzr67RS7F9ZH3v2ahIJGWDIjJKtniJ
	7YMbVlocorKTnFxX5NDDQohTpleRYa86bR4w1E+CqT8t2pmMrjVRsW4+KIdbYM3mHlgsm+
	fFaa4kvUtXb08Zjc5dhRv04Eed367lU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789027158;
	b=uYY4uN2pr40APaX9NDEdFUA13lpfAIVwM+SlNIV1BcDth1RJeOVktlDtmBO64Kda8CjJPn
	0hYlHpTRA6tNAz1W+OI6zdnBl/tUP5aqT0mIMJVY+fNKWz6L3HLg0ChHVi/oU2DkrYQ3KX
	vEuVcgjSR9KKPItVc6ul91MNbs1zhs0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQFA2UmQ;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE46640743;
	Thu, 10 Sep 2026 07:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD62B1F000FF;
	Thu, 10 Sep 2026 07:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789027157;
	bh=NRs/chg0KdnpHvHLY9kfJ9kqDasmfHkg3JlNvfdFpxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NQFA2UmQHMnTly+2eXTG8Pj8f+tmN8nLepBmX5vYFNjVw1HfO3ezcE2e3msAZcGKZ
	 Nj85KlHQ7ImLxXVhEMr+AXBT/ULU3Zh58BBiYEUMCZqu6PX/SkPJqMSjP/vdKr/sZ1
	 Cw0SThBCYzl9SW8qCmYWP0gGyLp6/njf2s0ydXIJBfvnFG7iJgU0/dbdRvT+LNQq8B
	 vI+IaR3JxmLvUBbRZBwNJxifjFC1r4u+XndAlj32yr5YoDSkSOfFpfnaouIaJwP1Za
	 e/HMCoMOkXuEQ0wm5waUt0AjJkPOFVYQJSJFxLrgvOB+YGpM24gUHIfypCoQ9/EgJK
	 Hinjfj/aUvopQ==
Date: Thu, 10 Sep 2026 09:59:08 +0200
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
Subject: Re: [PATCH 07/12] mm/sparse: remove pfn_in_present_section()
Message-ID: <aqJjTE04G1A1l0A3@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-7-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-7-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: b1nj964wmwaaso7prgoozwzmkgzhhj57
X-Rspamd-Queue-Id: D58E6120008
X-HE-Tag: 1789027158-229590
X-HE-Meta: U2FsdGVkX18vufagGWLIR+xlQUn+mOs1wgb3lgnIhw5lxT1kopXZpoK608TC/tRlLmpMghCXQJYZg94MAIc6NzB1Ti11jZL6p1HZISITFXn26ufyp2jl1AywDV+RH3/Aof1fmPxgKeHAb+84zslnHEA8MfXJJSJCQ8g58fN9r5kY8fQ8UCjkZQWd+l2XOMwYIrTt3A+WA3q/lcAFBmj/CkhPWFefnmin0qRfU9RaxRxKLP8rjIXO0QvvtuZe7t6oFAjeJlk8olApnjr6MoFBQI98mxbt5IbKcQfci62JNm1LYgPhmfO6182pxtvYxPaN52YVQ78k3T9u9M/3n6FTZcjuS13um0ZhnLKRAPu65UF4uBuAtGqlqmZT+ZniAmhJApHd+Gxui0o5zDfrFw3Zgwyghm3HdSsC9paRpScEVxjgpdgwaihi4Fa7WDCrQqL4TVxtgrl/XP8e+IdzEo78Bl48pZ6tt/z31GPZhX4XNZZzO2E98hMk01dea1njJ8WbuUv4ibxQVh6t7i/ELe0GljJAatR4LekQbcGxUP3FfbNDh4eyDdp3OVeRJazyJrlNqnuCNQfqIdXwdeBgnhTfD5gf0M99hrytDhg1oLL0xhtjMy02ns7Xwdlh3/8s+ImGiSLyhjcg5KSrlJ7LSNesV5yaUwz2Ph4uQvQTf4dicH6v4B0tKTPMnk7BSBQHdzmJLZ7lll7+9Glr08FLcQeTFRhy+1UH0oAUjOQQ4f9JADxSXF6GjEaIaiN4YYWqFeSDBCh/0wtTwp3HkVK5tu8EgtawIM3aXIsIIokui+KrTekI9aT3dfMMjJXW9qazizVgIL85Q/829tNar3AT3qMoUe6ESxd4ftEWhfbsGeyjkKfWASBYmxXdhAzvOqae9lfKXBq+mox47g3jlewRD6n0H478x1xrzdiCEbYBrV0UL62l2FpJi10T6PiujqwJEAKNNPr++9rUa2S5etuffRs
 Lis3vHxx
 Gm+1yw8me/xmglJUWYoHt8zqxayw4Q5Ut9WMAVchFWpqVNuBBJsiRxHBz8Ho1GtfjFSZUTcwwSslX4ozdjie+d78hRkja9mh1U7yniF8IPC93vLOElZK0rEzIm+6iV6dzOLZhmGbJbolLk2psThXiJvQEz+QFf4ZfhpC7MNKkmspUl1/TRhK359awLsiGntgXigtFuJR7nlMcT4FQ248lroWxcUGgbLNmE8L+jG0qEczl8A9W2YR4EypHLaz38i24tvB51K4hS7aA02mlmndXCaoWc2a88Q9amQoHvSGEsCEqG+57INRG8iTgRqUnoudgFcQmkAuRerakjN3bDSs36Vj5BLY6q+uEAkrW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:00PM +0200, David Hildenbrand (Arm) wrote:
> Unused, let's remove it.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

