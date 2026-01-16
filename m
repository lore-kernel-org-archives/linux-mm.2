Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391BED47CDA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4EE6B0089; Fri, 16 Jan 2026 06:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CCC56B008A; Fri, 16 Jan 2026 06:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AADF6B0092; Fri, 16 Jan 2026 06:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5356B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:01:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCC921A05EE
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:01:28 +0000 (UTC)
X-FDA: 84337535856.15.7C2F88B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6EBC84001A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:01:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a9O3Gu2E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=meirtaGP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zCnkCSC+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AsD/sTNq";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768561286; a=rsa-sha256;
	cv=none;
	b=rl9wAyzzTXZXfF4PQramFBxfO7rNSJd7eRqq25RTGMQvSj89mcjl39BqFqGLl1f4k0zmTk
	4/gDsUefUvrzKKfL6516H33F/38MpPr1IspsiERPcyaxeL8+DW75+DRxKsWR5i54IwYm5z
	GzUsQw1oQ1QAUY/jcTG5DVvWpuwMx1E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a9O3Gu2E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=meirtaGP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zCnkCSC+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AsD/sTNq";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768561286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ku1XPwrP1SS53/mL1tvFmnSiaEKNhp384TKnyEmC8D4=;
	b=bUemMZX8TtEeHM8pm+iP/VfmZl9k8F+hHWPhssAZgzLSYsY5thbfBlfyZFEvql2+ZDS2+V
	MlRwTFWeWxcWrkhIqGje8eYi61eoiCo8BQZKmcjyhR4S6PNwy9hpz25E8AvI6B1zx4AdTf
	QDHdy38DAVBjLStod7Sp+MAo41Vqxno=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B84C33369C;
	Fri, 16 Jan 2026 11:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768561284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ku1XPwrP1SS53/mL1tvFmnSiaEKNhp384TKnyEmC8D4=;
	b=a9O3Gu2E44ymusWN6VfFQ9yQAVEG0wGx0IiD+6wPUZWoUYi2Vry1bSuL382dk3TZeip2Vw
	vKxCTA4NQFMxcL0FR0whpluaYMtgx/LTH3NUvWQ/9sEB9cc0+yHASJCtGoanCEf6Xc53PB
	7xR7TlFpvSBGngcVNwXJXXZ7UjiigHQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768561284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ku1XPwrP1SS53/mL1tvFmnSiaEKNhp384TKnyEmC8D4=;
	b=meirtaGP8WYSd6wXi6Q3AePnF0ALT5tlVM8cpmL2+y5Fa6THOtxWGQJPt1+hcE4Trz3QWu
	xdgiJJbTZaw0AVCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768561283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ku1XPwrP1SS53/mL1tvFmnSiaEKNhp384TKnyEmC8D4=;
	b=zCnkCSC+G4Hy2vlz71nczfSbtfdwB4nWmOAn4bCvdsOGt4N9/Xh1Od8leUWi6kW2kVanbc
	HvPccaxl03Qz9HUfx1diKuYVSIs0eLzKIelTTOoan0lrKE6weihLnaeyLzwVScW2UbdZf5
	ty/Bvi4MDZOVvcDCgRTGGZf5qfZJ+Ac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768561283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ku1XPwrP1SS53/mL1tvFmnSiaEKNhp384TKnyEmC8D4=;
	b=AsD/sTNqrler6kelsmwC/Bqg0Uru4O6WF8Csnveq6dhat4zHyqwV+Xd1rdZitiIbOLTQaG
	mMvx76vaVRnXTvCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E2843EA63;
	Fri, 16 Jan 2026 11:01:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EV4uIYMaamnwGQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 11:01:23 +0000
Message-ID: <bcfe8618-b547-49fb-97e8-e57c2fb4b7dd@suse.cz>
Date: Fri, 16 Jan 2026 12:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 03/20] mm/slab: make caches with sheaves mergeable
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
 <CAJuCfpHowLbqn7ex1COBTZBchhWFy=C3sgD0Uo=J-nKX+NYBvA@mail.gmail.com>
 <4e73da60-b58d-40bd-86ed-a0243967017b@suse.cz> <aWn67WZlfnqcWX46@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aWn67WZlfnqcWX46@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EBC84001A
X-Stat-Signature: h1zu4zf57xh543ysicps6dj3dk1rzg9e
X-Rspam-User: 
X-HE-Tag: 1768561286-884212
X-HE-Meta: U2FsdGVkX185kcRHshfJda+4Gy1GXF3VJ5k0Z5KFW1zyLOLsxwqhjpjhpx8p5GLhc8/qR4KjlYZZLPLHqpcni47Zs5bXO2sh+yEgiamOXPMwuPZHhvJVSh2B2ns+eZ2gJ2saVv62Lef0lBDisJX0MQ+TWtywpkdZEJtPwI5UJAtGb809BuEtN8IEydvpGYDY1AC4QKtG+iXc04vbVUCM5EvyFXecAU16xr53dPhDN8P6q7hrWW8sfEuAduNKPkTVBkFAclCourvTq7/PkFVeMTatZ31CCV0s9Rncwz4HxMfD0d8iZf4LWq5Hnceo+Moo5QSSRR4LOO3IHG4pbi5G/PgMJFQT7PRqswP+rqavDgTRimykE3yYvq1SE5mFzdw69QJFBQ6AojE0MiBCPLXwors6uTHeFBPpZQD/wIKXmw3KrAwMq18vuahHyE2BJKF7rzvpRW61QrglyAjwAQVZuwScBpg/i6MpEyuRonwJIn2KmlyCtKdwwIanrqOX66GeOeGlptU6MZlHOpBILGVHDxytgR3WMWhSsMTiVZ/DbyevBNSnzTRIgp1cbzNE1o9B1UYLtV0WiFAGvF65Cl4AilQcU+UyKkd4oO9fVyuQ7EIoAnzcaqBVlzctR8hdq6HUM6uoDKchZ5usfXMCnulSOQ2a5Sq4tf1ifrii5LXXEA7wPdceQxbQwRnKprLMLHFPyti02wA55VYmJeNJcaF05gsj651Sx/RRqX7q2+nLYo9366yMPwTxGc4GS1bXettq3YMo1uqiJp0ETEccmV78pnKsT0vDA9JDhSpZDqhSWCj7eFvUuxW5KqeT1TpupIA3lroTHuw0nMEknUTcN5UHDiv40u9q2XF+LJcOjpSefi/vuQ8Mt5elJRX7dFLlZyXYO8iBn+H66hy5Uw2KR34iUcSAtkB68EETOp7/BitLoiVPNVBU+hnIBz+LqT78pdOhTzIkv6pKY+ywFfvE7EW
 wfaflkkv
 reaL7HGuWrKnF2KTJ+ygI5K6MkQuxJmu0VvcB44r058SZR6lUP1btLmZqeg/pT5ZKL1G5FLTqtw7oVU06xyX7oPRc9owB0WPl0CVAY71kYUHPYRbzqGvjymvhqAYuNpCiqrNceBHt0ip0XQcgjIEHar6YmMj5PeBug5uCZ3FwgiZn94X7QKRT4bEhErzkE0iGtomvJjHnJy3I+FrAIm/nh8PXUPMd/E0YRS/zOrAdJsXd6mWx33Xrm2DxKTuhllXIjxeb+lUbMAFAqVI2pLNk10m7Q4klFqIseCjRCTy/v6fYIXScJH8MRBJNUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 09:46, Harry Yoo wrote:
> On Fri, Jan 16, 2026 at 08:24:02AM +0100, Vlastimil Babka wrote:
>> On 1/16/26 01:22, Suren Baghdasaryan wrote:
>> > On Mon, Jan 12, 2026 at 3:17 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>> >> @@ -337,6 +331,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>> >>         flags &= ~SLAB_DEBUG_FLAGS;
>> >>  #endif
>> >>
>> >> +       /*
>> >> +        * Caches with specific capacity are special enough. It's simpler to
>> >> +        * make them unmergeable.
>> >> +        */
>> >> +       if (args->sheaf_capacity)
>> >> +               flags |= SLAB_NO_MERGE;
>> > 
>> > So, this is very subtle and maybe not that important but the comment
>> > for kmem_cache_args.sheaf_capacity claims "When slub_debug is enabled
>> > for the cache, the sheaf_capacity argument is ignored.". With this
>> > change this argument is not completely ignored anymore... It sets
>> > SLAB_NO_MERGE even if slub_debug is enabled, doesn't it?
>> 
>> True, but the various debug flags set by slub_debug also prevent merging so
>> it doesn't change the outcome.
> 
> nit: except for slub_debug=F (SLAB_CONSISTENCY_CHECKS), since it doesn't
> prevent merging (it's in SLAB_DEBUG_FLAGS but not in SLAB_NEVER_MERGE).

Hm right. But I think that's wrong then and it should be there.
SLAB_CONSISTENCY_CHECKS is enough to stop using the fastpaths (both
before/after sheaves) so it should be a reason not to merge.

