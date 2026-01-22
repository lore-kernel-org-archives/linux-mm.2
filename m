Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF8EC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68266B012B; Thu, 22 Jan 2026 04:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46426B012D; Thu, 22 Jan 2026 04:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DEE6B012E; Thu, 22 Jan 2026 04:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6166B012B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:30:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1357E571A7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:30:12 +0000 (UTC)
X-FDA: 84359078664.27.4F65B2D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1AD68A0012
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:30:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jFiLAw3L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4rQzDQ2d;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jFiLAw3L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4rQzDQ2d;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769074210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAT1+es+A4HBBS3yZMDrVW5I/Uvw14juxNaFJLZ0ZB4=;
	b=0SWNI+2a8cSSlMRzz1VllXGqNtGYO/fLqOBBcWUhegP7RkQ6wiG3Dox8HeRAD+3YuP0jGE
	zeJzg+O/+X6pT/R98OJmLyCc6dLE/rsEtXYc7qfAeVC0OQb7MVRqeLdKHZqUJk52IknykW
	rSKNzcohRRejEmPNnvOM3c+/fC1mxIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769074210; a=rsa-sha256;
	cv=none;
	b=lkg6FkXBL6JsrtGtZselkhlrvqzMWGvmRrB+9NpJ1YmpWD7B3Svz8bZOGZehGReH5bB0Qh
	SSMM0B7jxsHWXsuyHqZO8h0lRrOOaQa813hH+Lb+QHnFJGHtICm0qv1YHKX7Rmw54PaSAA
	bM1pSTZCePWf+nefScXsfN0H7i7166g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jFiLAw3L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4rQzDQ2d;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jFiLAw3L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4rQzDQ2d;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6BACB5BD61;
	Thu, 22 Jan 2026 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769074206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAT1+es+A4HBBS3yZMDrVW5I/Uvw14juxNaFJLZ0ZB4=;
	b=jFiLAw3Lq+/mFplVBA7ZIHVHBvXqmWavMIsNSJ5LRwOmkXuQiz1EM9bB/p7pXm335uUhX+
	tuwUIqUd5NUrhp5Xaf48OCwilhkl5L+FI0IZyAJAT2RhMEigmcs1WDzhVHFhRraGSHWiYU
	u4OfsRW+C9t7ENR4ijqlfVrsTJNRtZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769074206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAT1+es+A4HBBS3yZMDrVW5I/Uvw14juxNaFJLZ0ZB4=;
	b=4rQzDQ2d3m/FNW6OWzoSD950xkfAB+1FjR72QF2+u0rkF1L2bFPAgCTITjjxJA7hXtCE2c
	nthg2bbZbHAKfgAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769074206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAT1+es+A4HBBS3yZMDrVW5I/Uvw14juxNaFJLZ0ZB4=;
	b=jFiLAw3Lq+/mFplVBA7ZIHVHBvXqmWavMIsNSJ5LRwOmkXuQiz1EM9bB/p7pXm335uUhX+
	tuwUIqUd5NUrhp5Xaf48OCwilhkl5L+FI0IZyAJAT2RhMEigmcs1WDzhVHFhRraGSHWiYU
	u4OfsRW+C9t7ENR4ijqlfVrsTJNRtZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769074206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAT1+es+A4HBBS3yZMDrVW5I/Uvw14juxNaFJLZ0ZB4=;
	b=4rQzDQ2d3m/FNW6OWzoSD950xkfAB+1FjR72QF2+u0rkF1L2bFPAgCTITjjxJA7hXtCE2c
	nthg2bbZbHAKfgAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EA5813955;
	Thu, 22 Jan 2026 09:30:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rBoqBx7ucWmACgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 09:30:06 +0000
Message-ID: <5cf8b74e-5ba3-4788-ba1a-4cfe9ef366d3@suse.cz>
Date: Thu, 22 Jan 2026 10:30:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/21] mm/slub: cleanup and repurpose some stat items
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-21-5595cb000772@suse.cz>
 <CAJuCfpHg9YfkVwtfCUvLH_0HNWzUgx1ekQ-QMyYBW_Qeqt=WjA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpHg9YfkVwtfCUvLH_0HNWzUgx1ekQ-QMyYBW_Qeqt=WjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1AD68A0012
X-Stat-Signature: wkp7uresrzyox9wfdjwheachdn3o3df3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769074207-708256
X-HE-Meta: U2FsdGVkX1/M+PgqDlTh5QnkIsptFTxMnImSUrM9XhqYtmJMYN5EKHomAwmVH0DAXvU4IPi0iE38chETFwXK+vY7xOiZxYaUPiBTJo3w24kp0y29GyaQ8T26zsplsD2aFMl3iJnJDKUZDNdU+eVxSdiFdVnF/+J8x5EM8eno5luTvO3nZg0LVe1wuTPh1OxnUgFnWMAlbyNhbnwTaycwqhzuHCkt0NuTEttT6nQPXaCCVg8hiXZ+LpX07RBzzrFzBZhiGaQofmKTHZywtC09+WuSbGOjDaW+moMolrhKOINZlI/yH1RFolJejbPzKbq6xsOzbjtnvZAv5+GrVXnjndshYZQ9um9BVMr3G/W1hC+e08vS/Hbt6ntdSLxtQPs47IMlFF9RPV+dWwsgrxIokOUfNBa82VCWDYFbvdhuRjp8ifp5Mbt2Uu+4Zjtx57VCRf6roGQJ+aT7Xm3X8Q44p9OaO12gC7ELxgnlXso37+6fiUSdb1Bn5IkpM5Y7Zl77RhX/JpeIUEkc50wTjeIkBr4cZ/XVzK7MiUVgBvMnSw+yEL/UmXSIvkJNprkzHfON9HPTrMIZrxAh4uUPB1/BJGQrS1G8wx5k2rx2lDVOo6W1NfTbreXMHBO1Eec6AArh9aZS9RiOcofB9Tzhwx7F+W/nUVb2lotncjmRTdFa0qxJNyin+nWihUBofCcGLsKXvhIaud22XiSfbfS9ZgXP7BMdVVw21w4BCX5HpFlbkb2Z0t1upTbPgV6T7xnM/zMq3Wn+KfobWH0C7oBu6ntv5nrJETuPZsrDBQ6jEAz5OTngBAgi+oQ45Jy7tmUcReu2qVRMMVGouRQSZyxzbaf+Nn8l3QNmCydoICS1JV4+y2GF6zCs3urhBK0wbit0j6HEI9ku7ebbX7J7HWxBUhMW3XZQO9VodZueY4KpvlJLOkcXyswRxOft4ZcQzSa0ovsClPODyTp4vd/DLg1UHfm
 z7kRlZcM
 aAd7dcjGzpIDZFaWjuac3IqldVlK+WWnwgsvZhYhb+2oVKKCLxHp4tz2YVdTDVpHv46GmOkJpN7qecsLmWprnHdfOSrhByWExUuCBYti7JvxItTyKPMR3+o69qV1NeyY7yq6o4S8AFpEMs2UKNq183huMZ1WfPnTyxnOcd378sELvdUC7QdLrilCBQw+lPWOJ61gaFcTzJyzDHgiI7jXKNTzZ6L/iBBcvhN+l2h1ydUrEIdy+fdSMs2kyqIvOEDg18G1eGSjlIpu4sVHnfL1R9bhJ9xHceOaJsZpj8GCQUdSTp4rlcw8zGHpiTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 03:35, Suren Baghdasaryan wrote:
> On Fri, Jan 16, 2026 at 6:41 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> A number of stat items related to cpu slabs became unused, remove them.
>>
>> Two of those were ALLOC_FASTPATH and FREE_FASTPATH. But instead of
>> removing those, use them instead of ALLOC_PCS and FREE_PCS, since
>> sheaves are the new (and only) fastpaths, Remove the recently added
>> _PCS variants instead.
>>
>> Change where FREE_SLOWPATH is counted so that it only counts freeing of
>> objects by slab users that (for whatever reason) do not go to a percpu
>> sheaf, and not all (including internal) callers of __slab_free(). Thus
>> flushing sheaves (counted by SHEAF_FLUSH) no longer also increments
>> FREE_SLOWPATH.
> 
> nit: I think I understand what you mean but "no longer also
> increments" sounds wrong. Maybe repharase as "Thus sheaf flushing
> (already counted by SHEAF_FLUSH) does not affect FREE_SLOWPATH
> anymore."?

OK will do.

>> @@ -5111,8 +5100,6 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>>         unsigned long flags;
>>         bool on_node_partial;
>>
>> -       stat(s, FREE_SLOWPATH);
> 
> After moving the above accounting to the callers I think there are
> several callers which won't account it anymore:
> - free_deferred_objects
> - memcg_alloc_abort_single
> - slab_free_after_rcu_debug
> - ___cache_free
> 
> Am I missing something or is that intentional?

I'm adding them for completeness, but not to memcg_alloc_abort_single() as
that's not result of a user-initiated-free.


