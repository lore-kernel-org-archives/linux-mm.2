Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB18CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 17:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201848E0112; Tue, 14 Oct 2025 13:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1AF8E0090; Tue, 14 Oct 2025 13:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051AD8E0112; Tue, 14 Oct 2025 13:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E47F78E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:42:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B006140A69
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:42:18 +0000 (UTC)
X-FDA: 83997438756.22.541E294
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4F81DA001B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:42:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BMwBV93d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XLbyzQ2K;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BMwBV93d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XLbyzQ2K;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760463736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URiO7IixP2q+6gg3VISCX9P098udorxIkiJkXia62O4=;
	b=gZToIaFnuht4qHS3WY+8guZHK+CC73pmyZd62R5TUgtPFzw4qrIga2O4mT6wxtshKJ/gBy
	qZv8n7OeMzPmrNFO3pyvW8pPJAD8yY3biFYAwJjV3COXZeNi/svf7UQSqNK1sM5lhjiunQ
	VGO/jtJwBFAau/36o9RPs3fVpRm9i9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760463736; a=rsa-sha256;
	cv=none;
	b=ONSN+jeKQeMVnUhBXqYisv5uSy3C1e69k8CuwwK0IWGZ/+f2djsj1ssuQv2mbzL8g+GfNC
	nNnPNttYP2awbbs8YuA0ArYaG1qwNlF9+pdv1bODDd67cLvAgcyOCUJ7rMtMudvG0JuAXt
	twSzwl//MU5ORynu2IbzT2EuNZYbML8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BMwBV93d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XLbyzQ2K;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BMwBV93d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XLbyzQ2K;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6E794203BB;
	Tue, 14 Oct 2025 17:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760463734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=URiO7IixP2q+6gg3VISCX9P098udorxIkiJkXia62O4=;
	b=BMwBV93d6A1g5P8Dx5Vou4Ki403PifgdX0f9kgk4DJ3U1oeRzHNTzO1sSLo8jPjHTYXcbG
	8wNpDLKCQimQ81JZNzDR2QrYoa+uwWZ3vk5jCE2Sj7dk4rxe0DzRp7j05WsoCio+tT1FTO
	srVKKTKqioPsVSwAWP6yt/BAjnKxmVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760463734;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=URiO7IixP2q+6gg3VISCX9P098udorxIkiJkXia62O4=;
	b=XLbyzQ2KrdBCTsTMYmeDeU6+WNVpi5V7Q1zCNra4qBhqj82ZjpyYdd0+DamP0sregod6AV
	Rc0jGSTGDvJe8ACg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760463734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=URiO7IixP2q+6gg3VISCX9P098udorxIkiJkXia62O4=;
	b=BMwBV93d6A1g5P8Dx5Vou4Ki403PifgdX0f9kgk4DJ3U1oeRzHNTzO1sSLo8jPjHTYXcbG
	8wNpDLKCQimQ81JZNzDR2QrYoa+uwWZ3vk5jCE2Sj7dk4rxe0DzRp7j05WsoCio+tT1FTO
	srVKKTKqioPsVSwAWP6yt/BAjnKxmVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760463734;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=URiO7IixP2q+6gg3VISCX9P098udorxIkiJkXia62O4=;
	b=XLbyzQ2KrdBCTsTMYmeDeU6+WNVpi5V7Q1zCNra4qBhqj82ZjpyYdd0+DamP0sregod6AV
	Rc0jGSTGDvJe8ACg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51302139B0;
	Tue, 14 Oct 2025 17:42:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Wl1yE3aL7mipNwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 14 Oct 2025 17:42:14 +0000
Message-ID: <6f09edd2-2149-4854-9d2e-24b07bdccc75@suse.cz>
Date: Tue, 14 Oct 2025 19:42:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm/page_alloc: Batch page freeing in
 free_frozen_page_commit
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Kiryl Shutsemau <kirill@shutemov.name>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251014131527.2682236-1-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251014131527.2682236-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: s7dprro4a8gzqcz63huhjogpr9hffwwn
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F81DA001B
X-HE-Tag: 1760463736-856967
X-HE-Meta: U2FsdGVkX1+L22R1bRwJrKudkzyKqaOSVd59HqaHEA4vaTsAr4syRmBh/QiAG19rJj02w/Th0Y2AXnsWIIC2VS21cDi/Mwqf0csMbt165DhEPM2u//6UzWKi33Ohdl1CjC+E3luJjtsS55tGDC+EKjFzpjUGoesPEaXIUUzS6jR/DtTPqHwZsbE4ZaahDVY3a/02jEIpht4n9jgLjhYYbMRV+9rPTJGn2Cl/DHBpfbqAauTL2CMkh8MUXe4Q3p3q8N1l6WBWN/voYRZoKd0uqT9RQGh7ynMnft7vj+1iTXYxvtR1hK8it7xK9V0RFWC2zS+cj8ZMcErbdEiCLDh4eRmmGzfJMJAW6sKyIdj5Imawu/CumVqV5WrBSIMzwAEMjDYKsyEj1lBgoPvx5a+BIHgMgfWJp+UEPrbN0IwDJvhYHb1iVRZT5FcxoICa0MMz6fCPaWGkIumkb7b9KRnAJgidZcm7WOrVDSqCCh6zGh++ZHXyH3MVUjaALticx6tMYqzY8iokDZXluBq6G0ysiPsTZyI5hr6EdDzL0JuPh3z7QETWN1Y2dHu5yqvqsqZfJb4edz1xXaE304V1ZJ5Ema2KhK87xO7rgDrSK03Hti/fuyaLdJTwKwka4X/oggyhf90t08d08/lzsNSKRFzX+zulU07JpfnFJcCZWrIflOIZ6/D2JhrmtoAweUCZEIrojguUyv5/SFZ2vmliYzj/uQYQbGCJPSbutf6jnVTr85QWQsfDqqwhNHtPuP9OysuaKO5doi7K5tSM2wzfNkw4gpHj7oIQ0lr880VEyyJRk3IPB1FH1sTIed0tmoR8EUqIYqwejeghe0Dute0JHQ1jv5FWHxYF0TEeRikgnHZJNrHpKKCdlAVkiHYw7cG9s67k98lHjtOkIhz48eBX5jdJCWUswv2zdVsVoZgn1YDptJRCZF9vS/i59kKtk1am7+B774NFBkDWGsWjfjEkMCV
 86TLULM9
 ZsIxlKBHngTLzA+Ehjyhbbtw+/gN8QZdaJiKJNmaMqM+B8X9sGzopE250hwy5cGLyq2DCvP47jDPFp+0F0pGfFMny5GHdy7tekYsBZpNtwDUpxVia7ctto7m3uYEXnUE93eSTP/P8BELlJ7m4dnspH9TjuDnSS+0tijiOZW0F8e/c1H576ICHm2aWlqqGjnpivFyyDLOKVS0E0y3G7c1lvrzJ0evBgZ2HB1Q/Kc0Zv1hWnTO88i6GtcQ26RAKZBwn8fcFQ8B46ctaJ/wbicgrpKONycXo18z+0OHBvybCxBilu5Mz94X6fux97i0c5a6WvKf1pcRIWI3+2OVNB12R+E04UO1d0MTujNRg17nptAF2hhdlsPaRUCSfyasucwxky60n9BrencwopMyf5ajiaDzpSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 15:15, Joshua Hahn wrote:
> On Tue, 14 Oct 2025 11:38:00 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> On 10/13/25 21:08, Joshua Hahn wrote:
>> > Before returning, free_frozen_page_commit calls free_pcppages_bulk using
>> > nr_pcp_free to determine how many pages can appropritately be freed,
>> > based on the tunable parameters stored in pcp. While this number is an
>> > accurate representation of how many pages should be freed in total, it
>> > is not an appropriate number of pages to free at once using
>> > free_pcppages_bulk, since we have seen the value consistently go above
>> > 2000 in the Meta fleet on larger machines.
>> > 
>> > As such, perform batched page freeing in free_pcppages_bulk by using
>> > pcp->batch member. In order to ensure that other processes are not
>> > starved of the zone lock, free both the zone lock and pcp lock to yield to
>> > other threads.
>> > 
>> > Note that because free_frozen_page_commit now performs a spinlock inside the
>> > function (and can fail), the function may now return with a freed pcp.
>> > To handle this, return true if the pcp is locked on exit and false otherwise.
>> > 
>> > In addition, since free_frozen_page_commit must now be aware of what UP
>> > flags were stored at the time of the spin lock, and because we must be
>> > able to report new UP flags to the callers, add a new unsigned long*
>> > parameter UP_flags to keep track of this.
> 
> [...snip...]
> 
>> > @@ -2861,15 +2871,47 @@ static void free_frozen_page_commit(struct zone *zone,
>> >  		 * Do not attempt to take a zone lock. Let pcp->count get
>> >  		 * over high mark temporarily.
>> >  		 */
>> > -		return;
>> > +		return true;
>> >  	}
>> >  
>> >  	high = nr_pcp_high(pcp, zone, batch, free_high);
>> >  	if (pcp->count < high)
>> > -		return;
>> > +		return true;
>> > +
>> > +	to_free = nr_pcp_free(pcp, batch, high, free_high);
>> > +	if (to_free == 0)
>> > +		return true;
> 
> Hello Vlastimil, thank you for your patience and review on this iteration!

No problem!

> 
>> > +		to_free_batched = min(to_free, batch);
>> > +		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
>> > +		to_free -= to_free_batched;
>> > +		if (pcp->count >= high) {
> 
> Here, I think I should change this in the next version to also just check
> for the same condition in the while loop (i.e. to_free > 0 && pcp->count > 0)

You're right, I missed that one.
> The idea is that if we have another iteration, we will re-lock. Otherwise, we
> can just ignore the case inside the if statement. I think if it is left as
> a check for pcp->count >= high, then there will be a weird case for when
> 0 < pcp->count <= high, where we continue to call free_pcppages_bulk but
> do not re-lock.
> 
> So unfortunately, I will have to check for the same condition of the
> while loop in the if statement : -( I'll send a new version with the changes;
> I don't expect there to be a drastic performance change, since I think the
> early termination case would have only applied if there was a race condition
> that freed the pcp remotely.

Great!


