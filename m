Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD01EA811A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581376B0005; Tue, 10 Feb 2026 09:08:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532A66B0088; Tue, 10 Feb 2026 09:08:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E69C6B0089; Tue, 10 Feb 2026 09:08:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF9D6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:08:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C79B0B9D2F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:08:27 +0000 (UTC)
X-FDA: 84428727054.29.A54E960
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6801A1A0007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:08:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m68OswU0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/A0BdlL";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m68OswU0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/A0BdlL";
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770732505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siu8SYkmjX9m2OZ+XOB/9WDUAEbPkmYm4mxtpi0S0qk=;
	b=nf7WvemFAVQLbNQ55U4AK/NN9aC7yT9MfXVdv0NKp19dR0lGzonDPzSsnNgadq53ILjtrJ
	DqC79xx5GhsPRxBFMT8hnO934vSTZ4/aSa3Pyfe+b1nOmrBpKJxmDKuVsKyzobGmfV3SJ0
	WpEi7w9fQEPjdbYkxfj8/Bts6dchCdc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m68OswU0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/A0BdlL";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m68OswU0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/A0BdlL";
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770732505; a=rsa-sha256;
	cv=none;
	b=8DfDyECT+gxQDv8yBNB+NApsfGeUUpsuJPNA5tvGJYX12eSxcV5fc2g7chdoYLFcj3GfkU
	x17LBmv0rUmjxwpNulzqZ+QASyKSbdfqNgEdLVhqmid5sAdYeTeFaGLhcJAMr3Tp0PCxFH
	rC36WASbmnlRFds1kRZxWnvy/EFY4tk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A2A975BD5E;
	Tue, 10 Feb 2026 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770732503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siu8SYkmjX9m2OZ+XOB/9WDUAEbPkmYm4mxtpi0S0qk=;
	b=m68OswU0f2LGn65lTAl3sxVCtcobw7LtdBWCAQ3M2HZvf3/2uhY8fFhvcwRZiWEAa2bSrn
	PsD7rzrLjDS14EGxvfrYqE/j6ysVzbi7Lwsc8x8zYvrRaJG45klYRC8kGPDzMulq54hKqa
	UZnd2KpR8smWh99nDexTY8mB9Itn9l0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770732503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siu8SYkmjX9m2OZ+XOB/9WDUAEbPkmYm4mxtpi0S0qk=;
	b=8/A0BdlLLIbC+brIYjwEQ/c+T+sc+qMX2XIbtOQPI4atEqpuEyTFbRde51cip/tEg97Acb
	paWg64/AFn4DfiDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770732503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siu8SYkmjX9m2OZ+XOB/9WDUAEbPkmYm4mxtpi0S0qk=;
	b=m68OswU0f2LGn65lTAl3sxVCtcobw7LtdBWCAQ3M2HZvf3/2uhY8fFhvcwRZiWEAa2bSrn
	PsD7rzrLjDS14EGxvfrYqE/j6ysVzbi7Lwsc8x8zYvrRaJG45klYRC8kGPDzMulq54hKqa
	UZnd2KpR8smWh99nDexTY8mB9Itn9l0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770732503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siu8SYkmjX9m2OZ+XOB/9WDUAEbPkmYm4mxtpi0S0qk=;
	b=8/A0BdlLLIbC+brIYjwEQ/c+T+sc+qMX2XIbtOQPI4atEqpuEyTFbRde51cip/tEg97Acb
	paWg64/AFn4DfiDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C9233EA64;
	Tue, 10 Feb 2026 14:08:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ccfbHNc7i2kINQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 14:08:23 +0000
Message-ID: <435e40be-fa79-4e57-83b4-5c3f5114cac2@suse.cz>
Date: Tue, 10 Feb 2026 15:08:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] mm/slab: support kmalloc_nolock() -> kfree[_rcu]()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org
References: <20260210044642.139482-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260210044642.139482-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: i35nomqk3k8a47gmptcef88kcaxfj5yz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6801A1A0007
X-HE-Tag: 1770732505-136337
X-HE-Meta: U2FsdGVkX1+taUqGjT6L+J9EZt6QluB4/p9ixsIjA1Bs6q/EDvb9BCrlgmtjRhvb8tYxJAUuWLmYmyFzin4kcNfL968m+5t5hO3PlMTFl/4rgxyDg54C0EbvqITmXmHhsXMgaeWoc229i2cq+nsrrPYRMWprqLLrES9ri+Hj2D/+iUC1uLyzsMs27/FC1IL7+8tssAgGit6Zwk/XWMDhNZL36cxI5aAGyNZPr4vpFtXjzGX5sqkSIXWVNEA2oOrXfI5vnynd+rACeZ2a0BrppR4a1Hy5RmI3RrtvJ5Q3//iYfepeIOi/oXMfiUPK1eGbXRrvRBNjLun7zXLpVxXvP/V7RaqzlbBml5LfcEOAZFe8eA9RaVM+R4dd7QbU53I0dM9M4VPYgGPNnAceJbV2SLU0qUmpTaG36+3mdfFdF4H/d3/UziWfjOOUtP1JfuJJrDZQVEVkV8byKfd1F8R0b3fmyBDblYFINCaE/UzQt+bZDSqIgJh7YkDIY2PIoQs4F+YGf4QqP4eHoNuhkOCca6HgH6+tRkKfqHtzIDgRHkErpvySEkRX69UpDOi8w1mT8m/UVeSBbNrCgmUO1Xu9ydMMak+HccHIuIN6Z1AHInwFosD+12NsJGckLoSUcBjpNRDto8Qm0R2FxrBF5GwEItMxjrbsc67PeZkCiOuN2ZIeZ541srB1eKsKaYTPGxJl5a3F5CkAR6r9cPYoJM9hWbi8IG3q0EgLQBofv/SsslC1gDchKOKZDon2C9mQGlLhtjs06gjVX2+CGH6f/QFz6ZQz1giz2vk4c6ecBt400BWwhi+GxMhD4ycmRGnmyDxzMnC+qyxZ79pktGBJBWxhRCv8G/x+hINfjo362IibtUAA5mfyglLWn6KYLiTUXyUFtd4T+HDZhlUFbSMTnTzpCdO3sByLu4O0ArYliD7XPFI3BbQA9It5hFxdUWV6QgtqbTUKa0s0XLvTdzjHGxB
 F72ayl/M
 go+DkRHgd2JJw0B8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 05:46, Harry Yoo wrote:
> This is separated from the RFC version of "k[v]free_rcu() improvements"
> series [1], as these changes are relatively small and beneficial for BPF
> because it enables the bpf code to use kfree_rcu() instead of
> call_rcu() + kfree_nolock().
> 
> Patch 1 allows kfree() and kfree_rcu() to be used with objects that are
> allocated from kmalloc_nolock().
> 
> Patch 2 is a cleanup that frees a bit used to record whether obj_exts
> was allocated using kmalloc_nolock() or kmalloc(), since now both cases
> can be freed with kfree().
> 
> [1] https://lore.kernel.org/linux-mm/20260206093410.160622-1-harry.yoo@oracle.com

Thanks, added to slab/for-next

> v1 -> v2:
>   - Added Catalin's Reviewed-by tag on patch 1, and Alexei's Acked-by tag
>     on patch 2 that I forgot to add. Thanks!
> 
>   - Fix calling kfree() in free_slab_obj_exts() and alloc_slab_obj_exts()
>     when !allow_spin. Pass allow_spin parameter down to free_slab_obj_exts().
> 
> V1:  https://lore.kernel.org/linux-mm/20260209121013.50475-1-harry.yoo@oracle.com
> 
> Harry Yoo (2):
>   mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
>   mm/slab: drop the OBJEXTS_NOSPIN_ALLOC flag from enum objext_flags
> 
>  include/linux/memcontrol.h |  3 +--
>  include/linux/rcupdate.h   |  4 ++--
>  mm/kmemleak.c              | 22 ++++++++++-----------
>  mm/slub.c                  | 39 +++++++++++++++++++++++++++-----------
>  4 files changed, 41 insertions(+), 27 deletions(-)
> 
> 
> base-commit: f6ed7e47c1fc78e78c9bfeb668b1ad9ba5c58120


