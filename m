Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DD6CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 10:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8154A8E0003; Wed,  1 Oct 2025 06:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6278E0002; Wed,  1 Oct 2025 06:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B49F8E0003; Wed,  1 Oct 2025 06:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56EA48E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:02:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C990811B146
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:02:17 +0000 (UTC)
X-FDA: 83949105114.21.499CD93
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8E90180005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:02:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B9FzD2Cm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rE7Fvyhn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1Q34JIqo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MoEEEght;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759312935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeD8soTHHIxNG6f1XpozFfG0T75bKxyP4oAiQvd6izY=;
	b=cCDWp+l21G6Wep/wA7ZNoH5G+AbtvG1tSUz4zWJjW8a9ZZ8yHPf5TF+uejMTLZkH/gKicU
	epLg9mEohChc7ffVPsKqGQbf9TLgL9p+S6NLRVhHpbLNvWpvT/p166In5ugEDThXMv/KRu
	jpQM2EbRa/qVlEvN7xxFn7Z/4qn5nWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759312935; a=rsa-sha256;
	cv=none;
	b=TNd2CkAS8xG5Tw/rgUsqfGJcaduIzxhmCa7fqoQxWq+3SVA2sAlVjeVpen34MjgbWjXjh9
	zWSoIIaOSMFA2h8200ojtDCtHDJzYTB9Ok5wvCPfOEM3LgtDryDhLoVF1DlRvs7/y003mw
	HsWAqRTnADWJ6Ff/qS7f0LLGfcBNqPA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B9FzD2Cm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rE7Fvyhn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1Q34JIqo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MoEEEght;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73D05337A4;
	Wed,  1 Oct 2025 10:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759312927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TeD8soTHHIxNG6f1XpozFfG0T75bKxyP4oAiQvd6izY=;
	b=B9FzD2CmxCKFVebzqdQFEmlFPt22S5EjbPIZsp5yuBxLvpL2KhgiMsO3t/8Vmqt6K1UNZT
	49/iHf+B2diTqIB7UsT74yjk/ZCBv0ScegguvGT/1yls0y5ZoCs6zYctvXUbmNXskGi5JR
	xBdFGx79WsPyL+7Y5KjxhnTJ059SYdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759312927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TeD8soTHHIxNG6f1XpozFfG0T75bKxyP4oAiQvd6izY=;
	b=rE7Fvyhn6OtfaFyfpp7h8JxLtJ8put0GTFpJcbtzTgPtwUTzJoOAEruZQ4AJ2JHU610MGn
	yryK6oe4i9gtjyCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759312922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TeD8soTHHIxNG6f1XpozFfG0T75bKxyP4oAiQvd6izY=;
	b=1Q34JIqoIlXithAOEHLzWztElhn0iwwC96rDV8SdaTwxGABhyDCYq0uAV83MN0P8ZucKDs
	l/iVkqQEMJkjsTKhEn+KKP/Pw5mo0K+R4l05nHz6X8/O++069/pdI8niE5plSB2kocUShZ
	GdbvO75HMwJgqdVLP4CP3/pIzRDVdNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759312922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TeD8soTHHIxNG6f1XpozFfG0T75bKxyP4oAiQvd6izY=;
	b=MoEEEght4a9SSGw6MaP8wY4NdyUJBcKUM41d2/gKPD11aN9SydwUf+/RU3WfNcMLBOzQVQ
	AyqDU9CCA+2KtXAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6185313A42;
	Wed,  1 Oct 2025 10:02:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eeKCFxr83GhJTwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 01 Oct 2025 10:02:02 +0000
Message-ID: <689e36d4-d828-42c5-9e57-ba663adc9ea9@suse.cz>
Date: Wed, 1 Oct 2025 12:04:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in
 free_frozen_page_commit
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Chris Mason <clm@fb.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kirill@shutemov.name>, Brendan Jackman
 <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20250929151744.2922386-1-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20250929151744.2922386-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C8E90180005
X-Stat-Signature: 5yetsdrronpgewcjodtdo37c41wdsbks
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759312934-887240
X-HE-Meta: U2FsdGVkX19s73fx4hfoxqwUeRIWMr69xAuO7OCmmUy4BpqfQWyI3qLMW8WH0eBn0tdvBN/TbOsNe4DDD3C3mrARTuFZSZLfF1gcsFR7pRJGxMWOjTTGu1Lrf2jodNT1x49MMKMg0TxROSQYldgDdNgbZZ251/VMHFmiOrQPLY1UqM038vFPoX0+5tTZR/BXnsHllEFGCxahgY9v3NneeK+ZCsNQwK6DQqMEgCgEuvV3Yso/SMVc+pgFhGk6X1j63oRekTBiqKF+IgqxmYFRpsa9lK91qVSoGeEqKZVAFZ4ZjVkmtwDdLkkIan5n2mUQHfz4gL9Nv+Td6dWTX0LIgOFKg5a0sZcox4hYE4HjJpF8OWR/RZE3qfJGlMTMtiNOVHYb1ZXxF9GHw1D/JO0QWeljAADbrdKojQ59ignfEkhPexvBrMtZfatyWdsZjLWuZe//ndCYtOiKwemuLvcqFrcKGB+hIGefV7wbwVhzyOaARLcMwvq8SWMfk4gb6UkB/VoVF2C1/oxa46LPl2YLDOMeLVDsHfL7RmM9LMGbSi0qiXkkl25nZCDxkUigTIcK5+gVuafxoUpJduvyPklGCyINA80EkALCOUonRcLHwYXNJSSUgngayfHsr4HlHyukqsfV0mOFd7gfmprDmNLGORrCj2t914/3UKh9Fva1X7hq0sSK5sLWEMUNJOJIWva/2OM9qipdtDTVsOuX1Jl56Sk/TEsaxBIVX1TyprYFFyvcNiQ5+Nulg/ZcDE7U3q+K+0b+A+2VBSEaxARsJiUzEhArEPnM085pF5jOMglf5JaTBNgRFVcM3N6kIQaAEd7zlM3EOhC0i5zn2e8udzlh4M54M7rRMX0d93Nx4OdTfszMzD9sDR8k4++Lc+vjqulcj2U95qeozw68JKM4FNaN/A7tg6Bfl5yXImgDig+do4iS597Xj/F+MzqpXHQVlc0K5uMxPRrb3DUfN4UAc4Q
 w4+LqtQZ
 pVR9bZTNS/0zzmwaMUeyn/kmyH5nkX2EQ56BYlxHzI6euASqSqPrCjBnr60f2h4N6PuO8aimfrcpZlupqJihKZ1qI+qDhD4J9cHOlKs/TnkxXm/SCPQKcCXY7HnK5fNSzEN09xcxOYMAsKF977h/pILWqAxfSVOCeG3Nf2WLoTmnbhgzHcXIlJWYgMhuLsMsEQePlcIfKqIddH+5lYEJYsYIjU9YOVuHMLxUgbcPEpNVLwaDJW41CSr5OiEhv2mWY8WKHY3ev1Dwzjz1jcr1qxvRUjNcwb6wTux8FekG/JrVkEg8NkM/Cse2jt/16867jjeMW7o7BoZw9xoNTeiyjhFAxJblPclF+trYc/ay6z9A6lC7sUA++vicMdLHcTQozUlqjZRM9dlArp8pDCfiueBuXxykIeNyX9LLGbY11ymEbGIe42qbSTHpKDR6/H5mwwZ6G7fL9drYDeQPzLrg7UVBwug0yKltcgnd4+qx6ayURm60gJIi7mGzvkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/25 5:17 PM, Joshua Hahn wrote:
> On Sun, 28 Sep 2025 13:17:37 +0800 kernel test robot <oliver.sang@intel.com> wrote:
> 
> Hello Kernel Test Robot,
> 
>> Hello,
>>
>> kernel test robot noticed "WARNING:bad_unlock_balance_detected" on:
>>
>> commit: 7e86100bfb0d65a17f3228a9af4c2a49ac38f057 ("[PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit")
>> url: https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-page_alloc-vmstat-Simplify-refresh_cpu_vm_stats-change-detection/20250925-044532
>> patch link: https://lore.kernel.org/all/20250924204409.1706524-5-joshua.hahnjy@gmail.com/
>> patch subject: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
>>
>> in testcase: trinity
>> version: 
>> with following parameters:
>>
>> 	runtime: 300s
>> 	group: group-03
>> 	nr_groups: 5
>>
>> config: x86_64-randconfig-161-20250927
>> compiler: gcc-14
>> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
>>
>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>> | Closes: https://lore.kernel.org/oe-lkp/202509281204.3086f707-lkp@intel.com
>>
>>
>> [  414.880298][ T7549] WARNING: bad unlock balance detected!
>> [  414.881071][ T7549] 6.17.0-rc6-00147-g7e86100bfb0d #1 Not tainted
>> [  414.881924][ T7549] -------------------------------------
>> [  414.882695][ T7549] date/7549 is trying to release lock (&pcp->lock) at:
>> [ 414.883649][ T7549] free_frozen_page_commit+0x425/0x9d0 
>> [  414.884764][ T7549] but there are no more locks to release!
>> [  414.885539][ T7549]
>> [  414.885539][ T7549] other info that might help us debug this:
>> [  414.886704][ T7549] 2 locks held by date/7549:
>> [ 414.887353][ T7549] #0: ffff888104f29940 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap (include/linux/seqlock.h:431 include/linux/mmap_lock.h:88 include/linux/mmap_lock.h:398 mm/mmap.c:1288) 
>> [ 414.888591][ T7549] #1: ffff8883ae40e858 (&pcp->lock){+.+.}-{3:3}, at: free_frozen_page_commit+0x46a/0x9d0 
> 
> So based on this, it seems like I must have overlooked a pretty important
> consideration here. When I unlock the pcp, it allows both the zone and pcp
> lock to be picked up by another task (pcp lock less likely), but it also
> means that this process can be migrated to a different CPU, where it will
> be trying to unlock & acquire a completely different pcp.

Yes.

> For me the most simple solution looks to be migrate_disable() and
> migrate_enable() in the function to ensure that this task is bound to the
> CPU it originally started runing on.
> 
> I'm not sure how this will affect performance, but I think in terms of

It is somewhat expensive, I'd rather avoid if possible.

> desired behavior it does seem like this is the correct way to do it.

I'd rather detect this happened (new pcp doesn't match old pcp after a
relock) and either give up (should be rare enough hopefully so won't
cause much imbalance) or recalculate how much to free on the other cpu
and continue there (probably subtract how much we already did so we
don't end up unlucky flushing all kinds of cpus "forever").

> Joshua


