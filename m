Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BFECA5FD7
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 14:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA6B6B0005; Wed, 21 Jan 2026 09:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E196B0088; Wed, 21 Jan 2026 09:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6355F6B0089; Wed, 21 Jan 2026 09:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E58F6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:43:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E699160496
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:43:34 +0000 (UTC)
X-FDA: 84356239548.20.BAD6723
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7FE1E120010
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:43:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0xxDTGYP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UWFlwboY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KEs+pPW8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C6xIN9nM;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769006612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmVjSrgHwt4rC/tyfPn0I3pmKcbRZfmv2nxAbVtf+zo=;
	b=K9NkcvFFyQZUkjbz+S+dc1dpywepHuGz1tTGXzit7NPnnGR8ZmpXgdnsDpXmsd397G76FG
	4R26GyKpy7Z5HUD42QWbnxbmR84FXysurO+67lSjIWSZKIgxhOrJv9XBgEcDynSRqr7NyO
	VRuip+eJjG8MhxUkUGzCKdhQ6lJU57g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769006612; a=rsa-sha256;
	cv=none;
	b=HiDX4xkl34F/aNkmAdWhInSGBGRr/Ma5kFcP+TLRXhozfIDYFkWmi9kLLlPpWUxwzw7TMf
	9Xb54uE8f9SMZo/jsTl2wgQg/OdLPUvcwX3UTBH8i3Me0QJ9JsgYFPcFxSyjt+017B6e/M
	kgjGPRTrmw7HgPC7Ehwj/b/RJWw0gRo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0xxDTGYP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UWFlwboY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KEs+pPW8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C6xIN9nM;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EC3C45BD14;
	Wed, 21 Jan 2026 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769006610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EmVjSrgHwt4rC/tyfPn0I3pmKcbRZfmv2nxAbVtf+zo=;
	b=0xxDTGYPXQKhBMOzVZp2CslVUV5XLo+2lm2ACuNG7skbzPzCIaO7hXXxQg0Tar/8+uWTFE
	vCnP9PMRc+z3zwdM+4QQ738I74Wlhp4cIup+npvq2fpe1u8sRrtJHoM4ne//1yVkzCpFVY
	JK+xfI2QgRu5Mw69hY/Mv7AySzevwqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769006610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EmVjSrgHwt4rC/tyfPn0I3pmKcbRZfmv2nxAbVtf+zo=;
	b=UWFlwboYs0YvRIlh31DQTWFeUA7pM/E0HLgqtZRCB0gJNVW3sG+/JfJxqlRFm0QUNLLNrX
	fSxwnfZcT1E2rBCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769006609; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EmVjSrgHwt4rC/tyfPn0I3pmKcbRZfmv2nxAbVtf+zo=;
	b=KEs+pPW8O33d+5UwGK2eOdlBkBRjm1d1izBvsaSjQM9lyhVQXA7RLivL+jZtOyLSsMZ55C
	d+X+vHq1lWSGW7JajilVke6PbGqESWykCOHFIM2K+2Iuas+3d9JNZIjWqO7iZkwCU4SeMi
	7Y9/APDvX7/co61WCUPqpV0LTWE6Am4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769006609;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EmVjSrgHwt4rC/tyfPn0I3pmKcbRZfmv2nxAbVtf+zo=;
	b=C6xIN9nMGdinc0lkImj4jyQrmR+rXmglJ6v/W0+34dfMbJtt1tq9qUa7gpnppo+ouysww7
	ACXsi//VCPADekCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C90643EA63;
	Wed, 21 Jan 2026 14:43:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gXs0LxHmcGlxeQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 14:43:29 +0000
Message-ID: <afc38741-d647-4b28-8ffc-c752ab5bb5d6@suse.cz>
Date: Wed, 21 Jan 2026 15:43:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
 <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
 <c17d4413-1ffa-4d3e-8d87-0e7c2b022c16@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <c17d4413-1ffa-4d3e-8d87-0e7c2b022c16@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FE1E120010
X-Rspamd-Server: rspam12
X-Stat-Signature: pskbuxii6oqagomiosrwpnxkdsbghqfa
X-HE-Tag: 1769006611-835740
X-HE-Meta: U2FsdGVkX1/4qm7WRqBGkDsqTrkwHl9U4Us5j1UQ1Ssq2QM1JLrs+AaXJk0kBx9v2kF+qQwiae075sh9mLqXCd6uaxzNt+bm/lETLI7tTsrakFrbkEGlpQLGBzLLd+WLV4SiOeZ3RcTcF/Ih2+HoLz0aXuBh5N2sUMHuyI/Sqah2OUI40vdDrKaORQvvFYlue/8qnfkRlusJ9u3G7VG5eHVRLGbEWQX/WCWJdk8jGAlbskiHzufCAq55/cEhaLAXfNas8YM2+KZBAUYbDrCxIjeXsfzrgvLkzk4lQWxc+yvJ6yfI2VFZP3jipM5pSqpScVrqgJ0tkx0DN38ErBBJppmpkQth8C/AEUNIR8jfY+2/8B1fX/jAKWFLzqQu/qdGvCKXVqDytUVpes3ypXr0nh1gsU7GNziHCjfaC+4+WxMZ7kDfFGhcyUbNyokJz/ecJVL3x3bnBqzlS0v99e5e+PJZmemUe6fEjJ4MwhE0Mf3wmIizTyStg7HN8Bdkn/V7co9caarsS8ydc+g8hiZ0HmvBNFZNXBBitLZjQmYnQTGs89nyv4+n4YDZC2SbkBO02E1iCuEq+Ir4skx7iwqWYwRcarUqX7VK2vs0P/oENUIR86DYhAF1nc0L5mtGyRYaNd/JnrVLJ9JO4xYssGBOD2+l3Sk6m7BHUkvlXfxFjU1AycjeTeuk/mFw4pqByf0RUcLHeBQhOl5o28UrRJZ26kSlsLQL0i95iDOzp7dyhkFImnfCBKTq5Yv+i9tKch0x4bb08OqmkgLMFYeAKzEbXQxp/lR9eytIL0m7ApxR4KYoOaGGQiDYQ8fNmVaE30kSH296pvAVsY19aAT4iLv5SIuWC8FrMb+UtZe1zIhJPFD6YwjcX7PvBcaRnzFznTTpbqN4Tz3qr296Fdjqr4xSWqZpvaxdN6YYLSZ7aq+/sO2uQhr/87Dkv5ecqEEK8XSntlEoVSG1kd5s/drRpG6
 FyhpkBgD
 uK51IjbG3zbo2UhrTL4FWuBtKcMn3ftrcRnqmDMq3JFamKDhepPOQ8lgB0GYGjiAEXZKUIcYRskHg7BxuDRzMJ6ZEn4EBDGigfvn1XNvxme20o4teTYqkD8awNRLig8OhyOPE2XH5fUKAyPM9czar/FnQUJm2yw+LOvTI3JxGWkX87N5PbUm+o0CHrNpyfaVwanOj8t9PMtzwb8KC5Ar+QSP5k/mWkQ7KY4wlvGoVh1I3aLwSg8xTFOK1N+8gqaFluYPXKGQaSK/BCjqq5AwEXb90nO00pEkQhY7zB4ZGtd+6O2edQwTjHnqVaMJpG0mxSrng6+aPWoAaCNQQipo2IrOC486I24oJmq5TVpdGoBNLkneJoS72668CFlIFcSLvjyl4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 15:22, Vlastimil Babka wrote:
> On 1/20/26 23:25, Suren Baghdasaryan wrote:
>> On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>>
>>> We have removed the partial slab usage from allocation paths. Now remove
>>> the whole config option and associated code.
>>>
>>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> 
>> I did?
> 
> Hmm looks like you didn't. Wonder if I screwed up, or b4 did. Sorry about that.

Seems like it was b4 and did for all patches, damn. Sorry, will fix up to
match reality.


