Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0890AC54FCC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 07:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC24A6B0088; Fri, 20 Feb 2026 02:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70366B0089; Fri, 20 Feb 2026 02:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51A06B008A; Fri, 20 Feb 2026 02:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2B36B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:44:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22779C3787
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:44:10 +0000 (UTC)
X-FDA: 84464046660.18.A70737B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id A64B1160005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:44:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BwGng01S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5vZicEWZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZzHogcgo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=njdbUyVP;
	spf=pass (imf08.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771573448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9zZU8rQyq0UhB0/jWOvgsYzj7gv8Vqlnis9ECm8PdA=;
	b=YyWdQAsVuUUx0MG2fe6E6JPjCe5Eiiz+LBIOmbLEBBG9OmbrwWkRDpknEnhCenpdpG+oo2
	NT7AuEgfw5NYdRPYx8QQP87evXiBtEuvvq1z7OTAN5J0Egt3hxUPxfU5TM1pVcE9TzUBip
	Xjc48av128tNLoYreCS+xGALbuH6IRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771573448; a=rsa-sha256;
	cv=none;
	b=nWQdVuoJzMgbvDv4yCRn/YVRv0ePbopePnmKZDXR++bgfRMEa2FuqbQvO/MXX45VEOBF22
	dQt27ure1Gaw6VJS161LivdkJjDcYS8V9hPUK+jbpHJfik4qtH5ztdsuL7wifjQK5Jnwqs
	ItLnz0jdVeRBRK22O4VX5JvT/35qWqI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BwGng01S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5vZicEWZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZzHogcgo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=njdbUyVP;
	spf=pass (imf08.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3DC085BCC2;
	Fri, 20 Feb 2026 07:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771573444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9zZU8rQyq0UhB0/jWOvgsYzj7gv8Vqlnis9ECm8PdA=;
	b=BwGng01SvwKa1gDxtgZNBjoR/YEinPXtLps71cMXhv7vZeEZlevPdFutA797m5DRloHr+F
	Da/70SwFrPx5Qkl0d/WWAw3eBmMvX8Doz7F+WCsbLdxUzFNqsDq6RMfxUdiUr+/LCS0FNH
	aV0OIra7orT0sM4SGsSW4NKTVC6Uqog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771573444;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9zZU8rQyq0UhB0/jWOvgsYzj7gv8Vqlnis9ECm8PdA=;
	b=5vZicEWZgitKKdCEQ5uUzWsqL4kiwLAV4vC0HfKiF9WS1RpIXryYHYG6bs8ZxbvfPlimAZ
	WMR1GtnAUUjiAxCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771573443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9zZU8rQyq0UhB0/jWOvgsYzj7gv8Vqlnis9ECm8PdA=;
	b=ZzHogcgoE+vTqZ6Wudm8OaOLN/3bQG8fC9G5EBOl05yVRRgLoi4HCQKJNRwzrLbyuxSJBW
	cApJ/K7vhiSotHfJqgF8rJV1LC2mKYtjH567TE6D3xFO7E4UA8uWHoh98RoorNupi+kxVM
	0a+o7lMO3yEVVbeJwazXqx2PrO/6MS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771573443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9zZU8rQyq0UhB0/jWOvgsYzj7gv8Vqlnis9ECm8PdA=;
	b=njdbUyVPMylL0bvLamqip/1ferRENunYoH3/mgFzOmlsNBmGEJEitKBOJFxOrkKEqap4cw
	gagR4Q6FQY+mr6CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3B343EA65;
	Fri, 20 Feb 2026 07:44:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hQt8OMIQmGm5fAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 20 Feb 2026 07:44:02 +0000
Message-ID: <29a7ef25-27a8-49cd-a2f2-8db693ada39c@suse.de>
Date: Fri, 20 Feb 2026 08:44:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
To: Theodore Tso <tytso@mit.edu>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-mm@kvack.org
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
 <20260219143242.GC69183@macsyma-wired.lan>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260219143242.GC69183@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Stat-Signature: dpb5ophyqz3shkuj1w8epecdxzimbxca
X-Rspamd-Queue-Id: A64B1160005
X-Rspam-User: 
X-HE-Tag: 1771573447-588225
X-HE-Meta: U2FsdGVkX1/Ycgq8bU0NplOxCzHsowCRf9ZiBzV1fFEy7CvX5yBW/a25dIPiA7F1/g96ecUbHxFUKn+z1TovYg8zs6Wau1pIFA3pcD9kluh+THJ3MrAVw+7jSnAdEJUx+/JIuzsSqh+eFomjJG45gVkr4T/RWw04SadJoe8DxyUacbltN/3EE63VNXlA47yxvvX1QWRaJb+En/LykKcO2HLkoZf22bsB6p/su6GkRNyx1FB+rlcVIkU6VnL3gkEe6/tsuH08OtGEscxEFvzubQhHVVL6NfnfiYwejptj5CwUzZvvkeXV5XDj6N2HOJQhKHGtfGYtAo7VU02u4MuxKPkPflU4ylKXiDXBQeQF8ayghxLnVBoFFWk2JAhbJMEk5OtfBkfWqNgQ4gLBxn+BOL7FwLGfxGxN7VvE5UBwMdGjBgDP1zEEBGgjKutai0hxuwN90xywFgAsWt37VU5CeXGJuj9nM5R2q1TDxFenCsnNO0gcIRhHDYq0j+Kx0hRy71vDXxfaGrx/tqVpxVZ0JmBBKP0mVckQRpNCLxm6p3Cv/OzQxFiWvPfNHGwZcQ3hloGEDXBMDurnEk2g+9WTKujLSOVNtHhAYdOkrn3b/vWAdtO7cWtZpUkN1dS7DzK1e2fdfXuysvDOYTnSFRe6Mi5aw9IrT/QvlrahgXAGiG7+6fcpM0mZjmwShQ/pi49BIkL1fMIYFr9PXCB2YdEsaSdwbywdEkS5Otu4rh5ilBV1yqq7ybad7w9cM4wDEKkJdvaR33iYJUtChOzgzqEenQuXtjcvF4uFpnImRt2ks2KL9Qd2PGLPDKSFuZiF0YIdNb1IbOUDs7U4AKSauH3pmZXTS4fSNTX/xjnfgSuxhDy8aCLHkJlo9dzr6RecnXNbXiNRCB0wo/s0R9k19L9BFuNrD4LRxMhoqr5K1ieMtxfIqzT2MNMc715UyqRPs6wlV4NUCYsnsl7+GbwAZip
 ohABPbU6
 eqWijZQe3wDQ90cOQBwPCoJse1awBWRjCkdr0KwMPv7iyKPij4DtpQCV/7/WqvvrV0xLSowJvQBaWgUR3NMvgr1SO0qzaomVKMGrJZtmabXwPDkIAFKTru4sVITm/1ruPT5/P8PAlRhTpzLzMy3OvCVj7wDjyIFOb4haj6pTc/k+7x3gade77ACsByesfe6EcT1y9+YVbEH/0LK9WvaWJA45C19GWJ0scUET0ly84UbXE9oplSjGuhPB4BczGn2jwYRhAlKYLjttI5XpTOsqxuPknyJGZsfrYOLNMCEZTkOC/sfWURyeZR4Nan++pFc6fVWCKxoS1Hef/hRDPlGAY56I2I50/BjxM0lASJ6lxjBixcyEhdeA6iWMdzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 15:32, Theodore Tso wrote:
> On Thu, Feb 19, 2026 at 10:54:48AM +0100, Hannes Reinecke wrote:
>> Hi all,
>>
>> I (together with the Czech Technical University) did some experiments trying
>> to measure memory fragmentation with large block sizes.
>> Testbed used was an nvme setup talking to a nvmet storage over
>> the network.
>>
>> Doing so raised some challenges:
>>
>> - How do you _generate_ memory fragmentation? The MM subsystem is
>>    precisely geared up to avoid it, so you would need to come up
>>    with some idea how to defeat it. With the help from Willy I managed
>>    to come up with something, but I really would like to discuss
>>    what would be the best option here.
> 
> I'm trying to understand the goal of the experiment.  I'm guessing
> that the goal was to see how much memory fragmentation would result
> from using large block sizes with the control being to use, say, 4k
> blocks.  Is that correct?
> 
The main goal was to figure out if we have increased memory 
fragmentation when using LBS.
Clearly, most (internal) allocations still work on page-sized
objects, so one can argue that using LBS might increase fragmentation.
On the other hand, all _filesystem_ objects will be in LBS sizes,
so we won't increase fragmentation if we only allocate in LBS sizes.
So which is it?

> So I guess the question here is what are realstic workloads that
> people would have in real world situations, so we can do the A-B
> experiments to see what using LBS result in?
> 
Yes.

>> - What is acceptable memory fragmentation? Are we good enough if the
>>    measured fragmentation does not grow during the test runs?
> 
> I can think of two possible metrics.  The first is whether it results
> in degradation of performance given certain real world workloads.
> 
> The second is whether given a particular memory pressure, the memory
> fragmentation results in more jobs getting OOM killed.
> 
That would be ideal, but we first need to have a program exerting
memory pressure...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

