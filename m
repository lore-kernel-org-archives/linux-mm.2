Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFA1C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DB06B008A; Thu, 30 Jul 2026 04:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEF16B008C; Thu, 30 Jul 2026 04:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DFFD6B0093; Thu, 30 Jul 2026 04:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF3306B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:27:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F66E1208F4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:27:30 +0000 (UTC)
X-FDA: 85044763860.19.134F642
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 902C140003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:27:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4pYm5aR;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785400048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnnuA+kjlZ6bKreGABRl4KjVlBc9ASvcx70BFPlTzYk=;
	b=mq2StXqds9uiz1g36HEGt6/7INGROr3vY8zWQ+A7OE9lFtEWXpFXEs9zUu+sqIagiQNXVM
	CC5Kg0ddAtSGxu0pkeMpZb0y0M0PGhN/c5V8eDKDdIR74fiKR6ti7JkLCtpVKKcJUqvkO0
	FWpMh16a+FRR8X+4HDeJbtw4ABzJCJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785400048;
	b=dOKW9no7vpGGz+hhV8ir11zUyOwes/sruP+SI5f0Gxx8biDIdU5ximJlR9gxEn61mFBG3j
	nKZztV/JoMwUCf2wbJwn7AG5B5uIYyfRJQGGDK9Urxacbd8JTf0Jg4ehkNVrAY2h6e9nFT
	SCwIHzFH/y1AgzMZxhSEgrw3Jiyacdw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4pYm5aR;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C270343CD8;
	Thu, 30 Jul 2026 08:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FCA1F000E9;
	Thu, 30 Jul 2026 08:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785400047;
	bh=rnnuA+kjlZ6bKreGABRl4KjVlBc9ASvcx70BFPlTzYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E4pYm5aRyjK4rnOEYKjs0fo927Vb/MjUSVhQNCD5mgt/e5tTqrQ4fZY/QgSMzyi2R
	 QImZTgn7PqEd0PRP85Hrpktjc7dt7ajWTtY8XV5uJ1UilXD+/JfBqeBk45VVBmDNLO
	 nBo5b2xkte9xIveTT3SB6sb8rToQRn0ak+su0vKx7I778J56NSNxsIH2WJYsalnoam
	 quApoO8inWxpBSm1b9M9+bXGruhEfF3j2R/n+uRPKZHtytOmntbL6Quh+xK2566N+/
	 ejqkJMDTvdZgE0pfN31157/XKer1QUQFZCjjo0q9NlX4LjeXJFpO+IM7D+fQcfipbp
	 dtmmEuMArtFZg==
Message-ID: <2a84e37c-407b-437c-a908-56526ce86322@kernel.org>
Date: Thu, 30 Jul 2026 10:27:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: return -ENOMEM for page-table allocation failure in
 insert_pages()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Avi Weiss <thnkslprpt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Soheil Hassas Yeganeh <soheil@google.com>,
 Arjun Roy <arjunroy@google.com>, Eric Dumazet <edumazet@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260730071323.964321-1-thnkslprpt@gmail.com>
 <amr9zoSncZguF_uu@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amr9zoSncZguF_uu@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 902C140003
X-Stat-Signature: ppg6m4m835zhowd41gzb3r3raqrxmpp8
X-Rspam-User: 
X-HE-Tag: 1785400048-391581
X-HE-Meta: U2FsdGVkX1+Tsw1TniNBoVcd1SCjgtoFmbwVG32m7H9Rjhz5uLk1R60T5bOuHUiiihOOW6TND6bi5Qw5VkSGjCI8YiLBR768/kDoIrwkRk6ODtXCSH40zw01qT9fP/v7M9kKqjP7zwr2ZYrDqtHyh60ttXJWuM0wEEMxw64B+Yz3Mf9rnJfQlLb13bARqRdasCdEh5jqIngpWdObRqUTGzewIp1LHAxmu8wEijvb2JOU/LPaBeEs0kAoKSJfPRGuX9wuMBukjklZroaWrtcy52lhIuHP9w33AZen7g5qMrJp1noIkHBQqCxxXMrKzqjZXCz0cnx0rvYj06QoLtlik/Ca4KISpDWZh8y3kTgN49nsWsg7A+NoJXqABkVX/1XcbaglP0hCaR7wBedi0rBS1xHnc5y+OPEBluQ0RyyViVXuYlD1nNWZoeT+/r4RxC63E9NORim1BYi5EE81v7qH9bPxnA9w/3+cOuGx/YePB0E1x28TZwoNmFj/wTSTOOQApG2B6VhAfPdBBpthJ46zErwjSivC6figJ6kjfRPRm1wjGukKM7KgHTCjmgSV9/Nz8+TFd7XfiwJOK5EHOZ46DeSAwU55mmIyQaa6t0rvj95aq1kME0nYWjhd18kdSl2HtdPFx0f96oUPQx6Gf39RIMtw0hgdG7/or3624HI/1yq1cj+MKLV+EuFzgIpJyTGv06UzLZTJT61s8ftIG7n7nCpnIVR7WGdJop3j0xZjdZw+HNKSxxRDfMuFNv70ZKWbRKlHyWp8hMjWx69JPlAuSghhMXtGRxjclKIQX1WqlLRgLGk1A1MWDH285WI4yhrsHJn+BW0fVK/A+3HyZSWIBnAkdufAOttf2bOAdNtnHztHysgFTT9PW3CPnDctYDbFyJxznU9TQdiD8tW5+gqMdw5jVluPDT5Rjma0k+LEezi9P8bTFY/SdpimXc2oyqV341wSCWfGTiVdC/FcvuO
 +1G5qLq3
 wSux9BT/HmS+UyJKV12FzHyS7nQhAbNwEDx2RzzyBSKGBLC4SIRwIj/uwQCTsKX+PCIGoVFMJlMq1uDnxzG7OetkVTsxIcUJAUN9N07s4jX2KwfXLXcH3nZcvZlY8k0DRxa5rJsJk85Sh02umsDg/QC1dbjXPHCFoV1Yxc5AxK2WYrbGEbFkp2u120Y8yb8vIfg4Xptz/y51TQ+m/5GOUcgFVV8G6Sd4xMfTMoQza6pg99305KLT7ta4UPzpkHl28lGuJhIObAkgXNhfm5Z6OiNN40OUyLNclXo7M/zozptsHMipgG08K/Q0IfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 09:42, Lorenzo Stoakes (ARM) wrote:
> On Thu, Jul 30, 2026 at 10:13:23AM +0300, Avi Weiss wrote:
>> walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
>> pmd_alloc() fails. These are page-table allocation failures, but
>> insert_pages() currently reports them as -EFAULT.
>>
>> Return -ENOMEM instead, consistent with the subsequent pte_alloc()
>> failure and with the single-page insert_page() path, which reports
>> failure of the same page-table allocation chain as -ENOMEM.
>>
>> Address and range validation failures in vm_insert_pages() continue to
>> return -EFAULT. Keep the later -EFAULT return for
>> pte_offset_map_lock(), which is not an allocation failure.
>>
>> Fixes: 8cd3984d81d5 ("mm/memory.c: add vm_insert_pages()")
> 
> Hmm :)
> 
> This isn't really a fix. Anybody relying on this returning -ENOMEM
> vs. -EFAULT here is in a state of sin anyway (unless you can point to
> specific users who are broken).

Agreed, I am missing the problem here?

-- 
Cheers,

David

