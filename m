Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FAD6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41616B00BB; Wed,  1 Jul 2026 02:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1906B00BD; Wed,  1 Jul 2026 02:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB816B00BE; Wed,  1 Jul 2026 02:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B38436B00BB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:13:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28B741A0199
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:13:33 +0000 (UTC)
X-FDA: 84939191106.23.B35490F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3ECD80007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:13:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nVkPquKq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IgLbW7hT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nVkPquKq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IgLbW7hT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886411;
	b=0kNBGZqrM/MIvEq2jKLRyZLBN7E3g+yn5LyAK+Eh2Wzk4oqA4/FOfH3GD0r7RK/zVF0a4n
	cWB0q1BXVHdddgmdccI6j4u/fVEvLkmDiu43T8jBfazKbh0q6bfl9phY+39HQdLeA1A0QQ
	vhva+tmZMy12erseEBQE87CIk6nsezk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=5E6H3E9bjwbC8FKjfHVzOWKTVp0lVCeb9QO+dKGgCfxzC7rlSj4f6w1/eUHybexUX3Q8mj
	vgc4ssbB/xNDB3mfO90e/H/FxRSvJ5xKXJk0jYYhyw95jMU3LGoFOpW8Yqa9SlMA9WpwRV
	2qo/FM9vS2N+de4Nw0D4RffwMApqC8k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nVkPquKq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IgLbW7hT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nVkPquKq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IgLbW7hT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 386CC75FA2;
	Wed,  1 Jul 2026 06:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782886409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=nVkPquKqfnuglwRA64kO/65FlsWtnZVcUr3tQjW84mZEt5kIK1Id+IAvCnd8COFWAMIdCN
	A+LLI/gXRqAumQ6m6nZvELRBDLiulChfZexd6Z8RaTTDRKPx8SMbetsUAzw04D6Lu6YrUo
	3Tt20D3L669qjQts1PWJhNHngCyL2zI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782886409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=IgLbW7hT3Aoo3CqPjJU1FBDZYQCfBqX2sBw4KqeELLYrzoJwo6zrbQBzA6udP+eNK09Hw4
	2Irk1zJbX7sxlFAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782886409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=nVkPquKqfnuglwRA64kO/65FlsWtnZVcUr3tQjW84mZEt5kIK1Id+IAvCnd8COFWAMIdCN
	A+LLI/gXRqAumQ6m6nZvELRBDLiulChfZexd6Z8RaTTDRKPx8SMbetsUAzw04D6Lu6YrUo
	3Tt20D3L669qjQts1PWJhNHngCyL2zI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782886409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=IgLbW7hT3Aoo3CqPjJU1FBDZYQCfBqX2sBw4KqeELLYrzoJwo6zrbQBzA6udP+eNK09Hw4
	2Irk1zJbX7sxlFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88874779AA;
	Wed,  1 Jul 2026 06:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9virHwiwRGoNTQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 01 Jul 2026 06:13:28 +0000
Message-ID: <abde41f0-7d40-42ba-a232-cc0538cd0e4b@suse.de>
Date: Wed, 1 Jul 2026 08:13:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, alison.schofield@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3ECD80007
X-Rspam-User: 
X-Stat-Signature: 6ryqqw71enuiuk76aup7ctstc9s1mmxo
X-HE-Tag: 1782886410-394222
X-HE-Meta: U2FsdGVkX19c8E3gNMB39XWBGcpNIj36n64oDWjftSZE3Booc3zwk1Z7HkHvGRMLPskzr538kzE579stroUJ7Ya3hysA+OaESUNg0JhBeVVAFFPppJQjgqhZR6mwyVgRuz4lprk8X+94AKa5sLXxPTuDCHVYsIbczDGRv//feGf2DuW5KCX0RDla/ZCf18NzXFmI78UEomMNWn4m05SCu2QVIm2PH4CrYPRmSV1nd9Mejioccz6b52NdJMWUShwIVWaZfokzLRIAOJLkBushEgs3hGPMp0xXcA/D5Y5UecuIXdjyq7aTP84Znz4o8o0tdpfBpDbgvPNL33TFqLoyn9HmOlqLjW4NWaLmdW0eBAciJXQym3pGf2gPL9/UryZQc64Rj5YLia7vqGN7ZLxOcu+X+GbRubxG0r+2Jt3Ub+pR8XqisZW3q+uTC3G2GfKShX/UrcWqvOPT3wLapUcHciTYKfIAMCSW9UYfbzyfxDgJLkXlOQr86UlLUMOhfAvag/8XJRSDumeQeJ+pRW1qjSWuWHEo2tYjNxShvLXjnslI8aR9YzY/VHm17woOs3Aj02R4MKmSWx0ah+tnMnhgfY0LFnte7YIDhQd8XyVlC3VuxqVmIKr3T2dbybAxKjtNUIfAXKMBzepJAtj0IulzFtNNoqxA8lIqRHGWAHmpVlU0Z840rPcqow9SZUMcPWWZDvAKS+NYQgmlnYtAlHZn6r2Nc9vRQk0M3XV8v0vdNGhWQHH+Zb8nwFG6xC5tD1RWgG1+1HAqf1ddagoSn19j542knxFWCkU0yGVa6QRj2TsSFcyQox3LroSa4BuknBUzca03wGo1dImB2D1/7T5/XSyrCaWu1Ts8GtyDrNe2QXH6xQn9+APOjCSdzSjpVR0Vg3502r3H9+MDaZmFuKLY3qMtcFkDQ4MjSjNbjoZkqYWYv/raInV9fnu5WrVyqOroyrOrH+k2Ch6ZqAKi+o5
 7vP9t40i
 wS+jhbYcUE0xcUMgb0L7UjRfBTxLIeKA1LliriXH6JN7o+IVVsp21//ikXZcC8Y3Y82MbfPo4HogW/GlzSgLPGJ6Xo/G+JEId7/aiWVx5ATUmIIlFYsBkm5kXQmYwXA+WlLg7ulqB1JSkrU5qdvvYOlD8b9WHlQ6zGREyJPRZ1pO5nhOyoRe2uJAcQrES4+LvIr1pJEQ/gWM5oP2u/Q4vLDMaH/E37DafqEbAMK0c/I8fFbEIuj2HIzVS5ebuwyAduMJh6CrHVVzQmxH96n/PG3aCtihUMc8cmzKjbBcIOIU57+7eXlLHB95rfvJA9kL4JStUgIVm+a77fZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 12:14 AM, Gregory Price wrote:
> On Tue, Jun 30, 2026 at 05:18:41PM -0400, Gregory Price wrote:
>> There is no atomic mechanism to offline and remove an entire
>> multi-block DAX kmem device.  This is presently done in two steps:
> 
> ... snip snip snip ...
> 
> Sashiko pointed out a false-positive, but adding a fixup patch
> here that adds additional consistency.
> 
> On total failure - release all resources.  This makes the sysfs
> interface consistent with the probe failure path.
> 

Speaking of which ...
With this patch we now have _two_ interfaces to do the same thing.
And both will be generating uevents.
Which is far from ideal (one could easily envision _conflicting_
udev rules, one set doing an 'online' on the old interface,
and another set doing an 'offline' on the new interface...)
Is there a way to not sending uevents for the old interface
or to make it configurable?
The old interface had the nasty side effect of generating
_tons_ of uevents during booting, and on larger machines we
even had seen udev acting as a fork-bomb during booting,
taking down the entire machine (we had to restrict udev
to 512 threads max to avoid that from happening).
So if we could disable uevents for the old interface
things would be _so_ much easier ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

