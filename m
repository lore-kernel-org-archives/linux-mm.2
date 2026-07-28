Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44011C54F57
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DAE6B00A1; Tue, 28 Jul 2026 15:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389236B00A2; Tue, 28 Jul 2026 15:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2045C6B00A3; Tue, 28 Jul 2026 15:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E476E6B00A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:29:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 785DFA0480
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:50 +0000 (UTC)
X-FDA: 85039175340.17.AD5CE00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id AD49920007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WaGYi7Rd;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiRBy+bpTGJjo9NnvKPxurd/L92V0c29LWMs3hMtAj4=;
	b=MxEAv/WufKj+c2dB2vQrfGMmrkPdRYD/ZFpR7DwTBqybOzIuIXLFtU/CrIfLMQdSzH+Lyk
	e+NnGp1PSXI/6rZ8axfRCon7b+9IGDpbcP8S19hPbpLNHmmx3IQz3ZQUjnVzVVgfFkPzuE
	/AipuzsEr7TGN/2tmG3EqGqZZhgM1Zk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266988;
	b=UL3Y9G8vLibR07OMRI6jK2/jqSMwHfUzhA6FYfuJcWWNPYCz4/mogkR2i/TmqidfvabLHu
	ZZ4M61s0v0sPGS+feujT8WwS8lm9qX/QQmtF41+s7xvtDPAaFWY3N5Sri97ixeUc/qOIoz
	hVxlLs0XAgM98a05sZZ4e/NW6wsVmwE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WaGYi7Rd;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D426C406DD;
	Tue, 28 Jul 2026 19:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF3C1F00A3F;
	Tue, 28 Jul 2026 19:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785266987;
	bh=jiRBy+bpTGJjo9NnvKPxurd/L92V0c29LWMs3hMtAj4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WaGYi7RditWVBgZgJj6WfEABspGKIo8MmLOihiZuXhyHDKZ+Qzz4IofmfG6mYEekT
	 j0DAZfF2+fZEgHaM8QOGsiwCX88bJ5YPG2qQpBlkdB0xxYduzqJsYPLryy7dpZ1ORG
	 XIHYlATknJAyBKFqjTUWuXBJxPNc50BfjWnwG0+kjbgsv67Dn1P3O4ViO8D1NiEhY3
	 ITrqzoxYfYf06c0++ss0qi6tcFBHHnMj5GY0rORg/vaFlSj/GwVvf6ogk5RCQGWT35
	 Q0qwRU8rvwPlzY17rElaT7B9DA580O+gLZhirPmMf3wCsYR8I5lNqyEBNUNOs+RuQI
	 81mFyJy09+pLg==
Message-ID: <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
Date: Tue, 28 Jul 2026 21:29:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
To: Juan Yescas <jyescas@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: android-mm@google.com, fvdl@google.com, tkjos@google.com,
 minchan@google.com, dskiba@google.com
References: <20260723074854.1013941-1-jyescas@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AD49920007
X-Stat-Signature: f4pnz9pf3hm9dg9nj773gyzm4ddxd4oh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785266988-847287
X-HE-Meta: U2FsdGVkX19Ef4GfsSGD7y76QoatAxSCEJ18YBAXE3aHOG02sj7APa9NoawNrL64SFrJGujRrm9rGOfTqSsgXyPPf0OSK0MvO98KnFP89BvT0Xl4iAB7kCo0C1f5JA136xmzdvHzVR/qutZpy+q8Ut/LVbG6PboDcRK++LVHK+FUiH6PXdIN33EsXh2w7vuba5VZhBGtFLZRBt3C18RI5EX8uiy4vAd/QP8kq0nhGRIYebiQi+9utw83izcVxufoIysBVyjFI1kF6yEw5notk7xzyLWt0KDp/ABSqEup01sVrJlJN6utpbf2WmKZ/t3rWV6QjCEqDOESbCVCFgFn2uoDBwscLlHRIpy34GWMO/jnzantSqA+LlKR9o6MOCuXshm0wvMhHWTe5r6sVeU3WBtjFnficq6kqZ+gJnYxAx2B6EHdeqPjZdsPSDZ8kn15RItOewKEak8zr7TVyq5uMTjNARfulBOi9s5aXrls7cZaFcgJCIchFA/UZmdJK/WpLrPUO1tlNY84N7NWDNjlf+CSlfimOszvMgeQdvg4JJqYCB18TocrRjkmFUWPexLMQ7+KJb8pRmAOkRst5uIRdGrlIgZ4nx/4yzVMrz0IQcF/mNg4ucD9z+lWtr6kHigqx1I6b0brxCKjIQOoG3vkdp50XTMhYVd3w+QK9eVX6xAN42HxgbJKMCo0zscrOV14xs9cPd4qsR4AfLJEzdYA5wK81gN9b1E0oeqo/BqiqLf3sMvo/wa1wRLYhvxUiJ/cpkFuF0wvtVMe2kPZb1X7Crp/W0wk0KSyJyWQTve8fDXpgpYTfDVAd4T7X/i9wIcDMZ1GpvVrYhLSzdTLUmd0YDtijpZ6GMEOIs/a4iIUnWBPaVKar5CskemK46tHkcXHMauVPuDwQT9GkbTEb65q0T8NQlrC3GzvMT1wwtydSs3axEtmnpnek7oBPK8xebzZq6IGByjRB31EgJvldO9
 UQ/REXVt
 LFI7mxj4RmFi5SvwbajhaSAVqSYWv2RSrhG0iIeWh2UTTPqIWM8OemMQ4/5cKyOtQpbdqsIGmgF9kkkC89voFgrs5P21s0jKy0AIrIc1nOy6bW/HRssc8ulddWoJ5woydcsRbwbq64j0k4CMonGyv2Q/9gd5NjhPv1SUSlY8uqnFujaLQ/Yhn+cnEi1B1aAwzNRQIw3yC82wQ69g7/g7ZqFWoQ5gM9QLMqeFg1i1YZYnnsN03nyWnNPZYazvtfbS2WL1Syc2DPadpAI9AGAGhRRxWPUiRC9LAhlDkLKs8HN+9QB4Cx2n/FuTlhArRD0VEzVYagJsfsn+ueYd9H44VSEk77Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/26 09:47, Juan Yescas wrote:
> This patch series introduces the Page Alloc Hogger. The Page Alloc Hogger
> allows you to allocate memory pages from specific nodes, zones, migration
> types, and orders directly via debugfs. This provides key benefits for
> testing and debugging:

Would it be feasible to carry this as an OOT debugging module? Would a lot of
symbols be missing to achieve that?

-- 
Cheers,

David

