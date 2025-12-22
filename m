Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1BF6E677ED
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 16:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21126B0088; Mon, 22 Dec 2025 11:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4556B0089; Mon, 22 Dec 2025 11:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E876B008A; Mon, 22 Dec 2025 11:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C32116B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:11:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9664916025D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:11:19 +0000 (UTC)
X-FDA: 84247596678.15.486666D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1B7178000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:11:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tqoxDoaC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lot4pniX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zTarqlek;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GkX85H+l;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766419877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKhTDzTzmD5iKvmoTGnpWCFjsyMXUoyPigq7m7JqQmY=;
	b=VSXWNDX8MNmaYR0psps5QO2Eb1ygp0eIEfz1XQjSjPR+8zF2fezoUsaRoMvcxW4ki7bICa
	0IpAJ0byqhuDvVd0K+ZAMumSI/AKrqYc6BpVr3fDRmTaSl5s8LC5dBfp6cH0R0u3cE09mR
	dhyU7DMBxDyGg2x2SkFAWiwtq9GN/1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766419877; a=rsa-sha256;
	cv=none;
	b=xgW8gfZ8GsEv7QVu5royN51zrGWUEycc0ru63psPQuD6vVECWsmCWOAh5gHomlq5BswfPH
	j3MvktryXCzbhOCb2jVJjD9y1bT/+w1jYTya9KGUFJnEFIVAI+kA+zNeWLuLEfFqH96Axj
	0xLc04yBPzT1pVc/mZ+PX52rV6i504I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tqoxDoaC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lot4pniX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zTarqlek;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GkX85H+l;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 259935BCDA;
	Mon, 22 Dec 2025 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766419875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AKhTDzTzmD5iKvmoTGnpWCFjsyMXUoyPigq7m7JqQmY=;
	b=tqoxDoaCPc0AcEMn8QE74YblxKt9/oimhQ/BHAoTpP1C99doouK9n+IyOegyLASbV3qjic
	Qqgy1AJMctRb5iCqXWWKMmAVSyI4CZwqX4G2+VAcrJluoM1wDwRgRDmHtixSejVfqm62h8
	aUI3OqUzAvXUiP1wVEUEHFNHrznOW+o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766419875;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AKhTDzTzmD5iKvmoTGnpWCFjsyMXUoyPigq7m7JqQmY=;
	b=Lot4pniXzhejp6mYqaooYLLzLxgZEPH5ZmJiRJABivVIoavxBPSRycSKChtinWIiIV99mI
	CVf6R2LieI5wsEBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766419874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AKhTDzTzmD5iKvmoTGnpWCFjsyMXUoyPigq7m7JqQmY=;
	b=zTarqlekhFb2QnZCpQJSi7bSo8COvZ6VOBOFx3svvXRaGYKEsxuTgzcgwB8V3y+A3hFB2o
	dUA1XDuP5/DJwKAjwCEP4/VWaMu0+NIQd1J/QohOpGGyrvTIrV6Daqmcuhk3K5+2TVpqHp
	vd0S0VE2ybBqEYbCOAvPtOLXKnUdEb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766419874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AKhTDzTzmD5iKvmoTGnpWCFjsyMXUoyPigq7m7JqQmY=;
	b=GkX85H+luA75Q/QWZBgVSB9T0h/0H7IeLCqBIt992Km9Iaezk7kxHP4+O0lQ+3R54bb5A5
	B3W6CGw8T6GPtYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 075213EA63;
	Mon, 22 Dec 2025 16:11:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I6J/AaJtSWnDFAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 22 Dec 2025 16:11:14 +0000
Message-ID: <5a1721bc-e7e8-40e8-b2b9-c071d18a0112@suse.cz>
Date: Mon, 22 Dec 2025 17:11:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm/vmalloc] a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
To: Matthew Wilcox <willy@infradead.org>,
 kernel test robot <oliver.sang@intel.com>
Cc: Vishal Moola <vishal.moola@gmail.com>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 Mel Gorman <mgorman@techsingularity.net>
References: <202512101320.e2f2dd6f-lkp@intel.com>
 <aUW05pyc9nZkvY-1@casper.infradead.org>
 <aUXhy1Jyv7_GccIp@casper.infradead.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aUXhy1Jyv7_GccIp@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9wnj9cxk33i6btrron3ocejzjf9fzq7h
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B7178000C
X-Rspam-User: 
X-HE-Tag: 1766419876-346745
X-HE-Meta: U2FsdGVkX18QeoilYSIIhub3QavBvuclR2xIka7JNniZxWXrD67DYizENgqZhepwU9uVZtU4Z/Ko2iXNXlTxNiyO2tLpy3KZFjp7d86FlBiV56ajIc4+fLEugLo0tBvOJvPZPIFsoXCiqo9ObUNvh20NBsHSrteOFjSu2461jvfXIRdYSVDW3aaLY8W3+lsHMUWDrzqjAtB1ctx9jBMmdxd49FmQy+5oyOV1KQ4saR3+q4enR3ybgOWMyaaw4InZXaotcEeKFaLbXhFgaPhjY9tVNuBjsBmgU7vALFFLY5MKUKHpSQGKo2WcbbDjsv4tHUjzUO/29GSX0qnKSZx/u3x/23eW9n5IctQaNv4aDaivQSUOawWFIl37Q+btl1j68ncqNxZ/G3GP+sWP7nAcazHd11o8/GFsLCEzkptQlA/4A+VF+LHXWgbws9hHIf1dQLTreDqum2LVp9T4LW/AUEGPYEgjX52X/F5yKfCivMkI42c6Cj2kJ2f5yfzkyTBdpPMtItWbrRgPkaqBnKzOaeLP9cBLezsr9le4cmCy7JwIv/v1vcgx55WJyLX+euO9Ji+ohilNha2MLDJMS0g6/EUUoIKIiwbAV0xn5TKV8MNtJNII1PoltuZomrZjAOdsCDznVyEaOpZbVqFlemcuTLPbThPXavlO3HVabodYfUaPL146v6V8xN5ppxvZoJt4Ux2p5MWk4WfvgEnMVN5QX23gWeOtszEdR5RHP2w+ARCdVgwAbK0JRwsqa2HFwXwCWWoMqcjdaCF0WuNzBwx4uvv39uf2WTg7fuonmmN/g/TGyPebm+SzYjYcL7XaeZPkKqV+1w7ATrglaIJCwqbe1qFzb3DhVMIUUbiwFGbCAgIYwQZo+Bb18+FJrK8qS9tUnb+n6JqO1a6HG+Fk262bzrq15o7Xo/VMk/mp2CYN4tuQ/w3DJn9uZygKuqCpl/D7xN0Bg8SlD0rgVrEPynd
 XbTTG6Ji
 JQ6Dz5SVgk9Ud6DGbGG/9MPFBii3iQ5if0XbQ8PHov+OXV+mKsIfubAQ+Pt3uKkJgehuPJjB1hvH+pu4/R0UMHcuF3XJb0V11iASqtCIbT4ANy13H2HALUrkqsfoGpqjhn9kFKCpkUHB7kgtMym1ApPPrbFKUcDrbVkMFVTl7+FZ5zHcAAOTPkY07e9w2WL1IbQYXfpx83U+tuWC6oqxtFE6uaPE8eOAWyvraLROk02vkl3m/YomfyJacWF1iLMDjnimU6XipP7xJlb/TwsN3Jbc5T6427CMOZJL3CdlNa6J13qzLaamxBRctbGUHvu29PlA4YVkiPFpyoqyNUyiMnUKu1DGOvriYoa3V5x/NMi75EvsVTqJ+anLvT1PK73ohs1AAgxl2cuOBznL91bmBE7FnoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 00:37, Matthew Wilcox wrote:
> On Fri, Dec 19, 2025 at 08:26:14PM +0000, Matthew Wilcox wrote:
>> Now, as I recall, we are very much doing this on purpose.  We decided
>> not to disable interrupts at this point for improved interrupt
>> latency, accepting the possibility that we'd occasionally fail
>> the trylock.  Except on UP that's now an assertion failure.

IIRC the primary motivation wasn't irq latency, it was to avoid IPIs for
remote drains. So the drain_pages_zone() can be in fact locking pcp of
another cpu, and any local operations on that cpu are then supposed to fail
their trylock (should be relatively rare). Disabling irqs would then make no
sense for protecting other cpu.

> This is stupid and wrong.  If we have CONFIG_SMP=n and
> CONFIG_DEBUG_SPINLOCK=n, then trylock always succeeds.  And we'll end
> up corrupting the data structure protected by the lock.  So the warning
> is real, and we need to fix this.

That seems to be true and we should probably be doing spin_lock_irqsave() on
UP instead of spin_lock() in drain_pages_zone() and several other places.
Ideally via some wrappers like we have for the trylock operations that also
do some UP-specific stuff - pcp_spin_trylock() and pcp_spin_trylock().

> With my distro hat on, I do not give two hoots.  We don't ship a nosmp
> kernel.  I suspect all other distros (except maybe something targetting
> m68k?) are in the same boat.

Yeah seems the problem was introduced at 6.2 with commit 574907741599
("mm/page_alloc: leave IRQs enabled for per-cpu page allocations") or
something around that.

I'm off until Jan 5th so won't be developing a fix until then, but agree it
doesn't seem that urgent now.


