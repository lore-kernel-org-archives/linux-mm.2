Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B88CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63EE08E0024; Mon, 15 Sep 2025 11:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF828E0001; Mon, 15 Sep 2025 11:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6F18E0024; Mon, 15 Sep 2025 11:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 371C18E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:11:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16C38BA235
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:11:07 +0000 (UTC)
X-FDA: 83891822574.09.437B3A5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8765E180016
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:11:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hoxW3BUA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zBlcqtLn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nRdO194U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o2m1P6fj;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757949064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p72R/ETpcEsOcIKQa1GrSL0CC8AcpAY1+Kw5v1KsfV8=;
	b=NDDWCxN8lbKYWNElKX+E97yNSNshFdKfaSrZvW2QOaMfpXo9vIaIeSHXHCED5KTicTc3An
	0eAl64glssszWEchxVLTipdsNv0KoKAr9Dm9CwZP2KajvBKgMWowTczIwsZmH/Nk258V7m
	APHu+TurmNOYeDxcgHDyqfyv+I6DqD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757949064; a=rsa-sha256;
	cv=none;
	b=2n++Vm6R5fy4fBrq8OMM7rkltdCCK8dZnvLAXzfcekKwAWk/zD4pyjzp6Espmn285I96gm
	qaaJJ4dTTzFfNbZyhbg54/OOqMIPlRj30zguiDaTBgUJWgd3eOOVL+Dq36Ff0ppbwdTG9l
	QlMFIUMleLMF7ZR/3qmVBFpIBfUlza0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hoxW3BUA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zBlcqtLn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nRdO194U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o2m1P6fj;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D760A1F7C8;
	Mon, 15 Sep 2025 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757949063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p72R/ETpcEsOcIKQa1GrSL0CC8AcpAY1+Kw5v1KsfV8=;
	b=hoxW3BUA6Ss/5b+z44dY44anCiRaKAhZdEKWlbdj1726UaTmzEbjMY1BqDNx2UUSHLBdBT
	mlDm60pQZLYaUP2aJvaui9uN6wA00N5piQ8w0JFsRMi2WMGVdSh75KB3s1aqz3El9+XHlR
	Z1KS4PfLtDhHXDYir1P4TEd5NJTfSdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757949063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p72R/ETpcEsOcIKQa1GrSL0CC8AcpAY1+Kw5v1KsfV8=;
	b=zBlcqtLn9AG1+Z903BJDuPjJCUgaIcL8t9vicGwZ2pfWIg0k1lgI4PqyT+WuuQuRYuvWwW
	Izc5s0cf3/OC71BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757949062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p72R/ETpcEsOcIKQa1GrSL0CC8AcpAY1+Kw5v1KsfV8=;
	b=nRdO194UaI3NDXAFg6AMzN9WVTyLkS7kiyWIpSRLShY3Kcqk/pQfxMHPjD+JwmtoPgYKLB
	Fc/YCYZjmsKUKv+TUi+ymwqAg6VY92npoehhbCQYNJsMVizHefrBDd44ADL6AL4ZXZ3Br7
	O03sxP+cnMXkwmeN9THwLChhu7Cl1TU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757949062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p72R/ETpcEsOcIKQa1GrSL0CC8AcpAY1+Kw5v1KsfV8=;
	b=o2m1P6fjRvc6oje295gpCiYySRavFhL+9Hneps/DC7c7YXHXT2kQSqiGK5JigabXYN9zYD
	6cHJDXmGFSk6bkAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B92AD1368D;
	Mon, 15 Sep 2025 15:11:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ULXQLIYsyGg9cAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 15:11:02 +0000
Message-ID: <75bc0c27-3d08-484d-9d22-59bc70f7ee1d@suse.cz>
Date: Mon, 15 Sep 2025 17:11:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, Harry Yoo <harry.yoo@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>,
 Andrii Nakryiko <andrii@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
 <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
 <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
 <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x>
 <CAJuCfpHJEUypV2HWRHqE598kr-1Nz_DokMz_UgrUnq8YkFcb9w@mail.gmail.com>
 <CAADnVQJQo6+AwJ_LxARVu37J-5T-7tyn1kA5hMVDGDfEyjF6mQ@mail.gmail.com>
 <e166705a-e838-4c8f-a8cf-64913e120caa@suse.cz>
 <CAJuCfpGR2tHhUu=p4X2YKPNot4TJbhuFPRiT8BgOHvtcw=j-Ug@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpGR2tHhUu=p4X2YKPNot4TJbhuFPRiT8BgOHvtcw=j-Ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8765E180016
X-Stat-Signature: 9moue9d9ake6crz9hruyebhk84wjx6ki
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757949064-850202
X-HE-Meta: U2FsdGVkX19pwwXDioNUJRE+BOlSHNLXas7ba9iTnLFRIoWYvDtLcbmBir/xLKFL6uoqEVzbPEK6lhXf7F32OV2on7R80sAz7Rxrzo7xzEaAVFGrYbtLuz5v9EctZW0Q5kuK4YpLBmnBjWyyK7BDSr9t0TRldwvfVil/8XJSJXbgCQ2UW+7wlsi6MYXd0Iv1Fo2St83NU/mdc82bxLS0f9aU+nZiaPsEuRvWtPbG1krEBNPweT/GXXsSrPzod64aK2WbQxVS2n1kQVrxsaFf0CotVbcLDF28w5an68w3D+JtyQ2GdBl8pXi8gXaGgP+MT3uVWD7DgyP9ebixJ851gTWygZZTUWoRlKntfp+aVBzWOCYrr63LXGcyQBJJANzWt+Ptj322CAisXL2dKpGmvkRoy9fRFh7q0iQZZc1hUfnwyvpUe6ymrtWPR1oPGyX8QW1hNnudzs9UVGelVLgsCmgIOEFqoZwiXca8xQp4uTu1/7hhRWjMR/dQnUgtBh5H4Rvwa3Krt53scjAZmWOC8aAnkhqCT2eCZsNfo+2m3mY4RjL06I8x77yWvBtAxF+W3QHbr7infE+nRRJqXj6vJIYh35U7F1OZo0wevsRbp/tpwVu9NKT/lVZ9tjyx/kXhAy+6+o9fDLhrYla7vhuoFnFtUxpfBC8EDaa3bjwhfZQZTa7eFwBpKvYRZD36jNLMStCwXszh1CHKOWGvJZWnE1obcAHKt1UVLLVGH9Ev8mXpyhcS4Tb8qzwqm+jFvl02kkOewJUp9orXox9EBD6gxphC7r531TxlP4IVxYYEqHhHwxykRDB8+OK9hZfURphB8UQG9KQSE7U7pfwb0wVGu2Rm69sdCEnzsBmnQHZb8o+Yy9X3CAodeNftEp9bir/7Z6K/I4yrodtm3/sSnauPiRhbTXQ5Raumdxgo4olg/6LYLgEE+NosLvoL1QZ8MH7aIAsvEQoeMt1t+Y9u+4F
 5vjiBNMs
 oHDYg+fAoKzOVm+B09ZBrUAylI6rjqF0ynKtxM5jFdo4i6/odpFfxXCK1xo08gkEKR63Xux6WYjkeoi2uY8EZHKMYBOhZfhtmMDcQ3AFN3dsak7UcqlpD3M4tS9dmRmX1qbIx7Jv3RIeC2Ih9zpiorR9ZOmbqIhdI7ds+rT8tFoQ7NdEquL+YEf72VYKhlbVQBfBkGgXehfGkB7qEsNA3+DRvn2/KukR6ehJmEYK8a0yuDiT/n9Z/L5vc1J6uLDu0W1gIfzAqAp6HpE5JwWGjLsCYrXEQW51zJ+8BDT2SU2C12o8ReI/76HyEx0qkInglDe4JIRwDciq9ptODupvDJJ6F5NHu3v7MJRI6TF5dxmF/Vrah3N/rfRgE89GQm1BNr5MHWJkK8h2rUhNBTfeXOS++JbpgyqkSn/uaNDXl2DBXHh2ePZGo3aR2DkXy9jzjVpG/0zc0/g86YdxU91YW8LnFYtq361gvERWx7m98FRcXkFcyvfmzaoeirGltQI9Dtn/KOg4GO+K+jmElEBIgIoHbZIvXA9GcfoIXVz1t7wwu0PH+Zjbe8+pRiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/25 17:06, Suren Baghdasaryan wrote:
> On Mon, Sep 15, 2025 at 12:51 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>>
>> Shakeel or Suren, will you sent the fix, including Fixes: ? I can put in
>> ahead of this series with cc stable in slab/for-next and it shouldn't affect
>> the series.
> 
> I will post it today. I was planning to include it as a resping of the
> fixup patchset [1] but if you prefer it separately I can do that too.
> Please let me know your preference.

I think it will be better for patches touching slab (only) to be separate,
to avoid conflict potential. [1] seems mm tree material

> Another fixup patch I'll be adding is the removal of the `if
> (new_slab)` condition for doing mark_failed_objexts_alloc() inside
> alloc_slab_obj_exts() [2].

Ack, then it's 2 patches for slab :)

Thanks,
Vlastimil

> [1] https://lore.kernel.org/all/20250909233409.1013367-1-surenb@google.com/
> [2] https://elixir.bootlin.com/linux/v6.16.5/source/mm/slub.c#L1996


