Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18FED25040
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 07:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271DC6B0088; Mon, 12 Jan 2026 02:28:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FA06B0089; Mon, 12 Jan 2026 02:28:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3E26B008A; Mon, 12 Jan 2026 02:28:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE0E16B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:28:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0AEB1AD04D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:28:34 +0000 (UTC)
X-FDA: 84322484148.20.67D1F1A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6CCF3A000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:28:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="n2JBP/2O";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZVDXwO4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="n2JBP/2O";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZVDXwO4;
	spf=pass (imf15.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768202912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76p1BKSyNSE6Ia9N32SzQzLhtPo9wRgYQuaf3Xhfo98=;
	b=nZhlp1N+SP2QKgaTa4hQHF9sMpymn5x0mt+wxNL0EKz5K1+WhQ8o0U61YHr7hMmX8d3Psc
	ZDnXukfXXqqoXEA650mwLEVH5yN3iulIZAdpQBPDQeKOYlOufLpFfdthxjWK61L0aBsPy3
	8psAzNZ7dmckOWT3msD40gSHeDxjTAk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="n2JBP/2O";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZVDXwO4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="n2JBP/2O";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZVDXwO4;
	spf=pass (imf15.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768202912; a=rsa-sha256;
	cv=none;
	b=M3oTRZBIIMHtmK/2OXotfLDaN2Hm+NfzE0fllIu/mGPFJyepwNOr2K+uUMntCGKw7bn/XE
	wgXC3J7jqihUyUBgN+MwUtcmAyD8WZEUg7Aoqc7PG4e/sCbAnsvKgwnQk8h3qplMiX/B3s
	mO3YgFMK5+1s+tg6GgI5vVtCM3eUEIM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 53BB3336AE;
	Mon, 12 Jan 2026 07:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768202910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76p1BKSyNSE6Ia9N32SzQzLhtPo9wRgYQuaf3Xhfo98=;
	b=n2JBP/2OtM9QK4ca43tBi2yP4+Eik3Fe2wF7bW9L1OsRAu2aeImqeIo+j/JAHOVAhOEl6O
	F2YoAIAaRbhcrPqfpDmH+gs3E4UMwrQR0d3EJCNGLhXjv/b1TL8n/z1qKifNUecVD+iq1d
	To+DCvUWuORNjZ7+V9yPDTi1vGDU/5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768202910;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76p1BKSyNSE6Ia9N32SzQzLhtPo9wRgYQuaf3Xhfo98=;
	b=XZVDXwO4OuqJvtL+doLnImo8TwFCB2rWqvMgPd+QO3iFiQAGLfJ5bMQNvn7uFGNslIC8lI
	fnQ9eFyy282ZDFDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768202910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76p1BKSyNSE6Ia9N32SzQzLhtPo9wRgYQuaf3Xhfo98=;
	b=n2JBP/2OtM9QK4ca43tBi2yP4+Eik3Fe2wF7bW9L1OsRAu2aeImqeIo+j/JAHOVAhOEl6O
	F2YoAIAaRbhcrPqfpDmH+gs3E4UMwrQR0d3EJCNGLhXjv/b1TL8n/z1qKifNUecVD+iq1d
	To+DCvUWuORNjZ7+V9yPDTi1vGDU/5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768202910;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76p1BKSyNSE6Ia9N32SzQzLhtPo9wRgYQuaf3Xhfo98=;
	b=XZVDXwO4OuqJvtL+doLnImo8TwFCB2rWqvMgPd+QO3iFiQAGLfJ5bMQNvn7uFGNslIC8lI
	fnQ9eFyy282ZDFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C97833EA63;
	Mon, 12 Jan 2026 07:28:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LBuBL52iZGljRQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 12 Jan 2026 07:28:29 +0000
Message-ID: <b1b4ce23-d02c-46ec-96fe-ada6ae0948c6@suse.de>
Date: Mon, 12 Jan 2026 08:28:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Gregory Price <gourry@gourry.net>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
 <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
 <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
 <fd21ebf7-d016-4729-8d23-a7c0f2a3d8c6@kernel.org>
 <20baab84-c8b0-4c46-a550-21b26b975d07@suse.de>
 <65c246bc-fb10-4cef-8163-3a55bd96f326@kernel.org>
 <aWEvuS95-7yP-Vc8@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aWEvuS95-7yP-Vc8@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CCF3A000B
X-Stat-Signature: 761x5uk6wsu81bipz4drhqjs57iyknxq
X-HE-Tag: 1768202912-437550
X-HE-Meta: U2FsdGVkX198H8vUaSLVzZJBHZhG6Tz0oZTb1NztfgA4KVI/LDNtc878aamD0cqYRGgFAWmWxj6V68llVEJGgM0Fe1UdYRo6l/wwaJfX7XnC51EgydbkwNgDnEfZW4D2KTk5HlrVhfMxPcq625bd59nALJwlg2nwIFP8b473gwWikUHS+dy0at8Npi1+eLrxdDeCvWJORRUmA3o8n9BMW2HwqV9/7AO2ejfUjDFZGn8FIf1El5bk1/z8/3StS1sHiKOpVwJqfD64u9TfAf8wPHPSudNSndrnCbbiygbB9IwWbvxPfYWDwmPC7E+QIlR25VuGOP6h3aDosMSp9ivErGgXgXeUOiHg39y6ZE4E089BOoCMzxhGAPEeBN/w8z+S0SGQmnR3IK4m52f0XF/30QRqqW3D2vnvmUmDQBw9c6Eit1p6pdOc6E3tDy1t8E3z8+rLgcC5N1VpQyvBuL8GuOqw5mAjDY0SdR4N1o2sPwEDnRuqBqTJlxU1pWq6uSzZqZVYZD/F5VTTpJM8Xl31JR+BWeRSjoCBJMcsV+aRGbzQB/rgZNfMWecAHyYvhx6nKh9y0XIapGEsYOz5eJl2/pcexCYuef2QxevGWQH43a8zmggvJCc5ck2ex3bJGOHzkYm5ElwzU7anB+v2FKUB4nBofwlVkNpQYqxX1oZECEgr41gI2qN3nqPSFs3AtDWjhIr0gQjYct2eMYEhp4TF9SNFVfYrIZoNXS+613zvE9xWuiUGPApuHa2og34EYGz0SyboE/M5CgT6C21SbIG2QOnnj7/qM3YlLrF6lib4CvAlhJWtTzyJRx29EUA8vXgkG5hdPNW5O+YeW9WARAotCm+o3zmb002xHJvP/9fI++/ATq32NwHeKPpROubIPqigESDEevJIY7MB+CCg73zg16cgpPoEw9XwGA5Q2Sg0pg9lew86Vx4GM/8MSxnAm8/iPkEF9sr5DY2krVR8VtA
 OSanK06y
 rzivJdz2qNpWE7mdfcwhMKRdSaMIipS/Q80f5fmDpf1/T1dCCa3J6d8f6LAlhCMNpv3dmI80pCKezS9DoianmzOhKbNGJ9+CqO6jVh/2S2BdHVJ/KCMwNrBWiqdn1st75vD/pT8A1BcCz3mTAAuYB8dFy/37Uq2hOnwTEnduCtTRCH7dSowWoOr3GB4Esx/drAIoSk3G2wHA80MjjQzmg5KhB0Z11msddwQkbl0wchy2pLmMkSunpaTYZMyDUXBlxxAdZsz9Cuh7gsD29nzbaxiqvje8aV1A84v23VUJtJJqiGX8T10+Y/nNAnY4q9VMoNKRN9Wz+aMLVhvXmFurfilKc5ya6QPGLateYSh6cZgH7TXWLSUSDwmnRmGHyvnEZq5Ln
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 17:41, Gregory Price wrote:
> On Thu, Jan 08, 2026 at 03:16:24PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/8/26 08:31, Hannes Reinecke wrote:
>>> On 1/6/26 21:22, David Hildenbrand (Red Hat) wrote:
>>>> On 1/6/26 20:59, Gregory Price wrote:
>>
>>> For hardware-based scenarios memory will always be removed in
>>> larger entities (eg the CXL device), and it's always an 'all-or-nothing'
>>> scenario; you cannot remove individual memory blocks on a CXL device.
>>> So there the memory block abstraction makes less sense, and it
>>> would be good to have a single 'knob' to remove the entire CXL
>>> device and all memory blocks on it.
>>> Sure, it might take some time, but one doesn't need to worry about
>>> restoring the original state if the operation on one block fails.
>>
>> That's not what I was getting at:
>>
>> offline_and_remove_memory() can be called on large regions, and it properly
>> handles whether we have to back out because some offlining failed.
>>
>> The issue arises once dax would have to call offline_and_remove_memory()
>> multiple times, on non-contiguous areas. Of course, we could handle that by
>> providing an interface that consumes multiple memory ranges.
>>
>> For the DAX use case, I thing we'd really want a way to just use
>>
>> * add_and_online_memory() [does not exist yet, but ppc does something
>>    similar]
>> * offline_and_remove_memory()
>>
> 
> I'm starting to think this issue is actually the result of bad patterns
> in the cxl driver - namely using dax as a path to hotplug sysram.
> 
> I suppose either we need a `cxl/dax_region/remove` that handles the
> whole operation in one go, or
> 
> we want `cxl/region/commit` to handle hot(un)plug as a single action.
> 
> tl;dr:  Split the dax use case from the sysram use case, and make a
>          cxl sysram driver directly manage hotplug rather than use dax.
> 

Well ... not sure.
We are doing fine even currently during boot up; we can align policies
and everything to ensure the system comes up with the 'correct' setting
Things start to get iffy if one is reconfiguring memory to move from
daxdev to system ram and vice versa.
Currently we can do this with a simple memory online/offline; with your
suggestion we would need to remove the memory, too, when doing that.
Might be getting even more awkward as this most likely involves calling
the hotplug functions for the CXL device itself ...

So not sure if it's a win. But one should try and see where we end up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

