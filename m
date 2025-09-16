Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C64CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9818E001C; Tue, 16 Sep 2025 08:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A5E8E0001; Tue, 16 Sep 2025 08:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4495D8E001C; Tue, 16 Sep 2025 08:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3262D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:25:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D00EA1A00E9
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:25:10 +0000 (UTC)
X-FDA: 83895033180.29.0B073A8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A99340002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:25:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DsNBnqnT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YUA7UAwJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DsNBnqnT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YUA7UAwJ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0pPuWp2BNu3NBcJM9vWn6dowI1JFSkBMrrb6aXFThBM=;
	b=ULORnzkLbikt37EX7tR8Ti3SvxG10m+hhVAxLLYueCZ25F+3zOnEe1TesWC8yqGT5ywcFR
	Wel3aS1VwZ1WyQxOZsQERkdYFJ2A8zscLfc0ad3yykLYwfVYq77dIjtjcpEbRus2e4l4WV
	vJMaThayOrp7GJUmWXRhKC5T3GJTlWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758025508; a=rsa-sha256;
	cv=none;
	b=qzNY+jLTafbkQzAHTeTtO6u5jqh1LQe4lnodQ2wjHkfKdAUTI8QN35tjcpQYptVCjCWNig
	D/V4lFMurROADLuAlRcIFAUYv9RDDpOcslziYh2BBr1jy5/M6Y6lrtDqPuTohu/07NZEJ4
	ABySMfzgcNRiACyo8A+RCfu1DaG1quU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DsNBnqnT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YUA7UAwJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DsNBnqnT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YUA7UAwJ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 34F9922238;
	Tue, 16 Sep 2025 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758025506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0pPuWp2BNu3NBcJM9vWn6dowI1JFSkBMrrb6aXFThBM=;
	b=DsNBnqnTs2enxmErYm/wr4REs1CvXeqhu7xasCeV5S4KexLsmkLhPyO5GM6q5ibEJaEfSB
	M+fMM8tMjmZIjA/iCS9JFEqa1xB0bFTcMPq3olJgm++swV7ucjNNB/U/k0Zj2sOm4ptsem
	EF11p6kWb87z4FptWgsnF5Ao/6JhIsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758025506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0pPuWp2BNu3NBcJM9vWn6dowI1JFSkBMrrb6aXFThBM=;
	b=YUA7UAwJWD7ZuDfq3lT1RWzfdIm/7UCuAlVF1tqdz9i1KBYrqtRI+UGWGe73YnyJfBDoMN
	5NAHnxD8uzJ9iLCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758025506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0pPuWp2BNu3NBcJM9vWn6dowI1JFSkBMrrb6aXFThBM=;
	b=DsNBnqnTs2enxmErYm/wr4REs1CvXeqhu7xasCeV5S4KexLsmkLhPyO5GM6q5ibEJaEfSB
	M+fMM8tMjmZIjA/iCS9JFEqa1xB0bFTcMPq3olJgm++swV7ucjNNB/U/k0Zj2sOm4ptsem
	EF11p6kWb87z4FptWgsnF5Ao/6JhIsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758025506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0pPuWp2BNu3NBcJM9vWn6dowI1JFSkBMrrb6aXFThBM=;
	b=YUA7UAwJWD7ZuDfq3lT1RWzfdIm/7UCuAlVF1tqdz9i1KBYrqtRI+UGWGe73YnyJfBDoMN
	5NAHnxD8uzJ9iLCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D52013A63;
	Tue, 16 Sep 2025 12:25:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3C3ZBiJXyWigeAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Sep 2025 12:25:06 +0000
Message-ID: <3cc1d02d-8145-4ae8-b76c-918debd7c7b7@suse.cz>
Date: Tue, 16 Sep 2025 14:25:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, shakeel.butt@linux.dev,
 mhocko@suse.com, bigeasy@linutronix.de, andrii@kernel.org, memxor@gmail.com,
 akpm@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org,
 hannes@cmpxchg.org
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <aMlDI_uu8_UZSzlm@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aMlDI_uu8_UZSzlm@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bjsagtgegwc5n7w7oadeuajoxekzuysm
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A99340002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758025507-36825
X-HE-Meta: U2FsdGVkX19UT+82G4AzKGZ/TZ133f1lF7G44ggKJmnChtNHa6rQVdGVOEM9xwfOCy/n1P1ExbzqBPsizfwSuF/rE0Ya99iJ16UCQ08vuHObG2q5dpVLQYhQVxnWfGihdQJ8uZYNaHWNz3pGmkXu8Cwtqyrt+3OWb/i/NrQGr4kT+MYov4thRpchBUfqPGlOmWeSRyvwG/UhAGjl6+QvVRzioURIHJ/BNeG6qdeGy5ix4/28vQMmQaOAzo44bwRtUgOdPcCAD9vaFR8mPtL9vds1IGZ7qd7k7l/JEZMr9J+vUDDlspZwRJ9OTwK4HZDNp7fTM5+OkLR/BZgwwpr0ztUNpYa+XTYpvD939E33Ods3E4shzrE7qPwVoA/mYGG3y01deDvKLgB2Za7OzRltnYuexv2eqYkrO7wrAzs39tDKUmZ8JztEMtKJApC10fHn8EuqHnteoFj8XISjO+JjNQzzlcZtoXg8acGwcDiyQdgAYmxB7ZA77KhdYbmyBDZ2EfmdQGboomXHupqs3zUHENxaRZijegY4yFUhSGWfcIWGzWEjPVaT9S59v5Rdg6TnRAsWt0AdPuI2ATx4PD6eczg0gz3i02jagF+XOCxmhGYb+RdKzOKPK8pyy5tyU40DqAcvr5kMXT9srcxdCSnFUosw9+4tMu196xYsx/YnFMloh77h9icv4ar9zRqeyU+ss+BFWlZpfWlOhUKZn8vAgE9GXfqAiFVU4tiggIqULysgv0Q7HxLl9dUYDrvymMGvx4IASERc2dDUsGBPcy+sttRxOnT9l8sAL41BOQCVtwnVhcn8gDpo25APJHMP7ZLgl+4iQdobMXISEmEpiHXHrpwIbpVMWJnkS4MFdzbVJn+Jii8awjyIEDotQ2i44sANti/b5NWfHt/CUEwAzx2kc7kSKBW1O52njudFOYl8ONaWhBWIdHtfGGaYoMOMIahZT5QWnabTHGiE0aQco/Q
 ct9JadFr
 55JWlDUuywGeXO6lUsJveUmXQdEqAQzIOyy/Cc0fSFkqWmr/U5TAX1xWEXxp2KmlUkuS31+zovIbI7vSTvE0izyIflASwkgLT39l0YPp1k0NIfydoQngcyF+r/5+gX3Hf96fDn+BmQ9v0zFAYGzQ60YpWrXDAAMZtRArkIZ/tCj1FF9HNmxJAo7SaC5bzTq0QiRtBUmtHDAj6Q55eaaCEJwvftYTrHiXF0j6z7bVbfyeIg6jsQHEx94wHWcTvqNsxbJAk43Xtnf60D+ZrhZj7rFUOk1vnMJ3fDzv7SdrIa1rDAQlktgmW+o/jR+uf0HX1xS45KnR4dlrtf2+oJsIrnQ73pO9IJqeLIStQdNAVaXntj4ZcetpmMk8ZEGDB3aTT0tr3guQ0wmonkGGAMzimdWO5gctwyFkGUT0tJoDHnS4nR4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/25 12:59, Harry Yoo wrote:
> On Mon, Sep 15, 2025 at 07:21:40PM -0700, Alexei Starovoitov wrote:
>> From: Alexei Starovoitov <ast@kernel.org>
>> 
>> Disallow kprobes in ___slab_alloc() to prevent reentrance:
>> kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
>> kprobe -> bpf -> kmalloc_nolock().
>> 
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> ---
> 
> Maybe I'm a bit paranoid, but should we also add this to
> all functions that ___slab_alloc() calls?

It should be enough to all that it calls under local_lock_cpu_slab().
AFAICS these are all trivial and inline. Maybe get_freelist() and the
functions it calls is more complex. Should we mark all that __always_inline
and would we be able to to rely on this? Or rather add the
NOKPROBE_SYMBOL()? (but it would be wrong if that turned the function to be
non-inlined).

