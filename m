Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D53C47BE0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 10:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD036B008A; Tue,  6 Jan 2026 05:38:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B546B0093; Tue,  6 Jan 2026 05:38:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1126E6B0095; Tue,  6 Jan 2026 05:38:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F24756B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:38:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CC9A58FEE
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:38:49 +0000 (UTC)
X-FDA: 84301190778.01.6D3F60E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C52320004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:38:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zFUQDZPK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vq5N0il0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zFUQDZPK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vq5N0il0;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767695927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woe7anwbB9JirxyyXAWMC4pxGiIUU4x6DNKGJ7UdkNU=;
	b=GKApzvV4Jm6j8+nQLcChYYtprVwT+E2YcXkZSqovVoY/ccT/o2TyqTGoztJw6MfoeEagYG
	KUOfSepxHH8QmyddB7HQVTD+BQuf60VmJq8elzzupcPy6nes8s4NH19KhD4LHMeh/JO9n4
	GRwhmU2xQVh2Y4OnOD0HrRbhqbECA7c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zFUQDZPK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vq5N0il0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zFUQDZPK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vq5N0il0;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767695927; a=rsa-sha256;
	cv=none;
	b=5SplS+iLPMerZY0e0i/Gj3UfwyqO67qLpeGDvvAKgMkCLRBfSHLDwCnao1y4QY3FwFHwc3
	rRkLFPB41aEZxpFKXQVrRTcByF7vYg6vVNUlk3vww8ULyTavZNSzlRZmlrf5wYUKRYPNIN
	M789pg6ixV22TFZOLuYK4eJcjJ9m018=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 55D595BCC3;
	Tue,  6 Jan 2026 10:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767695925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=woe7anwbB9JirxyyXAWMC4pxGiIUU4x6DNKGJ7UdkNU=;
	b=zFUQDZPKqbpmZRSk2KsWlBJ5ygfS8BU/U0JfKYeTZ+oBvmfG6veNn+xA1n0x2DdHIXulYl
	yGzUb92S2CfbVIe49HhVnw5rXQk5S7Kbp5fo4HHgA8Mfnu7lT8CZ9HYBnVIgbXpUabkgW9
	6yDhqZShBz4IoEQrsF8G9z/gVZrV/Vs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767695925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=woe7anwbB9JirxyyXAWMC4pxGiIUU4x6DNKGJ7UdkNU=;
	b=Vq5N0il0hLZUkcCHdEIrZBypRqxvjDWCTXWyDHvHD7eyQRHgn3GY4eDv8ZgP0fLQY2A3/x
	Rt2wNxph4XRJHKBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767695925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=woe7anwbB9JirxyyXAWMC4pxGiIUU4x6DNKGJ7UdkNU=;
	b=zFUQDZPKqbpmZRSk2KsWlBJ5ygfS8BU/U0JfKYeTZ+oBvmfG6veNn+xA1n0x2DdHIXulYl
	yGzUb92S2CfbVIe49HhVnw5rXQk5S7Kbp5fo4HHgA8Mfnu7lT8CZ9HYBnVIgbXpUabkgW9
	6yDhqZShBz4IoEQrsF8G9z/gVZrV/Vs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767695925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=woe7anwbB9JirxyyXAWMC4pxGiIUU4x6DNKGJ7UdkNU=;
	b=Vq5N0il0hLZUkcCHdEIrZBypRqxvjDWCTXWyDHvHD7eyQRHgn3GY4eDv8ZgP0fLQY2A3/x
	Rt2wNxph4XRJHKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 339323EA63;
	Tue,  6 Jan 2026 10:38:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lL34CzXmXGmDJwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 10:38:45 +0000
Message-ID: <a6e16aa3-b98b-44ff-ae05-4f1002840f4a@suse.cz>
Date: Tue, 6 Jan 2026 11:38:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 2/3] mm/page_alloc: refactor the initial compaction
 handling
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251222074055.74545-1-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251222074055.74545-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C52320004
X-Stat-Signature: dienux3ei1r7ofoxtbhp4meyhtaetyze
X-Rspam-User: 
X-HE-Tag: 1767695926-263967
X-HE-Meta: U2FsdGVkX1/Bfodwa0WGnFCLwjraU9KFvz0TYWDtQGMVa/t9xm6gO9JPUZ+BMvXs4hr09bjOHFB6ZUrRZyhmM8QAGS2gvbLN9aE19K9jmqulYrMg8Og7RwBN3FJCGMtbRYlYD4Pycv0Ni4Rml3l+tPToZn88lhCxbfMFkyy/6VyhWexH6FGrxetX/x+aA2lqEQUkiTJcHZjnSMFIJNsLRZFTqt7g8MJaeqYd+TkQSMxF+MZvm9o6fMnl9u2gLDLKfrvzzII3np9fJbMANSaqeN4BJusQDDJRgARiMDoJmbO/JaVmraXv7MbPecf4EbMjct3jmbVea0ONhNHpqWIgKAbB+X5q0zSCHUOtZILVftd0yjYa/KFgIEuliDpdGX4ikvka8M4qOIxuR+OQyKs/d2SWOvPi/7X7WTTAke/aEAmFuEl51BMXRZnaojdju78kdaoek0hPi8TzEbfq2N3BgOnMnS5ubyTKeXRk/f3vh8vMnfL1s9dDNbgMIUY+IPcWBMf/+iAlhoE8PpG7b3mjJ/kgFJW6fjpao0h98FBzhWrI3RaTxyzn2I/L/C9oUi8xEm1egETOD36/DtvauD3H5JG9GEAqiJeEwr8B4kwPPQDtvml80mRsrYxcsn0/2UMnCVaP3cVzFDFk3b4jizbJ+IDjkWaxlIjtsPzkr+FCeHopcINAS6Il80RjkVn2EfuhiDCVn82J+JKrlH1WXzmCJZQ10JfZSahvHep323mKN7wyF4777eWes8EIc3W62QlSBdV4D64tZNwVM7SGMHKAXbf+P3bWqJNxu2f/P7SVMukmmxYhmo9tlkSwYPOsk4gleLXIglGb0/YsBPBU4x0sHQcXvJCaZXHdXMGT6d9J2W43OrYM8ZUpHxgw4xqvBc27EEG2HVPhZhizzo2lWxljuM1/oW9s7X9jXZW5ynq/vQTZc6+Oe0SNgbII3/KzFmXZQVKFWY9H9zb/6VpGAjw
 p3BkLJ+d
 El6C8kGZbvI84Z9QtbuIHqQGY7PR0xd14PHoO5Odx+hyORhpzkVsUYl4b+Cv0ANClVcRXbFQW4ms5KklYGZ+DV7BbxxSVTUdiiPtLbFED3B79VECTeaB6pPu91j1pESNasmSVDBJom4itYXfvoIr6h13VvBI+j1Ftmdeq6aZWVGhzrQEOOpq8c1joPMUV5sB2++U/klIqgW9/QEc6F44aL7k80kGL3aqkosQt2Z4rncxr984Krq2XcwfhRKYJU28ImFw2jTANKSt45EDLMdcTrc2epvy4gd4yT6y2E95PZCmAHMaVvMd3pYusrogZ6jFIHw2Lxgpfn/E8DDsPfD1x6xBVTNviiHZY4pWJu/mcAxyYQ+O6modRz6xg7oroHazvZCp67iC1rCAhF6fvkd4lSRhaImiZ4KjY0Ny0pUe8Jfc0lbnZXf4jUhEKaSnwpreCfsQxkGD2mKRZMmxcbcLFV7DdvZHhnjfjrxM8RIn0nnzCIZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 08:40, Joshua Hahn wrote:
> On Fri, 19 Dec 2025 18:38:52 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
> Hi Vlastimil,
> 
> I hope you are doing well, sorry for the late reply. The patch overall looks
> good to me, but I have a few very small nits.
> 
>> The initial direct compaction done in some cases in
>> __alloc_pages_slowpath() stands out from the main retry loop of
>> reclaim + compaction.
>> 
>> We can simplify this by instead skipping the initial reclaim attempt via
>> a new local variable compact_first, and handle the compact_prority to
>> match the original behavior.
>> 
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/page_alloc.c | 106 +++++++++++++++++++++++++++++---------------------------
>>  1 file changed, 54 insertions(+), 52 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 9e7b0967f1b5..cb8965fd5e20 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4512,6 +4512,11 @@ static bool oom_reserves_allowed(struct task_struct *tsk)
>>  	return true;
>>  }
>>  
>> +static inline bool gfp_thisnode_noretry(gfp_t gfp_mask)
>> +{
>> +	return (gfp_mask & __GFP_NORETRY) && (gfp_mask & __GFP_THISNODE);
>> +}
> 
> NIT: Is there a reason why this was turned into its own function? The checks
> seem short enough to open-code and it seems like there's only one caller as
> far as I can tell. Actually I think there are some better candidates of
> turning boolean checks into functions, like the one below:

I initially made the helper because there were multiple uses of it but then
went away with the refactoring. Agree it's not useful at this point.

> [...snip...]
> 
>> +	/*
>> +	 * For costly allocations, try direct compaction first, as it's likely
>> +	 * that we have enough base pages and don't need to reclaim. For non-
>> +	 * movable high-order allocations, do that as well, as compaction will
>> +	 * try prevent permanent fragmentation by migrating from blocks of the
>> +	 * same migratetype.
>> +	 */
>> +	if (can_compact && (costly_order || (order > 0 &&
>> +					ac->migratetype != MIGRATE_MOVABLE))) {
>> +		compact_first = true;
>> +		compact_priority = INIT_COMPACT_PRIORITY;
>> +	}
>> +
> 
> It has indeed become shorter thanks to this patch, but I think if we want to
> make the code more "readable" we can stay consistent and move these into thier
> own boolean checks, or just leave them open-coded. No strong preference here,
> just wanted to offer my 2c and hear what you think.

Yeah I'll leave the open coded variants, as with single usages the wrappers
would just add another layer to go through when trying to understand the code.

> [...snip...]
> 
>> +		/*
>> +		 * For the initial compaction attempt we have lowered its
>> +		 * priority. Restore it for further retries. With __GFP_NORETRY
>> +		 * there will be a single round of reclaim+compaction with the
>> +		 * lowered priority.
>> +		 */
>> +		if (!(gfp_mask & __GFP_NORETRY)) {
>> +			compact_priority = DEF_COMPACT_PRIORITY;
>> +		}
> 
> NIT: I think these braces are unecessary : -)

Ack.

> Otherwise, LGTM! Thank you for your work, it looks a lot cleaner.
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks!

