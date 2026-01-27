Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF65BD2FEC2
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 17:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFB66B0089; Tue, 27 Jan 2026 12:06:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D266B008A; Tue, 27 Jan 2026 12:06:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B816B008C; Tue, 27 Jan 2026 12:06:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0267A6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:06:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9308E1A02F9
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:06:16 +0000 (UTC)
X-FDA: 84378371952.19.DD5B110
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id C14F9180007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:06:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iEmOrog+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IoV00OUV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iEmOrog+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IoV00OUV;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769533574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rEWW9ghmyHGzLgDvKacTV22NiBejhvtORksbA8GEow=;
	b=X1CPQoflHeMh0wxiOLh+8xJKp0LjnbxYzFPN08q60j8WkxQN0U2yOZeDZpwrWWGcMbjgK3
	2T5azb9O+pg9251wDFI14H0KGYHQKob4iy562Z3i57vr6+aHaiXWbsb2AukcAdNaxzX4e7
	FirvvDIQw8YZWjvceLCDMj2xjClud28=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iEmOrog+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IoV00OUV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iEmOrog+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IoV00OUV;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769533574; a=rsa-sha256;
	cv=none;
	b=YDCmm5fcCV1zd/6KBRwGUmEVSdxF8AXpBBFdwD97r+vioBrFUu7+lWA9bLSWWStMrg5ch/
	zPMNg/qr2UFkv0uSWW5nqvHu/ghxvgUBgWkF1jasfYbSocVhCiDh7CfEfnElJH9JwoVSiR
	Aoxbro8WQnJB/xFehrEWCTEF45YtIUI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5999E337D2;
	Tue, 27 Jan 2026 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769533572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7rEWW9ghmyHGzLgDvKacTV22NiBejhvtORksbA8GEow=;
	b=iEmOrog+fALfeyQlwXRe7MxHCQNuSNAXjOJ09Zr+iQQnWa7JpDIwkRc3BenjfCnGF/lmYv
	uoLERQVHk6PKtTHPp/2kvmaV0wbWYbdPls2+UVvSWT8R6XAdKs6sP64t6BmBWR9NMSyWJZ
	4xnjerhog6uASWsviIHMmcnZlp3tKNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769533572;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7rEWW9ghmyHGzLgDvKacTV22NiBejhvtORksbA8GEow=;
	b=IoV00OUVADsYvnSMIxh6MKlruPVlDctgnlVHIxas47XNUGD6Of1KClWR3a7/XqNnCX0kcm
	DYl1TxpBos7fe4Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769533572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7rEWW9ghmyHGzLgDvKacTV22NiBejhvtORksbA8GEow=;
	b=iEmOrog+fALfeyQlwXRe7MxHCQNuSNAXjOJ09Zr+iQQnWa7JpDIwkRc3BenjfCnGF/lmYv
	uoLERQVHk6PKtTHPp/2kvmaV0wbWYbdPls2+UVvSWT8R6XAdKs6sP64t6BmBWR9NMSyWJZ
	4xnjerhog6uASWsviIHMmcnZlp3tKNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769533572;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7rEWW9ghmyHGzLgDvKacTV22NiBejhvtORksbA8GEow=;
	b=IoV00OUVADsYvnSMIxh6MKlruPVlDctgnlVHIxas47XNUGD6Of1KClWR3a7/XqNnCX0kcm
	DYl1TxpBos7fe4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 352563EA61;
	Tue, 27 Jan 2026 17:06:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qiBrDITweGlTXQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 27 Jan 2026 17:06:12 +0000
Message-ID: <0409661a-4612-48e8-b394-ec21b744d17f@suse.cz>
Date: Tue, 27 Jan 2026 18:06:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 0/2] Only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable
 caches
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Hai Li <hao.li@linux.dev>, linux-mm@kvack.org
References: <20260127103151.21883-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260127103151.21883-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C14F9180007
X-Stat-Signature: ntaprbo4fmioyzx7rjwekzth8w4sd9t9
X-Rspam-User: 
X-HE-Tag: 1769533573-828517
X-HE-Meta: U2FsdGVkX1/HMSzJy5JdHEJzeK5lOFcaeGPmnh+IezgCXVfBrszP/kHBCb6AnUvRh7lKTm6n73Xv/S8swJGV4o8SsjJ9SLkQU6sALutgbme7hlFeLtNOONSbxrlFDFi2Bmon+eMuEByuExjTyLRrMdHAzxaUaTvlcLJbhu9YHc71FARb+xMJuicn+0vwwzan1wfL/0+W2u6hqERkrpzGU3MdA76EMg5TcLLETpnvTFI8JcYdu75WfyBtsKDHM0hhkb/MrBx75Y7HbWCnmxWsoJ+Bjnwz/W32O2hBqmPupIvKh00/f1BY935+Uln8ufGRXYAtaPN6rmhHdTgaDR2bAOPotSi5cl4dSPkYFYMl5UTIKb18WyD0S4MfDUeULYXm+GcNihvauCDJv/SODvbi9Dm3giAOLvh0+6PxUaerbm7iGRrezCupA1QsEQUXz6k6XARaaAg4W/2nTca5H+RGR0i+AbMp55L9/A59+Q5pr4BZqfMomFekHwmoy29hlBHkZHy/c6gik5lKNwrsrg/0/fwg2K4Kw0NLf8LTgS9fAbx9JgGcuCDOMZ5TQnD19hNVsJdIgvf+1NlbuOQEDgi9qVjhWq2D6ZwVPnbqFGGeG7yctXB3bDKJjUCkILLq6zdOOyXaixljofpZ0RCuCJmn4zzMWByI1WrMFpsyMSEec/viIYkm1ojg9w3VfD+jhNEGGMje74EGnQUHGDy86AHXW74Oxp/0yzzliwokEJs0vRjkv/O61X5KGDiuiF4BFde+G/GxV45n/rCWzDEJcHDAzyRDFyTROPcJhtqdC6fVP7t07w4IApzFdgQVTY7U151aY17fjPEQGifj2fgnrWfZloXeiRWZsDgWgrWHOduz20Mnom2ALdrpCTwZiUTBcWVy5sFn7NUnPoH8lJ0u072JFMAr9cDUu0bv77e8Z2Fod9Bu9w+HoR/pb+weXruCdLqsG1QfvUU6eKm/uP18sZ3
 CEuBcBTr
 BPd+eoPgLwgLHQYhJRhB8w4Mkyd9vA15i3z4mLrbGhrcyAI3nOaag1vARmw6prbmRRqfPTPFWxPKVrlGEcd7vR+oMTNZY9BRzbDNYcIj8R2IlPEfoTkfKoA0pmRE9fiG7dcdBagbr415l71FP9+9PCN96rVDJ/bOqhM7Ug+hDf6T9Nv0sKqhKXbUfLZwIQ6yaBR2o/QnOWXjFS9+hwxQU2kUdxdyrjM7s8u/Ut+ZiTJRkIvnqGaOWYuLbqtEoleni6ToqqD7TCVLrpkE6hVNTDeVK34Euxy3uWG8M4yhH47WstYAYS8nT2zyKw6muvFH+ldLJl8M+x1ysINw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 11:31, Harry Yoo wrote:
> While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
> slab objects, it prevents slab merging because merging can change
> the metadata layout.
> 
> As pointed out Vlastimil Babka, disabling merging solely for this memory
> optimization may not be a net win, because disabling slab merging tends
> to increase overall memory usage.
> 
> So let's take a conservative approach and restrict SLAB_OBJ_EXT_IN_OBJ
> to caches that are already unmergeable for other reasons.
> 
> Ideally this should be part of the slab/for-7.0/obj_metadata branch,
> but due to a conflict with slab/for-7.0/sheaves, I based it on
> slab/for-next (be36abd97e52).
> 
> Patch 1 factors out mergeability logic to slab_args_unmergeable().
> This is used to determine mergeability before the cache is created.
> 
> Patch 2 uses the new function to allow SLAB_OBJ_EXT_IN_OBJ
> only when merging is not allowed for other reasons.
> 
> Harry Yoo (2):
>   mm/slab: factor out slab_args_unmergeable()
>   mm/slab: only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable caches

Thanks, applied to slab/for-next and reorganized the sub-branches a bit to
prevent conflicts.

>  mm/slab.h        |  1 +
>  mm/slab_common.c | 27 +++++++++++++++++----------
>  mm/slub.c        |  3 ++-
>  3 files changed, 20 insertions(+), 11 deletions(-)
> 


