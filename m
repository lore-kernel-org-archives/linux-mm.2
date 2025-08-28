Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD2F5C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEAA96B002D; Thu, 28 Aug 2025 13:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BEA6B0032; Thu, 28 Aug 2025 13:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964776B0062; Thu, 28 Aug 2025 13:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 843DB6B002D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:21:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29D4714030B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:21:42 +0000 (UTC)
X-FDA: 83826833244.24.097D27C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id A38CF140015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:21:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nThzlAak;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gMZ8Q3pp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nThzlAak;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gMZ8Q3pp;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfCGw5pM9uR39krOrwg6Sb8/Khvwk+UK0gyOoU00y+E=;
	b=MajC8MclPB8lVT6wXPiyKhMNwCeQYTo9McqOjrXzdxKr+8Zf62VrZETfid3C1uFz6vkFmo
	GYrpsoxzGMU0kj64UDDG31rIhK9gK1PrTcEOCc+DIIVaoxbODZbRbxBadmfRG7FRWU/yPk
	HGzNvxhQ1bK4J57b9tPHovsXfA+dFYI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nThzlAak;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gMZ8Q3pp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nThzlAak;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gMZ8Q3pp;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401700; a=rsa-sha256;
	cv=none;
	b=mO1Dmow67KS9Wmzj1j0jWENXzJM9tqt1lRpDlCtDII6if79Qn78SA66s0PezSAZVcUYUu0
	0gzr5m3245qbWM4K8xUt20j+z/pLCqqic7RJtrCzzxdWbXL21zJ1AJ9zAyvEJvjOG7lt9G
	XLlVog+fexgILIU0Pg542/D8DNZ1Nvc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E348520B13;
	Thu, 28 Aug 2025 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756401696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JfCGw5pM9uR39krOrwg6Sb8/Khvwk+UK0gyOoU00y+E=;
	b=nThzlAakhU+/mXpQsgN6BwB7cAslJUe7bi1xqrUMQBq7YLMFnJDA62cOUL/zsDQTsAf0jE
	HHTVuwRpuNoPqftu51KaX2lDj9+0+nSXZ7pfdy+3ziVIV1LEWV4BTGd2T6fHZx5rQ2DAez
	MIgYdpVW64Umsl0TEImKU1xauWQa0wk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756401696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JfCGw5pM9uR39krOrwg6Sb8/Khvwk+UK0gyOoU00y+E=;
	b=gMZ8Q3ppMFtfMmsmjigrEMuFBGbncgtQ1oUhGhYDVPbc7rZZscZj8KdKPmi6OzBZrH+NGg
	5VirpOXVmJQjPAAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756401696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JfCGw5pM9uR39krOrwg6Sb8/Khvwk+UK0gyOoU00y+E=;
	b=nThzlAakhU+/mXpQsgN6BwB7cAslJUe7bi1xqrUMQBq7YLMFnJDA62cOUL/zsDQTsAf0jE
	HHTVuwRpuNoPqftu51KaX2lDj9+0+nSXZ7pfdy+3ziVIV1LEWV4BTGd2T6fHZx5rQ2DAez
	MIgYdpVW64Umsl0TEImKU1xauWQa0wk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756401696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JfCGw5pM9uR39krOrwg6Sb8/Khvwk+UK0gyOoU00y+E=;
	b=gMZ8Q3ppMFtfMmsmjigrEMuFBGbncgtQ1oUhGhYDVPbc7rZZscZj8KdKPmi6OzBZrH+NGg
	5VirpOXVmJQjPAAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B633413326;
	Thu, 28 Aug 2025 17:21:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wG0oLCCQsGh9VQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 17:21:36 +0000
Message-ID: <ec2469aa-5586-4169-a8d3-2f768fbe0ff8@suse.cz>
Date: Thu, 28 Aug 2025 19:21:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yueyang Pan <pyyjason@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Usama Arif <usamaarif642@gmail.com>,
 linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
 <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
 <5ce6yn4iml5tk5zpf73gbxk6z244bkchwuxfpvuervyh2zlqlc@7sanekvjpglm>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <5ce6yn4iml5tk5zpf73gbxk6z244bkchwuxfpvuervyh2zlqlc@7sanekvjpglm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: upfzmgsco9ysm6tmh44rfho8tn3acd53
X-Rspam-User: 
X-Rspamd-Queue-Id: A38CF140015
X-Rspamd-Server: rspam05
X-HE-Tag: 1756401698-549565
X-HE-Meta: U2FsdGVkX18o1af+IMkgjqkNmjVt7M8MGOgC1W/biBPzWeiJflCmjEL93C91R7vS4+qxQQ8kUeQQDMCwfx6facoocEjEZAtFRINvseZkQkEWb3vcpyHiJwBXcy9Qnmtudlr/7CbAJyHPwKhOl3V1ba2lwNPgKphz3IMpRrblgXIdtjcgLCKBhcDrgi2A6dWvAvQvKWPT/YoajObzKYwYP2JEYPDTpt5X760PfQYSn9ALHAqmIbtS9nbtviuoRw+xXpsSBO4xO9LdSNn3WQzelYF5m6pzolDXRC4YesHmOS2zDlZJqji30t95FNcmWOuwYqwPSPJIYdGFTcecl22E6NZ3fYLPMUdi+xEWu0UwzUKEsTYAk4jA9MxMnPUaPkS9ax35jngc0ZG5wGUdutRd0iDIKhpjTkyQEnqmnQuMv/qe19iTGwWI71U9PDwtsm75syRpBE/DwEmVnuTZJRd3Gfq0b/YZN0NLCb6musmr4X6i+Vn4I7CJgiK95Ob6Du/bz0ha6U3PqiRVAscFeXiQ7NuMqK1vVwmaK3/YfUwNd0GWDAK5k6L8rb2DDvz2eQPEkUG1b+doXq6UnfAAzsdN2WY+vIoT2mC+aGa631HmYH9xs5tDEblkEoaH996+qbnmWWSG7WEGLc4TfgnhX7XEWrBwgkMxAwipsdE17gftqYg0GLpHG6vorq/iISvNhwfQcM9gLtmjkC4oIHzDnV4q5MgiW5sZEqiOyc4eOMIIVinigB/RKEWGN7aeww6zR+Y1WkwAFHK/YVJ520weoQpHMt4fKfHLZGB/FxGFD1de6ncQdMSmA/c8lgd23jlrkkyGbtuUD9PieGfXhFoVgMqKX5TiINjMiEJtuCmTPwQJ1bPqqHvUfXOFLKKAsLBJwYKjWomX5TxK0UdA7oJp15SCvLd2WgS2Pf95N9s9U8KlQ5mKaQyGhLJ1ndka73chY3t1zbzFL1T6OULhwwX2suf
 ya/4cQ2P
 XF2ZNoBlJr7W44NFi7geV3QbdbYDrSSamXNvbvnD9IxKL9PstgiWTwvQDSaGEZYS93LbFcdkxB+1RPElH9D+h8SZYEmX6O24hLlPxRDE6U+HK1A6goRCiIqVvxAgM/JjNkzAgmNzDatVvybPMvHh5ia7OjzXON5HOoyPzNhIQuUA4Arx35L5rY8eCBfWnbhavKeEZgS+IPK11JyQPApAYPgt2id3l535o4znRR6uabAR73nkAZeytnlNLIxPWdWQbzJ+goLgGb9h/OzMBSiA2gEyLnBrERkX+zQqDSSfFI79I6O6WsPBzaVyMBkB9/FUQfH2AwNZUQLAosTw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 18:35, Shakeel Butt wrote:
> On Thu, Aug 28, 2025 at 10:41:23AM +0200, Vlastimil Babka wrote:
>> > 
>> > I was not aware of interrupt context before. I will change to test-and-set 
>> > lock in the next version.
>> 
>> Perhaps simply spinlock_t with spin_trylock()?
>> 
> 
> Will lockdep complain that this spinlock is taken in non-irq and irq
> context without disabling irqs?

If we only use spin_trylock then it won't.

