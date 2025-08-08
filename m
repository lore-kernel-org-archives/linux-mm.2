Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8A5C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 17:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FACE6B0099; Fri,  8 Aug 2025 13:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2316B009C; Fri,  8 Aug 2025 13:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1526B009D; Fri,  8 Aug 2025 13:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2006B0099
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:17:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10EAE58B8F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:17:30 +0000 (UTC)
X-FDA: 83754246660.03.DA3FC74
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9F4871C000B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:17:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0ZXDrScc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5ZhJrIII;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lajouUj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e+5rQaJr;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754673448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sVBcQBRTFhVWNufYIx2wletwkPL25cTchws8/srXrs=;
	b=KDGnOPkvKowp4vEZTM1g84xaOLT7FLG3/pvovqNEu26U727+kUM9LuZ/Ma6TWpKEA0oKYJ
	4arhnGbirCeFhyfkPP06PJmdnmEZOrzwxfNlUhoVdTlGN6mUFVLtga3e9qND4d6RXFAvEs
	g+1TPlHl5rQyuSgLsk6Nk+IAH9i74t4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754673448; a=rsa-sha256;
	cv=none;
	b=B9yEcrS/90qqDquSVxqCGegv0D5nHCzPOk5JQvnaVMYiz/9E6MH28YqETYwPGRryN/UCoN
	LfdSTq1uAavUXvszl6Z/gsCoMnOQIPBmwLXpAknoD83NzgTsz9K99g7p5Lq4FMzMcQKOuE
	a741TL6UmsgdwnI9kE3pQVZsFsDS4QY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0ZXDrScc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5ZhJrIII;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lajouUj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e+5rQaJr;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA07A5BE02;
	Fri,  8 Aug 2025 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754673446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3sVBcQBRTFhVWNufYIx2wletwkPL25cTchws8/srXrs=;
	b=0ZXDrScc24nNkhxQplNn8XxoOUKxXKLOUhuw5xs/A5yMNau0mehalMWxitrK0q2FBAJTbm
	UmEiW/yGVyjqS0c+/sXlqHyUMT+ImRHCa9xTBIY38LGqwN9aVzOKH7K8QQfJqW0vOjDZFi
	gQ5I7RPsjiL9ZrIG/K+/2TvFgNdzkt8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754673446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3sVBcQBRTFhVWNufYIx2wletwkPL25cTchws8/srXrs=;
	b=5ZhJrIIIyy46L5JzpDmNSxVpFVKwb5v5bjbqLUjzk4aoqlcxKp+UJoFzXJb8LxKy9FGg5C
	OVCG4b7hDNgQDrBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754673445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3sVBcQBRTFhVWNufYIx2wletwkPL25cTchws8/srXrs=;
	b=lajouUj+L0g1MIFEhKSK6pub/mGFn814IPHjA6Uq6HX2GUJxkPqQQu9NKO/Mh5SFJ5f5g8
	sPwoZqUyqFxNxTttK+iupo0IZU0/14KFmJ9crp6AHU4jJGtc6UTXyaL4rfzvIrzC+q2TK9
	V8l9+Rp2Yz77VYz7nAsmxRnM3I5MkzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754673445;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3sVBcQBRTFhVWNufYIx2wletwkPL25cTchws8/srXrs=;
	b=e+5rQaJrd8YoWJVYcgP8mnDuXZ3Fi0T57MPjtETSE58YzL59zLZ/1t/KIugHzbtU+9u6Jk
	TeK3bPak4l4pJmCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACEF413A7E;
	Fri,  8 Aug 2025 17:17:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J+GCKSUxlmgrYQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Aug 2025 17:17:25 +0000
Message-ID: <b2d0ec84-a758-41ed-8aa7-91756bb14e20@suse.cz>
Date: Fri, 8 Aug 2025 19:17:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 2/3] mm/mremap: catch invalid multi VMA moves earlier
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
 <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: ctwujwej81n8ptejjw6eh8e4r6m3d1rq
X-Rspamd-Queue-Id: 9F4871C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754673447-981922
X-HE-Meta: U2FsdGVkX18GXsb/8JgHPv2igGiwMoc1t3pH2FqTnvLYegw0IHwP7QfwgExxtJzdzXgh70/3QHvRxH9RgS251grSTQgoHhBBOspKUQMTtEcwfbp8H4YL4AxAAyaGcbxa4/WzEP6hT/1ZF6o6yOdTKfEoR3qT/Eiz+1g9mnRHV4N2EUjkual5zhYRX8CoNx3yTW2RlezKNAv4un/M5UF3Sx4ii83Dge+BwYYkD6OIEASJH+40EXhFfjwoNTPtSsIbg6KJuy65CIps6skl6y1KYxtnzHu7/4VWw6HcsdfVvDcDcBjpnvgwwCml12CfAWn0I2pLJsFgdIacPb903JFfkjtIWAbzf9nvD+J/OLHZGvwBR4S1xDG5m2WGJJB6+m+4M2EWF6oSyLteCq74TlM5mrh4CeUlq5P+nmwKe/3mQAWA3n8+XeFsT5NGv5JZOvAXw1cY8sU+2zbLcSgK/05fZVDaQgWu2QSaok7BIgqHI1THzczZ4UWcESkOCVeLD7DK2GxrANCVP24XphtUcD4501pB+nnK9CpQuYiv+gXFbpi3A9o5vaccoC3bU/ATHlUSNZwUQbKTJLuwyFJw07pQq9OJACdwHqX6cSG5PIyVNnrKCZ/dnbOqJRbxoT/m8LPvqciLOfE0Ek5hUUzYyK1FSHi8ZSfip5bNmC3M+lAB6qjdXcJRs8MDwZw6eSV6QfMKeFouak7UWwhDhDtgJVPKXHx40dblqjbKdZdtBDDAy6qWDvXseDuV5fFORQJflMUAosq4wsuHthDhkSkApJmn3v8T1smV/XCdL0pAiKs8BJ1KIADmiqfZQJG7N9PLCAeehA8w+8t21VnQh/8xv59DWLs9EmNasOibYmuEoxYzz1+/M0rsMAewgQ5KVZ3COpwo/lrnnbK9IK6csBHxKBWeYpdvoyea/p55uaBqFWCatF5EiaJt1aWgkd7nlySfyNmCaKuxLaBkREj+HoeG/pZ
 5OoWO4FQ
 IyJYMQAyRrbG4wJnzoLbmXNL1CUBwFRPU9+x6WN8MDTtpC71dH4oAhT8lqEdTwIIZU/E/rm1jBm150A0orJbWHy8p9DzI4qwPX5q+4OsWbKhCO2r3Epeu8VDeSO6xLRfh+ih+UYVVwmnKmZVK6NQxh3D+KvYbVhTpcs3WPHyH56jnNWP+P9MvMHK/erIonzFjiKHMQESOzQJdUxf2HzlIMshGJnHHBI31uRboUwAmZBYYJz3//xkQHW1kGx0EbrweqPOhrUbFYuB0612vTmp851hbHz+zCYN+/64JsruLN5vaAlHW+1ac7Vj4qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/25 13:11, Lorenzo Stoakes wrote:
> In remap_move() we must account for both a single VMA case, where we are
> permitted to move a single VMA regardless of multi-VMA move eligiblity, and
> multiple VMAs which, of course, must be eligible for such an operation.
> 
> We determine this via vma_multi_allowed().
> 
> Currently, if the first VMA is not eligible, but others are, we will move
> the first then return an error. This is not ideal, as we are performing an
> operation which we don't need to do which has an impact on the memory
> mapping.
> 
> We can very easily determine if this is a multi VMA move prior to the move
> of the first VMA, by checking vma->vm_end vs. the specified end address.
> 
> Therefore this patch does so, and as a result eliminates unnecessary logic
> around tracking whether the first VMA was permitted or not.
> 
> This is most useful for cases where a user attempts to erroneously move
> mutliple VMAs which are not eligible for non-transient reasons - for
> instance, UFFD-armed VMAs, or file-backed VMAs backed by a file system or
> driver which specifies a custom f_op->get_unmapped_area.
> 
> In the less likely instance of a failure due to transient issues such as
> out of memory or mapping limits being hit, the issue is already likely
> fatal and so the fact the operation may be partially complete is
> acceptable.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

With the updated commit log,

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>



