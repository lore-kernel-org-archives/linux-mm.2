Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009ECC88E78
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 08:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673ED6B0088; Mon, 26 Jan 2026 03:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6221E6B0089; Mon, 26 Jan 2026 03:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9B16B008A; Mon, 26 Jan 2026 03:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB4E6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:39:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D709EBAEB0
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:39:26 +0000 (UTC)
X-FDA: 84373465932.30.FD689D8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 65A8218000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:39:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t/waB+j2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KAJM9FFC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CSkTefY0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ay+WlyzK;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769416764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8apTRjaXyVloWrbPyJGXpF6txJlbz3ZAwUoAcFkvk4=;
	b=MKE7pMg0DYfXbjWmNkSLi1nQjXsvJglXKQQqrrnDSWxwB2uR0q636dA+FnLxWYDOzgsE3t
	jbaqqieIXui8EkwopV11D3ltjlZvPjKX+QHscbiRdVnT+q03346Ir4FDWSAbiVWTdxBqBz
	Z3r/bL580h2KDMADMFqyQQQrp9Lr0cc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769416764; a=rsa-sha256;
	cv=none;
	b=vs0DAbAarYn7RE5eIvO7Id+5D9zJHpziLFVbfxfB+nSK6VROYwBcRC6LgEu/B5qLG+H3nk
	s3cYU0446RAdJI92NyVe505ynJU+hajis5MgJmJWKmkhooK5F2kkm0ESGgIhLxmq03KM78
	QZ+jAuZ9kjXBAOlbwCCvp9aVv6KOqfQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t/waB+j2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KAJM9FFC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CSkTefY0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ay+WlyzK;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CCB9336CE;
	Mon, 26 Jan 2026 08:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769416762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C8apTRjaXyVloWrbPyJGXpF6txJlbz3ZAwUoAcFkvk4=;
	b=t/waB+j2ugV/tWl5MMCbqMEiDGV2/8OWeqP1lMsNsoyr7XYYrabD1q63Qrt+YzS/xntYLp
	uqmzDOPOpm4CcZpVQTNKq5eY6EpB5060+fNL85HPvmq6O/jedg8OixvM0LNGk3qv8sHqNT
	oiAExgQgiqLT7+XZ92wosPyJHoqtieg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769416762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C8apTRjaXyVloWrbPyJGXpF6txJlbz3ZAwUoAcFkvk4=;
	b=KAJM9FFCbjI3pCIjlEWM4MdjpYMCIfm/y9cM/AqSHhRHzFZ7xEt7yu59sjIHqNuundCHvW
	qGYN2b6wDG+kQ6Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769416761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C8apTRjaXyVloWrbPyJGXpF6txJlbz3ZAwUoAcFkvk4=;
	b=CSkTefY0MtsKYl/YIoaFrr3CrzzcmiqngjVEdMT0IfdKG8vyVRZP11B/IWxSeS/9wUGSK/
	fwoQkmi9GlscBcA2n9l8MidPVBEZxmGVCAJVm2lDx2tQMapyA2El+/50h2DC0AL32XEuTM
	Oin6fzOlpiijum3Q7CzT/Smxqy2Ydjw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769416761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C8apTRjaXyVloWrbPyJGXpF6txJlbz3ZAwUoAcFkvk4=;
	b=Ay+WlyzKYc6OzkOkBiej4kLCmNO4otuwfsO4hlMvmj2poBFHgU950+6yktW12kS1VkJH/U
	BY/VJOSO/yGv8KAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 729C6139F0;
	Mon, 26 Jan 2026 08:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XSH7Gjkod2kQJwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 08:39:21 +0000
Message-ID: <ff10180f-0b9e-43c0-93ff-b421ff1454c6@suse.cz>
Date: Mon, 26 Jan 2026 09:39:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
 <7tds765fsicczreeqckiuwpny2tolotfrnbz6jhpjrch6x5pg3@5irfwnohvsli>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <7tds765fsicczreeqckiuwpny2tolotfrnbz6jhpjrch6x5pg3@5irfwnohvsli>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 65A8218000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nrfcp6feq3qxij3jkskgm65secrtbm8b
X-HE-Tag: 1769416764-368161
X-HE-Meta: U2FsdGVkX1+Sc+r8sD/DrT9FgAtoKy03S1joSbP25wLZ7088Cc6Bn4V0CW8hdurG70GoCs7pMNwigc7mak0h7O7czWyxkUX/2IjSFUBK50wgl++JzHoMoDLqTklpSvGhau80AJ79ilH9vib95Vkmqdozm03jU2eI5iwu/hxD4LGy+/u3pwn9Vyyd2GpzF3Wb2Oc937G0txAXWAEA1DKmIQ4heyEfa75vlQlGr7oKtUEsv/+9GJ8qt4fYrEEhtkjdK7UXS7lFNx/2qREPFs5ZUdMkWUO0p5bv6PTno4lHYC8VaKh/FbVHz+5Fc07+RMW4fTWeBFabVaT7bOdIT94IwsLj4wasc7aKwujCgrZFZbiZow5DuQvxcrf8/ojs76IB2tpJMpNgdazNju3jZNXxcz651r3s3OV+Ecrz4lNs/HzkeKJUVdWeC10+5vezBHB/6ViE/sYK8iq8XqexaRE+Jl84jukllO1HK8DpUTSgSh/dMA/aknWFWXT8fr+PpvXOeR50FLfvDLbUDGW7sNAiy/Xa5xWeWCSpFb1gUMmFT0OGRlMjGzDafA1L8nnC0Vo18aPV35kNkviY7c/zKu0RgzWyAw6S2da+DrW+bkm5Ptdc9KUoCnkTQWCmyqs+CMk2YKfQU1Wyh+LrtmtnGo128G7QzFIUxkmGYnPsYN5vE8Zd9pAxkSKbYfcMqL0WoeiMpf3770f9sSZbvA4tZFVQ7/x2fzIirCgb/wX5bTMyP/z2W9U27EHBCbpHnpTDdCi+IZS97ORhtzTK5SopBfUpYYeqLaur9wkTY1VfeN17n4oyQX5i6wjWg6P9fvJ8SQsyrG7egjC/BGSIqsmWxmLt2VwnpA711jThGT36qc79iSQxsSCQM+0fA/t1UgFfJ8affsr4+5q69aFQj4Jj6lQePIg8DFQ5R91NtiZjbwO6j3uXCMfPZAEeVaMyVPfgiLIuZTKx2l/Ag7PBYuQHUTr
 xdrkNTPW
 c0YBZnLoSb17fe+S+MV8LemUq3L45JeWCLHoiI+zrmrgqlwC9hQsIMvns2elTWAsorSjOAxFVvgnB0utUwERTiXDWOceX32Vt8vvJTWWXok3NI8Z6h9xwXtBiWukYpRbIoREG/KKHcJDXGab+NHE5oveBDQN+bemiPGig++BEcWbiujSXnthQb+rO7Xi1vxu/xN8aYZKH10Tqz5Sh9yvjsBwWxk1Hb1x32vI7qZ6lhsWlHw7ocGAq1z4nuOkqsXzgAVGp2/cBwqJijuAAivboeP0aMGPyxZzhOIDrS2ZEkwxBuijN0bP8i+my/I+qzcIOLHS23GNK/s3HQdiswkjhsg1cgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 07:36, Hao Li wrote:
> On Fri, Jan 23, 2026 at 07:52:44AM +0100, Vlastimil Babka wrote:
>> In the first step to replace cpu (partial) slabs with sheaves, enable
>> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
>> and calculate sheaf capacity with a formula that roughly follows the
>> formula for number of objects in cpu partial slabs in set_cpu_partial().
>> 
>> This should achieve roughly similar contention on the barn spin lock as
>> there's currently for node list_lock without sheaves, to make
>> benchmarking results comparable. It can be further tuned later.
>> 
>> Don't enable sheaves for bootstrap caches as that wouldn't work. In
>> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
>> even for !CONFIG_SLAB_OBJ_EXT.
>> 
>> This limitation will be lifted for kmalloc caches after the necessary
>> bootstrapping changes.
>> 
>> Also do not enable sheaves for SLAB_NOLEAKTRACE caches to avoid
>> recursion with kmemleak tracking (thanks to Breno Leitao).
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Also, looks good to me.
> 
> As a side node, while looking into the test results reported by Zhao Liu [1], I
> ran a quick test of the current patchset with the will-it-scale mmap2 workload.
> In my runs, tuning capacity up or down did indeed have a noticeable impact on
> performance. Hopefully we can make this tuning even smarter in follow-up work.

Right, thanks for checking that.

> [1] https://lore.kernel.org/linux-mm/aWi9nAbIkTfYFoMM@intel.com/
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!


