Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B07C1FA0C4D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB886B0092; Wed, 15 Apr 2026 04:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D24F6B0093; Wed, 15 Apr 2026 04:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A1F6B0095; Wed, 15 Apr 2026 04:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E599F6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:38:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C4FF1B7EC3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:38:03 +0000 (UTC)
X-FDA: 84660137646.16.EF141EE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FCE4C0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:38:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J3YBlqxF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hEvGsYck;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J3YBlqxF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hEvGsYck;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776242281; a=rsa-sha256;
	cv=none;
	b=utNhcPhz0v13pasrP5h3fSlUHSiFcu639mNDIBJeHQ85n0HcgVecG45sw3Ufz01rf5ifhl
	qvD19XQDI2YfPDRJ+tfepLjfqyt3k0obm/7Ue3d5IXGCTBWSkMIA+ZMmm2OFjlJT1pLmZY
	2As6yI3qAvVK74kJLRvW6jZqapIhRjk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J3YBlqxF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hEvGsYck;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J3YBlqxF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hEvGsYck;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776242281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PB019jISU1/JV0vj13AJi5SAPdeqiJKzwFyxmcN5xO8=;
	b=IhrVgnlDfcng4Y1G3Fth+Xdzbaa3dGugpsbAxd+cxhrC3nfvGoi2yifr7qgoYE+DuhT/VQ
	F8sx0q75gEG8qfvk8xwAbsS6H5TcBkmcFGKCnsrFemvxIoVgyIh5yzjC70Q2uI1FFi1xvd
	BOjr/gmjKRML6Wn8g/hrNtpC6Syqn/s=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 86EC25BE28;
	Wed, 15 Apr 2026 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776242279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PB019jISU1/JV0vj13AJi5SAPdeqiJKzwFyxmcN5xO8=;
	b=J3YBlqxFO9//ViOCKoMwBkJc6v5lA/uIpEljRxo13KRQDtjFdorQ3di6/ETeuxQqhMvOVv
	jV8x9EJfxYywMEhhzvePCwtoEN+yIpdYws9IUjHOIGeSZJNKFJAvZYjpKllryJRdb+3yly
	+RfnqgoasI/hIMqdMhkQz1BDsqOy00A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776242279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PB019jISU1/JV0vj13AJi5SAPdeqiJKzwFyxmcN5xO8=;
	b=hEvGsYckZeEjadqHGTRQTe2iQZeX5fpLUmKCBJ9iego3f8uIuCOi5I4NDJOvwbCLOD3sh1
	fS1RWStf2Y2ybzBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776242279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PB019jISU1/JV0vj13AJi5SAPdeqiJKzwFyxmcN5xO8=;
	b=J3YBlqxFO9//ViOCKoMwBkJc6v5lA/uIpEljRxo13KRQDtjFdorQ3di6/ETeuxQqhMvOVv
	jV8x9EJfxYywMEhhzvePCwtoEN+yIpdYws9IUjHOIGeSZJNKFJAvZYjpKllryJRdb+3yly
	+RfnqgoasI/hIMqdMhkQz1BDsqOy00A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776242279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PB019jISU1/JV0vj13AJi5SAPdeqiJKzwFyxmcN5xO8=;
	b=hEvGsYckZeEjadqHGTRQTe2iQZeX5fpLUmKCBJ9iego3f8uIuCOi5I4NDJOvwbCLOD3sh1
	fS1RWStf2Y2ybzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F7334B8FF;
	Wed, 15 Apr 2026 08:37:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5g2QHGZO32lFRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 15 Apr 2026 08:37:58 +0000
Date: Wed, 15 Apr 2026 10:37:56 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
Message-ID: <ad9OZAVnYvhxfh-Z@localhost.localdomain>
References: <20260415022326.53218-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415022326.53218-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1FCE4C0008
X-Stat-Signature: cg7grmmyxdy5c4fzambqud1e5fifrem4
X-HE-Tag: 1776242280-54397
X-HE-Meta: U2FsdGVkX19/KoQ0DcjNNcZ0vb//bQdC9wwB1dRZ7zNBQgEP8/gXf1Uy6EFiPn0ps6axQ60PZe8j0DXntZq1gKJ2Vb6UGxt0M5YxlyWaMIWFxuARzrp3TbKFzCT3aXCacw2rIVv0EYWDxcHZBu1ah3MqJqaL69ydsMoIORNBO4dP4kpI1P+dB3Ozs34s2vy3NMKX7M8V9J2x35sXqa7umW6n4+ZDNbN/CKqADY6DWqXo6NmdGJ/+2xKOAhfpMdGUQxxEcFe6xaUpiU7jEFD+yOa9POA9/JBll6a9nP2BU257ppnVbwkawzQYOKaBlcLqU4CrveTx3mTbPpk+TsC/+WnKVX+YBX2CSN/W8xeObqnY1IYm4ThvFPPCfFBYqJzPTOqZld8ztZgYf7dlPQi321FpPYGc4+xrBSKgL1X57qZsTw7KAAItY9kKKQSN4PYFQSlFJdSO7KyCaDI9wTOBS5Bq3Vh27tZ3nrmbFetTv0SWeoTkToyVwOenWArti/SSYja380rLq3BMP7DoPkYChXf77PMDFrW6XLsNBTkV1GBvH8aPInX6mj3jPpgpCxRqbf61FuIdeKlGmUQ3CxfcnhhfyuxxA145GiKs+jqD9zQnyAyRu0mJ9XqulxCBRo7fO+3SwfEPQfsode1iSHgoyH3Gs49Eai/30waG7vrgiWGV0H2+eKOI1C1O8THBdxA3ulUyN4Ue+NAr4/ZKXLZ3kzuCmqmTVC4g7oqWgP8iJFTtR0p+j3r7Lirx2RxTZofMw11vQ1SB6Xb8l8nLObtnBwBex8cNTCUfAciu9YsTRIKnf8lvYbl8CEW1PEduDCEf2ClEhkEJqfSPrOjDqvJJycPozQZvzb+zFM0CqRG5NRggLpy9KSPlSliJiMQiqJjk9yd3+pQ7d0b0wHuNm7zRhA5RanfyLIAlX2IV3CIhb+HC5L6wut4yy2Z1lDPpwuEuLToAeXMkkqH/EF88fOQ
 XDnckaUJ
 L5BBuRCMbBciuW7XUGMERZXlMqN6baFfll8Y7DofREztYjHZUPKiXE7rXX+6Dqq+RyPazIz9USZRNXijhLvY2eGdAKn6OwOlQ6Dzl1isWhG5G0l4T0Btv192D8mv2zlECGHZxX8c1cpPzX3okY2Q8wnHIIuHNE+goNw+QWiutQqrr13Zv5cx692WcEUCmHAdOm8Cr145b+S2iwM2NFmR313732EeMZUsGljlHz0DHnUpDq+jDpsRrXTf1KVkFaScRIwIjB4iimlU4YbH9R7T4/nFbNkHEGH6CS8caiimO9qPvBeZuIF4qJHSkVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 10:23:26AM +0800, Muchun Song wrote:
> When memory is hot-removed, section_deactivate() can tear down
> mem_section->usage while concurrent pfn walkers still inspect the
> subsection map via pfn_section_valid() or pfn_section_first_valid().
> 
> After commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
> memory_section->usage") converted the teardown to an RCU-based
> scheme, the code still relies on SECTION_HAS_MEM_MAP becoming visible
> to readers before ms->usage is cleared and queued for freeing.
> 
> That ordering is not guaranteed. section_deactivate() can clear
> ms->usage and queue kfree_rcu() before another CPU observes the
> SECTION_HAS_MEM_MAP clear. A concurrent pfn walker can therefore see
> valid_section() return true, enter its sched-RCU read-side critical
> section after kfree_rcu() has already been queued, and then dereference
> a stale ms->usage pointer.
> 
> And pfn_to_online_page() can call pfn_section_valid() without its
> own sched-RCU read-side critical section, which has similar problem.
> 
> The race looks like this:
> 
>   compact_zone()                    memunmap_pages
>   ==============                    ==============
>                                     __remove_pages()->
>                                       sparse_remove_section()->
>                                         section_deactivate():
>                                           a) [ Clear SECTION_HAS_MEM_MAP
>                                                is reordered to b) ]
>                                           kfree_rcu(ms->usage)
>       __pageblock_pfn_to_page
>          ......
>           pfn_valid():
>             rcu_read_lock_sched()
>             valid_section() // return true
>             pfn_section_valid()
>               [Access ms->usage which is UAF]
>                                           WRITE_ONCE(ms->usage, NULL)
>             rcu_read_unlock_sched()       b) Clear SECTION_HAS_MEM_MAP
> 
> Fix this by using rcu_replace_pointer() when clearing ms->usage in
> section_deactivate(), then it does not rely on the order of clearing
> of SECTION_HAS_MEM_MAP.

The fix itself does not look too intrusive and I guess it kind of makes
sense when you think about the ordering issue, so if we want to be
rock solid, why not. 
Does it slow down operations a lot?

I would also point out that you rcu-protect pfn_section_valid().

Regarding the pfn_to_online_page() race, that is something that every now
and then pops up, but as David said, we never seen that happening in the
wild so I guess no one really made the time to look into that.

 

-- 
Oscar Salvador
SUSE Labs

