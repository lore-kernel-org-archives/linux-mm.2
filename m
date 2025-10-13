Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC02CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474848E001D; Mon, 13 Oct 2025 04:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BAA8E0002; Mon, 13 Oct 2025 04:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33AB38E001D; Mon, 13 Oct 2025 04:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEA08E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:11:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E60631402B7
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:11:03 +0000 (UTC)
X-FDA: 83992370406.26.6BA4132
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9CB21160010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:11:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hN5ZU1ai;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JHQYgRZP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hN5ZU1ai;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JHQYgRZP;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760343061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ps41zUy95kfjQbWRm26qwDq0kcKNrKkfDkWwXUzHQk=;
	b=XfYbh0Ni551D3jE2b38jNNtPS9vy4iVv/CnPgeLJAy5nndYQvYh677NXnVqZRiEUwO3TOE
	kov0tsl3FRC98Z7uMI95pZcfIreHNs+crHtXQweHOeRBBBmlGSY0I7juswMYYlCh6igKC2
	pjU1K4Ylu0uFEFK6iWJ6WXZUd9O9fAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760343062; a=rsa-sha256;
	cv=none;
	b=OE689dRfHjOwoXFnVW8WyeshG44qz48UL2MrrbmvKnaIihN+qfCpA9YFnVOcctaEbnGxfu
	kt+V/iUH220V2lLaHf5lD47Z5rHsMKmbTQAvAot8D6hCLvm6mEHKhbDdbo0QeMMA9WQn8S
	m23ENMPjj1xIXRirnd8vuKWe5aueaUU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hN5ZU1ai;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JHQYgRZP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hN5ZU1ai;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JHQYgRZP;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2C75A21275;
	Mon, 13 Oct 2025 08:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760343060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8ps41zUy95kfjQbWRm26qwDq0kcKNrKkfDkWwXUzHQk=;
	b=hN5ZU1aiAETszeTISSACxTrVIT4FIDiNbwSCadcQjU4eLVyGNFACm9vuYpGaOt0InVZNYF
	szhIRF9tldJ1NwWFm8eqsrCUfMokc9koSOXtaSXzh9Tfg7bk2O1UIS3FelNv/ocXg9fGon
	kKzk2SaMRc8dAI2b8h6uN4JKW2kfZkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760343060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8ps41zUy95kfjQbWRm26qwDq0kcKNrKkfDkWwXUzHQk=;
	b=JHQYgRZPJtqz/rhmxOsmYlzT6tBnNajUWKDitVayTk3qrf1RZRnHzc1oNPW45ivTr/4mvk
	UhSMUJHtTLjeCRCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760343060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8ps41zUy95kfjQbWRm26qwDq0kcKNrKkfDkWwXUzHQk=;
	b=hN5ZU1aiAETszeTISSACxTrVIT4FIDiNbwSCadcQjU4eLVyGNFACm9vuYpGaOt0InVZNYF
	szhIRF9tldJ1NwWFm8eqsrCUfMokc9koSOXtaSXzh9Tfg7bk2O1UIS3FelNv/ocXg9fGon
	kKzk2SaMRc8dAI2b8h6uN4JKW2kfZkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760343060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8ps41zUy95kfjQbWRm26qwDq0kcKNrKkfDkWwXUzHQk=;
	b=JHQYgRZPJtqz/rhmxOsmYlzT6tBnNajUWKDitVayTk3qrf1RZRnHzc1oNPW45ivTr/4mvk
	UhSMUJHtTLjeCRCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1039213874;
	Mon, 13 Oct 2025 08:11:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HCp0AxS07GiGHQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 13 Oct 2025 08:11:00 +0000
Message-ID: <32a23856-ffaa-4d41-b77f-fa0306042621@suse.cz>
Date: Mon, 13 Oct 2025 10:10:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING: locking bug in __set_page_owner (2)
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Brendan Jackman <jackmanb@google.com>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 Michal Hocko <mhocko@suse.com>, Network Development
 <netdev@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 syzkaller-bugs <syzkaller-bugs@googlegroups.com>, ziy@nvidia.com,
 bpf <bpf@vger.kernel.org>
References: <68e7e6ad.a70a0220.126b66.0043.GAE@google.com>
 <20251009165241.4d78dc5d9fa5525d988806b5@linux-foundation.org>
 <CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com>
 <20251009174108.ad6fea5b1e4bb84b8e2e223b@linux-foundation.org>
 <CAADnVQKkLyJ0cbLet3q3X+X70FPAejcqTxP66d82WTO82c16rw@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQKkLyJ0cbLet3q3X+X70FPAejcqTxP66d82WTO82c16rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CB21160010
X-Rspamd-Server: rspam02
X-Stat-Signature: ixe7g4bw6dpt4efcgdzd5uiyerbmsc1i
X-HE-Tag: 1760343061-777740
X-HE-Meta: U2FsdGVkX1+TRpxp8K2nXhNJyv9StGWJtEIBOQuuOYJtBmp7rVGqix+XKU18Hto4UR9Q982jSlkzqckGZqgELOhR1SWOS/2txW/EraZDooCzJMqDyEQFNf2WU0dGzPb0yperlABCEZRdke+L1aOCk4HzHv+tjxPV5cNqAVW0GUX5jTdqCMY3/zRkKFee19JMP3Q8xkNw55tzs/HzMeRAvbxKWJBWJWGYxBuEh3rkXZs8N1V2oYwFXbJoNBpp6Y1lBpXknDGDtw16uiv1tsVc9FMVdLOIzU8sp8o/fIMbSH16/WocOklqnK+B0UeUw7/4RNeLYHUh5k9dJs1ikjy6CzB2mRhrq6srSJNRqVU5S1KIvpK89fzCG9oNrnvsUfOpGjB8dIKl80goqPpDlYc90KyyV0RnDaUuwZpSvXosIuuGYqgQLJAbTgTtzhdi2B7+B6eL7ml9HREI1hFHn7Gmmgblm1vDDYGNu8zIYBsJJ2nRGnDqpdKBxaua2o2jhZ2vVo6/80M9sQC9POgpKMLPkJvFsBDlZ1idy+maU+uxDsTouMJm2GLrhdaE4Lugx8PhpLABsXyOkELRnbl4xb7SJOGB7TJnDg98eD3yzrCuqyfQMYHBH2HwYxNRrzZrIFhMeZIObjzOBgwL6SzrzrWpRXexBWuoETNfaoIdsOamxY3L0zxMt3SzUM1yBRAv+IbWkAB+szYDFkkdWsrcIz3Q1cbjrfqIjFg9OoWI8H/NUE6Fknil2TS/ZAS8VLWdQWPTsTUVpvkkmBrUFf4yUZq1fCaJwDIiidtcAQ6p44gtbtlt3xZJEILHrAum8sMjf6n6sWAw3lZniVTOeWm9LDTu+4QdW/oltNqZP8ye9QlItiAB7c9vu1/mQWgGROyOW5kminUc4P53el463n/brfPUzgE7aO0/p89WP8zAd6mQfK/JATwMKKOIB3z+/hYct9ujs2YnVnsy+j131MJnkoV
 J7zp+UNE
 +7Rekd9teXs6QE4O3Dx5ZT2yzq9Ooc/RPIJe+D78purb608T8/AJVpRXVIGR0xrk2BQJU5ya6eh6Wnyln0eGAfRmMo0tVkohF1NtKFHwGismsvg0IUd0wUz2sJUTSr5UX7heixG/2ZDluaPV9cQdRGIKIN0c2DI7ZpeMWlsTjw15UvCJCEq/qIMF3R6Y3uhdtTMKyXHeCeGLXq/nyCsbeBhH8KP581LYSOvIhE97267V7xd8YXaKi0CAtjAs7rGJ1E/TsQ1xEkNqkHfR3pPWGibNadzp4zmwG6A9VC4tyqXzzmu5ewiupaluDCqiiuymSTclZT7BwhRkjOPmarYZ/sfdLDAJyxBnuQJRHXcFB2LxnlURWKnPPeF5++7bYhlmcd6F33ccejg5XijGJpZGhgX7X/quT8GETeDxXr/WVg5ns4Nwai16FpusnN2wrK53ddaMRXUcbMIsEv27Ac+WpoLIg7Cj8IMe/iw8Xy5G5662S7ldqzTLxBOMiNvfvVwejInI4n40r5pNvXlNBNgouGK5+meWshK2layYjZzodTcZ8Qh0KwsGImAkniQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/25 03:02, Alexei Starovoitov wrote:
> On Thu, Oct 9, 2025 at 5:41 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>> Seems 6.18 will need this.  Do you think it is needed in earlier kernel
>> versions?
> 
> Maybe. I need to study the git history of that code to see
> whether it's a new path or I simply missed it earlier.

I would add the following, which means 6.15. Maybe there were no users
immediately that would trigger it, but should be proper. The only non-EOL
stable is 6.17 anyway, but might help others backporting.

Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic
page allocation")
Acked-by: Vlastimil Babka <vbabka@suse.cz>

