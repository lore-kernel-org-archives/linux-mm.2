Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61EA2CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF366B0005; Tue,  9 Jun 2026 05:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6CA6B0088; Tue,  9 Jun 2026 05:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC7A6B008A; Tue,  9 Jun 2026 05:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A98426B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:38:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D7A0164718
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:38:33 +0000 (UTC)
X-FDA: 84859874106.02.B1B3EFF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 17B4240004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:38:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RpU3rkyb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pDGmlFH1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RpU3rkyb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pDGmlFH1;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780997911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Srm7PK7AT6aFPTM2v6yJ9xkkVvxKv/0zAI9E1iz1CtU=;
	b=Z3/uqCsc5LAttnzaVr6GP7s2RG4AWe5b/w3pEQcxWsglkij3v+cHH4CX/5wORql+a7pW7P
	XxG/CiuWSDJuYyXgUJF1a60qnK/T9CKVjQyqWtW7IG3f8WOyoFV9Q+5JnBTbIUROa7J2Kt
	z7qEeMfkEl2IfXIAPR2NbtvSr0WtbfU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780997911;
	b=L1dLOc04Fv9zdbbn9bWw5frw81pBSX/lx2HBIk7yeyRZXQp12ml9cJFct/jttco7us8sAH
	VnBaJTl9eQd2mUryybA79ODT7wgj+x6mCtFcJuXkd7rMWTP7DC/QS8afCW5BStt5v/lt76
	TTjHBhFYeIhMCbxZxnNGsFfc76ZzcTk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RpU3rkyb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pDGmlFH1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RpU3rkyb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pDGmlFH1;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4A326A901;
	Tue,  9 Jun 2026 09:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780997909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Srm7PK7AT6aFPTM2v6yJ9xkkVvxKv/0zAI9E1iz1CtU=;
	b=RpU3rkybMsMghOlt3HwyUr22B00VNY79+Pq3HaO/+h6Bx+/m3zVc558EWP7TZVEnsKxbYG
	u+5saTqDMGBnyFDbRru6EON8ql9QfTIzBZCYP5oEjqViKI1AzjQlRRyWdS99PaBaAKji84
	tbd1Lt6ymPN6dF7/PPdEJYh9+2ktt4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780997909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Srm7PK7AT6aFPTM2v6yJ9xkkVvxKv/0zAI9E1iz1CtU=;
	b=pDGmlFH1FMvV/iCjLi0vK52DoSH7RL697Fp3yAtsGROXYwQF1Qt34Rw0GMjbfJyL/elsyY
	y2Nk3ATPt+959UCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780997909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Srm7PK7AT6aFPTM2v6yJ9xkkVvxKv/0zAI9E1iz1CtU=;
	b=RpU3rkybMsMghOlt3HwyUr22B00VNY79+Pq3HaO/+h6Bx+/m3zVc558EWP7TZVEnsKxbYG
	u+5saTqDMGBnyFDbRru6EON8ql9QfTIzBZCYP5oEjqViKI1AzjQlRRyWdS99PaBaAKji84
	tbd1Lt6ymPN6dF7/PPdEJYh9+2ktt4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780997909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Srm7PK7AT6aFPTM2v6yJ9xkkVvxKv/0zAI9E1iz1CtU=;
	b=pDGmlFH1FMvV/iCjLi0vK52DoSH7RL697Fp3yAtsGROXYwQF1Qt34Rw0GMjbfJyL/elsyY
	y2Nk3ATPt+959UCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F753779A7;
	Tue,  9 Jun 2026 09:38:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8vWXBhXfJ2o0KgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 09 Jun 2026 09:38:29 +0000
Message-ID: <fac2d527-e861-4f79-8e45-35f8993cc33d@suse.de>
Date: Tue, 9 Jun 2026 11:38:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: increasing PAGE_ALLOC_COSTLY_ORDER, was Re: [LSF/MM/BPF TOPIC]
 Memory fragmentation with large block sizes
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andy Whitcroft <apw@shadowen.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
 <aifAm1rRKF75HVeM@infradead.org>
 <1225376d-dc29-44a1-add6-0cb14926a538@suse.de>
 <aifWqFpSkcMU31UO@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aifWqFpSkcMU31UO@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 17B4240004
X-Rspam-User: 
X-Stat-Signature: opmqnq6mzhra3naa1mf7dbjcz1dzo11u
X-Rspamd-Server: rspam08
X-HE-Tag: 1780997910-492838
X-HE-Meta: U2FsdGVkX18mzMtRb66IBaTZ7E90MyiAAso89S2MO5W+aN71nSP/fGuira7bfOHjb0QxY/VvZElnozkfrY7OIXBmkNKRP925mc1YhlqU5EHYI3raK1pBtHcIGo4nHUzTYELt5mIEW24e7BqOZqX5FF8Mxr2DtbrdVVa0R4X9oe+nUqW6naIDWPPMeapYbfWRBHuM3KR3OQKE+oIzQQUaI0yNyCseS+6N2LuzX6n50PIsHLxPiJI47UCSTNgkoxItqwt4afwojklzVO/4Co7VK3lkWypqQTlmtJXzIYBM/mJL3UqRu9e1tRYJuVu91tc3g5KfBGBfFSFxClIoT7msqP/zm2BfibNwxfYSw1zOKWGiA1BOU5QuJI196i2SIf2dveISHYelcF9CH0QGy4979Q+wMPvzdq9d2vhFtjVOwfkgCNYiNqtOY7eCaiDWB4doUthKgusxBiIAHsWKQbqMP8JRMSq2Lufos0SYvKZS7NURnYi9F+f+PurMLQEqIutNEk3TC7Kt3mN1zh1ywUKOZIfgnsecQalwWXc+wpTja4Uw+fn10C2CI7AGIFdscHi9Lg80MiGTj00a9vB3/FQ841al1gaCpbze8Ivek80JtyXQpjcaF6XMThiXzauhIvYLTWjYpaWfHsanRednUQSn6R2/uVNxR4cYWhk8jZlOMQ7bi5z0EVnYUDiEznJlNftDur5mrdKsN5Lsq9MlwEXy0VWrUipwB5pCytRwpJdPOvm7ERT6ToaeiPYTJlCr8P1EXSpTuLR0Bou9DyqA2AWNczpW72YHlzvR5xoPnw6yIGr2U+JRCnchjNzhRT/D7G7XP2rYz3tgPFs+pkC+ZNr7991PtqeXcEnohhkb0jEct++Plj+Iouz6lNV0NfNWwusQjravntbnGu3u5fQutpZ9hNu3JCaKccX25iKFMPmXI6YazmmOzhDfZp+8WSq5lZHoIG+2XM+/XjFy6FCVG0s
 waHbdmi7
 uMq8bKdTwXzCO8A5iZUslqYMLOVm0bJ0I82AFqA9gIl4oZQbHtNMnvp50tevXJOzqQBeneIiJlMk0ZxMBqdMLtqZQugtriyVlFSYxTDpeChiWW7PctYpAd29M0GunHqnsjx8m3PBqoH4Sqtptb1myT4Arat8svAlhTjJ/GkkGNRLCBef5OazVreU7syAtcK7WJK07XqTyc87cXGHrnG1JuZ1p+f0aZgurIL+anxd6fAibDVYiJkDN6S+/S9l1WCuPZQz7PVi27+qFkE7MXUWRA9tjgQx7LV2Dq2sSjq9XN2Ek75U9Qg9TFjA/R3DztiqfCOWbEq8vQCEh8yru/UtgYfJ+QAmzFMejW/6qx57ASAIGZvjfe14Ng5NAZDvaXPwSKVYj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 11:02, Christoph Hellwig wrote:
> On Tue, Jun 09, 2026 at 10:39:14AM +0200, Hannes Reinecke wrote:
>> With 32k block sizes the picture changed completely; the 'bump'
>> vanished, and there was only pronounces spike with 0-order pages
>> (about four times the size of the spike with 4k block sizes).
>>
>> This led me to assume that compaction broke down at 32k block sizes;
>> this assumption was confirmed by Vlastimil Babka who pointed out that
>> there is a maximum order to which page compaction is attempted:
>>
>> include/linux/mmzone.h:
>> /*
>>   * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
>>   * costly to service.  That is between allocation orders which should
>>   * coalesce naturally under reasonable reclaim pressure and those which
>>   * will not.
>>   */
>> #define PAGE_ALLOC_COSTLY_ORDER 3
>>
>> and it's main usage is 'order > PAGE_ALLOC_COSTLY_ORDER'.
>> Which ties in directly with what we're seeing.
> 
> Yes, we've also seen similar issue with memory allocation beyond
> PAGE_ALLOC_COSTLY_ORDER.  Right now the maximum block size supported
> for XFS is 64k, and there's various workloads for which we'd like to
> make use of that.  Increasing PAGE_ALLOC_COSTLY_ORDER to cover 64k
> allocations would be extremely helpful to make it perform well.
> 
> How has PAGE_ALLOC_COSTLY_ORDER been chosen?  And what would it take
> to increase it?
> 
Not much; it's basically a setting which we can change.
Measuring the _impact_ of the change would be the tricky thing.

>> It will probably make sense to align the maximum block size which we
>> currently support (ie 64k) with this value to ensure that compaction
>> works with larger block sizes. Or maybe even the other way round;
>> tie the maximum block size which we support to PAGE_ALLOC_COSTLY_ORDER.
>> But that would mean to restrict the blocksize to 16k, whereas xfs
>> works happily with 32k. So we might want to raise PAGE_ALLOC_COSTLY_ORDER.
> 
> block sizes larger than PAGE_ALLOC_COSTLY_ORDER work, but it doesn't
> perform great.  So I don't think a hard limit would be good.
> 
I was thinking to tie the block size to PAGE_ALLOC_COSTLY_ORDER, and 
make PAGE_ALLOC_COSTLY_ORDER a Kconfig setting.
That should give us enough flexibility to test out things.

But sure, just making PAGE_ALLOC_COSTLY_ORDER configurable would be
enough here for now. Until someone comes along wanting to have larger
block sizes.

>> Question is, though, how could we measure the impact?
>> This particular value has been in since 2007 (commit 5ad333eb66ff1 'lumpy
>> reclaim V4'), and it might well be that the original
>> reasoning doesn't apply anymore.
> 
> I've not even seen much of a reasoning for picking the value in that
> commit.  Or did I miss something?
> 
I haven't seen anything. It was merged in 2007, and I would suspect
that with compaction (which went in 2010) most of its reasoning will
be obsolete anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

