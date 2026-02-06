Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4527EE20B6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 16:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822396B0088; Fri,  6 Feb 2026 11:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CFBF6B0089; Fri,  6 Feb 2026 11:44:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FC26B008A; Fri,  6 Feb 2026 11:44:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53C906B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:44:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02956B72E4
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:44:50 +0000 (UTC)
X-FDA: 84414605982.23.AE4A77C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 73D0512000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:44:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JH/1Buh9";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rGI5wcLT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Oftyxcvz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S3fPNZXs;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770396289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iae96BpziYNnFm2n487MAGMR4usXUTx6hjnk1gdR25Q=;
	b=2/VQt9eZTkRZ0plzr91C0PeGG2hM+xgInDd16O+vP3a7fpzugjmVYPBoHrjrpdNtdEB2y+
	gG823+bkxUUQkW9sNTY/mkLgLuxw/xdTvwkwgq71YVVcSSTQhcfvRvoW3LtYgPRGKQGv72
	B3X/quCkr+1tr7S32qrslCR3jHlxkoY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JH/1Buh9";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rGI5wcLT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Oftyxcvz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S3fPNZXs;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770396289; a=rsa-sha256;
	cv=none;
	b=CrIZT+Y4FE1/FrE3nRTqRIh2uKLvJk6ToEG86c/81JijweCGUQZk6R0TCdOGZKbHQNbCHo
	3D5IHayeUdcqp5lRphkQPS98CSaXeKroNZXGV+uTXYxMIWdg4iHIi2np59PU0xI9vv0tT6
	IkLzlnpiK4pWf3ZQNImFkAV/4f7nhQk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A88F23E6D4;
	Fri,  6 Feb 2026 16:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770396286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Iae96BpziYNnFm2n487MAGMR4usXUTx6hjnk1gdR25Q=;
	b=JH/1Buh9Cc1f3JOr906oTrqrh/dYiBddpuwqF9BYPcziDhvEKyAB9ysER9Qh4JzDykkLmx
	JdwhkYm9kM3dcxnFOqDz9JN37VDvRXMp3cCgNgaaJQ0xN744jKAnzoLqyuyS9dgJU5ev+5
	QN3RcBKGh8KUfsajAZCWi9kFM9+ZnzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770396286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Iae96BpziYNnFm2n487MAGMR4usXUTx6hjnk1gdR25Q=;
	b=rGI5wcLTyIMQqAfVk7fg6R3WgI0Rm2sJ0QrtuqbQqMWsR7gaZy/GUcAYLXkveJnYqvfCka
	Wp+EfmvwphOd3hDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770396285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Iae96BpziYNnFm2n487MAGMR4usXUTx6hjnk1gdR25Q=;
	b=OftyxcvzQDpcEev3KVbkvXMk68RKF4C79Faq/fbEeUh7XJTj9kZcSGe5I4YN4Wcye5I8JY
	gSGt4x511DHCMongASo2ueKQ5L+7c3dct3vtc6z+K8ZSMUksLRWxaBSu12Rs/Z8w1sEt1f
	3bMblOQE0WPO/KnswYS/1mI+++Qr2Fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770396285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Iae96BpziYNnFm2n487MAGMR4usXUTx6hjnk1gdR25Q=;
	b=S3fPNZXsuHLZeEjHHyezS7aJ4YF/x1hAajDxPS78uskpkGrX8zCGqKoFnnFSf4LLoJHeHv
	ZPVhM9fx+WnE3rAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 739CD3EA63;
	Fri,  6 Feb 2026 16:44:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Itz5Gn0ahmnxVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 06 Feb 2026 16:44:45 +0000
Message-ID: <699982e5-6660-4e48-be57-3ee7326a20d5@suse.cz>
Date: Fri, 6 Feb 2026 17:44:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-US
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Petr Tesarik <ptesarik@suse.com>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
 <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
 <pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir>
 <665ff739-73d8-4996-95e0-f09c3e5b6552@suse.cz>
 <2abde505-1e35-8d74-2806-7a3cd430e306@gentwo.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <2abde505-1e35-8d74-2806-7a3cd430e306@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 73D0512000B
X-Stat-Signature: yhis8hw1bouw4kj8ixa1nwizc3ufbd8g
X-Rspam-User: 
X-HE-Tag: 1770396288-565107
X-HE-Meta: U2FsdGVkX198kxVHaH/XPic6sv4Vg0MijNWvHq6cT7nv8BJcfblGnIG1q50C2Gehc3D6CMdYUbfW6JIvzDs4ZpRokb7xaScy8A8GWlTRkKkbWwAb65075tUCQ87013Z9d2Y0HST1tktf+tVb0zPrZyFsS0ObOTPo9+vbkhFozi/+xyC0dAj5mJk7ob9wlFSSTiSGm8hu5sUBfD6X3iZnbOztBOWjzYXiIHQioCfhJyg2hOiGRm9fqV4ge+qsevq1nXHNNDijRTbcLLSKe+s8n5/TLYWLQ4SXXebEG3tGsvARXVMzbfCcj8VPVh0MmZyyS4nWevxDDRwlPEYNSXi6uIm18TROJhSz8s9Cf32Jgp8OEvh+nYgcYh6bdStRMsy3LgMwLd3DZVNU6/53FdWc63low3EZ95s1P8LWZ+OR6aLTlfzaj6onASzcYyK3HH01HRFIOAgUA4HQ3w4dGLi7fd5ZzA3FxDgnA3wGpZvU8a5UHGtQPIrwjujyXRbW3UESPYWu/CuFxPUxzXxHYaRxSQjutudNXm9a5iEFdQTOAAnc4IBvcxvL2rOvXr2DUkxefKGX4xWJ1kN2VVzee4vlGjNIRYuEkYHGPAcZkV4HHlEDMdVfVrUpovkKFsrzCgigdT564mvSPzjOZ1lpgKh+B528UIo8R7gPFl5AOHwbaiPibkDVAO5IplNLX02PjV1Vrmz6T2wl6lQa1YWTXjBRE7oSY6E2QHLcG2icRO2AymnZqCs+gC83PSW+QbcBp5wNK3rsKxlHpLOx7l6NpMrn5vXNA5hKHqyKd7T3oAL8g2W7fP1Fq516Ld0n8l8GMrFMcgmXXJuneW5DVhTE61K2GEo1XN701AKiO9BodvY3z2jA7e2xuH/dg1i77cFkyE3Y9aIs/soalPsv8sJjAsu/N+EdziTf68by2X0A/OBCM96YxE5aHdM9uvTXeEtERY3LETM4aFezuFIXyswD3Vx
 VdpPYsC/
 1gk3qErLIuIaprYIuQL89l13AUnPBGgiHw3Rl/vXqWxXeHQpOU5Lol67q7cGHGWcTk9h9ulEXbQU+GaE0F/vFGdbKz3NcW2H889gn1n7SPjwvj5BuJxb6hE+nF7D0BtoVsNA1rSyhHoTD+Y3oh3daJVZUktNS10RUhOKeO7TnWgLnAUHwdtg6tm6Xl5cvWhMQTE/NNeaoO0SKKF9XxshR7K3MS4tuQvCU2ZVgTBnN2b91GBH6FPjwIGts9UIOge3No3rNElB8JPxA70OPfwU+2qHRDIq3DyCfCMX5gWKNEmjCqQba+de10g/5dA/VG4w/hVpSvy9HQC714bXZA8ygWhu4XoJQhFDcO2ecZQrxLMHgQph+aJg2jaQ0sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 19:24, Christoph Lameter (Ampere) wrote:
> On Wed, 4 Feb 2026, Vlastimil Babka wrote:
> 
>> > So I think the performance of the percpu partial list and the sheaves mechanism
>> > is roughly the same, which is consistent with our expectations.
>>
>> Thanks!
> 
> There are other considerations that usually do not show up well in
> benchmark tests.
> 
> The sheaves cannot do the spatial optimizations that cpu partial lists
> provide. Fragmentation in slab caches (and therefore the nubmer of
> partial slab pages) will increase since
> 
> 1. The objects are not immediately returned to their slab pages but end up
> in some queuing structure.
> 
> 2. Available objects from a single slab page are not allocated in sequence
> to empty partial pages and remove the page from the partial lists.
> 
> Objects are put into some queue on free and are processed on a FIFO basis.
> Objects allocated may come from lots of different slab pages potentially
> increasing TLB pressure.

IIUC this is what you said before [1] and the cover letter has a link and a
summary of it.

[1] https://lore.kernel.org/all/f7c33974-e520-387e-9e2f-1e523bfe1545@gentwo.org/


