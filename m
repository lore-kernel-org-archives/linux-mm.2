Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C2CC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92E96B008A; Thu, 10 Sep 2026 08:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42096B008C; Thu, 10 Sep 2026 08:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931996B0095; Thu, 10 Sep 2026 08:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB206B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:16:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02F921404C6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:16:01 +0000 (UTC)
X-FDA: 85197749364.11.E743BD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C16914000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:16:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAwYKaDK;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789042560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XWeEQAbcBQCpWZCK+9GzqSSfU/QDHQzFWzVzrQZerE=;
	b=4r6XqvIJdWdUCNR1U93AzULzuzzl2sRYIW6L8rrDZGovPRIBjrFWGvrNX2V+FwhdYTfyfB
	EUpQdZAWogHdw3OcMz8ape7J4F7Egzo4mxN+7dso35W0XUf1YlDgQjIhgg4F4JPRQZ1dA1
	RRaxx3IYAmAHzGoEkFPgZvwGBu3MCu4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAwYKaDK;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789042560;
	b=xnELYQvHCsRzvDWh43J2Swa1wOSN3W2KgiFMewiYlYtxAfMoT3X0A6/5L/pDZooZSz42fu
	LXeypSuH0Pa3VKMCQRHdNgE1kVz5U9d/IZ5VnHLMEz1xtjrVqRqbfw0IAGW4aOH9Ll8SvW
	aq7mK3ujGlE2O1p08xdJjXDwaVEwmxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C659416AA;
	Thu, 10 Sep 2026 12:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3A41F000FF;
	Thu, 10 Sep 2026 12:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789042559;
	bh=1XWeEQAbcBQCpWZCK+9GzqSSfU/QDHQzFWzVzrQZerE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TAwYKaDKW0hTR3gVgSN3rsosHocgxDEN89+NbRlIOOKGsiIjGiLLiQcuDIrTNup1C
	 PMHhjQHz5Zs7E/Oix00PFWiRwKwbdHVyoNFFEhfTT/hYCQJ6kH98AwL7lUNfSgd34o
	 Nf0PMRL+FvDvbC9eXZwwcgHkVVpFWZr5HALVe2HA21h/4kxtbp0VkinyOq9tCA4gIg
	 Eesl1vGtOR1h2yh9AgwFaJ51ZRW/33plu/xlWi7fIkz5aOEXsTATWGjpItFlgzqgd7
	 DLPo0fcBvIjLFiCX1KgDx02Ghu4fAm2K6vxILj+iWYwyut4Wc8awO4bZIA/oOVPJv9
	 /EUR8yt1yMeUQ==
Date: Thu, 10 Sep 2026 14:15:49 +0200
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
Subject: Re: [PATCH 09/12] mm/sparse: remove SECTION_MARKED_PRESENT
Message-ID: <aqKfdTCHbqFmc7FC@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C16914000B
X-Stat-Signature: 4k6ycxrz6xnbetki4ckrk5y6hjjui3e3
X-Rspam-User: 
X-HE-Tag: 1789042560-910484
X-HE-Meta: U2FsdGVkX1/WKyAH1gaCmhQJJr2+T6V9cEg7bE2hK2pUVKRPlMKaTyBRssqCUkz11vfvRFMX8DYC84YeLgoR9AgVm5OWHAabI1ANk0SlhaMY/uLKoZrFAEXXOEJJAKr+DE3U3IrGmkefTpjm6jBDqH6UsQlY6NtFlTwU9oBgiOnHMmZ1MpbNk6uShF3WJ5Vvtd0ENiTvg44BFgpv0aYj6QIQX0e753kK/5oynyhtsdYtBsp9jQIK42j0Ko9ozb/o67vXPkey05X0VJMGLPalkYcxZSHAyrXZbs0mPdWs++Fi68x02snBsztUMIIc6MQMFKqzBol7YU1gOqIM1d/xCV+KeZDTnlLQBIgtzgPXd76Mqk4VIJDwNmQZjC6CKGHze2iJGaeI/6UJl05Wt4uWWlqWIRn+2IO5hXteJwOxJxnYM6wt1B3oDECt8tSbnjXNaZOTRFkr0FgFN60mwc7jTFlF6TQirdakCstBuEM0mDXjyCj+ssQIqU8ChMltJqUn/WXILI7y7rwvRFSf96dYJzdNvsAUIBprr5Ekg6fVzWn5nxxCnkD+0HA/s/BByhi1rz7L+/zIsPnFpMXYQe8bnRgoVSwX/L6HW914lLPPJ4W+YbvCXJCyCOoyjpaZovVJbNVfv4lQS1nO+8KFom1Ff+bTTNIfXfe/fFYsQh0KZ9JYu3xwA9Mr180PlFYmyNhh/GrcNCrSHM15xfKFu8Vt6wWW7W1ebUszEM6gu7HGOVS6W1VJ/0RRTOx4UAwODrPcQLQNSlk/Fj3cubOSe5z3uwQG4ah4JC2eBP/mmhYGzE61379eT0GTS8RbYvnZLuQY7WEYOK9lDeokbz78rNkskCcWzhbcXB/KLB6+s+2aS9Uu0Nqw53Lui1lRm3wTnzr6PLXtphF9dmW6LqRWKDe91OooE3Z4a40OqUqgnKqXadz0VdgybDBgVQe7q97gCgzlUjjcmygFUm3Rx3nNqL5
 x+ZrqaJH
 RE67KyM2ykgzpqHaX2cPsRnYDTGLIcPAUXI0WQ5UCueiRK2NIJEpLZKKpp/sTYXTT5KTfvE0dFMLbLS9IymrY2y88lrk3xdcXQ6ebJ16d1dyfTXpV+XO2twgymjVSx5hsfdSLNrlcHmth/fN9nEfbsyWZur76KU3EY7sb0XKwZBCdrmkZu7cumvPu3FyRDxHE/3PxR/qv5v6Z8r2HYkMaQUgaFXVxJkHNjfI4A3basVhBVRCbZ5hT5+UAmGjslZxeasjhSXWy3Uhn0DkJBYZU1qrWKVpd4X8X8HSd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:02PM +0200, David Hildenbrand (Arm) wrote:
> All present section iterators run before memory hotplug added any
> further memory sections, Therefore, we can simply use the SECTION_IS_EARLY
> flag by setting that flag earlier in sparse_prepare_early_sections().
> 
> Get rid of SECTION_MARKED_PRESENT entirely and rename
> for_each_present_section_nr() to for_each_early_section_nr().
> 
> Also update the gdb script to use the updated value for
> SECTION_IS_EARLY.
> 
> No functional change intended.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

