Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8198CCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D056C8E008F; Wed, 29 Oct 2025 11:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD598E0045; Wed, 29 Oct 2025 11:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCCF8E008F; Wed, 29 Oct 2025 11:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6A858E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:42:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C97F140869
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:42:45 +0000 (UTC)
X-FDA: 84051569490.12.9EA07CE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id D04F9A0016
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:42:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yYmcDfKv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMSzVuNq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yYmcDfKv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMSzVuNq;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761752563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rrj//QFmpN6e/2LkQmU6PX1hLwcBM+04iiPMvPfmFWQ=;
	b=OjxmuGyCySQydMpDKE7YlI0iTfOHlLXR8N9exKkHowFKYbkTuVXKU253WfvphPnzC3rC3e
	edKJSyrICBYM6sbWw1Y8cyZBQAX264Ani/AlqLQvwXTDt3oNDuR9v8YguUA4aChtdZCiDl
	NSoPnpU/oOV05LFG//MAsIjqw93q6ZA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yYmcDfKv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMSzVuNq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yYmcDfKv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMSzVuNq;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761752563; a=rsa-sha256;
	cv=none;
	b=NiRz1ztB5jDbPd87ryCEBBQprpXjj2R9T1Q5UjQDx4LngK8hl52OhiUtA5qew8cjrCbZTy
	nJVxYUkXGubd/OZQTmXCOq+tDnOKrdu5ne5p7gmuKQkwzxfzowp3VZS7Z04QaeO8fbf0Ji
	0WUXoske9INNPMuoXqlQ4EDl4C/slrE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2A47A2290B;
	Wed, 29 Oct 2025 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761752561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rrj//QFmpN6e/2LkQmU6PX1hLwcBM+04iiPMvPfmFWQ=;
	b=yYmcDfKvpvor1cFqUi7M94+YrkX/7tR+ZjhtJtMc5fq6Un41MBt2YaTwurPKbIbT0exOY0
	q6dQWoFtogJ55kWq4O70ZepzAzyyg61lvsJVI+k0AWsZZt6cCaspKQdXuhDdfTyp/ASpVe
	cV/0PJXQ0Fkxc4QO/ef0ibImx/oEJy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761752561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rrj//QFmpN6e/2LkQmU6PX1hLwcBM+04iiPMvPfmFWQ=;
	b=rMSzVuNqjNdpyyXyHIX1h9Vq3zw7qPmSFUVbfP+wLAVnv73CnJ0+0Ymhy5hJ84P+9l0pjx
	kyZNbxQjx2wDv5Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761752561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rrj//QFmpN6e/2LkQmU6PX1hLwcBM+04iiPMvPfmFWQ=;
	b=yYmcDfKvpvor1cFqUi7M94+YrkX/7tR+ZjhtJtMc5fq6Un41MBt2YaTwurPKbIbT0exOY0
	q6dQWoFtogJ55kWq4O70ZepzAzyyg61lvsJVI+k0AWsZZt6cCaspKQdXuhDdfTyp/ASpVe
	cV/0PJXQ0Fkxc4QO/ef0ibImx/oEJy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761752561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rrj//QFmpN6e/2LkQmU6PX1hLwcBM+04iiPMvPfmFWQ=;
	b=rMSzVuNqjNdpyyXyHIX1h9Vq3zw7qPmSFUVbfP+wLAVnv73CnJ0+0Ymhy5hJ84P+9l0pjx
	kyZNbxQjx2wDv5Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 103DA1349D;
	Wed, 29 Oct 2025 15:42:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cbeoA/E1AmmafQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 15:42:41 +0000
Message-ID: <d70962f3-37c4-4410-9cfb-2c0f5c85470e@suse.cz>
Date: Wed, 29 Oct 2025 16:42:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 05/19] slab: add sheaves to most caches
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
 <20251023-sheaves-for-all-v1-5-6ffa2c9941c0@suse.cz>
 <aP67sQ2dD73iXubl@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aP67sQ2dD73iXubl@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fc8tcokxgxhzrpdh5pku4rnobx1156eg
X-Rspamd-Queue-Id: D04F9A0016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761752562-566178
X-HE-Meta: U2FsdGVkX18DJlmIDBCu+DpHGia+SpXmoymuWlziee1bKWOszK8YDYbmQTpFqC/IUGeCJlG87Q0ijuUEsFsSdVFEFCXLCWwtI3GALgIbaD1eHXA4yMTQWva9JgXv0jzE/7m8dmulXw13/8sGK3KNaj/qNOskqZAaXoT7AmdpBnjbGTUnNqxSC23+VI8QbPahvN9pnNMcWAKvK4sjOo96PG22LTuTzyII4TwiHaznDzG3RnKt46DtdMVsU9O/cNGXpQZPuKSec7kE/5c9R+ja2dB2+ORJY/YE+P80/aF+mRDL7gnQKeZwwQTJnkcmmTVecXGS2XHworsTND8Z7xC/oJ+mdxqjRqUg+UmeotGaqfG3V/Ai9YMZyxENU/ZJqVS4oMO5bauNeoqg0aP+06R5ZmUIh24OyDdrIm2Jw0JkKmbKVNMNSZtrsDMujHbhebOUveFP8/WgA6/+3nAX6bw+WPxZ2NyQuLUYU0bNTosvelR9TdxfAyvOcJu/VVll4YVU+EPQG/NaSErLTYF40w+pOLO1VVQ+tUfIttFE9zdjVwgCvQ9ildRLrEfONBw4LAlZpiPTvs6Be8zmBdxWOPx2qBuE0BQQEFK9lBDOKCMJNs2uOPvkkNCWM397mA/L8/X2zrG92Hgv6K1rpqswsEkzfeoW3yAb38a5jajdc+NpBKmfDqNdAzyCeB+EeSpek+ypiCUyQVTG/Zmk96fB3Z17SVe/w2/5ZdzAM/jN2k25nlfUG8atO0MdR25bjbGD4nd+GjVNWer9NVNODBdu1biuBAi3CMkjU9ut3S2bDXLYZ+3VR0FOKbIJhAz4YPMiiWflelDxaFOZTKgNfwp8abItjhEIFBA3T1GZyCT7gAVuxTmcSAICERDegLY7VuzWIdr2UUrXi420XhwDV5eaMZbjBQptO+aEyTpSmfFFYyOBdHbaEwK1WEc0LqgrQETbD5FH1xHr0ZhR+RyE+d8Ievy
 NZarxYC2
 iiKkfseJpJMd7tXnyfeEh5VOy7RTVITHOE2XboiuPxpwaOfC0rFOMejhO8prCDVM9BGRHxPtDnVjOTlIFIXdVAFTuFQ1ZJRwHRIlqA9W2kjp2YS3Lhsh0BgbHi/0XqqYnG9fPPnhHz1iWYOTM+j5mdCaoqwpzGrx2gP7B0nbbfSA1gQYDZsIzdqnWgKxlwCbddLshJdV1hLhHcmL3mtgZMxeBxc+0qCYBfLiWGrpO8Ii8bC/aoX49GyNFknfQj0LGLpxr86NBCjgyWWIilP72TfchWd2KqVCzpyS+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/27/25 01:24, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 03:52:27PM +0200, Vlastimil Babka wrote:
>> In the first step to replace cpu (partial) slabs with sheaves, enable
>> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
>> and calculate sheaf capacity with a formula that roughly follows the
>> formula for number of objects in cpu partial slabs in set_cpu_partial().
> 
> Should we scale sheaf capacity not only based on object size but also
> on the number of CPUs, like calculate_order() does?

We can try that as a follow-up, right now it's trying to roughly match the
pre-existing amount of caching so that bots hopefully won't report
regressions just because it became smaller (like we've already seen for
maple nodes).

>> This should achieve roughly similar contention on the barn spin lock as
>> there's currently for node list_lock without sheaves, to make
>> benchmarking results comparable. It can be further tuned later.
>> 
>> Don't enable sheaves for kmalloc caches yet, as that needs further
>> changes to bootstraping.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 


