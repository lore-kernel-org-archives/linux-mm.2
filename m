Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E17C2D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 20:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2976B00A0; Fri, 28 Nov 2025 15:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA996B00A5; Fri, 28 Nov 2025 15:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11EF6B00A6; Fri, 28 Nov 2025 15:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAA6E6B00A0
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:10:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21678BAEDF
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:10:35 +0000 (UTC)
X-FDA: 84161108430.03.89C931B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC35140013
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:10:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EDUF0JDw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5FPqdGpO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EDUF0JDw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5FPqdGpO;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764360633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgPNiOd6gYQUmPWsJjhdWNBy7OatRMyrF6W5hClr3us=;
	b=ZKvDtUMNQkx5SuSYc6CbcP5OSYB3/Pbr6lN2J0ah75/bKqqts7i9rgoIp0wbJ3w0nSVfNR
	zvDEzaL0BVUQT764NpivpQqfoeuioWFbrtX32rwb+Lk3ivA+hBC9WBOTFzZyRx2NQ6S2zz
	7JvzJrsf1JsTKwRxCTYv/0ZDWpOzolk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764360633; a=rsa-sha256;
	cv=none;
	b=X9LKyZXexKG/QJy/hNFWedf7VQ8b/C5PqFa4+wYu7yy5Wkb+5jAZZ8zo+4wfZr4tUYFYa0
	ZE434jFERyrC2+NuN0GzQwqgpEUxr1Gt9+LmfCf7agrWDnhKdzJn+qkh2lno/yXUcix9hU
	yRvH8WSqUN7V/3NU13mJG+hXGzXfC/I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EDUF0JDw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5FPqdGpO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EDUF0JDw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5FPqdGpO;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 01E9533766;
	Fri, 28 Nov 2025 20:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764360629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgPNiOd6gYQUmPWsJjhdWNBy7OatRMyrF6W5hClr3us=;
	b=EDUF0JDwO0JT3i4tjm7WCqqpyEnMpLi30kPYLjzV82vqX3njpwWoH1JtquWX2ZBoATXhZs
	b8WiDKpd/G5+yaazLHO7VUNPAqmqWnrTQHpEDnN4TSpq2ra9TvzLaNLl7Vly7bjaRFVCga
	Xl8fo+dwAxIRP7fIyk6YP1EmpnB26oI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764360629;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgPNiOd6gYQUmPWsJjhdWNBy7OatRMyrF6W5hClr3us=;
	b=5FPqdGpO3/0QfM/QfeBJNBU22eSh1CTsYre4R/gvSRjFf41A+nGlZ8QHmDlq9XZNblaR7H
	Hp0LLFLgwHi62/DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764360629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgPNiOd6gYQUmPWsJjhdWNBy7OatRMyrF6W5hClr3us=;
	b=EDUF0JDwO0JT3i4tjm7WCqqpyEnMpLi30kPYLjzV82vqX3njpwWoH1JtquWX2ZBoATXhZs
	b8WiDKpd/G5+yaazLHO7VUNPAqmqWnrTQHpEDnN4TSpq2ra9TvzLaNLl7Vly7bjaRFVCga
	Xl8fo+dwAxIRP7fIyk6YP1EmpnB26oI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764360629;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgPNiOd6gYQUmPWsJjhdWNBy7OatRMyrF6W5hClr3us=;
	b=5FPqdGpO3/0QfM/QfeBJNBU22eSh1CTsYre4R/gvSRjFf41A+nGlZ8QHmDlq9XZNblaR7H
	Hp0LLFLgwHi62/DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA5113EA63;
	Fri, 28 Nov 2025 20:10:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uCv+NLQBKmmsGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 28 Nov 2025 20:10:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4810DA08BE; Fri, 28 Nov 2025 21:10:20 +0100 (CET)
Date: Fri, 28 Nov 2025 21:10:20 +0100
From: Jan Kara <jack@suse.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, jack@suse.cz, Mateusz Guzik <mjguzik@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
Message-ID: <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
References: <20251127233635.4170047-1-krisman@suse.de>
 <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: AC35140013
X-Stat-Signature: x61cw7hgghuj1x5ct4ro3wjcrwu9gr44
X-HE-Tag: 1764360632-785248
X-HE-Meta: U2FsdGVkX1/maQL49S7ic6pUDMAkharshS16Ss8RuOz21jGDPNUJ50evDahtzOWW+E3B9HkkJDVWv52/Mc1N45tgGTSjOnhD9oliEArrVgMUbymIRbNaGMUlv5dbnCAL0TSGvlcekrCGCI5CID5DZrW5fdLz+bcAADaQxvNhAWaIxAgKSrLbOlYymRXplmKeDa2HIbA9Qih+JPfo3a3wa/JF+TcxG4D5gEB4ED4wBLRAE/dbOamlg36+Y4VEuZ6Raz4Nu7v8kbO2jwPvqZDGdKRCCoq4mm4ht1eY45U6TQN7C/l19+rrgQ29GXi7GOACq3zYmcxmF3mIokxDIY9onZW8tngQvcdnWaLyY3EQC9AuG9X+r9DYPk0t1SCX6agju5LhV8Jrgj4q+RPS1K3Nz7L4+O1dKPTa4Eks1JpI1Bjy6U8CSZ6dqBqSksa0w0+I1s9eK2XdxN8AXJFUUbpjzpXUJZXJU+BTXbfS7PQdIMQDFZZSuPraMkLh3CppInTzoBR+9UJdRw2hCi/mirrZN3v3TIOgRFSl7B7Yl36AvWIHpfNPm3afydHHA/IBRUV8Y8m1Gc4k6df2bZGkFVziSMegAoFL6cXYnYOxuiBjLNsqGJdwxmG0F90PF58FEq9cuawMRujZw9V3SqfM+k0j5lGYrtw+ddjq/3wiyuFoWh+vAkOVa00fey34+Fz/C551J6ryIt1gbdQFU/nZ/tM/LpJmbTTjQ9I2S/tM4QyGkA3SlPzD0L83PsE4gkDb41IR7TYW+vHQaFrLIT+ziKoMrxAClYDniC62+7xhxzSBTyX8HS2rPQV8j+VLBQHX7GxpvhVDyE5O3rbnm/GYsobuaaxSKaGrOm0RBI0vxNDdVJGZ6CJjzPSJjVwEUqibs5qzsWBSIi7KsRgougDdZGA8Wd46agVIfSn8YUhyrg/9+IXzchojHxOt7S9LTTpVFybTgWtaJDfi53oJ2lWLX9W
 To791Csv
 neoS5QeUzM67sVxTzhGyzXjqa80afgY8Ojhu5xWQcliFrDkukDjBKUcEslbgNLrtdtpvWbbg4eyBUKDbSaUZghQHTzxc70240+cEQsr6pO3mM4bxhJ6hWfYbBpPTQLIKgfrn7AsVL/gZ0iYuxuRRE6ePBVARTtNEMvRPADy0A45gFQdb4L+aLx+ZYwjP1E+FtLAtqWji3GzeR7WIMoy4aQx61Pv8TlROndCVthaSFaoS6lQAT9K6EdQ1cR47/5qYCY487vtz8GAAakHWfyXmy8o8E5S/F0+8aKaESiWUy7QTnM1YrHfgct3ybTNL8/KapkrpsBDy0COPdnXcyBVJBDL88DCPGK3FGuh1VqcrZQvXeBq/UxiMQsfiB+Qnt4yaW+GVc7q0N9O+0IXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 28-11-25 08:30:08, Mathieu Desnoyers wrote:
> On 2025-11-27 18:36, Gabriel Krisman Bertazi wrote:
> > The cost of the pcpu memory allocation is non-negligible for systems
> > with many cpus, and it is quite visible when forking a new task, as
> > reported in a few occasions.
> I've come to the same conclusion within the development of
> the hierarchical per-cpu counters.
> 
> But while the mm_struct has a SLAB cache (initialized in
> kernel/fork.c:mm_cache_init()), there is no such thing
> for the per-mm per-cpu data.
> 
> In the mm_struct, we have the following per-cpu data (please
> let me know if I missed any in the maze):
> 
> - struct mm_cid __percpu *pcpu_cid (or equivalent through
>   struct mm_mm_cid after Thomas Gleixner gets his rewrite
>   upstream),
> 
> - unsigned int __percpu *futex_ref,
> 
> - NR_MM_COUNTERS rss_stats per-cpu counters.
> 
> What would really reduce memory allocation overhead on fork
> is to move all those fields into a top level
> "struct mm_percpu_struct" as a first step. This would
> merge 3 per-cpu allocations into one when forking a new
> task.
> 
> Then the second step is to create a mm_percpu_struct
> cache to bypass the per-cpu allocator.
> 
> I suspect that by doing just that we'd get most of the
> performance benefits provided by the single-threaded special-case
> proposed here.

I don't think so. Because in the profiles I have been doing for these
loads the biggest cost wasn't actually the per-cpu allocation itself but
the cost of zeroing the allocated counter for many CPUs (and then the
counter summarization on exit) and you're not going to get rid of that with
just reshuffling per-cpu fields and adding slab allocator in front.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

