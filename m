Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE84BCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F5F6B00A6; Thu, 25 Jun 2026 02:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12556B00A7; Thu, 25 Jun 2026 02:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01406B00A8; Thu, 25 Jun 2026 02:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2BCC6B00A6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:17:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32EDB1405DE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:17:41 +0000 (UTC)
X-FDA: 84917428722.23.FFA3611
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id D7326180008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:17:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qbcZ4cUo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YkCJXl0Q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n5GkZTym;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SxiLqY4c;
	spf=pass (imf24.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782368259;
	b=3r0HH0HkkwDAehs3H9k0c3A/BYySo+eynQKNhWDEOZ/6kz/HlNIAiIx7ASFmwpf1BUbhH+
	O1xOFBWvWjQyzq0rETwtdfl+yes2wY5PqY8dmRBj9UGjtj8wS4eDhfd9KBXlyPKBUrCSMF
	sEf3Wu2fUCS1TJX92oLM2mGLJSrr0Ww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782368259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=cxrhbtS1UzNlI2+EyUUYbBmE7g1jgJqTNOeWHy0l9lb2xuX2o2hNR5PhyidYV/qYHmIqHh
	U2P337SkG3LIP+RmVJhMFptdpPUbZmYXYdpNok59RfYO6be547Xz6NOL0JAU/3R7Rh40qT
	4ROzrhAHaNhgTRqbBh0xwRPB1qBzlfA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qbcZ4cUo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YkCJXl0Q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n5GkZTym;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SxiLqY4c;
	spf=pass (imf24.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3017271833;
	Thu, 25 Jun 2026 06:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=qbcZ4cUoNNNrBS8sol12QF8a20XBCri1pgE/tbEdP9ig/UFZv6rgUEzcBD7fEqjllibg/M
	2DamV6U48sRwmzWWHVtfG5yBHYzRzIrN4YjYuL+/AZ/KZYMdJnh7KqsYUnsiNmlqVqw+sd
	xs8bhKwszOVTMgmzHEbqt9qbD0w9zis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=YkCJXl0QMcZ5eO9Wh0jGxv+7rTwJYQzwe9ARpYn0YEXCxC4d23jhg0GVTLww7bCO2z3BAO
	DxQ5Hxdo5cGHW9DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=n5GkZTymO0+yOwrypTZxvOLlmvqBerJvEj15XaIGob78rgtYBHPQ1psIEuTOvqOsRNcc3t
	ohqU2GpqweS7euy88WjypV8xCKCpPj4fJ5M7hInIC9kC9l8FefQfnH7SkHxPDLO4KU+es9
	tjCrQN6zsPu1BSEV2Uf6LN3Wm+Fmorc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=SxiLqY4czk0sQSzuZDu3RT6Wr3/E4Up9OPuVaJflrlwJbTYsGooecfrd8fqUtk8oos1KTM
	3Fc5qxS9lcGZmaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B2A4779A8;
	Thu, 25 Jun 2026 06:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uH2uEP/HPGp0PQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jun 2026 06:17:35 +0000
Message-ID: <8e42587a-d614-4259-ae6b-5bca1479b425@suse.de>
Date: Thu, 25 Jun 2026 08:17:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, alison.schofield@intel.com,
 Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
 apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260624145744.3532049-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7326180008
X-Rspam-User: 
X-Stat-Signature: d1x5bmgr6k7cdepdpoi5ahhjmjghqkip
X-HE-Tag: 1782368258-803323
X-HE-Meta: U2FsdGVkX18Ttn7b6LXi/PNkSBbIbfzv26LQFksbbNHJcPU9284yZO3X8z6hhVcw623zwtNeCj6zzJ5y0TyWn2jUxME3P+4bsSV32zbclHC2nvX4zwMFI3ZK9g98NWwJFF9xS3wut/dJhVsSorQPmbH9e/4TVO4R1SzxlZMz7Sy8IlFP4Ces+96hJefMGY6dN74wnDab4laW+8hzcs4jLlzBClrI+6gSCrFgdMOVgDlM6YlmFi0O2F9hN0uelpMoMDzaAN59eDvC7Z4xtXdMJQrIetQD7WkMgy9WTXPe/ysr2EkkZaUAZeY5k42urxudfXUlPXyt6PxF8hcIk0PBspOMuz9eI8LCk2xxzuKFX4sh/lLP4TAJGHjKfWo/KdH76ucZVPffhztfVjOsRwj2iDOXQx4CgMo2MP7fOyupX/3WPFAiiPkxT5dwL56pMXY5KtytsXbq9z4dVqii2gYPtFd1Mp54v4Ft5NjLLfwZl0zlUgIFKv7v6zCjeV/v0xwlWJSgoSdBhkVvLGMSP1hXOndCkNlBg/s9xn9EAWMX98XTphq9l5mz+MTD8PnmkDF4CI58gHOdw3e8cNSLyVxzSuGO4vP8zdkpwVJ7Bstv+WPnjSHEOy8PdvMcrWewMSANdSEJH0g1TKgflusTP0JcvZ8S+k98XXsqxio2fXxTW642kaMh0XbT3JBlr1NBRyk4NUsFvje3M8/0U528y1PzOYJjK0ul76kdJrhsV8QZSTGTQGEVLMhhSVo12II7JSHV1/jYg0Lxy/Ygi3kZ7xIf0n01iYQZxgZ1nIhvRbxAZQgYIejv7S2qnEqTPLOfJo7rfb9S7XKJGdlEfIFliGNCnVZEqVR4HAMKb+RLsKDRDSmbB0MhqPsfD3IXtV5lIfSYACgR1bx0JXkQ4s2W68r0+ldnDj3WU3Hho8D95FElRJIiApa5tr9kDil7G167GRFpjaT5gxx912ll885zxAO
 jKOOeeVW
 DDGYMN0Jx+iJ3LUxx9d7MipnHTKfRiteq+DI8XREwyANX1TBM6wRP/JXnptULZk1+CQbVuk5cRa4SvxXFJRtH0hvAJQgApB1ykN54hVtBUEYdKC13X8ny/aqoDNx/ipv1u46h72XhUvs7n0y1ClrLFcfIkMgoiiNeYBbf9pYpRbDHrLFKgxlMkbPgLse6bBmAVXO7OwbXa8IXUxXlHTkPT9YYdq9KigcSC50DVAj6/5Zl5YYjCaIocmbt9BbEHPM/JRC9CtX8ykgfF7d+3BibNCCxTbEyDrl5giF6tlTcfHLe/vA/mvNNCT+xiYISFL6XbZIcTNbO/+Uzw1w/lQRvnz+l6cVOXj9fkLKEpzkPPW9jlxZBrzjObLefOOT1rxw43z6NZQa1kFogbCFttfO+wnj9O4Ft6bB1rrNH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 4:57 PM, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:
>      1. offline all
>      2. remove all).
> 
> This creates a race condition where another entity operates directly
> on the memory blocks and can cause hot-unplug to fail / unbind to
> deadlock.
> 
> Add a new 'state' sysfs attribute that enables an atomic whole-device
> hotplug operation across its entire memory region.
> 
> daxX.Y/state mirrors the per-block memoryX/state ABI:
>    - [offline, online, online_kernel, online_movable]
>    - "unplugged" - is added specifically for dax0.0/state
> 
> The valid writable states include:
>    - "unplugged":      memory blocks are not present
>    - "online":         memory is online, zone chosen by the kernel
>    - "online_kernel":  memory is online in ZONE_NORMAL
>    - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>    - unplugged                -> online[_kernel|_movable]
>    - online[_kernel|_movable] -> unplugged
>    - offline                  -> unplugged
> 
> A device can only be onlined from "unplugged", so it must be returned
> there before being onlined into a different state.
> 
> For backwards compatibility the memory blocks are always created at
> probe - existing tools expect them to be present after kmem binds.
> 
> "offline" is therefore a reportable state but is not writable: it only
> arises from the legacy auto_online_blocks=offline policy.  Onlining
> such a device through this attribute requires unplugging it first in
> an effort to get drivers creating DAX devices to set a default.
> 
> Unplug is atomic across the whole device: dax_kmem_do_hotremove()
> collects every added range and offlines/removes them in one operation.
> Either the operation succeeds or is entirely rolled back.
> 
> Unbind Note:
>    We used to call remove_memory() during unbind, which would fire a
>    BUG() if any of the memory blocks were online at that time.  We lift
>    this into a WARN in the cleanup routine and don't attempt hotremove
>    if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.
> 
>    An offline dax device memory is removed on unbind as before.
> 
>    If online at unbind, the resources are leaked (as before), but now
>    we prevent deadlock if a memory region is impossible to hotremove.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   Documentation/ABI/testing/sysfs-bus-dax |  26 +++
>   drivers/base/memory.c                   |   9 +
>   drivers/dax/kmem.c                      | 224 ++++++++++++++++++++----
>   include/linux/memory_hotplug.h          |   1 +
>   4 files changed, 224 insertions(+), 36 deletions(-)
> 
That looks good, but question remains:

Why do we need to treat the 'unbind' call as a given thing?
If we know that we cannot handle online memory during unbind,
can't we just disallow unbind in that case?
I don't think it's too much to ask from an admin to offline
the memory first, _especially_ as now we have a simple knob
to do that ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

