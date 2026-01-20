Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AC3D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C1B6B0404; Tue, 20 Jan 2026 08:53:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA2B6B0406; Tue, 20 Jan 2026 08:53:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1046B0407; Tue, 20 Jan 2026 08:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 893A46B0404
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:53:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F62A140586
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:53:35 +0000 (UTC)
X-FDA: 84352484790.24.E919804
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id AE2CB20008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:53:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZexLY8tP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rmvli727;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZexLY8tP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rmvli727;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqKkMtS0KU8ZcdmqP+5+V86Ckg0CaMGNunHU579OoB4=;
	b=4cYgcdzCUAwi7//kguFVzB9PO8awXeH4TMEUgCyXfmo60MMNQ1TOqB3F6Y+vzb4vlyInus
	bYEZs7jMmoyzS502dYR4LOP+x4qUmMjHhoBJOPsYs1+04qy1TUIK1Zpb+ApdFt9oXXmobG
	jLqTnHrDXLRdm5CPmYAFIyaQqfP24zg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZexLY8tP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rmvli727;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZexLY8tP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rmvli727;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917213; a=rsa-sha256;
	cv=none;
	b=jv8wiz/b55MYFmdwrfwlcnUVGm1WlS6VvmM0Ry3vM2nW1M+MWqkxekGx/Oo0LK+gjJRoyg
	Juw4eNiuUKdXdX2kVwrerTalCjmHzqCFaSkzmtA8RTW1QdTFHBY5mZa2RAMJiB6y+GzXQq
	MhnkCCzF+cOYBljY/8ERfa8tUlh6SP8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2DC65BCCC;
	Tue, 20 Jan 2026 13:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768917211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KqKkMtS0KU8ZcdmqP+5+V86Ckg0CaMGNunHU579OoB4=;
	b=ZexLY8tP0oXVpVFwefK4bjndfkLTr8kNDrkaT62Oek03uJ4HuYlfujKeVdE8Cg2U5N0BV5
	aPcBBSi56BWVqaGNzn1JgnugsKX+dTrSJh98j7o2WyRC2AA+uPgCPb/cqpquFga4WNyed8
	TjuetzW6vVKEKaMwFkfayWw0DN6zjxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768917211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KqKkMtS0KU8ZcdmqP+5+V86Ckg0CaMGNunHU579OoB4=;
	b=Rmvli727iuePClT02xFlOmBB2r8dDmP3wr/tOJLzd5NfUHmYrlsSDSkUpWJRHzTeSYP/bI
	jYn0RIXnAip3KZBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768917211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KqKkMtS0KU8ZcdmqP+5+V86Ckg0CaMGNunHU579OoB4=;
	b=ZexLY8tP0oXVpVFwefK4bjndfkLTr8kNDrkaT62Oek03uJ4HuYlfujKeVdE8Cg2U5N0BV5
	aPcBBSi56BWVqaGNzn1JgnugsKX+dTrSJh98j7o2WyRC2AA+uPgCPb/cqpquFga4WNyed8
	TjuetzW6vVKEKaMwFkfayWw0DN6zjxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768917211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KqKkMtS0KU8ZcdmqP+5+V86Ckg0CaMGNunHU579OoB4=;
	b=Rmvli727iuePClT02xFlOmBB2r8dDmP3wr/tOJLzd5NfUHmYrlsSDSkUpWJRHzTeSYP/bI
	jYn0RIXnAip3KZBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBAC13EA63;
	Tue, 20 Jan 2026 13:53:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iGHtL9qIb2kHPAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 20 Jan 2026 13:53:30 +0000
Message-ID: <30f843d9-03cf-4c7c-8a29-8e11b12e47e4@suse.cz>
Date: Tue, 20 Jan 2026 14:53:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/vma: use lockdep where we can, reduce
 duplication
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1768855783.git.lorenzo.stoakes@oracle.com>
 <bd410fd91d22eef37f9b617327cafce33b267b09.1768855783.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <bd410fd91d22eef37f9b617327cafce33b267b09.1768855783.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE2CB20008
X-Stat-Signature: o9bjkdpidezgfchncoyabs1sinpa96jg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768917212-873719
X-HE-Meta: U2FsdGVkX1/YuBBiNrh3it7HXi6y/8c/WQorqfb+wIBiNqZg8jhnikdW+M7UL8URDAjTxpbdC+gsGo9fzy00EN6jMQYyUW9nMRp7lurPC3M8w4S8/8AOaCkeDGDG3Bt4KJnZ4v8plRNC8BL5zmU/EcRd1O+XFh1KbVyac0/q8PL59OoI+ls+kLWexlJ//sarxyNwPkTKFMvFxJR/VC9UQUg9CcSwVCjwmx94pz2HvaFU3XQdPl3KgC10+BSNkw9UkJkhbceNxy5DjyNMFItxdzGaYA7C5bQ4Gq6CQWPCI9j4R11mF8CdfeJNnTdm7m1zgEG0KHh6eVkHecFtBnybzYhIG/L/KIqDRagU7yy5kQgkICgemN2LPG8+aQOZygHxybD4+uQj2GCL/JKtLHU/fiZOH06YfJrxs2HRQQ0nqTJCwK7nsygq422qmjOSyAsc+qLuSDp+DCLTdoOMMZaWHSsDfYeWeJl77sl1h0pbVCaY+fe6jljQRqA6VPSsTUAm17ccjItaYeeSo7yEBx3Z/4G/ZoKgfvUh7VP0AxkIOXjE0kB+uFRDfdID9AUw2du+wcGtrn/9DH7f/YQeVqjw9G74GjdJu5Zirt9/bhXB6lqwz6bb6KF1sujoYmVJ30PWdo1HgSiGwr1P4yT5JJPDY9Ud7mcTzctNq4aP4kg0EW1NzggNu9b3RgpMHGm5LmaMeqlNWdpZs8tl8I6FFRGmSRPxlh6o6jA7TzUyLbW9eFhXzPmdi6F21wcmNUW+WGylfLgInomqVo1sBwf5MPsrM9LPyovSCXFBBDsbkV310OBJpCHb9ifu6BiFpYqh4kZvg5BKiU0w8CY9cikJxR4GQqQCtlDVRYjxm7OJ19Vc6iyhap7n2u9s+p2Zwv7vULhk0H99pNw3GtJwGv8sv0HSm4u6vrVCNAK6FNzZtGs1UL6vRPh8saiBu5b/U1sCsainHRondrhdcgQsV58W8tN
 F8+x+ENi
 65Cvk1qk6kOp6H3i44BbbHQtDzlc7LCeLbtXfo2b76ooDk+r9N3XEBH5fXup1rFoVNkwH7nWsYhsvR/JGiDenhHJvjcxqzjsarN4oGzCfkrLxZCbKx8mavIfknp8PyZSDWZ1iupPNnbZ8b2kKnUu4sO7KV5ofv1PdBk5fvIalS0cuGG7R4tGplrYZncy3CEZsgCD9ItiXPP3dCDN48cQhSnWtAdy+r8NNgSf9nkdm4Ux511MYdu5Dv/OmOdjEzZRxuAeKh0M+RYAJ9PAIw2iTh1FEJyVEuOFRci0hJM+zGnescjMX0MdH9WIV6HkqSajcEaHA2JEybrWE113AVnUmjz9d8RKTLfMn4U13QWqX9lXUlHRvjfIMp7adHbxQ/riQWDZB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 21:59, Lorenzo Stoakes wrote:
> We introduce vma_is_read_locked(), which must deal with the case in which
> VMA write lock sets refcnt to VMA_LOCK_OFFSET or VMA_LOCK_OFFSET +
> 1. Luckily is_vma_writer_only() already exists which we can use to check
> this.

So I think there's a bit of a caveat in that

- is_vma_writer_only() may be a false positive if there is a temporary
reader of a detached vma (per comments in vma_mark_detached() and
vma_mark_detached())

- hence vma_is_read_locked() may be a false negative

- hence vma_assert_locked() might assume wrongly that we should not assert
being a reader, so we vma_assert_write_locked() instead, and fail

Howevever the above should mean it could be only us who is the temporary
reader. And we are not going to use vma_assert_locked() during the temporary
reader part (in vma_start_read()).

So it's probably fine, but maybe worth some comments to prevent people
getting suspicious and reconstructing this?

But I think perhaps also vma_assert_locked() could, with lockdep enabled
(similarly to vma_assert_stabilised() in patch 2), use the
"lock_is_held(&vma->vmlock_dep_map)" condition (without immediately
asserting it) for the primary reader vs writer decision, and not rely on
vma_is_read_locked()? Because lockdep has the precise information.

It would likely make things more ugly, or require more refactoring, but
hopefully worthwhile?

> We then try to make vma_assert_locked() use lockdep as far as we can.
> 
> Unfortunately the VMA lock implementation does not even try to track VMA
> write locks using lockdep, so we cannot track the lock this way.
> 
> This is less egregious than it might seem as VMA write locks are predicated
> on mmap write locks, which we do lockdep assert.
> 
> vma_assert_write_locked() already asserts the mmap write lock is taken so
> we get that checked implicitly.

> However for read locks we do indeed use lockdup, via rwsem_acquire_read()
> called in vma_start_read() and rwsem_release_read() called in
> vma_refcount_put() called in turn by vma_end_read().
> 
> Therefore we perform a lockdep assertion if the VMA is known to be
> read-locked.
> 
> If it is write-locked, we assert the mmap lock instead, with a lockdep
> check if lockdep is enabled.
> 
> If lockdep is not enabled, we just check that locks are in place.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mmap_lock.h | 34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index b50416fbba20..6979222882f1 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -236,6 +236,13 @@ int vma_start_write_killable(struct vm_area_struct *vma)
>  	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
>  }
>  
> +static inline bool vma_is_read_locked(const struct vm_area_struct *vma)
> +{
> +	const unsigned int refcnt = refcount_read(&vma->vm_refcnt);
> +
> +	return refcnt > 1 && !is_vma_writer_only(refcnt);
> +}
> +
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>  {
>  	unsigned int mm_lock_seq;
> @@ -243,12 +250,31 @@ static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>  	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
>  }
>  
> +/**
> + * vma_assert_locked() - Assert that @vma is either read or write locked and
> + * that we have ownership of that lock (if lockdep is enabled).
> + * @vma: The VMA we assert.
> + *
> + * If lockdep is enabled, we ensure ownership of the VMA lock. Otherwise we
> + * assert that we are VMA write-locked, which implicitly asserts that we hold
> + * the mmap write lock.
> + */
>  static inline void vma_assert_locked(struct vm_area_struct *vma)
>  {
> -	unsigned int mm_lock_seq;
> -
> -	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
> -		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
> +	/*
> +	 * VMA locks currently only utilise lockdep for read locks, as
> +	 * vma_end_write_all() releases an unknown number of VMA write locks and
> +	 * we don't currently walk the maple tree to identify which locks are
> +	 * released even under CONFIG_LOCKDEP.
> +	 *
> +	 * However, VMA write locks are predicated on an mmap write lock, which
> +	 * we DO track under lockdep, and which vma_assert_write_locked()
> +	 * asserts.
> +	 */
> +	if (vma_is_read_locked(vma))
> +		lockdep_assert(lock_is_held(&vma->vmlock_dep_map));
> +	else
> +		vma_assert_write_locked(vma);
>  }
>  
>  static inline bool vma_is_attached(struct vm_area_struct *vma)


