Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB92D72353
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E53B6B0460; Fri, 23 Jan 2026 03:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD2E6B0462; Fri, 23 Jan 2026 03:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC8F6B0463; Fri, 23 Jan 2026 03:54:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC7D6B0460
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:54:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9466C58C8B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:54:54 +0000 (UTC)
X-FDA: 84362618508.02.8FD9F97
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 18CAD40003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:54:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3B3Xn3qm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4cZ1qBoU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IpY6C4ds;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J7fXZghw;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lolhUMXL1i76ejiN0nNDsWdfi8cnvehcmMYWyLKNk88=;
	b=BKLOAkPbHtMksMJrbePEA3PNSyQZ56Ktl9j2AgKxTYwXCreR8t4ocqum8lqO1jQiMCQ0N2
	afF0dDtypSOrKXcOTgKzPTRTzTHS1UDzB0kA6YmA3ez/dgAIdh06lCbhcYFwMbPBoAzQyM
	Llb9S0fzefkTMdkO+z70uVcDxnmfA6w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3B3Xn3qm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4cZ1qBoU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IpY6C4ds;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J7fXZghw;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158492; a=rsa-sha256;
	cv=none;
	b=4E4rGbdYd9d25wzQDi3osLq5pEBdEqw4B1Aqr/vdYAnUzVkUNQ0ykXPQIiX3QrY5AvkiBW
	ElgaLOJMy+db4FEN8zwDW9P45AZ/Nmto38D+mBe4QZqmhuU7Lg6jLg4QLPdGWFUok53vtg
	K8prkwB1/URYXB5hT+fZ89jWSgJMONA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 857893378C;
	Fri, 23 Jan 2026 08:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769158490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lolhUMXL1i76ejiN0nNDsWdfi8cnvehcmMYWyLKNk88=;
	b=3B3Xn3qml/14IloxJpiYb1hCN6sRkBzLqVqVSk8T+nCJJ4fZ1xLf1HxZvq1Z5pBxAs4fJe
	RlnTfUjpY7Rx3oFFGpwOggm/sZ7YF+lCxExN3JijwsH73iuGcfRVVWD3tLHocwcSpSTkuK
	zFKhX5Pfip8zAE03eIzsZfj0yg+WXtQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769158490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lolhUMXL1i76ejiN0nNDsWdfi8cnvehcmMYWyLKNk88=;
	b=4cZ1qBoU1lIZKPBl074SM5tSHjz0ioTV8mFN1k0+K8aS6PMnTONq0D/8wDcZTbm9Ca3VZk
	r7xDinx0WvUTmeDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769158489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lolhUMXL1i76ejiN0nNDsWdfi8cnvehcmMYWyLKNk88=;
	b=IpY6C4dsoJJTSYQph4hW0k9X+EbHJDxoCz+rRkh1v2L7Jio71t9nFX6wNSywKvDOb9dRNl
	eqwyGrAxMRLSln4COXVaS8tdiu2wEgJXnhk00jvuJdsnGk9pOyWtJhq0yL80d3jchCVtS1
	cqji33SInWcVIiWxLNfmf9bJ4BYYPMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769158489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lolhUMXL1i76ejiN0nNDsWdfi8cnvehcmMYWyLKNk88=;
	b=J7fXZghwPOb0f/jbWFwF1d4Z+MMKneUI/+aqFp6Kr5QGZBCzrll9Rf87RvaDshMOunu7jw
	apobb6GR87IFRfAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 574111395E;
	Fri, 23 Jan 2026 08:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jSz+FFk3c2k3VwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 08:54:49 +0000
Message-ID: <04bfb078-be50-4dcf-9838-f0ccff352d02@suse.cz>
Date: Fri, 23 Jan 2026 09:54:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 05/10] mm/vma: de-duplicate __vma_enter_locked()
 error path
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <2611b2b6957b7aef587e9ae62712a888159dce60.1769086312.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <2611b2b6957b7aef587e9ae62712a888159dce60.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18CAD40003
X-Stat-Signature: zi6kpxeqix8adfjnt5hp3z5roosgg491
X-Rspam-User: 
X-HE-Tag: 1769158491-658480
X-HE-Meta: U2FsdGVkX1+RLOjdGZBNmRcEN6d7OQc55ne82Qc8rME5RgCWPwuOcdjG3cHgin4vYwdYnCw4itqFWR8N03jhd0PpP4tnqzPQCRInGYBXwkRjj1pL70RQPKJz4NK7bL+YHblE8VjmBJcpLRQGzs46h7dV/qVpdNLl/Uh8UGdOEW/fs6y53Wx61bO5fyH4KlkhvjWczbdFqASpiK48mVPsgQbXEd37MLONvF5iqdXCMrRI0IPIq7BYOASR7mwUZqM02duE2+53cJ/HG3URt4pc/H+C0v0bQ0j0hEJuDAX7oUEb214zh52qp8lzsgghvv/JVZ5xMO7DJxmf57joZdJZV1afP6cXn7z+8duusan9Npbm3Eo9Gh/KDnMi/Nv76kln6NnE5vyP4x646MfaSCFbpFXX4SOqvfvcNTjZkq4HvfKR9Tt+qDh5QzQVRqXKfm9gG+AhpwehLczsL953yMLnVhzqxCjWbDtkfB+Ggv8PFOjcEO0AmUMLX0BTRojaIrgvDP01FxHhqkRamfQHUu4MtCYBJ/GRYrzJTfY7fcwWEdosV4nWQQVZQEsgE44dqbMkYq/EcFMpo8roNAMWIyOPwhQRWvdN67qBlwyLS4wuSkBp94OtJ+m0X699nrpdqfOsnqa4Euf2jCljltrnVY/d/2QSNISLD++N57+sga29JpW6rvv+QZOYlcB3r62M12vrTkifzSsjg18qARY65zl4/rnMPK9IQlfrUMrsy7gD4HGqZrnJkEF+XmwJC9tLs8oyXhz0dwrb6E2r9d/TgeFhoJDvHKnmHLn6IuLFTHw6u6LAHrMGaUtGB5jcSCnL7Rw65GJfJuHUs7QdNlo1Fl32yxnXFXOh2nw+1nkwOJXV1JYWKnoX+E8sEKEnZAMVZlb+TSgMKzmxyJuACoC2qkwzX5zAC8aP4TzvzYI9cB9XQXO1adzoxRLALnZmaVkvsIfWfA1S9KT1JGcpGMxbJ44
 7QExU4Ht
 ZJXxaXrSOjnSxrFGAVyVW2WqmAKi2NuuvlAHz40WG9qf8pjQ80sH4jXBgnVRL6tfz18UUKIMUFROOCCWDBQcEVPIt0o7iQWA64nViQu8b7sNugXmOUw9c3R8MK1y97GS//lE2GWFkCiY+rzJ4MKm9XYTN3Z8hn383g8G1RIe4FB1vNdiDqBYTcU4zbGfp8PMfYcmzBX5ciKdB+CQYvksQdmM8p7czvCRY3WpdIje4DyeqApL1hSYR2PoRifRW208orRB6GT7ZOkLqtjWxKIFEra/h6Y0PhzZUSqEf9tW5dIPTH5Poe2FZW8GKORexwFskoCWfCo9/bSQaWjHW7pyVn1RuUBok+gFFOCygJGVafGsaWXx4y9OR9H51r/TCxwxeUXovbUwin86nmEGPX+KrwcfU8xfagUIFsK1f3sBOxZ7YO7GJ5knb1s8GGeza0KSjrK1lkA+0AE0k+meAaUvouLSwPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 14:01, Lorenzo Stoakes wrote:
> We're doing precisely the same thing that __vma_exit_locked() does, so
> de-duplicate this code and keep the refcount primitive in one place.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


