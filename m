Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0092DC44501
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D966B00C2; Mon,  6 Jul 2026 09:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD7E6B00C9; Mon,  6 Jul 2026 09:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD526B00CB; Mon,  6 Jul 2026 09:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0ED76B00C2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:47:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4485F1403FD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:47:53 +0000 (UTC)
X-FDA: 84958480026.24.FAC953E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 760B640003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:47:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7lLSbte;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbPEspgjb9iGcX/qagd/OLVGEsMaq2T5st1yXWGMpXw=;
	b=uCIO8enTJ/F7X97QZvxTfsB8zfUpqCw9z5ETQ7TMAB51JDE9bKqXohVSE8611kVa8Y6yEt
	0xbz09zJsFgF11dIlhQMa5NjYKYBb3ESvCu9vd0gGcUjzMgzQLTyczavk88E2ulRLTZDDm
	KUoxfvUlAacuPUjiPCEAuziEQUJDqpU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7lLSbte;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345671;
	b=Qa13/qMeZExIS8xW3OAUK7eGFdUJFnfEtWr3n1nrgUJDWGClemLfSpKe/qBsVgysMMcSFR
	y2IoUQwd2VrauAD8oYLRs7lbP4dLW8CtRjOkIfKfnJd0EXvSVWEO4OWUtUuR7jaPB7ptdS
	sIPpAQZMVTDDiBvIBQNnnYnP+LWpu5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3FDE429EE;
	Mon,  6 Jul 2026 13:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0A41F00AC4;
	Mon,  6 Jul 2026 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783345670;
	bh=XbPEspgjb9iGcX/qagd/OLVGEsMaq2T5st1yXWGMpXw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T7lLSbte1fabsTl8bqPNuY+WLRW6VPGciNfEAYPT0untF/dtC13lyqXaIO0GUsbnr
	 XYTVpJJ5iSiIBpBoxy4cw6YQyaZpL+8tqyGQ8Um1dEpjQHgpXD8mWTKuV5TUacGD4V
	 oJ735qQnfjo9RyoPMRCr0PXK0GeQdEC1wR80Tm/f9OCNJr+/bWfPJQAI134iqWkPly
	 Z0K+i2IqKGqfKnpbqJ5B7sITRrsf3hZqa2a1UntZgvnAwrzBx52Ja0uDy8kHmCy9y8
	 2HxQdNUljStTVdpR6WtuwGU+mGKZQgJwNsmUIO7lNa5o58I0xDcvjxs1nzjJ2RHi92
	 YsuDksmPhh2Rg==
Message-ID: <374a0a2a-444c-412b-8ab8-414dff6a2ca9@kernel.org>
Date: Mon, 6 Jul 2026 15:47:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/8] mm: factor zone-device page init helpers out of
 __init_zone_device_page
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
 bp@alien8.de, dave.hansen@linux.intel.com, kees@kernel.org,
 linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
 rppt@kernel.org, tglx@kernel.org, x86@kernel.org
References: <38919e81-4c35-4e8b-ba2a-8af8be60b0b6@kernel.org>
 <20260706115035.49813-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706115035.49813-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 760B640003
X-Stat-Signature: 784mnq1ot1e36zstufunpajfj5xdjmu4
X-Rspam-User: 
X-HE-Tag: 1783345671-688647
X-HE-Meta: U2FsdGVkX1+O6WZheEI7ARxW0b3wLNplHOYOuM3M9Ro9wDNQq0E3d6xlXvfECuemQoPUqy5zdNc6kLopxUuczZlytlZPvXHTOZnEK2vgt6GinHphOiD3kxxtxRVOwb8evRMizi3W6Ae4oRcGU744kxw3BLp6QFVoE9i7UQysOWsOhYQUK6qEmPolzTesL63vm5yeYytb+mXtrsp4Vz1Jh5f4/B2n6T2WWbLu2UR4FyT4tYw27h9BkT4mSgCqDvHS11kLcS0J/A6rVjlV7cd6HVVOByOQO3rAaOHTCJqh8V9QlHAuYFo3Bv87PtF3fcUbYUON7oyAL4gsihLwLyE1w+oQhY7sOVr0iokXDZdMg2BBmQYaLhk7o9rmxZkvj/tq+9eqYQDWL4Hxdw+ZDP1w0jVFnnpkBm/0QXHdQ/MeXfgnZ90znyqD3JQvvky5sZZJpr3qiDYZIKwIOSDP+gXSfkG5UFc6hPa0IRj2XTpw6HhjpPQTQT0MW+t7EU3VMKevj9qY8f6oVA0DHK+GBpIfjr2IgtWc1v6/akz3hyGJt1OY+/RZZmZBUtcaB4nQNL0fm+eKCkVU/hRuYPTR5JTY6dvN3vr7dow6CjhSWUbiSGggUbjkF5LcsixBJoWpplDeFjc/4nHVu5WpYT4pBJ8YknxMOyakrbmIWhmDvJ9CoXXKb/m3r3C19HGM28pHWWt6nplLqyU7KJS2tCYfBkXFk1ZKdWGUMV+Gn5NnE/2hKpM8KVt9fzewjDe7/mzirGbikM/wKt3zIYkmRWjXAzumtIm4O22pvPPd8Ntr+uIAvFL1c//XwDZ0aTDqESw7fo1YGsmcyX0OmR+LIyMQcim3w6b/WF7xaw4kWNX9nS3oRe69XBRcMaQiJ9TeiyHxAw68OHLVJqSoSuVvlaHtwV/rGsK62QH2FDywV83N8o0jDWvxqK6CrXlrx6kQl737kXqr7cV6R6bLwq7bewxemJL
 fIHMfmQp
 T0tyVKHDGiEPhxuMq+eq4b0CwZZT53mYg15qwHI/9wlyxI1ueLm6wOewT7VSw2O5+oX2TGzPM3v9h26AGQ0ToonP4TWN3e5uh911X/YY+EFtCZJt/sIFVzCNStdM7HIEP+N1XbQ2CES/QcWvAMZmDYJheWQyMVSyVPqh0WuUIkYJ5Bl4qDR43dW3gn2mTKuOHHxoN3LFWTMPxRCWNjpDzHFikUve23sZNszEScCTOQKnppnYHohskddOS2nlMhMblmi92JNO3g40BLMMOEF2K3fCrfURirblk7zAWj/9n8RcMa5ZZ26euof8iGJ0NAnZpNqtK0vLuDKxb3js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 13:50, Li Zhe wrote:
> On Mon, Jul 6, 2026 at 11:13:45AM +0200, david@kernel.org wrote:
> 
>>> +static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
>>> +{
>>> +	/*
>>> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
>>> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
>>> +	 * the count again when the allocator or driver hands the page out.
>>> +	 */
>>> +	switch (pgmap->type) {
>>> +	case MEMORY_DEVICE_FS_DAX:
>>> +	case MEMORY_DEVICE_PRIVATE:
>>> +	case MEMORY_DEVICE_COHERENT:
>>> +	case MEMORY_DEVICE_PCI_P2PDMA:
>>> +		return false;
>>> +	case MEMORY_DEVICE_GENERIC:
>>> +		return true;
>>> +	default:
>>> +		WARN_ONCE(1, "Unknown memory type!");
>>> +		return true;
>>
>> Wouldn't the compiler warn if we would define a new type but forgot to update it
>> here? We're using an enum, and I thought the compiler would bail out in that case.
>>
>> Or are we scared of some other garbage ending up in there?
>>
>> Apart from that LGTM.
> 
> Thanks.
> 
> I will drop the default case in v6 so a newly added enum memory_type
> value is easier to catch during build review.
> 
> I will move the WARN_ONCE() after the switch so we still keep a
> runtime guard in case some invalid value ever shows up there.

If the compiler complains, we won't need the WARN_ONCE().

-- 
Cheers,

David

