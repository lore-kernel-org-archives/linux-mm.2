Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37968CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 13:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8EE8E0147; Thu, 30 Oct 2025 09:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0DD8E007D; Thu, 30 Oct 2025 09:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E6C8E0147; Thu, 30 Oct 2025 09:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FDCD8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:18:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5E5716015A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:18:51 +0000 (UTC)
X-FDA: 84054835662.04.CDF5278
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21A96160010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:18:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kX0etpTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZUhI6lNy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kX0etpTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZUhI6lNy;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761830329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgjcxRthmM6PCoG1BiMHfp5HdQ/ejgbzHCetCjaVfDk=;
	b=5DpqRw/t2Ih8puphAkM9kpZ9fTu5PDNddDPaFmqpb2l5SLENQbL3IfbfUrCMcwn7kQXA83
	i6oGQ9ubEU8qhbKeAHsUsQzG5nf8IrS+c8KmTvkdkH8LEkTHbysmNNJUQBHTxDyMXt4gy2
	V6iw3b56AXwLHzSa2iwiasbwwlJj6o4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kX0etpTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZUhI6lNy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kX0etpTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZUhI6lNy;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761830329; a=rsa-sha256;
	cv=none;
	b=EA6sx9P210rWKe77b/oRyGzOplfLlKjxYzviGdEK1Jdntzo242ewu8VGkgTS7UWPTmaY5z
	2yXC5Rv6k+FQkkNIYwnfTsqUbA2q6nnzNsuu5ZJBPB6o1dkaldwcEcwrSs2mM+m3WwSQGd
	bD89r3+03g9lq21o30LKl19aB2k2pcU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06C7A1F6E6;
	Thu, 30 Oct 2025 13:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761830327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CgjcxRthmM6PCoG1BiMHfp5HdQ/ejgbzHCetCjaVfDk=;
	b=kX0etpToU/L1+noHFXojTL4kScufLYFcskoWFzx2mIARRWUpb1JTr2uEeS1Jq3qi3aQpcH
	pllhyT66jYnhEtyhJY6RYXzB4apxxL0kk7Rv3Bx+YAejbWtYMPhTvS4NqSJH1YTDqcne4Q
	smkbzkAsq1IuPsAPcGL9zOSPVogWHyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761830327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CgjcxRthmM6PCoG1BiMHfp5HdQ/ejgbzHCetCjaVfDk=;
	b=ZUhI6lNyYmBAkIoA2bbz6dL8p3QR/xEiF+UmKTMvPWT1WlevTqrz8tw5zNggFYZzGLinNK
	mDLwhnkExICvJIDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761830327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CgjcxRthmM6PCoG1BiMHfp5HdQ/ejgbzHCetCjaVfDk=;
	b=kX0etpToU/L1+noHFXojTL4kScufLYFcskoWFzx2mIARRWUpb1JTr2uEeS1Jq3qi3aQpcH
	pllhyT66jYnhEtyhJY6RYXzB4apxxL0kk7Rv3Bx+YAejbWtYMPhTvS4NqSJH1YTDqcne4Q
	smkbzkAsq1IuPsAPcGL9zOSPVogWHyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761830327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CgjcxRthmM6PCoG1BiMHfp5HdQ/ejgbzHCetCjaVfDk=;
	b=ZUhI6lNyYmBAkIoA2bbz6dL8p3QR/xEiF+UmKTMvPWT1WlevTqrz8tw5zNggFYZzGLinNK
	mDLwhnkExICvJIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCE5913393;
	Thu, 30 Oct 2025 13:18:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ovyeNbZlA2kjWgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 13:18:46 +0000
Message-ID: <2a95b2db-c487-440c-b95c-35549c8f5ba6@suse.cz>
Date: Thu, 30 Oct 2025 14:18:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/19] slab: add optimized sheaf refill from partial
 list
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-9-6ffa2c9941c0@suse.cz>
 <aP8dWDNiHVpAe7ak@hyeyoo> <113a75f7-6846-48e4-9709-880602d44229@suse.cz>
 <aQKsNPQe--6QMOg0@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aQKsNPQe--6QMOg0@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 21A96160010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: oh4j1s16zoywbbm97766k11fbdf9qa3n
X-HE-Tag: 1761830328-434036
X-HE-Meta: U2FsdGVkX18LU0d8W8fZBkaxUZLYo1BZKjoboCFxWPuE/rjGNHRyrBj4dgB/k55IxqYmoPWCoH/wCz0cOVzX/x5/uflFM22NBrOYsiVpE6VOu0S/e+BPY0Dg/TbGH6DnuLKcOua+8/q42fRyNGrnuprGc8Sb1lLq+bvX7g3MqVWgemOIHPz9ZRr9YF21zBmt6oeX3LfFD0SkuLDRpVrYuif6dS9vbXvsEk5fU2CuWRzlWBy2nOuo5fRecUVvlfX9fZYn3UhELgCI7nidYdLhoiSIrhZOGJrxGkcG2/JGnR5YgdDIh/PnnDzQSgzLgTQC3RUUJd1rd+1XB/6kJNQu8QZ1KaooCeGijij/t1TMfLfyzmEdG6NBxhwvrig19DOQcG8tKzh9ae/b/5kA+9nhcMhZUVxRzS3W1KpFV9guP2xL3cVKsafJCtkkbfQXuOTQCNr6e1Du/Ppfpx6LzM1Jf5w45ZovsMtXarCKVNwBV9nraC/pOZ94Zhvxa3fZBDKtfuRxQznw5ZrLhnagLkMuLfneUlePkUGkPVQBd9US0tawcmfzGjaUa8wft8hZIldoM5w153ehDhdJWg84d293tbEiLts1D2qCmk5lrAwlk2BZdWUcFW4LCIEIB7zQYAExA4msEzyu8ytukL+YZdSS/FZqWw1MvBD6Ek19MqSNZEvphJ2ChUofgMGJ+I2wFFKDXVzVzjmuyz8a0vc80XCt95HACbeRWq2vNdMxbxX7hexlEfqtAPp8hmsUZ8yZsZaGx3D3Pf5hNty0+lbBVpiNyIk0IW+o/azcFNPXJzYaCJUKq174c06frpBOm48RG/yyF5taOD2wnQPlm5Ac0dkAi9H9MwUlt8u7TObxHMqmiKE8CnAdG3HE6FgtmvC0VsuIMOhKViS1/KKY7f3yFDj4IvEIitVzyCi1NYL4ZSAtZwhSmiEkwWENiaeH7KZAT+598junYFxq+wrkd5NAkrc
 wUlS3gS3
 P3A0ED5UqYNWeSrmn1HGVdqqb3RlTETAD3Ndtz+oO8/FlG1Bc9v40AlrBGsqq67XLio3XC/Kd5XcMuwSgn2YGcrMAtv/esxapcYGGbH/iR5DWz+go054hBwahM+lmcgdF2A7aY9jwTEPZYpjKrkGEfoXT2UtrW1Y8WQ4sL/NXRikN3/2sfo1MvA5vLKWWZnoLijJBzxIuvvtKcCP9K4iLvQyrcDEwIeMk9gDl27Pm3QUWPj0gWjiqG8LF3GCPktOyFKmTm1K48APH8GJ0YhR2SEoHZZ3x4K/celd+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/30/25 01:07, Harry Yoo wrote:
> On Wed, Oct 29, 2025 at 09:48:27PM +0100, Vlastimil Babka wrote:
>> (side note: gfpflags_allow_blocking() might be too conservative now that
>> sheafs will be the only caching layer, that condition could be perhaps
>> changed to gfpflags_allow_spinning() to allow some cheap refill).
> 
> Sounds good to me.

Hm now I realized the gfpflags_allow_blocking() check is there to make sure
we can take the local lock without trylock after obtaining a full sheaf, so
we can install it - because it should mean we're not in an interrupt
context. The fact we already succeeded trylock earlier should be enough, but
we'd run again into inventing ugly tricks to make lockdep happy.

Or we use trylock and have failure paths that are only possible to hit on RT
in practice...

