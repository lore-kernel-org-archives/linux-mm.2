Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7815C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E916B0088; Mon, 24 Aug 2026 10:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65F56B009D; Mon, 24 Aug 2026 10:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54BA6B00A5; Mon, 24 Aug 2026 10:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADB1B6B0088
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:44:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46CB640188
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:44:13 +0000 (UTC)
X-FDA: 85136433186.13.E7770DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7780C40004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:44:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EDx/ebIR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQokobOnzFx766ycwjdsmUZkNuOG9N7qwhFQ4tQY8GI=;
	b=RFnmbVRlZaGQiFRDeTUZYGsMyHt5IzVvPMSM0rib7cIX1Uvub90FAVSDSSzSaU7EDegNkn
	O4DDYKMXQUYbWLfEuFsPsc7ySM3Aw78xKNNLauJknxyhbD0wCAYN0LAU6NH42xgEAr8S0f
	VyG0sywQNBzg7gFHYZ1SjpKyaNtKldo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EDx/ebIR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582651;
	b=Avn8z5E/kUXGBpTlq8eOaT0ZhoJ51bdgP7h0T0sKST9NJ1wAe2QKp782M8bdQn7ksjfmsj
	VHX/2FMP3YVpaHPGeHSnYHZBCF9PtiWOKMIAAUVr4C+nllZXs0VJ2x4I1rkDVja/9jVjUy
	qi/ledsgVEsfWK2aGXxFcUxR49apA7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A23FD43A4E;
	Mon, 24 Aug 2026 14:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5131F00A3F;
	Mon, 24 Aug 2026 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787582650;
	bh=QQokobOnzFx766ycwjdsmUZkNuOG9N7qwhFQ4tQY8GI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EDx/ebIRHPPAEr4vyUHoRfprdZRzHQrMcuhuD63VjKrhtsdLhKk81VF88Krt4GnL0
	 q0WsC/GIIjQMj6oZCFatOZVDtFR83C8xJoLAlTb1JiQl0/XmsR8j/2cMRQM8qt8I0z
	 +Y7b9LVI91ZNRpDuHpvoudk9d3HCrQXfNPvHlHHS3LMWbpghVf9W1MEb28f48OGfO/
	 b1JeQlSwMxN1wTqU+Olimy5ANpLfroo2pTrn5gx3/jKLVytp9L+f1TERFBfWfw2zId
	 hgecs3hOSiTiCDrUj6Xp+KM0ofY7PlIIsE3GyiOWEPQ8MmDEaI2pJtg+NBUZDB3UYK
	 QzxLXe0NYwWxg==
Message-ID: <7ea3ca54-1975-4b7f-bd08-d28e72fa4b7f@kernel.org>
Date: Mon, 24 Aug 2026 16:43:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] userfaultfd: rename vm_userfaultfd_ctx to
 vm_uffd_state
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-4-3086981b33cf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-4-3086981b33cf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7780C40004
X-Rspamd-Server: rspam07
X-Stat-Signature: w9mn1ntj9tzwjcpydzrqzhakbtctzqzt
X-HE-Tag: 1787582651-461685
X-HE-Meta: U2FsdGVkX181lb1OfbksTokfPcoN98jcoAeoQxDtk2qBhg7VELaw/I8GSJcYYr0NbWWcF6JdoN3L94hu2T3/ILH6IcVJHWiuVWznNoGJlWLldmzguOvrwW7R5LyoQQ46A6yJPdvWw7UXlLBtK1DxCPgUNUz8T9Ft5ZDPDJgnWQ11hw2YUsI6Wrd6cne3oEeSxOg1RWPQ2JQ/Vo9HKMosW9tvGbURyIAAWQbnP0hivW8YDFg/m52Y645Zn/bqf/xXiMKklKGSEvP8IupyZwclR39HkzIekfrU0UfY7ObcjcIvsF3OuCW/lgbjQJDdGm8FjTowZB1goYXfPBTbT889NpPMDtNFTMIib/iliq3FgJPr1g3dAZZR/M+e1/Gt/6qtSuy58mjtol9lK8eTzndGxrKCPtOWGeDL8Cn3fv4oxNbRU3sWr9FtJK1hXU+vqT0CO3g2WH/r8G8zQpFQ8a/l64Cn73F1UxmiCHq6t/ouO+BNQk/DgErwe5gLfz0HyPZY6XJ6hOgBUyGMP78qA2aNbPE4FJLsEQQpAChwMd2WYhvhLwbGw4JhUKNHobwsZEnn6d348h2+NogwTOxyyWpgZwjo4QISh2lg9RxHLvauJfBbPr3QWvtlImJg3DQyXe9NLH5oI3Et2L1+heHQjs+ThDtUVHg9T8RH0RPGQDBtZH2No4Weqq7XByeaB0M4R+JkvwhTk0OJMG6Rrj61DOONLb+mrb1POsK9kLPopK0EbB9GV8l4O/GviHU5t389u7HiWX35hBG8P3sG7ead70iqSo1Ncb9TMHW/HRmlbHO2C8fOvo8lhVRbbSvezadcAVEUx76yVp++zqEzJy7OIwi8OBg1DKqhoDAi3McWIrAgaz31VbkA2bu9RHnEP/3Ou5M/QGyO7ldesPO4zrxXcmPhRHH5ChW+cwwGYWSBWh7/M8OwQZDPr7W7I7VQg6nbaCkVK3EuXfctbQvD3dlbvAV
 iZJ6RZg7
 YS/FcKovHjQaz7CodV4J0Ahml1CZaMslKtYT+9H7ldl45DBjuUrwJnp8TDLkbTEY2V8X1l4UCuNM6XP7ex/sJkGcYbDQ7EP4B0t4xm5SP15QDRybibHvS0C3VprJGd0eesinCPdx3WehU49aUcQ81SdpRdlWtPcuK0jyQIFl8OAwZ5mVowD2aD/O8OQjaOd0pX2SrR6uacf750aVUHcDyITAQ+I+JQ+3oECgEA+JqTofyKXBlg9QHgCqhRqff9VllYXCPW26MBYiE/otQMlvgfhpTMw2H7hpZH3894znwVh/SfJgwdgFA6rffWLNrzw1FXxDoekEoH2rykTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/23/26 14:17, Mike Rapoport (Microsoft) wrote:
> Rename struct vm_userfaultfd_ctx to vm_uffd_state to better reflect that
> it will represent the userfaultfd state for a VMA rather than just a
> context pointer.
> 
> This is a preparatory step for extending the struct with a mode field.
> 
> Mechanical rename, no functional change.
> 
> Assisted-by: copilot:claude-opus-4.6
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

