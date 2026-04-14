Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F9DF531F8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE446B0088; Tue, 14 Apr 2026 03:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85346B008A; Tue, 14 Apr 2026 03:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AFE6B0092; Tue, 14 Apr 2026 03:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B85F46B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:08:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5EDC58BA0A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:08:27 +0000 (UTC)
X-FDA: 84656283054.11.50934B7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BCF81A0006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:08:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2ZrEZXGp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5oqspILO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2ZrEZXGp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5oqspILO;
	spf=pass (imf19.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776150505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wt6kw4jL5p1XsC5RPgmFgPFuBvYztobMsY4SgGXfGIc=;
	b=O7XCwQQyJcSv4cIykjNbYdpkDf9ywvpH/hMV6ntaZI+APzTpBEflJ5oN0NxhYODFNDjwm2
	cOrFQ4MgL4jI7HNvA4Gf3gDS1bfjuyXhr7ZVNJ25MTi3OQq62t9iV1In2y5JcPXhZYDvlT
	ybjlkuOZlrNxSc+3JgH2V0tiWRye0PY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2ZrEZXGp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5oqspILO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2ZrEZXGp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5oqspILO;
	spf=pass (imf19.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776150505; a=rsa-sha256;
	cv=none;
	b=ONXAa4bYNyJdLLC2bZfLQ0/9OHLIJ9Pwjt7G74xySYnEmmILb2jN19Lhi8vYdl+Z2Yz7si
	RkGr9J4+cT9o+SnsG6hPFaX7foWH+WhiQCwHOXUqSPzL6V8NdRN8hdQcDCa69rgDo3pmx/
	VvhSksxT2YqG4hEReYnGzuCLx/Do8aY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F1225BDC6;
	Tue, 14 Apr 2026 07:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776150503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt6kw4jL5p1XsC5RPgmFgPFuBvYztobMsY4SgGXfGIc=;
	b=2ZrEZXGpnbNVpWl5bb3rjDubn8n/uzqsSwnNSubmdUKYn061Yu/3GKbR4Z7I9Y5S/dOu1l
	hDMahK0ZAntq0tJ4cRPcNY52JJ//x7qsq2RUWV1SbnAAfRpbg9Elsu/Gzu0y3ewcO0FtWX
	3O/ukZPgqns4u3oHem6D/H3tbr1lCuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776150503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt6kw4jL5p1XsC5RPgmFgPFuBvYztobMsY4SgGXfGIc=;
	b=5oqspILO4TNmq/oBc+DBMhbzi6+Zy/7eixVJk+OPjH6QOcOcz2RM0hUAJUKLnc4J5TJRGa
	G3hPwIt2kWJW5tCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776150503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt6kw4jL5p1XsC5RPgmFgPFuBvYztobMsY4SgGXfGIc=;
	b=2ZrEZXGpnbNVpWl5bb3rjDubn8n/uzqsSwnNSubmdUKYn061Yu/3GKbR4Z7I9Y5S/dOu1l
	hDMahK0ZAntq0tJ4cRPcNY52JJ//x7qsq2RUWV1SbnAAfRpbg9Elsu/Gzu0y3ewcO0FtWX
	3O/ukZPgqns4u3oHem6D/H3tbr1lCuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776150503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt6kw4jL5p1XsC5RPgmFgPFuBvYztobMsY4SgGXfGIc=;
	b=5oqspILO4TNmq/oBc+DBMhbzi6+Zy/7eixVJk+OPjH6QOcOcz2RM0hUAJUKLnc4J5TJRGa
	G3hPwIt2kWJW5tCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14E424B302;
	Tue, 14 Apr 2026 07:08:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1fzmA+fn3WlsPQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 14 Apr 2026 07:08:23 +0000
Message-ID: <38952332-dad4-4d17-a9c1-5c25d79f67b4@suse.de>
Date: Tue, 14 Apr 2026 09:08:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Strategies for memory deallocation/movement
 for Dynamic Capacity Pooling
To: Gregory Price <gourry@gourry.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <e06deabf-44ad-4f3f-b817-78506c5e3203@suse.de>
 <20260413164359.00001c86@huawei.com>
 <ad1b4dVCgG27A5AK@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <ad1b4dVCgG27A5AK@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0BCF81A0006
X-Stat-Signature: dhrqqtucp3dwwt3kdw6pjix9bub9wu19
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776150504-314878
X-HE-Meta: U2FsdGVkX1/ldJe40+C4uwhZdtsVdk9bVZkBM4Bj8lHYlJhdyFcGylZoAGo11pAgE8lT5kIcKg9f3PygadjoRF2xjxSoi97IHwy20QG+P2CIq3dx2XJRktGJOtnPCGv1sCZLrHrvVPAXb4G83lBt0ID3bmZ9m/XcAvixQWs2pqpWNtSqWfNBnpvudP4+obRcqx3MR360Dzo6WW2L0naBf1Wc9YF/+Li6aGHaHAagULyce8DZ3yPf88t6ZeCLiawEhliIG2LdNzEtRCiEBqmOsNtGETwnR+NH0xSj8NoMNntD5RA/e7yVkI5cIg3CPC+SjEDWtJY3mQyxj2FGj/XqcRLOQ0lv7JYVqW7jPaq3h9GU0qKyp3/FbnT8/GtrvnPi/CW7TLlpf5F1nLxPJbtnqPBnshxtWScR3hB4armC/1HAlRiYx91iDF2OTbP4PXbTuo1ds0nKGa0+2kfQAziVxeozqWfmbgLTEaZupePuH0HGYySAjhmVUeIVCddLrL/bQ4mOxUW3OKBFAmpztNP/VYN7vlYbyV/0lR8rHm9hbKsJnzwPV4aWgIvtAtgwFwi14JVaai0nFOmkZXnRU/pIC1tY260G9tUO84vJuUjGgzgnRyjAZCcKWTm0Z1ZNZJKKocXeruT+vej6b7qP3W/qxLr6OsXIA+qhiWS7Sk3497aBn6LZm5ipLThyHfjdNbqzFn9kSwEHJimgXlKRMkl2dQicQSAHuLzk1eRX5b9Rk8IWb0jCiTBcLCT35URh3SsFY22rUrCgFlrAlNoUrEo+aQ6oKsATsCo+SE9Ix7aohwRLjaidUp9/2Y7iE3f5vsgzxz24uCgaGyQx4KdpFu0aDd9r+voAqgzt7nFtl9yx0ZGHHZF8cjqhzw1std+Epdo2TTYendxFaJeC1r2QCRMvVz87gmBrVbgcgnSvTdvGsM34llHP7QGuAeDPeATbTiwHO+rbZLOOAdvxzYvveLs
 KhTl9M4N
 Z4ofx1TMKy0O8KHpm0dDVpe3kXDeipeE9CwfVlcu4CE0Vv/W1cxoUcHMl4fe8sa3RsxXbvnCuFHmBlxy9eKsRu6+rP7vY1OwxZjpZ7gwy9qOwjedtJl3R9Bg8WA5mo+r90n6ha+3RBzRHbw5WGjmlC+HK+Dg896c7yq8UEjAVAxE+nwHJFS4NgSO7621vy2EBkfIunGfAUZjOx3/NTymAGqFjcJW9BDqrsYwyandOwmBbFmgjY9nSBM0oMjyxAlsY761NBPUo/8f26wedFpAmTJWBcfNddCtkDu9DCS97hwpOvfZL03TW6SNEMuIM7dhlKYjoceRoRIdQRkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 23:10, Gregory Price wrote:
> On Mon, Apr 13, 2026 at 04:43:59PM +0100, Jonathan Cameron wrote:
>>>
>>> So quite some things to discuss; however, not sure if this isn't too
>>> much of an arcane topic which should rather be directed at places like
>>> LPC. But I'll let the PC decide.
>>
>> Superficially feels a bit arcane, particularly as we are currently
>> kicking untagged memory into the long grass as there are too many
>> open questions on how to present it at all (e.g. related to Gregory's
>> recent work on private nodes).  On recent CXL sync calls the proposal
>> has been to do tagged memory first and only support allocation of
>> all memory with a given tag in one go and full release.
>>
> 
> General consensus after last few months seems to be:
> 
> "While technically possible, untagged memory a bad idea for $REASONS"
> 
> I do not thing the private node case changes this, if anything it only
> changes where the capacity ends up.
> 
Thing is, there will be things like CXL switches. And with that we'll 
get CXL memory behind the switch, making it possible to reshuffle memory
'behind the back' of the application.
While the situation is similar to the current memory hotplug case
(and, in fact, the mechanism on the host side will be the same I guess),
the problem is now that we have a bit more flexibility.

The reason why one would want to reshuffle memory behind a CXL switch
is to deallocate memory from one machine to reassign it to another
machine. But as the request is just for 'memory' (not 'this particular
CXL card holding _that_ memory'), the admin gets to decide _which_
of the memory areas assigned to machine A should be moved to machine B.
But how?

And that basically is the question: Can we get the admin / orchestration
a better idea which of the memory blocks should be preferred for 
reassignment?
I'm sure there are applications which have a pretty flexible memory
allocation strategy which, with some prodding, they would be happy to 
relinquish. But I'm equally sure there are applications which react
extremely allergic to memory being pulled of underneath them.
And then there are 'modern' applications, which also don't like that
but for them it really doesn't matter as one can simply restart them.

So it would be cool if we could address this, as then the admin 
/orchastration can make a far better choice which memory area to
reassign.
And it might even help in other scenarios (VM ballooning?), too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

