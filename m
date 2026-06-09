Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25BD7CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF2D6B0005; Tue,  9 Jun 2026 14:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6126B0088; Tue,  9 Jun 2026 14:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC656B008A; Tue,  9 Jun 2026 14:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3B66B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:11:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06A4A4073B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:11:55 +0000 (UTC)
X-FDA: 84861167790.21.2CD4354
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4AB331C000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:11:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2cktXfY;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781028713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m7LOutxoWIA5dr7VvPYs0WwbrWZOLkJ4/IC53j1ALo=;
	b=KHZ45Cqck9fKHnDhIROalKiOCqcp+EeLyLvX6gmsusnyhSzF7nbShJ+YrJ7o1DktjEjSGg
	yGSfT+anImYFkV9CEe1OEhVL7GFBEeGCY14NLpXEJS5hginnP1dgxd1yVIneGejjx/7Gx9
	xTdeMR1CusV60aWni8JK1132jHVzCA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781028713;
	b=g4aldAVQTdt+w8FOarH/8Lp1vmEl2FiSjAqVwxrPO1u0KCO7OD2mOkzt3r1DZaxWXdLMHT
	o/+m8AWIgAdvvZjDp5G+wF8VlQiEdprTgMZUyAs/fALqj/GGKrYPTMulA2NjHvX1D10U50
	0gpEH0WIAzJhR/ogTYUrdxKp/gU2Ap0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2cktXfY;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C386A6025B;
	Tue,  9 Jun 2026 18:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD3F1F00893;
	Tue,  9 Jun 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781028712;
	bh=5m7LOutxoWIA5dr7VvPYs0WwbrWZOLkJ4/IC53j1ALo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i2cktXfY0Vcq1+kYgtz7sBNDemjS0Ze/OJhQgmEIa5kiHWYa2QPe2SvFT1bEXkfdb
	 /MULUkLCOqNFN+fs/qGtwlAKDDmbsFNFnhjoU4e9qPBb3BqDUceXMOWRkzigXDFO5C
	 LzgXNKVB1kHGh+pS8ik8GDPBzI3sMAZ0t2Bq38uvT50VKcQ8+nvW3/a3C/62sc2hJ0
	 v0mVkm6B2HMQolGN2simwlkX7PKT0nkSt1AX3oK0DqVn8NS+ym5NAAdactRRqx1hfC
	 vwm1baTLV38fEjy657BU796s0ngC6PsQwrlg/IZN5IwyiDueNr3LmaDqFJCElHYT64
	 RJ2zvvZE/sIIg==
Message-ID: <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>
Date: Tue, 9 Jun 2026 20:11:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, linux-cxl@vger.kernel.org,
 linux-kselftest@vger.kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com, Hannes Reinecke <hare@suse.de>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
 <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4AB331C000D
X-Stat-Signature: dxgg5un17p13fzhuiyggcxqp6fgog84o
X-HE-Tag: 1781028713-261932
X-HE-Meta: U2FsdGVkX19ADde4X+pD8HozZxtmMPSVEIrYPyJzJ7kiG5KywgCrUWZKPs9MG+0jecD8hJqrmJFAcgaefPF/RJEdXhmS+WvHrpXEM+lUJdCvTTiDqeaW/8ebuIwAonpvlEW3p+x6lxSGoIztd+fdAspaWpNm00oEJAWeITlWmbPTQ+Q/FbiEM+3WTyi7M7rT3CHI2ptqNUwFS+EKR1QkaI64TwxOe6bn0seJM+3s6lwcw0SLxXi241MLdQfswz+31v4dbL3i6lQbX6XrxJAjMMd8hG0822Q4iVsgTGPRfurYEVXh615PHiM+HpnCoSq88ncJwqGIRJnbItsRUh4yrEvPO7lkD56EJck7b3C9yGYqz/T6nwlAtCQ2dY9uv6A+asY8SQ8OXVgLRdRuOxyLUQ685W2SZ40EwPLArK6AJdcLIbuRzSjC5jybb3euSLvxdeYzi21+g1f/Wgivf3Mabmwv/4S3y3fRRXo/ltzx9PYF0TR3FWZD2fg/bwpxHPxrqGLw9EFpvStuKKxj4Ar4ETqXsdGlT0a64x1FPvRlp9IAWxdgZjHNNSsfHD+sgxQrdkk2lbTNdLwtNCv1tka7O6FI752ZxbspIF/QzD29I4KMlZtNPjZle0CFRqGNzchElSKH3qr2CsGm+9GnILf/u2+sQIHOTOD6xcCUJxqTOnsfZWGZUg41TNPXUqYqHHijK+/vMdn1yezwWNEEBFAoip5zmUd0wv5fwGCBx2gAj86/zcuIiUb8Xt73lC4laQUrZb5yzO2ULBcn34E1I9rJnII/0ZEpbYZqxyQhUbGJVKAyQGjSEG6UjN71aRD2dLMRJE1HQCWYyoaSe6xdWLt2XgLcMfJljmx5mnLCyCLrpdx7wiGGEVRoKVVp1HdcdaCUsLHpUogafJdXePCB9ywy1e7BZaBwo/59aSZlZvekTIghrD2goIiVDPsbCAJf7Vtg4LEjiNV9mLBd12/n1CR
 8jblNRFB
 /H9KbJm0GfGQPSJnCVzz6/W7Q6eCM/oViHDi0YSZvinAfWBQSV+mgrhx0i3wV83NeEDpV1ec4kofw5WYs0pxLEdJ5ez0kMTTxg1ojj6Cla56npvlgrbD9D7uFYpGUDkq7QF39+tqONpSLJVBYNprEvdBTvfCuUybnYrHzGTm024mEj+eWSLZXUGFTulOGarzbZABTEECcu/oU7ZkY5y+Clo5PvoAKY4bOgYnSvdpjCmAbVwRJgLoL/aDYEE1e4QNVGKhf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 17:35, Gregory Price wrote:
> On Tue, Jun 09, 2026 at 12:26:07PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/5/26 23:19, Gregory Price wrote:
>>
>>>  
>>> +static int dax_kmem_parse_state(const char *buf)
>>> +{
>>> +	if (sysfs_streq(buf, "unplugged"))
>>> +		return DAX_KMEM_UNPLUGGED;
>>> +	if (sysfs_streq(buf, "online"))
>>> +		return MMOP_ONLINE;
>>> +	if (sysfs_streq(buf, "online_kernel"))
>>> +		return MMOP_ONLINE_KERNEL;
>>> +	if (sysfs_streq(buf, "online_movable"))
>>> +		return MMOP_ONLINE_MOVABLE;
>>> +	return -EINVAL;
>>
>> Should we try making use of mhp_online_type_from_str()/online_type_to_str()
>> [possibly a nicer exported function for the latter] to avoid duplicating this ...
>>
> 
> In patch 6 response i point out adding MMOP_UNPLUGGED
> 
> If we add MMOP_UNPLUGGED as a state that is only use by callers of
> memory hotplug to represent the current state - but not as a valid input
> to memory_hotplug.c - then we can simply this as you request.
> 
> Although we'll need to add a couple lines to memoryN/state parsing code
> to disallow MMOP_UNPLUGGED as a valid input (otherwise you could
> permanently unplug memory without the ability to get it back... unless
> you want that?  Seems useless to me.)

I would just special-case your KMEM-special value, and then branch off to the
core helpers?

static int dax_kmem_parse_state(const char *buf)
{
	if (sysfs_streq(buf, "unplugged"))
		return DAX_KMEM_UNPLUGGED;
	return mhp_online_type_from_str(...);
}

So there is no need to add a value to MM core?

-- 
Cheers,

David

