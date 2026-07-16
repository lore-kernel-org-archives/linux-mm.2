Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6FAAC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A4A6B0135; Thu, 16 Jul 2026 11:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B116B0137; Thu, 16 Jul 2026 11:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7613C6B0138; Thu, 16 Jul 2026 11:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9406B0135
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2886A00D2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:09:20 +0000 (UTC)
X-FDA: 84994973280.02.74B3FEE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC2E74000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:09:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWeiiFMI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zvbFxaXh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWeiiFMI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zvbFxaXh;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784214558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LfUgg0n19vDJax5C8zHGy4BuUGI2ivSxdihsCEdwu0=;
	b=uyAZCSJfNfAdXuprLWbiZ/jk8WKNlje9gY9ARHKQZwd27YdILS3dfD/op1LU7H/DzBcuuv
	Iav8ULygcmoB2vxrcvU6XyVgi7+kn+gh6Lnw+TEMcHlbyqPwCpxGmKRPVETto3hKYB6hJN
	Ajgx/ONptVNd/dE1ygRjKwEwJkJS1X8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWeiiFMI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zvbFxaXh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWeiiFMI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zvbFxaXh;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784214558;
	b=j/F2wiClc/VxsOswj4K4ym4rOFbXzA7qTeXF1MRyF3BECk021aRZMWcEBh5cIPCGjpPBdv
	C/5sE9vj+rvs73cet6xtOHlm7FMo5/6nGqmQw69ZaP1RtXmnCUcAWIgGqtZjbc926j8ar1
	C4XLJ/iNdZTj5Si+3WOcLh/Kk0K4zOs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 651E1789D7;
	Thu, 16 Jul 2026 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784214557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5LfUgg0n19vDJax5C8zHGy4BuUGI2ivSxdihsCEdwu0=;
	b=CWeiiFMItu24NHY6UlKPgkkT4bPR2N4quhUDntE+t0iJrlrOMKtoeQwPtANLK9wo0QBsKL
	6yK45VjJGnklmtgc31GKaZjrW+0gzMDY2r4KNe5froByEl3xcXyYbREOIgBW0NVvf9NeRm
	/+fHly3XP+L4jooPNV8fpbwNbwG/EJM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784214557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5LfUgg0n19vDJax5C8zHGy4BuUGI2ivSxdihsCEdwu0=;
	b=zvbFxaXhKFbs/0ygiq7Pdb2TXfl1UTtOYI9Pzv5ApT9v8X8xsOEx6Whdno45jCERBzNDPQ
	x2L84CF32PBU1zCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784214557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5LfUgg0n19vDJax5C8zHGy4BuUGI2ivSxdihsCEdwu0=;
	b=CWeiiFMItu24NHY6UlKPgkkT4bPR2N4quhUDntE+t0iJrlrOMKtoeQwPtANLK9wo0QBsKL
	6yK45VjJGnklmtgc31GKaZjrW+0gzMDY2r4KNe5froByEl3xcXyYbREOIgBW0NVvf9NeRm
	/+fHly3XP+L4jooPNV8fpbwNbwG/EJM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784214557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5LfUgg0n19vDJax5C8zHGy4BuUGI2ivSxdihsCEdwu0=;
	b=zvbFxaXhKFbs/0ygiq7Pdb2TXfl1UTtOYI9Pzv5ApT9v8X8xsOEx6Whdno45jCERBzNDPQ
	x2L84CF32PBU1zCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C786779AD;
	Thu, 16 Jul 2026 15:09:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WG5JExz0WGo3awAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 16 Jul 2026 15:09:16 +0000
Date: Thu, 16 Jul 2026 16:09:14 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/mseal: remove further superfluous comments,
 do_mseal()
Message-ID: <aljzdCwWzyvTDgmv@pedro-suse.lan>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
 <20260716-mseal-fixups-v1-3-3a9609bf041b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716-mseal-fixups-v1-3-3a9609bf041b@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AC2E74000C
X-Stat-Signature: fs6fgpaqf7kqmx88968bnta47ygyf891
X-Rspam-User: 
X-HE-Tag: 1784214558-489331
X-HE-Meta: U2FsdGVkX18ndCccoWsJ5IW6xCmAiNPVDP+NI3nG+yShjW1S87xnnKCywoCKNwyMY2YeHwCna+ChWkS5AJVYZv1MjLJf9qNPJ73FbEYzvvEgNsEK43pPNxZcl9izQQnJcm0Ff5kT2DfB6Z0VqELE3UieLzsnHe/oCe/QiIfNW3Zkcf5pVtKTRI0Wwbsd//jRd/vUf22Dp5BvGIafAJm3WVeIPRyeE7LD9lRWmvWFYrJh5pKgnqd6WwiH9v4RRtLIOCi9rF4L7SijhOYxgwZcUGpXMhT5ICdbjU0ahXxGzrs6grwvxKpehgFWhGYpv8gdNlWLpa42qLsNZJtd9YDegYZA1PdhyJWvSBidho/2WB5ZWN2h3d8g8HX6uRmFT+xx6bBZ8TZgKSPYEyP+PoEyYObc0A1sYJS+cU6Zxs9cbXS9TtY7tDbB7WQFie38aekVjR4cOrAw3N+WDsa0SV2zeT87dcIZqA8HOB1TXuB7aAotolA6fznM1iCKGnW0VhBiASAhboZe3hsCA1kwChpoM9QNSUxHFeUI4APE7DrpCPpUIO7gU9e8RiOTDUVhAmcPdT1dsFyQvjNx6KagzWUZ2it8lLZvgYjL7eDfbl+5pV2sSCqHsAgWZuuxCHK31W3rBznk/Q4DniN2cwxnGivbTsFqFMjObpzKxBqh/poUY0hTpmz3y92JXsCGrTHsCgifiUN5LDHFsuuBMu/9UuJsk3fP3y8X1WzsWerAH7yx5ovx2yktuyiOMn0fUO82r/irwBtiLfC+WL8G/8jl4qq2sSsPYC2grSf0ew+BqRSm/Ljm/ZAuE8iFG6Mp4H7m//9ppkVWaPvX6/Z76xouIlwXvp9iSx6dhlsh/Jwkyc7/GAyF7Bl/BNtIYtM2Zk31vfN9cWrjSlD3hJ71pLKkoJ85VtTRKRiWZQmQ+7bNq5II42bhcOUvW3cPBG761SrYSXU7zmVKtzcR0jdMY/AxnCl
 44uxwg8Q
 k5V0GWP5Uxlvj/uJ7Aap2q8R/mVj/ei0IIxKsXEZFqtOB4YuFqwU3qt28UxEt6cTN8RBn6mUQojPQoythirlgqafCl4Nk6QFuaK7CpofwXbpTMz8x9xmEhvoF1O9gw0oacP8xLgfnJnK4MyK8rpzKBzpaN8xLEiVF/TDGR7u72AF8n9+/GstjtactTsPmhTY2WPz1+ArWMopioKQNOu5H4Or6KZsm6IRCLYW51rPs0KYs8DWIEyJsqeWssavgR8l6Or681jpxcppo/NKLeeJz7oGJm+2FeFOAH51V5b+fohDRgRXg4UIgVqz6c1x+SGWv11E6eoAyFXE+UxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:43:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> There's no need to abstract do_mseal() any longer so put the system call
> implementation in the system call declaration.

This looks great!

> 
> The comment around do_mseal() is strangely formatted, overly long and adds
> a lot of superfluous information that the code already provides, so boil it
> down to the essentials.

But I would much rather we delete the whole comment (like Leon's patch did,
per my request). Do you disagree?

> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Anyway,

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

