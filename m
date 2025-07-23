Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B46C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECCE6B0095; Wed, 23 Jul 2025 05:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E296B0096; Wed, 23 Jul 2025 05:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765BB6B0099; Wed, 23 Jul 2025 05:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 606356B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:17:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2992C0618
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:17:20 +0000 (UTC)
X-FDA: 83694975840.10.C2A328B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A5AC40009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:17:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cYvXp/6H";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPxPU7cX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cYvXp/6H";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPxPU7cX;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVlMssvby1yb993DflorYya9fMf7ULYpb5K7ZCVR/QQ=;
	b=oVvfSVH7voYYIxBDznvPddIl1E9tnxBLq9omXAz/U0v2y9zFon/1OGkzDbBfvKZ9ZogWK2
	k2mZozPqgb7ziKOG1qFSxwbGdbZlBIv87QEQK8HwNeaoXgwNhQleHFuB3LO9eLf+2NaJJl
	R05LpFjYc2bnqRea3ISjioMIxjMRppQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753262238; a=rsa-sha256;
	cv=none;
	b=ZJtIp6sDv++TeddblT/hsIP5XVNecZt/uRajiB7gN9GRTyN6xEPkNR7GcLE0pY44MvdMv4
	0QuEYQfuaiVUUWemHOoCn6z9OTgESR5TpN4n5O6rCRRhMYzIxb2l9LmTAOdEuWb1UE9Mmp
	d7O6fhqs6m/LJOQ1Qh1QAH7HNYn4ZpU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cYvXp/6H";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPxPU7cX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cYvXp/6H";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPxPU7cX;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C646B1F449;
	Wed, 23 Jul 2025 09:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753262236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UVlMssvby1yb993DflorYya9fMf7ULYpb5K7ZCVR/QQ=;
	b=cYvXp/6HHgVExIjwjAVxinOeVgIZ30zRsCN2DZO6UBg45M33SS4maL4w4WMcNT0f3NFxP8
	UJDHKfVb70bodbsNkc8lL8GYEYTYeod8TQh+5q0SyFAsHh2mCetI+4Nw+c9R+QpwvL05CV
	3pvsKcuNGrCC4+GyEDnKXuXfZwqp4EM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753262236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UVlMssvby1yb993DflorYya9fMf7ULYpb5K7ZCVR/QQ=;
	b=YPxPU7cXW0qfRn6uob62I8yoI1iOKTE501/jCr24E9+QhP3RvDXKS+ESDuSDntaUhDsfYi
	wZEremmY4d3Cz2BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753262236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UVlMssvby1yb993DflorYya9fMf7ULYpb5K7ZCVR/QQ=;
	b=cYvXp/6HHgVExIjwjAVxinOeVgIZ30zRsCN2DZO6UBg45M33SS4maL4w4WMcNT0f3NFxP8
	UJDHKfVb70bodbsNkc8lL8GYEYTYeod8TQh+5q0SyFAsHh2mCetI+4Nw+c9R+QpwvL05CV
	3pvsKcuNGrCC4+GyEDnKXuXfZwqp4EM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753262236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UVlMssvby1yb993DflorYya9fMf7ULYpb5K7ZCVR/QQ=;
	b=YPxPU7cXW0qfRn6uob62I8yoI1iOKTE501/jCr24E9+QhP3RvDXKS+ESDuSDntaUhDsfYi
	wZEremmY4d3Cz2BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9EA5913302;
	Wed, 23 Jul 2025 09:17:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6NUHJpyogGgQVAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 09:17:16 +0000
Message-ID: <fb5426c1-c94b-4e79-b09a-fb6b8b1ce03b@suse.cz>
Date: Wed, 23 Jul 2025 11:17:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
Content-Language: en-US
To: Xuanye Liu <liuqiye2025@163.com>, David Hildenbrand <david@redhat.com>,
 Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
 <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
 <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
 <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A5AC40009
X-Stat-Signature: g9pdc77o4hyckyk4wt1tk67645tn981p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753262238-887352
X-HE-Meta: U2FsdGVkX1+vGfeuankIl5A21kDcIUmKLS+XJ3yoxxBYW15pZOmJcYJZF4sT5lsO1T0xIcQjOMWGAh+6taYfTg9Fb2RmcDZnBY3SQyloMFaBTjLbc6kDcnQL3Y0mPu4FSrzAauDV/eCsEJOfxfQJuLaZ47ey+IPEKpGKdDUDZGVUJ6fRGCjeZSJGTAkfulxLkREBjQHaCjuwO2P5zsLkBSahdkyJRY13HWQzQkerpjZKcT3bmMAjf/n05qKOm6rE0lIvE10AkJWbBwPL+B+zCYFnAnlpUKbJfhUfYK8sxn1F5KnxiTbqya2EWhOe6s6vlfJ2jelO/HlVjEqjmuYaAqCPnTS+lMZp2XS2L3rC+UNqxz2ZFxvZhFjYag/2YRnfAu/dbT+j5RB/r6XB6AHo1J1S82+1dptJlw+WHDzQBaZJN1e4AJl9TbtUhsoIfrp1uim8JNx5XXxSEBFjMIpK9DFAQygltD0c6JIMxPkKTXUFEhJHVSI9eWTzFtmqfA5MnupxJsP3qGf4y2A0PhjFsVvKAmuXUz3odRjg0FLIfaQ34Eq3VyYWC+BV5mZKrnHmh4GqJm+If3ai5AuN+VO8n5fUBfx4RcGnzJXRT41ltS1a37D8X53D/Uq9/tF2YcXKBCCIizaBfKjMjoIBPk795Tx5pqO13MgVuSkmbq9QFXsCVgL3grwqPruLFJ47/mVq6Dy1Y3XwHo2Nf1IedX20J10bEVIRcO55FxjQDbpfvuZDBGT/RBHgXm4cWOghpBtQhLbPJHEKPcCxNaD/87GroViYk8jZDyy2VleQWfQu92B3DD23D06jo9L4PUxtkdS8BOu96NOAlmKQNpjVNq+0szpGKwa1W5sFIRavOPd7bv1J9Y0eSQf8qWhYzsuSt/Zx5XqZ7ibijc74VikJXTRqH130xhvkjQqb7nRQyfjnbxle2fYJjQOLTxVeOqe53dmBaIqLg4Xp7Y6ZbkhXdAn
 wj+PPfpz
 8ZfmTjHKrYGwzOjKOA+7g1AubQn/IYGVkhrLg6KwcemwyTFVgVCc+uNE6oraEWfQFoeJclJAi4tmpqsi/1oWXYGT7fzq//hrGD/4FL++OQFFIU0/T/4QEq1ovjWmlv8h6Ik5vbsVxUkIzKgLuGHUdyf5ZOfMV6vitX5EmY9o1jckbI48giLTtTmyAXbeP9VpxwnFQdTIBMgNiFouGDLq4RtgNNSP6RZp7AYihSX05ukbRkjTH58VzMERvDS7mS8+Ua2OMfUQlwYkjkLswAmEHsEZUFvUiQZf6V3dac4F/ANI0JZ6ErEnL7/mQNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 11:10, Xuanye Liu wrote:
> 
> 在 2025/7/23 16:42, David Hildenbrand 写道:
>> On 23.07.25 10:05, David Hildenbrand wrote:
>>> On 23.07.25 09:45, Xuanye Liu wrote:
>>>>
>>>> 在 2025/7/23 15:31, Kees Cook 写道:
>>>>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>>>>>> The check_mm() function verifies the correctness of rss counters in
>>>>>> struct mm_struct. Currently, it only prints an alert when a bad
>>>>>> rss-counter state is detected, but lacks sufficient context for
>>>>>> debugging.
>>>>>>
>>>>>> This patch adds a dump_stack() call to provide a stack trace when
>>>>>> the rss-counter state is invalid. This helps developers identify
>>>>>> where the corrupted mm_struct is being checked and trace the
>>>>>> underlying cause of the inconsistency.
>>>>> Why not just convert the pr_alert to a WARN?
>>>> Good idea! I'll gather more feedback from others and then update to v2.
>>>
>>> Makes sense to me.
>>
>> After discussion this with Lorenzo off-list, isn't the stack completely misleading/useless in that case?
>>
>> Whatever caused the RSS counter mismatch (e.g., unmapped the wrong pages, missed to unmap pages) quite possibly happened in different context, way way earlier.
>>
>> Why would you think the stack trace would be of any value when destroying an MM (__mmdrop)?
>>
>> Having that said, I really hate these "pr_*("BUG: ...") with passion. Probably we'd want to invoke the panic_on_warn machinery, because something unexpected happened.
>>
> The stack trace dumped here may indeed not reflect the root cause ——
> the actual error could have occurred much earlier, for example during a
> failed or missing page map/unmap operation.
> The current stack (e.g., in __mmdrop() or exit_mmap()) is merely part
> of the cleanup phase.
> 
> Given that, how should we go about identifying the root cause when such an issue occurs?
> 
> Is there any existing way to trace it more effectively, or could we introduce a new mechanism
> to monitor and detect these inconsistencies earlier?                                         
> 
> Let’s brainstorm possible solutions together.

Excellent idea! How about we introduce a function that walks the whole page
tables and checks the numbers of individual pte types against the rss
counters. And if we invoke it before and after every single pte update, we
can pinpoint much sooner the moment it went wrong and the stack that lead to it?

