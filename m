Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B767CC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CABF8E0002; Thu,  7 Aug 2025 06:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379BC8E0001; Thu,  7 Aug 2025 06:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241C58E0002; Thu,  7 Aug 2025 06:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1198C8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:48:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B64F6B6994
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:48:47 +0000 (UTC)
X-FDA: 83749638294.27.ED35CFC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 500E7180006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:48:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zUpKvsAd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OCqAfUS8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zUpKvsAd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OCqAfUS8;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754563725; a=rsa-sha256;
	cv=none;
	b=DuX2vIMb4aVympDykblAXDeqm7rw1xzo/KiHm4fBk1OGZvSrMlpzbWK+eCltjE/XIzXAUE
	PtM3JH/vlf9L+tdjOlIF18Lm/DMNk0zpUnpGMKNV+C3L2lEi2n9ThJqTRbikE8y1mDmw/V
	JFkMQRymkroo2/TpRt4Jsjv2BLoPfmw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zUpKvsAd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OCqAfUS8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zUpKvsAd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OCqAfUS8;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754563725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlKy82/Fd/DACmJueXeq1pHVlADct9qz8hQPevvcNX4=;
	b=eAyki7kgMmUGJgUNgSHk9BpNgLoMt44R6SRtYysa9v+H9cUOxBfR4Ad3UAwB/lbAL1vY41
	tjaV9+MI/w1vJhz7h11fpTL+RvdIGg6JQtClznCvtUz26UISICJeS+0nEXhcSRAKwJJtd2
	1BhTRIL3c3BoUJOPvRw3+t2/yuJ2X7I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C780A33D0B;
	Thu,  7 Aug 2025 10:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754563723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YlKy82/Fd/DACmJueXeq1pHVlADct9qz8hQPevvcNX4=;
	b=zUpKvsAdpFFAm5GaSxEKG04pLxEmqsRn1b77wwSPcW69YIdLKGh/OtseNS8kNFNDImPw4I
	wktv9ue4xusNVfygaIWOaMPUbsqBzvPa7Xu8jMiNeLHATGducwwJlMkVjfBojvnSSkUvaw
	0MAUC9jN2+j2qQkGwAXBc1+X0vkAcpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754563723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YlKy82/Fd/DACmJueXeq1pHVlADct9qz8hQPevvcNX4=;
	b=OCqAfUS8UqaVcqzXcwGFBvJ6e+IlFF04xgTmriR6yd7Z4WfUcEpbiBKIGBogPOb7nVKVZx
	3/IrHYYl9xkAarDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754563723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YlKy82/Fd/DACmJueXeq1pHVlADct9qz8hQPevvcNX4=;
	b=zUpKvsAdpFFAm5GaSxEKG04pLxEmqsRn1b77wwSPcW69YIdLKGh/OtseNS8kNFNDImPw4I
	wktv9ue4xusNVfygaIWOaMPUbsqBzvPa7Xu8jMiNeLHATGducwwJlMkVjfBojvnSSkUvaw
	0MAUC9jN2+j2qQkGwAXBc1+X0vkAcpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754563723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YlKy82/Fd/DACmJueXeq1pHVlADct9qz8hQPevvcNX4=;
	b=OCqAfUS8UqaVcqzXcwGFBvJ6e+IlFF04xgTmriR6yd7Z4WfUcEpbiBKIGBogPOb7nVKVZx
	3/IrHYYl9xkAarDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB70B136DC;
	Thu,  7 Aug 2025 10:48:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QS0CKIuElGh3VAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 07 Aug 2025 10:48:43 +0000
Message-ID: <33275585-f2db-4779-89f0-3ae24b455a67@suse.cz>
Date: Thu, 7 Aug 2025 12:48:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Realtime threads delayed due to kcompactd0
Content-Language: en-US
To: Alexander Krabler <Alexander.Krabler@kuka.com>,
 Frank van der Linden <fvdl@google.com>, Mike Galbraith <efault@gmx.de>,
 Hugh Dickins <hughd@google.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Dennis Schimmel <Dennis.Schimmel@kuka.com>,
 Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
 <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz>
 <DU0PR01MB10385C08C119276D99A234D978226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DU0PR01MB10385C08C119276D99A234D978226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 500E7180006
X-Stat-Signature: nta83nek77xny8xt9j3zz6sqhbidr9ui
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754563725-741099
X-HE-Meta: U2FsdGVkX18BnvPIBPHAWvEa7VZsbq1x54jxFZjjl0T7mp5sc3hveYAp6InjKU7zjCTHtIokMuDZRu0JylJXqTxFrneSgyiZ4+FdZxLzbdRxgFyhSnrI/FcdiCfMIih4/nR+WFcc9izgnTFvTQyYLC4lgB6jvDqaTxMBoa40VQ2fjtjHNdapDZlUuOxbBwZ240pMgXPFnD3lS6TLzNT8xioqiUp+qV1b95w4cmIA4qDW/LkD9rcEb6/g/tZbbgF3kjXJJqhu7APhFsBinLfKv7fUkVW3y0ooccYc8kViZPtcNH5BVWW/XOEgWIqi8PURQOvR3eRTSYXhafGdXgUUf0gblDNXf0s3mmODRvfvtOWZpfXBqvi7tXiW5mhNNjeEFMVU5jtS6p2z2ZlwMs335Dn0EaP1k36n9OF16+uWZXEkk1iWKs0GIBdd/vBcWeYrfffPuLZbGA+rpY0351Mcl/NEn8sIrEkv9QqoieMN+0tpvF4hNrECr6E6622ImtMup3iMIOSdQULnMjx8fzz/dKVpce/GBk40O336uJ7iyek73ToNKNt0XALMpDeGEGxs/TOS6aOiF/IK6GcV5JgKMs9PHwCi9GANWxbVVuu0KSvVp1YxJX4QW7eIMVqojQkzpXy6YvaJmAKrkDf10cQa4EuQF+dRt5Vm2xcbhlzCE8PiLUb4O6wVQ/5cHIYU4ZG8t4ZMvqAQiYs7c6+F9agqXsjqIxqZjlOGAi/PPix0aITBVBVIV+7d+w5dJRze0iT7H0l5nYI1MRd7h7WsJYFUJkxQ8cvfNoP/5P/h1N//2ML+dHOJu9nNfzT43MmyCpaFcS6pR0CrAI5IcFRsekkulamXy1y4bEeO3lEJkjfzA0PY4oTbIRdJHk71wLMt62M6wnd98PsUIWTiswpq9k8wL7HYV+VqZRwcTaj6YC0nrkF+mmbx6zTBGvDcbJ2PZ5Thghc974QQgw37w0DKrMu
 7i7LKG6r
 9dAXishu61s5LA6Z2F+0IUJ3qsoCuL+fqZgn52GhMHiOE4dT8IsaET61wo/KjT1QWgXwT4NbkS0Q09Uu8K8YGAsorraS569H//WzD4YFdvhsqqaulIt+wr73pAuX+Br4MMaQH1az2jlI/NiNA9r8lHc5WRYflgToiD6dXPmKoZ9a64deOrkWR+D95RGYY2TJgLh+oZmy5tLTpd0iYfnf/BHtHCIDmSdKXfTgR7Ls6v1G0oR5DELFfRB2uAHQieIRdNxhXCRdsb60dBhA3lAakyCVV7XQz0/u/amL6qdAXYpt/c8ClykwtJcnbfSYR9eLjIovp4ERqCa0Hpczby6dxujF3V9TrRsjzo4Dwi11qjzLSaFwNF/mX7tbv8UTXDdH6TxUs0nTgaWpO2pnNpi0GWQrEX0hpo9EKVf5n6Grke60dSrTcrOVnQOPviQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 15:40, Alexander Krabler wrote:
> On 8/1/25 14:57, Vlastimil Babka wrote:
>> Hm that means something isn't working as intended. Do the pages have also
>> the unevictable flag?
>
> I have checked /proc/<pid>/smaps.
> Neither the manpage
(https://www.man7.org/linux/man-pages/man5/proc_pid_smaps.5.html)
> nor kernel source code (fs/proc/task_mmu.c show_smap_vma_flags) tells me
about unevictable flag.
Ah ok, you checked /proc/pid/smaps. Since you said "pages" I thought you
meant individual pages which would be from /proc/kpageflags

But IIRC getting a page in a state where it has an mlock flag but (not yet)
the unevictable flag should be rare so I would be surprised if that was the
problem here.

Hm or maybe it's actually that the error can happen only in the other
direction - page is unevictable (on unevictable list) while not mlocked, at
least the counters such as UNEVICTABLE_PGRESCUED suggest that.

Hugh knows this code the best. Do you think we should e.g. test the mlocked
flag instead/in addition to unevictable flag in compaction to avoid
violating vm.compact_unevictable_allowed = 0?

