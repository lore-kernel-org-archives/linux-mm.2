Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1405CAC58F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9C48E000F; Mon, 15 Sep 2025 03:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A918E0001; Mon, 15 Sep 2025 03:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D323F8E000F; Mon, 15 Sep 2025 03:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C02C08E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:51:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7358CC04AC
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:51:26 +0000 (UTC)
X-FDA: 83890714572.03.D2C93A7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id C639640011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:51:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TMyhhUjH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A4A26eiB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TMyhhUjH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A4A26eiB;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757922684; a=rsa-sha256;
	cv=none;
	b=qpeA73touqOkSFMed7E08dbzU6L8GfTnZdgoMhUgMp6q+kyNyRppkEgILsDKwCbRkWWS5I
	PBCYqxF+YsAAx9biXrMHZPC8U4v9/Ez4jP/YGOL7AGQq+eftz0U3ZwTD/fViZNbGlP6bk8
	6tBB8PvMKx3f5iQXNhbJ9qmQE6Oht/w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TMyhhUjH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A4A26eiB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TMyhhUjH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A4A26eiB;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757922684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1II8JwH5N5skoHHG9OMK3O2Q+vtcUlDHwhtvu+iE+c=;
	b=sEDKZKNw1X6aPe0turfxcIb8zDBhaD6+oABCpE0qhkfUJ76THS+aHC6QSTP9+ZEXlh+9JF
	VTyt/Js8vFx8gg6GU9Qdy8p91bTx0B+chJdXOzwm59Vi9dXOPSkNzBW/lo8+xNw2dpqNFb
	nQBTVH52ORo2gj/5bcYEPenvd9mfYtU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 483491F7EC;
	Mon, 15 Sep 2025 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757922682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1II8JwH5N5skoHHG9OMK3O2Q+vtcUlDHwhtvu+iE+c=;
	b=TMyhhUjHZ07q8NdOAHO1mMhPm0o0xuvPgjneWVFebHZVB/P7V8SejIG+Lvl/Wh/jmbOihP
	g11QC9dnhUjp7aQWdHqtMlNp74Y3jZ/EVsrLBXj3gyvcX/mDaJPaTcZz7zLMZEJMqHB1of
	0xcrH7eRY7RpgfRwoAo3vUi0TLsBPvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757922682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1II8JwH5N5skoHHG9OMK3O2Q+vtcUlDHwhtvu+iE+c=;
	b=A4A26eiBz+CksO/yp2GEOsBLuM8+5V7UBmmhUEF2bjkYk6Y5UE2sdOqAdKWrAgRmS65pos
	QDDe0VGxgctyOaAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757922682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1II8JwH5N5skoHHG9OMK3O2Q+vtcUlDHwhtvu+iE+c=;
	b=TMyhhUjHZ07q8NdOAHO1mMhPm0o0xuvPgjneWVFebHZVB/P7V8SejIG+Lvl/Wh/jmbOihP
	g11QC9dnhUjp7aQWdHqtMlNp74Y3jZ/EVsrLBXj3gyvcX/mDaJPaTcZz7zLMZEJMqHB1of
	0xcrH7eRY7RpgfRwoAo3vUi0TLsBPvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757922682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1II8JwH5N5skoHHG9OMK3O2Q+vtcUlDHwhtvu+iE+c=;
	b=A4A26eiBz+CksO/yp2GEOsBLuM8+5V7UBmmhUEF2bjkYk6Y5UE2sdOqAdKWrAgRmS65pos
	QDDe0VGxgctyOaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26FA51368D;
	Mon, 15 Sep 2025 07:51:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pUmEB3rFx2h3WwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 07:51:22 +0000
Message-ID: <e166705a-e838-4c8f-a8cf-64913e120caa@suse.cz>
Date: Mon, 15 Sep 2025 09:51:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, bpf <bpf@vger.kernel.org>,
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
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQJQo6+AwJ_LxARVu37J-5T-7tyn1kA5hMVDGDfEyjF6mQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C639640011
X-Stat-Signature: twsga5jcn9ostn1o4sw61hu86ka5pxu3
X-Rspam-User: 
X-HE-Tag: 1757922683-727526
X-HE-Meta: U2FsdGVkX1/dav5FyaO9zAIOrR+ExRb+9JC/cGPapRDplYvnvjW/hBwCYEVHG4zUsXYOCTbETmMmm8pZxgUuz34spFgBD6KMyG72k+LZj95nuarZSV6mHPOsxxV6GTmtwbUQl489C/GDCbnkFEWEQgzCLvsLrvQj+/iuj+3fNko1ey3mLMOoSZWDJVofwt44mcPh4VaF0LRjITuRf8kHYlCQ8HgOnlwRTmUTn0kzLlDADjZ9LBqHN91t8u+8Ktbc4kTYiLLeUrYV84awu2p60RnBrIbXuUPFhsJBFhK+UpVipvGqe1+55AdaoEiZldr1LYoQcsfMLL40kMSm/uQf949XjGcbQ1HakKncNJbr4OKmz/oKr9YFPTVEP0vNyTL7qCFXHWCdWq+NBxElpztC2SAiN4iUSLSDa1GkyPcAO0h8n+ohEcmg5RQwb6za51s9AAK/915pKPURy05zKlGtZsqYH7l7Gke/LEnzTBk4dV/Qaa4iqyS5yHNY1v33yT233yQv48WMcNBLPPv8Ts/DiB/ZFk/kf/OQqnuveSh9VMSm/lgMKCMDXHORdAl899XIUCNzzfCXdGTmqgeqTpiCg++wjHbjJE1HeOLnYp2zoSUxDhDJe75CSQnXLUhzJwGUMGK77hlPd+tLYWmN5zvmmdQzGk/hx8Y0SUkFLyDY0fWy1UyvFXPRG684EOQCCn992kQYtD71vZZSXkz2EKSxVihKC4lnRCsTVYz/YEZpcJaGct8xTpE9zesJqrifNmrTAJRKhfUXexIGSSR/w4YS09z4hiYy1fjDg2L6sc1D7K7Mn24eMKUFxsKQ5eN53o21RBstwmYdgggP2004YuDgoLrhI5LDpr3saHGLrF2i5V8xyL4xK2+Bfq9XWZmFRSlToPFbeMocsGMTb4qvKgRtbKDTEw321Fw21Ee9OOZYnd74zdiQseyNmPwgKI1/3J2b2el0Hm5/mK5ydH8KTnA
 wwoRReGO
 CsDXO5tne56gnCm68B2wR0rq3CDQ43SnHnVMLOjrHb3I25l5b+e0k+j5/9lGjA94fvkoyZANH5w0HM0W9pt2GbzTxchvTpBRNT+KvdzXXbCHAC35dxSvSEiNAaED7qyN1mhK/Ec5dqKq2w2yK9rA8pmDLjfE/wHTa57sovOZ6ndx0PWBpuaQdZh4Zrtg7tEeNy4PUsS8V0br4QCZHxAz59wdHGzbcgP12z7r4SgaaV574/nXPUV7PhWarBrUwX4PxT99tHSGdA8D4BJ0CGnVSKP/VgovRRRqxtmIJEV1cL91gu36exAzJ33dHkkrj1lFmfNFPFZqxN4Sv4pn9RLZyI3DVtaIh/7iD/CYx3WMkN05aKjTcvYl69fqI2zIuE25lLKiWCBI2htBRACoG5f0Ws6lG8mglGFE1BhHjXi1LK+UwJ+oBHyUutSOrG9YLKYdjmnG9H0nR2zJ5z7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/25 03:12, Alexei Starovoitov wrote:
> On Fri, Sep 12, 2025 at 5:36 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> > > > Suren is
>> > > > fixing the condition of VM_BUG_ON_PAGE() in slab_obj_exts(). With this
>> > > > patch, I think, that condition will need to be changed again.
>> > >
>> > > That's orthogonal and I'm not convinced it's correct.
>> > > slab_obj_exts() is doing the right thing. afaict.
>> >
>> > Currently we have
>> >
>> > VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS))
>> >
>> > but it should be (before your patch) something like:
>> >
>> > VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL)))
>> >
>> > After your patch, hmmm, the previous one would be right again and the
>> > newer one will be the same as the previous due to aliasing. This patch
>> > doesn't need to touch that VM_BUG. Older kernels will need to move to
>> > the second condition though.
>>
>> Correct. Currently slab_obj_exts() will issue a warning when (obj_exts
>> == OBJEXTS_ALLOC_FAIL), which is a perfectly valid state indicating
>> that previous allocation of the vector failed due to memory
>> exhaustion. Changing that warning to:
>>
>> VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS |
>> OBJEXTS_ALLOC_FAIL)))
>>
>> will correctly avoid this warning and after your change will still
>> work. (MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL) when
>> (MEMCG_DATA_OBJEXTS == OBJEXTS_ALLOC_FAIL) is technically unnecessary
>> but is good for documenting the conditions we are checking.
> 
> I see what you mean. I feel the comment in slab_obj_exts()
> that explains all that would be better long term than decipher
> from C code. Both are fine, I guess.

I guess perhaps both, having "(MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL)" in
the code (to discover where OBJEXTS_ALLOC_FAIL is important to consider, in
case the flag layout changes again), and a comment explaining what's going on.

Shakeel or Suren, will you sent the fix, including Fixes: ? I can put in
ahead of this series with cc stable in slab/for-next and it shouldn't affect
the series.

