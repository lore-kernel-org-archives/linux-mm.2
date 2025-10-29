Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 711ECCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643D08E008C; Wed, 29 Oct 2025 11:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3BC8E0045; Wed, 29 Oct 2025 11:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BAD08E008C; Wed, 29 Oct 2025 11:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35FB68E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:37:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D500613BD21
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:37:25 +0000 (UTC)
X-FDA: 84051556050.07.2ACFBBC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 474F32000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:37:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fgmgu+IT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Uu6lBP9H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fgmgu+IT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Uu6lBP9H;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761752243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENJQWumhQFBRbBzZ2XQ78O0uq9YHFwzP1q0R/p8ERLo=;
	b=7fr+D7cMTD00C32GFToTdj6KRYRLOXiJ1oEWGVktJbIAZT/tqK+wOdS53j7ipzXIfvRMSZ
	BCIReFefbdI7hrpJJMR+RsDfXPIcm1VQWyLdWL4yJj6epnuRuTwdw2h9VGaEb5A2T55a06
	wZ/ZEkjhkr/LWXHhsx8shXr4WSAjxDw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fgmgu+IT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Uu6lBP9H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fgmgu+IT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Uu6lBP9H;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761752243; a=rsa-sha256;
	cv=none;
	b=moyI0DfAClRzqAA6OCmvnrG+nzdYcoZpHJoV52C4SN4+icZWE109XoMq19pmt8yQUN9dfL
	7lUOiCYaOJJCZrVwns/6b03sHB6379u8OU0fJkRacbWOzJ4ZxXxRr4FfSdzpzIMTLG840M
	Ql4E6TwPwgtKPb7KptHDjHFxcUE3YUY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6BB5120FD0;
	Wed, 29 Oct 2025 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761752241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ENJQWumhQFBRbBzZ2XQ78O0uq9YHFwzP1q0R/p8ERLo=;
	b=Fgmgu+ITLbZdDiWMzTF5FTjtGkdaD46txdnMMZCqCfBWgtK8RQqazEPPUkHwj3GyEmDt2r
	HHC7drpWoGk/xtmHwSSDGjF42ChHmSNSqUsOC0OKPgCirEJE3ZLPCCPP27ZOuc/4gOzwlV
	bhIex/DRWbgcXMvYdp1qnOeX1JLGgUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761752241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ENJQWumhQFBRbBzZ2XQ78O0uq9YHFwzP1q0R/p8ERLo=;
	b=Uu6lBP9HxMWJt9zMWubGmWEMUPxMGNADw5c/VIE2hc2Af17a5+c+tDA4DHBQCBu7FLCgvf
	t0VSyC4F+rQn3mCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761752241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ENJQWumhQFBRbBzZ2XQ78O0uq9YHFwzP1q0R/p8ERLo=;
	b=Fgmgu+ITLbZdDiWMzTF5FTjtGkdaD46txdnMMZCqCfBWgtK8RQqazEPPUkHwj3GyEmDt2r
	HHC7drpWoGk/xtmHwSSDGjF42ChHmSNSqUsOC0OKPgCirEJE3ZLPCCPP27ZOuc/4gOzwlV
	bhIex/DRWbgcXMvYdp1qnOeX1JLGgUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761752241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ENJQWumhQFBRbBzZ2XQ78O0uq9YHFwzP1q0R/p8ERLo=;
	b=Uu6lBP9HxMWJt9zMWubGmWEMUPxMGNADw5c/VIE2hc2Af17a5+c+tDA4DHBQCBu7FLCgvf
	t0VSyC4F+rQn3mCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D5DF1349D;
	Wed, 29 Oct 2025 15:37:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aaF/ErE0AmlyeAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 15:37:21 +0000
Message-ID: <90f21264-b227-4a83-9944-39d3e0ea40dd@suse.cz>
Date: Wed, 29 Oct 2025 16:37:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 03/19] slub: remove CONFIG_SLUB_TINY specific code
 paths
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev,
 bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-3-6ffa2c9941c0@suse.cz>
 <CAADnVQKYkMVmjMrRhsg29fgYKQU8=bDJW3ghTHLbmFHJPmdNxA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQKYkMVmjMrRhsg29fgYKQU8=bDJW3ghTHLbmFHJPmdNxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: znc5bk9mahtjgyirwr8y4af78qw43ttp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 474F32000D
X-HE-Tag: 1761752243-106651
X-HE-Meta: U2FsdGVkX1/+mPmKjJbWApa3XTWM9aAgfnm6SI1anGPljv4SP2nz2yNSSaut21K+wCgWSVwlDcE2mBdkihw1v7ibNKsocuFVk0C6kB2s0QZBpxpdeoy5/3pYueT+S/h51NEmvdWEMod5kJFDOqC8LLkvg0vrWII27dloKwRrA5U3bBya81wH7v6LTRwI5wecw3u1is4SCIfAwo/pRVSgnlG7FwJcmlAgh3GF1v7ut2ki9FPSkOoCmeW/2eYrrtQXILLiNTAC0kx+tDyTuTPTAMk7826PQNngae5IZQaLHXKlVNzfzLXAx4b50iYZR9Ifc7yDV7yUFflObePuovctCC06+YJ+ViQ1WPUlYIInuoOWwY8b/vcvLl5XFi0w9dRsfxC4BKr50wVTS+tdb2vqqp6RDnkE7Bk9x2/7iHWpmb2mhf+GX6Y9iY9yXUk/FvhAx8IZh20cv0nmPChbl3sfGFq20IdIDQ8ykLcca4d3Fp8hG1YuRd80hxKnWVW9iSBmoHndPj7hPm6THZlsLa1q85+fGs5Sm13/NKu3RJgPVb4InKKsGenZqQZxskG5/jBx+sPZSgyHw0jSQJdVsOTsCyInh8VXBM/m6bRvQxUHHlnRxPZ0KOE5pqMk6y+WmWrbVraJVBVoSpLaMsUd03J+XT4egDK5kqVzX+rcqntdfYHcA3opHyiIf0yLpviDX3bhxsT481dbqpkfc/D5kBVIgMfCtPhpiS3el6WiQxvYJjlH0WD4nMNk9Y1at6vE2LaWpzOdJ6rWXnWUnS7uHprA/wWYxjEPAlmJCExx6T4mSBuW7uhDnmX3e/OmwcV74BmBEgtM9QYJDWCTUIAhaUZWBNjcVZryHxoa1X3eoVC4NXKZ2nrtgctAqmlcUCFj5Rj+/GZ8RLwU4mkejNunvqVqrrxwQjt4v7KtOmKHexDDIpy6bi8yFLofi+j+3S00e9NtZd/NJmL23OcfBCDbIsj
 cGgG6pqV
 Y0bZ6SlRS+jbH9YBDyvF/52FZhr1ce93sGG35LhmgoYpSiwe5F3+duUzfNEyBUHaVPOAjkbUqybwQP2ZWcXtE9YewCFI/XN6gzCITJSTVNoO6oai5TsLzFmBSx+lfC57kqNLAltw3xuSQbM0AL3gYH527xb54jVq8TxCtdsRcJZcXwVXQYofH66IVh4Rkf2xEpAfMGXG0Z37rAO/dXf//1AhDkgqXv/U7liBJPEAs1Zt0+5r8OTC4srmB9lwLQkzWLMTqN/k6O3CcO4KKUzGFW1R2bDumY2HD/6eTDONgyJ1YZoBAJsUBoX2ExMUW05yjBXgCqb8OZjS2nXNT70Mwo1vyFfsS/DNbOKzkBQw06b4v8F8HyYLyZVWlmFeFtWKbmBd6L9gdUtWKAIMlcYt7X9QPXl7NtTu2QL9RGIFF9g7eINs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/25/25 00:34, Alexei Starovoitov wrote:
> On Thu, Oct 23, 2025 at 6:53 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> CONFIG_SLUB_TINY minimizes the SLUB's memory overhead in multiple ways,
>> mainly by avoiding percpu caching of slabs and objects. It also reduces
>> code size by replacing some code paths with simplified ones through
>> ifdefs, but the benefits of that are smaller and would complicate the
>> upcoming changes.
>>
>> Thus remove these code paths and associated ifdefs and simplify the code
>> base.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slab.h |   2 --
>>  mm/slub.c | 107 +++-----------------------------------------------------------
>>  2 files changed, 4 insertions(+), 105 deletions(-)
> 
> Looks like it is removing most of it.

The special code, yes. But the savings from avoiding percpu caching are the
most important anyway and they stay.

> Just remove the whole thing. Do people care about keeping SLUB_TINY?

They did when SLOB was being removed. We can always remove it completely
later, but this code cleanup is enough for me not to complicate the further
changes, so I wouldn't want to put the complete removal in this series.

