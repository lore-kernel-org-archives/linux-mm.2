Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED367C531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 10:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61796B0093; Tue, 28 Jul 2026 06:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E388F6B0095; Tue, 28 Jul 2026 06:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D014E6B0096; Tue, 28 Jul 2026 06:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5EF26B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:33:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E1C040310
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:33:37 +0000 (UTC)
X-FDA: 85037824074.18.730314A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED4ACC0009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:33:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hmspDYhX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dfv9hSEH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vrM7+Kpp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=15VO8SDD;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785234815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ScQ16CMjFlPTjKS2k1tW3rCTBpjt7WhqtuW+Eef6SU=;
	b=qirOMkbB7Vbq1x1z/3RrsIJNmGs59QRzs1uKmmhKHC1N9TiyzowEzCLFgYbzLrHD/8OEVx
	GuJymFkHCbORP1MIEJvdNuMQ96aa4+SRDMuepF2jNoGvV0/rUy5WNef0dyENfMzUCtqaew
	RL4b/jN6KBbVdys7FUQlFKkyhsuQhW4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785234815;
	b=wR7BTxjY9tVFa7kcy1OiQ58PESOUfdtH6y9UAi76dFsgeulHzdeCCZz6zI6v05Uq0WpnR6
	HUvEhN0b24D8RraliXvhu/ov5mevQXwqLzwy0NjUQybIRfVx8DWMte87v4Hm+Y1+i4uDKP
	EvYHBpeV+uwN8IhqUHhMSfq2AW+RQtw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hmspDYhX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dfv9hSEH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vrM7+Kpp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=15VO8SDD;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3524B3E03;
	Tue, 28 Jul 2026 10:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785234809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ScQ16CMjFlPTjKS2k1tW3rCTBpjt7WhqtuW+Eef6SU=;
	b=hmspDYhXrp6nsKgIWnShKcP3m1zateD3bEY3uR3GMErFfIxMI9+7/9QdoMY1OSL1i+d9Ny
	ss+c7CzUHS0b0s/s+ubeJoKE314FUJcdwBRgQPnYA3jZnGclfq6lclfmk1jrAfkFHmjPXD
	ALydB6hGuiNUAt7T35xwF/Q7tGqIIw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785234809;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ScQ16CMjFlPTjKS2k1tW3rCTBpjt7WhqtuW+Eef6SU=;
	b=dfv9hSEHvWLKGMbbBNhVjCDz2vk/P4DzXoOYrI4DR42iExQvjuX+5M9j7wSOSUNUvXU0J9
	pxBzL3eURvkQWNAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785234805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ScQ16CMjFlPTjKS2k1tW3rCTBpjt7WhqtuW+Eef6SU=;
	b=vrM7+KpprfezwZJiC2tqWLgrwHwaue0fD8f19jQfJUlGkmYWSlvkowfoF2O9cJqSfmnc2E
	2eRBmU3pjwhTkWXbEm98yaEC3/yIJSvaC3seVOLe1nBu+YacKViosmAP40ubcTMimr6XR/
	8Xli5LeJ4agy1c0nCZRnAXLzkzRjoIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785234805;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ScQ16CMjFlPTjKS2k1tW3rCTBpjt7WhqtuW+Eef6SU=;
	b=15VO8SDDjXpk6nGQsh3OpyKNDkmPEvq+Y5DXMA1IPu2e8rn0UdJqkJ/eKY1HHB5Xqxfpku
	TyjJh3Fea260PcBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 261BF779B1;
	Tue, 28 Jul 2026 10:33:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mOr2BXSFaGppLAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 28 Jul 2026 10:33:24 +0000
Date: Tue, 28 Jul 2026 11:33:22 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: fmayle@google.com, jack@suse.cz, akpm@linux-foundation.org, 
	david@kernel.org, kaleshsingh@google.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, lkp@intel.com, oe-lkp@lists.linux.dev, 
	oliver.sang@intel.com, surenb@google.com, willy@infradead.org, baohua@kernel.org, 
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <amiCX6kcQneMZu3-@pedro-suse.lan>
References: <CAHCxdc64d-6qNBwwSZX8mdz4-V+88No2x0wG4mex5WPXBDE9AA@mail.gmail.com>
 <20260727014610.3479784-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727014610.3479784-1-zhangbo56@xiaomi.com>
X-Rspamd-Queue-Id: ED4ACC0009
X-Stat-Signature: 57k376t9begjif978ypdydnnq3jkneii
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785234814-795054
X-HE-Meta: U2FsdGVkX1+yXH0rcXrcoISRet4A3c7P0mZPZkMZWvk8oWt2KOx+G2zYJv7wILULWvU9lQb6FpTMIXMFU+OVPIVUsa53y0cdzBcmiRK6YUe50w2+eCuzn6LmECHJSw2huNc4szlgkU2hMuFtK0kEWIrm8decVe6la08cQv2NrOMyFInveyajIucAUSEjzqJWT8NsFwA4GG472pkAAZNQsx3Kzd7wFTMFtSNejI3Dve570D2JARqyjvVlC/B8V9mQfCGouE9SVW6SzCcIrT2y4nz1ELPHNj0mkGrIg6e5LanBG5YOyHIFV18sYC3NnyjJlK+OkJZfYgOKj+NbULu/GF/MuCf4nysXJKmP/bMez+9rESMiPsLxtgph/rp7hEGpx2ear5jj4oabHTa75x0BHwP5LMGOBQ6aaIjY1O+gOXSi81BvcgmIcvENx9yWINloT60FyFE5hYg2fam7itY/kCI5YekJvTZITP3KfWUajGej9xc2ROKVPG0XlpXvmAffZoS6SFZAOxn5VwS2eSCN+HKfRw/UURoBfUhs59YAxBwnlm5cbCjoUS6sIdhJZ2BAbN+ceC5izLH17U3vuPjHYg7NnkSBlr4rPh2afVJU2PQEE4YeYiiapcbDyux+QZZTOf5GRjZaOeEaOgGSDzR5uCbXJz6nUtQXJ8ujOj1jPIptDqMpB3QtaGGcHYfOmLjMsPX/LTtXAIU7JEZd9cwT7lLxk2e8YXiweJHgjquvlks37rjRVHzb3hwJm7p5R6Yt1/qgwGiqul+4P8c3UQz7z+HPUPqYIoK78bH34pnSB0F64rMnB5KgxMQo5VRi//Ou1dvTvD0T81/8AhnQ+WCXFHuoZUV4oqPAWTm8XFGW1gUEOA6iBXUvXbCZZpavRP/PA8W2e0fgTcFzXn8xFzvOG3LNR/BEREoCBtHrBOq3kY1PyXn4QnIVt3MRmg+vE+oFb8G3rBpMaqVpIVSYtNg
 E1iFv29Q
 I2DxROJkAB+pob/Di88asIhVrD/jXY8pV9ukv4tGXWRNb1zPNp2uWO/a67//G4dBwnGExqnjeE86J5YghPaXaUFvNg5G69AH4eGNvTUA/1AoCOpG7KE37agfkQuzIVuH+OBQgPHHw/vNcjz3dS+C5FPCwuGKDpeHM8TpZWyKZRrtz41s+JF9r52dV/6iMSrUFK5Uc1nq0rFRtpTKH9yTMRkt1cvJ9ovL6STpLOoG2ZVCVj2SOQnRBSTvv0l9m1JdKQuhYOClSnrYyyHUJzaq2Hz8zdFaWibAqYKVyTWa8JQc1wl7oqVqN76IISw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 09:46:10AM +0800, Bo Zhang wrote:
> On Thu, Jul 23, 2026 at 01:34:38PM -0700, Frederick Mayle wrote:
> > I maybe missing something subtle, but, I think you've changed it from "don't
> > read beyond the VMA" to "if there is a chance we could read beyond the VMA,
> > don't read beyond the VMA", which seems like a more complex expression of the
> > same behavior.
> 
> Hi Frederick,
> 
> The subtlety is in how async readahead interacts with _max_index. The two
> are not equivalent because async readahead sets ra->start to the end of
> the previous readahead window, not to vmf->pgoff. So even though the user
> is still faulting well inside the VMA, the readahead target (ra->start)
> has already moved past the VMA end, however _max_index blocks it.
> 
> Here is the concrete scenario (ra_pages=128, VMA covers pages 0-1023):
> 
>   1. Fault at page 0 triggers sync readahead: reads pages 0-127,
>      places PG_readahead marker at page ~96.
> 
>   2. Sequential faults continue. Fault at page 96 hits PG_readahead,
>      triggers async readahead in do_async_mmap_readahead().
> 
>   3. page_cache_async_ra() detects sequential pattern (index == expected)
>      and does:
>        ra->start += ra->size;  /* pushes start to end of previous window */
>      So ra->start = 128 (NOT vmf->pgoff=96), ra->size = 256 which is doubled
> 
>   4. page_cache_ra_order() calculates:
>        limit = min(file_end, ractl->_max_index)
> 
>   With the unconditional approach:
>      _max_index = 1023 (always set)
>      limit = 1023, ra->start(128) < limit (It works fine here)
> 
>   But after several ramp-ups, when the window reaches the boundary:
> 
>   5. Fault at page ~896 hits PG_readahead, async readahead fires.
>      page_cache_async_ra() does ra->start += ra->size:
>        ra->start = 1024  (previous window ended at 1023)
>        ra->size  = 128
> 
>   6. page_cache_ra_order():
>        limit = min(file_end, 1023) = 1023
>        ra->start(1024) > limit(1023) (Which will read NOTHING)
> 
>   Result: page 1024 (in VMA2) is never prefetched. When the process
>   enters VMA2, it takes a major fault and readahead ramps up from scratch.

That's on purpose.

> 
> With my conditional approach:
>   At step 5, vmf->pgoff=896, vma_pages_left = 1024-896 = 128
>   128 < 128 (the condition is false), so _max_index stays ULONG_MAX
>   ra->start(1024) < ULONG_MAX, and it will prefetch pages 1024-1151 normally.

This is exactly what we're trying to solve.

>   Page 1024 is already cached when VMA2 is entered, only minor fault happens.
> 
> The key point: when mprotect splits a large file mapping into adjacent
> VMAs (common for ELF segments, or read-then-write patterns), there's no
> benefit in preventing readahead from crossing the boundary, so the data is
> still sequential in the file. The limit only helps when we're actually
> near the end of useful data (within ra_pages of the VMA end).

This is completely missing the point. This change tried to back off from
reading _anything_ past the VMA _on purpose_, due to ELF file spillage. This
patch reintroduces spillage in a very obfuscated way.

-- 
Pedro

